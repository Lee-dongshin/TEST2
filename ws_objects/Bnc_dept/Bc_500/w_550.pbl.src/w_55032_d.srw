$PBExportHeader$w_55032_d.srw
$PBExportComments$브랜드진행 전년비교
forward
global type w_55032_d from w_com010_d
end type
end forward

global type w_55032_d from w_com010_d
integer width = 3680
integer height = 2276
end type
global w_55032_d w_55032_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_vs_year, idw_vs_season
String is_brand , is_year , is_season, is_vs_year, is_vs_season, is_fr_ymd, is_to_ymd, is_vs_fr_ymd, is_vs_to_ymd
String is_opt_chn
end variables

on w_55032_d.create
call super::create
end on

on w_55032_d.destroy
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




is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"기준년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) =  "" then
   MessageBox(ls_title,"기준시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_vs_year = dw_head.GetItemString(1, "vs_year")
if IsNull(is_vs_year) or Trim(is_vs_year) = "" then
   MessageBox(ls_title,"비교준년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("vs_year")
   return false
end if


is_vs_season = dw_head.GetItemString(1, "vs_season")
if IsNull(is_vs_season) or Trim(is_vs_season) =  "" then
   MessageBox(ls_title,"비교시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("vs_season")
   return false
end if

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"기준기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"기준기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_vs_fr_ymd = dw_head.GetItemString(1, "vs_fr_ymd")
if IsNull(is_vs_fr_ymd) or Trim(is_vs_fr_ymd) = "" then
   MessageBox(ls_title,"비교기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("vs_fr_ymd")
   return false
end if

is_vs_to_ymd = dw_head.GetItemString(1, "vs_to_ymd")
if IsNull(is_vs_to_ymd) or Trim(is_vs_to_ymd) = "" then
   MessageBox(ls_title,"비교기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("vs_to_ymd")
   return false
end if

is_opt_chn = dw_head.GetItemString(1, "opt_chn")


return true

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year , is_season , is_vs_year, is_vs_season, is_opt_chn, is_fr_ymd, is_to_ymd, is_vs_fr_ymd, is_vs_to_ymd)
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

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

type cb_close from w_com010_d`cb_close within w_55032_d
end type

type cb_delete from w_com010_d`cb_delete within w_55032_d
end type

type cb_insert from w_com010_d`cb_insert within w_55032_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55032_d
end type

type cb_update from w_com010_d`cb_update within w_55032_d
end type

type cb_print from w_com010_d`cb_print within w_55032_d
end type

type cb_preview from w_com010_d`cb_preview within w_55032_d
end type

type gb_button from w_com010_d`gb_button within w_55032_d
end type

type cb_excel from w_com010_d`cb_excel within w_55032_d
end type

type dw_head from w_com010_d`dw_head within w_55032_d
integer x = 27
integer width = 3557
integer height = 300
string dataobject = "d_55032_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

This.GetChild("vs_year", idw_vs_year)
idw_vs_year.SetTransObject(SQLCA)
idw_vs_year.Retrieve('002')

This.GetChild("vs_season", idw_vs_season)
idw_vs_season.SetTransObject(SQLCA)
idw_vs_season.Retrieve('003', gs_brand, '%')
end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand, ls_bf_year
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
		
  CASE  "vs_year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("vs_season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")							

END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_55032_d
integer beginy = 492
integer endy = 492
end type

type ln_2 from w_com010_d`ln_2 within w_55032_d
integer beginy = 496
integer endy = 496
end type

type dw_body from w_com010_d`dw_body within w_55032_d
integer y = 512
integer height = 1528
string dataobject = "d_55032_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_55032_d
end type

