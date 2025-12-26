$PBExportHeader$w_61014_d.srw
$PBExportComments$원가/물량진행현황
forward
global type w_61014_d from w_com010_d
end type
type cbx_compact from checkbox within w_61014_d
end type
type st_1 from statictext within w_61014_d
end type
type st_2 from statictext within w_61014_d
end type
type dw_mat from datawindow within w_61014_d
end type
type dw_1 from datawindow within w_61014_d
end type
type cb_graph from commandbutton within w_61014_d
end type
end forward

global type w_61014_d from w_com010_d
integer width = 3675
integer height = 2276
cbx_compact cbx_compact
st_1 st_1
st_2 st_2
dw_mat dw_mat
dw_1 dw_1
cb_graph cb_graph
end type
global w_61014_d w_61014_d

type variables
string is_brand, is_year, is_season, is_sojae, is_make_type, is_yymmdd, is_ps_z, is_ps_chn
datawindowchild idw_brand, idw_season, idw_sojae, idw_make_type

end variables

on w_61014_d.create
int iCurrent
call super::create
this.cbx_compact=create cbx_compact
this.st_1=create st_1
this.st_2=create st_2
this.dw_mat=create dw_mat
this.dw_1=create dw_1
this.cb_graph=create cb_graph
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_compact
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.dw_mat
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.cb_graph
end on

on w_61014_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_compact)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_mat)
destroy(this.dw_1)
destroy(this.cb_graph)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
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

is_brand     = dw_head.GetItemString(1, "brand")
is_year      = dw_head.GetItemString(1, "year")
is_season    = dw_head.GetItemString(1, "season")
is_sojae     = dw_head.GetItemString(1, "sojae")
is_make_type = dw_head.GetItemString(1, "make_type")
is_yymmdd    = dw_head.GetItemString(1, "yymmdd")
is_ps_z      = dw_head.GetItemString(1, "ps_z")
is_ps_chn    = dw_head.GetItemString(1, "ps_chn")

if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

decimal ldc_mat_jego_amt, ldc_mat_jego_amt_q
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
il_rows = dw_mat.retrieve(is_brand, is_year, is_season, is_sojae, is_ps_z)
if il_rows > 0 and is_ps_chn <> 'C' then
	ldc_mat_jego_amt = dw_mat.getitemnumber(1,"stock_need_amt_all")
	ldc_mat_jego_amt_q = ldc_mat_jego_amt/1000
	
else 
	ldc_mat_jego_amt = 0 
	ldc_mat_jego_amt_q = 0
end if



il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_make_type, is_yymmdd, ldc_mat_jego_amt_q , is_ps_z, is_ps_chn)
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

event open;call super::open;dw_body.Object.DataWindow.HorizontalScrollSplit  = 600

//is_brand     = dw_head.GetItemString(1, "brand")
//is_year      = dw_head.GetItemString(1, "year")
//is_season    = dw_head.GetItemString(1, "season")
//
//il_rows = dw_1.retrieve(is_brand, is_year, is_season, is_sojae, is_make_type, is_ps_z)
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_mat, "ScaleToRight")
inv_resize.of_Register(st_2, "FixedToRight")

dw_mat.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

//dw_body.ShareData(dw_print)
decimal ldc_mat_jego_amt, ldc_mat_jego_amt_q
long ll_rows

ll_rows = dw_mat.rowcount()
if ll_rows > 0 and is_ps_chn <> 'C' then
	ldc_mat_jego_amt = dw_mat.getitemnumber(1,"stock_need_amt_all")
	ldc_mat_jego_amt_q = ldc_mat_jego_amt/1000
	
else 
	ldc_mat_jego_amt = 0 
	ldc_mat_jego_amt_q = 0
end if


il_rows = dw_print.retrieve(is_brand, is_year, is_season, is_sojae, is_make_type, is_yymmdd, ldc_mat_jego_amt_q , is_ps_z, is_ps_chn)


dw_print.inv_printpreview.of_SetZoom()


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61014_d","0")
end event

type cb_close from w_com010_d`cb_close within w_61014_d
end type

type cb_delete from w_com010_d`cb_delete within w_61014_d
end type

type cb_insert from w_com010_d`cb_insert within w_61014_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61014_d
end type

type cb_update from w_com010_d`cb_update within w_61014_d
end type

type cb_print from w_com010_d`cb_print within w_61014_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_61014_d
end type

type gb_button from w_com010_d`gb_button within w_61014_d
end type

type cb_excel from w_com010_d`cb_excel within w_61014_d
end type

type dw_head from w_com010_d`dw_head within w_61014_d
integer y = 160
integer height = 180
string dataobject = "d_61014_h01"
end type

event dw_head::constructor;call super::constructor;string ls_null

This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003',gs_brand, '%')
idw_season.insertrow(1)
idw_season.SetItem(1,'inter_cd','%')
idw_season.SetItem(1,'inter_nm','전체')

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve(ls_null)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1,'sojae','%')
idw_sojae.SetItem(1,'sojae_nm','전체')


This.GetChild("make_type", idw_make_type )
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.InsertRow(1)
idw_make_type.SetItem(1,'inter_cd','%')
idw_make_type.SetItem(1,'inter_nm','전체')

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

type ln_1 from w_com010_d`ln_1 within w_61014_d
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com010_d`ln_2 within w_61014_d
integer beginy = 352
integer endy = 352
end type

type dw_body from w_com010_d`dw_body within w_61014_d
integer y = 1244
integer height = 796
string dataobject = "d_61014_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_61014_d
string dataobject = "d_61014_r00"
end type

type cbx_compact from checkbox within w_61014_d
integer x = 2679
integer y = 176
integer width = 457
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 81324524
string text = "Compact"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then
	dw_body.dataobject = "d_61014_d02"
	dw_print.dataobject = "d_61014_r99"
else
	dw_body.dataobject = "d_61014_d01"
	dw_print.dataobject = "d_61014_r00"
end if
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_body.Object.DataWindow.HorizontalScrollSplit  = 600

end event

type st_1 from statictext within w_61014_d
integer x = 69
integer y = 64
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 79741120
string text = "※ VAT +"
boolean focusrectangle = false
end type

type st_2 from statictext within w_61014_d
integer x = 3127
integer y = 276
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 81324524
string text = "※단위 : 천원"
boolean focusrectangle = false
end type

type dw_mat from datawindow within w_61014_d
integer x = 5
integer y = 368
integer width = 3589
integer height = 872
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_61014_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_61014_d
boolean visible = false
integer x = 5
integer y = 372
integer width = 2139
integer height = 1148
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "원가진행현황"
string dataobject = "d_61014_d04"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_graph from commandbutton within w_61014_d
integer x = 2661
integer y = 260
integer width = 402
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "그래프보기"
end type

event clicked;decimal ldc_mat_jego_amt, ldc_pre_style_cost
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

ldc_mat_jego_amt   = dw_body.getitemdecimal(1,"mat_jego_amt")
ldc_pre_style_cost = dw_body.getitemdecimal(1,"pre_style_cost")

//messagebox("ldc_mat_jego_amt",string(ldc_mat_jego_amt,"#,##0"))
//messagebox("ldc_pre_style_cost",string(ldc_pre_style_cost,"#,##0"))
//
il_rows = dw_1.retrieve(is_brand, is_year, is_season, is_sojae, is_make_type, is_ps_z, ldc_mat_jego_amt, ldc_pre_style_cost, is_ps_chn)
if il_rows > 0 then
	dw_1.visible = true
	dw_1.title = '원가진행현황  -  ' + is_brand 
end if

end event

