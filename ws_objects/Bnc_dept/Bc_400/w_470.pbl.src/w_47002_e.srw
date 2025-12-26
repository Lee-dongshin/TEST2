$PBExportHeader$w_47002_e.srw
$PBExportComments$주문출고관리
forward
global type w_47002_e from w_com010_e
end type
end forward

global type w_47002_e from w_com010_e
end type
global w_47002_e w_47002_e

type variables
datawindowchild idw_proc_stat, idw_color
String is_order_ymd, is_shop_cd, is_order_no, is_order_name, is_order_mobile, is_proc_stat, is_fr_ymd, is_to_ymd, is_gubn
end variables

on w_47002_e.create
call super::create
end on

on w_47002_e.destroy
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

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"주문일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"주문일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


is_shop_cd = dw_head.GetItemString(1, "shoP_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
 is_shop_cd = "%"
end if

is_order_no = dw_head.GetItemString(1, "order_no")
if IsNull(is_order_no) or Trim(is_order_no) = "" then
 is_order_no = "%"
end if

is_order_name = dw_head.GetItemString(1, "order_name")
if IsNull(is_order_no) or Trim(is_order_no) = "" then
 is_order_no = "%"
end if

is_order_mobile = dw_head.GetItemString(1, "order_mobile")
if IsNull(is_order_mobile) or Trim(is_order_mobile) = "" then
 is_order_mobile = "%"
end if

is_proc_stat = dw_head.GetItemString(1, "proc_stat")
if IsNull(is_proc_stat) or Trim(is_proc_stat) = "" then
   MessageBox(ls_title,"주문처리내역을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("proc_stat")
   return false
end if

is_gubn = dw_head.GetItemString(1, "gubn")

return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_shop_cd, is_order_no, is_order_name, is_order_mobile, is_gubn)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count
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

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
             "t_fr_ymd.Text = '" + is_fr_ymd + "'" + &				 
             "t_to_ymd.Text = '" + is_to_ymd + "'" 

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_47002_e","0")
end event

type cb_close from w_com010_e`cb_close within w_47002_e
end type

type cb_delete from w_com010_e`cb_delete within w_47002_e
end type

type cb_insert from w_com010_e`cb_insert within w_47002_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_47002_e
end type

type cb_update from w_com010_e`cb_update within w_47002_e
end type

type cb_print from w_com010_e`cb_print within w_47002_e
end type

type cb_preview from w_com010_e`cb_preview within w_47002_e
end type

type gb_button from w_com010_e`gb_button within w_47002_e
end type

type cb_excel from w_com010_e`cb_excel within w_47002_e
end type

type dw_head from w_com010_e`dw_head within w_47002_e
integer x = 5
integer width = 3602
string dataobject = "d_47002_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("proc_stat", idw_proc_stat)
idw_proc_stat.SetTransObject(SQLCA)
idw_proc_stat.Retrieve('043')
idw_proc_stat.InsertRow(1)
idw_proc_stat.SetItem(1, "inter_cd", '%')
idw_proc_stat.SetItem(1, "inter_nm", '전체')
end event

type ln_1 from w_com010_e`ln_1 within w_47002_e
end type

type ln_2 from w_com010_e`ln_2 within w_47002_e
end type

type dw_body from w_com010_e`dw_body within w_47002_e
string dataobject = "d_47002_D01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_proc_stat

This.GetChild("proc_stat", ldw_proc_stat)
ldw_proc_stat.SetTransObject(SQLCA)
ldw_proc_stat.Retrieve('043')


This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.retrieve('%')


end event

type dw_print from w_com010_e`dw_print within w_47002_e
string dataobject = "d_47002_r01"
end type

