$PBExportHeader$w_42003_e.srw
$PBExportComments$반품등록
forward
global type w_42003_e from w_com010_e
end type
type cb_input from commandbutton within w_42003_e
end type
type cb_copy from commandbutton within w_42003_e
end type
type cb_1 from commandbutton within w_42003_e
end type
type dw_stock from datawindow within w_42003_e
end type
type dw_1 from datawindow within w_42003_e
end type
type dw_list from datawindow within w_42003_e
end type
type cb_print1 from commandbutton within w_42003_e
end type
type cbx_a4 from checkbox within w_42003_e
end type
type cbx_laser from checkbox within w_42003_e
end type
end forward

global type w_42003_e from w_com010_e
event ue_input ( )
event ue_print1 ( )
cb_input cb_input
cb_copy cb_copy
cb_1 cb_1
dw_stock dw_stock
dw_1 dw_1
dw_list dw_list
cb_print1 cb_print1
cbx_a4 cbx_a4
cbx_laser cbx_laser
end type
global w_42003_e w_42003_e

type variables
DataWindowChild    idw_brand, idw_color,    idw_size
String is_house,   is_brand,     is_yymmdd,  is_out_no
String is_shop_cd, is_shop_type, is_shop_ymd , is_rqst_gubn, is_note, is_brand_grp

end variables

forward prototypes
public function boolean wf_margin_set (long al_row, string as_style)
public function boolean wf_margin_set_color (long al_row, string as_style, string as_color)
public subroutine wf_amt_set (long al_row, long al_qty, long al_curr_price)
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

event ue_input();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
dw_list.Visible   = False
dw_1.Visible      = True
dw_stock.Visible  = True
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
 				 IF is_shop_cd <> "NX7997"  then
	 				 IF is_shop_cd <> "WT3531"  then
						 IF is_shop_cd <> "CT3516"  then					
							if is_brand <> LeftA(is_shop_cd,1) then
								MessageBox("경고","매장 코드와 브랜드를 확인 하십시요!")
								return 
							end if
						 END IF	
					END IF	 
			    END IF
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

event ue_print1();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long   i,j
String ls_shop_type, ls_out_no, ls_jup_name, ls_modify, ls_Error

dw_print.DataObject = "d_com420_a4"
dw_print.SetTransObject(SQLCA)
		
if cbx_a4.checked then 		
		IF dw_list.Visible THEN
			ls_jup_name = "(매 장 용)"			
					 
				FOR i = 1 TO dw_list.RowCount() 
					IF ls_out_no <> dw_list.object.out_no[i] OR ls_shop_type <> dw_list.object.shop_type[i] THEN 
						ls_out_no    = dw_list.GetitemString(i, "out_no")
						ls_shop_type = dw_list.GetitemString(i, "shop_type")
						dw_print.Retrieve(is_brand, is_yymmdd, is_shop_cd, ls_shop_type, ls_out_no, '2')
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

		ELSE 
					ls_jup_name = "(매 장 용)"			
						ls_out_no    = dw_body.GetitemString(1, "out_no")
						ls_shop_type = dw_body.GetitemString(1, "shop_type")
						dw_print.Retrieve(is_brand, is_yymmdd, is_shop_cd, ls_shop_type, ls_out_no, '2')
						ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"
		
						ls_Error = dw_print.Modify(ls_modify)
							IF (ls_Error <> "") THEN 
								MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
							END IF
						IF dw_print.RowCount() > 0 Then
							il_rows = dw_print.Print()
						END IF	
		end if					
else			
		IF dw_list.Visible THEN	
					 
				FOR i = 1 TO dw_list.RowCount() 
					IF ls_out_no <> dw_list.object.out_no[i] OR ls_shop_type <> dw_list.object.shop_type[i] THEN 
						ls_out_no    = dw_list.GetitemString(i, "out_no")
						ls_shop_type = dw_list.GetitemString(i, "shop_type")

							for j = 1 to 3	
								if j = 1 then 
									ls_jup_name = "(거 래 처 용)"			
								elseif j = 2 then
									ls_jup_name = "(매 장 용)"			
								else
									ls_jup_name = "(창 고 용)"			
								end if						
									
									dw_print.Retrieve(is_brand, is_yymmdd, is_shop_cd, ls_shop_type, ls_out_no, '2')									
									ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"
					
									ls_Error = dw_print.Modify(ls_modify)
										IF (ls_Error <> "") THEN 
											MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
										END IF
									IF dw_print.RowCount() > 0 Then
										il_rows = dw_print.Print()
									END IF
							 next	
					END IF 	
				NEXT 
				

		ELSE 
						ls_out_no    = dw_body.GetitemString(1, "out_no")
						ls_shop_type = dw_body.GetitemString(1, "shop_type")
											
						for j = 1 to 3	
							if j = 1 then 
								ls_jup_name = "(거 래 처 용)"			
							elseif j = 2 then
								ls_jup_name = "(매 장 용)"			
							else
								ls_jup_name = "(창 고 용)"			
							end if						
						
								dw_print.Retrieve(is_brand, is_yymmdd, is_shop_cd, ls_shop_type, ls_out_no, '2')			
								ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"
				
								ls_Error = dw_print.Modify(ls_modify)
									IF (ls_Error <> "") THEN 
										MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
									END IF
								IF dw_print.RowCount() > 0 Then
									il_rows = dw_print.Print()
								END IF
						next	
		END IF
end if
		
		
//else			
//		IF dw_list.Visible THEN
//			for j = 1 to 4	
//				if j = 1 then 
//					ls_jup_name = "(영 업 용)"
//				elseif j = 2 then
//					ls_jup_name = "(거 래 처 용)"			
//				elseif j = 3 then
//					ls_jup_name = "(매 장 용)"			
//				else
//					ls_jup_name = "(창 고 용)"			
//				end if
//					 
//				FOR i = 1 TO dw_list.RowCount() 
//					IF ls_out_no <> dw_list.object.out_no[i] OR ls_shop_type <> dw_list.object.shop_type[i] THEN 
//						ls_out_no    = dw_list.GetitemString(i, "out_no")
//						ls_shop_type = dw_list.GetitemString(i, "shop_type")
//						dw_print.Retrieve(is_brand, is_yymmdd, is_shop_cd, ls_shop_type, ls_out_no, '2')
//						ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"
//		
//						ls_Error = dw_print.Modify(ls_modify)
//							IF (ls_Error <> "") THEN 
//								MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
//							END IF
//						IF dw_print.RowCount() > 0 Then
//							il_rows = dw_print.Print()
//						END IF
//					END IF 	
//				NEXT 
//			next	
//		ELSE 
//			for j = 1 to 4	
//				if j = 1 then 
//					ls_jup_name = "(영 업 용)"
//				elseif j = 2 then
//					ls_jup_name = "(거 래 처 용)"			
//				elseif j = 3 then
//					ls_jup_name = "(매 장 용)"			
//				else
//					ls_jup_name = "(창 고 용)"			
//				end if
//		
//					 
//						ls_out_no    = dw_body.GetitemString(1, "out_no")
//						ls_shop_type = dw_body.GetitemString(1, "shop_type")
//						dw_print.Retrieve(is_brand, is_yymmdd, is_shop_cd, ls_shop_type, ls_out_no, '2')
//						ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"
//		
//						ls_Error = dw_print.Modify(ls_modify)
//							IF (ls_Error <> "") THEN 
//								MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
//							END IF
//						IF dw_print.RowCount() > 0 Then
//							il_rows = dw_print.Print()
//						END IF
//			next		
//		END IF
//end if
//

This.Trigger Event ue_msg(6, il_rows)

end event

public function boolean wf_margin_set (long al_row, string as_style);Long    ll_qty,         ll_tag_price, ll_curr_price,  ll_out_price
String  ls_null,        ls_sale_type = space(2)
decimal ldc_marjin,     ldc_dc_rate 
SetNull(ls_null) 

ldc_dc_rate = dw_body.GetitemDecimal(al_row - 1, "disc_rate")
/* 반품시 마진율 체크 */
IF al_row > 1 AND is_shop_type > '4' AND ldc_dc_rate <> 0 THEN
	ls_sale_type  = dw_body.GetitemString(al_row - 1, "sale_type")
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
/* 재고내역 조회 */
dw_stock.Retrieve(is_shop_cd, as_style)
dw_1.Setitem(1, "style",      as_style)
dw_1.Setitem(1, "tag_price",  dw_body.object.tag_price[al_row])

/* 금액 처리 */
wf_amt_set(al_row, ll_qty, ll_curr_price)

RETURN True
end function

public function boolean wf_margin_set_color (long al_row, string as_style, string as_color);Long    ll_qty,         ll_tag_price, ll_curr_price,  ll_out_price
String  ls_null,        ls_sale_type = space(2), ls_style, ls_color
decimal ldc_marjin,     ldc_dc_rate 
SetNull(ls_null) 

ldc_dc_rate = dw_body.GetitemDecimal(al_row - 1, "disc_rate")
/* 반품시 마진율 체크 */
IF al_row > 1 AND is_shop_type > '4' AND ldc_dc_rate <> 0 THEN
	ls_sale_type  = dw_body.GetitemString(al_row - 1, "sale_type")
	ldc_marjin    = dw_body.Object.margin_rate[al_row - 1]
	ll_tag_price  = dw_body.GetitemNumber(al_row, "tag_price")
	ll_curr_price = ll_tag_price * (100 - ldc_dc_rate) / 100
	gf_marjin_price (is_shop_cd, ll_curr_price, ldc_marjin, ll_out_price)
ELSE
   IF gf_outmarjin_color (is_yymmdd,    is_shop_cd, is_shop_type, as_style, as_color, & 
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
/* 사이즈 클리어 */
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
/* 재고내역 조회 */
dw_stock.Retrieve(is_shop_cd, as_style)
dw_1.Setitem(1, "style",      as_style)
dw_1.Setitem(1, "tag_price",  dw_body.object.tag_price[al_row])

/* 금액 처리 */
wf_amt_set(al_row, ll_qty, ll_curr_price)

RETURN True
end function

public subroutine wf_amt_set (long al_row, long al_qty, long al_curr_price);/* 각 단가 및 반품량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_out_price
Decimal ldc_rtrn_amt 
Decimal ldc_marjin

ll_tag_price  = dw_body.GetitemDecimal(al_row, "tag_price") 
ll_out_price  = dw_body.GetitemNumber(al_row, "out_price") 
ldc_rtrn_amt  = dec(ll_out_price) * al_qty   

dw_body.Setitem(al_row, "tag_amt",      dec(ll_tag_price)  * al_qty)
dw_body.Setitem(al_row, "curr_amt",     dec(al_curr_price) * al_qty)
dw_body.Setitem(al_row, "rtrn_collect", ldc_rtrn_amt) 
dw_body.Setitem(al_row, "vat", ldc_rtrn_amt - Round(ldc_rtrn_amt / 1.1, 0))


end subroutine

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.05.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_null, LS_SHOP_TYPE,ls_work_gubn
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn , ls_brand2 
String ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
Long   ll_tag_price,  ll_cnt 
Setnull(ls_null)

ls_brand2 = dw_head.getitemstring(1, "brand")

IF al_row > 1 and LenA(as_style_no) <> 9 THEN
	gf_style_edit(dw_body.Object.style_no[al_row - 1], as_style_no, ls_style, ls_chno) 
	
	
	IF ls_chno = '%' THEN
		select isnull(min(chno),'%')
		into :ls_chno
		from tb_12021_d (nolock)
		where style like :ls_style;
	END IF
//    THEN ls_chno = '0' 

ELSE 
	ls_style = LeftA(as_style_no, 8)
	ls_chno  = MidA(as_style_no, 9, 1)
END IF 


IF MidA(is_shop_cd, 2, 1) = 'X' OR MidA(is_shop_cd, 2, 1) = 'T' THEN 
	ls_plan_yn = '%'
ELSEIF is_shop_type = '1' THEN 
	ls_plan_yn = 'N'
ELSEIF is_shop_type = '3' THEN 
				
 if gs_user_id = '990902' or gs_user_id = '991214' then
	ls_plan_yn = '%'
 else	
	ls_plan_yn = 'Y'
 end if		

ELSEIF is_shop_type = '4' THEN 
	if MidA(is_shop_cd,2,1) <> 'X' then
		ls_plan_yn = 'N'
	else	
		ls_plan_yn = '%'
   end if
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
	and :is_brand_grp  like '%' + brand + '%'	
//	and brand   =	  :ls_brand2
	and isnull(tag_price, 0) <> 0;
	
IF SQLCA.SQLCODE <> 0 or ll_cnt <> 1 THEN 
	Return False 
END IF 


IF ls_style  <> 'NC5AJ973' AND ls_style <> 'NC5AJ911' AND ls_style <> 'NC5AL911' AND ls_style <> 'NC5AJ910' AND ls_style <> 'NC5MB628' AND ls_style <> 'NC5AS910' AND ls_style <> 'NC5MB962' AND ls_style <> 'NC5MB964' AND ls_style <> 'NC5MJ965' AND ls_style <> 'NC5AJ913' AND ls_style <> 'NC5AL913' AND ls_style <> 'NC5AS913' AND ls_style <> 'NC5AJ915' AND ls_style <> 'NC5AL915' AND ls_style <> 'NC5AS915' THEN 				
	if MidA(ls_style,2,1) = "C" and LeftA(ls_style,1) <> 'B' and LeftA(ls_style,1) <> 'D' and LeftA(ls_style,1) <> 'K' and LeftA(ls_style,1) <> 'U' and LeftA(ls_style,1) <> 'L'  then
		if  is_shop_cd <> "NT3542" then 
			if  is_shop_cd <> "NT3550" then 
			if is_shop_cd <> "NZ1999" then 
				if is_shop_cd <> "NX3537" then 
					if is_shop_cd <> "NX4994" then 
					 if is_shop_cd <> "NT3531" then 					
						 if is_shop_cd <> "WT3516" then 	
							if MidA(is_shop_cd,2,5) <> "X4992" then 
								messagebox("경고!", "이 제품은 중국수출만 가능한 제품입니다!")
								return false
							end if		
						end if
					 end if
 					 end if
					end if				   				
				end if				   
			end if				   
		end if
	end if 	
END IF
				
if is_shop_type = "4" and LenA(ls_style) = 8 then
		Select shop_type
		into :ls_shop_type
		From tb_56012_d with (nolock)
		Where style      = :ls_style 
		  and start_ymd <= :is_yymmdd
		  and end_ymd   >= :is_yymmdd
		  and shop_cd    = :is_shop_cd ;

			if MidA(is_shop_cd,3,4) = '2000'  or MidA(is_shop_cd,3,4) = '4900' then
				ls_shop_type = '4'
			elseif MidA(is_shop_cd,3,4) = '3300' or MidA(is_shop_cd,3,4) = '1802'  then
				ls_shop_type = '4'
			else	
				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
					if is_shop_type = '3' then
					 ls_shop_type = '3'
					else 
					 ls_shop_type = '1'	
					end if 
				end if	 
			end if				
		
//		if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
//						if is_shop_type = '3' then
//						 ls_shop_type = '3'
//						else 
//						 ls_shop_type = '1'	
//						end if 
//		end if	 
		
		if is_shop_type <> ls_shop_type then 
			messagebox("경고!", "제품판매가 가능한 매장형태는 " + ls_shop_type + " 입니다!")
//			return false
		end if	
end if
				
				


//select isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX'),
//		 isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
//into :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq, :ls_given_fg, :ls_given_ymd
//from tb_12020_m with (nolock)
//where style = :ls_style;
//
//if ls_bujin_chk = "Y" then 
//	messagebox("부진체크1", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
//end if 	
//
//if ls_given_fg = "Y" and ls_given_ymd <= is_yymmdd then 
//	messagebox("품번체크", ls_given_ymd + "일자로 사은품 전환된 제품입니다!")
//	return false
//end if 	


select isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX'),
		 isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
into :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq, :ls_given_fg, :ls_given_ymd
from tb_12020_m with (nolock)
where style = :ls_style;


select 
		 isnull(given_ymd, 'XXXXXXXX'), isnull(work_gubn,'A')
into  :ls_given_ymd, :ls_work_gubn
from tb_56040_m with (nolock)
where style = :ls_style
and   work_gubn in ('A','R') ;

if ls_bujin_chk = "Y" then 
	messagebox("부진체크1", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
end if 	

if ls_given_ymd <= is_yymmdd and LenA(ls_work_gubn) = 1 then 
	messagebox("품번체크", ls_given_ymd + "일자로 사은품 전환된 제품입니다!")
	return false
end if 	



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
if is_shop_type > '3' THEN
	dw_body.SetItem(al_row, "color",    '')
	dw_body.SetItem(al_row, "size",     'XX')

	//	dw_body.SetItem(al_row, "color",    'XX')
//	ls_color = dw_body.GetitemString(al_row - 1, "color")
//	select count(color)
//	  into :ll_cnt  
//	  from tb_12024_d with (nolock)
//	 where style = :ls_style 
//	   and chno  = :ls_chno 
//		and color = :ls_color ;
//   IF ll_cnt > 0 THEN
//      dw_body.SetItem(al_row, "color", ls_color)
//      dw_body.Setcolumn( "color")		
//		dw_body.SetItem(al_row, "size",     'XX')		
//	ELSE
//      dw_body.SetItem(al_row, "color",    '')
//		dw_body.SetItem(al_row, "size",     'XX')		
//      dw_body.Setcolumn( "color")				
//	END IF
//	dw_body.SetItem(al_row, "size",     'XX')		
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

on w_42003_e.create
int iCurrent
call super::create
this.cb_input=create cb_input
this.cb_copy=create cb_copy
this.cb_1=create cb_1
this.dw_stock=create dw_stock
this.dw_1=create dw_1
this.dw_list=create dw_list
this.cb_print1=create cb_print1
this.cbx_a4=create cbx_a4
this.cbx_laser=create cbx_laser
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_input
this.Control[iCurrent+2]=this.cb_copy
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_stock
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.dw_list
this.Control[iCurrent+7]=this.cb_print1
this.Control[iCurrent+8]=this.cbx_a4
this.Control[iCurrent+9]=this.cbx_laser
end on

on w_42003_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_input)
destroy(this.cb_copy)
destroy(this.cb_1)
destroy(this.dw_stock)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.cb_print1)
destroy(this.cbx_a4)
destroy(this.cbx_laser)
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

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
//elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
elseif (gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'E' or is_brand = 'M' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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

is_shop_ymd = String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
is_note     = dw_head.GetItemstring(1, "note")

is_rqst_gubn = dw_head.GetItemString(1, "rqst_gubn")
if IsNull(is_rqst_gubn) or Trim(is_rqst_gubn) = "" then
   MessageBox(ls_title,"전표유형을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rqst_gubn")
   return false
end if


select DBO.SF_INTER_CD2('001',:is_brand)
into :is_brand_grp
from dual;


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
	dw_1.Visible = False
	dw_stock.Visible = False
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
         cb_print1.enabled   = true			
         cb_preview.enabled = true
         cb_excel.enabled   = true
         cb_1.enabled       = true
         cb_insert.enabled  = false
         cb_delete.enabled  = false
         cb_update.enabled  = false
         cb_copy.enabled    = false
         cb_input.Text      = "등록(&I)"
         dw_head.enabled    = true 
         dw_body.enabled    = false
         ib_changed         = false
      end if
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled  = true
			cb_print.enabled   = false
			cb_print1.enabled   = false			
			cb_preview.enabled = false
			cb_excel.enabled   = false
		end if
		if dw_head.Enabled then
         cb_input.Text = "조건(&I)"
			dw_head.Enabled = false
         cb_1.enabled    = false
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed         = false
			cb_print.enabled   = true
			cb_print1.enabled   = true			
			cb_preview.enabled = true
			cb_excel.enabled   = true
			cb_delete.enabled  = false
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
      cb_input.Text = "등록(&I)"
      cb_1.enabled       = true
      cb_insert.enabled  = false
      cb_delete.enabled  = false
      cb_print.enabled   = false
      cb_print1.enabled   = false		
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
         cb_print1.enabled   = false			
         cb_preview.enabled = false
         cb_excel.enabled   = false
         cb_copy.Enabled    = false
         cb_1.enabled       = false
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
         cb_print1.enabled   = false			
         cb_preview.enabled = false
         cb_excel.enabled   = false
      end if

END CHOOSE

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(cb_input,  "FixedToRight")
inv_resize.of_Register(dw_list,   "ScaleToRight&Bottom")
inv_resize.of_Register(dw_stock,  "ScaleToBottom")

dw_list.SetTransObject(SQLCA)
dw_stock.SetTransObject(SQLCA)

dw_1.insertRow(0)
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_cd, ls_shop_nm, ls_brand, ls_style, ls_chno,ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_color
String	  ls_given_fg, ls_given_ymd, LS_SHOP_TYPE	, ls_work_gubn, ls_gubn
Long       ll_tag_price
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm3(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			
//			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
//			                         "  AND  (SHOP_DIV  IN ('G', 'K', 'T','I') or shop_cd like '__499_') " + &
//											 "  AND BRAND = '" + ls_brand + "'"
											 
//			if ls_brand = "J" or ls_brand = "N"   then
//				gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
//			                         "  AND  (SHOP_DIV  IN ('G', 'K', 'T','I','O') or shop_cd like '__499_') " + &
//												 "  AND BRAND in ('N','J') "
//			else									 
		
				gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND  (SHOP_DIV  IN ('G', 'K', 'T','I','O','B') or shop_cd like '__499_') " + &
												 "  AND BRAND = '" + ls_brand + "'"
//			end if				
											 
											 
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
			
			
//			gst_cd.default_where   = "WHERE brand = '" + is_brand + "' " + & 
//			                         "  AND isnull(tag_price, 0) <> 0 "
											 

			if is_brand = "J" or is_brand = "N"  then
				gst_cd.default_where   = "WHERE  '" + is_brand_grp + "' like '%' + brand + '%' " + & 
										 "  AND isnull(tag_price, 0) <> 0 "
			else									 
		
				gst_cd.default_where   = "WHERE  '" + is_brand_grp + "' like '%' + brand + '%' " + & 
			                         "  AND isnull(tag_price, 0) <> 0 "
			end if															 
											 
			IF is_shop_type = '1' and is_shop_cd = 'OG0009' THEN 
//				gst_cd.default_where   = gst_cd.default_where + "AND plan_yn = 'N'"
			elseif is_shop_type = '1' and is_shop_cd <> 'OG0009' THEN 
				
				if gs_user_id = '990902' or gs_user_id = '991214' then
					gst_cd.default_where   = gst_cd.default_where + " and plan_yn like '%' "
				else	
					gst_cd.default_where   = gst_cd.default_where + "AND plan_yn = 'N'"					
				end if						

			ELSEIF is_shop_type = '3' THEN
				gst_cd.default_where   = gst_cd.default_where + "AND plan_yn = 'Y'"
			ELSEIF is_shop_type = '4' THEN
				if MidA(is_shop_cd, 2, 1) <> 'X'  then
					gst_cd.default_where   = gst_cd.default_where + "AND plan_yn = 'N'"				
				end if	
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
				ls_CHNO  = lds_Source.GetItemString(1,"CHNO")				
				ls_color = lds_Source.GetItemString(1,"color")							
				
			IF ls_style  <> 'NC5AJ973' AND ls_style <> 'NC5AJ911' AND ls_style <> 'NC5AL911' AND ls_style <> 'NC5AJ910' AND ls_style <> 'NC5MB628' AND ls_style <> 'NC5AS910' AND ls_style <> 'NC5MB962' AND ls_style <> 'NC5MB964' AND ls_style <> 'NC5MJ965' AND ls_style <> 'NC5AJ913' AND ls_style <> 'NC5AL913' AND ls_style <> 'NC5AS913' AND ls_style <> 'NC5AJ915' AND ls_style <> 'NC5AL915' AND ls_style <> 'NC5AS915' THEN 				
				if MidA(ls_style,2,1) = "C" and LeftA(ls_style,1) <> 'B' and LeftA(ls_style,1) <> 'D' and LeftA(ls_style,1) <> 'K' and LeftA(ls_style,1) <> 'U' then
					if  is_shop_cd <> "NT3542" then 
 					  if  is_shop_cd <> "NT3550" then 						
						if is_shop_cd <> "NZ1999" then 
							if is_shop_cd <> "NX3537" then 
								if is_shop_cd <> "NX4994" then 								
								  if is_shop_cd <> "NT3531" then 								
									  if is_shop_cd <> "WT3516" then 		
											if MidA(is_shop_cd,2,5) <> "X4992" then 
												messagebox("경고!", "이 제품은 중국수출만 가능한 제품입니다!")
				//								dw_body.SetItem(al_row, "style_no", "")
												ib_itemchanged = FALSE
												return 1 
											end if	
									  end if	
								  end if									
								end if												
							end if			
						end if										
						end if				   
				   end if
            end if 					
			END IF	
				
				if is_shop_type = "4" then			
					
						Select shop_type
						into :ls_shop_type
						From tb_56012_d_color with (nolock)
						Where style      = :ls_style 
						  and color      = :ls_color 	
						  and start_ymd <= :is_yymmdd
						  and end_ymd   >= :is_yymmdd
						  and shop_cd    = :is_shop_cd ;
						  
						if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		  
							Select shop_type
							into :ls_shop_type
							From tb_56012_d with (nolock)
							Where style      = :ls_style 
							  and start_ymd <= :is_yymmdd
							  and end_ymd   >= :is_yymmdd
							  and shop_cd    = :is_shop_cd ;						  
						end if	  

		   if MidA(is_shop_cd,3,4) = '2000' or MidA(is_shop_cd,3,4) = '4900' then
				ls_shop_type = '4'
			elseif MidA(is_shop_cd,3,4) = '3300' or MidA(is_shop_cd,3,4) = '1802' then
				ls_shop_type = '4'
			else	
				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
					if is_shop_type = '3' then
					 ls_shop_type = '3'
					else 
					 ls_shop_type = '1'	
					end if 
				end if	 
			end if								  
//						  
//						if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
//							if is_shop_type = '3' then
//							 ls_shop_type = '3'
//							else 
//							 ls_shop_type = '1'	
//							end if 
//						end if	 

						if is_shop_type <> ls_shop_type then 
							messagebox("경고!", "제품판매가 가능한 매장형태는 " + ls_shop_type + " 입니다!")
//							ib_itemchanged = FALSE
//							return 1
						end if	
						
				end if
				
				
				
				select isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX')
				into :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq
				from tb_12020_m with (nolock)
				where style = :ls_style;
				
				select 
				isnull(given_ymd, 'XXXXXXXX'), isnull(work_gubn,'A'), isnull(gubn,'G')
				into  :ls_given_ymd, :ls_work_gubn, :ls_gubn
				from tb_56040_m with (nolock)
				where style = :ls_style
				and   work_gubn in ('A','R') ;
				
				if ls_bujin_chk = "Y" then 
					messagebox("부진체크", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
            end if 					
				
//				if ls_given_fg = "Y" and ls_given_ymd <= is_yymmdd then 
//					messagebox("품번체크", ls_given_ymd + "일자로 사은품 전환된 제품입니다!")
//					dw_body.SetItem(al_row, "style_no", "")
//					ib_itemchanged = FALSE
//					return 1 
//				end if 	
	

				if ls_given_ymd <= is_yymmdd and LenA(ls_work_gubn) = 1 and ls_gubn = 'G' then 
					messagebox("품번검색", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				end if 									

				if ls_given_ymd <= is_yymmdd and LenA(ls_work_gubn) = 1 and ls_gubn = 'C' then 
					messagebox("품번검색", ls_given_ymd + "일자로 제품수불 통제로 전환된 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				end if 									
				
				
 				IF wf_margin_set(al_row, ls_style) THEN 
				   dw_body.SetItem(al_row, "style_no", ls_style + lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "style",    lds_Source.GetItemString(1,"style"))
				   dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand"))
				   dw_body.SetItem(al_row, "year",     lds_Source.GetItemString(1,"year"))
				   dw_body.SetItem(al_row, "season",   lds_Source.GetItemString(1,"season"))
				   dw_body.SetItem(al_row, "sojae",    lds_Source.GetItemString(1,"sojae"))
				   dw_body.SetItem(al_row, "item",     lds_Source.GetItemString(1,"item"))
				   dw_body.SetItem(al_row, "color",    lds_Source.GetItemString(1,"color"))
				   dw_body.SetItem(al_row, "size",     lds_Source.GetItemString(1,"size"))
					wf_margin_set_color(al_row, ls_style, ls_color)					
				   ib_changed = true
               cb_update.enabled = true
				   /* 다음컬럼으로 이동 */
			      dw_body.SetColumn("qty")
			      lb_check = TRUE 
				END IF
				ib_itemchanged = FALSE
			END IF
			Destroy  lds_Source
	CASE "style"		
			IF ai_div = 1 THEN 	
            Select tag_price
              into :ll_tag_price
              from vi_12020_1 
             where style   = :as_data
             	and tag_price <> 0 ;
				IF SQLCA.SQLCODE = 0 THEN 
					ls_shop_cd = dw_head.GetitemString(1, "shop_cd")
					dw_1.Setitem(1, "tag_price", ll_tag_price)
					dw_stock.Retrieve(ls_shop_cd, as_data)
					Return 0
				END IF
			END IF 
			ls_brand = dw_head.GetitemString(1, "brand")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com013" 
			gst_cd.default_where   = "WHERE brand = '" + ls_brand + "' " + & 
			                         "  AND isnull(tag_price, 0) <> 0 "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + as_data + "%'" 
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
				   dw_1.SetRow(al_row)
				   dw_1.SetColumn(as_column)
				END IF
				ls_style = lds_Source.GetItemString(1,"style")
			   dw_1.SetItem(al_row, "style",     ls_style )
				dw_1.SetItem(al_row, "tag_price", lds_Source.GetItemNumber(1,"tag_price")) 
				ls_shop_cd = dw_head.GetitemString(1, "shop_cd")
				dw_stock.Retrieve(ls_shop_cd, ls_style)
		      lb_check = TRUE 
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

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/
long i, ll_row_count, li_no, j
datetime ld_datetime
string ls_chk

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


if is_brand = "V" or is_brand = "B" or is_brand = "F" or is_brand = "L"   then
			messagebox("주의", "이터널 브랜드의 경우 이터널영업관리를 이용하세요!")
//			return -1
			Return 0
End if		

/* 반품전표 채번 */
idw_status = dw_body.GetItemStatus(1, 0, Primary!)
IF idw_status = DataModified! OR idw_status = NotModified!	THEN
	is_out_no = dw_body.GetitemString(1, "out_no")
ELSEIF gf_style_outno(is_yymmdd, is_brand, is_out_no) = FALSE THEN 
	Return -1 
END IF 
//
//
select   convert(decimal(5), isnull(max(no), '0000'))
into :li_no
from tb_42021_h with (nolock)
where yymmdd  = :is_yymmdd
and   out_no  = :is_out_no
and   shop_cd = :is_shop_cd ;


FOR j=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(j, 0, Primary!)
	ls_chk = dw_body.getitemstring(j, "yymmdd")
   IF idw_status <> NewModified! and isnull(is_note) = false and isnull(ls_chk) = false THEN			
  	   dw_body.SetItemStatus(j, 0, Primary!, DataModified!)		
   END IF
NEXT


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	
	
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "yymmdd",    is_yymmdd)
      dw_body.Setitem(i, "shop_cd",   is_shop_cd)
      dw_body.Setitem(i, "shop_type", is_shop_type)
      dw_body.Setitem(i, "out_no",    is_out_no)
      dw_body.Setitem(i, "no",        String(li_no + 1 , "0000"))
      dw_body.Setitem(i, "house_cd",  is_house)
      dw_body.Setitem(i, "jup_gubn",  'O1')
		if is_rqst_gubn = "Y" then
	      dw_body.Setitem(i, "rqst_gubn",  is_rqst_gubn)		
      end if			
		IF is_house = '450000' or is_house = '020000' or is_house = '040000' THEN
         dw_body.Setitem(i, "class",  'B')  /* 불량창고 -> B급 */
		ELSE
         dw_body.Setitem(i, "class",  'A')
		END IF
      dw_body.Setitem(i, "shop_ymd",  is_shop_ymd)
      dw_body.Setitem(i, "note",  is_note)		
      dw_body.Setitem(i, "reg_id",    gs_user_id)
      dw_body.Setitem(i, "reg_dt",    ld_datetime)		
		li_no = li_no + 1
		
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		
      dw_body.Setitem(i, "shop_ymd",  is_shop_ymd)
      dw_body.Setitem(i, "note",  is_note)		
      dw_body.Setitem(i, "mod_id",    gs_user_id)
      dw_body.Setitem(i, "mod_dt",    ld_datetime)

		
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

if cbx_laser.checked then
	dw_print.DataObject = "d_com420_A"
	dw_print.SetTransObject(SQLCA)
ELSE
	dw_print.DataObject = "d_com420"
	dw_print.SetTransObject(SQLCA)
END IF	


IF dw_list.Visible THEN
   FOR i = 1 TO dw_list.RowCount() 
      IF ls_out_no <> dw_list.object.out_no[i] OR ls_shop_type <> dw_list.object.shop_type[i] THEN 
         ls_out_no    = dw_list.GetitemString(i, "out_no")
         ls_shop_type = dw_list.GetitemString(i, "shop_type")
         dw_print.Retrieve(is_brand, is_yymmdd, is_shop_cd, ls_shop_type, ls_out_no, '2')
         IF dw_print.RowCount() > 0 Then
            il_rows = dw_print.Print()
         END IF
		END IF 	
	NEXT 
ELSE 
   ls_out_no    = dw_body.GetitemString(1, "out_no")
   ls_shop_type = dw_body.GetitemString(1, "shop_type")
   dw_print.Retrieve(is_brand, is_yymmdd, is_shop_cd, ls_shop_type, ls_out_no, '2')
   IF dw_print.RowCount() > 0 Then
      il_rows = dw_print.Print()
   END IF
END IF

This.Trigger Event ue_msg(6, il_rows)

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04																  */	
/* 수정일      : 2002.03.04																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

IF idw_status = NotModified! OR idw_status = DataModified! THEN
	RETURN 
END IF 

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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42003_e","0")
end event

event ue_excel();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)
	IF dw_list.Visible THEN
		li_ret = dw_list.SaveAs(ls_doc_nm, Excel!, TRUE)
	else	
		li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
	end if	
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_close from w_com010_e`cb_close within w_42003_e
integer taborder = 130
end type

type cb_delete from w_com010_e`cb_delete within w_42003_e
integer x = 1746
integer width = 279
integer taborder = 80
end type

type cb_insert from w_com010_e`cb_insert within w_42003_e
integer x = 1472
integer width = 279
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_42003_e
integer taborder = 140
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

type cb_update from w_com010_e`cb_update within w_42003_e
integer width = 238
integer taborder = 120
end type

type cb_print from w_com010_e`cb_print within w_42003_e
integer x = 2021
integer width = 471
integer taborder = 90
string text = "거래명세서인쇄(&P)"
end type

type cb_preview from w_com010_e`cb_preview within w_42003_e
boolean visible = false
integer taborder = 100
end type

type gb_button from w_com010_e`gb_button within w_42003_e
end type

type cb_excel from w_com010_e`cb_excel within w_42003_e
integer x = 969
integer width = 256
integer taborder = 110
end type

type dw_head from w_com010_e`dw_head within w_42003_e
integer y = 168
integer height = 280
string dataobject = "d_42003_h01"
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

if  gs_brand = "M"  then 
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

type ln_1 from w_com010_e`ln_1 within w_42003_e
integer beginy = 464
integer endy = 464
end type

type ln_2 from w_com010_e`ln_2 within w_42003_e
integer beginy = 468
integer endy = 468
end type

type dw_body from w_com010_e`dw_body within w_42003_e
event ue_set_col ( string as_column )
integer x = 1138
integer y = 480
integer width = 2418
integer height = 1520
string dataobject = "d_42003_d02"
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
String ls_null, ls_style
Setnull(ls_null) 

CHOOSE CASE dwo.name 
//	CASE "style_no"	
//		IF ib_itemchanged THEN RETURN 1 
//		ll_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1) 
//		IF Len(This.GetitemString(row, "size")) = 2 THEN
//			This.Post Event ue_set_col("qty")
//		END IF 
//		Return ll_ret
//	CASE "color"	
//		This.Setitem(row, "size", ls_null)
		
	CASE "style_no"	
		IF ib_itemchanged THEN RETURN 1 
		ll_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		IF LenA(This.GetitemString(row, "size")) = 2 and LenA(This.GetitemString(row, "color")) = 2 THEN
			This.Post Event ue_set_col("qty")
		else	
			This.Post Event ue_set_col("color")			
		END IF 
		Return ll_ret
		
	CASE "color"	
		
		ls_style = This.GetitemString(row, "style")
		wf_margin_set_color(row, ls_style, data)		
		
		if This.GetitemString(row, "size") <> 'XX' then
			This.Setitem(row, "size", ls_null) 
			This.Post Event ue_set_col("size")		
		end if		
		
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

type dw_print from w_com010_e`dw_print within w_42003_e
string dataobject = "d_com420"
end type

type cb_input from commandbutton within w_42003_e
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

type cb_copy from commandbutton within w_42003_e
event ue_keydown pbm_keydown
integer x = 265
integer y = 44
integer width = 219
integer height = 92
integer taborder = 150
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
String  ls_style,       ls_sale_type = space(2), ls_color
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

if is_shop_cd <> "OT3535" then 
	if is_shop_cd <> "NT3531" then
		if is_shop_cd <> "OT3532" then
			if is_brand <> LeftA(is_shop_cd,1) then
				MessageBox("경고","매장 코드와 브랜드를 확인 하십시요!")
				return 
			end if
		end if
	end if	
end if

ll_row_cnt = dw_body.RowCount() 
IF ll_row_cnt < 1 THEN RETURN 

This.Enabled = False
oldpointer = SetPointer(HourGlass!)


dw_body.SetRedraw(FALSE)
FOR i = 1 TO ll_row_cnt
	IF dw_body.GetItemStatus(i, 0, Primary!) = New!	THEN CONTINUE 
	ls_style = dw_body.GetitemString(i, "style") 
	ls_color = dw_body.GetitemString(i, "color") 	
		if is_shop_cd <> 'NZ3999' then
			if is_shop_cd <> 'OZ1998' then
				if is_shop_cd <> 'IZ1991' then				
					/* 출고시 마진율 체크 */			
					IF gf_outmarjin_color (is_yymmdd,    is_shop_cd, is_shop_type, ls_style, ls_color,& 
										  ls_sale_type, ldc_marjin, ldc_dc_rate,  ll_curr_price, ll_out_price) = FALSE THEN 
						SetPointer(oldpointer)
						MessageBox("확인요망", " 마진율이 없습니다.")
						This.Enabled = True
						dw_body.SetRedraw(True)
						RETURN 
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
				end if
			end if
		end if
			//   IF i > 1 THEN 
			//	   IF dw_body.Object.sale_type[1]   <> ls_sale_type OR &
			//	      dw_body.Object.margin_rate[1] <> ldc_marjin   THEN 
			//   		SetPointer(oldpointer)
			//	      MessageBox("확인요망", "[" + ls_style + "] 마진율이 다른 형태 입니다.")
			//         This.Enabled = True
			//         dw_body.SetRedraw(True)
			//		   Return 
			//	   END IF
			//   END IF 
		/* 단가 및 율 등록 */
		if is_shop_cd = 'NZ3999' or is_shop_cd = 'OZ1998' or is_shop_cd = 'IZ1991' then		
			dw_body.SetItemStatus(i, 0, Primary!, NewModified!) 
		end if
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
cb_1.enabled = false

dw_body.SetFocus()

end event

type cb_1 from commandbutton within w_42003_e
integer x = 480
integer y = 44
integer width = 238
integer height = 92
integer taborder = 140
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "불러오기"
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/
String ls_yes, ls_brand, ls_yymmdd, ls_shop_cd, ls_out_no, ls_fr_ymd, ls_to_ymd, ls_shop_type
Long   ll_row
DataWindowChild ldw_child 
IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			dw_body.SetFocus()
			RETURN
	END CHOOSE
END IF

ls_brand = dw_head.GetitemString(1, "brand")
gsv_cd.gs_cd1 = ls_brand

integer Net

long Distance = 3.457

Net = MessageBox("러시아 재고건 처리", '러시아 재고건을 처리 하시겠습니까?', Exclamation!, YesNo!, 2)

IF Net = 1 THEN 

OpenWithParm (W_42003_r_S, "W_42003_r_S 출고전표 불러오기")  // 러시아 출고건 불러오기
	ls_yes = Message.StringParm 
	IF ls_yes = 'YES' THEN 
		ls_fr_ymd  = gsv_cd.gs_cd2 
		ls_to_ymd  = gsv_cd.gs_cd3 
		ls_yymmdd = dw_head.getitemstring(1,'yymmdd')
		ls_shop_cd = gsv_cd.gs_cd4 
		ls_shop_type = dw_head.getitemstring(1,'shop_type')
		
		dw_body.dataobject = "d_42003_d04"
		dw_body.SetTransObject(SQLCA)		

		dw_body.GetChild("sale_type", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('011')
		
		dw_body.GetChild("color", idw_color)
		idw_color.SetTransObject(SQLCA)
		idw_color.insertRow(0)
		
		dw_body.GetChild("size", idw_size)
		idw_size.SetTransObject(SQLCA)
		idw_size.insertRow(0)

		ll_row = dw_body.Retrieve(ls_fr_ymd, ls_to_ymd, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_brand)
		
		IF ll_row = 0 THEN 
			MessageBox("확인", "해당 출고자료가 없습니다!")
		ELSE 
			cb_copy.Enabled = True
		END IF 
	END IF 
ELSE
	OpenWithParm (W_42003_S, "W_42003_S 출고전표 불러오기") 
	ls_yes = Message.StringParm 
	IF ls_yes = 'YES' THEN 
		ls_yymmdd  = gsv_cd.gs_cd2 
		ls_shop_cd = gsv_cd.gs_cd3 
		ls_out_no  = gsv_cd.gs_cd4 

		dw_body.dataobject = "d_42003_d02"
		dw_body.SetTransObject(SQLCA)

		dw_body.GetChild("sale_type", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('011')
		
		dw_body.GetChild("color", idw_color)
		idw_color.SetTransObject(SQLCA)
		idw_color.insertRow(0)
		
		dw_body.GetChild("size", idw_size)
		idw_size.SetTransObject(SQLCA)
		idw_size.insertRow(0)
		
		ll_row = dw_body.Retrieve(ls_yymmdd, ls_shop_cd, '', ls_out_no, '',  ls_brand, '2') 
		IF ll_row = 0 THEN 
			MessageBox("확인", "해당 출고자료가 없습니다!")
		ELSE 
			cb_copy.Enabled = True
		END IF 
	END IF 
END IF


//OpenWithParm (W_42003_S, "W_42003_S 출고전표 불러오기") 
/*
ls_yes = Message.StringParm 
IF ls_yes = 'YES' THEN 
   ls_yymmdd  = gsv_cd.gs_cd2 
	ls_shop_cd = gsv_cd.gs_cd3 
	ls_out_no  = gsv_cd.gs_cd4 
	ll_row = dw_body.Retrieve(ls_yymmdd, ls_shop_cd, '', ls_out_no, '',  ls_brand, '2') 
	IF ll_row = 0 THEN 
		MessageBox("확인", "해당 출고자료가 없습니다!")
	ELSE 
		cb_copy.Enabled = True
   END IF 
END IF 
*/
end event

type dw_stock from datawindow within w_42003_e
integer x = 5
integer y = 676
integer width = 1129
integer height = 1316
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_42003_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_child 

This.GetChild("shop_type", ldw_child) 
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')
end event

type dw_1 from datawindow within w_42003_e
event ue_keydown pbm_dwnkey
integer x = 5
integer y = 472
integer width = 1129
integer height = 200
integer taborder = 60
string title = "none"
string dataobject = "d_42003_d99"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;/*===========================================================================*/
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
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

//CHOOSE CASE ls_column_name
//	CASE "cust_cd"
//		ls_helpMsg = "▶ ※ 거래처 코드를 입력하세요! "
//	CASE ELSE
//		ls_helpMsg = " "
//END CHOOSE
//
//Parent.SetMicroHelp(ls_helpMsg)

end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "style"	
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event itemerror;Return 1
end event

event getfocus;dw_head.AcceptText()

end event

type dw_list from datawindow within w_42003_e
event ue_syscommand pbm_syscommand
boolean visible = false
integer x = 5
integer y = 440
integer width = 3607
integer height = 1612
integer taborder = 70
boolean titlebar = true
string title = "반품조회"
string dataobject = "d_42003_d03"
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

event doubleclicked;String ls_out_no, ls_shop_type, ls_rqst_gubn, ls_pda_no, ls_box_no, ls_box_size, ls_tran_cust, ls_note

IF row < 0 THEN RETURN 

ls_out_no    = This.GetitemString(row, "out_no")
ls_shop_type = This.GetitemString(row, "shop_type")
ls_rqst_gubn = This.GetitemString(row, "rqst_gubn")
ls_pda_no 	 = This.GetitemString(row, "pda_no")
ls_tran_cust = This.GetitemString(row, "tran_cust")
ls_box_size	 = This.GetitemString(row, "box_size")
ls_box_no 	 = This.GetitemString(row, "box_no")
ls_note 	 = This.GetitemString(row, "note")

IF dw_body.Retrieve(is_yymmdd, is_shop_cd, ls_shop_type, ls_out_no, &
                    is_house,  is_brand, '1') > 0 THEN 
   dw_stock.visible = True						  
   dw_body.visible  = True						  
   dw_1.visible  = True			
   dw_list.visible  = False 
	cb_copy.Enabled  = True
	cb_insert.Enabled = True
	if ls_rqst_gubn = "Y" then
		dw_head.setitem(1, "rqst_gubn", ls_rqst_gubn)
   end if		
	dw_head.setitem(1, "Note", ls_note)
	dw_head.setitem(1, "box_size", ls_box_size)
	dw_head.setitem(1, "box_no", ls_box_no)	
	dw_head.setitem(1, "pda_no", ls_pda_no)		
	dw_head.SetColumn("shop_cd")
	dw_head.SetFocus()
END IF

end event

type cb_print1 from commandbutton within w_42003_e
integer x = 713
integer y = 44
integer width = 256
integer height = 92
integer taborder = 140
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

type cbx_a4 from checkbox within w_42003_e
integer x = 2921
integer y = 280
integer width = 576
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 79741120
string text = "명세서A4(매장용)"
borderstyle borderstyle = stylelowered!
end type

type cbx_laser from checkbox within w_42003_e
integer x = 2921
integer y = 348
integer width = 567
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

