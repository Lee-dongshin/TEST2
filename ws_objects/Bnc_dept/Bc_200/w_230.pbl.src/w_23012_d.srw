$PBExportHeader$w_23012_d.srw
$PBExportComments$계산서 상세내역
forward
global type w_23012_d from w_com010_d
end type
end forward

global type w_23012_d from w_com010_d
end type
global w_23012_d w_23012_d

type variables
string is_brand, is_bill_date, is_bill_type, is_cust_cd, is_dept_gubn
string is_m_type_0, is_m_type_1, is_m_type_2, is_m_type_3, is_m_type_4, is_m_type_5, is_m_type_6, is_m_type_7, is_m_type_8, is_m_type_9

datawindowchild idw_brand, idw_bill_type
end variables

on w_23012_d.create
call super::create
end on

on w_23012_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_brand = "O" or is_brand = "D" or is_brand  = "Y" or is_brand  = "A" then
	dw_print.dataObject = "d_23012_r01_olive"
	dw_print.SetTransObject(SQLCA)
	//dw_print.constructor()
	
else 	
	dw_print.dataObject = "d_23012_r01"
	dw_print.SetTransObject(SQLCA)
	//dw_print.constructor()	
end if	


	

il_rows = dw_body.retrieve(is_brand, is_bill_date, is_bill_type, is_cust_cd, is_dept_gubn, is_m_type_0, is_m_type_1, is_m_type_2, is_m_type_3, is_m_type_4, is_m_type_5, is_m_type_6, is_m_type_7, is_m_type_8, is_m_type_9)
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

event pfc_preopen;call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"bill_date",string(ld_datetime,"yyyymmdd"))

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

is_brand     = dw_head.GetItemString(1, "brand")
is_bill_date = dw_head.GetItemString(1, "bill_date")
is_bill_type = dw_head.GetItemString(1, "bill_type")
is_cust_cd   = dw_head.GetItemString(1, "cust_cd")
is_dept_gubn = dw_head.GetItemString(1, "dpet_gubn")
is_m_type_0  = dw_head.GetItemString(1, "m_type_0")
is_m_type_1  = dw_head.GetItemString(1, "m_type_1")
is_m_type_2  = dw_head.GetItemString(1, "m_type_2")
is_m_type_3  = dw_head.GetItemString(1, "m_type_3")
is_m_type_4  = dw_head.GetItemString(1, "m_type_4")
is_m_type_5  = dw_head.GetItemString(1, "m_type_5")
is_m_type_6  = dw_head.GetItemString(1, "m_type_6")
is_m_type_7  = dw_head.GetItemString(1, "m_type_7")
is_m_type_8  = dw_head.GetItemString(1, "m_type_8")
is_m_type_9  = dw_head.GetItemString(1, "m_type_9")


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
elseif ( gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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


return true

end event

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
//         cb_retrieve.Text = "조건(&Q)"
//         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_23012_d","0")
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

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_23012_d
end type

type cb_delete from w_com010_d`cb_delete within w_23012_d
end type

type cb_insert from w_com010_d`cb_insert within w_23012_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_23012_d
end type

type cb_update from w_com010_d`cb_update within w_23012_d
end type

type cb_print from w_com010_d`cb_print within w_23012_d
end type

type cb_preview from w_com010_d`cb_preview within w_23012_d
end type

type gb_button from w_com010_d`gb_button within w_23012_d
end type

type cb_excel from w_com010_d`cb_excel within w_23012_d
end type

type dw_head from w_com010_d`dw_head within w_23012_d
string dataobject = "d_23012_h01"
end type

event dw_head::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')

this.getchild("bill_type",idw_bill_type)
idw_bill_type.settransobject(sqlca)
idw_bill_type.retrieve('008')
idw_bill_type.insertrow(1)
idw_bill_type.setitem(1,"inter_cd","%")
idw_bill_type.setitem(1,"inter_nm","전체")


end event

type ln_1 from w_com010_d`ln_1 within w_23012_d
end type

type ln_2 from w_com010_d`ln_2 within w_23012_d
end type

type dw_body from w_com010_d`dw_body within w_23012_d
integer x = 14
integer y = 452
string dataobject = "d_23012_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("pay_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('007')

end event

type dw_print from w_com010_d`dw_print within w_23012_d
integer x = 32
integer y = 648
integer width = 846
integer height = 340
string dataobject = "d_23012_r01_olive"
end type

event dw_print::constructor;call super::constructor;//datawindowchild ldw_child
//
//this.getchild("pay_gubn",ldw_child)
//ldw_child.settransobject(sqlca)
//ldw_child.retrieve('007')

end event

