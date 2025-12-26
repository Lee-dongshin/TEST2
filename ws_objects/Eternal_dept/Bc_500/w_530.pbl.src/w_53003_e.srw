$PBExportHeader$w_53003_e.srw
$PBExportComments$점간 이송 등록
forward
global type w_53003_e from w_com010_e
end type
type dw_out from u_dw within w_53003_e
end type
type dw_rtn from u_dw within w_53003_e
end type
type cbx_laser from checkbox within w_53003_e
end type
end forward

global type w_53003_e from w_com010_e
integer width = 3675
integer height = 2276
dw_out dw_out
dw_rtn dw_rtn
cbx_laser cbx_laser
end type
global w_53003_e w_53003_e

type variables
DataWindowChild idw_brand, idw_fr_shop_type, idw_to_shop_type
DataWindowChild idw_color, idw_size, idw_tran_type, idw_tran_cust

String is_brand, is_yymmdd, is_to_ymd, is_data_opt
String is_fr_shop_cd, is_fr_shop_type, is_to_shop_cd, is_to_shop_type



end variables

forward prototypes
public function integer wf_data_set (long al_body_row, string as_bill_no, string as_no, string as_flag)
public function boolean wf_style_chk (long al_row, string as_style_no, string as_flag)
public function boolean wf_style_set (long al_row, string as_style, string as_flag)
public function boolean wf_stock_chk (long al_row, long al_qty)
public subroutine wf_amt_set (long al_row, long al_qty, string as_flag)
end prototypes

public function integer wf_data_set (long al_body_row, string as_bill_no, string as_no, string as_flag);Long ll_row

If as_flag = 'RTN' Then
	ll_row = dw_rtn.InsertRow(0)
	
	dw_rtn.SetItem(ll_row, "yymmdd",        is_yymmdd      )
	dw_rtn.SetItem(ll_row, "shop_cd",       is_fr_shop_cd  )
	dw_rtn.SetItem(ll_row, "shop_type",     is_fr_shop_type)
	dw_rtn.SetItem(ll_row, "out_no",        as_bill_no     )
	dw_rtn.SetItem(ll_row, "house_cd",      '990000'       )
	dw_rtn.SetItem(ll_row, "jup_gubn",      'O2'           )
	dw_rtn.SetItem(ll_row, "sale_type",     dw_body.GetItemString (al_body_row, "rtn_sale_type")  )
	dw_rtn.SetItem(ll_row, "margin_rate",   dw_body.GetItemDecimal(al_body_row, "rtn_margin_rate"))
	dw_rtn.SetItem(ll_row, "disc_rate",     dw_body.GetItemDecimal(al_body_row, "rtn_disc_rate")  )
	dw_rtn.SetItem(ll_row, "no",            as_no          )
	dw_rtn.SetItem(ll_row, "style",         dw_body.GetItemString (al_body_row, "style"))
	dw_rtn.SetItem(ll_row, "chno",          dw_body.GetItemString (al_body_row, "chno") )
//	If is_fr_shop_type > '3' Then
//		dw_rtn.SetItem(ll_row, "color",      'XX')
//		dw_rtn.SetItem(ll_row, "size",       'XX')
//	Else
		dw_rtn.SetItem(ll_row, "color",      dw_body.GetItemString (al_body_row, "color"))
		dw_rtn.SetItem(ll_row, "size",       dw_body.GetItemString (al_body_row, "size") )
//	End If
	dw_rtn.SetItem(ll_row, "class",         'A'            )
	dw_rtn.SetItem(ll_row, "tag_price",     dw_body.GetItemDecimal(al_body_row, "tag_price")     )
	dw_rtn.SetItem(ll_row, "curr_price",    dw_body.GetItemNumber (al_body_row, "rtn_curr_price"))
	dw_rtn.SetItem(ll_row, "out_price",     dw_body.GetItemNumber (al_body_row, "rtn_out_price") )
	dw_rtn.SetItem(ll_row, "qty",           dw_body.GetItemDecimal(al_body_row, "move_qty")      )
	dw_rtn.SetItem(ll_row, "tag_amt",       dw_body.GetItemDecimal(al_body_row, "tag_amt")       )
	dw_rtn.SetItem(ll_row, "curr_amt",      dw_body.GetItemDecimal(al_body_row, "rtn_curr_amt")  )
	dw_rtn.SetItem(ll_row, "rtrn_collect",  dw_body.GetItemDecimal(al_body_row, "rtrn_collect")  )
	dw_rtn.SetItem(ll_row, "vat",           dw_body.GetItemDecimal(al_body_row, "rtn_vat")       )
	dw_rtn.SetItem(ll_row, "rot_shop",      is_to_shop_cd  )
	dw_rtn.SetItem(ll_row, "rot_shop_type", is_to_shop_type)
	dw_rtn.SetItem(ll_row, "brand",         is_brand       )
	dw_rtn.SetItem(ll_row, "year",          dw_body.GetItemString (al_body_row, "year")  )
	dw_rtn.SetItem(ll_row, "season",        dw_body.GetItemString (al_body_row, "season"))
	dw_rtn.SetItem(ll_row, "item",          dw_body.GetItemString (al_body_row, "item")  )
	dw_rtn.SetItem(ll_row, "sojae",         dw_body.GetItemString (al_body_row, "sojae") )
	dw_rtn.SetItem(ll_row, "reg_id",        gs_user_id     )
Else
	ll_row = dw_out.InsertRow(0)
	
	dw_out.SetItem(ll_row, "yymmdd",        is_to_ymd      )
	dw_out.SetItem(ll_row, "shop_cd",       is_to_shop_cd  )
	dw_out.SetItem(ll_row, "shop_type",     is_to_shop_type)
	dw_out.SetItem(ll_row, "out_no",        as_bill_no     )
	dw_out.SetItem(ll_row, "house_cd",      '990000'       )
	dw_out.SetItem(ll_row, "jup_gubn",      'O2'           )
	dw_out.SetItem(ll_row, "out_type",      'A'            )
	dw_out.SetItem(ll_row, "sale_type",     dw_body.GetItemString (al_body_row, "out_sale_type")  )
	dw_out.SetItem(ll_row, "margin_rate",   dw_body.GetItemDecimal(al_body_row, "out_margin_rate"))
	dw_out.SetItem(ll_row, "disc_rate",     dw_body.GetItemDecimal(al_body_row, "out_disc_rate")  )
	dw_out.SetItem(ll_row, "no",            as_no          )
	dw_out.SetItem(ll_row, "style",         dw_body.GetItemString (al_body_row, "style"))
	dw_out.SetItem(ll_row, "chno",          dw_body.GetItemString (al_body_row, "chno") )
//	If is_to_shop_type > '3' Then
//		dw_out.SetItem(ll_row, "color",      'XX')
//		dw_out.SetItem(ll_row, "size",       'XX')
//	Else
		dw_out.SetItem(ll_row, "color",      dw_body.GetItemString (al_body_row, "color"))
		dw_out.SetItem(ll_row, "size",       dw_body.GetItemString (al_body_row, "size") )
	//End If
	dw_out.SetItem(ll_row, "class",         'A')
	dw_out.SetItem(ll_row, "tag_price",     dw_body.GetItemDecimal(al_body_row, "tag_price")     )
	dw_out.SetItem(ll_row, "curr_price",    dw_body.GetItemNumber (al_body_row, "out_curr_price"))
	dw_out.SetItem(ll_row, "out_price",     dw_body.GetItemNumber (al_body_row, "out_out_price") )
	dw_out.SetItem(ll_row, "qty",           dw_body.GetItemDecimal(al_body_row, "move_qty")      )
	dw_out.SetItem(ll_row, "tag_amt",       dw_body.GetItemDecimal(al_body_row, "tag_amt")       )
	dw_out.SetItem(ll_row, "curr_amt",      dw_body.GetItemDecimal(al_body_row, "out_curr_amt")  )
	dw_out.SetItem(ll_row, "out_collect",   dw_body.GetItemDecimal(al_body_row, "out_collect")   )
	dw_out.SetItem(ll_row, "vat",           dw_body.GetItemDecimal(al_body_row, "out_vat")       )
	dw_out.SetItem(ll_row, "rot_shop",      is_fr_shop_cd  )
	dw_out.SetItem(ll_row, "rot_shop_type", is_fr_shop_type)
	dw_out.SetItem(ll_row, "brand",         is_brand       )
	dw_out.SetItem(ll_row, "year",          dw_body.GetItemString (al_body_row, "year")  )
	dw_out.SetItem(ll_row, "season",        dw_body.GetItemString (al_body_row, "season"))
	dw_out.SetItem(ll_row, "item",          dw_body.GetItemString (al_body_row, "item")  )
	dw_out.SetItem(ll_row, "sojae",         dw_body.GetItemString (al_body_row, "sojae") )
	dw_out.SetItem(ll_row, "reg_id",        gs_user_id     )
End If

Return 0

end function

public function boolean wf_style_chk (long al_row, string as_style_no, string as_flag);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.15                                                  */	
/* 수정일      : 2002.03.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color, ls_null, ls_given_ymd, ls_given_fg
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn, ls_shop_type  ,ls_work_gubn
Long   ll_tag_price,  ll_cnt  

SetNull(ls_null)

IF al_row > 1 and LenA(as_style_no) <> 9 THEN
	gf_style_edit(dw_body.Object.style_no[al_row - 1], as_style_no, ls_style, ls_chno) 
   IF ls_chno = '%' THEN ls_chno = '0' 
ELSE 
	ls_style = LeftA(as_style_no, 8)
	ls_chno  = MidA(as_style_no, 9, 1)
END IF 

IF MidA(is_fr_shop_cd, 2, 1) = 'X' OR MidA(is_fr_shop_cd, 2, 1) = 'T' Then
	If MidA(is_to_shop_cd, 2, 1) = 'X' OR MidA(is_to_shop_cd, 2, 1) = 'T' THEN 
		ls_plan_yn = '%'
	ElseIf is_to_shop_type = '1' Then
		ls_plan_yn = 'N'
	ElseIf is_to_shop_type = '3' Then
		ls_plan_yn = 'Y'
	ElseIf is_to_shop_type = '4' Then
		ls_plan_yn = 'N'		
	Else
		ls_plan_yn = '%'
	End If
ELSEIF is_fr_shop_type = '1' THEN 
	ls_plan_yn = 'N'
ELSEIF is_fr_shop_type = '3' THEN 
	ls_plan_yn = 'Y'
ELSEIF is_fr_shop_type = '' THEN 
	ls_plan_yn = 'N'	
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
  from vi_12020_1
 where style   like :ls_style 
	and chno    =    :ls_chno
	and plan_yn like :ls_plan_yn
	and isnull(tag_price, 0) <> 0;
	
IF SQLCA.SQLCODE <> 0 or ll_cnt <> 1 THEN 
	Return False 
END IF 


////is_fr_shop_cd, is_fr_shop_type
//if is_fr_shop_type = "4" or is_fr_shop_type = "1" then
//
//			Select shop_type
//			into :ls_shop_type
//			From tb_56012_d with (nolock)
//			Where style      = :ls_style 
//			  and start_ymd <= :is_yymmdd
//			  and end_ymd   >= :is_yymmdd
//			  and shop_cd    = :is_fr_shop_cd ;
//			
//			if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
//							if is_fr_shop_type = '3' then
//							 ls_shop_type = '3'
//							else 
//							 ls_shop_type = '1'	
//							end if 
//			end if	 
//			
//			if is_fr_shop_type <> ls_shop_type then 
//				messagebox("경고!", "제품판매가 가능한 매장형태는 " + ls_shop_type + " 입니다!")
//				return false
//			end if	
//end if
//
//if is_to_shop_type = "4" or is_to_shop_type = "1" then
//
//			Select shop_type
//			into :ls_shop_type
//			From tb_56012_d with (nolock)
//			Where style      = :ls_style 
//			  and start_ymd <= :is_yymmdd
//			  and end_ymd   >= :is_yymmdd
//			  and shop_cd    = :is_to_shop_cd ;
//			
//			if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
//							if is_to_shop_type = '3' then
//							 ls_shop_type = '3'
//							else 
//							 ls_shop_type = '1'	
//							end if 
//			end if	 
//			
//			if is_to_shop_type <> ls_shop_type then 
//				messagebox("경고!", "제품판매가 가능한 매장형태는 " + ls_shop_type + " 입니다!")
//				return false
//			end if	
//end if

//select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
//into  :ls_given_fg, :ls_given_ymd
//from tb_12020_m with (nolock)
//where style = :ls_style;
//
//
//if ls_given_fg = "Y"  and ls_given_ymd <= is_yymmdd then 
//	messagebox("품번체크", ls_given_ymd + "일자로 사은품 전환된 제품입니다!")
//	return false
//end if 	


select 
		 isnull(given_ymd, 'XXXXXXXX'), isnull(work_gubn,'A')
into  :ls_given_ymd, :ls_work_gubn
from tb_56040_m with (nolock)
where style = :ls_style
and   work_gubn in ('A','O') ;


if ls_given_ymd <= is_yymmdd and LenA(ls_work_gubn) = 1 then 
	messagebox("품번체크", ls_given_ymd + "일자로 사은품 전환된 제품입니다!")
	return false
end if 	



dw_body.SetItem(al_row, "tag_price", ll_tag_price) 
IF wf_style_set(al_row, ls_style, as_flag) THEN 
   dw_body.SetItem(al_row, "style_no", ls_style + ls_chno)
   dw_body.SetItem(al_row, "style",    ls_style)
	dw_body.SetItem(al_row, "chno",     ls_chno)
	dw_body.SetItem(al_row, "brand",    ls_brand)
	dw_body.SetItem(al_row, "year",     ls_year)
	dw_body.SetItem(al_row, "season",   ls_season)
	dw_body.SetItem(al_row, "sojae",    ls_sojae)
	dw_body.SetItem(al_row, "item",     ls_item)
	dw_body.SetItem(al_row, "proc_yn",  'N')
END IF

if (is_brand = "N" OR is_brand = 'O' OR is_brand = 'W') and is_fr_shop_type > '3' and is_to_shop_type > '3' THEN
//	dw_body.SetItem(al_row, "color",    'XX')
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
		
	dw_body.SetItem(al_row, "size",     'XX')	
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
//ls_color = dw_body.GetitemString(al_row - 1, "color")
//select count(color)
//  into :ll_cnt  
//  from tb_12024_d with (nolock)
// where style = :ls_style 
//	and chno  = :ls_chno 
//	and color = :ls_color ;
//IF ll_cnt > 0 THEN
//	dw_body.SetItem(al_row, "color", ls_color)
//ELSE
//	dw_body.SetItem(al_row, "color", ls_null)
//END IF
//dw_body.SetItem(al_row, "size", ls_null)
//
Return True

end function

public function boolean wf_style_set (long al_row, string as_style, string as_flag);String  ls_style,       ls_to_ymd,      ls_sale_type_chk = space(2)
Long    ll_row,         ll_dc_rate_chk, ll_curr_price_chk,          ll_out_price_chk
Decimal ldc_margin_chk, ldc_dc_rate_chk

String  ls_null,        ls_sale_type = space(2)
Long    ll_curr_price,  ll_out_price
decimal ldc_margin,     ldc_dc_rate

SetNull(ls_null) 

If as_flag = 'RTN' Then
	/* 발송(반품)시 마진율 체크 */
	IF gf_outmarjin (is_yymmdd,    is_fr_shop_cd, is_fr_shop_type, as_style, & 
							ls_sale_type, ldc_margin,    ldc_dc_rate,      ll_curr_price, ll_out_price) = FALSE THEN 
		RETURN False 
	END IF
	
	// 발송(반품)시 기준 마진율과 동일한지 CHECK
	ll_row = dw_body.Find(" IsRowNew() And Not(IsNull(style_no)) ", 1, al_row - 1)
	If ll_row < 1 Then
		ll_row = dw_body.Find(" IsRowNew() And Not(IsNull(style_no)) ", al_row + 1, dw_body.RowCount())
	End If
	
	If ll_row > 0 Then
//		ls_style         = Left(dw_body.GetItemString(ll_row, "style_no"), 8)
		ls_sale_type_chk = dw_body.GetItemString (ll_row, "rtn_sale_type")
		ldc_margin_chk   = dw_body.GetItemDecimal(ll_row, "rtn_margin_rate")
//		/* 발송(반품)시 기준마진율 체크 */
//		IF gf_out_marjin (is_to_ymd,        is_fr_shop_cd,  is_fr_shop_type, ls_style, & 
//								ls_sale_type_chk, ldc_margin_chk, ll_dc_rate_chk,  ll_curr_price_chk, ll_out_price_chk) = FALSE THEN 
//			RETURN False 
//		END IF
		
		If ls_sale_type_chk <> ls_sale_type or ldc_margin_chk <> ldc_margin Then
			MessageBox("입력오류", "발송(반품) 마진율이 다릅니다!")
			Return False
		End If
	End If

	/*색상 및 사이즈 클리어 */
	dw_body.Setitem(al_row, "color", ls_null)
	dw_body.Setitem(al_row, "size",  ls_null)
	
	/* 단가 및 율 등록 */
	dw_body.Setitem(al_row, "rtn_sale_type",   ls_sale_type )
	dw_body.Setitem(al_row, "move_qty",        1            )
	dw_body.Setitem(al_row, "rtn_margin_rate", ldc_margin   )
	dw_body.Setitem(al_row, "rtn_disc_rate",   ldc_dc_rate   )
	dw_body.Setitem(al_row, "rtn_curr_price",  ll_curr_price)
	dw_body.Setitem(al_row, "rtn_out_price",   ll_out_price )
End If

/* 인수(출고)시 마진율 체크 */
IF gf_outmarjin (is_to_ymd,    is_to_shop_cd, is_to_shop_type, as_style, & 
						ls_sale_type, ldc_margin,    ldc_dc_rate,      ll_curr_price, ll_out_price) = FALSE THEN 
	RETURN False 
END IF

// 인수(출고)시 기준 마진율과 동일한지 CHECK
//If dw_body.GetItemStatus(al_row, 0, Primary!) = NewModified! Then
	ll_row = dw_body.Find(" proc_chk = 'N' And proc_yn = 'Y'", 1, al_row - 1)
	If ll_row < 1 Then
		ll_row = dw_body.Find(" proc_chk = 'N' And proc_yn = 'Y'", al_row + 1, dw_body.RowCount())
	End If
	
	If ll_row > 0 Then
//		ls_style  = Left(dw_body.GetItemString(ll_row, "style_no"), 8)
		ls_sale_type_chk = dw_body.GetItemString (ll_row, "out_sale_type")
		ldc_margin_chk   = dw_body.GetItemDecimal(ll_row, "out_margin_rate")
//		/* 인수(출고)시 기준마진율 체크 */
//		IF gf_out_marjin (is_to_ymd,        is_to_shop_cd,  is_to_shop_type, ls_style, & 
//								ls_sale_type_chk, ldc_margin_chk, ll_dc_rate_chk,  ll_curr_price_chk, ll_out_price_chk) = FALSE THEN 
//			RETURN False 
//		END IF
		
		If ls_sale_type_chk <> ls_sale_type or ldc_margin_chk <> ldc_margin Then
			MessageBox("입력오류", "인수(출고) 마진율이 다릅니다!")
			Return False
		End If
	End If
//End If

/* 단가 및 율 등록 */
dw_body.Setitem(al_row, "out_sale_type",   ls_sale_type )
dw_body.Setitem(al_row, "out_margin_rate", ldc_margin   )
dw_body.Setitem(al_row, "out_disc_rate",   ldc_dc_rate   )
dw_body.Setitem(al_row, "out_curr_price",  ll_curr_price)
dw_body.Setitem(al_row, "out_out_price",   ll_out_price )

/* 금액 처리 */
wf_amt_set(al_row, dw_body.GetItemDecimal(al_row, "move_qty"), as_flag)

RETURN True

end function

public function boolean wf_stock_chk (long al_row, long al_qty);String ls_style, ls_chno, ls_color, ls_size , ls_find
Long   ll_stock_qty, ll_cnt_stop, ll_row_count, i, k, ll, ll_chk_qty


ls_style = dw_body.getitemstring(al_row,"style_no")
ls_chno  = MidA(ls_style, 9, 1)
ls_color = dw_body.getitemstring(al_row,"color")
ls_size  = dw_body.getitemstring(al_row,"size")

select dbo.sf_get_stockqty(:is_fr_shop_cd, :is_fr_shop_type, :ls_style, :ls_chno, :ls_color, :ls_size)
  into :ll_stock_qty
  from dual;

//messagebox("ll_stock_qty", string(ll_stock_qty))


if MidA(is_fr_shop_cd,2,1) = "X" then 
	IF ll_stock_qty - al_qty < 0 THEN 
	MessageBox("확인", ls_style +ls_chno + ls_color + ls_size + " 재고수량: " + string(ll_stock_qty) + ", 재고가 없는 제품은 의뢰할수 없습니다!") 
	RETURN FALSE 
	END IF
end if
  


Return True

end function

public subroutine wf_amt_set (long al_row, long al_qty, string as_flag);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_out_price
Long ll_out_amt 
Decimal ldc_marjin

If as_flag = 'RTN' Then
//	ll_tag_price  = dw_body.GetitemDecimal(al_row, "tag_price" ) 
	ll_curr_price = dw_body.GetitemNumber (al_row, "rtn_curr_price") 
	ll_out_price  = dw_body.GetitemNumber (al_row, "rtn_out_price" ) 
	ll_out_amt    = ll_out_price * al_qty   
	
//	dw_body.Setitem(al_row, "tag_amt",      ll_tag_price  * al_qty)
	dw_body.Setitem(al_row, "rtn_curr_amt", ll_curr_price * al_qty)
	dw_body.Setitem(al_row, "rtrn_collect", ll_out_amt            ) 
	dw_body.Setitem(al_row, "rtn_vat",      ll_out_amt - Round(ll_out_amt / 1.1, 0))
End If

ll_tag_price  = dw_body.GetitemDecimal(al_row, "tag_price"     ) 
ll_curr_price = dw_body.GetitemNumber (al_row, "out_curr_price") 
ll_out_price  = dw_body.GetitemNumber (al_row, "out_out_price" ) 
ll_out_amt    = ll_out_price * al_qty   

dw_body.Setitem(al_row, "tag_amt",      ll_tag_price  * al_qty)
dw_body.Setitem(al_row, "out_curr_amt", ll_curr_price * al_qty)
dw_body.Setitem(al_row, "out_collect",  ll_out_amt            ) 
dw_body.Setitem(al_row, "out_vat",      ll_out_amt - Round(ll_out_amt / 1.1, 0))

end subroutine

on w_53003_e.create
int iCurrent
call super::create
this.dw_out=create dw_out
this.dw_rtn=create dw_rtn
this.cbx_laser=create cbx_laser
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_out
this.Control[iCurrent+2]=this.dw_rtn
this.Control[iCurrent+3]=this.cbx_laser
end on

on w_53003_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_out)
destroy(this.dw_rtn)
destroy(this.cbx_laser)
end on

event open;call super::open;dw_head.SetItem(1, "to_ymd", dw_head.GetItemDatetime(1, "yymmdd"))

select data_level
into :is_data_opt
from tb_93010_m
where person_id = :gs_user_id;
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.14                                                  */	
/* 수정일      : 2002.03.14                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_style, ls_chno, ls_given_fg, ls_given_ymd, ls_shop_type,ls_work_gubn
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "fr_shop_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				if gs_brand <> 'K' then
					IF IsNull(as_data) or Trim(as_data) = "" THEN
						dw_head.SetItem(al_row, "fr_shop_nm", "")
						RETURN 0
					END IF 
					IF LeftA(as_data, 1) = is_brand and gf_shop_nm3(as_data, 'S', ls_shop_nm) = 0 THEN
						dw_head.SetItem(al_row, "fr_shop_nm", ls_shop_nm)
						RETURN 0
					END IF 
				end if
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND     = '" + is_brand + "' " + &
			                         "  AND SHOP_STAT = '00' "
			
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
				dw_head.SetItem(al_row, "fr_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "fr_shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("fr_shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			
	CASE "to_shop_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "to_shop_nm", "")
					RETURN 0
				END IF 
				IF LeftA(as_data, 1) = is_brand and gf_shop_nm3(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "to_shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND     = '" + is_brand + "' " + &
			                         "  AND SHOP_STAT = '00' "
			
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
				dw_head.SetItem(al_row, "to_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "to_shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("to_shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			
	CASE "style_no"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_body.SetItem(al_row, "move_qty",  0  )
				   dw_body.SetItem(al_row, "tag_price", 0  )
				   dw_body.SetItem(al_row, "color",     "" )
				   dw_body.SetItem(al_row, "size",      "" )
				   dw_body.SetItem(al_row, "proc_yn",   "N")
					RETURN 0
				END IF 
				IF wf_style_chk(al_row, as_data, 'RTN')  THEN 
					RETURN 2
				END IF 
			END IF
			
			IF al_row > 1 and LenA(Trim(as_data)) <> 9 THEN 
				gf_style_edit(dw_body.Object.style_no[al_row - 1], as_data, ls_style, ls_chno)
			ELSE
		      ls_style = MidA(as_data, 1, 8)
		      ls_chno  = MidA(as_data, 9, 1)
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com013" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' "
			
			IF (MidA(is_fr_shop_cd, 2, 1) = 'X' OR MidA(is_fr_shop_cd, 2, 1) = 'T') Then
				If (MidA(is_to_shop_cd, 2, 1) = 'X' OR MidA(is_to_shop_cd, 2, 1) = 'T') THEN 
				ElseIf is_to_shop_type = '1' Then
					gst_cd.default_where   = gst_cd.default_where + "AND PLAN_YN = 'N'"
				ElseIf is_to_shop_type = '3' Then
					gst_cd.default_where   = gst_cd.default_where + "AND PLAN_YN = 'Y'"
				ElseIf is_to_shop_type = '4' Then
					gst_cd.default_where   = gst_cd.default_where + "AND PLAN_YN = 'N'"					
				End If
			ELSEIF is_fr_shop_type = '1' THEN 
				gst_cd.default_where   = gst_cd.default_where + "AND PLAN_YN = 'N'"
			ELSEIF is_fr_shop_type = '3' THEN
				gst_cd.default_where   = gst_cd.default_where + "AND PLAN_YN = 'Y'"
			ElseIf is_to_shop_type = '4' Then
 			   gst_cd.default_where   = gst_cd.default_where + "AND PLAN_YN = 'N'"									
			END IF
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "STYLE  LIKE '" + ls_style + "%'" + &
				                " AND CHNO  LIKE '" + ls_chno  + "%'" 
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
				dw_body.SetItem(al_row, "tag_price", lds_Source.GetItemDecimal(1,"tag_price")) 
				ls_style = lds_Source.GetItemString(1, "style")

// 품번 판매형태 체크 제한
//is_fr_shop_cd, is_fr_shop_type
//	if is_fr_shop_type =  "4"  or is_fr_shop_type =  "1" then
//				Select shop_type
//				into :ls_shop_type
//				From tb_56012_d with (nolock)
//				Where style      = :ls_style 
//				  and start_ymd <= :is_yymmdd
//				  and end_ymd   >= :is_yymmdd
//				  and shop_cd    = :is_fr_shop_cd ;
//				  
//			if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
//				if is_fr_shop_type = '3' then
//				 ls_shop_type = '3'
//   			else 
//				 ls_shop_type = '1'	
// 				end if 
//			end if	 
//				
//				if is_fr_shop_type <> ls_shop_type then 
//					messagebox("경고!", "제품등록이 가능한 매장형태는 " + ls_shop_type + " 입니다!")
//					ib_itemchanged = FALSE
//					return 1
//				end if
//	end if				
//	
//	if is_to_shop_type = "4" or is_to_shop_type = "1" then
//				Select shop_type
//				into :ls_shop_type
//				From tb_56012_d with (nolock)
//				Where style      = :ls_style 
//				  and start_ymd <= :is_yymmdd
//				  and end_ymd   >= :is_yymmdd
//				  and shop_cd    = :is_to_shop_cd ;
//				  
//			if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
//				if is_to_shop_type = '3' then
//				 ls_shop_type = '3'
//   			else 
//				 ls_shop_type = '1'	
// 				end if 
//			end if	 
//				
//				if is_to_shop_type <> ls_shop_type then 
//					messagebox("경고!", "제품등록이 가능한 매장형태는 " + ls_shop_type + " 입니다!")
//					ib_itemchanged = FALSE
//					return 1
//				end if
//	end if					
				
// 사은품 전환 체크 제한

//				select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
//				into  :ls_given_fg, :ls_given_ymd
//				from beaucre.dbo.tb_12020_m with (nolock)
//				where style like :ls_style + '%';			
//
//
//				IF ls_given_fg = "Y"  AND  ls_given_ymd >= is_yymmdd  THEN
//					messagebox("품번검색", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")					
//					dw_body.SetItem(al_row, "style_no", "")
//					ib_itemchanged = FALSE
//					return 1 	
//				END IF 							
				
				
				select 
				isnull(given_ymd, 'XXXXXXXX'), isnull(work_gubn,'A')
				into  :ls_given_ymd, :ls_work_gubn
				from tb_56040_m with (nolock)
				where style = :ls_style
				and   work_gubn in ('A','O') ;				
					
				IF ls_given_ymd >= is_yymmdd  and isnull(ls_work_gubn) = true THEN
					messagebox("품번검색", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				END IF 			
						
				
 				IF wf_style_set(al_row, ls_style, 'RTN') THEN 
				   dw_body.SetItem(al_row, "style_no", ls_style + lds_Source.GetItemString(1,"chno") )
				   dw_body.SetItem(al_row, "style",    ls_style   )
				   dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno")    )
				   dw_body.SetItem(al_row, "color",    lds_Source.GetItemString(1,"color")   )
				   dw_body.SetItem(al_row, "size",     lds_Source.GetItemString(1,"size")    )					
				   dw_body.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand")   )
				   dw_body.SetItem(al_row, "year",     lds_Source.GetItemString(1,"year")    )
				   dw_body.SetItem(al_row, "season",   lds_Source.GetItemString(1,"season")  )
				   dw_body.SetItem(al_row, "sojae",    lds_Source.GetItemString(1,"sojae")   )
				   dw_body.SetItem(al_row, "item",     lds_Source.GetItemString(1,"item")    )
					ib_changed = true
					lb_check = TRUE 
					cb_update.enabled = true
				   /* 다음컬럼으로 이동 */
			      dw_body.SetColumn("move_qty")
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

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.14                                                  */	
/* 수정일      : 2002.03.14                                                  */
/*===========================================================================*/
Long ll_dc_rate, ll_curr_price, ll_out_price
String ls_style

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd, &
									is_fr_shop_cd, is_fr_shop_type, is_to_shop_cd, is_to_shop_type)

IF il_rows > 0 THEN
   dw_body.SetFocus()
Else
	il_rows = dw_body.InsertRow(1)
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.14                                                  */	
/* 수정일      : 2002.03.14                                                  */
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
   MessageBox(ls_title, "브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymmdd = Trim(String(dw_head.GetItemDatetime(1, "yymmdd"), 'yyyymmdd'))
if IsNull(is_yymmdd) or is_yymmdd = "" then
   MessageBox(ls_title, "기등록 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_to_ymd = Trim(String(dw_head.GetItemDatetime(1, "to_ymd"), 'yyyymmdd'))
if IsNull(is_to_ymd) or is_to_ymd = "" then
   MessageBox(ls_title, "신규등록 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_fr_shop_cd = Trim(dw_head.GetItemString(1, "fr_shop_cd"))
if IsNull(is_fr_shop_cd) or is_fr_shop_cd = "" then
   MessageBox(ls_title, "발송매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_shop_cd")
   return false
end if

is_fr_shop_type = Trim(dw_head.GetItemString(1, "fr_shop_type"))
if IsNull(is_fr_shop_type) or is_fr_shop_type = "" then
   MessageBox(ls_title, "발송매장 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_shop_type")
   return false
end if

is_to_shop_cd = Trim(dw_head.GetItemString(1, "to_shop_cd"))
if IsNull(is_to_shop_cd) or is_to_shop_cd = "" then
   MessageBox(ls_title, "인수매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_shop_cd")
   return false
end if

is_to_shop_type = Trim(dw_head.GetItemString(1, "to_shop_type"))
if IsNull(is_to_shop_type) or is_to_shop_type = "" then
   MessageBox(ls_title, "인수매장 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_shop_type")
   return false
end if

If (MidA(is_fr_shop_cd, 2, 1) = 'X' OR MidA(is_fr_shop_cd, 2, 1) = 'T') THEN 
ElseIf is_fr_shop_type = '1' Then
	If (MidA(is_to_shop_cd, 2, 1) = 'X' OR MidA(is_to_shop_cd, 2, 1) = 'T') THEN 
	ElseIf is_to_shop_type = '3' Then
		MessageBox(ls_title, "정상 매장에서 기획 매장으로 이송할 수 없습니다!")
		dw_head.SetFocus()
		dw_head.SetColumn("to_shop_type")
	   return false
	End If
ElseIf is_fr_shop_type = '3' Then
	If (MidA(is_to_shop_cd, 2, 1) = 'X' OR MidA(is_to_shop_cd, 2, 1) = 'T') THEN 
	ElseIf is_to_shop_type = '1' Then
		MessageBox(ls_title, "기획 매장에서 정상 매장으로 이송할 수 없습니다!")
		dw_head.SetFocus()
		dw_head.SetColumn("to_shop_type")
		return false
	End If
End If

return true

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.14                                                  */	
/* 수정일      : 2002.03.14                                                  */
/*===========================================================================*/
Long i, ll_row_count, ll_rtn_row = 0, ll_out_row = 0
String ls_rtn_no, ls_out_no, ls_rtn_row, ls_out_row, ls_to_out_no, ls_rt_yn,ls_tran_cust,ls_tran_type
Decimal ldc_move_qty
Datetime ld_datetime
Long ll_rtn_rows, ll_out_rows, ll_qty
integer li_result,li_box_no

IF is_data_opt = "V" THEN
	MessageBox("경고", "저장권한이 없습니다 !") 
	Return 0
END IF

li_result = MessageBox("경고!", "저장작업을 진행하시겠습니까?" , Exclamation!, OKCancel!, 2)

IF li_result <> 1 THEN
	Return -1
END IF

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF



dw_rtn.Reset()
dw_out.Reset()

// 반품번호 채번
If gf_style_outno(is_yymmdd, is_brand, ls_rtn_no) = False Then
	MessageBox("저장오류", "반품번호 채번에 실패하였습니다!")
	Return -1
End IF

// 출고번호 채번
If gf_style_outno(is_to_ymd, is_brand, ls_out_no) = False Then
	MessageBox("저장오류", "출고번호 채번에 실패하였습니다!")
	Return -1
End IF

ll_row_count = dw_body.RowCount()

FOR i=1 TO ll_row_count   
	  ll_qty = dw_body.GetitemNumber(i, "move_qty")
	  if wf_stock_chk( i, ll_qty) = false then
				Return -1
	  end if	
	  
	  if ll_qty < 1 then
		  messagebox('확인','이송량에 0 또는  - 는 넣을 수 없습니다!')
		  return -1
	  end if
next  

//
//FOR i=1 TO ll_row_count   
//	ls_tran_cust  = dw_body.GetitemString(i, "tb_53020_h_tran_cust") 
//	ls_tran_type  = dw_body.GetitemString(i, "tb_53020_h_tran_type") 	
//	li_box_no     = dw_body.GetitemNumber(i, "tb_53020_h_box_no")
//	
//	idw_status = dw_body.GetItemStatus(i, 0, Primary!)
//	
//   IF idw_status = NewModified! or idw_status = DataModified!  THEN				/* New Record */
//
//		if  isnull(ls_tran_cust) = true or len(ls_tran_cust) = 0 then 	
//				messagebox("경고!" , "이송업체 없이 등록할 수 없습니다!")
//				return -1
//		end if			
//		
//		if  isnull(ls_tran_type) = true or len(ls_tran_type) = 0 then 	
//				messagebox("경고!" , "이송형태 없이 등록할 수 없습니다!")
//				return -1
//		end if				
//	
//		
//		if  (ls_tran_type = '201' or ls_tran_type = '202' or ls_tran_type = '701' 	or ls_tran_type = '702' or ls_tran_type = '802' or ls_tran_type = '803') and li_box_no = 0  then 	
//				messagebox("경고!" , "박스번호없이 등록할 수 없습니다!")
//				return -1
//		end if			
//	end if
//next	




FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified!  THEN				/* New Record */
		ldc_move_qty = dw_body.GetItemDecimal(i, "move_qty")
		If IsNull(ldc_move_qty) or ldc_move_qty = 0 Then
			dw_body.SetItemStatus(i, 0, Primary!, NotModified!)
		Else
			ll_rtn_row++
			ls_rtn_row = String(ll_rtn_row, '0000')
			wf_data_set(i, ls_rtn_no, ls_rtn_row, 'RTN')
			dw_body.Setitem(i, "fr_ymd",       is_yymmdd      )
			dw_body.Setitem(i, "fr_shop_cd",   is_fr_shop_cd  )
			dw_body.Setitem(i, "fr_shop_type", is_fr_shop_type)
			dw_body.Setitem(i, "fr_rtn_no",    ls_rtn_no      )
			dw_body.Setitem(i, "fr_no",        ls_rtn_row     )
			dw_body.Setitem(i, "to_shop_cd",   is_to_shop_cd  )
			dw_body.Setitem(i, "to_shop_type", is_to_shop_type)
			dw_body.Setitem(i, "brand",        is_brand       )
			dw_body.Setitem(i, "reg_id",       gs_user_id     )
			If dw_body.GetItemString(i, "proc_yn") = 'Y' Then
				ll_out_row++
				ls_out_row = String(ll_out_row, '0000')
				wf_data_set(i, ls_out_no, ls_out_row, 'OUT')
				dw_body.Setitem(i, "to_ymd",    is_to_ymd )
				dw_body.Setitem(i, "to_out_no", ls_out_no )
				dw_body.Setitem(i, "to_no",     ls_out_row)
			End If
		End If
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		ls_to_out_no = dw_body.GetItemString(i, "to_out_no")
		ls_rt_yn = dw_body.GetItemString(i, "rt_yn")
		If dw_body.GetItemString(i, "proc_yn") = 'Y'  and isnull(ls_to_out_no) Then
			ll_out_row++
			ls_out_row = String(ll_out_row, '0000')
			wf_data_set(i, ls_out_no, ls_out_row, 'OUT')
			dw_body.Setitem(i, "to_ymd",    is_to_ymd  )
			dw_body.Setitem(i, "to_out_no", ls_out_no  )
			dw_body.Setitem(i, "to_no",     ls_out_row )
			dw_body.Setitem(i, "mod_id",    gs_user_id )
			dw_body.Setitem(i, "mod_dt",    ld_datetime)
		elseif  (dw_body.GetItemString(i, "rt_yn")  = 'Y' or dw_body.GetItemString(i, "proc_yn") = 'N'	)then		
			dw_body.Setitem(i, "mod_id",    gs_user_id )
			dw_body.Setitem(i, "mod_dt",    ld_datetime)			
		Else
			dw_body.SetItemStatus(i, 0, Primary!, NotModified!)
		End If
   END IF
NEXT

il_rows     = dw_body.Update(TRUE, FALSE)
ll_rtn_rows = dw_rtn. Update(TRUE, FALSE)
ll_out_rows = dw_out. Update(TRUE, FALSE)

if il_rows = 1 and ll_rtn_rows = 1 and ll_out_rows = 1 then
   dw_body.ResetUpdate()
   dw_rtn. ResetUpdate()
   dw_out. ResetUpdate()
   commit USING SQLCA;
	dw_body.retrieve(is_brand, is_yymmdd, &
						  is_fr_shop_cd, is_fr_shop_type, is_to_shop_cd, is_to_shop_type)
else
   rollback USING SQLCA;
	il_rows = -1
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event pfc_preopen;call super::pfc_preopen;dw_rtn.SetTransObject(SQLCA)
dw_out.SetTransObject(SQLCA)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53003_e","0")
end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long   i 
String ls_fr_shop_type, ls_fr_out_no, ls_fr_out_nob, ls_fr_shop_cd, ls_fr_yymmdd, ls_yymmdd, ls_print, ls_inout_gubn, ls_out_gubn
String ls_to_shop_type, ls_to_out_no, ls_to_out_nob, ls_to_shop_cd, ls_to_yymmdd, ls_proc_yn

if cbx_laser.checked then
	dw_print.DataObject = "d_com420_A1"
	dw_print.SetTransObject(SQLCA)
ELSE
	dw_print.DataObject = "d_com420"
	dw_print.SetTransObject(SQLCA)
END IF	


FOR i = 1 TO dw_body.RowCount() 
		ls_proc_yn = dw_body.GetitemString(i, "proc_yn")	
	if ls_proc_yn = "Y" then

		
		ls_fr_yymmdd     = dw_body.GetitemString(i, "fr_ymd")			 
		ls_fr_out_no     = dw_body.GetitemString(i, "fr_rtn_no")
		ls_fr_shop_cd 	  = dw_body.GetitemString(i, "fr_shop_cd") 
		ls_fr_shop_type  = dw_body.GetitemString(i, "fr_shop_type")

		if ls_fr_out_no <> ls_fr_out_nob then
		
			il_rows = dw_print.Retrieve(is_brand, ls_fr_yymmdd, ls_fr_shop_cd, ls_fr_shop_type, ls_fr_out_no, '2')
			IF dw_print.RowCount() > 0 Then
				il_rows = dw_print.Print()
			END IF		
			ls_fr_out_nob = ls_fr_out_no
		end if	

		
		ls_to_yymmdd     = dw_body.GetitemString(i, "to_ymd")			 
		ls_to_out_no     = dw_body.GetitemString(i, "to_out_no")
		ls_to_shop_cd 	  = dw_body.GetitemString(i, "to_shop_cd") 
		ls_to_shop_type  = dw_body.GetitemString(i, "to_shop_type")

		if ls_to_out_no <> ls_to_out_nob then

			il_rows = dw_print.Retrieve(is_brand, ls_to_yymmdd, ls_to_shop_cd, ls_to_shop_type, ls_to_out_no, '1')
			IF dw_print.RowCount() > 0 Then
				il_rows = dw_print.Print()
			END IF	
			ls_to_out_nob = ls_to_out_no		
		end if
	end if	
NEXT 
	
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_insert();string ls_tran_cust, ls_tran_type
long li_box_no

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

il_rows = dw_body.InsertRow(0)

///* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
//if il_rows > 0 then
//	dw_body.ScrollToRow(il_rows)
//	dw_body.SetColumn(ii_min_column_id)
//	dw_body.SetFocus()
//end if

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	ls_tran_cust = dw_body.getitemstring(il_rows -1, "tb_53020_h_tran_cust")
	ls_tran_type = dw_body.getitemstring(il_rows -1, "tb_53020_h_tran_type")	

	if  ls_tran_type = '201' or ls_tran_type = '202' or ls_tran_type = '701' 	or ls_tran_type = '702' or ls_tran_type = '802' or ls_tran_type = '803'  then 	
		li_box_no = dw_body.getitemNumber(il_rows -1, "tb_53020_h_box_no")	
	else	
		li_box_no = 0
	end if	

	dw_body.Setitem(il_rows, "tb_53020_h_tran_cust", ls_tran_cust)
	dw_body.Setitem(il_rows, "tb_53020_h_tran_type", ls_tran_type)
	dw_body.Setitem(il_rows, "tb_53020_h_box_no", li_box_no)	
	
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if


This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_53003_e
end type

type cb_delete from w_com010_e`cb_delete within w_53003_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_53003_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_53003_e
end type

type cb_update from w_com010_e`cb_update within w_53003_e
end type

type cb_print from w_com010_e`cb_print within w_53003_e
integer width = 439
string text = "거래명세서(&P)"
end type

type cb_preview from w_com010_e`cb_preview within w_53003_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_53003_e
end type

type cb_excel from w_com010_e`cb_excel within w_53003_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_53003_e
integer width = 3502
integer height = 316
string dataobject = "d_53003_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("fr_shop_type", idw_fr_shop_type)
idw_fr_shop_type.SetTransObject(SQLCA)
idw_fr_shop_type.Retrieve('911')

This.GetChild("to_shop_type", idw_to_shop_type)
idw_to_shop_type.SetTransObject(SQLCA)
idw_to_shop_type.Retrieve('911')

end event

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.14                                                  */	
/* 수정일      : 2002.03.14                                                  */
/*===========================================================================*/
String ls_fr_shop_type

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(row, "fr_shop_cd", "")
		This.SetItem(row, "fr_shop_nm", "")
		This.SetItem(row, "to_shop_cd", "")
		This.SetItem(row, "to_shop_nm", "")
	CASE "to_ymd","yymmdd"
		If gf_iwoldate_chk(gs_user_id, is_pgm_id, LeftA(data, 4) + MidA(data, 6, 2) + MidA(data, 9, 2) ) = False Then
			MessageBox("입력오류", "일자를 소급할 수 없습니다!")
			Return 1
		End If
		
//	CASE "fr_shop_type"
//		This.SetItem(row, "to_shop_type", "")
//		
//	CASE "to_shop_type"
//		ls_fr_shop_type = This.GetItemString(row, "fr_shop_type")
//		If ls_fr_shop_type = '1' Then
//			If data = '3' Then Return 1
//		ElseIf ls_fr_shop_type = '3' Then
//			If data = '1' Then Return 1
//		End If
			
	CASE "fr_shop_cd", "to_shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_53003_e
integer beginy = 520
integer endy = 520
end type

type ln_2 from w_com010_e`ln_2 within w_53003_e
integer beginy = 524
integer endy = 524
end type

type dw_body from w_com010_e`dw_body within w_53003_e
integer y = 540
integer height = 1500
string dataobject = "d_53003_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child
string ls_filter_str

This.GetChild("tb_53020_h_tran_cust", idw_tran_cust)
idw_tran_cust.SetTransObject(SQLCA)
idw_tran_cust.Retrieve('404')


ls_filter_str = "inter_cd in ('M02','M07','M08') " 
idw_tran_cust.SetFilter(ls_filter_str)
idw_tran_cust.Filter( )
idw_tran_cust.InsertRow(1)
idw_tran_cust.SetItem(1, "inter_cd", '')
idw_tran_cust.SetItem(1, "inter_nm", '')


This.GetChild("tb_53020_h_tran_type", idw_tran_type)
idw_tran_type.SetTransObject(SQLCA)
idw_tran_type.Retrieve('406','%')
idw_tran_type.InsertRow(1)
idw_tran_type.SetItem(1, "inter_cd", '')
idw_tran_type.SetItem(1, "inter_nm", '')

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.InsertRow(0)

This.GetChild("color_nm", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

This.GetChild("size", idw_size)
idw_size.SetTransObject(SQLCA)
idw_size.InsertRow(0)

This.GetChild("size_nm", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

This.GetChild("rtn_sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

This.GetChild("out_sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;String ls_style_no, ls_color,ls_tran_cust, ll

CHOOSE CASE dwo.name
	CASE "color"
		ls_style_no = This.GetItemString(row, "style_no")
		idw_color.Retrieve(LeftA(ls_style_no, 8), MidA(ls_style_no, 9, 1))
		idw_color.insertRow(1)
		idw_color.Setitem(1, "color", "XX")
		idw_color.Setitem(1, "color_enm", "XX")
	CASE "size"
		ls_style_no = This.GetItemString(row, "style_no")
		ls_color    = This.GetItemString(row, "color")
		idw_size.Retrieve(LeftA(ls_style_no, 8), MidA(ls_style_no, 9, 1), ls_color)
		idw_size.insertRow(1)
		idw_size.Setitem(1, "size", "XX")
		idw_size.Setitem(1, "size_nm", "XX")	
	CASE "tb_53020_h_tran_type"
		ls_tran_cust = This.GetItemString(row, "tb_53020_h_tran_cust")
		idw_tran_type.Retrieve('406', ls_tran_cust)		
	
		
END CHOOSE


end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.14                                                  */	
/* 수정일      : 2002.03.14                                                  */
/*===========================================================================*/
String ls_style
Long   ll_ret

CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		ll_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1) 
		
		IF LenA(This.GetitemString(row, "color")) = 2 THEN
			This.SetColumn("sale_qty")
//			This.Post Event ue_set_col("sale_qty")
		END IF 
		
		Return ll_ret
		
	CASE "move_qty"
		if wf_stock_chk(row, Long(data)) <> false then
			wf_amt_set(row, Long(data), 'RTN')
		else 
			Return 1
		end if	
		
	CASE "proc_yn"
		If data = 'Y' Then
			ls_style = LeftA(This.GetItemString(row, "style_no"), 8)
			IF wf_style_set(row, ls_style, 'OUT') = False THEN 
				Return 1
			END IF
		End If
		
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

event dw_body::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.06.19                                                  */	
/* 수정일      : 2002.06.19                                                  */
/*===========================================================================*/
Long i
String ls_style, ls_proc_yn, ls_proc_chk

If dwo.name = 'b_proc_yn' Then
	If dwo.Text = '선택' Then
		For i = 1 To This.RowCount()
			ls_proc_chk = dw_body.getitemstring(i, "proc_chk")
			
			if ls_proc_chk = "N" then
				ls_style = LeftA(This.GetItemString(i, "style_no"), 8)
				IF wf_style_set(i, ls_style, 'OUT') THEN 
					This.SetItem(i, "proc_yn", 'Y')
				Else
					This.SetItem(i, "proc_yn", 'N')
				END IF
			end if	
			
		Next

		dwo.Text = '제외'
		
	ElseIf dwo.Text = '제외' Then
		For i = 1 To This.RowCount()
			ls_proc_chk = dw_body.getitemstring(i, "proc_chk")
			
			if ls_proc_chk = "N" then
				This.SetItem(i, "proc_yn", 'N')
			end if	
		Next

		dwo.Text = '선택'

	End If
End If

end event

event dw_body::editchanged;call super::editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.14                                                  */	
/* 수정일      : 2002.03.14                                                  */
/*===========================================================================*/
String ls_style
Long   ll_ret

CHOOSE CASE dwo.name
	CASE "move_qty"
		dw_body.accepttext()
		ll_ret = dw_body.getitemnumber(row,'move_qty')
		if ll_ret < 1 then
			messagebox('확인','이송량에 0 또는  - 는 넣을 수 없습니다!')
			dw_body.setitem(row,'move_qty',1)
			Return 
		end if
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_53003_e
integer x = 288
integer y = 1132
integer width = 3346
integer height = 932
boolean titlebar = true
string dataobject = "d_com420"
end type

type dw_out from u_dw within w_53003_e
boolean visible = false
integer x = 2455
integer y = 964
integer width = 448
integer height = 356
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_53003_d03"
boolean hscrollbar = true
end type

event dberror;//

end event

type dw_rtn from u_dw within w_53003_e
boolean visible = false
integer x = 1911
integer y = 976
integer width = 448
integer height = 356
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_53003_d02"
boolean hscrollbar = true
end type

event dberror;//
end event

type cbx_laser from checkbox within w_53003_e
integer x = 2921
integer y = 208
integer width = 535
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
string text = " 명세서(laser)"
borderstyle borderstyle = stylelowered!
end type

