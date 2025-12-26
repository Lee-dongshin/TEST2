$PBExportHeader$w_31003_d.srw
$PBExportComments$생산 공정 진행 관리
forward
global type w_31003_d from w_com010_d
end type
end forward

global type w_31003_d from w_com010_d
end type
global w_31003_d w_31003_d

on w_31003_d.create
call super::create
end on

on w_31003_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type cb_close from w_com010_d`cb_close within w_31003_d
end type

type cb_delete from w_com010_d`cb_delete within w_31003_d
end type

type cb_insert from w_com010_d`cb_insert within w_31003_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_31003_d
end type

type cb_update from w_com010_d`cb_update within w_31003_d
end type

type cb_print from w_com010_d`cb_print within w_31003_d
end type

type cb_preview from w_com010_d`cb_preview within w_31003_d
end type

type gb_button from w_com010_d`gb_button within w_31003_d
end type

type cb_excel from w_com010_d`cb_excel within w_31003_d
end type

type dw_head from w_com010_d`dw_head within w_31003_d
end type

type ln_1 from w_com010_d`ln_1 within w_31003_d
end type

type ln_2 from w_com010_d`ln_2 within w_31003_d
end type

type dw_body from w_com010_d`dw_body within w_31003_d
end type

type dw_print from w_com010_d`dw_print within w_31003_d
end type

