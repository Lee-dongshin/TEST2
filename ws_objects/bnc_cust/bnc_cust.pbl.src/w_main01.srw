$PBExportHeader$w_main01.srw
$PBExportComments$Main Window
forward
global type w_main01 from w_frame
end type
type st_1 from statictext within w_main01
end type
type shl_1 from statichyperlink within w_main01
end type
type p_email from picture within w_main01
end type
type dw_menu from uo_menubar within w_main01
end type
type gb_1 from groupbox within w_main01
end type
end forward

global type w_main01 from w_frame
integer x = 5
integer y = 4
integer width = 3657
integer height = 2288
string menuname = "m_0_0000"
windowstate windowstate = maximized!
long backcolor = 80269528
boolean toolbarvisible = false
event ue_menu_open ( )
event ue_logon ( )
event ue_board_open ( )
event ue_insert ( )
event ue_update ( )
event ue_delete ( )
event ue_first_open ( )
event ue_test_shop ( )
st_1 st_1
shl_1 shl_1
p_email p_email
dw_menu dw_menu
gb_1 gb_1
end type
global w_main01 w_main01

type prototypes
Function ulong GetCurrentDirectoryA (ulong textlen, ref string dirtext) library "KERNEL32.DLL" alias for "GetCurrentDirectoryA;Ansi"

end prototypes

type variables
n_cst_platformwin32 iuo_platformwin32
String              is_mail_pgm, is_country_nm

end variables

event ue_logon();Window		lw_Sheet, lw_close[]
n_cst_logonattrib ls_logonattrib
integer     li_ret
String      ls_grp_nm


lw_Sheet = This.GetFirstSheet()
menu			lm_curr_menu

DO WHILE IsValid(lw_Sheet)
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
	GF_INTER_NM('001', gs_brand, gs_brand_nm)
   This.Title = '보끄레 협력업체 시스템' + " [ " + gs_brand_nm + " ] " + gs_shop_nm + " [ " + gs_country_nm + " ] "
	dw_menu.of_SetTrans()
   dw_menu.of_outlookbar(1)
   dw_menu.Retrieve("W_CUST100")
   This.PostEvent("ue_first_open")
END IF
	
end event

event ue_insert;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2001.11.27                                                  */	
/* 수성일      : 2001.11.27                                                  */
/*===========================================================================*/
n_cst_parms       lnv_Parm

SetPointer(HourGlass!)

lnv_Parm.iw_Parent   = this 
lnv_Parm.is_select   = 'I' 
lnv_Parm.is_winid    = ''
lnv_Parm.ii_OpenPos  = gi_menu_pos
lnv_Parm.is_parentid = gs_menu_id

OpenWithParm(W_MENU02, lnv_Parm)
n_cst_parms   lnv_Parm1
lnv_Parm1 = Message.PowerObjectParm

dw_menu.Retrieve(gs_menu_id)

SetPointer(Arrow!)

end event

event ue_update;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2001.11.27                                                  */	
/* 수성일      : 2001.11.27                                                  */
/*===========================================================================*/
n_cst_parms       lnv_Parm
Long              ll_row

ll_row = dw_menu.GetRow()

If ll_row < 1 Then Return

SetPointer(HourGlass!) 

lnv_Parm.iw_Parent   = this
lnv_Parm.is_select   = 'U' 
lnv_Parm.ii_OpenPos  = gi_menu_pos
lnv_Parm.is_parentid = gs_menu_id
lnv_Parm.is_winid    = dw_menu.GetitemString(ll_row, "pgm_id")
OpenWithParm(w_menu02, lnv_Parm)

n_cst_parms      lnv_Parm1
lnv_Parm1 = Message.PowerObjectParm

dw_menu.Retrieve(gs_menu_id)

SetPointer(Arrow!)

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2001.11.27                                                  */	
/* 수성일      : 2001.11.27                                                  */
/*===========================================================================*/
Long        ll_row 
String      ls_PgmID, ls_PgmNM

ll_row = dw_menu.GetRow()
If ll_row < 1 Then Return

SetPointer(HourGlass!)

ls_PgmID = dw_menu.GetitemString(ll_row, "pgm_id")
ls_PgmNM = dw_menu.GetitemString(ll_row, "pgm_nm")

IF MessageBox("메뉴삭제", ls_PgmNm + "을 메뉴에서 삭제하시겠습니까?",  &
						        Question!, YesNo!) = 2 THEN RETURN 

DELETE FROM tb_93030_h 
	WHERE tb_93030_h.Menu_id = :gs_menu_id
	  AND tb_93030_h.pgm_id  = :ls_PgmID;

IF SQLCA.SQLCODE <> 0 THEN
	MessageBox("오류1", SQLCA.SQLErrText)
	ROLLBACK;
	RETURN
END IF

DELETE FROM tb_93020_m 
 WHERE tb_93020_m.pgm_id  = :ls_PgmID;

IF SQLCA.SQLCODE <> 0 THEN
	MessageBox("오류2", SQLCA.SQLErrText)
	ROLLBACK;
	RETURN
ELSE
	COMMIT;
END IF

dw_menu.Retrieve(gs_menu_id)

SetPointer(Arrow!)

end event

event ue_first_open();/*------------------------------------------------------------*/
/* 내        용  : 기본 WINDOW를 Open한다.(판매w_sh101_e)     */
/*------------------------------------------------------------*/
Window lw_window

lw_window = This
gf_open_sheet(lw_window, 'W_CU100_E', '생산진도관리')


end event

event ue_test_shop();String ls_Parm

OPen(w_test_shop)
ls_Parm = Message.StringParm
IF ls_Parm = 'OK' Then 
	This.Title = '보끄레 협력업체 시스템' + " [ " + gs_brand_nm + " ] " + gs_shop_nm + " [ " + gs_country_nm + " ] "
	
END IF

end event

on w_main01.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_0_0000" then this.MenuID = create m_0_0000
this.st_1=create st_1
this.shl_1=create shl_1
this.p_email=create p_email
this.dw_menu=create dw_menu
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.shl_1
this.Control[iCurrent+3]=this.p_email
this.Control[iCurrent+4]=this.dw_menu
this.Control[iCurrent+5]=this.gb_1
end on

on w_main01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.shl_1)
destroy(this.p_email)
destroy(this.dw_menu)
destroy(this.gb_1)
end on

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
ulong		lul_Rc, lul_size = 260 	/* MAX_PATH */
String   ls_home_dir		
integer	li_rc
boolean  lb_db_status = True
environment env
double ldb_size_X, ldb_size_Y



//if (isNull(SQLCA.DBHandle()) or SQLCA.DBHandle() = 0) then
//	if gf_connect_dbms(SQLCA) = FALSE then
//		lb_db_Status = False
//		This.Post Event Pfc_Close()
//	end if
//end if
//
//If GetEnvironment(env) <> 1 Then return

//If env.screenwidth  = 1024 Then return
//If env.screenheight = 768 Then return
//
//ldb_size_X =  env.screenwidth / 1024
//ldb_size_Y =  env.screenheight / 768
//
//// 윈도우의 위치 변경
//If This.windowstate = normal! Then
//   This.x = ((This.Width * ldb_size_X) - This.Width) / 2
//   This.y = ((This.Height * ldb_size_Y) - This.Height) / 2
//End If 
////
ls_home_dir = Space (lul_size)
lul_rc = GetCurrentDirectoryA (lul_size, ls_home_dir)

If lul_rc < 1 Then
	ls_home_dir = "C:\BNC_CUST"
End If

if RightA(ls_home_dir, 1) = '\' then
   gs_home_dir = LeftA(ls_home_dir, LenA(ls_home_dir) - 1)
else
   gs_home_dir = ls_home_dir
end if


if  gs_country_cd = '00'  then
	 is_country_nm = '한국' 
elseif gs_country_cd = '06' then
	 is_country_nm = '중국'
end if 

if lb_db_Status Then
   // MS SQL session-id를 읽어온다.
   gf_get_session(gs_sessionid)
   This.Title = '보끄레 협력업체 시스템' + " [ " + gs_brand_nm + " ] " + gs_shop_nm + " [ " + gs_country_nm + " ] "
   li_rc = of_SetStatusBar(true)
   This.SetMicroHelp("작업을 선택하십시오! ")
   li_rc = inv_statusbar.of_Register('id_addr', 'text', gs_ip_addr, 400)
   li_rc = inv_statusbar.of_Register('Session_id', 'text', ' Sid [' + gs_sessionid +']', 300)
   li_rc = inv_statusbar.of_SetTimerFormat('yyyy/mm/dd hh:mm:ss')
   li_rc = inv_statusbar.of_SetTimerWidth(480)
   li_rc = inv_statusbar.of_SetTimer(True)
end if

end event

event pfc_postopen;call super::pfc_postopen;This.TriggerEvent("ue_logon")


end event

event resize;call super::resize;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/

This.mdi_1.resize(newwidth  - 670, newheight - 70)
This.arrangesheets(Layer!)
dw_menu.move(newwidth  - 670, 0)
dw_menu.resize( 670, newheight - 550)
p_email.move(newwidth  - 650, newheight - 510)
st_1.move(newwidth  - 300, newheight - 410)
gb_1.move(newwidth  - 670, newheight - 550)
shl_1.move(newwidth  - 600, newheight - 150)

end event

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
datetime ld_datetime
string	ls_mm



IF isvalid(iuo_platformwin32) = FALSE THEN 
	iuo_platformwin32 = create n_cst_platformwin32 
END IF

/* 시스템 날짜를 가져온다 */
//IF gf_sysdate(ld_datetime) = FALSE THEN
//	Return 0
//END IF

ls_mm = String(now(),"MM") //String(ld_datetime,"MM")
//ls_mm = "01"

IF ls_mm < "04" THEN
	dw_menu.Modify("p_1.FileName='1.gif'")
	dw_menu.Modify("DataWindow.Color=764542")
ELSEIF ls_mm < "08" THEN
	dw_menu.Modify("p_1.FileName='2.gif'")
	dw_menu.Modify("DataWindow.Color=12655360")
ELSE
	dw_menu.Modify("p_1.FileName='3.gif'")
	dw_menu.Modify("DataWindow.Color=22222")
END IF

timer(60)
end event

event timer;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.05.20 (김 태범)                                        */
/*===========================================================================*/
datetime ld_datetime
string	ls_yymmdd

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_yymmdd = String(ld_datetime,"YYYYMMDD")

SELECT dbo.sf_cust_mail_chk(:gs_shop_cd)
  INTO :is_mail_pgm
  FROM DUAL ;
  
IF isnull(is_mail_pgm) OR Trim(is_mail_pgm) = "" THEN
	p_email.PictureName = 'email-off.gif'
ELSE
   iuo_platformwin32.of_playsound ("C:\Bnc_CUST\bmp\mail.wav")
	p_email.PictureName = 'email-on.gif'
	
	if is_mail_pgm = "W_107_D" then
		st_1.text = "R/T"
	elseif is_mail_pgm = "W_SH117_E" then	
		st_1.text = "완불!"
	else
		st_1.text = "편지!"		
	end if
END IF

end event

event close;call super::close;IF isvalid(iuo_platformwin32) THEN 
   DESTROY iuo_platformwin32
END IF
end event

type st_1 from statictext within w_main01
integer x = 3342
integer y = 1756
integer width = 261
integer height = 116
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 80269524
alignment alignment = center!
boolean focusrectangle = false
end type

type shl_1 from statichyperlink within w_main01
integer x = 3049
integer y = 2040
integer width = 507
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 80269528
string text = "www.ibeaucre.co.kr"
boolean focusrectangle = false
string url = "www.ibeaucre.co.kr"
end type

type p_email from picture within w_main01
integer x = 2999
integer y = 1724
integer width = 320
integer height = 280
boolean originalsize = true
string picturename = "email-off.gif"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.05.20  (김 태범)                                       */
/*===========================================================================*/

String ls_win_id, ls_win_nm, ls_pgm_stat
Window lw_window
Long   ll_Top 

IF isnull(is_mail_pgm) or Trim(is_mail_pgm) = "" THEN 
   ls_win_id = "W_cu303_E" 
ELSE
   ls_win_id = is_mail_pgm
END IF

SELECT pgm_nm,     pgm_stat 
  INTO :ls_win_nm, :ls_pgm_stat  
  FROM TB_93020_M 
 WHERE PGM_ID = :ls_win_id;

IF gl_user_level = 999 OR ls_pgm_stat = 'B' THEN 
	p_email.PictureName = 'email-off.gif'
	st_1.text = ""
   lw_window = Parent
   gf_open_sheet(lw_window, ls_win_id, ls_win_nm) 
END IF

end event

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/
addToolTipItem(handle(this), "☞ 메시지를 조회합니다!!!")
end event

type dw_menu from uo_menubar within w_main01
integer x = 2949
integer width = 672
integer height = 1692
integer taborder = 10
boolean vscrollbar = true
end type

event rbuttondown;call super::rbuttondown;/*===========================================================================*/
/* 작성자      : 지우정보(김 태범)														  */	
/* 작성일      : 2001.11.27																  */	
/* Description : 오른쪽 마우스 Popup Menu                                    */
/*===========================================================================*/
string	ls_parentid, ls_WinID

window		lw_parent
m_3_0000    lm_view

if not IsValid (lm_view) then
	lm_view = create m_3_0000
end if

/* 등급이 999만 메뉴 등록, 수정, 삭제가 가능함 */
if gl_user_level <> 999 then return 1

lw_parent = Parent

lm_view.m_viewitem.PopMenu (lw_parent.PointerX(), lw_parent.PointerY())

If IsValid(lm_View) Then Destroy lm_View

return 1


end event

type gb_1 from groupbox within w_main01
integer x = 2949
integer y = 1680
integer width = 672
integer height = 344
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711935
long backcolor = 80269528
end type

