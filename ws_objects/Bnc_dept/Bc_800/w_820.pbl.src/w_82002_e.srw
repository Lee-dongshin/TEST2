$PBExportHeader$w_82002_e.srw
$PBExportComments$KPI측정지표 등록(부서)
forward
global type w_82002_e from w_com010_e
end type
end forward

global type w_82002_e from w_com010_e
end type
global w_82002_e w_82002_e

type variables
string is_yyyy, is_empno, is_higher_staff, is_dept_code
datawindowchild idw_higher
end variables

on w_82002_e.create
call super::create
end on

on w_82002_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;string is_higher_staff_nm, ls_dept_code, ls_dept_nm, ls_head_dept

is_yyyy = dw_head.getitemstring(1,"yyyy")

////////////
	select  
		dept_code,
		dbo.sf_dept_nm(dept_code)	as dept_nm,
		(select grp_cd1 from mis.dbo.thb02 (nolock) where dept_code = a.dept_code) as head_dept
		into :ls_dept_code, :ls_dept_nm, :ls_head_dept
	from mis.dbo.thb01 a(nolock) where empno = :gs_user_id;
////////////	
	
dw_head.setitem(1,"dept_code",ls_dept_code)
dw_head.setitem(1,"dept_nm",ls_dept_nm)


/////////////
select top 1 second_staff, dbo.sf_emp_nm(second_staff) as second_staff_nm 
	into :is_higher_staff, :is_higher_staff_nm
from tb_81001_m (nolock)
where yyyy = :is_yyyy 
and   dept_code = :ls_dept_code;
/////////////
dw_head.setitem(1,"higher_staff",is_higher_staff)







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
is_dept_code = dw_head.GetItemString(1, "dept_code")

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if



is_higher_staff  = dw_head.GetItemString(1, "higher_staff")
if IsNull(is_higher_staff) or Trim(is_higher_staff) = "" then
   MessageBox(ls_title,"1차상사를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("higher_staff")
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

il_rows = dw_body.retrieve(is_yyyy, is_dept_code)
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
String     ls_shop_nm , ls_yyyy, ls_empno, ls_allot, ls_grade, ls_sql, ls_cf_step
Boolean    lb_check 
DataStore  lds_Source
long  li_score

CHOOSE CASE as_column
			

		case "higher_grade"
			lS_allot = dw_body.getitemstring(al_row,"allot")
			select score into :li_score from tb_81000_c (nolock) where allot = :ls_allot and grade = :as_data;				
			dw_body.setitem(al_row,"higher_point",li_score)		

		case "allot"
			
			ls_grade = dw_body.getitemstring(al_row,"higher_grade")
			select score into :li_score from tb_81000_c (nolock) where allot = :as_data and grade = :ls_grade;				
			dw_body.setitem(al_row,"higher_point",li_score)	
		
			
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
	

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */	
      dw_body.Setitem(i, "yyyy", is_yyyy)
      dw_body.Setitem(i, "dept_code", is_dept_code)
      dw_body.Setitem(i, "higher_staff", is_higher_staff)
		
//		dw_body.Setitem(i, "dept_code", ls_dept_code)
		dw_body.Setitem(i, "head_dept", ls_head_dept)
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

event ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_kpi_grp

if dw_body.AcceptText() <> 1 then return
	
ls_kpi_grp = dw_body.getitemstring(dw_body.rowcount() -1,"kpi_grp")

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.setitem(il_rows,"kpi_grp", ls_kpi_grp)
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id+1)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_82002_e
end type

type cb_delete from w_com010_e`cb_delete within w_82002_e
end type

type cb_insert from w_com010_e`cb_insert within w_82002_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_82002_e
end type

type cb_update from w_com010_e`cb_update within w_82002_e
end type

type cb_print from w_com010_e`cb_print within w_82002_e
end type

type cb_preview from w_com010_e`cb_preview within w_82002_e
end type

type gb_button from w_com010_e`gb_button within w_82002_e
end type

type cb_excel from w_com010_e`cb_excel within w_82002_e
end type

type dw_head from w_com010_e`dw_head within w_82002_e
integer y = 160
integer width = 3561
integer height = 168
string dataobject = "d_82002_h01"
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

event dw_head::constructor;call super::constructor;
This.GetChild("higher_staff", idw_higher)
idw_higher.SetTransObject(SQLCA)
idw_higher.Retrieve(gs_user_id)
idw_higher.InsertRow(1)


end event

type ln_1 from w_com010_e`ln_1 within w_82002_e
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_e`ln_2 within w_82002_e
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_e`dw_body within w_82002_e
integer y = 368
integer height = 1672
string dataobject = "d_82002_d01"
end type

event dw_body::constructor;call super::constructor;datawindowchild idw_child

This.GetChild("value_code", idw_child)
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve('801')

end event

event dw_body::ue_keydown;//Parent.Trigger Event ue_insert()
/*===========================================================================*/
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
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
	CASE KeyDownArrow!
		IF This.GetRow() = This.RowCount() THEN
		   Parent.Trigger Event ue_insert()
		END IF
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
	CASE "my_grade","first_grade","second_grade","allot","confirm_ok"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		IF dw_body.AcceptText() <> 1 THEN RETURN 1
		return Parent.trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

type dw_print from w_com010_e`dw_print within w_82002_e
integer x = 91
integer y = 700
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

