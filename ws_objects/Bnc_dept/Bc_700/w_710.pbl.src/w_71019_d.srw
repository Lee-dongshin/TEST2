$PBExportHeader$w_71019_d.srw
$PBExportComments$마일리지소멸자조회
forward
global type w_71019_d from w_com010_d
end type
type dw_member from datawindow within w_71019_d
end type
end forward

global type w_71019_d from w_com010_d
integer width = 3662
integer height = 2092
dw_member dw_member
end type
global w_71019_d w_71019_d

type variables
String is_fr_ymd, is_to_ymd, is_vip
Datawindowchild  idw_area, idw_sale_type
end variables

on w_71019_d.create
int iCurrent
call super::create
this.dw_member=create dw_member
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_member
end on

on w_71019_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_member)
end on

event open;call super::open;//datetime ld_datetime
//
//IF gf_sysdate(ld_datetime) = FALSE THEN
//	ld_datetime = DateTime(Today(), Now())
//END IF
//
//dw_head.SetItem(1, "fr_ymd", string(ld_datetime,"yyyymmdd"))
//dw_head.SetItem(1, "to_ymd", string(ld_datetime,"yyyymmdd"))
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
String ls_title

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

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) then
   MessageBox(ls_title,"소멸일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) then
   MessageBox(ls_title,"조회일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_vip = dw_head.GetItemString(1, "vip")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

	dw_body.DataObject = "d_71019_d01"
	dw_body.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_vip)

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

event ue_preview();   dw_print.DataObject = "d_71019_r01"	
	dw_print.SetTransObject(SQLCA)
	This.Trigger Event ue_title()
	dw_print.retrieve(is_fr_ymd, is_to_ymd, is_vip)

   dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title();/*===========================================================================*/
/* 작성자      : (주)보끄레 (윤춘식)                                       */	
/* 작성일      : 2002.11.14                                                  */	
/* 수정일      : 2002.11.14                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_vip

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


if is_vip = '2' then
	ls_vip = 'VIP 회원'
else 
	ls_vip = '전체회원'
end if

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_yymmdd.Text = '" + String(is_fr_ymd + is_to_ymd, '@@@@/@@/@@ ~~ @@@@/@@/@@') + "'" + &
				"t_vip.Text = '" + ls_vip + "'"

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_71019_d","0")
end event

event pfc_preopen();call super::pfc_preopen;dw_member.SetTransObject(SQLCA)
 
end event

type cb_close from w_com010_d`cb_close within w_71019_d
end type

type cb_delete from w_com010_d`cb_delete within w_71019_d
end type

type cb_insert from w_com010_d`cb_insert within w_71019_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_71019_d
end type

type cb_update from w_com010_d`cb_update within w_71019_d
end type

type cb_print from w_com010_d`cb_print within w_71019_d
boolean visible = false
integer x = 1769
end type

type cb_preview from w_com010_d`cb_preview within w_71019_d
integer x = 1733
integer width = 384
string text = "인쇄하기(&V)"
end type

type gb_button from w_com010_d`gb_button within w_71019_d
end type

type cb_excel from w_com010_d`cb_excel within w_71019_d
end type

type dw_head from w_com010_d`dw_head within w_71019_d
integer height = 116
string dataobject = "d_71019_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_71019_d
integer beginy = 288
integer endy = 288
end type

type ln_2 from w_com010_d`ln_2 within w_71019_d
integer beginy = 292
integer endy = 292
end type

type dw_body from w_com010_d`dw_body within w_71019_d
integer x = 23
integer y = 300
string dataobject = "d_71019_d01"
boolean hscrollbar = true
end type

event dw_body::doubleclicked;call super::doubleclicked;string  ls_jumin
long    ll_rows


dw_member.Reset()
ls_jumin = this.getitemstring(row,"jumin")
ll_rows = dw_member.Retrieve(ls_jumin) 

if  ll_rows > 0 then
	dw_member.visible = true
end if



end event

type dw_print from w_com010_d`dw_print within w_71019_d
string dataobject = "d_71019_r01"
end type

type dw_member from datawindow within w_71019_d
boolean visible = false
integer x = 5
integer y = 300
integer width = 4500
integer height = 2000
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "회원정보"
string dataobject = "d_member_info"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.01.18                                                  */
/*===========================================================================*/

This.GetChild("area", idw_area)
idw_area.SetTRansObject(SQLCA)
idw_area.Retrieve('090')


This.GetChild("sale_type", idw_sale_type )
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.Retrieve('011')

end event

event doubleclicked;this.visible = false
end event

