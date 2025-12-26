$PBExportHeader$w_52008_e.srw
$PBExportComments$매장반품율통제관리
forward
global type w_52008_e from w_com010_e
end type
end forward

global type w_52008_e from w_com010_e
end type
global w_52008_e w_52008_e

type variables
String is_brand, is_shop_div, is_yymm, is_empno
end variables

on w_52008_e.create
call super::create
end on

on w_52008_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
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


is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"적용월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("is_yymm")
   return false
end if

is_empno = dw_head.GetItemString(1, "empno")
if IsNull(is_empno) or Trim(is_empno) = "" then
	is_empno = '%'
end if

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_brand, is_yymm, is_shop_div, '%')
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
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
   IF idw_status = NewModified! THEN			/* New Record */
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

event open;call super::open;datetime ld_datetime
string ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.Setitem(1, "yymm", string(ld_datetime, "YYYYMM"))
dw_head.Setitem(1, "shop_div", "%")

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_52008_e","0")
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =  "t_brand.Text = '" + is_brand + "'" + &
             "t_fr_yymm.text = '" + is_yymm + "'" + &
             "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)
end event

type cb_close from w_com010_e`cb_close within w_52008_e
end type

type cb_delete from w_com010_e`cb_delete within w_52008_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_52008_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_52008_e
end type

type cb_update from w_com010_e`cb_update within w_52008_e
end type

type cb_print from w_com010_e`cb_print within w_52008_e
boolean enabled = true
end type

type cb_preview from w_com010_e`cb_preview within w_52008_e
boolean enabled = true
end type

type gb_button from w_com010_e`gb_button within w_52008_e
end type

type cb_excel from w_com010_e`cb_excel within w_52008_e
boolean enabled = true
end type

type dw_head from w_com010_e`dw_head within w_52008_e
integer height = 160
string dataobject = "d_52008_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_Child

This.GetChild("brand", ldw_Child)
ldw_Child.SetTransObject(SQLCA)
ldw_Child.Retrieve('001')

This.GetChild("shop_div", ldw_Child)
ldw_Child.SetTransObject(SQLCA)
ldw_Child.Retrieve('910')
ldw_Child.insertRow(1)
ldw_Child.Setitem(1, "inter_cd", "%")
ldw_Child.Setitem(1, "inter_nm", "전체")
//ldw_child.SetFilter("inter_cd <> 'A' and inter_cd <> 'T' and inter_cd <> 'X'")
ldw_child.SetFilter("inter_cd <> 'A' ")
ldw_child.Filter()
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(row, "empno", "")
		This.SetItem(row, "empno_nm_h", "")
	CASE "empno", "empno_h"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_52008_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_e`ln_2 within w_52008_e
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_e`dw_body within w_52008_e
integer y = 372
integer width = 3566
integer height = 1624
string dataobject = "d_52008_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_e`dw_print within w_52008_e
integer x = 174
integer y = 496
string dataobject = "d_52008_r01"
end type

