$PBExportHeader$w_23019_d.srw
$PBExportComments$시즌별 마감현황
forward
global type w_23019_d from w_com010_d
end type
end forward

global type w_23019_d from w_com010_d
integer width = 3675
integer height = 2268
end type
global w_23019_d w_23019_d

type variables
string is_brand, is_fr_yymmdd, is_to_yymmdd, is_year, is_season, is_mat_type, is_bill_type
datawindowchild idw_brand, idw_season, idw_mat_type, idw_bill_type
end variables

on w_23019_d.create
call super::create
end on

on w_23019_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime

IF gf_cdate(ld_datetime,-12)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

end event

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

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_mat_type = dw_head.GetItemString(1, "mat_type")
is_bill_type = dw_head.GetItemString(1, "bill_type")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_year, is_season, is_mat_type, is_bill_type)
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

il_rows = dw_print.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_year, is_season, is_mat_type, is_bill_type)
dw_print.inv_printpreview.of_SetZoom()


end event

event ue_print();//
end event

type cb_close from w_com010_d`cb_close within w_23019_d
end type

type cb_delete from w_com010_d`cb_delete within w_23019_d
end type

type cb_insert from w_com010_d`cb_insert within w_23019_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_23019_d
end type

type cb_update from w_com010_d`cb_update within w_23019_d
end type

type cb_print from w_com010_d`cb_print within w_23019_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_23019_d
end type

type gb_button from w_com010_d`gb_button within w_23019_d
end type

type cb_excel from w_com010_d`cb_excel within w_23019_d
end type

type dw_head from w_com010_d`dw_head within w_23019_d
integer y = 164
integer height = 216
string dataobject = "d_23019_h01"
end type

event dw_head::constructor;call super::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')
idw_brand.insertrow(1)
idw_brand.setitem(1,"inter_cd","%")
idw_brand.setitem(1,"inter_nm","전체")


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


This.GetChild("mat_type", idw_mat_type)
idw_mat_type.SetTransObject(SQLCA)
idw_mat_type.Retrieve('014')
idw_mat_type.insertrow(1)
idw_mat_type.setitem(1,"inter_cd","%")
idw_mat_type.setitem(1,"inter_nm","전체")


This.GetChild("bill_type", idw_bill_type)
idw_bill_type.SetTransObject(SQLCA)
idw_bill_type.Retrieve('008')
idw_bill_type.insertrow(1)
idw_bill_type.setitem(1,"inter_cd","%")
idw_bill_type.setitem(1,"inter_nm","전체")


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

type ln_1 from w_com010_d`ln_1 within w_23019_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_d`ln_2 within w_23019_d
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_d`dw_body within w_23019_d
integer y = 404
integer height = 1632
string dataobject = "d_23019_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_23019_d
string dataobject = "d_23019_d01"
end type

