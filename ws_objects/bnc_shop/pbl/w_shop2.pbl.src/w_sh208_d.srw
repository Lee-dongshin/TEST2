$PBExportHeader$w_sh208_d.srw
$PBExportComments$상품권회수조회
forward
global type w_sh208_d from w_com010_d
end type
end forward

global type w_sh208_d from w_com010_d
integer width = 2990
integer height = 2084
end type
global w_sh208_d w_sh208_d

type variables
string  is_from_date , is_to_date, is_jumin, is_event_id
DataWindowChild idw_sale_type, idw_event_id
end variables

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                              */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

//is_from_date = dw_head.GetItemString(1, "from_date")
//if IsNull(is_from_date) or Trim(is_from_date) = "" then
//   MessageBox(ls_title,"from일자를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("from_date")
//   return false
//end if

is_event_id = dw_head.GetItemString(1, "event_id")
if IsNull(is_event_id) or Trim(is_event_id) = "" then
   MessageBox(ls_title,"행사를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("event_id")
   return false
end if

is_jumin = dw_head.GetItemString(1, "jumin")
if IsNull(is_jumin) or Trim(is_jumin) = "" then
   is_jumin = '%'
end if

return true
end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                  */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(gs_brand, is_event_id, gs_shop_cd, is_jumin)
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

on w_sh208_d.create
call super::create
end on

on w_sh208_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type cb_close from w_com010_d`cb_close within w_sh208_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh208_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh208_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh208_d
end type

type cb_update from w_com010_d`cb_update within w_sh208_d
end type

type cb_print from w_com010_d`cb_print within w_sh208_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_sh208_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_sh208_d
end type

type dw_head from w_com010_d`dw_head within w_sh208_d
integer y = 152
integer height = 176
string dataobject = "d_sh208_h01"
end type

event dw_head::constructor;This.GetChild("event_id", idw_event_id)
idw_event_id.SetTransObject(SQLCA)
idw_event_id.Retrieve(gs_brand)

end event

type ln_1 from w_com010_d`ln_1 within w_sh208_d
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_d`ln_2 within w_sh208_d
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_d`dw_body within w_sh208_d
integer y = 368
integer height = 1468
string dataobject = "d_sh208_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;This.GetChild("sale_type", idw_sale_type)
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.Retrieve('011')

end event

type dw_print from w_com010_d`dw_print within w_sh208_d
end type

