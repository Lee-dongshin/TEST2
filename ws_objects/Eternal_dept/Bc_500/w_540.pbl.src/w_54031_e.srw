$PBExportHeader$w_54031_e.srw
$PBExportComments$닷컴용부진관리
forward
global type w_54031_e from w_com010_e
end type
end forward

global type w_54031_e from w_com010_e
integer width = 3675
integer height = 2276
end type
global w_54031_e w_54031_e

type variables
string is_brand, is_dep_seq, is_dep_ymd, is_year, is_season, is_item, is_sojae, is_yymmdd
DataWindowChild idw_brand, idw_dep_seq, idw_season, odw_year, idw_sojae, idw_item
end variables

on w_54031_e.create
call super::create
end on

on w_54031_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title, ls_dep_seq

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

is_year = dw_head.GetitemString(1, "year")
if Isnull(is_year) or Trim(is_year) = "" then
	MessageBox(ls_title, "시즌년도를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("year")
	return false
end if

is_season = dw_head.GetitemString(1, "season")
if Isnull(is_season) or Trim(is_season) = "" then
	MessageBox(ls_title, "시즌을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("season")
	return false
end if

is_sojae = dw_head.GetitemString(1, "sojae")
if Isnull(is_sojae) or Trim(is_sojae) = "" then
	MessageBox(ls_title, "소재를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("sojae")
	return false
end if

is_item = dw_head.GetitemString(1, "item")
if Isnull(is_item) or Trim(is_item) = "" then
	MessageBox(ls_title, "품종을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("item")
	return false
end if

is_dep_seq = dw_head.GetitemString(1, "dep_seq")
if Isnull(is_dep_seq) or Trim(is_dep_seq) = "" then
	is_dep_seq = "%"
//	MessageBox(ls_title, "부진차수를 입력하십시요!")
//	dw_head.SetFocus()
//	dw_head.SetColumn("dep_seq")
//	return false
end if

is_yymmdd = dw_head.GetitemString(1, "yymmdd")
if Isnull(is_yymmdd) or Trim(is_yymmdd) = "" then
	MessageBox(ls_title, "해제일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("yymmdd")
	return false
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_sojae,is_item,is_dep_seq,"%")

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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54031_e","0")
end event

event open;call super::open;is_brand = dw_head.GetItemString(1, "brand")
is_year  = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")

idw_dep_seq.Retrieve(is_brand, is_year, is_season)
idw_dep_seq.InsertRow(1)
idw_dep_seq.SetItem(1, "dep_seq", '%')
idw_dep_seq.SetItem(1, "dep_ymd", '전체')

end event

event type long ue_update();call super::ue_update;long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
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

type cb_close from w_com010_e`cb_close within w_54031_e
end type

type cb_delete from w_com010_e`cb_delete within w_54031_e
end type

type cb_insert from w_com010_e`cb_insert within w_54031_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_54031_e
end type

type cb_update from w_com010_e`cb_update within w_54031_e
end type

type cb_print from w_com010_e`cb_print within w_54031_e
end type

type cb_preview from w_com010_e`cb_preview within w_54031_e
end type

type gb_button from w_com010_e`gb_button within w_54031_e
end type

type cb_excel from w_com010_e`cb_excel within w_54031_e
end type

type dw_head from w_com010_e`dw_head within w_54031_e
integer y = 160
integer height = 212
string dataobject = "d_54031_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTRansObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%', gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", "%")
idw_item.SetItem(1, "item_nm", "전체")

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.insertrow(1)
idw_sojae.Setitem(1, "sojae", "%")
idw_sojae.Setitem(1, "sojae_nm", "전체")

This.GetChild("dep_seq", idw_dep_seq)
idw_dep_seq.SetTRansObject(SQLCA)
idw_dep_seq.InsertRow(1)



end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child



CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(1, "dep_seq", "")
		is_brand = data
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		This.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', data)
		idw_sojae.insertrow(1)
		idw_sojae.Setitem(1, "sojae", "%")
		idw_sojae.Setitem(1, "sojae_nm", "전체")
		
		This.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve(data)
		idw_item.insertrow(1)
		idw_item.Setitem(1, "item", "%")
		idw_item.Setitem(1, "item_nm", "전체")		

		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		

	CASE "year"
		This.SetItem(1, "dep_seq", "")
		is_year = data
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")		
		
	CASE "season"
		This.SetItem(1, "dep_seq", "")
		is_season = data
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
			
	
END CHOOSE 
		 
		 
	
		
end event

type ln_1 from w_com010_e`ln_1 within w_54031_e
integer beginy = 372
integer endy = 372
end type

type ln_2 from w_com010_e`ln_2 within w_54031_e
integer beginy = 376
integer endy = 376
end type

type dw_body from w_com010_e`dw_body within w_54031_e
integer y = 388
integer height = 1652
string dataobject = "d_54031_d01"
end type

event dw_body::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "dotcom_cancel" 
    IF data = 'Y' THEN
		dw_body.setitem(row, "cancel_ymd", is_yymmdd)
    else	
		dw_body.setitem(row, "cancel_ymd", "")
    END IF
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_54031_e
end type

