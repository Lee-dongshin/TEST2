$PBExportHeader$w_52005_e.srw
$PBExportComments$품번별판매비축율관리
forward
global type w_52005_e from w_com010_e
end type
end forward

global type w_52005_e from w_com010_e
end type
global w_52005_e w_52005_e

type variables
String is_brand, is_year, is_season, is_sojae, is_item

end variables

on w_52005_e.create
call super::create
end on

on w_52005_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
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

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"품종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

return true
end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.28                                                  */	
/* 수정일      : 2002.01.28                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.28                                                  */	
/* 수정일      : 2002.01.28                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event open;call super::open;dw_head.Setitem(1, "sojae", '%')
dw_head.Setitem(1, "item",  '%')

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_52005_e","0")
end event

type cb_close from w_com010_e`cb_close within w_52005_e
end type

type cb_delete from w_com010_e`cb_delete within w_52005_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_52005_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_52005_e
end type

type cb_update from w_com010_e`cb_update within w_52005_e
end type

type cb_print from w_com010_e`cb_print within w_52005_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_52005_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_52005_e
end type

type cb_excel from w_com010_e`cb_excel within w_52005_e
end type

type dw_head from w_com010_e`dw_head within w_52005_e
integer x = 14
integer height = 156
string dataobject = "d_52005_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child) 
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("season", ldw_child) 
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('003')

This.GetChild("sojae", ldw_child) 
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('%',gs_brand)
ldw_child.insertRow(1)
ldw_child.Setitem(1, "sojae", '%')
ldw_child.Setitem(1, "sojae_nm", '전체')

This.GetChild("item", ldw_child) 
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('%',gs_brand)
ldw_child.insertRow(1)
ldw_child.Setitem(1, "item", '%')
ldw_child.Setitem(1, "item_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;
DataWindowChild ldw_child 

CHOOSE CASE dwo.name

	
	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		
	This.GetChild("sojae", ldw_child)
	ldw_child.SetTransObject(SQLCA)
	ldw_child.Retrieve('%', data)
	ldw_child.insertrow(1)
	ldw_child.Setitem(1, "sojae", "%")
	ldw_child.Setitem(1, "sojae_nm", "전체")
	
	This.GetChild("item", ldw_child)
	ldw_child.SetTransObject(SQLCA)
	ldw_child.Retrieve(data)
	ldw_child.insertrow(1)
	ldw_child.Setitem(1, "item", "%")
	ldw_child.Setitem(1, "item_nm", "전체")
		
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_52005_e
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_e`ln_2 within w_52005_e
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_e`dw_body within w_52005_e
integer y = 352
integer height = 1700
string dataobject = "d_52005_d01"
end type

type dw_print from w_com010_e`dw_print within w_52005_e
end type

