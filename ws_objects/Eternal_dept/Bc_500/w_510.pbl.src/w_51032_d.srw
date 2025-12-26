$PBExportHeader$w_51032_d.srw
$PBExportComments$매장파트타임근태관리
forward
global type w_51032_d from w_com010_d
end type
end forward

global type w_51032_d from w_com010_d
integer width = 3680
integer height = 2248
end type
global w_51032_d w_51032_d

type variables
DataWindowChild	idw_brand
String is_brand, is_yymm, is_empno
end variables

on w_51032_d.create
call super::create
end on

on w_51032_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"근무월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_empno = dw_head.GetItemString(1, "empno_h")
if IsNull(is_empno) or Trim(is_empno) = "" then
	is_empno = '%'
end if

return true

end event

event open;call super::open;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.setitem(1, "yymm", string(ld_datetime, "YYYYMM"))

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_51032_d","0")
end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymm, is_empno)
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
string ls_person_id, ls_brand

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	
   IF idw_status = NewModified! THEN				/* New Record */
		dw_body.Setitem(i, "a_yymm", is_yymm) 
      dw_body.Setitem(i, "tb_51062_d_reg_id", gs_user_id)
		dw_body.Setitem(i, "tb_51062_d_reg_dt", ld_datetime)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "tb_51062_d_mod_id", gs_user_id)
      dw_body.Setitem(i, "tb_51062_d_mod_dt", ld_datetime)
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
String     ls_style_no, ls_year, ls_season, ls_sojae, ls_item, ls_st_cust_cd, ls_st_cust_nm, ls_mat_cust_cd, ls_mat_cust_nm, ls_mat_cd, ls_mat_nm
Integer    li_sex, li_return, li_okyes
Boolean    lb_check
Decimal    ldc_tag_price
DataStore  lds_Source

SetNull(ls_null)

CHOOSE CASE as_column

	CASE "person_nm"				
			IF ai_div = 1 THEN 	
				If IsNull(as_data) or as_data = "" Then
					dw_body.SetItem(al_row, "person_nm", "")
					RETURN 0
				END IF 
			END IF
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "PT사원 검색" 
			gst_cd.datawindow_nm   = "d_com_51031" 
			gst_cd.default_where   = " WHERE left(shop_cd,1) = '" + is_brand + "'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "person_nm LIKE '" + as_data + "%'"
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
					dw_body.SetRow(al_row)
					dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "a_person_id", lds_Source.GetItemString(1,"person_id"))
				dw_body.SetItem(al_row, "b_person_nm", lds_Source.GetItemString(1,"person_nm"))
				dw_body.SetItem(al_row, "b_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_body.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
//				dw_body.SetColumn("tel1")
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
				cb_excel.enabled = false
			END IF
			Destroy  lds_Source

	CASE "empno_h"
		is_brand = Trim(dw_head.GetItemString(1, "brand"))
			IF ai_div = 1 THEN
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_head.SetItem(al_row, "empno_nm_h", "")
					RETURN 0
				END IF 
			END IF
			
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "영업부 사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 	
		
				gst_cd.default_where   = " WHERE DEPT_CODE in ( '5000','5200','K000','K120','T400','R400') " + &
								 "   AND GOOUT_GUBN = '1' and brand = '" + is_brand + "'"
	
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "EMPNO LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF
	
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)
	
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "empno_h", lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "empno_nm_h", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("fr_yymm")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
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

type cb_close from w_com010_d`cb_close within w_51032_d
end type

type cb_delete from w_com010_d`cb_delete within w_51032_d
boolean visible = true
end type

type cb_insert from w_com010_d`cb_insert within w_51032_d
boolean visible = true
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_51032_d
end type

type cb_update from w_com010_d`cb_update within w_51032_d
boolean visible = true
end type

type cb_print from w_com010_d`cb_print within w_51032_d
end type

type cb_preview from w_com010_d`cb_preview within w_51032_d
end type

type gb_button from w_com010_d`gb_button within w_51032_d
end type

type cb_excel from w_com010_d`cb_excel within w_51032_d
end type

type dw_head from w_com010_d`dw_head within w_51032_d
integer x = 9
integer y = 160
integer width = 3584
integer height = 132
string dataobject = "d_51032_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(row, "empno_h", "")
		This.SetItem(row, "empno_nm_h", "")
	CASE "shop_cd_h", "empno_h"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_51032_d
integer beginy = 296
integer endy = 296
end type

type ln_2 from w_com010_d`ln_2 within w_51032_d
integer beginy = 300
integer endy = 300
end type

type dw_body from w_com010_d`dw_body within w_51032_d
integer y = 316
integer width = 3598
integer height = 1696
string dataobject = "d_51032_d01"
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
	 
	CASE "person_nm"	//  Popup 검색창이 존재하는 항목 
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

type dw_print from w_com010_d`dw_print within w_51032_d
integer x = 2450
integer y = 364
integer width = 1138
integer height = 400
string dataobject = "d_51032_r01"
end type

