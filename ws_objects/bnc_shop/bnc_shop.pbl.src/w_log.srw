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
end type
global w_log w_log

type variables
integer ii_focus
end variables

forward prototypes
public function boolean wf_getfiledate ()
end prototypes

public function boolean wf_getfiledate ();OLEObject FSO, FSO2
INTEGER ll_result, li_rc,li_find
string rtn, ls_file_name, ls_file_path,ls_string, ls_file_date

LONG ll_buf
String ls_ver
int li_rc1
long i_pos1, i_pos2
 


	ll_buf = 25
	
	
		oleobject req
		
		req = CREATE oleobject
		
		li_rc = req.ConnectToNewObject("Msxml2.XMLHTTP.3.0")
		
	
		ls_string = "http://with.ibeaucre.co.kr/instant/chkver.asp?gubn=shop&saup=bnc&name=pbd"
//		ls_string = "http://with.ibeaucre.co.kr/instant/chkver.asp?gubn=dept&saup=eternal&name=pbd"
		
	
		IF li_rc < 0 THEN
		 ls_ver = ''
		ELSE
		 req.open ("POST", ls_string , false)
		 req.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
		 req.send ()
		 ls_ver = Trim(req.responsetext)
		
		END IF
		
		req.DisconnectObject()
		Destroy req				



li_find = PosA(ls_ver,"|")

//messagebox("", Trim(Mid(ls_ver, 1, li_find - 1)) )

ls_file_date = Trim(MidA(ls_ver, li_find + 1 , 12)) 
 

ls_file_path = gs_home_dir + "\pbd\" + Trim(MidA(ls_ver, 1, li_find - 1)) 

//messagebox("", ls_file_path )

//파일존재 여부
IF NOT FILEEXISTS(ls_file_path) THEN RETURN false 

// File System OBJECT 생성
FSO = CREATE OLEObject
FSO2 = CREATE OLEObject

 
//fileSystemObject를 연결

ll_result = FSO.ConnectToNewObject("Scripting.FileSystemObject")


//에러가 발생하였을경우 'none' 을 리턴

IF ll_result <> 0 THEN

DESTROY FSO
DESTROY FSO2
RETURN false
END IF

 
//선택한 파일 지정

FSO2 = FSO.GetFile(ls_file_path)

 

//File System 구하기
//rtn = string(FSO2.DateCreated , 'yyyy/mm/dd-hh:mm') --> 생성일자
//rtn = string(FSO2.DateLastAccessed , 'yyyy/mm/dd-hh:mm') --> 접근일자
//rtn = string(FSO2.DateLastModified , 'yyyy/mm/dd-hh:mm') --> 수정일자
//rtn = string(FileLength(as_filename)) --> 파일크기
 

//형식 지정

rtn = string(FSO2.DateLastModified, 'yyyy-mm-dd hh:mm:ss')
 
// File System OBJECT Destroy
DESTROY FSO
DESTROY FSO2

//messagebox("", rtn)

if LeftA(rtn,10) = ls_file_date then
	RETURN true
else 	
	RETURN false 
end if	

 
end function

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
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_nm
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.sle_new
this.Control[iCurrent+7]=this.sle_new2
this.Control[iCurrent+8]=this.st_5
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
end on

event open;Window ldw_parent

ldw_parent = This.ParentWindow()
This.x = ((ldw_parent.Width - This.Width) / 2) +  ldw_parent.x
This.y = ((ldw_parent.Height - This.Height) / 2) +  ldw_parent.y 

end event

event pfc_default();integer	li_rc,li_rtrn
String   ls_shop_cd, ls_passwd,  ls_newpasswd, ls_err_msg = SPACE(80)
String   ls_brand_cd = space(1), ls_user_grp = space(1), ls_file_name
Long     ll_err_no, ll_user_level 
uint wstyle, rtn

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


if wf_GetFileDate() then 
	//messagebox("버전체크", "버전확인 완료! 계속 하시려면 확인을 눌러 주세요!")
else 
	 li_rtrn =  messagebox("버전오류 - 업데이트 필요!", "구버전 사용시 판매등록에 문제가 생길 수 있습니다. 재설치 또는 MIS팀에 문의 바랍니다! 업데이트 하시겠습니까?" ,Question!,OKCancel!)
	   if li_rtrn = 1 then
//			Post Close(w_main01)
			inv_logonattrib.ii_rc = -1	
			CloseWithReturn (this, inv_logonattrib)
			wstyle = 0
			ls_file_name = "c:\bnc_shop\BNC_SHOP_INSTALL.exe"
			rtn =  WinExec(ls_file_name, wstyle)
			return
		end if	
end if	

ls_shop_cd   = sle_userid.text
ls_passwd    = sle_password.text
ls_newpasswd = sle_new.text

SQLCA.SP_SHOP_LOGIN(ls_shop_cd,  ls_passwd,   ls_newpasswd, ll_user_level, &
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
	gs_shop_cd     = ls_shop_cd 
	gs_user_id     = ls_shop_cd 
	gs_shop_pwd	   = ls_passwd
	gl_user_level  = ll_user_level 
	gs_brand       = ls_brand_cd 
	gs_user_grp    = ls_user_grp 
   gs_shop_nm     = st_nm.text  
	gs_brand_1     = gs_brand 
	gs_shop_cd_1   = gs_shop_cd

	select dbo.sf_inter_cd2('001', :gs_brand)
	into :gs_brand_grp    
	from dual;
	
	if MidA(ls_shop_cd, 2, 1) = 'X'  and ls_shop_cd <> "JX3300"  then
		select distinct shop_div
		into	:gs_shop_div
		from tb_91100_m  with (nolock) 
		where shop_cd like '%' + substring(:gs_shop_cd,3,4)
		AND SHOP_DIV IN ('B','G');	
		
		if MidA(gs_shop_cd,3,4) = '4251' then 
			gs_brand_nm = 'Lounge B'
			gs_shop_nm = '스타필드 고양점'
		end if	
		
		if MidA(gs_shop_cd,3,4) = '1890' then 
			gs_brand_nm = '본사매장'
			gs_shop_nm = '본사매장'
		end if	
	else
		gs_shop_div = MidA(ls_shop_cd, 2, 1)
	end if
	

	
   CloseWithReturn (this, inv_logonattrib)	
	
END IF
//		messagebox('gs_brand_1',gs_brand_1)
//		messagebox('gs_shop_cd_1',gs_shop_cd_1)
//		messagebox('gs_shop_div',gs_shop_div)
//		messagebox('gs_shop_CD',gs_shop_CD)		
Return
end event

type p_logo from w_logon`p_logo within w_log
integer x = 18
integer y = 20
integer width = 1170
integer height = 840
boolean originalsize = false
string picturename = "C:\bnc_shop\bmp\beaucre.gif"
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
string text = "매장코드 와 비밀번호를 입력하십시요"
end type

type cb_ok from w_logon`cb_ok within w_log
integer x = 1307
integer y = 724
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
integer y = 724
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
integer y = 124
integer width = 238
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
textcase textcase = upper!
integer limit = 6
end type

event sle_userid::losefocus;call super::losefocus;IF LenA(This.Text) <> 0 THEN
	
	if LeftA(This.Text,1) = 'O' OR  LeftA(This.Text,1) = 'Y' then
		p_logo.picturename = "C:\bnc_shop\bmp\olive_log.jpg"
	elseif LeftA(This.Text,1) = 'D' then
		p_logo.picturename = "C:\bnc_shop\bmp\miminko_log.jpg"		
	else 
    	p_logo.picturename = "C:\bnc_shop\bmp\beaucre_log.jpg"
	end if	 
		
	IF gf_shop_nm(This.text, 'S', st_nm.text) <> 0 THEN
		IF This.text = 'TB1004' THEN 
			st_nm.text = 'TEST매장'
		ELSEif This.text = '0X3300' THEN 
			st_nm.text = '가족행사판매0'
		ELSEif This.text = '1X3300' THEN 
			st_nm.text = '가족행사판매1'			
		ELSEif This.text = '2X3300' THEN 
			st_nm.text = '가족행사판매2'						
		ELSEif This.text = '3X3300' THEN 
			st_nm.text = '가족행사판매3'								
		ELSEif This.text = '4X3300' THEN 
			st_nm.text = '가족행사판매4'						
		ELSEif This.text = '5X3300' THEN 
			st_nm.text = '가족행사판매5'	
		ELSEif This.text = '6X3300' THEN 
			st_nm.text = '가족행사판매6'	
		ELSEif This.text = '7X3300' THEN 
			st_nm.text = '상황실1'
		ELSEif This.text = '8X3300' THEN 
			st_nm.text = '상황실2'
		ELSEif This.text = 'XX1890' THEN 
			st_nm.text = '본사매장'
		ELSEif This.text = 'XX1187' THEN 
			st_nm.text = 'LOUNGE B 대구매장'			
		ELSEif This.text = 'XX4251' THEN 
			st_nm.text = 'LOUNGE B 매장'
		ELSE			
	      This.SetFocus()
		END IF
	END IF
END IF
//
//0X3300	가족행사1
//1X3300	가족행사2
//2X3300	가족행사3
//3X3300	가족행사4
//4X3300	가족행사5
//5X3300	가족행사6
//
end event

event sle_userid::getfocus;call super::getfocus;gf_kor_eng(Handle(Parent), 'DE', 1)
ii_focus = 1

end event

type sle_password from w_logon`sle_password within w_log
integer x = 1586
integer y = 372
integer width = 585
end type

event sle_password::getfocus;call super::getfocus;ii_focus = 2

end event

type st_2 from w_logon`st_2 within w_log
integer x = 1307
integer y = 124
integer width = 274
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "매장코드"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
end type

type st_3 from w_logon`st_3 within w_log
integer x = 1307
integer y = 372
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
integer y = 496
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
integer y = 620
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
integer y = 248
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
integer y = 496
integer width = 585
integer height = 76
integer taborder = 50
boolean bringtotop = true
boolean autohscroll = true
boolean password = true
end type

event getfocus;call super::getfocus;ii_focus = 5

end event

type sle_new2 from u_sle within w_log
integer x = 1586
integer y = 620
integer width = 585
integer height = 76
integer taborder = 60
boolean bringtotop = true
boolean autohscroll = true
boolean password = true
end type

event getfocus;call super::getfocus;ii_focus = 6

end event

type st_5 from statictext within w_log
integer x = 1307
integer y = 248
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
string text = "매장명칭"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

