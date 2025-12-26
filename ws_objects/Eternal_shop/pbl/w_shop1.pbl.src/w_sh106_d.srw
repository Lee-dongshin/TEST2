$PBExportHeader$w_sh106_d.srw
$PBExportComments$판매현황조회2
forward
global type w_sh106_d from w_com010_d
end type
type rb_a from radiobutton within w_sh106_d
end type
type rb_b from radiobutton within w_sh106_d
end type
type rb_c from radiobutton within w_sh106_d
end type
type rb_d from radiobutton within w_sh106_d
end type
type rb_e from radiobutton within w_sh106_d
end type
end forward

global type w_sh106_d from w_com010_d
integer width = 2990
long backcolor = 16777215
rb_a rb_a
rb_b rb_b
rb_c rb_c
rb_d rb_d
rb_e rb_e
end type
global w_sh106_d w_sh106_d

type variables
DataWindowChild	idw_shop_type
String is_fr_ymd, is_to_ymd, is_shop_cd, is_shop_nm, is_shop_type, is_opt_view
end variables

on w_sh106_d.create
int iCurrent
call super::create
this.rb_a=create rb_a
this.rb_b=create rb_b
this.rb_c=create rb_c
this.rb_d=create rb_d
this.rb_e=create rb_e
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_a
this.Control[iCurrent+2]=this.rb_b
this.Control[iCurrent+3]=this.rb_c
this.Control[iCurrent+4]=this.rb_d
this.Control[iCurrent+5]=this.rb_e
end on

on w_sh106_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_a)
destroy(this.rb_b)
destroy(this.rb_c)
destroy(this.rb_d)
destroy(this.rb_e)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;string   ls_title
integer li_date_diff

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

//if gs_brand = "N" then 
//   MessageBox(ls_title,"현재 온앤온 매장은 사용이 불가능 합니다!")
//	return false
//end if	
//

//is_opt_view = dw_head.GetItemString(1, "opt_view")

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_shop_nm = dw_head.GetItemString(1, "shop_nm")

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

if LeftA(is_shop_cd,1) <> gs_brand  then
	MessageBox(ls_title,"동일 브랜드 매장만 조회 가능합니다.")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
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
else
	if is_shop_cd <> gs_shop_cd and gs_brand = "N" then
		MessageBox(ls_title,"타매장는 조회 불가능합니다.")
		dw_head.SetFocus()
		dw_head.SetColumn("shop_cd")
		return false
	end if	
end if

select datediff(day, :is_fr_ymd, :is_to_ymd)
into :li_date_diff
from dual;



if is_fr_ymd > is_to_ymd then
	MessageBox(ls_title,"마지막일자가 시작일자보다 작습니다.")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

if li_date_diff > 93 then
	MessageBox(ls_title," 3개월 미만의 기간만 조회 가능합니다.")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if




return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = MidA(as_data,1,1)
end if

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
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
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' and brand = '" + gs_brand + "' "
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

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

/*
if is_opt_view = "A" then 
	dw_body.DataObject = "d_sh106_d01"
	dw_print.DataObject = "d_sh106_r01"	
elseif is_opt_view = "B" then 
	dw_body.DataObject = "d_sh106_d02"	
	dw_print.DataObject = "d_sh106_r02"		
elseif is_opt_view = "C" then 
	dw_body.DataObject = "d_sh106_d03"	
//	dw_print.DataObject = "d_sh106_r03"		
elseif is_opt_view = "D" then 
	dw_body.DataObject = "d_sh106_d04"	
//	dw_print.DataObject = "d_sh106_r04"		
else
	dw_body.DataObject = "d_sh106_d05"		
//	dw_print.DataObject = "d_sh106_r05"		
end if	

dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
*/
//'n','20080101','20080415','ng1082','1'

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	is_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(gs_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_shop_type)
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

/*
if gs_brand = 'N' then
	dw_head.object.shop_cd.enabled = false
//	dw_head.object.shop_cd.background = rgb
else
	dw_head.object.shop_cd.enabled = true
end if
*/
end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


ls_modify =	"t_shop_cd.Text = '" + is_shop_cd + "'" + &
             "t_shop_nm.Text = '" + is_shop_nm + "'" + &
             "t_fr_ymd.Text = '" + is_fr_ymd + "'" + &
             "t_to_ymd.Text = '" + is_to_ymd + "'" 

		
dw_print.Modify(ls_modify)
end event

event open;call super::open;string ls_modify


dw_head.setitem(1, "brand", upper(MidA(gs_shop_cd,1,1)))
if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.setitem(1, "brand", 'N')
end if

if MidA(gs_shop_cd,3,4) <> '2000' then 
	if MidA(gs_shop_cd_1,1,2) <> 'XX' then
		ls_modify =	'brand.protect = 1'
		dw_head.Modify(ls_modify)
	end if
end if

end event

type cb_close from w_com010_d`cb_close within w_sh106_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh106_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh106_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh106_d
end type

type cb_update from w_com010_d`cb_update within w_sh106_d
end type

type cb_print from w_com010_d`cb_print within w_sh106_d
end type

type cb_preview from w_com010_d`cb_preview within w_sh106_d
end type

type gb_button from w_com010_d`gb_button within w_sh106_d
long backcolor = 16777215
end type

type dw_head from w_com010_d`dw_head within w_sh106_d
integer x = 841
integer y = 152
integer width = 2153
integer height = 216
string dataobject = "d_sh106_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')

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



String   ls_filter_str = ''	

ls_filter_str = "inter_cd <> '9' " 
idw_shop_type.SetFilter(ls_filter_str)
idw_shop_type.Filter( )


end event

event dw_head::itemchanged;call super::itemchanged;long ll_b_cnt

CHOOSE CASE dwo.name
	CASE "shop_cd"      // dddw로 작성된 항목
		IF ib_itemchanged THEN RETURN 1
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
/*
	CASE "opt_view"
			dw_head.accepttext()			
			is_opt_view = dw_head.GetItemString(1, "opt_view")

			Trigger Event ue_retrieve()
*/
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_sh106_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_d`ln_2 within w_sh106_d
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_d`dw_body within w_sh106_d
integer y = 396
integer width = 2898
integer height = 1380
string dataobject = "d_sh106_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_sh106_d
string dataobject = "d_sh106_r01"
end type

type rb_a from radiobutton within w_sh106_d
integer x = 27
integer y = 180
integer width = 366
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 16777215
string text = "일자별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;is_opt_view = 'A'

dw_body.DataObject = "d_sh106_d01"
dw_print.DataObject = "d_sh106_r01"	

dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

trigger event ue_retrieve()
end event

type rb_b from radiobutton within w_sh106_d
integer x = 27
integer y = 248
integer width = 366
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 16777215
string text = "월별"
borderstyle borderstyle = stylelowered!
end type

event clicked;is_opt_view = 'B'

dw_body.DataObject = "d_sh106_d02"	
dw_print.DataObject = "d_sh106_r02"		

dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

trigger event ue_retrieve()
end event

type rb_c from radiobutton within w_sh106_d
integer x = 27
integer y = 316
integer width = 366
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 16777215
string text = "품번별"
borderstyle borderstyle = stylelowered!
end type

event clicked;is_opt_view = 'C'

dw_body.DataObject = "d_sh106_d03"	
//	dw_print.DataObject = "d_sh106_r03"		

dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

trigger event ue_retrieve()
end event

type rb_d from radiobutton within w_sh106_d
integer x = 379
integer y = 180
integer width = 425
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 16777215
string text = "품번/색상별"
borderstyle borderstyle = stylelowered!
end type

event clicked;is_opt_view = 'D'

dw_body.DataObject = "d_sh106_d04"	
//	dw_print.DataObject = "d_sh106_r04"		

dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

trigger event ue_retrieve()
end event

type rb_e from radiobutton within w_sh106_d
integer x = 379
integer y = 248
integer width = 571
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 16777215
string text = "(코드)품번/색상"
borderstyle borderstyle = stylelowered!
end type

event clicked;is_opt_view = 'E'

dw_body.DataObject = "d_sh106_d05"		
//	dw_print.DataObject = "d_sh106_r05"		

dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

trigger event ue_retrieve()
end event

