$PBExportHeader$w_12a10_e.srw
$PBExportComments$전자 작업 지시서
forward
global type w_12a10_e from w_com010_e
end type
type cb_del_all from commandbutton within w_12a10_e
end type
type dw_master from datawindow within w_12a10_e
end type
type dw_spec from datawindow within w_12a10_e
end type
type dw_detail from datawindow within w_12a10_e
end type
type tab_1 from tab within w_12a10_e
end type
type tabpage_1 from userobject within tab_1
end type
type cb_spec_set from commandbutton within tabpage_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cb_spec_set cb_spec_set
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
type cb_order from commandbutton within tabpage_4
end type
type dw_4 from datawindow within tabpage_4
end type
type cb_5 from commandbutton within tabpage_4
end type
type tabpage_4 from userobject within tab_1
cb_order cb_order
dw_4 dw_4
cb_5 cb_5
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
type cb_smat_set from commandbutton within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_6 dw_6
cb_smat_set cb_smat_set
end type
type tabpage_7 from userobject within tab_1
end type
type dw_7 from datawindow within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_7 dw_7
end type
type tabpage_8 from userobject within tab_1
end type
type dw_8 from datawindow within tabpage_8
end type
type tabpage_8 from userobject within tab_1
dw_8 dw_8
end type
type tab_1 from tab within w_12a10_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
end type
type cb_copy_style from commandbutton within w_12a10_e
end type
type dw_copy_style from datawindow within w_12a10_e
end type
type cbx_pop from checkbox within w_12a10_e
end type
type dw_label from datawindow within w_12a10_e
end type
type dw_date from datawindow within w_12a10_e
end type
type st_1 from statictext within w_12a10_e
end type
type cb_4 from commandbutton within w_12a10_e
end type
type cb_connect from commandbutton within w_12a10_e
end type
type cb_getfile from commandbutton within w_12a10_e
end type
type cb_putfile from commandbutton within w_12a10_e
end type
type cb_disconnect from commandbutton within w_12a10_e
end type
type dw_ftp from datawindow within w_12a10_e
end type
type dw_accept from datawindow within w_12a10_e
end type
type cb_1 from commandbutton within w_12a10_e
end type
end forward

global type w_12a10_e from w_com010_e
integer width = 5161
integer height = 2368
event ue_first_open ( )
cb_del_all cb_del_all
dw_master dw_master
dw_spec dw_spec
dw_detail dw_detail
tab_1 tab_1
cb_copy_style cb_copy_style
dw_copy_style dw_copy_style
cbx_pop cbx_pop
dw_label dw_label
dw_date dw_date
st_1 st_1
cb_4 cb_4
cb_connect cb_connect
cb_getfile cb_getfile
cb_putfile cb_putfile
cb_disconnect cb_disconnect
dw_ftp dw_ftp
dw_accept dw_accept
cb_1 cb_1
end type
global w_12a10_e w_12a10_e

type variables
String  is_style, is_chno, is_brand, is_year, is_season, is_sojae, is_item , is_country_cd, is_make_type, is_orgmat_cd, is_out_seq, is_out_seq2, is_brand_nm
String  is_size[], is_zsojae, is_zitem, is_ctrl_brand, is_out_seq_chn, is_make_ymd,is_concept, is_job, is_file_nm, is_order_id, is_path, is_select
Boolean ib_read[], bl_connect
DataWindowChild idw_color, idw_color_3, idw_color_4 , idw_style_type, idw_fabric_by, idw_spec_cd

end variables

forward prototypes
public function long wf_get_pcs (string as_color)
public function integer wf_get_pcs_exp (string as_color)
public function boolean wf_mat_cd_chk (string as_mat_cd)
public function boolean wf_mat_stock (string as_mat_cd, string as_color, ref string as_spec, ref decimal adc_stock_qty, ref decimal adc_resv_qty)
public function boolean wf_del_check (long al_row, datawindow adw_temp)
public function boolean wf_style_chk (string as_style)
public subroutine wf_set_color (integer ai_index)
public subroutine wf_display_spec ()
public subroutine wf_set_size ()
public subroutine wf_save_spec ()
public subroutine wf_mat_info_set (long al_row, string as_mat_cd)
public function boolean wf_resv_update (ref string as_errmsg)
public subroutine wf_accept_ck ()
public subroutine wf_tab_retrieve (integer ai_index)
public subroutine wf_tab_insert (integer ai_tab)
public function boolean wf_tab_update (datetime adt_datetime, ref string as_errmsg)
end prototypes

event ue_first_open();/*------------------------------------------------------------*/
/* 내        용  : 기본 WINDOW를 Open한다. 'W_CU100_e04'      */
/*------------------------------------------------------------*/
Window lw_window

lw_window = This
//gf_open_sheet(lw_window, 'W_21004_e', '부자재발주등록')


end event

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

public function boolean wf_style_chk (string as_style);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* 품번 코드 CHECK  */
 
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_seq, ls_nm , ls_syear, ls_brand1
DataWindowChild ldw_child

IF isnull(as_style) OR LenA(as_style) <> 9 THEN Return False

// 브랜드 
ls_brand  = MidA(as_style, 1, 1)
IF gf_inter_nm('001', ls_brand, ls_nm) <> 0 THEN Return False 


select case when :as_style like '[BP]X3X___%' then '20132' else dbo.sf_inter_cd1('002',substring(:as_style,3,1)) + convert(char(1),dbo.sf_inter_sort_seq('003',substring(:as_style,4,1))) end
into :ls_syear
from dual;


if ls_syear >= "20133"  then
	ls_brand1 = MidA(as_style,1,1)
else	
	ls_brand1 = ls_brand
end if

				
				dw_master.GetChild("sojae", ldw_child)
				ldw_child.SetTransObject(SQLCA)
				ldw_child.Retrieve('%' ,ls_brand1)


				ldw_child.SetRedraw(false)
				ldw_child.setFilter( " sojae <> 'O'");
				ldw_child.Filter()
				ldw_child.SetRedraw(true)
				
				
				dw_master.GetChild("zsojae", ldw_child)
				ldw_child.SetTransObject(SQLCA)
				ldw_child.Retrieve('%',ls_brand1)
				ldw_child.SetRedraw(false)
				if ls_brand1 = "P" or ls_brand1 = "B" or ls_brand1 = "K" then
				else
					ldw_child.setFilter( " sojae <> 'A' and sojae <> 'B' and sojae <> 'C' and sojae <> 'D' and sojae <> 'Y' and sojae <> 'O'  ");
				end if					
				ldw_child.Filter()
				ldw_child.SetRedraw(true)
				
				
				dw_master.GetChild("item", ldw_child)
				ldw_child.SetTransObject(SQLCA)
				ldw_child.Retrieve(ls_brand1)
				ldw_child.SetRedraw(false)
				ldw_child.setFilter( " item <> '1' ");
				ldw_child.Filter()
				ldw_child.SetRedraw(true)
				
				dw_master.GetChild("zitem", ldw_child)
				ldw_child.SetTransObject(SQLCA)
				ldw_child.Retrieve(ls_brand1)
				ldw_child.SetRedraw(false)
				ldw_child.setFilter( "item <> 'Z' and item <> 'X' and item <> '1' ");
				ldw_child.Filter()
				ldw_child.SetRedraw(true)



// 소재
ls_sojae  = MidA(as_style, 2, 1)
IF ls_syear <= '20134' and ls_brand = 'B' or ls_brand = 'P'  then
	IF gf_sojae_nm(ls_sojae, ls_nm) <> 0 THEN Return False 
ELSE
	IF gf_sojae_nm2(ls_sojae, ls_brand1, ls_nm) <> 0 THEN Return False 
END IF
//시즌년도 
ls_year   = MidA(as_style, 3, 1)
IF gf_inter_nm('002', ls_year, ls_nm) <> 0 THEN Return False 
// 시즌 
ls_season = MidA(as_style, 4, 1)
IF gf_inter_nm('003', ls_season, ls_nm) <> 0 THEN Return False 
// 품종 
ls_item = MidA(as_style, 5, 1)
IF ls_syear <= '20134' and ls_brand = 'B' or ls_brand = 'P'  then
	IF gf_item_nm(ls_item, ls_nm) <> 0 THEN Return False 
ELSE
	IF gf_item_nm2(ls_item, ls_brand1,ls_nm) <> 0 THEN Return False 
END IF
// 순번 
ls_seq = MidA(as_style, 6, 3)
Return match(ls_seq, "[0-Z][0-Z][0-Z]")

 
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
//		dw_spec.DeleteRow(i)
	ELSE 
		tab_1.tabpage_2.dw_2.Setitem(ll_row, "size_spec_" + String(j), dw_spec.GetitemDecimal(i, "size_spec"))
	END IF
NEXT

/* 제품 치수내역 정렬 */
tab_1.tabpage_2.dw_2.SetSort("spec_fg A, spec_cd A")
tab_1.tabpage_2.dw_2.Sort()
tab_1.tabpage_2.dw_2.ResetUpdate()

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

public subroutine wf_save_spec ();/*-------------------------------------------------*/
/* tab_1.tabpage_2.dw_2 내용을 dw_spec로 이관 처리 */
/*-------------------------------------------------*/

String  ls_spec_fg,    ls_spec_cd, ls_size, ls_find, ls_flag
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

 		IF isnull(ldc_size_spec)   THEN CONTINUE

		ls_find = "spec_fg = '" + ls_spec_fg + "' and spec_cd = '" + & 
		          ls_spec_cd + "' and size = '" + ls_size + "'"
		ll_row  = dw_spec.find(ls_find, 1, dw_spec.RowCount()) 
		IF ll_row < 1 THEN
			ll_row = dw_spec.insertRow(0)
	      dw_spec.Setitem(ll_row, "spec_fg", ls_spec_fg)
	      dw_spec.Setitem(ll_row, "spec_cd", ls_spec_cd)
	      dw_spec.Setitem(ll_row, "size",    ls_size)
		END IF
		ls_flag = dw_spec.Getitemstring(ll_row,"update_flag")
		if  ls_flag = 'N' then 
			dw_spec.SetItemStatus(ll_row, 0, Primary!, NewModified!)
		end if
      dw_spec.Setitem(ll_row, "spec_term", ldc_spec_term)
      dw_spec.Setitem(ll_row, "size_spec", ldc_size_spec)
	NEXT 
NEXT

///* 제품 치수가 없는자료는 삭제 */

//FOR i = 1 to   dw_spec.RowCount() 
//	ldc_size_spec = dw_spec.GetitemDecimal(i, "size_spec")
//   IF isnull(ldc_size_spec) OR ldc_size_spec = 0 THEN 
//		dw_spec.DeleteRow(i)
//	END IF
//NEXT
//
end subroutine

public subroutine wf_mat_info_set (long al_row, string as_mat_cd);/*
String ls_patt_type, ls_OrgMat_Cd, ls_country_cd, ls_patt_chk, ls_OrgMat_chk
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
   IF len(ls_patt_type) > 0 THEN
      dw_master.Setitem(1, "patt_type", ls_patt_type) 
	END IF
   IF len(ls_country_cd) > 0 THEN
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
   IF len(ls_OrgMat_Cd) > 0 THEN
      dw_master.Setitem(1, "orgmat_cd", ls_OrgMat_Cd)								 
	END IF
END IF
*/
end subroutine

public function boolean wf_resv_update (ref string as_errmsg);/*
// 원자재 출고 예약량 처리 

String  ls_mat_cd, ls_mat_color 
Decimal ldc_t_need_qty,  ldc_resv_qty
Long    i

// 삭제자료  예약량 차감 

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

// 신규 및 수정 자료  예약량 차감 
IF tab_1.tabpage_3.dw_3.ModifiedCount() > 0  THEN
	FOR i = 1 TO tab_1.tabpage_3.dw_3.RowCount()
		idw_status = tab_1.tabpage_3.dw_3.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN				// New Record 
	      ls_mat_cd    = tab_1.tabpage_3.dw_3.GetitemString(i, "mat_cd")
	      ls_mat_color = tab_1.tabpage_3.dw_3.GetitemString(i, "mat_color")
	      ldc_resv_qty = tab_1.tabpage_3.dw_3.GetitemDecimal(i, "t_need_qty")
			IF isnull(ldc_resv_qty) THEN ldc_resv_qty = 0 
		ELSEIF idw_status = DataModified! THEN	      // Modify Record 
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
*/
Return TRUE 
end function

public subroutine wf_accept_ck ();
string ls_empno_1, ls_empno_2, ls_empno_3, ls_empno_4, ls_empno_5, ls_empno_6, ls_empno_7, ls_empno_8, ls_empno_9, ls_empno_10, ls_empno_11

ls_empno_1 = dw_accept.getitemstring(1,'empno_1')
ls_empno_2 = dw_accept.getitemstring(1,'empno_2')
ls_empno_3 = dw_accept.getitemstring(1,'empno_3')
ls_empno_4 = dw_accept.getitemstring(1,'empno_4')
ls_empno_5 = dw_accept.getitemstring(1,'empno_5')
ls_empno_6 = dw_accept.getitemstring(1,'empno_6')
ls_empno_7 = dw_accept.getitemstring(1,'empno_7')
ls_empno_8 = dw_accept.getitemstring(1,'empno_8')
ls_empno_9 = dw_accept.getitemstring(1,'empno_9')
ls_empno_10 = dw_accept.getitemstring(1,'empno_10')
ls_empno_11 = dw_accept.getitemstring(1,'empno_11')

if isnull(ls_empno_1) or ls_empno_1 = '' then
	dw_accept.object.cb_1.visible = true
	dw_accept.object.empnm_1.visible = true
else
	dw_accept.object.cb_1.visible = false
	dw_accept.object.empno_1.visible = false
end if

if isnull(ls_empno_2) or ls_empno_2 = '' then
	dw_accept.object.cb_2.visible = true
	dw_accept.object.empnm_2.visible = true
else
	dw_accept.object.cb_2.visible = false
	dw_accept.object.empno_2.visible = false
end if

if isnull(ls_empno_3) or ls_empno_3 = '' then
	dw_accept.object.cb_3.visible = true
	dw_accept.object.empnm_3.visible = true
else
	dw_accept.object.cb_3.visible = false
	dw_accept.object.empno_3.visible = false
end if

if isnull(ls_empno_4) or ls_empno_4 = '' then
	dw_accept.object.cb_4.visible = true
	dw_accept.object.empnm_4.visible = true
else
	dw_accept.object.cb_4.visible = false
	dw_accept.object.empno_4.visible = false
end if

if isnull(ls_empno_5) or ls_empno_5 = '' then
	dw_accept.object.cb_5.visible = true
	dw_accept.object.empnm_5.visible = true
else
	dw_accept.object.cb_5.visible = false
	dw_accept.object.empno_5.visible = false
end if

if isnull(ls_empno_6) or ls_empno_6 = '' then
	dw_accept.object.cb_6.visible = true
	dw_accept.object.empnm_6.visible = true
else
	dw_accept.object.cb_6.visible = false
	dw_accept.object.empno_6.visible = false
end if

if isnull(ls_empno_7) or ls_empno_7 = '' then
	dw_accept.object.cb_7.visible = true
	dw_accept.object.empnm_7.visible = true
else
	dw_accept.object.cb_7.visible = false
	dw_accept.object.empno_7.visible = false
end if

if isnull(ls_empno_8) or ls_empno_8 = '' then
	dw_accept.object.cb_8.visible = true
	dw_accept.object.empnm_8.visible = true
else
	dw_accept.object.cb_8.visible = false
	dw_accept.object.empno_8.visible = false
end if

if isnull(ls_empno_9) or ls_empno_9 = '' then
	dw_accept.object.cb_9.visible = true
	dw_accept.object.empnm_9.visible = true
else

	dw_accept.object.cb_9.visible = false
	dw_accept.object.empno_9.visible = false
end if

if isnull(ls_empno_10) or ls_empno_10 = '' then
	dw_accept.object.cb_10.visible = true
	dw_accept.object.empnm_10.visible = true
else
	dw_accept.object.cb_10.visible = false
	dw_accept.object.empno_10.visible = false
end if

if isnull(ls_empno_11) or ls_empno_11 = '' then
	dw_accept.object.cb_11.visible = true
	dw_accept.object.empnm_11.visible = true
else
	dw_accept.object.cb_11.visible = false
	dw_accept.object.empno_11.visible = false
end if

end subroutine

public subroutine wf_tab_retrieve (integer ai_index);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* TABPAGE별 조회   */
long ll_user_level, ll_cnt_1
string ls_order_id, ls_i, ls_pic, ls_p
int i
ll_user_level = gl_user_level

IF ib_read[ai_index] THEN RETURN 

/*
//원가 담당 브랜드(기획엠디)
select '999'
	into :ll_user_level		
from tb_93013_d(nolock) 
where person_id = :gs_user_id
and   work_gbn = '1'
and   ctrl_brand like '%'+:is_brand+'%';
*/
ls_order_id = dw_master.getitemstring(1,'order_id')

//////////////////////

CHOOSE CASE ai_index
	CASE 1 
		tab_1.tabpage_1.dw_1.Retrieve(ls_order_id)
	CASE 2
		tab_1.tabpage_2.dw_2.Retrieve(ls_order_id)
	CASE 3 
		tab_1.tabpage_3.dw_3.Retrieve(ls_order_id) 
	CASE 4 
		tab_1.tabpage_4.dw_4.Retrieve(ls_order_id) 
		tab_1.tabpage_4.dw_4.Object.p_1.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_1")
		tab_1.tabpage_4.dw_4.Object.p_2.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_2")
		tab_1.tabpage_4.dw_4.Object.p_3.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_3")
		tab_1.tabpage_4.dw_4.Object.p_4.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_4")
		tab_1.tabpage_4.dw_4.Object.p_5.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_5")
		tab_1.tabpage_4.dw_4.Object.p_6.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_6")
		tab_1.tabpage_4.dw_4.Object.p_7.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_7")
		tab_1.tabpage_4.dw_4.Object.p_8.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_8")
		tab_1.tabpage_4.dw_4.Object.p_9.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_9")
		tab_1.tabpage_4.dw_4.Object.p_10.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_10")
		tab_1.tabpage_4.dw_4.Object.p_11.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_11")
		tab_1.tabpage_4.dw_4.Object.p_12.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_12")
		tab_1.tabpage_4.dw_4.Object.p_13.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_13")
		tab_1.tabpage_4.dw_4.Object.p_14.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_14")
		tab_1.tabpage_4.dw_4.Object.p_15.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_15")
		tab_1.tabpage_4.dw_4.Object.p_16.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_16")
		tab_1.tabpage_4.dw_4.Object.p_17.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_17")
		tab_1.tabpage_4.dw_4.Object.p_18.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_18")
		tab_1.tabpage_4.dw_4.Object.p_19.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_19")
		tab_1.tabpage_4.dw_4.Object.p_20.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_20")

//		for i=1 to tab_1.tabpage_4.dw_4.rowcount()
//			ls_i = string(i)
//			ls_pic = 'tab_1.tabpage_4.dw_4.Object.'
//			ls_p = ls_pic + 'p_' + ls_i + '.FileName'
//			ls_p = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_"+ls_i)
			
//			tab_1.tabpage_4.dw_4.Object.p_1.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_"+ls_i)
//			tab_1.tabpage_4.dw_4.Object.p_2.FileName = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_2")
//		next
	CASE 5 
		tab_1.tabpage_5.dw_5.Retrieve(ls_order_id) 
	CASE 6 
		tab_1.tabpage_6.dw_6.Retrieve(ls_order_id) 
	CASE 7 
		tab_1.tabpage_7.dw_7.Retrieve(ls_order_id) 
	CASE 8 
		tab_1.tabpage_8.dw_8.Retrieve(ls_order_id) 
END CHOOSE

ib_read[ai_index] = True

end subroutine

public subroutine wf_tab_insert (integer ai_tab);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* TABPAGE별 Insert   */
long ll_user_level
string ls_spec_fg, ls_spec_cd, ls_smat_fg
int i,j,k
Long   ll_row ,ll_row_1


//////////////////////
if ai_tab = 1 then
	select count(inter_cd)
	into   :ll_row
	from   tb_91011_c
	where  inter_grp = '128';
		
	for i = 1 to ll_row
		tab_1.tabpage_1.dw_1.insertRow(0)
		
		SELECT inter_cd1, inter_cd
		into   :ls_spec_fg, :ls_spec_cd
		FROM   tb_91011_c (nolock)
		WHERE inter_grp = "128"	
				and sort_seq = :i;				
				
		tab_1.tabpage_1.dw_1.Setitem(i, "spec_fg",     ls_spec_fg) 
		tab_1.tabpage_1.dw_1.Setitem(i, "spec_cd",      ls_spec_cd) 
		tab_1.tabpage_1.dw_1.Setitem(i, "size",     '01') 

	next

	j=0
	for i = 1 + ll_row to ll_row + ll_row
		
		 j = j + 1
		tab_1.tabpage_1.dw_1.insertRow(0)
		
		SELECT inter_cd1, inter_cd
		into   :ls_spec_fg, :ls_spec_cd
		FROM   tb_91011_c (nolock)
		WHERE inter_grp = "128"	
				and sort_seq = :j;				
				
		tab_1.tabpage_1.dw_1.Setitem(i, "spec_fg",     ls_spec_fg) 
		tab_1.tabpage_1.dw_1.Setitem(i, "spec_cd",      ls_spec_cd) 
		tab_1.tabpage_1.dw_1.Setitem(i, "size",     '02') 
	next		

	k=0
	for i = 1 + ll_row + ll_row to ll_row + ll_row + ll_row
		
		 k = k + 1
		tab_1.tabpage_1.dw_1.insertRow(0)
		
		SELECT inter_cd1, inter_cd
		into   :ls_spec_fg, :ls_spec_cd
		FROM   tb_91011_c (nolock)
		WHERE inter_grp = "128"	
				and sort_seq = :K;				
				
		tab_1.tabpage_1.dw_1.Setitem(i, "spec_fg",     ls_spec_fg) 
		tab_1.tabpage_1.dw_1.Setitem(i, "spec_cd",      ls_spec_cd) 
		tab_1.tabpage_1.dw_1.Setitem(i, "size",     'ZZ') 
	next
	
	ib_changed = true
	cb_update.enabled = true
	cb_print.enabled = false
	cb_preview.enabled = false		

elseif ai_tab = 6 then
	select count(inter_cd)
	into   :ll_row_1
	from   tb_91011_c
	where  inter_grp = '129';
	
	for i = 1 to ll_row_1
		tab_1.tabpage_6.dw_6.insertRow(0)
		
		SELECT inter_cd
		into   :ls_smat_fg
		FROM   tb_91011_c (nolock)
		WHERE inter_grp = "129"	
				and sort_seq = :i;				

		tab_1.tabpage_6.dw_6.Setitem(i, "smat_fg",     ls_smat_fg) 
		ib_changed = true
		cb_update.enabled = true
		cb_print.enabled = false
		cb_preview.enabled = false	
	next
end if

end subroutine

public function boolean wf_tab_update (datetime adt_datetime, ref string as_errmsg);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/

// tabpage datawindow 저장 처리 
Long    i, ll_row 
String  ls_color, ls_size, ls_uid, ls_order_id, ls_style, ls_chno, ls_no, ls_mat_uid, ls_spec_fg, ls_spec_cd, ls_mat_cd, ls_smat_fg, ls_mat_uid1, ls_mat_no1, ls_mat_cd1, ls_image, ls_mod_no
datetime ld_datetime

gf_sysdate(ld_datetime)

dw_master.accepttext()
tab_1.tabpage_1.dw_1.accepttext()
tab_1.tabpage_2.dw_2.accepttext()
tab_1.tabpage_3.dw_3.accepttext()
tab_1.tabpage_4.dw_4.accepttext()
tab_1.tabpage_5.dw_5.accepttext()
tab_1.tabpage_6.dw_6.accepttext()
tab_1.tabpage_7.dw_7.accepttext()
tab_1.tabpage_8.dw_8.accepttext()

ls_order_id = dw_master.getitemstring(1,'order_id')
ls_style = dw_master.getitemstring(1,'style')
ls_chno = dw_master.getitemstring(1,'chno')


//완성제품치수
FOR i = 1 TO tab_1.tabpage_1.dw_1.DeletedCount() 
	ls_spec_fg = tab_1.tabpage_1.dw_1.GetitemString(i, "spec_fg", delete!, true)
	ls_spec_cd  = tab_1.tabpage_1.dw_1.GetitemString(i, "spec_cd",  delete!, true) 
NEXT

FOR i = 1 TO tab_1.tabpage_1.dw_1.RowCount()
   idw_status = tab_1.tabpage_1.dw_1.GetItemStatus(i, 0, Primary!)
	
	select right(isnull(max(right(mod_no,3)), 0) + 1001, 3)
	into :ls_mod_no
	from tb_12A23_d with (nolock)
	where order_id = :ls_order_id;
	
   IF idw_status = NewModified! THEN				// New Record 

		select 'O' + right(isnull(max(right(uid,5)), 0) + 100001, 5)
		into :ls_uid
		from tb_12A23_d with (nolock);
		
      tab_1.tabpage_1.dw_1.Setitem(i, "uid",  	ls_uid)			
		tab_1.tabpage_1.dw_1.Setitem(i, "order_id",	ls_order_id)
		tab_1.tabpage_1.dw_1.Setitem(i, "mod_no",	ls_mod_no)
		tab_1.tabpage_1.dw_1.Setitem(i, "reg_id", gs_user_id)
		tab_1.tabpage_1.dw_1.Setitem(i, "reg_dt", ld_datetime)
	ELSEIF idw_status = DataModified! THEN		   // Modify Record 
		tab_1.tabpage_1.dw_1.Setitem(i, "mod_no",	ls_mod_no)
		tab_1.tabpage_1.dw_1.Setitem(i, "mod_id", gs_user_id)
		tab_1.tabpage_1.dw_1.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

//원자재요청_기획
FOR i = 1 TO tab_1.tabpage_2.dw_2.DeletedCount() 
	ls_mat_cd = tab_1.tabpage_2.dw_2.GetitemString(i, "mat_cd", delete!, true)
NEXT

FOR i = 1 TO tab_1.tabpage_2.dw_2.RowCount()
   idw_status = tab_1.tabpage_2.dw_2.GetItemStatus(i, 0, Primary!)

	select right(isnull(max(right(mod_no,3)), 0) + 1001, 3)
	into :ls_mod_no
	from tb_12A25_m with (nolock)
	where order_id = :ls_order_id;
	
   IF idw_status = NewModified! THEN				// New Record 

		select 'O' + right(isnull(max(right(uid,5)), 0) + 100001, 5)
		into :ls_uid
		from tb_12A25_m with (nolock);
		
		select right(isnull(max(right(no,4)), 0) + 10001, 4)
		into :ls_no
		from tb_12A25_m with (nolock)
		where uid = :ls_uid;

      tab_1.tabpage_2.dw_2.Setitem(i, "uid",  	ls_uid)
      tab_1.tabpage_2.dw_2.Setitem(i, "no",  	ls_no)		
		tab_1.tabpage_2.dw_2.Setitem(i, "order_id",	ls_order_id)
		tab_1.tabpage_2.dw_2.Setitem(i, "style",	ls_style)
		tab_1.tabpage_2.dw_2.Setitem(i, "chno",	ls_chno)
		tab_1.tabpage_2.dw_2.Setitem(i, "mod_no", ls_mod_no)
		tab_1.tabpage_2.dw_2.Setitem(i, "reg_id", gs_user_id)
		tab_1.tabpage_2.dw_2.Setitem(i, "reg_dt", ld_datetime)
	ELSEIF idw_status = DataModified! THEN		   // Modify Record
		tab_1.tabpage_2.dw_2.Setitem(i, "mod_no", ls_mod_no)
		tab_1.tabpage_2.dw_2.Setitem(i, "mod_id", gs_user_id)
		tab_1.tabpage_2.dw_2.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

//원자재요청_자재
FOR i = 1 TO tab_1.tabpage_3.dw_3.DeletedCount() 
	ls_mat_cd = tab_1.tabpage_3.dw_3.GetitemString(i, "mat_color", delete!, true)
NEXT

for i =1 to tab_1.tabpage_2.dw_2.rowcount()
	FOR i = 1 TO tab_1.tabpage_3.dw_3.RowCount()
		idw_status = tab_1.tabpage_3.dw_3.GetItemStatus(i, 0, Primary!)

		select right(isnull(max(right(mod_no,3)), 0) + 1001, 3)
		into :ls_mod_no
		from tb_12A25_d with (nolock)
		where order_id = :ls_order_id;
			
		IF idw_status = NewModified! THEN				// New Record 	
			select 'O' + right(isnull(max(right(uid,5)), 0) + 100001, 5)
			into :ls_uid
			from tb_12A25_d with (nolock);
			
			select right(isnull(max(right(no,4)), 0) + 10001, 4)
			into :ls_no
			from tb_12A25_d with (nolock)
			where uid = :ls_uid;
	
			tab_1.tabpage_3.dw_3.Setitem(i, "uid",  	ls_uid)
			tab_1.tabpage_3.dw_3.Setitem(i, "no",  	ls_no)		
			tab_1.tabpage_3.dw_3.Setitem(i, "order_id",	ls_order_id)
			tab_1.tabpage_3.dw_3.Setitem(i, "mod_no", ls_mod_no)
			tab_1.tabpage_3.dw_3.Setitem(i, "reg_id", gs_user_id)
			tab_1.tabpage_3.dw_3.Setitem(i, "reg_dt", ld_datetime)
		ELSEIF idw_status = DataModified! THEN		   // Modify Record
			tab_1.tabpage_3.dw_3.Setitem(i, "mod_no", ls_mod_no)
			tab_1.tabpage_3.dw_3.Setitem(i, "mod_id", gs_user_id)
			tab_1.tabpage_3.dw_3.Setitem(i, "mod_dt", ld_datetime)
		END IF
	NEXT
next

//swatch
FOR i = 1 TO tab_1.tabpage_4.dw_4.DeletedCount() 
	ls_image = tab_1.tabpage_4.dw_4.GetitemString(i, "image_1", delete!, true)
NEXT

FOR i = 1 TO tab_1.tabpage_4.dw_4.RowCount()
   idw_status = tab_1.tabpage_4.dw_4.GetItemStatus(i, 0, Primary!)
	
		select right(isnull(max(right(mod_no,3)), 0) + 1001, 3)
		into :ls_mod_no
		from tb_12A26_d with (nolock)
		where order_id = :ls_order_id;
	
   IF idw_status = NewModified! THEN				// New Record 

		select 'O' + right(isnull(max(right(uid,5)), 0) + 100001, 5)
		into :ls_uid
		from tb_12A26_d;

		select right(isnull(max(right(no,4)), 0) + 10000 + :i, 4)
		into :ls_no
		from tb_12A26_d with (nolock)
		where uid = :ls_uid;

      tab_1.tabpage_4.dw_4.Setitem(i, "uid",  	ls_uid)
		tab_1.tabpage_4.dw_4.Setitem(i, "no",  	ls_no)
		tab_1.tabpage_4.dw_4.Setitem(i, "order_id",	ls_order_id)
		tab_1.tabpage_4.dw_4.Setitem(i, "mod_no",	ls_mod_no)
		tab_1.tabpage_4.dw_4.Setitem(i, "reg_id", gs_user_id)
		tab_1.tabpage_4.dw_4.Setitem(i, "reg_dt", ld_datetime)
	ELSEIF idw_status = DataModified! THEN		   // Modify Record 
		tab_1.tabpage_4.dw_4.Setitem(i, "mod_no",	ls_mod_no)
		tab_1.tabpage_4.dw_4.Setitem(i, "mod_id", gs_user_id)
		tab_1.tabpage_4.dw_4.Setitem(i, "mod_dt", ld_datetime)
   END IF	
NEXT

// 후가공
FOR i = 1 TO tab_1.tabpage_5.dw_5.DeletedCount() 
	ls_color = tab_1.tabpage_5.dw_5.GetitemString(i, "color", delete!, true)
	ls_size  = tab_1.tabpage_5.dw_5.GetitemString(i, "size",  delete!, true) 
NEXT

FOR i = 1 TO tab_1.tabpage_5.dw_5.RowCount()
   idw_status = tab_1.tabpage_5.dw_5.GetItemStatus(i, 0, Primary!)

	select right(isnull(max(right(mod_no,3)), 0) + 1001, 3)
	into :ls_mod_no
	from tb_12A28_d with (nolock)
	where order_id = :ls_order_id;
	
   IF idw_status = NewModified! THEN				// New Record 

		select 'O' + right(isnull(max(right(uid,5)), 0) + 100001, 5)
		into :ls_uid
		from tb_12A28_d;

		select right(isnull(max(right(no,4)), 0) + 10000 + :i, 4)
		into :ls_no
		from tb_12A28_d with (nolock)
		where uid = :ls_uid;

      tab_1.tabpage_5.dw_5.Setitem(i, "uid",  	ls_uid)
		tab_1.tabpage_5.dw_5.Setitem(i, "no",  	ls_no)
		tab_1.tabpage_5.dw_5.Setitem(i, "order_id",	ls_order_id)
		tab_1.tabpage_5.dw_5.Setitem(i, "mod_no",	ls_mod_no)
		tab_1.tabpage_5.dw_5.Setitem(i, "reg_id", gs_user_id)
		tab_1.tabpage_5.dw_5.Setitem(i, "reg_dt", ld_datetime)
	ELSEIF idw_status = DataModified! THEN		   // Modify Record 
		tab_1.tabpage_5.dw_5.Setitem(i, "mod_no",	ls_mod_no)
		tab_1.tabpage_5.dw_5.Setitem(i, "mod_id", gs_user_id)
		tab_1.tabpage_5.dw_5.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

//부자재요청
FOR i = 1 TO tab_1.tabpage_6.dw_6.DeletedCount() 
	ls_smat_fg = tab_1.tabpage_6.dw_6.GetitemString(i, "smat_fg", delete!, true)
NEXT

FOR i = 1 TO tab_1.tabpage_6.dw_6.RowCount()
   idw_status = tab_1.tabpage_6.dw_6.GetItemStatus(i, 0, Primary!)

	select right(isnull(max(right(mod_no,3)), 0) + 1001, 3)
	into :ls_mod_no
	from tb_12A27_d with (nolock)
	where order_id = :ls_order_id;
	
   IF idw_status = NewModified! THEN				/* New Record */

		select 'O' + right(isnull(max(right(uid,5)), 0) + 100001, 5)
		into :ls_uid
		from tb_12A27_d with (nolock);

//		select convert(varchar(4), convert(decimal(5), isnull(max(no)+ 1, '0001')))
		select right(isnull(max(right(no,4)), 0) + 10000 + :i, 4)
		into :ls_no
		from tb_12A27_d with (nolock)
		where uid = :ls_uid;

      tab_1.tabpage_6.dw_6.Setitem(i, "uid",  	ls_uid)
      tab_1.tabpage_6.dw_6.Setitem(i, "no",  	ls_no)		
		tab_1.tabpage_6.dw_6.Setitem(i, "order_id",	ls_order_id)
		tab_1.tabpage_6.dw_6.Setitem(i, "style",	ls_style)
		tab_1.tabpage_6.dw_6.Setitem(i, "chno",	ls_chno)
		tab_1.tabpage_6.dw_6.Setitem(i, "mod_id", ls_mod_no)
		tab_1.tabpage_6.dw_6.Setitem(i, "reg_id", gs_user_id)
		tab_1.tabpage_6.dw_6.Setitem(i, "reg_dt", ld_datetime)
	ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
		tab_1.tabpage_6.dw_6.Setitem(i, "mod_id", ls_mod_no)
		tab_1.tabpage_6.dw_6.Setitem(i, "mod_id", gs_user_id)
		tab_1.tabpage_6.dw_6.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT



//배색정보
FOR i = 1 TO tab_1.tabpage_7.dw_7.DeletedCount() 
	ls_color = tab_1.tabpage_7.dw_7.GetitemString(i, "color", delete!, true)
	ls_size  = tab_1.tabpage_7.dw_7.GetitemString(i, "size",  delete!, true) 
NEXT

FOR i = 1 TO tab_1.tabpage_7.dw_7.RowCount()
   idw_status = tab_1.tabpage_7.dw_7.GetItemStatus(i, 0, Primary!)

	select right(isnull(max(right(mod_no,3)), 0) + 1001, 3)
	into :ls_mod_no
	from tb_12A24_d with (nolock)
	where order_id = :ls_order_id;
	
   IF idw_status = NewModified! THEN				// New Record 

		select 'O' + right(isnull(max(right(uid,5)), 0) + 100001, 5)
		into :ls_uid
		from tb_12A24_d with (nolock);
		
		select right(isnull(max(right(no,4)), 0) + 10000 + :i, 4)
		into :ls_no
		from tb_12A24_d with (nolock)
		where uid = :ls_uid;

      tab_1.tabpage_7.dw_7.Setitem(i, "uid",  	ls_uid)
		tab_1.tabpage_7.dw_7.Setitem(i, "no",  	ls_no)		
		tab_1.tabpage_7.dw_7.Setitem(i, "order_id",	ls_order_id)
      tab_1.tabpage_7.dw_7.Setitem(i, "style",  ls_style)
      tab_1.tabpage_7.dw_7.Setitem(i, "chno",   ls_chno)
		tab_1.tabpage_7.dw_7.Setitem(i, "mod_no", ls_mod_no)		
		tab_1.tabpage_7.dw_7.Setitem(i, "reg_id", gs_user_id)
		tab_1.tabpage_7.dw_7.Setitem(i, "reg_dt", ld_datetime)
	ELSEIF idw_status = DataModified! THEN		   // Modify Record 
		tab_1.tabpage_7.dw_7.Setitem(i, "mod_no", ls_mod_no)	
		tab_1.tabpage_7.dw_7.Setitem(i, "mod_id", gs_user_id)
		tab_1.tabpage_7.dw_7.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

// Assort 내역
FOR i = 1 TO tab_1.tabpage_8.dw_8.DeletedCount() 
	ls_color = tab_1.tabpage_8.dw_8.GetitemString(i, "color", delete!, true)
	ls_size  = tab_1.tabpage_8.dw_8.GetitemString(i, "size",  delete!, true) 
NEXT

FOR i = 1 TO tab_1.tabpage_8.dw_8.RowCount()
   idw_status = tab_1.tabpage_8.dw_8.GetItemStatus(i, 0, Primary!)
	
	select right(isnull(max(right(mod_no,3)), 0) + 1001, 3)
	into :ls_mod_no
	from tb_12A30_s with (nolock)
	where order_id = :ls_order_id;
	
   IF idw_status = NewModified! THEN				// New Record 

		select 'O' + right(isnull(max(right(uid,5)), 0) + 100001, 5)
		into :ls_uid
		from tb_12A30_s;

      tab_1.tabpage_8.dw_8.Setitem(i, "uid",  	ls_uid)
		tab_1.tabpage_8.dw_8.Setitem(i, "order_id",	ls_order_id)
      tab_1.tabpage_8.dw_8.Setitem(i, "style",  ls_style)
      tab_1.tabpage_8.dw_8.Setitem(i, "chno",   ls_chno)
		tab_1.tabpage_8.dw_8.Setitem(i, "mod_no",   ls_mod_no)
		tab_1.tabpage_8.dw_8.Setitem(i, "reg_id", gs_user_id)
		tab_1.tabpage_8.dw_8.Setitem(i, "reg_dt", ld_datetime)
	ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
		tab_1.tabpage_8.dw_8.Setitem(i, "mod_no",   ls_mod_no)
		tab_1.tabpage_8.dw_8.Setitem(i, "mod_id", gs_user_id)
		tab_1.tabpage_8.dw_8.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT


/*
tab_1.tabpage_1.dw_1.Update()
tab_1.tabpage_2.dw_2.Update()
tab_1.tabpage_3.dw_3.Update()
tab_1.tabpage_4.dw_4.Update()
tab_1.tabpage_5.dw_5.Update()
tab_1.tabpage_6.dw_6.Update()
tab_1.tabpage_7.dw_7.Update()
tab_1.tabpage_8.dw_8.Update()
*/
if tab_1.tabpage_1.dw_1.Update(true,false) <> 1 then return false
if tab_1.tabpage_2.dw_2.Update(true,false) <> 1 then return false
if tab_1.tabpage_3.dw_3.Update(true,false) <> 1 then return false
if tab_1.tabpage_4.dw_4.Update(true,false) <> 1 then return false
if tab_1.tabpage_5.dw_5.Update(true,false) <> 1 then return false
if tab_1.tabpage_6.dw_6.Update(true,false) <> 1 then return false
if tab_1.tabpage_7.dw_7.Update(true,false) <> 1 then return false
if tab_1.tabpage_8.dw_8.Update(true,false) <> 1 then return false

return true


end function

on w_12a10_e.create
int iCurrent
call super::create
this.cb_del_all=create cb_del_all
this.dw_master=create dw_master
this.dw_spec=create dw_spec
this.dw_detail=create dw_detail
this.tab_1=create tab_1
this.cb_copy_style=create cb_copy_style
this.dw_copy_style=create dw_copy_style
this.cbx_pop=create cbx_pop
this.dw_label=create dw_label
this.dw_date=create dw_date
this.st_1=create st_1
this.cb_4=create cb_4
this.cb_connect=create cb_connect
this.cb_getfile=create cb_getfile
this.cb_putfile=create cb_putfile
this.cb_disconnect=create cb_disconnect
this.dw_ftp=create dw_ftp
this.dw_accept=create dw_accept
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_del_all
this.Control[iCurrent+2]=this.dw_master
this.Control[iCurrent+3]=this.dw_spec
this.Control[iCurrent+4]=this.dw_detail
this.Control[iCurrent+5]=this.tab_1
this.Control[iCurrent+6]=this.cb_copy_style
this.Control[iCurrent+7]=this.dw_copy_style
this.Control[iCurrent+8]=this.cbx_pop
this.Control[iCurrent+9]=this.dw_label
this.Control[iCurrent+10]=this.dw_date
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.cb_4
this.Control[iCurrent+13]=this.cb_connect
this.Control[iCurrent+14]=this.cb_getfile
this.Control[iCurrent+15]=this.cb_putfile
this.Control[iCurrent+16]=this.cb_disconnect
this.Control[iCurrent+17]=this.dw_ftp
this.Control[iCurrent+18]=this.dw_accept
this.Control[iCurrent+19]=this.cb_1
end on

on w_12a10_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_del_all)
destroy(this.dw_master)
destroy(this.dw_spec)
destroy(this.dw_detail)
destroy(this.tab_1)
destroy(this.cb_copy_style)
destroy(this.dw_copy_style)
destroy(this.cbx_pop)
destroy(this.dw_label)
destroy(this.dw_date)
destroy(this.st_1)
destroy(this.cb_4)
destroy(this.cb_connect)
destroy(this.cb_getfile)
destroy(this.cb_putfile)
destroy(this.cb_disconnect)
destroy(this.dw_ftp)
destroy(this.dw_accept)
destroy(this.cb_1)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_emp_nm, ls_dept, ls_fr_style, ls_fr_chno, ls_mat_cd, ls_cust_nm, ls_brand, ls_syear, ls_order_id, ls_style_no
long		  ll_cnt_1
Boolean    lb_check 
DataStore  lds_Source
DataWindowChild ldw_child

CHOOSE CASE as_column
	CASE "order_id"	
			if isnull(as_data) or LenA(as_data) = 0 then return 1
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "작업지시서 검색" 
			gst_cd.datawindow_nm   = "d_com01a" 
			gst_cd.default_where   = "where order_id like '" + MidA(is_order_id, 1, 1) + "%'" 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " order_id LIKE '" + as_data + "%'"
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

				/* 다음컬럼으로 이동 */				
				is_order_id = lds_Source.GetItemString(al_row,"order_id")
				il_rows = dw_master.retrieve(is_order_id, is_style, is_chno)
				dw_master.Object.p_img.FileName = '\\220.118.68.4\olive_design\'+ dw_master.getitemstring(1, "image") 		
				is_job = '2'				
				ls_order_id = dw_master.getitemstring(1,'order_id')
				
				dw_head.setitem(1,'order_id',ls_order_id)
				dw_head.setitem(1,'style_no',dw_master.getitemstring(1,'style')+dw_master.getitemstring(1,'chno'))
				dw_date.retrieve(ls_order_id)				
				dw_accept.retrieve(ls_order_id)
				wf_accept_ck()
//				IF tab_1.selectedtab <> 1 THEN 				
				wf_tab_retrieve(1)
				wf_tab_retrieve(4)

					

//				END IF
			
				dw_master.TriggerEvent(Editchanged!)
//				dw_master.SetColumn("make_type")
				//조회 수정
				ib_itemchanged = False 
				lb_check = TRUE 
				This.Trigger Event ue_button(1, il_rows)
				This.Trigger Event ue_msg(1, il_rows)
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
					
		
	CASE "style_no"
		
			ls_style_no = dw_head.GetItemString(1,"style_no")
			ls_style =  LeftA(ls_style_no, 8)
			ls_chno =   MidA(ls_style_no, 9, 1)
			if isnull(ls_style) or ls_style = '' then
				ls_style = '%'
			end if
			
			if isnull(ls_chno) or ls_chno = '' then
				ls_chno = '%'
			end if
			
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "STYLE NO 검색" 
			gst_cd.datawindow_nm   = "d_com01a" 
			gst_cd.default_where   = "where style LIKE  '" + ls_style + "%'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " CHNO LIKE '" + ls_chno + "%' "
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
				ls_style_no = lds_Source.GetItemString(1,"style_no")
				dw_head.SetItem(al_row, "style_no",    ls_style_no)
				
				/* 다음컬럼으로 이동 */
				is_order_id = lds_Source.GetItemString(al_row,"order_id")

				il_rows = dw_master.retrieve(is_order_id, is_style, is_chno)
				dw_master.Object.p_img.FileName = '\\220.118.68.4\olive_design\'+ dw_master.getitemstring(1, "image") 
				is_job = '2'				
				ls_order_id = dw_master.getitemstring(1,'order_id')
				dw_head.setitem(1,'order_id',ls_order_id)
				dw_date.retrieve(ls_order_id)
				dw_accept.retrieve(ls_order_id)
				wf_accept_ck()
				wf_tab_retrieve(1)
				wf_tab_retrieve(4)
				dw_master.TriggerEvent(Editchanged!)

				//조회 수정

				ib_itemchanged = False 
				lb_check = TRUE 
				This.Trigger Event ue_button(1, il_rows)
				This.Trigger Event ue_msg(1, il_rows)
				
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
				cb_excel.enabled = false
			END IF
			Destroy  lds_Source
/*
	CASE "style_no"				
		   ls_style = Mid(as_data, 1, 8)
			ls_chno  = Mid(as_data, 9, 1)
			
			
			IF ai_div = 1 THEN 	
				IF gf_style_chk(ls_style, ls_chno) THEN
					
					select case when :ls_style like '[BP]X3X___%' then '20132' else dbo.sf_inter_cd1('002',substring(:ls_style,3,1)) + convert(char(1),dbo.sf_inter_sort_seq('003',substring(:ls_style,4,1))) end
					into :ls_syear
					from dual;
			
			
					if ls_syear >= "20133"  then
						ls_brand = mid(ls_style,1,1)
					else	
						ls_brand = "N"
					end if
					
					dw_master.GetChild("sojae", ldw_child)
					ldw_child.SetTransObject(SQLCA)
					ldw_child.Retrieve('%' ,ls_brand)
					ldw_child.SetRedraw(false)
					ldw_child.setFilter( " sojae <> 'O'");
					ldw_child.Filter()
					ldw_child.SetRedraw(true)
					
					
					dw_master.GetChild("zsojae", ldw_child)
					ldw_child.SetTransObject(SQLCA)
					ldw_child.Retrieve('%',ls_brand)
					ldw_child.SetRedraw(false)
					if ls_brand = "B" or ls_brand = "P" or ls_brand = "K" then
					else	
					ldw_child.setFilter( " sojae <> 'A' and sojae <> 'B' and sojae <> 'C' and sojae <> 'D' and sojae <> 'Y' and sojae <> 'O'  ");
					end if
					ldw_child.Filter()
					ldw_child.SetRedraw(true)
					
					
					dw_master.GetChild("item", ldw_child)
					ldw_child.SetTransObject(SQLCA)
					ldw_child.Retrieve(ls_brand)
					ldw_child.SetRedraw(false)
					ldw_child.setFilter( " item <> '1' ");
					ldw_child.Filter()
					ldw_child.SetRedraw(true)
					
					dw_master.GetChild("zitem", ldw_child)
					ldw_child.SetTransObject(SQLCA)
					ldw_child.Retrieve(ls_brand)
					ldw_child.SetRedraw(false)
					ldw_child.setFilter( "item <> 'Z' and item <> 'X' and item <> '1' ");
					ldw_child.Filter()
					ldw_child.SetRedraw(true)
					
					if gs_brand <> "K" then						
						RETURN 0
					else 
						if gs_brand <> mid(as_data,1,1) then
							Return 1
						else 
							RETURN 0
						end if	
					end if	
					
					
				END IF 
				IF wf_style_chk(as_data) THEN
					Return 0 
				ELSEIF Len(as_data) = 9 THEN
					MessageBox("오류", "품번 코드가 형식에 맞지안습니다 !")
					Return 1
				END IF
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 

			if gs_brand <> "K" then
			  gst_cd.default_where   = ""
			else
			  gst_cd.default_where   = "where style like 'K%' " 	
			end if  

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
			
			select case when :ls_style like '[BP]X3X___%' then '20132' else dbo.sf_inter_cd1('002',substring(:ls_style,3,1)) + convert(char(1),dbo.sf_inter_sort_seq('003',substring(:ls_style,4,1))) end
			into :ls_syear
			from dual;
			
			
			   if ls_syear >= "20133"  then
					ls_brand = mid(ls_style,1,1)
				else	
					ls_brand = "N"
				end if
				
				dw_master.GetChild("sojae", ldw_child)
				ldw_child.SetTransObject(SQLCA)
				ldw_child.Retrieve('%' ,ls_brand)
				ldw_child.SetRedraw(false)
				ldw_child.setFilter( " sojae <> 'O'");
				ldw_child.Filter()
				ldw_child.SetRedraw(true)
				
				
				dw_master.GetChild("zsojae", ldw_child)
				ldw_child.SetTransObject(SQLCA)
				ldw_child.Retrieve('%',ls_brand)
				ldw_child.SetRedraw(false)
				if ls_brand = "B" or ls_brand = "P" or ls_brand = "K" then
				else	
				ldw_child.setFilter( " sojae <> 'A' and sojae <> 'B' and sojae <> 'C' and sojae <> 'D' and sojae <> 'Y' and sojae <> 'O'  ");
			end if
				ldw_child.Filter()
				ldw_child.SetRedraw(true)
				
				
				dw_master.GetChild("item", ldw_child)
				ldw_child.SetTransObject(SQLCA)
				ldw_child.Retrieve(ls_brand)
				ldw_child.SetRedraw(false)
				ldw_child.setFilter( " item <> '1' ");
				ldw_child.Filter()
				ldw_child.SetRedraw(true)
				
				dw_master.GetChild("zitem", ldw_child)
				ldw_child.SetTransObject(SQLCA)
				ldw_child.Retrieve(ls_brand)
				ldw_child.SetRedraw(false)
				ldw_child.setFilter( "item <> 'Z' and item <> 'X' and item <> '1' ");
				ldw_child.Filter()
				ldw_child.SetRedraw(true)
			
			
			
			Destroy  lds_Source
	*/
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
					dw_master.Setitem(al_row, "dsgn_emp_nm", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			/* 관련부서 산출 */ 


			
//			if Mid(is_style, 1, 1) = 'M' then 
//		   	gst_cd.default_where   = "where goout_gubn = '1' and empno in('A10402','A40401') " /* 쇼핑몰(노주연,최문정) 추가 */  			
//			elseif Mid(is_style, 1, 1) = 'T' or Mid(is_style, 1, 1) = 'Y' then 
//		   	gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('T000','O100')" /* TASSE 추가 */  
//			elseif Mid(is_style, 1, 1) = 'W' then 
//			   gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('K100','K400','O100','B100')" /* W. 추가 */  
//			else
//				gf_get_inter_sub ('991', Mid(is_style, 1, 1) + '10', '1', ls_dept)
//				gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('" + ls_dept + "','B200','O200','O100','B100','O000','T100','T000','K400','N000')" /* 니트 , 악세라시 추가 */  
//			end if




			gst_cd.default_where   = "where goout_gubn = '1' " // and dept_code in ('K100','B200','O200','O100','B100','O000','T100','T000','K400','N000')" /* 니트 , 악세라시 추가 */  
			
			
			
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

is_order_id = dw_head.GetItemString(1, "order_id")
if IsNull(is_order_id) or Trim(is_order_id) = "" then
//   MessageBox(ls_title,"작업지서 ID를 입력하십시요!")
	is_order_id = '%'
   dw_head.SetFocus()
//   dw_head.SetColumn("order_id")
//   return false
end if

is_style  = MidA(ls_style_no, 1, 8)
is_chno   = MidA(ls_style_no, 9, 1)
is_brand  = MidA(is_style, 1, 1)

//select dbo.sf_inter_nm('019',:is_brand) into :is_brand_nm from dual;

//gf_get_inter_sub('002', Mid(is_style, 3, 1), '1', is_year)
//is_season = Mid(is_style, 4, 1)
//is_sojae  = Mid(is_style, 2, 1)
//is_item   = Mid(is_style, 5, 1)

//is_country_cd = dw_master.GetItemString(1, "country_cd2")

//is_make_type = dw_master.GetItemString(1, "make_type2")

//is_orgmat_cd = dw_master.GetItemString(1, "orgmat_cd2")

return true

end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 		   									  */	
/* 작성일      : 2002.01.08																  */	
/*===========================================================================*/
inv_resize.of_Register(cb_del_all, "FixedToRight")
/* Data window Resize */
inv_resize.of_Register(dw_master, "ScaleToBottom")
inv_resize.of_Register(tab_1,     "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_1,  "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_2,  "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_3.dw_3,  "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_4.dw_4,  "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_5.dw_5,  "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_6.dw_6,  "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_7.dw_7,  "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_8.dw_8,  "ScaleToRight&Bottom")


inv_resize.of_Register(dw_label, "ScaleToRight")
/* DataWindow의 Transction 정의 */
dw_master.SetTransObject(SQLCA)
dw_date.SetTransObject(SQLCA)
dw_accept.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
dw_spec.SetTransObject(SQLCA)


tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)
tab_1.tabpage_4.dw_4.SetTransObject(SQLCA)
tab_1.tabpage_5.dw_5.SetTransObject(SQLCA)
tab_1.tabpage_6.dw_6.SetTransObject(SQLCA)
tab_1.tabpage_7.dw_7.SetTransObject(SQLCA)
tab_1.tabpage_8.dw_8.SetTransObject(SQLCA)


dw_label.SetTransObject(SQLCA)
/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_master)   

dw_master.insertRow(0)
dw_date.insertRow(0)
dw_accept.insertRow(0)
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
DateTime ld_datetime
Long i, ll_rows
string ls_flag, ls_sample_cd, ls_color, ls_remark

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_master.accepttext()

dw_master.retrieve(is_order_id, is_style, is_chno)
dw_date.retrieve(is_order_id)
dw_accept.retrieve(is_order_id)
wf_accept_ck()

// Assort 내역은 항상 retrieve
IF tab_1.selectedtab <> 1 THEN 
   wf_tab_retrieve(1) 
END IF


/* 선택된 tab자료 조회 */ 
wf_tab_retrieve(tab_1.selectedtab) 
is_job = '2'
This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)
//il_rows = dw_master.retrieve(is_order_id, is_style, is_chno)

//il_rows = dw_master.retrieve(is_style, is_chno)
//il_rows = dw_7.retrieve(is_style + is_chno)
//ll_rows = dw_detail.retrieve(is_style, is_chno)
/*
IF il_rows > 0 THEN
	If ll_rows <= 0 Then
		gf_sysdate(ld_datetime) 
		dw_master.Setitem(1, "mod_id", gs_user_id)
		dw_master.Setitem(1, "mod_dt", ld_datetime)
	End If		
	
   dw_master.SetFocus()
end if
*/

/*
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
	IF Mid(is_style, 5, 1) = 'Z' or Mid(is_style, 2, 1) = 'Y' THEN
     dw_master.Setitem(1, "plan_yn", "Y") 
   ELSE
     dw_master.Setitem(1, "plan_yn", "N") 
   END IF

//	IF is_sojae = 'W' THEN 
//	   dw_master.Setitem(1, "make_type", '10')
//	END IF 


//   dw_master.Setitem(1, "country_cd", "00")
//	dw_master.Setitem(1, "country_cd2", "00")
   
//	gf_sysdate(ld_datetime) 
//   dw_master.Setitem(1, "req_ymd", String(ld_datetime, "yyyymmdd"))
	
//	select sample_cd into :ls_sample_cd 
//	from tb_31031_m (nolock) 
//	where style = :is_style;
	
//	dw_master.Setitem(1, "sample_cd",    ls_sample_cd)
	
//	dw_master.SetFocus()
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
*/


/****************** Main Label **************************/
/*
il_rows = dw_label.retrieve(is_style, is_chno)
for i = 1 to dw_label.rowcount()
	ls_flag = dw_label.getitemstring(i,"flag")	
	if ls_flag = 'New' then
		dw_label.SetItemStatus(i, 0, Primary!,NewModified!)
//	else
//		dw_label.SetItemStatus(i, 0, Primary!,DataModified!)
	end if

	ls_remark = dw_label.getitemstring(i,"remark")	
	if isnull(ls_remark) or ls_remark = '' then
		ls_color = dw_label.getitemstring(i,"color")	
		select '(' + convert(varchar(5),sum(plan_qty)) + ')'
			into :ls_remark
			from tb_12030_s (nolock) 
			where style = :is_style 
			and   chno  = :is_chno
			and   color = :ls_color;

		dw_label.setitem(i,"remark",ls_remark)
		ib_changed = true
		cb_update.enabled = true
	end if
next 
*/
/********************************************************/

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
		   tab_1.enabled = true
         dw_master.Enabled = true
			cb_preview.enabled = true
//			cb_copy_style.enabled = true

			tab_1.enabled = true
      end if

	CASE 4		/* 삭제 */
      cb_delete.enabled = true
		cb_copy_style.enabled = false
//		tab_1.tabpage_4.cb_order.enabled = false
   CASE 5    /* 조건 */
      cb_insert.enabled  = false
      cb_del_all.enabled = false
		tab_1.enabled = false 
      dw_master.Enabled = false
		cb_copy_style.enabled = false
		cb_update.enabled = false
		dw_head.setitem(1, 'order_id', '')
		dw_head.setitem(1, 'style_no', '')		
//		tab_1.tabpage_4.cb_order.enabled = false
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
	CASE 5 
		ldw_temp = tab_1.tabpage_5.dw_5
	CASE 6
		ldw_temp = tab_1.tabpage_6.dw_6
	CASE 7
		ldw_temp = tab_1.tabpage_7.dw_7
	CASE 8
		ldw_temp = tab_1.tabpage_8.dw_8
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

event ue_delete();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.08																  */	
/* 수정일      : 2002.01.08																  */
/*===========================================================================*/
DataWindow  ldw_temp
long			ll_cur_row, ll_qty

if dw_master.AcceptText() <> 1 then return

/* 선택된 Tab Page DataWindow 산출 */ 
CHOOSE CASE tab_1.selectedtab 
	CASE 1 
		ldw_temp = tab_1.tabpage_1.dw_1
		ll_qty = ldw_temp.getitemnumber(ldw_temp.GetRow(),'in_qty_kor')
		if ll_qty <> 0 then 
			messagebox("확인","수불 내역이 있어 삭제할 수 없습니다.")
			return
		end if	
		ll_qty = ldw_temp.getitemnumber(ldw_temp.GetRow(),'in_qty_chn')
		if ll_qty <> 0 then 
			messagebox("확인","수불 내역이 있어 삭제할 수 없습니다.")
			return
		end if		
	CASE 2
		ldw_temp = tab_1.tabpage_2.dw_2
	CASE 3 
//		ldw_temp = tab_1.tabpage_3.dw_3
		ll_qty = ldw_temp.getitemnumber(ldw_temp.GetRow(),'out_qty')
		if ll_qty <> 0 then 
			messagebox("확인","수불 내역이 있어 삭제할 수 없습니다.")
			return
		end if
	CASE 4 
//		ldw_temp = tab_1.tabpage_4.dw_4
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
/*
tab_1.tabpage_5.dw_99.Retrieve()
FOR i = 1 TO 6
    ib_read[i]  = false
NEXT
*/
end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.07                                                  */	
/* 수정일      : 2002.03.07                                                  */
/*===========================================================================*/


long i, ll_row_count, ll_size_spec1,ll_size_spec2,ll_size_spec3,ll_size_spec4, ll_cnt
long ll_make_price, ll_sub_price
datetime ld_datetime
String   ls_mat_cd, ls_mat_nm, ls_mat_nm_chk, ls_ErrMsg, ls_flag, ls_mat_fg, ls_brand,ls_dsgn_emp, ls_style_ck
string ls_image, ls_bigo, ls_design_ymd, ls_pum_ymd, ls_order_id, ls_uid_21, ls_uid_22, ls_sign_ymd_1, ls_empno_1
string ls_style, ls_chno, ls_sojae, ls_dlvy_ymd, ls_fix_ymd, ls_cust, mod_chk, ls_mod_no

gf_sysdate(ld_datetime)

//이미지만 입력시 구분자
if is_job = '1' then
	ll_row_count = dw_master.RowCount()
	IF ll_row_count < 1 THEN RETURN -1
	/*
	IF dw_master.AcceptText() <> 1 THEN RETURN -1
	IF dw_date.AcceptText() <> 1 THEN RETURN -1
	IF dw_accept.AcceptText() <> 1 THEN RETURN -1
	*/
	dw_master.AcceptText()
	dw_date.AcceptText()
	dw_accept.AcceptText()

	//작지마스터
	select 'O' + right(isnull(max(right(order_id,5)), 0) + 100001, 5)
	into :ls_order_id
	from tb_12A20_M;	

	select right(isnull(max(right(mod_no,3)), 0) + 10001, 3)
	into :ls_mod_no
	from tb_12A20_M
	where order_id = :ls_order_id;	
	
	ls_image = dw_master.getitemstring(1, 'image')
	ls_bigo	= dw_master.getitemstring(1, 'bigo')
	ls_style	= dw_master.getitemstring(1, 'style')
	if isnull(ls_style) then
		ls_style = ''
	end if
	
	select count(style), style
	into :ll_cnt, :ls_style_ck
	from tb_12a20_m with (nolock)
	where style = :ls_style
	group by style;
	
	if ll_cnt > 0 and ls_style_ck <> '' then
		messagebox('확인','품번이 중복 되었습니다. 확인바랍니다!')
		return -1
	end if
	
	if ls_image = '' or isnull(ls_image) then
		messagebox('입력확인!','이미지를 선택해 주세요!')
   	dw_master.SetFocus()
	   dw_master.SetColumn("image")
		return -1
	end if
	
	dw_master.setitem(1,'order_id', ls_order_id)
	dw_master.setitem(1,'style', ls_style)
	dw_master.setitem(1,'image', ls_image)	
	dw_master.setitem(1,'bigo', ls_bigo)
   dw_master.setitem(1,'mod_no', ls_mod_no)

   //일자 정보 입력
	select 'O' + right(isnull(max(right(uid,5)), 0) + 100001, 5)
	into :ls_uid_21
	from tb_12A21_d;		

	select right(isnull(max(right(mod_no,3)), 0) + 10001, 3)
	into :ls_mod_no
	from tb_12A21_d
	where order_id = :ls_order_id;
	
	ls_design_ymd = dw_date.getitemstring(1, 'design_ymd')
	ls_pum_ymd = dw_date.getitemstring(1, 'pum_ymd')


	if ls_pum_ymd = '' or isnull(ls_pum_ymd) then
		messagebox('입력확인!','품평일자를 등록해 주세요!')
   	dw_date.SetFocus()
	   dw_date.SetColumn("pum_ymd")
		return -1
	end if

	if ls_design_ymd = '' or isnull(ls_design_ymd) then
		messagebox('입력확인!','디자인메인수정 일자를 등록해 주세요!')
   	dw_date.SetFocus()
	   dw_date.SetColumn("design_ymd")
		return -1
	end if

	dw_date.setitem(1,'uid', ls_uid_21)
	dw_date.setitem(1,'order_id', ls_order_id)
	dw_date.setitem(1,'pum_ymd', ls_pum_ymd)
	dw_date.setitem(1,'design_ymd', ls_design_ymd)
	dw_date.setitem(1,'mod_no', ls_mod_no)

   //결재 정보 입력
	select 'O' + right(isnull(max(right(uid,5)), 0) + 100001, 5)
	into :ls_uid_22
	from tb_12A22_d;
	
	select right(isnull(max(right(mod_no,3)), 0) + 10001, 3)
	into :ls_mod_no
	from tb_12A22_d
	where order_id = :ls_order_id;

	ls_sign_ymd_1 = dw_accept.getitemstring(1, 'sign_ymd_1')
	ls_empno_1 = dw_accept.getitemstring(1, 'empno_1')

	dw_accept.setitem(1,'uid', ls_uid_22)
	dw_accept.setitem(1,'order_id', ls_order_id)
	dw_accept.setitem(1,'sign_ymd_1', ls_sign_ymd_1)
	dw_accept.setitem(1,'empno_1', ls_empno_1)
	dw_accept.setitem(1,'mod_no', ls_mod_no)
	


	idw_status = dw_master.GetItemStatus(1, 0, Primary!)
	IF idw_status = NewModified! THEN				/* New Record    */
		dw_master.Setitem(1, "reg_id", gs_user_id)
		dw_master.Setitem(1, "reg_dt", ld_datetime)	
		dw_date.Setitem(1, "reg_id", gs_user_id)
		dw_date.Setitem(1, "reg_dt", ld_datetime)	
		dw_accept.Setitem(1, "reg_id", gs_user_id)
		dw_accept.Setitem(1, "reg_dt", ld_datetime)	
	ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
		dw_master.Setitem(1, "mod_id", gs_user_id)
		dw_master.Setitem(1, "mod_dt", ld_datetime)
		dw_date.Setitem(1, "mod_id", gs_user_id)
		dw_date.Setitem(1, "mod_dt", ld_datetime)
		dw_accept.Setitem(1, "mod_id", gs_user_id)
		dw_accept.Setitem(1, "mod_dt", ld_datetime)
	END IF 	

	
//	if ll_row_count = 1 then
	il_rows = dw_master.Update(TRUE, FALSE) 
	if il_rows = 1 then		
//		dw_master.Update()
		dw_date.Update()
		dw_accept.Update()
		cb_Connect.triggerevent (clicked!)
		cb_PutFile.triggerevent (clicked!)
		cb_DisConnect.triggerevent (clicked!)
		commit  USING SQLCA;	
		
		cb_4.enabled = false
		
	else
		rollback  USING SQLCA;
		IF Trim(ls_ErrMsg) <> "" THEN 
			MessageBox("저장 오류", ls_ErrMsg)
			return 0
		END IF 
	end if
	
elseif is_job = '2' then
	dw_master.accepttext()

	ls_order_id		= dw_master.getitemstring(1,'order_id')
	ls_style			= dw_master.getitemstring(1,'style')
	ls_chno			= dw_master.getitemstring(1,'chno')
	ls_sojae 		= dw_master.getitemstring(1,'sojae')
	ls_dlvy_ymd		= dw_master.getitemstring(1,'dlvy_ymd')
	ls_fix_ymd		= dw_master.getitemstring(1,'fix_ymd')
	ll_make_price	= dw_master.getitemnumber(1,'make_price')
	ll_sub_price	= dw_master.getitemnumber(1,'sub_price')
	ls_cust			= dw_master.getitemstring(1,'cust')

	select right(isnull(max(right(mod_no,3)), 0) + 1001, 3)
	into :ls_mod_no
	from tb_12A20_M
	where order_id = :ls_order_id;

	select count(style), style
	into :ll_cnt, :ls_style_ck
	from tb_12a20_m with (nolock)
	where style = :ls_style
	group by style;
	
	if ll_cnt > 1 and ls_style_ck <> '' then
		messagebox('확인','품번이 중복 되었습니다. 확인바랍니다!')
		return -1
	end if

	idw_status = dw_master.GetItemStatus(1, 0, Primary!)
	IF idw_status = NewModified! THEN				/* New Record    */
		dw_master.Setitem(1, "mod_no", ls_mod_no)
		dw_master.Setitem(1, "reg_id", gs_user_id)
		dw_master.Setitem(1, "reg_dt", ld_datetime)	
	ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
		dw_master.Setitem(1, "style", ls_style)
		dw_master.Setitem(1, "chno", ls_chno)
		dw_master.Setitem(1, "sojae", ls_sojae)
		dw_master.Setitem(1, "dlvy_ymd", ls_dlvy_ymd)
		dw_master.Setitem(1, "fix_ymd", ls_fix_ymd)
		dw_master.Setitem(1, "make_price", ll_make_price)
		dw_master.Setitem(1, "sub_price", ll_sub_price)
		dw_master.Setitem(1, "cust", ls_cust)
		dw_master.Setitem(1, "mod_no", ls_mod_no)
		dw_master.Setitem(1, "mod_id", gs_user_id)
		dw_master.Setitem(1, "mod_dt", ld_datetime)
	END IF

	il_rows = dw_master.Update(TRUE, FALSE)
	if il_rows = 1 then
//		dw_master.Update()		
		commit  USING SQLCA;	
	else
		rollback  USING SQLCA;
		IF Trim(ls_ErrMsg) <> "" THEN 
			MessageBox("저장 오류", ls_ErrMsg)
			return 0
		END IF 
	end if	

	select right(isnull(max(right(mod_no,3)), 0) + 1001, 3)
	into :ls_mod_no
	from tb_12A21_d
	where order_id = :ls_order_id;
	
	idw_status = dw_date.GetItemStatus(1, 0, Primary!)
	IF idw_status = NewModified! THEN				/* New Record    */
		dw_date.Setitem(1, "mod_no", ls_mod_no)
		dw_date.Setitem(1, "reg_id", gs_user_id)
		dw_date.Setitem(1, "reg_dt", ld_datetime)	
	ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
		dw_date.Setitem(1, "mod_no", ls_mod_no)
		dw_date.Setitem(1, "mod_id", gs_user_id)
		dw_date.Setitem(1, "mod_dt", ld_datetime)
	END IF

	il_rows = dw_date.Update(TRUE, FALSE)
	if il_rows = 1 then
//		dw_date.Update()
		commit  USING SQLCA;	
	else
		rollback  USING SQLCA;
		IF Trim(ls_ErrMsg) <> "" THEN 
			MessageBox("저장 오류", ls_ErrMsg)
			return 0
		END IF 
	end if	

	select right(isnull(max(right(mod_no,3)), 0) + 1001, 3)
	into :ls_mod_no
	from tb_12A22_d
	where order_id = :ls_order_id;

	idw_status = dw_accept.GetItemStatus(1, 0, Primary!)
	IF idw_status = NewModified! THEN				/* New Record    */
		dw_accept.Setitem(1, "mod_no", ls_mod_no)
		dw_accept.Setitem(1, "reg_id", gs_user_id)
		dw_accept.Setitem(1, "reg_dt", ld_datetime)			
	ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
		dw_accept.Setitem(1, "mod_no", ls_mod_no)
		dw_accept.Setitem(1, "mod_id", gs_user_id)
		dw_accept.Setitem(1, "mod_dt", ld_datetime)
	END IF

	il_rows = dw_accept.Update(TRUE, FALSE)
	if il_rows = 1 then
//		dw_accept.Update()
		commit  USING SQLCA;	
	else
		rollback  USING SQLCA;
		IF Trim(ls_ErrMsg) <> "" THEN 
			MessageBox("저장 오류", ls_ErrMsg)
			return 0
		END IF 
	end if	

	//	il_rows = wf_tab_update(ld_datetime, ls_ErrMsg)
	//	IF wf_tab_update(ld_datetime, ls_ErrMsg) THEN 
	IF wf_tab_update(ld_datetime, ls_ErrMsg) = true THEN 
			tab_1.tabpage_1.dw_1.ResetUpdate()
			tab_1.tabpage_2.dw_2.ResetUpdate()
			tab_1.tabpage_3.dw_3.ResetUpdate()
			tab_1.tabpage_4.dw_4.ResetUpdate()
			cb_Connect.triggerevent (clicked!)
			cb_PutFile.triggerevent (clicked!)
			cb_DisConnect.triggerevent (clicked!)			
			
			tab_1.tabpage_5.dw_5.ResetUpdate()
			tab_1.tabpage_6.dw_6.ResetUpdate()
			tab_1.tabpage_7.dw_7.ResetUpdate()
			tab_1.tabpage_8.dw_8.ResetUpdate()
			
			commit  USING SQLCA;	
		ELSE
			il_rows = -1
			rollback  USING SQLCA;
			IF Trim(ls_ErrMsg) <> "" THEN 
				MessageBox("저장 오류", ls_ErrMsg)
				return 0
			END IF 
		END IF	
end if

	This.Trigger Event ue_button(5, il_rows)
	This.Trigger Event ue_msg(5, il_rows)
	return il_rows

	
	
	
/*	
else
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

	
	ls_brand = dw_master.GetItemString(1, "brand")
	is_country_cd = dw_master.GetItemString(1, "country_cd2")
	is_make_type = dw_master.GetItemString(1, "make_type2")
	is_orgmat_cd = dw_master.GetItemString(1, "orgmat_cd2")
	is_concept  = dw_master.GetItemString(1, "concept")
	ls_dsgn_emp  = dw_master.GetItemString(1, "dsgn_emp")
	is_out_seq  = dw_master.GetItemString(1, "out_seq")
	is_out_seq2 = dw_master.GetItemString(1, "out_seq2")
	is_out_seq_chn  = dw_master.GetItemString(1, "out_seq_chn")
	is_zsojae = dw_master.GetItemString(1, "zsojae")
	is_zitem = dw_master.GetItemString(1, "zitem")
	is_make_ymd = dw_master.GetItemString(1, "make_ymd")
	
	if is_sojae = 'C' or is_sojae = 'D' or is_sojae = 'E' then 
		if ls_brand = "P" or ls_brand = "B" or ls_brand = "K" then
		else	
			if is_zsojae = '' or isnull(is_zsojae) then 
				messagebox("주의", "소재를 선택하여 주세요..")
				dw_master.setcolumn("zsojae")
				dw_master.setfocus()
				return -1
			end if
		end if	
	elseif is_item = 'Z' then 
		if is_zitem = '' or isnull(is_zitem) then 
			messagebox("주의", "품종을 선택하여 주세요..")
			dw_master.setcolumn("zitem")
			dw_master.setfocus()
			return -1
		end if
	elseif (is_item = 'A' or is_item = 'G' or is_item = 'F' ) AND ls_brand <> 'I' then 
					
			ll_size_spec1 = tab_1.tabpage_2.dw_2.getitemnumber(21,"size_spec_1")
			if isnull(ll_size_spec1) then ll_size_spec1 = 0 
			ll_size_spec2 = tab_1.tabpage_2.dw_2.getitemnumber(22,"size_spec_1")
			if isnull(ll_size_spec2) then ll_size_spec2 = 0 
			ll_size_spec3 = tab_1.tabpage_2.dw_2.getitemnumber(23,"size_spec_1")
			if isnull(ll_size_spec3) then ll_size_spec3 = 0 		
			ll_size_spec4 = tab_1.tabpage_2.dw_2.getitemnumber(24,"size_spec_1")		
			if isnull(ll_size_spec4) then ll_size_spec4 = 0 		
			
			
				if ls_brand = "P" or ls_brand = "B" or ls_brand = "K" then
				else	
				if is_item = 'F' and (ll_size_spec1 <= 1  or ll_size_spec2 <= 1 ) then 
		//			messagebox("ll_size_spec1",ll_size_spec1)
		//			messagebox("ll_size_spec2",ll_size_spec2)
					
					messagebox("주의", "머플러,목도리의 가로,세로 완성제품 치수를 확인해주세요! ..")
					tab_1.SelectedTab = 2
					tab_1.tabpage_2.dw_2.setrow(21)
					tab_1.tabpage_2.dw_2.SetFocus()
					tab_1.tabpage_2.dw_2.SetColumn("size_spec_1")	
					return -1	
				elseif is_item = 'G' and (ll_size_spec1 < 0  or ll_size_spec2 < 0 or ll_size_spec3 < 0 ) then 
		//			messagebox("is_item",is_item)
		//			messagebox("ll_size_spec1",ll_size_spec1)
		//			messagebox("ll_size_spec2",ll_size_spec2)
		//			messagebox("ll_size_spec3",ll_size_spec3)
					
					messagebox("주의", "가방의  가로,세로,높이 완성제품 치수를 확인해주세요! ..")
					tab_1.SelectedTab = 2
					tab_1.tabpage_2.dw_2.setrow(21)
					tab_1.tabpage_2.dw_2.SetFocus()
					tab_1.tabpage_2.dw_2.SetColumn("size_spec_1")		
					return -1				
				elseif is_item = 'A' and ll_size_spec4 <= 1  then 			
					messagebox("주의", "모자의 둘레 완성제품 치수를 확인해주세요! ..")	
					tab_1.SelectedTab = 2
					tab_1.tabpage_2.dw_2.setrow(24)
					tab_1.tabpage_2.dw_2.SetFocus()
					tab_1.tabpage_2.dw_2.SetColumn("size_spec_1")	
					return -1				
				end if	
					
			end if
			
	end if
	
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
	
	if len(is_orgmat_cd) <> 2 then
		MessageBox("확인","원료 코드를 입력하십시요!")
		dw_master.SetFocus()
		dw_master.SetColumn("orgmat_cd2")
		return -1
	end if
	
	if len(is_concept) <> 1 then
		MessageBox("확인","상품군을 력하십시요!")
		dw_master.SetFocus()
		dw_master.SetColumn("concept")
		return -1
	end if
	
	if len(ls_dsgn_emp) < 2 then
		MessageBox("확인","디자이너를 력하십시요!")
		dw_master.SetFocus()
		dw_master.SetColumn("dsgn_emp")
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
		dw_master.SetItemStatus(1, "out_seq", Primary!, NotModified!)
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
		dw_detail.Setitem(1, "zsojae",  is_zsojae) 	
		dw_detail.Setitem(1, "zitem",   is_zitem) 		
		
	
		
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
	dw_detail.Setitem(1, "zsojae",  is_zsojae) 	
	dw_detail.Setitem(1, "zitem",   is_zitem) 	
	dw_detail.Setitem(1, "out_seq",   is_out_seq) 	
	dw_detail.Setitem(1, "out_seq_chn",   is_out_seq_chn) 
	//dw_detail.Setitem(1, "make_ymd",   is_make_ymd) 	
	
	
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
		ls_mat_fg = dw_master.getitemstring(1,"maker_fg")	
	
	
		update a set maker_fg = :ls_mat_fg 
		from tb_12029_w a(nolock)
		where style = :is_style 
		and   chno  = :is_chno;
		
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
		
	
	else
		rollback  USING SQLCA;
		IF Trim(ls_ErrMsg) <> "" THEN 
			MessageBox("저장 오류", ls_ErrMsg)
			return 0
		END IF 
	end if
	
	//
	//	//////모링꽁뜨 작지 자동생성////////
	//if is_brand = 'O' then 
	//			 DECLARE sp_make_morine_12020_m PROCEDURE FOR sp_make_morine_12020_m  
	//						@style		 = :is_style;						
	//			 execute sp_make_morine_12020_m;	
	//			 
	//			 DECLARE sp_make_morine_12021_d PROCEDURE FOR sp_make_morine_12021_d  
	//						@style		 = :is_style,
	//						@chno  	    = :is_chno;						
	//			 execute sp_make_morine_12021_d;	
	//
	//
	//			 DECLARE sp_make_morine_12024_d PROCEDURE FOR sp_make_morine_12024_d  
	//						@style		 = :is_style,
	//						@chno  	    = :is_chno;						
	//			 execute sp_make_morine_12024_d;	
	//			 			 
	//	end if
	//
	//	////////////////////////////////////////////////////
	//	
			commit  USING SQLCA;	
		
	
		update a set a.smat_info = isnull(dbo.sf_smat_info(a.style),'')
		from tb_12020_m a(nolock)
		where a.style = :is_style
		and   isnull(a.smat_info,'') <> isnull(dbo.sf_smat_info(a.style),'');
	
	
		update a set mat_cd = b.mat_cd,
				  mat_nm = dbo.sf_mat_nm(b.mat_cd)
		from tb_12021_d a(nolock), tb_12025_d b(nolock)
		where a.style = b.style
		and   a.chno  = b.chno
		and   b.mat_gubn = '1'
		and   b.mat_fg= 'A'
		and   a.style = :is_style
		and   a.chno  = :is_chno
		and   isnull(a.mat_cd,'') = '';
		
		
		update a set 
			sect_nm    = case when right(b.cust_cd,4) in ('5140','5114') then 'SHANGHAI.' end
		from tb_12029_d a(nolock), tb_12021_d b(nolock)
		where a.style = b.style
		and   a.chno  = b.chno
		and   b.style = :is_style
		and   b.chno  = :is_chno
		and   isnull(a.sect_nm,'')  <> case when right(b.cust_cd,4) in ('5140','5114') then 'SHANGHAI.' end;
					
	
		commit  USING SQLCA;		
		
		
		 DECLARE sp_refresh_TagLabel PROCEDURE FOR sp_refresh_TagLabel  
					@style		 = :is_style,
					@chno  	    = :is_chno;						
		 execute sp_refresh_TagLabel;		
				 
		commit  USING SQLCA;		
		 
		insert into tb_12024_d (style, chno, color, size, reg_id)
		select	distinct  	style,	chno,	color,	size,	:gs_user_id as reg_id
		 from tb_12030_s a(nolock) 
		where not exists (select top 1 * from tb_12024_d (nolock)
				where style = a.style
				and   chno  = a.chno
				and   color = a.color
				and   size  = a.size)
		and   style = :is_style
		and   chno  = :is_chno
		and   color <> 'xx'
		and   size  <> 'xx'
		and   isnull(color,'') <> ''
		and   isnull(size,'') <> ''
		and   isnull(ord_qty,0) + isnull(ord_qty_exp,0)> 0 ;
		
		commit  USING SQLCA;		
		  
		  
	This.Trigger Event ue_button(3, il_rows)
	This.Trigger Event ue_msg(3, il_rows)
	return il_rows
*/


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12a10_e","0")
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

string ls_order_id, ls_style, ls_chno
//dw_master.ShareData(dw_print)

dw_master.accepttext()
ls_order_id = dw_master.getitemstring(1,'order_id')
ls_style = dw_master.getitemstring(1,'style')
ls_chno = dw_master.getitemstring(1,'chno')


dw_print.retrieve(ls_order_id, ls_style, ls_chno)
dw_print.Object.dw_1.Object.dw_1.Object.p_img.FileName = '\\220.118.68.4\olive_design\'+ dw_master.getitemstring(1, "image") 
dw_print.Object.dw_2.Object.dw_7.Object.p_1.FileName   = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_1") 
dw_print.Object.dw_2.Object.dw_7.Object.p_2.FileName   = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_2") 
dw_print.Object.dw_2.Object.dw_7.Object.p_3.FileName   = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_3") 
dw_print.Object.dw_2.Object.dw_7.Object.p_4.FileName   = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_4") 
dw_print.Object.dw_2.Object.dw_7.Object.p_5.FileName   = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_5") 
dw_print.Object.dw_2.Object.dw_7.Object.p_6.FileName   = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_6") 
dw_print.Object.dw_2.Object.dw_7.Object.p_7.FileName   = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_7") 
dw_print.Object.dw_2.Object.dw_7.Object.p_8.FileName   = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_8") 
dw_print.Object.dw_2.Object.dw_7.Object.p_9.FileName   = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_9") 
dw_print.Object.dw_2.Object.dw_7.Object.p_10.FileName  = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_10") 
dw_print.Object.dw_2.Object.dw_7.Object.p_11.FileName  = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_11") 
dw_print.Object.dw_2.Object.dw_7.Object.p_12.FileName  = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_12") 
dw_print.Object.dw_2.Object.dw_7.Object.p_13.FileName  = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_13") 
dw_print.Object.dw_2.Object.dw_7.Object.p_14.FileName  = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_14") 
dw_print.Object.dw_2.Object.dw_7.Object.p_15.FileName  = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_15") 
dw_print.Object.dw_2.Object.dw_7.Object.p_16.FileName  = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_16") 
dw_print.Object.dw_2.Object.dw_7.Object.p_17.FileName  = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_17") 
dw_print.Object.dw_2.Object.dw_7.Object.p_18.FileName  = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_18") 
dw_print.Object.dw_2.Object.dw_7.Object.p_19.FileName  = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_19") 
dw_print.Object.dw_2.Object.dw_7.Object.p_20.FileName  = '\\220.118.68.4\olive_sojae\'+ tab_1.tabpage_4.dw_4.getitemstring(1, "image_20") 
dw_print.inv_printpreview.of_SetZoom()


end event

event open;call super::open;if isnull(gsv_cd.gs_cd10) or gsv_cd.gs_cd10 = '' then
else
	dw_head.setitem(1,"style_no", string(gsv_cd.gs_cd10) + '0')
	setnull(gsv_cd.gs_cd10)
	trigger event ue_retrieve()
end if

dw_head.Setitem(1,'order_id', '%')


end event

type cb_close from w_com010_e`cb_close within w_12a10_e
integer x = 4709
integer taborder = 140
end type

type cb_delete from w_com010_e`cb_delete within w_12a10_e
integer x = 4763
integer y = 816
integer width = 283
integer height = 84
integer taborder = 90
end type

type cb_insert from w_com010_e`cb_insert within w_12a10_e
integer x = 4480
integer y = 816
integer width = 283
integer height = 84
integer taborder = 70
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_12a10_e
integer x = 4366
end type

type cb_update from w_com010_e`cb_update within w_12a10_e
integer taborder = 130
end type

type cb_print from w_com010_e`cb_print within w_12a10_e
integer x = 4018
integer taborder = 100
string text = "작지출력"
end type

event cb_print::clicked;dw_print.dataobject = "d_12a10_r00"
dw_print.SetTransObject(SQLCA)


trigger event ue_preview()

end event

type cb_preview from w_com010_e`cb_preview within w_12a10_e
boolean visible = false
integer x = 1605
integer taborder = 110
string text = "생산의뢰서"
end type

event cb_preview::clicked;dw_print.dataobject = "d_12a10_r01"
dw_print.SetTransObject(SQLCA)



Parent.Trigger Event ue_preview()
end event

type gb_button from w_com010_e`gb_button within w_12a10_e
integer width = 5083
end type

type cb_excel from w_com010_e`cb_excel within w_12a10_e
boolean visible = false
integer x = 2190
integer y = 36
integer taborder = 120
end type

type dw_head from w_com010_e`dw_head within w_12a10_e
integer y = 176
integer width = 5019
integer height = 148
string dataobject = "d_12a10_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
DataWindowChild ldw_child


CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
//		dw_master.GetChild("sojae", ldw_child)
//		ldw_child.SetTransObject(SQLCA)
//		ldw_child.Retrieve('%' ,mid(data,1,1))
//		ldw_child.SetRedraw(false)
//		ldw_child.setFilter( " sojae <> 'O'");
//		ldw_child.Filter()
//		ldw_child.SetRedraw(true)
//		
//		
//		dw_master.GetChild("zsojae", ldw_child)
//		ldw_child.SetTransObject(SQLCA)
//		ldw_child.Retrieve('%',mid(data,1,1))
//		ldw_child.SetRedraw(false)
//		ldw_child.setFilter( " sojae <> 'A' and sojae <> 'B' and sojae <> 'C' and sojae <> 'D' and sojae <> 'Y' and sojae <> 'O'  ");
//		ldw_child.Filter()
//		ldw_child.SetRedraw(true)
//		
//		
//		dw_master.GetChild("item", ldw_child)
//		ldw_child.SetTransObject(SQLCA)
//		ldw_child.Retrieve(mid(data,1,1))
//		ldw_child.SetRedraw(false)
//		ldw_child.setFilter( " item <> '1' ");
//		ldw_child.Filter()
//		ldw_child.SetRedraw(true)
//		
//		dw_master.GetChild("zitem", ldw_child)
//		ldw_child.SetTransObject(SQLCA)
//		ldw_child.Retrieve(mid(data,1,1))
//		ldw_child.SetRedraw(false)
//		ldw_child.setFilter( "item <> 'Z' and item <> 'X' and item <> '1' ");
//		ldw_child.Filter()
//		ldw_child.SetRedraw(true)
		

		
		
		
		

	CASE "mat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "order_id"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_12a10_e
integer beginy = 324
integer endx = 5061
integer endy = 324
end type

type ln_2 from w_com010_e`ln_2 within w_12a10_e
integer beginy = 328
integer endx = 5061
integer endy = 328
end type

type dw_body from w_com010_e`dw_body within w_12a10_e
boolean visible = false
integer x = 5979
integer y = 728
integer width = 489
integer height = 548
boolean titlebar = true
string title = "body"
string dataobject = "d_12a10_d12"
boolean resizable = true
end type

type dw_print from w_com010_e`dw_print within w_12a10_e
integer x = 1664
integer y = 124
integer width = 1797
integer height = 284
string dataobject = "d_12a10_r00"
end type

type cb_del_all from commandbutton within w_12a10_e
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
/*
// assort 자료 삭제 가능여부 체크 
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
// 원자재 소요 삭제 가능여부 체크 
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
*/
end event

type dw_master from datawindow within w_12a10_e
event ue_keydown pbm_dwnkey
integer x = 9
integer y = 696
integer width = 2629
integer height = 1432
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_12a10_d01"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
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
//	CASE KeyEnter!
//		Send(Handle(This), 256, 9, long(0,0))
//		Return 1
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

event constructor;DataWindowChild ldw_child, ldw_child_1

This.GetChild("gubn", ldw_child_1)
ldw_child_1.SetTransObject(SQLCA)
ldw_child_1.Retrieve('030')

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

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
/* 화일 탐색 */
string  ls_path, ls_file_nm
integer li_value
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

if ls_column_nm = "file_nm" then
		li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")
		
		IF li_value = 1 THEN 
//			dw_master.setitem(1, "image", is_path)
			dw_master.setitem(1, "image", ls_file_nm)
			dw_ftp.setitem(1,"rocalfile", is_path)
			dw_ftp.setitem(1,"remotefile", ls_file_nm)
			dw_master.Object.p_img.FileName = is_path
			

//			dw_master.Setitem(1, "p_img", ls_path)
//			dw_master.reset()
//			dw_master.insertrow(0)
//			dw_master.setitem(1, "p_img", ls_path)
//			dw_master.visible = true
			cb_update.enabled = true			
      else	
			is_file_nm = ""
		END IF
end if

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
//	CASE 515
//		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

This.ScrollTorow(row)
This.SetRow(row)
This.SetFocus()

MessageBox(parent.title + "[TB_12A20_M]", ls_message_string)
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
	case "out_seq"
		dw_detail.setitem(1,"out_seq",data)			

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

type dw_spec from datawindow within w_12a10_e
boolean visible = false
integer x = 5550
integer y = 936
integer width = 576
integer height = 432
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "spec"
string dataobject = "d_12a10_spec"
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

type dw_detail from datawindow within w_12a10_e
boolean visible = false
integer x = 5435
integer y = 1088
integer width = 626
integer height = 784
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "detail"
string dataobject = "d_12a10_d11"
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

type tab_1 from tab within w_12a10_e
integer x = 2633
integer y = 716
integer width = 2437
integer height = 1412
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
tabpage_7 tabpage_7
tabpage_8 tabpage_8
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.tabpage_8=create tabpage_8
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_7,&
this.tabpage_8}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
destroy(this.tabpage_8)
end on

event selectionchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.08                                                  */	
/* 수정일      : 2001.01.08                                                  */
/*===========================================================================*/

if oldindex < 1 then return

CHOOSE CASE newindex 
	case 1,2,3,4,5,6,7,8
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
	CASE 6
		IF tab_1.tabpage_6.dw_6.AcceptText() <> 1 THEN RETURN 1		
	CASE 7
		IF tab_1.tabpage_7.dw_7.AcceptText() <> 1 THEN RETURN 1		
	CASE 8
		IF tab_1.tabpage_8.dw_8.AcceptText() <> 1 THEN RETURN 1		

END CHOOSE

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2400
integer height = 1300
long backcolor = 79741120
string text = "완성제품치수"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_spec_set cb_spec_set
dw_1 dw_1
end type

on tabpage_1.create
this.cb_spec_set=create cb_spec_set
this.dw_1=create dw_1
this.Control[]={this.cb_spec_set,&
this.dw_1}
end on

on tabpage_1.destroy
destroy(this.cb_spec_set)
destroy(this.dw_1)
end on

type cb_spec_set from commandbutton within tabpage_1
integer y = 4
integer width = 347
integer height = 80
integer taborder = 150
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "기본치수등록"
end type

event clicked;wf_tab_insert(1)
tab_1.tabpage_1.cb_spec_set.enabled = false
end event

type dw_1 from datawindow within tabpage_1
event ue_keydown pbm_dwnkey
event ue_auto_need ( )
integer y = 92
integer width = 2395
integer height = 1080
integer taborder = 110
string title = "none"
string dataobject = "d_12a10_d04"
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

event ue_auto_need();/*
String  ls_color  
Decimal ldc_stock_qty, ldc_bf_tneed, ldc_t_exp_qty, ldc_ord_qty_exp
Decimal ldc_req_qty,   ldc_need_qty, ldc_loss , ldc_plan_qty,ldc_plan_qty_chn, ldc_ord_qty, ldc_ord_qty_chn
Long    i



// 중국 투입량 자동 변경 
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



// 원자재 소요량 변경 
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
	 
	 // 남은 잔량이 요척량보다 작을경우 Loss량으로 자동처리 
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

// 부자재 소요량 변경 
IF ib_read[4] = FALSE THEN 
	wf_tab_retrieve(4) 
END IF 
FOR i = 1 TO tab_1.tabpage_4.dw_4.RowCount()
	 ls_color = tab_1.tabpage_4.dw_4.GetitemString(i, "color")
	 ldc_req_qty  = tab_1.tabpage_4.dw_4.GetitemDecimal(i, "req_qty") 
	 ldc_need_qty = Round(wf_Get_pcs(ls_color) * ldc_req_qty, 1)
	 
	 ldc_loss  = tab_1.tabpage_4.dw_4.GetitemDecimal(i, "loss_qty") 
	 if isnull(ldc_loss) then ldc_loss = 0
	 
	 if ldc_need_qty <> 0 then //국내요척 있는곳에 로스추가
		 tab_1.tabpage_4.dw_4.Setitem(i, "need_qty",   ldc_need_qty)
		 tab_1.tabpage_4.dw_4.Setitem(i, "t_need_qty", ldc_need_qty + ldc_loss)	 

		 ldc_need_qty = Round(wf_Get_pcs_exp(ls_color) * ldc_req_qty, 1)
		 tab_1.tabpage_4.dw_4.Setitem(i, "t_exp_qty", ldc_need_qty)
	else // 국내요척 없으면 로스추가
		 tab_1.tabpage_4.dw_4.Setitem(i, "need_qty",   ldc_need_qty)
		 tab_1.tabpage_4.dw_4.Setitem(i, "t_need_qty", ldc_need_qty)	 

		 ldc_need_qty = Round(wf_Get_pcs_exp(ls_color) * ldc_req_qty, 1)
		 tab_1.tabpage_4.dw_4.Setitem(i, "t_exp_qty", ldc_need_qty + ldc_loss)
	end if
	 
NEXT 

*/


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
/*
CHOOSE CASE dwo.name
	CASE "plan_qty", "plan_qty_chn", "ord_qty_exp"
		This.Post Event ue_auto_need()
END CHOOSE

*/
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

event constructor;//This.SetRowFocusIndicator(Hand!)

DataWindowChild ldw_child_spec

This.GetChild("spec_fg", ldw_child_spec)
ldw_child_spec.SetTransObject(SQLCA)
ldw_child_spec.Retrieve('124')


This.GetChild("spec_cd", idw_spec_cd)
idw_spec_cd.SetTransObject(SQLCA)
idw_spec_cd.Retrieve('128','%')
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2400
integer height = 1300
long backcolor = 79741120
string text = "원자재정보_기획"
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
integer y = 92
integer width = 2395
integer height = 1080
integer taborder = 110
string title = "none"
string dataobject = "d_12a10_d05"
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

//This.SetRowFocusIndicator(Hand!)
/*
This.GetChild("mat_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('123')
ldw_child.SetFilter("inter_cd > '9'")
ldw_child.Filter()
*/

This.GetChild("color", idw_color_3)
idw_color_3.SetTransObject(SQLCA)
idw_color_3.retrieve()



This.GetChild("mat_color", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()



end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2400
integer height = 1300
long backcolor = 79741120
string text = "원자재정보_자재"
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
integer y = 92
integer width = 2395
integer height = 1080
integer taborder = 120
string dataobject = "d_12a10_d06"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.08                                                  */	
/* 수정일      : 2001.01.08                                                  */
/*===========================================================================*/
This.TriggerEvent(EditChanged!)

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

event constructor;This.GetChild("mat_color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()
idw_color.insertRow(0)
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

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2400
integer height = 1300
long backcolor = 79741120
string text = "swatch"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_order cb_order
dw_4 dw_4
cb_5 cb_5
end type

on tabpage_4.create
this.cb_order=create cb_order
this.dw_4=create dw_4
this.cb_5=create cb_5
this.Control[]={this.cb_order,&
this.dw_4,&
this.cb_5}
end on

on tabpage_4.destroy
destroy(this.cb_order)
destroy(this.dw_4)
destroy(this.cb_5)
end on

type cb_order from commandbutton within tabpage_4
integer x = 5
integer y = 1216
integer width = 549
integer height = 84
integer taborder = 70
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

type dw_4 from datawindow within tabpage_4
event type integer ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
event ue_keydown pbm_dwnkey
integer y = 92
integer width = 2395
integer height = 1080
integer taborder = 100
boolean bringtotop = true
string title = "none"
string dataobject = "d_12a10_d07"
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
/* 화일 탐색 */
string  ls_path, ls_file_nm
integer li_value
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN
//ftp 연결 하기..
dw_ftp.reset()
dw_ftp.insertrow(0)
dw_ftp.setitem(1,'addr','220.118.68.4')
dw_ftp.setitem(1,'id','olive_sojae')
dw_ftp.setitem(1,'pwd','eajosevilo')
	
cb_Connect.triggerevent (clicked!)

ls_column_nm = MidA(dwo.name, 4)
if ls_column_nm = "file_nm_1" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_1", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_1.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_2" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_2", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_2.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_3" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_3", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_3.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_4" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_4", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_4.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_5" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_5", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_5.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_6" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_6", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_6.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
	
elseif ls_column_nm = "file_nm_7" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_7", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_7.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_8" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_8", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_8.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_9" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_9", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_9.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_10" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_10", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_10.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_11" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_11", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_11.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_12" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_12", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_12.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_13" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_13", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_13.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_14" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_14", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_14.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_15" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_15", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_15.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_16" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_16", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_16.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_17" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_17", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_17.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_18" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_18", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_18.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_19" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_19", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_19.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF
elseif ls_column_nm = "file_nm_20" then
	li_value = GetFileOpenName("Select File", is_path, ls_file_nm, "JPG", "image Files (*.JPG),*.jpg")		
	IF li_value = 1 THEN 
		tab_1.tabpage_4.dw_4.setitem(1, "image_20", ls_file_nm)
		dw_ftp.setitem(1,"rocalfile", is_path)
		dw_ftp.setitem(1,"remotefile", ls_file_nm)
		tab_1.tabpage_4.dw_4.Object.p_20.FileName = is_path
		cb_PutFile.triggerevent (clicked!)
	else	
		is_file_nm = ""
	END IF

end if
//ftp 연결 끊기..
cb_DisConnect.triggerevent (clicked!)
cb_update.enabled = true		

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

//Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.08                                                  */	
/* 수정일      : 2001.01.08                                                  */
/*===========================================================================*/
String  ls_color, ls_mat_cd, ls_spec
Decimal ldc_stock_qty, ldc_resv_qty, ldc_need_qty, ldc_req_qty, ldc_need_qty_chn, ldc_t_need_qty, ldc_loss
	
/*

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
		if len(data) <> 0 then
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
*/
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

type cb_5 from commandbutton within tabpage_4
boolean visible = false
integer x = 2939
integer y = 280
integer width = 549
integer height = 84
integer taborder = 150
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
/*
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
   ll_row = Parent.dw_5.insertRow(0)
	Parent.dw_5.SetRow(ll_row)
	Parent.dw_5.SetColumn("mat_cd") 
	IF lds_Source.GetItemString(1,"mat_item") = 'A' THEN 
	   Parent.dw_5.SetItem(ll_row, "mat_fg", 'C')
	ELSE
	   Parent.dw_5.SetItem(ll_row, "mat_fg", lds_Source.GetItemString(1,"mat_type"))
	END IF
	Parent.dw_5.SetItem(ll_row, "color",     "XX")
	Parent.dw_5.SetItem(ll_row, "mat_cd",    lds_Source.GetItemString(1,"mat_cd"))
	Parent.dw_5.SetItem(ll_row, "mat_nm",    lds_Source.GetItemString(1,"mat_nm"))
	Parent.dw_5.SetItem(ll_row, "mat_color", "XX")
	Parent.dw_5.SetItem(ll_row, "spec",      "XX")
	
	if cbx_pop.checked = true then
		tab_1.tabpage_5.dw_5.Trigger Event ue_Popup("cust_cd", ll_row, mid(is_style,1,1), 0)
		tab_1.tabpage_5.dw_5.Trigger Event ue_Popup("dlvy_ymd", ll_row, mid(is_style,1,1), 0)	
	end if	
	
//	tab_1.tabpage_4.dw_4.Trigger Event ue_Popup("cust_cd", ll_row, mid(is_style,1,1), 0)
//	tab_1.tabpage_4.dw_4.Trigger Event ue_Popup("dlvy_ymd", ll_row, mid(is_style,1,1), 0)		
		
   ib_changed = true
   cb_update.enabled = true
	// 다음컬럼으로 이동 
	Parent.dw_5.ScrollToRow(ll_row)
	Parent.dw_5.SetFocus()
	Parent.dw_5.SetColumn("req_qty")
	ib_itemchanged = False 
END IF

Destroy  lds_Source
*/

end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2400
integer height = 1300
long backcolor = 79741120
string text = "후가공"
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
integer y = 92
integer width = 2395
integer height = 1080
integer taborder = 120
string title = "none"
string dataobject = "d_12a10_d08"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

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
This.TriggerEvent(EditChanged!)

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

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2400
integer height = 1300
long backcolor = 79741120
string text = "부자재정보"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_6 dw_6
cb_smat_set cb_smat_set
end type

on tabpage_6.create
this.dw_6=create dw_6
this.cb_smat_set=create cb_smat_set
this.Control[]={this.dw_6,&
this.cb_smat_set}
end on

on tabpage_6.destroy
destroy(this.dw_6)
destroy(this.cb_smat_set)
end on

type dw_6 from datawindow within tabpage_6
integer y = 92
integer width = 2395
integer height = 1080
integer taborder = 150
string title = "none"
string dataobject = "d_12a10_d09"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
end event

event constructor;//This.SetRowFocusIndicator(Hand!)

DataWindowChild ldw_child , ldw_child_1

This.GetChild("smat_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.retrieve('129')


This.GetChild("unit", ldw_child_1)
ldw_child_1.SetTransObject(SQLCA)
ldw_child_1.retrieve('004')






end event

event itemfocuschanged;String ls_spec_fg
datawindow ldw_spec_cd

CHOOSE CASE dwo.name
	CASE "spec_cd"
		ls_spec_fg = This.GetItemString(row, "spec_fg")
	
		idw_spec_cd.Retrieve('128', ls_spec_fg)
		idw_spec_cd.InsertRow(1)
		idw_spec_cd.SetItem(1, "inter_cd", '') 
		idw_spec_cd.SetItem(1, "inter_nm", '')

END CHOOSE

end event

type cb_smat_set from commandbutton within tabpage_6
integer y = 4
integer width = 439
integer height = 80
integer taborder = 150
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "기본부자재등록"
end type

event clicked;wf_tab_insert(6)
tab_1.tabpage_6.cb_smat_set.enabled = false

end event

event constructor;long ll_row
ll_row = tab_1.tabpage_6.dw_6.getrow()

if ll_row < 1 then
	tab_1.tabpage_6.cb_smat_set.enabled = true
else
	tab_1.tabpage_6.cb_smat_set.enabled = false
end if


end event

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2400
integer height = 1300
long backcolor = 79741120
string text = "배색정보"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_7 dw_7
end type

on tabpage_7.create
this.dw_7=create dw_7
this.Control[]={this.dw_7}
end on

on tabpage_7.destroy
destroy(this.dw_7)
end on

type dw_7 from datawindow within tabpage_7
event type integer ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
event ue_keydown pbm_dwnkey
integer y = 92
integer width = 2395
integer height = 1080
integer taborder = 110
string title = "none"
string dataobject = "d_12a10_d10"
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
string ls_jego_yn = 'N'

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false

/*
CHOOSE CASE dwo.name
	CASE "mat_cd"

		IF ib_itemchanged THEN RETURN 1		
		
		il_rows = This.Trigger Event ue_Popup(dwo.name, row, data, 1)
		ls_orgmat_cd = gf_getorgmat_cd(data)		
		dw_master.setitem(1,"orgmat_cd2",ls_orgmat_cd)		


		ls_mat_cd = data //this.getitemstring(row,"mat_cd")
		select max(case when ((init_qty + nmal_in_qty + tran_in_qty + ggong_in_qty) - (nmal_out_qty + tran_out_qty + ggong_out_qty + sale_qty + smple_qty + etc_qty)) > 0 then 'Y' else 'N' end)
				into :ls_jego_yn
		from tb_29012_s (nolock) 
		where mat_cd = :ls_mat_cd;


		if isnull(ls_jego_yn) or ls_jego_yn = 'N' then 
			messagebox("확인","재고가 없는 원단입니다..")
			this.setfocus()
			this.setcolumn("mat_cd")
			return 0
		end if
		
		
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
*/
end event

event constructor;//This.SetRowFocusIndicator(Hand!)


DataWindowChild ldw_child
 
This.GetChild("spec_fg", ldw_child) 
ldw_child.SetTransObject(SQLCA) 
ldw_child.retrieve('124') 

This.GetChild("spec_cd", ldw_child) 
ldw_child.SetTransObject(SQLCA) 
ldw_child.retrieve('125') 


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

type tabpage_8 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2400
integer height = 1300
long backcolor = 79741120
string text = "Assort"
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
event type integer ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
event ue_keydown pbm_dwnkey
integer y = 92
integer width = 2395
integer height = 1080
integer taborder = 20
string dataobject = "d_12a10_d11"
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
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		This.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event constructor;DataWindowChild ldw_child 

This.GetChild("smat_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.retrieve('129')



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
String  ls_color, ls_mat_cd, ls_spec
Decimal ldc_stock_qty, ldc_resv_qty, ldc_need_qty, ldc_req_qty, ldc_need_qty_chn, ldc_t_need_qty, ldc_loss
	
/*

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
		if len(data) <> 0 then
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
*/
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

type cb_copy_style from commandbutton within w_12a10_e
boolean visible = false
integer x = 2779
integer y = 44
integer width = 311
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "작지복사"
end type

event clicked;
		dw_copy_style.reset()
		dw_copy_style.insertrow(0)
		dw_copy_style.setitem(1,"fr_style_no", dw_head.getitemstring(1,"style_no"))
		dw_copy_style.visible = true
		dw_copy_style.setcolumn("to_style_no")
		dw_copy_style.setfocus()
end event

type dw_copy_style from datawindow within w_12a10_e
boolean visible = false
integer x = 1015
integer y = 816
integer width = 1504
integer height = 456
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "작지복사"
string dataobject = "d_12a10_d15"
boolean controlmenu = true
boolean resizable = true
boolean livescroll = true
end type

event buttonclicked;string ls_fr_style_no, ls_to_style_no 
string ls_fr_style, ls_fr_chno, ls_to_style, ls_to_chno

choose case dwo.name
	case "cb_copy_style"
			IF dw_copy_style.AcceptText() <> 1 THEN RETURN -1
			
			ls_fr_style_no = dw_copy_style.getitemstring(1,"fr_style_no")
			ls_to_style_no = dw_copy_style.getitemstring(1,"to_style_no")
		
			if not wf_style_chk(ls_fr_style_no) or not wf_style_chk(ls_to_style_no) then 
				 messagebox("확인","스타일번호를 다시 확인 하세요...")
				return -1
			end if
			
			ls_fr_style = LeftA(ls_fr_style_no,8)
			ls_fr_chno  = MidA(ls_fr_style_no,9,1)
			
			ls_to_style = LeftA(ls_to_style_no,8)
			ls_to_chno  = MidA(ls_to_style_no,9,1)
			
			if messagebox("확인","실행하시겠습니다...?",Exclamation!,YesNoCancel!,1 ) <> 1 then return			
			
			DECLARE sp_copy_style PROCEDURE FOR sp_copy_style  
					@fr_style	= :ls_fr_style,
					@fr_chno		= :ls_fr_chno,			
					@to_style	= :ls_to_style,
					@to_chno		= :ls_to_chno,
					@mod_id		= :gs_user_id;
						
			execute sp_copy_style;		
			 
			commit  USING SQLCA;
			messagebox("확인","정상처리되었슴니다...")
			dw_copy_style.visible = false
			dw_copy_style.reset()
			 
end choose

end event

type cbx_pop from checkbox within w_12a10_e
boolean visible = false
integer x = 4667
integer y = 108
integer width = 576
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "부자재팝업사용"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type dw_label from datawindow within w_12a10_e
boolean visible = false
integer x = 5243
integer y = 864
integer width = 485
integer height = 1016
integer taborder = 50
string title = "none"
string dataobject = "d_12a10_d14"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;string ls_out_ymd
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false


choose case dwo.name 
	case "label_outyn"
		if data="Y" then 	
			ls_out_ymd = this.getitemstring(row,"label_outymd")
			if ls_out_ymd = '' or isnull(ls_out_ymd) then 
				this.setitem(row,"label_outymd",string(now(),"yyyymmdd"))
			end if
		end if
end choose
end event

type dw_date from datawindow within w_12a10_e
integer x = 5
integer y = 340
integer width = 1239
integer height = 420
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_12a10_d02"
boolean border = false
boolean livescroll = true
end type

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

type st_1 from statictext within w_12a10_e
integer x = 1298
integer y = 368
integer width = 1211
integer height = 296
boolean bringtotop = true
integer textsize = -40
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 33554432
long backcolor = 67108864
string text = "생산의뢰서"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_4 from commandbutton within w_12a10_e
integer x = 375
integer y = 44
integer width = 439
integer height = 92
integer taborder = 150
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "디자인신규입력"
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
DateTime ld_datetime
Long i, ll_rows
string ls_flag, ls_sample_cd, ls_color, ls_remark

/* dw_head 필수입력 column check */
//IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

	dw_master.reset()
	dw_date.reset()
	dw_accept.reset()
	dw_master.insertrow(0)	
	dw_date.insertrow(0)
	dw_accept.insertrow(0)
	dw_head.reset()
	dw_head.insertrow(0)
	dw_head.enabled = false
	tab_1.enabled = true
	dw_master.Object.p_img.FileName = ''
	tab_1.tabpage_1.dw_1.reset()
	tab_1.tabpage_2.dw_2.reset()
	tab_1.tabpage_3.dw_3.reset()
	tab_1.tabpage_4.dw_4.reset()
	tab_1.tabpage_5.dw_5.reset()
	tab_1.tabpage_6.dw_6.reset()
	tab_1.tabpage_7.dw_7.reset()
	tab_1.tabpage_8.dw_8.reset()
//	wf_tab_insert(1)
	
//	dw_11.enabled = true

	//이미지만 입력시 구분자
	is_job = '1'	
	if is_job = '1' then
		dw_head.Modify("style_no.Protect=1")
		dw_head.Modify("cb_style_no.Protect=1")	
	end if
	
	dw_master.SetFocus()
	dw_master.SetColumn("image")
/*
// Assort 내역은 항상 retrieve
IF tab_1.selectedtab <> 1 THEN 
   wf_tab_retrieve(1) 
END IF


// 선택된 tab자료 조회  
wf_tab_retrieve(tab_1.selectedtab) 

wf_set_color(4)
*/



//This.Trigger Event ue_button(1, il_rows)
//This.Trigger Event ue_msg(1, il_rows)

end event

type cb_connect from commandbutton within w_12a10_e
boolean visible = false
integer x = 3936
integer y = 32
integer width = 402
integer height = 84
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Connect"
end type

event clicked;string ls_column_nm, ls_addr, ls_id, ls_pwd, ls_remote, ls_rocal
int li_rtn


ls_addr = dw_ftp.getitemstring(1,'addr')
ls_id = dw_ftp.getitemstring(1,'id')
ls_pwd = dw_ftp.getitemstring(1, 'pwd')

if bl_connect = true then
	MessageBox("확인", "FTP 가 이미 연결되었습니다.")
	return
end if

li_rtn = gf_ftp_connect(ls_addr,ls_id,ls_pwd)	


IF li_rtn = 1 then
	bl_connect = true
//	MessageBox("","FTP 성공")
ELSEIF li_rtn = -1 THEN
	MessageBox("확인","FTP 연결 실패")
	return
END IF

setpointer(HourGlass!)
string rtn
//rtn = uf_remote_dirlist('/ex/')
rtn = gf_ftp_remote_dirlist('')
setpointer(Arrow!)



end event

type cb_getfile from commandbutton within w_12a10_e
boolean visible = false
integer x = 3936
integer y = 120
integer width = 402
integer height = 84
integer taborder = 140
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "GetFile"
end type

event clicked;string ls_column_nm, ls_addr, ls_id, ls_pwd, ls_remote, ls_rocal
int li_rtn

ls_remote = dw_ftp.getitemstring(1, 'remotefile')
ls_rocal = dw_ftp.getitemstring(1, 'rocalfile')

setpointer(HourGlass!)
If gf_ftp_asc_chk(ls_remote) = 1 Then  // 텍스트
	li_rtn = gf_ftp_Getfile(ls_remote, ls_rocal, True )
Else // 이진
	li_rtn = gf_ftp_Getfile(ls_remote, ls_rocal, False)
End If	

setpointer(Arrow!)

If li_rtn = 1 Then
//	messagebox('','파일다운로드 성공 !!!!!')	 		 
Else
//	messagebox('','파일다운로드 실패 !!!!!')	 		 
End If 	 

end event

type cb_putfile from commandbutton within w_12a10_e
boolean visible = false
integer x = 3936
integer y = 204
integer width = 402
integer height = 84
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "PutFile"
end type

event clicked;string  ls_remote, ls_rocal
int li_rtn

ls_remote = dw_ftp.getitemstring(1, 'remotefile')
ls_rocal = dw_ftp.getitemstring(1, 'rocalfile')

setpointer(HourGlass!)
If gf_ftp_asc_chk(ls_rocal) = 1 Then  // 텍스트
	li_rtn = gf_ftp_putfile(ls_rocal, ls_remote, True )
Else // 이진
	li_rtn = gf_ftp_putfile(ls_rocal, ls_remote, False)
End If	

setpointer(Arrow!)	
If li_rtn = 1 Then
//	messagebox('','파일업로드 성공 !!!!!')
Else
//	messagebox('',ls_remote+' 파일 업로드 실패 !!!!!')
End If 	 

end event

type cb_disconnect from commandbutton within w_12a10_e
boolean visible = false
integer x = 3927
integer y = 296
integer width = 402
integer height = 84
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "DisConnect"
end type

event clicked;int li_rtn

if bl_connect = false then
	Messagebox("DisConnect확인", "먼저 FTP 연결을 확인하십시요")
	return
end if

li_rtn = gf_ftp_disconnect()

if li_rtn = 1 then
//	MessageBox("", "FTP 종료")
	bl_connect = false
elseif li_rtn = -1 then
	MessageBox("", "FTP 종료실패")
end if


end event

type dw_ftp from datawindow within w_12a10_e
boolean visible = false
integer x = 4777
integer y = 84
integer width = 1833
integer height = 592
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_12a10_ftp"
boolean border = false
boolean livescroll = true
end type

event constructor;dw_ftp.SetTransObject(SQLCA)
dw_ftp.insertrow(0)

dw_ftp.setitem(1,'addr','220.118.68.4')
dw_ftp.setitem(1,'id','olive_design')
dw_ftp.setitem(1,'pwd','ngisedevilo')

//dw_2.setitem(1,'remotefile','')
//dw_2.setitem(1,'rocalfile','C:\claim\')


bl_connect = false
u_ftp = create nvo_ftp
end event

type dw_accept from datawindow within w_12a10_e
integer x = 2578
integer y = 348
integer width = 2651
integer height = 376
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_12a10_d03"
boolean border = false
boolean livescroll = true
end type

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string  ls_file_nm, ls_yymmdd
integer li_value
string ls_column_nm, ls_column_value, ls_report
datetime ld_date_t

SELECT GetDate()
  INTO :ld_date_t
  FROM DUAL ;

//등록일자가져오기
ls_yymmdd = string(ld_date_t, "YYYYMMDD")
//ls_yymmdd = mid(ls_yymmdd,5,4)
IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

if ls_column_nm = "1" then
	dw_accept.setitem(1,'empno_1',gs_user_id)
	dw_accept.setitem(1,'sign_ymd_1',ls_yymmdd)
	dw_accept.object.cb_1.visible = false
end if

if ls_column_nm = "2" then
	dw_accept.setitem(1,'empno_2',gs_user_id)
	dw_accept.setitem(1,'sign_ymd_2',ls_yymmdd)
	dw_accept.object.cb_2.visible = false
end if

if ls_column_nm = "3" then
	dw_accept.setitem(1,'empno_3',gs_user_id)
	dw_accept.setitem(1,'sign_ymd_3',ls_yymmdd)
	dw_accept.object.cb_3.visible = false
end if

if ls_column_nm = "4" then
	dw_accept.setitem(1,'empno_4',gs_user_id)
	dw_accept.setitem(1,'sign_ymd_4',ls_yymmdd)
	dw_accept.object.cb_4.visible = false
end if

if ls_column_nm = "5" then
	dw_accept.setitem(1,'empno_5',gs_user_id)
	dw_accept.setitem(1,'sign_ymd_5',ls_yymmdd)
	dw_accept.object.cb_5.visible = false
end if

if ls_column_nm = "6" then
	dw_accept.setitem(1,'empno_6',gs_user_id)
	dw_accept.setitem(1,'sign_ymd_6',ls_yymmdd)
	dw_accept.object.cb_6.visible = false
end if

if ls_column_nm = "7" then
	dw_accept.setitem(1,'empno_7',gs_user_id)
	dw_accept.setitem(1,'sign_ymd_7',ls_yymmdd)
	dw_accept.object.cb_7.visible = false
end if

if ls_column_nm = "8" then
	dw_accept.setitem(1,'empno_8',gs_user_id)
	dw_accept.setitem(1,'sign_ymd_8',ls_yymmdd)
	dw_accept.object.cb_8.visible = false
end if

if ls_column_nm = "9" then
	dw_accept.setitem(1,'empno_9',gs_user_id)
	dw_accept.setitem(1,'sign_ymd_9',ls_yymmdd)
	dw_accept.object.cb_9.visible = false
end if

if ls_column_nm = "10" then
	dw_accept.setitem(1,'empno_10',gs_user_id)
	dw_accept.setitem(1,'sign_ymd_10',ls_yymmdd)
	dw_accept.object.cb_10.visible = false
end if

if ls_column_nm = "11" then
	dw_accept.setitem(1,'empno_11',gs_user_id)
	dw_accept.setitem(1,'sign_ymd_11',ls_yymmdd)
	dw_accept.object.cb_11.visible = false
end if

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event constructor;/*
DataWindowChild ldw_child_1

This.GetChild("empno_1", ldw_child_1)
ldw_child_1.SetTransObject(SQLCA)
ldw_child_1.Retrieve('%')
*/
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

end event

type cb_1 from commandbutton within w_12a10_e
boolean visible = false
integer x = 3479
integer y = 52
integer width = 402
integer height = 84
integer taborder = 150
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "결재후수정"
end type

event clicked;string ls_order_id, ls_sign_chk

select sign_chk
into :ls_sign_chk
from tb_12a22_d
where order_id = :ls_order_id;

if ls_sign_chk = 'Y' and cb_1.text = '결재후수정' then
	messagebox('확인!','다른직원 수정중에 있습니다. 완료후 처리해 주세요!!!')
	return
end if

if cb_1.text = '결재후수정' then
	cb_1.text = '수정진행중'
else
	cb_1.text = '결재후수정'
end if

ls_order_id = dw_master.getitemstring(1, 'order_id')

if cb_1.text = '결재후수정' then
	update tb_12a22_d set sign_chk = 'Y'
	from tb_12a22_d
	where order_id = :ls_order_id;
elseif cb_1.text = '결재후수정' then
	update tb_12a22_d set sign_chk = 'N'
	from tb_12a22_d
	where order_id = :ls_order_id;
end if

if sqlca.sqlcode = 0 then
	commit  USING SQLCA;		
else
	messagebox('수정오류','수정오류!')
	rollback  USING SQLCA;
end if
end event

