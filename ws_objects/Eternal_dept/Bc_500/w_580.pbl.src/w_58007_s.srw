$PBExportHeader$w_58007_s.srw
$PBExportComments$수입내역등록
forward
global type w_58007_s from w_com010_e
end type
end forward

global type w_58007_s from w_com010_e
integer width = 3675
integer height = 2276
end type
global w_58007_s w_58007_s

type variables
string is_brand, is_order_no
decimal  il_in_qty, il_main_cost, il_sub_cost
datawindowchild idw_brand


end variables

on w_58007_s.create
call super::create
end on

on w_58007_s.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.setitem(il_rows,"brand", is_brand)
	dw_body.setitem(il_rows,"order_no", is_order_no)
	dw_body.setitem(il_rows,"in_qty", il_in_qty)
	dw_body.setitem(il_rows,"main_cost_", il_main_cost)
	dw_body.setitem(il_rows,"sub_cost", il_sub_cost)
	
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_order_no = dw_head.GetItemString(1, "order_no")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
string ls_flag
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_order_no)
IF il_rows > 0 THEN
	il_in_qty = dw_body.getitemNumber(1,"in_qty")
	il_main_cost = dw_body.getitemNumber(1,"main_cost")
	il_sub_cost = dw_body.getitemNumber(1,"sub_cost")
	
	for i=1 to il_rows
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

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		cb_retrieve.enabled = true
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
		cb_retrieve.enabled = true
END CHOOSE

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_t_sub_cost
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	ll_t_sub_cost = dw_body.getitemNumber(i,"t_sub_cost")
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
		dw_body.SetItem(i, "etc_cost", ll_t_sub_cost)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
		dw_body.SetItem(i, "etc_cost", ll_t_sub_cost)		
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

type cb_close from w_com010_e`cb_close within w_58007_s
end type

type cb_delete from w_com010_e`cb_delete within w_58007_s
end type

type cb_insert from w_com010_e`cb_insert within w_58007_s
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_58007_s
end type

type cb_update from w_com010_e`cb_update within w_58007_s
end type

type cb_print from w_com010_e`cb_print within w_58007_s
end type

type cb_preview from w_com010_e`cb_preview within w_58007_s
end type

type gb_button from w_com010_e`gb_button within w_58007_s
end type

type cb_excel from w_com010_e`cb_excel within w_58007_s
end type

type dw_head from w_com010_e`dw_head within w_58007_s
integer height = 140
string dataobject = "d_58007_h04"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_e`ln_1 within w_58007_s
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_e`ln_2 within w_58007_s
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_e`dw_body within w_58007_s
integer y = 348
integer height = 1692
string dataobject = "d_58007_d04"
end type

event dw_body::editchanged;call super::editchanged;decimal i, ll_t_sub_cost, ll_in_qty, ll_main_cost, ll_sub_cost
decimal ll_qty, ll_amount, ll_t_qty, ll_t_amt, ll_etc_cost, ll_t_etc_cost

if dw_body.AcceptText() <> 1 then return

if dwo.name ="qty" or dwo.name="amount" or dwo.name="etc_cost" then 
	ll_in_qty = dw_body.getitemNumber(1,"in_qty")
	ll_main_cost = dw_body.getitemNumber(1,"main_cost")
	ll_sub_cost = dw_body.getitemNumber(1,"sub_cost")
	ll_t_qty = ll_in_qty
	ll_t_amt = ll_main_cost
	ll_t_etc_cost = ll_sub_cost
	
	if dwo.name ="qty" then 		
		for i = 1 to dw_body.rowcount()-1
			ll_qty = dw_body.getitemNumber(i,"qty")
			if isnull(ll_qty) then ll_qty = 0
			ll_t_qty = ll_t_qty - ll_qty
		next 		
		dw_body.SetItem(i, "qty", ll_t_qty)
		
	elseif dwo.name ="amount" then 
		for i = 1 to dw_body.rowcount()-1
			ll_amount = dw_body.getitemNumber(i,"amount")
			if isnull(ll_amount) then ll_amount = 0
			ll_t_amt = ll_t_amt - ll_amount
		next 		
		dw_body.SetItem(i, "amount", ll_t_amt)	
		
//	elseif dwo.name ="etc_cost" then
//		for i = 1 to dw_body.rowcount()-1
//			ll_etc_cost = dw_body.getitemNumber(i,"etc_cost")
//			ll_t_etc_cost = ll_t_etc_cost - ll_etc_cost
//		next 		
//		dw_body.SetItem(i, "etc_cost", ll_t_etc_cost)	

	end if

	for i = 1 to dw_body.rowcount()
		ll_t_sub_cost = dw_body.getitemNumber(i,"t_sub_cost")
		if isnull(ll_t_sub_cost)  then ll_t_sub_cost = 0
		dw_body.SetItem(i, "etc_cost", ll_t_sub_cost)
	next 
	
end if

end event

type dw_print from w_com010_e`dw_print within w_58007_s
end type

