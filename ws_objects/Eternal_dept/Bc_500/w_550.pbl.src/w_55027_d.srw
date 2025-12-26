$PBExportHeader$w_55027_d.srw
$PBExportComments$인기 STYLE 판매 현황(담당매장별)
forward
global type w_55027_d from w_com010_d
end type
type rb_m from radiobutton within w_55027_d
end type
type rb_mc from radiobutton within w_55027_d
end type
type rb_mcs from radiobutton within w_55027_d
end type
type p_1 from picture within w_55027_d
end type
type st_1 from statictext within w_55027_d
end type
type st_2 from statictext within w_55027_d
end type
type rb_m2 from radiobutton within w_55027_d
end type
type rb_mc2 from radiobutton within w_55027_d
end type
type rb_mcs2 from radiobutton within w_55027_d
end type
type gb_1 from groupbox within w_55027_d
end type
end forward

global type w_55027_d from w_com010_d
integer width = 3675
integer height = 2276
rb_m rb_m
rb_mc rb_mc
rb_mcs rb_mcs
p_1 p_1
st_1 st_1
st_2 st_2
rb_m2 rb_m2
rb_mc2 rb_mc2
rb_mcs2 rb_mcs2
gb_1 gb_1
end type
global w_55027_d w_55027_d

type variables
DataWindowChild idw_brand, idw_season, idw_sojae, idw_item, idw_shop_div, idw_empno

String is_brand, is_year, is_season, is_fr_yymmdd, is_to_yymmdd, is_sojae
String is_item, is_shop_div, is_fr_shop_cd, is_to_shop_cd, is_shop_type, is_sort_fg
String is_flag = '1', is_empno, is_shop_cd

Decimal idc_ranking

end variables

on w_55027_d.create
int iCurrent
call super::create
this.rb_m=create rb_m
this.rb_mc=create rb_mc
this.rb_mcs=create rb_mcs
this.p_1=create p_1
this.st_1=create st_1
this.st_2=create st_2
this.rb_m2=create rb_m2
this.rb_mc2=create rb_mc2
this.rb_mcs2=create rb_mcs2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_m
this.Control[iCurrent+2]=this.rb_mc
this.Control[iCurrent+3]=this.rb_mcs
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.rb_m2
this.Control[iCurrent+8]=this.rb_mc2
this.Control[iCurrent+9]=this.rb_mcs2
this.Control[iCurrent+10]=this.gb_1
end on

on w_55027_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_m)
destroy(this.rb_mc)
destroy(this.rb_mcs)
destroy(this.p_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.rb_m2)
destroy(this.rb_mc2)
destroy(this.rb_mcs2)
destroy(this.gb_1)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "fr_yymmdd", ld_datetime)
dw_head.SetItem(1, "to_yymmdd", ld_datetime)

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.22                                                  */	
/* 수정일      : 2002.01.22                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd,  is_year, is_season, is_sojae, &
									is_item,  is_shop_cd, is_empno, is_shop_type,  idc_ranking)

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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
String   ls_title

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

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_fr_yymmdd = String(dw_head.GetItemDatetime(1, "fr_yymmdd"), 'yyyymmdd')
if IsNull(is_fr_yymmdd) or Trim(is_fr_yymmdd) = "" then
   MessageBox(ls_title,"기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymmdd")
   return false
end if

is_to_yymmdd = String(dw_head.GetItemDatetime(1, "to_yymmdd"), 'yyyymmdd')
if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
   MessageBox(ls_title,"기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if

if is_to_yymmdd < is_fr_yymmdd then
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재 유형을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"복종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if


is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = "%"
end if

is_empno = dw_head.GetItemString(1, "empno")
if IsNull(is_empno) or Trim(is_empno) = "" then
	is_empno = "%"
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if


idc_ranking = dw_head.GetItemDecimal(1, "ranking")
if IsNull(idc_ranking) or idc_ranking = 0 then
   MessageBox(ls_title,"판매 순위를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("ranking")
   return false
end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_shop_div
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		ls_brand    = Trim(dw_head.GetItemString(1, "brand"))
		ls_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				If LeftA(as_data, 1) <> ls_brand Then
					MessageBox("입력오류", "브랜드가 다릅니다!")
					dw_head.SetItem(al_row, "shop_cd", "")
					dw_head.SetItem(al_row, "shop_nm", "")
					Return 1
				End If
				If ls_shop_div <> '%' Then
					If MidA(as_data, 2, 1) <> ls_shop_div Then
						MessageBox("입력오류", "유통망이 다릅니다!")
						dw_head.SetItem(al_row, "shop_cd", "")
						dw_head.SetItem(al_row, "shop_nm", "")
						Return 1
					End If
				End If
					
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "' " + &
			                         "  AND SHOP_DIV LIKE '" + ls_shop_div + "' " + &
											 "  AND SHOP_STAT = '00' "
											 
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
				dw_head.SetColumn("empno")
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

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.22                                                  */	
/* 수정일      : 2002.01.22                                                  */
/*===========================================================================*/
Datetime ld_datetime
String ls_modify, ls_datetime, ls_shop_type, ls_fr_shop_nm, ls_to_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_shop_type = '1' Then
	ls_shop_type = '정  상'
Else
	ls_shop_type = '정상 + 기획'
End IF

If is_shop_cd = '%' Then
	ls_fr_shop_nm = ' '
Else
	ls_fr_shop_nm = dw_head.GetItemString(1, "shop_nm")
End If


ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_year.Text = '" + is_year + "'" + &
            "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_fr_yymmdd.Text = '" + String(is_fr_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_to_yymmdd.Text = '" + String(is_to_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_sojae.Text = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_display") + "'" + &
            "t_item.Text = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'" + &
            "t_shop_cd.Text = '" + is_shop_cd + " " + ls_fr_shop_nm + "'" + &
            "t_shop_type.Text = '" + ls_shop_type + "'" + &
            "t_ranking.Text = '" + String(idc_ranking) + "위 까지'"

dw_print.Modify(ls_modify)


end event

event ue_button;/*===========================================================================*/
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
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         rb_m.Enabled    = false
         rb_mc.Enabled   = false
         rb_mcs.Enabled  = false
         rb_m2.Enabled   = false
         rb_mc2.Enabled  = false
         rb_mcs2.Enabled = false
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
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
		rb_m.Enabled    = true
		rb_mc.Enabled   = true
		rb_mcs.Enabled  = true
		rb_m2.Enabled   = true
		rb_mc2.Enabled  = true
		rb_mcs2.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55027_d","0")
end event

type cb_close from w_com010_d`cb_close within w_55027_d
end type

type cb_delete from w_com010_d`cb_delete within w_55027_d
end type

type cb_insert from w_com010_d`cb_insert within w_55027_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55027_d
end type

type cb_update from w_com010_d`cb_update within w_55027_d
end type

type cb_print from w_com010_d`cb_print within w_55027_d
end type

type cb_preview from w_com010_d`cb_preview within w_55027_d
end type

type gb_button from w_com010_d`gb_button within w_55027_d
end type

type cb_excel from w_com010_d`cb_excel within w_55027_d
end type

type dw_head from w_com010_d`dw_head within w_55027_d
integer x = 736
integer width = 2715
integer height = 416
string dataobject = "d_55027_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "INTER_CD", '%')
idw_season.SetItem(1, "INTER_nm", '전체')


This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

This.GetChild("empno", idw_empno)
idw_empno.SetTransObject(SQLCA)
idw_empno.Retrieve(gs_brand)
idw_empno.InsertRow(0)

end event

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/

String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	
		
	CASE "brand"
		If LeftA(dw_head.GetItemString(1, "shop_cd"), 1) <> data Then
			dw_head.SetItem(1, "shop_cd", "")
			dw_head.SetItem(1, "shop_nm", "")
		End If
		
 	   IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"empno","")
		This.GetChild("empno", idw_empno)
		idw_empno.SetTransObject(SQLCA)
		idw_empno.Retrieve(data)
		idw_empno.InsertRow(0)
		
		THIS.GetChild("sojae", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('%', data)
		ldw_child.InsertRow(1)
		ldw_child.SetItem(1, "sojae", '%')
		ldw_child.SetItem(1, "sojae_nm", '전체')
		
		THIS.GetChild("item", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve( data )
		ldw_child.InsertRow(1)
		ldw_child.SetItem(1, "item", '%')
		ldw_child.SetItem(1, "item_nm", '전체')
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		

	CASE "shop_div"
		If data <> '%' Then
			If MidA(dw_head.GetItemString(1, "fr_shop_cd"), 2, 1) <> data Then
				dw_head.SetItem(1, "fr_shop_cd", "")
				dw_head.SetItem(1, "fr_shop_nm", "")
			End If
			If MidA(dw_head.GetItemString(1, "to_shop_cd"), 2, 1) <> data Then
				dw_head.SetItem(1, "to_shop_cd", "")
				dw_head.SetItem(1, "to_shop_nm", "")
			End If
		End IF
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
				
	CASE "year"
	

		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
				
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_55027_d
integer beginy = 616
integer endy = 616
end type

type ln_2 from w_com010_d`ln_2 within w_55027_d
integer beginy = 620
integer endy = 620
end type

type dw_body from w_com010_d`dw_body within w_55027_d
integer y = 636
integer height = 1404
string dataobject = "d_55027_d01"
end type

event dw_body::doubleclicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String ls_style, ls_color, ls_size

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_style = This.GetItemString(row, 'style') /* DataWindow에 Key 항목을 가져온다 */
Choose Case is_flag
	Case '1', '4'
		ls_color = '%'
		ls_size  = '%'
	Case '2', '5'
		ls_color = This.GetItemString(row, 'color')
		ls_size  = '%'
	Case '3', '6'
		ls_color = This.GetItemString(row, 'color')
		ls_size  = This.GetItemString(row, 'size')
End Choose

IF IsNull(ls_style) or IsNull(ls_color) or IsNull(ls_size) THEN return

gsv_cd.gs_cd1  = is_brand
gsv_cd.gs_cd2  = is_fr_yymmdd
gsv_cd.gs_cd3  = is_to_yymmdd
gsv_cd.gs_cd4  = ls_style
gsv_cd.gs_cd5  = ls_color
gsv_cd.gs_cd6  = ls_size
gsv_cd.gs_cd7  = is_shop_div
gsv_cd.gs_cd8  = is_fr_shop_cd
gsv_cd.gs_cd9  = is_to_shop_cd
gsv_cd.gs_cd10 = is_shop_type

Open(w_55002_s)

end event

event dw_body::clicked;call super::clicked;//string ls_style
//choose case dwo.name
//	case "style"
//		ls_style = this.getitemstring(row, "style")
//		gf_style_pic(ls_style,'%')
//end choose
end event

type dw_print from w_com010_d`dw_print within w_55027_d
string dataobject = "d_55027_r01"
end type

type rb_m from radiobutton within w_55027_d
integer x = 37
integer y = 316
integer width = 302
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
string text = "STYLE NO"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor    = RGB(0, 0, 255)
rb_mc.TextColor   = RGB(0, 0, 0)
rb_mcs.TextColor  = RGB(0, 0, 0)
rb_m2.TextColor   = RGB(0, 0, 0)
rb_mc2.TextColor  = RGB(0, 0, 0)
rb_mcs2.TextColor = RGB(0, 0, 0)

dw_body.DataObject = 'd_55027_d01'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55027_r01'
dw_print.SetTransObject(SQLCA)

is_flag = '1'

end event

type rb_mc from radiobutton within w_55027_d
integer x = 37
integer y = 404
integer width = 270
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
string text = "COLOR"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_m.TextColor    = RGB(0, 0, 0)
This.TextColor    = RGB(0, 0, 255)
rb_mcs.TextColor  = RGB(0, 0, 0)
rb_m2.TextColor   = RGB(0, 0, 0)
rb_mc2.TextColor  = RGB(0, 0, 0)
rb_mcs2.TextColor = RGB(0, 0, 0)

dw_body.DataObject = 'd_55027_d02'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55027_r02'
dw_print.SetTransObject(SQLCA)

is_flag = '2'

end event

type rb_mcs from radiobutton within w_55027_d
integer x = 37
integer y = 492
integer width = 270
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
string text = "SIZE"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_m.TextColor    = RGB(0, 0, 0)
rb_mc.TextColor   = RGB(0, 0, 0)
This.TextColor    = RGB(0, 0, 255)
rb_m2.TextColor   = RGB(0, 0, 0)
rb_mc2.TextColor  = RGB(0, 0, 0)
rb_mcs2.TextColor = RGB(0, 0, 0)

dw_body.DataObject = 'd_55027_d03'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55027_r03'
dw_print.SetTransObject(SQLCA)

is_flag = '3'

end event

type p_1 from picture within w_55027_d
integer x = 37
integer y = 56
integer width = 73
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "F:\Bnc_dept\bmp\lemp.bmp"
boolean focusrectangle = false
end type

type st_1 from statictext within w_55027_d
integer x = 64
integer y = 228
integer width = 352
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "< STYLE >"
boolean focusrectangle = false
end type

type st_2 from statictext within w_55027_d
integer x = 425
integer y = 228
integer width = 215
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "< MCS >"
boolean focusrectangle = false
end type

type rb_m2 from radiobutton within w_55027_d
integer x = 398
integer y = 316
integer width = 265
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
string text = "STYLE"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_m.TextColor    = RGB(0, 0, 0)
rb_mc.TextColor   = RGB(0, 0, 0)
rb_mcs.TextColor  = RGB(0, 0, 0)
This.TextColor    = RGB(0, 0, 255)
rb_mc2.TextColor  = RGB(0, 0, 0)
rb_mcs2.TextColor = RGB(0, 0, 0)

dw_body.DataObject = 'd_55027_d04'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55027_r04'
dw_print.SetTransObject(SQLCA)

is_flag = '4'

end event

type rb_mc2 from radiobutton within w_55027_d
integer x = 398
integer y = 404
integer width = 270
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
string text = "COLOR"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_m.TextColor    = RGB(0, 0, 0)
rb_mc.TextColor   = RGB(0, 0, 0)
rb_mcs.TextColor  = RGB(0, 0, 0)
rb_m2.TextColor   = RGB(0, 0, 0)
This.TextColor    = RGB(0, 0, 255)
rb_mcs2.TextColor = RGB(0, 0, 0)

dw_body.DataObject = 'd_55027_d05'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55027_r05'
dw_print.SetTransObject(SQLCA)

is_flag = '5'

end event

type rb_mcs2 from radiobutton within w_55027_d
integer x = 398
integer y = 492
integer width = 270
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
string text = "SIZE"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_m.TextColor    = RGB(0, 0, 0)
rb_mc.TextColor   = RGB(0, 0, 0)
rb_mcs.TextColor  = RGB(0, 0, 0)
rb_m2.TextColor   = RGB(0, 0, 0)
rb_mc2.TextColor  = RGB(0, 0, 0)
This.TextColor    = RGB(0, 0, 255)

dw_body.DataObject = 'd_55027_d06'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55027_r06'
dw_print.SetTransObject(SQLCA)

is_flag = '6'

end event

type gb_1 from groupbox within w_55027_d
integer y = 136
integer width = 736
integer height = 476
integer taborder = 110
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

