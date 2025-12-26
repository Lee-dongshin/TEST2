$PBExportHeader$w_12018_d.srw
$PBExportComments$Reorder Style조회
forward
global type w_12018_d from w_com010_d
end type
type dw_1 from datawindow within w_12018_d
end type
type st_1 from statictext within w_12018_d
end type
type cbx_chn from checkbox within w_12018_d
end type
end forward

global type w_12018_d from w_com010_d
integer width = 3685
integer height = 2288
dw_1 dw_1
st_1 st_1
cbx_chn cbx_chn
end type
global w_12018_d w_12018_d

type variables
DataWindowChild idw_brand, idw_season, idw_sojae, idw_item
String is_brand, is_year, is_season, is_sojae, is_item, is_chn
end variables

forward prototypes
public function long wf_body_set (long al_rows)
end prototypes

public function long wf_body_set (long al_rows);/* dw_body에 dw_1에서 조회된 data를 셋팅 */
Long i, ll_col_cnt = 0, ll_rows
ll_rows = dw_body.InsertRow(0)
For i = 1 To al_rows
	ll_col_cnt++
	If ll_col_cnt > 5    Then
		ll_rows = dw_body.InsertRow(0)
		If ll_rows <= 0 Then Return -1
		ll_col_cnt = 1
	End If
	dw_body.SetItem(ll_rows, "style" + String(ll_col_cnt), dw_1.GetItemString(i, "style"))
	dw_body.SetItem(ll_rows, "chno" + String(ll_col_cnt), dw_1.GetItemString(i, "chno"))
	dw_body.SetItem(ll_rows, "style_pic" + String(ll_col_cnt), dw_1.GetItemString(i, "style_pic"))
	dw_body.SetItem(ll_rows, "mat_nm" + String(ll_col_cnt), dw_1.GetItemString(i, "mat_nm"))	
	dw_body.SetItem(ll_rows, "cust_nm" + String(ll_col_cnt), dw_1.GetItemString(i, "cust_nm"))	
	dw_body.SetItem(ll_rows, "tag_price" + String(ll_col_cnt), dw_1.GetItemdecimal(i,"tag_price"))
	dw_body.SetItem(ll_rows, "ord_ymd" + String(ll_col_cnt), dw_1.GetItemString(i, "ord_ymd"))
	dw_body.SetItem(ll_rows, "dlvy_ymd" + String(ll_col_cnt), dw_1.GetItemString(i, "dlvy_ymd"))	
	dw_body.SetItem(ll_rows, "out_ymd" + String(ll_col_cnt), dw_1.GetItemString(i, "out_ymd"))
	dw_body.SetItem(ll_rows, "style_info" + String(ll_col_cnt), dw_1.GetItemString(i, "style_info"))

Next

Return ll_rows


end function

on w_12018_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_1=create st_1
this.cbx_chn=create cbx_chn
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cbx_chn
end on

on w_12018_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.cbx_chn)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_1.retrieve(is_brand,is_year,is_season,is_sojae,is_item,is_chn)
dw_body.Reset()

dw_body.SetRedraw(False)
IF il_rows > 0 THEN
	If wf_body_set(il_rows) <= 0 Then 
		MessageBox("조회오류", "데이터 셋팅에 실패 하였습니다.")
		il_rows = -1
	Else
		This.Trigger Event ue_title()
	   dw_body.SetFocus()
	End If
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF
dw_body.SetRedraw(True)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)


end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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
   MessageBox(ls_title,"소재를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = Trim(dw_head.GetItemString(1, "item"))
if IsNull(is_item) or is_item = "" then
   MessageBox(ls_title,"복종을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

if cbx_chn.checked then 
	is_chn = "1"
else 
	is_chn = "0"
end if

return true

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.19                                                  */	
/* 수정일      : 2002.01.19                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_sale_type, ls_sort_fg, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


ls_modify =	"t_pg_id.Text     = '" + is_pgm_id + "'" + &
            "t_user_id.Text   = '" + gs_user_id + "'" + &
            "t_datetime.Text  = '" + ls_datetime + "'" + &
            "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_year.Text      = '" + is_year + "'" + &
            "t_season.Text    = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_sojae.Text     = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_display") + "'" + &
				"t_item.Text     = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'" 

dw_print.Modify(ls_modify)


end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12015_d","0")
end event

type cb_close from w_com010_d`cb_close within w_12018_d
end type

type cb_delete from w_com010_d`cb_delete within w_12018_d
end type

type cb_insert from w_com010_d`cb_insert within w_12018_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_12018_d
end type

type cb_update from w_com010_d`cb_update within w_12018_d
end type

type cb_print from w_com010_d`cb_print within w_12018_d
end type

type cb_preview from w_com010_d`cb_preview within w_12018_d
end type

type gb_button from w_com010_d`gb_button within w_12018_d
end type

type cb_excel from w_com010_d`cb_excel within w_12018_d
end type

type dw_head from w_com010_d`dw_head within w_12018_d
integer x = 18
integer width = 3529
integer height = 136
string dataobject = "d_12018_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
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
idw_item.Retrieve('%')
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')






end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.01.24                                                  */	
/* 수정일      : 2001.01.24                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand", "year"
		dw_head.accepttext()
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")

		//라빠레트 시즌적용
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
		
		
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_12018_d
integer beginy = 372
integer endy = 372
end type

type ln_2 from w_com010_d`ln_2 within w_12018_d
integer beginy = 376
integer endy = 376
end type

type dw_body from w_com010_d`dw_body within w_12018_d
integer x = 9
integer y = 392
integer height = 1656
string dataobject = "d_12018_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::clicked;String 	ls_search
if row > 0 then 


			ls_search 	= this.GetItemString(row,LeftA(string(dwo.name),5) + RightA(string(dwo.name),1))
			if LenA(ls_search) >= 8 then gf_style_color_pic(ls_search, '%','%')			

end if
end event

type dw_print from w_com010_d`dw_print within w_12018_d
integer x = 658
integer y = 596
string dataobject = "d_12018_r01"
end type

type dw_1 from datawindow within w_12018_d
boolean visible = false
integer x = 635
integer y = 764
integer width = 1353
integer height = 500
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_12018_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_12018_d
integer x = 101
integer y = 312
integer width = 3433
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "0,S:메인   1~~9 : 동일디자인, 동일소재 리오다     A~~R : 소재변경 리오다    T~~Z : 디자인변경 리오다"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_chn from checkbox within w_12018_d
integer x = 3113
integer y = 212
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "중국제외"
borderstyle borderstyle = stylelowered!
end type

