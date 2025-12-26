$PBExportHeader$w_71023_d.srw
$PBExportComments$마일리지 오류조회
forward
global type w_71023_d from w_com010_d
end type
type dw_member from datawindow within w_71023_d
end type
end forward

global type w_71023_d from w_com010_d
dw_member dw_member
end type
global w_71023_d w_71023_d

type variables
string is_jumin
DataWindowChild idw_area, idw_sale_type
end variables

on w_71023_d.create
int iCurrent
call super::create
this.dw_member=create dw_member
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_member
end on

on w_71023_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_member)
end on

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

is_jumin = dw_head.GetItemString(1, "jumin")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_jumin)
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

event pfc_preopen();call super::pfc_preopen;dw_member.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_71023_d
end type

type cb_delete from w_com010_d`cb_delete within w_71023_d
end type

type cb_insert from w_com010_d`cb_insert within w_71023_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_71023_d
end type

type cb_update from w_com010_d`cb_update within w_71023_d
end type

type cb_print from w_com010_d`cb_print within w_71023_d
end type

type cb_preview from w_com010_d`cb_preview within w_71023_d
end type

type gb_button from w_com010_d`gb_button within w_71023_d
end type

type cb_excel from w_com010_d`cb_excel within w_71023_d
end type

type dw_head from w_com010_d`dw_head within w_71023_d
integer height = 208
string dataobject = "d_71023_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_71023_d
integer beginy = 392
integer endy = 392
end type

type ln_2 from w_com010_d`ln_2 within w_71023_d
integer beginy = 396
integer endy = 396
end type

type dw_body from w_com010_d`dw_body within w_71023_d
integer y = 404
integer height = 1636
string dataobject = "d_71023_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;string   ls_jumin
long		ll_rows

ls_jumin = this.getitemstring(row,"jumin")

dw_member.Reset()

ll_rows = dw_member.retrieve(ls_jumin)

if  ll_rows > 0 then
	dw_member.visible = true
end if

end event

type dw_print from w_com010_d`dw_print within w_71023_d
integer x = 105
integer y = 764
end type

type dw_member from datawindow within w_71023_d
boolean visible = false
integer x = 5
integer y = 300
integer width = 4498
integer height = 2000
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "회원정보"
string dataobject = "d_member_info"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;this.GetChild("area", idw_area)
idw_area.SetTransObject(SQLCA)
idw_area.Retrieve("090")

this.GetChild("sale_type", idw_sale_type)
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.Retrieve("011")


end event

event doubleclicked;this.visible = false
end event

