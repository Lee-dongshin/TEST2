$PBExportHeader$w_71003_d.srw
$PBExportComments$일별/매장별 구매조회
forward
global type w_71003_d from w_com010_d
end type
type rb_1 from radiobutton within w_71003_d
end type
type rb_2 from radiobutton within w_71003_d
end type
type dw_member from datawindow within w_71003_d
end type
type gb_1 from groupbox within w_71003_d
end type
end forward

global type w_71003_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
dw_member dw_member
gb_1 gb_1
end type
global w_71003_d w_71003_d

type variables
String 	is_brand,is_shop_cd,is_area, id_reg_from, id_reg_to, is_vip, is_rfm
DataWindowChild idw_brand,idw_area, idw_sale_type

end variables

on w_71003_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_member=create dw_member
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.dw_member
this.Control[iCurrent+4]=this.gb_1
end on

on w_71003_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_member)
destroy(this.gb_1)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "reg_from", ld_datetime)
dw_head.SetItem(1, "reg_to", ld_datetime)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"							// 매장 코드
		is_area = dw_head.GetItemString(1, "area")
		is_brand = dw_head.GetItemString(1, "brand")
		If IsNull(is_brand) or Trim(is_brand) = "" Then 
			is_brand = ""
		END IF
		If IsNull(is_area) or Trim(is_area) = "" Then 
			is_area = ""
		END IF
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF LeftA(as_data, 1) <> is_brand Then
					MessageBox("입력오류","해당 브랜드의 매장코드가 아닙니다!")
					RETURN 1
				ELSEIF gf_shop_nm(as_data, 'S', ls_part_nm) <> 0 THEN
					MessageBox("입력오류","등록되지 않은 매장코드입니다!")
					RETURN 1
				END IF
				dw_head.SetItem(al_row, "shop_nm", ls_part_nm)
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "매장 코드 검색" 
				gst_cd.datawindow_nm   = "d_com912" 
				gst_cd.default_where   = " WHERE SHOP_CD LIKE '" + is_brand + "%' AND AREA_CD LIKE '"+is_area+"%'"
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " SHOP_CD LIKE '" + as_data + "%' "
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
					dw_head.SetColumn("sale_dt")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
			END IF

END CHOOSE

RETURN 0

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title
string	ls_temp_dt
date		ld_Date
time		lt_Time

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

id_reg_from = String(dw_head.GetItemDateTime(1,"reg_from"), 'yyyymmdd')
if IsNull(id_reg_from) Or Trim(id_reg_from) = "" then
   MessageBox(ls_title,"From일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("id_reg_from")
	return false
end if

id_reg_to = String(dw_head.GetItemDateTime(1,"reg_to"), 'yyyymmdd')
if IsNull(id_reg_to) Or Trim(id_reg_to) = "" then
   MessageBox(ls_title,"To일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("reg_to")
	return false
end if

if id_reg_from > id_reg_to  then
	MessageBox(ls_title, "마지막 일자가 처음 일자보다 작습니다!")
   dw_head.SetFocus()
	dw_head.SetColumn("reg_to")
	return false
end if

is_brand = dw_head.GetItemString(1, "brand")
is_area 	= dw_head.GetItemString(1, "area")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")
is_vip = dw_head.GetItemString(1, "vip")
is_rfm = dw_head.GetItemString(1, "rfm")

return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(id_reg_from,id_reg_to,is_area,is_brand, is_shop_cd, is_vip, is_rfm)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_vip, ls_rfm
string ls_shop_nm 

ls_shop_nm = dw_head.GetItemString(1,'shop_nm')

IF ls_shop_nm = "" OR isnull(ls_shop_nm) THEN
	ls_shop_nm = "전체"
END IF

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


if is_vip = '2' then
	ls_vip = 'VIP 회원'
else 
	ls_vip = '전체회원'
end if

choose case is_rfm
	case "A"
		ls_rfm = "최우수 고정고객"
	case "B"
		ls_rfm = "우수 고정고객"
	case "C"
		ls_rfm = "일반 고정고객"
	case "D"
		ls_rfm = "우수 유동고객"
	case "E"
		ls_rfm = "일반 유동고객"
	case "F"
		ls_rfm = "일반 휴면고객"
	case else 
		ls_rfm = "일반 휴면고객"
end choose


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
				"t_area.Text = '" + idw_area.GetItemString(idw_area.GetRow(), "inter_display") + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_shop_nm.Text = '" + ls_shop_nm + "'" + &
				"t_vip.Text = '" + ls_vip + "'" + &
				"t_rfm.Text = '" + ls_rfm + "'"

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_71003_d","0")
end event

event pfc_preopen();call super::pfc_preopen;dw_member.SetTransobject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_71003_d
end type

type cb_delete from w_com010_d`cb_delete within w_71003_d
end type

type cb_insert from w_com010_d`cb_insert within w_71003_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_71003_d
end type

type cb_update from w_com010_d`cb_update within w_71003_d
end type

type cb_print from w_com010_d`cb_print within w_71003_d
end type

type cb_preview from w_com010_d`cb_preview within w_71003_d
end type

type gb_button from w_com010_d`gb_button within w_71003_d
end type

type cb_excel from w_com010_d`cb_excel within w_71003_d
end type

type dw_head from w_com010_d`dw_head within w_71003_d
integer x = 526
integer y = 180
integer width = 3072
string dataobject = "d_71003_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.01.18                                                  */
/*===========================================================================*/
This.GetChild("area", idw_area)
idw_area.SetTRansObject(SQLCA)
idw_area.Retrieve('090')

idw_area.InsertRow(1)
idw_area.SetItem(1,'inter_cd','')
idw_area.SetItem(1,'inter_nm','전체')

This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

idw_brand.InsertRow(1)
idw_brand.SetItem(1,'inter_cd','')
idw_brand.SetItem(1,'inter_nm','전체')


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "area"
		This.SetItem(1, "brand", "")
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
	CASE "brand"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_71003_d
end type

type ln_2 from w_com010_d`ln_2 within w_71003_d
end type

type dw_body from w_com010_d`dw_body within w_71003_d
string dataobject = "d_71003_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(true)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(false)

//This.SetRowFocusIndicator(Hand!)

end event

event dw_body::doubleclicked;call super::doubleclicked;string 	ls_jumin
long		ll_rows

ls_jumin = this.getitemstring(row,"jumin")

dw_member.Reset()

ll_rows = dw_member.retrieve(ls_jumin)

if  ll_rows > 0 then
	dw_member.visible = true
end if 
end event

type dw_print from w_com010_d`dw_print within w_71003_d
integer x = 1001
integer y = 756
integer width = 1435
integer height = 724
string dataobject = "d_71003_r02"
end type

type rb_1 from radiobutton within w_71003_d
event ue_keydown ( )
integer x = 119
integer y = 252
integer width = 325
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
string text = "매장별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.textcolor = Rgb(0, 0, 255) 
rb_2.textcolor = Rgb(0, 0, 0)

dw_body.dataobject = "d_71003_d01"
dw_body.Settransobject(sqlca)

dw_print.dataobject = "d_71003_r01"
dw_print.Settransobject(sqlca)

 cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

end event

type rb_2 from radiobutton within w_71003_d
integer x = 119
integer y = 332
integer width = 325
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
string text = "일자별"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.textcolor = Rgb(0, 0, 255) 
rb_1.textcolor = Rgb(0, 0, 0)

dw_body.dataobject = "d_71003_d02"
dw_body.Settransobject(sqlca)

dw_print.dataobject = "d_71003_r02"
dw_print.Settransobject(sqlca)

 cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
end event

type dw_member from datawindow within w_71003_d
boolean visible = false
integer x = 5
integer y = 300
integer width = 4500
integer height = 2000
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "회원정보"
string dataobject = "d_member_info"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;this.getchild("area",idw_area)
idw_area.SetTransObject(SQLCA)
idw_area.retrieve("090")

this.getchild("sale_type",idw_sale_type)
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.retrieve("011")
end event

event doubleclicked;this.visible = false
end event

type gb_1 from groupbox within w_71003_d
integer x = 55
integer y = 188
integer width = 434
integer height = 228
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

