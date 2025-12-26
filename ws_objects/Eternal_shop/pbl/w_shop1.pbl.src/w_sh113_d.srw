$PBExportHeader$w_sh113_d.srw
$PBExportComments$타매장 재고조회
forward
global type w_sh113_d from w_com010_d
end type
type cb_house from commandbutton within w_sh113_d
end type
type dw_1 from datawindow within w_sh113_d
end type
type st_1 from statictext within w_sh113_d
end type
type st_2 from statictext within w_sh113_d
end type
type t_tag from editmask within w_sh113_d
end type
type rb_1 from radiobutton within w_sh113_d
end type
type rb_2 from radiobutton within w_sh113_d
end type
end forward

global type w_sh113_d from w_com010_d
long backcolor = 16777215
cb_house cb_house
dw_1 dw_1
st_1 st_1
st_2 st_2
t_tag t_tag
rb_1 rb_1
rb_2 rb_2
end type
global w_sh113_d w_sh113_d

type variables
DataWindowChild idw_color, idw_size
String is_style, is_chno , is_color	, is_size
end variables

on w_sh113_d.create
int iCurrent
call super::create
this.cb_house=create cb_house
this.dw_1=create dw_1
this.st_1=create st_1
this.st_2=create st_2
this.t_tag=create t_tag
this.rb_1=create rb_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_house
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.t_tag
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
end on

on w_sh113_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_house)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.t_tag)
destroy(this.rb_1)
destroy(this.rb_2)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno 
Boolean    lb_check 
Long ll_b_cnt
DataStore  lds_Source 



if MidA(gs_shop_cd_1,1,2) = 'XX' then
	If Trim(as_data) = '' or isnull(as_data) then
	else
		gs_brand = MidA(as_data,1,1)
		gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
	end if
end if


select isnull(count(brand),0)
into	:ll_b_cnt
from tb_91100_m  with (nolock) 
where shop_cd like '%' + substring(:gs_shop_cd,3,4)
		and brand = :gs_brand;	
		
if ll_b_cnt = 0 then 
	messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
	return 0
end if

CHOOSE CASE as_column
	CASE "style_no"	
		
			ls_style = LeftA(as_data, 8)  
			ls_chno  = MidA(as_data, 9, 1)  
//			IF ai_div = 1 THEN 	
//				IF gf_style_chk(ls_style, ls_chno)  THEN
//					RETURN 0 
//				END IF 
//			END IF
//
			this.t_tag.text = ''
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" + &
				                " and chno  LIKE '" + ls_chno + "%'" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lb_check = FALSE 
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
	

				this.t_tag.text = string(lds_Source.GetItemDecimal(1,"tag_price"),"###,###")
	
			   /* 다음컬럼으로 이동 */
			   dw_head.SetColumn("flag")
		      lb_check = TRUE 
				ib_itemchanged = FALSE
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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                    */	
/* 작성일      : 2002.04.28                                                  */	
/* 수정일      : 2002.04.28                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title, ls_style_no , LS_FLAG

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

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

ls_style_no = dw_head.GetItemString(1, "style_no")
if IsNull(ls_style_no) or Trim(ls_style_no) = "" then
   MessageBox(ls_title,"품번 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no")
   return false
end if

is_style = LeftA(ls_style_no, 8)    
is_chno  = MidA(ls_style_no,  9, 1) 
LS_FLAG = dw_head.GETITEMSTRING(1,"flag") 

IF LS_FLAG = 'Y' then 
	is_chno = '%'
END IF 

is_color = dw_head.GetItemString(1, "color")
if IsNull(is_color) or Trim(is_color) = "" then
   MessageBox(ls_title,"색상 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("color")
   return false
end if

is_size = dw_head.GetItemString(1, "size")
if IsNull(is_size) or Trim(is_size) = "" then
   MessageBox(ls_title,"사이즈를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("size")
   return false
end if


Return True 

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                 */	
/* 작성일      : 2002.04.28                                                  */	
/* 수정일      : 2002.04.28                                                  */
/*===========================================================================*/
decimal ldc_tag_price
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(gs_shop_cd, is_style, is_chno, is_color, is_size)
IF il_rows > 0 THEN
   dw_body.SetFocus()
	
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event open;call super::open;//if gs_brand <> "N" then
//	cb_house.enabled = false
//	cb_house.visible = false
//end if	

dw_body.Object.DataWindow.HorizontalScrollSplit  = 846
end event

type cb_close from w_com010_d`cb_close within w_sh113_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh113_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh113_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh113_d
end type

type cb_update from w_com010_d`cb_update within w_sh113_d
end type

type cb_print from w_com010_d`cb_print within w_sh113_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_sh113_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_sh113_d
long backcolor = 16777215
end type

type dw_head from w_com010_d`dw_head within w_sh113_d
integer width = 2770
integer height = 164
string dataobject = "d_sh113_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.04.29                                                  */	
/* 수정일      : 2002.04.29                                                  */
/*===========================================================================*/
long ll_b_cnt

CHOOSE CASE dwo.name
	CASE "style_no"	    
		IF ib_itemchanged THEN RETURN 1
		
			if MidA(gs_shop_cd_1,1,2) = 'XX' then
				If isnull(data) or Trim(data) = '' then
					messagebox('확인', '품번을 입력해주세요.')
					return 0
				end if 
				gs_brand = MidA(data,1,1)
				gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
			end if
			
			//gs_brand = mid(data,1,1)
			dw_head.setitem(1,'brand', gs_brand)
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

		
	CASE "brand"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			dw_head.accepttext()
			gs_brand = dw_head.getitemstring(1,'brand')

			select isnull(count(brand),0)
			into	:ll_b_cnt
			from tb_91100_m  with (nolock) 
			where shop_cd like '%' + substring(:gs_shop_cd_1,3,4)
					and brand = :gs_brand;	
					
			if ll_b_cnt = 0 then 
				messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
				dw_body.reset()
				return 0
			end if

			gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
			Trigger Event ue_retrieve()
			
END CHOOSE

end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;String ls_style, ls_chno, ls_color, ls_flag, ls_style_no

CHOOSE CASE dwo.name
	CASE "color"
		ls_style_no = This.GetitemString(row, "style_no")
		ls_style = MidA(ls_style_no,1,8)
		ls_chno  = MidA(ls_style_no,9,1)
	   ls_flag  = this.GETITEMSTRING(1,"flag") 
		
		IF ls_flag = 'Y' then ls_chno = '%' 
		
		idw_color.Retrieve(ls_style, ls_chno)
		idw_color.insertRow(1)
		idw_color.Setitem(1, "color", "%")
		idw_color.Setitem(1, "bb_color_enm", "전체")

	CASE "size"
		ls_style_no = This.GetitemString(row, "style_no")
		ls_style = MidA(ls_style_no,1,8)
		ls_chno  = MidA(ls_style_no,9,1)
	   ls_flag  = this.GETITEMSTRING(1,"flag") 
		  
		IF ls_flag = 'Y' then ls_chno = '%' 		  
		
		ls_color = This.GetitemString(row, "color")
		idw_size.Retrieve(ls_style, ls_chno, ls_color)
		idw_size.insertRow(1)
		idw_size.Setitem(1, "size", "%")
		idw_size.Setitem(1, "bb_size_nm", "전체")

END CHOOSE


end event

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.insertRow(1)
idw_color.Setitem(1, "color", "%")
idw_color.Setitem(1, "bb_color_enm", "전체")

This.GetChild("size", idw_size)
idw_size.SetTransObject(SQLCA)
idw_size.insertRow(1)
idw_size.Setitem(1, "size", "%")
idw_size.Setitem(1, "bb_size_nm", "전체")

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.object.brand_t.visible = true
	dw_head.object.brand.visible = true
else
	dw_head.object.brand_t.visible = false
	dw_head.object.brand.visible = false
end if


end event

event dw_head::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)                                           */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		return 1
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN  0
	   ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
	   IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
			   					String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_sh113_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_sh113_d
integer beginy = 360
integer endy = 360
end type

type dw_body from w_com010_d`dw_body within w_sh113_d
integer x = 5
integer y = 456
integer width = 2848
integer height = 1328
string dataobject = "d_sh113_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_sh113_d
integer x = 165
integer y = 872
end type

type cb_house from commandbutton within w_sh113_d
integer x = 37
integer y = 40
integer width = 347
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "물류재고"
end type

event clicked;IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_color = "%" or is_size = "%" then 
	messagebox ("경고", "색상, 사이즈를 정확히 입력해 주시기 바랍니다!")
//ELSEif is_CHNO = "%"  then 
//	messagebox ("경고", "물류재고는 차수를 입력하셔야 합니다!")	
else	
	dw_1.retrieve(is_style, is_chno, is_color, is_size)
	dw_1.visible = true
end if	

end event

type dw_1 from datawindow within w_sh113_d
boolean visible = false
integer x = 55
integer y = 744
integer width = 2272
integer height = 332
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "물류재고 여부"
string dataobject = "d_sh113_d02"
boolean controlmenu = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;dw_1.visible = false
end event

type st_1 from statictext within w_sh113_d
integer x = 82
integer y = 380
integer width = 297
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "소비자가:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_sh113_d
integer x = 402
integer y = 392
integer width = 457
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
boolean focusrectangle = false
end type

type t_tag from editmask within w_sh113_d
integer x = 393
integer y = 376
integer width = 457
integer height = 68
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711935
long backcolor = 16777215
string text = "none"
boolean border = false
boolean displayonly = true
string mask = "###,###"
end type

type rb_1 from radiobutton within w_sh113_d
integer x = 1253
integer y = 380
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "판매율포함"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then
	dw_body.dataobject="d_sh113_d01"
else
	dw_body.dataobject="d_sh113_d03"
end if
dw_body.SetTransObject(SQLCA)
end event

type rb_2 from radiobutton within w_sh113_d
integer x = 1705
integer y = 380
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "판매율제외"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then
	dw_body.dataobject="d_sh113_d03"
else
	dw_body.dataobject="d_sh113_d01"
end if
dw_body.SetTransObject(SQLCA)
end event

