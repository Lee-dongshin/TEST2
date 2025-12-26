$PBExportHeader$w_47010_d.srw
$PBExportComments$직택진행 조회
forward
global type w_47010_d from w_com010_d
end type
type dw_1 from datawindow within w_47010_d
end type
type rb_sum from radiobutton within w_47010_d
end type
type rb_detail from radiobutton within w_47010_d
end type
type rb_shop from radiobutton within w_47010_d
end type
end forward

global type w_47010_d from w_com010_d
integer width = 3689
integer height = 2280
dw_1 dw_1
rb_sum rb_sum
rb_detail rb_detail
rb_shop rb_shop
end type
global w_47010_d w_47010_d

type variables
DataWindowChild idw_brand
String is_brand, is_fr_ymd, is_to_ymd, is_fr_shop_cd, is_to_shop_cd, is_style, is_proc_yn, is_rt_accept, is_opt
end variables

on w_47010_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rb_sum=create rb_sum
this.rb_detail=create rb_detail
this.rb_shop=create rb_shop
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rb_sum
this.Control[iCurrent+3]=this.rb_detail
this.Control[iCurrent+4]=this.rb_shop
end on

on w_47010_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rb_sum)
destroy(this.rb_detail)
destroy(this.rb_shop)
end on

event open;call super::open;//DataWindowChild idw_brand
//string is_brand, is_fr_ymd, is_to_ymd, is_stylem, is_fr_shop_cd, is_to_shoP_cd
//

is_opt = "N"
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
string     ls_part_cd, ls_part_nm, ls_shop_nm, ls_where
DataStore  lds_Source
Boolean    lb_check 


is_brand = dw_head.GetItemString(1, "brand")

CHOOSE CASE as_column
		CASE "fr_shop_cd"	
			IF ai_div = 1 THEN
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_head.SetItem(al_row, "shop_nm", "")
					Return 0
				End If

				If gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
					dw_head.SetItem(al_row, "fr_shop_nm", ls_shop_nm)
					RETURN 0
				END IF 

				
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' and shop_cd like '[NJ]%' "
			ELSE
				gst_cd.Item_where = "  shop_cd like '[NJ]%' "
			END IF


			ls_where = " AND BRAND not like  '[OD]%' "


			gst_cd.default_where = gst_cd.default_where + ls_where
			
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "fr_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "fr_shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("to_shop_cd")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
				
		CASE "to_shop_cd"	
			IF ai_div = 1 THEN
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_head.SetItem(al_row, "shop_nm", "")
					Return 0
				End If

				If gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
					dw_head.SetItem(al_row, "to_shop_nm", ls_shop_nm)
					RETURN 0
				END IF 

				
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' "
			ELSE
				gst_cd.Item_where = "  shop_cd like '[NJ]%' "
			END IF

			ls_where = " AND BRAND not like  '[OD]%' and shop_cd like '_[DE]%' "


			gst_cd.default_where = gst_cd.default_where + ls_where
			
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "to_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "to_shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
			
			

			CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				// 스타일 선별작업
				

				is_brand = dw_head.GetItemString(1, "brand")
				IF  gl_user_level = 0 then 
					gst_cd.default_where   = "WHERE   style like '" + is_brand + "%' and style not like '[OD]%' "	
				else 	
					gst_cd.default_where   = " WHERE  tag_price <> 0 "
				end if
				

				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
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
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))								
 
			
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("fr_shop_cd")
					ib_itemchanged = False
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

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN




//if is_opt <> "Y" then
//	il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_style, is_fr_shop_cd, is_to_shop_cd, is_proc_yn)
//else 	
	il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_style, is_fr_shop_cd, is_to_shop_cd, is_proc_yn, is_rt_accept)
//end if


IF il_rows > 0 THEN
   dw_body.SetFocus()
//	if is_proc_yn = 'Y' then
//		dw_body.modify("Group1.Height = 0 ")
//	else
//		dw_body.modify("Group1.Height = 76 ")		
//	end if	
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

//if is_brand = "O" or is_brand = "D" then
// MessageBox(ls_title,"해당 브랜드는 조회 하실 수 없습니다!")
//// return false
//end if

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
	is_style = "%"
end if

is_fr_shop_cd = dw_head.GetItemString(1, "fr_shop_cd")
if IsNull(is_fr_shop_cd) or Trim(is_fr_shop_cd) = "" then
 is_fr_shop_cd = "%"
end if

is_to_shop_cd = dw_head.GetItemString(1, "to_shop_cd")
if IsNull(is_to_shop_cd) or Trim(is_to_shop_cd) = "" then
 is_to_shop_cd = "%"
end if

is_proc_yn = dw_head.GetItemString(1, "proc_yn")
if IsNull(is_proc_yn) or Trim(is_proc_yn) = "" then
 is_proc_yn = "%"
end if

is_rt_accept = dw_head.GetItemString(1, "rt_accept")
if IsNull(is_rt_accept) or Trim(is_rt_accept) = "" then
 is_rt_accept = "%"
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

return true

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_47010_d","0")
end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_rt_gubn 

if is_proc_yn = 'Y' then
	ls_rt_gubn = "발 송"
elseif is_proc_yn = 'N' then
	ls_rt_gubn = "미 발 송"	
else
	ls_rt_gubn = "전 체"	
end if	
	
IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")



ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "' " + &				
				"t_fr_ymd.Text = '" + is_fr_ymd + "' "   + &
				"t_to_ymd.Text = '" + is_to_ymd + "' "    + & 
				"t_proc_yn.Text = '" + ls_rt_gubn + "' "    				
				

dw_print.Modify(ls_modify)


end event

event pfc_preopen();call super::pfc_preopen;//inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")

dw_1.SetTransObject(SQLCA)

end event

type cb_close from w_com010_d`cb_close within w_47010_d
end type

type cb_delete from w_com010_d`cb_delete within w_47010_d
end type

type cb_insert from w_com010_d`cb_insert within w_47010_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_47010_d
end type

type cb_update from w_com010_d`cb_update within w_47010_d
end type

type cb_print from w_com010_d`cb_print within w_47010_d
end type

type cb_preview from w_com010_d`cb_preview within w_47010_d
end type

type gb_button from w_com010_d`gb_button within w_47010_d
integer height = 188
end type

type cb_excel from w_com010_d`cb_excel within w_47010_d
end type

type dw_head from w_com010_d`dw_head within w_47010_d
integer height = 316
string dataobject = "d_47010_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

idw_brand.insertrow(1)
idw_brand.Setitem(1, "inter_cd", "%")
idw_brand.Setitem(1, "inter_nm", "전체")
end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name

   CASE "fr_shop_cd"	,"to_shop_cd"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)


END CHOOSE


end event

type ln_1 from w_com010_d`ln_1 within w_47010_d
integer beginy = 496
integer endy = 496
end type

type ln_2 from w_com010_d`ln_2 within w_47010_d
integer beginy = 500
integer endy = 500
end type

type dw_body from w_com010_d`dw_body within w_47010_d
integer x = 9
integer y = 512
integer height = 1536
string dataobject = "d_47010_d05"
end type

event dw_body::doubleclicked;call super::doubleclicked;String 	ls_style, ls_chno, ls_color, ls_size
long ll_row
if row > 0 then 
	
	ls_style 	= this.GetItemString(row,'style')
	ls_chno 		= this.GetItemString(row,'chno')
	ls_color 	= this.GetItemString(row,'color')
	ls_size 		= this.GetItemString(row,'size')	
	
	ll_row = dw_1.retrieve(ls_style, ls_chno, ls_color, ls_size)
	
	if ll_row > 0 then 
		dw_1.visible = true
	else 	
		dw_1.visible = false
	end if
	
	
	
end if
end event

type dw_print from w_com010_d`dw_print within w_47010_d
string dataobject = "d_47010_r05"
end type

type dw_1 from datawindow within w_47010_d
boolean visible = false
integer x = 1970
integer y = 620
integer width = 1755
integer height = 1392
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "상세조회"
string dataobject = "d_47010_d03"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;dw_1.visible = false 
end event

type rb_sum from radiobutton within w_47010_d
boolean visible = false
integer x = 777
integer y = 48
integer width = 608
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "직택 발송집계"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_sum.TextColor       = RGB(0, 0, 255)
rb_shop.TextColor       = 0
rb_detail.TextColor     = 0
is_opt = "N"

dw_head.object.proc_yn.visible = false
dw_head.object.t_proc_yn.visible = false
dw_head.object.t_rt_accept.visible = false
dw_head.object.rt_accept.visible = false
dw_body.DataObject  = 'd_47010_d04'
dw_body.SetTransObject(SQLCA)

dw_print.DataObject  = 'd_47010_r04'
dw_print.SetTransObject(SQLCA)


end event

type rb_detail from radiobutton within w_47010_d
boolean visible = false
integer x = 777
integer y = 112
integer width = 599
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "진행내역 상세"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_sum.TextColor       = 0
rb_shop.TextColor       = 0
rb_detail.TextColor     =  RGB(0, 0, 255) 
is_opt = "N"
dw_head.object.proc_yn.visible = true
dw_head.object.t_proc_yn.visible = true
dw_head.object.t_rt_accept.visible = false
dw_head.object.rt_accept.visible = false
dw_body.DataObject  = 'd_47010_d02'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject  = 'd_47010_r02'
dw_print.SetTransObject(SQLCA)

end event

type rb_shop from radiobutton within w_47010_d
integer x = 32
integer y = 40
integer width = 841
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "진행 보기"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_sum.TextColor       = 0
rb_shop.TextColor       =  RGB(0, 0, 255) 
rb_detail.TextColor     = 0
is_opt = "Y"
dw_head.object.proc_yn.visible = true
dw_head.object.t_proc_yn.visible = true
dw_head.object.t_rt_accept.visible = true
dw_head.object.rt_accept.visible = true
dw_body.DataObject  = 'd_47010_d05'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject  = 'd_47010_r05'
dw_print.SetTransObject(SQLCA)

end event

