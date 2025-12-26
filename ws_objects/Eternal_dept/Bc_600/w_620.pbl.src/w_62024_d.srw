$PBExportHeader$w_62024_d.srw
$PBExportComments$매출차트분석
forward
global type w_62024_d from w_com010_d
end type
type cb_1 from commandbutton within w_62024_d
end type
type cb_2 from commandbutton within w_62024_d
end type
type cb_3 from commandbutton within w_62024_d
end type
type cb_out from commandbutton within w_62024_d
end type
type cb_in from commandbutton within w_62024_d
end type
type dw_2 from u_dw within w_62024_d
end type
type dw_1 from u_dw within w_62024_d
end type
end forward

global type w_62024_d from w_com010_d
integer width = 3634
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
cb_out cb_out
cb_in cb_in
dw_2 dw_2
dw_1 dw_1
end type
global w_62024_d w_62024_d

type variables
/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
String 	is_brand,is_year, is_season, is_item, is_sojae, is_style, is_out_seq, is_fr_yymmdd, is_to_yymmdd, is_sale_gubn, is_line_1, is_line_2, is_line_3, is_shop_cd
Long		il_order_no

DataWindowChild	idw_brand, idw_sojae, idw_season, idw_item, idw_out_seq
end variables

on w_62024_d.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_out=create cb_out
this.cb_in=create cb_in
this.dw_2=create dw_2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.cb_out
this.Control[iCurrent+5]=this.cb_in
this.Control[iCurrent+6]=this.dw_2
this.Control[iCurrent+7]=this.dw_1
end on

on w_62024_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_out)
destroy(this.cb_in)
destroy(this.dw_2)
destroy(this.dw_1)
end on

event open;call super::open;datetime ld_datetime


IF gf_cdate(ld_datetime,-3)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

//dw_head.setitem(1,"brand","%")
dw_head.setitem(1,"year","%")
dw_head.setitem(1,"season","%")


end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
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

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) OR is_year = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_brand		= dw_head.GetItemString(1, "brand")
is_item		= dw_head.GetItemString(1, "item")
is_sojae		= dw_head.GetItemString(1, "sojae")
is_season	= dw_head.GetItemString(1, "season")
is_out_seq	= dw_head.GetItemString(1, "out_seq")

is_style	= dw_head.GetItemString(1, "style")

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_sale_gubn = dw_head.GetItemString(1, "sale_gubn")
is_line_1	 = dw_head.GetItemString(1, "line_1")
is_line_2	 = dw_head.GetItemString(1, "line_2")
is_line_3	 = dw_head.GetItemString(1, "line_3")
is_shop_cd	 = dw_head.GetItemString(1, "shop_cd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if dw_body.visible then
	il_rows = dw_body.retrieve(is_brand,is_year, is_season, is_item, is_sojae, is_style, is_out_seq, is_fr_yymmdd, is_to_yymmdd, is_sale_gubn, is_line_1, is_line_2, is_line_3, is_shop_cd)
elseif dw_1.visible then
	il_rows = dw_1.retrieve(is_brand,is_year, is_season, is_item, is_sojae, is_out_seq, is_fr_yymmdd, is_to_yymmdd, is_sale_gubn, is_line_1, is_shop_cd)
elseif dw_2.visible then
	il_rows = dw_2.retrieve(is_brand,is_year, is_season, is_item, is_sojae, is_out_seq, is_fr_yymmdd, is_to_yymmdd, is_sale_gubn, is_line_1, is_shop_cd)
end if	
	
//IF il_rows = 0 THEN
//   MessageBox("조회", "조회할 자료가 없습니다.")
//ELSE
//   MessageBox("조회오류", "조회 실패 하였습니다.")
//END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_title();call super::ue_title;///*===========================================================================*/
///* 작성자      : (주)지우정보 (김 영일)                                      */	
///* 작성일      : 2002.03.05                                                  */	
///* 수정일      : 2002.03.05                                                  */
///*===========================================================================*/
//
//datetime ld_datetime
//string ls_modify, ls_datetime, ls_fr_ymd, ls_to_ymd
//
//
//IF gf_sysdate(ld_datetime) = FALSE THEN
//   ld_datetime = DateTime(Today(), Now())
//END IF
//
//ls_datetime = String(ld_datetime, "yyyy-mm-dd hh:mm:ss")
//
//ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
//             "t_user_id.Text = '" + gs_user_id + "'" + &
//             "t_datetime.Text = '" + ls_datetime + "'" + &
//             "t_fr_ymd.Text = '" + is_fr_ymd + "'" + &
//             "t_to_ymd.Text = '" + is_to_ymd + "'"
//dw_print.Modify(ls_modify)
//
//
end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
//         cb_retrieve.Text = "조건(&Q)"
//         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
//   CASE 5    /* 조건 */
//      cb_retrieve.Text = "조회(&Q)"
//      cb_print.enabled = false
//      cb_preview.enabled = false
//      cb_excel.enabled = false
//      ib_changed = false
//      dw_body.Enabled = false
//      dw_head.Enabled = true
//      dw_head.SetFocus()
//      dw_head.SetColumn(1)
	
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_62024_d","0")
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(cb_out, "FixedToRight")
inv_resize.of_Register(cb_in, "FixedToRight")

inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_2, "ScaleToRight&Bottom")

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_shop_div
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		ls_brand = Trim(dw_head.GetItemString(1, "brand"))
		IF ai_div = 1 THEN 	
			IF IsNull(as_data) OR Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "shop_nm", "")
				RETURN 0
			END IF 
			IF LeftA(as_data, 1) <> ls_brand THEN
				MessageBox("입력오류", "브랜드가 다릅니다!")
				dw_head.SetItem(al_row, "shop_cd", "")
				dw_head.SetItem(al_row, "shop_nm", "")
				RETURN 1
			END IF
				
			IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "' and shop_div in ('G','K') and len(close_ymd) = 0 "
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = CREATE DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = TRUE
			lds_Source = Message.PowerObjectParm
			dw_head.SetRow(al_row)
			dw_head.SetColumn(as_column)
			dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
			dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
			/* 다음컬럼으로 이동 */
			dw_head.SetColumn("shop_cd")
			ib_itemchanged = FALSE 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		DESTROY lds_Source

END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

type cb_close from w_com010_d`cb_close within w_62024_d
end type

type cb_delete from w_com010_d`cb_delete within w_62024_d
end type

type cb_insert from w_com010_d`cb_insert within w_62024_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_62024_d
end type

type cb_update from w_com010_d`cb_update within w_62024_d
end type

type cb_print from w_com010_d`cb_print within w_62024_d
end type

type cb_preview from w_com010_d`cb_preview within w_62024_d
end type

type gb_button from w_com010_d`gb_button within w_62024_d
end type

type cb_excel from w_com010_d`cb_excel within w_62024_d
end type

type dw_head from w_com010_d`dw_head within w_62024_d
integer y = 168
integer width = 3854
integer height = 252
string dataobject = "d_62024_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertrow(1)
idw_brand.Setitem(1, "inter_cd", "%")
idw_brand.Setitem(1, "inter_nm", "전체")


This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_bRAND)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1,'sojae','%')
idw_sojae.SetItem(1,'sojae_nm','전체')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

This.GetChild("item", idw_item)
idw_item.SetTRansObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.insertrow(1)
idw_item.Setitem(1, "item", "%")
idw_item.Setitem(1, "item_nm", "전체")


//This.GetChild("out_seq", idw_out_seq)
//idw_out_seq.SetTRansObject(SQLCA)
//idw_out_seq.Retrieve('010')
//idw_out_seq.insertrow(1)
//idw_out_seq.Setitem(1, "inter_cd", "%")
//idw_out_seq.Setitem(1, "inter_nm", "전체")


end event

event dw_head::itemchanged;call super::itemchanged;
string ls_year, ls_brand
DataWindowChild ldw_child



CHOOSE CASE dwo.name
	CASE "brand"
	

		This.GetChild("sojae", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('%', data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "sojae", "%")
		ldw_child.Setitem(1, "sojae_nm", "전체")
		
	
		This.GetChild("item", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve(data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "item", "%")
		ldw_child.Setitem(1, "item_nm", "전체")		
				
		
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

type ln_1 from w_com010_d`ln_1 within w_62024_d
integer beginy = 436
integer endy = 436
end type

type ln_2 from w_com010_d`ln_2 within w_62024_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_62024_d
integer x = 9
integer y = 540
integer width = 3575
integer height = 1500
string dataobject = "d_62024_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_62024_d
integer x = 0
integer y = 564
integer width = 768
integer height = 184
end type

type cb_1 from commandbutton within w_62024_d
integer x = 14
integer y = 448
integer width = 402
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "기본차트"
end type

event clicked;dw_body.visible = true
dw_1.visible = false
dw_2.visible = false

end event

type cb_2 from commandbutton within w_62024_d
integer x = 416
integer y = 448
integer width = 402
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "전년대비"
end type

event clicked;dw_body.visible = false
dw_1.visible = true
dw_2.visible = false

end event

type cb_3 from commandbutton within w_62024_d
integer x = 818
integer y = 448
integer width = 402
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "브랜드별"
end type

event clicked;dw_body.visible = false
dw_1.visible = false
dw_2.visible = true

end event

type cb_out from commandbutton within w_62024_d
integer x = 3323
integer y = 448
integer width = 128
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "+"
end type

event clicked;integer li_labels

if dw_body.visible then
	li_labels = dec(dw_body.object.gr_1.category.displayeverynlabels)
	li_labels = li_labels + 1
	
	if li_labels < 0 then 	li_labels = 0
	dw_body.object.gr_1.category.displayeverynlabels = li_labels
	
elseif dw_1.visible then
	li_labels = dec(dw_1.object.gr_1.category.displayeverynlabels)
	li_labels = li_labels + 1
	
	if li_labels < 0 then 	li_labels = 0
	dw_1.object.gr_1.category.displayeverynlabels = li_labels
	
elseif dw_2.visible then
	li_labels = dec(dw_2.object.gr_1.category.displayeverynlabels)
	li_labels = li_labels + 1
	
	if li_labels < 0 then 	li_labels = 0
	dw_2.object.gr_1.category.displayeverynlabels = li_labels
end if


end event

type cb_in from commandbutton within w_62024_d
integer x = 3461
integer y = 448
integer width = 128
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "-"
end type

event clicked;integer li_labels

if dw_body.visible then
	li_labels = dec(dw_body.object.gr_1.category.displayeverynlabels)
	li_labels = li_labels - 1
	
	if li_labels < 0 then 	li_labels = 0
	dw_body.object.gr_1.category.displayeverynlabels = li_labels
	
elseif dw_1.visible then
	li_labels = dec(dw_1.object.gr_1.category.displayeverynlabels)
	li_labels = li_labels - 1
	
	if li_labels < 0 then 	li_labels = 0
	dw_1.object.gr_1.category.displayeverynlabels = li_labels
	
elseif dw_2.visible then
	li_labels = dec(dw_2.object.gr_1.category.displayeverynlabels)
	li_labels = li_labels - 1
	
	if li_labels < 0 then 	li_labels = 0
	dw_2.object.gr_1.category.displayeverynlabels = li_labels
end if
end event

type dw_2 from u_dw within w_62024_d
boolean visible = false
integer x = 9
integer y = 540
integer width = 3575
integer height = 1500
integer taborder = 40
string dataobject = "d_62024_d03"
boolean hscrollbar = true
end type

type dw_1 from u_dw within w_62024_d
boolean visible = false
integer x = 9
integer y = 540
integer width = 3575
integer height = 1500
integer taborder = 40
string dataobject = "d_62024_d02"
boolean hscrollbar = true
end type

