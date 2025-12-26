$PBExportHeader$w_53036_d.srw
$PBExportComments$판매 현황(대만,베트남)
forward
global type w_53036_d from w_com010_d
end type
type rb_date from radiobutton within w_53036_d
end type
type rb_shop from radiobutton within w_53036_d
end type
type rb_sojae from radiobutton within w_53036_d
end type
type rb_item from radiobutton within w_53036_d
end type
type rb_style from radiobutton within w_53036_d
end type
type rb_mcs from radiobutton within w_53036_d
end type
type rb_style_no from radiobutton within w_53036_d
end type
type rb_mncs from radiobutton within w_53036_d
end type
type rb_mc from radiobutton within w_53036_d
end type
type rb_shop_tag from radiobutton within w_53036_d
end type
type gb_1 from groupbox within w_53036_d
end type
type dw_detail from datawindow within w_53036_d
end type
type rb_yymm from radiobutton within w_53036_d
end type
type dw_1 from u_dw within w_53036_d
end type
type dw_2 from datawindow within w_53036_d
end type
type cbx_except from checkbox within w_53036_d
end type
end forward

global type w_53036_d from w_com010_d
integer width = 3685
integer height = 2276
rb_date rb_date
rb_shop rb_shop
rb_sojae rb_sojae
rb_item rb_item
rb_style rb_style
rb_mcs rb_mcs
rb_style_no rb_style_no
rb_mncs rb_mncs
rb_mc rb_mc
rb_shop_tag rb_shop_tag
gb_1 gb_1
dw_detail dw_detail
rb_yymm rb_yymm
dw_1 dw_1
dw_2 dw_2
cbx_except cbx_except
end type
global w_53036_d w_53036_d

type variables
DataWindowChild idw_brand, idw_shop_div, idw_area_cd, idw_shop_type
DataWindowChild idw_season, idw_sojae, idw_item, idw_color

String is_brand, is_fr_ymd, is_to_ymd, is_shop_div, is_area_cd, is_style, is_chno, is_ps_except
String is_shop_cd, is_shop_type, is_year, is_season, is_sojae, is_item, is_seq_no, is_color, is_plan_dc
string is_except_eshop, is_dotcom
end variables

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_fr_ymd = Trim(dw_head.GetItemString(1, "fr_ymd"))
if IsNull(is_fr_ymd) or is_fr_ymd = "" then
   MessageBox(ls_title,"판매 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = Trim(dw_head.GetItemString(1, "to_ymd"))
if IsNull(is_to_ymd) or is_to_ymd = "" then
   MessageBox(ls_title,"판매 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

if is_to_ymd < is_fr_ymd then
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
if IsNull(is_shop_div) or is_shop_div = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_area_cd = Trim(dw_head.GetItemString(1, "area_cd"))
if IsNull(is_area_cd) or is_area_cd = "" then
   MessageBox(ls_title,"지역 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("area_cd")
   return false
end if

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd"))
if IsNull(is_shop_cd) or is_shop_cd = "" then
	is_shop_cd = '%'
end if

is_shop_type = Trim(dw_head.GetItemString(1, "shop_type"))
if IsNull(is_shop_type) or is_shop_type = "" then
   MessageBox(ls_title,"매장 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then is_year = '%'

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_sojae = Trim(dw_head.GetItemString(1, "sojae"))
if IsNull(is_sojae) or is_sojae = "" then
   MessageBox(ls_title,"소재 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = Trim(dw_head.GetItemString(1, "item"))
if IsNull(is_item) or is_item = "" then
   MessageBox(ls_title,"품종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_seq_no = Trim(dw_head.GetItemString(1, "seq_no"))
if IsNull(is_seq_no) or is_seq_no = "" then
	is_seq_no = '%'
end if


is_color = Trim(dw_head.GetItemString(1, "color"))
if IsNull(is_color) or is_color = "" then
   MessageBox(ls_title,"색상 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("color")
   return false
end if

is_plan_dc = Trim(dw_head.GetItemString(1, "plan_dc"))
if IsNull(is_plan_dc) or is_plan_dc = "" then
   MessageBox(ls_title,"조회구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("plan_dc")
   return false
end if

is_except_eshop = Trim(dw_head.GetItemString(1, "except_eshop"))
if IsNull(is_except_eshop) or is_except_eshop = "" then
   MessageBox(ls_title,"제외구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("except_eshop")
   return false
end if


is_dotcom = Trim(dw_head.GetItemString(1, "dotcom"))
if IsNull(is_dotcom) or is_dotcom = "" then
   MessageBox(ls_title,"닷컴매장구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dotcom")
   return false
end if


return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if cbx_except.visible then
	if cbx_except.checked then
		is_ps_except = "Y"
	else 	
		is_ps_except = "N"		
	end if
end if	

if cbx_except.visible then
	il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_div, is_area_cd, &
										is_shop_cd, is_shop_type, is_year, is_season, is_sojae, is_item, is_seq_no, is_color, is_ps_except, is_plan_dc, is_except_eshop, IS_DOTCOM)
else									
	il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_div, is_area_cd, &
										is_shop_cd, is_shop_type, is_year, is_season, is_sojae, is_item, is_seq_no, is_color, is_plan_dc,is_except_eshop, IS_DOTCOM)									
end if										

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

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				IF LeftA(as_data, 1) = is_brand And gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm",  ls_shop_nm)
				   dw_head.SetItem(al_row, "shop_div", '%')
				   dw_head.SetItem(al_row, "area_cd",  '%')
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
				dw_head.SetItem(al_row, "shop_div", '%')
				dw_head.SetItem(al_row, "area_cd",  '%')
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
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

on w_53036_d.create
int iCurrent
call super::create
this.rb_date=create rb_date
this.rb_shop=create rb_shop
this.rb_sojae=create rb_sojae
this.rb_item=create rb_item
this.rb_style=create rb_style
this.rb_mcs=create rb_mcs
this.rb_style_no=create rb_style_no
this.rb_mncs=create rb_mncs
this.rb_mc=create rb_mc
this.rb_shop_tag=create rb_shop_tag
this.gb_1=create gb_1
this.dw_detail=create dw_detail
this.rb_yymm=create rb_yymm
this.dw_1=create dw_1
this.dw_2=create dw_2
this.cbx_except=create cbx_except
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_date
this.Control[iCurrent+2]=this.rb_shop
this.Control[iCurrent+3]=this.rb_sojae
this.Control[iCurrent+4]=this.rb_item
this.Control[iCurrent+5]=this.rb_style
this.Control[iCurrent+6]=this.rb_mcs
this.Control[iCurrent+7]=this.rb_style_no
this.Control[iCurrent+8]=this.rb_mncs
this.Control[iCurrent+9]=this.rb_mc
this.Control[iCurrent+10]=this.rb_shop_tag
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.dw_detail
this.Control[iCurrent+13]=this.rb_yymm
this.Control[iCurrent+14]=this.dw_1
this.Control[iCurrent+15]=this.dw_2
this.Control[iCurrent+16]=this.cbx_except
end on

on w_53036_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_date)
destroy(this.rb_shop)
destroy(this.rb_sojae)
destroy(this.rb_item)
destroy(this.rb_style)
destroy(this.rb_mcs)
destroy(this.rb_style_no)
destroy(this.rb_mncs)
destroy(this.rb_mc)
destroy(this.rb_shop_tag)
destroy(this.gb_1)
destroy(this.dw_detail)
destroy(this.rb_yymm)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.cbx_except)
end on

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm, ls_year, ls_ps_except

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_shop_cd = '%' Then
	ls_shop_nm = '전체'
Else
	ls_shop_nm = dw_head.GetItemString(1, "shop_nm")
End If

If is_year = '%' Then
	ls_year = '전체'
Else
	ls_year = is_year
End If


if cbx_except.visible then
	if cbx_except.checked then
		ls_ps_except = "※ 악세사리 제외"
	else 	
		ls_ps_except = "※ 악세사리 포함"		
	end if
end if	


if cbx_except.visible then
	ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_yymmdd.Text = '" + String(is_fr_ymd, '@@@@/@@/@@') + ' ~ ' + String(is_to_ymd, '@@@@/@@/@@') + "'" + &
            "t_shop_div.Text = '" + idw_shop_div.GetItemString(idw_shop_div.GetRow(), "inter_display") + "'" + &
            "t_area_cd.Text = '" + idw_area_cd.GetItemString(idw_area_cd.GetRow(), "inter_display") + "'" + &
            "t_shop_cd.Text = '" + is_shop_cd + " " + ls_shop_nm + "'" + &
            "t_shop_type.Text = '" + idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "'" + &
            "t_year.Text = '" + ls_year + "'" + &
            "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_sojae.Text = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_display") + "'" + &
            "t_item.Text = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'" + &
            "t_seq_no.Text = '" + is_seq_no + "'" + &
            "t_color.Text = '" + idw_color.GetItemString(idw_color.GetRow(), "color_display") + "'"  + &
            "t_ps_except.Text = '" + ls_ps_except + "'" 
else
	ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
					"t_user_id.Text = '" + gs_user_id + "'" + &
					"t_datetime.Text = '" + ls_datetime + "'" + &
					"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_yymmdd.Text = '" + String(is_fr_ymd, '@@@@/@@/@@') + ' ~ ' + String(is_to_ymd, '@@@@/@@/@@') + "'" + &
					"t_shop_div.Text = '" + idw_shop_div.GetItemString(idw_shop_div.GetRow(), "inter_display") + "'" + &
					"t_area_cd.Text = '" + idw_area_cd.GetItemString(idw_area_cd.GetRow(), "inter_display") + "'" + &
					"t_shop_cd.Text = '" + is_shop_cd + " " + ls_shop_nm + "'" + &
					"t_shop_type.Text = '" + idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "'" + &
					"t_year.Text = '" + ls_year + "'" + &
					"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
					"t_sojae.Text = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_display") + "'" + &
					"t_item.Text = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'" + &
					"t_seq_no.Text = '" + is_seq_no + "'" + &
					"t_color.Text = '" + idw_color.GetItemString(idw_color.GetRow(), "color_display") + "'" 
end if				


dw_print.Modify(ls_modify)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
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
         cb_print.Enabled    = true
         cb_preview.Enabled  = true
         cb_excel.Enabled    = true
         cb_retrieve.Text    = "조회(&Q)"
         dw_head.Enabled     = true
			rb_date.Enabled     = false
			rb_shop_tag.Enabled = false
			rb_shop.Enabled     = false
			rb_sojae.Enabled    = false
			rb_item.Enabled     = false
			rb_style.Enabled    = false
			rb_mc.Enabled       = false
			rb_mcs.Enabled      = false
			rb_style_no.Enabled = false
			rb_mncs.Enabled     = false
         dw_body.Enabled     = true
         dw_body.SetFocus()
      else
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
      end if

      if al_rows >= 0 then
         ib_changed        = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.Enabled    = false
      cb_preview.Enabled  = false
      cb_excel.Enabled    = false
      ib_changed          = false
      dw_body.Enabled     = false
      dw_head.Enabled     = true
		rb_date.Enabled     = true
		rb_shop.Enabled     = true
		rb_shop_tag.Enabled = true
		rb_sojae.Enabled    = true
		rb_item.Enabled     = true
		rb_style.Enabled    = true
		rb_mc.Enabled       = true
		rb_mcs.Enabled      = true
		rb_style_no.Enabled = true
		rb_mncs.Enabled     = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event open;call super::open;dw_head.Setitem(1,'season', '%')
dw_head.Setitem(1,'year', '%')


datetime ld_datetime
string ls_fr_ymd, ls_to_ymd

select convert(char(08), dateadd(day, -1, dateadd(month, 1, left(convert(char(08), getdate(), 112),6) + '01'))	,112),
	 	 left(convert(char(08), getdate(), 112),6) + '01'
into   :ls_to_ymd, :ls_fr_ymd 
from dual;

dw_head.SetItem(1, "fr_ymd" ,ls_fr_ymd)
dw_head.SetItem(1, "to_ymd" ,ls_to_ymd)
end event

event pfc_preopen();call super::pfc_preopen;/* DataWindow의 Transction 정의 */
dw_detail.SetTransObject(SQLCA)

inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")


/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53036_d","0")
end event

type cb_close from w_com010_d`cb_close within w_53036_d
end type

type cb_delete from w_com010_d`cb_delete within w_53036_d
end type

type cb_insert from w_com010_d`cb_insert within w_53036_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_53036_d
end type

type cb_update from w_com010_d`cb_update within w_53036_d
end type

type cb_print from w_com010_d`cb_print within w_53036_d
end type

type cb_preview from w_com010_d`cb_preview within w_53036_d
end type

type gb_button from w_com010_d`gb_button within w_53036_d
end type

type cb_excel from w_com010_d`cb_excel within w_53036_d
end type

type dw_head from w_com010_d`dw_head within w_53036_d
integer y = 304
integer height = 292
string dataobject = "d_53036_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		This.Setitem(1, "shop_cd", "")
		This.Setitem(1, "shop_nm", "")
		
		This.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', data)
		idw_sojae.insertrow(1)
		idw_sojae.Setitem(1, "sojae", "%")
		idw_sojae.Setitem(1, "sojae_nm", "전체")
		
		This.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve(data)
		idw_item.insertrow(1)
		idw_item.Setitem(1, "item", "%")
		idw_item.Setitem(1, "item_nm", "전체")		
		
		
		
		
	CASE "shop_div"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
	CASE "area_cd"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

This.GetChild("area_cd", idw_area_cd)
idw_area_cd.SetTransObject(SQLCA)
idw_area_cd.Retrieve('090')
idw_area_cd.InsertRow(1)
idw_area_cd.SetItem(1, "inter_cd", '%')
idw_area_cd.SetItem(1, "inter_nm", '전체')

This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '0')
idw_shop_type.SetItem(1, "inter_nm", '기타제외')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%',gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()
idw_color.InsertRow(1)
idw_color.SetItem(1, "color", '%')
idw_color.SetItem(1, "color_enm", '전체')

end event

type ln_1 from w_com010_d`ln_1 within w_53036_d
integer beginy = 596
integer endy = 596
end type

type ln_2 from w_com010_d`ln_2 within w_53036_d
integer beginy = 600
integer endy = 600
end type

type dw_body from w_com010_d`dw_body within w_53036_d
integer x = 14
integer y = 608
integer height = 1432
string dataobject = "d_53036_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_shop_nm
is_shop_cd = this.getitemstring(row,"shop_cd")
ls_shop_nm = this.getitemstring(row,"shop_nm")
IF LenA(is_shop_cd) = 6  THEN		
	il_rows = dw_1.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_div, is_area_cd, &
								is_shop_cd, is_shop_type, is_year, is_season, is_sojae, is_item, is_seq_no, is_color, is_plan_dc,is_except_eshop, is_dotcom)
	
	if il_rows > 0 then 
		dw_1.title = ls_shop_nm
		dw_1.visible = true
	   dw_1.SetFocus()
		
	end if

END IF
   
	
//dw_detail.reset()
//is_style =  dw_body.GetitemString(row,"style")	
//is_chno  =  dw_body.GetitemString(row,"chno")	
//
//
//IF is_style = "" OR isnull(is_style) THEN		
//	return
//END IF
//
//IF is_chno = "" OR isnull(is_chno) THEN		
//		is_chno = '%'
//	END IF
//	
//IF dw_detail.RowCount() < 1 THEN 
//	il_rows = dw_detail.retrieve(is_style, is_chno)
//	
//END IF 
//
//dw_detail.visible = True

end event

type dw_print from w_com010_d`dw_print within w_53036_d
string dataobject = "d_53036_r01"
end type

type rb_date from radiobutton within w_53036_d
integer x = 41
integer y = 200
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
string text = "일  자"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
rb_shop.TextColor     = 0
rb_shop_tag.TextColor = 0
rb_sojae.TextColor    = 0
rb_item.TextColor     = 0
rb_style.TextColor    = 0
rb_mc.TextColor       = 0
rb_mcs.TextColor      = 0
rb_style_no.TextColor = 0
rb_mncs.TextColor     = 0
cbx_except.visible    = false

dw_body.DataObject  = 'd_53036_d01'
dw_print.DataObject = 'd_53036_r01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_shop from radiobutton within w_53036_d
integer x = 581
integer y = 200
integer width = 283
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
string text = "매  장"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
This.TextColor        = RGB(0, 0, 255)
rb_shop_tag.TextColor = 0
rb_sojae.TextColor    = 0
rb_item.TextColor     = 0
rb_style.TextColor    = 0
rb_mc.TextColor       = 0
rb_mcs.TextColor      = 0
rb_style_no.TextColor = 0
rb_mncs.TextColor     = 0
cbx_except.visible    = false

dw_body.DataObject  = 'd_53036_d02'
dw_print.DataObject = 'd_53036_r02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_sojae from radiobutton within w_53036_d
integer x = 1339
integer y = 200
integer width = 283
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
string text = "소  재"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_shop.TextColor     = 0
rb_shop_tag.TextColor = 0
This.TextColor        = RGB(0, 0, 255)
rb_item.TextColor     = 0
rb_style.TextColor    = 0
rb_mc.TextColor       = 0
rb_mcs.TextColor      = 0
rb_style_no.TextColor = 0
rb_mncs.TextColor     = 0
cbx_except.visible    = false

dw_body.DataObject  = 'd_53036_d03'
dw_print.DataObject = 'd_53036_r03'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_item from radiobutton within w_53036_d
integer x = 1605
integer y = 200
integer width = 283
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
string text = "품  종"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_shop.TextColor     = 0
rb_shop_tag.TextColor = 0
rb_sojae.TextColor    = 0
This.TextColor        = RGB(0, 0, 255)
rb_style.TextColor    = 0
rb_mc.TextColor       = 0
rb_mcs.TextColor      = 0
rb_style_no.TextColor = 0
rb_mncs.TextColor     = 0
cbx_except.visible    = false

dw_body.DataObject  = 'd_53036_d04'
dw_print.DataObject = 'd_53036_r04'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_style from radiobutton within w_53036_d
integer x = 1911
integer y = 200
integer width = 283
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

event clicked;rb_date.TextColor     = 0
rb_shop.TextColor     = 0
rb_shop_tag.TextColor = 0
rb_sojae.TextColor    = 0
rb_item.TextColor     = 0
This.TextColor        = RGB(0, 0, 255)
rb_mc.TextColor       = 0
rb_mcs.TextColor      = 0
rb_style_no.TextColor = 0
rb_mncs.TextColor     = 0
cbx_except.visible    = false

dw_body.DataObject  = 'd_53036_d05'
dw_print.DataObject = 'd_53036_r05'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_mcs from radiobutton within w_53036_d
integer x = 2565
integer y = 200
integer width = 407
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
string text = "STYLE+CL+SZ"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_shop.TextColor     = 0
rb_shop_tag.TextColor = 0
rb_sojae.TextColor    = 0
rb_item.TextColor     = 0
rb_style.TextColor    = 0
rb_mc.TextColor       = 0
This.TextColor        = RGB(0, 0, 255)
rb_style_no.TextColor = 0
rb_mncs.TextColor     = 0
cbx_except.visible    = false

dw_body.DataObject  = 'd_53036_d06'
dw_print.DataObject = 'd_53036_r06'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_style_no from radiobutton within w_53036_d
integer x = 2999
integer y = 200
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
string text = "STYLE_NO"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_shop.TextColor     = 0
rb_shop_tag.TextColor = 0
rb_sojae.TextColor    = 0
rb_item.TextColor     = 0
rb_style.TextColor    = 0
rb_mc.TextColor       = 0
rb_mcs.TextColor      = 0
This.TextColor        = RGB(0, 0, 255)
rb_mncs.TextColor     = 0
cbx_except.visible    = false

dw_body.DataObject  = 'd_53036_d07'
dw_print.DataObject = 'd_53036_r07'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_mncs from radiobutton within w_53036_d
integer x = 3333
integer y = 200
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
string text = "STYLE_NO+CL+SZ"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_shop.TextColor     = 0
rb_shop_tag.TextColor = 0
rb_sojae.TextColor    = 0
rb_item.TextColor     = 0
rb_style.TextColor    = 0
rb_mc.TextColor       = 0
rb_mcs.TextColor      = 0
rb_style_no.TextColor = 0
This.TextColor        = RGB(0, 0, 255)
cbx_except.visible    = false

dw_body.DataObject  = 'd_53036_d08'
dw_print.DataObject = 'd_53036_r08'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_mc from radiobutton within w_53036_d
integer x = 2217
integer y = 200
integer width = 343
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
string text = "STYLE+CL"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_shop.TextColor     = 0
rb_shop_tag.TextColor = 0
rb_sojae.TextColor    = 0
rb_item.TextColor     = 0
rb_style.TextColor    = 0
This.TextColor        = RGB(0, 0, 255)
rb_mcs.TextColor = 0
rb_style_no.TextColor = 0
rb_mncs.TextColor     = 0
cbx_except.visible    = false

dw_body.DataObject  = 'd_53036_d09'
dw_print.DataObject = 'd_53036_r09'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type rb_shop_tag from radiobutton within w_53036_d
integer x = 891
integer y = 200
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
long backcolor = 67108864
string text = "매장(tag가)"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_shop.TextColor     = 0
This.TextColor        = RGB(0, 0, 255)
rb_sojae.TextColor    = 0
rb_item.TextColor     = 0
rb_style.TextColor    = 0
rb_mc.TextColor       = 0
rb_mcs.TextColor      = 0
rb_style_no.TextColor = 0
rb_mncs.TextColor     = 0
cbx_except.visible    = true

dw_body.DataObject  = 'd_53036_d10'
dw_print.DataObject = 'd_53036_r10'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type gb_1 from groupbox within w_53036_d
integer y = 140
integer width = 3845
integer height = 156
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

type dw_detail from datawindow within w_53036_d
boolean visible = false
integer x = 923
integer y = 196
integer width = 1925
integer height = 1832
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "스타일정보"
string dataobject = "d_style_pic"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;dw_detail.visible = false
end event

type rb_yymm from radiobutton within w_53036_d
integer x = 329
integer y = 200
integer width = 251
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
string text = "월 별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_shop.TextColor    = 0
This.TextColor        = RGB(0, 0, 255)
rb_sojae.TextColor    = 0
rb_item.TextColor     = 0
rb_style.TextColor    = 0
rb_mc.TextColor       = 0
rb_mcs.TextColor      = 0
rb_style_no.TextColor = 0
rb_mncs.TextColor     = 0
cbx_except.visible    = false

dw_body.DataObject  = 'd_53036_d13'
dw_print.DataObject = 'd_53036_r13'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type dw_1 from u_dw within w_53036_d
boolean visible = false
integer x = 699
integer y = 676
integer width = 2912
integer height = 1364
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_53036_d09"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event clicked;call super::clicked;
dw_detail.reset()
is_style =  dw_1.GetitemString(row,"style")	
is_chno =  dw_1.GetitemString(row,"chno")	


IF is_style = "" OR isnull(is_style) THEN		
	return
END IF

IF is_chno = "" OR isnull(is_chno) THEN		
		is_chno = '%'
	END IF
	
IF dw_detail.RowCount() < 1 THEN 
	il_rows = dw_detail.retrieve(is_style, is_chno)
	
END IF 

dw_detail.visible = True
end event

event constructor;call super::constructor;This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)
end event

type dw_2 from datawindow within w_53036_d
boolean visible = false
integer x = 699
integer y = 676
integer width = 2578
integer height = 1364
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "스타일별 판매현황"
string dataobject = "d_53036_d05"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;	
	
dw_detail.reset()
is_style =  dw_1.GetitemString(row,"style")	
is_chno =  dw_1.GetitemString(row,"chno")	



IF is_style = "" OR isnull(is_style) THEN		
	return
END IF

IF is_chno = "" OR isnull(is_chno) THEN		
		is_chno = '%'
	END IF
	
IF dw_detail.RowCount() < 1 THEN 
	il_rows = dw_detail.retrieve(is_style, is_chno)
	
END IF 

dw_detail.visible = True
end event

type cbx_except from checkbox within w_53036_d
boolean visible = false
integer x = 3369
integer y = 324
integer width = 489
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "악세사리제외"
borderstyle borderstyle = stylelowered!
end type

