$PBExportHeader$w_91022_e.srw
$PBExportComments$신체치수 관리
forward
global type w_91022_e from w_com010_e
end type
end forward

global type w_91022_e from w_com010_e
end type
global w_91022_e w_91022_e

type variables
string is_item, is_gubn, is_sojae, is_size
datawindowchild idw_item, idw_sojae

end variables

on w_91022_e.create
call super::create
end on

on w_91022_e.destroy
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

is_item  = dw_head.GetItemString(1, "item")
is_gubn  = dw_head.GetItemString(1, "gubn")
is_sojae = dw_head.GetItemString(1, "sojae")
is_size  = dw_head.GetItemString(1, "size")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_flag
long i

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_gubn = 'K' then 
	dw_body.dataobject = "d_91022_d01"
elseif is_gubn = 'A' then 
	dw_body.dataobject = "d_91022_d03"	
else
	dw_body.dataobject = "d_91022_d02"		
end if
dw_body.SetTransObject(SQLCA)
dw_body.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%')


dw_body.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%')


il_rows = dw_body.retrieve(is_item, is_gubn, is_sojae, is_size)
IF il_rows > 0 THEN
	for i = 1 to il_rows
		ls_flag = dw_body.getitemstring(i,"flag")
		if ls_flag = "New" then 
			dw_body.SetItemStatus(i, 0, Primary!, New!)
		end if
	next
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_update;call super::ue_update;/*===========================================================================*/
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

type cb_close from w_com010_e`cb_close within w_91022_e
end type

type cb_delete from w_com010_e`cb_delete within w_91022_e
end type

type cb_insert from w_com010_e`cb_insert within w_91022_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_91022_e
end type

type cb_update from w_com010_e`cb_update within w_91022_e
end type

type cb_print from w_com010_e`cb_print within w_91022_e
end type

type cb_preview from w_com010_e`cb_preview within w_91022_e
end type

type gb_button from w_com010_e`gb_button within w_91022_e
end type

type cb_excel from w_com010_e`cb_excel within w_91022_e
end type

type dw_head from w_com010_e`dw_head within w_91022_e
integer height = 132
string dataobject = "d_91022_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%')
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')


dw_head.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%')
end event

type ln_1 from w_com010_e`ln_1 within w_91022_e
integer beginy = 336
integer endy = 336
end type

type ln_2 from w_com010_e`ln_2 within w_91022_e
integer beginy = 340
integer endy = 340
end type

type dw_body from w_com010_e`dw_body within w_91022_e
integer y = 360
integer height = 1672
string dataobject = "d_91022_d01"
end type

event dw_body::constructor;call super::constructor;
This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%')


This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%')
end event

type dw_print from w_com010_e`dw_print within w_91022_e
integer x = 151
integer y = 680
string dataobject = "d_91022_r01"
end type

event dw_print::constructor;call super::constructor;This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%')
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')
end event

