$PBExportHeader$w_41017_d.srw
$PBExportComments$시간대별 입고 현황
forward
global type w_41017_d from w_com010_d
end type
end forward

global type w_41017_d from w_com010_d
end type
global w_41017_d w_41017_d

type variables
DataWindowChild idw_brand, idw_year, idw_season
String is_brand, is_fr_ymd, is_to_ymd, is_cust_cd, is_style, is_in_time, is_year, is_season, is_style_opt, is_chn_gubn

end variables

on w_41017_d.create
call super::create
end on

on w_41017_d.destroy
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


is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
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

is_cust_cd = dw_head.GetItemString(1, "cust_cd")
if IsNull(is_cust_cd) or Trim(is_cust_cd) = "" then
   is_cust_cd = "%"   
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
   is_style = "%"   
end if

is_in_time = dw_head.GetItemString(1, "in_time")
if IsNull(is_in_time) or Trim(is_in_time) = "" then
   MessageBox(ls_title,"입고시간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("in_time")
   return false  
end if

is_style_opt = dw_head.GetItemString(1, "style_opt")
is_chn_gubn = dw_head.GetItemString(1, "chn_gubn")

return true

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//@brand     	varchar(01), 
//@fr_ymd      	varchar(08),
//@to_ymd      	varchar(08),
//@cust_cd	varchar(06),
//@style		varchar(08),
//@year		varchar(04),
//@season		varchar(01),
//@in_time	varchar(03), -- T00 : 전체, T15 ~ T21
//@style_opt	varchar(01)
//

il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_cust_cd, is_style, is_year, is_season, is_in_time, is_style_opt, is_chn_gubn)
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

event open;call super::open;dw_head.setitem(1,"in_time", "T00")
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"W_41017_d","0")
end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm, ls_between, ls_cust_nm

if is_cust_cd = "%" then
 ls_cust_nm = "전체"
else
 ls_cust_nm = dw_head.getitemstring(1, "cust_nm")
end if


ls_shop_nm = is_cust_cd + ' ' + ls_cust_nm
ls_between = String(is_fr_ymd, '@@@@/@@/@@') + " ~ " + String(is_to_ymd, '@@@@/@@/@@')
IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
				"t_user_id.Text = '" + gs_user_id + "'" + &
				"t_datetime.Text = '" + ls_datetime + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "' " + &
				"t_year.Text = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "' " + &					
				"t_between.Text = '" + ls_between + "' "   + &
				"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "' " +&
				"t_cust_cd.Text = '" + ls_shop_nm+ "' "   
//messagebox("ls_modify", ls_modify)

dw_print.Modify(ls_modify)

end event

type cb_close from w_com010_d`cb_close within w_41017_d
end type

type cb_delete from w_com010_d`cb_delete within w_41017_d
end type

type cb_insert from w_com010_d`cb_insert within w_41017_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_41017_d
end type

type cb_update from w_com010_d`cb_update within w_41017_d
end type

type cb_print from w_com010_d`cb_print within w_41017_d
end type

type cb_preview from w_com010_d`cb_preview within w_41017_d
end type

type gb_button from w_com010_d`gb_button within w_41017_d
end type

type cb_excel from w_com010_d`cb_excel within w_41017_d
end type

type dw_head from w_com010_d`dw_head within w_41017_d
integer y = 156
integer width = 3849
integer height = 284
string dataobject = "d_41017_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')

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

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
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

type ln_1 from w_com010_d`ln_1 within w_41017_d
integer beginy = 468
integer endy = 468
end type

type ln_2 from w_com010_d`ln_2 within w_41017_d
integer beginy = 472
integer endy = 472
end type

type dw_body from w_com010_d`dw_body within w_41017_d
integer y = 480
integer width = 3607
integer height = 1532
string dataobject = "d_41017_d01"
end type

type dw_print from w_com010_d`dw_print within w_41017_d
string dataobject = "d_41017_r01"
end type

