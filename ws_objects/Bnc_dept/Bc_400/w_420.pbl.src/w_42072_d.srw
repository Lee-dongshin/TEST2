$PBExportHeader$w_42072_d.srw
$PBExportComments$BOX반품관리조회
forward
global type w_42072_d from w_com010_d
end type
type st_1 from statictext within w_42072_d
end type
type st_2 from statictext within w_42072_d
end type
end forward

global type w_42072_d from w_com010_d
string title = "BOX 반품 집계"
st_1 st_1
st_2 st_2
end type
global w_42072_d w_42072_d

type variables
DataWindowChild idw_brand, idw_othr_brand, idw_out_no, idw_mng_cust

String is_brand, is_out_no, is_out_date, is_frm_yymmdd, is_to_yymmdd, is_mng_cust, is_opt_gubn
STRING IS_EXCEPT_GUBN, is_print_opt
end variables

on w_42072_d.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
end on

on w_42072_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
end on

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_yymmdd",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "to_yymmdd",string(ld_datetime, "yyyymmdd"))
idw_mng_cust.SetRow(2)

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_opt_gubn = "A" then 
	dw_body.DataObject = "d_42072_d01"
	dw_body.SetTransObject(SQLCA)
elseIF is_opt_gubn = "B" then 
	dw_body.DataObject = "d_42072_d02"
	dw_body.SetTransObject(SQLCA)
else	
	dw_body.DataObject = "d_42072_d03"
	dw_body.SetTransObject(SQLCA)	
end if	

il_rows = dw_body.retrieve(is_brand, is_frm_yymmdd, is_to_yymmdd, is_mng_cust, IS_EXCEPT_GUBN)


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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_title

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

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	


is_frm_yymmdd = dw_head.GetItemString(1, "frm_yymmdd")
if IsNull(is_frm_yymmdd) or Trim(is_frm_yymmdd) = "" then
   MessageBox(ls_title,"시작일자 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_yymmdd")
   return false
end if

is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
   MessageBox(ls_title,"마지막일자 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if

is_mng_cust = dw_head.GetItemString(1, "mng_cust")
if IsNull(is_mng_cust) or Trim(is_mng_cust) = "" then
   MessageBox(ls_title,"운송업체 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("mng_cust")
   return false
end if


is_opt_gubn = dw_head.GetItemString(1, "opt_gubn")
if IsNull(is_opt_gubn) or Trim(is_opt_gubn) = "" then
   MessageBox(ls_title,"조회기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_gubn")
   return false
end if


is_EXCEPT_GUBN = dw_head.GetItemString(1, "EXCEPT_GUBN")
if IsNull(is_EXCEPT_GUBN) or Trim(is_EXCEPT_GUBN) = "" then
   MessageBox(ls_title,"업체제외여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("EXCEPT_GUBN")
   return false
end if

is_print_opt = dw_head.GetItemString(1, "print_opt")
if IsNull(is_print_opt) or Trim(is_print_opt) = "" then
   MessageBox(ls_title,"인쇄구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("print_opt")
   return false
end if


return true

end event

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_yearseason

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_frm_yymmdd.Text = '" + String(is_frm_yymmdd, '@@@@/@@/@@') + "'" + &										
				"t_to_yymmdd.Text = '" + String(is_to_yymmdd, '@@@@/@@/@@') + "'" + &														
				"t_mng_cust.Text = '" + idw_mng_cust.GetItemString(idw_mng_cust.GetRow(), "inter_display") + "'"  

dw_print.Modify(ls_modify)

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_yearseason
long ll_row

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_print_opt = "N" then
	
	if is_opt_gubn = "A" then 
		dw_print.DataObject = "d_42072_r01"
		dw_print.SetTransObject(SQLCA)
	elseIF is_opt_gubn = "B" then 	
		dw_print.DataObject = "d_42072_r02"
		dw_print.SetTransObject(SQLCA)
	else	
		dw_print.DataObject = "d_42072_r03"
		dw_print.SetTransObject(SQLCA)
	end if		
	
	This.Trigger Event ue_title()
	dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로
	
	dw_body.ShareData(dw_print)

	
else
		dw_print.DataObject = "d_42072_r11"
		dw_print.SetTransObject(SQLCA)		

		ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
		
		ls_modify =	"t_yymmdd.Text = '" + String(is_frm_yymmdd, '@@@@/@@/@@') + "'" + &														
						"t_mng_cust.Text = '" + idw_mng_cust.GetItemString(idw_mng_cust.GetRow(), "inter_display") + "'"  		
		dw_print.Modify(ls_modify)
	
	dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로
//	dw_print.Object.DataWindow.Zoom = 78
	dw_print.retrieve(is_frm_yymmdd, is_frm_yymmdd, is_mng_cust, is_except_gubn)

		
		
end if		

dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();
datetime ld_datetime
string ls_modify, ls_datetime, ls_yearseason
long ll_row

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_print_opt = "N" then
	
	if is_opt_gubn = "A" then 
		dw_print.DataObject = "d_42034_r01"
		dw_print.SetTransObject(SQLCA)
	elseIF is_opt_gubn = "B" then 	
		dw_print.DataObject = "d_42034_r02"
		dw_print.SetTransObject(SQLCA)
	else	
		dw_print.DataObject = "d_42034_r03"
		dw_print.SetTransObject(SQLCA)
	end if		
	
	This.Trigger Event ue_title()
	dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로
	
	dw_body.ShareData(dw_print)
	
	IF dw_print.RowCount() = 0 Then
		MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
		il_rows = 0
	ELSE
		il_rows = dw_print.Print()
	END IF	
	
else
		dw_print.DataObject = "d_42034_r11"
		dw_print.SetTransObject(SQLCA)		

		ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
		
		ls_modify =	"t_yymmdd.Text = '" + String(is_frm_yymmdd, '@@@@/@@/@@') + "'" + &														
						"t_mng_cust.Text = '" + idw_mng_cust.GetItemString(idw_mng_cust.GetRow(), "inter_display") + "'"  		
		dw_print.Modify(ls_modify)
	
	dw_print.retrieve(is_frm_yymmdd, is_frm_yymmdd, is_mng_cust, is_except_gubn)
	dw_print.Object.DataWindow.Zoom = 78
	
	IF dw_print.RowCount() = 0 Then
		MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
		il_rows = 0
	ELSE
		il_rows = dw_print.Print()
	END IF	
		
		
end if		


This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42072_d","0")
end event

type cb_close from w_com010_d`cb_close within w_42072_d
end type

type cb_delete from w_com010_d`cb_delete within w_42072_d
end type

type cb_insert from w_com010_d`cb_insert within w_42072_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42072_d
end type

type cb_update from w_com010_d`cb_update within w_42072_d
end type

type cb_print from w_com010_d`cb_print within w_42072_d
end type

type cb_preview from w_com010_d`cb_preview within w_42072_d
end type

type gb_button from w_com010_d`gb_button within w_42072_d
end type

type cb_excel from w_com010_d`cb_excel within w_42072_d
end type

type dw_head from w_com010_d`dw_head within w_42072_d
integer x = 18
integer y = 160
integer width = 3506
integer height = 216
string dataobject = "d_42072_h01"
end type

event dw_head::constructor;datetime ld_datetime

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("mng_cust", idw_mng_cust)
idw_mng_cust.SetTransObject(SQLCA)
idw_mng_cust.Retrieve('404')


// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if
end event

type ln_1 from w_com010_d`ln_1 within w_42072_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_d`ln_2 within w_42072_d
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_d`dw_body within w_42072_d
integer x = 9
integer y = 392
integer width = 3561
integer height = 1612
string dataobject = "d_42072_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_42072_d
integer x = 2368
integer y = 1068
string dataobject = "d_42072_r01"
end type

type st_1 from statictext within w_42072_d
boolean visible = false
integer x = 2757
integer y = 256
integer width = 1193
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 배송의뢰서는 반품일자 "
boolean focusrectangle = false
end type

type st_2 from statictext within w_42072_d
boolean visible = false
integer x = 2848
integer y = 308
integer width = 553
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "시작일 기준입니다."
boolean focusrectangle = false
end type

