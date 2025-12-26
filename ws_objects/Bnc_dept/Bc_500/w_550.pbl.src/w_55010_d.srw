$PBExportHeader$w_55010_d.srw
$PBExportComments$매장(입고/판매/재고)현황
forward
global type w_55010_d from w_com010_d
end type
type st_1 from statictext within w_55010_d
end type
end forward

global type w_55010_d from w_com010_d
integer width = 3689
integer height = 2280
st_1 st_1
end type
global w_55010_d w_55010_d

type variables
String is_yymmdd, is_brand, is_year, is_season, is_shop_type, is_item, is_bujin_chk, is_sojae, is_rpt_gubn
DataWindowChild idw_brand, idw_season, idw_shop_type, idw_item, idw_shop_div, idw_sojae
String is_ps_except, is_sale_apply, is_dc_chk, is_fr_ymd, is_to_ymd, is_shop_cd
end variables

on w_55010_d.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_55010_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_bujin_chk = "Y" then
	if is_rpt_gubn = "N" then 
		dw_body.dataobject = "d_55010_d01"
		dw_print.dataobject = "d_55010_r01"
	else	
		dw_body.dataobject = "d_55010_d03"	
		dw_print.dataobject = "d_55010_r03"		
	end if	
ELSEif is_sale_apply = "Y" then
	if is_rpt_gubn = "N" then 
		dw_body.dataobject = "d_55010_d01"
		dw_print.dataobject = "d_55010_r01"		
	else	
		dw_body.dataobject = "d_55010_d03"	
		dw_print.dataobject = "d_55010_r03"		
	end if	
ELSEif is_dc_chk = "Y" then
	if is_rpt_gubn = "N" then 
		dw_body.dataobject = "d_55010_d01"
		dw_print.dataobject = "d_55010_r01"				
	else	
		dw_body.dataobject = "d_55010_d03"	
		dw_print.dataobject = "d_55010_r03"				
	end if	
else	
	if is_rpt_gubn = "N" then 
		dw_body.dataobject = "d_55010_d02"
		dw_print.dataobject = "d_55010_r02"				
	else	
		dw_body.dataobject = "d_55010_d04"
		dw_print.dataobject = "d_55010_r04"				
	end if	
end if


dw_body.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_yymmdd, is_fr_ymd, is_to_ymd, is_brand, is_year, is_season, is_shop_type, is_item,is_sojae, is_bujin_chk, is_ps_except, is_sale_apply, is_dc_chk, is_shop_cd)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

THIS.TRIGGER EVENT ue_button(1, il_rows)
THIS.TRIGGER EVENT ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
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

is_yymmdd = Trim(String(dw_head.GetItemDate(1, "yymmdd"), 'yyyymmdd'))
IF IsNull(is_yymmdd) OR is_yymmdd = "" THEN
   MessageBox(ls_title,"일자 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   RETURN FALSE
END IF

is_fr_ymd = Trim(dw_head.GetItemString(1, "fr_ymd"))
IF IsNull(is_fr_ymd) OR is_fr_ymd = "" THEN
   MessageBox(ls_title,"기간 시작일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   RETURN FALSE
END IF


is_to_ymd = Trim(dw_head.GetItemString(1, "to_ymd"))
IF IsNull(is_to_ymd) OR is_to_ymd = "" THEN
   MessageBox(ls_title,"기간 마지막일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF


is_brand = Trim(dw_head.GetItemString(1, "brand"))
IF IsNull(is_brand) OR is_brand = "" THEN
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF


//if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
//   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false	
//elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false		
//elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false			
//end if	




if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
//elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
elseif (gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'E' or is_brand = 'M' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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




is_year = Trim(dw_head.GetItemString(1, "year"))
IF IsNull(is_year) OR is_year = "" THEN
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   RETURN FALSE
END IF

is_season = Trim(dw_head.GetItemString(1, "season"))
IF IsNull(is_season) OR is_season = "" THEN
   MessageBox(ls_title,"시즌 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   RETURN FALSE
END IF

is_shop_type = Trim(dw_head.GetItemString(1, "shop_type"))
IF IsNull(is_shop_type) OR is_shop_type = "" THEN
   MessageBox(ls_title,"매장 형태를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   RETURN FALSE
END IF

is_item = Trim(dw_head.GetItemString(1, "item"))
IF IsNull(is_item) OR is_item = "" THEN
   MessageBox(ls_title,"품종 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   RETURN FALSE
END IF

is_sojae = Trim(dw_head.GetItemString(1, "sojae"))
IF IsNull(is_sojae) OR is_sojae = "" THEN
   MessageBox(ls_title,"소재 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   RETURN FALSE
END IF

is_bujin_chk = Trim(dw_head.GetItemString(1, "bujin_chk"))
IF IsNull(is_bujin_chk) OR is_bujin_chk = "" THEN
   MessageBox(ls_title,"부진구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("bujin_chk")
   RETURN FALSE
END IF

is_rpt_gubn = Trim(dw_head.GetItemString(1, "rpt_gubn"))
IF IsNull(is_rpt_gubn) OR is_rpt_gubn = "" THEN
   MessageBox(ls_title,"조회구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rpt_gubn")
   RETURN FALSE
END IF

is_ps_except = Trim(dw_head.GetItemString(1, "ps_except"))
IF IsNull(is_ps_except) OR is_ps_except = "" THEN
   MessageBox(ls_title,"악세사리제외를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("ps_except")
   RETURN FALSE
END IF

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd"))
IF IsNull(is_shop_cd) OR is_shop_cd = "" THEN
 is_shop_cd = "%"
END IF


is_sale_apply = Trim(dw_head.GetItemString(1, "sale_apply"))
is_dc_chk = Trim(dw_head.GetItemString(1, "dc_chk"))

RETURN TRUE

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */
/* 작성일      : 2002.02.18                                                  */
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_sale_type, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text     = '" + is_pgm_id    + "'" + &
				"t_user_id.Text   = '" + gs_user_id   + "'" + &
				"t_datetime.Text  = '" + ls_datetime  + "'" + &
				"t_yymmdd.Text    = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
				"t_year.Text      = '" + is_year      + "'" + &
				"t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(),         "inter_display") + "'" + &
				"t_season.Text    = '" + idw_season.GetItemString(idw_season.GetRow(),       "inter_display") + "'" + &
				"t_sale_type.Text = '" + idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "'" + &
				"t_item.Text      = '" + idw_item.GetItemString(idw_item.GetRow(),           "item_display")  + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55010_d","0")
end event

event ue_print();call super::ue_print;if is_bujin_chk = "Y" then
	if is_rpt_gubn = "N" then 
		dw_print.dataobject = "d_55010_r01"
	else	
		dw_print.dataobject = "d_55010_r03"	
	end if	
else	
	if is_rpt_gubn = "N" then 
		dw_print.dataobject = "d_55010_r02"
	else	
		dw_print.dataobject = "d_55010_r04"	
	end if	
end if

dw_print.SetTransObject(SQLCA)

end event

event ue_preview();call super::ue_preview;if is_bujin_chk = "Y" then
	if is_rpt_gubn = "N" then 
		dw_print.dataobject = "d_55010_r01"
	else	
		dw_print.dataobject = "d_55010_r03"	
	end if	
else	
	if is_rpt_gubn = "N" then 
		dw_print.dataobject = "d_55010_r02"
	else	
		dw_print.dataobject = "d_55010_r04"	
	end if	
end if

dw_print.SetTransObject(SQLCA)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm , ls_brand_grp
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		is_brand = dw_head.GetItemString(1, "brand")
		
		
		select dbo.sf_inter_cd2('001', :is_brand)
		into :ls_brand_grp    
		from dual;
		
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
			
			
			 
//	"WHERE  '" + gs_brand_grp + "' like '%' + brand + '%'  and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_f+is_season_s_f+"' ) )" + &
			gst_cd.default_where   = "WHERE  '" + ls_brand_grp + "' like '%' + brand + '%'  AND SHOP_STAT = '00' "
//			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "			
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

type cb_close from w_com010_d`cb_close within w_55010_d
end type

type cb_delete from w_com010_d`cb_delete within w_55010_d
end type

type cb_insert from w_com010_d`cb_insert within w_55010_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55010_d
end type

type cb_update from w_com010_d`cb_update within w_55010_d
end type

type cb_print from w_com010_d`cb_print within w_55010_d
end type

type cb_preview from w_com010_d`cb_preview within w_55010_d
end type

type gb_button from w_com010_d`gb_button within w_55010_d
end type

type cb_excel from w_com010_d`cb_excel within w_55010_d
end type

type dw_head from w_com010_d`dw_head within w_55010_d
integer height = 308
string dataobject = "d_55010_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003',gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


THIS.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')

THIS.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

THIS.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
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
		
		
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		

END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_55010_d
integer beginy = 512
integer endy = 512
end type

type ln_2 from w_com010_d`ln_2 within w_55010_d
integer beginy = 516
integer endy = 516
end type

type dw_body from w_com010_d`dw_body within w_55010_d
integer x = 9
integer y = 524
integer width = 3598
integer height = 1520
string dataobject = "d_55010_d04"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_55010_d
string dataobject = "d_55010_r01"
end type

type st_1 from statictext within w_55010_d
integer x = 37
integer y = 68
integer width = 480
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "(금액단위 : 천원)"
boolean focusrectangle = false
end type

