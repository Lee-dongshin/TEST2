$PBExportHeader$w_91003_e.srw
$PBExportComments$품종 코드 관리
forward
global type w_91003_e from w_com010_e
end type
end forward

global type w_91003_e from w_com010_e
string title = "품종 코드 관리"
end type
global w_91003_e w_91003_e

type variables
string is_item, is_item_nm
end variables

on w_91003_e.create
call super::create
end on

on w_91003_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 지우 정보                                                   */	
/* 작성일      : 2001.11.16                                                  */	
/* 수정일      : 2001.11.16                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_item, is_item_nm)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 지우 정보                                                   */	
/* 작성일      : 2001.11.16                                                  */	
/* 수정일      : 2001.11.16                                                  */
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

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then is_item = '%'

is_item_nm = dw_head.GetItemString(1, "item_nm")
IF IsNull(is_item_nm) OR Trim(is_item_nm) = "" THEN is_item_nm = '%'

return true
end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : 재우 정보                                                   */	
/* 작성일      : 2001.11.16                                                  */	
/* 수정일      : 2001.11.16                                                  */
/*===========================================================================*/
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

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows
end event

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : 지우 정보                                                   */	
/* 작성일      : 2001.11.16                                                  */	
/* 수정일      : 2001.11.16                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

IF is_item = "%" THEN is_item = "전체"
IF is_item_nm = "%" THEN is_item_nm = "전체"

ls_modify =	"t_item.Text = '" + is_item + "'" + &
				"t_item_nm.Text = '" + is_item_nm + "'" + &
				"t_user_id.Text = '" + gs_user_id + "'" + &
				"t_datetime.Text = '" + ls_datetime + "'"
				
dw_print.Modify(ls_modify)

end event

type cb_close from w_com010_e`cb_close within w_91003_e
end type

type cb_delete from w_com010_e`cb_delete within w_91003_e
end type

type cb_insert from w_com010_e`cb_insert within w_91003_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_91003_e
end type

type cb_update from w_com010_e`cb_update within w_91003_e
end type

type cb_print from w_com010_e`cb_print within w_91003_e
end type

type cb_preview from w_com010_e`cb_preview within w_91003_e
end type

type gb_button from w_com010_e`gb_button within w_91003_e
end type

type cb_excel from w_com010_e`cb_excel within w_91003_e
end type

type dw_head from w_com010_e`dw_head within w_91003_e
integer height = 112
string dataobject = "d_91003_h01"
end type

type ln_1 from w_com010_e`ln_1 within w_91003_e
integer beginy = 304
integer endy = 304
end type

type ln_2 from w_com010_e`ln_2 within w_91003_e
integer beginx = -9
integer beginy = 308
integer endx = 3611
integer endy = 308
end type

type dw_body from w_com010_e`dw_body within w_91003_e
integer x = 14
integer y = 328
integer width = 3547
integer height = 1668
string dataobject = "d_91003_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우 정보                                                   */	
/* 작성일      : 2001.11.16                                                  */	
/* 수정일      : 2001.11.16                                                  */
/*===========================================================================*/

This.SetRowFocusIndicator(Hand!)
end event

type dw_print from w_com010_e`dw_print within w_91003_e
string dataobject = "d_91003_r01"
end type

