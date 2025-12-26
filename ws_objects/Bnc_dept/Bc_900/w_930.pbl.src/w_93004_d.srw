$PBExportHeader$w_93004_d.srw
$PBExportComments$프로그램 접속 현황
forward
global type w_93004_d from w_com010_d
end type
type rb_sort from checkbox within w_93004_d
end type
end forward

global type w_93004_d from w_com010_d
rb_sort rb_sort
end type
global w_93004_d w_93004_d

type variables
String is_pg_id, is_person_id, is_fr_yymmdd, is_to_yymmdd, is_rb_sort

end variables

on w_93004_d.create
int iCurrent
call super::create
this.rb_sort=create rb_sort
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_sort
end on

on w_93004_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_sort)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.21                                                  */	
/* 수정일      : 2001.11.21                                                  */
/*===========================================================================*/
if rb_sort.checked then
	dw_body.dataobject = "d_93004_d02"
	dw_print.dataobject = "d_93004_r02"
else
	dw_body.dataobject = "d_93004_d01"
	dw_print.dataobject = "d_93004_r01"	
end if
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)



/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_pg_id, is_person_id, is_fr_yymmdd, is_to_yymmdd)
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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.21                                                  */	
/* 수정일      : 2001.11.21                                                  */
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

is_pg_id = dw_head.GetItemString(1, "pgm_id")
if IsNull(is_pg_id) or Trim(is_pg_id) = "" then
	is_pg_id = '%'
end if

is_person_id = dw_head.GetItemString(1, "person_id")
if IsNull(is_person_id) or Trim(is_person_id) = "" then
	is_person_id = '%'
end if

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.21                                                  */	
/* 수정일      : 2001.11.21                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/

string     ls_part_cd, ls_part_nm
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "pgm_id"							// 프로그램 ID
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF gf_pgm_nm(as_data, ls_part_nm) <> 0 THEN
					ls_part_nm = ''
//					MessageBox("입력오류","등록되지 않은 프로그램ID 입니다!")
//					RETURN 1
				END IF
				dw_head.SetItem(al_row, "pgm_nm", ls_part_nm)
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "프로그램 검색" 
				gst_cd.datawindow_nm   = "d_com992" 
				gst_cd.default_where   = ""		//WHERE PART_FG IN ('1', '2', '3') 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " PGM_ID LIKE '" + as_data + "%' "
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
					dw_head.SetItem(al_row, "pgm_id", lds_Source.GetItemString(1,"pgm_id"))
					dw_head.SetItem(al_row, "pgm_nm", lds_Source.GetItemString(1,"pgm_nm"))
					/* 다음컬럼으로 이동 */

					
					dw_head.SetColumn("person_id")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
			END IF
			rb_sort.checked = false

	CASE "person_id"							// 사용자 ID
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF gf_user_nm(as_data, ls_part_nm) <> 0 THEN
					ls_part_nm = ''
//					MessageBox("입력오류","등록되지 않은 사용자ID 입니다!")
//					RETURN 1
				END IF
				dw_head.SetItem(al_row, "person_nm", ls_part_nm)
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "사용자 검색" 
				gst_cd.datawindow_nm   = "d_com931" 
				gst_cd.default_where   = " where goout_ymd is null "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " (PERSON_ID LIKE '%" + as_data + "%' or person_nm like '%" + as_data + "%') "
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
					dw_head.SetItem(al_row, "person_id", lds_Source.GetItemString(1,"person_id"))
					dw_head.SetItem(al_row, "person_nm", lds_Source.GetItemString(1,"person_nm"))
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("run_stat")			
					
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
			END IF
			rb_sort.checked = true

END CHOOSE

RETURN 0

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.21                                                  */	
/* 수정일      : 2001.11.21                                                  */
/*===========================================================================*/

//datetime ld_datetime
//string ls_modify, ls_datetime, ls_pgm_nm, ls_person_nm, ls_job_stat
//
//IF gf_sysdate(ld_datetime) = FALSE THEN
//	ld_datetime = DateTime(Today(), Now())
//END IF
//
//ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
//
//ls_pgm_nm = dw_head.GetItemString(1, "pgm_nm")
//If IsNull(ls_pgm_nm) or Trim(ls_pgm_nm) = '' Then ls_pgm_nm = ' '
//
//ls_person_nm = dw_head.GetItemString(1, "person_nm")
//If IsNull(ls_person_nm) or Trim(ls_person_nm) = '' Then ls_person_nm = ' '
//
//
//
//ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
//            "t_user_id.Text = '" + gs_user_id + "'" + &
//            "t_datetime.Text = '" + ls_datetime + "'" + &
//            "t_pgm_id.Text = '" + is_pg_id + "'" + &
//            "t_pgm_nm.Text = '" + ls_pgm_nm + "'" + &
//            "t_person_id.Text = '" + is_person_id + "'" + &
//            "t_person_nm.Text = '" + ls_person_nm + "'" + &
//            "t_job_stat.Text = '" + ls_job_stat + "'"

dw_body.ShareData(dw_print)
//dw_print.inv_printpreview.of_SetZoom(ls_modify)

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.21                                                  */	
/* 수정일      : 2001.11.21                                                  */
/*===========================================================================*/
//
//datetime ld_datetime
//string ls_modify, ls_datetime, ls_pgm_nm, ls_person_nm, ls_job_stat
//
//IF gf_sysdate(ld_datetime) = FALSE THEN
//	ld_datetime = DateTime(Today(), Now())
//END IF
//
//ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
//
//ls_pgm_nm = dw_head.GetItemString(1, "pgm_nm")
//If IsNull(ls_pgm_nm) or Trim(ls_pgm_nm) = '' Then ls_pgm_nm = ' '
//
//ls_person_nm = dw_head.GetItemString(1, "person_nm")
//If IsNull(ls_person_nm) or Trim(ls_person_nm) = '' Then ls_person_nm = ' '
//
//If is_job_stat = '%' Then
//	ls_job_stat = '전체'
//ELSEIF is_job_stat = 'Y' Then
//	ls_job_stat = '사용중'
//Else
//	ls_job_stat = '종료'
//End If
//
//ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
//            "t_user_id.Text = '" + gs_user_id + "'" + &
//            "t_datetime.Text = '" + ls_datetime + "'" + &
//            "t_pgm_id.Text = '" + is_pg_id + "'" + &
//            "t_pgm_nm.Text = '" + ls_pgm_nm + "'" + &
//            "t_person_id.Text = '" + is_person_id + "'" + &
//            "t_person_nm.Text = '" + ls_person_nm + "'" + &
//            "t_job_stat.Text = '" + ls_job_stat + "'"

dw_body.ShareData(dw_print)
//dw_print.Modify(ls_modify)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if
end event

type cb_close from w_com010_d`cb_close within w_93004_d
integer taborder = 110
end type

type cb_delete from w_com010_d`cb_delete within w_93004_d
integer taborder = 60
end type

type cb_insert from w_com010_d`cb_insert within w_93004_d
integer taborder = 50
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_93004_d
end type

type cb_update from w_com010_d`cb_update within w_93004_d
integer taborder = 100
end type

type cb_print from w_com010_d`cb_print within w_93004_d
integer taborder = 70
end type

type cb_preview from w_com010_d`cb_preview within w_93004_d
integer taborder = 80
end type

type gb_button from w_com010_d`gb_button within w_93004_d
end type

type cb_excel from w_com010_d`cb_excel within w_93004_d
integer taborder = 90
end type

type dw_head from w_com010_d`dw_head within w_93004_d
integer x = 9
integer height = 124
string dataobject = "d_93004_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.21                                                  */	
/* 수정일      : 2001.11.21                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "pgm_id", "person_id"		//  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_93004_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_93004_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_93004_d
integer y = 348
integer height = 1696
integer taborder = 40
string dataobject = "d_93004_d01"
end type

type dw_print from w_com010_d`dw_print within w_93004_d
integer x = 165
integer y = 568
string dataobject = "d_93004_r01"
end type

type rb_sort from checkbox within w_93004_d
integer x = 3241
integer y = 208
integer width = 329
integer height = 60
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "사용자순"
boolean lefttext = true
borderstyle borderstyle = stylelowered!
end type

