$PBExportHeader$w_12020_d.srw
$PBExportComments$작업 지시서조회
forward
global type w_12020_d from w_com010_e
end type
type cb_del_all from commandbutton within w_12020_d
end type
type dw_master from datawindow within w_12020_d
end type
type dw_spec from datawindow within w_12020_d
end type
type dw_detail from datawindow within w_12020_d
end type
type cb_2 from commandbutton within w_12020_d
end type
type dw_label from datawindow within w_12020_d
end type
type tab_1 from tab within w_12020_d
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tabpage_4 from userobject within tab_1
end type
type cb_3 from commandbutton within tabpage_4
end type
type cb_1 from commandbutton within tabpage_4
end type
type dw_99 from datawindow within tabpage_4
end type
type dw_4 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
cb_3 cb_3
cb_1 cb_1
dw_99 dw_99
dw_4 dw_4
end type
type tabpage_5 from userobject within tab_1
end type
type dw_5 from datawindow within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_5 dw_5
end type
type tabpage_6 from userobject within tab_1
end type
type dw_6 from datawindow within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_6 dw_6
end type
type tabpage_8 from userobject within tab_1
end type
type dw_8 from datawindow within tabpage_8
end type
type tabpage_8 from userobject within tab_1
dw_8 dw_8
end type
type tabpage_7 from userobject within tab_1
end type
type dw_11 from datawindow within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_11 dw_11
end type
type tab_1 from tab within w_12020_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_8 tabpage_8
tabpage_7 tabpage_7
end type
type dw_7 from datawindow within w_12020_d
end type
type cb_sketch from commandbutton within w_12020_d
end type
end forward

global type w_12020_d from w_com010_e
integer width = 3707
integer height = 2224
cb_del_all cb_del_all
dw_master dw_master
dw_spec dw_spec
dw_detail dw_detail
cb_2 cb_2
dw_label dw_label
tab_1 tab_1
dw_7 dw_7
cb_sketch cb_sketch
end type
global w_12020_d w_12020_d

type variables
String  is_style, is_chno, is_brand, is_year, is_season, is_sojae, is_item , is_country_cd, is_make_type, is_orgmat_cd, is_out_seq, is_out_seq2, is_brand_nm
String  is_size[]
Boolean ib_read[]
DataWindowChild idw_color, idw_color_3, idw_color_4 , idw_style_type
end variables

forward prototypes
public function boolean wf_style_chk (string as_style)
public subroutine wf_display_spec ()
public subroutine wf_save_spec ()
public subroutine wf_set_size ()
public function boolean wf_resv_update (ref string as_errmsg)
public function boolean wf_mat_stock (string as_mat_cd, string as_color, ref string as_spec, ref decimal adc_stock_qty, ref decimal adc_resv_qty)
public subroutine wf_set_color (integer ai_index)
public subroutine wf_mat_info_set (long al_row, string as_mat_cd)
public function long wf_get_pcs (string as_color)
public function integer wf_get_pcs_exp (string as_color)
public function boolean wf_del_check (long al_row, datawindow adw_temp)
public function boolean wf_tab_update (datetime adt_datetime, ref string as_errmsg)
public subroutine wf_tab_retrieve (integer ai_index)
end prototypes

public function boolean wf_style_chk (string as_style);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* 품번 코드 CHECK  */
 
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_seq, ls_nm 

IF isnull(as_style) OR LenA(as_style) <> 9 THEN Return False

// 브랜드 
ls_brand  = MidA(as_style, 1, 1)
IF gf_inter_nm('001', ls_brand, ls_nm) <> 0 THEN Return False 
// 소재
ls_sojae  = MidA(as_style, 2, 1)
IF gf_sojae_nm(ls_sojae, ls_nm) <> 0 THEN Return False 
//시즌년도 
ls_year   = MidA(as_style, 3, 1)
IF gf_inter_nm('002', ls_year, ls_nm) <> 0 THEN Return False 
// 시즌 
ls_season = MidA(as_style, 4, 1)
IF gf_inter_nm('003', ls_season, ls_nm) <> 0 THEN Return False 
// 품종 
ls_item = MidA(as_style, 5, 1)
IF gf_item_nm(ls_item, ls_nm) <> 0 THEN Return False 

// 순번 
ls_seq = MidA(as_style, 6, 3)
Return match(ls_seq, "[0-9][0-9][0-9]")

 
end function

public subroutine wf_display_spec ();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/* dw_spec에있는 내역을 tab_1.tabpage_2.dw_2 로 이관                         */
/*===========================================================================*/
String ls_spec_fg, ls_spec_cd, ls_size, ls_find 
Long   i, j, k,   ll_max      
Long   ll_RowCnt, ll_row 

ll_RowCnt = dw_spec.RowCount()
IF ll_RowCnt < 1 THEN RETURN

/* 사이즈 갯수 (wf_set_size에서 정의됨)*/
ll_max = UpperBound(is_size)    

/* display 용 datawindow 초기화 후 셋팅 */
tab_1.tabpage_2.dw_2.Reset()
FOR i = ll_RowCnt TO 1 STEP -1
	ls_spec_fg = dw_spec.GetitemString(i, "spec_fg") 
	ls_spec_cd = dw_spec.GetitemString(i, "spec_cd") 
	ls_size    = dw_spec.GetitemString(i, "size") 
	ls_find    = "spec_fg = '" + ls_spec_fg + "' and spec_cd = '" + ls_spec_cd + "'"
	ll_row = tab_1.tabpage_2.dw_2.find(ls_find, 1, tab_1.tabpage_2.dw_2.RowCount())
	IF ll_row < 0 THEN 
		RETURN 
	ELSEIF ll_row = 0 THEN
		ll_row = tab_1.tabpage_2.dw_2.insertRow(0)
		tab_1.tabpage_2.dw_2.Setitem(ll_row, "spec_fg", ls_spec_fg)
		tab_1.tabpage_2.dw_2.Setitem(ll_row, "spec_cd", ls_spec_cd)
		tab_1.tabpage_2.dw_2.Setitem(ll_row, "spec_term", dw_spec.GetitemDecimal(i, "spec_term"))
   END IF 
	/* size assort 내역 검색 */
	FOR j = 1 TO ll_max 
		IF is_size[j] = ls_size THEN EXIT
	NEXT 
   /* 해당 사이즈가 없으면 삭제 */
	IF j > ll_max THEN 
		dw_spec.DeleteRow(i)
	ELSE 
		tab_1.tabpage_2.dw_2.Setitem(ll_row, "size_spec_" + String(j), dw_spec.GetitemDecimal(i, "size_spec"))
	END IF
NEXT

/* 제품 치수내역 정렬 */
tab_1.tabpage_2.dw_2.SetSort("spec_fg A, spec_cd A")
tab_1.tabpage_2.dw_2.Sort()
tab_1.tabpage_2.dw_2.ResetUpdate()

end subroutine

public subroutine wf_save_spec ();/*-------------------------------------------------*/
/* tab_1.tabpage_2.dw_2 내용을 dw_spec로 이관 처리 */
/*-------------------------------------------------*/

String  ls_spec_fg,    ls_spec_cd, ls_size, ls_find 
Long    ll_RowCnt,     ll_row, i, j  
Decimal ldc_spec_term, ldc_size_spec
DwItemStatus ldw_status

IF tab_1.tabpage_2.dw_2.modifiedcount() = 0 AND tab_1.tabpage_2.dw_2.deletedcount() = 0 THEN
	Return 
END IF

/* db처리용 datawindow clear */
FOR i = 1 TO dw_spec.RowCount()
   dw_spec.Setitem(ll_row, "size_spec", 0)
NEXT

/* display용 datawindow 에서 db용 datawindow로 자료 이관 */
ll_RowCnt = tab_1.tabpage_2.dw_2.RowCount()
FOR i = 1 TO ll_RowCnt 
	ls_spec_fg    = tab_1.tabpage_2.dw_2.GetitemString(i,  "spec_fg")  
	ls_spec_cd    = tab_1.tabpage_2.dw_2.GetitemString(i,  "spec_cd") 
	IF isnull(ls_spec_fg) or isnull(ls_spec_cd) THEN CONTINUE
   ldc_spec_term = tab_1.tabpage_2.dw_2.GetitemDecimal(i, "spec_term")
	FOR j = 1 TO UpperBound(is_size) 
	   ls_size       = tab_1.tabpage_2.dw_2.describe("t_size_spec_" + String(j) + ".Text")
		ldc_size_spec = tab_1.tabpage_2.dw_2.GetitemDecimal(i, "size_spec_" + String(j))

		IF isnull(ldc_size_spec) OR ldc_size_spec = 0 THEN CONTINUE

		ls_find = "spec_fg = '" + ls_spec_fg + "' and spec_cd = '" + & 
		          ls_spec_cd + "' and size = '" + ls_size + "'"
		ll_row  = dw_spec.find(ls_find, 1, dw_spec.RowCount()) 
		IF ll_row < 1 THEN
			ll_row = dw_spec.insertRow(0)
	      dw_spec.Setitem(ll_row, "spec_fg", ls_spec_fg)
	      dw_spec.Setitem(ll_row, "spec_cd", ls_spec_cd)
	      dw_spec.Setitem(ll_row, "size",    ls_size)
		END IF
      dw_spec.Setitem(ll_row, "spec_term", ldc_spec_term)
      dw_spec.Setitem(ll_row, "size_spec", ldc_size_spec)
	NEXT 
NEXT

/* 제품 치수가 없는자료는 삭제 */
FOR i = dw_spec.RowCount() TO 1 STEP -1
	ldc_size_spec = dw_spec.GetitemDecimal(i, "size_spec")
   IF isnull(ldc_size_spec) OR ldc_size_spec = 0 THEN 
		dw_spec.DeleteRow(i)
	END IF
NEXT

end subroutine

public subroutine wf_set_size ();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* 완성 제품 사이즈 정의[head] */
Long i, k, ll_rowcount
DataStore  lds_Source
String     ls_modify

ll_rowcount = tab_1.tabpage_1.dw_1.RowCount()
lds_Source  = Create DataStore 
lds_Source.DataObject = tab_1.tabpage_1.dw_1.DataObject

tab_1.tabpage_1.dw_1.RowsCopy(1, ll_rowcount, Primary!, lds_Source, 1, Primary!)

lds_Source.SetSort("size A")
lds_Source.Sort()

/* 사이즈 내역 Set */
String ls_null[]

is_size = ls_null
k = 0 
FOR i = 1 TO ll_rowcount
	IF i = 1 THEN
		k++
		is_size[k] = lds_source.object.size[i]
	ELSEIF lds_source.object.size[i] <> lds_source.object.size[i - 1] THEN
		k++
		is_size[k] = lds_source.object.size[i]
	END IF
NEXT

/* tab_1.tabpage_2.dw_2의 head 처리 */
FOR i = 1 TO 10 
	IF i > k THEN 
		ls_modify = "t_size_spec_" + String(i) + ".visible = 0 " + &
		            "size_spec_" + String(i) + ".visible = 0 "
	ELSE
		ls_modify = "t_size_spec_" + String(i) + ".text = '" + is_size[i] + "'" + &
                  "t_size_spec_" + String(i) + ".visible = 1 " + & 
						"size_spec_" + String(i) + ".visible = 1 "
	END IF
	tab_1.tabpage_2.dw_2.modify(ls_modify)
NEXT

Destroy  lds_Source


end subroutine

public function boolean wf_resv_update (ref string as_errmsg);/* 원자재 출고 예약량 처리 */

String  ls_mat_cd, ls_mat_color 
Decimal ldc_t_need_qty,  ldc_resv_qty
Long    i

/* 삭제자료  예약량 차감 */
FOR i = 1 TO tab_1.tabpage_3.dw_3.DeletedCount() 
	 ls_mat_cd      = tab_1.tabpage_3.dw_3.GetitemString(i, "mat_cd", delete!, True)
	 ls_mat_color   = tab_1.tabpage_3.dw_3.GetitemString(i, "mat_color", delete!, True)
	 ldc_t_need_qty = tab_1.tabpage_3.dw_3.GetitemDecimal(i, "t_need_qty", delete!, True)
	 IF isnull(ldc_t_need_qty) or ldc_t_need_qty = 0 THEN CONTINUE 
	 ldc_resv_qty = ldc_t_need_qty * -1
	 DECLARE SP_12010_Resv1 PROCEDURE FOR SP_12010_MatResv  
				@mat_cd   = :ls_mat_cd,   
				@color    = :ls_mat_color,   
				@resv_qty = :ldc_resv_qty  ;
	 EXECUTE SP_12010_Resv1; 
	 IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN 
        as_errMsg  = "[예약재고 " + String(SQLCA.SQLCODE) + "]" + sqlca.SQLERRTEXT
		 RETURN FALSE 
    END IF
NEXT 

/* 신규 및 수정 자료  예약량 차감 */
IF tab_1.tabpage_3.dw_3.ModifiedCount() > 0  THEN
	FOR i = 1 TO tab_1.tabpage_3.dw_3.RowCount()
		idw_status = tab_1.tabpage_3.dw_3.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record */
	      ls_mat_cd    = tab_1.tabpage_3.dw_3.GetitemString(i, "mat_cd")
	      ls_mat_color = tab_1.tabpage_3.dw_3.GetitemString(i, "mat_color")
	      ldc_resv_qty = tab_1.tabpage_3.dw_3.GetitemDecimal(i, "t_need_qty")
			IF isnull(ldc_resv_qty) THEN ldc_resv_qty = 0 
		ELSEIF idw_status = DataModified! THEN	      /* Modify Record */
         ls_mat_cd      = tab_1.tabpage_3.dw_3.GetitemString(i, "mat_cd")
	      ls_mat_color   = tab_1.tabpage_3.dw_3.GetitemString(i, "mat_color")
	      ldc_t_need_qty = tab_1.tabpage_3.dw_3.GetitemDecimal(i, "t_need_qty", Primary!, True) 
			IF isnull(ldc_t_need_qty) THEN ldc_t_need_qty = 0 
	      ldc_resv_qty   = tab_1.tabpage_3.dw_3.GetitemDecimal(i, "t_need_qty")
			IF isnull(ldc_resv_qty) THEN ldc_resv_qty = 0 
			ldc_resv_qty = ldc_resv_qty - ldc_t_need_qty
		ELSE
			CONTINUE 
		END IF 
		IF ldc_resv_qty = 0 THEN CONTINUE  
      DECLARE SP_12010_Resv2 PROCEDURE FOR SP_12010_MatResv  
					@mat_cd   = :ls_mat_cd,   
					@color    = :ls_mat_color,   
					@resv_qty = :ldc_resv_qty  ;
      EXECUTE SP_12010_Resv2; 
      IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN 
         as_errMsg  = "[예약재고 " + String(SQLCA.SQLCODE) + "]" + sqlca.SQLERRTEXT
			RETURN FALSE 
		END IF
	NEXT
END IF

Return TRUE 
end function

public function boolean wf_mat_stock (string as_mat_cd, string as_color, ref string as_spec, ref decimal adc_stock_qty, ref decimal adc_resv_qty);/*===========================================================================*/
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

public subroutine wf_set_color (integer ai_index);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* assort내역에 등록된 색상만 요척내역에 색상 정의*/
DataStore  lds_Source
blob   lbl_dw
String ls_filter, ls_color[]
Long   i, k


lds_Source = Create DataStore 
tab_1.tabpage_1.dw_1.GetFullState ( lbl_dw )
lds_Source.SetFullState ( lbl_dw )

lds_Source.SetSort("color A")
lds_Source.Sort()



/* 색상 내역 Set */
k = 0 
FOR i = 1 TO lds_Source.RowCount() 
	IF isnull(lds_source.object.color[i]) or Trim(lds_source.object.color[i]) = "" THEN 
		CONTINUE 
	END IF
	IF i = 1 THEN
		k++
		ls_color[k] = lds_source.object.color[i]
	ELSEIF lds_source.object.color[i] <> lds_source.object.color[i - 1] THEN
		k++
		ls_color[k] = lds_source.object.color[i]
	END IF
NEXT

FOR i = 1 TO k 
	IF i = 1 THEN
	   ls_filter = "color = '" + ls_color[i] + "'" 
	ELSE
	   ls_filter = ls_filter + " or color = '" + ls_color[i] + "'" 
	END IF

NEXT
IF k > 0 AND ai_index = 4 THEN
   ls_filter = ls_filter + " or color = 'XX'" 
END IF	
	
CHOOSE CASE ai_index
	CASE 1,3 
		idw_color_3.SetFilter(ls_filter)
		idw_color_3.Filter()

	CASE 1,4 
      idw_color_4.SetFilter(ls_filter)
      idw_color_4.Filter()
END CHOOSE

Destroy  lds_Source

end subroutine

public subroutine wf_mat_info_set (long al_row, string as_mat_cd);String ls_patt_type, ls_OrgMat_Cd, ls_country_cd, ls_patt_chk, ls_OrgMat_chk
String ls_mat_fg
IF is_chno <> '0' AND  is_chno <> 'S' THEN
	RETURN 
END IF

ls_mat_fg = tab_1.tabpage_3.dw_3.GetitemString(al_row, "mat_fg") 
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

Return Long(tab_1.tabpage_1.dw_1.Describe(ls_exp))
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

Return Long(tab_1.tabpage_1.dw_1.Describe(ls_exp))
end function

public function boolean wf_del_check (long al_row, datawindow adw_temp);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* tab에 있는 자료 삭제 가능여부 체크  */

Long    ll_ordqty, ll_inqty, ll_outqty, ll_saleqty 
Decimal ldc_out_qty

CHOOSE CASE tab_1.selectedtab 
	CASE 1 
		ll_ordqty  = adw_temp.GetitemNumber(al_row, "ord_qty")
		ll_inqty   = adw_temp.GetitemNumber(al_row, "in_qty")
		ll_outqty  = adw_temp.GetitemNumber(al_row, "out_qty")
		ll_saleqty = adw_temp.GetitemNumber(al_row, "sale_qty") 
		IF ll_ordqty <> 0 OR ll_inqty <> 0 OR ll_outqty <> 0 OR ll_saleqty <> 0 THEN 
			MessageBox("삭제오류", "삭제할수 없는 자료입니다.")
			RETURN FALSE
		END IF
	CASE 3 
		ldc_out_qty = adw_temp.GetitemDecimal(al_row, "out_qty")
		IF ldc_out_qty <> 0  THEN 
			MessageBox("삭제오류", "삭제할수 없는 자료입니다.")
			RETURN FALSE
		END IF
	CASE 4 
		ldc_out_qty = adw_temp.GetitemDecimal(al_row, "out_qty")
		IF ldc_out_qty <> 0  THEN 
			MessageBox("삭제오류", "삭제할수 없는 자료입니다.")
			RETURN FALSE
		END IF
END CHOOSE

Return True

end function

public function boolean wf_tab_update (datetime adt_datetime, ref string as_errmsg);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* tabpage datawindow 저장 처리 */
Long    i, ll_row 
String  ls_color, ls_size 
/* Assort 내역 처리 tabpage_1.dw_1 tb_12030_s */
/* dw_body        tb_12024_d */
dw_body.Reset() 
dw_body.retrieve(is_style, is_chno) 
FOR i = 1 TO tab_1.tabpage_1.dw_1.DeletedCount() 
	ls_color = tab_1.tabpage_1.dw_1.GetitemString(i, "color", delete!, true)
	ls_size  = tab_1.tabpage_1.dw_1.GetitemString(i, "size",  delete!, true) 
	ll_row   = dw_body.find("color = '" + ls_color + "' and size = '" + ls_size + "'", 1, dw_body.RowCount()) 
	IF ll_row > 0 THEN 
		dw_body.DeleteRow(ll_row)
	END IF
NEXT
FOR i = 1 TO tab_1.tabpage_1.dw_1.RowCount()
   idw_status = tab_1.tabpage_1.dw_1.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
	
      tab_1.tabpage_1.dw_1.Setitem(i, "style",  is_style)
      tab_1.tabpage_1.dw_1.Setitem(i, "chno",   is_chno)
      tab_1.tabpage_1.dw_1.Setitem(i, "brand",  is_brand)
      tab_1.tabpage_1.dw_1.Setitem(i, "year",   is_year)
      tab_1.tabpage_1.dw_1.Setitem(i, "season", is_season)
      tab_1.tabpage_1.dw_1.Setitem(i, "sojae",  is_sojae)
      tab_1.tabpage_1.dw_1.Setitem(i, "item",   is_item)
		ll_row = dw_body.insertRow(0)
		dw_body.Setitem(ll_row, "style",  is_style)
		dw_body.Setitem(ll_row, "chno",   is_chno)
		dw_body.Setitem(ll_row, "color",  tab_1.tabpage_1.dw_1.GetitemString(i, "color"))
		dw_body.Setitem(ll_row, "size",   tab_1.tabpage_1.dw_1.GetitemString(i, "size"))
		dw_body.Setitem(ll_row, "reg_id", gs_user_id)
   END IF
NEXT

/* 완성제품 치수 처리 */
/* tabpage_2.dw_2에 변경 내역 있으면 dw_spec로 이관 */
//if ib_read[2] then
IF tab_1.tabpage_2.dw_2.ModifiedCount() > 0 OR tab_1.tabpage_2.dw_2.deletedcount() > 0 THEN 
	wf_save_spec()
END IF
IF dw_spec.ModifiedCount() > 0 THEN 
	FOR i = 1 TO dw_spec.RowCount()
		idw_status = dw_spec.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record */
			dw_spec.Setitem(i, "style",  is_style)
			dw_spec.Setitem(i, "chno",   is_chno)
			dw_spec.Setitem(i, "reg_id", gs_user_id)
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
			dw_spec.Setitem(i, "mod_id", gs_user_id)
			dw_spec.Setitem(i, "mod_dt", adt_datetime)
		END IF
	NEXT
END IF
/* 원자재 요척 tabpage_3.dw_3  */
IF tab_1.tabpage_3.dw_3.ModifiedCount() > 0 OR tab_1.tabpage_3.dw_3.deletedcount() > 0 THEN
	FOR i = 1 TO tab_1.tabpage_3.dw_3.RowCount()
		idw_status = tab_1.tabpage_3.dw_3.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record */
			tab_1.tabpage_3.dw_3.Setitem(i, "style",      is_style)
			tab_1.tabpage_3.dw_3.Setitem(i, "chno",       is_chno)
			tab_1.tabpage_3.dw_3.Setitem(i, "mat_gubn",   '1')
			tab_1.tabpage_3.dw_3.Setitem(i, "brand",      is_brand)
			tab_1.tabpage_3.dw_3.Setitem(i, "reg_id",     gs_user_id)
		ELSEIF idw_status = DataModified! THEN	      /* Modify Record */
			tab_1.tabpage_3.dw_3.Setitem(i, "bf_reqqty",  tab_1.tabpage_3.dw_3.GetitemDecimal(i, "req_qty",  Primary!, TRUE))
			tab_1.tabpage_3.dw_3.Setitem(i, "bf_needqty", tab_1.tabpage_3.dw_3.GetitemDecimal(i, "t_need_qty", Primary!, TRUE))
			tab_1.tabpage_3.dw_3.Setitem(i, "mod_id",     gs_user_id)
			tab_1.tabpage_3.dw_3.Setitem(i, "mod_dt",     adt_datetime)
		END IF
		tab_1.tabpage_3.dw_3.Setitem(i, "no",  String(i, "0000"))
	NEXT
END IF

/* 부자재 요척 tabpage_4.dw_4  */
IF tab_1.tabpage_4.dw_4.ModifiedCount() > 0 OR tab_1.tabpage_4.dw_4.Deletedcount() > 0 THEN
	FOR i = 1 TO tab_1.tabpage_4.dw_4.RowCount()
		idw_status = tab_1.tabpage_4.dw_4.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record */
			tab_1.tabpage_4.dw_4.Setitem(i, "style",      is_style)
			tab_1.tabpage_4.dw_4.Setitem(i, "chno",       is_chno)
			tab_1.tabpage_4.dw_4.Setitem(i, "mat_gubn",   '2')
			tab_1.tabpage_4.dw_4.Setitem(i, "brand",      is_brand)
			tab_1.tabpage_4.dw_4.Setitem(i, "reg_id",     gs_user_id)
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
			tab_1.tabpage_4.dw_4.Setitem(i, "bf_reqqty",  tab_1.tabpage_4.dw_4.GetitemDecimal(i, "req_qty",  Primary!, TRUE))
			tab_1.tabpage_4.dw_4.Setitem(i, "bf_needqty", tab_1.tabpage_4.dw_4.GetitemDecimal(i, "t_need_qty", Primary!, TRUE))
			tab_1.tabpage_4.dw_4.Setitem(i, "mod_id",     gs_user_id)
			tab_1.tabpage_4.dw_4.Setitem(i, "mod_dt",     adt_datetime)
		END IF
		tab_1.tabpage_4.dw_4.Setitem(i, "no",  String(i, "0000"))
	NEXT
END IF

/* 수정사항 (TB_12022_D) */
idw_status = tab_1.tabpage_8.dw_8.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record    */
   tab_1.tabpage_8.dw_8.Setitem(1, "style", is_style)
   tab_1.tabpage_8.dw_8.Setitem(1, "chno" , is_chno)
	
   tab_1.tabpage_8.dw_8.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
   tab_1.tabpage_8.dw_8.Setitem(1, "mod_id", gs_user_id)
   tab_1.tabpage_8.dw_8.Setitem(1, "mod_dt", adt_datetime)
END IF

/* 패브릭가이드 (TB_12050_D) */
idw_status = tab_1.tabpage_7.dw_11.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record    */
   tab_1.tabpage_7.dw_11.Setitem(1, "style", is_style)
   tab_1.tabpage_7.dw_11.Setitem(1, "chno" , is_chno)
	
   tab_1.tabpage_7.dw_11.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
   tab_1.tabpage_7.dw_11.Setitem(1, "mod_id", gs_user_id)
   tab_1.tabpage_7.dw_11.Setitem(1, "mod_dt", adt_datetime)
END IF


// tb_12030_s
IF tab_1.tabpage_1.dw_1.Update(TRUE, FALSE) <> 1 THEN  RETURN FALSE 
// tb_12024_d
IF dw_body.Update(TRUE, FALSE) <> 1 THEN  RETURN FALSE 
// tb_12023_d
IF dw_spec.Update(TRUE, FALSE) <> 1 THEN  RETURN FALSE 
// tb_12025_d
IF tab_1.tabpage_3.dw_3.Update(TRUE, FALSE) <> 1 THEN  RETURN FALSE 
// tb_12025_d
IF tab_1.tabpage_4.dw_4.Update(TRUE, FALSE) <> 1 THEN  RETURN FALSE 
// tb_12022_d
IF tab_1.tabpage_8.dw_8.Update(TRUE, FALSE) <> 1 THEN  RETURN FALSE 
// tb_12050_d
IF tab_1.tabpage_7.dw_11.Update(TRUE, FALSE) <> 1 THEN  RETURN FALSE 
RETURN WF_RESV_UPDATE(as_errmsg)

end function

public subroutine wf_tab_retrieve (integer ai_index);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* TABPAGE별 조회   */
long ll_user_level
IF ib_read[ai_index] THEN RETURN 

ll_user_level = 999

CHOOSE CASE ai_index
	CASE 1 
		tab_1.tabpage_1.dw_1.Retrieve(is_style, is_chno, ll_user_level) 
	CASE 2
		dw_spec.Retrieve(is_style, is_chno) 
		tab_1.tabpage_2.dw_2.Reset() 
	CASE 3 
		tab_1.tabpage_3.dw_3.Retrieve(is_style, is_chno) 
	CASE 4 
		tab_1.tabpage_4.dw_4.Retrieve(is_style, is_chno) 
	CASE 5 
		tab_1.tabpage_5.dw_5.Retrieve(is_style, is_chno) 
	CASE 6 
		tab_1.tabpage_6.dw_6.Retrieve(is_brand, is_year, is_season) 
//	Case 7
//		tab_1.tabpage_7.phl_1.PictureName = '\\220.118.68.4\photo\' + is_brand_nm + '\' + is_year + '\' + is_season + '\' + is_style + '.jpg'
	CASE 7 
		il_rows = tab_1.tabpage_8.dw_8.Retrieve(is_style, is_chno) 
		if il_rows = 0 then
			tab_1.tabpage_8.dw_8.insertrow(1)
		end if
	CASE 8 
		il_rows = tab_1.tabpage_7.dw_11.Retrieve(is_style, is_chno) 
		if il_rows = 0 then
			tab_1.tabpage_7.dw_11.insertrow(1)
		end if
		
END CHOOSE

ib_read[ai_index] = True

end subroutine

on w_12020_d.create
int iCurrent
call super::create
this.cb_del_all=create cb_del_all
this.dw_master=create dw_master
this.dw_spec=create dw_spec
this.dw_detail=create dw_detail
this.cb_2=create cb_2
this.dw_label=create dw_label
this.tab_1=create tab_1
this.dw_7=create dw_7
this.cb_sketch=create cb_sketch
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_del_all
this.Control[iCurrent+2]=this.dw_master
this.Control[iCurrent+3]=this.dw_spec
this.Control[iCurrent+4]=this.dw_detail
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.dw_label
this.Control[iCurrent+7]=this.tab_1
this.Control[iCurrent+8]=this.dw_7
this.Control[iCurrent+9]=this.cb_sketch
end on

on w_12020_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_del_all)
destroy(this.dw_master)
destroy(this.dw_spec)
destroy(this.dw_detail)
destroy(this.cb_2)
destroy(this.dw_label)
destroy(this.tab_1)
destroy(this.dw_7)
destroy(this.cb_sketch)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_emp_nm, ls_dept, ls_mat_cd, ls_fr_style, ls_fr_chno, ls_brand, ls_syear
Boolean    lb_check 
DataStore  lds_Source
DataWindowChild ldw_child

CHOOSE CASE as_column
	CASE "style_no"				
		   ls_style = MidA(as_data, 1, 8)
			ls_chno  = MidA(as_data, 9, 1)
			
			
			IF ai_div = 1 THEN 	
//				IF gf_style_chk(ls_style, ls_chno) THEN
//					RETURN 0
//				END IF 
				select case when :ls_style like '[BP]X3X___%' then '20132' else dbo.sf_inter_cd1('002',substring(:ls_style,3,1)) + convert(char(1),dbo.sf_inter_sort_seq('003',substring(:ls_style,4,1))) end
				into :ls_syear
				from dual;
		
				if ls_syear >= "20133"  then
					ls_brand = MidA(ls_style,1,1)
				else	
					ls_brand = "N"
				end if
				
				dw_master.getchild("season",ldw_child)
				ldw_child.settransobject(sqlca)
				ldw_child.retrieve('003', ls_brand, LeftA(ls_syear,4))						

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
				
				IF wf_style_chk(as_data) THEN
					Return 0 
				ELSEIF LenA(as_data) = 9 THEN
					MessageBox("오류", "품번 코드가 형식에 맞지안습니다 !")
					Return 1
				END IF
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
				dw_head.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))

				cb_2.enabled = true				 				
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "mat_cd"				
		   ls_mat_cd = as_data
			ls_chno   = MidA(as_data, 9, 1)
			
			if ai_div = 1  then 
				if isnull(as_data) or as_data = '' then 
					return 0
				END IF
			end if
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = ""
			
			
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = " (mat_cd LIKE  '" + ls_mat_cd + "%' or mat_nm LIKE  '%" + ls_mat_cd + "%') "
//			ELSE
//				gst_cd.Item_where = ""
//			END IF


			IF gs_brand <> "K" then			
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " (mat_cd LIKE  '" + ls_mat_cd + "%' or mat_nm LIKE  '%" + ls_mat_cd + "%') "
				ELSE
					gst_cd.Item_where = ""
				END IF
			else 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " (mat_cd LIKE  '" + ls_mat_cd + "%' or mat_nm LIKE  '%" + ls_mat_cd + "%') and mat_cd like 'K%'"
				ELSE
					gst_cd.Item_where = "mat_cd like 'K%'"
				END IF
				
			end if	

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))				
				dw_head.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))																
				dw_head.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))				


				ls_style = lds_Source.GetItemString(1,"style")
				ls_chno  = lds_Source.GetItemString(1,"chno")

				select fr_style, fr_chno into :ls_fr_style, :ls_fr_chno 
				from tb_12021_d(nolock) where style = :ls_style and chno = :ls_chno;
				
				dw_head.setitem(1, "fr_style", ls_fr_style)
				dw_head.setitem(1, "fr_chno", ls_fr_chno)


				cb_2.enabled = true				 				
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source					
	CASE "sample_cd"	
			if isnull(as_data) or LenA(as_data) = 0 then return 1
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "샘플코드 검색" 
			gst_cd.datawindow_nm   = "d_com121" 
			gst_cd.default_where   = "where sample_cd like '" + MidA(is_style, 1, 5) + "%'" 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "sample_cd LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_master.SetRow(al_row)
				dw_master.SetColumn(as_column)
				dw_master.SetItem(al_row, "sample_cd",   lds_Source.GetItemString(1,"sample_cd"))
				dw_master.SetItem(al_row, "dsgn_emp",    lds_Source.GetItemString(1,"dsgn_emp"))
				dw_master.SetItem(al_row, "dsgn_emp_nm", lds_Source.GetItemString(1,"dsgn_emp_nm"))
				dw_master.SetItem(al_row, "out_seq",     lds_Source.GetItemString(1,"out_seq"))
				/* 다음컬럼으로 이동 */
				dw_master.TriggerEvent(Editchanged!)
				dw_master.SetColumn("make_type")
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
					dw_master.Setitem(al_row, "dsgn_emp_nm", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			/* 관련부서 산출 */ 

				
			
			if MidA(is_style, 1, 1) = 'T' or MidA(is_style, 1, 1) = 'Y' then 
		   	gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('T000')" /* TASSE 추가 */  
			elseif MidA(is_style, 1, 1) = 'W' then 
			   gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('K100','K400','O100','B100')" /* W. 추가 */  
			else
				gf_get_inter_sub ('991', MidA(is_style, 1, 1) + '10', '1', ls_dept)
				gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('" + ls_dept + "','B200','O200','O100','B100','O000','T100','T000','K400')" /* 니트 , 악세라시 추가 */  
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
				dw_master.SetRow(al_row)
				dw_master.SetColumn(as_column)
				dw_master.SetItem(al_row, "dsgn_emp",    lds_Source.GetItemString(1,"empno"))
				dw_master.SetItem(al_row, "dsgn_emp_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				dw_master.TriggerEvent(Editchanged!)
				dw_master.SetColumn("make_type")
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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String   ls_title, ls_style_no

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

ls_style_no = dw_head.GetItemString(1, "style_no")
if IsNull(ls_style_no) or Trim(ls_style_no) = "" then
   MessageBox(ls_title,"품번 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no")
   return false
end if
is_style  = MidA(ls_style_no, 1, 8)
is_chno   = MidA(ls_style_no, 9, 1)
is_brand  = MidA(is_style, 1, 1)

select dbo.sf_inter_nm('019',:is_brand) into :is_brand_nm from dual;

gf_get_inter_sub('002', MidA(is_style, 3, 1), '1', is_year)
is_season = MidA(is_style, 4, 1)
is_sojae  = MidA(is_style, 2, 1)
is_item   = MidA(is_style, 5, 1)


is_country_cd = dw_master.GetItemString(1, "country_cd2")




is_make_type = dw_master.GetItemString(1, "make_type2")


is_orgmat_cd = dw_master.GetItemString(1, "orgmat_cd2")



if gs_brand = 'N' and (MidA(is_style,1,1) = 'O' or MidA(is_style,1,1) = 'D' or MidA(is_style,1,1) = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false
elseif  ( gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (MidA(is_style,1,1) = 'N' or MidA(is_style,1,1) = 'M' or MidA(is_style,1,1) = 'E' or MidA(is_style,1,1) = 'F' or MidA(is_style,1,1) = 'G'  or MidA(is_style,1,1) = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false	
elseif gs_brand = 'Y' and (MidA(is_style,1,1) = 'N' or MidA(is_style,1,1) = 'M' or MidA(is_style,1,1) = 'E' or MidA(is_style,1,1) = 'F' or MidA(is_style,1,1) = 'G'  or MidA(is_style,1,1) = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false	
	
elseif gs_brand = 'B' and (MidA(is_style,1,1) = 'O' or MidA(is_style,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false		
elseif gs_brand = 'G' and (MidA(is_style,1,1) = 'O' or MidA(is_style,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false			
end if	


return true

end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 		   									  */	
/* 작성일      : 2002.01.08																  */	
/*===========================================================================*/
inv_resize.of_Register(cb_sketch, "FixedToRight")
inv_resize.of_Register(cb_del_all, "FixedToRight")
/* Data window Resize */
//inv_resize.of_Register(dw_master, "ScaleToRight")
inv_resize.of_Register(tab_1,     "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_1,  "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_2,  "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_3.dw_3,  "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_4.dw_4,  "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_4.dw_99, "ScaleToBottom")
inv_resize.of_Register(tab_1.tabpage_5.dw_5,  "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_6.dw_6,  "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_8.dw_8,  "ScaleToRight&Bottom")
inv_resize.of_Register(dw_label, "ScaleToRight")
inv_resize.of_Register(tab_1.tabpage_7.dw_11,  "ScaleToRight&Bottom")
/* DataWindow의 Transction 정의 */
dw_master.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
dw_spec.SetTransObject(SQLCA)
dw_7.SetTransObject(SQLCA)

tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)
tab_1.tabpage_4.dw_4.SetTransObject(SQLCA)
tab_1.tabpage_4.dw_99.SetTransObject(SQLCA)
tab_1.tabpage_5.dw_5.SetTransObject(SQLCA)
tab_1.tabpage_6.dw_6.SetTransObject(SQLCA)
tab_1.tabpage_8.dw_8.SetTransObject(SQLCA)
tab_1.tabpage_7.dw_11.SetTransObject(SQLCA)

dw_label.SetTransObject(SQLCA)
/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_master)   

dw_master.insertRow(0)
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
DateTime ld_datetime
Long i, ll_rows
string ls_flag

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


/****************** Main Label **************************/
il_rows = dw_label.retrieve(is_style, is_chno)
for i = 1 to dw_label.rowcount()
	ls_flag = dw_label.getitemstring(i,"flag")
	if ls_flag = 'New' then
		dw_label.SetItemStatus(i, 0, Primary!,NewModified!)
	else
		dw_label.SetItemStatus(i, 0, Primary!,DataModified!)
	end if

next 

/********************************************************/

il_rows = dw_7.retrieve(is_style + is_chno)
ll_rows = dw_detail.retrieve(is_style, is_chno)
il_rows = dw_master.retrieve(is_style, is_chno)
IF il_rows > 0 THEN
	If ll_rows <= 0 Then
		gf_sysdate(ld_datetime) 
		dw_master.Setitem(1, "req_ymd", String(ld_datetime, "yyyymmdd"))
	End If		

	

   dw_master.SetFocus()
ELSEIF il_rows = 0 THEN 
	il_rows = dw_master.insertRow(0)
	IF match(is_chno, "[0S]") = FALSE THEN 
		MessageBox("확인요망","MAIN 품번이 등록 되여있지 않습니다.") 
		RETURN 
	END IF
   dw_master.Setitem(1, "style",   is_style)
   dw_master.Setitem(1, "brand",   is_brand)
   dw_master.Setitem(1, "year",    is_year)
   dw_master.Setitem(1, "season",  is_season)
   dw_master.Setitem(1, "sojae",   is_sojae)
   dw_master.Setitem(1, "item",    is_item)
	IF MidA(is_style, 5, 1) = 'Z' THEN
     dw_master.Setitem(1, "plan_yn", "Y") 
   ELSE
     dw_master.Setitem(1, "plan_yn", "N") 
   END IF

//	IF is_sojae = 'W' THEN 
//	   dw_master.Setitem(1, "make_type", '10')
//	END IF 


   dw_master.Setitem(1, "country_cd", "00")
	dw_master.Setitem(1, "country_cd2", "00")
   
	gf_sysdate(ld_datetime) 
   dw_master.Setitem(1, "req_ymd", String(ld_datetime, "yyyymmdd"))
	dw_master.SetFocus()
END IF


// Assort 내역은 항상 retrieve
IF tab_1.selectedtab <> 1 THEN 
   wf_tab_retrieve(1) 
END IF


/* 선택된 tab자료 조회 */ 
wf_tab_retrieve(tab_1.selectedtab) 

wf_set_color(4)



This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/
integer i 

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_insert.enabled = true
         cb_del_all.enabled = true
			cb_sketch.enabled = true
		   tab_1.enabled = true
         dw_master.Enabled = true
			cb_preview.enabled = true
      end if
	CASE 4		/* 삭제 */
      cb_delete.enabled = true
   CASE 5    /* 조건 */
      cb_insert.enabled  = false
      cb_del_all.enabled = false
		cb_sketch.enabled = false
		tab_1.enabled = false 
      dw_master.Enabled = false
		FOR i = 1 TO 8
		   ib_read[i]  = false
		NEXT
END CHOOSE

end event

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
DataWindow  ldw_temp

if dw_master.AcceptText() <> 1 then return

CHOOSE CASE tab_1.selectedtab 
	CASE 1 
		ldw_temp = tab_1.tabpage_1.dw_1
	CASE 2
		ldw_temp = tab_1.tabpage_2.dw_2
	CASE 3 
		ldw_temp = tab_1.tabpage_3.dw_3
	CASE 4 
		ldw_temp = tab_1.tabpage_4.dw_4
	CASE ELSE
		Return
END CHOOSE

if ldw_temp.AcceptText() <> 1 then return

il_rows = ldw_temp.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
   this.Trigger Event ue_init(ldw_temp)   
	ldw_temp.ScrollToRow(il_rows)
	ldw_temp.SetColumn(ii_min_column_id)
	ldw_temp.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_delete;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.08																  */	
/* 수정일      : 2002.01.08																  */
/*===========================================================================*/
DataWindow  ldw_temp
long			ll_cur_row

if dw_master.AcceptText() <> 1 then return

/* 선택된 Tab Page DataWindow 산출 */ 
CHOOSE CASE tab_1.selectedtab 
	CASE 1 
		ldw_temp = tab_1.tabpage_1.dw_1
	CASE 2
		ldw_temp = tab_1.tabpage_2.dw_2
	CASE 3 
		ldw_temp = tab_1.tabpage_3.dw_3
	CASE 4 
		ldw_temp = tab_1.tabpage_4.dw_4
	CASE ELSE
		Return
END CHOOSE

ll_cur_row = ldw_temp.GetRow()
if ll_cur_row <= 0 then return

// 삭제 가능여부 체크
//IF wf_del_check(ll_cur_row, ldw_temp) = FALSE THEN RETURN

idw_status = ldw_temp.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = ldw_temp.DeleteRow (ll_cur_row)
ldw_temp.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event pfc_postopen();call super::pfc_postopen;int i 

tab_1.tabpage_4.dw_99.Retrieve()
FOR i = 1 TO 6
    ib_read[i]  = false
NEXT

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.07                                                  */	
/* 수정일      : 2002.03.07                                                  */
/*===========================================================================*/


long i, ll_row_count
datetime ld_datetime
String   ls_mat_cd, ls_mat_nm, ls_mat_nm_chk, ls_ErrMsg, ls_flag

ll_row_count = dw_master.RowCount()
IF ll_row_count < 1 THEN RETURN -1

IF dw_label.AcceptText() <> 1 THEN RETURN -1
IF dw_master.AcceptText() <> 1 THEN RETURN -1
IF tab_1.tabpage_1.dw_1.AcceptText() <> 1 THEN RETURN -1
IF tab_1.tabpage_2.dw_2.AcceptText() <> 1 THEN RETURN -1
IF tab_1.tabpage_3.dw_3.AcceptText() <> 1 THEN RETURN -1
IF tab_1.tabpage_4.dw_4.AcceptText() <> 1 THEN RETURN -1

/* assot, 원부자재 요척 리체크 */
tab_1.tabpage_1.dw_1.Trigger Event ue_auto_need()








is_country_cd = dw_master.GetItemString(1, "country_cd2")
is_make_type = dw_master.GetItemString(1, "make_type2")
is_orgmat_cd = dw_master.GetItemString(1, "orgmat_cd2")
is_out_seq  = dw_master.GetItemString(1, "out_seq")
is_out_seq2 = dw_master.GetItemString(1, "out_seq2")

if is_make_type <> '40' then
	for i = 1 to tab_1.tabpage_3.dw_3.rowcount()
		if tab_1.tabpage_3.dw_3.getitemnumber(i,"req_qty") = 0 then 
			MessageBox("확인","원자재요척을 입력하십시요!")
			tab_1.tabpage_3.dw_3.setrow(i)
			tab_1.tabpage_3.dw_3.SetFocus()
			tab_1.tabpage_3.dw_3.SetColumn("req_qty")
			return -1				
		end if
	next
end if



if IsNull(is_country_cd) or Trim(is_country_cd) = "" then
   MessageBox("확인","국가 코드를 입력하십시요!")
   dw_master.SetFocus()
   dw_master.SetColumn("country_cd2")
   return -1
end if

if IsNull(is_make_type) or Trim(is_make_type) = "" then
   MessageBox("확인","생산형태 코드를 입력하십시요!")
   dw_master.SetFocus()
   dw_master.SetColumn("make_type2")
   return -1
end if

if IsNull(is_orgmat_cd) or Trim(is_orgmat_cd) = "" then
   MessageBox("확인","원료 코드를 입력하십시요!")
   dw_master.SetFocus()
   dw_master.SetColumn("orgmat_cd2")
   return -1
end if



/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

/* 마스터에 main원자재 처리 */
IF tab_1.tabpage_3.dw_3.modifiedcount() = 0 THEN 
	i = 0 
ELSE
   i = tab_1.tabpage_3.dw_3.find("mat_fg = 'A'", 1, tab_1.tabpage_3.dw_3.RowCount()) 
END IF
IF i > 0 THEN  
	ls_mat_cd = tab_1.tabpage_3.dw_3.GetitemString(i, "mat_cd") 
	ls_mat_nm = tab_1.tabpage_3.dw_3.GetitemString(i, "mat_nm") 
   dw_master.Setitem(1, "mat_cd", ls_mat_cd) 
	ls_mat_nm_chk = dw_master.GetitemString(i, "mat_nm") 
	IF isnull(ls_mat_nm_chk) or Trim(ls_mat_nm_chk) = "" THEN
      dw_master.Setitem(1, "mat_nm", ls_mat_nm) 
	END IF
   dw_detail.Setitem(1, "mat_cd", ls_mat_cd) 
END IF 


/* 마스터 처리 (TB_12020_M) */
idw_status = dw_master.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record    */
	dw_master.Setitem(1, "make_type",   is_make_type) 	
   dw_master.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
	dw_master.Setitem(1, "make_type",   is_make_type) 	
   dw_master.Setitem(1, "mod_id", gs_user_id)
   dw_master.Setitem(1, "mod_dt", ld_datetime)
END IF

/* 디테일 처리 (TB_12021_D) */
IF dw_detail.RowCount() = 0 THEN    
	dw_detail.insertRow(0) 
	dw_detail.Setitem(1, "style",  is_style)
	dw_detail.Setitem(1, "chno",   is_chno)
	dw_detail.Setitem(1, "brand",  is_brand)
	dw_detail.Setitem(1, "year",   is_year)
	dw_detail.Setitem(1, "season", is_season)
	dw_detail.Setitem(1, "sojae",  is_sojae)
	dw_detail.Setitem(1, "item",   is_item) 
	

	
END IF 
IF dw_master.GetItemStatus(1, "req_ymd", Primary!) = DataModified! THEN
   dw_detail.Setitem(1, "req_ymd", dw_master.GetitemString(1, "req_ymd")) 
END IF 
IF dw_master.GetItemStatus(1, "remark", Primary!) = DataModified! THEN
   dw_detail.Setitem(1, "remark", dw_master.GetitemString(1, "remark")) 
END IF 
IF dw_master.GetItemStatus(1, "mat_nm", Primary!) = DataModified! THEN
   dw_detail.Setitem(1, "mat_nm", dw_master.GetitemString(1, "mat_nm")) 
END IF 



dw_detail.Setitem(1, "country_cd",  is_country_cd) 
dw_detail.Setitem(1, "make_type",   is_make_type) 
dw_detail.Setitem(1, "orgmat_cd",   is_orgmat_cd) 



idw_status = dw_detail.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record    */
	dw_detail.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
	dw_detail.Setitem(1, "mod_id", gs_user_id)
	dw_detail.Setitem(1, "mod_dt", ld_datetime)
END IF 






il_rows = dw_label.Update(TRUE, FALSE)

IF wf_tab_update(ld_datetime, ls_ErrMsg) THEN 
   il_rows = dw_master.Update(TRUE, FALSE)
	IF il_rows = 1 THEN
      il_rows = dw_detail.Update(TRUE, FALSE) 
	END IF
ELSE
   il_rows = -1
END IF



///////////////출고차순 확정///////////////
//	update tb_12028_d 
//	set out_seq = :is_out_seq2,
//		 mod_id  = :gs_user_id,
//		 mod_dt  = getdate()
//	where style = :is_style 
//	and   chno  = :is_chno	                          
//
//	if @@rowcount = 0
//		insert into tb_12028_d (STYLE, CHNO, BRAND,	YEAR, SEASON, OUT_SEQ, REG_ID	)
//		select :is_style , :is_chno, :is_brand, :is_year, :is_season, :is_out_seq2, :gs_user_id
//		where not exists (select * 
//					from tb_12028_d (nolock)
//					where style = :is_style 
//					and   chno  = :is_chno);
///////////////////////////////////////////


if il_rows = 1 then
   dw_master.ResetUpdate()
   dw_detail.ResetUpdate()
   dw_body.ResetUpdate()
   tab_1.tabpage_1.dw_1.ResetUpdate()
   dw_spec.ResetUpdate()
   tab_1.tabpage_3.dw_3.ResetUpdate()
   tab_1.tabpage_4.dw_4.ResetUpdate()
   wf_tab_retrieve(3)
	dw_label.ResetUpdate()
	tab_1.tabpage_7.dw_11.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
	IF Trim(ls_ErrMsg) <> "" THEN 
		MessageBox("저장 오류", ls_ErrMsg)
	END IF 
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12020_d","0")
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

//dw_body.ShareData(dw_print)
dw_print.retrieve(is_style,is_chno)
dw_print.inv_printpreview.of_SetZoom()

end event

event open;call super::open;if isnull(gsv_cd.gs_cd10) or gsv_cd.gs_cd10 = '' then
else
	dw_head.setitem(1,"style_no", string(gsv_cd.gs_cd10) + '0')
	setnull(gsv_cd.gs_cd10)
	trigger event ue_retrieve()
end if

end event

type cb_close from w_com010_e`cb_close within w_12020_d
integer taborder = 140
end type

type cb_delete from w_com010_e`cb_delete within w_12020_d
boolean visible = false
integer x = 919
integer taborder = 90
end type

type cb_insert from w_com010_e`cb_insert within w_12020_d
boolean visible = false
integer x = 576
integer taborder = 70
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_12020_d
end type

type cb_update from w_com010_e`cb_update within w_12020_d
boolean visible = false
integer taborder = 130
end type

type cb_print from w_com010_e`cb_print within w_12020_d
integer x = 1262
integer taborder = 100
string text = "작지출력"
end type

event cb_print::clicked;dw_print.dataobject = "d_12010_r01"
dw_print.SetTransObject(SQLCA)


trigger event ue_preview()

end event

type cb_preview from w_com010_e`cb_preview within w_12020_d
integer x = 1605
integer taborder = 110
string text = "생산의뢰서"
end type

event cb_preview::clicked;dw_print.dataobject = "d_12020_r00"
dw_print.SetTransObject(SQLCA)



Parent.Trigger Event ue_preview()
end event

type gb_button from w_com010_e`gb_button within w_12020_d
end type

type cb_excel from w_com010_e`cb_excel within w_12020_d
boolean visible = false
integer x = 2190
integer y = 36
integer taborder = 120
end type

type dw_head from w_com010_e`dw_head within w_12020_d
integer width = 3543
integer height = 148
string dataobject = "d_12010_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
CHOOSE CASE dwo.name
	CASE "style_no","mat_cd"	     //  Popup 검색창이 존재하는 항목 		
		IF ib_itemchanged THEN RETURN 1
	
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)


END CHOOSE

end event

event dw_head::editchanged;call super::editchanged;if LenA(data) > 3 then	cb_2.enabled = true
end event

type ln_1 from w_com010_e`ln_1 within w_12020_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_e`ln_2 within w_12020_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_e`dw_body within w_12020_d
boolean visible = false
integer x = 4274
integer y = 680
integer width = 489
integer height = 548
boolean titlebar = true
string title = "body"
string dataobject = "d_12010_d12"
boolean resizable = true
end type

type dw_print from w_com010_e`dw_print within w_12020_d
string dataobject = "d_12020_r00"
end type

type cb_del_all from commandbutton within w_12020_d
boolean visible = false
integer x = 1957
integer y = 44
integer width = 347
integer height = 92
integer taborder = 150
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "작지삭제"
end type

event clicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
Long    ll_ordqty, ll_inqty, ll_outqty, ll_saleqty 
Long    i 
Decimal ldc_out_qty
String  ls_ErrMsg 

/* assort 자료 삭제 가능여부 체크 */
FOR i = 1 TO tab_1.tabpage_1.dw_1.RowCount()
	ll_ordqty  = tab_1.tabpage_1.dw_1.GetitemNumber(i, "ord_qty")
	ll_inqty   = tab_1.tabpage_1.dw_1.GetitemNumber(i, "in_qty")
	ll_outqty  = tab_1.tabpage_1.dw_1.GetitemNumber(i, "out_qty")
	ll_saleqty = tab_1.tabpage_1.dw_1.GetitemNumber(i, "sale_qty") 
	IF ll_ordqty <> 0 OR ll_inqty <> 0 OR ll_outqty <> 0 OR ll_saleqty <> 0 THEN 
		MessageBox("삭제오류", "수불내역이 있어 삭제할수 없습니다.")
		RETURN 
	END IF
NEXT
/* 원자재 소요 삭제 가능여부 체크 */
FOR i = 1 TO tab_1.tabpage_3.dw_3.RowCount()
	ldc_out_qty = tab_1.tabpage_3.dw_3.GetitemDecimal(i, "out_qty")
	IF ldc_out_qty <> 0  THEN 
		MessageBox("삭제오류", "원자재 출고자료가 있어 삭제할수 없습니다.")
		RETURN 
	END IF
NEXT 
/* 부자재 소요 삭제 가능여부 체크 */
FOR i = 1 TO tab_1.tabpage_4.dw_4.RowCount()
	ldc_out_qty = tab_1.tabpage_4.dw_4.GetitemDecimal(i, "out_qty")
	IF ldc_out_qty <> 0  THEN 
		MessageBox("삭제오류", "부자재 출고자료가 있어 삭제할수 없습니다.")
		RETURN 
	END IF
NEXT 

IF MessageBox("확인", "[" + is_style + is_chno + "] 내역을 정말 삭제하시겠습니까 ?", Question!, YesNo!) = 2 THEN RETURN

 DECLARE sp_12010_del PROCEDURE FOR SP_12010_DEL  
         @style = :is_style,   
         @chno  = :is_chno  ; 
			
EXECUTE sp_12010_del;

IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN 
	commit  USING SQLCA;
	dw_master.Reset()
	dw_detail.Reset()
	dw_body.Reset()
	dw_spec.Reset()
	tab_1.tabpage_1.dw_1.Reset()
	tab_1.tabpage_2.dw_2.Reset()
	tab_1.tabpage_3.dw_3.Reset()
	tab_1.tabpage_4.dw_4.Reset()
	tab_1.tabpage_5.dw_5.Reset()
	dw_master.insertRow(0)
   Parent.Trigger Event ue_button(5, 2)
	Return 
END IF

ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" + SQLCA.SqlErrText
Rollback  USING SQLCA;
MessageBox("SQL 오류", ls_ErrMsg) 

end event

type dw_master from datawindow within w_12020_d
event ue_keydown pbm_dwnkey
integer x = 9
integer y = 344
integer width = 3259
integer height = 868
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_12020_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
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
//	CASE KeyDownArrow!
//		IF This.GetRow() = This.RowCount() THEN
//		   This.InsertRow(This.GetRow() + 1)
//		END IF
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
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event constructor;DataWindowChild ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_master.getitemstring(1,'brand')
is_year = dw_master.getitemstring(1,'year')

this.getchild("season",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('003', is_brand, is_year)
//ldw_child.retrieve('003')

//This.GetChild("season", ldw_child)
//ldw_child.SetTransObject(SQLCA)
//ldw_child.Retrieve('003')

//This.GetChild("sojae", ldw_child)
//ldw_child.SetTransObject(SQLCA)
//ldw_child.Retrieve('%')
//
//This.GetChild("item", ldw_child)
//ldw_child.SetTransObject(SQLCA)
//ldw_child.Retrieve()

This.GetChild("make_type2", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('030')


This.GetChild("out_seq", ldw_child)
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


end event

event buttonclicked;/*===========================================================================*/
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

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 2627
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 515
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

This.ScrollTorow(row)
This.SetRow(row)
This.SetFocus()

MessageBox(parent.title + "[TB_12020_M]", ls_message_string)
return 1
end event

event editchanged;/*===========================================================================*/
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

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.08                                                  */	
/* 수정일      : 2001.01.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE dwo.name
	CASE "sample_cd", "dsgn_emp"
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1) 
	CASE "req_ymd"
		IF GF_DATECHK(data) = FALSE THEN RETURN 1
	case "cancel_yn"
		dw_detail.setitem(1,"cancel_yn",data)		
	case "make_type2"
		dw_detail.setitem(1,"make_type",data)
	case "orgmat_cd2"
		dw_detail.setitem(1,"orgmat_cd",data)
	case "country_cd2"
		dw_detail.setitem(1,"country_cd",data)		
	case "pay_gubn"
		dw_detail.setitem(1,"pay_gubn",data)			

END CHOOSE

end event

event itemerror;return 1
end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

end event

type dw_spec from datawindow within w_12020_d
boolean visible = false
integer x = 4393
integer y = 932
integer width = 576
integer height = 432
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "spec"
string dataobject = "d_12010_d13"
boolean resizable = true
boolean livescroll = true
end type

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 2627
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 515
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

This.ScrollTorow(row)
This.SetRow(row)
This.SetFocus()

MessageBox(parent.title + "[TB_12023_D]", ls_message_string)
return 1
end event

type dw_detail from datawindow within w_12020_d
boolean visible = false
integer x = 4279
integer y = 1084
integer width = 626
integer height = 784
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "detail"
string dataobject = "d_12010_d11"
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 2627
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 515
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

This.ScrollTorow(row)
This.SetRow(row)
This.SetFocus()

MessageBox(parent.title + "[TB_12021_D]", ls_message_string)
return 1
end event

type cb_2 from commandbutton within w_12020_d
integer x = 2043
integer y = 200
integer width = 718
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "원자재 가능량 새로고침"
end type

event clicked;string ls_style_no, ls_brand, ls_year, ls_season, ls_style, ls_chno
pointer oldpointer  // Declares a pointer variable


IF dw_head.AcceptText() <> 1 THEN RETURN 1
ls_style_no = dw_head.GetItemString(1, "style_no")


This.Enabled = False
oldpointer = SetPointer(HourGlass!)


select top 1 brand, year, season, style, chno 
	into :ls_brand, :ls_year, :ls_season, :ls_style, :ls_chno
from tb_12021_d (nolock) 
where style like left(isnull(:ls_style_no,''),8) + '%'
and   chno  like substring(isnull(:ls_style_no,''),9,1) + '%';
	 

 DECLARE sp_syncro_data PROCEDURE FOR sp_syncro_data  
			@brand     = :ls_brand,  
			@year	     = :ls_year,
			@season    = :ls_season,
			@style	  = :ls_style,
			@chno		  = :ls_chno,
			@flag    = '1';
			
 execute sp_syncro_data;	

SetPointer(oldpointer)			 
			 
return 1			 		 
end event

type dw_label from datawindow within w_12020_d
integer x = 3264
integer y = 344
integer width = 366
integer height = 880
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_12020_d14"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

type tab_1 from tab within w_12020_d
integer x = 5
integer y = 1228
integer width = 3602
integer height = 780
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean showpicture = false
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_8 tabpage_8
tabpage_7 tabpage_7
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_8=create tabpage_8
this.tabpage_7=create tabpage_7
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_8,&
this.tabpage_7}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_8)
destroy(this.tabpage_7)
end on

event selectionchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.08                                                  */	
/* 수정일      : 2001.01.08                                                  */
/*===========================================================================*/

if oldindex < 1 then return

CHOOSE CASE newindex 
	CASE 2 
		if ib_read[2] then
		   wf_save_spec()
		   wf_set_size() 
		   wf_display_spec()
		else
         wf_tab_retrieve(newindex)
		   wf_set_size() 
		   wf_display_spec()
		end if
	CASE 3, 4
		wf_set_color(newindex) 
      wf_tab_retrieve(newindex)
	CASE ELSE
      wf_tab_retrieve(newindex)
END CHOOSE

end event

event selectionchanging;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.08                                                  */	
/* 수정일      : 2001.01.08                                                  */
/*===========================================================================*/

if oldindex < 1 then return 0

CHOOSE CASE oldindex 
	CASE 1 
		IF tab_1.tabpage_1.dw_1.AcceptText() <> 1 THEN RETURN 1
	CASE 2 
		IF tab_1.tabpage_2.dw_2.AcceptText() <> 1 THEN RETURN 1
	CASE 3 
		IF tab_1.tabpage_3.dw_3.AcceptText() <> 1 THEN RETURN 1
	CASE 4 
		IF tab_1.tabpage_4.dw_4.AcceptText() <> 1 THEN RETURN 1
	CASE 5 
		IF tab_1.tabpage_5.dw_5.AcceptText() <> 1 THEN RETURN 1
	CASE 7 
		IF tab_1.tabpage_8.dw_8.AcceptText() <> 1 THEN RETURN 1		
	CASE 8 
		IF tab_1.tabpage_7.dw_11.AcceptText() <> 1 THEN RETURN 1		
END CHOOSE

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 668
long backcolor = 79741120
string text = "Assort"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within tabpage_1
event ue_keydown pbm_dwnkey
event ue_auto_need ( )
integer width = 3557
integer height = 784
integer taborder = 110
string title = "none"
string dataobject = "d_12010_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
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
END CHOOSE

end event

event ue_auto_need();String  ls_color  
Decimal ldc_stock_qty, ldc_bf_tneed, ldc_t_exp_qty, ldc_ord_qty_exp
Decimal ldc_req_qty,   ldc_need_qty, ldc_loss , ldc_plan_qty,ldc_plan_qty_chn, ldc_ord_qty, ldc_ord_qty_chn
Long    i



/* 중국 투입량 자동 변경 */
IF ib_read[1] = FALSE THEN 
	wf_tab_retrieve(1) 
END IF 
FOR i = 1 TO tab_1.tabpage_1.dw_1.RowCount()
	 ldc_ord_qty  = tab_1.tabpage_1.dw_1.GetitemDecimal(i, "ord_qty") 
	 ldc_plan_qty = tab_1.tabpage_1.dw_1.GetitemDecimal(i, "plan_qty") 

	 ldc_ord_qty_chn  = tab_1.tabpage_1.dw_1.GetitemDecimal(i, "ord_qty_chn") 
	 ldc_plan_qty_chn = tab_1.tabpage_1.dw_1.GetitemDecimal(i, "plan_qty_chn")
	 
 	 ldc_ord_qty_exp = tab_1.tabpage_1.dw_1.GetitemDecimal(i, "ord_qty_exp") 
	 
	 /* 기획량과 투입량 일치 */
	 IF ldc_ord_qty <> 0  THEN
		 tab_1.tabpage_1.dw_1.Setitem(i, "ord_qty",   ldc_plan_qty)
		 tab_1.tabpage_1.dw_1.Setitem(i, "ord_qty_chn",   ldc_plan_qty_chn)	
	 end if

	 
NEXT 



/* 원자재 소요량 변경 */
IF ib_read[3] = FALSE THEN 
	wf_tab_retrieve(3) 
END IF 
FOR i = 1 TO tab_1.tabpage_3.dw_3.RowCount()
	 ls_color      = tab_1.tabpage_3.dw_3.GetitemString(i,  "color")
	 ldc_stock_qty = tab_1.tabpage_3.dw_3.GetitemDecimal(i, "c_stock_qty") 
    IF tab_1.tabpage_3.dw_3.GetItemStatus(i, 0, Primary!) = NewModified! THEN
		 ldc_bf_tneed = 0 
	 ELSE
		 ldc_bf_tneed  = tab_1.tabpage_3.dw_3.GetitemDecimal(i, "t_need_qty", Primary!, TRUE) 
		 IF isnull(ldc_bf_tneed) THEN ldc_bf_tneed = 0 
	 END IF 
	 ldc_req_qty  = tab_1.tabpage_3.dw_3.GetitemDecimal(i, "req_qty") 
	 ldc_need_qty = Round(wf_Get_pcs(ls_color) * ldc_req_qty, 1)
	 
	 ldc_t_exp_qty = Round(wf_Get_pcs_exp(ls_color) * ldc_req_qty, 1)
	 
	 /* 남은 잔량이 요척량보다 작을경우 Loss량으로 자동처리 */
	 IF ldc_bf_tneed + ldc_stock_qty - ldc_need_qty < ldc_req_qty and &
		 ldc_bf_tneed + ldc_stock_qty - ldc_need_qty > 0           THEN
		 ldc_loss = ldc_bf_tneed + ldc_stock_qty - ldc_need_qty
	 ELSE 
		 ldc_loss = 0 
	 END IF
	 
	 tab_1.tabpage_3.dw_3.Setitem(i, "need_qty",   ldc_need_qty)
	 tab_1.tabpage_3.dw_3.Setitem(i, "loss_qty",   ldc_loss)
	 tab_1.tabpage_3.dw_3.Setitem(i, "t_need_qty", ldc_need_qty + ldc_loss)
	 
 	 tab_1.tabpage_3.dw_3.Setitem(i, "t_exp_qty",   ldc_t_exp_qty)
NEXT 

/* 부자재 소요량 변경 */
IF ib_read[4] = FALSE THEN 
	wf_tab_retrieve(4) 
END IF 
FOR i = 1 TO tab_1.tabpage_4.dw_4.RowCount()
	 ls_color = tab_1.tabpage_4.dw_4.GetitemString(i, "color")
	 ldc_req_qty  = tab_1.tabpage_4.dw_4.GetitemDecimal(i, "req_qty") 
	 ldc_need_qty = Round(wf_Get_pcs(ls_color) * ldc_req_qty, 1)
	 tab_1.tabpage_4.dw_4.Setitem(i, "need_qty",   ldc_need_qty)
	 tab_1.tabpage_4.dw_4.Setitem(i, "t_need_qty", ldc_need_qty)
NEXT 


end event

event itemerror;return 1
end event

event dberror;///*===========================================================================*/
///* 작성자      : (주)지우정보 (김 태범)                                      */	
///* 작성일      : 1999.11.09																  */	
///* 수정일      : 2002.01.08																  */
///*===========================================================================*/
//
//string ls_message_string
//
//CHOOSE CASE sqldbcode
//	CASE 2627
//		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
//	CASE 515
//		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
//	CASE -1
//		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
//	CASE ELSE
//		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
//		   				     "~n" + "에러메세지("+sqlerrtext+")" 
//END CHOOSE
//
//This.ScrollTorow(row)
//This.SetRow(row)
//This.SetFocus()
//
//MessageBox(parentwindow().GetActivesheet().title + "[TB_12030_S]", ls_message_string)
//
//return 1
end event

event editchanged;/*===========================================================================*/
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

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.08                                                  */	
/* 수정일      : 2001.01.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE dwo.name
	CASE "plan_qty", "plan_qty_chn"
		This.Post Event ue_auto_need()
END CHOOSE


end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

end event

event constructor;This.SetRowFocusIndicator(Hand!)

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 668
long backcolor = 79741120
string text = "완성제품치수"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_2
event ue_keydown pbm_dwnkey
integer width = 3561
integer height = 872
integer taborder = 110
string title = "none"
string dataobject = "d_12020_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
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
END CHOOSE

end event

event editchanged;/*===========================================================================*/
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

event dberror;///*===========================================================================*/
///* 작성자      : (주)지우정보 (김 태범)                                      */	
///* 작성일      : 1999.11.09																  */	
///* 수정일      : 2002.01.08																  */
///*===========================================================================*/
//
//string ls_message_string
//
//CHOOSE CASE sqldbcode
//	CASE 2627
//		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
//	CASE 515
//		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
//	CASE -1
//		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
//	CASE ELSE
//		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
//		   				     "~n" + "에러메세지("+sqlerrtext+")" 
//END CHOOSE
//
//This.ScrollTorow(row)
//This.SetRow(row)
//This.SetFocus()
//
//MessageBox(parentwindow().GetActivesheet().title, ls_message_string)
//
//return 1
end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.08                                                  */	
/* 수정일      : 2001.01.08                                                  */
/*===========================================================================*/
This.TriggerEvent(EditChanged!)

end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

end event

event itemerror;return 1
end event

event constructor;DataWindowChild ldw_child
 
This.GetChild("spec_fg", ldw_child) 
ldw_child.SetTransObject(SQLCA) 
ldw_child.retrieve('124') 

This.GetChild("spec_cd", ldw_child) 
ldw_child.SetTransObject(SQLCA) 
ldw_child.retrieve('125') 


end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 668
long backcolor = 79741120
string text = "원자재요척"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from datawindow within tabpage_3
event type integer ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
event ue_keydown pbm_dwnkey
integer width = 3552
integer height = 872
integer taborder = 110
string title = "none"
string dataobject = "d_12020_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_mat_nm, ls_mat_fg, ls_null
Boolean    lb_check 
DataStore  lds_Source
SetNull(ls_null)

CHOOSE CASE as_column
	CASE "mat_cd"				
			IF ai_div = 1 THEN 	
				IF LeftA(is_style,1) = LeftA(as_data,1) and gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
					This.Setitem(al_row, "mat_nm", ls_mat_nm)
					This.Setitem(al_row, "mat_color", ls_null)
					wf_mat_info_set(al_row, as_data)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "원자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 
			gst_cd.default_where   = "where brand      = '" + is_brand + "'" + &
			                         "  and mat_year   = '" + is_year  + "'" + &
											 "  and mat_season = '" + is_season + "'" 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "mat_cd LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				This.SetRow(al_row)
				This.SetColumn(as_column)
				This.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
				This.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))
				This.SetItem(al_row, "mat_color", ls_null)
				wf_mat_info_set(al_row, lds_Source.GetItemString(1,"mat_cd"))
            ib_changed = true
            cb_update.enabled = true
				/* 다음컬럼으로 이동 */
				This.SetColumn("mat_color")
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

event ue_keydown;/*===========================================================================*/
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

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.08                                                  */	
/* 수정일      : 2001.01.08                                                  */
/*===========================================================================*/
String  ls_color, ls_mat_cd, ls_mat_nm, ls_spec, ls_orgmat_cd, ls_patt_type, ls_country_cd , ls_mat_nm_m
Decimal ldc_stock_qty, ldc_resv_qty, ldc_need_qty, ldc_t_exp_qty
Decimal ldc_bf_need,   ldc_bf_tneed, ldc_loss

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false

CHOOSE CASE dwo.name
	CASE "mat_cd"

		IF ib_itemchanged THEN RETURN 1
		il_rows = This.Trigger Event ue_Popup(dwo.name, row, data, 1)
		ls_orgmat_cd = gf_getorgmat_cd(data)		
		dw_master.setitem(1,"orgmat_cd2",ls_orgmat_cd)		
		
		
		select Patt_Type, country_cd
			into :ls_patt_type, :ls_country_cd
		from tb_21010_m (nolock) 
		where mat_cd = :data;

		dw_master.setitem(1,"patt_type",ls_patt_type)		
		dw_master.setitem(1,"country_cd",ls_country_cd)		
		dw_master.setitem(1,"orgmat_cd2",ls_orgmat_cd)	
		
		if row = 1 then		
			ls_mat_nm = this.getitemstring(row,"mat_nm")
			
			dw_master.setitem(1,"mat_cd",data)
			dw_master.setitem(1,"mat_nm",ls_mat_nm)
		end if
		
		

		
		
		return il_rows
		
	CASE "mat_color" 
		ls_mat_cd = This.GetitemString(row, "mat_cd")
		IF wf_mat_stock(ls_mat_cd, data, ls_spec, ldc_stock_qty, ldc_resv_qty) = FALSE THEN
         RETURN 1			
		END IF
		This.Setitem(row, "spec",      ls_spec)
		This.Setitem(row, "stock_qty", ldc_stock_qty)
		This.Setitem(row, "resv_qty",  ldc_resv_qty) 
	CASE "req_qty"
		ls_color      = This.GetitemString(row, "color")
		ldc_stock_qty = This.GetitemDecimal(row, "c_stock_qty") 
      IF This.GetItemStatus(row, 0, Primary!) = NewModified! THEN
			ldc_bf_tneed = 0 
		ELSE
		   ldc_bf_tneed  = This.GetitemDecimal(row, "t_need_qty", Primary!, TRUE) 
		   IF isnull(ldc_bf_tneed) THEN ldc_bf_tneed = 0 
		END IF 
//		ldc_need_qty = round(wf_Get_pcs(ls_color) * Dec(Data),1)	
		ldc_need_qty = wf_Get_pcs(ls_color) * Dec(Data)
		ldc_t_exp_qty = wf_Get_pcs_exp(ls_color) * Dec(Data)
		
		/* 사용 가능량 체크는 사용가능량에 기존 등록된 총소요량을 더해서 체크  */	
		
		
		IF ldc_bf_tneed + ldc_stock_qty < ldc_need_qty - 0.01 THEN 
			MessageBox("확인요망", "소요량이 사용가능량을 초과합니다!")
//			Return 1   //20031101 부로 가능량에 상관없이 요척가능(이명진)

		END IF
		
		/* 남은 잔량이 요척량보다 작을경우 Loss량으로 자동처리 */
		IF ldc_bf_tneed + ldc_stock_qty - ldc_need_qty < Dec(Data) AND &
		   ldc_bf_tneed + ldc_stock_qty - ldc_need_qty > 0 THEN
		   ldc_loss = ldc_bf_tneed + ldc_stock_qty - ldc_need_qty
		ELSE 
			ldc_loss = 0 
		END IF
		This.Setitem(row, "need_qty",   ldc_need_qty)
		This.Setitem(row, "loss_qty",   ldc_loss)
		This.Setitem(row, "t_need_qty", ldc_need_qty + ldc_loss)

		This.Setitem(row, "t_exp_qty", ldc_t_exp_qty)	//원단 수출용
		
	CASE "loss_qty" 
		ldc_stock_qty = This.GetitemDecimal(row, "c_stock_qty") 
		ldc_need_qty  = This.GetitemDecimal(row, "need_qty") 
      IF This.GetItemStatus(row, 0, Primary!) = NewModified! THEN
			ldc_bf_tneed = 0 
		ELSE
		   ldc_bf_tneed  = This.GetitemDecimal(row, "t_need_qty", Primary!, true) 
		   IF isnull(ldc_bf_tneed) THEN ldc_bf_tneed = 0 
		END IF 
		/* 사용 가능량 체크는 사용가능량에 기존 등록된 총소요량을 더해서 체크  */

		
		IF ldc_bf_tneed + ldc_stock_qty < ldc_need_qty + Dec(Data) THEN 
			MessageBox("확인요망", "소요량이 사용가능량을 초과합니다!")
			Return 1
		END IF
		This.Setitem(row, "t_need_qty", Dec(Data) + ldc_need_qty)
END CHOOSE

end event

event constructor;DataWindowChild ldw_child

This.GetChild("mat_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('123')
ldw_child.SetFilter("inter_cd > '9'")
ldw_child.Filter()


This.GetChild("color", idw_color_3)
idw_color_3.SetTransObject(SQLCA)
idw_color_3.retrieve()



This.GetChild("mat_color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.insertRow(0)

This.GetChild("mat_color_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()


end event

event editchanged;/*===========================================================================*/
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

event dberror;///*===========================================================================*/
///* 작성자      : (주)지우정보 (김 태범)                                      */	
///* 작성일      : 1999.11.09																  */	
///* 수정일      : 2002.01.08																  */
///*===========================================================================*/
//
//string ls_message_string
//
//CHOOSE CASE sqldbcode
//	CASE 2627
//		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
//	CASE 515
//		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
//	CASE -1
//		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
//	CASE ELSE
//		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
//		   				     "~n" + "에러메세지("+sqlerrtext+")" 
//END CHOOSE
//
//This.ScrollTorow(row)
//This.SetRow(row)
//This.SetFocus()
//
//MessageBox(parentwindow().GetActivesheet().title + "[원자재]", ls_message_string)
//
//return 1
end event

event buttonclicked;/*===========================================================================*/
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

event itemfocuschanged;/*===========================================================================*/
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

event itemerror;return 1
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 668
long backcolor = 79741120
string text = "부자재요척"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_3 cb_3
cb_1 cb_1
dw_99 dw_99
dw_4 dw_4
end type

on tabpage_4.create
this.cb_3=create cb_3
this.cb_1=create cb_1
this.dw_99=create dw_99
this.dw_4=create dw_4
this.Control[]={this.cb_3,&
this.cb_1,&
this.dw_99,&
this.dw_4}
end on

on tabpage_4.destroy
destroy(this.cb_3)
destroy(this.cb_1)
destroy(this.dw_99)
destroy(this.dw_4)
end on

type cb_3 from commandbutton within tabpage_4
integer y = 88
integer width = 558
integer height = 84
integer taborder = 150
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
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
			
tab_1.tabpage_4.dw_4.Retrieve(ls_style, ls_chno)

end event

type cb_1 from commandbutton within tabpage_4
integer y = 8
integer width = 558
integer height = 84
integer taborder = 130
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "기본부자재 자동등록"
end type

event clicked;String ls_mat, ls_mat_cd, ls_mat_nm 
Long   ll_pcs, ll_row 

ls_mat = is_brand + '2' + MidA(is_style, 3, 1) + is_season
ll_pcs = wf_Get_Pcs("XX")

DECLARE MAT_LIST CURSOR FOR
//  SELECT mat_cd, mat_nm 
//    FROM dbo.SF_12010_LIST(:ls_mat) ;
  SELECT mat_cd, mat_nm 
		 FROM TB_21000_M (nolock)
                WHERE MAT_CD   LIKE :ls_mat + '%' 
                  AND MAT_TYPE =    '0';


OPEN MAT_LIST;

FETCH MAT_LIST INTO :ls_mat_cd, :ls_mat_nm;
DO WHILE sqlca.sqlcode = 0 
	ll_row = parent.dw_4.find("mat_cd = '" + ls_mat_cd + "'", 1, parent.dw_4.RowCount())
	IF ll_row = 0 THEN 
		ll_row = parent.dw_4.insertRow(0)
		parent.dw_4.Setitem(ll_row, "mat_fg",     "0") 
		parent.dw_4.Setitem(ll_row, "color",      "XX") 
		parent.dw_4.Setitem(ll_row, "mat_cd",     ls_mat_cd) 
		parent.dw_4.Setitem(ll_row, "mat_nm",     ls_mat_nm) 
		parent.dw_4.Setitem(ll_row, "mat_color",  "XX") 
		parent.dw_4.Setitem(ll_row, "spec",       "XX") 
		parent.dw_4.Setitem(ll_row, "req_qty",    1) 
		parent.dw_4.Setitem(ll_row, "need_qty",   ll_pcs) 
		parent.dw_4.Setitem(ll_row, "t_need_qty", ll_pcs) 
      ib_changed = true
      cb_update.enabled = true
      cb_print.enabled = false
      cb_preview.enabled = false
	END IF
   FETCH MAT_LIST INTO :ls_mat_cd, :ls_mat_nm;
LOOP

CLOSE MAT_LIST;




end event

type dw_99 from datawindow within tabpage_4
integer y = 176
integer width = 558
integer height = 692
integer taborder = 110
string title = "none"
string dataobject = "d_12010_d99"
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
gst_cd.datawindow_nm   = "d_com913" 
gst_cd.default_where   = "where brand      = '" + is_brand + "'" + &
                         "  and mat_year   = '" + is_year  + "'" + &
								 "  and mat_season = '" + is_season + "'" 
gst_cd.Item_where = "mat_item = '" + ls_item + "'"


lds_Source = Create DataStore

OpenWithParm(W_COM200, lds_Source)
IF Isvalid(Message.PowerObjectParm) THEN
	ib_itemchanged = True
	lds_Source = Message.PowerObjectParm
   ll_row = Parent.dw_4.insertRow(0)
	Parent.dw_4.SetRow(ll_row)
	Parent.dw_4.SetColumn("mat_cd") 
	IF lds_Source.GetItemString(1,"mat_item") = 'A' THEN 
	   Parent.dw_4.SetItem(ll_row, "mat_fg", 'C')
	ELSE
	   Parent.dw_4.SetItem(ll_row, "mat_fg", lds_Source.GetItemString(1,"mat_type"))
	END IF
	Parent.dw_4.SetItem(ll_row, "color",     "XX")
	Parent.dw_4.SetItem(ll_row, "mat_cd",    lds_Source.GetItemString(1,"mat_cd"))
	Parent.dw_4.SetItem(ll_row, "mat_nm",    lds_Source.GetItemString(1,"mat_nm"))
	Parent.dw_4.SetItem(ll_row, "mat_color", "XX")
	Parent.dw_4.SetItem(ll_row, "spec",      "XX")
   ib_changed = true
   cb_update.enabled = true
	/* 다음컬럼으로 이동 */
	Parent.dw_4.ScrollToRow(ll_row)
	Parent.dw_4.SetFocus()
	Parent.dw_4.SetColumn("req_qty")
	ib_itemchanged = False 
END IF

Destroy  lds_Source

end event

type dw_4 from datawindow within tabpage_4
event type integer ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
event ue_keydown pbm_dwnkey
integer x = 562
integer y = 4
integer width = 2994
integer height = 868
integer taborder = 100
boolean bringtotop = true
string title = "none"
string dataobject = "d_12020_d05"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_mat_nm, ls_null
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
			gst_cd.datawindow_nm   = "d_com913" 
			gst_cd.default_where   = "where brand      = '" + is_brand + "'" + &
			                         "  and mat_year   = '" + is_year  + "'" + &
											 "  and mat_season = '" + is_season + "'" 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "mat_cd LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				This.SetRow(al_row)
				This.SetColumn(as_column)
				This.SetItem(al_row, "mat_fg", lds_Source.GetItemString(1,"mat_type"))
				This.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
				This.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))

				This.SetItem(al_row, "mat_color", ls_null)
            ib_changed = true
            cb_update.enabled = true
				/* 다음컬럼으로 이동 */
				This.SetColumn("mat_color")
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

event ue_keydown;/*===========================================================================*/
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

event editchanged;/*===========================================================================*/
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

event dberror;///*===========================================================================*/
///* 작성자      : (주)지우정보 (김 태범)                                      */	
///* 작성일      : 1999.11.09																  */	
///* 수정일      : 2002.01.08																  */
///*===========================================================================*/
//
//string ls_message_string
//
//CHOOSE CASE sqldbcode
//	CASE 2627
//		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
//	CASE 515
//		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
//	CASE -1
//		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
//	CASE ELSE
//		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
//		   				     "~n" + "에러메세지("+sqlerrtext+")" 
//END CHOOSE
//
//This.ScrollTorow(row)
//This.SetRow(row)
//This.SetFocus()
//
//MessageBox(parentwindow().GetActivesheet().title + "[부자재]", ls_message_string)
//
//return 1
end event

event buttonclicked;/*===========================================================================*/
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

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.08                                                  */	
/* 수정일      : 2001.01.08                                                  */
/*===========================================================================*/
String  ls_color, ls_mat_cd, ls_spec
Decimal ldc_stock_qty, ldc_resv_qty, ldc_need_qty


ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false

CHOOSE CASE dwo.name
	CASE "mat_cd"
		IF ib_itemchanged THEN RETURN 1
		return This.Trigger Event ue_Popup(dwo.name, row, data, 1)
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
		ldc_need_qty = Round(wf_Get_pcs(ls_color) * Dec(Data), 1)
		This.Setitem(row, "need_qty",   ldc_need_qty)
		This.Setitem(row, "t_need_qty", ldc_need_qty)
END CHOOSE

end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

end event

event itemerror;return 1
end event

event constructor;DataWindowChild ldw_child 

This.GetChild("mat_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.retrieve('123')
ldw_child.SetFilter("inter_cd <> 'A'")
ldw_child.Filter()

This.GetChild("color", idw_color_4)
idw_color_4.SetTransObject(SQLCA)
idw_color_4.retrieve()

end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 668
long backcolor = 79741120
string text = "sub공정"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_5.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_5.destroy
destroy(this.dw_5)
end on

type dw_5 from datawindow within tabpage_5
integer width = 3557
integer height = 872
integer taborder = 120
string title = "none"
string dataobject = "d_12010_d06"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_child

This.GetChild("sub_job", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('310')
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 668
long backcolor = 79741120
string text = "진행내역"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_6 dw_6
end type

on tabpage_6.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tabpage_6.destroy
destroy(this.dw_6)
end on

type dw_6 from datawindow within tabpage_6
integer width = 3557
integer height = 872
integer taborder = 130
string title = "none"
string dataobject = "d_12010_d07"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_8 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 668
long backcolor = 79741120
string text = "수정사항"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_8 dw_8
end type

on tabpage_8.create
this.dw_8=create dw_8
this.Control[]={this.dw_8}
end on

on tabpage_8.destroy
destroy(this.dw_8)
end on

type dw_8 from datawindow within tabpage_8
integer width = 3566
integer height = 772
integer taborder = 150
string title = "none"
string dataobject = "d_12020_d09"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
end event

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3566
integer height = 668
long backcolor = 79741120
string text = "패브릭가이드"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_11 dw_11
end type

on tabpage_7.create
this.dw_11=create dw_11
this.Control[]={this.dw_11}
end on

on tabpage_7.destroy
destroy(this.dw_11)
end on

type dw_11 from datawindow within tabpage_7
integer width = 3566
integer height = 668
integer taborder = 160
string dataobject = "d_12050_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_7 from datawindow within w_12020_d
boolean visible = false
integer x = 677
integer y = 148
integer width = 2921
integer height = 1868
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "SKETCH"
string dataobject = "d_12010_pic"
boolean controlmenu = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_sketch from commandbutton within w_12020_d
integer x = 2299
integer y = 44
integer width = 402
integer height = 92
integer taborder = 150
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "SKETCH"
end type

event clicked;IF dw_7.visible then
	dw_7.visible = false
else
	dw_7.visible = true
end if

end event

