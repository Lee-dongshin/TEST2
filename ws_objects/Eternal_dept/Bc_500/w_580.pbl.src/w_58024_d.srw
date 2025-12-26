$PBExportHeader$w_58024_d.srw
$PBExportComments$중국수출금액 simulation
forward
global type w_58024_d from w_com010_d
end type
type rb_2 from radiobutton within w_58024_d
end type
type rb_1 from radiobutton within w_58024_d
end type
end forward

global type w_58024_d from w_com010_d
integer width = 3675
integer height = 2276
rb_2 rb_2
rb_1 rb_1
end type
global w_58024_d w_58024_d

type variables
string is_brand, is_fr_yymmdd,  is_to_yymmdd, is_gubn
Decimal id_usd_rate, id_mat_pro, id_markup, id_margin

DatawindowChild  idw_brand

end variables

event open;call super::open;datetime	ld_datetime
string   ls_from_date, ls_to_date

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_to_date = String(ld_datetime, "yyyymmdd")
ls_from_date = LeftA(ls_to_date,4) + '0101'

dw_head.Setitem(1,"fr_yymmdd", ls_from_date)
dw_head.Setitem(1,"to_yymmdd", ls_to_date)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_58024_d","0")
end event

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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"Brand를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if



is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
if IsNull(is_fr_yymmdd) or Trim(is_fr_yymmdd) = "" then
   MessageBox(ls_title,"From일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymmdd")
   return false
end if

is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
   MessageBox(ls_title,"To일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if

if is_fr_yymmdd > is_to_yymmdd then
	MessageBox(ls_title,"From일자가 To일자보다 큽니다 !")
	return false
end if

id_usd_rate = dw_head.GetItemDecimal(1, "usd_rate")
if IsNull(id_usd_rate) or  id_usd_rate  = 0 then
   id_usd_rate = 1150
	dw_head.SetItem(1, "usd_rate",1150)
end if


id_mat_pro = dw_head.GetItemDecimal(1, "mat_pro")
if IsNull(id_mat_pro) or  id_mat_pro  = 0 then
   id_usd_rate = 0.333
	dw_head.SetItem(1, "mat_pro",0.333)
end if

id_markup = dw_head.GetItemDecimal(1, "markup")
if IsNull(id_markup) or  id_markup  = 0 then
   id_usd_rate = 4.5
	dw_head.SetItem(1, "markup",4.5)
end if

id_margin = dw_head.GetItemDecimal(1, "margin")
if IsNull(id_margin) or  id_margin  = 0 then
   id_usd_rate = 0.25
	dw_head.SetItem(1, "margin", 0.25)
end if



is_gubn = dw_head.GetItemString(1, "gubn") 


return true







end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

IF rb_1.checked = true then
	il_rows = dw_body.retrieve(is_brand,is_fr_yymmdd, is_to_yymmdd,id_usd_rate, id_mat_pro,id_markup,id_margin)
else
	il_rows = dw_body.retrieve(is_brand,is_fr_yymmdd, is_to_yymmdd,id_usd_rate, is_gubn)
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

on w_58024_d.create
int iCurrent
call super::create
this.rb_2=create rb_2
this.rb_1=create rb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
end on

on w_58024_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
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

ls_modify =	"t_fr_yymmdd.Text = '" + string(is_fr_yymmdd,'@@@@년@@월@@일') + "'" + &
            "t_to_yymmdd.Text = '" + string(is_to_yymmdd,'@@@@년@@월@@일') + "'" + &
				"t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_nm") + '  중국 출고 및 미수금 현황'  + "'"  
           
dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_58024_d
end type

type cb_delete from w_com010_d`cb_delete within w_58024_d
end type

type cb_insert from w_com010_d`cb_insert within w_58024_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_58024_d
end type

type cb_update from w_com010_d`cb_update within w_58024_d
end type

type cb_print from w_com010_d`cb_print within w_58024_d
end type

type cb_preview from w_com010_d`cb_preview within w_58024_d
end type

type gb_button from w_com010_d`gb_button within w_58024_d
end type

type cb_excel from w_com010_d`cb_excel within w_58024_d
end type

type dw_head from w_com010_d`dw_head within w_58024_d
integer width = 2949
string dataobject = "d_58024_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')
end event

type ln_1 from w_com010_d`ln_1 within w_58024_d
end type

type ln_2 from w_com010_d`ln_2 within w_58024_d
end type

type dw_body from w_com010_d`dw_body within w_58024_d
string dataobject = "d_58024_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(false)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_print from w_com010_d`dw_print within w_58024_d
integer x = 1865
integer y = 736
integer height = 592
string dataobject = "d_58024_r01"
end type

type rb_2 from radiobutton within w_58024_d
integer x = 3063
integer y = 328
integer width = 411
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "실데이타보기"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor  = RGB(0, 0, 255)
rb_1.Textcolor = 0


dw_body.DataObject  = 'd_58024_d02'
dw_print.DataObject = 'd_58024_r02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_1 from radiobutton within w_58024_d
integer x = 3063
integer y = 224
integer width = 439
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "추정치로 보기"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor  = RGB(0, 0, 255)
rb_2.Textcolor = 0


dw_body.DataObject  = 'd_58024_d01'
dw_print.DataObject = 'd_58024_r01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

