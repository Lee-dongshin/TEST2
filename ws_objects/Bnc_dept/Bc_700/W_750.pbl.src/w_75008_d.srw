$PBExportHeader$w_75008_d.srw
$PBExportComments$고객 세그먼트분포
forward
global type w_75008_d from w_com010_d
end type
type st_a from statictext within w_75008_d
end type
type st_b from statictext within w_75008_d
end type
type st_c from statictext within w_75008_d
end type
type st_d from statictext within w_75008_d
end type
type st_e from statictext within w_75008_d
end type
type st_f from statictext within w_75008_d
end type
type cb_graph from commandbutton within w_75008_d
end type
type dw_2 from datawindow within w_75008_d
end type
type dw_1 from datawindow within w_75008_d
end type
end forward

global type w_75008_d from w_com010_d
integer width = 3643
st_a st_a
st_b st_b
st_c st_c
st_d st_d
st_e st_e
st_f st_f
cb_graph cb_graph
dw_2 dw_2
dw_1 dw_1
end type
global w_75008_d w_75008_d

type variables
datawindowchild idw_brand, idw_area_cd, idw_shop_grp	
string is_brand, is_area_cd, is_shop_cd, is_shop_grp


end variables

on w_75008_d.create
int iCurrent
call super::create
this.st_a=create st_a
this.st_b=create st_b
this.st_c=create st_c
this.st_d=create st_d
this.st_e=create st_e
this.st_f=create st_f
this.cb_graph=create cb_graph
this.dw_2=create dw_2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_a
this.Control[iCurrent+2]=this.st_b
this.Control[iCurrent+3]=this.st_c
this.Control[iCurrent+4]=this.st_d
this.Control[iCurrent+5]=this.st_e
this.Control[iCurrent+6]=this.st_f
this.Control[iCurrent+7]=this.cb_graph
this.Control[iCurrent+8]=this.dw_2
this.Control[iCurrent+9]=this.dw_1
end on

on w_75008_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_a)
destroy(this.st_b)
destroy(this.st_c)
destroy(this.st_d)
destroy(this.st_e)
destroy(this.st_f)
destroy(this.cb_graph)
destroy(this.dw_2)
destroy(this.dw_1)
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if
is_area_cd = dw_head.GetItemString(1, "area_cd")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")
is_shop_grp = dw_head.GetItemString(1, "shop_grp")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long	ll_amt_on, ll_amt_olive, ll_amt_w
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand,'F', is_area_cd, is_shop_cd, is_shop_grp)
IF il_rows > 0 THEN
	il_rows = dw_2.retrieve(is_brand, is_area_cd, is_shop_cd, is_shop_grp)
	if il_rows > 0 then
		dw_2.visible = true
		
		select floor((isnull(sum(sale_amt_1),0) + isnull(sum(sale_amt_2),0) - isnull(sum(goods_amt),0) 
	 			- isnull((select isnull(sum(sale_amt_1),0) + isnull(sum(sale_amt_2),0) - isnull(sum(goods_amt),0) 
					from tb_12032_s (nolock)  where yymmdd between '20020301' and '20020313' and brand = 'N'),0)) / 1000)
		into :ll_amt_on
		from tb_12031_s (nolock)  where yymm >= '200203' and brand = 'N';

		dw_2.object.t_on.text = string(ll_amt_on,"#,##0")
		
		select floor((isnull(sum(sale_amt_1),0) + isnull(sum(sale_amt_2),0) - isnull(sum(goods_amt),0) 
	 			- isnull((select isnull(sum(sale_amt_1),0) + isnull(sum(sale_amt_2),0) - isnull(sum(goods_amt),0) 
					from tb_12032_s (nolock)  where yymmdd between '20020301' and '20020313' and brand = 'O'),0)) / 1000)
		into :ll_amt_olive
		from tb_12031_s (nolock)  where yymm >= '200203' and brand = 'O';

		dw_2.object.t_olive.text = string(ll_amt_olive,"#,##0")		

		select floor((isnull(sum(sale_amt_1),0) + isnull(sum(sale_amt_2),0) - isnull(sum(goods_amt),0)) / 1000) 	 			
		into :ll_amt_w
		from tb_12031_s (nolock)  where yymm >= '200203' and brand = 'W';

		dw_2.object.t_W.text = string(ll_amt_w,"#,##0")			
		dw_2.object.t_total.text = string(ll_amt_on + ll_amt_olive + ll_amt_w,"#,##0")		
	end if
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")


/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_2, "ScaleToRight&Bottom")
/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

st_a.backcolor = rgb(190,201,167)
st_b.backcolor = rgb(205,128,64) 
st_c.backcolor = rgb(128,128,255)
st_d.backcolor = rgb(255,128,255)
st_e.backcolor = rgb(0,128,128)
st_f.backcolor = rgb(253,249,219)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_75008_d","0")
end event

event ue_preview();
This.Trigger Event ue_title ()
//dw_body.ShareData(dw_print)
il_rows = dw_print.retrieve(is_brand,'F', is_area_cd, is_shop_cd, is_shop_grp)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title();call super::ue_title;decimal ll_on, ll_olive, ll_w, ll_amt_on, ll_amt_olive, ll_amt_w
//////////////////////////////////
select floor((isnull(sum(sale_amt_1),0) + isnull(sum(sale_amt_2),0) - isnull(sum(goods_amt),0) 
		- isnull((select isnull(sum(sale_amt_1),0) + isnull(sum(sale_amt_2),0) - isnull(sum(goods_amt),0) 
			from tb_12032_s (nolock)  where yymmdd between '20020301' and '20020313' and brand = 'N'),0)) / 1000)
into :ll_amt_on
from tb_12031_s (nolock)  where yymm >= '200203' and brand = 'N';

dw_print.object.t_on.text = string(ll_amt_on,"#,##0")

messagebox("lgjsl","sgjald")
messagebox("lsgdj",ll_amt_on)
select floor((isnull(sum(sale_amt_1),0) + isnull(sum(sale_amt_2),0) - isnull(sum(goods_amt),0) 
		- isnull((select isnull(sum(sale_amt_1),0) + isnull(sum(sale_amt_2),0) - isnull(sum(goods_amt),0) 
			from tb_12032_s (nolock)  where yymmdd between '20020301' and '20020313' and brand = 'O'),0)) / 1000)
into :ll_amt_olive
from tb_12031_s (nolock)  where yymm >= '200203' and brand = 'O';

dw_print.object.t_olive.text = string(ll_amt_olive,"#,##0")		

select floor((isnull(sum(sale_amt_1),0) + isnull(sum(sale_amt_2),0) - isnull(sum(goods_amt),0)) / 1000) 	 			
into :ll_amt_w
from tb_12031_s (nolock)  where yymm >= '200203' and brand = 'W';

dw_print.object.t_W.text = string(ll_amt_w,"#,##0")			
dw_print.object.t_total.text = string(ll_amt_on + ll_amt_olive + ll_amt_w,"#,##0")

end event

type cb_close from w_com010_d`cb_close within w_75008_d
end type

type cb_delete from w_com010_d`cb_delete within w_75008_d
end type

type cb_insert from w_com010_d`cb_insert within w_75008_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_75008_d
end type

type cb_update from w_com010_d`cb_update within w_75008_d
end type

type cb_print from w_com010_d`cb_print within w_75008_d
end type

type cb_preview from w_com010_d`cb_preview within w_75008_d
end type

type gb_button from w_com010_d`gb_button within w_75008_d
end type

type cb_excel from w_com010_d`cb_excel within w_75008_d
end type

type dw_head from w_com010_d`dw_head within w_75008_d
integer y = 192
integer height = 136
string dataobject = "d_75008_h01"
end type

event dw_head::constructor;call super::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')
idw_brand.insertrow(1)
idw_brand.setitem(1,"inter_cd","%")
idw_brand.setitem(1,"inter_nm","전체")

this.getchild("area_cd",idw_area_cd)
idw_area_cd.settransobject(sqlca)
idw_area_cd.retrieve('090')
idw_area_cd.insertrow(1)
idw_area_cd.setitem(1,"inter_cd","%")
idw_area_cd.setitem(1,"inter_nm","전체")

this.getchild("shop_grp",idw_shop_grp)
idw_shop_grp.settransobject(sqlca)
idw_shop_grp.retrieve('912')
idw_shop_grp.insertrow(1)
idw_shop_grp.setitem(1,"inter_cd","%")
idw_shop_grp.setitem(1,"inter_nm","전체")

end event

type ln_1 from w_com010_d`ln_1 within w_75008_d
integer beginy = 360
integer endy = 360
end type

type ln_2 from w_com010_d`ln_2 within w_75008_d
integer beginy = 364
integer endy = 364
end type

type dw_body from w_com010_d`dw_body within w_75008_d
integer y = 376
integer height = 728
string dataobject = "d_75008_d01"
boolean vscrollbar = false
boolean livescroll = false
end type

type dw_print from w_com010_d`dw_print within w_75008_d
string dataobject = "d_75008_r00"
end type

type st_a from statictext within w_75008_d
integer x = 14
integer y = 1112
integer width = 530
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 80269524
string text = "최우수 고정고객(A)"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if dw_2.visible then 	dw_2.visible = false
il_rows = dw_1.retrieve(is_brand,'A',is_area_cd, is_shop_cd, is_shop_grp)
if il_rows > 0 then	dw_1.visible = true

end event

type st_b from statictext within w_75008_d
integer x = 549
integer y = 1112
integer width = 530
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 80269524
string text = "우수 고정고객(B)"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if dw_2.visible then 	dw_2.visible = false
il_rows = dw_1.retrieve(is_brand,'B',is_area_cd, is_shop_cd, is_shop_grp)
if il_rows > 0 then	dw_1.visible = true
end event

type st_c from statictext within w_75008_d
integer x = 1083
integer y = 1112
integer width = 530
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 80269524
string text = "일반 고정고객(C)"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if dw_2.visible then 	dw_2.visible = false
il_rows = dw_1.retrieve(is_brand,'C',is_area_cd, is_shop_cd, is_shop_grp)
if il_rows > 0 then	dw_1.visible = true
end event

type st_d from statictext within w_75008_d
integer x = 1618
integer y = 1112
integer width = 530
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 80269524
string text = "우수 유동고객(D)"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if dw_2.visible then 	dw_2.visible = false
il_rows = dw_1.retrieve(is_brand,'D',is_area_cd, is_shop_cd, is_shop_grp)
if il_rows > 0 then	dw_1.visible = true

end event

type st_e from statictext within w_75008_d
integer x = 2153
integer y = 1112
integer width = 530
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 80269524
string text = "일반 유동고객(E)"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if dw_2.visible then 	dw_2.visible = false
il_rows = dw_1.retrieve(is_brand,'E',is_area_cd, is_shop_cd, is_shop_grp)
if il_rows > 0 then	dw_1.visible = true

end event

type st_f from statictext within w_75008_d
integer x = 2688
integer y = 1112
integer width = 530
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 80269524
string text = "일반 휴면고객(F)"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if dw_2.visible then 	dw_2.visible = false
il_rows = dw_1.retrieve(is_brand,'F',is_area_cd, is_shop_cd, is_shop_grp)
if il_rows > 0 then	dw_1.visible = true

end event

type cb_graph from commandbutton within w_75008_d
integer x = 3273
integer y = 1112
integer width = 315
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "그래프보기"
end type

event clicked;	if dw_2.visible = false then
		if dw_2.rowcount() = 0 then 
			il_rows = dw_2.retrieve()
			if il_rows > 0 then
				dw_2.visible = true
			end if
		else
			dw_2.visible = true
		end if
	end if
	
end event

type dw_2 from datawindow within w_75008_d
integer x = 5
integer y = 1184
integer width = 3584
integer height = 860
integer taborder = 40
string title = "none"
string dataobject = "d_75008_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;choose case dwo.name
	case "cb_exit"
		this.visible = false
end choose

end event

type dw_1 from datawindow within w_75008_d
boolean visible = false
integer x = 5
integer y = 1184
integer width = 3547
integer height = 860
integer taborder = 40
string title = "none"
string dataobject = "d_75008_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

