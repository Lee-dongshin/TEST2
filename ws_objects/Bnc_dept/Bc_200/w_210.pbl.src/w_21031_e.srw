$PBExportHeader$w_21031_e.srw
$PBExportComments$전안법보관서류등록
forward
global type w_21031_e from w_com010_e
end type
type gb_1 from groupbox within w_21031_e
end type
type dw_1 from datawindow within w_21031_e
end type
type dw_2 from datawindow within w_21031_e
end type
type dw_3 from datawindow within w_21031_e
end type
type dw_size from datawindow within w_21031_e
end type
type dw_ftp from datawindow within w_21031_e
end type
type cb_connect from commandbutton within w_21031_e
end type
type cb_getfile from commandbutton within w_21031_e
end type
type cb_putfile from commandbutton within w_21031_e
end type
type cb_disconnect from commandbutton within w_21031_e
end type
type dw_5 from datawindow within w_21031_e
end type
type st_1 from statictext within w_21031_e
end type
type st_2 from statictext within w_21031_e
end type
type st_3 from statictext within w_21031_e
end type
type st_4 from statictext within w_21031_e
end type
type st_5 from statictext within w_21031_e
end type
type dw_4 from datawindow within w_21031_e
end type
type cb_add_ft from commandbutton within w_21031_e
end type
end forward

global type w_21031_e from w_com010_e
integer width = 3698
integer height = 2272
windowstate windowstate = maximized!
gb_1 gb_1
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
dw_size dw_size
dw_ftp dw_ftp
cb_connect cb_connect
cb_getfile cb_getfile
cb_putfile cb_putfile
cb_disconnect cb_disconnect
dw_5 dw_5
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
dw_4 dw_4
cb_add_ft cb_add_ft
end type
global w_21031_e w_21031_e

type variables
string	is_brand, is_year, is_style, is_chno, is_color, is_ft_order, is_add_ft = 'N'
string is_img_nm, is_pdf_nm
boolean bl_connect
end variables

on w_21031_e.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.dw_size=create dw_size
this.dw_ftp=create dw_ftp
this.cb_connect=create cb_connect
this.cb_getfile=create cb_getfile
this.cb_putfile=create cb_putfile
this.cb_disconnect=create cb_disconnect
this.dw_5=create dw_5
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.dw_4=create dw_4
this.cb_add_ft=create cb_add_ft
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.dw_3
this.Control[iCurrent+5]=this.dw_size
this.Control[iCurrent+6]=this.dw_ftp
this.Control[iCurrent+7]=this.cb_connect
this.Control[iCurrent+8]=this.cb_getfile
this.Control[iCurrent+9]=this.cb_putfile
this.Control[iCurrent+10]=this.cb_disconnect
this.Control[iCurrent+11]=this.dw_5
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.st_4
this.Control[iCurrent+16]=this.st_5
this.Control[iCurrent+17]=this.dw_4
this.Control[iCurrent+18]=this.cb_add_ft
end on

on w_21031_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.dw_size)
destroy(this.dw_ftp)
destroy(this.cb_connect)
destroy(this.cb_getfile)
destroy(this.cb_putfile)
destroy(this.cb_disconnect)
destroy(this.dw_5)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.dw_4)
destroy(this.cb_add_ft)
end on

event ue_retrieve();
/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_mat_cd, ls_size, ls_size_1, ls_size_2, ls_size_3, ls_size_4
int i, li_count_1
long ll_rows, ll_rows1

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_style, is_chno, is_color)

//올리브는 이미지 않넣고 기획이미지 가져옮.(황병준 요청)
//if is_brand = 'O' then
	dw_body.setitem(1, 'img_nm', is_style + '_' + is_color + '.jpg')
	dw_body.object.cb_img_nm.visible = false
//end if

if il_rows > 0 then 
	dw_1.retrieve(is_brand, is_year, is_style, is_chno, is_color)
	ll_rows = dw_2.retrieve(is_brand, is_year, is_style, is_chno, is_color)
	if ll_rows < 1 then
//		dw_2.insertrow(0)
	end if
	is_ft_order = dw_body.getitemstring(1,'ft_order')
	ll_rows1 = dw_3.retrieve(is_brand, is_year, is_ft_order)
	if ll_rows1 < 1 then
		dw_3.insertrow(0)
	end if
	dw_4.retrieve(is_brand, is_year, is_style, is_chno, is_color, is_ft_order)
	dw_5.retrieve(is_brand, is_year, is_style, is_chno, is_color)
end if
IF il_rows > 0 THEN
   dw_body.SetFocus()
elseif il_rows = 0 then
	dw_body.insertrow(0)	
END IF

dw_size.retrieve(is_brand, is_year, is_style, is_chno)
li_count_1 = dw_size.rowcount()

for i=1 to dw_size.rowcount()
	ls_size = dw_body.getitemstring(1,'size')
	if i = 1 then
		ls_size_1 = dw_size.getitemstring(i,'size')
		dw_body.setitem(1,'size', ls_size_1)		
	elseif i = 2 then
		ls_size_2 = dw_size.getitemstring(i,'size')
		dw_body.setitem(1,'size', ls_size + ', ' + ls_size_2)
	elseif i = 3 then
		ls_size_3 = dw_size.getitemstring(i,'size')
		dw_body.setitem(1,'size', ls_size + ', ' + ls_size_3)
	elseif i = 4 then
		ls_size_4 = dw_size.getitemstring(i,'size')
		dw_body.setitem(1,'size', ls_size + ', ' + ls_size_4)
	end if 

next


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
//IF dw_head.Enabled THEN
////	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
//	dw_body.Reset()
//END IF
//
il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
/*
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()	
*/

	dw_head.setitem(1,'style','')
	dw_head.setitem(1,'chno','')
	dw_head.setitem(1,'color','')
	dw_body.reset()
	dw_1.reset()
	dw_2.reset()
	dw_3.reset()
	dw_4.reset()
	dw_5.reset()	
	dw_body.insertrow(0)
	dw_1.InsertRow(0)
//	dw_2.InsertRow(0)
	dw_3.InsertRow(0)
	dw_4.InsertRow(0)
	dw_5.InsertRow(0)
	dw_head.ScrollToRow(il_rows)
	dw_head.SetColumn(ii_min_column_id)
	dw_head.SetFocus()	

end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
string ls_brand, ls_year, ls_style, ls_chno, ls_serial
string ls_img_nm, ls_filename, ls_sp_string1, ls_sp_file
string ls_pdf_nm, ls_filename1, ls_sp_string2, ls_sp_file1
integer li_FileNum
uint rtn,wstyle

dw_3.AcceptText()
dw_2.AcceptText()

is_ft_order = dw_3.getitemstring(1,'ft_order')
if isnull(is_ft_order) or is_ft_order = '' then 
	messagebox('확인!', 'FITI Report관리의 접수번호를 등록해 주세요!')
	return -1
end if

if is_add_ft = 'N' then
	ls_img_nm = dw_body.getitemstring(1, 'img_nm')
else
	ls_img_nm = is_ft_order + '.jpg'
end if

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

idw_status = dw_body.GetItemStatus(1, 0, Primary!)

select style
into :ls_style
from tb_21031_m
where brand = :is_brand
		and year = :is_brand
		and style = :is_style
		and chno  = :is_chno
		and color = :is_color
		and ft_order = :is_ft_order;

if isnull(ls_style) or ls_style = '' then
	idw_status = NewModified!
end if

//idw_status = dw_4.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */	
	dw_4.insertrow(0)
	dw_4.setitem(1, "brand"    , is_brand)
	dw_4.setitem(1, "year"     , is_year)
	dw_4.setitem(1, "style"    , is_style)
	dw_4.setitem(1, "chno"     , is_chno)
	dw_4.setitem(1, "color"    , is_color)
	dw_4.setitem(1, "img_nm"   , ls_img_nm)		
	dw_4.setitem(1, "ft_order" , is_ft_order)
	dw_4.setitem(1, "size"     , dw_body.getitemstring(1,'size'))
	dw_4.Setitem(1, "reg_id"   , gs_user_id)
	dw_4.Setitem(1, "reg_dt"   , ld_datetime)

	if is_add_ft = 'N' then
		dw_5.insertrow(0)
		dw_5.setitem(1, "brand"    , is_brand)
		dw_5.setitem(1, "year"     , is_year)
		dw_5.setitem(1, "style"    , is_style)
		dw_5.setitem(1, "chno"     , is_chno)	
		dw_5.setitem(1, "color"    , is_color)
		dw_5.setitem(1, "p_name" , dw_1.getitemstring(1,'p_name'))	
		dw_5.setitem(1, "p_saupno" , dw_1.getitemstring(1,'p_saupno'))	
		dw_5.setitem(1, "p_ownr_nm" , dw_1.getitemstring(1,'p_ownr_nm'))	
		dw_5.setitem(1, "p_mail" , dw_1.getitemstring(1,'p_email'))	
		dw_5.setitem(1, "p_addr" , dw_1.getitemstring(1,'p_addr'))	
		dw_5.setitem(1, "p_tel" , dw_1.getitemstring(1,'p_tel'))	
		dw_5.setitem(1, "p_fax" , dw_1.getitemstring(1,'p_fax'))	
		dw_5.setitem(1, "s_name_1" , dw_1.getitemstring(1,'s_name_1'))	
		dw_5.setitem(1, "s_name_2" , dw_1.getitemstring(1,'s_name_2'))	
		dw_5.Setitem(1, "reg_id" , gs_user_id)
		dw_5.Setitem(1, "reg_dt" , ld_datetime)
	end if

ll_row_count = dw_2.rowcount()
if isnull(ll_row_count) or ll_row_count < 1 then
else
	for i = 1 to ll_row_count
		dw_2.setitem(i, "brand"  , is_brand)
		dw_2.setitem(i, "year"   , is_year)
		dw_2.setitem(i, "style"  , is_style)
		dw_2.setitem(i, "chno"   , is_chno)	
		dw_2.setitem(i, "color"  , is_color)
		dw_2.Setitem(i, "reg_id" , gs_user_id)
		dw_2.Setitem(i, "reg_dt" , ld_datetime)
	next
end if

	dw_3.setitem(1, "brand"  , is_brand)
	dw_3.setitem(1, "year"   , is_year)
	dw_3.setitem(1, "style"  , is_style)
	dw_3.setitem(1, "chno"   , is_chno)	
	dw_3.setitem(1, "color"  , is_color)
	dw_3.Setitem(1, "reg_id" , gs_user_id)
	dw_3.Setitem(1, "reg_dt" , ld_datetime)


	ls_filename = "c:\bnc_dept\rename_1.bat"	
	if is_brand <> 'O' then
		ls_img_nm = trim(dw_body.getitemstring(1, "img_nm"))
		ls_sp_string1 = 'copy ' + ls_img_nm 
		ls_sp_file =  is_ft_order + '.jpg'
		dw_body.setitem(1, "img_nm", ls_sp_file)
		dw_4.setitem(1, "img_nm", ls_sp_file)
	end if

	ls_pdf_nm = trim(dw_3.getitemstring(1, "pdf_nm"))
	ls_sp_string2 = 'copy ' + ls_pdf_nm 
	ls_sp_file1 =  is_ft_order + '.pdf'
	dw_3.setitem(1, "pdf_nm", ls_sp_file1)

	if isnull(ls_filename) or ls_filename = "" then
	else	
//		if is_brand <> 'O' then
//			wstyle = 0				
//			li_FileNum = FileOpen(ls_filename, streamMode!, Write!, Shared!, Replace!)	
//			FileWrite(li_FileNum, ls_sp_string1)
//			FileClose(li_FileNum)
//			rtn = WinExec(ls_filename, wstyle)
//		end if
//		
		wstyle = 0				
		li_FileNum = FileOpen(ls_filename, streamMode!, Write!, Shared!, Replace!)	
		FileWrite(li_FileNum, ls_sp_string2)
		FileClose(li_FileNum)
		rtn = WinExec(ls_filename1, wstyle)
	end if	

ELSEIF idw_status = DataModified! THEN		/* Modify Record */
	dw_4.setitem(1, "brand"    , is_brand)
	dw_4.setitem(1, "year"     , is_year)
	dw_4.setitem(1, "style"    , is_style)
	dw_4.setitem(1, "chno"     , is_chno)	
	dw_4.setitem(1, "color"    , is_color)
	dw_4.setitem(1, "img_nm"   , ls_img_nm)		
	dw_4.setitem(1, "ft_order" , is_ft_order)
	dw_4.setitem(1, "size"     , dw_body.getitemstring(1,'size'))
	dw_4.Setitem(1, "mod_id" , gs_user_id)
	dw_4.Setitem(1, "mod_dt" , ld_datetime)

	if is_add_ft = 'N' then
		dw_5.setitem(1, "brand"  , is_brand)
		dw_5.setitem(1, "year"   , is_year)
		dw_5.setitem(1, "style"  , is_style)
		dw_5.setitem(1, "chno"   , is_chno)
		dw_5.setitem(1, "color"  , is_color)
		dw_5.setitem(1, "p_name" , dw_1.getitemstring(1,'p_name'))	
		dw_5.setitem(1, "p_saupno" , dw_1.getitemstring(1,'p_saupno'))	
		dw_5.setitem(1, "p_ownr_nm" , dw_1.getitemstring(1,'p_ownr_nm'))	
		dw_5.setitem(1, "p_mail" , dw_1.getitemstring(1,'p_email'))	
		dw_5.setitem(1, "p_addr" , dw_1.getitemstring(1,'p_addr'))		
		dw_5.setitem(1, "p_tel" , dw_1.getitemstring(1,'p_tel'))	
		dw_5.setitem(1, "p_fax" , dw_1.getitemstring(1,'p_fax'))	
		dw_5.setitem(1, "s_name_1" , dw_1.getitemstring(1,'s_name_1'))	
		dw_5.setitem(1, "s_name_2" , dw_1.getitemstring(1,'s_name_2'))	
		dw_5.Setitem(1, "mod_id" , gs_user_id)
		dw_5.Setitem(1, "mod_dt" , ld_datetime)
	end if

ll_row_count = dw_2.rowcount()
if isnull(ll_row_count) or ll_row_count < 1 then
else
	for i = 1 to ll_row_count
		dw_2.setitem(i, "brand"  , is_brand)
		dw_2.setitem(i, "year"   , is_year)
		dw_2.setitem(i, "style"  , is_style)
		dw_2.setitem(i, "chno"   , is_chno)	
		dw_2.setitem(i, "color"  , is_color)
		dw_2.Setitem(i, "mod_id" , gs_user_id)
		dw_2.Setitem(i, "mod_dt" , ld_datetime)
	next
end if
	dw_3.setitem(1, "brand"  , is_brand)
	dw_3.setitem(1, "year"   , is_year)
	dw_3.setitem(1, "style"  , is_style)
	dw_3.setitem(1, "chno"   , is_chno)	
	dw_3.setitem(1, "color"  , is_color)
	dw_3.Setitem(1, "mod_id" , gs_user_id)
	dw_3.Setitem(1, "mod_dt" , ld_datetime)

	ls_filename = "c:\bnc_dept\rename_1.bat"	
//	if is_brand <> 'O' then
//		ls_img_nm = trim(dw_body.getitemstring(1, "img_nm"))
//		ls_sp_string1 = 'copy ' + ls_img_nm 
//		ls_sp_file =  is_ft_order + '.jpg'
//		dw_body.setitem(1, "img_nm", ls_sp_file)
//		dw_4.setitem(1, "img_nm", ls_sp_file)
//	end if
	
	ls_pdf_nm = trim(dw_3.getitemstring(1, "pdf_nm"))
	ls_sp_string2 = 'copy ' + ls_pdf_nm 
	ls_sp_file1 =  is_ft_order + '.pdf'
	dw_3.setitem(1, "pdf_nm", ls_sp_file1)

	if isnull(ls_filename) or ls_filename = "" then
	else	
//		if is_brand <> 'O' then
//			wstyle = 0				
//			li_FileNum = FileOpen(ls_filename, streamMode!, Write!, Shared!, Replace!)	
//			FileWrite(li_FileNum, ls_sp_string1)
//			FileClose(li_FileNum)
//			rtn = WinExec(ls_filename, wstyle)
//		end if
		
		wstyle = 0				
		li_FileNum = FileOpen(ls_filename, streamMode!, Write!, Shared!, Replace!)	
		FileWrite(li_FileNum, ls_sp_string2)
		FileClose(li_FileNum)
		rtn = WinExec(ls_filename1, wstyle)
	end if	
END IF


il_rows = dw_4.Update()

if il_rows = 1 then
	if isnull(ll_row_count) or ll_row_count < 1 then
	else
		dw_2.update()		
	end if
	dw_3.update()
	if is_add_ft = 'N' then
		dw_5.update()
	end if
   commit  USING SQLCA;


	//	FTP 이미지 전송시작//
		//제품이미지
//		if is_brand <> 'O' then
//			dw_ftp.setitem(1,'addr','172.16.1.84')
//			dw_ftp.setitem(1,'id','simg')
//			dw_ftp.setitem(1,'pwd','gmis')
//			dw_ftp.setitem(1,'remotefile', '/VOL1/simg/'+is_brand+'/'+is_year+'/'+ls_sp_file)
//			dw_ftp.setitem(1,'rocalfile', ls_img_nm)
//			cb_Connect.triggerevent (clicked!)
//			cb_PutFile.triggerevent (clicked!)
//			cb_DisConnect.triggerevent (clicked!)
//		end if
		
		//FT_PDF파일
		dw_ftp.setitem(1,'addr','172.16.1.84')
		dw_ftp.setitem(1,'id','spdf')
		dw_ftp.setitem(1,'pwd','fdps')
		dw_ftp.setitem(1,'remotefile', '/VOL1/spdf/'+is_brand+'/'+is_year+'/'+ls_sp_file1)
		dw_ftp.setitem(1,'rocalfile', ls_pdf_nm)
		cb_Connect.triggerevent (clicked!)
		cb_PutFile.triggerevent (clicked!)
		cb_DisConnect.triggerevent (clicked!)

else
   rollback  USING SQLCA;
end if
This.Trigger Event ue_retrieve()
This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows
end event

event ue_delete();call super::ue_delete;if dw_body.rowcount() = 0 then
	dw_body.DeleteRow(-1)
	dw_1.DeleteRow(-1)
	dw_2.DeleteRow(-1)
	dw_3.DeleteRow(-1)
	dw_4.DeleteRow(-1)
	dw_5.DeleteRow(-1)
end if
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드를 입력 하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif (gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	


is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"년도를 입력 하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
   MessageBox(ls_title,"스타일을 입력 하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("is_style")
   return false
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
   MessageBox(ls_title,"차수를 입력 하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("is_chno")
   return false
end if

is_color = dw_head.GetItemString(1, "color")
if IsNull(is_color) or Trim(is_color) = "" then
   MessageBox(ls_title,"컬러를 입력 하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("is_color")
   return false
end if
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_flag, ls_age_grp, ls_jumin , ls_given_fg, ls_given_ymd
String     ls_style,   ls_chno, ls_data , ls_sojae, ls_shop_type, ls_style_k
string     ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_year, ls_season, ls_tel_no
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
			gst_cd.datawindow_nm   = "d_com013" 
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
				dw_head.SetItem(al_row, "color", lds_Source.GetItemString(1,"color"))
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
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
			cb_add_ft.enabled = true
			cb_insert.enabled = true
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
			cb_add_ft.enabled = false
			cb_insert.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			cb_add_ft.enabled = false
			cb_insert.enabled = false
			cb_retrieve.Text = "조회(&Q)"
			dw_head.Enabled = true
			dw_body.Enabled = true
/*			
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = true
				dw_body.Enabled = true
			end if
*/			
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
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
		cb_add_ft.enabled = false
		cb_insert.enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 		   									  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/

/* Data window Resize */
inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
//inv_resize.of_Register(dw_2, "ScaleToRight")
inv_resize.of_Register(dw_3, "ScaleToRight&Bottom")
inv_resize.of_Register(cb_add_ft, "FixedToRight")

/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
dw_5.SetTransObject(SQLCA)
dw_size.SetTransObject(SQLCA)

/* DataWindow Head에 One Row 추가 */
dw_body.InsertRow(0)
dw_1.InsertRow(0)
//dw_2.InsertRow(0)
dw_3.InsertRow(0)
dw_4.InsertRow(0)
dw_5.InsertRow(0)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_21031_e","0")
end event

type cb_close from w_com010_e`cb_close within w_21031_e
end type

type cb_delete from w_com010_e`cb_delete within w_21031_e
boolean visible = false
integer x = 1266
integer taborder = 60
end type

type cb_insert from w_com010_e`cb_insert within w_21031_e
integer x = 827
boolean enabled = false
string text = "신규(&A)"
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_21031_e
end type

type cb_update from w_com010_e`cb_update within w_21031_e
integer taborder = 30
end type

type cb_print from w_com010_e`cb_print within w_21031_e
boolean visible = false
integer x = 1609
integer taborder = 70
end type

type cb_preview from w_com010_e`cb_preview within w_21031_e
boolean visible = false
integer x = 1952
integer taborder = 80
end type

type gb_button from w_com010_e`gb_button within w_21031_e
end type

type cb_excel from w_com010_e`cb_excel within w_21031_e
boolean visible = false
integer x = 2295
integer taborder = 90
end type

type dw_head from w_com010_e`dw_head within w_21031_e
integer x = 9
integer y = 160
integer width = 3589
integer height = 132
string dataobject = "d_21031_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
/*===========================================================================*/
String ls_yymmdd

CHOOSE CASE dwo.name
	CASE "style"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;datawindowchild ldw_child

this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('001')

this.getchild("year",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('002')

this.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "color", '%')
ldw_child.SetItem(1, "color_enm", '전체')

end event

type ln_1 from w_com010_e`ln_1 within w_21031_e
integer beginy = 296
integer endy = 296
end type

type ln_2 from w_com010_e`ln_2 within w_21031_e
integer beginy = 300
integer endy = 300
end type

type dw_body from w_com010_e`dw_body within w_21031_e
integer x = 9
integer y = 320
integer width = 2725
integer height = 1716
string dataobject = "d_21031_d01"
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
	CASE KeyDownArrow!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
		END IF
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
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::buttonclicking;call super::buttonclicking;/* 화일 탐색 */
string  ls_sp_path, ls_sp_file_nm, ls_re_path, ls_re_file_nm
integer li_value
string ls_column_nm, ls_column_value, ls_report

// cb_file_nm
IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)
//case dw.name
if ls_column_nm = "img_nm" then
	li_value = GetFileOpenName("Select File", ls_sp_path, ls_sp_file_nm, "JPG", "image Files (*.JPG),*.JPG, *.JPEG")
	
	IF li_value = 1 THEN 
		dw_body.Setitem(1, "img_nm", ls_sp_path)
		cb_update.enabled = true
		dw_body.setitem(1, "serial", ls_sp_path)
	else	
		is_img_nm = ""
	END IF
end if


end event

type dw_print from w_com010_e`dw_print within w_21031_e
integer x = 32
integer y = 344
end type

type gb_1 from groupbox within w_21031_e
integer x = 3625
integer y = 1296
integer width = 1888
integer height = 536
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "* 유의사항 *"
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_21031_e
integer x = 2738
integer y = 320
integer width = 2784
integer height = 964
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_21031_d02"
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;datawindowchild ldw_child

this.getchild("s_name_1",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('047')

this.getchild("s_name_2",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('047')
end event

event itemchanged;cb_update.enabled = true
Parent.Trigger Event ue_button (4, il_rows)
end event

type dw_2 from datawindow within w_21031_e
integer x = 2738
integer y = 1292
integer width = 873
integer height = 552
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_21031_d03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report, ls_yymmdd, ls_judg_fg
Long ll_row

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Choose Case ls_column_nm
	Case "add"
			il_rows = This.InsertRow(0)	
//			cb_update.enabled = true
			This.SetColumn(il_rows)			
	Case "delete"
		ll_row = This.GetRow()
		if ll_row <= 0 then return
		idw_status = This.GetItemStatus(ll_row, 0, Primary!)
		il_rows = This.DeleteRow(ll_row)
//		cb_update.enabled = true
		This.SetFocus()
End Choose

cb_update.enabled = true
Parent.Trigger Event ue_button (4, il_rows)
end event

type dw_3 from datawindow within w_21031_e
integer x = 2738
integer y = 1844
integer width = 1303
integer height = 380
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_21031_d04"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicking;/* 화일 탐색 */
string  ls_sp_path, ls_sp_file_nm, ls_re_path, ls_re_file_nm
integer li_value
string ls_column_nm, ls_column_value, ls_report

// cb_file_nm
IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)
//case dw.name
if ls_column_nm = "pdf_nm" then
	li_value = GetFileOpenName("Select File", ls_sp_path, ls_sp_file_nm, "PDF", "Adobe PDF 파일 (*.pdf),*.PDF")
	
	IF li_value = 1 THEN 
		dw_3.Setitem(1, "pdf_nm", ls_sp_path)
		cb_update.enabled = true
		dw_3.setitem(1, "serial", ls_sp_path+ls_sp_file_nm)
		dw_3.visible = true
	else	
		is_pdf_nm = ""
	END IF
end if

cb_update.enabled = true
Parent.Trigger Event ue_button (4, il_rows)

end event

type dw_size from datawindow within w_21031_e
boolean visible = false
integer x = 2057
integer y = 592
integer width = 480
integer height = 840
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_21031_d01_size"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_ftp from datawindow within w_21031_e
boolean visible = false
integer x = 3355
integer y = 1296
integer width = 1769
integer height = 692
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_21031_d05"
boolean controlmenu = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;dw_ftp.SetTransObject(SQLCA)
dw_ftp.insertrow(0)

dw_ftp.setitem(1,'addr','172.16.1.84')
dw_ftp.setitem(1,'id','simg')
dw_ftp.setitem(1,'pwd','gmis')
dw_ftp.setitem(1,'remotefile','')
//dw_2.setitem(1,'rocalfile','C:\sample\')
//dw_2.setitem(1,'rocalfile','C:\sample\sp_img\')


bl_connect = false
u_ftp = create nvo_ftp
end event

type cb_connect from commandbutton within w_21031_e
boolean visible = false
integer x = 3698
integer y = 116
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
string text = "Connect"
end type

event clicked;string ls_column_nm, ls_addr, ls_id, ls_pwd, ls_remote, ls_rocal
int li_rtn


ls_addr = dw_ftp.getitemstring(1,'addr')
ls_id = dw_ftp.getitemstring(1,'id')
ls_pwd = dw_ftp.getitemstring(1, 'pwd')

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

type cb_getfile from commandbutton within w_21031_e
boolean visible = false
integer x = 4128
integer y = 112
integer width = 402
integer height = 84
integer taborder = 140
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

ls_remote = dw_ftp.getitemstring(1, 'remotefile')
ls_rocal = dw_ftp.getitemstring(1, 'rocalfile')

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

type cb_putfile from commandbutton within w_21031_e
boolean visible = false
integer x = 4119
integer y = 208
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
string text = "PutFile"
end type

event clicked;string  ls_remote, ls_rocal
int li_rtn

ls_remote = dw_ftp.getitemstring(1, 'remotefile')
ls_rocal = dw_ftp.getitemstring(1, 'rocalfile')

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

type cb_disconnect from commandbutton within w_21031_e
boolean visible = false
integer x = 3694
integer y = 208
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
	MessageBox("", "FTP 종료실패")
end if


end event

type dw_5 from datawindow within w_21031_e
boolean visible = false
integer x = 4457
integer y = 1572
integer width = 1065
integer height = 840
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "공급자접합성확인서"
string dataobject = "d_21031_d07"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_21031_e
integer x = 3675
integer y = 1380
integer width = 864
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "1. 제품사진 등록시 확장자 : JPG"
boolean focusrectangle = false
end type

type st_2 from statictext within w_21031_e
integer x = 3675
integer y = 1440
integer width = 946
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "2. Fiti 성적서 등록시 확장자 : PDF"
boolean focusrectangle = false
end type

type st_3 from statictext within w_21031_e
integer x = 3675
integer y = 1500
integer width = 1522
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "3. 제품사진 등록시 사이즈(가로×세로) : 448 × 488 픽셀"
boolean focusrectangle = false
end type

type st_4 from statictext within w_21031_e
integer x = 3675
integer y = 1564
integer width = 1737
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "4. 제품사진 등록시 픽셀 사이즈가 다를 경우 이미지가 외곡 될 수"
boolean focusrectangle = false
end type

type st_5 from statictext within w_21031_e
integer x = 3675
integer y = 1632
integer width = 1678
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "   있습니다."
boolean focusrectangle = false
end type

type dw_4 from datawindow within w_21031_e
boolean visible = false
integer x = 3872
integer y = 792
integer width = 1344
integer height = 840
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "제품설명서"
string dataobject = "d_21031_d06"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_add_ft from commandbutton within w_21031_e
integer x = 416
integer y = 44
integer width = 411
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "Ft 성적서추가"
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
//IF dw_head.Enabled THEN
////	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
//	dw_body.Reset()
//END IF
//

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_style, is_chno, is_color)

if (isnull(is_style) or is_style = '') or (isnull(is_chno) or is_chno = '') or (isnull(is_color) or is_color = '') then
	messagebox('확인','조회후 처리 해 주세요!')
	return 0
end if

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	is_add_ft = 'Y'
	dw_body.setitem(1,'ft_order','')
	dw_3.reset()
	dw_3.insertrow(0)
end if

//This.Trigger Event ue_button(2, il_rows)
//This.Trigger Event ue_msg(2, il_rows)

end event

