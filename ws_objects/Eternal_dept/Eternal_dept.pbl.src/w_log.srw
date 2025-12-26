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
end forward

global type w_log from w_logon
integer x = 699
integer y = 500
integer width = 2199
integer height = 1040
long backcolor = 16777215
gb_1 gb_1
st_1 st_1
st_4 st_4
st_nm st_nm
gb_2 gb_2
sle_new sle_new
sle_new2 sle_new2
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
		
	
//		ls_string = "http://with.ibeaucre.co.kr/instant/chkver.asp?gubn=shop&saup=eternal&name=pbd"
		ls_string = "http://with.ibeaucre.co.kr/instant/chkver.asp?gubn=dept&saup=eternal&name=pbd"
		
	
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
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_nm
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.sle_new
this.Control[iCurrent+7]=this.sle_new2
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
end on

event open;//
end event

event pfc_default;integer	li_rc, li_rtrn
String   ls_userid, ls_passwd,   ls_newpasswd, ls_err_msg = SPACE(80)
String   ls_dept_cd = space(4),  ls_brand = space(1), ls_user_grp = space(1)
string   ls_work_gbn,ls_string ,ls_file_name
Long     ll_err_no, ll_user_level 

string 		ls_ini_file,ls_compname, ls_Ipaddr
LONG ll_buf
String ls_publicip, ls_host
int li_rc1
long i_pos1, i_pos2

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




//if wf_GetFileDate() then 
//	//messagebox("버전체크", "버전확인 완료! 계속 하시려면 확인을 눌러 주세요!")
//else 
//	 li_rtrn =  messagebox("버전오류 - 업데이트 필요!", "구버전 사용시 판매등록에 문제가 생길 수 있습니다. 재설치 또는 MIS팀에 문의 바랍니다! 업데이트 하시겠습니까?" ,Question!,OKCancel!)
//	   if li_rtrn = 1 then
////			Post Close(w_main01)
//			inv_logonattrib.ii_rc = -1	
//			CloseWithReturn (this, inv_logonattrib)
//			wstyle = 0
//			ls_file_name = "C:\eternal_dept\dept_install.exe"
//			rtn =  WinExec(ls_file_name, wstyle)
//			return
//		end if	
//end if	



ls_userid    = sle_userid.text
ls_passwd    = sle_password.text
ls_newpasswd = sle_new.text

		 
SQLCA.SP_USER_INFO(ls_userid,   ls_passwd,   ls_newpasswd, ll_user_level, ls_dept_cd, &
                   ls_brand,    ls_user_grp, ll_err_no,    ls_err_msg)

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
	gs_user_pw	  = ls_passwd
	gl_user_level = ll_user_level
	gs_dept_cd    = ls_dept_cd
	gs_brand      = ls_brand 
	gs_user_grp   = ls_user_grp
   gs_user_nm    = st_nm.text
	
	
				ll_buf = 25
				
				ls_Ipaddr = space(100) // 메모리 할당! = space(ll_buf) // 메모리 할당!
				
				ls_compname = space(ll_buf) // 메모리 할당!
//				
				GetIPAddress(ls_Ipaddr,LenA(ls_Ipaddr))
				
				GetComputerNameA(ls_compname, ll_buf)
//				
//				messagebox("IP", ls_Ipaddr)
//				
				if MidA(ls_Ipaddr,1,3) <> "172" then
					oleobject req
					
					req = CREATE oleobject
					li_rc = req.ConnectToNewObject("Msxml2.XMLHTTP.3.0")
					
					ls_string = "http://smartstore.ibeaucre.co.kr/chkIP.asp"
				
				
					IF li_rc < 0 THEN
					 ls_publicip = ''
					ELSE
					 req.open ("POST", ls_string , false)
					 req.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
					 req.send ()
					 ls_publicip = Trim(req.responsetext)
						ls_Ipaddr = ls_publicip
					END IF
					
					req.DisconnectObject()
					Destroy req				
			
//					messagebox("IP", ls_Ipaddr)
					
					if IsNull(ls_Ipaddr) or Trim(ls_Ipaddr) = "" then
						ls_Ipaddr = ""
					end if
	//					
					//	if ls_Ipaddr <> "175.208.191.122" and ls_Ipaddr <> "125.140.115.254" and  Trim(ls_Ipaddr) <> ""  then
							
							insert into tb_93080_h (login_date, person_id, login_ip, user_pass, person_nm, host_name)
							select getdate(), :gs_user_id, :ls_Ipaddr, :gs_user_pw,:gs_user_nm, :ls_compname ;
							COMMIT;
					//	end if
						
				end if	
					
   CloseWithReturn (this, inv_logonattrib)	
END IF




//ls_compname = ls_compname + ' / ' + ls_Ipaddr

//
//select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '1';
//if match(ls_work_gbn,'1') then // 원가계산서 확인
//	close(w_mesage_d)
//	open(w_mesage_d)
//end if
//
//select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '3';
//if match(ls_work_gbn,'3') then // 원자재출고요청 확인
//	close(w_mesage_d2)
//	open(w_mesage_d2)
//end if 
//
//select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '4';
//if match(ls_work_gbn,'4') then // CAd 완료 확인
//	close(w_mesage_d3)
//	open(w_mesage_d3)
//end if 
//
//select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '5';
//if match(ls_work_gbn,'5') then // 부자재 발주서 확인
//	close(w_mesage_d4)
//	open(w_mesage_d4)
//end if 
//
//select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '7';
//if match(ls_work_gbn,'7') then // 요척변경서 확인
//	close(w_mesage_d5)
//	open(w_mesage_d5)	
//end if 
//
//select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '8';
//if match(ls_work_gbn,'8') then // 요척변경서 확인
//	close(w_mesage_d6)
//	open(w_mesage_d6)	
//end if 
//
//select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '9';
//if match(ls_work_gbn,'9') then // 요척변경서 확인
//	close(w_mesage_d9)
//	open(w_mesage_d9)	
//end if 
//
//Return


end event

type p_logo from w_logon`p_logo within w_log
integer x = 0
integer y = 0
integer width = 1170
integer height = 840
boolean originalsize = false
string picturename = "C:\eternal_dept\bmp\eternal.gif"
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
long backcolor = 16777215
string text = " 사용자 사번과 비밀번호를 입력하십시요"
end type

type cb_ok from w_logon`cb_ok within w_log
integer x = 1239
integer y = 660
integer width = 384
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인(&Y)"
end type

type cb_cancel from w_logon`cb_cancel within w_log
integer x = 1714
integer y = 660
integer width = 389
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

type sle_userid from w_logon`sle_userid within w_log
integer x = 1518
integer y = 132
integer width = 256
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
textcase textcase = upper!
integer limit = 6
end type

event sle_userid::losefocus;call super::losefocus;string ls_name, ls_empno



IF LenA(this.Text) <> 0 THEN
	ls_empno = This.text
	//messagebox("", ls_empno)
	IF gf_user_nm(This.text, st_nm.text) <> 0 THEN
		
	   This.SetFocus()
	END IF
END IF

end event

event sle_userid::getfocus;call super::getfocus;gf_kor_eng(Handle(Parent), 'DE', 1)
ii_focus = 1

end event

type sle_password from w_logon`sle_password within w_log
integer x = 1518
integer y = 256
integer width = 585
end type

event sle_password::getfocus;call super::getfocus;ii_focus = 2

end event

type st_2 from w_logon`st_2 within w_log
integer x = 1239
integer y = 132
integer width = 274
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "사   번"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
end type

type st_3 from w_logon`st_3 within w_log
integer x = 1239
integer y = 256
integer width = 274
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
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
integer x = 1239
integer y = 412
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
long backcolor = 16777215
boolean enabled = false
string text = "변경번호"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_4 from statictext within w_log
integer x = 1239
integer y = 540
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
long backcolor = 16777215
boolean enabled = false
string text = "확인번호"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_nm from statictext within w_log
integer x = 1774
integer y = 132
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
long backcolor = 16777215
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
integer x = 1518
integer y = 412
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
integer x = 1518
integer y = 540
integer width = 585
integer height = 76
integer taborder = 60
boolean bringtotop = true
boolean autohscroll = true
boolean password = true
end type

event getfocus;call super::getfocus;ii_focus = 6

end event

