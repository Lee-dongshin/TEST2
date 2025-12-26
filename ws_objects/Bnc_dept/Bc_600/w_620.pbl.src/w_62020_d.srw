$PBExportHeader$w_62020_d.srw
$PBExportComments$각종 분석 차트
forward
global type w_62020_d from w_com020_d
end type
end forward

global type w_62020_d from w_com020_d
integer width = 3680
integer height = 2256
end type
global w_62020_d w_62020_d

type variables
string is_brand, is_year, is_season, is_sojae, is_yymm, is_var, is_opt, is_sort
datawindowchild	idw_brand, idw_season, idw_sojae


end variables

on w_62020_d.create
call super::create
end on

on w_62020_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_preopen();datetime ld_datetime
of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")


/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToBottom")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(st_1, "ScaleToBottom")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
//dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
dw_list.InsertRow(0)


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"yymm",string(ld_datetime,"yyyymm"))

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
is_year  = dw_head.GetItemString(1, "year")
is_season= dw_head.GetItemString(1, "season")
is_sojae = dw_head.GetItemString(1, "sojae")
is_yymm  = dw_head.GetItemString(1, "yymm")
is_var   = dw_head.GetItemString(1, "var")
is_opt   = dw_head.GetItemString(1, "opt")
is_sort  = dw_head.GetItemString(1, "sort")


if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

return true

end event

event ue_button(integer ai_cb_div, long al_rows);///*===========================================================================*/
///* 작성자      : (주)지우정보 (김 태범)                                      */	
///* 작성일      : 2001.01.01                                                  */	
///* 수정일      : 2001.01.01                                                  */
///*===========================================================================*/
///* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
///*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
///*===========================================================================*/
//
//CHOOSE CASE ai_cb_div
//   CASE 1		/* 조회 */
//      if al_rows > 0 then
//         cb_retrieve.Text = "조건(&Q)"
//         dw_head.Enabled = false
//         dw_list.Enabled = true
//         dw_body.Enabled = true
//      else
//         dw_head.SetFocus()
//      end if
//
//   CASE 5    /* 조건 */
//      cb_retrieve.Text = "조회(&Q)"
//      cb_print.enabled = false
//      cb_preview.enabled = false
//      cb_excel.enabled = false
//      dw_list.Enabled = false
//      dw_body.Enabled = false
//      dw_head.Enabled = true
//      dw_head.SetFocus()
//      dw_head.SetColumn(1)
//
//   CASE 7  /* dw_list clicked 조회 */
//      if al_rows > 0 then
//         cb_print.enabled = true
//         cb_preview.enabled = true
//         cb_excel.enabled = true
//		else
//         cb_print.enabled = false
//         cb_preview.enabled = false
//         cb_excel.enabled = false
//		end if
//END CHOOSE
//
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_yymm, is_var, is_opt, is_sort)
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_62020_d","0")
end event

type cb_close from w_com020_d`cb_close within w_62020_d
end type

type cb_delete from w_com020_d`cb_delete within w_62020_d
end type

type cb_insert from w_com020_d`cb_insert within w_62020_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_62020_d
end type

type cb_update from w_com020_d`cb_update within w_62020_d
end type

type cb_print from w_com020_d`cb_print within w_62020_d
end type

type cb_preview from w_com020_d`cb_preview within w_62020_d
end type

type gb_button from w_com020_d`gb_button within w_62020_d
end type

type cb_excel from w_com020_d`cb_excel within w_62020_d
end type

type dw_head from w_com020_d`dw_head within w_62020_d
integer y = 160
integer height = 164
string dataobject = "d_62020_h01"
end type

event dw_head::constructor;call super::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003',gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')


end event

event dw_head::itemchanged;call super::itemchanged;
string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")

		This.GetChild("sojae", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('%', data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "sojae", "%")
		ldw_child.Setitem(1, "sojae_nm", "전체")
		
	
//		This.GetChild("item", idw_item)
//		idw_item.SetTransObject(SQLCA)
//		idw_item.Retrieve(data)
//		idw_item.insertrow(1)
//		idw_item.Setitem(1, "item", "%")
//		idw_item.Setitem(1, "item_nm", "전체")		
//				
		
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

type ln_1 from w_com020_d`ln_1 within w_62020_d
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com020_d`ln_2 within w_62020_d
integer beginy = 328
integer endy = 328
end type

type dw_list from w_com020_d`dw_list within w_62020_d
integer y = 344
integer width = 581
integer height = 1680
string dataobject = "d_62020_l01"
boolean vscrollbar = false
end type

event dw_list::itemchanged;call super::itemchanged;dw_head.setitem(1,"opt",data)
end event

type dw_body from w_com020_d`dw_body within w_62020_d
integer x = 626
integer y = 344
integer width = 2971
integer height = 1676
string dataobject = "d_62020_d01"
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "opt"      // dddw로 작성된 항목
    dw_head.Setitem(1,"opt",data)

END CHOOSE

end event

type st_1 from w_com020_d`st_1 within w_62020_d
integer x = 608
integer y = 344
integer height = 1676
end type

type dw_print from w_com020_d`dw_print within w_62020_d
end type

