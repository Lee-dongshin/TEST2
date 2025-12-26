$PBExportHeader$w_91023_e.srw
$PBExportComments$동호회관리
forward
global type w_91023_e from w_com010_e
end type
end forward

global type w_91023_e from w_com010_e
end type
global w_91023_e w_91023_e

type variables
string is_club_cd, is_person_id

datawindowchild	idw_club_cd

end variables

on w_91023_e.create
call super::create
end on

on w_91023_e.destroy
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

is_club_cd = dw_head.GetItemString(1, "club_cd")
is_person_id = dw_head.GetItemString(1, "person_id")
return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_person_id, is_club_cd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_update;call super::ue_update;/*===========================================================================*/
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

//FOR i=1 TO ll_row_count
//   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
//   IF idw_status = NewModified! THEN				/* New Record */
//      dw_body.Setitem(i, "reg_id", gs_user_id)
//   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
//      dw_body.Setitem(i, "mod_id", gs_user_id)
//      dw_body.Setitem(i, "mod_dt", ld_datetime)
//   END IF
//NEXT

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

event ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_inter_nm, ls_kname, ls_brand, ls_dept_code 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "person_id"				
			select kname, case saup_gubn when '01' then 'N' when '02' then 'O' when '11' then 'W' end as brand, dept_code 
				into :ls_kname, :ls_brand, :ls_dept_code 
			from mis.dbo.thb01 where empno = :as_data;
			
			dw_body.setitem(al_row,"person_nm",ls_kname)
			dw_body.setitem(al_row,"brand",ls_brand)
			dw_body.setitem(al_row,"dept_cd",ls_dept_code)	

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

type cb_close from w_com010_e`cb_close within w_91023_e
end type

type cb_delete from w_com010_e`cb_delete within w_91023_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_91023_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_91023_e
end type

type cb_update from w_com010_e`cb_update within w_91023_e
end type

type cb_print from w_com010_e`cb_print within w_91023_e
end type

type cb_preview from w_com010_e`cb_preview within w_91023_e
end type

type gb_button from w_com010_e`gb_button within w_91023_e
end type

type cb_excel from w_com010_e`cb_excel within w_91023_e
end type

type dw_head from w_com010_e`dw_head within w_91023_e
integer y = 160
integer height = 112
string dataobject = "d_91023_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("club_cd", idw_club_cd)
idw_club_cd.SetTransObject(SQLCA)
idw_club_cd.Retrieve('950')
idw_club_cd.InsertRow(1)
idw_club_cd.SetItem(1, "inter_cd", '%')
idw_club_cd.SetItem(1, "inter_nm", '전체')
end event

type ln_1 from w_com010_e`ln_1 within w_91023_e
integer beginy = 284
integer endy = 284
end type

type ln_2 from w_com010_e`ln_2 within w_91023_e
integer beginy = 288
integer endy = 288
end type

type dw_body from w_com010_e`dw_body within w_91023_e
integer y = 308
integer height = 1732
string dataobject = "d_91023_d01"
end type

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

CHOOSE CASE dwo.name
	CASE "colunm1" 
    IF data = 'A' THEN
	      /*action*/
    END IF

	CASE "person_id"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)


END CHOOSE

end event

event dw_body::constructor;call super::constructor;This.GetChild("club_cd", idw_club_cd)
idw_club_cd.SetTransObject(SQLCA)
idw_club_cd.Retrieve('950')

end event

type dw_print from w_com010_e`dw_print within w_91023_e
end type

