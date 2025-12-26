$PBExportHeader$w_73004_d.srw
$PBExportComments$카드회원 등록 현황
forward
global type w_73004_d from w_com010_d
end type
end forward

global type w_73004_d from w_com010_d
end type
global w_73004_d w_73004_d

type variables
DataWindowChild idw_brand

String is_brand, is_fr_ymd, is_to_ymd, is_vip

end variables

on w_73004_d.create
call super::create
end on

on w_73004_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.11                                                  */	
/* 수정일      : 2002.04.11                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd)

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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.11                                                  */	
/* 수정일      : 2002.04.11                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_fr_ymd = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
if IsNull(is_fr_ymd) or is_fr_ymd = "" then
   MessageBox(ls_title,"가입 기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
if IsNull(is_to_ymd) or is_to_ymd = "" then
   MessageBox(ls_title,"가입 기간을 입력하십시요!")
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

is_vip = Trim(dw_head.GetItemString(1, "vip"))

return true

end event

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.11                                                  */	
/* 수정일      : 2002.04.11                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_vip

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_vip = '2' then
	ls_vip = 'VIP 회원'
else 
	ls_vip = '전체회원'
end if


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id + "'" + &
            "t_user_id.Text  = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_yymmdd.Text   = '" + String(is_fr_ymd + is_to_ymd, '@@@@/@@/@@ ~~ @@@@/@@/@@') + "'" + &
				"t_vip.Text = '" + ls_vip + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_73004_d","0")
end event

type cb_close from w_com010_d`cb_close within w_73004_d
end type

type cb_delete from w_com010_d`cb_delete within w_73004_d
end type

type cb_insert from w_com010_d`cb_insert within w_73004_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_73004_d
end type

type cb_update from w_com010_d`cb_update within w_73004_d
end type

type cb_print from w_com010_d`cb_print within w_73004_d
end type

type cb_preview from w_com010_d`cb_preview within w_73004_d
end type

type gb_button from w_com010_d`gb_button within w_73004_d
end type

type cb_excel from w_com010_d`cb_excel within w_73004_d
end type

type dw_head from w_com010_d`dw_head within w_73004_d
integer height = 124
string dataobject = "d_73004_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertrow(1)
idw_brand.Setitem(1, "inter_cd", "%")
idw_brand.Setitem(1, "inter_nm", "전체")

end event

type ln_1 from w_com010_d`ln_1 within w_73004_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_73004_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_73004_d
integer y = 348
integer height = 1692
string dataobject = "d_73004_d01"
end type

type dw_print from w_com010_d`dw_print within w_73004_d
integer x = 160
integer y = 360
string dataobject = "d_73004_r01"
end type

