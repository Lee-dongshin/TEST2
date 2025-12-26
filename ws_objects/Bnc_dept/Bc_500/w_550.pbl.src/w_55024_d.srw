$PBExportHeader$w_55024_d.srw
$PBExportComments$년도,시즌,브랜드 판매비교조회
forward
global type w_55024_d from w_com010_d
end type
end forward

global type w_55024_d from w_com010_d
integer width = 3694
integer height = 2280
end type
global w_55024_d w_55024_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_year1, idw_season1
string is_brand, is_yymmdd, is_year, is_season, is_dep_fg, is_chi_gubn, is_year1, is_season1
end variables

on w_55024_d.create
call super::create
end on

on w_55024_d.destroy
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


//if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
//   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false	
//elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false		
//elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false			
//end if	





if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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



is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
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
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_year1 = dw_head.GetItemString(1, "year1")
if IsNull(is_year1) or Trim(is_year1) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year1")
   return false
end if

is_season1 = dw_head.GetItemString(1, "season1")
if IsNull(is_season1) or Trim(is_season1) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season1")
   return false
end if



is_dep_fg = dw_head.GetItemString(1, "dep_fg")
if IsNull(is_dep_fg) or Trim(is_dep_fg) = "" then
   MessageBox(ls_title,"부진구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dep_fg")
   return false
end if

is_chi_gubn = dw_head.GetItemString(1, "chi_gubn")
if IsNull(is_chi_gubn) or Trim(is_chi_gubn) = "" then
   MessageBox(ls_title,"중국포함 여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("chi_gubn")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;Datetime ld_datetime
String ls_datetime, ls_modify, ls_chi_gubn, ls_dep_fg
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


if is_chi_gubn = "A" then 
	ls_chi_gubn = "※ 중국포함 전체"
elseif is_chi_gubn = "B" then 
	ls_chi_gubn = "※ 중국제품 제외"	
else
	ls_chi_gubn = "※ 중국제품"	
end if	

if is_dep_fg = "%" then 
	ls_dep_fg = "※ 부진포함 전체"
elseif is_dep_fg = "Y" then 
	ls_dep_fg = "※ 부진제품"	
else
	ls_dep_fg = "※ 부진 제외"	
end if	

il_rows = dw_body.retrieve(is_yymmdd, is_year, is_season, is_brand, is_dep_fg, is_chi_gubn, is_year1, is_season1)

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_create_ymd.Text = '" + ls_datetime + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "' "  + &
				"t_chi_gubn.Text = '" + ls_chi_gubn + "' "  + &				
				"t_dep_fg.Text = '" + ls_dep_fg + "' "   
dw_body.Modify(ls_modify)


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

event ue_preview();Datetime ld_datetime
String ls_datetime, ls_modify, ls_chi_gubn, ls_dep_fg


dw_print.retrieve(is_yymmdd, is_year, is_season, is_brand, is_dep_fg, is_chi_gubn, is_year1, is_season1)

if is_chi_gubn = "A" then 
	ls_chi_gubn = "※ 중국포함 전체"
elseif is_chi_gubn = "B" then 
	ls_chi_gubn = "※ 중국제품 제외"	
else
	ls_chi_gubn = "※ 중국제품"	
end if	

if is_dep_fg = "%" then 
	ls_dep_fg = "※ 부진포함 전체"
elseif is_dep_fg = "Y" then 
	ls_dep_fg = "※ 부진제품"	
else
	ls_dep_fg = "※ 부진 제외"	
end if	

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_create_ymd.Text = '" + ls_datetime + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "' "  + &
				"t_chi_gubn.Text = '" + ls_chi_gubn + "' "  + &				
				"t_dep_fg.Text = '" + ls_dep_fg + "' "   

dw_print.Modify(ls_modify)

dw_print.inv_printpreview.of_SetZoom()



end event

event ue_print();Datetime ld_datetime
String ls_datetime, ls_modify, ls_chi_gubn, ls_dep_fg


dw_print.retrieve(is_yymmdd, is_year, is_season, is_brand, is_dep_fg, is_chi_gubn, is_year1, is_season1)

if is_chi_gubn = "A" then 
	ls_chi_gubn = "※ 중국포함 전체"
elseif is_chi_gubn = "B" then 
	ls_chi_gubn = "※ 중국제품 제외"	
else
	ls_chi_gubn = "※ 중국제품"	
end if	

if is_dep_fg = "%" then 
	ls_dep_fg = "※ 부진포함 전체"
elseif is_dep_fg = "Y" then 
	ls_dep_fg = "※ 부진제품"	
else
	ls_dep_fg = "※ 부진 제외"	
end if	

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_create_ymd.Text = '" + ls_datetime + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "' "  + &
				"t_chi_gubn.Text = '" + ls_chi_gubn + "' "  + &				
				"t_dep_fg.Text = '" + ls_dep_fg + "' "   

dw_print.Modify(ls_modify)


IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55024_d","0")
end event

type cb_close from w_com010_d`cb_close within w_55024_d
end type

type cb_delete from w_com010_d`cb_delete within w_55024_d
end type

type cb_insert from w_com010_d`cb_insert within w_55024_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55024_d
end type

type cb_update from w_com010_d`cb_update within w_55024_d
end type

type cb_print from w_com010_d`cb_print within w_55024_d
end type

type cb_preview from w_com010_d`cb_preview within w_55024_d
end type

type gb_button from w_com010_d`gb_button within w_55024_d
end type

type cb_excel from w_com010_d`cb_excel within w_55024_d
end type

type dw_head from w_com010_d`dw_head within w_55024_d
integer y = 156
integer height = 316
string dataobject = "d_55024_H01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

This.GetChild("year1", idw_year1 )
idw_year1.SetTransObject(SQLCA)
idw_year1.Retrieve('002')

This.GetChild("season1", idw_season1 )
idw_season1.SetTransObject(SQLCA)
idw_season1.Retrieve('003',gs_brand, '%')

end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand, ls_bf_year
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
		
		ls_year = this.getitemstring(row, "year1")			
		this.getchild("season1",ldw_child)
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
		
	CASE "year1"
	
		
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season1",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")		
				  								
				
		
						
				

END CHOOSE 
end event

type ln_1 from w_com010_d`ln_1 within w_55024_d
integer beginy = 472
integer endy = 472
end type

type ln_2 from w_com010_d`ln_2 within w_55024_d
integer beginy = 476
integer endy = 476
end type

type dw_body from w_com010_d`dw_body within w_55024_d
integer x = 9
integer y = 492
integer width = 3602
integer height = 1548
string dataobject = "d_55024_d05"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_55024_d
string dataobject = "d_55024_r01"
end type

