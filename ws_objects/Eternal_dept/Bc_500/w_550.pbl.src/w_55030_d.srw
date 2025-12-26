$PBExportHeader$w_55030_d.srw
$PBExportComments$시즌별재고현황
forward
global type w_55030_d from w_com010_d
end type
type st_1 from statictext within w_55030_d
end type
type dw_1 from datawindow within w_55030_d
end type
end forward

global type w_55030_d from w_com010_d
integer width = 3694
integer height = 2252
st_1 st_1
dw_1 dw_1
end type
global w_55030_d w_55030_d

type variables
DataWindowChild idw_brand, idw_year, idw_season
String is_brand, is_yymmdd, is_year, is_season, is_view_opt, is_acc_except, is_plan_except, is_dep_except
end variables

on w_55030_d.create
int iCurrent
call super::create
this.st_1=create st_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_1
end on

on w_55030_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_1)
end on

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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
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

is_view_opt = dw_head.GetItemString(1, "view_opt")
is_acc_except = dw_head.GetItemString(1, "acc_except")
is_plan_except = dw_head.GetItemString(1, "plan_except")
is_dep_except = dw_head.GetItemString(1, "dep_except")



return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//@yymmdd		varchar(08),
//@brand 		varchar(01),
//@year 		varchar(04),
//@season		varchar(01),
//@view_opt	varchar(01)
//

il_rows = dw_body.retrieve(is_yymmdd, is_brand, is_year, is_season, is_view_opt, is_acc_except, is_plan_except, is_dep_except)
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55030_d","0")
end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_opt_view

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_view_opt = 'H' Then
	ls_opt_view = '입고기준'
Else
	ls_opt_view = '출고기준'	
End If

	ls_modify =	"t_pg_id.Text      = '" + is_pgm_id    + "'" + &
					"t_user_id.Text    = '" + gs_user_id   + "'" + &
					"t_datetime.Text   = '" + ls_datetime  + "'" + &
					"t_yymmdd.Text     = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
					"t_year.Text       = '" + is_year      + "'" + &
					"t_season.Text     = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
					"t_opt_view.Text    = '" + ls_opt_view + "'" 


dw_print.Modify(ls_modify)
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToBottom")

/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_55030_d
end type

type cb_delete from w_com010_d`cb_delete within w_55030_d
end type

type cb_insert from w_com010_d`cb_insert within w_55030_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55030_d
end type

type cb_update from w_com010_d`cb_update within w_55030_d
end type

type cb_print from w_com010_d`cb_print within w_55030_d
end type

type cb_preview from w_com010_d`cb_preview within w_55030_d
end type

type gb_button from w_com010_d`gb_button within w_55030_d
end type

type cb_excel from w_com010_d`cb_excel within w_55030_d
end type

type dw_head from w_com010_d`dw_head within w_55030_d
integer y = 156
integer height = 200
string dataobject = "d_55030_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_cd1", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_nm", '전체')



//This.GetChild("sojae", idw_sojae)
//idw_sojae.SetTransObject(SQLCA)
//idw_sojae.Retrieve('%')
//idw_sojae.InsertRow(1)
//idw_sojae.SetItem(1, "sojae", '%')
//idw_sojae.SetItem(1, "sojae_nm", '전체')
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

type ln_1 from w_com010_d`ln_1 within w_55030_d
integer beginy = 368
integer endy = 368
end type

type ln_2 from w_com010_d`ln_2 within w_55030_d
integer beginy = 372
integer endy = 372
end type

type dw_body from w_com010_d`dw_body within w_55030_d
integer y = 380
integer width = 3607
integer height = 1636
string dataobject = "d_55030_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_gubn, ls_year, ls_season, ls_brand
decimal ldc_dc_rate

ls_gubn = this.GetitemString(row, "gubn")
ldc_dc_rate = this.GetitemDecimal(row, "dc_rate")
ls_year = this.GetitemString(row, "year")
ls_season = this.GetitemString(row, "season")
ls_brand  = this.GetitemString(row, "brand")

//@yymmdd		varchar(08),
//@brand 		varchar(01),
//@year 		varchar(04),
//@season		varchar(01),
//@view_opt	varchar(01),
//@gubn		varchar(03),
//@dc_rate	decimal(5,2)

		IF LenA(ls_gubn) = 3 and isnull(ls_gubn) <> true  THEN		
			il_rows = dw_1.retrieve(is_yymmdd, ls_brand, ls_year, ls_season, is_view_opt, ls_gubn, ldc_dc_rate)			
			if il_rows > 0 then 
				dw_1.visible = true
				dw_1.SetFocus()				
			end if
		end if	
		
end event

type dw_print from w_com010_d`dw_print within w_55030_d
string dataobject = "d_55030_r01"
end type

type st_1 from statictext within w_55030_d
integer x = 133
integer y = 296
integer width = 1253
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 재고는 순수 국내 상품 수량입니다."
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_55030_d
boolean visible = false
integer x = 1815
integer y = 380
integer width = 1797
integer height = 1636
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "스타일내역조회"
string dataobject = "d_55030_d02"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;String 	ls_search
if row > 0 then 
	choose case dwo.name
		case 'style','style_no'
			ls_search 	= this.GetItemString(row,string(dwo.name))
			if LenA(ls_search) >= 8 then  gf_style_color_size_pic(ls_search, '%','%','0','K')			
	end choose	
end if

end event

