$PBExportHeader$w_21032_d.srw
$PBExportComments$전안법보관서류조회
forward
global type w_21032_d from w_com020_d
end type
type tab_1 from tab within w_21032_d
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
type cb_2 from commandbutton within tabpage_3
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
cb_2 cb_2
dw_3 dw_3
end type
type tab_1 from tab within w_21032_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type dw_print2 from datawindow within w_21032_d
end type
end forward

global type w_21032_d from w_com020_d
integer width = 3662
tab_1 tab_1
dw_print2 dw_print2
end type
global w_21032_d w_21032_d

type variables
DataWindowChild  idw_brand, idw_year, idw_color
String is_brand, is_year, is_style, is_chno, is_color, is_sub_style

string is_img_nm, is_pdf_nm
boolean bl_connect
end variables

on w_21032_d.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_print2=create dw_print2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_print2
end on

on w_21032_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_print2)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
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
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


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

is_year = dw_head.GetItemString(1, "year")
if LenA(is_year) <> 4 then
	is_year = '201'+is_year
end if

if IsNull(is_year)  then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
is_chno = dw_head.GetItemString(1, "chno")
is_color = dw_head.GetItemString(1, "color")
is_sub_style = dw_head.GetItemString(1, "sub_style")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */
/* 작성일      : 2002.02.05                                                  */
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_year, is_style, is_chno, is_color, is_sub_style)

dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;//dw_assort.SetTransObject(SQLCA)
//dw_db.SetTransObject(SQLCA) 

tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)
dw_print2.SetTransObject(SQLCA)

inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_3, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_2, "ScaleToRight&Bottom")
//inv_resize.of_Register(tab_1.tabpage_3.dw_3, "ScaleToRight&Bottom")
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.06                                                  */	
/* 수정일      : 2002.02.06                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_21032_d","0")
end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

//This.Trigger Event ue_title()
dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로

//dw_body.ShareData(dw_print)
tab_1.tabpage_1.dw_1.ShareData(dw_print)
tab_1.tabpage_2.dw_2.ShareData(dw_print2)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
   dw_print2.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로

tab_1.tabpage_1.dw_1.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_flag, ls_age_grp, ls_jumin , ls_given_fg, ls_given_ymd
String     ls_style,   ls_chno, ls_data , ls_sojae, ls_shop_type, ls_style_k
string     ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_year, ls_season, ls_tel_no
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style"				
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "chno", "")
					RETURN 0
				END IF 
				IF gf_style_chk(as_data, '%') = True THEN
				   dw_head.SetItem(al_row, "chno", "")
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "STYLE 코드 검색" 
			gst_cd.datawindow_nm   = "d_com013" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "STYLE LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				dw_head.SetItem(al_row, "chno",  lds_Source.GetItemString(1,"chno"))
				dw_head.SetItem(al_row, "color", lds_Source.GetItemString(1,"color"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("chno")
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

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
      else
         dw_head.SetFocus()
      end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
//         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if
END CHOOSE

end event

type cb_close from w_com020_d`cb_close within w_21032_d
integer x = 3205
end type

type cb_delete from w_com020_d`cb_delete within w_21032_d
end type

type cb_insert from w_com020_d`cb_insert within w_21032_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_21032_d
integer x = 2862
end type

type cb_update from w_com020_d`cb_update within w_21032_d
end type

type cb_print from w_com020_d`cb_print within w_21032_d
end type

type cb_preview from w_com020_d`cb_preview within w_21032_d
boolean visible = false
end type

type gb_button from w_com020_d`gb_button within w_21032_d
integer width = 3579
end type

type cb_excel from w_com020_d`cb_excel within w_21032_d
end type

type dw_head from w_com020_d`dw_head within w_21032_d
integer x = 18
integer y = 152
integer height = 148
string dataobject = "d_21032_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA) 
idw_brand.Retrieve('001')

this.getchild("year",idw_year)
idw_year.settransobject(sqlca)
idw_year.retrieve('002')


this.getchild("color",idw_color)
idw_color.settransobject(sqlca)
idw_color.retrieve()
idw_color.InsertRow(1)
idw_color.SetItem(1, "color", '%')
idw_color.SetItem(1, "color_enm", '전체')




// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
/*===========================================================================*/
String ls_yymmdd

CHOOSE CASE dwo.name
	CASE "style","sub_style"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
/*
CASE "year"
		dw_head.accepttext()
		is_year = dw_head.getitemstring(1,'year')
*/
END CHOOSE

end event

type ln_1 from w_com020_d`ln_1 within w_21032_d
integer beginy = 304
integer endy = 304
end type

type ln_2 from w_com020_d`ln_2 within w_21032_d
integer beginy = 308
integer endy = 308
end type

type dw_list from w_com020_d`dw_list within w_21032_d
integer x = 0
integer y = 320
integer width = 1705
integer height = 1680
string dataobject = "d_21032_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_sub_style, ls_ft_order

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_style = This.GetItemString(row, 'style') 
is_chno = This.GetItemString(row, 'chno') 
is_color	= This.GetItemString(row, 'color')
is_sub_style = This.GetItemString(row, 'sub_style')
ls_ft_order  = This.GetItemString(row, 'ft_order')

IF IsNull(is_style) THEN return

il_rows = tab_1.tabpage_1.dw_1.retrieve(is_brand, is_year, is_style, is_chno, is_color) 
IF il_rows > 0 THEN
	tab_1.tabpage_2.dw_2.retrieve(is_brand, is_year, is_style, is_chno, is_color)
	tab_1.tabpage_3.dw_3.retrieve(is_brand, is_year, ls_ft_order)
END IF 

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_21032_d
boolean visible = false
integer x = 2912
integer y = 464
integer width = 434
integer height = 660
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type st_1 from w_com020_d`st_1 within w_21032_d
integer x = 1710
integer y = 320
integer height = 1728
end type

type dw_print from w_com020_d`dw_print within w_21032_d
integer x = 2560
integer y = 236
string dataobject = "d_21032_d02"
end type

type tab_1 from tab within w_21032_d
integer x = 1728
integer y = 320
integer width = 1842
integer height = 1684
integer taborder = 50
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

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 1806
integer height = 1572
long backcolor = 79741120
string text = "제품설명서"
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
integer width = 2528
integer height = 1572
integer taborder = 20
string title = "none"
string dataobject = "d_21032_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 1806
integer height = 1572
long backcolor = 79741120
string text = "공급자적합성확인서"
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
integer width = 2528
integer height = 1572
integer taborder = 20
string title = "none"
string dataobject = "d_21032_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 1806
integer height = 1572
long backcolor = 79741120
string text = "Fiti 성적서"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_2 cb_2
dw_3 dw_3
end type

on tabpage_3.create
this.cb_2=create cb_2
this.dw_3=create dw_3
this.Control[]={this.cb_2,&
this.dw_3}
end on

on tabpage_3.destroy
destroy(this.cb_2)
destroy(this.dw_3)
end on

type cb_2 from commandbutton within tabpage_3
integer x = 1362
integer y = 16
integer width = 402
integer height = 84
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Acrobat 실행"
end type

event clicked;STRING ls_filename, LS_STRING
uint rtn, wstyle
long li_filenum

ls_filename = "c:\bnc_dept\pdfopen.bat"

ls_string = tab_1.tabpage_3.dw_3.getitemstring(1,'serial')

wstyle = 0		

li_FileNum = FileOpen(ls_filename, streamMode!, Write!, Shared!, Replace!)
FileWrite(li_FileNum, ls_string)	
FileClose(li_FileNum)
rtn = WinExec(ls_filename, wstyle)		
	
end event

type dw_3 from datawindow within tabpage_3
integer y = 12
integer width = 1358
integer height = 484
integer taborder = 20
string title = "none"
string dataobject = "d_21032_d05"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print2 from datawindow within w_21032_d
boolean visible = false
integer x = 2135
integer y = 132
integer width = 722
integer height = 840
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_21032_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

