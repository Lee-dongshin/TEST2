$PBExportHeader$w_79018_d.srw
$PBExportComments$시험성적별 접수현황
forward
global type w_79018_d from w_com010_d
end type
end forward

global type w_79018_d from w_com010_d
end type
global w_79018_d w_79018_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_result, idw_judg_fg, idw_color,  idw_judg_s, idw_judg_l
String is_brand, is_year, is_season, is_frm_ymd, is_to_ymd, is_result, is_judg_fg, is_judg_l, is_judg_s
end variables

on w_79018_d.create
call super::create
end on

on w_79018_d.destroy
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

is_frm_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
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

is_result = dw_head.GetItemString(1, "result")
if IsNull(is_result) or Trim(is_result) = "" then
   MessageBox(ls_title,"종합판정내용을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("result")
   return false
end if

is_judg_fg = dw_head.GetItemString(1, "judg_fg")
if IsNull(is_judg_fg) or Trim(is_judg_fg) = "" then
   MessageBox(ls_title,"판정구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("judg_fg")
   return false
end if

is_judg_l = dw_head.GetItemString(1, "judg_l")
if IsNull(is_judg_l) or Trim(is_judg_l) = "" then
//   MessageBox(ls_title,"판정대분류를 입력하십시요!")
	is_judg_l = '%'
   dw_head.SetFocus()
   dw_head.SetColumn("judg_l")
//   return false
end if

is_judg_s = dw_head.GetItemString(1, "judg_s")
if IsNull(is_judg_s) or Trim(is_judg_s) = "" then
//   MessageBox(ls_title,"판정소분류를 입력하십시요!")
	is_judg_s = '%'
   dw_head.SetFocus()
   dw_head.SetColumn("judg_s")
//   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_result, is_brand ,is_frm_ymd , is_to_ymd, is_judg_fg, is_year, is_season, is_judg_l, is_judg_s )
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
string ls_modify, ls_datetime,ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify  = "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
				 "t_fr_ymd.Text = '" + String(is_frm_ymd, '@@@@/@@/@@') + "'" + &
 				 "t_to_ymd.Text = '" + String(is_to_ymd, '@@@@/@@/@@') + "'" + &
				 "t_judg_fg.Text = '" + idw_judg_fg.GetItemString(idw_judg_fg.GetRow(), "inter_display") + "'" + &
				 "t_judg_l.Text = '" + idw_judg_l.GetItemString(idw_judg_l.GetRow(), "inter_display") + "'" + &
 				 "t_judg_s.Text = '" + idw_judg_s.GetItemString(idw_judg_s.GetRow(), "inter_display") + "'" 
dw_print.Modify(ls_modify)



end event

type cb_close from w_com010_d`cb_close within w_79018_d
end type

type cb_delete from w_com010_d`cb_delete within w_79018_d
end type

type cb_insert from w_com010_d`cb_insert within w_79018_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_79018_d
end type

type cb_update from w_com010_d`cb_update within w_79018_d
end type

type cb_print from w_com010_d`cb_print within w_79018_d
end type

type cb_preview from w_com010_d`cb_preview within w_79018_d
end type

type gb_button from w_com010_d`gb_button within w_79018_d
end type

type cb_excel from w_com010_d`cb_excel within w_79018_d
end type

type dw_head from w_com010_d`dw_head within w_79018_d
integer x = 23
integer y = 160
integer width = 3570
integer height = 212
string dataobject = "D_79018_H01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTRansObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

This.GetChild("year", idw_year)
idw_year.SetTRansObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.Setitem(1, "inter_cd", "%")
idw_year.Setitem(1, "inter_cd1", "%")
idw_year.Setitem(1, "inter_nm", "전체")

This.GetChild("result", idw_result)
idw_result.SetTRansObject(SQLCA)
idw_result.Retrieve('800')


This.GetChild("judg_fg", idw_judg_fg)
idw_judg_fg.SetTRansObject(SQLCA)
idw_judg_fg.Retrieve('799')
idw_judg_fg.InsertRow(1)
idw_judg_fg.Setitem(1, "inter_cd", "%")
idw_judg_fg.Setitem(1, "inter_nm", "전체")

This.GetChild("judg_l", idw_judg_l)
idw_judg_l.SetTransObject(SQLCA)
idw_judg_l.Retrieve('795')
idw_judg_l.InsertRow(1)
idw_judg_l.SetItem(1, "inter_cd", '%')
idw_judg_l.SetItem(1, "inter_nm", '전체')

This.GetChild("judg_s", idw_judg_s)
idw_judg_s.SetTransObject(SQLCA)
idw_judg_s.Retrieve('796','%')
idw_judg_s.InsertRow(1)
idw_judg_s.SetItem(1, "inter_cd", '%')
idw_judg_s.SetItem(1, "inter_nm", '전체')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;String ls_judg_l

CHOOSE CASE dwo.name
	CASE "judg_s"
		ls_judg_l = This.GetItemString(row, "judg_l")
		idw_judg_s.Retrieve('796', ls_judg_l)
		idw_judg_s.InsertRow(1)
		idw_judg_s.SetItem(1, "inter_cd", '')
		idw_judg_s.SetItem(1, "inter_nm", '')		
END CHOOSE

end event

event dw_head::itemchanged;call super::itemchanged;string ls_year, ls_brand
DataWindowChild ldw_child



CHOOSE CASE dwo.name
	CASE "brand"
				
		
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

type ln_1 from w_com010_d`ln_1 within w_79018_d
integer beginy = 372
integer endy = 372
end type

type ln_2 from w_com010_d`ln_2 within w_79018_d
integer beginy = 376
integer endy = 376
end type

type dw_body from w_com010_d`dw_body within w_79018_d
integer y = 384
integer width = 3593
integer height = 1628
string dataobject = "D_79018_D01"
end type

event dw_body::constructor;call super::constructor;This.GetChild("color", idw_color)
idw_color.SetTRansObject(SQLCA)
idw_color.Retrieve('%')
end event

type dw_print from w_com010_d`dw_print within w_79018_d
string dataobject = "D_79018_r01"
end type

