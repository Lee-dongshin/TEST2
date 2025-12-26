$PBExportHeader$w_32006_d.srw
$PBExportComments$ITEM별 미입고 현황
forward
global type w_32006_d from w_com020_d
end type
end forward

global type w_32006_d from w_com020_d
integer width = 3680
integer height = 2284
string title = "ITEM별 미입고 현황"
end type
global w_32006_d w_32006_d

type variables
DataWindowChild idw_brand, idw_season, idw_sojae, idw_make_type, idw_out_seq

String is_brand, is_year, is_season, is_sojae, is_make_type, is_out_seq
String is_item, is_cust_cd

end variables

on w_32006_d.create
call super::create
end on

on w_32006_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_preopen;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범) 														  */	
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
inv_resize.of_Register(dw_head, "ScaleToRight")
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

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.10                                                  */	
/* 수정일      : 2001.12.10                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_sojae = Trim(dw_head.GetItemString(1, "sojae"))
if IsNull(is_sojae) or is_sojae = "" then
   MessageBox(ls_title,"소재 유형을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_make_type = Trim(dw_head.GetItemString(1, "make_type"))
if IsNull(is_make_type) or is_make_type = "" then
   MessageBox(ls_title,"생산 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("make_type")
   return false
end if

is_out_seq = Trim(dw_head.GetItemString(1, "out_seq"))
if IsNull(is_out_seq) or is_out_seq = "" then
   MessageBox(ls_title,"출고 차순을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_seq")
   return false
end if

return true	

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */
/* 작성일      : 2001.12.10                                                  */
/* 수정일      : 2001.12.10                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_sojae, is_year, is_season, is_make_type, is_out_seq)

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

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

//dw_body.ShareData(dw_print)
dw_print.Retrieve(is_brand, is_sojae, is_year, is_season, is_make_type, is_out_seq)
dw_print.inv_printpreview.of_SetZoom()	//ls_modify

end event

event ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

//dw_body.ShareData(dw_print)
dw_print.Retrieve(is_brand, is_sojae, is_year, is_season, is_make_type, is_out_seq)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.10                                                  */	
/* 수정일      : 2001.12.10                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
             "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_sojae.Text = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
             "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
             "t_make_type.Text = '" + idw_make_type.GetItemString(idw_make_type.GetRow(), "inter_display") + "'" + &
             "t_out_seq.Text = '" + idw_out_seq.GetItemString(idw_out_seq.GetRow(), "inter_display") + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_32006_d","0")
end event

type cb_close from w_com020_d`cb_close within w_32006_d
end type

type cb_delete from w_com020_d`cb_delete within w_32006_d
end type

type cb_insert from w_com020_d`cb_insert within w_32006_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_32006_d
end type

type cb_update from w_com020_d`cb_update within w_32006_d
end type

type cb_print from w_com020_d`cb_print within w_32006_d
end type

type cb_preview from w_com020_d`cb_preview within w_32006_d
end type

type gb_button from w_com020_d`gb_button within w_32006_d
end type

type cb_excel from w_com020_d`cb_excel within w_32006_d
end type

type dw_head from w_com020_d`dw_head within w_32006_d
integer height = 224
string dataobject = "d_32006_h01"
end type

event dw_head::constructor;call super::constructor;dw_head.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

dw_head.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', is_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

dw_head.GetChild("make_type", idw_make_type)
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.InsertRow(1)
idw_make_type.SetItem(1, "inter_cd", '%')
idw_make_type.SetItem(1, "inter_nm", '전체')

dw_head.GetChild("out_seq", idw_out_seq)
idw_out_seq.SetTransObject(SQLCA)
idw_out_seq.Retrieve('010')
idw_out_seq.InsertRow(1)
idw_out_seq.SetItem(1, "inter_cd", '%')
idw_out_seq.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name


	CASE "brand", "year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")


			This.GetChild("sojae", idw_sojae)
			idw_sojae.SetTransObject(SQLCA)
			idw_sojae.Retrieve('%', is_brand)
			idw_sojae.insertrow(1)
			idw_sojae.Setitem(1, "sojae", "%")
			idw_sojae.Setitem(1, "sojae_nm", "전체")

		
END CHOOSE
end event

type ln_1 from w_com020_d`ln_1 within w_32006_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com020_d`ln_2 within w_32006_d
integer beginy = 428
integer endy = 428
end type

type dw_list from w_com020_d`dw_list within w_32006_d
integer y = 444
integer width = 3561
integer height = 688
string dataobject = "d_32006_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.10                                                  */	
/* 수정일      : 2001.12.10                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_item = This.GetItemString(row, 'item') /* DataWindow에 Key 항목을 가져온다 */
is_cust_cd = This.GetItemString(row, 'cust_cd') /* DataWindow에 Key 항목을 가져온다 */
//IF IsNull(is_item) or IsNull(is_cust_cd) THEN 
//	dw_body.Reset()
//	return
//End If

il_rows = dw_body.retrieve(is_brand, is_sojae, is_year, is_season, + &
									is_make_type, is_out_seq, is_item, is_cust_cd)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

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

//// DATAWINDOW COLUMN Modify
//Integer i, li_column_count
//String  ls_column_name, ls_modify
//
//li_column_count = Integer(This.Describe("DataWindow.Column.Count"))
//
//IF li_column_count = 0 THEN RETURN
//
//FOR i=1 TO li_column_count
//	ls_column_name = This.Describe('#' + String(i) + '.Name')
//	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
//		ls_modify   = ls_modify + ls_column_name + &
//		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
//	END IF
//NEXT
//
//This.Modify(ls_modify)
end event

type dw_body from w_com020_d`dw_body within w_32006_d
integer x = 27
integer y = 1144
integer width = 3561
integer height = 896
string dataobject = "d_32006_d02"
boolean hscrollbar = true
end type

type st_1 from w_com020_d`st_1 within w_32006_d
boolean visible = false
integer y = 344
integer height = 1696
end type

type dw_print from w_com020_d`dw_print within w_32006_d
string dataobject = "d_32006_r01"
end type

