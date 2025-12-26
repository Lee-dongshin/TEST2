$PBExportHeader$w_21001_k.srw
$PBExportComments$자재코드등록 테스트
forward
global type w_21001_k from window
end type
type cb_9 from commandbutton within w_21001_k
end type
type st_8 from statictext within w_21001_k
end type
type em_printzoom from editmask within w_21001_k
end type
type st_7 from statictext within w_21001_k
end type
type st_6 from statictext within w_21001_k
end type
type em_zoom from editmask within w_21001_k
end type
type cb_8 from commandbutton within w_21001_k
end type
type cb_7 from commandbutton within w_21001_k
end type
type cb_6 from commandbutton within w_21001_k
end type
type sle_2 from singlelineedit within w_21001_k
end type
type cb_5 from commandbutton within w_21001_k
end type
type cb_4 from commandbutton within w_21001_k
end type
type cb_3 from commandbutton within w_21001_k
end type
type em_1 from editmask within w_21001_k
end type
type cb_2 from commandbutton within w_21001_k
end type
type cb_1 from commandbutton within w_21001_k
end type
type ddlb_4 from dropdownlistbox within w_21001_k
end type
type st_4 from statictext within w_21001_k
end type
type ddlb_3 from dropdownlistbox within w_21001_k
end type
type st_3 from statictext within w_21001_k
end type
type st_2 from statictext within w_21001_k
end type
type st_1 from statictext within w_21001_k
end type
type ddlb_1 from dropdownlistbox within w_21001_k
end type
type sle_1 from singlelineedit within w_21001_k
end type
type st_5 from statictext within w_21001_k
end type
type gb_1 from groupbox within w_21001_k
end type
type dw_body from datawindow within w_21001_k
end type
type dw_print from datawindow within w_21001_k
end type
end forward

global type w_21001_k from window
string tag = "W_21001_K"
integer width = 3721
integer height = 1980
boolean titlebar = true
string title = "테스트조회"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
event ue_preview ( )
event ue_excel ( )
cb_9 cb_9
st_8 st_8
em_printzoom em_printzoom
st_7 st_7
st_6 st_6
em_zoom em_zoom
cb_8 cb_8
cb_7 cb_7
cb_6 cb_6
sle_2 sle_2
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
em_1 em_1
cb_2 cb_2
cb_1 cb_1
ddlb_4 ddlb_4
st_4 st_4
ddlb_3 ddlb_3
st_3 st_3
st_2 st_2
st_1 st_1
ddlb_1 ddlb_1
sle_1 sle_1
st_5 st_5
gb_1 gb_1
dw_body dw_body
dw_print dw_print
end type
global w_21001_k w_21001_k

event ue_excel();string ls_doc_nm, ls_nm

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
li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

on w_21001_k.create
this.cb_9=create cb_9
this.st_8=create st_8
this.em_printzoom=create em_printzoom
this.st_7=create st_7
this.st_6=create st_6
this.em_zoom=create em_zoom
this.cb_8=create cb_8
this.cb_7=create cb_7
this.cb_6=create cb_6
this.sle_2=create sle_2
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.em_1=create em_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.ddlb_4=create ddlb_4
this.st_4=create st_4
this.ddlb_3=create ddlb_3
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.ddlb_1=create ddlb_1
this.sle_1=create sle_1
this.st_5=create st_5
this.gb_1=create gb_1
this.dw_body=create dw_body
this.dw_print=create dw_print
this.Control[]={this.cb_9,&
this.st_8,&
this.em_printzoom,&
this.st_7,&
this.st_6,&
this.em_zoom,&
this.cb_8,&
this.cb_7,&
this.cb_6,&
this.sle_2,&
this.cb_5,&
this.cb_4,&
this.cb_3,&
this.em_1,&
this.cb_2,&
this.cb_1,&
this.ddlb_4,&
this.st_4,&
this.ddlb_3,&
this.st_3,&
this.st_2,&
this.st_1,&
this.ddlb_1,&
this.sle_1,&
this.st_5,&
this.gb_1,&
this.dw_body,&
this.dw_print}
end on

on w_21001_k.destroy
destroy(this.cb_9)
destroy(this.st_8)
destroy(this.em_printzoom)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.em_zoom)
destroy(this.cb_8)
destroy(this.cb_7)
destroy(this.cb_6)
destroy(this.sle_2)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.em_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.ddlb_4)
destroy(this.st_4)
destroy(this.ddlb_3)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.ddlb_1)
destroy(this.sle_1)
destroy(this.st_5)
destroy(this.gb_1)
destroy(this.dw_body)
destroy(this.dw_print)
end on

event open;int newwidth, newheight
String year, inter_cd, inter_nm


dw_body.SetTransObject(sqlca)

select convert(varchar,getdate(),112)
into :year
from dual;




em_1.text = LeftA(year,4)

sle_2.text = '전 체'

em_zoom.text = '100'

st_6.visible = false
st_7.visible = false
st_8.visible = false
cb_7.visible = false
cb_8.visible = false
cb_9.visible = false
em_zoom.visible = false
em_printzoom.visible = false



//select inter_cd,
//		 inter_nm
//  into :inter_cd, :inter_nm
//  from tb_91011_C
// where inter_grp = '001'
//   and isnull(inter_data2,'X')  <> 'none'
// ORDER BY SORT_SEQ;


ddlb_1.SelectItem(1)

ddlb_3.SelectItem(1)

ddlb_4.SelectItem(1)

end event

event close;Close (this)
end event

event resize;


newwidth = this.WorkSpaceWidth() 
newheight = this.WorkSpaceHeight()

dw_body.resize(newwidth, newheight - 296)
dw_print.resize(newwidth, newheight - 296)
end event

type cb_9 from commandbutton within w_21001_k
integer x = 1842
integer y = 112
integer width = 466
integer height = 88
integer taborder = 170
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "프린트 설정(&S)"
end type

event clicked;PrintSetup()
dw_print.setfocus()
end event

type st_8 from statictext within w_21001_k
integer x = 1093
integer y = 132
integer width = 238
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "Page이동"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_printzoom from editmask within w_21001_k
event enchange pbm_enchange
integer x = 837
integer y = 116
integer width = 215
integer height = 84
integer taborder = 140
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "100"
borderstyle borderstyle = stylelowered!
string mask = "###"
boolean spin = true
double increment = 10
string minmax = "10~~200"
end type

event enchange;dw_print.Object.DataWindow.Zoom = this.text
dw_print.setfocus()
end event

event modified;dw_print.Object.DataWindow.Zoom = this.text
dw_print.setfocus()
end event

type st_7 from statictext within w_21001_k
integer x = 571
integer y = 132
integer width = 238
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "출력배율"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_6 from statictext within w_21001_k
integer x = 64
integer y = 132
integer width = 238
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 82899184
string text = "화면배율"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_zoom from editmask within w_21001_k
event enchange pbm_enchange
integer x = 329
integer y = 116
integer width = 215
integer height = 84
integer taborder = 130
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "###"
boolean spin = true
double increment = 10
string minmax = "10~~200"
end type

event enchange;dw_print.object.datawindow.print.preview.zoom = This.text
dw_print.setfocus()
end event

type cb_8 from commandbutton within w_21001_k
integer x = 1358
integer y = 116
integer width = 133
integer height = 84
integer taborder = 150
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "◀"
end type

event clicked;dw_print.ScrollPriorPage()
dw_print.setfocus()
end event

type cb_7 from commandbutton within w_21001_k
integer x = 1490
integer y = 116
integer width = 133
integer height = 84
integer taborder = 160
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "▶"
end type

event clicked;dw_print.ScrollNextPage()
dw_print.setfocus()
end event

type cb_6 from commandbutton within w_21001_k
integer x = 2528
integer y = 164
integer width = 393
integer height = 84
integer taborder = 110
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Excel(&E)"
end type

event clicked;if dw_body.rowCount() <= 0 then 
	messagebox('확인','조회 된 자료가 없습니다. 조회를 먼저 해주세요')
	return
end if

trigger Event ue_excel()

end event

type sle_2 from singlelineedit within w_21001_k
integer x = 1001
integer y = 164
integer width = 814
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 82899184
borderstyle borderstyle = stylelowered!
end type

type cb_5 from commandbutton within w_21001_k
integer x = 809
integer y = 164
integer width = 192
integer height = 84
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "검색"
end type

event clicked;String     ls_mat_nm, ls_cust_nm, ls_emp_nm, is_brand, is_mat_year, is_mat_season, is_mat_sojae, as_data
Boolean    lb_check
long ai_div
DataStore  lds_Source 

ai_div = 1

as_data =  Trim(sle_1.text)


IF isnull(as_data) or as_data = "" then
	as_data = '%'
end if


is_brand = RightA(trim(ddlb_1.text),1)
is_mat_year =  trim(em_1.text)
is_mat_season =  RightA(trim(ddlb_3.text),1)


IF ai_div = 1 THEN 	
	IF isnull(as_data) or as_data = "" then
			RETURN 0			
	ELSEIF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
			RETURN 0		
	end if					
END IF

gst_cd.ai_div          = ai_div
gst_cd.window_title    = "원자재코드 검색" 
gst_cd.datawindow_nm   = "d_com020" 
gst_cd.default_where   = " where brand like '" + is_brand + "' and mat_year like '" + is_mat_year + "%' and mat_season like '" + is_mat_season + "%'"

IF as_data <> "" THEN
	gst_cd.Item_where = "mat_cd LIKE '" + as_data + "%'"
ELSE
	gst_cd.Item_where = ""
END IF


lds_Source = Create DataStore

OpenWithParm(W_COM200, lds_Source)

IF Isvalid(Message.PowerObjectParm) THEN
	lds_Source = Message.PowerObjectParm
	sle_1.text = lds_Source.GetItemString(1,"mat_cd")
	sle_2.text = lds_Source.GetItemString(1,"mat_nm")
	lb_check = TRUE 
ELSE
	lb_check = FALSE 
END IF
Destroy  lds_Source


IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

type cb_4 from commandbutton within w_21001_k
integer x = 2994
integer y = 192
integer width = 366
integer height = 88
integer taborder = 100
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "출력(&P)"
end type

event clicked;String p_brand, p_mat_year, p_mat_season, p_sojae, p_mat_cd
Dec net


dw_print.SetTransObject(sqlca)

dw_print.setredraw(false)


if dw_body.rowCount() <= 0 then 
	messagebox('확인','출력 할 자료가 없습니다. 조회를 먼저 해주세요')
	return
end if

p_brand = RightA(ddlb_1.text,1)
p_mat_year = trim(em_1.text)
p_mat_season = RightA(ddlb_3.text,1)
p_sojae = RightA(ddlb_4.text,1)
p_mat_cd = trim(sle_1.text)

if p_mat_cd = '' or isnull(p_mat_cd) then
	p_mat_cd = '%'
else 
	p_mat_cd = p_mat_cd + '%'
end if


dw_print.Object.t_brand.text = LeftA(ddlb_1.text,20)

dw_print.Object.t_year.text = trim(em_1.text)

dw_print.Object.t_season.text = LeftA(ddlb_3.text,20)

dw_print.Object.t_sojae.text = LeftA(ddlb_4.text,20)


dw_print.retrieve(p_brand, p_mat_year, p_mat_season, p_sojae, p_mat_cd)

dw_print.setredraw(True)


dw_print.Object.DataWindow.Print.Orientation = 1

dw_print.SetFocus()


net = messagebox('출력','출력하시겠습니까?',question!, YesNo!, 2)


If net = 1 then
	dw_print.print()
else
	return
end if



end event

type cb_3 from commandbutton within w_21001_k
integer x = 2994
integer y = 104
integer width = 366
integer height = 88
integer taborder = 90
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "미리보기(&V)"
end type

event clicked;String p_brand, p_mat_year, p_mat_season, p_sojae, p_mat_cd


st_1.visible = False
st_2.visible = False
st_3.visible = False
st_4.visible = False
st_5.visible = False

ddlb_1.visible = False
ddlb_3.visible = False
ddlb_4.visible = False
cb_5.visible = False
cb_6.visible = False
em_1.visible = False
sle_1.visible = False
sle_2.visible = False

st_6.visible = True
st_7.visible = True
st_8.visible = True
cb_7.visible = True
cb_8.visible = True
cb_9.visible = True
em_zoom.visible = True
em_printzoom.visible = True




dw_print.SetTransObject(sqlca)

dw_print.setredraw(false)


if dw_body.rowCount() <= 0 then 
	messagebox('확인','출력 할 자료가 없습니다. 조회를 먼저 해주세요')
	return
end if

p_brand = RightA(ddlb_1.text,1)
p_mat_year = trim(em_1.text)
p_mat_season = RightA(ddlb_3.text,1)
p_sojae = RightA(ddlb_4.text,1)
p_mat_cd = trim(sle_1.text)

if p_mat_cd = '' or isnull(p_mat_cd) then
	p_mat_cd = '%'
else 
	p_mat_cd = p_mat_cd + '%'
end if

dw_print.Object.t_brand.text = LeftA(ddlb_1.text,20)

dw_print.Object.t_year.text = trim(em_1.text)

dw_print.Object.t_season.text = LeftA(ddlb_3.text,20)

dw_print.Object.t_sojae.text = LeftA(ddlb_4.text,20)


dw_print.retrieve(p_brand, p_mat_year, p_mat_season, p_sojae, p_mat_cd)

dw_print.setredraw(True)

dw_print.visible = True

dw_print.Object.DataWindow.Print.Orientation = 1

dw_print.Modify("DataWindow.Print.Preview = Yes")

dw_print.SetFocus()


end event

type em_1 from editmask within w_21001_k
integer x = 1312
integer y = 72
integer width = 261
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type cb_2 from commandbutton within w_21001_k
integer x = 3360
integer y = 16
integer width = 256
integer height = 264
integer taborder = 120
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event clicked;Trigger Event close()
end event

type cb_1 from commandbutton within w_21001_k
integer x = 2994
integer y = 16
integer width = 366
integer height = 88
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;String is_brand, is_mat_year, is_mat_season, is_sojae, ls_msg, is_mat_cd


dw_body.setredraw(false)
dw_print.reset()

dw_print.visible = false

st_1.visible = True
st_2.visible = True
st_3.visible = True
st_4.visible = True
st_5.visible = True

ddlb_1.visible = True
ddlb_3.visible = True
ddlb_4.visible = True
cb_5.visible = True
cb_6.visible = True
em_1.visible = True
sle_1.visible = True
sle_2.visible = True

st_6.visible = false
st_7.visible = false
st_8.visible = false
cb_7.visible = false
cb_8.visible = false
cb_9.visible = false
em_zoom.visible = false
em_printzoom.visible = false




is_brand = RightA(ddlb_1.text,1)
is_mat_year = trim(em_1.text)
is_mat_season = RightA(ddlb_3.text,1)
is_sojae = RightA(ddlb_4.text,1)
is_mat_cd = trim(sle_1.text)

if is_mat_cd = '' or isnull(is_mat_cd) then
	is_mat_cd = '%'
	sle_2.text = '전 체'
else 
	is_mat_cd = is_mat_cd + '%'
end if



if LenA(trim(is_brand)) < 1 then
	messagebox('확인', '브랜드를 선택해주세요')
	return
end if


if LenA(trim(is_mat_year)) < 4 then
	messagebox('확인', '년도를 제대로 입력해주세요')
	return
end if

if LenA(trim(is_mat_season)) < 1 then
	messagebox('확인', '시즌을 선택해주세요')
	return
end if

if LenA(trim(is_sojae)) < 1 then
	messagebox('확인', '소재를 선택해주세요')
	return
end if


dw_body.retrieve(is_brand, is_mat_year, is_mat_season, is_sojae, is_mat_cd)

dw_body.setredraw(true)

dw_body.SetFocus()
end event

type ddlb_4 from dropdownlistbox within w_21001_k
integer x = 2528
integer y = 72
integer width = 393
integer height = 1496
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "none"
boolean sorted = false
boolean vscrollbar = true
string item[] = {"전체                                            %","JEANS                                          J","KNIT                                             K","LEATHER                                     L","원사                                              N","기타                                              O","WOVEN                                        W"}
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_21001_k
integer x = 2350
integer y = 84
integer width = 165
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "소재:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_3 from dropdownlistbox within w_21001_k
integer x = 1838
integer y = 72
integer width = 407
integer height = 1276
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "none"
boolean sorted = false
boolean vscrollbar = true
string item[] = {"봄                                                  S","여름                                             M","가을                                             A","겨울                                             W","사계절                                            X"}
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_21001_k
integer x = 1655
integer y = 84
integer width = 174
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "시즌:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_21001_k
integer x = 1125
integer y = 84
integer width = 174
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "년도:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_21001_k
integer x = 78
integer y = 84
integer width = 224
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "브랜드:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_1 from dropdownlistbox within w_21001_k
integer x = 329
integer y = 72
integer width = 480
integer height = 1392
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "none"
boolean sorted = false
boolean vscrollbar = true
string item[] = {"전체                                         %","ON & ON                                   N","OLIVE DES OLIVE                   O","Lapalette                                   B"}
borderstyle borderstyle = stylelowered!
end type

type sle_1 from singlelineedit within w_21001_k
event ue_keydown pbm_keydown
integer x = 329
integer y = 164
integer width = 480
integer height = 84
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;CHOOSE CASE key
	CASE KeyEnter!
		Trigger Event clicked(cb_5)
	CASE KeyF1! 
		Trigger Event clicked(cb_5)
END CHOOSE

end event

type st_5 from statictext within w_21001_k
integer x = 41
integer y = 180
integer width = 261
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "자재코드:"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_21001_k
integer x = 14
integer y = 20
integer width = 2962
integer height = 252
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type dw_body from datawindow within w_21001_k
integer y = 296
integer width = 3621
integer height = 1516
integer taborder = 80
string dataobject = "d_21001_t01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;datawindowchild ldw_child

this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('001')
end event

event clicked;setrow(row)
end event

type dw_print from datawindow within w_21001_k
boolean visible = false
integer y = 296
integer width = 3621
integer height = 1524
string title = "none"
string dataobject = "d_21001_t02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;datawindowchild ldw_child

this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('001')

end event

event clicked;this.setfocus()
end event

