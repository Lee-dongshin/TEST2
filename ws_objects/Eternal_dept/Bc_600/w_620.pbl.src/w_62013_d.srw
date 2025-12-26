$PBExportHeader$w_62013_d.srw
$PBExportComments$출고상품매장인기도분석
forward
global type w_62013_d from w_com010_d
end type
type rb_style from radiobutton within w_62013_d
end type
type rb_channel from radiobutton within w_62013_d
end type
type rb_area from radiobutton within w_62013_d
end type
type ddlb_1 from dropdownlistbox within w_62013_d
end type
type cbx_vote from checkbox within w_62013_d
end type
type cb_chart from commandbutton within w_62013_d
end type
type dw_chart from datawindow within w_62013_d
end type
end forward

global type w_62013_d from w_com010_d
integer height = 2260
rb_style rb_style
rb_channel rb_channel
rb_area rb_area
ddlb_1 ddlb_1
cbx_vote cbx_vote
cb_chart cb_chart
dw_chart dw_chart
end type
global w_62013_d w_62013_d

type variables
string is_brand, is_year, is_season, is_item, is_style, is_yymmdd , is_gubn 
long il_body_row = 1

end variables

on w_62013_d.create
int iCurrent
call super::create
this.rb_style=create rb_style
this.rb_channel=create rb_channel
this.rb_area=create rb_area
this.ddlb_1=create ddlb_1
this.cbx_vote=create cbx_vote
this.cb_chart=create cb_chart
this.dw_chart=create dw_chart
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_style
this.Control[iCurrent+2]=this.rb_channel
this.Control[iCurrent+3]=this.rb_area
this.Control[iCurrent+4]=this.ddlb_1
this.Control[iCurrent+5]=this.cbx_vote
this.Control[iCurrent+6]=this.cb_chart
this.Control[iCurrent+7]=this.dw_chart
end on

on w_62013_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_style)
destroy(this.rb_channel)
destroy(this.rb_area)
destroy(this.ddlb_1)
destroy(this.cbx_vote)
destroy(this.cb_chart)
destroy(this.dw_chart)
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

is_brand  = dw_head.GetItemString(1, "brand")
is_year   = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_item   = dw_head.GetItemString(1, "item")
is_style  = dw_head.GetItemString(1, "style")
is_yymmdd = dw_head.GetItemString(1, "yymmdd")

if cbx_vote.checked then
	is_gubn = 'V'
else
	is_gubn = 'P'
end if


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

//* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_item, is_style, is_yymmdd)
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

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_chart, "FixedToRight&Bottom")

dw_chart.SetTransObject(SQLCA)


end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
string ls_style


ls_style = dw_chart.getitemstring(1,"style")


This.Trigger Event ue_title ()

il_rows = dw_print.retrieve(is_brand, is_year, is_season, is_item, is_style,ls_style, is_yymmdd, is_gubn)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
string ls_style

CHOOSE CASE as_column
	CASE "graph"
			/* dw_head 필수입력 column check */
			IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN 0

			ls_style = dw_body.getitemstring(il_body_row,"style")
			dw_chart.visible = true	
			dw_chart.retrieve(ls_style, is_gubn)
		


END CHOOSE

RETURN 0

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;	rb_style.enabled = dw_head.Enabled
	rb_channel.enabled = dw_head.Enabled
	rb_area.enabled = dw_head.Enabled
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_62013_d","0")
end event

type cb_close from w_com010_d`cb_close within w_62013_d
end type

type cb_delete from w_com010_d`cb_delete within w_62013_d
end type

type cb_insert from w_com010_d`cb_insert within w_62013_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_62013_d
integer x = 2688
end type

event cb_retrieve::clicked;/*===========================================================================*/
/* 작성자      : M.S.I (김태범) 															  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

IF dw_head.Enabled THEN

	Parent.Trigger Event ue_retrieve()	//조회
ELSE

	Parent.Trigger Event ue_head()	//조건
END IF

SetPointer(oldpointer)
This.Enabled = True


end event

type cb_update from w_com010_d`cb_update within w_62013_d
end type

type cb_print from w_com010_d`cb_print within w_62013_d
end type

type cb_preview from w_com010_d`cb_preview within w_62013_d
end type

type gb_button from w_com010_d`gb_button within w_62013_d
end type

type cb_excel from w_com010_d`cb_excel within w_62013_d
end type

type dw_head from w_com010_d`dw_head within w_62013_d
integer height = 184
string dataobject = "d_62013_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild	idw_child

this.getchild("brand",idw_child)
idw_child.SetTransObject(SQLCA) 
idw_child.retrieve('001')

this.getchild("season",idw_child)
idw_child.SetTransObject(SQLCA) 
idw_child.retrieve('003')
idw_child.insertrow(1)
idw_child.setitem(1,"inter_cd","%")
idw_child.setitem(1,"inter_nm","전체")

this.getchild("item",idw_child)
idw_child.SetTransObject(SQLCA) 
idw_child.retrieve()
idw_child.insertrow(1)
idw_child.setitem(1,"item","%")
idw_child.setitem(1,"item_nm","전체")


end event

type ln_1 from w_com010_d`ln_1 within w_62013_d
integer beginy = 388
integer endy = 388
end type

type ln_2 from w_com010_d`ln_2 within w_62013_d
integer beginy = 392
integer endy = 392
end type

type dw_body from w_com010_d`dw_body within w_62013_d
event type long ue_graph ( )
integer y = 412
integer height = 1628
string dataobject = "d_62013_d01"
end type

event dw_body::clicked;call super::clicked;string ls_style


if row > 0 then
	this.selectrow(0,false)
	this.selectrow(row,true)

//	p_pic.picturename = this.getitemstring(row,"pic_dir")	
	dw_chart.object.p_1.Filename = this.getitemstring(row,"pic_dir")	
	il_body_row = row
end if

if row > 0  then 
	ls_style = dw_body.getitemstring(row,"style")
	dw_chart.retrieve(ls_style, is_gubn)
	dw_chart.title = ls_style
	dw_chart.visible = true	
end if





end event

type dw_print from w_com010_d`dw_print within w_62013_d
string dataobject = "d_62013_r00"
end type

type rb_style from radiobutton within w_62013_d
integer x = 2459
integer y = 168
integer width = 357
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
string text = "스타일별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then
	dw_body.dataobject = "d_62013_d01"
	dw_chart.dataobject = "d_62013_c01"
	dw_body.SetTransObject(SQLCA)
	dw_chart.SetTransObject(SQLCA)


end if
end event

type rb_channel from radiobutton within w_62013_d
integer x = 2459
integer y = 236
integer width = 357
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
string text = "유통별"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then
	dw_body.dataobject = "d_62013_d02"
	dw_chart.dataobject = "d_62013_c02"
	dw_print.dataobject = "d_62013_r00"
	
	dw_body.SetTransObject(SQLCA)
	dw_chart.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)


end if
end event

type rb_area from radiobutton within w_62013_d
integer x = 2459
integer y = 304
integer width = 357
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
string text = "지역별"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then
	dw_body.dataobject = "d_62013_d03"
	dw_chart.dataobject = "d_62013_c03"
	dw_print.dataobject = "d_62013_r99"
	
	dw_body.SetTransObject(SQLCA)
	dw_chart.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)


end if
	
end event

type ddlb_1 from dropdownlistbox within w_62013_d
integer x = 2885
integer y = 188
integer width = 704
integer height = 1036
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "ColStakedObj"
boolean sorted = false
string item[] = {"Area","Bar","Bar3D","Bar3DObj","BarStaked","BarStaked3DObj","Col","Col3D","Col3DObj","ColStaked","ColStaked3DObj","Line","Pie","Scatter","Area3D","Line3D","Pie3D"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;dw_chart.object.gr_1.graphtype = index
end event

type cbx_vote from checkbox within w_62013_d
integer x = 2880
integer y = 284
integer width = 526
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
string text = "투표자수 기준"
borderstyle borderstyle = stylelowered!
end type

event clicked;if cbx_vote.checked then
	is_gubn = 'V'
else
	is_gubn = 'P'
end if
end event

type cb_chart from commandbutton within w_62013_d
boolean visible = false
integer x = 59
integer y = 48
integer width = 439
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "그래프보기"
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
string ls_style


			/* dw_head 필수입력 column check */
			IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN 0

			ls_style = dw_body.getitemstring(il_body_row,"style")
			dw_chart.visible = true	
			dw_chart.retrieve(ls_style, is_gubn)
		



end event

type dw_chart from datawindow within w_62013_d
boolean visible = false
integer x = 2409
integer y = 608
integer width = 1175
integer height = 1424
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "그래픽"
string dataobject = "d_62013_c02"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;parent.dw_chart.visible = false
end event

