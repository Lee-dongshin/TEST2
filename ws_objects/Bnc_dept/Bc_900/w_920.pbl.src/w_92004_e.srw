$PBExportHeader$w_92004_e.srw
$PBExportComments$상표권 출원등록
forward
global type w_92004_e from w_com020_e
end type
end forward

global type w_92004_e from w_com020_e
integer width = 3625
integer height = 2232
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
windowstate windowstate = maximized!
end type
global w_92004_e w_92004_e

type variables
string is_trademark, is_item_grp, is_country_cd, is_apply_no, is_regist_no, is_old_new

datawindowchild  idw_country_cd, idw_office_cd, idw_state, idw_item_grp, idw_trademark
end variables

on w_92004_e.create
call super::create
end on

on w_92004_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_apply_no, is_regist_no, is_trademark, is_country_cd, is_item_grp, is_old_new)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

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

is_trademark  = dw_head.GetItemString(1, "trademark")
is_item_grp   = dw_head.GetItemString(1, "item_grp")
is_country_cd = dw_head.GetItemString(1, "country_cd")
is_apply_no   = dw_head.GetItemString(1, "apply_no")
is_regist_no  = dw_head.GetItemString(1, "regist_no")


return true

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

event open;call super::open;if isnull(gsv_cd.gs_cd10) or  gsv_cd.gs_cd10 = '' then
else
	dw_head.setitem(1,"apply_no",gsv_cd.gs_cd10)
	trigger event ue_retrieve()
	dw_body.retrieve(gsv_cd.gs_cd10)
end if


end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;///*===========================================================================*/
///* 작성자      : 지우정보                                                    */	
///* 작성일      : 2001..                                                  */	
///* 수정일      : 2001..                                                  */
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
//   CASE 2   /* 추가 */
//      if al_rows > 0 then
//			cb_delete.enabled = true
//			cb_print.enabled = false
//			cb_preview.enabled = false
//			cb_excel.enabled = false
//			if dw_head.Enabled then
//				cb_retrieve.Text = "조건(&Q)"
//				dw_head.Enabled = false
//				dw_list.Enabled = true
//				dw_body.Enabled = true
//			end if
//		end if
//
//	CASE 3		/* 저장 */
//		if al_rows = 1 then
//			ib_changed = false
//			cb_print.enabled = true
//			cb_preview.enabled = true
//			cb_excel.enabled = true
//		end if
//
//	CASE 4		/* 삭제 */
//		if al_rows = 1 then
//			if dw_body.RowCount() = 0 then
//            cb_delete.enabled = false
//			end if
//         if idw_status <> new! and idw_status <> newmodified! then
//            ib_changed = true
//            cb_update.enabled = true
//			end if
//         cb_print.enabled = false
//         cb_preview.enabled = false
//         cb_excel.enabled = false
//		end if
//
//   CASE 5    /* 조건 */
//      cb_retrieve.Text = "조회(&Q)"
////      cb_insert.enabled = false
//      cb_delete.enabled = false
//      cb_print.enabled = false
//      cb_preview.enabled = false
//      cb_excel.enabled = false
//      cb_update.enabled = false
//      ib_changed = false
//      dw_list.Enabled = false
//      dw_body.Enabled = false
//      dw_head.Enabled = true
//      dw_head.SetFocus()
//      dw_head.SetColumn(1)
//
//   CASE 7  /* dw_list clicked 조회 */
//      if al_rows > 0 then
//         cb_delete.enabled = true
//         cb_print.enabled = true
//         cb_preview.enabled = true
//         cb_excel.enabled = true
//		else
//         cb_delete.enabled = false
//         cb_print.enabled = false
//         cb_preview.enabled = false
//         cb_excel.enabled = false
//		end if
//
//      if al_rows >= 0 then
//         ib_changed = false
//         cb_update.enabled = false
//         cb_insert.enabled = true
//      end if
//END CHOOSE
//
end event

type cb_close from w_com020_e`cb_close within w_92004_e
end type

type cb_delete from w_com020_e`cb_delete within w_92004_e
end type

type cb_insert from w_com020_e`cb_insert within w_92004_e
boolean enabled = true
end type

event cb_insert::clicked;///*===========================================================================*/
///* 작성자      : 지우정보      															  */	
///*===========================================================================*/
//if dw_body.rowcount() = 0 then 
//	Parent.Trigger Event ue_insert()
//end if


IF dw_head.Enabled THEN
ELSE
	Parent.Trigger Event ue_head()	//조건
END IF
dw_body.reset()
Parent.Trigger Event ue_insert()


end event

type cb_retrieve from w_com020_e`cb_retrieve within w_92004_e
end type

type cb_update from w_com020_e`cb_update within w_92004_e
end type

type cb_print from w_com020_e`cb_print within w_92004_e
end type

type cb_preview from w_com020_e`cb_preview within w_92004_e
end type

type gb_button from w_com020_e`gb_button within w_92004_e
end type

type cb_excel from w_com020_e`cb_excel within w_92004_e
end type

type dw_head from w_com020_e`dw_head within w_92004_e
integer width = 4357
integer height = 152
string dataobject = "d_92004_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve()

idw_country_cd.insertrow(1)
idw_country_cd.setitem(1,"inter_cd","%")
idw_country_cd.setitem(1,"inter_nm","전체")


This.GetChild("item_grp", idw_item_grp)
idw_item_grp.SetTransObject(SQLCA)
idw_item_grp.Retrieve('0')
idw_item_grp.insertrow(1)
idw_item_grp.setitem(1,"item","%")


This.GetChild("trademark", idw_trademark)
idw_trademark.SetTransObject(SQLCA)
idw_trademark.Retrieve('00','01')
idw_trademark.insertrow(1)
idw_trademark.setitem(1,"trademark","")
end event

type ln_1 from w_com020_e`ln_1 within w_92004_e
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com020_e`ln_2 within w_92004_e
integer beginy = 328
integer endy = 328
end type

type dw_list from w_com020_e`dw_list within w_92004_e
integer y = 348
integer width = 677
integer height = 1688
string dataobject = "d_92004_l01"
end type

event dw_list::clicked;call super::clicked;///*===========================================================================*/
///* 작성자      :                                                       */	
///* 작성일      : 2001..                                                  */	
///* 수정일      : 2001..                                                  */
///*===========================================================================*/
//
//IF row <= 0 THEN Return
//
//IF ib_changed THEN 
//  	CHOOSE CASE gf_update_yn(Parent.title)
//		CASE 1
//			IF Parent.Trigger Event ue_update() < 1 THEN
//				RETURN 1
//			END IF		
//		CASE 3
//			RETURN 1
//	END CHOOSE
//END IF
//	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)
//
//is_apply_no = dw_list.GetItemString(row, "apply_no")
//
//il_rows = dw_body.retrieve(is_apply_no)
//Parent.Trigger Event ue_button(7, il_rows)
//Parent.Trigger Event ue_msg(1, il_rows)
end event

event dw_list::constructor;//
end event

event dw_list::doubleclicked;call super::doubleclicked;/*===========================================================================*/
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

is_apply_no = dw_list.GetItemString(row, "apply_no")

il_rows = dw_body.retrieve(is_apply_no)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_92004_e
integer x = 722
integer y = 348
integer width = 2885
integer height = 1688
string dataobject = "d_92004_d01"
end type

event dw_body::constructor;call super::constructor;This.GetChild("re_office_cd", idw_office_cd)
idw_office_cd.SetTransObject(SQLCA)
idw_office_cd.Retrieve('995')


This.GetChild("office_cd", idw_office_cd)
idw_office_cd.SetTransObject(SQLCA)
idw_office_cd.Retrieve('995')



This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')


This.GetChild("state", idw_state)
idw_state.SetTransObject(SQLCA)
idw_state.Retrieve('00','01')
//idw_state.SetItem(1, "inter_cd", '')
//idw_state.SetItem(1, "inter_nm", '')


end event

event dw_body::getfocus;call super::getfocus;string ls_country_cd, ls_office_cd
ls_country_cd = this.getitemstring(1,"country_cd")
ls_office_cd  = this.getitemstring(1,"office_cd")

idw_state.Retrieve(ls_country_cd, ls_office_cd)
end event

type st_1 from w_com020_e`st_1 within w_92004_e
integer x = 704
integer y = 352
integer height = 1688
end type

type dw_print from w_com020_e`dw_print within w_92004_e
integer x = 119
integer y = 672
string dataobject = "d_92004_r01"
end type

event dw_print::constructor;call super::constructor;This.GetChild("re_office_cd", idw_office_cd)
idw_office_cd.SetTransObject(SQLCA)
idw_office_cd.Retrieve('995')


This.GetChild("office_cd", idw_office_cd)
idw_office_cd.SetTransObject(SQLCA)
idw_office_cd.Retrieve('995')


This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')



This.GetChild("state", idw_state)
idw_state.SetTransObject(SQLCA)
idw_state.Retrieve('00','01')
idw_state.SetItem(1, "inter_cd", '')
idw_state.SetItem(1, "inter_nm", '')


end event

