$PBExportHeader$w_56022_e.srw
$PBExportComments$부진재매입선정
forward
global type w_56022_e from w_com010_e
end type
end forward

global type w_56022_e from w_com010_e
integer width = 3675
integer height = 2288
end type
global w_56022_e w_56022_e

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_dep_seq
String is_brand, is_year, is_season, is_dep_seq, is_stock_ymd, is_proc_ymd
end variables

on w_56022_e.create
call super::create
end on

on w_56022_e.destroy
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

is_dep_seq = dw_head.GetItemString(1, "dep_seq")
if IsNull(is_dep_seq) or Trim(is_dep_seq) = "" then
   MessageBox(ls_title,"부진차수를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dep_seq")
   return false
end if


is_stock_ymd = dw_head.GetItemString(1, "stock_ymd")
if IsNull(is_stock_ymd) or Trim(is_stock_ymd) = "" then
   MessageBox(ls_title,"재고기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("stock_ymd")
   return false
end if

is_proc_ymd = dw_head.GetItemString(1, "proc_ymd")
if IsNull(is_proc_ymd) or Trim(is_proc_ymd) = "" then
   MessageBox(ls_title,"재매입일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("proc_ymd")
   return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_dep_seq, is_stock_ymd, is_proc_ymd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56022_e","0")
end event

event type long ue_update();call super::ue_update;long i, ll_row_count
String ls_data_type
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
	ls_data_type = dw_body.getitemstring(i, "data_type")
   
	if ls_data_type = "N" then
		dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
	end if
	
	idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "REG_ID", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

type cb_close from w_com010_e`cb_close within w_56022_e
end type

type cb_delete from w_com010_e`cb_delete within w_56022_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56022_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56022_e
end type

type cb_update from w_com010_e`cb_update within w_56022_e
end type

type cb_print from w_com010_e`cb_print within w_56022_e
end type

type cb_preview from w_com010_e`cb_preview within w_56022_e
end type

type gb_button from w_com010_e`gb_button within w_56022_e
end type

type cb_excel from w_com010_e`cb_excel within w_56022_e
end type

type dw_head from w_com010_e`dw_head within w_56022_e
integer y = 160
integer height = 208
string dataobject = "d_56022_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve("001")

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve("003", gs_brand, '%') 

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve("002") 

This.GetChild("dep_seq", idw_dep_seq)
idw_dep_seq.SetTransObject(SQLCA)

end event

event dw_head::itemchanged;call super::itemchanged;String ls_null, ls_yymmdd
SetNull(ls_null)
String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "season"
		This.Setitem(1, "dep_seq", ls_null)
		
	CASE "brand"
		This.Setitem(1, "dep_seq", ls_null)		
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
		
		This.Setitem(1, "dep_seq", ls_null)
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")				
		
END CHOOSE
end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;String ls_brand, ls_year, ls_season 

CHOOSE CASE dwo.name
	CASE "dep_seq"
		  ls_brand   = This.GetitemString(1, "brand") 
		  ls_year    = This.GetitemString(1, "year") 
		  ls_season  = This.GetitemString(1, "season") 
        idw_dep_seq.Retrieve(ls_brand, ls_year, ls_season)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_56022_e
integer beginy = 396
integer endy = 396
end type

type ln_2 from w_com010_e`ln_2 within w_56022_e
integer beginy = 400
integer endy = 400
end type

type dw_body from w_com010_e`dw_body within w_56022_e
integer y = 408
integer height = 1632
string dataobject = "d_56022_d01"
end type

event dw_body::constructor;call super::constructor;// DATAWINDOW COLUMN Modify
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

event dw_body::buttonclicked;call super::buttonclicked;Long i
String ls_yn, ls_out_no

If dwo.Name = 'cb_select' Then
	If dwo.Text = '전체' Then
		ls_yn = 'Y'
		dwo.Text = '해제'
	Else
		ls_yn = 'N'
		dwo.Text = '전체'
	End If
	
	For i = 1 To This.RowCount()
		This.SetItem(i, "proc_chk", ls_yn)
	Next

End If

end event

type dw_print from w_com010_e`dw_print within w_56022_e
end type

