$PBExportHeader$w_56004_d.srw
$PBExportComments$마진율 조회
forward
global type w_56004_d from w_com020_d
end type
type dw_1 from datawindow within w_56004_d
end type
type dw_2 from datawindow within w_56004_d
end type
type dw_3 from u_dw within w_56004_d
end type
type tab_1 from tab within w_56004_d
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tab_1 from tab within w_56004_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
end forward

global type w_56004_d from w_com020_d
integer width = 3675
integer height = 2284
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
tab_1 tab_1
end type
global w_56004_d w_56004_d

type variables
String is_brand, is_year, is_season, is_yymmdd
String is_shop_div, is_shop_cd  
end variables

on w_56004_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.tab_1
end on

on w_56004_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.tab_1)
end on

event open;call super::open;dw_head.Setitem(1, "shop_div", 'G')
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_1,  "ScaleToRight&Bottom")
inv_resize.of_Register(dw_2,  "ScaleToRight&Bottom")
inv_resize.of_Register(dw_3,  "ScaleToRight&Bottom")

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.25                                                  */	
/* 수정일      : 2002.02.25                                                  */
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
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */
/* 작성일      : 2002.02.25                                                  */
/* 수정일      : 2002.02.25                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_shop_div)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56004_d","0")
end event

event ue_excel();string ls_doc_nm, ls_nm

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
//li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
li_ret = MessageBox("저장형식 선택",  "화면과 같은 양식을 원하시면 Yes! 기초데이터를 원하시면 No! 를 선택해주세요! 파일 오픈시 확인 메시지는 무시하고 열어 주세요! ",  Question!, YesNo!)
	if li_ret = 1 then
//		li_ret = dw_body.SaveAsascii(ls_doc_nm) //, Excel!, TRUE)
			if dw_body.visible = true then
				li_ret = dw_body.SaveAsascii(ls_doc_nm)
			elseif dw_1.visible = true then	
				li_ret = dw_1.SaveAsascii(ls_doc_nm)
			elseif dw_2.visible = true then	
				li_ret = dw_2.SaveAsascii(ls_doc_nm)	
			else	
				li_ret = dw_3.SaveAsascii(ls_doc_nm)
			end if 
		
		
	else 	
			if dw_body.visible = true then
				li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
			elseif dw_1.visible = true then	
				li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
			elseif dw_2.visible = true then	
				li_ret = dw_2.SaveAs(ls_doc_nm, Excel!, TRUE)		
			else	
				li_ret = dw_3.SaveAs(ls_doc_nm, Excel!, TRUE)	
			end if 
	end if	
	


if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if

SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)
Run("C:\Program Files (x86)\Microsoft Office\root\Office16\EXCEL.EXE " + ls_doc_nm, Maximized!)
//	Run("Excel.exe " + ls_doc_nm, Maximized!)


end event

type cb_close from w_com020_d`cb_close within w_56004_d
end type

type cb_delete from w_com020_d`cb_delete within w_56004_d
end type

type cb_insert from w_com020_d`cb_insert within w_56004_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_56004_d
end type

type cb_update from w_com020_d`cb_update within w_56004_d
end type

type cb_print from w_com020_d`cb_print within w_56004_d
boolean visible = false
end type

type cb_preview from w_com020_d`cb_preview within w_56004_d
boolean visible = false
end type

type gb_button from w_com020_d`gb_button within w_56004_d
end type

type cb_excel from w_com020_d`cb_excel within w_56004_d
end type

type dw_head from w_com020_d`dw_head within w_56004_d
integer y = 184
integer height = 176
string dataobject = "d_56004_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child) 
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("season", ldw_child) 
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('003', gs_brand, '%')

This.GetChild("shop_div", ldw_child) 
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('910')
ldw_child.SetFilter("inter_data2 = 'Y'")
ldw_child.Filter()

end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name

	
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
		
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

type ln_1 from w_com020_d`ln_1 within w_56004_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com020_d`ln_2 within w_56004_d
integer beginy = 388
integer endy = 388
end type

type dw_list from w_com020_d`dw_list within w_56004_d
integer x = 9
integer y = 412
integer width = 942
integer height = 1632
string dataobject = "d_56004_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.25                                                  */	
/* 수정일      : 2002.02.25                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_shop_cd = This.GetItemString(row, 'shop_cd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_shop_cd) THEN return
il_rows = dw_body.retrieve(is_brand, is_shop_cd, is_yymmdd)
dw_1.Retrieve(is_brand, is_shop_cd, is_year, is_season, is_yymmdd)

dw_2.SetSort("end_ymd d, start_ymd d, shop_type A, sale_type A")
dw_2.Sort( )
dw_2.Retrieve(is_brand, is_shop_cd, is_year, is_season, is_yymmdd)
dw_3.Retrieve(is_brand, is_shop_cd, is_year, is_season, is_yymmdd)


Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_56004_d
integer x = 987
integer y = 512
integer width = 2601
integer height = 1532
string dataobject = "d_56004_d02"
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

end event

type st_1 from w_com020_d`st_1 within w_56004_d
boolean visible = false
integer x = 864
boolean enabled = false
end type

type dw_print from w_com020_d`dw_print within w_56004_d
end type

type dw_1 from datawindow within w_56004_d
boolean visible = false
integer x = 978
integer y = 504
integer width = 2601
integer height = 1532
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_56004_d03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_child 

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

end event

type dw_2 from datawindow within w_56004_d
boolean visible = false
integer x = 978
integer y = 504
integer width = 2601
integer height = 1532
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_56004_d04"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_child 

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')


end event

event clicked;//dc_rate_t

string newsort
if row > 0 then 
	choose case dwo.name
		case 'dc_rate'
			newsort = "DC_RATE d"
			dw_2.SetSort(newsort)
			dw_2.Sort( )
			
		case 'style'
			newsort = "style a"
			dw_2.SetSort(newsort)
			dw_2.Sort( )
			
		case 'start_ymd'
			newsort = "start_ymd "
			dw_2.SetSort(newsort)
			dw_2.Sort( )		
			
		case 'shop_type'
			newsort = "shop_type "
			dw_2.SetSort(newsort)
			dw_2.Sort( )					

		case 'sale_type'
			newsort = "start_ymd a , start_ymd a "
			dw_2.SetSort(newsort)
			dw_2.Sort( )			
	end choose	
end if

end event

type dw_3 from u_dw within w_56004_d
boolean visible = false
integer x = 978
integer y = 504
integer width = 2601
integer height = 1532
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_56004_d05"
end type

event constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')


end event

type tab_1 from tab within w_56004_d
integer x = 965
integer y = 408
integer width = 2629
integer height = 1640
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

event selectionchanged;CHOOSE CASE newindex 
	CASE 1 
		dw_body.Visible = TRUE
		dw_1.Visible    = FALSE
		dw_2.Visible    = FALSE
		dw_3.Visible    = FALSE		
	CASE 2
		dw_body.Visible = FALSE
		dw_1.Visible    = TRUE
		dw_2.Visible    = FALSE
		dw_3.Visible    = FALSE		
	CASE 3 
		dw_body.Visible = FALSE
		dw_1.Visible    = FALSE
		dw_2.Visible    = TRUE
		dw_3.Visible    = FALSE		
	CASE 4 
		dw_body.Visible = FALSE
		dw_1.Visible    = FALSE
		dw_2.Visible    = FALSE
		dw_3.Visible    = TRUE
END CHOOSE
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2592
integer height = 1528
long backcolor = 79741120
string text = "기준"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2592
integer height = 1528
long backcolor = 79741120
string text = "시즌별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2592
integer height = 1528
long backcolor = 79741120
string text = "품번별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2592
integer height = 1528
long backcolor = 79741120
string text = "품번칼라별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

