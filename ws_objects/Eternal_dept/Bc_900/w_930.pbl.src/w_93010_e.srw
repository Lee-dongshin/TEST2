$PBExportHeader$w_93010_e.srw
$PBExportComments$프로그램별 소급관리
forward
global type w_93010_e from w_com010_e
end type
end forward

global type w_93010_e from w_com010_e
end type
global w_93010_e w_93010_e

type variables
String is_pg_id

end variables

on w_93010_e.create
call super::create
end on

on w_93010_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
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

is_pg_id = dw_head.GetItemString(1, "pgm_id_h")

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_pg_id)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
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
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
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

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
string     ls_pgm_nm
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "pgm_id_h"		
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF isnull(as_data) OR LenA(as_data) <> 9 THEN
					ls_pgm_nm = ""
			   ELSEIF gf_pgm_nm(as_data, ls_pgm_nm) <> 0 THEN
					MessageBox("입력오류","등록되지 않은 프로그램입니다!")
					RETURN 1
				END IF
				dw_head.SetItem(al_row, "pgm_nm", ls_pgm_nm)
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "프로그램명 검색" 
				gst_cd.datawindow_nm   = "d_com992" 
				gst_cd.default_where   = "WHERE PGM_DIV IN ('B', 'E') " + &
				                         "  AND PGM_FG  = 'W' "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "PGM_ID  LIKE  '" + as_data + "%'"
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
					dw_head.SetItem(al_row, "pgm_id_h", lds_Source.GetItemString(1,"pgm_id"))
					dw_head.SetItem(al_row, "pgm_nm", lds_Source.GetItemString(1,"pgm_nm"))
					/* 다음컬럼으로 이동 */
					cb_retrieve.SetFocus() 
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
			END IF
	CASE "pgm_id"		
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF gf_pgm_nm(as_data, ls_pgm_nm) <> 0 THEN
					MessageBox("입력오류","등록되지 않은 프로그램입니다!")
					RETURN 1
				END IF
				dw_body.SetItem(al_row, "pgm_nm", ls_pgm_nm)
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "프로그램명 검색" 
				gst_cd.datawindow_nm   = "d_com992" 
				gst_cd.default_where   = "WHERE PGM_DIV IN ('B', 'E') " + &
				                         "  AND PGM_FG  = 'W' "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "PGM_ID  LIKE  '" + as_data + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF

				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm
					dw_body.SetRow(al_row)
					dw_body.SetColumn(as_column)
					dw_body.SetItem(al_row, "pgm_id", lds_Source.GetItemString(1,"pgm_id"))
					dw_body.SetItem(al_row, "pgm_nm", lds_Source.GetItemString(1,"pgm_nm"))
					/* 다음컬럼으로 이동 */
					dw_body.SetColumn("iwol_fr_ymd")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
			END IF
END CHOOSE

RETURN 0

end event

type cb_close from w_com010_e`cb_close within w_93010_e
end type

type cb_delete from w_com010_e`cb_delete within w_93010_e
end type

type cb_insert from w_com010_e`cb_insert within w_93010_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_93010_e
end type

type cb_update from w_com010_e`cb_update within w_93010_e
end type

type cb_print from w_com010_e`cb_print within w_93010_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_93010_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_93010_e
end type

type cb_excel from w_com010_e`cb_excel within w_93010_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_93010_e
integer height = 176
string dataobject = "d_93010_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "pgm_id_h"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_93010_e
integer beginy = 360
integer endy = 360
end type

type ln_2 from w_com010_e`ln_2 within w_93010_e
integer beginy = 364
integer endy = 364
end type

type dw_body from w_com010_e`dw_body within w_93010_e
integer y = 384
integer height = 1664
string dataobject = "d_93010_d01"
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "iwol_fr_ymd", "iwol_to_ymd", "st_ymd", "ed_ymd" 
      IF Gf_DateChk(data) = FALSE THEN
	      Return 1
      END IF
	CASE "pgm_id"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_93010_e
end type

