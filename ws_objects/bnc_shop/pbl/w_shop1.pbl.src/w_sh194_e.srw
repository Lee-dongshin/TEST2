$PBExportHeader$w_sh194_e.srw
$PBExportComments$본사 판매반품 요청
forward
global type w_sh194_e from w_com010_e
end type
type dw_1 from datawindow within w_sh194_e
end type
type cb_1 from commandbutton within w_sh194_e
end type
type st_1 from statictext within w_sh194_e
end type
type st_2 from statictext within w_sh194_e
end type
type dw_15 from datawindow within w_sh194_e
end type
type st_ok_coupon1 from statictext within w_sh194_e
end type
type st_ok_coupon2 from statictext within w_sh194_e
end type
type shl_member from statichyperlink within w_sh194_e
end type
type dw_17 from datawindow within w_sh194_e
end type
type em_1 from editmask within w_sh194_e
end type
type st_8 from statictext within w_sh194_e
end type
type st_9 from statictext within w_sh194_e
end type
type dw_list from datawindow within w_sh194_e
end type
type shl_manual from statichyperlink within w_sh194_e
end type
type dw_member_sale from datawindow within w_sh194_e
end type
type dw_back_sale from datawindow within w_sh194_e
end type
end forward

global type w_sh194_e from w_com010_e
integer width = 2990
integer height = 2320
string title = "예약판매등록"
boolean ib_closestatus = true
event ue_tot_set ( )
dw_1 dw_1
cb_1 cb_1
st_1 st_1
st_2 st_2
dw_15 dw_15
st_ok_coupon1 st_ok_coupon1
st_ok_coupon2 st_ok_coupon2
shl_member shl_member
dw_17 dw_17
em_1 em_1
st_8 st_8
st_9 st_9
dw_list dw_list
shl_manual shl_manual
dw_member_sale dw_member_sale
dw_back_sale dw_back_sale
end type
global w_sh194_e w_sh194_e

type variables
String is_yymmdd, is_fr_yymmdd, is_to_yymmdd, is_sale_no, is_member_return, idw_give_amt, is_use_shop, is_ok_coupon = "N", is_dotcom_select = "N", is_mj_bit = 'N', is_coupon_gubn
long id_remain_point
decimal idc_dc_rate_org
datawindowchild idw_shop_cd, idw_sale_type, idw_shop_type, idw_event_id

string is_close_ymd_t, is_year_t, is_season_t, is_season_nm_t, is_season_s_t, is_s_gubn_t, is_e_gubn_t, is_p_gubn_t
string is_close_ymd_f, is_year_f, is_season_f, is_season_nm_f, is_season_s_f, is_s_gubn_f, is_e_gubn_f, is_p_gubn_f
string is_set_style_chk , ld_datetime2
end variables

forward prototypes
public function integer wf_yes_no (string as_title)
public subroutine wf_ok_coupon (integer al_row, string as_ok_coupon)
public function boolean uf_chk_birthday (string as_birthday, ref string as_jumin, ref string as_user_name, ref string as_tel_no3)
public function boolean uf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name)
public function boolean uf_member_chk (string as_flag, string as_find)
public function integer uf_yes_no_imsi (string as_user_name)
public subroutine wf_amt_clear ()
public subroutine wf_amt_set3 (long al_row)
public function boolean wf_close_check (string as_brand, ref string as_close_ymd_t, ref string as_year_t, ref string as_season_t, ref string as_season_nm_t, ref string as_season_s_t, ref string as_gubn_1_t, ref string as_gubn_2_t, ref string as_gubn_3_t, ref string as_close_ymd_f, ref string as_year_f, ref string as_season_f, ref string as_season_nm_f, ref string as_season_s_f, ref string as_gubn_1_f, ref string as_gubn_2_f, ref string as_gubn_3_f)
public function boolean wf_give_rate_chk (integer al_give_rate, string as_coupon_date)
public subroutine wf_goods_amt_clear ()
public subroutine wf_line_chk (long al_row)
public function integer wf_set_margin (integer al_row, integer al_give_rate)
public subroutine wf_amt_set_row ()
public subroutine wf_amt_set (long al_row, long al_sale_qty)
public function boolean wf_style_set (long al_row, string as_style, string as_yymmdd, long al_qty)
public function boolean wf_goods_chk (long al_goods_amt, string as_coupon_date)
public subroutine wf_amt_set2 ()
public function boolean wf_member_set (string as_flag, string as_find)
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

event ue_tot_set();Long ll_sale_qty, ll_sale_amt, ll_real_amt, ll_goods_amt, ll_ok_coupon_amt
Long ll_real_amt_tmp

ll_sale_qty = Long(dw_body.Describe("evaluate('sum(sale_qty)',0)"))
ll_sale_amt = Long(dw_body.Describe("evaluate('sum(sale_amt)',0)"))
ll_real_amt = Long(dw_body.Describe("evaluate('sum(real_amt)',0)"))
ll_goods_amt = Long(dw_body.Describe("evaluate('sum(goods_amt)',0)"))
ll_ok_coupon_amt = Long(dw_body.Describe("evaluate('sum(ok_coupon_amt)',0)"))

//ll_real_amt = ll_real_amt - ll_goods_amt 
ll_real_amt_tmp = ll_real_amt - ll_goods_amt 


dw_1.Setitem(1, "sale_qty", ll_sale_qty)
dw_1.Setitem(1, "sale_amt", ll_real_amt)
dw_1.Setitem(1, "real_amt", ll_real_amt_tmp)
/*
dw_1.Setitem(1, "sale_qty", ll_sale_qty)
dw_1.Setitem(1, "sale_amt", ll_sale_amt)
dw_1.Setitem(1, "real_amt", ll_real_amt)
*/

Return

end event

public function integer wf_yes_no (string as_title);/*=================================================================*/
/* 작 성 자 : 지우정보                                             */	
/* 내    용 : 수정 자료 저장여부 확인                              */
/*=================================================================*/

RETURN  MessageBox(as_title,'쿠폰을 사용하시겠습니까?', &
			          Question!, YesNo!)


end function

public subroutine wf_ok_coupon (integer al_row, string as_ok_coupon);long ll_sale_qty, ll_curr_price, ll_goods_amt, ll_goods_amt_new, ll_ok_coupon_amt
string ls_coupon_no

ll_sale_qty = dw_body.getitemdecimal(al_row,"sale_qty")
ll_curr_price = dw_body.getitemdecimal(al_row,"curr_price")
ll_ok_coupon_amt = dw_body.getitemdecimal(al_row,"ok_coupon_amt")
ll_goods_amt = dw_body.getitemdecimal(al_row,"goods_amt")



ls_coupon_no = dw_body.getitemstring(al_row,"coupon_no")




if isnull(ll_goods_amt) then ll_goods_amt = 0


if as_ok_coupon = 'Y' then 
	ll_ok_coupon_amt = 10000 //(ll_sale_qty * ll_curr_price)*0.05  //ok쿠폰 5% 금액 적용	
	ll_goods_amt_new = ll_goods_amt + ll_ok_coupon_amt  
//	if isnull(ls_coupon_no) or ls_coupon_no = '' then 
//		ls_coupon_no = "Ko1006"
//	end if
else
	ll_ok_coupon_amt = dw_body.getitemdecimal(al_row,"ok_coupon_amt")
	if isnull(ll_ok_coupon_amt) then ll_ok_coupon_amt = 0
	ll_goods_amt_new = ll_goods_amt - ll_ok_coupon_amt
	ll_ok_coupon_amt = 0
//	
//	if ls_coupon_no = "Ko1006" then
//		setnull(ls_coupon_no)
//	end if
end if

dw_body.setitem(al_row,"goods_amt", ll_goods_amt_new)
dw_body.setitem(al_row,"ok_coupon_amt", ll_ok_coupon_amt)
//dw_body.setitem(al_row,"coupon_no", ls_coupon_no)



end subroutine

public function boolean uf_chk_birthday (string as_birthday, ref string as_jumin, ref string as_user_name, ref string as_tel_no3);string ls_s_user_name, ls_s_tel_no3_4
int li_cnt

ls_s_user_name = dw_1.getitemstring(1,"s_user_name")
//ls_s_tel_no3_4 = dw_1.getitemstring(1,"s_tel_no3_4")

	select jumin, user_name, tel_no3
		into :as_jumin, :as_user_name, :as_tel_no3
	from tb_71010_m (nolock) 
	where left(jumin,6) = :as_birthday
	and user_name = :ls_s_user_name;
//	and right(tel_no3,4) = :ls_s_tel_no3_4;	


	select count(jumin)
		into :li_cnt
	from tb_71010_m (nolock) 
	where left(jumin,6) = :as_birthday
	and user_name = :ls_s_user_name;
//	and right(tel_no3,4) = :ls_s_tel_no3_4;




	if li_cnt <> 1 or isnull(as_jumin) or LenA(as_jumin) <> 13 then 
		return False
	else 
		return True
	end if
	
end function

public function boolean uf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name);string ls_secure_no
int li_cnt

ls_secure_no = dw_1.getitemstring(1,"secure_no")

	select jumin, user_name
		into :as_jumin, :as_user_name
	from tb_71010_m (nolock) 
	where tel_no3 = replace(:as_tel_no,'-','')
	 and  right(jumin,3) = :ls_secure_no;

	select count(jumin)
		into :li_cnt
	from tb_71010_m (nolock) 
	where tel_no3 = replace(:as_tel_no,'-','')
	 and  right(jumin,3) = :ls_secure_no;


	if li_cnt <> 1 or isnull(as_jumin) or LenA(as_jumin) <> 13 then 
		return False
	else 
		return True
	end if
	
end function

public function boolean uf_member_chk (string as_flag, string as_find);
string ls_user_name
int ll_yn_imsi


IF as_flag = '4' then

	SELECT user_name
 	INTO :ls_user_name
	FROM imsi_mem_emcom a(nolock)  
	WHERE  card_no = '4870090' + :as_find ; 
	
	if ls_user_name <> '' then
		
		ll_yn_imsi = uf_yes_no_imsi(ls_user_name)
		
		if ll_yn_imsi = 1 then
			return false
		else 
			return true	
		end if

	else
		return true	
	end if

end if



end function

public function integer uf_yes_no_imsi (string as_user_name);


RETURN  MessageBox('확인',as_user_name+' 고객님이 맞습니까?', &
			          Question!, YesNo!)

end function

public subroutine wf_amt_clear ();/* 회원 즉시할인 +5% 적용 취소 금액 처리 */
long i , ll_row_count
String ls_mem_dc_yn
Decimal ld_dc_rate, ld_sale_price, ld_curr_price

ll_row_count = dw_body.rowcount()

FOR i=1 TO ll_row_count	

	ls_mem_dc_yn     = dw_body.GetitemString(i, "mem_dc_yn") 

	if ls_mem_dc_yn = "Y" then

		ld_dc_rate     = dw_body.GetitemDecimal(i, "dc_rate") 
		ld_sale_price    = dw_body.GetitemDecimal(i, "sale_price") 
		ld_curr_price	  = dw_body.GetitemDecimal(i, "curr_price") 
		
		ld_dc_rate		= ld_dc_rate - 5
		ld_sale_price  = ld_curr_price * ((100 - ld_dc_rate)/100)
		

		dw_body.SetItem(i, "dc_rate", ld_dc_rate)
		dw_body.SetItem(i, "sale_price", ld_sale_price)		
		dw_body.SetItem(i, "mem_dc_yn", "N")

	end if

	
NEXT




end subroutine

public subroutine wf_amt_set3 (long al_row);/* 회원 즉시할인 +5% 적용 금액 처리 */
Decimal ld_tag_price, ld_curr_price, ld_sale_price, ld_dc_rate,ld_tot_real_amt
String ls_sale_type, ls_style_no
	
	ld_tag_price     = dw_body.GetitemDecimal(al_row, "tag_price") 
	ld_tot_real_amt    = dw_body.GetitemDecimal(al_row, "tot_real_amt") 
	ld_sale_price    = dw_body.GetitemDecimal(al_row, "sale_price") 
	ld_curr_price	  = dw_body.GetitemDecimal(al_row, "curr_price") 
	ld_dc_rate       = dw_body.GetitemDecimal(al_row, "dc_rate") 
	ls_sale_type     = dw_body.GetitemString(al_row, "sale_type") 
   ls_style_no     = dw_body.GetitemString(al_row, "style_no") 

	// 5%즉시할인 조이그라이슨 제외
	if (MidA(ls_style_no,1,1) <> 'L') and is_coupon_gubn <> '03'  then
		if (ld_tag_price = ld_sale_price and MidA(ls_sale_type,1,1) = '1') or (MidA(ls_sale_type,1,1) = '1' and  ld_dc_rate <= 20 ) then
			if ld_dc_rate < 20 and is_coupon_gubn <> '03' then
				ld_dc_rate = ld_dc_rate + 5	
			else
				ld_dc_rate = ld_dc_rate
			end if
			
			ld_sale_price = ld_curr_price * ((100 - ld_dc_rate)/100)
			
			dw_body.SetItem(al_row, "dc_rate", ld_dc_rate)
			dw_body.SetItem(al_row, "sale_price", ld_sale_price)		
			dw_body.SetItem(al_row, "mem_dc_yn", "Y")
			
			dw_1.SetItem(al_row, "sale_amt", ld_tot_real_amt)
//		elseif gs_brand = 'N' and is_yymmdd >= '20160524' and is_yymmdd <= '20160525'  and ( mid(ls_style_no,1,8) = 'NW6MB275' or mid(ls_style_no,1,8) = 'NW6MB363' or mid(ls_style_no,1,8) = 'NW6ML286' or mid(ls_style_no,1,8) ='NW6MO313' or mid(ls_style_no,1,8) ='NW6MO320') then			
		elseif gs_brand = 'N' and is_yymmdd >= '20161021' and is_yymmdd <= '20161025'  and ( MidA(ls_style_no,1,8) = 'NW6WH499' or MidA(ls_style_no,1,8) = 'NW6WH204' or MidA(ls_style_no,1,8) = 'NW6WH574' or MidA(ls_style_no,1,8) ='NW6WH117' or MidA(ls_style_no,1,8) ='NW6WH107') then			
			ld_dc_rate = ld_dc_rate + 5	
			ld_sale_price = ld_curr_price * ((100 - ld_dc_rate)/100)
			
			dw_body.SetItem(al_row, "dc_rate", ld_dc_rate)
			dw_body.SetItem(al_row, "sale_price", ld_sale_price)		
			dw_body.SetItem(al_row, "mem_dc_yn", "Y")
			
			dw_1.SetItem(al_row, "sale_amt", ld_tot_real_amt)			
		end if
	end if

		
end subroutine

public function boolean wf_close_check (string as_brand, ref string as_close_ymd_t, ref string as_year_t, ref string as_season_t, ref string as_season_nm_t, ref string as_season_s_t, ref string as_gubn_1_t, ref string as_gubn_2_t, ref string as_gubn_3_t, ref string as_close_ymd_f, ref string as_year_f, ref string as_season_f, ref string as_season_nm_f, ref string as_season_s_f, ref string as_gubn_1_f, ref string as_gubn_2_f, ref string as_gubn_3_f);//string as_close_ymd, as_year, as_season, as_close_ymd_f, as_year_f, as_season_f
long ll_cnt

//마감일자 찾기
select max(yymmdd)
into :as_close_ymd_t
from tb_56071_d
where brand = :as_brand;

//마감년도시즌 찾기
select	year, 
			season,
			case	when season = 'S' then '봄('+season+')'
					when season = 'M' then '여름('+season+')'
					when season = 'A' then '가을('+season+')'
					when season = 'W' then '겨울('+season+')'
					else '사계절(X)' end season_nm,
			convert(char(01),dbo.sf_inter_sort_seq('003', season)) season_s,
			isnull(gubn_1,'N') as gubn_1,
			isnull(gubn_2,'N') as gubn_2,
			isnull(gubn_3,'N') as gubn_3
into   :as_year_t, :as_season_t, :as_season_nm_t, :as_season_s_t, :as_gubn_1_t, :as_gubn_2_t, :as_gubn_3_t
from tb_56071_d
where brand = :gs_brand
		and yymmdd = :as_close_ymd_t;

//마감일자 전 단계 찾기
select max(yymmdd)
into :as_close_ymd_f
from tb_56071_d
where brand = :as_brand
		and yymmdd not in (:as_close_ymd_t);
		
//마감년도신즌 전 단계 찾기
select	year,
			season,
			case	when season = 'S' then '봄('+season+')'
					when season = 'M' then '여름('+season+')'
					when season = 'A' then '가을('+season+')'
					when season = 'W' then '겨울('+season+')'
					else '사계절(X)' end season,
			convert(char(01),dbo.sf_inter_sort_seq('003', season)) season_s,
			isnull(gubn_1,'N') as gubn_1,
			isnull(gubn_2,'N') as gubn_2,
			isnull(gubn_3,'N') as gubn_3
into   :as_year_f, :as_season_f, :as_season_nm_f, :as_season_s_f, :as_gubn_1_f, :as_gubn_2_f, :as_gubn_3_f
from tb_56071_d
where brand = :as_brand
		and yymmdd = :as_close_ymd_f;

//마감 제외되는 매장이 있는지 찾기
select	count(yymmdd)
into :ll_cnt
from tb_56072_d
where brand = :as_brand
		and year = :as_year_t
		and season = :as_season_t
		and shop_cd = :gs_shop_cd;

//제외된 매장의 마감일자를 변경해줌..
if ll_cnt = 1 then	
	select	yymmdd
	into :as_close_ymd_t
	from tb_56072_d
	where brand = :as_brand
			and year = :as_year_t
			and season = :as_season_t
			and shop_cd = :gs_shop_cd;
end if

return true
end function

public function boolean wf_give_rate_chk (integer al_give_rate, string as_coupon_date);long i,j, ll_t_row, ll_give_rate, ll_dc_rate, ll_t_rate, ll_dc_rate_chk, ll_dc_rate_org
string ls_coupon_no, ls_t_coupon, ls_brand, ls_style_no, ls_year, ls_season, ls_item, ls_sale_type, ls_style, ls_season_sort, ls_style_chk
long ll_yesno, ll_sale_price, ll_t_price , ll_curr_price
long ll_qty, ll_sale_qty, ll_t_qty,ll_collect_price
decimal ldc_sale_rate

ll_yesno = MessageBox("확인",'할인율 쿠폰을 사용하시겠습니까?', Question!, YesNo!)
if ll_yesno =2  then 
	dw_1.setitem(1,"give_rate",0)
	return false					 
end if

ls_coupon_no =	dw_1.getitemstring(1,"coupon_no")

if upper(MidA(ls_coupon_no,1,1)) <> upper(gs_brand) and MidA(ls_coupon_no,1,1) <> 'T' then
	select dbo.sf_inter_nm('001',left(:ls_coupon_no,1) ) into :ls_brand from dual;
	MessageBox("쿠폰오류", ls_brand+"에서만 사용 되도록 발행된 쿠폰입니다!")
	return FALSE

end if	

ll_t_qty = 0
for j = 1 to 20
	ll_t_price=0
	ll_t_rate =0
	for i=1 to dw_body.rowcount()
		ls_style_no  = dw_body.getitemString(i,"style_no")
		if LenA(ls_style_no)=13 then 
			ll_sale_qty  = dw_body.getitemNumber(i,"sale_qty")
			ll_sale_price= dw_body.getitemNumber(i,"sale_price")
			ll_give_rate = dw_body.getitemNumber(i,"give_rate")
			ll_dc_rate   = dw_body.getitemNumber(i,"dc_rate")
			ldc_sale_rate=	dw_body.getitemNumber(i,"sale_rate")
			ls_t_coupon  =	dw_body.getitemstring(i,"coupon_no")
			ls_sale_type =	dw_body.getitemstring(i,"sale_type")
			ll_dc_rate_org   = dw_body.getitemNumber(i,"dc_rate_org")
			
			ls_brand     =	dw_body.getitemstring(i,"brand")
			ls_year      =	dw_body.getitemstring(i,"year")
			ls_season    =	dw_body.getitemstring(i,"season")
			ls_item      =	dw_body.getitemstring(i,"item")

			ll_qty = ll_t_qty + ll_sale_qty					


			if ls_season = 'S' then 
				ls_season_sort = '1'
			elseif ls_season = 'M' then 
				ls_season_sort = '2'
			elseif ls_season = 'A' then 
				ls_season_sort = '3'
			else
				ls_season_sort = '4'
			end if
				
			
			if ll_sale_qty > 0 &
				and (isnull(ls_t_coupon) or ls_t_coupon = "") &
				and ls_year + ls_season_sort >= '20082' &
				and (ls_item <> 'Z' or ((as_coupon_date = '20080523' or as_coupon_date = '20080606') and ls_coupon_no <> 'SECOND' and ls_coupon_no <> 'FIRST1') ) then		//2007년W이후 정상판매만 10%할인권 적용 기획제외 (2007년 11.23 행사)

//				if isnull(ll_dc_rate) or ll_dc_rate < 50 then	//(20131219 막음 by 김종길)
//				if  ll_dc_rate <= 20 and ((ls_brand = 'N' and left(ls_sale_type,1) = '1') or (ls_brand <> 'N' and left(ls_sale_type,1) <= '2')) then	// 정상판매 
				if ll_dc_rate_org <= 30 and (LeftA(ls_sale_type,1) = '1' or ls_sale_type = '20' or ls_sale_type = '21') then //(20131219 쿠폰사용가능기준)

					if ll_sale_price > ll_t_price  then 
						if ll_qty <= 20 then  // 20ps 까지만 적용
							ll_t_price = ll_sale_price
							ll_t_row = i	
						end if
					end if
					
				end if								
			end if
			
		end if
	next 
			
	if ll_t_row > 0 then 

/////////////////////		
		ll_dc_rate   = dw_body.getitemNumber(ll_t_row,"dc_rate")
		if isnull(al_give_rate) then al_give_rate = 0
		if isnull(ll_dc_rate) then ll_dc_rate = 0
	
		ll_t_rate = al_give_rate
	
//		if ls_brand = 'N' and ll_dc_rate > 0 then   //온앤온은 정상 최대 20%까지만 적용 
//			ll_t_rate = al_give_rate - ll_dc_rate
//		else 
//			ll_t_rate = al_give_rate
//		end if

		
////////////////////
		
		
		ls_style  = dw_body.getitemString(ll_t_row,"style")
		
		ls_style_chk  = dw_body.getitemString(j,"style")
		ll_dc_rate_chk  = dw_body.getitemNumber(j,"dc_rate")
		
		if is_use_shop = "WG0001" and ( ls_style = "WW7AH205" or ls_style = "WF7WZ911" OR ls_style = "WK7AZ118" )		then
					IF  ls_style =  "WF7WZ911" THEN
						ll_sale_price    = 200000
						ll_curr_price    = ll_sale_price
						ls_sale_type     = "33"
			
					elseif  ls_style =  "WK7AZ118" THEN	
						ll_sale_price    = 29000
						ll_curr_price    = ll_sale_price
						ls_sale_type     = "33"
					else	
						ll_sale_price    = 59000
						ll_curr_price    = ll_sale_price
						ls_sale_type     = "12"
					end if			
			
			gf_marjin_price(gs_shop_cd, ll_sale_price, ldc_sale_rate, ll_collect_price) 
			dw_body.Setitem(ll_t_row, "sale_type",     ls_sale_type) 

			dw_body.Setitem(ll_t_row, "dc_rate",       0) 
			dw_body.Setitem(ll_t_row, "give_rate",     0) 
			dw_body.Setitem(ll_t_row, "sale_price",    ll_sale_price)
			dw_body.Setitem(ll_t_row, "curr_price",    ll_curr_price)		
			dw_body.Setitem(ll_t_row, "collect_price", ll_collect_price)				
			dw_body.Setitem(ll_t_row,"coupon_no", ls_coupon_no)	
			
		elseif ls_coupon_no = 'T11120' then

			   if (MidA(ls_style_chk,3,2) = '1A' or MidA(ls_style_chk,3,2) = '1M') and ll_dc_rate_chk <= 20 then
				   dw_body.setitem(j,"give_rate", ll_t_rate) 
			    	dw_body.Setitem(j,"coupon_no", ls_coupon_no)
			   end if			
				
		elseif ls_coupon_no = 'I11110' then
			   if (MidA(ls_style_chk,3,2) = '1W' or MidA(ls_style_chk,3,2) = '1A') and ll_dc_rate_chk <= 10 then
				   dw_body.setitem(j,"give_rate", ll_t_rate) 
			    	dw_body.Setitem(j,"coupon_no", ls_coupon_no)
			   end if
				
		elseif ls_coupon_no = 'N16001' then
			   if ls_sale_type < '20' then
				   dw_body.setitem(j,"give_rate", ll_t_rate) 
			    	dw_body.Setitem(j,"coupon_no", ls_coupon_no)
				else
					messagebox('확인!','판매형태가 정상인 제품만 쿠폰사용이 가능합니다.')
					return false
			   end if	
		else					
//				dw_body.setitem(ll_t_row,"give_rate",al_give_rate) 
				dw_body.setitem(ll_t_row,"give_rate", ll_t_rate) 
				dw_body.Setitem(ll_t_row,"coupon_no", ls_coupon_no)			
		end if
		
		
		ll_sale_qty  = dw_body.getitemNumber(ll_t_row,"sale_qty")
		ll_t_qty = ll_t_qty + ll_sale_qty

	end if
	ll_t_price = 0
	ll_t_row   = 0
next 


if i > 2 then 
	return true
else
	return false
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
	if ls_coupon_no_tmp <> "" and ld_give_rate = 0 then
			
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


	
	ls_ok_coupon = dw_body.getitemstring(i,"ok_coupon")
	if ls_ok_coupon = 'Y' then 
		wf_ok_coupon(i, ls_ok_coupon)
	end if
	
NEXT


//dw_1.setitem(1, "goods_amt", 0)

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
	
/*  판매금액에 할인금액적용을 백화점과 대리점 별도로 계산된 내역 수정(요청:장나영차장 일자:20140702)
	 if gs_shop_div = "G" then
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
		
//		if abs(ll_sale_collect - round((ll_sale_amt ) * (100 - ldc_sale_rate)/100,0)) > 3 then 
//			ll_sale_collect = round((ll_sale_amt ) * (100 - ldc_sale_rate)/100,0)
//			dw_body.setitem(al_row,"sale_collect", ll_sale_collect)
//		end if
		
		
	
		
		
		if ll_io_vat <> (ll_io_amt - round(ll_io_amt/1.1,0) ) then
			ll_io_vat  = (ll_io_amt - round(ll_io_amt/1.1,0) )
			dw_body.setitem(al_row,"io_vat", ll_io_vat)
		end if

return


end subroutine

public function integer wf_set_margin (integer al_row, integer al_give_rate);String ls_style_no, ls_yes, ls_sale_type, ls_plan_yn, ls_year, ls_season, ls_sojae, ls_card_no
Long   ll_curr_price, ll_sale_price, ll_collect_price, ld_goods_amt, ll_dc_rate, ll_sale_rate,ll_dc_rate_org

dw_body.AcceptText()


	ls_style_no   = dw_body.GetitemString(al_row, "style_no")
	ls_plan_yn = MidA(ls_style_no,5,1)
	
	
//	select year, season, sojae
//	into :ls_year, :ls_season, :ls_sojae
//	from tb_12020_m (nolock)
//	where style = left(:ls_style_no,8) ;
	
//if al_give_rate > 0 and gs_shop_cd = "WG0001" and ( LEFT(ls_style_no,8) = "WF7WZ911" OR  LEFT(ls_style_no,8) = "WK7AZ118" OR  LEFT(ls_style_no,8) = "WW7AH205" ) THEN
//	
//					
//		IF  LEFT(ls_style_no,8) =  "WF7WZ911" THEN
//			ll_sale_price    = 200000
//			ll_curr_price    = ll_sale_price
//			ls_sale_type     = "33"
//
//		elseif  LEFT(ls_style_no,8) =  "WK7AZ118" THEN	
//			ll_sale_price    = 29000
//			ll_curr_price    = ll_sale_price
//			ls_sale_type     = "33"
//		else	
//			ll_sale_price    = 59000
//			ll_curr_price    = ll_sale_price
//			ls_sale_type     = "12"
//		end if			
//			
//		gf_marjin_price(gs_shop_cd, ll_sale_price, ll_sale_rate, ll_collect_price) 
//		dw_body.Setitem(al_row, "sale_type",     ls_sale_type) 
//		dw_body.Setitem(al_row, "dc_rate",       0) 
//		dw_body.Setitem(al_row, "give_rate",     0) 
//	//	dw_body.Setitem(al_row, "sale_rate",     ll_sale_rate )// gsv_cd.gdc_cd1) 
//		dw_body.Setitem(al_row, "sale_price",    ll_sale_price)
//		dw_body.Setitem(al_row, "curr_price",    ll_curr_price)		
//		dw_body.Setitem(al_row, "collect_price", ll_collect_price)
//		wf_amt_set(al_row, dw_body.Object.sale_qty[al_row]) 
//	
//ELSE

	ll_curr_price = dw_body.GetitemNumber(al_row, "curr_price")
	ld_goods_amt  = dw_body.GetitemNumber(al_row, "goods_amt")
	ll_dc_rate  = dw_body.GetitemNumber(al_row, "dc_rate")
	ll_dc_rate_org  = dw_body.GetitemNumber(al_row, "dc_rate_org")	

	ls_card_no  = dw_body.Getitemstring(al_row, "card_no")
	ls_sale_type  = dw_body.GetitemString(al_row, "sale_type")
	if ls_sale_type = '33' then

			ll_sale_price    = ll_curr_price * (100 - al_give_rate) / 100 
			dw_body.Setitem(al_row, "sale_type",     ls_sale_type) 
			dw_body.Setitem(al_row, "give_rate",     0) 
			dw_body.Setitem(al_row, "curr_price",    ll_sale_price)
			dw_body.Setitem(al_row, "sale_price",    ll_sale_price)
			dw_body.Setitem(al_row, "collect_price", ll_collect_price)
			wf_amt_set(al_row, dw_body.Object.sale_qty[al_row]) 
			
	else				
		
		
//		if ls_year = '2008' and ( ls_season = 'A' or ls_season = 'W') and ls_sojae = 'X' then
//			ll_dc_rate = long(ll_dc_rate)+ 10
//		else	



			ll_dc_rate = long(ll_dc_rate) + long(al_give_rate)

			
		//	ll_dc_rate_org = idc_dc_rate_org + long(al_give_rate)


//		end if	
			
			ll_sale_price    = ll_curr_price * (100 - ll_dc_rate) / 100 
			
			select top 1 sale_type, marjin_rate 
				into :ls_sale_type, :ll_sale_rate
			from tb_56010_m a(nolock) 
			where shop_cd = :gs_shop_cd
			and   end_ymd > :is_yymmdd
			and   shop_type = case when :ls_plan_yn = 'Z' then '3' else '1' end
			and   dc_rate = :ll_dc_rate_org
			order by sale_type;
			
			gf_marjin_price(gs_shop_cd, ll_sale_price, ll_sale_rate, ll_collect_price) 
			
			ll_sale_price    = ll_curr_price * (100 - ll_dc_rate) / 100 

			dw_body.Setitem(al_row, "sale_type",     ls_sale_type) 
			dw_body.Setitem(al_row, "dc_rate",       ll_dc_rate) 
			dw_body.Setitem(al_row, "give_rate",     0) 
			dw_body.Setitem(al_row, "sale_rate",     ll_sale_rate )// gsv_cd.gdc_cd1) 
			dw_body.Setitem(al_row, "sale_price",    ll_sale_price)
			dw_body.Setitem(al_row, "collect_price", ll_collect_price)
			wf_amt_set(al_row, dw_body.Object.sale_qty[al_row]) 
	end if


	return 1
	

end function

public subroutine wf_amt_set_row ();/* 회원 즉시할인 +5% 적용 금액 처리 */
long i , ll_row_count
String ls_mem_dc_yn
String ls_sale_type, ls_style_no, ls_date
Decimal ld_tag_price, ld_curr_price, ld_sale_price, ld_dc_rate,ld_tot_real_amt

ll_row_count = dw_body.rowcount()
ls_date = dw_head.GetItemString(1,'yymmdd')
//ls_date = mid(ls_date,1,4) + mid(ls_date,6,2) + mid(ls_date,9,2)

FOR i=1 TO ll_row_count	

	ld_tag_price     = dw_body.GetitemDecimal(i, "tag_price") 
	ld_tot_real_amt    = dw_body.GetitemDecimal(i, "tot_real_amt") 
	ld_curr_price    = dw_body.GetitemDecimal(i, "curr_price") 
	ld_sale_price    = dw_body.GetitemDecimal(i, "sale_price") 	
	ld_dc_rate       = dw_body.GetitemDecimal(i, "dc_rate") 
	ls_sale_type     = dw_body.GetitemString(i, "sale_type") 
	ls_style_no      = dw_body.GetitemString(i, "style_no") 		
	

	// 5% 즉시할인 조이그라이슨 제외 모발일쿠폰 ctrip사용 제외.
	if (MidA(ls_style_no,1,1) <> 'L') and is_coupon_gubn <> '03'  then
			// 5% 즉시할인 ND1900,OD1900,ID1900 제외 (2015.10.30)
		if (gs_shop_cd<>'ND1900' and gs_shop_cd<>'OD1900' and gs_shop_cd<>'ID1900') then
			if (ld_tag_price = ld_sale_price and MidA(ls_sale_type,1,1) = '1') or (MidA(ls_sale_type,1,1) = '1' and  ld_dc_rate <= 10 )  then
		
				ld_dc_rate = ld_dc_rate + 5	
				ld_sale_price = ld_curr_price * ((100 - ld_dc_rate)/100)
				dw_body.SetItem(i, "dc_rate", ld_dc_rate)
				dw_body.SetItem(i, "sale_price", ld_sale_price)		
				dw_body.SetItem(i, "mem_dc_yn", "Y")
		
			end if
		end if
		
		
	end if
	
//   if gs_brand = 'N' and ls_date >= '20160425' and ls_date <= '20160427'  and ( mid(ls_style_no,1,8) = 'NK6MP622' or mid(ls_style_no,1,8) = 'NW6MB236' or mid(ls_style_no,1,8) = 'NW6MB817' or mid(ls_style_no,1,8) ='NW6MJ258' or mid(ls_style_no,1,8) ='NW6ML149') then
	if gs_brand = 'N' and ls_date >= '20161021' and ls_date <= '20161025'  and ( MidA(ls_style_no,1,8) = 'NW6WH499' or MidA(ls_style_no,1,8) = 'NW6WH204' or MidA(ls_style_no,1,8) = 'NW6WH574' or MidA(ls_style_no,1,8) ='NW6WH117' or MidA(ls_style_no,1,8) ='NW6WH107') then			
				ld_dc_rate = ld_dc_rate + 5	
				ld_sale_price = ld_curr_price * ((100 - ld_dc_rate)/100)
				dw_body.SetItem(i, "dc_rate", ld_dc_rate)
				dw_body.SetItem(i, "sale_price", ld_sale_price)		
				dw_body.SetItem(i, "mem_dc_yn", "Y")
	end if
	
NEXT


dw_1.SetItem(1, "sale_amt", ld_tot_real_amt)



end subroutine

public subroutine wf_amt_set (long al_row, long al_sale_qty);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_sale_price, ll_out_price, ll_collect_price
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect1  , ll_sale_collect
Decimal ldc_marjin
Long ll_sale_amt_chk


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

ll_sale_amt_chk = dw_body.GetitemDecimal(al_row, "sale_amt") 


//
// messagebox("al_sale_qty",al_sale_qty)
//messagebox("ll_sale_amt_chk",ll_sale_amt_chk)

		IF ll_goods_amt <> 0 THEN 
		 
			ldc_marjin = dw_body.GetitemDecimal(al_row, "sale_rate")
 		   gf_marjin_price(gs_shop_cd, (ll_sale_price * al_sale_qty) - ll_goods_amt, ldc_marjin, ll_sale_collect1)
         //판매금액에 할인금액적용을 백화점과 대리점 별도로 계산된 내역 수정(요청:장나영차장 일자:20140702)
			if gs_shop_div = "G" then 
				ll_sale_collect = ll_sale_collect1 //- (ll_goods_amt * ldc_marjin / 100)
			else
				ll_sale_collect = ll_sale_collect1
			end if	
		ELSE
			ll_sale_collect = ll_collect_price * al_sale_qty
		END IF
		dw_body.Setitem(al_row, "sale_collect", ll_sale_collect) 
		
		/* 세일 재매입 처리 */
//		gf_marjin_price(gs_shop_cd, (ll_sale_price * al_sale_qty), ldc_marjin, ll_sale_collect)  					
		ll_io_amt = (ll_out_price  * al_sale_qty) - ll_sale_collect
		dw_body.Setitem(al_row, "io_amt", ll_io_amt)
		dw_body.Setitem(al_row, "io_vat", ll_io_amt - Round(ll_io_amt / 1.1, 0))
		
		

end subroutine

public function boolean wf_style_set (long al_row, string as_style, string as_yymmdd, long al_qty);Long    ll_dc_rate     
Long    ll_curr_price,  ll_out_price
Long    ll_sale_price,  ll_collect_price 
String  ls_shop_type,   ls_sale_type = space(2), ls_year, ls_season, ls_sojae,	ls_plan_yn, ls_shop_cd, ls_shop_div, ls_dot_com, ls_color
decimal ldc_out_marjin, ldc_sale_marjin, ll_sale_rate


if is_set_style_chk <> '' then 
	messagebox('확인','세트상품과 일반상품은 같이 결제 할 수 없습니다.')
	return false
end if



/* 정상, 기획 */
ls_shop_type = dw_body.GetitemString(al_row, "shop_type")
//ls_sale_type = dw_body.GetitemString(al_row, "sale_type")
is_mj_bit = 'Y'

if gs_shop_cd = 'OD0002' then
	ls_dot_com = '1'
else	
	ls_dot_com = dw_body.GetItemString(al_row, "dotcom")
end if	

ls_color   = dw_body.GetItemString(al_row, "color")

//if as_yymmdd <= "20170915" then
//
//	/* 출고시 마진율 체크 (출고시에는 닷컴마진율이 아닌 백화점 마진으로 나가기)*/
//	IF gf_out_marjin (as_yymmdd,    gs_shop_cd,     ls_shop_type , as_style, & 
//							ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
//		is_mj_bit = 'N'
//		RETURN False 
//	END IF
//	
//else	
	IF gf_out_marjin_color (as_yymmdd,    gs_shop_cd,     ls_shop_type , as_style, ls_color, & 
							ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
		is_mj_bit = 'N'
		RETURN False 
	END IF
//end if

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
	elseif gs_shop_cd = 'OD0002' then
		select a.shoP_cd, a.shop_div
		into :ls_shoP_cd, :ls_shop_div
		from tb_91100_m a (nolock)
		where exists (	select * 
				from tb_91100_m b (nolock) 
				where b.shoP_div in ('B','G','D')
				  and b.brand = a.brand
				  and b.cust_cd = a.cust_cd
				  and b.shop_cd = :gs_shop_cd
				)
		and shop_div = 'H'
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
		
		IF gf_sale_marjin_color (as_yymmdd,    ls_shop_cd,      ls_shop_type, as_style, ls_color, & 
								 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 
			is_mj_bit = 'N'
			RETURN False
		END IF


      // 닷컴으로 판매시에는 G코드가 아닌 H로 수정해서 입력
		ll_curr_price = ll_sale_price
		ldc_out_marjin = ldc_sale_marjin
		ll_out_price = ll_collect_price
else
	/* 판매 마진율 체크 닷컴이 아닐때. */
	
		IF gf_sale_marjin_color (as_yymmdd,    gs_shop_cd,      ls_shop_type, as_style, ls_color, & 
							 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 		
		   return false
	   end if


end if


/* 판매 자료 등록 */
if is_mj_bit = 'Y' then
	
	if gs_shop_cd = 'OD0002' then //본점 닷컴 무조건 적용
		dw_body.Setitem(al_row, "dotcom","1")
	end if	
	
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

public function boolean wf_goods_chk (long al_goods_amt, string as_coupon_date);Long 	  j, i, k, ll_accept_point, ll_remain_point, ll_total_point , ll_row_count,ll_goods_amt,ll_sale_price, ll_sale_price2,ll_sale_qty   ,ll_give_amt, ll_chk_sale_price
decimal ld_goods_amt, ld_mok, ld_qty, ld_coupon_amt, ld_check_amt,ld_tot_goods_amt , ld_dc_rate, ld_sale_amt
string  ls_jumin, ls_card_no, ls_sale_fg, ls_style_no, ls_item, ls_coupon_no, ls_coupon_yn, ls_sale_type, ls_yymmdd, ls_coupon_no1, ls_sale_type_chk
integer li_sale_qty, ll_YN, li_chk_cnt, ps_chk
string  ls_brand,ls_item_tmp,ls_item_tmp_chk, ls_give_date, ls_msg_yn = 'N', ls_year, ls_season
long    ll_remain_amt, ll_ok_coupon_amt, ll_tot_ok_coupon_amt
String ps_yymmdd, ps_sale_no, ps_shop_cd
string ps_jumin, ps_card_no, ps_give_date

wf_goods_amt_clear()

ls_jumin        = dw_1.GetitemString (1, "jumin")          // 주민번호
ls_coupon_no    = dw_1.GetitemString (1, "coupon_no")          // 선택쿠폰번호
ld_goods_amt    = dw_1.Getitemdecimal(1, "goods_amt")      // 사용할 금액
ll_total_point  = dw_1.getitemdecimal( 1, "total_point")   // 총 포인트 
ll_remain_point = dw_1.getitemdecimal( 1, "remain_point")  // 남은 포인트 
ls_yymmdd       = dw_1.getitemString( 1, "give_date")  		// 남은 포인트 
ll_accept_point = ld_goods_amt                   	    	  // 사용할 포인트
ls_coupon_yn = 'n'
li_sale_qty    =  dw_1.getitemNumber( 1, "sale_qty")
ld_sale_amt    =  dw_1.getitemNumber( 1, "sale_amt")

ll_row_count = dw_body.RowCount()


IF isnull(al_goods_amt) OR al_goods_amt = 0 THEN 
	 wf_goods_amt_clear()
	RETURN TRUE 
END IF

 // 잔여 포인트를 십원 단위로 사용하도록 변환 
 ll_remain_amt =  (ll_remain_point  / 10) 
 ll_remain_point = ll_remain_amt  *  10
 ll_give_amt   =  ld_goods_amt / 10
//messagebox('잔액', ll_remain_point)

// 먼저 사용할 쿠폰이 있는지 체크   //
	select give_point * 10,
			 upper(coupon_no)
	 into :ld_coupon_amt, :ls_coupon_no 
	from	tb_71011_h (nolock)
	where jumin       = :ls_jumin
	and	point_flag  = '1'
	and   accept_flag = 'N'
	and   give_date   = :ls_yymmdd
	and   give_point  = :ll_give_amt
	and   isnull(coupon_no,'')   like isnull(:ls_coupon_no,'') + '%'
	and   isnull(use_ymd,'9') >= convert(char(8),getdate(),112) 
	order by give_point desc;

//messagebox("ls_coupon_no", ls_coupon_no)


if trim(ls_coupon_no) <> "" and  UPPER(ls_coupon_no) <> 'FIRST1' AND UPPER(ls_coupon_no) <> 'SECOND' and LeftA(UPPER(ls_coupon_no),1) <> 'T' THEN
	if MidA(ls_coupon_no,1,1) <> gs_brand then
		select dbo.sf_inter_nm('001',left(:ls_coupon_no,1) ) into :ls_brand from dual;
		MessageBox("쿠폰오류", ls_brand+"에서만 사용 되도록 발행된 쿠폰입니다!")
		return FALSE
	end if	
END IF	


if trim(ls_coupon_no) <> "" and (UPPER(ls_coupon_no) = 'T13220' or UPPER(ls_coupon_no) = 'T13250') and (UPPER(gs_brand) <> 'N' and UPPER(gs_brand) <> 'O')  THEN
	MessageBox("쿠폰오류", "사용 가능한 브랜드가 아닙니다.")
	return FALSE		
END IF

// 20131209~20131215
if trim(ls_coupon_no) <> "" and UPPER(ls_coupon_no) = 'T13620' and (UPPER(gs_brand) <> 'N' and UPPER(gs_brand) <> 'O' and UPPER(gs_brand) <> 'I')  THEN
	MessageBox("쿠폰오류", "사용 가능한 브랜드가 아닙니다.")
	return FALSE		
END IF


// 20131011~20131130
if trim(ls_coupon_no) <> "" and (UPPER(ls_coupon_no) = 'T13450' or UPPER(ls_coupon_no) = 'T13430') and (UPPER(gs_shop_cd) <> 'IG0662' and UPPER(gs_shop_cd) <> 'BG1865' and UPPER(gs_shop_cd) <> 'IG0010' and UPPER(gs_shop_cd) <> 'BK1720' and UPPER(gs_shop_cd) <> 'BG1862' )  THEN
	MessageBox("쿠폰오류", "사용 가능한 매장이 아닙니다.")
	return FALSE		
END IF


// 아래 금액체크부분은 합계금액을 체크하는것임 ///////////////////////////////////////////////////
// 합계금액을 체크한다는것은 쿠폰이 적용될 상품이 체크기준보다 낮은금액이어도 무관하다는것.///////
IF isnull(ld_sale_amt) THEN ld_sale_amt = 0 

if trim(ls_coupon_no) <> "" and ((UPPER(ls_coupon_no) = 'T09430' and ld_sale_amt < 100000) or (UPPER(ls_coupon_no) = 'T09450' and ld_sale_amt < 150000)) THEN
	if UPPER(ls_coupon_no) = 'T09430' then
		MessageBox("쿠폰오류", "10만원 이상 구매시만 사용 되도록 발행된 쿠폰입니다!")
		return FALSE
	else
		MessageBox("쿠폰오류", "15만원 이상 구매시만 사용 되도록 발행된 쿠폰입니다!")
		return FALSE		
	end if	
END IF		

if trim(ls_coupon_no) <> "" and (UPPER(ls_coupon_no) = 'B14110' or UPPER(ls_coupon_no) = 'B14130') and ld_sale_amt < 100000 THEN
	MessageBox("쿠폰오류", "10만원 이상 구매시만 사용 되도록 발행된 쿠폰입니다!")
	return FALSE		
END IF

if trim(ls_coupon_no) <> "" and UPPER(ls_coupon_no) = 'B14150' and ld_sale_amt < 200000  THEN
	MessageBox("쿠폰오류", "20만원 이상 구매시만 사용 되도록 발행된 쿠폰입니다!")
	return FALSE		
END IF


/*
if trim(ls_coupon_no) <> "" and UPPER(ls_coupon_no) = 'T13250' and ld_sale_amt < 150000 THEN
	MessageBox("쿠폰오류", "15만원 이상 구매시만 사용 되도록 발행된 쿠폰입니다!")
	return FALSE		
END IF

if trim(ls_coupon_no) <> "" and UPPER(ls_coupon_no) = 'B13330' and ld_sale_amt < 150000 THEN
	MessageBox("쿠폰오류", "15만원 이상 구매시만 사용 되도록 발행된 쿠폰입니다!")
	return FALSE		
END IF
*/
////////////////////////////////////////////////////////////////////////////////////////////////////



////각 상품의 판매가로 체크//// use funtion(coupon_no,limit_price,str)..///////////////////////////
// 각 판매가체크는 리스트상에 체크기준 금액보다 낮은 판매가의 상품이 존재하면 안됨 .///////
// 리스트상에서 가장 낮은 금액에 쿠폰이 적용되야 하기때문 /////////////////////////////////
//------------- coupon_no T13250 --------------------------------------------------------
if trim(ls_coupon_no) <> "" and UPPER(ls_coupon_no) = 'T13250' then
	li_chk_cnt = 0
	FOR i=1 TO ll_row_count
		ll_chk_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))		
		if ll_chk_sale_price < 150000 then
			li_chk_cnt = li_chk_cnt + 1
		end if
	NEXT
	
	if li_chk_cnt > 0 then
		MessageBox("쿠폰오류", "15만원 이상 제품에만 사용 되도록 발행된 쿠폰입니다!")
		return FALSE				
	end if
end if
//---------------------------------------------------------------------------------------



//------------- coupon_no N14150 I14150 --------------------------------------------------------
if trim(ls_coupon_no) <> "" and (UPPER(ls_coupon_no) = 'N14150' or UPPER(ls_coupon_no) = 'I14150') then
	li_chk_cnt = 0
	FOR i=1 TO ll_row_count
		ll_chk_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))		
		if ll_chk_sale_price < 200000 then
			li_chk_cnt = li_chk_cnt + 1
		end if
	NEXT
	
	if li_chk_cnt > 0 then
		MessageBox("쿠폰오류", "20만원 이상 제품에만 사용 되도록 발행된 쿠폰입니다!")
		return FALSE				
	end if
end if
//---------------------------------------------------------------------------------------


//------------- coupon_no N14130 I14130 --------------------------------------------------------
if trim(ls_coupon_no) <> "" and (UPPER(ls_coupon_no) = 'N14130' or UPPER(ls_coupon_no) = 'I14130') then
	li_chk_cnt = 0
	FOR i=1 TO ll_row_count
		ll_chk_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))		
		if ll_chk_sale_price < 150000 then
			li_chk_cnt = li_chk_cnt + 1
		end if
	NEXT
	
	if li_chk_cnt > 0 then
		MessageBox("쿠폰오류", "15만원 이상 제품에만 사용 되도록 발행된 쿠폰입니다!")
		return FALSE				
	end if
end if
//---------------------------------------------------------------------------------------


//------------- coupon_no B14230 --------------------------------------------------------
if trim(ls_coupon_no) <> "" and UPPER(ls_coupon_no) = 'B14230' then
	li_chk_cnt = 0
	FOR i=1 TO ll_row_count
		ll_chk_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))		
		if ll_chk_sale_price < 100000 then
			li_chk_cnt = li_chk_cnt + 1
		end if
	NEXT
	
	if li_chk_cnt > 0 then
		MessageBox("쿠폰오류", "10만원 이상 제품에만 사용 되도록 발행된 쿠폰입니다!")
		return FALSE				
	end if
end if
//---------------------------------------------------------------------------------------

//------------- coupon_no B13330 --------------------------------------------------------
if trim(ls_coupon_no) <> "" and UPPER(ls_coupon_no) = 'B13330' then
	li_chk_cnt = 0
	FOR i=1 TO ll_row_count
		ll_chk_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))		
		if ll_chk_sale_price < 150000 then
			li_chk_cnt = li_chk_cnt + 1
		end if
	NEXT
	
	if li_chk_cnt > 0 then
		MessageBox("쿠폰오류", "15만원 이상 제품에만 사용 되도록 발행된 쿠폰입니다!")
		return FALSE				
	end if
end if
//---------------------------------------------------------------------------------------
//------------- coupon_no B13230 --------------------------------------------------------

if trim(ls_coupon_no) <> "" and UPPER(ls_coupon_no) = 'B13230' then
	li_chk_cnt = 0
	FOR i=1 TO ll_row_count
		ll_chk_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))		
		if ll_chk_sale_price < 150000 then
			li_chk_cnt = li_chk_cnt + 1
		end if
	NEXT
	
	if li_chk_cnt > 0 then
		MessageBox("쿠폰오류", "15만원 이상 제품에만 사용 되도록 발행된 쿠폰입니다!")
		return FALSE				
	end if
end if

//---------------------------------------------------------------------------------------
//------------- coupon_no O15150 --------------------------------------------------------

if trim(ls_coupon_no) <> "" and UPPER(ls_coupon_no) = 'O15150' then
	li_chk_cnt = 0
	FOR i=1 TO ll_row_count
		ll_chk_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))		
		if ll_chk_sale_price < 200000 then
			li_chk_cnt = li_chk_cnt + 1
		end if
	NEXT
	
	if li_chk_cnt > 0 then
		MessageBox("쿠폰오류", "20만원 이상 제품에만 사용 되도록 발행된 쿠폰입니다!")
		return FALSE				
	end if
end if

//------------- coupon_no N15150 --------------------------------------------------------

if trim(ls_coupon_no) <> "" and UPPER(ls_coupon_no) = 'N15150' then
	li_chk_cnt = 0
	ll_chk_sale_price = dw_1.getitemdecimal(1,"real_amt")

	if ll_chk_sale_price < 200000 then
		li_chk_cnt = li_chk_cnt + 1
	end if		
	/*
	FOR i=1 TO ll_row_count
		ll_chk_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))		
		if ll_chk_sale_price < 200000 then
			li_chk_cnt = li_chk_cnt + 1
		end if
	NEXT
	*/
	if li_chk_cnt > 0 then
		MessageBox("쿠폰오류", "20만원 이상 제품에만 사용 되도록 발행된 쿠폰입니다!")
		return FALSE				
	end if
end if

//---------------------------------------------------------------------------------------

//------------- coupon_no I15130 B15230 P15230 --------------------------------------------------------

if trim(ls_coupon_no) <> "" and (UPPER(ls_coupon_no) = 'I15130' or UPPER(ls_coupon_no) = 'B15230' or UPPER(ls_coupon_no) = 'P15230') then
	li_chk_cnt = 0
	FOR i=1 TO ll_row_count
		ll_chk_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))		
		if ll_chk_sale_price < 100000 then
			li_chk_cnt = li_chk_cnt + 1
		end if
	NEXT
	
	if li_chk_cnt > 0 then
		MessageBox("쿠폰오류", "10만원 이상 제품에만 사용 되도록 발행된 쿠폰입니다!")
		return FALSE				
	end if
end if

//---------------------------------------------------------------------------------------

//------------- coupon_no N16001 --------------------------------------------------------
long ll_chk_sale_amt
if trim(ls_coupon_no) <> "" and (UPPER(ls_coupon_no) = 'N16001') then
	li_chk_cnt = 0
	FOR i=1 TO ll_row_count
		ll_chk_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))		
		ll_chk_sale_amt = ll_chk_sale_amt + ll_chk_sale_price
//		if ll_chk_sale_price < 100000 then
//			li_chk_cnt = li_chk_cnt + 1
//		end if
	NEXT
	
	if ll_chk_sale_amt < 100000 then
		MessageBox("쿠폰오류", "10만원 이상 제품에만 사용 되도록 발행된 쿠폰입니다!")
		return FALSE				
	end if
end if

//------------- coupon_no N17005 --------------------------------------------------------
//long ll_chk_sale_amt
if trim(ls_coupon_no) <> "" and (UPPER(ls_coupon_no) = 'N17005') then
	li_chk_cnt = 0
	ll_chk_sale_price = 0
	ll_chk_sale_amt = 0

	FOR i=1 TO ll_row_count
		ls_sale_type_chk = dw_body.GetitemString(i, "sale_type")
		ll_chk_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))	
		ld_dc_rate    = dw_body.GetitemDecimal(i, "dc_rate") 
		if ls_sale_type_chk < "33"  and  ls_sale_type_chk <> "22"  then
			ll_chk_sale_amt = ll_chk_sale_amt + ll_chk_sale_price
		end if	
//		if ll_chk_sale_price < 100000 then
//			li_chk_cnt = li_chk_cnt + 1
//		end if
	NEXT
	
	if ll_chk_sale_amt < 200000 then
		MessageBox("쿠폰오류", "정상 합계 20만원 이상에 사용 되도록 발행된 쿠폰입니다!")
		return FALSE				
	end if
end if


//---------------------------------------------------------------------------------------


//------------- coupon_no I15130 Y코드 사용불가처리 --------------------------------------------------------

if trim(ls_coupon_no) <> "" and UPPER(ls_coupon_no) = 'I15130' then
	li_chk_cnt = 0
	FOR i=1 TO ll_row_count
		ls_item_tmp = dw_body.Getitemstring(i, "style_no")	
		ls_item_tmp_chk = RightA(LeftA(ls_item_tmp,2),1)		
		if ls_item_tmp_chk = 'Y' then
			li_chk_cnt = li_chk_cnt + 1
		end if
	NEXT
	
	if li_chk_cnt > 0 then
		MessageBox("쿠폰오류", "Y 기획상품에는 사용할수 없습니다.")
		return FALSE				
	end if
end if

//---------------------------------------------------------------------------------------


		

////////////////////////////////////////////////////////////////////////////////////////////



	
IF isnull(ld_coupon_amt) THEN ld_coupon_amt = 0 



IF ll_remain_point + ld_coupon_amt < ld_goods_amt THEN 
		MessageBox("Point 오류", "잔여 Point가 부족합니다.")
		wf_goods_amt_clear()
		dw_1.setitem(1,"goods_amt",0)
		dw_1.SetColumn("goods_amt")
		return FALSE
	END IF

// 만약 쿠폰이 없다면 잔여 포인트와 사용할 포인트만 비교한다  //
if   ld_coupon_amt = 0  then 	 
  IF ll_remain_point  < ll_goods_amt then
	   MessageBox("Point 오류", "쿠폰도 없고 잔여 Point가 부족합니다.")
		wf_goods_amt_clear()
		dw_1.setitem(1,"goods_amt",0)
		dw_1.SetColumn("goods_amt")
		return FALSE
	END IF
end if	
	

// 이 이후로는 쿠폰 또는 잔여포인트가 충분한 경우 로직임 //
	

	ll_goods_amt = dw_1.GetitemNumber(1, "goods_amt")  
	
	IF isnull(ll_goods_amt) THEN ll_goods_amt = 0 
	 
// 만약 사용할 금액이 쿠폰 금액이 충분하다면  //


if  ld_coupon_amt > 0  and ll_goods_amt >= ld_coupon_amt  then	
		ll_YN=wf_yes_no(This.title)

		
	   FOR i=1 TO ll_row_count
			ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))				
			ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
			ls_style_no   = dw_body.Getitemstring(i, "style_no")
			ls_item       = RightA(LeftA(ls_style_no,2),1)
			ls_sale_type  = dw_body.Getitemstring(i, "sale_type")
			ld_dc_rate    = dw_body.GetitemDecimal(i, "dc_rate") 
			ls_year		  = dw_body.Getitemstring(i, "year")
			ls_season     = dw_body.Getitemstring(i, "season")

						
// 가장 최저가 상품에 구매할인권을 쓰게 처리 						 
// 			IF (ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ld_dc_rate < 31  and ls_sale_type < '30' and ((isnull(as_coupon_date) or (as_coupon_date <> '20080523' and as_coupon_date = '20080606')) or (ls_coupon_no = 'SECOND' or ls_coupon_no = 'FIRST1') ) ) or &  
//				(ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ls_sale_type < '40' and (as_coupon_date = '20080523' or as_coupon_date = '20080606') and ls_coupon_no <> 'SECOND' and ls_coupon_no <> 'FIRST1' ) THEN  	//기획/균일 포함

//				 균일/자체세일 막음(주석처리) (20130619 by 김종길)
//				IF (ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ld_dc_rate < 31  and ls_sale_type < '30' and (isnull(as_coupon_date) or (ls_coupon_no = 'SECOND' or ls_coupon_no = 'FIRST1') ) ) 
//				or (ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ls_sale_type < '30' and ls_coupon_no <> 'SECOND' and ls_coupon_no <> 'FIRST1' ) THEN  	

				IF (ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ld_dc_rate < 31  and ls_sale_type < '22' and (not isnull(as_coupon_date) or (ls_coupon_no = 'SECOND' or ls_coupon_no = 'FIRST1' ) ) and ls_coupon_no <>'N16001' and ls_coupon_no <> 'N17001' and  ls_coupon_no <> 'N17002' and ls_coupon_no <> 'N17003' and ls_coupon_no <> 'N17004' ) then		
					 k = k + 1
					if k= 1 then
						ll_sale_price2 = ll_sale_price 
					end if
							
								
					if ll_sale_price <= ll_sale_price2 then				
						for j = 1 to i
 							 ll_ok_coupon_amt   = dw_body.GetitemDecimal(j, "ok_coupon_amt")							 
							 dw_body.Setitem(j,"goods_amt", ll_ok_coupon_amt)						
							 if ll_ok_coupon_amt > 0 then 
							 	 dw_body.Setitem(j,"coupon_no", '')		//ok쿠폰 행사중

							 else
								 dw_body.Setitem(j,"coupon_no", '')
							 end if
						next


					  	CHOOSE CASE ll_YN   // 쿠폰 사용할지 확인 
							CASE 1    
								
								//예약판매분 쿠폰 사용내역 확인
								
								
								//ps_give_date = dw_10.GetItemString(1,"give_date") //지급일
								//ps_yymmdd = dw_10.GetItemString(1,"use_ymd")		  //사용기한
								ps_card_no = dw_1.GetItemString(1,"card_no")
								ps_jumin = dw_1.GetItemString(1,"jumin")
								ps_card_no = '4870090' + ps_card_no
								
								
								select count(*)  
								into :ps_chk
								from tb_53017_h
								where yymmdd between :ps_give_date and :ps_yymmdd
								and card_no = :ps_card_no
								and jumin = :ps_jumin
								and coupon_no = :ls_coupon_no;
								
								
								if ps_chk > 0 then
									messagebox('확인','예약판매로 이미 사용하신 쿠폰입니다. 확인해주세요.')
									return False
								end if
									
							

								ll_sale_price2 = ll_sale_price 
								ls_coupon_yn = 'y'		
								ll_ok_coupon_amt   = dw_body.GetitemDecimal(i, "ok_coupon_amt")
								dw_body.Setitem(i,"coupon_no", ls_coupon_no)

								if isnull(ll_ok_coupon_amt) then ll_ok_coupon_amt = 0
								if isnull(ld_coupon_amt) then ld_coupon_amt = 0
								
								dw_body.Setitem(i,"goods_amt", ld_coupon_amt + ll_ok_coupon_amt)
								
								// 쿠폰 쓰고 남은 금액 다시 계산 //
								ll_goods_amt = ll_goods_amt - ld_coupon_amt	
								ll_goods_amt = ll_goods_amt / 10000
								ll_goods_amt = ll_goods_amt * 10000						 
						END CHOOSE	
						
					end if	
				elseif (ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ls_sale_type < '20' and ls_coupon_no = 'N16001' ) then		
					 k = k + 1
					if k= 1 then
						ll_sale_price2 = ll_sale_price 
					end if
							
								
					if ll_sale_price <= ll_sale_price2 then				
						for j = 1 to i
 							 ll_ok_coupon_amt   = dw_body.GetitemDecimal(j, "ok_coupon_amt")							 
							 dw_body.Setitem(j,"goods_amt", ll_ok_coupon_amt)						
							 if ll_ok_coupon_amt > 0 then 
							 	 dw_body.Setitem(j,"coupon_no", '')		//ok쿠폰 행사중

							 else
								 dw_body.Setitem(j,"coupon_no", '')
							 end if
						next


					  	CHOOSE CASE ll_YN   // 쿠폰 사용할지 확인 
							CASE 1    
								
								//예약판매분 쿠폰 사용내역 확인
								
								
								//ps_give_date = dw_10.GetItemString(1,"give_date") //지급일
								//ps_yymmdd = dw_10.GetItemString(1,"use_ymd")		  //사용기한
								ps_card_no = dw_1.GetItemString(1,"card_no")
								ps_jumin = dw_1.GetItemString(1,"jumin")
								ps_card_no = '4870090' + ps_card_no
								
								
								select count(*)  
								into :ps_chk
								from tb_53017_h
								where yymmdd between :ps_give_date and :ps_yymmdd
								and card_no = :ps_card_no
								and jumin = :ps_jumin
								and coupon_no = :ls_coupon_no;
								
								
								if ps_chk > 0 then
									messagebox('확인','예약판매로 이미 사용하신 쿠폰입니다. 확인해주세요.')
									return False
								end if
									
								ll_sale_price2 = ll_sale_price 
								ls_coupon_yn = 'y'		
								ll_ok_coupon_amt   = dw_body.GetitemDecimal(i, "ok_coupon_amt")
								dw_body.Setitem(i,"coupon_no", ls_coupon_no)

								if isnull(ll_ok_coupon_amt) then ll_ok_coupon_amt = 0
								if isnull(ld_coupon_amt) then ld_coupon_amt = 0
								
								dw_body.Setitem(i,"goods_amt", ld_coupon_amt + ll_ok_coupon_amt)
								
								// 쿠폰 쓰고 남은 금액 다시 계산 //
								ll_goods_amt = ll_goods_amt - ld_coupon_amt	
								ll_goods_amt = ll_goods_amt / 10000
								ll_goods_amt = ll_goods_amt * 10000						 
						END CHOOSE	
						
					end if	
				elseif (ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ls_sale_type < '40' and (ls_coupon_no = 'N17001' or ls_coupon_no = 'N17002' or ls_coupon_no = 'N17003' or ls_coupon_no = 'N17005') ) then		

					//2017, 2018년 정상
					if (ls_coupon_no = 'N17005' and ( ls_sale_type > '32' or ls_sale_type = "22"  )  ) or ( (ls_coupon_no = 'N17005' and ls_year < '2018') ) then
							MessageBox("확인1", "2018년 정상/세일/기획(부진,품목제외) 제품에만 사용할수 있습니다! 정상 외 상품은 제외하고 등록해주세요!")  
							ls_coupon_yn = 'n'	
							ls_msg_yn = 'Y'	
						return FALSE
					end if
								
					 k = k + 1
					if k= 1 then
						ll_sale_price2 = ll_sale_price 
					end if

					if ll_sale_price <= ll_sale_price2 then				
						for j = 1 to i
 							 ll_ok_coupon_amt   = dw_body.GetitemDecimal(j, "ok_coupon_amt")							 
							 dw_body.Setitem(j,"goods_amt", ll_ok_coupon_amt)						
							 if ll_ok_coupon_amt > 0 then 
							 	 dw_body.Setitem(j,"coupon_no", '')		//ok쿠폰 행사중

							 else
								 dw_body.Setitem(j,"coupon_no", '')
							 end if
						next


					  	CHOOSE CASE ll_YN   // 쿠폰 사용할지 확인 
							CASE 1    
								
								//예약판매분 쿠폰 사용내역 확인
								
								
								//ps_give_date = dw_10.GetItemString(1,"give_date") //지급일
								//ps_yymmdd = dw_10.GetItemString(1,"use_ymd")		  //사용기한
								ps_card_no = dw_1.GetItemString(1,"card_no")
								ps_jumin = dw_1.GetItemString(1,"jumin")
								ps_card_no = '4870090' + ps_card_no
								
								
								select count(*)  
								into :ps_chk
								from tb_53017_h
								where yymmdd between :ps_give_date and :ps_yymmdd
								and card_no = :ps_card_no
								and jumin = :ps_jumin
								and coupon_no = :ls_coupon_no;
								
								
								if ps_chk > 0 then
									messagebox('확인','예약판매로 이미 사용하신 쿠폰입니다. 확인해주세요.')
									return False
								end if
									
								ll_sale_price2 = ll_sale_price 
								ls_coupon_yn = 'y'		
								ll_ok_coupon_amt   = dw_body.GetitemDecimal(i, "ok_coupon_amt")
								dw_body.Setitem(i,"coupon_no", ls_coupon_no)

								if isnull(ll_ok_coupon_amt) then ll_ok_coupon_amt = 0
								if isnull(ld_coupon_amt) then ld_coupon_amt = 0
								
								dw_body.Setitem(i,"goods_amt", ld_coupon_amt + ll_ok_coupon_amt)
								
								// 쿠폰 쓰고 남은 금액 다시 계산 //
								ll_goods_amt = ll_goods_amt - ld_coupon_amt	
								ll_goods_amt = ll_goods_amt / 10000
								ll_goods_amt = ll_goods_amt * 10000						 
						END CHOOSE	
						
					end if	
				elseif ls_style_no <> '' and ls_msg_yn <> 'Y'  then 
		
					if	(as_coupon_date = '20080523' or as_coupon_date = '20080606') and ls_coupon_no <> 'SECOND' and ls_coupon_no <> 'FIRST1'  then
					 					
								MessageBox("확인", " 정상/세일/기획/균일  제품에만 사용할수 있습니다.")  
								ls_coupon_yn = 'n'	
								ls_msg_yn = 'Y'
								return FALSE
								
					elseif ls_coupon_no = 'N16001' and ls_sale_type >= '20' then
								MessageBox("확인", "정상 제품에만 사용할수 있습니다!")  
								ls_coupon_yn = 'n'	
								ls_msg_yn = 'Y'
		
								return FALSE
								
					elseif ls_coupon_no = 'N17001' and ls_sale_type > '40'  then
								MessageBox("확인", "정상/세일/기획 제품에만 사용할수 있습니다!")  
								ls_coupon_yn = 'n'	
								ls_msg_yn = 'Y'		
								return FALSE
					//2017년도 시즌 A에 정상 세일만, M은 정상,기획,세일
					elseif (ls_coupon_no = 'N17003' and ls_sale_type > '40') or ( (ls_coupon_no = 'N17003' and ls_year >= '2017' and ls_season = 'A' and MidA(ls_sale_type,1,1) = '3') ) then
								MessageBox("확인", "2017년 여름(M)상품은 정상/세일/기획 , 가을(A)상품은 정상/세일 제품에만 사용할수 있습니다!")  
								ls_coupon_yn = 'n'	
								ls_msg_yn = 'Y'		
								return FALSE
								
			   	elseif (ls_coupon_no = 'N17005' and ( ls_sale_type > '32'  or ls_sale_type = "22"  )) or ( (ls_coupon_no = 'N17005' and ls_year <= '2017') ) then
								MessageBox("확인2", "2017년 겨울, 2018년 정상/세일 20% 이하 제품에만 사용할수 있습니다! 정상 외 상품은 제외하고 등록해주세요!")  
								ls_coupon_yn = 'n'	
								ls_msg_yn = 'Y'		
								return FALSE								

					else

						 if ld_dc_rate >= 31 or ls_sale_type >= '22' then						
								MessageBox("확인", " 정상/세일(30%이내)  제품에만 사용할수 있습니다!")  
								ls_coupon_yn = 'n'	
								ls_msg_yn = 'Y'

								return FALSE								
								
					//	else 		
					//			ls_coupon_yn = 'Y'	
					//			ls_msg_yn = 'Y'
						 end if
					end if
				END IF
	    NEXT
		 
		IF ld_coupon_amt = ll_accept_point and ls_coupon_yn = 'Y' then
   	   messagebox('쿠폰사용 끝', ls_coupon_no)		
			return true
		END IF
 elseif  ll_goods_amt < ld_coupon_amt and  ll_goods_amt < 10  THEN 
	   MessageBox("확인", "마일리지는 10원 이상부터 사용할수 있습니다.")  
   return false
 end if

// 더 쓸 금액이 없으면 종료 //

//IF ll_goods_amt  > ll_remain_point  OR  ll_goods_amt < 30000  THEN 
IF ll_goods_amt  > ll_remain_point  OR  ll_goods_amt < 10  THEN 
	ll_tot_ok_coupon_amt =  dw_body.Getitemdecimal(1,"tot_ok_coupon_amt")
	if isnull(ll_tot_ok_coupon_amt) then ll_tot_ok_coupon_amt = 0
	
 	ld_tot_goods_amt =  dw_body.Getitemdecimal(1,"tot_goods_amt")
	ld_tot_goods_amt = ld_tot_goods_amt - ll_tot_ok_coupon_amt
	
	dw_1.setitem (1, "goods_amt", ld_tot_goods_amt )	
	ld_tot_goods_amt =  dw_1.Getitemdecimal(1,"goods_amt")
	if ld_tot_goods_amt > 0 then 
	   MessageBox("확인", "총" + string(ld_tot_goods_amt) + " 만큼만 사용합니다1.")  
	end if
   return true
END IF

	
	ld_mok = MOD(ll_goods_amt , 10) 
	
	if ld_mok <> 0 then
		MessageBox("Point 오류", "1PCS에 10원 단위로 입력하세요. ")
		wf_goods_amt_clear()
		dw_1.setitem(1,"goods_amt",0)
		dw_1.SetColumn("goods_amt")
		return false    
	end if
	
    	
	/* point 판매 처리 및 가능여부 체크 (정상판매단가가  Point금액 이상 매출만 가능)*/
	
	FOR i=1 TO ll_row_count
		
		ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))
		ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
		ls_style_no   = dw_body.Getitemstring(i, "style_no")
		ls_item       = RightA(LeftA(ls_style_no,2),1)
		ls_coupon_no  = dw_body.Getitemstring(i, "coupon_no")
		ls_sale_type  = dw_body.Getitemstring(i, "sale_type")
		ld_dc_rate    = dw_body.GetitemDecimal(i, "dc_rate") 
		
		ll_ok_coupon_amt   = dw_body.GetitemDecimal(i, "ok_coupon_amt")
		if isnull(ll_ok_coupon_amt) then ll_ok_coupon_amt = 0
		
		IF ls_coupon_no = '' then					 
				IF ll_goods_amt > 0 and ll_sale_price > ll_goods_amt and  & 
					ll_sale_qty  > 0 and ld_dc_rate  < 31  and ls_sale_type < '30' THEN  
					ls_sale_fg = '2' 
//					if ll_goods_amt >=  30000 then 
					if ll_goods_amt >=  10 then 
						dw_body.Setitem(i,"goods_amt", ll_goods_amt + ll_ok_coupon_amt)	
			 		   messagebox('확인', '마일리지 ' + string(ll_goods_amt) + '원 사용')
						ll_goods_amt = 0
					 
					else 	
						dw_body.Setitem(i,"goods_amt", ll_ok_coupon_amt)
						ls_sale_fg = '1' 
					end if
				ELSE
					dw_body.Setitem(i,"goods_amt", ll_ok_coupon_amt)
					ls_sale_fg = '0' 
				END IF				 
				dw_body.setitem(i,"sale_fg",ls_sale_fg)
		END IF
	NEXT	
	ll_tot_ok_coupon_amt =  dw_body.Getitemdecimal(1,"tot_ok_coupon_amt")
	if isnull(ll_tot_ok_coupon_amt) then ll_tot_ok_coupon_amt = 0
	
	ld_tot_goods_amt =  dw_body.Getitemdecimal(1,"tot_goods_amt")
	ld_tot_goods_amt = ld_tot_goods_amt - ll_tot_ok_coupon_amt
	
   dw_1.setitem(1, "goods_amt", ld_tot_goods_amt ) 
  
	
	IF ld_tot_goods_amt  = ld_goods_amt THEN  
		RETURN TRUE 
	ELSE
	   ld_tot_goods_amt =  dw_1.Getitemdecimal(1,"goods_amt")
		MessageBox("확인", "총" + string(ld_tot_goods_amt) + " 만큼만 사용합니다2.")
		RETURN true
	END IF
	
//	IF ll_goods_amt > 30000   then
	IF ll_goods_amt > 10   then
		MessageBox("Point 오류", "사용할 Point가 구매할 상품보다 많습니다.")
		MessageBox("ll_goods_amt", ll_goods_amt)
		 wf_goods_amt_clear()
		 dw_1.setitem(1,"goods_amt",0)
		 dw_1.SetColumn("goods_amt")
		RETURN false	
	END IF 
	
				
//	IF ll_remain_point >= ll_accept_point THEN 
//		RETURN TRUE 
//	ELSE
//		MessageBox("Point 오류", "사용할 Point가 부족합니다2.")
//		wf_goods_amt_clear()
//		dw_1.setitem(1,"goods_amt",0)
//		dw_1.SetColumn("goods_amt")
//	END IF
		
RETURN FALSE





end function

public subroutine wf_amt_set2 ();/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_sale_price, ll_out_price, ll_collect_price, ll_row_count,ll_foundrow
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect  , ll_dc_amt, ll_sale_price2, ll_sale_qty,ll_sale_price3, ll_min_sale_price ,ll_sale_collect1
long ll_find, ll_qty, ll_cnt
long sale_price[]
int i, j, k
String ls_coupon_no, ls_sale_type, ls_item, ls_style_no, ls_coupon_yn, ls_style, ls_yymmdd, ls_event_id
Decimal ldc_marjin,ld_dc_rate, ll_dc_rate 

dw_body.AcceptText()


//ls_coupon_no = dw_11.getitemstring(1,"coupon_no")
//ls_event_id  = dw_11.getitemstring(1,"event_id")
//ll_dc_amt    = dw_11.getitemNumber(1,"dc_amt")



if ls_event_id = 'GC0901' then 
	if not (gs_shop_cd = 'OG0034' or gs_shop_cd = 'OG0003' or gs_shop_cd = 'OG0038' or gs_shop_cd = 'OG0046' or gs_shop_cd = 'OG0048' or gs_shop_cd = 'OG0010' or gs_shop_cd = 'OG0008' or gs_shop_cd = 'OG0106') then
		messagebox("알림!", "선택한 이벤트에 해당되는 매장이 아닙니다 !!!")
		return
	end if	
end if

if ls_event_id = 'TM1112' then 
	if not (gs_shop_cd = 'BB1807' or gs_shop_cd = 'BB1888') then
		messagebox("알림!", "선택한 이벤트에 해당되는 매장이 아닙니다 !!!")
		return
	end if	
end if

select count(*)
into :ll_cnt
from tb_71011_p (nolock)
where :is_yymmdd between give_date and use_ymd
and verify_no = :ls_coupon_no
and event_id  = :ls_event_id
and accept_flag = 'N'
and :gs_brand like isnull(brand,'%');

if gs_shop_cd = 'BB1813' then
	ll_cnt = 1
end if

if ll_cnt <= 0 then 
	messagebox("알림!", "선택한 이벤트에 기간내 발행된 쿠폰이 없습니다!")
	return
end if


IF isnull(ll_goods_amt) THEN ll_goods_amt = 0 	 

ll_row_count = dw_body.RowCount()

if  ll_dc_amt > 0  and isnull(ls_coupon_no) <> true and LenA(ls_coupon_no) = 6 and ll_cnt > 0 and ls_coupon_no > "00000" then	  	    		
	   FOR i=1 TO ll_row_count
			ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))				
			ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
			ls_style_no   = dw_body.Getitemstring(i, "style_no")
			ls_item       = RightA(LeftA(ls_style_no,2),1)
			ls_sale_type  = dw_body.Getitemstring(i, "sale_type")
			ld_dc_rate    = dw_body.GetitemDecimal(i, "dc_rate") 
			
		    // 가장 최저가 상품에 구매할인권을 쓰게 처리 						 
				IF  ll_sale_price > ll_dc_amt  and ll_sale_qty  > 0 and ld_dc_rate < 80  and ls_sale_type < '30'  THEN  	
					 k = k + 1
					if k= 1 then
						ll_sale_price2 = ll_sale_price 
					end if
								
					if ll_sale_price <= ll_sale_price2 then				
						for j = 1 to i
							 
							 dw_body.Setitem(j,"coupon_no", '')
							 dw_body.Setitem(j,"goods_amt", 0)	
						 	 ll_qty   = dw_body.GetitemDecimal(j, "sale_qty")
							 ls_style = dw_body.GetitemString(j, "style")
							 if gs_shop_cd <> 'BB1813' then
								 wf_style_set(j, ls_style, is_yymmdd, ll_qty)							  
							end if
							 wf_amt_set(j, ll_qty)
						next	
								ll_sale_price2 = ll_sale_price 
								dw_body.Setitem(i,"coupon_no", ls_coupon_no)
								
							     CHOOSE CASE wf_yes_no(This.title)   // 쿠폰 사용할지 확인 
										CASE 1    
											ll_sale_price2 = ll_sale_price 
											ls_coupon_yn = 'y'	
											ll_tag_price     = dw_body.GetitemDecimal(i, "tag_price") 
											ll_curr_price    = dw_body.GetitemDecimal(i, "curr_price") 
											ll_sale_price    = dw_body.GetitemDecimal(i, "sale_price") 
											ll_out_price     = dw_body.GetitemNumber(i, "out_price") 
											ll_collect_price = dw_body.GetitemNumber(i, "collect_price")
											
											ll_sale_price3 = ll_sale_price - ll_dc_amt
											
											dw_body.Setitem(i, "sale_price", ll_sale_price)					
											dw_body.Setitem(i, "tag_amt",  ll_tag_price  * ll_sale_qty)
											dw_body.Setitem(i, "curr_amt", ll_curr_price * ll_sale_qty)
											dw_body.Setitem(i, "sale_amt", ll_sale_price * ll_sale_qty)
											dw_body.Setitem(i, "out_amt",  ll_out_price * ll_sale_qty) 
											dw_body.Setitem(i, "goods_amt",  ll_dc_amt) 
											dw_body.Setitem(i, "event_id",  ls_event_id)
											dw_1.setitem(1,"goods_amt",ll_dc_amt)
											
											ldc_marjin = dw_body.GetitemDecimal(i, "sale_rate")										
											gf_marjin_price(gs_shop_cd, (ll_sale_price * ll_sale_qty) - ll_goods_amt, ldc_marjin, ll_sale_collect1)
											//판매금액에 할인금액적용을 백화점과 대리점 별도로 계산된 내역 수정(요청:장나영차장 일자:20140702)
											if gs_shop_div = "G" then 
												ll_sale_collect = ll_sale_collect1 //- (ll_goods_amt * ldc_marjin / 100)
											else
												ll_sale_collect = ll_sale_collect1
											end if	
											
											dw_body.Setitem(i, "sale_collect", ll_sale_collect) 
											
											ll_io_amt = (ll_out_price  * ll_sale_qty) - ll_sale_collect
											dw_body.Setitem(i, "io_amt", ll_io_amt)
											dw_body.Setitem(i, "io_vat", ll_io_amt - Round(ll_io_amt / 1.1, 0))	
											dw_body.Setitem(i,"coupon_no", ls_coupon_no)
											//dw_11.setitem(1,"coupon_no","")		
											//dw_11.setitem(1,"dc_amt",0)		
											wf_amt_set(i, ll_sale_qty)
									END CHOOSE	
									
								end if					
							END IF
					 NEXT

				IF ls_coupon_yn = 'y' then
//					messagebox('쿠폰사용 끝', ls_coupon_no)		
					//dw_11.visible = false
					return
				END IF								

 else
	messagebox('경고', "쿠폰번호를 확인하세요!")
   return
 end if
	
	

		
		
end subroutine

public function boolean wf_member_set (string as_flag, string as_find);String  ls_user_name, ls_jumin, ls_card_no, ls_age_grp, ls_tel_no3, ls_secure_no
string  ls_s_user_name, ls_s_birthday, ls_s_tel_no3_4
string  ls_yymmdd, ls_crm_grp
Long    ll_total_point, ll_give_point, ll_accept_point, ll_year, ll_coupon_cnt 
int	  ll_ans
Decimal ld_give_point, ld_give_rate
DataStore	lds_source	
Boolean lb_return 
DataWindowChild ldw_child

dw_body.AcceptText()




select convert(char(08), getdate(),112)
into :ls_yymmdd
from dual;



dw_1.setitem(1, "give_rate",0)	


IF as_flag = '3' THEN
		if LenA(as_find) <> 6 then 
			messagebox("확인","생년월일을 정확히 입력하세요..")			
			return true				
		elseif uf_chk_birthday(as_find, ls_jumin,ls_user_name,ls_tel_no3) THEN
			dw_1.SetItem(1, "jumin",     ls_jumin)
		else 			
			ls_secure_no = dw_1.getitemstring(1,"secure_no")
			ls_s_user_name = dw_1.getitemstring(1,"s_user_name")
//			ls_s_tel_no3_4 = dw_1.getitemstring(1,"s_tel_no3_4")
			
			
			gst_cd.ai_div          = 1
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""
			IF Trim(as_find) <> "" THEN
				gst_cd.Item_where   = " left(jumin,6) = '" + as_find + "' and user_name = '" + ls_s_user_name + "' "
//				gst_cd.Item_where   = " left(jumin,6) = '" + as_find + "' and user_name = '" + ls_s_user_name + "' and right(tel_no3,4) = '" + ls_s_tel_no3_4 + "' "				

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
	 WHERE jumin   = :as_find ; 
	
ELSE
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


if (ll_total_point - ll_accept_point) >= 10 then 
//	dw_1.object.text_message.text = "사용할 Point금액이 있습니다 !"
	dw_1.object.text_message.text = ""
	
else 
	dw_1.object.text_message.text = ""
end if

//ls_yymmdd = '20170501'

select sum(give_point * 10), sum(give_rate) 
into	 :ld_give_point, :ld_give_rate
from	 tb_71011_h (nolock)
where jumin       = :ls_jumin
and	point_flag  = '1'
and   isnull(accept_flag,'N') = 'N'
and   :ls_yymmdd between give_date and use_ymd //  사용 만기일 체크 발행일부터 만기일까지..
and  (coupon_no in ('first1','second')
or    coupon_no like :gs_brand+'%'
or    coupon_no like 'T%')
and   isnull(use_shop,'%') = case when use_shop is null then '%' else :gs_shop_cd end;


if ld_give_point >  0 then 
	if ld_give_rate > 0 then 
		dw_1.object.text_message2.text = string(ld_give_rate)+"% 할인율쿠폰, 구매할인권" + string(ld_give_point) + "원"
	else
		dw_1.object.text_message2.text = "구매할인권 " + string(ld_give_point) + "원"
	end if
	dw_1.setitem(1, "give_date","")	
	//dw_1.object.cb_give.visible = true
else 
	if ld_give_rate > 0 then 
		dw_1.object.text_message2.text = string(ld_give_rate)+"% 할인율쿠폰"
		//dw_1.object.cb_give.visible = true
	else
		dw_1.object.text_message2.text = ""
		//dw_1.object.cb_give.visible = false
	end if
	dw_1.setitem(1, "give_date","")	

end if

dw_1.SetItem(1, "card_no",      RightA(ls_card_no, 9))
dw_1.SetItem(1, "user_name",    ls_user_name)
dw_1.SetItem(1, "jumin",        ls_jumin)
dw_1.Setitem(1, "total_point",  ll_total_point)
dw_1.Setitem(1, "give_point",   ll_give_point)
dw_1.Setitem(1, "accept_point", ll_accept_point)
dw_1.Setitem(1, "tel_no3", 	  ls_tel_no3)
dw_1.Setitem(1, "secure_no", 	  RightA(ls_jumin,3))
dw_1.Setitem(1, "crm_grp", 	  ls_crm_grp)

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

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_size, ls_shop_type, ls_given_fg, ls_given_ymd, ls_shop_type_1
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn , LS_RTRN_YMD , ls_work_gubn, ls_date
Long   ll_tag_price, ll_ord_qty, ll_ord_qty_chn , ll_cnt
decimal ldc_sale_qty
// ldc_sale_price_1
dw_body.AcceptText()
dw_head.accepttext()
ls_date = dw_head.GetItemString(1,'yymmdd')
//ls_date = mid(ls_date,1,4) + mid(ls_date,6,2) + mid(ls_date,9,2)

IF LenA(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)



// 반품용 프로시져도 제한 
// SP_SH101_D31
// SP_SH101_D34
if MidA(gs_shop_cd,3,4) >= "1900" and MidA(gs_shop_cd,3,4) <= "1913" then 
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
		and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
		and sojae  <> 'C'   ;
elseif 	gs_shop_div = 'L' then
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
		and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
		and sojae  <> 'C'  ;

//elseif gs_shop_cd = "NG0008" or gs_shop_cd = "NG1150"  or  gs_shop_cd = "OG0002" or  gs_shop_cd = "OH0002" then 
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
//	   and year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= '20091'		
//		and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
//		and sojae  <> 'C'   ;
		
elseif gs_brand = "B" or gs_brand = 'P' or gs_brand = 'K' or gs_brand = 'U' or gs_brand = 'D' then 
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
		and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end   ;
		

elseif gs_brand = "N" or gs_brand = "O" or gs_brand = 'I' then
	if ls_date <= is_close_ymd_t then
		//마감일자 전의 판매
		//정상+행사
		if is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'Y' then					
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
			// where brand = :gs_brand 
			where :gs_brand_grp  like '%' + brand + '%'				 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_f + :is_season_s_f )
//							or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_f + :is_season_s_f  and plan_yn = 'Y')
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type = '33'
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );	
							
		//정상+행사+기획
		elseif is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'N' then
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
//			 where brand = :gs_brand 
			 where :gs_brand_grp  like '%' + brand + '%'	
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_f + :is_season_s_f ) 
							or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_f + :is_season_s_f  and plan_yn = 'Y')
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type = '33'
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );							
		end if
	else
		//마감일자 후의 판매
		//정상+행사
		if is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'Y' then
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
//			 where brand = :gs_brand 
			where :gs_brand_grp  like '%' + brand + '%'	
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_t + :is_season_s_t ) 
							or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = case when :gs_brand = 'N' then  '20175' else 'XX' end ) //2017 사계절 임시 예외처리
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type = '33'
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );							  

		//정상+행사+기획
		elseif is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'N' then
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
//			 where brand = :gs_brand 
			where :gs_brand_grp  like '%' + brand + '%'				 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_t + :is_season_s_t ) 
							or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_t + :is_season_s_t  and plan_yn = 'Y')
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type = '33'
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );		
		end if
	end if
/*		
elseif gs_brand = "O" then
	if ls_date <= '20150602' then
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
			and sojae  <> 'C' 		
			and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
			and ( 
					(  
						( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20143' ) 
//					or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20141'  and plan_yn = 'Y')
					)
					or style in (select a.style
							from tb_56012_d a (nolock)
							where a.shop_type = '3'
							and a.sale_type = '33'
							and a.shop_cd = :gs_shop_cd
							and :is_yymmdd between a.start_ymd and a.end_ymd
							and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
											where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
											  and a.shop_cd = :gs_shop_cd
											  and a.shop_cd = b.shop_cd 
											  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
					  );	
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
			and sojae  <> 'C' 		
			and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
			and ( 
					(  
						( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20144' ) 
//					or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20141'  and plan_yn = 'Y')
					)
					or style in (select a.style
							from tb_56012_d a (nolock)
							where a.shop_type = '3'
							and a.sale_type = '33'
							and a.shop_cd = :gs_shop_cd
							and :is_yymmdd between a.start_ymd and a.end_ymd
							and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
											where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
											  and a.shop_cd = :gs_shop_cd
											  and a.shop_cd = b.shop_cd 
											  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
					  );	
	end if
elseif gs_brand = "N" then
	if ls_date <= '20150614' then
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
			and sojae  <> 'C' 		
			and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end	
			and ( (  
						( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20145' )
						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20144'  and plan_yn = 'Y' )
						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20144'  and (item = 'U' or item = 'G' or item = 'F' ))
					)
					or style in (select a.style
							from tb_56012_d a (nolock)
							where a.shop_type = '3'
							and a.sale_type = '33'
							and a.shop_cd = :gs_shop_cd
							and :is_yymmdd between a.start_ymd and a.end_ymd
							and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
											where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
											  and a.shop_cd = :gs_shop_cd
											  and a.shop_cd = b.shop_cd 
											  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
					  );	
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
			and sojae  <> 'C' 		
			and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end	
			and ( (  
						( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20151' )
						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20151'  and plan_yn = 'Y' )
//						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20144'  and (item = 'U' or item = 'G' or item = 'F' ))
					)
					or style in (select a.style
							from tb_56012_d a (nolock)
							where a.shop_type = '3'
							and a.sale_type = '33'
							and a.shop_cd = :gs_shop_cd
							and :is_yymmdd between a.start_ymd and a.end_ymd
							and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
											where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
											  and a.shop_cd = :gs_shop_cd
											  and a.shop_cd = b.shop_cd 
											  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
					  );	
	end if

elseif gs_brand = "I" then
	if gs_user_id = 'IE1912' or gs_user_id = 'IG0017' or gs_user_id = 'IG0019' or gs_user_id = 'IG0681' then //주소연대리 요청 : 압구정CJ판매가능하게(20130722)
		if ls_date <= '20150419' then
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
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end	
				and ( (  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20143' ) 
//								or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20134'  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type = '33'
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );		
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
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end	
				and ( (  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20144' ) 
//								or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20134'  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type = '33'
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );		
		end if
		
	

	else
		if ls_date <= '20150412' then
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
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end	
				and ( (  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20143' ) 
//								or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20134'  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type = '33'
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );		
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
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end	
				and ( (  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20144' ) 
//								or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20134'  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type = '33'
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );		
		end if
		
	end if
*/	
else 	
		Select brand,     year,     season,     
			 sojae,     item,     tag_price,     plan_yn   
	  into :ls_brand, :ls_year, :ls_season, 
			 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
	  from vi_12024_1 with (nolock)
//	 where brand = :gs_brand 
		where :gs_brand_grp  like '%' + brand + '%'	
		and style = :ls_style 
		and chno  = :ls_chno
		and color = :ls_color 
		and size  = :ls_size
		and sojae  <> 'C' 	
		and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end	
      and ( (  
		  			( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20094' ) 
//            or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20094'  and plan_yn = 'Y' )   
				)
		
 	  		  or style in (select a.style
						from tb_56012_d a (nolock)
						where a.shop_type = '3'
						and a.sale_type = '33'
						and a.shop_cd = :gs_shop_cd
						and :is_yymmdd between a.start_ymd and a.end_ymd
						and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
										where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
										  and a.shop_cd = :gs_shop_cd
										  and a.shop_cd = b.shop_cd 
										  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y'))
			  );		
		
		
//	   and ( (  ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20074'  OR STYLE IN  ('WW7WE605','WW7WE608','WW7WE609') )
//            or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20072'  and plan_yn = 'Y' )   )
//			or style in (select a.style
//							from tb_56012_d a (nolock)
//							where a.shop_type = '3'
//							and a.sale_type = '33'
//							and a.shop_cd = :gs_shop_cd
//							and :is_yymmdd between a.start_ymd and a.end_ymd
//							and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
//											where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
//											  and a.shop_cd = :gs_shop_cd
//											  and a.shop_cd = b.shop_cd 
//											  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y')  )		
//				);							 

end if

//IF SQLCA.SQLCODE <> 0 THEN 
//	messagebox("확인","시즌마감되어 등록이 불가능합니다! 관리팀에 연락 바랍니다!")
//	Return False 
//END IF


Select isnull(ord_qty,0), isnull(ord_qty_chn,0)
  into :ll_ord_qty, :ll_ord_qty_chn  
  from tb_12030_s with (nolock)
 where brand = :gs_brand 
   and style = :ls_style 
	and chno  = :ls_chno
	and color = :ls_color 
	and size  = :ls_size;
	
if gs_brand <> 'M' then
//	if ll_ord_qty - ll_ord_qty_chn <= 0  then 
//		messagebox("경고!", "국내 판매등록이 불가능한 제품입니다!")
//		return false
//	end if	
end if	

ll_cnt = 0

if MidA(gs_shop_cd,1,2) = "NG" and is_yymmdd >= "20180901" then 
	Select shop_type
	into :ls_shop_type
	From tb_56012_d_color with (nolock)
	Where style      = :ls_style 
	  and color      = :ls_color
	  and start_ymd <= :is_yymmdd
	  and end_ymd   >= :is_yymmdd
	  and shop_type <> '9'
	  and shop_cd    = "NI" + right(:gs_shop_cd ,4)
	  group by shop_type;
	
			if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then	
				Select shop_type
				into :ls_shop_type
				From tb_56012_d with (nolock)
				Where style      = :ls_style 
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and shop_type <> '9'
				  and shop_cd    = "NI" + right(:gs_shop_cd ,4) ;
			end if
else
	
	Select shop_type
	into :ls_shop_type
	From tb_56012_d_color with (nolock)

	Where style      = :ls_style 
	  and color      = :ls_color
	  and start_ymd <= :is_yymmdd
	  and end_ymd   >= :is_yymmdd
	  and shop_type <> '9'
	  and shop_cd    = :gs_shop_cd 
	  group by shop_type;
	
			if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then	
				Select shop_type
				into :ls_shop_type
				From tb_56012_d with (nolock)
				Where style      = :ls_style 
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and shop_type <> '9'
				  and shop_cd    = :gs_shop_cd ;
			end if
end if

if gs_brand = "I" then
	//코인코즈는 품번별 마진 없으면 년도/시즌까지 확인 요청 장나영차장 요청 (20140617).
	Select	a.shop_type
	into :ls_shop_type_1
	From tb_56011_d a with (nolock), tb_12020_m b (nolock)
	Where b.style = :ls_style 
	and a.start_ymd <= :is_yymmdd
	and a.end_ymd   >= :is_yymmdd
	and a.shop_cd    = :gs_shop_cd
	and a.year       = b.year
	and a.season     = b.season;
	

	if IsNull(ls_shop_type_1) or Trim(ls_shop_type_1) = "" then	
		if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
			ls_shop_type = '1'					
		end if
	else
		ls_shop_type = ls_shop_type_1				
	end if
else
	//코인코즈 제외
	if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
		 ls_shop_type = '1'
	end if	
end if
/*
if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
	ls_shop_type = "1"
end if	
*/
if ls_shop_type > "3"  then 
//	messagebox("경고!", "정상 판매등록이 불가능한 제품입니다!")
//	return false
end if	

SELECT  ISNULL(RTRN_YMD, 'XXXXXXXX')
INTO :LS_RTRN_YMD
FROM tb_54020_h
WHERE STYLE = :LS_STYLE
AND   DEP_FG = 'Y';

if IsNull(LS_RTRN_YMD) or Trim(LS_RTRN_YMD) = "" then
	LS_RTRN_YMD = "XXXXXXXX"
end if


if gs_user_id <> 'IE1912'  then //주소연대리 요청 : 압구정CJ몰 판매가능하게(20130723)
	if gs_shop_div <> 'M' then //장나영차장 요청 : 면세점은 부진처리 후에도 정상으로 판매가능하게 (20140722)
		if ls_shop_type < "3"  then 
			IF LS_RTRN_YMD <= IS_YYMMDD THEN 
				messagebox("경고!", "부진적용일이후 정상 판매,반품등록은 불가능합니다! 관리팀에 연락 바랍니다!")
				return false
			END IF	
		end if	
	end if
end if	


select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
into  :ls_given_fg, :ls_given_ymd
from tb_12020_m with (nolock)
where style = :ls_style;


if ls_given_fg = "Y" then 
//	messagebox("품번체크", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")
//	return false
end if 	


select work_gubn, given_ymd
into :ls_work_gubn, :ls_given_ymd
from beaucre.dbo.tb_56040_m with (nolock)
where style like :ls_style + '%'
and   gubn = 'C';

IF ( ls_work_gubn = "S" or ls_work_gubn = "A" ) and ls_given_ymd <= is_yymmdd THEN 
//	messagebox("품번검색", ls_given_ymd + "일자로 판매불가로 전환된 제품입니다!")					
//	return false 	
END IF 		


dw_body.SetItem(al_row, "tag_price", ll_tag_price) 
IF ls_plan_yn = 'Y' THEN 
	dw_body.Setitem(al_row, "shop_type", '3')
ELSE
	dw_body.Setitem(al_row, "shop_type", '1')
END IF

if isnull(dw_body.GetItemNumber(al_row, "sale_qty")) or dw_body.GetItemNumber(al_row, "sale_qty") = 0  then
	ldc_sale_qty = 1
else
	ldc_sale_qty = dw_body.GetItemNumber(al_row, "sale_qty")
end if

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

on w_sh194_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.st_1=create st_1
this.st_2=create st_2
this.dw_15=create dw_15
this.st_ok_coupon1=create st_ok_coupon1
this.st_ok_coupon2=create st_ok_coupon2
this.shl_member=create shl_member
this.dw_17=create dw_17
this.em_1=create em_1
this.st_8=create st_8
this.st_9=create st_9
this.dw_list=create dw_list
this.shl_manual=create shl_manual
this.dw_member_sale=create dw_member_sale
this.dw_back_sale=create dw_back_sale
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.dw_15
this.Control[iCurrent+6]=this.st_ok_coupon1
this.Control[iCurrent+7]=this.st_ok_coupon2
this.Control[iCurrent+8]=this.shl_member
this.Control[iCurrent+9]=this.dw_17
this.Control[iCurrent+10]=this.em_1
this.Control[iCurrent+11]=this.st_8
this.Control[iCurrent+12]=this.st_9
this.Control[iCurrent+13]=this.dw_list
this.Control[iCurrent+14]=this.shl_manual
this.Control[iCurrent+15]=this.dw_member_sale
this.Control[iCurrent+16]=this.dw_back_sale
end on

on w_sh194_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_15)
destroy(this.st_ok_coupon1)
destroy(this.st_ok_coupon2)
destroy(this.shl_member)
destroy(this.dw_17)
destroy(this.em_1)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.dw_list)
destroy(this.shl_manual)
destroy(this.dw_member_sale)
destroy(this.dw_back_sale)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(cb_1, "FixedToRight")


inv_resize.of_Register(st_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_1, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_member_sale, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_back_sale, "ScaleToRight&Bottom")

dw_15.SetTransObject(SQLCA)
dw_back_sale.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_member_sale.SetTransObject(SQLCA)


dw_1.insertRow(0)

// ok쿠폰 적용 설명
if gs_brand <> 'O' then  
	st_ok_coupon1.visible = false
	st_ok_coupon2.visible = false
end if



//고판다쿠폰 20150923~20151231 명동메가,영플라자,가로수길,제주점만 해당. 
//춘절프로모션 20160201~20160229 라빠레트 명동메가,영플라자,가로수길 해당.
//춘절프로모션 20160201~20160229 온앤온 롯데본점, 롯데잠실, 롯데영등포, 롯데노원, 롯데청량리, 현대천호, 현대신촌, 현대미아, 신세계강남, 신세계영등포 해당
//if gs_shop_cd = 'BB1807' or gs_shop_cd = 'BB1813' or gs_shop_cd = 'BB1801' or gs_shop_cd = 'BK1722' or gs_shop_cd = 'TB1004' then
//if ((gs_brand = 'N' and gs_shop_div = 'G' and is_yymmdd >= '20160201' and is_yymmdd <= '20160229') or (gs_shop_cd = 'BB1807' or gs_shop_cd = 'BB1813' or gs_shop_cd = 'BB1801' or gs_shop_cd = 'BK1722' )) then
/*등록일자가져오기*/
string ls_yymmdd
date ld_date_t
SELECT convert(varchar(8), GetDate(),112)
  INTO :ls_yymmdd
  FROM DUAL ;

if gs_shop_cd = 'BB1807' or gs_shop_cd = 'BB1813' or gs_shop_cd = 'BB1801' or gs_shop_cd = 'BK1722' then
	dw_1.object.cb_gopanda.visible = true
elseif ((gs_shop_cd = 'NG0008' or gs_shop_cd = 'NG0009' or gs_shop_cd = 'NG0006' or gs_shop_cd = 'NG0037' or gs_shop_cd = 'NG0014' or gs_shop_cd = 'NG0019' or gs_shop_cd = 'NG0030' or gs_shop_cd = 'NG1091' or gs_shop_cd = 'NG1141' or gs_shop_cd = 'NG1142') and ls_yymmdd >= '20160201' and ls_yymmdd <= '20160229') then
	dw_1.object.cb_gopanda.visible = true
else
	dw_1.object.cb_gopanda.visible = false
end if


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);///*===========================================================================*/
///* 작성자      : 김 태범                                                     */	
///* 작성일      : 2002.02.15                                                  */	
///* 수정일      : 2002.02.15                                                  */
///*===========================================================================*/
//String     ls_style, ls_chno, ls_color, ls_size, ls_shop_type, ls_given_fg, ls_given_ymd, LS_RTRN_YMD, ls_work_gubn, ls_for_lotte, ls_barcode, ls_g_style_no, ls_g_color, ls_g_size
//Long       ll_row_cnt , ll_ord_qty, ll_ord_qty_chn, li_shop_cnt
//Boolean    lb_check 
//string ls_shop_snm, ls_ok, ls_date, ls_shop_nm
//DataStore  lds_Source 
//
//dw_head.accepttext()
//dw_body.AcceptText()
//ls_date = dw_head.GetItemString(1,'yymmdd')
////ls_date = mid(ls_date,1,4) + mid(ls_date,6,2) + mid(ls_date,9,2)
//
//CHOOSE CASE as_column
//	CASE "style_no"		
//		
//			IF ai_div = 1 THEN 	
//				IF wf_style_chk(al_row, as_data)  THEN
//				   ll_row_cnt = dw_body.RowCount()
//				   IF al_row = ll_row_cnt THEN 
//					   ll_row_cnt = dw_body.insertRow(0)
//				   END IF
//				   This.Post Event ue_tot_set()
//					RETURN 0 
//				END IF 
//			END IF
//			
//			
//			
//		   ls_style = Mid(as_data, 1, 8)
//		   ls_chno  = Mid(as_data, 9, 1)
//		   ls_color = Mid(as_data, 10, 2)
//		   ls_size  = Mid(as_data, 12, 2)
//			
//		   gst_cd.ai_div          = ai_div
//			gst_cd.window_title    = "품번 코드 검색" 
//			gst_cd.datawindow_nm   = "d_com012" 
//	
//////////////////////////////////////////////////////////////////////////////////////////////////////////
////		   IF GS_SHOP_DIV <> "L" THEN
////				if mid(gs_shop_cd,3,4) >= "1900" and mid(gs_shop_cd,3,4) <= "1913" then 
////					gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and  year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  >  '20054'  " 				 			
////					
////				elseif gs_brand = "B" or gs_brand = "P" or gs_brand = "K" or gs_brand = 'L' or gs_brand = 'U' then 					
////					gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and  year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  >  '20054'  " 				 			
////					
////				else
////					if gs_brand = "N" or gs_brand = "O" or gs_brand = 'I' then
////						if ls_date <= is_close_ymd_t then
////							//마감일자 전의 판매
////							//정상+행사
////							if is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'Y' then
////								gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_f+is_season_s_f+"' ) )" + &
////												" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
////												" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
////												" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
////												" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') <> 'Y' "
////							//정상+행사+기획
////							elseif is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'N' then
////								gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_f+is_season_s_f+"' ) or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '"+is_year_f+is_season_s_f+"' and plan_yn = 'Y' )  )" + &
////												" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
////												" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
////												" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
////												" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') <> 'Y' "
////							end if
////						else
////							//마감일자 후의 판매
////							//정상+행사
////							if is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'Y' then
////								gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_t+is_season_s_t+"' ) or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = case when brand = 'N' then '20175' else 'XX' end ) )" + &
////												" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
////												" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
////												" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
////												" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') <> 'Y' "
////							//정상+행사+기획
////							elseif is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'N' then
////								gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_t+is_season_s_t+"' ) or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '"+is_year_t+is_season_s_t+"' and plan_yn = 'Y' )  )" + &
////												" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
////												" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
////												" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
////												" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') <> 'Y' "
////							end if
////						end if
////						
////					elseif gs_brand = 'B' or gs_brand = 'P' or gs_brand = 'K' or gs_brand = 'U' then
////						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20101' ) )" + &
////										" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
////										" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
////										" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
////										" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and isnull(for_lotte,'N') <> 'Y' "
////					else 
////						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20101' ) )" + &
////										" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
////										" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
////										" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
////										" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') ))  and isnull(for_lotte,'N') <> 'Y' " 					
////					end if					
////				end if
////			else
////				if mid(gs_shop_cd,3,4) >= "1900" and mid(gs_shop_cd,3,4) <= "1913" then 
////					gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and  year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  >  '20054'  " 				 			
////				else
////					if gs_brand = "N" then
////						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20101' ) )" + &
////										" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
////										" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
////										" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
////										" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') = 'Y' " 					
////							
////					elseif gs_brand = "O" then
////						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and ( ( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20094' ) or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20094'  and plan_yn = 'Y' )  )" + &
////										" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
////										" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
////										" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
////										" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') = 'Y' " 					
////					elseif gs_brand = 'B' or gs_brand = 'P' or gs_brand = 'K' then
////						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20101' ) )" + &																										
////										" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
////										" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
////										" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
////										" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and isnull(for_lotte,'N') = 'Y' " 					
////	
////					else 
////						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20101' ) )" + &																										
////										" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
////										" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
////										" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
////										" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') = 'Y' " 					
////					end if					
////				end if					
////			end if			
//			
//
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" + &
//				                " and chno  LIKE '" + ls_chno + "%'" + &
//				                " and color LIKE '" + ls_color + "%'" + &
//				                " and size  LIKE '" + ls_size + "%'" 
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
//				IF lds_Source.GetItemString(1,"plan_yn") = 'Y' THEN 
//					dw_body.Setitem(al_row, "shop_type", '3')
//				ELSE
//					dw_body.Setitem(al_row, "shop_type", '1')
//				END IF
//				
//				ls_style = lds_Source.GetItemString(1,"style")
//				ls_color = lds_Source.GetItemString(1,"color")				
//				
//				
//					Select shop_type
//				into :ls_shop_type
//				From tb_56012_d_color with (nolock)
//				Where style      = :ls_style 
//				  and color      = :ls_color	
//				  and start_ymd <= :is_yymmdd
//				  and end_ymd   >= :is_yymmdd
//				  and shop_type <> '9'
//				  and shop_cd    = :gs_shop_cd ;
//				
//				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
//					Select shop_type
//					into :ls_shop_type
//					From tb_56012_d with (nolock)
//					Where style      = :ls_style 
//					  and start_ymd <= :is_yymmdd
//					  and end_ymd   >= :is_yymmdd
//					  and shop_type <> '9'
//					  and shop_cd    = :gs_shop_cd ;
//				end if
//			
//				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
//					ls_shop_type = "1"
//				end if	
//				
//				//if ls_shop_type > "3" then 
//				//	messagebox("경고!", "정상 판매등록이 불가능한 제품입니다!")
//				//	ib_itemchanged = FALSE
//				//	return 1					
//				//end if					
//								
//				SELECT  ISNULL(RTRN_YMD, 'XXXXXXXX')
//				INTO :LS_RTRN_YMD
//				FROM tb_54020_h
//				WHERE STYLE = :LS_STYLE
//				AND   DEP_FG = 'Y';
//				
//
//				if IsNull(LS_RTRN_YMD) or Trim(LS_RTRN_YMD) = "" then
//				   LS_RTRN_YMD = "XXXXXXXX"
//				end if
//
//				if gs_user_id <> 'IE1912' then //주소연대리 요청 : 압구정CJ몰 판매가능하게(20130723)
//					if gs_shop_div <> 'M' then //장나영차장 요청 : 면세점은 부진처리 후에도 정상으로 판매가능하게 (20140722)
//						if ls_shop_type < "3"  then 
//							//IF LS_RTRN_YMD <= IS_YYMMDD THEN 
//							//	messagebox("경고!", "부진적용일이후 정상 판매,반품등록은 불가능합니다! 관리팀에 연락 바랍니다!")
//							//	ib_itemchanged = FALSE						
//							//	return 1
//							//END IF	
//						end if					
//					end if
//				end if	
//
//				
//				select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX'), isnull(for_lotte,'N')
//				into :ls_given_fg, :ls_given_ymd, :ls_for_lotte
//				from beaucre.dbo.tb_12020_m with (nolock)
//				where style like :ls_style + '%';
//				
//				IF ls_given_fg = "Y"  THEN 
//					messagebox("품번검색", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")					
//					dw_body.SetItem(al_row, "style_no", "")
//					ib_itemchanged = FALSE
//					return 1 	
//				END IF 		
//
//		   	IF gs_shop_div <> "L" and ls_for_lotte = "Y"  THEN 
//					messagebox("품번검색", "전용상품으로 전용매장코드에서만 등록 가능합니다!")					
//					dw_body.SetItem(al_row, "style_no", "")
//					ib_itemchanged = FALSE
//					return 1 	
//				END IF 		
//
//
//			   select work_gubn, given_ymd
//				into :ls_work_gubn, :ls_given_ymd
//				from beaucre.dbo.tb_56040_m with (nolock)
//				where style like :ls_style + '%'
//				and   gubn = 'C';
//				
//				IF (ls_work_gubn = "S" or ls_work_gubn = "A") and ls_given_ymd <= is_yymmdd THEN 
//					messagebox("품번검색", ls_given_ymd + "일자로 판매불가로 전환된 제품입니다!")					
//					dw_body.SetItem(al_row, "style_no", "")
//					ib_itemchanged = FALSE
//					return 1 	
//				END IF 		
//
//
//				ls_style = lds_Source.GetItemString(1,"style")
//				ls_chno  = lds_Source.GetItemString(1,"chno")
//				ls_color = lds_Source.GetItemString(1,"color")
//				ls_size = lds_Source.GetItemString(1,"size")	
//		
//				Select isnull(ord_qty,0), isnull(ord_qty_chn,0)
//				  into :ll_ord_qty, :ll_ord_qty_chn  
//				  from tb_12030_s with (nolock)
//				 where brand = :gs_brand 
//					and style = :ls_style 
//					and chno  = :ls_chno
//					and color = :ls_color 
//					and size  = :ls_size;
//				if gs_brand <> 'M' then
//					if ll_ord_qty - ll_ord_qty_chn <= 0  then 
//						messagebox("경고!",  "국내에 출고 되지 않는 제품입니다!")
//						dw_body.SetItem(al_row, "style_no", "")
//						ib_itemchanged = FALSE
//						return 1 	
//					end if	
//				end if	
//		
// 				IF wf_style_set(al_row, ls_style, is_yymmdd, 1) THEN 
//				   dw_body.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
//				   dw_body.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
//				   dw_body.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
//				   dw_body.SetItem(al_row, "color", lds_Source.GetItemString(1,"color"))
//				   dw_body.SetItem(al_row, "size", lds_Source.GetItemString(1,"size"))
//				   dw_body.SetItem(al_row, "brand", lds_Source.GetItemString(1,"brand"))
//				   dw_body.SetItem(al_row, "year", lds_Source.GetItemString(1,"year"))
//				   dw_body.SetItem(al_row, "season", lds_Source.GetItemString(1,"season"))
//				   dw_body.SetItem(al_row, "sojae", lds_Source.GetItemString(1,"sojae"))
//				   dw_body.SetItem(al_row, "item", lds_Source.GetItemString(1,"item"))
//					dw_body.SetItem(al_row, "goods_amt", 0)
//					dw_body.SetItem(al_row, "give_rate", 0)
//					dw_body.SetItem(al_row, "coupon_no", "")
//					dw_body.SetItem(al_row, "phone_no", "")
//					dw_body.SetItem(al_row, "visiter", "")
//					dw_body.SetItem(al_row, "shop_cd", gs_shop_cd)
//					dw_body.SetItem(al_row, "yymmdd", is_yymmdd)
//					wf_style_set(al_row, ls_style, is_yymmdd, 1)  
//				   ib_changed = true
//               cb_update.enabled = true
//				   /* 다음컬럼으로 이동 */
//				   ll_row_cnt = dw_body.RowCount()
//				   IF al_row = ll_row_cnt THEN 
//					   ll_row_cnt = dw_body.insertRow(0)
//				   END IF
//				   dw_body.SetRow(ll_row_cnt)  
//				   dw_body.SetColumn("style_no")
//				   This.Post Event ue_tot_set()
//			      lb_check = TRUE 
//				END IF
//				ib_itemchanged = FALSE
//			END IF
//
//////////////////			
////			SELECT  'ok'
////			INTO :ls_ok
////			FROM tb_12020_m
////			WHERE STYLE = :LS_STYLE		
////			and   brand = 'W'
////			and   (year < '2007' or 
////					 (year = '2007' and season in ('S','M'))
////					);
////		
////			if ls_ok = 'ok' and ls_shop_type < "4"  and IS_YYMMDD >= '20070909' then 
////					messagebox("경고!", "W. 7M이전제품은 9/9일부로 정상.기획판매,반품등록은 불가능합니다! 관리팀에 연락 바랍니다!")
////					ib_itemchanged = FALSE	
////					return 0
////			end if
////			
/////////////////	
//
//			Destroy  lds_Source
//
//	CASE "style_no_back"		
//			IF ai_div = 1 THEN 	
//				//IF wf_style_chk_back(al_row, as_data)  THEN
//					
//				//	RETURN 0 
//				//END IF 
//			END IF
//		
//	CASE "style"		
//
//			
//		   gst_cd.ai_div          = ai_div
//			gst_cd.window_title    = "품번 코드 검색" 
//			gst_cd.datawindow_nm   = "d_com011" 
//			gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' "
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "style  LIKE '" + AS_DATA + "%'"  
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
//				   //dw_6.SetRow(al_row)
//				   //dw_6.SetColumn(as_column)
//				END IF
//				
//				select count(shop_cd)
//				into :li_shop_cnt
//				from TB_51035_H (nolock)
//				where shop_cd = :gs_shop_cd
//				  and :is_yymmdd between frm_ymd and to_ymd ;
//				  
//				if li_shop_cnt <> 0 then
//					LS_STYLE = lds_Source.GetItemString(1,"style")
//					//dw_6.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
//					//DW_7.RETRIEVE(gs_shop_cd, LS_STYLE)
//				else
//					messagebox("경고!", "행사진행 기간에만 조회가능합니다!")
//				end if	
//				
//			   /* 다음컬럼으로 이동 */
//		      lb_check = TRUE 
//				ib_itemchanged = FALSE
//			END IF
//			Destroy  lds_Source
//		
//			
//END CHOOSE
//
//IF ai_div = 1 THEN 
//	IF lb_check THEN
//      RETURN 2 
//	ELSE
//		RETURN 1
//	END IF
//END IF
//
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



if MidA(gs_shop_cd,3,4) = '2000' and gs_brand <> "E" then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

if MidA(gs_shop_cd,2,1) = 'I' and gs_brand =  "N" then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
//	open(W_SH133_E)//, '행사판매일보등록') // 온앤온행사분리매장
	return false
end if	


if gs_brand <>  "N" then
	messagebox("주의!", '온앤온 매장에서만 사용할 수 있습니다!')
	Close (this)
//	open(W_SH133_E)//, '행사판매일보등록') // 온앤온행사분리매장
	return false
end if	

is_yymmdd  = dw_head.GetItemString(1, "yymmdd")
is_sale_no = dw_head.GetitemString(1, "sale_no")

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")



if MidA(gs_shop_cd	,1,1) = "N" then
	dw_body.Object.ok_coupon.Protect = 0
	//st_8.TEXT = "※ 예약판매 등록 화면입니다."
		
else		
	dw_body.Object.ok_coupon.Protect = 1
	//st_8.TEXT = "※ 판매유형은 온앤온만 적용중입니다!"
end if	


Return true 
 

end event

event pfc_postopen();call super::pfc_postopen;integer li_cnt, li_cnt2


	
cb_1.TriggerEvent(Clicked!)


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
			cb_print.enabled = true
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
	if isnull(Trim(dw_body.GetItemString(ll_cur_row,"empty_4"))) then
		il_rows = dw_body.DeleteRow (ll_cur_row)
	else
		dw_body.SetFocus()
		RETURN
	end if
else
	il_rows = dw_body.DeleteRow (ll_cur_row)
	dw_body.SetFocus()
END IF 

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

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

il_rows = dw_list.Retrieve(is_fr_yymmdd, is_to_yymmdd, gs_shop_cd) 



dw_body.Visible = False
dw_1.Visible = False
dw_list.Visible = True

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;string ls_yymmdd, ls_shop_cd, ls_yymm_p, ls_yymm_n
long ll_rowcnt
string ls_deposit_chk, ls_date
//datetime ld_datetime

select convert(varchar(8), getdate(),112)
  into :ld_datetime2
  from dual;





dw_head.setitem(1,"yymmdd",ld_datetime2)

dw_head.setitem(1,"fr_yymmdd",ld_datetime2)
dw_head.setitem(1,"to_yymmdd",ld_datetime2)




if gs_user_id = "TB1004" or gs_shop_div = 'M' then 
	dw_head.object.yymmdd.protect = 0
else
	dw_head.object.yymmdd.protect = 1
end if




ls_date = dw_head.GetItemString(1,'yymmdd')

//ls_date = mid(ls_date,1,4) + mid(ls_date,6,2) + mid(ls_date,9,2)



//마감하는 년도시즌 가져오는 펑션
wf_close_check(gs_brand,is_close_ymd_t,is_year_t,is_season_t,is_season_nm_t,is_season_s_t,is_s_gubn_t,is_e_gubn_t,is_p_gubn_t,is_close_ymd_f,is_year_f,is_season_f,is_season_nm_f,is_season_s_f,is_s_gubn_f,is_e_gubn_f,is_p_gubn_f)





if isnull(is_close_ymd_f) then
	is_close_ymd_f = ''
end if

//if gs_brand = 'N' or gs_brand = 'O' or gs_brand = 'I' then
//	if ls_date >= is_close_ymd_t then
//		ST_2.TEXT = "※ " + is_year_t + "년 " + is_season_nm_t + " 이전 제품은 관리팀에 문의 바랍니다!" + is_close_ymd_t
//	else
//		ST_2.TEXT = "※ " + is_year_f + "년 " + is_season_nm_f + " 이전 제품은 관리팀에 문의 바랍니다!" + is_close_ymd_f	
//	end if
//end if



if gs_shop_div = 'M' then
	st_2.text = ''
end if

	

ll_rowcnt = idw_event_id.RowCount()

//messagebox("ll_rowcnt", string(ll_rowcnt, "00000"))


	

	
select convert(char(08), getdate(),112)
into :ls_yymmdd
from dual;


//if ls_yymmdd > '20060606' then 
//		dw_1.object.cb_dept_give.visible = false
//end if






is_member_return  = 'N'


// 인기도조사 투표 확인

il_rows = dw_15.retrieve(gs_shop_cd)
//il_rows = dw_16.retrieve(gs_shop_cd)
//if il_rows > 0 then 
//	dw_16.title = '매장:' + gs_shop_cd + ' ' + gs_shop_nm
//	dw_16.visible = true
//end if

//if il_rows > 0 then 
//	
//	integer Net
//	Net = MessageBox("확인","출고상품 인기도조사 미투표건이 존재합니다..투표하세요!!")
////	w_main01.shl_1.visible = true
//else
////	w_main01.shl_1.visible = false
//end if	


//대리점 입금관련 메세지
select dbo.SF_DepositDay_CHK(:gs_shop_cd, :ls_yymmdd)
into :ls_deposit_chk
from dual;

IF isnull(ls_deposit_chk) = false and  Trim(ls_deposit_chk) = "Y" THEN
	messagebox("알림!","오늘은 입금일입니다!")
end if



//반품율현황 
ls_date = MidA(ls_date,1,6)

if MidA(gs_shop_cd,2,1) = 'H' then
	select dbo.SF_DOTCOM_SHOP(:gs_shop_cd)	
	into :ls_shop_cd
	from dual;
else
	ls_shop_cd = gs_shop_cd
end if

end event

event resize;call super::resize;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/

This.arrangesheets(Layer!)

shl_member.move(667,newheight - 425)

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
dw_print.retrieve(ls_yymmdd, ls_shop_cd, ls_sale_no)
ls_add1 = dw_print.getitemstring(1,'cust_addr')
		
if LenA(ls_add1) > 32 then	
	for  li_rcnt = ll_cnt   to 1 step -1
		if MidA(ls_add1,li_rcnt,1) = ' ' then
				li_mid = li_rcnt
		end if 
	next
		
	if li_mid < 1 then
		li_mid = 32
	end if	
	dw_print.object.t_addr_1.text = MidA(ls_add1,1,li_mid)
	dw_print.object.t_addr_2.text = MidA(ls_add1,li_mid+ 1, LenA(ls_add1))
else
	dw_print.object.t_addr_1.text = ls_add1
end if

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
	dw_print.object.p_1.filename = gs_brand + '_logo_1.bmp'	
	dw_print.object.p_3.filename = gs_brand + '_logo_2.bmp'
	dw_print.object.p_4.filename = gs_brand + '_qr_1.bmp'
	
	if gs_shop_cd = 'KB2500' then
		dw_print.object.t_1.text = '215-81-93610'
		dw_print.object.t_3.text = '올리브데올리브(주)'
	else 
		dw_print.object.t_1.text = '215-81-36619'
		dw_print.object.t_3.text = '(주)보끄레머천다이징'
	end if
	
	dw_print.object.t_gubn.text = '[ 고객용 ]'
	dw_print.Print()
	dw_print.object.t_gubn.text = '[ 매장용 ]'
	dw_print.Print()
	dw_print.object.t_gubn.text = '[ 본사용 ]'
	dw_print.Print()
END IF

dw_print.object.t_addr_1.text = ''
dw_print.object.t_addr_2.text = ''
dw_print.object.t_gubn.text   = ''

This.Trigger Event ue_msg(6, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
String   ls_style_no,   ls_sale_fg,   ls_card_no  , ls_coupon_no , ls_jumin, ls_item, ls_card_no_origin, ls_date, ls_shop_type1,ls_empty_4
long     ll_sale_price, ll_goods_amt, ll_sale_qty , ll_coupon_amt, ll_accept_point
long     i, iii, ll_row_count, ll_chk, ll_give_rate, k, ll_excp_cnt
decimal	ldc_dc_rate, ld_goods_amt, ldc_sale_qty
datetime ld_datetime
int		li_point_seq	, ii, li_cnt
String   ls_shop_type, ls_sale_type, ls_dot_com, ls_shoP_cd, ls_shop_div, ls_phone_no, ls_ok_coupon, ls_mem_dc_yn, ls_dotcom_tmp, ls_visiter
long		ll_sale_qty1, ll_sale_total,ll_chk_sale_price,li_chk_cnt,ll_chk_sale_amt
decimal  ld_dc_rate_tmp
string	ls_sale_type_tmp, ls_style, ls_season, ls_coupon_no_chk , ls_sale_no, gs_user_name

string ls_rtrn_yn
long ll_rtrn_tag_amt, ll_limit_rtrn_amt, ll_real_rtrn_amt, ll_sale_rtrn_qty
string ls_date_1, ls_date_2
datetime ld_date_t, ld_date_time
string ls_date_time
long ll_sale_cnt, ps_empty_6
String ps_sale_no, ps_yymmdd, ps_shop_cd, ps_shop_type, ts_sale_no, ps_no, ps_empty_4, ps_empty_5


IF dw_body.AcceptText() <> 1 THEN RETURN -1


IF dw_1.AcceptText()    <> 1 THEN RETURN -1

SELECT GetDate(), GetDate()
  INTO :ld_date_t, :ld_date_time
  FROM DUAL ;

/*등록일자가져오기*/
ls_date_1 = string(ld_date_t, "YYYYMMDD")
ls_date_2 = dw_head.getitemString(1,'yymmdd')



dw_1.setfocus()
dw_1.setcolumn("goods_amt")
is_yymmdd = dw_body.getitemString(1,'yymmdd')

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF





ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
ld_goods_amt  = dw_1.GetitemDecimal(i, "goods_amt")

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
	

	
	
	
//IF isnull(dw_1.Object.age_grp[1]) THEN
//	MessageBox("경고", "연령층 이나 회원정보를 등록하십시오 !") 
//	Return 0 
//END IF
//

//*******************

ll_row_count = dw_body.RowCount()
dw_body.accepttext()


	ls_sale_type_tmp = dw_body.getitemstring(i,"sale_type")	


// 쿠폰저장전 최종 체크

FOR i=1 TO ll_row_count
	ls_coupon_no_chk  = dw_body.Getitemstring(i, "coupon_no")	
	if trim(ls_coupon_no_chk) <> "" then
		ls_coupon_no = ls_coupon_no_chk
	end if		
NEXT	
	
if trim(ls_coupon_no) <> "" and (UPPER(ls_coupon_no) = 'N17005') then
	li_chk_cnt = 0
	ll_chk_sale_price = 0
	ll_chk_sale_amt = 0
	FOR i=1 TO ll_row_count
		ls_sale_type_tmp = dw_body.GetitemString(i, "sale_type")
		ll_chk_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))	
		ld_dc_rate_tmp = dw_body.GetitemDecimal(i, "dc_rate")
		if ls_sale_type_tmp < "33"  and ls_sale_type_tmp <> "22" then
			ll_chk_sale_amt = ll_chk_sale_amt + ll_chk_sale_price
		end if	

	NEXT
	
	if ll_chk_sale_amt < 200000 then
		MessageBox("쿠폰오류", "정상 합계 20만원 이상에 사용 되도록 발행된 쿠폰입니다!")
		return 0			
	end if
end if

for i=1 to ll_row_count	
	ls_dotcom_tmp	= dw_body.GetitemString(i, "dotcom")	
	IF ls_dotcom_tmp = "1" then 

		for iii=1 to ll_row_count
			ls_mem_dc_yn	= dw_body.GetitemString(iii, "mem_dc_yn")		
			IF ls_mem_dc_yn = "Y" then
				messagebox("경고!","닷컴매출과 즉시할인매출은 동시등록이 불가능합니다! 다시한번 확인하세요!")
				Return 0 
			END IF
		next

	END IF
next

for i=1 to ll_row_count
	ld_dc_rate_tmp = dw_body.getitemNumber(i,"dc_rate")
	ls_sale_type_tmp = dw_body.getitemstring(i,"sale_type")	
	ls_coupon_no  = dw_body.Getitemstring(i, "coupon_no")	
	
	// 201404 온,코 구매할인권 관련 체크		
	if gs_brand = 'N' and (ls_coupon_no='N14120' or ls_coupon_no='N14150' or ls_coupon_no='N14130') and (ld_dc_rate_tmp > 5 or ls_sale_type_tmp >= '22') then						
		MessageBox('경고', '정상(no sale) 제품에만 사용할수 있습니다.')  
		Return 0 
	end if								
		
next


//*******************
for i=1 to ll_row_count
	ll_give_rate = dw_body.getitemNumber(i,"give_rate")
	if ll_give_rate > 0 then
		wf_set_margin(i, ll_give_rate)
	end if			
next
//*******************

FOR i = ll_row_count to 1 step -1 
	ls_style_no = dw_body.GetitemString(i, "style_no")
	IF isnull(ls_style_no) THEN
		dw_body.DeleteRow(i) 
	END IF
NEXT 

ll_row_count = dw_body.RowCount()



///////////////////세일 번호 체크 //////////////////////////////////
IF ll_row_count > 0 AND dw_body.GetItemStatus(1, 0, Primary!) <> NewModified! THEN 
	is_sale_no = dw_body.GetitemString(1, "sale_no")
ELSE
	 select right(isnull(max(SALE_NO), 0) + 10001, 4)
	 INTO :ls_sale_no 
	  from tb_53017_h(nolock) 
	 where yymmdd    = :is_yymmdd 
		and shop_cd   = :gs_shop_cd 
		and shop_type in ('1', '3');
			
			
	is_sale_no = ls_sale_no
	
END IF




/***********20160617~20160619 10만원이상 구매시 3만원 추가즉시할인 체크 적용
            1) 온앤온 대구백화점 : 2015년 12월 04일(금) ~ 12월 6일(일), 3일간 
**********************/
if isnull(ls_dotcom_tmp) then 
	ls_dotcom_tmp = '' 	
end if

string ls_dotcom_temp[],ls_dotcom_tmp4
if gs_brand = "N" and gs_shop_div <> "H" and is_yymmdd >= "20160617" and is_yymmdd <= '20160619' and gs_shop_cd = 'NG1001' then
	for i=1 to ll_row_count
		ls_dotcom_temp[i]	= dw_body.GetitemString(i, "dotcom")
		if ls_dotcom_temp[i] = '1' then
			ls_dotcom_tmp4 = '1'
			messagebox("경고!","닷컴매출과 즉시할인매출은 동시등록이 불가능합니다! 다시한번 확인하세요!")
			Return 0 
		else
			ls_dotcom_tmp4 = '0'
		end if
	next
end if

IF gs_brand = "N" and gs_shop_div <> "H" and is_yymmdd >= "20160617" and is_yymmdd <= '20160619' and gs_shop_cd = 'NG1001' then
	This.Trigger Event ue_tot_set()
END IF



/***********20161008~20161014 30만원이상 구매시 3만원 추가즉시할인 체크 적용
            1) 온앤온 롯데안산 매장 : 2016년 10월 08일(토) ~ 10월 14일(금), 7일간 
**********************/

IF gs_brand = "N" and gs_shop_div <> "H" and is_yymmdd >= "20161008" and is_yymmdd <= '20161014' and gs_shop_cd = 'NG1109' then
	This.Trigger Event ue_tot_set()
//	wf_goods_chk5(ld_goods_amt,ls_coupon_no)
END IF
/****************************************************************************/

/***********20170602~20170630 10만원이상 구매시 3만원 추가즉시할인 체크 적용
            1) 온앤온 프로모션 매장 : 2017년 06월 01일(금) ~ 06월 30일(금), 30일간 
**********************/
//	ls_coupon_no  = dw_body.Getitemstring(i, "coupon_no")
//IF gs_brand = "N" and gs_shop_div <> "H" and is_yymmdd >= "20170602" and is_yymmdd <= '20170630' and ls_coupon_no = 'N17002' then
//	This.Trigger Event ue_tot_set()
//	wf_goods_chk3()
//END IF


/****************************************************************************/

/* point 판매 처리 및 가능여부 체크 (정상판매단가가  Point금액 이상 매출만 가능)*/
ll_goods_amt = dw_1.GetitemNumber(1, "goods_amt")  // point금액 

IF isnull(ll_goods_amt) THEN ll_goods_amt = 0 
	ls_card_no   = dw_1.GetitemString(1, "card_no")
IF isnull(ls_card_no) = FALSE AND LenA(ls_card_no) = 9 THEN
	ls_card_no = '4870090' + ls_card_no 
ELSE
	Setnull(ls_card_no)
END IF
		
string ls_year_1, ls_season_1, ls_coupon_no_1, ls_sale_type_1, ls_style_no1
FOR i=1 TO ll_row_count
		idw_status = dw_body.GetItemStatus(i, 0, Primary!)
		ls_dot_com = dw_body.GetItemString(i, "dotcom")
		ls_ok_coupon = dw_body.GetItemString(i, "ok_coupon") //예약판매구분으로 변경 201808
		ldc_sale_qty = dw_body.GetItemNumber(i, "sale_qty")		
		ls_coupon_no_1 =  dw_body.GetItemString(i, "coupon_no")
		ls_sale_type_1 =  dw_body.GetItemString(i, "sale_type")
		ls_year_1    = dw_body.GetItemString(i, "year")
		ls_style_no1 = dw_body.GetItemString(i, "style_no")
		ps_empty_5   = dw_body.GetItemString(i, "empty_5")
		//ps_yymmdd    = dw_body.GetitemString(i, "yymmdd")
		
		
		
		
		If isnull(ps_empty_5) or Trim(ps_empty_5) = '' then
			messagebox('확인','반품사유를 입력해주세요.')
			return 0
		end if
		
		//If isnull(ps_empty_6) then
		//	messagebox('확인','판매/반품여부를 선택해주세요.')
		//	return 0
		//end if
		

		if gs_shop_cd = 'OD0002' then
			ls_dot_com = '1'
		end if	
			
		if (ls_coupon_no_1 = 'N17004' and ls_sale_type_1 > '40' ) or (ls_coupon_no_1 = 'N17004' and ls_year_1 >= '2017' and ls_season_1 = 'm')  then
			MessageBox("확인", "2017년 가을(A)상품은 정상/세일/기획 , 겨울(W)상품은 정상/세일/기획 제품에만 사용할수 있습니다!")  
			return 0
		end if
		
		if ls_ok_coupon = "Y" then
			ii = ii + 1
		end if
				
		if ls_dot_com = "1"  and gs_shop_div <> "L" then 
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
				
			elseif gs_shop_cd = 'OD0002' then
				select a.shoP_cd, a.shop_div
				into :ls_shoP_cd, :ls_shop_div
				from tb_91100_m a (nolock)
				where exists (	select * 
						from tb_91100_m b (nolock) 
						where b.shoP_div in ('B','G','D')
						  and b.brand = a.brand
						  and b.cust_cd = a.cust_cd
						  and b.shop_cd = :gs_shop_cd
						)
				and shop_div = 'H'
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
					  from tb_53017_h (nolock)
					 where yymmdd    = :is_yymmdd 
						and shop_cd   = :ls_shop_cd
						and shop_type in ('1','3');
				end if		
				

			//닷컴은 브랜드데이 적용이 안되게 수정함.
			//작업일자:2012.8.16  작업자:윤상혁
			select count('shop_cd')
			into :li_cnt
			from tb_56011_d with (nolock)
			where shop_cd = :ls_shop_cd
					and shop_type = '1'
					and sale_type in ('17','18');
					
			if dw_body.getitemstring(i, 'shop_type') = '1' and (dw_body.getitemstring(i, 'sale_type') = '17' or dw_body.getitemstring(i, 'sale_type') = '18') then
				if li_cnt < 1 and dw_body.getitemstring(i,'style_no') <> '' then
					messagebox('확인', 'Dotcom은 브랜드데이 할인율 적용이 되지 않습니다!!!')
					return 0
				end if
			end if
			
	   else
				   ls_shop_cd = gs_shop_cd
					ls_shop_div = gs_shop_div

		end if 

		  IF  idw_status <> NewModified! and gs_shop_div <> "H" and ls_dot_com = "1"  then
				MessageBox("경고", "기존판매분의 닷컴으로의 전환은 불가능합니다.!") 
				Return 0 
 		   END IF

		ls_style = MidA(dw_body.getitemstring(i,'style_no'),1,8)
		
		//닷컴으로 판매시 마진율 한번더 체크해서 닷컴으로 된 마진율 넣기
		//반품의 경우는 제외함.
		//작업일자:2014.10.18  작업자:윤상혁
		ls_visiter = dw_body.getitemstring(i,'visiter')
		if ls_shoP_div = 'H' or ls_shop_cd = 'BG1813' then
			if isnull(ls_visiter) or ls_visiter = '' then
//			if is_member_return <> 'N' then
				if is_member_return <> 'Y' then	
					wf_style_set(i, ls_style, is_yymmdd, ldc_sale_qty)
					if is_mj_bit = 'N' then
						return 0
					end if
				end if
			end if
//			end if
		end if
		
		
		gs_user_name = dw_1.GetitemString(1,"user_name")
						
		If not isnull(gs_user_name) or gs_user_name <> '' then
			ls_visiter = gs_user_name
			dw_body.Setitem(i, "visiter", ls_visiter)
		end if 
						
		IF idw_status = NewModified! THEN			/* New Record */  
			dw_body.Setitem(i, "no",  String(i, "0000"))
			dw_body.Setitem(i, "yymmdd", is_yymmdd)
			dw_body.Setitem(i, "shop_cd",  ls_shop_cd)
			dw_body.Setitem(i, "shop_div", ls_shop_div)
			dw_body.Setitem(i, "sale_no",  is_sale_no)
			dw_body.Setitem(i, "reg_id",   gs_user_id)
			dw_body.Setitem(i, "event_id", gs_shop_cd)			
			dw_body.Setitem(i, "reg_dt", ld_datetime)			
			dw_body.Setitem(i, "org_sale_qty",  ldc_sale_qty)			
			
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */	
		   dw_body.Setitem(i, "shop_cd",  ls_shop_cd)
	      dw_body.Setitem(i, "shop_div", MidA(ls_shop_cd,2,1))	
			dw_body.Setitem(i, "event_id", gs_shop_cd)						
			dw_body.Setitem(i, "mod_id", gs_user_id)
			dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF 
		
		ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))
		ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
		ls_style_no   = dw_body.Getitemstring(i, "style_no")
		ls_item       = RightA(LeftA(ls_style_no,2),1)
		
		ll_goods_amt = dw_body.GetitemNumber(i, "goods_amt")  // point금액 
		
		ls_coupon_no  = dw_body.Getitemstring(i, "coupon_no")	
		
		
	
	

	// 구매할인권 정상+ 30%세일까지만  쿠폰금액이상의 제품에만 사용가능 
		IF LenA(ls_coupon_no) =  6 then	
			
			//  쿠폰으로 2매 구매못하도록 막음 //
			
			IF ll_sale_qty > 1 AND ll_goods_amt > 0   THEN
				MessageBox("경고", "쿠폰은 1PCS에만 적용 판매 할 수 있습니다!") 
				Return 0 
 		   END IF

		 
			
			IF ll_sale_qty > 1 AND ll_goods_amt > 0  and  ll_sale_qty * ll_sale_price > ll_goods_amt then
				MessageBox("경고", "쿠폰금액이상의 제품에만 적용 판매 할 수 있습니다!") 
				Return 0 
 		   END IF			 

					IF ll_goods_amt > 0 and ll_sale_price > ll_goods_amt and  & 
						ll_sale_qty  > 0 and  dw_body.Object.dc_rate[i]  < 31  and dw_body.Object.sale_type[i]  < '30'  THEN  
						ls_sale_fg = '2' 
					ELSEIF LenA(Trim(dw_1.Object.jumin[1])) = 13 and LeftA(dw_body.Object.sale_type[i], 1) <= '2' THEN  // 정상 적용 
						ls_sale_fg = '1' 
					ELSE
						ls_sale_fg = '0' 
					END IF		


		
		
		
   	ELSE		// 마일리지는 정상+ 30%sale 만 사용가능 

					IF ll_goods_amt > 0 and ll_sale_price > ll_goods_amt and  & 
						ll_sale_qty  > 0 and dw_body.Object.dc_rate[i] <  31  and dw_body.Object.sale_type[i]  < '30' THEN  
						ls_sale_fg = '2' 
					ELSEIF LenA(Trim(dw_1.Object.jumin[1])) = 13 and LeftA(dw_body.Object.sale_type[i], 1) <= '2' THEN  // 정상 적용 
						ls_sale_fg = '1' 
					ELSE
						ls_sale_fg = '0' 
					END IF		

		END IF			
	
	

		if is_member_return = 'N' THEN  // 회원반품일때는 처리하지말고 RETURN    
			wf_amt_set(i, ll_sale_qty)
		end if	
			
		
		IF idw_status <> New! THEN 
			//dw_body.Setitem(i, "age_grp", dw_1.Object.age_grp[1])  
			//dw_body.Setitem(i, "sale_fg", ls_sale_fg)
			//dw_body.Setitem(i, "jumin",   Trim(dw_1.Object.jumin[1]))  
			dw_body.Setitem(i, "card_no", ls_card_no)  
		END IF
		
		//ls_jumin     = Trim(dw_1.Object.jumin[1])
		ls_shop_type = dw_body.getitemstring(i, "shop_type")
		ls_sale_type = dw_body.getitemstring(i, "sale_type")	
		ldc_dc_rate  = dw_body.getitemnumber(i, "dc_rate")	
//		ls_card_no_origin = dw_body.getitemnumber(i, "card_no")	

		if isnull(ls_sale_type) or ls_sale_type = '' then 
			messagebox('주의','판매형태가 존재하지 않습니다. 관리팀에 문의하세요..')
			return -1
		end if	
	
	   if ii > 1 then 
			messagebox('주의','이벤트 쿠폰은 한 스타일에만 사용 가능합니다..')
			return -1
		elseif ii = 1 and isnull(ls_card_no) then
			messagebox('주의','회원가입 구매인 경우에만 쿠폰 사용 가능합니다..')
			return -1
		end if	
	
		if is_member_return = 'N' THEN  // 회원반품일때는 처리하지말고 RETURN    
		  wf_line_chk(i)
		end if	
			
		ls_empty_4 = dw_body.GetItemString(i,"empty_4")	
		
		if IsNull(ls_empty_4) or Trim(ls_empty_4) = "" then
			ls_empty_4 = "N"
		end if
		
		
			
	// if GS_BRAND = "N"  and dw_body.Getitemnumber(i, "sale_qty") > 0 and ls_empty_4 <> "N"   and idw_status = DataModified! THEN  // 회원반품일때는 처리하지말고 RETURN    
	//	  if wf_stock_chk(i, ls_style_no1) = false then 
	//		 	MESSAGEBOX("알림!" , "재고가 없는 품번으로 판매처리가 불가 합니다.!")
	//		   return -1
 	//	  end	if
	//	end if			
	
NEXT
		
		
 is_member_return  = 'N'   // 회원 반품 마크 해지 처리 

/* 판매일자와 시스템 날짜가 다르면 재 로그인 처리
   장나영차장님 요청 - '20140408'
*/


IF dw_head.AcceptText()    <> 1 THEN RETURN -1


if gs_shop_div <> 'M'  then
	IF ls_date_1 <> ls_date_2 then
		messagebox('확인','판매 입력일이 다릅니다. 재 로그인 해주시기 바랍니다!')
		Return 0
	END IF
end if



il_rows = dw_body.Update(TRUE, FALSE)



if il_rows = 1 then
	ls_phone_no = dw_body.getitemstring(1,"phone_no")
//	messagebox('ls_phone_no',ls_phone_no)
	if ls_phone_no <> '미지정매장' then
	   
	end if
	
	

   dw_body.ResetUpdate()
	if ls_phone_no <> '미지정매장' then
	 
	end if
	

	
   commit  USING SQLCA;

	dw_body.Retrieve(is_yymmdd, gs_shop_cd, is_sale_no) 
	cb_1.SetFocus()
else
   rollback  USING SQLCA;
end if

Post Event ue_tot_set()

//if gs_shop_cd = 'GB1807' or gs_shop_cd = 'TB1004' then
//	integer Net
//	Net = MessageBox("영수증출력", "영수증을 출력 하시겠습니까?", Exclamation!, OKCancel!, 2)
//	
//	IF Net = 1 THEN 
//		cb_print.TriggerEvent(Clicked!)
//	END IF
//end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

type cb_close from w_com010_e`cb_close within w_sh194_e
boolean visible = false
integer x = 389
end type

type cb_delete from w_com010_e`cb_delete within w_sh194_e
integer x = 1769
integer width = 315
integer taborder = 70
end type

type cb_insert from w_com010_e`cb_insert within w_sh194_e
boolean visible = false
integer taborder = 60
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh194_e
integer x = 2469
integer width = 384
integer taborder = 110
string text = "요청조회(&Q)"
end type

event cb_retrieve::clicked;call super::clicked;datetime ld_datetime

dw_head.object.t_1.visible = True
dw_head.object.t_2.visible = True
dw_head.object.fr_yymmdd.visible = True
dw_head.object.to_yymmdd.visible = True


dw_head.object.yymmdd_t.visible = False
dw_head.object.yymmdd.visible = False

st_2.visible = False
st_8.visible = False
end event

type cb_update from w_com010_e`cb_update within w_sh194_e
integer taborder = 50
end type

type cb_print from w_com010_e`cb_print within w_sh194_e
integer x = 1376
integer width = 393
integer taborder = 80
boolean enabled = true
string text = "영수증출력(&P)"
end type

event cb_print::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
/*
string ls_yymmdd, ls_sale_no, ls_shop_cd, ls_add1
double li_mid
int li_rcnt, ll_cnt

ls_yymmdd  = dw_body.getitemstring(1,'yymmdd')
ls_shop_cd = dw_body.getitemstring(1,'shop_cd')
ls_sale_no = dw_body.getitemstring(1,'sale_no')

dw_print.retrieve(ls_yymmdd, ls_shop_cd, ls_sale_no)
ls_add1 = dw_print.getitemstring(1,'cust_addr')
		
if len(ls_add1) > 32 then	
	for  li_rcnt = ll_cnt   to 1 step -1
		if mid(ls_add1,li_rcnt,1) = ' ' then
				li_mid = li_rcnt
		end if 
	next
		
	if li_mid < 1 then
		li_mid = 32
	end if	
	dw_print.object.t_addr_1.text = mid(ls_add1,1,li_mid)
	dw_print.object.t_addr_2.text = mid(ls_add1,li_mid+ 1, len(ls_add1))
else
	dw_print.object.t_addr_1.text = ls_add1
end if

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
	dw_print.object.t_gubn.text = '[ 고객용 ]'
   dw_print.Print()
	dw_print.object.t_gubn.text = '[ 매장용 ]'
	dw_print.Print()
END IF
dw_print.object.t_addr_1.text = ''
dw_print.object.t_addr_2.text = ''
dw_print.object.t_gubn.text   = ''

//This.Trigger Event ue_msg(6, il_rows)
*/
end event

type cb_preview from w_com010_e`cb_preview within w_sh194_e
boolean visible = false
integer x = 1193
integer y = 48
integer taborder = 90
end type

type gb_button from w_com010_e`gb_button within w_sh194_e
end type

type dw_head from w_com010_e`dw_head within w_sh194_e
integer y = 152
integer width = 2601
integer height = 96
string dataobject = "d_sh194_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_yymmdd
//

CHOOSE CASE dwo.name
	CASE "yymmdd"
		ls_yymmdd = String(Date(data), "yyyymmdd")
      IF GF_IWOLDATE_CHK(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN
			MessageBox("일자변경", "소급할수 없는 일자입니다.")
			Return 1
		END IF
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_sh194_e
integer beginy = 336
integer endy = 336
end type

type ln_2 from w_com010_e`ln_2 within w_sh194_e
integer beginy = 340
integer endy = 340
end type

type dw_body from w_com010_e`dw_body within w_sh194_e
event ue_set_column ( long al_row )
integer x = 5
integer y = 348
integer width = 2885
integer height = 960
string dataobject = "d_sh194_d01_new"
boolean hscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

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

event dw_body::doubleclicked;call super::doubleclicked;String ls_style_no, ls_yes , ls_coupon_no, ls_user
Long   ll_curr_price, ll_sale_price, ll_collect_price, ld_goods_amt,ll_dc_rate

//if dwo.name <> "sale_type" OR gs_brand = "O" or  gs_brand = "W" then return

if dwo.name <> "sale_type" or  gs_brand = "W" then return

IF row < 1 THEN RETURN 
ls_style_no = This.GetitemString(row, "style_no")

IF isnull(ls_style_no) or Trim(ls_style_no) = "" THEN RETURN

gsv_cd.gs_cd1 = This.GetitemString(row, "shop_type")
gsv_cd.gs_cd2 = is_yymmdd

//OpenWithParm (W_SH101_P, "W_SH101_P 판매형태 내역") 
ls_yes = Message.StringParm 
IF ls_yes = 'YES' THEN 
	ll_curr_price = This.GetitemNumber(row, "curr_price")
	ld_goods_amt  = This.GetitemNumber(row, "goods_amt")
	ls_user = dw_1.getitemstring(1,'user_name')

	if ls_user <> '' then //고객데이터가 있을경우
		ll_sale_price    = ll_curr_price * (100 - (5 + gsv_cd.gl_cd1)) / 100 
		gf_marjin_price(gs_shop_cd, ll_sale_price, gsv_cd.gdc_cd1, ll_collect_price) 
		idc_dc_rate_org = gsv_cd.gl_cd1
		This.Setitem(row, "dc_rate_org",   gsv_cd.gl_cd1) 
		This.Setitem(row, "sale_type",     gsv_cd.gs_cd3) 
		if gsv_cd.gl_cd1 <= 15 and gs_brand <> 'L' then
			This.Setitem(row, "dc_rate",       5 + gsv_cd.gl_cd1) 
		else
			This.Setitem(row, "dc_rate",       gsv_cd.gl_cd1) 
		end if
		This.Setitem(row, "sale_rate",     gdc_sale_rate )// gsv_cd.gdc_cd1) 
		This.Setitem(row, "sale_price",    ll_sale_price)
		This.Setitem(row, "collect_price", ll_collect_price)
	else //고객데이터가 없을경우
		ll_sale_price    = ll_curr_price * (100 - gsv_cd.gl_cd1) / 100 
		gf_marjin_price(gs_shop_cd, ll_sale_price, gsv_cd.gdc_cd1, ll_collect_price) 
		idc_dc_rate_org = gsv_cd.gl_cd1
		This.Setitem(row, "dc_rate_org",   gsv_cd.gl_cd1) 		
		This.Setitem(row, "sale_type",     gsv_cd.gs_cd3) 
		This.Setitem(row, "dc_rate",       gsv_cd.gl_cd1) 
		This.Setitem(row, "sale_rate",     gdc_sale_rate )// gsv_cd.gdc_cd1) 
		This.Setitem(row, "sale_price",    ll_sale_price)
		This.Setitem(row, "collect_price", ll_collect_price)		
	end if	

	dw_1.Setitem(1, "give_rate", 0)
	
	wf_goods_chk(long(ld_goods_amt), ls_coupon_no)
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

ls_yymmdd = dw_head.getitemString(1,"yymmdd")




end event

event dw_body::clicked;call super::clicked;/*
long i, ll_dc_rate, ll_chk =0, ii, ll_row_count
string ls_style,ls_modify
string ls_brand, ls_year, ls_season, ls_yymmdd
string ls_mem_dc_yn

integer ii_choose


if dwo.name = 'dotcom'  then 	

	
	CHOOSE CASE dwo.name
		case "dotcom"
			ll_row_count = this.rowcount()
			
			FOR i=1 TO ll_row_count	
			
				ls_mem_dc_yn     = dw_body.GetitemString(i, "mem_dc_yn") 
			
				if ls_mem_dc_yn = 'Y' then
					messagebox("경고!","닷컴매출과 즉시할인매출은 동시등록이 불가능합니다! 다시한번 확인하세요!")
	
						for ii = 1 to ll_row_count
							this.setitem(ii , "dotcom", "0")
							is_dotcom_select = 'N'							
//							dw_body.dotcom.checked = false
						next
				end if
	
			NEXT	
			
	end CHOOSE
		
		
end if
*/

end event

type dw_print from w_com010_e`dw_print within w_sh194_e
integer x = 1385
integer y = 224
integer width = 1349
integer height = 948
boolean enabled = false
string dataobject = "d_sh194_p01"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

type dw_1 from datawindow within w_sh194_e
event ue_keydown pbm_dwnkey
event type long ue_item_changed ( long row,  dwobject dwo,  string data )
integer x = 5
integer y = 1312
integer width = 2880
integer height = 576
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh194_d02"
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

event type long ue_item_changed(long row, dwobject dwo, string data);string  ls_coupon_no, ls_secure_no, ls_tel_no3, ls_card_no
string  ls_s_user_name, ls_s_birthday, ls_s_tel_no3_4
decimal ld_goods_amt, ll_sale_qty, ll_sale_amt
long    i, ll_row_count

IF dw_1.AcceptText() <> 1 THEN RETURN 1

CHOOSE CASE dwo.name
	CASE "card_no" 
			wf_goods_amt_clear()
			wf_amt_clear()

			//########### 회원 즉시할인 +5% 적용 로직 #####################
			ls_card_no = dw_1.getitemstring(1, "card_no")

			IF Trim(ls_card_no) <> "" THEN 
				//wf_amt_set3(row)
				dw_1.AcceptText()
			END IF
			

		IF uf_member_chk('4', data) = FALSE THEN

			dw_17.visible = true	
			dw_17.Modify("t_brand.text = '"+gs_brand_nm+"'")

			This.Setitem(1, "goods_amt", 0)
			RETURN 1

		end if
			
			
		IF WF_MEMBER_SET('2', data) = FALSE THEN
			if data <> "" then 
				MessageBox("오류", "미등록된 회원 입니다")
			end if
			This.Setitem(1, "goods_amt", 0)
			RETURN 1
		ELSE

				This.Setitem(1, "goods_amt", 0)
				This.SetColumn("goods_amt")
				
				wf_amt_set_row()
			

		END IF
   CASE "jumin"	
			wf_goods_amt_clear()		
			wf_amt_clear()
			
		IF WF_MEMBER_SET('1', data) = FALSE THEN	
			if data <> "" then 
				MessageBox("오류", "미등록된 카드회원 입니다")
			end if
			
			This.Setitem(1, "goods_amt", 0)
			RETURN 1 
		ELSE
			This.Setitem(1, "goods_amt", 0)
			This.SetColumn("goods_amt")

			wf_amt_set_row()

		END IF 

	 CASE "s_user_name"
		wf_goods_amt_clear()
		wf_amt_clear()

		SetPointer(HourGlass!)
		
		ls_s_birthday = RightA(dw_1.getitemstring(1,"s_birthday"),6)
//		ls_s_tel_no3_4 = dw_1.getitemstring(1,"s_tel_no3_4")				

		if isnull(ls_s_birthday) or LenA(ls_s_birthday) < 6 then
//			messagebox("알림!", "[1]생년월일을 정확히 입력하세요.!")
			This.SetColumn("s_birthday")
/*			
		elseif isnull(ls_s_tel_no3_4) or len(ls_s_tel_no3_4) <> 4 then
			messagebox("알림!", "[2]휴대폰 뒷번호 4자리를 정확히 입력하세요.!")
			This.SetColumn("s_tel_no3_4")			
*/			
		else
			IF WF_MEMBER_SET('3', ls_s_birthday) = FALSE THEN
				if data <> "" then 
					MessageBox("오류", "미등록된 회원 입니다")	
				end if
				This.Setitem(1, "goods_amt", 0)				
				RETURN 1 
			ELSE
				This.Setitem(1, "goods_amt", 0)
				This.SetColumn("goods_amt")
				
				wf_amt_set_row()

			END IF 
		end if		

	 CASE "s_birthday"
		wf_goods_amt_clear()
		wf_amt_clear()

//------------
		//########### 회원 즉시할인 +5% 적용 로직 #####################
		ls_s_birthday = RightA(dw_1.getitemstring(1,"s_birthday"),6)

		IF Trim(ls_s_birthday) <> "" THEN 
			//wf_amt_set3(row)
			dw_1.AcceptText()
		END IF

//------------

		SetPointer(HourGlass!)
		
		ls_s_user_name = dw_1.getitemstring(1,"s_user_name")		
//------------		ls_s_birthday = right(dw_1.getitemstring(1,"s_birthday"),6)		

//		ls_s_tel_no3_4 = dw_1.getitemstring(1,"s_tel_no3_4")				
	
		if isnull(ls_s_user_name) then
			messagebox("알림!", "[3]회원명을 정확히 입력하세요.!")
			This.SetColumn("s_user_name")
/*			
		elseif isnull(ls_s_tel_no3_4) or len(ls_s_tel_no3_4) <> 4 then
			messagebox("알림!", "[4]휴대폰 뒷번호 4자리를 정확히 입력하세요.!")
			This.SetColumn("s_tel_no3_4")			
*/			

		else
			IF WF_MEMBER_SET('3', ls_s_birthday) = FALSE THEN
				if data <> "" then 
					MessageBox("오류", "미등록된 회원 입니다")	
				end if
				This.Setitem(1, "goods_amt", 0)				
				RETURN 1 
			ELSE
				This.Setitem(1, "goods_amt", 0)
				This.SetColumn("goods_amt")

				wf_amt_set_row()
				
				
			END IF 
		end if		
		
		//########### 회원 즉시할인 +5% 적용 로직 #####################
//		if data <> '' and ls_s_birthday <> '' then
//			wf_amt_set3(row)
//			dw_1.AcceptText()
//		end if
		
/*
	 CASE "s_tel_no3_4"
		wf_goods_amt_clear()
		wf_amt_clear()
		
		SetPointer(HourGlass!)
		
		ls_s_user_name = dw_1.getitemstring(1,"s_user_name")		
		ls_s_birthday = right(dw_1.getitemstring(1,"s_birthday"),6)				

		if isnull(ls_s_user_name) then
			messagebox("알림!", "[5]회원명을 정확히 입력하세요.!")
			This.SetColumn("s_user_name")
			
		elseif isnull(ls_s_birthday) or len(ls_s_birthday) < 6 then
			messagebox("알림!", "[6]생년월일을 정확히 입력하세요.!")
			This.SetColumn("s_birthday")			
			
		else
			IF WF_MEMBER_SET('3', ls_s_birthday) = FALSE THEN
				if data <> "" then 
					MessageBox("오류", "미등록된 회원 입니다")	
				end if
				This.Setitem(1, "goods_amt", 0)				
				RETURN 1 
			ELSE
				This.Setitem(1, "goods_amt", 0)
				This.SetColumn("goods_amt")

				wf_amt_set_row()
				
				
			END IF 
		end if				
*/		
/*		
	 CASE "tel_no3"
		wf_goods_amt_clear()
		SetPointer(HourGlass!)

		ls_secure_no = dw_1.getitemstring(1,"secure_no")
		if isnull(ls_secure_no) or len(ls_secure_no) <> 3 then
			messagebox("알림!", "주민번호 끝자리 세숫자를 입력하세요!")
			This.SetColumn("secure_no")
		else
			IF WF_MEMBER_SET('3', data) = FALSE THEN
				if data <> "" then 
					MessageBox("오류", "미등록된 카드회원 입니다")	
				end if
				This.Setitem(1, "goods_amt", 0)				
				RETURN 1 
			ELSE
				This.Setitem(1, "goods_amt", 0)
				This.SetColumn("goods_amt")
			END IF 
		end if		
	 CASE "secure_no"
		wf_goods_amt_clear()		
		SetPointer(HourGlass!)

		ls_tel_no3 = dw_1.getitemstring(1,"tel_no3")
		if isnull(ls_tel_no3) or len(ls_tel_no3) < 7 then
			messagebox("알림!", "핸드폰번호를 입력하세요!")
			This.SetColumn("tel_no3")
		else
			IF WF_MEMBER_SET('3', ls_tel_no3) = FALSE THEN
				MessageBox("오류", "미등록된 카드회원 입니다")	
				This.Setitem(1, "goods_amt", 0)				
				RETURN 1 
			ELSE
				This.Setitem(1, "goods_amt", 0)
				This.SetColumn("goods_amt")
			END IF 
		end if			
*/		
	CASE "goods_amt" 
		wf_goods_amt_clear()

			ld_goods_amt = dw_1.getitemdecimal(1,"goods_amt")
			IF not wf_goods_chk(long(ld_goods_amt), ls_coupon_no) and ld_goods_amt <> 0 THEN 		
				this.Setitem(1,"goods_amt",0)
//				Parent.Post Event ue_tot_set()
//				RETURN 1
			END IF


END CHOOSE 

Parent.Post Event ue_tot_set()
end event

event constructor;DataWindowChild ldw_child

This.GetChild("age_grp", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("403")

//This.GetChild("give_amt", idw_give_amt)
//ldw_child.SetTransObject(SQLCA)
//ldw_child.Retrieve('%')
//ldw_child.InsertRow(0)
end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
String ls_jumin, ls_style
decimal ld_dc_rate


	
IF dw_body.AcceptText() <> 1 THEN RETURN -1



IF dwo.name = "b_return" THEN  //회원반품
	
	if MidA(gs_shop_cd,1,1) = "N" then 
		messagebox('알림', '30일이내 정상판매분은 조회/반품요청이 불가 합니다!')	  
	end if	
	
	gs_jumin = dw_1.GetitemString(1, "jumin")
			
	IF isnull(gs_jumin) or gs_jumin = "" Then
		messagebox('확인', '회원반품은 회원조회 후 가능합니다!')	  
		return	0
	END IF
  
	dw_member_sale.reset()
	dw_member_sale.insertrow(1)
	dw_member_sale.setitem(1,"shop_cd",gs_shop_cd)	
	dw_member_sale.setcolumn("style_no")
	dw_member_sale.visible =true
	dw_member_sale.setfocus()
END IF	



IF dwo.name = "b_back_sale" THEN //일반반품

	if MidA(gs_shop_cd,1,1) = "N" then 
		messagebox('알림', '30일이내 정상판매분은 조회/반품요청이 불가 합니다!')	  
	end if	
	
	dw_back_sale.reset()
	dw_back_sale.insertrow(1)
   dw_back_sale.setitem(1,"shop_cd",gs_shop_cd)	
	dw_back_sale.visible =true
	dw_back_sale.setcolumn("style_no")
	dw_back_sale.object.style_no.protect = 0
	dw_back_sale.setfocus()
END IF

IF dwo.name = "cb_gopanda" THEN 
	ls_style = dw_body.getitemstring(1,'style')
	if ls_style = '' or isnull(ls_style) then
		messagebox('확인','판매스타일을 먼저 입력해 주세요!')
		return 0
	end if
	


END IF

Parent.Post Event ue_tot_set()

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

type cb_1 from commandbutton within w_sh194_e
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
string text = "반품입력(&P)"
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
dw_body.enabled = true
dw_1.enabled = true


dw_head.object.t_1.visible = False
dw_head.object.t_2.visible = False
dw_head.object.fr_yymmdd.visible = False
dw_head.object.to_yymmdd.visible = False
st_2.visible = True
st_8.visible = True
dw_head.object.yymmdd_t.visible = True
dw_head.object.yymmdd.visible = True


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
   parent.shl_member.Visible = True		
END IF

dw_body.Reset()
il_rows = dw_body.insertRow(0)
dw_back_sale.reset()
dw_member_sale.reset()
dw_1.Reset()
dw_1.object.text_message.text = ""
dw_1.object.text_message2.text = ""
dw_1.insertRow(0)


dw_body.SetItem(1,"yymmdd", ld_datetime2)
dw_body.SetItem(1,"shop_cd",gs_shop_cd)
dw_body.setcolumn("style_no")
dw_body.setfocus()

Parent.Trigger Event ue_button(6, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type st_1 from statictext within w_sh194_e
integer y = 936
integer width = 2894
integer height = 956
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

type st_2 from statictext within w_sh194_e
integer x = 704
integer y = 156
integer width = 2144
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
string text = "※ 행사품번은 행사판매일보등록에서 등록해주세요."
boolean focusrectangle = false
end type

type dw_15 from datawindow within w_sh194_e
boolean visible = false
integer x = 1595
integer y = 472
integer width = 544
integer height = 596
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "리스트"
string dataobject = "d_vote_list"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_ok_coupon1 from statictext within w_sh194_e
boolean visible = false
integer x = 2450
integer y = 156
integer width = 1179
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 65535
string text = "※ 올리브 OK쿠폰(5%) - 50%DC 미만품목"
boolean focusrectangle = false
end type

type st_ok_coupon2 from statictext within w_sh194_e
boolean visible = false
integer x = 2450
integer y = 204
integer width = 1179
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 65535
string text = "8A: 10/06~~10/31,  8W: 10/06~~10/12"
boolean focusrectangle = false
end type

type shl_member from statichyperlink within w_sh194_e
integer x = 667
integer y = 1664
integer width = 311
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
long textcolor = 16777215
long backcolor = 8421376
string text = "신규등록"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string   ls_url

ls_url = "https://membership.ibeaucre.co.kr:450/member/join.asp?simple=Y&shop_cd="+gs_shop_cd
//ls_url = "http://new-membership.ibeaucre.co.kr/mem_ins_form.htm?shop_cd="+gs_shop_cd
shl_member.url = ls_url

end event

type dw_17 from datawindow within w_sh194_e
boolean visible = false
integer x = 91
integer y = 692
integer width = 2633
integer height = 616
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "고객안내"
string dataobject = "d_sh194_d36"
boolean controlmenu = true
borderstyle borderstyle = styleshadowbox!
end type

type em_1 from editmask within w_sh194_e
boolean visible = false
integer x = 1760
integer y = 416
integer width = 402
integer height = 84
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "1"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#,##0"
end type

type st_8 from statictext within w_sh194_e
integer x = 704
integer y = 232
integer width = 4059
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 반품 요청 화면입니다. 영업관리자에게 문의 후 등록해주세요. 임의로 등록 시 승인 처리가 되지 않습니다."
boolean focusrectangle = false
end type

type st_9 from statictext within w_sh194_e
integer x = 389
integer y = 64
integer width = 1998
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
string text = "※ 승인 처리 후 수정/삭제 불가능합니다. 신중히 등록해주세요!"
boolean focusrectangle = false
end type

type dw_list from datawindow within w_sh194_e
event ue_syscommand pbm_syscommand
integer y = 360
integer width = 2894
integer height = 1712
integer taborder = 110
boolean titlebar = true
string title = "판매일보조회"
string dataobject = "d_sh194_d10"
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

event doubleclicked;String ls_sale_no, ls_jumin, ls_coupon_no, ls_ymd

IF row < 1 THEN RETURN

dw_head.object.t_1.visible = False
dw_head.object.t_2.visible = False
dw_head.object.fr_yymmdd.visible = False
dw_head.object.to_yymmdd.visible = False
st_2.visible = True
st_8.visible = True
dw_head.object.yymmdd_t.visible = True
dw_head.object.yymmdd.visible = True



ls_sale_no = This.GetitemString(row, "sale_no")
ls_jumin   = This.GetitemString(row, "jumin")
ls_coupon_no = This.GetitemString(row, "coupon_no")
ls_ymd = This.GetitemString(row, "yymmdd")
dw_body.Retrieve(ls_ymd, gs_shop_cd, ls_sale_no) 
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

If Trim(this.GetitemString(row, "empty_1")) = 'Y' then
	cb_delete.enabled = False
	cb_update.enabled = False
else
	cb_delete.enabled = True
end if

dw_body.visible = TRUE 
dw_1.visible    = TRUE 
dw_list.visible = FALSE

end event

type shl_manual from statichyperlink within w_sh194_e
integer x = 5
integer y = 252
integer width = 521
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
long textcolor = 255
long backcolor = 12639424
string text = "메뉴얼 보기"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string   ls_url

ls_url = "http://with.ibeaucre.co.kr/instant/manual/dept_shop.asp?v=a26"
//ls_url = "http://new-membership.ibeaucre.co.kr/mem_ins_form.htm?shop_cd="+gs_shop_cd
shl_manual.url = ls_url

end event

type dw_member_sale from datawindow within w_sh194_e
event ue_return_point ( )
boolean visible = false
integer y = 24
integer width = 2391
integer height = 1804
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "고객구매내역"
string dataobject = "d_sh194_d31"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event ue_return_point();long ld_return_point_all, ld_remain_point

	ld_return_point_all = dw_member_sale.getitemdecimal(1,"return_point_all")
	
//messagebox("확인",id_remain_point)
//messagebox("확인",ld_return_point_all)
	ld_remain_point = id_remain_point - ld_return_point_all
	if ld_remain_point < 0 then 
		messagebox("확인","해당제품 반품시 마이너스 마일리지 " + string(ld_remain_point * -1) + "원이 발생하게됩니다. 고객님께 수금해 주세요." )
	end if
	
end event

event buttonclicked;string     ls_sale_no, ls_style, ls_chno, ls_color, ls_size,ls_style_no,ls_sale_type,ls_age_grp,ls_sale_fg,ls_jumin, ls_card_no,ls_coupon_no 
string	  ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_shop_div, ls_plan_yn,ls_shop_type, ls_return_yn
decimal    ld_sale_qty, ld_tag_price,ld_curr_price, ld_dc_rate, ld_sale_price,ld_tag_amt,ld_curr_amt,ld_sale_amt  
decimal    ld_out_rate, ld_out_amt, ld_sale_rate ,ld_sale_collect,ld_goods_amt,ld_io_amt, ld_io_vat  
long       ll_row_count, i, j = 0, ll_ret_cnt
string 	  ls_yymmdd, ls_shop_cd, ls_shop_nm, ls_phone_no, ls_visiter, ls_dotcom, ls_rtrn_info, to_yymmdd
long 	  li_sale_qty, li_sale_qty2
datetime   ld_datetime

IF row < 1 THEN RETURN


SELECT  GetDate()
  INTO :ld_datetime
  FROM DUAL ;
  

IF dw_member_sale.AcceptText() <> 1 THEN RETURN 

choose case dwo.name
	case "cb_return"



		ll_ret_cnt = dw_member_sale.getitemnumber(1,"tot_ret_cnt")		
		if isnull(ll_ret_cnt) or ll_ret_cnt = 0 then 
			messagebox("확인","반품할 스타일을 선택하세요..")
			return 
		end if
		

		dw_body.Reset()
				
		ll_row_count = This.RowCount()		
		
		FOR i = 1 to ll_row_count 		
			
//				ls_shop_cd = dw_back_sale.getitemstring(i,"shop_cd")
//				if isnull(ls_shop_cd) or len(ls_shop_cd) < 6 then 
//					messagebox('not','notmodified')
//					this.SetItemStatus(i, 0, Primary!, Notmodified!)
//				end if
//			
			
				ls_return_yn = This.GetitemString(i, "return_yn")	 
				IF  ls_return_yn = 'Y' THEN
					ls_yymmdd      = This.GetitemString(i, "yymmdd")	
					ls_sale_no     = This.GetitemString(i, "sale_no")	
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
					ls_shop_cd     = This.GetitemString(i, "shop_cd")
					ls_shop_nm     = This.GetitemString(i, "shop_snm")
					ls_phone_no		= This.GetitemString(i, "phone_no")
					ls_visiter		= This.GetitemString(i, "visiter")
					ls_dotcom		= This.GetitemString(i, "dotcom")
					ls_rtrn_info   = ls_yymmdd + ls_shop_cd + RightA(ls_sale_no,2)
					

					//this.Setitem(i, "phone_no", is_yymmdd+gs_shop_cd)						


													
					if isnull(ls_visiter) or ls_visiter= '' then
						messagebox("확인","스타일번호를 먼저 검색해주세요..")
						return								
					end if

					//if wf_style_chk_back(i, ls_style_no) = false then 
					//	messagebox("확인","시즌 마감 되었거나 잘못된 스타일 입니다.")
					//	return 
					//end if				

//					if len(ls_shop_cd) <> 6 or isnull(ls_shop_cd) then  // 매장 미지정
//						this.reset()
//					end if
					

					j= j + 1
					dw_body.insertrow(j)
					
					select  max(plan_yn) 
					into	 :ls_plan_yn
					from    vi_12024_1 (nolock)
					where   style = :ls_style;
					
					if  ls_plan_yn = 'Y' then
					 ls_shop_type = '3'
					else
					 ls_shop_type = '1'
					end if
					
					
					select sum(sale_qty) as sale_qty
					into :li_sale_qty
					from tb_53010_h with (nolock)
					where style = :ls_style
							and chno = :ls_chno
							and color = :ls_color
							and size = :ls_size
							and card_no = :ls_card_no;
							
					select sum(isnull(sale_qty,0)) as sale_qty
					into :li_sale_qty2
					from tb_53017_h with (nolock)
					where style = :ls_style
							and chno = :ls_chno
							and color = :ls_color
							and size = :ls_size
							and card_no = :ls_card_no;
							
					If isnull(li_sale_qty2) then
						li_sale_qty2 = 0
					end if
					
					
					if li_sale_qty + li_sale_qty2 < 1 then
						messagebox("확인","기존에 반품처리건이 있습니다.")
						return
					end if
					
					
					if LeftA(ls_phone_no,1) = "R"  and isnull(ls_phone_no) = false  then
						MessageBox("확인","이미 반품처리된 대상으로 확인됩니다. ")
						return
					end if
					
		
					
					dw_body.Setitem(j, "style",ls_style)
					dw_body.Setitem(j, "yymmdd",is_yymmdd)
					dw_body.Setitem(j, "chno",ls_chno)
					dw_body.Setitem(j, "color",ls_color)
					dw_body.Setitem(j, "size",ls_size)
					dw_body.Setitem(j, "shop_type",ls_shop_type)
					dw_body.Setitem(j, "style_no",ls_style_no)
					dw_body.Setitem(j, "sale_type",ls_sale_type)
					dw_body.Setitem(j, "age_grp",ls_age_grp)
					dw_body.Setitem(j, "sale_fg",ls_sale_fg)
					dw_body.Setitem(j, "jumin",ls_jumin)
					dw_body.Setitem(j, "card_no",ls_card_no)
					dw_body.Setitem(j, "coupon_no",ls_coupon_no) 
					dw_body.Setitem(j, "brand",ls_brand)
					dw_body.Setitem(j, "year",ls_year)
					dw_body.Setitem(j, "season",ls_season)
					dw_body.Setitem(j, "sojae",ls_sojae)
					dw_body.Setitem(j, "item",ls_item)
					dw_body.Setitem(j, "shop_div",ls_shop_div)
					dw_body.Setitem(j, "sale_qty",ld_sale_qty)  	
					dw_body.Setitem(j, "tag_price",ld_tag_price) 	
					dw_body.Setitem(j, "curr_price",ld_curr_price) 	
					dw_body.Setitem(j, "dc_rate",ld_dc_rate) 	 
					dw_body.Setitem(j, "sale_price",ld_sale_price) 	
					dw_body.Setitem(j, "tag_amt",ld_tag_amt) 	 
					dw_body.Setitem(j, "curr_amt",ld_curr_amt)  	
					dw_body.Setitem(j, "sale_amt",ld_sale_amt) 	
					dw_body.Setitem(j, "out_rate",ld_out_rate) 	 		
					dw_body.Setitem(j, "out_amt",ld_out_amt) 	 
					dw_body.Setitem(j, "out_price",ld_out_amt/ld_sale_qty) 
					dw_body.Setitem(j, "sale_rate",ld_sale_rate) 	
					dw_body.Setitem(j, "sale_collect",ld_sale_collect) 	 
					dw_body.Setitem(j, "collect_price",ld_sale_collect/ld_sale_qty) 
					dw_body.Setitem(j, "goods_amt",ld_goods_amt) 	
					dw_body.Setitem(j, "io_amt",ld_io_amt)  
					dw_body.Setitem(j, "io_vat", ld_io_vat)  
					dw_body.Setitem(j, "phone_no", ls_rtrn_info)		
					dw_body.Setitem(j, "visiter", ls_visiter)
					dw_body.Setitem(j, "dotcom", ls_dotcom)
					
					//ls_rtrn_info   = "R" + ls_shop_cd + ls_yymmdd 
		
//					wf_style_set(j, ls_style, ls_yymmdd, ld_sale_qty)
					parent.cb_delete.enabled = false
				end if
		NEXT
		
		
		is_member_return = 'N'
		dw_body.visible = TRUE 
		dw_1.visible    = TRUE 
		//dw_body.enabled = false
		dw_1.enabled = false

		dw_member_sale.visible = FALSE
		//dw_back_sale.visible = FALSE

		cb_update.enabled = true	
	
	case "cb_sale"

		 
		//ls_yymmdd      = This.GetitemString(1, "yymmdd")
		ls_style       = This.GetitemString(1, "style")
		ls_style_no    = This.GetitemString(1, "style_no")
		ls_chno        = This.GetitemString(1, "chno")
		ls_color       = This.GetitemString(1, "color")
		ls_size        = This.GetitemString(1, "size")
		ls_shop_cd		= This.GetitemString(1, "shop_cd")
//		ls_shop_nm		= This.GetitemString(1, "shop_nm")
		ls_phone_no		= This.GetitemString(1, "phone_no")
		ld_dc_rate	   = This.Getitemdecimal(1, "dc_rate")
		ls_dotcom	   = This.GetitemString(1, "dotcom")

	
//		if isnull(ls_shop_cd) or len(ls_shop_cd) <> 6 then 
//			ls_yymmdd = is_yymmdd
//		end if
		
		
		
		
		if LenA(ls_shop_cd) = 6  and (isnull(ls_style_no) or LenA(ls_style_no) < 13) then 
			messagebox('확인','스타일번호를 입력하세요..')
			this.setcolumn("style_no")
			this.setfocus()
			return 0
		end if
		


		
//		messagebox('ls_style', ls_style)
//		messagebox('ls_chno', ls_chno)
//		messagebox('ls_color', ls_color)
//		messagebox('ls_size', ls_size)
//		messagebox('ls_shop_cd', ls_shop_cd)
//		messagebox('gs_jumin', gs_jumin)
//		messagebox('gs_shop_cd', gs_shop_cd)
//		messagebox('ls_dc_rate', ld_dc_rate)
//		messagebox('ls_dotcom', ls_dotcom)		

		select convert(varchar(8),dateadd(month,-1,getdate()),112)
		  into :to_yymmdd
		  from dual;
		
		il_rows = dw_member_sale.retrieve(ls_style, ls_chno, ls_color, ls_size, ls_shop_cd, gs_jumin, to_yymmdd)	 

		messagebox("", ls_style + '/' +  ls_chno + '/' + ls_color + '/' + ls_size +   '/'+ ls_shop_cd +'/' + gs_shop_cd + '/' + string(ld_dc_rate,'00') + '/' + ls_dotcom	)	
		
		if il_rows = 0 then
			messagebox("확인","검색된 판매내역이 없습니다..")
			dw_member_sale.reset()
			dw_member_sale.insertrow(1)
			dw_member_sale.setitem(1,"shop_cd",gs_shop_cd)	
			dw_member_sale.setcolumn("yymmdd")
			dw_member_sale.visible =true
			dw_member_sale.setfocus()
		end if									
		is_member_return = 'N'			
end choose




Parent.Post Event ue_tot_set()




end event

event constructor;DataWindowChild ldw_child 
long ll_row

//매장 미지정 안되게 수정 영업관리팀 요청사항(20131223)
This.GetChild("shop_cd", idw_shop_cd)
idw_shop_cd.SetTransObject(SQLCA)
//ll_row = idw_shop_cd.Retrieve(gs_brand)
ll_row = idw_shop_cd.Retrieve(gs_brand, gs_shop_cd)
ll_row = ll_row + 1



This.GetChild("sale_type", idw_sale_type)
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.Retrieve('011')



This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')


end event

event itemchanged;

/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.02.16                                                  */	
/* 수정일      : 2002.02.16                                                  */
/*===========================================================================*/
integer li_ret
decimal ld_goods_amt
CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		
		   if isnull(data) or data = '' then return 0
			
			//li_ret = Parent.Trigger Event ue_Popup("style_no_back", row, data, 1)
			//if li_ret = 1 then  
			//	return li_ret
			//end if
			
			this.setitem(row,"style",LeftA(data,8))
			this.setitem(row,"chno",MidA(data,9,1))
			this.setitem(row,"color",MidA(data,10,2))
			this.setitem(row,"size",MidA(data,12,2))
			
	case "return_yn"
		if data = 'N' or isnull(data) then 
			this.setitem(row,"phone_no","")
		end if
		post event ue_return_point()
		
	case "shop_cd"
		If MidA(data,2,1) = 'H' then
			this.setitem(row,"dotcom",'1')
		else
			this.setitem(row,"dotcom",'0')
		end if
		
		if LenA(this.GetItemString(row,"style_no")) = 13 then
			this.EVENT ButtonClicked(1, 0, this.object.cb_sale )
		end if
END CHOOSE



end event

event editchanged;/*===========================================================================*/
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
		
CHOOSE case dwo.name
	case "style"
		if LenA(string(data)) = 8 then
			ls_tag = This.Describe(ls_column_name + ".Tag")
			gf_kor_eng(Handle(Parent), ls_tag, 2)
			Send(Handle(This), 256, 9, long(0,0))
		end if
		
	case "chno"
		if LenA(string(data)) = 1 then
			ls_tag = This.Describe(ls_column_name + ".Tag")
			gf_kor_eng(Handle(Parent), ls_tag, 2)
			Send(Handle(This), 256, 9, long(0,0))
		end if
	
	case "color"
		if LenA(string(data)) = 2 then
			ls_tag = This.Describe(ls_column_name + ".Tag")
			gf_kor_eng(Handle(Parent), ls_tag, 2)
			Send(Handle(This), 256, 9, long(0,0))
		end if
	
	case "size"
		if LenA(string(data)) = 2 then
			ls_tag = This.Describe(ls_column_name + ".Tag")
			gf_kor_eng(Handle(Parent), ls_tag, 2)
			Send(Handle(This), 256, 9, long(0,0))
		end if
end choose







end event

type dw_back_sale from datawindow within w_sh194_e
event ue_keydown pbm_dwnkey
boolean visible = false
integer y = 24
integer width = 2391
integer height = 1804
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string title = "일반회원 구매내역"
string dataobject = "d_sh194_d34"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
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
		if ls_column_name = "style_no" then
			this.EVENT ButtonClicked(1, 0, this.object.cb_sale )
		end if
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
END CHOOSE



end event

event buttonclicked;string     ls_sale_no, ls_style, ls_chno, ls_color, ls_size,ls_style_no,ls_sale_type,ls_age_grp,ls_sale_fg,ls_jumin, ls_card_no,ls_coupon_no 
string	  ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_shop_div, ls_plan_yn,ls_shop_type, ls_return_yn
decimal    ld_sale_qty, ld_tag_price,ld_curr_price, ld_dc_rate, ld_sale_price,ld_tag_amt,ld_curr_amt,ld_sale_amt  
decimal    ld_out_rate, ld_out_amt, ld_sale_rate ,ld_sale_collect,ld_goods_amt,ld_io_amt, ld_io_vat  
long       ll_row_count, i, j = 0, ll_ret_cnt, li_sale_qty2, li_sale_qty, li_sale_qty3
string 	  ls_yymmdd, ls_shop_cd, ls_shop_nm, ls_phone_no, ls_visiter, ls_dotcom, ls_rtrn_info, to_yymmdd


IF row < 1 THEN RETURN


IF dw_back_sale.AcceptText() <> 1 THEN RETURN 

choose case dwo.name
	case "cb_return"



		ll_ret_cnt = dw_back_sale.getitemnumber(1,"tot_ret_cnt")		
		if isnull(ll_ret_cnt) or ll_ret_cnt = 0 then 
			messagebox("확인","반품할 스타일을 선택하세요..")
			return 
		end if
		

		dw_body.Reset()
				
		ll_row_count = This.RowCount()		
		
		FOR i = 1 to ll_row_count 		
				idw_status = This.GetItemStatus(i, 0, Primary!)
//				ls_shop_cd = dw_back_sale.getitemstring(i,"shop_cd")
//				if isnull(ls_shop_cd) or len(ls_shop_cd) < 6 then 
//					messagebox('not','notmodified')
//					this.SetItemStatus(i, 0, Primary!, Notmodified!)
//				end if
//			
			
				ls_return_yn = This.GetitemString(i, "return_yn")	 
				IF  ls_return_yn = 'Y' THEN
					ls_yymmdd      = This.GetitemString(i, "yymmdd")	
					ls_sale_no     = This.GetitemString(i, "sale_no")	
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
					ls_shop_cd     = This.GetitemString(i, "shop_cd")
					ls_shop_nm     = This.GetitemString(i, "shop_snm")
					ls_phone_no		= This.GetitemString(i, "phone_no")
					ls_visiter		= This.GetitemString(i, "visiter")
					ls_dotcom		= This.GetitemString(i, "dotcom")
					ls_rtrn_info   = ls_yymmdd + ls_shop_cd + RightA(ls_sale_no,2)
					

					this.Setitem(i, "phone_no", is_yymmdd+gs_shop_cd)						

					if LenA(ls_shop_cd) = 6  and  (LenA(ls_style_no) < 13 or isnull(ls_style_no)) then 
						messagebox('확인','스타일번호를 입력하세요..')
						this.setcolumn("style_no")
						this.setfocus()
						return 
					end if
		
													
					if isnull(ls_visiter) or ls_visiter= '' then
						messagebox("확인","반품구분을 입력해주세요..")
						return								
					end if

//					if wf_style_chk_back(i, ls_style_no) = false then 
//						messagebox("확인","시즌 마감 되었거나 잘못된 스타일 입니다.")
//						return 
//					end if				

//					if len(ls_shop_cd) <> 6 or isnull(ls_shop_cd) then  // 매장 미지정
//						this.reset()
//					end if
					

					j= j + 1
					dw_body.insertrow(j)
					
					select  max(plan_yn) 
					into	 :ls_plan_yn
					from    vi_12024_1 (nolock)
					where   style = :ls_style;
					
					if  ls_plan_yn = 'Y' then
					 ls_shop_type = '3'
					else
					 ls_shop_type = '1'
					end if
					
					
					select sum(sale_qty) as sale_qty
					into :li_sale_qty
					from tb_53010_h with (nolock)
					where style = :ls_style
							and chno = :ls_chno
							and color = :ls_color
							and size = :ls_size
							and shop_cd = :gs_shop_cd;
							
					select sum(isnull(sale_qty,0)) as sale_qty
					into :li_sale_qty2
					from tb_53017_h with (nolock)
					where style = :ls_style
							and chno = :ls_chno
							and color = :ls_color
							and size = :ls_size
							and shop_cd = :gs_shop_cd
							and empty_1 = 'N';
							
					If isnull(li_sale_qty2) then
						li_sale_qty2 = 0
					end if
					
					
					if li_sale_qty + li_sale_qty2 < 1 then
						messagebox("확인","기존에 반품처리건이 있습니다.")
						return
					end if
					
					
					select count(*)
					into :li_sale_qty3
					from tb_53017_h with (nolock)
					where style = :ls_style
							and chno = :ls_chno
							and color = :ls_color
							and size = :ls_size
							and shop_cd = :gs_shop_cd
							and empty_1 = 'N'
							and phone_no = :ls_rtrn_info;
							
					if li_sale_qty3 > 0 then
						messagebox("확인","기존에 반품처리건이 있습니다.")
						return
					end if
							
							
					
					
					dw_body.Setitem(j, "style",ls_style)
					dw_body.Setitem(j, "yymmdd",is_yymmdd)
					dw_body.Setitem(j, "chno",ls_chno)
					dw_body.Setitem(j, "color",ls_color)
					dw_body.Setitem(j, "size",ls_size)
					dw_body.Setitem(j, "shop_type",ls_shop_type)
					dw_body.Setitem(j, "style_no",ls_style_no)
					dw_body.Setitem(j, "sale_type",ls_sale_type)
					dw_body.Setitem(j, "age_grp",ls_age_grp)
					dw_body.Setitem(j, "sale_fg",ls_sale_fg)
					dw_body.Setitem(j, "jumin",ls_jumin)
					dw_body.Setitem(j, "card_no",ls_card_no)
					dw_body.Setitem(j, "coupon_no",ls_coupon_no) 
					dw_body.Setitem(j, "brand",ls_brand)
					dw_body.Setitem(j, "year",ls_year)
					dw_body.Setitem(j, "season",ls_season)
					dw_body.Setitem(j, "sojae",ls_sojae)
					dw_body.Setitem(j, "item",ls_item)
					dw_body.Setitem(j, "shop_div",ls_shop_div)
					dw_body.Setitem(j, "sale_qty",ld_sale_qty)  	
					dw_body.Setitem(j, "tag_price",ld_tag_price) 	
					dw_body.Setitem(j, "curr_price",ld_curr_price) 	
					dw_body.Setitem(j, "dc_rate",ld_dc_rate) 	 
					dw_body.Setitem(j, "sale_price",ld_sale_price) 	
					dw_body.Setitem(j, "tag_amt",ld_tag_amt) 	 
					dw_body.Setitem(j, "curr_amt",ld_curr_amt)  	
					dw_body.Setitem(j, "sale_amt",ld_sale_amt) 	
					dw_body.Setitem(j, "out_rate",ld_out_rate) 	 		
					dw_body.Setitem(j, "out_amt",ld_out_amt) 	 
					dw_body.Setitem(j, "out_price",ld_out_amt/ld_sale_qty) 
					dw_body.Setitem(j, "sale_rate",ld_sale_rate) 	
					dw_body.Setitem(j, "sale_collect",ld_sale_collect) 	 
					dw_body.Setitem(j, "collect_price",ld_sale_collect/ld_sale_qty) 
					dw_body.Setitem(j, "goods_amt",ld_goods_amt) 	
					dw_body.Setitem(j, "io_amt",ld_io_amt)  
					dw_body.Setitem(j, "io_vat", ld_io_vat)  
					dw_body.Setitem(j, "phone_no", ls_rtrn_info)	
					dw_body.Setitem(j, "visiter", ls_visiter)
					dw_body.Setitem(j, "dotcom", ls_dotcom)					

					parent.cb_delete.enabled = false
				else
					If idw_status = DataModified! THEN	
						this.Setitem(i, "visiter", '')
					end if
				end if
		NEXT
		
		
		is_member_return = 'N'
		dw_body.visible = TRUE 
		dw_1.visible    = TRUE 
		//dw_body.enabled = false
		dw_1.enabled = false

		dw_member_sale.visible = FALSE
		dw_back_sale.visible = FALSE

		cb_update.enabled = true	

//		dw_19.retrieve(ls_yymmdd, ls_shop_cd, ls_sale_no, '%')
	
	case "cb_sale"
		dw_1.Reset()
		dw_1.insertrow(1)
		 
		ls_yymmdd      = This.GetitemString(1, "yymmdd")
		ls_style       = This.GetitemString(1, "style")
		ls_style_no    = This.GetitemString(1, "style_no")
		ls_chno        = This.GetitemString(1, "chno")
		ls_color       = This.GetitemString(1, "color")
		ls_size        = This.GetitemString(1, "size")
		ls_shop_cd		= This.GetitemString(1, "shop_cd")
//		ls_shop_nm		= This.GetitemString(1, "shop_nm")
		

	
	
		
		if LenA(ls_shop_cd) = 6  and  (LenA(ls_style_no) < 13 or isnull(ls_style_no)) then 
			messagebox('확인','스타일번호를 입력하세요..')
			this.object.style_no.protect = 0
			this.setcolumn("style_no")
			this.setfocus()
			return 
		end if

		
//		messagebox('ls_style', ls_style)
//		messagebox('ls_chno', ls_chno)
//		messagebox('ls_color', ls_color)
//		messagebox('ls_size', ls_size)
//		messagebox('ls_shop_cd', ls_shop_cd)
//		messagebox('ls_yymmdd', ls_yymmdd)
//		messagebox('gs_shop_cd', gs_shop_cd)
//		messagebox('ls_dc_rate', ld_dc_rate)
//		messagebox('ls_dotcom', ls_dotcom)		
		select convert(varchar(8),dateadd(month,-1,getdate()),112)
		  into :to_yymmdd
		  from dual;
		 
		
		il_rows = dw_back_sale.retrieve(ls_style, ls_chno, ls_color, ls_size, ls_shop_cd, to_yymmdd)	 
		
		//messagebox("", ls_style + '/' +  ls_chno + '/' + ls_color + '/' + ls_size +   '/'+ ls_shop_cd )	
		
		if il_rows = 0 then
			messagebox("확인","검색된 판매내역이 없습니다..")
			this.object.style_no.protect = 0
			dw_back_sale.reset()
			dw_back_sale.insertrow(1)
			dw_back_sale.setitem(1,"shop_cd",gs_shop_cd)	
			dw_back_sale.setcolumn("style_no")
			dw_back_sale.visible =true
			dw_back_sale.setfocus()
		else
			this.object.style_no.protect = 1
		end if									
		is_member_return = 'N'			
end choose




Parent.Post Event ue_tot_set()




end event

event constructor;DataWindowChild ldw_child 
long ll_row

//매장 미지정 안되게 수정 영업관리팀 요청사항(20131223)
This.GetChild("shop_cd", idw_shop_cd)
idw_shop_cd.SetTransObject(SQLCA)
//ll_row = idw_shop_cd.Retrieve(gs_brand)
ll_row = idw_shop_cd.Retrieve(gs_brand, gs_shop_cd)
ll_row = ll_row + 1

end event

event editchanged;/*===========================================================================*/
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
		
CHOOSE case dwo.name
	case "style"
		if LenA(string(data)) = 8 then
			ls_tag = This.Describe(ls_column_name + ".Tag")
			gf_kor_eng(Handle(Parent), ls_tag, 2)
			Send(Handle(This), 256, 9, long(0,0))
		end if
		
	case "chno"
		if LenA(string(data)) = 1 then
			ls_tag = This.Describe(ls_column_name + ".Tag")
			gf_kor_eng(Handle(Parent), ls_tag, 2)
			Send(Handle(This), 256, 9, long(0,0))
		end if
	
	case "color"
		if LenA(string(data)) = 2 then
			ls_tag = This.Describe(ls_column_name + ".Tag")
			gf_kor_eng(Handle(Parent), ls_tag, 2)
			Send(Handle(This), 256, 9, long(0,0))
		end if
	
	case "size"
		if LenA(string(data)) = 2 then
			ls_tag = This.Describe(ls_column_name + ".Tag")
			gf_kor_eng(Handle(Parent), ls_tag, 2)
			Send(Handle(This), 256, 9, long(0,0))
		end if
end choose







end event

event itemchanged;

/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.02.16                                                  */	
/* 수정일      : 2002.02.16                                                  */
/*===========================================================================*/
integer li_ret
decimal ld_goods_amt
CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		
		   if isnull(data) or data = '' then return 0
			
			
			this.setitem(row,"style",LeftA(data,8))
			this.setitem(row,"chno",MidA(data,9,1))
			this.setitem(row,"color",MidA(data,10,2))
			this.setitem(row,"size",MidA(data,12,2))

	case "return_yn"
		if data = 'N' or isnull(data) then 
			this.setitem(row,"phone_no","")
		end if
	case "shop_cd"
		If MidA(data,2,1) = 'H' then
			this.setitem(row,"dotcom",'1')
		else
			this.setitem(row,"dotcom",'0')
		end if
		
		if LenA(this.GetItemString(row,"style_no")) = 13 then
			this.EVENT ButtonClicked(1, 0, this.object.cb_sale )
		end if
END CHOOSE



end event

