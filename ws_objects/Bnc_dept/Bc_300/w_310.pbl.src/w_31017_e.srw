$PBExportHeader$w_31017_e.srw
$PBExportComments$중간검사결과보고서
forward
global type w_31017_e from w_com010_e
end type
type dw_1 from datawindow within w_31017_e
end type
type dw_2 from datawindow within w_31017_e
end type
end forward

global type w_31017_e from w_com010_e
integer height = 2260
dw_1 dw_1
dw_2 dw_2
end type
global w_31017_e w_31017_e

type variables
string is_yymmdd, is_style, is_chno

end variables

on w_31017_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
end on

on w_31017_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if
is_style = dw_head.GetItemString(1, "style")
is_chno  = dw_head.GetItemString(1, "chno" )



if gs_brand = 'N' and (MidA(is_style,1,1) = 'O' or MidA(is_style,1,1) = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false
elseif gs_brand = 'O' and (MidA(is_style,1,1) = 'N' or MidA(is_style,1,1) = 'B' or MidA(is_style,1,1) = 'L' or MidA(is_style,1,1) = 'F' or MidA(is_style,1,1) = 'G'  or MidA(is_style,1,1) = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false	
elseif gs_brand = 'B' and (MidA(is_style,1,1) = 'O' or MidA(is_style,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false		
elseif gs_brand = 'G' and (MidA(is_style,1,1) = 'O' or MidA(is_style,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false			
end if	


return true

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

il_rows = dw_body.retrieve(is_yymmdd, is_style, is_chno)
IF il_rows > 0 THEN
	for i = 1 to il_rows 
		ls_flag = dw_body.getitemstring(i,"flag")
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
		dw_1.visible = true		
	end if
	
	il_rows = dw_2.retrieve(is_yymmdd, is_style, is_chno)
	if il_rows > 0 then 
		for i = 1 to il_rows 
			ls_flag = dw_2.getitemstring(i,"flag")
			if ls_flag = "New" then 
				dw_2.SetItemStatus(i, 0, Primary!, NewModified!)
			end if
		next 		
		dw_2.visible = true		
	end if
		
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

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
///////////////////////////////////////////////////

/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 		   									  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(dw_2, "ScaleToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)

////////////////////////////////////////////////


end event

event open;call super::open;
dw_body.insertrow(1)
dw_1.insertrow(1)
dw_2.insertrow(1)


dw_1.object.chk_gram_fin.visible = false
dw_1.object.t_2.visible = false

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
	
	FOR i=1 TO ll_row_count
		idw_status = dw_2.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record */
			dw_2.Setitem(i, "reg_id", gs_user_id)
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
			dw_2.Setitem(i, "mod_id", gs_user_id)
			dw_2.Setitem(i, "mod_dt", ld_datetime)
		END IF
	NEXT
	il_rows = dw_2.Update(TRUE, FALSE)	

	
   dw_body.ResetUpdate()
	dw_1.ResetUpdate()
	dw_2.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

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
				
			if gs_brand <> "K" then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where =  " style LIKE ~'" + as_data + "%~' "
				ELSE
					gst_cd.Item_where = ""
				END IF
			else 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where =  " style LIKE ~'" + as_data + "%~'  and style like 'K%' "
				ELSE
					gst_cd.Item_where = "style like 'K%'"
				END IF
				
			end if					
				
//				IF Trim(as_data) <> "" THEN
//					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
//				ELSE
//					gst_cd.Item_where = ""
//				END IF
//
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
//			gst_cd.default_where   = " WHERE DEPT_CODE in ('s200','d000','d300','T210') " + &
//			gst_cd.default_where   = " WHERE Dbo.Sf_Dept_Nm(Dept_Code) like '%생산%' " + &
//			                         "   AND GOOUT_GUBN = '1' "
			gst_cd.default_where   = " WHERE GOOUT_GUBN = '1' "

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (EMPNO LIKE '" + as_data + "%' or kname like '%" + as_data + "%') "
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

il_rows = dw_print.retrieve(is_yymmdd, is_style, is_chno)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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

for i = dw_2.rowcount() to 1 STEP -1
	dw_2.DeleteRow(i)
next 

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
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_1.Enabled = true
			dw_2.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
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
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
	         dw_1.Enabled = true
				dw_2.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
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
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
		dw_1.Enabled = false
		dw_2.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

type cb_close from w_com010_e`cb_close within w_31017_e
end type

type cb_delete from w_com010_e`cb_delete within w_31017_e
end type

type cb_insert from w_com010_e`cb_insert within w_31017_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_31017_e
end type

type cb_update from w_com010_e`cb_update within w_31017_e
end type

type cb_print from w_com010_e`cb_print within w_31017_e
end type

type cb_preview from w_com010_e`cb_preview within w_31017_e
end type

type gb_button from w_com010_e`gb_button within w_31017_e
end type

type cb_excel from w_com010_e`cb_excel within w_31017_e
end type

type dw_head from w_com010_e`dw_head within w_31017_e
integer height = 164
string dataobject = "d_31017_h01"
end type

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_31017_e
integer beginy = 356
integer endy = 356
end type

type ln_2 from w_com010_e`ln_2 within w_31017_e
integer beginy = 360
integer endy = 360
end type

type dw_body from w_com010_e`dw_body within w_31017_e
integer y = 380
integer height = 1128
boolean enabled = false
string dataobject = "d_31017_d01"
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		if ls_column_name <> 'remark' then
			Send(Handle(This), 256, 9, long(0,0))
		end if
		Return 1
//	CASE KeyDownArrow!
//		IF This.GetRow() = This.RowCount() THEN
//		   This.InsertRow(This.GetRow() + 1)
//		END IF
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
//
CHOOSE CASE dwo.name
	CASE "empno"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1		
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_31017_e
string dataobject = "d_31017_r00"
end type

type dw_1 from datawindow within w_31017_e
integer x = 2034
integer y = 984
integer width = 1143
integer height = 444
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_31017_d03"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event constructor;datawindowchild ldw_child

This.GetChild("color", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()
end event

type dw_2 from datawindow within w_31017_e
integer x = 5
integer y = 1516
integer width = 3589
integer height = 520
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_31017_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;datawindowchild ldw_child

This.GetChild("chk_cd_0", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_2", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_3", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_4", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_5", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_6", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_7", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_8", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_9", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_a", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_b", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_c", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')



end event

