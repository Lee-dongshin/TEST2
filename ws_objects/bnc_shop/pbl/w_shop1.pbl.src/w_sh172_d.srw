$PBExportHeader$w_sh172_d.srw
$PBExportComments$매장행사완불요청확인
forward
global type w_sh172_d from w_com010_d
end type
end forward

global type w_sh172_d from w_com010_d
integer width = 2985
end type
global w_sh172_d w_sh172_d

type variables
String is_frm_ymd, is_to_ymd, is_style

end variables

on w_sh172_d.create
call super::create
end on

on w_sh172_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

is_frm_ymd = String(dw_head.GetItemDate(1, "frm_ymd"), "yyyymmdd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_ymd")
   return false
end if

is_to_ymd = String(dw_head.GetItemDate(1, "to_ymd"), "yyyymmdd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
 is_style = "%"
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
/*===========================================================================*/
String     ls_style_no
Boolean    lb_check 
DataStore  lds_Source

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = MidA(as_data,1,1)
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

CHOOSE CASE as_column
	CASE "style"				
			   gst_cd.ai_div          = ai_div
				gst_cd.window_title    = "STYLE 코드 검색" 
				gst_cd.datawindow_nm   = "d_com011" 
				gst_cd.default_where   = ""		//WHERE TB_11010_M.PART_FG IN ('1', '2', '3') 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " STYLE LIKE '" + LeftA(as_data, 8) + "%' "
				ELSE
					gst_cd.Item_where = ""
				END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("flag")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(is_frm_ymd, is_to_ymd, gs_shop_cd, is_style)
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

event open;call super::open;datetime ld_datetime
date ld_date
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd")

ld_date = Date(ls_datetime)

ls_datetime = String(ld_date, "yyyymmdd")

dw_head.setitem(1, "frm_ymd", ld_date)


end event

type cb_close from w_com010_d`cb_close within w_sh172_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh172_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh172_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh172_d
end type

type cb_update from w_com010_d`cb_update within w_sh172_d
end type

type cb_print from w_com010_d`cb_print within w_sh172_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_sh172_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_sh172_d
end type

type dw_head from w_com010_d`dw_head within w_sh172_d
integer y = 156
integer width = 2862
integer height = 176
string dataobject = "d_sh172_h01"
end type

event dw_head::itemchanged;call super::itemchanged;long ll_b_cnt
CHOOSE CASE dwo.name

	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if LenA(data) > 0 then
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		end if
		
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

type ln_1 from w_com010_d`ln_1 within w_sh172_d
integer beginy = 332
integer endy = 332
end type

type ln_2 from w_com010_d`ln_2 within w_sh172_d
integer beginy = 336
integer endy = 336
end type

type dw_body from w_com010_d`dw_body within w_sh172_d
integer y = 352
integer height = 1432
string dataobject = "d_sh172_d01"
end type

type dw_print from w_com010_d`dw_print within w_sh172_d
end type

