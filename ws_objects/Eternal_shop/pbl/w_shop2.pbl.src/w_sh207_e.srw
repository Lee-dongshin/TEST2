$PBExportHeader$w_sh207_e.srw
$PBExportComments$쿠폰회수
forward
global type w_sh207_e from w_com010_e
end type
end forward

global type w_sh207_e from w_com010_e
integer width = 2981
integer height = 2084
long backcolor = 16777215
end type
global w_sh207_e w_sh207_e

type variables
string   is_event_id, is_shop_cd, is_coupon_no, is_jumin, is_tel_no3, is_verify_no
DataWindowChild	idw_sale_type, idw_event_id
end variables

on w_sh207_e.create
call super::create
end on

on w_sh207_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

//if gs_shop_cd <> 'WG0023' or gs_shop_cd <> 'NG1091' then
//	messagebox("주의!", '행사진행 대상 매장이 아닙니다!')
//	return false
//end if	
//



is_event_id = dw_head.GetItemString(1, "event_id")
if IsNull(is_event_id) or Trim(is_event_id) = "" then
   MessageBox(ls_title,"행사를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("event_id")
   return false
end if
//
//is_coupon_no = dw_head.GetItemString(1, "coupon_no")
//if IsNull(is_coupon_no) or Trim(is_coupon_no) = "" then
//   MessageBox(ls_title,"상품권번호를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("coupon_no")
//   return false
//end if

is_verify_no = dw_head.GetItemString(1, "verify_no")
if IsNull(is_verify_no) or Trim(is_verify_no) = "" then
   MessageBox(ls_title,"인증번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("verify_no")
   return false
end if


is_jumin = dw_head.GetItemString(1, "jumin")
if IsNull(is_jumin) or Trim(is_jumin) = "" then
   MessageBox(ls_title,"주민번호 뒤3자리를  입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jumin")
   return false
end if

return true
end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_accept_ymd, ls_shop_nm
datetime ld_datetime

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_event_id, gs_shop_cd, is_verify_no, is_jumin)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

ls_accept_ymd  = dw_body.Getitemstring(1,"accept_ymd") 

if ls_accept_ymd <> '' and LenA(ls_accept_ymd) = 8 then 
	dw_body.object.text_message.text = "이미 회수된 상품권입니다 !"
else 
	dw_body.object.text_message.text = ""
end if

//if ls_accept_ymd = ''  or isnull(ls_accept_ymd) then 
//		/* 시스템 날짜를 가져온다 */
//		IF gf_sysdate(ld_datetime) = FALSE THEN
//		END IF
//		
//		ls_accept_ymd  = String(ld_datetime, "yyyymmdd")
//		
//		 
//		dw_body.Setitem(1, "accept_shop", gs_shop_cd)
//		dw_body.Setitem(1, "accept_ymd", ls_accept_ymd)
//		IF gf_shop_nm(gs_shop_cd, 'S', ls_shop_nm) = 0 THEN
//		   dw_body.SetItem(1, "accept_shop_nm", ls_shop_nm)
//		END IF 
//		
//end if


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
String ls_shop_cd, ls_accept_ymd, ls_sale_type, ls_verify_no, ls_chk_verify
decimal ldc_dc_rate

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
//	ls_verify_no = dw_body.getitemstring(i, "verify_no")
//	ls_chk_verify = dw_body.getitemstring(i, "chk_verify_no")	
//
//	if IsNull(ls_verify_no) or Trim(ls_verify_no) = "" then
//   ls_verify_no = "AA"
//	end if
//
//	if IsNull(ls_chk_verify) or Trim(ls_chk_verify) = "" then
//   ls_chk_verify = "AA"
//	end if
//	
//	
//	if upper(ls_verify_no) <> upper(ls_chk_verify) then // 007611쿠폰 : 인증체크 안함
//		 messagebox('경고', '쿠폰인증 번호가 다릅니다! 인증번호를 확인해주세요!')
//		 dw_body.SetFocus()
//		 dw_body.SetColumn("chk_verify")
//		 	return -1
//	end if	 
//	

	
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */			
      dw_body.Setitem(i, "dc_rate", ldc_dc_rate)			
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

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "accept_shop"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_body.SetItem(al_row, "accept_shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
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
				dw_body.SetItem(al_row, "accept_shop", lds_Source.GetItemString(1,"shop_cd"))
				dw_body.SetItem(al_row, "accept_shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("sale_type")
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

type cb_close from w_com010_e`cb_close within w_sh207_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh207_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh207_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh207_e
end type

type cb_update from w_com010_e`cb_update within w_sh207_e
end type

type cb_print from w_com010_e`cb_print within w_sh207_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh207_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh207_e
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh207_e
integer x = 41
integer y = 220
integer width = 3163
integer height = 172
string dataobject = "d_sh207_h01"
end type

event dw_head::constructor;This.GetChild("event_id", idw_event_id)
idw_event_id.SetTransObject(SQLCA)
idw_event_id.Retrieve(gs_brand)

end event

event dw_head::itemchanged;call super::itemchanged;//CHOOSE CASE dwo.name
//	CASE "event_id"      // dddw로 작성된 항목
//		if data = "0003" then
//			dw_head.setitem(1, "coupon_no","T00003")
//		end if	
//
//
//END CHOOSE
end event

type ln_1 from w_com010_e`ln_1 within w_sh207_e
end type

type ln_2 from w_com010_e`ln_2 within w_sh207_e
end type

type dw_body from w_com010_e`dw_body within w_sh207_e
string dataobject = "d_sh207_d01"
boolean hscrollbar = true
boolean livescroll = false
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve(gs_shop_cd, '%')


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

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)                                           */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
//

datetime ld_datetime
String ls_accept_ymd, ls_shop_cd, ls_shop_nm

CHOOSE CASE dwo.name
	case "accept_flag"
		dw_body.Setitem(1, "accept_shop", ls_shop_cd)
		dw_body.Setitem(1, "accept_shop_nm", ls_shop_nm)
		dw_body.Setitem(1, "accept_ymd", ls_accept_ymd)		
		if data = 'Y' then 
				/* 시스템 날짜를 가져온다 */
				IF gf_sysdate(ld_datetime) = FALSE THEN
				END IF
				
				ls_accept_ymd  = String(ld_datetime, "yyyymmdd")
				
				 
				dw_body.Setitem(1, "accept_shop", gs_shop_cd)
				dw_body.Setitem(1, "accept_ymd", ls_accept_ymd)
				IF gf_shop_nm(gs_shop_cd, 'S', ls_shop_nm) = 0 THEN
					dw_body.SetItem(1, "accept_shop_nm", ls_shop_nm)
				END IF 
				
		end if		

//	CASE "accept_shop"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
//		
//		ls_accept_ymd = dw_body.getitemstring(row, "accept_ymd")
//		
//		This.GetChild("sale_type", idw_sale_type)
//		idw_sale_type.SetTransObject(SQLCA)
//		idw_sale_type.Retrieve(data, ls_accept_ymd)

//	CASE "accept_ymd"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//	
//		ls_shop_cd = dw_body.getitemstring(row, "accept_shop")
//		
//		This.GetChild("sale_type", idw_sale_type)
//		idw_sale_type.SetTransObject(SQLCA)
//		idw_sale_type.Retrieve(ls_shop_cd, data)

		
END CHOOSE

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;String ls_accept_ymd, ls_shop_cd

CHOOSE CASE dwo.name
	CASE "sale_type" //,"accept_ymd", "accept_shop"
		ls_accept_ymd = dw_body.getitemstring(row, "accept_ymd")
		if IsNull(ls_accept_ymd) or Trim(ls_accept_ymd) = "" then
			MessageBox("경고!","회수일을 입력하십시요!")
			dw_body.SetFocus()
			dw_body.SetColumn("accept_ymd")
			return -1
		end if		
		
		ls_shop_cd    = dw_body.getitemstring(row, "accept_shop")
		if IsNull(ls_shop_cd) or Trim(ls_shop_cd) = "" then
			MessageBox("경고!","회수매장을 입력하십시요!")
			dw_body.SetFocus()
			dw_body.SetColumn("accept_shop")
			return -1
		end if
		
		This.GetChild("sale_type", idw_sale_type)
		idw_sale_type.SetTransObject(SQLCA)
		idw_sale_type.Retrieve(ls_shop_cd, ls_accept_ymd)
		
	

END CHOOSE
end event

type dw_print from w_com010_e`dw_print within w_sh207_e
end type

