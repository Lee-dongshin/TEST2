$PBExportHeader$w_21013_e.srw
$PBExportComments$자재발주컨펌
forward
global type w_21013_e from w_com010_e
end type
end forward

global type w_21013_e from w_com010_e
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
windowstate windowstate = maximized!
end type
global w_21013_e w_21013_e

type variables
string is_mat_cd
end variables

on w_21013_e.create
call super::create
end on

on w_21013_e.destroy
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

is_mat_cd = dw_head.GetItemString(1, "mat_cd")

if isnull(is_mat_cd) then 
	is_mat_cd = gsv_cd.gs_cd7
	dw_head.SetItem(1, "mat_cd", is_mat_cd)	
end if





if gs_brand = 'N' and (MidA(is_mat_cd,1,1) = 'O' or MidA(is_mat_cd,1,1) = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("mat_cd")
   return false
elseif (gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (MidA(is_mat_cd,1,1) = 'N' or MidA(is_mat_cd,1,1) = 'B' or MidA(is_mat_cd,1,1) = 'L' or MidA(is_mat_cd,1,1) = 'F' or MidA(is_mat_cd,1,1) = 'G'  or MidA(is_mat_cd,1,1) = 'J' ) then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("mat_cd")
   return false	
elseif gs_brand = 'B' and (MidA(is_mat_cd,1,1) = 'O' or MidA(is_mat_cd,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("mat_cd")
   return false		
elseif gs_brand = 'G' and (MidA(is_mat_cd,1,1) = 'O' or MidA(is_mat_cd,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("mat_cd")
   return false			
end if	

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_head.retrieve(is_mat_cd)
il_rows = dw_body.retrieve(is_mat_cd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

//This.Trigger Event ue_button(1, il_rows)
//This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);//
end event

event open;call super::open;Trigger Event ue_retrieve()	//조회
end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_head.RowCount()
IF dw_head.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

//FOR i=1 TO ll_row_count
//   idw_status = dw_head.GetItemStatus(i, 0, Primary!)
//   IF idw_status = NewModified! THEN				/* New Record */
//      dw_body.Setitem(i, "reg_id", gs_user_id)
//   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
//      dw_body.Setitem(i, "mod_id", gs_user_id)
//      dw_body.Setitem(i, "mod_dt", ld_datetime)
//   END IF
//NEXT

il_rows = dw_head.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_head.ResetUpdate()
	ib_changed = false
   commit  USING SQLCA;
	Trigger Event ue_retrieve()	

else
   rollback  USING SQLCA;
end if

//This.Trigger Event ue_button(3, il_rows)
//This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen();call super::pfc_preopen;dw_head.SetTransObject(SQLCA)
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로

dw_print.retrieve(is_mat_cd)
dw_print.inv_printpreview.of_SetZoom()

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_21013_e","0")
end event

type cb_close from w_com010_e`cb_close within w_21013_e
end type

type cb_delete from w_com010_e`cb_delete within w_21013_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_21013_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_21013_e
boolean visible = false
boolean enabled = false
end type

type cb_update from w_com010_e`cb_update within w_21013_e
end type

type cb_print from w_com010_e`cb_print within w_21013_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_21013_e
boolean enabled = true
end type

type gb_button from w_com010_e`gb_button within w_21013_e
end type

type cb_excel from w_com010_e`cb_excel within w_21013_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_21013_e
integer height = 176
string dataobject = "d_21013_h02"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
//cb_print.enabled = false
//cb_preview.enabled = false
//cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
//
//CHOOSE CASE dwo.name
//	CASE "colunm1" 
//    IF data = 'A' THEN
//	      /*action*/
//    END IF
//	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
//END CHOOSE
//
end event

type ln_1 from w_com010_e`ln_1 within w_21013_e
integer beginy = 364
integer endy = 364
end type

type ln_2 from w_com010_e`ln_2 within w_21013_e
integer beginy = 368
integer endy = 368
end type

type dw_body from w_com010_e`dw_body within w_21013_e
integer y = 388
integer height = 1640
string dataobject = "d_21013_r00"
end type

type dw_print from w_com010_e`dw_print within w_21013_e
string dataobject = "d_21013_r00"
end type

