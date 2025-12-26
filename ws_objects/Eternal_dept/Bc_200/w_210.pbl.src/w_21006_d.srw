$PBExportHeader$w_21006_d.srw
$PBExportComments$자재코드 조회
forward
global type w_21006_d from w_com010_d
end type
type rb_1 from radiobutton within w_21006_d
end type
type rb_2 from radiobutton within w_21006_d
end type
type gb_1 from groupbox within w_21006_d
end type
end forward

global type w_21006_d from w_com010_d
integer width = 3685
integer height = 2264
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_21006_d w_21006_d

type variables
string  is_mat_gubn, is_brand, is_mat_year, is_mat_season, is_mat_sojae
datawindowchild  idw_brand, idw_season, idw_mat_sojae
end variables

on w_21006_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.gb_1
end on

on w_21006_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event open;call super::open;is_mat_gubn = '1'
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.14                                                  */	
/* 수정일      : 2002.01.14                                                  */
/* event       : ue_retrieve                                                 */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_mat_year, is_mat_season,is_mat_sojae)

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
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.14                                                  */	
/* 수정일      : 2002.01.14                                                  */
/* event       : ue_keycheck                                                 */
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_mat_year = dw_head.GetItemString(1, "mat_year")
if IsNull(is_mat_year) or Trim(is_mat_year) = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("mat_year")
   return false
end if

is_mat_season = dw_head.GetItemString(1, "mat_season")
if IsNull(is_mat_season) or Trim(is_mat_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("mat_season")
   return false
end if

is_mat_sojae = dw_head.GetItemString(1, "mat_sojae")
if IsNull(is_mat_sojae) or Trim(is_mat_sojae) = "" then
	MessageBox(ls_title,"소재품종을 선택 하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("mat_sojae")
	return false
end if

return true
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_mat_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
				 "t_mat_sojae.Text = '" + idw_mat_sojae.Getitemstring(idw_mat_sojae.GetRow(),"mat_sojae_display") + "'"
dw_print.Modify(ls_modify)



end event

type cb_close from w_com010_d`cb_close within w_21006_d
end type

type cb_delete from w_com010_d`cb_delete within w_21006_d
end type

type cb_insert from w_com010_d`cb_insert within w_21006_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_21006_d
end type

type cb_update from w_com010_d`cb_update within w_21006_d
end type

type cb_print from w_com010_d`cb_print within w_21006_d
end type

type cb_preview from w_com010_d`cb_preview within w_21006_d
end type

type gb_button from w_com010_d`gb_button within w_21006_d
end type

type cb_excel from w_com010_d`cb_excel within w_21006_d
end type

type dw_head from w_com010_d`dw_head within w_21006_d
integer x = 658
integer y = 180
integer width = 2354
string dataobject = "d_21006_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : constructor(dw_head)                                        */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')


//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_mat_year = dw_head.getitemstring(1,'mat_year')

this.getchild("mat_season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_mat_year)
//idw_season.retrieve('003')

This.GetChild("mat_sojae", idw_mat_sojae)
idw_mat_sojae.SetTRansObject(SQLCA)
idw_mat_sojae.Retrieve("1",is_brand)
idw_mat_sojae.insertrow(1)
idw_mat_sojae.Setitem(1, "mat_sojae", "%")
idw_mat_sojae.Setitem(1, "mat_sojae_nm", "전체")

 

end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "brand", "mat_year"		
		//라빠레트 시즌적용
		dw_head.accepttext()
		is_brand = dw_head.getitemstring(1,'brand')
		is_mat_year = dw_head.getitemstring(1,'mat_year')
		
		this.getchild("mat_season",idw_season)
		idw_season.settransobject(sqlca)
		idw_season.retrieve('003', is_brand, is_mat_year)
		//idw_season.retrieve('003')
		
		
		This.GetChild("mat_sojae", idw_mat_sojae)
		idw_mat_sojae.SetTRansObject(SQLCA)

		if rb_1.checked = true then
			idw_mat_sojae.Retrieve("1",is_brand)
		else
			idw_mat_sojae.Retrieve("2",is_brand)
		end if
		
		idw_mat_sojae.insertrow(1)
		idw_mat_sojae.Setitem(1, "mat_sojae", "%")
		idw_mat_sojae.Setitem(1, "mat_sojae_nm", "전체")
		
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_21006_d
end type

type ln_2 from w_com010_d`ln_2 within w_21006_d
end type

type dw_body from w_com010_d`dw_body within w_21006_d
integer x = 14
integer y = 456
string dataobject = "d_21006_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;This.inv_sort.of_SetColumnHeader(false)
end event

type dw_print from w_com010_d`dw_print within w_21006_d
string dataobject = "d_21006_r01"
end type

type rb_1 from radiobutton within w_21006_d
event ue_keydown pbm_keydown
integer x = 183
integer y = 236
integer width = 320
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
string text = "원자재"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0))
END IF

end event

event clicked;This.textcolor = Rgb(0, 0, 255) 
rb_2.textcolor = Rgb(0, 0, 0)
is_mat_gubn = '1' 
dw_body.dataobject = "d_21006_d01"
dw_body.Settransobject(sqlca)

dw_print.dataobject = "d_21006_r01"
dw_print.Settransobject(sqlca)


dw_head.SetItem(1, "mat_sojae", "")

idw_mat_sojae.Retrieve('1',is_brand)
idw_mat_sojae.insertrow(1)
idw_mat_sojae.Setitem(1, "mat_sojae", "%")
idw_mat_sojae.Setitem(1, "mat_sojae_nm", "전체")

 cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

end event

type rb_2 from radiobutton within w_21006_d
event ue_keydown pbm_keydown
integer x = 183
integer y = 316
integer width = 320
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
string text = "부자재"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0))
END IF

end event

event clicked;This.textcolor = Rgb(0, 0, 255) 
rb_1.textcolor = Rgb(0, 0, 0)
is_mat_gubn = '2' 
dw_body.dataobject = "d_21006_d02"
dw_body.Settransobject(sqlca)

dw_print.dataobject = "d_21006_r02"
dw_print.Settransobject(sqlca)
dw_head.SetItem(1, "mat_sojae", "")

idw_mat_sojae.Retrieve('2',is_brand)
idw_mat_sojae.insertrow(1)
idw_mat_sojae.Setitem(1, "mat_sojae", "%")
idw_mat_sojae.Setitem(1, "mat_sojae_nm", "전체")

 cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
end event

type gb_1 from groupbox within w_21006_d
integer x = 91
integer y = 164
integer width = 498
integer height = 248
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

