$PBExportHeader$w_23003_e.srw
$PBExportComments$자재매입계산서등록
forward
global type w_23003_e from w_com010_e
end type
end forward

global type w_23003_e from w_com010_e
integer width = 3680
integer height = 2280
string title = "자재매입계산서등록"
end type
global w_23003_e w_23003_e

on w_23003_e.create
call super::create
end on

on w_23003_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_23003_e","0")
end event

type cb_close from w_com010_e`cb_close within w_23003_e
end type

type cb_delete from w_com010_e`cb_delete within w_23003_e
end type

type cb_insert from w_com010_e`cb_insert within w_23003_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_23003_e
end type

type cb_update from w_com010_e`cb_update within w_23003_e
end type

type cb_print from w_com010_e`cb_print within w_23003_e
end type

type cb_preview from w_com010_e`cb_preview within w_23003_e
end type

type gb_button from w_com010_e`gb_button within w_23003_e
end type

type cb_excel from w_com010_e`cb_excel within w_23003_e
end type

type dw_head from w_com010_e`dw_head within w_23003_e
integer height = 376
string dataobject = "d_23003_d01"
end type

type ln_1 from w_com010_e`ln_1 within w_23003_e
integer beginx = 5
integer beginy = 572
integer endx = 3625
integer endy = 572
end type

type ln_2 from w_com010_e`ln_2 within w_23003_e
integer beginx = 5
integer beginy = 576
integer endx = 3625
integer endy = 576
end type

type dw_body from w_com010_e`dw_body within w_23003_e
integer y = 592
integer height = 1448
string dataobject = "d_23003_d02"
end type

type dw_print from w_com010_e`dw_print within w_23003_e
end type

