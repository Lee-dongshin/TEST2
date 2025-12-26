$PBExportHeader$w_31006_d.srw
$PBExportComments$주간별 입고 예정 스타일
forward
global type w_31006_d from w_com010_d
end type
end forward

global type w_31006_d from w_com010_d
end type
global w_31006_d w_31006_d

type variables
DataWindowChild idw_brand, idw_season, idw_make_type

String is_brand, is_year, is_season, is_make_type, is_fr_deli_dt, is_to_deli_dt

end variables

forward prototypes
public function long wf_body_set (long al_rows)
end prototypes

public function long wf_body_set (long al_rows);/* dw_body에 dw_print에서 조회된 data를 셋팅 */
Long i, ll_col_cnt = 6, ll_rows
String ls_deli_chk = '00000000', ls_deli_ymd

For i = 1 To al_rows
	ls_deli_ymd = dw_print.GetItemString(i, "delivery_ymd")
	If ll_col_cnt > 5 or ls_deli_chk <> ls_deli_ymd Then
		ll_rows = dw_body.InsertRow(0)
		If ll_rows <= 0 Then Return -1
		ll_col_cnt = 1
		dw_body.SetItem(ll_rows, "delivery_ymd", ls_deli_ymd)
		ls_deli_chk = ls_deli_ymd
	End If
	dw_body.SetItem(ll_rows, "style" + String(ll_col_cnt), dw_print.GetItemString(i, "style"))
	dw_body.SetItem(ll_rows, "chno" + String(ll_col_cnt), dw_print.GetItemString(i, "chno"))
	dw_body.SetItem(ll_rows, "cust_cd" + String(ll_col_cnt), dw_print.GetItemString(i, "cust_cd"))
	dw_body.SetItem(ll_rows, "cust_nm" + String(ll_col_cnt), dw_print.GetItemString(i, "cust_nm"))
	dw_body.SetItem(ll_rows, "style_pic" + String(ll_col_cnt), dw_print.GetItemString(i, "style_pic"))
	ll_col_cnt++
Next

Return ll_rows

end function

on w_31006_d.create
call super::create
end on

on w_31006_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_print.retrieve(is_brand, is_year, is_season, is_make_type, is_fr_deli_dt, is_to_deli_dt)
dw_body.Reset()

dw_body.SetRedraw(False)
IF il_rows > 0 THEN
	If wf_body_set(il_rows) <= 0 Then 
		MessageBox("조회오류", "데이터 셋팅에 실패 하였습니다.")
		il_rows = -1
	Else
		This.Trigger Event ue_title()
	   dw_body.SetFocus()
	End If
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF
dw_body.SetRedraw(True)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "fr_deli_dt", ld_datetime)
dw_head.SetItem(1, "to_deli_dt", ld_datetime)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

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
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_make_type = dw_head.GetItemString(1, "make_type")
if IsNull(is_make_type) or Trim(is_make_type) = "" then
   MessageBox(ls_title,"생산형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("make_type")
   return false
end if

is_fr_deli_dt = String(dw_head.GetItemDatetime(1, "fr_deli_dt"), 'yyyymmdd')
if IsNull(is_fr_deli_dt) or Trim(is_fr_deli_dt) = "" then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_deli_dt")
   return false
end if

is_to_deli_dt = String(dw_head.GetItemDatetime(1, "to_deli_dt"), 'yyyymmdd')
if IsNull(is_to_deli_dt) or Trim(is_to_deli_dt) = "" then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_deli_dt")
   return false
end if

If is_to_deli_dt < is_fr_deli_dt Then
   MessageBox(ls_title,"마지막 일자가 처음 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_deli_dt")
   return false
end if

return true

end event

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.14                                                  */	
/* 수정일      : 2001.12.14                                                  */
/*===========================================================================*/

dw_body.inv_printpreview.of_SetZoom()

end event

event ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.14                                                  */	
/* 수정일      : 2001.12.14                                                  */
/*===========================================================================*/

IF dw_body.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_body.Print()
END IF

This.Trigger Event ue_msg(6, il_rows)

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
				"t_user_id.Text = '" + gs_user_id + "'" + &
				"t_datetime.Text = '" + ls_datetime + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_year.Text = '" + is_year + "'" + &
				"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
				"t_make_type.Text = '" + idw_make_type.GetItemString(idw_make_type.GetRow(), "inter_display") + "'" + &
				"t_fr_deli_dt.Text = '" + String(is_fr_deli_dt, '@@@@/@@/@@') + "'" + &
				"t_to_deli_dt.Text = '" + String(is_to_deli_dt, '@@@@/@@/@@') + "'"

dw_body.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_31006_d","0")
end event

type cb_close from w_com010_d`cb_close within w_31006_d
end type

type cb_delete from w_com010_d`cb_delete within w_31006_d
end type

type cb_insert from w_com010_d`cb_insert within w_31006_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_31006_d
end type

type cb_update from w_com010_d`cb_update within w_31006_d
end type

type cb_print from w_com010_d`cb_print within w_31006_d
end type

type cb_preview from w_com010_d`cb_preview within w_31006_d
end type

type gb_button from w_com010_d`gb_button within w_31006_d
end type

type cb_excel from w_com010_d`cb_excel within w_31006_d
end type

type dw_head from w_com010_d`dw_head within w_31006_d
integer height = 220
string dataobject = "d_31006_h01"
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

This.GetChild("make_type", idw_make_type)
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.InsertRow(1)
idw_make_type.SetItem(1, "inter_cd", '%')
idw_make_type.SetItem(1, "inter_nm", '전체')

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

END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_31006_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_d`ln_2 within w_31006_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_31006_d
integer y = 444
integer height = 1596
string dataobject = "d_31006_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;This.of_SetPrintPreview(TRUE)

end event

type dw_print from w_com010_d`dw_print within w_31006_d
string dataobject = "d_31006_d03"
end type

