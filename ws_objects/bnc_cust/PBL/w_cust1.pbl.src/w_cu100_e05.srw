$PBExportHeader$w_cu100_e05.srw
$PBExportComments$생산의뢰관리(입고의뢰등록)
forward
global type w_cu100_e05 from w_com010_e
end type
end forward

global type w_cu100_e05 from w_com010_e
integer width = 3653
integer height = 2236
event type long ue_data_check ( )
end type
global w_cu100_e05 w_cu100_e05

type variables
string   is_input_req_ymd, is_input_req_time
end variables

event type long ue_data_check();long i, ll_input_req_qty
string ls_flag, ls_input_req_ymd, ls_input_req_time

for i = 1 to dw_body.rowcount()
	ls_flag = dw_body.getitemstring(i,"Flag")
	ll_input_req_qty = dw_body.getitemnumber(i,"input_req_qty")
	ls_input_req_ymd = dw_body.getitemstring(i,"input_req_ymd")
	ls_input_req_time = dw_body.getitemstring(i,"input_req_time")
	
	if ls_flag = "New" and ll_input_req_qty <> 0 then
		if isnull(ls_input_req_ymd) or LenA(ls_input_req_ymd) <> 8 then dw_body.setitem(i,"input_req_ymd",is_input_req_ymd)
		if isnull(ls_input_req_time) or LenA(ls_input_req_time) = 0 then dw_body.setitem(i,"input_req_time",is_input_req_time)
	end if
next
return i

end event

on w_cu100_e05.create
call super::create
end on

on w_cu100_e05.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime  ld_datetime

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

/* 시스템일자 보다 하루 다음 날자를 구한다 */
IF gf_add_date(ld_datetime,1,is_input_req_ymd) = FALSE THEN
	Return 0
END IF

 dw_head.SetItem(1, "input_req_ymd", is_input_req_ymd)	
 dw_head.SetItem(1, "input_req_time", '10시')	
trigger event ue_retrieve()
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                       */	
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

is_input_req_ymd = dw_head.GetItemString(1, "input_req_ymd")
if IsNull(is_input_req_ymd) or Trim(is_input_req_ymd) = "" then
   MessageBox(ls_title,"입고예정 일자를 입력하세요! ")
   dw_head.SetFocus()
   dw_head.SetColumn("input_req_ymd")
   return false
end if

is_input_req_time = dw_head.GetItemString(1, "input_req_time")
if IsNull(is_input_req_time) or Trim(is_input_req_time) = "" then
   MessageBox(ls_title,"입고예정 시간을 입력하세요! ")
   dw_head.SetFocus()
   dw_head.SetColumn("input_req_time")
   return false
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string is_flag
long i

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(gs_shop_cd, gs_style, gs_chno)

IF il_rows > 0 THEN
   dw_body.SetFocus()
	for i = 1 to il_rows
		is_flag = dw_body.getitemstring(i,"flag")
		if is_flag = "New"  then dw_body.SetItemStatus(i, 0, Primary!, New!)
	next 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

trigger event ue_data_check()

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

type cb_close from w_com010_e`cb_close within w_cu100_e05
end type

type cb_delete from w_com010_e`cb_delete within w_cu100_e05
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_cu100_e05
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_cu100_e05
end type

type cb_update from w_com010_e`cb_update within w_cu100_e05
end type

type cb_print from w_com010_e`cb_print within w_cu100_e05
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_cu100_e05
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_cu100_e05
integer width = 3593
end type

type dw_head from w_com010_e`dw_head within w_cu100_e05
integer y = 188
integer width = 3557
integer height = 136
string dataobject = "D_CU100_H03"
end type

type ln_1 from w_com010_e`ln_1 within w_cu100_e05
integer beginy = 364
integer endx = 3616
integer endy = 364
end type

type ln_2 from w_com010_e`ln_2 within w_cu100_e05
integer beginy = 368
integer endx = 3616
integer endy = 368
end type

type dw_body from w_com010_e`dw_body within w_cu100_e05
integer y = 380
integer width = 3602
integer height = 1668
string dataobject = "d_cu100_d05"
end type

event dw_body::constructor;call super::constructor;This.inv_sort.of_SetColumnHeader(false)
end event

type dw_print from w_com010_e`dw_print within w_cu100_e05
end type

