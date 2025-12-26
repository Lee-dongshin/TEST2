$PBExportHeader$w_81102_e.srw
$PBExportComments$인사평가등록(개인)
forward
global type w_81102_e from w_com010_e
end type
type dw_1 from datawindow within w_81102_e
end type
type dw_2 from datawindow within w_81102_e
end type
end forward

global type w_81102_e from w_com010_e
integer width = 3643
integer height = 2244
event ue_dw_2_resize ( )
dw_1 dw_1
dw_2 dw_2
end type
global w_81102_e w_81102_e

type variables
string is_yyyy, is_empno,is_gubun, is_jikgun_type, is_first_staff, is_second_staff
datawindowchild idw_first, idw_second, idw_jikgun_type
end variables

on w_81102_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
end on

on w_81102_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
end on

event open;call super::open;string is_first_staff_nm, is_second_staff_nm, dept_code_chk


dw_head.setitem(1,"empno",gs_user_id)
dw_head.setitem(1,"kname",gs_user_nm)
//Trigger Event ue_Popup("empno", 1, gs_user_id, 1)

is_yyyy = dw_head.getitemstring(1,"yyyy")

select jikgun_type, gubun, first_staff,  second_staff, dbo.sf_emp_nm(first_staff)  as first_staff_nm, dbo.sf_emp_nm(second_staff) as second_staff_nm, dept_code
	into :is_jikgun_type,:is_gubun, :is_first_staff, :is_second_staff, :is_first_staff_nm, :is_second_staff_nm, :dept_code_chk
from tb_81104_c (nolock)
where yyyy = :is_yyyy 
and   empno = :gs_user_id;



If dept_code_chk = 'O500' or dept_code_chk = 'N500' or dept_code_chk = 'N200' or dept_code_chk = 'N210' or dept_code_chk = 'O200' then
	dw_head.Object.empno.protect = 0
else
	dw_head.Object.empno.protect = 1
end if


dw_head.setitem(1,"jikgun_type",is_jikgun_type)
dw_head.setitem(1,"first_staff",is_first_staff)
dw_head.setitem(1,"second_staff",is_second_staff)

dw_head.setitem(1,"first_staff_nm",is_first_staff_nm)
dw_head.setitem(1,"second_staff_nm",is_second_staff_nm)


dw_1.insertrow(1)
dw_body.insertrow(1)
dw_2.insertrow(1)
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

is_jikgun_type = dw_head.GetItemString(1, "jikgun_type")
if IsNull(is_jikgun_type) or Trim(is_jikgun_type) = "" then
   MessageBox(ls_title,"직군을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jikgun_type")
   return false
end if

is_first_staff  = dw_head.GetItemString(1, "first_staff")
//if IsNull(is_first_staff) or Trim(is_first_staff) = "" then
//   MessageBox(ls_title,"1차상사를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("first_staff")
//   return false
//end if

is_second_staff = dw_head.GetItemString(1, "second_staff")
//if IsNull(is_second_staff) or Trim(is_second_staff) = "" then
//   MessageBox(ls_title,"2차상사를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("second_staff")
//   return false
//end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
string ls_flag
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if  is_gubun <> '평가대상' then
    messagebox('확인', '평가대상이 아닙니다 !!')
	 return 
end if

il_rows = dw_1.retrieve(is_yyyy, is_empno, is_jikgun_type, is_first_staff, is_second_staff)
IF il_rows > 0 THEN
	ls_flag = dw_1.getitemstring(1,"flag")
	if ls_flag = "New" then
		dw_1.SetItemStatus(1, 0, Primary!, NewModified!)
	end if
END IF


il_rows = dw_body.retrieve(is_yyyy, is_empno, is_jikgun_type)
IF il_rows > 0 THEN
	for i=1 to il_rows
		ls_flag = dw_body.getitemstring(i,"flag")
		if ls_flag = "New" then
		 	dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
		end if
	next 
   dw_body.SetFocus()
END IF


il_rows = dw_2.retrieve(is_yyyy, is_empno, is_jikgun_type, is_first_staff, is_second_staff)
//IF il_rows > 0 THEN
//	ls_flag = dw_2.getitemstring(1,"flag")
//	if ls_flag = "New" then
//		dw_2.SetItemStatus(1, 0, Primary!, New!)
//	end if
//END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm , ls_yyyy, ls_empno, ls_allot, ls_grade, ls_sql, ls_cf_step
string  ls_jikgun_type,ls_gubun, ls_first_staff, ls_second_staff, ls_first_staff_nm, ls_second_staff_nm

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
				ls_empno = lds_Source.GetItemString(1,"empno")

				select jikgun_type, gubun, first_staff,  second_staff, dbo.sf_emp_nm(first_staff)  as first_staff_nm, dbo.sf_emp_nm(second_staff) as second_staff_nm 
					into :ls_jikgun_type,:ls_gubun, :ls_first_staff, :ls_second_staff, :ls_first_staff_nm, :ls_second_staff_nm
				from tb_81104_c (nolock)
				where yyyy = :is_yyyy 
				and   empno = :ls_empno;
				
				dw_head.setitem(1,"jikgun_type",ls_jikgun_type)
				dw_head.setitem(1,"first_staff",ls_first_staff)
				dw_head.setitem(1,"second_staff",ls_second_staff)
				
				dw_head.setitem(1,"first_staff_nm",ls_first_staff_nm)
				dw_head.setitem(1,"second_staff_nm",ls_second_staff_nm)
				
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

			
			RETURN 0
			
			
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

event pfc_preopen;call super::pfc_preopen;dw_head.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

inv_resize.of_Register(dw_1, "ScaleToRight")
inv_resize.of_Register(dw_2, "FixedToBottom&ScaleToRight")
end event

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime


ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_1.AcceptText() <> 1 THEN RETURN -1
IF dw_2.AcceptText() <> 1 THEN RETURN -1



/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

idw_status = dw_1.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */
	dw_1.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN		/* Modify Record */
	dw_1.Setitem(1, "mod_id", gs_user_id)
	dw_1.Setitem(1, "mod_dt", ld_datetime)
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

il_rows = dw_1.Update(TRUE, FALSE)		
il_rows = dw_body.Update(TRUE, FALSE)
if il_rows = 1 then
	
	if il_rows = 1 then
		dw_body.ResetUpdate()
		dw_1.ResetUpdate()
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




///*===========================================================================*/
///* 작성자      : (주)지우정보 ()                                      */	
///* 작성일      : 2001..                                                  */	
///* 수정일      : 2001..                                                  */
///*===========================================================================*/
//long i, ll_row_count
//datetime ld_datetime
//string ls_jikgub, ls_dept_code, ls_head_dept
//
//ll_row_count = dw_body.RowCount()
//IF dw_body.AcceptText() <> 1 THEN RETURN -1
//
///* 시스템 날짜를 가져온다 */
//IF gf_sysdate(ld_datetime) = FALSE THEN
//	Return 0
//END IF
//
//
//
//
//////////////
//	select  jikguk, 
//		dept_code,
//		(select grp_cd1 from mis.dbo.thb02 (nolock) where dept_code = a.dept_code) as head_dept
//		into :ls_jikgub, :ls_dept_code, :ls_head_dept
//	from mis.dbo.thb01 a(nolock) where empno = :is_empno;
//////////////	
//	
//
//FOR i=1 TO ll_row_count
//   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
//   IF idw_status = NewModified! THEN				/* New Record */	
//      dw_body.Setitem(i, "yyyy", is_yyyy)
//      dw_body.Setitem(i, "empno", is_empno)
//      dw_body.Setitem(i, "first_staff", is_first_staff)
//      dw_body.Setitem(i, "second_staff", is_second_staff)
//		
//		dw_body.Setitem(i, "jikgub", ls_jikgub)
//		dw_body.Setitem(i, "dept_code", ls_dept_code)
//		dw_body.Setitem(i, "head_dept", ls_head_dept)
//      dw_body.Setitem(i, "reg_id", gs_user_id)
//   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
//      dw_body.Setitem(i, "mod_id", gs_user_id)
//      dw_body.Setitem(i, "mod_dt", ld_datetime)
//   END IF
//NEXT
//
//il_rows = dw_body.Update(TRUE, FALSE)
//
//if il_rows = 1 then
//   dw_body.ResetUpdate()
//   commit  USING SQLCA;
//else
//   rollback  USING SQLCA;
//end if
//
//This.Trigger Event ue_button(3, il_rows)
//This.Trigger Event ue_msg(3, il_rows)
//return il_rows
//
end event

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
il_rows = dw_print.retrieve(is_yyyy, is_empno, is_jikgun_type, is_first_staff, is_second_staff, 'A')
//dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()


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

event ue_title;call super::ue_title;/*===========================================================================*/
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

dw_print.object.t_title.text = is_yyyy+'년 인사평가'


end event

type cb_close from w_com010_e`cb_close within w_81102_e
end type

type cb_delete from w_com010_e`cb_delete within w_81102_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_81102_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_81102_e
end type

type cb_update from w_com010_e`cb_update within w_81102_e
end type

type cb_print from w_com010_e`cb_print within w_81102_e
end type

type cb_preview from w_com010_e`cb_preview within w_81102_e
end type

type gb_button from w_com010_e`gb_button within w_81102_e
end type

type cb_excel from w_com010_e`cb_excel within w_81102_e
end type

type dw_head from w_com010_e`dw_head within w_81102_e
integer y = 160
integer width = 3561
integer height = 168
string dataobject = "d_81102_h01"
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

	CASE "empno"    //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		




		
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
//
end event

event dw_head::constructor;call super::constructor;This.GetChild("jikgun_type", idw_jikgun_type)
idw_jikgun_type.SetTransObject(SQLCA)
idw_jikgun_type.Retrieve('')
idw_jikgun_type.InsertRow(1)

This.GetChild("first_staff", idw_first)
idw_first.SetTransObject(SQLCA)
idw_first.Retrieve('')
idw_first.InsertRow(1)

This.GetChild("second_staff", idw_second)
idw_second.SetTransObject(SQLCA)
idw_second.Retrieve('')
idw_second.InsertRow(1)
end event

type ln_1 from w_com010_e`ln_1 within w_81102_e
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_e`ln_2 within w_81102_e
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_e`dw_body within w_81102_e
integer y = 700
integer width = 3593
integer height = 636
string dataobject = "d_81102_d01"
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
//This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
//This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
//This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)


datawindowchild idw_child

This.GetChild("value_code", idw_child)
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve('801')

end event

event dw_body::ue_keydown;//
end event

event dw_body::itemchanged;call super::itemchanged;//CHOOSE CASE dwo.name
//	CASE "my_grade","first_grade","second_grade","allot","confirm_ok"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//		IF dw_body.AcceptText() <> 1 THEN RETURN 1
//		return Parent.trigger Event ue_Popup(dwo.name, row, data, 1)
//END CHOOSE
end event

type dw_print from w_com010_e`dw_print within w_81102_e
integer x = 1998
integer y = 600
string dataobject = "d_81100_r01"
end type

event dw_print::constructor;call super::constructor;//datawindowchild idw_child
//
//This.GetChild("value_code", idw_child)
//idw_child.SetTransObject(SQLCA)
//idw_child.Retrieve('801')
//
//This.GetChild("sub_code", idw_child)
//idw_child.SetTransObject(SQLCA)
//idw_child.Retrieve('802')
//
//This.GetChild("allot", idw_child)
//idw_child.SetTransObject(SQLCA)
//idw_child.Retrieve()
end event

type dw_1 from datawindow within w_81102_e
integer x = 5
integer y = 360
integer width = 3593
integer height = 344
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_81102_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;string ls_status, ls_my_grade, ls_value_code, ls_sub_title, ls_gubn = '0'
long i, j
/*===========================================================================*/
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
	CASE "colunm1" 
    IF data = 'A' THEN
	      /*action*/
    END IF
	CASE "cf_flag"	     //  Popup 검색창이 존재하는 항목 
		ls_status = dw_1.getitemstring(1,"status")
		if data = '1' then 
			for i = 1 to dw_body.rowcount()
				ls_my_grade = dw_body.getitemstring(i,"my_grade")
				ls_value_code = dw_body.getitemstring(i,"value_code")
				if ls_value_code <> 'C' and (isnull(ls_my_grade) or ls_my_grade = '') then
					messagebox('확인','자기평가를 입력해 주세요..')
					dw_body.setfocus()
					dw_body.setrow(i)
					dw_body.setcolumn('my_grade')
					return 1
				elseif ls_value_code = 'C' then
					ls_my_grade = dw_body.getitemstring(i,"my_grade")
					ls_sub_title = dw_body.getitemstring(i,"sub_title")
					if ls_sub_title='1. 본인 기술' and (isnull(ls_my_grade) or ls_my_grade = '') then
						messagebox('확인','자기평가를 입력해 주세요..')
						dw_body.setfocus()
						dw_body.setrow(i)
						dw_body.setcolumn('my_grade')
						return 1						
					end if
				end if
			next 
			
			
			if ls_status = "" or isnull(ls_status) then 
				ls_status = 'A'
			else
				ls_status = CharA(AscA(ls_status)+1)
			end if
			dw_1.setitem(1,"status",ls_status)

		elseif data = '0' then 
			ls_status = CharA(AscA(ls_status)-1)
			dw_1.setitem(1,"status",ls_status)

		end if

END CHOOSE

end event

event editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

type dw_2 from datawindow within w_81102_e
event ue_dw_1_set ( )
integer x = 5
integer y = 1324
integer width = 3593
integer height = 700
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_81102_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_dw_1_set;string ls_job_rt, ls_last_grade
int  ll_job_month



//ls_job_rt = dw_2.getitemstring(1,'job_rt')
//ll_job_month = dw_2.getitemdecimal(1,'job_month')
//ls_last_grade = dw_2.getitemstring(1,'last_grade')
//
//dw_1.setitem(1,'job_rt',ls_job_rt)
//dw_1.setitem(1,'job_month',ll_job_month)
//dw_1.setitem(1,'last_grade',ls_last_grade)



end event

event itemchanged;string ls_status, ls_my_grade, ls_value_code, ls_sub_title, ls_gubn = '0'
long i, j
/*===========================================================================*/
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
string ls_job_rt, ls_last_grade
decimal ll_job_month

CHOOSE CASE dwo.name

	case "job_rt"
		ls_job_rt = data
		dw_1.setitem(1,'job_rt',ls_job_rt)
		
	case "job_month"
		ll_job_month = dec(data)
//		messagebox('aa',ll_job_month)
		
		dw_1.setitem(1,'job_month',ll_job_month)
		
	case "last_grade"
		ls_last_grade = data
		dw_1.setitem(1,'last_grade',ls_last_grade)

	CASE "cf_flag"	     //  Popup 검색창이 존재하는 항목 
		ls_status = dw_1.getitemstring(1,"status")
		if data = '1' then 
			for i = 1 to dw_body.rowcount()
				ls_my_grade = dw_body.getitemstring(i,"my_grade")
				ls_value_code = dw_body.getitemstring(i,"value_code")
				if ls_value_code <> 'C' and (isnull(ls_my_grade) or ls_my_grade = '') then
					messagebox('확인','자기평가를 입력해 주세요..')
					dw_body.setfocus()
					dw_body.setrow(i)
					dw_body.setcolumn('my_grade')
					return 1
				elseif ls_value_code = 'C' then
					ls_my_grade = dw_body.getitemstring(i,"my_grade")
					ls_sub_title = dw_body.getitemstring(i,"sub_title")
					if ls_sub_title='1. 본인 기술' and (isnull(ls_my_grade) or ls_my_grade = '') then
						messagebox('확인','자기평가를 입력해 주세요..')
						dw_body.setfocus()
						dw_body.setrow(i)
						dw_body.setcolumn('my_grade')
						return 1						
					end if
				end if
			next 
			
			
			if ls_status = "" or isnull(ls_status) then 
				ls_status = 'A'
			else
				ls_status = CharA(AscA(ls_status)+1)
			end if
			dw_1.setitem(1,"status",ls_status)

		elseif data = '0' then 
			ls_status = CharA(AscA(ls_status)-1)
			dw_1.setitem(1,"status",ls_status)

		end if

END CHOOSE






//post event ue_dw_1_set()
end event

event editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

//post event ue_dw_1_set()

end event

