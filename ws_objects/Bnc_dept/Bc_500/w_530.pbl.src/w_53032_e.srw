$PBExportHeader$w_53032_e.srw
$PBExportComments$사내판매요청등록
forward
global type w_53032_e from w_com010_e
end type
type dw_1 from datawindow within w_53032_e
end type
type st_1 from statictext within w_53032_e
end type
type st_2 from statictext within w_53032_e
end type
type st_3 from statictext within w_53032_e
end type
type cb_input from commandbutton within w_53032_e
end type
end forward

global type w_53032_e from w_com010_e
event ue_input ( )
dw_1 dw_1
st_1 st_1
st_2 st_2
st_3 st_3
cb_input cb_input
end type
global w_53032_e w_53032_e

type variables
DataWindowChild	idw_brand, idw_color, idw_size
String is_brand, is_yymmdd, is_rqst_no, is_pay_way, is_empno, is_empnm, is_data_opt ,is_bill_ymd
end variables

forward prototypes
public function boolean wf_stock_chk (long al_row)
public subroutine wf_amt_set (long al_row, long al_qty, long al_sale_price)
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

event ue_input();
dw_1.Visible   = False
dw_body.Visible   = True

/* dw_head 필수입력 column check */

dw_head.setitem(1,"rqst_no","")

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_pay_way = "%" then
   MessageBox("입력","결제방법을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("pay_way")
   Return 
end if

if is_empno = "%" then
   MessageBox("입력","사번(매장코드)를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("empno")
   Return 
end if

if is_empnm = "%" then
   MessageBox("입력","구매자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("empnm")
   Return 
end if


if MidA(is_empno,1,1) = "N" or MidA(is_empno,1,1) = "O" or MidA(is_empno,1,1) = "W" then 
	if is_pay_way = "A" then
		messagebox("알림!", "매장사원 판매는 급여공제가 불가합니다!")
		return
	end if
end if	


if MidA(is_empno,1,1) = "N" or MidA(is_empno,1,1) = "O" or MidA(is_empno,1,1) = "W" then 
	if is_pay_way = "A" then
		messagebox("알림!", "매장사원 판매는 급여공제가 불가합니다!")
		return
	end if
end if	


dw_body.reset()

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

public function boolean wf_stock_chk (long al_row);String ls_style, ls_chno, ls_color, ls_size
long ll_stock_qty

ls_style = dw_body.getitemstring(al_row, "style")
ls_chno  = dw_body.getitemstring(al_row, "chno")
ls_color = dw_body.getitemstring(al_row, "color")
ls_size  = dw_body.getitemstring(al_row, "size")


select dbo.sf_house_real_stock(:ls_style, :ls_chno, :ls_color, :ls_size, '010000')
into :ll_stock_qty
from dual;


if ll_stock_qty <= 0 then 
//	messagebox("알림!","재고가 없는 품번입니다!")
	return false
else
	return true
end if	
end function

public subroutine wf_amt_set (long al_row, long al_qty, long al_sale_price);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_out_price, ll_collect_price
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect ,ll_sale_collect1
Decimal ldc_dc_rate

IF dw_body.AcceptText() <> 1 THEN RETURN

ll_tag_price     = dw_body.GetitemDecimal(al_row, "tag_price") 
ldc_dc_rate		  = dw_body.GetitemDecimal(al_row, "dc_rate") 

dw_body.Setitem(al_row, "sale_amt", ll_tag_price * al_qty * ((100 - ldc_dc_rate) /100))


end subroutine

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.05.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_null, ls_shop_type,ls_dc_flag
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn , ls_brand2, ls_year_no
String ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd, ls_make_type
Long   ll_tag_price,  ll_cnt , ll_dc_cnt, ll_stock_qty
Decimal ldc_dc_rate
SetNull(ls_null)

ls_brand2 = dw_head.getitemstring(1, "brand")

IF al_row > 1 and LenA(as_style_no) <> 9 THEN
	gf_style_edit(dw_body.Object.style_no[al_row - 1], as_style_no, ls_style, ls_chno) 
	
	IF ls_chno = '%' THEN
		select isnull(min(chno),'%')
		into :ls_chno
		from tb_12021_d (nolock)
		where style like :ls_style
		  and brand = :is_brand;
//	else 
//   	 ls_chno = '0' 		
	END IF

ELSE 
	ls_style = LeftA(as_style_no, 8)
	ls_chno  = MidA(as_style_no, 9, 1)
	
END IF 




Select count(style), 
       max(style)  ,   max(chno), 
       max(brand)  ,   max(year),     max(season),     
       max(sojae)  ,   max(item),     max(tag_price) ,
		 max(make_type)	
  into :ll_cnt     , 
       :ls_style   ,   :ls_chno, 
       :ls_brand   ,   :ls_year,      :ls_season, 
		 :ls_sojae   ,   :ls_item,      :ll_tag_price, :ls_make_type
  from vi_12020_1 with (nolock) 
 where style   like :ls_style 
	and chno    =    :ls_chno
	and isnull(tag_price, 0) <> 0
   and brand = :is_brand;
	
IF SQLCA.SQLCODE <> 0 or ll_cnt <> 1 THEN 
	Return False 
END IF 

				
select isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX'),
		 isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX'), year, season,
		 year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON))
into :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq, :ls_given_fg, :ls_given_ymd, :ls_year, :ls_season, :ls_year_no
from tb_12020_m with (nolock)
where style = :ls_style;

if ls_make_type = "50"  then 
	messagebox("품번체크", "위탁 상품으로 사내판매가 불가한 제품입니다!")
	return false
end if 	

if ls_given_fg = "Y"  and ls_given_ymd <= is_yymmdd then 
	messagebox("품번체크", ls_given_ymd + "일자로 사은품 전환된 제품입니다!")
	return false
end if 	

				
if ls_bujin_chk = "Y" then 
	messagebox("부진체크", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
end if 	

select count(*)
into :ll_dc_cnt
from tb_54021_h with (nolock)
where style = :ls_style;

select max(isnull(dc_rate,0))
into :ldc_dc_rate
from tb_56012_d with (nolock)
where style  = :ls_style;



dw_body.SetItem(al_row, "tag_price", ll_tag_price) 
dw_body.SetItem(al_row, "style_no", ls_style + ls_chno)
dw_body.SetItem(al_row, "style",    ls_style)
dw_body.SetItem(al_row, "chno",     ls_chno)
dw_body.SetItem(al_row, "brand",    ls_brand)
dw_body.SetItem(al_row, "bill_chk_ymd",  is_bill_ymd)



if is_brand = "E" and ls_year + ls_season = "2008W" and is_yymmdd <= "20090320" then	
		dw_body.SetItem(al_row, "dc_rate",    70)
		
elseif is_brand = "P"  then	
		dw_body.SetItem(al_row, "dc_rate",    30)

//elseif is_brand = "B" or is_brand = "G"  then	
//		dw_body.SetItem(al_row, "dc_rate",    40)

elseif is_brand = "B" then	
		dw_body.SetItem(al_row, "dc_rate",    40)

		
elseif is_brand = "I" and ls_year_no = '20131' then
		dw_body.SetItem(al_row, "dc_rate",    70)		

elseif is_brand = "I" and ls_year_no >= "20132" and ls_year_no <= '20134' then	
		dw_body.SetItem(al_row, "dc_rate",    60)		

elseif is_brand = "H" then	
		dw_body.SetItem(al_row, "dc_rate",    90)


elseif is_brand <> "I" then

	if ls_bujin_chk = "Y" or ls_year_no <= '20124' then
			dw_body.SetItem(al_row, "dc_rate",    70)
	elseif ll_dc_cnt > 0 then	
		
		if isnull(ldc_dc_rate) or ldc_dc_rate < 50 then
			dw_body.SetItem(al_row, "dc_rate",    40)
		else	
			dw_body.SetItem(al_row, "dc_rate",    70)
		end if						

	else	
		dw_body.SetItem(al_row, "dc_rate",    40)
	end if	
	
end if	


//
//if is_brand = "E" and ls_year + ls_season = "2008W" and is_yymmdd <= "20090320" then
//	dw_body.SetItem(al_row, "dc_rate",    70)	
//	
//elseif is_brand = "B" or is_brand = "S" then	
//		dw_body.SetItem(al_row, "dc_rate",    40)
//else	
//	if ls_bujin_chk = "Y" then
//			dw_body.SetItem(al_row, "dc_rate",    70)	
//	elseif ll_dc_cnt <> 0 then	
//		if isnull(ldc_dc_rate) or ldc_dc_rate < 50 then 
//			dw_body.SetItem(al_row, "dc_rate",    40)
//		else
//			dw_body.SetItem(al_row, "dc_rate",    70)	
//		end if	
//	else	
//		dw_body.SetItem(al_row, "dc_rate",    40)
//	end if	
//end if	

Return True

end function

on w_53032_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.cb_input=create cb_input
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.cb_input
end on

on w_53032_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cb_input)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd, ls_empnm
String 	  ls_plan_yn, ls_SHOP_TYPE,ls_dept_nm, ls_style_no, ls_year, ls_season, ls_make_type,ls_year_no
decimal	  ldc_sale_amt, ldc_tag_price, ldc_dc_rate
Boolean    lb_check 
DataStore  lds_Source
long		  ll_dc_cnt



CHOOSE CASE as_column
	
	CASE "style_no"		
			IF ai_div = 1 THEN 	
				IF wf_style_chk(al_row, as_data)  THEN 
					RETURN 2 
				END IF 
			END IF
			IF al_row > 1 THEN 
				gf_style_edit(dw_body.object.style_no[al_row -1], as_data, ls_style, ls_chno)

				select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX'), plan_yn, make_type
				into  :ls_given_fg, :ls_given_ymd, :ls_plan_yn, :ls_make_type
				from tb_12020_m with (nolock)
				where style = :ls_style;
					
				IF ls_given_fg = "Y"  AND  ls_given_ymd >= is_yymmdd  THEN
					messagebox("품번검색", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				END IF 			
	
				IF ls_make_type = "50"  THEN
					messagebox("품번검색", "위탁상품으로 사내판매 불가한 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				END IF 		
	
				
			ELSE
		      ls_style = MidA(as_data, 1, 8)
		      ls_chno  = MidA(as_data, 9, 1) 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com013" 
			gst_cd.default_where   = "WHERE brand = '" + is_brand + "' " + & 
			                         "  AND isnull(tag_price, 0) <> 0 and make_type <> '50' "
       
		 
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
				ls_CHNO = lds_Source.GetItemString(1,"CHNO")				
				
				select isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX'),isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX'), year, season,
						 year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON))
				into :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq, :ls_given_fg, :ls_given_ymd, :ls_year, :ls_season, :ls_year_no
				from tb_12020_m with (nolock)
				where style = :ls_style;
				
				select count(*)
				into :ll_dc_cnt
				from tb_54021_h with (nolock)
				where style = :ls_style;
				
				select max(dc_rate)
				into :ldc_dc_rate
				from tb_56012_d with (nolock)
				where style  = :ls_style
						and  end_ymd >= :is_yymmdd
						and substring(shop_cd,2,5) not in ('K2100');
				
			END IF	

							
				if ls_bujin_chk = "Y" then 
					messagebox("부진체크", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
            end if 	
				
				IF ls_given_fg = "Y"  AND ls_given_ymd <= is_yymmdd THEN 
					messagebox("품번검색", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				END IF 
				
					ls_style = lds_Source.GetItemString(1,"style")
					ls_chno  = lds_Source.GetItemString(1,"chno")
				
				   dw_body.SetItem(al_row, "style_no", ls_style + ls_chno)
				   dw_body.SetItem(al_row, "style",    lds_Source.GetItemString(1,"style"))
				   dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand"))
				   dw_body.SetItem(al_row, "color",    lds_Source.GetItemString(1,"color"))
				   dw_body.SetItem(al_row, "size",     lds_Source.GetItemString(1,"size"))
				   dw_body.SetItem(al_row, "qty",  1)				
				
 			
//			    if wf_stock_chk(al_row) = false then 
//					dw_body.SetColumn("style_no")
//					ib_itemchanged = FALSE
//					return 1 	
//				end if	
					
					
					
					ldc_tag_Price =  lds_Source.GetItemNumber(1,"tag_price")		

if is_brand = "E" and ls_year + ls_season = "2008W" and is_yymmdd <= "20090320" then	
		dw_body.SetItem(al_row, "dc_rate",    70)
		ldc_sale_amt  =  ldc_tag_Price * 0.30						
		dw_body.SetItem(al_row, "sale_amt",    ldc_sale_amt)	
		
elseif is_brand = "P"  then	
		dw_body.SetItem(al_row, "dc_rate",    30)
		ldc_sale_amt  =  ldc_tag_Price * 0.70						
		dw_body.SetItem(al_row, "sale_amt",    ldc_sale_amt)								
		
elseif is_brand = "B"   then	
					
		dw_body.SetItem(al_row, "dc_rate",    40)
		ldc_sale_amt  =  ldc_tag_Price * 0.6						
		dw_body.SetItem(al_row, "sale_amt",    ldc_sale_amt)												

elseif is_brand = "H"   then						
		dw_body.SetItem(al_row, "dc_rate",    90)
		ldc_sale_amt  =  ldc_tag_Price * 0.1						
		dw_body.SetItem(al_row, "sale_amt",    ldc_sale_amt)			

elseif is_brand = "I" and ls_year_no < '20131' then
		messagebox('확인','2013년도 코인코즈 이전 제품은 사내 판매가 안됩니다!')
		dw_body.reset()
		
elseif is_brand = "I" and ls_year_no = '20131' then
		dw_body.SetItem(al_row, "dc_rate",    70)
		ldc_sale_amt  =  ldc_tag_Price * 0.3						
		dw_body.SetItem(al_row, "sale_amt",    ldc_sale_amt)	

elseif is_brand = "I" and ls_year_no >= "20132" and ls_year_no <= '20134' then	
		dw_body.SetItem(al_row, "dc_rate",    60)
		ldc_sale_amt  =  ldc_tag_Price * 0.4
		dw_body.SetItem(al_row, "sale_amt",    ldc_sale_amt)

elseif is_brand = "I" and ls_year_no >= "20141" then
		messagebox('확인','2014년도 코인코즈 제품은 사내판매가 안됩니다!')
		dw_body.reset()
		
elseif is_brand <> "I" then

	if ls_bujin_chk = "Y" or ls_year_no <= '20124' then
			dw_body.SetItem(al_row, "dc_rate",    70)
			ldc_sale_amt  =  ldc_tag_Price * 0.3						
			dw_body.SetItem(al_row, "sale_amt",    ldc_sale_amt)							
	elseif ll_dc_cnt > 0 then	
		
		if isnull(ldc_dc_rate) or ldc_dc_rate < 50 then
			dw_body.SetItem(al_row, "dc_rate",    40)
			ldc_sale_amt  =  ldc_tag_Price * 0.6						
			dw_body.SetItem(al_row, "sale_amt",    ldc_sale_amt)							
		else	
			dw_body.SetItem(al_row, "dc_rate",    70)
			ldc_sale_amt  =  ldc_tag_Price * 0.3						
			dw_body.SetItem(al_row, "sale_amt",    ldc_sale_amt)																								
		end if						

	else	
		dw_body.SetItem(al_row, "dc_rate",    40)
		ldc_sale_amt  =  ldc_tag_Price * 0.6						
		dw_body.SetItem(al_row, "sale_amt",    ldc_sale_amt)												
	end if	
	
end if	


				   dw_body.SetItem(al_row, "bill_chk_ymd",  is_bill_ymd)					
			
				
				   ib_changed = true
               cb_update.enabled = true
				   /* 다음컬럼으로 이동 */
		         dw_body.SetColumn("qty")
			      lb_check = TRUE 

				ib_itemchanged = FALSE

			Destroy  lds_Source
			
	CASE "empno"		
		
//IF isnull(as_data) or Trim(as_data) = "" THEN
//		dw_head.SetItem(al_row, "empnm", "")
//		RETURN 0
//elseif mid(as_data,1,1)	= "N" or mid(as_data,1,1)	= "O" or mid(as_data,1,1)	= "W" then			
//					
////--------------------------------------------------		
//		   IF ai_div = 1 THEN 
//				IF gf_shop_nm3(as_data, 'S', ls_shop_nm) = 0 THEN					
//				   dw_head.SetItem(al_row, "dept_nm", ls_shop_nm)
//					RETURN 0
//				END IF 
//			END IF
//		   gst_cd.ai_div          = ai_div
//			gst_cd.window_title    = "매장 코드 검색" 
//			gst_cd.datawindow_nm   = "d_com912" 
//			ls_brand = dw_head.GetitemString(1, "brand")
//			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
//			                         "  AND SHOP_DIV  IN ('G', 'K') " + &
//											 "  AND BRAND = '" + ls_brand + "'"
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
//			ELSE
//				gst_cd.Item_where = ""
//			END IF
//
//			lds_Source = Create DataStore
//			OpenWithParm(W_COM200, lds_Source)
//
//			lb_check = FALSE 
//			IF Isvalid(Message.PowerObjectParm) THEN
//				ib_itemchanged = True
//				lds_Source = Message.PowerObjectParm
//				IF ai_div = 2 THEN 
//				   dw_head.SetRow(al_row)
//				   dw_head.SetColumn(as_column)
//				END IF
//				dw_head.SetItem(al_row, "empno", lds_Source.GetItemString(1,"shop_cd"))
//				dw_head.SetItem(al_row, "dept_nm", lds_Source.GetItemString(1,"shop_snm"))
//				/* 다음컬럼으로 이동 */
//	         dw_head.SetColumn("empnm")
//				ib_itemchanged = False 
//				lb_check = TRUE 
//			END IF
//			Destroy  lds_Source			
//			
//else			
//------------------------------------------------		
			IF ai_div = 1 THEN 
				if gf_emp_nm(as_data, ls_empnm) = 0 THEN
					dw_head.Setitem(al_row, "empnm", ls_empnm)
					
					select dept_nm
					into :ls_dept_nm
					from vi_93010_3 (nolock)
					where empno = :as_data;

					IF ISNULL(ls_dept_nm) OR ls_dept_nm = "" THEN 
//						return 1 
					ELSE											
						dw_head.Setitem(al_row, "dept_nm", ls_dept_nm)
						RETURN 0
					END IF	
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			/* 관련부서 산출 */ 
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(empno LIKE '" + as_data + "%' OR " + & 
				                    " kname LIKE '" + as_data + "%' )" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_HEAD.SetRow(al_row)
				dw_HEAD.SetColumn(as_column)
				dw_HEAD.SetItem(al_row, "empno",    lds_Source.GetItemString(1,"empno"))
				dw_HEAD.SetItem(al_row, "empnm", lds_Source.GetItemString(1,"kname"))
				dw_HEAD.SetItem(al_row, "dept_nm", lds_Source.GetItemString(1,"dept_nm"))				
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source			
//end if			
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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title, ls_time
long     li_date_part, li_cnt

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

//is_data_opt


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


is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"요청일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_rqst_no = dw_head.GetItemString(1, "rqst_no")
if IsNull(is_rqst_no) or Trim(is_rqst_no) = "" then
	is_rqst_no = "%"
end if

is_pay_way = dw_head.GetItemString(1, "pay_way")
if IsNull(is_pay_way) or Trim(is_pay_way) = "" then
   MessageBox(ls_title,"결제방법을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("pay_way")
   return false
end if

is_empno = dw_head.GetItemString(1, "empno")
if IsNull(is_empno) or Trim(is_empno) = "" then
	is_empno = "%"
end if

is_empnm = dw_head.GetItemString(1, "empnm")
if IsNull(is_empnm) or Trim(is_empnm) = "" then
	is_empnm = "%"
end if

//select convert(char(8), dateadd(day, 7, :is_yymmdd), 112)
//into :is_bill_ymd
//from dual;


select case when :is_yymmdd between convert(char(06), dateadd(mm, -1, :is_yymmdd),112) + '16'
			                       and substring(:is_yymmdd,1,6) + '15' then substring(:is_yymmdd,1,6) + '25' 
	         when :is_yymmdd between substring(:is_yymmdd,1,6) + '16'
			                      and convert(char(06), dateadd(mm, 1, :is_yymmdd),112) + '15' then convert(char(06), dateadd(mm, 1, :is_yymmdd),112) + '25' 
	end
into :is_bill_ymd	
from dual;	


select datepart(weekday, getdate()), convert(char(5),getdate(),114)
into :li_date_part, :ls_time
from dual;
  
if is_brand = "E" and is_yymmdd <= "20090320" then 
	return true
else	
	if gs_user_id = "991001" or gs_user_id = "991008" or gs_user_id = "B00405" or gs_user_id = "B31115" or gs_user_id = 'B51201'or gs_user_id = "B50101" or gs_user_id = "B60111" then
		return true
	else
		if li_date_part = 3  then
			if ls_time > '16:01' then
			  MessageBox(ls_title,"오후 4시이전까지 요청 가능합니다!")
			  return false		
			end if		
	
		else
		  MessageBox(ls_title,"화요일에만 요청 가능합니다!")
		  return false
		end if
		
		
		select count(*)
		into :li_cnt
		from tb_53060_h (nolock)
		where empno = :is_empno
		and kname like :is_empnm + '%'	
		and bill_ymd <  convert(char(8), getdate(),112)
		and pay_way = 'B'
		and isnull(bill_yn,'N') = 'N'
		and isnull(out_yn,'N') = 'Y' ;
		
			if li_cnt > 0 then
			  MessageBox(ls_title,"등록이 제한되었습니다. 물류에 확인하세요!")
			  return false		
			end if
	end if		
end if	

return true

end event

event type long ue_update();call super::ue_update;string ls_rqst_no, ls_no, ls_bill_yn, ls_bill_ymd
long i, ll_row_count,ll_tag_price, ll_sale_amt
decimal ldc_dc_rate
int li_no, li_qty
datetime ld_datetime



ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

   IF LenA(is_rqst_no) <> 4 then
		select  substring(convert(varchar(5), convert(decimal(5), isnull(max(rqst_no), '0000')) + 10001), 2, 4) 
		into :ls_rqst_no
		from tb_53060_h with (nolock)
		where  yymmdd = :is_yymmdd
		and    empno  = :is_empno;

		li_no = 1
   else
		ls_rqst_no = is_rqst_no
		
		select max(isnull(no,0)) + 1  
		into :li_no
		from tb_53060_h with (nolock)
		where  yymmdd = :is_yymmdd
		and    empno  = :is_empno
		and   rqst_no = :ls_rqst_no ;

	end if	

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	ls_bill_ymd = dw_body.getitemstring(i, "bill_ymd")
	
//	if wf_stock_chk(i) = false then 
//		dw_body.selectrow(i, true)
//		messagebox("알림!", "재고가 없는 품번입니다!. 삭제 후 다시 저장해주세요!")
//		return -1
//	end if	

	ll_tag_price     = dw_body.GetitemNumber(i, "tag_price") 
	ll_sale_amt      = dw_body.GetitemNumber(i, "sale_amt") 	
	ldc_dc_rate		  = dw_body.GetitemDecimal(i, "dc_rate") 
	li_qty 			  = dw_body.GetitemNumber(i, "qty") 
	
	if ll_sale_amt <> ll_tag_price * li_qty * ((100 - ldc_dc_rate) /100) then
		dw_body.selectrow(i, true)
		messagebox("알림!", "판매금액이 달라 저장할 수 없습니다!")
		return -1
	end if	

	
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "yymmdd", is_yymmdd)
      dw_body.Setitem(i, "rqst_no", ls_rqst_no)
      dw_body.Setitem(i, "no", string(li_no, "0000"))		
      dw_body.Setitem(i, "empno",  is_empno)
      dw_body.Setitem(i, "kname", is_empnm)
      dw_body.Setitem(i, "brand", is_brand)
      dw_body.Setitem(i, "pay_way", is_pay_way)
      dw_body.Setitem(i, "reg_id", gs_user_id)
		dw_body.selectrow(i, false)
		li_no = li_no + 1
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	dw_head.setitem(1, "rqst_no", ls_rqst_no)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_insert();
if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
else	
	IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN 
END IF

if is_pay_way = "%" then
   MessageBox("입력","결제방법을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("pay_way")
   Return 
end if

if is_empno = "%" then
   MessageBox("입력","사번(매장코드)를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("empno")
   Return 
end if

if is_empnm = "%" then
   MessageBox("입력","구매자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("empnm")
   Return 
end if


if MidA(is_empno,1,1) = "N" or MidA(is_empno,1,1) = "O" or MidA(is_empno,1,1) = "W" then 
	if is_pay_way = "A" then
		messagebox("알림!", "매장사원 판매는 급여공제가 불가합니다!")
		return
	end if
end if	

il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_1.retrieve(is_yymmdd, is_rqst_no, is_empno, is_empnm, is_brand, is_pay_way)
IF il_rows > 0 THEN
   dw_1.visible = true
   dw_1.SetFocus()
else	
   dw_1.visible = false
   dw_1.SetFocus()	
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(cb_input, "FixedToRight")
dw_1.SetTransObject(SQLCA)
end event

event open;call super::open;select data_level
into :is_data_opt
from tb_93010_m (nolock)
where person_id = :gs_user_id;


//if is_data_opt = "V" then
//	dw_body.object.bill_yn.protect = 1
//	dw_body.object.bill_chk_ymd.protect = 1
//else	
//	dw_body.object.bill_yn.protect = 0
//	dw_body.object.bill_chk_ymd.protect = 0
//end if	
end event

event ue_button(integer ai_cb_div, long al_rows);
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_input.enabled = false			
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
			cb_input.enabled = true
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
			cb_input.enabled = true
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
		cb_input.enabled = true
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event ue_delete();/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row
string      ls_out_yn

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

if idw_status = NewModified! THEN	
	il_rows = dw_body.DeleteRow (ll_cur_row)
end if

dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"W_53032_e","0")
end event

type cb_close from w_com010_e`cb_close within w_53032_e
end type

type cb_delete from w_com010_e`cb_delete within w_53032_e
end type

type cb_insert from w_com010_e`cb_insert within w_53032_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_53032_e
end type

type cb_update from w_com010_e`cb_update within w_53032_e
end type

type cb_print from w_com010_e`cb_print within w_53032_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_53032_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_53032_e
end type

type cb_excel from w_com010_e`cb_excel within w_53032_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_53032_e
integer x = 32
integer height = 208
string dataobject = "D_53032_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::itemchanged;call super::itemchanged;String ls_yymmdd

CHOOSE CASE dwo.name

	CASE "empno"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if isnull(data) = false or data <> "" then 
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		end if
END CHOOSE
end event

type ln_1 from w_com010_e`ln_1 within w_53032_e
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_e`ln_2 within w_53032_e
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_e`dw_body within w_53032_e
event ue_set_col ( string as_column )
integer y = 400
integer height = 1608
string dataobject = "d_53032_d02"
end type

event dw_body::ue_set_col(string as_column);This.SetColumn(as_column)
end event

event dw_body::constructor;call super::constructor;
This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.insertRow(0)

This.GetChild("size", idw_size)
idw_size.SetTransObject(SQLCA)
idw_size.insertRow(0)


end event

event dw_body::itemchanged;call super::itemchanged;Long    ll_ret, ll_curr_price, ll_qty, ll_sale_price 
Decimal ldc_margin_rate
String ls_null
Setnull(ls_null) 

CHOOSE CASE dwo.name
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
		if This.GetitemString(row, "size") <> 'XX' then
			This.Setitem(row, "size", ls_null) 
			This.Post Event ue_set_col("size")
		end if	
	CASE "qty" 
		ll_qty   = Long(Data) 
		IF isnull(ll_qty) or ll_qty = 0 THEN RETURN 1 
		ll_sale_price = This.GetitemNumber(row, "tag_price")
      /* 금액 처리           */
		wf_amt_set(row, ll_qty, ll_sale_price) 
		wf_stock_chk(row)

END CHOOSE

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;String ls_style, ls_chno, ls_color, ls_size

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
	CASE "qty"
		ls_style = This.GetitemString(row, "style")
		ls_chno  = This.GetitemString(row, "chno")
		ls_color = This.GetitemString(row, "color")
		ls_size  = This.GetitemString(row, "size")		
	 //  if wf_stock_chk(row)  then return 1
		
END CHOOSE

end event

event dw_body::doubleclicked;call super::doubleclicked;String 	ls_search
if row > 0 then 
	choose case dwo.name
		case 'style','style_no'
			ls_search 	= this.GetItemString(row,string(dwo.name))
			if LenA(ls_search) >= 8 then gf_style_color_pic(ls_search, '%','%')			
	end choose	
end if

end event

type dw_print from w_com010_e`dw_print within w_53032_e
end type

type dw_1 from datawindow within w_53032_e
boolean visible = false
integer x = 5
integer y = 400
integer width = 3589
integer height = 1640
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_53032_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;String ls_rqst_no, ls_empno, ls_empnm, ls_pay_way , ls_dept_nm
sTRING ls_rot_yn, ls_box_no, ls_proc_yn

IF row < 0 THEN RETURN 

ls_rqst_no   = This.GetitemString(row, "rqst_no")
ls_empno     = This.GetitemString(row, "empno")
ls_empnm     = This.GetitemString(row, "kname")
ls_pay_way     = This.GetitemString(row, "pay_way")

IF dw_body.Retrieve(is_yymmdd, ls_rqst_no,  ls_empno) > 0 THEN 
   dw_body.visible = True						  
   dw_1.visible = False 
	cb_insert.Enabled = True
	
	if MidA(ls_empno,1,1) = "N" or  MidA(ls_empno,1,1) = "O" or  MidA(ls_empno,1,1) = "W" then
		select shop_snm
		into :ls_dept_nm
		from tb_91100_m (nolock)
		where shoP_cd = :ls_empno;
	else	
		select dept_nm
		into :ls_dept_nm
		from vi_93010_1 (nolock)
		where person_id = :ls_empno;
	end if
	
	dw_body.SetFocus()
	dw_head.setitem(1, "rqst_no", ls_rqst_no)
	dw_head.setitem(1, "empno", ls_empno)	
	dw_head.setitem(1, "empnm", ls_empnm)		
	dw_head.setitem(1, "dept_nm", ls_dept_nm)			
	dw_head.setitem(1, "pay_way", ls_pay_way)	
	
END IF


end event

type st_1 from statictext within w_53032_e
boolean visible = false
integer x = 23
integer y = 404
integer width = 2523
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
string text = "※ 현금입금 계좌번호: 온앤온,W. - 외환 223-13-02918-6 (주)보끄레머천다이징"
boolean focusrectangle = false
end type

type st_2 from statictext within w_53032_e
boolean visible = false
integer x = 114
integer y = 520
integer width = 3022
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "현금 입금시 본인이 아닌 다른 사람의 이름으로 입금시 꼭 물류센타의 담당자에게 연락 바랍니다."
boolean focusrectangle = false
end type

type st_3 from statictext within w_53032_e
boolean visible = false
integer x = 718
integer y = 464
integer width = 1586
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "올리브   - 외환 631-000306-821 올리브 데 올리브(주)"
boolean focusrectangle = false
end type

type cb_input from commandbutton within w_53032_e
integer x = 2546
integer y = 52
integer width = 325
integer height = 84
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "신규(&I)"
end type

event clicked;IF dw_head.Enabled THEN
   Parent.Trigger Event ue_input()	//등록 
ELSE 
	Parent.Trigger Event ue_head()	//조건 
END IF

end event

