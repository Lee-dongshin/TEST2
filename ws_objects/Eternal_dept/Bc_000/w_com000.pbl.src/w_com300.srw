$PBExportHeader$w_com300.srw
$PBExportComments$스타일정보창
forward
global type w_com300 from window
end type
type dw_6 from datawindow within w_com300
end type
type dw_5 from datawindow within w_com300
end type
type st_3 from statictext within w_com300
end type
type st_1 from statictext within w_com300
end type
type st_2 from statictext within w_com300
end type
type dw_2 from datawindow within w_com300
end type
type dw_1 from datawindow within w_com300
end type
type dw_4 from datawindow within w_com300
end type
type dw_3 from datawindow within w_com300
end type
end forward

global type w_com300 from window
integer width = 2043
integer height = 2184
boolean titlebar = true
string title = "스타일정보"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 67108864
event ue_chno_ddw ( )
event ue_chno ( )
event ue_retrieve ( )
dw_6 dw_6
dw_5 dw_5
st_3 st_3
st_1 st_1
st_2 st_2
dw_2 dw_2
dw_1 dw_1
dw_4 dw_4
dw_3 dw_3
end type
global w_com300 w_com300

type variables
string is_style, is_chno = '%'
datawindowchild idw_chno
end variables

event ue_chno();string ls_file_name , ls_color, ls_chno
long ll_row, ii, ll_rows, jj

is_style = dw_1.getitemstring(1,"style")
dw_2.insertrow(1)
dw_2.GetChild("chno", idw_chno)
idw_chno.SetTransObject(SQLCA)
idw_chno.Retrieve(is_style)
idw_chno.insertrow(1)
idw_chno.Setitem(1, "chno", "%")

ll_rows = dw_5.Retrieve(is_style, "%")
ll_row  = dw_6.Retrieve(is_style)

dw_3.visible = false
st_3.visible = false

// 사진이 없는 경우 있는 칼라를 찾아 사진 보이도록 작업
//ll_row = dw_1.RowCount()
ls_file_name = dw_1.getitemstring(1,"pic_dir")


if FileExists(ls_file_name) = false then 
	for ii = 1 to ll_rows
	 	 ls_color = dw_5.getitemstring(ii, "color")
		 
		 
		 for jj = 1 to ll_row
			 ls_chno = dw_6.getitemstring(jj, "chno")
			 select dbo.SF_PIC_COLOR_DIR(:is_style + :ls_chno,:ls_color)
			 into :ls_file_name
			 from dual ;
			 
			 if FileExists(ls_file_name) then
				messagebox("ls_file_name", ls_file_name)
				goto NextStep
			 end if
		next	 

	next
	
	NextStep:
	dw_1.setitem(1,"pic_dir", ls_file_name)
	st_3.visible = true
end if	




end event

event ue_retrieve();
string ls_file_name, ls_style, ls_color, ls_chno
integer jj, ll_rows, ll_row ,ll_row1, ii

is_style = dw_1.getitemstring(1,"style")
ll_rows = dw_1.retrieve(is_style, is_chno,'%')
ll_row1 = dw_6.retrieve(is_style)
ll_row  = dw_5.retrieve(is_style, '%')
st_3.visible = false
dw_3.visible = false
ls_file_name = dw_1.getitemstring(1,"pic_dir")

if FileExists(ls_file_name) = false then 
	for ii = 1 to ll_row
	 	 ls_color = dw_5.getitemstring(ii, "color")
		 
		 
		 for jj = 1 to ll_row1
			 ls_chno = dw_6.getitemstring(jj, "chno")
			 select dbo.SF_PIC_COLOR_DIR(:is_style + :ls_chno,:ls_color)
			 into :ls_file_name
			 from dual ;
			 
			 if FileExists(ls_file_name) then
				//messagebox("ls_file_name", ls_file_name)
				goto NextStep
			 end if
		next	 

	next
	
	NextStep:
	dw_1.setitem(1,"pic_dir", ls_file_name)
	st_3.visible = true
	
end if	

end event

on w_com300.create
this.dw_6=create dw_6
this.dw_5=create dw_5
this.st_3=create st_3
this.st_1=create st_1
this.st_2=create st_2
this.dw_2=create dw_2
this.dw_1=create dw_1
this.dw_4=create dw_4
this.dw_3=create dw_3
this.Control[]={this.dw_6,&
this.dw_5,&
this.st_3,&
this.st_1,&
this.st_2,&
this.dw_2,&
this.dw_1,&
this.dw_4,&
this.dw_3}
end on

on w_com300.destroy
destroy(this.dw_6)
destroy(this.dw_5)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.dw_4)
destroy(this.dw_3)
end on

event open;this.x = 500
this.y = 500

dw_1.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
dw_5.SetTransObject(SQLCA)
dw_6.SetTransObject(SQLCA)
post event ue_chno()
dw_3.visible = false
dw_4.visible = false

end event

type dw_6 from datawindow within w_com300
boolean visible = false
integer x = 1051
integer y = 1420
integer width = 571
integer height = 600
integer taborder = 30
string title = "none"
string dataobject = "d_chno_ddw"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_5 from datawindow within w_com300
boolean visible = false
integer x = 818
integer y = 1272
integer width = 896
integer height = 416
integer taborder = 20
string title = "none"
string dataobject = "d_com008"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_com300
boolean visible = false
integer x = 96
integer y = 1108
integer width = 846
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean italic = true
boolean underline = true
long textcolor = 16711680
long backcolor = 1090519039
string text = "※ 임의사진으로 대체합니다."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_com300
integer x = 672
integer y = 132
integer width = 325
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean italic = true
boolean underline = true
long textcolor = 16711680
long backcolor = 1090519039
string text = "Life Cycle"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;dw_3.visible = true
dw_3.retrieve(is_style, is_chno)
end event

type st_2 from statictext within w_com300
integer x = 64
integer y = 132
integer width = 393
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean italic = true
boolean underline = true
long textcolor = 16711680
long backcolor = 1090519039
string text = "판매상위매장"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;dw_4.visible = true
dw_4.retrieve(is_style)
end event

type dw_2 from datawindow within w_com300
integer x = 1381
integer y = 1184
integer width = 187
integer height = 68
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_chno_001"
boolean border = false
boolean livescroll = true
end type

event itemchanged;is_chno = data
post event ue_retrieve()

end event

type dw_1 from datawindow within w_com300
integer width = 2025
integer height = 2080
integer taborder = 10
string title = "none"
string dataobject = "d_style_color_pic"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
String 	ls_search, ls_pic_dir
if row > 0 then 
	choose case dwo.name
		case 'color', 'color_nm'
			ls_search 	= this.GetItemString(row,"color")
			if is_chno = '%' or isnull(is_chno) then 
				is_chno = '%' 
			end if
		if LenA(ls_search) >= 2 then gf_pic_color_dir(is_style+is_chno, ls_search,ls_pic_dir)
		//	messagebox('dir = ' , ls_pic_dir)
			dw_1.retrieve(is_style,is_chno,ls_search)
	end choose	
end if

end event

type dw_4 from datawindow within w_com300
boolean visible = false
integer y = 1208
integer width = 1847
integer height = 716
integer taborder = 30
string title = "none"
string dataobject = "d_style_shop_grp"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;dw_4.visible = false
end event

type dw_3 from datawindow within w_com300
boolean visible = false
integer x = 27
integer y = 1172
integer width = 1810
integer height = 728
integer taborder = 20
string title = "none"
string dataobject = "d_life_cycle"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;dw_3.visible = false
end event

