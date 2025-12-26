$PBExportHeader$w_sh137_d.srw
$PBExportComments$리오더입고예정
forward
global type w_sh137_d from w_com010_d
end type
end forward

global type w_sh137_d from w_com010_d
integer width = 2990
integer height = 2076
end type
global w_sh137_d w_sh137_d

type variables
string is_brand, is_style, is_gubn
datawindowchild  idw_brand

end variables

on w_sh137_d.create
call super::create
end on

on w_sh137_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                              */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

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
if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	is_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if


	
else
	is_brand = dw_head.GetItemString(1, "brand")
	if IsNull(is_brand) or Trim(is_brand) = "" then
		MessageBox(ls_title,"() 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if
is_style = dw_head.GetItemString(1, "style")
is_gubn = dw_head.GetItemString(1, "gubn")

if (gs_brand = 'N' or gs_brand = 'J') and is_brand = 'O' then

		MessageBox(ls_title,"매장에 맞는 유통 브랜드 코드를 확인하세요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
		
elseif (gs_brand = 'N' or gs_brand = 'J') and is_brand = 'D' then		
	
		MessageBox(ls_title,"매장에 맞는 유통 브랜드 코드를 확인하세요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
		
end if	

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                  */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	is_brand = dw_head.getitemstring(1,'brand')
end if

il_rows = dw_body.retrieve(is_brand, is_style, is_gubn)
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

type cb_close from w_com010_d`cb_close within w_sh137_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh137_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh137_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh137_d
end type

type cb_update from w_com010_d`cb_update within w_sh137_d
end type

type cb_print from w_com010_d`cb_print within w_sh137_d
end type

type cb_preview from w_com010_d`cb_preview within w_sh137_d
end type

type gb_button from w_com010_d`gb_button within w_sh137_d
end type

type dw_head from w_com010_d`dw_head within w_sh137_d
integer height = 140
string dataobject = "d_sh137_h01"
end type

event dw_head::constructor;call super::constructor;if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.object.brand.protect = 0
elseif MidA(gs_shop_cd_1,1,1) = 'N' or MidA(gs_shop_cd_1,1,1) = 'J' then
	dw_head.object.brand.protect = 0	
else
	dw_head.object.brand.protect = 1
end if


This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

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

type ln_1 from w_com010_d`ln_1 within w_sh137_d
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_d`ln_2 within w_sh137_d
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_d`dw_body within w_sh137_d
integer y = 348
integer height = 1480
string dataobject = "d_sh137_d01"
boolean hscrollbar = true
end type

event dw_body::clicked;call super::clicked;IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)
end event

type dw_print from w_com010_d`dw_print within w_sh137_d
end type

