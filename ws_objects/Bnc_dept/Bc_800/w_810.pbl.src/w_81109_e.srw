$PBExportHeader$w_81109_e.srw
$PBExportComments$인사평가(최종평가 (구) )
forward
global type w_81109_e from w_com020_e
end type
type dw_1 from datawindow within w_81109_e
end type
type dw_2 from datawindow within w_81109_e
end type
end forward

global type w_81109_e from w_com020_e
integer width = 3648
dw_1 dw_1
dw_2 dw_2
end type
global w_81109_e w_81109_e

type variables
string is_yyyy, is_empno, is_jikgun_type, is_first_staff, is_second_staff, is_key_value

end variables

on w_81109_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
end on

on w_81109_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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
is_empno = dw_head.GetItemString(1, "empno")
return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_yyyy, is_empno)
dw_1.Reset()
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;dw_head.setitem(1,"empno",gs_user_id)
dw_head.setitem(1,"kname",gs_user_nm)

dw_1.insertrow(1)
dw_body.insertrow(1)
end event

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_1.AcceptText() <> 1 THEN RETURN -1

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
	

		
il_rows = dw_1.Update(TRUE, FALSE)
if il_rows = 1 then
		dw_1.ResetUpdate()
		commit  USING SQLCA;
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

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm , ls_yyyy, ls_empno, ls_allot, ls_grade, ls_sql, ls_cf_step
Boolean    lb_check 
DataStore  lds_Source
long  li_score

CHOOSE CASE as_column
		case "my_grade"
			lS_allot = dw_body.getitemstring(al_row,"allot")
			select score into :li_score from tb_81000_c (nolock) where allot = :ls_allot and grade = :as_data;				
			dw_body.setitem(al_row,"my_point",li_score)		

		case "first_grade"
			lS_allot = dw_body.getitemstring(al_row,"allot")
			select score into :li_score from tb_81000_c (nolock) where allot = :ls_allot and grade = :as_data;				
			dw_body.setitem(al_row,"first_point",li_score)		

		case "second_grade"
			lS_allot = dw_body.getitemstring(al_row,"allot")
			select score into :li_score from tb_81000_c (nolock) where allot = :ls_allot and grade = :as_data;				
			dw_body.setitem(al_row,"second_point",li_score)		

		case "allot"
			ls_grade = dw_body.getitemstring(al_row,"my_grade")
			select score into :li_score from tb_81000_c (nolock) where allot = :as_data and grade = :ls_grade;				
			dw_body.setitem(al_row,"my_point",li_score)	
			
			setnull(li_score)
			ls_grade = dw_body.getitemstring(al_row,"first_grade")
			select score into :li_score from tb_81000_c (nolock) where allot = :as_data and grade = :ls_grade;				
			dw_body.setitem(al_row,"first_point",li_score)	
		
			setnull(li_score)
			ls_grade = dw_body.getitemstring(al_row,"second_grade")
			select score into :li_score from tb_81000_c (nolock) where allot = :as_data and grade = :ls_grade;				
			dw_body.setitem(al_row,"second_point",li_score)	
			
		case "confirm_ok"
			ls_cf_step = dw_body.getitemstring(al_row,"cf_step")
			if as_data = "Y" then 
					if isnull(ls_cf_step) then 
						ls_cf_step = "B"
					else
						select char(ascii(:ls_cf_step)+1) into :ls_cf_step from dual;
						
					end if
			else
					if ls_cf_step = "B" then 
						setnull(ls_cf_step)
					else
						select char(ascii(:ls_cf_step)-1) into :ls_cf_step from dual;
						
					end if
			end if
			dw_body.setitem(al_row,"cf_step",ls_cf_step)
			
			RETURN 0
			
			
END CHOOSE



RETURN 0

end event

event pfc_preopen;call super::pfc_preopen;dw_head.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

inv_resize.of_Register(dw_1, "ScaleToRight")
inv_resize.of_Register(dw_2, "FixedToBottom&ScaleToRight")
end event

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
il_rows = dw_print.retrieve(is_yyyy, is_key_value, is_jikgun_type, is_first_staff, is_second_staff)
//dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()


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

type cb_close from w_com020_e`cb_close within w_81109_e
end type

type cb_delete from w_com020_e`cb_delete within w_81109_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_81109_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_81109_e
end type

type cb_update from w_com020_e`cb_update within w_81109_e
end type

type cb_print from w_com020_e`cb_print within w_81109_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_81109_e
end type

type gb_button from w_com020_e`gb_button within w_81109_e
end type

type cb_excel from w_com020_e`cb_excel within w_81109_e
end type

type dw_head from w_com020_e`dw_head within w_81109_e
integer y = 164
integer height = 164
string dataobject = "d_81109_H01"
end type

type ln_1 from w_com020_e`ln_1 within w_81109_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com020_e`ln_2 within w_81109_e
integer beginy = 356
integer endy = 356
end type

type dw_list from w_com020_e`dw_list within w_81109_e
integer y = 380
integer width = 1065
integer height = 1660
string dataobject = "d_81109_L01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_flag
long i

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

is_key_value = This.GetItemString(row, 'empno') /* DataWindow에 Key 항목을 가져온다 */
is_jikgun_type= This.GetItemString(row, 'jikgun_type')
is_first_staff= This.GetItemString(row, 'first_staff')
is_second_staff= This.GetItemString(row, 'second_staff')

IF IsNull(is_key_value) THEN return
il_rows = dw_2.retrieve(is_yyyy, is_key_value,is_jikgun_type, is_first_staff, is_second_staff)
il_rows = dw_1.retrieve(is_yyyy, is_key_value,is_jikgun_type, is_first_staff, is_second_staff)
IF il_rows > 0 THEN
	ls_flag = dw_1.getitemstring(1,"flag")
	if ls_flag = "New" then
		dw_1.SetItemStatus(1, 0, Primary!, New!)
	end if
END IF


il_rows = dw_body.retrieve(is_yyyy, is_key_value,is_jikgun_type)
IF il_rows > 0 THEN
	for i=1 to il_rows
		ls_flag = dw_body.getitemstring(i,"flag")
		if ls_flag = "New" then
		 	dw_body.SetItemStatus(i, 0, Primary!, New!)
		end if
	next 
   dw_body.SetFocus()
END IF

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_81109_e
integer x = 1111
integer y = 704
integer width = 2496
integer height = 628
string dataobject = "d_81109_d01"
end type

event dw_body::constructor;call super::constructor;datawindowchild idw_child

This.GetChild("value_code", idw_child)
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve('801')

end event

event dw_body::ue_keydown;//
end event

event dw_body::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "confirm_ok","first_grade","second_grade","allot"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		IF dw_body.AcceptText() <> 1 THEN RETURN 1
		return Parent.trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

type st_1 from w_com020_e`st_1 within w_81109_e
integer x = 1093
integer y = 380
integer height = 1660
end type

event st_1::ue_mouseup;call super::ue_mouseup;
Long		ll_Width

ll_Width = dw_1.X + dw_1.Width - st_1.X - ii_BarThickness

dw_1.Resize (st_1.X - dw_1.X, dw_1.Height)

dw_1.Move (st_1.X + ii_BarThickness, dw_1.Y)
dw_1.Resize (ll_Width, dw_1.Height)


ll_Width = dw_2.X + dw_2.Width - st_1.X - ii_BarThickness

dw_2.Resize (st_1.X - dw_2.X, dw_2.Height)

dw_2.Move (st_1.X + ii_BarThickness, dw_2.Y)
dw_2.Resize (ll_Width, dw_2.Height)

end event

type dw_print from w_com020_e`dw_print within w_81109_e
integer x = 110
integer y = 896
string dataobject = "d_81100_r01"
end type

type dw_1 from datawindow within w_81109_e
integer x = 1111
integer y = 372
integer width = 2496
integer height = 340
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_81109_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

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

event itemchanged;string ls_status, ls_grade, ls_value_code, ls_sub_title, ls_gubn = '0'
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
			ls_grade = dw_1.getitemstring(1,"last_grade")
			if isnull(ls_grade) or ls_grade = '' then
				messagebox('확인','최종평가를 입력해 주세요..')
				dw_1.setfocus()
				dw_1.setrow(1)
				dw_1.setcolumn('last_grade')
				return 1
			end if
		
			
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

type dw_2 from datawindow within w_81109_e
integer x = 1111
integer y = 1320
integer width = 2496
integer height = 700
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_81109_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

