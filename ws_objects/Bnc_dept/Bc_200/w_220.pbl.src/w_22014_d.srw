$PBExportHeader$w_22014_d.srw
$PBExportComments$부자재입고 비교조회
forward
global type w_22014_d from w_com010_d
end type
end forward

global type w_22014_d from w_com010_d
end type
global w_22014_d w_22014_d

type variables
DataWindowChild idw_brand , idw_year, idw_season
String is_year , is_season, is_yymm, is_opt, is_brand, is_export_yn
end variables

on w_22014_d.create
call super::create
end on

on w_22014_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22014_d","0")
end event

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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_opt = dw_head.GetItemString(1, "opt")

is_export_yn = dw_head.GetItemString(1, "export_yn")

return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year ,is_season, is_yymm, is_opt, is_export_yn)
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

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id + "'" + &
            "t_user_id.Text  = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_yymm.Text  = '" + String(is_yymm, '@@@@/@@') + "'" + &
				"t_brand.Text = '" +idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_year.Text = '" +idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "'" + &
				"t_season.Text = '" +idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" 

dw_print.Modify(ls_modify)

end event

type cb_close from w_com010_d`cb_close within w_22014_d
end type

type cb_delete from w_com010_d`cb_delete within w_22014_d
end type

type cb_insert from w_com010_d`cb_insert within w_22014_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_22014_d
end type

type cb_update from w_com010_d`cb_update within w_22014_d
end type

type cb_print from w_com010_d`cb_print within w_22014_d
end type

type cb_preview from w_com010_d`cb_preview within w_22014_d
end type

type gb_button from w_com010_d`gb_button within w_22014_d
end type

type cb_excel from w_com010_d`cb_excel within w_22014_d
end type

type dw_head from w_com010_d`dw_head within w_22014_d
integer x = 5
integer y = 156
integer width = 3593
integer height = 152
string dataobject = "d_22014_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')


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
end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
	CASE "brand", "year"		
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
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_22014_d
integer beginy = 308
integer endy = 308
end type

type ln_2 from w_com010_d`ln_2 within w_22014_d
integer beginy = 312
integer endy = 312
end type

type dw_body from w_com010_d`dw_body within w_22014_d
integer y = 320
integer height = 1720
string dataobject = "d_22014_d01"
end type

type dw_print from w_com010_d`dw_print within w_22014_d
string dataobject = "d_22014_r01"
end type

