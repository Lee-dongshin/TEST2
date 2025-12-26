$PBExportHeader$w_sh321_d.srw
$PBExportComments$마일리지카드용품입고조회
forward
global type w_sh321_d from w_com010_d
end type
end forward

global type w_sh321_d from w_com010_d
integer width = 2958
integer height = 2064
long backcolor = 16777215
end type
global w_sh321_d w_sh321_d

type variables
String is_fr_ymd, is_to_ymd
end variables

on w_sh321_d.create
call super::create
end on

on w_sh321_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                             */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
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

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

is_fr_ymd = String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
is_to_ymd = String(dw_head.GetItemDate(1, "to_ymd"), "yyyymmdd")

if is_fr_ymd > is_to_ymd then
   MessageBox(ls_title,"시작일이 종료일 보다 큽니다 !")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(gs_shop_cd, is_fr_ymd, is_to_ymd)
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

type cb_close from w_com010_d`cb_close within w_sh321_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh321_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh321_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh321_d
end type

type cb_update from w_com010_d`cb_update within w_sh321_d
end type

type cb_print from w_com010_d`cb_print within w_sh321_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_sh321_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_sh321_d
long backcolor = 16777215
end type

type dw_head from w_com010_d`dw_head within w_sh321_d
integer width = 2775
integer height = 160
string dataobject = "d_sh311_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_sh321_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_sh321_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_sh321_d
integer y = 376
integer width = 2875
integer height = 1456
string dataobject = "d_sh321_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_sh321_d
end type

