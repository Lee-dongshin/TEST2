$PBExportHeader$w_sh331_d.srw
$PBExportComments$부자재 누락조회
forward
global type w_sh331_d from w_com010_d
end type
end forward

global type w_sh331_d from w_com010_d
long backcolor = 16777215
end type
global w_sh331_d w_sh331_d

type variables
string is_fr_ymd, is_to_ymd, is_apply_yymm, is_rpt_gubn

end variables

on w_sh331_d.create
call super::create
end on

on w_sh331_d.destroy
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


is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
is_to_ymd = dw_head.GetItemString(1, "to_ymd")
is_apply_yymm = dw_head.GetItemString(1, "yymm")

is_rpt_gubn = dw_head.GetItemString(1, "rpt_opt")

if is_rpt_gubn = "A" then
	is_apply_yymm = "%"
else	
	is_fr_ymd = "20140101"
	is_to_ymd = "99999999"
end if	

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_brand = dw_head.getitemstring(1,'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_apply_yymm, gs_shop_cd, gs_brand)
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

type cb_close from w_com010_d`cb_close within w_sh331_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh331_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh331_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh331_d
end type

type cb_update from w_com010_d`cb_update within w_sh331_d
end type

type cb_print from w_com010_d`cb_print within w_sh331_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_sh331_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_sh331_d
long backcolor = 16777215
end type

type dw_head from w_com010_d`dw_head within w_sh331_d
integer width = 2830
string dataobject = "d_sh331_h01"
end type

event dw_head::itemchanged;call super::itemchanged;long ll_b_cnt
CHOOSE CASE dwo.name

	CASE "brand"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			dw_head.accepttext()
			gs_brand = dw_head.getitemstring(1,'brand')

			select isnull(count(brand),0)
			into	:ll_b_cnt
			from tb_91100_m  with (nolock) 
			where shop_cd like '%' + substring(:gs_shop_cd_1,3,4)
					and brand = :gs_brand;	
					
			if ll_b_cnt = 0 then 
				messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
				dw_body.reset()
				return 0
			end if

			gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
			Trigger Event ue_retrieve()
	
END CHOOSE
		
end event

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.object.brand_t.visible = true
	dw_head.object.brand.visible = true
else
	dw_head.object.brand_t.visible = false
	dw_head.object.brand.visible = false
end if


end event

type ln_1 from w_com010_d`ln_1 within w_sh331_d
end type

type ln_2 from w_com010_d`ln_2 within w_sh331_d
end type

type dw_body from w_com010_d`dw_body within w_sh331_d
integer width = 2853
integer height = 1316
string dataobject = "d_sh331_d01"
end type

type dw_print from w_com010_d`dw_print within w_sh331_d
end type

