$PBExportHeader$w_56012_d.srw
$PBExportComments$재매입 거래명세서
forward
global type w_56012_d from w_com010_d
end type
type rb_1 from radiobutton within w_56012_d
end type
type rb_2 from radiobutton within w_56012_d
end type
type rb_3 from radiobutton within w_56012_d
end type
type rb_4 from radiobutton within w_56012_d
end type
type dw_1 from datawindow within w_56012_d
end type
type cbx_laser from checkbox within w_56012_d
end type
type gb_1 from groupbox within w_56012_d
end type
end forward

global type w_56012_d from w_com010_d
integer width = 3685
integer height = 2284
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
dw_1 dw_1
cbx_laser cbx_laser
gb_1 gb_1
end type
global w_56012_d w_56012_d

type variables
String is_brand, is_yymm, is_shop_div, is_shop_type, is_shop_cd, is_job_fg 
String is_yn 
end variables

on w_56012_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.dw_1=create dw_1
this.cbx_laser=create cbx_laser
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.cbx_laser
this.Control[iCurrent+7]=this.gb_1
end on

on w_56012_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.dw_1)
destroy(this.cbx_laser)
destroy(this.gb_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymm = String(dw_head.GetItemDateTime(1, "yymm"), "yyyymm")

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = '%'
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.05.15                                                  */	
/* 수정일      : 2002.05.15                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymm, is_shop_div, is_shop_cd, is_shop_type, is_job_fg)

IF il_rows > 0 THEN
   dw_body.SetFocus()
	cb_print.Enabled = True 
	is_yn            = 'Y'
ELSEIF il_rows = 0 THEN
	cb_print.Enabled = False
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	cb_print.Enabled = False
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

//This.Trigger Event ue_button(1, il_rows)

This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;is_job_fg = '1'
dw_head.Setitem(1, "shop_div",  '%')
dw_head.Setitem(1, "shop_type", '%')

end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
		   IF ai_div = 1 AND (isnull(as_data) or Trim(as_data) = "" ) THEN 
				dw_head.Setitem(1, "shop_nm", "") 
				Return 0 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
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

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.05.16                                                  */	
/* 수정일      : 2002.05.16                                                  */
/*===========================================================================*/
Long   i, ll_row  
String ls_yn, ls_shop_cd, ls_job_fg  

if cbx_laser.checked = true then 
	dw_print.dataobject = "d_56012_r04"
	dw_print.SetTransObject(SQLCA)
else	
	dw_print.dataobject = "d_56012_r03"
	dw_print.SetTransObject(SQLCA)
end if 


FOR i = 1 TO dw_body.RowCount() 
	ls_yn  = dw_body.GetitemString(i, "prn_yn")
	IF ls_yn = 'Y' THEN 
		ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
      ls_job_fg  = dw_body.GetitemString(i, "job_fg")
	   ll_row = dw_print.Retrieve(is_brand, is_yymm, ls_shop_cd, is_shop_type, ls_job_fg)
	   IF ll_row > 0 THEN dw_print.Print()
	END IF 
NEXT 

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56012_d","0")
end event

type cb_close from w_com010_d`cb_close within w_56012_d
end type

type cb_delete from w_com010_d`cb_delete within w_56012_d
end type

type cb_insert from w_com010_d`cb_insert within w_56012_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56012_d
end type

type cb_update from w_com010_d`cb_update within w_56012_d
end type

type cb_print from w_com010_d`cb_print within w_56012_d
integer width = 576
string text = "거래명세서 인쇄(&P)"
end type

type cb_preview from w_com010_d`cb_preview within w_56012_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_56012_d
end type

type cb_excel from w_com010_d`cb_excel within w_56012_d
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_56012_d
integer x = 768
integer y = 164
integer width = 2807
integer height = 228
string dataobject = "d_56012_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild  ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("shop_div", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('910')
ldw_child.Setfilter("inter_cd <> 'A' and inter_cd < 'T'")
ldw_child.Filter()
ldw_child.insertrow(1)
ldw_child.Setitem(1, "inter_cd", '%')
ldw_child.Setitem(1, "inter_nm", '전체')

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')
ldw_child.insertrow(1)
ldw_child.Setitem(1, "inter_cd", '%')
ldw_child.Setitem(1, "inter_nm", '전체')


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.05.16                                                  */	
/* 수정일      : 2002.05.16                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_56012_d
integer beginy = 400
integer endy = 400
end type

type ln_2 from w_com010_d`ln_2 within w_56012_d
integer beginy = 404
integer endy = 404
end type

type dw_body from w_com010_d`dw_body within w_56012_d
integer y = 424
integer width = 3602
integer height = 1624
string dataobject = "d_56012_d01"
end type

event dw_body::buttonclicked;call super::buttonclicked;Long i 

IF is_yn = 'Y' THEN 
	is_yn = 'N' 
ELSE 
	is_yn = 'Y'
END IF

FOR i = 1 TO This.RowCount()
	This.Setitem(i, "prn_yn", is_yn)
NEXT 

end event

event dw_body::doubleclicked;call super::doubleclicked;String ls_shop_cd, ls_job_fg  

IF row < 1 THEN RETURN 

ls_shop_cd = This.GetitemString(row, "shop_cd")
ls_job_fg  = This.GetitemString(row, "job_fg")

This.SelectRow(0,   False)
This.SelectRow(row, True )
dw_1.Retrieve(is_brand, is_yymm, ls_shop_cd, is_shop_type, ls_job_fg)

dw_1.visible = TRUE 
end event

type dw_print from w_com010_d`dw_print within w_56012_d
string dataobject = "d_56012_r03"
end type

type rb_1 from radiobutton within w_56012_d
integer x = 50
integer y = 204
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "세일"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;is_job_fg = '1' 
This.TextColor = rgb(0, 0, 255) 
rb_2.TextColor = rgb(0, 0, 0) 
rb_3.TextColor = rgb(0, 0, 0) 
rb_4.TextColor = rgb(0, 0, 0) 

end event

type rb_2 from radiobutton within w_56012_d
integer x = 439
integer y = 204
integer width = 247
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
string text = "쿠폰"
borderstyle borderstyle = stylelowered!
end type

event clicked;is_job_fg = '2' 
This.TextColor = rgb(0, 0, 255) 
rb_1.TextColor = rgb(0, 0, 0) 
rb_3.TextColor = rgb(0, 0, 0) 
rb_4.TextColor = rgb(0, 0, 0) 

end event

type rb_3 from radiobutton within w_56012_d
integer x = 50
integer y = 284
integer width = 352
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
string text = "재고감가"
borderstyle borderstyle = stylelowered!
end type

event clicked;is_job_fg = '3' 
This.TextColor = rgb(0, 0, 255) 
rb_1.TextColor = rgb(0, 0, 0) 
rb_2.TextColor = rgb(0, 0, 0) 
rb_4.TextColor = rgb(0, 0, 0) 

end event

type rb_4 from radiobutton within w_56012_d
integer x = 439
integer y = 284
integer width = 247
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
string text = "전체"
borderstyle borderstyle = stylelowered!
end type

event clicked;is_job_fg = '%' 
This.TextColor = rgb(0, 0, 255) 
rb_1.TextColor = rgb(0, 0, 0) 
rb_2.TextColor = rgb(0, 0, 0) 
rb_3.TextColor = rgb(0, 0, 0) 

end event

type dw_1 from datawindow within w_56012_d
boolean visible = false
integer x = 210
integer y = 432
integer width = 3013
integer height = 1504
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "상세내역"
string dataobject = "d_56012_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;IF dwo.name = "b_close" THEN 
	This.Visible = FALSE
END IF 
end event

type cbx_laser from checkbox within w_56012_d
integer x = 864
integer y = 60
integer width = 544
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 79741120
string text = "명세서(레이저)"
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_56012_d
integer x = 9
integer y = 148
integer width = 736
integer height = 224
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

