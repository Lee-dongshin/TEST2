$PBExportHeader$w_91017_d.srw
$PBExportComments$매장현황표
forward
global type w_91017_d from w_com010_d
end type
type chk_print_opt from checkbox within w_91017_d
end type
end forward

global type w_91017_d from w_com010_d
chk_print_opt chk_print_opt
end type
global w_91017_d w_91017_d

type variables
string is_brand, is_shop_stat
datawindowchild idw_brand, idw_shop_stat
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


is_shop_stat = dw_head.GetItemString(1, "shop_stat")
if IsNull(is_shop_stat) or Trim(is_shop_stat) = "" then
   MessageBox(ls_title,"코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_stat")
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

il_rows = dw_body.retrieve(is_brand, is_shop_stat)
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

on w_91017_d.create
int iCurrent
call super::create
this.chk_print_opt=create chk_print_opt
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.chk_print_opt
end on

on w_91017_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.chk_print_opt)
end on

event ue_title();call super::ue_title;/*===========================================================================*/
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

ls_modify =	"t_brand.text = '" +  idw_brand.GetItemString(idw_brand.GetRow(), "inter_nm") + "'" 

dw_print.Modify(ls_modify)


end event

event ue_preview();
if chk_print_opt.checked = true then
	dw_print.dataobject = "d_91017_r03"
	dw_print.SetTransObject(SQLCA)
	dw_PRINT.RETRIEVE("N","O","B","I","P")	
ELSE	
	dw_print.dataobject = "d_91017_r01"
	dw_print.SetTransObject(SQLCA)
	This.Trigger Event ue_title ()	
	dw_body.ShareData(dw_print)
END IF	


dw_print.inv_printpreview.of_SetZoom()
end event

event ue_print();if chk_print_opt.checked = true then
	dw_print.dataobject = "d_91017_r03"
	dw_print.SetTransObject(SQLCA)
	dw_PRINT.RETRIEVE("N","O","B","I","P")	
ELSE	
	dw_print.dataobject = "d_91017_r01"
	dw_print.SetTransObject(SQLCA)
	This.Trigger Event ue_title ()	
	dw_body.ShareData(dw_print)
END IF	



IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)
end event

type cb_close from w_com010_d`cb_close within w_91017_d
end type

type cb_delete from w_com010_d`cb_delete within w_91017_d
end type

type cb_insert from w_com010_d`cb_insert within w_91017_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_91017_d
end type

type cb_update from w_com010_d`cb_update within w_91017_d
end type

type cb_print from w_com010_d`cb_print within w_91017_d
end type

type cb_preview from w_com010_d`cb_preview within w_91017_d
end type

type gb_button from w_com010_d`gb_button within w_91017_d
end type

type cb_excel from w_com010_d`cb_excel within w_91017_d
end type

type dw_head from w_com010_d`dw_head within w_91017_d
string dataobject = "d_91017_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')


This.GetChild("shop_stat", idw_shop_stat)
idw_shop_stat.SetTransObject(SQLCA)
idw_shop_stat.Retrieve('913')
idw_shop_stat.InsertRow(1)
idw_shop_stat.SetItem(1, "inter_cd", '%')
idw_shop_stat.SetItem(1, "inter_nm", '전체')
end event

type ln_1 from w_com010_d`ln_1 within w_91017_d
end type

type ln_2 from w_com010_d`ln_2 within w_91017_d
end type

type dw_body from w_com010_d`dw_body within w_91017_d
string dataobject = "d_91017_d01"
end type

type dw_print from w_com010_d`dw_print within w_91017_d
string dataobject = "d_91017_r01"
end type

type chk_print_opt from checkbox within w_91017_d
integer x = 1856
integer y = 240
integer width = 622
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "전 브랜드 출력"
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_modify

dw_print.dataobject = "d_91017_r03"
dw_print.SetTransObject(SQLCA)


end event

