$PBExportHeader$w_com900.srw
$PBExportComments$미리보기
forward
global type w_com900 from w_zoom
end type
type st_2 from statictext within w_com900
end type
type cb_1 from u_cb within w_com900
end type
type cb_2 from u_cb within w_com900
end type
type cb_3 from u_cb within w_com900
end type
type cb_4 from u_cb within w_com900
end type
type em_1 from u_em within w_com900
end type
type cb_5 from u_cb within w_com900
end type
type cb_7 from u_cb within w_com900
end type
type gb_2 from groupbox within w_com900
end type
type gb_4 from groupbox within w_com900
end type
end forward

global type w_com900 from w_zoom
integer x = 0
integer y = 0
integer width = 3653
integer height = 2284
string title = "미리보기"
st_2 st_2
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
em_1 em_1
cb_5 cb_5
cb_7 cb_7
gb_2 gb_2
gb_4 gb_4
end type
global w_com900 w_com900

on w_com900.create
int iCurrent
call super::create
this.st_2=create st_2
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.em_1=create em_1
this.cb_5=create cb_5
this.cb_7=create cb_7
this.gb_2=create gb_2
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.cb_4
this.Control[iCurrent+6]=this.em_1
this.Control[iCurrent+7]=this.cb_5
this.Control[iCurrent+8]=this.cb_7
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_4
end on

on w_com900.destroy
call super::destroy
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.em_1)
destroy(this.cb_5)
destroy(this.cb_7)
destroy(this.gb_2)
destroy(this.gb_4)
end on

event close;call super::close;inv_zoomattrib.idw_obj.ShareDataOff( )
end event

event open;call super::open;IF inv_zoomattrib.is_modify <> '' THEN
	dw_preview.Modify(inv_zoomattrib.is_modify)
END IF

end event

event pfc_preopen;call super::pfc_preopen;environment env
double ldb_size_X, ldb_size_Y

If GetEnvironment(env) <> 1 Then return

If env.screenwidth  = 800 Then return
If env.screenheight = 600 Then return

ldb_size_X =  env.screenwidth / 800
ldb_size_Y =  env.screenheight / 600

// 윈도우의 크기 변경
If This.windowstate = normal! Then
   This.Width  *= ldb_size_X
   This.Height *= ldb_size_Y
	dw_preview.width  = This.Width  - 35
   dw_preview.height = This.Height - 310
End If 


end event

type rb_200 from w_zoom`rb_200 within w_com900
boolean visible = false
integer x = 1394
integer y = 64
integer width = 251
boolean enabled = false
end type

type rb_100 from w_zoom`rb_100 within w_com900
boolean visible = false
integer x = 1394
integer y = 64
integer width = 233
boolean enabled = false
end type

type rb_75 from w_zoom`rb_75 within w_com900
boolean visible = false
integer x = 1394
integer y = 64
integer width = 233
boolean enabled = false
end type

type rb_50 from w_zoom`rb_50 within w_com900
boolean visible = false
integer x = 1394
integer y = 64
integer width = 233
boolean enabled = false
end type

type rb_25 from w_zoom`rb_25 within w_com900
boolean visible = false
integer x = 1394
integer y = 64
integer width = 233
boolean enabled = false
end type

type st_1 from w_zoom`st_1 within w_com900
integer x = 32
integer y = 80
integer width = 270
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = " 화면배율"
end type

type em_zoom from w_zoom`em_zoom within w_com900
integer x = 297
integer y = 64
integer taborder = 10
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
double increment = 10
end type

event em_zoom::enchange;dw_preview.object.datawindow.print.preview.zoom = This.text

end event

type cb_ok from w_zoom`cb_ok within w_com900
boolean visible = false
integer x = 1833
integer y = 64
integer width = 306
integer taborder = 0
boolean enabled = false
end type

type cb_cancel from w_zoom`cb_cancel within w_com900
integer x = 3227
integer y = 64
integer width = 306
integer taborder = 80
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "닫기(&C)"
end type

type cb_apply from w_zoom`cb_apply within w_com900
boolean visible = false
integer x = 1833
integer y = 64
integer width = 306
integer taborder = 100
end type

type dw_preview from w_zoom`dw_preview within w_com900
integer x = 5
integer y = 204
integer width = 3625
integer height = 1992
end type

event dw_preview::pfc_printdlg;//////////////////////////////////////////////////////////////////////////////
//	Event:  			pfc_printdlg
//	Arguments:		astr_printdlg:  print dialog structure by ref
//	Returns:			Integer - 1 if it succeeds and -1 if an error occurs
//	Description:	Opens the print dialog for this DataWindow, 
//						and sets the print values the user selected for the DW.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History	Version
//						5.0   Initial version
//////////////////////////////////////////////////////////////////////////////
//	Copyright ?1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
boolean			lb_collate
integer			li_copies
long				ll_rc
long				ll_pagecount
string				ls_pagecount
string				ls_pathname = "Output"
string				ls_filename
string				ls_copies
string				ls_collate
n_cst_platform		lnv_platform
n_cst_conversion	lnv_conversion
window				lw_parent

// Initialize printdlg structure with current print values of DW
astr_printdlg.b_allpages = true

ls_copies = this.Object.DataWindow.Print.Copies
if not IsNumber (ls_copies) then	ls_copies = "1"

li_copies = Integer (ls_copies)
astr_printdlg.l_copies = li_copies

ls_collate = this.Object.DataWindow.Print.Collate
lb_collate = lnv_conversion.of_Boolean (ls_collate)
astr_printdlg.b_collate = lb_collate

astr_printdlg.l_frompage = 1
astr_printdlg.l_minpage = 1

ls_pagecount = this.Describe ("Evaluate ('PageCount()', 1)")
if IsNumber (ls_pagecount) then
	ll_pagecount = Long (ls_pagecount)
	astr_printdlg.l_maxpage = ll_pagecount
	astr_printdlg.l_topage = ll_pagecount
end if

if this.GetSelectedRow (0) = 0 then	astr_printdlg.b_disableselection = true

// Allow printdlg structure to have additional values
// set before opening print dialog
this.event pfc_preprintdlg (astr_printdlg)

// Open print dialog
f_setplatform (lnv_platform, true)
this.of_GetParentWindow (lw_parent)
ll_rc = lnv_platform.of_PrintDlg (astr_printdlg, lw_parent)
f_setplatform (lnv_platform, false)

// Set print values of DW based on users selection
if ll_rc > 0 then
	// Page Range
	if astr_printdlg.b_allpages then
		this.Object.DataWindow.Print.Page.Range = ""
	elseif astr_printdlg.b_pagenums then
		this.Object.DataWindow.Print.Page.Range = &
			String (astr_printdlg.l_frompage) + "-" + String (astr_printdlg.l_topage)
	elseif astr_printdlg.b_selection then
		this.Object.DataWindow.Print.Page.Range = "selection"
	end if

	// Collate copies
	this.Object.DataWindow.Print.Collate = astr_printdlg.b_collate

	// Number of copies
	this.Object.DataWindow.Print.Copies = astr_printdlg.l_copies

	// Print to file (must prompt user for filename first)
	if astr_printdlg.b_printtofile then
		if GetFileSaveName ("Print to File", ls_pathname, ls_filename, "prn", &
			"Printer Files,*.prn,All Files,*.*") <= 0 then
			return -1
		else
			this.Object.DataWindow.Print.Filename = ls_pathname
		end if
	end if
end if

return ll_rc
end event

type gb_1 from w_zoom`gb_1 within w_com900
integer x = 18
integer y = 0
integer width = 1038
integer height = 192
string text = ""
end type

type gb_3 from w_zoom`gb_3 within w_com900
integer x = 1070
integer y = 0
integer width = 1335
integer height = 192
integer taborder = 0
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Page이동"
end type

type cb_dlghelp from w_zoom`cb_dlghelp within w_com900
boolean visible = false
integer x = 1609
integer y = 516
integer taborder = 0
end type

type st_2 from statictext within w_com900
integer x = 567
integer y = 80
integer width = 261
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "출력배율"
boolean focusrectangle = false
end type

type cb_1 from u_cb within w_com900
integer x = 1134
integer y = 64
integer width = 306
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "맨앞(&T)"
end type

event clicked;call super::clicked;dw_preview.event pfc_firstpage()
end event

type cb_2 from u_cb within w_com900
integer x = 1435
integer y = 64
integer width = 306
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "이전(&B)"
end type

event clicked;call super::clicked;dw_preview.event pfc_previouspage()
end event

type cb_3 from u_cb within w_com900
integer x = 1737
integer y = 64
integer width = 306
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "다음(&N)"
end type

event clicked;call super::clicked;dw_preview.event pfc_nextpage()
end event

type cb_4 from u_cb within w_com900
integer x = 2039
integer y = 64
integer width = 306
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "맨뒤(&E)"
end type

event clicked;call super::clicked;dw_preview.event pfc_lastpage()
end event

type em_1 from u_em within w_com900
event ue_enchange pbm_enchange
integer x = 795
integer y = 64
integer width = 229
integer height = 84
integer taborder = 20
boolean bringtotop = true
string text = "100"
string mask = "###"
boolean spin = true
double increment = 10
string minmax = "10~~200"
end type

event ue_enchange;//dw_preview.Object.DataWindow.print.Scale = integer(this.text)
dw_preview.Object.DataWindow.Zoom = this.text

end event

event modified;call super::modified;//dw_preview.Object.DataWindow.Print.Scale = integer(this.text)
dw_preview.Object.DataWindow.Zoom = this.text

end event

type cb_5 from u_cb within w_com900
integer x = 2775
integer y = 64
integer width = 306
integer taborder = 70
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "설정(&S)"
end type

event clicked;call super::clicked;PrintSetup()
dw_preview.object.datawindow.print.preview.zoom = em_zoom.text

end event

type cb_7 from u_cb within w_com900
integer x = 2473
integer y = 64
integer width = 306
integer taborder = 90
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "인쇄(&P)"
end type

event clicked;call super::clicked;dw_preview.Event pfc_Print()
end event

type gb_2 from groupbox within w_com900
integer x = 2423
integer width = 718
integer height = 192
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80263581
string text = "프린트"
borderstyle borderstyle = stylelowered!
end type

type gb_4 from groupbox within w_com900
integer x = 3159
integer width = 430
integer height = 192
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80263581
borderstyle borderstyle = stylelowered!
end type

