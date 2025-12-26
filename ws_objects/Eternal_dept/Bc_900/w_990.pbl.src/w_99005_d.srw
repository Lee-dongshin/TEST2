$PBExportHeader$w_99005_d.srw
$PBExportComments$도서대여조회
forward
global type w_99005_d from w_com010_d
end type
type st_1 from statictext within w_99005_d
end type
type dw_detail from datawindow within w_99005_d
end type
type rb_1 from radiobutton within w_99005_d
end type
type rb_2 from radiobutton within w_99005_d
end type
type rb_3 from radiobutton within w_99005_d
end type
end forward

global type w_99005_d from w_com010_d
st_1 st_1
dw_detail dw_detail
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
end type
global w_99005_d w_99005_d

type variables
string is_frm_ymd, is_to_ymd
end variables

on w_99005_d.create
int iCurrent
call super::create
this.st_1=create st_1
this.dw_detail=create dw_detail
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
end on

on w_99005_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_detail)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
end on

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
//         cb_retrieve.Text = "조건(&Q)"
//         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
//   CASE 5    /* 조건 */
//      cb_retrieve.Text = "조회(&Q)"
//      cb_print.enabled = false
//      cb_preview.enabled = false
//      cb_excel.enabled = false
//      ib_changed = false
//      dw_body.Enabled = false
//      dw_head.Enabled = true
//      dw_head.SetFocus()
//      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if rb_3.checked = true then 
	il_rows = dw_body.retrieve(is_frm_ymd, is_to_ymd)
else	
	il_rows = dw_body.retrieve()
end if	
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

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

//dw_body.ShareData(dw_print)
dw_print.Retrieve()
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();call super::ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

//dw_body.ShareData(dw_print)
dw_print.Retrieve()
IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;dw_detail.SetTransObject(SQLCA)
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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

if rb_3.checked = true  then

is_frm_ymd = dw_head.GetItemString(1, "frm_ymd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if



end if

return true

end event

type cb_close from w_com010_d`cb_close within w_99005_d
end type

type cb_delete from w_com010_d`cb_delete within w_99005_d
end type

type cb_insert from w_com010_d`cb_insert within w_99005_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_99005_d
end type

type cb_update from w_com010_d`cb_update within w_99005_d
end type

type cb_print from w_com010_d`cb_print within w_99005_d
end type

type cb_preview from w_com010_d`cb_preview within w_99005_d
end type

type gb_button from w_com010_d`gb_button within w_99005_d
end type

type cb_excel from w_com010_d`cb_excel within w_99005_d
end type

type dw_head from w_com010_d`dw_head within w_99005_d
integer x = 1573
integer y = 176
integer width = 1554
integer height = 108
string dataobject = "d_99005_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_99005_d
integer beginy = 168
integer endy = 168
end type

type ln_2 from w_com010_d`ln_2 within w_99005_d
integer beginy = 172
integer endy = 172
end type

type dw_body from w_com010_d`dw_body within w_99005_d
integer y = 292
integer height = 1748
string dataobject = "d_99005_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::doubleclicked;call super::doubleclicked;string   ls_Person_id


dw_detail.reset()
ls_person_id  =  dw_body.GetitemString(row,"Person_id")

dw_detail.Retrieve(ls_person_id)

	IF ls_person_id = "" OR isnull(ls_person_id) THEN		
		return
	END IF

	
IF dw_detail.RowCount() < 1 THEN 
	il_rows = dw_detail.Retrieve(ls_person_id)
END IF 

	dw_detail.visible = True



end event

type dw_print from w_com010_d`dw_print within w_99005_d
integer x = 1943
integer y = 380
string dataobject = "d_99005_d01"
end type

type st_1 from statictext within w_99005_d
integer x = 55
integer y = 52
integer width = 1074
integer height = 76
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 80269524
string text = "직원 도서 대여 내역"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_detail from datawindow within w_99005_d
boolean visible = false
integer x = 96
integer y = 556
integer width = 3369
integer height = 1600
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "상세내역"
string dataobject = "d_99006_d01"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;dw_detail.Visible = false
end event

type rb_1 from radiobutton within w_99005_d
integer x = 73
integer y = 192
integer width = 325
integer height = 84
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 80269524
string text = "사번순"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
rb_2.TextColor     = 0
rb_3.TextColor     = 0

dw_body.DataObject  = 'd_99005_d01'
dw_print.DataObject = 'd_99005_d01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
//
//dw_body.SetSort("Person_id A")
//dw_print.SetSort("Person_id A")
dw_body.Retrieve()

end event

type rb_2 from radiobutton within w_99005_d
integer x = 485
integer y = 192
integer width = 338
integer height = 84
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 80269524
string text = "대여순"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_3.TextColor     = 0

dw_body.DataObject  = 'd_99005_d02'
dw_print.DataObject = 'd_99005_d02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


//dw_body.SetSort("grand_sum_book_cnt D") 
//dw_print.SetSort("grand_sum_book_cnt D") 
dw_body.Retrieve()


end event

type rb_3 from radiobutton within w_99005_d
integer x = 869
integer y = 204
integer width = 635
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 80269524
string text = "기간(반납일자기준)"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_2.TextColor     = 0

dw_body.DataObject  = 'd_99005_d03'
dw_print.DataObject = 'd_99005_d03'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
//
//dw_body.SetSort("Person_id A")
//dw_print.SetSort("Person_id A")

parent.Trigger Event ue_retrieve()
end event

