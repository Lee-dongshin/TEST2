$PBExportHeader$w_57003_d.srw
$PBExportComments$비상연락망(내선현황)
forward
global type w_57003_d from w_com010_d
end type
type st_1 from statictext within w_57003_d
end type
end forward

global type w_57003_d from w_com010_d
st_1 st_1
end type
global w_57003_d w_57003_d

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve()
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

event ue_preview();  
 
 /*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()


 dw_print.retrieve('%','1','%','2','%','3','1','2','3')
 
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()


dw_print.retrieve('%','1','%','2','%','3','1','2','3')
IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

on w_57003_d.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_57003_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify   = 	"t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_57003_d
end type

type cb_delete from w_com010_d`cb_delete within w_57003_d
end type

type cb_insert from w_com010_d`cb_insert within w_57003_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_57003_d
end type

type cb_update from w_com010_d`cb_update within w_57003_d
end type

type cb_print from w_com010_d`cb_print within w_57003_d
boolean enabled = true
end type

type cb_preview from w_com010_d`cb_preview within w_57003_d
boolean enabled = true
end type

type gb_button from w_com010_d`gb_button within w_57003_d
end type

type cb_excel from w_com010_d`cb_excel within w_57003_d
boolean enabled = true
end type

type dw_head from w_com010_d`dw_head within w_57003_d
boolean visible = false
end type

type ln_1 from w_com010_d`ln_1 within w_57003_d
end type

type ln_2 from w_com010_d`ln_2 within w_57003_d
end type

type dw_body from w_com010_d`dw_body within w_57003_d
string dataobject = "d_57003_d03"
end type

type dw_print from w_com010_d`dw_print within w_57003_d
string dataobject = "d_57003_d03"
end type

type st_1 from statictext within w_57003_d
integer x = 137
integer y = 248
integer width = 1705
integer height = 108
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = roman!
string facename = "바탕체"
long textcolor = 8388608
long backcolor = 67108864
string text = "직원 비상연락망(내선) 현황"
alignment alignment = center!
boolean focusrectangle = false
end type

