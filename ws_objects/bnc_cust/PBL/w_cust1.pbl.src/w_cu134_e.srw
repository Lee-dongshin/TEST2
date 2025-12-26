$PBExportHeader$w_cu134_e.srw
$PBExportComments$검사결과보고서
forward
global type w_cu134_e from w_com010_e
end type
type dw_1 from datawindow within w_cu134_e
end type
end forward

global type w_cu134_e from w_com010_e
integer width = 3653
integer height = 2236
dw_1 dw_1
end type
global w_cu134_e w_cu134_e

type variables
string is_yymmdd, is_style, is_chno
end variables

on w_cu134_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_cu134_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_flag
long i
if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

il_rows = dw_body.retrieve(is_yymmdd, is_style, is_chno, 'New')
IF il_rows > 0 THEN
	for i = 1 to il_rows
		ls_flag = dw_body.getitemstring(1,"flag")
		if ls_flag = "New" then
			dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
		end if
	next
	il_rows = dw_1.retrieve(is_yymmdd, is_style, is_chno)
	if il_rows > 0 then 
		for i = 1 to il_rows 
			ls_flag = dw_1.getitemstring(i,"flag")
			if ls_flag = "New" then 
			dw_1.SetItemStatus(i, 0, Primary!, NewModified!)
			end if
		next
	end if
   dw_body.SetFocus()
END IF

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)


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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
//if IsNull(is_brand) or Trim(is_brand) = "" then
//   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//end if

is_style = dw_head.GetItemString(1, "style")
is_chno = dw_head.GetItemString(1, "chno")
return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_dept_cd
Boolean    lb_check 
DataStore  lds_Source
CHOOSE CASE as_column
	CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = " WHERE 1 = 1 "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
				ELSE
					gst_cd.Item_where = ""
				END IF

				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm

					dw_head.SetRow(al_row)
					dw_head.SetColumn(as_column)
            				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
			
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("chno")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
	CASE "empno"				
		ls_brand = LeftA(is_style,1)
		
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data)  = "" THEN
				   dw_body.SetItem(al_row, "emp_nm", "")
					RETURN 0
				END IF 
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "검사원 사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 

//			If gf_get_inter_sub('991', ls_brand + '50', '1', ls_dept_cd) = False Then
//				dw_body.SetItem(al_row, "empno", "")
//				dw_body.SetItem(al_row, "emp_nm", "")
//				Return 2
//			END IF 
			gst_cd.default_where   = " WHERE brand = '" + ls_brand + "' and DEPT_CODE in ('s200','d000','d300','T210') " + &
			                         "   AND GOOUT_GUBN = '1' "

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "EMPNO LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "empno", lds_Source.GetItemString(1,"empno"))
				dw_body.SetItem(al_row, "emp_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
				dw_body.SetColumn("remark")
				ib_itemchanged = False 
				lb_check = TRUE 
				
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source				
end choose

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

il_rows = dw_print.retrieve(is_yymmdd, is_style, is_chno, 'Dat', gs_shop_cd)
dw_print.inv_printpreview.of_SetZoom()


end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_flag
long i
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymmdd, is_style, is_chno, 'Dat', gs_shop_cd)
dw_1.reset()
IF il_rows > 0 THEN
	for i = 1 to il_rows
		ls_flag = dw_body.getitemstring(1,"flag")
		if ls_flag = "New" then
			dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
		end if
	next
	il_rows = dw_1.retrieve(is_yymmdd, is_style, is_chno)
	if il_rows > 0 then 
		for i = 1 to il_rows 
			ls_flag = dw_1.getitemstring(i,"flag")
			if ls_flag = "New" then 
				dw_1.SetItemStatus(i, 0, Primary!, NewModified!)
			end if
		next 		

	end if
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
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
	
	FOR i=1 TO ll_row_count
		idw_status = dw_1.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record */
			dw_1.Setitem(i, "reg_id", gs_user_id)
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
			dw_1.Setitem(i, "mod_id", gs_user_id)
			dw_1.Setitem(i, "mod_dt", ld_datetime)
		END IF
	NEXT
	
	il_rows = dw_1.Update(TRUE, FALSE)	
	if il_rows = 1 then
		dw_1.ResetUpdate()
		dw_body.ResetUpdate()
		commit  USING SQLCA;
	else
		rollback  USING SQLCA;
	end if
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long	i,	ll_cur_row

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_body.DeleteRow (ll_cur_row)
for i = dw_1.rowcount() to 1 STEP -1
	dw_1.DeleteRow(i)
next 
dw_1.visible = false
dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
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
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
			dw_1.visible = true
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
			dw_1.visible = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
			end if
			dw_1.visible = true
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false

		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false

      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

type cb_close from w_com010_e`cb_close within w_cu134_e
end type

type cb_delete from w_com010_e`cb_delete within w_cu134_e
end type

type cb_insert from w_com010_e`cb_insert within w_cu134_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_cu134_e
end type

type cb_update from w_com010_e`cb_update within w_cu134_e
end type

type cb_print from w_com010_e`cb_print within w_cu134_e
end type

type cb_preview from w_com010_e`cb_preview within w_cu134_e
end type

type gb_button from w_com010_e`gb_button within w_cu134_e
integer width = 3602
end type

type dw_head from w_com010_e`dw_head within w_cu134_e
integer y = 164
integer width = 3602
integer height = 124
string dataobject = "d_31018_h01"
end type

event dw_head::itemchanged;//////////////////////////////////////////////////////////////////////////////
//	Event:			itemchanged
//	Description:	Send itemchanged notification to services
//////////////////////////////////////////////////////////////////////////////
//	Rev. History	Version
//						6.0   Initial version
// 					7.0	Linkage service should not fire events when querymode is enabled
//////////////////////////////////////////////////////////////////////////////
//	Copyright ?1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
boolean lb_disablelinkage
integer li_rc

// Is Querymode enabled?
If IsValid(inv_QueryMode) then lb_disablelinkage = inv_QueryMode.of_GetEnabled()

if not lb_disablelinkage then
	if IsValid (inv_Linkage) then
		//	*Note: If the changed value needs to be validated.  Validation needs to 
		//		occur prior to this linkage.pfc_itemchanged event.  If key syncronization is 
		//		performed, then the changed value cannot be undone. (i.e. return codes)	
		li_rc = inv_Linkage.event pfc_itemchanged (row, dwo, data)
	end if
end if
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

int li_ret
string ls_brand, ls_year, ls_season

CHOOSE CASE dwo.name
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_cu134_e
integer beginy = 288
integer endx = 3602
integer endy = 288
end type

type ln_2 from w_com010_e`ln_2 within w_cu134_e
integer beginy = 292
integer endx = 3602
integer endy = 292
end type

type dw_body from w_com010_e`dw_body within w_cu134_e
integer y = 312
integer width = 3602
integer height = 1732
string dataobject = "d_31018_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;datawindowchild	ldw_make_type

This.GetChild("make_type", ldw_make_type)
ldw_make_type.SetTransObject(SQLCA)
ldw_make_type.Retrieve('030')
end event

event dw_body::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
	CASE "empno"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

type dw_print from w_com010_e`dw_print within w_cu134_e
string dataobject = "d_31018_r01"
end type

event dw_print::constructor;call super::constructor;datawindowchild	ldw_make_type

This.GetChild("make_type", ldw_make_type)
ldw_make_type.SetTransObject(SQLCA)
ldw_make_type.Retrieve('030')
end event

type dw_1 from datawindow within w_cu134_e
boolean visible = false
integer x = 2807
integer y = 1372
integer width = 869
integer height = 448
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_31017_d03"
boolean border = false
boolean livescroll = true
end type

