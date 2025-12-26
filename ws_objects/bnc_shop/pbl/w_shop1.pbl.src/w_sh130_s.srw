$PBExportHeader$w_sh130_s.srw
$PBExportComments$판매일보등록[WDOT고객등록]
forward
global type w_sh130_s from w_com010_e
end type
type st_1 from statictext within w_sh130_s
end type
end forward

global type w_sh130_s from w_com010_e
integer width = 1819
integer height = 1076
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_closeparm ( )
st_1 st_1
end type
global w_sh130_s w_sh130_s

type variables
String  is_jumin, is_area_cd , is_email , is_email1 , is_email2, is_tel_no3, is_tel_no3a, is_tel_no3b, is_tel_no3c
integer il_sex
String  is_tel_no1, is_tel_no1a, is_tel_no1b, is_tel_no1c
end variables

forward prototypes
public function boolean wf_card_chk (string as_card_no)
end prototypes

event ue_closeparm();
CloseWithReturn(This, is_jumin)

end event

public function boolean wf_card_chk (string as_card_no);String ls_card_no 
Long   ll_cnt 

IF LenA(Trim(as_card_no)) <> 9  THEN RETURN FALSE 
IF match(as_card_no, "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][12]") = FALSE THEN 
	MessageBox("확인", "카드번호 오류 !") 
	dw_body.SetFocus()
	RETURN FALSE
END IF
ls_card_no = "1128003" + as_card_no

SELECT count(card_no) 
  INTO :ll_cnt 
  FROM TB_72010_M 
 WHERE card_no = :ls_card_no;

IF ll_cnt > 0 THEN 
	MessageBox("확인", "이미 등록된 카드번호 입니다 !")
	RETURN FALSE
END IF

dw_body.Setitem(1, "card_no", ls_card_no)

RETURN TRUE 


end function

on w_sh130_s.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_sh130_s.destroy
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
 
   ls_tel_no3 = dw_body.GetItemString(1,"tel_no3")
  
	
	if LenA(ls_tel_no3) = 12 then
			ls_tel_no3a = LeftA(ls_tel_no3,3)
			ls_tel_no3b = MidA(ls_tel_no3,5,3)
			ls_tel_no3c = RightA(ls_tel_no3,4)
			
			dw_body.SetItem(1,"tel_no3a",ls_tel_no3a)
			dw_body.SetItem(1,"tel_no3b",ls_tel_no3b)
			dw_body.SetItem(1,"tel_no3c",ls_tel_no3c)
	ElseIf LenA(ls_tel_no3) = 13 then
			ls_tel_no3a = LeftA(ls_tel_no3,3)
			ls_tel_no3b = MidA(ls_tel_no3,5,4)
			ls_tel_no3c = RightA(ls_tel_no3,4)
			
			dw_body.SetItem(1,"tel_no3a",ls_tel_no3a)
			dw_body.SetItem(1,"tel_no3b",ls_tel_no3b)
			dw_body.SetItem(1,"tel_no3c",ls_tel_no3c)
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

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_tot_point, ll_event_point
datetime ld_datetime 
String   ls_card_no, ls_zipcode, ls_yymmdd, ls_area_cd

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1 



ls_card_no = dw_body.GetitemString(1, "card_no") 
IF isnull(ls_card_no) OR LenA(ls_card_no) <> 16 THEN 
	MessageBox("오류", "카드번호를 확인하세요")
	dw_body.SetColumn("card_no2")
	RETURN -1 
END IF

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_yymmdd = String(ld_datetime, "yyyymmdd") 

// 이메일 구하기

is_tel_no3a = dw_body.GetitemString(1, "tel_no3a")
is_tel_no3b = dw_body.GetitemString(1, "tel_no3b")
is_tel_no3c = dw_body.GetitemString(1, "tel_no3c")


IF is_tel_no3a <> '' and is_tel_no3b <> '' and is_tel_no3c <> '' THEN
	is_tel_no3 = is_tel_no3a + "-" + is_tel_no3b + "-" + is_tel_no3c
ELSE
	is_tel_no3 = ''
END if



FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "jumin",   is_jumin)
      dw_body.Setitem(i, "sex",     il_sex)	
		dw_body.Setitem(i, "tel_no3",   is_tel_no3)
		
		IF gf_area_cd(gs_shop_cd,ls_area_cd) = TRUE THEN
				dw_body.SetItem(i, "area", ls_area_cd)
			END IF			
		
		IF dw_body.GetItemStatus(i, "card_no", Primary!) = DataModified! THEN
         dw_body.Setitem(i, "shop_cd",       gs_shop_cd)
         dw_body.Setitem(i, "card_day",      String(ld_datetime, "yyyymmdd"))

		END IF
      dw_body.Setitem(i, "reg_id",  gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		IF dw_body.GetItemStatus(i, "card_no", Primary!) = DataModified! THEN
         dw_body.Setitem(i, "shop_cd", gs_shop_cd)
         dw_body.Setitem(i, "card_day", String(ld_datetime, "yyyymmdd"))       			 

		END IF
		
		IF gf_area_cd(gs_shop_cd,ls_area_cd) = TRUE THEN
				dw_body.SetItem(i, "area", ls_area_cd)
			END IF						
			
		dw_body.Setitem(i, "tel_no3",   is_tel_no3)		
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

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 윤춘식                                     */	
/* 작성일      : 2002.09.26                                                  */	
/* 수정일      : 2002.09.26(윤춘식)                                          */
/*===========================================================================*/
String     ls_zipcode, ls_addr  
Boolean    lb_check 
DataStore  lds_Source

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

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF


RETURN 0

end event

type cb_close from w_com010_e`cb_close within w_sh130_s
integer x = 1403
end type

type cb_delete from w_com010_e`cb_delete within w_sh130_s
boolean visible = false
integer x = 741
end type

type cb_insert from w_com010_e`cb_insert within w_sh130_s
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh130_s
boolean visible = false
integer x = 603
integer y = 48
end type

type cb_update from w_com010_e`cb_update within w_sh130_s
end type

type cb_print from w_com010_e`cb_print within w_sh130_s
boolean visible = false
integer x = 741
end type

type cb_preview from w_com010_e`cb_preview within w_sh130_s
boolean visible = false
integer x = 741
end type

type gb_button from w_com010_e`gb_button within w_sh130_s
integer width = 1797
end type

type dw_head from w_com010_e`dw_head within w_sh130_s
integer x = 27
integer y = 200
integer width = 1088
integer height = 108
string dataobject = "d_sh101_h20"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
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
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_sh130_s
boolean visible = false
end type

type ln_2 from w_com010_e`ln_2 within w_sh130_s
boolean visible = false
end type

type dw_body from w_com010_e`dw_body within w_sh130_s
integer x = 27
integer y = 304
integer width = 1751
integer height = 652
boolean enabled = false
string dataobject = "d_sh130_d20"
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

type dw_print from w_com010_e`dw_print within w_sh130_s
integer x = 251
integer y = 612
end type

type st_1 from statictext within w_sh130_s
integer x = 9
integer y = 176
integer width = 1792
integer height = 784
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

