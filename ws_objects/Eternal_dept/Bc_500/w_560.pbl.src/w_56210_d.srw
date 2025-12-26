$PBExportHeader$w_56210_d.srw
$PBExportComments$매장계산서 인쇄
forward
global type w_56210_d from w_com010_d
end type
type st_1 from statictext within w_56210_d
end type
type dw_hidd from u_dw within w_56210_d
end type
type p_1 from picture within w_56210_d
end type
end forward

global type w_56210_d from w_com010_d
integer width = 3680
integer height = 2276
st_1 st_1
dw_hidd dw_hidd
p_1 p_1
end type
global w_56210_d w_56210_d

type variables
String is_brand, is_yymm, is_shop_div, is_flag, is_yn, is_yn2

end variables

on w_56210_d.create
int iCurrent
call super::create
this.st_1=create st_1
this.dw_hidd=create dw_hidd
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_hidd
this.Control[iCurrent+3]=this.p_1
end on

on w_56210_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_hidd)
destroy(this.p_1)
end on

event open;call super::open;dw_head.Setitem(1, "shop_div", 'G')
dw_head.Setitem(1, "flag", '%')

end event

event ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.06.03                                                  */	
/* 수정일      : 2002.06.03                                                  */
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

is_brand    = dw_head.GetItemString(1, "brand")
is_shop_div = dw_head.GetItemString(1, "shop_div")
is_yymm     = String(dw_head.GetItemDateTime(1, "yymm"), "yyyymm")
is_flag     = dw_head.GetItemString(1, "flag")

return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.03                                                  */	
/* 수정일      : 2002.06.03                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymm, is_brand, is_shop_div, is_flag)

IF il_rows > 0 THEN
	is_yn = 'Y'
   dw_body.SetFocus()
	cb_print.Enabled = True 
	cb_preview.Enabled = True 	
	cb_excel.Enabled = True 
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event ue_print();String  ls_shop_cd, ls_issue_date, ls_bill_no 
Long    i, ll_row, j, ll_row2

ll_row = dw_body.RowCount()
dw_print.dataobject = "d_com560"
dw_print.SetTransObject(SQLCA)

FOR i = 1 TO ll_row 
	IF dw_body.object.prn_yn[i] = 'N' THEN CONTINUE
	
	ls_shop_cd    = dw_body.GetitemString(i, "shop_cd")
	ll_row2 = dw_hidd.Retrieve(is_yymm, is_brand, ls_shop_cd, is_flag)
	For j = 1 To ll_row2
		ls_issue_date = dw_hidd.GetitemString(j, "issue_date")
		ls_bill_no    = dw_hidd.GetitemString(j, "bill_no")
		
		IF dw_print.Retrieve(is_yymm, ls_bill_no, ls_shop_cd, is_brand, ls_issue_date) > 0 THEN
			dw_print.Print()
		END IF 
	Next
NEXT 

end event

event pfc_preopen;call super::pfc_preopen;dw_hidd.SetTransObject(SQLCA)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56210_d","0")
end event

event ue_preview();String  ls_shop_cd, ls_issue_date, ls_bill_no 
Long    i, ll_row, j, ll_row2

ll_row = dw_body.RowCount()
dw_print.dataobject = "d_com560_a"
dw_print.SetTransObject(SQLCA)

FOR i = 1 TO ll_row 
	IF dw_body.object.prn_yn[i] = 'N' THEN CONTINUE
	
	ls_shop_cd    = dw_body.GetitemString(i, "shop_cd")
	ll_row2 = dw_hidd.Retrieve(is_yymm, is_brand, ls_shop_cd, is_flag)
	For j = 1 To ll_row2
		ls_issue_date = dw_hidd.GetitemString(j, "issue_date")
		ls_bill_no    = dw_hidd.GetitemString(j, "bill_no")
		
		IF dw_print.Retrieve(is_yymm, ls_bill_no, ls_shop_cd, is_brand, ls_issue_date) > 0 THEN
			dw_print.Print()
		END IF 
	Next
NEXT 

end event

type cb_close from w_com010_d`cb_close within w_56210_d
integer taborder = 110
end type

type cb_delete from w_com010_d`cb_delete within w_56210_d
integer taborder = 60
end type

type cb_insert from w_com010_d`cb_insert within w_56210_d
integer taborder = 50
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56210_d
end type

type cb_update from w_com010_d`cb_update within w_56210_d
integer taborder = 100
end type

type cb_print from w_com010_d`cb_print within w_56210_d
integer taborder = 70
end type

type cb_preview from w_com010_d`cb_preview within w_56210_d
integer taborder = 80
string text = "낱장인쇄(&V)"
end type

type gb_button from w_com010_d`gb_button within w_56210_d
end type

type cb_excel from w_com010_d`cb_excel within w_56210_d
integer taborder = 90
end type

type dw_head from w_com010_d`dw_head within w_56210_d
integer height = 136
string dataobject = "d_56210_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("shop_div", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('910')
ldw_child.SetFilter("inter_cd > 'A' and inter_cd < 'Z'")
ldw_child.Filter()
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '%')
ldw_child.SetItem(1, "inter_nm", '전체')

end event

type ln_1 from w_com010_d`ln_1 within w_56210_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_56210_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_56210_d
integer x = 9
integer y = 348
integer height = 1692
string dataobject = "d_56210_d01"
end type

event dw_body::buttonclicked;call super::buttonclicked;Long i, ll_row

ll_row = This.RowCount()

IF ll_row < 1 THEN RETURN 

IF is_yn = 'Y' THEN
	is_yn = 'N'
ELSE
	is_yn = 'Y'
END IF

FOR i = 1 TO ll_row 
	This.Setitem(i, "prn_yn", is_yn)
NEXT 

end event

event dw_body::doubleclicked;String ls_shop_cd
Long ll_row

ls_shop_cd = This.GetItemString(row, "shop_cd")

If IsNull(ls_shop_cd) or Trim(ls_shop_cd) = "" Then Return -1

ll_row = dw_hidd.Retrieve(is_yymm, is_brand, ls_shop_cd, is_flag)

If ll_row > 0 Then 
	is_yn2 = 'Y'
	dw_hidd.Visible = True
End If

end event

type dw_print from w_com010_d`dw_print within w_56210_d
string dataobject = "d_com560_a"
end type

type st_1 from statictext within w_56210_d
integer x = 146
integer y = 64
integer width = 1083
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "인쇄시 용지 : 사용자정의 (2100/2540)mm"
boolean focusrectangle = false
end type

type dw_hidd from u_dw within w_56210_d
boolean visible = false
integer x = 229
integer y = 496
integer width = 3095
integer height = 996
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "매장 내역"
string dataobject = "d_56210_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event buttonclicked;call super::buttonclicked;Long i, ll_row
String ls_shop_cd, ls_issue_date, ls_bill_no

Choose Case dwo.name
	Case 'b_yn'
		ll_row = This.RowCount()
		
		IF ll_row < 1 THEN RETURN 
		
		IF is_yn2 = 'Y' THEN
			is_yn2 = 'N'
		ELSE
			is_yn2 = 'Y'
		END IF
		
		FOR i = 1 TO ll_row 
			This.Setitem(i, "prn_yn", is_yn2)
		NEXT 
	Case 'b_print'
		ll_row = This.RowCount()
		
		IF ll_row < 1 THEN RETURN 
		
		FOR i = 1 TO ll_row 
			IF This.object.prn_yn[i] = 'N' THEN CONTINUE
			ls_shop_cd    = This.GetitemString(i, "shop_cd")
			ls_issue_date = This.GetitemString(i, "issue_date")
			ls_bill_no    = This.GetitemString(i, "bill_no")
			
			IF dw_print.Retrieve(is_yymm, ls_bill_no, ls_shop_cd, is_brand, ls_issue_date) > 0 THEN
				dw_print.Print()
			END IF 
		NEXT 
		
	Case 'b_close'
		This.Visible = False
End Choose

end event

type p_1 from picture within w_56210_d
integer x = 41
integer y = 60
integer width = 73
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "lemp.bmp"
boolean focusrectangle = false
end type

