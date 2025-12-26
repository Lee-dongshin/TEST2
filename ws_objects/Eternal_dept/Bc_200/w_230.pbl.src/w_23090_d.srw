$PBExportHeader$w_23090_d.srw
$PBExportComments$시즌별(월별) 업체마감 현황
forward
global type w_23090_d from w_com010_d
end type
end forward

global type w_23090_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_23090_d w_23090_d

on w_23090_d.create
call super::create
end on

on w_23090_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type cb_close from w_com010_d`cb_close within w_23090_d
end type

type cb_delete from w_com010_d`cb_delete within w_23090_d
end type

type cb_insert from w_com010_d`cb_insert within w_23090_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_23090_d
end type

type cb_update from w_com010_d`cb_update within w_23090_d
end type

type cb_print from w_com010_d`cb_print within w_23090_d
end type

type cb_preview from w_com010_d`cb_preview within w_23090_d
end type

type gb_button from w_com010_d`gb_button within w_23090_d
end type

type cb_excel from w_com010_d`cb_excel within w_23090_d
end type

type dw_head from w_com010_d`dw_head within w_23090_d
integer height = 224
string dataobject = "d_23090_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_23090_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_d`ln_2 within w_23090_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_23090_d
integer y = 444
integer height = 1596
string dataobject = "d_23090_d01"
end type

type dw_print from w_com010_d`dw_print within w_23090_d
end type

