$PBExportHeader$w_12a13_e.srw
$PBExportComments$디자인실_부자재등록
forward
global type w_12a13_e from w_com020_e
end type
type dw_99 from datawindow within w_12a13_e
end type
type cb_balju from commandbutton within w_12a13_e
end type
type cb_1 from commandbutton within w_12a13_e
end type
type cb_3 from commandbutton within w_12a13_e
end type
type dw_master from datawindow within w_12a13_e
end type
type cbx_pop from checkbox within w_12a13_e
end type
type cb_5 from commandbutton within w_12a13_e
end type
type cb_smat from commandbutton within w_12a13_e
end type
type cb_order from commandbutton within w_12a13_e
end type
type dw_9 from datawindow within w_12a13_e
end type
end forward

global type w_12a13_e from w_com020_e
integer width = 3689
integer height = 2244
boolean righttoleft = true
event ue_first_open ( )
dw_99 dw_99
cb_balju cb_balju
cb_1 cb_1
cb_3 cb_3
dw_master dw_master
cbx_pop cbx_pop
cb_5 cb_5
cb_smat cb_smat
cb_order cb_order
dw_9 dw_9
end type
global w_12a13_e w_12a13_e

type variables
string is_brand, is_style, is_chno, is_order_id, is_dsgn_emp, is_season, is_year
Boolean ib_read[]
DataWindowChild idw_brand, idw_color, idw_size, idw_empno, idw_shop_cd, idw_spec_fg, idw_spec_cd, idw_fabric_by
end variables

forward prototypes
public function integer wf_style_chk (string as_style, string as_chno, ref string as_year, ref string as_season, ref string as_sojae, ref string as_item, ref string as_st_cust_cd, ref string as_st_cust_nm, ref string as_mat_cust_cd, ref string as_mat_cust_nm, ref string as_mat_cd, ref string as_mat_nm, ref decimal adc_tag_price)
public subroutine wf_mat_info_set (long al_row, string as_mat_cd)
public function boolean wf_mat_stock (string as_mat_cd, string as_color, string as_spec, decimal adc_stock_qty, decimal adc_resv_qty)
public function boolean wf_mat_cd_chk (string as_mat_cd)
public function integer wf_get_pcs_exp (string as_color)
public function long wf_get_pcs (string as_color)
end prototypes

event ue_first_open();/*------------------------------------------------------------*/
/* 내        용  : 기본 WINDOW를 Open한다. 'W_CU100_e04'      */
/*------------------------------------------------------------*/
Window lw_window

lw_window = This
gf_open_sheet(lw_window, 'W_21004_e', '부자재발주등록')


end event

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

public subroutine wf_mat_info_set (long al_row, string as_mat_cd);String ls_patt_type, ls_OrgMat_Cd, ls_country_cd, ls_patt_chk, ls_OrgMat_chk
String ls_mat_fg
IF is_chno <> '0' AND  is_chno <> 'S' THEN
	RETURN 
END IF

ls_mat_fg = dw_body.GetitemString(al_row, "mat_fg") 
IF ls_mat_fg <> 'A' THEN RETURN 

ls_patt_chk = dw_master.GetitemString(1, "patt_type")
IF isnull(ls_patt_chk) OR Trim(ls_patt_chk) = "" THEN
   select Patt_Type    ,  country_cd
     into :ls_patt_type,  :ls_country_cd
     from tb_21010_m 
    where mat_cd = :as_mat_cd ;
   IF LenA(ls_patt_type) > 0 THEN
      dw_master.Setitem(1, "patt_type", ls_patt_type) 
	END IF
   IF LenA(ls_country_cd) > 0 THEN
	   dw_master.Setitem(1, "country_cd", ls_country_cd)
	END IF
END IF 

ls_orgmat_chk = dw_master.GetitemString(1, "orgmat_cd")
IF isnull(ls_OrgMat_Cd) OR Trim(ls_OrgMat_Cd) = "" THEN
   select top 1 OrgMat_Cd
     into :ls_OrgMat_Cd
     from TB_21012_D 
    where mat_cd = :as_mat_cd
      and OrgMat_Rate = (select max(OrgMat_Rate)
                           from TB_21012_D
                         where mat_cd = :as_mat_cd) ; 
   IF LenA(ls_OrgMat_Cd) > 0 THEN
      dw_master.Setitem(1, "orgmat_cd", ls_OrgMat_Cd)								 
	END IF
END IF

end subroutine

public function boolean wf_mat_stock (string as_mat_cd, string as_color, string as_spec, decimal adc_stock_qty, decimal adc_resv_qty);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* 원자재 재고량 및 예약량  산출  */

  select isnull(max(b.spec),'XX'), 
         isnull(sum(a.stock_qty), 0), 
         isnull(sum(a.resv_qty), 0) 
	 into :as_spec, :adc_stock_qty, :adc_resv_qty 
    from vi_29012_1 a, 
         tb_21011_d b 
   where b.mat_cd = a.mat_cd 
     and b.color  = a.color 
     and a.mat_cd = :as_mat_cd
     and a.color  = :as_color 
	  and a.house  = '110000' ;
  
IF SQLCA.SQLCODE <> 0 THEN 
	MessageBox("SQL 오류", SQLCA.SqlErrText)
	RETURN FALSE
END IF

Return TRUE
end function

public function boolean wf_mat_cd_chk (string as_mat_cd);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* 품번 코드 CHECK  */
 
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_seq, ls_nm 

IF isnull(as_mat_cd) OR LenA(as_mat_cd) < 9 THEN Return False

// 브랜드 
ls_brand  = MidA(as_mat_cd, 1, 1)
IF gf_inter_nm('001', ls_brand, ls_nm) <> 0 THEN Return False 
// 소재
ls_sojae  = MidA(as_mat_cd, 5, 1)
IF gf_sojae_nm(ls_sojae, ls_nm) <> 0 THEN Return False 
//시즌년도 
ls_year   = MidA(as_mat_cd, 3, 1)
IF gf_inter_nm('002', ls_year, ls_nm) <> 0 THEN Return False 
// 시즌 
ls_season = MidA(as_mat_cd, 4, 1)
IF gf_inter_nm('003', ls_season, ls_nm) <> 0 THEN Return False 

// 순번 
ls_seq = MidA(as_mat_cd, 6, 4)
Return match(ls_seq, "[0-9][0-9][0-9][0-9]")

 
end function

public function integer wf_get_pcs_exp (string as_color);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* 색상별 기획량수 산출  */
String ls_exp

/* 'XX'는 전체 색상 */
IF as_color = 'XX' THEN
   ls_exp = "evaluate('SUM(ord_qty_exp)',0)"
ELSE
	ls_exp = "evaluate('sum(if(color = ~"" + as_color + "~", ord_qty_exp, 0))',0)" 
END IF

//Return Long(tab_1.tabpage_1.dw_1.Describe(ls_exp))
Return 0
end function

public function long wf_get_pcs (string as_color);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* 색상별 기획량수 산출  */
String ls_exp

/* 'XX'는 전체 색상 */
IF as_color = 'XX' THEN
   ls_exp = "evaluate('SUM(plan_qty)',0)"
ELSE
	ls_exp = "evaluate('sum(if(color = ~"" + as_color + "~", plan_qty, 0))',0)" 
END IF

//Return Long(tab_1.tabpage_1.dw_1.Describe(ls_exp))

return 0
end function

on w_12a13_e.create
int iCurrent
call super::create
this.dw_99=create dw_99
this.cb_balju=create cb_balju
this.cb_1=create cb_1
this.cb_3=create cb_3
this.dw_master=create dw_master
this.cbx_pop=create cbx_pop
this.cb_5=create cb_5
this.cb_smat=create cb_smat
this.cb_order=create cb_order
this.dw_9=create dw_9
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_99
this.Control[iCurrent+2]=this.cb_balju
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.dw_master
this.Control[iCurrent+6]=this.cbx_pop
this.Control[iCurrent+7]=this.cb_5
this.Control[iCurrent+8]=this.cb_smat
this.Control[iCurrent+9]=this.cb_order
this.Control[iCurrent+10]=this.dw_9
end on

on w_12a13_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_99)
destroy(this.cb_balju)
destroy(this.cb_1)
destroy(this.cb_3)
destroy(this.dw_master)
destroy(this.cbx_pop)
destroy(this.cb_5)
destroy(this.cb_smat)
destroy(this.cb_order)
destroy(this.dw_9)
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


il_rows =dw_list.retrieve(is_brand, is_style, is_chno, is_dsgn_emp)

IF il_rows < 1 THEN
	This.Trigger Event ue_insert()
else		
	dw_body.Reset()	
//	This.Trigger Event ue_retrieve()	
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)


end event

event type long ue_update();call super::ue_update;long i, ll_row_count, ll_seq_NO, ll_row_count_1, ll_cnt
sTRING LS_SEQ_NO, ls_yymmdd, ls_cbit, ls_abit, ls_bbit
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

IF dw_body.ModifiedCount() > 0 OR dw_body.Deletedcount() > 0 THEN
	for i = 1 to dw_body.rowcount()
		idw_status = dw_body.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record    */
			dw_body.Setitem(i, "style", is_style)
			dw_body.Setitem(i, "chno", is_chno)
			dw_body.Setitem(i, "mat_gubn",   '2')
			dw_body.Setitem(i, "brand",   is_brand)					
			dw_body.Setitem(i, "reg_id", gs_user_id)
			dw_body.Setitem(i, "reg_dt", ld_datetime)	
		ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
			dw_body.Setitem(i, "bf_reqqty",  dw_body.GetitemDecimal(i, "req_qty",  Primary!, TRUE))
			dw_body.Setitem(i, "bf_needqty", dw_body.GetitemDecimal(i, "t_need_qty", Primary!, TRUE))
			dw_body.Setitem(i, "mod_id", gs_user_id)
			dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF 
		dw_body.Setitem(i, "no",  String(i, "0000"))	
	next
end if

il_rows = dw_body.Update(TRUE, FALSE) 
if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12a13_e","0")
end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범) 				   									  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_head, "ScaleToRight")
//inv_resize.of_Register(dw_list, "ScaleToBottom")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
//inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(dw_99, "ScaleToBottom")
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
dw_master.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_99.SetTransObject(SQLCA)
dw_9.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)


/* DataWindow Head에 One Row 추가 */
//dw_head.InsertRow(0)
dw_list.InsertRow(0)
dw_body.InsertRow(0)
dw_master.InsertRow(0)
dw_99.InsertRow(0)




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

//dw_list.reset()
//dw_body.reset()
il_rows = dw_body.InsertRow(0)
//dw_1.Insertrow(0)


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return
END IF

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()	
end if


This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event pfc_postopen();call super::pfc_postopen;int i 

dw_99.Retrieve()
FOR i = 1 TO 6
    ib_read[i]  = false
NEXT

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
      else
         dw_head.SetFocus()
      end if

   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_list.Enabled = true
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_insert.enabled = false
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
         cb_insert.enabled = true
			cb_delete.enabled = true
      end if
END CHOOSE

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
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

type cb_close from w_com020_e`cb_close within w_12a13_e
end type

type cb_delete from w_com020_e`cb_delete within w_12a13_e
end type

type cb_insert from w_com020_e`cb_insert within w_12a13_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_12a13_e
end type

type cb_update from w_com020_e`cb_update within w_12a13_e
end type

type cb_print from w_com020_e`cb_print within w_12a13_e
end type

type cb_preview from w_com020_e`cb_preview within w_12a13_e
end type

type gb_button from w_com020_e`gb_button within w_12a13_e
end type

type cb_excel from w_com020_e`cb_excel within w_12a13_e
end type

type dw_head from w_com020_e`dw_head within w_12a13_e
integer x = 14
integer y = 152
integer width = 3584
integer height = 108
string dataobject = "d_12a13_h01"
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

type ln_1 from w_com020_e`ln_1 within w_12a13_e
integer beginy = 260
integer endy = 260
end type

type ln_2 from w_com020_e`ln_2 within w_12a13_e
integer beginy = 264
integer endy = 264
end type

type dw_list from w_com020_e`dw_list within w_12a13_e
integer x = 5
integer y = 280
integer width = 681
integer height = 1144
string dataobject = "D_12a13_D01"
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

il_rows = dw_body.retrieve(is_style, is_chno, gl_user_level)
//dw_body.retrieve(is_style, is_chno, gl_user_level)
dw_master.retrieve(is_style, is_chno)

is_year = dw_master.GetItemString(row, 'year')
is_season = dw_master.GetItemString(row, 'season')

IF il_rows <= 0 THEN
	dw_body.Reset()
	dw_body.insertrow(0)
elseif il_rows >= 1 then
	dw_body.retrieve(is_style, is_chno, gl_user_level)
END IF

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_e`dw_body within w_12a13_e
event type integer ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
integer x = 713
integer y = 268
integer width = 3227
integer height = 1736
string dataobject = "D_12a13_D02"
boolean vscrollbar = false
end type

event type integer dw_body::ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_mat_nm, ls_null, ls_cust_nm, ls_mat_cd, ls_mat_item
Boolean    lb_check 
DataStore  lds_Source
SetNull(ls_null)

CHOOSE CASE as_column
	CASE "mat_cd"				
			IF ai_div = 1 THEN 	
				IF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
					This.Setitem(al_row, "mat_nm", ls_mat_nm)
					This.Setitem(al_row, "mat_color", ls_null)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "부자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com_smat" 
			gsv_cd.gs_cd1   =is_brand
			gsv_cd.gs_cd2   =is_year
			gsv_cd.gs_cd3   =is_season
			gsv_cd.gs_cd4   =""	
			gsv_cd.gs_cd5   =as_data
			
		gst_cd.Item_where = " "

			lds_Source = Create DataStore
			OpenWithParm(W_COM201, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				This.SetRow(al_row)
				This.SetColumn(as_column)
				This.SetItem(al_row, "mat_fg", lds_Source.GetItemString(1,"mat_type"))
				This.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
				This.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))

				This.SetItem(al_row, "color", "XX")
				This.SetItem(al_row, "spec", "XX")
				This.SetItem(al_row, "mat_color", "XX")
            ib_changed = true
            cb_update.enabled = true
				/* 다음컬럼으로 이동 */
				This.SetColumn("req_qty")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "cust_cd"				
		
	 		ls_mat_cd = this.getitemstring(	al_row, "mat_cd" )
			ls_mat_item =  MidA(ls_mat_cd,5,1)
//			messagebox("ls_mat_cd", ls_mat_cd)			
//			messagebox("ls_mat_item", ls_mat_item)
			
			IF ai_div = 1 THEN 	
				if LenA(as_data) = 0 then				
				elseIF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
					this.Setitem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			
				gst_cd.default_where   = "Where change_gubn = '00'  " 
					
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%') and smat_gubn like  '%" + ls_mat_item + "%'   " 				
//				gst_cd.Item_where = "custcode LIKE '%" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				this.SetRow(al_row)
				this.SetColumn(as_column)
				this.SetItem(al_row, "cust_cd",    lds_Source.GetItemString(1,"custcode"))
				this.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				this.SetColumn("dlvy_ymd")
            ib_changed = true
            cb_update.enabled = true
				/* 다음컬럼으로 이동 */
				This.SetColumn("req_qty")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source		
			
	CASE "dlvy_ymd"				
		 	
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "납기일자 검색" 
			gst_cd.datawindow_nm   = "d_12010_day" 			
			gst_cd.default_where   = "	where t_date >= convert(char(08), dateadd(day, -2, getdate()),112) " 
			gst_cd.Item_where = " t_date <= convert(char(08), dateadd(day, 12, getdate()),112)"
		
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				this.SetRow(al_row)
				this.SetColumn(as_column)
				this.SetItem(al_row, "dlvy_ymd",  lds_Source.GetItemString(1,"t_date"))
				/* 다음컬럼으로 이동 */
            ib_changed = true
            cb_update.enabled = true
				/* 다음컬럼으로 이동 */
				This.SetColumn("req_qty")
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

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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
	CASE KeyDownArrow!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
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
		This.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

CHOOSE CASE ls_column_nm
	CASE "mat_color" 
		idw_color.Retrieve(This.Object.mat_cd[row])
END CHOOSE 
end event

event dw_body::dberror;//
end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child, ldw_color_3

This.GetChild("mat_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.retrieve('123')
ldw_child.SetFilter("inter_cd <> 'A'")
ldw_child.Filter()


This.GetChild("color", ldw_color_3)
ldw_color_3.SetTransObject(SQLCA)
ldw_color_3.retrieve()


/*
This.GetChild("mat_color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.insertRow(0)

This.GetChild("mat_color_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()
*/

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

event dw_body::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

This.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.08                                                  */	
/* 수정일      : 2001.01.08                                                  */
/*===========================================================================*/
String  ls_color, ls_mat_cd, ls_spec
Decimal ldc_stock_qty, ldc_resv_qty, ldc_need_qty, ldc_req_qty, ldc_need_qty_chn, ldc_t_need_qty, ldc_loss
	


ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false

CHOOSE CASE dwo.name
	CASE "mat_cd"
		IF ib_itemchanged THEN RETURN 1
		return This.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "cust_cd"
		IF ib_itemchanged THEN RETURN 1
		if LenA(data) <> 0 then
			return This.Trigger Event ue_Popup(dwo.name, row, data, 1)		
		end if	
	CASE "mat_color" 
		ls_mat_cd = This.GetitemString(row, "mat_cd")
		IF wf_mat_stock(ls_mat_cd, data, ls_spec, ldc_stock_qty, ldc_resv_qty) = FALSE THEN
         RETURN 1			
		END IF
		This.Setitem(row, "spec",      ls_spec)
		This.Setitem(row, "stock_qty", ldc_stock_qty)
		This.Setitem(row, "resv_qty",  ldc_resv_qty) 
	CASE "req_qty"
		ls_color = This.GetitemString(row, "color")
		ldc_loss = This.Getitemdecimal(row, "loss_qty")
		if isnull(ldc_loss) then ldc_loss = 0
		
		ldc_need_qty = Round(wf_Get_pcs(ls_color) * Dec(Data), 1)
		This.Setitem(row, "need_qty",   ldc_need_qty)
		This.Setitem(row, "t_need_qty", ldc_need_qty + ldc_loss)

		setnull(ldc_need_qty)
		ldc_need_qty = Round(wf_Get_pcs_exp(ls_color) * Dec(Data), 1)
		This.Setitem(row, "t_exp_qty", ldc_need_qty)

	CASE "loss_qty"
		ldc_loss = dec(Data)
		if isnull(ldc_loss) then ldc_loss = 0
		
		ls_color = This.GetitemString(row, "color")
		ldc_req_qty = this.Getitemnumber(row,"req_qty")
		if isnull(ldc_req_qty) then ldc_req_qty = 0

		ldc_need_qty = Round(wf_Get_pcs(ls_color) * Dec(ldc_req_qty),1) 
		if ldc_need_qty <> 0 then 
			ldc_t_need_qty = ldc_need_qty + ldc_loss
		else
			ldc_t_need_qty = ldc_need_qty
		end if		
		This.Setitem(row, "need_qty",   ldc_need_qty)
		This.Setitem(row, "t_need_qty", ldc_t_need_qty)

		setnull(ldc_t_need_qty)		
		ldc_need_qty_chn = Round(wf_Get_pcs_exp(ls_color) * Dec(ldc_req_qty),1)
		if ldc_need_qty <> 0 then 
			ldc_t_need_qty = ldc_need_qty_chn 
		else
			ldc_t_need_qty = ldc_need_qty_chn + ldc_loss
		end if
		This.Setitem(row, "t_exp_qty", ldc_t_need_qty)





END CHOOSE

end event

event dw_body::itemerror;call super::itemerror;return 1
end event

type st_1 from w_com020_e`st_1 within w_12a13_e
integer x = 690
integer y = 276
integer height = 1752
end type

type dw_print from w_com020_e`dw_print within w_12a13_e
integer x = 3031
integer y = 248
string dataobject = "D_12a12_l01"
end type

type dw_99 from datawindow within w_12a13_e
integer x = 5
integer y = 1684
integer width = 681
integer height = 316
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_12a13_d99"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
DataStore  lds_Source
String     ls_item, ls_null
Long       ll_row

IF row < 1 THEN RETURN 

Setnull(ls_null)

ls_item = This.GetitemString(row, "inter_cd")

gst_cd.ai_div          = 2 
gst_cd.window_title    = "부자재코드 검색" 
gst_cd.datawindow_nm   = "d_com_smat" 
gsv_cd.gs_cd1   =is_brand
gsv_cd.gs_cd2   =is_year
gsv_cd.gs_cd3   =is_season
gsv_cd.gs_cd4   =ls_item								
gsv_cd.gs_cd5   =""

lds_Source = Create DataStore

OpenWithParm(W_COM201, lds_Source)
IF Isvalid(Message.PowerObjectParm) THEN
	ib_itemchanged = True
	lds_Source = Message.PowerObjectParm
   ll_row = dw_body.insertRow(0)
	dw_body.SetRow(ll_row)
	dw_body.SetColumn("mat_cd") 
	IF lds_Source.GetItemString(1,"mat_item") = 'A' THEN 
	   dw_body.SetItem(ll_row, "mat_fg", 'C')
	ELSE
	   dw_body.SetItem(ll_row, "mat_fg", lds_Source.GetItemString(1,"mat_type"))
	END IF
	dw_body.SetItem(ll_row, "color",     "XX")
	dw_body.SetItem(ll_row, "mat_cd",    lds_Source.GetItemString(1,"mat_cd"))
	dw_body.SetItem(ll_row, "mat_nm",    lds_Source.GetItemString(1,"mat_nm"))
	dw_body.SetItem(ll_row, "mat_color", "XX")
	dw_body.SetItem(ll_row, "spec",      "XX")
	dw_body.SetItem(ll_row, "style",    is_style)
	dw_body.SetItem(ll_row, "chno",    is_chno)
	dw_body.SetItem(ll_row, "mat_gubn",    '2')
   ib_changed = true
   cb_update.enabled = true
	/* 다음컬럼으로 이동 */
	dw_body.ScrollToRow(ll_row)
	dw_body.SetFocus()
	dw_body.SetColumn("req_qty")
	
	if cbx_pop.checked = true then
		dw_body.Trigger Event ue_Popup("cust_cd", ll_row, MidA(is_style,1,1), 0)
		dw_body.Trigger Event ue_Popup("dlvy_ymd", ll_row, MidA(is_style,1,1), 0)	
	end if	
//	dw_10.retrieve()
//	dw_10.visible = true
	
	ib_itemchanged = False 
END IF

Destroy  lds_Source

end event

type cb_balju from commandbutton within w_12a13_e
integer x = 5
integer y = 1428
integer width = 681
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "발주 등록"
end type

event clicked;string ls_style, ls_level, ls_gubn
	gsv_cd.gs_cd10 = ""
	gsv_cd.gs_cd10 = is_style + is_chno
//	OpenWithParm (w_21004_e, "w_21004_e 발주서등록") 
	
//Trigger Event ue_first_open()
		
return il_rows

end event

type cb_1 from commandbutton within w_12a13_e
integer x = 5
integer y = 1512
integer width = 681
integer height = 84
integer taborder = 140
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "기본부자재 자동등록"
end type

event clicked;String ls_mat, ls_mat_cd, ls_mat_nm , ls_mat_type
Long   ll_pcs, ll_row 
decimal ldc_plan_qty_chn_all, ldc_ord_qty_exp_all

ls_mat = is_brand + '2' + MidA(is_style, 3, 1) + is_season
ll_pcs = wf_Get_Pcs("XX")

//ldc_plan_qty_chn_all = tab_1.tabpage_1.dw_1.GetitemDecimal(1, "plan_qty_chn_all") 
//ldc_ord_qty_exp_all  = tab_1.tabpage_1.dw_1.GetitemDecimal(1, "ord_qty_exp_all") 
ldc_plan_qty_chn_all = 0
ldc_ord_qty_exp_all  = 0

DECLARE MAT_LIST CURSOR FOR
//  SELECT mat_cd, mat_nm 
//    FROM dbo.SF_12010_LIST(:ls_mat) ;
  SELECT mat_cd, mat_nm, mat_type 
		 FROM TB_21000_M (nolock)
                WHERE MAT_CD   LIKE :ls_mat + '%' 
                  AND (MAT_TYPE =    '0'
						or   (mat_type = '5' and :ldc_ord_qty_exp_all <> 0) );


OPEN MAT_LIST;

FETCH MAT_LIST INTO :ls_mat_cd, :ls_mat_nm, :ls_mat_type;
DO WHILE sqlca.sqlcode = 0 
	ll_row = dw_body.find("mat_cd = '" + ls_mat_cd + "'", 1, dw_body.RowCount())
	IF ll_row = 0 THEN 
		ll_row = dw_body.insertRow(0)
		dw_body.Setitem(ll_row, "mat_fg",     ls_mat_type) 
		dw_body.Setitem(ll_row, "color",      "XX") 
		dw_body.Setitem(ll_row, "mat_cd",     ls_mat_cd) 
		dw_body.Setitem(ll_row, "mat_nm",     ls_mat_nm) 
		dw_body.Setitem(ll_row, "mat_color",  "XX") 
		dw_body.Setitem(ll_row, "spec",       "XX") 
		dw_body.Setitem(ll_row, "req_qty",    1) 
		dw_body.Setitem(ll_row, "need_qty",   ll_pcs) 
		dw_body.Setitem(ll_row, "t_need_qty", ll_pcs) 
      ib_changed = true
      cb_update.enabled = true
      cb_print.enabled = false
      cb_preview.enabled = false
	END IF
   FETCH MAT_LIST INTO :ls_mat_cd, :ls_mat_nm, :ls_mat_type;
LOOP

CLOSE MAT_LIST;




end event

type cb_3 from commandbutton within w_12a13_e
integer x = 5
integer y = 1596
integer width = 681
integer height = 84
integer taborder = 160
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "메인에서 카피"
end type

event clicked;string ls_style, ls_chno
ls_style = dw_head.getitemstring(1,"style_no")

ls_chno = MidA(ls_style,9,1)
ls_style = LeftA(ls_style,8)

	
	insert into tb_12025_d (
	style    ,
	chno ,
	mat_gubn, 
	no   ,
	mat_cd,     
	mat_color, 
	spec      ,      
	mat_fg ,
	bf_reqqty,    
	bf_needqty,   
	req_qty    ,  
	need_qty    , 
	loss_qty     ,
	t_need_qty   ,
	color ,
	brand ,
	reg_id ,
	reg_dt  ,                                               
	mod_id ,
	mod_dt   )                                             
	
	select 
	style    ,
	:ls_chno	as chno ,
	mat_gubn, 
	no   ,
	mat_cd,     
	mat_color, 
	spec      ,      
	mat_fg ,
	bf_reqqty,    
	bf_needqty,   
	req_qty    ,  
	req_qty*(select sum(isnull(ord_qty,plan_qty)) from tb_12030_s (nolock) where style = a.style and chno = :ls_chno and color like replace(a.color,'X','%') )	t_need_qty   ,
	null	loss_qty     ,
	req_qty*(select sum(isnull(ord_qty,plan_qty)) from tb_12030_s (nolock) where style = a.style and chno = :ls_chno and color like replace(a.color,'X','%') )	t_need_qty   ,
	color ,
	brand ,
	reg_id ,
	reg_dt  ,                                               
	mod_id ,
	mod_dt 
	 from tb_12025_d a(nolock)
	where style    = :ls_style
	and   chno     in ('0','S')
	and   mat_gubn = '2'
	and   not exists (select top 1 * from tb_12025_d (nolock) 
				where style = a.style
				and   chno  = :ls_chno
				and   mat_gubn = '2');

commit  USING SQLCA;			
			
dw_body.Retrieve(ls_style, ls_chno, gl_user_level)

end event

type dw_master from datawindow within w_12a13_e
integer x = 2245
integer y = 1164
integer width = 1280
integer height = 840
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_12010_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('003')

This.GetChild("sojae", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('%' ,gs_brand)
ldw_child.SetRedraw(false)
ldw_child.setFilter( " sojae <> 'O'");
ldw_child.Filter()
ldw_child.SetRedraw(true)


This.GetChild("zsojae", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('%',gs_brand)
ldw_child.SetRedraw(false)
//ldw_child.setFilter( " sojae <> 'A' and sojae <> 'B' and sojae <> 'C' and sojae <> 'D' and sojae <> 'Y' and sojae <> 'O'  ");
ldw_child.Filter()
ldw_child.SetRedraw(true)


This.GetChild("item", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve(gs_brand)
ldw_child.SetRedraw(false)
ldw_child.setFilter( " item <> '1' ");
ldw_child.Filter()
ldw_child.SetRedraw(true)

This.GetChild("zitem", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve(gs_brand)
ldw_child.SetRedraw(false)
ldw_child.setFilter( "item <> 'Z' and item <> 'X' and item <> '1' ");
ldw_child.Filter()
ldw_child.SetRedraw(true)


This.GetChild("make_type2", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('030')


This.GetChild("out_seq", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('010')

This.GetChild("out_seq_chn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('010')


This.GetChild("out_seq2", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('032')

This.GetChild("concept", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('122')

This.GetChild("patt_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('020')



This.GetChild("orgmat_cd2", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('021')



This.GetChild("country_cd2", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('000')

This.GetChild("pay_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('007')

This.GetChild("style_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('126')

this.getchild("fabric_by",idw_fabric_by)
idw_fabric_by.settransobject(sqlca)
idw_fabric_by.retrieve('214')



end event

type cbx_pop from checkbox within w_12a13_e
integer x = 3067
integer y = 168
integer width = 466
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "부자재팝업사용"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type cb_5 from commandbutton within w_12a13_e
integer x = 5
integer y = 2432
integer width = 681
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "탈부착부자재"
end type

event clicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
DataStore  lds_Source
String     ls_item, ls_null
Long       ll_row
decimal    ldc_need_qty

Setnull(ls_null)

gst_cd.ai_div          = 2 
gst_cd.window_title    = "부자재코드 검색" 
gst_cd.datawindow_nm   = "d_com913" 
gst_cd.default_where   = "where brand      = '" + is_brand + "'" + &
								"  and mat_year   = '" + is_year  + "'" + &
								"  and mat_season = '" + is_season + "'" + &
                        "  and mat_type   = '3' "  
gst_cd.Item_where = " 1 = 1 " //mat_item = '" + ls_item + "'"


lds_Source = Create DataStore

OpenWithParm(W_COM200, lds_Source)
IF Isvalid(Message.PowerObjectParm) THEN
	ib_itemchanged = True
	lds_Source = Message.PowerObjectParm
   ll_row = dw_body.insertRow(0)
	dw_body.SetRow(ll_row)
	dw_body.SetColumn("mat_cd") 
	IF lds_Source.GetItemString(1,"mat_item") = 'A' THEN 
	   dw_body.SetItem(ll_row, "mat_fg", 'C')
	ELSE
	   dw_body.SetItem(ll_row, "mat_fg", lds_Source.GetItemString(1,"mat_type"))
	END IF
	dw_body.SetItem(ll_row, "color",     "XX")
	dw_body.SetItem(ll_row, "mat_cd",    lds_Source.GetItemString(1,"mat_cd"))
	dw_body.SetItem(ll_row, "mat_nm",    lds_Source.GetItemString(1,"mat_nm"))
	dw_body.SetItem(ll_row, "mat_color", "XX")
	dw_body.SetItem(ll_row, "spec",      "XX")
	
	if cbx_pop.checked = true then
		dw_body.Trigger Event ue_Popup("cust_cd", ll_row, MidA(is_style,1,1), 0)
		dw_body.Trigger Event ue_Popup("dlvy_ymd", ll_row, MidA(is_style,1,1), 0)	
	end if	
	
//	tab_1.tabpage_4.dw_4.Trigger Event ue_Popup("cust_cd", ll_row, mid(is_style,1,1), 0)
//	tab_1.tabpage_4.dw_4.Trigger Event ue_Popup("dlvy_ymd", ll_row, mid(is_style,1,1), 0)		
		
   ib_changed = true
   cb_update.enabled = true
	/* 다음컬럼으로 이동 */
	dw_body.ScrollToRow(ll_row)
	dw_body.SetFocus()
	dw_body.SetColumn("req_qty")
	ib_itemchanged = False 
END IF

Destroy  lds_Source

end event

type cb_smat from commandbutton within w_12a13_e
event ue_rowcopy ( )
integer x = 5
integer y = 2516
integer width = 681
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "악세사리 기본부자재"
end type

event ue_rowcopy();long 		i, j, ll_row, ll_4
string 	ls_mat_cd
decimal 	ldc_need_qty
ll_4 = dw_body.rowcount()

for i = 1 to dw_9.rowcount()
	
	ls_mat_cd = dw_9.getitemstring(i,"mat_cd")
	ll_row = dw_body.find("mat_cd = '" + ls_mat_cd + "'", 1, ll_4 )

	if ll_row = 0 then 
		dw_body.insertrow(0)
		ll_4= ll_4 + 1
		dw_body.setitem(ll_4,"style",dw_9.getitemstring(i,"style"))
		dw_body.setitem(ll_4,"chno",dw_9.getitemstring(i,"chno"))
		dw_body.setitem(ll_4,"mat_cd",dw_9.getitemstring(i,"mat_cd"))
		dw_body.setitem(ll_4,"mat_nm",dw_9.getitemstring(i,"mat_nm"))
		dw_body.setitem(ll_4,"mat_gubn",dw_9.getitemstring(i,"mat_gubn"))
		dw_body.setitem(ll_4,"color",dw_9.getitemstring(i,"color"))
		dw_body.setitem(ll_4,"mat_color",dw_9.getitemstring(i,"mat_color"))
		dw_body.setitem(ll_4,"mat_fg",dw_9.getitemstring(i,"mat_fg"))
		dw_body.setitem(ll_4,"spec",dw_9.getitemstring(i,"spec"))
		
		dw_body.setitem(ll_4, "req_qty",      1)
		
		ldc_need_qty = Round(wf_Get_pcs('XX'), 1)
		dw_body.setitem(ll_4, "need_qty",   ldc_need_qty)
		dw_body.setitem(ll_4, "t_need_qty", ldc_need_qty)

		setnull(ldc_need_qty)
		ldc_need_qty = Round(wf_Get_pcs_exp('XX'), 1)
		dw_body.setitem(ll_4, "t_exp_qty", ldc_need_qty)		

end if			 

next 





end event

event clicked;long i, j, ll_row, ll_4
string ls_mat_cd
ll_4 = dw_body.rowcount()

dw_9.retrieve(is_style, is_chno)

//post event ue_rowcopy() 





end event

type cb_order from commandbutton within w_12a13_e
integer x = 5
integer y = 2604
integer width = 681
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "부자재 자동발주"
end type

event clicked;pointer oldpointer  // Declares a pointer variable
string ls_brand, ls_ord_ymd, ls_ord_origin
integer li_request

	ls_brand   = dw_master.getitemstring(1,"brand")
	ls_ord_ymd = string(now(),"yyyymmdd")	
	ls_ord_origin = dw_master.getitemstring(1,"style") + dw_master.getitemstring(1,"chno")
	
	messagebox("ls_brand",ls_brand)
	messagebox("ls_ord_ymd",ls_ord_ymd)
	messagebox("ls_ord_origin",ls_ord_origin)

	if messagebox("확인","실행하시겠습니다...?",Exclamation!,YesNoCancel!,1 ) <> 1 then return
	oldpointer = SetPointer(HourGlass!)
	
	
	DECLARE   SP_Auto_SmatOrder PROCEDURE FOR SP_Auto_SmatOrder
			@brand 	   = :ls_brand,
			@ord_ymd	   = :ls_ord_ymd,
			@ord_origin	= :ls_ord_origin,
			@reg_id		= :gs_user_id;
						
	EXECUTE SP_Auto_SmatOrder;	
	SetPointer(oldpointer)
	
	if SQLCA.sqlcode = -1 then
		messagebox("확인", "등록에 실패하였습니다..")
		rollback  USING SQLCA;
	else
		messagebox("확인","정상처리되었슴니다...")
		commit  USING SQLCA;
		
		li_request = MessageBox("확인", "발주서 등록화면을 보시겠습니까?", Exclamation!, OKCancel!, 2)

		IF li_request = 1 THEN		
		 	gsv_cd.gs_cd10 = ""
			gsv_cd.gs_cd10 = is_style + is_chno	
			Trigger Event ue_first_open()
		END IF
		
	end if	
	
	
	
		
end event

type dw_9 from datawindow within w_12a13_e
integer x = 1376
integer y = 1168
integer width = 480
integer height = 840
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_12a13_d10"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

