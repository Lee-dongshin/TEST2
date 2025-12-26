$PBExportHeader$w_62027_d.srw
$PBExportComments$최근 인기스타일
forward
global type w_62027_d from w_com010_d
end type
end forward

global type w_62027_d from w_com010_d
integer width = 3675
integer height = 2288
end type
global w_62027_d w_62027_d

type variables
string is_brand, is_year, is_season, is_sojae, is_item, is_yymmdd, is_out_seq, is_opt_chno
int ii_top_cnt

datawindowchild idw_brand, idw_season, idw_sojae, idw_item, idw_out_seq

end variables

on w_62027_d.create
call super::create
end on

on w_62027_d.destroy
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

is_year    = dw_head.GetItemString(1, "year")
is_season  = dw_head.GetItemString(1, "season")
is_sojae   = dw_head.GetItemString(1, "sojae")
is_item    = dw_head.GetItemString(1, "item")
ii_top_cnt = dw_head.GetItemdecimal(1, "top_cnt")
is_yymmdd  = dw_head.GetItemString(1, "yymmdd")
is_out_seq = dw_head.GetItemString(1, "out_seq")
is_opt_chno = dw_head.GetItemString(1, "opt_chno")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_style
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_yymmdd, ii_top_cnt, is_out_seq, is_opt_chno)
IF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
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

dw_print.object.t_brand.text = idw_brand.getitemstring(idw_brand.getrow(), "inter_nm")
dw_print.object.t_yearseason.text = is_year + '-' + idw_season.getitemstring(idw_season.getrow(), "inter_nm")
dw_print.object.t_item.text = idw_item.getitemstring(idw_item.getrow(), "item_nm")

dw_print.object.t_sojae.text = idw_sojae.getitemstring(idw_sojae.getrow(), "inter_nm")
dw_print.object.t_yymmdd.text = is_yymmdd
dw_print.object.t_top_cnt.text = string(ii_top_cnt)

dw_print.object.t_out_seq.text = idw_out_seq.getitemstring(idw_out_seq.getrow(), "inter_nm")

if is_opt_chno = 'Y' then dw_print.object.t_opt_chno.text = '차수무시'


end event

type cb_close from w_com010_d`cb_close within w_62027_d
end type

type cb_delete from w_com010_d`cb_delete within w_62027_d
end type

type cb_insert from w_com010_d`cb_insert within w_62027_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_62027_d
end type

type cb_update from w_com010_d`cb_update within w_62027_d
end type

type cb_print from w_com010_d`cb_print within w_62027_d
end type

type cb_preview from w_com010_d`cb_preview within w_62027_d
end type

type gb_button from w_com010_d`gb_button within w_62027_d
end type

type cb_excel from w_com010_d`cb_excel within w_62027_d
end type

type dw_head from w_com010_d`dw_head within w_62027_d
string dataobject = "d_62027_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild	idw_child

this.getchild("brand",idw_brand)
idw_brand.SetTransObject(SQLCA) 
idw_brand.retrieve('001')

this.getchild("season",idw_season)
idw_season.SetTransObject(SQLCA) 
idw_season.retrieve('003', gs_brand, '%')
idw_season.insertrow(1)
idw_season.setitem(1,"inter_cd","%")
idw_season.setitem(1,"inter_nm","전체")

this.getchild("item",idw_item)
idw_item.SetTransObject(SQLCA) 
idw_item.retrieve(gs_brand)
idw_item.insertrow(1)
idw_item.setitem(1,"item","%")
idw_item.setitem(1,"item_nm","전체")


this.getchild("sojae",idw_sojae)
idw_sojae.SetTransObject(SQLCA) 
idw_sojae.retrieve('%', gs_brand)
idw_sojae.insertrow(1)
idw_sojae.setitem(1,"inter_cd","%")
idw_sojae.setitem(1,"inter_nm","전체")


this.getchild("out_seq",idw_out_seq)
idw_out_seq.SetTransObject(SQLCA) 
idw_out_seq.retrieve('010')
idw_out_seq.insertrow(1)
idw_out_seq.setitem(1,"inter_cd","%")
idw_out_seq.setitem(1,"inter_nm","전체")
end event

event dw_head::itemchanged;call super::itemchanged;
string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
		
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

type ln_1 from w_com010_d`ln_1 within w_62027_d
end type

type ln_2 from w_com010_d`ln_2 within w_62027_d
end type

type dw_body from w_com010_d`dw_body within w_62027_d
string dataobject = "d_62027_d01"
end type

event dw_body::constructor;/*===========================================================================*/
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

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

type dw_print from w_com010_d`dw_print within w_62027_d
string dataobject = "d_62027_r01"
end type

