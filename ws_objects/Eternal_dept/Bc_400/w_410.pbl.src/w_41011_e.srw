$PBExportHeader$w_41011_e.srw
$PBExportComments$Tasse Tasse 제품입고
forward
global type w_41011_e from w_com010_e
end type
end forward

global type w_41011_e from w_com010_e
integer width = 3675
integer height = 2276
end type
global w_41011_e w_41011_e

type variables
string is_yymmdd, is_style, is_flag 
long    is_check2 = 0
end variables

on w_41011_e.create
call super::create
end on

on w_41011_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"yymmdd",string(ld_datetime,"yyyymmdd"))
end if

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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
is_style = dw_head.GetItemString(1, "style")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymmdd, is_style, is_flag)
IF il_rows > 0 THEN

   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_insert();/*============================================================================*/
/* 작성자      : (주)지우정보 ()                                      			*/	
/* 작성일      : 2001..                                                  		*/	
/* 수정일      : 2001..                                                  		*/
/*============================================================================*/
long i
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymmdd, is_style, is_flag)
IF il_rows > 0 THEN
	if is_flag = 'New' then
		for i = 1 to il_rows
			dw_body.SetItemStatus(i, 0, Primary!, New!)			
		next 
	end if
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)
end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
string ls_yymmdd, ls_in_no, ls_no
long ll_act_yn

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
	FOR i=1 TO ll_row_count
			ls_yymmdd = dw_body.getitemstring(i,"yymmdd")
			ls_in_no  = dw_body.getitemstring(i,"in_no")
			ls_no     = dw_body.getitemstring(i,"no")
			ll_act_yn = dw_body.getitemnumber(i,"act_yn")
			if ll_act_yn = 1 then

				DECLARE sp_auto_tasse PROCEDURE FOR sp_auto_tasse  
							@yymmdd     = :ls_yymmdd,
							@in_no		= :ls_in_no,
							@no			= :ls_no;
							
				execute sp_auto_tasse;											
			end if
			
	NEXT
   dw_body.ResetUpdate()
	commit  		USING SQLCA;	
else 
	rollback  	USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

type cb_close from w_com010_e`cb_close within w_41011_e
end type

type cb_delete from w_com010_e`cb_delete within w_41011_e
end type

type cb_insert from w_com010_e`cb_insert within w_41011_e
end type

event cb_insert::clicked;is_flag = 'New'
Parent.Trigger Event ue_insert()
end event

type cb_retrieve from w_com010_e`cb_retrieve within w_41011_e
end type

event cb_retrieve::clicked;/*===========================================================================*/
/* 작성자      : M.S.I (김태범) 															  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
is_flag = 'Dat'

pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

IF dw_head.Enabled THEN
	Parent.Trigger Event ue_retrieve()	//조회
ELSE
	Parent.Trigger Event ue_head()	//조건
END IF

SetPointer(oldpointer)
This.Enabled = True

end event

type cb_update from w_com010_e`cb_update within w_41011_e
end type

type cb_print from w_com010_e`cb_print within w_41011_e
end type

type cb_preview from w_com010_e`cb_preview within w_41011_e
end type

type gb_button from w_com010_e`gb_button within w_41011_e
end type

type cb_excel from w_com010_e`cb_excel within w_41011_e
end type

type dw_head from w_com010_e`dw_head within w_41011_e
integer height = 168
string dataobject = "d_41011_h01"
end type

type ln_1 from w_com010_e`ln_1 within w_41011_e
integer beginy = 356
integer endy = 356
end type

type ln_2 from w_com010_e`ln_2 within w_41011_e
integer beginy = 360
integer endy = 360
end type

type dw_body from w_com010_e`dw_body within w_41011_e
integer y = 376
integer height = 1664
string dataobject = "d_41011_d01"
end type

event dw_body::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : M.S.I (정 시영)															  */	
/* 작성일      : 2000.09.18																  */	
/* 수정일      : 2000.09.18																  */
/*===========================================================================*/
long	ll_row_count, i

CHOOSE CASE dwo.name
	CASE "cb_choice2"
		If is_check2 = 0 then
			is_check2 = 1
			This.Object.cb_choice2.Text = '제외'
		Else
			is_check2 = 0
			This.Object.cb_choice2.Text = '선택'
		End If
		
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "act_yn", is_check2)
		Next
		
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_41011_e
end type

