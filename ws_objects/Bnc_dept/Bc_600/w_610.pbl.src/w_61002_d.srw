$PBExportHeader$w_61002_d.srw
$PBExportComments$월별매출현황
forward
global type w_61002_d from w_com010_d
end type
type dw_1 from u_dw within w_61002_d
end type
type dw_2 from datawindow within w_61002_d
end type
type dw_3 from u_dw within w_61002_d
end type
end forward

global type w_61002_d from w_com010_d
integer width = 3680
integer height = 2264
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
end type
global w_61002_d w_61002_d

type variables
/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
String 				is_brand,is_year,is_plan_year,is_season,is_sale_div, is_shopping_yn
DataWindowChild	idw_brand,idw_plan_year,idw_season,idw_sale_div
end variables

on w_61002_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_3
end on

on w_61002_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
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

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) OR is_year = "" then
   MessageBox(ls_title,"조회일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_plan_year = dw_head.GetItemString(1, "plan_year")
//if IsNull(is_plan_year) OR is_plan_year = "" then
//   MessageBox(ls_title,"기획년도를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("plan_year")
//   return false
//end if
//
is_brand		= dw_head.GetItemString(1, "brand")
is_season	= dw_head.GetItemString(1, "season")
is_sale_div	= dw_head.GetItemString(1, "sale_div")
is_shopping_yn	= dw_head.GetItemString(1, "shopping_yn")




if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand,is_year,is_plan_year,is_season,is_sale_div,is_shopping_yn)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

dw_1.retrieve(is_brand,is_year,is_plan_year,is_season,is_sale_div,is_shopping_yn)
dw_3.visible = false

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "year", String(ld_datetime,'yyyy'))
dw_head.SetItem(1, "plan_year", '%')
dw_head.SetItem(1, "season", '%')
end event

event pfc_preopen;call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)

inv_resize.of_Register(dw_1, "FixedToBottom&ScaleToRight")
inv_resize.of_Register(dw_3, "FixedToBottom&ScaleToRight")
end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy-mm-dd hh:mm:ss")


ls_modify =	 " t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
			    " t_year.Text     = '" + dw_head.GetitemString(1, "plan_year") + "'" + &		
			    " t_season.Text   = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &									  
			    " t_sale_div.Text = '" + idw_sale_div.GetItemString(idw_sale_div.GetRow(), "inter_display") + "'"+ &					 				  
				 " t_pg_id.Text    = '" + is_pgm_id + "'" + &
             " t_user_id.Text  = '" + gs_user_id + "'" + &
             " t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
CHOOSE CASE as_column
	CASE "graph"
			dw_2.Visible = True
			/* dw_head 필수입력 column check */
			IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN 0
			dw_2.retrieve(is_brand,is_year,is_plan_year,is_season,is_sale_div)
	CASE "close"
			dw_2.Visible = False
	CASE "bar"
			dw_2.Object.gr_1.GraphType = 9
	CASE "line"
			dw_2.Object.gr_1.GraphType = 12
END CHOOSE

RETURN 0

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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61002_d","0")
end event

type cb_close from w_com010_d`cb_close within w_61002_d
end type

type cb_delete from w_com010_d`cb_delete within w_61002_d
end type

type cb_insert from w_com010_d`cb_insert within w_61002_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61002_d
end type

type cb_update from w_com010_d`cb_update within w_61002_d
end type

type cb_print from w_com010_d`cb_print within w_61002_d
end type

type cb_preview from w_com010_d`cb_preview within w_61002_d
end type

type gb_button from w_com010_d`gb_button within w_61002_d
end type

type cb_excel from w_com010_d`cb_excel within w_61002_d
end type

type dw_head from w_com010_d`dw_head within w_61002_d
integer y = 152
integer height = 240
string dataobject = "d_61002_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

idw_season.InsertRow(1)
idw_season.SetItem(1,'inter_cd','')
idw_season.SetItem(1,'inter_nm','전체')

This.GetChild("sale_div", idw_sale_div )
idw_sale_div.SetTransObject(SQLCA)
idw_sale_div.Retrieve('009')

idw_sale_div.InsertRow(1)
idw_sale_div.SetItem(1,'inter_cd','0')
idw_sale_div.SetItem(1,'inter_nm','기타제외')


idw_sale_div.InsertRow(1)
idw_sale_div.SetItem(1,'inter_cd','')
idw_sale_div.SetItem(1,'inter_nm','전체')


end event

event dw_head::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                   */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name

	
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")				
		 
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_61002_d
integer beginy = 400
integer endy = 400
end type

type ln_2 from w_com010_d`ln_2 within w_61002_d
integer beginy = 404
integer endy = 404
end type

type dw_body from w_com010_d`dw_body within w_61002_d
integer y = 412
integer height = 908
string dataobject = "d_61002_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/


end event

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(false)

//This.SetRowFocusIndicator(Hand!)

end event

event dw_body::doubleclicked;string ls_yymm

ls_yymm = This.GetItemString(row, 'yymm')

IF IsNull(ls_yymm) THEN return
dw_3.retrieve(is_brand,ls_yymm,is_plan_year,is_season,is_sale_div)
dw_3.visible = true










end event

type dw_print from w_com010_d`dw_print within w_61002_d
integer x = 763
integer y = 548
integer width = 1481
integer height = 720
string dataobject = "d_61002_r01"
end type

type dw_1 from u_dw within w_61002_d
integer x = 5
integer y = 1328
integer width = 3589
integer height = 692
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_61002_d02"
boolean hsplitscroll = true
end type

type dw_2 from datawindow within w_61002_d
boolean visible = false
integer x = 96
integer y = 524
integer width = 3273
integer height = 1520
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "그래프보기"
string dataobject = "d_61002_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                   */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

type dw_3 from u_dw within w_61002_d
boolean visible = false
integer x = 5
integer y = 1328
integer width = 3589
integer height = 692
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_61002_d04"
boolean hsplitscroll = true
end type

