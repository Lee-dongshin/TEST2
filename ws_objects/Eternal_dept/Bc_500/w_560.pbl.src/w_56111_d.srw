$PBExportHeader$w_56111_d.srw
$PBExportComments$판매수수료 지급내역서 (개인)
forward
global type w_56111_d from w_com010_d
end type
end forward

global type w_56111_d from w_com010_d
integer width = 3685
integer height = 2280
end type
global w_56111_d w_56111_d

type variables
DataWindowChild idw_brand, idw_shop_div, idw_comm_fg

String is_brand, is_yymm, is_shop_div, is_comm_fg
String is_shop_cd, is_shop_nm, is_sale_emp, is_sale_empnm, is_bigo

end variables

on w_56111_d.create
call super::create
end on

on w_56111_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_head.SetItem(1,"shop_div","%")
dw_head.SetItem(1,"comm_fg","%")

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymm, is_shop_div, is_comm_fg)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

THIS.TRIGGER EVENT ue_button(1, il_rows)
THIS.TRIGGER EVENT ue_msg(1, il_rows)

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
String ls_modify

ls_modify =	"t_yymm.Text     = '" + String(is_yymm, '@@@@.@@') + "'" + &
            "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_shop_cd.Text  = '" + is_shop_cd + ' ' + is_shop_nm + "'" + &
            "t_sale_emp.Text = '" + is_sale_emp + ' ' + is_sale_empnm + "'" + &
            "t_bigo.Text = ' ~* 참고 : " + is_bigo + "'"

dw_print.Modify(ls_modify)

end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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
is_brand = Trim(dw_head.GetItemString(1, "brand"))
IF IsNull(is_brand) OR is_brand = "" THEN
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF

is_yymm = Trim(String(dw_head.GetItemDateTime(1, "yymm"), 'yyyymm'))
IF IsNull(is_yymm) OR is_yymm = "" THEN
   MessageBox(ls_title,"기준 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   RETURN FALSE
END IF

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
IF IsNull(is_shop_div) OR is_shop_div = "" THEN
   MessageBox(ls_title,"유통망 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   RETURN FALSE
END IF

is_comm_fg = Trim(dw_head.GetItemString(1, "comm_fg"))
IF IsNull(is_comm_fg) OR is_comm_fg = "" THEN
   MessageBox(ls_title,"수수료 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("comm_fg")
   RETURN FALSE
END IF

is_bigo = Trim(dw_head.GetItemString(1, "bigo"))
IF IsNull(is_bigo) OR is_bigo = "" THEN is_bigo = ' '

RETURN TRUE

end event

event ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long i, ll_chk = 0

For i = 1 To dw_body.RowCount()
	If dw_body.GetItemString(i, "print_yn") = 'Y' Then
		
		ll_chk++
		is_shop_cd    = dw_body.GetItemString(i, "shop_cd")
		is_shop_nm    = dw_body.GetItemString(i, "shop_nm")
		is_sale_emp   = dw_body.GetItemString(i, "sale_emp")
		is_sale_empnm = dw_body.GetItemString(i, "sale_empnm")

		This.Trigger Event ue_title ()

		il_rows = dw_print.Retrieve(is_brand, is_yymm, is_shop_cd, is_sale_emp)
		
		IF il_rows > 0 Then il_rows = dw_print.Print()
	End If
Next 

If ll_chk = 0 Then
	MessageBox("인쇄오류", "인쇄할 데이터를 선택하십시요!")
End If

This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56111_d","0")
end event

type cb_close from w_com010_d`cb_close within w_56111_d
end type

type cb_delete from w_com010_d`cb_delete within w_56111_d
end type

type cb_insert from w_com010_d`cb_insert within w_56111_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56111_d
end type

type cb_update from w_com010_d`cb_update within w_56111_d
end type

type cb_print from w_com010_d`cb_print within w_56111_d
end type

type cb_preview from w_com010_d`cb_preview within w_56111_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_56111_d
end type

type cb_excel from w_com010_d`cb_excel within w_56111_d
end type

type dw_head from w_com010_d`dw_head within w_56111_d
integer y = 168
integer height = 324
string dataobject = "d_56111_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

THIS.GetChild("comm_fg", idw_comm_fg)
idw_comm_fg.SetTransObject(SQLCA)
idw_comm_fg.Retrieve('919')
idw_comm_fg.InsertRow(1)
idw_comm_fg.SetItem(1, "inter_cd", '%')
idw_comm_fg.SetItem(1, "inter_nm", '전체')

end event

type ln_1 from w_com010_d`ln_1 within w_56111_d
integer beginy = 520
integer endy = 520
end type

type ln_2 from w_com010_d`ln_2 within w_56111_d
integer beginy = 524
integer endy = 524
end type

type dw_body from w_com010_d`dw_body within w_56111_d
integer x = 9
integer y = 540
integer width = 3593
integer height = 1504
string dataobject = "d_56111_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report
Long i

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

If ls_column_nm = 'print_yn' and dwo.Text = '제외' Then
	For i = 1 To This.RowCount()
		This.SetItem(i, "print_yn", 'N')
	Next
	
	dwo.Text = '선택'
ElseIf ls_column_nm = 'print_yn' and dwo.Text = '선택' Then
	For i = 1 To This.RowCount()
		This.SetItem(i, "print_yn", 'Y')
	Next
	
	dwo.Text = '제외'
End If

end event

type dw_print from w_com010_d`dw_print within w_56111_d
integer x = 425
integer y = 140
string dataobject = "d_56111_r01"
end type

