$PBExportHeader$w_71011_e.srw
$PBExportComments$카드 재발급 접수
forward
global type w_71011_e from w_com010_e
end type
type dw_hidden from u_dw within w_71011_e
end type
end forward

global type w_71011_e from w_com010_e
dw_hidden dw_hidden
end type
global w_71011_e w_71011_e

type variables
String is_yymmdd, is_card_no, is_jumin

end variables

on w_71011_e.create
int iCurrent
call super::create
this.dw_hidden=create dw_hidden
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_hidden
end on

on w_71011_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_hidden)
end on

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.20                                                  */	
/* 수정일      : 2002.03.20                                                  */
/*===========================================================================*/
String     ls_card_no, ls_jumin, ls_custom_nm, ls_null, ls_shop_nm
Boolean    lb_check
DataStore  lds_Source

SetNull(ls_null)

CHOOSE CASE as_column
	CASE "card_no_h"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					RETURN 0
				END IF 
				IF gf_cust_card_chk(as_data, ls_jumin, ls_custom_nm) = TRUE THEN
				   dw_head.SetItem(al_row, "jumin_h",     ls_jumin    )
				   dw_head.SetItem(al_row, "custom_nm_h", ls_custom_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = " WHERE CARD_NO IS NOT NULL "		
			IF IsNull(as_data) = False and Trim(as_data) <> "" THEN
				gst_cd.Item_where = " CARD_NO LIKE '" + Trim(as_data) + "%' "
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
				dw_head.SetItem(al_row, "card_no_h",   lds_Source.GetItemString(1,"card_no")  )
				dw_head.SetItem(al_row, "jumin_h",     lds_Source.GetItemString(1,"jumin")    )
				dw_head.SetItem(al_row, "custom_nm_h", lds_Source.GetItemString(1,"user_name"))
				IF ai_div = 2 THEN 	
				   cb_retrieve.PostEvent(clicked!)
				END IF 
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
	CASE "jumin_h"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					RETURN 0
				END IF 
				IF gf_cust_jumin_chk(as_data, ls_custom_nm, ls_card_no) = TRUE THEN
				   dw_head.SetItem(al_row, "card_no_h",   ls_card_no  )
				   dw_head.SetItem(al_row, "custom_nm_h", ls_custom_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = " WHERE CARD_NO IS NOT NULL "		
			IF IsNull(as_data) = False and Trim(as_data) <> "" THEN
				gst_cd.Item_where = " JUMIN LIKE '" + Trim(as_data) + "%' "
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
				dw_head.SetItem(al_row, "card_no_h",   lds_Source.GetItemString(1,"card_no")  )
				dw_head.SetItem(al_row, "jumin_h",     lds_Source.GetItemString(1,"jumin")    )
				dw_head.SetItem(al_row, "custom_nm_h", lds_Source.GetItemString(1,"user_name"))
				IF ai_div = 2 THEN 	
				   cb_retrieve.PostEvent(clicked!)
				END IF 
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
	CASE "custom_nm_h"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					RETURN 0
				END IF 
				IF gf_cust_name_chk(as_data, ls_custom_nm, ls_jumin, ls_card_no) = TRUE THEN
				   dw_head.SetItem(al_row, "card_no_h", ls_card_no)
				   dw_head.SetItem(al_row, "jumin_h",   ls_jumin  )
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = " WHERE CARD_NO IS NOT NULL "		
			IF IsNull(as_data) = False and Trim(as_data) <> "" THEN
				gst_cd.Item_where = " USER_NAME LIKE '" + Trim(as_data) + "%' "
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
				dw_head.SetItem(al_row, "card_no_h",   lds_Source.GetItemString(1,"card_no")  )
				dw_head.SetItem(al_row, "jumin_h",     lds_Source.GetItemString(1,"jumin")    )
				dw_head.SetItem(al_row, "custom_nm_h", lds_Source.GetItemString(1,"user_name"))
				IF ai_div = 2 THEN 	
				   cb_retrieve.PostEvent(clicked!)
				END IF 
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
	CASE "custom_h"
			If dw_head.AcceptText() <> 1 Then Return 1
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = " WHERE CARD_NO IS NOT NULL "		
			ls_card_no   = dw_head.GetItemString(al_row, "card_no_h"  )
			ls_jumin     = dw_head.GetItemString(al_row, "jumin_h"    )
			ls_custom_nm = dw_head.GetItemString(al_row, "custom_nm_h")
			IF IsNull(ls_card_no) = False and Trim(ls_card_no) <> "" THEN
				gst_cd.Item_where = " CARD_NO LIKE '" + Trim(ls_card_no) + "%' AND "
			ELSE
				gst_cd.Item_where = ""
			END IF
			IF IsNull(ls_jumin) = False and Trim(ls_jumin) <> "" THEN
				gst_cd.Item_where = gst_cd.Item_where + " JUMIN LIKE '" + Trim(ls_jumin) + "%' AND "
			END IF
			IF IsNull(ls_custom_nm) = False and Trim(ls_custom_nm) <> "" THEN
				gst_cd.Item_where = gst_cd.Item_where + " USER_NAME LIKE '" + Trim(ls_custom_nm) + "%' "
			ELSE
				gst_cd.Item_where = LeftA(gst_cd.Item_where, LenA(gst_cd.Item_where) - 4)
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
				dw_head.SetItem(al_row, "card_no_h",   lds_Source.GetItemString(1,"card_no")  )
				dw_head.SetItem(al_row, "jumin_h",     lds_Source.GetItemString(1,"jumin")    )
				dw_head.SetItem(al_row, "custom_nm_h", lds_Source.GetItemString(1,"user_name"))
				IF ai_div = 2 THEN 	
				   cb_retrieve.PostEvent(clicked!)
				END IF 
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
	CASE "shop_cd1"				
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					RETURN 0
				END IF 
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_body.SetItem(al_row, "shop_nm1", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND <> '0' AND Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "shop_cd1", lds_Source.GetItemString(1,"shop_cd"))
				dw_body.SetItem(al_row, "shop_nm1", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("shop_cd1")
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

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.23                                                  */	
/* 수정일      : 2002.04.23                                                  */
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

is_yymmdd = Trim(String(dw_head.GetItemDate(1, "yymmdd"), 'yyyymmdd'))
if IsNull(is_yymmdd) or is_yymmdd = "" then
   MessageBox(ls_title,"접수 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_card_no = Trim(dw_head.GetItemString(1, "card_no_h"))
if IsNull(is_card_no) or is_card_no = "" then
   MessageBox(ls_title,"카드 번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("card_no_h")
   return false
end if

is_jumin = Trim(dw_head.GetItemString(1, "jumin_h"))
if IsNull(is_jumin) or is_jumin = "" then
   MessageBox(ls_title,"주민 번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jumin_h")
   return false
end if

return true

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.23                                                  */	
/* 수정일      : 2002.04.23                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_jumin)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.24                                                  */	
/* 수정일      : 2002.04.24                                                  */
/*===========================================================================*/
long ll_rows, ll_chk, ll_seq_max
datetime ld_datetime
String ls_new_card_no, ls_card_seq, ls_post_flag1, ls_shop_cd1

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

idw_status = dw_body.GetItemStatus(1, 0, Primary!)
IF idw_status = DataModified! THEN		/* Modify Record */
	ls_post_flag1 = dw_body.GetItemString(1, "post_flag1")
	If ls_post_flag1 = '2' Then
		ls_shop_cd1 = dw_body.GetItemString(1, "shop_cd1")
		If IsNull(ls_shop_cd1) or Trim(ls_shop_cd1) = "" Then
			MessageBox("저장오류", "수령매장 코드를 입력하십시요.")
			Return -1
		End If
	End If
	
	SELECT ISNULL(MAX(SEQ_NO), 0) + 1
	  INTO :ll_seq_max
	  FROM TB_71020_H
	 WHERE JUMIN = :is_jumin
	;
	If SQLCA.SQLCODE <> 0 Then
		MessageBox("저장오류", "재발급 순번 채번에 실패하였습니다.")
		Return -1
	End If
	
	ls_new_card_no = is_card_no
	Do 
		ls_card_seq = MidA(ls_new_card_no, 15, 1)
		If ls_card_seq = '9' Then
			ls_card_seq = 'A'
		Else
			ls_card_seq = CharA(AscA(ls_card_seq) + 1)
		End If
		ls_new_card_no = ReplaceA(ls_new_card_no, 15, 1, ls_card_seq)
		
		SELECT COUNT(JUMIN)
		  INTO :ll_chk
		  FROM TB_71010_M
		 WHERE CARD_NO = :ls_new_card_no
		;
		If SQLCA.SQLCODE <> 0 Then
			MessageBox("저장오류", "카드번호 중복 체크에 실패하였습니다.")
			Return -1
		End If
	Loop Until ll_chk = 0
	
	dw_body.SetItem(1, "card_no", ls_new_card_no)
	dw_body.Setitem(1, "mod_id", gs_user_id)
	dw_body.Setitem(1, "mod_dt", ld_datetime)

	dw_hidden.Reset()
	dw_hidden.InsertRow(0)
	dw_hidden.SetItem(1, "jumin", is_jumin)
	dw_hidden.SetItem(1, "seq_no", ll_seq_max)
	dw_hidden.SetItem(1, "reiss_ymd", is_yymmdd)
	dw_hidden.SetItem(1, "card_no", ls_new_card_no)
	dw_hidden.SetItem(1, "post_flag", ls_post_flag1)
	dw_hidden.SetItem(1, "shop_cd", ls_shop_cd1)
	dw_hidden.Setitem(1, "reg_id", gs_user_id)
END IF

il_rows = dw_body.Update(TRUE, FALSE)
ll_rows = dw_hidden.Update(TRUE, FALSE)

if il_rows = 1 and ll_rows = 1 then
   dw_body.ResetUpdate()
   dw_hidden.ResetUpdate()
   commit  USING SQLCA;
else
	If il_rows = 1 Then il_rows = ll_rows
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen;call super::pfc_preopen;dw_hidden.SetTransObject(SQLCA)

dw_body.InsertRow(0)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_71011_e","0")
end event

type cb_close from w_com010_e`cb_close within w_71011_e
integer taborder = 110
end type

type cb_delete from w_com010_e`cb_delete within w_71011_e
boolean visible = false
integer taborder = 60
end type

type cb_insert from w_com010_e`cb_insert within w_71011_e
boolean visible = false
integer taborder = 50
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_71011_e
end type

type cb_update from w_com010_e`cb_update within w_71011_e
integer taborder = 100
end type

type cb_print from w_com010_e`cb_print within w_71011_e
boolean visible = false
integer taborder = 70
end type

type cb_preview from w_com010_e`cb_preview within w_71011_e
boolean visible = false
integer taborder = 80
end type

type gb_button from w_com010_e`gb_button within w_71011_e
end type

type cb_excel from w_com010_e`cb_excel within w_71011_e
boolean visible = false
integer taborder = 90
end type

type dw_head from w_com010_e`dw_head within w_71011_e
integer height = 124
string dataobject = "d_71011_h01"
end type

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
Long ll_return

CHOOSE CASE dwo.name
	CASE "card_no_h", "jumin_h", "custom_nm_h"	//  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		ll_return = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		IF ll_return = 0 or ll_return = 2 THEN cb_retrieve.PostEvent(clicked!)
		return ll_return
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_71011_e
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_e`ln_2 within w_71011_e
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_e`dw_body within w_71011_e
integer y = 340
integer height = 1692
integer taborder = 40
boolean enabled = false
string dataobject = "d_71011_d01"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String ls_addr

CHOOSE CASE dwo.name
	CASE "post_flag1"
		If data = '0' Then
			ls_addr = This.GetItemString(row, "addr")
			If IsNull(ls_addr) or Trim(ls_addr) = "" Then
				MessageBox("입력불가", "자택 주소가 없습니다!")
				Return 1
			End If
		ElseIf data = '1' Then
			ls_addr = This.GetItemString(row, "addr2")
			If IsNull(ls_addr) or Trim(ls_addr) = "" Then
				MessageBox("입력불가", "직장 주소가 없습니다!")
				Return 1
			End If
		End If
	CASE "shop_cd1"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

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

type dw_print from w_com010_e`dw_print within w_71011_e
end type

type dw_hidden from u_dw within w_71011_e
boolean visible = false
integer x = 1166
integer y = 468
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_71011_d02"
end type

