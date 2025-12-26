$PBExportHeader$w_sh130_e.srw
$PBExportComments$호텔행사판매
forward
global type w_sh130_e from w_com010_e
end type
type dw_1 from datawindow within w_sh130_e
end type
type cb_1 from commandbutton within w_sh130_e
end type
type dw_list from datawindow within w_sh130_e
end type
type dw_2 from datawindow within w_sh130_e
end type
type dw_3 from datawindow within w_sh130_e
end type
type st_1 from statictext within w_sh130_e
end type
type dw_21 from datawindow within w_sh130_e
end type
type dw_20 from datawindow within w_sh130_e
end type
type gb_1 from groupbox within w_sh130_e
end type
type dw_cosmetic from datawindow within w_sh130_e
end type
end forward

global type w_sh130_e from w_com010_e
integer width = 2990
integer height = 2032
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
event ue_tot_set ( )
event ue_total_retrieve ( )
dw_1 dw_1
cb_1 cb_1
dw_list dw_list
dw_2 dw_2
dw_3 dw_3
st_1 st_1
dw_21 dw_21
dw_20 dw_20
gb_1 gb_1
dw_cosmetic dw_cosmetic
end type
global w_sh130_e w_sh130_e

type variables
DataWindowChild idw_pay_way, idw_card_gubn
datawindowchild idw_shop_cd, idw_sale_type, idw_shop_type, idw_event_id

String is_yymmdd, is_sale_no, is_coupon_yn
string is_set_style_chk 
decimal idc_dc_rate_org

end variables

forward prototypes
public subroutine wf_amt_set (long al_row, long al_sale_qty)
public function boolean wf_goods_chk (long al_goods_amt)
public function boolean wf_empnm (string as_data, ref string as_empno, ref string as_empnm)
public subroutine wf_goods_amt_clear ()
public function boolean wf_member_set (string as_flag, string as_find)
public subroutine wf_amt_reset (long al_row)
public function boolean wf_style_set (long al_row, string as_style)
public function boolean wf_style_chk (long al_row, string as_style_no)
public function boolean wf_set_cosmetic (string as_set_style_chk)
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

ll_row = dw_2.Retrieve(is_yymmdd, gs_shop_cd)
dw_2.ShareData(dw_3)
IF ll_row < 1 THEN
	dw_2.insertRow(0) 
END IF 
end event

public subroutine wf_amt_set (long al_row, long al_sale_qty);/* 각 단가 및 판매량에 따른 금액 처리 */
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

public function boolean wf_empnm (string as_data, ref string as_empno, ref string as_empnm);string ls_empno, ls_empnm
integer li_cnt

    SELECT top 1 Kname, empno
	  into :As_empnm, :as_empno
      FROM VI_93000_1 (nolock)
     WHERE ( EmpNo = :as_data or Kname like :as_data + '%')
	  and   goout_gubn = '1'	
	   and (empno not like 'G4%' or empno = 'G40401') ;

   SELECT count(kname)
	   into :li_cnt
      FROM VI_93000_1 (nolock)
     WHERE ( EmpNo = :as_data or Kname like :as_data + '%')	  
	  and   goout_gubn = '1'
  	   and (empno not like 'G4%' or empno = 'G40401') ;
		  
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

public function boolean wf_style_set (long al_row, string as_style);Long    ll_dc_rate     
Long    ll_curr_price,  ll_out_price
Long    ll_sale_price,  ll_collect_price ,ll_tag_price
String  ls_shop_type,   ls_sale_type = space(2), ls_shop_cd, ls_color
decimal ldc_out_marjin, ldc_sale_marjin

/* 정상, 기획 */
ls_shop_type = dw_body.GetitemString(al_row, "shop_type")
ls_color = dw_body.GetitemString(al_row, "color")

ls_shop_type = "4"

ls_shop_cd =MidA(as_style, 1,1) + "X3300"


//if is_yymmdd <= "20170915" then
	/* 출고시 마진율 체크 */
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
//	/* 출고시 마진율 체크 */
	IF gf_out_marjin_color (is_yymmdd,    ls_shop_cd,     ls_shop_type, as_style, ls_color, & 
							ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
		RETURN False 
	END IF
	/* 판매 마진율 체크 */
	IF gf_sale_marjin_color (is_yymmdd,   ls_shop_cd,      ls_shop_type, as_style, ls_color, & 
							 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 
		RETURN False 
	END IF
//end if	

if is_coupon_yn = "Y" then
	ll_tag_price = dw_body.GetitemNumber(al_row, "tag_price")
	
	IF ls_sale_type = "41" then 
		ll_sale_price    = ll_tag_price * (100 - 50) / 100 
		gf_marjin_price(ls_shop_cd, ll_tag_price, 50, ll_collect_price) 
		dw_body.Setitem(al_row, "dc_rate",       50)		
	elseIF ls_sale_type = "42" then 
		ll_sale_price    = ll_tag_price * (100 - 60) / 100 
		gf_marjin_price(ls_shop_cd, ll_tag_price, 60, ll_collect_price) 
		dw_body.Setitem(al_row, "dc_rate",       60)				
	elseIF ls_sale_type = "44" then 
		ll_sale_price    = ll_tag_price * (100 - 70) / 100 
		gf_marjin_price(ls_shop_cd, ll_tag_price, 70, ll_collect_price) 
		dw_body.Setitem(al_row, "dc_rate",       70)		
	elseIF ls_sale_type = "45" then 
		ll_sale_price    = ll_tag_price * (100 - 90) / 100 
		gf_marjin_price(ls_shop_cd, ll_tag_price, 90, ll_collect_price) 
		dw_body.Setitem(al_row, "dc_rate",       90)				
	elseIF ls_sale_type = "46" then 
	elseIF ls_sale_type = "47" then 
		ll_sale_price    = ll_tag_price * (100 - 85) / 100 
		gf_marjin_price(ls_shop_cd, ll_tag_price, 85, ll_collect_price) 
		dw_body.Setitem(al_row, "dc_rate",       85)						
	elseIF ls_sale_type = "48" then 
		ll_sale_price    = ll_tag_price * (100 - 40) / 100 
		gf_marjin_price(ls_shop_cd, ll_tag_price, 40, ll_collect_price) 
		dw_body.Setitem(al_row, "dc_rate",       40)						
	elseIF ls_sale_type = "49" then 
		ll_sale_price    = ll_tag_price * (100 - 30) / 100 
		gf_marjin_price(ls_shop_cd, ll_tag_price, 80, ll_collect_price) 		
		dw_body.Setitem(al_row, "dc_rate",       30)
		
	else				
		ll_sale_price    = ll_tag_price * (100 - 80) / 100 
		gf_marjin_price(ls_shop_cd, ll_tag_price, 80, ll_collect_price) 		
		dw_body.Setitem(al_row, "dc_rate",       80)
	end if	
	
	dw_body.Setitem(al_row, "sale_type",  ls_sale_type)
	dw_body.Setitem(al_row, "sale_qty",   1)	
	dw_body.Setitem(al_row, "curr_price",    ll_curr_price)
	dw_body.Setitem(al_row, "sale_price",    ll_sale_price)
	dw_body.Setitem(al_row, "out_rate",      ldc_out_marjin)
	dw_body.Setitem(al_row, "out_price",     ll_out_price)
	dw_body.Setitem(al_row, "sale_rate",     ldc_sale_marjin)
	dw_body.Setitem(al_row, "collect_price", ll_collect_price)
else
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
end if
/* 금액 처리 */
wf_amt_set(al_row, 1)

RETURN True
end function

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_size, ls_shop_type, ls_given_fg, ls_given_ymd
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn  
Long   ll_tag_price , ll_cnt, ll_cnt1

IF LenA(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)

Select brand,     year,     season,     
       sojae,     item,     tag_price,     plan_yn   
  into :ls_brand, :ls_year, :ls_season, 
       :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
  from vi_12024_1 with (nolock)
 where style = :ls_style 
	and chno  = :ls_chno
	and color = :ls_color 
	and size  = :ls_size;


IF SQLCA.SQLCODE <> 0 THEN 
	Return False 
END IF


//Select shop_type
//into :ls_shop_type
//From tb_56012_d with (nolock)
//Where style      = :ls_style 
//  and start_ymd <= :is_yymmdd
//  and end_ymd   >= :is_yymmdd
//  and shop_cd    = case when substring(:ls_style,1,1) = 'N' then 'NX3300' 
//								when substring(:ls_style,1,1) = 'O' then 'OX3300'
//								when substring(:ls_style,1,1) = 'W' then 'WX3300'
//								when substring(:ls_style,1,1) = 'M' then 'MX3300'
//								when substring(:ls_style,1,1) = 'T' then 'TX3300'
//								when substring(:ls_style,1,1) = 'C' then 'TX3300'
//								when substring(:ls_style,1,1) = 'E' then 'EX3300'
//							else 'XXXXXX' end ;
//
//if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
//	ls_shop_type = "1"
//end if	
//
//if ls_shop_type < "4"  then 
//	messagebox("경고!", "행사 판매등록이 불가능한 제품입니다!")
//	return false
//end if	

ls_shop_type = "4"


		
		Select count(*)
		into :ll_cnt
		From tb_56012_d_color with (nolock)
		Where style      = :ls_style 
		and color        = :ls_color	
		and shop_type    = :ls_shop_type		
		and shop_cd    = substring(:ls_style,1,1) + 'X3300'
		and start_ymd <= :is_yymmdd
		and end_ymd   >= :is_yymmdd;
		
		
		if isnull(ll_cnt) or ll_cnt = 0 then
			Select count(*)
			into :ll_cnt
			From tb_56012_d with (nolock)
			Where style      = :ls_style 
			and shop_type    = :ls_shop_type
			and shop_cd    = substring(:ls_style,1,1) + 'X3300'			
			and start_ymd <= :is_yymmdd
			and end_ymd   >= :is_yymmdd;
		end if



		select count(a.shop_cd)
		into :ll_cnt1
		From tb_56011_d a with (nolock), tb_12020_m b (nolock)
		where a.shop_cd like substring(:ls_style,1,1) + 'X3300'
		and   b.style     =  :ls_style 
		and   a.year      = b.year
		and   a.season    = b.season 
		and   a.brand     = b.brand
		and   a.start_ymd <= :is_yymmdd
		and   a.end_ymd   >= :is_yymmdd;

		if ll_cnt + ll_cnt1 <= 0 then 
			messagebox("경고!", "판매등록이 불가능한 제품입니다!")
			return false					
		end if		

dw_body.SetItem(al_row, "tag_price", ll_tag_price) 
dw_body.Setitem(al_row, "shop_type", ls_shop_type)

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
//	wf_style_set(al_row, ls_style) 
ELSE
	Return False
END IF

Return True

end function

public function boolean wf_set_cosmetic (string as_set_style_chk);Long    ll_dc_rate     
Long    ll_curr_price,  ll_out_price
Long    ll_sale_price,  ll_collect_price , ll_row_count, ll_sale_qty, ll_get_row
String  ls_shop_type,   ls_sale_type = space(2), ls_plan_yn, ls_shop_cd, ls_sale_type_c
decimal ldc_out_marjin, ldc_sale_marjin, ll_sale_rate, ld_sale_price, ld_sale_price_c, ld_tag_price_c
long al_row, al_qty, ll_row_cnt
long ll_style_qty
int i, j
string ls_shop_cd_chk, ls_date, ls_style, ls_chno, ls_color, ls_size, ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_style_no

ls_date = string(dw_head.getitemdate(1,'yymmdd'),'YYYYMMDD')

dw_20.accepttext()
dw_20.visible = false

ll_sale_qty = dw_20.getitemnumber(1,'sale_qty')

select shop_cd
into :ls_shop_cd_chk
from tb_56012_d_cosmetic with (nolock)
where set_style = :as_set_style_chk;


dw_cosmetic.reset()
dw_cosmetic.retrieve(ls_shop_cd_chk, is_set_style_chk, ls_date)

ll_row_count = dw_cosmetic.rowcount()

if dw_body.getrow() = 1 and dw_body.getitemstring(1,'style_no') = is_set_style_chk then
	ll_get_row = 1
	dw_body.reset()
	ll_row_count = dw_cosmetic.rowcount()
else 
	ll_get_row = dw_body.getrow()
	ll_row_count = dw_cosmetic.rowcount() + ll_get_row -1
	dw_body.deleterow(ll_get_row)
	dw_body.insertrow(0)
end if


j = 0

for i=ll_get_row to ll_row_count 
//for i=ll_get_row to 1
	j = 1 + j
	
	dw_body.insertrow(0)
	//코스메틱 세트 마진율 가져오기
	ls_shop_type = dw_cosmetic.getitemstring(j,'shop_type')
	ls_style_no = dw_cosmetic.getitemstring(j,'style_no')
	ls_style = dw_cosmetic.getitemstring(j, "style")
	ls_chno = dw_cosmetic.getitemstring(j, "chno")
	ls_color = dw_cosmetic.getitemstring(j, "color")
	ls_size = dw_cosmetic.getitemstring(j, "size")
	ls_shop_type = "4" // dw_cosmetic.getitemstring(j, "shop_type")
	ls_sale_type_c = "4A" //dw_cosmetic.getitemstring(j, "sale_type")	
	ld_sale_price_c = dw_cosmetic.getitemnumber(j, "Sale_Price")
	ld_tag_price_c = dw_cosmetic.getitemnumber(j, "tag_Price")
	ls_shop_cd = MidA(ls_style,1,1) + 'X3300'

   if ls_date <= "20170915" then

		// 출고시 마진율 체크 (출고시에는 닷컴마진율이 아닌 백화점 마진으로 나가기)	
		IF gf_out_marjin (ls_date,    gs_shop_cd,     ls_shop_type , ls_style, & 
								ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
			RETURN False 
		END IF
	
		// 판매 마진율 체크 닷컴이 아닐때. 	
		IF gf_sale_marjin (ls_date,    gs_shop_cd,      ls_shop_type, ls_style, & 
								 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 		
			return false
		end if

   else 	
			// 출고시 마진율 체크 (출고시에는 닷컴마진율이 아닌 백화점 마진으로 나가기)	
		IF gf_out_marjin_color (ls_date,    ls_shop_cd,     ls_shop_type , ls_style, ls_color,& 
								ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
			RETURN False 
		END IF
	
		// 판매 마진율 체크 닷컴이 아닐때. 	
		IF gf_sale_marjin_color (ls_date,    ls_shop_cd,      ls_shop_type, ls_style, ls_color, & 
								 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 		
			return false
		end if

   end if	 
	
	ls_sale_type = dw_cosmetic.getitemstring(j, "sale_type")		
	ls_brand = dw_cosmetic.getitemstring(j, "brand")
	ls_year = dw_cosmetic.getitemstring(j, "year")
	ls_season = dw_cosmetic.getitemstring(j, "season")
	ls_sojae = dw_cosmetic.getitemstring(j, "sojae")
	ls_item = dw_cosmetic.getitemstring(j, "item")

   dw_body.SetItem(i, "style_no",		ls_style_no)
   dw_body.SetItem(i, "style",			ls_style)
	dw_body.SetItem(i, "chno",				ls_chno)
	dw_body.SetItem(i, "color",			ls_color)
	dw_body.SetItem(i, "size",				ls_size)
	dw_body.SetItem(i, "shop_type",		ls_shop_type)
	dw_body.SetItem(i, "sale_type",		ls_sale_type_c)

	dw_body.Setitem(i, "dc_rate_org",	ll_dc_rate)

	dw_body.Setitem(i, "sale_qty",		ll_sale_qty)
	dw_body.Setitem(i, "tag_price",		ld_tag_price_c)
//재매입금액 안나오게 	
//	dw_body.Setitem(i, "curr_price",    ld_sale_price_c)
//재매입금액 나오게 
	dw_body.Setitem(i, "curr_price",    ll_curr_price)
	dw_body.Setitem(i, "dc_rate",       0)
	dw_body.Setitem(i, "sale_price",    ld_sale_price_c)
	dw_body.Setitem(i, "out_rate",      ldc_out_marjin)
	dw_body.Setitem(i, "out_price",     ll_out_price)
	dw_body.Setitem(i, "sale_rate",     ldc_sale_marjin)
	dw_body.Setitem(i, "collect_price", ll_collect_price)
	
	dw_body.SetItem(i, "brand",    ls_brand)
	dw_body.SetItem(i, "year",     ls_year)
	dw_body.SetItem(i, "season",   ls_season)
	dw_body.SetItem(i, "sojae",    ls_sojae)
	dw_body.SetItem(i, "item",     ls_item)

	dw_body.SetItem(i, "goods_amt", 0)
	dw_body.SetItem(i, "give_rate", 0)
	dw_body.SetItem(i, "coupon_no", "")
	dw_body.SetItem(i, "phone_no", "")
	dw_body.SetItem(i, "visiter", "")	
	dw_body.SetItem(i, "set_style", is_set_style_chk)
	idc_dc_rate_org = ll_dc_rate	

	al_row = i 
	al_qty =	ll_sale_qty
	/* 금액 처리 */
	wf_amt_set(al_row, al_qty)
next


	// 다음컬럼으로 이동 
	ll_row_cnt = dw_body.RowCount()
	IF al_row = ll_row_cnt THEN 
		ll_row_cnt = dw_body.insertRow(0)
	END IF

	This.Post Event ue_tot_set()

	RETURN True
//else
//	RETURN false
//end if
end function

on w_sh130_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.dw_list=create dw_list
this.dw_2=create dw_2
this.dw_3=create dw_3
this.st_1=create st_1
this.dw_21=create dw_21
this.dw_20=create dw_20
this.gb_1=create gb_1
this.dw_cosmetic=create dw_cosmetic
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.dw_3
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.dw_21
this.Control[iCurrent+8]=this.dw_20
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.dw_cosmetic
end on

on w_sh130_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.dw_list)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.st_1)
destroy(this.dw_21)
destroy(this.dw_20)
destroy(this.gb_1)
destroy(this.dw_cosmetic)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(cb_1, "FixedToRight")
inv_resize.of_Register(st_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_1, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_2, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_3, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(gb_1, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight&Bottom")


dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

dw_1.insertRow(0)

dw_cosmetic.SetTransObject(SQLCA)
dw_21.SetTransObject(SQLCA)
dw_20.SetTransObject(SQLCA)
dw_20.insertRow(0)


//코인코즈 압구정직영점만 해당됨 20130416.
//지나미 가로수길 추가 20131014
if gs_shop_cd = '1X3300' or gs_shop_cd = '2X3300' or gs_shop_cd = '3X3300' or gs_shop_cd = '4X3300' or gs_shop_cd = '5X3300' or gs_shop_cd = '6X3300' then
	cb_print.visible = true
else
	cb_print.visible = false
end if


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size, ls_shop_type, ls_given_fg, ls_given_ymd, ls_emp_nm
String     ls_empno, ls_qry,ls_cust_cd, ls_cust_nm, ls_year, ls_season
Long       ll_row_cnt ,ll_inte_amt, ll_cnt,ll_cnt1, ll_cnt2
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
 				gst_cd.default_where   = "WHERE brand like '%'" // + gs_brand + "'"// and year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20032' and sojae <> 'C' "				
//			end if	 
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
				
				
				dw_body.Setitem(al_row, "shop_type", '4')
				
				ls_style = lds_Source.GetItemString(1,"style")
				ls_color = lds_Source.GetItemString(1,"color")				
				ls_year  = lds_Source.GetItemString(1,"year")
				ls_season = lds_Source.GetItemString(1,"season")				
				
				
//				Select shop_type
//				into :ls_shop_type
//				From tb_56012_d with (nolock)
//				Where style      = :ls_style 
//				  and start_ymd <= :is_yymmdd
//				  and end_ymd   >= :is_yymmdd
//				  and shop_cd    = case when substring(:ls_style,1,1) = 'N' then 'NX3300' 
//												when substring(:ls_style,1,1) = 'O' then 'OX3300'
//												when substring(:ls_style,1,1) = 'W' then 'WX3300'
//												when substring(:ls_style,1,1) = 'C' then 'CX3300'
//												when substring(:ls_style,1,1) = 'T' then 'TX3300'
//												when substring(:ls_style,1,1) = 'M' then 'MX3300'
//												when substring(:ls_style,1,1) = 'E' then 'EX3300'
//											else 'XXXXXX' end ;
//												
//				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
//					ls_shop_type = "1"
//				end if	
//				
//				if ls_shop_type < "4" then 
//					messagebox("경고!", "정상 판매등록이 불가능한 제품입니다!")
//					ib_itemchanged = FALSE
//					return 1					
//				end if	


			Select count(*)
				into :ll_cnt2
				From tb_56012_d_color with (nolock)
				Where style      = :ls_style 
				  and color      = :ls_color
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and shop_cd    = substring(:ls_style,1,1) + 'X3300' ;
				  


				Select count(*)
				into :ll_cnt
				From tb_56012_d with (nolock)
				Where style      = :ls_style 
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and shop_cd    = substring(:ls_style,1,1) + 'X3300' ;
				  

				  select count(a.shop_cd)
	  				into :ll_cnt1
					From tb_56011_d a with (nolock), tb_12020_m b (nolock)
					where a.shop_cd like substring(:ls_style,1,1) + 'X3300'
					and   b.style     =  :ls_style 
					and   a.year      = b.year
					and   a.season    = b.season 
					and   a.brand     = b.brand
					and   a.start_ymd <= :is_yymmdd
					and   a.end_ymd   >= :is_yymmdd;

				  
												
				if ll_cnt + ll_cnt1 + ll_cnt2 <= 0 then 
					messagebox("경고!", "판매등록이 불가능한 제품입니다!")
					ib_itemchanged = FALSE
					return 1					
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
					wf_style_set(al_row, ls_style) 
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
			
	CASE "empno1"		
			IF ai_div = 1 THEN 	
			IF wf_empnm(as_data, ls_empno, ls_emp_nm) = true THEN
			   	dw_1.SetItem(1, "emp_nm", ls_emp_nm) 
			   	dw_1.SetItem(1, "empno",  ls_empno) 					
			   	dw_1.SetItem(1, "empno1", ls_empno) 										
					RETURN 0 
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
//			if gs_shop_div = "G" then
// 				gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20032' "
//			else	 
 				gst_cd.default_where   = "WHERE goout_gubn = '1' and dept_code not in ('5a00','7a00','ka00') and (empno not like 'G4%' or empno = 'G40401')" 
//			end if	

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (empno like '" + as_data + "%' or kname like '" + as_data + "%') and goout_gubn = '1' and dept_code not in ('5a00','7a00','ka00') and (empno not like 'G4%' or empno = 'G40401')"
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
				
				dw_1.SetItem(al_row, "emp_nm", lds_Source.GetItemString(1,"kname")) 
				dw_1.SetItem(al_row, "empno", lds_Source.GetItemString(1,"empno")) 				
				dw_1.SetItem(al_row, "cust_cd1", "") 				
				dw_1.SetItem(al_row, "cust_cd", "") 								
				dw_1.SetItem(al_row, "cust_nm", "") 								
				
				   ib_changed = true
               cb_update.enabled = true
		
				   dw_body.SetColumn("cust_cd1")
				//   This.Post Event ue_tot_set()
			      lb_check = TRUE 
				ib_itemchanged = FALSE
			END IF
			Destroy  lds_Source			
			

	CASE "cust_cd1"							// 거래처 코드
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF gf_cust_nm(as_data, 'S', ls_cust_nm) <> 100 THEN
					 If RightA(as_data, 4) < '5000' or RightA(as_data, 4) > '9999' Then
						MessageBox("입력오류","협력업체 코드가 아닙니다!")
						else	
						dw_1.SetItem(al_row, "cust_cd", as_data)				
						dw_1.SetItem(al_row, "cust_nm", ls_cust_nm)
						return 0
   					End If
				else
					MessageBox("입력오류","등록되지 않은 거래처 코드입니다!")					
				END IF
			end if	
					
						// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "거래처 코드 검색" 
				gst_cd.datawindow_nm   = "d_com911" 
				gst_cd.default_where   = " WHERE Cust_Code Between '5000' And '9999' and change_gubn = '00' "
				IF Trim(as_data) <> "" THEN
//					gst_cd.Item_where = " CustCode LIKE ~'" + as_data + "%~' "
					gst_cd.Item_where = " CustCode LIKE ~'" + as_data + "%~' or Cust_sName like '%" + as_data + "%' "					
				ELSE
					gst_cd.Item_where = ""
				END IF

				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm
					dw_1.SetRow(al_row)
					dw_1.SetColumn(as_column)
					dw_1.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"CustCode"))
					dw_1.SetItem(al_row, "cust_cd1", lds_Source.GetItemString(1,"CustCode"))					
					dw_1.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"Cust_sName"))

					dw_1.SetItem(al_row, "empno1", "")
					dw_1.SetItem(al_row, "empno", "")					
					dw_1.SetItem(al_row, "emp_nm", "")

					/* 다음컬럼으로 이동 */
					dw_1.SetColumn("card_gubn")
					ib_itemchanged = False
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

is_yymmdd  = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"판매일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if


is_sale_no = dw_head.GetitemString(1, "sale_no")
is_coupon_yn = "N" // dw_head.GetitemString(1, "coupon_yn")

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
         cb_print.enabled = true
         cb_preview.enabled = true			
         dw_1.Enabled = true
			dw_body.Enabled = true
         dw_body.SetFocus()
      end if
      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false			
      end if
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false			
		//	if dw_head.Enabled then
			dw_body.Enabled = true
		//	end if
		end if
	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true			
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
		end if
   CASE 5    /* 조건 */
      cb_delete.enabled = false
      cb_update.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false		
      ib_changed = false
      dw_body.Enabled = false
		dw_head.enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
   CASE 6		/* 입력 */
      if al_rows > 0 then
         cb_delete.enabled = True
         dw_1.Enabled = true
			dw_head.enabled = false
			dw_body.Enabled = true			
         dw_body.SetFocus()
      end if
      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
			cb_print.enabled = true
			cb_preview.enabled = true				
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
long     i, ll_row_count, ll_chk, ll_cash_amt, ll_card_amt, ll_sale_amt
decimal	ldc_dc_rate, ld_goods_amt
datetime ld_datetime 
int     li_point_seq	
String   ls_shop_type, ls_sale_type, ls_shop_cd, ls_card_gubn, ls_pay_way, ls_empno, ls_cust_cd, ls_chk

IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_1.AcceptText()    <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

//IF NOT isnull(dw_1.Object.JUMIN[1]) AND isnull(dw_1.Object.age_grp[1]) THEN
//	MessageBox("경고", "연령층 이나 회원정보를 등록하십시오 !") 
//	Return 0 
//END IF
ll_row_count = dw_body.RowCount()

ls_card_gubn = dw_1.getitemstring(1, "card_gubn")
ls_pay_way = dw_1.getitemstring(1, "pay_way")
ll_cash_amt = dw_1.getitemNumber(1, "cash_amt")
ll_card_amt = dw_1.getitemNumber(1, "card_amt")
ll_sale_amt = dw_1.getitemNumber(1, "sale_amt")
ls_empno 	= dw_1.getitemString(1, "empno")
ls_cust_cd 	= dw_1.getitemString(1, "cust_cd")


//	if is_coupon_yn = "Y" then
//		  if (len(trim(ls_empno)) < 6  or isnull(ls_empno) ) and ( len(trim(ls_cust_cd)) < 6  or isnull(ls_cust_cd)) then
//			MessageBox("경고!","쿠폰에 거래처나 사번을 확인해주세요!")
//			dw_1.SetFocus()
//			dw_1.SetColumn("empno")
//			return -1			
//   		end if	
//	end if		

//	if is_coupon_yn = "N" and len(trim(ls_empno)) > 5  then
//			MessageBox("경고!","쿠폰 적용을 확인해주세요 !")
//			dw_1.SetFocus()
//			dw_1.SetColumn("empno")
//			return -1
//	end if		



	if ls_pay_way > "1" and ls_card_gubn = "00" then
			MessageBox("경고!","결제 카드의 종류를 입력해 주세요!")
			dw_1.SetFocus()
			dw_1.SetColumn("card_gubn")
			return -1
	end if			
	
	if ll_row_count = 0 and (ll_sale_amt = 0  or  isnull(ll_sale_amt)) then
			MessageBox("경고!","판매내역이 없습니다!")
			dw_body.SetFocus()
			dw_body.SetColumn("style_no")
			return -1
	end if	

	if ls_pay_way = "1" and ll_sale_amt <> ll_cash_amt then
			MessageBox("경고!","결제금액과 판매금액을 확인해주세요!")
			dw_1.SetFocus()
			dw_1.SetColumn("cash_amt")
			return -1
	elseif  ls_pay_way = "2" and ll_sale_amt <> ll_card_amt then
			MessageBox("경고!","결제금액과 판매금액을 확인해주세요!")
			dw_1.SetFocus()
			dw_1.SetColumn("card_amt")
			return -1		
  elseif	ls_pay_way = "3" and ll_sale_amt <> ll_card_amt + ll_cash_amt then
			MessageBox("경고!","결제금액과 판매금액을 확인해주세요!")
			dw_1.SetFocus()
			dw_1.SetColumn("card_amt")
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
	 select right(isnull(max(SALE_NO), 0) + 10001, 4)
	  into :is_sale_no 
	  from tb_53010_h (nolock)
	 where yymmdd    = :is_yymmdd 
		and shop_cd   like '_X3300%'
		and shop_type = '4';
END IF



///* point 판매 처리 및 가능여부 체크 (정상판매단가가  Point금액 이상 매출만 가능)*/
//ll_goods_amt = dw_1.GetitemNumber(1, "goods_amt")  // point금액 

//IF isnull(ll_goods_amt) THEN ll_goods_amt = 0 
//	ls_card_no   = dw_1.GetitemString(1, "card_no")
//IF isnull(ls_card_no) = FALSE AND len(ls_card_no) = 9 THEN
//	ls_card_no = '1128003' + ls_card_no 
//ELSE
//	Setnull(ls_card_no)
//END IF


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	ls_style = dw_body.getitemstring(i, "style")
	
	ls_shop_cd = MidA(ls_style,1,1) + "X3300"
	
   IF idw_status = NewModified! THEN			/* New Record */  
      dw_body.Setitem(i, "no",  String(i, "0000"))
      dw_body.Setitem(i, "yymmdd", is_yymmdd)
      dw_body.Setitem(i, "shop_cd",  ls_shop_cd)
      dw_body.Setitem(i, "shop_div", "X")
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
	END IF
	
	ls_shop_type = dw_body.getitemstring(i, "shop_type")
	ls_sale_type = dw_body.getitemstring(i, "sale_type")	
	ldc_dc_rate  = dw_body.getitemnumber(i, "dc_rate")	

NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
//------------------------
	
	ll_row_count = dw_1.RowCount()
	FOR i=1 TO ll_row_count
   idw_status = dw_1.GetItemStatus(i, 0, Primary!)
	
   IF idw_status = NewModified! THEN				
		/* New Record */
      dw_1.Setitem(i, "yymmdd", is_yymmdd)				
      dw_1.Setitem(i, "shop_cd", gs_shop_cd)						
      dw_1.Setitem(i, "shop_type", "4")						
      dw_1.Setitem(i, "sale_no", is_sale_no)										
      dw_1.Setitem(i, "cash_amt", ll_cash_amt)												
      dw_1.Setitem(i, "card_amt", ll_card_amt)			
      dw_1.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_1.Setitem(i, "cash_amt", ll_cash_amt)												
      dw_1.Setitem(i, "card_amt", ll_card_amt)			
      dw_1.Setitem(i, "mod_id", gs_user_id)
      dw_1.Setitem(i, "mod_dt", ld_datetime)
   END IF
 NEXT	
 	il_rows = dw_1.Update(TRUE, FALSE)
	if il_rows = 1 then
   	dw_1.ResetUpdate()
	   commit  USING SQLCA;
		
	else
		 rollback  USING SQLCA;
	end if		
	
//------------------------
	cb_1.SetFocus()
else
   rollback  USING SQLCA;
end if

//-----------------------------------
Post Event ue_tot_set()

if gs_shop_cd = '1X3300' or gs_shop_cd = '2X3300' or gs_shop_cd = '3X3300' or gs_shop_cd = '4X3300' or gs_shop_cd = '5X3300' or gs_shop_cd = '6X3300' then
	integer Net
	Net = MessageBox("영수증출력", "영수증을 출력 하시겠습니까?", Exclamation!, OKCancel!, 2)
	
	IF Net = 1 THEN 
		cb_print.TriggerEvent(Clicked!)
	END IF
end if
//-----------------------------------

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

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_yymmdd, ls_sale_no, ls_pay_way

ls_sale_no   = dw_body.GetitemString(1, "sale_no")

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pay_way.Text = '" + idw_pay_way.GetItemString(idw_pay_way.GetRow(), "inter_display") + "'" + &
				"t_yymmdd.Text = '" + is_yymmdd + "'" + &
				"t_sale_no.Text = '" + ls_sale_no + "'"

dw_print.Modify(ls_modify)


end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

string ls_yymmdd, ls_sale_no, ls_shop_cd, ls_add1
double li_mid
int li_rcnt, ll_cnt

ls_yymmdd  = dw_body.getitemstring(1,'yymmdd')
ls_shop_cd = dw_body.getitemstring(1,'shop_cd')
ls_sale_no = dw_body.getitemstring(1,'sale_no')

dw_print.accepttext()
dw_print.reset()
dw_print.retrieve(ls_yymmdd, ls_shop_cd, ls_sale_no, gs_shop_cd)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
//	dw_print.object.p_1.filename = gs_brand + '_logo_1.bmp'	
//	dw_print.object.p_3.filename = gs_brand + '_logo_2.bmp'
//	dw_print.object.p_4.filename = gs_brand + '_qr_1.bmp'

	dw_print.object.p_1.filename = 'S_logo_1.bmp'	
	

	dw_print.object.t_1.text = '215-81-36619'
	dw_print.object.t_3.text = '(주)보끄레머천다이징'

	
	dw_print.object.t_gubn.text = '[ 고객용 ]'
	dw_print.Print()
	dw_print.object.t_gubn.text = '[ 본사용 ]'
	dw_print.Print()
END IF

dw_print.object.t_gubn.text   = ''

This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_sh130_e
boolean visible = false
integer x = 389
end type

type cb_delete from w_com010_e`cb_delete within w_sh130_e
integer x = 1029
integer width = 256
integer taborder = 70
end type

type cb_insert from w_com010_e`cb_insert within w_sh130_e
integer x = 795
integer width = 238
integer taborder = 60
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh130_e
integer x = 2469
integer width = 384
integer taborder = 110
string text = "일보조회(&Q)"
end type

type cb_update from w_com010_e`cb_update within w_sh130_e
integer taborder = 50
end type

type cb_print from w_com010_e`cb_print within w_sh130_e
integer x = 1650
integer width = 439
integer taborder = 80
string text = "영수증출력(&P)"
end type

type cb_preview from w_com010_e`cb_preview within w_sh130_e
integer x = 1303
integer taborder = 90
end type

type gb_button from w_com010_e`gb_button within w_sh130_e
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh130_e
integer y = 152
integer width = 2843
integer height = 96
string dataobject = "d_sh130_h01"
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
//      IF GF_IWOLDATE_CHK(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN
//			MessageBox("일자변경", "소급할수 없는 일자입니다.")
//			Return 1
//		END IF

	

END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_sh130_e
integer beginy = 256
integer endy = 256
end type

type ln_2 from w_com010_e`ln_2 within w_sh130_e
integer beginy = 260
integer endy = 260
end type

type dw_body from w_com010_e`dw_body within w_sh130_e
event ue_set_column ( long al_row )
integer x = 9
integer y = 256
integer width = 2871
integer height = 1236
string dataobject = "d_sh130_d01"
boolean hscrollbar = true
end type

event dw_body::ue_set_column(long al_row);/* 품번 키보드 및 스캐너 입력시 다음 line으로 이동 */

dw_body.SetRow(al_row + 1)  
dw_body.SetColumn("style_no")

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

event dw_body::doubleclicked;call super::doubleclicked;String ls_style_no, ls_yes , ls_shop_type, ls_shop_cd, ls_brand
Long   ll_curr_price, ll_sale_price, ll_collect_price, ll_tag_price

IF row < 1 THEN RETURN 
ls_style_no = This.GetitemString(row, "style_no")
ls_brand    = This.GetitemString(row, "brand")

ls_shop_cd = MidA(ls_style_no, 1,1) + "X3300"


IF isnull(ls_style_no) or Trim(ls_style_no) = "" THEN RETURN

ls_shop_type  = This.GetitemString(row, "shop_type")
gsv_cd.gs_cd1 = This.GetitemString(row, "shop_type")
gsv_cd.gs_cd2 = is_yymmdd
gsv_cd.gs_cd3 = ls_shop_cd
gsv_cd.gs_cd4 = ls_brand

OpenWithParm (W_SH130_P, "W_SH130_P 판매형태 내역") 
ls_yes = Message.StringParm 
IF ls_yes = 'YES' THEN 
	ll_curr_price = This.GetitemNumber(row, "curr_price")
	ll_tag_price = This.GetitemNumber(row, "tag_price")
	ll_sale_price    = ll_tag_price * (100 - gsv_cd.gl_cd1) / 100 
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

event dw_body::itemchanged;call super::itemchanged;integer li_ret
string ls_card_no, ls_set_style, ls_shop_cd_chk, ls_set_style_chk, ls_style_chk
integer Net
long ll_cnt, ll_rows

CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
	//	IF ib_itemchanged THEN RETURN 1
//		li_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
		
			dw_body.accepttext()
			//대상매장 및 Set스타일 찾기			
			is_set_style_chk = ''
			ls_set_style = dw_body.getitemstring(row,'style_no')
			ls_set_style = MidA(ls_set_style,1,10)
			
			select set_style
			into :is_set_style_chk
			from tb_56012_d_cosmetic with (nolock)
			where set_style = :ls_set_style;

			if isnull(is_set_style_chk) then 
				is_set_style_chk = '' 
			end if
			
			if MidA(ls_set_style,1,1) = 'G' or gs_shop_cd = 'tb1004' then
				if is_set_style_chk <> '' then 
					Net = MessageBox('확인','세트상품 판매수량이 2세트 이상입니까?', Exclamation!, YesNo!,2)
					IF Net = 1 THEN 				
						dw_20.visible = true
						/* 다음컬럼으로 이동 */
						dw_20.setrow(1)
						dw_20.SetColumn("sale_qty")
					ELSE
						dw_20.setitem(1,'sale_qty',1)
						wf_set_cosmetic(is_set_style_chk)
					END IF
					
					ll_cnt = dw_body.rowcount() -1
//					dw_body.insertrow(0)
					This.Post Event ue_set_column(ll_cnt)
				end if
			end if

	 		
			
				if MidA(ls_set_style,1,1)  = 'D' or gs_shop_cd = 'tb1004' then
					
					  	ls_set_style = this.getitemstring(row,'style_no')
						ls_set_style = MidA(ls_set_style,1,8)
			
						select distinct set_style
						into :is_set_style_chk
						from tb_56012_d_set with (nolock)
						where style = :ls_set_style
						and   :gs_shop_cd  like  shop_cd
						and   shop_type = "4"
						and   :is_yymmdd between start_ymd and end_ymd;
			
						if isnull(is_set_style_chk) then 
							is_set_style_chk = '' 
						end if
					
					if is_set_style_chk <> '' then 
						if messagebox("확인","세트판매 해당 상품입니다. 단품판매시 할인 적용이 안됩니다. 세트판매처리 하시겠습니까?",Exclamation!,YesNoCancel!,1 ) = 1 then
							ll_rows = dw_21.retrieve(gs_shop_cd, ls_set_style, is_yymmdd)
							if ll_rows > 0 then
								dw_21.visible = true
							end if	
						else 

							is_set_style_chk = ''
						end if	
					END IF

				end if
			

			
//		IF ib_itemchanged THEN RETURN 1
		if is_set_style_chk = ''  then
			dw_body.SetItem(row, "goods_amt", 0)
			dw_body.SetItem(row, "give_rate", 0)
			dw_body.SetItem(row, "coupon_no", "")
			dw_body.SetItem(row, "phone_no", "")
			dw_body.SetItem(row, "visiter", "")
			li_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		end if
		
		
		
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

type dw_print from w_com010_e`dw_print within w_sh130_e
integer x = 987
integer y = 328
integer width = 1595
integer height = 1008
string dataobject = "d_sh130_p01"
end type

event dw_print::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("color", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

end event

type dw_1 from datawindow within w_sh130_e
event ue_keydown pbm_dwnkey
event type long ue_item_changed ( long row,  dwobject dwo,  string data )
integer x = 9
integer y = 1488
integer width = 2894
integer height = 300
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh130_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
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

event constructor;DataWindowChild ldw_child
String   ls_filter_str = ''	

This.GetChild("pay_way", idw_pay_way)
idw_pay_way.SetTransObject(SQLCA)
idw_pay_way.Retrieve("041")

//ls_filter_str = "inter_cd = '1' " 
//idw_pay_way.SetFilter(ls_filter_str)
//idw_pay_way.Filter( )

This.GetChild("card_gubn", idw_card_gubn)
idw_card_gubn.SetTransObject(SQLCA)
idw_card_gubn.Retrieve("042")


ls_filter_str = ''	
ls_filter_str = "inter_cd in ('00','01','03','04','06','11','12','14') " 
idw_card_gubn.SetFilter(ls_filter_str)
idw_card_gubn.Filter( )





This.GetChild("card_gubn", idw_card_gubn)
idw_card_gubn.SetTransObject(SQLCA)
idw_card_gubn.Retrieve("042")



ls_filter_str = "inter_cd in ('00','01','03','04','06','11','12','14') " 
idw_card_gubn.SetFilter(ls_filter_str)
idw_card_gubn.Filter( )



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

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
String ls_null , ls_coupon_no
Long   ll_give_point, ll_accept_point, li_ret
decimal ld_goods_amt, ld_sale_amt

IF dw_body.RowCount() > 0 THEN 
	IF dw_body.GetitemStatus(1, 0, Primary!) <> New! THEN 
      ib_changed = true
      cb_update.enabled = true
	END IF
END IF

CHOOSE CASE dwo.name
	CASE "empno1"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if isnull(data) = false then 
//			dw_1.setitem(row, "cust_cd1", "")
//			dw_1.setitem(row, "cust_cd", "")
//			dw_1.setitem(row, "cust_nm", "")				
			dw_1.setitem(row, "empno1", "")
			dw_1.setitem(row, "empno", "")
			dw_1.setitem(row, "emp_nm", "")	
		end if			
		li_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "cust_cd1"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if isnull(data) = false then 
//			dw_1.setitem(row, "empno1", "")
//			dw_1.setitem(row, "empno", "")
//			dw_1.setitem(row, "emp_nm", "")		
			dw_1.setitem(row, "cust_cd1", "")
			dw_1.setitem(row, "cust_cd", "")
			dw_1.setitem(row, "cust_nm", "")				
		end if			
		li_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
		
	CASE "pay_way"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		ld_sale_amt = dw_1.getitemnumber(row, "sale_amt")
		if data = "1" then 
			dw_1.setitem(row, "card_amt", 0)
			dw_1.setitem(row, "cash_amt", ld_sale_amt)
		elseif data = "2" then 	
			dw_1.setitem(row, "card_amt", ld_sale_amt)
			dw_1.setitem(row, "cash_amt", 0)		
		else	
			dw_1.setitem(row, "card_amt", ld_sale_amt)
			dw_1.setitem(row, "cash_amt", 0)		
		end if	

	CASE "card_amt"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		ld_sale_amt = dw_1.getitemnumber(row, "sale_amt")
		dw_1.setitem(row, "cash_amt", ld_sale_amt - dec(data))
			
	CASE "cash_amt"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		ld_sale_amt = dw_1.getitemnumber(row, "sale_amt")

		dw_1.setitem(row, "card_amt", ld_sale_amt - dec(data))

			
END CHOOSE

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

event buttonclicked;string ls_column_nm, ls_column_value, ls_report

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

type cb_1 from commandbutton within w_sh130_e
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

type dw_list from datawindow within w_sh130_e
event ue_syscommand pbm_syscommand
integer x = 9
integer y = 256
integer width = 2894
integer height = 1128
integer taborder = 110
boolean titlebar = true
string title = "판매일보조회"
string dataobject = "d_sh130_d10"
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
cb_print.enabled = true
cb_preview.enabled = true	

end event

type dw_2 from datawindow within w_sh130_e
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

type dw_3 from datawindow within w_sh130_e
boolean visible = false
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

type st_1 from statictext within w_sh130_e
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

type dw_21 from datawindow within w_sh130_e
boolean visible = false
integer x = 1248
integer y = 268
integer width = 1623
integer height = 1540
integer taborder = 90
boolean bringtotop = true
boolean titlebar = true
string title = "세트판매"
string dataobject = "d_sh101_d08"
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

event buttonclicked;Long    ll_dc_rate     
Long    ll_curr_price,  ll_out_price
Long    ll_sale_price,  ll_collect_price , ll_row_count, ll_sale_qty, ll_get_row
String  ls_shop_type,   ls_sale_type = space(2), ls_plan_yn, ls_shop_cd, ls_chk_yn, ls_set_type
decimal ldc_out_marjin, ldc_sale_marjin, ll_sale_rate, ld_sale_price, ld_sale_price_c, ld_tag_price_c
long al_row, al_qty, ll_row_cnt,ll_row
long ll_style_qty
int i, j, li_sel_cnt 
string ls_shop_cd_chk, ls_date, ls_style, ls_chno, ls_color, ls_size, ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_style_no

choose case dwo.name
	case "cb_select"

ls_date = string(dw_head.getitemdate(1,'yymmdd'),'YYYYMMDD')

dw_21.accepttext()


ll_row_count = dw_21.rowcount()
li_sel_cnt = 0
for j = 1 to ll_row_count 

	ls_set_type = dw_21.getitemstring(j,'set_type')
	ls_chk_yn = dw_21.getitemstring(j,'sel_yn')
	if ls_chk_yn = "Y" then
		li_sel_cnt = li_sel_cnt + 1
	end if	

next

if ls_set_type = "SP01" and  li_sel_cnt <> 2 then
	messagebox("경고!", "해당 품번은  1 + 1 상품입니다. 선택 수량이 다릅니다!")
	RETURN 1 
end if 	
	

if dw_body.getrow() = 1 then
	ll_get_row = 1
	dw_body.reset()

else 
	ll_get_row = dw_body.getrow()
	dw_body.deleterow(ll_get_row)
end if

j = 0
for j = 1 to ll_row_count 


	ls_chk_yn = dw_21.getitemstring(j,'sel_yn')
	ls_shop_type = dw_21.getitemstring(j,'shop_type')
	ls_style = dw_21.getitemstring(j, "style")
	ls_chno = dw_21.getitemstring(j, "chno")
	ls_color = dw_21.getitemstring(j, "color")
	ls_size = dw_21.getitemstring(j, "size")
	ls_shop_type = dw_21.getitemstring(j, "shop_type")
	ld_sale_price_c = dw_21.getitemnumber(j, "Sale_Price")
	ld_tag_price_c = dw_21.getitemnumber(j, "tag_Price")
	ls_style_no = ls_style + ls_chno + ls_color + ls_size				
	if ls_chk_yn = "Y" then		
				
				
							// 출고시 마진율 체크 (출고시에는 닷컴마진율이 아닌 백화점 마진으로 나가기)	
						IF gf_out_marjin_color (ls_date,    gs_shop_cd,     ls_shop_type , ls_style, ls_color,& 
												ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
							RETURN 1 
						END IF
					
						// 판매 마진율 체크 닷컴이 아닐때. 	
						IF gf_sale_marjin_color (ls_date,    gs_shop_cd,      ls_shop_type, ls_style, ls_color, & 
												 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 		
							return 1
						end if
				
				
					
					ls_sale_type = dw_21.getitemstring(j, "sale_type")		
					ls_brand = dw_21.getitemstring(j, "brand")
					ls_year = dw_21.getitemstring(j, "year")
					ls_season = dw_21.getitemstring(j, "season")
					ls_sojae = dw_21.getitemstring(j, "sojae")
					ls_item = dw_21.getitemstring(j, "item")
				
					ll_row = dw_body.insertrow(0)
				
					dw_body.SetItem(ll_row, "style_no",		ls_style_no)
					dw_body.SetItem(ll_row, "style",			ls_style)
					dw_body.SetItem(ll_row, "chno",				ls_chno)
					dw_body.SetItem(ll_row, "color",			ls_color)
					dw_body.SetItem(ll_row, "size",				ls_size)
					dw_body.SetItem(ll_row, "shop_type",		ls_shop_type)
					dw_body.SetItem(ll_row, "sale_type",		ls_sale_type)
				
					dw_body.Setitem(ll_row, "dc_rate_org",	ll_dc_rate)
				
					dw_body.Setitem(ll_row, "sale_qty",		1)
					dw_body.Setitem(ll_row, "tag_price",		ld_tag_price_c)
				//재매입금액 안나오게 	
				//	dw_body.Setitem(i, "curr_price",    ld_sale_price_c)
				//재매입금액 나오게 
					dw_body.Setitem(ll_row, "curr_price",    ll_curr_price)
					dw_body.Setitem(ll_row, "dc_rate",       0)
					dw_body.Setitem(ll_row, "sale_price",    ld_sale_price_c)
					dw_body.Setitem(ll_row, "out_rate",      ldc_out_marjin)
					dw_body.Setitem(ll_row, "out_price",     ll_out_price)
					dw_body.Setitem(ll_row, "sale_rate",     ldc_sale_marjin)
					dw_body.Setitem(ll_row, "collect_price", ll_collect_price)
					
					dw_body.SetItem(ll_row, "brand",    ls_brand)
					dw_body.SetItem(ll_row, "year",     ls_year)
					dw_body.SetItem(ll_row, "season",   ls_season)
					dw_body.SetItem(ll_row, "sojae",    ls_sojae)
					dw_body.SetItem(ll_row, "item",     ls_item)
				
					dw_body.SetItem(ll_row, "goods_amt", 0)
					dw_body.SetItem(ll_row, "give_rate", 0)
					dw_body.SetItem(ll_row, "coupon_no", "")
					dw_body.SetItem(ll_row, "phone_no", "")
					dw_body.SetItem(ll_row, "visiter", "")	
					dw_body.SetItem(ll_row, "set_style", is_set_style_chk)
					idc_dc_rate_org = ll_dc_rate	
				
					al_row = ll_row 
					al_qty =	ll_sale_qty
					/* 금액 처리 */
					wf_amt_set(al_row, al_qty)
	end if

next

	dw_21.visible = false
	// 다음컬럼으로 이동 
	ll_row_cnt = dw_body.RowCount()
	IF al_row = ll_row_cnt THEN 
		ll_row_cnt = dw_body.insertRow(0)
	END IF

	parent.Post Event ue_tot_set()

	RETURN 0
	

case "cb_exit"	
		dw_21.visible = false
		dw_21.reset()
		messagebox("알림!", "해당 상품을 다시 입력해주세요!")
		ll_get_row = dw_body.getrow()
		dw_body.deleterow(ll_get_row)
		ll_row = dw_body.insertRow(0)
			
	/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
		if ll_row > 0 then
			dw_body.ScrollToRow(ll_row)
			dw_body.SetColumn("style_no")
			dw_body.SetFocus()
		end if
		
end choose	
	
//else
//	RETURN false
//end if
end event

type dw_20 from datawindow within w_sh130_e
boolean visible = false
integer x = 1504
integer y = 364
integer width = 667
integer height = 288
integer taborder = 90
boolean bringtotop = true
boolean titlebar = true
string title = "세트수량을 입력하세요!"
string dataobject = "d_sh101_d39"
boolean border = false
boolean livescroll = true
end type

event buttonclicked;IF dwo.name = "b_update" THEN 
	wf_set_cosmetic(is_set_style_chk)
	dw_20.visible = false
end if

IF dwo.name = "b_close" THEN 
	dw_20.visible = false
end if
end event

type gb_1 from groupbox within w_sh130_e
boolean visible = false
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

type dw_cosmetic from datawindow within w_sh130_e
boolean visible = false
integer x = 283
integer y = 372
integer width = 1477
integer height = 700
integer taborder = 30
string title = "none"
string dataobject = "d_sh101_d38"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

