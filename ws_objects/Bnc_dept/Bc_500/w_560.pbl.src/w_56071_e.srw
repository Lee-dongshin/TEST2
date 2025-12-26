$PBExportHeader$w_56071_e.srw
$PBExportComments$정상판매마감관리
forward
global type w_56071_e from w_com010_d
end type
type dw_1 from datawindow within w_56071_e
end type
type cb_shop_input from commandbutton within w_56071_e
end type
end forward

global type w_56071_e from w_com010_d
integer width = 3694
integer height = 2260
dw_1 dw_1
cb_shop_input cb_shop_input
end type
global w_56071_e w_56071_e

type variables
DataWindowChild	idw_brand
String is_brand, is_year, is_season, is_fr_ymd, is_to_ymd , is_yymmdd, is_empno
end variables

on w_56071_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_shop_input=create cb_shop_input
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_shop_input
end on

on w_56071_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_shop_input)
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

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"마감일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마감일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if



return true

end event

event open;call super::open;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.setitem(1, "yymmdd", string(ld_datetime, "YYYYMMDD"))

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56071_e","0")
end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_fr_ymd, is_to_ymd)
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

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'"

dw_print.Modify(ls_modify)


end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : M.S.I (김 태범)                                             */	
/* 작성일      : 2001.05.31                                                  */	
/* 수성일      : 2001.05.31                                                  */
/*===========================================================================*/
long i, ll_row_count
decimal ld_max_id
datetime ld_datetime
string ls_person_id, ls_brand, ls_date, ls_max_id

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
		dw_body.Setitem(i, "reg_dt", ld_datetime)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_insert();call super::ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_empno

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF
	


il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.20                                                  */	
/* 수정일      : 2002.03.20                                                  */
/*===========================================================================*/
String     ls_card_no, ls_jumin, ls_custom_nm, ls_tel_1, ls_tel_no1, ls_tel_no2, ls_tel_no3, ls_null, ls_tel_no, ls_user_name,ls_part_nm
String     ls_style_no, ls_year, ls_season, ls_sojae, ls_item, ls_st_cust_cd, ls_st_cust_nm, ls_mat_cust_cd, ls_mat_cust_nm, ls_mat_cd, ls_mat_nm, ls_shop_nm, ls_brand
Integer    li_sex, li_return, li_okyes
Boolean    lb_check
Decimal    ldc_tag_price
DataStore  lds_Source

SetNull(ls_null)

CHOOSE CASE as_column
	CASE "shop_cd", "cb_shop_cd"			
			IF ai_div = 1 THEN 	
				If IsNull(as_data) or as_data = "" Then
					dw_1.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_1.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV  IN ('G', 'K', 'B','H') " + &
											 "  AND BRAND = '" + ls_brand + "'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
					dw_1.SetRow(al_row)
					dw_1.SetColumn(as_column)
				END IF
				dw_1.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_1.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_1.SetColumn("yymmdd")
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
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

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
	CASE 1		/* 조회 */
		cb_retrieve.Text = "조건(&Q)"
		dw_head.Enabled = false
//		If al_rows <= 0 Then
			dw_body.Enabled = true
//		End If
		cb_insert.enabled = true
		cb_delete.enabled = true
		cb_print.enabled = true
		cb_preview.enabled = true
		cb_excel.enabled = true
	CASE 2   /* 추가 */
		if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
			end if
			dw_body.Enabled = true
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
			cb_insert.enabled = false
			cb_delete.enabled = false
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
//         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled  = true
         cb_print.enabled   = true
         cb_preview.enabled = true
         cb_excel.enabled   = true
			dw_body.enabled    = true
		else
         cb_delete.enabled  = false
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = true
         cb_insert.enabled = true
      end if
END CHOOSE

end event

event ue_delete();call super::ue_delete;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_body.DeleteRow (ll_cur_row)
dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
inv_resize.of_Register(cb_shop_input, "FixedToRight")
end event

type cb_close from w_com010_d`cb_close within w_56071_e
end type

type cb_delete from w_com010_d`cb_delete within w_56071_e
boolean visible = true
end type

type cb_insert from w_com010_d`cb_insert within w_56071_e
boolean visible = true
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56071_e
end type

type cb_update from w_com010_d`cb_update within w_56071_e
boolean visible = true
end type

type cb_print from w_com010_d`cb_print within w_56071_e
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_56071_e
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_56071_e
end type

type cb_excel from w_com010_d`cb_excel within w_56071_e
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_56071_e
integer x = 9
integer y = 160
integer width = 3584
integer height = 132
string dataobject = "d_56071_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child, ldw_year

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
/*
This.GetChild("year", ldw_year)
ldw_year.SetTransObject(SQLCA)
ldw_year.Retrieve('002')
ldw_year.insertRow(1)
ldw_year.Setitem(1, "inter_cd", "%")
ldw_year.Setitem(1, "inter_nm", "전체")
*/
dw_head.setitem(1, 'year','%')

This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('003', gs_brand, '%')
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", "%")
ldw_child.Setitem(1, "inter_nm", "전체")
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
/*===========================================================================*/
String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(row, "empno_h", "")
		This.SetItem(row, "empno_nm_h", "")

		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
	CASE "shop_cd_h", "empno_h"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
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

type ln_1 from w_com010_d`ln_1 within w_56071_e
integer beginy = 296
integer endy = 296
end type

type ln_2 from w_com010_d`ln_2 within w_56071_e
integer beginy = 300
integer endy = 300
end type

type dw_body from w_com010_d`dw_body within w_56071_e
integer y = 316
integer width = 3598
integer height = 1696
string dataobject = "d_56071_d01"
boolean hscrollbar = true
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
String ls_time

select convert(char(20), getdate(), 112)
into :ls_time
from dual;

CHOOSE CASE dwo.name
	 
	CASE "shop_cd_h"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)	

END CHOOSE


ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)
end event

event dw_body::editchanged;call super::editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child, ldw_year

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("year", ldw_year)
ldw_year.SetTransObject(SQLCA)
ldw_year.Retrieve('002')

This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('003')


end event

type dw_print from w_com010_d`dw_print within w_56071_e
integer x = 2450
integer y = 364
integer height = 432
end type

type dw_1 from datawindow within w_56071_e
boolean visible = false
integer x = 14
integer y = 320
integer width = 4590
integer height = 1604
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "제외매장등록"
string dataobject = "d_56071_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report, ls_yymmdd, ls_judg_fg
int i
Long ll_row, ll_row_count
datetime ld_datetime 

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

Choose Case ls_column_nm
	Case "add"
			il_rows = This.InsertRow(0)				
			This.SetColumn(il_rows)
	Case "delete"
		ll_row = This.GetRow()
		if ll_row <= 0 then return
		idw_status = This.GetItemStatus(ll_row, 0, Primary!)
		il_rows = This.DeleteRow(ll_row)
		This.SetFocus()
//		Parent.Trigger Event ue_button (4, il_rows)
	Case "update"
		ll_row_count = dw_1.RowCount()
		IF dw_1.AcceptText() <> 1 THEN RETURN -1
		
		/* 시스템 날짜를 가져온다 */
		IF gf_sysdate(ld_datetime) = FALSE THEN
			Return 0
		END IF
		
		FOR i=1 TO ll_row_count
			idw_status = dw_1.GetItemStatus(i, 0, Primary!)
			IF idw_status = NewModified! THEN				/* New Record */
				dw_1.Setitem(i, "reg_id", gs_user_id)
				dw_1.Setitem(i, "reg_dt", ld_datetime)
			ELSEIF idw_status = DataModified! THEN		/* Modify Record */
				dw_1.Setitem(i, "mod_id", gs_user_id)
				dw_1.Setitem(i, "mod_dt", ld_datetime)
			END IF
		NEXT
		
		il_rows = dw_1.Update()
		
		if il_rows = 1 then
			commit  USING SQLCA;
		else
			rollback  USING SQLCA;
		end if
		
		
	Case "close"
		dw_1.visible = false
		

	CASE "shop_cd" //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

END CHOOSE

end event

event constructor;DataWindowChild ldw_child, ldw_year

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("year", ldw_year)
ldw_year.SetTransObject(SQLCA)
ldw_year.Retrieve('002')

This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('003')

end event

event itemchanged;CHOOSE CASE dwo.name
	 
	CASE "shop_cd"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)	

END CHOOSE
end event

event itemfocuschanged;String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)
end event

type cb_shop_input from commandbutton within w_56071_e
integer x = 2459
integer y = 44
integer width = 416
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "제외매장등록"
end type

event clicked;string ls_brand, ls_year, ls_season

dw_head.accepttext()
ls_brand = dw_head.getitemstring(1,'brand')
ls_year = dw_head.getitemstring(1,'year')
ls_season = dw_head.getitemstring(1,'season')

dw_1.retrieve(ls_brand, ls_year, ls_season)


dw_1.visible = true


end event

