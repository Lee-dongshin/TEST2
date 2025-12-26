$PBExportHeader$w_sh205_e.srw
$PBExportComments$고객쿠폰지급
forward
global type w_sh205_e from w_com010_e
end type
end forward

global type w_sh205_e from w_com010_e
integer width = 2944
long backcolor = 16777215
end type
global w_sh205_e w_sh205_e

type variables
String is_jumin , is_card_no, is_tel_no3
end variables

forward prototypes
public function boolean uf_phone_chk (string as_tel_no, ref string as_jumin, ref string as_user_name, ref string as_card_no)
public function boolean wf_coupon_no_chk (string as_coupon_no)
end prototypes

public function boolean uf_phone_chk (string as_tel_no, ref string as_jumin, ref string as_user_name, ref string as_card_no);/*============================================================*/
/* 작 성 자  : 지우정보(김영일)                               */
/* 작 성 일  : 2002/02/18                                     */
/* 수 정 일  : 2002/02/18                                     */
/* 내    용  : 회원이 있는지 체크한다.                        */
/*============================================================*/
long ls_cnt

	
	SELECT count(jumin)
	INTO  :ls_cnt
	FROM beaucre.dbo.TB_71010_M
	where replace(tel_no3,'-','') = replace(:as_tel_no,'-','');
	
	IF ls_cnt <> 1 Then 
		RETURN False
	ELSE
		SELECT jumin,user_name,card_no 
		INTO  :as_jumin,:as_user_name,:as_card_no 
		FROM beaucre.dbo.TB_71010_M
		where replace(tel_no3,'-','') = replace(:as_tel_no,'-','');
		RETURN True
	END IF


end function

public function boolean wf_coupon_no_chk (string as_coupon_no);string ls_give_coupon_no

select   coupon_no 
into		:ls_give_coupon_no 
from	   beaucre.dbo.tb_71019_h 
where    coupon_no = :as_coupon_no;

if       as_coupon_no = ls_give_coupon_no then
	      messagebox('확인', '이미지급된 쿠폰번호 입니다')
			
		   return 	true
end if
		



return  false
end function

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2001.02.18                                                  */
/*===========================================================================*/
datetime ld_datetime
String   ls_title, ls_give_date

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


IF gf_sysdate(ld_datetime) = FALSE THEN
END IF

ls_give_date  = String(ld_datetime, "yyyymmdd")


if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	




//if ls_give_date > '20050922' then 
//	if mid(gs_shop_cd,1,1) <> 'W' then
//		messagebox("주의!", '상품권 지급기간이 종료되었습니다!')
//		return false
//	end if	
//end if	

is_jumin = dw_head.GetItemString(1, "jumin")
is_card_no = dw_head.GetItemString(1, "card_no")
is_tel_no3 = dw_head.GetItemString(1, "tel_no3")


if  is_jumin = '' or isnull(is_jumin)  then
	 messagebox('경고', '주민번호를 등록 하시오')
	 return false
end if
return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.04.06(김태범)                                          */
/*===========================================================================*/
String     ls_jumin, ls_user_name, ls_card_no
String     ls_shop_nm, ls_zipcode, ls_addr, ls_area_cd,ls_tel_no3
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "jumin"
			IF ai_div = 1 THEN 	
				IF gf_cust_jumin_chk(as_data, ls_user_name, ls_card_no,ls_tel_no3) = TRUE THEN
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
						//MessageBox("오류", "주민번호가 잘못되어 있습니다!")
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

	CASE "card_no"
			IF ai_div = 1 THEN 	
				IF gf_cust_card_chk('4870090'+ as_data, ls_jumin, ls_user_name,ls_tel_no3) = TRUE THEN
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


	CASE "user_name"				
			IF ai_div = 1 THEN
				IF gf_cust_name_chk(as_data, ls_user_name, ls_jumin, ls_card_no,ls_tel_no3) = TRUE THEN
				   dw_head.SetItem(al_row, "jumin", ls_jumin)
				   dw_head.SetItem(al_row, "card_no", RightA(ls_card_no,9))
					dw_head.SetItem(al_row, "tel_no3", ls_tel_no3)	
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where   = " user_name LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "tel_no3",	 lds_Source.GetItemString(1,"tel_no3"))
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
				IF uf_phone_chk(as_data, ls_jumin,ls_user_name,ls_card_no) THEN
				   dw_head.SetItem(al_row, "jumin",     ls_jumin)
					dw_head.SetItem(al_row, "user_name", ls_user_name)		
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
				IF ai_div = 2 THEN 	
				   cb_retrieve.PostEvent(clicked!)
				END IF 
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

on w_sh205_e.create
call super::create
end on

on w_sh205_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

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



/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
END IF

ls_give_date  = String(ld_datetime, "yyyymmdd")


select  yymmdd, sum(sale_amt - goods_amt) 
into	  :ls_yymmdd, :ll_sale_amt
from	  tb_53010_h with (nolock)
where   yymmdd = :ls_give_date
and	  brand  = :gs_brand
and	  jumin  = :is_jumin
and	  sale_type < '40'
group by yymmdd;

if  IsNull(ll_sale_amt) then 
	 ll_sale_amt = 0
end if

if  ll_sale_amt = 0 then 
	 ll_coupon_cnt = 0
else
	IF GS_BRAND = 'W' THEN
		ll_coupon_cnt =   Truncate(ll_sale_amt / 100000,0) 
	ELSE	
		ll_coupon_cnt =   Truncate(ll_sale_amt / 100000,0) 
	END IF	
end if



if   ll_row_count  >  ll_coupon_cnt   then
     messagebox('확인', '상품권 지급할수 있는 매출이 안됩니다!')
	  return -1
end if



FOR i=1 TO ll_row_count
	ls_coupon_no = dw_body.getitemstring(i, "coupon_no")
 
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
			if wf_coupon_no_chk(ls_coupon_no) then 
				return -1
			end if
		dw_body.Setitem(i, "brand", gs_brand)
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN	      /* Modify Record */
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

is_jumin = dw_head.GetItemString(1, "jumin")
is_card_no = dw_head.GetItemString(1, "card_no")
is_tel_no3 = dw_head.GetItemString(1, "tel_no3")



/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
END IF

ls_give_date  = String(ld_datetime, "yyyymmdd")

//  messagebox('브랜드', gs_brand)

select  sum(sale_amt - goods_amt) 
into	  :ll_sale_amt
from	  tb_53010_h with (nolock)
where   yymmdd = :ls_give_date
and	  brand  = :gs_brand
and	  jumin  = :is_jumin
and	  sale_type < '40';

if  IsNull(ll_sale_amt) then 
	 ll_sale_amt = 0
end if

if  ll_sale_amt = 0 then 
	 ll_coupon_cnt = 0
else
		IF GS_BRAND = 'W' THEN
		ll_coupon_cnt =   Truncate(ll_sale_amt / 100000,0) 
	ELSE	
		ll_coupon_cnt =   Truncate(ll_sale_amt / 100000,0) 
	END IF	
end if


if ll_coupon_cnt >  0  and LenA(is_jumin) = 13 then 
	dw_head.object.text_message.text = "금일 매출로 상품권을  " + string(ll_coupon_cnt) + "장 지급할수 있습니다 !"
else 
	dw_head.object.text_message.text = ""
end if


/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_jumin, gs_brand, ls_give_date)




This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

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

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
END IF

ls_give_date  = String(ld_datetime, "yyyymmdd")


il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

select card_no
into   :is_card_no
from	 beaucre.dbo.tb_71010_m (nolock)
where  jumin = :is_jumin;


dw_body.Setitem(il_rows,"jumin", is_jumin)
dw_body.Setitem(il_rows,"give_date", ls_give_date)
dw_body.Setitem(il_rows,"point_seq", il_rows)
dw_body.Setitem(il_rows,"card_no", is_card_no)
dw_body.Setitem(il_rows,"give_amt", 10000)
dw_body.Setitem(il_rows,"accept_flag", 'N')


This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_sh205_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh205_e
end type

type cb_insert from w_com010_e`cb_insert within w_sh205_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh205_e
end type

type cb_update from w_com010_e`cb_update within w_sh205_e
end type

type cb_print from w_com010_e`cb_print within w_sh205_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh205_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh205_e
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh205_e
integer y = 164
integer width = 2830
integer height = 256
string dataobject = "d_sh205_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.04.06(ktb)                                             */
/*===========================================================================*/
Long li_ret

CHOOSE CASE dwo.name
		CASE "jumin","card_no","tel_no3", "user_name"
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

type ln_1 from w_com010_e`ln_1 within w_sh205_e
end type

type ln_2 from w_com010_e`ln_2 within w_sh205_e
end type

type dw_body from w_com010_e`dw_body within w_sh205_e
string dataobject = "d_sh205_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
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

type dw_print from w_com010_e`dw_print within w_sh205_e
integer x = 169
integer y = 664
end type

