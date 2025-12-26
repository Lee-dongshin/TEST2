$PBExportHeader$w_91012_d.srw
$PBExportComments$거래처 조회
forward
global type w_91012_d from w_com010_d
end type
type rb_1 from radiobutton within w_91012_d
end type
type rb_2 from radiobutton within w_91012_d
end type
type rb_3 from radiobutton within w_91012_d
end type
type gb_1 from groupbox within w_91012_d
end type
end forward

global type w_91012_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
gb_1 gb_1
end type
global w_91012_d w_91012_d

type variables
DatawindowChild idw_brand, idw_change_gubn
String is_flag, is_brand,  is_change_gubn
end variables

on w_91012_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.gb_1
end on

on w_91012_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.gb_1)
end on

event open;call super::open;is_flag = '1'
dw_head.Setitem(1, "change_gubn", '%')

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.04.02                                                  */	
/* 수정일      : 2002.04.02                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_flag, is_brand, is_change_gubn)
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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.02                                                  */	
/* 수정일      : 2002.04.02                                                  */
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

is_change_gubn = dw_head.GetItemString(1, "change_gubn")
if IsNull(is_change_gubn) or Trim(is_change_gubn) = "" then
   MessageBox(ls_title,"거래처형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("change_gubn")
   return false
end if

return true

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.02                                                  */	
/* 수정일      : 2002.04.02                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_flag

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
IF is_flag = '1' THEN
   ls_flag = '(자재/생산)'
ELSEIF is_flag = '2' THEN
   ls_flag = '(수수료사원)'
ELSE
   ls_flag = '(매장)'
END IF

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_flag.Text  = '" + ls_flag + "'" + &
				 "t_brand.Text = '브랜드 : " + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") + "'" + &
				 "t_stat.Text = '거래처 형태 : " + idw_change_gubn.GetitemString(idw_change_gubn.GetRow(), "inter_display") + "'"

dw_print.Modify(ls_modify)


end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         rb_1.Enabled = false
         rb_2.Enabled = false
         rb_3.Enabled = false
      end if
   CASE 5    /* 조건 */
      rb_1.Enabled = true
      rb_2.Enabled = true
      rb_3.Enabled = true
	
END CHOOSE

end event

type cb_close from w_com010_d`cb_close within w_91012_d
end type

type cb_delete from w_com010_d`cb_delete within w_91012_d
end type

type cb_insert from w_com010_d`cb_insert within w_91012_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_91012_d
end type

type cb_update from w_com010_d`cb_update within w_91012_d
end type

type cb_print from w_com010_d`cb_print within w_91012_d
end type

type cb_preview from w_com010_d`cb_preview within w_91012_d
end type

type gb_button from w_com010_d`gb_button within w_91012_d
end type

type cb_excel from w_com010_d`cb_excel within w_91012_d
end type

type dw_head from w_com010_d`dw_head within w_91012_d
integer x = 1170
integer y = 188
integer width = 2386
integer height = 140
string dataobject = "d_91012_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("change_gubn", idw_change_gubn)
idw_change_gubn.SetTransObject(SQLCA)
idw_change_gubn.Retrieve('913')
idw_change_gubn.insertRow(1)
idw_change_gubn.Setitem(1, "inter_cd", '%')
idw_change_gubn.Setitem(1, "inter_nm", '전체')



end event

type ln_1 from w_com010_d`ln_1 within w_91012_d
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_d`ln_2 within w_91012_d
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_d`dw_body within w_91012_d
integer y = 368
integer height = 1680
string dataobject = "d_91012_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("appv_cond", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('007')

This.GetChild("change_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('913')

end event

type dw_print from w_com010_d`dw_print within w_91012_d
string dataobject = "d_91012_r01"
end type

event dw_print::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("appv_cond", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('007')

This.GetChild("change_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('913')

end event

type rb_1 from radiobutton within w_91012_d
event ue_keydown pbm_keydown
integer x = 59
integer y = 224
integer width = 361
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
string text = "자재/생산"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN 
	Send(Handle(This), 256, 9, long(0,0))
	Return 1 
END IF

end event

event clicked;is_flag = '1' 
This.textcolor = Rgb(0, 0, 255)
rb_2.textcolor = Rgb(0, 0, 0)
rb_3.textcolor = Rgb(0, 0, 0)

end event

type rb_2 from radiobutton within w_91012_d
event ue_keydown pbm_keydown
integer x = 430
integer y = 224
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "수수료사원"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN 
	Send(Handle(This), 256, 9, long(0,0))
	Return 1 
END IF

end event

event clicked;is_flag = '2'
This.textcolor = Rgb(0, 0, 255)
rb_1.textcolor = Rgb(0, 0, 0)
rb_3.textcolor = Rgb(0, 0, 0)


end event

type rb_3 from radiobutton within w_91012_d
event ue_keydown pbm_keydown
integer x = 832
integer y = 224
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "매장"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN 
	Send(Handle(This), 256, 9, long(0,0))
	Return 1 
END IF

end event

event clicked;is_flag = '3' 
This.textcolor = Rgb(0, 0, 255)
rb_1.textcolor = Rgb(0, 0, 0)
rb_2.textcolor = Rgb(0, 0, 0)



end event

type gb_1 from groupbox within w_91012_d
integer x = 23
integer y = 160
integer width = 1115
integer height = 156
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

