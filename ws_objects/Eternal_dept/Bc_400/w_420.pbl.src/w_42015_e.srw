$PBExportHeader$w_42015_e.srw
$PBExportComments$기타출고
forward
global type w_42015_e from w_com010_e
end type
type rb_1 from radiobutton within w_42015_e
end type
type rb_2 from radiobutton within w_42015_e
end type
type dw_1 from datawindow within w_42015_e
end type
type gb_1 from groupbox within w_42015_e
end type
end forward

global type w_42015_e from w_com010_e
integer width = 3685
integer height = 2232
rb_1 rb_1
rb_2 rb_2
dw_1 dw_1
gb_1 gb_1
end type
global w_42015_e w_42015_e

type variables
DatawindowChild  idw_brand, idw_color, idw_size 
String is_brand, is_house, is_yymmdd, is_jup_gubn, is_acc_gubn
String is_shop_cd, is_shop_type 

end variables

forward prototypes
public function boolean wf_style_chk (long al_row, string as_style_no)
public function boolean wf_margin_set (long al_row, string as_style)
public function boolean wf_margin_set_color (long al_row, string as_style, string as_color)
public function boolean wf_rtrn_set ()
end prototypes

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn  
Long   ll_tag_price 

IF LenA(Trim(as_style_no)) <> 9 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)

IF is_shop_type = '1' THEN 
	ls_plan_yn = 'N'
ELSEIF is_shop_type = '3' THEN 
	ls_plan_yn = 'Y'
ELSE
	ls_plan_yn = '%'
END IF


Select brand,     year,     season,     
       sojae,     item,     tag_price
  into :ls_brand, :ls_year, :ls_season, 
       :ls_sojae, :ls_item, :ll_tag_price
  from vi_12020_1 
 where style   =    :ls_style 
	and chno    =    :ls_chno
	and plan_yn like :ls_plan_yn;

IF SQLCA.SQLCODE <> 0 THEN 
	Return False 
END IF

dw_body.SetItem(al_row, "tag_price", ll_tag_price) 
IF wf_margin_set(al_row, ls_style) THEN
	dw_body.SetItem(al_row, "style_no",  as_style_no)
	dw_body.SetItem(al_row, "style",     ls_style)
	dw_body.SetItem(al_row, "chno",      ls_chno)
	dw_body.SetItem(al_row, "brand",     ls_brand)
	dw_body.SetItem(al_row, "year",      ls_year)
	dw_body.SetItem(al_row, "season",    ls_season)
	dw_body.SetItem(al_row, "sojae",     ls_sojae)
	dw_body.SetItem(al_row, "item",      ls_item) 
END IF

Return True

end function

public function boolean wf_margin_set (long al_row, string as_style);Long    ll_qty      
Long    ll_tag_price, ll_curr_price,  ll_out_price
String  ls_null,       ls_sale_type = space(2)
decimal ldc_marjin, ldc_dc_rate

IF is_jup_gubn = '02' and LenA(is_shop_cd) = 6 THEN 
	/* 매장 반품시 마진율 체크 */
	IF gf_out_marjin (is_yymmdd,    is_shop_cd, is_shop_type, as_style, & 
							ls_sale_type, ldc_marjin, ldc_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
		RETURN False 
	END IF
	/* 단가 및 율 등록 */
	dw_body.Setitem(al_row, "sale_type",   ls_sale_type)
	dw_body.Setitem(al_row, "curr_price",  ll_curr_price)
	dw_body.Setitem(al_row, "disc_rate",   ldc_dc_rate)
	dw_body.Setitem(al_row, "margin_rate", ldc_marjin)
	dw_body.Setitem(al_row, "out_price",   ll_out_price)
END IF

ll_tag_price = dw_body.GetitemNumber(al_row, "tag_price")
ll_qty       = dw_body.GetitemNumber(al_row, "qty")
IF isnull(ll_qty) THEN ll_qty = 1
SetNull(ls_null)

dw_body.Setitem(al_row, "color", ls_null)
dw_body.Setitem(al_row, "size",  ls_null)
dw_body.Setitem(al_row, "qty",   ll_qty)
dw_body.Setitem(al_row, "amt",   ll_qty * ll_tag_price)

RETURN True
end function

public function boolean wf_margin_set_color (long al_row, string as_style, string as_color);Long    ll_qty      
Long    ll_tag_price, ll_curr_price,  ll_out_price
String  ls_null,       ls_sale_type = space(2)
decimal ldc_marjin, ldc_dc_rate

IF is_jup_gubn = '02' and LenA(is_shop_cd) = 6 THEN 
	/* 매장 반품시 마진율 체크 */
	IF gf_outmarjin_color (is_yymmdd,    is_shop_cd, is_shop_type, as_style, as_color,& 
							ls_sale_type, ldc_marjin, ldc_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
		RETURN False 
	END IF
	/* 단가 및 율 등록 */
	dw_body.Setitem(al_row, "sale_type",   ls_sale_type)
	dw_body.Setitem(al_row, "curr_price",  ll_curr_price)
	dw_body.Setitem(al_row, "disc_rate",   ldc_dc_rate)
	dw_body.Setitem(al_row, "margin_rate", ldc_marjin)
	dw_body.Setitem(al_row, "out_price",   ll_out_price)
END IF

ll_tag_price = dw_body.GetitemNumber(al_row, "tag_price")
ll_qty       = dw_body.GetitemNumber(al_row, "qty")
IF isnull(ll_qty) THEN ll_qty = 1
SetNull(ls_null)


dw_body.Setitem(al_row, "size",  ls_null)
dw_body.Setitem(al_row, "qty",   ll_qty)
dw_body.Setitem(al_row, "amt",   ll_qty * ll_tag_price)

RETURN True
end function

public function boolean wf_rtrn_set ();Long    i 
Decimal ldc_qty, ldc_tag_price, ldc_curr_price, ldc_out_price 

dw_1.Reset()
FOR i=1 TO dw_body.RowCount()
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	dw_1.insertRow(0)
	IF idw_status = New! THEN CONTINUE
	dw_1.Object.yymmdd[i]      = is_yymmdd
   dw_1.Object.shop_cd[i]     = is_shop_cd
   dw_1.Object.shop_type[i]   = is_shop_type
   dw_1.Object.house_cd[i]    = is_house
	dw_1.Object.jup_gubn[i]    = 'O1'
	dw_1.Object.sale_type[i]   = dw_body.Object.sale_type[i]  
	dw_1.Setitem(i, "margin_rate", dw_body.GetitemDecimal(i, "margin_rate"))
	dw_1.Setitem(i, "disc_Rate",   dw_body.GetitemDecimal(i, "disc_Rate"))
   dw_1.Object.no[i]          = String(i, "0000")
	dw_1.Object.style[i]       = dw_body.Object.style[i]
   dw_1.Object.chno[i]        = dw_body.Object.chno[i]
	dw_1.Object.color[i]       = dw_body.Object.color[i]
   dw_1.Object.size[i]        = dw_body.Object.size[i]
	dw_1.Object.class[i]       = 'A' 
	ldc_tag_price  = dw_body.GetitemDecimal(i, "tag_price")
	ldc_curr_price = dw_body.GetitemDecimal(i, "curr_price")
	ldc_out_price  = dw_body.GetitemDecimal(i, "out_price")
	ldc_qty        = dw_body.GetitemDecimal(i, "qty")
	dw_1.Setitem(i, "tag_price",    ldc_tag_price)
	dw_1.Setitem(i, "curr_price",   ldc_curr_price)
	dw_1.Setitem(i, "out_price",    ldc_out_price)
	dw_1.Setitem(i, "qty",          ldc_qty)
	dw_1.Setitem(i, "tag_amt",      ldc_qty * ldc_tag_price)
	dw_1.Setitem(i, "curr_amt",     ldc_qty * ldc_curr_price)
	dw_1.Setitem(i, "rtrn_collect", ldc_qty * ldc_out_price)
	dw_1.Setitem(i, "vat",          (ldc_qty * ldc_out_price) - Round(ldc_qty * ldc_out_price / 1.1, 0))
   dw_1.Object.brand[i]       = dw_body.Object.brand[i]  
	dw_1.Object.year[i]        = dw_body.Object.year[i]   
   dw_1.Object.season[i]      = dw_body.Object.season[i] 
	dw_1.Object.item[i]        = dw_body.Object.item[i]   
   dw_1.Object.sojae[i]       = dw_body.Object.sojae[i]  
	dw_1.Setitem(i, "note", dw_body.GetitemString(i, "remark"))	
	dw_1.Setitem(i, "reg_id", dw_body.GetitemString(i, "reg_id"))
	dw_1.Setitem(i, "reg_dt", dw_body.GetitemDateTime(i, "reg_dt"))
   dw_1.SetItemStatus(i, 0, Primary!, idw_status)
NEXT

Return True
end function

on w_42015_e.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_1=create dw_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_42015_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_style, ls_chno
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm3(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV  IN ('G', 'K', 'T','I')  " + &
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
			IF ai_div = 1 THEN 	
				IF wf_style_chk(al_row, as_data)  THEN 
					RETURN 0 
				END IF 
			END IF
			IF al_row > 1 THEN 
				gf_style_edit(dw_body.object.style_no[al_row -1], as_data, ls_style, ls_chno)
			ELSE
		      ls_style = MidA(as_data, 1, 8)
		      ls_chno  = MidA(as_data, 9, 1) 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "WHERE brand = '" + is_brand + "' "
			IF is_shop_type = '1' THEN 
				gst_cd.default_where   = gst_cd.default_where + "AND plan_yn = 'N'"
			ELSEIF is_shop_type = '3' THEN
				gst_cd.default_where   = gst_cd.default_where + "AND plan_yn = 'Y'"
			END IF
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" + &
				                " and chno  LIKE '" + ls_chno  + "%'" 
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
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "tag_price", lds_Source.GetItemNumber(1,"tag_price")) 
				ls_style = lds_Source.GetItemString(1,"style")
 				IF wf_margin_set(al_row, ls_style) THEN 
				   dw_body.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
				   dw_body.SetItem(al_row, "style",    lds_Source.GetItemString(1,"style"))
				   dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand"))
				   dw_body.SetItem(al_row, "year",     lds_Source.GetItemString(1,"year"))
				   dw_body.SetItem(al_row, "season",   lds_Source.GetItemString(1,"season"))
				   dw_body.SetItem(al_row, "sojae",    lds_Source.GetItemString(1,"sojae"))
				   dw_body.SetItem(al_row, "item",     lds_Source.GetItemString(1,"item"))
				   ib_changed = true
               cb_update.enabled = true
				   /* 다음컬럼으로 이동 */
			      dw_body.SetColumn("color")
			      lb_check = TRUE 
				END IF
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

event open;call super::open;is_jup_gubn = '02'
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.16                                                  */	
/* 수정일      : 2002.03.16                                                  */
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

is_house = dw_head.GetItemString(1, "house")
if IsNull(is_house) or Trim(is_house) = "" then
   MessageBox(ls_title,"창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

is_acc_gubn = dw_head.GetItemString(1, "acc_gubn")
IF is_jup_gubn = '02' THEN
	if IsNull(is_acc_gubn) or Trim(is_acc_gubn) = "" then
		MessageBox(ls_title,"회계구분 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("acc_gubn")
		return false
	end if
END IF

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
is_shop_type = dw_head.GetItemString(1, "shop_type")
if LenA(is_shop_cd) = 6 and  (IsNull(is_shop_type) or Trim(is_shop_type) = "") then
   MessageBox(ls_title,"매장형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.16                                                  */	
/* 수정일      : 2002.03.16                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//il_rows = dw_body.retrieve()
dw_body.Reset()
dw_head.Setitem(1, "out_no", "")
il_rows = dw_body.insertRow(0)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         rb_1.Enabled = false
         rb_2.Enabled = false
      end if
   CASE 5    /* 조건 */
      cb_retrieve.Text = "입력(&Q)"
      rb_1.Enabled = true
      rb_2.Enabled = true 
END CHOOSE

end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.16                                                 */	
/* 수정일      : 2002.03.16                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_row
datetime ld_datetime
String   ls_out_no ,ls_rtrn_no

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

IF is_jup_gubn = '02' and LenA(is_shop_cd) = 6 THEN
   IF wf_rtrn_set() = FALSE THEN Return 0 
END IF

//IF gf_style_outno (is_yymmdd, is_brand, ls_out_no ) = FALSE THEN
//	RETURN -1 
//END IF
//

	select  substring(convert(varchar(5), convert(decimal(5), isnull(max(out_no), '0000')) + 10001), 2, 4) 
	into :ls_out_no
	from tb_42010_h with (nolock)
	where yymmdd = :is_yymmdd
	and house_cd  = :is_house;
	
	IF gf_style_outno(is_yymmdd, is_brand, ls_rtrn_no) = FALSE THEN 
		Return -1 
	END IF	
		


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "yymmdd",    is_yymmdd)
      dw_body.Setitem(i, "house_cd",  is_house)
      dw_body.Setitem(i, "out_no",    ls_out_no)
      dw_body.Setitem(i, "no",        String(i, "0000"))
      dw_body.Setitem(i, "jup_gubn",  is_jup_gubn)
      dw_body.Setitem(i, "acc_gubn",  is_acc_gubn) 
      dw_body.Setitem(i, "shop_cd",   is_shop_cd)
      dw_body.Setitem(i, "shop_type", is_shop_type)
		IF is_jup_gubn = '02' and LenA(is_shop_cd) = 6 THEN
         dw_1.Setitem(i, "out_no", ls_rtrn_no)
		   dw_1.Setitem(i, "reg_id",    gs_user_id)			
	   END IF
      dw_body.Setitem(i, "reg_id", gs_user_id)
     
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)

		IF is_jup_gubn = '02' and LenA(is_shop_cd) = 6 THEN
			dw_1.Setitem(i, "mod_id", gs_user_id)
			dw_1.Setitem(i, "mod_dt", ld_datetime)
	   END IF

   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)
IF il_rows = 1 THEN
   il_rows = dw_1.Update(TRUE, FALSE)
END IF

if il_rows = 1 then
   dw_body.ResetUpdate()
   dw_1.ResetUpdate()
   commit  USING SQLCA; 
	dw_head.Setitem(1, "out_no", ls_out_no)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42015_e","0")
end event

type cb_close from w_com010_e`cb_close within w_42015_e
end type

type cb_delete from w_com010_e`cb_delete within w_42015_e
end type

type cb_insert from w_com010_e`cb_insert within w_42015_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_42015_e
string text = "입력(&Q)"
end type

type cb_update from w_com010_e`cb_update within w_42015_e
end type

type cb_print from w_com010_e`cb_print within w_42015_e
end type

type cb_preview from w_com010_e`cb_preview within w_42015_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_42015_e
end type

type cb_excel from w_com010_e`cb_excel within w_42015_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_42015_e
integer x = 503
integer width = 3054
string dataobject = "d_42015_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("house", ldw_child) 
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve()

This.GetChild("brand", idw_brand) 
idw_brand.SetTransObject(sqlca)
idw_brand.Retrieve('001')
  
This.GetChild("acc_gubn", ldw_child) 
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('027')

This.GetChild("shop_type", ldw_child) 
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('911')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.16                                                  */	
/* 수정일      : 2002.03.16                                                  */
/*===========================================================================*/
String ls_yymmdd

CHOOSE CASE dwo.name
	CASE "yymmdd"      
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_42015_e
integer beginy = 428
integer endy = 428
end type

type ln_2 from w_com010_e`ln_2 within w_42015_e
integer beginy = 432
integer endy = 432
end type

type dw_body from w_com010_e`dw_body within w_42015_e
integer x = 14
integer y = 452
integer width = 3579
integer height = 1548
string dataobject = "d_42015_d01"
end type

event dw_body::constructor;call super::constructor;This.GetChild("color", idw_color)
idw_color.SetTransobject(sqlca)
idw_color.insertRow(0)

This.GetChild("size", idw_size)
idw_size.SetTransobject(sqlca)
idw_size.insertRow(0)


end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
Long   ll_tag_price 
String ls_null, ls_style
Setnull(ls_null) 

CHOOSE CASE dwo.name
	CASE "style_no"	
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "color"	
		ls_style = This.GetitemString(row, "style")
		wf_margin_set_color(row, ls_style, data)
				
		
		This.Setitem(row, "size", ls_null)
	CASE "qty"	
		ll_tag_price = This.GetitemNumber(row, "tag_price")
		This.Setitem(row, "amt", ll_tag_price * Long(data))
END CHOOSE

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;String ls_style, ls_chno, ls_color

CHOOSE CASE dwo.name
	CASE "color" 
		ls_style = This.GetitemString(row, "style")
		ls_chno  = This.GetitemString(row, "chno")
		idw_color.Retrieve(ls_style, ls_chno)
	CASE "size"
		ls_style = This.GetitemString(row, "style")
		ls_chno  = This.GetitemString(row, "chno")
		ls_color = This.GetitemString(row, "color")
		idw_size.Retrieve(ls_style, ls_chno, ls_color)
END CHOOSE

end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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
		IF ls_column_name = "remark" THEN 
			IF This.GetRow() = This.RowCount() THEN
 			   Parent.Post Event ue_insert()
		   END IF
		END IF
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
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
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_42015_e
end type

type rb_1 from radiobutton within w_42015_e
integer x = 91
integer y = 224
integer width = 334
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
string text = "회계처리"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = Rgb(0,0,255) 
rb_2.TextColor = Rgb(0,0,0)

is_jup_gubn = '02'
dw_head.Modify("acc_gubn.Protect=0")
dw_head.Modify("acc_gubn.Background.Mode=0")

end event

type rb_2 from radiobutton within w_42015_e
integer x = 91
integer y = 300
integer width = 366
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
string text = "차용"
borderstyle borderstyle = stylelowered!
end type

event clicked;String ls_null
Setnull(ls_null)

This.TextColor = Rgb(0,0,255) 
rb_1.TextColor = Rgb(0,0,0)

is_jup_gubn = '01'
dw_head.Setitem(1, "acc_gubn", ls_null)
dw_head.Modify("acc_gubn.Protect=1")
dw_head.Modify("acc_gubn.Background.Mode=1")

end event

type dw_1 from datawindow within w_42015_e
boolean visible = false
integer x = 2473
integer y = 756
integer width = 1170
integer height = 432
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_42015_d02"
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 2627
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 515
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

MessageBox(parent.title + "(dw_1)", ls_message_string)
return 1
end event

type gb_1 from groupbox within w_42015_e
integer x = 32
integer y = 156
integer width = 443
integer height = 252
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

