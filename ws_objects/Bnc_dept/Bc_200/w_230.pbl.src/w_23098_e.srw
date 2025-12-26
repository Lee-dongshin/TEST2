$PBExportHeader$w_23098_e.srw
$PBExportComments$원자재 지불 마감 관리
forward
global type w_23098_e from w_com010_e
end type
end forward

global type w_23098_e from w_com010_e
end type
global w_23098_e w_23098_e

on w_23098_e.create
call super::create
end on

on w_23098_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type cb_close from w_com010_e`cb_close within w_23098_e
end type

type cb_delete from w_com010_e`cb_delete within w_23098_e
end type

type cb_insert from w_com010_e`cb_insert within w_23098_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_23098_e
end type

type cb_update from w_com010_e`cb_update within w_23098_e
end type

type cb_print from w_com010_e`cb_print within w_23098_e
end type

type cb_preview from w_com010_e`cb_preview within w_23098_e
end type

type gb_button from w_com010_e`gb_button within w_23098_e
end type

type cb_excel from w_com010_e`cb_excel within w_23098_e
end type

type dw_head from w_com010_e`dw_head within w_23098_e
integer x = 96
integer y = 192
integer width = 3474
integer height = 100
string dataobject = "d_23098_h01"
end type

type ln_1 from w_com010_e`ln_1 within w_23098_e
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_e`ln_2 within w_23098_e
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_e`dw_body within w_23098_e
integer y = 348
integer height = 1692
string dataobject = "d_23098_d01"
end type

type dw_print from w_com010_e`dw_print within w_23098_e
end type

