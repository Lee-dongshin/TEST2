$PBExportHeader$w_61000_d.srw
$PBExportComments$전브랜드판매실적
forward
global type w_61000_d from w_com020_d
end type
type st_2 from statictext within w_61000_d
end type
end forward

global type w_61000_d from w_com020_d
integer width = 3675
integer height = 2276
st_2 st_2
end type
global w_61000_d w_61000_d

type variables
string  is_yymm, is_sale_div
datawindowchild  idw_sale_div
end variables

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


/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(st_1, "ScaleToBottom")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

on w_61000_d.create
int iCurrent
call super::create
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
end on

on w_61000_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
end on

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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_sale_div = dw_head.GetItemString(1, "sale_div")
if IsNull(is_sale_div) or Trim(is_sale_div) = "" then
   MessageBox(ls_title,"판매구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_div")
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

il_rows = dw_list.retrieve(is_yymm, is_sale_div)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF
il_rows = dw_body.retrieve(is_yymm, is_sale_div)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_72007_d","0")
end event

event ue_preview;
This.Trigger Event ue_title ()

il_rows = dw_print.retrieve(is_yymm, is_sale_div)

dw_print.inv_printpreview.of_SetZoom()
end event

event ue_title;call super::ue_title;/*===========================================================================*/
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
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_yymm.text = is_yymm
dw_print.object.t_sale_div.text = idw_sale_div.getitemstring(idw_sale_div.getrow(),"inter_nm")


end event

type cb_close from w_com020_d`cb_close within w_61000_d
end type

type cb_delete from w_com020_d`cb_delete within w_61000_d
end type

type cb_insert from w_com020_d`cb_insert within w_61000_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_61000_d
end type

type cb_update from w_com020_d`cb_update within w_61000_d
end type

type cb_print from w_com020_d`cb_print within w_61000_d
end type

type cb_preview from w_com020_d`cb_preview within w_61000_d
end type

type gb_button from w_com020_d`gb_button within w_61000_d
end type

type cb_excel from w_com020_d`cb_excel within w_61000_d
end type

type dw_head from w_com020_d`dw_head within w_61000_d
integer y = 156
integer width = 1925
integer height = 72
string dataobject = "d_61000_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/


This.GetChild("sale_div", idw_sale_div )
idw_sale_div.SetTransObject(SQLCA)
idw_sale_div.Retrieve('009')

idw_sale_div.InsertRow(1)
idw_sale_div.SetItem(1,'inter_cd','0')
idw_sale_div.SetItem(1,'inter_nm','기타제외')


idw_sale_div.InsertRow(1)
idw_sale_div.SetItem(1,'inter_cd','%')
idw_sale_div.SetItem(1,'inter_nm','전체')


end event

type ln_1 from w_com020_d`ln_1 within w_61000_d
integer beginy = 252
integer endy = 252
end type

type ln_2 from w_com020_d`ln_2 within w_61000_d
integer beginy = 240
integer endy = 240
end type

type dw_list from w_com020_d`dw_list within w_61000_d
integer y = 268
integer width = 3561
integer height = 1180
string dataobject = "d_61000_d03"
boolean hscrollbar = true
boolean hsplitscroll = true
boolean livescroll = false
end type

event dw_list::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

end event

type dw_body from w_com020_d`dw_body within w_61000_d
integer x = 27
integer y = 1456
integer width = 3566
integer height = 580
string dataobject = "d_61000_d04"
boolean hscrollbar = true
boolean hsplitscroll = true
boolean livescroll = false
end type

type st_1 from w_com020_d`st_1 within w_61000_d
boolean visible = false
integer x = 750
integer width = 55
boolean enabled = false
end type

type dw_print from w_com020_d`dw_print within w_61000_d
string dataobject = "d_61000_r01"
end type

type st_2 from statictext within w_61000_d
integer x = 2057
integer y = 184
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "[단위:백만원]"
boolean focusrectangle = false
end type

