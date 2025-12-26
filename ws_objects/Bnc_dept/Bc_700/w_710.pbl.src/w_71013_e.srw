$PBExportHeader$w_71013_e.srw
$PBExportComments$우편물 반송 접수
forward
global type w_71013_e from w_com010_e
end type
type dw_hidden from u_dw within w_71013_e
end type
end forward

global type w_71013_e from w_com010_e
dw_hidden dw_hidden
end type
global w_71013_e w_71013_e

type variables
String is_yymmdd, is_card_no, is_jumin

end variables

on w_71013_e.create
int iCurrent
call super::create
this.dw_hidden=create dw_hidden
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_hidden
end on

on w_71013_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_hidden)
end on

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.20                                                  */	
/* 수정일      : 2002.03.20                                                  */
/*===========================================================================*/
String     ls_card_no, ls_jumin, ls_custom_nm, ls_null
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
long ll_seq_max
datetime ld_datetime
String ls_rtn_flag1, ls_post_flag1, ls_rtn_type1, ls_rtn_ymd1

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

idw_status = dw_body.GetItemStatus(1, 0, Primary!)
IF idw_status = DataModified! THEN		/* Modify Record */
	ls_rtn_flag1 = dw_body.GetItemString(1, "rtn_flag1")
	If IsNull(ls_rtn_flag1) or Trim(ls_rtn_flag1) = "" Then
		MessageBox("저장오류", "반송 구분을 입력하십시요.")
	   dw_body.SetFocus()
		dw_body.SetColumn("rtn_flag1")
		Return -1
	End If
	ls_post_flag1 = dw_body.GetItemString(1, "post_flag1")
	If IsNull(ls_post_flag1) or Trim(ls_post_flag1) = "" Then
		MessageBox("저장오류", "우편물 수령지를 입력하십시요.")
	   dw_body.SetFocus()
		dw_body.SetColumn("post_flag1")
		Return -1
	End If
	ls_rtn_type1 = dw_body.GetItemString(1, "rtn_type1")
	If IsNull(ls_rtn_type1) or Trim(ls_rtn_type1) = "" Then
		MessageBox("저장오류", "반송 형태를 입력하십시요.")
	   dw_body.SetFocus()
		dw_body.SetColumn("rtn_type1")
		Return -1
	End If
	ls_rtn_ymd1 = dw_body.GetItemString(1, "rtn_ymd1")
	If IsNull(ls_rtn_ymd1) or Trim(ls_rtn_ymd1) = "" Then
		MessageBox("저장오류", "반송 일자를 입력하십시요.")
	   dw_body.SetFocus()
		dw_body.SetColumn("rtn_ymd1")
		Return -1
	End If
	
	SELECT ISNULL(MAX(SEQ_NO), 0) + 1
	  INTO :ll_seq_max
	  FROM TB_71040_H
	 WHERE JUMIN = :is_jumin
	;
	If SQLCA.SQLCODE <> 0 Then
		MessageBox("저장오류", "반송 순번 채번에 실패하였습니다.")
		Return -1
	End If
	
	dw_hidden.Reset()
	dw_hidden.InsertRow(0)
	dw_hidden.SetItem(1, "jumin", is_jumin)
	dw_hidden.SetItem(1, "seq_no", ll_seq_max)
	dw_hidden.SetItem(1, "yymmdd", is_yymmdd)
	dw_hidden.SetItem(1, "rtn_flag", ls_rtn_flag1)
	dw_hidden.SetItem(1, "rtn_type", ls_rtn_type1)
	dw_hidden.SetItem(1, "rtn_ymd", ls_rtn_ymd1)
	dw_hidden.SetItem(1, "post_flag", ls_post_flag1)
	dw_hidden.Setitem(1, "reg_id", gs_user_id)
END IF

il_rows = dw_hidden.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_hidden.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event pfc_preopen;call super::pfc_preopen;dw_hidden.SetTransObject(SQLCA)

dw_body.InsertRow(0)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_71013_e","0")
end event

type cb_close from w_com010_e`cb_close within w_71013_e
integer taborder = 110
end type

type cb_delete from w_com010_e`cb_delete within w_71013_e
boolean visible = false
integer taborder = 60
end type

type cb_insert from w_com010_e`cb_insert within w_71013_e
boolean visible = false
integer taborder = 50
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_71013_e
end type

type cb_update from w_com010_e`cb_update within w_71013_e
integer taborder = 100
end type

type cb_print from w_com010_e`cb_print within w_71013_e
boolean visible = false
integer taborder = 70
end type

type cb_preview from w_com010_e`cb_preview within w_71013_e
boolean visible = false
integer taborder = 80
end type

type gb_button from w_com010_e`gb_button within w_71013_e
end type

type cb_excel from w_com010_e`cb_excel within w_71013_e
boolean visible = false
integer taborder = 90
end type

type dw_head from w_com010_e`dw_head within w_71013_e
integer height = 124
string dataobject = "d_71013_h01"
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
	CASE "rtn_ymd1"
		If gf_datechk(data) = False Then Return 1
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_71013_e
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_e`ln_2 within w_71013_e
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_e`dw_body within w_71013_e
integer y = 348
integer height = 1692
integer taborder = 40
boolean enabled = false
string dataobject = "d_71013_d01"
boolean vscrollbar = false
boolean livescroll = false
end type

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

event dw_body::constructor;DataWindowChild ldw_child

This.GetChild("rtn_type1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('703')

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String ls_addr

CHOOSE CASE dwo.name
	CASE "rtn_ymd1"
		If gf_datechk(data) = False Then Return 1
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
END CHOOSE


end event

type dw_print from w_com010_e`dw_print within w_71013_e
end type

type dw_hidden from u_dw within w_71013_e
boolean visible = false
integer x = 1166
integer y = 468
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_71013_d02"
end type

