$PBExportHeader$w_31008_d.srw
$PBExportComments$생산 투입 현황
forward
global type w_31008_d from w_com010_d
end type
end forward

global type w_31008_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_31008_d w_31008_d

type variables
string is_brand, is_year, is_season, is_yymmdd, is_item
string is_fr_in_ymd, is_to_in_ymd, is_fr_ord_ymd, is_to_ord_ymd, is_make_type, is_main_gubn
datawindowchild  idw_brand, idw_year, idw_season, idw_make_type, idw_item

end variables

on w_31008_d.create
call super::create
end on

on w_31008_d.destroy
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

is_brand  = dw_head.GetItemString(1, "brand")
is_year   = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
//is_yymmdd = dw_head.GetItemString(1, "yymmdd")

is_fr_in_ymd = dw_head.GetItemString(1, "fr_in_ymd")
is_to_in_ymd = dw_head.GetItemString(1, "to_in_ymd")
is_fr_ord_ymd = dw_head.GetItemString(1, "fr_ord_ymd")
is_to_ord_ymd = dw_head.GetItemString(1, "to_ord_ymd")

is_make_type = dw_head.GetItemString(1, "make_type")
is_main_gubn = dw_head.GetItemString(1, "main_gubn")
is_item = dw_head.GetItemString(1, "item")

if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

return true

end event

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

//IF gf_cdate(ld_datetime,-1)  THEN  
//	dw_head.setitem(1,"fr_in_ymd",string(ld_datetime,"yyyymmdd"))
//	dw_head.setitem(1,"fr_ord_ymd",string(ld_datetime,"yyyymmdd"))
//end if

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_in_ymd",string(ld_datetime,"yyyymmdd"))
	dw_head.setitem(1,"to_ord_ymd",string(ld_datetime,"yyyymmdd"))
end if
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//messagebox("is_brand",is_brand)
//messagebox("is_brand",is_year)
//messagebox("is_season",is_season)
//messagebox("is_brand",is_fr_in_ymd)
//messagebox("is_brand",is_to_in_ymd)
//messagebox("is_brand",is_fr_ord_ymd)
//messagebox("is_brand",is_to_ord_ymd)
//messagebox("is_brand",is_make_type)
//messagebox("is_brand",is_main_gubn)

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_fr_in_ymd, is_to_in_ymd, is_fr_ord_ymd, is_to_ord_ymd, is_make_type, is_main_gubn, is_item)
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

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" 
dw_print.Modify(ls_modify)

dw_print.object.t_brand.text  = idw_brand.GetItemString(idw_brand.GetRow(), "inter_nm")
dw_print.object.t_year.text   = is_year
dw_print.object.t_season.text = is_season
dw_print.object.t_item.text   = is_item
dw_print.object.t_make_type.text = is_make_type

dw_print.object.t_fr_in_ymd.text  = is_fr_in_ymd
dw_print.object.t_to_in_ymd.text  = is_to_in_ymd
dw_print.object.t_fr_ord_ymd.text = is_fr_ord_ymd
dw_print.object.t_to_ord_ymd.text = is_to_ord_ymd
dw_print.object.t_item.text = idw_item.GetItemString(idw_item.GetRow(), "item_nm")

choose case is_main_gubn
	case "A"
		dw_print.object.t_main_gubn.text  = "전체"
	case "M"
		dw_print.object.t_main_gubn.text  = "메인"
	case "R"
		dw_print.object.t_main_gubn.text  = "리오다"
end choose
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_31008_d","0")
end event

type cb_close from w_com010_d`cb_close within w_31008_d
end type

type cb_delete from w_com010_d`cb_delete within w_31008_d
end type

type cb_insert from w_com010_d`cb_insert within w_31008_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_31008_d
end type

type cb_update from w_com010_d`cb_update within w_31008_d
end type

type cb_print from w_com010_d`cb_print within w_31008_d
end type

type cb_preview from w_com010_d`cb_preview within w_31008_d
end type

type gb_button from w_com010_d`gb_button within w_31008_d
end type

type cb_excel from w_com010_d`cb_excel within w_31008_d
end type

type dw_head from w_com010_d`dw_head within w_31008_d
string dataobject = "d_31008_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

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


This.GetChild("make_type", idw_make_type)
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.InsertRow(1)
idw_make_type.SetItem(1, "inter_cd", '%')
idw_make_type.SetItem(1, "inter_nm", '전체')


This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(is_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')



end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name


	CASE "brand", "year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1

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

		This.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve(is_brand)
		idw_item.insertrow(1)
		idw_item.Setitem(1, "item", "%")
		idw_item.Setitem(1, "item_nm", "전체")
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_31008_d
end type

type ln_2 from w_com010_d`ln_2 within w_31008_d
end type

type dw_body from w_com010_d`dw_body within w_31008_d
string dataobject = "d_31008_d01"
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_brand, ldw_year, ldw_make_type

This.GetChild("brand", ldw_brand)
ldw_brand.SetTransObject(SQLCA)
ldw_brand.Retrieve('001')

This.GetChild("year", ldw_year)
ldw_year.SetTransObject(SQLCA)
ldw_year.Retrieve('002')

This.GetChild("make_type", ldw_make_type)
ldw_make_type.SetTransObject(SQLCA)
ldw_make_type.Retrieve('030')

end event

type dw_print from w_com010_d`dw_print within w_31008_d
integer x = 41
integer y = 556
integer width = 1024
integer height = 416
string dataobject = "d_31008_r01"
end type

event dw_print::constructor;call super::constructor;datawindowchild  ldw_brand, ldw_make_type

dw_print.GetChild("brand", ldw_brand)
ldw_brand.SetTransObject(SQLCA)
ldw_brand.Retrieve('001')

dw_print.GetChild("make_type", ldw_make_type)
ldw_make_type.SetTransObject(SQLCA)
ldw_make_type.Retrieve('030')

end event

