$PBExportHeader$w_62017_d.srw
$PBExportComments$시즌별 배수분석
forward
global type w_62017_d from w_com010_d
end type
type dw_1 from datawindow within w_62017_d
end type
end forward

global type w_62017_d from w_com010_d
integer width = 3680
integer height = 2256
dw_1 dw_1
end type
global w_62017_d w_62017_d

on w_62017_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_62017_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve()
IF il_rows > 0 THEN
	il_rows = dw_1.retrieve()
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight")
dw_1.SetTransObject(SQLCA)
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

dw_print.retrieve()
dw_print.inv_printpreview.of_SetZoom()

end event

type cb_close from w_com010_d`cb_close within w_62017_d
end type

type cb_delete from w_com010_d`cb_delete within w_62017_d
end type

type cb_insert from w_com010_d`cb_insert within w_62017_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_62017_d
end type

type cb_update from w_com010_d`cb_update within w_62017_d
end type

type cb_print from w_com010_d`cb_print within w_62017_d
end type

type cb_preview from w_com010_d`cb_preview within w_62017_d
end type

type gb_button from w_com010_d`gb_button within w_62017_d
end type

type cb_excel from w_com010_d`cb_excel within w_62017_d
end type

type dw_head from w_com010_d`dw_head within w_62017_d
boolean visible = false
integer height = 48
end type

type ln_1 from w_com010_d`ln_1 within w_62017_d
integer beginy = 228
integer endy = 228
end type

type ln_2 from w_com010_d`ln_2 within w_62017_d
integer beginy = 232
integer endy = 232
end type

type dw_body from w_com010_d`dw_body within w_62017_d
integer x = 0
integer y = 1192
integer height = 820
string dataobject = "d_62017_d01"
end type

type dw_print from w_com010_d`dw_print within w_62017_d
string dataobject = "d_62017_r01"
end type

type dw_1 from datawindow within w_62017_d
integer y = 224
integer width = 3589
integer height = 892
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_62017_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

