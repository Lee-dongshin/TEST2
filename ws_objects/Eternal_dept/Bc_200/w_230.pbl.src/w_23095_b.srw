$PBExportHeader$w_23095_b.srw
$PBExportComments$부자재 지불마감 일괄처리
forward
global type w_23095_b from w_com010_e
end type
end forward

global type w_23095_b from w_com010_e
end type
global w_23095_b w_23095_b

on w_23095_b.create
call super::create
end on

on w_23095_b.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type cb_close from w_com010_e`cb_close within w_23095_b
end type

type cb_delete from w_com010_e`cb_delete within w_23095_b
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_23095_b
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_23095_b
end type

type cb_update from w_com010_e`cb_update within w_23095_b
string text = "처리(&S)"
end type

type cb_print from w_com010_e`cb_print within w_23095_b
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_23095_b
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_23095_b
end type

type cb_excel from w_com010_e`cb_excel within w_23095_b
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_23095_b
integer x = 457
integer y = 616
integer width = 2729
integer height = 908
string dataobject = "d_23095_h01"
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type ln_1 from w_com010_e`ln_1 within w_23095_b
boolean visible = false
end type

type ln_2 from w_com010_e`ln_2 within w_23095_b
boolean visible = false
end type

type dw_body from w_com010_e`dw_body within w_23095_b
boolean visible = false
end type

type dw_print from w_com010_e`dw_print within w_23095_b
end type

