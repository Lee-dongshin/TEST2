$PBExportHeader$w_main01.srw
$PBExportComments$Main Window[EIS]
forward
global type w_main01 from w_frame
end type
end forward

global type w_main01 from w_frame
integer x = 5
integer y = 4
integer width = 3657
integer height = 2400
string menuname = "m_0_0000"
windowstate windowstate = maximized!
boolean toolbarvisible = false
event ue_menu_open ( )
event ue_logon ( )
event ue_board_open ( )
end type
global w_main01 w_main01

type prototypes
Function ulong GetCurrentDirectoryA (ulong textlen, ref string dirtext) library "KERNEL32.DLL" alias for "GetCurrentDirectoryA;Ansi"

end prototypes

event ue_menu_open();/*------------------------------------------------------------*/
/* 내        용  : 메뉴탐색 WINDOW를 Open한다.(W_MAIN01)      */
/*------------------------------------------------------------*/

/* Open Window for Menu Explorer */
//Close(W_EIS)
OpenSheet(W_EIS, This, gi_menu_pos, Original!) 

end event

on w_main01.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_0_0000" then this.MenuID = create m_0_0000
end on

on w_main01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_preopen();ulong		lul_Rc, lul_size = 260 	/* MAX_PATH */
String   ls_home_dir		
integer	li_rc
boolean  lb_db_status = True
STRING ls_filename, LS_STRING
uint rtn, wstyle
long li_filenum

if (isNull(SQLCA.DBHandle()) or SQLCA.DBHandle() = 0) then
	if gf_connect_dbms(SQLCA) = FALSE then
		lb_db_Status = False
		This.Post Event Pfc_Close()
	end if
end if

ls_home_dir = Space (lul_size)
lul_rc = GetCurrentDirectoryA (lul_size, ls_home_dir)

If lul_rc < 1 Then
	ls_home_dir = "C:\eternal_DEPT"
End If

if RightA(ls_home_dir, 1) = '\' then
   gs_home_dir = LeftA(ls_home_dir, LenA(ls_home_dir) - 1)
else
   gs_home_dir = ls_home_dir
end if

if lb_db_Status Then
   // MS SQL session-id를 읽어온다.
   gf_get_session(gs_sessionid)
   This.Title = '이터널그룹/뷰티 시스템' + " [ " + gs_home_dir + " ] "
   li_rc = of_SetStatusBar(true)
   This.SetMicroHelp("작업을 선택하십시오! ")
   li_rc = inv_statusbar.of_Register('Session_id', 'text', ' Sid [' + gs_sessionid +']', 300)
   li_rc = inv_statusbar.of_SetTimerFormat('yyyy/mm/dd hh:mm:ss')
   li_rc = inv_statusbar.of_SetTimerWidth(480)
   li_rc = inv_statusbar.of_SetTimer(True)
end if

menu			lm_curr_menu
lm_curr_menu = this.menuid
lm_curr_menu.item[2].enabled = False
lm_curr_menu.item[3].enabled = False




ls_filename = "c:\eternal_dept\rename.bat"
ls_string = 'net use \\220.118.68.4\photo otohpcnb /user:bnc_photo'  

wstyle = 0		

li_FileNum = FileOpen(ls_filename, streamMode!, Write!, Shared!, Replace!)
FileWrite(li_FileNum, ls_string)	
FileClose(li_FileNum)
rtn = WinExec(ls_filename, wstyle)		

//ls_string = ' ' 	
//li_FileNum = FileOpen(ls_filename, streamMode!, Write!, Shared!, Replace!)
//FileWrite(li_FileNum, ls_string)	
//FileClose(li_FileNum)
end event

event pfc_postopen();call super::pfc_postopen;gs_user_id    = "BNCEIS"
gl_user_level = 999
This.TriggerEvent("ue_menu_open")

end event

