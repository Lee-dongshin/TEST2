$PBExportHeader$w_55025_d.srw
$PBExportComments$국내/중국 입판현황
forward
global type w_55025_d from w_com010_d
end type
type dw_1 from datawindow within w_55025_d
end type
end forward

global type w_55025_d from w_com010_d
integer width = 3680
integer height = 2248
dw_1 dw_1
end type
global w_55025_d w_55025_d

type variables
datawindowchild idw_brand, idw_season, idw_sojae, idw_item, idw_dep_fg

string is_brand, is_year, is_season, is_sojae, is_item, is_dep_fg, is_style, is_chno, is_out_yymmdd, is_sal_yymmdd
string is_gubn, is_chno_musi, is_limit

end variables

on w_55025_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_55025_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

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
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year       = dw_head.GetItemString(1, "year")
is_season     = dw_head.GetItemString(1, "season")
is_sojae      = dw_head.GetItemString(1, "sojae")
is_item       = dw_head.GetItemString(1, "item")
is_dep_fg     = dw_head.GetItemString(1, "dep_fg")
is_style      = dw_head.GetItemString(1, "style")
is_out_yymmdd = dw_head.GetItemString(1, "out_yymmdd")
is_sal_yymmdd = dw_head.GetItemString(1, "sal_yymmdd")
is_gubn 		  = dw_head.GetItemString(1, "gubn")
is_chno_musi  = dw_head.GetItemString(1, "chno_musi")
is_limit		  = dw_head.GetItemString(1, "limit")



return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_gubn = "1" then 
	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_style, '%', is_out_yymmdd, is_sal_yymmdd, is_dep_fg, is_chno_musi, is_limit)
else
	il_rows = dw_1.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_style, '%', is_out_yymmdd, is_sal_yymmdd, is_dep_fg, is_chno_musi, is_limit)	
end if


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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_brand.text = is_brand 
dw_print.object.t_year.text = is_year
dw_print.object.t_season.text = is_season 
dw_print.object.t_sojae.text = is_sojae 
dw_print.object.t_item.text = is_item 
dw_print.object.t_style.text = is_style
dw_print.object.t_out_yymmdd.text = is_out_yymmdd 

dw_print.object.t_sal_yymmdd.text = is_sal_yymmdd 

if is_dep_fg = 'Y' then	dw_print.object.t_dep_fg.text = '부진상품'



end event

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"out_yymmdd",string(ld_datetime,"yyyymmdd"))
	dw_head.setitem(1,"sal_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

if is_gubn = '1' then
	dw_body.ShareData(dw_print)
else
	dw_1.ShareData(dw_print)	
end if
dw_print.inv_printpreview.of_SetZoom()

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
if dw_body.visible = true then 
	li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
else
	li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
end if

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_close from w_com010_d`cb_close within w_55025_d
end type

type cb_delete from w_com010_d`cb_delete within w_55025_d
end type

type cb_insert from w_com010_d`cb_insert within w_55025_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55025_d
end type

type cb_update from w_com010_d`cb_update within w_55025_d
end type

type cb_print from w_com010_d`cb_print within w_55025_d
end type

type cb_preview from w_com010_d`cb_preview within w_55025_d
end type

type gb_button from w_com010_d`gb_button within w_55025_d
end type

type cb_excel from w_com010_d`cb_excel within w_55025_d
end type

type dw_head from w_com010_d`dw_head within w_55025_d
integer y = 164
integer width = 4119
integer height = 220
string dataobject = "d_55025_h01"
end type

event dw_head::constructor;call super::constructor;
THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

THIS.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

THIS.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

THIS.GetChild("dep_fg", idw_dep_fg)
idw_dep_fg.SetTransObject(SQLCA)
idw_dep_fg.Retrieve('540')
idw_dep_fg.InsertRow(1)
idw_dep_fg.SetItem(1, "inter_cd", '%')
idw_dep_fg.SetItem(1, "inter_nm", '전체')




end event

event dw_head::itemchanged;call super::itemchanged;
String ls_year, ls_brand
DataWindowChild ldw_child

choose case dwo.name
	case "gubn"
		if data = '1' then
			dw_body.visible = true
			dw_1.visible = false
			dw_print.dataobject = "d_55025_r01"
		elseif data = '2' then
			dw_1.visible = true		
			dw_body.visible = false
			dw_print.dataobject = "d_55025_r02"			
		else
			messagebox("확인", "이상한데요.")
		end if
		dw_print.SetTransObject(SQLCA)
		
		

	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
		
		THIS.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', data)
		idw_sojae.InsertRow(1)
		idw_sojae.SetItem(1, "sojae", '%')
		idw_sojae.SetItem(1, "sojae_nm", '전체')
		
		THIS.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve( data )
		idw_item.InsertRow(1)
		idw_item.SetItem(1, "item", '%')
		idw_item.SetItem(1, "item_nm", '전체')

		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")


		
	CASE "year"
	

		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
						
		
	  
end choose

end event

type ln_1 from w_com010_d`ln_1 within w_55025_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_d`ln_2 within w_55025_d
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_d`dw_body within w_55025_d
integer y = 408
integer height = 1608
string dataobject = "d_55025_d01"
end type

type dw_print from w_com010_d`dw_print within w_55025_d
string dataobject = "d_55025_r02"
end type

type dw_1 from datawindow within w_55025_d
integer x = 5
integer y = 408
integer width = 3589
integer height = 1608
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_55025_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

