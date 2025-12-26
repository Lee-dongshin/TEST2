$PBExportHeader$w_sh101_20051109.srw
$PBExportComments$판매일보등록
forward
global type w_sh101_20051109 from w_com010_e
end type
type dw_1 from datawindow within w_sh101_20051109
end type
type cb_1 from commandbutton within w_sh101_20051109
end type
type dw_list from datawindow within w_sh101_20051109
end type
type st_1 from statictext within w_sh101_20051109
end type
type dw_2 from datawindow within w_sh101_20051109
end type
type dw_3 from datawindow within w_sh101_20051109
end type
type st_2 from statictext within w_sh101_20051109
end type
type gb_1 from groupbox within w_sh101_20051109
end type
end forward

global type w_sh101_20051109 from w_com010_e
integer width = 2953
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
event ue_tot_set ( )
event ue_total_retrieve ( )
dw_1 dw_1
cb_1 cb_1
dw_list dw_list
st_1 st_1
dw_2 dw_2
dw_3 dw_3
st_2 st_2
gb_1 gb_1
end type
global w_sh101_20051109 w_sh101_20051109

type variables
String is_yymmdd, is_sale_no

end variables

forward prototypes
public subroutine wf_line_chk (long al_row)
public subroutine wf_amt_set (long al_row, long al_sale_qty)
public subroutine wf_goods_amt_clear ()
public function boolean wf_goods_chk (long al_goods_amt)
public function boolean wf_member_set (string as_flag, string as_find)
public function boolean wf_style_set (long al_row, string as_style)
public function boolean uf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name)
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

event ue_tot_set();Long ll_sale_qty, ll_sale_amt

ll_sale_qty = Long(dw_body.Describe("evaluate('sum(sale_qty)',0)"))
ll_sale_amt = Long(dw_body.Describe("evaluate('sum(sale_amt)',0)"))

dw_1.Setitem(1, "sale_qty", ll_sale_qty)
dw_1.Setitem(1, "sale_amt", ll_sale_amt)

Return

end event

event ue_total_retrieve();Long ll_row 

ll_row = dw_2.Retrieve(is_yymmdd, gs_shop_cd)
dw_2.ShareData(dw_3)
IF ll_row < 1 THEN
	dw_2.insertRow(0) 
END IF 
end event

public subroutine wf_line_chk (long al_row);long ll_curr_amt, ll_out_amt, ll_sale_amt, ll_sale_collect, ll_io_amt, ll_io_vat, ll_goods_amt
decimal ldc_out_rate, ldc_sale_rate

ll_curr_amt = dw_body.getitemdecimal(al_row,"curr_amt")
ll_out_amt = dw_body.getitemdecimal(al_row,"out_amt")
ll_sale_amt = dw_body.getitemdecimal(al_row,"sale_amt")
ll_sale_collect = dw_body.getitemdecimal(al_row,"sale_collect")
ll_io_amt = dw_body.getitemdecimal(al_row,"io_amt")
ll_io_vat = dw_body.getitemdecimal(al_row,"io_vat")
ldc_out_rate  = dw_body.getitemdecimal(al_row,"out_rate")
ldc_sale_rate = dw_body.getitemdecimal(al_row,"sale_rate")
ll_goods_amt = dw_body.getitemdecimal(al_row,"goods_amt")


if abs(ll_out_amt - round(ll_curr_amt * (100 - ldc_out_rate)/100,0)) > 3 then 
	ll_out_amt = round(ll_curr_amt * (100 - ldc_out_rate)/100,0)
	dw_body.setitem(al_row,"out_amt", ll_out_amt)
end if

if isnull(ll_goods_amt) then ll_goods_amt = 0

if abs(ll_sale_collect - round((ll_sale_amt - ll_goods_amt) * (100 - ldc_sale_rate)/100,0)) > 3 then 
	ll_sale_collect = round((ll_sale_amt - ll_goods_amt) * (100 - ldc_sale_rate)/100,0)
	dw_body.setitem(al_row,"sale_collect", ll_sale_collect)
end if

if ll_io_amt <> (ll_out_amt - ll_sale_collect) then
	ll_io_amt  = ll_out_amt - ll_sale_collect
	dw_body.setitem(al_row,"io_amt", ll_io_amt)
end if


if ll_io_vat <> (ll_io_amt - round(ll_io_amt/1.1,0) ) then
	ll_io_vat  = (ll_io_amt - round(ll_io_amt/1.1,0) )
	dw_body.setitem(al_row,"io_vat", ll_io_vat)
end if

return


end subroutine

public subroutine wf_amt_set (long al_row, long al_sale_qty);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_sale_price, ll_out_price, ll_collect_price
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect  
Decimal ldc_marjin

ll_tag_price     = dw_body.GetitemDecimal(al_row, "tag_price") 
ll_curr_price    = dw_body.GetitemDecimal(al_row, "curr_price") 
ll_sale_price    = dw_body.GetitemDecimal(al_row, "sale_price") 
ll_out_price     = dw_body.GetitemNumber(al_row, "out_price") 
ll_collect_price = dw_body.GetitemNumber(al_row, "collect_price")

dw_body.Setitem(al_row, "tag_amt",  ll_tag_price  * al_sale_qty)
dw_body.Setitem(al_row, "curr_amt", ll_curr_price * al_sale_qty)
dw_body.Setitem(al_row, "sale_amt", ll_sale_price * al_sale_qty)
dw_body.Setitem(al_row, "out_amt",  ll_out_price  * al_sale_qty) 

ll_goods_amt = dw_body.GetitemDecimal(al_row, "goods_amt") 
IF ll_goods_amt > 0 THEN 
	ldc_marjin = dw_body.GetitemDecimal(al_row, "sale_rate")
	gf_marjin_price(gs_shop_cd, (ll_sale_price * al_sale_qty) - ll_goods_amt, ldc_marjin, ll_sale_collect)  
ELSE
	ll_sale_collect = ll_collect_price * al_sale_qty  
END IF
dw_body.Setitem(al_row, "sale_collect", ll_sale_collect) 

/* 세일 재매입 처리 */
ll_io_amt = (ll_out_price  * al_sale_qty) - ll_sale_collect
dw_body.Setitem(al_row, "io_amt", ll_io_amt)
dw_body.Setitem(al_row, "io_vat", ll_io_amt - Round(ll_io_amt / 1.1, 0))


end subroutine

public subroutine wf_goods_amt_clear ();long i , ll_row_count

ll_row_count = dw_body.rowcount()

FOR i=1 TO ll_row_count
	dw_body.Setitem(i, "goods_amt", 0)
	dw_body.Setitem(i, "coupon_no", '')
	
NEXT


//dw_1.setitem(1, "goods_amt", 0)

end subroutine

public function boolean wf_goods_chk (long al_goods_amt);
Long 	  j, i, k, ll_accept_point, ll_remain_point, ll_total_point , ll_row_count,ll_goods_amt,ll_sale_price, ll_sale_price2,ll_sale_qty   
decimal ld_goods_amt, ld_mok, ld_qty, ld_coupon_amt, ld_check_amt,ld_tot_goods_amt 
string  ls_jumin, ls_card_no, ls_sale_fg, ls_style_no, ls_item, ls_coupon_no, ls_coupon_yn
integer il_remain_amt

 wf_goods_amt_clear()

ls_jumin        = dw_1.GetitemString (1, "jumin")          // 주민번호
ld_goods_amt    = dw_1.Getitemdecimal(1, "goods_amt")      // 사용할 금액
ll_total_point  = dw_1.getitemdecimal( 1, "total_point")   // 총 포인트 
ll_remain_point = dw_1.getitemdecimal( 1, "remain_point")  // 남은 포인트 
ll_accept_point = ld_goods_amt                   	    			 // 사용할 포인트
ls_coupon_yn = 'n'

ll_row_count = dw_body.RowCount()

IF isnull(al_goods_amt) OR al_goods_amt = 0 THEN 
	 wf_goods_amt_clear()
	RETURN TRUE 
END IF

select top 1 give_point * 10,
		 coupon_no
  into :ld_coupon_amt, :ls_coupon_no 
from	tb_71011_h (nolock)
where jumin       = :ls_jumin
and	point_flag  = '1'
and   accept_flag = 'N';

//  logic start -- 2005. 02.05 ~ 2005. 02.28 구매할인권 행사  //
//  					  			
//			if  ld_goods_amt  = 20000   and  gs_brand  <> 'O'   then
//					  messagebox('확인', "2만원권 구매할인권은 올리브 매장에서만 사용가능 합니다 !")
//						return FALSE
//			end if
//			
//			if  ld_coupon_amt  = 20000  and  gs_brand  <> 'O'   then
//						ld_coupon_amt = 0		 	
//			end if
//			
//			
//			if   ld_goods_amt  = 30000   and  gs_brand  = 'O'  then
//					  messagebox('확인', "3만원권 구매할인권은 올리브 매장에서는 사용할수 없습니다 !")
//						return FALSE
//			end if
//			
//			if   ld_coupon_amt  = 30000  and  gs_brand  = 'O'  then	
//					  ld_coupon_amt = 0
//			end if
//			
//			if ld_coupon_amt = 50000  and  gs_brand  = 'O'  then	
//		//			  messagebox('확인', "5만원권 구매할인권은 올리브 매장에서는 사용할수 없습니다 !")
//					  ld_coupon_amt = 0
//			end if
		
//  logic end --  2005. 02.05 ~ 2005. 02.28 구매할인권 행사  // 
 
	ll_goods_amt = dw_1.GetitemNumber(1, "goods_amt")  
	
	IF isnull(ll_goods_amt) THEN ll_goods_amt = 0 
	

  il_remain_amt =  (ll_remain_point  / 50000) 
  ll_remain_point = il_remain_amt * 50000
	  
  IF ll_remain_point + ld_coupon_amt < ll_goods_amt then
	   MessageBox("Point 오류", "사용할 Point가 부족합니다1.")
		wf_goods_amt_clear()
		dw_1.setitem(1,"goods_amt",0)
		dw_1.SetColumn("goods_amt")
		return FALSE
	END IF


ld_mok = MOD(ll_goods_amt , 50000) 
ld_check_amt = MOD(ll_goods_amt - ld_coupon_amt, 50000)


IF ld_mok <> 0  AND ld_check_amt <> 0 then
	MessageBox("Point 오류", "사용할 Point를 정확하게 입력하세요 .")
	wf_goods_amt_clear()
	dw_1.setitem(1,"goods_amt",0)
	dw_1.SetColumn("goods_amt")
	return FALSE
END IF

IF (ld_coupon_amt  > 0  and  ld_mok <> 0) or (ld_coupon_amt = 50000)  THEN	
	FOR i=1 TO ll_row_count
		ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))				
		ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
		ls_style_no   = dw_body.Getitemstring(i, "style_no")
		ls_item       = RightA(LeftA(ls_style_no,2),1)

	
	// 가장 최저가 상품에 구매할인권을 쓰게 처리 
	if is_yymmdd > '20050331' then
			IF ld_coupon_amt > 0 and ll_sale_price > ld_coupon_amt and  & 
				ll_sale_qty  > 0 and LeftA(dw_body.Object.sale_type[i], 2) = '11' THEN  	
				k = k + 1
				if k= 1 then
					ll_sale_price2 = ll_sale_price 
				end if
							
				if ll_sale_price <= ll_sale_price2 then				
					for j = 1 to i
						dw_body.Setitem(j,"coupon_no", '')
						dw_body.Setitem(j,"goods_amt", 0)
					next
					ll_sale_price2 = ll_sale_price 
					ls_coupon_yn = 'y'
					dw_body.Setitem(i,"coupon_no", ls_coupon_no)
					dw_body.Setitem(i,"goods_amt", ld_coupon_amt) 				
				end if
				
			END IF
	else
			IF ld_coupon_amt > 0 and ll_sale_price > ld_coupon_amt and  & 
				ll_sale_qty  > 0 and LeftA(dw_body.Object.sale_type[i], 2) = '11'  and &
				ls_item  <> 'X' THEN  	
				k = k + 1
				if k= 1 then
					ll_sale_price2 = ll_sale_price 
				end if
							
				if ll_sale_price <= ll_sale_price2 then				
					for j = 1 to i
						dw_body.Setitem(j,"coupon_no", '')
						dw_body.Setitem(j,"goods_amt", 0)
					next
					ll_sale_price2 = ll_sale_price 
					ls_coupon_yn = 'y'
					dw_body.Setitem(i,"coupon_no", ls_coupon_no)
					dw_body.Setitem(i,"goods_amt", ld_coupon_amt) 				
				end if
				
			END IF
	
		end if
		
	NEXT
ELSE
	FOR  i=1 TO ll_row_count
		  dw_body.Setitem(i,"coupon_no", '')
		  dw_body.Setitem(i,"goods_amt", 0)
	NEXT
END IF 	

//  사용할 쿠폰이 있으면 쿠폰금액 만큼 차감 
if	ls_coupon_yn = 'y' then
	ll_goods_amt = ll_goods_amt - ld_coupon_amt
	ld_coupon_amt = 0	
end if


//IF (ld_coupon_amt  > 0  and  ld_mok <> 0) or (ld_coupon_amt = 50000)  THEN	
//	FOR i=1 TO ll_row_count
//		ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))
//		ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
//		ls_style_no   = dw_body.Getitemstring(i, "style_no")
//		ls_item       = right(left(ls_style_no,2),1)
//	
//		IF ld_coupon_amt > 0 and ll_sale_price > ld_coupon_amt and  & 
//			ll_sale_qty  > 0 and Left(dw_body.Object.sale_type[i], 2) = '11'  and &
//			ls_item  <> 'X' THEN  
//			
//			if ll_goods_amt >= ld_coupon_amt   then 
//				ls_sale_fg = '2' 
//				dw_body.Setitem(i,"coupon_no", ls_coupon_no)
//				dw_body.Setitem(i,"goods_amt", ld_coupon_amt)
//				ll_goods_amt = ll_goods_amt - ld_coupon_amt
//				ld_coupon_amt = 0				
//			else 	
//				dw_body.Setitem(i,"coupon_no", '')
//				dw_body.Setitem(i,"goods_amt", 0)
//			end if
//		ELSE
//			dw_body.Setitem(i,"coupon_no", '')
//			dw_body.Setitem(i,"goods_amt", 0)
//			ls_sale_fg = '0' 
//		END IF		 
//	NEXT
//ELSE
//	FOR  i=1 TO ll_row_count
//		  dw_body.Setitem(i,"coupon_no", '')
//		  dw_body.Setitem(i,"goods_amt", 0)
//	NEXT
//END IF 	
//	
   IF ll_remain_point < ll_goods_amt then
		    return true
	END IF
	
	IF  ll_goods_amt < 50000  then
		 	IF ld_coupon_amt > 0  then 
				MessageBox("Point 오류", "구매할인권 사용할 품목이 없습니다!")
				wf_goods_amt_clear()
				dw_1.setitem(1,"goods_amt",0)
				dw_1.SetColumn("goods_amt")
				return false  
			else
				return true
			end if
	END IF
	

	IF ll_remain_point < 50000 		then 
		MessageBox("Point 오류", "남은 포인트가 50000원 이상 일때만 사용가능 합니다.")
		wf_goods_amt_clear()
		dw_1.setitem(1,"goods_amt",0)
		dw_1.SetColumn("goods_amt")
		return false               
	END IF
	

	ld_mok = MOD(ll_goods_amt , 50000) 
	
	if ld_mok <> 0 then
		MessageBox("Point 오류", "1PCS에 50000원 단위로 입력하세요. ")
		wf_goods_amt_clear()
		dw_1.setitem(1,"goods_amt",0)
		dw_1.SetColumn("goods_amt")
		return false    
	end if
	
	
	
	/* point 판매 처리 및 가능여부 체크 (정상판매단가가  Point금액 이상 매출만 가능)*/

	
	IF isnull(ll_goods_amt) THEN ll_goods_amt = 0 
	
	FOR i=1 TO ll_row_count
		
		ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))
		ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
		ls_style_no   = dw_body.Getitemstring(i, "style_no")
		ls_item       = RightA(LeftA(ls_style_no,2),1)
		ls_coupon_no   = dw_body.Getitemstring(i, "coupon_no")
		
		IF ls_coupon_no = '' then		
			if is_yymmdd > '20050331' then
						IF ll_goods_amt > 0 and ll_sale_price > 50000 and  & 
							ll_sale_qty  > 0 and LeftA(dw_body.Object.sale_type[i], 2) = '11'  THEN  
							ls_sale_fg = '2' 
							if ll_goods_amt >=  50000 then 
								dw_body.Setitem(i,"goods_amt", 50000)						
								ll_goods_amt = ll_goods_amt - 50000
							else 	
								dw_body.Setitem(i,"goods_amt", 0)
								ls_sale_fg = '1' 
							end if
						ELSE
							dw_body.Setitem(i,"goods_amt", 0)
							ls_sale_fg = '0' 
						END IF	
			else			
						IF ll_goods_amt > 0 and ll_sale_price > 50000 and  & 
							ll_sale_qty  > 0 and LeftA(dw_body.Object.sale_type[i], 2) = '11'  and &
							ls_item  <> 'X' THEN  
							ls_sale_fg = '2' 
							if ll_goods_amt >=  50000 then 
								dw_body.Setitem(i,"goods_amt", 50000)						
								ll_goods_amt = ll_goods_amt - 50000
							else 	
								dw_body.Setitem(i,"goods_amt", 0)
								ls_sale_fg = '1' 
							end if
						ELSE
							dw_body.Setitem(i,"goods_amt", 0)
							ls_sale_fg = '0' 
						END IF					
			end if	
				dw_body.setitem(i,"sale_fg",ls_sale_fg)
		END IF
	NEXT
	
	ld_tot_goods_amt =  dw_body.Getitemdecimal(1,"tot_goods_amt")
	
	IF ld_tot_goods_amt  = ld_goods_amt THEN 
		RETURN TRUE 
	ELSE
		MessageBox("Point 오류", "사용할 Point가 틀립니다 .")
		wf_goods_amt_clear()
		dw_1.setitem(1,"goods_amt",0)
		dw_1.SetColumn("goods_amt")
	END IF
	
	IF ll_goods_amt > 50000 then
		MessageBox("Point 오류", "사용할 Point가 구매할 상품보다 많습니다.")
		 wf_goods_amt_clear()
		 dw_1.setitem(1,"goods_amt",0)
		 dw_1.SetColumn("goods_amt")
		RETURN false	
	END IF 
				
	IF ll_remain_point >= ll_accept_point THEN 
		RETURN TRUE 
	ELSE
		MessageBox("Point 오류", "사용할 Point가 부족합니다2.")
		wf_goods_amt_clear()
		dw_1.setitem(1,"goods_amt",0)
		dw_1.SetColumn("goods_amt")
	END IF
	
	


RETURN FALSE





//Long 	  i, ll_accept_point, ll_remain_point, ll_total_point , ll_row_count,ll_goods_amt,ll_sale_price, ll_sale_qty   
//decimal ld_goods_amt, ld_mok, ld_qty, ld_coupon_amt, ld_check_amt,ld_tot_goods_amt
//string  ls_jumin, ls_card_no, ls_sale_fg, ls_style_no, ls_item, ls_coupon_no
//integer il_remain_amt
//
//
//ls_jumin        = dw_1.GetitemString (1, "jumin")          // 주민번호
//ld_goods_amt    = dw_1.Getitemdecimal(1, "goods_amt")      // 사용할 금액
//ll_total_point  = dw_1.getitemdecimal( 1, "total_point")   // 총 포인트 
//ll_remain_point = dw_1.getitemdecimal( 1, "remain_point")  // 남은 포인트 
//ll_accept_point = ld_goods_amt                             // 사용할 포인트
//
//
//ll_row_count = dw_body.RowCount()
//
//IF isnull(al_goods_amt) OR al_goods_amt = 0 THEN 
//	 wf_goods_amt_clear()
//	RETURN TRUE 
//END IF
//
//select top 1 give_point * 10,
//		 coupon_no
//  into :ld_coupon_amt, :ls_coupon_no 
//from	tb_71011_h (nolock)
//where jumin       = :ls_jumin
//and	point_flag  = '1'
//and   accept_flag = 'N';
//
//
// 
//	ll_goods_amt = dw_1.GetitemNumber(1, "goods_amt")  
//	
//	IF isnull(ll_goods_amt) THEN ll_goods_amt = 0 
//	
//
//  il_remain_amt =  (ll_remain_point  / 50000)
//  
//  ll_remain_point = il_remain_amt  * 50000 
//	  
//  IF ll_remain_point + ld_coupon_amt < ll_goods_amt then
//	   MessageBox("Point 오류", "사용할 Point가 부족합니다1.")
//		wf_goods_amt_clear()
//		dw_1.setitem(1,"goods_amt",0)
//		dw_1.SetColumn("goods_amt")
//		return FALSE
//	END IF
//
//
//ld_mok = MOD(ll_goods_amt , 50000) 
//ld_check_amt = MOD(ll_goods_amt - ld_coupon_amt, 50000)
//
//
//IF ld_mok <> 0  AND ld_check_amt <> 0 then
//	MessageBox("Point 오류", "사용할 Point를 정확하게 입력하세요 .")
//	wf_goods_amt_clear()
//	dw_1.setitem(1,"goods_amt",0)
//	dw_1.SetColumn("goods_amt")
//	return FALSE
//END IF
//
//
//
//
//IF (ld_coupon_amt  > 0  and  ld_mok <> 0) or (ld_coupon_amt = 50000)  THEN	
//	FOR i=1 TO ll_row_count
//		ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))
//		ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
//		ls_style_no   = dw_body.Getitemstring(i, "style_no")
//		ls_item       = right(left(ls_style_no,2),1)
//	
//		IF ld_coupon_amt > 0 and ll_sale_price > ld_coupon_amt and  & 
//			ll_sale_qty  > 0 and Left(dw_body.Object.sale_type[i], 2) = '11'  and &
//			ls_item  <> 'X' THEN  
//			
//			if ll_goods_amt >= ld_coupon_amt   then 
//				ls_sale_fg = '2' 
//				dw_body.Setitem(i,"coupon_no", ls_coupon_no)
//				dw_body.Setitem(i,"goods_amt", ld_coupon_amt)
//				ll_goods_amt = ll_goods_amt - ld_coupon_amt
//				ld_coupon_amt = 0				
//			else 	
//				dw_body.Setitem(i,"coupon_no", '')
//				dw_body.Setitem(i,"goods_amt", 0)
//			end if
//		ELSE
//			dw_body.Setitem(i,"coupon_no", '')
//			dw_body.Setitem(i,"goods_amt", 0)
//			ls_sale_fg = '0' 
//		END IF		 
//	NEXT
//ELSE
//	FOR  i=1 TO ll_row_count
//		  dw_body.Setitem(i,"coupon_no", '')
//		  dw_body.Setitem(i,"goods_amt", 0)
//	NEXT
//END IF 	
//	
//   IF ll_remain_point < ll_goods_amt then
//		    return true
//	END IF
//	
//	IF  ll_goods_amt < 50000  then
//		 	IF ld_coupon_amt > 0  then 
//				MessageBox("Point 오류", "구매할인권 사용할 품목이 없습니다!")
//				wf_goods_amt_clear()
//				dw_1.setitem(1,"goods_amt",0)
//				dw_1.SetColumn("goods_amt")
//				return false  
//			else
//				return true
//			end if
//	END IF
//	
//
//	IF ll_remain_point < 50000 		then 
//		MessageBox("Point 오류", "남은 포인트가 50000원 이상 일때만 사용가능 합니다.")
//		wf_goods_amt_clear()
//		dw_1.setitem(1,"goods_amt",0)
//		dw_1.SetColumn("goods_amt")
//		return false               
//	END IF
//	
//
//	ld_mok = MOD(ll_goods_amt , 50000) 
//	
//	if ld_mok <> 0 then
//		MessageBox("Point 오류", "1PCS에 50000원 단위로 입력하세요. ")
//		wf_goods_amt_clear()
//		dw_1.setitem(1,"goods_amt",0)
//		dw_1.SetColumn("goods_amt")
//		return false    
//	end if
//	
//	
//	
//	/* point 판매 처리 및 가능여부 체크 (정상판매단가가  Point금액 이상 매출만 가능)*/
//
//	
//	IF isnull(ll_goods_amt) THEN ll_goods_amt = 0 
//	
//	FOR i=1 TO ll_row_count
//		
//		ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))
//		ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
//		ls_style_no   = dw_body.Getitemstring(i, "style_no")
//		ls_item       = right(left(ls_style_no,2),1)
//		ls_coupon_no   = dw_body.Getitemstring(i, "coupon_no")
//		
//		IF ls_coupon_no = '' then					
//				IF ll_goods_amt > 0 and ll_sale_price > 50000 and  & 
//					ll_sale_qty  > 0 and Left(dw_body.Object.sale_type[i], 2) = '11'  and &
//					ls_item  <> 'X' THEN  
//					ls_sale_fg = '2' 
//					if ll_goods_amt >=  50000 then 
//						dw_body.Setitem(i,"goods_amt", 50000)						
//						ll_goods_amt = ll_goods_amt - 50000
//					else 	
//						dw_body.Setitem(i,"goods_amt", 0)
//						ls_sale_fg = '1' 
//					end if
//				ELSE
//					dw_body.Setitem(i,"goods_amt", 0)
//					ls_sale_fg = '0' 
//				END IF	
//				dw_body.setitem(i,"sale_fg",ls_sale_fg)
//		END IF
//	NEXT
//	
//	ld_tot_goods_amt =  dw_body.Getitemdecimal(1,"tot_goods_amt")
//	
//	IF ld_tot_goods_amt  = ld_goods_amt THEN 
//		RETURN TRUE 
//	ELSE
//		MessageBox("Point 오류", "사용할 Point가 틀립니다 .")
//		wf_goods_amt_clear()
//		dw_1.setitem(1,"goods_amt",0)
//		dw_1.SetColumn("goods_amt")
//	END IF
//	
//	IF ll_goods_amt > 50000 then
//		MessageBox("Point 오류", "사용할 Point가 구매할 상품보다 많습니다.")
//		 wf_goods_amt_clear()
//		 dw_1.setitem(1,"goods_amt",0)
//		 dw_1.SetColumn("goods_amt")
//		RETURN false	
//	END IF 
//				
//	IF ll_remain_point >= ll_accept_point THEN 
//		RETURN TRUE 
//	ELSE
//		MessageBox("Point 오류", "사용할 Point가 부족합니다2.")
//		wf_goods_amt_clear()
//		dw_1.setitem(1,"goods_amt",0)
//		dw_1.SetColumn("goods_amt")
//	END IF
//	
//	
//
//
//RETURN FALSE
//
end function

public function boolean wf_member_set (string as_flag, string as_find);String  ls_user_name,   ls_jumin,      ls_card_no,      ls_age_grp, ls_tel_no3
Long    ll_total_point, ll_give_point, ll_accept_point, ll_year, ll_coupon_cnt 
Decimal ld_give_point
DataStore	lds_source	
Boolean lb_return 
IF as_flag = '3' THEN
		if LenA(as_find) < 10 then 
			messagebox("확인","전화번호를 올바로 입력하세요..")			
			return true				
		elseif uf_chk_phone(as_find, ls_jumin,ls_user_name) THEN
			dw_1.SetItem(1, "jumin",     ls_jumin)
		else 			
			gst_cd.ai_div          = 1
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""
			IF Trim(as_find) <> "" THEN
				gst_cd.Item_where   = " tel_no3 = '" + as_find + "'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_1.SetRow(1)
				ls_jumin = lds_Source.GetItemString(1,"jumin")
				dw_1.SetItem(1, "jumin",  ls_jumin) 

			END IF			
			Destroy  lds_Source	
		end if
		as_flag = '1'
		as_find = ls_jumin
end if
	
			
IF as_flag = '1' THEN
	SELECT user_name,       jumin,          card_no,
			 total_point * 10,     give_point * 10,     accept_point * 10, tel_no3 
	  INTO :ls_user_name,   :ls_jumin,      :ls_card_no,  
			 :ll_total_point, :ll_give_point, :ll_accept_point, :ls_tel_no3
	  FROM TB_71010_M  with (nolock)  
	 WHERE jumin   = :as_find ; 
	
ELSE
	SELECT user_name,       jumin,          card_no,
			 total_point * 10,     give_point * 10,     accept_point * 10, tel_no3
	  INTO :ls_user_name,   :ls_jumin,      :ls_card_no,  
			 :ll_total_point, :ll_give_point, :ll_accept_point, :ls_tel_no3
	  FROM TB_71010_M  with (nolock)   
	 WHERE card_no = '4870090' + :as_find ; 
END IF

IF SQLCA.SQLCODE <> 0 AND isnull(as_find) = false THEN 
	lb_return = False  
ELSEIF isnull(ls_card_no) OR Trim(ls_card_no) = "" THEN
	SetNull(ls_jumin)
	lb_return = False  
ELSE	
	lb_return = True 
END IF


if (ll_total_point - ll_accept_point) >= 50000 then 
	dw_1.object.text_message.text = "사용할 Point금액이 있습니다 !"
else 
	dw_1.object.text_message.text = ""
end if

select top 1 give_point * 10
into	 :ld_give_point
from	 tb_71011_h (nolock)
where jumin       = :ls_jumin
and	point_flag  = '1'
and   accept_flag = 'N'
and   coupon_no is not null ;


if ld_give_point >  0 then 
	dw_1.object.text_message2.text = "구매할인권이 " + string(ld_give_point) + "원 있습니다 !"
else 
	dw_1.object.text_message2.text = ""
end if


dw_1.SetItem(1, "card_no",      RightA(ls_card_no, 9))
dw_1.SetItem(1, "user_name",    ls_user_name)
dw_1.SetItem(1, "jumin",        ls_jumin)
dw_1.Setitem(1, "total_point",  ll_total_point)
dw_1.Setitem(1, "give_point",   ll_give_point)
dw_1.Setitem(1, "accept_point", ll_accept_point)
dw_1.Setitem(1, "tel_no3", 	  ls_tel_no3)

/* 연령층 처리 */
IF MidA(ls_jumin,7,1) > '2' THEN	//2000년 이후 출생자.
	ll_year = Long(LeftA(is_yymmdd, 4)) - (Long(MidA(ls_jumin,1,2)) + 2000) + 1
ELSE
	ll_year = Long(LeftA(is_yymmdd, 4)) - (Long(MidA(ls_jumin,1,2)) + 1900) + 1
END IF 

IF lb_return = False OR isnull(as_find) THEN
	setnull(ls_age_grp)
ELSEIF ll_year < 10 THEN
	ls_age_grp = "50"		
ELSEIF ll_year < 20 THEN
	ls_age_grp = "10"
ELSEIF ll_year < 25 THEN
	ls_age_grp = "20"		
ELSEIF ll_year < 30 THEN
	ls_age_grp = "25"		
ELSEIF ll_year < 35 THEN
	ls_age_grp = "30"		
ELSEIF ll_year < 40 THEN
	ls_age_grp = "35"		
ELSEIF ll_year < 50 THEN
	ls_age_grp = "40"		
ELSE
	ls_age_grp = "50"		
END IF
dw_1.SetItem(1, "age_grp", ls_age_grp)


Return lb_return

end function

public function boolean wf_style_set (long al_row, string as_style);Long    ll_dc_rate     
Long    ll_curr_price,  ll_out_price
Long    ll_sale_price,  ll_collect_price 
String  ls_shop_type,   ls_sale_type = space(2)
decimal ldc_out_marjin, ldc_sale_marjin

/* 정상, 기획 */
ls_shop_type = dw_body.GetitemString(al_row, "shop_type")

/* 출고시 마진율 체크 */
IF gf_out_marjin (is_yymmdd,    gs_shop_cd,     ls_shop_type, as_style, & 
                  ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
	RETURN False 
END IF
/* 판매 마진율 체크 */
IF gf_sale_marjin (is_yymmdd,    gs_shop_cd,      ls_shop_type, as_style, & 
                   ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 
	RETURN False 
END IF

/* 판매 자료 등록 */
dw_body.Setitem(al_row, "sale_type",  ls_sale_type)
dw_body.Setitem(al_row, "sale_qty",   1)

dw_body.Setitem(al_row, "curr_price",    ll_curr_price)
dw_body.Setitem(al_row, "dc_rate",       ll_dc_rate)
dw_body.Setitem(al_row, "sale_price",    ll_sale_price)
dw_body.Setitem(al_row, "out_rate",      ldc_out_marjin)
dw_body.Setitem(al_row, "out_price",     ll_out_price)
dw_body.Setitem(al_row, "sale_rate",     ldc_sale_marjin)
dw_body.Setitem(al_row, "collect_price", ll_collect_price)

/* 금액 처리 */
wf_amt_set(al_row, 1)

RETURN True
end function

public function boolean uf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name);int li_cnt

	select jumin, user_name
		into :as_jumin, :as_user_name
	from tb_71010_m (nolock) 
	where tel_no3 = replace(:as_tel_no,'-','');
	

	select count(jumin)
		into :li_cnt
	from tb_71010_m (nolock) 
	where tel_no3 = replace(:as_tel_no,'-','');


	if li_cnt <> 1 or isnull(as_jumin) or LenA(as_jumin) <> 13 then 
		return False
	else 
		return True
	end if
	
end function

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_size, ls_shop_type, ls_given_fg, ls_given_ymd
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn , LS_RTRN_YMD 
Long   ll_tag_price, ll_ord_qty, ll_ord_qty_chn 

IF LenA(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)


if gs_brand = "M" then 
	Select brand,     year,     season,     
			 sojae,     item,     tag_price,     plan_yn   
	  into :ls_brand, :ls_year, :ls_season, 
			 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
	  from vi_12024_1 with (nolock)
	 where brand = :gs_brand 
		and style = :ls_style 
		and chno  = :ls_chno
		and color = :ls_color 
		and size  = :ls_size
		and (sojae  <> 'C' OR STYLE IN ('NC5AJ973', 'NC5AJ911','NC5AL911','NC5AJ910','NC5AS910', 'NC5MB628','NC5MB962','NC5MB964','NC5MJ965', 'NC5AJ913','NC5AL913','NC5AS913','NC5AJ915','NC5AL915','NC5AS915')  ) ;

//elseif gs_brand = "W" and is_yymmdd > '20050923'  then
//	Select brand,     year,     season,     
//			 sojae,     item,     tag_price,     plan_yn   
//	  into :ls_brand, :ls_year, :ls_season, 
//			 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
//	  from vi_12024_1 with (nolock)
//	 where brand = :gs_brand 
//		and style = :ls_style 
//		and chno  = :ls_chno
//		and color = :ls_color 
//		and size  = :ls_size
//		and sojae <> 'C'	
//      and year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  > '20052' 		;
////	   and (year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  > '20051' 
////	        or style in ('WW5SB906','WW5SD107','WX5SG514','WX5ST517',
////			               'WX5SU513','WX5SU515','WX5SU516','WX5SX510', 
////			               'WX5SX528','WX5SX529','WX5SX530'))

else	
		Select brand,     year,     season,     
			 sojae,     item,     tag_price,     plan_yn   
	  into :ls_brand, :ls_year, :ls_season, 
			 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
	  from vi_12024_1 with (nolock)
	 where brand = :gs_brand 
		and style = :ls_style 
		and chno  = :ls_chno
		and color = :ls_color 
		and size  = :ls_size
		and year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  > case when :is_yymmdd > '20050930' then  '20052' else '200501' end  //case when :gs_brand <> 'O' then '20044' else '200403' end
		and  (sojae  <> 'C' OR STYLE IN  ('NC5AJ973', 'NC5AJ911','NC5AL911','NC5AJ910','NC5AS910', 'NC5MB628','NC5MB962','NC5MB964','NC5MJ965', 'NC5AJ913','NC5AL913','NC5AS913','NC5AJ915','NC5AL915','NC5AS915')  );	

end if

IF SQLCA.SQLCODE <> 0 THEN 
	Return False 
END IF


Select isnull(out_qty,0), isnull(out_qty_chn,0)
  into :ll_ord_qty, :ll_ord_qty_chn  
  from tb_12030_s with (nolock)
 where brand = :gs_brand 
   and style = :ls_style 
	and chno  = :ls_chno
	and color = :ls_color 
	and size  = :ls_size;
if gs_brand <> 'M' then
	if ll_ord_qty - ll_ord_qty_chn <= 0  then 
		messagebox("경고!", "국내 판매등록이 불가능한 제품입니다!")
		return false
	end if	
end if	


Select shop_type
into :ls_shop_type
From tb_56012_d with (nolock)
Where style      = :ls_style 
  and start_ymd <= :is_yymmdd
  and end_ymd   >= :is_yymmdd
  and shop_cd    = :gs_shop_cd ;

if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
	ls_shop_type = "1"
end if	

if ls_shop_type > "3"  then 
	messagebox("경고!", "정상 판매등록이 불가능한 제품입니다!")
	return false
end if	

SELECT  ISNULL(RTRN_YMD, 'XXXXXXXX')
INTO :LS_RTRN_YMD
FROM tb_54020_h
WHERE STYLE = :LS_STYLE
AND   DEP_FG = 'Y';

if IsNull(LS_RTRN_YMD) or Trim(LS_RTRN_YMD) = "" then
	LS_RTRN_YMD = "XXXXXXXX"
end if


if ls_shop_type < "3"  then 
	IF LS_RTRN_YMD <= IS_YYMMDD THEN 
		messagebox("경고!", "부진적용일이후 정상 판매,반품등록은 불가능합니다! 관리팀에 연락 바랍니다!")
		return false
	END IF	
end if	


select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
into  :ls_given_fg, :ls_given_ymd
from tb_12020_m with (nolock)
where style = :ls_style;


if ls_given_fg = "Y" then 
	messagebox("품번체크", ls_given_ymd + "일자로 사은품 전환된 제품입니다!")
	return false
end if 	




dw_body.SetItem(al_row, "tag_price", ll_tag_price) 
IF ls_plan_yn = 'Y' THEN 
	dw_body.Setitem(al_row, "shop_type", '3')
ELSE
	dw_body.Setitem(al_row, "shop_type", '1')
END IF
IF wf_style_set(al_row, ls_style) THEN 
   dw_body.SetItem(al_row, "style_no", as_style_no)
   dw_body.SetItem(al_row, "style",    ls_style)
	dw_body.SetItem(al_row, "chno",     ls_chno)
	dw_body.SetItem(al_row, "color",    ls_color)
	dw_body.SetItem(al_row, "size",     ls_size)
	dw_body.SetItem(al_row, "brand",    ls_brand)
	dw_body.SetItem(al_row, "year",     ls_year)
	dw_body.SetItem(al_row, "season",   ls_season)
	dw_body.SetItem(al_row, "sojae",    ls_sojae)
	dw_body.SetItem(al_row, "item",     ls_item)
ELSE
	Return False
END IF

Return True

end function

on w_sh101_20051109.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.dw_list=create dw_list
this.st_1=create st_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.dw_2
this.Control[iCurrent+6]=this.dw_3
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_sh101_20051109.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.dw_list)
destroy(this.st_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.st_2)
destroy(this.gb_1)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(cb_1, "FixedToRight")
inv_resize.of_Register(st_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_1, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_2, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_3, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(gb_1, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight&Bottom")


dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

dw_1.insertRow(0)



end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size, ls_shop_type, ls_given_fg, ls_given_ymd, LS_RTRN_YMD
Long       ll_row_cnt , ll_ord_qty, ll_ord_qty_chn
Boolean    lb_check 
DataStore  lds_Source 

CHOOSE CASE as_column
	CASE "style_no"		
			IF ai_div = 1 THEN 	
				IF wf_style_chk(al_row, as_data)  THEN
				   ll_row_cnt = dw_body.RowCount()
				   IF al_row = ll_row_cnt THEN 
					   ll_row_cnt = dw_body.insertRow(0)
				   END IF
				   This.Post Event ue_tot_set()
					RETURN 0 
				END IF 
			END IF
		   ls_style = MidA(as_data, 1, 8)
		   ls_chno  = MidA(as_data, 9, 1)
		   ls_color = MidA(as_data, 10, 2)
		   ls_size  = MidA(as_data, 12, 2)
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com012" 
//			if gs_shop_div = "G" then
// 				gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20032' "
//			else	 
// 				gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20042' and sojae <> 'C' "				

			if gs_brand = "M" then
		   gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (sojae  <> 'C' OR STYLE IN  ('NC5AJ973', 'NC5AJ911','NC5AL911','NC5AJ910','NC5AS910', 'NC5MB628','NC5MB962','NC5MB964','NC5MJ965', 'NC5AJ913','NC5AL913','NC5AS913','NC5AJ915','NC5AL915','NC5AS915')  ) " 				
//		   elseif  gs_brand = "W" then
// 			gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON))) > '20052' and sojae <> 'C' " //or style in ('WW5SB906','WW5SD107','WX5SG514','WX5ST517','WX5SU513','WX5SU515','WX5SU516','WX5SX510', 'WX5SX528','WX5SX529','WX5SX530'))  " 				
		   else 
				if is_yymmdd > '20050930' then
		 			gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON))) > '20052'  and (sojae  <> 'C' OR STYLE IN  ('NC5AJ973', 'NC5AJ911','NC5AL911','NC5AJ910','NC5AS910', 'NC5MB628','NC5MB962','NC5MB964','NC5MJ965', 'NC5AJ913','NC5AL913','NC5AS913','NC5AJ915','NC5AL915','NC5AS915')   )  " 				
				else	 
	 				gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON))) > '20051'  and (sojae  <> 'C' OR STYLE IN  ('NC5AJ973', 'NC5AJ911','NC5AL911','NC5AJ910','NC5AS910', 'NC5MB628','NC5MB962','NC5MB964','NC5MJ965', 'NC5AJ913','NC5AL913','NC5AS913','NC5AJ915','NC5AL915','NC5AS915')   )  " 									 
				end if	 
		   end if

				 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" + &
				                " and chno  LIKE '" + ls_chno + "%'" + &
				                " and color LIKE '" + ls_color + "%'" + &
				                " and size  LIKE '" + ls_size + "%'" 
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
				IF lds_Source.GetItemString(1,"plan_yn") = 'Y' THEN 
					dw_body.Setitem(al_row, "shop_type", '3')
				ELSE
					dw_body.Setitem(al_row, "shop_type", '1')
				END IF
				ls_style = lds_Source.GetItemString(1,"style")
				
				
				Select shop_type
				into :ls_shop_type
				From tb_56012_d with (nolock)
				Where style      = :ls_style 
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and shop_cd    = :gs_shop_cd ;

			
				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
					ls_shop_type = "1"
				end if	
				
				if ls_shop_type > "3" then 
					messagebox("경고!", "정상 판매등록이 불가능한 제품입니다!")
					ib_itemchanged = FALSE
					return 1					
				end if					
								
				SELECT  ISNULL(RTRN_YMD, 'XXXXXXXX')
				INTO :LS_RTRN_YMD
				FROM tb_54020_h
				WHERE STYLE = :LS_STYLE
				AND   DEP_FG = 'Y';
				

				if IsNull(LS_RTRN_YMD) or Trim(LS_RTRN_YMD) = "" then
				   LS_RTRN_YMD = "XXXXXXXX"
				end if
				
				if ls_shop_type < "3"  then 
					IF LS_RTRN_YMD <= IS_YYMMDD THEN 
						messagebox("경고!", "부진적용일이후 정상 판매,반품등록은 불가능합니다! 관리팀에 연락 바랍니다!")
						ib_itemchanged = FALSE						
						return 1
					END IF	
				end if					
			
				select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
				into :ls_given_fg, :ls_given_ymd
				from beaucre.dbo.tb_12020_m with (nolock)
				where style like :ls_style + '%';
				
				IF ls_given_fg = "Y"  THEN 
					messagebox("품번검색", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				END IF 		

				ls_style = lds_Source.GetItemString(1,"style")
				ls_chno  = lds_Source.GetItemString(1,"chno")
				ls_color = lds_Source.GetItemString(1,"color")
				ls_size = lds_Source.GetItemString(1,"size")	
		
				Select isnull(out_qty,0), isnull(out_qty_chn,0)
				  into :ll_ord_qty, :ll_ord_qty_chn  
				  from tb_12030_s with (nolock)
				 where brand = :gs_brand 
					and style = :ls_style 
					and chno  = :ls_chno
					and color = :ls_color 
					and size  = :ls_size;
				if gs_brand <> 'M' then
					if ll_ord_qty - ll_ord_qty_chn <= 0  then 
						messagebox("경고!",  "국내에 출고 되지 않는 제품입니다!")
						dw_body.SetItem(al_row, "style_no", "")
						ib_itemchanged = FALSE
						return 1 	
					end if	
				end if	
		
 				IF wf_style_set(al_row, ls_style) THEN 
				   dw_body.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
				   dw_body.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				   dw_body.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "color", lds_Source.GetItemString(1,"color"))
				   dw_body.SetItem(al_row, "size", lds_Source.GetItemString(1,"size"))
				   dw_body.SetItem(al_row, "brand", lds_Source.GetItemString(1,"brand"))
				   dw_body.SetItem(al_row, "year", lds_Source.GetItemString(1,"year"))
				   dw_body.SetItem(al_row, "season", lds_Source.GetItemString(1,"season"))
				   dw_body.SetItem(al_row, "sojae", lds_Source.GetItemString(1,"sojae"))
				   dw_body.SetItem(al_row, "item", lds_Source.GetItemString(1,"item"))
				   ib_changed = true
               cb_update.enabled = true
				   /* 다음컬럼으로 이동 */
				   ll_row_cnt = dw_body.RowCount()
				   IF al_row = ll_row_cnt THEN 
					   ll_row_cnt = dw_body.insertRow(0)
				   END IF
				   dw_body.SetRow(ll_row_cnt)  
				   dw_body.SetColumn("style_no")
				   This.Post Event ue_tot_set()
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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string ls_title 

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

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

is_yymmdd  = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")
is_sale_no = dw_head.GetitemString(1, "sale_no")

Return true 
 
end event

event pfc_postopen();call super::pfc_postopen;cb_1.TriggerEvent(Clicked!)
This.Post Event ue_total_retrieve() 

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = false
         dw_1.Enabled = true
         dw_body.SetFocus()
      end if
      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			if dw_head.Enabled then
				dw_body.Enabled = true
			end if
		end if
	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
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
		end if
   CASE 5    /* 조건 */
      cb_delete.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.SetFocus()
      dw_head.SetColumn(1)
   CASE 6		/* 입력 */
      if al_rows > 0 then
         cb_delete.enabled = True
         dw_1.Enabled = true
         dw_body.SetFocus()
      end if
      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
END CHOOSE

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
long	ll_cur_row

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	
IF idw_status <> NewModified!	THEN 
   dw_body.SetFocus()
	RETURN 
END IF 

il_rows = dw_body.DeleteRow (ll_cur_row)
dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
String   ls_style_no,   ls_sale_fg,   ls_card_no  , ls_coupon_no , ls_jumin, ls_item, ls_card_no_origin
long     ll_sale_price, ll_goods_amt, ll_sale_qty , ll_coupon_amt, ll_accept_point
long     i, ll_row_count, ll_chk
decimal	ldc_dc_rate, ld_goods_amt
datetime ld_datetime 
int     li_point_seq	
String   ls_shop_type, ls_sale_type

IF dw_body.AcceptText() <> 1 THEN RETURN -1
dw_1.setfocus()
dw_1.setcolumn("goods_amt")

IF dw_1.AcceptText()    <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

//IF NOT isnull(dw_1.Object.card_no[1]) AND isnull(dw_1.Object.jumin[1]) THEN
//	MessageBox("경고", "회원정보를 다시 확인하고 등록하십시오 !") 
//	Return 0 
//END IF
//IF NOT isnull(dw_1.Object.tel_no3[1]) AND isnull(dw_1.Object.jumin[1]) THEN
//	MessageBox("경고", "회원정보를 다시 확인하고 등록하십시오 !") 
//	Return 0 
//END IF
//
//IF NOT isnull(dw_1.Object.jumin[1]) AND isnull(dw_1.Object.card_no[1]) THEN
//	MessageBox("경고", "회원정보를 다시 확인하고 등록하십시오 !") 
//	Return 0 
//END IF
//
//IF NOT isnull(dw_1.Object.JUMIN[1]) AND isnull(dw_1.Object.age_grp[1]) THEN
//	MessageBox("경고", "연령층 이나 회원정보를 등록하십시오 !") 
//	Return 0 
//END IF

   IF NOT isnull(dw_1.Object.jumin[1]) THEN	    
		IF WF_MEMBER_SET('1', dw_1.Object.jumin[1]) = FALSE THEN					
			MessageBox("오류", "미등록된 카드회원 입니다")
			Return 0 
		ELSE
			dw_1.Setitem(1, "goods_amt", 0)
			dw_1.SetColumn("goods_amt")
		END IF 		
   ELSEIF NOT isnull(dw_1.Object.card_no[1])  then
		IF WF_MEMBER_SET('2', dw_1.Object.card_no[1]) = FALSE THEN
			MessageBox("오류", "미등록된 회원 입니다")
			Return 0 
		ELSE
			dw_1.Setitem(1, "goods_amt", 0)
			dw_1.SetColumn("goods_amt")
		END IF		
	ELSEIF NOT isnull(dw_1.Object.tel_no3[1]) then
		SetPointer(HourGlass!)
		IF WF_MEMBER_SET('3', dw_1.Object.tel_no3[1]) = FALSE THEN
			MessageBox("오류", "미등록된 카드회원 입니다")	
			Return 0 
		ELSE
			dw_1.Setitem(1, "goods_amt", 0)
			dw_1.SetColumn("goods_amt")
		END IF 
	END IF
	
IF isnull(dw_1.Object.age_grp[1]) THEN
	MessageBox("경고", "연령층 이나 회원정보를 등록하십시오 !") 
	Return 0 
END IF

ll_row_count = dw_body.RowCount()
FOR i = ll_row_count to 1 step -1 
	ls_style_no = dw_body.GetitemString(i, "style_no")
	IF isnull(ls_style_no) THEN
		dw_body.DeleteRow(i) 
	END IF
NEXT 
ll_row_count = dw_body.RowCount()

IF ll_row_count > 0 AND dw_body.GetItemStatus(1, 0, Primary!) <> NewModified! THEN 
	is_sale_no = dw_body.GetitemString(1, "sale_no")
ELSEIF gf_Get_Saleno(is_yymmdd, gs_shop_cd, '1', is_sale_no) <> 0 THEN 
	Return -1 
END IF



/* point 판매 처리 및 가능여부 체크 (정상판매단가가  Point금액 이상 매출만 가능)*/
ll_goods_amt = dw_1.GetitemNumber(1, "goods_amt")  // point금액 

IF isnull(ll_goods_amt) THEN ll_goods_amt = 0 
	ls_card_no   = dw_1.GetitemString(1, "card_no")
IF isnull(ls_card_no) = FALSE AND LenA(ls_card_no) = 9 THEN
	ls_card_no = '4870090' + ls_card_no 
ELSE
	Setnull(ls_card_no)
END IF


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN			/* New Record */  
      dw_body.Setitem(i, "no",  String(i, "0000"))
      dw_body.Setitem(i, "yymmdd", is_yymmdd)
      dw_body.Setitem(i, "shop_cd",  gs_shop_cd)
      dw_body.Setitem(i, "shop_div", gs_shop_div)
      dw_body.Setitem(i, "sale_no",  is_sale_no)
      dw_body.Setitem(i, "reg_id",   gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */	
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF 
	
	ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))
	ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
	ls_style_no  = dw_body.Getitemstring(i, "style_no")
   ls_item      = RightA(LeftA(ls_style_no,2),1)
	
	ll_goods_amt = dw_body.GetitemNumber(i, "goods_amt")  // point금액 
	
	
	if is_yymmdd > '20050331' then
			IF ll_goods_amt > 0 and ll_sale_price > ll_goods_amt and  & 
				ll_sale_qty  > 0 and LeftA(dw_body.Object.sale_type[i], 2) = '11' THEN  
				ls_sale_fg = '2' 
			ELSEIF LenA(Trim(dw_1.Object.jumin[1])) = 13 and LeftA(dw_body.Object.sale_type[i], 1) < '2' THEN  // 정상 적용 
				ls_sale_fg = '1' 
			ELSE
				ls_sale_fg = '0' 
			END IF		
	else			
			IF ll_goods_amt > 0 and ll_sale_price > ll_goods_amt and  & 
				ll_sale_qty  > 0 and LeftA(dw_body.Object.sale_type[i], 2) = '11'  and &
				ls_item  <> 'X' THEN  
				ls_sale_fg = '2' 
			ELSEIF LenA(Trim(dw_1.Object.jumin[1])) = 13 and LeftA(dw_body.Object.sale_type[i], 1) < '2' THEN  // 정상 적용 
				ls_sale_fg = '1' 
			ELSE
				ls_sale_fg = '0' 
			END IF		
	end if			
	
	
   wf_amt_set(i, ll_sale_qty)
	
	
	
   IF idw_status <> New! THEN 
      dw_body.Setitem(i, "age_grp", dw_1.Object.age_grp[1])  
      dw_body.Setitem(i, "sale_fg", ls_sale_fg)
      dw_body.Setitem(i, "jumin",   Trim(dw_1.Object.jumin[1]))  
      dw_body.Setitem(i, "card_no", ls_card_no)  
	END IF
	
	ls_jumin     = Trim(dw_1.Object.jumin[1])
	ls_shop_type = dw_body.getitemstring(i, "shop_type")
	ls_sale_type = dw_body.getitemstring(i, "sale_type")	
	ldc_dc_rate  = dw_body.getitemnumber(i, "dc_rate")	

	wf_line_chk(i)
NEXT

//// 포인트 사용 최종점검 
//ld_goods_amt = dw_1.getitemdecimal(1,"goods_amt")
//
//IF not wf_goods_chk(long(ld_goods_amt))  THEN 
//	dw_1.Reset()
//	dw_1.InsertRow(1)
//	Post Event ue_tot_set()
//END IF
//
//
il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	This.Post Event ue_total_retrieve()
	cb_1.SetFocus()
else
   rollback  USING SQLCA;
end if


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
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

il_rows = dw_list.Retrieve(is_yymmdd, gs_shop_cd) 
This.Post Event ue_total_retrieve()

dw_body.Visible = False
dw_1.Visible = False
dw_list.Visible = True

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;

//IF GS_BRAND <> 'W' THEN
//	ST_2.TEXT = "※ 2005년 봄(S) 이전 제품은 관리팀에 문의 바랍니다! "
//ELSE	
	ST_2.TEXT = "※ 2005년 여름(M) 이전 제품은 관리팀에 문의 바랍니다! "
//END IF		
end event

type cb_close from w_com010_e`cb_close within w_sh101_20051109
boolean visible = false
integer x = 389
end type

type cb_delete from w_com010_e`cb_delete within w_sh101_20051109
integer taborder = 70
end type

type cb_insert from w_com010_e`cb_insert within w_sh101_20051109
boolean visible = false
integer taborder = 60
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh101_20051109
integer x = 2469
integer width = 384
integer taborder = 110
string text = "일보조회(&Q)"
end type

type cb_update from w_com010_e`cb_update within w_sh101_20051109
integer taborder = 50
end type

type cb_print from w_com010_e`cb_print within w_sh101_20051109
boolean visible = false
integer taborder = 80
end type

type cb_preview from w_com010_e`cb_preview within w_sh101_20051109
boolean visible = false
integer x = 1193
integer y = 48
integer taborder = 90
end type

type gb_button from w_com010_e`gb_button within w_sh101_20051109
end type

type dw_head from w_com010_e`dw_head within w_sh101_20051109
integer y = 152
integer height = 96
string dataobject = "d_sh101_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_yymmdd

CHOOSE CASE dwo.name
	CASE "yymmdd"
		ls_yymmdd = String(Date(data), "yyyymmdd")
      IF GF_IWOLDATE_CHK(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN
			MessageBox("일자변경", "소급할수 없는 일자입니다.")
			Return 1
		END IF
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_sh101_20051109
integer beginy = 256
integer endy = 256
end type

type ln_2 from w_com010_e`ln_2 within w_sh101_20051109
integer beginy = 260
integer endy = 260
end type

type dw_body from w_com010_e`dw_body within w_sh101_20051109
event ue_set_column ( long al_row )
integer x = 9
integer y = 260
integer width = 2880
integer height = 644
string dataobject = "d_sh101_d01"
boolean hscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_body::ue_set_column(long al_row);/* 품번 키보드 및 스캐너 입력시 다음 line으로 이동 */

dw_body.SetRow(al_row + 1)  
dw_body.SetColumn("style_no")

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.02.16                                                  */	
/* 수정일      : 2002.02.16                                                  */
/*===========================================================================*/
integer li_ret
decimal ld_goods_amt
CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		li_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		IF li_ret <> 1 THEN
			This.Post Event ue_set_column(row) 
		END IF
		return li_ret
	CASE "sale_qty"	  
		IF isnull(data) or Long(data) = 0 THEN RETURN 1
			
			ld_goods_amt = dw_body.getitemdecimal(row,"goods_amt")
			
			IF Long(data) < 0	then				
				this.Setitem(row,"goods_amt",0)
				dw_1.Setitem(1,"goods_amt",0)
				Parent.Post Event ue_tot_set()		 
			END IF
		wf_amt_set(row, Long(data))
		
		Parent.Post Event ue_tot_set()
END CHOOSE

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.of_SetSort(False)

This.GetChild("color", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')


end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)                                           */	
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

event dw_body::getfocus;call super::getfocus;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)


end event

event dw_body::doubleclicked;call super::doubleclicked;String ls_style_no, ls_yes 
Long   ll_curr_price, ll_sale_price, ll_collect_price, ld_goods_amt

IF row < 1 THEN RETURN 
ls_style_no = This.GetitemString(row, "style_no")

IF isnull(ls_style_no) or Trim(ls_style_no) = "" THEN RETURN

gsv_cd.gs_cd1 = This.GetitemString(row, "shop_type")
gsv_cd.gs_cd2 = is_yymmdd

OpenWithParm (W_SH101_P, "W_SH101_P 판매형태 내역") 
ls_yes = Message.StringParm 
IF ls_yes = 'YES' THEN 
	ll_curr_price = This.GetitemNumber(row, "curr_price")
	ld_goods_amt  = This.GetitemNumber(row, "goods_amt")
	ll_sale_price    = ll_curr_price * (100 - gsv_cd.gl_cd1) / 100 
	gf_marjin_price(gs_shop_cd, ll_sale_price, gsv_cd.gdc_cd1, ll_collect_price) 
	This.Setitem(row, "sale_type",     gsv_cd.gs_cd3) 
	This.Setitem(row, "dc_rate",       gsv_cd.gl_cd1) 
	This.Setitem(row, "sale_rate",     gdc_sale_rate )// gsv_cd.gdc_cd1) 
	This.Setitem(row, "sale_price",    ll_sale_price)
	This.Setitem(row, "collect_price", ll_collect_price)
	wf_goods_chk(long(ld_goods_amt))
	wf_amt_set(row, This.Object.sale_qty[row]) 
   ib_changed = true
   cb_update.enabled = true
	Parent.Trigger Event ue_tot_set()
END IF 


end event

type dw_print from w_com010_e`dw_print within w_sh101_20051109
end type

type dw_1 from datawindow within w_sh101_20051109
event ue_keydown pbm_dwnkey
event type long ue_item_changed ( long row,  dwobject dwo,  string data )
integer x = 9
integer y = 900
integer width = 2880
integer height = 444
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh101_d02"
boolean maxbox = true
boolean border = false
boolean livescroll = true
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)                                           */	
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

event type long ue_item_changed(long row, dwobject dwo, string data);string  ls_coupon_no
decimal ld_goods_amt, ll_sale_qty, ll_sale_amt
long    i, ll_row_count

CHOOSE CASE dwo.name
	CASE "card_no" 
		IF WF_MEMBER_SET('2', data) = FALSE THEN
			MessageBox("오류", "미등록된 회원 입니다")
			RETURN 1
		ELSE
			This.Setitem(1, "goods_amt", 0)
			This.SetColumn("goods_amt")
		END IF
   CASE "jumin"	    
		IF WF_MEMBER_SET('1', data) = FALSE THEN					
			MessageBox("오류", "미등록된 카드회원 입니다")
			RETURN 1 
		ELSE
			This.Setitem(1, "goods_amt", 0)
			This.SetColumn("goods_amt")
		END IF 
	 CASE "tel_no3"	 
		SetPointer(HourGlass!)
		IF WF_MEMBER_SET('3', data) = FALSE THEN
			MessageBox("오류", "미등록된 카드회원 입니다")		
			RETURN 1 
		ELSE
			This.Setitem(1, "goods_amt", 0)
			This.SetColumn("goods_amt")
		END IF 
		
	CASE "goods_amt" 
			ld_goods_amt = dw_1.getitemdecimal(1,"goods_amt")
			IF not wf_goods_chk(long(ld_goods_amt))  THEN 		
				this.Setitem(1,"goods_amt",0)
				Parent.Post Event ue_tot_set()
				RETURN 1
			END IF

	
END CHOOSE 
end event

event constructor;DataWindowChild ldw_child

This.GetChild("age_grp", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("403")


end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
String ls_jumin

IF dwo.name = "b_member" THEN 
	OpenWithParm (W_SH101_S, "W_SH101_S 신규회원접수") 
   ls_jumin = Message.StringParm 
	IF isnull(ls_jumin) = False and LenA(Trim(ls_jumin)) = 13 THEN
		wf_member_set('1', ls_jumin) 
		IF dw_body.RowCount() > 0 THEN 
	      IF dw_body.GetitemStatus(1, 0, Primary!) <> New! THEN 
            ib_changed = true
            cb_update.enabled = true
	      END IF
      END IF
	END IF
END IF

//IF dwo.name = "b_coupon" THEN 
//
//	gs_jumin = dw_1.GetitemString(1, "jumin")
//	MessageBox("주민번호",gs_jumin)
//	IF isnull(gs_jumin) or gs_jumin = "" Then
//		gs_jumin = "%"
//	END IF
//	
//	gs_coupon_no = dw_1.GetitemString(1, "coupon_no")
//	MessageBox("쿠폰번호",gs_coupon_no)
//	IF isnull(gs_coupon_no) or gs_coupon_no = "" Then
//		gs_coupon_no = "%"
//	END IF
//
//	OpenWithParm (W_SH101_P2, "W_SH101_P2 쿠폰발행내역") 
//	This.Setitem(row, "coupon_no",     gsv_cd.gs_cd1) 
//	This.Setitem(row, "jumin",     gsv_cd.gs_cd2) 
//	This.Setitem(row, "goods_amt",     gsv_cd.gl_cd1) 
//END IF	

end event

event itemerror;Return 1
end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

//post event ue_item_changed(row, dwo, data)
end event

event itemchanged;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
String ls_null , ls_coupon_no
Long   ll_give_point, ll_accept_point
decimal ld_goods_amt

IF dw_body.RowCount() > 0 THEN 
	IF dw_body.GetitemStatus(1, 0, Primary!) <> New! THEN 
      ib_changed = true
      cb_update.enabled = true
	END IF
END IF

post event ue_item_changed(row, dwo, data)

end event

event getfocus;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)


end event

event editchanged;//String ls_null , ls_coupon_no
//Long   ll_give_point, ll_accept_point
//decimal ld_goods_amt
//
//IF dw_body.RowCount() > 0 THEN 
//	IF dw_body.GetitemStatus(1, 0, Primary!) <> New! THEN 
//      ib_changed = true
//      cb_update.enabled = true
//	END IF
//END IF

//post event ue_item_changed(row, dwo, data)

end event

type cb_1 from commandbutton within w_sh101_20051109
event ue_keydown pbm_keydown
integer x = 2085
integer y = 44
integer width = 384
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "판매입력(&P)"
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
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
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

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

IF dw_body.Visible = FALSE THEN 
	dw_body.Visible = True
	dw_1.Visible = True
	dw_list.Visible = False
END IF

dw_body.Reset()
il_rows = dw_body.insertRow(0)

dw_1.Reset()
dw_1.insertRow(0)

Parent.Trigger Event ue_button(6, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_list from datawindow within w_sh101_20051109
event ue_syscommand pbm_syscommand
integer y = 264
integer width = 2889
integer height = 1092
integer taborder = 110
boolean titlebar = true
string title = "판매일보조회"
string dataobject = "d_sh101_d10"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
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

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')


end event

event doubleclicked;String ls_sale_no, ls_jumin, ls_coupon_no

IF row < 1 THEN RETURN

ls_sale_no = This.GetitemString(row, "sale_no")
ls_jumin   = This.GetitemString(row, "jumin")
ls_coupon_no = This.GetitemString(row, "coupon_no")
dw_body.Retrieve(is_yymmdd, gs_shop_cd, ls_sale_no) 
Parent.Post Event ue_tot_set()
dw_1.Setitem(1, "goods_amt", Long(dw_body.Describe("evaluate('sum(goods_amt)',0)")))

IF isnull(ls_jumin) = FALSE AND Trim(ls_jumin) <> "" THEN
   wf_member_set('1', ls_jumin)
	dw_1.Setitem(1, "coupon_no", ls_coupon_no)
ELSE
   Setnull(ls_jumin)
   dw_1.SetItem(1, "card_no",      ls_jumin)
   dw_1.SetItem(1, "user_name",    ls_jumin)
   dw_1.SetItem(1, "jumin",        ls_jumin)
   dw_1.Setitem(1, "total_point",  0)
   dw_1.Setitem(1, "give_point",   0)
   dw_1.Setitem(1, "accept_point", 0)
	dw_1.Setitem(1, "age_grp", This.GetitemString(row, "age_grp"))
	
END IF

dw_body.visible = TRUE 
dw_1.visible    = TRUE 
dw_list.visible = FALSE

end event

type st_1 from statictext within w_sh101_20051109
integer y = 264
integer width = 2894
integer height = 1088
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_2 from datawindow within w_sh101_20051109
boolean visible = false
integer x = 23
integer y = 1400
integer width = 2853
integer height = 392
string title = "none"
string dataobject = "d_sh101_d03"
boolean border = false
boolean livescroll = true
end type

event doubleclicked;dw_2.visible = false
dw_3.visible = true
end event

type dw_3 from datawindow within w_sh101_20051109
integer x = 23
integer y = 1400
integer width = 2853
integer height = 80
integer taborder = 50
string title = "none"
string dataobject = "d_sh101_d03"
boolean border = false
boolean livescroll = true
end type

event doubleclicked;dw_2.visible = true
dw_3.visible = false
end event

type st_2 from statictext within w_sh101_20051109
integer x = 1230
integer y = 176
integer width = 1664
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 2005년 봄(S) 이전 제품은 관리팀에 문의 바랍니다!"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_sh101_20051109
integer x = 14
integer y = 1356
integer width = 2875
integer height = 448
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "매출계(년월계는 기획제외) - 항목이름이나 숫자를 더블클릭하세요!"
borderstyle borderstyle = styleraised!
end type

