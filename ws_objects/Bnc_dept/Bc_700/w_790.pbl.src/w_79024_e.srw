$PBExportHeader$w_79024_e.srw
$PBExportComments$불량유형관리
forward
global type w_79024_e from w_com020_e
end type
type dw_1 from datawindow within w_79024_e
end type
type dw_2 from datawindow within w_79024_e
end type
type cb_connect from commandbutton within w_79024_e
end type
type cb_getfile from commandbutton within w_79024_e
end type
type cb_putfile from commandbutton within w_79024_e
end type
type cb_disconnect from commandbutton within w_79024_e
end type
end forward

global type w_79024_e from w_com020_e
integer width = 3634
dw_1 dw_1
dw_2 dw_2
cb_connect cb_connect
cb_getfile cb_getfile
cb_putfile cb_putfile
cb_disconnect cb_disconnect
end type
global w_79024_e w_79024_e

type variables
DataWindowChild idw_brand, idw_child, idw_judg_s
String is_brand, is_yymmdd, is_fr_yymmdd, is_to_yymmdd, is_seq_no, is_file_nm, is_receipt_type, is_judg_l, is_judg_s, is_style, is_chno
string is_bit
boolean bl_connect


end variables

on w_79024_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.cb_connect=create cb_connect
this.cb_getfile=create cb_getfile
this.cb_putfile=create cb_putfile
this.cb_disconnect=create cb_disconnect
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.cb_connect
this.Control[iCurrent+4]=this.cb_getfile
this.Control[iCurrent+5]=this.cb_putfile
this.Control[iCurrent+6]=this.cb_disconnect
end on

on w_79024_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.cb_connect)
destroy(this.cb_getfile)
destroy(this.cb_putfile)
destroy(this.cb_disconnect)
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

//접수사례는 고객상담팀에서만 작성할수 있게.
if gs_dept_cd = '3200' or gs_dept_cd = 'T810' or gs_dept_cd = 'S320' or gs_dept_cd = '9000' or gs_dept_cd = 'T500'  then
	dw_body.Modify("receipt_ex.Protect=0")
	dw_body.Object.receipt_ex.background.Color = rgb(255,255,255)
else 
	dw_body.Modify("receipt_ex.Protect=1")
	dw_body.Object.receipt_ex.background.Color = rgb(236,233,216)	
end if

dw_body.SetColumn(ii_min_column_id)
dw_body.SetFocus()
dw_body.SetRedraw(True)

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_79015_e","0")
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


if is_brand = "V" or is_brand = "B" or is_brand = "F" or is_brand = "L" then
			messagebox("주의", "이터널 브랜드의 경우 이터널영업관리를 이용하세요!")
			  return false
//			return -1
//			Return 0
End if		

//is_fr_yymmdd = Trim(String(dw_head.GetItemDate(1, "fr_yymmdd"), 'yyyymmdd'))
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

is_judg_l = Trim(dw_head.GetItemString(1, "judg_l"))
if IsNull(is_judg_l) or is_judg_l = "" then
	is_judg_l = '%'
end if

is_judg_s = Trim(dw_head.GetItemString(1, "judg_s"))
if IsNull(is_judg_s) or is_judg_s = "" then
	is_judg_s = '%'
end if

is_style = Trim(dw_head.GetItemString(1, "style"))
if IsNull(is_style) or is_style = "" then
	is_style = '%'
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or is_chno = "" then
	is_chno = '%'
end if

is_receipt_type = Trim(dw_head.GetItemString(1, "receipt_type"))

//elseif is_bit = '2' then
//	is_yymmdd = Trim(String(dw_body.GetItemDate(1, "yymmdd"), 'yyyymmdd'))
//	if IsNull(is_yymmdd) or is_yymmdd = "" then
//	   MessageBox(ls_title,"의뢰 일자를 입력하십시요!")
//	   dw_body.SetFocus()
//	   dw_body.SetColumn("yymmdd")
//	   return false
//	end if
//	
//	is_judg_l = Trim(dw_body.GetItemString(1, "judg_l"))
//	if IsNull(is_judg_l) or is_judg_l = "" then
//		MessageBox(ls_title,"판정 대분류를 입력하십시요!")
//		dw_body.SetFocus()
//		dw_body.SetColumn("is_judg_l")
//		return false
//	end if
//	
//	is_judg_s = Trim(dw_body.GetItemString(1, "judg_s"))
//	if IsNull(is_judg_s) or is_judg_s = "" then
//		MessageBox(ls_title,"판정 소분류를 입력하십시요!")
//		dw_body.SetFocus()
//		dw_body.SetColumn("is_judg_s")
//		return false
//	end if
//	
//	is_style = Trim(dw_body.GetItemString(1, "style"))
//	if IsNull(is_style) or is_style = "" then
//		MessageBox(ls_title,"품번을 입력하십시요!")
//		dw_body.SetFocus()
//		dw_body.SetColumn("is_style")
//		return false
//	end if
//	
//	is_chno = dw_body.GetItemString(1, "chno")
//	if IsNull(is_chno) or is_chno = "" then
//		MessageBox(ls_title,"차순을 입력하십시요!")
//		dw_body.SetFocus()
//		dw_body.SetColumn("is_chno")
//		return false
//	end if
//end if
//is_seq_no = Trim(dw_body.GetItemString(1, "seq_no"))
//if IsNull(is_seq_no) or is_seq_no = "" then
//	is_seq_no = '%'
//end if

//is_receipt_type = Trim(dw_head.GetItemString(1, "receipt_type"))

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

	CASE "style"		

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "WHERE brand = '" + is_brand + "' " 
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + as_data + "%'" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lb_check = FALSE 
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				
				dw_body.SetItem(al_row, "style",    lds_Source.GetItemString(1,"style"))
				dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno"))
				dw_body.SetItem(al_row, "cust_cd",  lds_Source.GetItemString(1,"cust_cd"))				
				dw_body.SetItem(al_row, "year",     lds_Source.GetItemString(1,"year"))				
				dw_body.SetItem(al_row, "season",  lds_Source.GetItemString(1,"season"))								
				
				ls_cust_cd = lds_Source.GetItemString(1,"cust_cd")
				ls_style = lds_Source.GetItemString(1,"style")
				ls_chno  = lds_Source.GetItemString(1,"chno")
				
				select dsgn_emp, dbo.sf_emp_nm(dsgn_emp), dbo.sf_cust_nm(:ls_cust_cd, 's')
				into :ls_dsgn_emp, :ls_dsgn_nm, :ls_cust_nm
				from tb_12020_m (nolock)
				where style = :ls_style;
				
				dw_body.SetItem(al_row, "dsgn_emp",  ls_dsgn_emp)								
				dw_body.SetItem(al_row, "dsgn_nm",  ls_dsgn_nm)								
				dw_body.SetItem(al_row, "cust_nm",  ls_cust_nm)												
				
				select sum(ord_qty), sum(sale_qty)
				into :ll_ord_qty, :ll_sale_qty
				from tb_12030_s (nolock)
				where style = :ls_style
				  and chno  = :ls_chno;

				dw_body.SetItem(al_row, "ord_qty", ll_ord_qty)								
				dw_body.SetItem(al_row, "sale_qty", ll_sale_qty)								

				string ls_judg_s
				ls_judg_s = dw_body.getitemstring(1,'judg_s')
				SELECT COUNT(SEQ_NO)
				 into :ll_receipt_qty
				 FROM TB_79011_D  (NOLOCK)
				 WHERE STYLE = :ls_style
					AND CHNO  = :ls_chno
					ANd JUDG_S = :ls_judg_s;
//				AND ISNULL(JUDG_FG, '0') IN ('1','2');				
					
				dw_body.SetItem(al_row, "receipt_qty", ll_receipt_qty)								
				
				ib_changed = true
				cb_update.enabled = true
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("receipt_ex")
				lb_check = TRUE 
				ib_itemchanged = FALSE
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

//messagebox('is_brand',is_brand)
//messagebox('is_fr_yymmdd',is_fr_yymmdd)
//messagebox('is_to_yymmdd',is_to_yymmdd)
//messagebox('is_style',is_style)
//messagebox('is_chno',is_chno)
//messagebox('is_judg_l',is_judg_l)
//messagebox('is_judg_s',is_judg_s)
//messagebox('is_receipt_type',is_receipt_type)
il_rows = dw_list.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_style, is_chno, is_judg_l, is_judg_s, is_receipt_type)

//is_brand, is_fr_yymmdd, is_to_yymmdd, is_style, is_chno, is_judg_l, is_judg_s, is_receipt_type

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
String ls_file_nm, ls_seq_no
string ls_filename, ls_string,ls_string1,ls_string2, ls_title, ls_file
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
	
	is_judg_l = Trim(dw_body.GetItemString(1, "judg_l"))
	if IsNull(is_judg_l) or is_judg_l = "" then
		MessageBox(ls_title,"판정 대분류를 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("is_judg_l")
		return 0
	end if
	
	is_judg_s = Trim(dw_body.GetItemString(1, "judg_s"))
	if IsNull(is_judg_s) or is_judg_s = "" then
		MessageBox(ls_title,"판정 소분류를 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("is_judg_s")
		return 0
	end if
	
	is_style = Trim(dw_body.GetItemString(1, "style"))
	if IsNull(is_style) or is_style = "" then
		MessageBox(ls_title,"품번을 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("is_style")
		return 0
	end if
	
	is_chno = dw_body.GetItemString(1, "chno")
	if IsNull(is_chno) or is_chno = "" then
		MessageBox(ls_title,"차순을 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("is_chno")
		return 0
	end if
end if
	



FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */

		select right(isnull(max(seq_no), 0) + 10001, 4)
		into :ls_seq_no
		from tb_79012_h(nolock) 
		where yymmdd    =  :is_yymmdd
		and brand     =  :is_brand;
	
	   dw_body.Setitem(i, "yymmdd", is_yymmdd)	
	   dw_body.Setitem(i, "seq_no", ls_seq_no)			
      dw_body.Setitem(i, "brand", is_brand)
      dw_body.Setitem(i, "reg_id", gs_user_id)	
      dw_body.Setitem(i, "receipt_type", is_receipt_type)		

		ls_filename = "c:\bnc_dept\rename.bat"	
		ls_file_nm = trim(dw_body.getitemstring(1, "file_nm"))	
		ls_string1 = 'copy ' + ls_file_nm + '  c:\claim\' + is_style + is_chno + is_judg_l + is_judg_s + ls_seq_no + '.jpg'
		ls_file =  is_style + is_chno + is_judg_l + is_judg_s + ls_seq_no + '.jpg'
		
		if isnull(ls_filename) or ls_filename = "" then
		else	
			wstyle = 0				
			li_FileNum = FileOpen(ls_filename, streamMode!, Write!, Shared!, Replace!)	
			FileWrite(li_FileNum, ls_string1)
			FileClose(li_FileNum)
			rtn = WinExec(ls_filename, wstyle)
		end if
	
//   dw_1.setitem(1, "pic",  'c:\claim\' +  is_brand + is_yymmdd + ls_seq_no + '.jpg' )	
		
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */		
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
		
		ls_filename = "c:\bnc_dept\rename.bat"
		ls_file_nm = trim(dw_body.getitemstring(1, "file_nm"))
		ls_string1 = 'copy ' + ls_file_nm + '  c:\claim\' + is_style + is_chno + is_judg_l + is_judg_s + ls_seq_no + '.jpg'
		ls_file =  is_style + is_chno + is_judg_l + is_judg_s + ls_seq_no + '.jpg'

		if isnull(ls_filename) or ls_filename = "" then
		else	
			wstyle = 0		
			li_FileNum = FileOpen(ls_filename, streamMode!, Write!, Shared!, Replace!)
			FileWrite(li_FileNum, ls_string1)			
			FileClose(li_FileNum)	
			rtn = WinExec(ls_filename, wstyle)
		end if		
//		dw_1.setitem(1, "pic",  'c:\claim\' +  is_brand + is_yymmdd + is_seq_no + '.jpg' )			
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
   dw_body.setitem(1, "file_nm", "")
	
//	FTP 이미지 전송시작//
	dw_2.setitem(1,'addr','220.118.68.4')
	dw_2.setitem(1,'id','photo_claim')
	dw_2.setitem(1,'pwd','zmffpdla')
	dw_2.setitem(1,'remotefile', ls_file)
	dw_2.setitem(1,'rocalfile', 'C:\claim\' + ls_file)
	cb_Connect.triggerevent (clicked!)
	cb_PutFile.triggerevent (clicked!)
	cb_DisConnect.triggerevent (clicked!)
//	FTP 이미지 전송끝//

//	dw_list.retrieve(is_yymmdd, is_brand)
//	dw_list.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_style, is_chno, is_judg_l, is_judg_s, is_receipt_type)
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
		If al_rows <= 0 Then
			dw_body.Enabled = true
		End If
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
         cb_excel.enabled   = true
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

ls_filename = "c:\bnc_dept\rename.bat"
ls_string = 'md C:\claim'  

wstyle = 0		

li_FileNum = FileOpen(ls_filename, streamMode!, Write!, Shared!, Replace!)
FileWrite(li_FileNum, ls_string)	
FileClose(li_FileNum)
rtn = WinExec(ls_filename, wstyle)		



end event

event pfc_preopen();call super::pfc_preopen;string ls_date

ls_date = String(Today(), "yyyymmdd")
dw_head.setitem(1,'fr_yymmdd',MidA(ls_date,1,6)+'01')
dw_head.setitem(1,'to_yymmdd',ls_date)
end event

type cb_close from w_com020_e`cb_close within w_79024_e
end type

type cb_delete from w_com020_e`cb_delete within w_79024_e
end type

type cb_insert from w_com020_e`cb_insert within w_79024_e
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_79024_e
end type

type cb_update from w_com020_e`cb_update within w_79024_e
end type

type cb_print from w_com020_e`cb_print within w_79024_e
end type

type cb_preview from w_com020_e`cb_preview within w_79024_e
end type

type gb_button from w_com020_e`gb_button within w_79024_e
end type

type cb_excel from w_com020_e`cb_excel within w_79024_e
end type

type dw_head from w_com020_e`dw_head within w_79024_e
integer width = 3506
integer height = 160
string dataobject = "d_79024_h01"
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

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child, ldw_judg_s

This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("judg_l", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('795')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("judg_s", ldw_judg_s)
ldw_judg_s.SetTransObject(SQLCA)
ldw_judg_s.Retrieve('796','%')
ldw_judg_s.InsertRow(1)
ldw_judg_s.SetItem(1, "inter_cd", '')
ldw_judg_s.SetItem(1, "inter_nm", '')


end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;String ls_judg_l
DataWindowChild ldw_judg_s
CHOOSE CASE dwo.name
	CASE "judg_s"		
		This.GetChild("judg_s", ldw_judg_s)
		ls_judg_l = This.GetItemString(row, "judg_l")
		ldw_judg_s.Retrieve('796', ls_judg_l)
		ldw_judg_s.InsertRow(1)
		ldw_judg_s.SetItem(1, "inter_cd", '')
		ldw_judg_s.SetItem(1, "inter_nm", '')
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_79024_e
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com020_e`ln_2 within w_79024_e
integer beginy = 360
integer endy = 360
end type

type dw_list from w_com020_e`dw_list within w_79024_e
integer y = 356
integer height = 1692
string dataobject = "d_79024_d01"
end type

event dw_list::clicked;call super::clicked;string ls_yymmdd, ls_judg_l, ls_judg_s, ls_style, ls_ftp_add, ls_serial, ls_serial_1, ls_seq_no
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
ls_seq_no = This.GetItemString(row, 'seq_no')
ls_style  = This.getitemstring(row, 'style')
ls_judg_l = This.getitemstring(row, 'judg_l')
ls_judg_s = This.getitemstring(row, 'judg_s')

IF IsNull(is_seq_no) THEN return
il_rows = dw_body.retrieve(is_yymmdd, ls_seq_no, is_brand, is_receipt_type)

ls_ftp_add = '\\220.118.68.4\photo\claim_ex\'

/*
select style + chno + judg_l + judg_s + max(seq_no) + '.jpg'		AS SERIAL,
		 style + chno + judg_l + judg_s + '0001' + '.jpg'			   AS SERIAL_1
into :ls_serial, :ls_serial_1
from tb_79012_h (nolock)
where style = :ls_style
		and judg_l = :ls_judg_l
		and judg_s = :ls_judg_s
group by style, chno, judg_l, judg_s;
*/

select style + chno + judg_l + judg_s + seq_no + '.jpg'	AS SERIAL,
       style + chno + judg_l + judg_s + '0001' + '.jpg'	AS SERIAL1
into :ls_serial, :ls_serial_1
from tb_79012_h (nolock)
where style = :ls_style
		and judg_l = :ls_judg_l
		and judg_s = :ls_judg_s
		and seq_no = :ls_seq_no;

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
		
dw_head.setitem(1, "seq_no", is_seq_no)

dw_1.setitem(1, "pic", '')

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_e`dw_body within w_79024_e
integer y = 356
integer height = 1692
string dataobject = "D_79024_D02"
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
string  ls_path, ls_file_nm
integer li_value
string ls_column_nm, ls_column_value, ls_report

// cb_file_nm
IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

//case dw.name
if ls_column_nm = "file_nm" then
		li_value = GetFileOpenName("Select File", ls_path, ls_file_nm, "JPG", "image Files (*.JPG),*.JPG, *.JPEG")
		
		IF li_value = 1 THEN 
			dw_body.Setitem(1, "file_nm", ls_path)
			cb_update.enabled = true
			dw_1.reset()
			dw_1.insertrow(0)
			dw_1.setitem(1, "pic", ls_path)
			dw_1.visible = true
      else	
			is_file_nm = ""
		END IF
end if
end event

event dw_body::constructor;call super::constructor;This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

This.GetChild("judg_l", idw_child)
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve('795')
idw_child.InsertRow(1)
idw_child.SetItem(1, "inter_cd", '')
idw_child.SetItem(1, "inter_nm", '')

This.GetChild("judg_s", idw_judg_s)
idw_judg_s.SetTransObject(SQLCA)
idw_judg_s.Retrieve('796','%')
idw_judg_s.InsertRow(1)
idw_judg_s.SetItem(1, "inter_cd", '')
idw_judg_s.SetItem(1, "inter_nm", '')


end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;/* 화일 탐색 */
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
end event

type st_1 from w_com020_e`st_1 within w_79024_e
integer y = 356
integer height = 1692
end type

type dw_print from w_com020_e`dw_print within w_79024_e
integer x = 837
integer y = 204
end type

type dw_1 from datawindow within w_79024_e
integer x = 430
integer y = 812
integer width = 1650
integer height = 1540
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "예제사진보기"
string dataobject = "d_79024_d03"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_79024_e
boolean visible = false
integer x = 3205
integer y = 1072
integer width = 1893
integer height = 412
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_79024_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;dw_2.SetTransObject(SQLCA)
dw_2.insertrow(0)

dw_2.setitem(1,'addr','220.118.68.4')
dw_2.setitem(1,'id','photo_claim')
dw_2.setitem(1,'pwd','zmffpdla')
dw_2.setitem(1,'remotefile','')
dw_2.setitem(1,'rocalfile','C:\claim\')


bl_connect = false
u_ftp = create nvo_ftp
end event

type cb_connect from commandbutton within w_79024_e
boolean visible = false
integer x = 3218
integer y = 492
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

type cb_getfile from commandbutton within w_79024_e
boolean visible = false
integer x = 3218
integer y = 580
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

type cb_putfile from commandbutton within w_79024_e
boolean visible = false
integer x = 3218
integer y = 664
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
	messagebox('',ls_remote+' 파일 업로드 실패 !!!!!')
End If 	 

end event

type cb_disconnect from commandbutton within w_79024_e
boolean visible = false
integer x = 3209
integer y = 756
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

