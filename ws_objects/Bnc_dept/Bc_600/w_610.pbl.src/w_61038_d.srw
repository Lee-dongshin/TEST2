$PBExportHeader$w_61038_d.srw
$PBExportComments$경영정보손익실적
forward
global type w_61038_d from w_com010_d
end type
type tab_1 from tab within w_61038_d
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
type dw_4 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
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
type tab_1 from tab within w_61038_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type
type st_1 from statictext within w_61038_d
end type
end forward

global type w_61038_d from w_com010_d
integer width = 3675
integer height = 2284
tab_1 tab_1
st_1 st_1
end type
global w_61038_d w_61038_d

type variables
string is_brand, is_fr_yymm, is_to_yymm
datawindowchild  idw_brand

Boolean lb_ret_chk1 = False, lb_ret_chk2 = False, lb_ret_chk3 = False, lb_ret_chk4 = False, lb_ret_chk5 = False, lb_ret_chk6 = False
end variables

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61039_d","0")
end event

event open;call super::open;string  ls_fr_yymm 
ls_fr_yymm = dw_head.GetItemString(1, "fr_yymm")

is_fr_yymm  =   LeftA(ls_fr_yymm,4) + '01'

dw_head.Setitem(1,'fr_yymm' , is_fr_yymm)




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

tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)
tab_1.tabpage_4.dw_4.SetTransObject(SQLCA)
tab_1.tabpage_5.dw_5.SetTransObject(SQLCA)
tab_1.tabpage_6.dw_6.SetTransObject(SQLCA)

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;///*===========================================================================*/
///* 작성자      : (주)지우정보 (김 태범)                                      */	
///* 작성일      : 2001.01.01                                                  */	
///* 수정일      : 2001.01.01                                                  */
///*===========================================================================*/
///* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
///*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
///*===========================================================================*/
//
//CHOOSE CASE ai_cb_div
//   CASE 1		/* 조회 */
//      if al_rows > 0 then
//         cb_print.enabled = true
//         cb_preview.enabled = true
//         cb_excel.enabled = true
////         cb_retrieve.Text = "조건(&Q)"
////         dw_head.Enabled = false
////         dw_body.Enabled = true
////         tab_1.Enabled = true
////         dw_body.SetFocus()
//      else
//         cb_print.enabled = false
//         cb_preview.enabled = false
//         cb_excel.enabled = false
//      end if
//
//      if al_rows >= 0 then
//         ib_changed = false
//         cb_update.enabled = false
//      end if
//		
//   CASE 5    /* 조건 */
//      cb_retrieve.Text = "조회(&Q)"
//      cb_print.enabled = false
//      cb_preview.enabled = false
//      cb_excel.enabled = false
//      ib_changed = false
////		dw_body.Enabled = false
////		tab_1.Enabled = false
////		lb_ret_chk1 = False
////		lb_ret_chk2 = False
////		lb_ret_chk3 = False
//      dw_head.Enabled = true
//      dw_head.SetFocus()
//      dw_head.SetColumn(1)
//	
//END CHOOSE
//
end event

event ue_excel();call super::ue_excel;/*===========================================================================*/
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
	Case 4
		li_ret = Tab_1.TabPage_4.dw_4.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 5
		li_ret = Tab_1.TabPage_5.dw_5.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 6
		li_ret = Tab_1.TabPage_6.dw_6.SaveAs(ls_doc_nm, Excel!, TRUE)
End Choose

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_title, ls_m_gubun

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
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_fr_yymm = dw_head.GetItemString(1, "fr_yymm")


if IsNull(is_fr_yymm) or Trim(is_fr_yymm) = "" then
   MessageBox(ls_title,"From 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymm")
   return false
end if

is_to_yymm = dw_head.GetItemString(1, "to_yymm")
if IsNull(is_to_yymm) or Trim(is_to_yymm) = "" then
   MessageBox(ls_title,"To 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   return false
end if

//ls_m_gubun = dw_head.GetItemString(1, "m_gubun")
//
//if ls_m_gubun = '1' then
//	is_fr_yymm = is_to_yymm
//end if
return true

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/



dw_print.retrieve(is_brand,is_fr_yymm,is_to_yymm)

This.Trigger Event ue_title ()


dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/


dw_print.retrieve(is_brand,is_fr_yymm,is_to_yymm)

This.Trigger Event ue_title()

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


		Choose Case tab_1.SelectedTab
			Case 1
				il_rows = tab_1.tabpage_1.dw_1.retrieve('%',is_fr_yymm,is_to_yymm)
				is_brand = '%'
				
			Case 2
				il_rows = tab_1.tabpage_2.dw_2.retrieve('N',is_fr_yymm,is_to_yymm)
				is_brand = 'N'
			
			Case 3
				il_rows = tab_1.tabpage_3.dw_3.retrieve('O',is_fr_yymm,is_to_yymm)
				is_brand = 'O'
			
			Case 4
				il_rows = tab_1.tabpage_4.dw_4.retrieve('W',is_fr_yymm,is_to_yymm)
				is_brand = 'W'
			
			Case 5
				il_rows = tab_1.tabpage_5.dw_5.retrieve('B',is_fr_yymm,is_to_yymm)
				is_brand = 'B'
				
			Case 6
				il_rows = tab_1.tabpage_6.dw_6.retrieve('U',is_fr_yymm,is_to_yymm)
				is_brand = 'U'
				
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

event ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_brand_nm 

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if  		is_brand = '%' then 
	 		ls_brand_nm = '국내전체' 
elseif	is_brand = 'N' then 
	 		ls_brand_nm = '온앤온' 
elseif	is_brand = 'O' then 
	 		ls_brand_nm = '올리브' 
elseif	is_brand = 'W' then 
	 		ls_brand_nm = '더블유닷' 		
elseif	is_brand = 'B' then 
	 		ls_brand_nm = '쇼핑몰' 			 
elseif	is_brand = 'U' then 
	 		ls_brand_nm = '미주' 
end if
		
		
ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	 "t_brand.Text = '" + ls_brand_nm  + "'" + &
             "t_fr_yymm.Text = '" + String(is_fr_yymm, '@@@@/@@')  + "'" + &
             "t_to_yymm.Text = '" + String(is_to_yymm, '@@@@/@@') + "'"

dw_print.Modify(ls_modify)


end event

on w_61038_d.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.st_1
end on

on w_61038_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.st_1)
end on

type cb_close from w_com010_d`cb_close within w_61038_d
end type

type cb_delete from w_com010_d`cb_delete within w_61038_d
end type

type cb_insert from w_com010_d`cb_insert within w_61038_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61038_d
end type

type cb_update from w_com010_d`cb_update within w_61038_d
end type

type cb_print from w_com010_d`cb_print within w_61038_d
end type

type cb_preview from w_com010_d`cb_preview within w_61038_d
end type

type gb_button from w_com010_d`gb_button within w_61038_d
end type

type cb_excel from w_com010_d`cb_excel within w_61038_d
end type

type dw_head from w_com010_d`dw_head within w_61038_d
integer x = 18
integer y = 164
integer width = 2400
integer height = 116
string dataobject = "d_61038_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

//idw_brand.InsertRow(1)
//idw_brand.SetItem(1,'inter_cd','S')
//idw_brand.SetItem(1,'inter_nm','쇼핑몰')

//
//idw_brand.InsertRow(1)
//idw_brand.SetItem(1,'inter_cd','Z')
//idw_brand.SetItem(1,'inter_nm','보끄레총괄')
//
idw_brand.InsertRow(1)
idw_brand.SetItem(1,'inter_cd','%')
idw_brand.SetItem(1,'inter_nm','전체')


end event

type ln_1 from w_com010_d`ln_1 within w_61038_d
integer beginy = 296
integer endy = 296
end type

type ln_2 from w_com010_d`ln_2 within w_61038_d
integer beginy = 300
integer endy = 300
end type

type dw_body from w_com010_d`dw_body within w_61038_d
end type

type dw_print from w_com010_d`dw_print within w_61038_d
integer x = 1778
integer y = 612
string dataobject = "d_61038_r01"
end type

type tab_1 from tab within w_61038_d
event type boolean ue_keycheck ( string as_cb_div )
integer x = 5
integer y = 304
integer width = 3589
integer height = 1740
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
end type

event ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_title, ls_m_gubun

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
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_fr_yymm = dw_head.GetItemString(1, "fr_yymm")


if IsNull(is_fr_yymm) or Trim(is_fr_yymm) = "" then
   MessageBox(ls_title,"From 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymm")
   return false
end if

is_to_yymm = dw_head.GetItemString(1, "to_yymm")
if IsNull(is_to_yymm) or Trim(is_to_yymm) = "" then
   MessageBox(ls_title,"To 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   return false
end if

//ls_m_gubun = dw_head.GetItemString(1, "m_gubun")
//
//if ls_m_gubun = '1' then
//	is_fr_yymm = is_to_yymm
//end if
return true

end event

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
					is_brand = '%'
					il_rows = This.Tabpage_1.dw_1.Retrieve('%', is_fr_yymm, is_to_yymm)
					
				Case 2
					is_brand = 'N'
					il_rows = This.Tabpage_2.dw_2.Retrieve('N', is_fr_yymm, is_to_yymm)
				
				Case 3
					is_brand = 'O'
					il_rows = This.Tabpage_3.dw_3.Retrieve('O', is_fr_yymm, is_to_yymm)
					
					
				Case 4
					is_brand = 'W'
					il_rows = This.Tabpage_4.dw_4.Retrieve('W', is_fr_yymm, is_to_yymm)
					
				Case 5
					is_brand = 'B'
					il_rows = This.Tabpage_5.dw_5.Retrieve('B', is_fr_yymm, is_to_yymm)
	
				Case 6
					is_brand = 'U'
					il_rows = This.Tabpage_6.dw_6.Retrieve('U', is_fr_yymm, is_to_yymm)

			End Choose
		
End If

end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1628
long backcolor = 79741120
string text = "국내전체"
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
integer x = 5
integer y = 12
integer width = 3547
integer height = 1620
integer taborder = 110
string title = "none"
string dataobject = "d_61038_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1628
long backcolor = 79741120
string text = "온앤온"
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
integer x = 5
integer y = 12
integer width = 3547
integer height = 1616
integer taborder = 110
string title = "none"
string dataobject = "d_61038_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1628
long backcolor = 79741120
string text = "올리브"
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
integer x = 5
integer y = 12
integer width = 3547
integer height = 1616
integer taborder = 120
string title = "none"
string dataobject = "d_61038_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1628
long backcolor = 79741120
string text = "더블유닷"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_4 dw_4
end type

on tabpage_4.create
this.dw_4=create dw_4
this.Control[]={this.dw_4}
end on

on tabpage_4.destroy
destroy(this.dw_4)
end on

type dw_4 from datawindow within tabpage_4
integer x = 5
integer y = 12
integer width = 3547
integer height = 1620
integer taborder = 120
string title = "none"
string dataobject = "d_61038_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1628
long backcolor = 79741120
string text = "쇼핑몰"
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
integer x = 5
integer y = 12
integer width = 3547
integer height = 1616
integer taborder = 120
string title = "none"
string dataobject = "d_61038_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1628
long backcolor = 79741120
string text = "미주수출"
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
integer x = 5
integer y = 12
integer width = 3547
integer height = 1616
integer taborder = 120
string title = "none"
string dataobject = "d_61038_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_61038_d
integer x = 3013
integer y = 332
integer width = 535
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
string text = "(단위:백만원, +vat)"
boolean focusrectangle = false
end type

