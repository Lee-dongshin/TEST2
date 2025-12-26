$PBExportHeader$w_61019_d.srw
$PBExportComments$매장판매순위
forward
global type w_61019_d from w_com010_d
end type
type rb_1 from radiobutton within w_61019_d
end type
type rb_2 from radiobutton within w_61019_d
end type
end forward

global type w_61019_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
end type
global w_61019_d w_61019_d

type variables
DataWindowChild idw_brand, idw_season

String is_brand, is_fr_yymm, is_to_yymm,   is_year, is_season


end variables

on w_61019_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
end on

on w_61019_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
end on

event open;call super::open;datetime ld_datetime
string   ls_yymm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_yymm = String(ld_datetime, "yyyymm")

dw_head.Setitem(1,'season', '%')
dw_head.Setitem(1,'year', '%')
dw_head.Setitem(1,'Fr_yymm', ls_yymm)
dw_head.Setitem(1,'to_yymm', ls_yymm)


end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/
String   ls_title

IF as_cb_div = '1' THEN
	ls_title = '조회오류'
ELSEIF as_cb_div = '2' THEN
	ls_title = '추가오류'
ELSEIF as_cb_div = '3' THEN
	ls_title = '저장오류'
ELSE
	ls_title ='오류'
END IF

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title, "브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


is_fr_yymm = Trim(dw_head.GetItemString(1, "fr_yymm"))
if IsNull(is_fr_yymm) or is_fr_yymm = "" then
   MessageBox(ls_title,"From판매월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymm")
   return false
end if


is_to_yymm = Trim(dw_head.GetItemString(1, "to_yymm"))
if IsNull(is_to_yymm) or is_to_yymm = "" then
   MessageBox(ls_title,"To판매월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   return false
end if

if is_to_yymm < is_fr_yymm then
   MessageBox(ls_title,"To판매월이 From판매월보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   return false
end if


is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then is_year = '%'

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title, "시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN



if rb_1.Checked = TRUE then 
	if is_brand = 'B' or is_brand = 'P' or is_brand = 'E' then
	dw_body.DataObject  = 'd_61019_d11'
	dw_print.DataObject = 'd_61019_r11'
	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
	else
	dw_body.DataObject  = 'd_61019_d01'
	dw_print.DataObject = 'd_61019_r01'
	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
	end if	
	
	il_rows = dw_body.retrieve( is_fr_yymm, is_to_yymm, is_brand, is_year, is_season)
else
	il_rows = dw_body.retrieve( is_fr_yymm, is_to_yymm,  is_year, is_season)
end if

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox( '조회' ,  "조회할 자료가 없습니다.")
ELSE
   MessageBox( '조회오류',  "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm, ls_year

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


If is_year = '%' Then
	ls_year =  '전체'
Else
	ls_year = is_year
End If

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_yymm.Text = '" + String(is_fr_yymm, '@@@@/@@') + ' ~ ' + String(is_to_yymm, '@@@@/@@') + "'" + &            
            "t_year.Text = '" + ls_year + "'" + &
            "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'"
dw_print.Modify(ls_modify)

end event

type cb_close from w_com010_d`cb_close within w_61019_d
end type

type cb_delete from w_com010_d`cb_delete within w_61019_d
end type

type cb_insert from w_com010_d`cb_insert within w_61019_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61019_d
end type

type cb_update from w_com010_d`cb_update within w_61019_d
end type

type cb_print from w_com010_d`cb_print within w_61019_d
end type

type cb_preview from w_com010_d`cb_preview within w_61019_d
end type

type gb_button from w_com010_d`gb_button within w_61019_d
end type

type cb_excel from w_com010_d`cb_excel within w_61019_d
end type

type dw_head from w_com010_d`dw_head within w_61019_d
integer width = 2135
string dataobject = "d_61019_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name

	
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")				
		 
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_61019_d
end type

type ln_2 from w_com010_d`ln_2 within w_61019_d
end type

type dw_body from w_com010_d`dw_body within w_61019_d
string dataobject = "d_61019_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
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

type dw_print from w_com010_d`dw_print within w_61019_d
integer x = 1381
integer y = 532
string dataobject = "d_61019_r01"
end type

type rb_1 from radiobutton within w_61019_d
integer x = 2523
integer y = 240
integer width = 466
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
string text = "매장 판매순위"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_2.TextColor     = 0

dw_body.DataObject  = 'd_61019_d01'
dw_print.DataObject = 'd_61019_r01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type rb_2 from radiobutton within w_61019_d
integer x = 2523
integer y = 328
integer width = 549
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
string text = "브랜드별 비교조회"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0

dw_body.DataObject  = 'd_61019_d02'
dw_print.DataObject = 'd_61019_d02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

