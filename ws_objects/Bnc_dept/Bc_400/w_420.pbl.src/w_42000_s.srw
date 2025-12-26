$PBExportHeader$w_42000_s.srw
$PBExportComments$출고반품[판매형태]
forward
global type w_42000_s from w_com010_d
end type
end forward

global type w_42000_s from w_com010_d
integer width = 1051
integer height = 740
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_closeparm ( )
end type
global w_42000_s w_42000_s

event ue_closeparm();CloseWithReturn(This, "YES")

end event

on w_42000_s.create
call super::create
end on

on w_42000_s.destroy
call super::destroy
end on

event pfc_preopen();call super::pfc_preopen;Window ldw_parent
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

il_rows = dw_body.retrieve(gsv_cd.gs_cd1, gsv_cd.gs_cd2, gsv_cd.gs_cd3, gsv_cd.gs_cd4)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

end event

event pfc_postopen();call super::pfc_postopen;This.Trigger Event ue_retrieve()
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42000_s","0")
end event

type cb_close from w_com010_d`cb_close within w_42000_s
integer x = 288
integer y = 524
end type

type cb_delete from w_com010_d`cb_delete within w_42000_s
end type

type cb_insert from w_com010_d`cb_insert within w_42000_s
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42000_s
boolean visible = false
end type

type cb_update from w_com010_d`cb_update within w_42000_s
end type

type cb_print from w_com010_d`cb_print within w_42000_s
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_42000_s
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_42000_s
boolean visible = false
end type

type cb_excel from w_com010_d`cb_excel within w_42000_s
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_42000_s
boolean visible = false
end type

type ln_1 from w_com010_d`ln_1 within w_42000_s
boolean visible = false
end type

type ln_2 from w_com010_d`ln_2 within w_42000_s
boolean visible = false
end type

type dw_body from w_com010_d`dw_body within w_42000_s
integer y = 4
integer width = 1006
integer height = 508
string dataobject = "d_42000_d99"
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("011")

end event

event dw_body::doubleclicked;call super::doubleclicked;IF row < 1 THEN RETURN 

gsv_cd.gs_cd5  = This.GetitemString(row, "sale_type") 
gsv_cd.gdc_cd1 = This.GetitemDecimal(row, "marjin_rate") 
gsv_cd.gdc_cd2 = This.GetitemNumber(row, "dc_rate") 

Parent.Post Event ue_closeParm()

end event

type dw_print from w_com010_d`dw_print within w_42000_s
end type

