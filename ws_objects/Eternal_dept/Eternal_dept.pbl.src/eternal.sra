$PBExportHeader$eternal.sra
$PBExportComments$이터널 MIS 시스템
forward
global type eternal from application
end type
global u_n_tr sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
/* 공통 전역변수 */
n_cst_appmanager    gnv_app
u_changekorea       gu_auto_koram           /* 한영 자동변환 */
gs_cd_search        gst_cd                  /* 검색창 Structure */
gs_vari_cd          gsv_cd                  /* 코드 Structure */

nvo_ftp u_ftp										  /* Ftp 관련 */
ulong ll_connect, ll_open						  /* Ftp 관련 */

string    gs_home_dir   = "C:\Eternal_DEPT"     /* HOME DIR        */
string    gs_sessionid  = "ssn-id"          /* sessionID       */
string    gs_user_id    = "USERID"          /* 사용자 ID       */
string    gs_user_pw    = "USERPW"          /* 사용자 pw       */
string    gs_user_nm    = "USERNAME"        /* 성명            */
Long      gl_user_level                     /* 사용자 등급     */
string    gs_brand                          /* 관련 브랜드코드 */
string    gs_lang                           /* 언어선택        */
string    gs_user_grp                       /* 사용자 그룹     */
string    gs_dept_cd    = "PART"            /* 부서코드        */
string    gs_dept_nm    = "부서명"          /* 부서명          */
string    gs_menu_id                        /* menuID          */
integer   gi_menu_pos = 3                   /* 메뉴의 창위치   */
string    gs_style_comb                     /* 메뉴의 창위치   */
decimal   gdc_rate								  /* 할인률 or 마진률*/	

end variables

global type eternal from application
string appname = "eternal"
integer highdpimode = 0
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 25.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 5
long richtexteditx64type = 5
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = ""
string appruntimeversion = "25.0.0.3726"
boolean manualsession = false
boolean unsupportedapierror = false
boolean ultrafast = false
boolean bignoreservercertificate = false
uint ignoreservercertificate = 0
long webview2distribution = 0
boolean webview2checkx86 = false
boolean webview2checkx64 = false
string webview2url = "https://developer.microsoft.com/en-us/microsoft-edge/webview2/"
end type
global eternal eternal

type prototypes
FUNCTION ulong SetCapture(UINT hWnd )      LIBRARY "user32.dll"
FUNCTION ulong GetCapture( )               LIBRARY "user32.dll"
SUBROUTINE     ReleaseCapture ()           LIBRARY "user32.dll"
FUNCTION ulong CreateMutexA (ulong lpMutexAttributes, int bInitialOwner, ref string lpName) library "kernel32.dll" alias for "CreateMutexA;Ansi"
FUNCTION ulong GetLastError () library "kernel32.dll" 
FUNCTION uint WinExec(ref string filename, uint wstyle) LIBRARY "kernel32.dll" alias for "WinExec;Ansi"
FUNCTION BOOLEAN GetComputerNameA(REF STRING cname,REF LONG nbuf) LIBRARY "kernel32.dll" alias for "GetComputerNameA;Ansi"
Function integer GetIPAddress ( ref string buf, integer len ) library "getmacip.dll" alias for "GetIPAddress;Ansi" //alias for "GetIPAddress;Ansi"

//FUNCTION long ShellExecuteA( long hWnd, REF String ls_Operation, REF String ls_File, REF String ls_Parameters, REF String  ls_Directory, INT nShowCmd ) library 'shell32' alias for "ShellExecuteA;Ansi"
FUNCTION long ShellExecuteW( long hWnd, REF String ls_Operation, REF String ls_File, REF String ls_Parameters, REF String  ls_Directory, INT nShowCmd ) library 'shell32' 








end prototypes

forward prototypes
public function boolean f_newexe_chk ()
end prototypes

public function boolean f_newexe_chk ();String ls_file_nm
n_cst_filesrvwin32   luo_file32

ls_file_nm = gs_home_dir + '\eternal.exe'

IF FileExists(ls_file_nm + '__')  = FALSE THEN RETURN FALSE

luo_file32 = create n_cst_filesrvwin32

FileDelete(ls_file_nm)
luo_file32.of_filerename(ls_file_nm + '__', ls_file_nm)

destroy(luo_file32)

RETURN TRUE
end function

on eternal.create
appname="eternal"
message=create message
sqlca=create u_n_tr
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on eternal.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;gnv_app = CREATE n_cst_appmanager
gu_auto_koram = CREATE u_changekorea

///* Program 중복실행 체크 (실행 Program 생성시 필요) */
//ulong ll_mutex, ll_err
//string ls_mutex_name
//
//if handle (GetApplication (), false) <> 0 then
//   ls_mutex_name = this.AppName + char (0)
//   ll_mutex = CreateMutexA (0, 0, ls_mutex_name)
//   ll_err = GetLastError ()
//   if ll_err = 183 then    // 프로그램 실행중
//      MessageBox ("경고",  "보끄레머천다이징 시스템 이미 실행중 입니다.")     
//      halt close
//   end if
//end if
///* Program 중복실행 체크 END */

//IF f_newexe_chk() THEN
//	MessageBox("확인", "MAIN 프로그램이 변경되었습니다.~r~n 다시 시작하십시오")
//	RETURN
//END IF

/* MAIN FRAME Window를 Open한다. */
IF commandline = "EIS" THEN 
   Open (w_main01)
ELSE
   Open (w_main00)
END IF

idle(10800)
/* 실행 모듈 생성시 REMARK END */

end event

event close;DESTROY gnv_app 
DESTROY gu_auto_koram 
Disconnect ;
end event

event systemerror;/*------------------------------------------------------------*/
/* Name          : Application; systemerror                   */
/* 내        용  : Application Run시의 RunTime Error Message  */
/*------------------------------------------------------------*/

// Open(w_0_0005)
return
end event

event idle;integer Resp

// *** 사용하던 모든 작업을 취소한다.
ROLLBACK USING SQLCA ;
//gf_set_end_log ('ALL') ;
COMMIT USING SQLCA ;
DISCONNECT USING SQLCA;

Resp = MessageBox("시간 초과","180분동안 사용하지 않아 자동으로 종료합니다!")

halt;

end event

