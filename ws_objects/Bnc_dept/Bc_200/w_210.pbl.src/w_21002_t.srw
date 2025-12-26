$PBExportHeader$w_21002_t.srw
$PBExportComments$테스트일자 조회
forward
global type w_21002_t from w_com010_e
end type
end forward

global type w_21002_t from w_com010_e
integer width = 3703
integer height = 2268
end type
global w_21002_t w_21002_t

type variables
String is_style
end variables

on w_21002_t.create
call super::create
end on

on w_21002_t.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_style)

IF il_rows > 0 THEN
   dw_body.SetFocus()
elseif il_rows = 0 then
	dw_body.insertrow(0)	
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

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

is_style = dw_head.GetItemString(1, "style")

if is_style = '' or isnull(is_style) then
	is_style = '%'
else 
	is_style = is_style + '%'
end if
end event

event ue_insert();if dw_body.AcceptText() <> 1 then return

il_rows = dw_body.InsertRow(0)



/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)
end event

event ue_button(integer ai_cb_div, long al_rows);/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
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
END CHOOSE

end event

event type long ue_update();long i, ll_row_count
datetime ld_datetime, ls_reg_dt, ls_mod_dt
string ls_style, ls_test_date, ls_reg_id, ls_mod_id
int cnt


ll_row_count = dw_body.RowCount()


IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count

	idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */	
		ls_style = dw_body.getitemstring(i,"style")	
		ls_test_date = dw_body.getitemstring(i,"test_date")
		
		if LenA(trim(ls_style)) <> 8 then 
			messagebox('확인','스타일번호를 8자리로 입력해주세요.')
			return 0
		end if
				
		if LenA(trim(ls_test_date)) <> 8 then 
			messagebox('확인','테스트일자를 제대로 입력해주세요.')
			return 0
		end if
		
		select count(style)
		  into :cnt
		from test_0226_m
		where style = :ls_style;
		
		if cnt > 0 then 
			messagebox('','이미 등록된 스타일번호입니다.')
			//rollback;
			return 0
		end if
				
		ls_reg_id = gs_user_id
		ls_reg_dt = ld_datetime
		ls_mod_id = gs_user_id
		ls_mod_dt = ld_datetime
	
      dw_body.Setitem(i, "reg_id", gs_user_id)
      dw_body.Setitem(i, "reg_dt", ls_reg_dt)
      dw_body.Setitem(i, "mod_id", ls_mod_id)
      dw_body.Setitem(i, "mod_dt", ls_mod_dt)
		
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		ls_test_date = dw_body.getitemstring(i,"test_date")
		
		if LenA(trim(ls_test_date)) <> 8 then 
			messagebox('확인','테스트일자를 제대로 입력해주세요.')
			return 0
		end if
				
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
	
NEXT



il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
	MessageBox('', 'Error.'+Sqlca.SqlErrText)
end if


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
This.trigger event ue_retrieve()
return il_rows
end event

event ue_delete();call super::ue_delete;if dw_body.rowcount() = 0 then
	dw_body.insertrow(0)
end if
end event

type cb_close from w_com010_e`cb_close within w_21002_t
end type

type cb_delete from w_com010_e`cb_delete within w_21002_t
end type

type cb_insert from w_com010_e`cb_insert within w_21002_t
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_21002_t
end type

type cb_update from w_com010_e`cb_update within w_21002_t
end type

type cb_print from w_com010_e`cb_print within w_21002_t
end type

type cb_preview from w_com010_e`cb_preview within w_21002_t
end type

type gb_button from w_com010_e`gb_button within w_21002_t
end type

type cb_excel from w_com010_e`cb_excel within w_21002_t
end type

type dw_head from w_com010_e`dw_head within w_21002_t
integer x = 9
integer y = 168
integer width = 3589
integer height = 208
string dataobject = "d_21002_t03"
end type

type ln_1 from w_com010_e`ln_1 within w_21002_t
integer beginy = 396
integer endy = 396
end type

type ln_2 from w_com010_e`ln_2 within w_21002_t
integer beginy = 400
integer endy = 400
end type

type dw_body from w_com010_e`dw_body within w_21002_t
integer x = 18
integer y = 416
integer height = 1612
string dataobject = "d_21002_t04"
boolean hscrollbar = true
end type

event dw_body::clicked;call super::clicked;setrow(row)
end event

event dw_body::doubleclicked;string p_style, r_detail, f_detail, A, t_flag

Choose Case dwo.name
	case 'test_detail'
		t_flag = dw_body.getitemstring(getrow(),"flag")
		
		If t_flag = '1' then
			
			p_style = dw_body.getitemstring(getrow(),"style")
			f_detail = dw_body.getitemstring(getrow(),"test_detail")
			
			
			OpenWithParm(W_21002_p, p_style)
			
			A = Message.StringParm
			
			If A = "CloseEvent" Then
				
			else
				dw_body.Setitem(getrow(), "test_detail", A)
				Trigger Event ue_update()
			end if
		end if
end Choose
end event

type dw_print from w_com010_e`dw_print within w_21002_t
string dataobject = "d_21002_t05"
end type

