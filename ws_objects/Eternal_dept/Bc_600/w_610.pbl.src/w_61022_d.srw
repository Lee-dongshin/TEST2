$PBExportHeader$w_61022_d.srw
$PBExportComments$일자별 예상매출분석
forward
global type w_61022_d from w_com010_d
end type
type cb_1 from commandbutton within w_61022_d
end type
type dw_1 from datawindow within w_61022_d
end type
end forward

global type w_61022_d from w_com010_d
cb_1 cb_1
dw_1 dw_1
end type
global w_61022_d w_61022_d

type variables
string is_brand, is_yymmdd
datawindowchild idw_brand

end variables

on w_61022_d.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_1
end on

on w_61022_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_1)
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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd, 0)
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

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)



IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"yymmdd",string(ld_datetime,"yyyymmdd"))
end if

end event

type cb_close from w_com010_d`cb_close within w_61022_d
end type

type cb_delete from w_com010_d`cb_delete within w_61022_d
end type

type cb_insert from w_com010_d`cb_insert within w_61022_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61022_d
end type

type cb_update from w_com010_d`cb_update within w_61022_d
end type

type cb_print from w_com010_d`cb_print within w_61022_d
end type

type cb_preview from w_com010_d`cb_preview within w_61022_d
end type

type gb_button from w_com010_d`gb_button within w_61022_d
end type

type cb_excel from w_com010_d`cb_excel within w_61022_d
end type

type dw_head from w_com010_d`dw_head within w_61022_d
integer height = 148
string dataobject = "d_61022_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')



end event

type ln_1 from w_com010_d`ln_1 within w_61022_d
integer beginy = 340
integer endy = 340
end type

type ln_2 from w_com010_d`ln_2 within w_61022_d
integer beginy = 344
integer endy = 344
end type

type dw_body from w_com010_d`dw_body within w_61022_d
integer y = 364
integer height = 1652
string dataobject = "d_61022_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_61022_d
string dataobject = "d_61022_r01"
end type

type cb_1 from commandbutton within w_61022_d
integer x = 2601
integer y = 204
integer width = 576
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "시간대별 판매등록율"
end type

event clicked;dw_1.visible = true
dw_1.retrieve()

end event

type dw_1 from datawindow within w_61022_d
boolean visible = false
integer x = 5
integer y = 364
integer width = 3589
integer height = 1652
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_61022_d02"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

