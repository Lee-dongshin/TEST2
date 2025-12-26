$PBExportHeader$w_sh144_e.srw
$PBExportComments$복합매장_행사판매등록
forward
global type w_sh144_e from w_com010_e
end type
type cb_1 from commandbutton within w_sh144_e
end type
type dw_list from datawindow within w_sh144_e
end type
type st_1 from statictext within w_sh144_e
end type
type dw_1 from datawindow within w_sh144_e
end type
type gb_1 from groupbox within w_sh144_e
end type
type dw_3 from datawindow within w_sh144_e
end type
type dw_2 from datawindow within w_sh144_e
end type
type st_2 from statictext within w_sh144_e
end type
type dw_4 from datawindow within w_sh144_e
end type
end forward

global type w_sh144_e from w_com010_e
integer width = 2994
integer height = 2056
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
event ue_tot_set ( )
event ue_total_retrieve ( )
cb_1 cb_1
dw_list dw_list
st_1 st_1
dw_1 dw_1
gb_1 gb_1
dw_3 dw_3
dw_2 dw_2
st_2 st_2
dw_4 dw_4
end type
global w_sh144_e w_sh144_e

type variables
String is_yymmdd, is_sale_no, is_fr_year, is_fr_season, is_mj_bit = 'N'
decimal idc_dc_rate_org

end variables

forward prototypes
public function boolean wf_member_set (string as_flag, string as_find)
public function boolean wf_empnm (string as_data, ref string as_empno, ref string as_empnm)
public subroutine wf_goods_amt_clear ()
public function boolean wf_goods_chk (long al_goods_amt)
public subroutine wf_amt_set (long al_row, long al_sale_qty)
public subroutine wf_amt_reset (long al_row)
public function boolean wf_style_set (long al_row, string as_style, string as_yymmdd, long al_qty)
public function boolean wf_style_chk (long al_row, string as_style_no)
public function boolean wf_style_set_back (long al_row, string as_style)
end prototypes

event ue_tot_set();Long ll_sale_qty, ll_sale_amt

ll_sale_qty = Long(dw_body.Describe("evaluate('sum(sale_qty)',0)"))
ll_sale_amt = Long(dw_body.Describe("evaluate('sum(sale_amt)',0)"))
//
//dw_1.Setitem(1, "sale_qty", ll_sale_qty)
//dw_1.Setitem(1, "sale_amt", ll_sale_amt)

Return

end event

event ue_total_retrieve();Long ll_row 

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

ll_row = dw_2.Retrieve(is_yymmdd, gs_shop_cd)
dw_2.ShareData(dw_3)
IF ll_row < 1 THEN
	dw_2.insertRow(0) 
END IF 
end event

public function boolean wf_member_set (string as_flag, string as_find);String  ls_user_name,   ls_jumin,      ls_card_no,      ls_age_grp
Long    ll_total_point, ll_give_point, ll_accept_point, ll_year 
Boolean lb_return 

IF as_flag = '1' THEN
	SELECT user_name,       jumin,          card_no,
			 total_point,     give_point,     accept_point 
	  INTO :ls_user_name,   :ls_jumin,      :ls_card_no,  
			 :ll_total_point, :ll_give_point, :ll_accept_point 
	  FROM TB_72010_M  with (nolock)  
	 WHERE jumin   = :as_find ; 
ELSE
	SELECT user_name,       jumin,          card_no,
			 total_point,     give_point,     accept_point 
	  INTO :ls_user_name,   :ls_jumin,      :ls_card_no,  
			 :ll_total_point, :ll_give_point, :ll_accept_point 
	  FROM TB_72010_M  with (nolock)   
	 WHERE card_no = '1128003' + :as_find ; 
END IF

IF SQLCA.SQLCODE <> 0 AND isnull(as_find) = false THEN 
	lb_return = False  
ELSEIF isnull(ls_card_no) OR Trim(ls_card_no) = "" THEN
	SetNull(ls_jumin)
	lb_return = False
	return lb_return
ELSE	
	lb_return = True 
END IF

dw_1.SetItem(1, "card_no",      RightA(ls_card_no, 9))
dw_1.SetItem(1, "user_name",    ls_user_name)
dw_1.SetItem(1, "jumin",        ls_jumin)
dw_1.Setitem(1, "total_point",  ll_total_point)
dw_1.Setitem(1, "accept_point", ll_accept_point)
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

public function boolean wf_empnm (string as_data, ref string as_empno, ref string as_empnm);string ls_empno, ls_empnm
integer li_cnt

    SELECT top 1 Kname, empno
	  into :As_empnm, :as_empno
      FROM VI_93000_1 (nolock)
     WHERE ( EmpNo = :as_data or Kname like :as_data + '%')
	  and   goout_gubn = '1'	;
	  
   SELECT count(kname)
	   into :li_cnt
      FROM VI_93000_1 (nolock)
     WHERE ( EmpNo = :as_data or Kname like :as_data + '%')	  
	  and   goout_gubn = '1'	;
	  
if li_cnt <> 1 or isnull(As_empnm) or isnull(As_empno) then 
		return False
	else 
		return True
	end if	  
	  
	  
	  
end function

public subroutine wf_goods_amt_clear ();long i , ll_row_count

ll_row_count = dw_body.rowcount()

FOR i=1 TO ll_row_count
	dw_body.Setitem(i, "goods_amt", 0)
NEXT


end subroutine

public function boolean wf_goods_chk (long al_goods_amt);Long 	  i, ll_accept_point, ll_remain_point, ll_total_point , ll_row_count,ll_goods_amt,ll_sale_price, ll_sale_qty   
decimal ld_goods_amt, ld_mok, ld_qty
string  ls_card_no, ls_sale_fg, ls_style_no, ls_item




ld_goods_amt    = dw_1.Getitemdecimal(1, "goods_amt")      // 사용할 금액
ll_total_point  = dw_1.getitemdecimal( 1, "total_point")   // 총 포인트 
ll_remain_point = dw_1.getitemdecimal( 1, "remain_point")  // 남은 포인트 
ll_accept_point = ld_goods_amt / 10                        // 사용할 포인트


ll_row_count = dw_body.RowCount()

IF isnull(al_goods_amt) OR al_goods_amt = 0 THEN 
	 wf_goods_amt_clear()
	RETURN TRUE 
END IF

IF ll_remain_point < 3000 		then 
	MessageBox("Point 오류", "남은 포인트가 3000점 이상 일때만 사용가능 합니다.")
   wf_goods_amt_clear()
	return false               
END IF

ll_goods_amt = dw_1.GetitemNumber(1, "goods_amt")  // point금액 
ld_mok = MOD(ld_goods_amt , 30000) 

if ld_mok <> 0 then
	MessageBox("Point 오류", "1PCS에 30000원 단위로 입력하세요. ")
	wf_goods_amt_clear()
	return false    
end if


/* point 판매 처리 및 가능여부 체크 (정상판매단가가  Point금액 이상 매출만 가능)*/
ll_goods_amt = dw_1.GetitemNumber(1, "goods_amt")  // point금액 

IF isnull(ll_goods_amt) THEN ll_goods_amt = 0 

ls_card_no   = dw_1.GetitemString(1, "card_no")

IF isnull(ls_card_no) = FALSE AND LenA(ls_card_no) = 9 THEN
	ls_card_no = '1128003' + ls_card_no 
ELSE
	Setnull(ls_card_no)
END IF

FOR i=1 TO ll_row_count
  	ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))
	ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
	ls_style_no   = dw_body.Getitemstring(i, "style_no")
   ls_item       = RightA(LeftA(ls_style_no,2),1)
	
	IF ll_goods_amt > 0 and ll_sale_price > 30000 and  & 
	   ll_sale_qty  > 0 and LeftA(dw_body.Object.sale_type[i], 2) = '11'  and &
		ls_item  <> 'X' THEN  
      ls_sale_fg = '2' 
		if ld_goods_amt >=  30000 then 
			dw_body.Setitem(i,"goods_amt", 30000)
		   ld_goods_amt = ld_goods_amt - 30000
		else 	
		   dw_body.Setitem(i,"goods_amt", 0)
		end if
	ELSE
		dw_body.Setitem(i,"goods_amt", 0)
      ls_sale_fg = '0' 
   END IF		 
NEXT


IF ld_goods_amt > 0 then
	MessageBox("Point 오류", "사용할 Point가 구매할 상품보다 많습니다.")
	 wf_goods_amt_clear()
	RETURN false	
END IF 
			
IF ll_remain_point >= ll_accept_point THEN 
	RETURN TRUE 
ELSE
   MessageBox("Point 오류", "사용할 Point가 부족합니다.")
   wf_goods_amt_clear()
END IF

RETURN FALSE




end function

public subroutine wf_amt_set (long al_row, long al_sale_qty);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_sale_price, ll_out_price, ll_collect_price
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect  ,ll_tot_amt, ll_row_cnt, i, ll_sale_amt
Decimal ldc_marjin
string ls_pay_way, ls_style, ls_shop_cd

ll_row_cnt = dw_body.rowcount()

ll_tag_price     = dw_body.GetitemDecimal(al_row, "tag_price") 
ll_curr_price    = dw_body.GetitemDecimal(al_row, "curr_price") 
ll_sale_price    = dw_body.GetitemDecimal(al_row, "sale_price") 
ll_out_price     = dw_body.GetitemNumber(al_row, "out_price") 
ll_collect_price = dw_body.GetitemNumber(al_row, "collect_price")
ls_style 	     = dw_body.GetitemString(al_row, "style")

dw_body.Setitem(al_row, "tag_amt",  ll_tag_price  * al_sale_qty)
dw_body.Setitem(al_row, "curr_amt", ll_curr_price * al_sale_qty)
dw_body.Setitem(al_row, "sale_amt", ll_sale_price * al_sale_qty)
dw_body.Setitem(al_row, "out_amt",  ll_out_price  * al_sale_qty) 

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	if MidA(ls_style,1,1) = '8' then
		gs_brand = 'G'
		gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
	else
		gs_brand = MidA(ls_style,1,1)
		gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
	end if
end if

if MidA(gs_shop_cd,3,6) = "2000" then
	if MidA(ls_style, 1,1) = "N" then 
		ls_shop_cd = "NK2000"
	ELSEIF MidA(ls_style, 1,1) = "O" then 	
		ls_shop_cd = "OK2000"
	ELSEif MidA(ls_style, 1,1) = "W" then 	
		ls_shop_cd = "WK2000"
	ELSE
		ls_shop_cd = "CK2000"	
	end if	
else
	ls_shoP_cd = gs_shop_cd
end if	

ll_goods_amt = dw_body.GetitemDecimal(al_row, "goods_amt") 
IF ll_goods_amt > 0 THEN 
	ldc_marjin = dw_body.GetitemDecimal(al_row, "sale_rate")
	gf_marjin_price(ls_shop_cd, (ll_sale_price * al_sale_qty) - ll_goods_amt, ldc_marjin, ll_sale_collect)  
ELSE
	ll_sale_collect = ll_collect_price * al_sale_qty  
END IF
dw_body.Setitem(al_row, "sale_collect", ll_sale_collect) 

/* 세일 재매입 처리 */
ll_io_amt = (ll_out_price  * al_sale_qty) - ll_sale_collect
dw_body.Setitem(al_row, "io_amt", ll_io_amt)
dw_body.Setitem(al_row, "io_vat", ll_io_amt - Round(ll_io_amt / 1.1, 0))

ll_tot_amt = 0

for i = 1 to ll_row_cnt	
	
		ll_sale_amt = dw_body.getitemnumber(i, "sale_amt")
	if IsNull(ll_sale_amt)  then
		ll_sale_amt = 0
	end if
	
	ll_tot_amt =ll_tot_amt + ll_sale_amt
next

ls_pay_way = dw_1.getitemstring(1, "pay_way")
dw_1.setitem(1, "sale_amt", ll_tot_amt)

if ls_pay_way = "1" then 
	dw_1.setitem(1, "cash_amt", ll_tot_amt)
elseif ls_pay_way = "2" then 	
	dw_1.setitem(1, "card_amt", ll_tot_amt)	
else
	dw_1.setitem(1, "cash_amt", 0)	
	dw_1.setitem(1, "card_amt", 0)
end if	
end subroutine

public subroutine wf_amt_reset (long al_row);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_sale_price, ll_out_price, ll_collect_price
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect  ,ll_tot_amt, ll_row_cnt, i, ll_sale_amt
Decimal ldc_marjin
string ls_pay_way

ll_row_cnt = dw_body.rowcount()

ll_tag_price     = dw_body.GetitemDecimal(al_row, "tag_price") 
ll_curr_price    = dw_body.GetitemDecimal(al_row, "curr_price") 
ll_sale_price    = dw_body.GetitemDecimal(al_row, "sale_price") 
ll_out_price     = dw_body.GetitemNumber(al_row, "out_price") 
ll_collect_price = dw_body.GetitemNumber(al_row, "collect_price")


ll_tot_amt = 0

for i = 1 to ll_row_cnt	
	ll_sale_amt = dw_body.getitemnumber(i, "sale_amt")
	if IsNull(ll_sale_amt)  then
		ll_sale_amt = 0
	end if
	
	ll_tot_amt =ll_tot_amt + ll_sale_amt
next

ls_pay_way = dw_1.getitemstring(1, "pay_way")
dw_1.setitem(1, "sale_amt", ll_tot_amt)

if ls_pay_way = "1" then 
	dw_1.setitem(1, "cash_amt", ll_tot_amt)
elseif ls_pay_way = "2" then 	
	dw_1.setitem(1, "card_amt", ll_tot_amt)	
else
	dw_1.setitem(1, "cash_amt", 0)	
	dw_1.setitem(1, "card_amt", 0)
end if	
end subroutine

public function boolean wf_style_set (long al_row, string as_style, string as_yymmdd, long al_qty);Long    ll_dc_rate     
Long    ll_curr_price,  ll_out_price
Long    ll_sale_price,  ll_collect_price 
String  ls_shop_type,   ls_sale_type = space(2), ls_year, ls_season, ls_sojae,	ls_plan_yn, ls_shop_cd, ls_shop_div, ls_dot_com, ls_color
decimal ldc_out_marjin, ldc_sale_marjin, ll_sale_rate

/* 정상, 기획 */
//ls_shop_type = dw_body.GetitemString(al_row, "shop_type")
//ls_sale_type = dw_body.GetitemString(al_row, "sale_type")
/////////////////////////////////////////
/*
if is_set_style_chk <> '' then 
	messagebox('확인','세트상품과 일반상품은 같이 결제 할 수 없습니다.')
	return false
end if
*/

ls_color = dw_body.GetItemString(al_row, "color")

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	if MidA(as_style,1,1) = '8' then
		gs_brand = 'G'
		gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
	else
		gs_brand = MidA(as_style,1,1)
		gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
	end if
end if

if MidA(gs_shop_cd,3,6) = "2000" then
	if MidA(as_style, 1,1) = "N" then 
		ls_shop_cd = "NK2000"
	ELSEIF MidA(as_style, 1,1) = "O" then 	
		ls_shop_cd = "OK2000"
	ELSEif MidA(as_style, 1,1) = "W" then 	
		ls_shop_cd = "WK2000"
	ELSEif MidA(as_style, 1,1) = "C" then 	 
		ls_shop_cd = "CK2000"
	else
		ls_shop_cd = "MD1900"	
	end if	
else
	 ls_shop_cd = gs_shop_cd
end if	 

	Select  year,     season
	  into :ls_year, :ls_season	       
		  from vi_12024_1 with (nolock)
		 where style = :as_style;		
//
//	if is_yymmdd <= '20170915' then
//		Select shop_type
//		into :ls_shop_type
//		From tb_56012_d with (nolock)
//		Where style      = :as_style 
//		  and start_ymd <= :is_yymmdd
//		  and end_ymd   >= :is_yymmdd
//		  and shop_cd    = :ls_shop_cd ;
//	else
		Select shop_type
		into :ls_shop_type
		From tb_56012_d_color with (nolock)
		Where style      = :as_style 
		  and color      = :ls_color
		  and start_ymd <= :is_yymmdd
		  and end_ymd   >= :is_yymmdd
		  and shop_cd    = :ls_shop_cd ;
		  
		  if Isnull(ls_shop_type) or Trim(ls_shop_type) = "" then
				Select shop_type
				into :ls_shop_type
				From tb_56012_d with (nolock)
				Where style      = :as_style 
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and shop_cd    = :ls_shop_cd ;		  
			end if		  
		
//	end if	
//		  
		if ls_shop_type = '1' then
			messagebox('style_set확인','정상 제품입니다. 확인 바랍니다.')			
			return false
		end if
		
	if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
			Select shop_type
   		into :ls_shop_type
			From tb_56011_d with (nolock)
			Where start_ymd <= :is_yymmdd
		   and end_ymd   >= :is_yymmdd
		   and shop_cd    = :ls_shop_cd
			and shop_type  = '4'
			and year   = :ls_year 
			and season = :ls_season;			
	end if	 		  
		  
		
	if MidA(gs_shop_cd,3,6) = "2000" then 	
		if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
			if MidA(as_style, 5,1) = 'Z' then
			 ls_shop_type = '3'
			else 
			 ls_shop_type = '1'	
			end if 
		end if	 
	else
		if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
			messagebox("경고!", "해당품번에 마진이 없습니다!")
			RETURN False 			
		end if	 
	end if	
/////////////////////////////////////////

is_mj_bit = 'Y'
ls_dot_com = dw_body.GetItemString(al_row, "dotcom")


/* 출고시 마진율 체크 (출고시에는 닷컴마진율이 아닌 백화점 마진으로 나가기)*/
//if as_yymmdd <= '20170915' then
//	IF gf_out_marjin (as_yymmdd,    gs_shop_cd,     ls_shop_type , as_style, & 
//							ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
//		is_mj_bit = 'N'
//		RETURN False 
//	END IF
//else
	IF gf_out_marjin_color (as_yymmdd,    gs_shop_cd,     ls_shop_type , as_style, ls_color, & 
							ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
		is_mj_bit = 'N'
		RETURN False 
	END IF	
//end if	
//
if ls_dot_com = "1" then
	//라빠레트 영플라자만 닷컴 체크했을 경우 G로 들어가게 수정 20161230 by 윤상혁
	if gs_shop_cd = 'BB1813' then
		select a.shoP_cd, a.shop_div
		into :ls_shoP_cd, :ls_shop_div
		from tb_91100_m a (nolock)
		where exists (	select * 
				from tb_91100_m b (nolock) 
				where b.shoP_div in ('B','G')
				  and b.brand = a.brand
				  and b.cust_cd = a.cust_cd
				  and b.shop_cd = :gs_shop_cd
				)
		and shop_div = 'G'
		and shop_stat = '00'	;
	else
		select a.shoP_cd, a.shop_div
		into :ls_shoP_cd, :ls_shop_div
		from tb_91100_m a (nolock)
		where exists (	select * 
				from tb_91100_m b (nolock) 
				where b.shoP_div in ('B','G')
				  and b.brand = a.brand
				  and b.cust_cd = a.cust_cd
				  and b.shop_cd = :gs_shop_cd
				)
		and shop_div = 'H'
		and shop_stat = '00'	;
	end if
	
	if IsNull(ls_shoP_cd) or Trim(ls_shoP_cd) = "" then
		ls_shop_cd = gs_shop_cd
		ls_shop_div = gs_shop_div
	end if
	
	/* 판매 마진율 체크 닷컴일때.(판매시에는 닷컴마진율로 나가기)*/
//	if as_yymmdd <= '20170915' then
//		IF gf_sale_marjin (as_yymmdd,    ls_shop_cd,      ls_shop_type, as_style, & 
//								 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 
//			is_mj_bit = 'N'
//			RETURN False
//		END IF
//	else
		IF gf_sale_marjin_color (as_yymmdd,    ls_shop_cd,      ls_shop_type, as_style, ls_color, & 
								 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 
			is_mj_bit = 'N'
			RETURN False
		END IF		
//	end if	
//	
	ll_curr_price = ll_sale_price
	ldc_out_marjin = ldc_sale_marjin
	ll_out_price = ll_collect_price
else
	/* 판매 마진율 체크 닷컴이 아닐때. */
//	if as_yymmdd <= '20170915' then
//		IF gf_sale_marjin (as_yymmdd,    gs_shop_cd,      ls_shop_type, as_style, & 
//								 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 		
//			return false
//		end if
//	else
		IF gf_sale_marjin_color (as_yymmdd,    gs_shop_cd,      ls_shop_type, as_style, ls_color, & 
								 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 		
			return false
		end if		
//	end if	
end if

//select year, season, sojae, plan_yn
//into :ls_year, :ls_season, :ls_sojae, :ls_plan_yn
//from tb_12020_m (nolock)
//where style = left(:as_style,8) ;
//
//// 올리브 걸스 윅크 시즌2 행사
//if is_yymmdd >= '20081003' and is_yymmdd <= '20081012' and gs_brand = 'O' then
//
//	if ls_year = '2008' and ( ls_season = 'A' or ls_season = 'W') and ls_sojae = 'X' then
//		ll_dc_rate = long(ll_dc_rate) + 10
//	end if	
//		
//	select top 1 sale_type, marjin_rate 
//		into :ls_sale_type, :ll_sale_rate
//	from tb_56010_m a(nolock) 
//	where shop_cd = :gs_shop_cd
//	and   end_ymd > :is_yymmdd
//	and   shop_type = case when :ls_plan_yn = 'Y' then '3' else '1' end
//	and   dc_rate = :ll_dc_rate
//	order by sale_type;		
//		
//	ll_sale_price    = ll_curr_price * (100 - ll_dc_rate) / 100 
//end if	
//

/* 판매 자료 등록 */
if is_mj_bit = 'Y' then
	idc_dc_rate_org = ll_dc_rate
	dw_body.Setitem(al_row, "dc_rate_org",       ll_dc_rate)
	
	dw_body.Setitem(al_row, "sale_type",  ls_sale_type)
	dw_body.Setitem(al_row, "sale_qty",   al_qty)
	
	dw_body.Setitem(al_row, "curr_price",    ll_curr_price)
	dw_body.Setitem(al_row, "dc_rate",       ll_dc_rate)
	dw_body.Setitem(al_row, "sale_price",    ll_sale_price)
	dw_body.Setitem(al_row, "out_rate",      ldc_out_marjin)
	dw_body.Setitem(al_row, "out_price",     ll_out_price)
	dw_body.Setitem(al_row, "sale_rate",     ldc_sale_marjin)
	dw_body.Setitem(al_row, "collect_price", ll_collect_price)
	
	/* 금액 처리 */
	wf_amt_set(al_row, al_qty)
	RETURN True
else
	RETURN false
end if

//RETURN True
end function

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_size, ls_shop_type, ls_given_fg, ls_given_ymd
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn , ls_shop_cd, ls_dep_fg
Long   ll_tag_price , ll_ord_qty, ll_ord_qty_chn, ll_stock_qty, ll_b_cnt
decimal ldc_sale_qty
IF LenA(Trim(as_style_no)) <> 13 THEN RETURN FALSE

if MidA(as_style_no, 1, 8) = 'NW6SO652' then
	as_style_no = MidA(as_style_no, 1, 8) + '1' + MidA(as_style_no, 10, 2) + MidA(as_style_no, 12, 2)
end if		

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	if MidA(as_style_no,1,1) = '8' then
		gs_brand = 'G'
		gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
	else
		gs_brand = MidA(as_style_no,1,1)
		gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
	end if
end if

select isnull(count(brand),0)
into	:ll_b_cnt
from tb_91100_m  with (nolock) 
where shop_cd like '%' + substring('XX1890',3,4)
		and brand = :gs_brand;	
		
if ll_b_cnt = 0 then 
	messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
	return false
end if

if MidA(gs_shop_cd,3,2) = '19' or  MidA(gs_shop_cd,3,6) = '2000'  then
//	messagebox("mid(gs_shop_cd,3,6)",mid(gs_shop_cd,3,6))
	
	Select brand,     year,     season,     
	       sojae,     item,     tag_price,     plan_yn, 	dep_fg
	  into :ls_brand, :ls_year, :ls_season, 
	       :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn, :ls_dep_fg     
		  from vi_12024_1 with (nolock)
		 where style = :ls_style 
			and chno  = :ls_chno
			and color = :ls_color 
			and size  = :ls_size
			and plan_yn <> 'Y'	
			and sojae  <> 'C' ;		
			
elseif gs_brand = "I" then			
		Select brand,     year,     season,     
				 sojae,     item,     tag_price,     plan_yn, 	dep_fg
		  into :ls_brand, :ls_year, :ls_season, 
				 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn, :ls_dep_fg     
			  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
  			   and plan_yn <> 'Y'					
				and year + season in (	select year + season
												from tb_51036_d a (nolock), tb_51035_h b (nolock)
												where :is_yymmdd between a.frm_ymd and a.to_ymd
												and a.shop_cd = :gs_shoP_cd
												and a.shop_cd = b.shop_cd
												and a.frm_ymd = b.frm_ymd
												and b.cancel <> 'Y' )
				and sojae  <> 'C' ;			
elseif gs_brand = 'B' or gs_brand = 'P' or gs_brand = 'K' or gs_brand = 'U' then
		Select brand,     year,     season,     
				 sojae,     item,     tag_price,     plan_yn, 	dep_fg
		  into :ls_brand, :ls_year, :ls_season, 
				 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn, :ls_dep_fg     
			  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
  			   and plan_yn <> 'Y'					
				and size    <>  case when  substring(:gs_shop_cd,3,6) = "2000" then 'CC' else 'XX' end
				and year + season in (	select year + season
												from tb_51036_d a (nolock), tb_51035_h b (nolock)
												where :is_yymmdd between a.frm_ymd and a.to_ymd
												and a.shop_cd = :gs_shoP_cd
												and a.shop_cd = b.shop_cd
												and a.frm_ymd = b.frm_ymd
												and b.cancel <> 'Y' ) ;	
			
else			
		Select brand,     year,     season,     
				 sojae,     item,     tag_price,     plan_yn, 	dep_fg
		  into :ls_brand, :ls_year, :ls_season, 
				 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn, :ls_dep_fg     
			  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
  			   and plan_yn <> 'Y'					
				and size    <>  case when  substring(:gs_shop_cd,3,6) = "2000" then 'CC' else 'XX' end
				and year + season in (	select year + season
												from tb_51036_d a (nolock), tb_51035_h b (nolock)
												where :is_yymmdd between a.frm_ymd and a.to_ymd
												and a.shop_cd = :gs_shoP_cd
												and a.shop_cd = b.shop_cd
												and a.frm_ymd = b.frm_ymd
												and b.cancel <> 'Y' )
				and sojae  <> 'C' ;		
end if

	//			and ( year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  >=  '20064')				
				
//	else
//		
//	
//		Select a.brand,     a.year,     a.season,     
//				 a.sojae,     a.item,     a.tag_price,     a.plan_yn, 	a.dep_fg
//		  into :ls_brand, :ls_year, :ls_season, 
//				 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn, :ls_dep_fg    
//			  from vi_12024_1 a with (nolock), 
//					 (select distinct b.year, b.season
//						from tb_51035_h a (nolock), tb_51036_d b (nolock)
//						where :is_yymmdd between a.frm_ymd and a.to_ymd  
//						and a.cancel <> 'Y'
//						and a.shop_cd = :gs_shop_cd
//						and a.shop_cd = b.shop_cd
//						and a.frm_ymd = b.frm_ymd
//						and a.to_ymd  = b.to_ymd ) b	  
//			 where a.brand = :gs_brand 
//				and a.style = :ls_style 
//				and a.chno  = :ls_chno
//				and a.color = :ls_color 
//				and a.size  = :ls_size
//				and a.year   = b.year
//				and a.season = b.season
//				and a.size  <>  case when  substring(:gs_shop_cd,3,6) = "2000" then 'CC' else 'XX' end
//				and a.sojae  <> 'C' ;		
//	
//	end if

IF SQLCA.SQLCODE <> 0 THEN 
	messagebox("경고!", "품번이 잘못되었거나 행사대상 제품이 아닙니다!")
	Return False 
END IF

if MidA(gs_shop_cd,3,6) = "2000" then
	if MidA(ls_style, 1,1) = "N" then 
		ls_shop_cd = "NK2000"
	ELSEIF MidA(ls_style, 1,1) = "O" then 	
		ls_shop_cd = "OK2000"
	ELSEif MidA(ls_style, 1,1) = "W" then 	
		ls_shop_cd = "WK2000"
	ELSEif MidA(ls_style, 1,1) = "C" then 		
		ls_shop_cd = "CK2000"	
	else
		ls_shop_cd = "MD1900"		
	end if	
else
	ls_shop_cd = gs_shop_cd
end if	

//	if is_yymmdd <= '20170915' then
//		Select shop_type
//		into :ls_shop_type
//		From tb_56012_d with (nolock)
//		Where style      = :ls_style 
//		  and start_ymd <= :is_yymmdd
//		  and end_ymd   >= :is_yymmdd
//		  and shop_cd    = :ls_shop_cd;
//	else
		Select shop_type
		into :ls_shop_type
		From tb_56012_d_color with (nolock)
		Where style      = :ls_style 
		  and color      = :ls_color
		  and start_ymd <= :is_yymmdd
		  and end_ymd   >= :is_yymmdd
		  and shop_cd    = :ls_shop_cd;
		  
		  if Isnull(ls_shop_type) or Trim(ls_shop_type) = "" then
			Select shop_type
			into :ls_shop_type
			From tb_56012_d with (nolock)
			Where style      = :ls_style 
			  and start_ymd <= :is_yymmdd
			  and end_ymd   >= :is_yymmdd
			  and shop_cd    = :ls_shop_cd;		  
		end if		  
		
//	end if	
		  
		if ls_shop_type = '1' then
			messagebox('style_chk확인','정상 제품입니다. 확인 바랍니다.')
			return false			
		end if

		if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
				Select shop_type
				into :ls_shop_type
				From tb_56011_d with (nolock)
				Where start_ymd <= :is_yymmdd
				and end_ymd   >= :is_yymmdd
				and shop_cd    = :ls_shop_cd
				and shop_type  = '4'
				and year   = :ls_year 
				and season = :ls_season;			
		end if	 		 


	 if MidA(gs_shop_cd,3,6) = "2000" then	
		if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
			if MidA(ls_style, 5,1) = 'Z' then
			 ls_shop_type = '3'
			else 
			 ls_shop_type = '1'	
			end if 
		end if	 
	ELSE
		if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
			messagebox("경고!", "해당품번의 마진이 없습니다!")
			Return False
		end if	
	end if	



Select isnull(ord_qty,0), isnull(ord_qty_chn,0)
  into :ll_ord_qty, :ll_ord_qty_chn  
  from tb_12030_s with (nolock)
 where  style = :ls_style 
	and chno  = :ls_chno
	and color = :ls_color 
	and size  = :ls_size;
	
if gs_brand <> 'M' then
	if ll_ord_qty - ll_ord_qty_chn <= 0  then 
		messagebox("경고!", "국내 판매등록이 불가능한 제품입니다!")
		return false
	end if	
end if	



select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
into  :ls_given_fg, :ls_given_ymd
from tb_12020_m with (nolock)
where style = :ls_style;

if ls_given_fg = "Y" then 
	messagebox("품번체크", ls_given_ymd + "일자로 판매불가로 전환된 제품입니다!")
	return false
end if 	

//	select sum(isnull(out_qty,0)) - sum(isnull(rtrn_qty,0)) - sum(isnull(sale_qty,0))
//	into :ll_stock_qty
//	  from tb_44012_s with (nolock)
//		 where shop_cd = :gs_shoP_cd
//		   and shop_type = :ls_shop_type
//		 	and style = :ls_style;
////			and chno  = :ls_chno
////			and color = :ls_color 
////			and size  = :ls_size;
////
////messagebox("ll_stock_qty", string(ll_stock_qty,"0000"))
//if ll_stock_qty <= 0 then 
//	messagebox("재고확인", "현재 매장에 재고가 없는 스타일입니다!")
//	return false
//end if 	


dw_body.SetItem(al_row, "tag_price", ll_tag_price) 
dw_body.Setitem(al_row, "shop_type", ls_shop_type)

if isnull(dw_body.GetItemNumber(al_row, "sale_qty")) or dw_body.GetItemNumber(al_row, "sale_qty") = 0  then
	ldc_sale_qty = 1
else
	ldc_sale_qty = dw_body.GetItemNumber(al_row, "sale_qty")
end if

//ldc_sale_qty = dw_body.GetItemNumber(al_row, "sale_qty")

IF wf_style_set(al_row, ls_style, is_yymmdd, ldc_sale_qty) THEN 
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
	wf_style_set(al_row, ls_style, is_yymmdd, ldc_sale_qty) 
ELSE
	Return False
END IF

Return True

end function

public function boolean wf_style_set_back (long al_row, string as_style);Long    ll_dc_rate     
Long    ll_curr_price,  ll_out_price
Long    ll_sale_price,  ll_collect_price 
String  ls_shop_type,   ls_sale_type = space(2), ls_shop_cd, ls_year, ls_season, ls_color
decimal ldc_out_marjin, ldc_sale_marjin

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	if MidA(as_style,1,1) = '8' then
		gs_brand = 'G'
		gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
	else
		gs_brand = MidA(as_style,1,1)
		gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
	end if
end if

ls_color = dw_body.GetitemString(al_row, "color")

/* 정상, 기획 */
//ls_shop_type = dw_body.GetitemString(al_row, "shop_type")
if MidA(gs_shop_cd,3,6) = "2000" then
	if MidA(as_style, 1,1) = "N" then 
		ls_shop_cd = "NK2000"
	ELSEIF MidA(as_style, 1,1) = "O" then 	
		ls_shop_cd = "OK2000"
	ELSEif MidA(as_style, 1,1) = "W" then 	
		ls_shop_cd = "WK2000"
	ELSEif MidA(as_style, 1,1) = "C" then 	 
		ls_shop_cd = "CK2000"
	else
		ls_shop_cd = "MD1900"	
	end if	
else
	 ls_shop_cd = gs_shop_cd
end if	 

	Select  year,     season
	  into :ls_year, :ls_season	       
		  from vi_12024_1 with (nolock)
		 where style = :as_style;		

//	if is_yymmdd <= '20170915' then
//		Select shop_type
//		into :ls_shop_type
//		From tb_56012_d with (nolock)
//		Where style      = :as_style 
//		  and start_ymd <= :is_yymmdd
//		  and end_ymd   >= :is_yymmdd
//		  and shop_cd    = :ls_shop_cd ;
//		  
//	else
		Select shop_type
		into :ls_shop_type
		From tb_56012_d_color with (nolock)
		Where style      = :as_style 
		  and color      = :ls_color	
		  and start_ymd <= :is_yymmdd
		  and end_ymd   >= :is_yymmdd
		  and shop_cd    = :ls_shop_cd ;
		  
		if isnull(ls_shop_type) or Trim(ls_shop_type) = "" then		  
			Select shop_type
			into :ls_shop_type
			From tb_56012_d with (nolock)
			Where style      = :as_style 
			  and start_ymd <= :is_yymmdd
			  and end_ymd   >= :is_yymmdd
			  and shop_cd    = :ls_shop_cd ;
		end if		  
		
//	end if 
	
		if ls_shop_type = '1' then
			return false
			messagebox('확인','정상 제품입니다. 확인 바랍니다.')
		end if		  

	if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
			Select shop_type
   		into :ls_shop_type
			From tb_56011_d with (nolock)
			Where start_ymd <= :is_yymmdd
		   and end_ymd   >= :is_yymmdd
		   and shop_cd    = :ls_shop_cd
			and shop_type  = '4'
			and year   = :ls_year 
			and season = :ls_season;			
	end if	 		  
		  
		
	if MidA(gs_shop_cd,3,6) = "2000" then 	
		if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
			if MidA(as_style, 5,1) = 'Z' then
			 ls_shop_type = '3'
			else 
			 ls_shop_type = '1'	
			end if 
		end if	 
	else
		if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
			messagebox("경고!", "해당품번에 마진이 없습니다!")
			RETURN False 			
		end if	 
	end if		

//if is_yymmdd <= '20170915' then
//	
//	/* 출고시 마진율 체크 */
//	IF gf_out_marjin (is_yymmdd,    ls_shop_cd,     ls_shop_type, as_style, & 
//							ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
//		RETURN False 
//	END IF
//	/* 판매 마진율 체크 */
//	IF gf_sale_marjin (is_yymmdd,   ls_shop_cd,      ls_shop_type, as_style, & 
//							 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 
//		RETURN False 
//	END IF
//else

	/* 출고시 마진율 체크 */
	IF gf_out_marjin_color (is_yymmdd,    ls_shop_cd,     ls_shop_type, as_style, ls_color, & 
							ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
		RETURN False 
	END IF
	/* 판매 마진율 체크 */
	IF gf_sale_marjin_color (is_yymmdd,   ls_shop_cd,      ls_shop_type, as_style, ls_color,  & 
							 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 
		RETURN False 
	END IF	
//end if	

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

on w_sh144_e.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_list=create dw_list
this.st_1=create st_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.dw_3=create dw_3
this.dw_2=create dw_2
this.st_2=create st_2
this.dw_4=create dw_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.dw_3
this.Control[iCurrent+7]=this.dw_2
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.dw_4
end on

on w_sh144_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_list)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.dw_4)
end on

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(cb_1, "FixedToRight")
inv_resize.of_Register(st_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_1, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_2, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_3, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(gb_1, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_4, "FixedToBottom&ScaleToRight")


dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

dw_1.insertRow(0)
dw_4.insertRow(0)



end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size, ls_shop_type, ls_given_fg, ls_given_ymd, ls_emp_nm, ls_fr_year
String     ls_empno, ls_qry, ls_year, ls_season
Long       ll_row_cnt , ll_ord_qty, ll_ord_qty_chn,ll_stock_qty
Boolean    lb_check 
DataStore  lds_Source 
decimal    ldc_sale_qty
ls_fr_year = is_fr_year + is_fr_season

is_yymmdd  = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	if MidA(as_data,1,1) = '8' then
		gs_brand = 'G'
		gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
	else
		gs_brand = MidA(as_data,1,1)
		gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
	end if
end if

CHOOSE CASE as_column
	CASE "style_no"		
		if MidA(as_data, 1, 8) = 'NW6SO652' then
			as_data = MidA(as_data, 1, 8) + '1' + MidA(as_data, 10, 2) + MidA(as_data, 12, 2)
		end if	
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
		
//			if mid(gs_shop_cd,3,4) = '2000' then
//				gst_cd.default_where   = "WHERE  year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  >  '20054'  " 				 			
//			elseif mid(gs_shop_cd,3,2) = '19' then
//				gst_cd.default_where   = "WHERE  year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  >  '20054'  " 				 				
//			else
//				if gs_brand = "N" then
//				gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and  year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  >=   '" + ls_fr_year + "' and sojae <> 'C' " 
////												 " or ( year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  >  '20063'  and plan_yn = 'Y'))"
//				else 												 
//				  gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and  year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  >=   '" + ls_fr_year + "' and sojae <> 'C' " 
//				end if								
//			end if	 
				
	if MidA(gs_shop_cd,3,4) >= "1900" and MidA(gs_shop_cd,3,4) <= "1913" then 				
	    gst_cd.default_where   = "WHERE brand = '" + gs_brand + "'"
	elseif gs_braND = "I" THEN
	    gst_cd.default_where   = "WHERE brand = '" + gs_brand + "'"
		 
	else	 
		if gs_brand = "B" or gs_brand = "P" or gs_brand = "K" or gs_brand = 'U' then 					
			gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and plan_yn <> 'Y' and  year + season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where  '" + is_yymmdd + "' "  + &
		                         " between a.frm_ymd and a.to_ymd and a.shop_cd =  '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') "  
		else
			gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and plan_yn <> 'Y' and  year + season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where  '" + is_yymmdd + "' "  + &
		                         " between a.frm_ymd and a.to_ymd and a.shop_cd =  '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') and sojae <> 'C' "  
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
			
				ls_style = lds_Source.GetItemString(1,"style")		
				ls_chno  = lds_Source.GetItemString(1,"chno")		
				ls_color = lds_Source.GetItemString(1,"color")		
				ls_size = lds_Source.GetItemString(1,"size")						
				ls_year = lds_Source.GetItemString(1,"year")						
				ls_season = lds_Source.GetItemString(1,"season")										

				if wf_style_chk(al_row, ls_style + ls_chno + ls_color + ls_size ) = false then 
						ib_itemchanged = FALSE
						return 1 
				end if		


		if MidA(gs_shop_CD,3,6) = "2000" then							
				
				
				Select shop_type
				into :ls_shop_type
				From tb_56012_d_color with (nolock)
				Where style      = :ls_style 
				  and color      = :ls_color
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and (shop_cd    like '_K2000' or shop_cd = 'MD1900') ;
				
				
				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
					Select shop_type
					into :ls_shop_type
					From tb_56012_d with (nolock)
					Where style      = :ls_style 
					  and start_ymd <= :is_yymmdd
					  and end_ymd   >= :is_yymmdd
					  and (shop_cd    like '_K2000' or shop_cd = 'MD1900') ;
				end if 
				  
				
				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
					if MidA(ls_style, 5,1) = 'Z' then
					 ls_shop_type = '3'
					else 
					 ls_shop_type = '1'	
					end if 
				end if	 				
				
			ELSE		
				
				Select shop_type
				into :ls_shop_type
				From tb_56012_d_color with (nolock)
				Where style      = :ls_style 
				  and color      = :ls_color
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and shop_type > '3'
				  and shop_cd   = :GS_SHOP_CD;
				 
				 if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then	
					Select shop_type
					into :ls_shop_type
					From tb_56012_d with (nolock)
					Where style      = :ls_style 
					  and start_ymd <= :is_yymmdd
					  and end_ymd   >= :is_yymmdd
					  and shop_type > '3'
					  and shop_cd   = :GS_SHOP_CD;
				  end if	
				
					if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
						Select shop_type
						into :ls_shop_type
						From tb_56011_d with (nolock)
						Where start_ymd <= :is_yymmdd
						and end_ymd   >= :is_yymmdd
						and shop_cd    = :GS_SHOP_CD
						and shop_type > '3'
						and year   = :ls_year 
						and season = :ls_season;			
					end if	 		  
				
				
				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
					dw_body.SetItem(al_row, "style_no", "")
						ib_itemchanged = FALSE
						return 1 
				end if	 		
				
			Select isnull(ord_qty,0), isnull(ord_qty_chn,0)
				  into :ll_ord_qty, :ll_ord_qty_chn  
				  from tb_12030_s with (nolock)
				 where style = :ls_style 
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
		END IF		
		
				select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
				into :ls_given_fg, :ls_given_ymd
				from beaucre.dbo.tb_12020_m with (nolock)
				where style like :ls_style + '%';
				
				IF ls_given_fg = "Y"  THEN 
					messagebox("품번검색", ls_given_ymd + "일자로 판매불가로 전환된 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				END IF 		
		
		
//			select sum(isnull(out_qty,0)) - sum(isnull(rtrn_qty,0)) - sum(isnull(sale_qty,0))
//			into :ll_stock_qty
//			  from tb_44012_s with (nolock)
//				 where shop_cd = :gs_shoP_cd
//					and shop_type = :ls_shop_type
//					and style = :ls_style 
//					and chno  = :ls_chno
//					and color = :ls_color 
//					and size  = :ls_size;
//
//				//messagebox("ll_stock_qty", string(ll_stock_qty,"0000"))
//				if ll_stock_qty <= 0 then 
//					messagebox("재고확인", "현재 매장에 재고가 없는 스타일입니다!")
//					dw_body.SetItem(al_row, "style_no", "")
//					ib_itemchanged = FALSE
//					return 1 	
//				end if 	
		
		
		
				dw_body.SetItem(al_row, "shop_type", ls_shop_type) 
				ldc_sale_qty = dw_body.GetItemNumber(al_row, "sale_qty")	
 				IF wf_style_set(al_row, ls_style,is_yymmdd, ldc_sale_qty) THEN 
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
					wf_style_set(al_row, ls_style,is_yymmdd, ldc_sale_qty)
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
long ll_cnt

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

is_yymmdd  = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"판매일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if


is_sale_no = dw_head.GetitemString(1, "sale_no")


if MidA(gs_shop_cd,3,4) = '2000' or gs_shop_cd = 'MD1900' then
	
//elseif gs_brand = 'W' then	
//				is_fr_year = "2007"
//				is_fr_season = "2"
else
//   select  count(shop_cd), min(a.fr_year), min(b.inter_cd1) 
//	  into :ll_cnt, :is_fr_year, :is_fr_season
//	from tb_51035_h a (nolock), tb_91011_c b (nolock)
//	where a.brand = :gs_brand
//	and b.inter_grp = '003'
//	and a.fr_season = b.inter_cd 
//	and :is_yymmdd between a.frm_ymd and a.to_ymd
//	and a.shop_cd = :gs_shop_cd ;
	
	
   select  count(shop_cd), min(a.fr_year), min(a.fr_season) 
   into :ll_cnt, :is_fr_year, :is_fr_season
	from tb_51035_h a (nolock)
	where :is_yymmdd between a.frm_ymd and a.to_ymd
	and  a.cancel <> 'Y'
	and a.shop_cd = :gs_shop_cd ;	
	
		if is_fr_year = "%" then
			if gs_brand = "O" then
				is_fr_year = "2006"
			else	
				is_fr_year = "2007"
			end if	
		end if	
		
		if is_fr_season = "%" then			
			if gs_brand = 'O' then
				is_fr_season = "4"
			else	
				is_fr_season = "2"
			end if				
		else
			if is_fr_season = "S" then
				is_fr_season = "1"
			elseif is_fr_season = "M" then
				is_fr_season = "2"	
			elseif is_fr_season = "A" then
				is_fr_season = "3"	
			elseif is_fr_season = "W" then
				is_fr_season = "4"					
			end if	
		end if	
 	

		if ll_cnt < 1 then
				if MidA(gs_shop_cd ,2,1) = 'G' or MidA(gs_shop_cd ,2,1) = 'K' then
						st_2.text = "※ 등록은 진행 행사가 있는 기간에만 가능합니다."
						RETURN FALSE
				else		
						st_2.text = ""	
				end if					
		else 	
				st_2.text = ""	
		end if			
	
end if	


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
wf_amt_reset(il_rows)
This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
String   ls_style_no,   ls_sale_fg,   ls_card_no  , ls_coupon_no , ls_jumin, ls_item, ls_card_no_origin, ls_style
long     ll_sale_price, ll_goods_amt, ll_sale_qty , ll_coupon_amt, ll_accept_point
long     i, ll_row_count, ll_chk, ll_cash_amt, ll_card_amt, ll_sale_amt, ll_stock_qty
decimal	ldc_dc_rate, ld_goods_amt, ldc_sale_qty
datetime ld_datetime 
int     li_point_seq	
String   ls_shop_type, ls_sale_type, ls_shop_cd, ls_card_gubn, ls_pay_way,ls_dot_com, ls_shop_div, ls_brand
String ls_chno, ls_color, ls_size, ls_year

IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_4.AcceptText()    <> 1 THEN RETURN -1
ls_jumin = dw_4.getitemstring(1,"jumin")
ls_card_no = dw_4.getitemstring(1,"card_no")

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

//IF NOT isnull(dw_1.Object.JUMIN[1]) AND isnull(dw_1.Object.age_grp[1]) THEN
//	MessageBox("경고", "연령층 이나 회원정보를 등록하십시오 !") 
//	Return 0 
//END IF
ll_row_count = dw_body.RowCount()


	
	if ll_row_count = 0 and (ll_sale_amt = 0  or  isnull(ll_sale_amt)) then
			MessageBox("경고!","판매내역이 없습니다!")
			dw_body.SetFocus()
			dw_body.SetColumn("style_no")
			return -1
	end if	




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
ELSE

	if MidA(gs_shop_cd,3,6) = "2000" then
		 select right(isnull(max(SALE_NO), 0) + 10001, 4)
		  into :is_sale_no 
		  from tb_53010_h (nolock)
		 where yymmdd    = :is_yymmdd 
			and (shop_cd   like '__2000%' or shop_cd like 'MD1900%')
				and shop_type in ('1','3','4');
				
	
	else			
		 select right(isnull(max(SALE_NO), 0) + 10001, 4)
		  into :is_sale_no 
		  from tb_53010_h (nolock)
		 where yymmdd    = :is_yymmdd 
			and shop_cd   = :gs_shop_cd
				and shop_type in ('1','3','4');
	end if		
END IF



///* point 판매 처리 및 가능여부 체크 (정상판매단가가  Point금액 이상 매출만 가능)*/
//ll_goods_amt = dw_1.GetitemNumber(1, "goods_amt")  // point금액 


	
//IF isnull(ls_card_no) = FALSE AND len(ls_card_no) = 9 THEN
//	ls_card_no = '4870090' + ls_card_no 
//END IF
//

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	ls_style = dw_body.getitemstring(i, "style")
	ls_chno  = dw_body.getitemstring(i, "chno")
	ls_color = dw_body.getitemstring(i, "color")
	ls_size = dw_body.getitemstring(i, "size")	
	ll_sale_qty = dw_body.getitemNumber(i, "sale_qty")	
	ls_dot_com = dw_body.GetItemString(i, "dotcom")
	ls_shop_type = dw_body.getitemstring(i, "shop_type")
	ls_sale_type = dw_body.getitemstring(i, "sale_type")	
	ldc_dc_rate  = dw_body.getitemnumber(i, "dc_rate")		
	ls_year = dw_body.getitemstring(i, "year")
	ldc_sale_qty = dw_body.GetItemNumber(i, "sale_qty")	
	
		if ls_dot_com = "1" then 
			
			//라빠레트 영플라자만 닷컴 체크했을 경우 G로 들어가게 수정 20161230 by 윤상혁
			if gs_shop_cd = 'BB1813' then
				select a.shoP_cd, a.shop_div
				into :ls_shoP_cd, :ls_shop_div
				from tb_91100_m a (nolock)
				where exists (	select * 
						from tb_91100_m b (nolock) 
						where b.shoP_div in ('B','G')
						  and b.brand = a.brand
						  and b.cust_cd = a.cust_cd
						  and b.shop_cd = :gs_shop_cd
						)
				and shop_div = 'G'
				and shop_stat = '00'	;
			else
				select a.shoP_cd, a.shop_div
				into :ls_shoP_cd, :ls_shop_div
				from tb_91100_m a (nolock)
				where exists (	select * 
						from tb_91100_m b (nolock) 
						where b.shoP_div in ('B','G')
						  and b.brand = a.brand
						  and b.cust_cd = a.cust_cd
						  and b.shop_cd = :gs_shop_cd
						)
				and shop_div = 'H'
				and shop_stat = '00'	;
			end if
				
			
				if IsNull(ls_shoP_cd) or Trim(ls_shoP_cd) = "" then
				   ls_shop_cd = gs_shop_cd
					ls_shop_div = gs_shop_div
			   else
							select right(isnull(max(SALE_NO), 0) + 10001, 4)
							  into :is_sale_no 
							  from tb_53010_h (nolock)
							 where yymmdd    = :is_yymmdd 
								and shop_cd   = :ls_shop_cd
								and shop_type in ('1','3','4');
				end if							
							
	   else
				   ls_shop_cd = gs_shop_cd
					ls_shop_div = gs_shop_div

		end if 

	 	  IF  idw_status <> NewModified! and gs_shop_div <> "H" and ls_dot_com = "1"  then
				MessageBox("경고", "기존판매분의 닷컴으로의 전환은 불가능합니다.!") 
				Return 0 
 		   END IF
			 
	
	if idw_status = NewModified! and  ll_sale_qty > 0  and ( MidA(gs_shop_cd,3,6) <> "2000"  and  MidA(gs_shop_cd,2,1) <> "E" and MidA(gs_shop_cd,3,6) <> "0002" ) then
		
		select sum(isnull(out_qty,0)) - sum(isnull(rtrn_qty,0)) - sum(isnull(sale_qty,0))
	  into :ll_stock_qty
	  from tb_44012_s with (nolock)
		 where shop_cd = :gs_shoP_cd
		   and shop_type = :ls_shop_type
		 	and style = :ls_style 
			and year = :ls_year; //년도가 기존에 있는 2001년도 상품코드가 있어서 수량이 안맞아 임시로 넣음.
//			and chno  = :ls_chno
//			and color = :ls_color 
//			and size  = :ls_size;
//홍윤정부장 요청
//NW6SO652 0차로 찍히면 1차로 변경해서 저장함.(by 윤상혁)20160325
		if ll_stock_qty <= 0 and ll_sale_qty > 0 and ls_style <> 'NW6SO652' then 
			messagebox("재고확인", ls_style + ls_chno + ls_color + ls_size + "는 현재 매장에 재고가 없는 스타일입니다!")
			return 0
		end if 	
		
	   if ll_stock_qty >= 0 and ll_stock_qty < ll_sale_qty and ls_style <> 'NW6SO652' then 
			messagebox("재고확인", ls_style + ls_chno + ls_color + ls_size + "는 현재 재고보다 판매수량이 많습니다!")
			return 0
		end if 			
		
		
	end if
	
	if MidA(gs_shop_cd,3,6) = "2000" then	
		ls_brand = MidA(ls_style,1,1)
		if MidA(ls_style,1,1) = "N" then
			ls_shop_cd = "NK2000"
		elseif MidA(ls_style,1,1) = "O" then	
			ls_shop_cd = "OK2000"
		elseif MidA(ls_style,1,1) = "W" then	 
			ls_shop_cd = "WK2000"
		else	
			ls_shop_cd = "MD1900"		
		end if	
	else
		ls_shop_cd = ls_shop_cd
		ls_brand = gs_brand
	end if	

	ls_style = MidA(dw_body.getitemstring(i,'style_no'),1,8)
	
	//닷컴으로 판매시 마진율 한번더 체크해서 닷컴으로 된 마진율 넣기
	//장나영차장님 요청건.
	//작업일자:2014.10.18  작업자:윤상혁

	if ls_shoP_div = 'H' then
		wf_style_set(i, ls_style, is_yymmdd, ldc_sale_qty)
		if is_mj_bit = 'N' then
			return 0
		end if
	end if

	//복합매장 채번
	if IsNull(ls_shoP_cd) or Trim(ls_shoP_cd) = "" then
		ls_shop_cd = gs_shop_cd
		ls_shop_div = gs_shop_div
	else
		select right(isnull(max(SALE_NO), 0) + 10001, 4)
		  into :is_sale_no 
		  from tb_53010_h (nolock)
		 where yymmdd    = :is_yymmdd 
			and substring(shop_cd,3,4)   = substring(:ls_shop_cd,3,4)
			and shop_type in ('1','3');
	end if		

   IF idw_status = NewModified! THEN			/* New Record */  
      dw_body.Setitem(i, "no",  String(i, "0000"))
      dw_body.Setitem(i, "yymmdd", is_yymmdd)
      dw_body.Setitem(i, "shop_cd",  ls_shop_cd)
      dw_body.Setitem(i, "shop_div", MidA(ls_shop_cd,2,1))
      dw_body.Setitem(i, "sale_no",  is_sale_no)
		dw_body.setitem(i, "brand", ls_brand)
      dw_body.Setitem(i, "reg_id",   gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */	
	   dw_body.Setitem(i, "shop_cd",  ls_shop_cd)
      dw_body.Setitem(i, "shop_div", MidA(ls_shop_cd,2,1))		
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF 
	
	ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))
	ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
	ls_style_no  = dw_body.Getitemstring(i, "style_no")
   ls_item      = RightA(LeftA(ls_style_no,2),1)
	
//	IF ll_goods_amt > 0 and ll_sale_price > 30000 and  & 
//	   ll_sale_qty  > 0 and Left(dw_body.Object.sale_type[i], 2) = '11'  and &
//		ls_item  <> 'X' THEN  
//      ls_sale_fg = '2' 
//		dw_body.Setitem(i, "goods_amt", ll_goods_amt) 
//		ll_goods_amt = 0 
//	ELSEIF Len(Trim(dw_1.Object.jumin[1])) = 13 and Left(dw_body.Object.sale_type[i], 1) < '2' THEN  // 정상 적용 
//      ls_sale_fg = '1' 
//		dw_body.Setitem(i, "goods_amt", 0)
//   ELSE
//      ls_sale_fg = '0' 
//		dw_body.Setitem(i, "goods_amt", 0) 
//   END IF		
	
   wf_amt_set(i, ll_sale_qty)
	
   IF idw_status <> New! THEN 
      dw_body.Setitem(i, "sale_fg", ls_sale_fg)   
		dw_body.Setitem(i, "jumin",   ls_jumin)  
		dw_body.Setitem(i, "card_no", ls_card_no)  

	END IF
	
	
	


NEXT

/* 판매일자와 시스템 날짜가 다르면 재 로그인 처리
   장나영차장님 요청 - '20140408'
*/
string ls_date_1, ls_date_2
datetime ld_date_t

SELECT GetDate() 
  INTO :ld_date_t
  FROM DUAL ;

IF dw_head.AcceptText()    <> 1 THEN RETURN -1

ls_date_1 = string(ld_date_t, "YYYYMMDD")
ls_date_2 = string(dw_head.getitemdate(1,'yymmdd'),'YYYYMMDD')


IF ls_date_1 <> ls_date_2 then
	messagebox('확인','판매 입력일이 다릅니다. 재 로그인 해주시기 바랍니다!')
	Return 0
END IF

/*코인코즈 판매등록 제한걸기 반품등록만 가능하게 수정 - by윤상혁(20160104) */

int m
if gs_brand = "I" then
	for m = 1 to ll_row_count
		if dw_body.Getitemnumber(m, "sale_qty") > 0 then
			messagebox("경고!","코인코즈 판매등록은 반품만 가능합니다! 정상 등록시 영업관리팀 주소연과장에게 확인하세요!")
			Return 0 
		end if
	next
end if


il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	dw_body.Retrieve(is_yymmdd, gs_shop_cd, is_sale_no) 
	This.Post Event ue_total_retrieve()	

	cb_1.SetFocus()
else
   rollback  USING SQLCA;
end if

/*구매내역 영수증 출력
if gs_shop_cd = 'TB1004' or mid(gs_shop_cd_1,1,2) = 'XX' then
	integer Net
	Net = MessageBox("영수증출력", "영수증을 출력 하시겠습니까?", Exclamation!, OKCancel!, 2)
	
	IF Net = 1 THEN 
		cb_print.TriggerEvent(Clicked!)
	END IF
end if
	

*/


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

event ue_insert();
if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */

IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
//	dw_body.Reset()
END IF

il_rows = dw_body.InsertRow(0)
wf_amt_reset(il_rows)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_sh144_e
boolean visible = false
integer x = 389
end type

type cb_delete from w_com010_e`cb_delete within w_sh144_e
integer taborder = 70
end type

type cb_insert from w_com010_e`cb_insert within w_sh144_e
integer taborder = 60
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh144_e
integer x = 2469
integer width = 384
integer taborder = 110
string text = "일보조회(&Q)"
end type

type cb_update from w_com010_e`cb_update within w_sh144_e
integer taborder = 50
end type

type cb_print from w_com010_e`cb_print within w_sh144_e
boolean visible = false
integer taborder = 80
end type

type cb_preview from w_com010_e`cb_preview within w_sh144_e
boolean visible = false
integer x = 1193
integer y = 48
integer taborder = 90
end type

type gb_button from w_com010_e`gb_button within w_sh144_e
end type

type dw_head from w_com010_e`dw_head within w_sh144_e
integer y = 152
integer height = 96
string dataobject = "d_sh133_h01"
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
//		is_yymmdd = String(Date(data), "yyyymmdd")
//      IF GF_IWOLDATE_CHK(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN
//			MessageBox("일자변경", "소급할수 없는 일자입니다.")
//			Return 1
//		END IF
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_sh144_e
integer beginy = 256
integer endy = 256
end type

type ln_2 from w_com010_e`ln_2 within w_sh144_e
integer beginy = 260
integer endy = 260
end type

type dw_body from w_com010_e`dw_body within w_sh144_e
event ue_set_column ( long al_row )
integer x = 9
integer y = 256
integer width = 2866
integer height = 924
string dataobject = "d_sh144_d01"
boolean hscrollbar = true
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
		wf_amt_reset(row)
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
Long   ll_curr_price, ll_sale_price, ll_collect_price

IF row < 1 THEN RETURN 
ls_style_no = This.GetitemString(row, "style_no")

IF isnull(ls_style_no) or Trim(ls_style_no) = "" THEN RETURN

gsv_cd.gs_cd1 = This.GetitemString(row, "shop_type")
gsv_cd.gs_cd2 = is_yymmdd

OpenWithParm (W_SH101_P, "W_SH101_P 판매형태 내역") 
ls_yes = Message.StringParm 
IF ls_yes = 'YES' THEN 
	ll_curr_price = This.GetitemNumber(row, "curr_price")
	ll_sale_price    = ll_curr_price * (100 - gsv_cd.gl_cd1) / 100 
	gf_marjin_price(gs_shop_cd, ll_sale_price, gsv_cd.gdc_cd1, ll_collect_price) 
	This.Setitem(row, "sale_type",     gsv_cd.gs_cd3) 
	This.Setitem(row, "dc_rate",       gsv_cd.gl_cd1) 
	This.Setitem(row, "sale_rate",     gsv_cd.gdc_cd1) 
	This.Setitem(row, "sale_price",    ll_sale_price)
	This.Setitem(row, "collect_price", ll_collect_price)
	wf_amt_set(row, This.Object.sale_qty[row]) 
   ib_changed = true
   cb_update.enabled = true
	Parent.Trigger Event ue_tot_set()
END IF 

end event

event dw_body::buttonclicked;call super::buttonclicked;long i, ll_dc_rate, ll_chk =0, ii, ll_row
string ls_style,ls_modify
string ls_brand, ls_year, ls_season, ls_yymmdd
integer ii_choose

ls_yymmdd = string(dw_head.getitemdate(1,"yymmdd"),"yyyymmdd")

if dwo.name = 'cb_select'  then 	



  ii_choose = MessageBox("경고!", "닷컴매출로 일괄처리됩니다! 다시 한번 확인하세요!", Exclamation!, OKCancel!, 2)

	IF ii_choose = 1 THEN
	
	 ll_row = this.rowcount()
	
		if this.object.cb_select.text = "전체"  then 
			for ii = 1 to ll_row
				this.setitem(ii , "dotcom", "1")
			next	
		  ls_modify = 'cb_select.text= "해제"'
		  this.Modify(ls_modify)		
			
		else
			for ii = 1 to ll_row
				this.setitem(ii , "dotcom", "0")
			next	
		  ls_modify = 'cb_select.text= "전체"' 
		  this.Modify(ls_modify)		
					
			
		end if	
	
	ELSE
	    MessageBox("확인!", "취소되었습니다!")
	 
	END IF

 

	
	
	

end if


end event

type dw_print from w_com010_e`dw_print within w_sh144_e
end type

type cb_1 from commandbutton within w_sh144_e
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

type dw_list from datawindow within w_sh144_e
event ue_syscommand pbm_syscommand
integer x = 9
integer y = 256
integer width = 2866
integer height = 928
integer taborder = 110
boolean titlebar = true
string title = "판매일보조회"
string dataobject = "d_sh142_d10"
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

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')


end event

event doubleclicked;String ls_sale_no, ls_jumin, ls_coupon_no, ls_shop_type

IF row < 1 THEN RETURN

ls_sale_no   = This.GetitemString(row, "sale_no")
ls_shop_type = This.GetitemString(row, "sale_no")

dw_body.Retrieve(is_yymmdd, gs_shop_cd, ls_sale_no) 
dw_1.Retrieve(is_yymmdd, gs_shop_cd, "4", ls_sale_no) 
//Parent.Post Event ue_tot_set()
//dw_1.Setitem(1, "goods_amt", Long(dw_body.Describe("evaluate('sum(goods_amt)',0)")))

//IF isnull(ls_jumin) = FALSE AND Trim(ls_jumin) <> "" THEN
//   wf_member_set('1', ls_jumin)
//	dw_1.Setitem(1, "coupon_no", ls_coupon_no)
//ELSE
//   Setnull(ls_jumin)
//   dw_1.SetItem(1, "card_no",      ls_jumin)
//   dw_1.SetItem(1, "user_name",    ls_jumin)
//   dw_1.SetItem(1, "jumin",        ls_jumin)
//   dw_1.Setitem(1, "total_point",  0)
//   dw_1.Setitem(1, "give_point",   0)
//   dw_1.Setitem(1, "accept_point", 0)
//	dw_1.Setitem(1, "age_grp", This.GetitemString(row, "age_grp"))
//	
//END IF
//


dw_body.visible = TRUE 
dw_1.visible    = TRUE 
dw_list.visible = FALSE

end event

type st_1 from statictext within w_sh144_e
boolean visible = false
integer x = 2217
integer y = 176
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_sh144_e
boolean visible = false
integer x = 2839
integer y = 1332
integer width = 41
integer height = 36
integer taborder = 40
boolean bringtotop = true
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_sh144_e
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

type dw_3 from datawindow within w_sh144_e
boolean visible = false
integer x = 23
integer y = 1400
integer width = 2853
integer height = 384
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh133_d03"
boolean border = false
boolean livescroll = true
end type

event doubleclicked;dw_2.visible = true
dw_3.visible = false
end event

type dw_2 from datawindow within w_sh144_e
integer x = 23
integer y = 1400
integer width = 2853
integer height = 88
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh133_d03"
boolean border = false
boolean livescroll = true
end type

event doubleclicked;dw_2.visible = false
dw_3.visible = true
end event

type st_2 from statictext within w_sh144_e
integer x = 718
integer y = 168
integer width = 1906
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
boolean focusrectangle = false
end type

type dw_4 from datawindow within w_sh144_e
event type long ue_item_change ( long row,  dwobject dwo,  string data )
event type boolean wf_member_set ( string as_flag,  string as_find )
integer x = 9
integer y = 1184
integer width = 2894
integer height = 160
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh133_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long ue_item_change(long row, dwobject dwo, string data);string  ls_coupon_no, ls_secure_no
decimal ld_goods_amt, ll_sale_qty, ll_sale_amt
long    i, ll_row_count
string ls_user_name, ls_jumin, ls_card_no, ls_tel_no3,  ls_crm_grp
decimal  id_remain_point, ll_total_point, ll_give_point, ll_accept_point
			 

IF dw_4.AcceptText() <> 1 THEN RETURN 1

CHOOSE CASE dwo.name
	CASE "card_no" 
		SELECT user_name,       jumin,          card_no,
				 total_point * 10,     give_point * 10,     accept_point * 10, tel_no3,
				 total_point * 10 - isnull(accept_point,0) * 10,
				 
		(select top 1 case 
				case isnull(:gs_brand,'')
					when 'N' then n_score
					when 'O' then o_score
					when 'W' then w_score
					else b_score
				end
			when 'A' then '최우수고객'
			when 'B' then '우수고객'
			else 	      '일반고객'
			end 
			from tb_71010_crm (nolock)
			where jumin = a.jumin)	as crm_grp
			
		  INTO :ls_user_name,   :ls_jumin,      :ls_card_no,  
				 :ll_total_point, :ll_give_point, :ll_accept_point, :ls_tel_no3, 
				 :id_remain_point,
				 :ls_crm_grp
		  FROM TB_71010_M  a(nolock)  
		 WHERE card_no   = '4870090' + :data ; 
		
	CASE "jumin" 
		SELECT user_name,       jumin,          card_no,
				 total_point * 10,     give_point * 10,     accept_point * 10, tel_no3,
				 total_point * 10 - isnull(accept_point,0) * 10,
				 
		(select top 1 case 
				case isnull(:gs_brand,'')
					when 'N' then n_score
					when 'O' then o_score
					when 'W' then w_score
					else b_score
				end
			when 'A' then '최우수고객'
			when 'B' then '우수고객'
			else 	      '일반고객'
			end 
			from tb_71010_crm (nolock)
			where jumin = a.jumin)	as crm_grp
			
		  INTO :ls_user_name,   :ls_jumin,      :ls_card_no,  
				 :ll_total_point, :ll_give_point, :ll_accept_point, :ls_tel_no3, 
				 :id_remain_point,
				 :ls_crm_grp
		  FROM TB_71010_M  a(nolock)  
		 WHERE jumin   = :data ; 
		
	CASE "tel_no3" 
		SELECT user_name,       jumin,          card_no,
				 total_point * 10,     give_point * 10,     accept_point * 10, tel_no3,
				 total_point * 10 - isnull(accept_point,0) * 10,
				 
		(select top 1 case 
				case isnull(:gs_brand,'')
					when 'N' then n_score
					when 'O' then o_score
					when 'W' then w_score
					else b_score
				end
			when 'A' then '최우수고객'
			when 'B' then '우수고객'
			else 	      '일반고객'
			end 
			from tb_71010_crm (nolock)
			where jumin = a.jumin)	as crm_grp
			
		  INTO :ls_user_name,   :ls_jumin,      :ls_card_no,  
				 :ll_total_point, :ll_give_point, :ll_accept_point, :ls_tel_no3, 
				 :id_remain_point,
				 :ls_crm_grp
		  FROM TB_71010_M  a(nolock)  
		 WHERE tel_no3 = :data;
	
END CHOOSE 
this.setitem(1,"card_no",RightA(ls_card_no,9))
this.setitem(1,"jumin",ls_jumin)
this.setitem(1,"user_name",ls_user_name)
this.setitem(1,"crm_grp",ls_crm_grp)
this.setitem(1,"tel_no3",ls_tel_no3)


end event

event constructor;DataWindowChild ldw_child

This.GetChild("age_grp", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("403")
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

post event ue_item_change(row, dwo, data)

end event

