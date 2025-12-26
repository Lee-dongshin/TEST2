$PBExportHeader$w_81009_d.srw
$PBExportComments$인사종합평가조회
forward
global type w_81009_d from w_com010_d
end type
end forward

global type w_81009_d from w_com010_d
end type
global w_81009_d w_81009_d

type variables
string is_yyyy, is_empno

end variables

on w_81009_d.create
call super::create
end on

on w_81009_d.destroy
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
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("empno")
   return false
end if

is_empno = dw_head.GetItemString(1, "empno")
if IsNull(is_empno) or Trim(is_empno) = "" then
   MessageBox(ls_title,"사번을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("empno")
   return false
end if
return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yyyy, is_empno)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_emp_nm, ls_dept, ls_fr_style, ls_fr_chno, ls_mat_cd
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column

	CASE "empno"		

			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then  return 1
				if gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
					dw_head.Setitem(al_row, "emp_nm", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 

			gst_cd.default_where   = "where goout_gubn = '1' " // and dept_code in ('K100','B200','O200','O100','B100','O000','T100','T000','K400','N000')" /* 니트 , 악세라시 추가 */  
			
			
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(empno LIKE '" + as_data + "%' OR " + & 
				                    " kname LIKE '" + as_data + "%' )" 
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
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("make_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
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

type cb_close from w_com010_d`cb_close within w_81009_d
end type

type cb_delete from w_com010_d`cb_delete within w_81009_d
end type

type cb_insert from w_com010_d`cb_insert within w_81009_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_81009_d
end type

type cb_update from w_com010_d`cb_update within w_81009_d
end type

type cb_print from w_com010_d`cb_print within w_81009_d
end type

type cb_preview from w_com010_d`cb_preview within w_81009_d
end type

type gb_button from w_com010_d`gb_button within w_81009_d
end type

type cb_excel from w_com010_d`cb_excel within w_81009_d
end type

type dw_head from w_com010_d`dw_head within w_81009_d
integer height = 144
string dataobject = "d_81009_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "empno"      // dddw로 작성된 항목
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_81009_d
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_d`ln_2 within w_81009_d
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_d`dw_body within w_81009_d
integer y = 368
integer height = 1672
string dataobject = "d_81009_d01"
end type

type dw_print from w_com010_d`dw_print within w_81009_d
end type

