$PBExportHeader$w_93008_e.srw
$PBExportComments$특정업무 사용자권한
forward
global type w_93008_e from w_com020_e
end type
end forward

global type w_93008_e from w_com020_e
end type
global w_93008_e w_93008_e

type variables
string is_work_gbn, is_person_id

end variables

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

is_work_gbn = dw_head.GetItemString(1, "work_gbn")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_work_gbn, '%')
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : M.S.I (김 태범)                                             */	
/* 작성일      : 2001.05.31                                                  */	
/* 수성일      : 2001.05.31                                                  */
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
      dw_body.Setitem(i, "work_gbn", is_work_gbn)
	end if
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

on w_93008_e.create
call super::create
end on

on w_93008_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_person_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "person_id"				
			IF ai_div = 1 THEN 	
				IF gf_user_nm(as_data, ls_person_nm) = 0 THEN
				   dw_head.SetItem(al_row, "person_nm", ls_person_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사용자 검색" 
			gst_cd.datawindow_nm   = "d_com931" 
			gst_cd.default_where   = "WHERE Status_YN = 'Y' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (person_id LIKE '" + as_data + "%' or person_nm like '%" + as_data + "%')"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "person_id", lds_Source.GetItemString(1,"person_id"))
				dw_body.SetItem(al_row, "person_nm", lds_Source.GetItemString(1,"person_nm"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("user_level")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

type cb_close from w_com020_e`cb_close within w_93008_e
end type

type cb_delete from w_com020_e`cb_delete within w_93008_e
end type

type cb_insert from w_com020_e`cb_insert within w_93008_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_93008_e
end type

type cb_update from w_com020_e`cb_update within w_93008_e
end type

type cb_print from w_com020_e`cb_print within w_93008_e
end type

type cb_preview from w_com020_e`cb_preview within w_93008_e
end type

type gb_button from w_com020_e`gb_button within w_93008_e
end type

type cb_excel from w_com020_e`cb_excel within w_93008_e
end type

type dw_head from w_com020_e`dw_head within w_93008_e
integer height = 176
string dataobject = "d_93008_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild ldw_child
This.GetChild("work_gbn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('992')
end event

type ln_1 from w_com020_e`ln_1 within w_93008_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com020_e`ln_2 within w_93008_e
integer beginy = 356
integer endy = 356
end type

type dw_list from w_com020_e`dw_list within w_93008_e
integer y = 364
integer width = 837
integer height = 1676
string dataobject = "d_93008_L01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_person_id = This.GetItemString(row, 'person_id') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_person_id) THEN return
il_rows = dw_body.retrieve(is_work_gbn, is_person_id)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_93008_e
integer x = 891
integer y = 364
integer width = 2706
integer height = 1676
string dataobject = "d_93008_d01"
end type

event dw_body::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "colunm1" 
    IF data = 'A' THEN
	      /*action*/
    END IF
	CASE "person_id"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type st_1 from w_com020_e`st_1 within w_93008_e
integer x = 873
integer y = 364
integer height = 1676
end type

type dw_print from w_com020_e`dw_print within w_93008_e
integer x = 23
integer y = 864
end type

