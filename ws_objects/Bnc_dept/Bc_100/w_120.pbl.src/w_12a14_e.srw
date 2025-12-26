$PBExportHeader$w_12a14_e.srw
$PBExportComments$스와치등록
forward
global type w_12a14_e from w_com020_e
end type
end forward

global type w_12a14_e from w_com020_e
integer width = 3694
integer height = 2244
end type
global w_12a14_e w_12a14_e

type variables
string is_brand, is_style, is_chno, is_order_id, is_dsgn_emp

DataWindowChild idw_brand, idw_color, idw_size, idw_empno, idw_shop_cd, idw_spec_fg, idw_spec_cd
end variables

forward prototypes
public function integer wf_style_chk (string as_style, string as_chno, ref string as_year, ref string as_season, ref string as_sojae, ref string as_item, ref string as_st_cust_cd, ref string as_st_cust_nm, ref string as_mat_cust_cd, ref string as_mat_cust_nm, ref string as_mat_cd, ref string as_mat_nm, ref decimal adc_tag_price)
end prototypes

public function integer wf_style_chk (string as_style, string as_chno, ref string as_year, ref string as_season, ref string as_sojae, ref string as_item, ref string as_st_cust_cd, ref string as_st_cust_nm, ref string as_mat_cust_cd, ref string as_mat_cust_nm, ref string as_mat_cd, ref string as_mat_nm, ref decimal adc_tag_price);
SELECT A.YEAR, A.SEASON, A.SOJAE, A.ITEM,
       A.CUST_CD AS ST_CUST_CD,  dbo.sf_cust_nm(A.CUST_CD, 'S') AS ST_CUST_NM,
       B.CUST_CD AS MAT_CUST_CD, dbo.sf_cust_nm(B.CUST_CD, 'S') AS MAT_CUST_NM, 
		 B.MAT_CD, B.MAT_NM, A.TAG_PRICE
  INTO :as_year, :as_season, :as_sojae, :as_item,
       :as_st_cust_cd,  :as_st_cust_nm,
       :as_mat_cust_cd, :as_mat_cust_nm,
		 :as_mat_cd, :as_mat_nm, :adc_tag_price
  FROM VI_12020_1 A,
       TB_21010_M B
 WHERE A.MAT_CD *= B.MAT_CD
   AND A.STYLE = :as_style
   AND A.CHNO  = :as_chno
;

IF ISNULL(as_st_cust_cd) THEN RETURN 100

RETURN sqlca.sqlcode  


end function

on w_12a14_e.create
call super::create
end on

on w_12a14_e.destroy
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
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = ""then
	is_style = '%'
//   MessageBox(ls_title,"Style를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("style")
//	return false
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = ""then
	is_chno = '%'
//   MessageBox(ls_title,"Style를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("style")
//	return false
end if

is_dsgn_emp = Trim(dw_head.GetItemString(1, "dsgn_emp"))
if IsNull(is_dsgn_emp) or is_dsgn_emp = "" then
	is_dsgn_emp = '%'
end if

return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);string     ls_emp_nm, ls_null, ls_style_no, ls_emp_nm_d, ls_emp_nm_p, ls_emp_nm_t, ls_style, ls_chno
long       ll_qty, ll_cnt, ll_cnt_1
Boolean    lb_check
DataStore  lds_Source

dw_head.AcceptText() 
is_brand = dw_head.GetItemString(1, "brand")

SetNull(ls_null)
CHOOSE CASE as_column

	CASE "style_no"				
		   ls_style = MidA(as_data, 1, 8)
			ls_chno  = MidA(as_data, 9, 1)
						
			IF ai_div = 1 THEN 	
				IF gf_style_chk(ls_style, ls_chno) THEN
						if gs_brand <> "K" then						
							RETURN 0
						else 
							if gs_brand <> MidA(as_data,1,1) then
								Return 1
							else 
								RETURN 0
							end if	
						end if	
				end if				
				
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = ""
			
			if gs_brand <> "K" then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + ls_style + "%' and style like 'K%' "
				ELSE
					gst_cd.Item_where = "style like 'K%'"
				END IF
				
			end if	
			
//			
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"
//			ELSE
//				gst_cd.Item_where = ""
//			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))

//				cb_2.enabled = true				 				
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "dsgn_emp"		
			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then  return 1
				if gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
					dw_head.Setitem(al_row, "dsgn_emp", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			/* 관련부서 산출 */ 		
			if MidA(is_style, 1, 1) = 'O' then 
		   	gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('O000')" 
			end if
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(empno LIKE '" + as_data + "%' OR " + & 
				                    " kname LIKE '" + as_data + "%' )" 
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
				dw_head.SetItem(al_row, "dsgn_emp",    lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "dsgn_emp_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source

	CASE "empno_d"		
			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then  return 1
				if gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
					dw_body.Setitem(al_row, "d_empno", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			/* 관련부서 산출 */ 		
			if MidA(is_style, 1, 1) = 'O' then 
		   	gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('O000')" 
			end if
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(empno LIKE '" + as_data + "%' OR " + & 
				                    " kname LIKE '" + as_data + "%' )" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "d_empno",    lds_Source.GetItemString(1,"empno"))
				dw_body.SetItem(al_row, "d_empnm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
			
	CASE "empno_p"		
			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then  return 1
				if gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
					dw_body.Setitem(al_row, "p_empno", ls_emp_nm_p)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			/* 관련부서 산출 */ 		
			if MidA(is_style, 1, 1) = 'O' then 
		   	gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('P000')" 
			end if
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(empno LIKE '" + as_data + "%' OR " + & 
				                    " kname LIKE '" + as_data + "%' )" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "p_empno",    lds_Source.GetItemString(1,"empno"))
				dw_body.SetItem(al_row, "p_empnm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source

	CASE "empno_t"		
			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then  return 1
				if gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
					dw_body.Setitem(al_row, "t_empno", ls_emp_nm_t)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			/* 관련부서 산출 */ 		
			if MidA(is_style, 1, 1) = 'O' then 
		   	gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('S200')" 
			end if
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(empno LIKE '" + as_data + "%' OR " + & 
				                    " kname LIKE '" + as_data + "%' )" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "t_empno",    lds_Source.GetItemString(1,"empno"))
				dw_body.SetItem(al_row, "t_empnm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
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

event ue_retrieve();/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows =dw_list.retrieve(is_style, is_chno, is_dsgn_emp)

IF il_rows < 1 THEN
	This.Trigger Event ue_insert()
else		
	dw_body.Reset()	
	This.Trigger Event ue_retrieve()
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)


end event

event type long ue_update();call super::ue_update;long i, ll_row_count, ll_seq_NO, ll_row_count_1, ll_cnt
sTRING LS_SEQ_NO, ls_yymmdd, ls_cbit, ls_abit, ls_bbit, ls_uid, ls_uid_d, ls_order_id, ls_no
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


idw_status = dw_body.GetItemStatus(i, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */

	dw_body.Setitem(i, "reg_id", gs_user_id)
	dw_body.Setitem(i, "reg_dt", ld_datetime)
ELSEIF idw_status = DataModified! THEN		/* Modify Record */
	dw_body.Setitem(i, "mod_id", gs_user_id)
	dw_body.Setitem(i, "mod_dt", ld_datetime)
END IF


il_rows = dw_body.Update(TRUE, FALSE) 
if il_rows = 1 then
//   dw_body.ResetUpdate()
   commit  USING SQLCA;
//	This.Trigger Event ue_retrieve()
//	This.Trigger Event ue_insert()
else
   rollback  USING SQLCA;
end if


//This.Trigger Event ue_retrieve()
//This.Trigger Event ue_insert()

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12a11_e","0")
end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범) 				   									  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToBottom")
//inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_body, "ScaleToRight")
//inv_resize.of_Register(dw_1, "ScaleToBottom")
inv_resize.of_Register(st_1, "ScaleToBottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

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
//dw_head.InsertRow(0)
dw_list.InsertRow(0)
dw_body.InsertRow(0)
//dw_1.InsertRow(0)

end event

event open;call super::open;datetime ld_datetime
String ls_yymmdd

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

//ls_yymmdd = string(ld_datetime, "YYYYMM")

//dw_head.setitem(1, "empno", gs_user_id)
//dw_head.InsertRow(0)
dw_head.setitem(1, "brand", 'O')


end event

event ue_insert();datetime ld_datetime
String ls_yymmdd, ls_spec_fg, ls_spec_cd
long ll_cnt, ll_row_1, i

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */

IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
END IF

dw_list.reset()
dw_body.reset()
il_rows = dw_body.InsertRow(0)
//dw_1.Insertrow(0)


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return
END IF
/*
	select count(inter_cd)
	into   :ll_row_1
	from   tb_91011_c
	where  inter_grp = '128';
		
	for i = 1 to ll_row_1
		dw_1.insertRow(0)
		
		SELECT inter_cd1, inter_cd
		into   :ls_spec_fg, :ls_spec_cd
		FROM   tb_91011_c (nolock)
		WHERE inter_grp = "128"	
				and sort_seq = :i;				
				
		dw_1.Setitem(i, "spec_fg",   ls_spec_fg) 
		dw_1.Setitem(i, "spec_cd",   ls_spec_cd) 
	next
*/
/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()	
end if




This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

type cb_close from w_com020_e`cb_close within w_12a14_e
end type

type cb_delete from w_com020_e`cb_delete within w_12a14_e
end type

type cb_insert from w_com020_e`cb_insert within w_12a14_e
boolean visible = false
boolean enabled = true
string text = "신규(&A)"
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_12a14_e
end type

type cb_update from w_com020_e`cb_update within w_12a14_e
end type

type cb_print from w_com020_e`cb_print within w_12a14_e
end type

type cb_preview from w_com020_e`cb_preview within w_12a14_e
end type

type gb_button from w_com020_e`gb_button within w_12a14_e
end type

type cb_excel from w_com020_e`cb_excel within w_12a14_e
end type

type dw_head from w_com020_e`dw_head within w_12a14_e
integer x = 14
integer y = 152
integer width = 3584
integer height = 108
string dataobject = "d_12a14_h01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')



end event

event dw_head::itemchanged;CHOOSE CASE dwo.name	
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE


end event

event dw_head::ue_keydown;call super::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		// Column.Protect = True Then Return
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
								
//		Choose Case ls_column_name
//			Case "person_nm_h"
//				ls_column_name = "custom_h"
//		End Choose
		ls_column_name = "person_nm_h"
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_12a14_e
integer beginy = 260
integer endy = 260
end type

type ln_2 from w_com020_e`ln_2 within w_12a14_e
integer beginy = 264
integer endy = 264
end type

type dw_list from w_com020_e`dw_list within w_12a14_e
integer x = 5
integer y = 280
integer width = 681
integer height = 1720
string dataobject = "D_12a14_D01"
end type

event dw_list::clicked;call super::clicked;

IF row <= 0 THEN Return
/*
IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
*/
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_style = This.GetItemString(row, 'style') /* DataWindow에 Key 항목을 가져온다 */
is_chno  = This.GetItemString(row, 'chno') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_style) or IsNull(is_chno)  THEN return

il_rows = dw_body.retrieve(is_style, is_chno)

IF il_rows <= 0 THEN
	dw_body.Reset()
	dw_body.Insertrow(0)
	dw_body.Setitem(1,'style', is_style)
	dw_body.setitem(1,'chno', is_chno)
END IF
		
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_e`dw_body within w_12a14_e
integer x = 713
integer y = 268
integer width = 3429
integer height = 1940
string dataobject = "D_12a14_D02"
boolean vscrollbar = false
end type

event dw_body::itemchanged;call super::itemchanged;string ls_column_nm, ls_style_no, ls_color
dw_body.accepttext()
ls_column_nm = This.GetColumnName()
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE ls_column_nm
	CASE "yymmdd"
    IF gf_datechk(data) = False THEN Return 1
	CASE "empno_d","empno_p","empno_t", "style_no"     //  Popup 검색창이 존재하는 항목 		
//	CASE "person_nm", "style_no", "shop_cd"     //  Popup 검색창이 존재하는 항목 		
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	case "color"
			dw_body.setitem(1,'size','')
			ls_style_no = dw_body.getitemstring(1,"style_no")
			ls_color = dw_body.getitemstring(1,"color")
			
			dw_body.GetChild("size", idw_size)
			idw_size.SetTransObject(SQLCA)
			idw_size.Retrieve(LeftA(ls_style_no, 8), MidA(ls_style_no, 9, 1),ls_color)

			
END CHOOSE

end event

event dw_body::ue_keydown;String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		If dw_body.GetColumnName() = 'first_counsel' OR dw_body.GetColumnName() = 'first_result' OR dw_body.GetColumnName() = 'second_counsel' OR dw_body.GetColumnName() = 'second_result' Then
			RETURN 0
		else  
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		END IF	
		
	
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0 
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0 
								
//		Choose Case ls_column_name
//			Case "card_no", "jumin_NO", "PERSON_nm"
//				ls_column_name = "custom"
//		End Choose
		ls_column_name = 'PERSON_nm'
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::itemfocuschanged;string ls_column_nm, ls_style_no, ls_color, ls_datetime, ls_first, ls_second, ls_third, ls_abit, ls_bbit
String ls_tag, ls_helpMsg
datetime ld_datetime

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)
this.accepttext()
This.SelectText(1, 3000)

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return
END IF
ls_datetime = string(ld_datetime, "YYYYMMDDHHMMSS")

CHOOSE CASE ls_column_nm
//	CASE "color"
//		ls_style_no = This.GetItemString(row, "style_no")
//		idw_color.Retrieve(Left(ls_style_no, 8), Mid(ls_style_no, 9, 1))
//		idw_color.InsertRow(1)
//		idw_color.SetItem(1, "color", '')
//		idw_color.SetItem(1, "color_enm", '')
//		
//	CASE "size"		
//		ls_style_no = This.GetItemString(row, "style_no")
//		ls_color    = This.GetItemString(row, "color"   )
//		idw_size.Retrieve(Left(ls_style_no, 8), Mid(ls_style_no, 9, 1), ls_color)
//		idw_size.InsertRow(1)
//		idw_size.SetItem(1, "size", '')
//		idw_size.SetItem(1, "size_nm", '')

	case "first_counsel"
		ls_first = dw_body.getitemstring(1,'first_counsel')
		if isnull(ls_first) or trim(ls_first) = '' then
			dw_body.setitem(1, "first_time", ld_datetime)
		end if

	case "second_counsel"
		ls_second = dw_body.getitemstring(1,'second_counsel')
		if isnull(ls_second) or trim(ls_second) = '' then
			dw_body.setitem(1, "second_time", ld_datetime)
		end if
		
	case "third_counsel"
		ls_third = dw_body.getitemstring(1,'third_counsel')
		if isnull(ls_third) or trim(ls_third) = '' then
			dw_body.setitem(1, "third_time", ld_datetime)
		end if
	
END CHOOSE

end event

event dw_body::dberror;//
end event

type st_1 from w_com020_e`st_1 within w_12a14_e
integer x = 690
integer y = 276
integer height = 1752
end type

type dw_print from w_com020_e`dw_print within w_12a14_e
integer x = 3031
integer y = 248
string dataobject = "D_12a12_l01"
end type

