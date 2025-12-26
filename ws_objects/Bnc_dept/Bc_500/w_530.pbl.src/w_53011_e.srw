$PBExportHeader$w_53011_e.srw
$PBExportComments$부진모델 이동처리
forward
global type w_53011_e from w_com010_e
end type
type st_1 from statictext within w_53011_e
end type
type cbx_laser from checkbox within w_53011_e
end type
end forward

global type w_53011_e from w_com010_e
st_1 st_1
cbx_laser cbx_laser
end type
global w_53011_e w_53011_e

type variables
DataWindowChild idw_dep_seq
String is_brand,  is_year,    is_season,       is_dep_seq
String is_yymmdd, is_shop_cd, is_fr_shop_type, is_to_shop_type  , is_to_shop_cd
end variables

on w_53011_e.create
int iCurrent
call super::create
this.st_1=create st_1
this.cbx_laser=create cbx_laser
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cbx_laser
end on

on w_53011_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cbx_laser)
end on

event open;call super::open;dw_head.Setitem(1, "fr_shop_type", '1')
dw_head.Setitem(1, "to_shop_type", '4')

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm
Boolean    lb_check 
DataStore  lds_Source

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
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' "
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
				dw_head.SetColumn("fr_shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
			
	CASE "to_shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "to_shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' "
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
				dw_head.SetItem(al_row, "to_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "to_shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("to_shop_type")
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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.09                                                  */	
/* 수정일      : 2002.04.01                                                  */
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
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
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

is_dep_seq = dw_head.GetItemString(1, "dep_seq")
if IsNull(is_dep_seq) or Trim(is_dep_seq) = "" then
   MessageBox(ls_title,"부진 차수를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dep_seq")
   return false
end if

is_yymmdd = String(dw_head.GetitemDate(1, "yymmdd"), "yyyymmdd")

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_to_shop_cd = dw_head.GetItemString(1, "to_shop_cd")
if IsNull(is_to_shop_cd) or Trim(is_to_shop_cd) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_shop_cd")
   return false
end if

is_fr_shop_type = dw_head.GetItemString(1, "fr_shop_type")
if IsNull(is_fr_shop_type) or Trim(is_fr_shop_type) = "" then
   MessageBox(ls_title,"매장 형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_shop_type")
   return false
end if


is_to_shop_type = dw_head.GetItemString(1, "to_shop_type")
if IsNull(is_to_shop_type) or Trim(is_to_shop_type) = "" then
   MessageBox(ls_title,"매장 형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_shop_type")
   return false
end if

Return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.18                                                  */	
/* 수정일      : 2002.06.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_head.setitem(1,"out_no", "")

il_rows = dw_body.retrieve(is_yymmdd, is_shop_cd, is_fr_shop_type, is_to_shop_cd, is_to_shop_type, &
                           is_brand,  is_year   , is_season      , is_dep_seq)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSE
	MessageBox("확인","이동처리할 내역이 없습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_1, "ScaleToRight")

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
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      end if

      if al_rows > 0 then
         ib_changed = true
         cb_update.enabled = true
         st_1.Text = "<= 저장을 하셔야 이동 처리 됩니다 "
      end if
		
	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
         cb_update.enabled = false
			cb_print.enabled = true
         st_1.Text = "이동 처리 완료 되였습니다. "
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "산출(&Q)"
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
      st_1.Text = "현 시점 재고량으로 산출 합니다. "
END CHOOSE

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.18                                                  */	
/* 수정일      : 2002.06.18                                                  */
/*===========================================================================*/
long     i, ll_row_count
datetime ld_datetime
String   ls_out_no, ls_no, ls_style, ls_chno, ls_color, ls_size  
String   ls_fr_sale_type,  ls_to_sale_type,   ls_ErrMsg
long     ll_qty
Decimal  ldc_fr_disc_rate, ldc_fr_margin_rate, ldc_fr_curr_price, ldc_fr_out_price
Decimal  ldc_to_disc_rate, ldc_to_margin_rate, ldc_to_curr_price, ldc_to_out_price

IF dw_body.AcceptText() <> 1 THEN RETURN -1
ll_row_count = dw_body.RowCount()


IF MessageBox("주의!", "재고 이동처리를 진행하시겠습니까?" ,Exclamation!, OKCancel!, 2) <> 1 THEN
      return -1
END IF

// 출고 전표 채번 
IF Gf_Style_Outno(is_yymmdd, is_brand, ls_out_no) = FALSE THEN 
	Return -1 
else 
	dw_head.setitem(1, "out_no", ls_out_no)
END IF

il_rows    = 1 
FOR i=1 TO ll_row_count
	

	 ls_no              = String(i, "0000") 
	 ls_style           = dw_body.GetitemString(i, "style")
	 ls_chno            = dw_body.GetitemString(i, "chno") 
	 ls_color           = dw_body.GetitemString(i, "color") 
	 ls_size            = dw_body.GetitemString(i, "size")
    ls_fr_sale_type    = dw_body.GetitemString(i, "fr_sale_type")  
	 ls_to_sale_type    = dw_body.GetitemString(i, "to_sale_type")  
    ll_qty             = dw_body.GetitemNumber(i, "qty1")    
    ldc_fr_disc_rate   = dw_body.GetitemDecimal(i, "fr_disc_rate")    
	 ldc_fr_margin_rate = dw_body.GetitemDecimal(i, "fr_margin_rate")     
	 ldc_fr_curr_price  = dw_body.GetitemDecimal(i, "fr_curr_price")      
	 ldc_fr_out_price   = dw_body.GetitemDecimal(i, "fr_out_price")      
    ldc_to_disc_rate   = dw_body.GetitemDecimal(i, "to_disc_rate")     
	 ldc_to_margin_rate = dw_body.GetitemDecimal(i, "to_margin_rate")      
	 ldc_to_curr_price  = dw_body.GetitemDecimal(i, "to_curr_price")       
	 ldc_to_out_price   = dw_body.GetitemDecimal(i, "to_out_price")      

	 if ll_qty <> 0 then
	 
		 DECLARE SP_53011 PROCEDURE FOR SP_53011
					  @yymmdd         = :is_yymmdd,   
					  @fr_shop_cd     = :is_shop_cd, 
					  @fr_shop_type   = :is_fr_shop_type, 
					  @to_shop_cd     = :is_to_shop_cd, 				  
					  @to_shop_type   = :is_to_shop_type, 
					  @out_no         = :ls_out_no, 
					  @no             = :ls_no, 
					  @style          = :ls_style,
					  @chno           = :ls_chno,
					  @color          = :ls_color, 
					  @size           = :ls_size, 
					  @qty            = :ll_qty, 
					  @fr_sale_type   = :ls_fr_sale_type, 
					  @fr_disc_rate   = :ldc_fr_disc_rate, 
					  @fr_margin_rate = :ldc_fr_margin_rate,
					  @fr_curr_price  = :ldc_fr_curr_price, 
					  @fr_out_price   = :ldc_fr_out_price, 
					  @to_sale_type   = :ls_to_sale_type, 
					  @to_disc_rate   = :ldc_to_disc_rate, 
					  @to_margin_rate = :ldc_to_margin_rate,
					  @to_curr_price  = :ldc_to_curr_price, 
					  @to_out_price   = :ldc_to_out_price,  
					  @user_id        = :gs_user_id ;  
	
			EXECUTE SP_53011;
			
			if SQLCA.SQLCODE < 0  then
				ls_ErrMsg  = SQLCA.SQLErrText 
				il_rows    = -1 
				exit 
			end if 
	
		end if
		
NEXT

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
	MessageBox("저장오류", ls_ErrMsg)
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53011_e","0")
end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long   i 
String ls_out_no

if cbx_laser.checked then
	dw_print.DataObject = "d_com420_A1"
	dw_print.SetTransObject(SQLCA)
ELSE
	dw_print.DataObject = "d_com420"
	dw_print.SetTransObject(SQLCA)
END IF	



IF dw_body.AcceptText() <> 1 THEN RETURN 

	ls_out_no    = dw_head.GetitemString(1, "out_no")


	dw_print.Retrieve(is_brand, is_yymmdd, is_shop_cd, is_fr_shop_type, ls_out_no, '2')
	IF dw_print.RowCount() > 0 Then
		il_rows = dw_print.Print()
	END IF
	
	

   dw_print.Retrieve(is_brand, is_yymmdd, is_to_shop_cd, is_to_shop_type, ls_out_no, '1')
   IF dw_print.RowCount() > 0 Then
      il_rows = dw_print.Print()
   END IF


This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_53011_e
end type

type cb_delete from w_com010_e`cb_delete within w_53011_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_53011_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_53011_e
string text = "산출(&Q)"
end type

type cb_update from w_com010_e`cb_update within w_53011_e
end type

type cb_print from w_com010_e`cb_print within w_53011_e
integer x = 1861
integer width = 549
boolean enabled = true
string text = "거래명세서인쇄(&P)"
end type

type cb_preview from w_com010_e`cb_preview within w_53011_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_53011_e
end type

type cb_excel from w_com010_e`cb_excel within w_53011_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_53011_e
integer y = 160
integer height = 284
string dataobject = "d_53011_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("001")

This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("003", gs_brand, '%') 

This.GetChild("dep_seq", idw_dep_seq)
idw_dep_seq.SetTransObject(SQLCA)

This.GetChild("fr_shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("to_shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;String ls_brand, ls_year, ls_season 

CHOOSE CASE dwo.name
	CASE "dep_seq"
		  ls_brand   = This.GetitemString(1, "brand") 
		  ls_year    = This.GetitemString(1, "year") 
		  ls_season  = This.GetitemString(1, "season") 
        idw_dep_seq.Retrieve(ls_brand, ls_year, ls_season)
END CHOOSE

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.18                                                  */	
/* 수정일      : 2002.06.18                                                  */
/*===========================================================================*/
String ls_null, ls_yymmdd,  ls_year, ls_brand
SetNull(ls_null)
DataWindowChild ldw_child


CHOOSE CASE dwo.name
	CASE "yymmdd"      
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
   CASE  "season"
	This.Setitem(1, "dep_seq", ls_null)
		  
	CASE "brand"
		This.Setitem(1, "dep_seq", ls_null)
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
	
  CASE  "year"
		This.Setitem(1, "dep_seq", ls_null)
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")		
		
	CASE "shop_cd","to_shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_53011_e
integer beginy = 456
integer endy = 456
end type

type ln_2 from w_com010_e`ln_2 within w_53011_e
integer beginy = 460
integer endy = 460
end type

type dw_body from w_com010_e`dw_body within w_53011_e
integer height = 1544
string dataobject = "d_53011_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("fr_sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('011')

This.GetChild("to_sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('011')

end event

type dw_print from w_com010_e`dw_print within w_53011_e
string dataobject = "d_com420"
end type

type st_1 from statictext within w_53011_e
integer x = 411
integer y = 60
integer width = 1070
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "일자 시점 재고량으로 산출 합니다."
boolean focusrectangle = false
end type

type cbx_laser from checkbox within w_53011_e
integer x = 3040
integer y = 184
integer width = 507
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
string text = "명세서(laser)"
borderstyle borderstyle = stylelowered!
end type

