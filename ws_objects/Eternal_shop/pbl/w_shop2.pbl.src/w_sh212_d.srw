$PBExportHeader$w_sh212_d.srw
$PBExportComments$고객수선리스트
forward
global type w_sh212_d from w_com010_d
end type
end forward

global type w_sh212_d from w_com010_d
long backcolor = 16777215
end type
global w_sh212_d w_sh212_d

type variables
string is_shop_cd, is_fr_yymmdd, is_to_yymmdd, is_judg_fg
datawindowchild idw_judg_fg


end variables

on w_sh212_d.create
call super::create
end on

on w_sh212_d.destroy
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

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"() 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
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

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_judg_fg   = dw_head.GetItemString(1, "judg_fg")

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                  */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_shop_cd, is_fr_yymmdd, is_to_yymmdd, is_judg_fg)
IF il_rows > 0 THEN
//   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
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

event pfc_preopen();call super::pfc_preopen;
dw_head.setitem(1,"shop_cd",gs_shop_cd)
dw_head.setitem(1,"shop_nm",gs_shop_nm)

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.setitem(1,"shop_cd",'N' + gs_shop_div + MidA(gs_shop_cd,3,4))
	dw_head.setitem(1,"shop_nm",gs_shop_nm)
else
	dw_head.setitem(1,"shop_cd",gs_shop_cd)
	dw_head.setitem(1,"shop_nm",gs_shop_nm)
end if


end event

event open;call super::open;string yymmdd
yymmdd=String(now(),"yyyymmdd")

dw_head.setitem(1,"fr_yymmdd",yymmdd)
dw_head.setitem(1,"to_yymmdd",yymmdd)
end event

type cb_close from w_com010_d`cb_close within w_sh212_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh212_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh212_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh212_d
end type

type cb_update from w_com010_d`cb_update within w_sh212_d
end type

type cb_print from w_com010_d`cb_print within w_sh212_d
end type

type cb_preview from w_com010_d`cb_preview within w_sh212_d
end type

type gb_button from w_com010_d`gb_button within w_sh212_d
long backcolor = 16777215
end type

type dw_head from w_com010_d`dw_head within w_sh212_d
integer x = 9
integer y = 164
integer width = 2843
integer height = 196
string dataobject = "d_sh212_h01"
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

			if MidA(gs_shop_cd_1,1,2) = 'XX' then
				dw_head.setitem(1,"shop_cd",gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4))
				dw_head.setitem(1,"shop_nm",gs_shop_nm)
			else
				dw_head.setitem(1,"shop_cd",gs_shop_cd)
				dw_head.setitem(1,"shop_nm",gs_shop_nm)
			end if

			gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
			Trigger Event ue_retrieve()
	
END CHOOSE
		
end event

type ln_1 from w_com010_d`ln_1 within w_sh212_d
integer beginy = 368
integer endy = 368
end type

type ln_2 from w_com010_d`ln_2 within w_sh212_d
integer beginy = 372
integer endy = 372
end type

type dw_body from w_com010_d`dw_body within w_sh212_d
integer y = 384
integer width = 2857
integer height = 1404
string dataobject = "d_sh212_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_sh212_d
end type

