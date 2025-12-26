$PBExportHeader$w_61037_d.srw
$PBExportComments$온라인유통판매현황
forward
global type w_61037_d from w_com010_d
end type
type rb_1 from radiobutton within w_61037_d
end type
type rb_2 from radiobutton within w_61037_d
end type
type rb_3 from radiobutton within w_61037_d
end type
end forward

global type w_61037_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
end type
global w_61037_d w_61037_d

type variables
string  is_yymm, is_gubun
end variables

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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"판매년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if  rb_1.checked then
	is_gubun = '%'
elseif rb_2.checked then
	is_gubun = 's'
else  
	is_gubun = 'h'
end if


il_rows = dw_body.retrieve(is_yymm, is_gubun)
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

on w_61037_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
end on

on w_61037_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
end on

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
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_yymm.Text = '" + is_yymm + "'"

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_61037_d
end type

type cb_delete from w_com010_d`cb_delete within w_61037_d
end type

type cb_insert from w_com010_d`cb_insert within w_61037_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61037_d
end type

type cb_update from w_com010_d`cb_update within w_61037_d
end type

type cb_print from w_com010_d`cb_print within w_61037_d
end type

type cb_preview from w_com010_d`cb_preview within w_61037_d
end type

type gb_button from w_com010_d`gb_button within w_61037_d
end type

type cb_excel from w_com010_d`cb_excel within w_61037_d
end type

type dw_head from w_com010_d`dw_head within w_61037_d
integer x = 594
integer y = 220
integer width = 622
integer height = 168
string dataobject = "d_61037_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_61037_d
end type

type ln_2 from w_com010_d`ln_2 within w_61037_d
end type

type dw_body from w_com010_d`dw_body within w_61037_d
string dataobject = "d_61037_d01"
end type

type dw_print from w_com010_d`dw_print within w_61037_d
integer x = 229
integer y = 648
string dataobject = "d_61037_r01"
end type

type rb_1 from radiobutton within w_61037_d
integer x = 110
integer y = 200
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "전체"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor    = RGB(0, 0, 255)
rb_2.TextColor    = 0
rb_3.TextColor    = 0


is_yymm = dw_head.GetItemString(1, "yymm")

dw_body.retrieve(is_yymm, '%')
 
end event

type rb_2 from radiobutton within w_61037_d
integer x = 110
integer y = 272
integer width = 402
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
string text = "쇼핑몰"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor    = RGB(0, 0, 255)
rb_1.TextColor    = 0
rb_3.TextColor    = 0

is_yymm = dw_head.GetItemString(1, "yymm")
dw_body.retrieve(is_yymm, 'S')
 
end event

type rb_3 from radiobutton within w_61037_d
integer x = 110
integer y = 340
integer width = 402
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
string text = "백화점닷컴"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor    = RGB(0, 0, 255)
rb_1.TextColor    = 0
rb_2.TextColor    = 0

is_yymm = dw_head.GetItemString(1, "yymm")
dw_body.retrieve(is_yymm, 'H')
 
end event

