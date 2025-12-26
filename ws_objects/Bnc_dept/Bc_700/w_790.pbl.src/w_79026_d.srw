$PBExportHeader$w_79026_d.srw
$PBExportComments$수선실처리별 내역
forward
global type w_79026_d from w_com010_d
end type
end forward

global type w_79026_d from w_com010_d
end type
global w_79026_d w_79026_d

type variables
DataWindowChild	idw_brand, idw_year, idw_season, idw_sojae, idw_item
String is_brand, is_frm_ymd, is_to_ymd, is_year, is_season 
String is_sojae, is_item, is_judg_fg1, is_judg_fg2, is_opt_view, is_judg
end variables

on w_79026_d.create
call super::create
end on

on w_79026_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

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

is_frm_ymd = dw_head.GetItemString(1, "frm_ymd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"품종을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

//is_judg_fg1 = Trim(dw_head.GetItemString(1, "judg_fg1"))
//is_judg_fg2 = Trim(dw_head.GetItemString(1, "judg_fg2"))
//if is_judg_fg1 = '2' and is_judg_fg2 = '1' then
//   MessageBox(ls_title,"판정 구분을 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("judg_fg1")
//   return false
//end if


is_opt_view = dw_head.GetItemString(1, "opt_view")
if IsNull(is_opt_view) or Trim(is_opt_view) = "" then
   MessageBox(ls_title,"죄회구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_view")
   return false
end if

is_judg = dw_head.GetItemString(1, "judg")
if IsNull(is_judg) or Trim(is_judg) = "" then
   MessageBox(ls_title,"복종 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("judg")
   return false
end if


return true

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_79014_d","0")
end event

event open;call super::open;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = string(ld_datetime, "YYYYMMDD")


dw_head.setitem(1, "frm_ymd", MidA(ls_datetime,1,6)+'01')
dw_head.setitem(1, "to_ymd", ls_datetime)
dw_head.setitem(1, 'year', '%')
dw_head.setitem(1, 'season', '%')
dw_head.setitem(1, 'judg', '%')
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_79013_d01 'n','20040501','20040521','2003','w','w','j','1','2'

if is_opt_view = "A" then
	dw_body.dataobject = "d_79026_d06"
	dw_print.dataobject = "d_79026_r06"	
	dw_body.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)
	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_frm_ymd, is_to_ymd)
	dw_print.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_frm_ymd, is_to_ymd)	
else	
	dw_body.dataobject = "d_79026_d07"	
	dw_print.dataobject = "d_79026_r07"		
 	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)	
	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_frm_ymd, is_to_ymd, is_judg)
	dw_print.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_frm_ymd, is_to_ymd, is_judg)
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

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime, ls_judg_fg

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
//
//If is_judg_fg1 = '1' Then
//	ls_judg_fg = ' 수선'
//End If
//If is_judg_fg2 = '2' Then
//	ls_judg_fg = ls_judg_fg + ' CLAIM'
//End If


ls_modify =	"t_pg_id.Text    = '" + is_pgm_id + "'" + &
            "t_user_id.Text  = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
      		"t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_frm_ymd.Text  = '" + is_frm_ymd + "'" + &
				"t_to_ymd.Text   = '" + is_to_ymd + "'" + &				
				"t_year.Text     = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_nm") + "'" + &
				"t_season.Text   = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_nm") + "'" + &
				"t_sojae.Text    = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_nm") + "'" + &
				"t_item.Text     = '" + idw_item.GetItemString(idw_item.GetRow(), "item_nm") + "'" 


dw_print.Modify(ls_modify)
end event

type cb_close from w_com010_d`cb_close within w_79026_d
end type

type cb_delete from w_com010_d`cb_delete within w_79026_d
end type

type cb_insert from w_com010_d`cb_insert within w_79026_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_79026_d
end type

type cb_update from w_com010_d`cb_update within w_79026_d
end type

type cb_print from w_com010_d`cb_print within w_79026_d
end type

type cb_preview from w_com010_d`cb_preview within w_79026_d
end type

type gb_button from w_com010_d`gb_button within w_79026_d
end type

type cb_excel from w_com010_d`cb_excel within w_79026_d
end type

type dw_head from w_com010_d`dw_head within w_79026_d
integer y = 168
integer height = 192
string dataobject = "d_79026_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_cd1", '%')
idw_brand.SetItem(1, "inter_nm", '전체')

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')


This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')


This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

dw_head.setitem(1, 'judg', '%')





end event

event dw_head::itemchanged;call super::itemchanged;
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

type ln_1 from w_com010_d`ln_1 within w_79026_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_d`ln_2 within w_79026_d
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_d`dw_body within w_79026_d
integer x = 9
integer y = 400
integer width = 3598
integer height = 1620
string dataobject = "d_79026_d06"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_79026_d
string dataobject = "d_79026_r06"
end type

