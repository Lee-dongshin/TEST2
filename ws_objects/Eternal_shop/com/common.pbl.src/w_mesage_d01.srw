$PBExportHeader$w_mesage_d01.srw
$PBExportComments$사내판매처리내역
forward
global type w_mesage_d01 from w_com010_d
end type
end forward

global type w_mesage_d01 from w_com010_d
integer width = 1906
integer height = 932
event type long ue_refresh ( string as_person_id )
end type
global w_mesage_d01 w_mesage_d01

event type long ue_refresh(string as_person_id);long ll_rows

ll_rows = dw_body.retrieve(gs_shop_cd)

if ll_rows > 0 then
	this.visible = true
else
	this.visible = false
end if

//timer(600)
return ll_rows

end event

on w_mesage_d01.create
call super::create
end on

on w_mesage_d01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event timer;call super::timer;il_rows = dw_body.retrieve(gs_shop_cd)

if il_rows > 0 then
	this.visible = true
else
	this.visible = false
end if

end event

event pfc_preopen();call super::pfc_preopen;this.x = 70
this.y = 1360
trigger event ue_refresh(gs_shop_cd)
end event

type cb_close from w_com010_d`cb_close within w_mesage_d01
boolean visible = false
end type

type cb_delete from w_com010_d`cb_delete within w_mesage_d01
end type

type cb_insert from w_com010_d`cb_insert within w_mesage_d01
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_mesage_d01
boolean visible = false
end type

type cb_update from w_com010_d`cb_update within w_mesage_d01
end type

type cb_print from w_com010_d`cb_print within w_mesage_d01
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_mesage_d01
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_mesage_d01
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_mesage_d01
boolean visible = false
end type

type ln_1 from w_com010_d`ln_1 within w_mesage_d01
boolean visible = false
end type

type ln_2 from w_com010_d`ln_2 within w_mesage_d01
boolean visible = false
end type

type dw_body from w_com010_d`dw_body within w_mesage_d01
integer y = 12
integer width = 1856
integer height = 700
string dataobject = "d_message_001"
end type

type dw_print from w_com010_d`dw_print within w_mesage_d01
end type

