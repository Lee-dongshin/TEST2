$PBExportHeader$w_56021_d.srw
$PBExportComments$품번별 할인 현황표
forward
global type w_56021_d from w_com010_d
end type
end forward

global type w_56021_d from w_com010_d
integer width = 3680
integer height = 2272
end type
global w_56021_d w_56021_d

type variables
String is_brand, is_year, is_season, is_sale_type1, is_sale_type2, is_sale_type3
DataWindowChild idw_brand, idw_year, idw_season
end variables

on w_56021_d.create
call super::create
end on

on w_56021_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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



is_year = dw_head.GetItemString(1, "year")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_sale_type1 = dw_head.GetItemString(1, "sale_type1")
is_sale_type2 = dw_head.GetItemString(1, "sale_type2")
is_sale_type3 = dw_head.GetItemString(1, "sale_type3")
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_year, is_season, is_brand, is_sale_type1, is_sale_type2, is_sale_type3)
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56021_d","0")
end event

event ue_preview();This.Trigger Event ue_title ()

dw_print.retrieve(is_year, is_season, is_brand, is_sale_type1, is_sale_type2, is_sale_type3)
dw_print.inv_printpreview.of_SetZoom()
end event

event ue_print();

This.Trigger Event ue_title()

dw_print.retrieve(is_year, is_season, is_brand, is_sale_type1, is_sale_type2, is_sale_type3)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =		"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_year.Text = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "'" + &
					"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" 

dw_print.Modify(ls_modify)

end event

type cb_close from w_com010_d`cb_close within w_56021_d
end type

type cb_delete from w_com010_d`cb_delete within w_56021_d
end type

type cb_insert from w_com010_d`cb_insert within w_56021_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56021_d
end type

type cb_update from w_com010_d`cb_update within w_56021_d
end type

type cb_print from w_com010_d`cb_print within w_56021_d
end type

type cb_preview from w_com010_d`cb_preview within w_56021_d
end type

type gb_button from w_com010_d`gb_button within w_56021_d
end type

type cb_excel from w_com010_d`cb_excel within w_56021_d
end type

type dw_head from w_com010_d`dw_head within w_56021_d
integer height = 144
string dataobject = "d_56021_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')


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

type ln_1 from w_com010_d`ln_1 within w_56021_d
integer beginy = 316
integer endy = 316
end type

type ln_2 from w_com010_d`ln_2 within w_56021_d
integer beginy = 320
integer endy = 320
end type

type dw_body from w_com010_d`dw_body within w_56021_d
integer y = 340
integer height = 1680
string dataobject = "d_56021_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_56021_d
string dataobject = "d_56021_r02"
end type

