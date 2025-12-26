$PBExportHeader$w_sh218_e.srw
$PBExportComments$고객내역추가입력
forward
global type w_sh218_e from w_com020_e
end type
end forward

global type w_sh218_e from w_com020_e
integer width = 2976
integer height = 2072
end type
global w_sh218_e w_sh218_e

type variables
String is_card_no, is_cust_name, is_jumin

String  is_email , is_email1 , is_email2, is_tel_no3, is_tel_no3a, is_tel_no3b, is_tel_no3c
String  is_tel_no1, is_tel_no1a, is_tel_no1b, is_tel_no1c
end variables

forward prototypes
public function integer wf_tel_no_chk (string as_tel_no, ref string as_card_no, ref string as_user_name, ref string as_tel_no3)
end prototypes

public function integer wf_tel_no_chk (string as_tel_no, ref string as_card_no, ref string as_user_name, ref string as_tel_no3);long ls_cnt

SELECT COUNT(JUMIN)
  INTO :ls_cnt
  FROM TB_71010_M
 WHERE tel_no3 = :as_tel_no;

IF ls_cnt = 1 Then
	SELECT CARD_NO, user_name, tel_no3
	  INTO :as_card_no, :As_user_name, :as_tel_no3
	  FROM TB_71010_M
	WHERE tel_no3 = :as_tel_no;
	RETURN 0
end if

end function

on w_sh218_e.create
call super::create
end on

on w_sh218_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_keycheck;String   ls_title

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

is_card_no = dw_head.GetItemString(1, "card_no")
is_cust_name = dw_head.GetItemString(1, "cust_name")

return true
end event

event ue_retrieve;call super::ue_retrieve;IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_card_no, is_cust_name, gs_shop_cd)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_update;long i, ll_row_count, ll_tot_point, ll_event_point
datetime ld_datetime 
String   ls_card_no, ls_zipcode, ls_yymmdd, ls_tel_no3, ls_post_flag, ls_addrv, ls_addrv_s, ls_tel_no3a, ls_user_name

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1 

ls_user_name = dw_body.GetitemString(1, "user_name")
ls_zipcode = dw_body.GetitemString(1, "zipcode_v") 
ls_post_flag = dw_body.GetitemString(1, "post_flag") 
ls_addrv = dw_body.GetitemString(1, "addrv") 
ls_addrv_s = dw_body.GetitemString(1, "addrv_s") 
ls_tel_no3a = dw_body.GetitemString(1, "tel_no3a") 

if ls_user_name = '아무개' then
	MessageBox("오류", "회원명을 수정해주세요!")
	dw_body.SetColumn("user_name")
	RETURN -1 
END IF	

IF isnull(ls_zipcode) OR LenA(ls_zipcode) <> 7 THEN 
	MessageBox("오류", "우편번호를 검색하여 정확히 입력하세요!")
	dw_body.SetColumn("zipcode")
	RETURN -1 
END IF

if isnull(ls_tel_no3a) then
	MessageBox("오류", "통신회사 번호를 선택하세요!")
	dw_body.SetColumn("tel_no3a")
	RETURN -1 	
END IF	

IF trim(ls_tel_no3a) <> "010" THEN 
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

IF isnull(ls_post_flag) OR LenA(ls_post_flag) = 0 THEN 
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

ls_tel_no3 = dw_body.GetitemString(1, "tel_no3a") + dw_body.GetitemString(1, "tel_no3b") + dw_body.GetitemString(1, "tel_no3c")

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

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
		dw_body.Setitem(i, "email",   is_email)
		dw_body.Setitem(i, "tel_no3",   is_tel_no3)
		dw_body.Setitem(i, "tel_no1",   is_tel_no1)			
      dw_body.Setitem(i, "reg_id",  gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		dw_body.Setitem(i, "email",   is_email)
		dw_body.Setitem(i, "tel_no3",   is_tel_no3)
		dw_body.Setitem(i, "tel_no1",   is_tel_no1)		
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if
SQLCA.Lock = "RC"
	
This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows





end event

event ue_popup;call super::ue_popup;String     ls_zipcode, ls_addr, ls_card_no, ls_user_name, ls_rec_tel_no
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

type cb_close from w_com020_e`cb_close within w_sh218_e
end type

type cb_delete from w_com020_e`cb_delete within w_sh218_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_sh218_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_sh218_e
end type

type cb_update from w_com020_e`cb_update within w_sh218_e
end type

type cb_print from w_com020_e`cb_print within w_sh218_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_sh218_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_sh218_e
end type

type dw_head from w_com020_e`dw_head within w_sh218_e
integer height = 180
string dataobject = "d_sh218_h01"
end type

type ln_1 from w_com020_e`ln_1 within w_sh218_e
integer beginy = 356
integer endy = 356
end type

type ln_2 from w_com020_e`ln_2 within w_sh218_e
integer beginy = 356
integer endy = 356
end type

type dw_list from w_com020_e`dw_list within w_sh218_e
integer y = 380
integer width = 823
integer height = 1440
string dataobject = "d_sh218_d01"
end type

event dw_list::clicked;String ls_email1, ls_email2, ls_email, ls_tel_no3a, ls_tel_no3b, ls_tel_no3c, ls_tel_no3,ls_birthday
sTRING ls_tel_no1a, ls_tel_no1b, ls_tel_no1c, ls_tel_no1
Long ll_pos, ll_len_str

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_jumin = This.GetItemString(row, 'jumin') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_jumin) THEN return
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
	
END IF

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)




end event

type dw_body from w_com020_e`dw_body within w_sh218_e
integer x = 873
integer y = 380
integer width = 2002
integer height = 1440
string dataobject = "d_sh218_d02"
end type

event dw_body::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
   case "user_name"
			dw_body.SetRow(1)
			dw_body.SetColumn("job")
	CASE "rec_tel_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)			
	END CHOOSE
end event

event dw_body::ue_keydown;call super::ue_keydown;String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
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

type st_1 from w_com020_e`st_1 within w_sh218_e
integer x = 837
end type

type dw_print from w_com020_e`dw_print within w_sh218_e
end type

