$PBExportHeader$w_cu136_d.srw
$PBExportComments$케어라벨조회
forward
global type w_cu136_d from w_com020_d
end type
end forward

global type w_cu136_d from w_com020_d
integer width = 3653
integer height = 2236
end type
global w_cu136_d w_cu136_d

type variables
string  is_style_no, is_style, is_chno, is_color, is_p_no1, is_p_no2, is_p_no3, is_p_no4  , is_washing1, is_washing2, is_washing3, is_washing4, is_washing5, is_washing6
string  is_brand, is_year, is_season, is_sojae, is_item, is_country_cd, is_reg_dt, is_mat_cd, is_mat_color

//string  as_mat_nm1, as_mat_rate1, as_mat_nm2,as_mat_rate2, as_mat_nm3,as_mat_rate3, as_mat_nm4, as_mat_rate4, as_mat_nm5, as_mat_rate5  
datawindowchild idw_color, idw_color1, idw_brand, idw_season, idw_sojae, idw_item, idw_fabric_by, idw_sect_nm, idw_country_cd
end variables

on w_cu136_d.create
call super::create
end on

on w_cu136_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
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
is_mat_cd = Trim(dw_head.GetItemString(1, "mat_cd"))
return true
end event

event ue_retrieve();call super::ue_retrieve;IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

is_style =  LeftA(is_style_no,8)
il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_style, gs_shop_cd)
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

event open;call super::open;dw_body.Insertrow(0)		
end event

type cb_close from w_com020_d`cb_close within w_cu136_d
end type

type cb_delete from w_com020_d`cb_delete within w_cu136_d
end type

type cb_insert from w_com020_d`cb_insert within w_cu136_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_cu136_d
end type

type cb_update from w_com020_d`cb_update within w_cu136_d
end type

type cb_print from w_com020_d`cb_print within w_cu136_d
end type

type cb_preview from w_com020_d`cb_preview within w_cu136_d
end type

type gb_button from w_com020_d`gb_button within w_cu136_d
integer width = 3598
end type

type dw_head from w_com020_d`dw_head within w_cu136_d
integer width = 3575
string dataobject = "d_cu136_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%')
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')


This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%')
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')



end event

type ln_1 from w_com020_d`ln_1 within w_cu136_d
integer endx = 3611
end type

type ln_2 from w_com020_d`ln_2 within w_cu136_d
integer endx = 3611
end type

type dw_list from w_com020_d`dw_list within w_cu136_d
integer height = 1596
string dataobject = "d_cu136_l01"
end type

event dw_list::clicked;call super::clicked;long  ll_body_rows, ll_detail_rows
string ls_mat_nm1, ls_remark1, ls_country_nm, ls_sect_nm, ls_flag, ls_cust_nm, ls_sojae
IF row <= 0 THEN Return


This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_style = This.GetItemString(row, 'style') /* DataWindow에 Key 항목을 가져온다 */
is_chno  = This.GetItemString(row, 'chno') /* DataWindow에 Key 항목을 가져온다 */
is_color = This.GetItemString(row, 'color') /* DataWindow에 Key 항목을 가져온다 */
ls_sojae = This.GetItemString(row, 'sojae') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_style) or IsNull(is_chno)  or IsNull(is_color)  THEN return

il_rows = dw_body.retrieve(is_style, is_chno,is_color)


idw_color1.Retrieve(is_style,is_chno)
IF il_rows = 0 THEN
	dw_body.Reset()
	dw_body.Insertrow(0)		
END IF
ls_country_nm = dw_body.getitemstring(1,"country_cd")
ls_cust_nm = dw_body.getitemstring(1,"cust_nm")
if upper(ls_country_nm) <> 'KOREA' then 
	dw_body.object.t_importer.text = "수입자:" + ls_cust_nm
else
	dw_body.object.t_importer.text = "' '"
end if
This.GetChild("sect_nm", idw_sect_nm)
idw_sect_nm.SetTransObject(SQLCA)
idw_sect_nm.retrieve(ls_country_nm)
idw_sect_nm.InsertRow(0)

			
dw_body.Setitem(1, "style", is_style)
dw_body.Setitem(1, "chno" , is_chno)
dw_body.Setitem(1, "color", is_color)


Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_d`dw_body within w_cu136_d
integer width = 2839
integer height = 1592
string dataobject = "d_cu136_d01"
end type

event dw_body::buttonclicked;call super::buttonclicked;long  ll_body_rows, ll_detail_rows
string ls_mat_nm1, ls_remark1, ls_country_nm, ls_sect_nm, ls_flag
string ls_mat_cd, ls_mat_color
datawindowchild ldw_child
CHOOSE CASE dwo.name

   CASE "cb_in"

		
	dw_body.dataobject = "d_cu136_d02"  //속감등록
	dw_body.SetTransObject(SQLCA)
	
	this.object.cb_mat_info.visible = false
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
	
 	this.getchild("mat_gubn9",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('212')
	this.getchild("mat_gubn10",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('212')
	this.getchild("mat_gubn11",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('212')
	this.getchild("mat_gubn12",ldw_child)
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
	
	this.getchild("mat_nm9",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('213')
	
	this.getchild("mat_nm10",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('213')
	
	this.getchild("mat_nm11",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('213')
	
	this.getchild("mat_nm12",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('213')
	
	this.getchild("country_cd",idw_country_cd)
	idw_country_cd.settransobject(sqlca)
	idw_country_cd.retrieve('214')
	
	this.getchild("care_code",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve()
	
	this.getchild("washing_type",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve()
	
	this.getchild("fabric_by",idw_fabric_by)
	idw_fabric_by.settransobject(sqlca)
	idw_fabric_by.retrieve('214')
	
	This.GetChild("sect_nm", idw_sect_nm)
	idw_sect_nm.SetTransObject(SQLCA)
	idw_sect_nm.retrieve('%')
	idw_sect_nm.InsertRow(0)

	
	is_style = dw_list.GetItemString(dw_list.getrow(), 'style') /* DataWindow에 Key 항목을 가져온다 */
	is_chno  = dw_list.GetItemString(dw_list.getrow(), 'chno') /* DataWindow에 Key 항목을 가져온다 */
	is_color = dw_list.GetItemString(dw_list.getrow(), 'color') /* DataWindow에 Key 항목을 가져온다 */
	
	
	IF IsNull(is_style) or IsNull(is_chno)  or IsNull(is_color)  THEN return
	
	il_rows = dw_body.retrieve(is_style, is_chno,is_color)
	
	
	idw_color1.Retrieve(is_style,is_chno)
	IF il_rows = 0 THEN
		dw_body.Reset()
		dw_body.Insertrow(0)		
	END IF
	
	ls_country_nm = dw_body.getitemstring(1,"country_cd")
	This.GetChild("sect_nm", idw_sect_nm)
	idw_sect_nm.SetTransObject(SQLCA)
	idw_sect_nm.retrieve(ls_country_nm)
	idw_sect_nm.InsertRow(0)
	
				
	dw_body.Setitem(1, "style", is_style)
	dw_body.Setitem(1, "chno" , is_chno)
	dw_body.Setitem(1, "color", is_color)
	
	
	
	
	Parent.Trigger Event ue_button(7, il_rows)
	Parent.Trigger Event ue_msg(1, il_rows)
	
	
	
   CASE "cb_out"		
		

		dw_body.dataobject = "d_cu136_d01"  //겉감등록		 
		dw_body.SetTransObject(SQLCA)
									

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

this.getchild("mat_gubn9",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn10",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn11",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn12",ldw_child)
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

this.getchild("mat_nm9",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm10",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm11",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm12",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')


this.getchild("care_code",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("washing_type",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("fabric_by",idw_fabric_by)
idw_fabric_by.settransobject(sqlca)
idw_fabric_by.retrieve('214')

This.GetChild("sect_nm", idw_sect_nm)
idw_sect_nm.SetTransObject(SQLCA)
idw_sect_nm.retrieve('%')
idw_sect_nm.InsertRow(0)

this.getchild("country_cd",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('214')

this.getchild("care_lable",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('216')
		
		is_style = dw_list.GetItemString(dw_list.getrow(), 'style') /* DataWindow에 Key 항목을 가져온다 */
		is_chno  = dw_list.GetItemString(dw_list.getrow(), 'chno') /* DataWindow에 Key 항목을 가져온다 */
		is_color = dw_list.GetItemString(dw_list.getrow(), 'color') /* DataWindow에 Key 항목을 가져온다 */
		
		
		IF IsNull(is_style) or IsNull(is_chno)  or IsNull(is_color)  THEN return
		
		il_rows = dw_body.retrieve(is_style, is_chno,is_color)

		
		idw_color1.Retrieve(is_style,is_chno)
		IF il_rows = 0 THEN
			dw_body.Reset()
			dw_body.Insertrow(0)		
		END IF
		ls_country_nm = dw_body.getitemstring(1,"country_cd")
		This.GetChild("sect_nm", idw_sect_nm)
		idw_sect_nm.SetTransObject(SQLCA)
		idw_sect_nm.retrieve(ls_country_nm)
		idw_sect_nm.InsertRow(0)
		
					
		dw_body.Setitem(1, "style", is_style)
		dw_body.Setitem(1, "chno" , is_chno)
		dw_body.Setitem(1, "color", is_color)
		
		
		
		
		Parent.Trigger Event ue_button(7, il_rows)
		Parent.Trigger Event ue_msg(1, il_rows)

END CHOOSE



end event

event dw_body::constructor;call super::constructor;datawindowchild ldw_child

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

this.getchild("mat_gubn9",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn10",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn11",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn12",ldw_child)
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

this.getchild("mat_nm9",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm10",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm11",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm12",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')


this.getchild("care_code",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("washing_type",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("fabric_by",idw_fabric_by)
idw_fabric_by.settransobject(sqlca)
idw_fabric_by.retrieve('214')

This.GetChild("sect_nm", idw_sect_nm)
idw_sect_nm.SetTransObject(SQLCA)
idw_sect_nm.retrieve('%')
idw_sect_nm.InsertRow(0)

this.getchild("country_cd",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('214')

this.getchild("care_lable",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('216')

end event

type st_1 from w_com020_d`st_1 within w_cu136_d
integer height = 1600
end type

type dw_print from w_com020_d`dw_print within w_cu136_d
end type

