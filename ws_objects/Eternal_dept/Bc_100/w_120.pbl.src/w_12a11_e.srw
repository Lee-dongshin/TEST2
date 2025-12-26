$PBExportHeader$w_12a11_e.srw
$PBExportComments$도식화
forward
global type w_12a11_e from w_com030_e
end type
type dw_ftp from datawindow within w_12a11_e
end type
type cb_putfile from commandbutton within w_12a11_e
end type
type cb_getfile from commandbutton within w_12a11_e
end type
type cb_disconnect from commandbutton within w_12a11_e
end type
type cb_connect from commandbutton within w_12a11_e
end type
end forward

global type w_12a11_e from w_com030_e
integer width = 3707
dw_ftp dw_ftp
cb_putfile cb_putfile
cb_getfile cb_getfile
cb_disconnect cb_disconnect
cb_connect cb_connect
end type
global w_12a11_e w_12a11_e

type variables
string  is_brand, is_style, is_chno, is_dsgn_emp, is_design_gubn, is_path
boolean bl_connect
datawindowchild idw_brand
end variables

on w_12a11_e.create
int iCurrent
call super::create
this.dw_ftp=create dw_ftp
this.cb_putfile=create cb_putfile
this.cb_getfile=create cb_getfile
this.cb_disconnect=create cb_disconnect
this.cb_connect=create cb_connect
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ftp
this.Control[iCurrent+2]=this.cb_putfile
this.Control[iCurrent+3]=this.cb_getfile
this.Control[iCurrent+4]=this.cb_disconnect
this.Control[iCurrent+5]=this.cb_connect
end on

on w_12a11_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ftp)
destroy(this.cb_putfile)
destroy(this.cb_getfile)
destroy(this.cb_disconnect)
destroy(this.cb_connect)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
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

is_style = Trim(dw_head.GetItemString(1, "style"))
if IsNull(is_style) or is_style = "" then
	is_style = '%'
end if

is_chno = Trim(dw_head.GetItemString(1, "chno"))
if IsNull(is_chno) or is_chno = "" then
	is_chno = '%'
end if

is_dsgn_emp = Trim(dw_head.GetItemString(1, "dsgn_emp"))
if IsNull(is_dsgn_emp) or is_dsgn_emp = "" then
	is_dsgn_emp = '%'
end if

 is_design_gubn = Trim(dw_head.GetItemString(1, "design_gubn"))
if IsNull(is_design_gubn) or is_design_gubn = "" then
   MessageBox(ls_title,"도식화 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("design_gubn")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                               */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//is_style =  left(is_style_no,8)
il_rows = dw_list.retrieve(is_brand, is_style, is_chno, is_dsgn_emp, is_design_gubn )
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_emp_nm, ls_dept, ls_mat_cd, ls_fr_style, ls_fr_chno
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style_no"				
		   ls_style = MidA(as_data, 1, 8)
			ls_chno  = MidA(as_data, 9, 1)
						
			IF ai_div = 1 THEN 	
				IF gf_style_chk(ls_style, ls_chno) THEN
						if gs_brand <> "K" then						
							RETURN 0
						else 
							if gs_brand <> MidA(as_data,1,1) then
								Return 1
							else 
								RETURN 0
							end if	
						end if	
				end if				
				
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = ""
			
			if gs_brand <> "K" then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + ls_style + "%' and style like 'K%' "
				ELSE
					gst_cd.Item_where = "style like 'K%'"
				END IF
				
			end if	
			
//			
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"
//			ELSE
//				gst_cd.Item_where = ""
//			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))

//				cb_2.enabled = true				 				
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source

	CASE "dsgn_emp"		
			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then  return 1
				if gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
					dw_head.Setitem(al_row, "dsgn_emp", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			/* 관련부서 산출 */ 
		
			if MidA(is_style, 1, 1) = 'O' then 
		   	gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('O000')" 
			end if
			
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(empno LIKE '" + as_data + "%' OR " + & 
				                    " kname LIKE '" + as_data + "%' )" 
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
				dw_head.SetItem(al_row, "dsgn_emp",    lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "dsgn_emp_nm", lds_Source.GetItemString(1,"kname"))
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

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.07                                                  */	
/* 수정일      : 2002.03.07                                                  */
/*===========================================================================*/


long i, ll_row_count, ll_size_spec1,ll_size_spec2,ll_size_spec3,ll_size_spec4, ll_cnt
long ll_make_price, ll_sub_price
datetime ld_datetime
String   ls_mat_cd, ls_mat_nm, ls_mat_nm_chk, ls_ErrMsg, ls_flag, ls_mat_fg, ls_brand,ls_dsgn_emp, ls_style_ck
string ls_image, ls_bigo, ls_design_ymd, ls_pum_ymd, ls_order_id, ls_uid_21, ls_uid_22, ls_sign_ymd_1, ls_empno_1
string ls_style, ls_chno

gf_sysdate(ld_datetime)

ll_row_count = dw_body.RowCount()
IF ll_row_count < 1 THEN RETURN -1

dw_body.AcceptText()

//작지마스터
	ls_image = dw_body.getitemstring(1, 'image')
	ls_bigo	= dw_body.getitemstring(1, 'bigo')
	ls_style	= dw_body.getitemstring(1, 'style')
	ls_chno =  dw_body.getitemstring(1, 'chno')


	if ls_image = '' or isnull(ls_image) then
		messagebox('입력확인!','이미지를 선택해 주세요!')
   	dw_body.SetFocus()
	   dw_body.SetColumn("image")
		return -1
	end if
	
	dw_body.setitem(1,'image', ls_image)	
	dw_body.setitem(1,'bigo', ls_bigo)



	idw_status = dw_body.GetItemStatus(1, 0, Primary!)
	IF idw_status = NewModified! THEN				/* New Record    */
		dw_body.Setitem(1, "reg_id", gs_user_id)
		dw_body.Setitem(1, "reg_dt", ld_datetime)	
	ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
		dw_body.Setitem(1, "mod_id", gs_user_id)
		dw_body.Setitem(1, "mod_dt", ld_datetime)
	END IF 	

	

	il_rows = dw_body.Update(TRUE, FALSE) 
	if il_rows = 1 then		
//		dw_body.Update()
		update tb_12021_d set design_gubn = 'Y'
		from tb_12021_d 
		where brand = :gs_brand and style = :ls_style and chno = :ls_chno;
		
		cb_Connect.triggerevent (clicked!)
		cb_PutFile.triggerevent (clicked!)
		cb_DisConnect.triggerevent (clicked!)
		commit  USING SQLCA;	
	else
		rollback  USING SQLCA;
		IF Trim(ls_ErrMsg) <> "" THEN 
			MessageBox("저장 오류", ls_ErrMsg)
			return 0
		END IF 
	end if
	
	This.Trigger Event ue_button(5, il_rows)
	This.Trigger Event ue_msg(5, il_rows)
	return il_rows
end event

type cb_close from w_com030_e`cb_close within w_12a11_e
end type

type cb_delete from w_com030_e`cb_delete within w_12a11_e
boolean visible = false
end type

type cb_insert from w_com030_e`cb_insert within w_12a11_e
boolean visible = false
string text = "복사"
end type

type cb_retrieve from w_com030_e`cb_retrieve within w_12a11_e
end type

type cb_update from w_com030_e`cb_update within w_12a11_e
end type

type cb_print from w_com030_e`cb_print within w_12a11_e
end type

type cb_preview from w_com030_e`cb_preview within w_12a11_e
end type

type gb_button from w_com030_e`gb_button within w_12a11_e
integer x = 5
end type

type cb_excel from w_com030_e`cb_excel within w_12a11_e
end type

type dw_head from w_com030_e`dw_head within w_12a11_e
integer x = 18
integer y = 188
integer width = 4206
integer height = 112
string dataobject = "d_12a11_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1

	
END CHOOSE

end event

event dw_head::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

type ln_1 from w_com030_e`ln_1 within w_12a11_e
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com030_e`ln_2 within w_12a11_e
integer beginy = 320
integer endy = 320
end type

type dw_list from w_com030_e`dw_list within w_12a11_e
integer x = 9
integer y = 344
integer width = 1285
integer height = 1652
string dataobject = "d_12a11_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long  ll_body_rows, ll_detail_rows
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
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_style = This.GetItemString(row, 'style') /* DataWindow에 Key 항목을 가져온다 */
is_chno  = This.GetItemString(row, 'chno') /* DataWindow에 Key 항목을 가져온다 */


IF IsNull(is_style) or IsNull(is_chno)  THEN return


il_rows = dw_body.retrieve(is_style, is_chno)

IF il_rows <= 0 THEN
	dw_body.Reset()
	dw_body.Insertrow(0)
	dw_body.Setitem(1,'style', is_style)
	dw_body.setitem(1,'chno', is_chno)
else 
	dw_body.Object.p_img.FileName = '\\220.118.68.4\olive_design\'+ dw_body.getitemstring(1, "image")
	
END IF

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com030_e`dw_body within w_12a11_e
integer x = 1326
integer y = 344
integer width = 2290
integer height = 1652
string dataobject = "d_12a11_d02"
boolean vscrollbar = false
end type

event dw_body::clicked;call super::clicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
/*
String 	ls_search
if row > 0 then 
	choose case dwo.name
		case 'style_pic'
			ls_search 	= this.GetItemString(row,'style')
			if len(ls_search) >= 8 then gf_style_color_pic(ls_search, '%','%')			
	end choose	
end if
*/
end event

event dw_body::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
/* 화일 탐색 */
string  ls_path, ls_file_nm
integer li_value
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

if ls_column_nm = "file_nm" then
		li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")
		
		IF li_value = 1 THEN 

			dw_body.setitem(1, "image", ls_file_nm)
			dw_ftp.setitem(1,"rocalfile", is_path)
			dw_ftp.setitem(1,"remotefile", ls_file_nm)
			dw_body.Object.p_img.FileName = is_path
			

//			dw_master.Setitem(1, "p_img", ls_path)
//			dw_master.reset()
//			dw_master.insertrow(0)
//			dw_master.setitem(1, "p_img", ls_path)
//			dw_master.visible = true
			cb_update.enabled = true			
      else	
//			is_file_nm = ""
		END IF
end if

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

type st_1 from w_com030_e`st_1 within w_12a11_e
integer x = 1303
integer y = 344
integer height = 1640
end type

type dw_print from w_com030_e`dw_print within w_12a11_e
integer x = 1527
integer y = 916
string dataobject = "d_12a11_r01"
end type

type dw_ftp from datawindow within w_12a11_e
boolean visible = false
integer x = 1655
integer y = 804
integer width = 1847
integer height = 556
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_12a10_ftp"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;dw_ftp.SetTransObject(SQLCA)
dw_ftp.insertrow(0)

dw_ftp.setitem(1,'addr','220.118.68.4')
dw_ftp.setitem(1,'id','olive_design')
dw_ftp.setitem(1,'pwd','ngisedevilo')

bl_connect = false
u_ftp = create nvo_ftp
end event

type cb_putfile from commandbutton within w_12a11_e
boolean visible = false
integer x = 2245
integer y = 636
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
string text = "putfile"
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
//	messagebox('',ls_remote+' 파일 업로드 실패 !!!!!')
End If 	 

end event

type cb_getfile from commandbutton within w_12a11_e
boolean visible = false
integer x = 1829
integer y = 628
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
string text = "getfile"
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
//	messagebox('','파일다운로드 성공 !!!!!')	 		 
Else
//	messagebox('','파일다운로드 실패 !!!!!')	 		 
End If 	 

end event

type cb_disconnect from commandbutton within w_12a11_e
boolean visible = false
integer x = 2665
integer y = 632
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
string text = "disconnect"
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

type cb_connect from commandbutton within w_12a11_e
boolean visible = false
integer x = 1362
integer y = 636
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
string text = "connect"
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

