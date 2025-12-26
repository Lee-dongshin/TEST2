$PBExportHeader$w_12030_d.srw
$PBExportComments$아이템별 원자재 배분
forward
global type w_12030_d from w_com010_d
end type
type dw_1 from datawindow within w_12030_d
end type
end forward

global type w_12030_d from w_com010_d
integer width = 3689
integer height = 2244
dw_1 dw_1
end type
global w_12030_d w_12030_d

type variables
decimal is_stock_qty
decimal is_req_qty_1, is_req_qty_2, is_req_qty_3, is_req_qty_4, is_req_qty_5
decimal is_req_pos_1, is_req_pos_2, is_req_pos_3, is_req_pos_4, is_req_pos_5

end variables

on w_12030_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_12030_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
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

IF dw_body.AcceptText() <> 1 THEN RETURN FALSE
IF dw_1.AcceptText() <> 1 THEN RETURN FALSE

if as_cb_div = '4' then
	is_stock_qty = dw_1.GetItemnumber(1, "stock_yd")
	is_req_qty_1 = dw_1.GetItemnumber(1, "req_qty_1")
	is_req_qty_2 = dw_1.GetItemnumber(1, "req_qty_2")
	is_req_qty_3 = dw_1.GetItemnumber(1, "req_qty_3")
	is_req_qty_4 = dw_1.GetItemnumber(1, "req_qty_4")
	is_req_qty_5 = dw_1.GetItemnumber(1, "req_qty_5")
	
	is_req_pos_1 = dw_1.GetItemnumber(1, "req_pos_1")
	is_req_pos_2 = dw_1.GetItemnumber(1, "req_pos_2")
	is_req_pos_3 = dw_1.GetItemnumber(1, "req_pos_3")
	is_req_pos_4 = dw_1.GetItemnumber(1, "req_pos_4")
	is_req_pos_5 = dw_1.GetItemnumber(1, "req_pos_5")
	
else	
	is_stock_qty = dw_body.GetItemnumber(1, "stock_yd")
	is_req_qty_1 = dw_body.GetItemnumber(1, "req_qty_1")
	is_req_qty_2 = dw_body.GetItemnumber(1, "req_qty_2")
	is_req_qty_3 = dw_body.GetItemnumber(1, "req_qty_3")
	is_req_qty_4 = dw_body.GetItemnumber(1, "req_qty_4")
	is_req_qty_5 = dw_body.GetItemnumber(1, "req_qty_5")
	
	is_req_pos_1 = dw_body.GetItemnumber(1, "req_pos_1")
	is_req_pos_2 = dw_body.GetItemnumber(1, "req_pos_2")
	is_req_pos_3 = dw_body.GetItemnumber(1, "req_pos_3")
	is_req_pos_4 = dw_body.GetItemnumber(1, "req_pos_4")
	is_req_pos_5 = dw_body.GetItemnumber(1, "req_pos_5")
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('4') = FALSE THEN RETURN
//messagebox("stock_qty", string(is_stock_qty))
//messagebox("req_pos_1", string(is_req_pos_1))
il_rows = dw_1.retrieve(is_stock_qty, is_req_qty_1, is_req_qty_2, is_req_qty_3, is_req_qty_4, is_req_qty_5, + &
									is_req_pos_1, is_req_pos_2, is_req_pos_3, is_req_pos_4, is_req_pos_5)
									
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//messagebox("stock_qty", string(is_stock_qty))
//messagebox("req_pos_1", string(is_req_pos_1))
il_rows = dw_body.retrieve(is_stock_qty, is_req_qty_1, is_req_qty_2, is_req_qty_3, is_req_qty_4, is_req_qty_5, + &
									is_req_pos_1, is_req_pos_2, is_req_pos_3, is_req_pos_4, is_req_pos_5)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)


dw_1.insertrow(0)
dw_body.insertrow(0)
dw_1.setfocus()
end event

event ue_button(integer ai_cb_div, long al_rows);//
end event

type cb_close from w_com010_d`cb_close within w_12030_d
end type

type cb_delete from w_com010_d`cb_delete within w_12030_d
end type

type cb_insert from w_com010_d`cb_insert within w_12030_d
boolean enabled = false
end type

event cb_insert::clicked;call super::clicked;dw_body.insertrow(0)
end event

type cb_retrieve from w_com010_d`cb_retrieve within w_12030_d
end type

type cb_update from w_com010_d`cb_update within w_12030_d
end type

type cb_print from w_com010_d`cb_print within w_12030_d
end type

type cb_preview from w_com010_d`cb_preview within w_12030_d
end type

type gb_button from w_com010_d`gb_button within w_12030_d
end type

type cb_excel from w_com010_d`cb_excel within w_12030_d
end type

type dw_head from w_com010_d`dw_head within w_12030_d
integer height = 52
end type

type ln_1 from w_com010_d`ln_1 within w_12030_d
integer beginy = 244
integer endy = 244
end type

type ln_2 from w_com010_d`ln_2 within w_12030_d
integer beginy = 248
integer endy = 248
end type

type dw_body from w_com010_d`dw_body within w_12030_d
event ue_keydown pbm_dwnkey
integer x = 18
integer y = 1232
integer height = 776
string dataobject = "d_12030_d01"
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)                                       */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		return 1
	CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

type dw_print from w_com010_d`dw_print within w_12030_d
integer x = 1431
integer y = 1120
end type

type dw_1 from datawindow within w_12030_d
event ue_keydown pbm_keydown
integer x = 18
integer y = 260
integer width = 3589
integer height = 964
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_12030_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)                                       */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		return 1
	CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

