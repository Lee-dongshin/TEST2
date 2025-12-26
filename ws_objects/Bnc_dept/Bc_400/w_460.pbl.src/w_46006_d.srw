$PBExportHeader$w_46006_d.srw
$PBExportComments$부자재공제내역
forward
global type w_46006_d from w_com010_d
end type
end forward

global type w_46006_d from w_com010_d
end type
global w_46006_d w_46006_d

type variables
DataWindowChild idw_brand
string is_fr_ymd, is_to_ymd, is_shop_cd, is_apply_yymm, is_rpt_gubn, is_brand

end variables

on w_46006_d.create
call super::create
end on

on w_46006_d.destroy
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
	is_shop_cd  = "%"	
end if

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
is_to_ymd = dw_head.GetItemString(1, "to_ymd")
is_apply_yymm = dw_head.GetItemString(1, "yymm")

is_rpt_gubn = dw_head.GetItemString(1, "rpt_opt")

if is_rpt_gubn = "A" then
	is_apply_yymm = "%"
else	
	is_fr_ymd = "20140101"
	is_to_ymd = "99999999"
end if	

return true

end event

event ue_retrieve();call super::ue_retrieve;IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_apply_yymm, is_shop_cd, is_brand)
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

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_opt_chi, ls_fr_ymd, ls_to_ymd

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

if is_rpt_gubn = "B" then
	ls_fr_ymd = "전체"
	ls_to_ymd = "전체"
end if	

ls_modify =		"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_fr_ymd.Text = '" + ls_fr_ymd + "'" + &
					"t_to_ymd.Text = '" + ls_to_ymd + "'" 


dw_print.Modify(ls_modify)


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
String 	  ls_plan_yn, ls_SHOP_TYPE,ls_work_gubn, ls_gubn
Boolean    lb_check 
long  ll_row
DataStore  lds_Source
long ll_row1
string ls_mat_cd,  ls_mat_nm
decimal ldc_price

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm3(as_data, 'S', ls_shop_nm) = 0 THEN
					
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
											 "  AND BRAND = '" + ls_brand + "'"
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
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

type cb_close from w_com010_d`cb_close within w_46006_d
end type

type cb_delete from w_com010_d`cb_delete within w_46006_d
end type

type cb_insert from w_com010_d`cb_insert within w_46006_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_46006_d
end type

type cb_update from w_com010_d`cb_update within w_46006_d
end type

type cb_print from w_com010_d`cb_print within w_46006_d
end type

type cb_preview from w_com010_d`cb_preview within w_46006_d
end type

type gb_button from w_com010_d`gb_button within w_46006_d
end type

type cb_excel from w_com010_d`cb_excel within w_46006_d
end type

type dw_head from w_com010_d`dw_head within w_46006_d
string dataobject = "d_46006_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_46006_d
end type

type ln_2 from w_com010_d`ln_2 within w_46006_d
end type

type dw_body from w_com010_d`dw_body within w_46006_d
string dataobject = "d_46006_d01"
end type

type dw_print from w_com010_d`dw_print within w_46006_d
string dataobject = "d_46006_r01"
end type

