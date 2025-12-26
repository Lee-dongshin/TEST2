$PBExportHeader$w_75011_d.srw
$PBExportComments$고객 코디스타일 제안
forward
global type w_75011_d from w_com020_d
end type
type p_1 from picture within w_75011_d
end type
type p_2 from picture within w_75011_d
end type
end forward

global type w_75011_d from w_com020_d
integer width = 3657
integer height = 2240
p_1 p_1
p_2 p_2
end type
global w_75011_d w_75011_d

type variables
long il_recency, il_frequency
string is_jumin, is_fr_yymmdd, is_to_yymmdd
end variables

on w_75011_d.create
int iCurrent
call super::create
this.p_1=create p_1
this.p_2=create p_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.p_2
end on

on w_75011_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_1)
destroy(this.p_2)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_75011_d","0")
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

//is_brand = dw_head.GetItemString(1, "brand")
//if IsNull(is_brand) or Trim(is_brand) = "" then
//   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//end if
//
il_recency   = dw_head.GetItemNumber(1, "recency")
il_frequency = dw_head.GetItemNumber(1, "frequency")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(il_recency, il_frequency)
dw_body.Reset()
IF il_rows > 0 THEN
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

IF gf_cdate(ld_datetime,-1)  THEN  
	is_fr_yymmdd = string(ld_datetime,"yyyymmdd")

end if

IF gf_cdate(ld_datetime,0)  THEN  
	is_to_yymmdd = string(ld_datetime,"yyyymmdd")

end if


end event

type cb_close from w_com020_d`cb_close within w_75011_d
end type

type cb_delete from w_com020_d`cb_delete within w_75011_d
end type

type cb_insert from w_com020_d`cb_insert within w_75011_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_75011_d
end type

type cb_update from w_com020_d`cb_update within w_75011_d
end type

type cb_print from w_com020_d`cb_print within w_75011_d
end type

type cb_preview from w_com020_d`cb_preview within w_75011_d
end type

type gb_button from w_com020_d`gb_button within w_75011_d
end type

type cb_excel from w_com020_d`cb_excel within w_75011_d
end type

type dw_head from w_com020_d`dw_head within w_75011_d
integer height = 116
string dataobject = "d_75011_h01"
end type

type ln_1 from w_com020_d`ln_1 within w_75011_d
integer beginy = 292
integer endy = 292
end type

type ln_2 from w_com020_d`ln_2 within w_75011_d
integer beginy = 296
integer endy = 296
end type

type dw_list from w_com020_d`dw_list within w_75011_d
integer x = 5
integer y = 312
integer width = 3022
integer height = 1736
string dataobject = "d_75011_d01"
end type

event dw_list::doubleclicked;call super::doubleclicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_jumin = This.GetItemString(row, 'jumin') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_jumin) THEN return
il_rows = dw_body.retrieve('', is_fr_yymmdd, is_to_yymmdd, 3, is_jumin)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_75011_d
integer x = 3045
integer y = 312
integer width = 1847
integer height = 1736
string dataobject = "d_75011_d02"
end type

event dw_body::constructor;/*===========================================================================*/
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

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

event dw_body::clicked;call super::clicked;string ls_style, ls_codi, ls_pic_dir1, ls_pic_dir2

if row > 0 then
	ls_style = this.getitemstring(row,"style")
	ls_codi  = this.getitemstring(row,"codi")
	
	if gf_pic_dir('0',ls_style ,ls_pic_dir1) <> 100 then	p_1.picturename = ls_pic_dir1
		
	if gf_pic_dir('0',ls_codi	,ls_pic_dir2) <> 100 then  p_2.picturename  = ls_pic_dir2
end if





end event

event dw_body::resize;call super::resize;p_1.x = this.x + 800
p_2.x = this.x + 800
end event

type st_1 from w_com020_d`st_1 within w_75011_d
integer x = 3026
integer y = 312
integer height = 1736
end type

type dw_print from w_com020_d`dw_print within w_75011_d
integer x = 23
integer y = 608
end type

type p_1 from picture within w_75011_d
integer x = 3831
integer y = 328
integer width = 983
integer height = 972
boolean bringtotop = true
boolean focusrectangle = false
end type

type p_2 from picture within w_75011_d
integer x = 3831
integer y = 1312
integer width = 983
integer height = 972
boolean bringtotop = true
boolean focusrectangle = false
end type

