$PBExportHeader$w_75010_d.srw
$PBExportComments$기간별 회원매출현황
forward
global type w_75010_d from w_com010_d
end type
type dw_1 from datawindow within w_75010_d
end type
end forward

global type w_75010_d from w_com010_d
dw_1 dw_1
end type
global w_75010_d w_75010_d

type variables
string is_fr_yymmdd, is_to_yymmdd, is_year, is_season, is_shop_cd

datawindowchild idw_season

end variables

on w_75010_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_75010_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event open;call super::open;datetime ld_datetime


IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
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

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")

is_year   = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")

//if IsNull(is_brand) or Trim(is_brand) = "" then
//   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_yymmdd, is_to_yymmdd, is_year, is_season, is_shop_cd)
IF il_rows > 0 THEN
	il_rows = dw_1.retrieve(is_fr_yymmdd, is_to_yymmdd, is_year, is_season, is_shop_cd)
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();/*===========================================================================*/
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
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_75010_d","0")
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

//dw_body.ShareData(dw_print)
il_rows = dw_print.retrieve(is_fr_yymmdd, is_to_yymmdd, is_year, is_season, is_shop_cd)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF
ls_shop_nm = dw_head.getitemstring(1,"shop_nm")
ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

//ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
//             "t_user_id.Text = '" + gs_user_id + "'" + &
//             "t_datetime.Text = '" + ls_datetime + "'"
//
//dw_print.Modify(ls_modify)
//

dw_print.object.t_fr_yymmdd.text = is_fr_yymmdd
dw_print.object.t_to_yymmdd.text = is_to_yymmdd
dw_print.object.t_year.text      = is_year
dw_print.object.t_season.text    = is_season
dw_print.object.t_shop_cd.text   = is_shop_cd + ' ' + ls_shop_nm
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
li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_close from w_com010_d`cb_close within w_75010_d
end type

type cb_delete from w_com010_d`cb_delete within w_75010_d
end type

type cb_insert from w_com010_d`cb_insert within w_75010_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_75010_d
end type

type cb_update from w_com010_d`cb_update within w_75010_d
end type

type cb_print from w_com010_d`cb_print within w_75010_d
end type

type cb_preview from w_com010_d`cb_preview within w_75010_d
end type

type gb_button from w_com010_d`gb_button within w_75010_d
end type

type cb_excel from w_com010_d`cb_excel within w_75010_d
end type

type dw_head from w_com010_d`dw_head within w_75010_d
integer height = 148
string dataobject = "d_75010_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;string ls_shop_cd
string ls_year, ls_brand
DataWindowChild ldw_child

choose case dwo.name
	case "shop_cd"
		select dbo.sf_shop_nm(:data,'s') 
			into :ls_shop_cd
			from dual;
			
		this.setitem(1,'shop_nm',ls_shop_cd)
		
		
CASE "brand"

		
//		This.GetChild("sojae", ldw_child)
//		ldw_child.SetTransObject(SQLCA)
//		ldw_child.Retrieve('%', data)
//		ldw_child.insertrow(1)
//		ldw_child.Setitem(1, "sojae", "%")
//		ldw_child.Setitem(1, "sojae_nm", "전체")
//		
//	
//		This.GetChild("item", ldw_child)
//		ldw_child.SetTransObject(SQLCA)
//		ldw_child.Retrieve(data)
//		ldw_child.insertrow(1)
//		ldw_child.Setitem(1, "item", "%")
//		ldw_child.Setitem(1, "item_nm", "전체")		
//				
//		
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
end choose

		
		
end event

type ln_1 from w_com010_d`ln_1 within w_75010_d
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_d`ln_2 within w_75010_d
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_d`dw_body within w_75010_d
integer y = 340
integer height = 992
string dataobject = "d_75010_d01"
end type

type dw_print from w_com010_d`dw_print within w_75010_d
string dataobject = "d_75010_r00"
end type

type dw_1 from datawindow within w_75010_d
integer x = 5
integer y = 1344
integer width = 3589
integer height = 704
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_75010_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

