$PBExportHeader$w_33004_e.srw
$PBExportComments$가공료 지불 확정 관리
forward
global type w_33004_e from w_com020_e
end type
end forward

global type w_33004_e from w_com020_e
integer width = 3680
integer height = 2276
end type
global w_33004_e w_33004_e

on w_33004_e.create
call super::create
end on

on w_33004_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type cb_close from w_com020_e`cb_close within w_33004_e
end type

type cb_delete from w_com020_e`cb_delete within w_33004_e
end type

type cb_insert from w_com020_e`cb_insert within w_33004_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_33004_e
end type

type cb_update from w_com020_e`cb_update within w_33004_e
end type

type cb_print from w_com020_e`cb_print within w_33004_e
end type

type cb_preview from w_com020_e`cb_preview within w_33004_e
end type

type gb_button from w_com020_e`gb_button within w_33004_e
end type

type cb_excel from w_com020_e`cb_excel within w_33004_e
end type

type dw_head from w_com020_e`dw_head within w_33004_e
integer height = 212
string dataobject = "d_33004_h01"
end type

type ln_1 from w_com020_e`ln_1 within w_33004_e
integer beginy = 420
integer endy = 420
end type

type ln_2 from w_com020_e`ln_2 within w_33004_e
integer beginy = 424
integer endy = 424
end type

type dw_list from w_com020_e`dw_list within w_33004_e
integer y = 440
integer width = 2354
integer height = 1600
string dataobject = "d_33004_d01"
boolean hscrollbar = true
end type

type dw_body from w_com020_e`dw_body within w_33004_e
integer x = 2405
integer y = 440
integer width = 1189
integer height = 1600
string dataobject = "d_33004_d02"
end type

type st_1 from w_com020_e`st_1 within w_33004_e
integer x = 2386
integer y = 440
integer height = 1600
end type

type dw_print from w_com020_e`dw_print within w_33004_e
end type

