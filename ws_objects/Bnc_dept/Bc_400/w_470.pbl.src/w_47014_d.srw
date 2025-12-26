$PBExportHeader$w_47014_d.srw
$PBExportComments$직영몰판매비교(직영몰VS메이크샵)
forward
global type w_47014_d from w_com010_d
end type
type tab_1 from tab within w_47014_d
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tabpage_4 from userobject within tab_1
end type
type mle_1 from multilineedit within tabpage_4
end type
type tabpage_4 from userobject within tab_1
mle_1 mle_1
end type
type tab_1 from tab within w_47014_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type dw_pass from datawindow within w_47014_d
end type
type cb_1 from commandbutton within w_47014_d
end type
type dw_sale from datawindow within w_47014_d
end type
type dw_rtrn from datawindow within w_47014_d
end type
type cb_2 from commandbutton within w_47014_d
end type
type dw_insert from datawindow within w_47014_d
end type
type cb_4 from commandbutton within w_47014_d
end type
end forward

global type w_47014_d from w_com010_d
integer width = 3680
tab_1 tab_1
dw_pass dw_pass
cb_1 cb_1
dw_sale dw_sale
dw_rtrn dw_rtrn
cb_2 cb_2
dw_insert dw_insert
cb_4 cb_4
end type
global w_47014_d w_47014_d

type variables
DataWindowChild idw_shop_cd
string is_fr_ymd, is_to_ymd, is_brand, is_style, is_chno, is_gubn, is_order_stat, is_stat 
int ii_index, ii_insert_data = 0
Boolean lb_ret_chk1 = False, lb_ret_chk2 = False, lb_ret_chk3 = False

end variables

on w_47014_d.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_pass=create dw_pass
this.cb_1=create cb_1
this.dw_sale=create dw_sale
this.dw_rtrn=create dw_rtrn
this.cb_2=create cb_2
this.dw_insert=create dw_insert
this.cb_4=create cb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_pass
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_sale
this.Control[iCurrent+5]=this.dw_rtrn
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.dw_insert
this.Control[iCurrent+8]=this.cb_4
end on

on w_47014_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_pass)
destroy(this.cb_1)
destroy(this.dw_sale)
destroy(this.dw_rtrn)
destroy(this.cb_2)
destroy(this.dw_insert)
destroy(this.cb_4)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드를 입력하십시요!")
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

is_gubn = dw_head.GetItemString(1, "gubn")
if IsNull(is_gubn) or Trim(is_gubn) = "" then
	is_gubn = "%"
end if

is_order_stat = dw_head.GetItemString(1, "order_stat")
if IsNull(is_order_stat) or Trim(is_order_stat) = "" then
	is_order_stat = "%"
end if

is_stat = dw_head.GetItemString(1, "stat")
if IsNull(is_stat) or Trim(is_stat) = "" then
	is_stat = "%"
end if

select count(order_no) 
into :ii_insert_data
from tb_45040_insert
where yymm = substring(:is_fr_ymd,1,6)
		and brand = :is_brand;
		
if ii_insert_data < 1 then
	cb_1.enabled = false
else 
	cb_1.enabled = true
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;int net

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)		
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA) 

Choose Case tab_1.SelectedTab
	Case 1
		if ii_insert_data > 0 then
			net = MessageBox("확인", '당월 정산 임시 데이터가 있습니다! 조회 하시겠습니까?', Question!, YesNo! )
			if net = 1 then
				tab_1.tabpage_1.dw_1.dataobject = 'd_47014_d07'
				tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
			else
				tab_1.tabpage_1.dw_1.dataobject = 'd_47014_d01'
				tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)		
			end if
			
		end if
		il_rows = tab_1.tabpage_1.dw_1.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_style, is_chno, is_gubn, is_order_stat, is_stat )
		lb_ret_chk1 = True
	Case 2
		il_rows = tab_1.tabpage_2.dw_2.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_style, is_chno, is_gubn, is_order_stat, is_stat )
		lb_ret_chk2 = True
	Case 3
		il_rows = tab_1.tabpage_3.dw_3.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_style, is_chno, is_gubn, is_order_stat, is_stat )
		lb_ret_chk3 = True
	Case 4
		tab_1.Tabpage_4.mle_1.text = "1. 라운지비의 정산은 메이크샵 판매분을 본사 전산의 판매/반품에 맞춰 정상하는 방식이다.~r~n~r~n" + & 
											 "2. [ 항목설명 ]~r~n" + & 
											 "   ① 영업관리 판매가 : 영업관리판매가~r~n" + & 
											 "   ② 몰 판매가 : 입점몰 파일등록의 판매가~r~n" + & 
											 "   ③ 차액 : 몰판매가 - 영업관리판매가~r~n" + & 
											 "   ④ 결제금액 : 몰판매가 - (회원등급할인액+쿠폰할인금액+모바일할인금액+사용한적립금)~r~n" + & 
											 "   ⑤ 실결제가 : MAKE_SHOP 판매가격 - (회원등급할인액+쿠폰할인금액+모바일할인금액+사용한적립금)~r~n" + & 
											 "   ⑥ 차액 : ⑤ 실결제가 - ④ 결제금액~r~n" + & 
											 "   ⑦ 회원등급할인액 : 회원등급할인액~r~n" + & 
											 "   ⑧ 쿠폰 할인금액 : 쿠폰 할인금액~r~n" + & 
											 "   ⑨ 모바일 할인금액 : 모바일 할인금액~r~n" + & 
											 "   ⑩ 사용한 적립금 : 사용한 적립금~r~n" + & 
											 "   ⑪ 합계 : 회원등급할인액 + 쿠폰할인금액 + 모바일할인금액 + 사용한적립금~r~n" + & 
											 "   ⑫ 배송료 : 배송료~r~n~r~n" + & 
											 "3. [ 작업방법 ]~r~n" + &
											 "   ① 메이크샵 내려받은 정산파일을 22.정산 데이터 입력(W_47013_E)에서 입력한다.~r~n" + & 
											 "   ② 브랜드별로 기초데이터 조회를 한후 임시데이터 생성을 한다.~r~n" + & 
											 "   ③ 임시데이터 조회를 하여 수정을 하고 임시데이터 저장을 한다.~r~n" + & 
											 "   ② 더이상 수정할 데이터가 없을 경우 월정산마감을 하여 최총파일을 만든다."
		
END Choose

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				  "t_fr_ymd.Text = '" + is_fr_ymd + "'" + &				 
				  "t_to_ymd.Text = '" + is_to_ymd + "'"

dw_print.Modify(ls_modify)


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column

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
			gst_cd.default_where   = "WHERE 1 = 1 "
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

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count,li_cnt_err, ll_cnt
string ls_style_chk, ls_yymm
datetime ld_datetime
string ls_brand, ls_shop_nm, ls_order_id, ls_order_no, ls_stat, ls_gubn, ls_payment_stat, ls_payment_method, ls_order_stat, ls_sale_ymd, ls_invoice, ls_style_no, ls_m_style, ls_ord_ymd
decimal ld_qty, ld_sale_qty, ld_erp_sale_amt, ld_make_sale_amt, ld_goods_amt, ld_coupon_amt, ld_use_amt, ld_ship_charge, ld_sale_price, ld_cha_amt_1, ld_sil_amt, ld_cha_amt_2, ld_total_use, ld_mobile_amt
string ls_shop_cd, ls_s_shop_type, ls_sale_no, ls_s_no, ls_rtrn_sale_ymd, ls_r_shop_type, ls_rtrn_no, ls_r_no

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

IF tab_1.tabpage_1.dw_1.AcceptText() <> 1 THEN RETURN -1

ll_row_count = tab_1.tabpage_1.dw_1.RowCount()

ls_yymm = MidA(dw_head.getitemstring(1,"fr_ymd"),1,6)
dw_body.reset()
select count(order_no) 
into :ll_cnt
from tb_45040_s
where yymm = :ls_yymm 
		and brand = :is_brand;

if ll_row_count >= 1 then
	if ll_cnt > 0 then
		if MessageBox("확인", ls_yymm + '월 정산 마감 데이터가 있습니다! 재 처리 하시겠습니까 ?', Question!, YesNo! ) = 2 then
			return 0 
		end if

		delete
		from tb_45040_s
		where yymm = :ls_yymm 
		and brand = :is_brand;
		commit  USING SQLCA;
		
	end if
	
	if ll_cnt <= 0 then
		if MessageBox("확인", "월정산마감 처리 하시겠습니까 ?", Question!, YesNo! ) = 2 then
			RETURN 0 
		end if
	end if
else 
	return 0
end if

select count(order_no) 
into :ii_insert_data
from tb_45040_insert with (nolock)
where yymm = :ls_yymm
		and brand = :is_brand;
		
if ii_insert_data >= 1 then
	insert tb_45040_s
	select *
	from tb_45040_insert
	where yymm = :ls_yymm 
			and brand = :is_brand;
			commit  USING SQLCA;			
	messagebox('확인!','월정산 처리가 완료 되었습니다!')			
	
elseif ii_insert_data < 1 then
	messagebox('확인!','먼저 임시데이터를 생성해 주세요!')
	return 0
end if



/*
FOR i=1 TO ll_row_count
	
	ls_brand				 = mid(tab_1.tabpage_1.dw_1.getitemstring(i,"shop_cd"),1,1)
	ls_shop_nm			 = tab_1.tabpage_1.dw_1.getitemstring(i,"shop_nm")
	ls_order_id			 = tab_1.tabpage_1.dw_1.getitemstring(i,"order_id")
	ls_order_no			 = tab_1.tabpage_1.dw_1.getitemstring(i,"order_no")
	ls_stat				 = tab_1.tabpage_1.dw_1.getitemstring(i,"stat")
	ls_gubn				 = tab_1.tabpage_1.dw_1.getitemstring(i,"gubn")
	ls_payment_stat	 = tab_1.tabpage_1.dw_1.getitemstring(i,"payment_stat")
	ls_payment_method	 = tab_1.tabpage_1.dw_1.getitemstring(i,"payment_method")
	ls_order_stat		 = tab_1.tabpage_1.dw_1.getitemstring(i,"order_stat")
	ls_ord_ymd			 = tab_1.tabpage_1.dw_1.getitemstring(i,"ord_ymd")
	ls_invoice			 = tab_1.tabpage_1.dw_1.getitemstring(i,"invoice")
	ls_style_no			 = tab_1.tabpage_1.dw_1.getitemstring(i,"style_no")
	ls_m_style			 = tab_1.tabpage_1.dw_1.getitemstring(i,"m_style")
	ld_qty				 = tab_1.tabpage_1.dw_1.getitemnumber(i,"qty")
	ld_sale_qty			 = tab_1.tabpage_1.dw_1.getitemnumber(i,"sale_qty")	
	ld_erp_sale_amt	 = tab_1.tabpage_1.dw_1.getitemnumber(i,"erp_sale_amt")	
	ld_sale_price		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"sale_price")
	ld_cha_amt_1		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"cha_amt_1")	
	ld_make_sale_amt	 = tab_1.tabpage_1.dw_1.getitemnumber(i,"make_sale_amt")
	ld_sil_amt			 = tab_1.tabpage_1.dw_1.getitemnumber(i,"sil_amt")
	ld_cha_amt_2		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"cha_amt_2")
	ld_goods_amt		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"goods_amt")
	ld_coupon_amt		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"coupon_amt")
	ld_mobile_amt		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"mobile_amt")
	ld_use_amt			 = tab_1.tabpage_1.dw_1.getitemnumber(i,"use_amt")
	ld_total_use		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"total_use")
	ld_ship_charge		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"ship_charge")	
	ls_shop_cd			 = tab_1.tabpage_1.dw_1.getitemstring(i,"shop_cd")
	ls_sale_ymd			 = tab_1.tabpage_1.dw_1.getitemstring(i,"sale_ymd")
	ls_s_shop_type		 = tab_1.tabpage_1.dw_1.getitemstring(i,"s_shop_type")
	ls_sale_no			 = tab_1.tabpage_1.dw_1.getitemstring(i,"sale_no")
	ls_s_no				 = tab_1.tabpage_1.dw_1.getitemstring(i,"s_no")
	ls_rtrn_sale_ymd	 = tab_1.tabpage_1.dw_1.getitemstring(i,"rtrn_sale_ymd")
	ls_r_shop_type		 = tab_1.tabpage_1.dw_1.getitemstring(i,"r_shop_type")
	ls_rtrn_no			 = tab_1.tabpage_1.dw_1.getitemstring(i,"rtrn_no")
	ls_r_no				 = tab_1.tabpage_1.dw_1.getitemstring(i,"r_no")

	dw_body.insertrow(0)
	dw_body.Setitem(i, "yymm", ls_yymm)
	dw_body.Setitem(i, "brand", ls_brand)
	dw_body.Setitem(i, "shop_nm", ls_shop_nm)
	dw_body.Setitem(i, "order_id", ls_order_id)
	dw_body.Setitem(i, "order_no", ls_order_no)
	dw_body.Setitem(i, "stat", ls_stat)
	dw_body.Setitem(i, "gubn", ls_gubn)
	dw_body.Setitem(i, "payment_stat", ls_payment_stat)
	dw_body.Setitem(i, "payment_method", ls_payment_method)
	dw_body.Setitem(i, "order_stat", ls_order_stat)
	dw_body.Setitem(i, "ord_ymd", ls_ord_ymd)
	dw_body.Setitem(i, "invoice", ls_invoice)
	dw_body.Setitem(i, "style_no", ls_style_no)
	dw_body.Setitem(i, "m_style", ls_m_style)
	dw_body.Setitem(i, "qty", ld_qty)
	dw_body.Setitem(i, "sale_qty", ld_sale_qty)	
	dw_body.Setitem(i, "erp_sale_amt", ld_erp_sale_amt)	
	dw_body.Setitem(i, "sale_price", ld_sale_price)
	dw_body.Setitem(i, "cha_amt_1", ld_cha_amt_1)
	dw_body.Setitem(i, "make_sale_amt", ld_make_sale_amt)
	dw_body.Setitem(i, "sil_amt", ld_sil_amt)
	dw_body.Setitem(i, "cha_amt_2", ld_cha_amt_2)	
	dw_body.Setitem(i, "goods_amt", ld_goods_amt)
	dw_body.Setitem(i, "coupon_amt", ld_coupon_amt)
	dw_body.Setitem(i, "mobile_amt", ld_mobile_amt)
	dw_body.Setitem(i, "use_amt", ld_use_amt)
	dw_body.Setitem(i, "total_use", ld_total_use)
	dw_body.Setitem(i, "ship_charge", ld_ship_charge)
	dw_body.Setitem(i, "shop_cd", ls_shop_cd)
	dw_body.Setitem(i, "sale_ymd", ls_sale_ymd)
	dw_body.Setitem(i, "s_shop_type", ls_s_shop_type)
	dw_body.Setitem(i, "sale_no", ls_sale_no)
	dw_body.Setitem(i, "s_no", ls_s_no)
	dw_body.Setitem(i, "rtrn_sale_ymd", ls_rtrn_sale_ymd)
	dw_body.Setitem(i, "r_shop_type", ls_r_shop_type)
	dw_body.Setitem(i, "rtrn_no", ls_rtrn_no)
	dw_body.Setitem(i, "r_no",  ls_r_no)
	dw_body.Setitem(i, "reg_id", gs_user_id)
	dw_body.Setitem(i, "reg_dt", ld_datetime)
NEXT

	il_rows = dw_body.Update(TRUE, FALSE)
	
	if il_rows = 1 then
		dw_body.ResetUpdate()
		commit  USING SQLCA;
		messagebox('확인!','월정산 처리가 완료 되었습니다!')
	else
		rollback  USING SQLCA;
	end if
*/



This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_3.dw_3, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_4.mle_1, "ScaleToRight&Bottom")

tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)

dw_sale.SetTransObject(SQLCA)
dw_rtrn.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)
end event

event ue_excel();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

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
Choose Case Tab_1.SelectedTab
	Case 1
		li_ret = Tab_1.TabPage_1.dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 2
		li_ret = Tab_1.TabPage_2.dw_2.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 3
		li_ret = Tab_1.TabPage_3.dw_3.SaveAs(ls_doc_nm, Excel!, TRUE)
End Choose

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
			cb_update.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

//      if al_rows >= 0 then
//         ib_changed = false
//         cb_update.enabled = false
//      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
		cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event open;call super::open;string ls_yymm, ls_brand

select convert(varchar(6), dateadd(mm,-1,getdate()),112)
  into :ls_yymm
  from dual;

dw_head.setitem(1,'fr_ymd',ls_yymm+'01')
dw_head.setitem(1,'to_ymd',ls_yymm+'31')

ls_brand = dw_head.getitemstring(1, 'brand')

select count(order_no) 
into :ii_insert_data
from tb_45040_insert
where yymm = :ls_yymm
		and brand = :ls_brand;
		
if ii_insert_data < 1 then
	cb_1.enabled = false
else 
	cb_1.enabled = true
end if

end event

type cb_close from w_com010_d`cb_close within w_47014_d
end type

type cb_delete from w_com010_d`cb_delete within w_47014_d
end type

type cb_insert from w_com010_d`cb_insert within w_47014_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_47014_d
end type

type cb_update from w_com010_d`cb_update within w_47014_d
integer width = 439
boolean enabled = true
string text = "월정산마감(&S)"
end type

type cb_print from w_com010_d`cb_print within w_47014_d
end type

type cb_preview from w_com010_d`cb_preview within w_47014_d
end type

type gb_button from w_com010_d`gb_button within w_47014_d
end type

type cb_excel from w_com010_d`cb_excel within w_47014_d
end type

type dw_head from w_com010_d`dw_head within w_47014_d
integer x = 5
integer y = 160
integer width = 4114
integer height = 192
string dataobject = "d_47014_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001') 
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '%')
ldw_child.SetItem(1, "inter_nm", '전체')


// 해당 브랜드 선별작업 
/*
String   ls_filter_str = ''	

	ls_filter_str = "b_shop_stat = '00'" 
	idw_shop_cd.SetFilter(ls_filter_str)
	idw_shop_cd.Filter( )
*/
end event

event dw_head::itemchanged;call super::itemchanged;String ls_yymmdd

lb_ret_chk1 = False
lb_ret_chk2 = False
lb_ret_chk3 = False


CHOOSE CASE dwo.name

	CASE "style"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_47014_d
integer beginy = 360
integer endy = 360
end type

type ln_2 from w_com010_d`ln_2 within w_47014_d
integer beginy = 364
integer endy = 364
end type

type dw_body from w_com010_d`dw_body within w_47014_d
boolean visible = false
integer x = 658
integer y = 436
integer width = 1819
integer height = 1076
string dataobject = "d_47014_d04"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_47014_d
integer x = 183
integer y = 340
string dataobject = "d_47014_r01"
end type

type tab_1 from tab within w_47014_d
integer x = 9
integer y = 368
integer width = 3584
integer height = 1624
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
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
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

event selectionchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
int net

If oldindex > 0 Then	
	/* dw_head 필수입력 column check */
	IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
			Choose Case newindex
				Case 1
					ii_index = 1
					cb_1.enabled = true
					If lb_ret_chk1 = False Then

						if ii_insert_data > 0 then
							net = MessageBox("확인", '당월 정산 임시 데이터가 있습니다! 조회 하시겠습니까?', Question!, YesNo! )
							if net = 1 then
								tab_1.tabpage_1.dw_1.dataobject = 'd_47014_d07'
								tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
							else
								tab_1.tabpage_1.dw_1.dataobject = 'd_47014_d01'
								tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)		
							end if
						end if
	
						il_rows = This.Tabpage_1.dw_1.Retrieve(is_fr_ymd, is_to_ymd, is_brand, is_style, is_chno, is_gubn, is_order_stat, is_stat )
						lb_ret_chk1 = True
					End If
				Case 2					
					ii_index = 2
					cb_1.enabled = false
					If lb_ret_chk2 = False Then
						il_rows = This.Tabpage_2.dw_2.Retrieve(is_fr_ymd, is_to_ymd, is_brand, is_style, is_chno, is_gubn, is_order_stat, is_stat )
						lb_ret_chk2 = True
					End If
				Case 3
					ii_index = 3
					cb_1.enabled = false
					If lb_ret_chk3 = False Then
						il_rows = This.Tabpage_3.dw_3.Retrieve(is_fr_ymd, is_to_ymd, is_brand, is_style, is_chno, is_gubn, is_order_stat, is_stat )
						lb_ret_chk3 = True
					End If
				Case 4
					ii_index = 4
					cb_1.enabled = false
					This.Tabpage_4.mle_1.text = "1. 라운지비의 정산은 메이크샵 판매분을 본사 전산의 판매/반품에 맞춰 정상하는 방식이다.~r~n~r~n~r~n" + & 
					                            "2. [ 항목설명 ]~r~n~r~n" + & 
														 "   ① 영업관리 판매가 : 영업관리판매가~r~n~r~n" + & 
														 "   ② 몰 판매가 : 입점몰 파일등록의 판매가~r~n~r~n" + & 
														 "   ③ 차액 : 몰판매가 - 영업관리판매가~r~n~r~n" + & 
														 "   ④ 결제금액 : 몰판매가 - (회원등급할인액+쿠폰할인금액+모바일할인금액+사용한적립금)~r~n~r~n" + & 
														 "   ⑤ 실결제가 : MAKE_SHOP 판매가격 - (회원등급할인액+쿠폰할인금액+모바일할인금액+사용한적립금)~r~n~r~n" + & 
														 "   ⑥ 차액 : ⑤ 실결제가 - ④ 결제금액~r~n~r~n" + & 
														 "   ⑦ 회원등급할인액 : 회원등급할인액~r~n~r~n" + & 
														 "   ⑧ 쿠폰 할인금액 : 쿠폰 할인금액~r~n~r~n" + & 
														 "   ⑨ 모바일 할인금액 : 모바일 할인금액~r~n~r~n" + & 
														 "   ⑩ 사용한 적립금 : 사용한 적립금~r~n~r~n" + & 
														 "   ⑪ 합계 : 회원등급할인액 + 쿠폰할인금액 + 모바일할인금액 + 사용한적립금~r~n~r~n" + & 
														 "   ⑫ 배송료 : 배송료~r~n~r~n~r~n" + & 
														 "3. [ 부분환불 ]~r~n~r~n" + &
														 "   order id기준으로 부분환불시 판매시에 사용한 use_amt가 있을경우 마감처리한 데이터에서 ~r~n~r~n" + & 
														 "   use_amt를 가져다가 소트순번에 따른 데이터에 사용한 금액*-1 + 당월 사용된use_amt를 더해서 입력한다. ~r~n~r~n" + & 
														 "   ex) 판매 A a1  use_amt 20000원 사용 ~r~n~r~n" + & 
														 "              a2  use_amt     0원 사용 ~r~n~r~n" + & 
														 "              a3  use_amt     0원 사용 ~r~n~r~n" + & 
														 "       반품 A a3  use_amt 13000원 사용 ~r~n~r~n" + & 
														 "   결과: 판매시 (20000원 * -1) + 13000원 = -7000원으로 소트순서에 맞게 넣어줌.~r~n~r~n~r~n" + & 
														 "4. [ 작업방법 ]~r~n~r~n" + &
														 "   ① 메이크샵 내려받은 정산파일을 22.정산 데이터 입력(W_47013_E)에서 입력한다.~r~n~r~n" + & 
														 "   ② 브랜드별로 기초데이터 조회를 한후 임시데이터 생성을 한다.~r~n~r~n" + & 
														 "   ③ 임시데이터 조회를 하여 수정을 하고 임시데이터 저장을 한다.~r~n~r~n" + & 
														 "   ④ 더이상 수정할 데이터가 없을 경우 월정산마감을 하여 최총 파일을 만든다."



			End Choose

End If

end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3547
integer height = 1512
long backcolor = 79741120
string text = "정상"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within tabpage_1
integer y = 12
integer width = 3543
integer height = 1480
integer taborder = 20
string title = "none"
string dataobject = "d_47014_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;gf_tSort(tab_1.tabpage_1.dw_1)

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)
end event

event doubleclicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
String 	ls_order_no, ls_gubn, ls_shop_cd, ls_sale_ymd, ls_s_shop_type, ls_sale_no, ls_s_no, ls_rtrn_sale_ymd, ls_r_shop_type, ls_rtrn_no, ls_r_no

tab_1.tabpage_1.dw_1.accepttext()
ls_order_no 		= tab_1.tabpage_1.dw_1.GetItemString(getrow(),'order_no')
ls_gubn 				= tab_1.tabpage_1.dw_1.GetItemString(getrow(),'gubn')
ls_shop_cd			= tab_1.tabpage_1.dw_1.GetItemString(getrow(),'shop_cd')
ls_sale_ymd			= tab_1.tabpage_1.dw_1.GetItemString(getrow(),'sale_ymd')
ls_s_shop_type		= tab_1.tabpage_1.dw_1.GetItemString(getrow(),'s_shop_type')
ls_sale_no			= tab_1.tabpage_1.dw_1.GetItemString(getrow(),'sale_no')
ls_s_no				= tab_1.tabpage_1.dw_1.GetItemString(getrow(),'s_no')
ls_rtrn_sale_ymd	= tab_1.tabpage_1.dw_1.GetItemString(getrow(),'rtrn_sale_ymd')
ls_r_shop_type		= tab_1.tabpage_1.dw_1.GetItemString(getrow(),'r_shop_type')
ls_rtrn_no			= tab_1.tabpage_1.dw_1.GetItemString(getrow(),'rtrn_no')
ls_r_no				= tab_1.tabpage_1.dw_1.GetItemString(getrow(),'r_no')



	


choose case dwo.name
	case 'order_no'
		if ls_gubn = '판매' then
			dw_sale.visible = true
			dw_rtrn.visible = false
			dw_sale.reset()
			dw_sale.retrieve(ls_order_no, ls_shop_cd, ls_sale_ymd, ls_s_shop_type, ls_sale_no, ls_s_no)
		elseif ls_gubn = '반품' then
			dw_sale.visible = false
			dw_rtrn.visible = true
			dw_rtrn.reset()
			dw_rtrn.retrieve(ls_order_no, ls_shop_cd, ls_rtrn_sale_ymd, ls_r_shop_type, ls_rtrn_no, ls_r_no)
		end if
	

		

end choose	


end event

event itemchanged;long ll_goods_amt, ll_coupon_amt, ll_mobile_amt, ll_use_amt, ll_total_use, ll_sale_price, ll_make_sale_amt, ll_sil_amt

CHOOSE CASE dwo.name
	CASE "goods_amt", "coupon_amt", "mobile_amt", "use_amt"
		tab_1.tabpage_1.dw_1.accepttext()
		ll_goods_amt  = this.getitemnumber(row, "goods_amt")		
		ll_coupon_amt = this.getitemnumber(row, "coupon_amt")	
		ll_mobile_amt = this.getitemnumber(row, "mobile_amt")			
		ll_use_amt    = this.getitemnumber(row, "use_amt")	
		ll_sale_price = this.getitemnumber(row, "sale_price")	
		
		if isnull(ll_goods_amt) or ll_goods_amt = 0 then
			ll_goods_amt = 0
		end if
		if isnull(ll_coupon_amt) or ll_coupon_amt = 0 then
			ll_coupon_amt = 0
		end if
		if isnull(ll_mobile_amt) or ll_mobile_amt = 0 then
			ll_mobile_amt = 0
		end if		
		if isnull(ll_use_amt) or ll_use_amt = 0 then
			ll_use_amt = 0
		end if
		if isnull(ll_sale_price) or ll_sale_price = 0 then
			ll_sale_price = 0
		end if
		
		ll_total_use = ll_goods_amt+ll_coupon_amt+ll_mobile_amt+ll_use_amt
		this.setitem(row,'total_use', ll_total_use)
		
		this.setitem(row,'make_sale_amt', ll_sale_price - ll_total_use)
		this.setitem(row,'sil_amt', ll_sale_price - ll_total_use)
		
		ll_make_sale_amt = this.getitemnumber(row, "make_sale_amt")
		ll_sil_amt = this.getitemnumber(row, "sil_amt")
		
		this.setitem(row,'cha_amt_2', ll_make_sale_amt - ll_sil_amt)
		
		
		
		
END CHOOSE

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3547
integer height = 1512
long backcolor = 79741120
string text = "영업관리누락"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_2
integer y = 12
integer width = 3543
integer height = 1480
integer taborder = 20
string title = "none"
string dataobject = "d_47014_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;gf_tSort(tab_1.tabpage_2.dw_2)
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3547
integer height = 1512
long backcolor = 79741120
string text = "메이크샵누락"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from datawindow within tabpage_3
integer y = 12
integer width = 3543
integer height = 1480
integer taborder = 20
string title = "none"
string dataobject = "d_47014_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;gf_tSort(tab_1.tabpage_3.dw_3)
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3547
integer height = 1512
long backcolor = 79741120
string text = "정산개요"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
mle_1 mle_1
end type

on tabpage_4.create
this.mle_1=create mle_1
this.Control[]={this.mle_1}
end on

on tabpage_4.destroy
destroy(this.mle_1)
end on

type mle_1 from multilineedit within tabpage_4
integer y = 4
integer width = 3547
integer height = 1504
integer taborder = 110
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type dw_pass from datawindow within w_47014_d
boolean visible = false
integer x = 1847
integer y = 756
integer width = 1152
integer height = 248
integer taborder = 110
boolean bringtotop = true
boolean titlebar = true
string title = "PASS 입력"
string dataobject = "d_47014_pass"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;dw_pass.accepttext()

if dw_pass.getitemstring(1,'pass') <> '135790' then
	messagebox('오류!','비밀번호가 틀립니다. 확인후 다시 입력해 주세요!')
	return 0
else
	dw_pass.reset()
	dw_pass.visible = false	
end if

cb_retrieve.enabled = true
cb_1.enabled = true
cb_update.TriggerEvent(Clicked!)


end event

type cb_1 from commandbutton within w_47014_d
integer x = 32
integer y = 44
integer width = 439
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "월정산마감"
end type

event clicked;string ls_order_id

ls_order_id			 = tab_1.tabpage_1.dw_1.getitemstring(1,"order_id")

if isnull(ls_order_id) or ls_order_id = '' then
	messagebox('정산확인!','정산할 파일을 조회후 처리 하세요!')
	return 
end if

dw_pass.SetTransObject(SQLCA)
dw_pass.visible = true
dw_pass.insertrow(0)
	

	if dw_pass.visible = true then
		cb_print.enabled = false
		cb_preview.enabled = false
		cb_excel.enabled = false
		cb_update.enabled = false
		cb_retrieve.enabled = false
		cb_1.enabled = false
		dw_head.Enabled = false
		dw_body.Enabled = false
		dw_pass.SetFocus()
	else
		cb_print.enabled = true
		cb_preview.enabled = true
		cb_excel.enabled = true
		cb_update.enabled = true
		cb_retrieve.enabled = true
		cb_1.enabled = true
		dw_head.Enabled = false
		
		dw_body.Enabled = true
	end if

end event

type dw_sale from datawindow within w_47014_d
boolean visible = false
integer x = 192
integer y = 836
integer width = 3337
integer height = 940
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "판매내역"
string dataobject = "d_47014_D05"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;datawindowchild ldw_proc_stat, ldw_color

This.GetChild("proc_stat", ldw_proc_stat)
ldw_proc_stat.SetTransObject(SQLCA)
ldw_proc_stat.Retrieve('043')


This.GetChild("color", ldw_color)
ldw_color.SetTransObject(SQLCA)
ldw_color.retrieve('%')

end event

type dw_rtrn from datawindow within w_47014_d
boolean visible = false
integer x = 192
integer y = 836
integer width = 3337
integer height = 940
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "반품내역"
string dataobject = "d_47014_D06"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;datawindowchild ldw_proc_stat, ldw_rtrn_stat, ldw_rtrn_reason, ldw_rtrn_reason_detail, ldw_rtrn_reason_detail_b, ldw_color

This.GetChild("proc_stat", ldw_proc_stat)
ldw_proc_stat.SetTransObject(SQLCA)
ldw_proc_stat.Retrieve('043')

This.GetChild("rtrn_stat", ldw_rtrn_stat)
ldw_rtrn_stat.SetTransObject(SQLCA)
ldw_rtrn_stat.Retrieve('044')

This.GetChild("rtrn_reason", ldw_rtrn_reason)
ldw_rtrn_reason.SetTransObject(SQLCA)
ldw_rtrn_reason.Retrieve('045')

This.GetChild("rtrn_reason_detail", ldw_rtrn_reason_detail_b)
ldw_rtrn_reason_detail_b.SetTransObject(SQLCA)
ldw_rtrn_reason_detail_b.Retrieve('046', '%')
ldw_rtrn_reason_detail_b.InsertRow(0)

This.GetChild("color", ldw_color)
ldw_color.SetTransObject(SQLCA)
ldw_color.retrieve('%')


end event

type cb_2 from commandbutton within w_47014_d
integer x = 946
integer y = 44
integer width = 466
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "임시데이터 생성"
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count,li_cnt_err, ll_row_count_1
string ls_style_chk, ls_yymm
datetime ld_datetime
string ls_brand, ls_shop_nm, ls_order_id, ls_order_no, ls_stat, ls_gubn, ls_payment_stat, ls_payment_method, ls_order_stat, ls_sale_ymd, ls_invoice, ls_style_no, ls_m_style, ls_ord_ymd
decimal ld_qty, ld_sale_qty, ld_erp_sale_amt, ld_make_sale_amt, ld_goods_amt, ld_coupon_amt, ld_use_amt, ld_ship_charge, ld_sale_price, ld_cha_amt_1, ld_sil_amt, ld_cha_amt_2, ld_total_use, ld_mobile_amt
string ls_shop_cd, ls_s_shop_type, ls_sale_no, ls_s_no, ls_rtrn_sale_ymd, ls_r_shop_type, ls_rtrn_no, ls_r_no


ll_row_count = tab_1.tabpage_1.dw_1.RowCount()

IF tab_1.tabpage_1.dw_1.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_yymm = MidA(dw_head.getitemstring(1,"fr_ymd"),1,6)

dw_insert.reset()
		
if ll_row_count >= 1 then
	if ii_insert_data > 0 then
		if MessageBox("확인", ls_yymm + '월 정산 임시 데이터가 있습니다! 재 처리 하시겠습니까 ?', Question!, YesNo! ) = 2 then
			return 0 
		end if

		delete
		from tb_45040_insert
		where yymm = :ls_yymm 
		and brand = :is_brand;
		commit  USING SQLCA;
		
	end if
	
	if ii_insert_data <= 0 then
		if MessageBox("확인", "월 정산 임시 데이터를 생성 하시겠습니까 ?", Question!, YesNo! ) = 2 then
			RETURN 0 
		end if
	end if
else 
	return 0
end if

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

tab_1.tabpage_1.dw_1.dataobject = 'd_47014_d01'
tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)	
tab_1.tabpage_1.dw_1.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_style, is_chno, is_gubn, is_order_stat, is_stat )
//tab_1.tabpage_1.dw_1.retrieve(is_fr_ymd, is_to_ymd, is_brand, '%', '%', '%', '%', '%' )
		
FOR i=1 TO ll_row_count
	
	ls_brand				 = MidA(tab_1.tabpage_1.dw_1.getitemstring(i,"shop_cd"),1,1)
	ls_shop_nm			 = tab_1.tabpage_1.dw_1.getitemstring(i,"shop_nm")
	ls_order_id			 = tab_1.tabpage_1.dw_1.getitemstring(i,"order_id")
	ls_order_no			 = tab_1.tabpage_1.dw_1.getitemstring(i,"order_no")
	ls_stat				 = tab_1.tabpage_1.dw_1.getitemstring(i,"stat")
	ls_gubn				 = tab_1.tabpage_1.dw_1.getitemstring(i,"gubn")
	ls_payment_stat	 = tab_1.tabpage_1.dw_1.getitemstring(i,"payment_stat")
	ls_payment_method	 = tab_1.tabpage_1.dw_1.getitemstring(i,"payment_method")
	ls_order_stat		 = tab_1.tabpage_1.dw_1.getitemstring(i,"order_stat")
	ls_ord_ymd			 = tab_1.tabpage_1.dw_1.getitemstring(i,"ord_ymd")
	ls_invoice			 = tab_1.tabpage_1.dw_1.getitemstring(i,"invoice")
	ls_style_no			 = tab_1.tabpage_1.dw_1.getitemstring(i,"style_no")
	ls_m_style			 = tab_1.tabpage_1.dw_1.getitemstring(i,"m_style")
	ld_qty				 = tab_1.tabpage_1.dw_1.getitemnumber(i,"qty")
	ld_sale_qty			 = tab_1.tabpage_1.dw_1.getitemnumber(i,"sale_qty")	
	ld_erp_sale_amt	 = tab_1.tabpage_1.dw_1.getitemnumber(i,"erp_sale_amt")	
	ld_sale_price		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"sale_price")
	ld_cha_amt_1		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"cha_amt_1")	
	ld_make_sale_amt	 = tab_1.tabpage_1.dw_1.getitemnumber(i,"make_sale_amt")
	ld_sil_amt			 = tab_1.tabpage_1.dw_1.getitemnumber(i,"sil_amt")
	ld_cha_amt_2		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"cha_amt_2")
	ld_goods_amt		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"goods_amt")
	ld_coupon_amt		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"coupon_amt")
	ld_mobile_amt		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"mobile_amt")
	ld_use_amt			 = tab_1.tabpage_1.dw_1.getitemnumber(i,"use_amt")
	ld_total_use		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"total_use")
	ld_ship_charge		 = tab_1.tabpage_1.dw_1.getitemnumber(i,"ship_charge")	
	ls_shop_cd			 = tab_1.tabpage_1.dw_1.getitemstring(i,"shop_cd")
	ls_sale_ymd			 = tab_1.tabpage_1.dw_1.getitemstring(i,"sale_ymd")
	ls_s_shop_type		 = tab_1.tabpage_1.dw_1.getitemstring(i,"s_shop_type")
	ls_sale_no			 = tab_1.tabpage_1.dw_1.getitemstring(i,"sale_no")
	ls_s_no				 = tab_1.tabpage_1.dw_1.getitemstring(i,"s_no")
	ls_rtrn_sale_ymd	 = tab_1.tabpage_1.dw_1.getitemstring(i,"rtrn_sale_ymd")
	ls_r_shop_type		 = tab_1.tabpage_1.dw_1.getitemstring(i,"r_shop_type")
	ls_rtrn_no			 = tab_1.tabpage_1.dw_1.getitemstring(i,"rtrn_no")
	ls_r_no				 = tab_1.tabpage_1.dw_1.getitemstring(i,"r_no")

	dw_insert.insertrow(0)
	dw_insert.Setitem(i, "yymm", ls_yymm)
	dw_insert.Setitem(i, "brand", ls_brand)
	dw_insert.Setitem(i, "shop_nm", ls_shop_nm)
	dw_insert.Setitem(i, "order_id", ls_order_id)
	dw_insert.Setitem(i, "order_no", ls_order_no)
	dw_insert.Setitem(i, "stat", ls_stat)
	dw_insert.Setitem(i, "gubn", ls_gubn)
	dw_insert.Setitem(i, "payment_stat", ls_payment_stat)
	dw_insert.Setitem(i, "payment_method", ls_payment_method)
	dw_insert.Setitem(i, "order_stat", ls_order_stat)
	dw_insert.Setitem(i, "ord_ymd", ls_ord_ymd)
	dw_insert.Setitem(i, "invoice", ls_invoice)
	dw_insert.Setitem(i, "style_no", ls_style_no)
	dw_insert.Setitem(i, "m_style", ls_m_style)
	dw_insert.Setitem(i, "qty", ld_qty)
	dw_insert.Setitem(i, "sale_qty", ld_sale_qty)	
	dw_insert.Setitem(i, "erp_sale_amt", ld_erp_sale_amt)	
	dw_insert.Setitem(i, "sale_price", ld_sale_price)
	dw_insert.Setitem(i, "cha_amt_1", ld_cha_amt_1)
	dw_insert.Setitem(i, "make_sale_amt", ld_make_sale_amt)
	dw_insert.Setitem(i, "sil_amt", ld_sil_amt)
	dw_insert.Setitem(i, "cha_amt_2", ld_cha_amt_2)	
	dw_insert.Setitem(i, "goods_amt", ld_goods_amt)
	dw_insert.Setitem(i, "coupon_amt", ld_coupon_amt)
	dw_insert.Setitem(i, "mobile_amt", ld_mobile_amt)
	dw_insert.Setitem(i, "use_amt", ld_use_amt)
	dw_insert.Setitem(i, "total_use", ld_total_use)
	dw_insert.Setitem(i, "ship_charge", ld_ship_charge)
	dw_insert.Setitem(i, "shop_cd", ls_shop_cd)
	dw_insert.Setitem(i, "sale_ymd", ls_sale_ymd)
	dw_insert.Setitem(i, "s_shop_type", ls_s_shop_type)
	dw_insert.Setitem(i, "sale_no", ls_sale_no)
	dw_insert.Setitem(i, "s_no", ls_s_no)
	dw_insert.Setitem(i, "rtrn_sale_ymd", ls_rtrn_sale_ymd)
	dw_insert.Setitem(i, "r_shop_type", ls_r_shop_type)
	dw_insert.Setitem(i, "rtrn_no", ls_rtrn_no)
	dw_insert.Setitem(i, "r_no",  ls_r_no)
	dw_insert.Setitem(i, "reg_id", gs_user_id)
	dw_insert.Setitem(i, "reg_dt", ld_datetime)
NEXT

	il_rows = dw_insert.Update(TRUE, FALSE)
	
	if il_rows = 1 then
		dw_insert.ResetUpdate()
		commit  USING SQLCA;
		messagebox('확인!','임시 데이터 생성이 완료 되었습니다!')
		
		select count(order_no) 
		into :ii_insert_data
		from tb_45040_insert with (nolock)
		where yymm = substring(:is_fr_ymd,1,6)
				and brand = :is_brand;
				
		if ii_insert_data >= 1 then
			tab_1.tabpage_1.dw_1.dataobject = 'd_47014_d07'
			tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)			
		elseif ii_insert_data < 1 then
			tab_1.tabpage_1.dw_1.dataobject = 'd_47014_d01'
			tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)			
		end if
		tab_1.tabpage_1.dw_1.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_style, is_chno, is_gubn, is_order_stat, is_stat )
	else
		rollback  USING SQLCA;
	end if


//This.Trigger Event ue_button(3, il_rows)
//This.Trigger Event ue_msg(3, il_rows)
//return il_rows

end event

type dw_insert from datawindow within w_47014_d
boolean visible = false
integer x = 2103
integer y = 572
integer width = 1079
integer height = 840
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_47014_d07"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_4 from commandbutton within w_47014_d
integer x = 475
integer y = 44
integer width = 466
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "임시데이터 저장"
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, li_cnt_err, ll_cnt, ll_row_count_1
string ls_style_chk, ls_yymm
datetime ld_datetime
string ls_brand, ls_shop_nm, ls_order_id, ls_order_no, ls_stat, ls_gubn, ls_payment_stat, ls_payment_method, ls_order_stat, ls_sale_ymd, ls_invoice, ls_style_no, ls_m_style, ls_ord_ymd
decimal ld_qty, ld_sale_qty, ld_erp_sale_amt, ld_make_sale_amt, ld_goods_amt, ld_coupon_amt, ld_use_amt, ld_ship_charge, ld_sale_price, ld_cha_amt_1, ld_sil_amt, ld_cha_amt_2, ld_total_use, ld_mobile_amt
string ls_shop_cd, ls_s_shop_type, ls_sale_no, ls_s_no, ls_rtrn_sale_ymd, ls_r_shop_type, ls_rtrn_no, ls_r_no

IF tab_1.tabpage_1.dw_1.AcceptText() <> 1 THEN RETURN -1

if tab_1.tabpage_1.dw_1.RowCount() = 0 then return -1

 
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

	il_rows = tab_1.tabpage_1.dw_1.Update(TRUE, FALSE)
	
	if il_rows = 1 then
		dw_insert.ResetUpdate()
		commit  USING SQLCA;
		messagebox('확인!','임시 데이터가 저장 되었습니다!')
	else
		rollback  USING SQLCA;
	end if


//This.Trigger Event ue_button(3, il_rows)
//This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

