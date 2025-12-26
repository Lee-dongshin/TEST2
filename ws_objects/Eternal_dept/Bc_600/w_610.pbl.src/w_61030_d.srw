$PBExportHeader$w_61030_d.srw
$PBExportComments$자산/부채 현황
forward
global type w_61030_d from w_com010_d
end type
type dw_3 from datawindow within w_61030_d
end type
type dw_2 from datawindow within w_61030_d
end type
end forward

global type w_61030_d from w_com010_d
dw_3 dw_3
dw_2 dw_2
end type
global w_61030_d w_61030_d

type variables
string  is_yymm,   is_slip_bonji, is_sw1, is_sw2
datawindowchild idw_slip_bonji
end variables

on w_61030_d.create
int iCurrent
call super::create
this.dw_3=create dw_3
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_3
this.Control[iCurrent+2]=this.dw_2
end on

on w_61030_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_3)
destroy(this.dw_2)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_3, "ScaleToRight&Bottom")


/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymm, is_slip_bonji)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

is_sw1 = '0' 
is_sw2 = '0'

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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_slip_bonji = dw_head.GetItemString(1, "slip_bonji")
if IsNull(is_slip_bonji) or Trim(is_slip_bonji) = "" then
   MessageBox(ls_title,"사업장을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("slip_bonji")
   return false
end if
return true

end event

type cb_close from w_com010_d`cb_close within w_61030_d
end type

type cb_delete from w_com010_d`cb_delete within w_61030_d
end type

type cb_insert from w_com010_d`cb_insert within w_61030_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61030_d
end type

type cb_update from w_com010_d`cb_update within w_61030_d
end type

type cb_print from w_com010_d`cb_print within w_61030_d
end type

type cb_preview from w_com010_d`cb_preview within w_61030_d
end type

type gb_button from w_com010_d`gb_button within w_61030_d
end type

type cb_excel from w_com010_d`cb_excel within w_61030_d
end type

type dw_head from w_com010_d`dw_head within w_61030_d
integer height = 140
string dataobject = "d_61030_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("slip_bonji", idw_slip_bonji)
idw_slip_bonji.SetTransObject(SQLCA)
idw_slip_bonji.Retrieve('028')

end event

type ln_1 from w_com010_d`ln_1 within w_61030_d
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_d`ln_2 within w_61030_d
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_d`dw_body within w_61030_d
integer y = 344
integer height = 1676
string dataobject = "d_61030_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_acc_code
if row = 0 then return
	

ls_acc_code = this.getitemstring(row,"acc_code")
if ls_acc_code = '11301' then
	dw_3.visible = false
//	dw_2.visible = true
   if is_sw1 = '0' then  
		dw_2.retrieve(is_yymm,is_slip_bonji)
		is_sw1 = '1'
	end if
	dw_2.visible = true
elseif  ls_acc_code = '11303'   then
	dw_2.visible = false
//	dw_3.visible = true
	if is_sw2 = '0' then
		dw_3.retrieve(is_yymm,is_slip_bonji)
		is_sw2 = '1'
   end if
	dw_3.visible = true
end if		


end event

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(false)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_print from w_com010_d`dw_print within w_61030_d
integer y = 1244
integer width = 571
integer height = 600
boolean titlebar = true
string title = "채권현황표"
string dataobject = "d_61030_d01"
end type

type dw_3 from datawindow within w_61030_d
boolean visible = false
integer x = 9
integer y = 348
integer width = 2085
integer height = 1696
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "년도별 원단재고자산"
string dataobject = "d_61030_d03"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;	THIS.visible = FALSE
end event

type dw_2 from datawindow within w_61030_d
boolean visible = false
integer x = 32
integer y = 360
integer width = 2176
integer height = 1700
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "년도별 의류재고자산 "
string dataobject = "d_61030_d02"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;	THIS.visible = FALSE
end event

