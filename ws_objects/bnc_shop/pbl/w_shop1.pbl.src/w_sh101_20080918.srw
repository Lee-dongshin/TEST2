$PBExportHeader$w_sh101_20080918.srw
$PBExportComments$판매일보등록
forward
global type w_sh101_20080918 from w_com010_e
end type
type dw_1 from datawindow within w_sh101_20080918
end type
type cb_1 from commandbutton within w_sh101_20080918
end type
type st_1 from statictext within w_sh101_20080918
end type
type dw_2 from datawindow within w_sh101_20080918
end type
type st_2 from statictext within w_sh101_20080918
end type
type tab_1 from tab within w_sh101_20080918
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tab_1 from tab within w_sh101_20080918
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_3 tabpage_3
end type
type st_3 from statictext within w_sh101_20080918
end type
type dw_3 from datawindow within w_sh101_20080918
end type
type dw_5 from datawindow within w_sh101_20080918
end type
type dw_4 from datawindow within w_sh101_20080918
end type
type st_4 from statictext within w_sh101_20080918
end type
type st_5 from statictext within w_sh101_20080918
end type
type dw_6 from datawindow within w_sh101_20080918
end type
type dw_7 from datawindow within w_sh101_20080918
end type
type dw_8 from datawindow within w_sh101_20080918
end type
type dw_9 from datawindow within w_sh101_20080918
end type
type dw_10 from datawindow within w_sh101_20080918
end type
type dw_11 from datawindow within w_sh101_20080918
end type
type dw_12 from datawindow within w_sh101_20080918
end type
type dw_list from datawindow within w_sh101_20080918
end type
type dw_13 from datawindow within w_sh101_20080918
end type
type cb_2 from commandbutton within w_sh101_20080918
end type
type dw_back_sale from datawindow within w_sh101_20080918
end type
type dw_member_sale from datawindow within w_sh101_20080918
end type
type st_6 from statictext within w_sh101_20080918
end type
type dw_14 from datawindow within w_sh101_20080918
end type
type dw_15 from datawindow within w_sh101_20080918
end type
end forward

global type w_sh101_20080918 from w_com010_e
integer width = 2939
integer height = 2036
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
event ue_tot_set ( )
event ue_total_retrieve ( )
event ue_rt_retrieve ( )
event ue_member_retrieve ( )
dw_1 dw_1
cb_1 cb_1
st_1 st_1
dw_2 dw_2
st_2 st_2
tab_1 tab_1
st_3 st_3
dw_3 dw_3
dw_5 dw_5
dw_4 dw_4
st_4 st_4
st_5 st_5
dw_6 dw_6
dw_7 dw_7
dw_8 dw_8
dw_9 dw_9
dw_10 dw_10
dw_11 dw_11
dw_12 dw_12
dw_list dw_list
dw_13 dw_13
cb_2 cb_2
dw_back_sale dw_back_sale
dw_member_sale dw_member_sale
st_6 st_6
dw_14 dw_14
dw_15 dw_15
end type
global w_sh101_20080918 w_sh101_20080918

type variables
String is_yymmdd, is_sale_no, is_member_return, idw_give_amt, is_use_shop
long id_remain_point
datawindowchild idw_shop_cd, idw_sale_type, idw_shop_type

end variables

forward prototypes
public subroutine wf_goods_amt_clear ()
public subroutine wf_line_chk (long al_row)
public function integer wf_yes_no (string as_title)
public subroutine wf_amt_set2 ()
public subroutine wf_amt_set (long al_row, long al_sale_qty)
public function boolean uf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name)
public function boolean wf_member_set (string as_flag, string as_find)
public function boolean wf_style_set (long al_row, string as_style, string as_yymmdd, long al_qty)
public function integer wf_set_margin (integer al_row, integer al_give_rate)
public function boolean wf_goods_chk (long al_goods_amt, string as_coupon_date)
public function boolean wf_give_rate_chk (integer al_give_rate, string as_coupon_date)
public function boolean wf_style_chk_back (long al_row, string as_style_no)
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

event ue_tot_set();Long ll_sale_qty, ll_sale_amt, ll_real_amt, ll_goods_amt

ll_sale_qty = Long(dw_body.Describe("evaluate('sum(sale_qty)',0)"))
ll_sale_amt = Long(dw_body.Describe("evaluate('sum(sale_amt)',0)"))
ll_real_amt = Long(dw_body.Describe("evaluate('sum(real_amt)',0)"))
ll_goods_amt = Long(dw_body.Describe("evaluate('sum(goods_amt)',0)"))

ll_real_amt = ll_real_amt - ll_goods_amt

dw_1.Setitem(1, "sale_qty", ll_sale_qty)
dw_1.Setitem(1, "sale_amt", ll_sale_amt)
dw_1.Setitem(1, "real_amt", ll_real_amt)
Return

end event

event ue_total_retrieve();Long ll_row 
integer li_cnt
 
ll_row = dw_2.Retrieve(is_yymmdd, gs_shop_cd)
dw_2.ShareData(dw_3)
IF ll_row < 1 THEN
	dw_2.insertRow(0) 
END IF 



end event

event ue_rt_retrieve();Long ll_row , ll_find, ll_recall_qty, ll_accept_qty
decimal ldc_rt_rate
integer li_week_no, li_day_no
string ls_find


ll_row = dw_4.Retrieve(MidA(gs_shop_cd,1,10) , MidA(is_yymmdd,1,6), gs_shop_cd)
IF ll_row < 1 THEN
	dw_4.insertRow(0) 
else
	select datepart(week, :is_yymmdd), datepart(weekday, :is_yymmdd)
	into :li_week_no, :li_day_no
	from dual;
	
	ls_find  = "week_no = " + string(li_week_no) + ""
		ll_find = dw_4.find(ls_find, 1, dw_4.RowCount())
		IF ll_find > 0 THEN
			ll_recall_qty = dw_4.getitemNumber(ll_find, "recall_qty")
			ll_accept_qty = dw_4.getitemNumber(ll_find, "accept_qty")	
			ldc_rt_rate 	= ll_accept_qty / ll_recall_qty 
		end if		

//   li_day_no = 6

if li_week_no <> 39 then
	if li_day_no >= 6 and ldc_rt_rate < 0.9 then
		if gs_brand = 'N' then
		  messagebox("경고!", "RT승인율이 90%미만으로 출고정지대상이 됩니다! RT를 확인하세요!")
			st_3.text = "RT승인율이 90%미만으로 출고정지 대상이 됩니다! RT를 확인하세요!"	
		end if	
	elseif li_day_no >= 6 and ldc_rt_rate < 0.8 then
		if gs_brand = 'W' then
		  messagebox("경고!", "RT승인율이 80%미만으로 출고정지대상이 됩니다! RT를 확인하세요!")
			st_3.text = "RT승인율이 80%미만으로 출고정지 대상이 됩니다! RT를 확인하세요!"	
		end if	
	elseif li_day_no >= 6 and ldc_rt_rate < 0.5 then
		if gs_brand = 'O' then
		  messagebox("경고!", "RT승인율이 50%미만으로 출고정지대상이 됩니다! RT를 확인하세요!")
			st_3.text = "RT승인율이 50%미만으로 출고정지 대상이 됩니다! RT를 확인하세요!"
		END IF	
	else
		st_3.text = "매출계(년월계:기획제외) - 항목, 숫자 더블클릭하세요!"
	end if	
end if
	
END IF 
end event

event ue_member_retrieve();Long ll_row , ll_find, ll_recall_qty, ll_accept_qty
decimal ldc_rt_rate
integer li_week_no, li_day_no
string ls_find


ll_row = dw_8.Retrieve( MidA(is_yymmdd,1,6), gs_brand, gs_shop_cd)
//ll_row = dw_8.Retrieve( '200602', 'n', 'ng0006', 0 , 'A')
dw_12.Retrieve( MidA(is_yymmdd,1,6), gs_shop_cd)
IF ll_row < 1 THEN	
	dw_8.insertRow(0) 
END IF 

end event

public subroutine wf_goods_amt_clear ();long i , ll_row_count

ll_row_count = dw_body.rowcount()

FOR i=1 TO ll_row_count
	dw_body.Setitem(i, "goods_amt", 0)
	dw_body.Setitem(i, "give_rate", 0)
	dw_body.Setitem(i, "coupon_no", '')
	
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

return


end subroutine

public function integer wf_yes_no (string as_title);/*=================================================================*/
/* 작 성 자 : 지우정보                                             */	
/* 내    용 : 수정 자료 저장여부 확인                              */
/*=================================================================*/

RETURN  MessageBox(as_title,'쿠폰을 사용하시겠습니까?', &
			          Question!, YesNo!)


end function

public subroutine wf_amt_set2 ();/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_sale_price, ll_out_price, ll_collect_price, ll_row_count,ll_foundrow
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect  , ll_dc_amt, ll_sale_price2, ll_sale_qty,ll_sale_price3, ll_min_sale_price ,ll_sale_collect1
long ll_find, ll_qty, ll_cnt
long sale_price[]
int i, j, k
String ls_coupon_no, ls_sale_type, ls_item, ls_style_no, ls_coupon_yn, ls_style, ls_yymmdd
Decimal ldc_marjin,ld_dc_rate

ls_coupon_no = dw_11.getitemstring(1,"coupon_no")
ll_dc_amt    = dw_11.getitemNumber(1,"dc_amt")

select count(*), convert(char(08), getdate(),102)
into :ll_cnt, :ls_yymmdd
from tb_53010_h (nolock)
where yymmdd between '20060524' and '20060606'
and sale_type = '11'
and brand = 'w'
and len(coupon_no) = 5
and coupon_no = :ls_coupon_no;


if ls_yymmdd > '20060606' then 
	return
end if

IF isnull(ll_goods_amt) THEN ll_goods_amt = 0 	 

ll_row_count = dw_body.RowCount()

if  ll_dc_amt > 0  and isnull(ls_coupon_no) <> true and LenA(ls_coupon_no) = 5 and ll_cnt = 0 and ls_coupon_no > "00000" then	  	    		
	   FOR i=1 TO ll_row_count
			ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))				
			ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
			ls_style_no   = dw_body.Getitemstring(i, "style_no")
			ls_item       = RightA(LeftA(ls_style_no,2),1)
			ls_sale_type  = dw_body.Getitemstring(i, "sale_type")
			ld_dc_rate    = dw_body.GetitemDecimal(i, "dc_rate") 
			
		    // 가장 최저가 상품에 구매할인권을 쓰게 처리 						 
				IF  ll_sale_price > ll_dc_amt  and ll_sale_qty  > 0 and ld_dc_rate < 10  and ls_sale_type < '12'  THEN  	
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
							 wf_style_set(j, ls_style, is_yymmdd, ll_qty)							  
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
											
											dw_body.Setitem(i, "sale_price", ll_sale_price3)					
											dw_body.Setitem(i, "tag_amt",  ll_tag_price  * ll_sale_qty)
											dw_body.Setitem(i, "curr_amt", ll_curr_price * ll_sale_qty)
											dw_body.Setitem(i, "sale_amt", ll_sale_price3 * ll_sale_qty)
											dw_body.Setitem(i, "out_amt",  ll_out_price  * ll_sale_qty) 
											
											ldc_marjin = dw_body.GetitemDecimal(i, "sale_rate")
//											gf_marjin_price(gs_shop_cd, (ll_sale_price3 * ll_sale_qty) , ldc_marjin, ll_sale_collect)  
//											gf_marjin_price(gs_shop_cd, (ll_sale_price3 * ll_sale_qty) - ll_goods_amt, ldc_marjin, ll_sale_collect)  											
											
											gf_marjin_price(gs_shop_cd, (ll_sale_price3 * ll_sale_qty) - ll_goods_amt, ldc_marjin, ll_sale_collect1)
											if gs_shop_div = "G" then 
												ll_sale_collect = ll_sale_collect1 - (ll_goods_amt * ldc_marjin / 100)
											else
												ll_sale_collect = ll_sale_collect1
											end if												
											
											dw_body.Setitem(i, "sale_collect", ll_sale_collect) 
											
											/* 세일 재매입 처리 */
											if gs_shop_div = "G" then
												gf_marjin_price(gs_shop_cd, (ll_sale_price3 * ll_sale_qty) , ldc_marjin, ll_sale_collect)  											
											else	
												gf_marjin_price(gs_shop_cd, (ll_sale_price3 * ll_sale_qty) - ll_goods_amt, ldc_marjin, ll_sale_collect)  																							
											end if
											
											ll_io_amt = (ll_out_price  * ll_sale_qty) - ll_sale_collect
											dw_body.Setitem(i, "io_amt", ll_io_amt)
											dw_body.Setitem(i, "io_vat", ll_io_amt - Round(ll_io_amt / 1.1, 0))	
											dw_body.Setitem(i,"coupon_no", ls_coupon_no)
											dw_11.setitem(1,"coupon_no","")		

									END CHOOSE	
									
								end if					
							END IF
					 NEXT

				IF ls_coupon_yn = 'y' then
					messagebox('쿠폰사용 끝', ls_coupon_no)		
					dw_11.visible = false
					return
				END IF								

 else
	messagebox('경고', "쿠폰번호를 확인하세요!")
   return
 end if
	
	

		
		
end subroutine

public subroutine wf_amt_set (long al_row, long al_sale_qty);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_sale_price, ll_out_price, ll_collect_price
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect1  , ll_sale_collect
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
//
// messagebox("al_sale_qty",al_sale_qty)
//messagebox("ll_collect_price",ll_collect_price)

		IF ll_goods_amt <> 0 THEN 
		 
			ldc_marjin = dw_body.GetitemDecimal(al_row, "sale_rate")
 		   gf_marjin_price(gs_shop_cd, (ll_sale_price * al_sale_qty) - ll_goods_amt, ldc_marjin, ll_sale_collect1)
			if gs_shop_div = "G" then 
				ll_sale_collect = ll_sale_collect1 - (ll_goods_amt * ldc_marjin / 100)
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

public function boolean wf_member_set (string as_flag, string as_find);String  ls_user_name, ls_jumin, ls_card_no, ls_age_grp, ls_tel_no3, ls_secure_no
string  ls_yymmdd, ls_crm_grp
Long    ll_total_point, ll_give_point, ll_accept_point, ll_year, ll_coupon_cnt 
int	  ll_ans
Decimal ld_give_point, ld_give_rate
DataStore	lds_source	
Boolean lb_return 
DataWindowChild ldw_child

select convert(char(08), getdate(),112)
into :ls_yymmdd
from dual;


dw_1.setitem(1, "give_rate",0)	

IF as_flag = '3' THEN
		if LenA(as_find) < 10 then 
			messagebox("확인","전화번호를 올바로 입력하세요..")			
			return true				
		elseif uf_chk_phone(as_find, ls_jumin,ls_user_name) THEN
			dw_1.SetItem(1, "jumin",     ls_jumin)
		else 			
			ls_secure_no = dw_1.getitemstring(1,"secure_no")
			
			gst_cd.ai_div          = 1
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""
			IF Trim(as_find) <> "" THEN
				gst_cd.Item_where   = " tel_no3 = '" + as_find + "' and right(jumin,3) = '" + ls_secure_no + "' "
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


if (ll_total_point - ll_accept_point) >= 50000 then 
	dw_1.object.text_message.text = "사용할 Point금액이 있습니다 !"
	
else 
	dw_1.object.text_message.text = ""
end if


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
and   isnull(use_shop,'%') = case when use_shop is null then '%' else :Gs_shop_cd end;


if ld_give_point >  0 then 
	if ld_give_rate > 0 then 
		dw_1.object.text_message2.text = string(ld_give_rate)+"% 할인율쿠폰, 구매할인권" + string(ld_give_point) + "원"
	else
		dw_1.object.text_message2.text = "구매할인권 " + string(ld_give_point) + "원"
	end if
	dw_1.setitem(1, "give_date","")	
	dw_1.object.cb_give.visible = true
else 
	if ld_give_rate > 0 then 
		dw_1.object.text_message2.text = string(ld_give_rate)+"% 할인율쿠폰"
		dw_1.object.cb_give.visible = true
	else
		dw_1.object.text_message2.text = ""
		dw_1.object.cb_give.visible = false
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

public function boolean wf_style_set (long al_row, string as_style, string as_yymmdd, long al_qty);Long    ll_dc_rate     
Long    ll_curr_price,  ll_out_price
Long    ll_sale_price,  ll_collect_price 
String  ls_shop_type,   ls_sale_type = space(2)
decimal ldc_out_marjin, ldc_sale_marjin

/* 정상, 기획 */
ls_shop_type = dw_body.GetitemString(al_row, "shop_type")

/* 출고시 마진율 체크 */
IF gf_out_marjin (as_yymmdd,    gs_shop_cd,     ls_shop_type, as_style, & 
                  ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
	RETURN False 
END IF
/* 판매 마진율 체크 */
IF gf_sale_marjin (as_yymmdd,    gs_shop_cd,      ls_shop_type, as_style, & 
                   ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 
	RETURN False 
END IF

/* 판매 자료 등록 */
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
end function

public function integer wf_set_margin (integer al_row, integer al_give_rate);String ls_style_no, ls_yes, ls_sale_type, ls_plan_yn
Long   ll_curr_price, ll_sale_price, ll_collect_price, ld_goods_amt, ll_dc_rate, ll_sale_rate


	ls_style_no   = dw_body.GetitemString(al_row, "style_no")
	ls_plan_yn = MidA(ls_style_no,5,1)
	
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
			ll_dc_rate = long(ll_dc_rate)+long(al_give_rate)
			
			
			select top 1 sale_type, marjin_rate 
				into :ls_sale_type, :ll_sale_rate
			from tb_56010_m a(nolock) 
			where shop_cd = :gs_shop_cd
			and   end_ymd > :is_yymmdd
			and   shop_type = case when :ls_plan_yn = 'Z' then '3' else '1' end
			and   dc_rate = :ll_dc_rate
			order by sale_type;
			
			
			ll_sale_price    = ll_curr_price * (100 - ll_dc_rate) / 100 
			gf_marjin_price(gs_shop_cd, ll_sale_price, ll_sale_rate, ll_collect_price) 
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

public function boolean wf_goods_chk (long al_goods_amt, string as_coupon_date);Long 	  j, i, k, ll_accept_point, ll_remain_point, ll_total_point , ll_row_count,ll_goods_amt,ll_sale_price, ll_sale_price2,ll_sale_qty   ,ll_give_amt
decimal ld_goods_amt, ld_mok, ld_qty, ld_coupon_amt, ld_check_amt,ld_tot_goods_amt , ld_dc_rate
string  ls_jumin, ls_card_no, ls_sale_fg, ls_style_no, ls_item, ls_coupon_no, ls_coupon_yn, ls_sale_type, ls_yymmdd, ls_coupon_no1
integer il_remain_amt, li_sale_qty, ll_YN
string ls_brand, ls_give_date, ls_msg_yn = 'N'
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

ll_row_count = dw_body.RowCount()


IF isnull(al_goods_amt) OR al_goods_amt = 0 THEN 
	 wf_goods_amt_clear()
	RETURN TRUE 
END IF

 // 잔여 포인트를 만원 단위로 사용하도록 변환 
 il_remain_amt =  (ll_remain_point  / 10000) 
 ll_remain_point = il_remain_amt  *  10000
 ll_give_amt   =  ld_goods_amt / 10
// messagebox('잔액', ll_remain_point)

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
	
						
		    // 가장 최저가 상품에 구매할인권을 쓰게 처리 						 
// 				IF (ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ld_dc_rate < 31  and ls_sale_type < '30' and ((isnull(as_coupon_date) or (as_coupon_date <> '20080523' and as_coupon_date = '20080606')) or (ls_coupon_no = 'SECOND' or ls_coupon_no = 'FIRST1') ) ) or &  
//					(ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ls_sale_type < '40' and (as_coupon_date = '20080523' or as_coupon_date = '20080606') and ls_coupon_no <> 'SECOND' and ls_coupon_no <> 'FIRST1' ) THEN  	//기획/균일 포함

				IF (ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ld_dc_rate < 31  and ls_sale_type < '30' and (isnull(as_coupon_date) or (ls_coupon_no = 'SECOND' or ls_coupon_no = 'FIRST1') ) ) or &  
				    (ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ls_sale_type < '30' and ls_coupon_no <> 'SECOND' and ls_coupon_no <> 'FIRST1' ) THEN  	
			
					 k = k + 1
					if k= 1 then
						ll_sale_price2 = ll_sale_price 
					end if
								
					if ll_sale_price <= ll_sale_price2 then				
						for j = 1 to i
							 dw_body.Setitem(j,"coupon_no", '')
							 dw_body.Setitem(j,"goods_amt", 0)																									
						next	
						
					  	CHOOSE CASE ll_YN   // 쿠폰 사용할지 확인 
							CASE 1    
								ll_sale_price2 = ll_sale_price 
								ls_coupon_yn = 'y'						
								dw_body.Setitem(i,"coupon_no", ls_coupon_no)
								dw_body.Setitem(i,"goods_amt", ld_coupon_amt)
								
								// 쿠폰 쓰고 남은 금액 다시 계산 //
								ll_goods_amt = ll_goods_amt - ld_coupon_amt	
								ll_goods_amt = ll_goods_amt / 10000
								ll_goods_amt = ll_goods_amt * 10000						 
						END CHOOSE	
						
					end if					
				elseif ls_style_no <> '' and ls_msg_yn <> 'Y'  then 
					if	(as_coupon_date = '20080523' or as_coupon_date = '20080606') and ls_coupon_no <> 'SECOND' and ls_coupon_no <> 'FIRST1' then
					 					
								MessageBox("확인", " 정상/세일/기획/균일  제품에만 사용할수 있습니다.")  
								ls_coupon_yn = 'n'	
								ls_msg_yn = 'Y'
					else
						 if ld_dc_rate >= 31 then						
								MessageBox("확인", " 정상/세일(30%이내)  제품에만 사용할수 있습니다.")  
								ls_coupon_yn = 'n'	
								ls_msg_yn = 'Y'
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
 elseif  ll_goods_amt < ld_coupon_amt and  ll_goods_amt < 10000  THEN 
	   MessageBox("확인", "마일리지는 10000원 이상부터 사용할수 있습니다.")  
   return false
 end if

// 더 쓸 금액이 없으면 종료 //
//IF ll_goods_amt  > ll_remain_point  OR  ll_goods_amt < 30000  THEN 
IF ll_goods_amt  > ll_remain_point  OR  ll_goods_amt < 10000  THEN 
 	ld_tot_goods_amt =  dw_body.Getitemdecimal(1,"tot_goods_amt")
	dw_1.setitem (1, "goods_amt", ld_tot_goods_amt )	
	ld_tot_goods_amt =  dw_1.Getitemdecimal(1,"goods_amt")
	if ld_tot_goods_amt > 0 then 
	   MessageBox("확인", "총" + string(ld_tot_goods_amt) + " 만큼만 사용합니다1.")  
	end if
   return true
END IF

	
	ld_mok = MOD(ll_goods_amt , 10000) 
	
	if ld_mok <> 0 then
		MessageBox("Point 오류", "1PCS에 10000원 단위로 입력하세요. ")
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
		
		IF ls_coupon_no = '' then					 
				IF ll_goods_amt > 0 and ll_sale_price > ll_goods_amt and  & 
					ll_sale_qty  > 0 and ld_dc_rate  < 31  and ls_sale_type < '30' THEN  
					ls_sale_fg = '2' 
//					if ll_goods_amt >=  30000 then 
					if ll_goods_amt >=  10000 then 
						dw_body.Setitem(i,"goods_amt", ll_goods_amt)	
			 		   messagebox('확인', '마일리지 ' + string(ll_goods_amt) + '원 사용')
						ll_goods_amt = 0
					 
					else 	
						dw_body.Setitem(i,"goods_amt", 0)
						ls_sale_fg = '1' 
					end if
				ELSE
					dw_body.Setitem(i,"goods_amt", 0)
					ls_sale_fg = '0' 
				END IF				 
				dw_body.setitem(i,"sale_fg",ls_sale_fg)
		END IF
	NEXT	
	
	ld_tot_goods_amt =  dw_body.Getitemdecimal(1,"tot_goods_amt")
	 
   dw_1.setitem(1, "goods_amt", ld_tot_goods_amt ) 
  
	
	IF ld_tot_goods_amt  = ld_goods_amt THEN  
		RETURN TRUE 
	ELSE
	   ld_tot_goods_amt =  dw_1.Getitemdecimal(1,"goods_amt")
		MessageBox("확인", "총" + string(ld_tot_goods_amt) + " 만큼만 사용합니다2.")
		RETURN true
	END IF
	
//	IF ll_goods_amt > 30000   then
	IF ll_goods_amt > 10000   then
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

public function boolean wf_give_rate_chk (integer al_give_rate, string as_coupon_date);long i,j, ll_t_row, ll_give_rate, ll_dc_rate, ll_t_rate
string ls_coupon_no, ls_t_coupon, ls_brand, ls_style_no, ls_year, ls_season, ls_item, ls_sale_type, ls_style, ls_season_sort
long ll_yesno, ll_sale_price, ll_t_price , ll_curr_price
long ll_qty, ll_sale_qty, ll_t_qty,ll_collect_price
decimal ldc_sale_rate

ll_yesno = MessageBox("확인",'정상할인율 쿠폰을 사용하시겠습니까?', Question!, YesNo!)
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

//				if isnull(ll_dc_rate) or ll_dc_rate <= 70 then	
				if  ll_dc_rate <= 20 and ((ls_brand = 'N' and LeftA(ls_sale_type,1) = '1') or (ls_brand <> 'N' and LeftA(ls_sale_type,1) <= '2')) then	// 정상판매 
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
	
		if ls_brand = 'N' and ll_dc_rate > 0 then   //온앤온은 정상 최대 20%까지만 적용 
			ll_t_rate = al_give_rate - ll_dc_rate
		else 
			ll_t_rate = al_give_rate
		end if

		
////////////////////
		
		
		ls_style  = dw_body.getitemString(ll_t_row,"style")
		
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

public function boolean wf_style_chk_back (long al_row, string as_style_no);/*===========================================================================*/
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
		and plan_yn <> 'Y'
		and sojae  <> 'C'   ;
		
elseif gs_brand = "N" then
	
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
		and ( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20082' )		           		
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

elseif gs_brand = "O" then

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
	 and ( (  ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20082' )
            or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20082'  and plan_yn = 'Y' )   )
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
											  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y')  )		
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
	   and ( (  ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20074'  OR STYLE IN  ('WW7WE605','WW7WE608','WW7WE609') )
            or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20072'  and plan_yn = 'Y' )   )
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
											  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y')  )		
				);							 

end if

IF SQLCA.SQLCODE <> 0 THEN 
	messagebox("확인","시즌마감되어 반품등록이 불가능합니다! 관리팀에 연락 바랍니다!")
	Return False 
END IF


Select isnull(ord_qty,0), isnull(ord_qty_chn,0)
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


//Select shop_type
//into :ls_shop_type
//From tb_56012_d with (nolock)
//Where style      = :ls_style 
//  and start_ymd <= :is_yymmdd
//  and end_ymd   >= :is_yymmdd
//  and shop_type <> '9'
//  and shop_cd    = :gs_shop_cd ;
//
//if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
//	ls_shop_type = "1"
//end if	
//
//if ls_shop_type > "3"  then 
//	messagebox("경고!", "정상 판매등록이 불가능한 제품입니다!")
//	return false
//end if	
//
//SELECT  ISNULL(RTRN_YMD, 'XXXXXXXX')
//INTO :LS_RTRN_YMD
//FROM tb_54020_h
//WHERE STYLE = :LS_STYLE
//AND   DEP_FG = 'Y';
//
//if IsNull(LS_RTRN_YMD) or Trim(LS_RTRN_YMD) = "" then
//	LS_RTRN_YMD = "XXXXXXXX"
//end if
//
//
//if ls_shop_type < "3"  then 
//	IF LS_RTRN_YMD <= IS_YYMMDD THEN 
//		messagebox("경고!", "부진적용일이후 정상 판매,반품등록은 불가능합니다! 관리팀에 연락 바랍니다!")
//		return false
//	END IF	
//end if	
//
//
//select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
//into  :ls_given_fg, :ls_given_ymd
//from tb_12020_m with (nolock)
//where style = :ls_style;
//
//
//if ls_given_fg = "Y" then 
//	messagebox("품번체크", ls_given_ymd + "일자로 사은품 전환된 제품입니다!")
//	return false
//end if 	
//


//dw_body.SetItem(al_row, "tag_price", ll_tag_price) 
//IF ls_plan_yn = 'Y' THEN 
//	dw_body.Setitem(al_row, "shop_type", '3')
//ELSE
//	dw_body.Setitem(al_row, "shop_type", '1')
//END IF
//IF wf_style_set(al_row, ls_style, is_yymmdd, 1) THEN 
//   dw_body.SetItem(al_row, "style_no", as_style_no)
//   dw_body.SetItem(al_row, "style",    ls_style)
//	dw_body.SetItem(al_row, "chno",     ls_chno)
//	dw_body.SetItem(al_row, "color",    ls_color)
//	dw_body.SetItem(al_row, "size",     ls_size)
//	dw_body.SetItem(al_row, "brand",    ls_brand)
//	dw_body.SetItem(al_row, "year",     ls_year)
//	dw_body.SetItem(al_row, "season",   ls_season)
//	dw_body.SetItem(al_row, "sojae",    ls_sojae)
//	dw_body.SetItem(al_row, "item",     ls_item)
//ELSE
//	Return False
//END IF

Return True

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
		and sojae  <> 'C'   ;
		
elseif gs_brand = "N" then
	
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
		and ( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20082' )		           		
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

elseif gs_brand = "O" then

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
	 and ( (  ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20082' )
            or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20082'  and plan_yn = 'Y' )   )
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
											  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y')  )		
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
		and ( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20082' )		           
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

IF SQLCA.SQLCODE <> 0 THEN 
	messagebox("확인","시즌마감되어 등록이 불가능합니다! 관리팀에 연락 바랍니다!")
	Return False 
END IF


Select isnull(ord_qty,0), isnull(ord_qty_chn,0)
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
  and shop_type <> '9'
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
	messagebox("품번체크", ls_given_ymd + "일자로 판매불가로 전환된 제품입니다!")
	return false
end if 	



dw_body.SetItem(al_row, "tag_price", ll_tag_price) 
IF ls_plan_yn = 'Y' THEN 
	dw_body.Setitem(al_row, "shop_type", '3')
ELSE
	dw_body.Setitem(al_row, "shop_type", '1')
END IF
IF wf_style_set(al_row, ls_style, is_yymmdd, 1) THEN 
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

on w_sh101_20080918.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.st_1=create st_1
this.dw_2=create dw_2
this.st_2=create st_2
this.tab_1=create tab_1
this.st_3=create st_3
this.dw_3=create dw_3
this.dw_5=create dw_5
this.dw_4=create dw_4
this.st_4=create st_4
this.st_5=create st_5
this.dw_6=create dw_6
this.dw_7=create dw_7
this.dw_8=create dw_8
this.dw_9=create dw_9
this.dw_10=create dw_10
this.dw_11=create dw_11
this.dw_12=create dw_12
this.dw_list=create dw_list
this.dw_13=create dw_13
this.cb_2=create cb_2
this.dw_back_sale=create dw_back_sale
this.dw_member_sale=create dw_member_sale
this.st_6=create st_6
this.dw_14=create dw_14
this.dw_15=create dw_15
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.tab_1
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.dw_3
this.Control[iCurrent+9]=this.dw_5
this.Control[iCurrent+10]=this.dw_4
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.dw_6
this.Control[iCurrent+14]=this.dw_7
this.Control[iCurrent+15]=this.dw_8
this.Control[iCurrent+16]=this.dw_9
this.Control[iCurrent+17]=this.dw_10
this.Control[iCurrent+18]=this.dw_11
this.Control[iCurrent+19]=this.dw_12
this.Control[iCurrent+20]=this.dw_list
this.Control[iCurrent+21]=this.dw_13
this.Control[iCurrent+22]=this.cb_2
this.Control[iCurrent+23]=this.dw_back_sale
this.Control[iCurrent+24]=this.dw_member_sale
this.Control[iCurrent+25]=this.st_6
this.Control[iCurrent+26]=this.dw_14
this.Control[iCurrent+27]=this.dw_15
end on

on w_sh101_20080918.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.tab_1)
destroy(this.st_3)
destroy(this.dw_3)
destroy(this.dw_5)
destroy(this.dw_4)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.dw_6)
destroy(this.dw_7)
destroy(this.dw_8)
destroy(this.dw_9)
destroy(this.dw_10)
destroy(this.dw_11)
destroy(this.dw_12)
destroy(this.dw_list)
destroy(this.dw_13)
destroy(this.cb_2)
destroy(this.dw_back_sale)
destroy(this.dw_member_sale)
destroy(this.st_6)
destroy(this.dw_14)
destroy(this.dw_15)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(cb_1, "FixedToRight")
inv_resize.of_Register(cb_2, "FixedToRight")
inv_resize.of_Register(st_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_1, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_2, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_3, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_4, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_5, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_6, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_7, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_8, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_9, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_10, "FixedToBottom")
inv_resize.of_Register(dw_12, "FixedToBottom")
inv_resize.of_Register(TAB_1, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(st_3, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(st_4, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(st_5, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_member_sale, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_back_sale, "ScaleToRight&Bottom")

dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
dw_5.SetTransObject(SQLCA)
dw_6.SetTransObject(SQLCA)
dw_7.SetTransObject(SQLCA)
dw_8.SetTransObject(SQLCA)
dw_9.SetTransObject(SQLCA)
dw_10.SetTransObject(SQLCA)
dw_12.SetTransObject(SQLCA)
dw_13.SetTransObject(SQLCA)
dw_14.SetTransObject(SQLCA)
dw_15.SetTransObject(SQLCA)

dw_list.SetTransObject(SQLCA)
dw_member_sale.SetTransObject(SQLCA)
dw_back_sale.SetTransObject(SQLCA)
dw_1.insertRow(0)



end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size, ls_shop_type, ls_given_fg, ls_given_ymd, LS_RTRN_YMD
Long       ll_row_cnt , ll_ord_qty, ll_ord_qty_chn, li_shop_cnt
Boolean    lb_check 
string ls_shop_snm, ls_ok
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
			
	
		if MidA(gs_shop_cd,3,4) >= "1900" and MidA(gs_shop_cd,3,4) <= "1913" then 
				gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and  year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  >  '20054'  " 				 			
			else
				if gs_brand = "N" then
						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and ( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20081' ) " + &		           		
							 	   " or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
								   " and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
								   " and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
									" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' " 					
						
				elseif gs_brand = "O" then
				//		gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and ( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20081' ) " + &		           							
						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and ( ( (year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20082' or  year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20082'  and plan_yn = 'Y' )  ) " + &		           		
							 	   " or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
								   " and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
								   " and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
									" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' " 					

		  		else 
						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and ( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20082' ) " + &		           		
							 	   " or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
								   " and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
								   " and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
									" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' " 					
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
				  and shop_type <> '9'
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
					messagebox("품번검색", ls_given_ymd + "일자로 판매불가로 전환된 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				END IF 		

				ls_style = lds_Source.GetItemString(1,"style")
				ls_chno  = lds_Source.GetItemString(1,"chno")
				ls_color = lds_Source.GetItemString(1,"color")
				ls_size = lds_Source.GetItemString(1,"size")	
		
				Select isnull(ord_qty,0), isnull(ord_qty_chn,0)
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
		
 				IF wf_style_set(al_row, ls_style, is_yymmdd, 1) THEN 
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
					dw_body.SetItem(al_row, "goods_amt", 0)
					dw_body.SetItem(al_row, "give_rate", 0)
					dw_body.SetItem(al_row, "coupon_no", "")
					dw_body.SetItem(al_row, "phone_no", "")
					dw_body.SetItem(al_row, "visiter", "")
					  
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

////////////////			
//			SELECT  'ok'
//			INTO :ls_ok
//			FROM tb_12020_m
//			WHERE STYLE = :LS_STYLE		
//			and   brand = 'W'
//			and   (year < '2007' or 
//					 (year = '2007' and season in ('S','M'))
//					);
//		
//			if ls_ok = 'ok' and ls_shop_type < "4"  and IS_YYMMDD >= '20070909' then 
//					messagebox("경고!", "W. 7M이전제품은 9/9일부로 정상.기획판매,반품등록은 불가능합니다! 관리팀에 연락 바랍니다!")
//					ib_itemchanged = FALSE	
//					return 0
//			end if
//			
///////////////	

			Destroy  lds_Source

	CASE "style_no_back"		
			IF ai_div = 1 THEN 	
				IF wf_style_chk_back(al_row, as_data)  THEN
					
					RETURN 0 
				END IF 
			END IF
		
	CASE "style"		

			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com011" 
			gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + AS_DATA + "%'"  
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
				   dw_6.SetRow(al_row)
				   dw_6.SetColumn(as_column)
				END IF
				
				select count(shop_cd)
				into :li_shop_cnt
				from TB_51035_H (nolock)
				where shop_cd = :gs_shop_cd
				  and :is_yymmdd between frm_ymd and to_ymd ;
				  
				if li_shop_cnt <> 0 then
					LS_STYLE = lds_Source.GetItemString(1,"style")
					dw_6.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					DW_7.RETRIEVE(GS_SHOP_CD, LS_STYLE)
				else
					messagebox("경고!", "행사진행 기간에만 조회가능합니다!")
				end if	
				
			   /* 다음컬럼으로 이동 */
		      lb_check = TRUE 
				ib_itemchanged = FALSE
			END IF
			Destroy  lds_Source

	CASE "shop_snm"	
		
//			IF ai_div = 1 THEN 	
//				IF gf_shop_nm(as_data, 'S', ls_shop_snm) = 0 THEN
//				   dw_back_sale.SetItem(1, "shop_snm", ls_shop_snm)
//					RETURN 0
//				END IF 
//			END IF
//			if  isnull(as_data) or len(as_data) = 0 then return  0
//			
//		   gst_cd.ai_div          = ai_div
//			gst_cd.window_title    = "매장 코드 검색" 
//			gst_cd.datawindow_nm   = "d_com912" 
//			gst_cd.default_where   = "WHERE Shop_Stat = '00' and shop_div in ('G','K') and brand = '" + gs_brand + "' "
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "SHOP_sNM LIKE '%" + as_data + "%'"
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
//				   dw_back_sale.SetRow(1)
//				   dw_back_sale.SetColumn(as_column)
//				END IF
//				ls_shop_snm = "현대미아아아" //lds_Source.GetItemString(1,"shop_snm")
//				messagebox("ls_shop_nm",ls_shop_snm)
				
//				dw_back_sale.SetItem(1, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
//				dw_back_sale.SetItem(1, "shop_snm", "현대대대")
				/* 다음컬럼으로 이동 */
//				dw_back_sale.SetColumn("style")
//				ib_itemchanged = false

//			END IF
//			Destroy  lds_Source	

			
			
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

event pfc_postopen();call super::pfc_postopen;
integer li_cnt, li_cnt2

select count(style) into :li_cnt 
from tb_53060_h a(nolock), VI_93010_3 b (nolock)
where datepart(week, a.yymmdd) = datepart(week, getdate()) 
and   a.empno = b.empno
and   b.dept_code = :gs_shop_cd;
//and out_yn = 'Y';

if li_cnt > 0 then
	dw_13.retrieve(gs_shop_cd)
	dw_13.visible = true
	cb_2.visible = true
end if 

SELECT count(*) into :li_cnt2  //KM_VMD
FROM (
		SELECT count(*) as cnt
		FROM km.dbo.VMD_Weekly
		WHERE convert(char(8),d_date,112) >=  convert(char(8),getdate()-30,112)
			and d_brand = :gs_brand
		
		UNION ALL
		
		SELECT	 count(*) as cnt
		FROM km.dbo.VMD_shop
		WHERE convert(char(8),rcdymd,112) >=  convert(char(8),getdate()-7,112)
			and brand = :gs_brand
		) x
where x.cnt > 0;


if li_cnt2 > 0 then
	dw_14.retrieve(gs_shop_cd)
	dw_14.visible = true
end if 



cb_1.TriggerEvent(Clicked!)



This.Post Event ue_total_retrieve() 
This.Post Event ue_rt_retrieve() 
//This.Post Event ue_member_retrieve() 

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
long     i, ll_row_count, ll_chk, ll_give_rate
decimal	ldc_dc_rate, ld_goods_amt
datetime ld_datetime 
int     li_point_seq	
String   ls_shop_type, ls_sale_type, ls_dot_com, ls_shoP_cd, ls_shop_div, ls_phone_no
IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_member_sale.AcceptText() <> 1 THEN RETURN -1
IF dw_back_sale.AcceptText() <> 1 THEN RETURN -1

IF dw_1.AcceptText()    <> 1 THEN RETURN -1

		

dw_1.setfocus()
dw_1.setcolumn("goods_amt")


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


ll_row_count = dw_body.RowCount()
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
		ls_dot_com = dw_body.GetItemString(i, "dotcom")
		
		
		if ls_dot_com = "1" then 
			
				select a.shoP_cd, a.shop_div
				into :ls_shoP_cd, :ls_shop_div
				from tb_91100_m a (nolock)
				where exists (	select * 
						from tb_91100_m b (nolock) 
						where b.shoP_div = 'G'
						  and b.brand = a.brand
						  and b.cust_cd = a.cust_cd
						  and b.shop_cd = :gs_shop_cd
						)
				and shop_div = 'H'
				and shop_stat = '00'	;
				
				if IsNull(ls_shoP_cd) or Trim(ls_shoP_cd) = "" then
				   ls_shop_cd = gs_shop_cd
					ls_shop_div = gs_shop_div
			   else
					select right(isnull(max(SALE_NO), 0) + 10001, 4)
					  into :is_sale_no 
					  from tb_53010_h (nolock)
					 where yymmdd    = :is_yymmdd 
						and shop_cd   = :ls_shop_cd
						and shop_type in ('1','3');
				end if		
	   else
				   ls_shop_cd = gs_shop_cd
					ls_shop_div = gs_shop_div

		end if 

		  IF  idw_status <> NewModified! and gs_shop_div <> "H" and ls_dot_com = "1"  then
				MessageBox("경고", "기존판매분의 닷컴으로의 전환은 불가능합니다.!") 
				Return 0 
 		   END IF
			 

		
		IF idw_status = NewModified! THEN			/* New Record */  
			dw_body.Setitem(i, "no",  String(i, "0000"))
			dw_body.Setitem(i, "yymmdd", is_yymmdd)
			dw_body.Setitem(i, "shop_cd",  ls_shop_cd)
			dw_body.Setitem(i, "shop_div", ls_shop_div)
			dw_body.Setitem(i, "sale_no",  is_sale_no)
			dw_body.Setitem(i, "reg_id",   gs_user_id)
			dw_body.Setitem(i, "reg_dt", ld_datetime)			
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */	
		   dw_body.Setitem(i, "shop_cd",  ls_shop_cd)
	      dw_body.Setitem(i, "shop_div", MidA(ls_shop_cd,2,1))	
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
					ELSEIF LenA(Trim(dw_1.Object.jumin[1])) = 13 and LeftA(dw_body.Object.sale_type[i], 1) < '2' THEN  // 정상 적용 
						ls_sale_fg = '1' 
					ELSE
						ls_sale_fg = '0' 
					END IF		
	
		
   	ELSE		// 마일리지는 정상+ 30%sale 만 사용가능 

					IF ll_goods_amt > 0 and ll_sale_price > ll_goods_amt and  & 
						ll_sale_qty  > 0 and dw_body.Object.dc_rate[i] <  31  and dw_body.Object.sale_type[i]  < '30' THEN  
						ls_sale_fg = '2' 
					ELSEIF LenA(Trim(dw_1.Object.jumin[1])) = 13 and LeftA(dw_body.Object.sale_type[i], 1) < '2' THEN  // 정상 적용 
						ls_sale_fg = '1' 
					ELSE
						ls_sale_fg = '0' 
					END IF		

		END IF			
	
	

		if is_member_return = 'N' THEN  // 회원반품일때는 처리하지말고 RETURN    
			wf_amt_set(i, ll_sale_qty)
		end if	
			
		
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


		if isnull(ls_sale_type) or ls_sale_type = '' then 
			messagebox('주의','판매형태가 존재하지 않습니다. 관리팀에 문의하세요..')
			return -1
		end if	
	
		if is_member_return = 'N' THEN  // 회원반품일때는 처리하지말고 RETURN    
		  wf_line_chk(i)
		end if	
			
NEXT
		
		
 is_member_return  = 'N'   // 회원 반품 마크 해지 처리 

il_rows = dw_body.Update(TRUE, FALSE)
if il_rows = 1 then
	ls_phone_no = dw_body.getitemstring(1,"phone_no")
//	messagebox('ls_phone_no',ls_phone_no)
	if ls_phone_no <> '미지정매장' then
	   dw_back_sale.Update(TRUE, FALSE)
	end if
	
   dw_member_sale.Update(TRUE, FALSE)
   dw_body.ResetUpdate()
	if ls_phone_no <> '미지정매장' then
	   dw_back_sale.ResetUpdate()		
	end if
	
   dw_member_sale.ResetUpdate()	
   commit  USING SQLCA;
	dw_body.Retrieve(is_yymmdd, gs_shop_cd, is_sale_no) 
	This.Post Event ue_total_retrieve()
//	This.Post Event ue_rt_retrieve()	
	cb_1.SetFocus()
else
   rollback  USING SQLCA;
end if




Post Event ue_tot_set()

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
This.Post Event ue_rt_retrieve()
This.Post Event ue_member_retrieve()

dw_body.Visible = False
dw_1.Visible = False
dw_list.Visible = True

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;string ls_yymmdd

IF GS_BRAND = 'W' THEN
	ST_2.TEXT = "※ 2007년 겨울(W) 이전 제품은 관리팀에 문의 바랍니다! "


//	if  gs_shop_cd = "WK0032" or gs_shop_cd = "WK0040" or gs_shop_cd = "WG0003" or gs_shop_cd = "WG0006"  or gs_shop_cd = "WG0013" or gs_shop_cd = "WG0017" or gs_shop_cd = "WG0020" or gs_shop_cd = "WG0024" &
//	  or gs_shop_cd = "WG0042" or gs_shop_cd = "WG0035" or gs_shop_cd = "WG0004" or gs_shop_cd = "WG0018" or gs_shop_cd = "WG0036"  then
//		dw_1.object.cb_dept_give.visible = false
//	else
//	dw_1.object.cb_dept_give.visible = true
//	end if


ELSEif  GS_BRAND = 'N' THEN	
	ST_2.TEXT =  "※ 2008년 여름(M) 이전 제품은 관리팀에 문의 바랍니다! "
	dw_1.object.cb_dept_give.visible = false
ELSE	
	ST_2.TEXT = "※ 2008년 여름(M) 이전 제품은 관리팀에 문의 바랍니다! "
	dw_1.object.cb_dept_give.visible = false	
END IF		


IF MidA(GS_shop_cd,2,1) = 'H' THEN
	ST_6.TEXT = "※ 닷컴 매장으로 로그인 하셨습니다!"
ELSE	
	ST_6.TEXT = ""
END IF		


dw_1.object.cb_dept_give.visible = false
	
	
select convert(char(08), getdate(),112)
into :ls_yymmdd
from dual;


//if ls_yymmdd > '20060606' then 
//		dw_1.object.cb_dept_give.visible = false
//end if



DW_6.INSERTROW(0)
DW_11.INSERTROW(0)



is_member_return  = 'N'


// 인기도조사 투표 확인

il_rows = dw_15.retrieve(gs_shop_cd)

if il_rows > 0 then 
	
	integer Net
	Net = MessageBox("확인","출고상품 인기도조사 미투표건이 존재합니다..투표하세요!!")
//	w_main01.shl_1.visible = true
else
//	w_main01.shl_1.visible = false
end if	
end event

type cb_close from w_com010_e`cb_close within w_sh101_20080918
boolean visible = false
integer x = 389
end type

type cb_delete from w_com010_e`cb_delete within w_sh101_20080918
integer x = 1577
integer taborder = 70
end type

type cb_insert from w_com010_e`cb_insert within w_sh101_20080918
boolean visible = false
integer taborder = 60
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh101_20080918
integer x = 2469
integer width = 384
integer taborder = 110
string text = "일보조회(&Q)"
end type

type cb_update from w_com010_e`cb_update within w_sh101_20080918
integer taborder = 50
end type

type cb_print from w_com010_e`cb_print within w_sh101_20080918
boolean visible = false
integer taborder = 80
end type

type cb_preview from w_com010_e`cb_preview within w_sh101_20080918
boolean visible = false
integer x = 1193
integer y = 48
integer taborder = 90
end type

type gb_button from w_com010_e`gb_button within w_sh101_20080918
end type

type dw_head from w_com010_e`dw_head within w_sh101_20080918
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
//			Return 1
		END IF
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_sh101_20080918
integer beginy = 256
integer endy = 256
end type

type ln_2 from w_com010_e`ln_2 within w_sh101_20080918
integer beginy = 260
integer endy = 260
end type

type dw_body from w_com010_e`dw_body within w_sh101_20080918
event ue_set_column ( long al_row )
integer x = 5
integer y = 268
integer width = 2880
integer height = 564
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
					dw_body.SetItem(row, "goods_amt", 0)
					dw_body.SetItem(row, "give_rate", 0)
					dw_body.SetItem(row, "coupon_no", "")
					dw_body.SetItem(row, "phone_no", "")
					dw_body.SetItem(row, "visiter", "")
		
		li_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		IF li_ret <> 1 THEN
			This.Post Event ue_set_column(row) 
		END IF
		return li_ret
	CASE "sale_qty"	  
//		this.Setitem(row,"give_rate",0)
//		this.Setitem(row,"coupon_no","")
		
					dw_body.SetItem(row, "goods_amt", 0)
					dw_body.SetItem(row, "give_rate", 0)
					dw_body.SetItem(row, "coupon_no", "")
					dw_body.SetItem(row, "phone_no", "")
					dw_body.SetItem(row, "visiter", "")
					
		
		IF isnull(data) or Long(data) = 0 THEN RETURN 1
		if data = "-" then 
			messagebox("확인","반품등록은 일반/회원반품을 이용해 주세요..")
			return 1
		end if
			
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

event dw_body::doubleclicked;call super::doubleclicked;String ls_style_no, ls_yes , ls_coupon_no
Long   ll_curr_price, ll_sale_price, ll_collect_price, ld_goods_amt

if dwo.name <> "sale_type" OR gs_brand <> "N" then return

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
	
	dw_1.Setitem(1, "give_rate", 0)
	
	wf_goods_chk(long(ld_goods_amt), ls_coupon_no)
	wf_amt_set(row, This.Object.sale_qty[row]) 
   ib_changed = true
   cb_update.enabled = true
	Parent.Trigger Event ue_tot_set()
END IF 


end event

type dw_print from w_com010_e`dw_print within w_sh101_20080918
end type

type dw_1 from datawindow within w_sh101_20080918
event ue_keydown pbm_dwnkey
event type long ue_item_changed ( long row,  dwobject dwo,  string data )
integer x = 5
integer y = 832
integer width = 2880
integer height = 428
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

event type long ue_item_changed(long row, dwobject dwo, string data);string  ls_coupon_no, ls_secure_no, ls_tel_no3
decimal ld_goods_amt, ll_sale_qty, ll_sale_amt
long    i, ll_row_count

IF dw_1.AcceptText() <> 1 THEN RETURN 1

CHOOSE CASE dwo.name
	CASE "card_no" 
			wf_goods_amt_clear()
		IF WF_MEMBER_SET('2', data) = FALSE THEN
			if data <> "" then 
				MessageBox("오류", "미등록된 회원 입니다")
			end if
			This.Setitem(1, "goods_amt", 0)
			RETURN 1
		ELSE
			This.Setitem(1, "goods_amt", 0)
			This.SetColumn("goods_amt")
		END IF
   CASE "jumin"	
			wf_goods_amt_clear()		
		IF WF_MEMBER_SET('1', data) = FALSE THEN	
			if data <> "" then 
				MessageBox("오류", "미등록된 카드회원 입니다")
			end if
			
			This.Setitem(1, "goods_amt", 0)
			RETURN 1 
		ELSE
			This.Setitem(1, "goods_amt", 0)
			This.SetColumn("goods_amt")
		END IF 
	 CASE "tel_no3"
		wf_goods_amt_clear()
		SetPointer(HourGlass!)

		ls_secure_no = dw_1.getitemstring(1,"secure_no")
		if isnull(ls_secure_no) or LenA(ls_secure_no) <> 3 then
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
		if isnull(ls_tel_no3) or LenA(ls_tel_no3) < 7 then
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
		
	CASE "goods_amt" 
		wf_goods_amt_clear()
			ld_goods_amt = dw_1.getitemdecimal(1,"goods_amt")
			IF not wf_goods_chk(long(ld_goods_amt), ls_coupon_no) and ld_goods_amt <> 0 THEN 		
				this.Setitem(1,"goods_amt",0)
//				Parent.Post Event ue_tot_set()
//				RETURN 1
			END IF
		Parent.Post Event ue_tot_set()
	
END CHOOSE 
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
String ls_jumin
decimal ld_dc_rate


	
IF dw_body.AcceptText() <> 1 THEN RETURN -1

IF dwo.name = "b_member" THEN 
	wf_goods_amt_clear()
	this.setitem(1, "card_no","")
	this.setitem(1, "jumin","")	
	this.setitem(1, "tel_no3","")	
	this.setitem(1, "user_name","")		
	this.setitem(1, "goods_amt",0)			
	
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

IF dwo.name = "b_return" THEN  //회원반품
	
	gs_jumin = dw_1.GetitemString(1, "jumin")
			
	IF isnull(gs_jumin) or gs_jumin = "" Then
		messagebox('확인', '고객정보를 먼저 입력 하세요!')	  
		return	0
	END IF
   dw_member_sale.Retrieve(gs_jumin)
	dw_member_sale.visible =true
END IF	

IF dwo.name = "b_back_sale" THEN //일반반품
//   dw_back_sale.Retrieve('','xxxxxxxx','x','x',gs_shop_cd,'', gs_shop_cd, ld_dc_rate,'0')	
	dw_back_sale.reset()
	dw_back_sale.insertrow(1)
//	dw_back_sale.setitem(1,"yymmdd",is_yymmdd)
   dw_back_sale.setitem(1,"shop_cd",gs_shop_cd)	
	dw_back_sale.visible =true
	dw_back_sale.setcolumn("yymmdd")
	dw_back_sale.setfocus()
END IF

IF dwo.name = "cb_coupon" THEN 
	gs_jumin = dw_1.GetitemString(1, "jumin")		
	//  messagebox('주민 = ', gs_jumin)
	
	IF isnull(gs_jumin) or gs_jumin = "" Then
		messagebox('확인', '고객정보를 먼저 입력 하세요!')	  
		return	0
	END IF
	
	OpenWithParm (W_SH101_C, "W_SH101_C 증정권 전환") 			
   ls_jumin = Message.StringParm 
////////////////////////////////////////////////////////
			wf_goods_amt_clear()
		ls_jumin = dw_1.getitemstring(1,"jumin")
		IF WF_MEMBER_SET('1', ls_jumin) = FALSE THEN		
			if ls_jumin <> "" then 
				MessageBox("오류", "미등록된 카드회원 입니다")
			end if
			
			This.Setitem(1, "goods_amt", 0)
			RETURN 1 
		ELSE
			This.Setitem(1, "goods_amt", 0)
			This.SetColumn("goods_amt")
		END IF 
////////////////////////////////////////////////////////

END IF
	
IF dwo.name = "cb_give" THEN 
	gs_jumin = dw_1.GetitemString(1, "jumin")		
	//  messagebox('주민 = ', gs_jumin)
	
	IF isnull(gs_jumin) or gs_jumin = "" Then
		messagebox('확인', '고객정보를 먼저 입력 하세요!')	  
		return	0
	END IF

	dw_10.retrieve(gs_jumin, gs_brand, gs_shop_cd)
	dw_10.visible = true

END IF

IF dwo.name = "cb_dept_give" THEN 
	//  messagebox('주민 = ', gs_jumin)
	
	IF gs_brand <> 'W' then
		messagebox('확인', '더블유닷매장만 진행중입니다!')	  
		return	0
	END IF

	dw_11.visible = true

END IF

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

type cb_1 from commandbutton within w_sh101_20080918
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
dw_body.enabled = true
dw_1.enabled = true
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
dw_back_sale.reset()
dw_member_sale.reset()
dw_1.Reset()
dw_1.object.text_message.text = ""
dw_1.object.text_message2.text = ""
dw_1.insertRow(0)

dw_body.setcolumn("style_no")
dw_body.setfocus()

Parent.Trigger Event ue_button(6, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type st_1 from statictext within w_sh101_20080918
integer y = 264
integer width = 2894
integer height = 1008
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

type dw_2 from datawindow within w_sh101_20080918
boolean visible = false
integer x = 32
integer y = 1380
integer width = 2843
integer height = 392
string title = "none"
string dataobject = "d_sh101_d03"
boolean border = false
boolean livescroll = true
end type

event doubleclicked;dw_2.visible = false
dw_3.visible = true
end event

type st_2 from statictext within w_sh101_20080918
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
string text = "※ 2006년 겨울(W) 이전 제품은 관리팀에 문의 바랍니다!"
boolean focusrectangle = false
end type

type tab_1 from tab within w_sh101_20080918
event create ( )
event destroy ( )
integer x = 5
integer y = 1280
integer width = 2894
integer height = 548
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_4=create tabpage_4
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_4,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_4)
destroy(this.tabpage_3)
end on

event clicked;
  	CHOOSE CASE index
		CASE 1
			dw_2.visible = false
			dw_3.visible = TRUE
			dw_4.visible = false
			dw_5.visible = false
			dw_6.visible = false
			dw_7.visible = false
			dw_8.visible = false
			dw_9.visible = false						
			dw_12.visible = false		
			st_4.visible = false			
			st_5.visible = false

		CASE 2
			dw_2.visible = false
			dw_3.visible = false
			dw_4.visible = TRUE
			dw_5.visible = false
			dw_6.visible = false
			dw_7.visible = false		
			dw_8.visible = false
			dw_9.visible = false						
			dw_12.visible = false					
			st_4.visible = true
			st_5.visible = true

	  	  
 		CASE 3
				
			dw_2.visible = false
			dw_3.visible = false
			dw_4.visible = false
			dw_5.visible = false
			dw_6.visible = false
			dw_7.visible = false	
			dw_8.visible = TRUE
			dw_12.visible = false					
			dw_9.visible = false
			st_4.visible = FALSE
			st_5.visible = FALSE		
			
			if dw_8.rowcount() <= 0 then
				parent.Post Event ue_member_retrieve() 	
		   end if
			
 		CASE 4
			
			dw_2.visible = false
			dw_3.visible = false
			dw_4.visible = false
			dw_5.visible = false
			dw_6.visible = TRUE
			dw_7.visible = TRUE	
			dw_8.visible = false
			dw_9.visible = false		
			dw_12.visible = false					
			st_4.visible = FALSE
			st_5.visible = FALSE
		
 
	END CHOOSE
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2857
integer height = 436
boolean border = true
long backcolor = 79741120
string text = "  매출  "
borderstyle borderstyle = stylelowered!
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2857
integer height = 436
boolean border = true
long backcolor = 79741120
string text = "  R/T  "
borderstyle borderstyle = stylelowered!
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2857
integer height = 436
long backcolor = 79741120
string text = "회원모집"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2857
integer height = 436
long backcolor = 79741120
string text = "행사가조회"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type st_3 from statictext within w_sh101_20080918
integer x = 1266
integer y = 1296
integer width = 1618
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "매출계(년월계:기획제외) - 항목, 숫자 더블클릭하세요!"
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_sh101_20080918
integer x = 32
integer y = 1380
integer width = 2839
integer height = 80
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh101_d03"
boolean border = false
boolean livescroll = true
end type

event doubleclicked;dw_2.visible = true
dw_3.visible = false
end event

type dw_5 from datawindow within w_sh101_20080918
boolean visible = false
integer x = 50
integer y = 1388
integer width = 2793
integer height = 416
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "D_SH129_D02"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;dw_5.visible = false
dw_4.visible = true
st_4.visible = true
st_5.visible = true
end event

type dw_4 from datawindow within w_sh101_20080918
boolean visible = false
integer x = 32
integer y = 1388
integer width = 2825
integer height = 416
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "D_SH129_D01"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;integer li_week_no
long ll_row

dw_5.visible = true
dw_4.visible = false
st_4.visible = false
st_5.visible = false

li_week_no = this.GetitemNumber(row, "week_no")

ll_row = dw_5.Retrieve(MidA(gs_shop_cd,1,10) , li_week_no, gs_shop_cd)
IF ll_row < 1 THEN
	dw_4.insertRow(0) 
END IF 

end event

type st_4 from statictext within w_sh101_20080918
boolean visible = false
integer x = 1915
integer y = 1480
integer width = 905
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
string text = "※ 더블클릭하시면 상세 내역을 "
boolean focusrectangle = false
end type

type st_5 from statictext within w_sh101_20080918
boolean visible = false
integer x = 2007
integer y = 1544
integer width = 526
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
string text = "보실 수 있습니다!"
boolean focusrectangle = false
end type

type dw_6 from datawindow within w_sh101_20080918
boolean visible = false
integer x = 55
integer y = 1384
integer width = 823
integer height = 432
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "D_SH101_D21"
boolean border = false
boolean livescroll = true
end type

event itemchanged;integer li_ret
decimal ld_goods_amt
CHOOSE CASE dwo.name
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		li_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		return li_ret
END CHOOSE

end event

event buttonclicked;
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

type dw_7 from datawindow within w_sh101_20080918
boolean visible = false
integer x = 859
integer y = 1384
integer width = 2016
integer height = 432
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "D_SH101_D22"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_8 from datawindow within w_sh101_20080918
boolean visible = false
integer x = 23
integer y = 1376
integer width = 2857
integer height = 436
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh101_d25"
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;integer li_week_no
long ll_row

dw_8.visible = false
dw_9.visible = true

li_week_no = this.GetitemNumber(row, "week_no")

ll_row = dw_9.Retrieve( MidA(is_yymmdd,1,6), gs_brand, gs_shop_cd, li_week_no , 'B')

IF ll_row < 1 THEN
	dw_9.insertRow(0) 
END IF 

end event

type dw_9 from datawindow within w_sh101_20080918
boolean visible = false
integer x = 23
integer y = 1376
integer width = 2857
integer height = 436
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh101_d24"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;dw_8.visible = true
dw_9.visible = false

end event

type dw_10 from datawindow within w_sh101_20080918
boolean visible = false
integer x = 247
integer y = 256
integer width = 2281
integer height = 732
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "구매할인권발급내역"
string dataobject = "d_sh101_d32"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;String ls_give_date, ls_coupon_no, ls_yymmdd, ls_use_ymd, ls_verify_no, ls_chk_verify
long ll_give_amt, ll_give_rate
DECIMAL ld_goods_amt

is_use_shop = ""

IF dw_10.AcceptText()    <> 1 THEN RETURN 

select convert(char(08), getdate(),112)
into :ls_yymmdd
from dual;

IF row < 1 THEN RETURN 


ll_give_amt  = This.GetitemNumber(row, "give_amt")
ll_give_rate = This.GetitemNumber(row, "give_rate")
ls_give_date = This.GetitemString(row, "give_date")
ls_coupon_no = This.GetitemString(row, "coupon_no")
ls_use_ymd   = This.GetitemString(row, "use_ymd")
ls_verify_no = This.GetitemString(row, "verify_no")
ls_chk_verify = This.GetitemString(row, "chk_verify")
is_use_shop  = This.GetitemString(row, "use_shop")


IF  ls_use_ymd < ls_yymmdd THEN
	 messagebox('경고', '유효기간이 지난 쿠폰입니다 !')
	 return 1 
END IF

if IsNull(ls_verify_no) or Trim(ls_verify_no) = "" then
   ls_verify_no = "AA"
end if

if IsNull(ls_chk_verify) or Trim(ls_chk_verify) = "" then
   ls_chk_verify = "AA"
end if


if upper(ls_verify_no) <> upper(ls_chk_verify) and ls_coupon_no <> 'O07611' then // 007611쿠폰 : 인증체크 안함
	 messagebox('경고', '쿠폰인증 번호가 다릅니다! 인증번호를 확인해주세요!')
	 this.SetColumn("chk_verify")
	 return 1 
end if	 

dw_1.Setitem(1, "goods_amt", ll_give_amt) 
dw_1.Setitem(1, "give_rate", ll_give_rate) 

dw_1.Setitem(1, "give_date", ls_give_date) 
dw_1.Setitem(1, "coupon_no", ls_coupon_no) 
dw_1.AcceptText() 

ld_goods_amt = dw_1.getitemdecimal(1,"goods_amt")	

IF not wf_goods_chk(long(ld_goods_amt), ls_give_date)  THEN 		
	dw_1.Setitem(1,"goods_amt",0)
	Parent.Post Event ue_tot_set()
	RETURN 1
END IF
	
if ll_give_rate > 0 then 
	IF not wf_give_rate_chk(ll_give_rate, ls_give_date)  THEN 		
		dw_1.Setitem(1,"give_rate",0)	
		Parent.Post Event ue_tot_set()
		RETURN 1
	END IF	

end if
Parent.Post Event ue_tot_set()

dw_1.SetColumn("jumin")

this.visible = false
end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
String ls_jumin


IF dwo.name = "cb_close" THEN 
	dw_10.visible = false
END IF	

end event

event clicked;
This.SelectRow(0, FALSE)

This.SelectRow(row, TRUE)
end event

type dw_11 from datawindow within w_sh101_20080918
boolean visible = false
integer x = 1637
integer y = 1368
integer width = 1216
integer height = 352
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "백화점 할인권 사용"
string dataobject = "d_sh101_d33"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;String ls_jumin



CHOOSE CASE dwo.name
	CASE "cb_close"	     //  Popup 검색창이 존재하는 항목 
		dw_11.visible = false
	CASE "cb_apply"	  
		IF dw_11.AcceptText() <> 1 THEN RETURN 1
		wf_amt_set2()
		

END CHOOSE
end event

type dw_12 from datawindow within w_sh101_20080918
boolean visible = false
integer x = 1810
integer y = 1108
integer width = 1079
integer height = 688
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "고객구매현황"
string dataobject = "d_sh101_d26"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_list from datawindow within w_sh101_20080918
event ue_syscommand pbm_syscommand
integer y = 256
integer width = 2898
integer height = 1024
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

type dw_13 from datawindow within w_sh101_20080918
boolean visible = false
integer x = 795
integer y = 264
integer width = 1911
integer height = 964
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "사내판매내역"
string dataobject = "d_message_001"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_sh101_20080918
boolean visible = false
integer x = 1701
integer y = 44
integer width = 384
integer height = 92
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "사내판매내역"
end type

event clicked;integer li_cnt

select count(style) into :li_cnt 
from tb_53060_h a(nolock), VI_93010_3 b (nolock)
where datepart(week, a.yymmdd) = datepart(week, getdate()) 
and   a.empno = b.empno
and   b.dept_code = :gs_shop_cd;
//and out_yn = 'Y';

if li_cnt > 0 then
	dw_13.retrieve(gs_shop_cd)
	dw_13.visible = true
else
	messagebox("알림!", "요청한 내역이 없습니다!")	
end if 
end event

type dw_back_sale from datawindow within w_sh101_20080918
event ue_keydown pbm_dwnkey
boolean visible = false
integer y = 24
integer width = 2894
integer height = 1804
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "일반회원 구매내역"
string dataobject = "d_sh101_d34"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
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
long ll_row


This.GetChild("shop_cd", idw_shop_cd)
idw_shop_cd.SetTransObject(SQLCA)
ll_row = idw_shop_cd.Retrieve(gs_brand)
ll_row = ll_row + 1
idw_shop_cd.insertrow(ll_row)
idw_shop_cd.setitem(ll_row,"shop_cd","")
idw_shop_cd.setitem(ll_row,"shop_snm","매장 미지정")



This.GetChild("sale_type", idw_sale_type)
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.Retrieve('011')



This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')


end event

event buttonclicked;string     ls_sale_no, ls_style, ls_chno, ls_color, ls_size,ls_style_no,ls_sale_type,ls_age_grp,ls_sale_fg,ls_jumin, ls_card_no,ls_coupon_no 
string	  ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_shop_div, ls_plan_yn,ls_shop_type, ls_return_yn
decimal    ld_sale_qty, ld_tag_price,ld_curr_price, ld_dc_rate, ld_sale_price,ld_tag_amt,ld_curr_amt,ld_sale_amt  
decimal    ld_out_rate, ld_out_amt, ld_sale_rate ,ld_sale_collect,ld_goods_amt,ld_io_amt, ld_io_vat  
long       ll_row_count, i, j = 0, ll_ret_cnt
string 	  ls_yymmdd, ls_shop_cd, ls_shop_nm, ls_phone_no, ls_visiter, ls_dotcom, ls_rtrn_info


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


													
					if isnull(ls_visiter) or ls_visiter= '' then
						messagebox("확인","반품구분을 입력해주세요..")
						return								
					end if

					if wf_style_chk_back(j, ls_style_no) = false then 
						messagebox("확인","시즌 마감 되었거나 잘못된 스타일 입니다.")
						return 
					end if				

//					if len(ls_shop_cd) <> 6 or isnull(ls_shop_cd) then  // 매장 미지정
//						this.reset()
//					end if
					

					j= j + 1
					dw_body.insertrow(j)
					
					select  plan_yn 
					into	 :ls_plan_yn
					from    tb_12020_m (nolock)
					where   style = :ls_style;
					
					if  ls_plan_yn = 'Y' then
					 ls_shop_type = '3'
					else
					 ls_shop_type = '1'
					end if
					
					
					dw_body.Setitem(j, "style",ls_style)
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
					if ls_phone_no = '미지정매장' then 
						dw_body.Setitem(j, "phone_no", ls_phone_no)
					else
						dw_body.Setitem(j, "phone_no", ls_rtrn_info)	
					end if
					dw_body.Setitem(j, "visiter", ls_visiter)
					dw_body.Setitem(j, "dotcom", ls_dotcom)					
//					wf_style_set(j, ls_style, ls_yymmdd, ld_sale_qty)
					parent.cb_delete.enabled = false
				end if
		NEXT
		
		
		is_member_return = 'N'
		dw_body.visible = TRUE 
		dw_1.visible    = TRUE 
		dw_body.enabled = false
		dw_1.enabled = false

		dw_member_sale.visible = FALSE
		dw_back_sale.visible = FALSE

		cb_update.enabled = true	
	
		
	case "cb_sale"
		dw_1.Reset()
		dw_1.insertrow(1)
		 
		ls_yymmdd      = This.GetitemString(1, "yymmdd")
		ls_style       = This.GetitemString(1, "style")
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
		
		if LenA(ls_shop_cd) = 6 and ls_shop_cd <> gs_shop_cd and (isnull(ls_style) or LenA(ls_style) < 8) then 
			messagebox('확인','스타일번호를 입력하세요..')
			this.setcolumn("style_no")
			this.setfocus()
			return 0
		end if
		
		if LenA(ls_yymmdd) = 8 and (isnull(ls_shop_cd) or LenA(ls_shop_cd) < 6) and LenA(ls_style) < 8 then 
			messagebox('확인','스타일번호를 입력하세요..')
			this.setcolumn("shop_cd")
			this.setfocus()
			return 0			
		end if

		if ls_shop_cd = gs_shop_cd and (isnull(ls_yymmdd) or LenA(ls_yymmdd) < 8) and (isnull(ls_style) or LenA(ls_style) < 8) then 
			messagebox('확인','날짜 또는 스타일번호를 입력하세요..')
			this.setcolumn("style_no")
			this.setfocus()
			return 0
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
		
		il_rows = dw_back_sale.retrieve(ls_style, ls_chno, ls_color, ls_size, ls_shop_cd, ls_yymmdd, gs_shop_cd, ld_dc_rate, ls_dotcom)	 
		
messagebox("", ls_style + '/' +  ls_chno + '/' + ls_color + '/' + ls_size +   '/' + gs_shop_cd + '/' + string(ld_dc_rate,'00') + '/' + ls_dotcom	)	
		if il_rows = 1 then
			messagebox("확인","검색된 판매내역이 없습니다..")
		end if									
		is_member_return = 'N'			
end choose




Parent.Post Event ue_tot_set()




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
			
			li_ret = Parent.Trigger Event ue_Popup("style_no_back", row, data, 1)
			if li_ret = 1 then  
				return li_ret
			end if
			
			this.setitem(row,"style",LeftA(data,8))
			this.setitem(row,"chno",MidA(data,9,1))
			this.setitem(row,"color",MidA(data,10,2))
			this.setitem(row,"size",MidA(data,12,2))

	case "return_yn"
		if data = 'N' or isnull(data) then 
			this.setitem(row,"phone_no","")
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

type dw_member_sale from datawindow within w_sh101_20080918
event ue_return_point ( )
boolean visible = false
integer y = 24
integer width = 2894
integer height = 1792
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "고객구매내역"
string dataobject = "d_sh101_d31"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event ue_return_point;long ld_return_point_all, ld_remain_point

	ld_return_point_all = dw_member_sale.getitemdecimal(1,"return_point_all")
	
//messagebox("확인",id_remain_point)
//messagebox("확인",ld_return_point_all)
	ld_remain_point = id_remain_point - ld_return_point_all
	if ld_remain_point < 0 then 
		messagebox("확인","해당제품 반품시 마이너스 마일리지 " + string(ld_remain_point * -1) + "원이 발생하게됩니다. 고객님께 수금해 주세요." )
	end if
	
end event

event constructor;DataWindowChild ldw_child 


This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')



This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')


end event

event buttonclicked;string     ls_style, ls_chno, ls_color, ls_size,ls_style_no,ls_sale_type,ls_age_grp,ls_sale_fg,ls_jumin, ls_card_no,ls_coupon_no 
string	  ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_shop_div, ls_plan_yn,ls_shop_type, ls_return_yn
decimal    ld_sale_qty, ld_tag_price,ld_curr_price, ld_dc_rate, ld_sale_price,ld_tag_amt,ld_curr_amt,ld_sale_amt  
decimal    ld_out_rate, ld_out_amt, ld_sale_rate ,ld_sale_collect,ld_goods_amt,ld_io_amt, ld_io_vat, ld_jan_point
long       ll_row_count, i, j = 0
string     ls_phone_no, ls_visiter, ls_yymmdd

IF row < 1 THEN RETURN

dw_body.Reset()

//ll_row_count = This.RowCount()

//FOR i = ll_row_count to 1 step -1 
//	ls_return_yn = This.GetitemString(i, "return_yn")	 
//	IF  ls_return_yn <> 'Y' THEN
//		dw_member_sale.DeleteRow(i) 
//	END IF
//NEXT 

ll_row_count = This.RowCount()

FOR i = 1 to ll_row_count 
	ls_return_yn = This.GetitemString(i, "return_yn")	 
	IF  ls_return_yn = 'Y' THEN		
		ls_yymmdd       = This.GetitemString(i, "yymmdd")		
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
		ls_phone_no		= This.GetitemString(i, "phone_no")
		ls_visiter		= This.GetitemString(i, "visiter")

		
		j= j + 1
		dw_body.insertrow(j)
		
		select  plan_yn 
		into	 :ls_plan_yn
		from    tb_12020_m (nolock)
		where   style = :ls_style;
		
		if  ls_plan_yn = 'Y' then
		 ls_shop_type = '3'
		else
		 ls_shop_type = '1'
		end if
		
		
		if wf_style_chk_back(j, ls_style_no) = false then 
			messagebox("확인","시즌 마감 되었거나 잘못된 스타일 입니다.")
			return 
		end if	
		
		dw_body.Setitem(j, "style",ls_style)
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
		dw_body.Setitem(j, "sale_rate",ld_sale_rate) 	
		dw_body.Setitem(j, "sale_collect",ld_sale_collect) 	 
		dw_body.Setitem(j, "goods_amt",ld_goods_amt) 	
		dw_body.Setitem(j, "io_amt",ld_io_amt)  
		dw_body.Setitem(j, "io_vat", ld_io_vat)  
		dw_body.Setitem(j, "phone_no", ls_phone_no)
		dw_body.Setitem(j, "visiter", ls_visiter)	
		
//		wf_style_set(j, ls_style, ls_yymmdd, ld_sale_qty)		
		dw_member_sale.SetItemStatus(i, "phone_no", Primary!, DataModified!)
		dw_member_sale.SetItemStatus(i, "visiter", Primary!, DataModified!)
	elseif  ls_return_yn = 'N' THEN
		setnull(ls_phone_no)
		setnull(ls_visiter)
		
		This.Setitem(i, "phone_no", ls_phone_no)
		This.Setitem(i, "visiter", ls_visiter)
		dw_member_sale.SetItemStatus(i, "phone_no", Primary!, DataModified!)
		dw_member_sale.SetItemStatus(i, "visiter", Primary!, DataModified!)	

	end if
NEXT

is_member_return = 'Y'



Parent.Post Event ue_tot_set()
dw_1.Setitem(1, "goods_amt", ld_goods_amt)


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
	dw_1.Setitem(1, "age_grp",ls_age_grp)
	
END IF

dw_body.visible = TRUE 
dw_1.visible    = TRUE 
dw_member_sale.visible = FALSE


cb_update.enabled = true

end event

event itemchanged;decimal ld_remain_point, ld_return_point_all

if dwo.name = "return_yn" then 
	post event ue_return_point()
end if
end event

type st_6 from statictext within w_sh101_20080918
integer x = 389
integer y = 56
integer width = 1170
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711935
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type dw_14 from datawindow within w_sh101_20080918
boolean visible = false
integer x = 1038
integer y = 272
integer width = 1723
integer height = 1112
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "KM 사이트 최신정보"
string dataobject = "d_sh101_d35"
boolean controlmenu = true
boolean minbox = true
string icon = "Information!"
boolean livescroll = true
borderstyle borderstyle = styleshadowbox!
end type

event clicked;uint rtn, wstyle
string ls_file_name, ls_url

CHOOSE CASE dwo.name
	CASE "s_data2" 
		ls_url =	this.getitemstring(row, "km_new")
		ls_file_name = "C:\\Program Files\\Internet Explorer\\iexplore.exe  "
		ls_file_name = ls_file_name + ls_url
		wstyle = 1				
		rtn = WinExec(ls_file_name, wstyle)
END CHOOSE

end event

type dw_15 from datawindow within w_sh101_20080918
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

