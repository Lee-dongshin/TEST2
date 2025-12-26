$PBExportHeader$w_sh120_d.srw
$PBExportComments$Style Speed 조회
forward
global type w_sh120_d from w_com010_d
end type
type dw_detail from datawindow within w_sh120_d
end type
end forward

global type w_sh120_d from w_com010_d
integer width = 2971
integer height = 2048
dw_detail dw_detail
end type
global w_sh120_d w_sh120_d

type variables
string  is_brand, is_year, is_season, is_sojae, is_item, is_style, is_chno
DataWindowChild idw_brand, idw_season, idw_sojae, idw_item
end variables

on w_sh120_d.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
end on

on w_sh120_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
end on

event pfc_preopen();call super::pfc_preopen;/* DataWindow의 Transction 정의 */
dw_detail.SetTransObject(SQLCA)

end event

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
   MessageBox(ls_title,"복종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_sojae,is_item)

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

type cb_close from w_com010_d`cb_close within w_sh120_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh120_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh120_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh120_d
end type

type cb_update from w_com010_d`cb_update within w_sh120_d
end type

type cb_print from w_com010_d`cb_print within w_sh120_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_sh120_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_sh120_d
end type

type dw_head from w_com010_d`dw_head within w_sh120_d
integer height = 120
string dataobject = "d_sh120_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand, is_year)
//idw_sojae.InsertRow(1)
//idw_sojae.SetItem(1, "sojae", '%')
//idw_sojae.SetItem(1, "sojae_nm", '전체')


This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%', gs_brand, is_year)
//idw_item.InsertRow(1)
//idw_item.SetItem(1, "item", '%')
//idw_item.SetItem(1, "item_nm", '전체')
//

end event

type ln_1 from w_com010_d`ln_1 within w_sh120_d
integer beginy = 296
integer endy = 296
end type

type ln_2 from w_com010_d`ln_2 within w_sh120_d
integer beginy = 300
integer endy = 300
end type

type dw_body from w_com010_d`dw_body within w_sh120_d
integer y = 320
integer height = 1476
string dataobject = "d_sh120_d01"
end type

event dw_body::clicked;call super::clicked; dw_detail.reset()
   is_style =  dw_body.GetitemString(row,"style")	
	is_chno =  dw_body.GetitemString(row,"chno")	
	
	
	IF is_style = "" OR isnull(is_style) THEN		
		return
	END IF

IF dw_detail.RowCount() < 1 THEN 
	il_rows = dw_detail.retrieve(is_style, is_chno)
END IF 

	dw_detail.visible = True

end event

type dw_print from w_com010_d`dw_print within w_sh120_d
end type

type dw_detail from datawindow within w_sh120_d
boolean visible = false
integer x = 169
integer width = 2473
integer height = 1808
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "상세내역"
string dataobject = "d_sh120_d02"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_detail.reset()
 dw_detail.visible = false
	
end event

