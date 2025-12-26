$PBExportHeader$w_53001_e_backup.srw
$PBExportComments$판매등록
forward
global type w_53001_e_backup from w_com010_e
end type
type dw_member from datawindow within w_53001_e_backup
end type
type st_1 from statictext within w_53001_e_backup
end type
type cb_input from commandbutton within w_53001_e_backup
end type
type dw_point from datawindow within w_53001_e_backup
end type
type dw_list from datawindow within w_53001_e_backup
end type
end forward

global type w_53001_e_backup from w_com010_e
integer height = 2324
event ue_input ( )
event ue_tot_set ( )
dw_member dw_member
st_1 st_1
cb_input cb_input
dw_point dw_point
dw_list dw_list
end type
global w_53001_e_backup w_53001_e_backup

type variables
DataWindowChild idw_color, idw_size
String is_brand, is_yymmdd, is_shop_cd, is_shop_type
end variables

forward prototypes
public function boolean wf_goods_chk (long al_goods_amt)
public function boolean wf_member_set (string as_flag, string as_find)
private function boolean wf_coupon_chk (long al_goods_amt)
public function boolean wf_style_chk (long al_row, string as_style_no)
public subroutine wf_amt_set (long al_row, long al_sale_qty, long al_sale_price)
public function boolean wf_style_set (long al_row, string as_style)
end prototypes

event ue_input();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
dw_list.Visible   = False
dw_body.Visible   = True
dw_member.Visible = True

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
dw_member.Reset()
dw_member.insertRow(0)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(6, il_rows)

IF is_shop_type = '1' or is_shop_type = '3'  THEN
	dw_member.Enabled = TRUE
ELSE
	dw_member.Enabled = FALSE 
END IF 
end event

event ue_tot_set();Long ll_sale_qty, ll_sale_amt

ll_sale_qty = Long(dw_body.Describe("evaluate('sum(sale_qty)',0)"))
ll_sale_amt = Long(dw_body.Describe("evaluate('sum(sale_amt)',0)"))

dw_member.Setitem(1, "sale_qty", ll_sale_qty)
dw_member.Setitem(1, "sale_amt", ll_sale_amt)

Return

end event

public function boolean wf_goods_chk (long al_goods_amt);Long ll_accept_point, ll_row, ll_find   

IF isnull(al_goods_amt) OR al_goods_amt = 0 THEN RETURN TRUE 

ll_row = dw_point.RowCount()
IF ll_row < 1 THEN RETURN FALSE

ll_accept_point = al_goods_amt / 10 

ll_find = dw_point.Find("give_point = " + String(ll_accept_point), 1, ll_row) 
IF ll_find > 0 THEN RETURN TRUE 

RETURN FALSE 

end function

public function boolean wf_member_set (string as_flag, string as_find);String  ls_user_name,   ls_jumin,      ls_card_no,      ls_age_grp
Long    ll_total_point, ll_give_point, ll_accept_point, ll_year 
Boolean lb_return 

IF as_flag = '1' THEN
	SELECT user_name,       jumin,          card_no,
			 total_point,     give_point,     accept_point 
	  INTO :ls_user_name,   :ls_jumin,      :ls_card_no,  
			 :ll_total_point, :ll_give_point, :ll_accept_point 
	  FROM TB_71010_M with (nolock)   
	 WHERE jumin   = :as_find ; 
ELSE
	SELECT user_name,       jumin,          card_no,
			 total_point,     give_point,     accept_point 
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

dw_member.SetItem(1, "card_no",      RightA(ls_card_no, 9))
dw_member.SetItem(1, "user_name",    ls_user_name)
dw_member.SetItem(1, "jumin",        ls_jumin)
dw_member.Setitem(1, "total_point",  ll_total_point)
dw_member.Setitem(1, "give_point",   ll_give_point)
dw_member.Setitem(1, "accept_point", ll_accept_point) 

/* 연령층 처리 */
IF lb_return = False OR isnull(as_find) THEN
	setnull(ls_age_grp)
ELSEIF ll_year < 10 THEN
   GF_GET_AGEGRP(ls_jumin, integer(LeftA(is_yymmdd, 4)), ls_age_grp)
END IF
dw_member.SetItem(1, "age_grp", ls_age_grp)
dw_point.Retrieve(ls_jumin)

Return lb_return

end function

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
dw_point.Retrieve(ls_jumin)

Return lb_return
end function

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.05.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_shop_type, ls_given_fg, ls_given_ymd
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn  
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
	
IF SQLCA.SQLCODE <> 0 or ll_cnt <> 1 THEN 
	Return False 
END IF 

if is_shop_type <> '9' and ls_sojae = "C" then 
	messagebox("경고!", "중국수출 모델은 기타에서만 등록 가능합니다!")
	return false
end if	

Select shop_type
into :ls_shop_type
From tb_56012_d with (nolock)
Where style      = :ls_style 
  and start_ymd <= :is_yymmdd
  and end_ymd   >= :is_yymmdd
  and shop_cd    = :is_shop_cd ;

if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
				if is_shop_type = '3' then
				 ls_shop_type = '3'
   			else 
				 ls_shop_type = '1'	
 				end if 
end if	 

if is_shop_type <> ls_shop_type then 
	messagebox("경고!", "제품판매가 가능한 매장형태는 " + ls_shop_type + " 입니다!")
//	return false
end if	

select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
into  :ls_given_fg, :ls_given_ymd
from tb_12020_m with (nolock)
where style = :ls_style;


if ls_given_fg = "Y"  and ls_given_ymd <= is_yymmdd then 
	messagebox("품번체크", ls_given_ymd + "일자로 사은품 전환된 제품입니다!")
	return false
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
	dw_body.SetItem(al_row, "color",    'XX')
	dw_body.SetItem(al_row, "size",     'XX')
ELSE
	dw_body.SetItem(al_row, "color",    '')
	dw_body.SetItem(al_row, "size",     '')
END IF 

Return True

end function

public subroutine wf_amt_set (long al_row, long al_sale_qty, long al_sale_price);/* 각 단가 및 판매량에 따른 금액 처리 */
Long ll_tag_price, ll_curr_price, ll_out_price, ll_collect_price
Long ll_io_amt,    ll_goods_amt,  ll_sale_collect  
Decimal ldc_marjin

ll_tag_price     = dw_body.GetitemDecimal(al_row, "tag_price") 
ll_curr_price    = dw_body.GetitemDecimal(al_row, "curr_price") 
ll_out_price     = dw_body.GetitemNumber(al_row, "out_price") 
ll_collect_price = dw_body.GetitemNumber(al_row, "collect_price")

dw_body.Setitem(al_row, "tag_amt",  ll_tag_price  * al_sale_qty)
dw_body.Setitem(al_row, "curr_amt", ll_curr_price * al_sale_qty)
dw_body.Setitem(al_row, "sale_amt", al_sale_price * al_sale_qty)
dw_body.Setitem(al_row, "out_amt",  ll_out_price  * al_sale_qty) 

ll_goods_amt = dw_body.GetitemDecimal(al_row, "goods_amt") 
IF ll_goods_amt > 0 THEN 
	ldc_marjin = dw_body.GetitemDecimal(al_row, "sale_rate")
	gf_marjin_price(is_shop_cd, (al_sale_price * al_sale_qty) - ll_goods_amt, ldc_marjin, ll_sale_collect)  
ELSE
	ll_sale_collect = ll_collect_price * al_sale_qty
END IF
dw_body.Setitem(al_row, "sale_collect", ll_sale_collect)

/* 세일 재매입 처리 */
ll_io_amt = (ll_out_price  * al_sale_qty) - ll_sale_collect
dw_body.Setitem(al_row, "io_amt", ll_io_amt)
dw_body.Setitem(al_row, "io_vat", ll_io_amt - Round(ll_io_amt / 1.1, 0))

end subroutine

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

on w_53001_e_backup.create
int iCurrent
call super::create
this.dw_member=create dw_member
this.st_1=create st_1
this.cb_input=create cb_input
this.dw_point=create dw_point
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_member
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_input
this.Control[iCurrent+4]=this.dw_point
this.Control[iCurrent+5]=this.dw_list
end on

on w_53001_e_backup.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_member)
destroy(this.st_1)
destroy(this.cb_input)
destroy(this.dw_point)
destroy(this.dw_list)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
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
   MessageBox(ls_title,"브랜드와 매장코드가 일치 하지 않습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_flag, ls_age_grp, ls_jumin 
String     ls_style,   ls_chno, ls_data , ls_sojae, ls_shop_type
string     ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
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
				ls_sojae = lds_Source.GetItemString(1,"sojae")				
				
				if is_shop_type <> '9' and ls_sojae = "C" then 
					messagebox("경고!", "중국수출 모델은 기타에서만 등록 가능합니다!")
					ib_itemchanged = FALSE
					return 1
				end if	
				
				Select shop_type
				into :ls_shop_type
				From tb_56012_d with (nolock)
				Where style      = :ls_style 
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and shop_cd    = :is_shop_cd ;
				  
			if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
				if is_shop_type = '3' then
				 ls_shop_type = '3'
   			else 
				 ls_shop_type = '1'	
 				end if 
			end if	 
				
				if is_shop_type <> ls_shop_type then 
					messagebox("경고!", "제품판매가 가능한 매장형태는 " + ls_shop_type + " 입니다!")
//					ib_itemchanged = FALSE
//					return 1
				end if	
				
				select isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX'),
						 isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
				into :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq, :ls_given_fg, :ls_given_ymd
				from beaucre.dbo.tb_12020_m with (nolock)
				where style like :ls_style + '%';
				
				if ls_bujin_chk = "Y" then 
				messagebox("부진체크", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
				end if 	
				
								
	   		IF ls_given_fg = "Y"  AND ls_given_ymd <= is_yymmdd THEN 
					messagebox("품번검색", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				END IF 
				
				
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
	CASE "card_no", "jumin" 		
			IF ai_div = 1 THEN 	
				IF as_column = "card_no" THEN 
					ls_flag = '2'
				ELSE
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
				ELSE
               gst_cd.Item_where = "jumin   LIKE '" + as_data + "%'"
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
				dw_member.SetItem(1, "give_point",   lds_Source.GetItemNumber(1,"give_point")) 
				dw_member.SetItem(1, "accept_point", lds_Source.GetItemNumber(1,"accept_point")) 
				ls_jumin = lds_Source.GetItemString(1,"jumin")
            GF_GET_AGEGRP(ls_jumin, integer(LeftA(is_yymmdd, 4)), ls_age_grp)
				dw_member.SetItem(1, "age_grp", ls_age_grp) 
				dw_point.Retrieve(ls_jumin)
			   ib_changed        = true
            cb_update.enabled = true
			   /* 다음컬럼으로 이동 */
			   dw_member.SetColumn("sale_qty")
		      lb_check       = TRUE 
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

il_rows = dw_list.retrieve(is_brand, is_yymmdd, is_shop_cd, is_shop_type)

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

dw_point.SetTransObject(SQLCA)
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
      dw_member.Enabled  = false
      dw_head.Enabled    = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 6		/* 입력 */
      if al_rows > 0 then
         cb_insert.enabled  = true
         cb_delete.enabled  = true
         cb_print.enabled   = true
         cb_preview.enabled = true
         cb_excel.enabled   = true
         dw_head.Enabled    = false
         dw_body.Enabled    = true
         dw_member.Enabled  = true
         dw_body.SetFocus()
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
String	ls_sale_type, ls_color, ls_size
long     ll_sale_price, ll_goods_amt, ll_sale_qty 
long     i, ll_row_count, ll_chk, ls_no
decimal  ldc_dc_rate
datetime ld_datetime 

IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_member.AcceptText()    <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

IF is_shop_type = '1' AND isnull(dw_member.Object.age_grp[1]) THEN
	MessageBox("경고", "연령층 이나 회원정보를 등록하십시오 !") 
	Return 0 
END IF

if is_brand <> MidA(is_shop_cd,1,1) then
	MessageBox("경고", "브랜드와 매장이 맞지 않습니다!") 
	Return 0 
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
   ls_sale_no = dw_body.GetitemString(1, "sale_no")
ELSEIF Gf_Get_Saleno(is_yymmdd, is_shop_cd, is_shop_type, ls_sale_no) <> 0 THEN 
	Return -1 
END IF

  select right(isnull(max(NO), 0) + 10001, 4)
  into :ls_no
  from tb_53010_h(nolock) 
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
	   dw_body.Setitem(i, "no",  string(ls_no,"0000"))	
      dw_body.Setitem(i, "yymmdd",     is_yymmdd)
      dw_body.Setitem(i, "shop_cd",    is_shop_cd)
      dw_body.Setitem(i, "shop_type",  is_shop_type)
      dw_body.Setitem(i, "shop_div",   MidA(is_shop_cd, 2, 1))
      dw_body.Setitem(i, "sale_no",    ls_sale_no)
      dw_body.Setitem(i, "reg_id",     gs_user_id)
		
	   ls_no = ls_no + 1 
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF 
   /* 교환권 판매 처리 및 가능여부 체크 (정상판매단가가  교환권금액 이상 매출만 가능) */
	IF is_shop_type = '1' or is_shop_type = '3' THEN  /* 정상 매장만 처리 */
		ll_sale_price = Long(dw_body.GetitemDecimal(i, "sale_price"))
		ll_sale_qty  = dw_body.GetitemDecimal(i, "sale_qty")
		ls_coupon_no = dw_member.GetitemString(1, "coupon_no") 
		ls_style_no  = dw_body.Getitemstring(i, "style_no")
      ls_item      = RightA(LeftA(ls_style_no,2),1)
		      
		IF ll_goods_amt > 0 and ll_sale_price > ll_goods_amt and & 
			ll_sale_qty  > 0 and LeftA(dw_body.Object.sale_type[i], 2) = '11' and &
			ls_item     <> 'X' THEN 
			ls_sale_fg = '2' 
			dw_body.Setitem(i, "goods_amt", ll_goods_amt) 
			dw_body.Setitem(i, "coupon_no", ls_coupon_no)
			ll_goods_amt = 0 
	
		ELSEIF LenA(ls_card_no) = 16 and LeftA(dw_body.Object.sale_type[i], 1) < '2' THEN  // 정상 적용 
			ls_sale_fg = '1' 
			dw_body.Setitem(i, "goods_amt", 0)
			dw_body.Setitem(i, "coupon_no", '')
		ELSE
			ls_sale_fg = '0' 
			dw_body.Setitem(i, "goods_amt", 0)
			dw_body.Setitem(i, "coupon_no", '')
		END IF		
		// 교환권액 등록후 수금액 및 판매감가  산출 
		wf_amt_set(i, ll_sale_qty, ll_sale_price)
		IF idw_status <> New! THEN 
			dw_body.Setitem(i, "age_grp", dw_member.Object.age_grp[1])  
			dw_body.Setitem(i, "sale_fg", ls_sale_fg)
			dw_body.Setitem(i, "jumin",   Trim(dw_member.Object.jumin[1]))  
			dw_body.Setitem(i, "card_no", ls_card_no)  
		END IF
	ELSE 
		dw_body.Setitem(i, "sale_fg", '0')
	END IF 

//	select count(jumin)
//	into :ll_chk
//	from tb_71011_h
//	where give_date >= '20030818'
//	and   substring(coupon_no,1,1) in ('N','O') 
//	and   jumin =  :ls_jumin;
//	
//	if ll_chk <= 0 and is_shop_type = '3' and ldc_dc_rate = 10 then
//		MessageBox("경고", "쿠폰이 발행되지 않아 기획 10% 할인 할 수 없습니다!") 
//		Return 0 
//	end if	

	ldc_dc_rate  = dw_body.getitemnumber(i, "dc_rate")	
	ls_sale_type = dw_body.getitemString(i, "sale_type")	

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
	
	
NEXT

IF ll_goods_amt > 0 THEN 
	MessageBox("교환권 오류", "교환권 판매할수 있는 품번이 없습니다.")
	RETURN 0 
END IF

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

event open;call super::open;dw_head.Setitem(1, "shop_type", '1')
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53001_e","0")
end event

event pfc_dberror();//
end event

type cb_close from w_com010_e`cb_close within w_53001_e_backup
integer taborder = 140
end type

type cb_delete from w_com010_e`cb_delete within w_53001_e_backup
integer taborder = 130
end type

type cb_insert from w_com010_e`cb_insert within w_53001_e_backup
integer taborder = 70
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_53001_e_backup
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

type cb_update from w_com010_e`cb_update within w_53001_e_backup
end type

type cb_print from w_com010_e`cb_print within w_53001_e_backup
boolean visible = false
integer taborder = 100
end type

type cb_preview from w_com010_e`cb_preview within w_53001_e_backup
boolean visible = false
integer taborder = 110
end type

type gb_button from w_com010_e`gb_button within w_53001_e_backup
end type

type cb_excel from w_com010_e`cb_excel within w_53001_e_backup
boolean visible = false
integer taborder = 120
end type

type dw_head from w_com010_e`dw_head within w_53001_e_backup
integer width = 3447
integer height = 156
string dataobject = "d_53001_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 
String DWfilter

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001') 

 DWfilter = "inter_cd <> 'W' " 

ldw_child.SetFilter(DWfilter)
ldw_child.Filter()


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
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_53001_e_backup
integer beginy = 340
integer endy = 340
end type

type ln_2 from w_com010_e`ln_2 within w_53001_e_backup
integer beginy = 344
integer endy = 344
end type

type dw_body from w_com010_e`dw_body within w_53001_e_backup
event ue_set_col ( string as_column )
integer x = 14
integer y = 368
integer width = 3575
integer height = 1304
integer taborder = 50
boolean enabled = false
string dataobject = "d_53001_d01"
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
Decimal ldc_sale_marjin
String  ll_null
SetNull(ll_null)

CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1 
		ll_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1) 
		IF LenA(This.GetitemString(row, "color")) = 2 THEN
			This.Post Event ue_set_col("sale_qty")
		END IF 
		Return ll_ret
	CASE "color"	    
		This.Setitem(row, "size", ll_null) 
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
Long   ll_curr_price, ll_sale_price, ll_collect_price

IF row < 1 THEN RETURN 
ls_style_no = This.GetitemString(row, "style_no")

IF isnull(ls_style_no) or Trim(ls_style_no) = "" THEN RETURN

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
		ls_size = This.GetitemString(row, "size")		

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

type dw_print from w_com010_e`dw_print within w_53001_e_backup
end type

type dw_member from datawindow within w_53001_e_backup
event ue_keydown pbm_dwnkey
event type long ue_item_changed ( long row,  dwobject dwo,  string data )
integer x = 14
integer y = 1664
integer width = 3570
integer height = 456
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_53001_d10"
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

event type long ue_item_changed(long row, dwobject dwo, string data);string ls_coupon_no
decimal ld_goods_amt


CHOOSE CASE dwo.name
	CASE "card_no", "jumin"	    
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "goods_amt" 
		ls_coupon_no = dw_member.getitemstring(1,"coupon_no")
	IF isnull(ls_coupon_no) or ls_coupon_no = "" then
		IF not wf_goods_chk(Long(Data))  THEN 
			MessageBox("쿠폰 체크", "해당금액 쿠폰 발행내역이 없습니다.")
			this.Reset()
			this.InsertRow(1)
			RETURN 1
		END IF
	ELSEIF ls_coupon_no <> "" and  Long(data) = 0 then
		RETURN 0
	ELSE
		IF not wf_coupon_chk(Long(Data))  THEN 
			MessageBox("쿠폰 체크", "쿠폰번호 오류이거나 사용된 쿠폰입니다.")
			this.Reset()
			this.InsertRow(1)
			RETURN 1
		END IF
	END IF
	
	CASE "coupon_no" 
		ld_goods_amt = dw_member.getitemdecimal(1,"goods_amt")
	IF ld_goods_amt <> 0 then
		IF not wf_coupon_chk(long(ld_goods_amt))  THEN 
			MessageBox("쿠폰 체크", "쿠폰번호 오류이거나 사용된 쿠폰입니다.")
			this.Reset()
			this.InsertRow(1)
			RETURN 1
		END IF
	END IF
END CHOOSE 
end event

event itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
string ls_sale_type
string ls_coupon_no
decimal ld_goods_amt

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
	OpenWithParm (W_53001_S2, "W_SH101_S 신규회원접수") 
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

type st_1 from statictext within w_53001_e_backup
integer x = 5
integer y = 360
integer width = 3593
integer height = 1692
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

type cb_input from commandbutton within w_53001_e_backup
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

type dw_point from datawindow within w_53001_e_backup
boolean visible = false
integer x = 1248
integer y = 308
integer width = 1143
integer height = 432
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_53001_d11"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

type dw_list from datawindow within w_53001_e_backup
boolean visible = false
integer x = 18
integer y = 368
integer width = 3575
integer height = 1676
integer taborder = 80
string title = "none"
string dataobject = "d_53001_d08"
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
String ls_sale_no, ls_jumin , ls_coupon_no 

IF row < 1 THEN RETURN 

is_shop_type = This.GetitemString(row, "shop_type")
ls_sale_no   = This.GetitemString(row, "sale_no") 
ls_jumin     = This.GetitemString(row, "jumin")
ls_coupon_no = This.GetitemString(row, "coupon_no")

dw_head.Setitem(1, "shop_type", is_shop_type) 
dw_body.Retrieve(is_yymmdd, is_shop_cd, is_shop_type, ls_sale_no)

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
dw_member.Visible = True
This.visible = False

dw_body.SetFocus()

Parent.Trigger Event ue_button(6, il_rows)

IF is_shop_type = '1' or is_shop_type = '3' THEN
	dw_member.Enabled = TRUE
ELSE
	dw_member.Enabled = FALSE 
END IF 

end event

