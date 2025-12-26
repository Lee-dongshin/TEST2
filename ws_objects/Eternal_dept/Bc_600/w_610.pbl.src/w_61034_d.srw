$PBExportHeader$w_61034_d.srw
$PBExportComments$쇼핑몰경영회의
forward
global type w_61034_d from w_com010_d
end type
end forward

global type w_61034_d from w_com010_d
end type
global w_61034_d w_61034_d

type variables
string  is_yymm, is_gubun, is_brand
datawindowchild idw_brand
end variables

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")

is_gubun = dw_head.GetItemString(1, "gubun")
return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymm, is_brand, is_gubun)
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

on w_61034_d.create
call super::create
end on

on w_61034_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
//         cb_retrieve.Text = "조건(&Q)"
//         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
//   CASE 5    /* 조건 */
//      cb_retrieve.Text = "조회(&Q)"
//      cb_print.enabled = false
//      cb_preview.enabled = false
//      cb_excel.enabled = false
//      ib_changed = false
//      dw_body.Enabled = false
//      dw_head.Enabled = true
//      dw_head.SetFocus()
//      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_year, ls_season, ls_sale_div

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")



ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" 

dw_print.Modify(ls_modify)

end event

event ue_preview();///*===========================================================================*/
///* 작성자      : (주)지우정보                                                */	
///* 작성일      : 2002.01.03                                                  */	
///* 수정일      : 2002.01.03                                                  */
///*===========================================================================*/
//
//This.Trigger Event ue_title ()
//
//dw_body.ShareData(dw_print)
//dw_print.inv_printpreview.of_SetZoom()
//
end event

type cb_close from w_com010_d`cb_close within w_61034_d
end type

type cb_delete from w_com010_d`cb_delete within w_61034_d
end type

type cb_insert from w_com010_d`cb_insert within w_61034_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61034_d
end type

type cb_update from w_com010_d`cb_update within w_61034_d
end type

type cb_print from w_com010_d`cb_print within w_61034_d
end type

type cb_preview from w_com010_d`cb_preview within w_61034_d
end type

type gb_button from w_com010_d`gb_button within w_61034_d
end type

type cb_excel from w_com010_d`cb_excel within w_61034_d
end type

type dw_head from w_com010_d`dw_head within w_61034_d
integer x = 46
integer y = 196
integer width = 2290
integer height = 128
string dataobject = "d_61034_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_d`ln_1 within w_61034_d
integer beginy = 364
integer endy = 364
end type

type ln_2 from w_com010_d`ln_2 within w_61034_d
integer beginy = 368
integer endy = 368
end type

type dw_body from w_com010_d`dw_body within w_61034_d
integer y = 380
integer height = 1660
string dataobject = "d_61034_d01"
end type

type dw_print from w_com010_d`dw_print within w_61034_d
integer width = 635
string dataobject = "d_61034_r01"
end type

