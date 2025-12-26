$PBExportHeader$w_51033_d.srw
$PBExportComments$매장파트타임 근태/집행 현황
forward
global type w_51033_d from w_com010_d
end type
end forward

global type w_51033_d from w_com010_d
integer width = 3680
integer height = 2244
end type
global w_51033_d w_51033_d

type variables
DataWindowChild	idw_brand
String is_brand, is_empno, is_fr_yymm, is_to_yymm, is_gubn
end variables

on w_51033_d.create
call super::create
end on

on w_51033_d.destroy
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


is_empno = dw_head.GetItemString(1, "empno_h")
if IsNull(is_empno) or Trim(is_empno) = "" then
   is_empno = '%'
end if

is_fr_yymm = dw_head.GetItemString(1, "fr_yymm")
if IsNull(is_fr_yymm) or Trim(is_fr_yymm) = "" then
   MessageBox(ls_title,"근무 시작월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymm")
   return false
end if

is_to_yymm = dw_head.GetItemString(1, "to_yymm")
if IsNull(is_to_yymm) or Trim(is_to_yymm) = "" then
   MessageBox(ls_title,"근무 종료월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   return false
end if

is_gubn = dw_head.GetItemString(1, "gubn")
if IsNull(is_gubn) or Trim(is_gubn) = "" then
   is_gubn = '%'
end if

return true

end event

event open;call super::open;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.setitem(1, "fr_yymm", string(ld_datetime, "YYYYMM"))
dw_head.setitem(1, "to_yymm", string(ld_datetime, "YYYYMM"))
dw_head.setitem(1, "gubn", 'Y')


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_51033_d","0")
end event

event ue_retrieve();call super::ue_retrieve;decimal ld_plan, ld_amt, ld_s2
string ls_fr_yymm, ls_to_yymm

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_empno, is_fr_yymm, is_to_yymm, is_gubn)

ls_fr_yymm = MidA(is_fr_yymm,1,4) + '.' + MidA(is_fr_yymm,5,2)
ls_to_yymm = MidA(is_to_yymm,1,4) + '.' + MidA(is_to_yymm,5,2)

select sum(goal) * 1000
  into :ld_plan
from mis.dbo.acc_plan with (nolock)
where yymm between :ls_fr_yymm and :ls_to_yymm
	and mgr_cost_type = '43109'
	and dept_code like :is_brand + '900'
	and left(dept_code,1) in ('N','O');


select	sum(b.slip_cha_amt) amt
  into	:ld_amt
from		mis.dbo.tat01m a, mis.dbo.tat01d b, mis.dbo.tab01 c
where		a.slip_appl_code like :is_brand + '900'
			and left(a.slip_appl_code,1) in ('N','O')
			and substring(a.slip_date,1,7) between :ls_fr_yymm and :ls_to_yymm
			and a.slip_bonji = b.slip_bonji
			and a.slip_date  = b.slip_date
			and a.slip_no    = b.slip_no
			and b.acc_code   = c.acc_code			
			and c.acc_code   = '43109'
			and c.cust_cha   = '1';

ld_s2 = dw_body.getitemnumber(1, 'compute_4')

dw_head.setitem(1,'s_1', ld_plan)
dw_head.setitem(1,'s_2', ld_s2)
dw_head.setitem(1,'s_3', ld_plan - ld_s2)
dw_head.setitem(1,'m_1', ld_plan)
dw_head.setitem(1,'m_2', ld_amt)
dw_head.setitem(1,'m_3', ld_plan - ld_amt)
dw_head.setitem(1,'total_1', ld_plan - ld_plan)
dw_head.setitem(1,'total_2', ld_s2 - ld_amt)
dw_head.setitem(1,'total_3', (ld_plan - ld_s2) - (ld_plan - ld_amt))


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
            "t_s_1.Text = '" + string(dw_head.getitemnumber(1,'s_1'),'#,###') + "'" + &
				"t_s_2.Text = '" + string(dw_head.getitemnumber(1,'s_2'),'#,###') + "'" + &
				"t_s_3.Text = '" + string(dw_head.getitemnumber(1,'s_3'),'#,###') + "'" + &
				"t_m_1.Text = '" + string(dw_head.getitemnumber(1,'m_1'),'#,###') + "'" + &
				"t_m_2.Text = '" + string(dw_head.getitemnumber(1,'m_2'),'#,###') + "'" + &
				"t_m_3.Text = '" + string(dw_head.getitemnumber(1,'m_3'),'#,###') + "'" + &
				"t_total_1.Text = '" + string(dw_head.getitemnumber(1,'total_1'),'#,###') + "'" + &
				"t_total_2.Text = '" + string(dw_head.getitemnumber(1,'total_2'),'#,###') + "'" + &
				"t_total_3.Text = '" + string(dw_head.getitemnumber(1,'total_3'),'#,###') + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'"

dw_print.Modify(ls_modify)


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

	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				If IsNull(as_data) or as_data = "" Then
					dw_body.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
			END IF
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com918" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
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
					dw_body.SetRow(al_row)
					dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_body.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("tel1")
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
					dw_head.SetItem(al_row, "emp_nm_h", "")
					RETURN 0
				END IF 
			END IF
			
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "영업부 사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 	
		
				gst_cd.default_where   = " WHERE DEPT_CODE in ( '5000','5200','K000','K120','T400','R400','X100') " + &
								 "   AND GOOUT_GUBN = '1' "

	//		end if	
				
	
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

type cb_close from w_com010_d`cb_close within w_51033_d
end type

type cb_delete from w_com010_d`cb_delete within w_51033_d
end type

type cb_insert from w_com010_d`cb_insert within w_51033_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_51033_d
end type

type cb_update from w_com010_d`cb_update within w_51033_d
end type

type cb_print from w_com010_d`cb_print within w_51033_d
end type

type cb_preview from w_com010_d`cb_preview within w_51033_d
end type

type gb_button from w_com010_d`gb_button within w_51033_d
end type

type cb_excel from w_com010_d`cb_excel within w_51033_d
end type

type dw_head from w_com010_d`dw_head within w_51033_d
integer x = 9
integer y = 160
integer width = 3584
integer height = 452
string dataobject = "d_51033_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertrow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')
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

type ln_1 from w_com010_d`ln_1 within w_51033_d
integer beginy = 612
integer endy = 612
end type

type ln_2 from w_com010_d`ln_2 within w_51033_d
integer beginy = 616
integer endy = 616
end type

type dw_body from w_com010_d`dw_body within w_51033_d
integer y = 632
integer width = 3598
integer height = 1380
string dataobject = "d_51033_d01"
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
	 
	CASE "shop_cd"	//  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		

END CHOOSE

end event

type dw_print from w_com010_d`dw_print within w_51033_d
integer x = 2450
integer y = 364
integer width = 1024
integer height = 368
string dataobject = "d_51033_r01"
end type

