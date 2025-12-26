$PBExportHeader$w_mat_d02.srw
$PBExportComments$기간별조회
forward
global type w_mat_d02 from w_com010_d
end type
end forward

global type w_mat_d02 from w_com010_d
string title = "기간별 조회"
end type
global w_mat_d02 w_mat_d02

type variables
string is_brand, is_fr_yymmdd, is_to_yymmdd
datawindowchild  idw_brand

end variables

on w_mat_d02.create
call super::create
end on

on w_mat_d02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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
is_brand     = dw_head.GetItemString(1, "brand")
is_fr_yymmdd = dw_head.GetItemString(1, "fr_ymd")
is_to_yymmdd = dw_head.GetItemString(1, "to_ymd")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

is_brand = '%'
il_rows = dw_body.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, gs_user_id)
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

type cb_close from w_com010_d`cb_close within w_mat_d02
end type

type cb_delete from w_com010_d`cb_delete within w_mat_d02
end type

type cb_insert from w_com010_d`cb_insert within w_mat_d02
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_mat_d02
end type

type cb_update from w_com010_d`cb_update within w_mat_d02
end type

type cb_print from w_com010_d`cb_print within w_mat_d02
end type

type cb_preview from w_com010_d`cb_preview within w_mat_d02
end type

type gb_button from w_com010_d`gb_button within w_mat_d02
end type

type cb_excel from w_com010_d`cb_excel within w_mat_d02
end type

type dw_head from w_com010_d`dw_head within w_mat_d02
integer height = 160
string dataobject = "d_mat_h11"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')

end event

type ln_1 from w_com010_d`ln_1 within w_mat_d02
integer beginy = 356
integer endy = 356
end type

type ln_2 from w_com010_d`ln_2 within w_mat_d02
integer beginy = 360
integer endy = 360
end type

type dw_body from w_com010_d`dw_body within w_mat_d02
integer y = 380
integer height = 1640
string dataobject = "d_mat_d11"
end type

event dw_body::itemchanged;//
end event

type dw_print from w_com010_d`dw_print within w_mat_d02
string dataobject = "d_mat_r11"
end type

