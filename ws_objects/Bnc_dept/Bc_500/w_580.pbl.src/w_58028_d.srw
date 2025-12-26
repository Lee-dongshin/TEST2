$PBExportHeader$w_58028_d.srw
$PBExportComments$부자재수출 진행현황
forward
global type w_58028_d from w_com010_d
end type
type dw_1 from datawindow within w_58028_d
end type
type st_1 from statictext within w_58028_d
end type
end forward

global type w_58028_d from w_com010_d
integer width = 3639
dw_1 dw_1
st_1 st_1
end type
global w_58028_d w_58028_d

type variables
string is_brand, is_year, is_season, is_fr_yymmdd, is_to_yymmdd
datawindowchild idw_brand, idw_season

end variables

on w_58028_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_1
end on

on w_58028_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_1)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if


is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_fr_yymmdd, is_to_yymmdd)
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

//dw_print.object.t_band.text = '브랜드: ' + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
//dw_print.object.t_season.text = '시즌: ' + is_year +' '+idw_season.getitemstring(idw_season.getrow(),"inter_nm")
//

end event

event open;call super::open;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymm"+"01"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if
end event

event pfc_preopen;call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

dw_print.dataobject = "d_58028_r02"
dw_print.SetTransObject(SQLCA)

This.Trigger Event ue_title ()

dw_1.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_preview;dw_print.dataobject = "d_58028_r01"
dw_print.SetTransObject(SQLCA)

This.Trigger Event ue_title ()

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

type cb_close from w_com010_d`cb_close within w_58028_d
end type

type cb_delete from w_com010_d`cb_delete within w_58028_d
end type

type cb_insert from w_com010_d`cb_insert within w_58028_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_58028_d
end type

type cb_update from w_com010_d`cb_update within w_58028_d
end type

type cb_print from w_com010_d`cb_print within w_58028_d
integer width = 453
string text = "미리보기(상세)"
end type

type cb_preview from w_com010_d`cb_preview within w_58028_d
integer x = 1874
end type

type gb_button from w_com010_d`gb_button within w_58028_d
end type

type cb_excel from w_com010_d`cb_excel within w_58028_d
integer x = 2217
end type

type dw_head from w_com010_d`dw_head within w_58028_d
integer height = 144
string dataobject = "d_58028_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
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

type ln_1 from w_com010_d`ln_1 within w_58028_d
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_d`ln_2 within w_58028_d
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_d`dw_body within w_58028_d
integer y = 368
integer height = 1672
string dataobject = "d_58028_d01"
boolean hscrollbar = true
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
		              ".color='0~tif (getrow() = currentrow(), rgb(0,0,255), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

event dw_body::doubleclicked;call super::doubleclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001.05.29                                                  */	
/* 수성일      : 2001.05.29                                                  */
/*===========================================================================*/
String ls_inter_grp, ls_hs_nm

IF row <= 0 THEN Return

	
//This.SelectRow(0, FALSE)
//This.SelectRow(row, TRUE)

ls_inter_grp = This.GetItemString(row, 'invoice_no') /* DataWindow에 Key 항목을 가져온다 */
ls_hs_nm = This.GetItemString(row, 'hs_nm')

IF IsNull(ls_inter_grp) THEN return

il_rows = dw_1.retrieve(is_brand, is_year, is_season, ls_inter_grp, ls_hs_nm)
dw_1.visible = true

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_print from w_com010_d`dw_print within w_58028_d
string dataobject = "d_58028_r01"
end type

type dw_1 from datawindow within w_58028_d
boolean visible = false
integer x = 137
integer y = 264
integer width = 3822
integer height = 1820
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_58028_d02"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_58028_d
integer x = 2898
integer y = 252
integer width = 585
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※상세내역: 더블클릭"
boolean focusrectangle = false
end type

