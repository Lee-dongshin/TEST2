$PBExportHeader$w_73001_d.srw
$PBExportComments$회원모집현황(매장별)
forward
global type w_73001_d from w_com010_d
end type
type rb_shop_age from radiobutton within w_73001_d
end type
type rb_shop from radiobutton within w_73001_d
end type
type gb_1 from groupbox within w_73001_d
end type
end forward

global type w_73001_d from w_com010_d
windowstate windowstate = maximized!
rb_shop_age rb_shop_age
rb_shop rb_shop
gb_1 gb_1
end type
global w_73001_d w_73001_d

type variables
DataWindowChild idw_area, idw_gubn, idw_brand

string is_yyyy, is_area, is_gubn, is_brand

end variables

on w_73001_d.create
int iCurrent
call super::create
this.rb_shop_age=create rb_shop_age
this.rb_shop=create rb_shop
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_shop_age
this.Control[iCurrent+2]=this.rb_shop
this.Control[iCurrent+3]=this.gb_1
end on

on w_73001_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_shop_age)
destroy(this.rb_shop)
destroy(this.gb_1)
end on

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
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

is_yyyy = Trim(String(dw_head.GetItemDatetime(1, "yyyy"), 'yyyy'))
if IsNull(is_yyyy) or is_yyyy = "" then
   MessageBox(ls_title,"기준 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

is_area 	= Trim(dw_head.GetItemString(1, "area"))
if IsNull(is_area) or is_area = "" then
   MessageBox(ls_title,"지역 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("area")
   return false
end if

is_gubn 	= Trim(dw_head.GetItemString(1, "gubn"))
if IsNull(is_gubn) or is_gubn = "" then
   MessageBox(ls_title,"회원 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubn")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")

return true

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_gubn, is_yyyy, is_area, is_brand)

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

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
				"t_year.Text = '" + is_yyyy + "'" + &
				"t_area.Text = '" + idw_area.GetItemString(idw_area.GetRow(), "inter_display") + "'"  + &
				"t_gubn.Text = '" + idw_gubn.GetItemString(idw_gubn.GetRow(), "inter_display") + "'" 
				
dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_73001_d","0")
end event

type cb_close from w_com010_d`cb_close within w_73001_d
end type

type cb_delete from w_com010_d`cb_delete within w_73001_d
end type

type cb_insert from w_com010_d`cb_insert within w_73001_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_73001_d
end type

type cb_update from w_com010_d`cb_update within w_73001_d
end type

type cb_print from w_com010_d`cb_print within w_73001_d
end type

type cb_preview from w_com010_d`cb_preview within w_73001_d
end type

type gb_button from w_com010_d`gb_button within w_73001_d
end type

type cb_excel from w_com010_d`cb_excel within w_73001_d
end type

type dw_head from w_com010_d`dw_head within w_73001_d
integer x = 498
integer y = 188
integer width = 3058
integer height = 128
string dataobject = "d_73001_h01"
end type

event dw_head::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.01.18                                                  */
/*===========================================================================*/
This.GetChild("area", idw_area)
idw_area.SetTRansObject(SQLCA)
idw_area.Retrieve('090')
idw_area.InsertRow(1)
idw_area.SetItem(1,'inter_cd','%')
idw_area.SetItem(1,'inter_nm','전체')

This.GetChild("gubn", idw_gubn)
idw_gubn.SetTRansObject(SQLCA)
idw_gubn.Retrieve('702')
idw_gubn.insertrow(0)
idw_gubn.SetItem(idw_gubn.rowcount(),'inter_cd','9')
idw_gubn.SetItem(idw_gubn.rowcount(),'inter_nm','VIP 회원')


This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertrow(1)
idw_brand.Setitem(1, "inter_cd", "%")
idw_brand.Setitem(1, "inter_nm", "전체")
end event

type ln_1 from w_com010_d`ln_1 within w_73001_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_73001_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_73001_d
integer y = 364
integer height = 1676
string dataobject = "d_73001_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_73001_d
integer x = 658
integer y = 420
integer width = 1829
integer height = 816
string dataobject = "d_73001_r01"
end type

event dw_print::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.01.18                                                  */
/*===========================================================================*/
DataWindowChild ldw_child 

This.GetChild("area", ldw_child)
ldw_child.SetTRansObject(SQLCA)
ldw_child.Retrieve('090')
end event

type rb_shop_age from radiobutton within w_73001_d
integer x = 55
integer y = 188
integer width = 379
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
string text = "매장연령별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_shop.TextColor = 0

dw_body.DataObject = 'd_73001_d01'
dw_print.DataObject = 'd_73001_r01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_shop from radiobutton within w_73001_d
integer x = 55
integer y = 264
integer width = 379
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
string text = "매장별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_shop_age.TextColor = 0
This.TextColor = RGB(0, 0, 255)

dw_body.DataObject = 'd_73001_d02'
dw_print.DataObject = 'd_73001_r02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type gb_1 from groupbox within w_73001_d
integer y = 136
integer width = 480
integer height = 212
integer taborder = 110
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

