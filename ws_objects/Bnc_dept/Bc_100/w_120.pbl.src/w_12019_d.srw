$PBExportHeader$w_12019_d.srw
$PBExportComments$캐어라벨조회
forward
global type w_12019_d from w_com030_e
end type
end forward

global type w_12019_d from w_com030_e
integer height = 2280
end type
global w_12019_d w_12019_d

type variables
string  is_style_no, is_style, is_chno, is_color, is_p_no1, is_p_no2, is_p_no3, is_p_no4  , is_washing1, is_washing2, is_washing3, is_washing4
string  is_brand, is_year, is_season, is_sojae, is_item, is_country_cd, is_reg_dt
datawindowchild idw_color, idw_color1, idw_brand, idw_season, idw_sojae, idw_item
end variables

on w_12019_d.create
call super::create
end on

on w_12019_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
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


is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_sojae = Trim(dw_head.GetItemString(1, "sojae"))
if IsNull(is_sojae) or is_sojae = "" then
   MessageBox(ls_title,"소재 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = Trim(dw_head.GetItemString(1, "item"))
if IsNull(is_item) or is_item = "" then
   MessageBox(ls_title,"품종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if


is_style_no = Trim(dw_head.GetItemString(1, "style_no"))

is_country_cd = Trim(dw_head.GetItemString(1, "country_cd"))
is_reg_dt = Trim(dw_head.GetItemString(1, "reg_dt"))

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                               */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

is_style =  LeftA(is_style_no,8)
il_rows = dw_list.retrieve(is_brand,is_year,is_season,is_sojae,is_item,is_style,is_country_cd,is_reg_dt)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSE
   dw_body.InsertRow(0)
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12019_d","0")
end event

type cb_close from w_com030_e`cb_close within w_12019_d
end type

type cb_delete from w_com030_e`cb_delete within w_12019_d
boolean visible = false
end type

type cb_insert from w_com030_e`cb_insert within w_12019_d
boolean visible = false
string text = "복사"
end type

type cb_retrieve from w_com030_e`cb_retrieve within w_12019_d
end type

type cb_update from w_com030_e`cb_update within w_12019_d
boolean visible = false
end type

type cb_print from w_com030_e`cb_print within w_12019_d
end type

type cb_preview from w_com030_e`cb_preview within w_12019_d
end type

type gb_button from w_com030_e`gb_button within w_12019_d
integer x = 5
end type

type cb_excel from w_com030_e`cb_excel within w_12019_d
end type

type dw_head from w_com030_e`dw_head within w_12019_d
integer x = 18
integer y = 188
integer height = 228
string dataobject = "d_21093_h01"
end type

event dw_head::constructor;call super::constructor;

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',is_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')


This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(is_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')



end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name


	CASE "brand", "year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		dw_head.accepttext()
		is_brand = dw_head.getitemstring(1,'brand')
		is_year = dw_head.getitemstring(1,'year')
		
		this.getchild("season",idw_season)
		idw_season.settransobject(sqlca)
		idw_season.retrieve('003', is_brand, is_year)

		This.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', is_brand)
		idw_sojae.insertrow(1)
		idw_sojae.Setitem(1, "sojae", "%")
		idw_sojae.Setitem(1, "sojae_nm", "전체")
		
		This.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve(is_brand)
		idw_item.insertrow(1)
		idw_item.Setitem(1, "item", "%")
		idw_item.Setitem(1, "item_nm", "전체")
			
END CHOOSE

end event

type ln_1 from w_com030_e`ln_1 within w_12019_d
end type

type ln_2 from w_com030_e`ln_2 within w_12019_d
end type

type dw_list from w_com030_e`dw_list within w_12019_d
integer x = 9
integer width = 987
string dataobject = "d_12019_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long  ll_body_rows, ll_detail_rows
IF row <= 0 THEN Return

//IF ib_changed THEN 
//  	CHOOSE CASE gf_update_yn(Parent.title)
//		CASE 1
//			IF Parent.Trigger Event ue_update() < 1 THEN
//				RETURN 1
//			END IF		
//		CASE 3
//			RETURN 1
//	END CHOOSE
//END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_style = This.GetItemString(row, 'style') /* DataWindow에 Key 항목을 가져온다 */
is_chno  = This.GetItemString(row, 'chno') /* DataWindow에 Key 항목을 가져온다 */
is_color = This.GetItemString(row, 'color') /* DataWindow에 Key 항목을 가져온다 */


IF IsNull(is_style) or IsNull(is_chno)  or IsNull(is_color)  THEN return

il_rows = dw_body.retrieve(is_style, is_chno,is_color)


//idw_color1.Retrieve(is_style,is_chno)

IF il_rows = 0 THEN
	dw_body.Reset()
	dw_body.Insertrow(0)
END IF

//dw_body.Setitem(1, "style", is_style)
//dw_body.Setitem(1, "chno", is_chno)
//dw_body.Setitem(1, "color", is_color)


Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com030_e`dw_body within w_12019_d
integer x = 1033
integer width = 2560
string dataobject = "d_12019_d02"
boolean vscrollbar = false
end type

event dw_body::constructor;call super::constructor;
datawindowchild ldw_child

this.getchild("COLOR",idw_color1)
idw_color1.settransobject(sqlca)
idw_color1.InsertRow(1)



this.getchild("mat_gubn1",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn2",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn3",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn4",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')


this.getchild("mat_gubn5",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn6",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn7",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn8",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_nm1",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm2",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm3",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm4",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm5",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm6",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm7",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm8",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("country_cd",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('214')

this.getchild("care_code",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("washing_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()




end event

event dw_body::clicked;call super::clicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
String 	ls_search
if row > 0 then 
	choose case dwo.name
		case 'style_pic'
			ls_search 	= this.GetItemString(row,'style')
			if LenA(ls_search) >= 8 then gf_style_color_pic(ls_search, '%','%')			
	end choose	
end if

end event

type st_1 from w_com030_e`st_1 within w_12019_d
integer x = 1006
end type

type dw_print from w_com030_e`dw_print within w_12019_d
integer x = 1527
integer y = 916
string dataobject = "d_12019_d02"
end type

