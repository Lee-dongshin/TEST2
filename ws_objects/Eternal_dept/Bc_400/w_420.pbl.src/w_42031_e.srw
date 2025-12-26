$PBExportHeader$w_42031_e.srw
$PBExportComments$수주출고등록
forward
global type w_42031_e from w_com010_e
end type
type cb_input from commandbutton within w_42031_e
end type
type cb_copy from commandbutton within w_42031_e
end type
type dw_list from datawindow within w_42031_e
end type
type cb_move from commandbutton within w_42031_e
end type
end forward

global type w_42031_e from w_com010_e
integer width = 3689
integer height = 2288
event ue_input ( )
cb_input cb_input
cb_copy cb_copy
dw_list dw_list
cb_move cb_move
end type
global w_42031_e w_42031_e

type variables
DataWindowChild    idw_brand, idw_color,   idw_size
String is_house,   is_brand,    is_yymmdd, is_out_no
String is_shop_cd, is_shop_type 

end variables

forward prototypes
public function boolean wf_margin_set (long al_row, string as_style)
public function boolean wf_style_chk (long al_row, string as_style_no)
public subroutine wf_amt_set (long al_row, long al_qty, long al_curr_price)
end prototypes

event ue_input();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
dw_list.Visible   = False
dw_body.Visible   = True

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
if is_shop_type = "%" then
   MessageBox("입력","정확한 매장형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   Return 
end if

if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox("입력","매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return 
end if


if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox("입력","브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return 
end if


if is_shop_cd <> "OT3535" THEN 
	IF is_shop_cd <> "OX4998" then 
	    if is_shop_cd <> "NT3531" THEN 
			 IF is_shop_cd <> "NX4998"  then
				 IF is_shop_cd <> "OT3532"  then
					if is_brand <> LeftA(is_shop_cd,1) then
						MessageBox("경고","매장 코드와 브랜드를 확인 하십시요!")
						return 
					end if
				end if
			 END IF
		 END IF	
	end if	
end if

dw_body.Reset()
il_rows = dw_body.insertRow(0)

IF il_rows > 0 THEN
	dw_head.Setitem(1, "out_no", '')
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(6, il_rows)

end event

public function boolean wf_margin_set (long al_row, string as_style);Long    ll_qty,         ll_tag_price,   ll_curr_price,  ll_out_price
String  ls_null,        ls_sale_type = space(2)
decimal ldc_marjin,     ldc_dc_rate
SetNull(ls_null) 

ldc_dc_rate = dw_body.GetitemDecimal(al_row - 1, "disc_rate")
/* 출고시 마진율 체크 */
IF al_row > 1 AND is_shop_type > '3' AND ldc_dc_rate <> 0 THEN
	ls_sale_type  = dw_body.Object.sale_type[al_row - 1]
	ldc_marjin    = dw_body.Object.margin_rate[al_row - 1]
	ll_tag_price  = dw_body.GetitemNumber(al_row, "tag_price")
	ll_curr_price = ll_tag_price * (100 - ldc_dc_rate) / 100
	gf_marjin_price (is_shop_cd, ll_curr_price, ldc_marjin, ll_out_price)
ELSE
	IF gf_outmarjin (is_yymmdd,    is_shop_cd, is_shop_type, as_style, & 
						  ls_sale_type, ldc_marjin, ldc_dc_rate,  ll_curr_price, ll_out_price) = FALSE THEN 
		RETURN False 
	END IF
END IF 

IF al_row > 1 THEN 
	IF dw_body.Object.sale_type[1]   <> ls_sale_type OR &
	   dw_body.Object.margin_rate[1] <> ldc_marjin   THEN 
		MessageBox("확인요망", "마진율이 다른 형태 입니다.")
		Return False
	END IF
END IF 
/*색상 및 사이즈 클리어 */
dw_body.Setitem(al_row, "color", ls_null)
dw_body.Setitem(al_row, "size",  ls_null)
ll_qty = dw_body.GetitemNumber(al_row, "qty") 
IF isnull(ll_qty) THEN ll_qty = 1

/* 단가 및 율 등록 */
dw_body.Setitem(al_row, "sale_type",   ls_sale_type)
dw_body.Setitem(al_row, "qty",         ll_qty)
dw_body.Setitem(al_row, "curr_price",  ll_curr_price)
dw_body.Setitem(al_row, "disc_rate",   ldc_dc_rate)
dw_body.Setitem(al_row, "margin_rate", ldc_marjin)
dw_body.Setitem(al_row, "out_price",   ll_out_price)

/* 금액 처리 */
wf_amt_set(al_row, ll_qty, ll_curr_price)

RETURN True
end function

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.05.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_null
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn , ls_brand2
Long   ll_tag_price,  ll_cnt 
SetNull(ls_null)

ls_brand2 = dw_head.getitemstring(1, "brand")

IF al_row > 1 and LenA(as_style_no) <> 9 THEN
	gf_style_edit(dw_body.Object.style_no[al_row - 1], as_style_no, ls_style, ls_chno) 
   IF ls_chno = '%' THEN ls_chno = '0' 
ELSE 
	ls_style = LeftA(as_style_no, 8)
	ls_chno  = MidA(as_style_no, 9, 1)
END IF 

IF MidA(is_shop_cd, 2, 1) = 'X' OR MidA(is_shop_cd, 2, 1) = 'T' THEN 
	ls_plan_yn = '%'
ELSEIF is_shop_type = '1' THEN 
	ls_plan_yn = 'N'
ELSEIF is_shop_type = '3' THEN 
	ls_plan_yn = 'Y'
ELSE
	ls_plan_yn = '%'
END IF

Select count(style), 
       max(style)  ,   max(chno), 
       max(brand)  ,   max(year),     max(season),     
       max(sojae)  ,   max(item),     max(tag_price)  
  into :ll_cnt     , 
       :ls_style   ,   :ls_chno, 
       :ls_brand   ,   :ls_year,      :ls_season, 
		 :ls_sojae   ,   :ls_item,      :ll_tag_price
  from vi_12020_1 with (nolock) 
 where style   like :ls_style 
	and chno    =    :ls_chno
	and plan_yn like :ls_plan_yn
	and brand   = 	  :ls_brand2
	and isnull(tag_price, 0) <> 0;
	
IF SQLCA.SQLCODE <> 0 or ll_cnt <> 1 THEN 
	Return False 
END IF 


dw_body.SetItem(al_row, "tag_price", ll_tag_price) 
IF wf_margin_set(al_row, ls_style) THEN 
   dw_body.SetItem(al_row, "style_no", ls_style + ls_chno)
   dw_body.SetItem(al_row, "style",    ls_style)
	dw_body.SetItem(al_row, "chno",     ls_chno)
	dw_body.SetItem(al_row, "brand",    ls_brand)
	dw_body.SetItem(al_row, "year",     ls_year)
	dw_body.SetItem(al_row, "season",   ls_season)
	dw_body.SetItem(al_row, "sojae",    ls_sojae)
	dw_body.SetItem(al_row, "item",     ls_item)
END IF

//IF Mid(is_shop_cd, 2, 1) = 'X' OR Mid(is_shop_cd, 2, 1) = 'T' OR 
if (is_brand = "N" OR is_brand = 'O') and is_shop_type > '3' and ( is_shop_cd <> "NT3516" OR IS_SHOP_CD <> "NT3533") THEN
	dw_body.SetItem(al_row, "color",    'XX')
	dw_body.SetItem(al_row, "size",     'XX')
ELSEIF is_shop_cd = "OX3536" OR 	is_shop_cd = "NX3536" THEN
	dw_body.SetItem(al_row, "color",    'XX')
	dw_body.SetItem(al_row, "size",     'XX')	
ELSEIF (is_brand = "J" OR is_brand = 'Y') and is_shop_type > '3' THEN
	ls_color = dw_body.GetitemString(al_row - 1, "color")
	select count(color)
	  into :ll_cnt  
	  from tb_12024_d with (nolock)
	 where style = :ls_style 
	   and chno  = :ls_chno 
		and color = :ls_color ;
   IF ll_cnt > 0 THEN
      dw_body.SetItem(al_row, "color", ls_color)
	ELSE
      dw_body.SetItem(al_row, "color",    '')
	END IF
	dw_body.SetItem(al_row, "size", ls_null)
	
ELSE
	ls_color = dw_body.GetitemString(al_row - 1, "color")
	select count(color)
	  into :ll_cnt  
	  from tb_12024_d with (nolock)
	 where style = :ls_style 
	   and chno  = :ls_chno 
		and color = :ls_color ;
   IF ll_cnt > 0 THEN
      dw_body.SetItem(al_row, "color", ls_color)
	ELSE
      dw_body.SetItem(al_row, "color",    '')
	END IF
	dw_body.SetItem(al_row, "size", ls_null)
	
END IF 

Return True

end function

public subroutine wf_amt_set (long al_row, long al_qty, long al_curr_price);/* 각 단가 및 출고량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_out_price
Decimal ldc_out_amt 
Decimal ldc_marjin

ll_tag_price  = dw_body.GetitemDecimal(al_row, "tag_price") 
ll_out_price  = dw_body.GetitemNumber(al_row, "out_price") 
ldc_out_amt   = dec(ll_out_price) * al_qty   

dw_body.Setitem(al_row, "tag_amt",     dec(ll_tag_price)  * al_qty)
dw_body.Setitem(al_row, "curr_amt",    dec(al_curr_price) * al_qty)
dw_body.Setitem(al_row, "out_collect", ldc_out_amt) 
dw_body.Setitem(al_row, "vat", ldc_out_amt - Round(ldc_out_amt / 1.1, 0))


end subroutine

on w_42031_e.create
int iCurrent
call super::create
this.cb_input=create cb_input
this.cb_copy=create cb_copy
this.dw_list=create dw_list
this.cb_move=create cb_move
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_input
this.Control[iCurrent+2]=this.cb_copy
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.cb_move
end on

on w_42031_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_input)
destroy(this.cb_copy)
destroy(this.dw_list)
destroy(this.cb_move)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
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

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")
is_out_no = dw_head.GetitemString(1, "out_no")

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

return true 
end event

event open;call super::open;dw_head.Setitem(1, "shop_type", '1')
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/
String ls_shop_nm

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(This.title)
		CASE 1
			IF This.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			dw_body.SetFocus()
			RETURN
	END CHOOSE
END IF

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

IF isnull(is_out_no) or Trim(is_out_no) = "" THEN 
	is_out_no = '%'
END IF

IF isnull(is_shop_cd) or Trim(is_shop_cd) = "" THEN 
	is_shop_cd = '%'
END IF
IF is_out_no = '%' and is_shop_cd = '%' THEN 
	MessageBox("조회", "매장코드 나 전표번호를 입력하십시오 !")
	dw_head.SetFocus()
	RETURN
END IF 

il_rows = dw_list.retrieve(is_yymmdd, is_shop_cd, is_shop_type, is_out_no, is_house, is_brand)

IF il_rows >= 0 THEN
	is_shop_cd = dw_list.GetitemString(1, "shop_cd")
	gf_shop_nm(is_shop_cd, 'S', ls_shop_nm) 
   dw_head.SetItem(1, "shop_cd", is_shop_cd)
   dw_head.SetItem(1, "shop_nm", ls_shop_nm)
	dw_list.Visible = True
	dw_body.Visible = False
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 6 - 입력  */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows >= 0 then
         cb_print.enabled   = true
         cb_preview.enabled = true
         cb_excel.enabled   = true
			
			if dw_list.visible = false then 
				cb_insert.enabled  = true
				cb_delete.enabled  = true
	         cb_move.enabled    = TRUE
			else	
				cb_insert.enabled  = false
				cb_delete.enabled  = false
	         cb_move.enabled    = false					
			end if				
			
		
         cb_update.enabled  = false
    //     cb_copy.enabled    = false
         cb_input.Text      = "등록(&I)"
         dw_head.enabled    = true 
         dw_body.enabled    = true
         ib_changed         = false
      end if
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled  = true
			cb_print.enabled   = false
			cb_preview.enabled = false
			cb_excel.enabled   = false
		end if
		if dw_head.Enabled then
         cb_input.Text = "조건(&I)"
			dw_head.Enabled = false
		end if
	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed         = false
			cb_print.enabled   = true
			cb_preview.enabled = true
			cb_excel.enabled   = true
			cb_delete.enabled  = false
         cb_move.enabled    = true			
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_input.Text = "등록(&I)"
      cb_insert.enabled  = false
      cb_delete.enabled  = false
      cb_print.enabled   = false
      cb_preview.enabled = false
      cb_excel.enabled   = false
      cb_update.enabled  = false 
		IF dw_body.RowCount() > 0 THEN 
		   IF dw_body.GetItemStatus(1, 0, Primary!) <> New! THEN 
				cb_copy.enabled  = true 
			END IF
		END IF
      ib_changed         = false
      dw_body.Enabled    = false
      dw_head.Enabled    = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 6		/* 입력 */
      if al_rows > 0 then
         cb_insert.enabled  = true
         cb_delete.enabled  = true
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
         cb_copy.Enabled    = false
         dw_head.Enabled    = false
         dw_body.Enabled    = true
         dw_body.SetFocus()
         ib_changed = false
         cb_update.enabled = false
         cb_input.Text = "조건(&I)"
      else
         cb_insert.enabled  = false
         cb_delete.enabled  = false
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
      end if

END CHOOSE

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(cb_input,   "FixedToRight")
inv_resize.of_Register(dw_list,   "ScaleToRight&Bottom")

dw_list.SetTransObject(SQLCA)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND (SHOP_DIV  IN ('G', 'K', 'T') or shop_cd like '__499_')" + &
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
					RETURN 2 
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
			gst_cd.datawindow_nm   = "d_com013" 
			gst_cd.default_where   = "WHERE brand = '" + is_brand + "' " + & 
			                         "  AND isnull(tag_price, 0) <> 0 "
         IF MidA(is_shop_cd, 2, 1) = 'X' OR MidA(is_shop_cd, 2, 1) = 'T' THEN 
			ELSEIF is_shop_type = '1' THEN 
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
				
				select isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX')
				into :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq
				from tb_12020_m with (nolock)
				where style = :ls_style;
				
				if ls_bujin_chk = "Y" then 
					messagebox("부진체크", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
            end if 	
				
 				IF wf_margin_set(al_row, ls_style) THEN 
				   dw_body.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
				   dw_body.SetItem(al_row, "style",    lds_Source.GetItemString(1,"style"))
				   dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand"))
				   dw_body.SetItem(al_row, "year",     lds_Source.GetItemString(1,"year"))
				   dw_body.SetItem(al_row, "season",   lds_Source.GetItemString(1,"season"))
				   dw_body.SetItem(al_row, "sojae",    lds_Source.GetItemString(1,"sojae"))
				   dw_body.SetItem(al_row, "item",     lds_Source.GetItemString(1,"item"))
				   dw_body.SetItem(al_row, "color",    lds_Source.GetItemString(1,"color"))
				   dw_body.SetItem(al_row, "size",     lds_Source.GetItemString(1,"size"))
				   ib_changed = true
               cb_update.enabled = true
				   /* 다음컬럼으로 이동 */
		         dw_body.SetColumn("qty")
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

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/
long i, ll_row_count, il_no
datetime ld_datetime


ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF
/* 출고전표 채번 */
idw_status = dw_body.GetItemStatus(1, 0, Primary!)
IF idw_status = DataModified! OR idw_status = NotModified!	THEN
	is_out_no = dw_body.GetitemString(1, "out_no")
	
	sELECT convert(decimal, max(isnull(no,0)))
	into :il_no
	from tb_42020_h
	where yymmdd 		= :is_yymmdd
	and   shop_cd 		= :is_shop_cd
	and   shop_type 	= :is_shop_type
	and   out_no 		= :is_out_no;
	
ELSEIF gf_style_outno(is_yymmdd, is_brand, is_out_no) = FALSE THEN 
	Return -1 
END IF


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
		il_no = il_no + 1
      dw_body.Setitem(i, "yymmdd",    is_yymmdd)
      dw_body.Setitem(i, "shop_cd",   is_shop_cd)
      dw_body.Setitem(i, "shop_type", is_shop_type)
      dw_body.Setitem(i, "out_no",    is_out_no)
      dw_body.Setitem(i, "no",        String(il_no, "0000"))
      dw_body.Setitem(i, "house_cd",  is_house)
      dw_body.Setitem(i, "jup_gubn",  'O1')
      dw_body.Setitem(i, "out_type",  'A') 
		IF is_house = '450000' or is_house = '020000' THEN
         dw_body.Setitem(i, "class",  'B')  /* 불량창고 -> B급 */
		ELSE
         dw_body.Setitem(i, "class",  'A')
		END IF
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
	dw_head.Setitem(1, "out_no", is_out_no)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long   i 
String ls_shop_type, ls_out_no

IF dw_list.Visible THEN
   FOR i = 1 TO dw_list.RowCount() 
      IF ls_out_no <> dw_list.object.out_no[i] OR ls_shop_type <> dw_list.object.shop_type[i] THEN 
         ls_out_no    = dw_list.GetitemString(i, "out_no")
         ls_shop_type = dw_list.GetitemString(i, "shop_type")
         dw_print.Retrieve(is_brand, is_yymmdd, is_shop_cd, ls_shop_type, ls_out_no, '1')
         IF dw_print.RowCount() > 0 Then
            il_rows = dw_print.Print()
         END IF
		END IF 	
	NEXT 
ELSE 
   ls_out_no    = dw_body.GetitemString(1, "out_no")
   ls_shop_type = dw_body.GetitemString(1, "shop_type")
   dw_print.Retrieve(is_brand, is_yymmdd, is_shop_cd, ls_shop_type, ls_out_no, '1')
   IF dw_print.RowCount() > 0 Then
      il_rows = dw_print.Print()
   END IF
END IF

This.Trigger Event ue_msg(6, il_rows)

end event

event ue_delete;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04																  */	
/* 수정일      : 2002.03.04																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

//IF idw_status = NotModified! OR idw_status = DataModified! THEN
//	RETURN 
//END IF 

il_rows = dw_body.DeleteRow (ll_cur_row)
dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
   if is_shop_type = "%" then
      MessageBox("입력","정확한 매장형태 코드를 입력하십시요!")
      dw_head.SetFocus()
      dw_head.SetColumn("shop_type")
      Return 
   end if
   if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
      MessageBox("입력","매장 코드를 입력하십시요!")
      dw_head.SetFocus()
      dw_head.SetColumn("shop_cd")
      return 
   end if
	IF dw_body.RowCount() > 0 THEN 
		IF is_shop_cd   <> dw_body.Object.shop_cd[1] OR &
		   is_yymmdd    <> dw_body.Object.yymmdd[1] OR & 
     		is_shop_type <> dw_body.Object.shop_type[1]   THEN
         MessageBox("추가","매장 및 일자가 틀려 추가할수 없습니다!")
			Return
		END IF
	END IF
END IF

il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.enabled = True
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42031_e","0")
end event

type cb_close from w_com010_e`cb_close within w_42031_e
integer taborder = 110
end type

type cb_delete from w_com010_e`cb_delete within w_42031_e
integer x = 1577
integer taborder = 60
end type

type cb_insert from w_com010_e`cb_insert within w_42031_e
integer x = 1234
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_42031_e
integer taborder = 120
end type

event cb_retrieve::clicked;/*===========================================================================*/
/* 작성자      : 김 태범      															  */	
/* 작성일      : 2002.03.04																  */	
/* 수정일      : 2002.03.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

Parent.Trigger Event ue_retrieve()	//조회

SetPointer(oldpointer)
This.Enabled = True

end event

type cb_update from w_com010_e`cb_update within w_42031_e
integer taborder = 100
end type

type cb_print from w_com010_e`cb_print within w_42031_e
integer x = 1920
integer width = 549
integer taborder = 70
string text = "거래명세서인쇄(&P)"
end type

type cb_preview from w_com010_e`cb_preview within w_42031_e
boolean visible = false
integer x = 1303
integer y = 36
integer taborder = 80
end type

type gb_button from w_com010_e`gb_button within w_42031_e
end type

type cb_excel from w_com010_e`cb_excel within w_42031_e
boolean visible = false
integer x = 1486
integer y = 28
integer taborder = 90
end type

type dw_head from w_com010_e`dw_head within w_42031_e
integer height = 240
string dataobject = "d_42031_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("house", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", '%')
ldw_child.Setitem(1, "inter_nm", "전체")

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)                                       */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
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

type ln_1 from w_com010_e`ln_1 within w_42031_e
integer beginy = 416
integer endy = 416
end type

type ln_2 from w_com010_e`ln_2 within w_42031_e
integer beginy = 420
integer endy = 420
end type

type dw_body from w_com010_e`dw_body within w_42031_e
event ue_set_col ( string as_column )
integer y = 440
integer width = 3607
integer height = 1612
string dataobject = "d_42031_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::ue_set_col(string as_column);This.SetColumn(as_column)
end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.insertRow(0)

This.GetChild("size", idw_size)
idw_size.SetTransObject(SQLCA)
idw_size.insertRow(0)


end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;String ls_style, ls_chno, ls_color

CHOOSE CASE dwo.name
	CASE "color" 
		ls_style = This.GetitemString(row, "style")
		ls_chno  = This.GetitemString(row, "chno")
		idw_color.Retrieve(ls_style, ls_chno)
		idw_color.insertRow(1)
		idw_color.Setitem(1, "color", "XX")
		idw_color.Setitem(1, "color_enm", "XX")
	CASE "size"
		ls_style = This.GetitemString(row, "style")
		ls_chno  = This.GetitemString(row, "chno")
		ls_color = This.GetitemString(row, "color")
		idw_size.Retrieve(ls_style, ls_chno, ls_color)
		idw_size.insertRow(1)
		idw_size.Setitem(1, "size", "XX")
		idw_size.Setitem(1, "size_nm", "XX")
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
		IF ls_column_name = "qty" THEN 
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

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
Long    ll_ret, ll_curr_price, ll_qty, ll_out_price 
Decimal ldc_margin_rate
String ls_null
Setnull(ls_null) 

CHOOSE CASE dwo.name
	CASE "style_no"	
		IF ib_itemchanged THEN RETURN 1 
		ll_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		IF LenA(This.GetitemString(row, "size")) = 2 THEN
			This.Post Event ue_set_col("qty")
		END IF 
		Return ll_ret
	CASE "color"	
		This.Setitem(row, "size", ls_null) 
	CASE "curr_price"
		ll_curr_price   = Long(Data) 
		IF isnull(ll_curr_price) or ll_curr_price = 0 THEN RETURN 1 
		ll_qty          = This.GetitemNumber(row, "qty")
		ldc_margin_rate = This.GetitemDecimal(row, "margin_rate")
		/* 출고가 산출 */
		gf_marjin_price(is_shop_cd, ll_curr_price, ldc_margin_rate, ll_out_price) 
      This.Setitem(row, "out_price",  ll_out_price)
      /* 금액 처리           */
		wf_amt_set(row, ll_qty, ll_curr_price) 
	CASE "qty"	
		ll_curr_price = This.GetitemNumber(row, "curr_price")
		wf_amt_set(row, Long(data), ll_curr_price)
END CHOOSE

cb_move.enabled    = false
end event

event dw_body::doubleclicked;call super::doubleclicked;String ls_style_no,  ls_yes 
Long   ll_tag_price, ll_curr_price, ll_out_price

IF row < 1 THEN RETURN 
ls_style_no = This.GetitemString(row, "style_no")

IF isnull(ls_style_no) or Trim(ls_style_no) = "" THEN RETURN
IF is_shop_type < '4' THEN RETURN 

gsv_cd.gs_cd1 = is_brand 
gsv_cd.gs_cd2 = is_shop_cd 
gsv_cd.gs_cd3 = is_shop_type
gsv_cd.gs_cd4 = is_yymmdd

OpenWithParm (W_42000_S, "W_42000_S 출고마진 내역") 
ls_yes = Message.StringParm 
IF ls_yes = 'YES' THEN 
   ll_tag_price  = This.GetitemNumber(row, "tag_price")
   ll_curr_price = ll_tag_price * (100 - gsv_cd.gdc_cd2) / 100 
	gf_marjin_price(is_shop_cd, ll_curr_price, gsv_cd.gdc_cd1, ll_out_price) 
	This.Setitem(row, "curr_price",  ll_curr_price) 
	This.Setitem(row, "sale_type",   gsv_cd.gs_cd5) 
	This.Setitem(row, "disc_rate",   gsv_cd.gdc_cd2) 
	This.Setitem(row, "margin_rate", gsv_cd.gdc_cd1) 
	This.Setitem(row, "out_price",   ll_out_price) 
	wf_amt_set(row, This.Object.qty[row], ll_curr_price) 
   ib_changed = true
   cb_update.enabled = true
	dw_body.SetRow(row)
	dw_body.SetColumn("curr_price")
END IF 

end event

type dw_print from w_com010_e`dw_print within w_42031_e
integer x = 2025
integer y = 768
string dataobject = "d_com420_suju"
end type

type cb_input from commandbutton within w_42031_e
event ue_keydown pbm_keydown
integer x = 2528
integer y = 44
integer width = 347
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "등록(&I)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
end event

event clicked;/*===========================================================================*/
/* 작성자      : 김태범        															  */	
/* 작성일      : 2002.03.04																  */	
/* 수정일      : 2002.03.04																  */
/*===========================================================================*/
IF dw_head.Enabled THEN
   Parent.Trigger Event ue_input()	//등록 
ELSE 
	Parent.Trigger Event ue_head()	//조건 
END IF

end event

event getfocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 700

end event

event losefocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 400

end event

type cb_copy from commandbutton within w_42031_e
event ue_keydown pbm_keydown
integer x = 384
integer y = 44
integer width = 347
integer height = 92
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "복사(&C)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
end event

event getfocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 700

end event

event losefocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 400

end event

event clicked;/*===========================================================================*/
/* 작성자      : 김 태범      															  */	
/* 작성일      : 2002.03.04																  */	
/* 수정일      : 2002.03.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable
Long    i, ll_row_cnt  
Long    ll_qty,         ll_curr_price,  ll_out_price
String  ls_style,       ls_sale_type = space(2)
decimal ldc_marjin,     ldc_dc_rate

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
if is_shop_type = "%" then
   MessageBox("입력","정확한 매장형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   Return 
end if


if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox("입력","매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return 
end if


if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox("입력","브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return 
end if

//if is_shop_cd <> "OT3535" then 
//	if is_shop_cd <> "NT3531" then
		if is_brand <> LeftA(is_shop_cd,1) then
			MessageBox("경고","매장 코드와 브랜드를 확인 하십시요!")
			return 
		end if
//	end if	
//end if

ll_row_cnt = dw_body.RowCount() 
IF ll_row_cnt < 1 THEN RETURN 

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

dw_body.SetRedraw(FALSE)
FOR i = 1 TO ll_row_cnt
   IF dw_body.GetItemStatus(i, 0, Primary!) = New!	THEN CONTINUE 
   ls_style = dw_body.GetitemString(i, "style") 
   /* 출고시 마진율 체크 */
   IF gf_outmarjin (is_yymmdd,    is_shop_cd, is_shop_type, ls_style, & 
                    ls_sale_type, ldc_marjin, ldc_dc_rate,  ll_curr_price, ll_out_price) = FALSE THEN 
		SetPointer(oldpointer)
      This.Enabled = True
      dw_body.SetRedraw(True)
	   RETURN 
   END IF
   IF i > 1 THEN 
	   IF dw_body.Object.sale_type[1]   <> ls_sale_type OR &
	      dw_body.Object.margin_rate[1] <> ldc_marjin   THEN 
	      MessageBox("확인요망", "[" + ls_style + "] 마진율이 다른 형태 입니다.")
   		SetPointer(oldpointer)
         This.Enabled = True
		   Return 
         dw_body.SetRedraw(True)
	   END IF
   END IF 
   /* 단가 및 율 등록 */
   dw_body.Setitem(i, "sale_type",   ls_sale_type)
   dw_body.Setitem(i, "curr_price",  ll_curr_price)
   dw_body.Setitem(i, "disc_rate",   ldc_dc_rate)
   dw_body.Setitem(i, "margin_rate", ldc_marjin)
   dw_body.Setitem(i, "out_price",   ll_out_price)
   ll_qty = dw_body.GetitemNumber(i, "qty") 
   wf_amt_set(i, ll_qty, ll_curr_price)
   dw_body.SetItemStatus(i, 0, Primary!, NewModified!) 
NEXT 

dw_body.SetRedraw(True)

SetPointer(oldpointer)
This.Enabled = True


Parent.Trigger Event ue_button(6, 1)

dw_head.Setitem(1, "out_no", '')
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

dw_body.SetFocus()

end event

type dw_list from datawindow within w_42031_e
event ue_syscommand pbm_syscommand
boolean visible = false
integer y = 436
integer width = 3607
integer height = 1612
integer taborder = 50
boolean titlebar = true
string title = "출고조회"
string dataobject = "d_42031_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_syscommand;/* DataWindow 위치 이동 금지 */
uint a

a = message.wordparm

CHOOSE CASE a
      CASE 61456, 61458
         message.processed = true
         message.returnvalue = 0
END CHOOSE

return

end event

event constructor;DataWindowChild ldw_child 

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('911')

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('011')

This.GetChild("out_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('420')


end event

event doubleclicked;String ls_out_no, ls_shop_type  , ls_shop_cd
long ii

IF row < 0 THEN RETURN 

ls_out_no    = This.GetitemString(row, "out_no")
ls_shop_type = This.GetitemString(row, "shop_type")
ls_shop_cd   = This.GetitemString(row, "shop_cd")

il_rows = dw_body.Retrieve(is_yymmdd, is_shop_cd, ls_shop_type, ls_out_no, &
                    is_house,  is_brand)

IF il_rows > 0 THEN 
	dw_head.setitem(1,"out_no", ls_out_no)
	dw_head.setitem(1,"shop_cd", ls_shop_cd)	
   dw_body.visible = True						  
   dw_list.visible = False 
	cb_copy.Enabled = True
	cb_insert.Enabled = True
	cb_delete.Enabled = True	
//	dw_head.SetColumn("shop_cd")

	ib_changed = true
	cb_update.enabled = true
	cb_print.enabled = false
	cb_preview.enabled = false
	cb_excel.enabled = false
	
   dw_body.enabled = True						  	
	dw_body.SetFocus()
	
	
	parent.Trigger Event ue_button(1, il_rows)


END IF


end event

type cb_move from commandbutton within w_42031_e
integer x = 731
integer y = 44
integer width = 347
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "출고처리(M)"
end type

event clicked;string ls_yymmdd, ls_out_no, ls_shop_cd, ls_shop_type, ls_brand
long    ll_cnt, II, JJ, KK, ll_ok, ll_rtrn

		dw_head.AcceptText()
		
		ll_rtrn = messagebox("경고!", "출고확정이되면 전표를 수정할 수 없습니다! 작업을진행 하시겠습니까?",Question!,OKCancel! )

		if ll_rtrn = 1 then
						ls_brand			= dw_head.GetitemString(1, "brand")
						ls_yymmdd   	= String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")
						ls_out_no   	= dw_head.GetItemString(1, "out_no")				
						ls_shop_cd  	= dw_head.GetItemString(1, "shop_cd")
						ls_shop_type	= dw_head.Getitemstring(1, "shop_type")	
						
					
					// 전표의 확정전표의 유무를 확인한다.						
			      select count(*) 
					into :ll_cnt
					from tb_42020_suju with (nolock)
					where brand  		= :ls_brand
					and   yymmdd 		= :ls_yymmdd
					and   shop_cd 		= :ls_shop_cd
					and   shop_type 	= :ls_shop_type
					and   out_no		= :ls_out_no;
					
					if ll_cnt > 0   then
								
					    DECLARE sp_42031 PROCEDURE FOR sp_42031  
									@yymmdd 		= :ls_yymmdd,   
									@out_no 		= :ls_out_no,   
									@shop_cd 	= :ls_shop_cd,   
									@shop_type 	= :ls_shop_type,   
									@brand 		= :ls_brand  ;
									
					    execute sp_42031;			
		
						 commit USING SQLCA; 
													
					end if
					
				if ll_CNT > 0 then 
					messagebox("알림!" ,  ls_yymmdd + "일" + ls_out_no + "번 전표가 출고처리되었습니다!")
					dw_body.reset()					
				else
					messagebox("알림!" , "출고 처리된 자료가 없습니다!")
				end if

		else		
				messagebox("알림!" , "작업이 취소 되었습니다!")
		end if
	
	
	

end event

