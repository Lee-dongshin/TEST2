$PBExportHeader$w_61042_d.srw
$PBExportComments$판매현황
forward
global type w_61042_d from w_com010_d
end type
type cb_1 from commandbutton within w_61042_d
end type
type dw_99 from datawindow within w_61042_d
end type
type dw_body2 from datawindow within w_61042_d
end type
end forward

global type w_61042_d from w_com010_d
cb_1 cb_1
dw_99 dw_99
dw_body2 dw_body2
end type
global w_61042_d w_61042_d

type variables
String is_yymm, is_chk
end variables

on w_61042_d.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_99=create dw_99
this.dw_body2=create dw_body2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_99
this.Control[iCurrent+3]=this.dw_body2
end on

on w_61042_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_99)
destroy(this.dw_body2)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.09                                                  */	
/* 수정일      : 2002.05.09                                                  */
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

is_yymm = dw_head.GetItemstring(1, "yymm")




return true


end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.05.10                                                  */	
/* 수정일      : 2002.05.10                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_yymm)
IF il_rows > 0 THEN
   dw_body.SetFocus()
	cb_excel.Enabled = True
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
	cb_excel.Enabled = False
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
	cb_excel.Enabled = False
END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;is_chk = '1' 
dw_body.Object.DataWindow.HorizontalScrollSplit  = 10



end event

type cb_close from w_com010_d`cb_close within w_61042_d
integer taborder = 120
end type

type cb_delete from w_com010_d`cb_delete within w_61042_d
integer taborder = 60
end type

type cb_insert from w_com010_d`cb_insert within w_61042_d
integer taborder = 50
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61042_d
end type

type cb_update from w_com010_d`cb_update within w_61042_d
integer taborder = 100
end type

type cb_print from w_com010_d`cb_print within w_61042_d
boolean visible = false
integer taborder = 70
end type

type cb_preview from w_com010_d`cb_preview within w_61042_d
boolean visible = false
integer taborder = 80
end type

type gb_button from w_com010_d`gb_button within w_61042_d
end type

type cb_excel from w_com010_d`cb_excel within w_61042_d
integer taborder = 90
end type

type dw_head from w_com010_d`dw_head within w_61042_d
integer y = 152
integer height = 144
string dataobject = "d_61042_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_61042_d
integer beginy = 308
integer endy = 308
end type

type ln_2 from w_com010_d`ln_2 within w_61042_d
integer beginy = 312
integer endy = 312
end type

type dw_body from w_com010_d`dw_body within w_61042_d
integer x = 0
integer y = 324
integer width = 3566
integer height = 1672
integer taborder = 40
string dataobject = "d_61042_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.09                                                  */	
/* 수정일      : 2002.05.09                                                  */
/*===========================================================================*/

This.of_SetSort(False)







end event

type dw_print from w_com010_d`dw_print within w_61042_d
end type

type cb_1 from commandbutton within w_61042_d
boolean visible = false
integer x = 1586
integer y = 44
integer width = 347
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Compact"
end type

event clicked;
IF is_chk = '1' THEN 
	is_chk = '2'
	dw_body2.Visible = True
	dw_body.Visible  = False
ELSE
	is_chk = '1'
	dw_body.Visible  = True
	dw_body2.Visible = False
END IF

end event

type dw_99 from datawindow within w_61042_d
boolean visible = false
integer x = 2139
integer y = 284
integer width = 411
integer height = 432
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_61003_d99"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_body2 from datawindow within w_61042_d
boolean visible = false
integer y = 376
integer width = 3611
integer height = 1672
integer taborder = 30
string title = "none"
string dataobject = "d_61041_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

