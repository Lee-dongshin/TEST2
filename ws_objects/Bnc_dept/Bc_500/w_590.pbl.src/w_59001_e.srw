$PBExportHeader$w_59001_e.srw
$PBExportComments$판매등록(해외)
forward
global type w_59001_e from w_com010_e
end type
type dw_member from datawindow within w_59001_e
end type
type st_1 from statictext within w_59001_e
end type
type cb_input from commandbutton within w_59001_e
end type
type st_2 from statictext within w_59001_e
end type
type dw_member_sale from datawindow within w_59001_e
end type
type dw_list from datawindow within w_59001_e
end type
end forward

global type w_59001_e from w_com010_e
integer width = 3648
integer height = 2324
event ue_input ( )
event ue_tot_set ( )
dw_member dw_member
st_1 st_1
cb_input cb_input
st_2 st_2
dw_member_sale dw_member_sale
dw_list dw_list
end type
global w_59001_e w_59001_e

type variables
DataWindowChild idw_color, idw_size
String is_brand, is_yymmdd, is_shop_cd, is_shop_type, is_data_opt, is_member_return,is_style, is_chno
long il_rates
end variables

forward prototypes
public subroutine wf_goods_amt_clear ()
public function boolean wf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name)
public function boolean wf_member_set (string as_flag, string as_find)
public subroutine wf_line_chk (long al_row)
private function boolean wf_coupon_chk (long al_goods_amt)
public function boolean wf_goods_chk (long al_goods_amt)
public subroutine wf_amt_set (long al_row, long al_sale_qty, long al_sale_price)
public function boolean wf_style_chk (long al_row, string as_style_no)
public function boolean wf_style_set (long al_row, string as_style)
public function integer wf_yes_no (string as_title)
end prototypes

event ue_input();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
dw_list.Visible   = False
dw_body.Visible   = True
//dw_member.Visible = True 해외에서는 사용을 안함.

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
if is_shop_type = "%" then
   MessageBox("Input Error","Enter the Shop code!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   Return 
end if

dw_body.Reset()
il_rows = dw_body.insertRow(0)
dw_member.Reset()
dw_member.insertRow(0)

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

dw_member.Setitem(1, "sale_qty", ll_sale_qty)
dw_member.Setitem(1, "sale_amt", ll_sale_amt)

Return

end event

public subroutine wf_goods_amt_clear ();long i , ll_row_count

ll_row_count = dw_body.rowcount()

FOR i=1 TO ll_row_count
	dw_body.Setitem(i, "goods_amt", 0)
	dw_body.Setitem(i, "coupon_no", '')	
NEXT

end subroutine

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

public function boolean wf_member_set (string as_flag, string as_find);String  ls_user_name,   ls_jumin,      ls_card_no,      ls_age_grp
Long    ll_total_point, ll_give_point, ll_accept_point, ll_year 
decimal ld_give_point
Boolean lb_return 
DataStore	lds_source	

IF as_flag = '3' THEN
		if LenA(as_find) < 10 then 
			messagebox("확인","전화번호를 올바로 입력하세요..")			
			return true				
		else
			 wf_chk_phone(as_find, ls_jumin,ls_user_name) 
			dw_member.SetItem(1, "jumin",     ls_jumin)
			as_flag = '1'
			as_find = ls_jumin
		end if	
end if

IF as_flag = '1' THEN
	SELECT user_name,       jumin,          card_no,
			 total_point * 10,     give_point * 10,     accept_point * 10
	  INTO :ls_user_name,   :ls_jumin,      :ls_card_no,  
			 :ll_total_point, :ll_give_point, :ll_accept_point 
	  FROM TB_71010_M with (nolock)   
	 WHERE jumin   = :as_find ; 
ELSE
	SELECT user_name,       jumin,          card_no,
			 total_point * 10,     give_point * 10,     accept_point * 10
	  INTO :ls_user_name,   :ls_jumin,      :ls_card_no,  
			 :ll_total_point, :ll_give_point, :ll_accept_point 
	  FROM TB_71010_M with (nolock)
	 WHERE card_no = '4870090' + :as_find ; 	 
END IF

IF SQLCA.SQLCODE <> 0 AND isnull(as_find) = false THEN 
	lb_return = False 
ELSE 
	lb_return = True
END IF

if (ll_total_point - ll_accept_point) >= 30000 then 
	dw_member.object.text_message.text = "사용할 Point금액이 있습니다 !"
else 
	dw_member.object.text_message.text = ""
end if

select top 1 give_point * 10
into	 :ld_give_point
from	 tb_71011_h (nolock)
where jumin       = :ls_jumin
and	point_flag  = '1'
and   accept_flag = 'N'
and   coupon_no is not null ;


if ld_give_point >  0 then 
	dw_member.object.text_message2.text = "구매할인권이 " + string(ld_give_point) + "원 있습니다 !"
else 
	dw_member.object.text_message2.text = ""
end if

dw_member.SetItem(1, "card_no",      RightA(ls_card_no, 9))
dw_member.SetItem(1, "user_name",    ls_user_name)
dw_member.SetItem(1, "jumin",        ls_jumin)
dw_member.Setitem(1, "total_point",  ll_total_point)
dw_member.Setitem(1, "accept_point", ll_accept_point) 

/* 연령층 처리 */
IF lb_return = False OR isnull(as_find) THEN
	setnull(ls_age_grp)
ELSEIF ll_year < 10 THEN
   GF_GET_AGEGRP(ls_jumin, integer(LeftA(is_yymmdd, 4)), ls_age_grp)
END IF
dw_member.SetItem(1, "age_grp", ls_age_grp)


Return lb_return

end function

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

	 if MidA(is_shop_cd,2,1) = "G" then
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
			if abs(ll_sale_collect - round((ll_sale_amt - ll_goods_amt) * (100 - ldc_sale_rate)/100,0)) > 3 then 
			ll_sale_collect = round((ll_sale_amt - ll_goods_amt) * (100 - ldc_sale_rate)/100,0)
			dw_body.setitem(al_row,"sale_collect", ll_sale_collect)
			end if	

			if ll_io_amt <> (ll_out_amt - ll_sale_collect) then
			ll_io_amt  = ll_out_amt - ll_sale_collect
			dw_body.setitem(al_row,"io_amt", ll_io_amt)
			end if
			
	 end if	
		
//		if abs(ll_sale_collect - round((ll_sale_amt ) * (100 - ldc_sale_rate)/100,0)) > 3 then 
//			ll_sale_collect = round((ll_sale_amt ) * (100 - ldc_sale_rate)/100,0)
//			dw_body.setitem(al_row,"sale_collect", ll_sale_collect)
//		end if
		
		if ll_io_vat <> (ll_io_amt - round(ll_io_amt/1.1,0) ) then
			ll_io_vat  = (ll_io_amt - round(ll_io_amt/1.1,0) )
			dw_body.setitem(al_row,"io_vat", ll_io_vat)
		end if


////IF ll_goods_amt  >= 	ll_sale_amt and ll_goods_amt > 0  THEN 	// 2005.11.11 ~ 11.20 구매할인권 행사 쿠폰보자 싼 제품 구매시
////		   ll_sale_collect = 0
////			dw_body.setitem(al_row,"sale_collect", ll_sale_collect)
////		 
////		
////		if ll_io_amt <> (ll_out_amt - ll_sale_collect) then
////			ll_io_amt  = ll_out_amt - ll_sale_collect
////			dw_body.setitem(al_row,"io_amt", ll_io_amt)
////		end if
////
////		if ll_io_vat <> (ll_io_amt - round(ll_io_amt/1.1,0) ) then
////			ll_io_vat  = (ll_io_amt - round(ll_io_amt/1.1,0) )
////			dw_body.setitem(al_row,"io_vat", ll_io_vat)
////		end if
////		
////ELSE		// 정상로직 	
//	
//	if abs(ll_sale_collect - round((ll_sale_amt - ll_goods_amt) * (100 - ldc_sale_rate)/100,0)) > 3 then 
//		ll_sale_collect = round((ll_sale_amt - ll_goods_amt) * (100 - ldc_sale_rate)/100,0)
//		dw_body.setitem(al_row,"sale_collect", ll_sale_collect)
//	end if
//	
//	if ll_io_amt <> (ll_out_amt - ll_sale_collect) then
//		ll_io_amt  = ll_out_amt - ll_sale_collect
//		dw_body.setitem(al_row,"io_amt", ll_io_amt)
//	end if
//	
//	
//	if ll_io_vat <> (ll_io_amt - round(ll_io_amt/1.1,0) ) then
//		ll_io_vat  = (ll_io_amt - round(ll_io_amt/1.1,0) )
//		dw_body.setitem(al_row,"io_vat", ll_io_vat)
//	end if
	
//END IF

return


end subroutine

private function boolean wf_coupon_chk (long al_goods_amt);String  ls_user_name,   ls_jumin,      ls_card_no,      ls_age_grp,	ls_coupon_no
Long    ll_total_point, ll_give_point, ll_accept_point, ll_year 
Boolean lb_return 

ls_coupon_no = dw_member.GetItemString(1,"coupon_no")
ls_jumin = dw_member.GetItemString(1,"jumin")

	SELECT a.user_name,       a.jumin,          a.card_no,
			 a.total_point,     a.give_point,     a.accept_point 
	  INTO :ls_user_name,   :ls_jumin,      :ls_card_no,  
			 :ll_total_point, :ll_give_point, :ll_accept_point 
	  FROM TB_71010_M a with (nolock) , TB_71011_H b with (nolock)  
	 WHERE b.coupon_no   = :ls_coupon_no
	 AND 	 b.give_point  = :al_goods_amt / 10
	 AND 	 a.jumin			= b.jumin 
	 AND   b.accept_flag = 'N' 
	 AND	 b.point_flag = 1 ;

IF SQLCA.SQLCODE <> 0 AND isnull(ls_coupon_no) = false THEN 
	lb_return = False  
ELSE	
	lb_return = True 
END IF

dw_member.SetItem(1, "card_no",      RightA(ls_card_no, 9))
dw_member.SetItem(1, "user_name",    ls_user_name)
dw_member.SetItem(1, "jumin",        ls_jumin)
dw_member.Setitem(1, "total_point",  ll_total_point)
dw_member.Setitem(1, "give_point",   ll_give_point)
dw_member.Setitem(1, "accept_point", ll_accept_point)
/* 연령층 처리 */
IF MidA(ls_jumin,7,1) > '2' THEN	//2000년 이후 출생자.
	ll_year = Long(LeftA(is_yymmdd, 4)) - (Long(MidA(ls_jumin,1,2)) + 2000) + 1
ELSE
	ll_year = Long(LeftA(is_yymmdd, 4)) - (Long(MidA(ls_jumin,1,2)) + 1900) + 1
END IF 

IF lb_return = False OR isnull(ls_coupon_no) THEN
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
dw_member.SetItem(1, "age_grp", ls_age_grp)


Return lb_return
end function

public function boolean wf_goods_chk (long al_goods_amt);Long 	  j, i, k, ll_accept_point, ll_remain_point, ll_total_point , ll_row_count,ll_goods_amt,ll_sale_price, ll_sale_price2,ll_sale_qty   
decimal ld_goods_amt, ld_mok, ld_qty, ld_coupon_amt, ld_check_amt,ld_tot_goods_amt,ld_dc_rate 
string  ls_jumin, ls_card_no, ls_sale_fg, ls_style_no, ls_item, ls_coupon_no, ls_coupon_yn, ls_date_chk
integer il_remain_amt, li_sale_qty

wf_goods_amt_clear()

ls_jumin        = dw_member.GetitemString (1, "jumin")          // 주민번호
ld_goods_amt    = dw_member.Getitemdecimal(1, "goods_amt")      // 사용할 금액
ll_total_point  = dw_member.getitemdecimal( 1, "total_point")   // 총 포인트 
ll_remain_point = dw_member.getitemdecimal( 1, "remain_point")  // 남은 포인트 
ll_accept_point = ld_goods_amt                   	    	  // 사용할 포인트
ls_coupon_yn = 'n'
li_sale_qty    =  dw_member.getitemNumber( 1, "sale_qty")

ll_row_count = dw_body.RowCount()


select convert(char(08), getdate(), 112)
into :ls_date_chk
from dual;

IF isnull(al_goods_amt) OR al_goods_amt = 0 THEN 
	 wf_goods_amt_clear()
	RETURN TRUE 
END IF

 // 잔여 포인트를 만원 단위로 사용하도록 변환 
 il_remain_amt =  (ll_remain_point  / 10000) 
 ll_remain_point = il_remain_amt  *  10000


if ls_date_chk <= "20090224"   then

else

// 먼저 사용할 쿠폰이 있는지 체크   //
			select top 1 give_point * 10,
					 coupon_no
			 into :ld_coupon_amt, :ls_coupon_no 
			from	tb_71011_h (nolock)
			where jumin       = :ls_jumin
			and	point_flag  = '1'
			and   accept_flag = 'N'
			order by give_point desc;
			
			
		IF isnull(ld_coupon_amt) THEN ld_coupon_amt = 0 
		
		IF ll_remain_point + ld_coupon_amt < ld_goods_amt THEN 
				MessageBox("Point 오류", "잔여 Point가 부족합니다.")
				wf_goods_amt_clear()
				dw_member.setitem(1,"goods_amt",0)
				dw_member.SetColumn("goods_amt")
				return FALSE
			END IF
		
		// 만약 쿠폰이 없다면 잔여 포인트와 사용할 포인트만 비교한다  //
		if   ld_coupon_amt = 0  then 	 
		  IF ll_remain_point  < ll_goods_amt then
				MessageBox("Point 오류", "쿠폰도 없고 잔여 Point가 부족합니다.")
				wf_goods_amt_clear()
				dw_member.setitem(1,"goods_amt",0)
				dw_member.SetColumn("goods_amt")
				return FALSE
			END IF
		end if	
end if	

// 이 이후로는 쿠폰 또는 잔여포인트가 충분한 경우 로직임 //
	
//------------------------------------
	ll_goods_amt = dw_member.GetitemNumber(1, "goods_amt")  
	
	IF isnull(ll_goods_amt) THEN ll_goods_amt = 0 
	 
// 만약 사용할 금액이 쿠폰 금액이 충분하다면  //


if  ld_coupon_amt > 0  and ll_goods_amt >= ld_coupon_amt  then	  	    		
	   FOR i=1 TO ll_row_count
			ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))				
			ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
			ls_style_no   = dw_body.Getitemstring(i, "style_no")
			ls_item       = RightA(LeftA(ls_style_no,2),1)
			ld_dc_rate    = dw_body.GetitemDecimal(i, "dc_rate")
		    // 가장 최저가 상품에 구매할인권을 쓰게 처리 						 
				IF  ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ld_dc_rate < 31 THEN  	
					 k = k + 1
					if k= 1 then
						ll_sale_price2 = ll_sale_price 
					end if
								
					if ll_sale_price <= ll_sale_price2 then				
						for j = 1 to i
							 dw_body.Setitem(j,"coupon_no", '')
							 dw_body.Setitem(j,"goods_amt", 0)																									
						next	
						
					  	CHOOSE CASE wf_yes_no(This.title)   // 쿠폰 사용할지 확인 
							CASE 1    
								ll_sale_price2 = ll_sale_price 
								ls_coupon_yn = 'y'						
								dw_body.Setitem(i,"coupon_no", ls_coupon_no)
								dw_body.Setitem(i,"goods_amt", ld_coupon_amt)
								
								// 쿠폰 쓰고 남은 금액 다시 계산 //
								ll_goods_amt = ll_goods_amt - ld_coupon_amt	
								ll_goods_amt = ll_goods_amt / 10000
								ll_goods_amt = ll_goods_amt * 10000		
								i = ll_row_count
						END CHOOSE	
						
					end if					
				END IF
	    NEXT
		 
		IF ld_coupon_amt = ll_accept_point and ls_coupon_yn = 'y' then
   	   messagebox('쿠폰사용 끝', ls_coupon_no)		
			return true
		END IF
 elseif  ll_goods_amt < ld_coupon_amt and  ll_goods_amt < 30000  THEN 
	   MessageBox("확인", "마일리지는 30000원 이상부터 사용할수 있습니다.")  
   return false
 end if
	

// 더 쓸 금액이 없으면 종료 //
if ls_date_chk <= "20090224"   then

else
	IF ll_goods_amt  > ll_remain_point  OR  ll_goods_amt < 30000  THEN 
		ld_tot_goods_amt =  dw_body.Getitemdecimal(1,"tot_goods_amt")
		dw_member.setitem (1, "goods_amt", ld_tot_goods_amt )	
		ld_tot_goods_amt =  dw_member.Getitemdecimal(1,"goods_amt")
		MessageBox("확인", "총" + string(ld_tot_goods_amt) + " 만큼만 사용합니다1.")  
		return true
	END IF
end if

	
	ld_mok = MOD(ll_goods_amt , 10000) 
	
	if ld_mok <> 0 then
		MessageBox("Point 오류", "1PCS에 10000원 단위로 입력하세요. ")
		wf_goods_amt_clear()
		dw_member.setitem(1,"goods_amt",0)
		dw_member.SetColumn("goods_amt")
		return false    
	end if
	
    	
	/* point 판매 처리 및 가능여부 체크 (정상판매단가가  Point금액 이상 매출만 가능)*/
	
	FOR i=1 TO ll_row_count
		
		ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))
		ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
		ls_style_no   = dw_body.Getitemstring(i, "style_no")
		ls_item       = RightA(LeftA(ls_style_no,2),1)
		ls_coupon_no  = dw_body.Getitemstring(i, "coupon_no")
		ld_dc_rate    = dw_body.GetitemDecimal(i, "dc_rate")
		
		IF ls_coupon_no = '' then					 
				IF ll_goods_amt > 0 and ll_sale_price > ll_goods_amt and  & 
					ll_sale_qty  > 0 and ld_dc_rate  < 31 THEN  
					ls_sale_fg = '2' 
					 if ls_date_chk <= '20090224' then
						if ll_goods_amt >=  20000 then 
							dw_body.Setitem(i,"goods_amt", ll_goods_amt)	
							messagebox('확인', '마일리지 ' + string(ll_goods_amt) + '원 사용')
							ll_goods_amt = 0
						 
						else 	
							dw_body.Setitem(i,"goods_amt", 0)
							ls_sale_fg = '1' 
						end if
					else
						if ll_goods_amt >=  30000 then 
							dw_body.Setitem(i,"goods_amt", ll_goods_amt)	
							messagebox('확인', '마일리지 ' + string(ll_goods_amt) + '원 사용')
							ll_goods_amt = 0
						 
						else 	
							dw_body.Setitem(i,"goods_amt", 0)
							ls_sale_fg = '1' 
						end if
					end if	
				ELSE
					dw_body.Setitem(i,"goods_amt", 0)
					ls_sale_fg = '0' 
				END IF				 
				dw_body.setitem(i,"sale_fg",ls_sale_fg)
		END IF
	NEXT	
	
	ld_tot_goods_amt =  dw_body.Getitemdecimal(1,"tot_goods_amt")
	 
   dw_member.setitem(1, "goods_amt", ld_tot_goods_amt ) 
  
	
	IF ld_tot_goods_amt  = ld_goods_amt THEN  
		RETURN TRUE 
	ELSE
	   ld_tot_goods_amt =  dw_member.Getitemdecimal(1,"goods_amt")
		MessageBox("확인", "총" + string(ld_tot_goods_amt) + " 만큼만 사용합니다2.")
		RETURN true
	END IF
	
	IF ll_goods_amt > 30000   then
		MessageBox("Point 오류", "사용할 Point가 구매할 상품보다 많습니다.")
		MessageBox("ll_goods_amt", ll_goods_amt)
		 wf_goods_amt_clear()
		 dw_member.setitem(1,"goods_amt",0)
		 dw_member.SetColumn("goods_amt")
		RETURN false	
	END IF 
	
				

		
RETURN FALSE







end function

public subroutine wf_amt_set (long al_row, long al_sale_qty, long al_sale_price);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_out_price, ll_collect_price, ll_local_price, ll_sale_price
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect ,ll_sale_collect1
Decimal ldc_marjin

IF dw_body.AcceptText() <> 1 THEN RETURN

ll_tag_price     = dw_body.GetitemDecimal(al_row, "tag_price") 
ll_curr_price    = dw_body.GetitemDecimal(al_row, "curr_price") 
ll_out_price     = dw_body.GetitemNumber(al_row, "out_price") 
ll_collect_price = dw_body.GetitemNumber(al_row, "collect_price")
ll_local_price   = dw_body.GetitemNumber(al_row, "local_price")
if dw_body.GetitemDecimal(al_row, "sale_price") <= 0 then
	al_sale_price    = ll_local_price * il_rates
end if	

dw_body.Setitem(al_row, "tag_amt",  ll_tag_price  * al_sale_qty)
dw_body.Setitem(al_row, "curr_amt", ll_curr_price * al_sale_qty)
dw_body.Setitem(al_row, "sale_price", al_sale_price)
ll_sale_price = dw_body.GetitemDecimal(al_row, "sale_price")
dw_body.Setitem(al_row, "sale_amt", al_sale_price * al_sale_qty)
dw_body.Setitem(al_row, "out_amt",  ll_out_price  * al_sale_qty)
if al_sale_qty < 0 then
	dw_body.Setitem(al_row, "sale_price", al_sale_price * -1)
	dw_body.setitem(al_row, "local_price", ll_local_price * -1)
end if

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
	if MidA(is_shop_cd,2,1) = "G" then 
		ll_sale_collect = ll_sale_collect1 - (ll_goods_amt * ldc_marjin / 100)
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
		and isnull(tag_price, 0) <> 0
		and isnull(for_lotte,'N') = 'Y'	;
		
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
		and isnull(tag_price, 0) <> 0
		and isnull(for_lotte,'N') = 'Y';
		
	end if		
	
IF SQLCA.SQLCODE <> 0 or ll_cnt < 1 THEN 
	Return False 
END IF 


		
if is_shop_type = "4" and LenA(ls_style) = 8 then
		Select shop_type
		into :ls_shop_type
		From tb_56012_d with (nolock)
		Where style      = :ls_style 
		  and start_ymd <= :is_yymmdd
		  and end_ymd   >= :is_yymmdd
		  and shop_cd    = :is_shop_cd ;

		
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
from beaucre.dbo.tb_12020_m with (nolock)
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

public function boolean wf_style_set (long al_row, string as_style);Long    ll_curr_price,  ll_out_price
Long    ll_sale_price,  ll_collect_price 
String  ls_sale_type = space(2)
decimal ldc_out_marjin, ldc_sale_marjin, ldc_dc_rate


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

public function integer wf_yes_no (string as_title);/*=================================================================*/
/* 작 성 자 : 지우정보                                             */	
/* 내    용 : 수정 자료 저장여부 확인                              */
/*=================================================================*/

RETURN  MessageBox(as_title,'쿠폰을 사용하시겠습니까?', &
			          Question!, YesNo!)


end function

on w_59001_e.create
int iCurrent
call super::create
this.dw_member=create dw_member
this.st_1=create st_1
this.cb_input=create cb_input
this.st_2=create st_2
this.dw_member_sale=create dw_member_sale
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_member
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_input
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.dw_member_sale
this.Control[iCurrent+6]=this.dw_list
end on

on w_59001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_member)
destroy(this.st_1)
destroy(this.cb_input)
destroy(this.st_2)
destroy(this.dw_member_sale)
destroy(this.dw_list)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
/*===========================================================================*/
String   ls_title, ls_shop_grp

IF as_cb_div = '1' THEN
	ls_title = "Query Error"
ELSEIF as_cb_div = '2' THEN
	ls_title = "Add Error"
ELSEIF as_cb_div = '3' THEN
	ls_title = "Save Error"
ELSE
	ls_title = "Error"
END IF

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"Enter the Brand code!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"Enter the Shop code!!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

 
if MidA(is_shop_cd,1,1) <> is_brand then
   MessageBox(ls_title,"Brands and shops the code does not match!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
	is_style = "%"
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
	is_chno = "%"
end if

il_rates = dw_head.GetItemNumber(1, "rates")
if IsNull(il_rates) or il_rates = 0 then
   MessageBox(ls_title,"Enter the rate!")
   dw_head.SetFocus()
   dw_head.SetColumn("rates")
   return false
end if

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

select shop_grp
into :ls_shop_grp
from tb_91100_m (nolock)
where shop_cd = :is_shop_cd;

if ls_shop_grp <> "01" then 
		st_2.text = "※ 등록은 제품이 진행되는 롯데계열에서만 가능합니다."
		RETURN FALSE
else 	
			st_2.text = ""	
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
string     ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_year, ls_season, ls_tel_no
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm3(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					
					select tel_no
					into :ls_tel_no
					from tb_91100_m (nolock)
					where shop_cd = :as_data;
					
				   dw_head.SetItem(al_row, "tel_no", ls_tel_no)					
						
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "Shop Code Search" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' and shop_div = 'T' " + &
											 "  AND Shop_cd in (select shop_cd from tb_91130_m with (nolock)) "
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
//				from beaucre.dbo.tb_12020_m with (nolock)
//				where style like :ls_style + '%';
//				
//				if ls_bujin_chk = "Y" then 
//				messagebox("부진체크", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
//				end if 					
			END IF
				
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "Style Code Search" 
			gst_cd.datawindow_nm   = "d_com013" 
			gst_cd.default_where   = "WHERE brand = '" + is_brand + "' " + &
			                         "  AND isnull(tag_price, 0) <> 0  " //+ &
//			                         "  AND reg_id <> 'auto' "
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
				ls_sojae = lds_Source.GetItemString(1,"sojae")				
				ls_year = lds_Source.GetItemString(1,"year")					
				ls_season = lds_Source.GetItemString(1,"season")					
				
			IF ls_style  <> 'NC5AJ973' AND ls_style <> 'NC5AJ911' AND ls_style <> 'NC5AL911' AND ls_style <> 'NC5AJ910' AND ls_style <> 'NC5MB628' AND ls_style <> 'NC5AS910' AND ls_style <> 'NC5MB962' AND ls_style <> 'NC5MB964' AND ls_style <> 'NC5MJ965' AND ls_style <> 'NC5AJ913' AND ls_style <> 'NC5AL913' AND ls_style <> 'NC5AS913' AND ls_style <> 'NC5AJ915' AND ls_style <> 'NC5AL915' AND ls_style <> 'NC5AS915' THEN 				
				if is_shop_type <> '9' and ls_sojae = "C" and LeftA(ls_style,1) <> 'B' and LeftA(ls_style,1) <> 'P' and LeftA(ls_style,1) <> 'K'  then					
					messagebox("경고!", "중국수출 모델은 기타에서만 등록 가능합니다!")
					ib_itemchanged = FALSE
					return 1
				end if	
			END IF
			
				if is_shop_type = "4" then			
					
						Select shop_type
						into :ls_shop_type
						From tb_56012_d with (nolock)
						Where style      = :ls_style 
						  and start_ymd <= :is_yymmdd
						  and end_ymd   >= :is_yymmdd
						  and shop_cd    = :is_shop_cd ;
						  
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
				from beaucre.dbo.tb_12020_m with (nolock)
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
					dw_body.SetItem(al_row, "local_price",     0)
					dw_body.SetItem(al_row, "sale_price",  dw_body.getitemDecimal(al_row, "local_price") * il_rates * dw_body.getitemnumber(al_row, "sale_qty") )
					dw_body.SetItem(al_row, "sale_amt",   dw_body.getitemDecimal(al_row, "local_price") * il_rates  * dw_body.getitemnumber(al_row, "sale_qty") )
					dw_body.SetItem(al_row, "real_price",  dw_body.getitemDecimal(al_row, "local_price") * il_rates * dw_body.getitemnumber(al_row, "sale_qty") )
					
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

	CASE "card_no", "jumin" ,"tel_no3"		
			IF ai_div = 1 THEN 	
				IF as_column = "card_no" THEN 
					ls_flag = '2'
				ELSEif as_column = "tel_no3" THEN 
					ls_flag = '3'
				else
					ls_flag = '1'						
				END IF
				IF wf_member_set(ls_flag, as_data)  THEN
					RETURN 0 
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = "Where card_no is not null"
			IF Trim(as_data) <> "" THEN 
				IF as_column = "card_no" THEN
               gst_cd.Item_where = "card_no LIKE '4870090" + as_data + "%'"
				ELSEif as_column = "jumin" THEN
               gst_cd.Item_where = "jumin   LIKE '" + as_data + "%'"
				ELSEif as_column = "tel_no3" THEN
               gst_cd.Item_where = " replace(tel_no3,'-','') = replace('" + as_data + "','-','')"				
				END IF
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
				   dw_member.SetRow(al_row)
				   dw_member.SetColumn(as_column)
				END IF
				dw_member.SetItem(1, "card_no",      RightA(lds_Source.GetItemString(1,"card_no"), 9)) 
				dw_member.SetItem(1, "jumin",        lds_Source.GetItemString(1,"jumin")) 
				dw_member.SetItem(1, "user_name",    lds_Source.GetItemString(1,"user_name")) 
				dw_member.SetItem(1, "total_point",  lds_Source.GetItemNumber(1,"total_point")) 
				dw_member.SetItem(1, "accept_point", lds_Source.GetItemNumber(1,"accept_point")) 
				ls_jumin = lds_Source.GetItemString(1,"jumin")
            GF_GET_AGEGRP(ls_jumin, integer(LeftA(is_yymmdd, 4)), ls_age_grp)
				dw_member.SetItem(1, "age_grp", ls_age_grp) 
			   ib_changed        = true
            cb_update.enabled = true
			   /* 다음컬럼으로 이동 */
			   dw_member.SetColumn("sale_qty")
		      lb_check       = TRUE 
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

il_rows = dw_list.retrieve(is_brand, is_yymmdd, is_shop_cd, is_shop_type, is_style, is_chno)

IF il_rows >= 0 THEN
   dw_list.visible   = True
   dw_body.visible   = False
   dw_member.visible = False
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(cb_input,   "FixedToRight")
inv_resize.of_Register(dw_list,   "ScaleToRight&Bottom")
inv_resize.of_Register(st_1,      "ScaleToRight&Bottom")
inv_resize.of_Register(dw_member, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_member_sale,   "ScaleToRight&Bottom")


dw_member_sale.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_member.InsertRow(0)

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
         cb_input.Text      = "INPUT(&I)"
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
      cb_input.Text = "INPUT(&I)"
      cb_insert.enabled  = false
      cb_delete.enabled  = false
      cb_print.enabled   = false
      cb_preview.enabled = false
      cb_excel.enabled   = false
      cb_update.enabled  = false
      ib_changed         = false
      dw_body.Enabled    = false
      dw_member.Enabled  = false
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
				dw_member.object.goods_amt.protect = 0 	
	         dw_body.SetFocus()				
			else	
				messagebox("Caution!", "Sales data can not be modified! Please contact your administrator!")
// 	          dw_body.Enabled    = false
    			 cb_insert.enabled  = false
             cb_delete.enabled  = false				
 				dw_member.object.goods_amt.protect = 1
			end if	
         dw_member.Enabled  = true
         ib_changed = false
         cb_update.enabled = false
         cb_input.Text = "INPUT(&I)"
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
String	ls_sale_type, ls_color, ls_size
long     ll_sale_price, ll_goods_amt, ll_sale_qty 
long     i, ll_row_count, ll_chk, ll_no
decimal  ldc_dc_rate, ld_goods_amt
datetime ld_datetime 

IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_member.AcceptText()    <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

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
   ls_sale_no = dw_body.GetitemString(1, "sale_no")
ELSEIF Gf_Get_Saleno2(is_yymmdd, is_shop_cd, is_shop_type, ls_sale_no) <> 0 THEN 
	Return -1 
END IF

select right(isnull(max(NO), 0) + 10001, 4)
into :ll_no
from tb_53013_h(nolock) 
where yymmdd    =  :is_yymmdd
and shop_cd   =  :is_shop_cd
and sale_no   =  :ls_sale_no ; 

/* 교환권 판매 처리 및 가능여부 체크 (정상판매단가가  교환권금액 이상 매출만 가능)*/
ll_goods_amt = dw_member.GetitemNumber(1, "goods_amt")
IF isnull(ll_goods_amt) THEN ll_goods_amt = 0
	ls_card_no   = dw_member.GetitemString(1, "card_no")
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
			dw_body.Setitem(i, "age_grp", dw_member.Object.age_grp[1])  
			dw_body.Setitem(i, "sale_fg", ls_sale_fg)
			dw_body.Setitem(i, "jumin",   Trim(dw_member.Object.jumin[1]))  
			dw_body.Setitem(i, "card_no", ls_card_no) 			
			ll_no = ll_no + 1 
			
			//curr이 안들어 갔으면 다시 넣어주기
			if isnull(dw_body.GetitemNumber(i, "curr_price")) or dw_body.GetitemNumber(i, "curr_price") = 0 then      
				wf_style_set(i, dw_body.Getitemstring(i,MidA('style_no',1,8)))
				messagebox('Check!', 'Enter the Local_price!')
				dw_head.SetFocus()
				dw_head.SetColumn("Local_price")
				return 0
			end if

			//local_price이 안들어 갔으면 다시 넣어주기
			if isnull(dw_body.GetitemNumber(i, "local_price")) or dw_body.GetitemNumber(i, "local_price") = 0 then      
				wf_style_set(i, dw_body.Getitemstring(i,MidA('style_no',1,8)))
				messagebox('Check!', 'Enter the Local_price!')
				dw_head.SetFocus()
				dw_head.SetColumn("Local_price")
				return 0
			end if					
			
			//style_no가 팝업을 통하여 안들어 갔있으면,
			if isnull(dw_body.Getitemstring(i, "style_no")) or dw_body.Getitemstring(i, "style_no") = '' or LenA(dw_body.Getitemstring(i, "style_no")) < 9 or			isnull(dw_body.Getitemstring(i, "style")) or dw_body.Getitemstring(i, "style") = '' or LenA(dw_body.Getitemstring(i, "style")) < 8 then      
	//			wf_style_chk(i,dw_body.Getitemstring(i,mid('style_no',1,8)))
	//			messagebox('Check!', 'You have to Enter the style code with Popup Windows!')
				messagebox('Check!', 'Style code must enter through a Popup Windows!')
				dw_body.SetFocus()
				dw_body.SetColumn("Style_no")			
				return 0
			end if			
			
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
			dw_body.Setitem(i, "mod_id", gs_user_id)
			dw_body.Setitem(i, "mod_dt", ld_datetime)
			dw_body.Setitem(i, "age_grp", dw_member.Object.age_grp[1])  
			dw_body.Setitem(i, "sale_fg", ls_sale_fg)
			dw_body.Setitem(i, "jumin",   Trim(dw_member.Object.jumin[1]))  
			dw_body.Setitem(i, "card_no", ls_card_no) 				
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
						ELSEIF LenA(ls_card_no) = 16 and LeftA(dw_body.Object.sale_type[i], 1) < '2' THEN  // 정상 적용 
							ls_sale_fg = '1' 
						ELSE
							ls_sale_fg = '0' 
						END IF
				
			ELSE		//마일리지는 정상+sale 만 사용가능 
				
						IF ll_goods_amt > 0 and ll_sale_price > ll_goods_amt and  & 
							ll_sale_qty  > 0 and dw_body.Object.dc_rate[i]  < 31 THEN 
							ls_sale_fg = '2' 	
						ELSEIF LenA(ls_card_no) = 16 and LeftA(dw_body.Object.sale_type[i], 1) < '2' THEN  // 정상 적용 
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
				dw_body.Setitem(i, "age_grp", dw_member.Object.age_grp[1])  
				dw_body.Setitem(i, "sale_fg", ls_sale_fg)
				dw_body.Setitem(i, "jumin",   Trim(dw_member.Object.jumin[1]))  
				dw_body.Setitem(i, "card_no", ls_card_no)  
			END IF
		ELSE 
			dw_body.Setitem(i, "sale_fg", '0')
		END IF 
		
		ls_sale_fg = dw_body.getitemstring(i,"sale_fg")
		ldc_dc_rate  = dw_body.getitemnumber(i, "dc_rate")	
		ls_sale_type = dw_body.getitemString(i, "sale_type")	
		
		
		
			ls_color = dw_body.GetitemString(i, "color")
			if isnull(ls_color) or  Trim(ls_color) = "" then 
				messagebox("Caution!", "Enter the Color!")
				return 0
			end if 		
			
			ls_size = dw_body.GetitemString(i, "size")	
			if isnull(ls_size) or  Trim(ls_size) = "" then 
				messagebox("Caution!", "Enter the Size!")
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
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event open;call super::open;string ls_shop_snm

dw_head.Setitem(1, "shop_type", '9')


select data_level
into :is_data_opt
from tb_93010_m with (nolock)
where person_id = :gs_user_id;

//gs_user_id
select shop_snm
into :ls_shop_snm
from TB_91100_M with (nolock)
where shop_cd = :gs_user_id;


if ls_shop_snm = '' or isnull(ls_shop_snm) then
else
	dw_head.setitem(1,'brand',MidA(gs_user_id,1,1))
	dw_head.setitem(1,'shop_cd', gs_user_id)
	dw_head.setitem(1,'shop_nm', ls_shop_snm )
end if

is_member_return = 'N' 
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53001_e","0")
end event

event pfc_dberror();//
end event

event ue_msg(integer ai_cb_div, long al_rows);call super::ue_msg;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/* ai_cb_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 6 - 삭제  */
/* al_rows     : 리턴값                                                      */
/*===========================================================================*/

String ls_msg

CHOOSE CASE ai_cb_div
   CASE 1      /* 조회 */
      CHOOSE CASE al_rows
         CASE IS > 0
            ls_msg = "Inquiry has been completed."
         CASE 0
            ls_msg = "No data to query."
         CASE IS < 0
            ls_msg = "Inquiry failed."
      END CHOOSE
   CASE 2      /* 추가 */
      IF al_rows > 0 THEN
         ls_msg = "Enter the data."
      ELSE
         ls_msg = "Data input has failed."
      END IF
   CASE 3      /* 저장 */
      IF al_rows = 1 THEN
         ls_msg = "Data has been saved."
      ELSE
         ls_msg = "Saving data has failed."
      END IF
   CASE 4      /* 삭제 */
      IF al_rows > 0 THEN
         ls_msg = "Data has been deleted."
      ELSE
         ls_msg = "Deletion of data failed."
      END IF
   CASE 5      /* 조건 */
      ls_msg = "Enter a query data."
   CASE 6      /* 인쇄 */
		IF al_rows = 1 THEN
         ls_msg = "Printing is complete."
      ELSE
         ls_msg = "Printing failed."
      END IF
END CHOOSE

This.ParentWindow().SetMicroHelp(ls_msg)

end event

type cb_close from w_com010_e`cb_close within w_59001_e
integer taborder = 140
string text = "EXIT(&X)"
end type

type cb_delete from w_com010_e`cb_delete within w_59001_e
integer taborder = 130
string text = "DEL(&D)"
end type

type cb_insert from w_com010_e`cb_insert within w_59001_e
integer taborder = 70
boolean enabled = false
string text = "ADD(&A)"
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_59001_e
integer x = 2839
integer width = 384
integer taborder = 40
string text = "QUERY(&Q)"
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

type cb_update from w_com010_e`cb_update within w_59001_e
string text = "SAVE(&S)"
end type

type cb_print from w_com010_e`cb_print within w_59001_e
boolean visible = false
integer taborder = 100
end type

type cb_preview from w_com010_e`cb_preview within w_59001_e
boolean visible = false
integer taborder = 110
end type

type gb_button from w_com010_e`gb_button within w_59001_e
end type

type cb_excel from w_com010_e`cb_excel within w_59001_e
boolean visible = false
integer taborder = 120
end type

type dw_head from w_com010_e`dw_head within w_59001_e
integer x = 18
integer y = 164
integer width = 3566
integer height = 280
string dataobject = "d_59001_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001') 



This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911') 

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
			  MessageBox("Caution!","That can not be entered is the date!")
			  Return 1
        END IF
	CASE "shop_cd"	,"style"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_59001_e
integer beginy = 456
integer endy = 456
end type

type ln_2 from w_com010_e`ln_2 within w_59001_e
integer beginy = 460
integer endy = 460
end type

type dw_body from w_com010_e`dw_body within w_59001_e
event ue_set_col ( string as_column )
integer x = 9
integer width = 3579
integer height = 1636
integer taborder = 50
string dataobject = "d_59001_d01"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event dw_body::ue_set_col(string as_column);This.SetColumn(as_column)
end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
Long    ll_ret, ll_sale_qty, ll_sale_price, ll_collect_price, ll_local_price, ll_rates
Decimal ldc_sale_marjin, ld_goods_amt
String  ll_null
SetNull(ll_null)
dw_body.accepttext()
CHOOSE CASE dwo.name
//	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1 
//		ll_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1) 
//		IF Len(This.GetitemString(row, "color")) = 2 THEN
//			This.Post Event ue_set_col("sale_qty")
//		END IF 
//		Return ll_ret
//	CASE "color"	    
//		This.Setitem(row, "size", ll_null) 
//		
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
			This.Setitem(row, "size", ll_null) 
			This.Post Event ue_set_col("size")
		end if			

	CASE "local_price"
		ll_local_price = dw_body.getitemdecimal(row,"local_price")
		ll_rates = dw_head.getitemdecimal(1,"rates")
		ll_sale_qty     = This.GetitemNumber(row, "sale_qty")
		ll_sale_price = ll_local_price * ll_rates * ll_sale_qty
		IF is_shop_type > '3' THEN 
         This.Setitem(row, "curr_price", ll_sale_price)
         This.Setitem(row, "out_price",  ll_collect_price)
		END IF 		
      /* 금액 처리           */		
		wf_amt_set(row, ll_sale_qty, ll_sale_price) 
		Parent.Post Event ue_tot_set()

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
      /* 금액처리           */
		wf_amt_set(row, ll_sale_qty, ll_sale_price) 
		Parent.Post Event ue_tot_set()

   CASE "sale_qty" 
		ll_sale_qty   = Long(Data) 
		IF isnull(ll_sale_qty) or ll_sale_qty = 0 THEN RETURN 1 
		
		ld_goods_amt = this.getitemdecimal(row,"goods_amt")
		
			IF Long(Data) < 0 then 
            this.setitem(row,"goods_amt", 0)
				dw_member.setitem(1,"goods_amt", 0)
				Parent.Post Event ue_tot_set()
			END IF
		dw_body.accepttext()
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

event dw_body::doubleclicked;call super::doubleclicked;String ls_style_no,   ls_yes 
Long   ll_curr_price, ll_sale_price, ll_collect_price, ll_sale_qty, ll_goods_amt, ll_local_price, ll_rates

IF row < 1 THEN RETURN 
ls_style_no = This.GetitemString(row, "style_no")

IF isnull(ls_style_no) or Trim(ls_style_no) = "" THEN RETURN
ll_goods_amt = This.GetitemDecimal(row, "goods_amt")
ll_sale_qty  = This.GetitemDecimal(row, "sale_qty")
ll_local_price = This.GetitemDecimal(row, "local_price")
ll_rates = dw_head.GetitemDecimal(1,'rates')
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
//	   ll_sale_price = ll_local_price * ll_rates * (100 - gdc_rate) / 100 
	ELSE
	   ll_curr_price = This.GetitemNumber(row, "curr_price")
	   ll_sale_price = ll_curr_price * (100 - gdc_rate) / 100 
//	   ll_sale_price = ll_local_price * ll_rates * (100 - gdc_rate) / 100 
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
			messagebox("check!", "Enter the color code!")
			return 0
		end if 		
		
		if isnull(ls_size) or  Trim(ls_size) = "" then 
			messagebox("check!", "Enter the size code!")
			return 0
		end if 						
		
END CHOOSE


end event

event dw_body::dberror;//
end event

type dw_print from w_com010_e`dw_print within w_59001_e
end type

type dw_member from datawindow within w_59001_e
event ue_keydown pbm_dwnkey
event type long ue_item_changed ( long row,  dwobject dwo,  string data )
boolean visible = false
integer x = 14
integer y = 1664
integer width = 3570
integer height = 456
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_59001_d10"
boolean livescroll = true
borderstyle borderstyle = styleraised!
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
	CASE "card_no", "jumin","tel_no3"	    
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "goods_amt" 
			ld_goods_amt = this.getitemdecimal(1,"goods_amt")
			IF not wf_goods_chk(long(ld_goods_amt))  THEN 
            this.setitem(1,"goods_amt", 0)
				dw_member.SetColumn("goods_amt")
				Parent.Post Event ue_tot_set()
				RETURN 1
			END IF
			
	
END CHOOSE 


end event

event itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
string ls_sale_type
string  ls_coupon_no
decimal ld_goods_amt, ll_sale_qty, ll_sale_amt
long    i, ll_row_count

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false



post event ue_item_changed(row, dwo, data)
end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report
String ls_jumin

IF dwo.name = "b_member" THEN 
	gsv_cd.gs_cd1 = is_shop_cd 
	OpenWithParm (W_53001_S2, "W_53001_S2 신규회원접수") 
   ls_jumin = Message.StringParm 
	IF isnull(ls_jumin) = False and LenA(Trim(ls_jumin)) = 13 THEN
		wf_member_set('1', ls_jumin) 
		IF dw_body.RowCount() > 0 THEN 
	      IF dw_body.GetitemStatus(1, 0, Primary!) <> New! THEN 
            ib_changed = true
            cb_update.enabled = true
				Return 
	      END IF
      END IF
	END IF
END IF

IF dwo.name = "b_return" THEN 
	ls_jumin = dw_member.GetitemString(1, "jumin")
	IF isnull(ls_jumin) or ls_jumin = "" Then
		messagebox('확인', '고객정보를 먼저 입력 하세요!')	  
		return	0
	END IF
   dw_member_sale.Retrieve(ls_jumin)
	dw_member_sale.visible =true	
END IF	




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

event constructor;DataWindowChild ldw_child 

This.GetChild("age_grp", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('403')

end event

event itemerror;Return 1
end event

type st_1 from statictext within w_59001_e
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

type cb_input from commandbutton within w_59001_e
event ue_keydown pbm_keydown
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
string text = "INPUT(&I)"
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

type st_2 from statictext within w_59001_e
boolean visible = false
integer x = 41
integer y = 392
integer width = 2286
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "☞ 주의: 악세사리는 2005.04.01 부터 할인권 적용이 가능합니다!"
boolean focusrectangle = false
end type

type dw_member_sale from datawindow within w_59001_e
boolean visible = false
integer x = 5
integer y = 372
integer width = 3607
integer height = 1632
integer taborder = 60
boolean titlebar = true
string title = "고객구매조회"
string dataobject = "d_59001_d31"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event buttonclicked;string     ls_style, ls_chno, ls_color, ls_size,ls_style_no,ls_sale_type,ls_age_grp,ls_sale_fg,ls_jumin, ls_card_no,ls_coupon_no 
string	  ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_shop_div, ls_plan_yn,ls_shop_type, ls_return_yn
decimal    ld_sale_qty, ld_tag_price,ld_curr_price, ld_dc_rate, ld_sale_price,ld_tag_amt,ld_curr_amt,ld_sale_amt  
decimal    ld_out_rate, ld_out_amt, ld_sale_rate ,ld_sale_collect,ld_goods_amt,ld_io_amt, ld_io_vat  
long       ll_row_count, i

IF row < 1 THEN RETURN

dw_body.Reset()

ll_row_count = This.RowCount()

FOR i = ll_row_count to 1 step -1 
	ls_return_yn = This.GetitemString(i, "return_yn")	 
	IF  ls_return_yn <> 'Y' THEN
		dw_member_sale.DeleteRow(i) 
	END IF
NEXT 

ll_row_count = This.RowCount()

FOR i = 1 to ll_row_count  		
		ls_style       = This.GetitemString(i, "style")
		ls_chno        = This.GetitemString(i, "chno")
		ls_color       = This.GetitemString(i, "color")
		ls_size        = This.GetitemString(i, "size")
		ls_style_no    = This.GetitemString(i, "style_no")
		ls_sale_type	= This.GetitemString(i, "sale_type")
		ls_age_grp		= This.GetitemString(i, "age_grp")
		ls_sale_fg		= This.GetitemString(i, "sale_fg")
		ls_jumin			= This.GetitemString(i, "jumin")
		ls_card_no		= This.GetitemString(i, "card_no")
		ls_coupon_no	= This.GetitemString(i, "coupon_no") 
		ls_brand 		= This.GetitemString(i, "brand")
		ls_year 			= This.GetitemString(i, "year")
		ls_season  		= This.GetitemString(i, "season")
		ls_sojae 		= This.GetitemString(i, "sojae")
		ls_item 			= This.GetitemString(i, "item")
		ls_shop_div		= This.GetitemString(i, "shop_div")
		ld_sale_qty		= This.GetitemDecimal(i, "sale_qty") * -1	
		ld_tag_price	= This.GetitemDecimal(i, "tag_price") 	
		ld_curr_price 	= This.GetitemDecimal(i, "curr_price") 	
		ld_dc_rate		= This.GetitemDecimal(i, "dc_rate") 	 
		ld_sale_price	= This.GetitemDecimal(i, "sale_price") 	
		ld_tag_amt		= This.GetitemDecimal(i, "tag_amt") 	* -1	
		ld_curr_amt		= This.GetitemDecimal(i, "curr_amt") * -1		
		ld_sale_amt		= This.GetitemDecimal(i, "sale_amt")  * -1	 		
		ld_out_rate		= This.GetitemDecimal(i, "out_rate") 	
		ld_out_amt  	= This.GetitemDecimal(i, "out_amt") 	* -1	
		ld_sale_rate   = This.GetitemDecimal(i, "sale_rate") 	
		ld_sale_collect = This.GetitemDecimal(i, "sale_collect") 	* -1	
		ld_goods_amt	= This.GetitemDecimal(i, "goods_amt")   * -1	
		ld_io_amt		= This.GetitemDecimal(i, "io_amt") * -1	
		ld_io_vat		= This.GetitemDecimal(i, "io_vat") * -1		
		
		
		dw_body.insertrow(i)
		
		select  plan_yn 
		into	 :ls_plan_yn
		from    tb_12020_m (nolock)
		where   style = :ls_style;
		
		if  ls_plan_yn = 'Y' then
		 ls_shop_type = '3'
		else
		 ls_shop_type = '1'
		end if
		
		
		dw_body.Setitem(i, "style",ls_style)
		dw_body.Setitem(i, "chno",ls_chno)
		dw_body.Setitem(i, "color",ls_color)
		dw_body.Setitem(i, "size",ls_size)
		dw_body.Setitem(i, "shop_type",ls_shop_type)
		dw_body.Setitem(i, "style_no",ls_style_no)
		dw_body.Setitem(i, "sale_type",ls_sale_type)
		dw_body.Setitem(i, "age_grp",ls_age_grp)
		dw_body.Setitem(i, "sale_fg",ls_sale_fg)
		dw_body.Setitem(i, "jumin",ls_jumin)
		dw_body.Setitem(i, "card_no",ls_card_no)
		dw_body.Setitem(i, "coupon_no",ls_coupon_no) 
		dw_body.Setitem(i, "brand",ls_brand)
		dw_body.Setitem(i, "year",ls_year)
		dw_body.Setitem(i, "season",ls_season)
		dw_body.Setitem(i, "sojae",ls_sojae)
		dw_body.Setitem(i, "item",ls_item)
		dw_body.Setitem(i, "shop_div",ls_shop_div)
		dw_body.Setitem(i, "sale_qty",ld_sale_qty)  	
		dw_body.Setitem(i, "tag_price",ld_tag_price) 	
		dw_body.Setitem(i, "curr_price",ld_curr_price) 	
		dw_body.Setitem(i, "dc_rate",ld_dc_rate) 	 
		dw_body.Setitem(i, "sale_price",ld_sale_price) 	
		dw_body.Setitem(i, "tag_amt",ld_tag_amt) 	 
		dw_body.Setitem(i, "curr_amt",ld_curr_amt)  	
		dw_body.Setitem(i, "sale_amt",ld_sale_amt) 	
		dw_body.Setitem(i, "out_amt",ld_out_amt) 	 
		dw_body.Setitem(i, "sale_rate",ld_sale_rate) 	
		dw_body.Setitem(i, "sale_collect",ld_sale_collect) 	 
		dw_body.Setitem(i, "goods_amt",ld_goods_amt) 	
		dw_body.Setitem(i, "io_amt",ld_io_amt)  
		dw_body.Setitem(i, "io_vat", ld_io_vat)  
NEXT

 is_member_return = 'Y'



Parent.Post Event ue_tot_set()
dw_member.Setitem(1, "goods_amt", ld_goods_amt)


IF isnull(ls_jumin) = FALSE AND Trim(ls_jumin) <> "" THEN
   wf_member_set('1', ls_jumin)
	dw_member.Setitem(1, "coupon_no", ls_coupon_no)
ELSE
   Setnull(ls_jumin)
   dw_member.SetItem(1, "card_no",      ls_jumin)
   dw_member.SetItem(1, "user_name",    ls_jumin)
   dw_member.SetItem(1, "jumin",        ls_jumin)
   dw_member.Setitem(1, "total_point",  0)
   dw_member.Setitem(1, "give_point",   0)
   dw_member.Setitem(1, "accept_point", 0)
	dw_member.Setitem(1, "age_grp",ls_age_grp)
	
END IF

dw_body.visible = TRUE 
dw_member.visible    = TRUE 
dw_member_sale.visible = FALSE


cb_update.enabled = true

end event

event constructor;DataWindowChild ldw_child 


This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')



This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')


end event

type dw_list from datawindow within w_59001_e
boolean visible = false
integer x = 9
integer y = 468
integer width = 3575
integer height = 1676
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "d_59001_d08"
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
String ls_sale_no, ls_jumin , ls_coupon_no ,ls_no

IF row < 1 THEN RETURN 


is_shop_type = This.GetitemString(row, "shop_type")
ls_sale_no   = This.GetitemString(row, "sale_no") 
ls_jumin     = This.GetitemString(row, "jumin")
ls_coupon_no = This.GetitemString(row, "coupon_no")
ls_no        = This.GetitemString(row, "no")

dw_head.Setitem(1, "shop_type", is_shop_type) 

if dwo.name <> "no" then 
	dw_body.Retrieve(is_yymmdd, is_shop_cd, is_shop_type, ls_sale_no, "%")
else	
	dw_body.Retrieve(is_yymmdd, is_shop_cd, is_shop_type, ls_sale_no, ls_no )
end if	


dw_member.Setitem(1, "goods_amt", Long(dw_body.Describe("evaluate('sum(goods_amt)',0)")))

IF isnull(ls_jumin) = FALSE AND Trim(ls_jumin) <> "" THEN
   wf_member_set('1', ls_jumin) 
	dw_member.Setitem(1, "coupon_no", ls_coupon_no)
ELSE
   Setnull(ls_jumin)
   dw_member.SetItem(1, "card_no",      ls_jumin)
   dw_member.SetItem(1, "user_name",    ls_jumin)
   dw_member.SetItem(1, "jumin",        ls_jumin)
   dw_member.Setitem(1, "total_point",  0)
   dw_member.Setitem(1, "give_point",   0)
   dw_member.Setitem(1, "accept_point", 0)
	dw_member.Setitem(1, "age_grp", This.GetitemString(row, "age_grp"))
END IF
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

