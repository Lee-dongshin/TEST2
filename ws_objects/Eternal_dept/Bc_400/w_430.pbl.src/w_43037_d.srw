$PBExportHeader$w_43037_d.srw
$PBExportComments$매장창고재고조회
forward
global type w_43037_d from w_com010_d
end type
type cbx_1 from checkbox within w_43037_d
end type
type cbx_2 from checkbox within w_43037_d
end type
type cbx_7 from checkbox within w_43037_d
end type
type cbx_8 from checkbox within w_43037_d
end type
type cbx_9 from checkbox within w_43037_d
end type
type cbx_10 from checkbox within w_43037_d
end type
type cbx_3 from checkbox within w_43037_d
end type
type cbx_4 from checkbox within w_43037_d
end type
type cbx_5 from checkbox within w_43037_d
end type
type cbx_6 from checkbox within w_43037_d
end type
type st_1 from statictext within w_43037_d
end type
type rb_h from radiobutton within w_43037_d
end type
type rb_f from radiobutton within w_43037_d
end type
type rb_e from radiobutton within w_43037_d
end type
type rb_d from radiobutton within w_43037_d
end type
type rb_c from radiobutton within w_43037_d
end type
type rb_b from radiobutton within w_43037_d
end type
type rb_a from radiobutton within w_43037_d
end type
type rb_g from radiobutton within w_43037_d
end type
type gb_1 from groupbox within w_43037_d
end type
end forward

global type w_43037_d from w_com010_d
integer width = 3675
integer height = 2276
cbx_1 cbx_1
cbx_2 cbx_2
cbx_7 cbx_7
cbx_8 cbx_8
cbx_9 cbx_9
cbx_10 cbx_10
cbx_3 cbx_3
cbx_4 cbx_4
cbx_5 cbx_5
cbx_6 cbx_6
st_1 st_1
rb_h rb_h
rb_f rb_f
rb_e rb_e
rb_d rb_d
rb_c rb_c
rb_b rb_b
rb_a rb_a
rb_g rb_g
gb_1 gb_1
end type
global w_43037_d w_43037_d

type variables
Datawindowchild idw_brand, idw_shop_type, idw_year, idw_season, idw_house_cd
String is_brand, is_shop_cd, is_yymmdd, is_shop_type, is_year, is_season, is_style_no, is_gubn, is_house_cd
string is_shop_div, is_shop_div2, is_shop_div3, is_shop_div4, is_shop_div5, is_shop_div6, is_shop_div7, is_shop_div8, is_shop_div9, is_shop_div10, is_shop_div11
end variables

on w_43037_d.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.cbx_7=create cbx_7
this.cbx_8=create cbx_8
this.cbx_9=create cbx_9
this.cbx_10=create cbx_10
this.cbx_3=create cbx_3
this.cbx_4=create cbx_4
this.cbx_5=create cbx_5
this.cbx_6=create cbx_6
this.st_1=create st_1
this.rb_h=create rb_h
this.rb_f=create rb_f
this.rb_e=create rb_e
this.rb_d=create rb_d
this.rb_c=create rb_c
this.rb_b=create rb_b
this.rb_a=create rb_a
this.rb_g=create rb_g
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.cbx_2
this.Control[iCurrent+3]=this.cbx_7
this.Control[iCurrent+4]=this.cbx_8
this.Control[iCurrent+5]=this.cbx_9
this.Control[iCurrent+6]=this.cbx_10
this.Control[iCurrent+7]=this.cbx_3
this.Control[iCurrent+8]=this.cbx_4
this.Control[iCurrent+9]=this.cbx_5
this.Control[iCurrent+10]=this.cbx_6
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.rb_h
this.Control[iCurrent+13]=this.rb_f
this.Control[iCurrent+14]=this.rb_e
this.Control[iCurrent+15]=this.rb_d
this.Control[iCurrent+16]=this.rb_c
this.Control[iCurrent+17]=this.rb_b
this.Control[iCurrent+18]=this.rb_a
this.Control[iCurrent+19]=this.rb_g
this.Control[iCurrent+20]=this.gb_1
end on

on w_43037_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.cbx_7)
destroy(this.cbx_8)
destroy(this.cbx_9)
destroy(this.cbx_10)
destroy(this.cbx_3)
destroy(this.cbx_4)
destroy(this.cbx_5)
destroy(this.cbx_6)
destroy(this.st_1)
destroy(this.rb_h)
destroy(this.rb_f)
destroy(this.rb_e)
destroy(this.rb_d)
destroy(this.rb_c)
destroy(this.rb_b)
destroy(this.rb_a)
destroy(this.rb_g)
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

is_house_cd = dw_head.GetItemString(1, "house")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if


is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_style_no = dw_head.GetItemString(1, "style_no")
if IsNull(is_style_no) or Trim(is_style_no) = "" then
  is_style_no = "%"
end if


is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
  is_shop_cd = "%"
end if

If cbx_1.checked then 
	is_shop_div = '%'
ELSE
	is_shop_div = ''
end if

If cbx_2.checked then 
	is_shop_div2 = 'A'
ELSE
	is_shop_div2 = ''
end if

If cbx_3.checked then 
	is_shop_div3 = 'D'
ELSE
	is_shop_div3 = ''
end if

If cbx_4.checked then 
	is_shop_div4 = 'G'
ELSE
	is_shop_div4 = ''
end if


If cbx_5.checked then 
	is_shop_div5 = 'O'
ELSE
	is_shop_div5 = ''
end if

If cbx_6.checked then 
	is_shop_div6 = 'F'
ELSE
	is_shop_div6 = ''
end if

If cbx_7.checked then 
	is_shop_div7 = 'M'
ELSE
	is_shop_div7 = ''
end if


If cbx_8.checked then 
	is_shop_div8 = 'U'
ELSE
	is_shop_div8 = ''
end if


If cbx_9.checked then 
	is_shop_div9 = 'H'
ELSE
	is_shop_div9 = ''
end if


If cbx_10.checked then 
	is_shop_div10 = 'X'
ELSE
	is_shop_div10 = ''
end if



return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
			IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 				
				
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
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

event ue_retrieve();call super::ue_retrieve;IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

// procedure [dbo].[SP_43037_D01]
//				@base_yymmdd	varchar(08),
//				@brand 		varchar(01),
//				@shop_cd	varchar(06),
//				@shop_TYPE	varchar(01),
//				@HOUSE_CD	VARCHAR(06),
//				@style		varchar(08),
//				@year		varchar(04),
//				@season  	varchar(01),
//				@sojae		varchar(01),
//				@item		varchar(01),
//				@chno_gubn	varchar(01),
//				@ps_shop_div		VARCHAR(1),    -- 유통망	% 전체
//				@ps_shop_div2		VARCHAR(1),    -- 유통망	A 일반몰
//				@ps_shop_div3		VARCHAR(1),    -- 유통망	D 백화점몰
//				@ps_shop_div4		VARCHAR(1),    -- 유통망	G 글로벌
//				@ps_shop_div5		VARCHAR(1),    -- 유통망	O 직영
//				@ps_shop_div6		VARCHAR(1),    -- 유통망	F 오프라인
//				@ps_shop_div7		VARCHAR(1),    -- 유통망	M 면세
//				@ps_shop_div8		VARCHAR(1),    -- 유통망	U 아울렛
//				@ps_shop_div9		VARCHAR(1),    -- 유통망	H 홀세일
//				@ps_shop_div10		VARCHAR(1) ,   -- 유통망		X 기타
//				@ps_shop_stat		VARCHAR(02),    -- 폐점제외여부  'y'
//				@opt_view		varchar(01)     -- a: 품번별 , b :품번별차수무시, c:품번칼라  , d: 품번칼라 차수무시, e:품번칼라사이즈  f: 품번칼라사이즈 차수무시 H : 매장별 품번칼라사이즈
//


//messagebox("is_yymmdd", is_yymmdd )
//messagebox("is_brand", is_brand)
//messagebox("is_shop_cd",is_shop_cd)
//messagebox("is_shop_type",is_shop_type)
//messagebox("is_house_cd",is_house_cd)
//messagebox("is_style_no",is_style_no)
//messagebox("is_year",is_year)
//messagebox("is_season",is_season)
//messagebox("is_shop_div",is_shop_div)
//messagebox("is_shop_div2",is_shop_div2)
//messagebox("is_shop_div3",is_shop_div3)
//messagebox("is_shop_div4",is_shop_div4)
//messagebox("is_shop_div5",is_shop_div5)
//messagebox("is_shop_div6",is_shop_div6)
//messagebox("is_shop_div7",is_shop_div7)
//messagebox("is_shop_div8",is_shop_div8)
//messagebox("is_shop_div9",is_shop_div9)
//messagebox("is_shop_div10",is_shop_div10)
//messagebox("is_gubn",is_gubn)
il_rows = dw_body.retrieve(is_yymmdd, is_brand, is_shop_cd, is_shop_type, is_house_cd, is_style_no, is_year, is_season, '%','%','%',is_shop_div,is_shop_div2,is_shop_div3,is_shop_div4,is_shop_div5,is_shop_div6,is_shop_div7,is_shop_div8,is_shop_div9,is_shop_div10,'%' ,is_gubn)
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

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm

ls_shoP_nm = dw_head.getitemstring( 1, "shop_nm")

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
             "t_yymmdd.Text = '" + is_yymmdd + "'" + &
             "t_shop_cd.Text = '" + is_shop_cd + "'" + &				 
             "t_shop_nm.Text = '" + ls_shop_nm + "'" + &
 				 "t_shop_type.Text = '" + idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "'" 

dw_print.Modify(ls_modify)


end event

event open;call super::open;is_gubn = 'A'
end event

type cb_close from w_com010_d`cb_close within w_43037_d
end type

type cb_delete from w_com010_d`cb_delete within w_43037_d
end type

type cb_insert from w_com010_d`cb_insert within w_43037_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43037_d
end type

type cb_update from w_com010_d`cb_update within w_43037_d
end type

type cb_print from w_com010_d`cb_print within w_43037_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_43037_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_43037_d
end type

type cb_excel from w_com010_d`cb_excel within w_43037_d
end type

type dw_head from w_com010_d`dw_head within w_43037_d
integer x = 5
integer y = 324
integer width = 3131
integer height = 276
string dataobject = "d_43037_h01"
boolean maxbox = true
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

This.GetChild("house", idw_house_cd )
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('%')
//idw_house_cd.insertrow(1)
//idw_house_cd.Setitem(1, "shop_cd", "%")
//idw_house_cd.Setitem(1, "shop_snm", "전체")
//


this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('009')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "brand", "year"		
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_43037_d
integer beginy = 600
integer endy = 600
end type

type ln_2 from w_com010_d`ln_2 within w_43037_d
integer beginy = 604
integer endy = 604
end type

type dw_body from w_com010_d`dw_body within w_43037_d
integer y = 616
integer height = 1424
string dataobject = "d_43037_d01"
end type

type dw_print from w_com010_d`dw_print within w_43037_d
string dataobject = "d_43036_r01"
end type

type cbx_1 from checkbox within w_43037_d
integer x = 2478
integer y = 344
integer width = 302
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
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;cbx_2.checked = False
cbx_3.checked = False
cbx_4.checked = False
cbx_5.checked = False
cbx_6.checked = False
cbx_7.checked = False
cbx_8.checked = False
cbx_9.checked = False
cbx_10.checked = False

end event

type cbx_2 from checkbox within w_43037_d
integer x = 2478
integer y = 404
integer width = 302
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
string text = "일반몰"
borderstyle borderstyle = stylelowered!
end type

event clicked;cbx_1.checked = False

end event

type cbx_7 from checkbox within w_43037_d
integer x = 3081
integer y = 344
integer width = 293
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
string text = "면세"
borderstyle borderstyle = stylelowered!
end type

event clicked;cbx_1.checked = False

end event

type cbx_8 from checkbox within w_43037_d
integer x = 3081
integer y = 404
integer width = 293
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
string text = "아울렛"
borderstyle borderstyle = stylelowered!
end type

event clicked;cbx_1.checked = False

end event

type cbx_9 from checkbox within w_43037_d
integer x = 3081
integer y = 472
integer width = 293
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
string text = "홀세일"
borderstyle borderstyle = stylelowered!
end type

event clicked;cbx_1.checked = False

end event

type cbx_10 from checkbox within w_43037_d
integer x = 3387
integer y = 344
integer width = 293
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
string text = "기타"
borderstyle borderstyle = stylelowered!
end type

event clicked;cbx_1.checked = False

end event

type cbx_3 from checkbox within w_43037_d
integer x = 2478
integer y = 472
integer width = 302
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
string text = "백화점몰"
borderstyle borderstyle = stylelowered!
end type

event clicked;cbx_1.checked = False

end event

type cbx_4 from checkbox within w_43037_d
integer x = 2784
integer y = 344
integer width = 293
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
string text = "글로벌"
borderstyle borderstyle = stylelowered!
end type

event clicked;cbx_1.checked = False

end event

type cbx_5 from checkbox within w_43037_d
integer x = 2784
integer y = 404
integer width = 293
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
string text = "직영몰"
borderstyle borderstyle = stylelowered!
end type

event clicked;cbx_1.checked = False

end event

type cbx_6 from checkbox within w_43037_d
integer x = 2784
integer y = 472
integer width = 302
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
string text = "오프라인"
borderstyle borderstyle = stylelowered!
end type

event clicked;cbx_1.checked = False

end event

type st_1 from statictext within w_43037_d
integer x = 2217
integer y = 460
integer width = 233
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "유통망"
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_h from radiobutton within w_43037_d
integer x = 1856
integer y = 180
integer width = 686
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
string text = "품번칼라사이즈(매장별)"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
is_gubn = 'H'
rb_a.TextColor     = 0
rb_b.TextColor     = 0
rb_c.TextColor     = 0
rb_d.TextColor = 0
rb_e.TextColor    = 0
rb_f.TextColor       = 0
rb_g.TextColor       = 0
end event

type rb_f from radiobutton within w_43037_d
integer x = 1102
integer y = 248
integer width = 658
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
string text = "품번칼라사이즈(차수X)"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
is_gubn = 'F'
rb_a.TextColor     = 0
rb_b.TextColor     = 0
rb_c.TextColor     = 0
rb_d.TextColor = 0
rb_e.TextColor    = 0
rb_h.TextColor       = 0
rb_g.TextColor       = 0
end event

type rb_e from radiobutton within w_43037_d
integer x = 1102
integer y = 180
integer width = 466
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
string text = "품번칼라사이즈"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
is_gubn = 'E'
rb_a.TextColor     = 0
rb_b.TextColor     = 0
rb_c.TextColor     = 0
rb_d.TextColor = 0
rb_f.TextColor    = 0
rb_h.TextColor       = 0
rb_g.TextColor       = 0

end event

type rb_d from radiobutton within w_43037_d
integer x = 549
integer y = 248
integer width = 494
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
string text = "품번칼라(차수X)"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
is_gubn = 'D'
rb_a.TextColor     = 0
rb_b.TextColor     = 0
rb_c.TextColor     = 0
rb_e.TextColor = 0
rb_f.TextColor    = 0
rb_h.TextColor       = 0
rb_g.TextColor       = 0

end event

type rb_c from radiobutton within w_43037_d
integer x = 549
integer y = 180
integer width = 302
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80269524
string text = "품번칼라"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
is_gubn = 'C'
rb_a.TextColor     = 0
rb_b.TextColor     = 0
rb_d.TextColor     = 0
rb_e.TextColor = 0
rb_f.TextColor    = 0
rb_h.TextColor       = 0
rb_g.TextColor       = 0

end event

type rb_b from radiobutton within w_43037_d
integer x = 23
integer y = 248
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
long backcolor = 80269524
string text = "품번별(차수X)"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
is_gubn = 'B'
rb_a.TextColor     = 0
rb_c.TextColor     = 0
rb_d.TextColor     = 0
rb_e.TextColor = 0
rb_f.TextColor    = 0
rb_h.TextColor       = 0
rb_g.TextColor       = 0

end event

type rb_a from radiobutton within w_43037_d
integer x = 23
integer y = 180
integer width = 283
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
string text = "품번별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
is_gubn = 'A'
rb_b.TextColor     = 0
rb_c.TextColor     = 0
rb_d.TextColor     = 0
rb_e.TextColor = 0
rb_f.TextColor    = 0
rb_h.TextColor       = 0
rb_g.TextColor       = 0

end event

type rb_g from radiobutton within w_43037_d
integer x = 1856
integer y = 248
integer width = 850
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
string text = "품번칼라사이즈(매장별-차수X)"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
is_gubn = 'G'
rb_a.TextColor     = 0
rb_b.TextColor     = 0
rb_c.TextColor     = 0
rb_d.TextColor = 0
rb_e.TextColor    = 0
rb_f.TextColor       = 0
rb_h.TextColor       = 0


end event

type gb_1 from groupbox within w_43037_d
integer y = 140
integer width = 4110
integer height = 188
integer taborder = 150
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

