$PBExportHeader$w_46003_d.srw
$PBExportComments$특수부자재 출고현황
forward
global type w_46003_d from w_com010_d
end type
end forward

global type w_46003_d from w_com010_d
end type
global w_46003_d w_46003_d

type variables
string is_brand , is_yymmdd, is_mat_cd, is_style, is_fr_ymd, is_to_ymd, is_out_yn, is_year, is_season, is_item, is_make_type

datawindowchild idw_brand, idw_season, idw_item

end variables

on w_46003_d.create
call super::create
end on

on w_46003_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_out_yn = dw_head.GetItemString(1, "out_yn")
if IsNull(is_out_yn) or Trim(is_out_yn) = "" then
   MessageBox(ls_title,"출고여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_yn")
   return false
end if

is_style  = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
  is_style = "%"
end if

is_mat_cd = dw_head.GetItemString(1, "mat_cd")
if IsNull(is_mat_cd) or Trim(is_mat_cd) = "" then
  is_mat_cd = "%"
end if

is_year   = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
  is_year = "%"
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
  is_season = "%"
end if

is_item   = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
  is_item = "%"
end if

is_make_type = dw_head.GetItemString(1, "make_type")
if IsNull(is_make_type) or Trim(is_make_type) = "" then
  is_make_type = "%"
end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style"				
			if is_brand = '' then is_brand = gs_brand
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "스타일 검색" 
			gst_cd.datawindow_nm   = "d_sh131_ddw" 
			gst_cd.default_where   = " where a.mat_cd = b.mat_cd " + &
											 " and   b.mat_type = '3' "

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " a.style LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))

				/* 다음컬럼으로 이동 */

				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//@brand		varchar(1),
//@fr_ymd		varchar(8),
//@to_ymd		varchar(8),
//@mat_cd		varchar(10) = null,
//@style		varchar(8)  = null,
//@year		varchar(4) = null,
//@season		varchar(1) = null,
//@item		varchar(1) = null,
//@make_type	varchar(4) = null

il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_mat_cd, is_style,  is_year, is_season, is_item, is_make_type)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_preview();


This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_print.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_mat_cd, is_style,  is_year, is_season, is_item, is_make_type)
dw_print.inv_printpreview.of_SetZoom()
end event

event ue_print();This.Trigger Event ue_title()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_print.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_mat_cd, is_style,  is_year, is_season, is_item, is_make_type)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event open;call super::open;dw_body.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로
end event

type cb_close from w_com010_d`cb_close within w_46003_d
end type

type cb_delete from w_com010_d`cb_delete within w_46003_d
end type

type cb_insert from w_com010_d`cb_insert within w_46003_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_46003_d
end type

type cb_update from w_com010_d`cb_update within w_46003_d
end type

type cb_print from w_com010_d`cb_print within w_46003_d
end type

type cb_preview from w_com010_d`cb_preview within w_46003_d
end type

type gb_button from w_com010_d`gb_button within w_46003_d
end type

type cb_excel from w_com010_d`cb_excel within w_46003_d
end type

type dw_head from w_com010_d`dw_head within w_46003_d
integer y = 156
integer height = 220
string dataobject = "d_46003_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
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

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(is_brand)
idw_item.insertrow(1)
idw_item.setitem(1,"item","%")
idw_item.setitem(1,"item_nm","전체")
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
	
			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_brand)
			idw_item.insertrow(1)
			idw_item.Setitem(1, "item", "%")
			idw_item.Setitem(1, "item_nm", "전체")
		
END CHOOSE
		
end event

type ln_1 from w_com010_d`ln_1 within w_46003_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_d`ln_2 within w_46003_d
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_d`dw_body within w_46003_d
integer y = 400
integer height = 1640
string dataobject = "d_46003_d00"
end type

type dw_print from w_com010_d`dw_print within w_46003_d
string dataobject = "d_46003_d00"
end type

