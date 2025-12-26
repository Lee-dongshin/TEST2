$PBExportHeader$w_61023_d.srw
$PBExportComments$중국온앤온일자별매출
forward
global type w_61023_d from w_com010_d
end type
end forward

global type w_61023_d from w_com010_d
end type
global w_61023_d w_61023_d

type variables
String is_brand, is_fr_yymmdd, is_to_yymmdd
datawindowchild idw_brand
end variables

on w_61023_d.create
call super::create
end on

on w_61023_d.destroy
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

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
if IsNull(is_fr_yymmdd) or Trim(is_fr_yymmdd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymmdd")
   return false
end if

is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
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

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd)
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

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "fr_yymmdd" ,MidA(string(ld_datetime,"yyyymmdd"),1,6) + '01')
dw_head.SetItem(1, "to_yymmdd" ,string(ld_datetime,"yyyymmdd"))

dw_body.Object.DataWindow.HorizontalScrollSplit  = 534
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61023_d","0")
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

//dw_body.ShareData(dw_print)
il_rows = dw_print.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd)
dw_print.inv_printpreview.of_SetZoom()


end event

type cb_close from w_com010_d`cb_close within w_61023_d
end type

type cb_delete from w_com010_d`cb_delete within w_61023_d
end type

type cb_insert from w_com010_d`cb_insert within w_61023_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61023_d
end type

type cb_update from w_com010_d`cb_update within w_61023_d
end type

type cb_print from w_com010_d`cb_print within w_61023_d
end type

type cb_preview from w_com010_d`cb_preview within w_61023_d
end type

type gb_button from w_com010_d`gb_button within w_61023_d
end type

type cb_excel from w_com010_d`cb_excel within w_61023_d
end type

type dw_head from w_com010_d`dw_head within w_61023_d
integer y = 156
integer height = 168
string dataobject = "d_61023_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_d`ln_1 within w_61023_d
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_d`ln_2 within w_61023_d
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_d`dw_body within w_61023_d
integer y = 344
integer height = 1696
string dataobject = "d_61023_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_61023_d
string dataobject = "d_61023_r01"
end type

