$PBExportHeader$w_62022_d.srw
$PBExportComments$미사용 - 인기투표대비 판매현황
forward
global type w_62022_d from w_com020_d
end type
end forward

global type w_62022_d from w_com020_d
integer width = 3685
integer height = 2284
end type
global w_62022_d w_62022_d

type variables
string is_brand, is_year, is_season, is_item, is_shop_cd, is_style, is_area_cd, is_gubn, is_fr_yymmdd, is_to_yymmdd
datawindowchild idw_brand, idw_season, idw_item, idw_area_cd
end variables

on w_62022_d.create
call super::create
end on

on w_62022_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

is_brand  = dw_head.GetItemString(1, "brand")
is_year   = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_item   = dw_head.GetItemString(1, "item")
is_style   = dw_head.GetItemString(1, "style")
is_area_cd  = dw_head.GetItemString(1, "area_cd")
is_gubn   = dw_head.GetItemString(1, "gubn")
is_fr_yymmdd   = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd   = dw_head.GetItemString(1, "to_yymmdd")



return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


if is_gubn = '1' and dw_list.dataobject <> 'd_62022_L02' then 
	dw_list.dataobject = 'd_62022_L02'
	dw_body.dataobject = 'd_62022_d02'
	dw_print.dataobject = 'd_62022_r02'
	dw_list.SetTransObject(SQLCA)
	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
	
elseif is_gubn = '0' and dw_list.dataobject <> 'd_62022_L01' then
	dw_list.dataobject = 'd_62022_L01'
	dw_body.dataobject = 'd_62022_d01'			
	dw_print.dataobject = 'd_62022_r01'
	dw_list.SetTransObject(SQLCA)
	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
end if




il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_item, is_style, is_area_cd, is_fr_yymmdd, is_to_yymmdd )
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_62022_d","0")
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")



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

dw_print.object.t_yymmdd.text = '출고일자: ' + is_fr_yymmdd + ' - ' + is_to_yymmdd
dw_print.object.t_brand.text = '브랜드: ' + is_brand +' ' + idw_brand.getitemstring(idw_brand.getrow(),'inter_nm')
dw_print.object.t_season.text = '시즌: ' + is_year +is_season +' ' + idw_season.getitemstring(idw_season.getrow(),'inter_nm')



end event

event open;call super::open;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyymmdd")
dw_head.setitem(1,'fr_yymmdd', ls_datetime)
dw_head.setitem(1,'to_yymmdd', ls_datetime)
end event

type cb_close from w_com020_d`cb_close within w_62022_d
end type

type cb_delete from w_com020_d`cb_delete within w_62022_d
end type

type cb_insert from w_com020_d`cb_insert within w_62022_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_62022_d
end type

type cb_update from w_com020_d`cb_update within w_62022_d
end type

type cb_print from w_com020_d`cb_print within w_62022_d
end type

type cb_preview from w_com020_d`cb_preview within w_62022_d
end type

type gb_button from w_com020_d`gb_button within w_62022_d
end type

type cb_excel from w_com020_d`cb_excel within w_62022_d
end type

type dw_head from w_com020_d`dw_head within w_62022_d
string dataobject = "d_62022_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003',gs_brand, '%')

This.GetChild("item", idw_item)
idw_item.SetTRansObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.insertrow(1)
idw_item.Setitem(1, "item", "%")
idw_item.Setitem(1, "item_nm", "전체")


This.GetChild("area_cd", idw_area_cd )
idw_area_cd.SetTransObject(SQLCA)
idw_area_cd.Retrieve('090')
idw_area_cd.insertrow(1)
idw_area_cd.Setitem(1, "inter_cd", "%")
idw_area_cd.Setitem(1, "inter_nm", "전체")



end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "brand"

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
		 				
END CHOOSE



end event

type ln_1 from w_com020_d`ln_1 within w_62022_d
integer beginy = 420
integer endy = 420
end type

type ln_2 from w_com020_d`ln_2 within w_62022_d
integer beginy = 424
integer endy = 424
end type

type dw_list from w_com020_d`dw_list within w_62022_d
integer x = 14
integer y = 440
integer width = 987
integer height = 1592
string dataobject = "d_62022_L01"
end type

event dw_list::doubleclicked;call super::doubleclicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_style
IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_shop_cd = This.GetItemString(row, 'shop_cd') /* DataWindow에 Key 항목을 가져온다 */
ls_style = This.GetItemString(row, 'style') /* DataWindow에 Key 항목을 가져온다 */


if is_gubn  = '0' then 
	IF IsNull(is_shop_cd) THEN return
	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_item, is_shop_cd, is_fr_yymmdd, is_to_yymmdd)
else
	IF IsNull(ls_style) THEN return
	il_rows = dw_body.retrieve(ls_style)	
end if

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
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
This.inv_sort.of_SetColumnHeader(false)

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

type dw_body from w_com020_d`dw_body within w_62022_d
integer x = 1029
integer y = 440
integer width = 2565
integer height = 1596
string dataobject = "d_62022_d01"
boolean hscrollbar = true
end type

event dw_body::clicked;call super::clicked;string ls_style
choose case dwo.name
	case "style"		
		ls_style = this.getitemstring(row, "style")
		gf_style_pic(ls_style,'%')
end choose




end event

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(true)

//This.SetRowFocusIndicator(Hand!)

end event

type st_1 from w_com020_d`st_1 within w_62022_d
integer x = 1010
integer y = 436
integer height = 1600
end type

type dw_print from w_com020_d`dw_print within w_62022_d
string dataobject = "d_62022_r01"
end type

