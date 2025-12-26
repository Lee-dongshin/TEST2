$PBExportHeader$w_81111_e.srw
$PBExportComments$1차평가집계표
forward
global type w_81111_e from w_com010_e
end type
type dw_1 from datawindow within w_81111_e
end type
type cbx_1 from checkbox within w_81111_e
end type
end forward

global type w_81111_e from w_com010_e
dw_1 dw_1
cbx_1 cbx_1
end type
global w_81111_e w_81111_e

type variables
string  is_yyyy, is_empno
datawindowchild idw_stat
end variables

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_title

IF as_cb_div = '1' THEN
	ls_title = "조회오류"
ELSEIF as_cb_div = '2' THEN
	ls_title = "추가오류"
ELSEIF as_cb_div = '3' THEN
	ls_title = "저장오류"
ELSE
	ls_title = "오류"
END IF

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

is_empno = dw_head.GetItemString(1, "empno")
if IsNull(is_empno) or Trim(is_empno) = "" then
   MessageBox(ls_title,"사번을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("empno")
   return false
end if



return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yyyy, is_empno)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF
il_rows = dw_1.retrieve(is_yyyy, is_empno)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;dw_head.setitem(1,"empno",gs_user_id)
dw_head.setitem(1,"kname",gs_user_nm)

is_yyyy = dw_head.getitemstring(1,"yyyy")
end event

on w_81111_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cbx_1
end on

on w_81111_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cbx_1)
end on

event type long ue_update();call super::ue_update;int  id_cnt

 if cbx_1.checked  then  
	
  

	id_cnt = dw_body.find("status < 'A' ", 1, dw_body.rowCount() ) 

	
	
	if id_cnt > 0 then 
		messagebox('확인', '평가 미완료된 직원이 있습니다 !!') 
		return -1
	end if
	
	update a set status = 'B'
	from    tb_81101_m a
	where   yyyy = :is_yyyy
	and     first_staff = :is_empno
	and     isnull(status,'') = 'A'; 
	
	 commit  USING SQLCA;
	
else
	messagebox('확인', '제출하기 클릭 후 저장하십시오 !!') 
	RETURN -1
end if
	
	messagebox('확인', '저장되었습니다 !!') 
	
return 0
 
end event

type cb_close from w_com010_e`cb_close within w_81111_e
end type

type cb_delete from w_com010_e`cb_delete within w_81111_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_81111_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_81111_e
end type

type cb_update from w_com010_e`cb_update within w_81111_e
end type

type cb_print from w_com010_e`cb_print within w_81111_e
end type

type cb_preview from w_com010_e`cb_preview within w_81111_e
end type

type gb_button from w_com010_e`gb_button within w_81111_e
end type

type cb_excel from w_com010_e`cb_excel within w_81111_e
end type

type dw_head from w_com010_e`dw_head within w_81111_e
integer width = 1760
string dataobject = "d_81111_h01"
end type

type ln_1 from w_com010_e`ln_1 within w_81111_e
end type

type ln_2 from w_com010_e`ln_2 within w_81111_e
end type

type dw_body from w_com010_e`dw_body within w_81111_e
integer height = 1580
string dataobject = "d_81111_d01"
end type

event dw_body::constructor;call super::constructor;This.GetChild("status", idw_stat)
idw_stat.SetTransObject(SQLCA)
idw_stat.Retrieve('815')

end event

type dw_print from w_com010_e`dw_print within w_81111_e
string dataobject = "d_81111_d01"
end type

event dw_print::constructor;call super::constructor;This.GetChild("status", idw_stat)
idw_stat.SetTransObject(SQLCA)
idw_stat.Retrieve('815')
end event

type dw_1 from datawindow within w_81111_e
integer x = 91
integer y = 888
integer width = 1431
integer height = 1084
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "1차평가 구성율표"
string dataobject = "d_81112_d01"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_81111_e
integer x = 3095
integer y = 344
integer width = 375
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16777215
long backcolor = 16711935
string text = "제출하기"
borderstyle borderstyle = stylelowered!
end type

event clicked;cb_update.enabled = true
end event

