$PBExportHeader$w_53100_e.srw
$PBExportComments$매장 판매 반품요청 승인
forward
global type w_53100_e from w_com010_e
end type
type st_1 from statictext within w_53100_e
end type
type cb_input from commandbutton within w_53100_e
end type
type st_2 from statictext within w_53100_e
end type
type dw_list from datawindow within w_53100_e
end type
end forward

global type w_53100_e from w_com010_e
integer width = 3680
integer height = 2360
event ue_input ( )
event ue_tot_set ( )
st_1 st_1
cb_input cb_input
st_2 st_2
dw_list dw_list
end type
global w_53100_e w_53100_e

type variables
DataWindowChild idw_color, idw_size
String is_brand, is_fr_yymmdd, is_to_yymmdd, is_shop_cd, is_shop_type, is_data_opt, is_member_return,is_style, is_chno, is_yymmdd, is_empty_gubn
string is_org_yymmdd, is_org_sale_no, is_org_no, chk_iud
end variables

forward prototypes
public function integer wf_yes_no (string as_title)
public function boolean wf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name)
public subroutine wf_goods_amt_clear ()
public subroutine wf_goods_chk3 ()
public subroutine wf_amt_set3 (long al_row)
public subroutine wf_amt_set_row ()
public function boolean wf_style_set (long al_row, string as_style)
public subroutine wf_amt_set (long al_row, long al_sale_qty, long al_sale_price)
public subroutine wf_line_chk (long al_row)
public subroutine wf_amt_clear ()
public function boolean wf_style_set_color (long al_row, string as_style, string as_color)
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

event ue_input();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
dw_list.Visible   = False
dw_body.Visible   = True
//dw_member.Visible = True

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
if is_shop_type = "%" then
   MessageBox("입력","정확한 매장형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   Return 
end if

dw_body.Reset()
il_rows = dw_body.insertRow(0)
//dw_member.Reset()
//dw_member.insertRow(0)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(6, il_rows)

//IF is_shop_type = '1' or is_shop_type = '3'  THEN
//	dw_member.Enabled = TRUE
//ELSE
//	dw_member.Enabled = FALSE 
//END IF 
end event

event ue_tot_set();Long ll_sale_qty, ll_sale_amt

ll_sale_qty = Long(dw_body.Describe("evaluate('sum(sale_qty)',0)"))
ll_sale_amt = Long(dw_body.Describe("evaluate('sum(sale_amt)',0)"))

//dw_member.Setitem(1, "sale_qty", ll_sale_qty)
//dw_member.Setitem(1, "sale_amt", ll_sale_amt)

Return

end event

public function integer wf_yes_no (string as_title);/*=================================================================*/
/* 작 성 자 : 지우정보                                             */	
/* 내    용 : 수정 자료 저장여부 확인                              */
/*=================================================================*/

RETURN  MessageBox(as_title,'쿠폰을 사용하시겠습니까?', &
			          Question!, YesNo!)


end function

public function boolean wf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name);int li_cnt

	select jumin, user_name
		into :as_jumin, :as_user_name
	from tb_71010_m (nolock) 
	where tel_no3 = replace(:as_tel_no,'-','')
	  and isnull(card_no,'XXXXXXXXXX') <> 'XXXXXXXXXX' ;
	

	select count(jumin)
		into :li_cnt
	from tb_71010_m (nolock) 
	where tel_no3 = replace(:as_tel_no,'-','')
     and isnull(card_no,'XXXXXXXXXX') <> 'XXXXXXXXXX' ;

	if li_cnt <> 1 or isnull(as_jumin) or LenA(as_jumin) <> 13 then 
		return False
	else 
		return True
	end if
	
end function

public subroutine wf_goods_amt_clear ();long i , ll_row_count
string ls_ok_coupon, ls_coupon_no_tmp
decimal ld_coupon_rate, ld_dc_rate, ld_sale_price, ld_curr_price, ld_give_rate

ll_row_count = dw_body.rowcount()

FOR i=1 TO ll_row_count

	ld_coupon_rate = 0
	ld_dc_rate = 0
	ls_coupon_no_tmp = ""
	
	ls_coupon_no_tmp = dw_body.getitemstring(i,"coupon_no")
	ld_dc_rate = dw_body.getitemdecimal(i,"dc_rate")
	ld_give_rate = dw_body.getitemdecimal(i,"give_rate")
	ld_sale_price = dw_body.getitemdecimal(i,"sale_price")	
	ld_curr_price = dw_body.getitemdecimal(i,"curr_price")		
	
	//쿠폰넘버 존재시 할인율 쿠폰인지 체크 및 할인율가져오기
	if ls_coupon_no_tmp <> "" then
			
		select top 1 isnull(give_rate,0)
		 into :ld_coupon_rate
		from	tb_71011_h (nolock)
		where coupon_no  = :ls_coupon_no_tmp;
		
	end if

	dw_body.Setitem(i, "goods_amt", 0)
	dw_body.Setitem(i, "give_rate", 0)
	dw_body.Setitem(i, "coupon_no", '')
	
   //할인율 쿠폰일시 제품 할인율 및 가격 재산출
	if ld_coupon_rate <> 0 then 
		
		ld_dc_rate = ld_dc_rate - ld_coupon_rate
		ld_sale_price  = ld_curr_price * ((100 - ld_dc_rate)/100)
		
		dw_body.Setitem(i, "dc_rate", ld_dc_rate )		
		dw_body.Setitem(i, "sale_price", ld_sale_price )				
		
		Post Event ue_tot_set()		
	end if

	
NEXT

end subroutine

public subroutine wf_goods_chk3 ();
decimal ll_tot_real_amt, ll_sale_amt, ll_chk_sale_amt
long i, ll_row_count
string ls_dc_flag, ls_coupon_no, ls_style_no, ls_sale_type, ls_season


ls_dc_flag = "Y"
ll_chk_sale_amt = 0
ll_sale_amt = 0

ll_row_count = dw_body.RowCount()

for i=1 to ll_row_count
	ls_coupon_no	= dw_body.GetitemString(i, "coupon_no")	
	IF ls_coupon_no <> "" then 
		ls_dc_flag = "N"
	END IF
next

/*
4m  
판매형태 11  14 17 21

*/

for i=1 to ll_row_count

	ll_sale_amt = 0
	ls_style_no = ""
	ls_sale_type = ""
	ls_season = ""
	
	ls_style_no	= dw_body.GetitemString(i, "style_no")	
	ls_sale_type = dw_body.GetitemString(i, "sale_type")	
	ll_sale_amt = dw_body.GetitemDecimal(i, "sale_amt")		
	ls_season =  MidA(ls_style_no,3,2)
/*	
	if is_shop_cd = 'NG1078' or is_shop_cd = 'NG1127' then
		if ls_dc_flag = "Y" and ls_season="4M" and (ls_sale_type="11" or ls_sale_type="14" or ls_sale_type="17" or ls_sale_type="21") then
			ll_chk_sale_amt = ll_chk_sale_amt + ll_sale_amt
		end if
	elseif is_shop_cd = 'NG1082' then
		
		if ls_dc_flag = "Y" and (ls_season="4M" or ls_season="4A") and (ls_sale_type="11" or ls_sale_type="14" or ls_sale_type="17" or ls_sale_type="21") then
			ll_chk_sale_amt = ll_chk_sale_amt + ll_sale_amt
		end if
	end if
*/
		if ls_dc_flag = "Y" and (ls_season="4M" or ls_season="4A") and (ls_sale_type="11" or ls_sale_type="14" or ls_sale_type="17" or ls_sale_type="21") then
			ll_chk_sale_amt = ll_chk_sale_amt + ll_sale_amt
		end if
next


if ll_chk_sale_amt < 200000 then
	ls_dc_flag = "N"
end if



IF ls_dc_flag = "Y" then
	
	for i=1 to ll_row_count
	
		ll_sale_amt = 0
		ls_style_no = ""
		ls_sale_type = ""
		ls_season = ""
		
		ls_style_no	= dw_body.GetitemString(i, "style_no")	
		ls_sale_type = dw_body.GetitemString(i, "sale_type")	
		ll_sale_amt = dw_body.GetitemDecimal(i, "sale_amt")		
		
		ls_season =  MidA(ls_style_no,3,2)
   //여름
	/*
	if is_shop_cd = 'NG1078' or is_shop_cd = 'NG1127' then
		if ls_season="4M" and (ls_sale_type="11" or ls_sale_type="14" or ls_sale_type="17" or ls_sale_type="21") and ll_sale_amt > 10000 then
			dw_body.Setitem(i, "coupon_no", "N00007")  
			dw_body.Setitem(i, "goods_amt", 10000)			
			return
		end if
	*/
	
	//여름 + 가을
//	elseif is_shop_cd = 'NG1082' then
		
		if (ls_season="4M" or ls_season ="4A") and (ls_sale_type="11" or ls_sale_type="14" or ls_sale_type="17" or ls_sale_type="21") and ll_sale_amt > 10000 then
			dw_body.Setitem(i, "coupon_no", "N00007")  
			dw_body.Setitem(i, "goods_amt", 10000)			
			return			
		end if

//	end if

	next
	
END IF







end subroutine

public subroutine wf_amt_set3 (long al_row);/* 회원 즉시할인 +5% 적용 금액 처리 */
Decimal ld_tag_price, ld_curr_price, ld_sale_price, ld_dc_rate,ld_tot_real_amt,ld_sale_qty, ld_sale_amt
String ls_sale_type
	
	ld_tag_price     = dw_body.GetitemDecimal(al_row, "tag_price") 
	ld_tot_real_amt    = dw_body.GetitemDecimal(al_row, "tot_real_amt") 
	ld_sale_price    = dw_body.GetitemDecimal(al_row, "sale_price") 
	ld_curr_price	  = dw_body.GetitemDecimal(al_row, "curr_price") 
	ld_sale_qty	  = dw_body.GetitemDecimal(al_row, "sale_qty") 
	ld_sale_amt	  = dw_body.GetitemDecimal(al_row, "sale_amt") 	
	ld_dc_rate       = dw_body.GetitemDecimal(al_row, "dc_rate") 
	ls_sale_type     = dw_body.GetitemString(al_row, "sale_type") 


 
	if (ld_tag_price = ld_sale_price and MidA(ls_sale_type,1,1) = '1') or (MidA(ls_sale_type,1,1) = '1' and  ld_dc_rate <= 10 ) then

		ld_dc_rate = ld_dc_rate + 5	
		ld_sale_price = ld_curr_price * ((100 - ld_dc_rate)/100)
		
		dw_body.SetItem(al_row, "dc_rate", ld_dc_rate)
		dw_body.SetItem(al_row, "sale_price", ld_sale_price)		
		dw_body.SetItem(al_row, "sale_amt", ld_sale_price*ld_sale_qty)				
		dw_body.SetItem(al_row, "mem_dc_yn", "Y")
		
//		dw_member.SetItem(al_row, "sale_amt", ld_sale_price*ld_sale_qty)
		This.Trigger Event ue_tot_set()
	end if

	
		

end subroutine

public subroutine wf_amt_set_row ();/* 회원 즉시할인 +5% 적용 금액 처리 */
long i , ll_row_count
String ls_mem_dc_yn
String ls_sale_type
Decimal ld_tag_price, ld_curr_price, ld_sale_price, ld_dc_rate,ld_tot_real_amt, ld_sale_amt, ld_sale_qty

ll_row_count = dw_body.rowcount()


FOR i=1 TO ll_row_count	

	ld_tag_price     = dw_body.GetitemDecimal(i, "tag_price") 
	ld_curr_price    = dw_body.GetitemDecimal(i, "curr_price") 
	ld_sale_price    = dw_body.GetitemDecimal(i, "sale_price") 	
	ld_sale_amt    = dw_body.GetitemDecimal(i, "sale_amt") 		
	ld_dc_rate       = dw_body.GetitemDecimal(i, "dc_rate") 
	ld_sale_qty       = dw_body.GetitemDecimal(i, "sale_qty") 	
	ls_sale_type     = dw_body.GetitemString(i, "sale_type") 


	
	if (ld_tag_price = ld_sale_price and MidA(ls_sale_type,1,1) = '1') or (MidA(ls_sale_type,1,1) = '1' and  ld_dc_rate <= 10 ) then

		ld_dc_rate = ld_dc_rate + 5	
		ld_sale_price = ld_curr_price * ((100 - ld_dc_rate)/100)
		dw_body.SetItem(i, "dc_rate", ld_dc_rate)
		dw_body.SetItem(i, "sale_price", ld_sale_price)		
		dw_body.SetItem(i, "sale_amt", ld_sale_price*ld_sale_qty)				
		dw_body.SetItem(i, "mem_dc_yn", "Y")
		

		
	end if


	
NEXT

This.Trigger Event ue_tot_set()
//dw_member.SetItem(1, "sale_amt", ld_sale_price*ld_sale_qty)



end subroutine

public function boolean wf_style_set (long al_row, string as_style);Long    ll_dc_rate     
Long    ll_curr_price,  ll_out_price
Long    ll_sale_price,  ll_collect_price 
String  ls_sale_type = space(2)
decimal ldc_out_marjin, ldc_sale_marjin, ldc_dc_rate


is_yymmdd = dw_body.GetItemString(al_row,'yymmdd')

/* 출고시 마진율 체크 */
IF gf_out_marjin (is_yymmdd,    is_shop_cd,     is_shop_type, as_style, & 
                  ls_sale_type, ldc_out_marjin, ldc_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
	RETURN False 
END IF

/* 판매 마진율 체크 */
IF gf_sale_marjin (is_yymmdd,    is_shop_cd,      is_shop_type, as_style, & 
                   ls_sale_type, ldc_sale_marjin, ldc_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 
	RETURN False 
END IF

/* 판매 자료 등록 */
dw_body.Setitem(al_row, "sale_type",  ls_sale_type)
dw_body.Setitem(al_row, "sale_qty",   1)
dw_body.Setitem(al_row, "curr_price",    ll_curr_price)
dw_body.Setitem(al_row, "dc_rate",       ldc_dc_rate)
dw_body.Setitem(al_row, "sale_price",    ll_sale_price)
dw_body.Setitem(al_row, "out_rate",      ldc_out_marjin)
dw_body.Setitem(al_row, "out_price",     ll_out_price)
dw_body.Setitem(al_row, "sale_rate",     ldc_sale_marjin)
dw_body.Setitem(al_row, "collect_price", ll_collect_price)

/* 금액 처리 */
wf_amt_set(al_row, 1, ll_sale_price)

RETURN True
end function

public subroutine wf_amt_set (long al_row, long al_sale_qty, long al_sale_price);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_out_price, ll_collect_price
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect ,ll_sale_collect1
Decimal ldc_marjin
 
IF dw_body.AcceptText() <> 1 THEN RETURN

ll_tag_price     = dw_body.GetitemDecimal(al_row, "tag_price") 
ll_curr_price    = dw_body.GetitemDecimal(al_row, "curr_price") 
ll_out_price     = dw_body.GetitemNumber(al_row, "out_price") 
ll_collect_price = dw_body.GetitemNumber(al_row, "collect_price")

dw_body.Setitem(al_row, "tag_amt",  ll_tag_price  * al_sale_qty)
dw_body.Setitem(al_row, "curr_amt", ll_curr_price * al_sale_qty)
dw_body.Setitem(al_row, "sale_amt", al_sale_price * al_sale_qty)
dw_body.Setitem(al_row, "out_amt",  ll_out_price  * al_sale_qty) 

ll_goods_amt = dw_body.GetitemDecimal(al_row, "goods_amt") 

//	 IF ll_goods_amt > 0 THEN 
//		ldc_marjin = dw_body.GetitemDecimal(al_row, "sale_rate")
//
//			gf_marjin_price(is_shop_cd, (al_sale_price * al_sale_qty) - ll_goods_amt, ldc_marjin, ll_sale_collect)  
//	 ELSE
//		ll_sale_collect = ll_collect_price * al_sale_qty
//	 END IF
//	 dw_body.Setitem(al_row, "sale_collect", ll_sale_collect)
	 
IF ll_goods_amt > 0 THEN  
	ldc_marjin = dw_body.GetitemDecimal(al_row, "sale_rate")
	gf_marjin_price(is_shop_cd, (al_sale_price * al_sale_qty) - ll_goods_amt, ldc_marjin, ll_sale_collect1)
	//판매금액에 할인금액적용을 백화점과 대리점 별도로 계산된 내역 수정(요청:장나영차장 일자:20140702)
	if MidA(is_shop_cd,2,1) = "G" then 
		ll_sale_collect = ll_sale_collect1 //- (ll_goods_amt * ldc_marjin / 100)
	else
		ll_sale_collect = ll_sale_collect1
	end if	
ELSE
	ll_sale_collect = ll_collect_price * al_sale_qty  
END IF
	dw_body.Setitem(al_row, "sale_collect", ll_sale_collect) 	 
	 
	
	/* 세일 재매입 처리 */
	gf_marjin_price(is_shop_cd, (al_sale_price * al_sale_qty), ldc_marjin, ll_sale_collect)  						
	ll_io_amt = (ll_out_price  * al_sale_qty) - ll_sale_collect	
	dw_body.Setitem(al_row, "io_amt", ll_io_amt)
	dw_body.Setitem(al_row, "io_vat", ll_io_amt - Round(ll_io_amt / 1.1, 0))
//END IF
end subroutine

public subroutine wf_line_chk (long al_row);long ll_curr_amt, ll_out_amt, ll_sale_amt, ll_sale_collect, ll_io_amt, ll_io_vat, ll_goods_amt,ll_sale_collect1
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
//판매금액에 할인금액적용을 백화점과 대리점 별도로 계산된 내역 수정(요청:장나영차장 일자:20140702)
/*
	 if mid(is_shop_cd,2,1) = "G" then
		if abs(ll_sale_collect - round((ll_sale_amt - ll_goods_amt) * (100 - ldc_sale_rate)/100 - (ll_goods_amt * ldc_sale_rate/100) ,0)    ) > 3 then 
			ll_sale_collect = round((ll_sale_amt - ll_goods_amt) * (100 - ldc_sale_rate)/100  - (ll_goods_amt * ldc_sale_rate/100)  ,0) 
			dw_body.setitem(al_row,"sale_collect", ll_sale_collect)
		end if
		
		ll_sale_collect1 = round((ll_sale_amt) * (100 - ldc_sale_rate)/100,0)
		if ll_io_amt <> (ll_out_amt - ll_sale_collect1) then
			ll_io_amt  = ll_out_amt - ll_sale_collect1
			dw_body.setitem(al_row,"io_amt", ll_io_amt)
		end if
		
		
 	 else	
*/
			if abs(ll_sale_collect - round((ll_sale_amt - ll_goods_amt) * (100 - ldc_sale_rate)/100,0)) > 3 then 
			ll_sale_collect = round((ll_sale_amt - ll_goods_amt) * (100 - ldc_sale_rate)/100,0)
			dw_body.setitem(al_row,"sale_collect", ll_sale_collect)
			end if	

			if ll_io_amt <> (ll_out_amt - ll_sale_collect) then
			ll_io_amt  = ll_out_amt - ll_sale_collect
			dw_body.setitem(al_row,"io_amt", ll_io_amt)
			end if
			
//	 end if	
		

		
		if ll_io_vat <> (ll_io_amt - round(ll_io_amt/1.1,0) ) then
			ll_io_vat  = (ll_io_amt - round(ll_io_amt/1.1,0) )
			dw_body.setitem(al_row,"io_vat", ll_io_vat)
		end if




return


end subroutine

public subroutine wf_amt_clear ();/* 회원 즉시할인 +5% 적용 취소 금액 처리 */
long i , ll_row_count
String ls_mem_dc_yn
Decimal ld_dc_rate, ld_sale_price, ld_curr_price, ld_sale_qty, ld_sale_amt

ll_row_count = dw_body.rowcount()

FOR i=1 TO ll_row_count	

	ls_mem_dc_yn     = dw_body.GetitemString(i, "mem_dc_yn") 

	if ls_mem_dc_yn = "Y" then

		ld_dc_rate     = dw_body.GetitemDecimal(i, "dc_rate") 
		ld_sale_price    = dw_body.GetitemDecimal(i, "sale_price") 
		ld_curr_price	  = dw_body.GetitemDecimal(i, "curr_price") 
		ld_sale_qty	  = dw_body.GetitemDecimal(i, "sale_qty") 
		ld_sale_amt	  = dw_body.GetitemDecimal(i, "sale_amt") 		
		
		ld_dc_rate		= ld_dc_rate - 5
		ld_sale_price  = ld_curr_price * ((100 - ld_dc_rate)/100)
		

		dw_body.SetItem(i, "dc_rate", ld_dc_rate)
		dw_body.SetItem(i, "sale_price", ld_sale_price)		
		dw_body.SetItem(i, "sale_amt", ld_sale_price*ld_sale_qty)				
		dw_body.SetItem(i, "mem_dc_yn", "N")

	end if

	
NEXT

This.Trigger Event ue_tot_set()


end subroutine

public function boolean wf_style_set_color (long al_row, string as_style, string as_color);Long    ll_dc_rate     
Long    ll_curr_price,  ll_out_price
Long    ll_sale_price,  ll_collect_price 
String  ls_sale_type = space(2), ls_style, ls_color, ls_shop_type, ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_year, ls_season
decimal ldc_out_marjin, ldc_sale_marjin, ldc_dc_rate

ls_year   = dw_body.GetitemString(al_row , "year")
ls_season   = dw_body.GetitemString(al_row , "season")

	if is_shop_type = "4" then			
					
						Select shop_type
						into :ls_shop_type
						From tb_56012_d_color with (nolock)
						Where style      = :as_style 
						  and color      = :as_color
						  and start_ymd <= :is_yymmdd
						  and end_ymd   >= :is_yymmdd
						  and shop_cd    = :is_shop_cd ;
						  
				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then								  
						Select shop_type
						into :ls_shop_type
						From tb_56012_d with (nolock)
						Where style      = :as_style 
						  and start_ymd <= :is_yymmdd
						  and end_ymd   >= :is_yymmdd
						  and shop_cd    = :is_shop_cd ;						  
					END IF		  
						  

				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
						Select shop_type
						into :ls_shop_type
						From tb_56011_d with (nolock)
						Where start_ymd <= :is_yymmdd
						and end_ymd   >= :is_yymmdd
						and shop_cd    = :is_shop_cd
						and shop_type > '3'
						and year   = :ls_year 
						and season = :ls_season;			
					end if	 		  


			if MidA(is_shop_cd,3,4) = '2000' then
				ls_shop_type = '4'
			elseif MidA(is_shop_cd,3,4) = '3300' then
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
						
						if is_shop_type <> ls_shop_type then 
							messagebox("경고!", "제품판매가 가능한 매장형태는 " + ls_shop_type + " 입니다!")
							ib_itemchanged = FALSE
							return false
						end if	
						
	end if
				
				
				select isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX')
				into :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq
				from tb_12020_m with (nolock)
				where style like :as_style + '%';

				
				if ls_bujin_chk = "Y" then 
					messagebox("부진체크", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
				end if 	
				
				


/* 출고시 마진율 체크 */
IF gf_outmarjin_color (is_yymmdd,    is_shop_cd,     is_shop_type, as_style, as_color, & 
                  ls_sale_type, ldc_out_marjin, ldc_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
	RETURN False 
END IF

/* 판매 마진율 체크 */
IF gf_sale_marjin_color (is_yymmdd,    is_shop_cd,      is_shop_type, as_style, as_color, & 
                   ls_sale_type, ldc_sale_marjin, ldc_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 
	RETURN False 
END IF

/* 판매 자료 등록 */
dw_body.Setitem(al_row, "sale_type",  ls_sale_type)
dw_body.Setitem(al_row, "sale_qty",   1)
dw_body.Setitem(al_row, "curr_price",    ll_curr_price)
dw_body.Setitem(al_row, "dc_rate",       ldc_dc_rate)
dw_body.Setitem(al_row, "sale_price",    ll_sale_price)
dw_body.Setitem(al_row, "out_rate",      ldc_out_marjin)
dw_body.Setitem(al_row, "out_price",     ll_out_price)
dw_body.Setitem(al_row, "sale_rate",     ldc_sale_marjin)
dw_body.Setitem(al_row, "collect_price", ll_collect_price)

/* 금액 처리 */
wf_amt_set(al_row, 1, ll_sale_price)

RETURN True
end function

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.05.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_shop_type, ls_given_fg, ls_given_ymd
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn  
string  ls_bujin_chk, ls_dep_ymd, ls_dep_seq
Long   ll_tag_price,  ll_cnt 

IF al_row > 1 and LenA(as_style_no) <> 9 THEN
	gf_style_edit(dw_body.Object.style_no[al_row - 1], as_style_no, ls_style, ls_chno) 
   IF ls_chno = '%' THEN ls_chno = '0' 
ELSE 
	ls_style = LeftA(as_style_no, 8)
	ls_chno  = MidA(as_style_no, 9, 1)
END IF 

IF is_shop_type = '1' THEN 
	ls_plan_yn = 'N'
ELSEIF is_shop_type = '3' THEN 
	ls_plan_yn = 'Y'
ELSE
	ls_plan_yn = '%'
END IF

if is_shop_type  <> '9' then
	
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
		
else	
	
		Select count(style), 
			 min(style)  ,   min(chno), 
			 min(brand)  ,   min(year),     min(season),     
			 min(sojae)  ,   min(item),     min(tag_price)  
	  into :ll_cnt     , 
			 :ls_style   ,   :ls_chno, 
			 :ls_brand   ,   :ls_year,      :ls_season, 
			 :ls_sojae   ,   :ls_item,      :ll_tag_price
	  from vi_12020_1
	 where style   like :ls_style 
		and chno    =    :ls_chno
		and plan_yn like :ls_plan_yn
		and isnull(tag_price, 0) <> 0;
		
	end if		
	
IF SQLCA.SQLCODE <> 0 or ll_cnt < 1 THEN 
	Return False 
END IF 

IF ls_style  <> 'NC5AJ973' AND ls_style <> 'NC5AJ911' AND ls_style <> 'NC5AL911' AND ls_style <> 'NC5AJ910' AND ls_style <> 'NC5MB628' AND ls_style <> 'NC5AS910' AND ls_style <> 'NC5MB962' AND ls_style <> 'NC5MB964' AND ls_style <> 'NC5MJ965' AND ls_style <> 'NC5AJ913' AND ls_style <> 'NC5AL913' AND ls_style <> 'NC5AS913' AND ls_style <> 'NC5AJ915' AND ls_style <> 'NC5AL915' AND ls_style <> 'NC5AS915' THEN 				
	if is_shop_type <> '9' and ls_sojae = "C" and LeftA(ls_style,1) <> 'B' and LeftA(ls_style,1) <> 'D' and LeftA(ls_style,1) <> 'K'  and LeftA(ls_style,1) <> 'U'  then 
		messagebox("경고!", "중국수출 모델은 기타에서만 등록 가능합니다!")
		return false
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
		
//		if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
//						if is_shop_type = '3' then
//						 ls_shop_type = '3'
//						else 
//						 ls_shop_type = '1'	
//						end if 
//		end if	 
		
			if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
						Select shop_type
						into :ls_shop_type
						From tb_56011_d with (nolock)
						Where start_ymd <= :is_yymmdd
						and end_ymd   >= :is_yymmdd
						and shop_cd    = :is_shop_cd
						and shop_type > '3'
						and year   = :ls_year 
						and season = :ls_season;			
				end if	 		  
		
		
			if MidA(is_shop_cd,3,4) = '2000' then
				ls_shop_type = '4'
			elseif MidA(is_shop_cd,3,4) = '3300' then
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
		
		if is_shop_type <> ls_shop_type then 
			messagebox("경고!", "제품판매가 가능한 매장형태는 " + ls_shop_type + " 입니다!")
			return false
		end if	
end if

select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
into  :ls_given_fg, :ls_given_ymd
from tb_12020_m with (nolock)
where style = :ls_style;


if ls_given_fg = "Y" then 
	messagebox("품번체크", ls_given_ymd + "일자로 사은품 전환된 제품입니다!")
	if is_yymmdd >= ls_given_ymd then
		return false
	end if	
end if 	

select isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX')
into :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq
from tb_12020_m with (nolock)
where style like :ls_style + '%';

if ls_bujin_chk = "Y" then 
	messagebox("부진체크", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
end if 	

dw_body.SetItem(al_row, "tag_price", ll_tag_price) 
IF wf_style_set(al_row, ls_style) THEN 
   dw_body.SetItem(al_row, "style_no", ls_style + ls_chno)
   dw_body.SetItem(al_row, "style",    ls_style)
	dw_body.SetItem(al_row, "chno",     ls_chno)
	dw_body.SetItem(al_row, "brand",    ls_brand)
	dw_body.SetItem(al_row, "year",     ls_year)
	dw_body.SetItem(al_row, "season",   ls_season)
	dw_body.SetItem(al_row, "sojae",    ls_sojae)
	dw_body.SetItem(al_row, "item",     ls_item)
END IF

IF is_shop_type > '3' THEN
	dw_body.SetItem(al_row, "color",    '')
//	dw_body.SetItem(al_row, "color",    'XX')
	dw_body.SetItem(al_row, "size",     'XX')
ELSE
	dw_body.SetItem(al_row, "color",    '')
	dw_body.SetItem(al_row, "size",     '')
END IF 

Return True

end function

on w_53100_e.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_input=create cb_input
this.st_2=create st_2
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_input
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.dw_list
end on

on w_53100_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_input)
destroy(this.st_2)
destroy(this.dw_list)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
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

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   is_shop_cd = '%'
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

 
//if mid(is_shop_cd,1,1) <> is_brand then
//   MessageBox(ls_title,"브랜드와 매장코드가 일치 하지 않습니다!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
	is_style = "%"
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
	is_chno = "%"
end if

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")


is_empty_gubn = dw_head.GetItemString(1, "empty_gubn")
if IsNull(is_empty_gubn) or Trim(is_empty_gubn) = "" then
	is_empty_gubn = "%"
end if



return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_flag, ls_age_grp, ls_jumin , ls_given_fg, ls_given_ymd
String     ls_style,   ls_chno, ls_data , ls_sojae, ls_shop_type, ls_style_k
string     ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_year, ls_season, ls_tel_no, ls_color
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				if gs_brand <> 'K' then
					IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
						dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
						
						select tel_no
						into :ls_tel_no
						from tb_91100_m (nolock)
						where shop_cd = :as_data;
						
						dw_head.SetItem(al_row, "tel_no", ls_tel_no)					
							
						RETURN 0
					END IF 
				end if
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
				dw_head.SetItem(al_row, "tel_no", lds_Source.GetItemString(1,"tel_no"))				
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "style_no"		
			IF ai_div = 1 THEN 	
			   IF wf_style_chk(al_row, as_data)  THEN
               This.Post Event ue_tot_set()
				   RETURN 2 
				END IF
			END IF
			
			IF al_row > 1 and LenA(Trim(as_data)) <> 9 THEN 
				gf_style_edit(dw_body.Object.style_no[al_row - 1], as_data, ls_style, ls_chno)
			ELSE
		      ls_style = MidA(as_data, 1, 8)
		      ls_chno  = MidA(as_data, 9, 1)
//				
//				select isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX')
//				into :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq
//				from tb_12020_m with (nolock)
//				where style like :ls_style + '%';
//				
//				if ls_bujin_chk = "Y" then 
//				messagebox("부진체크", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
//				end if 					
			END IF
				
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com013" 
			gst_cd.default_where   = "WHERE brand = '" + is_brand + "' " + &
			                         "  AND isnull(tag_price, 0) <> 0 "
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
				ls_sojae = lds_Source.GetItemString(1,"sojae")				
				ls_year = lds_Source.GetItemString(1,"year")					
				ls_season = lds_Source.GetItemString(1,"season")					
				
			IF ls_style  <> 'NC5AJ973' AND ls_style <> 'NC5AJ911' AND ls_style <> 'NC5AL911' AND ls_style <> 'NC5AJ910' AND ls_style <> 'NC5MB628' AND ls_style <> 'NC5AS910' AND ls_style <> 'NC5MB962' AND ls_style <> 'NC5MB964' AND ls_style <> 'NC5MJ965' AND ls_style <> 'NC5AJ913' AND ls_style <> 'NC5AL913' AND ls_style <> 'NC5AS913' AND ls_style <> 'NC5AJ915' AND ls_style <> 'NC5AL915' AND ls_style <> 'NC5AS915' THEN 				
//				if is_shop_type <> '9' and ls_sojae = "C" then 
				if is_shop_type <> '9' and ls_sojae = "C" and LeftA(ls_style,1) <> 'B' and LeftA(ls_style,1) <> 'D' and LeftA(ls_style,1) <> 'K' and LeftA(ls_style,1) <> 'U' and LeftA(ls_style,1) <> 'L' and LeftA(ls_style,1) <> 'V' then 
					messagebox("경고!", "중국수출 모델은 기타에서만 등록 가능합니다!")
					ib_itemchanged = FALSE
					return 1
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
						  
//						if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
//							if is_shop_type = '3' then
//							 ls_shop_type = '3'
//							else 
//							 ls_shop_type = '1'	
//							end if 
//						end if	 

				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
						Select shop_type
						into :ls_shop_type
						From tb_56011_d with (nolock)
						Where start_ymd <= :is_yymmdd
						and end_ymd   >= :is_yymmdd
						and shop_cd    = :is_shop_cd
						and shop_type > '3'
						and year   = :ls_year 
						and season = :ls_season;			
					end if	 		  


			if MidA(is_shop_cd,3,4) = '2000' then
				ls_shop_type = '4'
			elseif MidA(is_shop_cd,3,4) = '3300' then
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
						
						if is_shop_type <> ls_shop_type then 
							messagebox("경고!", "제품판매가 가능한 매장형태는 " + ls_shop_type + " 입니다!")
							ib_itemchanged = FALSE
							return 1
						end if	
						
				end if
				
				
				select isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX'),
						 isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
				into :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq, :ls_given_fg, :ls_given_ymd
				from tb_12020_m with (nolock)
				where style like :ls_style + '%';
				
				if ls_bujin_chk = "Y" then 
				messagebox("부진체크", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
				end if 	
				
//				IF ls_given_fg = "Y"  THEN 
//					messagebox("품번검색", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")					
//					dw_body.SetItem(al_row, "style_no", "")
//					ib_itemchanged = FALSE
//					return 1 	
//				END IF 				
												
				
 				IF wf_style_set(al_row, ls_style) THEN 
				   dw_body.SetItem(al_row, "style_no", ls_style + lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "style",    ls_style)
				   dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand"))
				   dw_body.SetItem(al_row, "year",     lds_Source.GetItemString(1,"year"))
				   dw_body.SetItem(al_row, "season",   lds_Source.GetItemString(1,"season"))
				   dw_body.SetItem(al_row, "sojae",    lds_Source.GetItemString(1,"sojae"))
				   dw_body.SetItem(al_row, "item",     lds_Source.GetItemString(1,"item"))
				   dw_body.SetItem(al_row, "color",    lds_Source.GetItemString(1,"color"))
				   dw_body.SetItem(al_row, "size",     lds_Source.GetItemString(1,"size"))
					wf_style_set_color(al_row, ls_style, ls_color)
				   ib_changed = true
               cb_update.enabled = true
				   /* 다음컬럼으로 이동 */
			      dw_body.SetColumn("sale_qty")
			      lb_check = TRUE 
               This.Post Event ue_tot_set()
				END IF
				ib_itemchanged = FALSE
			END IF
			Destroy  lds_Source
	
	CASE "style"				
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "chno", "")
					RETURN 0
				END IF 
				IF gf_style_chk(as_data, '%') = True THEN
				   dw_head.SetItem(al_row, "chno", "")
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "STYLE 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "STYLE LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				dw_head.SetItem(al_row, "chno",  lds_Source.GetItemString(1,"chno"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("chno")
				ib_itemchanged = False 
				lb_check = TRUE 
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
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

il_rows = dw_list.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_shop_cd, is_shop_type, is_style, is_chno, is_empty_gubn)

IF il_rows >= 0 THEN
   dw_list.visible   = True
   dw_body.visible   = False
   //dw_member.visible = False
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(cb_input,   "FixedToRight")
inv_resize.of_Register(dw_list,   "ScaleToRight&Bottom")
inv_resize.of_Register(st_1,      "ScaleToRight&Bottom")
//inv_resize.of_Register(dw_member, "FixedToBottom&ScaleToRight")


dw_list.SetTransObject(SQLCA)
//dw_member.InsertRow(0)

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
         cb_insert.enabled  = false
         cb_delete.enabled  = false
         cb_update.enabled  = false
         cb_input.Text      = "일보등록(&I)"
         dw_head.enabled    = true 
         ib_changed         = false
      end if
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled  = true
			cb_print.enabled   = false
			cb_preview.enabled = false
			cb_excel.enabled   = false
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed         = false
			cb_print.enabled   = true
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
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_input.Text = "일보등록(&I)"
      cb_insert.enabled  = false
      cb_delete.enabled  = false
      cb_print.enabled   = false
      cb_preview.enabled = false
      cb_excel.enabled   = false
      cb_update.enabled  = false
      ib_changed         = false
      dw_body.Enabled    = false
      //dw_member.Enabled  = false
      dw_head.Enabled    = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 6		/* 입력 */
      if al_rows > 0 then
         cb_print.enabled   = true
         cb_preview.enabled = true
         cb_excel.enabled   = true
         dw_head.Enabled    = false

			
			if  is_data_opt <> 'V' then
	         dw_body.Enabled    = true
		      cb_insert.enabled  = true
            cb_delete.enabled  = true			
				//dw_member.object.goods_amt.protect = 0 	
	         dw_body.SetFocus()				
			else	
				messagebox("경고!", "판매데이터는 수정 하실 수 없습니다! 관리팀에 문의하세요!")
// 	          dw_body.Enabled    = false
    			 cb_insert.enabled  = false
             cb_delete.enabled  = false				
 				//dw_member.object.goods_amt.protect = 1
			end if	
         //dw_member.Enabled  = true
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

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
String   ls_sale_no, ls_style_no,   ls_sale_fg,   ls_card_no  , ls_coupon_no, ls_item, ls_jumin
String	ls_sale_type, ls_color, ls_size, ls_empty_1, ls_sale_no2, ls_no2
long     ll_sale_price, ll_goods_amt, ll_sale_qty 
long     i, ll_row_count, ll_chk, ll_no
decimal  ldc_dc_rate, ld_goods_amt
datetime ld_datetime 

IF dw_body.AcceptText() <> 1 THEN RETURN -1
//IF dw_member.AcceptText()    <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

IF is_data_opt = "V" THEN
	MessageBox("경고", "저장권한이 없습니다 !") 
	Return 0
END IF


is_yymmdd  = dw_body.Getitemstring(dw_body.getrow(), "yymmdd")
is_shop_cd = dw_body.Getitemstring(dw_body.getrow(), "shop_cd")
ls_no2 = dw_body.Getitemstring(dw_body.getrow(), "no")


/***********20140718~20140724 20만원이상 구매시 1만원 추가즉시할인 체크 적용
            1) 갤/센터시티(NG1078) : 2014년 07월 18일(금) ~ 07월 24일(목), 7일간 
            2) 갤/진주(NG1127)     : 2014년 07월 18일(금) ~ 07월 20일(일), 3일간
				3) 갤/타임월드(NG1082) : 2014년 07월 19일(금) ~ 07월 20일(일), 2일간
**********************/
IF is_brand = "N" and is_yymmdd >= "20140718" and is_yymmdd <= '20140724' and (is_shop_cd = 'NG1024' or is_shop_cd = 'NG1130' or is_shop_cd = 'NG1054' or is_shop_cd = 'NG1096' or is_shop_cd = 'NG1125' or is_shop_cd = 'NG1152' or is_shop_cd = 'NG1017' or is_shop_cd = 'NG0019' or is_shop_cd = 'NG1163' or is_shop_cd = 'NG1108') then
	This.Trigger Event ue_tot_set()
	wf_goods_chk3()
END IF

/****************************************************************************/

//IF is_shop_type = '1' AND isnull(dw_member.Object.age_grp[1]) THEN
//	MessageBox("경고", "연령층 이나 회원정보를 등록하십시오 !") 
//	Return 0 
//END IF

ll_row_count = dw_body.RowCount()
FOR i = ll_row_count to 1 step -1 
	ls_style_no = dw_body.GetitemString(i, "style_no")
	IF isnull(ls_style_no) THEN
		dw_body.DeleteRow(i) 
	END IF
NEXT 
ll_row_count = dw_body.RowCount()

IF ll_row_count > 0 AND dw_body.GetItemStatus(1, 0, Primary!) <> NewModified! THEN 
	//판매날짜 수정에 따른 세일번호 재확인//
	If is_org_yymmdd = is_yymmdd then
   	ls_sale_no = dw_body.GetitemString(1, "sale_no")
	else
		 select right(isnull(max(SALE_NO), 0) + 10001, 4)
		  into :ls_sale_no
        from tb_53017_h (nolock)
       where yymmdd    = :is_yymmdd 
         and shop_cd   = :is_shop_cd 
         and shop_type = :is_shop_type;
			
	end if
ELSEIF Gf_Get_Saleno(is_yymmdd, is_shop_cd, is_shop_type, ls_sale_no) <> 0 THEN 
	Return -1 
END IF

select right(isnull(max(NO), 0) + 10001, 4)
into :ll_no
from tb_53017_h(nolock) 
where yymmdd  =  :is_yymmdd
and shop_cd   =  :is_shop_cd
and sale_no   =  :ls_sale_no; 

/* 교환권 판매 처리 및 가능여부 체크 (정상판매단가가  교환권금액 이상 매출만 가능)*/
//ll_goods_amt = dw_member.GetitemNumber(1, "goods_amt")
IF isnull(ll_goods_amt) THEN ll_goods_amt = 0
	//ls_card_no   = dw_member.GetitemString(1, "card_no")
IF isnull(ls_card_no) = FALSE AND LenA(Trim(ls_card_no)) = 9 THEN
	ls_card_no = '4870090' + ls_card_no 
ELSE
	SetNull(ls_card_no)
END IF

FOR i=1 TO ll_row_count
		idw_status = dw_body.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN			/* New Record */
		//      dw_body.Setitem(i, "no",  String(i, "0000"))
			dw_body.Setitem(i, "no",  string(ll_no,"0000"))			
			dw_body.Setitem(i, "yymmdd",     is_yymmdd)
			dw_body.Setitem(i, "shop_cd",    is_shop_cd)
			dw_body.Setitem(i, "shop_type",  is_shop_type)
			dw_body.Setitem(i, "shop_div",   MidA(is_shop_cd, 2, 1))
			dw_body.Setitem(i, "sale_no",    ls_sale_no)
			dw_body.Setitem(i, "reg_id",     gs_user_id)
			//dw_body.Setitem(i, "age_grp", dw_member.Object.age_grp[1])  
			dw_body.Setitem(i, "sale_fg", ls_sale_fg)
			//dw_body.Setitem(i, "jumin",   Trim(dw_member.Object.jumin[1]))  
			//dw_body.Setitem(i, "card_no", ls_card_no) 			
			ll_no = ll_no + 1 
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
			dw_body.Setitem(i, "mod_id", gs_user_id)
			dw_body.Setitem(i, "mod_dt", ld_datetime)
			//dw_body.Setitem(i, "age_grp", dw_member.Object.age_grp[1])  
			dw_body.Setitem(i, "sale_fg", ls_sale_fg)
			//dw_body.Setitem(i, "jumin",   Trim(dw_member.Object.jumin[1]))  
			//dw_body.Setitem(i, "card_no", ls_card_no) 				
		END IF 
		
		
 
		
		
		/* 교환권 판매 처리 및 가능여부 체크 (정상판매단가가  교환권금액 이상 매출만 가능) */
		IF is_shop_type = '1' or is_shop_type = '3' THEN  /* 정상 매장만 처리 */
			ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))
			ll_sale_qty  = dw_body.GetitemDecimal(i, "sale_qty")
			ls_style_no  = dw_body.Getitemstring(i, "style_no")
			ls_item      = RightA(LeftA(ls_style_no,2),1)
		
					
			ll_goods_amt = dw_body.GetitemNumber(i, "goods_amt")						
			ls_coupon_no  = dw_body.Getitemstring(i, "coupon_no")	
		
		
			IF LenA(ls_coupon_no) =  6 then	
						IF ll_sale_qty > 1 AND ll_goods_amt > 0   THEN
							MessageBox("경고", "쿠폰은 1PCS에만 적용 판매 할 수 있습니다!") 
							Return 0 
						END IF
						 
						
						IF ll_sale_qty > 1 AND ll_goods_amt > 0  and  ll_sale_qty * ll_sale_price > ll_goods_amt then
							MessageBox("경고", "쿠폰금액이상의 제품에만 적용 판매 할 수 있습니다!") 
							Return 0 
						END IF		
						
				
						IF ll_goods_amt > 0 and ll_sale_qty  > 0 and ll_sale_price > ll_goods_amt and dw_body.Object.dc_rate[i]  < 31 THEN 
							ls_sale_fg = '2' 	
						ELSEIF LenA(ls_card_no) = 16 and LeftA(dw_body.Object.sale_type[i], 1) <= '2' THEN  // 정상 적용 
							ls_sale_fg = '1' 
						ELSE
							ls_sale_fg = '0' 
						END IF
				
			ELSE		//마일리지는 정상+sale 만 사용가능 
				
						IF ll_goods_amt > 0 and ll_sale_price > ll_goods_amt and  & 
							ll_sale_qty  > 0 and dw_body.Object.dc_rate[i]  < 31 THEN 
							ls_sale_fg = '2' 	
						ELSEIF LenA(ls_card_no) = 16 and LeftA(dw_body.Object.sale_type[i], 1) <= '2' THEN  // 정상 적용 
							ls_sale_fg = '1' 
						ELSE
							ls_sale_fg = '0' 
						END IF			
			END IF
			
		// 교환권액 등록후 수금액 및 판매감가  산출
			
		if 	is_member_return = 'N' THEN   // 회원반품일때는 처리하지말고 RETURN   
			   wf_amt_set(i, ll_sale_qty, ll_sale_price)
		end if
		
		
			IF idw_status <> New! THEN 
//				dw_body.Setitem(i, "age_grp", dw_member.Object.age_grp[1])  
//				dw_body.Setitem(i, "sale_fg", ls_sale_fg)
//				dw_body.Setitem(i, "jumin",   Trim(dw_member.Object.jumin[1]))  
//				dw_body.Setitem(i, "card_no", ls_card_no)  
			END IF
		ELSE 
			dw_body.Setitem(i, "sale_fg", '0')
		END IF 
		
		ls_sale_fg = dw_body.getitemstring(i,"sale_fg")
		ldc_dc_rate  = dw_body.getitemnumber(i, "dc_rate")	
		ls_sale_type = dw_body.getitemString(i, "sale_type")	
		
		
		
			ls_color = dw_body.GetitemString(i, "color")
			if isnull(ls_color) or  Trim(ls_color) = "" then 
				messagebox("경고!", "칼라코드를 입력하세요!")
				return 0
			end if 		
			
			ls_size = dw_body.GetitemString(i, "size")	
			if isnull(ls_size) or  Trim(ls_size) = "" then 
				messagebox("경고!", "사이즈코드를 입력하세요!")
				return 0
			end if 				
		
		if 	is_member_return = 'N' THEN  // 회원반품일때는 처리하지말고 RETURN   
			wf_line_chk(i)
		end if
		
NEXT


is_member_return  = 'N'   // 회원 반품 마크 해지 처리 

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
	
	//승인시 판매등록//
	ls_empty_1 = dw_body.GetitemString(1, "empty_1")	
	
	//messagebox('1',ls_empty_1)
	
	If ls_empty_1 = 'Y' then
		
					String up_yymmdd, up_sale_no, up_style, up_chno, up_color, up_size, up_visiter
					//이전 판매데이터 visiter, phone_no 컬럼 업데이트하기/////////////////////////////////////////////////////
					select left(phone_no,8), '00'+right(phone_no,2), style, chno, color, size, visiter
					  into :up_yymmdd, :up_sale_no, :up_style, :up_chno, :up_color, :up_size, :up_visiter
					  from tb_53017_h with(nolock)
					 where yymmdd = :is_yymmdd
					   and shop_cd = :is_shop_cd
					   and shop_type =:is_shop_type
					   and sale_no = :ls_sale_no
					   and no = :ls_no2; 
					
						
					If LenA(up_yymmdd) < 8 or isnull(up_yymmdd) then
						messagebox('확인','MIS팀으로 문의해주세요.')
						return -1
					else
						update tb_53010_h set
						visiter = :up_visiter,
						phone_no = (:is_yymmdd + :is_shop_cd),
						mod_id = :gs_user_id,
						mod_dt = :ld_datetime
					 where yymmdd = :up_yymmdd
					   and shop_cd = :is_shop_cd
						and sale_no = :up_sale_no
					   and style = :up_style
					   and chno = :up_chno
					   and color = :up_color
					   and size = :up_size;
					end if
					
					
					
					
					
					
					
					//판매데이터 insert 전 sale_no, no 맥스값 가져오기.
					
						 select right(isnull(max(SALE_NO), 0) + 10001, 4)
						  into :ls_sale_no2
						  from tb_53010_h (nolock)
						 where yymmdd    = :is_yymmdd 
							and shop_cd   = :is_shop_cd 
							and shop_type = :is_shop_type;
	

													insert into tb_53010_h( yymmdd,
													shop_cd,
													shop_type,
													sale_no,
													no,
													style,
													chno,
													color,
													size,
													sale_type,
													sale_qty,
													tag_price,
													curr_price,
													dc_rate,
													sale_price,
													tag_amt,
													curr_amt,
													sale_amt,
													out_rate,
													out_amt,
													sale_rate,
													sale_collect,
													io_amt,
													io_vat,
													refill_mark,
													age_grp,
													sale_fg,
													jumin,
													card_no,
													goods_amt,
													sale_cust,
													brand,
													year,
													season,
													sojae,
													item,
													shop_div,
													trigger_yn,
													reg_id,
													reg_dt,
													mod_id,
													mod_dt,
													coupon_no,
													pda_no,
													phone_no,
													visiter,
													dotcom,
													ok_coupon,
													ok_coupon_amt,
													event_id,
													org_sale_qty,
													set_style,
													online_id,
													on_dc_rate,
													on_sale_price,
													empty_1,
													empty_2,
													empty_3,
													empty_4,
													empty_5,
													empty_6,
													empty_7,
													empty_8,
													empty_9,
													empty_10)
										select 
													yymmdd,
													shop_cd,
													shop_type,
													:ls_sale_no2,
													'0001',
													style,
													chno,
													color,
													size,
													sale_type,
													sale_qty,
													tag_price,
													curr_price,
													dc_rate,
													sale_price,
													tag_amt,
													curr_amt,
													sale_amt,
													out_rate,
													out_amt,
													sale_rate,
													sale_collect,
													io_amt,
													io_vat,
													refill_mark,
													age_grp,
													sale_fg,
													jumin,
													card_no,
													goods_amt,
													sale_cust,
													brand,
													year,
													season,
													sojae,
													item,
													shop_div,
													'Y',
													reg_id,
													reg_dt,
													mod_id,
													mod_dt,
													coupon_no,
													pda_no,
													phone_no,
													visiter,
													dotcom,
													ok_coupon,
													ok_coupon_amt,
													event_id,
													org_sale_qty,
													set_style,
													online_id,
													on_dc_rate,
													on_sale_price,
													empty_1,
													empty_2,
													empty_3,
													empty_4,
													empty_5,
													empty_6,
													empty_7,
													empty_8,
													empty_9,
													empty_10
													from tb_53017_h
													where yymmdd = :is_yymmdd
													and shop_cd = :is_shop_cd
													and shop_type =:is_shop_type
													and sale_no = :ls_sale_no
													and no = :ls_no2;
													
													commit  USING SQLCA;
													dw_body.Retrieve(is_yymmdd, is_shop_cd, is_shop_type, ls_sale_no, ls_no2)
	end if
	
	
else
   rollback  USING SQLCA;
end if


This.Trigger Event ue_tot_set()

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event open;call super::open;string ld_datetime

dw_head.Setitem(1, "shop_type", '%')
dw_head.Setitem(1, "empty_gubn", '%')

select data_level
into :is_data_opt
from tb_93010_m
where person_id = :gs_user_id;

select convert(varchar(8), getdate(),112)
  into :ld_datetime
  from dual;


select iud_gbn
  into :chk_iud
  from TB_93040_H
 where person_id = :gs_user_id
   and pgm_id = 'W_53100_E';
	

If chk_iud = '0' or trim(chk_iud) <> '' then
	cb_update.visible = False
	dw_body.Object.yymmdd.protect = 1
	dw_body.Object.empty_1.protect = 1
end if 
	

dw_head.setitem(1,"fr_yymmdd",ld_datetime)
dw_head.setitem(1,"to_yymmdd",ld_datetime)



is_member_return = 'N' 
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53001_e","0")
end event

event pfc_dberror();//
end event

event ue_excel();string ls_doc_nm, ls_nm

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

if dw_list.visible = true then
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

type cb_close from w_com010_e`cb_close within w_53100_e
integer taborder = 140
end type

type cb_delete from w_com010_e`cb_delete within w_53100_e
boolean visible = false
integer taborder = 130
end type

type cb_insert from w_com010_e`cb_insert within w_53100_e
boolean visible = false
integer taborder = 70
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_53100_e
integer x = 2839
integer width = 384
integer taborder = 40
string text = "일보조회(&Q)"
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

type cb_update from w_com010_e`cb_update within w_53100_e
end type

type cb_print from w_com010_e`cb_print within w_53100_e
boolean visible = false
integer taborder = 100
end type

type cb_preview from w_com010_e`cb_preview within w_53100_e
boolean visible = false
integer taborder = 110
end type

type gb_button from w_com010_e`gb_button within w_53100_e
end type

type cb_excel from w_com010_e`cb_excel within w_53100_e
integer taborder = 120
boolean enabled = true
end type

type dw_head from w_com010_e`dw_head within w_53100_e
integer y = 156
integer width = 3525
integer height = 220
string dataobject = "d_53100_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001') 



This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911') 
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '%')
ldw_child.SetItem(1, "inter_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
/*===========================================================================*/
String ls_yymmdd

CHOOSE CASE dwo.name
	CASE "yymmdd"      
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
	CASE "shop_cd"	,"style"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_53100_e
integer beginy = 456
integer endy = 456
end type

type ln_2 from w_com010_e`ln_2 within w_53100_e
integer beginy = 460
integer endy = 460
end type

type dw_body from w_com010_e`dw_body within w_53100_e
event ue_set_col ( string as_column )
integer x = 9
integer width = 3579
integer height = 1196
integer taborder = 50
string dataobject = "d_53100_d01"
boolean hscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylebox!
end type

event dw_body::ue_set_col(string as_column);This.SetColumn(as_column)
end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
Long    ll_ret, ll_sale_qty, ll_sale_price, ll_collect_price  
Decimal ldc_sale_marjin, ld_goods_amt
String  ll_null, ls_style
string ls_card_no
SetNull(ll_null)

CHOOSE CASE dwo.name
	CASE "yymmdd"	     
	
	CASE "style_no"	
		IF ib_itemchanged THEN RETURN 1 
		ll_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		

		/*
		20130101 부터
		*/
			//########### 회원 즉시할인 +5% 적용 로직 #####################
//			ls_card_no = dw_member.getitemstring(1, "card_no")

			IF Trim(ls_card_no) <> "" THEN 
				wf_amt_set3(row)
				//dw_member.AcceptText()
			END IF
			//#############################################################
				
		
		
		IF LenA(This.GetitemString(row, "size")) = 2 and LenA(This.GetitemString(row, "color")) = 2 THEN
			This.Post Event ue_set_col("qty")
		else	
			This.Post Event ue_set_col("color")			
		END IF 
		Return ll_ret
	CASE "color"	
		
		ls_style = This.GetitemString(row, "style")
		wf_style_set_color(row, ls_style, data)

		//ls_card_no = dw_member.getitemstring(1, "card_no")

			IF Trim(ls_card_no) <> "" THEN 
				wf_amt_set3(row)
				//dw_member.AcceptText()
			END IF
		
		if This.GetitemString(row, "size") <> 'XX' then
			This.Setitem(row, "size", ll_null) 
			This.Post Event ue_set_col("size")
		end if			
		
	CASE "sale_price" 
		ll_sale_price   = Long(Data) 
		IF isnull(ll_sale_price) or ll_sale_price = 0 THEN RETURN 1 
		ll_sale_qty     = This.GetitemNumber(row, "sale_qty")
		ldc_sale_marjin = This.GetitemDecimal(row, "sale_rate")
		/* 판매 수금 단가 산출 */
		gf_marjin_price(is_shop_cd, Long(data), ldc_sale_marjin, ll_collect_price) 
		This.Setitem(row, "collect_price", ll_collect_price)
		IF is_shop_type > '3' THEN 
         This.Setitem(row, "curr_price", ll_sale_price)
         This.Setitem(row, "out_price",  ll_collect_price)
		END IF 
      /* 금액 처리           */
		wf_amt_set(row, ll_sale_qty, ll_sale_price) 
		Parent.Post Event ue_tot_set()
	CASE "sale_qty" 
		ll_sale_qty   = Long(Data) 
		IF isnull(ll_sale_qty) or ll_sale_qty = 0 THEN RETURN 1 
		
		ld_goods_amt = this.getitemdecimal(row,"goods_amt")
		
			IF Long(Data) < 0 then 
            this.setitem(row,"goods_amt", 0)
				//dw_member.setitem(1,"goods_amt", 0)
				Parent.Post Event ue_tot_set()
			END IF
		
		ll_sale_price = This.GetitemNumber(row, "sale_price")
      /* 금액 처리           */
		wf_amt_set(row, ll_sale_qty, ll_sale_price) 
		Parent.Post Event ue_tot_set()
END CHOOSE

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.insertRow(0)

This.GetChild("size", idw_size)
idw_size.SetTransObject(SQLCA)
idw_size.insertRow(0)

This.GetChild("color_1", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve()

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('011')

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
		IF ls_column_name = "sale_qty" and This.GetRow() = This.RowCount() THEN 
			Parent.Post Event ue_insert()
		END IF
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

event dw_body::doubleclicked;call super::doubleclicked;String ls_style_no,   ls_yes, ls_flag
Long   ll_curr_price, ll_sale_price, ll_collect_price, ll_sale_qty, ll_goods_amt

		
IF row < 1 THEN RETURN 

ls_flag = This.GetitemString(row, "flag")                  


//화면 권한 없으면 수정 불가능
If chk_iud = '0' or trim(chk_iud) <> '' then
	return
end if 
	
	
	


//미승인 된 건만 처리 가능.
If ls_flag = '1' then

	ls_style_no = This.GetitemString(row, "style_no")
	
	IF isnull(ls_style_no) or Trim(ls_style_no) = "" THEN RETURN
	ll_goods_amt = This.GetitemDecimal(row, "goods_amt")
	ll_sale_qty  = This.GetitemDecimal(row, "sale_qty")
	is_yymmdd 	 = This.GetitemString(row, "yymmdd")
	is_shop_cd	 = This.GetitemString(row, "shop_cd")
	
	if ll_goods_amt > 0 and ll_sale_qty > 0 then 
		messagebox("주의", "마일리지 사용시 변경할 수 없습니다..")
		return  
	end if
		
	gsv_cd.gs_cd1 = is_brand 
	gsv_cd.gs_cd2 = is_shop_cd 
	gsv_cd.gs_cd3 = is_shop_type
	gsv_cd.gs_cd4 = is_yymmdd
	
	
	OpenWithParm (W_53001_S1, "W_53001_S 판매형태 내역") 
	ls_yes = Message.StringParm 
	IF ls_yes = 'YES' THEN 
		IF is_shop_type > '3' THEN 
			ll_curr_price = This.GetitemNumber(row, "tag_price")
			ll_sale_price = ll_curr_price * (100 - gdc_rate) / 100 
		ELSE
			ll_curr_price = This.GetitemNumber(row, "curr_price")
			ll_sale_price = ll_curr_price * (100 - gdc_rate) / 100 
		END IF 
		gf_marjin_price(is_shop_cd, ll_sale_price, gsv_cd.gdc_cd1, ll_collect_price) 
		This.Setitem(row, "sale_type",     gsv_cd.gs_cd5) 
		This.Setitem(row, "dc_rate",       gdc_rate) 
		This.Setitem(row, "sale_rate",     gsv_cd.gdc_cd1) 
		This.Setitem(row, "sale_price",    ll_sale_price)
		This.Setitem(row, "collect_price", ll_collect_price) 
		IF is_shop_type > '3' THEN 
			This.Setitem(row, "curr_price", ll_sale_price)
			This.Setitem(row, "out_price",  ll_collect_price) 
			This.Setitem(row, "out_rate",   gsv_cd.gdc_cd1) 
		END IF 
		wf_amt_set(row, This.Object.sale_qty[row], ll_sale_price) 
		ib_changed = true
		cb_update.enabled = true
		IF gsv_cd.gs_cd5 = '12' THEN
			dw_body.SetRow(row)
			dw_body.SetColumn("sale_price")
		END IF
		Parent.Trigger Event ue_tot_set()
	END IF 

end if 
end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color, ls_size

CHOOSE CASE dwo.name
	CASE "color"
		ls_style = This.GetitemString(row, "style")
		ls_chno  = This.GetitemString(row, "chno")
		idw_color.Retrieve(ls_style, ls_chno)
		if is_shop_type > '3' then 
			idw_color.insertRow(1)
			idw_color.Setitem(1, "color", "XX")
			idw_color.Setitem(1, "color_enm", "XX")
		end if 
	CASE "size"
		ls_style = This.GetitemString(row, "style")
		ls_chno  = This.GetitemString(row, "chno")
		ls_color = This.GetitemString(row, "color")
		idw_size.Retrieve(ls_style, ls_chno, ls_color)
		if is_shop_type > '3' then 
			idw_size.insertRow(1)
			idw_size.Setitem(1, "size", "XX")
			idw_size.Setitem(1, "size_nm", "XX")
		end if 
		
	CASE "sale_qty"
		ls_color = This.GetitemString(row, "color")
		ls_size  = This.GetitemString(row, "size")		

		if isnull(ls_color) or  Trim(ls_color) = "" then 
			messagebox("경고!", "칼라코드를 입력하세요!")
			return 0
		end if 		
		
		if isnull(ls_size) or  Trim(ls_size) = "" then 
			messagebox("경고!", "사이즈코드를 입력하세요!")
			return 0
		end if 						
		
END CHOOSE


end event

event dw_body::dberror;//
end event

event dw_body::rbuttondown;call super::rbuttondown;if row = 0 then return


IF idw_status = NotModified! OR idw_status = DataModified! THEN
else
	this.selectrow(0, false)
	this.selectrow(row, true)	
END IF 

	m_popup popup
	popup = Create m_popup

	popup.Popmenu(parent.X + this.X + this.pointerX(), parent.Y + this.Y + this.pointerY() + 200)

/*
choose case gi_popup
	case C_DELETE
		Trigger Event ue_delete()
	case C_INSERT
		Trigger Event ue_insert()

end choose

gi_popup = C_NONE
*/
end event

type dw_print from w_com010_e`dw_print within w_53100_e
end type

type st_1 from statictext within w_53100_e
integer x = 5
integer y = 464
integer width = 3593
integer height = 1660
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

type cb_input from commandbutton within w_53100_e
event ue_keydown pbm_keydown
boolean visible = false
integer x = 2455
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
boolean enabled = false
string text = "일보등록(&I)"
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

type st_2 from statictext within w_53100_e
integer x = 41
integer y = 392
integer width = 2633
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "☞ 주의: 승인 시 판매가 자동으로 등록되며, 수정이 불가능 합니다. 신중하게 등록해주세요."
boolean focusrectangle = false
end type

type dw_list from datawindow within w_53100_e
boolean visible = false
integer y = 368
integer width = 3575
integer height = 1676
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "d_53100_d08"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;DataWindowChild ldw_child 

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('011')

end event

event doubleclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
String ls_sale_no, ls_jumin , ls_coupon_no ,ls_no, ls_shop_cd

IF row < 1 THEN RETURN 

ls_shop_cd	 = This.GetitemString(row, "shop_cd")
is_shop_type = This.GetitemString(row, "shop_type")
ls_sale_no   = This.GetitemString(row, "sale_no") 
ls_jumin     = This.GetitemString(row, "jumin")
ls_coupon_no = This.GetitemString(row, "coupon_no")
ls_no        = This.GetitemString(row, "no")
is_yymmdd	 = This.GetitemString(row, "yymmdd")
is_org_yymmdd  = This.GetitemString(row, "yymmdd")
is_org_sale_no   = This.GetitemString(row, "sale_no") 
is_org_no        = This.GetitemString(row, "no")

dw_head.Setitem(1, "shop_type", is_shop_type) 

//if dwo.name <> "no" then 
//	dw_body.Retrieve(is_yymmdd, ls_shop_cd, is_shop_type, ls_sale_no, '%')
//else	
//	dw_body.Retrieve(is_yymmdd, ls_shop_cd, is_shop_type, ls_sale_no, ls_no)
//end if	

dw_body.Retrieve(is_yymmdd, ls_shop_cd, is_shop_type, ls_sale_no, ls_no)

//dw_member.Setitem(1, "goods_amt", Long(dw_body.Describe("evaluate('sum(goods_amt)',0)")))

//IF isnull(ls_jumin) = FALSE AND Trim(ls_jumin) <> "" THEN
//   wf_member_set('1', ls_jumin) 
//	dw_member.Setitem(1, "coupon_no", ls_coupon_no)
//ELSE
//   Setnull(ls_jumin)
//   dw_member.SetItem(1, "card_no",      ls_jumin)
//   dw_member.SetItem(1, "user_name",    ls_jumin)
//   dw_member.SetItem(1, "jumin",        ls_jumin)
//   dw_member.Setitem(1, "total_point",  0)
//   dw_member.Setitem(1, "give_point",   0)
//   dw_member.Setitem(1, "accept_point", 0)
//	dw_member.Setitem(1, "age_grp", This.GetitemString(row, "age_grp"))
//END IF

Parent.Post Event ue_tot_set()



dw_body.visible = True
//dw_member.Visible = True
This.visible = False

dw_body.SetFocus()

Parent.Trigger Event ue_button(6, il_rows)

//IF is_shop_type = '1' or is_shop_type = '3' THEN
//	dw_member.Enabled = TRUE
//ELSE
//	dw_member.Enabled = FALSE 
//END IF 
//
end event

