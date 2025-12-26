$PBExportHeader$w_61026_d.srw
$PBExportComments$브랜드 손익현황
forward
global type w_61026_d from w_com010_d
end type
type st_1 from statictext within w_61026_d
end type
type cbx_opt from checkbox within w_61026_d
end type
end forward

global type w_61026_d from w_com010_d
integer width = 3675
integer height = 2280
st_1 st_1
cbx_opt cbx_opt
end type
global w_61026_d w_61026_d

type variables
string is_brand, is_fr_yymm, is_to_yymm
datawindowchild  idw_brand
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


if IsNull(is_fr_yymm) or Trim(is_fr_yymm) = "" then
   MessageBox(ls_title,"From 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymm")
   return false
end if

is_to_yymm = dw_head.GetItemString(1, "to_yymm")
if IsNull(is_to_yymm) or Trim(is_to_yymm) = "" then
   MessageBox(ls_title,"To 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
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

if cbx_opt.checked = true then
	dw_body.dataObject = "d_61026_d11"
   dw_body.SetTransObject(SQLCA)
	
	dw_print.dataObject = "d_61026_r11"
   dw_print.SetTransObject(SQLCA)	
else 	
	dw_body.dataObject = "d_61026_d01"
   dw_body.SetTransObject(SQLCA)	
	
	dw_print.dataObject = "d_61026_r01"
   dw_print.SetTransObject(SQLCA)		
end if



il_rows = dw_body.retrieve(is_brand,is_fr_yymm,is_to_yymm)
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

on w_61026_d.create
int iCurrent
call super::create
this.st_1=create st_1
this.cbx_opt=create cbx_opt
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cbx_opt
end on

on w_61026_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cbx_opt)
end on

event open;call super::open;string  ls_fr_yymm 
ls_fr_yymm = dw_head.GetItemString(1, "fr_yymm")

is_fr_yymm  =   LeftA(ls_fr_yymm,4) + '01'

dw_head.Setitem(1,'fr_yymm' , is_fr_yymm)

dw_body.Object.DataWindow.HorizontalScrollSplit  = 710
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_1, "FixedToRight")
end event

type cb_close from w_com010_d`cb_close within w_61026_d
end type

type cb_delete from w_com010_d`cb_delete within w_61026_d
end type

type cb_insert from w_com010_d`cb_insert within w_61026_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61026_d
end type

type cb_update from w_com010_d`cb_update within w_61026_d
end type

type cb_print from w_com010_d`cb_print within w_61026_d
end type

type cb_preview from w_com010_d`cb_preview within w_61026_d
end type

type gb_button from w_com010_d`gb_button within w_61026_d
end type

type cb_excel from w_com010_d`cb_excel within w_61026_d
end type

type dw_head from w_com010_d`dw_head within w_61026_d
integer y = 164
integer width = 1947
integer height = 164
string dataobject = "d_61026_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

//idw_brand.InsertRow(1)
//idw_brand.SetItem(1,'inter_cd','S')
//idw_brand.SetItem(1,'inter_nm','쇼핑몰')

idw_brand.InsertRow(1)
idw_brand.SetItem(1,'inter_cd','Z')
idw_brand.SetItem(1,'inter_nm','보끄레총괄')

idw_brand.InsertRow(1)
idw_brand.SetItem(1,'inter_cd','%')
idw_brand.SetItem(1,'inter_nm','전체')

end event

type ln_1 from w_com010_d`ln_1 within w_61026_d
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_d`ln_2 within w_61026_d
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_d`dw_body within w_61026_d
integer y = 360
integer height = 1680
string dataobject = "d_61026_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(false)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_print from w_com010_d`dw_print within w_61026_d
integer x = 370
integer y = 796
integer width = 2071
string dataobject = "d_61026_r01"
end type

type st_1 from statictext within w_61026_d
integer x = 2560
integer y = 288
integer width = 997
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "단위:백만원( 미밍코:천단위 )"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_opt from checkbox within w_61026_d
integer x = 2016
integer y = 208
integer width = 1403
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "유통망구분(품번 브랜드 기준) 조회"
borderstyle borderstyle = stylelowered!
end type

