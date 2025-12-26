$PBExportHeader$w_61012_d.srw
$PBExportComments$회전율조회
forward
global type w_61012_d from w_com010_d
end type
type dw_1 from datawindow within w_61012_d
end type
type rb_rot_rate from radiobutton within w_61012_d
end type
type rb_stock_day from radiobutton within w_61012_d
end type
type dw_2 from datawindow within w_61012_d
end type
end forward

global type w_61012_d from w_com010_d
integer width = 3671
integer height = 2248
dw_1 dw_1
rb_rot_rate rb_rot_rate
rb_stock_day rb_stock_day
dw_2 dw_2
end type
global w_61012_d w_61012_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_sojae, idw_item
String is_brand,is_year, is_season, is_yymmdd, is_shop_cd, is_shop_type
String is_sojae, is_item, is_style_No, is_amt_gubn
end variables

forward prototypes
public function boolean wf_body_set (integer ai_column)
end prototypes

public function boolean wf_body_set (integer ai_column);String  ls_modify,   ls_error
String  ls_size , ls_yymm
Long    ll_stock_qty
integer i, k

/* 사이즈 셋 */
FOR i = 1 TO 12 
      ls_modify = ' s_stock'    + String(i,'00') + '.Visible=0' + &
                  ' e_stock'    + String(i,'00') + '.Visible=0' + &
                  ' avg_stock'  + String(i,'00') + '.Visible=0' + &
                  ' sale_amt'   + String(i,'00') + '.Visible=0' + &						
                  ' rot_rate'   + String(i,'00') + '.Visible=0' + &						
                  ' mm_day'     + String(i,'00') + '.Visible=0' + &						
                  ' stock_day'  + String(i,'00') + '.Visible=0' 				

	ls_Error = dw_1.Modify(ls_modify)
	
	IF (ls_Error <> "") THEN 
		MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
		Return False
	END IF
NEXT 

		ls_yymm = LeftA(is_yymmdd,4) + '.' + String(ai_column,'00')

      ls_modify = ' s_stock'    + String(ai_column,'00') + '.Visible=1' + &
                  ' s_stock'    + String(ai_column,'00') + '.x = 933' + &						
                  ' s_stock'    + String(ai_column,'00') + '.width = 329' + &												
                  ' e_stock'    + String(ai_column,'00') + '.Visible=1' + &
                  ' e_stock'    + String(ai_column,'00') + '.x = 1275' + &						
                  ' e_stock'    + String(ai_column,'00') + '.width = 329' + &												
                  ' avg_stock'  + String(ai_column,'00') + '.Visible=1' + &
                  ' avg_stock'  + String(ai_column,'00') + '.x = 1618' + &
                  ' avg_stock'  + String(ai_column,'00') + '.width=329' + &						
                  ' sale_amt'   + String(ai_column,'00') + '.Visible=1' + &						
                  ' sale_amt'   + String(ai_column,'00') + '.x=1952' + &						
                  ' sale_amt'   + String(ai_column,'00') + '.width=329' + &												
                  ' rot_rate'   + String(ai_column,'00') + '.Visible=1' + &						
                  ' rot_rate'   + String(ai_column,'00') + '.x=2295' + &						
                  ' rot_rate'   + String(ai_column,'00') + '.width=201' + &												
                  ' stock_day'  + String(ai_column,'00') + '.Visible=1' + &
                  ' stock_day'  + String(ai_column,'00') + '.x=2510' + &
                  ' stock_day'  + String(ai_column,'00') + '.width=247' + &
						" t_yymm.Text = '" + ls_yymm + "'"

	ls_Error = dw_1.Modify(ls_modify)
	
	IF (ls_Error <> "") THEN 
		MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
		Return False
	END IF

Return True 
end function

on w_61012_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rb_rot_rate=create rb_rot_rate
this.rb_stock_day=create rb_stock_day
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rb_rot_rate
this.Control[iCurrent+3]=this.rb_stock_day
this.Control[iCurrent+4]=this.dw_2
end on

on w_61012_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rb_rot_rate)
destroy(this.rb_stock_day)
destroy(this.dw_2)
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


is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

//messagebox("is_year", is_year)

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if


is_yymmdd = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if



is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_amt_gubn = dw_head.GetItemString(1, "amt_gubn")
if IsNull(is_amt_gubn) or Trim(is_amt_gubn) = "" then
   MessageBox(ls_title,"금액지군을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("amt_gubn")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */

dw_1.visible = false
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_2.retrieve(is_brand, is_year, is_season, is_yymmdd, is_shop_type, is_amt_gubn)
IF il_rows > 0 THEN
	dw_2.ShareData(dw_1)
	dw_2.ShareData(dw_body)
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
String 	  ls_plan_yn, ls_SHOP_TYPE
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm3(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV  IN ('G', 'K', 'D') " + &
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
				dw_head.SetColumn("shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			
	CASE "style_no"				
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF gf_style_chk(as_data, '%') = True THEN
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "STYLE 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "STYLE LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style"))

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

event open;call super::open;dw_head.setitem(1,"year", "%")
dw_head.setitem(1,"season", "%")
end event

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime,ls_title, ls_shop_type_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


if is_shop_type = "1" then 
   ls_shop_type_nm = "정상"
elseif is_shop_type = "3" then 
   ls_shop_type_nm = "정상+기획"	
else
   ls_shop_type_nm = "전체(행사포함)"
end if

ls_modify  = "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
				 "t_yymm.Text = '" + String(is_yymmdd, '@@@@/@@/@@') + "'"  + &
				 "t_sale_type.Text = '" + ls_shop_type_nm + "'" 
dw_print.Modify(ls_modify)





end event

type cb_close from w_com010_d`cb_close within w_61012_d
end type

type cb_delete from w_com010_d`cb_delete within w_61012_d
end type

type cb_insert from w_com010_d`cb_insert within w_61012_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61012_d
end type

type cb_update from w_com010_d`cb_update within w_61012_d
end type

type cb_print from w_com010_d`cb_print within w_61012_d
end type

type cb_preview from w_com010_d`cb_preview within w_61012_d
end type

type gb_button from w_com010_d`gb_button within w_61012_d
end type

type cb_excel from w_com010_d`cb_excel within w_61012_d
end type

type dw_head from w_com010_d`dw_head within w_61012_d
integer y = 184
integer height = 264
string dataobject = "d_61012_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "Inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "Inter_cd", '%')
idw_year.SetItem(1, "Inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;
String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "shop_cd","style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		

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

type ln_1 from w_com010_d`ln_1 within w_61012_d
integer beginx = 23
integer beginy = 448
integer endx = 3643
integer endy = 448
end type

type ln_2 from w_com010_d`ln_2 within w_61012_d
integer beginx = -32
integer beginy = 452
integer endx = 3589
integer endy = 452
end type

type dw_body from w_com010_d`dw_body within w_61012_d
integer y = 460
integer height = 1552
string dataobject = "d_61012_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::doubleclicked;call super::doubleclicked;String 	ls_search,ls_col
integer i
if row > 0 then 
	
	
	choose case LeftA(dwo.name,8)
		case 'rot_rate' , 'stock_da'
			dw_1.visible = true
			ls_col = RightA(dwo.name,2)
			i = integer(ls_col)
			wf_body_set( i)
	end choose	
end if
end event

type dw_print from w_com010_d`dw_print within w_61012_d
string dataobject = "d_61012_r01"
end type

type dw_1 from datawindow within w_61012_d
boolean visible = false
integer x = 14
integer y = 468
integer width = 3589
integer height = 1580
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_61012_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;			dw_1.visible = false
end event

type rb_rot_rate from radiobutton within w_61012_d
integer x = 3054
integer y = 232
integer width = 457
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
string text = "회전율"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
This.TextColor        = RGB(0, 0, 255)
rb_stock_day.TextColor    = 0
dw_1.visible = false

dw_body.DataObject  = 'd_61012_d01'
dw_body.SetTransObject(SQLCA)

dw_print.DataObject = 'd_61012_r01'
dw_print.SetTransObject(SQLCA)

dw_2.ShareData(dw_body)


end event

type rb_stock_day from radiobutton within w_61012_d
integer x = 3054
integer y = 312
integer width = 457
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
string text = "재고일수"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
rb_rot_rate.TextColor    = 0
dw_1.visible = false

dw_body.DataObject  = 'd_61012_d04'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_61012_r04'
dw_print.SetTransObject(SQLCA)
dw_2.ShareData(dw_body)
end event

type dw_2 from datawindow within w_61012_d
boolean visible = false
integer x = 2903
integer y = 696
integer width = 571
integer height = 600
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_61012_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

