$PBExportHeader$w_sh136_d.srw
$PBExportComments$리필입고예정
forward
global type w_sh136_d from w_com010_d
end type
type st_1 from statictext within w_sh136_d
end type
type st_2 from statictext within w_sh136_d
end type
type st_3 from statictext within w_sh136_d
end type
end forward

global type w_sh136_d from w_com010_d
integer width = 2990
integer height = 2076
long backcolor = 16777215
st_1 st_1
st_2 st_2
st_3 st_3
end type
global w_sh136_d w_sh136_d

type variables
string is_fr_ymd, is_to_ymd

end variables

on w_sh136_d.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
end on

on w_sh136_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;string   ls_title

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
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if	

return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, gs_shop_cd)
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

event open;call super::open;string ls_fr_ymd, ls_to_ymd

ls_to_ymd  = dw_head.GetitemString(1, "to_ymd")

select min(t_date)
into :ls_fr_ymd
from tb_date
where datepart(week, t_date) = datepart(week, :ls_to_ymd)
and t_date like left(:ls_to_ymd,4) + '%';


dw_head.Setitem(1, "fr_ymd", ls_fr_ymd)
end event

event pfc_postopen();call super::pfc_postopen;if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

This.Trigger Event ue_retrieve()
end event

type cb_close from w_com010_d`cb_close within w_sh136_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh136_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh136_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh136_d
end type

type cb_update from w_com010_d`cb_update within w_sh136_d
end type

type cb_print from w_com010_d`cb_print within w_sh136_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_sh136_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_sh136_d
long backcolor = 16777215
end type

type dw_head from w_com010_d`dw_head within w_sh136_d
integer y = 156
integer height = 168
string dataobject = "d_sh136_h01"
end type

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

type ln_1 from w_com010_d`ln_1 within w_sh136_d
end type

type ln_2 from w_com010_d`ln_2 within w_sh136_d
end type

type dw_body from w_com010_d`dw_body within w_sh136_d
string dataobject = "d_sh136_d01"
end type

type dw_print from w_com010_d`dw_print within w_sh136_d
end type

type st_1 from statictext within w_sh136_d
integer x = 155
integer y = 284
integer width = 1289
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 16777215
string text = "※조회 수량은 확정된 수량이 아닙니다."
boolean focusrectangle = false
end type

type st_2 from statictext within w_sh136_d
integer x = 215
integer y = 352
integer width = 2057
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 16777215
string text = "실입고분은 다음날 오전 ~"09.입고현황조회~" 에서 확인하시기 바랍니다!"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sh136_d
integer x = 37
integer y = 64
integer width = 2089
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 16777215
string text = "※ 기간내 배분 수량으로 최종 입고와 다를 수 있습니다."
boolean focusrectangle = false
end type

