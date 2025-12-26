$PBExportHeader$w_sh114_d.srw
$PBExportComments$BOX입고조회
forward
global type w_sh114_d from w_com010_d
end type
end forward

global type w_sh114_d from w_com010_d
integer width = 2976
integer height = 2088
end type
global w_sh114_d w_sh114_d

type variables
date		id_st_ymd,id_ed_ymd
string	is_st_ymd,is_ed_ymd

end variables

on w_sh114_d.create
call super::create
end on

on w_sh114_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
datetime ld_datetime

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

dw_head.SetItem(1,'st_ymd',Date(ld_datetime))
dw_head.SetItem(1,'ed_ymd',Date(ld_datetime))



end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 동은아빠                                       */	
/* 작성일      : 2002.01.22                                                  */	
/* 수정일      : 2002.01.22                                                  */
/*===========================================================================*/
String   ls_title,ls_style_no

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

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	


id_st_ymd = dw_head.GetItemDate(1, "st_ymd")
if IsNull(id_st_ymd) then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("st_ymd")
   return false
end if

id_ed_ymd = dw_head.GetItemDate(1, "ed_ymd")
if IsNull(id_ed_ymd) then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("ed_ymd")
   return false
end if

is_st_ymd	= String(id_st_ymd,"yyyymmdd")
is_ed_ymd	= String(id_ed_ymd,"yyyymmdd")

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.22                                                  */	
/* 수정일      : 2002.01.22                                                  */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(gs_shop_cd,is_st_ymd,is_ed_ymd)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

type cb_close from w_com010_d`cb_close within w_sh114_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh114_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh114_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh114_d
end type

type cb_update from w_com010_d`cb_update within w_sh114_d
end type

type cb_print from w_com010_d`cb_print within w_sh114_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_sh114_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_sh114_d
end type

type dw_head from w_com010_d`dw_head within w_sh114_d
integer x = 32
integer y = 168
integer width = 3442
integer height = 120
string dataobject = "d_sh114_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_sh114_d
integer beginy = 304
integer endy = 304
end type

type ln_2 from w_com010_d`ln_2 within w_sh114_d
integer beginy = 308
integer endy = 308
end type

type dw_body from w_com010_d`dw_body within w_sh114_d
integer y = 324
integer height = 1516
string dataobject = "d_sh114_d01"
end type

type dw_print from w_com010_d`dw_print within w_sh114_d
end type

