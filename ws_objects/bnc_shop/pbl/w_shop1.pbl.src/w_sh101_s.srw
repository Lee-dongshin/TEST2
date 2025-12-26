$PBExportHeader$w_sh101_s.srw
$PBExportComments$판매일보등록[고객등록]
forward
global type w_sh101_s from w_com010_e
end type
type st_1 from statictext within w_sh101_s
end type
end forward

global type w_sh101_s from w_com010_e
integer width = 1888
integer height = 1456
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_closeparm ( )
st_1 st_1
end type
global w_sh101_s w_sh101_s

type variables
String  is_jumin, is_area_cd , is_email , is_email1 , is_email2, is_tel_no3, is_tel_no3a, is_tel_no3b, is_tel_no3c
integer il_sex
String  is_tel_no1, is_tel_no1a, is_tel_no1b, is_tel_no1c
end variables

forward prototypes
public function boolean uf_make_card_no (string as_jumin, ref string as_card_no)
public function boolean wf_card_chk (string as_card_no)
public function integer wf_tel_no_chk (string as_tel_no, ref string as_card_no, ref string as_user_name, ref string as_tel_no3)
end prototypes

event ue_closeparm();
CloseWithReturn(This, is_jumin)

end event

public function boolean uf_make_card_no (string as_jumin, ref string as_card_no);
	select '4870090'+ convert(char(7),max(substring(card_no,8,7)) + 1) + '01'
		into :as_card_no
	from tb_71010_m a(nolock) 
	where card_no > '4870090917110001';

	if isnull(as_card_no) or LenA(as_card_no) <> 16 then
		return False
	else
		return True
	end if
	
end function

public function boolean wf_card_chk (string as_card_no);String ls_card_no 
Long   ll_cnt 

IF LenA(Trim(as_card_no)) <> 9  THEN RETURN FALSE 
IF match(as_card_no, "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][12]") = FALSE THEN 
	MessageBox("확인", "카드번호 오류 !") 
	dw_body.SetFocus()
	RETURN FALSE
END IF
ls_card_no = "4870090" + as_card_no

SELECT count(card_no) 
  INTO :ll_cnt 
  FROM TB_71010_M 
 WHERE card_no = :ls_card_no;

IF ll_cnt > 0 THEN 
	MessageBox("확인", "이미 등록된 카드번호 입니다 !")
	RETURN FALSE
END IF

dw_body.Setitem(1, "card_no", ls_card_no)

RETURN TRUE 


end function

public function integer wf_tel_no_chk (string as_tel_no, ref string as_card_no, ref string as_user_name, ref string as_tel_no3);
long ls_cnt

SELECT COUNT(JUMIN)
  INTO :ls_cnt
  FROM TB_71010_M
 WHERE tel_no3 = :as_tel_no
;

IF ls_cnt = 1 Then
	SELECT CARD_NO, user_name, tel_no3
	  INTO :as_card_no, :As_user_name, :as_tel_no3
	  FROM TB_71010_M
	WHERE tel_no3 = :as_tel_no
	;
	RETURN 0
end if

//ElseIf ls_cnt > 1 Then
//	RETURN -2
//Else
//	RETURN -1
//END IF

end function

on w_sh101_s.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_sh101_s.destroy
call super::destroy
destroy(this.st_1)
end on

event pfc_preopen();/*===========================================================================*/
/* 작성자      : 지우정보 (김태범) 														  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)

Window ldw_parent
Long   ll_x, ll_y

ldw_parent = This.ParentWindow()
This.x = ((ldw_parent.Width - This.Width) / 2) +  ldw_parent.x
This.y = ((ldw_parent.Height - This.Height) / 2) +  ldw_parent.y 

dw_body.InsertRow(0) 

Select area_cd 
  into :is_area_cd 
  from tb_91100_m 
 where shop_cd = :gs_shop_cd ;
 
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
String ls_email1, ls_email2, ls_email, ls_tel_no3a, ls_tel_no3b, ls_tel_no3c, ls_tel_no3,ls_birthday
sTRING ls_tel_no1a, ls_tel_no1b, ls_tel_no1c, ls_tel_no1
Long ll_pos, ll_len_str

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_jumin)
IF il_rows > 0 THEN
   ls_email = dw_body.GetItemString(1,"email")
   ls_tel_no3 = dw_body.GetItemString(1,"tel_no3")
   ls_tel_no1 = dw_body.GetItemString(1,"tel_no1")	
	if LenA(ls_email) > 0 then
		ll_pos =	PosA(ls_email,"@")
		ls_email1 = LeftA(ls_email,ll_pos - 1)
		ls_email2 = MidA(ls_email,ll_pos + 1,LenA(ls_email))
		dw_body.SetItem(1,"email1",ls_email1)
		dw_body.SetItem(1,"email2",ls_email2)
	end if
	
	if LenA(ls_tel_no3) = 10 then
			ls_tel_no3a = LeftA(ls_tel_no3,3)
			ls_tel_no3b = MidA(ls_tel_no3,4,3)
			ls_tel_no3c = RightA(ls_tel_no3,4)
			
			dw_body.SetItem(1,"tel_no3a",ls_tel_no3a)
			dw_body.SetItem(1,"tel_no3b",ls_tel_no3b)
			dw_body.SetItem(1,"tel_no3c",ls_tel_no3c)
	ElseIf LenA(ls_tel_no3) = 11 then
			ls_tel_no3a = LeftA(ls_tel_no3,3)
			ls_tel_no3b = MidA(ls_tel_no3,4,4)
			ls_tel_no3c = RightA(ls_tel_no3,4)
			
			dw_body.SetItem(1,"tel_no3a",ls_tel_no3a)
			dw_body.SetItem(1,"tel_no3b",ls_tel_no3b)
			dw_body.SetItem(1,"tel_no3c",ls_tel_no3c)
	end if
	
	ll_len_str = LenA(ls_tel_no1)
	if MidA(ls_tel_no1,1,2) = "02" then
		   if ll_len_str = 12 then
			   ls_tel_no1a = MidA(ls_tel_no1,1,2)
 			   ls_tel_no1b = MidA(ls_tel_no1,4,4)
 			   ls_tel_no1c = MidA(ls_tel_no1,9,4)				 
		   else		 
			   ls_tel_no1a = MidA(ls_tel_no1,1,2)
 			   ls_tel_no1b = MidA(ls_tel_no1,4,3)
 			   ls_tel_no1c = MidA(ls_tel_no1,8,4)				 
			end if				
			dw_body.SetItem(1,"tel_no1a",ls_tel_no1a)
			dw_body.SetItem(1,"tel_no1b",ls_tel_no1b)
			dw_body.SetItem(1,"tel_no1c",ls_tel_no1c)
	Else
		   if ll_len_str = 13 then
			   ls_tel_no1a = MidA(ls_tel_no1,1,3)
 			   ls_tel_no1b = MidA(ls_tel_no1,5,4)
 			   ls_tel_no1c = MidA(ls_tel_no1,10,4)				 
		   else		 
			   ls_tel_no1a = MidA(ls_tel_no1,1,3)
 			   ls_tel_no1b = MidA(ls_tel_no1,5,3)
 			   ls_tel_no1c = MidA(ls_tel_no1,9,4)				 
			end if							
			dw_body.SetItem(1,"tel_no1a",ls_tel_no1a)
			dw_body.SetItem(1,"tel_no1b",ls_tel_no1b)
			dw_body.SetItem(1,"tel_no1c",ls_tel_no1c)
	end if
	
	
	dw_body.Enabled = TRUE 
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN 
	dw_body.Enabled = TRUE 
   il_rows = dw_body.insertRow(0)
   dw_body.SetFocus()
	
	IF il_rows = 1 THEN	
	/* 생년월일 기본값 처리  */
	dw_body.Setitem(1, "jumin", is_jumin)
	IF MidA(is_jumin,7,1) > '2' THEN
		ls_birthday = '20'+MidA(is_jumin,1,6)
	ELSE
		ls_birthday = '19'+MidA(is_jumin,1,6)
	END IF
	dw_body.SetItem(il_rows,'birthday',ls_birthday)
	dw_body.SetItem(il_rows,'bday',1)
	/* 성별 기본값 처리  */
	IF MidA(is_jumin,7,1) = '1' OR MidA(is_jumin,7,1) = '3' THEN
		dw_body.Setitem(1, "sex", 0)
	ELSE 
		dw_body.Setitem(1, "sex", 1)
//		dw_body.SetRow(1)
//		dw_body.SetColumn("job")
	END IF
	END IF
END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
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

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

is_jumin = dw_head.GetItemString(1, "jumin")
if IsNull(is_jumin) or Trim(is_jumin) = "" then
   MessageBox(ls_title,"주민등록 번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jumin")
   return false
end if

IF match(MidA(is_jumin, 7, 1), "^[13]") THEN 
	il_sex = 0 
ELSE
	il_sex = 1 
END IF

return true
end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_tot_point, ll_event_point
datetime ld_datetime 
String   ls_card_no, ls_zipcode, ls_yymmdd, ls_tel_no3, ls_post_flag, ls_addrv, ls_addrv_s, ls_tel_no3a, ls_quick_yn

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1 

ls_quick_yn = dw_head.GetitemString(1, "quick_yn")
if isnull(ls_quick_yn) then
	ls_quick_yn = 'N'
end if	

ls_zipcode = dw_body.GetitemString(1, "zipcode_v") 
ls_post_flag = dw_body.GetitemString(1, "post_flag") 
ls_addrv = dw_body.GetitemString(1, "addrv") 
ls_addrv_s = dw_body.GetitemString(1, "addrv_s") 
ls_tel_no3a = dw_body.GetitemString(1, "tel_no3a") 

IF ls_quick_yn <> 'Y' and (isnull(ls_zipcode) OR LenA(ls_zipcode) <> 7) THEN 
	MessageBox("오류", "우편번호를 검색하여 정확히 입력하세요!")
	dw_body.SetColumn("zipcode")
	RETURN -1 
END IF

// 키보드 입력 편의를 위해 수정 -- 20041129 LYJ

if ls_quick_yn <> 'Y' and isnull(ls_tel_no3a) then
	MessageBox("오류", "통신회사 번호를 선택하세요!")
	dw_body.SetColumn("tel_no3a")
	RETURN -1 	
END IF	

IF ls_quick_yn <> 'Y' and trim(ls_tel_no3a) <> "010" THEN 
	IF  trim(ls_tel_no3a) <> "011" THEN 
		IF  trim(ls_tel_no3a) <> "016" THEN 
			IF  trim(ls_tel_no3a) <> "017" THEN 
				IF  trim(ls_tel_no3a) <> "018" THEN 
					IF  trim(ls_tel_no3a) <> "019" THEN 
						MessageBox("오류", "통신회사 번호를 선택하세요!")
						dw_body.SetColumn("tel_no3a")
						RETURN -1 
					end if	
				end if					
			end if				
		end if			
	end if		
end if	


IF ls_quick_yn <> 'Y' and (isnull(ls_post_flag) OR LenA(ls_post_flag) = 0) THEN 
	MessageBox("오류", "우편물 수령지를 선택하세요!")
	dw_body.SetColumn("post_flag")
	RETURN -1 
END IF

// 자택, 직장에 따라 주소값 선택 저장
IF ls_post_flag = "0" THEN 
	dw_body.Setitem(1,"zipcode", ls_zipcode)
	dw_body.Setitem(1,"addr", ls_addrv)
	dw_body.Setitem(1,"addr_s", ls_addrv_s)
ELSE
	dw_body.Setitem(1,"zipcode2", ls_zipcode)
	dw_body.Setitem(1,"addr2", ls_addrv)
	dw_body.Setitem(1,"addr2_s", ls_addrv_s)
END IF

ls_card_no = dw_body.GetitemString(1, "card_no") 
IF isnull(ls_card_no) OR LenA(ls_card_no) <> 16 THEN 
	SQLCA.Lock = "RU"
	if uf_make_card_no(is_jumin, ls_card_no) then
		dw_body.Setitem(1,"card_no2", MidA(ls_card_no,8))
		dw_body.Setitem(1,"card_no", ls_card_no)

	else
		MessageBox("오류", "카드번호를 확인하세요")
		SQLCA.Lock = "RC"
		RETURN -1 
	end if
	

END IF


ls_tel_no3 = dw_body.GetitemString(1, "tel_no3a") + dw_body.GetitemString(1, "tel_no3b") + dw_body.GetitemString(1, "tel_no3c")
//IF isnull(ls_tel_no3) OR Len(ls_tel_no3) < 10  THEN 
//	MessageBox("오류", "핸드폰번호를 정확히 입력하세요!")
//	dw_body.SetColumn("tel_no3a")
//	RETURN -1 
//END IF


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	SQLCA.Lock = "RC"
	Return 0
END IF

ls_yymmdd = String(ld_datetime, "yyyymmdd") 

// 이메일 구하기
is_email1 = dw_body.GetitemString(1, "email1") 
is_email2 = dw_body.GetitemString(1, "email2")
is_tel_no3a = dw_body.GetitemString(1, "tel_no3a")
is_tel_no3b = dw_body.GetitemString(1, "tel_no3b")
is_tel_no3c = dw_body.GetitemString(1, "tel_no3c")
is_tel_no1a = dw_body.GetitemString(1, "tel_no1a")
is_tel_no1b = dw_body.GetitemString(1, "tel_no1b")
is_tel_no1c = dw_body.GetitemString(1, "tel_no1c")

IF is_email1 <> '' and is_email2 <> '' THEN
	is_email = is_email1 + "@" + is_email2
ELSE
	is_email = ''
END if

IF is_tel_no3a <> '' and is_tel_no3b <> '' and is_tel_no3c <> '' THEN
	is_tel_no3 = is_tel_no3a + "-" + is_tel_no3b + "-" + is_tel_no3c
ELSE
	is_tel_no3 = ''
END if

IF is_tel_no1a <> '' and is_tel_no1b <> '' and is_tel_no1c <> '' THEN
	is_tel_no1 = is_tel_no1a + "-" + is_tel_no1b + "-" + is_tel_no1c
ELSE
	is_tel_no1 = ''
END if
//


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "jumin",   is_jumin)
      dw_body.Setitem(i, "sex",     il_sex)
		dw_body.Setitem(i, "email",   is_email)
		dw_body.Setitem(i, "tel_no3",   is_tel_no3)
		dw_body.Setitem(i, "tel_no1",   is_tel_no1)			
		IF dw_body.GetItemStatus(i, "card_no", Primary!) = DataModified! THEN
         dw_body.Setitem(i, "shop_cd",       gs_shop_cd)
         dw_body.Setitem(i, "card_day",      String(ld_datetime, "yyyymmdd"))
         dw_body.Setitem(i, "area",          is_area_cd)
		
//			if ls_yymmdd >= '20030613' and ls_yymmdd <= '20030817' then
//				ll_tot_point   = dw_body.Getitemnumber(i, "total_point")
//				ll_event_point = dw_body.Getitemnumber(i, "event_point")				
//				 dw_body.Setitem(i, "total_point", ll_tot_point + 300 )
//				 dw_body.Setitem(i, "event_point", ll_event_point + 300 )				 
//			end if	 
			
		END IF
      dw_body.Setitem(i, "reg_id",  gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		IF dw_body.GetItemStatus(i, "card_no", Primary!) = DataModified! THEN
         dw_body.Setitem(i, "shop_cd", gs_shop_cd)
         dw_body.Setitem(i, "card_day", String(ld_datetime, "yyyymmdd")) 
         dw_body.Setitem(i, "area",    is_area_cd)
			
//			if ls_yymmdd >= '20030613' and ls_yymmdd <= '20030817' then
//				ll_tot_point   = dw_body.Getitemnumber(i, "total_point")
//				ll_event_point = dw_body.Getitemnumber(i, "event_point")				
//				 dw_body.Setitem(i, "total_point", ll_tot_point + 300 )
//				 dw_body.Setitem(i, "event_point", ll_event_point + 300 )				 
//			 end if	 
			 
		END IF
		dw_body.Setitem(i, "email",   is_email)
		dw_body.Setitem(i, "tel_no3",   is_tel_no3)
		dw_body.Setitem(i, "tel_no1",   is_tel_no1)		
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
	This.Post Event ue_closeParm()

else
   rollback  USING SQLCA;
end if
SQLCA.Lock = "RC"
	
This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;

String     ls_zipcode, ls_addr, ls_card_no, ls_user_name, ls_rec_tel_no
integer li_return
Boolean    lb_check 
DataStore  lds_Source
CHOOSE CASE as_column
	CASE "zipcode_v","zipcode"		

			IF ai_div = 1 THEN 	
				IF gf_zipcode_chk(as_data, ls_zipcode, ls_addr) = True THEN
				   dw_body.SetItem(al_row, "zipcode_v", ls_zipcode)
				   dw_body.SetItem(al_row, "addrv", ls_addr)
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
				dw_body.SetItem(al_row, "zipcode_v", lds_Source.GetItemString(1,"zipcode1"))
				dw_body.SetItem(al_row, "addrv",    lds_Source.GetItemString(1,"jiyeok")+" "+lds_Source.GetItemString(1,"gu")+" "+lds_Source.GetItemString(1,"dong"))
				ib_itemchanged = False 
				lb_check = TRUE 
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("addrv_s")
				ib_changed = true
				cb_update.enabled = true
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source					
			
CASE "rec_tel_no"

			If dw_body.AcceptText() <> 1 Then Return 1
			
			if LenA(as_data) = 0 or isnull(as_data) then return 1
			
			IF ai_div = 1 THEN 	
				li_return = wf_tel_no_chk(as_data, ls_card_no, ls_user_name,ls_rec_tel_no)
				IF li_return = 0 THEN
						dw_body.SetItem(al_row, "recommender", ls_card_no    )
						dw_body.SetItem(al_row, "rec_user_name",   ls_user_name)						
						dw_body.SetItem(al_row, "rec_tel_no",   ls_rec_tel_no)												
						RETURN 0						
				END IF 
			END IF
			
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""		//WHERE Shop_Stat = '00' 
			gst_cd.Item_where = " tel_no3 LIKE '" + Trim(as_data) + "%'"
			

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
				dw_body.SetItem(al_row, "recommender",   lds_Source.GetItemString(1, "card_no")    )
				dw_body.SetItem(al_row, "rec_user_name", lds_Source.GetItemString(1, "user_name")  )
				dw_body.SetItem(al_row, "rec_tel_no", lds_Source.GetItemString(1, "tel_no3")  )				
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
				cb_update.enabled = true
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

event open;call super::open;string ls_card_auto_make
	select isnull(card_auto_make,'N') 
		into :ls_card_auto_make
	from tb_91100_m a(nolock) 
	where shop_cd = :gs_shop_cd;
	
	if isnull(ls_card_auto_make) or ls_card_auto_make = 'N' then
		dw_body.object.card_no2.protect = 0
		dw_body.object.card_no2.Background.Color = rgb(255,255,255)
	else
		dw_body.object.card_no2.protect = 1
		dw_body.object.card_no2.Background.Color = rgb(192,192,192)
	end if

//   if gs_shop_cd = 'NG0009' or gs_shop_cd = 'OG0034' or gs_shop_cd = 'TB1004' then
//		  dw_head.object.quick_yn.visible = true
//	  end if

end event

type cb_close from w_com010_e`cb_close within w_sh101_s
integer x = 1403
end type

type cb_delete from w_com010_e`cb_delete within w_sh101_s
boolean visible = false
integer x = 741
end type

type cb_insert from w_com010_e`cb_insert within w_sh101_s
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh101_s
boolean visible = false
integer x = 603
integer y = 48
end type

type cb_update from w_com010_e`cb_update within w_sh101_s
boolean enabled = true
end type

type cb_print from w_com010_e`cb_print within w_sh101_s
boolean visible = false
integer x = 741
end type

type cb_preview from w_com010_e`cb_preview within w_sh101_s
boolean visible = false
integer x = 741
end type

type gb_button from w_com010_e`gb_button within w_sh101_s
integer width = 1797
end type

type dw_head from w_com010_e`dw_head within w_sh101_s
integer x = 14
integer y = 200
integer width = 1298
integer height = 108
string dataobject = "d_sh101_h20"
end type

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "jumin"     
		IF gf_jumin_chk(data) THEN
  		   Parent.Post Event ue_retrieve() 
		ELSE
			MessageBox("오류", "주민등록번호가 잘못되여 있습니다.")
			RETURN 1
		END IF
	CASE "quick_yn"	
		if data = 'Y' then
			dw_body.Setitem(1,"user_name", "아무개")
			dw_body.object.user_name.protect = 1
		elseif data = 'N' then	
			dw_body.object.user_name.protect = 0
		end if
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_sh101_s
boolean visible = false
end type

type ln_2 from w_com010_e`ln_2 within w_sh101_s
boolean visible = false
end type

type dw_body from w_com010_e`dw_body within w_sh101_s
integer x = 14
integer y = 300
integer width = 1801
integer height = 1012
boolean enabled = false
string dataobject = "d_sh101_d20"
boolean vscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "card_no2" 
		IF wf_card_chk(data) = FALSE THEN RETURN 1
   case "user_name"
			dw_body.SetRow(1)
			dw_body.SetColumn("job")
	CASE "rec_tel_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)			
	END CHOOSE

end event

event dw_body::ue_keydown;call super::ue_keydown;/*===========================================================================*/
/* 작성자      : 윤춘식                                      */	
/* 작성일      : 2002.09.26                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
//	CASE KeyEnter!
//		Send(Handle(This), 256, 9, long(0,0))
//		Return 1
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

event dw_body::constructor;call super::constructor;datawindowchild idw_job

This.GetChild("job", idw_job)
idw_job.SetTransObject(SQLCA)
idw_job.retrieve('701')
end event

type dw_print from w_com010_e`dw_print within w_sh101_s
integer x = 133
integer y = 632
end type

type st_1 from statictext within w_sh101_s
integer x = 9
integer y = 176
integer width = 1833
integer height = 1160
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

