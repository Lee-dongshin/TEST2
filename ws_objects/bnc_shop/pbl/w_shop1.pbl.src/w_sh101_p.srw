$PBExportHeader$w_sh101_p.srw
$PBExportComments$마진율 list
forward
global type w_sh101_p from w_com010_d
end type
end forward

global type w_sh101_p from w_com010_d
integer width = 1024
integer height = 684
string menuname = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_closeparm ( )
end type
global w_sh101_p w_sh101_p

type variables

end variables

event ue_closeparm();
CloseWithReturn(This, "YES")


end event

on w_sh101_p.create
call super::create
end on

on w_sh101_p.destroy
call super::destroy
end on

event pfc_preopen();/*===========================================================================*/
/* 작성자      : 지우정보 (김태범) 														  */	
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
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


Window ldw_parent
Long   ll_x, ll_y

ldw_parent = This.ParentWindow()
This.x = ((ldw_parent.Width - This.Width) / 2) +  ldw_parent.x
This.y = ((ldw_parent.Height - This.Height) / 2) +  ldw_parent.y 

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.22                                                  */	
/* 수정일      : 2002.02.22                                                  */
/*===========================================================================*/

il_rows = dw_body.retrieve(gs_brand, gs_shop_cd, gsv_cd.gs_cd1, gsv_cd.gs_cd2)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

end event

event pfc_postopen();call super::pfc_postopen;This.Post Event ue_retrieve()
end event

type cb_close from w_com010_d`cb_close within w_sh101_p
integer x = 329
integer y = 472
string text = "취소(&X)"
end type

type cb_delete from w_com010_d`cb_delete within w_sh101_p
end type

type cb_insert from w_com010_d`cb_insert within w_sh101_p
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh101_p
boolean visible = false
end type

type cb_update from w_com010_d`cb_update within w_sh101_p
end type

type cb_print from w_com010_d`cb_print within w_sh101_p
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_sh101_p
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_sh101_p
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_sh101_p
boolean visible = false
end type

type ln_1 from w_com010_d`ln_1 within w_sh101_p
boolean visible = false
end type

type ln_2 from w_com010_d`ln_2 within w_sh101_p
boolean visible = false
end type

type dw_body from w_com010_d`dw_body within w_sh101_p
integer y = 0
integer width = 997
integer height = 464
string dataobject = "d_sh101_d05"
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("011")
end event

event dw_body::doubleclicked;call super::doubleclicked;decimal ldc_test
IF row < 1 THEN RETURN 

gsv_cd.gs_cd3  = This.GetitemString(row, "sale_type") 
gsv_cd.gl_cd1  = This.GetitemNumber(row, "dc_rate") 
gsv_cd.gdc_cd1 = This.GetitemDecimal(row, "marjin_rate") 
gdc_sale_rate = This.GetitemDecimal(row, "marjin_rate") 

Parent.Post Event ue_closeParm()

end event

type dw_print from w_com010_d`dw_print within w_sh101_p
end type

