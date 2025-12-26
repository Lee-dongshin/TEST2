$PBExportHeader$w_75004_d.srw
$PBExportComments$쿠폰 발행/회수현황
forward
global type w_75004_d from w_com010_d
end type
type rb_5000 from radiobutton within w_75004_d
end type
type rb_2000 from radiobutton within w_75004_d
end type
type cb_accept from commandbutton within w_75004_d
end type
type gb_1 from groupbox within w_75004_d
end type
type rb_3000 from radiobutton within w_75004_d
end type
type dw_1 from datawindow within w_75004_d
end type
end forward

global type w_75004_d from w_com010_d
rb_5000 rb_5000
rb_2000 rb_2000
cb_accept cb_accept
gb_1 gb_1
rb_3000 rb_3000
dw_1 dw_1
end type
global w_75004_d w_75004_d

type variables
string is_fr_yymm, is_to_yymm, is_vip
end variables

on w_75004_d.create
int iCurrent
call super::create
this.rb_5000=create rb_5000
this.rb_2000=create rb_2000
this.cb_accept=create cb_accept
this.gb_1=create gb_1
this.rb_3000=create rb_3000
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_5000
this.Control[iCurrent+2]=this.rb_2000
this.Control[iCurrent+3]=this.cb_accept
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.rb_3000
this.Control[iCurrent+6]=this.dw_1
end on

on w_75004_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_5000)
destroy(this.rb_2000)
destroy(this.cb_accept)
destroy(this.gb_1)
destroy(this.rb_3000)
destroy(this.dw_1)
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

//is_brand = dw_head.GetItemString(1, "brand")
//if IsNull(is_brand) or Trim(is_brand) = "" then
//   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//end if
//
is_fr_yymm = dw_head.GetItemString(1, "fr_yymm")
is_to_yymm = dw_head.GetItemString(1, "to_yymm")
is_vip = dw_head.GetItemString(1, "vip")
return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
dw_1.visible = false


/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_yymm, is_to_yymm, is_vip)
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

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)

IF gf_cdate(ld_datetime,-12)  THEN  
	dw_head.setitem(1,"fr_yymm",string(ld_datetime,"yyyymmdd"))
end if

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_75004_d","0")
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"
				 
dw_print.Modify(ls_modify)

dw_print.object.t_fr_yymm.text = dw_head.getitemstring(1,"fr_yymm")
dw_print.object.t_to_yymm.text = dw_head.getitemstring(1,"to_yymm")

dw_print.object.t_vip.text = dw_head.getitemstring(1,"vip")

if rb_5000.checked then
	dw_print.object.t_coupon.text = "5000 천점"
else
	dw_print.object.t_coupon.text = "3000 천점"
end if

end event

type cb_close from w_com010_d`cb_close within w_75004_d
end type

type cb_delete from w_com010_d`cb_delete within w_75004_d
end type

type cb_insert from w_com010_d`cb_insert within w_75004_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_75004_d
end type

type cb_update from w_com010_d`cb_update within w_75004_d
end type

type cb_print from w_com010_d`cb_print within w_75004_d
end type

type cb_preview from w_com010_d`cb_preview within w_75004_d
end type

type gb_button from w_com010_d`gb_button within w_75004_d
end type

type cb_excel from w_com010_d`cb_excel within w_75004_d
end type

type dw_head from w_com010_d`dw_head within w_75004_d
integer width = 2400
integer height = 188
string dataobject = "d_75004_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_75004_d
integer beginy = 392
integer endy = 392
end type

type ln_2 from w_com010_d`ln_2 within w_75004_d
integer beginy = 396
integer endy = 396
end type

type dw_body from w_com010_d`dw_body within w_75004_d
string dataobject = "d_75004_d01"
end type

type dw_print from w_com010_d`dw_print within w_75004_d
integer x = 87
integer y = 552
string dataobject = "d_75004_r01"
end type

type rb_5000 from radiobutton within w_75004_d
integer x = 2537
integer y = 260
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "5천점"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_body.object.gr_1.values="give_point_5"
dw_body.object.gr_2.values="accept_point_5"
dw_body.object.gr_3.values="cancel_point_5"

dw_1.object.gr_1.values="point_5"

end event

type rb_2000 from radiobutton within w_75004_d
integer x = 3223
integer y = 260
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "2천점"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_body.object.gr_1.values="give_point_2"
dw_body.object.gr_2.values="accept_point_2"
dw_body.object.gr_3.values="cancel_point_2"

dw_1.object.gr_1.values="point_2"
end event

type cb_accept from commandbutton within w_75004_d
integer x = 965
integer y = 40
integer width = 462
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "쿠폰회수율"
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_1.retrieve(is_fr_yymm, is_to_yymm, is_vip)
dw_1.visible = true

IF il_rows > 0 THEN

   dw_1.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF


end event

type gb_1 from groupbox within w_75004_d
integer x = 2469
integer y = 168
integer width = 1051
integer height = 200
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "쿠폰구분"
borderstyle borderstyle = stylelowered!
end type

type rb_3000 from radiobutton within w_75004_d
integer x = 2871
integer y = 260
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "3천점"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_body.object.gr_1.values="give_point_3"
dw_body.object.gr_2.values="accept_point_3"
dw_body.object.gr_3.values="cancel_point_3"

dw_1.object.gr_1.values="point_3"
end event

type dw_1 from datawindow within w_75004_d
boolean visible = false
integer x = 5
integer y = 412
integer width = 3602
integer height = 1628
integer taborder = 40
boolean titlebar = true
string title = "쿠폰회수율"
string dataobject = "d_75004_d02"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

