$PBExportHeader$w_42028_d.srw
$PBExportComments$점간이동 거래명세서 출력
forward
global type w_42028_d from w_com010_d
end type
type cbx_laser from checkbox within w_42028_d
end type
end forward

global type w_42028_d from w_com010_d
cbx_laser cbx_laser
end type
global w_42028_d w_42028_d

type variables
DataWindowChild idw_brand, idw_shop_div

String is_brand, is_fr_ymd, is_to_ymd, is_shop_div, is_shop_cd, is_shop_type, is_flag, is_opt

end variables

on w_42028_d.create
int iCurrent
call super::create
this.cbx_laser=create cbx_laser
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_laser
end on

on w_42028_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_laser)
end on

event open;call super::open;dw_head.SetItem(1,"shop_div","%")

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_div, is_flag, is_opt)

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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	


is_fr_ymd = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
IF IsNull(is_fr_ymd) OR is_fr_ymd = "" THEN
   MessageBox(ls_title,"기준 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   RETURN FALSE
END IF

is_to_ymd = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
IF IsNull(is_to_ymd) OR is_to_ymd = "" THEN
   MessageBox(ls_title,"기준 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF

IF is_to_ymd < is_fr_ymd THEN
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
IF IsNull(is_shop_div) OR is_shop_div = "" THEN
   MessageBox(ls_title,"유통망 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   RETURN FALSE
END IF

is_flag = Trim(dw_head.GetItemString(1, "flag"))
IF IsNull(is_flag) OR is_flag = "" THEN
   MessageBox(ls_title,"조회 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("flag")
   RETURN FALSE
END IF

is_opt = Trim(dw_head.GetItemString(1, "opt"))
IF IsNull(is_opt) OR is_opt = "" THEN
   MessageBox(ls_title,"조회 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt")
   RETURN FALSE
END IF

RETURN TRUE

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long i, ll_chk = 0

if cbx_laser.checked then
	dw_print.DataObject = "d_com421_A1"
	dw_print.SetTransObject(SQLCA)
ELSE
	dw_print.DataObject = "d_com421_a"
	dw_print.SetTransObject(SQLCA)
END IF	


For i = 1 To dw_body.RowCount()
	If dw_body.GetItemString(i, "print_yn") = 'Y' Then
		
		ll_chk++
		is_shop_cd    = dw_body.GetItemString(i, "shop_cd")

		il_rows = dw_print.Retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_flag, is_opt)
		
		IF il_rows > 0 Then il_rows = dw_print.Print()
	End If
Next 

If ll_chk = 0 Then
	MessageBox("인쇄오류", "인쇄할 데이터를 선택하십시요!")
End If

This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42028_d","0")
end event

type cb_close from w_com010_d`cb_close within w_42028_d
end type

type cb_delete from w_com010_d`cb_delete within w_42028_d
end type

type cb_insert from w_com010_d`cb_insert within w_42028_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42028_d
end type

type cb_update from w_com010_d`cb_update within w_42028_d
end type

type cb_print from w_com010_d`cb_print within w_42028_d
end type

type cb_preview from w_com010_d`cb_preview within w_42028_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_42028_d
end type

type cb_excel from w_com010_d`cb_excel within w_42028_d
end type

type dw_head from w_com010_d`dw_head within w_42028_d
integer y = 168
integer height = 132
string dataobject = "d_42028_h01"
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

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

type ln_1 from w_com010_d`ln_1 within w_42028_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_42028_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_42028_d
integer x = 9
integer y = 348
integer width = 3593
integer height = 1696
string dataobject = "d_42028_d01"
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

type dw_print from w_com010_d`dw_print within w_42028_d
integer x = 425
integer y = 140
string dataobject = "d_com421_a"
end type

type cbx_laser from checkbox within w_42028_d
integer x = 832
integer y = 60
integer width = 544
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "명세서(Laser)"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

