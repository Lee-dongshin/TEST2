$PBExportHeader$w_main00.srw
$PBExportComments$Main Window
forward
global type w_main00 from w_frame
end type
end forward

global type w_main00 from w_frame
integer x = 5
integer y = 4
integer width = 3657
integer height = 2400
string menuname = "m_0_0000"
windowstate windowstate = maximized!
boolean toolbarvisible = false
event ue_menu_open ( )
event ue_logon ( )
event ue_pgm_open ( )
event ue_report_open ( )
end type
global w_main00 w_main00

type prototypes
Function ulong GetCurrentDirectoryA (ulong textlen, ref string dirtext) library "KERNEL32.DLL" alias for "GetCurrentDirectoryA;Ansi"

end prototypes

event ue_logon();Window		lw_Sheet, lw_close[]
n_cst_logonattrib ls_logonattrib
integer     li_ret
String      ls_grp_nm

lw_Sheet = This.GetFirstSheet()
menu			lm_curr_menu


DO WHILE IsValid(lw_Sheet)
	IF lw_Sheet.ClassName() = "w_menu01" THEN
      lw_Sheet = This.GetNextSheet(lw_Sheet)
		CONTINUE
   END IF
	li_ret = MessageBox("확인", lw_Sheet.Title + &
	                            "을(를) 종료하시겠습니까?", Question!, YesNo!)
   IF li_ret = 1 THEN										 
	   Close(lw_Sheet)
      lw_Sheet = This.GetFirstSheet()
	ELSE
		RETURN
	END IF
LOOP

Open (w_log)
ls_logonattrib = Message.PowerObjectParm

IF (ls_logonattrib.ii_rc <> 1) THEN
   Post Close(This)
ELSE
//	GF_BRANCH_NM(gs_branch_cd, gs_branch_nm)
	IF ISNULL(gs_dept_nm) THEN
      inv_statusbar.of_Modify('gs_dept_nm', gs_dept_cd)
	ELSE
      inv_statusbar.of_Modify('gs_dept_nm',  gs_dept_nm)
   END IF

   inv_statusbar.of_Modify('gs_user_nm',   gs_user_nm)
   This.TriggerEvent("ue_menu_open")
END IF

end event

event ue_pgm_open();
OpenSheet(w_mat_d01, this, gi_menu_pos, Original! ) 

end event

event ue_report_open();
//OpenSheet(w_mat_d01, this, gi_menu_pos, Original! ) 

end event

on w_main00.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_0_0000" then this.MenuID = create m_0_0000
end on

on w_main00.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_preopen();ulong		lul_Rc, lul_size = 260 	/* MAX_PATH */
String   ls_home_dir		
integer	li_rc
boolean  lb_db_status = True

//if (isNull(SQLCA.DBHandle()) or SQLCA.DBHandle() = 0) then
//	if gf_connect_dbms(SQLCA) = FALSE then
//		lb_db_Status = False
//		This.Post Event Pfc_Close()
//	end if
//end if

ls_home_dir = Space (lul_size)
lul_rc = GetCurrentDirectoryA (lul_size, ls_home_dir)

If lul_rc < 1 Then
	ls_home_dir = "C:\BEAUCRE_SYS"
End If

if RightA(ls_home_dir, 1) = '\' then
   gs_home_dir = LeftA(ls_home_dir, LenA(ls_home_dir) - 1)
else
   gs_home_dir = ls_home_dir
end if

if lb_db_Status Then
   // MS SQL session-id를 읽어온다.
   gf_get_session(gs_sessionid)
   This.Title = '보끄레/이터널 원자재 시스템' + " [ " + gs_home_dir + " ] "
   li_rc = of_SetStatusBar(true)
   This.SetMicroHelp("작업을 선택하십시오! ")
   li_rc = inv_statusbar.of_Register('gs_dept_nm', 'text', gs_dept_nm, 300)
   li_rc = inv_statusbar.of_Register('gs_user_nm', 'text', gs_user_nm, 300)
   li_rc = inv_statusbar.of_Register('Session_id', 'text', ' Sid [' + gs_sessionid +']', 300)
   li_rc = inv_statusbar.of_SetTimerFormat('yyyy/mm/dd hh:mm:ss')
   li_rc = inv_statusbar.of_SetTimerWidth(480)
   li_rc = inv_statusbar.of_SetTimer(True)
end if


end event

event pfc_postopen;call super::pfc_postopen;This.TriggerEvent("ue_logon")

end event

