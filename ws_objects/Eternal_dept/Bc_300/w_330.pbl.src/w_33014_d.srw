$PBExportHeader$w_33014_d.srw
$PBExportComments$거래처별 임가공 진도 현황
forward
global type w_33014_d from w_com010_d
end type
type st_1 from statictext within w_33014_d
end type
end forward

global type w_33014_d from w_com010_d
integer width = 3675
integer height = 2276
st_1 st_1
end type
global w_33014_d w_33014_d

type variables
string is_brand, is_year, is_season, is_yymmdd, is_cust_cd, is_class, is_make_type, is_opt , is_cust_nm
datawindowchild idw_brand, idw_season, idw_make_type
end variables

on w_33014_d.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_33014_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
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


is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_cust_cd = dw_head.Getitemstring(1,"cust_cd")
if IsNull(is_cust_cd) or Trim(is_cust_cd) = "" then
	is_cust_cd = '%'
end if


is_make_type = dw_head.Getitemstring(1,"make_type")
is_opt = dw_head.Getitemstring(1,"opt")
is_class = dw_head.Getitemstring(1,"class")
is_cust_nm = dw_head.Getitemstring(1,"cust_nm")

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
				if isnull(as_data) or LenA(as_data) = 0 then 
					return 0
				ElseIF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
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

il_rows = dw_body.retrieve(is_brand, '%','%', is_yymmdd, is_class, is_make_type, is_cust_cd, is_opt)
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
				 "t_yymmdd.Text = '" + is_yymmdd + "'" + &
				 "t_cust_cd.Text = '" + is_cust_cd + "'" + &
				 "t_cust_nm.Text = '" + is_cust_nm + "'" + &
				 "t_make_type.Text = '" + idw_make_type.GetItemString(idw_make_type.GetRow(), "inter_display") + "'"   
dw_print.Modify(ls_modify)



end event

event open;call super::open;dw_body.Object.DataWindow.HorizontalScrollSplit  = 560
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_1, "FixedToRight")
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_33014_d","0")
end event

type cb_close from w_com010_d`cb_close within w_33014_d
end type

type cb_delete from w_com010_d`cb_delete within w_33014_d
end type

type cb_insert from w_com010_d`cb_insert within w_33014_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_33014_d
end type

type cb_update from w_com010_d`cb_update within w_33014_d
end type

type cb_print from w_com010_d`cb_print within w_33014_d
end type

type cb_preview from w_com010_d`cb_preview within w_33014_d
end type

type gb_button from w_com010_d`gb_button within w_33014_d
end type

type cb_excel from w_com010_d`cb_excel within w_33014_d
end type

type dw_head from w_com010_d`dw_head within w_33014_d
integer x = 14
integer width = 3566
integer height = 204
string dataobject = "d_33014_h01"
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

This.GetChild("season", idw_season)
idw_season.SetTRansObject(SQLCA)
idw_season.Retrieve('003')
idw_season.insertrow(1)
idw_season.setitem(1,"inter_cd","%")
idw_season.setitem(1,"inter_nm","전체")


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
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_33014_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_d`ln_2 within w_33014_d
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_d`dw_body within w_33014_d
integer y = 404
integer height = 1636
string dataobject = "d_33014_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_33014_d
integer x = 114
integer y = 696
string dataobject = "d_33014_r01"
end type

type st_1 from statictext within w_33014_d
integer x = 3122
integer y = 316
integer width = 434
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 단위 : 천원"
boolean focusrectangle = false
end type

