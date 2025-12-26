$PBExportHeader$w_61006_d.srw
$PBExportComments$매출추이현황
forward
global type w_61006_d from w_com010_d
end type
type tab_1 from tab within w_61006_d
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tab_1 from tab within w_61006_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type rb_1 from radiobutton within w_61006_d
end type
type rb_2 from radiobutton within w_61006_d
end type
type rb_3 from radiobutton within w_61006_d
end type
type rb_4 from radiobutton within w_61006_d
end type
end forward

global type w_61006_d from w_com010_d
integer width = 3675
integer height = 2248
string title = "일자별매출추이"
tab_1 tab_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
end type
global w_61006_d w_61006_d

type variables
/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
DataWindowChild	idw_brand
String 				is_brand, is_base_yymm, is_gubun, is_shopping_yn
Boolean lb_ret_chk1 = False, lb_ret_chk2 = False, lb_ret_chk3 = False

end variables

on w_61006_d.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
end on

on w_61006_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "base_yymm", ld_datetime)

end event

event pfc_preopen;call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_3.dw_3, "ScaleToRight&Bottom")

tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
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

is_brand	= Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) OR is_brand= "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_base_yymm = Trim(String(dw_head.GetItemDatetime(1, "base_yymm"), 'yyyymm'))
if IsNull(is_base_yymm) OR is_base_yymm = "" then
   MessageBox(ls_title,"기준 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("base_yymm")
   return false
end if

is_gubun	= Trim(dw_head.GetItemString(1, "gubun"))
if IsNull(is_gubun) OR is_gubun = "" then
   MessageBox(ls_title,"조회 기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubun")
   return false
end if

is_shopping_yn	= Trim(dw_head.GetItemString(1, "shopping_yn"))
if IsNull(is_shopping_yn) OR is_shopping_yn = "" then
   MessageBox(ls_title,"쇼핑몰 제외여부를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shopping_yn")
   return false
end if

return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if  rb_1.checked then
		Choose Case tab_1.SelectedTab
			Case 1
				il_rows = tab_1.tabpage_1.dw_1.retrieve(is_brand, is_base_yymm, is_gubun, is_shopping_yn)
				lb_ret_chk1 = True
			Case 2
				il_rows = tab_1.tabpage_2.dw_2.retrieve(is_brand, is_base_yymm, is_gubun, is_shopping_yn)
				lb_ret_chk2 = True
			Case 3
				il_rows = tab_1.tabpage_3.dw_3.retrieve(is_brand, is_base_yymm, is_gubun)
				lb_ret_chk3 = True
		END Choose
else
		Choose Case tab_1.SelectedTab
			Case 1
				il_rows = tab_1.tabpage_1.dw_1.retrieve(is_base_yymm)
				lb_ret_chk1 = True
			Case 2
				il_rows = tab_1.tabpage_2.dw_2.retrieve(is_base_yymm)
				lb_ret_chk2 = True
			Case 3
				il_rows = tab_1.tabpage_3.dw_3.retrieve(is_base_yymm)
				lb_ret_chk3 = True
		END Choose
end if
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

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
//         cb_retrieve.Text = "조건(&Q)"
//         dw_head.Enabled = false
//         dw_body.Enabled = true
//         tab_1.Enabled = true
//         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
//		dw_body.Enabled = false
//		tab_1.Enabled = false
//		lb_ret_chk1 = False
//		lb_ret_chk2 = False
//		lb_ret_chk3 = False
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_gubun

Choose Case Tab_1.SelectedTab
	Case 1
		dw_print.DataObject = 'd_61006_r01'
		dw_print.SetTransObject(SQLCA)
		Tab_1.TabPage_1.dw_1.ShareData(dw_print)
		If is_brand = 'N' or is_brand = 'J' Then
			ls_modify = "t_sale_amt3.Text = 'JMJ~n~r실적'" + &
							"t_sale_amt4.Text = 'JMJ~n~r누계'"
		Else
			ls_modify = "t_sale_amt3.Text = '예소~n~r실적'" + &
							"t_sale_amt4.Text = '예소~n~r누계'"
		End If
	Case 2
		dw_print.DataObject = 'd_61006_r02'
		dw_print.SetTransObject(SQLCA)
		Tab_1.TabPage_2.dw_2.ShareData(dw_print)
	Case 3
		dw_print.DataObject = 'd_61006_r03'
		dw_print.SetTransObject(SQLCA)
		Tab_1.TabPage_3.dw_3.ShareData(dw_print)
End Choose

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_gubun = 'Y' Then
	ls_gubun = '운영 매장'
Else
	ls_gubun = '전체 매장'
End IF

ls_modify =	"t_pg_id.Text     = '" + is_pgm_id + "'" + &
            "t_user_id.Text   = '" + gs_user_id + "'" + &
            "t_datetime.Text  = '" + ls_datetime + "'" + &
            "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_base_yymm.Text = '" + String(is_base_yymm, '@@@@/@@')+ "'" + &
            "t_gubun.Text     = '" + ls_gubun + "'" + &
            ls_modify
				
dw_print.Modify(ls_modify)

end event

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_excel;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)
Choose Case Tab_1.SelectedTab
	Case 1
		li_ret = Tab_1.TabPage_1.dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 2
		li_ret = Tab_1.TabPage_2.dw_2.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 3
		li_ret = Tab_1.TabPage_3.dw_3.SaveAs(ls_doc_nm, Excel!, TRUE)
End Choose

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61006_d","0")
end event

type cb_close from w_com010_d`cb_close within w_61006_d
end type

type cb_delete from w_com010_d`cb_delete within w_61006_d
end type

type cb_insert from w_com010_d`cb_insert within w_61006_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61006_d
end type

type cb_update from w_com010_d`cb_update within w_61006_d
end type

type cb_print from w_com010_d`cb_print within w_61006_d
end type

type cb_preview from w_com010_d`cb_preview within w_61006_d
end type

type gb_button from w_com010_d`gb_button within w_61006_d
end type

type cb_excel from w_com010_d`cb_excel within w_61006_d
end type

type dw_head from w_com010_d`dw_head within w_61006_d
integer x = 896
integer y = 164
integer width = 2651
integer height = 176
string dataobject = "d_61006_h01"
end type

event dw_head::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::itemchanged;call super::itemchanged;lb_ret_chk1 = False
lb_ret_chk2 = False
lb_ret_chk3 = False

end event

type ln_1 from w_com010_d`ln_1 within w_61006_d
integer beginx = 14
integer beginy = 440
integer endx = 3634
integer endy = 440
end type

type ln_2 from w_com010_d`ln_2 within w_61006_d
integer beginx = 14
integer beginy = 444
integer endx = 3634
integer endy = 444
end type

type dw_body from w_com010_d`dw_body within w_61006_d
boolean visible = false
integer y = 376
integer height = 1664
boolean enabled = false
end type

type dw_print from w_com010_d`dw_print within w_61006_d
string dataobject = "d_61006_r01"
end type

type tab_1 from tab within w_61006_d
event type boolean ue_keycheck ( string as_cb_div )
integer x = 14
integer y = 452
integer width = 3579
integer height = 1564
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
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

is_brand	= Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) OR is_brand= "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_base_yymm = Trim(String(dw_head.GetItemDatetime(1, "base_yymm"), 'yyyymm'))
if IsNull(is_base_yymm) OR is_base_yymm = "" then
   MessageBox(ls_title,"기준 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("base_yymm")
   return false
end if

is_gubun	= Trim(dw_head.GetItemString(1, "gubun"))
if IsNull(is_gubun) OR is_gubun = "" then
   MessageBox(ls_title,"조회 기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubun")
   return false
end if
is_shopping_yn	= Trim(dw_head.GetItemString(1, "shopping_yn"))
if IsNull(is_shopping_yn) OR is_shopping_yn = "" then
   MessageBox(ls_title,"쇼핑몰 제외여부를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shopping_yn")
   return false
end if
return true

end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

event selectionchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
If oldindex > 0 Then
	
	/* dw_head 필수입력 column check */
	IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
	
	  if  rb_1.checked then
			Choose Case newindex
				Case 1
					If lb_ret_chk1 = False Then
						il_rows = This.Tabpage_1.dw_1.Retrieve(is_brand, is_base_yymm, is_gubun,is_shopping_yn)
						lb_ret_chk1 = True
					End If
				Case 2
					If lb_ret_chk2 = False Then
						il_rows = This.Tabpage_2.dw_2.Retrieve(is_brand, is_base_yymm, is_gubun,is_shopping_yn)
						lb_ret_chk2 = True
					End If
				Case 3
					If lb_ret_chk3 = False Then
						il_rows = This.Tabpage_3.dw_3.Retrieve(is_brand, is_base_yymm, is_gubun)
						lb_ret_chk3 = True
					End If
			End Choose
	   else		
			Choose Case newindex
				Case 1
					If lb_ret_chk1 = False Then
						il_rows = This.Tabpage_1.dw_1.Retrieve( is_base_yymm )
						lb_ret_chk1 = True
					End If
				Case 2
					If lb_ret_chk2 = False Then
						il_rows = This.Tabpage_2.dw_2.Retrieve( is_base_yymm )
						lb_ret_chk2 = True
					End If
				Case 3
					If lb_ret_chk3 = False Then
						il_rows = This.Tabpage_3.dw_3.Retrieve( is_base_yymm )
						lb_ret_chk3 = True
					End If
			End Choose
		end if		
End If

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3543
integer height = 1452
long backcolor = 79741120
string text = "전년대비실적현황"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within tabpage_1
integer x = 9
integer y = 16
integer width = 3511
integer height = 1436
integer taborder = 20
string title = "none"
string dataobject = "d_61006_D01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3543
integer height = 1452
long backcolor = 79741120
string text = "목표대비실적현황"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_2
integer x = 9
integer y = 16
integer width = 3515
integer height = 1440
integer taborder = 10
string title = "none"
string dataobject = "d_61006_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3543
integer height = 1452
long backcolor = 79741120
string text = "그래프(꺽은선)"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from datawindow within tabpage_3
integer x = 9
integer y = 16
integer width = 3515
integer height = 1496
integer taborder = 10
string title = "none"
string dataobject = "d_61006_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_61006_d
integer x = 96
integer y = 160
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "매장"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor    = RGB(0, 0, 255)
rb_2.TextColor    = 0

tab_1.tabpage_1.dw_1.dataObject = "d_61006_d01"
tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)

tab_1.tabpage_2.dw_2.dataObject = "d_61006_d02"
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)

tab_1.tabpage_3.dw_3.dataObject = "d_61006_d03"
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)

dw_head.Object.brand.Visible = 1
dw_head.Object.t_1.Visible = 1
dw_head.Object.gubun.Visible = 1
dw_head.Object.shopping_yn.Visible = 1

il_rows = tab_1.tabpage_1.dw_1.retrieve(is_brand, is_base_yymm, is_gubun, is_shopping_yn)
il_rows = tab_1.tabpage_2.dw_2.retrieve(is_brand, is_base_yymm, is_gubun, is_shopping_yn)
il_rows = tab_1.tabpage_3.dw_3.retrieve(is_brand, is_base_yymm, is_gubun)

end event

type rb_2 from radiobutton within w_61006_d
integer x = 96
integer y = 220
integer width = 722
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "라빠레트(면세점 구분)"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor    = RGB(0, 0, 255)
rb_1.TextColor    = 0



tab_1.tabpage_1.dw_1.dataObject = "d_61006_s01"
tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)

tab_1.tabpage_2.dw_2.dataObject = "d_61006_s02"
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)

tab_1.tabpage_3.dw_3.dataObject = "d_61006_s03"
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)


trigger Event ue_keycheck('1')


dw_head.Object.brand.Visible = 0
dw_head.Object.t_1.Visible = 0
dw_head.Object.gubun.Visible = 0
dw_head.Object.shopping_yn.Visible = 0




tab_1.tabpage_1.dw_1.retrieve(is_base_yymm)

tab_1.tabpage_2.dw_2.retrieve(is_base_yymm)

tab_1.tabpage_3.dw_3.retrieve(is_base_yymm)
		
end event

type rb_3 from radiobutton within w_61006_d
integer x = 96
integer y = 288
integer width = 1234
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "조이그라이슨 (면세점 구분)"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor    = RGB(0, 0, 255)
rb_1.TextColor    = 0



tab_1.tabpage_1.dw_1.dataObject = "d_61006_L01"
tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)

tab_1.tabpage_2.dw_2.dataObject = "d_61006_L02"
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)

tab_1.tabpage_3.dw_3.dataObject = "d_61006_L03"
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)


trigger Event ue_keycheck('1')


dw_head.Object.brand.Visible = 0
dw_head.Object.t_1.Visible = 0
dw_head.Object.gubun.Visible = 0
dw_head.Object.shopping_yn.Visible = 0




tab_1.tabpage_1.dw_1.retrieve(is_base_yymm)

tab_1.tabpage_2.dw_2.retrieve(is_base_yymm)

tab_1.tabpage_3.dw_3.retrieve(is_base_yymm)
		
end event

type rb_4 from radiobutton within w_61006_d
integer x = 96
integer y = 360
integer width = 1234
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "루에브르 (면세점 구분)"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor    = RGB(0, 0, 255)
rb_1.TextColor    = 0



tab_1.tabpage_1.dw_1.dataObject = "d_61006_F01"
tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)

tab_1.tabpage_2.dw_2.dataObject = "d_61006_F02"
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)

tab_1.tabpage_3.dw_3.dataObject = "d_61006_F03"
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)


trigger Event ue_keycheck('1')


dw_head.Object.brand.Visible = 0
dw_head.Object.t_1.Visible = 0
dw_head.Object.gubun.Visible = 0
dw_head.Object.shopping_yn.Visible = 0




tab_1.tabpage_1.dw_1.retrieve(is_base_yymm)

tab_1.tabpage_2.dw_2.retrieve(is_base_yymm)

tab_1.tabpage_3.dw_3.retrieve(is_base_yymm)
		
end event

