$PBExportHeader$w_72019_d.srw
$PBExportComments$판매반품 분석
forward
global type w_72019_d from w_com020_d
end type
end forward

global type w_72019_d from w_com020_d
end type
global w_72019_d w_72019_d

type variables
string is_brand, is_year, is_season, is_fr_yymmdd, is_to_yymmdd, is_gubn
datawindowchild idw_brand, idw_season

end variables

on w_72019_d.create
call super::create
end on

on w_72019_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")
/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)													  */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(st_1, "ScaleToBottom")
inv_resize.of_Register(dw_head, "ScaleToRight")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_gubn = dw_head.GetItemString(1, "gubn")
return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_fr_yymmdd, is_to_yymmdd, is_gubn)
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

event open;call super::open;datetime ld_datetime

dw_body.Object.DataWindow.HorizontalScrollSplit = 735


IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "fr_yymmdd", string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "to_yymmdd", string(ld_datetime,"yyyymmdd"))

end event

type cb_close from w_com020_d`cb_close within w_72019_d
end type

type cb_delete from w_com020_d`cb_delete within w_72019_d
end type

type cb_insert from w_com020_d`cb_insert within w_72019_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_72019_d
end type

type cb_update from w_com020_d`cb_update within w_72019_d
end type

type cb_print from w_com020_d`cb_print within w_72019_d
integer x = 1765
string text = "Excel(위)"
end type

event cb_print::clicked;/*===========================================================================*/
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
li_ret = dw_list.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_preview from w_com020_d`cb_preview within w_72019_d
boolean visible = false
integer x = 1426
end type

type gb_button from w_com020_d`gb_button within w_72019_d
end type

type cb_excel from w_com020_d`cb_excel within w_72019_d
integer width = 357
string text = "Excel(아래)"
end type

type dw_head from w_com020_d`dw_head within w_72019_d
integer y = 160
integer height = 144
string dataobject = "d_72019_h01"
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


end event

event dw_head::itemchanged;call super::itemchanged;string ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name
	CASE "brand"
		
		This.GetChild("sojae", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('%', data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "sojae", "%")
		ldw_child.Setitem(1, "sojae_nm", "전체")
		
		
		
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

type ln_1 from w_com020_d`ln_1 within w_72019_d
integer beginy = 332
integer endy = 332
end type

type ln_2 from w_com020_d`ln_2 within w_72019_d
integer beginy = 336
integer endy = 336
end type

type dw_list from w_com020_d`dw_list within w_72019_d
integer x = 5
integer y = 340
integer width = 3598
integer height = 960
string dataobject = "d_72019_d01"
end type

event dw_list::doubleclicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string is_key_value

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_key_value = This.GetItemString(row, 'gubn') /* DataWindow에 Key 항목을 가져온다 */
//messagebox('is_key-value', is_key_value)
IF IsNull(is_key_value) THEN return
il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_fr_yymmdd, is_to_yymmdd, is_gubn, is_key_value)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_72019_d
integer x = 5
integer y = 1300
integer width = 3598
integer height = 740
string dataobject = "d_72019_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type st_1 from w_com020_d`st_1 within w_72019_d
boolean visible = false
integer y = 380
integer height = 1660
end type

type dw_print from w_com020_d`dw_print within w_72019_d
integer x = 562
integer y = 644
string dataobject = "d_72019_r01"
end type

