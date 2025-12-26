$PBExportHeader$w_79020_d.srw
$PBExportComments$유상비용지급조회
forward
global type w_79020_d from w_com010_d
end type
end forward

global type w_79020_d from w_com010_d
integer width = 3680
end type
global w_79020_d w_79020_d

type variables
DataWindowChild	idw_brand
String is_brand, is_fr_ymd, is_to_ymd, is_fr_receipt, is_to_receipt, is_style, is_custom_nm, is_rpt_style, is_ded_ymd
end variables

on w_79020_d.create
call super::create
end on

on w_79020_d.destroy
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


is_fr_ymd = dw_head.GetItemstring(1, "fr_ymd")
if IsNull(is_fr_ymd) or is_fr_ymd = "" then
   MessageBox(ls_title,"의뢰 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemstring(1, "to_ymd")
if IsNull(is_to_ymd) or is_to_ymd = "" then
   MessageBox(ls_title,"의뢰 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

if is_to_ymd < is_fr_ymd then
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_custom_nm = dw_head.GetItemString(1, "custom_nm")
if IsNull(is_custom_nm) or is_custom_nm = "" then
	is_custom_nm = '%'
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or is_style = "" then
	is_style = '%'
end if

is_fr_receipt = Trim(dw_head.GetItemString(1, "fr_receipt"))
if IsNull(is_fr_receipt) or is_fr_receipt = "" then
    is_fr_receipt = "00000000"
end if

is_to_receipt = Trim(dw_head.GetItemString(1, "to_receipt"))
if IsNull(is_to_receipt) or is_to_receipt = "" then
    is_to_receipt = "XXXXXXXX"
end if

is_rpt_style = Trim(dw_head.GetItemString(1, "rpt_style"))

is_ded_ymd = Trim(dw_head.GetItemString(1, "ded_ymd"))
if IsNull(is_ded_ymd) or is_ded_ymd = "" then
    is_ded_ymd = "%"
end if

//if is_rpt_style <> "D" then 
//	 is_ded_ymd = "%"
//end if	 

return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_rpt_style = "A" then
	dw_body.dataobject = "d_79020_d01"
	dw_print.dataobject = "d_79020_r01"	
	dw_body.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)
elseif is_rpt_style = "B" then
	dw_body.dataobject = "d_79020_d02"
	dw_print.dataobject = "d_79020_r02"	
	dw_body.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)
elseif is_rpt_style = "C" then
	dw_body.dataobject = "d_79020_d03"
	dw_print.dataobject = "d_79020_r03"	
	dw_body.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)
elseif is_rpt_style = "D" then
	dw_body.dataobject = "d_79020_d04"
	dw_print.dataobject = "d_79020_r04"	
	dw_body.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)
elseif is_rpt_style = "F" then
	dw_body.dataobject = "d_79020_d06"
	dw_print.dataobject = "d_79020_r06"	
	dw_body.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)
elseif is_rpt_style = "G" then
	dw_body.dataobject = "d_79020_d07"
	dw_print.dataobject = "d_79020_r07"	
	dw_body.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)
else
	dw_body.dataobject = "d_79020_d05"
	dw_print.dataobject = "d_79020_r05"	
	dw_body.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)	
end if

il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_fr_receipt, is_to_receipt,is_style, is_custom_nm, is_ded_ymd)

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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_79020_d","0")
end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
       		"t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_fr_ymd.Text  = '" + is_fr_ymd + "'" + &
				"t_to_ymd.Text   = '" + is_to_ymd + "'" + &				
				"t_fr_receipt.Text  = '" + is_fr_receipt + "'" + &
				"t_to_receipt.Text   = '" + is_to_receipt + "'" 

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_79020_d
end type

type cb_delete from w_com010_d`cb_delete within w_79020_d
end type

type cb_insert from w_com010_d`cb_insert within w_79020_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_79020_d
end type

type cb_update from w_com010_d`cb_update within w_79020_d
end type

type cb_print from w_com010_d`cb_print within w_79020_d
end type

type cb_preview from w_com010_d`cb_preview within w_79020_d
end type

type gb_button from w_com010_d`gb_button within w_79020_d
end type

type cb_excel from w_com010_d`cb_excel within w_79020_d
end type

type dw_head from w_com010_d`dw_head within w_79020_d
integer x = 14
integer width = 4713
string dataobject = "d_79020_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_d`ln_1 within w_79020_d
end type

type ln_2 from w_com010_d`ln_2 within w_79020_d
end type

type dw_body from w_com010_d`dw_body within w_79020_d
string dataobject = "d_79020_d06"
end type

type dw_print from w_com010_d`dw_print within w_79020_d
end type

