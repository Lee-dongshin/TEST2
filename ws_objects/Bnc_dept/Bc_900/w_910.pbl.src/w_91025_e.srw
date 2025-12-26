$PBExportHeader$w_91025_e.srw
$PBExportComments$세탁표시 관리
forward
global type w_91025_e from w_com020_e
end type
end forward

global type w_91025_e from w_com020_e
end type
global w_91025_e w_91025_e

on w_91025_e.create
call super::create
end on

on w_91025_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve()
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
	dw_list.insertrow(1)
	dw_list.setitem(1,"washing_type","%")
	dw_list.setitem(1,"washing_gubn","전 체")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

type cb_close from w_com020_e`cb_close within w_91025_e
end type

type cb_delete from w_com020_e`cb_delete within w_91025_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_91025_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_91025_e
end type

type cb_update from w_com020_e`cb_update within w_91025_e
end type

type cb_print from w_com020_e`cb_print within w_91025_e
end type

type cb_preview from w_com020_e`cb_preview within w_91025_e
end type

type gb_button from w_com020_e`gb_button within w_91025_e
end type

type cb_excel from w_com020_e`cb_excel within w_91025_e
end type

type dw_head from w_com020_e`dw_head within w_91025_e
integer height = 48
string dataobject = "d_91025_h01"
end type

type ln_1 from w_com020_e`ln_1 within w_91025_e
integer beginy = 216
integer endy = 216
end type

type ln_2 from w_com020_e`ln_2 within w_91025_e
integer beginy = 220
integer endy = 220
end type

type dw_list from w_com020_e`dw_list within w_91025_e
integer y = 244
integer width = 987
integer height = 1792
string dataobject = "d_91025_l01"
end type

event dw_list::clicked;call super::clicked;string ls_washing
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

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

ls_washing = This.GetItemString(row, 'washing_type') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(ls_washing) THEN return
il_rows = dw_body.retrieve(ls_washing)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_91025_e
integer x = 1042
integer y = 244
integer width = 2565
integer height = 1784
string dataobject = "d_91025_d01"
end type

type st_1 from w_com020_e`st_1 within w_91025_e
integer x = 1024
integer y = 244
integer height = 1792
end type

type dw_print from w_com020_e`dw_print within w_91025_e
integer x = 0
integer y = 912
end type

