$PBExportHeader$w_81007_e.srw
$PBExportComments$역량평가(2차상사)
forward
global type w_81007_e from w_com020_e
end type
end forward

global type w_81007_e from w_com020_e
end type
global w_81007_e w_81007_e

type variables
string is_yyyy, is_empno

end variables

on w_81007_e.create
call super::create
end on

on w_81007_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;dw_head.setitem(1,"empno",gs_user_id)
dw_head.setitem(1,"kname",gs_user_nm)
Trigger Event ue_Popup("empno", 1, gs_user_id, 1)
end event

event ue_update;/*===========================================================================*/
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

type cb_close from w_com020_e`cb_close within w_81007_e
end type

type cb_delete from w_com020_e`cb_delete within w_81007_e
end type

type cb_insert from w_com020_e`cb_insert within w_81007_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_81007_e
end type

type cb_update from w_com020_e`cb_update within w_81007_e
end type

type cb_print from w_com020_e`cb_print within w_81007_e
end type

type cb_preview from w_com020_e`cb_preview within w_81007_e
end type

type gb_button from w_com020_e`gb_button within w_81007_e
end type

type cb_excel from w_com020_e`cb_excel within w_81007_e
end type

type dw_head from w_com020_e`dw_head within w_81007_e
integer y = 164
integer height = 164
string dataobject = "d_81007_H01"
end type

type ln_1 from w_com020_e`ln_1 within w_81007_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com020_e`ln_2 within w_81007_e
integer beginy = 356
integer endy = 356
end type

type dw_list from w_com020_e`dw_list within w_81007_e
integer y = 380
integer width = 933
integer height = 1660
string dataobject = "d_81007_L01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string is_key_value

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

IF IsNull(is_key_value) THEN return
il_rows = dw_body.retrieve(is_yyyy, is_key_value,'','')
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_81007_e
integer x = 987
integer y = 380
integer width = 2624
integer height = 1660
string dataobject = "d_81007_d01"
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

type st_1 from w_com020_e`st_1 within w_81007_e
integer x = 969
integer y = 380
integer height = 1660
end type

type dw_print from w_com020_e`dw_print within w_81007_e
integer x = 110
integer y = 896
end type

