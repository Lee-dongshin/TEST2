$PBExportHeader$w_sh153_e.srw
$PBExportComments$매장(주문) 미등록 판매내역
forward
global type w_sh153_e from w_com020_e
end type
end forward

global type w_sh153_e from w_com020_e
end type
global w_sh153_e w_sh153_e

on w_sh153_e.create
call super::create
end on

on w_sh153_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type cb_close from w_com020_e`cb_close within w_sh153_e
end type

type cb_delete from w_com020_e`cb_delete within w_sh153_e
end type

type cb_insert from w_com020_e`cb_insert within w_sh153_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_sh153_e
end type

type cb_update from w_com020_e`cb_update within w_sh153_e
end type

type cb_print from w_com020_e`cb_print within w_sh153_e
end type

type cb_preview from w_com020_e`cb_preview within w_sh153_e
end type

type gb_button from w_com020_e`gb_button within w_sh153_e
end type

type dw_head from w_com020_e`dw_head within w_sh153_e
end type

type ln_1 from w_com020_e`ln_1 within w_sh153_e
end type

type ln_2 from w_com020_e`ln_2 within w_sh153_e
end type

type dw_list from w_com020_e`dw_list within w_sh153_e
integer height = 1320
string dataobject = "d_sh153_d01"
end type

type dw_body from w_com020_e`dw_body within w_sh153_e
integer width = 2075
integer height = 1320
end type

type st_1 from w_com020_e`st_1 within w_sh153_e
end type

type dw_print from w_com020_e`dw_print within w_sh153_e
end type

