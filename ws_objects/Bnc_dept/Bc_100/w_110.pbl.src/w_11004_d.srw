$PBExportHeader$w_11004_d.srw
$PBExportComments$월/판매형태별 매출계획현황
forward
global type w_11004_d from w_com010_d
end type
type rb_1 from radiobutton within w_11004_d
end type
type rb_2 from radiobutton within w_11004_d
end type
type st_1 from statictext within w_11004_d
end type
type rb_3 from radiobutton within w_11004_d
end type
type rb_4 from radiobutton within w_11004_d
end type
type gb_1 from groupbox within w_11004_d
end type
type dw_body2 from datawindow within w_11004_d
end type
type dw_body3 from datawindow within w_11004_d
end type
type dw_body4 from datawindow within w_11004_d
end type
type rb_5 from radiobutton within w_11004_d
end type
type dw_body5 from datawindow within w_11004_d
end type
end forward

global type w_11004_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
st_1 st_1
rb_3 rb_3
rb_4 rb_4
gb_1 gb_1
dw_body2 dw_body2
dw_body3 dw_body3
dw_body4 dw_body4
rb_5 rb_5
dw_body5 dw_body5
end type
global w_11004_d w_11004_d

type variables
DataWindowChild idw_brand, idw_country_cd
String  is_brand, is_yyyy, is_country_cd
end variables

on w_11004_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_1=create st_1
this.rb_3=create rb_3
this.rb_4=create rb_4
this.gb_1=create gb_1
this.dw_body2=create dw_body2
this.dw_body3=create dw_body3
this.dw_body4=create dw_body4
this.rb_5=create rb_5
this.dw_body5=create dw_body5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.dw_body2
this.Control[iCurrent+8]=this.dw_body3
this.Control[iCurrent+9]=this.dw_body4
this.Control[iCurrent+10]=this.rb_5
this.Control[iCurrent+11]=this.dw_body5
end on

on w_11004_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_1)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.gb_1)
destroy(this.dw_body2)
destroy(this.dw_body3)
destroy(this.dw_body4)
destroy(this.rb_5)
destroy(this.dw_body5)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
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

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

is_country_cd = dw_head.GetItemString(1, "country_cd")

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	



return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yyyy, is_country_cd)
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

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_1, "FixedToRight")
inv_resize.of_Register(dw_body2, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_body3, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_body4, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_body5, "ScaleToRight&Bottom")


dw_body2.SetTransObject(SQLCA)
dw_body3.SetTransObject(SQLCA)
dw_body4.SetTransObject(SQLCA)
dw_body5.SetTransObject(SQLCA)

dw_body.ShareData(dw_body2)

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
            "t_datetime.Text = '" + ls_datetime + "'" + &
				"t_brand.Text = '브랜드 : " + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_yyyy.Text = '계획 년도 : " + is_yyyy + "'"

dw_print.Modify(ls_modify)

//if is_opt_chn = 'K' then
//	dw_print.object.t_opt_chn.text = '구분: ' + '국내'
//else
//	dw_print.object.t_opt_chn.text = '구분: ' + '중국'
//end if
//
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_11004_d","0")
end event

event ue_preview();call super::ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

type cb_close from w_com010_d`cb_close within w_11004_d
end type

type cb_delete from w_com010_d`cb_delete within w_11004_d
end type

type cb_insert from w_com010_d`cb_insert within w_11004_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_11004_d
end type

type cb_update from w_com010_d`cb_update within w_11004_d
end type

type cb_print from w_com010_d`cb_print within w_11004_d
end type

type cb_preview from w_com010_d`cb_preview within w_11004_d
end type

type gb_button from w_com010_d`gb_button within w_11004_d
end type

type cb_excel from w_com010_d`cb_excel within w_11004_d
end type

type dw_head from w_com010_d`dw_head within w_11004_d
integer x = 1495
integer y = 180
integer width = 2094
integer height = 132
string dataobject = "d_11004_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(sqlca)
idw_brand.Retrieve('001')


This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(sqlca)
idw_country_cd.Retrieve('000')

end event

type ln_1 from w_com010_d`ln_1 within w_11004_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_11004_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_11004_d
integer y = 376
integer width = 3607
integer height = 1672
string dataobject = "d_11004_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_11004_d
string dataobject = "d_11004_r01"
end type

type rb_1 from radiobutton within w_11004_d
integer x = 55
integer y = 224
integer width = 288
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
string text = "시즌별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_2.TextColor = RGB(0, 0, 0)
rb_3.TextColor = RGB(0, 0, 0)
rb_4.TextColor = RGB(0, 0, 0)
rb_5.TextColor = RGB(0, 0, 0)

dw_print.DataObject = "d_11004_r01"
dw_print.SetTransObject(SQLCA)

dw_body.DataObject = "d_11004_d01"
dw_body.SetTransObject(SQLCA)

//dw_body.setredraw(FALSE)
//dw_body.SetSort("year A, season A, sale_div A")
//dw_body.Sort()
//dw_body.GroupCalc()
//dw_body.setredraw( True)
//
//dw_body.visible  = True
//dw_body2.visible = False
//dw_body3.visible = False
//dw_body4.visible = False
//
end event

type rb_2 from radiobutton within w_11004_d
integer x = 338
integer y = 224
integer width = 389
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
string text = "판매형태별"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_1.TextColor = RGB(0, 0, 0)
rb_3.TextColor = RGB(0, 0, 0)
rb_4.TextColor = RGB(0, 0, 0)
rb_5.TextColor = RGB(0, 0, 0)

dw_print.DataObject = "d_11004_r02"
dw_print.SetTransObject(SQLCA)

dw_body.DataObject = "d_11004_d02"
dw_body.SetTransObject(SQLCA)

// 
//dw_body2.setredraw(FALSE)
//dw_body2.SetSort("year A, season A, sale_div A")
//dw_body2.Sort()
//dw_body2.GroupCalc()
//dw_body2.setredraw( True)
//
//dw_body2.visible  = True
//dw_body.visible = False
//dw_body3.visible = False
//dw_body4.visible = False
//
end event

type st_1 from statictext within w_11004_d
integer x = 3195
integer y = 288
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "( 단위 : 천원)"
boolean focusrectangle = false
end type

type rb_3 from radiobutton within w_11004_d
integer x = 713
integer y = 224
integer width = 297
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "입금가"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_1.TextColor = RGB(0, 0, 0)
rb_2.TextColor = RGB(0, 0, 0)
rb_4.TextColor = RGB(0, 0, 0)
rb_5.TextColor = RGB(0, 0, 0)

dw_print.DataObject = "d_11004_r03"
dw_print.SetTransObject(SQLCA)
dw_body.DataObject = "d_11004_d03"
dw_body.SetTransObject(SQLCA)

end event

type rb_4 from radiobutton within w_11004_d
integer x = 987
integer y = 224
integer width = 251
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
string text = "원가"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_1.TextColor = RGB(0, 0, 0)
rb_2.TextColor = RGB(0, 0, 0)
rb_3.TextColor = RGB(0, 0, 0)
rb_5.TextColor = RGB(0, 0, 0)

dw_print.DataObject = "d_11004_r04"
dw_print.SetTransObject(SQLCA)

dw_body.DataObject = "d_11004_d04"
dw_body.SetTransObject(SQLCA)


end event

type gb_1 from groupbox within w_11004_d
integer x = 32
integer y = 168
integer width = 1449
integer height = 152
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

type dw_body2 from datawindow within w_11004_d
boolean visible = false
integer x = 5
integer y = 376
integer width = 3607
integer height = 1672
integer taborder = 40
string title = "none"
string dataobject = "d_11004_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_body3 from datawindow within w_11004_d
integer x = 5
integer y = 376
integer width = 3607
integer height = 1672
integer taborder = 40
string title = "none"
string dataobject = "d_11004_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_body4 from datawindow within w_11004_d
integer x = 5
integer y = 376
integer width = 3607
integer height = 1672
integer taborder = 40
string title = "none"
string dataobject = "d_11004_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_5 from radiobutton within w_11004_d
integer x = 1248
integer y = 224
integer width = 210
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
string text = "손익"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_1.TextColor = RGB(0, 0, 0)
rb_2.TextColor = RGB(0, 0, 0)
rb_3.TextColor = RGB(0, 0, 0)
rb_4.TextColor = RGB(0, 0, 0)

dw_print.DataObject = "d_11004_r05"
dw_print.SetTransObject(SQLCA)

dw_body.DataObject = "d_11004_d05"
dw_body.SetTransObject(SQLCA)
end event

type dw_body5 from datawindow within w_11004_d
integer x = 5
integer y = 376
integer width = 3607
integer height = 1672
integer taborder = 40
string title = "none"
string dataobject = "d_11004_d05"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

