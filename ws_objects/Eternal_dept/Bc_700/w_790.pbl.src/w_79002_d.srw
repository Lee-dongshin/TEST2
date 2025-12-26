$PBExportHeader$w_79002_d.srw
$PBExportComments$A/S처리현황
forward
global type w_79002_d from w_com010_d
end type
type tab_1 from tab within w_79002_d
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tabpage_4 from userobject within tab_1
end type
type rb_day_diff from radiobutton within tabpage_4
end type
type rb_cust_cd from radiobutton within tabpage_4
end type
type rb_style from radiobutton within tabpage_4
end type
type dw_4 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
rb_day_diff rb_day_diff
rb_cust_cd rb_cust_cd
rb_style rb_style
dw_4 dw_4
end type
type tabpage_5 from userobject within tab_1
end type
type dw_5 from datawindow within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_5 dw_5
end type
type tabpage_6 from userobject within tab_1
end type
type dw_6 from datawindow within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_6 dw_6
end type
type tabpage_7 from userobject within tab_1
end type
type dw_7 from datawindow within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_7 dw_7
end type
type tab_1 from tab within w_79002_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
end type
type dw_9 from datawindow within w_79002_d
end type
type dw_judg from datawindow within w_79002_d
end type
end forward

global type w_79002_d from w_com010_d
string title = "일자별매출추이"
tab_1 tab_1
dw_9 dw_9
dw_judg dw_judg
end type
global w_79002_d w_79002_d

type variables
DataWindowChild idw_judg_fg, idw_judg_s, idw_cust_fg_s
DataWindowChild idw_decision_a, idw_decision_b, idw_decision_c, idw_decision_d 

DataWindowChild idw_brand, idw_year, idw_season
String  is_fr_yymm, is_to_yymm  , is_brand, is_opt, is_receipt_type, is_year, is_season
Boolean lb_ret_chk1 = False, lb_ret_chk2 = False, lb_ret_chk3 = False, lb_ret_chk4 = False, lb_ret_chk5 = False, lb_ret_chk6 = False, lb_ret_chk7 = False

end variables

on w_79002_d.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_9=create dw_9
this.dw_judg=create dw_judg
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_9
this.Control[iCurrent+3]=this.dw_judg
end on

on w_79002_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_9)
destroy(this.dw_judg)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_datetime
IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

//dw_head.SetItem(1, "base_yymm", ld_datetime)

ls_datetime = String(ld_datetime, "yyyymmdd")

dw_head.setitem(1, 'fr_yymm',MidA(ls_datetime,1,6)+'01')
dw_head.setitem(1, 'to_yymm',ls_datetime)
end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_3.dw_3, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_4.dw_4, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_5.dw_5, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_6.dw_6, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_7.dw_7, "ScaleToRight&Bottom")


tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)
tab_1.tabpage_4.dw_4.SetTransObject(SQLCA)
tab_1.tabpage_5.dw_5.SetTransObject(SQLCA)
tab_1.tabpage_6.dw_6.SetTransObject(SQLCA)
tab_1.tabpage_7.dw_7.SetTransObject(SQLCA)
dw_9.SetTransObject(SQLCA)
dw_judg.SetTransObject(SQLCA)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
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

 
is_fr_yymm =  dw_head.GetItemstring(1, "fr_yymm")
if IsNull(is_fr_yymm) OR is_fr_yymm = "" then
   MessageBox(ls_title,"from년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymm")
   return false
end if

//messagebox('1', 'is_fr_yymm =' + is_fr_yymm )

is_to_yymm =  dw_head.GetItemstring(1, "to_yymm")
if IsNull(is_to_yymm) OR is_to_yymm = "" then
   MessageBox(ls_title,"to년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   return false
end if

//messagebox('2', 'is_to_yymm = ' + is_to_yymm)

is_brand =  dw_head.GetItemstring(1, "brand")
if IsNull(is_brand) OR is_brand = "" then
   MessageBox(ls_title,"브랜드를 입력하세요")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_opt =  dw_head.GetItemstring(1, "opt_view")
is_receipt_type =  dw_head.GetItemstring(1, "receipt_type")
is_year =  dw_head.GetItemstring(1, "year")
is_season =  dw_head.GetItemstring(1, "season")

return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

 
 if is_opt = "%" then 
  		tab_1.tabpage_1.dw_1.dataobject = "d_79002_d01"
		tab_1.tabpage_2.dw_2.dataobject = "d_79002_d03"
		tab_1.tabpage_5.dw_5.dataobject = "d_79002_d06"
elseif is_opt = "AA" then 		  
  		tab_1.tabpage_1.dw_1.dataobject = "d_79002_d11"	
		tab_1.tabpage_2.dw_2.dataobject = "d_79002_d13"		  		  
elseif is_opt = "BA" then 		  
  		tab_1.tabpage_1.dw_1.dataobject = "d_79002_d21"	
		tab_1.tabpage_2.dw_2.dataobject = "d_79002_d23"		  		  
elseif is_opt = "DA1" then 		  
  		tab_1.tabpage_1.dw_1.dataobject = "d_79002_d31"	
		tab_1.tabpage_2.dw_2.dataobject = "d_79002_d33"		  		  
elseif is_opt = "DA2" then 		  
  		tab_1.tabpage_1.dw_1.dataobject = "d_79002_d41"	
		tab_1.tabpage_2.dw_2.dataobject = "d_79002_d43"		  		  
elseif is_opt = "DA3" then 		  
  		tab_1.tabpage_1.dw_1.dataobject = "d_79002_d51"	
		tab_1.tabpage_2.dw_2.dataobject = "d_79002_d53"		  		  
elseif is_opt = "DA4" then 		  
  		tab_1.tabpage_1.dw_1.dataobject = "d_79002_d61"	
		tab_1.tabpage_2.dw_2.dataobject = "d_79002_d63"		  		  
end if		  
	   tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
	   tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)		
	   tab_1.tabpage_5.dw_5.SetTransObject(SQLCA) 
 
		Choose Case tab_1.SelectedTab
			Case 1
				il_rows = tab_1.tabpage_1.dw_1.retrieve(is_fr_yymm, is_to_yymm, is_receipt_type, is_year, is_season)
				lb_ret_chk1 = True
			Case 2
				il_rows = tab_1.tabpage_2.dw_2.retrieve(is_fr_yymm, is_to_yymm, is_receipt_type, is_year, is_season)
				lb_ret_chk2 = True
			Case 3
				il_rows = tab_1.tabpage_3.dw_3.retrieve(is_fr_yymm, is_to_yymm, is_receipt_type, is_year, is_season)
				lb_ret_chk3 = True
			Case 4
				il_rows = tab_1.tabpage_4.dw_4.retrieve(is_fr_yymm, is_to_yymm, is_brand, is_receipt_type, is_year, is_season)				
				lb_ret_chk4 = True
			Case 5
				il_rows = tab_1.tabpage_5.dw_5.retrieve(is_fr_yymm, is_to_yymm)
				lb_ret_chk5 = True
			Case 6
				il_rows = tab_1.tabpage_6.dw_6.retrieve(is_fr_yymm, is_to_yymm, is_receipt_type, is_year, is_season)
				lb_ret_chk6 = True
			Case 7
				il_rows = tab_1.tabpage_7.dw_7.retrieve(is_fr_yymm, is_to_yymm, is_year, is_season)
				lb_ret_chk7 = True
		END Choose

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

event ue_button;/*===========================================================================*/
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
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
//         cb_retrieve.Text = "조건(&Q)"
//         dw_head.Enabled = false
//         dw_body.Enabled = true
//         tab_1.Enabled = true
//         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
//		dw_body.Enabled = false
//		tab_1.Enabled = false
//		lb_ret_chk1 = False
//		lb_ret_chk2 = False
//		lb_ret_chk3 = False
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

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
Choose Case Tab_1.SelectedTab
	Case 1
		li_ret = Tab_1.TabPage_1.dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 2
		li_ret = Tab_1.TabPage_2.dw_2.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 3
		li_ret = Tab_1.TabPage_3.dw_3.SaveAs(ls_doc_nm, Excel!, TRUE)
	case 5
		li_ret = Tab_1.Tabpage_5.dw_5.SaveAs(ls_doc_nm, Excel!, TRUE)
	case 6
		li_ret = Tab_1.Tabpage_6.dw_6.SaveAs(ls_doc_nm, Excel!, TRUE)
	case 7
		li_ret = Tab_1.Tabpage_7.dw_7.SaveAs(ls_doc_nm, Excel!, TRUE)
End Choose

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_79002_d","0")
end event

event ue_title();/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
/*
datetime ld_datetime
string ls_modify, ls_datetime, ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
*/
/*
if is_opt = "%" then 
	ls_title = "전체"
elseif is_opt = "AA" then 	
	ls_title = "원단/업체별"	
elseif is_opt = "BA" then 	
	ls_title = "봉제/업체별"	
elseif is_opt = "DA1" then 	
	ls_title = "완사입/업체별(니트,진)"	
elseif is_opt = "DA2" then 	
	ls_title = "완사입/업체별(특종)"		
elseif is_opt = "DA3" then 	
	ls_title = "완사입/업체별(우븐)"		
elseif is_opt = "DA4" then 	
	ls_title = "완사입/업체별(ACC)"		
end if 
*/
/*
ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
				 "t_fr_yymm.Text = '" + is_fr_yymm + "'" + &
				 "t_to_yymm.Text = '" + is_to_yymm + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"   
*/

/*
dw_print.object.t_pg_id.Text = is_pgm_id
dw_print.object.t_user_id.Text = gs_user_id
dw_print.object.t_fr_yymm.Text = is_fr_yymm
dw_print.object.t_to_yymm.Text = is_to_yymm
dw_print.object.t_datetime.Text = ls_datetime
dw_print.object.t_title.Text = ls_title

dw_print.Modify(ls_modify)

*/

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

//This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로

datetime ld_datetime
string ls_modify, ls_datetime, ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

if is_opt = "%" then 
	dw_print.dataobject = "d_79002_r05"
   dw_print.SetTransObject(SQLCA)		  
	il_rows = dw_print.retrieve(is_fr_yymm,is_to_yymm, is_receipt_type, is_year, is_season)		  
	
	dw_print.object.t_pg_id.Text = is_pgm_id
	dw_print.object.t_user_id.Text = gs_user_id
	dw_print.object.t_fr_yymm.Text = is_fr_yymm
	dw_print.object.t_to_yymm.Text = is_to_yymm
	dw_print.object.t_datetime.Text = ls_datetime
else
	if tab_1.selectedtab = 1 then
  		dw_print.dataobject = "d_79002_r11"	
	   tab_1.tabpage_1.dw_1.ShareData(dw_print)			  
	elseif tab_1.selectedtab = 2 then	  
  		dw_print.dataobject = "d_79002_r13"		
		tab_1.tabpage_2.dw_2.ShareData(dw_print)				  
	else	  
  		dw_print.dataobject = "d_79002_r05"
	   dw_print.SetTransObject(SQLCA)			  
		il_rows = dw_print.retrieve(is_fr_yymm,is_to_yymm, is_receipt_type, is_year, is_season)			  
	end if
end if		  
dw_print.inv_printpreview.of_SetZoom()


end event

event ue_print();

This.Trigger Event ue_title()

 if is_opt = "%" then 
  		dw_print.dataobject = "d_79002_r05"
	   dw_print.SetTransObject(SQLCA)		  
		il_rows = dw_print.retrieve(is_fr_yymm,is_to_yymm, is_receipt_type, is_year, is_season)		  
else
		if tab_1.selectedtab = 1 then
	  		dw_print.dataobject = "d_79002_r11"	
		   tab_1.tabpage_1.dw_1.ShareData(dw_print)			  
		elseif tab_1.selectedtab = 2 then	  
	  		dw_print.dataobject = "d_79002_r13"		
			tab_1.tabpage_2.dw_2.ShareData(dw_print)				  
		else	  
	  		dw_print.dataobject = "d_79002_r05"
		   dw_print.SetTransObject(SQLCA)			  
			il_rows = dw_print.retrieve(is_fr_yymm,is_to_yymm, is_receipt_type, is_year, is_season)			  
		end if	  
end if		  

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.20                                                  */	
/* 수정일      : 2002.03.20                                                  */
/*===========================================================================*/
String     ls_card_no, ls_jumin, ls_custom_nm, ls_tel_no1, ls_tel_no2, ls_tel_no3, ls_null, ls_tel_no, ls_user_name,ls_part_nm
String     ls_style_no, ls_year, ls_season, ls_sojae, ls_item, ls_st_cust_cd, ls_st_cust_nm, ls_mat_cust_cd, ls_mat_cust_nm, ls_mat_cd, ls_mat_nm
Integer    li_sex, li_return, li_okyes
Boolean    lb_check
Decimal    ldc_tag_price
DataStore  lds_Source

SetNull(ls_null)

CHOOSE CASE as_column
	CASE "fix_cust"							// 생산처 코드
	   is_brand = Trim(dw_head.GetItemString(1, "brand"))
			
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					dw_judg.SetItem(al_row, "fix_cust_nm", "")
					RETURN 0
				End If
				
				Choose Case is_brand
					Case 'J'
						IF (LeftA(as_data, 1) = 'N' or LeftA(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_judg.SetItem(al_row, "fix_cust_nm", ls_part_nm)
							RETURN 0
						END IF
					Case 'Y'
						IF (LeftA(as_data, 1) = 'O' or LeftA(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_judg.SetItem(al_row, "fix_cust_nm", ls_part_nm)
							RETURN 0
						END IF
					Case Else
						IF LeftA(as_data, 1) = is_brand and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_judg.SetItem(al_row, "fix_cust_nm", ls_part_nm)
							RETURN 0
						END IF
				End Choose
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재/생산 거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911" 
			Choose Case is_brand
				Case 'J'
					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
				Case 'Y'
					gst_cd.default_where   = " WHERE BRAND IN ('O', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
				Case 'W'
					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "		
				Case 'I'
					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "													 													 
				Case Else
					gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' " + &
													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
			End Choose
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " CUSTCODE LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_judg.SetRow(al_row)
				dw_judg.SetColumn(as_column)
				dw_judg.SetItem(al_row, "fix_cust", lds_Source.GetItemString(1,"custcode"))
				dw_judg.SetItem(al_row, "fix_cust_nm", lds_Source.GetItemString(1,"cust_sname"))
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

type cb_close from w_com010_d`cb_close within w_79002_d
end type

type cb_delete from w_com010_d`cb_delete within w_79002_d
end type

type cb_insert from w_com010_d`cb_insert within w_79002_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_79002_d
end type

type cb_update from w_com010_d`cb_update within w_79002_d
end type

type cb_print from w_com010_d`cb_print within w_79002_d
end type

type cb_preview from w_com010_d`cb_preview within w_79002_d
end type

type gb_button from w_com010_d`gb_button within w_79002_d
end type

type cb_excel from w_com010_d`cb_excel within w_79002_d
end type

type dw_head from w_com010_d`dw_head within w_79002_d
integer x = 96
integer y = 156
integer width = 3255
integer height = 188
string dataobject = "d_79002_h01"
end type

event dw_head::itemchanged;call super::itemchanged;
string ls_year, ls_brand
DataWindowChild ldw_child


lb_ret_chk1 = False
lb_ret_chk2 = False
lb_ret_chk3 = False
lb_ret_chk4 = False
lb_ret_chk5 = False


CHOOSE CASE dwo.name
	CASE "brand"
		
//		This.GetChild("sojae", ldw_child)
//		ldw_child.SetTransObject(SQLCA)
//		ldw_child.Retrieve('%', data)
//		ldw_child.insertrow(1)
//		ldw_child.Setitem(1, "sojae", "%")
//		ldw_child.Setitem(1, "sojae_nm", "전체")
		
		
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")				
		 		
		
END CHOOSE
end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')
end event

type ln_1 from w_com010_d`ln_1 within w_79002_d
integer beginx = 14
integer beginy = 352
integer endx = 3634
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_79002_d
integer beginx = 14
integer beginy = 356
integer endx = 3634
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_79002_d
boolean visible = false
integer y = 376
integer height = 1664
boolean enabled = false
end type

type dw_print from w_com010_d`dw_print within w_79002_d
integer x = 110
integer y = 296
integer height = 384
string dataobject = "d_79002_r05"
end type

type tab_1 from tab within w_79002_d
event type boolean ue_keycheck ( string as_cb_div )
integer x = 14
integer y = 372
integer width = 3579
integer height = 1648
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
end type

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
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

 
is_fr_yymm =  dw_head.GetItemstring(1, "fr_yymm")
if IsNull(is_fr_yymm) OR is_fr_yymm = "" then
   MessageBox(ls_title,"from년월일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymm")
   return false
end if

is_to_yymm =  dw_head.GetItemstring(1, "to_yymm")
if IsNull(is_to_yymm) OR is_to_yymm = "" then
   MessageBox(ls_title,"to년월일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   return false
end if

is_brand=  dw_head.GetItemstring(1, "brand")
if IsNull(is_brand) OR is_brand = "" then
   MessageBox(ls_title,"브랜드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

return true

end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_7}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
end on

event selectionchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
If oldindex > 0 Then
	
	/* dw_head 필수입력 column check */
	IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
	
	 
			Choose Case newindex
				Case 1
					If lb_ret_chk1 = False Then
						il_rows = This.Tabpage_1.dw_1.Retrieve(is_fr_yymm, is_to_yymm, is_receipt_type, is_year, is_season)
						lb_ret_chk1 = True
					End If
				Case 2
					If lb_ret_chk2 = False Then
						il_rows = This.Tabpage_2.dw_2.Retrieve(is_fr_yymm, is_to_yymm, is_receipt_type, is_year, is_season)
						lb_ret_chk2 = True
					End If
				Case 3
					If lb_ret_chk3 = False Then
						il_rows = This.Tabpage_3.dw_3.Retrieve(is_fr_yymm, is_to_yymm, is_receipt_type, is_year, is_season)
						lb_ret_chk3 = True
					End If
				Case 4
					If lb_ret_chk4 = False Then
						il_rows = This.Tabpage_4.dw_4.Retrieve(is_fr_yymm, is_to_yymm, is_brand, is_receipt_type, is_year, is_season)
						lb_ret_chk4 = True
					End If
				Case 5
					If lb_ret_chk5 = False Then
						il_rows = This.Tabpage_5.dw_5.Retrieve(is_fr_yymm, is_to_yymm)
						lb_ret_chk5 = True
					End If
				Case 6
					If lb_ret_chk6 = False Then
						il_rows = This.Tabpage_6.dw_6.Retrieve(is_fr_yymm, is_to_yymm, is_receipt_type, is_year, is_season)
						lb_ret_chk6 = True
					End If
				Case 7
					If lb_ret_chk7 = False Then
						il_rows = This.Tabpage_7.dw_7.Retrieve(is_fr_yymm, is_to_yymm, is_year, is_season)
						lb_ret_chk7 = True
					End If
			End Choose
	   
End If

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3543
integer height = 1536
long backcolor = 79741120
string text = "기간별처리내역"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within tabpage_1
integer x = 9
integer y = 16
integer width = 3511
integer height = 1508
integer taborder = 20
string title = "none"
string dataobject = "d_79002_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3543
integer height = 1536
long backcolor = 79741120
string text = "브랜드별접수량"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_2
integer x = 9
integer y = 16
integer width = 3515
integer height = 1516
integer taborder = 10
string title = "none"
string dataobject = "d_79002_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3543
integer height = 1536
long backcolor = 79741120
string text = "발생유형별접수내역"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from datawindow within tabpage_3
integer x = 9
integer y = 16
integer width = 3515
integer height = 1496
integer taborder = 10
string title = "none"
string dataobject = "d_79002_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;////claim_qty7
//long ll_cnt
//string ls_brand
//
//tab_1.tabpage_3.dw_3.accepttext()
//ls_brand = tab_1.tabpage_3.dw_3.getitemstring(getrow(),'brand')
//ll_cnt = tab_1.tabpage_3.dw_3.getitemnumber(getrow(),'claim_qty7')
//
//CHOOSE CASE dwo.name
//	CASE "claim_qty7"      //  Popup 검색창이 존재하는 항목 
//
//		IF ib_itemchanged THEN RETURN 1
//		if isnull(ll_cnt) or ll_cnt < 1 then 
//			return 1
//		end if		
//		dw_9.retrieve(ls_brand, is_fr_yymm, is_to_yymm, is_year, is_season)
//		IF ll_cnt > 0 THEN
//			dw_9.visible = true
//		ELSE
//			dw_9.visible = false
//		END IF
//END CHOOSE
end event

event itemfocuschanged;//claim_qty7
long ll_cnt
string ls_brand

tab_1.tabpage_3.dw_3.accepttext()
ls_brand = tab_1.tabpage_3.dw_3.getitemstring(getrow(),'brand')
ll_cnt = tab_1.tabpage_3.dw_3.getitemnumber(getrow(),'claim_qty7')

CHOOSE CASE dwo.name
	CASE "claim_qty7"      //  Popup 검색창이 존재하는 항목 
		if isnull(ll_cnt) or ll_cnt < 1 then 
			return 1
		end if		
		dw_9.retrieve(ls_brand, is_fr_yymm, is_to_yymm, is_year, is_season)
		IF ll_cnt > 0 THEN
			dw_9.visible = true
		ELSE
			dw_9.visible = false
		END IF
END CHOOSE
end event

type tabpage_4 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 3543
integer height = 1536
long backcolor = 79741120
string text = "처리지연내역(15일이상)"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
rb_day_diff rb_day_diff
rb_cust_cd rb_cust_cd
rb_style rb_style
dw_4 dw_4
end type

on tabpage_4.create
this.rb_day_diff=create rb_day_diff
this.rb_cust_cd=create rb_cust_cd
this.rb_style=create rb_style
this.dw_4=create dw_4
this.Control[]={this.rb_day_diff,&
this.rb_cust_cd,&
this.rb_style,&
this.dw_4}
end on

on tabpage_4.destroy
destroy(this.rb_day_diff)
destroy(this.rb_cust_cd)
destroy(this.rb_style)
destroy(this.dw_4)
end on

type rb_day_diff from radiobutton within tabpage_4
integer x = 960
integer y = 36
integer width = 402
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "기간별 정렬"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;tab_1.Tabpage_4.dw_4.setsort("DD d")
tab_1.Tabpage_4.dw_4.Sort( )


end event

type rb_cust_cd from radiobutton within tabpage_4
integer x = 526
integer y = 28
integer width = 494
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "업체별 정렬"
borderstyle borderstyle = stylelowered!
end type

event clicked;tab_1.Tabpage_4.dw_4.setsort("cust_cd")
tab_1.Tabpage_4.dw_4.Sort( )
end event

type rb_style from radiobutton within tabpage_4
integer x = 73
integer y = 32
integer width = 517
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "스타일순정렬"
borderstyle borderstyle = stylelowered!
end type

event clicked;tab_1.Tabpage_4.dw_4.setsort("style, chno")
tab_1.Tabpage_4.dw_4.Sort( )
end event

type dw_4 from datawindow within tabpage_4
integer y = 128
integer width = 3538
integer height = 1408
integer taborder = 110
string title = "none"
string dataobject = "d_79002_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3543
integer height = 1536
long backcolor = 79741120
string text = "문의유형별 상담내역"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_5.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_5.destroy
destroy(this.dw_5)
end on

type dw_5 from datawindow within tabpage_5
integer x = 9
integer y = 16
integer width = 3515
integer height = 1496
integer taborder = 10
string title = "none"
string dataobject = "d_79002_d06"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3543
integer height = 1536
long backcolor = 79741120
string text = "담당부서별 접수량"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_6 dw_6
end type

on tabpage_6.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tabpage_6.destroy
destroy(this.dw_6)
end on

type dw_6 from datawindow within tabpage_6
integer x = 9
integer y = 16
integer width = 3515
integer height = 1496
integer taborder = 120
string title = "none"
string dataobject = "d_79002_d07"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3543
integer height = 1536
long backcolor = 79741120
string text = "년도별 접수량"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_7 dw_7
end type

on tabpage_7.create
this.dw_7=create dw_7
this.Control[]={this.dw_7}
end on

on tabpage_7.destroy
destroy(this.dw_7)
end on

type dw_7 from datawindow within tabpage_7
integer x = 9
integer y = 16
integer width = 3515
integer height = 1496
integer taborder = 120
string title = "none"
string dataobject = "d_79002_d08"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_9 from datawindow within w_79002_d
boolean visible = false
integer x = 443
integer y = 832
integer width = 2985
integer height = 1536
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "미분류건 내역"
string dataobject = "d_79002_d09"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_yymmdd, ls_seq
long ll_cnt
ls_yymmdd = dw_9.getitemstring(getrow(),'b_yymmdd')
ls_seq = dw_9.getitemstring(getrow(), 'b_seq_no')

ll_cnt = dw_judg.retrieve(ls_yymmdd, ls_seq)
IF ll_cnt > 0 THEN
	dw_judg.visible = true
ELSE
	dw_judg.visible = false
END IF

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

event rowfocuschanged;if currentrow < 1 then return
this.selectrow(0,false)
this.selectrow(currentrow,true)
end event

type dw_judg from datawindow within w_79002_d
boolean visible = false
integer x = 846
integer y = 828
integer width = 2450
integer height = 1700
integer taborder = 110
boolean bringtotop = true
boolean titlebar = true
string title = "판정"
string dataobject = "d_79002_d10"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dberror;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 2627
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 515
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

This.ScrollTorow(row)
This.SetRow(row)
This.SetFocus()

MessageBox(parent.title, ls_message_string)
return 1
end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report, ls_yymmdd, ls_judg_fg, ls_brand, ls_gubn, ls_go_ymd, ls_go_ymd2
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

ls_gubn = dw_judg.getitemstring(row,'go_gubn')
ls_go_ymd = dw_judg.getitemstring(row,'go_ymd')
ls_go_ymd2 = dw_judg.getitemstring(row,'go_ymd2')

Choose Case ls_column_nm
	Case "ok"
		IF dw_judg.AcceptText() <> 1 THEN RETURN
		if ls_gubn = '01' or ls_gubn = '02' or ls_gubn = '03' or ls_gubn = '04' then
			if isnull(ls_go_ymd) or ls_go_ymd = '' or LenA(ls_go_ymd) <> 8 then
				if isnull(ls_go_ymd2) or ls_go_ymd2 = '' or LenA(ls_go_ymd2) <> 8 then
					messagebox('확인','고객발송일을 입력해 주세요!')
					return 0
				end if
			end if
		elseif ls_gubn = '' or isnull(ls_gubn) then
				if ls_go_ymd = '' or LenA(ls_go_ymd) <> 8 then
					messagebox('확인','행랑발송일을 형식이 틀립니다. 확인해 주세요!')
					return 0
				end if
		end if		
		
		if dw_judg.update () = 1  then
			 COMMIT USING SQLCA;
		else			
			 ROLLBACK USING SQLCA;
			 messagebox('저장오류','판정 저장에 오류가 있습니다. 전산실에 문의 하십시오!')
			 RETURN
		end if
	Case "copy1"
		This.SetItem(row, "request", This.GetItemString(row, "problem"))
		ib_changed = true
		cb_update.enabled = false
		cb_print.enabled = false
		cb_preview.enabled = false
		cb_excel.enabled = false
	Case "copy2"
		This.SetItem(row, "result",  This.GetItemString(row, "problem"))
		ib_changed = true
		cb_update.enabled = false
		cb_print.enabled = false
		cb_preview.enabled = false
		cb_excel.enabled = false
	Case "fix_cust"
		Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)		
//	Case Else
//		Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)
End Choose

This.Visible = False

ls_brand = tab_1.tabpage_3.dw_3.getitemstring(getrow(),'brand')
dw_9.retrieve(ls_brand, is_fr_yymm, is_to_yymm, is_year, is_season)


end event

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
DataWindowChild ldw_child



This.GetChild("judg_l", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('795')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("judg_s", idw_judg_s)
idw_judg_s.SetTransObject(SQLCA)
idw_judg_s.Retrieve('796','%')
idw_judg_s.InsertRow(1)
idw_judg_s.SetItem(1, "inter_cd", '')
idw_judg_s.SetItem(1, "inter_nm", '')

This.GetChild("pay_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('797')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("deal_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('798')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("claim_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('79A')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("CUST_FG_L", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('79B')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')


This.GetChild("CUST_FG_S", idw_cust_fg_s)
idw_cust_fg_s.SetTransObject(SQLCA)
idw_cust_fg_s.InsertRow(0)

This.GetChild("decision_a", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('79D')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("decision_b", idw_decision_b)
idw_decision_b.SetTransObject(SQLCA)
idw_decision_b.InsertRow(0)

This.GetChild("decision_c", idw_decision_c)
idw_decision_c.SetTransObject(SQLCA)
idw_decision_c.InsertRow(0)

This.GetChild("decision_d", idw_decision_d)
idw_decision_d.SetTransObject(SQLCA)
idw_decision_d.InsertRow(0)


This.GetChild("go_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('79H')

dw_judg.object.pay_kamt.visible = false
dw_judg.setitem(1,'pay_kamt',0)



end event

event editchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = true
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemerror;return 1
end event

event itemfocuschanged;String ls_judg_l, LS_CUST_FG_L, ls_decision_a, ls_decision_b, ls_decision_c, ls_decision_d

CHOOSE CASE dwo.name
	CASE "judg_s"
		ls_judg_l = This.GetItemString(row, "judg_l")
		idw_judg_s.Retrieve('796', ls_judg_l)
		idw_judg_s.InsertRow(1)
		idw_judg_s.SetItem(1, "inter_cd", '')
		idw_judg_s.SetItem(1, "inter_nm", '')
	CASE "cust_fg_s"
		LS_CUST_FG_L = This.GetItemString(row, "CUST_FG_L")
		idw_cust_fg_s.Retrieve('79C', LS_CUST_FG_L)
		idw_cust_fg_s.InsertRow(1)
		idw_cust_fg_s.SetItem(1, "inter_cd", '')
		idw_cust_fg_s.SetItem(1, "inter_nm", '')		
	CASE "decision_b"
		ls_decision_a = This.GetItemString(row, "decision_a")

		idw_decision_b.Retrieve('79E', ls_decision_a)
		idw_decision_b.InsertRow(1)
		idw_decision_b.SetItem(1, "inter_cd", '')
		idw_decision_b.SetItem(1, "inter_nm", '')		
	CASE "decision_c"
		ls_decision_b = This.GetItemString(row, "decision_b")

		idw_decision_c.Retrieve('79F', ls_decision_b)
		idw_decision_c.InsertRow(1)
		idw_decision_c.SetItem(1, "inter_cd", '')
		idw_decision_c.SetItem(1, "inter_nm", '')		
	CASE "decision_d"
		ls_decision_c = This.GetItemString(row, "decision_c")

		idw_decision_d.Retrieve('79G', ls_decision_c)
		idw_decision_d.InsertRow(1)
		idw_decision_d.SetItem(1, "inter_cd", '')
		idw_decision_d.SetItem(1, "inter_nm", '')				
		

		
		
END CHOOSE

end event

