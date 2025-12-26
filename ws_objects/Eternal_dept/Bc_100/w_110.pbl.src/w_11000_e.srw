$PBExportHeader$w_11000_e.srw
$PBExportComments$사업계획기준표
forward
global type w_11000_e from w_com020_e
end type
end forward

global type w_11000_e from w_com020_e
end type
global w_11000_e w_11000_e

type variables
string is_brand, is_year, is_season, is_plan_fg, is_sojae, is_item
end variables

on w_11000_e.create
call super::create
end on

on w_11000_e.destroy
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

if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_year, is_season)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_insert();call super::ue_insert;string ls_sojae
ls_sojae = dw_body.getitemstring(1,"sojae")
if isnull(ls_sojae) or ls_sojae = "" then 	ls_sojae = is_plan_fg

dw_body.setitem(dw_body.getrow(),"brand",is_brand)
dw_body.setitem(dw_body.getrow(),"year",is_year)
dw_body.setitem(dw_body.getrow(),"season",is_season)
dw_body.setitem(dw_body.getrow(),"plan_fg",is_plan_fg)
dw_body.setitem(dw_body.getrow(),"sojae",ls_sojae)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_11000_e","0")
end event

type cb_close from w_com020_e`cb_close within w_11000_e
end type

type cb_delete from w_com020_e`cb_delete within w_11000_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_11000_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_11000_e
end type

type cb_update from w_com020_e`cb_update within w_11000_e
end type

type cb_print from w_com020_e`cb_print within w_11000_e
end type

type cb_preview from w_com020_e`cb_preview within w_11000_e
end type

type gb_button from w_com020_e`gb_button within w_11000_e
end type

type cb_excel from w_com020_e`cb_excel within w_11000_e
end type

type dw_head from w_com020_e`dw_head within w_11000_e
string dataobject = "d_11000_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('001')

is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('003',is_brand,is_year)
//ldw_child.retrieve('003')
end event

type ln_1 from w_com020_e`ln_1 within w_11000_e
end type

type ln_2 from w_com020_e`ln_2 within w_11000_e
end type

type dw_list from w_com020_e`dw_list within w_11000_e
string dataobject = "d_11000_l01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/


IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_plan_fg = This.GetItemString(row, 'plan_fg') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_plan_fg) THEN return
il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_plan_fg, "Dat")
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

event dw_list::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("plan_fg",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('111')
end event

event dw_list::buttonclicked;call super::buttonclicked;choose case dwo.name
	case "b_add"
		this.insertrow(this.rowcount()+1)
	case "b_del"
		this.deleterow(this.getrow())
end choose

end event

type dw_body from w_com020_e`dw_body within w_11000_e
string dataobject = "d_11000_d01"
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("plan_fg",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('111')

this.getchild("sojae",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('1')

this.getchild("item",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()
ldw_child.insertrow(1)
ldw_child.setitem(1,"item", "%")
ldw_child.setitem(1,"item_nm", "전체")

end event

event dw_body::buttonclicked;call super::buttonclicked;int li_prot
choose case dwo.name
	case "b_add"
		Parent.Trigger Event ue_insert()
	case "b_del"		
		Parent.Trigger Event ue_delete()
end choose

end event

type st_1 from w_com020_e`st_1 within w_11000_e
end type

type dw_print from w_com020_e`dw_print within w_11000_e
end type

