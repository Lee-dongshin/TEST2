$PBExportHeader$w_56115_d.srw
$PBExportComments$백화점마일리지현황
forward
global type w_56115_d from w_com010_d
end type
end forward

global type w_56115_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_56115_d w_56115_d

type variables
String is_brand, is_shop_cd, is_fr_yymm, is_to_yymm
DataWindowChild idw_brand
end variables

on w_56115_d.create
call super::create
end on

on w_56115_d.destroy
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shoP_cd = "%"
end if

is_fr_yymm = dw_head.GetItemString(1, "fr_yymm")
if IsNull(is_fr_yymm) or Trim(is_fr_yymm) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymm")
   return false
end if

is_to_yymm = dw_head.GetItemString(1, "to_yymm")
if IsNull(is_to_yymm) or Trim(is_to_yymm) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if LenA(is_shop_cd) > 1 and is_shop_cd <> "%" then
	dw_body.DataObject = "d_56115_d02"
   dw_print.DataObject = "d_56115_r02"
else	
	dw_body.DataObject = "d_56115_d01"
   dw_print.DataObject = "d_56115_r01"
end if	

dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_fr_yymm, is_to_yymm, is_brand, is_shop_cd)
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56115_d","0")
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
				dw_head.SetColumn("fr_yymm")
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

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	 "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
             "t_brand.Text = '" + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_fr_yymm.Text = '" + is_fr_yymm + "'" + &
             "t_to_yymm.Text = '" + is_to_yymm + "'" 

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_56115_d
end type

type cb_delete from w_com010_d`cb_delete within w_56115_d
end type

type cb_insert from w_com010_d`cb_insert within w_56115_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56115_d
end type

type cb_update from w_com010_d`cb_update within w_56115_d
end type

type cb_print from w_com010_d`cb_print within w_56115_d
end type

type cb_preview from w_com010_d`cb_preview within w_56115_d
end type

type gb_button from w_com010_d`gb_button within w_56115_d
end type

type cb_excel from w_com010_d`cb_excel within w_56115_d
end type

type dw_head from w_com010_d`dw_head within w_56115_d
integer y = 156
integer height = 188
string dataobject = "d_56115_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if LenA(data) > 1 then
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		end if	
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_56115_d
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_d`ln_2 within w_56115_d
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_d`dw_body within w_56115_d
integer y = 356
integer height = 1684
string dataobject = "d_56115_d01"
end type

type dw_print from w_com010_d`dw_print within w_56115_d
string dataobject = "d_56115_r01"
end type

