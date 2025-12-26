$PBExportHeader$w_44004_d.srw
$PBExportComments$창고재고현황조회
forward
global type w_44004_d from w_com010_d
end type
end forward

global type w_44004_d from w_com010_d
integer width = 3675
integer height = 2272
string title = "창고재고현황"
end type
global w_44004_d w_44004_d

type variables
DataWindowChild idw_house_cd, idw_brand, idw_year, idw_season, idw_sojae, idw_item, idw_color, idw_size,idw_class
string  is_yymmdd, is_brand, is_house_cd,  is_year , is_season, is_sojae, is_item, is_style_no, is_chno
string  is_color, is_size, is_class
end variables

on w_44004_d.create
call super::create
end on

on w_44004_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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

is_house_cd = dw_head.GetItemString(1, "house")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house")
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

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
is_sojae = "%"
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
is_item = "%"
end if

is_style_no = dw_head.GetItemString(1, "style_no")
if IsNull(is_style_no) or Trim(is_style_no) = "" then
is_style_no = "%"
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
is_chno = "%"
end if

is_color = dw_head.GetItemString(1, "color")
if IsNull(is_color) or Trim(is_color) = "" then
is_color = "%"
end if

is_size = dw_head.GetItemString(1, "size")
if IsNull(is_size) or Trim(is_size) = "" then
is_size = "%"
end if

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_44004_d01 '20011215' , 'n', '010000', '2001' ,'w', '%', 'o','417','%', '%', '%'
//messagebox("is_yymmdd", is_yymmdd)
//messagebox("is_brand", is_brand)
//messagebox("is_house_cd", is_house_cd)
//messagebox("is_year", is_year)
//messagebox("is_season", is_season)
//messagebox("is_sojae", is_sojae)
//messagebox("is_item", is_item)
//messagebox("is_style_no", is_style_no)
//messagebox("is_chno", is_chno)
//messagebox("is_color", is_color)
//messagebox("is_size", is_size)


il_rows = dw_body.retrieve(is_yymmdd, is_brand, is_house_cd, is_year, is_season, is_sojae, &
          is_item, is_style_no, is_chno, is_color,is_size)
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_44004_d","0")
end event

type cb_close from w_com010_d`cb_close within w_44004_d
end type

type cb_delete from w_com010_d`cb_delete within w_44004_d
end type

type cb_insert from w_com010_d`cb_insert within w_44004_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_44004_d
end type

type cb_update from w_com010_d`cb_update within w_44004_d
end type

type cb_print from w_com010_d`cb_print within w_44004_d
end type

type cb_preview from w_com010_d`cb_preview within w_44004_d
end type

type gb_button from w_com010_d`gb_button within w_44004_d
end type

type cb_excel from w_com010_d`cb_excel within w_44004_d
end type

type dw_head from w_com010_d`dw_head within w_44004_d
integer y = 156
integer height = 392
string dataobject = "d_44004_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("house", idw_house_cd )
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('%')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%')

This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%')

This.GetChild("color", idw_color )
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve('%')

This.GetChild("size", idw_size )
idw_size.SetTransObject(SQLCA)
idw_size.Retrieve('%')

This.GetChild("class", idw_class )
idw_class.SetTransObject(SQLCA)
idw_class.Retrieve('401')




end event

type ln_1 from w_com010_d`ln_1 within w_44004_d
integer beginx = 5
integer beginy = 548
integer endx = 3625
integer endy = 548
end type

type ln_2 from w_com010_d`ln_2 within w_44004_d
integer beginy = 552
integer endy = 552
end type

type dw_body from w_com010_d`dw_body within w_44004_d
integer y = 564
integer height = 1472
string dataobject = "d_44004_d01"
boolean hscrollbar = true
boolean livescroll = false
end type

event dw_body::constructor;call super::constructor;This.of_SetSort(false)
end event

type dw_print from w_com010_d`dw_print within w_44004_d
integer x = 2414
integer y = 1620
end type

