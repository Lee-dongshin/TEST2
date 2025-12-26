$PBExportHeader$w_21092_b.srw
$PBExportComments$케어라벨생성처리
forward
global type w_21092_b from w_com010_d
end type
type cb_batch from commandbutton within w_21092_b
end type
end forward

global type w_21092_b from w_com010_d
windowstate windowstate = maximized!
cb_batch cb_batch
end type
global w_21092_b w_21092_b

type variables
string is_brand , is_year

end variables

on w_21092_b.create
int iCurrent
call super::create
this.cb_batch=create cb_batch
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_batch
end on

on w_21092_b.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_batch)
end on

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year)
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

event ue_keycheck;/*===========================================================================*/
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

is_brand = dw_head.GetItemString(1, "brand")
is_year = dw_head.GetItemString(1, "year")

if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

return true

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_21092_b","0")
end event

type cb_close from w_com010_d`cb_close within w_21092_b
end type

type cb_delete from w_com010_d`cb_delete within w_21092_b
end type

type cb_insert from w_com010_d`cb_insert within w_21092_b
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_21092_b
end type

type cb_update from w_com010_d`cb_update within w_21092_b
end type

type cb_print from w_com010_d`cb_print within w_21092_b
end type

type cb_preview from w_com010_d`cb_preview within w_21092_b
end type

type gb_button from w_com010_d`gb_button within w_21092_b
end type

type cb_excel from w_com010_d`cb_excel within w_21092_b
end type

type dw_head from w_com010_d`dw_head within w_21092_b
string dataobject = "d_21092_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('001')

this.getchild("year",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('002')
end event

type ln_1 from w_com010_d`ln_1 within w_21092_b
end type

type ln_2 from w_com010_d`ln_2 within w_21092_b
end type

type dw_body from w_com010_d`dw_body within w_21092_b
string dataobject = "d_21092_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_21092_b
end type

type cb_batch from commandbutton within w_21092_b
integer x = 2139
integer y = 272
integer width = 402
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "생성처리"
end type

event clicked;long ret
ret =  messagebox("실행확인","실행하시겠습니까..?",Exclamation!,YesNo!,1)
if ret = 1 then
	parent.trigger event ue_retrieve()
	if dw_body.rowcount() > 1 then
	
			if is_brand = 'N' then
			dw_body.SaveAs("C:\zebra\qbcom\label_n" ,Text!, FALSE)
		elseif is_brand = 'O' Then
			dw_body.SaveAs("C:\zebra\qbcom\label_o" ,Text!, FALSE)	
		elseif is_brand = 'W' Then
			dw_body.SaveAs("C:\zebra\qbcom\label_w" ,Text!, FALSE)	
		elseif is_brand = 'T' Then
			dw_body.SaveAs("C:\zebra\qbcom\label_t" ,Text!, FALSE)	
		end if
	
	end if
		
end if
return ret

end event

