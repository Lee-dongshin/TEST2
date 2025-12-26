$PBExportHeader$w_91001_e.srw
$PBExportComments$내부코드 관리
forward
global type w_91001_e from w_com020_e
end type
type dw_1 from u_dw within w_91001_e
end type
end forward

global type w_91001_e from w_com020_e
integer height = 2476
dw_1 dw_1
end type
global w_91001_e w_91001_e

type variables
String is_inter_grp, is_inter_desc

end variables

on w_91001_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_91001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event pfc_preopen;call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : 지우정보      															  */	
/* 작성일      : 2001.05.29																  */	
/* 수정일      : 2001.05.29																  */
/*===========================================================================*/

inv_resize.of_Register(dw_1, "ScaleToRight")
dw_1.SetTransObject(SQLCA)

this.Trigger Event ue_init(dw_1)


end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : 지우정보 (권진택)  													  */	
/* 작성일      : 2000.09.06																  */	
/* 수정일      : 2000.09.06																  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_inter_grp, is_inter_desc)
dw_1.Reset()
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_keycheck;/*===========================================================================*/
/* 작성자      : 지우정보(권 진택)                                           */	
/* 작성일      : 2000.09.07                                                  */	
/* 수성일      : 2000.09.07                                                  */
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

is_inter_grp = dw_head.GetItemString(1, "inter_grp")
If IsNull(is_inter_grp) = True OR Trim(is_inter_grp) = "" then is_inter_grp = '%'

is_inter_desc = dw_head.GetItemString(1, "inter_kdesc")
If IsNull(is_inter_desc) = True OR Trim(is_inter_desc) = "" then is_inter_desc = '%'

return true	
end event

event ue_insert;/*===========================================================================*/
/* 작성자      : 지우정보(권 진택)                                           */	
/* 작성일      : 2000.09.06                                                  */	
/* 수성일      : 2000.09.06                                                  */
/*===========================================================================*/
long	ll_cur_row

if dw_1.AcceptText() <> 1 then return
if dw_body.AcceptText() <> 1 then return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(title)
		CASE 1
			IF Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			RETURN
	END CHOOSE
END IF
	
ll_cur_row = dw_1.GetRow()

if ll_cur_row < 0 then return

if ll_cur_row = 0 then
   il_rows = dw_1.InsertRow(0)
else	 
	dw_1.Reset()
	il_rows = dw_1.InsertRow(0)
end if	 

dw_body.reset()

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_1.Enabled = true
	dw_body.Enabled = false
	dw_1.ScrollToRow(il_rows)
	dw_1.SetColumn(ii_min_column_id)
	dw_1.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_delete;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수성일      : 1999.11.09																  */
/*===========================================================================*/
Long	 ll_cur_row, ll_rowcnt
Integer li_yn

ll_cur_row = dw_1.GetRow()

if ll_cur_row <= 0 then return

ll_rowcnt = dw_body.RowCount()

If ll_rowcnt > 0 Then 
	li_yn = MessageBox("경고!!!", "내부코드가 전부 삭제됩니다!!!", Exclamation!, OKCancel!, 2)
	IF li_yn = 1 THEN
		idw_status = dw_1.GetItemStatus (ll_cur_row, 0, primary!)	//ue_button에서 cb_update.Enabled 여부 결정
		il_rows = dw_1.DeleteRow(ll_cur_row)
		dw_body.RowsMove(1, dw_body.RowCount(), primary!, dw_body, 1, Delete!)	//dw_body의 모든 Row 삭제
		This.Trigger Event ue_button(4, il_rows)
		This.Trigger Event ue_msg(4, il_rows)
	ELSE
		return
	END IF
Else
	idw_status = dw_1.GetItemStatus (ll_cur_row, 0, primary!)	//ue_button에서 cb_update.Enabled 여부 결정
	il_rows = dw_1.DeleteRow(ll_cur_row)
	dw_body.RowsMove(1, dw_body.RowCount(), primary!, dw_body, 1, Delete!)	//dw_body의 모든 Row 삭제
	This.Trigger Event ue_button(4, il_rows)
	This.Trigger Event ue_msg(4, il_rows)
End If


end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : 지우정보(권 진택)                                           */	
/* 작성일      : 2000.09.07                                                  */	
/* 수성일      : 2001.10.04                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_found
datetime ld_datetime
String ls_inter_grp

ll_row_count = dw_body.RowCount()

IF dw_1.AcceptText() <> 1 THEN RETURN -1
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_inter_grp = dw_1.GetItemString(1, "inter_grp")

idw_status = dw_1.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */
	dw_1.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN	      /* Modify Record */
	dw_1.Setitem(1, "mod_id", gs_user_id)
	dw_1.Setitem(1, "mod_dt", ld_datetime)
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN            /* New Record */
      dw_body.Setitem(i, "inter_grp", ls_inter_grp)
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN	      /* Modify Record */
      dw_body.Setitem(i, "inter_grp", ls_inter_grp)
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
	ELSEIF idw_status = NotModified! THEN
      dw_body.Setitem(i, "inter_grp", ls_inter_grp)
   END IF
NEXT

il_rows = dw_1.Update(TRUE, FALSE)

if il_rows = 1 then
	il_rows = dw_body.Update(TRUE, FALSE)
	if il_rows = 1 then
   	dw_1.ResetUpdate()
   	dw_body.ResetUpdate()
		commit  USING SQLCA;
      dw_list.SetRedraw(FALSE)
		dw_list.Retrieve(is_inter_grp, is_inter_desc)
	   ll_found = dw_list.Find("inter_grp = '" + ls_inter_grp + "'", 1, dw_list.RowCount())
		IF ll_found > 0 THEN
		   dw_list.ScrollToRow(ll_found)
 	      dw_list.SelectRow(0, FALSE)
         dw_list.SelectRow(ll_found, TRUE) 
		END IF
      dw_list.SetRedraw(TRUE)
	else
		rollback  USING SQLCA;
	end if
else
	rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_button;/*===========================================================================*/
/* 작성자      : 지우정보 (권 진택)                                          */	
/* 작성일      : 2000.09.07                                                  */	
/* 수성일      : 2000.09.07                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_1.Enabled = false
         dw_body.Enabled = false
      else
         dw_head.SetFocus()
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
				dw_list.Enabled = true
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
			if dw_1.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
			dw_1.Enabled = false
			dw_body.Enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_insert.enabled = true
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_1.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
			dw_1.enabled = true
			dw_body.enabled = true
		else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
         cb_insert.enabled = true
      end if
END CHOOSE

end event

type cb_close from w_com020_e`cb_close within w_91001_e
end type

type cb_delete from w_com020_e`cb_delete within w_91001_e
end type

type cb_insert from w_com020_e`cb_insert within w_91001_e
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_91001_e
end type

type cb_update from w_com020_e`cb_update within w_91001_e
end type

type cb_print from w_com020_e`cb_print within w_91001_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_91001_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_91001_e
end type

type cb_excel from w_com020_e`cb_excel within w_91001_e
end type

type dw_head from w_com020_e`dw_head within w_91001_e
integer height = 124
string dataobject = "d_91001_h01"
end type

type ln_1 from w_com020_e`ln_1 within w_91001_e
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com020_e`ln_2 within w_91001_e
integer beginy = 332
integer endy = 332
end type

type dw_list from w_com020_e`dw_list within w_91001_e
integer y = 352
integer width = 937
integer height = 1904
boolean enabled = false
string dataobject = "d_91001_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001.05.29                                                  */	
/* 수성일      : 2001.05.29                                                  */
/*===========================================================================*/
String ls_inter_grp

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			RETURN
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_inter_grp = This.GetItemString(row, 'inter_grp') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(ls_inter_grp) THEN return

il_rows = dw_body.retrieve(ls_inter_grp)
il_rows = dw_1.retrieve(ls_inter_grp)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_e`dw_body within w_91001_e
integer x = 992
integer y = 516
integer width = 2601
integer height = 1740
boolean enabled = false
string dataobject = "d_91001_d03"
boolean hscrollbar = true
end type

event dw_body::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보 (권 진택)                                          */	
/* 작성일      : 2000.09.07																  */	
/* 수성일      : 2001.10.04                                                  */
/*===========================================================================*/
Integer ll_cur_row

ll_cur_row = dw_body.GetRow()

If dwo.name = "cb_deleterow" Then 
	idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	
	dw_body.DeleteRow(ll_cur_row)
	if idw_status <> new! and idw_status <> newmodified! then
		ib_changed = true
		cb_update.enabled = true
	end if
end if


end event

type st_1 from w_com020_e`st_1 within w_91001_e
boolean visible = false
integer x = 969
integer y = 352
integer height = 1904
boolean enabled = false
end type

type dw_print from w_com020_e`dw_print within w_91001_e
end type

type dw_1 from u_dw within w_91001_e
event ue_keycheck ( )
event ue_keydown pbm_dwnkey
integer x = 992
integer y = 352
integer width = 2601
integer height = 152
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_91001_d02"
boolean vscrollbar = false
boolean livescroll = false
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수성일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수성일      : 1999.11.08                                                  */
/*===========================================================================*/
String ls_inter_grp

IF dw_1.AcceptText() <> 1 THEN RETURN -1

ls_inter_grp = dw_1.GetItemString(1, "inter_grp")
If IsNull(ls_inter_grp) = True OR Trim(ls_inter_grp) = "" Then 
	dw_body.Enabled = false
else
	dw_body.Enabled = true
end if

end event

event itemerror;call super::itemerror;return 1
end event

event itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수성일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

end event

event dberror;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수성일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 1
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 1400
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

This.ScrollTorow(row)
This.SetRow(row)
This.SetFocus()

MessageBox(parent.title, ls_message_string)
return 1
end event

event editchanged;call super::editchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수성일      : 1999.11.08                                                  */
/*===========================================================================*/
String ls_inter_grp

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

IF dw_1.AcceptText() <> 1 THEN RETURN -1

ls_inter_grp = dw_1.GetItemString(1, "inter_grp")
If IsNull(ls_inter_grp) = True OR Trim(ls_inter_grp) = "" Then 
	dw_body.Enabled = false
else
	dw_body.Enabled = true
end if


end event

