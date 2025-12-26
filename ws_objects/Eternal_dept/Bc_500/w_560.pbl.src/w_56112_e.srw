$PBExportHeader$w_56112_e.srw
$PBExportComments$판매수수료회계처리(개인)
forward
global type w_56112_e from w_com010_e
end type
end forward

global type w_56112_e from w_com010_e
integer width = 3694
end type
global w_56112_e w_56112_e

type variables
DataWindowChild idw_brand
String is_brand, is_yymm
end variables

on w_56112_e.create
call super::create
end on

on w_56112_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;DateTime ld_datetime
String ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "YYYYMMDD")

dw_head.Setitem(1, "yymm", MidA(ls_datetime,1,6) )
end event

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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if
return true

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymm)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/
string ls_slip_no, ls_slip_date

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
			ls_slip_date = dw_body.GetitemString(1, "issue_date")
			ls_slip_no = dw_body.GetitemString(1, "bill_no")
			
			if isnull(ls_slip_no) OR Trim(ls_slip_no) = "" THEN
				  cb_update.enabled = true
			else
				  cb_update.enabled = false
			end if
			
			cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         cb_excel.enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

//      if al_rows >= 0 then
//         ib_changed = false
//         cb_update.enabled = false
//      end if
//		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
		   cb_excel.enabled = true
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE
end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.26                                                  */	
/* 수정일      : 2002.03.26                                                  */
/*===========================================================================*/
String ls_ErrMsg
Long   ll_sqlcode

IF MessageBox("확인", "전표 처리를 하시겠습니까 ?", Question!, YesNo! ) = 2 THEN 
	RETURN 0 
END IF

 DECLARE SP_56112_slip PROCEDURE FOR SP_56112_slip
         @brand     = :is_brand,   
         @yymm      = :is_yymm,   
         @uid       = :gs_user_id  ;

EXECUTE SP_56112_slip;

if SQLCA.SQLCODE = 0  OR SQLCA.SQLCODE = 100 then
   commit  USING SQLCA;
	il_rows = 1 
	dw_body.retrieve(is_brand, is_yymm)
	cb_update.Enabled = False

else 
	ll_sqlcode = SQLCA.SQLCODE
	ls_ErrMsg  = SQLCA.SQLErrText 
   rollback  USING SQLCA; 
	MessageBox("SQL 오류", "[" + String(ll_sqlcode) + "]" + ls_ErrMsg) 
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

type cb_close from w_com010_e`cb_close within w_56112_e
end type

type cb_delete from w_com010_e`cb_delete within w_56112_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56112_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56112_e
end type

type cb_update from w_com010_e`cb_update within w_56112_e
integer width = 649
string text = "사업소득등록(&S)"
end type

type cb_print from w_com010_e`cb_print within w_56112_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56112_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56112_e
end type

type cb_excel from w_com010_e`cb_excel within w_56112_e
end type

type dw_head from w_com010_e`dw_head within w_56112_e
integer y = 152
integer height = 180
string dataobject = "d_56112_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_e`ln_1 within w_56112_e
integer beginy = 332
integer endy = 332
end type

type ln_2 from w_com010_e`ln_2 within w_56112_e
integer beginy = 336
integer endy = 336
end type

type dw_body from w_com010_e`dw_body within w_56112_e
integer x = 18
integer y = 340
integer width = 3598
integer height = 1660
string dataobject = "d_56112_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_e`dw_print within w_56112_e
end type

