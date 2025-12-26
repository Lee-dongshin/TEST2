$PBExportHeader$w_47006_d.srw
$PBExportComments$반품 운송비 조회
forward
global type w_47006_d from w_com010_d
end type
end forward

global type w_47006_d from w_com010_d
end type
global w_47006_d w_47006_d

type variables
String is_fr_ord_ymd, is_to_ord_ymd, is_shop_cd, is_fr_rtrn_ymd, is_to_rtrn_ymd,  is_rtrn_stat,  is_mall_gubn

end variables

on w_47006_d.create
call super::create
end on

on w_47006_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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




is_rtrn_stat = dw_head.GetItemString(1, "gubn")
if IsNull(is_rtrn_stat) or Trim(is_rtrn_stat) = "" then
   MessageBox(ls_title,"반품상태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubn")
   return false
end if

is_fr_ord_ymd = dw_head.GetItemString(1, "fr_ord_ymd")
if IsNull(is_fr_ord_ymd) or Trim(is_fr_ord_ymd) = "" then
	is_fr_ord_ymd = "00000000"
//   MessageBox(ls_title,"주문일자를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("fr_ord_ymd")
//   return false
end if

is_to_ord_ymd = dw_head.GetItemString(1, "to_ord_ymd")
if IsNull(is_to_ord_ymd) or Trim(is_to_ord_ymd) = "" then
   is_to_ord_ymd = "99999999"
//   MessageBox(ls_title,"주문일자를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("to_ord_ymd")
//   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shoP_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = "%"
end if


is_fr_rtrn_ymd = dw_head.GetItemString(1, "fr_rtrn_ymd")
if IsNull(is_fr_rtrn_ymd) or Trim(is_fr_rtrn_ymd) = "" then
   MessageBox(ls_title,"반품일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_rtrn_ymd")
   return false
end if

is_to_rtrn_ymd = dw_head.GetItemString(1, "to_rtrn_ymd")
if IsNull(is_to_rtrn_ymd) or Trim(is_to_rtrn_ymd) = "" then
   MessageBox(ls_title,"반품일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_rtrn_ymd")
   return false
end if


is_mall_gubn = dw_head.GetItemString(1, "mall_gubn")

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
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
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
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

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_ord_ymd, is_to_ord_ymd, is_shop_cd, is_rtrn_stat, is_fr_rtrn_ymd, is_to_rtrn_ymd, is_mall_gubn)
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

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

//dw_head.SetItem(1, "fr_ord_ymd" ,string(ld_datetime,"yyyymmdd"))
//dw_head.SetItem(1, "to_ord_ymd" ,string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "fr_rtrn_ymd" ,string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "to_rtrn_ymd" ,string(ld_datetime,"yyyymmdd"))
end event

type cb_close from w_com010_d`cb_close within w_47006_d
end type

type cb_delete from w_com010_d`cb_delete within w_47006_d
end type

type cb_insert from w_com010_d`cb_insert within w_47006_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_47006_d
end type

type cb_update from w_com010_d`cb_update within w_47006_d
end type

type cb_print from w_com010_d`cb_print within w_47006_d
end type

type cb_preview from w_com010_d`cb_preview within w_47006_d
end type

type gb_button from w_com010_d`gb_button within w_47006_d
end type

type cb_excel from w_com010_d`cb_excel within w_47006_d
end type

type dw_head from w_com010_d`dw_head within w_47006_d
integer height = 228
string dataobject = "d_47006_h01"
end type

event dw_head::itemchanged;call super::itemchanged;int li_ret
string ls_brand, ls_year, ls_season

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if LenA(data) <> 0 then 
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		else 
			dw_head.setitem(1, "shop_nm","")
		end if
			
END CHOOSE
//
end event

type ln_1 from w_com010_d`ln_1 within w_47006_d
integer beginx = 32
integer beginy = 412
integer endx = 3653
integer endy = 412
end type

type ln_2 from w_com010_d`ln_2 within w_47006_d
integer beginy = 416
integer endy = 416
end type

type dw_body from w_com010_d`dw_body within w_47006_d
integer y = 428
integer height = 1612
string dataobject = "d_47006_d01"
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_proc_stat, ldw_rtrn_stat, ldw_rtrn_reason


This.GetChild("rtrn_stat", ldw_rtrn_stat)
ldw_rtrn_stat.SetTransObject(SQLCA)
ldw_rtrn_stat.Retrieve('044')

This.GetChild("rtrn_reason", ldw_rtrn_reason)
ldw_rtrn_reason.SetTransObject(SQLCA)
ldw_rtrn_reason.Retrieve('045')

end event

type dw_print from w_com010_d`dw_print within w_47006_d
end type

