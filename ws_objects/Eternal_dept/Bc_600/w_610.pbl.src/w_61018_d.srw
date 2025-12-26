$PBExportHeader$w_61018_d.srw
$PBExportComments$요일별입출판현황
forward
global type w_61018_d from w_com020_d
end type
type opt_0 from radiobutton within w_61018_d
end type
type opt_1 from radiobutton within w_61018_d
end type
end forward

global type w_61018_d from w_com020_d
integer width = 3694
integer height = 2280
opt_0 opt_0
opt_1 opt_1
end type
global w_61018_d w_61018_d

type variables
datawindowchild	idw_brand, idw_season, idw_sojae, idw_item

string is_fr_yymmdd, is_to_yymmdd, is_brand, is_year, is_season, is_item, is_sojae
long	il_opt
integer ii_wk_day
end variables

on w_61018_d.create
int iCurrent
call super::create
this.opt_0=create opt_0
this.opt_1=create opt_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.opt_0
this.Control[iCurrent+2]=this.opt_1
end on

on w_61018_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.opt_0)
destroy(this.opt_1)
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

is_fr_yymmdd   = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd   = dw_head.GetItemString(1, "to_yymmdd")
is_year   = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_sojae  = dw_head.GetItemString(1, "sojae")
is_item   = dw_head.GetItemString(1, "item")
il_opt	 = dw_head.GetItemNumber(1, "opt")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_fr_yymmdd, is_to_yymmdd, is_brand, is_year, is_season, is_sojae, is_item, il_opt)
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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_div

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


if isnull(ls_shop_div) then ls_shop_div = "전체"

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_brand.text  = is_brand  + ' ' + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")

dw_print.object.t_yearsn.text   = is_year + is_season
dw_print.object.t_sojae.text  = is_sojae  + ' ' + idw_sojae.getitemstring(idw_sojae.getrow(),"inter_nm")
dw_print.object.t_item.text   = is_item   + ' ' + idw_item.getitemstring(idw_item.getrow(),"inter_nm")

//if il_opt = 0 then
//	dw_print.object.t_opt.text   = "출고대비 판매율"
//else
//	dw_print.object.t_opt.text   = "입고대비 판매율"				 
//end if
dw_print.object.t_fr_yymmdd.text   = is_fr_yymmdd
dw_print.object.t_to_yymmdd.text   = is_to_yymmdd


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61018_d","0")
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
/* 작성자      : (주)지우정보 (김태범)													  */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(st_1, "ScaleToBottom")

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

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true

      else
         dw_head.SetFocus()

      end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if
END CHOOSE

end event

event open;call super::open;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))

end if

IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))

end if
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation	 = 1
dw_list.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

type cb_close from w_com020_d`cb_close within w_61018_d
integer taborder = 120
end type

type cb_delete from w_com020_d`cb_delete within w_61018_d
integer taborder = 70
end type

type cb_insert from w_com020_d`cb_insert within w_61018_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_61018_d
end type

type cb_update from w_com020_d`cb_update within w_61018_d
integer taborder = 110
end type

type cb_print from w_com020_d`cb_print within w_61018_d
boolean visible = false
integer taborder = 80
end type

type cb_preview from w_com020_d`cb_preview within w_61018_d
integer taborder = 90
boolean enabled = true
end type

type gb_button from w_com020_d`gb_button within w_61018_d
end type

type cb_excel from w_com020_d`cb_excel within w_61018_d
integer taborder = 100
end type

type dw_head from w_com020_d`dw_head within w_61018_d
integer y = 160
integer width = 3945
integer height = 188
string dataobject = "d_61018_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.insertrow(1)
idw_season.setitem(1,"inter_cd","%")
idw_season.setitem(1,"inter_nm","전체")

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.insertrow(1)
idw_sojae.setitem(1,"inter_cd","%")
idw_sojae.setitem(1,"inter_nm","전체")


This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.insertrow(1)
idw_item.setitem(1,"item","%")
idw_item.setitem(1,"item_nm","전체")
end event

event dw_head::itemchanged;call super::itemchanged;
string ls_year, ls_brand
DataWindowChild ldw_child



choose case dwo.name
	

	CASE "brand"
		IF ib_itemchanged THEN RETURN 1

	
		This.GetChild("sojae", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('%', data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "sojae", "%")
		ldw_child.Setitem(1, "sojae_nm", "전체")
		
		This.GetChild("item", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve(data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "item", "%")
		ldw_child.Setitem(1, "item_nm", "전체")		
			
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

type ln_1 from w_com020_d`ln_1 within w_61018_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com020_d`ln_2 within w_61018_d
integer beginy = 356
integer endy = 356
end type

type dw_list from w_com020_d`dw_list within w_61018_d
integer x = 5
integer y = 364
integer width = 3607
integer height = 1684
string dataobject = "d_61018_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_list::doubleclicked;call super::doubleclicked;///*===========================================================================*/
///* 작성자      :                                                       */	
///* 작성일      : 2001..                                                  */	
///* 수정일      : 2001..                                                  */
///*===========================================================================*/
//
//IF row <= 0 THEN Return
//
//This.SelectRow(0, FALSE)
//This.SelectRow(row, TRUE)
//
//ii_wk_day = this.getitemnumber(row, 'wk_day')
//is_sojae  = This.GetItemString(row, 'sojae') /* DataWindow에 Key 항목을 가져온다 */
//is_item   = This.GetItemString(row, 'item') /* DataWindow에 Key 항목을 가져온다 */
//
//
//
//IF IsNull(ii_wk_day) THEN return
//il_rows = dw_body.retrieve(is_fr_yymmdd, is_to_yymmdd, ii_wk_day, is_brand, is_year, is_season, is_sojae, is_item, il_opt)
//
//Parent.Trigger Event ue_button(7, il_rows)
//Parent.Trigger Event ue_msg(1, il_rows)
//
//
end event

event dw_list::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

//FOR i=1 TO li_column_count
//	ls_column_name = This.Describe('#' + String(i) + '.Name')
//	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
//		ls_modify   = ls_modify + ls_column_name + &
//		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
//	END IF
//NEXT

This.Modify(ls_modify)

//this.Object.DataWindow.HorizontalScrollSplit  = 730

end event

type dw_body from w_com020_d`dw_body within w_61018_d
boolean visible = false
integer x = 402
integer y = 2260
integer width = 3214
integer height = 604
boolean titlebar = true
boolean controlmenu = true
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;//this.Object.DataWindow.HorizontalScrollSplit  = 460
end event

event dw_body::clicked;call super::clicked;String 	ls_search
if dwo.name = "style" then
	ls_search 	= this.GetItemString(row,'style')
	if LenA(ls_search) >= 8 then gf_style_pic(ls_search,'%')
end if
end event

type st_1 from w_com020_d`st_1 within w_61018_d
boolean visible = false
integer x = 2418
end type

type dw_print from w_com020_d`dw_print within w_61018_d
integer x = 37
integer y = 1060
string dataobject = "d_61018_r01"
end type

type opt_0 from radiobutton within w_61018_d
integer x = 1824
integer y = 264
integer width = 315
integer height = 60
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "출고대비"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
if this.checked then
	il_opt = 0
	for i = 1 to dw_list.rowcount()
		dw_list.setitem(i,"opt",0)
	next
	
	for i = 1 to dw_body.rowcount()
		dw_body.setitem(i,"opt",0)
	next	
end if		



end event

type opt_1 from radiobutton within w_61018_d
integer x = 2144
integer y = 264
integer width = 315
integer height = 60
integer taborder = 140
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "판매대비"
borderstyle borderstyle = stylelowered!
end type

event clicked;long i
if this.checked then
	il_opt = 1
	
	for i = 1 to dw_list.rowcount()
		dw_list.setitem(i,"opt",1)
	next
	
	for i = 1 to dw_body.rowcount()
		dw_body.setitem(i,"opt",1)
	next
end if
end event

