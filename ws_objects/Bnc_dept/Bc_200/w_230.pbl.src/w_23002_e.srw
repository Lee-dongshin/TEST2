$PBExportHeader$w_23002_e.srw
$PBExportComments$자재클래임등록
forward
global type w_23002_e from w_com010_e
end type
end forward

global type w_23002_e from w_com010_e
string title = "미작업클래임등록"
end type
global w_23002_e w_23002_e

on w_23002_e.create
call super::create
end on

on w_23002_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_23002_e","0")
end event

type cb_close from w_com010_e`cb_close within w_23002_e
end type

type cb_delete from w_com010_e`cb_delete within w_23002_e
end type

type cb_insert from w_com010_e`cb_insert within w_23002_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_23002_e
end type

type cb_update from w_com010_e`cb_update within w_23002_e
end type

type cb_print from w_com010_e`cb_print within w_23002_e
end type

type cb_preview from w_com010_e`cb_preview within w_23002_e
end type

type gb_button from w_com010_e`gb_button within w_23002_e
end type

type cb_excel from w_com010_e`cb_excel within w_23002_e
end type

type dw_head from w_com010_e`dw_head within w_23002_e
integer x = 32
integer height = 412
string dataobject = "d_23002_d01"
end type

type ln_1 from w_com010_e`ln_1 within w_23002_e
integer beginx = 14
integer beginy = 616
integer endx = 3634
integer endy = 616
end type

type ln_2 from w_com010_e`ln_2 within w_23002_e
integer beginx = 14
integer beginy = 620
integer endx = 3634
integer endy = 620
end type

type dw_body from w_com010_e`dw_body within w_23002_e
integer y = 636
integer height = 1404
string dataobject = "d_23002_d02"
boolean hscrollbar = true
end type

type dw_print from w_com010_e`dw_print within w_23002_e
end type

