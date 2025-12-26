$PBExportHeader$w_92006_d.srw
$PBExportComments$학점현황
forward
global type w_92006_d from w_com020_d
end type
type dw_1 from datawindow within w_92006_d
end type
end forward

global type w_92006_d from w_com020_d
integer width = 3639
integer height = 2260
dw_1 dw_1
end type
global w_92006_d w_92006_d

type variables
string is_fr_yymmdd, is_to_yymmdd, is_empno, is_dept_cd, is_trng_gubn, is_trng_select, is_trng_desc
string is_slip_bonji, is_dep_grp
DataWindowChild idw_slip_bonji, idw_dep_grp
end variables

on w_92006_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_92006_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")


/////////////////////////////////////////////////////////
/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)													  */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

/* Data window Resize */
inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
//inv_resize.of_Register(st_1, "ScaleToBottom")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


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



is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_empno = dw_head.GetItemString(1, "empno")
is_dept_cd = dw_head.GetItemString(1, "dept_cd")
is_trng_gubn = dw_head.GetItemString(1, "trng_gubn")
is_trng_select = dw_head.GetItemString(1, "trng_select")
is_trng_desc = dw_head.GetItemString(1, "trng_desc")
is_slip_bonji = dw_head.GetItemString(1, "slip_bonji")
is_dep_grp = dw_head.GetItemString(1, "dep_grp")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_fr_yymmdd, is_to_yymmdd, is_empno, is_dept_cd, is_trng_gubn, is_trng_select, is_trng_desc, is_slip_bonji, is_dep_grp)
dw_body.Reset()
IF il_rows > 0 THEN
	dw_1.retrieve(is_fr_yymmdd, is_to_yymmdd, is_empno, is_dept_cd, is_trng_gubn, is_trng_select, is_trng_desc)
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymmdd",LeftA(string(ld_datetime,"yyyymmdd"),6) + "01")
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if
end event

type cb_close from w_com020_d`cb_close within w_92006_d
end type

type cb_delete from w_com020_d`cb_delete within w_92006_d
end type

type cb_insert from w_com020_d`cb_insert within w_92006_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_92006_d
end type

type cb_update from w_com020_d`cb_update within w_92006_d
end type

type cb_print from w_com020_d`cb_print within w_92006_d
end type

type cb_preview from w_com020_d`cb_preview within w_92006_d
end type

type gb_button from w_com020_d`gb_button within w_92006_d
end type

type cb_excel from w_com020_d`cb_excel within w_92006_d
end type

type dw_head from w_com020_d`dw_head within w_92006_d
integer y = 164
integer height = 220
string dataobject = "d_92006_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("slip_bonji", idw_slip_bonji)
idw_slip_bonji.SetTransObject(SQLCA)
idw_slip_bonji.Retrieve("018")
idw_slip_bonji.InsertRow(1)
idw_slip_bonji.SetItem(1, "inter_cd", '%')
idw_slip_bonji.SetItem(1, "inter_nm", '전체')

This.GetChild("dept_grp", idw_dep_grp)
idw_dep_grp.SetTransObject(SQLCA)
idw_dep_grp.Retrieve("005")
idw_dep_grp.InsertRow(1)
idw_dep_grp.SetItem(1, "inter_cd", '%')
idw_dep_grp.SetItem(1, "inter_nm", '전체')
end event

type ln_1 from w_com020_d`ln_1 within w_92006_d
integer beginy = 388
integer endy = 388
end type

type ln_2 from w_com020_d`ln_2 within w_92006_d
integer beginy = 392
integer endy = 392
end type

type dw_list from w_com020_d`dw_list within w_92006_d
integer x = 0
integer y = 408
integer width = 3589
integer height = 1420
string dataobject = "d_92006_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_dept_cd = This.GetItemString(row, 'dept_code') /* DataWindow에 Key 항목을 가져온다 */
IF IsNull(is_dept_cd) THEN return
il_rows = dw_body.retrieve(is_fr_yymmdd, is_to_yymmdd, is_empno, is_dept_cd, is_trng_gubn, is_trng_select, is_trng_desc)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_92006_d
integer x = 0
integer y = 1840
integer width = 3593
integer height = 200
string dataobject = "d_92006_d02"
boolean hscrollbar = true
end type

type st_1 from w_com020_d`st_1 within w_92006_d
integer x = 1262
integer y = 732
integer width = 498
integer height = 48
end type

type dw_print from w_com020_d`dw_print within w_92006_d
integer x = 329
integer y = 948
end type

type dw_1 from datawindow within w_92006_d
integer x = 2194
integer y = 412
integer width = 1381
integer height = 1408
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "학점순위"
string dataobject = "d_92006_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

