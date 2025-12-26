$PBExportHeader$w_99002_d.srw
$PBExportComments$table 정의서
forward
global type w_99002_d from w_com010_d
end type
end forward

global type w_99002_d from w_com010_d
end type
global w_99002_d w_99002_d

type variables
String is_table_id
end variables

on w_99002_d.create
call super::create
end on

on w_99002_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2000.09.05                                                  */	
/* 수성일      : 2000.09.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_table_id)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2000.09.05                                                  */	
/* 수성일      : 2000.09.05                                                  */
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

is_table_id = dw_head.GetItemString(1, "table_id")

IF isnull(is_table_id) OR Trim(is_table_id) = "" THEN 
	is_table_id = 'TB'
END IF

return true
end event

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2000.09.06                                                  */	
/* 수성일      : 2001.09.28                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/

string     ls_table_id, ls_table_nm
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "table_id"				// Table id
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF gf_table_nm(as_data, ls_table_nm) <> 0 THEN
					ls_table_nm = ""
				END IF
				dw_head.SetItem(al_row, "table_nm", ls_table_nm)
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "TABLE ID 검색" 
				gst_cd.datawindow_nm   = "d_com991" 
				gst_cd.default_where   = "TABLE_ID LIKE 'TB%'"
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "TABLE_ID  LIKE '" + as_data + "%'"
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
					dw_head.SetItem(al_row, "table_id", lds_Source.GetItemString(1,"table_id"))
					dw_head.SetItem(al_row, "table_nm", lds_Source.GetItemString(1,"table_nm"))
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("table_nm")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
			END IF
END CHOOSE

RETURN 0

end event

type cb_close from w_com010_d`cb_close within w_99002_d
end type

type cb_delete from w_com010_d`cb_delete within w_99002_d
end type

type cb_insert from w_com010_d`cb_insert within w_99002_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_99002_d
end type

type cb_update from w_com010_d`cb_update within w_99002_d
end type

type cb_print from w_com010_d`cb_print within w_99002_d
end type

type cb_preview from w_com010_d`cb_preview within w_99002_d
end type

type gb_button from w_com010_d`gb_button within w_99002_d
end type

type cb_excel from w_com010_d`cb_excel within w_99002_d
end type

type dw_head from w_com010_d`dw_head within w_99002_d
integer height = 136
string dataobject = "d_99002_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2000.09.06                                                  */	
/* 수성일      : 2000.09.06                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "table_id"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_99002_d
integer beginy = 316
integer endy = 316
end type

type ln_2 from w_com010_d`ln_2 within w_99002_d
integer beginy = 320
integer endy = 320
end type

type dw_body from w_com010_d`dw_body within w_99002_d
integer y = 340
integer height = 1692
string dataobject = "d_99002_d01"
end type

type dw_print from w_com010_d`dw_print within w_99002_d
integer x = 110
integer y = 172
integer width = 2235
integer height = 768
boolean titlebar = true
string dataobject = "d_99002_r01"
boolean resizable = true
end type

