$PBExportHeader$w_91026_e.srw
$PBExportComments$88바코드 관리
forward
global type w_91026_e from w_com010_e
end type
end forward

global type w_91026_e from w_com010_e
string title = "색상 코드 관리"
end type
global w_91026_e w_91026_e

type variables
DataWindowChild idw_year, idw_season
string is_year, is_season
end variables

on w_91026_e.create
call super::create
end on

on w_91026_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001.11.15                                                  */	
/* 수정일      : 2001.11.15                                                  */
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
/*
is_year = dw_head.GetItemString(1, "year")
If IsNull(is_year) OR Trim(is_year) = "" then is_year = '%'

is_season = dw_head.GetItemString(1, "season")
If IsNull(is_season) OR Trim(is_season) = "" then is_season = '%'
*/
return true	
end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001.11.15                                                  */	
/* 수정일      : 2001.11.15                                                  */
/*===========================================================================*/
string ls_brand, ls_dept_code
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


if gl_user_level = 999 then	
	ls_brand = '%'
else
	
	IF GS_BRAND = 'O' OR  GS_BRAND = 'D' THEN
		LS_BRAND = '[OD]'
	ELSE 	
		select dept_code
		into :ls_dept_code
		from mis.dbo.thb01
		where empno = :gs_user_id;
		
	
		if ls_dept_code = 'S300' then
			ls_brand = 'B'
		elseif ls_dept_code = 'L220' then
			ls_brand = 'G'
		end if
	END IF	

end if

il_rows = dw_body.retrieve(ls_brand)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001.11.15                                                  */	
/* 수정일      : 2001.11.15                                                  */
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
	   dw_body.Setitem(i, "brand", MidA(dw_body.getitemstring(i,'style_no'),1,1))
      dw_body.Setitem(i, "reg_id", gs_user_id)
		dw_body.Setitem(i, "reg_dt", ld_datetime)
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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001.11.15                                                  */	
/* 수정일      : 2001.11.15                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
/*
IF is_color = "%" THEN is_color = "전체"
IF is_color_enm = "%" THEN is_color_enm = "전체"

dw_body.ShareData(dw_print)

ls_modify =	"t_color_cd.Text = '" + is_color + "'" + &
           "t_color_enm.Text = '" + is_color_enm + "'" + &
			  "t_user_id.Text = '" + gs_user_id + "'" + &
           "t_datetime.Text = '" + ls_datetime + "'"
			  
dw_print.modify(ls_modify)
*/
end event

type cb_close from w_com010_e`cb_close within w_91026_e
end type

type cb_delete from w_com010_e`cb_delete within w_91026_e
end type

type cb_insert from w_com010_e`cb_insert within w_91026_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_91026_e
end type

type cb_update from w_com010_e`cb_update within w_91026_e
end type

type cb_print from w_com010_e`cb_print within w_91026_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_91026_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_91026_e
end type

type cb_excel from w_com010_e`cb_excel within w_91026_e
end type

type dw_head from w_com010_e`dw_head within w_91026_e
integer x = 0
integer y = 156
integer height = 132
string dataobject = "d_91026_h01"
end type

event dw_head::constructor;call super::constructor;/*
This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_nm", '전체')

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')
*/
end event

event dw_head::buttonclicking;call super::buttonclicking;/* 화일 탐색 */
Long   ll_rtn, ll_xls_ret
String ls_filename, ls_name, ls_path, ls_msg, ls_file_name1, ls_style_no
Long	 i, ll_rowcnt

dw_body.reset()

Oleobject xlapp

SetPointer(HourGlass!)
//dw_c01.AcceptText()
dw_head.AcceptText()

ll_rtn = GetFileOpenName("엑셀파일",   &
			+ ls_filename, ls_name, "XLS", &
			+ " XLS Files (*.XLSX),*.XLS")
If ll_rtn   =   1 Then
	dw_head.Object.path[1]   = ls_filename
	dw_head.Object.path_name[1]   = ls_name
End If

ls_filename = dw_head.Object.path[1]
ls_name     = dw_head.Object.path_name[1]		
ls_path     = MidA(ls_filename, 1 , LenA(ls_filename) - LenA(ls_name))

If IsNull(ls_filename) Or Trim(ls_filename) = '' Then 
	ls_msg = '엑셀 파일을 선택하여 주세요! ..........'
	Messagebox('확인',ls_msg)
	dw_head.SetFocus()
	dw_head.SetColumn("path")
	Return
End If

If IsNull(ls_name) Or Trim(ls_name) = '' Then 
	ls_msg = '엑셀 파일을 선택하여 주세요! ..........'
	Messagebox('확인',ls_msg)
	dw_head.SetFocus()
	dw_head.SetColumn("path_text")
	Return
End If

//엑셀용 OleObject를 열어 준다.
xlApp       = Create OLEObject    //엑셀용 OLE Object를 선언 한다.
ll_xls_ret = xlApp.ConnectToNewObject("excel.application") //엑셀과 연결하여 준다.
If ll_xls_ret < 0 Then
	ls_msg = '엑셀 프로그램을 사용하는데 실패 하였습니다! 포멧에 정확히 맞추어 다시 작업하세요!'
	Messagebox('확인',ls_msg)
	Return 
End If

xlApp.Application.Workbooks.Open(ls_filename) //화일을 엑셀에 맞추어서 열어 준다.

ls_file_name1 = ls_path + string(today(),'yyyymmdd') + string(now(),'hhmmss') + '_tmp.txt'

xlApp.Application.Activeworkbook.Saveas(ls_file_name1, -4158) //엑셀화일을 텍스트화일로 변환저장
xlApp.Application.Workbooks.close()
xlApp.DisConnectObject() //엑셀 오브젝트를 파괴한다.

dw_body.Reset()
//데이타 윈도우에 임포트 한다.
dw_body.importfile(ls_file_name1)
		
//필수자료 없는 데이타삭제
ll_rowcnt = dw_body.rowcount()
For i = ll_rowcnt To 1 STEP -1
	If i < 1 Then Exit
	ls_style_no = dw_body.object.style_no[i]
	If ls_style_no = "" Or IsNull(ls_style_no) Then
		dw_body.DeleteRow(i)
	End If	
Next

FileDelete(ls_file_name1)

//messagebox('완료', 'Excel 불러오기가 완료되었습니다! ')

parent.Trigger Event ue_button(1, ll_rtn)
cb_update.enabled = true
parent.Trigger Event ue_msg(1, ll_rtn)

		
		
end event

type ln_1 from w_com010_e`ln_1 within w_91026_e
integer beginy = 304
integer endy = 304
end type

type ln_2 from w_com010_e`ln_2 within w_91026_e
integer beginx = -9
integer beginy = 308
integer endx = 3611
integer endy = 308
end type

type dw_body from w_com010_e`dw_body within w_91026_e
integer x = 27
integer y = 328
integer width = 3561
integer height = 1704
string dataobject = "d_91026_d01"
end type

event dw_body::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.15                                                  */	
/* 수정일      : 1999.11.15                                                  */
/*===========================================================================*/

This.SetRowFocusIndicator(Hand!)
end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.15                                                  */	
/* 수정일      : 1999.11.15                                                  */
/*===========================================================================*/

string ls_color_grp

ls_color_grp = dw_body.GetItemString(this.getrow(), "color")
dw_body.Setitem(this.getrow(), "color_grp", LeftA(ls_color_grp,1))

end event

event dw_body::itemchanged;call super::itemchanged;//string ls_color_grp
//dw_body.accepttext()     //ItemFocusChanged()에서는 이부분 없이도 값이 들어감.
//ls_color_grp = dw_body.GetItemString(this.getrow(), "color_cd")
//dw_body.Setitem(this.getrow(), "color_grp", left(ls_color_grp,1))
end event

type dw_print from w_com010_e`dw_print within w_91026_e
integer x = 1728
integer y = 80
string dataobject = "d_91005_r01"
end type

