$PBExportHeader$w_sh165_d.srw
$PBExportComments$직택수수료조회
forward
global type w_sh165_d from w_com010_d
end type
end forward

global type w_sh165_d from w_com010_d
end type
global w_sh165_d w_sh165_d

type variables
String is_fr_ymd, is_to_ymd , is_yymm
end variables

on w_sh165_d.create
call super::create
end on

on w_sh165_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;//dw_head.Setitem(1, "fr_ymd", RelativeDate(dw_head.GetitemDate(1, "to_ymd"), -7))
end event

event pfc_postopen();call super::pfc_postopen;if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

This.Trigger Event ue_retrieve()
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.23                                                  */	
/* 수정일      : 2002.04.23                                                  */
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

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
	MessageBox(ls_title,"조회 기준월을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("yymm")
	return false
end if


//if DaysAfter(dw_head.GetItemDate(1, "fr_ymd"), dw_head.GetItemDate(1, "to_ymd")) > 7 then
//   MessageBox(ls_title,"기간은 1주일 이내로 입력하십시오!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("to_ymd")
//   return false
//end if
//
//is_fr_ymd = String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
//is_to_ymd = String(dw_head.GetItemDate(1, "to_ymd"), "yyyymmdd")
//
//if is_fr_ymd > is_to_ymd then
//   MessageBox(ls_title,"시작일이 종료일 보다 큽니다 !")
//   dw_head.SetFocus()
//   dw_head.SetColumn("to_ymd")
//   return false
//end if
//
//if gs_brand_1 = 'X' then
//	gs_brand = dw_head.GetItemString(1, "brand")
//	if IsNull(gs_brand) or Trim(gs_brand) = "" then
//		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
//		dw_head.SetFocus()
//		dw_head.SetColumn("brand")
//		return false
//	end if
//end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.23                                                  */	
/* 수정일      : 2002.04.23                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(is_yymm, MidA(gs_shop_cd,1,1), gs_shop_cd)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_msg(1, il_rows)

end event

type cb_close from w_com010_d`cb_close within w_sh165_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh165_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh165_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh165_d
end type

type cb_update from w_com010_d`cb_update within w_sh165_d
end type

type cb_print from w_com010_d`cb_print within w_sh165_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_sh165_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_sh165_d
end type

type dw_head from w_com010_d`dw_head within w_sh165_d
integer height = 144
string dataobject = "d_sh165_h01"
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

type ln_1 from w_com010_d`ln_1 within w_sh165_d
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_d`ln_2 within w_sh165_d
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_d`dw_body within w_sh165_d
integer y = 336
integer height = 1500
string dataobject = "d_sh165_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_sh165_d
end type

