$PBExportHeader$w_31005_d.srw
$PBExportComments$제품 입고 계획 현황
forward
global type w_31005_d from w_com010_d
end type
type cbx_1 from checkbox within w_31005_d
end type
end forward

global type w_31005_d from w_com010_d
integer width = 3675
integer height = 2276
cbx_1 cbx_1
end type
global w_31005_d w_31005_d

type variables
DataWindowChild idw_brand, idw_season, idw_make_type, idw_sojae, idw_country_cd, idw_jup_gubn, idw_item

String is_bill_dt, is_brand, is_year, is_season, is_make_type, is_sojae, is_country_cd, is_jup_gubn, is_cust_cd, is_style
string is_dlvy_fr, is_dlvy_to, is_out_seq, is_out_seq2, is_mis_gbn, is_reorder, is_chn_gbn, is_chn_exp, is_item







end variables

forward prototypes
public function integer wf_week_set ()
end prototypes

public function integer wf_week_set ();/* dw_body의 header에 요일 셋팅 */
String ls_week_kor, ls_column
Integer i = 0

Declare week_curs Cursor For
	SELECT WEEK_KOR +'(' + RIGHT(T_DATE,2) + ')' 
	  FROM TB_DATE
	 WHERE T_DATE BETWEEN :is_bill_dt AND CONVERT(VARCHAR(8), DATEADD(DD, 6, CAST(:is_bill_dt AS DATETIME)), 112) ;

Open week_curs;
   Fetch week_curs Into :ls_week_kor ;
	
	Do While SQLCA.SQLCODE = 0
		ls_column = "week_" + String(i) + "_t1.Text = ~'" + ls_week_kor + "~'"
		dw_body.Modify(ls_column)
		Fetch week_curs Into :ls_week_kor ;
		i++
	Loop
	
Close week_curs;

If i <> 7 Then Return -1

Return 0

end function

on w_31005_d.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
end on

on w_31005_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.10                                                  */	
/* 수정일      : 2001.12.10                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"bill_dt", string(ld_datetime,"yyyymmdd"))
//	dw_head.setitem(1,"dlvy_fr", string(ld_datetime,"yyyymm") + "01")
//	dw_head.SetItem(1,"dlvy_to", string(ld_datetime,'yyyymmdd'))
end if


end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.11                                                  */	
/* 수정일      : 2001.12.11                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if cbx_1.checked then

	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item, LeftA(is_bill_dt,6), is_make_type, is_country_cd, is_cust_cd, is_style, is_out_seq2, is_chn_gbn)
else

	il_rows = dw_body.retrieve(is_bill_dt, is_brand, is_year, is_season, is_sojae,is_item, is_country_cd, is_jup_gubn, is_make_type, is_cust_cd, is_style, is_dlvy_fr, is_dlvy_to, is_mis_gbn, is_reorder, is_chn_gbn, is_chn_exp)
end if

IF il_rows > 0 THEN
//	If wf_week_set() <> 0 Then MessageBox("조회오류", "요일 셋팅에 실패하였습니다.")
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.11                                                  */	
/* 수정일      : 2001.12.11                                                  */
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

is_bill_dt = dw_head.getitemstring(1,'bill_dt')
if IsNull(is_bill_dt) or Trim(is_bill_dt) = "" then
   MessageBox(ls_title,"기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("bill_dt")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season    = dw_head.GetItemString(1,"season")
is_sojae     = dw_head.GetItemString(1,"sojae")
is_item      = dw_head.GetItemString(1,"item")
is_country_cd= dw_head.GetItemString(1,"country_cd")
is_jup_gubn  = dw_head.GetItemString(1,"jup_gubn")
is_make_type = dw_head.GetItemString(1,"make_type")
is_cust_cd   = dw_head.GetItemString(1,"cust_cd")
is_style     = dw_head.GetItemString(1,"style")
is_dlvy_fr   = dw_head.GetitemString(1,"dlvy_fr")
is_dlvy_to   = dw_head.GetitemString(1,"dlvy_to")
is_out_seq   = dw_head.GetitemString(1,"out_seq")
is_out_seq2  = dw_head.GetitemString(1,"out_seq2")
is_mis_gbn   = dw_head.GetitemString(1,"mis_gbn")
is_reorder   = dw_head.GetitemString(1,"reorder")
is_chn_gbn   = dw_head.GetitemString(1,"chn_gbn")
is_chn_exp   = dw_head.GetitemString(1,"chn_exp")

return true

end event

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.11                                                  */	
/* 수정일      : 2001.12.11                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_column
Integer i

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

if cbx_1.checked then
	dw_print.object.t_brand.text = idw_brand.GetItemString(idw_brand.GetRow(), "inter_cd")
	dw_print.object.t_year.text = is_year
	dw_print.object.t_season.text = idw_season.GetItemString(idw_season.GetRow(), "inter_nm")
	dw_print.object.t_sojae.text = idw_sojae.GetItemString(idw_sojae.GetRow(), "inter_nm")
	dw_print.object.t_yymm.text = String(is_bill_dt, '@@@@/@@')
	dw_print.object.t_make_type.text = idw_make_type.GetItemString(idw_make_type.GetRow(), "inter_nm")
	dw_print.object.t_country_cd.text = idw_country_cd.GetItemString(idw_country_cd.GetRow(), "inter_nm")
	dw_print.object.t_cust_cd.text = dw_head.getitemstring(1,"cust_nm")
	dw_print.object.t_style.text = is_style
	dw_print.object.t_out_seq.text = dw_head.getitemstring(1,"out_seq2")	
else
		// dw_body의 요일을 가져와 dw_print에 셋팅
		For i = 0 To 6
			ls_column = ls_column + "week_" + String(i) + "_t1.Text = '" + dw_body.Describe("week_" + String(i) + "_t1.Text") + "'"
		Next
		
		ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
						"t_user_id.Text = '" + gs_user_id + "'" + &
						"t_datetime.Text = '" + ls_datetime + "'" + &
						"t_bill_dt.Text = '" + String(is_bill_dt, '@@@@/@@/@@') + "'" + &
						"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
						"t_year.Text = '" + is_year + "'" + &
						"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
						"t_make_type.Text = '" + idw_make_type.GetItemString(idw_make_type.GetRow(), "inter_display") + "'" + &
						"t_sojae.Text = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "inter_display") + "'" + &
						"t_country_cd.Text = '" + idw_country_cd.GetItemString(idw_country_cd.GetRow(), "inter_display") + "'" + &
						"t_jup_gubn.Text = '" + is_jup_gubn + "'" + &				
						ls_column
		
		dw_print.Modify(ls_modify)
		if is_reorder = 'Y' then 			dw_print.object.t_reorder.text = '리오다만'

		if is_chn_gbn = 'T' then
			dw_print.object.t_chn_gbn.text = '전체'
		elseif is_chn_gbn = 'K' then
			dw_print.object.t_chn_gbn.text = '국내'
		elseif is_chn_gbn = 'C' then
			dw_print.object.t_chn_gbn.text = '중국'
		end if
		
		
end if

		

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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_31005_d","0")
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation	 = 1
dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_body.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com010_d`cb_close within w_31005_d
end type

type cb_delete from w_com010_d`cb_delete within w_31005_d
end type

type cb_insert from w_com010_d`cb_insert within w_31005_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_31005_d
end type

type cb_update from w_com010_d`cb_update within w_31005_d
end type

type cb_print from w_com010_d`cb_print within w_31005_d
end type

type cb_preview from w_com010_d`cb_preview within w_31005_d
end type

type gb_button from w_com010_d`gb_button within w_31005_d
end type

type cb_excel from w_com010_d`cb_excel within w_31005_d
end type

type dw_head from w_com010_d`dw_head within w_31005_d
integer x = 27
integer y = 168
integer width = 4727
integer height = 280
string dataobject = "d_31005_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
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

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')


This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')
idw_country_cd.InsertRow(1)
idw_country_cd.SetItem(1, "inter_cd", '%')
idw_country_cd.SetItem(1, "inter_nm", '전체')


This.GetChild("make_type", idw_make_type)
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.InsertRow(1)
idw_make_type.SetItem(1, "inter_cd", '%')
idw_make_type.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	case "zip_yn"
		if data = "0" then 

				dw_body.dataobject = "d_31005_d01"
				dw_print.dataobject = "d_31005_r01"

				dw_body.SetTransObject(SQLCA)
				dw_print.SetTransObject(SQLCA)
		else
				dw_body.dataobject = "d_31005_d07"
				dw_print.dataobject = "d_31005_r07"			
				dw_body.SetTransObject(SQLCA)
				dw_print.SetTransObject(SQLCA)
		end if

	CASE "out_seq"      // dddw로 작성된 항목
		if data = "0" then 
			dw_body.dataobject = "d_31005_d01"
			dw_print.dataobject = "d_31005_r01"
		else
			dw_body.dataobject = "d_31005_d02"
			dw_print.dataobject = "d_31005_r02"			
		end if
		dw_body.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		

	CASE "brand", "year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1

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
		
		This.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', data)
		idw_sojae.insertrow(1)
		idw_sojae.Setitem(1, "sojae", "%")
		idw_sojae.Setitem(1, "sojae_nm", "전체")
		
		This.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve(data)
		idw_item.insertrow(1)
		idw_item.Setitem(1, "item", "%")
		idw_item.Setitem(1, "item_nm", "전체")		
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_31005_d
integer beginy = 464
integer endy = 464
end type

type ln_2 from w_com010_d`ln_2 within w_31005_d
integer beginy = 468
integer endy = 468
end type

type dw_body from w_com010_d`dw_body within w_31005_d
integer x = 0
integer y = 472
integer height = 1568
string dataobject = "d_31005_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_style
ls_style = this.GetItemString(row,'style_no')
if LenA(ls_style) >= 8 then gf_style_pic(ls_style,'%')
end event

type dw_print from w_com010_d`dw_print within w_31005_d
integer x = 46
integer y = 516
string dataobject = "d_31005_r01"
end type

type cbx_1 from checkbox within w_31005_d
integer x = 2062
integer y = 360
integer width = 297
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
string text = "달력보기"
boolean lefttext = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then 
	dw_body.dataobject = "d_31005_d03"
	dw_print.dataobject = "d_31005_r03"	
	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
	dw_head.object.out_seq2.visible = true
	dw_head.object.t_8.visible = true
else
	dw_body.dataobject = "d_31005_d01"
	dw_print.dataobject = "d_31005_r01"	
	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)	
	dw_head.object.out_seq2.visible = false
	dw_head.object.t_8.visible = false
end if	

dw_body.Object.DataWindow.Print.Orientation	 = 1
end event

