$PBExportHeader$w_43035_d.srw
$PBExportComments$부자재재고조회
forward
global type w_43035_d from w_com010_d
end type
end forward

global type w_43035_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_43035_d w_43035_d

type variables
DataWindowChild idw_brand
String is_brand, is_fr_ymd, is_to_ymd, is_mat_cd, is_opt_gift
end variables

on w_43035_d.create
call super::create
end on

on w_43035_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_cust_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column

	CASE "mat_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				If IsNull(as_data) or Trim(as_data) = "" Then
				   dw_head.SetItem(al_row, "mat_nm", "")
					RETURN 0
				END IF 
				
				//N2XXZ
				
				IF LeftA(as_data, 5) = is_brand + '2XXZ' and gf_mat_nm(as_data, ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "mat_nm", ls_cust_nm)
					RETURN 0
				END IF
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "부자재 코드 검색" 
			gst_cd.datawindow_nm   = "d_com913" 
			gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' and mat_cd like '_2XXZ%' "			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "MAT_CD LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
				dw_head.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
//				dw_head.SetColumn("end_ymd")
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

is_opt_gift = dw_head.GetItemString(1, "opt_gift")

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


if is_opt_gift = "N" then
	is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
	if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
		MessageBox(ls_title,"시작일자를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("fr_ymd")
		return false
	end if
	
	is_to_ymd = dw_head.GetItemString(1, "to_ymd")
	if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
		MessageBox(ls_title,"마지막일자를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("to_ymd")
		return false
	end if
	
	is_mat_cd = dw_head.GetItemString(1, "mat_cd")
	if IsNull(is_mat_cd) or Trim(is_mat_cd) = "" then
	  is_mat_cd = "%"
	end if
end if

return true
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43035_d","0")
end event

event ue_retrieve();call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_opt_gift = "N" then
	
	dw_print.dataobject = "d_43035_r01"
	dw_print.SetTransObject(SQLCA)
	
	dw_body.dataobject = "d_43035_d01"
	dw_body.SetTransObject(SQLCA)
	il_rows = dw_body.retrieve(is_fr_ymd ,is_to_ymd, is_mat_cd,is_brand )
else	
	
	dw_print.dataobject = "d_43035_r02"
	dw_print.SetTransObject(SQLCA)	
	
	dw_body.dataobject = "d_43035_d02"
	dw_body.SetTransObject(SQLCA)
	il_rows = dw_body.retrieve(is_brand )
end if


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

event ue_title();call super::ue_title;//datetime ld_datetime
datetime ld_datetime
string ls_modify, ls_datetime,ls_title, ls_mat_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_mat_cd = "%" then
 ls_mat_nm = "% 전체"
else
 ls_mat_nm = is_mat_cd + " " + dw_head.getitemstring(1, "mat_nm")
end if

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

if is_opt_gift = "N" then

	ls_modify  = "t_pg_id.Text = '" + is_pgm_id + "'" + &
					 "t_user_id.Text = '" + gs_user_id + "'" + &
					 "t_datetime.Text = '" + ls_datetime + "'" + &
					 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					 "t_fr_ymd.Text = '" + String(is_fr_ymd, '@@@@/@@/@@') + "'" + &
					 "t_to_ymd.Text = '" + String(is_to_ymd, '@@@@/@@/@@') + "'" + &				 
					 "t_mat_cd.Text = '" + ls_mat_nm  + "'"  
					 
else					
		ls_modify  = "t_pg_id.Text = '" + is_pgm_id + "'" + &
					 "t_user_id.Text = '" + gs_user_id + "'" + &
					 "t_datetime.Text = '" + ls_datetime + "'" + &
					 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" 
end if					 

dw_print.Modify(ls_modify)

end event

type cb_close from w_com010_d`cb_close within w_43035_d
end type

type cb_delete from w_com010_d`cb_delete within w_43035_d
end type

type cb_insert from w_com010_d`cb_insert within w_43035_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43035_d
end type

type cb_update from w_com010_d`cb_update within w_43035_d
end type

type cb_print from w_com010_d`cb_print within w_43035_d
end type

type cb_preview from w_com010_d`cb_preview within w_43035_d
end type

type gb_button from w_com010_d`gb_button within w_43035_d
end type

type cb_excel from w_com010_d`cb_excel within w_43035_d
end type

type dw_head from w_com010_d`dw_head within w_43035_d
integer y = 164
integer height = 176
string dataobject = "D_43035_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
		CASE "mat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_43035_d
integer beginy = 340
integer endy = 340
end type

type ln_2 from w_com010_d`ln_2 within w_43035_d
integer beginy = 344
integer endy = 344
end type

type dw_body from w_com010_d`dw_body within w_43035_d
integer y = 360
integer height = 1680
string dataobject = "D_43035_D01"
end type

type dw_print from w_com010_d`dw_print within w_43035_d
string dataobject = "D_43035_r01"
end type

