$PBExportHeader$w_56215_d.srw
$PBExportComments$영업보고
forward
global type w_56215_d from w_com010_d
end type
type dw_body2 from datawindow within w_56215_d
end type
type dw_body3 from datawindow within w_56215_d
end type
type tab_1 from tab within w_56215_d
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
type tab_1 from tab within w_56215_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_56215_d from w_com010_d
integer width = 3685
integer height = 2264
dw_body2 dw_body2
dw_body3 dw_body3
tab_1 tab_1
end type
global w_56215_d w_56215_d

type variables
DataWindowChild idw_brand
String is_brand, is_yymm

end variables

on w_56215_d.create
int iCurrent
call super::create
this.dw_body2=create dw_body2
this.dw_body3=create dw_body3
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_body2
this.Control[iCurrent+2]=this.dw_body3
this.Control[iCurrent+3]=this.tab_1
end on

on w_56215_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_body2)
destroy(this.dw_body3)
destroy(this.tab_1)
end on

event open;call super::open;DateTime ld_datetime
string ls_yymm

/* 시스템 날짜를 가져온다 */
ls_yymm =  string(gf_sysdate(ld_datetime), "YYYYMM")

dw_body.Setitem(1, "yymm", ls_yymm)
   

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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


is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymm)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

il_rows = dw_body2.retrieve(is_brand, MidA(is_yymm,1,4))
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

il_rows = dw_body3.retrieve(is_brand, is_yymm)
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

event pfc_preopen();call super::pfc_preopen;

/* DataWindow의 Transction 정의 */
dw_body2.SetTransObject(SQLCA)
dw_body3.SetTransObject(SQLCA)


inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_body2, "ScaleToright&Bottom")
inv_resize.of_Register(dw_body3, "ScaleToright&Bottom")

end event

event ue_preview();This.Trigger Event ue_title ()

dw_print.retrieve(is_brand, is_yymm)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();This.Trigger Event ue_title()

dw_print.retrieve(is_brand, is_yymm)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56215_d","0")
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

if	dw_body.visible  = true then
	li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
elseif dw_body2.visible = true then
	li_ret = dw_body2.SaveAs(ls_doc_nm, Excel!, TRUE)
else	
	li_ret = dw_body3.SaveAs(ls_doc_nm, Excel!, TRUE)
end if

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_close from w_com010_d`cb_close within w_56215_d
end type

type cb_delete from w_com010_d`cb_delete within w_56215_d
end type

type cb_insert from w_com010_d`cb_insert within w_56215_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56215_d
end type

type cb_update from w_com010_d`cb_update within w_56215_d
end type

type cb_print from w_com010_d`cb_print within w_56215_d
end type

type cb_preview from w_com010_d`cb_preview within w_56215_d
end type

type gb_button from w_com010_d`gb_button within w_56215_d
end type

type cb_excel from w_com010_d`cb_excel within w_56215_d
end type

type dw_head from w_com010_d`dw_head within w_56215_d
integer y = 164
integer width = 3360
integer height = 132
string dataobject = "d_56215_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_d`ln_1 within w_56215_d
integer beginy = 316
integer endy = 316
end type

type ln_2 from w_com010_d`ln_2 within w_56215_d
integer beginy = 320
integer endy = 320
end type

type dw_body from w_com010_d`dw_body within w_56215_d
integer y = 424
integer height = 1592
string dataobject = "d_56215_d02"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_56215_d
string dataobject = "d_56215_d01"
end type

type dw_body2 from datawindow within w_56215_d
boolean visible = false
integer x = 5
integer y = 424
integer width = 3589
integer height = 1592
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_56215_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_body3 from datawindow within w_56215_d
boolean visible = false
integer x = 5
integer y = 424
integer width = 3589
integer height = 1592
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_56215_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tab_1 from tab within w_56215_d
integer x = 5
integer y = 324
integer width = 3602
integer height = 1704
integer taborder = 40
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
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

event clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/

//IF dw_head.Enabled = TRUE THEN Return 1

  	CHOOSE CASE index
		CASE 1
			dw_body.visible  = true
			dw_body2.visible = false
			dw_body3.visible = false

		CASE 2
			dw_body.visible  = false
			dw_body2.visible = true
			dw_body3.visible = false

      CASE 3
			dw_body.visible  = false
			dw_body2.visible = false
			dw_body3.visible = true
		
END CHOOSE

	
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 1592
long backcolor = 79741120
string text = "브랜드별합계"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 1592
long backcolor = 79741120
string text = "월별판매(사입업체관련)"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 1592
long backcolor = 79741120
string text = "매장별월매출"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

