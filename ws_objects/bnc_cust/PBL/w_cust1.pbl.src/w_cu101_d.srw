$PBExportHeader$w_cu101_d.srw
$PBExportComments$생산Order조회
forward
global type w_cu101_d from w_com010_d
end type
type dw_total from datawindow within w_cu101_d
end type
end forward

global type w_cu101_d from w_com010_d
integer width = 3653
integer height = 2236
dw_total dw_total
end type
global w_cu101_d w_cu101_d

type variables
String is_style, is_chno ,is_style_no
decimal id_ord_qty

end variables

on w_cu101_d.create
int iCurrent
call super::create
this.dw_total=create dw_total
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_total
end on

on w_cu101_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_total)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.02                                                  */	
/* 수정일      : 2002.05.02                                                  */
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


return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.02                                                  */	
/* 수정일      : 2002.05.02                                                  */
/*===========================================================================*/
datetime ld_datetime
string   ls_date
/* dw_head 필수입력 column check */

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_date =  string(ld_datetime , 'yyyymmdd')

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
il_rows = dw_total.retrieve(gs_shop_cd,gs_country_cd)
il_rows = dw_body.retrieve(gs_shop_cd,gs_country_cd)

This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_postopen();call super::pfc_postopen;This.Trigger Event ue_retrieve()
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_body, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_total, "FixedTotop&ScaleToRight")
inv_resize.of_Register(dw_total, "ScaleToRight&Top")
dw_head.SetTransObject(SQLCA)
dw_total.SetTransObject(SQLCA)

end event

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

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_shop_cd + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_cu101_d
end type

type cb_delete from w_com010_d`cb_delete within w_cu101_d
integer taborder = 60
end type

type cb_insert from w_com010_d`cb_insert within w_cu101_d
integer taborder = 50
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_cu101_d
boolean visible = false
integer taborder = 30
end type

type cb_update from w_com010_d`cb_update within w_cu101_d
end type

type cb_print from w_com010_d`cb_print within w_cu101_d
integer taborder = 70
boolean enabled = true
end type

type cb_preview from w_com010_d`cb_preview within w_cu101_d
integer taborder = 80
boolean enabled = true
end type

type gb_button from w_com010_d`gb_button within w_cu101_d
integer width = 3602
end type

type dw_head from w_com010_d`dw_head within w_cu101_d
boolean visible = false
integer x = 485
integer y = 600
integer width = 2016
integer height = 1188
integer taborder = 20
boolean titlebar = true
string title = "색상/사이즈별내역"
string dataobject = "d_cu100_d02"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event dw_head::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "cb_prt"	    
		  IF dw_head.RowCount() = 0 Then
   		  MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   	     il_rows = 0
        ELSE
           il_rows = dw_head.Print()
        END IF				

END CHOOSE


end event

type ln_1 from w_com010_d`ln_1 within w_cu101_d
boolean visible = false
integer beginy = 564
integer endy = 564
end type

type ln_2 from w_com010_d`ln_2 within w_cu101_d
boolean visible = false
integer beginy = 536
integer endy = 536
end type

type dw_body from w_com010_d`dw_body within w_cu101_d
integer y = 576
integer width = 3607
integer height = 1472
integer taborder = 40
string dataobject = "d_cu101_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::clicked;call super::clicked;   dw_head.reset()
   is_style_no =  dw_body.GetitemString(row,"style_no")	
	id_ord_qty  =  dw_body.GetitemDecimal(row,"ord_qty")
	
	
	IF is_style_no = "" OR isnull(is_style_no) THEN		
		return
	END IF
	is_style =  LeftA(is_style_no,8) 
	is_chno  =  RightA(is_style_no,1)

IF dw_head.RowCount() < 1 THEN 
	il_rows = dw_head.retrieve(is_style, is_chno)
END IF 

	dw_head.visible = True

end event

type dw_print from w_com010_d`dw_print within w_cu101_d
integer x = 727
integer y = 444
string dataobject = "d_cu101_r01"
end type

type dw_total from datawindow within w_cu101_d
integer y = 168
integer width = 3607
integer height = 400
integer taborder = 110
string title = "none"
string dataobject = "d_cu101_d03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

