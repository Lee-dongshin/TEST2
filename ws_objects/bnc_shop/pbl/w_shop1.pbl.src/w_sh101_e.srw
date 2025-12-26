$PBExportHeader$w_sh101_e.srw
$PBExportComments$판매일보등록
forward
global type w_sh101_e from w_com010_e
end type
type dw_1 from datawindow within w_sh101_e
end type
type cb_1 from commandbutton within w_sh101_e
end type
type st_1 from statictext within w_sh101_e
end type
type dw_2 from datawindow within w_sh101_e
end type
type st_2 from statictext within w_sh101_e
end type
type tab_1 from tab within w_sh101_e
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
type tabpage_5 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tab_1 from tab within w_sh101_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_3 tabpage_3
tabpage_5 tabpage_5
end type
type st_3 from statictext within w_sh101_e
end type
type dw_3 from datawindow within w_sh101_e
end type
type dw_5 from datawindow within w_sh101_e
end type
type dw_4 from datawindow within w_sh101_e
end type
type st_4 from statictext within w_sh101_e
end type
type st_5 from statictext within w_sh101_e
end type
type dw_6 from datawindow within w_sh101_e
end type
type dw_7 from datawindow within w_sh101_e
end type
type dw_8 from datawindow within w_sh101_e
end type
type dw_9 from datawindow within w_sh101_e
end type
type dw_10 from datawindow within w_sh101_e
end type
type dw_11 from datawindow within w_sh101_e
end type
type dw_12 from datawindow within w_sh101_e
end type
type dw_list from datawindow within w_sh101_e
end type
type dw_13 from datawindow within w_sh101_e
end type
type cb_2 from commandbutton within w_sh101_e
end type
type dw_back_sale from datawindow within w_sh101_e
end type
type dw_member_sale from datawindow within w_sh101_e
end type
type st_6 from statictext within w_sh101_e
end type
type dw_14 from datawindow within w_sh101_e
end type
type dw_15 from datawindow within w_sh101_e
end type
type st_ok_coupon1 from statictext within w_sh101_e
end type
type st_ok_coupon2 from statictext within w_sh101_e
end type
type dw_16 from datawindow within w_sh101_e
end type
type shl_member from statichyperlink within w_sh101_e
end type
type dw_17 from datawindow within w_sh101_e
end type
type dw_18 from datawindow within w_sh101_e
end type
type dw_19 from datawindow within w_sh101_e
end type
type dw_cosmetic from datawindow within w_sh101_e
end type
type em_1 from editmask within w_sh101_e
end type
type st_7 from statictext within w_sh101_e
end type
type dw_20 from datawindow within w_sh101_e
end type
type dw_21 from datawindow within w_sh101_e
end type
type st_8 from statictext within w_sh101_e
end type
type cb_3 from commandbutton within w_sh101_e
end type
type st_online_gubn from statictext within w_sh101_e
end type
type rb_1 from radiobutton within w_sh101_e
end type
type rb_2 from radiobutton within w_sh101_e
end type
type st_online_id from statictext within w_sh101_e
end type
type sle_id from singlelineedit within w_sh101_e
end type
type cb_online_coupon from commandbutton within w_sh101_e
end type
type cb_emp_sale from commandbutton within w_sh101_e
end type
type cb_kakao_coupon from commandbutton within w_sh101_e
end type
type st_9 from statictext within w_sh101_e
end type
type dw_22 from datawindow within w_sh101_e
end type
end forward

global type w_sh101_e from w_com010_e
integer width = 2981
integer height = 2064
boolean controlmenu = false
boolean minbox = false
boolean ib_closestatus = true
event ue_tot_set ( )
event ue_total_retrieve ( )
event ue_rt_retrieve ( )
event ue_member_retrieve ( )
event ue_rtrn_rate_chk ( )
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
st_ok_coupon1 st_ok_coupon1
st_ok_coupon2 st_ok_coupon2
dw_16 dw_16
shl_member shl_member
dw_17 dw_17
dw_18 dw_18
dw_19 dw_19
dw_cosmetic dw_cosmetic
em_1 em_1
st_7 st_7
dw_20 dw_20
dw_21 dw_21
st_8 st_8
cb_3 cb_3
st_online_gubn st_online_gubn
rb_1 rb_1
rb_2 rb_2
st_online_id st_online_id
sle_id sle_id
cb_online_coupon cb_online_coupon
cb_emp_sale cb_emp_sale
cb_kakao_coupon cb_kakao_coupon
st_9 st_9
dw_22 dw_22
end type
global w_sh101_e w_sh101_e

type variables
String is_yymmdd, is_sale_no, is_member_return, idw_give_amt, is_use_shop, is_ok_coupon = "N", is_dotcom_select = "N", is_mj_bit = 'N', is_coupon_gubn
long id_remain_point
decimal idc_dc_rate_org
datawindowchild idw_shop_cd, idw_sale_type, idw_shop_type, idw_event_id

string is_close_ymd_t, is_year_t, is_season_t, is_season_nm_t, is_season_s_t, is_s_gubn_t, is_e_gubn_t, is_p_gubn_t
string is_close_ymd_f, is_year_f, is_season_f, is_season_nm_f, is_season_s_f, is_s_gubn_f, is_e_gubn_f, is_p_gubn_f
string is_set_style_chk ,is_coupon, is_empno, is_empno_stat,is_coupon_no, is_kakao_apply, is_kakao_coupon_type, is_kakao_return_ok
end variables

forward prototypes
public function boolean uf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name)
public function boolean uf_chk_birthday (string as_birthday, ref string as_jumin, ref string as_user_name, ref string as_tel_no3)
public function integer uf_yes_no_imsi (string as_user_name)
public function boolean uf_member_chk (string as_flag, string as_find)
public subroutine wf_rtrn_rate_check ()
public subroutine wf_goods_chk4 ()
public function integer wf_yes_no (string as_title)
public subroutine wf_goods_amt_clear ()
public subroutine wf_line_chk (long al_row)
public function boolean wf_member_set (string as_flag, string as_find)
public function boolean wf_set_cosmetic (string as_set_style_chk)
public subroutine wf_amt_clear ()
public subroutine wf_amt_set2 ()
public subroutine wf_amt_set3 (long al_row)
public subroutine wk (long al_row, long al_sale_qty, string as_style)
public subroutine wf_amt_set_empno (long al_row, long al_sale_qty, string as_style)
public function boolean wf_give_rate_chk (integer al_give_rate, string as_coupon_date)
public function boolean wf_goods_chk (long al_goods_amt, string as_coupon_date)
public function boolean wf_goods_chk2 (long al_goods_amt, string as_coupon_date)
public function boolean wf_goods_chk5 (long al_goods_amt, string as_coupon_date)
public subroutine wf_goods_chk3 ()
public subroutine wf_goods_chk3_kakao ()
public subroutine wf_ok_coupon (integer al_row, string as_ok_coupon)
public function boolean wf_stock_chk (long al_row, string as_style_no)
public subroutine wf_amt_set (long al_row, long al_sale_qty)
public function integer wf_set_margin (integer al_row, integer al_give_rate)
public function boolean wf_close_check (string as_brand, ref string as_close_ymd_t, ref string as_year_t, ref string as_season_t, ref string as_season_nm_t, ref string as_season_s_t, ref string as_gubn_1_t, ref string as_gubn_2_t, ref string as_gubn_3_t, ref string as_close_ymd_f, ref string as_year_f, ref string as_season_f, ref string as_season_nm_f, ref string as_season_s_f, ref string as_gubn_1_f, ref string as_gubn_2_f, ref string as_gubn_3_f)
public function boolean wf_style_chk_back_member (long al_row, string as_style_no)
public subroutine wf_amt_set_row ()
public subroutine wf_amt_set_kakao_style (long al_row, long al_sale_qty, string as_style)
public function boolean wf_style_set2 (long al_row, string as_style, string as_yymmdd, long al_qty, string as_dotcom)
public subroutine wf_amt_set_kakao_1 (long al_row, long al_sale_qty, string as_style)
public function boolean wf_style_chk_back (long al_row, string as_style_no)
public subroutine wf_amt_set_kakao (long al_row, long al_sale_qty, string as_style)
public function boolean wf_style_set (long al_row, string as_style, string as_yymmdd, long al_qty)
public subroutine wf_amt_set_kakao_2 (long al_row, long al_sale_qty, string as_style)
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
string ls_find, ls_shop_type


is_yymmdd  = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

ll_row = dw_4.Retrieve(mid(gs_shop_cd,1,10) , mid(is_yymmdd,1,6), gs_shop_cd)
IF ll_row < 1 THEN
	dw_4.insertRow(0) 
else
	select datepart(week, :is_yymmdd) -1 , datepart(weekday, :is_yymmdd)
	into :li_week_no, :li_day_no
	from dual;
	
	ls_find  = "week_no = " + string(li_week_no) + " and shop_type = '1' "
		ll_find = dw_4.find(ls_find, 1, dw_4.RowCount())
		IF ll_find > 0 THEN
			ll_recall_qty = dw_4.getitemNumber(ll_find, "recall_qty")
//			ll_accept_qty = dw_4.getitemNumber(ll_find, "accept_qty")	
			ll_accept_qty = dw_4.getitemNumber(ll_find, "re_qty")				
			//ldc_rt_rate 	= ll_accept_qty / ll_recall_qty 
			ldc_rt_rate = dw_4.getitemNumber(ll_find, "COMPUTE_11")				
		end if		

//   li_day_no = 6

	if li_day_no >= 6 and ldc_rt_rate < 0.8 and ll_recall_qty <> 0 then
//		if gs_brand = 'N' then
		  messagebox("경고!", "RT승인율이 80%미만으로 출고정지대상이 됩니다! RT를 확인하세요!")
			st_3.text = "RT승인율이 80%미만으로 출고정지 대상이 됩니다! RT를 확인하세요!"	
//		end if	
//	elseif li_day_no >= 6 and ldc_rt_rate < 0.8 and ll_recall_qty <> 0 then
//		if gs_brand = 'W' then
//		  messagebox("경고!", "RT승인율이 80%미만으로 출고정지대상이 됩니다! RT를 확인하세요!")
//			st_3.text = "RT승인율이 80%미만으로 출고정지 대상이 됩니다! RT를 확인하세요!"	
//		end if	
//	elseif li_day_no >= 6 and ldc_rt_rate < 0.5 and ll_recall_qty <> 0 then
//		if gs_brand = 'O' then
//		  messagebox("경고!", "RT승인율이 50%미만으로 출고정지대상이 됩니다! RT를 확인하세요!")
//			st_3.text = "RT승인율이 50%미만으로 출고정지 대상이 됩니다! RT를 확인하세요!"
//		END IF	
	else
		st_3.text = "매출계(년월계:기획제외) - 항목, 숫자 더블클릭하세요!"
	end if	
	
END IF 
end event

event ue_member_retrieve();Long ll_row , ll_find, ll_recall_qty, ll_accept_qty
decimal ldc_rt_rate
integer li_week_no, li_day_no
string ls_find


ll_row = dw_8.Retrieve( mid(is_yymmdd,1,6), gs_brand, gs_shop_cd)
//ll_row = dw_8.Retrieve( '200602', 'n', 'ng0006', 0 , 'A')
dw_12.Retrieve( mid(is_yymmdd,1,6), gs_shop_cd)
IF ll_row < 1 THEN	
	dw_8.insertRow(0) 
END IF 

end event

event ue_rtrn_rate_chk();wf_rtrn_rate_check()
end event

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


	if li_cnt <> 1 or isnull(as_jumin) or len(as_jumin) <> 13 then 
		return False
	else 
		return True
	end if
	
end function

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




	if li_cnt <> 1 or isnull(as_jumin) or len(as_jumin) <> 13 then 
		return False
	else 
		return True
	end if
	
end function

public function integer uf_yes_no_imsi (string as_user_name);


RETURN  MessageBox('확인',as_user_name+' 고객님이 맞습니까?', &
			          Question!, YesNo!)

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

public subroutine wf_rtrn_rate_check ();string ls_date

ls_date = string(dw_head.GetItemDate(1,'yymmdd'))
ls_date = mid(ls_date,1,4) + mid(ls_date,6,2)

dw_8.retrieve(gs_brand, ls_date, '%', gs_shop_cd)


end subroutine

public subroutine wf_goods_chk4 ();
decimal ll_tot_real_amt, ll_sale_amt, ll_chk_sale_amt, ll_excp_cnt
long i, ll_row_count, j
string ls_dc_flag, ls_coupon_no, ls_style_no, ls_sale_type, ls_season, ls_style_chk, ls_style

string ls_jumin
decimal ld_goods_amt

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
4W 판매형태 11
*/


for i=1 to ll_row_count

	ll_sale_amt = 0
	ls_style_no = ""
	ls_sale_type = ""
	ls_season = ""
	ll_excp_cnt = 0
	ls_style = ""
		
	ls_style_no	= dw_body.GetitemString(i, "style_no")	
	ls_sale_type = dw_body.GetitemString(i, "sale_type")	
	ll_sale_amt = dw_body.GetitemDecimal(i, "sale_amt")		
	ls_season =  mid(ls_style_no,3,2)
	ls_style = 	mid(ls_style_no,1,8)
	
		select isnull(sum(a.excp_chk),0) excp_chk
		into :ll_excp_cnt
		from (
				select case when style <> '' then 1 else 0 end as excp_chk		
				from tb_56012_d_excp
				where style = :ls_style
						and excp_yn = 'Y') a;	

	if gs_brand = 'N' then
		//온앤온 정상만.
		if ls_dc_flag = "Y" and (ls_season="4W") and (ls_sale_type="11") and ll_excp_cnt = 0   then
			ll_chk_sale_amt = ll_chk_sale_amt + ll_sale_amt
		end if
	end if
next

/*
if ll_chk_sale_amt < 300000 then
	ls_dc_flag = "N"
end if
*/


IF ls_dc_flag = "Y" then
	
	for i=1 to ll_row_count
	
		ll_sale_amt = 0
		ls_style_no = ""
		ls_sale_type = ""
		ls_season = ""
		ll_excp_cnt = 0
		ls_style = ""
		
		ls_style_no	= dw_body.GetitemString(i, "style_no")	
		ls_sale_type = dw_body.GetitemString(i, "sale_type")	
		ll_sale_amt = dw_body.GetitemDecimal(i, "sale_amt")				
		ls_season =  mid(ls_style_no,3,2)
		ls_style = 	mid(ls_style_no,1,8)

		select isnull(sum(a.excp_chk),0) excp_chk
		into :ll_excp_cnt
		from (
				select case when style <> '' then 1 else 0 end as excp_chk		
				from tb_56012_d_excp
				where style = :ls_style
						and excp_yn = 'Y') a;	
				
		if gs_brand = 'N' then
			if (ls_season ="4W") and (ls_sale_type="11") and ll_excp_cnt = 0   then

				ls_jumin = dw_1.getitemstring(1,'jumin')
				if ls_jumin <> ''  then
					
					dw_1.Setitem(1, "goods_amt", 0) 
					dw_1.Setitem(1, "give_rate", 30) 
					
					dw_1.Setitem(1, "give_date", '20141107') 
					dw_1.Setitem(1, "coupon_no", 'N14230') 
					dw_1.Setitem(j, "give_rate", 30)						
					dw_1.AcceptText() 
					
					ld_goods_amt = dw_1.getitemdecimal(1,"goods_amt")	
					dw_body.Setitem(i, "coupon_no", "N14230")
					dw_body.Setitem(i, "give_rate", 30)
				else
					dw_body.Setitem(i, "coupon_no", "N14230")
					dw_body.Setitem(i, "give_rate", 30)
				end if
			end if
		end if		
	next
END IF


end subroutine

public function integer wf_yes_no (string as_title);/*=================================================================*/
/* 작 성 자 : 지우정보                                             */	
/* 내    용 : 수정 자료 저장여부 확인                              */
/*=================================================================*/

RETURN  MessageBox(as_title,'쿠폰을 사용하시겠습니까?', &
			          Question!, YesNo!)


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

public function boolean wf_member_set (string as_flag, string as_find);String  ls_user_name, ls_jumin, ls_card_no, ls_age_grp, ls_tel_no3, ls_secure_no
string  ls_s_user_name, ls_s_birthday, ls_s_tel_no3_4
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
		if len(as_find) <> 6 then 
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

dw_1.SetItem(1, "card_no",      Right(ls_card_no, 9))
dw_1.SetItem(1, "user_name",    ls_user_name)
dw_1.SetItem(1, "jumin",        ls_jumin)
dw_1.Setitem(1, "total_point",  ll_total_point)
dw_1.Setitem(1, "give_point",   ll_give_point)
dw_1.Setitem(1, "accept_point", ll_accept_point)
dw_1.Setitem(1, "tel_no3", 	  ls_tel_no3)
dw_1.Setitem(1, "secure_no", 	  right(ls_jumin,3))
dw_1.Setitem(1, "crm_grp", 	  ls_crm_grp)

/* 연령층 처리 */
IF Mid(ls_jumin,7,1) > '2' THEN	//2000년 이후 출생자.
	ll_year = Long(Left(is_yymmdd, 4)) - (Long(Mid(ls_jumin,1,2)) + 2000) + 1
ELSE
	ll_year = Long(Left(is_yymmdd, 4)) - (Long(Mid(ls_jumin,1,2)) + 1900) + 1
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

public function boolean wf_set_cosmetic (string as_set_style_chk);Long    ll_dc_rate     
Long    ll_curr_price,  ll_out_price
Long    ll_sale_price,  ll_collect_price , ll_row_count, ll_sale_qty, ll_get_row
String  ls_shop_type,   ls_sale_type = space(2), ls_plan_yn, ls_shop_cd
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
	ls_shop_type = dw_cosmetic.getitemstring(j, "shop_type")
	ld_sale_price_c = dw_cosmetic.getitemnumber(j, "Sale_Price")
	ld_tag_price_c = dw_cosmetic.getitemnumber(j, "tag_Price")

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
		IF gf_out_marjin_color (ls_date,    gs_shop_cd,     ls_shop_type , ls_style, ls_color,& 
								ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
			RETURN False 
		END IF
	
		// 판매 마진율 체크 닷컴이 아닐때. 	
		IF gf_sale_marjin_color (ls_date,    gs_shop_cd,      ls_shop_type, ls_style, ls_color, & 
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
	dw_body.SetItem(i, "sale_type",		ls_sale_type)

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

public subroutine wf_amt_set2 ();/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_sale_price, ll_out_price, ll_collect_price, ll_row_count,ll_foundrow
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect  , ll_dc_amt, ll_sale_price2, ll_sale_qty,ll_sale_price3, ll_min_sale_price ,ll_sale_collect1
long ll_find, ll_qty, ll_cnt
long sale_price[]
int i, j, k
String ls_coupon_no, ls_sale_type, ls_item, ls_style_no, ls_coupon_yn, ls_style, ls_yymmdd, ls_event_id
Decimal ldc_marjin,ld_dc_rate, ll_dc_rate 

ls_coupon_no = dw_11.getitemstring(1,"coupon_no")
ls_event_id  = dw_11.getitemstring(1,"event_id")
ll_dc_amt    = dw_11.getitemNumber(1,"dc_amt")

if ls_event_id = 'GC0901' then 
	if not (GS_shop_cd = 'OG0034' or GS_shop_cd = 'OG0003' or GS_shop_cd = 'OG0038' or GS_shop_cd = 'OG0046' or GS_shop_cd = 'OG0048' or GS_shop_cd = 'OG0010' or GS_shop_cd = 'OG0008' or GS_shop_cd = 'OG0106') then
		messagebox("알림!", "선택한 이벤트에 해당되는 매장이 아닙니다 !!!")
		return
	end if	
end if



if ls_event_id = 'TM1112' then 
	if not (GS_shop_cd = 'BB1807' or GS_shop_cd = 'BB1888') then
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

if  ll_dc_amt > 0  and isnull(ls_coupon_no) <> true and len(ls_coupon_no) = 6 and ll_cnt > 0 and ls_coupon_no > "00000" then	  	    		
	   FOR i=1 TO ll_row_count
			ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))				
			ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
			ls_style_no   = dw_body.Getitemstring(i, "style_no")
			ls_item       = right(left(ls_style_no,2),1)
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
											dw_11.setitem(1,"coupon_no","")		
											dw_11.setitem(1,"dc_amt",0)		
											wf_amt_set(i, ll_sale_qty)
									END CHOOSE	
									
								end if					
							END IF
					 NEXT

				IF ls_coupon_yn = 'y' then
//					messagebox('쿠폰사용 끝', ls_coupon_no)		
					dw_11.visible = false
					return
				END IF								

 else
	messagebox('경고', "쿠폰번호를 확인하세요!")
   return
 end if
	
	

		
		
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
	if (mid(ls_style_no,1,1) <> 'L') and is_coupon_gubn <> '03'  then
		if (ld_tag_price = ld_sale_price and mid(ls_sale_type,1,1) = '1') or (mid(ls_sale_type,1,1) = '1' and  ld_dc_rate <= 20 )   then
			
			if ld_dc_rate < 20 and is_coupon_gubn <> '03' and mid(ls_style_no,1,1) <> 'N' then
				ld_dc_rate = ld_dc_rate + 5	
			elseif ld_dc_rate < 10 and is_coupon_gubn <> '03' and mid(ls_style_no,1,1) = 'N' then
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
		elseif gs_brand = 'N' and is_yymmdd >= '20161021' and is_yymmdd <= '20161025'   then			
			ld_dc_rate = ld_dc_rate + 5	
			ld_sale_price = ld_curr_price * ((100 - ld_dc_rate)/100)
			
			dw_body.SetItem(al_row, "dc_rate", ld_dc_rate)
			dw_body.SetItem(al_row, "sale_price", ld_sale_price)		
			dw_body.SetItem(al_row, "mem_dc_yn", "Y")
			
			dw_1.SetItem(al_row, "sale_amt", ld_tot_real_amt)			
		end if
	end if

		
end subroutine

public subroutine wk (long al_row, long al_sale_qty, string as_style);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_sale_price, ll_out_price, ll_collect_price
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect1  , ll_sale_collect
Decimal ldc_marjin, ldc_dc_rate
string ls_year, ls_season, ls_sale_type, ls_style,ls_saup_gubn, ls_plan_yn
Long ll_sale_amt_chk
integer li_style_cnt, ldc_margin_cnt

ll_tag_price     = dw_body.GetitemDecimal(al_row, "tag_price") 
ll_curr_price    = dw_body.GetitemDecimal(al_row, "TAG_price") 
ll_out_price     = dw_body.GetitemNumber(al_row, "out_price") 
ll_collect_price = dw_body.GetitemNumber(al_row, "collect_price")
ls_year = dw_body.Getitemstring(al_row, "year")
ls_season = dw_body.Getitemstring(al_row, "season")

is_empno = dw_head.GetItemString(1, "empno")

	if IsNull(is_empno) or Trim(is_empno) = "" then
		MessageBox("알림!","사우행사 판매인 경우 사번을 입력 하셔야 할인이 적용됩니다!")
		dw_head.SetFocus()
		dw_head.SetColumn("empno")
		return 
	end if	
	
		select case when right(saup_gubn,1) <> "2" then "1" else "2" end
		into :ls_saup_gubn
		from VIEW_emp_sale
		where empno = :is_empno
		and saup_gubn not like '_2%'	;

		
			if IsNull(ls_saup_gubn) or Trim(ls_saup_gubn) = "" then
			MessageBox("알림!","유효한 사번이 아닙니다!")
			dw_head.SetFocus()
			dw_head.Setitem(1, "empno", "")			
			dw_head.SetColumn("empno")
			return
		end if		
	

//select count(style)
//into :li_style_cnt
//from tb_except_style_202007 (nolock)
//where style = :as_style;
//
//
//if li_style_cnt > 0 then
//	messagebox("알림!", "사우행사 대상 제품이 아닙니다!")
//	return
//end if	


select max(year), max(season), max(plan_yn)
into :ls_year, :ls_season, :ls_plan_yn
from vi_12020_1 (nolock)
where style = :as_style;

//messagebox("" , as_style)
//messagebox("" , ls_year)
//messagebox("" , ls_season)


if ls_year  = "2020" and (ls_season  = "X" or ls_season = "W") then
	ldc_dc_rate = 30
	if ls_plan_yn = "Y" then
		ls_sale_type = "3L"
	   ll_curr_price = ll_tag_price * (100 - ldc_dc_rate) / 100
		ll_out_price  = ll_curr_price	* (100 -ldc_marjin) / 100	
	else 	
		ls_sale_type = "1L"		
	end if		
		
elseif ls_year = "2021" and ls_season  = "X"  then
	ldc_dc_rate = 30
	//ls_sale_type = "1J"	

	if ls_plan_yn = "Y" then
		ls_sale_type = "3L"
	   ll_curr_price = ll_tag_price * (100 - ldc_dc_rate) / 100		
		ll_out_price  = ll_curr_price	* (100 -ldc_marjin) / 100	
	else 	
		ls_sale_type = "1L"		
	end if		
		
	
	
else 
	messagebox("알림!", "사우행사 대상 제품이 아닙니다!")
	return
end if	
	



	
select count(*)
into :ldc_margin_cnt
from tb_56010_m (nolock)
where shop_cd = :gs_shop_cd
and :is_yymmdd between start_ymd and end_ymd
and sale_type = :ls_sale_type
and dc_rate = :ldc_dc_rate;

//messagebox("", string(ldc_margin_cnt, "0000"))

if ldc_margin_cnt < 1 then
	messagebox("알림!", "사우행사 적용 기간이 아닙니다!")
	return
end if	
	
select marjin_rate
into :ldc_marjin
from tb_56010_m (nolock)
where shop_cd = :gs_shop_cd
and :is_yymmdd between start_ymd and end_ymd
and sale_type = :ls_sale_type
and dc_rate = :ldc_dc_rate;


ll_sale_price = ll_tag_price * (100 - ldc_dc_rate) / 100

dw_body.Setitem(al_row, "sale_price",  ll_sale_price)
dw_body.Setitem(al_row, "tag_amt",  ll_tag_price  * al_sale_qty)
dw_body.Setitem(al_row, "curr_amt", ll_curr_price * al_sale_qty)
dw_body.Setitem(al_row, "sale_amt", ll_sale_price * al_sale_qty)
dw_body.Setitem(al_row, "out_amt",  ll_out_price  * al_sale_qty) 
dw_body.Setitem(al_row, "sale_type",  ls_sale_type) 
dw_body.Setitem(al_row, "empty_3",  is_empno) 

if ls_sale_type = "3K" or ls_sale_type = "3J"  or ls_sale_type = "3L"  then
	dw_body.Setitem(al_row, "curr_price", ll_curr_price)		
	dw_body.Setitem(al_row, "dc_rate",  0) 
	
else
	dw_body.Setitem(al_row, "dc_rate",  ldc_dc_rate) 	
end if	
	
dw_body.Setitem(al_row, "sale_rate",  ldc_marjin) 

ll_goods_amt = dw_body.GetitemDecimal(al_row, "goods_amt") 

ll_sale_amt_chk = dw_body.GetitemDecimal(al_row, "sale_amt") 




 		   gf_marjin_price(gs_shop_cd, (ll_sale_price * al_sale_qty), ldc_marjin, ll_sale_collect1)
         //판매금액에 할인금액적용을 백화점과 대리점 별도로 계산된 내역 수정(요청:장나영차장 일자:20140702)
			if gs_shop_div = "G" then 
				ll_sale_collect = ll_sale_collect1 //- (ll_goods_amt * ldc_marjin / 100)
			else
				ll_sale_collect = ll_sale_collect1
			end if	
		
		
		dw_body.Setitem(al_row, "sale_collect", ll_sale_collect) 
		
		/* 세일 재매입 처리 */
//		gf_marjin_price(gs_shop_cd, (ll_sale_price * al_sale_qty), ldc_marjin, ll_sale_collect)  					
		ll_io_amt = (ll_out_price  * al_sale_qty) - ll_sale_collect
		dw_body.Setitem(al_row, "io_amt", ll_io_amt)
		dw_body.Setitem(al_row, "io_vat", ll_io_amt - Round(ll_io_amt / 1.1, 0))
		
		

end subroutine

public subroutine wf_amt_set_empno (long al_row, long al_sale_qty, string as_style);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_sale_price, ll_out_price, ll_collect_price
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect1  , ll_sale_collect
Decimal ldc_marjin, ldc_dc_rate
string ls_year, ls_season, ls_sale_type, ls_style,ls_saup_gubn, ls_plan_yn
Long ll_sale_amt_chk
integer li_style_cnt, ldc_margin_cnt

ll_tag_price     = dw_body.GetitemDecimal(al_row, "tag_price") 
ll_curr_price    = dw_body.GetitemDecimal(al_row, "TAG_price") 
ll_out_price     = dw_body.GetitemNumber(al_row, "out_price") 
ll_collect_price = dw_body.GetitemNumber(al_row, "collect_price")
ls_year = dw_body.Getitemstring(al_row, "year")
ls_season = dw_body.Getitemstring(al_row, "season")

is_empno = dw_head.GetItemString(1, "empno")

	if IsNull(is_empno) or Trim(is_empno) = "" then
		MessageBox("알림!","사우행사 판매인 경우 사번을 입력 하셔야 할인이 적용됩니다!")
		dw_head.SetFocus()
		dw_head.SetColumn("empno")
		return 
	end if	
	
		select case when right(saup_gubn,1) <> "2" then "1" else "2" end
		into :ls_saup_gubn
		from VIEW_emp_sale
		where empno = :is_empno
		and saup_gubn not like '_2%'	;

		
			if IsNull(ls_saup_gubn) or Trim(ls_saup_gubn) = "" then
			MessageBox("알림!","유효한 사번이 아닙니다!")
			dw_head.SetFocus()
			dw_head.Setitem(1, "empno", "")			
			dw_head.SetColumn("empno")
			return
		end if		
	

//select count(style)
//into :li_style_cnt
//from tb_except_style_202007 (nolock)
//where style = :as_style;
//
//
//if li_style_cnt > 0 then
//	messagebox("알림!", "사우행사 대상 제품이 아닙니다!")
//	return
//end if	


select max(year), max(season), max(plan_yn)
into :ls_year, :ls_season, :ls_plan_yn
from vi_12020_1 (nolock)
where style = :as_style;

//messagebox("" , as_style)
//messagebox("" , ls_year)
//messagebox("" , ls_season)


if ls_year  = "2020" and (ls_season  = "X" or ls_season = "W") then
	ldc_dc_rate = 30
	if ls_plan_yn = "Y" then
		ls_sale_type = "3L"
	   ll_curr_price = ll_tag_price * (100 - ldc_dc_rate) / 100
		ll_out_price  = ll_curr_price	* (100 -ldc_marjin) / 100	
	else 	
		ls_sale_type = "1L"		
	end if		
		
elseif ls_year = "2021" and ls_season  = "X"  then
	ldc_dc_rate = 30
	//ls_sale_type = "1J"	

	if ls_plan_yn = "Y" then
		ls_sale_type = "3L"
	   ll_curr_price = ll_tag_price * (100 - ldc_dc_rate) / 100		
		ll_out_price  = ll_curr_price	* (100 -ldc_marjin) / 100	
	else 	
		ls_sale_type = "1L"		
	end if		
		
	
	
else 
	messagebox("알림!", "사우행사 대상 제품이 아닙니다!")
	return
end if	
	



	
select count(*)
into :ldc_margin_cnt
from tb_56010_m (nolock)
where shop_cd = :gs_shop_cd
and :is_yymmdd between start_ymd and end_ymd
and sale_type = :ls_sale_type
and dc_rate = :ldc_dc_rate;

//messagebox("", string(ldc_margin_cnt, "0000"))

if ldc_margin_cnt < 1 then
	messagebox("알림!", "사우행사 적용 기간이 아닙니다!")
	return
end if	
	
select marjin_rate
into :ldc_marjin
from tb_56010_m (nolock)
where shop_cd = :gs_shop_cd
and :is_yymmdd between start_ymd and end_ymd
and sale_type = :ls_sale_type
and dc_rate = :ldc_dc_rate;


ll_sale_price = ll_tag_price * (100 - ldc_dc_rate) / 100

dw_body.Setitem(al_row, "sale_price",  ll_sale_price)
dw_body.Setitem(al_row, "tag_amt",  ll_tag_price  * al_sale_qty)
dw_body.Setitem(al_row, "curr_amt", ll_curr_price * al_sale_qty)
dw_body.Setitem(al_row, "sale_amt", ll_sale_price * al_sale_qty)
dw_body.Setitem(al_row, "out_amt",  ll_out_price  * al_sale_qty) 
dw_body.Setitem(al_row, "sale_type",  ls_sale_type) 
dw_body.Setitem(al_row, "empty_3",  is_empno) 

if ls_sale_type = "3K" or ls_sale_type = "3J"  or ls_sale_type = "3L"  then
	dw_body.Setitem(al_row, "curr_price", ll_curr_price)		
	dw_body.Setitem(al_row, "dc_rate",  0) 
	
else
	dw_body.Setitem(al_row, "dc_rate",  ldc_dc_rate) 	
end if	
	
dw_body.Setitem(al_row, "sale_rate",  ldc_marjin) 

ll_goods_amt = dw_body.GetitemDecimal(al_row, "goods_amt") 

ll_sale_amt_chk = dw_body.GetitemDecimal(al_row, "sale_amt") 




 		   gf_marjin_price(gs_shop_cd, (ll_sale_price * al_sale_qty), ldc_marjin, ll_sale_collect1)
         //판매금액에 할인금액적용을 백화점과 대리점 별도로 계산된 내역 수정(요청:장나영차장 일자:20140702)
			if gs_shop_div = "G" then 
				ll_sale_collect = ll_sale_collect1 //- (ll_goods_amt * ldc_marjin / 100)
			else
				ll_sale_collect = ll_sale_collect1
			end if	
		
		
		dw_body.Setitem(al_row, "sale_collect", ll_sale_collect) 
		
		/* 세일 재매입 처리 */
//		gf_marjin_price(gs_shop_cd, (ll_sale_price * al_sale_qty), ldc_marjin, ll_sale_collect)  					
		ll_io_amt = (ll_out_price  * al_sale_qty) - ll_sale_collect
		dw_body.Setitem(al_row, "io_amt", ll_io_amt)
		dw_body.Setitem(al_row, "io_vat", ll_io_amt - Round(ll_io_amt / 1.1, 0))
		
		

end subroutine

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

if upper(mid(ls_coupon_no,1,1)) <> upper(gs_brand) and mid(ls_coupon_no,1,1) <> 'T' then
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
		if len(ls_style_no)=13 then 
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
				if ll_dc_rate_org <= 30 and (left(ls_sale_type,1) = '1' or ls_sale_type = '20' or ls_sale_type = '21') then //(20131219 쿠폰사용가능기준)

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

			   if (mid(ls_style_chk,3,2) = '1A' or mid(ls_style_chk,3,2) = '1M') and ll_dc_rate_chk <= 20 then
				   dw_body.setitem(j,"give_rate", ll_t_rate) 
			    	dw_body.Setitem(j,"coupon_no", ls_coupon_no)
			   end if			
				
		elseif ls_coupon_no = 'I11110' then
			   if (mid(ls_style_chk,3,2) = '1W' or mid(ls_style_chk,3,2) = '1A') and ll_dc_rate_chk <= 10 then
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

public function boolean wf_goods_chk (long al_goods_amt, string as_coupon_date);Long 	  j, i, k, ll_accept_point, ll_remain_point, ll_total_point , ll_row_count,ll_goods_amt,ll_sale_price, ll_sale_price2,ll_sale_qty   ,ll_give_amt, ll_chk_sale_price
decimal ld_goods_amt, ld_mok, ld_qty, ld_coupon_amt, ld_check_amt,ld_tot_goods_amt , ld_dc_rate, ld_sale_amt
string  ls_jumin, ls_card_no, ls_sale_fg, ls_style_no, ls_item, ls_coupon_no, ls_coupon_yn, ls_sale_type, ls_yymmdd, ls_coupon_no1, ls_sale_type_chk
integer li_sale_qty, ll_YN, li_chk_cnt
string  ls_brand,ls_item_tmp,ls_item_tmp_chk, ls_give_date, ls_msg_yn = 'N', ls_year, ls_season
long    ll_remain_amt, ll_ok_coupon_amt, ll_tot_ok_coupon_amt



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


if trim(ls_coupon_no) <> "" and  UPPER(ls_coupon_no) <> 'FIRST1' AND UPPER(ls_coupon_no) <> 'SECOND' and left(UPPER(ls_coupon_no),1) <> 'T' THEN
	if mid(ls_coupon_no,1,1) <> gs_brand then
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
		ls_item_tmp_chk = right(left(ls_item_tmp,2),1)		
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
			ls_item       = right(left(ls_style_no,2),1)
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
					elseif (ls_coupon_no = 'N17003' and ls_sale_type > '40') or ( (ls_coupon_no = 'N17003' and ls_year >= '2017' and ls_season = 'A' and mid(ls_sale_type,1,1) = '3') ) then
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
		ls_item       = right(left(ls_style_no,2),1)
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

public function boolean wf_goods_chk2 (long al_goods_amt, string as_coupon_date);Long 	  j, i, k, ll_accept_point, ll_remain_point, ll_total_point , ll_row_count,ll_goods_amt,ll_sale_price, ll_sale_price2,ll_sale_qty   ,ll_give_amt
decimal ld_goods_amt, ld_mok, ld_qty, ld_coupon_amt, ld_check_amt,ld_tot_goods_amt , ld_dc_rate
string  ls_jumin, ls_card_no, ls_sale_fg, ls_style_no, ls_item, ls_coupon_no, ls_coupon_yn, ls_sale_type, ls_yymmdd, ls_coupon_no1
integer il_remain_amt, li_sale_qty, ll_YN
string  ls_brand, ls_give_date, ls_msg_yn = 'N', ls_event_id
long    ll_ok_coupon_amt, ll_tot_ok_coupon_amt, ll_dc_amt, ll_cnt



wf_goods_amt_clear()

ls_coupon_no = dw_11.getitemstring(1,"coupon_no")
ls_event_id  = dw_11.getitemstring(1,"event_id")
ll_dc_amt    = dw_11.getitemNumber(1,"dc_amt")

ll_row_count = dw_body.RowCount()

IF isnull(al_goods_amt) OR al_goods_amt = 0 THEN 
	 wf_goods_amt_clear()
	RETURN TRUE 
END IF


select isnull(give_amt,0)
into :ld_coupon_amt
from tb_71011_p (nolock)
where :is_yymmdd between give_date and use_ymd
and verify_no = :ls_coupon_no
and event_id  = :ls_event_id
and accept_flag = 'N';
	
IF isnull(ld_coupon_amt) THEN ld_coupon_amt = 0 

if  ld_coupon_amt > 0  and ll_cnt > 0  then	
		ll_YN=wf_yes_no(This.title)

		

	   FOR i=1 TO ll_row_count
			ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))				
			ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
			ls_style_no   = dw_body.Getitemstring(i, "style_no")
			ls_item       = right(left(ls_style_no,2),1)
			ls_sale_type  = dw_body.Getitemstring(i, "sale_type")
			ld_dc_rate    = dw_body.GetitemDecimal(i, "dc_rate") 
		
			
						
		    // 가장 최저가 상품에 구매할인권을 쓰게 처리 						 
				IF (ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ld_dc_rate < 31  and ls_sale_type < '22' and (isnull(as_coupon_date) or (ls_coupon_no = 'SECOND' or ls_coupon_no = 'FIRST1') ) ) or &  
				    (ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ls_sale_type < '22' and ls_coupon_no <> 'SECOND' and ls_coupon_no <> 'FIRST1' ) THEN  	
			
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
								ll_sale_price2 = ll_sale_price 
								ls_coupon_yn = 'y'		
								ll_ok_coupon_amt   = dw_body.GetitemDecimal(i, "ok_coupon_amt")
								dw_body.Setitem(i,"coupon_no", ls_coupon_no)
								dw_body.Setitem(i,"event_id", ls_event_id)								

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
					if	(as_coupon_date = '20080523' or as_coupon_date = '20080606') and ls_coupon_no <> 'SECOND' and ls_coupon_no <> 'FIRST1' then
					 					
								MessageBox("확인", " 정상/세일/기획/균일  제품에만 사용할수 있습니다.")  
								ls_coupon_yn = 'n'	
								ls_msg_yn = 'Y'
					else
						 if ld_dc_rate >= 31 or ls_sale_type >= '22' then						
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
		ls_item       = right(left(ls_style_no,2),1)
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

public function boolean wf_goods_chk5 (long al_goods_amt, string as_coupon_date);Long 	  j, i, k, ll_accept_point, ll_remain_point, ll_total_point , ll_row_count,ll_goods_amt,ll_sale_price, ll_sale_price2,ll_sale_qty   ,ll_give_amt
decimal ld_goods_amt, ld_mok, ld_qty, ld_coupon_amt, ld_check_amt,ld_tot_goods_amt , ld_dc_rate
string  ls_jumin, ls_card_no, ls_sale_fg, ls_style_no, ls_item, ls_coupon_no, ls_coupon_yn, ls_sale_type, ls_yymmdd, ls_coupon_no1
integer il_remain_amt, li_sale_qty, ll_YN
string  ls_brand, ls_give_date, ls_msg_yn = 'N', ls_event_id
long    ll_ok_coupon_amt, ll_tot_ok_coupon_amt, ll_dc_amt, ll_cnt



wf_goods_amt_clear()

ls_coupon_no = dw_11.getitemstring(1,"coupon_no")
ls_event_id  = dw_11.getitemstring(1,"event_id")
ll_dc_amt    = dw_11.getitemNumber(1,"dc_amt")

ll_row_count = dw_body.RowCount()

IF isnull(al_goods_amt) OR al_goods_amt = 0 THEN 
	 wf_goods_amt_clear()
	RETURN TRUE 
END IF


select isnull(give_amt,0)
into :ld_coupon_amt
from tb_71011_p (nolock)
where :is_yymmdd between give_date and use_ymd
and verify_no = :ls_coupon_no
and event_id  = :ls_event_id
and accept_flag = 'N';
	
IF isnull(ld_coupon_amt) THEN ld_coupon_amt = 0 

if  ld_coupon_amt > 0  and ll_cnt > 0  then	
		ll_YN=wf_yes_no(This.title)

		

	   FOR i=1 TO ll_row_count
			ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))				
			ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
			ls_style_no   = dw_body.Getitemstring(i, "style_no")
			ls_item       = right(left(ls_style_no,2),1)
			ls_sale_type  = dw_body.Getitemstring(i, "sale_type")
			ld_dc_rate    = dw_body.GetitemDecimal(i, "dc_rate") 
		
			
						
		    // 가장 최저가 상품에 구매할인권을 쓰게 처리 						 
				IF (ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ld_dc_rate < 31  and ls_sale_type < '22' and (isnull(as_coupon_date) or (ls_coupon_no = 'SECOND' or ls_coupon_no = 'FIRST1') ) ) or &  
				    (ll_sale_price > ld_coupon_amt  and ll_sale_qty  > 0 and ls_sale_type < '22' and ls_coupon_no <> 'SECOND' and ls_coupon_no <> 'FIRST1' ) THEN  	
			
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
								ll_sale_price2 = ll_sale_price 
								ls_coupon_yn = 'y'		
								ll_ok_coupon_amt   = dw_body.GetitemDecimal(i, "ok_coupon_amt")
								dw_body.Setitem(i,"coupon_no", ls_coupon_no)
								dw_body.Setitem(i,"event_id", ls_event_id)								

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
					if	(as_coupon_date = '20080523' or as_coupon_date = '20080606') and ls_coupon_no <> 'SECOND' and ls_coupon_no <> 'FIRST1' then
					 					
								MessageBox("확인", " 정상/세일/기획/균일  제품에만 사용할수 있습니다.")  
								ls_coupon_yn = 'n'	
								ls_msg_yn = 'Y'
					else
						 if ld_dc_rate >= 31 or ls_sale_type >= '22' then						
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
		ls_item       = right(left(ls_style_no,2),1)
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

public subroutine wf_goods_chk3 ();
decimal ll_tot_real_amt, ll_sale_amt, ll_chk_sale_amt
long i, ll_row_count
string ls_dc_flag, ls_coupon_no, ls_style_no, ls_sale_type, ls_season, ls_style_chk


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
	ls_season =  mid(ls_style_no,3,2)
/*
	//품목할인 구하기
	select style
	into :ls_style_chk
	from tb_54021_h with (nolock)
	where brand = 'I' 
			and year = '2014' 
			and (season = 'M' or season = 'A') 
			and item not in ('Z') ;
*/
/*
	if gs_brand = 'I' then
		//코인코즈는 품목할인까지 포함.
		if ls_dc_flag = "Y" and (ls_season="4M" or ls_season="4A") and (ls_sale_type="11" or ls_sale_type="14" or ls_sale_type="17" or ls_sale_type="21" or ls_sale_type = "22") then
			ll_chk_sale_amt = ll_chk_sale_amt + ll_sale_amt
		end if
	elseif gs_brand = 'N' then
		//온앤온은 품목할인제외 포함.
		if ls_dc_flag = "Y" and (ls_season="4A" or ls_season="4W") and (ls_sale_type="11" or ls_sale_type="14" or ls_sale_type="17" or ls_sale_type="21") then
			ll_chk_sale_amt = ll_chk_sale_amt + ll_sale_amt
		end if
	end if
*/	

	if gs_brand = 'N' then
//		if ls_dc_flag = "Y" and (ls_season="6M") and (ls_sale_type="11" or ls_sale_type="14" or ls_sale_type="17" or ls_sale_type = "18" or ls_sale_type="21" ) then
		if ls_dc_flag = "Y" and (ls_season="6A") and (ls_sale_type="11" or ls_sale_type="14" or ls_sale_type="17"  ) then
			ll_chk_sale_amt = ll_chk_sale_amt + ll_sale_amt
		elseif ls_dc_flag = "Y" and ls_season="6W" and ls_sale_type="11" then
			ll_chk_sale_amt = ll_chk_sale_amt + ll_sale_amt
		end if
	end if
next


if ll_chk_sale_amt < 300000 then
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
		ls_season =  mid(ls_style_no,3,2)
		
		if gs_brand = 'N' then
			// 6년도 가을 + 겨울
			/** 온앤온 롯데안산점
			기     간 : 2016년 10월 08일(토) ~ 10월 14일(금), 7일간 
			내     용 : 10월 매출활성화를 위해 이벤트 진행
							1) 2016년도 가을,겨울 정상상품 10만원 이상구매시 3만원 즉시할인 [기획,품목,부진 제외]
			**/
			if (ls_season ="6A") and (ls_sale_type="11" or ls_sale_type="14" or ls_sale_type="17" ) and ll_sale_amt > 30000 then
				dw_body.Setitem(i, "coupon_no", "N00007")  
				dw_body.Setitem(i, "goods_amt", 30000)			
				return
			elseif (ls_season ="6W") and (ls_sale_type="11" ) and ll_sale_amt > 30000 then
				dw_body.Setitem(i, "coupon_no", "N00007")  
				dw_body.Setitem(i, "goods_amt", 30000)	
				return
			end if
		end if
		
		if gs_brand = 'I' then
			// 봄+여름
			/** 코인코즈전매장(홈플서스상암 및 온라인제외)
			기     간 : 2015년 04월 17일(금) ~ 04월 19일(일), 3일간
			내     용 : 오프라인 매출 활성화를 위한 이벤트 진행
							1) 15년 봄 / 여름 정상 상품(품목할인 제외) 
                       20만원 구매고객 대상 3만원 즉시 할인 시행

			**/	 	
			if (ls_season ="5M") and (ls_sale_type="11" or ls_sale_type="14" or ls_sale_type="17" or ls_sale_type="18" or ls_sale_type="21") and ll_sale_amt > 100000 then
				dw_body.Setitem(i, "coupon_no", "N00007")  
				dw_body.Setitem(i, "goods_amt", 30000)			
				return			
			end if
		end if	
		
	next
	
END IF







end subroutine

public subroutine wf_goods_chk3_kakao ();
decimal ll_tot_real_amt, ll_sale_amt, ll_chk_sale_amt
long i, ll_row_count
string ls_dc_flag, ls_coupon_no, ls_style_no, ls_sale_type, ls_season, ls_style_chk


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
	ls_season =  mid(ls_style_no,3,2)


	if gs_brand = 'N' then
//		if ls_dc_flag = "Y" and (ls_season="6A") and (ls_sale_type="11" or ls_sale_type="14" or ls_sale_type="17"  ) then
			ll_chk_sale_amt = ll_chk_sale_amt + ll_sale_amt
//		elseif ls_dc_flag = "Y" and ls_season="6W" and ls_sale_type="11" then
//			ll_chk_sale_amt = ll_chk_sale_amt + ll_sale_amt
//		end if
	end if
next


if ll_chk_sale_amt < 300000 then
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
		ls_season =  mid(ls_style_no,3,2)
		
		if gs_brand = 'N' then
			// 6년도 가을 + 겨울
			/** 온앤온 롯데안산점
			기     간 : 2016년 10월 08일(토) ~ 10월 14일(금), 7일간 
			내     용 : 10월 매출활성화를 위해 이벤트 진행
							1) 2016년도 가을,겨울 정상상품 10만원 이상구매시 3만원 즉시할인 [기획,품목,부진 제외]
			**/
			if (ls_season ="1M") and ll_sale_amt > 30000 then // and (ls_sale_type="11" or ls_sale_type="14" or ls_sale_type="17" )
				dw_body.Setitem(i, "empty_3",  is_coupon_no) 
				dw_body.Setitem(i, "goods_amt", 30000)			
				return
//			elseif (ls_season ="6W") and (ls_sale_type="11" ) and ll_sale_amt > 30000 then
//				dw_body.Setitem(i, "coupon_no", "N00007")  
//				dw_body.Setitem(i, "goods_amt", 30000)	
//				return
			end if
		end if
	
		
	next
	
END IF







end subroutine

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

public function boolean wf_stock_chk (long al_row, string as_style_no);String ls_style, ls_chno, ls_color, ls_size , ls_find, ls_shop_type
Long   ll_stock_qty, ll_cnt_stop, ll_row_count, i, k, ll, ll_chk_qty, ll_stock_qty1

IF Len(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = dw_body.getitemstring(al_row, "style")
ls_chno  = dw_body.getitemstring(al_row, "chno")
ls_color = dw_body.getitemstring(al_row, "color")
ls_size  = dw_body.getitemstring(al_row, "size")
ls_shop_type  = dw_body.getitemstring(al_row, "shop_type")

if mid(as_style_no,1,1) = '8' then
	gs_brand = 'G'
	gs_shop_cd = gs_brand + gs_shop_div + mid(gs_shop_cd,3,4)
//else
//	gs_brand = mid(as_style_no,1,1)
//	gs_shop_cd = gs_brand + gs_shop_div + mid(gs_shop_cd,3,4)
end if

select dbo.sf_get_stockqty(:gs_shop_cd, :ls_shop_type, :ls_style, :ls_chno, :ls_color, :ls_size)
  into :ll_stock_qty
  from dual;

	
IF sqlca.sqlcode <> 0 THEN 
	MessageBox("SQL 오류", SQLCA.SQLERRTEXT) 
	RETURN FALSE 
end if


ll_row_count = dw_body.rowcount() 
ll = 0
ll_stock_qty1 = 0


for i = 1 to ll_row_count 
		
		ls_find = "style_no = '" + ls_style + ls_chno +  ls_color + ls_size + "'"
		
		k = dw_body.find(ls_find, i, i )		
	
		
		if k <> 0 then
		 ll = dw_body.getitemnumber(i, "sale_qty")
		else 
		 ll = 0	
		end if
		
		ll_stock_qty1 = ll_stock_qty1 + ll
		
next  


ll_chk_qty = ll_stock_qty - ll_stock_qty1 

//messagebox("", mid(ls_style,5,1))

if mid(gs_shop_cd,2,1) = "D" then 
	IF ll_chk_qty < 0 and mid(ls_style,5,1) <> "I" THEN 
	MessageBox("확인",  as_style_no +  "는 재고가" + string( ll_stock_qty) + "개로 판매등록 수량 " + string(ll_stock_qty1) + "개 보다 재고가 적은 품번 입니다!") 
	RETURN FALSE 
	END IF
else	
	IF ll_chk_qty < 0 and mid(ls_style,5,1) <> "I" THEN 
		MessageBox("확인", as_style_no +  "는 재고가" + string(ll_stock_qty) + "개로 판매등록 수량 " + string(ll_stock_qty1) + "개 보다 재고가 적은 품번 입니다!") 
		RETURN FALSE 
	END IF
end if
  


Return True

end function

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

public function integer wf_set_margin (integer al_row, integer al_give_rate);String ls_style_no, ls_yes, ls_sale_type, ls_plan_yn, ls_year, ls_season, ls_sojae, ls_card_no
Long   ll_curr_price, ll_sale_price, ll_collect_price, ld_goods_amt, ll_dc_rate, ll_sale_rate,ll_dc_rate_org


	ls_style_no   = dw_body.GetitemString(al_row, "style_no")
	ls_plan_yn = mid(ls_style_no,5,1)
	
	
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
where brand = :as_brand // GS_BRAND 
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
and season IN ( :as_season_t, :AS_SEASON_F)
and shop_cd = :gs_shop_cd;

//제외된 매장의 마감일자를 변경해줌.. 마감시즌 전단계 예외 처리 하는 경우 발생 전시즌까지 검색

if ll_cnt = 1 then	
	select	MAX(yymmdd)
	into :as_close_ymd_t
	from tb_56072_d
	where brand = :as_brand
	and year = :as_year_t
	and season  IN ( :as_season_t, :AS_SEASON_F)
	and shop_cd = :gs_shop_cd;
end if

return true
end function

public function boolean wf_style_chk_back_member (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_size, ls_shop_type, ls_given_fg, ls_given_ymd, ls_sale_type, ls_sale_type_o
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn , LS_RTRN_YMD , ls_work_gubn, ls_date
Long   ll_tag_price, ll_ord_qty, ll_ord_qty_chn 

dw_head.accepttext()
ls_date = string(dw_head.GetItemDate(1,'yymmdd'))
ls_date = mid(ls_date,1,4) + mid(ls_date,6,2) + mid(ls_date,9,2)

IF Len(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = Mid(as_style_no, 1, 8)
ls_chno  = Mid(as_style_no, 9, 1)
ls_color = Mid(as_style_no, 10, 2)
ls_size  = Mid(as_style_no, 12, 2)

if mid(gs_shop_cd,3,4) >= "1900" and mid(gs_shop_cd,3,4) <= "1913" then 
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
		and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end;

elseif  gs_brand = "B" or gs_brand = 'D' or gs_brand = 'K' or gs_brand = 'U' then
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
		and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end;		

elseif gs_brand = "O" or gs_brand = 'Y' then
	if ls_date <= is_close_ymd_t then
		//마감일자 전의 판매
		//정상+행사
		if is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'N' then
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
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_f + :is_season_s_f ) 
							or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_f + :is_season_s_f  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );
		//정상+행사+기획
		elseif is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'Y' then
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
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_f + :is_season_s_f ) 
//							or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_f + :is_season_s_f  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
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
		if is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'N' then
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
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_t + :is_season_s_t ) 
						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_t + :is_season_s_t  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );			

		//정상+행사+기획
		elseif is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'Y' then
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
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_t + :is_season_s_t ) 
//						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_t + :is_season_s_t  and plan_yn = 'Y' )   
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
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

///// 20210928

elseif gs_brand = "N"  then
	if ls_date <= is_close_ymd_t then
		//마감일자 전의 판매
		//정상+행사
		if is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'N' then
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
//			 where  brand_grp = :gs_brand_grp // brand LIKE '[NJ]%' // :gs_brand 
			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_f + :is_season_s_f ) 
							or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_f + :is_season_s_f  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );
		//정상+행사+기획
		elseif is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'Y' then
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
//			 where  brand_grp = :gs_brand_grp // brand  LIKE '[NJ]%'
			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_f + :is_season_s_f ) 
//							or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_f + :is_season_s_f  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
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
		if is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'N' then
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
//			 where  brand_grp = :gs_brand_grp // brand  LIKE '[NJ]%'
			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_t + :is_season_s_t ) 
						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_t + :is_season_s_t  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );			

		//정상+행사+기획
		elseif is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'Y' then
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
//			 where  brand_grp = :gs_brand_grp // brand  LIKE '[NJ]%'
			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_t + :is_season_s_t ) 
//						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_t + :is_season_s_t  and plan_yn = 'Y' )   
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
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



/////
else 	
		Select brand,     year,     season,     
			 sojae,     item,     tag_price,     plan_yn   
	  into :ls_brand, :ls_year, :ls_season, 
			 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
	  from vi_12024_1 with (nolock)
//	 where brand = :gs_brand 
	 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp	 
		and style = :ls_style 
		and chno  = :ls_chno
		and color = :ls_color 
		and size  = :ls_size
		and sojae  <> 'C' 	
		and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
      and 
		
	 		 ( (  
		  			( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20094' ) 
//           or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20094'  and plan_yn = 'Y' )   
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
		
	
end if

IF SQLCA.SQLCODE <> 0 THEN 
	messagebox("확인","시즌마감되어 반품등록이 불가능합니다! 관리팀에 연락 바랍니다!")
	Return False 
END IF


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

ls_sale_type_o = dw_member_sale.getitemstring(al_row, "sale_type")

if left(as_style_no,1) = "N"  and (left(gs_shop_cd, 2) <> "NO" or left(gs_shop_cd, 2) <> "JO" )  then
	
//					Select sale_type
//					into :ls_sale_type
//					From tb_56012_d with (nolock)
//					Where style      = :ls_style 
//					  and start_ymd <= :is_yymmdd
//					  and end_ymd   >= :is_yymmdd
//					  and shop_type <> '9'
//					  and shop_cd    = :gs_shop_cd ;
//					
//					if IsNull(ls_sale_type) or Trim(ls_sale_type) = "" then
//						ls_shop_type = "11"
//					end if	
//					
//					if ls_shop_type < "40"  then 
//						messagebox("경고!", "정상 판매반품등록이 불가능한 제품입니다!")
//						return false
//					end if	
					
					SELECT  ISNULL(RTRN_YMD, '99999999')
					INTO :LS_RTRN_YMD
					FROM tb_54020_h
					WHERE STYLE = :LS_STYLE
					AND   DEP_FG = 'Y';
					
					if IsNull(LS_RTRN_YMD) or Trim(LS_RTRN_YMD) = "" then
						LS_RTRN_YMD = "99999999"
					end if
					
					
					if ls_sale_type_o < "40"  then 
						IF LS_RTRN_YMD <= IS_YYMMDD THEN 
							messagebox("경고!", "부진적용일이후 정상 판매,반품등록은 불가능합니다! 관리팀에 연락 바랍니다!")
							return false
						END IF	
					end if	
					
					SELECT  ISNULL(RTRN_YMD, '99999999')
					INTO :LS_RTRN_YMD
					FROM tb_54021_h
					WHERE STYLE = :LS_STYLE
					AND   DEP_FG = 'Y';
					
					if IsNull(LS_RTRN_YMD) or Trim(LS_RTRN_YMD) = "" then
						LS_RTRN_YMD = "99999999"
					end if

					
					if ls_sale_type_o < "20"  then 
						IF LS_RTRN_YMD <= IS_YYMMDD THEN 
							messagebox("경고!", "품목할인적용일이후 정상판매로의 반품등록은 불가능합니다! 관리팀에 연락 바랍니다!")
							return false
						END IF	
					end if						
					
					
end if					
					
					
select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
into  :ls_given_fg, :ls_given_ymd
from tb_12020_m with (nolock)
where style = :ls_style;


if ls_given_fg = "Y" then 
	messagebox("품번체크", ls_given_ymd + "일자로 사은품 전환된 제품입니다!")
	return false
end if 	


select work_gubn, given_ymd
into :ls_work_gubn, :ls_given_ymd
from beaucre.dbo.tb_56040_m with (nolock)
where style like :ls_style + '%'
and  shop_brand like '%' + :gs_brand + '%'
and   gubn = 'C';

IF (ls_work_gubn = "T" or  ls_work_gubn = "A") and ls_given_ymd <= is_yymmdd THEN 
	messagebox("품번검색", ls_given_ymd + "일자로 판매/판매반품 불가로 전환된 제품입니다!")					
	return false 	
END IF 		


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

public subroutine wf_amt_set_row ();/* 회원 즉시할인 +5% 적용 금액 처리 */
long i , ll_row_count
String ls_mem_dc_yn
String ls_sale_type, ls_style_no, ls_date
Decimal ld_tag_price, ld_curr_price, ld_sale_price, ld_dc_rate,ld_tot_real_amt

ll_row_count = dw_body.rowcount()
ls_date = string(dw_head.GetItemDate(1,'yymmdd'))
ls_date = mid(ls_date,1,4) + mid(ls_date,6,2) + mid(ls_date,9,2)

FOR i=1 TO ll_row_count	

	ld_tag_price     = dw_body.GetitemDecimal(i, "tag_price") 
	ld_tot_real_amt    = dw_body.GetitemDecimal(i, "tot_real_amt") 
	ld_curr_price    = dw_body.GetitemDecimal(i, "curr_price") 
	ld_sale_price    = dw_body.GetitemDecimal(i, "sale_price") 	
	ld_dc_rate       = dw_body.GetitemDecimal(i, "dc_rate") 
	ls_sale_type     = dw_body.GetitemString(i, "sale_type") 
	ls_style_no     = dw_body.GetitemString(i, "style_no") 		


	// 5% 즉시할인 조이그라이슨 제외 모발일쿠폰 ctrip사용 제외.
	if (mid(ls_style_no,1,1) <> 'L') and is_coupon_gubn <> '03'  then
			// 5% 즉시할인 ND1900,OD1900,ID1900 제외 (2015.10.30)
		if (gs_shop_cd <> 'ND1900' and gs_shop_cd <> 'OD1900' and gs_shop_cd <> 'ID1900')   then
			if (mid(ls_sale_type,1,1) = '1' and  ld_dc_rate <= 10 )  and left(gs_shop_cd,1)  <> "N"  then
		
				ld_dc_rate = ld_dc_rate + 5	
				ld_sale_price = ld_curr_price * ((100 - ld_dc_rate)/100)
				dw_body.SetItem(i, "dc_rate", ld_dc_rate)
				dw_body.SetItem(i, "sale_price", ld_sale_price)		
				dw_body.SetItem(i, "mem_dc_yn", "Y")
				
			elseif  (mid(ls_sale_type,1,1) = '1' and  ld_dc_rate < 10 ) and left(gs_shop_cd,1) = "N"  then
		
				ld_dc_rate = ld_dc_rate + 5	
				ld_sale_price = ld_curr_price * ((100 - ld_dc_rate)/100)
				dw_body.SetItem(i, "dc_rate", ld_dc_rate)
				dw_body.SetItem(i, "sale_price", ld_sale_price)		
				dw_body.SetItem(i, "mem_dc_yn", "Y")
				
		
			end if
		end if
		
		
	end if
	
//   if gs_brand = 'N' and ls_date >= '20160425' and ls_date <= '20160427'  and ( mid(ls_style_no,1,8) = 'NK6MP622' or mid(ls_style_no,1,8) = 'NW6MB236' or mid(ls_style_no,1,8) = 'NW6MB817' or mid(ls_style_no,1,8) ='NW6MJ258' or mid(ls_style_no,1,8) ='NW6ML149') then
//	if gs_brand = 'N' and ls_date >= '20161021' and ls_date <= '20161025'  and ( mid(ls_style_no,1,8) = 'NW6WH499' or mid(ls_style_no,1,8) = 'NW6WH204' or mid(ls_style_no,1,8) = 'NW6WH574' or mid(ls_style_no,1,8) ='NW6WH117' or mid(ls_style_no,1,8) ='NW6WH107') then			
//				ld_dc_rate = ld_dc_rate + 5	
//				ld_sale_price = ld_curr_price * ((100 - ld_dc_rate)/100)
//				dw_body.SetItem(i, "dc_rate", ld_dc_rate)
//				dw_body.SetItem(i, "sale_price", ld_sale_price)		
//				dw_body.SetItem(i, "mem_dc_yn", "Y")
//	end if
	
NEXT


dw_1.SetItem(1, "sale_amt", ld_tot_real_amt)



end subroutine

public subroutine wf_amt_set_kakao_style (long al_row, long al_sale_qty, string as_style);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_sale_price, ll_out_price, ll_collect_price
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect1  , ll_sale_collect, ll_sale_price_org
Decimal ldc_marjin, ldc_dc_rate, ldc_dc_rate_org, ldc_marjin_org, ldc_dc_rate_cal, ldc_dc_rate_cal_chk,ldc_plus_rate,ldc_dc_rate_org1
string ls_year, ls_season, ls_sale_type, ls_style,ls_saup_gubn, ls_plan_yn, ls_apply_type, ls_item
Long ll_sale_amt_chk,ll_kakao_chk,ll_used_cnt, ll_sale_chk, ll_apply_sale_price
integer li_style_cnt, ldc_margin_cnt

ll_tag_price     = dw_body.GetitemDecimal(al_row, "tag_price") 
ll_curr_price    = dw_body.GetitemDecimal(al_row, "curr_price") 
ll_out_price     = dw_body.GetitemNumber(al_row, "out_price") 
ll_collect_price = dw_body.GetitemNumber(al_row, "collect_price")
ll_sale_price_org = dw_body.GetitemNumber(al_row, "sale_price_org")
ldc_dc_rate_org = dw_body.GetitemNumber(al_row, "dc_rate_org")
ldc_marjin_org = dw_body.GetitemNumber(al_row, "sale_rate")
ls_sale_type = dw_body.Getitemstring(al_row, "sale_type")
ls_year = dw_body.Getitemstring(al_row, "year")
ls_season = dw_body.Getitemstring(al_row, "season")
ls_item = dw_body.Getitemstring(al_row, "item")
is_coupon_no = dw_head.GetItemString(1, "coupon_no")



if IsNull(is_coupon_no) or Trim(is_coupon_no) = "" then
	MessageBox("알림!","플러스친쿠 쿠폰인 경우 정확한 쿠폰번호를 입력 하셔야 할인이 적용됩니다!")
	dw_head.SetFocus()
	dw_head.SetColumn("coupon_no")
	return 
end if	
	
//추가 할인율	
ldc_plus_rate = 15



//대상품번 확인
select count(*)
into :li_style_cnt
from tb_12020_m (nolock)
where style = :as_style
and style in (	'MK4MDC13','MK4MPC04','MW4MBC01','MW4MBC06',
					'MW4MEC03','MW4MJC08','MW4MLC02','MW4MOC05',
					'MW4MOC07','MW4MOC15','MW4MOC16','MW4MOC18',
					'MW4XOC10','MW4MSC09','MW4XSC14');


	
select a.style, a.sale_price
into :ls_style, :ll_apply_sale_price
from (	
		select 	'MK4MDC13' as style, 	259000	as sale_price
		union
		select 	'MK4MPC04' as style, 	139000	as sale_price
		union
		select 	'MW4MBC01' as style, 	219000	as sale_price
		union
		select 	'MW4MBC06' as style, 	199000	as sale_price
		union
		select 	'MW4MEC03' as style, 	129000	as sale_price
		union
		select 	'MW4MJC08' as style, 	329000	as sale_price
		union
		select 	'MW4MLC02' as style, 	219000	as sale_price
		union
		select 	'MW4MOC05' as style, 	279000	as sale_price
		union
		select 	'MW4MOC07' as style, 	279000	as sale_price
		union
		select 	'MW4MOC15' as style, 	279000	as sale_price
		union
		select 	'MW4MOC16' as style, 	379000	as sale_price
		union
		select 	'MW4MOC18' as style, 	379000	as sale_price
		union
		select 	'MW4XOC10' as style, 	259000	as sale_price
		union
		select 	'MW4MSC09' as style, 	299000	as sale_price
		union
		select 	'MW4XSC14' as style, 	259000   as sale_price ) a
where a.style = :as_style;
	
	
if li_style_cnt < 1  then
	messagebox("알림!", "쿠폰 적용 대상 제품이 아닙니다!")
	return
else
	messagebox("알림!" , "적용대상 품번에만 추가 15% 할인이 적용됩니다!")		
end if	



// 정상 할인 제품에 해당하는 판매형태 확인
select count(*)
into :ll_sale_chk
from (select b.INTER_CD as sale_type
		from tb_91010_m a (nolock), tb_91011_c b (nolock)
		where   a.inter_grp = b.inter_grp
		and     a.inter_grp   = '011'
		and     ( (b.inter_cd like  '1%' and b.inter_cd not in ('1k', '1F'))
			 or 
			  b.inter_cd in ('21','31','22','23') ) ) a
where a.sale_type = :ls_sale_type	;	
	

if ll_sale_chk < 1 then
	messagebox("알림!", "해당품번은 쿠폰 적용 가능한 판매형태의 제품이  아닙니다!")
	return
end if	



select max(year), max(season), max(plan_yn)
into :ls_year, :ls_season, :ls_plan_yn
from vi_12020_1 (nolock)
where style = :as_style;


	
select count(*)
into :ldc_margin_cnt
from tb_56010_m (nolock)
where shop_cd = :gs_shop_cd
and :is_yymmdd between start_ymd and end_ymd
and sale_type = :ls_sale_type
and dc_rate =  :ldc_dc_rate_org ;


if ldc_margin_cnt < 1 then
	messagebox("알림!", "행사 적용 기간이 아닙니다! 쿠폰사용이 불가 합니다.")
	return
end if	
	
	
	
select marjin_rate
into :ldc_marjin
from tb_56010_m (nolock)
where shop_cd = :gs_shop_cd
and :is_yymmdd between start_ymd and end_ymd
and sale_type = :ls_sale_type
and dc_rate =  :ldc_dc_rate_org ;


if  is_yymmdd >= "20240111"  and ldc_dc_rate_org = 0 and ( ls_sale_type = "12" or ls_sale_type = "22" or ls_sale_type = "23" ) then		
	
	
	
	ldc_dc_rate_org1 = (1 - (ll_sale_price_org /ll_tag_price)) * 100	
	
	ll_sale_price = ll_tag_price  * (100 - ldc_dc_rate_org1) / 100
	ll_sale_price = ll_sale_price * (100 - ldc_plus_rate) / 100
	
//	ll_sale_price = ll_apply_sale_price
	
else 
	ll_sale_price = ll_tag_price  * (100 - ldc_dc_rate_org) / 100
	ll_sale_price = ll_sale_price * (100 - ldc_plus_rate) / 100
	
//		ll_sale_price = ll_apply_sale_price
end if	
						

dw_body.Setitem(al_row, "sale_price",  ll_sale_price)
dw_body.Setitem(al_row, "tag_amt",  ll_tag_price  * al_sale_qty)
dw_body.Setitem(al_row, "curr_amt", ll_curr_price * al_sale_qty)
dw_body.Setitem(al_row, "sale_amt", ll_sale_price * al_sale_qty)
dw_body.Setitem(al_row, "out_amt",  ll_out_price  * al_sale_qty) 
dw_body.Setitem(al_row, "sale_type",  ls_sale_type) 
dw_body.Setitem(al_row, "empty_3",  is_coupon_no) 

ldc_dc_rate = (1 - ll_sale_price / ll_tag_price) * 100

if mid(ls_sale_type,1,1) = "3" then
	dw_body.Setitem(al_row, "curr_price", ll_curr_price)		
	dw_body.Setitem(al_row, "dc_rate",  0) 
	
else
	dw_body.Setitem(al_row, "dc_rate",  ldc_dc_rate) 	
end if	
	
dw_body.Setitem(al_row, "sale_rate",  ldc_marjin) 

ll_goods_amt = dw_body.GetitemDecimal(al_row, "goods_amt") 

gf_marjin_price(gs_shop_cd, (ll_sale_price * al_sale_qty), ldc_marjin, ll_sale_collect1)

ll_sale_collect = ll_sale_collect1 //- (ll_goods_amt * ldc_marjin / 100)
dw_body.Setitem(al_row, "sale_collect", ll_sale_collect) 
		
		/* 세일 재매입 처리 */
//		gf_marjin_price(gs_shop_cd, (ll_sale_price * al_sale_qty), ldc_marjin, ll_sale_collect)  					
		ll_io_amt = (ll_out_price  * al_sale_qty) - ll_sale_collect
		dw_body.Setitem(al_row, "io_amt", ll_io_amt)
		dw_body.Setitem(al_row, "io_vat", ll_io_amt - Round(ll_io_amt / 1.1, 0))
		
		

end subroutine

public function boolean wf_style_set2 (long al_row, string as_style, string as_yymmdd, long al_qty, string as_dotcom);Long    ll_dc_rate     
Long    ll_curr_price,  ll_out_price
Long    ll_sale_price,  ll_collect_price 
String  ls_shop_type,   ls_sale_type = space(2), ls_year, ls_season, ls_sojae,	ls_plan_yn, ls_shop_cd, ls_shop_div, ls_dot_com, ls_color
decimal ldc_out_marjin, ldc_sale_marjin, ll_sale_rate

dw_body.accepttext()

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
	ls_dot_com = as_dotcom
end if	

//messagebox("style_set",ls_dot_com)

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
				where b.shoP_div in ('B','G','O')
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
	
		IF gf_out_marjin_color (as_yymmdd,    ls_shop_cd,     ls_shop_type , as_style, ls_color, & 
							ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
		is_mj_bit = 'N'
		RETURN False 
		END IF
	
		
		IF gf_sale_marjin_color (as_yymmdd,    ls_shop_cd,      ls_shop_type, as_style, ls_color, & 
								 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 
			is_mj_bit = 'N'
			RETURN False
		END IF


      // 닷컴으로 판매시에는 G코드가 아닌 H로 수정해서 입력
		//ll_curr_price = ll_sale_price
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

public subroutine wf_amt_set_kakao_1 (long al_row, long al_sale_qty, string as_style);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_sale_price, ll_out_price, ll_collect_price,ll_row_count
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect1  , ll_sale_collect, ll_sale_price_org
Decimal ldc_marjin, ldc_dc_rate, ldc_dc_rate_org, ldc_marjin_org, ldc_dc_rate_cal, ldc_dc_rate_cal_chk, ldc_plus_rate,ldc_dc_rate_org1
string ls_year, ls_season, ls_sale_type, ls_style,ls_saup_gubn, ls_plan_yn, ls_apply_type, LS_CHK_COUPON
Long ll_sale_amt_chk,ll_kakao_chk,ll_used_cnt, ll_sale_chk, ll_sum_chk_amt, ll_limit_amt, ll_sale_qty,ll_year_chk
integer li_style_cnt, ldc_margin_cnt, i, il_cnt_except


if is_kakao_apply = "E"  then  // 10%
//	ll_limit_amt = 300000
	
	
	// 300000  	// 20240118 영업부 이규민		
					// 202309 성희명 변경기안
					// 202305 김건형 30 -> 20  
	//	400000   // 202304 박태선 변경기안

	ll_limit_amt = 300000 
	ldc_plus_rate = 10
	
	
elseif  is_kakao_apply = "F"  then // 15%
	
	//ll_limit_amt = 500000  // 202304 박태선 변경기안
								 	 // 202309 성희명 변경기안
 								    // 202305 김건형 30 -> 40 202304 박태선 변경기안 40->30  / 20231106 40>= 이준민
	
		ll_limit_amt = 400000  
		ldc_plus_rate = 15
		
elseif  is_kakao_apply = "G"  then  // 10%
	
	// 400000  202304 박태선 변경기안
	// 202305 김건형 30 -> 20  400000  202304 박태선 변경기안

	ll_limit_amt = 200000 
	ldc_plus_rate = 10		
	
elseif  is_kakao_apply = "H"  then //20%
	
	ll_limit_amt = 1000000
	ldc_plus_rate = 20		
		
elseif  is_kakao_apply = "I"  then // 15%

	ll_limit_amt =  10000			// 300000 이규호 신세계광주 팝업매장 15
							 	         // 이규호 신세계백화점 센텀시티점 15
							 	         // 이규호 롯데인천점 팝업 15
							 	         // 이준민 현대백화점 울산 팝업 10											 
	ldc_plus_rate = 10			
	
elseif  is_kakao_apply = "J"  then // 10%	

	ll_limit_amt = 10000  // 202401 팝업용 임시 ,20241025 신
								  // 20241108 롯데잠실 팝업용
								  // 20241129  신세계백화점 강남점 팝업	wjdrl
	ldc_plus_rate = 15			

elseif  is_kakao_apply = "K"  then // 10%	

	ll_limit_amt = 400000  // 20241025 신
	ldc_plus_rate = 10			
	
	
else 
	return
end if

dw_body.AcceptText()

ll_row_count = dw_body.RowCount()

FOR i=1 TO ll_row_count // 대상에 해당되는 합계 금액 확인
		ls_sale_type = dw_body.Getitemstring(i, "sale_type")
		ll_sale_qty  =  dw_body.GetitemDecimal(i, "sale_qty") 		
		ls_year = dw_body.Getitemstring(i, "year")
		ls_season = dw_body.Getitemstring(i, "season")		
		
		if is_yymmdd >= "20240724" and is_yymmdd <= "20240731"  and gs_shop_cd = "NG1210"  and is_kakao_apply = "G" then 
				select count(*)
								into :ll_sale_chk
								from (select b.INTER_CD as sale_type
										from tb_91010_m a (nolock), tb_91011_c b (nolock)
										where   a.inter_grp = b.inter_grp
										and     a.inter_grp   = '011'
										and     ( (b.inter_cd like  '1%' and b.inter_cd not in ('1k', '1F'))
											 or 
											  b.inter_cd in ('21','31') ) ) a
								where a.sale_type = :ls_sale_type	;								

		elseif is_yymmdd >= "20240801" and is_yymmdd <= "20240831"  and gs_shop_cd = "NG1137"  and is_kakao_apply = "I" then 
				select count(*)
								into :ll_sale_chk
								from (select b.INTER_CD as sale_type
										from tb_91010_m a (nolock), tb_91011_c b (nolock)
										where   a.inter_grp = b.inter_grp
										and     a.inter_grp   = '011'
										and     ( (b.inter_cd like  '1%' and b.inter_cd not in ('1k', '1F'))
											 or 
											  b.inter_cd in ('21','31') ) ) a
								where a.sale_type = :ls_sale_type	;					
								
	elseif is_yymmdd >= "20241025"  and is_kakao_apply = "K" then 

			SELECT COUNT(*)
			INTO :LL_SALE_CHK
			FROM TB_56010_M X (NOLOCK)
			WHERE SHOP_CD = :GS_SHOP_CD
			AND :IS_YYMMDD BETWEEN START_YMD AND END_YMD
			AND SALE_TYPE IN (
						select b.INTER_CD as sale_type
						from tb_91010_m a (nolock), tb_91011_c b (nolock)
						where   a.inter_grp = b.inter_grp
						and     a.inter_grp   = '011'
						and     ( (b.inter_cd like  '1%' and b.inter_cd not in ('1k', '1F'))
							 or 
							  b.inter_cd in ('21','23') ) 
						)
			AND X.DC_RATE <= 30 //IN ( 0, 10, 20) 
			AND X.SALE_TYPE = :LS_SALE_TYPE;								
								
	else				

			SELECT COUNT(*)
			INTO :LL_SALE_CHK
			FROM TB_56010_M X (NOLOCK)
			WHERE SHOP_CD = :GS_SHOP_CD
			AND :IS_YYMMDD BETWEEN START_YMD AND END_YMD
			AND SALE_TYPE IN (
						select b.INTER_CD as sale_type
						from tb_91010_m a (nolock), tb_91011_c b (nolock)
						where   a.inter_grp = b.inter_grp
						and     a.inter_grp   = '011'
						and     ( (b.inter_cd like  '1%' and b.inter_cd not in ('1k', '1F'))
							 or 
							  b.inter_cd in ('21','23') ) 
						)
			AND X.DC_RATE <= 40 //IN ( 0, 10, 20) 
			AND X.SALE_TYPE = :LS_SALE_TYPE;
	
						
		end if				
						
		if  is_yymmdd >= "20240701"  and is_yymmdd <= "20241031" and is_kakao_apply <> "K" then    			 

			select count(*)
			into :ll_year_chk
			from 
			(		
			select  '2024' as year, 'W' as season
			union 	
			select  '2024' as year, 'A' as season
			union
			select  '2024' as year, 'M' as season
			union 	
			select  '2024' as year, 'X' as season
			) a
			where   a.year = :ls_year
			and     a.season = :ls_season ;
												
		elseif  is_yymmdd >= "20241024"  and is_kakao_apply = "K" then    			 

			select count(*)
			into :ll_year_chk
			from 
			(		
			select  '2024' as year, 'W' as season
			union 	
			select  '2024' as year, 'A' as season
			union
			select  '2024' as year, 'X' as season
			UNION
			select  '2025' as year, 'S' as season
			union 	
			select  '2025' as year, 'X' as season						
			
			) a
			where   a.year = :ls_year
			and     a.season = :ls_season ;

		elseif  is_yymmdd >= "20241101"  and ( is_kakao_apply = "I" or is_kakao_apply = "J"  ) then    			 

			select count(*)
			into :ll_year_chk
			from 
			(		
			select  '2024' as year, 'W' as season
			union 	
			select  '2024' as year, 'A' as season
			union
			select  '2024' as year, 'X' as season
			UNION
			select  '2025' as year, 'S' as season
			union 	
			select  '2025' as year, 'X' as season					
			) a
			where   a.year = :ls_year
			and     a.season = :ls_season ;
			
			
			
	else

			select count(*)
			into :ll_year_chk
			from 
			(		
			select  '2024' as year, 'S' as season
			union 	
			select  '2024' as year, 'M' as season
			union 	
			select  '2024' as year, 'X' as season
			union 	
			select  '2025' as year, 'S' as season
			union 	
			select  '2025' as year, 'X' as season
			
			
			) a
			where   a.year = :ls_year
			and     a.season = :ls_season ;


end if				
		
//		messagebox("", string(ll_sale_chk,"000"))
//		messagebox("", string(ll_year_chk,"000"))
//		

	if ll_sale_chk < 1  or ll_year_chk <= 0 then
		ll_sale_amt_chk = 0
		il_cnt_except = il_cnt_except + 1
		
	ELSE 
		ll_sale_amt_chk = dw_body.GetitemDecimal(i, "sale_price_org") 	* ll_sale_qty	
	end if	
						
	ll_sum_chk_amt = ll_sum_chk_amt + ll_sale_amt_chk	
	
NEXT

if ll_sum_chk_amt >= ll_limit_amt then	
	
	if is_kakao_apply = "E" then

			messagebox("알림!" , "할인 미적용대상 품번을 제외한 합계금액 30만원이상 추가 10% 할인이 적용됩니다!")				
		
	elseif is_kakao_apply = "F" then

			messagebox("알림!" , "할인 미적용대상 품번을 제외한 합계금액 40만원이상 추가 15% 할인이 적용됩니다!")		
	
	elseif is_kakao_apply = "G" then

			messagebox("알림!" , "할인 미적용대상 품번을 제외한 합계금액 20만원이상 추가 10% 할인이 적용됩니다!")				
	
	elseif is_kakao_apply = "H" then

			messagebox("알림!" , "할인 미적용대상 품번을 제외한 합계금액 100만원이상 추가 20% 할인이 적용됩니다!")		
		
	elseif is_kakao_apply = "I" then
	
			messagebox("알림!" , "할인 미적용대상 품번을 제외한 합계금액 1만원이상 추가 10% 할인이 적용됩니다!")	
			
	elseif is_kakao_apply = "J" then

			messagebox("알림!" , "할인 미적용대상 품번을 제외한 합계금액 1만원이상 추가 15% 할인이 적용됩니다!")		
			
	elseif is_kakao_apply = "K" then

			messagebox("알림!" , "할인 미적용대상 품번을 제외한 합계금액 40만원이상 추가 10% 할인이 적용됩니다!")					
			
	else 
			messagebox("알림!" , "할인 미적용대상 품번을 제외한 합계금액 50만원이상 추가 15% 할인이 적용됩니다!")		
		
	end if	
		
end if	

if ll_sum_chk_amt >= ll_limit_amt then
	FOR i=1 TO ll_row_count
	
						ll_tag_price     = dw_body.GetitemDecimal(i, "tag_price") 
						ll_curr_price    = dw_body.GetitemDecimal(i, "curr_price") 
						ll_out_price     = dw_body.GetitemNumber(i, "out_price") 
						ll_collect_price = dw_body.GetitemNumber(i, "collect_price")
						ll_sale_price_org = dw_body.GetitemNumber(i, "c_sale_price")
						ll_sale_price_org = dw_body.GetitemNumber(i, "sale_price_org")
						ldc_dc_rate_org = dw_body.GetitemNumber(i, "dc_rate_org")
						ldc_marjin_org = dw_body.GetitemNumber(i, "sale_rate")
						ls_sale_type = dw_body.Getitemstring(i, "sale_type")
						ls_year = dw_body.Getitemstring(i, "year")
						ls_season = dw_body.Getitemstring(i, "season")
						LS_CHK_COUPON = dw_head.GetItemString(i, "EMPTY_3")
						
				//		messagebox("", string( ll_sale_price_org))
						// 정상 할인 제품에 해당하는 판매형태 확인
						
				//elseif  is_yymmdd >= "20240408" and is_yymmdd <= "20240417"   and gs_shop_cd = 'NG1110' then
	 			if is_yymmdd >= "20240607" and is_yymmdd <= "20240620"  and gs_shop_cd = "NG1160" and is_kakao_apply = "I"  then 					
											
						SELECT COUNT(*)
						INTO :LL_SALE_CHK
						FROM TB_56010_M X (NOLOCK)
						WHERE SHOP_CD = :GS_SHOP_CD
						AND :IS_YYMMDD BETWEEN START_YMD AND END_YMD
						AND SALE_TYPE IN (
									select b.INTER_CD as sale_type
									from tb_91010_m a (nolock), tb_91011_c b (nolock)
									where   a.inter_grp = b.inter_grp
									and     a.inter_grp   = '011'
									and     ( (b.inter_cd like  '1%' and b.inter_cd not in ('1k', '1F'))
										 or 
										  b.inter_cd in ('21') ) 
									)
						AND X.DC_RATE <= 40
						AND X.SALE_TYPE = :LS_SALE_TYPE;																
												
				elseif  is_yymmdd >= "20240724" and is_yymmdd <= "20240731"   and gs_shop_cd = 'NG1210'  and is_kakao_apply = "G" then 
											
						SELECT COUNT(*)
						INTO :LL_SALE_CHK
						FROM TB_56010_M X (NOLOCK)
						WHERE SHOP_CD = :GS_SHOP_CD
						AND :IS_YYMMDD BETWEEN START_YMD AND END_YMD
						AND SALE_TYPE IN (
									select b.INTER_CD as sale_type
									from tb_91010_m a (nolock), tb_91011_c b (nolock)
									where   a.inter_grp = b.inter_grp
									and     a.inter_grp   = '011'
									and     ( (b.inter_cd like  '1%' and b.inter_cd not in ('1k'))
										 or 
										  b.inter_cd in ('21') ) 
									)
					//	AND X.DC_RATE <= 40
						AND X.SALE_TYPE = :LS_SALE_TYPE;					
						
				elseif  is_yymmdd >= "20240801" and is_yymmdd <= "20240831"   and gs_shop_cd = 'NG1137'  and is_kakao_apply = "I" then 
											
						SELECT COUNT(*)
						INTO :LL_SALE_CHK
						FROM TB_56010_M X (NOLOCK)
						WHERE SHOP_CD = :GS_SHOP_CD
						AND :IS_YYMMDD BETWEEN START_YMD AND END_YMD
						AND SALE_TYPE IN (
									select b.INTER_CD as sale_type
									from tb_91010_m a (nolock), tb_91011_c b (nolock)
									where   a.inter_grp = b.inter_grp
									and     a.inter_grp   = '011'
									and     ( (b.inter_cd like  '1%' and b.inter_cd not in ('1k', '1F'))
										 or 
										  b.inter_cd in ('21') ) 
									)
					//	AND X.DC_RATE <= 40
						AND X.SALE_TYPE = :LS_SALE_TYPE;						
						
				elseif  is_yymmdd >= "20241024"  and is_kakao_apply = "K" then 
						
						SELECT COUNT(*)
						INTO :LL_SALE_CHK
						FROM TB_56010_M X (NOLOCK)
						WHERE SHOP_CD = :GS_SHOP_CD
						AND :IS_YYMMDD BETWEEN START_YMD AND END_YMD
						AND SALE_TYPE IN (
									select b.INTER_CD as sale_type
									from tb_91010_m a (nolock), tb_91011_c b (nolock)
									where   a.inter_grp = b.inter_grp
									and     a.inter_grp   = '011'
									and     ( (b.inter_cd like  '1%' and b.inter_cd not in ('1k', '1F'))
										 or 
										  b.inter_cd in ('21') ) 
									)
//						AND X.DC_RATE IN ( 0, 10, 20)
						AND X.DC_RATE <= 30
						AND X.SALE_TYPE = :LS_SALE_TYPE;				
																			
  		    else 
						
						SELECT COUNT(*)
						INTO :LL_SALE_CHK
						FROM TB_56010_M X (NOLOCK)
						WHERE SHOP_CD = :GS_SHOP_CD
						AND :IS_YYMMDD BETWEEN START_YMD AND END_YMD
						AND SALE_TYPE IN (
									select b.INTER_CD as sale_type
									from tb_91010_m a (nolock), tb_91011_c b (nolock)
									where   a.inter_grp = b.inter_grp
									and     a.inter_grp   = '011'
									and     ( (b.inter_cd like  '1%' and b.inter_cd not in ('1k', '1F'))
										 or 
										  b.inter_cd in ('21') ) 
									)
//						AND X.DC_RATE IN ( 0, 10, 20)
						AND X.DC_RATE <= 40
						AND X.SALE_TYPE = :LS_SALE_TYPE;				
													
						
				end if 							
				
					if  is_yymmdd >= "20240701"  and  is_yymmdd <= "20241031" and is_kakao_apply <> "K" then    			 

							select count(*)
							into :ll_year_chk
							from 
							(		
							select  '2024' as year, 'W' as season
							union 	
							select  '2024' as year, 'A' as season
							union
							select  '2024' as year, 'M' as season
							union 	
							select  '2024' as year, 'X' as season
							) a
							where   a.year = :ls_year
							and     a.season = :ls_season ;
																
						elseif  is_yymmdd >= "20241024"  and is_kakao_apply = "K" then    			 
				
							select count(*)
							into :ll_year_chk
							from 
							(		
							select  '2024' as year, 'W' as season
							union 	
							select  '2024' as year, 'A' as season
							union
							select  '2024' as year, 'X' as season
							UNION
							select  '2025' as year, 'S' as season
							union 	
							select  '2025' as year, 'X' as season			
							) a
							where   a.year = :ls_year
							and     a.season = :ls_season ;
				
						elseif  is_yymmdd >= "20241101"  and ( is_kakao_apply = "I" or   is_kakao_apply = "J"  )then    			 
				
							select count(*)
							into :ll_year_chk
							from 
							(		
							select  '2024' as year, 'W' as season
							union 	
							select  '2024' as year, 'A' as season
							union
							select  '2024' as year, 'X' as season
							UNION
							select  '2025' as year, 'S' as season
							union 	
							select  '2025' as year, 'X' as season										
							) a
							where   a.year = :ls_year
							and     a.season = :ls_season ;							
							
					else
				
							select count(*)
							into :ll_year_chk
							from 
							(		
							select  '2024' as year, 'S' as season
							union 	
							select  '2024' as year, 'M' as season
							union 	
							select  '2024' as year, 'X' as season
							union 	
							select  '2025' as year, 'S' as season
							union 	
							select  '2025' as year, 'X' as season							
							
							) a
							where   a.year = :ls_year
							and     a.season = :ls_season ;
				
				
				end if				
				
								
				if ll_sale_chk < 1 or ll_year_chk <= 0 then
				//	messagebox("알림!", "해당품번은 쿠폰 적용 가능한 판매형태의 제품이  아닙니다!")
					GOTO SKIP
				end if	
						
						
//						select max(year), max(season), max(plan_yn)
//						into :ls_year, :ls_season, :ls_plan_yn
//						from vi_12020_1 (nolock)
//						where style = :as_style;
										
						
						//			 D 기본 할인, E 총구매금액 30만원이상 10%, F 총구매금액 50만원이상 15%
										
						if ls_year >= "2023"  then // and ldc_dc_rate_cal_chk <= 30 then //and ls_season  = "X"  then
								
									if  is_yymmdd >= "20240325" and is_yymmdd <= "20240407"  and gs_shop_cd = 'NG1017' and is_kakao_apply = "I"  and ldc_dc_rate_org = 0 and (ls_sale_type = "12" or  ls_sale_type = "22" or ls_sale_type = "23" ) then
										//신세계광주 팝업 쿠폰 I로 발행
										//(ll_tag_price / ll_sale_price_org) / 100
										//,
										
										
										ldc_dc_rate_org1 = (1 - (ll_sale_price_org /ll_tag_price)) * 100								
																	
										ldc_dc_rate = ldc_plus_rate + ldc_dc_rate_org1
								
										
										if ls_plan_yn = "Y" then
											ll_curr_price = ll_tag_price  * (100 - ldc_dc_rate_org) / 100
											ll_curr_price = ll_curr_price * (100 - ldc_plus_rate) / 100
											ll_out_price  = ll_curr_price	* (100 - ldc_marjin_org) / 100	
										end if		
										
//									elseif  is_yymmdd >= "20240408" and is_yymmdd <= "20240417"  and gs_shop_cd = 'NG1110'  and ldc_dc_rate_org = 0 and (ls_sale_type = "12" or  ls_sale_type = "22" or ls_sale_type = "23" ) then
//									elseif   is_yymmdd >= "20240607" and is_yymmdd <= "20240620"  and gs_shop_cd = "NG1160"  and ldc_dc_rate_org = 0 and (ls_sale_type = "12" or  ls_sale_type = "22" or ls_sale_type = "23" ) then										
									elseif   is_yymmdd >= "20240724" and is_yymmdd <= "20240731"  and gs_shop_cd = "NG1210"  and ldc_dc_rate_org = 0 and (ls_sale_type = "12" or  ls_sale_type = "22" or ls_sale_type = "23" ) then										
									
										//(ll_tag_price / ll_sale_price_org) / 100
										//,
										
										
										ldc_dc_rate_org1 = (1 - (ll_sale_price_org /ll_tag_price)) * 100								
																	
										ldc_dc_rate = ldc_plus_rate + ldc_dc_rate_org1
								
										
										if ls_plan_yn = "Y" then
											ll_curr_price = ll_tag_price  * (100 - ldc_dc_rate_org) / 100
											ll_curr_price = ll_curr_price * (100 - ldc_plus_rate) / 100
											ll_out_price  = ll_curr_price	* (100 - ldc_marjin_org) / 100	
										end if												

															
									elseif is_yymmdd <= "20250131"  and ldc_dc_rate_org = 0  and (ls_sale_type = "12" or  ls_sale_type = "21" or ls_sale_type = "xx" ) then
										
										//(ll_tag_price / ll_sale_price_org) / 100
										//,
										
										
										ldc_dc_rate_org1 = (1 - (ll_sale_price_org /ll_tag_price)) * 100								
																	
										ldc_dc_rate = ldc_plus_rate + ldc_dc_rate_org1
								
										
										if ls_plan_yn = "Y" then
											ll_curr_price = ll_tag_price  * (100 - ldc_dc_rate_org) / 100
											ll_curr_price = ll_curr_price * (100 - ldc_plus_rate) / 100
											ll_out_price  = ll_curr_price	* (100 - ldc_marjin_org) / 100	
										end if																						
										
										
									else 
										ldc_dc_rate = ldc_plus_rate + ldc_dc_rate_org
								
										if ls_plan_yn = "Y" then
											ll_curr_price = ll_tag_price  * (100 - ldc_dc_rate_org) / 100
											ll_curr_price = ll_curr_price * (100 - ldc_plus_rate) / 100
											ll_out_price  = ll_curr_price	* (100 - ldc_marjin_org) / 100	
										end if		
									end if
														
							else 
							//	messagebox("알림!", "쿠폰 행사 대상 제품이 아닙니다!")
								GOTO SKIP
							end if	
							
						
						
						
							
						select count(*)
						into :ldc_margin_cnt
						from tb_56010_m (nolock)
						where shop_cd = :gs_shop_cd
						and :is_yymmdd between start_ymd and end_ymd
						and sale_type = :ls_sale_type
						and dc_rate =  :ldc_dc_rate_org ;
						//and dc_rate = case when :ls_sale_type in ('22','23') then :ldc_dc_rate_cal else :ldc_dc_rate_org end;
						
						//messagebox("", string(ldc_margin_cnt, "0000"))
						
						if ldc_margin_cnt < 1 then
							//messagebox("알림!", "마지체크오류!")
								GOTO SKIP //return
						end if	
							
						select marjin_rate
						into :ldc_marjin
						from tb_56010_m (nolock)
						where shop_cd = :gs_shop_cd
						and :is_yymmdd between start_ymd and end_ymd
						and sale_type = :ls_sale_type
						and dc_rate =  :ldc_dc_rate_org ;
						//and dc_rate = case when :ls_sale_type in ('22','23') then :ldc_dc_rate_cal else :ldc_dc_rate_org end;
					

						if   is_yymmdd >= "20240724" and is_yymmdd <= "20240731"  and gs_shop_cd = "NG1210"   and ldc_dc_rate_org = 0 and (ls_sale_type = "12" or  ls_sale_type = "22" or ls_sale_type = "23" ) then
							
							ll_sale_price = ll_tag_price  * (100 - ldc_dc_rate_org1) / 100
							ll_sale_price = ll_sale_price * (100 - ldc_plus_rate) / 100
					
					
					   elseif  is_yymmdd >= "20240601" and ldc_dc_rate_org = 0 and (ls_sale_type = "12" or  ls_sale_type = "XX" or ls_sale_type = "23" ) then										
							
							ll_sale_price = ll_tag_price  * (100 - ldc_dc_rate_org1) / 100
							ll_sale_price = ll_sale_price * (100 - ldc_plus_rate) / 100
				
						
						else 
							ll_sale_price = ll_tag_price  * (100 - ldc_dc_rate_org) / 100
							ll_sale_price = ll_sale_price * (100 - ldc_plus_rate) / 100
						end if	
						
						
						dw_body.Setitem(i, "sale_price",  ll_sale_price)
						dw_body.Setitem(i, "tag_amt",  ll_tag_price  * al_sale_qty)
						dw_body.Setitem(i, "curr_amt", ll_curr_price * al_sale_qty)
						dw_body.Setitem(i, "sale_amt", ll_sale_price * al_sale_qty)
						dw_body.Setitem(i, "out_amt",  ll_out_price  * al_sale_qty) 
						dw_body.Setitem(i, "sale_type",  ls_sale_type) 
						dw_body.Setitem(i, "empty_3",  is_coupon_no) 
																	
																	
						// 최종 할인율 확인 																	
						ldc_dc_rate = (1 - ll_sale_price / ll_tag_price) * 100
						
						
						if mid(ls_sale_type,1,1) = "3" then
							dw_body.Setitem(i, "curr_price", ll_curr_price)		
							dw_body.Setitem(i, "dc_rate",  0) 
							
						else
							dw_body.Setitem(i, "dc_rate",  ldc_dc_rate) 	
						end if	
							
						dw_body.Setitem(i, "sale_rate",  ldc_marjin) 
						
						ll_goods_amt = dw_body.GetitemDecimal(i, "goods_amt") 
						
						gf_marjin_price(gs_shop_cd, (ll_sale_price * al_sale_qty), ldc_marjin, ll_sale_collect1)

						ll_sale_collect = ll_sale_collect1 //- (ll_goods_amt * ldc_marjin / 100)
						dw_body.Setitem(i, "sale_collect", ll_sale_collect) 
								
								/* 세일 재매입 처리 */
						//		gf_marjin_price(gs_shop_cd, (ll_sale_price * al_sale_qty), ldc_marjin, ll_sale_collect)  					
								ll_io_amt = (ll_out_price  * al_sale_qty) - ll_sale_collect
								dw_body.Setitem(i, "io_amt", ll_io_amt)
								dw_body.Setitem(i, "io_vat", ll_io_amt - Round(ll_io_amt / 1.1, 0))
								
		SKIP:								
								
		NEXT
end if		
								

end subroutine

public function boolean wf_style_chk_back (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_size, ls_shop_type, ls_given_fg, ls_given_ymd, ls_sale_type, ls_sale_type_o
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn , LS_RTRN_YMD , ls_work_gubn, ls_date
Long   ll_tag_price, ll_ord_qty, ll_ord_qty_chn 

dw_head.accepttext()
ls_date = string(dw_head.GetItemDate(1,'yymmdd'))
ls_date = mid(ls_date,1,4) + mid(ls_date,6,2) + mid(ls_date,9,2)

IF Len(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = Mid(as_style_no, 1, 8)
ls_chno  = Mid(as_style_no, 9, 1)
ls_color = Mid(as_style_no, 10, 2)
ls_size  = Mid(as_style_no, 12, 2)

if mid(gs_shop_cd,3,4) >= "1900" and mid(gs_shop_cd,3,4) <= "1913" then 
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
		and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end;

elseif  gs_brand = "B" or gs_brand = 'D' or gs_brand = 'V' or gs_brand = 'U' or gs_brand = 'G' then
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
		and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end;		

elseif  gs_brand = "O"  then
	if ls_date <= is_close_ymd_t then
		//마감일자 전의 판매
		//정상+행사
		if is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'N' then
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
			  where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp		
			  	and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= :is_year_f + :is_season_s_f ) 
							or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_f + :is_season_s_f  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );
		//정상+행사+기획
		elseif is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'Y' then
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
			  where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp		
			  	and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= :is_year_f + :is_season_s_f ) 
//							or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_f + :is_season_s_f  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
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
		if is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'N' then
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
			  where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp		
			  	and style = :ls_style 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= :is_year_t + :is_season_s_t ) 
						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_t + :is_season_s_t  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );			

		//정상+행사+기획
		elseif is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'Y' then
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
			  where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp		
			  	and style = :ls_style 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >=:is_year_t + :is_season_s_t ) 
//						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_t + :is_season_s_t  and plan_yn = 'Y' )   
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
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
	
	
////// 20210928

elseif gs_brand = "N"  then
	if ls_date <= is_close_ymd_t then
		//마감일자 전의 판매
		//정상+행사
		if is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'N' then
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
//			 where brand_grp = :gs_brand_grp //brand LIKE '[NJ]%' // :gs_brand 
			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp			 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= :is_year_f + :is_season_s_f ) 
							or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_f + :is_season_s_f  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );
		//정상+행사+기획
		elseif is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'Y' then
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
//			 where  brand_grp = :gs_brand_grp // brand  LIKE '[NJ]%' // :gs_brand 
			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= :is_year_f + :is_season_s_f ) 
//							or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_f + :is_season_s_f  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
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
		if is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'N' then
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
//			 where  brand_grp = :gs_brand_grp // brand  LIKE '[NJ]%' // :gs_brand 
			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= :is_year_t + :is_season_s_t ) 
						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_t + :is_season_s_t  and plan_yn = 'Y' ) 
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
								and a.shop_cd = :gs_shop_cd
								and :is_yymmdd between a.start_ymd and a.end_ymd
								and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) 
												where  :is_yymmdd  between a.frm_ymd and a.to_ymd 
												  and a.shop_cd = :gs_shop_cd
												  and a.shop_cd = b.shop_cd 
												  and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )
						  );			

		//정상+행사+기획
		elseif is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'Y' then
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
//			 where  brand_grp = :gs_brand_grp // brand  LIKE '[NJ]%' // :gs_brand 
			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp			 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >=:is_year_t + :is_season_s_t ) 
//						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_t + :is_season_s_t  and plan_yn = 'Y' )   
						)
						or style in (select a.style
								from tb_56012_d a (nolock)
								where a.shop_type = '3'
								and a.sale_type in ('33')
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




/////





else 	
		Select brand,     year,     season,     
			 sojae,     item,     tag_price,     plan_yn   
	  into :ls_brand, :ls_year, :ls_season, 
			 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
	  from vi_12024_1 with (nolock)
//	 where brand = :gs_brand 
	 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp
		and style = :ls_style 
		and chno  = :ls_chno
		and color = :ls_color 
		and size  = :ls_size
		and sojae  <> 'C' 	
		and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
      and 
		
	 		 ( (  
		  			( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20094' ) 
//           or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20094'  and plan_yn = 'Y' )   
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
		
	
end if

IF SQLCA.SQLCODE <> 0 THEN 
	messagebox("확인","시즌마감되어 반품등록이 불가능합니다! 관리팀에 연락 바랍니다!")
	Return False 
END IF


Select isnull(ord_qty,0), isnull(ord_qty_chn,0)
  into :ll_ord_qty, :ll_ord_qty_chn  
  from tb_12030_s with (nolock)
 where style = :ls_style 
	and chno  = :ls_chno
	and color = :ls_color 
	and size  = :ls_size;
	
if gs_brand <> 'M' then
	if ll_ord_qty - ll_ord_qty_chn <= 0  then 
		messagebox("경고!", "국내 판매등록이 불가능한 제품입니다!")
		return false
	end if	
end if	

ls_sale_type_o = dw_back_sale.getitemstring(al_row, "sale_type")

if left(as_style_no,1) = "N"  and (left(gs_shop_cd, 2) <> "NO" or left(gs_shop_cd, 2) <> "JO" ) then
	
//					Select sale_type
//					into :ls_sale_type
//					From tb_56012_d with (nolock)
//					Where style      = :ls_style 
//					  and start_ymd <= :is_yymmdd
//					  and end_ymd   >= :is_yymmdd
//					  and shop_type <> '9'
//					  and shop_cd    = :gs_shop_cd ;
//					
//					if IsNull(ls_sale_type) or Trim(ls_sale_type) = "" then
//						ls_shop_type = "11"
//					end if	
//					
//					if ls_shop_type < "40"  then 
//						messagebox("경고!", "정상 판매반품등록이 불가능한 제품입니다!")
//						return false
//					end if	
					
					SELECT  ISNULL(RTRN_YMD, '99999999')
					INTO :LS_RTRN_YMD
					FROM tb_54020_h
					WHERE STYLE = :LS_STYLE
					AND   DEP_FG = 'Y';
					
					if IsNull(LS_RTRN_YMD) or Trim(LS_RTRN_YMD) = "" then
						LS_RTRN_YMD = "99999999"
					end if
					
					
					if ls_sale_type_o < "40"  AND GS_SHOP_DIV <> "H" then 
						IF LS_RTRN_YMD <= IS_YYMMDD THEN 
							messagebox("경고!", "부진적용일이후 정상 판매,반품등록은 불가능합니다! 관리팀에 연락 바랍니다!")
							return false
						END IF	
					end if	
					
					SELECT  ISNULL(RTRN_YMD, '99999999')
					INTO :LS_RTRN_YMD
					FROM tb_54021_h
					WHERE STYLE = :LS_STYLE
					AND   DEP_FG = 'Y';
					
					if IsNull(LS_RTRN_YMD) or Trim(LS_RTRN_YMD) = "" then
						LS_RTRN_YMD = "99999999"
					end if

					
					if ls_sale_type_o < "20"  then 
						IF LS_RTRN_YMD <= IS_YYMMDD THEN 
							messagebox("경고!", "품목할인 적용일이후 정상판매로의 반품등록은 불가능합니다! 관리팀에 연락 바랍니다!")
							return false
						END IF	
					end if						
					
					
end if					
					
					
select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
into  :ls_given_fg, :ls_given_ymd
from tb_12020_m with (nolock)
where style = :ls_style;


if ls_given_fg = "Y" then 
	messagebox("품번체크", ls_given_ymd + "일자로 사은품 전환된 제품입니다!")
	return false
end if 	


select work_gubn, given_ymd
into :ls_work_gubn, :ls_given_ymd
from beaucre.dbo.tb_56040_m with (nolock)
where style like :ls_style + '%'
and  shop_brand like '%' + :gs_brand + '%'
and   gubn = 'C';

IF (ls_work_gubn = "T" or  ls_work_gubn = "A") and ls_given_ymd <= is_yymmdd THEN 
	messagebox("품번검색", ls_given_ymd + "일자로 판매/판매반품 불가로 전환된 제품입니다!")					
	return false 	
END IF 		


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

public subroutine wf_amt_set_kakao (long al_row, long al_sale_qty, string as_style);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_sale_price, ll_out_price, ll_collect_price
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect1  , ll_sale_collect, ll_sale_price_org
Decimal ldc_marjin, ldc_dc_rate, ldc_dc_rate_org, ldc_marjin_org, ldc_dc_rate_cal, ldc_dc_rate_cal_chk,ldc_plus_rate,ldc_dc_rate_org1
string ls_year, ls_season, ls_sale_type, ls_style,ls_saup_gubn, ls_plan_yn, ls_apply_type, ls_item
Long ll_sale_amt_chk,ll_kakao_chk,ll_used_cnt, ll_sale_chk
integer li_style_cnt, ldc_margin_cnt, ll_year_chk

ll_tag_price     = dw_body.GetitemDecimal(al_row, "tag_price") 
ll_curr_price    = dw_body.GetitemDecimal(al_row, "curr_price") 
ll_out_price     = dw_body.GetitemNumber(al_row, "out_price") 
ll_collect_price = dw_body.GetitemNumber(al_row, "collect_price")
ll_sale_price_org = dw_body.GetitemNumber(al_row, "sale_price")
ldc_dc_rate_org = dw_body.GetitemNumber(al_row, "dc_rate")
ldc_marjin_org = dw_body.GetitemNumber(al_row, "sale_rate")
ls_sale_type = dw_body.Getitemstring(al_row, "sale_type")
ls_year = dw_body.Getitemstring(al_row, "year")
ls_season = dw_body.Getitemstring(al_row, "season")
ls_item = dw_body.Getitemstring(al_row, "item")
is_coupon_no = dw_head.GetItemString(1, "coupon_no")



if is_kakao_apply = "D" then 	
	ldc_plus_rate = 10
elseif is_kakao_apply = "U" then 	
	ldc_plus_rate = 5
else 	
	ldc_plus_rate = 20
end if	

if gs_brand <> "D"  and gs_brand <> "A"  then

					select count(*)
					into :li_style_cnt
					from tb_12020_m (nolock)
					where style = :as_style
					and year >= '2023';
					//and item in ('O','J') ;
					
					
					if li_style_cnt < 1 and is_yymmdd >= "20220610"  then
						messagebox("알림!", "쿠폰 적용 가능한 2022-여름/사계절 제품이 아닙니다!")
						return
					end if	
					
					//if li_style_cnt < 1 and is_yymmdd >= "20220510" and is_yymmdd <= "20220522"  then
					//	messagebox("알림!", "쿠폰 적용 가능한 2021-사계절, 2022-여름/사계절 자켓, 원피스가 아닙니다!")
					//	return
					//end if	
					
					
					// 정상 할인 제품에 해당하는 판매형태 확인
					select count(*)
					into :ll_sale_chk
					from (select b.INTER_CD as sale_type
							from tb_91010_m a (nolock), tb_91011_c b (nolock)
							where   a.inter_grp = b.inter_grp
							and     a.inter_grp   = '011'
							and     ( (b.inter_cd like  '1%' and b.inter_cd not in ('1k'))
								 or 
								  b.inter_cd in ('21','31') ) ) a
					where a.sale_type = :ls_sale_type	;	
							
 
							
						if ll_sale_chk < 1 then
							messagebox("알림!", "해당품번은 쿠폰 적용 가능한 판매형태의 제품이  아닙니다!")
							return
						end if	
	else 					

			
			     if is_kakao_apply = "D" then		 
					
								select count(*)
								into :li_style_cnt
								from tb_71011_except_st (nolock)
								where style = :as_style;
								
								
								if li_style_cnt > 0 then
									messagebox("알림!", "쿠폰 적용 가능한 제품이 아닙니다!")
									return
								end if	
								
								
								
									// 정상 할인 제품에 해당하는 판매형태 확인
									select count(*)
									into :ll_sale_chk
									from (select b.INTER_CD as sale_type
											from tb_91010_m a (nolock), tb_91011_c b (nolock)
											where   a.inter_grp = b.inter_grp
											and     a.inter_grp   = '011'
											and     ( (b.inter_cd like  '1%' and b.inter_cd not in ('1k'))
												 or 
												  b.inter_cd in ('21','31') ) ) a
									where a.sale_type = :ls_sale_type	;	
					else 

								select count(*)
								into :ll_sale_chk
								from (select b.INTER_CD as sale_type
										from tb_91010_m a (nolock), tb_91011_c b (nolock)
										where   a.inter_grp = b.inter_grp
										and     a.inter_grp   = '011'
										and     ( (b.inter_cd like  '1%' and b.inter_cd not in ('1k'))
											 or 
											  b.inter_cd in ('21','22','31') ) ) a
								where a.sale_type = :ls_sale_type	;	
					end if
										
					if ll_sale_chk < 1 then
						messagebox("알림!", "해당품번은 쿠폰 적용 가능한 판매형태의 제품이  아닙니다!")
						return
					end if	
	end if						


	if IsNull(is_coupon_no) or Trim(is_coupon_no) = "" then
		MessageBox("알림!","플러스친쿠 쿠폰인 경우 정확한 쿠폰번호를 입력 하셔야 할인이 적용됩니다!")
		dw_head.SetFocus()
		dw_head.SetColumn("coupon_no")
		return 
	end if	
	
			
			if (gs_brand <> "D" and gs_brand <> "A" )then 
				select count(*), isnull(apply_type,'D')
				into :ll_kakao_chk, :ls_apply_type
				from tb_71011_kakao (nolock)
				where  apply_brand like '%' + :gs_brand + '%'
				and :is_yymmdd between start_ymd and end_ymd
				and coupon_no = :is_coupon_no	
				and accept_flag = 'N'
				group by apply_type	;
			else	
				select count(*), isnull(apply_type,'D')
				into :ll_kakao_chk, :ls_apply_type
				from tb_71011_kakao (nolock)
				where  apply_brand like '%' + :gs_brand + '%'
				and :is_yymmdd between start_ymd and end_ymd
				and coupon_no = :is_coupon_no	
				and right(coupon_no,6) = :gs_shop_cd
				and accept_flag = 'N'
				group by apply_type	;
			end if	

			
//			 D 기본 할인, E 총구매금액 30만원이상 10%, F 총구매금액 50만원이상 15%
		
			
			if IsNull(ll_kakao_chk) or ll_kakao_chk <= 0 then
				MessageBox("알림!","유효한 쿠폰번호가 아닙니다!")
				dw_head.SetFocus()
				dw_head.Setitem(1, "coupon_no", "")			
				dw_head.SetColumn("coupon_no")
				return 
			end if	
			
			select beaucre.dbo.SF_coupon_used_cnT(:is_coupon_no, :gs_shop_cd)
			into :ll_used_cnt
			from dual;	
			
		
			
			if ll_used_cnt >= 1 then
				MessageBox("알림!","사용된 쿠폰 입니다! 영업부에 문의 하세요!")
				dw_head.SetFocus()
				dw_head.Setitem(1, "coupon_no", "")			
				dw_head.SetColumn("coupon_no")
				return 
			end if					
	


select max(year), max(season), max(plan_yn)
into :ls_year, :ls_season, :ls_plan_yn
from vi_12020_1 (nolock)
where style = :as_style;

////실 할인율 보관
//ldc_dc_rate_cal = ldc_dc_rate_org
//
//// 실제 할인율 계산
//if ldc_dc_rate_org = 0  and ll_sale_price_org <> ll_tag_price then
//	ldc_dc_rate_cal_chk = (1 - (ll_sale_price_org / ll_tag_price)) * 100 
//else 	
//   ldc_dc_rate_cal_chk	= ldc_dc_rate_org
//end if	


//// 판매형태 22, 23 에 가격인하율  30% 이하 품볼할인으로 가격등록된 경우에 실 할인율 확인
//if (ls_sale_type = "22"  or ls_sale_type = "23" ) and  (1 - (ll_sale_price_org / ll_tag_price)) * 100  <= 30 and  ldc_dc_rate_cal = 0 then
//	ldc_dc_rate_org =  (1 - (ll_sale_price_org / ll_tag_price)) * 100
//end if
//


//			 D 기본 할인, E 총구매금액 30만원이상 10%, F 총구매금액 50만원이상 15%

if ls_apply_type = "D" then
	
//	select count(*)
//			into :ll_year_chk
//			from 
//			(
//			select  '2022' as year, 'W' as season
//			union 	
//			select  '2022' as year, 'X' as season
//			union		
//			select  '2023' as year, 'S' as season
//			union 	
//			select  '2023' as year, 'M' as season
//			union 	
//			select  '2023' as year, 'X' as season
//			) a
//			where   a.year = :ls_year
//			and     a.season = :ls_season ;
	
end if

if  ( gs_brand <> "D"  and gs_brand <> "A" ) then 
	
	if ls_year  = "2021" and (ls_season  = "X" or ls_season = "X") and li_style_cnt > 0 then //and ldc_dc_rate_cal_chk <= 30 then
		ldc_dc_rate = ldc_plus_rate + ldc_dc_rate_org
		if ls_plan_yn = "Y" then
			//ls_sale_type = "3L"
//			ll_curr_price = ll_tag_price * (100 - ldc_dc_rate) / 100
//			ll_out_price  = ll_curr_price	* (100 -ldc_marjin_org) / 100	
			
			ll_curr_price = ll_tag_price * (100 - ldc_dc_rate_org) / 100
			ll_curr_price = ll_curr_price * (100 - ldc_plus_rate) / 100
			ll_out_price  = ll_curr_price	* (100 -ldc_marjin_org) / 100				
			
		else 	
		//	ls_sale_type = "1L"		
		end if		
			
	elseif ls_year >= "2022"  and li_style_cnt > 0 then // and ldc_dc_rate_cal_chk <= 30 then //and ls_season  = "X"  then
		ldc_dc_rate = ldc_plus_rate + ldc_dc_rate_org
		//ls_sale_type = "1J"	
	
		if ls_plan_yn = "Y" then
		//	ls_sale_type = "3L"
//			ll_curr_price = ll_tag_price * (100 - ldc_dc_rate) / 100		
//			ll_out_price  = ll_curr_price	* (100 -ldc_marjin_org) / 100	

			ll_curr_price = ll_tag_price * (100 - ldc_dc_rate_org) / 100
			ll_curr_price = ll_curr_price * (100 - ldc_plus_rate) / 100
			ll_out_price  = ll_curr_price	* (100 -ldc_marjin_org) / 100		

//		else 	
		//	ls_sale_type = "1L"		
		end if		
				
	else 
		messagebox("알림!", "쿠폰 행사 대상 제품이 아닙니다!")
		return 
	end if	
	
end if	

if is_kakao_apply = "C" then

			select count(*)
			into :ll_year_chk
			from tb_kakako_mininko_style (nolock)
			where style = :as_style;


			if ll_year_chk < 1 then
				messagebox("알림!", "할인 대상제품이 아닙니다!")
				return
			end if	
	
end if	
	
select count(*)
into :ldc_margin_cnt
from tb_56010_m (nolock)
where shop_cd = :gs_shop_cd
and :is_yymmdd between start_ymd and end_ymd
and sale_type = :ls_sale_type
and dc_rate =  :ldc_dc_rate_org ;
//and dc_rate = case when :ls_sale_type in ('22','23') then :ldc_dc_rate_cal else :ldc_dc_rate_org end;


if ldc_margin_cnt < 1 then
	messagebox("알림!", "행사 적용 기간이 아닙니다!")
	return
end if	
	
select marjin_rate
into :ldc_marjin
from tb_56010_m (nolock)
where shop_cd = :gs_shop_cd
and :is_yymmdd between start_ymd and end_ymd
and sale_type = :ls_sale_type
and dc_rate =  :ldc_dc_rate_org ;
//and dc_rate = case when :ls_sale_type in ('22','23') then :ldc_dc_rate_cal else :ldc_dc_rate_org end;


ldc_dc_rate_org1 = (1 - (ll_sale_price_org /ll_tag_price)) * 100								
																	
ll_sale_price = ll_tag_price  * (100 - ldc_dc_rate_org1) / 100
ll_sale_price = ll_sale_price * (100 - ldc_plus_rate) / 100
								

dw_body.Setitem(al_row, "sale_price",  ll_sale_price)
dw_body.Setitem(al_row, "tag_amt",  ll_tag_price  * al_sale_qty)
dw_body.Setitem(al_row, "curr_amt", ll_curr_price * al_sale_qty)
dw_body.Setitem(al_row, "sale_amt", ll_sale_price * al_sale_qty)
dw_body.Setitem(al_row, "out_amt",  ll_out_price  * al_sale_qty) 
dw_body.Setitem(al_row, "sale_type",  ls_sale_type) 
dw_body.Setitem(al_row, "empty_3",  is_coupon_no) 

ldc_dc_rate = (1 - ll_sale_price / ll_tag_price) * 100

if mid(ls_sale_type,1,1) = "3" then
	dw_body.Setitem(al_row, "curr_price", ll_curr_price)		
	dw_body.Setitem(al_row, "dc_rate",  0) 
	
else
	dw_body.Setitem(al_row, "dc_rate",  ldc_dc_rate) 	
end if	
	
dw_body.Setitem(al_row, "sale_rate",  ldc_marjin) 

ll_goods_amt = dw_body.GetitemDecimal(al_row, "goods_amt") 

ll_sale_amt_chk = dw_body.GetitemDecimal(al_row, "sale_amt") 




 		   gf_marjin_price(gs_shop_cd, (ll_sale_price * al_sale_qty), ldc_marjin, ll_sale_collect1)
         //판매금액에 할인금액적용을 백화점과 대리점 별도로 계산된 내역 수정(요청:장나영차장 일자:20140702)
			if gs_shop_div = "G" then 
				ll_sale_collect = ll_sale_collect1 //- (ll_goods_amt * ldc_marjin / 100)
			else
				ll_sale_collect = ll_sale_collect1
			end if	
		
		
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

dw_body.accepttext()

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

//messagebox("style_set",ls_dot_com)

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
				where b.shoP_div in ('B','G','O')
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
	
		/* 출고 마진율 체크 닷컴일때.(판매시에는 닷컴마진율로 나가기)*/
		IF gf_out_marjin_color (as_yymmdd,    ls_shop_cd,     ls_shop_type , as_style, ls_color, & 
							ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
		is_mj_bit = 'N'
		RETURN False 
	END IF
	
	/* 판매 마진율 체크 닷컴일때.(판매시에는 닷컴마진율로 나가기)*/
		
		IF gf_sale_marjin_color (as_yymmdd,    ls_shop_cd,      ls_shop_type, as_style, ls_color, & 
								 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 
			is_mj_bit = 'N'
			RETURN False
		END IF


      // 닷컴으로 판매시에는 G코드가 아닌 H로 수정해서 입력
		//ll_curr_price = ll_sale_price
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
	dw_body.Setitem(al_row, "sale_price_org",       ll_sale_price)	
	
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
	if is_empno = "000000"  and is_coupon_no = "000000000000" then
		wf_amt_set(al_row, al_qty)   
	elseif is_empno <> "000000"  and is_coupon_no = "000000000000" then
		wf_amt_set_empno(al_row, al_qty, as_style)		
	elseif is_empno = "000000"  and is_coupon_no <> "000000000000" and (is_kakao_apply = "D" or is_kakao_apply = "C"  or is_kakao_apply = "U" )  then
		wf_amt_set_kakao(al_row, al_qty, as_style)				
	elseif is_empno = "000000"  and is_coupon_no <> "000000000000" and is_kakao_apply = "S" then
		wf_amt_set_kakao_style(al_row, al_qty, as_style)						
	elseif is_empno = "000000"  and is_coupon_no <> "000000000000" and ( is_kakao_apply = "E" or is_kakao_apply = "F" or is_kakao_apply = "G" or is_kakao_apply = "H" or is_kakao_apply = "I" or is_kakao_apply = "J" or is_kakao_apply = "K" ) then
		wf_amt_set_kakao_1(al_row, al_qty, as_style)						
	elseif is_empno = "000000"  and is_coupon_no <> "000000000000" and ( is_kakao_apply = "M" or is_kakao_apply = "N" or is_kakao_apply = "O" or is_kakao_apply = "P") then
		wf_amt_set_kakao_2(al_row, al_qty, as_style)								
	else 		
		wf_amt_set(al_row, al_qty)   
	end if		
	
	
	RETURN True
else
	RETURN false
end if

//RETURN True
end function

public subroutine wf_amt_set_kakao_2 (long al_row, long al_sale_qty, string as_style);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_sale_price, ll_out_price, ll_collect_price,ll_row_count
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect1  , ll_sale_collect, ll_sale_price_org
Decimal ldc_marjin, ldc_dc_rate, ldc_dc_rate_org, ldc_marjin_org, ldc_dc_rate_cal, ldc_dc_rate_cal_chk, ldc_plus_rate,ldc_dc_rate_org1
string ls_year, ls_season, ls_sale_type, ls_style,ls_saup_gubn, ls_plan_yn, ls_apply_type, LS_CHK_COUPON, ls_use_coupon
Long ll_sale_amt_chk,ll_kakao_chk,ll_used_cnt, ll_sale_chk, ll_sum_chk_amt, ll_limit_amt, ll_sale_qty,ll_year_chk, ll_sale_QTY_chk,  ll_sum_chk_QTY
integer li_style_cnt, ldc_margin_cnt, i, il_cnt_except
LONG ll_dc_limit_amt, ll_dc_limit_amt_CHK,ll_limit_QTY,ll_sum_dc,ll_sale_amt_chk_dc,ll_sale_amt_dc, ll_test,ll_sum_chk_QTY1


if is_kakao_apply = "M"  then  // 10%
//	ll_limit_amt = 300000
	
	
	// 300000  	// 20240118 영업부 이규민		
					// 202309 성희명 변경기안
					// 202305 김건형 30 -> 20  
	//	400000   // 202304 박태선 변경기안
		li_style_cnt = 2
		ll_dc_limit_amt = 100000 
		
		ll_limit_amt = 10000 // 400000  
		ldc_plus_rate = 10
	
	
elseif  is_kakao_apply = "N"  then // 10%
	
	
		li_style_cnt = 2
		ll_dc_limit_amt = 100000 
	
		ll_limit_amt = 10000 // 400000  
		ldc_plus_rate = 10
		
elseif  is_kakao_apply = "O"  then  // 10% 250909 이규호 2025년 M라인 여름(M), 사계절(X) 상품, 균일가 포함
	
		li_style_cnt = 2
		ll_dc_limit_amt = 100000 

		ll_limit_amt = 10000 // 400000  
		ldc_plus_rate = 10		
	
elseif  is_kakao_apply = "P"  then  // 10% 250909 이규호 25년 M라인 가을(A) 상품 현판가 기준 추가 10% 적용
	
		li_style_cnt = 2
		ll_dc_limit_amt = 100000 

		ll_limit_amt = 10000 // 400000  
		ldc_plus_rate = 10			
	
else 
	return
end if

dw_body.AcceptText()

ll_row_count = dw_body.RowCount()


	ll_sale_amt_dc	= 0
	ll_sum_chk_amt = 0
	ll_sum_chk_QTY1 = 0
	ll_sale_QTY_chk = 0


FOR i=1 TO ll_row_count // 대상에 해당되는 합계 금액 확인
	
		ll_sale_qty = 0
		ls_sale_type = dw_body.Getitemstring(i, "sale_type")
		ll_sale_qty  =  dw_body.GetitemDecimal(i, "sale_qty") 		
		ls_year = dw_body.Getitemstring(i, "year")
		ls_season = dw_body.Getitemstring(i, "season")		
		ll_sale_price_org = dw_body.GetitemDecimal(i, "sale_price_org")
		ls_style = dw_body.Getitemstring(i, "style")
		
			if is_kakao_apply = "N" then
			
				 SELECT COUNT(*)
					INTO :LL_SALE_CHK
					FROM TB_56010_M X (NOLOCK)
					WHERE SHOP_CD = :GS_SHOP_CD
					AND :IS_YYMMDD BETWEEN START_YMD AND END_YMD
					AND SALE_TYPE <= '22'
					AND X.DC_RATE <= 30 //IN ( 0, 10, 20) 
					AND X.SALE_TYPE = :LS_SALE_TYPE;
					
			elseif ( is_kakao_apply = "O" or  is_kakao_apply = "P" ) then // O: 250909 이규호 2025년 M라인 여름(M), 사계절(X) 상품, 균일가 포함
																							  // P: 250909 이규호 25년 M라인 가을(A) 상품 현판가 기준 추가 10% 적용
			
				 SELECT COUNT(*)
					INTO :LL_SALE_CHK
					FROM TB_56010_M X (NOLOCK)
					WHERE SHOP_CD = :GS_SHOP_CD
					AND :IS_YYMMDD BETWEEN START_YMD AND END_YMD
					AND SALE_TYPE <= '22'
					AND X.DC_RATE <= 30 //IN ( 0, 10, 20) 
					AND X.SALE_TYPE = :LS_SALE_TYPE;					
							
			else							
	
				 SELECT COUNT(*)
					INTO :LL_SALE_CHK
					FROM TB_56010_M X (NOLOCK)
					WHERE SHOP_CD = :GS_SHOP_CD
					AND :IS_YYMMDD BETWEEN START_YMD AND END_YMD
					AND SALE_TYPE = '11'
					AND X.DC_RATE < 10 //IN ( 0, 10, 20) 
					AND X.SALE_TYPE = :LS_SALE_TYPE;
					
			end if
						
	
			if IS_YYMMDD >= '20250801' then
				if is_kakao_apply = "N" then
						select count(*)
						into :ll_year_chk
						from 
						(		
						select  '2025' as year, 'M' as season
						union 	
						select  '2025' as year, 'A' as season
						union 	
						select  '2025' as year, 'W' as season
						union 	
						select  '2025' as year, 'X' as season
						
						) a
						where   a.year = :ls_year
						and     a.season = :ls_season ;
						 
					elseif is_kakao_apply = "O" then // 250909 이규호 2025년 M라인 여름(M), 사계절(X) 상품, 균일가 포함
						select count(*)
						into :ll_year_chk
						from 
						(		
						select  '2025' as year, 'M' as season, 'M' as brand
						union 	
						select  '2025' as year, 'X' as season, 'M' as brand
						
						) a
						where   a.year = :ls_year
						and     a.season = :ls_season
						and     a.brand = left(:ls_style,1)	;					
						
					elseif is_kakao_apply = "P" then // 250909 이규호 25년 M라인 가을(A) 상품 현판가 기준 추가 10% 적용
						select count(*)
						into :ll_year_chk
						from 
						(		
						select  '2025' as year, 'A' as season, 'M' as brand
						
						) a
						where   a.year = :ls_year
						and     a.season = :ls_season 
						and     a.brand = left(:ls_style,1)	;	
				else
						select count(*)
						into :ll_year_chk
						from 
						(		
						select  '2025' as year, 'A' as season
						union 	
						select  '2025' as year, 'W' as season
						union 	
						select  '2025' as year, 'X' as season
						
						) a
						where   a.year = :ls_year
						and     a.season = :ls_season ;
					end if
					
			else 	
				select count(*)
				into :ll_year_chk
				from 
				(		
				select  '2025' as year, 'S' as season
				union 	
				select  '2025' as year, 'M' as season
				union 	
				select  '2025' as year, 'A' as season
				union 	
				select  '2025' as year, 'W' as season
				union 	
				select  '2025' as year, 'X' as season
				
				) a
				where   a.year = :ls_year
				and     a.season = :ls_season ;
			end if	
				
		// N, O, P 타입 쿠폰 M라인 적용	
		
		// O: 250909 이규호 2025년 M라인 여름(M), 사계절(X) 상품, 균일가 포함
		// P: 250909 이규호 25년 M라인 가을(A) 상품 현판가 기준 추가 10% 적용		
		
		if is_kakao_apply = "N" and upper(mid(ls_style, 1,1)) <> "M"  then
				ll_year_chk = 0
		end if		

		if is_kakao_apply = "O" and upper(mid(ls_style, 1,1)) <> "M"  then
				ll_year_chk = 0
		end if		
		
		if is_kakao_apply = "P" and upper(mid(ls_style, 1,1)) <> "M"  then
				ll_year_chk = 0
		end if				
//		
		
//		mid(as_style, 1,1)
//		
//		messagebox("", mid(as_style, 1,1))
//		messagebox("", string(ll_year_chk,"000"))
//		

   //판매형태 조건과 년도시즌 조건 미충족시
	if ll_sale_chk < 1  or ll_year_chk <= 0 then
		ll_sale_amt_chk = 0
		il_cnt_except = il_cnt_except + 1
		
	ELSE 
		ll_sale_amt_chk = dw_body.GetitemDecimal(i, "sale_price_org") 	* ll_sale_qty	
		ll_sale_amt_chk_dc = dw_body.GetitemDecimal(i, "sale_price_org") 	* ll_sale_qty	 - dw_body.GetitemDecimal(i, "sale_price") 	* ll_sale_qty	
		ll_sale_QTY_chk = ll_sale_qty
	end if	
						
	ll_sale_amt_dc	= ll_sale_amt_dc + ll_sale_amt_chk_dc // 적용 할인 금액				
	ll_sum_chk_amt = ll_sum_chk_amt + ll_sale_amt_chk	 // 적용해당 판매금액
	ll_sum_chk_QTY1 = ll_sum_chk_QTY1 + ll_sale_QTY_chk	 // 적용해당 판매수량
	
NEXT


if ll_sum_chk_QTY <= li_style_cnt then	//한계 수량 li_style_cnt
	
	if is_kakao_apply = "M" then

			messagebox("알림!" , "할인 미적용대상 품번을 제외한 합계 수량 2장, 추가 10%(총할인 합계 10만원 이하) 할인이 적용됩니다!")				
		
	elseif is_kakao_apply = "N" then

			messagebox("알림!" , "할인 M라인 품번을 대상 합계 수량 2장, 추가 10%(총할인 합계 10만원 이하) 할인이 적용됩니다!")				
//			messagebox("알림!" , "할인 미적용대상 품번을 제외한 합계 수량 2장, 추가 10%(총할인 합계 10만원 이하) 할인이 적용됩니다!")		
	
	elseif is_kakao_apply = "O" then
		
			messagebox("알림!" , "할인 M라인 품번을 대상 합계 수량 2장, 추가 10%(총할인 합계 10만원 이하) 할인이 적용됩니다!")					
			
	elseif is_kakao_apply = "P" then
		
			messagebox("알림!" , "할인 M라인 품번을 대상 합계 수량 2장, 추가 10%(총할인 합계 10만원 이하) 할인이 적용됩니다!")								
	
	end if	
		
end if	



//합계 만원 이상이고 총할인 10만원 밑으로 할인중인경우
if ll_sum_chk_amt >= ll_limit_amt and ll_dc_limit_amt > ll_sale_amt_dc then
	
	ll_sale_amt_dc = 0
	ll_sale_amt_chk = 0
	ll_sale_amt_chk_dc = 0
	ll_sum_chk_QTY = 0
	
	FOR i=1 TO ll_row_count
	
						ll_tag_price     = dw_body.GetitemDecimal(i, "tag_price") 
						ll_curr_price    = dw_body.GetitemDecimal(i, "curr_price") 
						ll_out_price     = dw_body.GetitemNumber(i, "out_price") 
						ll_collect_price = dw_body.GetitemNumber(i, "collect_price")
						ll_sale_qty = dw_body.GetitemNumber(i, "sale_qty")
						ll_sale_price_org = dw_body.GetitemNumber(i, "c_sale_price")
						ll_sale_price_org = dw_body.GetitemNumber(i, "sale_price_org")
						ldc_dc_rate_org = dw_body.GetitemNumber(i, "dc_rate_org")
						ldc_marjin_org = dw_body.GetitemNumber(i, "sale_rate")
						ls_sale_type = dw_body.Getitemstring(i, "sale_type")
						ls_year = dw_body.Getitemstring(i, "year")
						ls_season = dw_body.Getitemstring(i, "season")
						LS_CHK_COUPON = dw_head.GetItemString(i, "EMPTY_3")
						ls_style = dw_body.Getitemstring(i, "style")
						
//			
//						SELECT COUNT(*)
//						INTO :LL_SALE_CHK
//						FROM TB_56010_M X (NOLOCK)
//						WHERE SHOP_CD = :GS_SHOP_CD
//						AND :IS_YYMMDD BETWEEN START_YMD AND END_YMD
//						AND SALE_TYPE = '11'
//						AND X.DC_RATE <= 9
//						AND X.SALE_TYPE = :LS_SALE_TYPE;			
						
						
						
			if is_kakao_apply = "N" then
			
				 SELECT COUNT(*)
					INTO :LL_SALE_CHK
					FROM TB_56010_M X (NOLOCK)
					WHERE SHOP_CD = :GS_SHOP_CD
					AND :IS_YYMMDD BETWEEN START_YMD AND END_YMD
					AND SALE_TYPE <= '22'
					AND X.DC_RATE <= 30 //IN ( 0, 10, 20) 
					AND X.SALE_TYPE = :LS_SALE_TYPE;
					
			elseif is_kakao_apply = "O" or  is_kakao_apply = "P"  then
				// O: 250909 이규호 2025년 M라인 여름(M), 사계절(X) 상품, 균일가 포함
				// P: 250909 이규호 25년 M라인 가을(A) 상품 현판가 기준 추가 10% 적용
			
				 SELECT COUNT(*)
					INTO :LL_SALE_CHK
					FROM TB_56010_M X (NOLOCK)
					WHERE SHOP_CD = :GS_SHOP_CD
					AND :IS_YYMMDD BETWEEN START_YMD AND END_YMD
					AND SALE_TYPE <= '22'
					AND X.DC_RATE <= 30 //IN ( 0, 10, 20) 
					AND X.SALE_TYPE = :LS_SALE_TYPE;					
							
			else							
	
				 SELECT COUNT(*)
					INTO :LL_SALE_CHK
					FROM TB_56010_M X (NOLOCK)
					WHERE SHOP_CD = :GS_SHOP_CD
					AND :IS_YYMMDD BETWEEN START_YMD AND END_YMD
					AND SALE_TYPE = '11'
					AND X.DC_RATE < 10 //IN ( 0, 10, 20) 
					AND X.SALE_TYPE = :LS_SALE_TYPE;
					
			end if
						
												
						if is_yymmdd >= '20250801' then
							
							if is_kakao_apply = "N" then
								select count(*)
								into :ll_year_chk
								from 
								(		
								select  '2025' as year, 'M' as season
								union 	
								select  '2025' as year, 'A' as season
								union 	
								select  '2025' as year, 'W' as season
								union 	
								select  '2025' as year, 'X' as season
								
								) a
								where   a.year = :ls_year
								and     a.season = :ls_season ;

												// O: 250909 이규호 2025년 M라인 여름(M), 사계절(X) 상품, 균일가 포함
												// P: 250909 이규호 25년 M라인 가을(A) 상품 현판가 기준 추가 10% 적용

							elseif is_kakao_apply = "O" then
								select count(*)
								into :ll_year_chk
								from 
								(		
								select  '2025' as year, 'M' as season, 'M' as brand
								union 	
								select  '2025' as year, 'X' as season, 'M' as brand
								
								) a
								where   a.year = :ls_year
								and     a.season = :ls_season
								and     a.brand  = left(:ls_style,1)	;				
								
							elseif is_kakao_apply = "P" then
								select count(*)
								into :ll_year_chk
								from 
								(		
								select  '2025' as year, 'A' as season, 'M' as brand						
								) a
								where   a.year = :ls_year
								and     a.season = :ls_season
								and     a.brand  = left(:ls_style,1)	;									
								
							else
								select count(*)
								into :ll_year_chk
								from 
								(		
								select  '2025' as year, 'A' as season
								union 	
								select  '2025' as year, 'W' as season
								union 	
								select  '2025' as year, 'X' as season
								
								) a
								where   a.year = :ls_year
								and     a.season = :ls_season ;
							end if
							
						else
							select count(*)
							into :ll_year_chk
							from 
							(		
								select  '2025' as year, 'S' as season
								union 	
								select  '2025' as year, 'M' as season
								union 	
								select  '2025' as year, 'A' as season
								union 	
								select  '2025' as year, 'W' as season
								union 	
								select  '2025' as year, 'X' as season
							) a
							where   a.year = :ls_year
							and     a.season = :ls_season ;
						end if																
				
					//	messagebox("", mid(as_style, 1,1))
				
			// N타입 쿠폰 M라인 5MX적용	
				// O: 250909 이규호 2025년 M라인 여름(M), 사계절(X) 상품, 균일가 포함
				// P: 250909 이규호 25년 M라인 가을(A) 상품 현판가 기준 추가 10% 적용
			if is_kakao_apply = "N" and upper(mid(ls_style, 1,1)) <> "M"  then
				ll_year_chk = 0
				GOTO SKIP	
			end if						
			
			if is_kakao_apply = "O" and upper(mid(ls_style, 1,1)) <> "M"  then
				ll_year_chk = 0
				GOTO SKIP	
			end if		
				
			if is_kakao_apply = "P" and upper(mid(ls_style, 1,1)) <> "M"  then
				ll_year_chk = 0
				GOTO SKIP	
			end if		
				
				
			//판매 형태 ,적용년도 시즌 쳌크				
			if ll_sale_chk < 1  or ll_year_chk <= 0 then
				//	messagebox("알림!", "해당품번은 쿠폰 적용 가능한 판매형태의 제품이  아닙니다!")
					GOTO SKIP				
			end if	
								
			//총할인금액 넘을경우 체크
			if ll_sale_amt_dc > ll_dc_limit_amt then								 
				
				GOTO SKIP				
				//적용가능 할인 금액 잔액

			end if	
			
			if ll_sum_chk_QTY  >= li_style_cnt then		
				messagebox("알림!", "할인 적용 수량 초과로 할인에서 제외 됩니다!")
		
				GOTO SKIP								

			end if	
								
						//마진 체크 
						select count(*)
						into :ldc_margin_cnt
						from tb_56010_m (nolock)
						where shop_cd = :gs_shop_cd
						and :is_yymmdd between start_ymd and end_ymd
						and sale_type = :ls_sale_type
						and dc_rate =  :ldc_dc_rate_org ;
						
						if ldc_margin_cnt < 1 then
						//messagebox("알림!", "마지체크오류!")
							GOTO SKIP //return
						end if	
							
						select marjin_rate
						into :ldc_marjin
						from tb_56010_m (nolock)
						where shop_cd = :gs_shop_cd
						and :is_yymmdd between start_ymd and end_ymd
						and sale_type = :ls_sale_type
						and dc_rate =  :ldc_dc_rate_org ;
					
						
												
						
						ldc_dc_rate_org1 = (1 - (ll_sale_price_org /ll_tag_price)) * 100			
						
						if   is_yymmdd >= "20250101"  then
							
							ll_sale_price = ll_tag_price  * (100 - ldc_dc_rate_org1) / 100
							ll_sale_price = ll_sale_price * (100 - ldc_plus_rate) / 100
					
						else 
							ll_sale_price = ll_tag_price  * (100 - ldc_dc_rate_org) / 100
							ll_sale_price = ll_sale_price * (100 - ldc_plus_rate) / 100
						end if	
						
					
						
						dw_body.Setitem(i, "sale_price",  ll_sale_price)
						dw_body.Setitem(i, "tag_amt",  ll_tag_price  * al_sale_qty)
						dw_body.Setitem(i, "curr_amt", ll_curr_price * al_sale_qty)
						dw_body.Setitem(i, "sale_amt", ll_sale_price * al_sale_qty)
						dw_body.Setitem(i, "out_amt",  ll_out_price  * al_sale_qty) 
						dw_body.Setitem(i, "sale_type",  ls_sale_type) 
						dw_body.Setitem(i, "empty_3",  is_coupon_no) 
						dw_body.Object.sale_qty.Protect=1
																	
						ll_test = dw_body.GetitemDecimal(i, "sale_price_org")	* al_sale_qty	- dw_body.GetitemDecimal(i, "sale_price")	* al_sale_qty
	
	
						// 할인잔액보다 할인이 클경우 잔액만 할인 적용
						if ll_sum_dc > 0 and ll_sum_dc <	 dw_body.GetitemDecimal(i, "sale_price_org")	* al_sale_qty	- dw_body.GetitemDecimal(i, "sale_price")	* al_sale_qty then						
							ll_sale_price = ll_tag_price  * (100 - ldc_dc_rate_org1) / 100
							ll_sale_price = ll_sale_price - ( ll_sum_dc / al_sale_qty )
							
							
							dw_body.Setitem(i, "sale_price",  ll_sale_price)
							dw_body.Setitem(i, "sale_amt", ll_sale_price * al_sale_qty)
							
						end if	
																	
																	
						// 최종 할인율 확인 																	
						ldc_dc_rate = (1 - ll_sale_price / ll_tag_price) * 100
						
						
						if mid(ls_sale_type,1,1) = "3" then
							dw_body.Setitem(i, "curr_price", ll_curr_price)		
							dw_body.Setitem(i, "dc_rate",  0) 
							
						else
							dw_body.Setitem(i, "dc_rate",  ldc_dc_rate) 	
						end if	
							
						dw_body.Setitem(i, "sale_rate",  ldc_marjin) 
						
						ll_goods_amt = dw_body.GetitemDecimal(i, "goods_amt") 
						
						gf_marjin_price(gs_shop_cd, (ll_sale_price * al_sale_qty), ldc_marjin, ll_sale_collect1)

						ll_sale_collect = ll_sale_collect1 //- (ll_goods_amt * ldc_marjin / 100)
						dw_body.Setitem(i, "sale_collect", ll_sale_collect) 
								
						/* 세일 재매입 처리 */
				//		gf_marjin_price(gs_shop_cd, (ll_sale_price * al_sale_qty), ldc_marjin, ll_sale_collect)  					
						ll_io_amt = (ll_out_price  * al_sale_qty) - ll_sale_collect
						dw_body.Setitem(i, "io_amt", ll_io_amt)
						dw_body.Setitem(i, "io_vat", ll_io_amt - Round(ll_io_amt / 1.1, 0))
						
						ll_sale_amt_chk = dw_body.GetitemDecimal(i, "sale_price_org") 	* ll_sale_qty	
						ll_sale_amt_chk_dc = dw_body.GetitemDecimal(i, "sale_price_org") 	* ll_sale_qty	 - dw_body.GetitemDecimal(i, "sale_price") 	* ll_sale_qty	
						
						ll_sale_amt_dc	= ll_sale_amt_dc + ll_sale_amt_chk_dc // 적용 할인 금액				
						ll_sum_chk_amt = ll_sum_chk_amt + ll_sale_amt_chk	 // 적용해당 판매금액
						ll_sum_chk_QTY = ll_sum_chk_QTY + ll_sale_qty	 // 적용해당 판매수량	
						ll_sum_dc = ll_dc_limit_amt - ll_sale_amt_dc
						
						//messagebox("할인수량ll_sum_chk_QTY ", string(ll_sum_chk_QTY, "0000"))						
						//messagebox("할인잔액ll_sum_dc ", string(ll_sum_dc, "0000"))
						//messagebox("총할인금액ll_sale_amt_dc", string(ll_sale_amt_dc, "0000"))
								
						
								
		SKIP:								
								
		NEXT
end if		
								

end subroutine

public function boolean wf_style_chk (long al_row, string as_style_no);
String ls_style, ls_chno, ls_color,  ls_size, ls_shop_type, ls_given_fg, ls_given_ymd, ls_shop_type_1, ls_dotcom,ls_shop_div
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn , LS_RTRN_YMD , ls_work_gubn, ls_date, ls_shop_cd, LS_CLOSE_CHK
Long   ll_tag_price, ll_ord_qty, ll_ord_qty_chn , ll_cnt
decimal ldc_sale_qty
integer li_style_cnt
// ldc_sale_price_1

dw_head.accepttext()
ls_date = string(dw_head.GetItemDate(1,'yymmdd'))
ls_date = mid(ls_date,1,4) + mid(ls_date,6,2) + mid(ls_date,9,2)

IF Len(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = Mid(as_style_no, 1, 8)
ls_chno  = Mid(as_style_no, 9, 1)
ls_color = Mid(as_style_no, 10, 2)
ls_size  = Mid(as_style_no, 12, 2)

//MESSAGEBOX("",is_close_ymd_t)

// 반품용 프로시져도 제한 
// SP_SH101_D31
// SP_SH101_D34
if mid(gs_shop_cd,3,4) >= "1900" and mid(gs_shop_cd,3,4) <= "1913" then 
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
		and brand_grp = :gs_brand_grp
		and sojae  <> 'C'   ;
		//and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
			

elseif mid(gs_shop_cd,2,5) = "X2710" then 
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
		
elseif gs_brand = 'D' then 
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
		

elseif  gs_brand = "O" or gs_brand = 'Y' then
	if ls_date <= is_close_ymd_t then
		//마감일자 전의 판매
		//정상+행사
		if is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'Y' then					
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
 			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= :is_year_f + :is_season_s_f )
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
 			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp			 where brand = :gs_brand 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= :is_year_f + :is_season_s_f ) 
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
 			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= :is_year_t + :is_season_s_t ) 
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
 			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= :is_year_t + :is_season_s_t ) 
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
elseif  gs_brand = "N" then
	if ls_date <= is_close_ymd_t then
		//마감일자 전의 판매
		//정상+행사
		if is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'Y' then					
			Select brand,     year,     season,     
					 sojae,     item,     tag_price,     plan_yn   
			  into :ls_brand, :ls_year, :ls_season, 
					 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
			  from vi_12024_1 with (nolock)
//			 where brand like case when left(:gs_shop_cd,1) IN ('N','J') then '[NJ]%' else :gs_brand  + '%' end
//			 where brand_grp  LIKE '%' + :gs_brand + '%' //= :gs_brand_grp
			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= :is_year_f + :is_season_s_f )
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
//			 where brand_grp  LIKE '%' + :gs_brand + '%' // = :gs_brand_grp //brand like case when left(:gs_shop_cd,1) IN ('N','J') then '[NJ]%' else :gs_brand  + '%' end
			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp			 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= :is_year_f + :is_season_s_f ) 
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
//			 where brand_grp  LIKE '%' + :gs_brand + '%' // = :gs_brand_grp //brand like case when left(:gs_shop_cd,1) IN ('N','J') then '[NJ]%' else :gs_brand  + '%' end
			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp			 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= :is_year_t + :is_season_s_t ) 
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
//			 where brand_grp = :gs_brand_grp // brand like case when left(:gs_shop_cd,1) IN ('N','J') then '[NJ]%' else :gs_brand  + '%' end
			 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp			 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and sojae  <> 'C' 		
				and isnull(for_lotte,'N') <>  case when :gs_shop_div = 'L' then 'N' else 'Y' end
				and ( 
						(  
							( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= :is_year_t + :is_season_s_t ) 
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
else 	
		Select brand,     year,     season,     
			 sojae,     item,     tag_price,     plan_yn   
	  into :ls_brand, :ls_year, :ls_season, 
			 :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
	  from vi_12024_1 with (nolock)
//	 where brand_grp LIKE '%' + :gs_brand + '%'
	 where :gs_brand_grp  LIKE '%' + brand + '%' //= :gs_brand_grp	 
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
		
		
 

end if

IF SQLCA.SQLCODE <> 0 THEN 
	messagebox("확인","시즌마감되어 등록이 불가능합니다! 관리팀에 연락 바랍니다!")
	Return False 
END IF


Select isnull(ord_qty,0), isnull(ord_qty_chn,0)
  into :ll_ord_qty, :ll_ord_qty_chn  
  from tb_12030_s with (nolock)
 where style = :ls_style 
	and chno  = :ls_chno
	and color = :ls_color 
	and size  = :ls_size;
	
if gs_brand <> 'M' then
	if ll_ord_qty - ll_ord_qty_chn <= 0  then 
		messagebox("경고!", "국내 판매등록이 불가능한 제품입니다!")
		return false
	end if	
end if	



ll_cnt = 0

ls_dotcom	= dw_body.GetitemString(al_row, "dotcom")
if IsNull(ls_dotcom) or Trim(ls_dotcom) = "" then
//   MessageBox(ls_dotcom,ls_dotcom)
	ls_dotcom = '0'
end if

if mid(gs_shop_cd,1,2) = "NG" and is_yymmdd >= "20180901"  and ls_dotcom = '0' then 
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
elseif mid(gs_shop_cd,1,2) = "NG" and ls_dotcom = '1' then 
	
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
					
	
	
	Select shop_type
	into :ls_shop_type
	From tb_56012_d_color with (nolock)
	Where style      = :ls_style 
	  and color      = :ls_color
	  and start_ymd <= :is_yymmdd
	  and end_ymd   >= :is_yymmdd
	  and shop_type <> '9'
	  and shop_cd    = :Ls_shop_cd
	  group by shop_type;
	
			if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then	
				Select shop_type
				into :ls_shop_type
				From tb_56012_d with (nolock)
				Where style      = :ls_style 
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and shop_type <> '9'
				  and shop_cd    = :Ls_shop_cd ;
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
if ls_shop_type > "3"  and left(gs_shop_cd ,1) <> "Y" then 
	messagebox("경고!", "정상 판매등록이 불가능한 제품입니다!  닷컴 한정 상품은 닷컴 체크를 먼저 하시고 등록 바랍니다!")
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

if LS_DOTCOM = "1" or gs_shop_div = "H" then
  LS_RTRN_YMD = "99999999"// IS_YYMMDD
end if  

if gs_user_id <> 'IE1912'  then //주소연대리 요청 : 압구정CJ몰 판매가능하게(20130723)
	if gs_shop_div <> 'O' then //상설점은 부진처리 후에도 정상으로 판매가능하게 (20140722)
		if ls_shop_type < "3" then 
			IF LS_RTRN_YMD <= IS_YYMMDD THEN 
				messagebox("경고!", "부진적용일이후 정상 판매,반품등록은 불가능합니다! 관리팀에 연락 바랍니다! ")
				messagebox("알림!", "닷컴 한정 상품은 닷컴 체크를 먼저 하시고 등록 바랍니다!")								 
				dw_body.SetItem(al_row, "style_no", "")
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
	messagebox("품번체크", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")
	return false
end if 	

//       FUNCTION SF_season_llose_chk
//	(@st_brand	VARCHAR(1),
//	 @shop_brand	VARCHAR(1),
//	 @year		varchar(04),
//	 @season	varchar(01),
//	 @shop_cd	varchar(06),
//	 @STYLE		VARCHAR(08),
//	 @yymmdd	varchar(08)
//
//)
SELECT DBO.SF_season_Close_chk(left(:ls_style,1), left(:gs_brand,1),:ls_year, :ls_season, :gs_shop_cd, :ls_style, :is_yymmdd)
into :ls_close_chk
from dual;


if ls_close_chk = "C" then
	messagebox("알림!", ls_year + "/" + ls_season + " 판매마감 상품으로 등록이 불가 합니다!" )
	return false
end if	

select count(style)
into :li_style_cnt
from tb_except_style_202007 (nolock)
where style = :ls_style;


if li_style_cnt > 0 and is_empno <> "000000"  then
	messagebox("알림!", "사우행사 대상 제품이 아닙니다!")
	return false
end if	



select work_gubn, given_ymd
into :ls_work_gubn, :ls_given_ymd
from beaucre.dbo.tb_56040_m with (nolock)
where style like :ls_style + '%'
and  shop_brand like '%' + :gs_brand + '%'
and   gubn = 'C';

IF ( ls_work_gubn = "S" or ls_work_gubn = "A" ) and ls_given_ymd <= is_yymmdd THEN 
	messagebox("품번검색", ls_given_ymd + "일자로 판매불가로 전환된 제품입니다!")					
	return false 	
END IF 		


dw_body.SetItem(al_row, "tag_price", ll_tag_price) 
IF ls_plan_yn = 'Y' THEN 
	dw_body.Setitem(al_row, "shop_type", '3')
ELSE
	if left(gs_shop_cd,1) <> "Y" then
		dw_body.Setitem(al_row, "shop_type", '1')
	else 	
		dw_body.Setitem(al_row, "shop_type", ls_shop_type)	
	end if	
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

on w_sh101_e.create
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
this.st_ok_coupon1=create st_ok_coupon1
this.st_ok_coupon2=create st_ok_coupon2
this.dw_16=create dw_16
this.shl_member=create shl_member
this.dw_17=create dw_17
this.dw_18=create dw_18
this.dw_19=create dw_19
this.dw_cosmetic=create dw_cosmetic
this.em_1=create em_1
this.st_7=create st_7
this.dw_20=create dw_20
this.dw_21=create dw_21
this.st_8=create st_8
this.cb_3=create cb_3
this.st_online_gubn=create st_online_gubn
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_online_id=create st_online_id
this.sle_id=create sle_id
this.cb_online_coupon=create cb_online_coupon
this.cb_emp_sale=create cb_emp_sale
this.cb_kakao_coupon=create cb_kakao_coupon
this.st_9=create st_9
this.dw_22=create dw_22
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
this.Control[iCurrent+28]=this.st_ok_coupon1
this.Control[iCurrent+29]=this.st_ok_coupon2
this.Control[iCurrent+30]=this.dw_16
this.Control[iCurrent+31]=this.shl_member
this.Control[iCurrent+32]=this.dw_17
this.Control[iCurrent+33]=this.dw_18
this.Control[iCurrent+34]=this.dw_19
this.Control[iCurrent+35]=this.dw_cosmetic
this.Control[iCurrent+36]=this.em_1
this.Control[iCurrent+37]=this.st_7
this.Control[iCurrent+38]=this.dw_20
this.Control[iCurrent+39]=this.dw_21
this.Control[iCurrent+40]=this.st_8
this.Control[iCurrent+41]=this.cb_3
this.Control[iCurrent+42]=this.st_online_gubn
this.Control[iCurrent+43]=this.rb_1
this.Control[iCurrent+44]=this.rb_2
this.Control[iCurrent+45]=this.st_online_id
this.Control[iCurrent+46]=this.sle_id
this.Control[iCurrent+47]=this.cb_online_coupon
this.Control[iCurrent+48]=this.cb_emp_sale
this.Control[iCurrent+49]=this.cb_kakao_coupon
this.Control[iCurrent+50]=this.st_9
this.Control[iCurrent+51]=this.dw_22
end on

on w_sh101_e.destroy
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
destroy(this.st_ok_coupon1)
destroy(this.st_ok_coupon2)
destroy(this.dw_16)
destroy(this.shl_member)
destroy(this.dw_17)
destroy(this.dw_18)
destroy(this.dw_19)
destroy(this.dw_cosmetic)
destroy(this.em_1)
destroy(this.st_7)
destroy(this.dw_20)
destroy(this.dw_21)
destroy(this.st_8)
destroy(this.cb_3)
destroy(this.st_online_gubn)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_online_id)
destroy(this.sle_id)
destroy(this.cb_online_coupon)
destroy(this.cb_emp_sale)
destroy(this.cb_kakao_coupon)
destroy(this.st_9)
destroy(this.dw_22)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(cb_1, "FixedToRight")
inv_resize.of_Register(cb_2, "FixedToRight")
inv_resize.of_Register(cb_3, "FixedToRight")
inv_resize.of_Register(cb_emp_sale, "FixedToRight")
inv_resize.of_Register(cb_kakao_coupon, "FixedToRight")
inv_resize.of_Register(st_1, "ScaleToRight&Bottom")
//inv_resize.of_Register(dw_1, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_1, "FixedToBottom")
inv_resize.of_Register(dw_22, "FixedToRight&Bottom")
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
inv_resize.of_Register(dw_16, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_18, "FixedToBottom&ScaleToRight")

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
dw_16.SetTransObject(SQLCA)
dw_18.SetTransObject(SQLCA)
dw_19.SetTransObject(SQLCA)
dw_cosmetic.SetTransObject(SQLCA)
dw_21.SetTransObject(SQLCA)
dw_20.SetTransObject(SQLCA)
dw_22.SetTransObject(SQLCA)
dw_20.insertRow(0)
dw_list.SetTransObject(SQLCA)
dw_member_sale.SetTransObject(SQLCA)
dw_back_sale.SetTransObject(SQLCA)
dw_1.insertRow(0)

// ok쿠폰 적용 설명
if gs_brand <> 'O' then  
	st_ok_coupon1.visible = false
	st_ok_coupon2.visible = false
end if

//코인코즈 압구정직영점만 해당됨 20130416.
//지나미 가로수길 추가 20131014
if gs_shop_cd = 'GB1807' or gs_shop_cd = 'TB1004' or mid(gs_shop_cd,2,5) = 'X2710' then
	cb_print.visible = true
else
	cb_print.visible = false
end if


//고판다쿠폰 20150923~20151231 명동메가,영플라자,가로수길,제주점만L 해당. 
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size, ls_shop_type, ls_given_fg, ls_given_ymd, LS_RTRN_YMD, ls_work_gubn, ls_for_lotte, ls_barcode, ls_g_style_no, ls_g_color, ls_g_size
Long       ll_row_cnt , ll_ord_qty, ll_ord_qty_chn, li_shop_cnt
Boolean    lb_check 
string ls_shop_snm, ls_ok, ls_date, ls_dotcom, ls_shop_cd, ls_shop_div, ls_close_chk, ls_year, ls_season
integer li_style_cnt
DataStore  lds_Source 

dw_head.accepttext()

ls_date = string(dw_head.GetItemDate(1,'yymmdd'))
ls_date = mid(ls_date,1,4) + mid(ls_date,6,2) + mid(ls_date,9,2)

CHOOSE CASE as_column
	CASE "style_no"		
		if	mid(as_data,1,2) = '88' then
			
			select style_no
			into :ls_g_style_no 
			from tb_cosmetic_barcode with (nolock)
			where barcode = :as_data;

			select color, size
			into :ls_g_color, :ls_g_size
			from vi_12024_1
			where style + chno = :ls_g_style_no ;

			IF ai_div = 1 THEN 	
				as_data = ls_g_style_no + ls_g_color + ls_g_size
				
				IF wf_style_chk(al_row, as_data)  THEN
				   ll_row_cnt = dw_body.RowCount()
				   IF al_row = ll_row_cnt THEN 
					   ll_row_cnt = dw_body.insertRow(0)
				   END IF					
				   This.Post Event ue_tot_set()
					RETURN 0 
				END IF 
			END IF
			
		   ls_style = Mid(as_data, 1, 8)
		   ls_chno  = Mid(as_data, 9, 1)
		   ls_color = Mid(as_data, 10, 2)
		   ls_size  = Mid(as_data, 12, 2)
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com012" 
			
		else
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
		   ls_style = Mid(as_data, 1, 8)
		   ls_chno  = Mid(as_data, 9, 1)
		   ls_color = Mid(as_data, 10, 2)
		   ls_size  = Mid(as_data, 12, 2)
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com012" 
		end if
////////////////////////////////////////////////////////////////////////////////////////////////////////
		   IF GS_SHOP_DIV <> "L" THEN
				if mid(gs_shop_cd,3,4) >= "1900" and mid(gs_shop_cd,3,4) <= "1913" then 
					gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and  year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  >  '20054'  " 				 			
//				elseif gs_shop_cd = "NG0008" or gs_shop_cd = "NG1150"  or  gs_shop_cd = "OG0002" or  gs_shop_cd = "OH0002" then 
//					gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and  year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  >=  '20091'  " 				 			
					
				elseif gs_brand = "B" or gs_brand = "G" or gs_brand = "V" or gs_brand = 'L' or gs_brand = 'U' then 					
					gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and  year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  >  '20054'  " 				 			
					
				else
					if gs_brand = "O" or gs_brand = 'Y' then
						if ls_date <= is_close_ymd_t then
							//마감일자 전의 판매
							//정상+행사
							if is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'Y' then
								//gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_f+is_season_s_f+"' ) )" + &
							  gst_cd.default_where   = "WHERE  '" + gs_brand_grp + "' like '%' + brand + '%'  and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_f+is_season_s_f+"' ) )" + &
												" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
												" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') <> 'Y' "
							//정상+행사+기획
							elseif is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'N' then
								gst_cd.default_where   = "WHERE  '" + gs_brand_grp + "' like '%' + brand + '%'   and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_f+is_season_s_f+"' ) or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '"+is_year_f+is_season_s_f+"' and plan_yn = 'Y' )  )" + &
												" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
												" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') <> 'Y' "
							end if
						else
							//마감일자 후의 판매
							//정상+행사
							if is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'Y' then
								gst_cd.default_where   = "WHERE  '" + gs_brand_grp + "' like '%' + brand + '%'   and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_t+is_season_s_t+"' ) or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = case when brand = 'N' then '20175' else 'XX' end ) )" + &
												" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
												" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') <> 'Y' "
							//정상+행사+기획
							elseif is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'N' then
								gst_cd.default_where   = "WHERE  '" + gs_brand_grp + "' like '%' + brand + '%'   and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_t+is_season_s_t+"' ) or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '"+is_year_t+is_season_s_t+"' and plan_yn = 'Y' )  )" + &
												" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
												" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') <> 'Y' "
							end if
						end if
						
					ELSEif gs_brand = "N"  then  // N 매장 상설 판매등록 
						if ls_date <= is_close_ymd_t then
							//마감일자 전의 판매
							//정상+행사
							if is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'Y' then
//								gst_cd.default_where   = "WHERE brand IN ('N','J') and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_f+is_season_s_f+"' ) )" + &								
								gst_cd.default_where   = "WHERE  '" + gs_brand_grp + "' like '%' + brand + '%'  and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_f+is_season_s_f+"' ) )" + &
												" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
												" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') <> 'Y' "
							//정상+행사+기획
							elseif is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'N' then
								gst_cd.default_where   = "WHERE  '" + gs_brand_grp + "' like '%' + brand + '%'  and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_f+is_season_s_f+"' ) or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '"+is_year_f+is_season_s_f+"' and plan_yn = 'Y' )  )" + &
												" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
												" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') <> 'Y' "
							end if
						else
							//마감일자 후의 판매
							//정상+행사
							if is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'Y' then
								gst_cd.default_where   = "WHERE  '" + gs_brand_grp + "' like '%' + brand + '%'  and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_t+is_season_s_t+"' ) or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = case when brand = 'N' then '20175' else 'XX' end ) )" + &
												" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
												" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') <> 'Y' "
							//정상+행사+기획
							elseif is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'N' then
								gst_cd.default_where   = "WHERE   '" + gs_brand_grp + "' like '%' + brand + '%'  and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_t+is_season_s_t+"' ) or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '"+is_year_t+is_season_s_t+"' and plan_yn = 'Y' )  )" + &
												" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
												" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
												" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') <> 'Y' "
							end if
						end if						
						
						
					elseif gs_brand = 'B' or gs_brand = 'P' or gs_brand = 'K' or gs_brand = 'U' then
						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20101' ) )" + &
										" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
										" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
										" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
										" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and isnull(for_lotte,'N') <> 'Y' "
					else 
						gst_cd.default_where   = "WHERE   '" + gs_brand_grp + "' like '%' + brand + '%' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20101' ) )" + &
										" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
										" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
										" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
										" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') ))  and isnull(for_lotte,'N') <> 'Y' " 					
					end if					
				end if
			else
				if mid(gs_shop_cd,3,4) >= "1900" and mid(gs_shop_cd,3,4) <= "1913" then 
					gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and  year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  >  '20054'  " 				 			
				else
					if gs_brand = "N" then
//						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and ( ( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20104' ) or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20104'  and plan_yn = 'Y' )  )" + &		           								
//						gst_cd.default_where   = "WHERE dbo.sf_inter_cd2('001',brand) = '" + gs_brand_grp + "' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20101' ) )" + &
						gst_cd.default_where   = "WHERE '" + gs_brand_grp + "' like '%' + brand + '%'  and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20101' ) )" + &						
										" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
										" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
										" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
										" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') = 'Y' " 					
							
					elseif gs_brand = "O" then
//						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20101' ) )" + &																																				
						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and ( ( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20094' ) or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20094'  and plan_yn = 'Y' )  )" + &
										" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
										" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
										" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
										" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') = 'Y' " 					
					elseif gs_brand = 'B' or gs_brand = 'P' or gs_brand = 'K' then
//						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and ( ( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20091' ) or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20091'  and plan_yn = 'Y' )  )" + &		           		
						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20101' ) )" + &																										
										" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
										" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
										" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
										" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and isnull(for_lotte,'N') = 'Y' " 					
	
					else 
//						gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and ( ( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20091' ) or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20091'  and plan_yn = 'Y' )  )" + &		           		
						gst_cd.default_where   = "WHERE   '" + gs_brand_grp + "' like '%' + brand + '%' and (( ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20101' ) )" + &																										
										" or style in (select a.style from tb_56012_d a (nolock)	where a.shop_type = '3'	and a.sale_type = '33' " + &
										" and a.shop_cd = '" + gs_shop_cd + "' and '" + is_yymmdd + "' between a.start_ymd and a.end_ymd " + &
										" and  a.year + a.season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where '" + is_yymmdd + "' between a.frm_ymd and a.to_ymd " + &
										" and a.shop_cd = '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd and b.cancel <> 'Y') )) and sojae <> 'C' and isnull(for_lotte,'N') = 'Y' " 					
					end if					
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
				ls_chno  = lds_Source.GetItemString(1,"chno")
				ls_color = lds_Source.GetItemString(1,"color")
				ls_size = lds_Source.GetItemString(1,"size")					
				
				ls_year = lds_Source.GetItemString(1,"year")				
				ls_season = lds_Source.GetItemString(1,"season")								
				ls_dotcom	= dw_body.GetitemString(al_row, "dotcom")
				
//				messagebox("ls_dotcom", ls_dotcom)
				
				if IsNull(ls_dotcom) or Trim(ls_dotcom) = "" then
				//	MessageBox(ls_dotcom,ls_dotcom)
					ls_dotcom = '0'
				end if	

				if ls_dotcom = "1" then
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
							
				Select shop_type
				into :ls_shop_type
				From tb_56012_d_color with (nolock)
				Where style      = :ls_style 
				  and color      = :ls_color	
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and shop_type <> '9'
				  and shop_cd    = :ls_shoP_cd ;
				
				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
					Select shop_type
					into :ls_shop_type
					From tb_56012_d with (nolock)
					Where style      = :ls_style 
					  and start_ymd <= :is_yymmdd
					  and end_ymd   >= :is_yymmdd
					  and shop_type <> '9'
					  and shop_cd    = :ls_shoP_cd ;
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
				  and shop_cd    = :gs_shop_cd ;
				
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
			
	
			
				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
						ls_shop_type = "1"
					
						IF lds_Source.GetItemString(1,"plan_yn") = 'Y' THEN 
							ls_shop_type = "3"
							ELSE
							ls_shop_type = "1"
						END IF
					
				end if	
				
				if ls_shop_type > "3" and left(gs_shop_cd,1) <> "Y" then 
					messagebox("경고!", "정상 판매등록이 불가능한 제품입니다! 닷컴 한정 상품은 닷컴 체크를 먼저 하시고 등록 바랍니다! ")
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

				if LS_DOTCOM = "1" or gs_shop_div = "H" then
				  LS_RTRN_YMD = "99999999" // IS_YYMMDD
				end if  

				if gs_user_id <> 'IE1912' then //주소연대리 요청 : 압구정CJ몰 판매가능하게(20130723)
					if gs_shop_div <> 'O' then //장나영차장 요청 : 면세점은 부진처리 후에도 정상으로 판매가능하게 (20140722)
						if ls_shop_type < "3"  then 
							IF LS_RTRN_YMD <= IS_YYMMDD THEN 
								messagebox("경고!", "부진적용일이후 정상 판매,반품등록은 불가능합니다! 닷컴 한정 상품은 닷컴 체크를 먼저 하시고 등록 바랍니다!")
								dw_body.SetItem(al_row, "style_no", "")
								ib_itemchanged = FALSE						
								return 1
							END IF	
						end if					
					end if
				end if	

				
				select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX'), isnull(for_lotte,'N')
				into :ls_given_fg, :ls_given_ymd, :ls_for_lotte
				from beaucre.dbo.tb_12020_m with (nolock)
				where style like :ls_style + '%';
				
				IF ls_given_fg = "Y"  THEN 
					messagebox("품번검색", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				END IF 		

		   	IF gs_shop_div <> "L" and ls_for_lotte = "Y"  THEN 
					messagebox("품번검색", "전용상품으로 전용매장코드에서만 등록 가능합니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				END IF 		
				
				
		
				
				
				SELECT DBO.SF_season_Close_chk(left(:ls_style,1), left(:gs_brand,1),:ls_year, :ls_season, :gs_shop_cd, :ls_style, :is_yymmdd)
				into :ls_close_chk
				from dual;
				
				
				if ls_close_chk = "C" then
					messagebox("알림!", ls_year + "/" + ls_season + " 시즌 마감 상품으로 등록이 불가 합니다!" )
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				end if	


			   select work_gubn, given_ymd
				into :ls_work_gubn, :ls_given_ymd
				from beaucre.dbo.tb_56040_m with (nolock)
				where style like :ls_style + '%'
				and   gubn = 'C';
				
				IF (ls_work_gubn = "S" or ls_work_gubn = "A") and ls_given_ymd <= is_yymmdd THEN 
					messagebox("품번검색", ls_given_ymd + "일자로 판매불가로 전환된 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				END IF 		


		
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
				
				
				

				select count(style)
				into :li_style_cnt
				from tb_except_style_202007 (nolock)
				where style = :ls_style;
				
				
				if li_style_cnt > 0 and is_empno <> "000000"  then
					messagebox("알림!", "사우행사 대상 제품이 아닙니다!")
					return 1
				end if	

				dw_body.Setitem(al_row, "shop_type", ls_shop_type)
		
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
					wf_style_set(al_row, ls_style, is_yymmdd, 1)  
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
string ls_title , ls_saup_gubn, ls_apply_type
long ll_ret, ll_used_cnt, ll_kakao_chk
int  li_shop_chk



IF as_cb_div = '1' THEN
	ls_title = "조회오류"
ELSEIF as_cb_div = '2' THEN
	ls_title = "추가오류"
ELSEIF as_cb_div = '3' THEN
	ls_title = "저장오류"
ELSE
	ls_title = "오류"
END IF

st_9.text = ""
cb_delete.visible = true
		
IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

if mid(gs_shop_cd,3,4) = '2000' and gs_brand <> "E" then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

if mid(gs_shop_cd,2,1) = 'I' and gs_brand =  "N" then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
//	open(W_SH133_E)//, '행사판매일보등록') // 온앤온행사분리매장
	return false
end if	

if gs_brand =  "J" then
	messagebox("주의!", '상설 매장에서는 사용할 수 없습니다!')
//	open(W_SH133_E)//, '행사판매일보등록') // 온앤온행사분리매장
	return false
end if	

is_yymmdd  = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")
is_sale_no = dw_head.GetitemString(1, "sale_no")
is_kakao_apply = "X"



//if is_yymmdd >= "20201224" and is_yymmdd <= "20201227"  and gs_shop_cd = "NG1193"  and as_cb_div <> "1" then

if is_yymmdd >= "20240101" and is_yymmdd <= "20240131"  and gs_shop_cd = "NX0006"  and as_cb_div = "2" then	
	
	
	if is_empno_stat <> "Y" then
		ll_ret = MessageBox("확인!", "사우행사 판매등록을 진행하시겠습니까?", Exclamation!, OKCancel!, 2)
	else 	
		ll_ret = 1
	end if	
	
	IF ll_ret = 1 THEN 
		
		dw_head.object.t_1.visible = true
		dw_head.object.t_1.text = "쿠폰(사번):"		
		dw_head.object.empno.visible = true	
		dw_head.object.coupon_no.visible = false
		is_empno_stat  = ""
	//	dw_head.object.emp_nm.visible = true		
		
		is_empno = dw_head.GetItemString(1, "empno")
		if IsNull(is_empno) or Trim(is_empno) = "" then
			MessageBox(ls_title,"사우행사 판매인 경우 사번을 입력 하셔야 할인이 적용됩니다!")
			dw_head.SetFocus()
			dw_head.SetColumn("empno")
			return false
		end if	
		
		select case when right(saup_gubn,1) <> "2" then "1" else "2" end
		into :ls_saup_gubn
		from VIEW_emp_sale
		where empno = :is_empno
		and saup_gubn not like '_2%';	

		
		if IsNull(ls_saup_gubn) or Trim(ls_saup_gubn) = "" then
			MessageBox(ls_title,"유효한 사번이 아닙니다!")
			dw_head.SetFocus()
			dw_head.Setitem(1, "empno", "")			
			dw_head.SetColumn("empno")
			return false
		end if	
		
// 쿠폰 사용 횟수 체한 없이 진행 		
//		select beaucre.dbo.SF_coupon_used_cnT(:is_empno, :gs_shop_cd)
//		into :ll_used_cnt
//		from dual;	
//		
//	
//		
//		if  ll_used_cnt >= 1 then
//			MessageBox(ls_title,"쿠폰사용 사용한도 초과된 사번입니다! 영업부에 문의 하세요!")
//			dw_head.SetFocus()
//			dw_head.Setitem(1, "empno", "")			
//			dw_head.SetColumn("empno")
//			return false
//		end if			

	ELSE
	
	dw_head.object.t_1.visible = false
	dw_head.object.empno.visible = false	
//	dw_head.object.emp_nm.visible = false		
	is_empno = "000000"
	is_coupon_no = "000000000000"	
	is_empno_stat  = "N"

	END IF	
	
	Return true 	
	
 elseif as_cb_div = "4" then
		
		if is_empno_stat <> "Y" then
			ll_ret = MessageBox("확인!", "카카오 쿠폰 사용을 진행하시겠습니까?", Exclamation!, OKCancel!, 2)
		else 	
			ll_ret = 1
		end if	
		
		IF ll_ret = 1 THEN 
			
			dw_head.object.t_1.visible = true
			dw_head.object.t_1.text = "쿠폰번호:"					
			dw_head.object.empno.visible = false	
			dw_head.object.coupon_no.visible = true	
			is_empno_stat  = "Y"
		//	dw_head.object.emp_nm.visible = true		
			
			
			if ( gs_brand <> "D"  and gs_brand <> "A" ) then
				is_coupon_no = dw_head.GetItemString(1, "coupon_no")
				if IsNull(is_coupon_no) or Trim(is_coupon_no) = "" or len(is_coupon_no) < 11  then
					MessageBox(ls_title,"모바일 화면의 쿠폰 번호를 정확히 입력하셔야  할인이 적용됩니다!")
					dw_head.SetFocus()
					dw_head.SetColumn("coupon_no")
					return false
				end if	
				
				  //쿠폰에 매장코드 지정 확인
					select count(*)
					into :li_shop_chk
					from tb_91100_m (nolock)
					where shop_cd = right(:is_coupon_no,6);
				
				if li_shop_chk >= 1 then // 쿠폰에 매장코드 지정
				
					select count(*), isnull(apply_type, 'D')
					into :ll_kakao_chk, :ls_apply_type
					from tb_71011_kakao (nolock)
					where  apply_brand like '%' + :gs_brand + '%'
					and :is_yymmdd between start_ymd and end_ymd
					and coupon_no = :is_coupon_no
					and accept_flag = 'N'
					and right(coupon_no,6) = :gs_shop_cd	
					group by isnull(apply_type, 'D');
				
				else 			 // 쿠폰에 매장코드 미지정	
					
					select count(*), isnull(apply_type, 'D')
					into :ll_kakao_chk, :ls_apply_type
					from tb_71011_kakao (nolock)
					where  apply_brand like '%' + :gs_brand + '%'
					and :is_yymmdd between start_ymd and end_ymd
					and coupon_no = :is_coupon_no
					and accept_flag = 'N'
					group by isnull(apply_type, 'D');					
					
				end if
				
			else 			
				is_coupon_no = dw_head.GetItemString(1, "coupon_no")
				if IsNull(is_coupon_no) or Trim(is_coupon_no) = "" or len(is_coupon_no) < 15  then
					MessageBox(ls_title,"모바일 화면의 쿠폰 번호를 정확히 입력하셔야  할인이 적용됩니다!")
					dw_head.SetFocus()
					dw_head.SetColumn("coupon_no")
					return false
				end if	
				
				
				select count(*), isnull(apply_type, 'D')
				into :ll_kakao_chk, :ls_apply_type
				from tb_71011_kakao (nolock)
				where  apply_brand like '%' + :gs_brand + '%'
				and :is_yymmdd between start_ymd and end_ymd
				and coupon_no = :is_coupon_no
				and accept_flag = 'N'
				and right(coupon_no,6) = :gs_shop_cd	
				group by isnull(apply_type, 'D');
			end if 
			
			
		   if isnull(ls_apply_type) then
				is_kakao_apply = "D"
			else 
				is_kakao_apply = ls_apply_type
			end if	
			
			if IsNull(ll_kakao_chk) or ll_kakao_chk <= 0 then
				MessageBox(ls_title,"유효한 쿠폰번호가 아닙니다!")
				dw_head.SetFocus()
				dw_head.Setitem(1, "coupon_no", "")			
				dw_head.SetColumn("coupon_no")
				is_coupon_no = "000000000000"	
				return false
			end if	
			
			select beaucre.dbo.SF_coupon_used_cnT(:is_coupon_no, :gs_shop_cd)
			into :ll_used_cnt
			from dual;	
			
			
			if ll_used_cnt >= 1 then
				MessageBox(ls_title,"사용된 쿠폰 입니다! 영업부에 문의 하세요!")
				dw_head.SetFocus()
				dw_head.Setitem(1, "coupon_no", "")			
				dw_head.SetColumn("coupon_no")
				return false
			end if					
		
		   if is_kakao_apply = "A" then 
				MessageBox(ls_title,"전체 구매 금액이 30만원이상인 경우 3만원이 자동 할인 적용됩니다!!")
				
			elseif is_kakao_apply = "E" then 

				st_9.text = "※ 카카오 쿠폰 적용: 전체 구매 금액이 30만원이상인 경우 10% 추가 할인 적용됩니다!!"

			elseif is_kakao_apply = "D" then 
				st_9.text = "※ 카카오 쿠폰 적용: 10% 추가 할인 적용됩니다!!"				

			elseif is_kakao_apply = "C" then 
				st_9.text = "※ 카카오 쿠폰 적용: 20% 추가 할인 적용됩니다!!"								

			elseif is_kakao_apply = "F" then 
				st_9.text = "※ 카카오 쿠폰 적용: 전체 구매 금액이 50만원이상인 경우 15% 추가 할인 적용됩니다!!"				

			elseif is_kakao_apply = "G" then 
				st_9.text = "※ 카카오 쿠폰 적용: 전체 구매 금액이 20만원이상인 경우 10% 추가 할인 적용됩니다!!"				

			elseif is_kakao_apply = "H" then 
				st_9.text = "※ 카카오 쿠폰 적용: 전체 구매 금액이 100만원이상인 경우 20% 추가 할인 적용됩니다!!"				

			elseif is_kakao_apply = "I" then 
				st_9.text = "※ 카카오 쿠폰 적용: 전체 구매 금액이 1만원이상인 경우 10% 추가 할인 적용됩니다!!"				

			elseif is_kakao_apply = "J" then 
				st_9.text = "※ 카카오 쿠폰 적용: 전체 구매 금액이 1만원이상인 경우 15% 추가 할인 적용됩니다!!"				

			elseif is_kakao_apply = "K" then 
				st_9.text = "※ 카카오 쿠폰 적용: 전체 구매 금액이 40만원이상인 경우 10% 추가 할인 적용됩니다!!"				

			elseif is_kakao_apply = "S" then 
				st_9.text = "※ 카카오 쿠폰 적용: 적용 대상 품번에만 15% 추가 할인 적용됩니다!!"				
				
			elseif is_kakao_apply = "M" then 
				st_9.text = "※ 카카오 쿠폰 적용: 적용 대상 품번에만 합계 수량 2장, 추가 10%(총할인 합계 10만원 이하) 할인이 적용됩니다!!!"	

			elseif is_kakao_apply = "N" then 
				st_9.text = "※ 카카오 쿠폰 적용: M라인 품번을 대상 합계 수량 2장, 추가 10%(총할인 합계 10만원 이하) 할인이 적용됩니다!!!"	
//				st_9.text = "※ 카카오 쿠폰 적용: 적용 대상 품번에만 합계 수량 2장, 추가 10%(총할인 합계 10만원 이하) 할인이 적용됩니다!!!"					
			
			elseif is_kakao_apply = "O" then 
				st_9.text = "※ 카카오 쿠폰 적용: M라인 품번을 대상 합계 수량 2장, 추가 10%(총할인 합계 10만원 이하) 할인이 적용됩니다!!!"	

			elseif is_kakao_apply = "P" then 
				st_9.text = "※ 카카오 쿠폰 적용: M라인 품번을 대상 합계 수량 2장, 추가 10%(총할인 합계 10만원 이하) 할인이 적용됩니다!!!"	

			elseif is_kakao_apply = "U" then 
				st_9.text = "※ 카카오 쿠폰 적용: 5% 추가 할인 적용됩니다!!"								
			
				
		   end if
	ELSE
	
			dw_head.object.t_1.visible = false
			dw_head.object.coupon_no.visible = false					
			dw_head.object.empno.visible = false	
			dw_head.object.emp_nm.visible = false		
			dw_head.Setitem(1, "coupon_no", "")	
			is_empno = "000000"
			is_coupon_no = "000000000000"
			is_empno_stat  = "N"
			is_kakao_apply = "D"
	END IF		
	
else	
	
	dw_head.object.t_1.visible = false
	dw_head.object.empno.visible = false	
	dw_head.object.coupon_no.visible = false		
//	dw_head.object.emp_nm.visible = false		
	dw_head.Setitem(1, "coupon_no", "")	
	is_empno = "000000"
	is_coupon_no = "000000000000"	
	is_empno_stat  = "N"	
	is_kakao_apply = "X"
end if	
	
	

if mid(gs_shop_cd	,1,1) = "N" then
	dw_body.Object.ok_coupon.Protect = 0
	//st_8.TEXT = "※ 예약(완불)은 예약판매등록 이용, 제품인도시 인도일등록시 실판처리 완료!"
	
	if  is_empno = "000000"  and is_coupon_no <> "000000000000" and  ( is_kakao_apply = "D" or is_kakao_apply = "E" or is_kakao_apply = "F" or is_kakao_apply = "G" or is_kakao_apply = "H" or is_kakao_apply = "S" or is_kakao_apply = "I"  or is_kakao_apply = "J"  or is_kakao_apply = "K" or is_kakao_apply = "M" or is_kakao_apply = "N" or is_kakao_apply = "O" or is_kakao_apply = "P" or is_kakao_apply = "U" ) then
		dw_body.Object.sale_qty.Protect = 1
		cb_delete.visible = false
	else 	
		cb_delete.visible = true
		dw_body.Object.sale_qty.Protect = 0		
	end if	
else		
	dw_body.Object.sale_qty.Protect = 0
	dw_body.Object.ok_coupon.Protect = 1
	st_8.TEXT = ""
end if	


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

//messagebox("gs_brand",gs_brand)

if gs_brand = "N" then
//	cb_3.visible = true
//	st_8.text = "※ 예약판매분의 경우 고객전달시 예약 인도일 등록을 처리해 주세요!"
else	
//	cb_3.visible = false
//	st_8.text = "※ 판매유형은 온앤온만 적용됩니다. !"
end if	
	
//messagebox("gs_shop_cd",gs_shop_cd)
//messagebox("gs_shop_pwd",gs_shop_pwd)

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
	if gs_shop_div <> 'M' then
		dw_14.retrieve(gs_shop_cd, gs_shop_pwd)
		dw_14.visible = true
	end if
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
//      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
   CASE 6		/* 입력 */
      if al_rows > 0 then
         cb_delete.enabled = True
//         dw_head.Enabled = false
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

dw_head.setitem(1, "empno", "")
dw_body.Visible = False
dw_1.Visible = False
dw_list.Visible = True

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;string ls_yymmdd, ls_shop_cd, ls_yymm_p, ls_yymm_n, ls_edi_yn
long ll_rowcnt, ldc_margin_cnt, ll_kakao_cnt,ll_shop_cnt, ll_edi_chk
string ls_deposit_chk, ls_date
/*
select convert(varchar(6), dateadd(mm,-1,getdate()),112) ,  convert(varchar(6), getdate(),112)
  into :ls_yymm_p, :ls_yymm_n
  from dual;
*/

ST_6.VISIBLE = FALSE
string ls_etc_shop_div


select etc_shop_div, edi_yn
into :ls_etc_shop_div, :ls_edi_yn
from tb_91100_m (nolock)
where shop_cd = :gs_shop_cd;


if ls_etc_shop_div = "C" then
//	st_online_gubn.visible = true
//	rb_1.visible = true
//	rb_2.visible = true
//	st_online_id.visible = true
//	sle_id.visible = true
//	cb_online_coupon.visible = true
//	
//	st_online_gubn.enabled = true
//	rb_1.enabled = true
//	rb_2.enabled = true
//	st_online_id.enabled = true
//	sle_id.enabled = true
//	cb_online_coupon.enabled = true	
	
	st_online_gubn.visible = false
	rb_1.visible = false
	rb_2.visible = false
	st_online_id.visible = false
	sle_id.visible = false
	cb_online_coupon.visible = false	
	
	st_online_gubn.enabled = false
	rb_1.enabled = false
	rb_2.enabled = false
	st_online_id.enabled = false
	sle_id.enabled = false
	cb_online_coupon.enabled = false			
	
else
	st_online_gubn.visible = false
	rb_1.visible = false
	rb_2.visible = false
	st_online_id.visible = false
	sle_id.visible = false
	cb_online_coupon.visible = false
	
	
	st_online_gubn.enabled = false
	rb_1.enabled = false
	rb_2.enabled = false
	st_online_id.enabled = false
	sle_id.enabled = false
	cb_online_coupon.enabled = false		
end if



if gs_user_id = "TB1004" or gs_shop_div = 'M' then 
	dw_head.object.yymmdd.protect = 0
else
	dw_head.object.yymmdd.protect = 1
end if


ls_date = string(dw_head.GetItemDate(1,'yymmdd'))
ls_date = mid(ls_date,1,4) + mid(ls_date,6,2) + mid(ls_date,9,2)

if gs_shop_cd = 'NG1110' and ls_date >= '20240430' and ls_date <= '20240510' then
	dw_1.object.cb_give_la.visible = false //true
else
	dw_1.object.cb_give_la.visible = false
end if

//마감하는 년도시즌 가져오는 펑션
wf_close_check(gs_brand,is_close_ymd_t,is_year_t,is_season_t,is_season_nm_t,is_season_s_t,is_s_gubn_t,is_e_gubn_t,is_p_gubn_t,is_close_ymd_f,is_year_f,is_season_f,is_season_nm_f,is_season_s_f,is_s_gubn_f,is_e_gubn_f,is_p_gubn_f)

if isnull(is_close_ymd_f) then
	is_close_ymd_f = ''
end if

//messagebox("is_year_t", is_year_t)
//messagebox("is_season_t", is_season_t)
//messagebox("is_year_f", is_year_f)
//messagebox("is_season_f", is_season_f)



if gs_brand = 'N' or gs_brand = 'O' or gs_brand = 'Y' then
	if ls_date >= is_close_ymd_t then
		ST_2.TEXT = "※ " + is_year_t + "년 " + is_season_nm_t + " 이전 제품은 관리팀에 문의 바랍니다!" + is_close_ymd_t
	else
		ST_2.TEXT = "※ " + is_year_f + "년 " + is_season_nm_f + " 이전 제품은 관리팀에 문의 바랍니다!" + is_close_ymd_f	
	end if
end if


dw_1.object.cb_dept_give.visible = false	

/*
IF GS_BRAND = 'N' THEN
	if ls_date <= '20150614' then
		ST_2.TEXT = "※ 2014년 겨울(W) 이전 제품은 관리팀에 문의 바랍니다! 20150322"
	else
		ST_2.TEXT = "※ 2015년 봄(S) 이전 제품은 관리팀에 문의 바랍니다! 20150615"
	end if
	dw_1.object.cb_dept_give.visible = false	
ELSEif  GS_BRAND = 'O' THEN	
	if ls_date <= '20150602' then
		ST_2.TEXT = "※ 2014년 가을(A) 이전 제품은 관리팀에 문의 바랍니다! 20141231"
	else
		ST_2.TEXT = "※ 2014년 겨울(W) 이전 제품은 관리팀에 문의 바랍니다! 20150603"
	end if
	dw_1.object.cb_dept_give.visible = false
ELSEif  GS_BRAND = 'I' THEN
	if ls_date <= '20150412' then
		ST_2.TEXT = "※ 2014년 가을(A) 이전 제품은 관리팀에 문의 바랍니다! 20150111"
	else
		ST_2.TEXT = "※ 2014년 겨울(W) 이전 제품은 관리팀에 문의 바랍니다! 20150413"
	end if
	dw_1.object.cb_dept_give.visible = false	
ELSE	
	ST_2.TEXT = "※ 2012년 가을(A) 이전 제품은 관리팀에 문의 바랍니다! 20121203"
	dw_1.object.cb_dept_give.visible = false	
END IF		
*/
if gs_shop_div = 'M' then
	st_2.text = ''
end if

IF mid(GS_shop_cd,2,1) = 'H' THEN
	ST_6.VISIBLE = TRUE	
	ST_6.TEXT = "※ 닷컴 매장으로 로그인 하셨습니다!"
ELSE		
	ST_6.VISIBLE = FALSE
	ST_6.TEXT = ""
END IF		

ll_rowcnt = idw_event_id.RowCount()

//messagebox("ll_rowcnt", string(ll_rowcnt, "00000"))

if ll_rowcnt > 0 then
 dw_1.object.cb_dept_give.visible = true
else
 dw_1.object.cb_dept_give.visible = false
end if 
	
// 행사 종료 후 주석 처리	
if not (GS_shop_cd = 'DG0263' or GS_shop_cd = 'BB1888') then
 dw_1.object.cb_dept_give.visible = false
end if
	
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

IF mid(GS_shop_cd,2,1) = 'K' and ls_deposit_chk = "Y" THEN
	ST_6.VISIBLE = TRUE
	ST_6.TEXT = "※ 오늘은 입금일입니다!"
END IF		

//edi마감 등록 관련 
dw_22.retrieve(ls_date, GS_SHOP_CD)

if gs_brand = "N" and ls_edi_yn = "Y" then
	dw_22.visible = true
else 	
	dw_22.visible = false	
end if	

select dbo.SF_get_input_edi(:ls_date,:GS_SHOP_CD)
into :ll_edi_chk
from dual;

if ll_edi_chk > 4 and ls_edi_yn = "Y"  then
	messagebox("알림!","일마감금액 미입력 3건이상으로 판매등록이 불가능합니다!")
	messagebox("알림!","메뉴(매장관리2 - 07 일별 매장 마감 차액관리)에서 미입력된 일자 등록 바랍니다. ")
	ST_2.TEXT = "※ 일마감금액 미입력 3건이상으로 판매등록이 불가능합니다!"	
	ST_8.TEXT = "※ 메뉴(매장관리2 - 07 일별 매장 마감 차액관리)에서 미입력된 일자 등록 바랍니다!"	
	dw_body.object.style_no.protect = 1
	dw_body.object.sale_qty.protect = 1	
else 	
	dw_body.object.style_no.protect = 0	
	dw_body.object.sale_qty.protect = 0		
//	dw_22.visible = false	
end if	


//반품율현황 
ls_date = mid(ls_date,1,6)

if mid(gs_shop_cd,2,1) = 'H' then
	select dbo.SF_DOTCOM_SHOP(:gs_shop_cd)	
	into :ls_shop_cd
	from dual;
else
	ls_shop_cd = gs_shop_cd
end if

	is_empno = "000000"
	is_coupon_no = "000000000000"	

dw_18.retrieve(gs_brand, ls_date, '%', ls_shop_cd)



if ( gs_brand  <> "D"  and gs_brand  <> "A" ) then
	// 카카오플러스친구 쿠폰 진행 확인
	select count(*)
	into :ll_kakao_cnt
	from tb_71011_kakao (nolock)
	where  apply_brand like '%' + :gs_brand + '%'
	and :ls_yymmdd between start_ymd and end_ymd
	and accept_flag = 'N' ;
	
else 	

	select count(*)
	into :ll_kakao_cnt
	from tb_71011_kakao (nolock)
	where  apply_brand like '%' + :gs_brand + '%'
	and :ls_yymmdd between start_ymd and end_ymd
	and right(coupon_no,6) = :gs_shop_cd
	and accept_flag = 'N' ;
	
end if

// 카카오플러스친구 쿠폰 진행시 오픈
	if ll_kakao_cnt > 0 then
		cb_kakao_coupon.visible = true
	ELSE 
		cb_kakao_coupon.visible = false		
	end if	
	
	

if ls_yymmdd >= "20201127" and ls_yymmdd <= "20201129"  and gs_shop_cd = "NG0008"  then
	
	
	select count(*)
	into :ldc_margin_cnt
	from tb_56010_m (nolock)
	where shop_cd = :gs_shop_cd
	and :ls_yymmdd between start_ymd and end_ymd
	and sale_type IN ('1J', '1K','3J','3K','1L','3L');

//  ldc_margin_cnt = 2

	if ldc_margin_cnt < 1 then
		cb_emp_sale.visible = fALSE
	ELSE 
		cb_emp_sale.visible = true		
	end if	
	

elseif ls_yymmdd >= "202400101" and ls_yymmdd <= "20240131"  and gs_shop_cd = "NX0006"  then
	
	
	select count(*)
	into :ldc_margin_cnt
	from tb_56010_m (nolock)
	where shop_cd = :gs_shop_cd
	and :ls_yymmdd between start_ymd and end_ymd
//	and sale_type IN ('1L','3L');
	and sale_type IN ('1J', '1K','3J','3K','1L','3L');

  ldc_margin_cnt = 2

	if ldc_margin_cnt < 1 then
		cb_emp_sale.visible = fALSE
	ELSE 
		cb_emp_sale.visible = true		
	end if	
	
	//cb_emp_sale.visible = true		
else	
	cb_emp_sale.visible = fALSE
END IF	

// 닷컴 매출 물류에서 처리 되는 대상 매장 확인 

			  select count(*)
				into :ll_shop_cnt
				from tb_91100_m a (nolock)
				where exists (	select * 
									from tb_91100_m b (nolock) 
									where b.shoP_div in ('B','G','D')
									  and b.brand = a.brand
									  and b.cust_cd = a.cust_cd
									  and b.shop_cd = :gs_shop_cd
									)
				and shop_div = 'H'
				and isnull(etc_shop_div,'F') = 'I' 
				and shop_stat = '00'	;



		if ll_shop_cnt > 0 then 			
//				messagebox("알림!", "닷컴 매출 등록이 불가능한 매장입니다!")	
				st_6.visible = true
			//	st_6.text =  "※ 닷컴 매출 등록이 불가능한 매장입니다!"
				
				IF mid(GS_shop_cd,2,1) = 'H' THEN
					ST_6.TEXT = "※ 닷컴 로그인 / 닷컴 매출등록 불가 매장!"
				ELSE		
					ST_6.TEXT = "※ 닷컴 매출 등록이 불가능한 매장입니다!"
				END IF		
				
				dw_body.object.dotcom.protect = 1
				dw_body.object.dotcom.visible = false				
		else 				
				st_6.visible = false
				st_6.text =  ""

				dw_body.object.dotcom.protect = 0
				dw_body.object.dotcom.visible = true
		end if
		
		
timer(120)		
end event

event resize;call super::resize;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/

This.arrangesheets(Layer!)

shl_member.move(672,newheight - 785)

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
	dw_print.object.p_1.filename = "c:\bnc_shop\bmp\" + gs_brand + '_logo_1.bmp'	
	dw_print.object.p_3.filename = "c:\bnc_shop\bmp\" + gs_brand + '_logo_2.bmp'
	dw_print.object.p_4.filename = "c:\bnc_shop\bmp\" + gs_brand + '_qr_1.bmp'
	
	if gs_shop_cd = 'KB2500' then
		dw_print.object.t_1.text = '215-81-93610'
		dw_print.object.t_3.text = '올리브데올리브(주)'
	else 
		dw_print.object.t_1.text = '215-81-36619'
		dw_print.object.t_3.text = '(주)보끄레머천다이징'
	end if
	
	dw_print.object.t_gubn.text = '[ 고객용 ]'
	dw_print.Print()
//	dw_print.object.t_gubn.text = '[ 매장용 ]'
//	dw_print.Print()
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
String   ls_style_no,   ls_sale_fg,   ls_card_no  , ls_coupon_no , ls_jumin, ls_item, ls_card_no_origin, ls_date, ls_shop_type1
long     ll_sale_price, ll_goods_amt, ll_sale_qty , ll_coupon_amt, ll_accept_point
long     i, iii, ll_row_count, ll_chk, ll_give_rate, k, ll_excp_cnt
decimal	ldc_dc_rate, ld_goods_amt, ldc_sale_qty
datetime ld_datetime
int		li_point_seq	, ii, li_cnt
String   ls_shop_type, ls_sale_type, ls_dot_com, ls_shoP_cd, ls_shop_div, ls_phone_no, ls_ok_coupon, ls_mem_dc_yn, ls_dotcom_tmp, ls_visiter
long		ll_sale_qty1, ll_sale_total,ll_chk_sale_price,li_chk_cnt,ll_chk_sale_amt, ll_dot_close
decimal  ld_dc_rate_tmp
string	ls_sale_type_tmp, ls_style, ls_season, ls_coupon_no_chk

string ls_rtrn_yn
long ll_rtrn_tag_amt, ll_limit_rtrn_amt, ll_real_rtrn_amt, ll_sale_rtrn_qty
string ls_date_1, ls_date_2
datetime ld_date_t, ld_date_time
string ls_date_time
long ll_sale_cnt

IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_member_sale.AcceptText() <> 1 THEN RETURN -1
IF dw_back_sale.AcceptText() <> 1 THEN RETURN -1
IF dw_1.AcceptText()    <> 1 THEN RETURN -1

SELECT GetDate(), GetDate()
  INTO :ld_date_t, :ld_date_time
  FROM DUAL ;

/*등록일자가져오기*/
ls_date_1 = string(ld_date_t, "YYYYMMDD")
ls_date_2 = string(dw_head.getitemdate(1,'yymmdd'),'YYYYMMDD')

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


if is_empno <> "000000" then
	li_chk_cnt = 0
	ll_chk_sale_price = 0
	ll_chk_sale_amt = 0
	FOR i=1 TO ll_row_count
		ls_sale_type_tmp = dw_body.GetitemString(i, "sale_type")
		ll_chk_sale_price = Long(dw_body.GetitemDecimal(i, "sale_amt"))	
		if ls_sale_type_tmp = "1J"  or ls_sale_type_tmp = "1K" or ls_sale_type_tmp = "3J"  or ls_sale_type_tmp = "3K"  then
			ll_chk_sale_amt = ll_chk_sale_amt + ll_chk_sale_price
		end if	

	NEXT
	
	if ll_chk_sale_amt > 1000000 then
		MessageBox("행사입력오류", " 합계금액 100만원 까지만 사용 가능합니다!")
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


/***********20141107~20141109 14시이전 선착순 10명(판매순번 10건)에게만 4W정상만 30%할인
            1) 전매장(면세, 본사매장 제외) ****************************************/
/*


ls_date_time = string(ld_date_time,'hhmm')

//판매건수 확인
select	isnull(sum(a.sale_cnt),0) sale_cnt
into	:ll_sale_cnt
from	(	select	case when sale_no <> '' then 1 else 0 end as sale_cnt
			from	tb_53010_h with (nolock)
			where	yymmdd = :ls_date_2
					and shop_cd = :gs_shop_cd
					and sale_qty >= 1
					and sale_type = 11 
					and dc_rate in (30, 35)
			group by sale_no) a ;

IF gs_brand = "N" and gs_shop_div <> "H" and is_yymmdd >= "20141107" and is_yymmdd <= '20141109' and ls_date_time < '1400' and ll_sale_cnt < 10 and (gs_shop_cd <> 'NM2600' or gs_shop_cd <> 'NB1890' ) then
//IF gs_brand = "N" and gs_shop_div <> "H" and is_yymmdd >= "20141107" and is_yymmdd <= '20141109' and ll_sale_cnt < 10 and (gs_shop_cd <> 'NM2600' or gs_shop_cd <> 'NB1890' ) then
	This.Trigger Event ue_tot_set()
	wf_goods_chk4()
END IF

*/

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



/************ 30%할인쿠폰 제한걸기 시작 *****************/
/*
ll_sale_qty1 = 0
ll_sale_total = 0
IF gs_brand = "N" and gs_shop_div <> "H" and is_yymmdd >= "20141107" and is_yymmdd <= '20141109' and ls_date_time < '1400' and ll_sale_cnt < 10 and (gs_shop_cd <> 'NM2600' or gs_shop_cd <> 'NB1890' ) then
	for i=1 to ll_row_count
		ll_excp_cnt = 0
		
		ll_sale_qty1 = dw_body.getitemnumber(i,'sale_qty')
		ll_sale_total = ll_sale_total + ll_sale_qty1 
		ll_sale_qty1 = 0
		
		ls_sale_type = dw_body.getitemstring(i,'sale_type')
		ls_style = mid(dw_body.getitemstring(i,'style_no'),1,8)
		ls_season =mid(dw_body.getitemstring(i,'style_no'),3,2)
		
		select isnull(sum(a.excp_chk),0) excp_chk
		into :ll_excp_cnt
		from (
				select case when style <> '' then 1 else 0 end as excp_chk		
				from tb_56012_d_excp
				where style = :ls_style
						and excp_yn = 'Y') a;	
			
		if gs_brand = 'N' then
			if (ls_season ="4W") and (ls_sale_type="11") and ll_excp_cnt = 1   then
				MessageBox('제외품번 확인','제외품번이 포함되어 있습니다. 확인후 다시 입력해 주세요!')
				cb_1.triggerevent (clicked!)
				return 0
			end if
		end if
		 
	next


	
	ls_coupon_no = dw_body.getitemstring(1,'coupon_no')
	if ls_coupon_no = 'N14230' then
		// 할인쿠폰 최대 3개까지만 적용 가능하게.
		if ll_row_count > 3 or ll_sale_total >3 then
			messagebox('확인','할인은 1인 3PCS까지만 사용이 가능합니다.')
				cb_1.triggerevent (clicked!)
			return 0
		end if
	end if
end if
*/
/************ 30%할인쿠폰 제한걸기 끝 *******************/


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




//202107 카카오 할인 금액권
IF gs_brand = "N" and gs_shop_div <> "H" and left(gs_shop_cd,2) = 'NG'  and is_kakao_apply = "A" then
	This.Trigger Event ue_tot_set()
	wf_goods_chk3_kakao()
END IF



/***********20161008~20161014 30만원이상 구매시 3만원 추가즉시할인 체크 적용
            1) 온앤온 롯데안산 매장 : 2016년 10월 08일(토) ~ 10월 14일(금), 7일간 
**********************/

IF gs_brand = "N" and gs_shop_div <> "H" and is_yymmdd >= "20161008" and is_yymmdd <= '20161014' and gs_shop_cd = 'NG1109' then
	This.Trigger Event ue_tot_set()
	wf_goods_chk3()
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
IF isnull(ls_card_no) = FALSE AND len(ls_card_no) = 9 THEN
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
		ls_year_1 =  dw_body.GetItemString(i, "year")
		ls_style_no1 =  dw_body.GetItemString(i, "style_no")		

		if gs_shop_cd = 'OD0002' then
			ls_dot_com = '1'
		end if	
			
		if (ls_coupon_no_1 = 'N17004' and ls_sale_type_1 > '40' ) or (ls_coupon_no_1 = 'N17004' and ls_year_1 >= '2017' and ls_season_1 = 'm')  then
			MessageBox("확인", "2017년 가을(A)상품은 정상/세일/기획 , 겨울(W)상품은 정상/세일/기획 제품에만 사용할수 있습니다!")  
			return 0
		end if
		
		
		
		//20230522 최승희 요청
//		//20221101 성희명
//		if (ls_dot_com <> "1" OR isnull(ls_dot_com) ) AND  MID(ls_style_no1,1,1) = "E"  then
//			MessageBox("확인", "E품번은 닷컴판매만 가능합니다.!")  
//			return 0
//		end if
		
		
		
		
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
						where b.shoP_div in ('B','G','O')
						  and b.brand = a.brand
						  and b.cust_cd = a.cust_cd
						  and b.shop_cd = :gs_shop_cd
						)
				and shop_div = 'H'
				and isnull(etc_shop_div,'F') <> 'I'	
				and shop_stat = '00'	;
			end if
			
			
				
				if IsNull(ls_shoP_cd) or Trim(ls_shoP_cd) = "" then
				   ls_shop_cd = gs_shop_cd
					ls_shop_div = gs_shop_div
			   else
					if mid(ls_shop_cd, 1,1) = "Y" then
						select right(isnull(max(SALE_NO), 0) + 10001, 4)
						  into :is_sale_no 
						  from tb_53010_h (nolock)
						 where yymmdd    = :is_yymmdd 
							and shop_cd   = :ls_shop_cd
							and shop_type in ('1','3','4' );
					else 
						select right(isnull(max(SALE_NO), 0) + 10001, 4)
						  into :is_sale_no 
						  from tb_53010_h (nolock)
						 where yymmdd    = :is_yymmdd 
							and shop_cd   = :ls_shop_cd
							and shop_type in ('1','3','4' );
					end if
							
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
		
		
		IF ls_shop_div = "H" then
			
				select count(*)
				into :ll_dot_close
				from tb_91100_m a (nolock)
				where shop_cd = :ls_shop_cd	
				and shop_div = 'H'
				and isnull(etc_shop_div,'F') = 'I'			
				and shop_stat = '00'	;
	
			    IF ll_dot_close <> 0 then
					MessageBox("경고", "운영주체변동으로 닷컴코드의 판매등록이 불가능한 매장입니다!") 
					Return 0 
				END IF

		end if
		

		  IF  idw_status <> NewModified! and gs_shop_div <> "H" and ls_dot_com = "1"  then
				MessageBox("경고", "기존판매분의 닷컴으로의 전환은 불가능합니다.!") 
				Return 0 
 		   END IF

		ls_style = mid(dw_body.getitemstring(i,'style_no'),1,8)
		
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
	      dw_body.Setitem(i, "shop_div", mid(ls_shop_cd,2,1))	
			dw_body.Setitem(i, "event_id", gs_shop_cd)						
			dw_body.Setitem(i, "mod_id", gs_user_id)
			dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF 
		
		ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))
		ll_sale_qty   = dw_body.GetitemDecimal(i, "sale_qty")
		ls_style_no   = dw_body.Getitemstring(i, "style_no")
		ls_item       = right(left(ls_style_no,2),1)
		
		ll_goods_amt = dw_body.GetitemNumber(i, "goods_amt")  // point금액 
		
		ls_coupon_no  = dw_body.Getitemstring(i, "coupon_no")	
		
		
	
	

	// 구매할인권 정상+ 30%세일까지만  쿠폰금액이상의 제품에만 사용가능 
		IF len(ls_coupon_no) =  6 then	
			
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
					ELSEIF Len(Trim(dw_1.Object.jumin[1])) = 13 and Left(dw_body.Object.sale_type[i], 1) <= '2' THEN  // 정상 적용 
						ls_sale_fg = '1' 
					ELSE
						ls_sale_fg = '0' 
					END IF		


		
		
		
   	ELSE		// 마일리지는 정상+ 30%sale 만 사용가능 

					IF ll_goods_amt > 0 and ll_sale_price > ll_goods_amt and  & 
						ll_sale_qty  > 0 and dw_body.Object.dc_rate[i] <  31  and dw_body.Object.sale_type[i]  < '30' THEN  
						ls_sale_fg = '2' 
					ELSEIF Len(Trim(dw_1.Object.jumin[1])) = 13 and Left(dw_body.Object.sale_type[i], 1) <= '2' THEN  // 정상 적용 
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
			
		if GS_BRAND = "N"  and dw_body.Getitemnumber(i, "sale_qty") > 0 and idw_status = NewModified! and is_empno = "000000" THEN  // 반품일때는 처리하지말고 RETURN    
		  if wf_stock_chk(i, ls_style_no1) = false then 
			 IF ls_ok_coupon = "1" THEN 
				MESSAGEBOX("알림!" , "예약(완불)의 경우 예약(완불)판매 별도 화면에서 등록이 시행됩니다. !")
		  	 ELSE 	
				MESSAGEBOX("알림!" , "재고가 없는 품번의 판매 제한이 시행됩니다! 쿠폰사용인 경우 전체 재등록 바랍니다. ")
			   return 0
    		 END IF 
		  end	if
		end if				
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

/*----------------------------------------------------------------------------*/
// 반품율 체크                                                                //
// 시행일시: 20140601                                                         //
// 요청자:민혜경대리(온앤온,올리브,라빠레트,코인코즈 합의함)                  //
/*----------------------------------------------------------------------------*/
dw_18.accepttext()
	
//반품율현황 
ls_date = string(dw_head.getitemdate(1,'yymmdd'),'YYYYMMDD')
ls_date = mid(ls_date,1,6)

if mid(gs_shop_cd,2,1) = 'H' then
	select dbo.SF_DOTCOM_SHOP(:gs_shop_cd)	
	into :ls_shop_cd
	from dual;
else
	ls_shop_cd = gs_shop_cd
end if

dw_18.retrieve(gs_brand, ls_date, '%', ls_shop_cd)


ls_rtrn_yn = dw_18.getitemstring(1,'rtrn_yn')
ll_rtrn_tag_amt = dw_18.getitemnumber(1,'rtrn_tag_amt')
ll_limit_rtrn_amt = dw_18.getitemnumber(1,'limit_rtrn_amt')



	FOR k=1 TO ll_row_count
		ll_sale_rtrn_qty = dw_body.getitemnumber(k,'sale_qty')
		ll_real_rtrn_amt = dw_body.getitemnumber(k,'sale_amt')
		ls_shop_type1 = dw_body.getitemstring(k,'shop_type')
	
		if ll_sale_rtrn_qty < 0 then
			if ls_rtrn_yn = 'Y' and ls_shop_type1 <= '2' then
				if ll_rtrn_tag_amt + (ll_real_rtrn_amt * -1) > ll_limit_rtrn_amt then
					messagebox('확인','반품 누적금액이 반품 제한금액을 초과 하였습니다!!!')
						if mid(gs_shop_cd,1,1) = "O" then 
							Return 0				
						end if	
				end if
			end if
		end if	
	next


/*---고판다------------------------------------------------------- */

string ls_barcord_no, ls_use_gubn, ls_coupon_no2
int h
ls_barcord_no = dw_19.getitemstring(1,'barcord_no')
ls_use_gubn = dw_19.getitemstring(1,'use_gubn')

dw_19.reset()
if ls_barcord_no = '' or isnull(ls_barcord_no) then

else

	for h = 1 to dw_body.rowcount()
		dw_19.insertrow(0)	
		dw_19.setitem(h,'yymmdd', is_yymmdd)
		dw_19.setitem(h,'shop_cd', gs_shop_cd)
		dw_19.setitem(h,'sale_no', dw_body.getitemstring(h,'sale_no'))
		dw_19.setitem(h,'no', dw_body.getitemstring(h,'no'))		
		ls_coupon_no2 = dw_body.getitemstring(h,'coupon_no')
		if mid(ls_coupon_no2,1,4) = 'GP15' or mid(ls_coupon_no2,1,4) = 'GP16' then
			dw_19.setitem(h,'coupon_no', 'B15999')
			dw_19.setitem(h,'coupon_gubn', '02')
		else
		dw_19.setitem(h,'coupon_no', ls_coupon_no2)
			dw_19.setitem(h,'coupon_gubn', '01')
		end if

		dw_19.setitem(h,'barcord_no', ls_barcord_no)
		if dw_body.getitemstring(h,'visiter') = '반품' then
			ls_use_gubn = 'R'
		end if
		dw_19.setitem(h,'use_gubn', ls_use_gubn)

		
	next	
end if
/*---고판다------------------------------------------------------- */

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

	dw_19.update()	
	
   commit  USING SQLCA;

	dw_body.Retrieve(is_yymmdd, gs_shop_cd, is_sale_no) 

	This.Post Event ue_total_retrieve()
//	This.Post Event ue_rt_retrieve()	
	dw_head.setitem(1, "empno","")
	dw_head.object.empno.visible = false
	is_empno_stat  = "N"	
	
	cb_1.SetFocus()
else
   rollback  USING SQLCA;
end if

dw_22.retrieve(is_yymmdd, gs_shop_cd)


Post Event ue_tot_set()

if gs_shop_cd = 'GB1807' or gs_shop_cd = 'TB1004' then
	integer Net
	Net = MessageBox("영수증출력", "영수증을 출력 하시겠습니까?", Exclamation!, OKCancel!, 2)
	
	IF Net = 1 THEN 
		cb_print.TriggerEvent(Clicked!)
	END IF
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event timer;call super::timer;string ls_date

SELECT convert(char(10), getdate(), 112)
  INTO :ls_date
  FROM DUAL ;
  
  
//messagebox("",  ls_date)
end event

type cb_close from w_com010_e`cb_close within w_sh101_e
boolean visible = false
integer x = 389
integer taborder = 380
end type

type cb_delete from w_com010_e`cb_delete within w_sh101_e
integer x = 1010
integer width = 293
integer taborder = 190
end type

type cb_insert from w_com010_e`cb_insert within w_sh101_e
boolean visible = false
integer taborder = 140
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh101_e
integer x = 2505
integer width = 357
integer taborder = 400
string text = "일보조회(&Q)"
end type

type cb_update from w_com010_e`cb_update within w_sh101_e
integer taborder = 80
end type

type cb_print from w_com010_e`cb_print within w_sh101_e
integer x = 608
integer width = 393
integer taborder = 260
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

type cb_preview from w_com010_e`cb_preview within w_sh101_e
boolean visible = false
integer x = 1193
integer y = 48
integer taborder = 330
end type

type gb_button from w_com010_e`gb_button within w_sh101_e
end type

type dw_head from w_com010_e`dw_head within w_sh101_e
integer x = 14
integer y = 152
integer width = 1682
integer height = 112
string dataobject = "d_sh101_h01"
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

type ln_1 from w_com010_e`ln_1 within w_sh101_e
integer beginy = 368
integer endy = 368
end type

type ln_2 from w_com010_e`ln_2 within w_sh101_e
integer beginy = 372
integer endy = 372
end type

type dw_body from w_com010_e`dw_body within w_sh101_e
event ue_set_column ( long al_row )
integer x = 5
integer y = 384
integer width = 2885
integer height = 308
integer taborder = 50
string dataobject = "d_sh101_d01_new"
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
string ls_card_no, ls_set_style, ls_shop_cd_chk, ls_set_style_chk, ls_style_chk, ls_style,ls_dot_com,LS_CHK_COUPON
integer Net, i, il_cnt_except
long ll_cnt, ll_rows, ll_sale_qty, ll_shop_cnt
long ll_sale_amt_dc, ll_sale_amt_chk_dc,	ll_sum_chk_amt, ll_sale_amt_chk, ll_sum_chk_QTY1, ll_sale_QTY_chk, ll_sale_price_org, ll_sale_chk, ll_year_chk // 적용해당 판매수량
CHOOSE CASE dwo.name
		
								
	
		
	case "ok_coupon"
//		if is_yymmdd >= '20090119' and is_yymmdd <= '20090215' and gs_brand = "N" then
////		if is_yymmdd >= '20090119' and is_yymmdd <= '20090215' then			
//			wf_ok_coupon(row, string(data))		
//   	else
//			messagebox("확인","이벤트 쿠폰 사용 기간이 아닙니다..")
//			return 1
//		end if
		
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
			dw_body.accepttext()
			
	//	ls_dot_com = dw_body.GetItemString(row, "dotcom")
	//	messagebox("ls_dot_com_style",ls_dot_com)			


			//대상매장 및 Set스타일 찾기			
			is_set_style_chk = ''
			ls_set_style = getitemstring(row,'style_no')
			ls_set_style = mid(ls_set_style,1,10)
			
			select set_style
			into :is_set_style_chk
			from tb_56012_d_cosmetic with (nolock)
			where set_style = :ls_set_style;

			if isnull(is_set_style_chk) then 
				is_set_style_chk = '' 
			end if
			
			if gs_brand = 'G' or gs_shop_cd = 'tb1004' then
				if is_set_style_chk <> '' then 
					Net = MessageBox('확인','세트상품이 2건 이상입니까?', Exclamation!, YesNo!,2)
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

	 		
			
				if gs_brand = 'D' or gs_shop_cd = 'tb1004' then
					
					  	ls_set_style = this.getitemstring(row,'style_no')
						ls_set_style = mid(ls_set_style,1,8)
			
						select distinct set_style
						into :is_set_style_chk
						from tb_56012_d_set with (nolock)
						where style = :ls_set_style
						and   :gs_shop_cd  like  shop_cd
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
			



			//롯데본점, 롯데잠실, 롯데노원, 신세계강남만 중국 특가판매를 하기위해 이미지아이템(I099)을 등록시 판매량 변경 가능하게 수정함.
			//요청자 고형보(2017년10월31일) by 윤상혁
			if gs_brand = 'N' and (gs_shop_cd = 'NG0008' or gs_shop_cd = 'NG0009' or gs_shop_cd = 'NG0037' or gs_shop_cd = 'NG1141' or gs_shop_cd = 'NG0006' or gs_shop_cd = 'NG0014')  and mid(ls_set_style,5,4) = 'I099' then
				dw_body.modify('sale_qty.edit.limit = 4')
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
		
		/*
		20130101 부터
		*/
			//########### 회원 즉시할인 +5% 적용 로직 #####################
		if is_set_style_chk = '' then
			ls_card_no = dw_1.getitemstring(1, "card_no")

			IF Trim(ls_card_no) <> "" THEN 
				wf_amt_set3(row)
				dw_1.AcceptText()
			END IF
			//#############################################################	  +
		
			IF li_ret <> 1  THEN
				This.Post Event ue_set_column(row) 
			END IF
			return li_ret
		end if


	CASE "sale_qty"	  
		if is_set_style_chk = '' then
//		this.Setitem(row,"give_rate",0)
//		this.Setitem(row,"coupon_no","")
		
			dw_body.SetItem(row, "goods_amt", 0)
			dw_body.SetItem(row, "give_rate", 0)
			dw_body.SetItem(row, "coupon_no", "")
			dw_body.SetItem(row, "phone_no", "")
			dw_body.SetItem(row, "visiter", "")
			
			ls_style = getitemstring(row,'style')
			
			IF isnull(data) or Long(data) = 0 THEN RETURN 1
 
			
			if mid(data,1,1) = "-" then 
				messagebox("확인","반품등록은 일반/회원반품을 이용해 주세요..")
				dw_body.SetItem(row, "sale_qty", 1)
				return 1
			end if
				
				ld_goods_amt = dw_body.getitemdecimal(row,"goods_amt")
				
				IF Long(data) < 0	then				
					this.Setitem(row,"goods_amt",0)
					dw_1.Setitem(1,"goods_amt",0)
					Parent.Post Event ue_tot_set()		 
				END IF
				
				
			if is_empno = "000000"  and is_coupon_no <> "000000000000" and ( is_kakao_apply = "M" or is_kakao_apply = "N")  then
				
					ll_sale_amt_chk_dc = 0 
					ll_sale_amt_dc	= 0
					ll_sum_chk_amt = 0
					ll_sum_chk_QTY1 = 0
					ll_sale_QTY_chk  = 0
					
				FOR i=1 TO dw_body.RowCount() // 대상에 해당되는 합계 금액 확인  IsNull(is_s_yymm) OR Trim(is_s_yymm)
	
						ll_sale_qty = 0
						ll_sale_qty  =  dw_body.GetitemDecimal(i, "sale_qty") 		
						LS_CHK_COUPON = dw_body.GetItemString(i, "EMPTY_3")
			
						if IsNull(LS_CHK_COUPON) = false then  				
							ll_sale_QTY_chk = ll_sale_qty
						end if
										
					ll_sum_chk_QTY1 = ll_sum_chk_QTY1 + ll_sale_QTY_chk	 // 적용해당 판매수량
					
				NEXT
				
				//messagebox("", ll_sum_chk_QTY1)
								
				
			end if
	
		/* 금액 처리 */
			if is_empno = "000000"  and is_coupon_no = "000000000000" then
				wf_amt_set(row, Long(data))   
			elseif is_empno <> "000000"  and is_coupon_no = "000000000000" then
				wf_amt_set_empno(row,  Long(data), ls_style)		
			elseif is_empno = "000000"  and is_coupon_no <> "000000000000" and is_kakao_apply = "D" then
				wf_amt_set_kakao(row,  Long(data), ls_style)				
			elseif is_empno = "000000"  and is_coupon_no <> "000000000000" and is_kakao_apply = "S" then //특정품번 적용
				wf_amt_set_kakao_style(row,  Long(data), ls_style)								
  		   elseif is_empno = "000000"  and is_coupon_no <> "000000000000" and ( is_kakao_apply = "E" or is_kakao_apply = "F" or is_kakao_apply = "G" or is_kakao_apply = "H" or is_kakao_apply = "I" or is_kakao_apply = "J" or is_kakao_apply = "K" ) then				
				wf_amt_set_kakao_1(row,  Long(data), ls_style)								
			elseif is_empno = "000000"  and is_coupon_no <> "000000000000" and ( is_kakao_apply = "M" or is_kakao_apply = "N")  then
				wf_amt_set_kakao_2(row,  Long(data), ls_style)								
				
			else 		
				wf_amt_set(row, Long(data))
			end if		
			
		
			
			Parent.Post Event ue_tot_set()
		end if
		
	CASE "dotcom"	  
		
			dw_body.accepttext()
			
			if IsNull(data) or Trim(data) = "" then	
				data = "0"
			end if	
		
		
			ls_style = dw_body.getitemstring(row,"style")
			ll_sale_qty = dw_body.getitemnumber(row,"sale_qty")
			
//			messagebox("", data)
//			messagebox("", ls_style)
//

			select count(*)
				into :ll_shop_cnt
				from tb_91100_m a (nolock)
				where exists (	select * 
						from tb_91100_m b (nolock) 
						where b.shoP_div in ('B','G','O')
						  and b.brand = a.brand
						  and b.cust_cd = a.cust_cd
						  and b.shop_cd = :gs_shop_cd
						)
				and shop_div = 'H'
				and isnull(etc_shop_div,'F') = 'I' 
				and shop_stat = '00'	;


		if ll_shop_cnt <> 0 then 
				data = "0"
				messagebox("알림!", "닷컴 매출 등록이 불가능한 매장입니다!")				
		end if
		
		
		if IsNull(ls_style) = false and Trim(ls_style) <> "" then				
				wf_style_set2(row, mid(ls_style,1,8), is_yymmdd, ll_sale_qty, data)
			end if	
			
END CHOOSE

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.of_SetSort(False)

if gs_brand = 'G' then
	dw_body.dataobject = 'd_sh101_d11_new'
else
	dw_body.dataobject = 'd_sh101_d01_new'
end if

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
      lc_kb[17] = Char (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = Char (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = Mid(ls_report, 4, Len(ls_report) - 4)
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

OpenWithParm (W_SH101_P, "W_SH101_P 판매형태 내역") 
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

ls_yymmdd = string(dw_head.getitemdate(1,"yymmdd"),"yyyymmdd")


if dwo.name = 'cb_ok_coupon' then 	
	
////	is_ok_coupon = this.getitemstring(1,"ok_coupon")
//	if is_ok_coupon = 'Y' then 
//		is_ok_coupon = 'N'
//	else
//		is_ok_coupon = 'Y'
//	end if
//
//
//
//	for i = 1 to this.rowcount()		
//		
//		ls_style = this.getitemstring(i,"style")
//		ls_brand = this.getitemstring(i,"brand")		
//		ls_year = this.getitemstring(i,"year")
//		ls_season = this.getitemstring(i,"season")
//		ll_dc_rate = this.getitemdecimal(i,"dc_rate")
//		
//		// ok쿠폰(올리브 8a,8w) 20081003 ~ 20081031
//		// 롯데시네마 쿠폰 20090119 ~ 20090219 
//		if (ls_brand = 'O' and ls_year = '2008' and ls_season = 'A' and ll_dc_rate < 50 and ls_yymmdd >= '20081002' and ls_yymmdd <= '20081031') or + &
//		   (ls_brand = 'O' and ls_year = '2008' and ls_season = 'W' and ll_dc_rate < 50 and ls_yymmdd >= '20081002' and ls_yymmdd <= '20081012') then
//
//			if len(ls_style) = 8 then 	
//				this.setitem(i,"ok_coupon",is_ok_coupon)
//				wf_ok_coupon(i, is_ok_coupon)
//				ll_chk = i
//			end if			
//		end if		
//	next 
//	
//	if ll_chk = 0 then 
//			messagebox("확인", "해당하는 쿠펀내역이 존재하지 않습니다..")
//	end if
//
//	Parent.Post Event ue_tot_set()

elseif dwo.name = 'cb_select'  then 	

	if is_dotcom_select = 'Y' then 
		is_dotcom_select = 'N'
	else
		is_dotcom_select = 'Y'
	end if	


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

type dw_print from w_com010_e`dw_print within w_sh101_e
integer x = 1385
integer y = 224
integer width = 1349
integer height = 948
boolean enabled = false
string dataobject = "d_sh101_p01"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

type dw_1 from datawindow within w_sh101_e
event ue_keydown pbm_dwnkey
event type long ue_item_changed ( long row,  dwobject dwo,  string data )
integer x = 5
integer y = 692
integer width = 2080
integer height = 576
integer taborder = 60
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
      lc_kb[17] = Char (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = Char (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = Mid(ls_report, 4, Len(ls_report) - 4)
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
		
		ls_s_birthday = right(dw_1.getitemstring(1,"s_birthday"),6)
//		ls_s_tel_no3_4 = dw_1.getitemstring(1,"s_tel_no3_4")				

		if isnull(ls_s_birthday) or len(ls_s_birthday) < 6 then
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
		ls_s_birthday = right(dw_1.getitemstring(1,"s_birthday"),6)

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

/*
IF dwo.name = "b_member" THEN 
	wf_goods_amt_clear()
	this.setitem(1, "card_no","")
	this.setitem(1, "jumin","")	
	this.setitem(1, "tel_no3","")	
	this.setitem(1, "user_name","")		
	this.setitem(1, "goods_amt",0)			
	
	
	OpenWithParm (W_SH101_S, "W_SH101_S 신규회원접수") 
   ls_jumin = Message.StringParm 
	IF isnull(ls_jumin) = False and Len(Trim(ls_jumin)) = 13 THEN
		wf_member_set('1', ls_jumin) 
		IF dw_body.RowCount() > 0 THEN 
	      IF dw_body.GetitemStatus(1, 0, Primary!) <> New! THEN 
            ib_changed = true
            cb_update.enabled = true
	      END IF
      END IF
	END IF

	
	
END IF
*/
IF dwo.name = "b_return" THEN  //회원반품
	dw_body.enabled = false
	dw_1.enabled = false
	
	if mid(gs_shop_cd,1,1) = "N" then 
		messagebox('알림', '30일이전 판매분과 부진/품목할인 선정 제품은 조회 반품이 불가 합니다!')	  
	end if	
	
	gs_jumin = dw_1.GetitemString(1, "jumin")
			
	IF isnull(gs_jumin) or gs_jumin = "" Then
		messagebox('확인', '고객정보를 먼저 입력 하세요!')
		dw_body.enabled = True
		dw_1.enabled = True
		return	0
	END IF
   dw_member_sale.Retrieve(gs_jumin)
	dw_member_sale.visible =true
END IF	

IF dwo.name = "b_back_sale" THEN //일반반품
	dw_body.enabled = false
	dw_1.enabled = false
	
	
	if mid(gs_shop_cd,1,1) = "N" then 
		messagebox('알림', '30일이전 판매분과 부진/품목할인 선정 제품은 조회 반품이 불가 합니다!')	  
	end if	

//   dw_back_sale.Retrieve('','xxxxxxxx','x','x',gs_shop_cd,'', gs_shop_cd, ld_dc_rate,'0')	
	dw_back_sale.reset()
	dw_back_sale.insertrow(1)
//	dw_back_sale.setitem(1,"yymmdd",is_yymmdd)
   dw_back_sale.setitem(1,"shop_cd",gs_shop_cd)	
	
	if mid(gs_shop_cd,1,1) = "N" or mid(gs_shop_cd,1,1) = "J" then
		dw_back_sale.object.shop_cd.protect = 1
	else 	
		dw_back_sale.object.shop_cd.protect = 0
	end if
	
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
	
//	IF gs_brand <> 'W' then
//		messagebox('확인', '더블유닷매장만 진행중입니다!')	  
//		return	0
//	END IF

	dw_11.visible = true

END IF

IF dwo.name = "cb_give_la" THEN 
	IF gs_shop_cd <> 'BB1813' then
		messagebox('확인', '롯데영플라자 라빠레트 매장만 진행중입니다!')	  
	//	return	0
	END IF
	
	if dw_body.getitemnumber(1,'dc_rate') = 20 and dw_body.getitemstring(1,'sale_type') = '18' then
		messagebox('확인', '20%즉시 할인과 무적쿠폰은 중복 사용이 안 됩니다.!')
		return	0		
	end if

	dw_11.visible = true

END IF


IF dwo.name = "cb_gopanda" THEN 
	ls_style = dw_body.getitemstring(1,'style')
	if ls_style = '' or isnull(ls_style) then
		messagebox('확인','판매스타일을 먼저 입력해 주세요!')
		return 0
	end if
	
	dw_19.visible = true
	dw_19.reset()
	dw_19.insertrow(0)
	dw_19.setcolumn("coupon_gubn")
	dw_19.setfocus()	
// 쿠폰번호	: 고판다
//	B15999

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

type cb_1 from commandbutton within w_sh101_e
event ue_keydown pbm_keydown
integer x = 2176
integer y = 44
integer width = 329
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
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
STRING LS_EMP_VISIBLE, ls_coupon_no_visible
long ll_ret

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

LS_EMP_VISIBLE = dw_head.Describe("empno.Visible")
ls_coupon_no_visible = dw_head.Describe("coupon_no.Visible")
dw_body.Object.sale_qty.Protect=0



if is_yymmdd >= "20200721" and is_yymmdd <= "20200726"  and (left(gs_shop_cd,2) = "NG" or  left(gs_shop_cd,2) = "NB" ) and LS_EMP_VISIBLE = "1"  then
	
	
	ll_ret = MessageBox("확인!", "사우행사 판매등록을 계속 진행하시겠습니까?", Exclamation!, OKCancel!, 2)
	
	IF ll_ret = 1 THEN 
		IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
	ELSE
		IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN	
	END IF	

elseif is_yymmdd >= "20210101" and is_yymmdd <= "20251231"  and (left(gs_shop_cd,2) = "NG" or  left(gs_shop_cd,2) = "NB" ) and ls_coupon_no_visible = "1"  then
	
	
	ll_ret = MessageBox("확인!", "카카오플러스친구 쿠폰 판매등록을 계속 진행하시겠습니까?", Exclamation!, OKCancel!, 2)
	
	IF ll_ret = 1 THEN 
		IF Trigger Event ue_keycheck('4') = FALSE THEN RETURN
	ELSE
		IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN	
	END IF		
	
elseif is_yymmdd >= "20230426" and is_yymmdd <= "20251231"  and (left(gs_shop_cd,2) = "DG" or  left(gs_shop_cd,2) = "DB" or  left(gs_shop_cd,2) = "DO"  or  left(gs_shop_cd,2) = "AX" ) and ls_coupon_no_visible = "1"  then
	
	
	ll_ret = MessageBox("확인!", "카카오플러스친구 쿠폰 판매등록을 계속 진행하시겠습니까?", Exclamation!, OKCancel!, 2)
	
	IF ll_ret = 1 THEN 
		IF Trigger Event ue_keycheck('4') = FALSE THEN RETURN
	ELSE
		IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN	
	END IF			
	
ELSE
	
	IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN		
		
end if	
	
			

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

dw_body.setcolumn("style_no")
dw_body.setfocus()

Parent.Trigger Event ue_button(6, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type st_1 from statictext within w_sh101_e
integer y = 376
integer width = 2894
integer height = 900
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

type dw_2 from datawindow within w_sh101_e
integer x = 32
integer y = 1380
integer width = 2843
integer height = 392
string title = "none"
string dataobject = "d_sh101_d03"
boolean border = false
boolean livescroll = true
end type

event doubleclicked;//dw_2.visible = false
//dw_3.visible = true
end event

type st_2 from statictext within w_sh101_e
integer x = 1650
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
long textcolor = 255
long backcolor = 67108864
string text = "※ 2009년 여름(M) 이전 제품은 관리팀에 문의 바랍니다!"
boolean focusrectangle = false
end type

type tab_1 from tab within w_sh101_e
event create ( )
event destroy ( )
integer x = 5
integer y = 1280
integer width = 2894
integer height = 548
integer taborder = 150
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
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_4=create tabpage_4
this.tabpage_3=create tabpage_3
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_4,&
this.tabpage_3,&
this.tabpage_5}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_4)
destroy(this.tabpage_3)
destroy(this.tabpage_5)
end on

event clicked;  	CHOOSE CASE index
		CASE 1
			dw_2.visible = true
			dw_3.visible = TRUE
			dw_4.visible = false
			dw_5.visible = false
			dw_6.visible = false
			dw_7.visible = false
			dw_8.visible = false
			dw_9.visible = false						
			dw_12.visible = false
			dw_18.visible = false
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
			dw_18.visible = false
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
			dw_18.visible = false
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
			dw_18.visible = false
			st_4.visible = FALSE
			st_5.visible = FALSE

 		CASE 5
			dw_2.visible = false
			dw_3.visible = false
			dw_4.visible = false
			dw_5.visible = false
			dw_6.visible = false
			dw_7.visible = false	
			dw_8.visible = false
			dw_9.visible = false		
			dw_12.visible = false	
			dw_18.visible = true
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

type tabpage_5 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 2857
integer height = 436
long backcolor = 79741120
string text = "반품율현황"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type st_3 from statictext within w_sh101_e
integer x = 1609
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

type dw_3 from datawindow within w_sh101_e
integer x = 32
integer y = 1380
integer width = 2839
integer height = 80
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh101_d03"
boolean border = false
boolean livescroll = true
end type

event doubleclicked;dw_2.visible = true
//dw_3.visible = false
end event

type dw_5 from datawindow within w_sh101_e
boolean visible = false
integer x = 50
integer y = 1388
integer width = 2793
integer height = 416
integer taborder = 200
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

type dw_4 from datawindow within w_sh101_e
boolean visible = false
integer x = 32
integer y = 1388
integer width = 2825
integer height = 416
integer taborder = 160
boolean bringtotop = true
string title = "none"
string dataobject = "D_SH129_D01"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;integer li_week_no
long ll_row
string ls_opt

dw_5.visible = true
dw_4.visible = false
st_4.visible = false
st_5.visible = false

if left(dwo.name,3) = 'all' then 	
	ls_opt = 'A'
else 
	ls_opt = 'B'
end if	

li_week_no = this.GetitemNumber(row, "week_no")

ll_row = dw_5.Retrieve(mid(gs_shop_cd,1,10) , li_week_no, gs_shop_cd, ls_opt)
IF ll_row < 1 THEN
	dw_4.insertRow(0) 
END IF 

end event

type st_4 from statictext within w_sh101_e
boolean visible = false
integer x = 2629
integer y = 1552
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

type st_5 from statictext within w_sh101_e
boolean visible = false
integer x = 2720
integer y = 1616
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

type dw_6 from datawindow within w_sh101_e
boolean visible = false
integer x = 55
integer y = 1384
integer width = 823
integer height = 432
integer taborder = 210
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

IF Pos(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = Mid(dwo.name, 4)

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = Mid(ls_report, 4, Len(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

type dw_7 from datawindow within w_sh101_e
boolean visible = false
integer x = 859
integer y = 1384
integer width = 2016
integer height = 432
integer taborder = 220
boolean bringtotop = true
string title = "none"
string dataobject = "D_SH101_D22"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_8 from datawindow within w_sh101_e
boolean visible = false
integer x = 23
integer y = 1376
integer width = 2857
integer height = 436
integer taborder = 100
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

ll_row = dw_9.Retrieve( mid(is_yymmdd,1,6), gs_brand, gs_shop_cd, li_week_no , 'B')

IF ll_row < 1 THEN
	dw_9.insertRow(0) 
END IF 

end event

type dw_9 from datawindow within w_sh101_e
boolean visible = false
integer x = 23
integer y = 1376
integer width = 2857
integer height = 436
integer taborder = 110
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

type dw_10 from datawindow within w_sh101_e
boolean visible = false
integer x = 247
integer y = 256
integer width = 2281
integer height = 732
integer taborder = 120
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



// 20131209~20131215
if trim(ls_coupon_no) <> "" and UPPER(ls_coupon_no) = 'T13620' and (UPPER(gs_brand) <> 'N' and UPPER(gs_brand) <> 'O' and UPPER(gs_brand) <> 'I')  THEN
	MessageBox("쿠폰오류", "사용 가능한 브랜드가 아닙니다.")
	return 1		
END IF


if ls_coupon_no = 'T09750' then 
	if not (GS_shop_cd = 'NG1136' or GS_shop_cd = 'OG0031') then
		messagebox("알림!", "선택한 이벤트에 해당되는 매장이 아닙니다 !!!")
		return 1
	end if	
end if

if ls_coupon_no = 'T09850' then 
	if not (GS_shop_cd = 'NG0006' or GS_shop_cd = 'NG1142' or GS_shop_cd = 'OG0003' or GS_shop_cd = 'OG0116') then
		messagebox("알림!", "선택한 이벤트에 해당되는 매장이 아닙니다 !!!")
		return 1
	end if	
end if


if ls_coupon_no = 'B14315' then 
	if not (GS_shop_cd = 'BG1869') then
		messagebox("알림!", "선택한 이벤트에 해당되는 매장이 아닙니다 !!!")
		return 1
	end if	
end if



if ls_coupon_no = 'P15130' then 
	if not (GS_shop_cd <> 'PB1803' and GS_shop_cd <> 'PG1871' and GS_shop_cd <> 'PG1874' and GS_shop_cd <> 'PB1817' and GS_shop_cd <> 'PD1900') then
		messagebox("알림!", "선택한 이벤트에 해당되는 매장이 아닙니다 !!!")
		return 1
	end if	
end if


if ls_coupon_no = 'B14830' then 
	if not (GS_shop_cd <> 'BB1824' and GS_shop_cd <> 'BB1823') then
		messagebox("알림!", "선택한 이벤트에 해당되는 매장이 아닙니다 !!!")
		return 1
	end if	
end if


if ls_coupon_no = 'N12130' then 
	if not (GS_shop_cd = 'NG1080' or GS_shop_cd = 'NG1092') then
		messagebox("알림!", "선택한 이벤트에 해당되는 매장이 아닙니다 !!!")
		return 1
	end if	
end if

if (ls_coupon_no = 'B14430' or ls_coupon_no = 'B14420') then 
	if not (GS_shop_cd = 'BB1812') then
		messagebox("알림!", "선택한 이벤트에 해당되는 매장이 아닙니다 !!!")
		return 1
	end if	
end if


if ls_coupon_no = 'I14220' then 
	messagebox("알림!", "코인코즈 직영몰에서만 사용가능합니다. !!!")
	return 1
end if


if ls_coupon_no = 'I14310' then 
	messagebox("알림!", "코인코즈 직영몰에서만 사용가능합니다. !!!")
	return 1
end if

if ls_coupon_no = 'B14610' then 
	messagebox("알림!", "라빠레뜨 직영몰에서만 사용가능합니다. !!!")
	return 1
end if


if ls_coupon_no = 'T12220' then 
	if not (gs_brand = 'N' or gs_brand = 'I') then
		messagebox("알림!", "선택한 이벤트에 해당되는 브랜드가 아닙니다 !!!")
		return 1
	end if	
end if


if ls_coupon_no = 'B15130' then 
	if not (GS_shop_cd = 'BG1862' or GS_shop_cd = 'BG1865') then
		messagebox("알림!", "선택한 이벤트에 해당되는 매장이 아닙니다 !!!")
		return 1
	end if	
end if

/*
if ls_coupon_no = 'N16001' then 
	if not (gs_brand <> 'N' ) then
		messagebox("알림!", "선택한 이벤트에 해당되는 매장이 아닙니다 !!!")
		return 1
	end if	
end if
*/

if ls_coupon_no = 'O15150' then 
	messagebox("알림!", "올리브데올리브 직영몰에서만 사용가능합니다. !!!")
	return 1
end if

if ls_coupon_no = 'N17002' then 
	if dw_1.getitemnumber(1,'sale_amt') < 100000 then
		messagebox("알림!", "구매금액이 100,000원 미만 이므로 해당대상이 아닙니다.!")
		return 1
	end if
end if

if ls_coupon_no = 'N17003' then 
	if dw_1.getitemnumber(1,'sale_amt') < 100000 then
		messagebox("알림!", "구매금액이 100,000원 미만 이므로 해당대상이 아닙니다.!")
		return 1
	end if
end if

if ls_coupon_no = 'N17004' then 
	/*
	IF wf_goods_chk(long(ld_goods_amt), ls_give_date)  THEN 		
		messagebox("알림!", "확인.")
		RETURN 1
	END IF
	*/
	wf_goods_chk(long(ld_goods_amt), ls_give_date)
	
	if isnull(ls_give_date) or ls_give_date = '' then
		messagebox("알림!", "행사 대상이 아닙니다.")
		return 1
	end if
	if dw_1.getitemnumber(1,'sale_amt') < 100000 then
		messagebox("알림!", "구매금액이 100,000원 미만 이므로 해당대상이 아닙니다.!")
		return 1
	end if
end if

if ls_coupon_no = 'N17005' then 
	/*
	IF wf_goods_chk(long(ld_goods_amt), ls_give_date)  THEN 		
		messagebox("알림!", "확인.")
		RETURN 1
	END IF
	*/
	IF wf_goods_chk(long(ld_goods_amt), ls_give_date) <> TRUE THEN
		wf_goods_amt_clear()
	END IF   
	 
	if isnull(ls_give_date) or ls_give_date = '' then
		messagebox("알림!", "행사 대상이 아닙니다.")
		return 1
	end if
	if dw_1.getitemnumber(1,'sale_amt') < 200000 then
		messagebox("알림!", "구매금액이 200,000원 미만 이므로 해당대상이 아닙니다.!")
		return 1
	end if
end if


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
	wf_goods_amt_clear()
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

type dw_11 from datawindow within w_sh101_e
boolean visible = false
integer x = 1102
integer y = 416
integer width = 1166
integer height = 428
integer taborder = 170
boolean bringtotop = true
boolean titlebar = true
string title = "의류교환권(비회원 대상 이벤트)"
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
			Parent.Post Event ue_tot_set()
		//wf_goods_chk(long(ld_goods_amt), ls_give_date)
		

END CHOOSE
end event

event constructor;

datetime ld_datetime
string ls_yymmdd
long ll_rowcnt
DataWindowChild ldw_child

if gs_shop_cd = "NG1082" then 
	select convert(char(08), dateadd(day, -1, getdate()),112)
	into :ls_yymmdd
	from dual;
else
	select convert(char(08), getdate(),112)
	into :ls_yymmdd
	from dual;
end if	

This.GetChild("event_id", idw_event_id)
idw_event_id.SetTransObject(SQLCA)
idw_event_id.Retrieve(ls_yymmdd, gs_brand)

//idw_event_id.Retrieve('20180908', gs_brand)

ll_rowcnt = idw_event_id.RowCount()

if ll_rowcnt > 0 then
	dw_1.object.cb_dept_give.visible = true
else
	dw_1.object.cb_dept_give.visible = false
end if	
	
end event

event itemchanged;CHOOSE CASE dwo.name
	CASE "event_id" 

	this.setitem(1, "dc_amt", 50000)
	
	if data = 'GC0901' then 
		this.setitem(1, "dc_amt", 30000)	 
		
		if not (GS_shop_cd = 'OG0034' or GS_shop_cd = 'OG0003' or GS_shop_cd = 'OG0038' or GS_shop_cd = 'OG0046' or GS_shop_cd = 'OG0048' or GS_shop_cd = 'OG0010' or GS_shop_cd = 'OG0008' or GS_shop_cd = 'OG0106') then
			messagebox("알림!", "선택한 이벤트에 해당되는 매장이 아닙니다 !!!")
		end if		
	end if
	
	if data = 'GC0902' then 
		this.setitem(1, "dc_amt", 100000)	 
	end if	

	if data = 'GC0903' or data = 'GC0904' or data = 'GC0905' then 
		this.setitem(1, "dc_amt", 30000)	 
	end if

	
	if data = 'B16112' then 
		this.setitem(1, "coupon_no", "B16112")
		this.setitem(1, "dc_amt", 5000)
	end if

	if data = 'B16113' then 
		this.setitem(1, "coupon_no", "B16113")
		this.setitem(1, "dc_amt", 10000)
	end if
	
	if data = 'B16114' then 
		this.setitem(1, "coupon_no", "B16114")
		this.setitem(1, "dc_amt", 20000)
	end if
	
	if data = 'D18091' then 
		this.setitem(1, "coupon_no", "D18091")
		this.setitem(1, "dc_amt", 10000)
	end if
	
	if data = 'D18092' then 
		this.setitem(1, "coupon_no", "D18092")
		this.setitem(1, "dc_amt", 20000)
	end if
	
		
END CHOOSE
end event

type dw_12 from datawindow within w_sh101_e
boolean visible = false
integer x = 1810
integer y = 1108
integer width = 1079
integer height = 688
integer taborder = 130
boolean bringtotop = true
boolean titlebar = true
string title = "고객구매현황"
string dataobject = "d_sh101_d26"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_list from datawindow within w_sh101_e
event ue_syscommand pbm_syscommand
integer y = 376
integer width = 2894
integer height = 900
integer taborder = 410
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

event doubleclicked;String ls_sale_no, ls_jumin, ls_coupon_no, ls_empno

IF row < 1 THEN RETURN

ls_sale_no = This.GetitemString(row, "sale_no")
ls_jumin   = This.GetitemString(row, "jumin")
ls_coupon_no = This.GetitemString(row, "coupon_no")
//ls_empno = This.GetitemString(row, "empty_3")
//
//if IsNull(ls_empno) or Trim(ls_empno) = "" then
//	is_empno = "000000"
//	dw_head.SetItem(1, "empno",  "")	
//else 	
//	dw_head.SetItem(1, "empno",      ls_empno)
//	is_empno = ls_empno
//end if


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

type dw_13 from datawindow within w_sh101_e
boolean visible = false
integer x = 795
integer y = 264
integer width = 1911
integer height = 964
integer taborder = 180
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

type cb_2 from commandbutton within w_sh101_e
boolean visible = false
integer x = 1701
integer y = 44
integer width = 384
integer height = 92
integer taborder = 390
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

type dw_back_sale from datawindow within w_sh101_e
event ue_keydown pbm_dwnkey
event close pbm_close
boolean visible = false
integer y = 24
integer width = 2894
integer height = 1804
integer taborder = 230
boolean bringtotop = true
boolean titlebar = true
string title = "일반회원 구매내역"
string dataobject = "d_sh101_d34"
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
      lc_kb[17] = Char (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = Char (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = Mid(ls_report, 4, Len(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE



end event

event constructor;DataWindowChild ldw_child 
long ll_row

//매장 미지정 안되게 수정 영업관리팀 요청사항(20131223)
This.GetChild("shop_cd", idw_shop_cd)
idw_shop_cd.SetTransObject(SQLCA)
//ll_row = idw_shop_cd.Retrieve(gs_brand)
ll_row = idw_shop_cd.Retrieve(gs_brand, gs_shop_cd)
ll_row = ll_row + 1
//idw_shop_cd.insertrow(ll_row)
//idw_shop_cd.setitem(ll_row,"shop_cd","")
//idw_shop_cd.setitem(ll_row,"shop_snm","")
//idw_shop_cd.setitem(ll_row,"shop_snm","매장 미지정")



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
long       ll_row_count, i, j = 0, ll_ret_cnt, ll_include_cnt
string 	  ls_yymmdd, ls_shop_cd, ls_shop_nm, ls_phone_no, ls_visiter, ls_dotcom, ls_rtrn_info, ls_empno, ls_empty_3
datetime   ls_datetime

IF row < 1 THEN RETURN


IF dw_back_sale.AcceptText() <> 1 THEN RETURN 

choose case dwo.name
	case "cb_return"


		


		if is_kakao_return_ok = 'N' then 
			messagebox("확인","카카오쿠폰 관련 판매는 부분 반품이 불가 합니다!")
			return 
		end if
		
		

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
					ls_rtrn_info   = ls_yymmdd + ls_shop_cd + right(ls_sale_no,2)
					ls_empno		= This.GetitemString(i, "empty_3")					
					ls_shop_cd 	= This.GetitemString(i, "shop_cd")
					ls_shop_type 	= This.GetitemString(i, "shop_type")

					select getdate()
					  into :ls_datetime
					  from dual;

					this.Setitem(i, "phone_no", is_yymmdd+gs_shop_cd)						
					this.Setitem(i, "mod_dt", ls_datetime)
					this.Setitem(i, "mod_id", gs_shop_cd)
					

													
					if isnull(ls_visiter) or ls_visiter= '' then
						messagebox("확인","반품구분을 입력해주세요..")
						return								
					end if

					if wf_style_chk_back(i, ls_style_no) = false then 
//					if gs_brand <> "Y" and  wf_style_chk_back(i, ls_style_no) = false then 						
						messagebox("확인","시즌 마감 되었거나 잘못된 스타일 입니다.")
						return 
					end if				

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
						if mid(gs_shop_cd,1,1) = "Y" then	
							ls_shop_type = ls_shop_type
						else
							 ls_shop_type = '1'
						end if					 
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
					dw_body.Setitem(j, "empty_3", ls_empno) 					
					
//					wf_style_set(j, ls_style, is_yymmdd, ld_sale_qty)  
					
//					if ls_phone_no = '미지정매장' then 
//						dw_body.Setitem(j, "phone_no", ls_phone_no)
//					else
						dw_body.Setitem(j, "phone_no", ls_rtrn_info)	
//					end if
					dw_body.Setitem(j, "visiter", ls_visiter)
					dw_body.Setitem(j, "dotcom", ls_dotcom)					
					
				
					
					
					if isnull(ls_empno) or len(ls_empno) < 7 then 
						
					is_empno = "000000"
					is_coupon_no = "000000000000"	
					is_empno_stat  = "N"		
						
						wf_style_set(j, ls_style, ls_yymmdd, ld_sale_qty)	
					end if
													
					
					
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
		dw_body.enabled = false
		dw_1.enabled = false
		dw_back_sale.Object.return_yn.Protect = 0
		dw_member_sale.visible = FALSE
		dw_back_sale.visible = FALSE

		cb_update.enabled = true	

		dw_19.retrieve(ls_yymmdd, ls_shop_cd, ls_sale_no, '%')
	
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
		
		if len(ls_shop_cd) = 6 and ls_shop_cd <> gs_shop_cd and (isnull(ls_style) or len(ls_style) < 8) then 
			messagebox('확인','스타일번호를 입력하세요..')
			this.reset()
			This.insertrow(1)
			this.setitem(1, "shop_cd", gs_shop_cd)
			this.setcolumn("style_no")
			this.setfocus()
			return 0
		end if
		
		if len(ls_yymmdd) = 8 and (isnull(ls_shop_cd) or len(ls_shop_cd) < 6) and len(ls_style) < 8 then 
			messagebox('확인','스타일번호를 입력하세요..')
			this.reset()
			This.insertrow(1)			
			this.setitem(1, "shop_cd", gs_shop_cd)
			this.setcolumn("shop_cd")
			this.setfocus()
			return 0			
		end if

		if ls_shop_cd = gs_shop_cd and (isnull(ls_yymmdd) or len(ls_yymmdd) < 8) and (isnull(ls_style) or len(ls_style) < 8) then 
			messagebox('확인','날짜 또는 스타일번호를 입력하세요..')
			this.reset()		
			this.insertrow(1)			
			this.setitem(1, "shop_cd", gs_shop_cd)			
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

		//messagebox("", ls_style + '/' +  ls_chno + '/' + ls_color + '/' + ls_size +   '/'+ ls_shop_cd +'/'+ ls_yymmdd + '/' + gs_shop_cd + '/' + string(ld_dc_rate,'00') + '/' + ls_dotcom	)	
		
		if il_rows = 0 then
			messagebox("확인","검색된 판매내역이 없습니다..")
		end if	
		dw_back_sale.Object.return_yn.Protect = 0
		is_member_return = 'N'			
end choose




Parent.Post Event ue_tot_set()




end event

event itemchanged;

integer li_ret
decimal ld_goods_amt
string ls_empno, ls_find, ls_yymmdd, ls_shop_cd
long ll_row_counts,ll_include_cnt, ll_row_cnt, ll_find,ll_list

CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		
		   if isnull(data) or data = '' then return 0
			
			li_ret = Parent.Trigger Event ue_Popup("style_no_back", row, data, 1)
			if li_ret = 1 then  
				return li_ret
			end if
			
			this.setitem(row,"style",left(data,8))
			this.setitem(row,"chno",mid(data,9,1))
			this.setitem(row,"color",mid(data,10,2))
			this.setitem(row,"size",mid(data,12,2))

	case "return_yn"
		if data = 'N' or isnull(data) then 
			this.setitem(row,"phone_no","")
		end if
//		
//		ls_empno = this.getitemstring(row, "empty_3")
//		ls_yymmdd = this.getitemstring(row, "yymmdd")
//		ls_shop_cd = this.getitemstring(row, "shop_cd")
//		
//		if data = 'Y' and isnull(ls_empno) = false then			
//						this.AcceptText() 
//			
//		 	    		select count(*)
//						into :ll_include_cnt
//						from tb_53010_h (nolock)
//						where yymmdd = :ls_yymmdd
//						and shop_cd = :ls_shop_cd	
//						and isnull(empty_3,'X') = :ls_empno	;
//						
//						ll_row_cnt    = this.RowCount() + 1
//						ll_find		= 1
//						
//						ls_find = "empty_3 = '" + ls_empno + "' and return_yn = 'Y' "
//						
//						messagebox("ls_find", ls_find)
//						
//						ll_find = this.find(ls_find, ll_find, ll_row_cnt)	
//						
//						DO WHILE ll_find > 0
//								//collect names
//								ll_list = ll_list + 1
//								
//								// Search again
//								ll_find++
//								ll_find = this.Find(ls_find, ll_find, ll_row_cnt )
//						LOOP						
//													
//						messagebox(string(ll_include_cnt, "0000"), string(ll_list, "0000"))		
//
//		end if
//		
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
		if len(string(data)) = 8 then
			ls_tag = This.Describe(ls_column_name + ".Tag")
			gf_kor_eng(Handle(Parent), ls_tag, 2)
			Send(Handle(This), 256, 9, long(0,0))
		end if
		
	case "chno"
		if len(string(data)) = 1 then
			ls_tag = This.Describe(ls_column_name + ".Tag")
			gf_kor_eng(Handle(Parent), ls_tag, 2)
			Send(Handle(This), 256, 9, long(0,0))
		end if
	
	case "color"
		if len(string(data)) = 2 then
			ls_tag = This.Describe(ls_column_name + ".Tag")
			gf_kor_eng(Handle(Parent), ls_tag, 2)
			Send(Handle(This), 256, 9, long(0,0))
		end if
	
	case "size"
		if len(string(data)) = 2 then
			ls_tag = This.Describe(ls_column_name + ".Tag")
			gf_kor_eng(Handle(Parent), ls_tag, 2)
			Send(Handle(This), 256, 9, long(0,0))
		end if
end choose







end event

event other;If wparam = 61536 then
	dw_body.enabled = True
	dw_1.enabled = True
	cb_1.enabled = True
	cb_retrieve.enabled = True
end if
end event

event itemfocuschanged;
integer li_ret
decimal ld_goods_amt
string ls_empno, ls_find, ls_yymmdd, ls_shop_cd, ls_return_yn, ls_empno_bf, ls_find2,ls_apply_type
long ll_row_counts,ll_include_cnt, ll_row_cnt, ll_find,ll_list, ll_cnt

this.AcceptText() 
ls_empno_bf = ""

CHOOSE CASE dwo.name

	case "visiter", "return_yn"
	
		is_kakao_return_ok = 'Y'
		ls_empno = this.getitemstring(row, "empty_3")
		ls_yymmdd = this.getitemstring(row, "yymmdd")
		ls_shop_cd = this.getitemstring(row, "shop_cd")
		ls_return_yn = this.getitemstring(row, "return_yn")		
		
		select  count(*), isnull(apply_type, 'D')
			into :ll_cnt, :ls_apply_type
			from tb_71011_kakao (nolock)
			where  apply_brand like '%' + :gs_brand + '%'
			and coupon_no = :ls_empno
			group by isnull(apply_type, 'D');
			
		//	messagebox(string(ll_cnt, "0000"), ls_apply_type)
		
		if ls_return_yn = 'Y' and isnull(ls_empno) = false then			
					
			
		 	    		select count(*)
						into :ll_include_cnt
						from tb_53010_h (nolock)
						where yymmdd = :ls_yymmdd
						and shop_cd = :ls_shop_cd	
						and isnull(empty_3,'X') = :ls_empno	;
						
						ll_row_cnt    = this.RowCount() + 1
						ll_find		= 1
						
						ls_find = "empty_3 = '" + ls_empno + "' and return_yn = 'Y' "
						ls_find2 = "empty_3 = '" + ls_empno + "' "
				//		messagebox("ls_find", ls_find)
						
						ll_find = this.find(ls_find2, ll_find, ll_row_cnt)	
						
						DO WHILE ll_find > 0
								//collect names
									if ls_apply_type = 'E' or ls_apply_type = 'F' then
										this.Object.return_yn.Protect = 1
										this.setitem(ll_find, "return_yn", "Y")
										this.setitem(ll_find, "visiter", "반품")				
									end if
								// Search again
								ll_find++
								ll_find = this.Find(ls_find2, ll_find, ll_row_cnt )
						LOOP						
						
						
						ll_find = this.find(ls_find, ll_find, ll_row_cnt)	
						
						DO WHILE ll_find > 0
								//collect names
								ll_list = ll_list + 1
								
								// Search again
								ll_find++
								ll_find = this.Find(ls_find, ll_find, ll_row_cnt )
						LOOP						
															
							if ll_include_cnt = ll_list  then

									is_kakao_return_ok = "Y"
								else 	
									is_kakao_return_ok = "N"	

							end if	


		end if
		
		
		
END CHOOSE


end event

type dw_member_sale from datawindow within w_sh101_e
event ue_return_point ( )
boolean visible = false
integer y = 24
integer width = 2894
integer height = 1792
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "고객구매내역"
string dataobject = "d_sh101_d31"
boolean controlmenu = true
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
string     ls_phone_no, ls_visiter, ls_yymmdd,ls_rtrn_info,ls_shop_cd, ls_sale_no, ls_empno
int        li_sale_qty
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
ls_phone_no= ''

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
		ls_empno		= This.GetitemString(i, "empno")		

		ls_shop_cd     = This.GetitemString(i, "shop_cd")	
		ls_sale_no     = This.GetitemString(i, "sale_no")
		
		
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
				
		if li_sale_qty < 1 then
			messagebox("확인","기존에 반품처리건이 있습니다.")
			return -1
		end if
		
		

		if left(ls_phone_no,1) = "R"  and isnull(ls_phone_no) = false  then
			MessageBox("확인","이미 반품처리된 대상으로 확인됩니다. ")
			return
		end if
		
		if wf_style_chk_back_member(j, ls_style_no) = false then 
			messagebox("확인","시즌 마감 되었거나 잘못된 스타일 입니다.")
			return 
		end if	
/*		
		select sum(sale_qty) as sale_qty
		into :li_sale_qty
		from tb_53010_h with (nolock)
		where style = :ls_style
				and chno = :ls_chno
				and color = :ls_color
				and size = :ls_size
				and card_no = :ls_card_no;
				
		if li_sale_qty < 1 then
			messagebox("확인","기존에 반품처리건이 있습니다.")
			return
		end if
*/
		
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
		dw_body.Setitem(j, "empty_3", ls_empno)			
		
//		wf_style_set(j, ls_style, ls_yymmdd, ld_sale_qty)		

		if isnull(ls_empno) or len(ls_empno) < 7 then 
			wf_style_set(j, ls_style, ls_yymmdd, ld_sale_qty)	
		end if


		ls_rtrn_info   = "R" + ls_shop_cd + ls_yymmdd 
		this.Setitem(i, "phone_no", ls_rtrn_info)				
		
		dw_member_sale.SetItemStatus(i, "phone_no", Primary!, DataModified!)
		dw_member_sale.SetItemStatus(i, "visiter", Primary!, DataModified!)
		
	elseif  ls_return_yn = 'N' THEN
		//setnull(ls_phone_no)
		//setnull(ls_visiter)
		
		//This.Setitem(i, "phone_no", ls_phone_no)
		//This.Setitem(i, "visiter", ls_visiter)
		//dw_member_sale.SetItemStatus(i, "phone_no", Primary!, DataModified!)
		//dw_member_sale.SetItemStatus(i, "visiter", Primary!, DataModified!)	

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

event other;If wparam = 61536 then
	dw_body.enabled = True
	dw_1.enabled = True
end if
end event

type st_6 from statictext within w_sh101_e
integer x = 37
integer y = 284
integer width = 1408
integer height = 64
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

type dw_14 from datawindow within w_sh101_e
boolean visible = false
integer x = 1038
integer y = 272
integer width = 1723
integer height = 1112
integer taborder = 240
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

type dw_15 from datawindow within w_sh101_e
boolean visible = false
integer x = 1595
integer y = 472
integer width = 544
integer height = 596
integer taborder = 250
boolean bringtotop = true
boolean titlebar = true
string title = "리스트"
string dataobject = "d_vote_list"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_ok_coupon1 from statictext within w_sh101_e
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

type st_ok_coupon2 from statictext within w_sh101_e
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

type dw_16 from datawindow within w_sh101_e
boolean visible = false
integer y = 140
integer width = 2894
integer height = 1684
integer taborder = 270
boolean bringtotop = true
boolean titlebar = true
string title = "매장 정보"
string dataobject = "d_61040_r00"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = styleshadowbox!
end type

type shl_member from statichyperlink within w_sh101_e
integer x = 672
integer y = 1040
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

event clicked;//string   ls_url
//
//ls_url = "https://membership.ibeaucre.co.kr:450/member/join.asp?simple=Y&shop_cd="+gs_shop_cd
////ls_url = "http://new-membership.ibeaucre.co.kr/mem_ins_form.htm?shop_cd="+gs_shop_cd
//shl_member.url = ls_url
//

Ulong lul_handle
long  ll_cnt


String ls_Command = "open"
String ls_Dir = ""
String ls_Args ="" //"toolbar=no,status=no,scrollbars=no,resizable=no,menubar=no,width=800,height=600"
String ls_URL = "https://membership.ibeaucre.co.kr:450/member/join.asp?simple=Y&shop_cd="+gs_shop_cd

ls_url = "https://membership.ibeaucre.co.kr:450/member/join.asp?simple=Y&shop_cd="+gs_shop_cd

//ll_cnt = ShellExecuteA( 0, ls_Command, ls_URL, ls_Args, ls_Dir, 5 )
ll_cnt = ShellExecuteW( 0, ls_Command, ls_URL, ls_Args, ls_Dir, 5 )
end event

type dw_17 from datawindow within w_sh101_e
boolean visible = false
integer x = 91
integer y = 692
integer width = 2633
integer height = 616
integer taborder = 280
boolean bringtotop = true
boolean titlebar = true
string title = "고객안내"
string dataobject = "d_sh101_d36"
boolean controlmenu = true
borderstyle borderstyle = styleshadowbox!
end type

type dw_18 from datawindow within w_sh101_e
boolean visible = false
integer x = 18
integer y = 1384
integer width = 2853
integer height = 424
integer taborder = 340
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh101_d07"
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event buttonclicked;string ls_date, ls_shop_cd

IF dwo.name = "b_renew" THEN  	//반품율현황 새로 고침

	ls_date = string(dw_head.GetItemDate(1,'yymmdd'))
	ls_date = mid(ls_date,1,4) + mid(ls_date,6,2) + mid(ls_date,9,2)
	ls_date = mid(ls_date,1,6)	
	
	if mid(gs_shop_cd,2,1) = 'H' then
		select dbo.SF_DOTCOM_SHOP(:gs_shop_cd)	
		into :ls_shop_cd
		from dual;
	else
		ls_shop_cd = gs_shop_cd
	end if
	
	dw_18.retrieve(gs_brand, ls_date, '%', ls_shop_cd)
END IF	



end event

type dw_19 from datawindow within w_sh101_e
boolean visible = false
integer x = 1097
integer y = 712
integer width = 1728
integer height = 524
integer taborder = 350
boolean bringtotop = true
boolean titlebar = true
string title = "GOPANDA 쿠폰"
string dataobject = "d_sh101_d37"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;string ls_barcord, ls_sale_type, ls_dc_rate, ls_user, ls_style
long ll_dc_rate, ll_collect_price, ll_sale_price, ll_curr_price,ld_goods_amt, ll_cnt
int i

dw_19.accepttext()
IF dwo.name = "b_1" THEN  
		
	is_coupon_gubn = dw_19.getitemstring(1,'coupon_gubn')
	if is_coupon_gubn = '' or isnull(is_coupon_gubn) then
		messagebox('확인', '구분을 선택해주세요!')
		return
	end if
	
	if	is_coupon_gubn = '03'then
		if dw_1.getitemstring(1,'card_no') = '' or isnull(dw_1.getitemstring(1,'card_no')) then
		else
			messagebox('확인', '회원 할인은 적용이 안됩니다. 다시 입력해 선택해주세요!')
			return
		end if
	end if
	
	ls_barcord = dw_19.getitemstring(1,'barcord_no')
	if ls_barcord = '' or isnull(ls_barcord) then
		messagebox('확인', '바코드를 번호를 넣어주세요!')
		return
	end if
	
	if dw_19.getitemstring(1,'use_gubn') = 'N' then
		messagebox('확인', '사용구분을 선택해 주세요!')
		return
	end if		

	if mid(ls_barcord,1,3) <> 'GP1' then
		if mid(ls_barcord,2,5) <> '16201' then
			if is_coupon_gubn <> '03' then
				messagebox('확인', '쿠폰번호를 확인해 주세요!')
				return
			end if
		end if
	end if		

	ll_cnt = 0
	ll_cnt = dw_body.rowcount()
	for i = 1 to ll_cnt
		if dw_19.getitemstring(i,'coupon_gubn') = '01' then
			if mid(dw_19.getitemstring(i,'barcord_no'),2,5) <> '16201' then
				messagebox('확인','쿠폰번호를 확인해 주세요1!')
				return 0
			end if
		elseif dw_19.getitemstring(i,'coupon_gubn') = '02' then
				if dw_19.getitemstring(i,'barcord_no') = 'GP15KR0110151'  then
				elseif dw_19.getitemstring(i,'barcord_no') = 'GP16KR0100305' then
				else
					messagebox('확인','쿠폰번호를 확인해 주세요2!')
					return 0
				end if
		elseif dw_19.getitemstring(i,'coupon_gubn') = '03' then
				if len(dw_19.getitemstring(i,'barcord_no')) <> 8  then
					messagebox('확인','쿠폰번호를 확인해 주세요2!')
					return 0
				end if
		end if
	next
	
	if mid(ls_barcord,1,4) = 'GP15' then //고판다 적용
	//	쿠폰번호 9자리의 숫자로 할인율 체크하기로 함.
	//	GP15KR0110151	

		ls_dc_rate = mid(ls_barcord,9,2)
		
		//messagebox('ls_dc_rate',ls_dc_rate)	
		select	sale_type, dc_rate
		into		:ls_sale_type, :ll_dc_rate
		from tb_53010_sale_shop
		where shop_cd = :gs_shop_cd
				and dc_rate = :ls_dc_rate
				and sale_type like '%_C'
				and :is_yymmdd >= start_ymd and :is_yymmdd <= end_ymd;
	
		if ls_sale_type = '' or isnull(ls_sale_type)	then
			messagebox('확인', '올바른 쿠폰번호가 아닙니다. 다시 입력해 주세요11!')
			return
		end if
	
		if ls_sale_type = '1C' then
			for i=1 to dw_body.rowcount()
				if dw_body.getitemstring(i,'sale_type') <> '11' then
					messagebox('확인','정상상품에만 적용이 가능합니다!')
					return
				end if
			next
/*
		elseif ls_sale_type = '2C' then
			for i=1 to dw_body.rowcount()-1
				string ls_chk_type, ls_style
				ls_chk_type = dw_body.getitemstring(i,'sale_type')
				ls_chk_type = mid(ls_chk_type,1,1)
				ls_style = dw_body.getitemstring(i,'style')
	
				if ls_style = 'BP5XV600' or ls_style = 'BP5XA602' or ls_style = 'BP5XS603' or ls_style = 'BP5XQ604' or ls_style = 'BP5XV605' then				
					
				else
					messagebox('확인','쿠폰적용 상품이 아닙니다! 다시 확인후 처리 바랍니다!')
					return
				end if
			next
*/
		end if

	
	//messagebox('ls_sale_type',ls_sale_type)
	//messagebox('ll_dc_rate',ll_dc_rate)
	
	
		ld_goods_amt  = dw_body.GetitemNumber(row, "goods_amt")
		ls_user = dw_1.getitemstring(1,'user_name')
	
		ll_cnt = 0
		ll_cnt = dw_body.rowcount()
		for i=1 to ll_cnt 
			if ls_user <> '' then //고객데이터가 있을경우
				ll_curr_price = dw_body.GetitemNumber(i, "curr_price")
				ll_sale_price    = ll_curr_price * (100 - (5 + ll_dc_rate)) / 100 
				gf_marjin_price(gs_shop_cd, ll_sale_price, gsv_cd.gdc_cd1, ll_collect_price) 
				idc_dc_rate_org = gsv_cd.gl_cd1
				dw_body.Setitem(i, "dc_rate_org",   ll_dc_rate) 
				dw_body.Setitem(i, "sale_type",     ls_sale_type) 
				dw_body.Setitem(i, "dc_rate",       5 + ll_dc_rate) 
				dw_body.Setitem(i, "sale_rate",     gdc_sale_rate )// gsv_cd.gdc_cd1) 
				dw_body.Setitem(i, "sale_price",    ll_sale_price)
				dw_body.Setitem(i, "collect_price", ll_collect_price)	
				dw_body.setitem(i, "coupon_no", "B15999")
			else //고객데이터가 없을경우
				ll_curr_price = dw_body.GetitemNumber(i, "curr_price")
				ll_sale_price    = ll_curr_price * (100 - ll_dc_rate) / 100 
				gf_marjin_price(gs_shop_cd, ll_sale_price, gsv_cd.gdc_cd1, ll_collect_price) 
				idc_dc_rate_org = gsv_cd.gl_cd1
				dw_body.Setitem(i, "dc_rate_org",   ll_dc_rate) 		
				dw_body.Setitem(i, "sale_type",     ls_sale_type) 
				dw_body.Setitem(i, "dc_rate",       ll_dc_rate) 
				dw_body.Setitem(i, "sale_rate",     gdc_sale_rate )// gsv_cd.gdc_cd1) 
				dw_body.Setitem(i, "sale_price",    ll_sale_price)
				dw_body.Setitem(i, "collect_price", ll_collect_price)		
				dw_body.setitem(i, "coupon_no", "B15999")		
			end if	
	
			dw_1.Setitem(1, "give_rate", 0)
		
		next	
	// 16년도는 아래 쿠폰으로 50% 적용
	// GP16 KR01 00305	
	//	bp5xp552
	//	bp5xs551
	// bp5xt550
	elseif mid(ls_barcord,1,4) = 'GP16' then //고판다 적용
		for i=1 to dw_body.rowcount()-1
			ls_style = dw_body.getitemstring(i,'style')
			if ls_style = 'BP5XP552' or ls_style = 'BP5XS551' or ls_style = 'BP5XT550' then				
				
			else
				messagebox('확인','쿠폰적용 상품이 아닙니다! 다시 확인후 처리 바랍니다!')
				return
			end if
		next		
		//다른 할인율 적용안되고 처리되게 요청함.
		ls_sale_type = '5C' 
		ll_dc_rate = 50
		ll_cnt = 0
		ll_cnt = dw_body.rowcount()
		for i=1 to ll_cnt 
			ll_curr_price = dw_body.GetitemNumber(i, "curr_price")
			ll_sale_price    = ll_curr_price * (100 - ll_dc_rate) / 100 
			gf_marjin_price(gs_shop_cd, ll_sale_price, gsv_cd.gdc_cd1, ll_collect_price)
			idc_dc_rate_org = gsv_cd.gl_cd1
			dw_body.Setitem(i, "dc_rate_org",   ll_dc_rate) 		
			dw_body.Setitem(i, "sale_type",     ls_sale_type) 
			dw_body.Setitem(i, "dc_rate",       ll_dc_rate) 
//			dw_body.Setitem(i, "sale_rate",     gdc_sale_rate )// gsv_cd.gdc_cd1) 
			dw_body.Setitem(i, "sale_price",    ll_sale_price)
			dw_body.Setitem(i, "collect_price", ll_collect_price)	
			dw_body.setitem(i,"coupon_no", "B15999")		
			dw_1.Setitem(1, "give_rate", 0)
		next

	elseif mid(ls_barcord,2,5) = '16201' then // 중국프로모션 적용		
		if gs_brand = 'N' then
			for i=1 to dw_body.rowcount()
				if dw_body.getitemstring(i,'sale_type') <> '11' then
					messagebox('확인','정상상품에만 적용이 가능합니다!')
					return
				end if
			next
			ls_sale_type = '1C'
			ll_dc_rate = 10
		elseif gs_brand = 'B' then
			for i=1 to dw_body.rowcount()
				if (dw_body.getitemstring(i,'sale_type') > '15')  then
					messagebox('확인','정상상품에만 적용이 가능합니다1!')
					return
				end if
			next
			ls_sale_type = '2C'
			ll_dc_rate = 20
		end if
		//다른 할인율 적용안되고 처리되게 요청함.
		ll_cnt = 0
		ll_cnt = dw_body.rowcount()
		for i=1 to ll_cnt 
			ll_curr_price = dw_body.GetitemNumber(i, "curr_price")
			ll_sale_price    = ll_curr_price * (100 - ll_dc_rate) / 100 
			gf_marjin_price(gs_shop_cd, ll_sale_price, gsv_cd.gdc_cd1, ll_collect_price)
			idc_dc_rate_org = gsv_cd.gl_cd1
			dw_body.Setitem(i, "dc_rate_org",   ll_dc_rate) 		
			dw_body.Setitem(i, "sale_type",     ls_sale_type) 
			dw_body.Setitem(i, "dc_rate",       ll_dc_rate) 
//			dw_body.Setitem(i, "sale_rate",     gdc_sale_rate )// gsv_cd.gdc_cd1) 
			dw_body.Setitem(i, "sale_price",    ll_sale_price)
			dw_body.Setitem(i, "collect_price", ll_collect_price)	
			dw_body.setitem(i,"coupon_no", gs_brand + "16201")		
			dw_1.Setitem(1, "give_rate", 0)
		next

	elseif is_coupon_gubn = '03' and len(ls_barcord) = 8 then // Ctrip프로모션 적용		
		if gs_brand = 'B' then
			for i=1 to dw_body.rowcount()
				if (dw_body.getitemstring(i,'sale_type') > '11')  then
					messagebox('확인','정상상품에만 적용이 가능합니다1!')
					return
				end if
			next
			ls_sale_type = '1C'
			ll_dc_rate = 10
		end if
		//다른 할인율 적용안되고 처리되게 요청함.
		ll_cnt = 0
		ll_cnt = dw_body.rowcount()
		for i=1 to ll_cnt 
			ll_curr_price = dw_body.GetitemNumber(i, "curr_price")
			ll_sale_price    = ll_curr_price * (100 - ll_dc_rate) / 100 
			gf_marjin_price(gs_shop_cd, ll_sale_price, gsv_cd.gdc_cd1, ll_collect_price)
			idc_dc_rate_org = gsv_cd.gl_cd1
			dw_body.Setitem(i, "dc_rate_org",   ll_dc_rate) 		
			dw_body.Setitem(i, "sale_type",     ls_sale_type) 
			dw_body.Setitem(i, "dc_rate",       ll_dc_rate) 
//			dw_body.Setitem(i, "sale_rate",     gdc_sale_rate )// gsv_cd.gdc_cd1) 
			dw_body.Setitem(i, "sale_price",    ll_sale_price)
			dw_body.Setitem(i, "collect_price", ll_collect_price)	
			dw_body.setitem(i,"coupon_no", gs_brand + "16301")		
			dw_1.Setitem(1, "give_rate", 0)
		next
	end if
	

	

	dw_19.visible = false	


	
//	wf_goods_chk(long(ld_goods_amt), ls_coupon_no)
	wf_amt_set(row, This.Object.sale_qty[row]) 
   ib_changed = true
   cb_update.enabled = true
	Parent.Trigger Event ue_tot_set()


END IF	



end event

type dw_cosmetic from datawindow within w_sh101_e
boolean visible = false
integer x = 283
integer y = 372
integer width = 1477
integer height = 700
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh101_d38"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type em_1 from editmask within w_sh101_e
boolean visible = false
integer x = 1760
integer y = 416
integer width = 402
integer height = 84
integer taborder = 290
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

type st_7 from statictext within w_sh101_e
boolean visible = false
integer x = 1189
integer y = 352
integer width = 974
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "세트상품 판매수량을 입력해 주세요!"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_20 from datawindow within w_sh101_e
boolean visible = false
integer x = 1504
integer y = 364
integer width = 667
integer height = 288
integer taborder = 300
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

type dw_21 from datawindow within w_sh101_e
boolean visible = false
integer x = 1248
integer y = 268
integer width = 1623
integer height = 1540
integer taborder = 310
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

type st_8 from statictext within w_sh101_e
integer x = 1650
integer y = 212
integer width = 2697
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711935
long backcolor = 67108864
string text = "※ 판매유형은 온앤온만 적용됩니다. "
boolean focusrectangle = false
end type

type cb_3 from commandbutton within w_sh101_e
boolean visible = false
integer x = 882
integer y = 40
integer width = 494
integer height = 96
integer taborder = 360
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "예약 인도일 등록"
end type

event clicked;gsv_cd.gs_cd2 = is_yymmdd

OpenWithParm (W_SH190_E, "고객인도일 등록") 
end event

type st_online_gubn from statictext within w_sh101_e
boolean visible = false
integer x = 64
integer y = 292
integer width = 603
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
string text = "Lounge B 가입구분 :"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_sh101_e
boolean visible = false
integer x = 672
integer y = 292
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
string text = "신규"
end type

event clicked;if rb_1.checked = true and sle_id.text <> '' then
	cb_online_coupon.enabled = true
else
	cb_online_coupon.enabled = false
end if
end event

type rb_2 from radiobutton within w_sh101_e
boolean visible = false
integer x = 928
integer y = 292
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
string text = "기가입"
end type

event clicked;if	is_coupon = 'Y' then
	messagebox('확인!','신규가입 20%쿠폰을 사용하였습니다. 기가입으로 변경이 불가능 합니다.')
	rb_1.checked = true
	rb_2.checked = false
	return
end if

/*
if rb_1.checked = true and sle_id.text <> '' then
	cb_online_coupon.enabled = true
else
	cb_online_coupon.enabled = false
end if
*/
end event

type st_online_id from statictext within w_sh101_e
boolean visible = false
integer x = 1266
integer y = 296
integer width = 443
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
string text = "Lounge B ID :"
boolean focusrectangle = false
end type

type sle_id from singlelineedit within w_sh101_e
boolean visible = false
integer x = 1710
integer y = 284
integer width = 571
integer height = 76
integer taborder = 370
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;long ll_row_count
int i

ll_row_count = dw_body.getrow()

for i = 1 to ll_row_count 
	if dw_body.getItemstring(i, "empty_1") = '사용완료' then
		cb_online_coupon.enabled = false		
		messagebox('확인!','이미 상품별 할인 쿠폰을 사용 했습니다.')
		return
	end if
next

if is_coupon = 'Y' then 
	cb_online_coupon.enabled = false
end if

if rb_1.checked = true and sle_id.text <> '' then
	cb_online_coupon.enabled = true
else
	cb_online_coupon.enabled = false
end if
end event

type cb_online_coupon from commandbutton within w_sh101_e
boolean visible = false
integer x = 2354
integer y = 276
integer width = 526
integer height = 84
integer taborder = 320
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "신규가입 20%쿠폰"
end type

event clicked;String ls_style_no, ls_yes , ls_coupon_no, ls_user, ls_online_id, ls_style_no_chk
Long   ll_curr_price, ll_sale_price, ll_collect_price, ld_goods_amt,ll_dc_rate, ld_dc_rate, ld_sale_price, ld_tag_price
long start_pos=1
string old_str, new_str, mystring

//if dwo.name <> "sale_type" OR gs_brand = "O" or  gs_brand = "W" then return
long ll_row_count, i
	dw_body.accepttext()
	ll_row_count = dw_body.getrow()

	ls_style_no_chk = dw_body.getitemstring(1,'style_no')
	if ls_style_no_chk = '' or isnull(ls_style_no_chk) then 
		messagebox('확인!','판매내역을 먼저 등록해 주세요!')
		return 
	end if
	
	if is_coupon = 'Y' then
		messagebox('확인!','이미 신규가입 20%쿠폰을 사용 했습니다.')
		cb_online_coupon.enabled = false
		return
	end if
	
	if cb_online_coupon.enabled = false then
		return
	end if
	
	for i = 1 to ll_row_count 
		if dw_body.getItemstring(i, "empty_1") = '사용완료' then
			messagebox('확인!','이미 상품별 할인 쿠폰을 사용 했습니다.')
			cb_online_coupon.enabled = false
			return
		end if
	next
	
	ll_dc_rate = 20

	cb_online_coupon.enabled = false

	mystring = sle_id.text
	old_str = ' '
	new_str = ''
	start_pos = Pos(mystring, old_str, start_pos)
	
	DO WHILE start_pos > 0
		mystring = Replace(mystring, start_pos, Len(old_str), new_str)
		start_pos = Pos(mystring, old_str, start_pos+Len(new_str))
	LOOP
	
	sle_id.text = mystring
	ls_online_id = sle_id.text
	
	if isnull(ls_online_id) or ls_online_id = '' then 
		messagebox('확인', 'Lounge B ID를 입력해 주세요!')
		return 0
	end if

	for i = 1 to ll_row_count 
		IF ll_dc_rate > 0   THEN 
			ll_curr_price = dw_body.GetitemNumber(i, "curr_price")
			ld_goods_amt  = dw_body.GetitemNumber(i, "goods_amt")
			ld_dc_rate    = dw_body.GetitemNumber(i, "dc_rate")
			ld_sale_price = dw_body.GetitemNumber(i, "sale_price")
			ld_tag_price  = dw_body.GetitemNumber(i, "tag_price")			
/*			
				ll_sale_price    = ll_curr_price * (100 - (ll_dc_rate + ld_dc_rate)) / 100 
				gf_marjin_price(gs_shop_cd, ll_sale_price, ld_dc_rate, ll_collect_price) 
				
				idc_dc_rate_org = ld_dc_rate
				dw_body.Setitem(i, "dc_rate_org",   gsv_cd.gl_cd1) 
				dw_body.Setitem(i, "dc_rate",       ll_dc_rate + idc_dc_rate_org) 
				dw_body.Setitem(i, "sale_rate",     gdc_sale_rate )// gsv_cd.gdc_cd1) 
				dw_body.Setitem(i, "sale_price",    ll_sale_price)
				dw_body.Setitem(i, "collect_price", ll_collect_price)
*/		
				//할인율 들어간 금액
				if ld_dc_rate > 0 then
					
//					if ld_dc_rate > 20 then
//						messagebox('확인', '쿠폰 적용시 제품 판매 가격이 정상가 대비 40% 이상인 경우 최대 40%만 적용 가능합니다. ')
//						ll_dc_rate = 40 - ld_dc_rate
//					end if	
					
					ll_sale_price    = ll_curr_price * (100 - (ll_dc_rate + ld_dc_rate)) / 100 
					
					
					gf_marjin_price(gs_shop_cd, ll_sale_price, ld_dc_rate, ll_collect_price) 
					
					idc_dc_rate_org = ld_dc_rate
					dw_body.Setitem(i, "dc_rate_org",   gsv_cd.gl_cd1) 
					dw_body.Setitem(i, "dc_rate",       ll_dc_rate + idc_dc_rate_org) 
					dw_body.Setitem(i, "sale_rate",     gdc_sale_rate )// gsv_cd.gdc_cd1) 
					dw_body.Setitem(i, "sale_price",    ll_sale_price)
					dw_body.Setitem(i, "collect_price", ll_collect_price)
				else //금액자체로 넣은 것들
					
//					if ( 1 - (ld_sale_price / ld_tag_price ) ) * 100 > 20 then
//						messagebox('확인', '쿠폰 적용시 제품 판매 가격이 정상가 대비 40% 이상인 경우 최대 40%만 적용 가능합니다. ')
//						ll_dc_rate = 40 - ( 1 - (ld_sale_price / ld_tag_price ) ) * 100
//					end if	
//					
					ll_sale_price    = ld_sale_price * (100 - (ll_dc_rate + ld_dc_rate)) / 100 
					
					
					gf_marjin_price(gs_shop_cd, ll_sale_price, ld_dc_rate, ll_collect_price) 
					
					idc_dc_rate_org = ld_dc_rate
					
					dw_body.Setitem(i, "dc_rate_org",   gsv_cd.gl_cd1) 
					dw_body.Setitem(i, "dc_rate",       ll_dc_rate + idc_dc_rate_org) 
					dw_body.Setitem(i, "sale_rate",     gdc_sale_rate )// gsv_cd.gdc_cd1) 
					dw_body.Setitem(i, "sale_price",    ll_sale_price)
					dw_body.Setitem(i, "collect_price", ll_collect_price)
				end if

			wf_goods_chk(long(ld_goods_amt), ls_coupon_no)
			wf_amt_set(i, dw_body.Object.sale_qty[i]) 
			ib_changed = true
			cb_update.enabled = true
			Parent.Trigger Event ue_tot_set()
		END IF 
	next
			
	is_coupon = 'Y'
end event

type cb_emp_sale from commandbutton within w_sh101_e
event ue_keydown pbm_keydown
integer x = 1746
integer y = 44
integer width = 425
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "사우행사입력(&P)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
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
IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN

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

dw_body.setcolumn("style_no")
dw_body.setfocus()

Parent.Trigger Event ue_button(6, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

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

type cb_kakao_coupon from commandbutton within w_sh101_e
event ue_keydown pbm_keydown
boolean visible = false
integer x = 1298
integer y = 44
integer width = 439
integer height = 92
integer taborder = 400
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "플친쿠폰사용(&P)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
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
IF Trigger Event ue_keycheck('4') = FALSE THEN RETURN

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
dw_body.Object.sale_qty.Protect=0

dw_body.setcolumn("style_no")
dw_body.setfocus()

Parent.Trigger Event ue_button(6, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

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

type st_9 from statictext within w_sh101_e
integer x = 1650
integer y = 260
integer width = 2715
integer height = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type dw_22 from datawindow within w_sh101_e
integer x = 2057
integer y = 688
integer width = 832
integer height = 712
integer taborder = 360
boolean bringtotop = true
boolean titlebar = true
string title = "일마감(저장을 꼭 눌러주세요!)"
string dataobject = "d_sh101_d41"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event itemchanged;///* 시스템 날짜를 가져온다 */

end event

event buttonclicked;String ls_jumin, ls_style,ls_Flag
decimal ld_dc_rate
integer i
long ll_row_count,ll_row
datetime ld_datetime 


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


	
IF dw_22.AcceptText() <> 1 THEN RETURN -1

ll_row_count = dw_22.RowCount()


IF dwo.name = "cb_save" THEN  //회원반품
	
		FOR i=1 TO ll_row_count
			
				ls_Flag = dw_22.getitemstring(i,"new_chk")			
				if ls_Flag = "NEW" then	dw_22.SetItemStatus(i, 0, Primary!,New!)
			
				idw_status = dw_22.GetItemStatus(i, 0, Primary!)
				IF idw_status = NewModified! THEN				/* New Record */
					dw_22.Setitem(i, "shop_cd",  gs_shop_cd)
					dw_22.Setitem(i, "reg_id", gs_user_id)
				ELSEIF idw_status = DataModified! THEN		/* Modify Record */
					dw_22.Setitem(i, "mod_id", gs_user_id)
					dw_22.Setitem(i, "mod_ymd", ld_datetime)
				END IF
			NEXT	
		
		
		il_rows = dw_22.Update(True, False)
		
		if il_rows = 1 then
			commit  USING SQLCA;		
			dw_22.retrieve(is_yymmdd, gs_shop_cd)
		else
			rollback  USING SQLCA;		
		
		end if
	
	
	
	
END IF	



end event

