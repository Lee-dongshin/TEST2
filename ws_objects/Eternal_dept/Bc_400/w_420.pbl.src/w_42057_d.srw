$PBExportHeader$w_42057_d.srw
$PBExportComments$EDI외주용파일
forward
global type w_42057_d from w_com010_d
end type
end forward

global type w_42057_d from w_com010_d
integer width = 3675
integer height = 2272
end type
global w_42057_d w_42057_d

type variables
DataWindowChild idw_brand, idw_jup_gubn, idw_house_cd, idw_shop_type
String is_brand, is_yymmdd, is_shop_cd, is_jup_gubn, is_deal_ymd, is_house_cd, is_gubn, is_shop_type
String is_rpt_opt, is_opt_all
end variables

on w_42057_d.create
call super::create
end on

on w_42057_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

IF as_cb_div = '1' THEN
	ls_title = "조회오류"
ELSEIF as_cb_div = '2' THEN
	ls_title = "추가오류"
ELSEIF as_cb_div = '3' THEN
	ls_title = "저장오류"
ELSE
	ls_title = "오류"
END IF

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"출고일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = "%"
end if

is_jup_gubn = dw_head.GetItemString(1, "jup_gubn")
if IsNull(is_jup_gubn) or Trim(is_jup_gubn) = "" then
   MessageBox(ls_title,"전표구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jup_gubn")
   return false
end if

is_gubn = dw_head.GetItemString(1, "gubn")
if IsNull(is_gubn) or Trim(is_gubn) = "" then
   MessageBox(ls_title,"출반구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubn")
   return false
end if

is_deal_ymd = dw_head.GetItemString(1, "deal_ymd")
if IsNull(is_deal_ymd) or Trim(is_deal_ymd) = "" then
	is_deal_ymd = "%"
end if

is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_rpt_opt = dw_head.GetItemString(1, "rpt_opt")
if IsNull(is_rpt_opt) or Trim(is_rpt_opt) = "" then
   MessageBox(ls_title,"조회구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rpt_opt")
   return false
end if

is_opt_all = dw_head.GetItemString(1, "opt_all")

return true
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42057_d","0")
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//messagebox ("anj", is_brand + "/" + is_yymmdd+ "/"+   is_shop_cd+ "/"+   is_house_cd+ "/"+   is_jup_gubn+ "/"+  is_gubn+ "/" +  is_deal_ymd)

if is_rpt_opt = "A" then
	dw_body.DataObject = "d_42057_d01"
else	
	dw_body.DataObject = "d_42057_d02"
end if 	
  dw_body.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_shop_cd,is_shop_type, is_house_cd, is_jup_gubn,is_gubn, is_deal_ymd, is_opt_all)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)
end event

event open;call super::open;string ls_yymmdd

select convert(char(08), getdate(),112)
into :ls_yymmdd
from dual;

dw_head.setitem(1, "deal_ymd", ls_yymmdd)
end event

type cb_close from w_com010_d`cb_close within w_42057_d
end type

type cb_delete from w_com010_d`cb_delete within w_42057_d
end type

type cb_insert from w_com010_d`cb_insert within w_42057_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42057_d
end type

type cb_update from w_com010_d`cb_update within w_42057_d
end type

type cb_print from w_com010_d`cb_print within w_42057_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_42057_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_42057_d
end type

type cb_excel from w_com010_d`cb_excel within w_42057_d
end type

type dw_head from w_com010_d`dw_head within w_42057_d
string dataobject = "d_42057_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()

THIS.GetChild("jup_gubn", idw_jup_gubn)
idw_jup_gubn.SetTransObject(SQLCA)
idw_jup_gubn.Retrieve('025')
idw_jup_gubn.InsertRow(1)
idw_jup_gubn.SetItem(1, "inter_cd", '%')
idw_jup_gubn.SetItem(1, "inter_nm", '전체')

This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if


end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "brand"
		dw_head.SetItem(1, "shop_cd", "")
		dw_head.SetItem(1, "shop_nm", "")
	CASE "shop_cd"	      //  Popup 검색창이 존재하는 항목
		IF ib_itemchanged THEN RETURN 1
		RETURN PARENT.TRIGGER EVENT ue_Popup(dwo.name, row, data, 1)

END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_42057_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_d`ln_2 within w_42057_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_42057_d
integer y = 436
integer height = 1600
string dataobject = "d_42057_d01"
end type

type dw_print from w_com010_d`dw_print within w_42057_d
end type

