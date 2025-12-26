$PBExportHeader$w_sh129_e.srw
$PBExportComments$매장출고 요청등록
forward
global type w_sh129_e from w_com010_e
end type
type st_1 from statictext within w_sh129_e
end type
type st_2 from statictext within w_sh129_e
end type
type dw_1 from datawindow within w_sh129_e
end type
end forward

global type w_sh129_e from w_com010_e
st_1 st_1
st_2 st_2
dw_1 dw_1
end type
global w_sh129_e w_sh129_e

type variables
String is_yymmdd
end variables

forward prototypes
public subroutine wf_style_dup (long al_row, string as_style)
public function boolean wf_stock_chk (long al_row, string as_style_no)
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

public subroutine wf_style_dup (long al_row, string as_style);
end subroutine

public function boolean wf_stock_chk (long al_row, string as_style_no);String ls_style, ls_chno, ls_color, ls_size , ls_find
Long   ll_stock_qty, ll_cnt_stop, ll_row_count, i, k, ll, ll_chk_qty

IF LenA(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)

//select dbo.sf_get_stockqty(:gs_shop_cd, '1', :ls_style, :ls_chno, :ls_color, :ls_size)
//  into :ll_stock_qty
//  from dual;
//
//
//// 기존의 완불등록사항및 승인체크
//select isnull(sum(d.rqst_qty) - (sum(d.accept_qty) +  sum(d.check_cnt)),0)
//into :ll_chk_qty
//from (		
//	select sum(a.rqst_qty) 		as rqst_qty,
//	       sum(a.Accept_Qty)	as accept_qty,
//	
//		isnull((select sum(b.Accept_Qty)
//		  from tb_54031_d b
//		  where b.shop_cd = a.shop_cd
//		  and   b.yymmdd  = a.yymmdd
//		  and   b.rqst_seq = a.rqst_seq
//		  and   b.shop_type = a.shop_type
//		  and   b.accept_fg = 'Y' ),0) as check_cnt	
//	from tb_54030_h a with (nolock) 
//	where a.self_yn = 'N'
//	and   a.yymmdd  >= '20030714'
//	and   a.shop_cd = :gs_shop_cd
//	and   a.style   = :ls_style
//	and   a.chno    = :ls_chno
//	and   a.color   = :ls_color
//	and   a.size    = :ls_size
//	group by a.shop_cd, a.yymmdd, a.rqst_seq,a.shop_type ) d ;
//
//
//
////messagebox("ll_stock_qty", string(ll_stock_qty))
////messagebox("ll_chk_qty", string(ll_chk_qty))
//
//ll_stock_qty = ll_stock_qty + ll_chk_qty
//
////messagebox("ll_stock_qty", string(ll_stock_qty))
////messagebox("ll_chk_qty", string(ll_chk_qty))
////
//ll_row_count = dw_body.rowcount() 
//
//for i = 1 to ll_row_count - 1
//	ls_find = "style_no = '" + ls_style + ls_chno +  ls_color + ls_size + "'"
//	
//	if i <> al_row then
//		k = dw_body.find(ls_find, 1, ll_row_count)		
//   end if
//	
//	if k <> 0 then
//	 ll = dw_body.getitemnumber(k, "rqst_qty")
//   end if
//
////   messagebox("ll_stock_qty", string(ll_stock_qty))
//	
//	ll_stock_qty = ll_stock_qty + ll
//next  
//
//IF sqlca.sqlcode <> 0 THEN 
//	MessageBox("SQL 오류", SQLCA.SQLERRTEXT) 
//	RETURN FALSE 
//ELSEIF ll_stock_qty >= 0 THEN 
//	MessageBox("확인", "재고가 있거나 이미 요청한 제품은 의뢰할수 없습니다!") 
//	dw_body.setitem(al_row, "style_no", "")
//	RETURN FALSE 
//END IF
//
//  
//	select count(style)
//	into :ll_cnt_stop
//	from tb_54040_m
// where brand   = :gs_brand 
//   and style   = :ls_style 
//	and chno    = :ls_chno
//	and color   = :ls_color 
//	and size    = :ls_size
//	and fr_stop_date <= :is_yymmdd
//	and to_stop_date >= :is_yymmdd ;
//	
//
//IF SQLCA.SQLCODE <> 0 THEN 
//	MessageBox("SQL 오류", SQLCA.SQLERRTEXT)
//	RETURN FALSE 
//END IF
//
//
//IF ll_cnt_stop <> 0  THEN 
//	MessageBox("확인", "완불통제된 상품이므로  의뢰할수 없습니다!")
//		dw_body.setitem(al_row, "style_no", "")
//	RETURN FALSE 
//END IF
//
//dw_body.Setitem(al_row, "rqst_qty", 1)

Return True

end function

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_size, ls_shop_type, ls_bujin_chk
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn  
Long   ll_tag_price 

IF LenA(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = MidA(as_style_no,1,1)
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

Select brand,     year,     season,     
       sojae,     item,     plan_yn, dep_fg   
  into :ls_brand, :ls_year, :ls_season, 
       :ls_sojae, :ls_item, :ls_plan_yn, :ls_bujin_chk    
  from vi_12024_1 
 where style   = :ls_style 
	and chno    = :ls_chno
	and color   = :ls_color 
	and size    = :ls_size
	and :gs_brand_grp like '%' + brand + '%';

IF SQLCA.SQLCODE <> 0 THEN 
	MessageBox("SQL 오류", SQLCA.SQLERRTEXT)
	RETURN FALSE 
END IF


IF GS_BRAND <> "J" THEN
	IF ls_plan_yn = 'Y' THEN 
		MessageBox("확인", "기획 품번은 의뢰할수 없습니다!")
		RETURN FALSE 
	END IF
	
	IF ls_bujin_chk = 'Y' THEN 
		MessageBox("확인", "부진 품번은 의뢰할수 없습니다!")
		RETURN FALSE 
	END IF
END IF
//if is_yymmdd <= '20170915' then  
//	Select shop_type
//	into :ls_shop_type
//	From tb_56012_d with (nolock)
//	Where style      = :ls_style 
//	  and start_ymd <= :is_yymmdd
//	  and end_ymd   >= :is_yymmdd
//	  and shop_cd    = :gs_shop_cd ;
//else
	Select shop_type
	into :ls_shop_type
	From tb_56012_d_color with (nolock)
	Where style      = :ls_style 
	  and color      = :ls_color
	  and start_ymd <= :is_yymmdd
	  and end_ymd   >= :is_yymmdd
	  and shop_cd    = :gs_shop_cd ;	
	  
	if Isnull( ls_shop_type) or trim(ls_shop_type) = "" then 
			Select shop_type
		into :ls_shop_type
		From tb_56012_d with (nolock)
		Where style      = :ls_style 
		  and start_ymd <= :is_yymmdd
		  and end_ymd   >= :is_yymmdd
		  and shop_cd    = :gs_shop_cd ;	
	end if	  
//end if	

if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
	ls_shop_type = "1"
end if	

IF GS_BRAND <> "J" THEN
	if ls_shop_type > "3"  then 
		messagebox("경고!", "행사 품번은 의뢰할수 없습니다!")
		return false
	end if	
END IF

IF wf_stock_chk(al_row, as_style_no) THEN 
   dw_body.SetItem(al_row, "style_no", as_style_no)
   dw_body.SetItem(al_row, "style",    ls_style)
	dw_body.SetItem(al_row, "chno",     ls_chno)
	dw_body.SetItem(al_row, "color",    ls_color)
	dw_body.SetItem(al_row, "size",     ls_size)
	dw_body.SetItem(al_row, "brand",    ls_brand)
ELSE
	Return False
END IF

Return True

end function

on w_sh129_e.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.dw_1
end on

on w_sh129_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_1)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_1, "ScaleToRight")
dw_1.SetTransObject(SQLCA)
end event

event pfc_postopen();call super::pfc_postopen;if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

This.Trigger Event ue_retrieve()
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;DECIMAL ldc_rt_rate
INTEGER li_day_no

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

if MidA(gs_shop_cd,3,4) = '2000' or  MidA(gs_shop_cd,1,2) = 'NI' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

is_yymmdd = dw_head.GetItemSTRING(1, "yymmdd")

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox("확인!","브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

select dbo.sf_SHOP_RT_RATE(:is_yymmdd, :gs_shop_cd)
  into :ldc_rt_rate
  from dual;

if gs_brand = "O" and gs_shop_div <> 'K' and  gs_shop_cd <> "OB1890" then
	if ldc_rt_rate < 90 then
		st_1.text = "1주일간의 정상RT반품율이 90% 미만이므로 등록 할 수 없습니다!"
		RETURN FALSE
	else 	
		st_1.text = ""	
	end if
else 	
		st_1.text = ""		
end if


SELECT DATEPART(WEEKDAY, :is_yymmdd)
INTO :li_day_no
FROM DUAL;


//if gs_brand = "N" then
//	if li_day_no > 2 then	
//		st_2.text = "※ 요청등록은 일요일과 월요일에만 가능합니다!"
//		RETURN FALSE
//	else
//		st_2.text = ""
//	end if
//else
//	st_2.text = ""
//end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.23                                                  */	
/* 수정일      : 2002.04.23                                                  */
/*===========================================================================*/
datetime ld_datetime
string   ls_yymmdd, ls_style,ls_style_no,ls_color,ls_size
long ii
string ls_find
long ll_found, ll_row

gf_sysdate(ld_datetime)

ls_yymmdd = String(ld_datetime, "YYYYMMDD")

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
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

//  dw_1.reset()
//	for ii = 1 to il_rows
// 	   ls_style = dw_body.getitemstring(ii, "style")
//		 
//		ll_found = dw_1.Find("style = '" + ls_style + "'", 1, dw_1.RowCount())
//	
//		if ll_found <= 0 then
//			ll_row = dw_1.insertrow(0)
//			dw_1.setitem(ll_row,"style",  ls_style)
//		end if	
//
//	next	
	
	dw_1.reset()
	for ii = 1 to il_rows
 	   ls_style = dw_body.getitemstring(ii, "style")
 	   ls_color = dw_body.getitemstring(ii, "color")
 	   ls_size  = dw_body.getitemstring(ii, "size")		 
		 
		ls_style_no = ls_style + ls_color + ls_size
		
		ll_found = dw_1.Find("style = '" + ls_style_no + "'", 1, dw_1.RowCount())
	
		if ll_found <= 0 then
			ll_row = dw_1.insertrow(0)
			dw_1.setitem(ll_row,"style",  ls_style_no)
		end if	

	next	


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size, ls_shop_type, ls_bujin_chk
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source 

CHOOSE CASE as_column
	CASE "style_no"		
			if MidA(gs_shop_cd_1,1,2) = 'XX' then
				gs_brand = MidA(as_data,1,1)
				gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
			end if
			
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
			
				gst_cd.default_where   = "WHERE  '" + gs_brand_grp + "' like '%' + brand + '%'" + &
												 "  and plan_yn = 'N'"			
			
//			if gs_brand = "J" OR gs_brand = "N" then
//				gst_cd.default_where   = "WHERE brand IN ('N','J') " + &
//												 "  and plan_yn = 'N'"
//			ELSE												 
//				gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' " + &
//												 "  and plan_yn = 'N'"
//			END IF												 
				
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" + &
				                " and chno  LIKE '" + ls_chno + "%'" + &
				                " and color LIKE '" + ls_color + "%'" + &
				                " and size  LIKE '" + ls_size + "%'" + &
									 " and isnull(tag_price,0) > 0 " 
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
				
				ls_color = dw_body.getitemstring(al_row, "color")
				
				Select shop_type
				into :ls_shop_type
				From tb_56012_d_color with (nolock)
				Where style      = :ls_style 
				  and color      = :ls_color
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and shop_cd    = :gs_shop_cd ;
				
				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
					Select shop_type
					into :ls_shop_type
					From tb_56012_d with (nolock)
					Where style      = :ls_style 
					  and start_ymd <= :is_yymmdd
					  and end_ymd   >= :is_yymmdd
					  and shop_cd    = :gs_shop_cd ;
				end if
				
				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
					ls_shop_type = "1"
				end if	
			
				
				if ls_shop_type > "3" then 
					messagebox("경고!", "행사 품번은 의뢰할수 없습니다!")
					ib_itemchanged = FALSE
					return 1					
				end if	
				
				ls_bujin_chk = lds_Source.GetItemString(1,"style_no")
				
				if ls_bujin_chk =  "Y" then 
					messagebox("경고!", "부진 품번은 의뢰할수 없습니다!")
					ib_itemchanged = FALSE
					return 1					
				end if	
				
 				IF wf_stock_chk(al_row, lds_Source.GetItemString(1,"style_no")) THEN 
				   dw_body.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
				   dw_body.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				   dw_body.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "color", lds_Source.GetItemString(1,"color"))
				   dw_body.SetItem(al_row, "size", lds_Source.GetItemString(1,"size"))
				   dw_body.SetItem(al_row, "brand", lds_Source.GetItemString(1,"brand"))
				   dw_body.SetItem(al_row, "tag_price", lds_Source.GetItemNumber(1,"tag_price"))					
				   dw_body.SetItem(al_row, "rqst_qty", 1)										
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
long i, ll_row_count, ii, ll_found, ll_row, ll_no, ll_rqst_qty
datetime ld_datetime
string ls_yymmdd, ls_style, ls_no, ls_color, ls_size, ls_style_no

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_yymmdd = string(ld_datetime, "YYYYMMDD")

	dw_1.reset()
	for ii = 1 to ll_row_count
 	   ls_style = dw_body.getitemstring(ii, "style")
 	   ls_color = dw_body.getitemstring(ii, "color")
 	   ls_size  = dw_body.getitemstring(ii, "size")		 
		 
		ls_style_no = ls_style + ls_color + ls_size
		
		ll_found = dw_1.Find("style = '" + ls_style_no + "'", 1, dw_1.RowCount())
	
		if ll_found <= 0 then
			ll_row = dw_1.insertrow(0)
			dw_1.setitem(ll_row,"style",  ls_style_no)
		end if	
		
		if MidA(gs_shop_cd_1,1,1) = 'XX' then
			if gs_shop_cd <> MidA(ls_style,1,1) then
				messagebox('주의!', '저장은 브랜드별로만 가능합니다.')
				return 0
			end if
		end if		
	next	
	
	
ll_rqst_qty = dw_body.getitemnumber(ll_row_count, "sum_rqst_qty")

	if MidA(gs_shop_cd,2,5) <> "D1900" then 
		
	if gs_brand = "O"  then
		if ll_rqst_qty > 3 then
			messagebox("경고!", "요청할수 있는 수량은 3개로 제한되어 있습니다!")
			 RETURN -1
		end if
	end if
	
	
	if gs_brand <> "J"  then
		if dw_1.RowCount() > 3 then
			messagebox("경고!", "요청할수 있는 스타일은 3개로 제한되어 있습니다!")
			 RETURN -1
		end if
	else
		if dw_1.RowCount() > 5 then
			messagebox("경고!", "요청할수 있는 스타일은 5개로 제한되어 있습니다!")
			 RETURN -1
		end if
	end if
end if

select right(isnull(max(no), 0) + 10001, 4)
  into :ls_no 
  from tb_54014_h (nolock)
 where yymmdd    = :is_yymmdd 
	and shop_cd   = :gs_shop_cd
	and shop_type = '1';

  ll_no = dec(ls_no)


FOR i=1 TO ll_row_count
	idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	IF idw_status = NewModified! THEN				/* New Record */
	 
		dw_body.Setitem(i, "yymmdd",    is_yymmdd)
		dw_body.Setitem(i, "shop_cd",   gs_shop_cd)
		dw_body.Setitem(i, "shop_type", '1')
		dw_body.Setitem(i, "NO", string(ll_no, "0000"))
		dw_body.Setitem(i, "reg_id", gs_user_id)
		ll_no = ll_no + 1
	ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		dw_body.Setitem(i, "mod_id", gs_user_id)
		dw_body.Setitem(i, "mod_dt", ld_datetime)
	END IF
NEXT

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

event open;call super::open;datetime ld_datetime
string   ls_yymmdd

gf_sysdate(ld_datetime)

ls_yymmdd = String(ld_datetime, "YYYYMMDD")

DW_HEAD.SETITEM(1, "YYMMDD", LS_YYMMDD)
end event

type cb_close from w_com010_e`cb_close within w_sh129_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh129_e
end type

type cb_insert from w_com010_e`cb_insert within w_sh129_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh129_e
end type

type cb_update from w_com010_e`cb_update within w_sh129_e
end type

type cb_print from w_com010_e`cb_print within w_sh129_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh129_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh129_e
end type

type dw_head from w_com010_e`dw_head within w_sh129_e
integer width = 2802
integer height = 160
string dataobject = "d_sh128_h01"
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

type ln_1 from w_com010_e`ln_1 within w_sh129_e
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_e`ln_2 within w_sh129_e
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_e`dw_body within w_sh129_e
event ue_set_column ( long al_row )
integer y = 364
integer width = 2848
integer height = 1420
string dataobject = "d_sh128_d01"
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

type dw_print from w_com010_e`dw_print within w_sh129_e
end type

type st_1 from statictext within w_sh129_e
integer x = 937
integer y = 172
integer width = 2002
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_2 from statictext within w_sh129_e
integer x = 923
integer y = 260
integer width = 2085
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
string text = "※ 요청등록 및 수정은 이번주 수요일부터 다음주 화요일까지 가능합니다!"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_sh129_e
integer x = 1961
integer y = 476
integer width = 896
integer height = 868
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "요청스타일수"
string dataobject = "d_sh128_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

