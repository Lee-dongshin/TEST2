$PBExportHeader$w_21093_e1.srw
$PBExportComments$케어라벨코드입력(POP-UP)
forward
global type w_21093_e1 from w_com010_e
end type
end forward

global type w_21093_e1 from w_com010_e
integer width = 1920
integer height = 2192
end type
global w_21093_e1 w_21093_e1

type variables
string  is_inter_grp
end variables

on w_21093_e1.create
call super::create
end on

on w_21093_e1.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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
	   dw_body.Setitem(i, "inter_grp", is_inter_grp)
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_inter_grp)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

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

is_inter_grp = dw_head.GetItemString(1, "inter_grp")
if IsNull(is_inter_grp) or Trim(is_inter_grp) = "" then
   MessageBox(ls_title,"구분 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("inter_grp")
   return false
end if

return true

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
         cb_retrieve.Text = "조건(&Q)"
			cb_retrieve.enabled = true	
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
 
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_retrieve.enabled = true
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
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
		cb_retrieve.enabled = true
      cb_delete.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

type cb_close from w_com010_e`cb_close within w_21093_e1
integer x = 1467
end type

type cb_delete from w_com010_e`cb_delete within w_21093_e1
integer x = 750
end type

type cb_insert from w_com010_e`cb_insert within w_21093_e1
integer x = 389
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_21093_e1
integer x = 1106
end type

type cb_update from w_com010_e`cb_update within w_21093_e1
end type

type cb_print from w_com010_e`cb_print within w_21093_e1
boolean visible = false
integer x = 1472
integer y = 164
end type

type cb_preview from w_com010_e`cb_preview within w_21093_e1
boolean visible = false
integer x = 1330
integer y = 168
end type

type gb_button from w_com010_e`gb_button within w_21093_e1
integer x = 14
integer width = 1833
end type

type cb_excel from w_com010_e`cb_excel within w_21093_e1
boolean visible = false
integer x = 1440
integer y = 168
end type

type dw_head from w_com010_e`dw_head within w_21093_e1
integer x = 27
integer y = 168
integer width = 1262
integer height = 120
string dataobject = "d_21093_h02"
end type

type ln_1 from w_com010_e`ln_1 within w_21093_e1
boolean visible = false
integer beginy = 312
integer endx = 1829
integer endy = 312
end type

type ln_2 from w_com010_e`ln_2 within w_21093_e1
boolean visible = false
integer beginy = 304
integer endx = 1829
integer endy = 304
end type

type dw_body from w_com010_e`dw_body within w_21093_e1
integer y = 332
integer width = 1838
integer height = 1624
string dataobject = "d_21093_d05"
end type

type dw_print from w_com010_e`dw_print within w_21093_e1
integer x = 754
integer y = 400
end type

