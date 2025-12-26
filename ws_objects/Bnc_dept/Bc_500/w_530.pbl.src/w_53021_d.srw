$PBExportHeader$w_53021_d.srw
$PBExportComments$타브랜드인기상품조회
forward
global type w_53021_d from w_com010_d
end type
end forward

global type w_53021_d from w_com010_d
end type
global w_53021_d w_53021_d

type variables
DataWindowChild	idw_vs_brand
String is_brand, is_yymm, is_week_no
end variables

on w_53021_d.create
call super::create
end on

on w_53021_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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

is_brand = dw_head.GetItemString(1, "vs_brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("vs_brand")
end if

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
 is_yymm = "%"
end if

is_week_no = dw_head.GetItemString(1, "week_no")
if IsNull(is_week_no) or Trim(is_week_no) = "" then
 is_week_no = "%"
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN



il_rows = dw_body.retrieve(is_brand, is_yymm, is_week_no)
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

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime, ls_yymm, ls_week_no

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_yymm = "%" then
	ls_yymm = "% 전체월"
else 
	ls_yymm = is_yymm
end if	

if is_week_no = "%" then
	ls_week_no = "% 전체주"
else 
	ls_week_no = is_week_no	
end if	

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify = "t_yymm.Text = '" + ls_yymm + "'" + &
            "t_week_no.Text = '" + ls_week_no + "'" 
				 

dw_print.Modify(ls_modify)


end event

event ue_preview();
This.Trigger Event ue_title ()

dw_print.retrieve(is_brand, is_yymm, is_week_no)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();This.Trigger Event ue_title()

dw_print.retrieve(is_brand, is_yymm, is_week_no)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53021_d","0")
end event

type cb_close from w_com010_d`cb_close within w_53021_d
end type

type cb_delete from w_com010_d`cb_delete within w_53021_d
end type

type cb_insert from w_com010_d`cb_insert within w_53021_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_53021_d
end type

type cb_update from w_com010_d`cb_update within w_53021_d
end type

type cb_print from w_com010_d`cb_print within w_53021_d
end type

type cb_preview from w_com010_d`cb_preview within w_53021_d
end type

type gb_button from w_com010_d`gb_button within w_53021_d
end type

type cb_excel from w_com010_d`cb_excel within w_53021_d
end type

type dw_head from w_com010_d`dw_head within w_53021_d
integer y = 156
integer width = 3305
integer height = 180
string dataobject = "d_53021_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("vs_brand", idw_vs_brand )
idw_vs_brand.SetTransObject(SQLCA)
idw_vs_brand.Retrieve('040')
idw_vs_brand.insertrow(1)
idw_vs_brand.SetItem(1,'inter_cd','%')
idw_vs_brand.SetItem(1,'inter_nm','전체')


end event

type ln_1 from w_com010_d`ln_1 within w_53021_d
integer beginy = 336
integer endy = 336
end type

type ln_2 from w_com010_d`ln_2 within w_53021_d
integer beginy = 340
integer endy = 340
end type

type dw_body from w_com010_d`dw_body within w_53021_d
integer y = 348
integer width = 3593
integer height = 1664
string dataobject = "d_53021_d01"
end type

type dw_print from w_com010_d`dw_print within w_53021_d
string dataobject = "d_53021_r01"
end type

