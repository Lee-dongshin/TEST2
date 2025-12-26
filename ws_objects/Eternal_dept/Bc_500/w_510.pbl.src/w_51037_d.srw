$PBExportHeader$w_51037_d.srw
$PBExportComments$담당별 인벤트 승인 및 반려
forward
global type w_51037_d from w_com010_d
end type
end forward

global type w_51037_d from w_com010_d
integer width = 3680
integer height = 2244
end type
global w_51037_d w_51037_d

type variables
DataWindowChild	idw_brand
String is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_empno , is_yymmdd
end variables

on w_51037_d.create
call super::create
end on

on w_51037_d.destroy
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

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"등록기간을 입력하십시요!1")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"등록기간을 입력하십시요!2")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = '%'
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

dw_head.setitem(1, "fr_ymd", string(ld_datetime, "YYYYMM")+'01')
dw_head.setitem(1, "to_ymd", string(ld_datetime, "YYYYMMDD"))

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_51034_d","0")
end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_empno)
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
string ls_modify, ls_datetime, ls_shop_cd, ls_empno, ls_shop_nm, ls_emp_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_shop_cd = dw_head.getitemstring(1,'shop_cd')
ls_shop_nm = dw_head.getitemstring(1,'shop_nm')
if ls_shop_cd = '' or isnull(ls_shop_cd) then
	ls_shop_cd = '전체'
else
	ls_shop_cd = ls_shop_cd + '(' + ls_shop_nm + ')'
end if

ls_empno = dw_head.getitemstring(1,'empno_h')
ls_emp_nm = dw_head.getitemstring(1,'emp_nm_h')
if ls_empno = '' or isnull(ls_empno) then
	ls_empno = '전체'
else
	ls_empno = ls_empno + '(' + ls_emp_nm + ')'
end if


ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_shop_cd.Text = '" + ls_shop_cd + "'" + &
            "t_empno.Text = '" + ls_empno + "'" + &
				"t_fr_ymd.Text = '" + dw_head.getitemstring(1,'fr_ymd') + "'" + &
				"t_to_ymd.Text = '" + dw_head.getitemstring(1,'to_ymd') + "'" + &
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

ls_date = string(DateTime(Today(), Now()), "YYYYMMDD")

//select isnull(max(no),0) into :ld_max_id
//from tb_51063_d with (nolock)
//where yymmdd = :ls_date;



FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
//		dw_body.Setitem(i, "yymmdd", ls_date)
//		dw_body.Setitem(i, "no", string(ld_max_id + 1, '0000'))
      dw_body.Setitem(i, "reg_id", gs_user_id)
		dw_body.Setitem(i, "reg_dt", ld_datetime)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		if dw_body.getitemstring(i,'sing_gubn') = 'Y' or dw_body.getitemstring(i,'sing_gubn') = 'N' then
			dw_body.setitem(i,'sing_ymd', ls_date)  
		end if
		if dw_body.getitemstring(i,'accept_gubn') = 'Y' or dw_body.getitemstring(i,'accept_gubn') = 'N' then
			dw_body.setitem(i,'accept_ymd', ls_date)  
		end if		
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.20                                                  */	
/* 수정일      : 2002.03.20                                                  */
/*===========================================================================*/
String     ls_card_no, ls_jumin, ls_custom_nm, ls_tel_1, ls_tel_no1, ls_tel_no2, ls_tel_no3, ls_null, ls_tel_no, ls_user_name,ls_part_nm, ls_brand
String     ls_style_no, ls_year, ls_season, ls_sojae, ls_item, ls_st_cust_cd, ls_st_cust_nm, ls_mat_cust_cd, ls_mat_cust_nm, ls_mat_cd, ls_mat_nm, ls_shop_nm
Integer    li_sex, li_return, li_okyes
Boolean    lb_check
Decimal    ldc_tag_price
DataStore  lds_Source

SetNull(ls_null)

CHOOSE CASE as_column

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
			gst_cd.default_where   = " WHERE DEPT_CODE in ( '5000','5200','K000','K120','T400','R400','X100') " + &
											 "   AND GOOUT_GUBN = '1' AND brand = '" + is_brand + "'"
	
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
//				dw_head.SetColumn("fr_yymm")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source			
			
		CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
			ls_brand = dw_head.getitemstring(1,"brand")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com918" 
			gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "' AND SHOP_STAT = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' or shop_nm like  '%" + as_data + "%'"
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
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("cust_type")
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

type cb_close from w_com010_d`cb_close within w_51037_d
end type

type cb_delete from w_com010_d`cb_delete within w_51037_d
end type

type cb_insert from w_com010_d`cb_insert within w_51037_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_51037_d
end type

type cb_update from w_com010_d`cb_update within w_51037_d
end type

type cb_print from w_com010_d`cb_print within w_51037_d
end type

type cb_preview from w_com010_d`cb_preview within w_51037_d
end type

type gb_button from w_com010_d`gb_button within w_51037_d
end type

type cb_excel from w_com010_d`cb_excel within w_51037_d
end type

type dw_head from w_com010_d`dw_head within w_51037_d
integer x = 9
integer y = 160
integer width = 3584
integer height = 212
string dataobject = "d_51037_h01"
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

type ln_1 from w_com010_d`ln_1 within w_51037_d
integer beginy = 380
integer endy = 380
end type

type ln_2 from w_com010_d`ln_2 within w_51037_d
integer beginy = 384
integer endy = 384
end type

type dw_body from w_com010_d`dw_body within w_51037_d
integer y = 400
integer width = 3598
integer height = 1612
string dataobject = "d_51037_d01"
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

event dw_body::constructor;call super::constructor;DataWindowChild idw_grp
This.GetChild("inter_cd", idw_grp)
idw_grp.SetTransObject(SQLCA)
idw_grp.Retrieve('094')


end event

type dw_print from w_com010_d`dw_print within w_51037_d
integer x = 2601
integer y = 152
string dataobject = "d_51037_r01"
end type

