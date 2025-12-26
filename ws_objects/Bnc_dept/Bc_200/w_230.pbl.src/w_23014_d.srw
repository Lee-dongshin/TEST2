$PBExportHeader$w_23014_d.srw
$PBExportComments$어음 및 현금 결재현황
forward
global type w_23014_d from w_com010_d
end type
type dw_sum from datawindow within w_23014_d
end type
end forward

global type w_23014_d from w_com010_d
integer height = 2260
dw_sum dw_sum
end type
global w_23014_d w_23014_d

type variables
datawindowchild idw_brand

string is_brand , is_yymm
end variables

on w_23014_d.create
int iCurrent
call super::create
this.dw_sum=create dw_sum
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_sum
end on

on w_23014_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_sum)
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
is_yymm  = dw_head.GetItemString(1, "yymm")

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


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymm)
dw_sum.reset()
IF il_rows > 0 THEN
	il_rows = dw_sum.retrieve(is_brand, is_yymm)
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(dw_sum, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


dw_sum.SetTransObject(SQLCA)
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

il_rows = dw_print.retrieve(is_brand, is_yymm)
dw_print.inv_printpreview.of_SetZoom()

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_23014_d","0")
end event

type cb_close from w_com010_d`cb_close within w_23014_d
end type

type cb_delete from w_com010_d`cb_delete within w_23014_d
end type

type cb_insert from w_com010_d`cb_insert within w_23014_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_23014_d
end type

type cb_update from w_com010_d`cb_update within w_23014_d
end type

type cb_print from w_com010_d`cb_print within w_23014_d
end type

type cb_preview from w_com010_d`cb_preview within w_23014_d
end type

type gb_button from w_com010_d`gb_button within w_23014_d
end type

type cb_excel from w_com010_d`cb_excel within w_23014_d
end type

type dw_head from w_com010_d`dw_head within w_23014_d
integer height = 132
string dataobject = "d_23014_h01"
end type

event dw_head::constructor;call super::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')
end event

type ln_1 from w_com010_d`ln_1 within w_23014_d
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_d`ln_2 within w_23014_d
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_d`dw_body within w_23014_d
integer y = 340
integer height = 1024
string dataobject = "d_23014_d01"
end type

type dw_print from w_com010_d`dw_print within w_23014_d
string dataobject = "d_23014_d00"
end type

type dw_sum from datawindow within w_23014_d
integer x = 5
integer y = 1372
integer width = 3589
integer height = 664
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_23014_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

