$PBExportHeader$w_61024_d.srw
$PBExportComments$전체수불원가현황
forward
global type w_61024_d from w_com010_d
end type
type tab_1 from tab within w_61024_d
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tab_1 from tab within w_61024_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_1 from datawindow within w_61024_d
end type
type st_1 from statictext within w_61024_d
end type
end forward

global type w_61024_d from w_com010_d
tab_1 tab_1
dw_1 dw_1
st_1 st_1
end type
global w_61024_d w_61024_d

type variables
String	is_brand, is_year, is_season, is_yymm, is_to_yymm
DataWindowChild idw_brand, idw_year, idw_season

end variables

on w_61024_d.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_1=create dw_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.st_1
end on

on w_61024_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_1)
destroy(this.st_1)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")

dw_1.SetTransObject(SQLCA)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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


is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if


is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_to_yymm = dw_head.GetItemString(1, "to_yymm")
if IsNull(is_to_yymm) or Trim(is_to_yymm) = "" then
   MessageBox(ls_title,"기준월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   return false
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_yymm, is_to_yymm)
	il_rows = dw_1.retrieve(is_brand, is_year, is_season, is_yymm, is_to_yymm)	
	IF il_rows > 0 THEN
		dw_body.visible = true
		dw_1.visible = false
		dw_body.SetFocus()
	ELSEIF il_rows = 0 THEN
		MessageBox("조회", "조회할 자료가 없습니다.")
	ELSE
		MessageBox("조회오류", "조회 실패 하였습니다.")
	END IF


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)
end event

event ue_preview();This.Trigger Event ue_title ()

dw_print.retrieve(is_brand, is_year, is_season, is_yymm, is_to_yymm)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_yymm



IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_yymm = is_yymm + "-" + is_to_yymm

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_yymm.Text = '" + ls_yymm + "'" + &
				"t_year.Text = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "'" + &
				"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" 				 

dw_print.Modify(ls_modify)

end event

type cb_close from w_com010_d`cb_close within w_61024_d
end type

type cb_delete from w_com010_d`cb_delete within w_61024_d
end type

type cb_insert from w_com010_d`cb_insert within w_61024_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61024_d
end type

type cb_update from w_com010_d`cb_update within w_61024_d
end type

type cb_print from w_com010_d`cb_print within w_61024_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_61024_d
end type

type gb_button from w_com010_d`gb_button within w_61024_d
end type

type cb_excel from w_com010_d`cb_excel within w_61024_d
end type

type dw_head from w_com010_d`dw_head within w_61024_d
integer height = 136
string dataobject = "d_61024_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.insertrow(1)
idw_season.setitem(1, "inter_cd", "%")
idw_season.setitem(1, "inter_cd1", "%")
idw_season.setitem(1, "inter_nm", "전체")
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

type ln_1 from w_com010_d`ln_1 within w_61024_d
integer beginy = 308
integer endy = 308
end type

type ln_2 from w_com010_d`ln_2 within w_61024_d
integer beginy = 312
integer endy = 312
end type

type dw_body from w_com010_d`dw_body within w_61024_d
integer x = 23
integer y = 424
integer width = 3566
integer height = 1596
string dataobject = "d_61024_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_61024_d
string dataobject = "d_61024_d03"
end type

type tab_1 from tab within w_61024_d
integer x = 9
integer y = 324
integer width = 3593
integer height = 1712
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

event clicked;
  	CHOOSE CASE index
		CASE 1
			dw_body.visible = true
			dw_1.visible = false


		CASE 2
			dw_body.visible = false
			dw_1.visible = true

	END CHOOSE

	
end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3557
integer height = 1600
long backcolor = 79741120
string text = "창고수불원가현황"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3557
integer height = 1600
long backcolor = 79741120
string text = "매장수불원가현황"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type dw_1 from datawindow within w_61024_d
boolean visible = false
integer x = 23
integer y = 424
integer width = 3566
integer height = 1596
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_61024_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_61024_d
integer x = 2944
integer y = 344
integer width = 645
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "※ 단위 :  천원"
alignment alignment = right!
boolean focusrectangle = false
end type

