$PBExportHeader$w_32023_d.srw
$PBExportComments$출고차순별 입고현황
forward
global type w_32023_d from w_com010_d
end type
end forward

global type w_32023_d from w_com010_d
end type
global w_32023_d w_32023_d

type variables
string is_brand, is_fr_year, is_fr_season, is_to_year, is_to_season, is_make_type, is_reorder, is_fr_out_seq, is_to_out_seq, is_exp_gbn
datawindowchild idw_brand, idw_fr_season, idw_to_season, idw_make_type
end variables

on w_32023_d.create
call super::create
end on

on w_32023_d.destroy
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


is_fr_year   = dw_head.GetItemString(1, "fr_year")
is_fr_season = dw_head.GetItemString(1, "fr_season")
is_to_year   = dw_head.GetItemString(1, "to_year")
is_to_season = dw_head.GetItemString(1, "to_season")
is_make_type = dw_head.GetItemString(1, "make_type")
is_reorder   = dw_head.GetItemString(1, "reorder")
is_fr_out_seq   = dw_head.GetItemString(1, "fr_out_seq")
is_to_out_seq   = dw_head.GetItemString(1, "to_out_seq")
is_exp_gbn   = dw_head.GetItemString(1, "exp_gbn")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_year, is_fr_season, is_to_year, is_to_season, is_make_type, is_reorder, is_exp_gbn, is_fr_out_seq, is_to_out_seq)
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

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

il_rows = dw_print.retrieve(is_brand, is_fr_year, is_fr_season, is_to_year, is_to_season, is_make_type, is_reorder, is_exp_gbn, is_fr_out_seq, is_to_out_seq)
dw_print.inv_printpreview.of_SetZoom()

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

type cb_close from w_com010_d`cb_close within w_32023_d
end type

type cb_delete from w_com010_d`cb_delete within w_32023_d
end type

type cb_insert from w_com010_d`cb_insert within w_32023_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_32023_d
end type

type cb_update from w_com010_d`cb_update within w_32023_d
end type

type cb_print from w_com010_d`cb_print within w_32023_d
end type

type cb_preview from w_com010_d`cb_preview within w_32023_d
end type

type gb_button from w_com010_d`gb_button within w_32023_d
end type

type cb_excel from w_com010_d`cb_excel within w_32023_d
end type

type dw_head from w_com010_d`dw_head within w_32023_d
integer height = 240
string dataobject = "d_32023_h01"
end type

event dw_head::constructor;call super::constructor;string ls_filter_str
datawindowchild idw_child

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertrow(1)
idw_brand.setitem(1,"inter_cd","[NO]")
idw_brand.setitem(1,"inter_nm","온앤온올리브")

//ls_filter_str = "inter_cd in ('N','O','W','[NO]')" 
//idw_brand.SetFilter(ls_filter_str)
//idw_brand.Filter( )


//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_fr_year = dw_head.getitemstring(1,'fr_year')
is_to_year = dw_head.getitemstring(1,'to_year')

this.getchild("season",idw_fr_season)
idw_fr_season.settransobject(sqlca)
idw_fr_season.retrieve('003', is_brand, is_fr_year)
//idw_season.retrieve('003')

this.getchild("season",idw_to_season)
idw_to_season.settransobject(sqlca)
idw_to_season.retrieve('003', is_brand, is_to_year)
//idw_season.retrieve('003')

This.GetChild("make_type", idw_make_type)
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.insertrow(1)
idw_make_type.setitem(1,"inter_cd","%")
idw_make_type.setitem(1,"inter_nm","전체")




This.GetChild("fr_out_seq", idw_child)
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve('010')


This.GetChild("to_out_seq", idw_child)
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve('010')





end event

event dw_head::itemchanged;call super::itemchanged;

CHOOSE CASE dwo.name
	CASE "brand", "fr_year"	, "to_year"	
		//라빠레트 시즌적용
		dw_head.accepttext()
		is_brand = dw_head.getitemstring(1,'brand')
		is_fr_year = dw_head.getitemstring(1,'fr_year')
		is_to_year = dw_head.getitemstring(1,'to_year')
		
		this.getchild("season",idw_fr_season)
		idw_fr_season.settransobject(sqlca)
		idw_fr_season.retrieve('003', is_brand, is_fr_year)
		//idw_season.retrieve('003')
		
		this.getchild("season",idw_to_season)
		idw_to_season.settransobject(sqlca)
		idw_to_season.retrieve('003', is_brand, is_to_year)

END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_32023_d
end type

type ln_2 from w_com010_d`ln_2 within w_32023_d
end type

type dw_body from w_com010_d`dw_body within w_32023_d
string dataobject = "d_32023_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_32023_d
string dataobject = "d_32023_r01"
end type

