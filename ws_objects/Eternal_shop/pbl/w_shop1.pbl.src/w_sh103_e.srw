$PBExportHeader$w_sh103_e.srw
$PBExportComments$점간 이동 관리
forward
global type w_sh103_e from w_com010_e
end type
type st_1 from statictext within w_sh103_e
end type
type st_2 from statictext within w_sh103_e
end type
type st_3 from statictext within w_sh103_e
end type
type st_4 from statictext within w_sh103_e
end type
type dw_1 from datawindow within w_sh103_e
end type
type st_5 from statictext within w_sh103_e
end type
end forward

global type w_sh103_e from w_com010_e
integer width = 3067
integer height = 2072
long backcolor = 16777215
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
dw_1 dw_1
st_5 st_5
end type
global w_sh103_e w_sh103_e

type variables
String is_yymmdd 
DataWindowChild idw_tran_cust, idw_tran_type

string is_close_ymd_t, is_year_t, is_season_t, is_season_nm_t, is_season_s_t, is_s_gubn_t, is_e_gubn_t, is_p_gubn_t
string is_close_ymd_f, is_year_f, is_season_f, is_season_nm_f, is_season_s_f, is_s_gubn_f, is_e_gubn_f, is_p_gubn_f
end variables

forward prototypes
public subroutine wf_push (string as_shop_cd, string as_yymmdd, string as_to_shop_cd)
public function boolean wf_rt_chk (long al_row)
public function boolean wf_close_check (string as_brand, ref string as_close_ymd_t, ref string as_year_t, ref string as_season_t, ref string as_season_nm_t, ref string as_season_s_t, ref string as_gubn_1_t, ref string as_gubn_2_t, ref string as_gubn_3_t, ref string as_close_ymd_f, ref string as_year_f, ref string as_season_f, ref string as_season_nm_f, ref string as_season_s_f, ref string as_gubn_1_f, ref string as_gubn_2_f, ref string as_gubn_3_f)
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

public subroutine wf_push (string as_shop_cd, string as_yymmdd, string as_to_shop_cd);string ls_shop_nm, ls_title, ls_content, ls_url, ls_to_id

gf_shop_nm(as_shop_cd,'S',ls_shop_nm)

ls_title = MidA(as_yymmdd,1,4) + '/' + MidA(as_yymmdd,5,2) + '/' + MidA(as_yymmdd,7,2) + ' 점간 이동이 등록 되었습니다.'
ls_content = MidA(as_yymmdd,1,4) + '/' + MidA(as_yymmdd,5,2) + '/' + MidA(as_yymmdd,7,2) + ' ' + ls_shop_nm + ' 매장으로 부터 점간 이동이 등록 되었습니다.'
ls_url = 'RTSTORE||'+as_to_shop_cd+'||' 
ls_to_id = as_to_shop_cd

gf_push(ls_title, ls_content, ls_url, ls_to_id)
end subroutine

public function boolean wf_rt_chk (long al_row);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_size, ls_given_fg, ls_given_ymd
String ls_brand, ls_plan_yn  , ls_shop_type, ls_to_shop_cd
Long   ll_move_qty, ll_move_qty_2, ll_move_qty_3


ls_style 		= dw_body.getitemstring(al_row, "style")
ls_color 		= dw_body.getitemstring(al_row, "color")
ls_size  		= dw_body.getitemstring(al_row, "size")
ls_to_shop_cd	= dw_body.getitemstring(al_row, "to_shop_cd")
ll_move_qty_3	= dw_body.getitemNumber(al_row, "move_qty")

	Select isnull(sum(isnull(move_qty,0)),0)
	  into :ll_move_qty
	  from tb_54013_h with (nolock)
	 where datepart(week, yymmdd ) = datepart(week, :is_yymmdd)
		and yymmdd like substring(:is_yymmdd, 1,4) + '%'
	 	and style = :ls_style 
		and color = :ls_color 
		and size  = :ls_size
		and to_shop_cd = :ls_to_shop_cd
		and fr_shop_cd = :gs_shop_cd;

	IF SQLCA.SQLCODE <> 0 THEN 
		Return False 
	END IF

	IF IsNull(ll_move_qty) or ll_move_qty = 0 THEN 
			Return False 
	else		
		
		Select isnull(sum(isnull(move_qty,0)),0)
		into :ll_move_qty_2
		from tb_53020_h with (nolock)
		where datepart(week, fr_ymd ) = datepart(week, :is_yymmdd)
		and fr_ymd like substring(:is_yymmdd, 1,4) + '%'
		and style = :ls_style 
		and color = :ls_color 
		and size  = :ls_size
		and to_shop_cd = :ls_to_shop_cd
		and fr_shop_cd = :gs_shop_cd
		and rt_yn = 'Y'	;
		
		IF SQLCA.SQLCODE <> 0 THEN 
			Return False 
		END IF
		
		if ll_move_qty_2 + ll_move_qty_3 > ll_move_qty then 
			messagebox("경고!", "지시한 수량 이상 등록 할 수 없습니다!")
			Return False 
		end if	
		
	END IF


	Return True

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

//제외된 마장의 마감일자를 변경해줌..
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

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_size, ls_given_fg, ls_given_ymd, ls_style_No, ls_size_end
String ls_brand, ls_plan_yn  , ls_shop_type,ls_work_gubn, ls_date, ls_now_year_season, ls_check_year_season, ls_year_season, ls_shop_type_1, ls_year_season_1
Long   ll_tag_price, ll_ord_qty, ll_ord_qty_chn , ll_sale_price, ll_cnt
decimal    ldc_sale_price, ldc_sale_price_1

dw_head.accepttext()

ls_date = string(dw_head.GetItemDate(1,'yymmdd'))
ls_date = MidA(ls_date,1,4) + MidA(ls_date,6,2) + MidA(ls_date,9,2)

IF LenA(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = MidA(as_style_no,  1, 8)
ls_chno  = MidA(as_style_no,  9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)

//브랜드별 마감일자 펑션 재 처리

//마감하는 년도시즌 가져오는 펑션
if MidA(as_style_no,1,1) = '8' then
	gs_brand = 'G'
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
else
	gs_brand = MidA(as_style_no,1,1)
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

wf_close_check(gs_brand,is_close_ymd_t,is_year_t,is_season_t,is_season_nm_t,is_season_s_t,is_s_gubn_t,is_e_gubn_t,is_p_gubn_t,is_close_ymd_f,is_year_f,is_season_f,is_season_nm_f,is_season_s_f,is_s_gubn_f,is_e_gubn_f,is_p_gubn_f)

if isnull(is_close_ymd_f) then
	is_close_ymd_f = ''
end if

if MidA(gs_shop_cd,3,4) = "1900"  or MidA(gs_shop_cd,2,1) = "X" then 
	Select brand,     tag_price,     plan_yn   
  into :ls_brand, :ll_tag_price, :ls_plan_yn       
	  from vi_12024_1 with (nolock)
	 where brand = :gs_brand 
		and style = :ls_style 
		and chno  = :ls_chno
		and color = :ls_color 
		and size  = :ls_size
		and sojae  <> 'C'  ;
		
elseif gs_shop_div = 'L' then 
	Select brand,     tag_price,     plan_yn   
  into :ls_brand, :ll_tag_price, :ls_plan_yn       
	  from vi_12024_1 with (nolock)
	 where brand = :gs_brand 
		and style = :ls_style 
		and chno  = :ls_chno
		and color = :ls_color 
		and size  = :ls_size
		and sojae  <> 'C' ;		


elseif gs_brand = "N" or gs_brand = "O" or gs_brand = 'I' then
	if ls_date <= is_close_ymd_t then
		//마감일자 전의 판매
		//정상+행사
		if is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'Y' then
			Select brand,     tag_price,     plan_yn   
			  into :ls_brand, :ll_tag_price, :ls_plan_yn     
			  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and (year + season in (	select year + season
														from tb_51036_d a (nolock), tb_51035_h b (nolock)
														where :is_yymmdd between a.frm_ymd and a.to_ymd
														and a.shop_cd = :gs_shoP_cd
														and a.shop_cd = b.shop_cd
														and a.frm_ymd = b.frm_ymd
														and b.cancel <> 'Y'
												union
												select year + season from tb_52011_d (nolock) 
												where brand = left(:gs_shop_cd,1) 
													)
					or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_f + :is_season_s_f 
							 )	 )		
/*
				and style in ( select style 
									from tb_56012_d (nolock) 
									where brand = :gs_brand and shop_cd = :gs_shop_cd and year = :is_year_f and season = :is_season_f and :is_yymmdd between start_ymd and end_ymd )
*/
				and sojae  <> 'C'  ;		
		//정상+행사+기획
		elseif is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'N' then
			Select brand,     tag_price,     plan_yn   
			  into :ls_brand, :ll_tag_price, :ls_plan_yn     
			  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and (year + season in (	select year + season
														from tb_51036_d a (nolock), tb_51035_h b (nolock)
														where :is_yymmdd between a.frm_ymd and a.to_ymd
														and a.shop_cd = :gs_shoP_cd
														and a.shop_cd = b.shop_cd
														and a.frm_ymd = b.frm_ymd
														and b.cancel <> 'Y'
												union
												select year + season from tb_52011_d (nolock) 
												where brand = left(:gs_shop_cd,1) 
													)
					or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_f + :is_season_s_f 
					or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_f + :is_season_s_f and plan_yn = 'Y'  )
							 )	 )		
/*
				and style in ( select style 
									from tb_56012_d (nolock) 
									where brand = :gs_brand and shop_cd = :gs_shop_cd and year = :is_year_f and season = :is_season_f and :is_yymmdd between start_ymd and end_ymd )
*/
				and sojae  <> 'C'  ;	
		end if
	else
		//마감일자 후의 판매
		//정상+행사
		if is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'Y' then
			Select brand,     tag_price,     plan_yn   
			  into :ls_brand, :ll_tag_price, :ls_plan_yn     
			  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and (year + season in (	select year + season
														from tb_51036_d a (nolock), tb_51035_h b (nolock)
														where :is_yymmdd between a.frm_ymd and a.to_ymd
														and a.shop_cd = :gs_shoP_cd
														and a.shop_cd = b.shop_cd
														and a.frm_ymd = b.frm_ymd
														and b.cancel <> 'Y'
												union
												select year + season from tb_52011_d (nolock) 
												where brand = left(:gs_shop_cd,1) 
													)
					or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_t + :is_season_s_t
							 )	 )		
/*
				and style in ( select style 
									from tb_56012_d (nolock) 
									where brand = :gs_brand and shop_cd = :gs_shop_cd and year = :is_year_t and season = :is_season_t and :is_yymmdd between start_ymd and end_ymd )
*/
				and sojae  <> 'C'  ;		
		//정상+행사+기획
		elseif is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'N' then
			Select brand,     tag_price,     plan_yn   
			  into :ls_brand, :ll_tag_price, :ls_plan_yn     
			  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and (year + season in (	select year + season
														from tb_51036_d a (nolock), tb_51035_h b (nolock)
														where :is_yymmdd between a.frm_ymd and a.to_ymd
														and a.shop_cd = :gs_shoP_cd
														and a.shop_cd = b.shop_cd
														and a.frm_ymd = b.frm_ymd
														and b.cancel <> 'Y'
												union
												select year + season from tb_52011_d (nolock) 
												where brand = left(:gs_shop_cd,1) 
													)
					or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > :is_year_t + :is_season_s_t 
					or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = :is_year_t + :is_season_s_t and plan_yn = 'Y'  )
							 )	 )		
/*
				and style in ( select style 
									from tb_56012_d (nolock) 
									where brand = :gs_brand and shop_cd = :gs_shop_cd and year = :is_year_t and season = :is_season_t and :is_yymmdd between start_ymd and end_ymd )
*/
				and sojae  <> 'C'  ;	
		end if
	end if
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
elseif  gs_brand = "O"  then
	if ls_date <= '20150602' then
		Select brand,     tag_price,     plan_yn   
		  into :ls_brand, :ll_tag_price, :ls_plan_yn     
		  from vi_12024_1 with (nolock)
		 where brand = :gs_brand 
			and style = :ls_style 
			and chno  = :ls_chno
			and color = :ls_color 
			and size  = :ls_size
			and (year + season in (	select year + season
													from tb_51036_d a (nolock), tb_51035_h b (nolock)
													where :is_yymmdd between a.frm_ymd and a.to_ymd
													and a.shop_cd = :gs_shoP_cd
													and a.shop_cd = b.shop_cd
													and a.frm_ymd = b.frm_ymd
													and b.cancel <> 'Y'
											union
											select year + season from tb_52011_d (nolock) 
											where brand = left(:gs_shop_cd,1) 
												)
				or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20143'
//				or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20141' and plan_yn = 'Y'  )
						 )	 )		
			and sojae  <> 'C' 
			and isnull(for_lotte,'N') <> case when :gs_shop_div = 'L' then 'N' else 'Y' end;			
	else
		Select brand,     tag_price,     plan_yn   
		  into :ls_brand, :ll_tag_price, :ls_plan_yn     
		  from vi_12024_1 with (nolock)
		 where brand = :gs_brand 
			and style = :ls_style 
			and chno  = :ls_chno
			and color = :ls_color 
			and size  = :ls_size
			and (year + season in (	select year + season
													from tb_51036_d a (nolock), tb_51035_h b (nolock)
													where :is_yymmdd between a.frm_ymd and a.to_ymd
													and a.shop_cd = :gs_shoP_cd
													and a.shop_cd = b.shop_cd
													and a.frm_ymd = b.frm_ymd
													and b.cancel <> 'Y'
											union
											select year + season from tb_52011_d (nolock) 
											where brand = left(:gs_shop_cd,1) 
												)
				or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20144'
//				or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20141' and plan_yn = 'Y'  )
						 )	 )		
			and sojae  <> 'C' 
			and isnull(for_lotte,'N') <> case when :gs_shop_div = 'L' then 'N' else 'Y' end;				
	end if
elseif  gs_brand = "N"  then
	if ls_date <= '20150614' then
		Select brand,     tag_price,     plan_yn   
		  into :ls_brand, :ll_tag_price, :ls_plan_yn     
			  from vi_12024_1 with (nolock)
		 where brand = :gs_brand 
			and style = :ls_style 
			and chno  = :ls_chno
			and color = :ls_color 
			and size  = :ls_size
			and (year + season in (	select year + season
													from tb_51036_d a (nolock), tb_51035_h b (nolock)
													where :is_yymmdd between a.frm_ymd and a.to_ymd
													and a.shop_cd = :gs_shoP_cd
													and a.shop_cd = b.shop_cd
													and a.frm_ymd = b.frm_ymd
													and b.cancel <> 'Y'
											union
											select year + season from tb_52011_d (nolock) 
											where brand = left(:gs_shop_cd,1) 
												)
					or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20145'
					or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20144' and (item = 'U' or item = 'G' or item = 'F'  ))
					or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20144' and plan_yn = 'Y'  )
					 ))								
			and sojae  <> 'C' 
			and isnull(for_lotte,'N') <> case when :gs_shop_div = 'L' then 'N' else 'Y' end;
	else
		Select brand,     tag_price,     plan_yn   
		  into :ls_brand, :ll_tag_price, :ls_plan_yn     
			  from vi_12024_1 with (nolock)
		 where brand = :gs_brand 
			and style = :ls_style 
			and chno  = :ls_chno
			and color = :ls_color 
			and size  = :ls_size
			and (year + season in (	select year + season
													from tb_51036_d a (nolock), tb_51035_h b (nolock)
													where :is_yymmdd between a.frm_ymd and a.to_ymd
													and a.shop_cd = :gs_shoP_cd
													and a.shop_cd = b.shop_cd
													and a.frm_ymd = b.frm_ymd
													and b.cancel <> 'Y'
											union
											select year + season from tb_52011_d (nolock) 
											where brand = left(:gs_shop_cd,1) 
												)
					or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20151'
//					or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20144' and (item = 'U' or item = 'G' or item = 'F'  ))
					or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20151' and plan_yn = 'Y'  )
					 ))								
			and sojae  <> 'C' 
			and isnull(for_lotte,'N') <> case when :gs_shop_div = 'L' then 'N' else 'Y' end;
	end if
elseif  gs_brand = "I"  then
	if gs_user_id = 'IE1912' or gs_user_id = 'IG0017' or gs_user_id = 'IG0019' or gs_user_id = 'IG0681' then
		if ls_date <= '20150419' then
			Select brand,     tag_price,     plan_yn   
			  into :ls_brand, :ll_tag_price, :ls_plan_yn     
				  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and (year + season in (	select year + season
														from tb_51036_d a (nolock), tb_51035_h b (nolock)
														where :is_yymmdd between a.frm_ymd and a.to_ymd
														and a.shop_cd = :gs_shoP_cd
														and a.shop_cd = b.shop_cd
														and a.frm_ymd = b.frm_ymd
														and b.cancel <> 'Y'
												union
												select year + season from tb_52011_d (nolock) 
												where brand = left(:gs_shop_cd,1) 
													)
						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20143'
//						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20134' and plan_yn = 'Y'  )
						 ))								
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <> case when :gs_shop_div = 'L' then 'N' else 'Y' end;		
		else
			Select brand,     tag_price,     plan_yn   
			  into :ls_brand, :ll_tag_price, :ls_plan_yn     
				  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and (year + season in (	select year + season
														from tb_51036_d a (nolock), tb_51035_h b (nolock)
														where :is_yymmdd between a.frm_ymd and a.to_ymd
														and a.shop_cd = :gs_shoP_cd
														and a.shop_cd = b.shop_cd
														and a.frm_ymd = b.frm_ymd
														and b.cancel <> 'Y'
												union
												select year + season from tb_52011_d (nolock) 
												where brand = left(:gs_shop_cd,1) 
													)
						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20144'
//						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20134' and plan_yn = 'Y'  )
						 ))								
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <> case when :gs_shop_div = 'L' then 'N' else 'Y' end;					
		end if


	else
		if ls_date <= '20150412' then
			Select brand,     tag_price,     plan_yn   
			  into :ls_brand, :ll_tag_price, :ls_plan_yn     
				  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and (year + season in (	select year + season
														from tb_51036_d a (nolock), tb_51035_h b (nolock)
														where :is_yymmdd between a.frm_ymd and a.to_ymd
														and a.shop_cd = :gs_shoP_cd
														and a.shop_cd = b.shop_cd
														and a.frm_ymd = b.frm_ymd
														and b.cancel <> 'Y'
												union
												select year + season from tb_52011_d (nolock) 
												where brand = left(:gs_shop_cd,1) 
													)
						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20143'
//						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20134' and plan_yn = 'Y'  )
						 ))								
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <> case when :gs_shop_div = 'L' then 'N' else 'Y' end;		
		else
			Select brand,     tag_price,     plan_yn   
			  into :ls_brand, :ll_tag_price, :ls_plan_yn     
				  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
				and (year + season in (	select year + season
														from tb_51036_d a (nolock), tb_51035_h b (nolock)
														where :is_yymmdd between a.frm_ymd and a.to_ymd
														and a.shop_cd = :gs_shoP_cd
														and a.shop_cd = b.shop_cd
														and a.frm_ymd = b.frm_ymd
														and b.cancel <> 'Y'
												union
												select year + season from tb_52011_d (nolock) 
												where brand = left(:gs_shop_cd,1) 
													)
						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20144'
//						or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '20134' and plan_yn = 'Y'  )
						 ))								
				and sojae  <> 'C' 
				and isnull(for_lotte,'N') <> case when :gs_shop_div = 'L' then 'N' else 'Y' end;					
		end if
	end if
*/

elseif gs_brand = "B" or gs_brand = 'P' or gs_brand = 'K' or  gs_brand = 'U' then	
	Select brand,     tag_price,     plan_yn   
  into :ls_brand, :ll_tag_price, :ls_plan_yn       
	  from vi_12024_1 with (nolock)
	 where brand = :gs_brand 
		and style = :ls_style 
		and chno  = :ls_chno
		and color = :ls_color 
		and size  = :ls_size ;
else
	
 		Select brand,     tag_price,     plan_yn   
		  into :ls_brand, :ll_tag_price, :ls_plan_yn     
			  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style 
				and chno  = :ls_chno
				and color = :ls_color 
				and size  = :ls_size
		      and ( year + season in (	select year + season
												from tb_51036_d a (nolock), tb_51035_h b (nolock)
												where :is_yymmdd between a.frm_ymd and a.to_ymd
												and a.shop_cd = :gs_shoP_cd
												and a.shop_cd = b.shop_cd
												and a.frm_ymd = b.frm_ymd
												and b.cancel <> 'Y'
										union
										select year + season from tb_52011_d (nolock) 
										where brand = left(:gs_shop_cd,1))
						OR ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20084'  ) )
				and sojae <> 'C' ;		
end if


IF SQLCA.SQLCODE <> 0 THEN 
	Return False 
END IF

	Select isnull(OUT_qty,0), isnull(OUT_qty_chn,0), year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) 
	  into :ll_ord_qty, :ll_ord_qty_chn, :ls_check_year_season
	  from tb_12030_s with (nolock)
	 where brand = :gs_brand 
		and style = :ls_style 
		and chno  = :ls_chno
		and color = :ls_color 
		and size  = :ls_size;

	select dbo.SF_CURR_YEAR(getdate()) + convert(char(01),dbo.sf_inter_sort_seq('003', dbo.SF_CURR_season(getdate())))
	  into :ls_now_year_season
	  from dual;		
		
if gs_brand <> 'M' then	
	if ls_check_year_season = ls_now_year_season then
		if ll_ord_qty - ll_ord_qty_chn <= 0  then 
			messagebox("경고!", "국내에 출고 되지 않는 제품입니다!")
			return false
		end if	
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
from tb_56040_m with (nolock)
where style like :ls_style + '%'
and   gubn = 'C';

IF ls_work_gubn = "A"  THEN 
	messagebox("품번검색", ls_given_ymd + "일자로 반품불가로 전환된 제품입니다!")					
	return false 	
END IF 			
	
	ll_cnt = 0
	
			select a.shop_type, case when isnull(a.dc_rate,0) <> 0 then b.tag_price * (100 - a.dc_rate) / 100 else isnull(a.sale_price,0) end,
				    b.year + convert(char(01),dbo.sf_inter_sort_seq('003', b.SEASON)), 1
			into  :ls_shop_type, :ldc_sale_price, :ls_year_season, :ll_cnt
			From tb_56012_d_color a with (nolock), tb_12020_m b (nolock)
			Where a.style    = :ls_style 
			and   a.color    = :ls_color	
			and a.start_ymd <= :is_yymmdd
			and a.end_ymd   >= :is_yymmdd
			and a.shop_cd    = :gs_shop_cd 
			and a.style      = b.style ;
		
		
//		if isnull(ll_cnt) or ll_cnt = 0 then
		if IsNull(ls_shop_type) or Trim(ls_shop_type) = ""  then
			
			Select a.shop_type, case when isnull(a.dc_rate,0) <> 0 then b.tag_price * (100 - a.dc_rate) / 100 else isnull(a.sale_price,0) end,
				    b.year + convert(char(01),dbo.sf_inter_sort_seq('003', b.SEASON)) 					
			into :ls_shop_type, :ldc_sale_price, :ls_year_season
			From tb_56012_d a with (nolock), tb_12020_m b (nolock)
			Where a.style    = :ls_style 
			and a.start_ymd <= :is_yymmdd
			and a.end_ymd   >= :is_yymmdd
			and a.shop_cd    = :gs_shop_cd 
			and a.style      = b.style;
			
		end if
		
//messagebox("sttyle-chk	ls_shop_type", ls_shop_type)


			if gs_brand = "I" and (IsNull(ls_shop_type) or Trim(ls_shop_type) = "") then
				//코인코즈는 품번별 마진 없으면 년도/시즌까지 확인 요청 장나영차장 요청 (20140617).
				Select	a.shop_type, 
							case when isnull(a.dc_rate,0) <> 0 then b.tag_price * (100 - a.dc_rate) / 100 else b.tag_price * (100 - a.dc_rate) / 100 end,
							b.year + convert(char(01),dbo.sf_inter_sort_seq('003', b.SEASON))
				into :ls_shop_type_1, :ldc_sale_price_1, :ls_year_season_1
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
				
	IF ls_shop_type <> "4" and MidA(gs_shop_cd,1,2) = "NI"  THEN 
	//	messagebox("품번검색", "행사매장에서는 행사이외의 점간등록이 불가합니다!")					
		dw_body.SetItem(al_row, "style_no", "")
		return false 
	END IF 				
		
//	IF ls_shop_type = "4" and mid(gs_shop_cd,1,2) = "NG"  THEN 
//	//	messagebox("품번검색", "정상매장에서는 행사품번의 점간등록이 불가합니다!")					
//		dw_body.SetItem(al_row, "style_no", "")
//		return false 
//	END IF 									
				

if ls_shop_type = "4" then
	dw_body.SetItem(al_row, "tag_price", ll_sale_price) 
	dw_body.Setitem(al_row, "fr_shop_type", ls_shop_type)
	dw_body.Setitem(al_row, "to_shop_type", ls_shop_type)	
	ls_style_no = ls_style + ls_chno + ls_color  + ls_size
	ls_size_end = ls_size
else
	
	if IsNull(ll_sale_price) or ll_sale_price  = 0 then
	  	dw_body.SetItem(al_row, "tag_price", ll_tag_price) 		
	else
		if ls_shop_type < "4" then 
 	 		dw_body.SetItem(al_row, "tag_price", ll_tag_price) 		
		else	  
			dw_body.SetItem(al_row, "tag_price", ll_sale_price) 
		end if	
	end if		


	IF ls_plan_yn = 'Y' THEN 
		dw_body.Setitem(al_row, "fr_shop_type", '3')
		dw_body.Setitem(al_row, "to_shop_type", '3')
	ELSE
		dw_body.Setitem(al_row, "fr_shop_type", '1')
		dw_body.Setitem(al_row, "to_shop_type", '1')
	END IF
	ls_style_no = ls_style + ls_chno + ls_color + ls_size
	ls_size_end = ls_size
end if	



dw_body.SetItem(al_row, "style_no", ls_style_no)
dw_body.SetItem(al_row, "style",    ls_style)
dw_body.SetItem(al_row, "chno",     ls_chno)
dw_body.SetItem(al_row, "color",    ls_color)
dw_body.SetItem(al_row, "size",     ls_size_end)
dw_body.SetItem(al_row, "brand",    ls_brand)

Return True

end function

on w_sh103_e.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.dw_1=create dw_1
this.st_5=create st_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.st_5
end on

on w_sh103_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.dw_1)
destroy(this.st_5)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
string   ls_title

IF as_cb_div = '1' THEN
	ls_title = "조회오류"
ELSEIF as_cb_div = '2' THEN
	ls_title = "추가오류"
ELSEIF as_cb_div = '3' THEN
	ls_title = "저장오류"
ELSE
	ls_title = "오류"
END IF

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

if MidA(gs_shop_cd,2,1) = 'H' then
	messagebox("주의!", '닷컴매장에서는 사용할 수 없습니다!')
	return false
end if	

if MidA(gs_shop_cd,2,1) = 'I' then
	messagebox("주의!", '행사전용매장에서는 사용할 수 없습니다!')
	return false
end if	

//if mid(gs_shop_cd,2,1) = 'X' then
if gs_shop_div = 'X' then
	messagebox("주의!", '기타매장에서는 사용할 수 없습니다!')
	return false
end if	


IF dw_head.AcceptText() <> 1 THEN RETURN FALSE



is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
Long ll_row
String ls_tran_cust, ls_tran_type, ls_find
Integer li_box_no
long ll_found

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(gs_shop_cd)
IF il_rows >= 0 THEN
	ll_row = dw_body.insertRow(0)
	
	ls_tran_cust = dw_body.getitemstring(ll_row -1, "tran_cust")
	ls_tran_type = dw_body.getitemstring(ll_row -1, "tran_type")	
	
	if  ls_tran_type = '201' or ls_tran_type = '202' or ls_tran_type = '701' 	or ls_tran_type = '702' or ls_tran_type = '802' or ls_tran_type = '803'  then 	
		li_box_no = dw_body.getitemNumber(ll_row -1, "box_no")	
	else	
		li_box_no = 0
	end if	
	
	dw_body.SetRow(ll_row)
	
	if isnull(ls_tran_cust) or ls_tran_cust = '' then
		ls_tran_cust = 'MXX'
		ls_tran_type = '000'
		li_box_no = 0
	end if
	
	if ls_tran_cust = 'M99' then
		ls_tran_cust = 'MXX'
		ls_tran_type = '000'
		li_box_no = 0
	end if	
	
	dw_body.setitem(ll_row, "tran_cust", ls_tran_cust)
	dw_body.setitem(ll_row, "tran_type", ls_tran_type)
	dw_body.setitem(ll_row, "box_no", li_box_no)	
	
	dw_body.SetColumn("style_no")
   dw_body.SetFocus()
END IF

This.Trigger Event ue_msg(1, il_rows)
This.Trigger Event ue_button(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size, ls_shop_nm, ls_given_fg, ls_given_ymd, ls_shop_type, ls_now_year_season, ls_check_year_season
String  	  ls_style_no, ls_size_end, ls_tran_cust, ls_tran_type, ls_work_gubn, ls_year_season, ls_date, ls_shop_type_1, ls_year_season_1
Long       ll_row_cnt , ll_ord_qty, ll_ord_qty_chn
integer    li_box_no
decimal    ldc_sale_price, ldc_sale_price_1
Boolean    lb_check 
DataStore  lds_Source 

dw_head.accepttext()
ls_date = string(dw_head.GetItemDate(1,'yymmdd'))
ls_date = MidA(ls_date,1,4) + MidA(ls_date,6,2) + MidA(ls_date,9,2)
//브랜드별 마감일자 펑션 재 처리

//마감하는 년도시즌 가져오는 펑션
if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = MidA(as_data,1,1)
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

wf_close_check(gs_brand,is_close_ymd_t,is_year_t,is_season_t,is_season_nm_t,is_season_s_t,is_s_gubn_t,is_e_gubn_t,is_p_gubn_t,is_close_ymd_f,is_year_f,is_season_f,is_season_nm_f,is_season_s_f,is_s_gubn_f,is_e_gubn_f,is_p_gubn_f)

if isnull(is_close_ymd_f) then
	is_close_ymd_f = ''
end if

CHOOSE CASE as_column
	CASE "style_no"		
			IF ai_div = 1 THEN 	
				IF wf_style_chk(al_row, as_data)  THEN
				   ll_row_cnt = dw_body.RowCount()
//				   IF al_row = ll_row_cnt THEN 
//					   ll_row_cnt = dw_body.insertRow(0)
//						ls_tran_cust = dw_body.getitemstring(ll_row_cnt -1, "tran_cust")
//						ls_tran_type = dw_body.getitemstring(ll_row_cnt -1, "tran_type")	
//
//						if  ls_tran_type = '202' or ls_tran_type = '203' or ls_tran_type = '701' 	or ls_tran_type = '702' or ls_tran_type = '801' or ls_tran_type = '802'  then 	
//							li_box_no = dw_body.getitemNumber(ll_row_cnt -1, "box_no")	
//						else	
//							li_box_no = 0
//						end if	
//					
//						dw_body.Setitem(ll_row_cnt, "tran_cust", ls_tran_cust)
//						dw_body.Setitem(ll_row_cnt, "tran_type", ls_tran_type)
//						dw_body.Setitem(ll_row_cnt, "box_no", li_box_no)	
//				   END IF
               dw_body.SetItem(al_row, "move_qty", 1)
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

			if MidA(gs_shop_cd,3,4) = "1900" or MidA(gs_shop_cd,3,4) = "1800" then
		      gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and sojae  <> 'C'   " 	
//			elseif mid(gs_shop_cd,2,1) = "B" then
//			      gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and sojae  <> 'C'   " 									
		   elseif MidA(gs_shop_cd,2,1) = "X" then
			      gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and sojae  <> 'C'   " 					
		   elseif MidA(gs_shop_cd,2,1) = "L" then
			      gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and sojae  <> 'C'   " 					
			else	
				if gs_brand = "N" or gs_brand = "O" then
					if ls_date <= is_close_ymd_t then
						//마감일자 전의 판매
						//정상+행사
						if is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'Y' then
//															"  and style in ( select style from tb_56012_d (nolock) where brand = '"+ gs_brand + "' and shop_cd = '" + gs_shop_cd + "' and year = '"+is_year_f+"' and season = '"+is_season_f+"' and '"+is_yymmdd+"' between start_ymd and end_ymd )" +&
							gst_cd.default_where	=	" WHERE brand = '" + gs_brand + "'  and ( year + season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where  '" + is_yymmdd + "' "  + &
															" between a.frm_ymd and a.to_ymd and a.shop_cd =  '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd  and b.cancel <> 'Y' union select year + season from tb_52011_d (nolock) where brand = left('" + gs_shop_cd + "',1)  ) " + & 
															"  or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_f+is_season_s_f+"' ) ) " +& 
															"  and sojae <> 'C'   "
											 
						//정상+행사+기획
						elseif is_s_gubn_f = 'Y' and is_e_gubn_f = 'Y' and is_p_gubn_f = 'N' then
//															"  and style in ( select style from tb_56012_d (nolock) where brand = '"+ gs_brand + "' and shop_cd = '" + gs_shop_cd + "' and year = '"+is_year_f+"' and season = '"+is_season_f+"' and '"+is_yymmdd+"' between start_ymd and end_ymd )" +&
							gst_cd.default_where	=	" WHERE brand = '" + gs_brand + "'  and ( year + season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where  '" + is_yymmdd + "' "  + &
															" between a.frm_ymd and a.to_ymd and a.shop_cd =  '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd  and b.cancel <> 'Y' union select year + season from tb_52011_d (nolock) where brand = left('" + gs_shop_cd + "',1)  ) " + & 
															"  or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_f+is_season_s_f+"' )  " +& 
															"  or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '"+is_year_f+is_season_s_f+"' and plan_yn = 'Y' ) )" +& 
															"  and sojae <> 'C'   "
						end if
					else
						//마감일자 후의 판매
						//정상+행사
						if is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'Y' then
//															"  and style in ( select style from tb_56012_d (nolock) where brand = '"+ gs_brand + "' and shop_cd = '" + gs_shop_cd + "' and year = '"+is_year_t+"' and season = '"+is_season_t+"' and '"+is_yymmdd+"' between start_ymd and end_ymd )" +&
							gst_cd.default_where	=	" WHERE brand = '" + gs_brand + "'  and ( year + season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where  '" + is_yymmdd + "' "  + &
															" between a.frm_ymd and a.to_ymd and a.shop_cd =  '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd  and b.cancel <> 'Y' union select year + season from tb_52011_d (nolock) where brand = left('" + gs_shop_cd + "',1)  ) " + & 
															"  or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_t+is_season_s_t+"' ) ) " +& 
															"  and sojae <> 'C'  "
						//정상+행사+기획
						elseif is_s_gubn_t = 'Y' and is_e_gubn_t = 'Y' and is_p_gubn_t = 'N' then
//															"  and style in ( select style from tb_56012_d (nolock) where brand = '"+ gs_brand + "' and shop_cd = '" + gs_shop_cd + "' and year = '"+is_year_t+"' and season = '"+is_season_t+"' and '"+is_yymmdd+"' between start_ymd and end_ymd )" +&
							gst_cd.default_where	=	" WHERE brand = '" + gs_brand + "'  and ( year + season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where  '" + is_yymmdd + "' "  + &
															" between a.frm_ymd and a.to_ymd and a.shop_cd =  '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd  and b.cancel <> 'Y' union select year + season from tb_52011_d (nolock) where brand = left('" + gs_shop_cd + "',1)  ) " + & 
															"  or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '"+is_year_t+is_season_s_t+"' )  " +& 
															"  or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) = '"+is_year_t+is_season_s_t+"' and plan_yn = 'Y' ) )" +& 
															"  and sojae <> 'C'   "
						end if
					end if

				elseif gs_brand = "B" or gs_brand = 'P' or gs_brand = 'K' or gs_brand = 'U' then
					gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and isnull(for_lotte,'N') = 'N' " 					
				else 
					gst_cd.default_where   = "WHERE brand = '" + gs_brand + "'  and ( year + season in (select year + season from tb_51036_d a (nolock), tb_51035_h b (nolock) where  '" + is_yymmdd + "' "  + &
										 " between a.frm_ymd and a.to_ymd and a.shop_cd =  '" + gs_shop_cd + "' and a.shop_cd = b.shop_cd and a.frm_ymd = b.frm_ymd  and b.cancel <> 'Y' union select year + season from tb_52011_d (nolock) where brand = left('" + gs_shop_cd + "',1)  ) " + & 
										 "  or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20103'   )  )   "  
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
				
				ls_style =  lds_Source.GetItemString(1,"style")
				
				select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
				into   :ls_given_fg, :ls_given_ymd
				from tb_12020_m with (nolock)
				where style like :ls_style + '%';
				
				IF ls_given_fg = "Y"  THEN 
					messagebox("품번검색", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				END IF 				
				
				
			   select work_gubn, given_ymd
				into :ls_work_gubn, :ls_given_ymd
				from tb_56040_m with (nolock)
				where style like :ls_style + '%'
				and   gubn = 'C';
				
				IF ls_work_gubn = "A"  THEN 
					messagebox("품번검색", ls_given_ymd + "일자로 반품불가로 전환된 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				END IF 						
								
				
				ls_style =  lds_Source.GetItemString(1,"style")
				ls_chno  =  lds_Source.GetItemString(1,"chno")
				ls_color =  lds_Source.GetItemString(1,"color")
				ls_size  =  lds_Source.GetItemString(1,"size")				
				
				Select isnull(OUT_qty,0), isnull(OUT_qty_chn,0), year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) 
				  into :ll_ord_qty, :ll_ord_qty_chn, :ls_check_year_season
				  from tb_12030_s with (nolock)
				 where brand = :gs_brand 
					and style = :ls_style 
					and chno  = :ls_chno
					and color = :ls_color 
					and size  = :ls_size;
					
				select dbo.SF_CURR_YEAR(getdate()) + convert(char(01),dbo.sf_inter_sort_seq('003', dbo.SF_CURR_season(getdate())))
				  into :ls_now_year_season
				  from dual;
				
			if gs_brand <> 'M' then	
				if ls_check_year_season = ls_now_year_season then
					if ll_ord_qty - ll_ord_qty_chn <= 0  then 
						messagebox("경고!", "국내 출고 되지 않는 제품입니다!")
						dw_body.SetItem(al_row, "style_no", "")
						ib_itemchanged = FALSE
						return 1 	
					end if					
				end if
			end if	
				

			Select a.shop_type, case when isnull(a.dc_rate,0) <> 0 then b.tag_price * (100 - a.dc_rate) / 100 else isnull(a.sale_price,0) end,
				    b.year + convert(char(01),dbo.sf_inter_sort_seq('003', b.SEASON)) 					
			into :ls_shop_type, :ldc_sale_price, :ls_year_season
			From tb_56012_d_color a with (nolock), tb_12020_m b (nolock)
			Where a.style    = :ls_style 
			and   a.color    = :ls_color
			and a.start_ymd <= :is_yymmdd
			and a.end_ymd   >= :is_yymmdd
			and a.shop_cd    = :gs_shop_cd 
			and a.style      = b.style;				
				
			if IsNull(ls_shop_type) or Trim(ls_shop_type) = ""	 then
				Select a.shop_type, case when isnull(a.dc_rate,0) <> 0 then b.tag_price * (100 - a.dc_rate) / 100 else isnull(a.sale_price,0) end,
						 b.year + convert(char(01),dbo.sf_inter_sort_seq('003', b.SEASON)) 					
				into :ls_shop_type, :ldc_sale_price, :ls_year_season
				From tb_56012_d a with (nolock), tb_12020_m b (nolock)
				Where a.style    = :ls_style 
				and a.start_ymd <= :is_yymmdd
				and a.end_ymd   >= :is_yymmdd
				and a.shop_cd    = :gs_shop_cd 
				and a.style      = b.style;
			end if	
					
		///	messagebox("uepopup	ls_shop_type", ls_shop_type)
			
			if gs_brand = "J" and (IsNull(ls_shop_type) or Trim(ls_shop_type) = "") then
				//코인코즈는 품번별 마진 없으면 년도/시즌까지 확인 요청 장나영차장 요청 (20140617).
				Select	a.shop_type, 
							case when isnull(a.dc_rate,0) <> 0 then b.tag_price * (100 - a.dc_rate) / 100 else b.tag_price * (100 - a.dc_rate) / 100 end,
							b.year + convert(char(01),dbo.sf_inter_sort_seq('003', b.SEASON))
				into :ls_shop_type_1, :ldc_sale_price_1, :ls_year_season_1
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

					
			IF ls_shop_type <> "4" and MidA(gs_shop_cd,2,1) = "I"  THEN 
				messagebox("품번검색", "행사매장에서는 행사이외의 점간등록이 불가합니다!")					
				dw_body.SetItem(al_row, "style_no", "")
				ib_itemchanged = FALSE
				return 1 	
			END IF 				
				
										
					
				
//			if IsNull(ldc_sale_price) or ldc_sale_price  = 0 then		
			if ls_shop_type <> "4"  then						
				
				if IsNull(ldc_sale_price) or ldc_sale_price  = 0 then
					dw_body.SetItem(al_row, "tag_price", lds_Source.GetItemNumber(1,"tag_price")) 
				else
					if ls_shop_type < "4" then
						dw_body.SetItem(al_row, "tag_price", lds_Source.GetItemNumber(1,"tag_price")) 
					else	
						dw_body.SetItem(al_row, "tag_price", ldc_sale_price) 
					end if	
				end if					
				
				ls_style_no = ls_style + ls_chno + ls_color + ls_size
				ls_size_end = ls_size
				
				IF lds_Source.GetItemString(1,"plan_yn") = 'Y' THEN 
					dw_body.Setitem(al_row, "fr_shop_type", '3')
					dw_body.Setitem(al_row, "to_shop_type", '3')
				ELSE
					dw_body.Setitem(al_row, "fr_shop_type", '1')
					dw_body.Setitem(al_row, "to_shop_type", '1')
				END IF
			else
				
				if isnull(ldc_sale_price) or ldc_sale_price = 0 then
					ldc_sale_price = ldc_sale_price_1
				end if
				
				dw_body.SetItem(al_row, "tag_price", ldc_sale_price) 
				dw_body.Setitem(al_row, "fr_shop_type", ls_shop_type)
				dw_body.Setitem(al_row, "to_shop_type", ls_shop_type)
				ls_style_no = ls_style + ls_chno + ls_color + ls_size
				ls_size_end = ls_size	
			end if	 				
			

			   dw_body.SetItem(al_row, "style_no", ls_style_no) // lds_Source.GetItemString(1,"style_no"))
			   dw_body.SetItem(al_row, "style",    lds_Source.GetItemString(1,"style"))
			   dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno"))
			   dw_body.SetItem(al_row, "color",    lds_Source.GetItemString(1,"color"))
			   dw_body.SetItem(al_row, "size",     ls_size_end) //lds_Source.GetItemString(1,"size"))
			   dw_body.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand"))
			   dw_body.SetItem(al_row, "move_qty", 1)
			   ib_changed = true
            cb_update.enabled = true
			   /* 다음컬럼으로 이동 */
//			   ll_row_cnt = dw_body.RowCount()
//			   IF al_row = ll_row_cnt THEN 
//				   ll_row_cnt = dw_body.insertRow(0)
//					ls_tran_cust = dw_body.getitemstring(ll_row_cnt -1, "tran_cust")
//					ls_tran_type = dw_body.getitemstring(ll_row_cnt -1, "tran_type")	
//
//					if  ls_tran_type = '202' or ls_tran_type = '203' or ls_tran_type = '701' 	or ls_tran_type = '702' or ls_tran_type = '801' or ls_tran_type = '802'  then 	
//						li_box_no = dw_body.getitemNumber(ll_row_cnt -1, "box_no")	
//					else	
//						li_box_no = 0
//					end if	
//				
//					dw_body.Setitem(ll_row_cnt, "tran_cust", ls_tran_cust)
//					dw_body.Setitem(ll_row_cnt, "tran_type", ls_tran_type)
//					dw_body.Setitem(ll_row_cnt, "box_no", li_box_no)	
//
//			   END IF
			   dw_body.SetColumn("to_shop_cd")
		      lb_check = TRUE 
				ib_itemchanged = FALSE
			END IF
			Destroy  lds_Source
			
			
	CASE "to_shop_cd"	
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
					if gs_shop_div = "L" and MidA(as_data,2,1) <> gs_shop_div  then
					elseif (MidA(as_data,1,1) <> "O" and MidA(as_data,2,1) = "E") or MidA(as_data,2,1) = "D" then
					elseif MidA(as_data,2,1) = "X" or gs_shop_div = "X" then					
					else 	 
						if MidA(as_data,1,1) = gs_brand and MidA(as_data,2,1) <> 'H' then																		
							dw_body.SetItem(al_row, "shop_nm", ls_shop_nm)						
							ll_row_cnt = dw_body.RowCount()
							IF al_row = ll_row_cnt THEN 
								ll_row_cnt = dw_body.insertRow(0)
								ls_tran_cust = dw_body.getitemstring(al_row -1, "tran_cust")
								ls_tran_type = dw_body.getitemstring(al_row -1, "tran_type")	
				
								if  ls_tran_type = '201' or ls_tran_type = '202' or ls_tran_type = '701' 	or ls_tran_type = '702' or ls_tran_type = '802' or ls_tran_type = '803' or ls_tran_type = 'A01' then 	
									li_box_no = dw_body.getitemNumber(al_row -1, "box_no")	
								else	
									li_box_no = 0
								end if	

								if isnull(ls_tran_cust) or ls_tran_cust = '' then
									ls_tran_cust = 'MXX'
									ls_tran_type = '000'
									li_box_no = 0
								end if								
								
								dw_body.Setitem(al_row, "tran_cust", ls_tran_cust)
								dw_body.Setitem(al_row, "tran_type", ls_tran_type)
								dw_body.Setitem(al_row, "box_no", li_box_no)	
				
							END IF										
							
							
							dw_body.SetRow(al_row + 1)
							dw_body.SetColumn("style_no")
							RETURN 0						
						end if	
					end if	
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			if gs_shop_div = "L" then
				gst_cd.default_where   = "WHERE Shop_Stat = '00' and shop_div = 'L' " + & 
												 "  AND BRAND     = '" + gs_brand + "'" + & 
												 "  AND shop_cd   not in ( '" + gs_shop_cd + "','OB1802','nb1802','bb1802','Pb1802','IK1301','IE1913','IE1912','ND1900','OD1900' ) "
			elseif gs_shop_div = "I" then
				gst_cd.default_where   = "WHERE Shop_Stat = '00' and shop_div = 'I' " + & 
												 "  AND BRAND     = '" + gs_brand + "'" + & 
												 "  AND shop_cd   not in ( '" + gs_shop_cd + "','OB1802','nb1802','bb1802','Pb1802','IK1301','IE1913','IE1912','ND1900','OD1900' ) "
											 
			else							
				gst_cd.default_where   = "WHERE Shop_Stat = '00' and shop_div in ('G','K','D','B') " + & 
												 "  AND BRAND     = '" + gs_brand + "'" + & 
												 "  AND shop_cd   not in ( '" + gs_shop_cd + "','OB1802','nb1802','bb1802','Pb1802','IK1301', 'IE1913','IE1912','ND1900','OD1900' ) "
			end if												 
//, '"+gs_brand+"+'D1900'												 
			IF Trim(as_data) <> "" THEN 
            IF Match(as_data, "^[A-Za-z0-9]") THEN
               gst_cd.Item_where = "SHOP_CD  LIKE '" + as_data + "%'"
            ELSE
               gst_cd.Item_where = "SHOP_SNM LIKE '%" + as_data + "%'"
            END IF
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
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "to_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_body.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */ 
			
				
			   ll_row_cnt = dw_body.RowCount()
			   IF al_row = ll_row_cnt THEN 
				   ll_row_cnt = dw_body.insertRow(0)
					ls_tran_cust = dw_body.getitemstring(al_row -1, "tran_cust")
					ls_tran_type = dw_body.getitemstring(al_row -1, "tran_type")	

					if  ls_tran_type = '201' or ls_tran_type = '202' or ls_tran_type = '701' 	or ls_tran_type = '702' or ls_tran_type = '802' or ls_tran_type = '803'  then 	
						li_box_no = dw_body.getitemNumber(al_row -1, "box_no")	
					else	
						li_box_no = 0
					end if	
				
					if isnull(ls_tran_cust) or ls_tran_cust = '' then
						ls_tran_cust = 'MXX'
						ls_tran_type = '000'
						li_box_no = 0
					end if				
				
					dw_body.Setitem(al_row, "tran_cust", ls_tran_cust)
					dw_body.Setitem(al_row, "tran_type", ls_tran_type)
					dw_body.Setitem(al_row, "box_no", li_box_no)	

			   END IF		
				
				dw_body.SetRow(al_row + 1)
				dw_body.SetColumn("style_no")
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

event pfc_postopen();call super::pfc_postopen;//This.Trigger Event ue_Retrieve()
string ls_date

ls_date = string(dw_head.GetItemDate(1,'yymmdd'))
ls_date = MidA(ls_date,1,4) + MidA(ls_date,6,2) + MidA(ls_date,9,2)

IF gs_brand = 'I' and ls_date >= '20151228' then
	cb_update.enabled = false
	dw_body.enabled = false
	cb_retrieve.enabled = false
	st_5.text = '코인코즈는 금일 이후로는 점간이송이 정지 되었습니다!'
	st_2.text = '자세한 문의는 영업관리팀에 문의 바랍니다.'
	st_4.text = ''
else
	if MidA(gs_shop_cd_1,1,2) = 'XX' then 
		gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
	end if	
	
	This.Trigger Event ue_Retrieve()
end if

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_move_qty , ll_data_cnt
integer li_cnt, li_box_no
datetime ld_datetime
String   ls_ymd,   ls_rtn_no, ls_no,    ls_to_shop_cd, ls_shop_type , ls_year, ls_season, ls_yymmdd
String   ls_style, ls_chno,   ls_color, ls_size,       ls_Err_msg , ls_rt_yn, ls_tran_cust, ls_tran_type

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ll_row_count = dw_body.RowCount()
FOR i=1 TO ll_row_count
   ll_move_qty   = dw_body.GetitemNumber(i, "move_qty")
	ls_shop_type  = dw_body.GetitemString(i, "fr_shop_type")
   ls_style		  = dw_body.GetitemString(i, "style")	
	ls_to_shop_cd = dw_body.GetitemString(i, "to_shop_cd")
	ls_yymmdd     = dw_body.GetitemString(i, "fr_ymd")
	
idw_status = dw_body.GetItemStatus(i, 0, Primary!)
IF idw_status = NewModified! THEN		   /* New Record */	
	
	if ls_shop_type = "4" then
			if MidA(gs_shop_cd,3,4) = "1900" or MidA(gs_shop_cd,3,4) = "1906" or MidA(gs_shop_cd,3,4) = "1907" then 
					Select count(*)
					into :li_cnt   
				  from vi_12024_1 with (nolock)
				 where brand = :gs_brand 
					and style = :ls_style 
//					and sojae  <> 'C'   ;
					and sojae <> case when brand <> 'B'  and brand <> 'P' and brand <> 'K' and brand <> 'U'   then 'C' else '' end;	
			ELSE	
				Select count(*)
					into :li_cnt
				  from vi_12024_1 with (nolock)
				 where brand = :gs_brand 
					and style = :ls_style 
					and plan_yn <> 'Y'					
					and size  <>  case when  substring(:gs_shop_cd,3,6) = "2000" then 'CC' else 'XX' end
					and year + season in (	select year + season
													from tb_51036_d a (nolock), tb_51035_h b (nolock)
													where :is_yymmdd between a.frm_ymd and a.to_ymd
													and a.shop_cd = :gs_shoP_cd
													and a.shop_cd = b.shop_cd
													and a.frm_ymd = b.frm_ymd
													and b.cancel <> 'Y' 
													union 
													select year + season from tb_52011_d (nolock) 
													where brand = left(:gs_shop_cd,1) )
//					and sojae  <> 'C' ;		
					and sojae <> case when brand <> 'B'  and brand <> 'P' and brand <> 'K' and  brand = 'U'  then 'C' else '' end;	
			END IF		
	else
		
		if MidA(gs_shop_cd,3,4) = "1900" or MidA(gs_shop_cd,3,4) = "1906" or MidA(gs_shop_cd,3,4) = "1907" then 
				Select count(*)
				into :li_cnt   
			  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style 
				and sojae  <> 'C'   ;
				
		elseif gs_brand = "N" then
			
			Select count(*)
				into :li_cnt 
			  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style 
				and ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20094' 
					  or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= '20094'  and plan_yn = 'Y' ))
				and sojae  <> 'C' ;
		
		
		elseif gs_brand = "O" then
		
			  Select count(*)
				into :li_cnt  
			  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style
				and ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20094' 
					  or ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) >= '20094'  and plan_yn = 'Y' ))
				and sojae  <> 'C' ;	
			
		else 	
			Select count(*)
				into :li_cnt
			  from vi_12024_1 with (nolock)
			 where brand = :gs_brand 
				and style = :ls_style 			
				and ( year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20094' 
						 OR STYLE IN  ('WW7WE605','WW7WE608','WW7WE609') )
//				and sojae  <> 'C'
				and sojae <> case when brand <> 'B'  and brand <> 'P' and brand <> 'K' and brand <> 'U'  then 'C' else '' end;	
		end if
	end if	
	
	
	if li_cnt <= 0 and isnull(ls_style) = false then
			messagebox("경고!" , "제품 시즌이 마감된 제품입니다!")
 	      dw_body.SetRow(i)  
			dw_body.SetColumn("style_no")
   		return -1
	end if		
	
end if	
	
	if ll_move_qty < 0 then
			messagebox("경고!" , "점간이송은 - 로 등록할 수 없습니다!")
   		return -1
	end if		
	

IF ls_rt_yn = "Y" then
	if wf_rt_chk(i)  = false then
		messagebox("경고!", "해당 품번이 금주 RT대상이 아니거나 수량이 다릅니다! 품번과 상대매장, 수량을 확인하세요!")				
		return -1
	end if	
END IF	


//IF mid(ls_to_shop_cd,3,4) = "1802" then
//		messagebox("경고!", "대상매장이 점간이송불가 매장입니다!")				
//		return -1
//END IF	
	
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


//   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN		   /* New Record */
	   /* 전표 번호 채번 */
	   gf_style_outno (is_yymmdd, gs_brand, ls_rtn_no)
      dw_body.Setitem(i, "fr_ymd",     is_yymmdd)
      dw_body.Setitem(i, "fr_shop_cd", gs_shop_cd)
      dw_body.Setitem(i, "fr_rtn_no",  ls_rtn_no)
      dw_body.Setitem(i, "fr_no",      '0001')
      dw_body.Setitem(i, "proc_yn",    'N')
      dw_body.Setitem(i, "reg_id",     gs_user_id)
      dw_body.Setitem(i, "reg_dt",     ld_datetime)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = 1
FOR i=1 TO ll_row_count
   idw_status   = dw_body.GetItemStatus(i, 0, Primary!)
   ll_move_qty   = dw_body.GetitemNumber(i, "move_qty")
   ls_ymd        = dw_body.GetitemString(i, "fr_ymd")
   ls_shop_type  = dw_body.GetitemString(i, "fr_shop_type")
   ls_rtn_no     = dw_body.GetitemString(i, "fr_rtn_no")
   ls_no         = dw_body.GetitemString(i, "fr_no")
   ls_style      = dw_body.GetitemString(i, "style")
   ls_chno       = dw_body.GetitemString(i, "chno")
   ls_color      = dw_body.GetitemString(i, "color")
   ls_size       = dw_body.GetitemString(i, "size")
   ls_to_shop_cd = dw_body.GetitemString(i, "to_shop_cd")
	ls_rt_yn      = dw_body.GetitemString(i, "rt_yn") 
	ls_tran_cust  = dw_body.GetitemString(i, "tran_cust") 
	ls_tran_type  = dw_body.GetitemString(i, "tran_type") 	
	li_box_no     = dw_body.GetitemNumber(i, "box_no") 	
	
	if ll_move_qty < 0 then
			messagebox("경고!" , "점간이송은 - 로 등록할 수 없습니다!")

   		return -1
	end if		
	
	if ls_to_shop_cd = gs_shop_cd then
			messagebox("경고!" , "같은 매장은 등록할 수 없습니다!")
   		return -1
	end if		
	
	if MidA(ls_to_shop_cd,2,1) <> MidA(gs_shop_cd,2,1)  and  MidA(gs_shop_cd,2,1) = "L"  then
			messagebox("경고!" , "전용상품은 전용매장으로만 등록할 수 있습니다!")
   		return -1
	end if		
	
	if MidA(ls_to_shop_cd,2,1) = "Z"  then
			messagebox("경고!" , "오픈매장으로는 점간 처리할 수 없습니다!")
   		return -1
	end if			
	
//	if mid(ls_to_shop_cd,2,1) = "X"  then
//			messagebox("경고!" , "기타매장으로는 점간 처리할 수 없습니다!")
//   		return -1
//	end if				
	
	if MidA(ls_to_shop_cd,2,1) = "T"  then
			messagebox("경고!" , "사입매장으로는 점간 처리할 수 없습니다!")
   		return -1
	end if			
	
	
	IF MidA(ls_to_shop_cd,3,4) = "1802" and ls_ymd = is_yymmdd then
		messagebox("경고!", "곤지암매장은 점간이송불가 매장입니다!")				
		return -1
	END IF	
	
	
//	'201','202','701','702','802','803'
	
	IF isnull(ls_style)      OR Trim(ls_style) = "" OR & 
	   isnull(ls_to_shop_cd) OR Trim(ls_to_shop_cd) = "" THEN 
		CONTINUE
	END IF 
	
	if ls_ymd = is_yymmdd then
		if ll_move_qty > 0 and isnull(ll_move_qty) = false  then
			if  isnull(ls_tran_cust) = true or LenA(ls_tran_cust) = 0 then 	
					messagebox("경고!" , "이송업체 없이 등록할 수 없습니다!")
					return -1
			end if			
			
  		
			if  (ls_tran_type = '201' or ls_tran_type = '202' or ls_tran_type = '701' 	or ls_tran_type = '702' or ls_tran_type = '802' or ls_tran_type = '803') and li_box_no = 0  then 	
					messagebox("경고!" , "박스번호없이 등록할 수 없습니다!")
					return -1
			end if			
		end if
	end if
	
   IF idw_status = NewModified! THEN		   /* New Record */
	     IF ll_move_qty <> 0 THEN 
         DECLARE SP_SH103_INSERT_new PROCEDURE FOR SP_SH103_INSERT_new
                 @yymmdd     = :ls_ymd       , 
                 @shop_cd    = :gs_shop_cd   , 
                 @shop_type  = :ls_shop_type , 
                 @out_no     = :ls_rtn_no    , 
                 @no         = :ls_no        ,
                 @style      = :ls_style     , 
                 @chno       = :ls_chno      , 
                 @color      = :ls_color     , 
                 @size       = :ls_size      , 
                 @qty        = :ll_move_qty  , 
                 @to_shop_cd = :ls_to_shop_cd   , 
					  @rt_yn      = :ls_rt_yn,
                 @reg_id     = :gs_user_id   ,        
                 @reg_dt     = :ld_datetime,
					  @tran_cust  = :ls_tran_cust,
					  @tran_type  = :ls_tran_type,
					  @box_no     = :li_box_no ;
       		  EXECUTE SP_SH103_INSERT_new ; 
					//wf_push(gs_shop_cd, is_yymmdd, ls_to_shop_cd)			//푸쉬넣기
				IF SQLCA.SQLCODE < 0 THEN 
					il_rows = - 1
					ls_Err_msg = SQLCA.SQLERRTEXT
					EXIT
				END IF
			END IF 
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      IF isnull(ll_move_qty) OR ll_move_qty = 0 THEN
         DECLARE SP_SH103_DELETE_new PROCEDURE FOR SP_SH103_DELETE_new  
                 @yymmdd     = :ls_ymd       , 
                 @shop_cd    = :gs_shop_cd   , 
                 @shop_type  = :ls_shop_type , 
                 @out_no     = :ls_rtn_no    , 
                 @no         = :ls_no        ; 
         EXECUTE SP_SH103_DELETE_new ;
			IF SQLCA.SQLCODE < 0 THEN 
				il_rows = - 1
				ls_Err_msg = SQLCA.SQLERRTEXT
				EXIT
			END IF
		ELSE
         DECLARE SP_SH103_UPDATE_new PROCEDURE FOR SP_SH103_UPDATE_new
                 @yymmdd     = :ls_ymd       , 
                 @shop_cd    = :gs_shop_cd   , 
                 @shop_type  = :ls_shop_type , 
                 @out_no     = :ls_rtn_no    , 
                 @no         = :ls_no        ,
                 @style      = :ls_style     , 
                 @chno       = :ls_chno      , 
                 @color      = :ls_color     , 
                 @size       = :ls_size      , 
                 @qty        = :ll_move_qty  , 
                 @to_shop_cd = :ls_to_shop_cd   , 
  					  @rt_yn      = :ls_rt_yn,
                 @mod_id     = :gs_user_id   ,        
                 @mod_dt     = :ld_datetime  ,
					  @tran_cust  = :ls_tran_cust,
					  @tran_type  = :ls_tran_type,
					  @box_no     = :li_box_no ;
         EXECUTE SP_SH103_UPDATE_new ;
				//wf_push(gs_shop_cd, is_yymmdd, ls_to_shop_cd)			//푸쉬넣기
			IF SQLCA.SQLCODE < 0 THEN 
				il_rows = - 1
				ls_Err_msg = SQLCA.SQLERRTEXT
				EXIT
			END IF
		END IF
	END IF 
NEXT



if il_rows = 1 then
   commit  USING SQLCA;
   dw_body.ResetUpdate()
	st_1.Text = ""
	This.Post Event ue_retrieve()
else
   rollback  USING SQLCA;
	MessageBox("SQL오류", ls_Err_msg)
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_1, "ScaleToRight")
dw_1.SetTransObject(SQLCA)

end event

event open;call super::open;string ls_date

ls_date = string(dw_head.GetItemDate(1,'yymmdd'))
ls_date = MidA(ls_date,1,4) + MidA(ls_date,6,2) + MidA(ls_date,9,2)

//마감하는 년도시즌 가져오는 펑션

wf_close_check(gs_brand,is_close_ymd_t,is_year_t,is_season_t,is_season_nm_t,is_season_s_t,is_s_gubn_t,is_e_gubn_t,is_p_gubn_t,is_close_ymd_f,is_year_f,is_season_f,is_season_nm_f,is_season_s_f,is_s_gubn_f,is_e_gubn_f,is_p_gubn_f)

if isnull(is_close_ymd_f) then
	is_close_ymd_f = ''
end if

if gs_brand = 'N' or gs_brand = 'O' or gs_brand = 'I' then
	if ls_date >= is_close_ymd_t then
		ST_2.TEXT = "※ " + is_year_t + "년 " + is_season_nm_t + " 이전 제품은 관리팀에 문의 바랍니다!" + is_close_ymd_t
	else
		ST_2.TEXT = "※ " + is_year_f + "년 " + is_season_nm_f + " 이전 제품은 관리팀에 문의 바랍니다!" + is_close_ymd_f	
	end if
end if

/*
IF GS_BRAND = 'N' THEN
	ST_2.TEXT = "※ 2007년 봄(S) 이전 제품은 관리팀에 문의 바랍니다! "
ELSE	
	ST_2.TEXT = "※ 2006년 겨울(W) 이전 제품은 관리팀에 문의 바랍니다! "
END IF	
*/

end event

event ue_preview();Long i, row_cnt

row_cnt = dw_body.RowCount()
For i = row_cnt To 1 Step -1
	If dw_body.GetItemString(i, 'prt_yn') = 'Y' Then
		dw_body.Rowscopy(i, i, Primary!, dw_1, 1, Primary!)
		dw_1.SetItem(1, 'prt_yn', 'N')
	End If
Next

This.Trigger Event ue_title ()



dw_1.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_shop_nm.Text = '" + gs_shop_nm + "'" + &
             "t_shop_cd.Text = '" + gs_shop_cd + "'" + &
				 "t_shop_nm1.Text = '" + gs_shop_nm + "'" + &
             "t_shop_cd1.Text = '" + gs_shop_cd + "'" 

dw_print.Modify(ls_modify)


end event

event ue_insert();string ls_tran_cust, ls_tran_type
integer li_box_no

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	ls_tran_cust = dw_body.getitemstring(il_rows -1, "tran_cust")
	ls_tran_type = dw_body.getitemstring(il_rows -1, "tran_type")	

	if  ls_tran_type = '201' or ls_tran_type = '202' or ls_tran_type = '701' 	or ls_tran_type = '702' or ls_tran_type = '802' or ls_tran_type = '803' or ls_tran_type = 'A01' then 	
		li_box_no = dw_body.getitemNumber(il_rows -1, "box_no")	
	else	
		li_box_no = 0
	end if	

	if isnull(ls_tran_cust) or ls_tran_cust = '' then
		ls_tran_cust = 'MXX'
		ls_tran_type = '000'
		li_box_no = 0
	end if

	if ls_tran_cust = 'M99' then
		ls_tran_cust = 'MXX'
		ls_tran_type = '000'
		li_box_no = 0
	end if
	
	dw_body.Setitem(il_rows, "tran_cust", ls_tran_cust)
	dw_body.Setitem(il_rows, "tran_type", ls_tran_type)
	dw_body.Setitem(il_rows, "box_no", li_box_no)	
	
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = true
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
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
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = true
				dw_body.Enabled = true
			end if
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
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

type cb_close from w_com010_e`cb_close within w_sh103_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh103_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh103_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh103_e
end type

type cb_update from w_com010_e`cb_update within w_sh103_e
end type

type cb_print from w_com010_e`cb_print within w_sh103_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh103_e
integer width = 352
string text = "전표출력(&V)"
end type

type gb_button from w_com010_e`gb_button within w_sh103_e
integer height = 160
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh103_e
integer x = 14
integer y = 164
integer width = 1010
integer height = 196
string dataobject = "d_sh103_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.object.brand_t.visible = true
	dw_head.object.brand.visible = true
else
	dw_head.object.brand_t.visible = false
	dw_head.object.brand.visible = false
end if


end event

event dw_head::itemchanged;call super::itemchanged;long ll_b_cnt
CHOOSE CASE dwo.name

	CASE "brand"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			dw_head.accepttext()
			gs_brand = dw_head.getitemstring(1,'brand')

			select isnull(count(brand),0)
			into	:ll_b_cnt
			from tb_91100_m  with (nolock) 
			where shop_cd like '%' + substring(:gs_shop_cd_1,3,4)
					and brand = :gs_brand;	
					
			if ll_b_cnt = 0 then 
				messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
				dw_body.reset()
				return 0
			end if

			gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
			Trigger Event ue_retrieve()
	
END CHOOSE
		
end event

type ln_1 from w_com010_e`ln_1 within w_sh103_e
integer beginy = 368
integer endy = 368
end type

type ln_2 from w_com010_e`ln_2 within w_sh103_e
integer beginy = 372
integer endy = 372
end type

type dw_body from w_com010_e`dw_body within w_sh103_e
event ue_set_column ( long al_row )
integer y = 384
integer width = 2981
integer height = 1444
string dataobject = "d_sh103_d01"
boolean hscrollbar = true
end type

event dw_body::ue_set_column(long al_row);/* 품번 키보드 및 스캐너 입력시 다음 line으로 이동 */

dw_body.SetRow(al_row + 1)  
dw_body.SetColumn("style_no")

end event

event dw_body::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
Long ll_ret 
st_1.Text = "반드시 저장버튼을 누르세요 ! "

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false

CHOOSE CASE dwo.name
	CASE "style_no"
		IF gs_brand <> MidA(data,1,1) then
			messagebox('확인', '브랜드가 다릅니다. 브랜드를 다시 선택해 주세요!')
			return 0
		end if
		
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "to_shop_cd"
		IF ib_itemchanged THEN RETURN 1
		ll_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		IF ll_ret <> 1 THEN
			This.Post Event ue_set_column(row) 
		END IF
		return ll_ret
	CASE "rt_yn"
		IF ib_itemchanged THEN RETURN 1
		if data = "Y" then
			IF wf_rt_chk(row) = false and is_yymmdd >= "20090106" then
				this.Setitem(row,"rt_yn","N")		
				messagebox("경고!", "해당 품번이 금주 RT대상이 아니거나 수량이 다릅니다! 품번과 상대매장, 수량을 확인하세요!")				
				dw_body.SetColumn("style_no")				
				return 0
			END IF
		end if				
	CASE "tran_cust" 
		This.SetItem(1, "tran_type", "")
		
		
		
CASE "prt_yn"
	ib_changed = false
	cb_update.enabled = false
	cb_print.enabled = true
	cb_preview.enabled = true
		
	

END CHOOSE

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

event dw_body::itemfocuschanged;call super::itemfocuschanged;
DataWindowChild ldw_child
String ls_tran_cust,ls_filter_str


CHOOSE CASE dwo.name
	CASE "tran_type"
		ls_tran_cust = This.GetItemString(row, "tran_cust")
		idw_tran_type.Retrieve('406', ls_tran_cust)
		
		ls_filter_str = "inter_cd in ('M02','M07','M08', 'M10') " 
		idw_tran_cust.SetFilter(ls_filter_str)
		idw_tran_cust.Filter( )
//		idw_tran_type.InsertRow(1)
//		idw_tran_type.SetItem(1, "inter_cd", '')
//		idw_tran_type.SetItem(1, "inter_nm", '')
//	

	
END CHOOSE

end event

event dw_body::buttonclicked;call super::buttonclicked;Long i
String ls_yn

If dwo.Name = 'cb_prt' Then
	If dwo.Text = '선택' Then
		ls_yn = 'Y'
		dwo.Text = '제외'
	Else
		ls_yn = 'N'
		dwo.Text = '선택'
	End If
	
	For i = 1 To This.RowCount()
		This.SetItem(i, "prt_yn", ls_yn)		
	Next	
End If

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child
string ls_filter_str

This.GetChild("tran_cust", idw_tran_cust)
idw_tran_cust.SetTransObject(SQLCA)
idw_tran_cust.Retrieve('404')

ls_filter_str = "inter_cd in ('M02','M07','M08', 'M10') " 
idw_tran_cust.SetFilter(ls_filter_str)
idw_tran_cust.Filter( )

idw_tran_cust.InsertRow(1)
idw_tran_cust.SetItem(1, "inter_cd", '')
idw_tran_cust.SetItem(1, "inter_nm", '')


This.GetChild("tran_type", idw_tran_type)
idw_tran_type.SetTransObject(SQLCA)
idw_tran_type.Retrieve('406','%')
idw_tran_type.InsertRow(1)
idw_tran_type.SetItem(1, "inter_cd", '')
idw_tran_type.SetItem(1, "inter_nm", '')




end event

type dw_print from w_com010_e`dw_print within w_sh103_e
string dataobject = "d_sh103_r01"
end type

type st_1 from statictext within w_sh103_e
integer x = 398
integer y = 56
integer width = 1353
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 16777215
boolean focusrectangle = false
end type

type st_2 from statictext within w_sh103_e
integer x = 960
integer y = 244
integer width = 2089
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 16777215
string text = "※ 2006년 봄(S) 이전 제품의 경우 관리팀에 연락 바랍니다."
boolean focusrectangle = false
end type

type st_3 from statictext within w_sh103_e
boolean visible = false
integer x = 1097
integer y = 236
integer width = 1097
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 부진제품은 등록 하실 수 없습니다!"
boolean focusrectangle = false
end type

type st_4 from statictext within w_sh103_e
integer x = 960
integer y = 308
integer width = 1577
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 16777215
string text = "※ RT로 인한 점간이송은 확인만 가능합니다!"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_sh103_e
boolean visible = false
integer x = 46
integer y = 864
integer width = 2770
integer height = 624
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_sh103_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_sh103_e
integer x = 960
integer y = 172
integer width = 2089
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 16777215
string text = "※ 이송업체와 방법, 박스의 경우 박스번호를 반드시  확인 등록바랍니다!"
boolean focusrectangle = false
end type

