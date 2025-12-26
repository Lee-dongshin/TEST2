$PBExportHeader$bnc_smat.sra
$PBExportComments$보끄레 협력업체 시스템
forward
global type bnc_smat from application
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
u_changekorea       gu_auto_koram       /* 한영 자동변환 */
gs_cd_search        gst_cd              /* 검색창 Structure */
gs_vari_cd          gsv_cd              /* 코드 Structure */

string    gs_home_dir   = "C:\BNC_SMAT"     /* HOME DIR        */
string    gs_sessionid  = "ssn-id"          /* sessionID       */
string    gs_ip_addr    = '999.999.999.999' /* IP ADDRESS      */
string    gs_menu_id    = "W_SMAT100"       /* menuID          */
integer   gi_menu_pos   = 2                 /* 메뉴의 창위치   */
string    gs_brand      = 'N'               /* 브랜드          */
string    gs_brand_nm   = '브랜드명'        /* 브랜드명        */
string    gs_shop_cd    = 'N00000'          /* 부자재 업체코드       */
string    gs_shop_nm    = '내매장'          /* 부자재 명칭       */
string	 gs_shop_div	= 'X'					  /* 유통망			   */
Long      gl_user_level                     /* 사용자 등급     */
string    gs_user_grp                       /* 사용자 그룹     */
string    gs_user_id                        /* 사용자 id       */

string    gs_style									/* 품번 				*/
string    gs_chno										/* 차수				*/
string    gs_work_dt									/* 작업일자			*/
string    gs_work_gubn								/* 작업구분 		*/
String	 gs_country_cd								/* 원산지 코드		*/
String	 gs_country_nm								/* 원산지 코드		*/
end variables

global type bnc_smat from application
string appname = "bnc_cust"
integer highdpimode = 0
string appruntimeversion = "25.0.0.3726"
end type
global bnc_smat bnc_smat

type prototypes
FUNCTION ulong SetCapture(UINT hWnd )      LIBRARY "user32.dll"
FUNCTION ulong GetCapture( )               LIBRARY "user32.dll"
SUBROUTINE     ReleaseCapture ()           LIBRARY "user32.dll"
FUNCTION ulong CreateMutexA (ulong lpMutexAttributes, int bInitialOwner, ref string lpName) library "kernel32.dll" alias for "CreateMutexA;Ansi"
FUNCTION ulong GetLastError () library "kernel32.dll" 

//원모양 윈도우
Function long CreateEllipticRgn( long lX1, long lY1, long lX2, long lY2 ) Library "gdi32.dll" 
Function long SetWindowRgn( long lHandle, long lRgn, boolean bIsRedraw ) Library "user32.dll" 

//풍선도움말
function ulong addToolTipItem(ulong hWndTool, string text) library "PBSupports.dll" alias for "addToolTipItem;Ansi"
function ulong releaseToolTipItem(ulong hWndTool) library "PBSupports.dll"

end prototypes

on bnc_smat.create
appname="bnc_smat"
message=create message
sqlca=create u_n_tr
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on bnc_smat.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;gnv_app = CREATE n_cst_appmanager
gu_auto_koram = CREATE u_changekorea

///* 실행 모듈 생성시 해제 START */
///* Program 중복실행 체크 (실행 Program 생성시 필요) */
//ulong ll_mutex, ll_err
//string ls_mutex_name
//
//if handle (GetApplication (), false) <> 0 then
//   ls_mutex_name = this.AppName + char (0)
//   ll_mutex = CreateMutexA (0, 0, ls_mutex_name)
//   ll_err = GetLastError ()
//   if ll_err = 183 then    // 프로그램 실행중
//      MessageBox ("경고",  "보끄레 매장관리 시스템 이미 실행중 입니다.")     
//      halt close
//   end if
//end if
///* Program 중복실행 체크 END */
//IF commandline <> "" THEN 
//   // *** MAIN FRAME Window를 Open한다.
//   Open (w_main)
//END IF
///* 실행 모듈 생성시 해제 END */

/* 실행 모듈 생성시 REMARK START */
/* MAIN FRAME Window를 Open한다. */
Open (w_main01)
/* 실행 모듈 생성시 REMARK END */

end event

event close;DESTROY gnv_app
DESTROY gu_auto_koram
Disconnect;
end event

event systemerror;/*------------------------------------------------------------*/
/* Name          : Application; systemerror                   */
/* 내        용  : Application Run시의 RunTime Error Message  */
/*------------------------------------------------------------*/

// Open(w_0_0005)
return
end event

