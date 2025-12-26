$PBExportHeader$w_58015_e.srw
$PBExportComments$수출및운송비관리
forward
global type w_58015_e from w_com010_e
end type
end forward

global type w_58015_e from w_com010_e
end type
global w_58015_e w_58015_e

type variables
string is_brand,  is_gubun, is_from_date, is_to_date
 Datawindowchild  idw_brand 
end variables

on w_58015_e.create
call super::create
end on

on w_58015_e.destroy
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_gubun = dw_head.GetItemString(1, "gubun")
if IsNull(is_gubun) or Trim(is_gubun) = "" then
   MessageBox(ls_title,"수출구분를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubun")
   return false
end if

is_from_date = dw_head.GetItemString(1, "from_date")
if IsNull(is_from_date) or Trim(is_from_date) = "" then
   MessageBox(ls_title,"From일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("from_date")
   return false
end if

is_to_date = dw_head.GetItemString(1, "to_date")
if IsNull(is_to_date) or Trim(is_to_date) = "" then
   MessageBox(ls_title,"To일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_date")
   return false
end if

if is_from_date > is_to_date then
	MessageBox(ls_title,"From일자가 To일자보다 큽니다 !")
	return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*=========================================================================-==*/
/* 작성자      : (주)지우정보 ()                                      			*/	
/* 작성일      : 2001..                                                  		*/	
/* 수정일      : 2001..                                                  		*/
/*========================================================================-===*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand,is_gubun, is_from_date, is_to_date)

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
long 		i, ll_row_count, ll_count
datetime ld_datetime
decimal	ld_qty, ld_amount, ld_tot_sale_amt,ld_tot_amt
string	ls_invoice_date, ls_invoice_no
 

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


FOR i=1 TO ll_row_count
	
	ls_invoice_date = dw_body.GetItemString(i,"invoice_date")
	ls_invoice_no = dw_body.GetItemString(i,"invoice_no")
	ld_tot_amt  =   dw_body.GetItemDecimal(i,"tot_amt")
	
	 dw_body.Setitem(i, "total_amount", ld_tot_amt)
	
	select count(*)  
	into	:ll_count
	from 	tb_58003_d 
	where brand        = :is_brand 
	and   gubun        = :is_gubun 
	and   Invoice_Date = :ls_invoice_date
	and   Invoice_no   = : ls_invoice_no;
	
	if  ll_count = 0 then 
		 dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
	end if
	
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN			/* Modify Record */
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

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event open;call super::open;datetime	ld_datetime
string   ls_from_date, ls_to_date

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_to_date = String(ld_datetime, "yyyymmdd")
ls_from_date = LeftA(ls_to_date,6) + '01'

dw_head.Setitem(1,"from_date", ls_from_date)
dw_head.Setitem(1,"to_date", ls_to_date)
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_country, ls_order_gubn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_gubun = 'G'  then
	ls_order_gubn = 'G 상품'
elseif is_gubun = 'M'  then
	 ls_order_gubn = 'M 원자재'
elseif is_gubun = 'S'  then
	 ls_order_gubn = 'S 부자재'
end if

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	 "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_gubun.Text = '" + ls_order_gubn + "'" + & 
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_yymmdd.Text = '" + String(is_from_date, '@@@@/@@/@@') + ' ~ ' + String(is_to_date, '@@@@/@@/@@') + "'"  
				 
				 

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_e`cb_close within w_58015_e
end type

type cb_delete from w_com010_e`cb_delete within w_58015_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_58015_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_58015_e
end type

type cb_update from w_com010_e`cb_update within w_58015_e
end type

type cb_print from w_com010_e`cb_print within w_58015_e
end type

type cb_preview from w_com010_e`cb_preview within w_58015_e
end type

type gb_button from w_com010_e`gb_button within w_58015_e
end type

type cb_excel from w_com010_e`cb_excel within w_58015_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_58015_e
integer y = 164
integer height = 120
string dataobject = "d_58015_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_e`ln_1 within w_58015_e
integer beginy = 292
integer endy = 292
end type

type ln_2 from w_com010_e`ln_2 within w_58015_e
integer beginy = 296
integer endy = 296
end type

type dw_body from w_com010_e`dw_body within w_58015_e
integer y = 308
integer height = 1732
string dataobject = "d_58015_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
boolean livescroll = false
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
		IF dw_body.GetColumnName() = "remark"  THEN
	   ELSE
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		END IF
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
END CHOOSE

Return 0
end event

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
//This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_print from w_com010_e`dw_print within w_58015_e
string dataobject = "d_58015_r01"
end type

