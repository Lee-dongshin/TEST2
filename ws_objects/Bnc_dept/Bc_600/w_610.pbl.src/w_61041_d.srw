$PBExportHeader$w_61041_d.srw
$PBExportComments$미사용-직영(본사)매장판매현황
forward
global type w_61041_d from w_com010_d
end type
type cb_1 from commandbutton within w_61041_d
end type
type dw_99 from datawindow within w_61041_d
end type
type dw_body2 from datawindow within w_61041_d
end type
end forward

global type w_61041_d from w_com010_d
cb_1 cb_1
dw_99 dw_99
dw_body2 dw_body2
end type
global w_61041_d w_61041_d

type variables
String is_yymmdd, is_chk
end variables

forward prototypes
public subroutine wf_head_set ()
end prototypes

public subroutine wf_head_set ();Long   i, j, ll_row, ll_wk_cnt, ll_wk_cd, ll_pos 
String ls_modify, ls_modify2 

ll_row = dw_99.Retrieve(is_yymmdd)

dw_body.Setredraw(False)
dw_body.DataObject  = "d_61041_d01"
dw_body2.DataObject = "d_61041_d02"
dw_body.SetTransObject(SQLCA)
dw_body.ShareData(dw_body2)
dw_body.TriggerEvent(constructor!)
dw_body2.TriggerEvent(constructor!)

ls_modify = ""
FOR i = 1 TO ll_row 
    ls_modify = ls_modify + "sale_amt" + dw_99.object.wk_cnt[i] + "_" + dw_99.object.wk_cd[i] + "_t" + &
                ".text='" + dw_99.object.dd[i] + "' "
NEXT

dw_body.Modify(ls_modify)

ll_wk_cnt = Long(dw_99.object.wk_cnt[ll_row]) 
ll_wk_cd  = Long(dw_99.object.wk_cd[ll_row])

ls_modify = ""
FOR i = ll_wk_cnt + 1 TO 6 
	FOR j = 1 TO 7 
		ls_modify = ls_modify + "sale_amt" + String(i) + "_" + String(j) + ".visible='0' "
	NEXT
	ls_modify  = ls_modify  + "compute_" + String(i) + ".visible='0' "
	ls_modify2 = ls_modify2 + "compute_" + String(i) + ".visible='0' "
NEXT 

dw_body.Modify(ls_modify)
dw_body2.Modify(ls_modify2)

dw_body.Object.DataWindow.HorizontalScrollSplit  = 1070
dw_body2.Object.DataWindow.HorizontalScrollSplit = 1070
ll_pos = 1070 + (306 * ((ll_wk_cnt - 1) * 7 + ll_wk_cd - 1)) + (279 * (ll_wk_cnt - 1))
dw_body.Object.DataWindow.HorizontalScrollPosition2  = ll_pos
dw_body2.Object.DataWindow.HorizontalScrollPosition2 = 1070 + (279 * (ll_wk_cnt - 1))

dw_body.Setredraw(True)

end subroutine

on w_61041_d.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_99=create dw_99
this.dw_body2=create dw_body2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_99
this.Control[iCurrent+3]=this.dw_body2
end on

on w_61041_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_99)
destroy(this.dw_body2)
end on

event ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.09                                                  */	
/* 수정일      : 2002.05.09                                                  */
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

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

return true


end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.05.10                                                  */	
/* 수정일      : 2002.05.10                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

wf_head_set()

il_rows = dw_body.retrieve(is_yymmdd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
	cb_excel.Enabled = True
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
	cb_excel.Enabled = False
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
	cb_excel.Enabled = False
END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;is_chk = '1' 
dw_body.Object.DataWindow.HorizontalScrollSplit  = 1070
dw_body2.Object.DataWindow.HorizontalScrollSplit = 1070


end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(dw_body2, "ScaleToRight&Bottom")

dw_body.ShareData(dw_body2)
dw_99.SetTransObject(SQLCA)

end event

event pfc_close;call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61041_d","0")
end event

type cb_close from w_com010_d`cb_close within w_61041_d
integer taborder = 120
end type

type cb_delete from w_com010_d`cb_delete within w_61041_d
integer taborder = 60
end type

type cb_insert from w_com010_d`cb_insert within w_61041_d
integer taborder = 50
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61041_d
end type

type cb_update from w_com010_d`cb_update within w_61041_d
integer taborder = 100
end type

type cb_print from w_com010_d`cb_print within w_61041_d
boolean visible = false
integer taborder = 70
end type

type cb_preview from w_com010_d`cb_preview within w_61041_d
boolean visible = false
integer taborder = 80
end type

type gb_button from w_com010_d`gb_button within w_61041_d
end type

type cb_excel from w_com010_d`cb_excel within w_61041_d
integer taborder = 90
end type

type dw_head from w_com010_d`dw_head within w_61041_d
integer y = 164
integer height = 176
string dataobject = "d_61041_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_61041_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_61041_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_61041_d
integer x = 0
integer y = 376
integer width = 3611
integer height = 1672
integer taborder = 40
string dataobject = "d_61041_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.09                                                  */	
/* 수정일      : 2002.05.09                                                  */
/*===========================================================================*/

This.of_SetSort(False)







end event

event dw_body::scrollvertical;call super::scrollvertical;dw_body2.Object.DataWindow.VerticalScrollPosition = scrollpos


end event

type dw_print from w_com010_d`dw_print within w_61041_d
end type

type cb_1 from commandbutton within w_61041_d
integer x = 1586
integer y = 44
integer width = 347
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Compact"
end type

event clicked;
IF is_chk = '1' THEN 
	is_chk = '2'
	dw_body2.Visible = True
	dw_body.Visible  = False
ELSE
	is_chk = '1'
	dw_body.Visible  = True
	dw_body2.Visible = False
END IF

end event

type dw_99 from datawindow within w_61041_d
boolean visible = false
integer x = 2139
integer y = 284
integer width = 411
integer height = 432
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_61003_d99"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_body2 from datawindow within w_61041_d
boolean visible = false
integer y = 376
integer width = 3611
integer height = 1672
integer taborder = 30
string title = "none"
string dataobject = "d_61041_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

