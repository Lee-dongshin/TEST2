$PBExportHeader$w_21011_d.srw
$PBExportComments$스타일별 부자재 발주서
forward
global type w_21011_d from w_com010_d
end type
type cbx_a from checkbox within w_21011_d
end type
type cbx_b from checkbox within w_21011_d
end type
type cbx_d from checkbox within w_21011_d
end type
type cbx_c from checkbox within w_21011_d
end type
type cbx_e from checkbox within w_21011_d
end type
type cbx_f from checkbox within w_21011_d
end type
end forward

global type w_21011_d from w_com010_d
integer width = 3675
integer height = 2280
windowstate windowstate = maximized!
event ue_confirm ( string as_sign,  checkbox as_dwo )
cbx_a cbx_a
cbx_b cbx_b
cbx_d cbx_d
cbx_c cbx_c
cbx_e cbx_e
cbx_f cbx_f
end type
global w_21011_d w_21011_d

type variables
string is_ord_origin

end variables

event ue_confirm(string as_sign, checkbox as_dwo);// 20060624부로 폐기(김도균) -- 발주서 단위로 관리
//string ls_style, ls_chno, ls_user_level
//
//ls_style 		 = dw_body.getitemstring(1,"style")
//ls_chno 			 = dw_body.getitemstring(1,"chno")
//
//
//if as_dwo.checked then
//	ls_user_level   = as_sign
//end if
//
//update tb_12021_d set smat_confirm = :ls_user_level where style =:ls_style and chno = :ls_chno ; 
//commit  USING SQLCA;
//	

end event

on w_21011_d.create
int iCurrent
call super::create
this.cbx_a=create cbx_a
this.cbx_b=create cbx_b
this.cbx_d=create cbx_d
this.cbx_c=create cbx_c
this.cbx_e=create cbx_e
this.cbx_f=create cbx_f
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_a
this.Control[iCurrent+2]=this.cbx_b
this.Control[iCurrent+3]=this.cbx_d
this.Control[iCurrent+4]=this.cbx_c
this.Control[iCurrent+5]=this.cbx_e
this.Control[iCurrent+6]=this.cbx_f
end on

on w_21011_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_a)
destroy(this.cbx_b)
destroy(this.cbx_d)
destroy(this.cbx_c)
destroy(this.cbx_e)
destroy(this.cbx_f)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_title

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

is_ord_origin = dw_head.GetItemString(1, "ord_origin")
if IsNull(is_ord_origin) or Trim(is_ord_origin) = "" then
   MessageBox(ls_title,"스타일번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("ord_origin")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_user_level, ls_smat_confirm
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_ord_origin, gs_user_id)
IF il_rows > 0 THEN
//	ls_user_level 		 = dw_body.getitemstring(1,"user_level")
//	ls_smat_confirm 	 = dw_body.getitemstring(1,"smat_confirm")
//
//	choose case ls_smat_confirm
//		case 'A'
//			cbx_a.checked = true
//		CASE 'B'
//			cbx_a.checked = true
//			cbx_b.checked = true
//			
//		CASE 'C'
//			cbx_a.checked = true
//			cbx_b.checked = true
//			cbx_c.checked = true
//			
//		CASE 'D'
//			cbx_a.checked = true
//			cbx_b.checked = true
//			cbx_c.checked = true
//			cbx_d.checked = true
//			
//		CASE 'E'
//			cbx_a.checked = true
//			cbx_b.checked = true
//			cbx_c.checked = true
//			cbx_d.checked = true
//			cbx_e.checked = true
//			
//		CASE 'F'
//			cbx_a.checked = true
//			cbx_b.checked = true
//			cbx_c.checked = true
//			cbx_d.checked = true
//			cbx_e.checked = true
//			cbx_f.checked = true
//			
//	end choose
//
//	   if ls_user_level >= 'A' then 
//			cbx_a.enabled = true
//			cbx_a.backcolor = rgb(255,0,0)
//		end if
//		
//	   if ls_user_level >= 'B' then 
//			cbx_b.enabled = true
//			cbx_b.backcolor = rgb(255,0,0)
//		end if
//
//	   if ls_user_level >= 'C' then 
//			cbx_c.enabled = true
//			cbx_c.backcolor = rgb(255,0,0)
//		end if
//
//	   if ls_user_level >= 'D' then 
//			cbx_d.enabled = true
//			cbx_d.backcolor = rgb(255,0,0)
//		end if
//
//	   if ls_user_level >= 'E' then 
//			cbx_e.enabled = true
//			cbx_e.backcolor = rgb(255,0,0)
//		end if
//
//	   if ls_user_level >= 'F' then 
//			cbx_f.enabled = true
//			cbx_f.backcolor = rgb(255,0,0)
//		end if
//
		

			
   dw_body.SetFocus()
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
	CASE "ord_origin"
	
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				END IF 
			END IF	

			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "제품 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "Where brand     = brand " 

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " style like '" + LeftA(as_data,8) +"%'"
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
				dw_head.SetItem(al_row, "ord_origin", lds_Source.GetItemString(1,"style")+lds_Source.GetItemString(1,"chno"))

				/* 다음컬럼으로 이동 */
				dw_head.scrolltorow(1)
				dw_head.SetColumn("ord_origin")
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

event open;call super::open;
if isnull(gsv_cd.gs_cd10) or gsv_cd.gs_cd10 = '' then
else
	dw_head.setitem(1,"ord_origin", gsv_cd.gs_cd10)
	setnull(gsv_cd.gs_cd10)
	setnull(gsv_cd.gs_cd9)
	trigger event ue_retrieve()
end if

end event

type cb_close from w_com010_d`cb_close within w_21011_d
end type

type cb_delete from w_com010_d`cb_delete within w_21011_d
end type

type cb_insert from w_com010_d`cb_insert within w_21011_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_21011_d
end type

event cb_retrieve::clicked;/*===========================================================================*/
/* 작성자      : M.S.I (김태범) 															  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

//This.Enabled = False
oldpointer = SetPointer(HourGlass!)

IF dw_head.Enabled THEN
	Parent.Trigger Event ue_retrieve()	//조회
ELSE
	Parent.Trigger Event ue_head()	//조건
END IF

SetPointer(oldpointer)
This.Enabled = True

end event

type cb_update from w_com010_d`cb_update within w_21011_d
end type

type cb_print from w_com010_d`cb_print within w_21011_d
end type

type cb_preview from w_com010_d`cb_preview within w_21011_d
end type

type gb_button from w_com010_d`gb_button within w_21011_d
end type

type cb_excel from w_com010_d`cb_excel within w_21011_d
end type

type dw_head from w_com010_d`dw_head within w_21011_d
integer height = 148
string dataobject = "d_21011_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "ord_origin"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_21011_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_21011_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_21011_d
event ue_save ( long row )
integer y = 344
integer height = 1696
string dataobject = "d_21011_d01"
end type

event dw_body::ue_save(long row);string ls_brand, ls_ord_ymd, ls_ord_no, ls_smat_confirm, ls_smat_confirm2, ls_smat_confirm3
IF dw_body.AcceptText() <> 1 THEN return

ls_smat_confirm  = dw_body.GetItemString(row, "smat_confirm")
ls_smat_confirm2 = dw_body.GetItemString(row, "smat_confirm2")
ls_smat_confirm3 = dw_body.GetItemString(row, "smat_confirm3")

ls_ord_ymd = dw_body.GetItemString(row, "mat_ord_ymd")
ls_ord_no = dw_body.GetItemString(row, "ord_no")
ls_brand = dw_body.GetItemString(row, "brand")

//messagebox('brand', ls_brand)
//messagebox('ls_ord_ymd', ls_ord_ymd)
//messagebox('ls_ord_no', ls_ord_no)
//messagebox('ls_smat_confirm', ls_smat_confirm)
update a 
	set smat_confirm  = :ls_smat_confirm,
	    smat_confirm2 = :ls_smat_confirm2,
	    smat_confirm3 = :ls_smat_confirm3
from tb_21020_m a(nolock)
where brand   = :ls_brand
and   ord_ymd = :ls_ord_ymd
and   ord_no  = :ls_ord_no;

commit  USING SQLCA;
end event

event dw_body::itemchanged;call super::itemchanged;IF dw_body.AcceptText() <> 1 THEN return
post event ue_save(row)

end event

type dw_print from w_com010_d`dw_print within w_21011_d
string dataobject = "d_21011_r01"
end type

type cbx_a from checkbox within w_21011_d
boolean visible = false
integer x = 1806
integer y = 688
integer width = 114
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 12632256
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event clicked;parent.trigger event ue_confirm('A',this)
end event

type cbx_b from checkbox within w_21011_d
boolean visible = false
integer x = 2071
integer y = 688
integer width = 114
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 12632256
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event clicked;parent.trigger event ue_confirm('B',this)
end event

type cbx_d from checkbox within w_21011_d
boolean visible = false
integer x = 2615
integer y = 688
integer width = 114
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 12632256
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event clicked;parent.trigger event ue_confirm('D',this)
end event

type cbx_c from checkbox within w_21011_d
boolean visible = false
integer x = 2345
integer y = 688
integer width = 114
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 12632256
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event clicked;parent.trigger event ue_confirm('C',this)
end event

type cbx_e from checkbox within w_21011_d
boolean visible = false
integer x = 2894
integer y = 688
integer width = 114
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 12632256
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event clicked;parent.trigger event ue_confirm('E',this)
end event

type cbx_f from checkbox within w_21011_d
boolean visible = false
integer x = 3168
integer y = 688
integer width = 114
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 12632256
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event clicked;parent.trigger event ue_confirm('F',this)
end event

