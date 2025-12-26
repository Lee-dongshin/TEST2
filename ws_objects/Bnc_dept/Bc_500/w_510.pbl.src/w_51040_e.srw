$PBExportHeader$w_51040_e.srw
$PBExportComments$일용근로자정보
forward
global type w_51040_e from w_com020_e
end type
end forward

global type w_51040_e from w_com020_e
end type
global w_51040_e w_51040_e

type variables
string is_kname, is_birth, is_jumn
end variables

on w_51040_e.create
call super::create
end on

on w_51040_e.destroy
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

is_kname = dw_head.GetItemString(1, "kname")
if IsNull(is_kname) or Trim(is_kname) = "" then
   MessageBox(ls_title,"대상자 이름을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("kname")
   return false
end if


is_birth = dw_head.GetItemString(1, "birth_day")
if IsNull(is_birth) or Trim(is_birth) = "" then
	is_birth = "%"
//   MessageBox(ls_title,"생년월일을 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("is_birth")
//   return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_kname, is_birth)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */

		 cb_insert.Enabled = True
		 
	 	 if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
	
      else
	      dw_body.Enabled = false
			cb_insert.Enabled = True
	      dw_head.SetFocus()
      end if		 
		 
		 
		 
   CASE 2      /* 추가 */
      if al_rows > 0 then
			dw_body.Enabled = true
		end if

//	CASE 4		/* 삭제 */
//		if al_rows = 1 then
//			if dw_body.RowCount() = 0 then
//            cb_delete.enabled = false
//			end if
//         if idw_status <> new! and idw_status <> newmodified! then
//            ib_changed = true
//            cb_update.enabled = true
//			end if
//		end if		

   CASE 5    /* 조건 */
//       cb_update.enabled = false
//       dw_body.Enabled = false
//		 cb_insert.Enabled = False
//		 
	    cb_retrieve.Text = "조회(&Q)"
       cb_update.enabled = false
       dw_head.Enabled = true
       dw_list.Enabled = false		 
       dw_body.Enabled = false
		 cb_insert.Enabled = False
 	    ib_changed = false
       dw_head.SetFocus()
       dw_head.SetColumn(1)		 
		 
		 
   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
			dw_body.Enabled = true
		end if
END CHOOSE



end event

event type long ue_update();call super::ue_update;long i, ll_row_count
datetime ld_datetime
string ls_jumn_no

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
	ls_jumn_no =  dw_body.GetItemString(i, "jumn_no")
	
	if LenA(ls_jumn_no) <> 14 or MidA(ls_jumn_no, 7,1) <> "-" then
		messagebox("주민번호 확인", "주민번호가 양식에 맞도록 입력해주세요!")
		Return 0
	end if	
	
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "input_empno", gs_user_id)
      dw_body.Setitem(i, "input_date", ld_datetime)
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

event ue_insert();
if dw_body.AcceptText() <> 1 then return


/* 변경된 자료가 있을때 저장여부를 확인*/
IF ib_changed THEN 
   CHOOSE CASE gf_update_yn(This.title)
	   CASE 1
		   IF This.Trigger Event ue_update() < 1 THEN
			   return
		   END IF		
	   CASE 3
		   return
   END CHOOSE
END IF


///* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
//IF dw_head.Enabled THEN
//	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
//END IF


dw_body.Reset()
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_emp_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column

CASE "kname"		

			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then  return 1
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "일용근로자 검색" 
			gst_cd.datawindow_nm   = "d_com936" 

			gst_cd.default_where   = "where 1 = 1 " 
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(kname LIKE '" + as_data + "%' )" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "kname",    lds_Source.GetItemString(1,"kname"))
				dw_head.SetItem(al_row, "birth_day", MidA(lds_Source.GetItemString(1,"jumn_no"),1,6))

				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
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

type cb_close from w_com020_e`cb_close within w_51040_e
end type

type cb_delete from w_com020_e`cb_delete within w_51040_e
end type

type cb_insert from w_com020_e`cb_insert within w_51040_e
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_51040_e
end type

type cb_update from w_com020_e`cb_update within w_51040_e
end type

type cb_print from w_com020_e`cb_print within w_51040_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_51040_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_51040_e
end type

type cb_excel from w_com020_e`cb_excel within w_51040_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_51040_e
integer height = 164
string dataobject = "d_51040_h01"
end type

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name

	CASE "kname"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_51040_e
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com020_e`ln_2 within w_51040_e
integer beginy = 348
integer endy = 348
end type

type dw_list from w_com020_e`dw_list within w_51040_e
integer x = 5
integer y = 360
integer width = 969
integer height = 1632
string dataobject = "d_51040_D01"
end type

event dw_list::clicked;call super::clicked;IF row <= 0 THEN Return

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

is_jumn = This.GetItemString(row, 'jumn_no') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_jumn) THEN return

il_rows = dw_body.retrieve(is_kname, is_jumn)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_51040_e
integer x = 997
integer y = 360
integer width = 2574
integer height = 1632
string dataobject = "d_51040_D02"
end type

type st_1 from w_com020_e`st_1 within w_51040_e
integer x = 978
integer y = 360
integer height = 1632
end type

type dw_print from w_com020_e`dw_print within w_51040_e
end type

