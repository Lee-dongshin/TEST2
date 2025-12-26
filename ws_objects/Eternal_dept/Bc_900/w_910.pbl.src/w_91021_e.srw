$PBExportHeader$w_91021_e.srw
$PBExportComments$부서코드 관리
forward
global type w_91021_e from w_com010_e
end type
end forward

global type w_91021_e from w_com010_e
end type
global w_91021_e w_91021_e

type variables
string is_slip_bonji
datawindowchild idw_slip_bonji
end variables

on w_91021_e.create
call super::create
end on

on w_91021_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

is_slip_bonji = dw_head.GetItemString(1,"slip_bonji")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_slip_bonji)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

//FOR i=1 TO ll_row_count
//   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
//   IF idw_status = NewModified! THEN				/* New Record */
//      dw_body.Setitem(i, "reg_id", gs_user_id)
//   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
//      dw_body.Setitem(i, "mod_id", gs_user_id)
//      dw_body.Setitem(i, "mod_dt", ld_datetime)
//   END IF
//NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

type cb_close from w_com010_e`cb_close within w_91021_e
end type

type cb_delete from w_com010_e`cb_delete within w_91021_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_91021_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_91021_e
end type

type cb_update from w_com010_e`cb_update within w_91021_e
end type

type cb_print from w_com010_e`cb_print within w_91021_e
end type

type cb_preview from w_com010_e`cb_preview within w_91021_e
end type

type gb_button from w_com010_e`gb_button within w_91021_e
end type

type cb_excel from w_com010_e`cb_excel within w_91021_e
end type

type dw_head from w_com010_e`dw_head within w_91021_e
integer y = 164
integer height = 148
string dataobject = "d_91021_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("slip_bonji", idw_slip_bonji)
idw_slip_bonji.SetTransObject(SQLCA)
idw_slip_bonji.Retrieve('028')
end event

type ln_1 from w_com010_e`ln_1 within w_91021_e
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_e`ln_2 within w_91021_e
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_e`dw_body within w_91021_e
integer y = 348
integer height = 1692
string dataobject = "d_91021_d01"
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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
		Return 1
//	CASE KeyDownArrow!
//		IF This.GetRow() = This.RowCount() THEN
//		   This.InsertRow(This.GetRow() + 1)
//		END IF
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

event dw_body::constructor;call super::constructor;datawindowchild ldw_child
This.GetChild("grp_cd1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('005')
ldw_child.insertrow(0)
ldw_child.SetItem(0, "inter_cd", '')
ldw_child.SetItem(0, "inter_nm", '')
end event

type dw_print from w_com010_e`dw_print within w_91021_e
string dataobject = "d_91021_r01"
end type

