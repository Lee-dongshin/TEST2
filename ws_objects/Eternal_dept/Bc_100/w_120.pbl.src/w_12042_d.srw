$PBExportHeader$w_12042_d.srw
$PBExportComments$품번정보조회
forward
global type w_12042_d from w_com030_e
end type
type dw_2 from datawindow within w_12042_d
end type
type dw_3 from datawindow within w_12042_d
end type
type dw_4 from datawindow within w_12042_d
end type
type dw_1 from datawindow within w_12042_d
end type
type dw_5 from datawindow within w_12042_d
end type
type dw_spec from datawindow within w_12042_d
end type
type dw_size from datawindow within w_12042_d
end type
type dw_6 from datawindow within w_12042_d
end type
end forward

global type w_12042_d from w_com030_e
integer width = 8014
integer height = 3816
dw_2 dw_2
dw_3 dw_3
dw_4 dw_4
dw_1 dw_1
dw_5 dw_5
dw_spec dw_spec
dw_size dw_size
dw_6 dw_6
end type
global w_12042_d w_12042_d

type variables
string  is_style_no, is_style, is_chno, is_color, is_p_no1, is_p_no2, is_p_no3, is_p_no4  , is_washing1, is_washing2, is_washing3, is_washing4
string  is_brand, is_year, is_season, is_sojae, is_item, is_country_cd, is_reg_dt, is_size_array[]
datawindowchild idw_color, idw_color1, idw_brand, idw_season, idw_sojae, idw_item
end variables

forward prototypes
public subroutine wf_set_size ()
public subroutine wf_display_spec ()
end prototypes

public subroutine wf_set_size ();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* 완성 제품 사이즈 정의[head] */
Long i, k, ll_rowcount
DataStore  lds_Source
String     ls_modify, ls_size[]

ll_rowcount = dw_SIZE.RowCount()
lds_Source  = Create DataStore 
lds_Source.DataObject = dw_SIZE.DataObject

dw_SIZE.RowsCopy(1, ll_rowcount, Primary!, lds_Source, 1, Primary!)

lds_Source.SetSort("size A")
lds_Source.Sort()

/* 사이즈 내역 Set */
String ls_null[]

is_size_array = ls_null
k = 0 
FOR i = 1 TO ll_rowcount
	IF i = 1 THEN
		k++
		is_size_array[k] = lds_source.object.size[i]
	ELSEIF lds_source.object.size[i] <> lds_source.object.size[i - 1] THEN
		k++
		is_size_array[k] = lds_source.object.size[i]
	END IF
NEXT

/* tab_1.tabpage_2.dw_2의 head 처리 */
FOR i = 1 TO 10 
	IF i > k THEN 
		ls_modify = "t_size_spec_" + String(i) + ".visible = 0 " + &
		            "size_spec_" + String(i) + ".visible = 0 "
	ELSE
		ls_modify = "t_size_spec_" + String(i) + ".text = '" + is_size_array[i] + "'" + &
                  "t_size_spec_" + String(i) + ".visible = 1 " + & 
						"size_spec_" + String(i) + ".visible = 1 "
	END IF
	dw_5.modify(ls_modify)
NEXT

Destroy  lds_Source


end subroutine

public subroutine wf_display_spec ();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/* dw_spec에있는 내역을 tab_1.tabpage_2.dw_2 로 이관                         */
/*===========================================================================*/
String ls_spec_fg, ls_spec_cd, ls_size, ls_find 
Long   i, j, k,   ll_max      
Long   ll_RowCnt, ll_row
decimal ll_size_spec

ll_RowCnt = dw_spec.RowCount()
IF ll_RowCnt < 1 THEN RETURN

/* 사이즈 갯수 (wf_set_size에서 정의됨)*/
ll_max = UpperBound(is_size_array)    

/* display 용 datawindow 초기화 후 셋팅 */
dw_5.Reset()
FOR i = ll_RowCnt TO 1 STEP -1
	ls_spec_fg = dw_spec.GetitemString(i, "spec_fg") 
	ls_spec_cd = dw_spec.GetitemString(i, "spec_cd") 
	ls_size    = dw_spec.GetitemString(i, "size") 
	ls_find    = "spec_fg = '" + ls_spec_fg + "' and spec_cd = '" + ls_spec_cd + "'"
	ll_row = dw_5.find(ls_find, 1, dw_5.RowCount())
	IF ll_row < 0 THEN 
		RETURN 
	ELSEIF ll_row = 0 THEN
		ll_row = dw_5.insertRow(0)
		dw_5.Setitem(ll_row, "spec_fg", ls_spec_fg)
		dw_5.Setitem(ll_row, "spec_cd", ls_spec_cd)		
		dw_5.Setitem(ll_row, "spec_term", dw_spec.GetitemDecimal(i, "spec_term"))
   END IF 
	/* size assort 내역 검색 */
	FOR j = 1 TO ll_max 
		IF is_size_array[j] = ls_size THEN EXIT
	NEXT 
   /* 해당 사이즈가 없으면 삭제 */
	IF j > ll_max THEN 
//		dw_spec.DeleteRow(i)
	ELSE 
		if MidA(is_style,2,1) <> "K" and ls_spec_fg <> "6" then
			ll_size_spec = dw_spec.GetitemDecimal(i, "size_spec") * 2.54
		else 
			ll_size_spec = dw_spec.GetitemDecimal(i, "size_spec") 
		end if
		
		dw_5.Setitem(ll_row, "size_spec_" + String(j),ll_size_spec)// dw_spec.GetitemDecimal(i, "size_spec"))
	END IF
NEXT

/* 제품 치수내역 정렬 */
dw_5.SetSort("spec_fg A, spec_cd A")
dw_5.Sort()


end subroutine

on w_12042_d.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_3=create dw_3
this.dw_4=create dw_4
this.dw_1=create dw_1
this.dw_5=create dw_5
this.dw_spec=create dw_spec
this.dw_size=create dw_size
this.dw_6=create dw_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.dw_4
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.dw_5
this.Control[iCurrent+6]=this.dw_spec
this.Control[iCurrent+7]=this.dw_size
this.Control[iCurrent+8]=this.dw_6
end on

on w_12042_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.dw_1)
destroy(this.dw_5)
destroy(this.dw_spec)
destroy(this.dw_size)
destroy(this.dw_6)
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


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
dw_5.SetTransObject(SQLCA)
dw_6.SetTransObject(SQLCA)
dw_spec.SetTransObject(SQLCA)
dw_size.SetTransObject(SQLCA)
end event

event open;call super::open;dw_1.Insertrow(0)
//dw_2.Insertrow(0)
dw_3.Insertrow(0)
dw_4.Insertrow(0)
dw_5.Insertrow(0)
end event

type cb_close from w_com030_e`cb_close within w_12042_d
end type

type cb_delete from w_com030_e`cb_delete within w_12042_d
boolean visible = false
end type

type cb_insert from w_com030_e`cb_insert within w_12042_d
boolean visible = false
string text = "복사"
end type

type cb_retrieve from w_com030_e`cb_retrieve within w_12042_d
end type

type cb_update from w_com030_e`cb_update within w_12042_d
boolean visible = false
end type

type cb_print from w_com030_e`cb_print within w_12042_d
boolean visible = false
end type

type cb_preview from w_com030_e`cb_preview within w_12042_d
boolean visible = false
end type

type gb_button from w_com030_e`gb_button within w_12042_d
integer x = 5
end type

type cb_excel from w_com030_e`cb_excel within w_12042_d
boolean visible = false
end type

type dw_head from w_com030_e`dw_head within w_12042_d
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

type ln_1 from w_com030_e`ln_1 within w_12042_d
end type

type ln_2 from w_com030_e`ln_2 within w_12042_d
end type

type dw_list from w_com030_e`dw_list within w_12042_d
integer x = 9
integer width = 987
integer height = 1588
string dataobject = "d_12019_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long  ll_body_rows, ll_detail_rows, ll_rows
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

ll_rows = dw_1.retrieve(is_style, is_chno)

IF ll_rows = 0 THEN
	dw_1.Reset()
	dw_1.Insertrow(0)
END IF


ll_rows = dw_2.retrieve(is_style, is_chno,is_color)

IF ll_rows = 0 THEN
	dw_2.Reset()
	dw_2.Insertrow(0)
END IF

ll_rows = dw_3.retrieve(is_style, is_chno)

IF ll_rows = 0 THEN
	dw_3.Reset()
	dw_3.Insertrow(0)
END IF


ll_rows = dw_4.retrieve(is_style, is_chno,is_color)

IF ll_rows = 0 THEN
	dw_4.Reset()
	dw_4.Insertrow(0)
END IF

ll_rows = dw_6.retrieve(is_style, is_chno,is_color)

IF ll_rows = 0 THEN
	dw_6.Reset()
	dw_6.Insertrow(0)
END IF

ll_rows = dw_spec.Retrieve(is_style, is_chno) 

IF ll_rows = 0 THEN
	dw_4.Reset()
	dw_4.Insertrow(0)
else 
	dw_size.Retrieve(is_style, is_chno) 
   wf_set_size() 
   wf_display_spec()	
END IF



Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com030_e`dw_body within w_12042_d
boolean visible = false
integer x = 5755
integer y = 1352
integer width = 1696
integer height = 2024
boolean titlebar = true
string title = " 취급주의"
string dataobject = "d_12042_d01"
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

type st_1 from w_com030_e`st_1 within w_12042_d
integer x = 1006
integer height = 1592
end type

type dw_print from w_com030_e`dw_print within w_12042_d
integer x = 1527
integer y = 916
string dataobject = "d_12019_d02"
end type

type dw_2 from datawindow within w_12042_d
integer x = 4352
integer y = 456
integer width = 2011
integer height = 2280
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
boolean titlebar = true
string title = "제품정보"
string dataobject = "d_12042_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.Setposition(totop!)
end event

type dw_3 from datawindow within w_12042_d
integer x = 1051
integer y = 1352
integer width = 3287
integer height = 2208
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
boolean titlebar = true
string title = "패브릭가이드"
string dataobject = "d_12042_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.Setposition(totop!)
end event

type dw_4 from datawindow within w_12042_d
integer x = 6382
integer y = 456
integer width = 1838
integer height = 2196
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
boolean titlebar = true
string title = "취급주의"
string dataobject = "d_12042_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.Setposition(totop!)
end event

event constructor;datawindowchild ldw_child

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

type dw_1 from datawindow within w_12042_d
integer x = 1042
integer y = 456
integer width = 3296
integer height = 888
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
boolean titlebar = true
string title = "작지내역"
string dataobject = "d_12042_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.Setposition(totop!)
end event

event constructor;DataWindowChild ldw_child
string ls_year 
This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')


//라빠레트 시즌적용
is_brand = this.getitemstring(1,'brand')
ls_year = this.getitemstring(1,'year')

this.getchild("season",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('003', is_brand, ls_year)

//This.GetChild("sojae", ldw_child)
//ldw_child.SetTransObject(SQLCA)
//ldw_child.Retrieve('%')
//
//This.GetChild("item", ldw_child)
//ldw_child.SetTransObject(SQLCA)
//ldw_child.Retrieve()

This.GetChild("make_type2", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('030')


This.GetChild("out_seq", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('010')

This.GetChild("out_seq2", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('032')

This.GetChild("concept", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('122')

This.GetChild("patt_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('020')



This.GetChild("orgmat_cd2", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('021')



This.GetChild("country_cd2", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('000')

This.GetChild("pay_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('007')

This.GetChild("style_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('126')


end event

type dw_5 from datawindow within w_12042_d
integer x = 4352
integer y = 2756
integer width = 2240
integer height = 800
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "완성제품치수( CM로 변환 )"
string dataobject = "d_12010_d03"
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_child
 
This.GetChild("spec_fg", ldw_child) 
ldw_child.SetTransObject(SQLCA) 
ldw_child.retrieve('124') 

This.GetChild("spec_cd", ldw_child) 
ldw_child.SetTransObject(SQLCA) 
ldw_child.retrieve('125') 

end event

type dw_spec from datawindow within w_12042_d
boolean visible = false
integer x = 3424
integer y = 380
integer width = 1591
integer height = 412
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_12010_spec"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_size from datawindow within w_12042_d
boolean visible = false
integer x = 4553
integer y = 36
integer width = 480
integer height = 380
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_12042_SIZE"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_6 from datawindow within w_12042_d
integer x = 6601
integer y = 2756
integer width = 713
integer height = 448
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "다운 중량"
string dataobject = "d_12042_weight"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

