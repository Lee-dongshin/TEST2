$PBExportHeader$w_log.srw
$PBExportComments$Log in Window
forward
global type w_log from w_logon
end type
type gb_1 from groupbox within w_log
end type
type st_1 from statictext within w_log
end type
type st_4 from statictext within w_log
end type
type st_nm from statictext within w_log
end type
type gb_2 from groupbox within w_log
end type
type sle_new from u_sle within w_log
end type
type sle_new2 from u_sle within w_log
end type
type st_5 from u_st within w_log
end type
type rb_beaucre from radiobutton within w_log
end type
type rb_eternal from radiobutton within w_log
end type
type gb_3 from groupbox within w_log
end type
end forward

global type w_log from w_logon
integer x = 699
integer y = 500
integer width = 2199
integer height = 1040
gb_1 gb_1
st_1 st_1
st_4 st_4
st_nm st_nm
gb_2 gb_2
sle_new sle_new
sle_new2 sle_new2
st_5 st_5
rb_beaucre rb_beaucre
rb_eternal rb_eternal
gb_3 gb_3
end type
global w_log w_log

type variables
integer ii_focus
end variables

on w_log.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.st_1=create st_1
this.st_4=create st_4
this.st_nm=create st_nm
this.gb_2=create gb_2
this.sle_new=create sle_new
this.sle_new2=create sle_new2
this.st_5=create st_5
this.rb_beaucre=create rb_beaucre
this.rb_eternal=create rb_eternal
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_nm
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.sle_new
this.Control[iCurrent+7]=this.sle_new2
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.rb_beaucre
this.Control[iCurrent+10]=this.rb_eternal
this.Control[iCurrent+11]=this.gb_3
end on

on w_log.destroy
call super::destroy
destroy(this.gb_1)
destroy(this.st_1)
destroy(this.st_4)
destroy(this.st_nm)
destroy(this.gb_2)
destroy(this.sle_new)
destroy(this.sle_new2)
destroy(this.st_5)
destroy(this.rb_beaucre)
destroy(this.rb_eternal)
destroy(this.gb_3)
end on

event open;//
end event

event pfc_default();

integer	li_rc
String   ls_userid, ls_passwd,   ls_newpasswd, ls_err_msg = SPACE(80)
String   ls_dept_cd = space(4),  ls_brand = space(1), ls_user_grp = space(1)
string   ls_work_gbn
Long     ll_err_no, ll_user_level 



if LenA (sle_userid.text) = 0 then
	of_MessageBox ("pfc_logon_enterid", inv_logonattrib.is_appname, &
		"사용자id를 입력하세요.", exclamation!, OK!, 1)
	sle_userid.SetFocus()
	return
end if

if ii_focus = 1 then
	sle_password.SetFocus()
	return
end if
	
if LenA (sle_password.text) = 0 then
	of_MessageBox ("pfc_logon_enterpassword", inv_logonattrib.is_appname, &
		"비밀 번호를 입력하세요", exclamation!, OK!, 1)
	sle_password.SetFocus()
	return
end if

if ii_focus = 5 then
	sle_new2.SetFocus()
	return
end if

if sle_new.text <> sle_new2.text then
	of_MessageBox ("pfc_new_password", inv_logonattrib.is_appname, &
		"변경할 비밀번호를 확인하세요", exclamation!, OK!, 1)
	sle_new.SetFocus()
	return
end if

ls_userid    = sle_userid.text
ls_passwd    = sle_password.text
ls_newpasswd = sle_new.text


SQLCA.SP_CUST_LOGIN(ls_userid,  ls_passwd,   ls_newpasswd, ll_user_level, &
                    ls_brand, ls_user_grp, ll_err_no,    ls_err_msg)
//						  
//SQLCA.SP_USER_INFO(ls_userid,   ls_passwd,   ls_newpasswd, ll_user_level, &
//                   ls_brand,    ls_user_grp, ll_err_no,    ls_err_msg)
//

IF sqlca.sqlcode <> 0 THEN 
	ROLLBACK;
   MessageBox("System 오류", SQLCA.SQLErrText)
	inv_logonattrib.ii_rc = -1	
	CloseWithReturn (this, inv_logonattrib)
ELSEIF ll_err_no <> 0 THEN
	ROLLBACK;
   MessageBox("오류", Trim(ls_err_msg))
   sle_password.SetFocus()
ELSE
	COMMIT;
   inv_logonattrib.ii_rc = 1 
	gs_user_id    = ls_userid
	gl_user_level = ll_user_level
	gs_dept_cd    = ls_dept_cd
	gs_brand      = ls_brand 
	gs_user_grp   = ls_user_grp
   gs_user_nm    = st_nm.text
   CloseWithReturn (this, inv_logonattrib)	
//	open (w_mat_d01)
//	OpenSheet(w_mat_d01, w_main00) 
//messagebox('gs_user_id',upper(gs_user_id))
	if upper(gs_user_id) = 'FITI1' then 
			OpenSheet(w_kola_101_e, w_main00, gi_menu_pos, Original! ) 
	elseif upper(gs_user_id) = 'KATRI' then 
			OpenSheet(w_kola_101_e, w_main00, gi_menu_pos, Original! ) 		
	end if
END IF





Return





end event

type p_logo from w_logon`p_logo within w_log
integer x = 0
integer y = 0
integer width = 1193
integer height = 832
boolean originalsize = false
string picturename = "beaucre.gif"
end type

type st_help from w_logon`st_help within w_log
integer x = 5
integer y = 860
integer width = 2094
integer height = 72
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = " 사용자 사번과 비밀번호를 입력하십시요"
end type

type cb_ok from w_logon`cb_ok within w_log
integer x = 1243
integer y = 712
integer width = 384
integer taborder = 60
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인(&Y)"
end type

type cb_cancel from w_logon`cb_cancel within w_log
integer x = 1719
integer y = 712
integer width = 389
integer taborder = 70
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

type sle_userid from w_logon`sle_userid within w_log
integer x = 1522
integer y = 184
integer width = 256
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
textcase textcase = upper!
integer limit = 6
end type

event sle_userid::losefocus;call super::losefocus;string ls_name,ls_person_nm,ls_home_dir
boolean  lb_db_status = True
environment env
double ldb_size_X, ldb_size_Y
integer	li_rc
ulong		lul_Rc, lul_size = 260 	/* MAX_PATH */




IF LenA(This.Text) <> 0 THEN
	if rb_eternal.checked then 
		if (isNull(SQLCA.DBHandle()) or SQLCA.DBHandle() = 0) then
			GS_DB = "E"
			if gf_connect_dbms_eternal(SQLCA) = FALSE then
				lb_db_Status = False
				Close(parent)
			end if
		end if	
	else
		if (isNull(SQLCA.DBHandle()) or SQLCA.DBHandle() = 0) then
			GS_DB = "B"			
			if gf_connect_dbms_beaucre(SQLCA) = FALSE then
				lb_db_Status = False
				Close(parent)
			end if
		end if
	end if
	
	
	gb_db_status = lb_db_Status
				
//	select PERSON_NM
//	into :ls_person_nm
//	from tb_93010_m (nolock)
//	where PERSON_id = :sle_userid.Text;
//	
//	st_nm.text = ls_person_nm
//
//	
//	sle_password.setfocus()
	
	
	IF LenA(this.Text) <> 0 THEN
//		IF gf_user_nm(This.text, st_nm.text) <> 0 THEN
		IF gf_user_nm(This.text, st_nm.text) <> 0 THEN			
			This.SetFocus()
		END IF
	END IF
END IF



end event

event sle_userid::getfocus;call super::getfocus;gf_kor_eng(Handle(Parent), 'DE', 1)
ii_focus = 1

end event

type sle_password from w_logon`sle_password within w_log
integer x = 1522
integer y = 308
integer width = 585
integer taborder = 30
end type

event sle_password::getfocus;call super::getfocus;ii_focus = 2

end event

type st_2 from w_logon`st_2 within w_log
integer x = 1243
integer y = 184
integer width = 274
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "사   번"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
end type

type st_3 from w_logon`st_3 within w_log
integer x = 1243
integer width = 274
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "비밀번호"
boolean border = true
borderstyle borderstyle = styleraised!
end type

type gb_1 from groupbox within w_log
integer x = 270
integer y = 360
integer width = 654
integer height = 332
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

type st_1 from statictext within w_log
integer x = 1243
integer y = 464
integer width = 274
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "변경번호"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_4 from statictext within w_log
integer x = 1243
integer y = 592
integer width = 274
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "확인번호"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_nm from statictext within w_log
integer x = 1778
integer y = 184
integer width = 329
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_log
integer x = 187
integer y = 188
integer width = 425
integer height = 332
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type sle_new from u_sle within w_log
integer x = 1522
integer y = 464
integer width = 585
integer height = 76
integer taborder = 40
boolean bringtotop = true
boolean autohscroll = true
boolean password = true
end type

event getfocus;call super::getfocus;ii_focus = 5

end event

type sle_new2 from u_sle within w_log
integer x = 1522
integer y = 592
integer width = 585
integer height = 76
integer taborder = 50
boolean bringtotop = true
boolean autohscroll = true
boolean password = true
end type

event getfocus;call super::getfocus;ii_focus = 6

end event

type st_5 from u_st within w_log
integer x = 1243
integer y = 84
integer width = 274
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "사업장"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
end type

type rb_beaucre from radiobutton within w_log
integer x = 1563
integer y = 36
integer width = 439
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80263581
string text = "보끄레/올리브"
boolean checked = true
end type

type rb_eternal from radiobutton within w_log
integer x = 1563
integer y = 112
integer width = 439
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80263581
string text = "이터널그룹"
end type

type gb_3 from groupbox within w_log
integer x = 1522
integer width = 594
integer height = 180
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 80263581
end type

