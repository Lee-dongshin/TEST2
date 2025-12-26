$PBExportHeader$w_62040_d.srw
$PBExportComments$품번색상별 정상/행사 기준정보
forward
global type w_62040_d from w_com010_e
end type
type dw_1 from datawindow within w_62040_d
end type
type cb_1 from commandbutton within w_62040_d
end type
type cb_2 from commandbutton within w_62040_d
end type
type dw_2 from datawindow within w_62040_d
end type
end forward

global type w_62040_d from w_com010_e
integer width = 3685
dw_1 dw_1
cb_1 cb_1
cb_2 cb_2
dw_2 dw_2
end type
global w_62040_d w_62040_d

type variables
DataWindowChild idw_brand, idw_season, idw_color

String is_brand, is_season, is_year, is_style, is_chno, is_color, is_event_gubn
end variables

on w_62040_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.dw_2
end on

on w_62040_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.dw_2)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_flag, ls_age_grp, ls_jumin , ls_given_fg, ls_given_ymd
String     ls_style,   ls_chno, ls_data , ls_sojae, ls_shop_type, ls_style_k
string     ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_year, ls_season, ls_tel_no, ls_color
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style"				
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "chno", "")
					RETURN 0
				END IF 
				IF gf_style_chk(as_data, '%') = True THEN
				   dw_head.SetItem(al_row, "chno", "")
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "STYLE 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "STYLE LIKE '" + as_data + "%'"
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
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF 
				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				dw_head.SetItem(al_row, "chno",  lds_Source.GetItemString(1,"chno"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("chno")
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

event open;call super::open;dw_head.Setitem(1,'event_gubn', '%')


dw_1.SetTransObject(sqlca)

dw_2.SetTransObject(SQLCA)

end event

event ue_retrieve();
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN




il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_style, is_chno, is_color, is_event_gubn)

dw_1.retrieve(is_brand, is_year, is_season, is_style, is_chno, is_color, is_event_gubn)



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

event type boolean ue_keycheck(string as_cb_div);String   ls_title

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


is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then is_year = '%'

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if


is_style = Trim(dw_head.GetItemString(1, "style"))
if isnull(trim(is_style)) or trim(is_style) = '' then
	is_style = '%'
end if

is_chno = Trim(dw_head.GetItemString(1, "chno"))
if isnull(trim(is_chno)) or trim(is_chno) = "" then
	is_chno = '%'
end if

is_color = Trim(dw_head.GetItemString(1, "color"))
if IsNull(is_color) or is_color = "" then
   MessageBox(ls_title,"색상 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("color")
   return false
end if


is_event_gubn = Trim(dw_head.GetItemString(1, "event_gubn"))



return true






end event

event type long ue_update();call super::ue_update;integer li_result
Datetime ld_datetime
long i, ll_row_count

li_result = MessageBox("경고!", "저장작업을 진행하시겠습니까?" , Exclamation!, OKCancel!, 2)


IF li_result <> 1 THEN
	Return -1
END IF


ll_row_count = dw_body.RowCount()

IF dw_body.AcceptText() <> 1 THEN RETURN -1



/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	If idw_status <> NotModified! Then
			dw_body.Setitem(i, "mod_id", gs_user_id)
			dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT



il_rows     = dw_body.Update(TRUE, FALSE)



if il_rows = 1  then
   dw_body.ResetUpdate()
   commit USING SQLCA;
	dw_body.retrieve(is_brand, is_year, is_season, is_style, is_chno, is_color, is_event_gubn)
else
   rollback USING SQLCA;
	il_rows = -1
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)


return il_rows

end event

event ue_excel();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)

li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
		

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_close from w_com010_e`cb_close within w_62040_d
end type

type cb_delete from w_com010_e`cb_delete within w_62040_d
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_62040_d
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_62040_d
end type

type cb_update from w_com010_e`cb_update within w_62040_d
end type

type cb_print from w_com010_e`cb_print within w_62040_d
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_62040_d
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_62040_d
end type

type cb_excel from w_com010_e`cb_excel within w_62040_d
end type

type dw_head from w_com010_e`dw_head within w_62040_d
integer width = 3552
string dataobject = "d_62040_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()
idw_color.InsertRow(1)
idw_color.SetItem(1, "color", '%')
idw_color.SetItem(1, "color_enm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
	CASE "style"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_62040_d
end type

type ln_2 from w_com010_e`ln_2 within w_62040_d
end type

type dw_body from w_com010_e`dw_body within w_62040_d
string dataobject = "d_62040_d01"
end type

event dw_body::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')



This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')



This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()
end event

type dw_print from w_com010_e`dw_print within w_62040_d
integer x = 2107
integer y = 588
end type

type dw_1 from datawindow within w_62040_d
boolean visible = false
integer x = 1024
integer y = 932
integer width = 1015
integer height = 576
boolean bringtotop = true
string title = "none"
string dataobject = "d_62040_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_62040_d
integer x = 2752
integer y = 320
integer width = 402
integer height = 84
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Excel 업로드"
end type

event clicked;Long   ll_rtn, ll_xls_ret
String ls_filename, ls_name, ls_path, ls_msg, ls_file_name1, ls_shop_type
Long	 i, ll_rowcnt

Oleobject xlapp

SetPointer(HourGlass!)
//dw_c01.AcceptText()
dw_head.AcceptText()

ll_rtn = GetFileOpenName("엑셀파일",   &
			+ ls_filename, ls_name, "XLS", &
			+ " XLS Files (*.XLS),*.XLS")
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
xlApp.Application.Workbooks(1).Saved = TRUE
xlApp.Application.Workbooks.close()
xlApp.Application.Application.Quit
xlApp.DisConnectObject() //엑셀 오브젝트를 파괴한다.


dw_2.Reset()
//데이타 윈도우에 임포트 한다.
dw_2.importfile(ls_file_name1)
		


FileDelete(ls_file_name1)

messagebox('완료', 'Excel 불러오기가 완료되었습니다! ')

		
		
end event

type cb_2 from commandbutton within w_62040_d
integer x = 3159
integer y = 320
integer width = 402
integer height = 84
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Excel 저장"
end type

event clicked;integer li_result
Datetime ld_datetime
long i, ll_row_count
String ls_style, ls_color, ls_chno, ls_size, ls_event_gubn, ls_path


li_result = MessageBox("경고!", "저장작업을 진행하시겠습니까?" , Exclamation!, OKCancel!, 2)


ls_path = dw_head.GetItemString(1, "path")


if trim(ls_path) = '' or isnull(ls_path) then
	messagebox("확인","저장할 파일이 없습니다. 확인해주세요.")
	return -1
end if

IF li_result <> 1 THEN
	Return -1
END IF


ll_row_count = dw_2.RowCount()

IF dw_2.AcceptText() <> 1 THEN RETURN -1



/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


FOR i=1 TO ll_row_count
	ls_style = dw_2.GetItemString(i, "style")
	ls_color = dw_2.GetItemString(i, "color")
	ls_chno = dw_2.GetItemString(i, "chno")
	ls_size = dw_2.GetItemString(i, "size")
	ls_event_gubn = dw_2.GetItemString(i, "event_gubn")
	
	If LenA(ls_style) = 8 Then
		update tb_54060_h set
		event_gubn = :ls_event_gubn,
		mod_id     = :gs_user_id,
		mod_dt     = :ld_datetime
		where style = :ls_style
		  and color = :ls_color
		  and chno  = :ls_chno
		  and size  = :ls_size
		  USING sqlca;
		commit USING SQLCA;
	end if
NEXT



//il_rows     = dw_2.Update(TRUE, FALSE)



//if il_rows = 1  then
   dw_2.Reset()
	dw_head.SetItem(1,"path",'')
	dw_head.SetItem(1,"path_name",'')
	messagebox('확인','엑셀파일이 저장되었습니다.')
//   commit USING SQLCA;
	dw_body.retrieve(is_brand, is_year, is_season, is_style, is_chno, is_color, is_event_gubn)
//else
//   rollback USING SQLCA;
//	il_rows = -1
//end if



return il_rows

end event

type dw_2 from datawindow within w_62040_d
boolean visible = false
integer x = 2331
integer y = 924
integer width = 1015
integer height = 576
boolean bringtotop = true
string title = "none"
string dataobject = "d_62040_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

