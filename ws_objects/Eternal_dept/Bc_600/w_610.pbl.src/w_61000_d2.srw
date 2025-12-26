$PBExportHeader$w_61000_d2.srw
$PBExportComments$전브랜드판매실적
forward
global type w_61000_d2 from w_com010_d
end type
type st_1 from statictext within w_61000_d2
end type
end forward

global type w_61000_d2 from w_com010_d
integer width = 3675
integer height = 2276
st_1 st_1
end type
global w_61000_d2 w_61000_d2

type variables
string  is_yymm,  is_sale_div
datawindowchild  idw_sale_div
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

is_sale_div = dw_head.GetItemString(1, "sale_div")
if IsNull(is_sale_div) or Trim(is_sale_div) = "" then
   MessageBox(ls_title,"판매구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_div")
   return false
end if



return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymm, is_sale_div, '%')
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

on w_61000_d2.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_61000_d2.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
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

type cb_close from w_com010_d`cb_close within w_61000_d2
end type

type cb_delete from w_com010_d`cb_delete within w_61000_d2
end type

type cb_insert from w_com010_d`cb_insert within w_61000_d2
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61000_d2
end type

type cb_update from w_com010_d`cb_update within w_61000_d2
end type

type cb_print from w_com010_d`cb_print within w_61000_d2
end type

type cb_preview from w_com010_d`cb_preview within w_61000_d2
end type

type gb_button from w_com010_d`gb_button within w_61000_d2
end type

type cb_excel from w_com010_d`cb_excel within w_61000_d2
end type

type dw_head from w_com010_d`dw_head within w_61000_d2
integer width = 2025
integer height = 196
string dataobject = "d_61000_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/


This.GetChild("sale_div", idw_sale_div )
idw_sale_div.SetTransObject(SQLCA)
idw_sale_div.Retrieve('009')

idw_sale_div.InsertRow(1)
idw_sale_div.SetItem(1,'inter_cd','0')
idw_sale_div.SetItem(1,'inter_nm','기타제외')


idw_sale_div.InsertRow(1)
idw_sale_div.SetItem(1,'inter_cd','%')
idw_sale_div.SetItem(1,'inter_nm','전체')


end event

type ln_1 from w_com010_d`ln_1 within w_61000_d2
end type

type ln_2 from w_com010_d`ln_2 within w_61000_d2
end type

type dw_body from w_com010_d`dw_body within w_61000_d2
string dataobject = "d_61000_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_61000_d2
integer x = 270
integer y = 612
string dataobject = "d_61000_d01"
end type

type st_1 from statictext within w_61000_d2
integer x = 46
integer y = 376
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "(단위:천원)"
boolean focusrectangle = false
end type

