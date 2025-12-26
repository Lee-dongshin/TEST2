$PBExportHeader$w_42019_d.srw
$PBExportComments$BOX출고관리
forward
global type w_42019_d from w_com010_d
end type
end forward

global type w_42019_d from w_com010_d
integer width = 3675
integer height = 2232
string title = "BOX 출고 집계"
end type
global w_42019_d w_42019_d

type variables
DataWindowChild idw_brand, idw_othr_brand, idw_out_no

String is_brand,   is_out_no, is_out_date, is_frm_yymmdd, is_to_yymmdd

end variables

on w_42019_d.create
call super::create
end on

on w_42019_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_yymmdd",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "to_yymmdd",string(ld_datetime, "yyyymmdd"))
end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_frm_yymmdd, is_to_yymmdd)
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_frm_yymmdd = dw_head.GetItemString(1, "frm_yymmdd")
if IsNull(is_frm_yymmdd) or Trim(is_frm_yymmdd) = "" then
   MessageBox(ls_title,"시작일자 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_yymmdd")
   return false
end if

is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
   MessageBox(ls_title,"마지막일자 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if



return true

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42019_d","0")
end event

type cb_close from w_com010_d`cb_close within w_42019_d
end type

type cb_delete from w_com010_d`cb_delete within w_42019_d
end type

type cb_insert from w_com010_d`cb_insert within w_42019_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42019_d
end type

type cb_update from w_com010_d`cb_update within w_42019_d
end type

type cb_print from w_com010_d`cb_print within w_42019_d
end type

type cb_preview from w_com010_d`cb_preview within w_42019_d
end type

type gb_button from w_com010_d`gb_button within w_42019_d
end type

type cb_excel from w_com010_d`cb_excel within w_42019_d
end type

type dw_head from w_com010_d`dw_head within w_42019_d
integer x = 626
integer width = 2610
integer height = 80
string dataobject = "d_42019_h01"
end type

event dw_head::constructor;datetime ld_datetime

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

type ln_1 from w_com010_d`ln_1 within w_42019_d
integer beginy = 268
integer endy = 268
end type

type ln_2 from w_com010_d`ln_2 within w_42019_d
integer beginy = 272
integer endy = 272
end type

type dw_body from w_com010_d`dw_body within w_42019_d
integer y = 284
integer width = 3593
integer height = 1712
string dataobject = "d_42019_d01"
end type

type dw_print from w_com010_d`dw_print within w_42019_d
integer x = 2368
integer y = 1068
end type

