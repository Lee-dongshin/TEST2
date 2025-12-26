$PBExportHeader$w_sh340_d.srw
$PBExportComments$대리점입금조회
forward
global type w_sh340_d from w_com010_d
end type
end forward

global type w_sh340_d from w_com010_d
integer width = 2976
integer height = 2040
long backcolor = 16777215
end type
global w_sh340_d w_sh340_d

type variables
String is_yymmdd
end variables

on w_sh340_d.create
call super::create
end on

on w_sh340_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;DateTime ld_datetime
String ls_datetime

if MidA(gs_shop_cd_1,1,2) = 'XX'then
	messagebox("주의!", '복합매장에서는 사용할 수 없습니다!')
	return 1
end if	

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "YYYYMMDD")

//dw_head.Setitem(1, "yymmdd", ls_datetime )

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
string   ls_title

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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                  */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return 
end if	

if gs_shop_div = "K" then
 il_rows = dw_body.retrieve(gs_brand, is_yymmdd, is_yymmdd, gs_shop_div, gs_shop_cd)
else
 messagebox("경고!", "해당 조회는 대리점의 경우에만 가능합니다!")
 return
end if

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

type cb_close from w_com010_d`cb_close within w_sh340_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh340_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh340_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh340_d
end type

type cb_update from w_com010_d`cb_update within w_sh340_d
end type

type cb_print from w_com010_d`cb_print within w_sh340_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_sh340_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_sh340_d
long backcolor = 16777215
end type

type dw_head from w_com010_d`dw_head within w_sh340_d
integer y = 152
integer height = 128
string dataobject = "d_sh340_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_sh340_d
integer beginy = 280
integer endy = 280
end type

type ln_2 from w_com010_d`ln_2 within w_sh340_d
integer beginy = 284
integer endy = 284
end type

type dw_body from w_com010_d`dw_body within w_sh340_d
integer y = 296
integer height = 1504
string dataobject = "d_sh340_d01"
end type

type dw_print from w_com010_d`dw_print within w_sh340_d
end type

