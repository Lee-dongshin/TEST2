$PBExportHeader$w_99001_d.srw
$PBExportComments$table list
forward
global type w_99001_d from w_com010_d
end type
type p_1 from picture within w_99001_d
end type
end forward

global type w_99001_d from w_com010_d
p_1 p_1
end type
global w_99001_d w_99001_d

on w_99001_d.create
int iCurrent
call super::create
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
end on

on w_99001_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_1)
end on

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 지우정보 ()                                             */	
/* 작성일      : 2000..                                                  */	
/* 수성일      : 2000..                                                  */
/*===========================================================================*/

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

type cb_close from w_com010_d`cb_close within w_99001_d
end type

type cb_delete from w_com010_d`cb_delete within w_99001_d
end type

type cb_insert from w_com010_d`cb_insert within w_99001_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_99001_d
end type

type cb_update from w_com010_d`cb_update within w_99001_d
end type

type cb_print from w_com010_d`cb_print within w_99001_d
end type

type cb_preview from w_com010_d`cb_preview within w_99001_d
end type

type gb_button from w_com010_d`gb_button within w_99001_d
end type

type cb_excel from w_com010_d`cb_excel within w_99001_d
end type

type dw_head from w_com010_d`dw_head within w_99001_d
boolean visible = false
end type

type ln_1 from w_com010_d`ln_1 within w_99001_d
boolean visible = false
end type

type ln_2 from w_com010_d`ln_2 within w_99001_d
boolean visible = false
end type

type dw_body from w_com010_d`dw_body within w_99001_d
integer y = 164
integer height = 1876
string dataobject = "d_99001_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;IF row < 1 THEN RETURN

gsv_cd.gs_cd1 = This.GetitemString(row, "table_id")
OpenWithParm(w_99001_s, "W_99001_S TABLE 정의서")
end event

type dw_print from w_com010_d`dw_print within w_99001_d
string dataobject = "d_99001_r01"
end type

type p_1 from picture within w_99001_d
integer x = 18
integer y = 76
integer width = 73
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "lemp.bmp"
boolean focusrectangle = false
end type

