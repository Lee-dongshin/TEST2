$PBExportHeader$w_23092_d.srw
$PBExportComments$정산 현황 (마감 집계)
forward
global type w_23092_d from w_com010_d
end type
end forward

global type w_23092_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_23092_d w_23092_d

on w_23092_d.create
call super::create
end on

on w_23092_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type cb_close from w_com010_d`cb_close within w_23092_d
end type

type cb_delete from w_com010_d`cb_delete within w_23092_d
end type

type cb_insert from w_com010_d`cb_insert within w_23092_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_23092_d
end type

type cb_update from w_com010_d`cb_update within w_23092_d
end type

type cb_print from w_com010_d`cb_print within w_23092_d
end type

type cb_preview from w_com010_d`cb_preview within w_23092_d
end type

type gb_button from w_com010_d`gb_button within w_23092_d
end type

type cb_excel from w_com010_d`cb_excel within w_23092_d
end type

type dw_head from w_com010_d`dw_head within w_23092_d
integer height = 124
string dataobject = "d_23092_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_23092_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_23092_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_23092_d
integer y = 348
integer height = 1692
string dataobject = "d_23092_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_23092_d
end type

