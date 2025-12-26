$PBExportHeader$w_54010_s1.srw
$PBExportComments$완불요청 일별작업확정
forward
global type w_54010_s1 from w_com010_e
end type
end forward

global type w_54010_s1 from w_com010_e
integer width = 3675
integer height = 2244
end type
global w_54010_s1 w_54010_s1

type variables
DataWindowChild idw_brand, idw_color
string is_yymmdd, is_brand, is_proc_yn

end variables

on w_54010_s1.create
call super::create
end on

on w_54010_s1.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;Datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "yymmdd",string(ld_datetime, "yyyymmdd"))

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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"작업일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_proc_yn = dw_head.GetItemString(1, "gubn")
if IsNull(is_proc_yn) or Trim(is_proc_yn) = "" then
   MessageBox(ls_title,"확정여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubn")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymmdd, is_brand, is_proc_yn)
IF il_rows > 0 THEN
   dw_body.SetFocus()
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
//      dw_body.Setitem(i, "mod_id", gs_user_id)
//      dw_body.Setitem(i, "mod_dt", ld_datetime)
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

type cb_close from w_com010_e`cb_close within w_54010_s1
end type

type cb_delete from w_com010_e`cb_delete within w_54010_s1
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_54010_s1
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_54010_s1
end type

type cb_update from w_com010_e`cb_update within w_54010_s1
end type

type cb_print from w_com010_e`cb_print within w_54010_s1
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_54010_s1
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_54010_s1
end type

type cb_excel from w_com010_e`cb_excel within w_54010_s1
end type

type dw_head from w_com010_e`dw_head within w_54010_s1
integer y = 188
integer height = 176
string dataobject = "d_54010_s01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_e`ln_1 within w_54010_s1
integer beginy = 372
integer endy = 372
end type

type ln_2 from w_com010_e`ln_2 within w_54010_s1
integer beginy = 376
integer endy = 376
end type

type dw_body from w_com010_e`dw_body within w_54010_s1
integer y = 384
integer height = 1628
string dataobject = "d_54010_s02"
end type

event dw_body::buttonclicked;call super::buttonclicked;Long	ll_row_count, i
string ls_select_yn, ls_accept_fg

CHOOSE CASE dwo.name
	CASE "cb_select"
		If This.Object.cb_select.Text = '전체승인' then
			ls_select_yn = 'Y'
			This.Object.cb_select.Text = '전체제외'
		Else
			ls_select_yn = 'N'
			This.Object.cb_select.Text = '전체승인'
		End If
		
		 
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			ls_accept_fg = this.getitemstring(i, "accept_fg")
			if  ls_accept_fg = 'C' then
				This.SetItem(i, "proc_yn", ls_select_yn)
			end if				
		Next
END CHOOSE
end event

event dw_body::constructor;call super::constructor;This.GetChild("color", idw_color )
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve('%')

end event

type dw_print from w_com010_e`dw_print within w_54010_s1
end type

