$PBExportHeader$w_61029_d.srw
$PBExportComments$자산/부채 현황
forward
global type w_61029_d from w_com010_d
end type
type dw_3 from datawindow within w_61029_d
end type
type dw_2 from datawindow within w_61029_d
end type
type dw_4 from datawindow within w_61029_d
end type
type dw_5 from datawindow within w_61029_d
end type
type dw_6 from datawindow within w_61029_d
end type
end forward

global type w_61029_d from w_com010_d
integer width = 3680
integer height = 2260
dw_3 dw_3
dw_2 dw_2
dw_4 dw_4
dw_5 dw_5
dw_6 dw_6
end type
global w_61029_d w_61029_d

on w_61029_d.create
int iCurrent
call super::create
this.dw_3=create dw_3
this.dw_2=create dw_2
this.dw_4=create dw_4
this.dw_5=create dw_5
this.dw_6=create dw_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_3
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_4
this.Control[iCurrent+4]=this.dw_5
this.Control[iCurrent+5]=this.dw_6
end on

on w_61029_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.dw_4)
destroy(this.dw_5)
destroy(this.dw_6)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_3, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_4, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_5, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_6, "ScaleToRight&Bottom")


/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
dw_5.SetTransObject(SQLCA)
dw_6.SetTransObject(SQLCA)
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve()
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

type cb_close from w_com010_d`cb_close within w_61029_d
end type

type cb_delete from w_com010_d`cb_delete within w_61029_d
end type

type cb_insert from w_com010_d`cb_insert within w_61029_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61029_d
end type

type cb_update from w_com010_d`cb_update within w_61029_d
end type

type cb_print from w_com010_d`cb_print within w_61029_d
end type

type cb_preview from w_com010_d`cb_preview within w_61029_d
end type

type gb_button from w_com010_d`gb_button within w_61029_d
end type

type cb_excel from w_com010_d`cb_excel within w_61029_d
end type

type dw_head from w_com010_d`dw_head within w_61029_d
integer height = 140
string dataobject = "d_61029_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_61029_d
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_d`ln_2 within w_61029_d
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_d`dw_body within w_61029_d
integer y = 344
integer height = 1676
string dataobject = "d_61029_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_gubn
if row = 0 then return
	

ls_gubn = this.getitemstring(row,"gubn")
if ls_gubn = '제품' then
	dw_6.visible = false	
	dw_5.visible = false
	dw_4.visible = false
	dw_3.visible = false
	dw_2.visible = true
	dw_2.x = this.x
	dw_2.y = this.y
	dw_2.width   = this.width
	dw_2.height  = this.height	
	dw_2.retrieve('S')
	dw_2.visible = true
elseif ls_gubn = '원단'  then
	dw_6.visible = false	
	dw_5.visible = false
	dw_4.visible = false
	dw_3.visible = false
	dw_2.visible = true
	dw_2.x = this.x
	dw_2.y = this.y
	dw_2.width   = this.width
	dw_2.height  = this.height	
	dw_2.retrieve('M')
	dw_2.visible = true
elseif ls_gubn = '미지급금'  then
	dw_6.visible = false	
	dw_5.visible = false
	dw_4.visible = false
	dw_2.visible = false
	dw_3.visible = true
	dw_3.x = this.x
	dw_3.y = this.y
	dw_3.width   = this.width
	dw_3.height  = this.height
	dw_3.retrieve()		
	dw_3.visible = true
else
	dw_6.visible = false	
	dw_5.visible = false
	dw_4.visible = true
	dw_2.visible = false
	dw_3.visible = false
	dw_4.x = this.x
	dw_4.y = this.y
	dw_4.width   = this.width
	dw_4.height  = this.height
	dw_4.retrieve()		
	dw_4.visible = true		
	
end if		


end event

type dw_print from w_com010_d`dw_print within w_61029_d
integer y = 1244
integer width = 571
integer height = 600
boolean titlebar = true
string title = "채권현황표"
string dataobject = "d_61029_r01"
end type

type dw_3 from datawindow within w_61029_d
boolean visible = false
integer x = 914
integer y = 656
integer width = 571
integer height = 600
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "미지급금 현황표"
string dataobject = "d_61029_d03"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;	THIS.visible = FALSE
end event

type dw_2 from datawindow within w_61029_d
boolean visible = false
integer x = 242
integer y = 652
integer width = 571
integer height = 600
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "년도별 재고자산 현황"
string dataobject = "d_61029_d02"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;	THIS.visible = FALSE
end event

type dw_4 from datawindow within w_61029_d
boolean visible = false
integer x = 1541
integer y = 664
integer width = 571
integer height = 600
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "채권현황표"
string dataobject = "d_61029_d04"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_gubn
if row = 0 then return
	

ls_gubn = this.getitemstring(row,"gubn")
if ls_gubn = 'A' then
	dw_6.visible = false	
	dw_5.visible = TRUE
	dw_3.visible = false
	dw_2.visible = FALSE
	dw_5.x = this.x
	dw_5.y = this.y
	dw_5.width   = this.width
	dw_5.height  = this.height	
	dw_5.retrieve()
	dw_5.visible = true
elseif ls_gubn = 'B'  then
	dw_6.visible = TRUE
	dw_5.visible = false
	dw_3.visible = false
	dw_2.visible = FALSE
	dw_6.x = this.x
	dw_6.y = this.y
	dw_6.width   = this.width
	dw_6.height  = this.height	
	dw_6.retrieve()
	dw_6.visible = true
else	
	dw_6.visible = TRUE
	dw_6.visible = false	
	dw_5.visible = false
	dw_3.visible = false
	dw_2.visible = FALSE
	
end if		
end event

type dw_5 from datawindow within w_61029_d
boolean visible = false
integer x = 2171
integer y = 664
integer width = 571
integer height = 600
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "브랜드별 매출 채권"
string dataobject = "d_61029_d05"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;	THIS.visible = FALSE
end event

type dw_6 from datawindow within w_61029_d
boolean visible = false
integer x = 2825
integer y = 660
integer width = 571
integer height = 600
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "국내외거래처별 미수금"
string dataobject = "d_61029_d06"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;	THIS.visible = FALSE
end event

