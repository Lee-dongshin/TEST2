$PBExportHeader$w_53060_e.srw
$PBExportComments$예약판매현황
forward
global type w_53060_e from w_com010_e
end type
type rb_1 from radiobutton within w_53060_e
end type
type rb_2 from radiobutton within w_53060_e
end type
type dw_1 from u_dw within w_53060_e
end type
type dw_2 from u_dw within w_53060_e
end type
type rb_3 from radiobutton within w_53060_e
end type
type rb_4 from radiobutton within w_53060_e
end type
end forward

global type w_53060_e from w_com010_e
integer width = 3680
rb_1 rb_1
rb_2 rb_2
dw_1 dw_1
dw_2 dw_2
rb_3 rb_3
rb_4 rb_4
end type
global w_53060_e w_53060_e

type variables
DataWindowChild idw_season, idw_color, idw_brand

String is_shop_cd, is_year, is_season, is_style, is_color, is_size, is_fr_yymmdd, is_to_yymmdd, is_chk_yn, is_brand
end variables

on w_53060_e.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rb_3=create rb_3
this.rb_4=create rb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.rb_4
end on

on w_53060_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rb_3)
destroy(this.rb_4)
end on

event ue_retrieve();/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN




il_rows = dw_body.retrieve(is_shop_cd, is_year, is_season,is_fr_yymmdd, is_to_yymmdd, is_chk_yn, is_brand)


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
   MessageBox(ls_title,"브랜드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd"))
if IsNull(is_shop_cd) or is_shop_cd = "" then
   is_shop_cd = '%'
end if

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if



is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if


is_fr_yymmdd = Trim(dw_head.GetItemString(1, "fr_yymmdd"))
if IsNull(is_fr_yymmdd) or is_fr_yymmdd = "" then
   MessageBox(ls_title,"날짜를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymmdd")
   return false
end if


is_to_yymmdd = Trim(dw_head.GetItemString(1, "to_yymmdd"))
if IsNull(is_to_yymmdd) or is_to_yymmdd = "" then
   MessageBox(ls_title,"날짜를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if

is_chk_yn = Trim(dw_head.GetItemString(1, "chk_yn"))
end event

event open;call super::open;string ls_date

dw_head.Setitem(1,'season', '%')
dw_head.Setitem(1,'year', '%')
dw_head.Setitem(1,'chk_yn', 'N')



select convert(varchar,getdate(),112)
into :ls_date
from dual;

dw_head.Setitem(1,'fr_yymmdd', LeftA(ls_date,6)+'01')
dw_head.Setitem(1,'to_yymmdd', ls_date)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm ,is_brand 
Boolean    lb_check 
DataStore  lds_Source



CHOOSE CASE as_column
	CASE "shop_cd"
		is_brand = 'N'
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				IF LeftA(as_data, 1) = is_brand And gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm",  ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
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
				dw_head.SetColumn("year")
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

event resize;call super::resize;newwidth = this.WorkSpaceWidth() 
newheight = this.WorkSpaceHeight()

dw_1.resize(newwidth, newheight - 340)
end event

type cb_close from w_com010_e`cb_close within w_53060_e
end type

type cb_delete from w_com010_e`cb_delete within w_53060_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_53060_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_53060_e
end type

type cb_update from w_com010_e`cb_update within w_53060_e
boolean visible = false
end type

type cb_print from w_com010_e`cb_print within w_53060_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_53060_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_53060_e
end type

type cb_excel from w_com010_e`cb_excel within w_53060_e
end type

type dw_head from w_com010_e`dw_head within w_53060_e
integer height = 224
string dataobject = "d_53060_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)


		
		

		
END CHOOSE
end event

type ln_1 from w_com010_e`ln_1 within w_53060_e
integer beginy = 404
integer endy = 404
end type

type ln_2 from w_com010_e`ln_2 within w_53060_e
integer beginy = 408
integer endy = 408
end type

type dw_body from w_com010_e`dw_body within w_53060_e
integer y = 420
integer width = 3570
string dataobject = "d_53060_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')


This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()

end event

event dw_body::doubleclicked;call super::doubleclicked;string ls_shop_nm, ls_shop_cd



CHOOSE CASE dwo.name   
	CASE "season", "style"
		
			is_year = this.getitemstring(row,"year")
			is_season = this.getitemstring(row,"season")
			is_style = this.getitemstring(row,"style")
			is_color = this.getitemstring(row,"color")
			is_size = this.getitemstring(row,"size")
		
			dw_1.DataObject  = 'd_53060_d03'
			dw_1.SetTransObject(SQLCA)
			
			il_rows = dw_1.retrieve(is_year, is_season, is_style, is_color, is_size, is_fr_yymmdd, is_to_yymmdd, is_chk_yn, is_shop_cd)	
			
			if il_rows > 0 then 
				dw_1.title = '매장별 예약판매 현황'
				dw_1.visible = true
				dw_1.SetFocus()
			end if

	CASE "shop_cd"
			ls_shop_cd = this.getitemstring(row,"shop_cd")
			
			dw_2.DataObject  = 'd_53060_d04'
			dw_2.SetTransObject(SQLCA)
			
			il_rows = dw_2.retrieve(ls_shop_cd, is_fr_yymmdd, is_to_yymmdd, is_chk_yn)	
			
			if il_rows > 0 then 
				dw_2.title = '매장별 예약판매 현황'
				dw_2.visible = true
				dw_2.SetFocus()
			end if

END CHOOSE
end event

type dw_print from w_com010_e`dw_print within w_53060_e
integer x = 2464
integer y = 460
end type

type rb_1 from radiobutton within w_53060_e
integer x = 41
integer y = 56
integer width = 279
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
string text = "시즌별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;this.TextColor     = RGB(0, 0, 255)
rb_2.TextColor     = 0
rb_3.TextColor     = 0
rb_4.TextColor     = 0

dw_1.visible = False
dw_2.visible = False


dw_body.DataObject  = 'd_53060_d01'
dw_body.SetTransObject(SQLCA)


dw_body.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

end event

type rb_2 from radiobutton within w_53060_e
integer x = 370
integer y = 56
integer width = 279
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
string text = "Style별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_1.TextColor     = 0
this.TextColor     = RGB(0, 0, 255)
rb_3.TextColor     = 0
rb_4.TextColor     = 0

dw_1.visible = False
dw_2.visible = False



dw_body.DataObject  = 'd_53060_d02'
dw_body.SetTransObject(SQLCA)


dw_body.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()

end event

type dw_1 from u_dw within w_53060_e
boolean visible = false
integer x = 5
integer y = 340
integer width = 3570
integer height = 1652
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_53060_d03"
boolean controlmenu = true
boolean hscrollbar = true
end type

event doubleclicked;call super::doubleclicked;string ls_shop_nm, ls_shop_cd





CHOOSE CASE dwo.name   
	CASE "shop_cd"
			ls_shop_cd = this.getitemstring(row,"shop_cd")
			
			dw_2.DataObject  = 'd_53060_d04'
			dw_2.SetTransObject(SQLCA)
			
			il_rows = dw_2.retrieve(ls_shop_cd, is_fr_yymmdd, is_to_yymmdd, is_chk_yn)	
			
			if il_rows > 0 then 
				dw_2.title = '매장별 예약판매 현황'
				dw_2.visible = true
				dw_2.SetFocus()
			end if

END CHOOSE
end event

type dw_2 from u_dw within w_53060_e
boolean visible = false
integer x = 55
integer y = 744
integer width = 3538
integer height = 632
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_53060_d04"
boolean controlmenu = true
boolean hscrollbar = true
boolean livescroll = false
end type

event constructor;call super::constructor;
This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()


This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)


end event

type rb_3 from radiobutton within w_53060_e
integer x = 1198
integer y = 56
integer width = 279
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
string text = "매장별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_1.TextColor     = 0
rb_2.TextColor     = 0
this.TextColor     = RGB(0, 0, 255)
rb_4.TextColor     = 0

dw_1.visible = False
dw_2.visible = False



dw_body.DataObject  = 'd_53060_d05'
dw_body.SetTransObject(SQLCA)

end event

type rb_4 from radiobutton within w_53060_e
integer x = 695
integer y = 56
integer width = 439
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
string text = "매장 Style 별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_1.TextColor     = 0
rb_2.TextColor     = 0
rb_3.TextColor     = 0
this.TextColor     = RGB(0, 0, 255)

dw_1.visible = False
dw_2.visible = False



dw_body.DataObject  = 'd_53060_d04'
dw_body.SetTransObject(SQLCA)


dw_body.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()

end event

