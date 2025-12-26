$PBExportHeader$w_logon.srw
forward
global type w_logon from window
end type
type rb_reolive from radiobutton within w_logon
end type
type rb_beaucre from radiobutton within w_logon
end type
type st_2 from statictext within w_logon
end type
type st_1 from statictext within w_logon
end type
type rb_chn from radiobutton within w_logon
end type
type rb_kor from radiobutton within w_logon
end type
type st_person_nm from statictext within w_logon
end type
type cb_2 from commandbutton within w_logon
end type
type cb_1 from commandbutton within w_logon
end type
type st_6 from statictext within w_logon
end type
type st_5 from statictext within w_logon
end type
type p_1 from picture within w_logon
end type
type st_9 from statictext within w_logon
end type
type st_8 from statictext within w_logon
end type
type st_7 from statictext within w_logon
end type
type sle_userid from singlelineedit within w_logon
end type
type sle_password from singlelineedit within w_logon
end type
type sle_new from singlelineedit within w_logon
end type
type sle_new2 from singlelineedit within w_logon
end type
type gb_1 from groupbox within w_logon
end type
type gb_2 from groupbox within w_logon
end type
end forward

global type w_logon from window
integer width = 2217
integer height = 1060
boolean titlebar = true
string title = "Logon"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
rb_reolive rb_reolive
rb_beaucre rb_beaucre
st_2 st_2
st_1 st_1
rb_chn rb_chn
rb_kor rb_kor
st_person_nm st_person_nm
cb_2 cb_2
cb_1 cb_1
st_6 st_6
st_5 st_5
p_1 p_1
st_9 st_9
st_8 st_8
st_7 st_7
sle_userid sle_userid
sle_password sle_password
sle_new sle_new
sle_new2 sle_new2
gb_1 gb_1
gb_2 gb_2
end type
global w_logon w_logon

forward prototypes
public function boolean uf_check_user ()
end prototypes

public function boolean uf_check_user ();long	lb_check

gs_user_id = sle_userid.text
gs_pass_wd = sle_password.text

select 1
	into :lb_check
from tb_93010_m (nolock)
where PERSON_id = :gs_user_id
and   pass_wd   = :gs_pass_wd;

if lb_check = 1 then
	return true
else
	return false
end if

return false
end function

on w_logon.create
this.rb_reolive=create rb_reolive
this.rb_beaucre=create rb_beaucre
this.st_2=create st_2
this.st_1=create st_1
this.rb_chn=create rb_chn
this.rb_kor=create rb_kor
this.st_person_nm=create st_person_nm
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_6=create st_6
this.st_5=create st_5
this.p_1=create p_1
this.st_9=create st_9
this.st_8=create st_8
this.st_7=create st_7
this.sle_userid=create sle_userid
this.sle_password=create sle_password
this.sle_new=create sle_new
this.sle_new2=create sle_new2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.rb_reolive,&
this.rb_beaucre,&
this.st_2,&
this.st_1,&
this.rb_chn,&
this.rb_kor,&
this.st_person_nm,&
this.cb_2,&
this.cb_1,&
this.st_6,&
this.st_5,&
this.p_1,&
this.st_9,&
this.st_8,&
this.st_7,&
this.sle_userid,&
this.sle_password,&
this.sle_new,&
this.sle_new2,&
this.gb_1,&
this.gb_2}
end on

on w_logon.destroy
destroy(this.rb_reolive)
destroy(this.rb_beaucre)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.rb_chn)
destroy(this.rb_kor)
destroy(this.st_person_nm)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.p_1)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.sle_userid)
destroy(this.sle_password)
destroy(this.sle_new)
destroy(this.sle_new2)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;this.x = 500
this.y = 600
end event

type rb_reolive from radiobutton within w_logon
integer x = 1531
integer y = 112
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
string text = "이터널"
borderstyle borderstyle = stylelowered!
end type

event clicked;	if rb_reolive.checked then 
		p_1.Picturename = "C:\BNC_MASTERFILE\eternal.gif"		
	else
		p_1.Picturename = "C:\BNC_MASTERFILE\beaucre.gif"		
	end if
	
	
end event

type rb_beaucre from radiobutton within w_logon
integer x = 1531
integer y = 52
integer width = 466
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "보끄레/올리브"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
	if rb_reolive.checked then 
		p_1.Picturename = "eternal.gif"		
	else
		p_1.Picturename = "beaucre.gif"		
	end if
	
	
end event

type st_2 from statictext within w_logon
integer x = 1221
integer y = 64
integer width = 274
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80269524
string text = "시스템"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_1 from statictext within w_logon
integer x = 1221
integer y = 224
integer width = 274
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80269524
string text = "원산지"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type rb_chn from radiobutton within w_logon
integer x = 1815
integer y = 228
integer width = 293
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "중국용"
borderstyle borderstyle = stylelowered!
end type

type rb_kor from radiobutton within w_logon
integer x = 1531
integer y = 228
integer width = 279
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "국내용"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type st_person_nm from statictext within w_logon
integer x = 1696
integer y = 312
integer width = 443
integer height = 72
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80269524
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_logon
integer x = 1691
integer y = 728
integer width = 384
integer height = 92
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;Close(w_logon)
end event

type cb_1 from commandbutton within w_logon
event ue_keydown pbm_dwnkey
integer x = 1216
integer y = 728
integer width = 384
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인(&Y)"
end type

event ue_keydown;CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
END CHOOSE

end event

event clicked;if uf_check_user() then
	if rb_kor.checked then
		if MidA(gs_user_id,3,4) = "7876"  or MidA(gs_user_id,3,4) = "4986" then			
			open(w_masterfile_001)
		elseif MidA(gs_user_id,3,4) = "603A" then			
			open(w_masterfile_001)
		else
			open(w_masterfile_003)			
		end if	
	else
		open(w_masterfile_002)
	end if
	close(w_logon)
end if

end event

type st_6 from statictext within w_logon
integer x = 1216
integer y = 312
integer width = 274
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80269524
string text = "사번"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_5 from statictext within w_logon
integer x = 5
integer y = 860
integer width = 2094
integer height = 72
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80269524
string text = " 사용자 사번과 비밀번호를 입력하십시요"
boolean focusrectangle = false
end type

type p_1 from picture within w_logon
integer width = 1170
integer height = 840
string picturename = "beaucre.gif"
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_9 from statictext within w_logon
integer x = 1216
integer y = 624
integer width = 274
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80269524
string text = "확인번호"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_8 from statictext within w_logon
integer x = 1216
integer y = 516
integer width = 274
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80269524
string text = "변경번호"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_7 from statictext within w_logon
integer x = 1216
integer y = 416
integer width = 274
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80269524
string text = "비밀번호"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type sle_userid from singlelineedit within w_logon
integer x = 1495
integer y = 312
integer width = 206
integer height = 76
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

event modified;ulong		lul_Rc, lul_size = 260 	/* MAX_PATH */
String   ls_home_dir		
integer	li_rc
boolean  lb_db_status = True
environment env
double ldb_size_X, ldb_size_Y
string ls_person_nm


if LenA(sle_userid.Text) = 6 then 
	if rb_reolive.checked then 
		gs_saup_gubn = "E"
		if (isNull(SQLCA.DBHandle()) or SQLCA.DBHandle() = 0) then
			if gf_connect_dbms_reolive(SQLCA) = FALSE then
				lb_db_Status = False
				Close(parent)
			end if
		end if	
	else
		gs_saup_gubn = "B"
		if rb_kor.checked then
			if (isNull(SQLCA.DBHandle()) or SQLCA.DBHandle() = 0) then
				if gf_connect_dbms_beaucre(SQLCA) = FALSE then
					lb_db_Status = False
					Close(parent)
				end if
			end if
		else
			if (isNull(SQLCA.DBHandle()) or SQLCA.DBHandle() = 0) then
				if gf_connect_dbms_china(SQLCA) = FALSE then
					lb_db_Status = False
					Close(parent)
				end if
			end if			
		end if
	end if
	
	
	


				
	select PERSON_NM
	into :ls_person_nm
	from tb_93010_m (nolock)
	where PERSON_id = :sle_userid.Text;
	
	st_person_nm.text = ls_person_nm

	
	sle_password.setfocus()
	
end if

end event

type sle_password from singlelineedit within w_logon
integer x = 1495
integer y = 416
integer width = 645
integer height = 76
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean password = true
borderstyle borderstyle = stylelowered!
end type

event modified;if sle_password.text <> "" then cb_1.event clicked()
end event

type sle_new from singlelineedit within w_logon
integer x = 1495
integer y = 520
integer width = 645
integer height = 76
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_new2 from singlelineedit within w_logon
integer x = 1495
integer y = 628
integer width = 645
integer height = 76
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_logon
integer x = 1504
integer y = 184
integer width = 654
integer height = 124
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80269524
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_logon
integer x = 1504
integer y = 4
integer width = 654
integer height = 180
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80269524
borderstyle borderstyle = stylelowered!
end type

