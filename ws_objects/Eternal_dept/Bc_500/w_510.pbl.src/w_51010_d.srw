$PBExportHeader$w_51010_d.srw
$PBExportComments$행사계획서
forward
global type w_51010_d from w_com010_d
end type
type rb_1 from radiobutton within w_51010_d
end type
type rb_2 from radiobutton within w_51010_d
end type
type rb_3 from radiobutton within w_51010_d
end type
type gb_1 from groupbox within w_51010_d
end type
end forward

global type w_51010_d from w_com010_d
integer width = 3680
integer height = 2280
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
gb_1 gb_1
end type
global w_51010_d w_51010_d

type variables
DataWindowChild idw_brand
String is_brand, is_frm_ymd, is_to_ymd, is_sale_gubn, is_shop_cd
end variables

on w_51010_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.gb_1
end on

on w_51010_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.gb_1)
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_frm_ymd = dw_head.GetItemString(1, "frm_ymd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_sale_gubn = dw_head.GetItemString(1, "sale_gubn")
if IsNull(is_sale_gubn) or Trim(is_sale_gubn) = "" then
   MessageBox(ls_title,"행사구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_gubn")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
  is_shop_cd = "%"
end if

return true

end event

event open;call super::open;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.setitem(1, "frm_ymd", string(ld_datetime, "YYYYMMDD"))
dw_head.setitem(1, "to_ymd", string(ld_datetime, "YYYYMMDD"))
end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_frm_ymd, is_to_ymd, is_shop_cd, is_sale_gubn)
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV  IN ('G', 'K') " + &
											 "  AND BRAND = '" + ls_brand + "'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
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

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text      = '" + is_pgm_id + "'" + &
             "t_user_id.Text   = '" + gs_user_id + "'" + &
             "t_datetime.Text  = '" + ls_datetime + "'" + &
				 "t_frm_ymd.text   = '" + is_frm_ymd + "'" + &
 				 "t_to_ymd.text    = '" + is_to_ymd + "'" 


dw_print.Modify(ls_modify)


end event

event ue_preview();
This.Trigger Event ue_title ()

dw_print.retrieve(is_brand, is_frm_ymd, is_to_ymd, is_shop_cd, is_sale_gubn)
dw_print.inv_printpreview.of_SetZoom()



end event

event ue_print();This.Trigger Event ue_title()

dw_print.retrieve(is_brand, is_frm_ymd, is_to_ymd, is_shop_cd, is_sale_gubn)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_51010_d","0")
end event

type cb_close from w_com010_d`cb_close within w_51010_d
end type

type cb_delete from w_com010_d`cb_delete within w_51010_d
end type

type cb_insert from w_com010_d`cb_insert within w_51010_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_51010_d
end type

type cb_update from w_com010_d`cb_update within w_51010_d
end type

type cb_print from w_com010_d`cb_print within w_51010_d
end type

type cb_preview from w_com010_d`cb_preview within w_51010_d
end type

type gb_button from w_com010_d`gb_button within w_51010_d
end type

type cb_excel from w_com010_d`cb_excel within w_51010_d
end type

type dw_head from w_com010_d`dw_head within w_51010_d
integer x = 1001
integer y = 180
integer width = 2409
string dataobject = "d_51010_h01"
end type

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		

END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

type ln_1 from w_com010_d`ln_1 within w_51010_d
end type

type ln_2 from w_com010_d`ln_2 within w_51010_d
end type

type dw_body from w_com010_d`dw_body within w_51010_d
string dataobject = "d_51010_d01A"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_51010_d
string dataobject = "d_51010_R01a"
end type

type rb_1 from radiobutton within w_51010_d
integer x = 73
integer y = 200
integer width = 576
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "행사시작일자기준"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
string ls_modify

ls_modify = "to_ymd.visible = true frm_ymd_t.text = '기간:' t_1.visible = true "
dw_head.Modify(ls_modify)

dw_body.dataobject = "d_51010_d01a"
dw_body.SetTransObject(SQLCA)

dw_print.dataobject = "d_51010_r01a"
dw_print.SetTransObject(SQLCA)

parent.Trigger Event ue_retrieve()	//조회
end event

type rb_2 from radiobutton within w_51010_d
integer x = 73
integer y = 280
integer width = 576
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "기준일자진행내역"
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_modify

ls_modify = "to_ymd.visible = false frm_ymd_t.text = '기준일자:' t_1.visible = false "
dw_head.Modify(ls_modify)

dw_body.dataobject = "d_51010_d02"
dw_body.SetTransObject(SQLCA)
dw_print.dataobject = "d_51010_r02"
dw_print.SetTransObject(SQLCA)

parent.Trigger Event ue_retrieve()	//조회
end event

type rb_3 from radiobutton within w_51010_d
boolean visible = false
integer x = 73
integer y = 356
integer width = 873
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "행사내역상세(시작일자기준)"
borderstyle borderstyle = stylelowered!
end type

event clicked;
string ls_modify

ls_modify = "to_ymd.visible = true frm_ymd_t.text = '기간:' t_1.visible = true "
dw_head.Modify(ls_modify)

dw_body.dataobject = "d_51010_d01"
dw_body.SetTransObject(SQLCA)
dw_print.dataobject = "d_51010_r01"
dw_print.SetTransObject(SQLCA)

parent.Trigger Event ue_retrieve()	//조회
end event

type gb_1 from groupbox within w_51010_d
integer x = 41
integer y = 152
integer width = 928
integer height = 280
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

