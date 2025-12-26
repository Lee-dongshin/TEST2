$PBExportHeader$w_91024_e.srw
$PBExportComments$케어라벨취급주의
forward
global type w_91024_e from w_com010_e
end type
end forward

global type w_91024_e from w_com010_e
end type
global w_91024_e w_91024_e

on w_91024_e.create
call super::create
end on

on w_91024_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve()
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

type cb_close from w_com010_e`cb_close within w_91024_e
end type

type cb_delete from w_com010_e`cb_delete within w_91024_e
end type

type cb_insert from w_com010_e`cb_insert within w_91024_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_91024_e
end type

type cb_update from w_com010_e`cb_update within w_91024_e
end type

type cb_print from w_com010_e`cb_print within w_91024_e
end type

type cb_preview from w_com010_e`cb_preview within w_91024_e
end type

type gb_button from w_com010_e`gb_button within w_91024_e
end type

type cb_excel from w_com010_e`cb_excel within w_91024_e
end type

type dw_head from w_com010_e`dw_head within w_91024_e
end type

type ln_1 from w_com010_e`ln_1 within w_91024_e
end type

type ln_2 from w_com010_e`ln_2 within w_91024_e
end type

type dw_body from w_com010_e`dw_body within w_91024_e
string dataobject = "d_91024_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_e`dw_print within w_91024_e
end type

