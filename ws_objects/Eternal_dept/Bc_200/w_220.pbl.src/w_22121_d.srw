$PBExportHeader$w_22121_d.srw
$PBExportComments$품번별 자재출고 확인
forward
global type w_22121_d from w_com010_d
end type
end forward

global type w_22121_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_22121_d w_22121_d

type variables
DataWindowchild idw_brand
string  is_brand
end variables

on w_22121_d.create
call super::create
end on

on w_22121_d.destroy
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

return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand)
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

type cb_close from w_com010_d`cb_close within w_22121_d
end type

type cb_delete from w_com010_d`cb_delete within w_22121_d
end type

type cb_insert from w_com010_d`cb_insert within w_22121_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_22121_d
end type

type cb_update from w_com010_d`cb_update within w_22121_d
end type

type cb_print from w_com010_d`cb_print within w_22121_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_22121_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_22121_d
end type

type cb_excel from w_com010_d`cb_excel within w_22121_d
end type

type dw_head from w_com010_d`dw_head within w_22121_d
integer height = 164
string dataobject = "d_22121_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_d`ln_1 within w_22121_d
integer beginy = 360
integer endy = 360
end type

type ln_2 from w_com010_d`ln_2 within w_22121_d
integer beginy = 364
integer endy = 364
end type

type dw_body from w_com010_d`dw_body within w_22121_d
integer y = 376
integer height = 1664
string dataobject = "d_22121_d01"
end type

event dw_body::itemchanged;call super::itemchanged;string ls_insert, ls_delete, ls_style, ls_chno, ls_mat_cd, ls_mat_color
integer Net
ls_insert = "제외처리 하시겠습니까?"
ls_delete = "제외취소 하시겠습니까?"

choose case dwo.name
	case 'ignore_yn'
		ls_style = This.GetitemString(row, "style")
		ls_chno  = This.GetitemString(row, "chno")
		ls_mat_cd = This.GetitemString(row, "mat_cd")
		ls_mat_color  = MidA(This.GetitemString(row, "color_nm"),1,2)


		Net = MessageBox("확인", "제외처리 하시겠습니까?" , Exclamation!, OKCancel!, 2)
		
		IF Net = 1 THEN
			update tb_12025_d set ignore_yn = 'Y'
			where style  = :ls_style
			  and chno   = :ls_chno
			  and mat_cd = :ls_mat_cd
			  and mat_color = :ls_mat_color
	
			commit  USING SQLCA;
		end if			
				
		trigger event ue_retrieve()



end choose

end event

type dw_print from w_com010_d`dw_print within w_22121_d
end type

