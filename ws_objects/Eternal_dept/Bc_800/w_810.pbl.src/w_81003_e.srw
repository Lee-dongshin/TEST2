$PBExportHeader$w_81003_e.srw
$PBExportComments$자기개발계획서
forward
global type w_81003_e from w_com010_e
end type
type dw_edu from datawindow within w_81003_e
end type
type dw_lan from datawindow within w_81003_e
end type
type tab_1 from tab within w_81003_e
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tab_1 from tab within w_81003_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type dw_etc from datawindow within w_81003_e
end type
end forward

global type w_81003_e from w_com010_e
integer height = 2244
dw_edu dw_edu
dw_lan dw_lan
tab_1 tab_1
dw_etc dw_etc
end type
global w_81003_e w_81003_e

type variables
string is_yyyy, is_empno, is_first_staff, is_second_staff, is_head_dept, is_dept_code
datawindowchild idw_first, idw_second, idw_yyyy

end variables

on w_81003_e.create
int iCurrent
call super::create
this.dw_edu=create dw_edu
this.dw_lan=create dw_lan
this.tab_1=create tab_1
this.dw_etc=create dw_etc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_edu
this.Control[iCurrent+2]=this.dw_lan
this.Control[iCurrent+3]=this.tab_1
this.Control[iCurrent+4]=this.dw_etc
end on

on w_81003_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_edu)
destroy(this.dw_lan)
destroy(this.tab_1)
destroy(this.dw_etc)
end on

event open;call super::open;//string is_yyyy, is_empno, is_jikgub, is_head_dept, is_first_staff, is_second_staff

string is_first_staff_nm, is_second_staff_nm

dw_head.setitem(1,"empno",gs_user_id)
dw_head.setitem(1,"kname",gs_user_nm)
Trigger Event ue_Popup("empno", 1, gs_user_id, 1)

is_yyyy = dw_head.getitemstring(1,"yyyy")


select first_staff,  second_staff, dbo.sf_emp_nm(first_staff)  as first_staff_nm, dbo.sf_emp_nm(second_staff) as second_staff_nm 
	into :is_first_staff, :is_second_staff, :is_first_staff_nm, :is_second_staff_nm
from tb_81001_m (nolock)
where yyyy = :is_yyyy 
and   empno = :gs_user_id;

dw_head.setitem(1,"first_staff",is_first_staff)
dw_head.setitem(1,"second_staff",is_second_staff)

dw_head.setitem(1,"first_staff_nm",is_first_staff_nm)
dw_head.setitem(1,"second_staff_nm",is_second_staff_nm)

end event

event ue_keycheck;/*===========================================================================*/
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

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

is_empno = dw_head.GetItemString(1, "empno")
if IsNull(is_empno) or Trim(is_empno) = "" then
   MessageBox(ls_title,"사번을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("empno")
   return false
end if

is_first_staff  = dw_head.GetItemString(1, "first_staff")
if IsNull(is_first_staff) or Trim(is_first_staff) = "" then
   MessageBox(ls_title,"1차상사를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("first_staff")
   return false
end if

is_second_staff = dw_head.GetItemString(1, "second_staff")
if IsNull(is_second_staff) or Trim(is_second_staff) = "" then
   MessageBox(ls_title,"2차상사를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("second_staff")
   return false
end if


return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
string ls_flag
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yyyy, is_empno, is_first_staff, is_second_staff)
il_rows = dw_edu.retrieve(is_yyyy, is_empno)
il_rows = dw_lan.retrieve(is_yyyy, is_empno)
il_rows = dw_etc.retrieve(is_yyyy, is_empno)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm , ls_yyyy, ls_empno, ls_allot, ls_grade
Boolean    lb_check 
DataStore  lds_Source
long  li_score

CHOOSE CASE as_column
			
	CASE "empno"						
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data)  = "" THEN
				   dw_head.SetItem(al_row, "kname", "")
					RETURN 0
				END IF 
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 

//			If gf_get_inter_sub('991', gs_brand + '50', '1', ls_dept_cd) = False Then
//				dw_head.SetItem(al_row, "empno", "")
//				dw_head.SetItem(al_row, "kname", "")
//				Return 2
//			END IF 
			gst_cd.default_where   = " WHERE GOOUT_GUBN = '1' "

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(EMPNO LIKE '" + as_data + "%' or kname LIKE '" + as_data + "%') "
				
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
				dw_head.SetItem(al_row, "empno", lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "kname", lds_Source.GetItemString(1,"kname"))

				is_dept_code = lds_Source.GetItemString(1,"dept_code")
				
				select grp_cd1 into :is_head_dept from mis.dbo.thb02 where dept_code = :is_dept_code;
				
				idw_first.Retrieve(lds_Source.GetItemString(1,"empno"))
				idw_first.InsertRow(0)
				
				idw_second.Retrieve(lds_Source.GetItemString(1,"empno"))
				idw_second.InsertRow(0)
				
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
//				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source	
			
		case "my_grade"
			lS_allot = dw_body.getitemstring(al_row,"allot")
			select score into :li_score from tb_81000_c (nolock) where allot = :ls_allot and grade = :as_data;				
			dw_body.setitem(al_row,"my_point",li_score)		

		case "first_grade"
			lS_allot = dw_body.getitemstring(al_row,"allot")
			select score into :li_score from tb_81000_c (nolock) where allot = :ls_allot and grade = :as_data;				
			dw_body.setitem(al_row,"first_grade",li_score)		

		case "second_grade"
			lS_allot = dw_body.getitemstring(al_row,"allot")
			select score into :li_score from tb_81000_c (nolock) where allot = :ls_allot and grade = :as_data;				
			dw_body.setitem(al_row,"second_point",li_score)		

		case "allot"
			ls_grade = dw_body.getitemstring(al_row,"my_grade")
			select score into :li_score from tb_81000_c (nolock) where allot = :as_data and grade = :ls_grade;				
			dw_body.setitem(al_row,"my_point",li_score)	
			
			ls_grade = dw_body.getitemstring(al_row,"first_grade")
			select score into :li_score from tb_81000_c (nolock) where allot = :as_data and grade = :ls_grade;				
			dw_body.setitem(al_row,"first_point",li_score)	
		
			ls_grade = dw_body.getitemstring(al_row,"second_grade")
			select score into :li_score from tb_81000_c (nolock) where allot = :as_data and grade = :ls_grade;				
			dw_body.setitem(al_row,"second_point",li_score)	
		
			
			
			
END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(dw_edu, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_lan, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_etc, "ScaleToRight&Bottom")

dw_edu.SetTransObject(SQLCA)
dw_lan.SetTransObject(SQLCA)
dw_etc.SetTransObject(SQLCA)



end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
string ls_jikgub, ls_dept_code, ls_head_dept

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF




////////////
	select  jikguk, 
		dept_code,
		(select grp_cd1 from mis.dbo.thb02 (nolock) where dept_code = a.dept_code) as head_dept
		into :ls_jikgub, :ls_dept_code, :ls_head_dept
	from mis.dbo.thb01 a(nolock) where empno = :is_empno;
////////////	
	

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_edu.AcceptText() <> 1 THEN RETURN -1
IF dw_lan.AcceptText() <> 1 THEN RETURN -1
IF dw_etc.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

////////doby
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "yyyy", is_yyyy)
      dw_body.Setitem(i, "empno", is_empno)
      dw_body.Setitem(i, "first_staff", is_first_staff)
      dw_body.Setitem(i, "second_staff", is_second_staff)
		dw_body.Setitem(i, "jikgub", ls_jikgub)
		dw_body.Setitem(i, "dept_code", ls_dept_code)
		dw_body.Setitem(i, "head_dept", ls_head_dept)
	
	   dw_body.Setitem(i, "reg_id", gs_user_id)
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

///////edu
FOR i=1 TO ll_row_count
   idw_status = dw_edu.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
	   dw_edu.Setitem(i, "yyyy", is_yyyy)
	   dw_edu.Setitem(i, "empno", is_empno)	
	   dw_edu.Setitem(i, "head_dept", is_head_dept)
	   dw_edu.Setitem(i, "dept_code", is_dept_code)
		
	   dw_edu.Setitem(i, "reg_id", gs_user_id)
      dw_edu.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_edu.Setitem(i, "mod_id", gs_user_id)
      dw_edu.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT
il_rows = dw_edu.Update(TRUE, FALSE)


///////lan
FOR i=1 TO ll_row_count
   idw_status = dw_lan.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
	   dw_lan.Setitem(i, "yyyy", is_yyyy)
	   dw_lan.Setitem(i, "empno", is_empno)	
	   dw_lan.Setitem(i, "head_dept", is_head_dept)
	   dw_lan.Setitem(i, "dept_code", is_dept_code)
		
	   dw_lan.Setitem(i, "reg_id", gs_user_id)
      dw_lan.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_lan.Setitem(i, "mod_id", gs_user_id)
      dw_lan.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT
il_rows = dw_lan.Update(TRUE, FALSE)


///////etc
FOR i=1 TO ll_row_count
   idw_status = dw_etc.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
	   dw_etc.Setitem(i, "yyyy", is_yyyy)
	   dw_etc.Setitem(i, "empno", is_empno)	
	   dw_etc.Setitem(i, "head_dept", is_head_dept)
	   dw_etc.Setitem(i, "dept_code", is_dept_code)
		dw_etc.Setitem(i, "higher_staff", is_second_staff)
		
	   dw_etc.Setitem(i, "reg_id", gs_user_id)
      dw_etc.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_etc.Setitem(i, "mod_id", gs_user_id)
      dw_etc.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT
il_rows = dw_etc.Update(TRUE, FALSE)

/////////////
if 1 = 1 then
   dw_body.ResetUpdate()
   dw_edu.ResetUpdate()
   dw_lan.ResetUpdate()
   dw_etc.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
choose case tab_1.SelectedTab	
	case 1
			if dw_body.AcceptText() <> 1 then return
			
			/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
			IF dw_head.Enabled THEN
				IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
				dw_body.Reset()
			END IF
			
			il_rows = dw_body.InsertRow(0)
			
			/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
			if il_rows > 0 then
				dw_body.ScrollToRow(il_rows)
				dw_body.SetColumn(ii_min_column_id)
				dw_body.SetFocus()
			end if
	case 2
			if dw_edu.AcceptText() <> 1 then return
			
			/* dw_edu 필수입력 column check ==> 조건을 누른후 추가시 */
			IF dw_head.Enabled THEN
				IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
				dw_edu.Reset()
			END IF
			
			il_rows = dw_edu.InsertRow(0)
			
			/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
			if il_rows > 0 then
				dw_edu.ScrollToRow(il_rows)
				dw_edu.SetColumn(ii_min_column_id)
				dw_edu.SetFocus()
			end if
	case 3
			if dw_lan.AcceptText() <> 1 then return
			
			/* dw_lan 필수입력 column check ==> 조건을 누른후 추가시 */
			IF dw_head.Enabled THEN
				IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
				dw_lan.Reset()
			END IF
			
			il_rows = dw_lan.InsertRow(0)
			
			/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
			if il_rows > 0 then
				dw_lan.ScrollToRow(il_rows)
				dw_lan.SetColumn(ii_min_column_id)
				dw_lan.SetFocus()
			end if
	case 4
			if dw_etc.AcceptText() <> 1 then return
			
			/* dw_lan 필수입력 column check ==> 조건을 누른후 추가시 */
			IF dw_head.Enabled THEN
				IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
				dw_etc.Reset()
			END IF
			
			il_rows = dw_etc.InsertRow(0)
			
			/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
			if il_rows > 0 then
				dw_etc.ScrollToRow(il_rows)
				dw_etc.SetColumn(ii_min_column_id)
				dw_etc.SetFocus()
			end if
end choose

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_delete;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row

choose case tab_1.SelectedTab	
	case 1
			ll_cur_row = dw_body.GetRow()			
			if ll_cur_row <= 0 then return			
			idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)				
			il_rows = dw_body.DeleteRow (ll_cur_row)
			dw_body.SetFocus()

	case 2
			ll_cur_row = dw_edu.GetRow()			
			if ll_cur_row <= 0 then return			
			idw_status = dw_edu.GetItemStatus (ll_cur_row, 0, primary!)				
			il_rows = dw_edu.DeleteRow (ll_cur_row)
			dw_edu.SetFocus()

	case 3
			ll_cur_row = dw_lan.GetRow()			
			if ll_cur_row <= 0 then return			
			idw_status = dw_lan.GetItemStatus (ll_cur_row, 0, primary!)				
			il_rows = dw_lan.DeleteRow (ll_cur_row)
			dw_lan.SetFocus()

	case 4
			ll_cur_row = dw_etc.GetRow()			
			if ll_cur_row <= 0 then return			
			idw_status = dw_etc.GetItemStatus (ll_cur_row, 0, primary!)				
			il_rows = dw_etc.DeleteRow (ll_cur_row)
			dw_etc.SetFocus()
			
	end choose

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

//This.Trigger Event ue_title ()

//dw_body.ShareData(dw_print)
dw_print.retrieve(is_yyyy, is_empno)
dw_print.inv_printpreview.of_SetZoom()

end event

type cb_close from w_com010_e`cb_close within w_81003_e
end type

type cb_delete from w_com010_e`cb_delete within w_81003_e
end type

type cb_insert from w_com010_e`cb_insert within w_81003_e
boolean visible = false
end type

event cb_insert::clicked;call super::clicked;//choose case oldindex
//	case 1
//		dw_body.visible = false
//	case 2
//		dw_edu.visible = false
//	case 3
//		dw_lan.visible = false
//	case 4
//		dw_etc.visible = false
//end choose
end event

type cb_retrieve from w_com010_e`cb_retrieve within w_81003_e
end type

type cb_update from w_com010_e`cb_update within w_81003_e
end type

type cb_print from w_com010_e`cb_print within w_81003_e
end type

type cb_preview from w_com010_e`cb_preview within w_81003_e
end type

type gb_button from w_com010_e`gb_button within w_81003_e
end type

type cb_excel from w_com010_e`cb_excel within w_81003_e
end type

type dw_head from w_com010_e`dw_head within w_81003_e
integer y = 160
integer height = 168
string dataobject = "d_81003_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
//
int li_ret
string ls_brand, ls_year, ls_season

CHOOSE CASE dwo.name

	CASE "empno"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
//
end event

event dw_head::constructor;call super::constructor;
This.GetChild("first_staff", idw_first)
idw_first.SetTransObject(SQLCA)
idw_first.Retrieve('')
idw_first.InsertRow(1)

This.GetChild("second_staff", idw_second)
idw_second.SetTransObject(SQLCA)
idw_second.Retrieve('')
idw_second.InsertRow(1)
end event

type ln_1 from w_com010_e`ln_1 within w_81003_e
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_e`ln_2 within w_81003_e
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_e`dw_body within w_81003_e
integer y = 444
integer height = 1580
string dataobject = "d_81003_d01"
end type

event dw_body::constructor;call super::constructor;datawindowchild idw_child

This.GetChild("value_code", idw_child)
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve('801')

This.GetChild("sub_code", idw_child)
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve('802')

This.GetChild("allot", idw_child)
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve()
end event

event dw_body::ue_keydown;//
end event

event dw_body::editchanged;call super::editchanged;///*===========================================================================*/
//int li_allot, li_score
//li_allot = this.getitemdecimal(row,"allot")
//messagebox('li_allot','aaaaaaaaaaa')
////select score into :li_score from tb_81000_c (nolock) where allot = :li_allot and grade = :data;				
//CHOOSE CASE dwo.name
//	CASE "my_grade" 
//		this.setitem(row,"my_point",li_score)		
//	CASE "first_grade" 
//		this.setitem(row,"first_point",li_score)		
//	CASE "second_grade" 
//		this.setitem(row,"second_point",li_score)		
//		
//END CHOOSE

end event

event dw_body::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "my_grade","first_grade","second_grade","allot"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		IF dw_body.AcceptText() <> 1 THEN RETURN 1
		return Parent.trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

type dw_print from w_com010_e`dw_print within w_81003_e
string dataobject = "d_81003_r00"
end type

type dw_edu from datawindow within w_81003_e
boolean visible = false
integer x = 5
integer y = 444
integer width = 3589
integer height = 1580
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_81003_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;
This.GetChild("yyyy", idw_yyyy)
idw_yyyy.SetTransObject(SQLCA)
idw_yyyy.Retrieve('002')
idw_yyyy.InsertRow(1)
end event

event itemchanged;/*===========================================================================*/
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

type dw_lan from datawindow within w_81003_e
boolean visible = false
integer x = 5
integer y = 444
integer width = 3589
integer height = 1580
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_81003_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;/*===========================================================================*/
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

type tab_1 from tab within w_81003_e
integer x = 5
integer y = 352
integer width = 2112
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

event selectionchanged;choose case oldindex
	case 1
		dw_body.visible = false
	case 2
		dw_edu.visible = false
	case 3
		dw_lan.visible = false
	case 4
		dw_etc.visible = false
end choose


choose case newindex
	case 1
		dw_body.visible = true
	case 2
		dw_edu.visible = true
	case 3
		dw_lan.visible = true
	case 4
		dw_etc.visible = true
end choose

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2075
integer height = -12
long backcolor = 79741120
string text = "자기개발계획표"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2075
integer height = -12
long backcolor = 79741120
string text = "년간교육이수"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2075
integer height = -12
long backcolor = 79741120
string text = "외국어능력평가"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2075
integer height = -12
long backcolor = 79741120
string text = "직무변경요청 및 기타협조사항"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type dw_etc from datawindow within w_81003_e
boolean visible = false
integer x = 5
integer y = 444
integer width = 3589
integer height = 1580
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_81003_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;/*===========================================================================*/
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

event editchanged;ib_changed = true
cb_update.enabled = true
end event

