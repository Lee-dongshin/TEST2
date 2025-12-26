$PBExportHeader$w_sm104_d.srw
$PBExportComments$비축부자재 조회
forward
global type w_sm104_d from w_com010_d
end type
type cb_excel from commandbutton within w_sm104_d
end type
end forward

global type w_sm104_d from w_com010_d
integer width = 3200
string title = "비축부자재현황"
cb_excel cb_excel
end type
global w_sm104_d w_sm104_d

type variables
string is_mat_cd, is_fr_yymmdd, is_to_yymmdd
end variables

on w_sm104_d.create
int iCurrent
call super::create
this.cb_excel=create cb_excel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_excel
end on

on w_sm104_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_excel)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                              */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

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

is_mat_cd = dw_head.GetItemString(1, "mat_cd")
is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                  */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(RightA(gs_user_id,4), is_fr_yymmdd, is_to_yymmdd, is_mat_cd,'%')
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

//--------------------------------------
IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

inv_resize.of_Register(cb_excel, "FixedToRight")

end event

type cb_close from w_com010_d`cb_close within w_sm104_d
end type

type cb_delete from w_com010_d`cb_delete within w_sm104_d
end type

type cb_insert from w_com010_d`cb_insert within w_sm104_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sm104_d
end type

type cb_update from w_com010_d`cb_update within w_sm104_d
end type

type cb_print from w_com010_d`cb_print within w_sm104_d
end type

type cb_preview from w_com010_d`cb_preview within w_sm104_d
end type

type gb_button from w_com010_d`gb_button within w_sm104_d
integer width = 3154
end type

type dw_head from w_com010_d`dw_head within w_sm104_d
integer width = 3131
integer height = 124
string dataobject = "d_sm104_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_sm104_d
integer beginy = 320
integer endx = 3145
integer endy = 320
end type

type ln_2 from w_com010_d`ln_2 within w_sm104_d
integer beginy = 324
integer endx = 3145
integer endy = 324
end type

type dw_body from w_com010_d`dw_body within w_sm104_d
integer y = 344
integer width = 3159
integer height = 1452
string dataobject = "d_sm104_d01"
end type

type dw_print from w_com010_d`dw_print within w_sm104_d
string dataobject = "d_sm104_r01"
end type

type cb_excel from commandbutton within w_sm104_d
integer x = 2885
integer y = 44
integer width = 256
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "엑셀"
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)
li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

