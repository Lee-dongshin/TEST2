$PBExportHeader$w_eis.srw
$PBExportComments$메뉴 및 판매현황
forward
global type w_eis from w_sheet
end type
type cb_1 from commandbutton within w_eis
end type
type tab_1 from tab within w_eis
end type
type tabpage_1 from userobject within tab_1
end type
type dw_4 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_4 dw_4
end type
type tabpage_2 from userobject within tab_1
end type
type dw_5 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_5 dw_5
end type
type tabpage_3 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_4 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_3 dw_3
end type
type tabpage_5 from userobject within tab_1
end type
type dw_6 from datawindow within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_6 dw_6
end type
type tab_1 from tab within w_eis
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
type dw_1 from uo_menubar within w_eis
end type
end forward

global type w_eis from w_sheet
integer x = 5
integer y = 4
integer width = 3657
integer height = 2188
string title = "매출 집계 조회"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean toolbarvisible = false
cb_1 cb_1
tab_1 tab_1
dw_1 dw_1
end type
global w_eis w_eis

on w_eis.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.tab_1=create tab_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.dw_1
end on

on w_eis.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.tab_1)
destroy(this.dw_1)
end on

event pfc_preopen();call super::pfc_preopen;of_SetResize(True)

inv_resize.of_Register(dw_1, "ScaleToBottom")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
//inv_resize.of_Register(tab_1 , "ScaleToBottom")
inv_resize.of_Register(tab_1.Tabpage_1.dw_4, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.Tabpage_2.dw_5, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.Tabpage_3.dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.Tabpage_4.dw_3, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.Tabpage_5.dw_6, "ScaleToRight&Bottom")
//inv_resize.of_Register(tab_1.Tabpage_1.dw_4, "ScaleToBottom")
//inv_resize.of_Register(tab_1.Tabpage_2.dw_5, "ScaleToBottom")

This.ParentWindow().Trigger ArrangeSheets(Layer!)

tab_1.Tabpage_1.dw_4.SetTRansObject(SQLCA)
tab_1.Tabpage_2.dw_5.SetTRansObject(SQLCA)
tab_1.Tabpage_3.dw_2.SetTRansObject(SQLCA)
tab_1.Tabpage_4.dw_3.SetTRansObject(SQLCA)
tab_1.Tabpage_5.dw_6.SetTRansObject(SQLCA)

end event

event pfc_postopen();call super::pfc_postopen;dw_1.SetTransObject(SQLCA) 
dw_1.of_outlookbar(1)
dw_1.Retrieve("W_EIS1000")
tab_1.Tabpage_2.dw_5.SetRedRaw(FALSE)
tab_1.Tabpage_2.dw_5.Retrieve()
tab_1.Tabpage_2.dw_5.SetRedRaw(True)

tab_1.Tabpage_3.dw_2.SetRedRaw(FALSE)
tab_1.Tabpage_3.dw_2.Retrieve()
tab_1.Tabpage_3.dw_2.SetRedRaw(True)

tab_1.Tabpage_1.dw_4.SetRedRaw(FALSE)
tab_1.Tabpage_1.dw_4.Retrieve()
tab_1.Tabpage_1.dw_4.SetRedRaw(TRUE)

tab_1.Tabpage_4.dw_3.SetRedRaw(FALSE)
tab_1.Tabpage_4.dw_3.Retrieve()
tab_1.Tabpage_4.dw_3.SetRedRaw(True)


tab_1.Tabpage_5.dw_6.SetRedRaw(FALSE)
tab_1.Tabpage_5.dw_6.Retrieve()
tab_1.Tabpage_5.dw_6.SetRedRaw(True)

end event

event timer;call super::timer;//tab_1.Tabpage_2.dw_5.SetRedRaw(FALSE)
//tab_1.Tabpage_2.dw_5.Retrieve()
//tab_1.Tabpage_2.dw_5.SetRedRaw(True)
//tab_1.Tabpage_1.dw_4.SetRedRaw(FALSE)
//tab_1.Tabpage_1.dw_4.Retrieve()
//tab_1.Tabpage_1.dw_4.SetRedRaw(TRUE)
//
end event

event open;call super::open;//Timer(600)
//  tab_1.Tabpage_1.dw_4.Object.DataWindow.HorizontalScrollSplit  = 762
end event

type cb_1 from commandbutton within w_eis
integer x = 3195
integer y = 8
integer width = 384
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회"
end type

event clicked;tab_1.Tabpage_2.dw_5.SetRedRaw(FALSE)
tab_1.Tabpage_2.dw_5.Retrieve()
tab_1.Tabpage_2.dw_5.SetRedRaw(True)
tab_1.Tabpage_1.dw_4.SetRedRaw(FALSE)
tab_1.Tabpage_1.dw_4.Retrieve()
tab_1.Tabpage_1.dw_4.SetRedRaw(TRUE)
tab_1.Tabpage_3.dw_2.SetRedRaw(FALSE)
tab_1.Tabpage_3.dw_2.Retrieve()
tab_1.Tabpage_3.dw_2.SetRedRaw(True)
tab_1.Tabpage_4.dw_3.SetRedRaw(FALSE)
tab_1.Tabpage_4.dw_3.Retrieve()
tab_1.Tabpage_4.dw_3.SetRedRaw(True)
tab_1.Tabpage_5.dw_6.SetRedRaw(FALSE)
tab_1.Tabpage_5.dw_6.Retrieve()
tab_1.Tabpage_5.dw_6.SetRedRaw(True)
end event

type tab_1 from tab within w_eis
integer x = 722
integer y = 8
integer width = 2862
integer height = 2020
integer taborder = 20
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
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2825
integer height = 1908
long backcolor = 79741120
string text = "요일별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_4 dw_4
end type

on tabpage_1.create
this.dw_4=create dw_4
this.Control[]={this.dw_4}
end on

on tabpage_1.destroy
destroy(this.dw_4)
end on

type dw_4 from datawindow within tabpage_1
integer y = 8
integer width = 2821
integer height = 1884
integer taborder = 30
string dataobject = "d_60000_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2825
integer height = 1908
long backcolor = 79741120
string text = "일/월/년계"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_2.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_2.destroy
destroy(this.dw_5)
end on

type dw_5 from datawindow within tabpage_2
integer y = 8
integer width = 2821
integer height = 1884
integer taborder = 30
string title = "none"
string dataobject = "d_60000_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2825
integer height = 1908
long backcolor = 79741120
string text = "일/월/년계2"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_3.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_3.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_3
integer y = 8
integer width = 2821
integer height = 1884
integer taborder = 40
string title = "none"
string dataobject = "d_60000_d01a"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2825
integer height = 1908
long backcolor = 79741120
string text = "직영몰일별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_4.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_4.destroy
destroy(this.dw_3)
end on

type dw_3 from datawindow within tabpage_4
integer y = 4
integer width = 2825
integer height = 1888
integer taborder = 40
string title = "none"
string dataobject = "d_60000_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2825
integer height = 1908
long backcolor = 79741120
string text = "직영몰 일/월/년계"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_6 dw_6
end type

on tabpage_5.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tabpage_5.destroy
destroy(this.dw_6)
end on

type dw_6 from datawindow within tabpage_5
integer x = 5
integer y = 12
integer width = 2821
integer height = 1896
integer taborder = 40
string title = "none"
string dataobject = "d_60000_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from uo_menubar within w_eis
integer x = 5
integer y = 4
integer width = 704
integer height = 1988
integer taborder = 10
end type

event clicked;call super::clicked;String ls_win_id, ls_win_nm, ls_pgm_stat
Window lw_window
Long   ll_Top 

CHOOSE CASE dwo.name 
	CASE "pgm_nm" 
	   ls_pgm_stat = This.GetitemString(row, "pgm_stat")
	   ls_win_nm   = This.GetitemString(row, "pgm_nm")
		IF gl_user_level = 999 OR ls_pgm_stat = 'B' THEN
		   ls_win_id = This.GetitemString(row, "pgm_id")
		   lw_window = Parent.ParentWindow()
		   gf_open_sheet(lw_window, ls_win_id, ls_win_nm)
		ELSE
		   MessageBox(ls_win_nm, "사용할수 없는 프로그램 입니다.") 
		END IF
	CASE ELSE
		IF MidA(dwo.name, 1, 7) = "lookbar" THEN 
			ll_Top = Long(MidA(dwo.name, 9))
			This.of_outlookbar(ll_Top)
			gs_menu_id = This.Describe(dwo.name + ".Tag")
			This.Retrieve(gs_menu_id)
		END IF
END CHOOSE
end event

