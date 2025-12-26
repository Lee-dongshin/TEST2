$PBExportHeader$w_12041_d.srw
$PBExportComments$생산의뢰현황(잡화)
forward
global type w_12041_d from w_com010_d
end type
type rb_style from radiobutton within w_12041_d
end type
type rb_cust from radiobutton within w_12041_d
end type
end forward

global type w_12041_d from w_com010_d
integer width = 4032
rb_style rb_style
rb_cust rb_cust
end type
global w_12041_d w_12041_d

type variables
DataWindowChild idw_brand, idw_season, idw_make_type, idw_sojae, idw_color, ldw_child 
String is_brand, is_year, is_season, is_sojae, is_make_type, is_fr_ymd, is_to_ymd, is_main_gubn, is_orderby = '0', is_ip_fr_ymd, is_ip_to_ymd

end variables

on w_12041_d.create
int iCurrent
call super::create
this.rb_style=create rb_style
this.rb_cust=create rb_cust
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_style
this.Control[iCurrent+2]=this.rb_cust
end on

on w_12041_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_style)
destroy(this.rb_cust)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.27                                                  */	
/* 수정일      : 2001.12.27                                                  */
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





if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif  ( gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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





is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
is_sojae = dw_head.GetItemString(1, "sojae")
is_main_gubn = dw_head.GetItemString(1, "main_gubn")

is_make_type = dw_head.GetItemString(1, "make_type")
if IsNull(is_make_type) or Trim(is_make_type) = "" then
   MessageBox(ls_title,"생산 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("make_type")
   return false
end if

is_fr_ymd = String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd')
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"의뢰 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd')
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"의뢰 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

if is_to_ymd < is_fr_ymd then
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if




is_ip_fr_ymd = dw_head.GetItemString(1, "ip_fr_ymd")
if IsNull(is_ip_fr_ymd) or Trim(is_ip_fr_ymd) = "" then
   MessageBox(ls_title,"의뢰 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("ip_fr_ymd")
   return false
end if

is_ip_to_ymd = dw_head.GetItemString(1, "ip_to_ymd")
if IsNull(is_ip_to_ymd) or Trim(is_ip_to_ymd) = "" then
   MessageBox(ls_title,"의뢰 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("ip_to_ymd")
   return false
end if

if is_ip_to_ymd < is_ip_fr_ymd then
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("ip_to_ymd")
   return false
end if



return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.27                                                  */	
/* 수정일      : 2001.12.27                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


//if is_orderby = '0' and dw_body.dataobject <> "d_12041_d01" then 
//	dw_body.dataobject  = "d_12041_d01"
//	dw_print.dataobject = "d_12041_r01"
//	dw_body.SetTransObject(SQLCA)
//	dw_print.SetTransObject(SQLCA)
//elseif is_orderby = '1' and dw_body.dataobject <> "d_12041_d02" then 
//	dw_body.dataobject  = "d_12041_d02"
//	dw_print.dataobject = "d_12041_r02"
//	dw_body.SetTransObject(SQLCA)
//	dw_print.SetTransObject(SQLCA)	
//end if


il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_make_type, is_fr_ymd, is_to_ymd, is_orderby, is_main_gubn, is_ip_fr_ymd, is_ip_to_ymd)

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

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.27                                                  */	
/* 수정일      : 2001.12.27                                                  */
/*===========================================================================*/
datetime ld_datetime
String ls_modify, ls_datetime
String ls_brand,  ls_season, ls_sojae, ls_make_type, ls_ymd

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
ls_brand    =  "브 랜 드 : " + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") 
ls_season   =  "시  즌 : " + is_year + "년도 " + &
               idw_season.GetitemString(idw_season.GetRow(), "inter_display")  
ls_sojae    =  "소  재 : " + idw_sojae.GetitemString(idw_sojae.GetRow(), "sojae_display") 

ls_make_type = "생산형태 : " + idw_make_type.GetitemString(idw_make_type.GetRow(), "inter_display") 
ls_ymd      = "의뢰일 : " + String(is_fr_ymd, '@@@@/@@/@@') + " ~~ " + String(is_to_ymd, '@@@@/@@/@@')



ls_modify =	"t_pg_id.Text     = '" + is_pgm_id + "'" + &
            "t_user_id.Text   = '" + gs_user_id + "'" + &
				"t_datetime.Text  = '" + ls_datetime + "'" + &
				"t_brand.Text     = '" + ls_brand + "'" + &
            "t_season.Text    = '" + ls_season + "'" + &
				"t_sojae.Text    = '" + ls_sojae + "'" + &
				"t_make_type.Text = '" + ls_make_type + "'" + &
				"t_ymd.Text       = '" + ls_ymd + "'"


dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12041_d","0")
end event

event open;call super::open;datetime ld_datetime


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"ip_fr_ymd",string(ld_datetime,"yyyymmdd"))
	dw_head.setitem(1,"ip_to_ymd",string(ld_datetime,"yyyymmdd"))
end if
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

type cb_close from w_com010_d`cb_close within w_12041_d
integer x = 3566
end type

type cb_delete from w_com010_d`cb_delete within w_12041_d
end type

type cb_insert from w_com010_d`cb_insert within w_12041_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_12041_d
integer x = 3223
end type

type cb_update from w_com010_d`cb_update within w_12041_d
end type

type cb_print from w_com010_d`cb_print within w_12041_d
end type

type cb_preview from w_com010_d`cb_preview within w_12041_d
end type

type gb_button from w_com010_d`gb_button within w_12041_d
integer width = 3945
end type

type cb_excel from w_com010_d`cb_excel within w_12041_d
end type

type dw_head from w_com010_d`dw_head within w_12041_d
integer width = 3904
integer height = 224
string dataobject = "d_12041_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTRansObject(SQLCA)
idw_sojae.Retrieve('%',gs_brand)
idw_sojae.insertrow(1)
idw_sojae.Setitem(1, "sojae", "%")
idw_sojae.Setitem(1, "sojae_nm", "전체")


This.GetChild("make_type", idw_make_type)
idw_make_type.SetTRansObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.insertrow(1)
idw_make_type.Setitem(1, "inter_cd", "%")
idw_make_type.Setitem(1, "inter_nm", "전체")


end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name


	CASE "brand", "year"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		
		//라빠레트 시즌적용
		dw_head.accepttext()
		
		is_brand = dw_head.getitemstring(1,'brand')
		is_year = dw_head.getitemstring(1,'year')
		
		this.getchild("season",idw_season)
		idw_season.settransobject(sqlca)
		idw_season.retrieve('003', is_brand, is_year)
		idw_season.insertrow(1)
		idw_season.Setitem(1, "inter_cd", "%")
		idw_season.Setitem(1, "inter_nm", "전체")
	
		This.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', is_brand)
		idw_sojae.insertrow(1)
		idw_sojae.Setitem(1, "sojae", "%")
		idw_sojae.Setitem(1, "sojae_nm", "전체")
//	
//	This.GetChild("item", idw_item)
//	idw_item.SetTransObject(SQLCA)
//	idw_item.Retrieve(data)
//	idw_item.insertrow(1)
//	idw_item.Setitem(1, "item", "%")
//	idw_item.Setitem(1, "item_nm", "전체")
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_12041_d
integer beginx = 32
integer beginy = 424
integer endx = 3936
integer endy = 424
end type

type ln_2 from w_com010_d`ln_2 within w_12041_d
integer beginx = 32
integer beginy = 428
integer endx = 3936
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_12041_d
integer y = 444
integer width = 3945
integer height = 1564
string dataobject = "d_12041_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_brand, ldw_year, ldw_make_type

This.GetChild("brand", ldw_brand)
ldw_brand.SetTransObject(SQLCA)
ldw_brand.Retrieve('001')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()

This.GetChild("style_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('126')
end event

type dw_print from w_com010_d`dw_print within w_12041_d
integer x = 165
integer y = 568
string dataobject = "d_12041_r01"
end type

event dw_print::constructor;call super::constructor;datawindowchild ldw_brand, ldw_year, ldw_make_type

This.GetChild("brand", ldw_brand)
ldw_brand.SetTransObject(SQLCA)
ldw_brand.Retrieve('001')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)



This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()


This.GetChild("style_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('126')

end event

type rb_style from radiobutton within w_12041_d
integer x = 3214
integer y = 308
integer width = 283
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
string text = "제품별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;datawindowchild ldw_brand, ldw_year, ldw_make_type


is_orderby = '0'

dw_body.dataobject  = "d_12041_d01"
dw_print.dataobject = "d_12041_r01"
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_body.GetChild("brand", ldw_brand)
ldw_brand.SetTransObject(SQLCA)
ldw_brand.Retrieve('001')

dw_body.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)

dw_body.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()

dw_body.GetChild("style_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('126')



dw_print.GetChild("brand", ldw_brand)
ldw_brand.SetTransObject(SQLCA)
ldw_brand.Retrieve('001')

dw_print.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)

dw_print.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()

dw_print.GetChild("style_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('126')

end event

type rb_cust from radiobutton within w_12041_d
integer x = 3561
integer y = 308
integer width = 283
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
string text = "업체별"
borderstyle borderstyle = stylelowered!
end type

event clicked;datawindowchild ldw_brand, ldw_year, ldw_make_type

is_orderby = '1'

dw_body.dataobject  = "d_12041_d02"
dw_print.dataobject = "d_12041_r02"
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)	


dw_body.GetChild("brand", ldw_brand)
ldw_brand.SetTransObject(SQLCA)
ldw_brand.Retrieve('001')

dw_body.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)

dw_body.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()

dw_body.GetChild("style_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('126')


dw_print.GetChild("brand", ldw_brand)
ldw_brand.SetTransObject(SQLCA)
ldw_brand.Retrieve('001')

dw_print.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)

dw_print.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()

dw_print.GetChild("style_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('126')
end event

