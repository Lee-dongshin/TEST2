$PBExportHeader$w_21097_d.srw
$PBExportComments$라벨/가격택 입력현황
forward
global type w_21097_d from w_com010_d
end type
end forward

global type w_21097_d from w_com010_d
integer width = 3675
integer height = 2252
end type
global w_21097_d w_21097_d

type variables
string is_brand, is_year, is_season, is_item, is_style, is_chno, is_gubn
datawindowchild idw_brand, idw_season, idw_item

end variables

on w_21097_d.create
call super::create
end on

on w_21097_d.destroy
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

is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_item  = dw_head.GetItemString(1, "item")
is_style = dw_head.GetItemString(1, "style")
is_chno  = dw_head.GetItemString(1, "chno")
is_gubn  = dw_head.GetItemString(1, "gubn")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_gubn = '1' and dw_body.dataobject = 'd_21097_d02' then
	dw_body.dataobject  = 'd_21097_d01'
	dw_print.dataobject = 'd_21097_r01'	
	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
elseif is_gubn = '2' and dw_body.dataobject = 'd_21097_d01' then
	dw_body.dataobject  = 'd_21097_d02'
	dw_print.dataobject = 'd_21097_r02'	
	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
end if


il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_item, is_style, is_chno)
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

dw_print.object.t_brand.text = idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_year.text = is_year
dw_print.object.t_season.text = idw_season.getitemstring(idw_season.getrow(),"inter_nm")
dw_print.object.t_item.text = idw_item.getitemstring(idw_item.getrow(),"item_nm")
dw_print.object.t_style.text = is_style


end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();

This.Trigger Event ue_title()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_body.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com010_d`cb_close within w_21097_d
end type

type cb_delete from w_com010_d`cb_delete within w_21097_d
end type

type cb_insert from w_com010_d`cb_insert within w_21097_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_21097_d
end type

type cb_update from w_com010_d`cb_update within w_21097_d
end type

type cb_print from w_com010_d`cb_print within w_21097_d
end type

type cb_preview from w_com010_d`cb_preview within w_21097_d
end type

type gb_button from w_com010_d`gb_button within w_21097_d
end type

type cb_excel from w_com010_d`cb_excel within w_21097_d
end type

type dw_head from w_com010_d`dw_head within w_21097_d
integer y = 164
integer height = 220
string dataobject = "d_21097_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(is_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;//string ls_brand, ls_year, ls_season, ls_item
//if dwo.name = "style" then
//	select top 1 brand, year, season, item 
//		into :ls_brand, :ls_year, :ls_season, :ls_item
//	from tb_12020_m (nolock)
//	where style like :data + '%'
//	order by year desc;
//	
//	this.setitem(1,"brand",ls_brand)
//	this.setitem(1,"year",ls_year)
//	this.setitem(1,"season",ls_season)
//	this.setitem(1,"item",ls_item)	
//	
//end if
//
//



CHOOSE CASE dwo.name


	CASE "brand","year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")
	
			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_year)
			idw_item.insertrow(1)
			idw_item.Setitem(1, "item", "%")
			idw_item.Setitem(1, "item_nm", "전체")
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_21097_d
integer beginy = 396
integer endy = 396
end type

type ln_2 from w_com010_d`ln_2 within w_21097_d
integer beginy = 400
integer endy = 400
end type

type dw_body from w_com010_d`dw_body within w_21097_d
integer y = 416
integer height = 1600
string dataobject = "d_21097_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_21097_d
integer x = 165
integer y = 656
string dataobject = "d_21097_r01"
end type

