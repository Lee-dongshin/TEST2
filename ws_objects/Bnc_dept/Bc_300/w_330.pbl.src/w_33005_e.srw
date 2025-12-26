$PBExportHeader$w_33005_e.srw
$PBExportComments$가공료 계산서 등록
forward
global type w_33005_e from w_com010_e
end type
end forward

global type w_33005_e from w_com010_e
string title = "가공료 계산서 등록"
end type
global w_33005_e w_33005_e

on w_33005_e.create
call super::create
end on

on w_33005_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type cb_close from w_com010_e`cb_close within w_33005_e
end type

type cb_delete from w_com010_e`cb_delete within w_33005_e
end type

type cb_insert from w_com010_e`cb_insert within w_33005_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_33005_e
end type

type cb_update from w_com010_e`cb_update within w_33005_e
end type

type cb_print from w_com010_e`cb_print within w_33005_e
end type

type cb_preview from w_com010_e`cb_preview within w_33005_e
end type

type gb_button from w_com010_e`gb_button within w_33005_e
end type

type cb_excel from w_com010_e`cb_excel within w_33005_e
end type

type dw_head from w_com010_e`dw_head within w_33005_e
string dataobject = "d_33005_h01"
end type

type ln_1 from w_com010_e`ln_1 within w_33005_e
end type

type ln_2 from w_com010_e`ln_2 within w_33005_e
end type

type dw_body from w_com010_e`dw_body within w_33005_e
string dataobject = "d_33005_d01"
end type

type dw_print from w_com010_e`dw_print within w_33005_e
end type

