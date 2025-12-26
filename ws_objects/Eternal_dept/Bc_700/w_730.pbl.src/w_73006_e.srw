$PBExportHeader$w_73006_e.srw
$PBExportComments$매장별회원모집보상
forward
global type w_73006_e from w_com010_e
end type
end forward

global type w_73006_e from w_com010_e
end type
global w_73006_e w_73006_e

type variables
DataWindowChild idw_brand
String is_brand, is_yymm
end variables

on w_73006_e.create
call super::create
end on

on w_73006_e.destroy
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

return true

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_73006_e","0")
end event

event ue_retrieve();call super::ue_retrieve;datetime ld_datetime
string ls_modify, ls_datetime, ls_next_yymm, ls_brand
long ii, ll_row_cnt

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymm, is_brand)
IF il_rows > 0 THEN

	select convert(char(06), dateadd(month, 1, :is_yymm + '01'),112)
	into :ls_next_yymm
	from dual;


	ls_modify =	 "t_base_yymm.Text = '" + is_yymm + "'" + &
					 "t_next_yymm.Text = '" + ls_next_yymm + "'" 
	
	dw_body.Modify(ls_modify)
	
	ll_row_cnt = dw_body.RowCount()
	
	for ii = 1 to ll_row_cnt
		ls_brand = dw_body.getitemstring(ii, "brand")
		if IsNull(ls_brand) or Trim(ls_brand) = "" then
			dw_body.SetItemStatus(ii, 0, Primary!, New!)
		end if	
	next
	
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count
datetime ld_datetime
String ls_yymm, ls_shop_cd, ls_sugm_ymd, ls_brand, ls_reg_id

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! or idw_status = New! THEN				/* New Record    */
	   dw_body.Setitem(i, "brand", is_brand)
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		   /* Modify Record */ 
		ls_brand = dw_body.GetitemString(i, "brand") 
		ls_reg_id = dw_body.GetitemString(i, "reg_id") 
		IF isnull(ls_brand) or Trim(ls_reg_id) = "" THEN 
         dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
         dw_body.Setitem(i, "brand",    is_brand)
         dw_body.Setitem(i, "reg_id", gs_user_id)
		ELSE
         dw_body.Setitem(i, "mod_id", gs_user_id)
         dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF
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
string ls_modify, ls_datetime, ls_next_yymm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

select convert(char(06), dateadd(month, 1, :is_yymm + '01'),112)
into :ls_next_yymm
from dual;
	

ls_modify =  "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_base_yymm.Text = '" + is_yymm + "'" + &
				 "t_next_yymm.Text = '" + ls_next_yymm + "'" + &
			  	 "t_brand.Text = '" + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") + "'" 

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_e`cb_close within w_73006_e
end type

type cb_delete from w_com010_e`cb_delete within w_73006_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_73006_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_73006_e
end type

type cb_update from w_com010_e`cb_update within w_73006_e
end type

type cb_print from w_com010_e`cb_print within w_73006_e
end type

type cb_preview from w_com010_e`cb_preview within w_73006_e
end type

type gb_button from w_com010_e`gb_button within w_73006_e
end type

type cb_excel from w_com010_e`cb_excel within w_73006_e
end type

type dw_head from w_com010_e`dw_head within w_73006_e
integer height = 152
string dataobject = "d_73006_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_e`ln_1 within w_73006_e
integer beginy = 336
integer endy = 336
end type

type ln_2 from w_com010_e`ln_2 within w_73006_e
integer beginy = 340
integer endy = 340
end type

type dw_body from w_com010_e`dw_body within w_73006_e
integer y = 352
integer height = 1688
string dataobject = "d_73006_d01"
boolean hscrollbar = true
end type

event dw_body::buttonclicked;call super::buttonclicked;Long i
String ls_contents1, ls_contents2, ls_opt

If dwo.Name = 'cb_copy' Then
	
		ls_opt = "D"
	
	  	ls_contents1 = This.getitemstring(1, "event_note")
		if IsNull(ls_contents1) or Trim(ls_contents1) = "" then
			MessageBox("주의!","복사 할 내역이 없습니다!")
			this.SetFocus()
			this.SetColumn("event_note")
			return 1
		end if
	
	For i = 1 To This.RowCount()
		ls_contents2 =  This.getitemstring(i, "event_note")
		
		if IsNull(ls_contents2) or Trim(ls_contents2) = "" then
 		  ls_contents2 = ""
		end if
	
		if ls_contents2 = "" or ls_contents1 = ls_contents2 then
			This.SetItem(i, "event_note", ls_contents1)
		end if	
	
	Next
	
else


		ls_opt = "C"

	
	  	ls_contents1 = This.getitemstring(1, "event_note")
		if IsNull(ls_contents1) or Trim(ls_contents1) = "" then
			MessageBox("주의!","복사 할 내역이 없습니다!")
			this.SetFocus()
			this.SetColumn("event_note")
			return 1
		end if
	
	For i = 1 To This.RowCount()
		ls_contents2 =  This.getitemstring(i, "event_note")
		if IsNull(ls_contents2) or Trim(ls_contents2) = "" then
 		  ls_contents2 = ""
		end if
		
		messagebox(ls_contents1, ls_contents2)
		
		if ls_contents2 <> "" and ls_contents1 = ls_contents2 then
			This.SetItem(i, "event_note", "")
		end if	
		
	Next	
	
End If

end event

type dw_print from w_com010_e`dw_print within w_73006_e
string dataobject = "d_73006_r01"
end type

