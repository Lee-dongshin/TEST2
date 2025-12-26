$PBExportHeader$w_61032_d.srw
$PBExportComments$매장손익분석
forward
global type w_61032_d from w_com010_d
end type
type st_1 from statictext within w_61032_d
end type
type dw_1 from datawindow within w_61032_d
end type
type cb_1 from commandbutton within w_61032_d
end type
end forward

global type w_61032_d from w_com010_d
integer width = 3675
integer height = 2280
st_1 st_1
dw_1 dw_1
cb_1 cb_1
end type
global w_61032_d w_61032_d

type variables
string is_brand, is_fr_yymm, is_to_yymm, is_shop_div
datawindowchild idw_brand

end variables

on w_61032_d.create
int iCurrent
call super::create
this.st_1=create st_1
this.dw_1=create dw_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cb_1
end on

on w_61032_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.cb_1)
end on

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



if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	


is_fr_yymm = dw_head.GetItemString(1, "fr_yymm")
is_to_yymm = dw_head.GetItemString(1, "to_yymm")
is_shop_div = dw_head.GetItemString(1, "shop_div")

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_fr_yymm, is_to_yymm, is_brand, is_shop_div)
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

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_brand.text = '브랜드: ' + is_brand + ' ' + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_yymm.text  = '조회기간: ' + is_fr_yymm + ' - ' + is_to_yymm

choose case is_shop_div 
	case '[GKED]'
		dw_print.object.t_shop_div.text = '구분: 사입점제외'
	case else
		dw_print.object.t_shop_div.text = '구분: 전체매장'
end choose



end event

event open;call super::open;dw_body.Object.DataWindow.HorizontalScrollSplit  = 1250
end event

event ue_button;/*===========================================================================*/
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
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
			cb_1.enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
			cb_1.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
		cb_1.enabled = false
	
END CHOOSE

end event

event pfc_preopen;call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_61032_d
end type

type cb_delete from w_com010_d`cb_delete within w_61032_d
end type

type cb_insert from w_com010_d`cb_insert within w_61032_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61032_d
end type

type cb_update from w_com010_d`cb_update within w_61032_d
end type

type cb_print from w_com010_d`cb_print within w_61032_d
end type

type cb_preview from w_com010_d`cb_preview within w_61032_d
end type

type gb_button from w_com010_d`gb_button within w_61032_d
end type

type cb_excel from w_com010_d`cb_excel within w_61032_d
end type

type dw_head from w_com010_d`dw_head within w_61032_d
integer y = 160
integer height = 152
string dataobject = "d_61032_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_d`ln_1 within w_61032_d
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_d`ln_2 within w_61032_d
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_d`dw_body within w_61032_d
integer y = 348
integer height = 1692
string dataobject = "d_61032_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_61032_d
string dataobject = "d_61032_r01"
end type

type st_1 from statictext within w_61032_d
integer x = 2875
integer y = 224
integer width = 699
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※부가세별도,  단위(천원)"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_61032_d
boolean visible = false
integer x = 219
integer y = 312
integer width = 2848
integer height = 1616
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "비용 상세내역"
string dataobject = "d_61032_d02"
boolean controlmenu = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_61032_d
integer x = 2405
integer y = 208
integer width = 448
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "비용 상세내역"
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_1.retrieve(is_fr_yymm, is_to_yymm, is_brand, is_shop_div)
IF il_rows > 0 THEN
   dw_1.visible = true
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF


end event

