$PBExportHeader$w_12038_e.srw
$PBExportComments$Original샘플관리
forward
global type w_12038_e from w_com020_e
end type
type dw_2 from datawindow within w_12038_e
end type
type cb_connect from commandbutton within w_12038_e
end type
type cb_getfile from commandbutton within w_12038_e
end type
type cb_putfile from commandbutton within w_12038_e
end type
type cb_disconnect from commandbutton within w_12038_e
end type
type dw_3 from datawindow within w_12038_e
end type
type dw_4 from datawindow within w_12038_e
end type
type st_2 from statictext within w_12038_e
end type
type dw_1 from datawindow within w_12038_e
end type
end forward

global type w_12038_e from w_com020_e
integer width = 3689
dw_2 dw_2
cb_connect cb_connect
cb_getfile cb_getfile
cb_putfile cb_putfile
cb_disconnect cb_disconnect
dw_3 dw_3
dw_4 dw_4
st_2 st_2
dw_1 dw_1
end type
global w_12038_e w_12038_e

type variables
DataWindowChild idw_brand, idw_child
String is_brand, is_yymmdd, is_fr_yymmdd, is_to_yymmdd, is_sp_file_nm, is_re_file_nm, is_item, is_empno, is_sample_no, is_sample_nm
string is_bit, is_seq_no
boolean bl_connect


end variables

on w_12038_e.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.cb_connect=create cb_connect
this.cb_getfile=create cb_getfile
this.cb_putfile=create cb_putfile
this.cb_disconnect=create cb_disconnect
this.dw_3=create dw_3
this.dw_4=create dw_4
this.st_2=create st_2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.cb_connect
this.Control[iCurrent+3]=this.cb_getfile
this.Control[iCurrent+4]=this.cb_putfile
this.Control[iCurrent+5]=this.cb_disconnect
this.Control[iCurrent+6]=this.dw_3
this.Control[iCurrent+7]=this.dw_4
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.dw_1
end on

on w_12038_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.cb_connect)
destroy(this.cb_getfile)
destroy(this.cb_putfile)
destroy(this.cb_disconnect)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.st_2)
destroy(this.dw_1)
end on

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long	ll_cur_row
string ls_date

if dw_body.AcceptText() <> 1 then return

/* 추가시 수정자료가 있을때 저장여부 확인 */
//if ib_changed then 
//	CHOOSE CASE gf_update_yn(This.title)
//		CASE 1
//			IF This.Trigger Event ue_update() < 1 THEN
//				RETURN
//			END IF		
//		CASE 2
//			ib_changed = false
//		CASE 3
//			RETURN
//	END CHOOSE
//end if

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
END IF

dw_body.  SetRedraw(False)
dw_body.  Reset()
il_rows = dw_body.InsertRow(0)

//ls_date = String(Today(), "yyyymmdd")
dw_body.setitem(1,'yymmdd',String(Today(), "yyyymmdd"))

/*
//접수사례는 고객상담팀에서만 작성할수 있게.
if gs_dept_cd = '3200' or gs_dept_cd = 'T810' or gs_dept_cd = 'S320' or gs_dept_cd = '9000' or gs_dept_cd = 'T500'  then
	dw_body.Modify("receipt_ex.Protect=0")
	dw_body.Object.receipt_ex.background.Color = rgb(255,255,255)
else 
	dw_body.Modify("receipt_ex.Protect=1")
	dw_body.Object.receipt_ex.background.Color = rgb(236,233,216)	
end if
*/
dw_body.SetColumn(ii_min_column_id)
dw_body.SetFocus()
dw_body.SetRedraw(True)

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12038_e","0")
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
	MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("brand")
	return false
end if

is_fr_yymmdd = Trim(dw_head.Getitemstring(1, "fr_yymmdd"))
if IsNull(is_fr_yymmdd) or is_fr_yymmdd = "" then
	MessageBox(ls_title,"조회 시작일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("fr_yymmdd")
	return false
end if

is_to_yymmdd = Trim(dw_head.Getitemstring(1, "to_yymmdd"))
if IsNull(is_to_yymmdd) or is_to_yymmdd = "" then
	MessageBox(ls_title,"조회 종료일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("to_yymmdd")
	return false
end if

is_item = Trim(dw_head.Getitemstring(1, "item"))
is_empno = Trim(dw_head.Getitemstring(1, "empno"))
is_sample_no = Trim(dw_head.Getitemstring(1, "sample_no"))
is_sample_nm = Trim(dw_head.Getitemstring(1, "sample_nm"))



return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk
String     ls_cust_nm, ls_dsgn_nm, ls_dsgn_emp, ls_cust_cd
long 		  ll_ord_qty, ll_sale_qty, ll_receipt_qty
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column

	CASE "empno"
		is_brand = Trim(dw_head.GetItemString(1, "brand"))
			IF ai_div = 1 THEN
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_head.SetItem(al_row, "empno_nm_h", "")
					RETURN 0
				END IF 
			END IF
			
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "구매사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com930"
//			gst_cd.default_where   = " WHERE GOOUT_GUBN = '1' AND brand = '" + is_brand + "'"
			gst_cd.default_where   = " WHERE GOOUT_GUBN = '1' "
	
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "EMPNO LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "empno", lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "empnm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("sample_nm")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source	

	CASE "empno_h"
		is_brand = Trim(dw_head.GetItemString(1, "brand"))
			IF ai_div = 1 THEN
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_head.SetItem(al_row, "empno_nm_h", "")
					RETURN 0
				END IF 
			END IF
			
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "구매사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com930"
			gst_cd.default_where   = " WHERE GOOUT_GUBN = '1' AND brand = '" + is_brand + "'"
	
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "EMPNO LIKE '" + as_data + "%'"
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
				dw_body.SetItem(al_row, "empno", lds_Source.GetItemString(1,"empno"))
				dw_body.SetItem(al_row, "dsgn_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("buy_price")
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

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_fr_yymmdd, is_to_yymmdd, is_brand, is_item, is_empno, is_sample_no, is_sample_nm)
dw_1.retrieve(is_fr_yymmdd, is_to_yymmdd, is_brand, is_item, is_empno, is_sample_no, is_sample_nm)

dw_body.Reset()

IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSE
	dw_body.InsertRow(0)	
	dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;
long i, ll_row_count
datetime ld_datetime
integer li_FileNum,li_FileNum1
blob emp_id_pic
String ls_seq_no, ls_title, ls_filename
string ls_sp_file_nm, ls_sp_string, ls_sp_string1, ls_sp_string2, ls_sp_file
string ls_re_file_nm, ls_re_string, ls_re_string1, ls_re_string2, ls_re_file
uint rtn, wstyle

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

if ll_row_count = 1 then
	/* dw_body 필수입력 column check */
	is_yymmdd = Trim(dw_body.Getitemstring(1, "yymmdd"))
	if IsNull(is_yymmdd) or is_yymmdd = "" then
		MessageBox(ls_title,"의뢰 일자를 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("yymmdd")
		return 0
	end if

end if

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */

		select right(isnull(max(no), 0) + 10001, 4)
		into :ls_seq_no
		from tb_12038_d(nolock) 
		where yymmdd   =  :is_yymmdd
		and brand     =  :is_brand;
	
	   dw_body.Setitem(i, "yymmdd", is_yymmdd)	
	   dw_body.Setitem(i, "no", ls_seq_no)			
      dw_body.Setitem(i, "brand", is_brand)
      dw_body.Setitem(i, "reg_id", gs_user_id)	
      dw_body.Setitem(i, "reg_dt", ld_datetime)
		
		ls_filename = "c:\bnc_dept\rename_1.bat"	
		ls_sp_file_nm = trim(dw_body.getitemstring(1, "sp_file_nm"))
		ls_re_file_nm = trim(dw_body.getitemstring(1, "re_file_nm"))	

		ls_sp_string1 = 'copy ' + ls_sp_file_nm 
		ls_sp_file =  is_yymmdd + is_brand + ls_seq_no + '.jpg'

		ls_re_string1 = 'copy ' + ls_re_file_nm 
		ls_re_file =  is_yymmdd + is_brand + ls_seq_no + '_re.jpg'

	   dw_body.setitem(1, "sp_file_nm", ls_sp_file)
		dw_body.setitem(1, "re_file_nm", ls_re_file)

		if isnull(ls_filename) or ls_filename = "" then
		else	
			wstyle = 0				
			li_FileNum = FileOpen(ls_filename, streamMode!, Write!, Shared!, Replace!)	
			FileWrite(li_FileNum, ls_sp_string1)
			FileClose(li_FileNum)
			rtn = WinExec(ls_filename, wstyle)

			wstyle = 0				
			li_FileNum = FileOpen(ls_filename, streamMode!, Write!, Shared!, Replace!)	
			FileWrite(li_FileNum, ls_re_string1)
			FileClose(li_FileNum)
			rtn = WinExec(ls_filename, wstyle)

		end if	
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */		
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
		
		ls_filename = "c:\bnc_dept\rename_1.bat"
		ls_sp_file_nm = trim(dw_body.getitemstring(1, "sp_file_nm"))
		ls_re_file_nm = trim(dw_body.getitemstring(1, "re_file_nm"))	

		ls_sp_string1 = 'copy ' + ls_sp_file_nm 
		ls_sp_file =  is_yymmdd + is_brand + is_seq_no + '.jpg'
		
		ls_re_string1 = 'copy ' + ls_re_file_nm 
		ls_re_file =  is_yymmdd + is_brand + is_seq_no + '_re.jpg'
		
	   dw_body.setitem(1, "sp_file_nm", ls_sp_file)
		dw_body.setitem(1, "re_file_nm", ls_re_file)
		
		if isnull(ls_filename) or ls_filename = "" then
		else	
			wstyle = 0		
			li_FileNum = FileOpen(ls_filename, streamMode!, Write!, Shared!, Replace!)
			FileWrite(li_FileNum, ls_sp_string1)			
			FileClose(li_FileNum)	
			rtn = WinExec(ls_filename, wstyle)

			li_FileNum = FileOpen(ls_filename, streamMode!, Write!, Shared!, Replace!)
			FileWrite(li_FileNum, ls_re_string1)			
			FileClose(li_FileNum)	
			rtn = WinExec(ls_filename, wstyle)

		end if		
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
   dw_body.setitem(1, "sp_file_nm", "")
   dw_body.setitem(1, "re_file_nm", "")
	
//	FTP 이미지 전송시작//
	//샘플이미지
	dw_2.setitem(1,'addr','220.118.68.4')
	dw_2.setitem(1,'id','sample_up')
	dw_2.setitem(1,'pwd','puelpmas')
	dw_2.setitem(1,'remotefile', ls_sp_file)
	dw_2.setitem(1,'rocalfile', ls_sp_file_nm)
	cb_Connect.triggerevent (clicked!)
	cb_PutFile.triggerevent (clicked!)
	cb_DisConnect.triggerevent (clicked!)
	//영수증이미지
	dw_2.reset()
	dw_2.insertrow(0)
	dw_2.setitem(1,'addr','220.118.68.4')
	dw_2.setitem(1,'id','sample_up')
	dw_2.setitem(1,'pwd','puelpmas')
	dw_2.setitem(1,'remotefile', ls_re_file)
	dw_2.setitem(1,'rocalfile', ls_re_file_nm)	
	cb_Connect.triggerevent (clicked!)
	cb_PutFile.triggerevent (clicked!)
	cb_DisConnect.triggerevent (clicked!)
	
	dw_4.visible = false
	dw_3.visible = false

//	FTP 이미지 전송끝//

//	dw_list.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_item, is_empno, is_sample_nm)
//	dw_body.retrieve(is_yymmdd, is_brand, ls_seq_no)
	This.Trigger Event ue_retrieve()
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
	CASE 1		/* 조회 */
		cb_retrieve.Text = "조건(&Q)"
		dw_head.Enabled = false
		dw_list.Enabled = true
		cb_excel.enabled = true
		If al_rows <= 0 Then
			dw_body.Enabled = true
		End If
	CASE 2   /* 추가 */
		if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = true
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_list.Enabled = true
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
//         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled  = true
         cb_print.enabled   = true
         cb_preview.enabled = true
//         cb_excel.enabled   = true
			dw_body.enabled    = true
		else
         cb_delete.enabled  = false
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
//         cb_insert.enabled = true
      end if
END CHOOSE

end event

event pfc_dberror();//
end event

event open;call super::open;STRING ls_filename, LS_STRING
uint rtn, wstyle
long li_filenum

/*
ls_filename = "c:\bnc_dept\rename_1.bat"
ls_string = 'md C:\sample\sp_img\N'  
//net use \\220.118.68.4\sample\sp_img\N puelpmas /user:sample_up
wstyle = 0		

li_FileNum = FileOpen(ls_filename, streamMode!, Write!, Shared!, Replace!)
FileWrite(li_FileNum, ls_string)	
FileClose(li_FileNum)
rtn = WinExec(ls_filename, wstyle)		

*/
end event

event pfc_preopen();call super::pfc_preopen;string ls_date

ls_date = String(Today(), "yyyymmdd")
dw_head.setitem(1,'fr_yymmdd',MidA(ls_date,1,6)+'01')
dw_head.setitem(1,'to_yymmdd',ls_date)
end event

event ue_excel();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
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

type cb_close from w_com020_e`cb_close within w_12038_e
end type

type cb_delete from w_com020_e`cb_delete within w_12038_e
end type

type cb_insert from w_com020_e`cb_insert within w_12038_e
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_12038_e
end type

type cb_update from w_com020_e`cb_update within w_12038_e
end type

type cb_print from w_com020_e`cb_print within w_12038_e
end type

type cb_preview from w_com020_e`cb_preview within w_12038_e
end type

type gb_button from w_com020_e`gb_button within w_12038_e
end type

type cb_excel from w_com020_e`cb_excel within w_12038_e
end type

type dw_head from w_com020_e`dw_head within w_12038_e
integer width = 3506
integer height = 160
string dataobject = "d_12038_h01"
end type

event dw_head::buttonclicking;call super::buttonclicking;///* 화일 탐색 */
//string  ls_path, ls_file_nm
//integer li_value
//string ls_column_nm, ls_column_value, ls_report
//
//// cb_file_nm
//IF Pos(dwo.name, "cb_") = 0 THEN RETURN
//
//ls_column_nm = Mid(dwo.name, 4)
//
//
////case dw.name
//if ls_column_nm = "file_nm" then
//		li_value = GetFileOpenName("Select File", ls_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")
//		
//		IF li_value = 1 THEN 
//			dw_head.Setitem(1, "file_nm", ls_path)
//			dw_1.reset()
//			dw_1.insertrow(0)
//			dw_1.setitem(1, "pic", ls_path)
//			dw_1.visible = true
//		END IF
//end if
end event

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child

This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("item", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve(gs_brand)
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "item", '%')
ldw_child.SetItem(1, "item_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "empno_h","empno"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

type ln_1 from w_com020_e`ln_1 within w_12038_e
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com020_e`ln_2 within w_12038_e
integer beginy = 360
integer endy = 360
end type

type dw_list from w_com020_e`dw_list within w_12038_e
integer y = 356
integer width = 1285
integer height = 1640
string dataobject = "d_12038_d01"
end type

event dw_list::clicked;call super::clicked;string ls_yymmdd, ls_ftp_sp_add, ls_ftp_re_add, ls_sp_serial, ls_sp_serial_1, ls_re_serial, ls_re_serial_1
boolean lb_exist

IF row <= 0 THEN Return

//IF ib_changed THEN 
//  	CHOOSE CASE gf_update_yn(Parent.title)
//		CASE 1
//			IF Parent.Trigger Event ue_update() < 1 THEN
//				RETURN 1
//			END IF		
//		CASE 3
//			RETURN 1
//	END CHOOSE
//END IF
//	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

//is_seq_no = This.GetItemString(row, 'seq_no') /* DataWindow에 Key 항목을 가져온다 */
is_yymmdd = This.GetItemString(row, 'yymmdd') /* DataWindow에 Key 항목을 가져온다 */
is_seq_no = This.GetItemString(row, 'no')

IF IsNull(is_seq_no) THEN return
il_rows = dw_body.retrieve(is_yymmdd, is_brand, is_seq_no)

ls_ftp_sp_add = '\\220.118.68.4\photo\sample\'
ls_ftp_re_add = '\\220.118.68.4\photo\sample\'

select yymmdd + brand + no + '.jpg'			AS sp_SERIAL,
       yymmdd + brand + '0001' + '.jpg'	AS sp_SERIAL1,
       yymmdd + brand + no + '_re.jpg'			AS re_SERIAL,
       yymmdd + brand + '0001' + '_re.jpg'	AS re_SERIAL1
into :ls_sp_serial, :ls_sp_serial_1, :ls_re_serial, :ls_re_serial_1
from tb_12038_d (nolock)
where yymmdd = :is_yymmdd
		and brand = :is_brand
		and no = :is_seq_no;

lb_exist = FileExists(ls_ftp_sp_add + ls_sp_serial)

if lb_exist = true then
	dw_body.setitem(1, 'sp_serial', ls_ftp_sp_add + ls_sp_serial)
	dw_body.setitem(1, 'sp_file_nm', ls_sp_serial)
else
	dw_body.setitem(1, 'sp_serial', '')
	dw_body.setitem(1, 'sp_file_nm', '저장된 샘플 사진이 없습니다!')
/*	
	lb_exist = FileExists(ls_ftp_sp_add + ls_sp_serial_1)
	if lb_exist = true then
		dw_body.setitem(1, 'sp_serial', ls_ftp_sp_add + ls_sp_serial_1)
		dw_body.setitem(1, 'sp_file_nm', ls_sp_serial_1)
	else
		dw_body.setitem(1, 'sp_serial', '')
		dw_body.setitem(1, 'sp_file_nm', '저장된 샘플 사진이 없습니다!')
	end if
*/
end if

lb_exist = FileExists(ls_ftp_re_add + ls_re_serial)

if lb_exist = true then
	dw_body.setitem(1, 're_serial', ls_ftp_re_add + ls_re_serial)
	dw_body.setitem(1, 're_file_nm', ls_re_serial)
else
	dw_body.setitem(1, 're_serial', '')
	dw_body.setitem(1, 're_file_nm', '저장된 영수증 사진이 없습니다!')
/*	
	lb_exist = FileExists(ls_ftp_re_add + ls_re_serial_1)
	if lb_exist = true then
		dw_body.setitem(1, 're_serial', ls_ftp_re_add + ls_re_serial_1)
		dw_body.setitem(1, 're_file_nm', ls_re_serial_1)
	else
		dw_body.setitem(1, 're_serial', '')
		dw_body.setitem(1, 're_file_nm', '저장된 영수증 사진이 없습니다!')
	end if
*/
end if

//dw_1.setitem(1, "pic", '')

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_e`dw_body within w_12038_e
integer x = 1339
integer y = 356
integer width = 2267
integer height = 1644
string dataobject = "D_12038_D02"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_body::itemchanged;call super::itemchanged;/* 화일 탐색 */
string  ls_path, ls_file_nm
integer li_value
string ls_column_nm, ls_column_value, ls_report
string ls_style, ls_chno, ls_judg_l, ls_judg_s, ls_serial

CHOOSE CASE dwo.name
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	
//	case "receipt_ex"
//		ls_style = dw_body.getitemstring(1, 'style')
//		ls_chno = dw_body.getitemstring(1, 'chno')
//		ls_judg_l = dw_body.getitemstring(1, 'judg_l')
//		ls_judg_s = dw_body.getitemstring(1, 'judg_s')
//
//		select top 1 '\\220.118.68.4\photo\claim_ex\' + style + chno + judg_l + judg_s + '0001' + '.jpg'		AS SERIAL
//		into :ls_serial
//		from tb_79012_h (nolock)
//		where style = :ls_style
//				and judg_l = :ls_judg_l
//				and judg_s = :ls_judg_s;
//		if isnull(ls_serial) or ls_serial = '' then
//			dw_body.setitem(1, 'serial', '')
//		else
//			dw_body.setitem(1, 'serial', ls_serial)
//		end if
	
END CHOOSE




end event

event dw_body::dberror;//
end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		If dw_body.GetColumnName() = 'receipt_ex' OR dw_body.GetColumnName() <> 'dept_opinion' OR dw_body.GetColumnName() <> 'how_handle'Then
			RETURN 0
		else  
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		END IF	



	CASE KeyUpArrow!, KeyDownArrow!, KeyPageUp!, KeyPageDown!
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
		// Column.Protect = True Then Return
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0 
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0 
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

Return 0

end event

event dw_body::buttonclicking;call super::buttonclicking;/* 화일 탐색 */
string  ls_sp_path, ls_sp_file_nm, ls_re_path, ls_re_file_nm
integer li_value
string ls_column_nm, ls_column_value, ls_report

// cb_file_nm
IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

//case dw.name
if ls_column_nm = "sp_file_nm" then
	li_value = GetFileOpenName("Select File", ls_sp_path, ls_sp_file_nm, "JPG", "image Files (*.JPG),*.JPG, *.JPEG")
	
	IF li_value = 1 THEN 
		dw_body.Setitem(1, "sp_file_nm", ls_sp_path)
//		dw_body.Setitem(1, "sp_file_nm", ls_sp_file_nm)
		cb_update.enabled = true
		dw_4.reset()
		dw_4.insertrow(0)
		dw_4.setitem(1, "pic", ls_sp_path)
		dw_4.visible = true
	else	
		is_sp_file_nm = ""
	END IF
end if

if ls_column_nm = "re_file_nm" then
	li_value = GetFileOpenName("Select File", ls_re_path, ls_re_file_nm, "JPG", "image Files (*.JPG),*.JPG, *.JPEG")
	
	IF li_value = 1 THEN 
		dw_body.Setitem(1, "re_file_nm", ls_re_path)
//		dw_body.Setitem(1, "re_file_nm", ls_path)
		cb_update.enabled = true
		dw_3.reset()
		dw_3.insertrow(0)
		dw_3.setitem(1, "pic", ls_re_path)
		dw_3.visible = true
	else	
		is_re_file_nm = ""
	END IF
end if

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child

This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

This.GetChild("item", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve(gs_brand)
ldw_child.InsertRow(1)
//ldw_child.SetItem(1, "item", '%')
//ldw_child.SetItem(1, "item_nm", '전체')

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;/* 화일 탐색 */
/*
string  ls_path, ls_file_nm
integer li_value
string ls_column_nm, ls_column_value, ls_report
string ls_style, ls_chno, ls_judg_l, ls_judg_s, ls_ftp_add, ls_serial, ls_serial_1
boolean lb_exist


CHOOSE CASE dwo.name
	CASE "judg_s"
		ls_judg_l = This.GetItemString(row, "judg_l")
		idw_judg_s.Retrieve('796', ls_judg_l)
		idw_judg_s.InsertRow(1)
		idw_judg_s.SetItem(1, "inter_cd", '')
		idw_judg_s.SetItem(1, "inter_nm", '')

		
	case "receipt_ex"
		ls_style = dw_body.getitemstring(1, 'style')
		ls_chno = dw_body.getitemstring(1, 'chno')
		ls_judg_l = dw_body.getitemstring(1, 'judg_l')
		ls_judg_s = dw_body.getitemstring(1, 'judg_s')
		ls_ftp_add = '\\220.118.68.4\photo\claim_ex\'
		
		select top 1 style + chno + judg_l + judg_s + seq_no + '.jpg'		AS SERIAL,
						 style + chno + judg_l + judg_s + '0001' + '.jpg'	   AS SERIAL_1
		into :ls_serial, :ls_serial_1
		from tb_79012_h (nolock)
		where style = :ls_style
				and judg_l = :ls_judg_l
				and judg_s = :ls_judg_s;

		//파일의 유무확인
		lb_exist = FileExists(ls_ftp_add + ls_serial)
		
		if lb_exist = true then
			dw_body.setitem(1, 'serial', ls_ftp_add + ls_serial)
			dw_body.setitem(1, 'file_nm', ls_serial)
		else
			lb_exist = FileExists(ls_ftp_add + ls_serial_1)
			if lb_exist = true then
				dw_body.setitem(1, 'serial', ls_ftp_add + ls_serial_1)
				dw_body.setitem(1, 'file_nm', ls_serial_1)
			else
				dw_body.setitem(1, 'serial', '')
				dw_body.setitem(1, 'file_nm', '저장된 사진이 없습니다!')
			end if
		end if
	

END CHOOSE
*/
end event

type st_1 from w_com020_e`st_1 within w_12038_e
integer x = 1317
integer y = 356
integer height = 1692
end type

type dw_print from w_com020_e`dw_print within w_12038_e
integer x = 475
integer y = 284
integer height = 760
string dataobject = "d_12038_r01"
end type

event dw_print::constructor;call super::constructor;DataWindowChild ldw_child


This.GetChild("item", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve(gs_brand)
ldw_child.InsertRow(1)

end event

type dw_2 from datawindow within w_12038_e
boolean visible = false
integer x = 1015
integer y = 208
integer width = 1893
integer height = 548
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_12038_d04"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;dw_2.SetTransObject(SQLCA)
dw_2.insertrow(0)

dw_2.setitem(1,'addr','220.118.68.4')
dw_2.setitem(1,'id','sample_up')
dw_2.setitem(1,'pwd','puelpmas')
dw_2.setitem(1,'remotefile','')
//dw_2.setitem(1,'rocalfile','C:\sample\')
//dw_2.setitem(1,'rocalfile','C:\sample\sp_img\')



bl_connect = false
u_ftp = create nvo_ftp
end event

type cb_connect from commandbutton within w_12038_e
boolean visible = false
integer x = 2985
integer y = 120
integer width = 402
integer height = 84
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Connect"
end type

event clicked;string ls_column_nm, ls_addr, ls_id, ls_pwd, ls_remote, ls_rocal
int li_rtn

ls_addr = dw_2.getitemstring(1,'addr')
ls_id = dw_2.getitemstring(1,'id')
ls_pwd = dw_2.getitemstring(1, 'pwd')

if bl_connect = true then
	MessageBox("확인", "FTP 가 이미 연결되었습니다.")
	return
end if

li_rtn = gf_ftp_connect(ls_addr,ls_id,ls_pwd)	

IF li_rtn = 1 then
	bl_connect = true
//	MessageBox("","FTP 성공")
ELSEIF li_rtn = -1 THEN
	MessageBox("확인","FTP 연결 실패")
	return
END IF

setpointer(HourGlass!)
string rtn
//rtn = uf_remote_dirlist('/ex/')
rtn = gf_ftp_remote_dirlist('')
setpointer(Arrow!)



end event

type cb_getfile from commandbutton within w_12038_e
boolean visible = false
integer x = 2985
integer y = 208
integer width = 402
integer height = 84
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "GetFile"
end type

event clicked;string ls_column_nm, ls_addr, ls_id, ls_pwd, ls_remote, ls_rocal
int li_rtn

ls_remote = dw_2.getitemstring(1, 'remotefile')
ls_rocal = dw_2.getitemstring(1, 'rocalfile')

setpointer(HourGlass!)
If gf_ftp_asc_chk(ls_remote) = 1 Then  // 텍스트
	li_rtn = gf_ftp_Getfile(ls_remote, ls_rocal, True )
Else // 이진
	li_rtn = gf_ftp_Getfile(ls_remote, ls_rocal, False)
End If	

setpointer(Arrow!)

If li_rtn = 1 Then
	messagebox('','파일다운로드 성공 !!!!!')	 		 
Else
	messagebox('','파일다운로드 실패 !!!!!')	 		 
End If 	 

end event

type cb_putfile from commandbutton within w_12038_e
boolean visible = false
integer x = 2985
integer y = 292
integer width = 402
integer height = 84
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "PutFile"
end type

event clicked;string  ls_remote, ls_rocal
int li_rtn

ls_remote = dw_2.getitemstring(1, 'remotefile')
ls_rocal = dw_2.getitemstring(1, 'rocalfile')

setpointer(HourGlass!)
If gf_ftp_asc_chk(ls_rocal) = 1 Then  // 텍스트
	li_rtn = gf_ftp_putfile(ls_rocal, ls_remote, True )
Else // 이진
	li_rtn = gf_ftp_putfile(ls_rocal, ls_remote, False)
End If	

setpointer(Arrow!)	
If li_rtn = 1 Then
//	messagebox('','파일업로드 성공 !!!!!')	 		 
Else
//	messagebox('',ls_remote+' 파일 업로드 실패 !!!!!')
End If 	 

end event

type cb_disconnect from commandbutton within w_12038_e
boolean visible = false
integer x = 3305
integer y = 308
integer width = 402
integer height = 84
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "DisConnect"
end type

event clicked;int li_rtn

if bl_connect = false then
	Messagebox("DisConnect확인", "먼저 FTP 연결을 확인하십시요")
	return
end if

li_rtn = gf_ftp_disconnect()

if li_rtn = 1 then
//	MessageBox("", "FTP 종료")
	bl_connect = false
elseif li_rtn = -1 then
//	MessageBox("", "FTP 종료실패")
end if


end event

type dw_3 from datawindow within w_12038_e
boolean visible = false
integer x = 2990
integer y = 656
integer width = 1723
integer height = 1344
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "영수증사진보기"
string dataobject = "d_12038_d03"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
borderstyle borderstyle = stylelowered!
end type

type dw_4 from datawindow within w_12038_e
boolean visible = false
integer x = 1257
integer y = 656
integer width = 1723
integer height = 1344
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "샘플사진보기"
string dataobject = "d_12038_d03"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_12038_e
integer x = 2953
integer y = 176
integer width = 1490
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "* 이미지 싸이즈 : 가로 355(픽셀), 세로 442(픽셀)"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_12038_e
boolean visible = false
integer x = 370
integer y = 564
integer width = 1627
integer height = 840
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_12038_d05"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;dw_1.SetTransObject(SQLCA)
dw_1.insertrow(0)

end event

