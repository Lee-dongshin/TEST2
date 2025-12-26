$PBExportHeader$w_71040_d.srw
$PBExportComments$고객신상정보관리
forward
global type w_71040_d from w_com010_d
end type
type dw_1 from datawindow within w_71040_d
end type
type cb_1 from commandbutton within w_71040_d
end type
type dw_2 from datawindow within w_71040_d
end type
end forward

global type w_71040_d from w_com010_d
integer height = 2336
dw_1 dw_1
cb_1 cb_1
dw_2 dw_2
end type
global w_71040_d w_71040_d

type variables
String is_jumin, is_user_name, is_last_sale_date, is_give_date
long 	 il_event_point
end variables

forward prototypes
public function boolean uf_chk_id (string as_user_id, ref string as_jumin, ref string as_user_name, ref string as_card_no, ref string as_tel_no)
public function boolean uf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name, ref string as_card_no, ref string as_user_id)
public function boolean uf_cust_card_chk (string as_card_no, ref string as_jumin, ref string as_user_name, ref string as_tel_no3, ref string as_user_id)
public function boolean uf_cust_jumin_chk (string as_jumin, ref string as_user_name, ref string as_card_no, ref string as_tel_no3, ref string as_user_id)
public function boolean uf_cust_name_chk (string as_user_name, string as_user_name2, string as_jumin, string as_card_no, string as_tel_no3, string as_user_id)
end prototypes

public function boolean uf_chk_id (string as_user_id, ref string as_jumin, ref string as_user_name, ref string as_card_no, ref string as_tel_no);int li_cnt
	select jumin, user_name, card_no, tel_no3
		into :as_jumin, :as_user_name, :as_card_no, :as_tel_no
	from beaucre.dbo.tb_71010_m (nolock) 
	where user_id = :as_user_id;

	select count(jumin)
		into :li_cnt
	from beaucre.dbo.tb_71010_m (nolock) 
	where user_id = :as_user_id;

	if li_cnt <> 1 or isnull(as_jumin) or LenA(as_jumin) <> 13 then 
		return False
	else 
		return True
	end if
end function

public function boolean uf_chk_phone (string as_tel_no, ref string as_jumin, ref string as_user_name, ref string as_card_no, ref string as_user_id);int li_cnt
	select jumin, user_name, card_no, user_id
		into :as_jumin, :as_user_name, :as_card_no, :as_user_id
	from beaucre.dbo.tb_71010_m (nolock) 
	where replace(tel_no3,'-','') = replace(:as_tel_no,'-','');

	select count(jumin)
		into :li_cnt
	from beaucre.dbo.tb_71010_m (nolock) 
	where replace(tel_no3,'-','') = replace(:as_tel_no,'-','');

	if li_cnt <> 1 or isnull(as_jumin) or LenA(as_jumin) <> 13 then 
		return False
	else 
		return True
	end if
end function

public function boolean uf_cust_card_chk (string as_card_no, ref string as_jumin, ref string as_user_name, ref string as_tel_no3, ref string as_user_id);SELECT isnull(max(JUMIN),""), isnull(max(USER_NAME),""), isnull(max(tel_no3),""), isnull(max(user_id),"")
  INTO :as_jumin, :as_user_name, :as_tel_no3, :as_user_id
  FROM beaucre.dbo.TB_71010_M
 WHERE CARD_NO like :as_card_no;

IF isnull(as_jumin) or as_jumin = "" Then
	RETURN False 
ELSE
	RETURN True 
END IF	
end function

public function boolean uf_cust_jumin_chk (string as_jumin, ref string as_user_name, ref string as_card_no, ref string as_tel_no3, ref string as_user_id);SELECT isnull(max(USER_NAME),""),isnull(max(CARD_NO),""),isnull(max(tel_no3),""),isnull(max(user_id),"")
INTO  :as_user_name,:as_card_no, :as_tel_no3, :as_user_id
FROM beaucre.dbo.TB_71010_M
WHERE JUMIN = :as_jumin;

IF isnull(as_card_no) or as_card_no = "" Then
	RETURN False	
ELSE
	RETURN True
END IF	
end function

public function boolean uf_cust_name_chk (string as_user_name, string as_user_name2, string as_jumin, string as_card_no, string as_tel_no3, string as_user_id);long ls_cnt

SELECT count(jumin)
INTO  :ls_cnt
FROM beaucre.dbo.TB_71010_M
WHERE user_name like :as_user_name + "%";

IF ls_cnt <> 1 Then 
	RETURN False
ELSE
	SELECT user_name,jumin,card_no,tel_no3,user_id
	INTO  :as_user_name2,:as_jumin,:as_card_no, :as_user_id
	FROM beaucre.dbo.TB_71010_M
	WHERE user_name like :as_user_name + "%";
	RETURN True
END IF

end function

on w_71040_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_2
end on

on w_71040_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.dw_2)
end on

event ue_popup;String     ls_jumin, ls_user_name, ls_card_no, ls_add_name, ls_user_id
String     ls_shop_nm, ls_zipcode, ls_addr, ls_area_cd, ls_tel_no3  
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "jumin"	
			if isnull(as_data) or as_data = '' then return 0
			IF ai_div = 1 THEN 	
				IF uf_cust_jumin_chk(as_data, ls_user_name, ls_card_no, ls_tel_no3, ls_user_id) = TRUE THEN
				   dw_head.SetItem(al_row, "user_name", ls_user_name)
				   dw_head.SetItem(al_row, "card_no", RightA(ls_card_no,9))
					dw_head.SetItem(al_row, "tel_no3", ls_tel_no3)
					dw_head.SetItem(al_row, "user_id", ls_user_id)
					RETURN 0
				ELSEIF LenA(Trim(as_data)) = 13 THEN
					IF gf_jumin_chk(as_data) THEN 
				      dw_head.SetItem(al_row, "user_name", "")
				      dw_head.SetItem(al_row, "card_no", "")
					   Return 0
					ELSE
						//MessageBox("오류", "주민번호가 잘못되여 있습니다!")
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
				dw_head.SetItem(al_row, "user_id", lds_Source.GetItemString(1,"user_id"))
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
				IF uf_cust_card_chk('4870090'+ as_data, ls_jumin, ls_user_name,ls_tel_no3,ls_user_id) = TRUE THEN
				   dw_head.SetItem(al_row, "user_name", ls_user_name)
				   dw_head.SetItem(al_row, "card_no",   RightA(Trim(as_data),9))			
				   dw_head.SetItem(al_row, "jumin",     ls_jumin)
					dw_head.SetItem(al_row, "tel_no3", ls_tel_no3)
					dw_head.SetItem(al_row, "user_id", ls_user_id)
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
				dw_head.SetItem(al_row, "user_id", lds_Source.GetItemString(1,"user_id"))
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
				IF uf_cust_name_chk(as_data, ls_user_name, ls_jumin, ls_card_no,ls_tel_no3,ls_user_id) = TRUE THEN
				   dw_head.SetItem(al_row, "jumin", ls_jumin)
				   dw_head.SetItem(al_row, "card_no", RightA(ls_card_no,9))
					dw_head.SetItem(al_row, "tel_no3", ls_tel_no3)
					dw_head.SetItem(al_row, "user_id", ls_user_id)					
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
				dw_head.SetItem(al_row, "user_id", lds_Source.GetItemString(1,"user_id"))
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
				IF isnull(as_data) or trim(as_data) = "" THEN
					RETURN 0
				END IF
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_body.SetItem(al_row, "shop_nm", ls_shop_nm)
					IF gf_area_cd(as_data,ls_area_cd) = True THEN
					   dw_body.SetItem(al_row, "area", ls_area_cd)
					END IF
					ib_changed = true
					cb_update.enabled = true
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND Shop_div  in ('G', 'K') "
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
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_body.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				
				IF gf_area_cd(lds_Source.GetItemString(1,"shop_cd"),ls_area_cd) = TRUE THEN
				   dw_body.SetItem(al_row, "area", ls_area_cd)
				END IF
				
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
				cb_update.enabled = true
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source		
	CASE "zipcode"				
			IF ai_div = 1 THEN 	
				IF gf_zipcode_chk(as_data, ls_zipcode, ls_addr) = True THEN
				   dw_body.SetItem(al_row, "zipcode", ls_zipcode)
				   dw_body.SetItem(al_row, "addr", ls_addr)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "우편번호 검색" 
			gst_cd.datawindow_nm   = "d_com916" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "ZIPCODE1 LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "zipcode", lds_Source.GetItemString(1,"zipcode1"))
				dw_body.SetItem(al_row, "addr",    lds_Source.GetItemString(1,"jiyeok")+" "+lds_Source.GetItemString(1,"gu")+" "+lds_Source.GetItemString(1,"dong"))
				ib_itemchanged = False 
				lb_check = TRUE 
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("addr_s")
				ib_changed = true
				cb_update.enabled = true
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source					
	CASE "zipcode2"				
			IF ai_div = 1 THEN 	
				IF gf_zipcode_chk(as_data, ls_zipcode, ls_addr) = True THEN
				   dw_body.SetItem(al_row, "zipcode2", ls_zipcode)
				   dw_body.SetItem(al_row, "addr2", ls_addr)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "우편번호 검색" 
			gst_cd.datawindow_nm   = "d_com916" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "ZIPCODE1 LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "zipcode2", lds_Source.GetItemString(1,"zipcode1"))
				dw_body.SetItem(al_row, "addr2",    lds_Source.GetItemString(1,"jiyeok")+" "+lds_Source.GetItemString(1,"gu")+" "+lds_Source.GetItemString(1,"dong"))
				ib_itemchanged = False 
				lb_check = TRUE 
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("addr2_s")
				ib_changed = true
				cb_update.enabled = true
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source		
			
	CASE "tel_no3"
			IF ai_div = 1 THEN 	
				IF uf_chk_phone(as_data, ls_jumin,ls_user_name,ls_card_no, ls_user_id) THEN
				   dw_head.SetItem(al_row, "user_name", ls_user_name)		
				   dw_head.SetItem(al_row, "jumin",     ls_jumin)
					dw_head.SetItem(al_row, "card_no", RightA(ls_card_no,9))
				   dw_head.SetItem(al_row, "user_id", ls_user_id)						
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
				dw_head.SetItem(al_row, "user_id", lds_Source.GetItemString(1,"user_id"))					
				 
				IF ai_div = 2 THEN 	
				   cb_retrieve.PostEvent(clicked!)
				END IF 
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source

	CASE "user_id"
			IF ai_div = 1 THEN 	
				IF uf_chk_id(as_data, ls_jumin, ls_user_name, ls_card_no, ls_tel_no3) THEN
				   dw_head.SetItem(al_row, "user_name", ls_user_name)		
				   dw_head.SetItem(al_row, "jumin",     ls_jumin)
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
				gst_cd.Item_where   = " user_id = '" + as_data + "'"
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
				dw_head.SetItem(al_row, "user_id", lds_Source.GetItemString(1,"user_id"))					
				 
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

event pfc_close;call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_71040_d","0")
end event

event type boolean ue_keycheck(string as_cb_div);String   ls_title

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
is_user_name = dw_head.GetItemString(1, "user_name")


IF dw_1.AcceptText() <> 1 THEN RETURN FALSE
is_give_date = dw_1.GetItemString(1, "give_date")
IF as_cb_div = '3' and (is_give_date = "" OR isnull(is_give_date)) THEN
   MessageBox(ls_title,"쿠폰 발행일자를 확인 하십시요!")
   dw_1.SetFocus()
   dw_1.SetColumn("give_date")
   return false
END IF

/*
il_event_point	= dw_1.GetItemNumber(1, "event_point")
is_last_sale_date = dw_1.GetItemString(1, "last_sale_date")

IF as_cb_div = '3' and (isnull(il_event_point) or il_event_point < 10) THEN
   MessageBox(ls_title,"이벤트포인트를 확인하십시요!")
   dw_1.SetFocus()
   dw_1.SetColumn("event_point")
   return false
END IF

IF as_cb_div = '3' and (is_last_sale_date = "" OR isnull(is_last_sale_date)) THEN
   MessageBox(ls_title,"사용가능일을 확인하십시요!")
   dw_1.SetFocus()
   dw_1.SetColumn("last_sale_date")
   return false
END IF
*/
return true
end event

event ue_retrieve;call super::ue_retrieve;String   ls_birthday
datetime ld_datetime

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_jumin)
IF il_rows > 0 THEN
	
	IF isnull(dw_body.GetItemString(il_rows,'birthday')) OR Trim(dw_body.GetItemString(il_rows,'birthday')) = "" THEN
      /* 생년월일 기본값 처리  */
		IF MidA(is_jumin,7,1) > '2' THEN
			ls_birthday = '20'+MidA(is_jumin,1,6)
		ELSE
			ls_birthday = '19'+MidA(is_jumin,1,6)
		END IF
		dw_body.SetItem(il_rows,'birthday',ls_birthday)
		dw_body.SetItem(il_rows,'bday',1)
	END IF
	dw_body.SetColumn("birthday")
   dw_body.SetFocus()
	dw_1.visible = true 
	dw_1.InsertRow(0)  
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button;CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
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
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

type cb_close from w_com010_d`cb_close within w_71040_d
end type

type cb_delete from w_com010_d`cb_delete within w_71040_d
end type

type cb_insert from w_com010_d`cb_insert within w_71040_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_71040_d
end type

type cb_update from w_com010_d`cb_update within w_71040_d
integer x = 1426
integer width = 521
integer weight = 700
string text = "이벤트포인트 지급"
end type

event cb_update::clicked;if messagebox("확인","실행하시겠습니다...?",Exclamation!,YesNoCancel!,1 ) <> 1 then return


IF Trigger Event ue_keycheck('3') = FALSE THEN RETURN

messagebox("is_jumin",is_jumin)
messagebox("il_event_point",il_event_point)
messagebox("is_last_sale_date",is_last_sale_date)


DECLARE sp_give_event_point PROCEDURE FOR sp_give_event_point  
		  @jumin          = :is_jumin,   
		  @event_point    = :il_event_point,   
		  @last_sale_date = :is_last_sale_date,   
		  @mod_user_id    = :gs_user_id;
			
execute sp_give_event_point;	

commit  USING SQLCA;


messagebox("확인","정상처리되었슴니다...")
end event

type cb_print from w_com010_d`cb_print within w_71040_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_71040_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_71040_d
end type

type cb_excel from w_com010_d`cb_excel within w_71040_d
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_71040_d
integer height = 128
string dataobject = "d_71040_h01"
end type

event dw_head::itemchanged;Long li_ret

CHOOSE CASE dwo.name
		CASE "jumin", "user_name", "card_no", "tel_no3", "user_id" 
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

type ln_1 from w_com010_d`ln_1 within w_71040_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_71040_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_71040_d
integer y = 356
string dataobject = "d_71040_d01"
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("area", ldw_child)
ldw_child.SetTRansObject(SQLCA)
ldw_child.Retrieve('090')

This.GetChild("job", ldw_child)
ldw_child.SetTRansObject(SQLCA)
ldw_child.Retrieve('701')

end event

type dw_print from w_com010_d`dw_print within w_71040_d
end type

type dw_1 from datawindow within w_71040_d
integer x = 50
integer y = 1960
integer width = 3488
integer height = 148
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_71040_d02"
boolean border = false
boolean livescroll = true
end type

type cb_1 from commandbutton within w_71040_d
integer x = 2121
integer y = 48
integer width = 512
integer height = 84
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "이벤트 쿠폰지급"
end type

event clicked;string ls_give_date, ls_event_id, ls_event_nm, ls_close_ymd, ls_card_no
decimal ld_price
long ll_rows

if messagebox("확인","실행 하시겠습니까...?",Exclamation!,YesNoCancel!,1 ) <> 1 then return


IF Trigger Event ue_keycheck('3') = FALSE THEN RETURN

ls_give_date = dw_1.getitemstring(1,'give_date')
dw_2.SetTransObject(SQLCA)


dw_2.retrieve(ls_give_date)
ls_card_no = '4870090' + dw_head.getitemstring(1,'card_no')
ls_event_id = dw_2.getitemstring(1,'event_id')
ls_event_nm = dw_2.getitemstring(1,'event_nm')
ls_close_ymd = dw_2.getitemstring(1,'close_ymd')
ld_price = dw_2.getitemnumber(1,'price') / 10

ll_rows = dw_2.RowCount()

if ll_rows < 0 then 
	messagebox('확인','등록된 쿠폰이 없습니다. 확인후 다시 처리해 주세요!' )
	return
end if

DECLARE sp_give_event_coupon PROCEDURE FOR sp_give_event_coupon  
			@card_no = :ls_card_no,
			@event_id = :ls_event_id,
			@use_ymd = :ls_close_ymd,
			@give_point = :ld_price,
			@reg_id = :gs_user_id;
			
execute sp_give_event_coupon;	

commit  USING SQLCA;


messagebox("확인","정상처리 되었습니다...")
end event

type dw_2 from datawindow within w_71040_d
boolean visible = false
integer x = 1783
integer y = 516
integer width = 1289
integer height = 408
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_71040_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

