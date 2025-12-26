$PBExportHeader$w_71029_e.srw
$PBExportComments$상품권지급
forward
global type w_71029_e from w_com010_e
end type
end forward

global type w_71029_e from w_com010_e
end type
global w_71029_e w_71029_e

type variables
String is_brand, is_jumin , is_card_no, is_tel_no3, is_give_date, is_shop_cd
datawindowchild  idw_brand

end variables

forward prototypes
public function boolean uf_cust_name_chk (string as_user_name, ref string as_user_name2, ref string as_jumin, ref string as_card_no, ref string as_tel_no3)
public function boolean uf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name, ref string as_card_no)
public function boolean uf_cust_card_chk (string as_card_no, ref string as_jumin, ref string as_user_name, ref string as_tel_no3)
public function boolean uf_cust_jumin_chk (string as_jumin, ref string as_user_name, ref string as_card_no, ref string as_tel_no3)
public function boolean uf_coupon_no_chk (string as_coupon_no)
end prototypes

public function boolean uf_cust_name_chk (string as_user_name, ref string as_user_name2, ref string as_jumin, ref string as_card_no, ref string as_tel_no3);/*============================================================*/
/* 작 성 자  : 지우정보(김영일)                               */
/* 작 성 일  : 2002/02/18                                     */
/* 수 정 일  : 2002/02/18                                     */
/* 내    용  : 회원이 있는지 체크한다.                        */
/*============================================================*/
long ls_cnt

SELECT count(jumin)
INTO  :ls_cnt
FROM TB_71010_M
WHERE user_name like :as_user_name + "%";

IF ls_cnt <> 1 Then 
	RETURN False
//elseIF ls_cnt > 1 Then 
//	RETURN False	
ELSE
	SELECT user_name,jumin,card_no,tel_no3
	INTO  :as_user_name2,:as_jumin,:as_card_no, :as_tel_no3
	FROM TB_71010_M
	WHERE user_name like :as_user_name + "%";
	RETURN True
END IF


end function

public function boolean uf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name, ref string as_card_no);int li_cnt
	select jumin, user_name, card_no
		into :as_jumin, :as_user_name, :as_card_no
	from tb_71010_m (nolock) 
	where replace(tel_no3,'-','') = replace(:as_tel_no,'-','');


	select count(jumin)
		into :li_cnt
	from tb_71010_m (nolock) 
	where replace(tel_no3,'-','') = replace(:as_tel_no,'-','');


	if li_cnt <> 1 or isnull(as_jumin) or LenA(as_jumin) <> 13 then 
		return False
	else 
		return True
	end if
	

end function

public function boolean uf_cust_card_chk (string as_card_no, ref string as_jumin, ref string as_user_name, ref string as_tel_no3);/*============================================================*/
/* 작 성 자  : 지우정보(김영일)                               */
/* 작 성 일  : 2002/02/18                                     */
/* 수 정 일  : 2002/02/18                                     */
/* 내    용  : 회원이 있는지 체크한다.                        */
/*============================================================*/
SELECT isnull(max(JUMIN),""), isnull(max(USER_NAME),""), isnull(max(tel_no3),"")
  INTO :as_jumin, :as_user_name, :as_tel_no3
  FROM TB_71010_M
 WHERE CARD_NO like :as_card_no;

IF isnull(as_jumin) or as_jumin = "" Then
	RETURN False 
ELSE
	RETURN True 
END IF	


end function

public function boolean uf_cust_jumin_chk (string as_jumin, ref string as_user_name, ref string as_card_no, ref string as_tel_no3);/*============================================================*/
/* 작 성 자  : 지우정보(김영일)                               */
/* 작 성 일  : 2002/02/18                                     */
/* 수 정 일  : 2002/02/18                                     */
/* 내    용  : 회원이 있는지 체크한다.                        */
/*============================================================*/
SELECT isnull(max(USER_NAME),""),isnull(max(CARD_NO),""),isnull(max(tel_no3),"")
INTO  :as_user_name,:as_card_no, :as_tel_no3
FROM TB_71010_M
WHERE JUMIN = :as_jumin;

IF isnull(as_card_no) or as_card_no = "" Then
	RETURN False	
ELSE
	RETURN True
END IF	


end function

public function boolean uf_coupon_no_chk (string as_coupon_no);string ls_give_coupon_no

select   coupon_no 
into		:ls_give_coupon_no 
from	   tb_71019_h 
where    coupon_no = :as_coupon_no;

if       as_coupon_no = ls_give_coupon_no then
	      messagebox('확인', '이미지급된 쿠폰번호 입니다')
			
		   return 	true
end if
		



return  false
end function

event ue_insert();/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_give_date 
datetime ld_datetime

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF




il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

select card_no
into   :is_card_no
from	 tb_71010_m (nolock)
where  jumin = :is_jumin;


dw_body.Setitem(il_rows,"jumin", is_jumin)
dw_body.Setitem(il_rows,"give_date", is_give_date)
dw_body.Setitem(il_rows,"point_seq", il_rows)
dw_body.Setitem(il_rows,"card_no", is_card_no)
dw_body.Setitem(il_rows,"give_amt", 10000)
dw_body.Setitem(il_rows,"accept_flag", 'N')


This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2001.02.18                                                  */
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

is_jumin = dw_head.GetItemString(1, "jumin")
is_card_no = dw_head.GetItemString(1, "card_no")
is_tel_no3 = dw_head.GetItemString(1, "tel_no3")
is_give_date = dw_head.GetItemString(1, "give_date")

is_brand = dw_head.GetItemString(1, "brand")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")




if  is_jumin = '' or isnull(is_jumin)  then
	 messagebox('경고', '주민번호를 등록 하시오')
	 return false
end if

if  is_brand = '' or isnull(is_brand)  then
	 messagebox('경고', '브랜드를 등록 하시오')
	 return false
end if

if  is_shop_cd = '' or isnull(is_shop_cd)  then
	 messagebox('경고', '매장을 등록 하시오')
	 return false
end if


return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.04.06(김태범)                                          */
/*===========================================================================*/
String     ls_jumin, ls_user_name, ls_card_no, ls_add_name
String     ls_shop_nm, ls_zipcode, ls_addr, ls_area_cd, ls_tel_no3  
Boolean    lb_check 
DataStore  lds_Source



CHOOSE CASE as_column
	CASE "jumin"	
			if isnull(as_data) or as_data = '' then return 0
			IF ai_div = 1 THEN 	
				IF uf_cust_jumin_chk(as_data, ls_user_name, ls_card_no, ls_tel_no3) = TRUE THEN
				   dw_head.SetItem(al_row, "user_name", ls_user_name)
				   dw_head.SetItem(al_row, "card_no", RightA(ls_card_no,9))
					dw_head.SetItem(al_row, "tel_no3", ls_tel_no3)
					is_jumin = dw_head.GetItemString(1, "jumin")
					is_card_no = dw_head.GetItemString(1, "card_no")
					is_tel_no3 = dw_head.GetItemString(1, "tel_no3")
					RETURN 0
				ELSEIF LenA(Trim(as_data)) = 13 THEN
					IF gf_jumin_chk(as_data) THEN 
				      dw_head.SetItem(al_row, "user_name", "")
				      dw_head.SetItem(al_row, "card_no", "")
					   Return 0
					ELSE
						MessageBox("오류", "주민번호가 잘못되여 있습니다!")
						Return 0 
					END IF
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where   = " jumin LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "jumin",     lds_Source.GetItemString(1,"jumin"))
				dw_head.SetItem(al_row, "user_name", lds_Source.GetItemString(1,"user_name"))
				dw_head.SetItem(al_row, "card_no",   RightA(lds_Source.GetItemString(1,"card_no"),9))
				dw_head.SetItem(al_row, "tel_no3", lds_Source.GetItemString(1,"tel_no3"))
				IF ai_div = 2 THEN 	
				   cb_retrieve.PostEvent(clicked!)
				END IF 
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "card_no"
			if isnull(as_data) or as_data = '' then return 0
			IF ai_div = 1 THEN 	
				IF uf_cust_card_chk('4870090'+ as_data, ls_jumin, ls_user_name,ls_tel_no3) = TRUE THEN
				   dw_head.SetItem(al_row, "user_name", ls_user_name)
				   dw_head.SetItem(al_row, "card_no",   RightA(Trim(as_data),9))			
				   dw_head.SetItem(al_row, "jumin",     ls_jumin)
					dw_head.SetItem(al_row, "tel_no3", ls_tel_no3)
					is_jumin = dw_head.GetItemString(1, "jumin")
					is_card_no = dw_head.GetItemString(1, "card_no")
					is_tel_no3 = dw_head.GetItemString(1, "tel_no3")
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where   = " card_no LIKE '" + '4870090'+as_data + "%'"
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
				dw_head.SetItem(al_row, "jumin",     lds_Source.GetItemString(1,"jumin"))
				dw_head.SetItem(al_row, "user_name", lds_Source.GetItemString(1,"user_name"))
				dw_head.SetItem(al_row, "card_no",   RightA(lds_Source.GetItemString(1,"card_no"),9))
				dw_head.SetItem(al_row, "tel_no3", lds_Source.GetItemString(1,"tel_no3"))
				IF ai_div = 2 THEN 	
				   cb_retrieve.PostEvent(clicked!)
				END IF 
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source

	CASE "user_name"				
			if isnull(as_data) or as_data = '' then return 0
			IF ai_div = 1 THEN
				IF uf_cust_name_chk(as_data, ls_user_name, ls_jumin, ls_card_no,ls_tel_no3) = TRUE THEN
				   dw_head.SetItem(al_row, "jumin", ls_jumin)
				   dw_head.SetItem(al_row, "card_no", RightA(ls_card_no,9))
					dw_head.SetItem(al_row, "tel_no3", ls_tel_no3)
					is_jumin = dw_head.GetItemString(1, "jumin")
					is_card_no = dw_head.GetItemString(1, "card_no")
					is_tel_no3 = dw_head.GetItemString(1, "tel_no3")
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where   = " user_name = '" + as_data + "'"
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
				dw_head.SetItem(al_row, "jumin",     lds_Source.GetItemString(1,"jumin"))
				dw_head.SetItem(al_row, "user_name", lds_Source.GetItemString(1,"user_name"))
				dw_head.SetItem(al_row, "card_no",   RightA(lds_Source.GetItemString(1,"card_no"),9))
				dw_head.SetItem(al_row, "tel_no3", lds_Source.GetItemString(1,"tel_no3"))
				IF ai_div = 2 THEN 	
				   cb_retrieve.PostEvent(clicked!)
				END IF 
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	
			
	CASE "tel_no3"
			IF ai_div = 1 THEN 	
				IF uf_chk_phone(as_data, ls_jumin,ls_user_name,ls_card_no) THEN
				   dw_head.SetItem(al_row, "user_name", ls_user_name)		
				   dw_head.SetItem(al_row, "jumin",     ls_jumin)
					dw_head.SetItem(al_row, "card_no", RightA(ls_card_no,9))
					is_jumin = dw_head.GetItemString(1, "jumin")
					is_card_no = dw_head.GetItemString(1, "card_no")
					is_tel_no3 = dw_head.GetItemString(1, "tel_no3")
					RETURN 0
				END IF 
			END IF
			
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where   = " replace(tel_no3,'-','') = replace('" + as_data + "','-','')"
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
				dw_head.SetItem(al_row, "jumin",     lds_Source.GetItemString(1,"jumin"))
				dw_head.SetItem(al_row, "user_name", lds_Source.GetItemString(1,"user_name"))
				dw_head.SetItem(al_row, "card_no",   RightA(lds_Source.GetItemString(1,"card_no"),9))
				dw_head.SetItem(al_row, "tel_no3", lds_Source.GetItemString(1,"tel_no3"))	 
				 
				IF ai_div = 2 THEN 	
				   cb_retrieve.PostEvent(clicked!)
				END IF 
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			
			Destroy  lds_Source
			
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
			gst_cd.default_where   = "WHERE  brand like '" + dw_head.object.brand[1]  +  "%'" + &
			                         "  AND  Shop_Stat = '00' " + &
											 "  AND  SHOP_DIV IN ('D', 'G', 'K') "			
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
//				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
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

on w_71029_e.create
call super::create
end on

on w_71029_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일) 												  */	
/* 작성일      : 2002.02.16																  */	
/* 수정일      : 2002.04.06(김 태범)													  */
/*===========================================================================*/
String   ls_birthday, ls_jumin
datetime ld_datetime
long		ll_total_point, ll_accept_point, ld_give_point, ll_cancel_point
long		ll_sale_amt, ll_coupon_cnt
string	ls_give_date



/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

select  sum(sale_amt - goods_amt) 
into	  :ll_sale_amt
from	  tb_53010_h with (nolock)
where   yymmdd = :is_give_date
and	  brand  = :is_brand
and	  jumin  = :is_jumin
and	  sale_type < '40';

if  IsNull(ll_sale_amt) then 
	 ll_sale_amt = 0
end if

if  ll_sale_amt = 0 then 
	 ll_coupon_cnt = 0
else
	ll_coupon_cnt =   Truncate(ll_sale_amt / 100000,0) 
end if


if ll_coupon_cnt >  0  and LenA(is_jumin) = 13 then 
	dw_head.object.text_message.text = "금일 매출로 상품권을  " + string(ll_coupon_cnt) + "장 지급할수 있습니다 !"
else 
	dw_head.object.text_message.text = ""
end if




il_rows = dw_body.retrieve(is_jumin, is_brand, is_give_date)




This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일) 												  */	
/* 작성일      : 2002.02.18																  */	
/* 수정일      : 2002.04.06(김 태범)    												  */
/*===========================================================================*/
long i, ll_row_count, ll_tot_coupon_amt, ll_sale_amt, ll_coupon_cnt
datetime ld_datetime
String   ls_addr, ls_zipcode, ls_give_date, ls_coupon_no, ls_yymmdd

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

is_jumin = dw_head.GetItemString(1, "jumin")
is_card_no = dw_head.GetItemString(1, "card_no")
is_tel_no3 = dw_head.GetItemString(1, "tel_no3")





select  yymmdd, sum(sale_amt - goods_amt) 
into	  :ls_yymmdd, :ll_sale_amt
from	  tb_53010_h with (nolock)
where   yymmdd = :is_give_date
and	  brand  = :is_brand
and	  jumin  = :is_jumin
and	  sale_type < '40'
group by yymmdd;

if  IsNull(ll_sale_amt) then 
	 ll_sale_amt = 0
end if

if  ll_sale_amt = 0 then 
	 ll_coupon_cnt = 0
else
	ll_coupon_cnt =   Truncate(ll_sale_amt / 100000,0) 
end if

if   ll_row_count  >  ll_coupon_cnt   then
     messagebox('확인', '상품권 지급할수 있는 매출이 안됩니다!')
	  return -1
end if



FOR i=1 TO ll_row_count
	ls_coupon_no = dw_body.getitemstring(i, "coupon_no")
 
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
			if uf_coupon_no_chk(ls_coupon_no) then 
				return -1
			end if
		dw_body.Setitem(i, "brand", is_brand)
      dw_body.Setitem(i, "reg_id", is_shop_cd)   /* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

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

event open;call super::open;datetime ld_datetime

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
END IF

is_give_date  = String(ld_datetime, "yyyymmdd")

dw_head.Setitem(1, "give_date", is_give_date)
dw_head.object.text_message.text = ""
end event

type cb_close from w_com010_e`cb_close within w_71029_e
end type

type cb_delete from w_com010_e`cb_delete within w_71029_e
end type

type cb_insert from w_com010_e`cb_insert within w_71029_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_71029_e
end type

type cb_update from w_com010_e`cb_update within w_71029_e
end type

type cb_print from w_com010_e`cb_print within w_71029_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_71029_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_71029_e
end type

type cb_excel from w_com010_e`cb_excel within w_71029_e
end type

type dw_head from w_com010_e`dw_head within w_71029_e
integer y = 156
integer height = 276
string dataobject = "d_71029_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.04.06(ktb)                                             */
/*===========================================================================*/
Long li_ret

CHOOSE CASE dwo.name
		CASE "jumin","card_no","tel_no3", "user_name", "shop_cd"
			SetPointer(HourGlass!)
			IF ib_itemchanged THEN RETURN 1
			IF Trim(Data) = "" THEN RETURN 0
			li_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1) 
			IF li_ret = 0 OR li_ret = 2 THEN 
				cb_retrieve.PostEvent(clicked!)
			END IF
			return li_ret
END CHOOSE

end event

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.01.18                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_e`ln_1 within w_71029_e
end type

type ln_2 from w_com010_e`ln_2 within w_71029_e
end type

type dw_body from w_com010_e`dw_body within w_71029_e
string dataobject = "d_71029_d01"
end type

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
//	CASE KeyDownArrow!
//		IF This.GetRow() = This.RowCount() THEN
//		   This.InsertRow(This.GetRow() + 1)
//		END IF
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

type dw_print from w_com010_e`dw_print within w_71029_e
end type

