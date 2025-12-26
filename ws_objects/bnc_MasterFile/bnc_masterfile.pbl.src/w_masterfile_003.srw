$PBExportHeader$w_masterfile_003.srw
forward
global type w_masterfile_003 from window
end type
type cb_print from commandbutton within w_masterfile_003
end type
type rb_3 from radiobutton within w_masterfile_003
end type
type rb_2 from radiobutton within w_masterfile_003
end type
type rb_1 from radiobutton within w_masterfile_003
end type
type dw_print5 from datawindow within w_masterfile_003
end type
type cb_excel from commandbutton within w_masterfile_003
end type
type cb_3 from commandbutton within w_masterfile_003
end type
type dw_print4 from datawindow within w_masterfile_003
end type
type cbx_1 from checkbox within w_masterfile_003
end type
type dw_print3 from datawindow within w_masterfile_003
end type
type dw_print2 from datawindow within w_masterfile_003
end type
type dw_print1 from datawindow within w_masterfile_003
end type
type cb_update from commandbutton within w_masterfile_003
end type
type st_tag from statictext within w_masterfile_003
end type
type st_care from statictext within w_masterfile_003
end type
type cb_2 from commandbutton within w_masterfile_003
end type
type cb_1 from commandbutton within w_masterfile_003
end type
type tab_1 from tab within w_masterfile_003
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tab_1 from tab within w_masterfile_003
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
type dw_head from datawindow within w_masterfile_003
end type
type dw_3 from datawindow within w_masterfile_003
end type
type dw_care from datawindow within w_masterfile_003
end type
type dw_tag from datawindow within w_masterfile_003
end type
type dw_4 from datawindow within w_masterfile_003
end type
type dw_1 from datawindow within w_masterfile_003
end type
type dw_2 from datawindow within w_masterfile_003
end type
end forward

global type w_masterfile_003 from window
integer width = 4521
integer height = 2276
boolean titlebar = true
string title = "파일생성"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 67108864
cb_print cb_print
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
dw_print5 dw_print5
cb_excel cb_excel
cb_3 cb_3
dw_print4 dw_print4
cbx_1 cbx_1
dw_print3 dw_print3
dw_print2 dw_print2
dw_print1 dw_print1
cb_update cb_update
st_tag st_tag
st_care st_care
cb_2 cb_2
cb_1 cb_1
tab_1 tab_1
dw_head dw_head
dw_3 dw_3
dw_care dw_care
dw_tag dw_tag
dw_4 dw_4
dw_1 dw_1
dw_2 dw_2
end type
global w_masterfile_003 w_masterfile_003

type variables
long il_rows
string is_brand, is_year, is_season, is_style
boolean  ib_changed
dwItemStatus idw_status
end variables

on w_masterfile_003.create
this.cb_print=create cb_print
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_print5=create dw_print5
this.cb_excel=create cb_excel
this.cb_3=create cb_3
this.dw_print4=create dw_print4
this.cbx_1=create cbx_1
this.dw_print3=create dw_print3
this.dw_print2=create dw_print2
this.dw_print1=create dw_print1
this.cb_update=create cb_update
this.st_tag=create st_tag
this.st_care=create st_care
this.cb_2=create cb_2
this.cb_1=create cb_1
this.tab_1=create tab_1
this.dw_head=create dw_head
this.dw_3=create dw_3
this.dw_care=create dw_care
this.dw_tag=create dw_tag
this.dw_4=create dw_4
this.dw_1=create dw_1
this.dw_2=create dw_2
this.Control[]={this.cb_print,&
this.rb_3,&
this.rb_2,&
this.rb_1,&
this.dw_print5,&
this.cb_excel,&
this.cb_3,&
this.dw_print4,&
this.cbx_1,&
this.dw_print3,&
this.dw_print2,&
this.dw_print1,&
this.cb_update,&
this.st_tag,&
this.st_care,&
this.cb_2,&
this.cb_1,&
this.tab_1,&
this.dw_head,&
this.dw_3,&
this.dw_care,&
this.dw_tag,&
this.dw_4,&
this.dw_1,&
this.dw_2}
end on

on w_masterfile_003.destroy
destroy(this.cb_print)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_print5)
destroy(this.cb_excel)
destroy(this.cb_3)
destroy(this.dw_print4)
destroy(this.cbx_1)
destroy(this.dw_print3)
destroy(this.dw_print2)
destroy(this.dw_print1)
destroy(this.cb_update)
destroy(this.st_tag)
destroy(this.st_care)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.tab_1)
destroy(this.dw_head)
destroy(this.dw_3)
destroy(this.dw_care)
destroy(this.dw_tag)
destroy(this.dw_4)
destroy(this.dw_1)
destroy(this.dw_2)
end on

event open;string ls_year, ls_yymmdd

/* DataWindow의 Transction 정의 */
dw_care.SetTransObject(SQLCA)
dw_tag.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)

dw_print1.SetTransObject(SQLCA)
dw_print2.SetTransObject(SQLCA)
dw_print3.SetTransObject(SQLCA)
dw_print4.SetTransObject(SQLCA)
dw_print5.SetTransObject(SQLCA)

dw_head.insertrow(1)

select convert(char(4),getdate(),112) 
	into :ls_year
from dual;

dw_head.setitem(1,"year",ls_year)


	cb_update.visible = true
	dw_1.enabled = true
	dw_2.enabled = true
	dw_4.enabled = true
	cb_3.visible = true
	


select convert(char(8),getdate(),112) 
	into :ls_yymmdd 
from dual;

dw_head.setitem(1,"yymmdd",ls_yymmdd)

end event

event resize;dw_head.width = this.width - 91
dw_care.width = this.width - 91
dw_tag.width  = this.width - 91
dw_3.width  = this.width - 91
dw_4.width  = this.width - 91

dw_care.height = this.height - 392
dw_tag.height  = this.height - 392
dw_1.height  = this.height - 392
dw_2.height  = this.height - 392
dw_3.height  = this.height - 392
dw_4.height  = this.height - 392
end event

event close;if ib_changed = true then
	if messagebox("확인","저장하시겠습니까..?",Exclamation!,YesNo!,1) <> 1 then return -1
	cb_update.event clicked()
end if



end event

type cb_print from commandbutton within w_masterfile_003
integer x = 3758
integer y = 36
integer width = 256
integer height = 84
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "프린트"
end type

event clicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (김 태범)                                      */	
///* 작성일      : 2001.01.01                                                  */	
///* 수정일      : 2001.01.01                                                  */
///*===========================================================================*/
//string ls_doc_nm, ls_nm
//
//integer li_ret
//boolean lb_exist
//Pointer Old_pointer
//
//IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
//	RETURN
//END IF	
//lb_exist = FileExists(ls_doc_nm)
//IF lb_exist THEN 
//   SetPointer(Old_pointer)
//	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
//	if li_ret = 2 then return
//end if
//
//Old_pointer = SetPointer(HourGlass!)
//
//if dw_1.visible then
//	li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
//
//elseif dw_3.visible then
//	li_ret = dw_3.SaveAs(ls_doc_nm, Excel!, TRUE)
//
//elseif dw_4.visible then
//	li_ret = dw_4.SaveAs(ls_doc_nm, Excel!, TRUE)
//	
//elseif dw_care.visible then
//	li_ret = dw_care.SaveAs(ls_doc_nm, Excel!, TRUE)
//
//elseif dw_tag.visible then
//	li_ret = dw_tag.SaveAs(ls_doc_nm, Excel!, TRUE)
//
//end if
//	
//
//	
//
//if li_ret <> 1 then
//	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
//   return
//end if
//SetPointer(Old_pointer)
//Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)
//
//
//
//
//
//
/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
STRING LS_YYMMDD
ls_yymmdd = dw_head.getitemstring(1,"yymmdd")
il_rows = dw_print5.retrieve(is_brand, ls_yymmdd, gs_user_id)

if messagebox("확인","인쇄하시겠습니다...?",Exclamation!,YesNoCancel!,1 ) <> 1 then return			
			
			
IF dw_print5.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print5.Print()
END IF




end event

type rb_3 from radiobutton within w_masterfile_003
boolean visible = false
integer x = 2354
integer y = 172
integer width = 229
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "영문"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then
	messagebox("","english")
	cb_2.trigger event ue_dataobj_set('english')
end if
end event

type rb_2 from radiobutton within w_masterfile_003
boolean visible = false
integer x = 2080
integer y = 172
integer width = 233
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "중문"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then
	messagebox("","china")
	cb_2.trigger event ue_dataobj_set('china')
end if
end event

type rb_1 from radiobutton within w_masterfile_003
integer x = 1810
integer y = 172
integer width = 219
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "한글"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then
	messagebox("","korea")
	cb_2.trigger event ue_dataobj_set('korea')
end if
end event

type dw_print5 from datawindow within w_masterfile_003
boolean visible = false
integer x = 210
integer y = 664
integer width = 3145
integer height = 1172
integer taborder = 110
boolean titlebar = true
string title = "none"
string dataobject = "d_masterfile_r34"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_excel from commandbutton within w_masterfile_003
integer x = 4018
integer y = 36
integer width = 238
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "엑셀"
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer


if dw_1.visible = true then
	
	messagebox("미발행 케어라벨 자료!" , "미발행 케어라벨 자료를 엑셀로 전환 합니다!")
	
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
	
	
	li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
		
	
	if li_ret <> 1 then
		MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
		return
	end if
	SetPointer(Old_pointer)
	Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end if

if dw_2.visible = true then
	
messagebox("미발행 택 자료!" , "미발행 택 자료를 엑셀로 전환 합니다!")	
	
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
	
	
	li_ret = dw_2.SaveAs(ls_doc_nm, Excel!, TRUE)
		
	
	if li_ret <> 1 then
		MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
		return
	end if
	SetPointer(Old_pointer)
	Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)
end if	
	
messagebox("거래명세서 자료!" , "거래명세서 자료를  엑셀로 전환 합니다!")	
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
	
	
	li_ret = dw_4.SaveAs(ls_doc_nm, Excel!, TRUE)
		
	
	if li_ret <> 1 then
		MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
		return
	end if
	SetPointer(Old_pointer)
	Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_3 from commandbutton within w_masterfile_003
integer x = 3209
integer y = 36
integer width = 238
integer height = 84
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가"
end type

event clicked;if dw_4.visible then 
	dw_4.insertrow(1)
	dw_4.setfocus()
	dw_4.setrow(1)
	dw_4.setcolumn("yymmdd")
end if
end event

type dw_print4 from datawindow within w_masterfile_003
integer x = 1477
integer y = 496
integer width = 411
integer height = 432
integer taborder = 100
string title = "none"
string dataobject = "d_masterfile_d34"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_masterfile_003
boolean visible = false
integer x = 2651
integer y = 176
integer width = 443
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "중국생산포함"
borderstyle borderstyle = stylelowered!
end type

type dw_print3 from datawindow within w_masterfile_003
boolean visible = false
integer x = 1029
integer y = 496
integer width = 411
integer height = 432
integer taborder = 90
string title = "none"
string dataobject = "d_masterfile_r33"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print2 from datawindow within w_masterfile_003
boolean visible = false
integer x = 585
integer y = 496
integer width = 411
integer height = 432
integer taborder = 80
string title = "none"
string dataobject = "d_masterfile_r32"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print1 from datawindow within w_masterfile_003
boolean visible = false
integer x = 133
integer y = 496
integer width = 411
integer height = 432
integer taborder = 70
string title = "none"
string dataobject = "d_masterfile_r31"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_update from commandbutton within w_masterfile_003
integer x = 4306
integer y = 36
integer width = 238
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "저장(&S)"
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
string ls_yymmdd, ls_gubn, ls_style, ls_chno, ls_color, ls_size, label_agree, ls_gubn2


IF dw_1.AcceptText() <> 1 THEN RETURN -1
IF dw_2.AcceptText() <> 1 THEN RETURN -1
IF dw_4.AcceptText() <> 1 THEN RETURN -1
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


FOR i=1 TO dw_1.rowcount()
   idw_status = dw_1.GetItemStatus(i, 0, Primary!)
	IF idw_status = NewModified! THEN				/* New Record */
	ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		dw_1.Setitem(i, "mod_id", gs_user_id)
		dw_1.Setitem(i, "mod_dt", ld_datetime)
	END IF
NEXT


il_rows = dw_1.Update(TRUE, FALSE)
if il_rows = 1 then	
	dw_1.ResetUpdate()
	for i=1 to dw_1.rowcount()
		ls_gubn   = dw_1.getitemstring(i,"gubn")
		label_agree = dw_1.getitemstring(i,"label_agree")	
		if ls_gubn <> '' and label_agree = 'Y' then //추가발행
			ls_yymmdd = dw_1.getitemstring(i,"yymmdd")
			ls_style  = dw_1.getitemstring(i,"style")
			ls_chno   = dw_1.getitemstring(i,"chno")
			ls_color  = dw_1.getitemstring(i,"color")
			ls_size   = dw_1.getitemstring(i,"size")
			
			update tb_12029_c set 
				print_yn = 'Y',
				mod_id = :gs_user_id,
				mod_dt = getdate()				
			where yymmdd = :ls_yymmdd
			and   gubn  in ('3','8')
			and   style = :ls_style
			and   chno  = :ls_chno
			and   color = :ls_color
			and   size  = :ls_size;					
		end if			
		
	next
	commit  USING SQLCA;
else
	rollback  USING SQLCA;
end if


/////////////////
FOR i=1 TO dw_2.rowcount()
   idw_status = dw_2.GetItemStatus(i, 0, Primary!)
	IF idw_status = NewModified! THEN				/* New Record */

	ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		dw_2.Setitem(i, "mod_id", gs_user_id)
		dw_2.Setitem(i, "mod_dt", ld_datetime)
	END IF

NEXT


il_rows = dw_2.Update(TRUE, FALSE)
if il_rows = 1 then				
	dw_2.ResetUpdate()
	for i=1 to dw_2.rowcount()
		ls_gubn = dw_2.getitemstring(i,"gubn")
		label_agree = dw_2.getitemstring(i,"tag_agree")
		if (ls_gubn = '1' or ls_gubn = '7' ) and label_agree = 'Y' then
			ls_yymmdd = dw_2.getitemstring(i,"yymmdd")
			ls_style  = dw_2.getitemstring(i,"style")
			ls_chno   = dw_2.getitemstring(i,"chno")
			ls_color  = dw_2.getitemstring(i,"color")
			ls_size   = dw_2.getitemstring(i,"size")

			update tb_12029_c set 
				print_yn = 'Y',
				mod_id = :gs_user_id,
				mod_dt = getdate()
			where yymmdd = :ls_yymmdd
			and   gubn  in ('1','2','7')
			and   style = :ls_style
			and   chno  = :ls_chno
			and   color = :ls_color
			and   size  = :ls_size;		
		end if
	
	next	

	commit  USING SQLCA;
else
	rollback  USING SQLCA;
end if
////////////////////

FOR i=1 TO dw_4.rowcount()
   idw_status = dw_4.GetItemStatus(i, 0, Primary!)

		IF idw_status = NewModified! THEN				/* New Record */
			dw_4.Setitem(i, "reg_id", gs_user_id)
			dw_4.Setitem(i, "auto_gbn", '0')
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
	
		END IF		
NEXT

il_rows = dw_4.Update(TRUE, FALSE)
if il_rows = 1 then				
	dw_4.ResetUpdate()
	commit  USING SQLCA;	
else
	rollback  USING SQLCA;
end if


ls_yymmdd = dw_head.getitemstring(1,"yymmdd")
il_rows = dw_1.retrieve(is_brand, is_year)
il_rows = dw_2.retrieve(is_brand, is_year)
il_rows = dw_4.retrieve(is_brand, ls_yymmdd, gs_user_id)


cb_update.enabled = false
ib_changed = false
return il_rows


end event

type st_tag from statictext within w_masterfile_003
integer x = 3131
integer y = 200
integer width = 983
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_care from statictext within w_masterfile_003
integer x = 3131
integer y = 144
integer width = 983
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_masterfile_003
event ue_dataobj_set ( string as_gubn )
integer x = 2857
integer y = 36
integer width = 302
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&V)"
end type

event ue_dataobj_set(string as_gubn);is_brand = dw_head.getitemstring(1,"brand")
is_year  = dw_head.getitemstring(1,"year")
	
//if as_gubn = 'korea' then	//////////////////한국어	
//	if is_brand = "L" then
//		dw_1.dataobject = "d_masterfile_d11"
//		dw_1.SetTransObject(SQLCA)		
//	else
//		dw_1.dataobject = "d_masterfile_d01"
//		dw_1.SetTransObject(SQLCA)			
//	end if
//	
//	
//	if is_brand = "T" or is_brand = "L" then
//		dw_2.dataobject = "d_masterfile_d12"
//		dw_2.SetTransObject(SQLCA)			
//	else
//		dw_2.dataobject = "d_masterfile_d02"
//		dw_2.SetTransObject(SQLCA)		
//	end if	
//	
//	dw_3.dataobject = "d_masterfile_d03"
//	dw_3.SetTransObject(SQLCA)		
//	
//	dw_4.dataobject = "d_masterfile_d04"
//	dw_4.SetTransObject(SQLCA)		
//	
//	dw_care.dataobject = "d_care_d01_new"
//	dw_care.SetTransObject(SQLCA)		
//	
//	dw_print1.dataobject = "d_masterfile_r01"
//	dw_print1.SetTransObject(SQLCA)		
//	
//	dw_print2.dataobject = "d_masterfile_r02"
//	dw_print2.SetTransObject(SQLCA)		
//
//	dw_print3.dataobject = "d_masterfile_r03"
//	dw_print3.SetTransObject(SQLCA)			
//	
//	dw_print4.dataobject = "d_masterfile_r04"
//	dw_print4.SetTransObject(SQLCA)			
//	
//	dw_tag.dataobject = "d_tag_d01"
//	dw_tag.SetTransObject(SQLCA)
//	
//elseif as_gubn = 'china' then    //////////////////중국어	
//	if is_brand = "L" then
//		dw_1.dataobject = "d_masterfile_chn_d11"
//		dw_1.SetTransObject(SQLCA)		
//	else
//		dw_1.dataobject = "d_masterfile_chn_d01"
//		dw_1.SetTransObject(SQLCA)			
//	end if
//	
//	
//	if is_brand = "T" or is_brand = "L" then
//		dw_2.dataobject = "d_masterfile_chn_d12"
//		dw_2.SetTransObject(SQLCA)			
//	else
//		dw_2.dataobject = "d_masterfile_chn_d02"
//		dw_2.SetTransObject(SQLCA)		
//	end if	
//	
//	dw_3.dataobject = "d_masterfile_chn_d03"
//	dw_3.SetTransObject(SQLCA)		
//	
//	dw_4.dataobject = "d_masterfile_chn_d04"
//	dw_4.SetTransObject(SQLCA)		
//	
//	dw_care.dataobject = "d_care_chn_d01"
//	dw_care.SetTransObject(SQLCA)		
//	
//	dw_print1.dataobject = "d_masterfile_chn_r01"
//	dw_print1.SetTransObject(SQLCA)		
//	
//	dw_print2.dataobject = "d_masterfile_chn_r02"
//	dw_print2.SetTransObject(SQLCA)		
//
//	dw_print3.dataobject = "d_masterfile_chn_r03"
//	dw_print3.SetTransObject(SQLCA)			
//	
//	dw_print4.dataobject = "d_masterfile_chn_r04"
//	dw_print4.SetTransObject(SQLCA)			
//	
//	dw_tag.dataobject = "d_tag_chn_d01"
//	dw_tag.SetTransObject(SQLCA)	
//	
//elseif as_gubn = 'english' then    //////////////////중국어	
//	if is_brand = "L" then
//		dw_1.dataobject = "d_masterfile_d11"
//		dw_1.SetTransObject(SQLCA)		
//	else
//		dw_1.dataobject = "d_masterfile_d01"
//		dw_1.SetTransObject(SQLCA)			
//	end if
//	
//	
//	if is_brand = "T" or is_brand = "L" then
//		dw_2.dataobject = "d_masterfile_d12"
//		dw_2.SetTransObject(SQLCA)			
//	else
//		dw_2.dataobject = "d_masterfile_d02"
//		dw_2.SetTransObject(SQLCA)		
//	end if	
//	
//	dw_3.dataobject = "d_masterfile_d03"
//	dw_3.SetTransObject(SQLCA)		
//	
//	dw_4.dataobject = "d_masterfile_d04"
//	dw_4.SetTransObject(SQLCA)		
//	
//	dw_care.dataobject = "d_care_eng_d01"
//	dw_care.SetTransObject(SQLCA)		
//	
//	dw_print1.dataobject = "d_masterfile_eng_r01"
//	dw_print1.SetTransObject(SQLCA)		
//	
//	dw_print2.dataobject = "d_masterfile_eng_r02"
//	dw_print2.SetTransObject(SQLCA)		
//
//	dw_print3.dataobject = "d_masterfile_eng_r03"
//	dw_print3.SetTransObject(SQLCA)			
//	
//	dw_print4.dataobject = "d_masterfile_eng_r04"
//	dw_print4.SetTransObject(SQLCA)			
//	
//	dw_tag.dataobject = "d_tag_eng_d01"
//	dw_tag.SetTransObject(SQLCA)	
//end if

	
end event

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.18                                                  */	
/* 수정일      : 2002.06.18                                                  */
/*===========================================================================*/

long i
datetime ldt_datetime
string ls_yymmdd
if not gf_sysdate(ldt_datetime) then
	return 1
end if


/* dw_head 필수입력 column check */
IF dw_head.AcceptText() <> 1 THEN RETURN 1

//if ib_changed = true then
//	if messagebox("확인","저장하시겠습니까..?",Exclamation!,YesNo!,1) = 1 then 
//		cb_update.event clicked()
//	end if		
//end if

ls_yymmdd = dw_head.getitemstring(1,"yymmdd")
is_brand  = dw_head.getitemstring(1,"brand")
is_year   = dw_head.getitemstring(1,"year")
is_season = dw_head.getitemstring(1,"season")
is_style  = dw_head.getitemstring(1,"style")

choose case tab_1.SelectedTab
	case 1	
		if cbx_1.checked then 
			il_rows = dw_care.retrieve(is_brand, is_year, 'Y', is_season, is_style)
		else
			il_rows = dw_care.retrieve(is_brand, is_year, 'Y', is_season, is_style)
		end if

	case 2
		if cbx_1.checked then 
			il_rows = dw_tag.retrieve (is_brand, is_year, 'Y', is_season, is_style)	
		else
			il_rows = dw_tag.retrieve (is_brand, is_year, 'Y', is_season, is_style)
		end if	
	case 3
		il_rows = dw_1.retrieve(is_brand, is_year)
		il_rows = dw_2.retrieve(is_brand, is_year)
	case 4
		il_rows = dw_3.retrieve(is_brand, is_year)
	case 5
		il_rows = dw_4.retrieve(is_brand, ls_yymmdd, gs_user_id)
		
end choose
if il_rows = 0 then 
	messagebox("확인","해당하는 데이타가 없습니다..")
end if

return

/*
if cbx_1.checked then 
	il_rows = dw_care.retrieve(is_brand, is_year, 'Y')
	il_rows = dw_tag.retrieve (is_brand, is_year, 'Y')	
else
	il_rows = dw_care.retrieve(is_brand, is_year, 'N')
	il_rows = dw_tag.retrieve (is_brand, is_year, 'N')
end if

il_rows = dw_1.retrieve(is_brand, is_year)
il_rows = dw_2.retrieve(is_brand, is_year)
il_rows = dw_3.retrieve(is_brand, is_year)

il_rows = dw_4.retrieve(is_brand, ls_yymmdd, gs_user_id)
*/

end event

type cb_1 from commandbutton within w_masterfile_003
integer x = 3520
integer y = 36
integer width = 238
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "파일생성"
end type

event clicked;long ret
string ls_path_care, ls_path_tag
if rb_3.checked then //영문
	ls_path_care = "C:\zebra\qbcom\label_" + is_brand + 'E'
	ls_path_tag  = "C:\zebra\qbcom\tag_" + is_brand + 'E'
else
	ls_path_care = "C:\zebra\qbcom\label_" + is_brand
	ls_path_tag  = "C:\zebra\qbcom\tag_" + is_brand

end if

st_care.text = ls_path_care
st_tag.text  = ls_path_tag

ret =  messagebox("파일생성","파일을 생성하시겠습니까..?",Exclamation!,YesNo!,1)
if ret = 1 then
	if dw_care.rowcount() > 0 then	dw_care.SaveAs(ls_path_care ,Text!, FALSE)
	if dw_tag.rowcount() > 0 then   dw_tag.SaveAs(ls_path_tag ,Text!, FALSE)
end if
return ret

end event

type tab_1 from tab within w_masterfile_003
integer x = 23
integer y = 148
integer width = 1755
integer height = 120
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

event selectionchanged;datetime ld_datetime
string ls_brand, ls_yymmdd

if newindex = 1 then
	dw_care.visible = true
	dw_tag.visible  = false
	dw_1.visible    = false
	dw_2.visible    = false
	dw_3.visible    = false	
	dw_4.visible    = false	
	
elseif newindex = 2 then
	dw_care.visible = false
	dw_tag.visible  = true
	dw_1.visible    = false
	dw_2.visible    = false
	dw_3.visible    = false	
	dw_4.visible    = false	
	
elseif newindex = 3 then	
	dw_care.visible = false
	dw_tag.visible  = false
	dw_1.visible    = true
	dw_2.visible    = true
	dw_3.visible    = false	
	dw_4.visible    = false	
	
elseif newindex = 4 then	
	dw_care.visible = false
	dw_tag.visible  = false
	dw_1.visible    = false
	dw_2.visible    = false
	dw_3.visible    = true
	dw_4.visible    = false	

elseif newindex = 5 then	
	dw_care.visible = false
	dw_tag.visible  = false
	dw_1.visible    = false
	dw_2.visible    = false
	dw_3.visible    = false
	dw_4.visible    = true
	IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
	END IF

	IF dw_head.AcceptText() <> 1 THEN RETURN 1
	ls_yymmdd = dw_head.getitemstring(1,"yymmdd")
	ls_brand = dw_head.getitemstring(1,"brand")
	dw_4.retrieve(ls_brand, ls_yymmdd, gs_user_id )

end if
end event

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
integer width = 1719
integer height = 8
long backcolor = 67108864
string text = "케어라벨 파일"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 1719
integer height = 8
long backcolor = 67108864
string text = "택 파일"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 1719
integer height = 8
long backcolor = 67108864
string text = "미발행 현황"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 1719
integer height = 8
long backcolor = 67108864
string text = "전체발행현황"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 1719
integer height = 8
long backcolor = 67108864
string text = "거래명세서"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
end type

type dw_head from datawindow within w_masterfile_003
integer x = 23
integer y = 12
integer width = 4210
integer height = 132
integer taborder = 10
string title = "none"
string dataobject = "d_masterfile_h01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;choose case dwo.name
	case "brand"
		is_brand  = data
	case "year"
		is_year   = data
end choose


end event

type dw_3 from datawindow within w_masterfile_003
boolean visible = false
integer x = 23
integer y = 268
integer width = 3511
integer height = 1872
integer taborder = 60
string title = "none"
string dataobject = "d_masterfile_d33"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_care from datawindow within w_masterfile_003
integer x = 23
integer y = 268
integer width = 3511
integer height = 1872
integer taborder = 30
string title = "none"
string dataobject = "d_care_d01_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_tag from datawindow within w_masterfile_003
integer x = 23
integer y = 268
integer width = 3511
integer height = 1876
integer taborder = 40
string title = "none"
string dataobject = "d_tag_d01"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
//cb_print.enabled = false
//cb_preview.enabled = false
//cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
//
//CHOOSE CASE dwo.name
//	CASE "colunm1" 
//    IF data = 'A' THEN
//	      /*action*/
//    END IF
//	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
//END CHOOSE
//
end event

type dw_4 from datawindow within w_masterfile_003
event ue_keydown pbm_dwnkey
boolean visible = false
integer x = 23
integer y = 268
integer width = 3511
integer height = 1872
integer taborder = 100
string title = "none"
string dataobject = "d_masterfile_d34"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()



CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1

END CHOOSE

end event

event constructor;datawindowchild ldw_color, ldw_bigo
This.GetChild("color", ldw_color )
ldw_color.SetTransObject(SQLCA)
ldw_color.Retrieve()

This.GetChild("bigo", ldw_bigo )
ldw_bigo.SetTransObject(SQLCA)
ldw_bigo.Retrieve('218')

end event

event itemchanged;int i
string ls_style, ls_color
ib_changed = true
cb_update.enabled = true

choose case dwo.name
	case "style"
		if LenA(data) <> 8 then
			messagebox("주의","스타일 번호를 올바로 입력하세요.")
			this.setcolumn("style")		
			return 1
		else
			select style into :ls_style  
			from tb_12020_m (nolock)
			where style = :data;
			
			if ls_style = '' or isnull(ls_style) then
				messagebox("주의","스타일 번호가 존재하지 않습니다..")
				this.setcolumn("style")		
				return 1				
			end if
			
		end if
	case "yymmdd"
		select isdate(:data) into :i from dual;
		if i = 0 then 
			messagebox("주의","일자를 올바로 입력하세요.")
			this.setcolumn("yymmdd")
			return 1
		end if
end choose

		
		


end event

event clicked;//string ls_sort
//if row = 0 then 
//	dwo.name
//	ls_sort = dwo.name + ' A'
//	messagebox("ls_string",ls_sort)
//	
//	
//	dw_4.SetRedraw(false)
//	
//	dw_4.SetSort(ls_sort)
//	
//	dw_4.Sort()
//	
//	dw_4.SetRedraw(true)
//end if
end event

type dw_1 from datawindow within w_masterfile_003
boolean visible = false
integer x = 14
integer y = 268
integer width = 2578
integer height = 1844
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "미발행 케어라벨"
string dataobject = "d_masterfile_d31"
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
//cb_print.enabled = false
//cb_preview.enabled = false
//cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
//
//CHOOSE CASE dwo.name
//	CASE "colunm1" 
//    IF data = 'A' THEN
//	      /*action*/
//    END IF
//	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
//END CHOOSE
//
end event

type dw_2 from datawindow within w_masterfile_003
boolean visible = false
integer x = 2587
integer y = 268
integer width = 2615
integer height = 1844
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "미발행 택"
string dataobject = "d_masterfile_d32"
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
//cb_print.enabled = false
//cb_preview.enabled = false
//cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
//
//CHOOSE CASE dwo.name
//	CASE "colunm1" 
//    IF data = 'A' THEN
//	      /*action*/
//    END IF
//	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
//END CHOOSE
//
end event

