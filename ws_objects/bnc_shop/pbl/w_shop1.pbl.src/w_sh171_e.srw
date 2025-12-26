$PBExportHeader$w_sh171_e.srw
$PBExportComments$매장행사완불요청
forward
global type w_sh171_e from w_com010_e
end type
type st_1 from statictext within w_sh171_e
end type
type st_2 from statictext within w_sh171_e
end type
type st_3 from statictext within w_sh171_e
end type
type st_4 from statictext within w_sh171_e
end type
end forward

global type w_sh171_e from w_com010_e
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
end type
global w_sh171_e w_sh171_e

type variables
String is_yymmdd
end variables

forward prototypes
public function boolean wf_stock_chk (long al_row, string as_style_no)
public function boolean wf_style_chk (long al_row, string as_style_no)
public function boolean wf_style_set (long al_row, string as_style)
end prototypes

public function boolean wf_stock_chk (long al_row, string as_style_no);String ls_style, ls_chno, ls_color, ls_size , ls_find
Long   ll_stock_qty, ll_cnt_stop, ll_row_count, i, k, ll, ll_chk_qty, ll_real_stock_qty, j, ll_row_count_1
long   ll_cnt

IF LenA(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)

ll_stock_qty = 0
ll_real_stock_qty = 0

ll_row_count = dw_body.rowcount() 
ll_cnt = ll_row_count


for i = 1 to ll_row_count - 1	

	ls_find = "style_no = '" + ls_style + ls_chno +  ls_color + ls_size + "'"
//	messagebox('ls_find',ls_find)
	if i <> al_row then
		k = dw_body.find(ls_find, 1, ll_row_count)		
   end if
	
	if k <> 0 then
	 ll = dw_body.getitemnumber(k, "rqst_qty")
   end if

//   messagebox("ll_stock_qty", string(ll_stock_qty))
	
	ll_stock_qty = ll_stock_qty + ll
next  



//IF sqlca.sqlcode <> 0 THEN 
//	MessageBox("SQL 오류", SQLCA.SQLERRTEXT) 
//	RETURN FALSE 
//ELSE
	IF ll_stock_qty > 0 THEN 
	MessageBox("확인", "재고가 있거나 이미 요청한 제품은 의뢰할수 없습니다!") 
	dw_body.setitem(al_row, "style_no", "")
	RETURN FALSE 
END IF

 
dw_body.Setitem(al_row, "rqst_qty", 1)



//창고재고 확인(20130308)
ll_row_count_1 = dw_body.rowcount() 

select dbo.sf_house_real_stock(:ls_style, :ls_chno, :ls_color, :ls_size, '010000')
  into :ll_real_stock_qty
  from dual;

for j = 0 to ll_row_count_1 - 1

	IF SQLCA.SQLCODE <> 0 THEN 
		MessageBox("SQL 오류", SQLCA.SQLERRTEXT)
		RETURN FALSE 
	END IF
	
	IF ll_real_stock_qty <= 0  THEN 
		MessageBox("확인", "물류창고에 재고가 없어 의뢰할 수 없습니다!")
			dw_body.DeleteRow (ll_row_count_1)
			dw_body.insertrow (ll_row_count_1)

			//변화된 내역을 확인 후 저장여부 구분
			if ll_cnt = dw_body.rowcount() then
				ib_changed = false
				cb_update.enabled = false
			else
				ib_changed = true
				cb_update.enabled = true
			end if

		RETURN FALSE 
	END IF
next  

Return True

end function

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_size, ls_shop_type, ls_bujin_chk
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn, ls_shop_type_1
Long   ll_tag_price 

IF LenA(Trim(as_style_no)) <> 13 THEN RETURN FALSE

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_brand = dw_head.getitemstring(1,'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)

Select brand,     year,     season,     
       sojae,     item,     plan_yn, dep_fg   
  into :ls_brand, :ls_year, :ls_season, 
       :ls_sojae, :ls_item, :ls_plan_yn, :ls_bujin_chk    
  from vi_12024_1 
 where brand   = :gs_brand 
   and style   = :ls_style 
	and chno    = :ls_chno
	and color   = :ls_color 
	and size    = :ls_size ;

IF SQLCA.SQLCODE <> 0 THEN 
	MessageBox("SQL 오류", SQLCA.SQLERRTEXT)
	RETURN FALSE 
END IF
//  
//  if is_yymmdd <= '20170915' then
//	Select shop_type
//	into :ls_shop_type
//	From tb_56012_d with (nolock)
//	Where style      = :ls_style 
//	  and start_ymd <= :is_yymmdd
//	  and end_ymd   >= :is_yymmdd
//	  and shop_type <> '9'
//	  and shop_cd    = :gs_shop_cd ;
//else
	Select shop_type
	into :ls_shop_type
	From tb_56012_d_color with (nolock)
	Where style      = :ls_style 
	  and color      = :ls_color
	  and start_ymd <= :is_yymmdd
	  and end_ymd   >= :is_yymmdd
	  and shop_type <> '9'
	  and shop_cd    = :gs_shop_cd ;
	  
	  if Isnull(ls_shop_type) or Trim(ls_shop_type) = "" then
			Select shop_type
			into :ls_shop_type
			From tb_56012_d with (nolock)
			Where style      = :ls_style 
			  and start_ymd <= :is_yymmdd
			  and end_ymd   >= :is_yymmdd
			  and shop_type <> '9'
			  and shop_cd    = :gs_shop_cd ;	  
		end if	  
	
//end if 	

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
				ls_shop_type = '4'					
			end if
		else
			ls_shop_type = ls_shop_type_1				
		end if
	else

	//코인코즈 제외
		if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
			IF ls_plan_yn = 'Y' then
				ls_shop_type = "3"
			ELSE	
				ls_shop_type = "1"
			END IF	
		end if	
	end if

	if ls_shop_type = "1" THEN					
		messagebox("경고!", "정상제품은 의뢰할수 없습니다!")
		ib_itemchanged = FALSE
		return FALSE				
	end if	

			
IF wf_stock_chk(al_row, as_style_no) THEN 
   dw_body.SetItem(al_row, "SHOP_TYPE", LS_SHOP_TYPE)
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
	dw_body.SetItem(al_row, "rqst_qty", 1)	
	 wf_stock_chk(al_row, as_style_no)
ELSE
	Return False
END IF		

Return True

end function

public function boolean wf_style_set (long al_row, string as_style);Long    ll_dc_rate     
Long    ll_curr_price,  ll_out_price
Long    ll_sale_price,  ll_collect_price 
String  ls_shop_type,   ls_sale_type = space(2), ls_color
decimal ldc_out_marjin, ldc_sale_marjin

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_brand = dw_head.getitemstring(1,'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

/* 정상, 기획 */
ls_shop_type = dw_body.GetitemString(al_row, "shop_type")
ls_color = dw_body.GetitemString(al_row, "color")

//if is_yymmdd <= '20170915' then
//	/* 출고시 마진율 체크 */
//	IF gf_out_marjin (is_yymmdd,    gs_shop_cd,     ls_shop_type, as_style, & 
//							ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
//		RETURN False 
//	END IF
//	/* 판매 마진율 체크 */
//	IF gf_sale_marjin (is_yymmdd,    gs_shop_cd,      ls_shop_type, as_style, & 
//							 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 
//		RETURN False 
//	END IF
//else 
		/* 출고시 마진율 체크 */
	IF gf_out_marjin_color (is_yymmdd,    gs_shop_cd,     ls_shop_type, as_style, ls_color,& 
							ls_sale_type, ldc_out_marjin, ll_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
		RETURN False 
	END IF
	/* 판매 마진율 체크 */
	IF gf_sale_marjin_color (is_yymmdd,    gs_shop_cd,      ls_shop_type, as_style, ls_color,& 
							 ls_sale_type, ldc_sale_marjin, ll_dc_rate,   ll_sale_price, ll_collect_price) = FALSE THEN 
		RETURN False 
	END IF
//end if	

/* 판매 자료 등록 */
dw_body.Setitem(al_row, "RQST_qty",   1)
Dw_body.Setitem(al_row, "sale_price",    ll_sale_price)

/* 금액 처리 */
//wf_amt_set(al_row, 1)

RETURN True
end function

on w_sh171_e.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
end on

on w_sh171_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_1, "ScaleToRight")

end event

event pfc_postopen();call super::pfc_postopen;if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

This.Trigger Event ue_retrieve()
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;LONG LL_CNT
datetime ld_datetime
string ls_TIME, ls_wan_yn

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return FALSE
END IF

ls_TIME = string(ld_datetime, "HM")

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox('확인!',"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if


  select wan_yn 
  into :ls_wan_yn
    from tb_91100_m 
   where brand     =    'N'
			and shop_cd = :gs_shop_cd
			and shop_stat = '00' 
			and shop_div  in  ('G', 'K', 'D','Z','E','B','X','T')
			and shop_seq  < '5000';

if ls_wan_yn = 'N' then
	messagebox('확인!', '행사완불 요청대상 매장이 아닙니다. 영업담당에게 확인해 주십시요!')
	RETURN FALSE
end if

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

//select count(shop_cd)
//  into :ll_cnt
//   from tb_51035_h a (nolock)
//    where a.brand = :gs_brand
//      and :is_yymmdd between a.frm_ymd and a.to_ymd
//      and a.shop_cd = :gs_shop_cd ;
//		
//
//if ll_cnt < 1 then
//	st_1.text = "※ 요청등록은 진행 행사가 있는 기간에만 가능합니다."
//	RETURN FALSE
//else 	
//	st_1.text = ""	
//end if
/*
if ls_TIME > "1700" then
	st_2.text = "※ 등록은 오후 5시까지만 가능합니다."
	RETURN FALSE
else 	
	st_2.text = ""	
end if
*/
return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.23                                                  */	
/* 수정일      : 2002.04.23                                                  */
/*===========================================================================*/
datetime ld_datetime
string   ls_yymmdd

gf_sysdate(ld_datetime)

ls_yymmdd = String(ld_datetime, "YYYYMMDD")

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(is_yymmdd, gs_shop_cd)

IF il_rows > 0 and ls_yymmdd = is_yymmdd THEN
	dw_body.insertRow(0)
	dw_body.SetRow(il_rows + 1)
   dw_body.SetFocus()
ELSEIF il_rows = 0 and ls_yymmdd = is_yymmdd THEN
	dw_body.insertRow(0)
	dw_body.SetRow(1)
   dw_body.SetFocus()
else
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size, ls_shop_type, ls_bujin_chk, ls_shop_type_1
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source 

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = MidA(as_data,1,1)
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

CHOOSE CASE as_column
	CASE "style_no"		
			IF ai_div = 1 THEN 	
				IF wf_style_chk(al_row, as_data)  THEN
				   ll_row_cnt = dw_body.RowCount()
				   IF al_row = ll_row_cnt THEN 
					   ll_row_cnt = dw_body.insertRow(0)
				   END IF
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
			gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' " 

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
				ls_color = lds_Source.GetItemString(1,"color")					
				
				Select shop_type
				into :ls_shop_type
				From tb_56012_d_color with (nolock)
				Where style      = :ls_style 
				  and color      = :ls_color	
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and shop_type <> '9'
				  and shop_cd    = :gs_shop_cd ;				
				
				if Isnull(ls_shop_type) or Trim(ls_shop_type) = "" then
					Select shop_type
					into :ls_shop_type
					From tb_56012_d with (nolock)
					Where style      = :ls_style 
					  and start_ymd <= :is_yymmdd
					  and end_ymd   >= :is_yymmdd
					  and shop_type <> '9'
					  and shop_cd    = :gs_shop_cd ;
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
							ls_shop_type = '4'					
						end if
					else
						ls_shop_type = ls_shop_type_1				
					end if
				else
			
					//코인코즈 제외
					if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
						IF lds_Source.GetItemString(1,"plan_yn") = 'Y' then
							ls_shop_type = "3"
						ELSE	
							ls_shop_type = "1"
						END IF	
					end if	
				end if
/*				
				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
					IF lds_Source.GetItemString(1,"plan_yn") = 'Y' then
						ls_shop_type = "3"
					ELSE	
						ls_shop_type = "1"
					END IF	
				end if	
*/


				
				if ls_shop_type = "1" THEN					
					messagebox("경고!", "정상제품은 의뢰할수 없습니다!")
					ib_itemchanged = FALSE
					return 1					
				end if	
				
			   dw_body.SetItem(al_row, "SHOP_TYPE", LS_SHOP_TYPE)




			IF wf_stock_chk(al_row, lds_Source.GetItemString(1,"style_no")) THEN 
 				IF  wf_style_set(al_row, ls_style) THEN 
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
				   dw_body.SetItem(al_row, "rqst_qty", 1)			
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
			      lb_check = TRUE 
					st_1.Text = "<- 등록후 반드시 저장버튼을 누르세요"
				else	
				   dw_body.SetColumn("style_no")
				END IF
			else
				dw_body.SetColumn("style_no")
			end if	
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

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.23                                                  */	
/* 수정일      : 2002.04.23                                                  */
/*===========================================================================*/
long i, ll_row_count, LL_RQST_QTY
datetime ld_datetime
string ls_yymmdd
integer li_rqst_seq

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_yymmdd = string(ld_datetime, "YYYYMMDD")


select isnull(max(rqst_seq),0)
into :li_rqst_seq
from tb_54032_h
where shop_cd = :gs_shop_cd
and yymmdd = :is_yymmdd;

FOR i=1 TO ll_row_count
	
	LL_RQST_QTY = DW_BODY.GETITEMNUMBER(I, "RQST_QTY")
	if LL_RQST_QTY > 3 then
		MESSAGEBOX("경고!", "요청량은 3장이하만 가능합니다!")
		RETURN -1
	end if
	
	
	idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	IF idw_status = NewModified! THEN				/* New Record */	
		dw_body.Setitem(i, "yymmdd",    is_yymmdd)
		dw_body.Setitem(i, "shop_cd",   gs_shop_cd)
		dw_body.Setitem(i, "rqst_seq", li_rqst_seq + 1 )
		dw_body.Setitem(i, "reg_id", gs_user_id)
	ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		dw_body.Setitem(i, "mod_id", gs_user_id)
		dw_body.Setitem(i, "mod_dt", ld_datetime)
	END IF
	
	li_rqst_seq = li_rqst_seq + 1
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

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
	st_1.Text = ""
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_button;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

datetime ld_datetime
string   ls_yymmdd

gf_sysdate(ld_datetime)

ls_yymmdd = String(ld_datetime, "YYYYMMDD")

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
			if ls_yymmdd = is_yymmdd then 
   	      cb_delete.enabled = true
			else
   	      cb_delete.enabled = false
			end if	
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
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
				dw_head.Enabled = false
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

event open;call super::open;//if gs_brand = "O" then
//	dw_body.Object.rqst_qty.Protect=1
//end if



end event

type cb_close from w_com010_e`cb_close within w_sh171_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh171_e
end type

type cb_insert from w_com010_e`cb_insert within w_sh171_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh171_e
end type

type cb_update from w_com010_e`cb_update within w_sh171_e
end type

type cb_print from w_com010_e`cb_print within w_sh171_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh171_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh171_e
end type

type dw_head from w_com010_e`dw_head within w_sh171_e
integer width = 2802
integer height = 176
string dataobject = "d_sh116_h01"
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

type ln_1 from w_com010_e`ln_1 within w_sh171_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_e`ln_2 within w_sh171_e
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_e`dw_body within w_sh171_e
event ue_set_column ( long al_row )
integer x = 5
integer y = 368
integer width = 2848
integer height = 1416
string dataobject = "d_sh171_d01"
boolean hscrollbar = true
end type

event dw_body::ue_set_column(long al_row);/* 품번 키보드 및 스캐너 입력시 다음 line으로 이동 */

dw_body.SetRow(al_row + 1)  
dw_body.SetColumn("style_no")

end event

event dw_body::constructor;call super::constructor;This.SetRowFocusIndicator(Hand!)

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

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.04.23                                                  */	
/* 수정일      : 2002.04.23                                                  */
/*===========================================================================*/
integer il_ret
st_1.Text = "<- 등록후 반드시 저장버튼을 누르세요"

CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		il_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		IF il_ret <> 1 THEN
			This.Post Event ue_set_column(row) 
		END IF
		return il_ret

END CHOOSE

end event

event dw_body::editchanged;call super::editchanged;st_1.Text = "<- 등록후 반드시 저장버튼을 누르세요" 
cb_delete.enabled = true


end event

type dw_print from w_com010_e`dw_print within w_sh171_e
end type

type st_1 from statictext within w_sh171_e
integer x = 1019
integer y = 184
integer width = 1824
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
string text = "※ 행사가 있는 기간에만 가능합니다."
boolean focusrectangle = false
end type

type st_2 from statictext within w_sh171_e
integer x = 1019
integer y = 248
integer width = 1847
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
string text = "※ 클레임건은 구분하시기 바랍니다."
boolean focusrectangle = false
end type

type st_3 from statictext within w_sh171_e
boolean visible = false
integer x = 1312
integer y = 340
integer width = 1559
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
string text = "※ 등록확인시간 ①전일 17시~~금일11시까지 : 15시확인"
boolean focusrectangle = false
end type

type st_4 from statictext within w_sh171_e
boolean visible = false
integer x = 1312
integer y = 396
integer width = 1545
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
string text = "②금일 11시~~금일17시까지 : 18시확인"
alignment alignment = right!
boolean focusrectangle = false
end type

