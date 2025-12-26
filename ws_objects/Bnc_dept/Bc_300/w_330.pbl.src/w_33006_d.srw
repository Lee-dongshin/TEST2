$PBExportHeader$w_33006_d.srw
$PBExportComments$년월 임가공 집계 현황
forward
global type w_33006_d from w_com010_d
end type
type rb_1 from radiobutton within w_33006_d
end type
type rb_2 from radiobutton within w_33006_d
end type
type gb_1 from groupbox within w_33006_d
end type
end forward

global type w_33006_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_33006_d w_33006_d

type variables
string is_brand, is_year, is_season, is_cust_cd, is_cust_nm, is_make_type, is_fr_yymmdd, is_to_yymmdd
datawindowchild idw_brand, idw_season, idw_make_type
end variables

on w_33006_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.gb_1
end on

on w_33006_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : ue_keycheck                                                 */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

IF as_cb_div = '1' THEN
	ls_title = "조회오류"
ELSEIF as_cb_div = '2' THEN
	ls_title = "추가오류"
ELSEIF as_cb_div = '3' THEN
	ls_title = "저장오류"
ELSE
	ls_title = "오류"
END IF

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = dw_head.GetItemString(1, "year")


is_season = dw_head.GetItemString(1, "season")
is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")



is_cust_cd = dw_head.Getitemstring(1,"cust_cd")


is_cust_nm = dw_head.Getitemstring(1,"cust_nm")
if IsNull(is_cust_nm) or Trim(is_cust_nm) = "" then
	is_cust_nm = '전체'
end if 
is_make_type = dw_head.Getitemstring(1,"make_type")


return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 종호)                                      */	
/* 작성일      : 2001.12.04                                                  */	
/* 수정일      : 2001.12.04                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/

string     ls_cust_cd, ls_cust_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"							// 거래처 코드
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
					dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF
				
			END IF   
			
			   gst_cd.ai_div          = ai_div	// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "거래처 코드 검색" 
				gst_cd.datawindow_nm   = "d_com911" 
				gst_cd.default_where   = " WHERE Cust_Code Between '5000' And '9999' "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " CustCode LIKE ~'" + as_data + "%~' "
				ELSE
					gst_cd.Item_where = ""
				END IF

				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm
					dw_head.SetRow(al_row)
					dw_head.SetColumn(as_column)
					dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"CustCode"))
					dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"Cust_sName"))
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("rmk")
					ib_itemchanged = False
					lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : ue_retrieve                                                 */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_make_type, is_cust_cd, is_fr_yymmdd, is_to_yymmdd)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	 "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
				 "t_cust_cd.Text = '" + is_cust_cd + "'" + &
				 "t_cust_nm.Text = '" + is_cust_nm + "'" + &
				 "t_make_type.Text = '" + idw_make_type.GetItemString(idw_make_type.GetRow(), "inter_display") + "'"   
dw_print.Modify(ls_modify)

dw_print.object.t_yymmdd.text = is_fr_yymmdd+' - '+is_to_yymmdd

end event

event open;call super::open;dw_body.Object.DataWindow.HorizontalScrollSplit  = 680


datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymmdd",LeftA(string(ld_datetime,"yyyymmdd"),6)+'01')
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_33006_d","0")
end event

type cb_close from w_com010_d`cb_close within w_33006_d
end type

type cb_delete from w_com010_d`cb_delete within w_33006_d
end type

type cb_insert from w_com010_d`cb_insert within w_33006_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_33006_d
end type

type cb_update from w_com010_d`cb_update within w_33006_d
end type

type cb_print from w_com010_d`cb_print within w_33006_d
end type

type cb_preview from w_com010_d`cb_preview within w_33006_d
end type

type gb_button from w_com010_d`gb_button within w_33006_d
end type

type cb_excel from w_com010_d`cb_excel within w_33006_d
end type

type dw_head from w_com010_d`dw_head within w_33006_d
integer x = 1024
integer y = 160
integer width = 2533
integer height = 240
string dataobject = "d_33006_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : constructor(dw_head)                                        */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")


This.GetChild("make_type", idw_make_type)
idw_make_type.SetTRansObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.insertrow(1)
idw_make_type.Setitem(1, "inter_cd", "%")
idw_make_type.Setitem(1, "inter_nm", "전체")

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : itemchanged(dw_head)                                        */
/*===========================================================================*/
CHOOSE CASE dwo.name
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "brand", "year"		
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")
			
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_33006_d
integer beginy = 404
integer endy = 404
end type

type ln_2 from w_com010_d`ln_2 within w_33006_d
integer beginy = 408
integer endy = 408
end type

type dw_body from w_com010_d`dw_body within w_33006_d
integer y = 420
integer height = 1620
string dataobject = "d_33006_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_33006_d
integer x = 114
integer y = 696
string dataobject = "d_33006_r02"
end type

type rb_1 from radiobutton within w_33006_d
integer x = 105
integer y = 200
integer width = 823
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "월별/협력업체별 현황"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_2.TextColor = RGB(0, 0, 0)

dw_body.DataObject = 'd_33006_d01'
dw_body.SetTransObject(SQLCA)

dw_print.DataObject = 'd_33006_r01'
dw_print.SetTransObject(SQLCA)

dw_body.Object.DataWindow.HorizontalScrollSplit  = 680

cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)



end event

type rb_2 from radiobutton within w_33006_d
integer x = 105
integer y = 276
integer width = 823
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "월별/형태별 현황"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_1.TextColor = RGB(0, 0, 0)
This.TextColor = RGB(0, 0, 255)

dw_body.DataObject = 'd_33006_d02'
dw_body.SetTransObject(SQLCA)

dw_print.DataObject = 'd_33006_r02'
dw_print.SetTransObject(SQLCA)

dw_body.Object.DataWindow.HorizontalScrollSplit  = 500

cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)



end event

type gb_1 from groupbox within w_33006_d
integer x = 46
integer y = 144
integer width = 942
integer height = 240
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

