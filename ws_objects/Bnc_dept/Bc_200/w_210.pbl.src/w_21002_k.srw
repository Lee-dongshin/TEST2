$PBExportHeader$w_21002_k.srw
$PBExportComments$자재코드등록 테스트
forward
global type w_21002_k from window
end type
type cb_11 from commandbutton within w_21002_k
end type
type cb_10 from commandbutton within w_21002_k
end type
type cb_9 from commandbutton within w_21002_k
end type
type cb_8 from commandbutton within w_21002_k
end type
type st_8 from statictext within w_21002_k
end type
type em_printzoom from editmask within w_21002_k
end type
type st_7 from statictext within w_21002_k
end type
type em_zoom from editmask within w_21002_k
end type
type st_6 from statictext within w_21002_k
end type
type cb_7 from commandbutton within w_21002_k
end type
type cb_6 from commandbutton within w_21002_k
end type
type cb_5 from commandbutton within w_21002_k
end type
type em_1 from editmask within w_21002_k
end type
type st_1 from statictext within w_21002_k
end type
type cb_2 from commandbutton within w_21002_k
end type
type cb_4 from commandbutton within w_21002_k
end type
type cb_3 from commandbutton within w_21002_k
end type
type cb_1 from commandbutton within w_21002_k
end type
type gb_1 from groupbox within w_21002_k
end type
type dw_body from datawindow within w_21002_k
end type
type dw_print from datawindow within w_21002_k
end type
end forward

global type w_21002_k from window
string tag = "테스트일자 조회"
integer width = 3712
integer height = 1980
boolean titlebar = true
string title = "테스트일자 조회"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
event ue_excel ( )
cb_11 cb_11
cb_10 cb_10
cb_9 cb_9
cb_8 cb_8
st_8 st_8
em_printzoom em_printzoom
st_7 st_7
em_zoom em_zoom
st_6 st_6
cb_7 cb_7
cb_6 cb_6
cb_5 cb_5
em_1 em_1
st_1 st_1
cb_2 cb_2
cb_4 cb_4
cb_3 cb_3
cb_1 cb_1
gb_1 gb_1
dw_body dw_body
dw_print dw_print
end type
global w_21002_k w_21002_k

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

on w_21002_k.create
this.cb_11=create cb_11
this.cb_10=create cb_10
this.cb_9=create cb_9
this.cb_8=create cb_8
this.st_8=create st_8
this.em_printzoom=create em_printzoom
this.st_7=create st_7
this.em_zoom=create em_zoom
this.st_6=create st_6
this.cb_7=create cb_7
this.cb_6=create cb_6
this.cb_5=create cb_5
this.em_1=create em_1
this.st_1=create st_1
this.cb_2=create cb_2
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_1=create cb_1
this.gb_1=create gb_1
this.dw_body=create dw_body
this.dw_print=create dw_print
this.Control[]={this.cb_11,&
this.cb_10,&
this.cb_9,&
this.cb_8,&
this.st_8,&
this.em_printzoom,&
this.st_7,&
this.em_zoom,&
this.st_6,&
this.cb_7,&
this.cb_6,&
this.cb_5,&
this.em_1,&
this.st_1,&
this.cb_2,&
this.cb_4,&
this.cb_3,&
this.cb_1,&
this.gb_1,&
this.dw_body,&
this.dw_print}
end on

on w_21002_k.destroy
destroy(this.cb_11)
destroy(this.cb_10)
destroy(this.cb_9)
destroy(this.cb_8)
destroy(this.st_8)
destroy(this.em_printzoom)
destroy(this.st_7)
destroy(this.em_zoom)
destroy(this.st_6)
destroy(this.cb_7)
destroy(this.cb_6)
destroy(this.cb_5)
destroy(this.em_1)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.dw_body)
destroy(this.dw_print)
end on

event close;Close (this)
end event

event open;dw_body.SetTransObject(sqlca)


dw_print.visible = false

st_6.visible = false
st_7.visible = false
st_8.visible = false
cb_8.visible = false
cb_9.visible = false
cb_10.visible = false
em_zoom.visible = false
em_printzoom.visible = false



cb_3.enabled = false
cb_4.enabled = false


end event

event resize;


newwidth = this.WorkSpaceWidth() 
newheight = this.WorkSpaceHeight()

dw_body.resize(newwidth, newheight - 396)
dw_print.resize(newwidth, newheight - 396)
end event

type cb_11 from commandbutton within w_21002_k
integer x = 2473
integer y = 164
integer width = 402
integer height = 84
integer taborder = 150
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

type cb_10 from commandbutton within w_21002_k
integer x = 1952
integer y = 164
integer width = 466
integer height = 88
integer taborder = 130
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

type cb_9 from commandbutton within w_21002_k
integer x = 1600
integer y = 168
integer width = 133
integer height = 84
integer taborder = 120
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

type cb_8 from commandbutton within w_21002_k
integer x = 1467
integer y = 168
integer width = 133
integer height = 84
integer taborder = 110
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

type st_8 from statictext within w_21002_k
integer x = 1202
integer y = 188
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

type em_printzoom from editmask within w_21002_k
event enchange pbm_enchange
integer x = 946
integer y = 172
integer width = 215
integer height = 84
integer taborder = 100
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

type st_7 from statictext within w_21002_k
integer x = 681
integer y = 188
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

type em_zoom from editmask within w_21002_k
event enchange pbm_enchange
integer x = 439
integer y = 172
integer width = 215
integer height = 84
integer taborder = 90
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

event enchange;dw_print.object.datawindow.print.preview.zoom = This.text
dw_print.setfocus()
end event

type st_6 from statictext within w_21002_k
integer x = 174
integer y = 188
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

type cb_7 from commandbutton within w_21002_k
integer x = 2935
integer y = 104
integer width = 338
integer height = 88
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;long i, ll_row_count
dwitemstatus idw_status
string ls_style, ls_test_date, ls_reg_id, ls_mod_id
datetime sys_date, ls_reg_dt, ls_mod_dt
int cnt, net

ll_row_count = dw_body.RowCount()

select getdate()
into :sys_date
from dual;

if dw_body.rowCount() <= 0 then 
	messagebox('확인','저장 할 자료가 없습니다. 조회를 먼저 해주세요')
	return
end if

IF dw_body.AcceptText() <> 1 THEN RETURN -1


net = messagebox('출력','출력하시겠습니까?',question!, YesNo!, 2)
	if net= 1 then
	
		FOR i=1 TO ll_row_count
			idw_status = dw_body.GetItemStatus(i, 0, Primary!)
			
			IF idw_status = NewModified! THEN
				ls_style = dw_body.getitemstring(i,"style")
				ls_test_date = dw_body.getitemstring(i,"test_date")
				ls_reg_id = gs_user_id
				ls_reg_dt = sys_date
				ls_mod_id = gs_user_id
				ls_mod_dt = sys_date
				
				if LenA(trim(ls_style)) <> 8 then 
					messagebox('확인','스타일번호를 8자리로 입력해주세요.')
					return
				end if
				
				if LenA(trim(ls_test_date)) <> 8 then 
					messagebox('확인','테스트일자를 제대로 입력해주세요.')
					return
				end if
				
				select count(style)
				  into :cnt
				from test_0226_m
				where style = :ls_style;
				
				if cnt > 0 then 
					messagebox('','이미 등록된 스타일번호입니다.')
					rollback;
					return
				end if
					
				insert into test_0226_m (style, test_date, reg_id, reg_dt, mod_id, mod_dt)
				values(:ls_style, :ls_test_date, :ls_reg_id, :ls_reg_dt, :ls_mod_id, :ls_mod_dt)
				using sqlca;
				
				//MessageBox('', 'Error.'+Sqlca.SqlErrText)
			ELSEIF idw_status = DataModified! THEN
				
				ls_style = dw_body.getitemstring(i,"style")
				ls_test_date = dw_body.getitemstring(i,"test_date")
				
				if LenA(trim(ls_test_date)) <> 8 then
					messagebox('확인','테스트일자를 제대로 입력해주세요.')
					rollback;
					
				else
					update test_0226_m set
						test_date = :ls_test_date,
						mod_id = :gs_user_id,
						mod_dt = :sys_date
					where style = :ls_style
					using sqlca;
					
				end if
			end if
		next
	
		IF SQLCA.SQLCODE < 0 THEN 
			ROLLBACK;
			MessageBox('', 'Error.'+Sqlca.SqlErrText)
			RETURN 
		ELSE
			COMMIT;
		end if
		
	else
		return
	end if
	
trigger event clicked(cb_1)

end event

type cb_6 from commandbutton within w_21002_k
integer x = 3273
integer y = 16
integer width = 338
integer height = 88
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가(&I)"
end type

event clicked;dw_body.insertrow(0)
dw_body.SetFocus()
dw_body.scrolltorow(dw_body.rowcount())
dw_body.setcolumn('style')

end event

type cb_5 from commandbutton within w_21002_k
integer x = 3273
integer y = 104
integer width = 338
integer height = 88
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제(&D)"
end type

event clicked;int t_row, net
string t_flag, t_style


t_row = dw_body.getrow()

t_flag = dw_body.getitemstring(t_row, "flag")
t_style = dw_body.getitemstring(t_row, "style")


if dw_body.rowCount() <= 0 then 
	messagebox('확인','삭제 할 자료가 없습니다. 조회를 먼저 해주세요')
	return
end if


if t_flag = '1' then
	net = messagebox('확인','삭제하시겠습니까?',question!, YesNo!, 2)
	if net= 1 then
		delete from test_0226_m
		where style = :t_style;
		
		commit using sqlca;
		trigger event clicked(cb_1)
	else
		return
	end if 
else
	dw_body.deleterow(t_row)
end if
end event

type em_1 from editmask within w_21002_k
integer x = 439
integer y = 172
integer width = 453
integer height = 84
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "########"
end type

type st_1 from statictext within w_21002_k
integer x = 96
integer y = 188
integer width = 329
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "스타일번호"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_21002_k
integer x = 2935
integer y = 280
integer width = 677
integer height = 88
integer taborder = 160
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

type cb_4 from commandbutton within w_21002_k
integer x = 3273
integer y = 192
integer width = 338
integer height = 88
integer taborder = 140
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "출력(&P)"
end type

event clicked;String p_style
Dec net


dw_print.SetTransObject(sqlca)

dw_print.setredraw(false)


if dw_body.rowCount() <= 0 then 
	messagebox('확인','출력 할 자료가 없습니다. 조회를 먼저 해주세요')
	return
end if

p_style = trim(em_1.text)

if p_style = '' or isnull(p_style) then
	p_style = '%'
else
	p_style = p_style + '%'
end if


dw_print.retrieve(p_style)

dw_print.setredraw(True)
dw_print.Object.DataWindow.Print.Orientation = 0
dw_print.SetFocus()


net = messagebox('출력','출력하시겠습니까?',question!, YesNo!, 2)

If net = 1 then
	dw_print.print()
else
	return
end if
end event

type cb_3 from commandbutton within w_21002_k
integer x = 2935
integer y = 192
integer width = 338
integer height = 88
integer taborder = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "미리보기(&V)"
end type

event clicked;String p_style



cb_5.enabled = False
cb_6.enabled = False
cb_7.enabled = False


st_1.visible = False
em_1.visible = False
cb_11.visible = False

st_6.visible = True
st_7.visible = True
st_8.visible = True
cb_8.visible = True
cb_9.visible = True
cb_10.visible = True
em_zoom.visible = True
em_printzoom.visible = True


dw_print.SetTransObject(sqlca)

dw_print.setredraw(false)


if dw_body.rowCount() <= 0 then 
	messagebox('확인','출력 할 자료가 없습니다. 조회를 먼저 해주세요')
	return
end if


p_style = trim(em_1.text)


if p_style = '' or isnull(p_style) then
	p_style = '%'
else
	p_style = p_style + '%'
end if



dw_print.retrieve(p_style)

dw_print.setredraw(True)

dw_print.visible = True

dw_print.Object.DataWindow.Print.Orientation = 0

dw_print.Modify("DataWindow.Print.Preview = Yes")

dw_print.SetFocus()


end event

type cb_1 from commandbutton within w_21002_k
integer x = 2935
integer y = 16
integer width = 338
integer height = 88
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;String is_style 


st_1.visible = True
em_1.visible = True
cb_11.visible = True

cb_3.enabled = True
cb_4.enabled = True
cb_5.enabled = True
cb_6.enabled = True
cb_7.enabled = True

st_6.visible = False
st_7.visible = False
st_8.visible = False
cb_8.visible = False
cb_9.visible = False
cb_10.visible = False
em_zoom.visible = False
em_printzoom.visible = False


dw_body.setredraw(false)

dw_print.reset()
dw_print.visible = false



is_style = trim(em_1.text)


if is_style = '' or isnull(is_style) then
	is_style = '%'
else 
	is_style = is_style + '%'
end if


dw_body.retrieve(is_style)

dw_body.setredraw(true)

dw_body.SetFocus()
end event

type gb_1 from groupbox within w_21002_k
integer x = 37
integer y = 28
integer width = 2875
integer height = 328
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

type dw_body from datawindow within w_21002_k
integer x = 18
integer y = 396
integer width = 3598
integer height = 1420
integer taborder = 30
string title = "none"
string dataobject = "d_21002_t01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;setrow(row)
end event

type dw_print from datawindow within w_21002_k
boolean visible = false
integer x = 18
integer y = 396
integer width = 3598
integer height = 1420
integer taborder = 70
string title = "none"
string dataobject = "d_21002_t02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;setrow(row)
end event

