$PBExportHeader$w_42005_e.srw
$PBExportComments$임시출고조회 수정(확정)
forward
global type w_42005_e from w_com020_e
end type
type dw_1 from datawindow within w_42005_e
end type
type cbx_a4 from checkbox within w_42005_e
end type
type cb_print1 from commandbutton within w_42005_e
end type
end forward

global type w_42005_e from w_com020_e
integer width = 3680
integer height = 2240
event ue_print1 ( )
dw_1 dw_1
cbx_a4 cbx_a4
cb_print1 cb_print1
end type
global w_42005_e w_42005_e

type variables
DataWindowChild    idw_brand, 	 idw_color,    idw_size,    idw_deal_fg, idw_color1,   idw_size1
DataWindowChild    idw_year,       idw_season,  idw_sojae,   idw_item
DataWindowChild    idw_house_cd
String is_house,   is_brand,       is_yymmdd,   is_out_no,   is_style,  is_chno, is_deal_fg
String is_shop_cd, is_shop_type,   is_out_type, is_color,    is_size,	is_style_n
string is_Rqst_Gubn, is_Rqst_Date, is_season,   is_year,     is_item,   is_sojae, is_house_cd
//       Work_NO


integer ii_deal_seq, ii_work_no, ii_no, ii_Rqst_chno
Boolean	Ib_TrueFalse
end variables

forward prototypes
public function boolean wf_margin_set (long al_row, string as_style)
public function boolean wf_resv_del (ref string as_errmsg)
public function boolean wf_style_chk (long al_row, string as_style_no)
public subroutine wf_amt_set (long al_row, long al_qty)
public function boolean wf_margin_set_color (long al_row, string as_style, string as_color)
end prototypes

event ue_print1();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long   i,j
String ls_shop_type, ls_out_no, ls_jup_name, ls_modify, ls_Error,ls_print, ls_shop_cd

dw_print.DataObject = "d_com420_a4"
dw_print.SetTransObject(SQLCA)
		
if cbx_a4.checked then 		
			ls_jup_name = "(매 장 용)"			

			FOR i = 1 TO dw_list.RowCount() 
				ls_print = dw_list.getitemstring(i, "out_print")
				IF ls_print = "Y"  THEN 
					ls_out_no    = dw_list.GetitemString(i, "out_no")
					ls_shop_cd   = dw_list.GetitemString(i, "shop_cd") 
					ls_shop_type = dw_list.GetitemString(i, "shop_type")
					dw_print.Retrieve(is_brand, is_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, '1')
					
					ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"
		
					ls_Error = dw_print.Modify(ls_modify)
						IF (ls_Error <> "") THEN 
							MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
						END IF
					
					IF dw_print.RowCount() > 0 Then
						il_rows = dw_print.Print()
					END IF
				END IF 	
			NEXT 			

else			
					 
			FOR i = 1 TO dw_list.RowCount() 
				ls_print = dw_list.getitemstring(i, "out_print")
				IF ls_print = "Y"  THEN 
					ls_out_no    = dw_list.GetitemString(i, "out_no")
					ls_shop_cd   = dw_list.GetitemString(i, "shop_cd") 
					ls_shop_type = dw_list.GetitemString(i, "shop_type")
								
					for j = 1 to 3	
						if j = 1 then 
							ls_jup_name = "(거 래 처 용)"			
						elseif j = 2 then
							ls_jup_name = "(매 장 용)"			
						else
							ls_jup_name = "(창 고 용)"			
						end if
							
								dw_print.Retrieve(is_brand, is_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, '1')
								
								ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"
					
								ls_Error = dw_print.Modify(ls_modify)
									IF (ls_Error <> "") THEN 
										MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
									END IF
								
								IF dw_print.RowCount() > 0 Then
									il_rows = dw_print.Print()
								END IF
					NEXT 									
				END IF 								
			next	
end if


This.Trigger Event ue_msg(6, il_rows)

end event

public function boolean wf_margin_set (long al_row, string as_style);Long    ll_qty      
Long    ll_curr_price,  ll_out_price
String  ls_null,        ls_sale_type = space(2)
decimal ldc_marjin, ldc_dc_rate
SetNull(ls_null) 


/* 출고시 마진율 체크 */


IF gf_outmarjin (is_yymmdd,    is_shop_cd, is_shop_type, as_style, & 
                  ls_sale_type, ldc_marjin, ldc_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
	RETURN False 
END IF

if is_shop_cd = 'NT3516' then ldc_dc_rate = 70.00

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
wf_amt_set(al_row, ll_qty)

RETURN True

end function

public function boolean wf_resv_del (ref string as_errmsg);Long   i, ll_row 
String ls_rqst_date, ls_style,   ls_chno,    ls_color, ls_size
String ls_out_type,  ls_shop_cd, ls_shop_div
Long   ll_rqst_chno, ll_deal_qty , ll_out_qty

ll_row = dw_body.DeletedCount()
FOR i = 1 TO ll_row 
	ls_rqst_date = dw_body.GetitemString(i, "rqst_date", Delete!, TRUE)
	ls_style     = dw_body.GetitemString(i, "style",     Delete!, TRUE)
	ls_chno      = dw_body.GetitemString(i, "chno",      Delete!, TRUE)
	ls_color     = dw_body.GetitemString(i, "color",     Delete!, TRUE)
	ls_size      = dw_body.GetitemString(i, "size",      Delete!, TRUE)
	ls_out_type  = dw_body.GetitemString(i, "out_type",  Delete!, TRUE)
	ls_shop_cd   = dw_body.GetitemString(i, "shop_cd",   Delete!, TRUE)
	ll_rqst_chno = dw_body.GetitemNumber(i, "rqst_chno", Delete!, TRUE)

	
	ll_out_qty   = dw_body.GetitemNumber(i, "qty",       Delete!, TRUE)	
	ls_shop_div  = MidA(ls_shop_cd, 2, 1)

//   select deal_qty * -1 
//	  into :ll_deal_qty 
//     from dbo.tb_52031_h
//    where out_ymd   = :ls_rqst_date 
//      and deal_seq  = :ll_rqst_chno
//      and style     = :ls_style 
//      and chno      = :ls_chno 
//      and color     = :ls_color 
//      and size      = :ls_size 
//      and deal_fg   = :ls_out_type
//      and shop_cd   = :ls_shop_cd  ;
		
	IF SQLCA.SQLCODE = 0 THEN
      IF gf_stresv_update (ls_style,    ls_chno,     ls_color,   ls_size, &
 	                        ls_shop_div, ll_out_qty * -1,  as_ErrMsg) = FALSE THEN 
	      RETURN FALSE
		END IF 
	END IF
NEXT 

RETURN TRUE

end function

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color, ls_null
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn  
Long   ll_tag_price , ll_cnt

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
	and plan_yn like :ls_plan_yn 
	and brand   =    :is_brand
	and tag_price <> 0 ;

IF SQLCA.SQLCODE <> 0 THEN 
	Return False 
END IF

dw_body.SetItem(al_row, "tag_price", ll_tag_price) 
IF wf_margin_set(al_row, ls_style) THEN 
   dw_body.SetItem(al_row, "style_no", as_style_no)
   dw_body.SetItem(al_row, "style",    ls_style)
	dw_body.SetItem(al_row, "chno",     ls_chno)
	dw_body.SetItem(al_row, "brand",    ls_brand)
	dw_body.SetItem(al_row, "year",     ls_year)
	dw_body.SetItem(al_row, "season",   ls_season)
	dw_body.SetItem(al_row, "sojae",    ls_sojae)
	dw_body.SetItem(al_row, "item",     ls_item)
END IF


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
	  dw_body.SetColumn("color")
	
	


Return True

end function

public subroutine wf_amt_set (long al_row, long al_qty);/* 각 단가 및 출고량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_out_price
Long ll_out_amt 
Decimal ldc_marjin

ll_tag_price  = dw_body.GetitemDecimal(al_row, "tag_price") 
ll_curr_price = dw_body.GetitemDecimal(al_row, "curr_price") 
ll_out_price  = dw_body.GetitemNumber(al_row, "out_price") 
ll_out_amt    = ll_out_price * al_qty   

dw_body.Setitem(al_row, "tag_amt",     ll_tag_price  * al_qty)
dw_body.Setitem(al_row, "curr_amt",    ll_curr_price * al_qty)
dw_body.Setitem(al_row, "out_collect", ll_out_amt) 
dw_body.Setitem(al_row, "vat", ll_out_amt - Round(ll_out_amt / 1.1, 0))


end subroutine

public function boolean wf_margin_set_color (long al_row, string as_style, string as_color);Long    ll_qty      
Long    ll_curr_price,  ll_out_price
String  ls_null,        ls_sale_type = space(2)
decimal ldc_marjin, ldc_dc_rate
SetNull(ls_null) 


/* 출고시 마진율 체크 */


IF gf_outmarjin_color (is_yymmdd,    is_shop_cd, is_shop_type, as_style, as_color, & 
                  ls_sale_type, ldc_marjin, ldc_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
	RETURN False 
END IF

if is_shop_cd = 'NT3516' then ldc_dc_rate = 70.00

IF al_row > 1 THEN 
	IF dw_body.Object.sale_type[1]   <> ls_sale_type OR &
	   dw_body.Object.margin_rate[1] <> ldc_marjin   THEN 
		MessageBox("확인요망", "마진율이 다른 형태 입니다.")
		Return False
	END IF
END IF 
/*색상 및 사이즈 클리어 */
//dw_body.Setitem(al_row, "color", ls_null)
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
wf_amt_set(al_row, ll_qty)

RETURN True

end function

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      :                                                    */	
/* 수정일      :                                                   */
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


is_out_no = dw_head.GetItemString(1, "out_no")
if IsNull(is_out_no) or Trim(is_out_no) = "" then
   is_out_no = "%"
end if

is_style_n = dw_head.GetItemString(1, "style_n")
if IsNull(is_style_n) or Trim(is_style_n) = "" then
   is_style_n = "%"
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
   is_chno = "%"
end if


is_color = dw_head.GetItemString(1, "color_1")
if IsNull(is_color) or Trim(is_color) = "" then
   MessageBox(ls_title,"색상을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("color_1")
   return false
end if

is_size = dw_head.GetItemString(1, "size_1")
if IsNull(is_size) or Trim(is_size) = "" then
   MessageBox(ls_title,"사이즈를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("size_1")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"품종을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"출고일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   is_shop_cd = "%"
end if

is_deal_fg = dw_head.GetItemString(1, "deal_fg")
if IsNull(is_deal_fg) or Trim(is_deal_fg) = "" then
   MessageBox(ls_title,"배분구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_fg")
   return false
end if	
	

ii_work_no = dw_head.GetItemNumber(1, "work_no")
if IsNull(ii_work_no) or ii_work_no <= 0 then
   ii_work_no = 0
end if

is_house_cd= dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if	



return true 
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_style, ls_chno, ls_color
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
		
			CASE "shop_cd"				
			IF ai_div = 1 THEN 
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				IF gf_shop_nm3(as_data, 'S', ls_shop_nm) = 0 THEN
//				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
//					RETURN 0
					if gs_brand <> "K" then
					   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
						RETURN 0
					else
							if gs_brand <> MidA(as_data,1,1) then
								Return 1
							else 
							   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
								RETURN 0
							end if	
					end if
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
				dw_head.SetColumn("shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
		
	CASE "style"				// 거래처 코드
			IF ai_div = 1 THEN 	
				IF wf_style_chk(al_row, as_data)  THEN 
					RETURN 0 
				END IF 
			END IF
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				// 스타일 선별작업
				IF  gl_user_level = 0 then 
					gst_cd.default_where   = "WHERE   style like '" + gs_brand + "%'"	
				else 	
					if gs_brand <> "K" then
						gst_cd.default_where   = " WHERE  tag_price <> 0 "
					else
						gst_cd.default_where   = " WHERE  tag_price <> 0 and brand = 'K' "						
					end if	
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
								
  	   ls_style =  lds_Source.GetItemString(1,"style")
		ls_chno  = lds_Source.GetItemString(1,"chno")
		
								
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("chno")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
			
//	CASE "style_no"		
//			IF ai_div = 1 THEN 	
//				IF wf_style_chk(al_row, as_data)  THEN 
//					RETURN 0 
//				END IF 
//			END IF
//			IF al_row > 1 THEN 
//				gf_style_edit(dw_body.object.style_no[al_row -1], as_data, ls_style, ls_chno)
//			ELSE
//		      ls_style = Mid(as_data, 1, 8)
//		      ls_chno  = Mid(as_data, 9, 1) 
//			END IF
//		   gst_cd.ai_div          = ai_div
//			gst_cd.window_title    = "품번 코드 검색" 
//			gst_cd.datawindow_nm   = "d_com010" 
//			gst_cd.default_where   = "WHERE brand = '" + is_brand + "' " + & 
//			                         "  AND tag_price <> 0 "
//			IF is_shop_type = '1' THEN 
//				gst_cd.default_where   = gst_cd.default_where + "AND plan_yn = 'N'"
//			ELSEIF is_shop_type = '3' THEN
//				gst_cd.default_where   = gst_cd.default_where + "AND plan_yn = 'Y'"
//			END IF
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" + &
//				                " and chno  LIKE '" + ls_chno  + "%'" 
//			ELSE
//				gst_cd.Item_where = ""
//			END IF
//
//			lb_check = FALSE 
//			lds_Source = Create DataStore
//			OpenWithParm(W_COM200, lds_Source)
//
//			IF Isvalid(Message.PowerObjectParm) THEN
//				ib_itemchanged = True
//				lds_Source = Message.PowerObjectParm
//				IF ai_div = 2 THEN 
//				   dw_body.SetRow(al_row)
//				   dw_body.SetColumn(as_column)
//				END IF
//				dw_body.SetItem(al_row, "tag_price", lds_Source.GetItemNumber(1,"tag_price")) 
//				ls_style = lds_Source.GetItemString(1,"style")
// 				IF wf_margin_set(al_row, ls_style) THEN 
//				   dw_body.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
//				   dw_body.SetItem(al_row, "style",    lds_Source.GetItemString(1,"style"))
//				   dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno"))
//				   dw_body.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand"))
//				   dw_body.SetItem(al_row, "year",     lds_Source.GetItemString(1,"year"))
//				   dw_body.SetItem(al_row, "season",   lds_Source.GetItemString(1,"season"))
//				   dw_body.SetItem(al_row, "sojae",    lds_Source.GetItemString(1,"sojae"))
//				   dw_body.SetItem(al_row, "item",     lds_Source.GetItemString(1,"item"))
//				   ib_changed = true
//               cb_update.enabled = true
//				   /* 다음컬럼으로 이동 */
//			      dw_body.SetColumn("color")
//			      lb_check = TRUE 
//				END IF
//				ib_itemchanged = FALSE
//			END IF
//			Destroy  lds_Source
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
			gst_cd.datawindow_nm   = "d_com013" 
			gst_cd.default_where   = "WHERE brand = '" + is_brand + "' " + & 
			                         "  AND tag_price <> 0 "
				 
											 
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
				ls_color = lds_Source.GetItemString(1,"color")				
			
 				IF wf_margin_set_color(al_row, ls_style, ls_color) THEN 
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
//				wf_margin_set(al_row, ls_style)
				   ib_changed = true
               cb_update.enabled = true
				   /* 다음컬럼으로 이동 */
			      dw_body.SetColumn("color")
			      lb_check = TRUE 
				END IF
				  dw_body.SetColumn("color")
				ib_itemchanged = FALSE
			END IF
			Destroy  lds_Source
         dw_body.SetColumn("color")
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

event ue_retrieve();
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_list.retrieve(is_brand, is_yymmdd, is_out_no, is_shop_cd, is_style_n, is_chno, IS_COLOR, IS_SIZE, is_deal_fg, ii_work_no, &
                           is_year, is_season, is_sojae, is_item, is_house_cd)

IF il_rows >= 0 THEN
   dw_list.SetFocus()
END IF


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)


end event

event type long ue_update();/*===========================================================================*/
/* 작성자      :                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/
long i, ll_row_count 
integer li_no
datetime ld_datetime
String   ls_ErrMsg

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF
/* 출고전표 채번 */

if IsNull(is_out_no) or Trim(is_out_no) = "" then
	IF gf_style_outno(is_yymmdd, is_brand, is_out_no) = FALSE THEN 
		Return -1 
	END IF 
end if

 li_no = ii_no

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	
   IF idw_status = NewModified!  and ib_TrueFalse = true THEN				/* New Record */
	   li_no = li_no + 1
	   dw_body.Setitem(i, "yymmdd",    is_yymmdd)
      dw_body.Setitem(i, "shop_cd",   is_shop_cd)
      dw_body.Setitem(i, "shop_type", is_shop_type)
      dw_body.Setitem(i, "out_no",    is_out_no)
      dw_body.Setitem(i, "no",        String(li_no, "0000"))
      dw_body.Setitem(i, "house_cd",  is_house_cd)
      dw_body.Setitem(i, "jup_gubn",  'O1')
      dw_body.Setitem(i, "out_type",   is_out_type) 
      dw_body.Setitem(i, "Rqst_Gubn",  is_Rqst_Gubn)
		dw_body.Setitem(i, "Rqst_Date",  is_Rqst_Date)
		dw_body.Setitem(i, "Rqst_chno",  ii_Rqst_chno)		
		dw_body.Setitem(i, "work_no",    ii_work_no)
		dw_body.Setitem(i, "class",  'A')
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT
IF wf_resv_del(ls_ErrMsg) THEN
   il_rows = dw_body.Update()
ELSE 
	il_rows = -1
END IF

if il_rows = 1 then
   commit  USING SQLCA;

	select max(no)
	into :ii_no
	from tb_42020_work
	where yymmdd = :is_yymmdd
	and   out_no = :is_out_no;
  
ii_work_no = dw_head.GetItemNumber(1, "work_no")
if IsNull(ii_work_no) or ii_work_no <= 0 then
   ii_work_no = 0
end if
  
// 	 dw_list.retrieve(is_brand, is_yymmdd, "%", "%", is_style_n, "%", IS_COLOR, IS_SIZE, is_deal_fg, ii_work_no, &
//                           is_year, is_season, is_sojae, is_item)
	
else
   rollback  USING SQLCA;
	IF Trim(ls_ErrMsg) <> "" THEN 
		MessageBox("예약재고 오류", ls_ErrMsg)
	END IF
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)
return il_rows

end event

on w_42005_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cbx_a4=create cbx_a4
this.cb_print1=create cb_print1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cbx_a4
this.Control[iCurrent+3]=this.cb_print1
end on

on w_42005_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cbx_a4)
destroy(this.cb_print1)
end on

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long   i 
String ls_shop_type, ls_out_no, ls_shop_cd, ls_yymmdd, ls_print

dw_print.DataObject = "d_com420"
dw_print.SetTransObject(SQLCA)

   FOR i = 1 TO dw_list.RowCount() 
		ls_print = dw_list.getitemstring(i, "out_print")
      IF ls_print = "Y"  THEN 
         ls_out_no    = dw_list.GetitemString(i, "out_no")
			ls_shop_cd   = dw_list.GetitemString(i, "shop_cd") 
         ls_shop_type = dw_list.GetitemString(i, "shop_type")
         dw_print.Retrieve(is_brand, is_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, '1')
         IF dw_print.RowCount() > 0 Then
            il_rows = dw_print.Print()
         END IF
		END IF 	
	NEXT 
	
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
      else
         dw_head.SetFocus()
      end if

   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
		   cb_insert.enabled = true
			cb_print.enabled = false
			cb_print1.enabled = false			
			cb_preview.enabled = false
			cb_excel.enabled = true
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_list.Enabled = true
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_print1.enabled = true			
			cb_preview.enabled = true
			cb_excel.enabled = true
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
         cb_print1.enabled = false			
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_insert.enabled = false
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_print1.enabled = false		
      cb_preview.enabled = false
      cb_excel.enabled = true
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
								
		
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_print1.enabled = true			
         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_print1.enabled = false			
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
         cb_insert.enabled = true
      end if
END CHOOSE

end event

event pfc_dberror;//
end event

event ue_excel;This.Trigger Event ue_button(5, il_rows)
	   DW_HEAD.SETITEM(1, "SHOP_CD", "")
		DW_HEAD.SETITEM(1, "SHOP_NM", "")	
		DW_HEAD.SETITEM(1, "OUT_NO", "")			
		DW_HEAD.SETITEM(1, "DEAL_FG", "%")					
		DW_HEAD.SETITEM(1, "SEASON", "%")									
		DW_HEAD.SETITEM(1, "SOJAE", "%")								
		DW_HEAD.SETITEM(1, "ITEM", "%")									
		DW_HEAD.SETITEM(1, "STYLE", "")									
		DW_HEAD.SETITEM(1, "COLOR", "%")									
		DW_HEAD.SETITEM(1, "SIZE", "%")		
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42005_e","0")
end event

event open;call super::open;dw_head.setitem(1, "year", "%")
dw_head.setitem(1, "season", "%")
end event

type cb_close from w_com020_e`cb_close within w_42005_e
end type

type cb_delete from w_com020_e`cb_delete within w_42005_e
integer x = 1760
end type

type cb_insert from w_com020_e`cb_insert within w_42005_e
integer x = 1417
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_42005_e
end type

type cb_update from w_com020_e`cb_update within w_42005_e
end type

type cb_print from w_com020_e`cb_print within w_42005_e
integer x = 2103
integer width = 677
string text = "거래명세서인쇄(&P)"
end type

type cb_preview from w_com020_e`cb_preview within w_42005_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_42005_e
end type

type cb_excel from w_com020_e`cb_excel within w_42005_e
integer x = 384
boolean enabled = true
string text = "신규(N)"
end type

type dw_head from w_com020_e`dw_head within w_42005_e
integer y = 160
integer height = 400
string dataobject = "d_42005_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("deal_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('521')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '%')
ldw_child.SetItem(1, "inter_nm", '전체')

This.GetChild("color_1", idw_color1)
idw_color1.SetTransObject(SQLCA)
idw_color1.Retrieve('%')
//idw_color1.insertRow(0)
idw_color1.InsertRow(1)
idw_color1.SetItem(1, "color", '%')
idw_color1.SetItem(1, "color_knm", '전체')
idw_color1.SetItem(1, "color_enm", '전체')

This.GetChild("size_1", idw_size1)
idw_size1.SetTransObject(SQLCA)
idw_size1.Retrieve('%')
//idw_size1.insertRow(0)
idw_size1.InsertRow(1)
idw_size1.SetItem(1, "size", '%')
idw_size1.SetItem(1, "size_nm", '전체')



THIS.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")


This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', is_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')


This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(is_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

This.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()


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
//		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, Data) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

   CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if LenA(data) <> 0 then
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
		end if

	CASE "brand", "year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")

			This.GetChild("sojae", idw_sojae)
			idw_sojae.SetTransObject(SQLCA)
			idw_sojae.Retrieve('%', is_brand)
			idw_sojae.insertrow(1)
			idw_sojae.Setitem(1, "sojae", "%")
			idw_sojae.Setitem(1, "sojae_nm", "전체")
			
			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_brand)
			idw_item.insertrow(1)
			idw_item.Setitem(1, "item", "%")
			idw_item.Setitem(1, "item_nm", "전체")
		
END CHOOSE

end event

event dw_head::itemfocuschanged;String ls_style, ls_chno, ls_color

CHOOSE CASE dwo.name
	CASE "color_1" 
//		ls_style = This.GetitemString(row, "style")
//		ls_chno  = "%" //This.GetitemString(row, "chno")
//		idw_color1.Retrieve(ls_style, ls_chno)
//		idw_color1.InsertRow(1)
//		idw_color1.SetItem(1, "color", '%')
//		idw_color1.SetItem(1, "color_enm", '전체')
//

			
	CASE "size_1"
//		ls_style = This.GetitemString(row, "style")
//		ls_chno  = "%" //This.GetitemString(row, "chno")
//		ls_color = This.GetitemString(row, "color_1")
//		idw_size1.Retrieve(ls_style, ls_chno, ls_color)
//		idw_size1.InsertRow(1)
//		idw_size1.SetItem(1, "size", '%')
//		idw_size1.SetItem(1, "size_nm", '전체')
		
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_42005_e
integer beginy = 560
integer endy = 560
end type

type ln_2 from w_com020_e`ln_2 within w_42005_e
integer beginy = 564
integer endy = 564
end type

type dw_list from w_com020_e`dw_list within w_42005_e
integer x = 9
integer y = 724
integer width = 773
integer height = 1280
string dataobject = "d_42005_d02"
end type

event dw_list::doubleclicked;call super::doubleclicked;string ls_shop_nm
Integer i, li_column_count
String  ls_column_name, ls_modify

if is_style_n = "%"  then 
	ib_TrueFalse = True
	is_color = "%"
	is_size = "%"
end if	

//string is_Rqst_Gubn, is_Rqst_Date
//integer ii_deal_seq, ii_work_no, ii_no

is_shop_type = dw_list.GetitemString(row, "shop_type")
is_shop_cd   = dw_list.GetitemString(row, "shop_cd")
is_yymmdd    = dw_list.GetitemString(row, "yymmdd")
is_out_no    = dw_list.GetitemString(row, "out_no")
is_out_type  = dw_list.GetitemString(row, "out_type")
is_Rqst_Gubn = dw_list.GetitemString(row, "Rqst_Gubn")
is_Rqst_Date = dw_list.GetitemString(row, "Rqst_Date")
ii_Rqst_chno = dw_list.GetitemNumber(row, "Rqst_chno")
ii_work_no   = dw_list.GetitemNumber(row, "work_no")

	

il_rows = dw_body.retrieve(is_yymmdd, is_shop_cd, is_out_no,  is_brand, is_style_n, '%', is_color, is_size ,ii_work_no , &
                            is_year, is_season, is_sojae, is_item )

select max(no)
into :ii_no
from tb_42020_work
where yymmdd = :is_yymmdd
and   out_no = :is_out_no;

gf_shop_nm(is_shop_cd, "S", ls_shop_nm)


IF il_rows > 0 THEN
	dw_head.setitem(1, "shop_cd", is_shop_cd)
	dw_head.setitem(1, "shop_nm", ls_shop_nm)	
   dw_body.SetFocus()
END IF


//If this.IsSelected(row) then
	this.SelectRow(row,TRUE)
//	
Parent.Trigger Event ue_button(7, il_rows)
//Parent.Trigger Event ue_msg(2, il_rows)

end event

type dw_body from w_com020_e`dw_body within w_42005_e
integer y = 580
integer height = 1420
string dataobject = "d_42005_d01"
end type

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

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
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
		wf_amt_set(row, Long(data))
		
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

event dw_body::ue_keydown;call super::ue_keydown;/*===========================================================================*/
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

event dw_body::dberror;//
end event

type st_1 from w_com020_e`st_1 within w_42005_e
integer y = 728
integer height = 1304
end type

type dw_print from w_com020_e`dw_print within w_42005_e
integer x = 1458
integer y = 832
string dataobject = "d_com420"
end type

type dw_1 from datawindow within w_42005_e
integer x = 32
integer y = 576
integer width = 704
integer height = 136
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_42005_d03"
boolean border = false
boolean livescroll = true
end type

event constructor;DW_1.INSERTROW(0)
end event

event buttonclicked;string ls_yymmdd, ls_out_no, ls_shop_cd, ls_modify
Integer li_deal_seq, li_work_no, li_rtrn
long    ll_row, II, JJ, KK, ll_ok

CHOOSE CASE dwo.name
	CASE "cb_select"	
	
		ll_row = dw_list.rowcount()
		if dw_1.object.cb_select.text = "전체선택"  then 
			for ii = 1 to ll_row
				dw_list.setitem(ii , "out_proc", "Y")
			next	

	   ls_modify = 'cb_select.text= "선택해제"' 
		dw_1.Modify(ls_modify)
			
      else
			for ii = 1 to ll_row
				dw_list.setitem(ii , "out_proc", "N")				
			next	
	   ls_modify = 'cb_select.text= "전체선택"'
		dw_1.Modify(ls_modify)
		end if	
			
	CASE "cb_proc"	
		dw_list.AcceptText()
		
		ll_row = dw_list.rowcount()
		ll_ok = 0
		
		li_rtrn = messagebox("경고!", "출고확정이되면 전표를 수정할 수 없습니다! 작업을진행 하시겠습니까?",Question!,OKCancel! )

		if li_rtrn = 1 then
				for ii= 1 to ll_row
						ls_yymmdd   = dw_list.GetItemString(ii, "yymmdd")
						ls_out_no   = dw_list.GetItemString(ii, "out_no")				
						ls_shop_cd  = dw_list.GetItemString(ii, "shop_cd")
					
					
						
						idw_status = dw_list.GetItemStatus(ii, 0, Primary!)
		
					if dw_list.GetitemString(ii, "out_proc") = "Y"  then
		
						 iF idw_status = DataModified! THEN	
								
						 DECLARE sp_42005_d02 PROCEDURE FOR sp_42005_d02  
				         @yymmdd = :ls_yymmdd,   
				         @out_no = :ls_out_no,   
				         @shop_cd = :ls_shop_cd,   
				         @brand = :is_brand  ;

					  	    execute sp_42005_d02;
 								
							commit  USING SQLCA; 
							 ll_ok = ll_ok + 1 						  
								
						end if
					end if
				next 	
				 
				if ll_ok > 0 then 
					messagebox("알림!" , "총 " + string(ll_ok) + "개의 전표가 출고처리되었습니다!")
				else
					messagebox("알림!" , "출고 처리된 자료가 없습니다!")
				end if
				Parent.Trigger Event ue_retrieve()
	else		
				messagebox("알림!" , "작업이 취소 되었습니다!")
	end if
END CHOOSE
	
	
	

end event

type cbx_a4 from checkbox within w_42005_e
integer x = 2967
integer y = 468
integer width = 585
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
string text = "명세서A4(매장용)"
borderstyle borderstyle = stylelowered!
end type

type cb_print1 from commandbutton within w_42005_e
integer x = 1070
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
string text = "명세서A4"
end type

event clicked;Parent.Trigger Event ue_print1()
end event

