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
type st_5 from statictext within w_log
end type
type rb_korea from radiobutton within w_log
end type
type rb_china from radiobutton within w_log
end type
type st_6 from statictext within w_log
end type
type st_7 from statictext within w_log
end type
type rb_beaucre from radiobutton within w_log
end type
type rb_reolive from radiobutton within w_log
end type
type gb_3 from groupbox within w_log
end type
type gb_e from groupbox within w_log
end type
end forward

global type w_log from w_logon
integer x = 699
integer y = 500
integer width = 2309
integer height = 1068
gb_1 gb_1
st_1 st_1
st_4 st_4
st_nm st_nm
gb_2 gb_2
sle_new sle_new
sle_new2 sle_new2
st_5 st_5
rb_korea rb_korea
rb_china rb_china
st_6 st_6
st_7 st_7
rb_beaucre rb_beaucre
rb_reolive rb_reolive
gb_3 gb_3
gb_e gb_e
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
this.rb_korea=create rb_korea
this.rb_china=create rb_china
this.st_6=create st_6
this.st_7=create st_7
this.rb_beaucre=create rb_beaucre
this.rb_reolive=create rb_reolive
this.gb_3=create gb_3
this.gb_e=create gb_e
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_nm
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.sle_new
this.Control[iCurrent+7]=this.sle_new2
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.rb_korea
this.Control[iCurrent+10]=this.rb_china
this.Control[iCurrent+11]=this.st_6
this.Control[iCurrent+12]=this.st_7
this.Control[iCurrent+13]=this.rb_beaucre
this.Control[iCurrent+14]=this.rb_reolive
this.Control[iCurrent+15]=this.gb_3
this.Control[iCurrent+16]=this.gb_e
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
destroy(this.rb_korea)
destroy(this.rb_china)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.rb_beaucre)
destroy(this.rb_reolive)
destroy(this.gb_3)
destroy(this.gb_e)
end on

event open;Window ldw_parent

ldw_parent = This.ParentWindow()
This.x = ((ldw_parent.Width - This.Width) / 2) +  ldw_parent.x
This.y = ((ldw_parent.Height - This.Height) / 2) +  ldw_parent.y 
gs_country_cd = '00'
gs_country_nm = '한국'
end event

event pfc_default();integer	li_rc
String   ls_shop_cd, ls_passwd,  ls_newpasswd, ls_err_msg = SPACE(80)
String   ls_brand_cd = space(1), ls_user_grp = space(1)
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

ls_shop_cd   = sle_userid.text
ls_passwd    = sle_password.text
ls_newpasswd = sle_new.text

//
//SQLCA.SP_SHOP_LOGIN(ls_shop_cd,  ls_passwd,   ls_newpasswd, ll_user_level, &
//                    ls_brand_cd, ls_user_grp, ll_err_no,    ls_err_msg)
//						  

SQLCA.SP_CUST_LOGIN(ls_shop_cd,  ls_passwd,   ls_newpasswd, ll_user_level, &
                    ls_brand_cd, ls_user_grp, ll_err_no,    ls_err_msg)
						  
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
	gs_shop_cd    = ls_shop_cd 
	gs_user_id    = ls_shop_cd 
	gl_user_level = ll_user_level 
	gs_brand      = ls_brand_cd 
	gs_user_grp   = ls_user_grp 
   gs_shop_nm    = st_nm.text  
	gs_shop_div   = MidA(ls_shop_cd, 2, 1)
   CloseWithReturn (this, inv_logonattrib)	
END IF
		
Return
end event

type p_logo from w_logon`p_logo within w_log
integer x = 18
integer y = 20
integer width = 1170
integer height = 840
boolean originalsize = false
string picturename = "beaucre.gif"
end type

type st_help from w_logon`st_help within w_log
integer x = 32
integer y = 888
integer width = 2231
integer height = 72
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "업체코드 와 비밀번호를 입력하십시요"
end type

type cb_ok from w_logon`cb_ok within w_log
integer x = 1307
integer y = 784
integer width = 384
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인(&Y)"
end type

type cb_cancel from w_logon`cb_cancel within w_log
integer x = 1783
integer y = 784
integer width = 389
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

type sle_userid from w_logon`sle_userid within w_log
integer x = 1586
integer y = 312
integer width = 238
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
textcase textcase = upper!
integer limit = 6
end type

event sle_userid::losefocus;call super::losefocus;ulong		lul_Rc, lul_size = 260 	/* MAX_PATH */
String   ls_home_dir		
integer	li_rc
boolean  lb_db_status = True
environment env
double ldb_size_X, ldb_size_Y


IF LenA(This.Text) <> 0 THEN

	if rb_reolive.checked then 
					MESSAGEBOX("연결!", "DB 연결!")
		if (isNull(SQLCA.DBHandle()) or SQLCA.DBHandle() = 0) then
			if gf_connect_dbms_reolive(SQLCA) = FALSE then
				lb_db_Status = False
				Close(parent)
			end if
	   ELSE
			MESSAGEBOX("연결!", "이터널DB 연결!")			
		end if	
	else
		if (isNull(SQLCA.DBHandle()) or SQLCA.DBHandle() = 0) then
			if gf_connect_dbms_beaucre(SQLCA) = FALSE then
				lb_db_Status = False
				Close(parent)
			end if
	
		end if
	end if
	
	
	IF gf_CUST_nm(This.text, 'S', st_nm.text) <> 0 THEN
		IF This.text = 'TB1004' THEN 
			st_nm.text = 'TEST매장'
		ELSE
	      This.SetFocus()
		END IF
	END IF
END IF
end event

event sle_userid::getfocus;call super::getfocus;gf_kor_eng(Handle(Parent), 'DE', 1)
ii_focus = 1


//IF Len(This.Text) <> 0 THEN
//	if rb_reolive.checked then 
//		if (isNull(SQLCA.DBHandle()) or SQLCA.DBHandle() = 0) then
//			if gf_connect_dbms_reolive(SQLCA) = FALSE then
//				lb_db_Status = False
//				Close(parent)
//			end if
//		end if	
//	else
//		if (isNull(SQLCA.DBHandle()) or SQLCA.DBHandle() = 0) then
//			if gf_connect_dbms_beaucre(SQLCA) = FALSE then
//				lb_db_Status = False
//				Close(parent)
//			end if
//		end if
//	end if
end event

type sle_password from w_logon`sle_password within w_log
integer x = 1586
integer y = 488
integer width = 585
end type

event sle_password::getfocus;call super::getfocus;ii_focus = 2

end event

type st_2 from w_logon`st_2 within w_log
integer x = 1307
integer y = 312
integer width = 274
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "업체코드"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
end type

type st_3 from w_logon`st_3 within w_log
integer x = 1307
integer y = 488
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
integer x = 210
integer y = 456
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
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_log
integer x = 1307
integer y = 584
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
integer x = 1307
integer y = 680
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
integer x = 1586
integer y = 400
integer width = 585
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
integer y = 84
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
borderstyle borderstyle = stylelowered!
end type

type sle_new from u_sle within w_log
integer x = 1586
integer y = 584
integer width = 585
integer height = 76
integer taborder = 70
boolean bringtotop = true
boolean autohscroll = true
boolean password = true
end type

event getfocus;call super::getfocus;ii_focus = 5

end event

type sle_new2 from u_sle within w_log
integer x = 1586
integer y = 680
integer width = 585
integer height = 76
integer taborder = 80
boolean bringtotop = true
boolean autohscroll = true
boolean password = true
end type

event getfocus;call super::getfocus;ii_focus = 6

end event

type st_5 from statictext within w_log
integer x = 1307
integer y = 400
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
long backcolor = 80263581
string text = "업체명칭"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type rb_korea from radiobutton within w_log
integer x = 1609
integer y = 220
integer width = 219
integer height = 64
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "한국"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;gs_country_cd = '00'
gs_country_nm = '한국'
end event

type rb_china from radiobutton within w_log
integer x = 1911
integer y = 220
integer width = 247
integer height = 64
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "중국"
borderstyle borderstyle = stylelowered!
end type

event clicked;gs_country_cd = '06'
gs_country_nm = '중국'
end event

type st_6 from statictext within w_log
integer x = 1307
integer y = 212
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
long backcolor = 80263581
string text = "원산지"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_7 from statictext within w_log
integer x = 1307
integer y = 32
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
long backcolor = 80263581
string text = "시스템"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type rb_beaucre from radiobutton within w_log
integer x = 1609
integer y = 36
integer width = 462
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "보끄레/올리브"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;	if rb_reolive.checked then 
		p_logo.Picturename = "c:\bnc_cust\bmp\eternal.gif"		
	else
		p_logo.Picturename = "c:\bnc_cust\bmp\beaucre.gif"		
	end if
	
	
end event

type rb_reolive from radiobutton within w_log
integer x = 1609
integer y = 100
integer width = 311
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "이터널"
borderstyle borderstyle = stylelowered!
end type

event clicked;	if rb_reolive.checked then 
		p_logo.Picturename = "c:\bnc_cust\bmp\eternal.gif"		
	else
		p_logo.Picturename = "c:\bnc_cust\bmp\beaucre.gif"		
	end if
	
	
end event

type gb_3 from groupbox within w_log
integer x = 1582
integer y = 176
integer width = 603
integer height = 124
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

type gb_e from groupbox within w_log
integer x = 1582
integer width = 603
integer height = 180
integer taborder = 10
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

