$PBExportHeader$w_31020_d.srw
$PBExportComments$년도시즌별 원가비교현황
forward
global type w_31020_d from w_com010_d
end type
end forward

global type w_31020_d from w_com010_d
end type
global w_31020_d w_31020_d

type variables
string is_brand, is_year, is_season, is_yymmdd
datawindowchild idw_brand, idw_season

end variables

on w_31020_d.create
call super::create
end on

on w_31020_d.destroy
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
is_season = dw_head.GetItemString(1, "season")
is_yymmdd = dw_head.GetItemString(1, "yymmdd")

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_yymmdd)
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

event ue_preview;
il_rows = dw_print.retrieve(is_brand, is_year, is_season, is_yymmdd)
dw_print.inv_printpreview.of_SetZoom()
end event

type cb_close from w_com010_d`cb_close within w_31020_d
end type

type cb_delete from w_com010_d`cb_delete within w_31020_d
end type

type cb_insert from w_com010_d`cb_insert within w_31020_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_31020_d
end type

type cb_update from w_com010_d`cb_update within w_31020_d
end type

type cb_print from w_com010_d`cb_print within w_31020_d
end type

type cb_preview from w_com010_d`cb_preview within w_31020_d
end type

type gb_button from w_com010_d`gb_button within w_31020_d
end type

type cb_excel from w_com010_d`cb_excel within w_31020_d
end type

type dw_head from w_com010_d`dw_head within w_31020_d
integer y = 164
integer height = 164
string dataobject = "d_31020_h01"
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

END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_31020_d
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_d`ln_2 within w_31020_d
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_d`dw_body within w_31020_d
integer y = 368
integer width = 3621
integer height = 1668
string dataobject = "d_31020_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_31020_d
integer x = 114
integer y = 568
integer width = 933
integer height = 256
string dataobject = "d_31020_d01"
end type

