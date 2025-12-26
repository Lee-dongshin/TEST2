$PBExportHeader$w_91018_e.srw
$PBExportComments$중국온앤온매장코드관리
forward
global type w_91018_e from w_com020_e
end type
end forward

global type w_91018_e from w_com020_e
end type
global w_91018_e w_91018_e

type variables
String is_new, is_shop_cd
end variables

on w_91018_e.create
call super::create
end on

on w_91018_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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

is_new = dw_head.GetItemString(1, "new")
if IsNull(is_new) or Trim(is_new) = "" then
   MessageBox(ls_title,"매장구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("new")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_new)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

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

type cb_close from w_com020_e`cb_close within w_91018_e
end type

type cb_delete from w_com020_e`cb_delete within w_91018_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_91018_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_91018_e
end type

type cb_update from w_com020_e`cb_update within w_91018_e
end type

type cb_print from w_com020_e`cb_print within w_91018_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_91018_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_91018_e
end type

type cb_excel from w_com020_e`cb_excel within w_91018_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_91018_e
integer y = 172
integer height = 144
string dataobject = "d_91018_h01"
end type

type ln_1 from w_com020_e`ln_1 within w_91018_e
integer beginy = 336
integer endy = 336
end type

type ln_2 from w_com020_e`ln_2 within w_91018_e
integer beginy = 340
integer endy = 340
end type

type dw_list from w_com020_e`dw_list within w_91018_e
integer x = 5
integer y = 348
integer width = 1111
integer height = 1688
string dataobject = "d_91018_d01"
end type

event dw_list::clicked;call super::clicked;

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_shop_cd = This.GetItemString(row, 'shop_cd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_shop_cd) THEN return
il_rows = dw_body.retrieve(is_shop_cd)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_91018_e
integer x = 1134
integer y = 348
integer width = 2459
integer height = 1688
string dataobject = "D_91018_D02"
end type

type st_1 from w_com020_e`st_1 within w_91018_e
integer x = 1120
integer y = 348
integer height = 1688
end type

type dw_print from w_com020_e`dw_print within w_91018_e
end type

