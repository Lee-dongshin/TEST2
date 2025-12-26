$PBExportHeader$w_sh101_e_backup.srw
$PBExportComments$판매일보등록
forward
global type w_sh101_e_backup from w_com010_e
end type
type dw_1 from datawindow within w_sh101_e_backup
end type
type cb_1 from commandbutton within w_sh101_e_backup
end type
type dw_point from datawindow within w_sh101_e_backup
end type
type st_2 from statictext within w_sh101_e_backup
end type
type dw_list from datawindow within w_sh101_e_backup
end type
type st_1 from statictext within w_sh101_e_backup
end type
type dw_2 from datawindow within w_sh101_e_backup
end type
type dw_3 from datawindow within w_sh101_e_backup
end type
type gb_1 from groupbox within w_sh101_e_backup
end type
end forward

global type w_sh101_e_backup from w_com010_e
integer width = 2953
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
event ue_tot_set ( )
event ue_total_retrieve ( )
event ue_point_update ( )
dw_1 dw_1
cb_1 cb_1
dw_point dw_point
st_2 st_2
dw_list dw_list
st_1 st_1
dw_2 dw_2
dw_3 dw_3
gb_1 gb_1
end type
global w_sh101_e_backup w_sh101_e_backup

type variables
String is_yymmdd, is_sale_no, is_tel_no3


end variables

forward prototypes
public function boolean wf_goods_chk (long al_goods_amt)
public function boolean wf_style_set (long al_row, string as_style)
public subroutine wf_amt_set (long al_row, long al_sale_qty)
public function boolean uf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name)
private function boolean wf_coupon_chk (long al_goods_amt)
public function boolean wf_member_set (string as_flag, string as_find)
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

event ue_point_update();//string  ls_coupon_no, ls_jumin, ls_sale_fg, ls_card_no, ls_give_date
//long    ll_accept_point 
//decimal ll_goods_amt
//int     li_point_seq 	
//datetime ld_datetime	
//
//
//	// 고객 회수Point  처리 (TB_71011_H) 
//
//		ls_jumin = dw_1.Getitemstring(1,"jumin")
//		ll_goods_amt = dw_1.Getitemdecimal(1, "goods_amt")
//       	
//      ll_accept_point = abs(ll_goods_amt) / 10 
//         
//        IF is_status = "new" THEN 
// 
//           // 회수 point 내역 추가 
//            
//               select isnull(max(point_seq), 0) + 1,    
//                      card_no,   accept_point                                  
//					 into   :li_point_seq,    
//                     :ls_card_no, :ll_accept_point   
//                from tb_71011_h 
//               where jumin      = :ls_jumin 
//                 and give_date  = :is_yymmdd 
//                 and point_flag = '2'  
//					 group by card_no,accept_point;
//					  
//				 insert into dbo.tb_71011_h
//                    (jumin,    give_date,         point_flag,   point_seq, coupon_no,   
//                     card_no,  accept_point,      accept_flag,  accept_ymd,       
//                     Reg_id,   Reg_Dt,            Mod_id,       Mod_Dt)  
//             values (:ls_jumin,    :is_yymmdd,        '2',      :li_point_seq, :ls_coupon_no,   
//                     :ls_card_no,  :ll_accept_point,  'Y',      :is_yymmdd,  
//                     :gs_user_id,  :ld_datetime,     null,      null);
//					  
//           // 발행 PONIT 내역에 회수 마크 처리 
//			  
//			  // 쿠폰번호가 없는 경우 처리 
//			  IF  isnull(ls_coupon_no) or ls_coupon_no = ''    THEN
//					 select top 1 give_date,   point_seq
//						into :ls_give_date, :li_point_seq
//						from dbo.tb_71011_h  
//					  where jumin       = :ls_jumin  
//						 and give_date   > convert(varchar(8), dateadd(yyyy, -1, :is_yymmdd), 112)
//						 and point_flag  = '1'  
//						 and give_point  = :ll_accept_point  
//						 and accept_flag = 'N';  
//					 
//					
//						 update dbo.tb_71011_h 
//							 set accept_flag = 'Y', 
//								  accept_ymd  = :is_yymmdd
//						  where jumin      = :ls_jumin 
//							 and give_date  = :ls_give_date
//							 and point_flag = '1' 
//							 and point_seq  = :li_point_seq;
//			
//			  ELSE	 // 쿠폰번호가 있는 경우 처리 
//					    update dbo.tb_71011_h 
//							 set accept_flag = 'Y', 
//								  accept_ymd  = :is_yymmdd
//						  where jumin      = :ls_jumin 
//							 and point_flag = '1' 
//							 and coupon_no  = :ls_coupon_no
//							 and give_point  = :ll_accept_point; 
//			 END IF
//       
//	   ELSE
//           
//          // 회수 point 내역 삭제 
//             delete from dbo.tb_71011_h 
//              where jumin      = :ls_jumin 
//                and give_date  = :is_yymmdd 
//                and point_flag = '2'
//                and point_seq  = (select max(point_seq) 
//                                    from dbo.tb_71011_h 
//                                   where jumin        = :ls_jumin 
//                                     and give_date    = :is_yymmdd 
//                                     and point_flag   = '2'
//                                     and accept_point = :ll_accept_point); 
//												 
//												 
//			  // 발행 PONIT 내역에  회수처리 취소 
//			  
//			  // 쿠폰번호가 없는 경우 처리 
//			  IF  isnull(ls_coupon_no) or  ls_coupon_no = ''    THEN
//					 select top 1 give_date,  point_seq
//						into :ls_give_date, :li_point_seq
//					 from dbo.tb_71011_h  
//					 where jumin       = :ls_jumin  
//                and accept_ymd  = :is_yymmdd
//                and point_flag  = '1'  
//                and give_point  = :ll_accept_point  
//                and accept_flag = 'Y'  
//              order by give_date desc, point_seq desc; 
//					 
//					
//					 update dbo.tb_71011_h 
//						 set accept_flag = 'N', 
//							  accept_ymd  = NULL
//					  where jumin      = :ls_jumin 
//						 and give_date  = :ls_give_date
//						 and point_flag = '1' 
//						 and point_seq  = :li_point_seq;
//			
//			  ELSE	 // 쿠폰번호가 있는 경우 처리 
//					    update dbo.tb_71011_h 
//							 set accept_flag = 'N', 
//								  accept_ymd  = NULL
//						  where jumin      = :ls_jumin 
//							 and point_flag = '1' 
//							 and coupon_no  = :ls_coupon_no
//							 and give_point  = :ll_accept_point ;
//			 END IF									 
//          
//      END IF                         
//	
//
//
//
//
//	
end event

public function boolean wf_goods_chk (long al_goods_amt);Long 	  ll_accept_point, ll_row, ll_find   

IF isnull(al_goods_amt) OR al_goods_amt = 0 THEN RETURN TRUE 

ll_row = dw_point.RowCount()
IF ll_row < 1 THEN RETURN FALSE

ll_accept_point = al_goods_amt / 10 

ll_find = dw_point.Find("give_point = " + String(ll_accept_point), 1, ll_row) 
IF ll_find > 0 THEN RETURN TRUE 

RETURN FALSE
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

private function boolean wf_coupon_chk (long al_goods_amt);String  ls_user_name,   ls_jumin,      ls_card_no,      ls_age_grp,	ls_coupon_no
String  ls_brand_chk
Long    ll_total_point, ll_give_point, ll_accept_point, ll_year, ll_coupon_cnt 
Boolean lb_return 

ls_coupon_no = dw_1.GetItemString(1,"coupon_no")
ls_jumin = dw_1.GetItemString(1,"jumin")


if gs_brand = 'N' then
	ls_brand_chk = 'C'
else 
	ls_brand_chk = 'D'
end if	

IF  Upper(LeftA(LS_COUPON_NO,1)) = 'C' OR  Upper(LeftA(LS_COUPON_NO,1)) = 'D' THEN 
	IF LeftA(LS_COUPON_NO,1) <> ls_brand_chk THEN 	RETURN FALSE
END IF

IF  Upper(LeftA(LS_COUPON_NO,1)) = 'N' OR  Upper(LeftA(LS_COUPON_NO,1)) = 'O' THEN 
	IF LeftA(LS_COUPON_NO,1) <> LeftA(GS_SHOP_CD,1) THEN 	RETURN FALSE
END IF
// 


	SELECT a.user_name,       a.jumin,          a.card_no,
			 a.total_point,     a.give_point,     a.accept_point 
	  INTO :ls_user_name,   :ls_jumin,      :ls_card_no,  
			 :ll_total_point, :ll_give_point, :ll_accept_point 
	  FROM TB_71010_M  a WITH (NOLOCK)  , TB_71011_H b  WITH (NOLOCK) 
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

select count(jumin) 
into	 :ll_coupon_cnt
from tb_71011_h  with (nolock)   
where jumin = :ls_jumin;

if ll_coupon_cnt > 0 then 
	dw_1.Setitem(1,"text_message", '사용할 쿠폰이 있습니다 !')
else 
	dw_1.Setitem(1,"text_message", '')
end if

dw_1.SetItem(1, "card_no",      RightA(ls_card_no, 9))
dw_1.SetItem(1, "user_name",    ls_user_name)
dw_1.SetItem(1, "jumin",        ls_jumin)
dw_1.Setitem(1, "total_point",  ll_total_point)
dw_1.Setitem(1, "give_point",   ll_give_point)
dw_1.Setitem(1, "accept_point", ll_accept_point)
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
dw_1.SetItem(1, "age_grp", ls_age_grp)
dw_point.Retrieve(ls_jumin)

Return lb_return
end function

public function boolean wf_member_set (string as_flag, string as_find);String  ls_user_name,   ls_jumin,      ls_card_no,      ls_age_grp, ls_tel_no3
Long    ll_total_point, ll_give_point, ll_accept_point, ll_year, ll_coupon_cnt 
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
				gst_cd.Item_where   = " replace(tel_no3,'-','') = replace('" + as_find + "','-','')"
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
			 total_point,     give_point,     accept_point, tel_no3 
	  INTO :ls_user_name,   :ls_jumin,      :ls_card_no,  
			 :ll_total_point, :ll_give_point, :ll_accept_point , :ls_tel_no3
	  FROM TB_71010_M  with (nolock)  
	 WHERE jumin   = :as_find ; 
	
ELSE
	SELECT user_name,       jumin,          card_no,
			 total_point,     give_point,     accept_point , tel_no3
	  INTO :ls_user_name,   :ls_jumin,      :ls_card_no,  
			 :ll_total_point, :ll_give_point, :ll_accept_point ,:ls_tel_no3
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

select count(jumin) 
into	 :ll_coupon_cnt
from tb_71011_h  with (nolock)   
where jumin = :ls_jumin
and   point_flag = '1'
and   accept_flag = 'n';

if ll_coupon_cnt > 0 then 
	dw_1.Setitem(1,"text_message", '사용할 쿠폰이 있습니다 !')
else 
	dw_1.Setitem(1,"text_message", '')
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
dw_point.Retrieve(ls_jumin)

Return lb_return

end function

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_size, ls_shop_type, ls_given_fg, ls_given_ymd
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn  
Long   ll_tag_price 

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
 where brand = :gs_brand 
   and style = :ls_style 
	and chno  = :ls_chno
	and color = :ls_color 
	and size  = :ls_size
	and year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  > CASE WHEN :GS_BRAND = 'N' THEN  '20041'
																									ELSE		'20034' END
	and sojae <> 'C' ;


IF SQLCA.SQLCODE <> 0 THEN 
	Return False 
END IF

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



dw_body.SetItem(al_row, "tag_price", ll_tag_price) 
IF ls_plan_yn = 'Y' THEN 
	dw_body.Setitem(al_row, "shop_type", '3')
ELSE
	dw_body.Setitem(al_row, "shop_type", '1')
END IF

select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
into  :ls_given_fg, :ls_given_ymd
from tb_12020_m with (nolock)
where style = :ls_style;


if ls_given_fg = "Y" then 
	messagebox("품번체크", ls_given_ymd + "일자로 사은품 전환된 제품입니다!")
	return false
end if 	



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

on w_sh101_e_backup.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.dw_point=create dw_point
this.st_2=create st_2
this.dw_list=create dw_list
this.st_1=create st_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_point
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.dw_2
this.Control[iCurrent+8]=this.dw_3
this.Control[iCurrent+9]=this.gb_1
end on

on w_sh101_e_backup.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.dw_point)
destroy(this.st_2)
destroy(this.dw_list)
destroy(this.st_1)
destroy(this.dw_2)
destroy(this.dw_3)
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
dw_point.SetTransObject(SQLCA)

dw_1.insertRow(0)



end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size, ls_shop_type, ls_given_fg, ls_given_ymd
Long       ll_row_cnt 
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
			
			if gs_BRAND <> "O" then
 				gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20041' and sojae <> 'C' "				
	      ELSE
 				gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20034' and sojae <> 'C' "								
         END IF
			
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

is_yymmdd  = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")
is_sale_no = dw_head.GetitemString(1, "sale_no")
is_tel_no3 = dw_head.GetitemString(1, "tel_no3")

Return true 
 
end event

event pfc_postopen();call super::pfc_postopen;gf_user_connect_pgm(gs_user_id,"w_sh101_e","1")
cb_1.TriggerEvent(Clicked!)
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
long     i, ll_row_count, ll_chk, ll_data_cnt
decimal	ldc_dc_rate
datetime ld_datetime 
int     li_point_seq	
String   ls_shop_type, ls_sale_type, ls_style, ls_year, ls_season

IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_1.AcceptText()    <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
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



/* 교환권 판매 처리 및 가능여부 체크 (정상판매단가가  교환권금액 이상 매출만 가능)*/
ll_goods_amt = dw_1.GetitemNumber(1, "goods_amt")
IF isnull(ll_goods_amt) THEN ll_goods_amt = 0 
ls_card_no   = dw_1.GetitemString(1, "card_no")
ls_coupon_no = dw_1.GetitemString(1, "coupon_no") 
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
	ls_style     = dw_body.Getitemstring(i, "style")	
	ls_year     = dw_body.Getitemstring(i, "year")	
	ls_season     = dw_body.Getitemstring(i, "season")		
	
	IF ll_goods_amt > 0 and ll_sale_price > ll_goods_amt and  & 
	   ll_sale_qty  > 0 and LeftA(dw_body.Object.sale_type[i], 2) = '11'  and &
		ls_item  <> 'X' THEN  
      ls_sale_fg = '2' 
		dw_body.Setitem(i, "goods_amt", ll_goods_amt) 
		dw_body.Setitem(i, "coupon_no", ls_coupon_no) 
		ll_goods_amt = 0 
	ELSEIF LenA(Trim(dw_1.Object.jumin[1])) = 13 and LeftA(dw_body.Object.sale_type[i], 1) < '2' THEN  // 정상 적용 
      ls_sale_fg = '1' 
		dw_body.Setitem(i, "goods_amt", 0)
		dw_body.Setitem(i, "coupon_no", '') 
   ELSE
      ls_sale_fg = '0' 
		dw_body.Setitem(i, "goods_amt", 0) 
		dw_body.Setitem(i, "coupon_no", '') 
   END IF		
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

//	if is_yymmdd >= "20030818" and is_yymmdd <= "20030901" then
//		select count(jumin)
//		into :ll_chk
//		from tb_71011_h
//		where give_date >= '20030818'
//		and   substring(coupon_no,1,1) in ('N','O') 
//		and   jumin =  :ls_jumin;
//		
//		if ll_chk <= 0 and ls_shop_type = '3' and ldc_dc_rate = 10 then
//			MessageBox("경고", "쿠폰이 발행되지 않아 기획 10% 할인 할 수 없습니다!") 
//			Return 0 
//		end if	
//	end if

	if gs_brand = "O" and ls_year = "2004" and ls_season = "S" then

		select count(*)
		into :ll_data_cnt
		from
			(SELECT 'OL4SJ801'  AS STYLE
			UNION ALL
			SELECT 'OL4SS801'  AS STYLE
			UNION ALL
			sELECT 'OW4SL207'  AS STYLE
			UNION ALL
			SELECT 'OW4SS207'  AS STYLE
			UNION ALL
			SELECT 'OW4SJ203'  AS STYLE
			UNION ALL
			SELECT 'OW4SS203'  AS STYLE
			UNION ALL
			SELECT 'OW4SS101'  AS STYLE 
			UNION ALL
			SELECT 'OW4SJ202'  AS STYLE 
			UNION ALL
			SELECT 'OW4SS202'  AS STYLE 
			UNION ALL
			SELECT 'OW4SL105'  AS STYLE 
			UNION ALL
			SELECT 'OW4SS105'  AS STYLE) a	
		where a.style = :ls_style ;
		
		if ll_data_cnt < 1 then
			MessageBox("경고", "봄상품은 재출고된 스타일 이외에는 판매등록할 수 없습니다!") 
			Return 0 
		end if	
		
	end if	

	
	if is_yymmdd >= "20030915" and is_yymmdd <= "20030930" then
		
		if  ls_sale_type = "14"  and ldc_dc_rate = 10  and isnull(ls_card_no) = true then
			MessageBox("경고", "마일리지 회원인 경우에만 정상10% 할인 할 수 있습니다!") 
			Return 0 
		end if	
		
//		if  ls_shop_type = "3"  and ldc_dc_rate = 20  and isnull(ls_card_no) = true then
//			MessageBox("경고", "마일리지 회원인 경우에만 기획20% 할인 할 수 있습니다!") 
//			Return 0 
//		end if	
		
	end if
	
NEXT

IF ll_goods_amt > 0 THEN 
	MessageBox("교환권 오류", "교환권 판매할수 있는 품번이 없습니다.")
	RETURN 0 
END IF

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

type cb_close from w_com010_e`cb_close within w_sh101_e_backup
boolean visible = false
integer x = 389
end type

type cb_delete from w_com010_e`cb_delete within w_sh101_e_backup
integer taborder = 70
end type

type cb_insert from w_com010_e`cb_insert within w_sh101_e_backup
boolean visible = false
integer taborder = 60
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh101_e_backup
integer x = 2469
integer width = 384
integer taborder = 110
string text = "일보조회(&Q)"
end type

type cb_update from w_com010_e`cb_update within w_sh101_e_backup
integer taborder = 50
end type

type cb_print from w_com010_e`cb_print within w_sh101_e_backup
boolean visible = false
integer taborder = 80
end type

type cb_preview from w_com010_e`cb_preview within w_sh101_e_backup
boolean visible = false
integer x = 1193
integer y = 48
integer taborder = 90
end type

type gb_button from w_com010_e`gb_button within w_sh101_e_backup
end type

type dw_head from w_com010_e`dw_head within w_sh101_e_backup
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

type ln_1 from w_com010_e`ln_1 within w_sh101_e_backup
integer beginy = 256
integer endy = 256
end type

type ln_2 from w_com010_e`ln_2 within w_sh101_e_backup
integer beginy = 260
integer endy = 260
end type

type dw_body from w_com010_e`dw_body within w_sh101_e_backup
event ue_set_column ( long al_row )
integer x = 9
integer y = 260
integer width = 2880
integer height = 644
string dataobject = "d_sh101_d01"
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

type dw_print from w_com010_e`dw_print within w_sh101_e_backup
end type

type dw_1 from datawindow within w_sh101_e_backup
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

event type long ue_item_changed(long row, dwobject dwo, string data);string ls_coupon_no
decimal ld_goods_amt

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
		ls_coupon_no = dw_1.getitemstring(1,"coupon_no")
		
		IF isnull(ls_coupon_no) or ls_coupon_no = "" then
			IF not wf_goods_chk(Long(Data))  THEN 
				MessageBox("쿠폰 체크", "해당금액 쿠폰 발행내역이 없습니다.")
				this.Reset()
				this.InsertRow(1)		
				Parent.Post Event ue_tot_set()
				RETURN 1
			END IF
		ELSEIF ls_coupon_no <> "" and  Long(data) = 0 then
			RETURN 0
		ELSE
			IF not wf_coupon_chk(Long(Data))  THEN 
				MessageBox("쿠폰 체크", "쿠폰번호 오류이거나 사용된 쿠폰입니다.")
				this.Reset()
				this.InsertRow(1)
				Parent.Post Event ue_tot_set()
				RETURN 1
			END IF
		END IF
	
	CASE "coupon_no" 
		ld_goods_amt = dw_1.getitemdecimal(1,"goods_amt")
	IF ld_goods_amt <> 0 then
		IF not wf_coupon_chk(long(ld_goods_amt))  THEN 
			MessageBox("쿠폰 체크", "쿠폰번호 오류이거나 사용된 쿠폰입니다.")
			this.Reset()
			this.InsertRow(1)
			Parent.Post Event ue_tot_set()
			RETURN 1
		END IF
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

type cb_1 from commandbutton within w_sh101_e_backup
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

type dw_point from datawindow within w_sh101_e_backup
boolean visible = false
integer x = 1723
integer y = 448
integer width = 846
integer height = 328
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh101_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_sh101_e_backup
integer x = 1097
integer y = 168
integer width = 1774
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 2004년 봄(S) 이전 제품의 경우 관리팀에 연락 바랍니다."
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_list from datawindow within w_sh101_e_backup
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

type st_1 from statictext within w_sh101_e_backup
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

type dw_2 from datawindow within w_sh101_e_backup
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

type dw_3 from datawindow within w_sh101_e_backup
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

type gb_1 from groupbox within w_sh101_e_backup
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

