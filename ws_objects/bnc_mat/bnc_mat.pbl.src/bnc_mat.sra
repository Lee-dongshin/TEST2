$PBExportHeader$bnc_mat.sra
$PBExportComments$보끄레 MIS 시스템
forward
global type bnc_mat from application
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

string    gs_home_dir   = "C:\BNC_mat"     /* HOME DIR        */
string    gs_sessionid  = "ssn-id"          /* sessionID       */
string    gs_user_id    = "bnc_mat"          /* 사용자 ID       */
string    gs_user_nm    = "USERNAME"        /* 성명            */
Long      gl_user_level                     /* 사용자 등급     */
string    gs_brand                          /* 관련 브랜드코드 */
string    gs_user_grp                       /* 사용자 그룹     */
string    gs_dept_cd    = "PART"            /* 부서코드        */
string    gs_dept_nm    = "부서명"          /* 부서명          */
string    gs_menu_id                        /* menuID          */
integer   gi_menu_pos = 3                   /* 메뉴의 창위치   */
string    gs_style_comb                     /* 메뉴의 창위치   */
string    gs_DB			                     /* 메뉴의 창위치   */
decimal   gdc_rate								  /* 할인률 or 마진률*/	

end variables

global type bnc_mat from application
string appname = "bnc_mat"
integer highdpimode = 0
string appruntimeversion = "25.0.0.3726"
end type
global bnc_mat bnc_mat

type prototypes
FUNCTION ulong SetCapture(UINT hWnd )      LIBRARY "user32.dll"
FUNCTION ulong GetCapture( )               LIBRARY "user32.dll"
SUBROUTINE     ReleaseCapture ()           LIBRARY "user32.dll"
FUNCTION ulong CreateMutexA (ulong lpMutexAttributes, int bInitialOwner, ref string lpName) library "kernel32.dll" alias for "CreateMutexA;Ansi"
FUNCTION ulong GetLastError () library "kernel32.dll" 
FUNCTION uint WinExec(ref string filename, uint wstyle) LIBRARY "kernel32.dll" alias for "WinExec;Ansi"
FUNCTION BOOLEAN GetComputerNameA(REF STRING cname,REF LONG nbuf) LIBRARY "kernel32.dll" alias for "GetComputerNameA;Ansi"







end prototypes

on bnc_mat.create
appname="bnc_mat"
message=create message
sqlca=create u_n_tr
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on bnc_mat.destroy
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

/* MAIN FRAME Window를 Open한다. */
Open (w_main00)


idle(6000)
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

Resp = MessageBox("시간 초과","100분동안 사용하지 않아 자동으로 종료합니다!")

halt;

end event

