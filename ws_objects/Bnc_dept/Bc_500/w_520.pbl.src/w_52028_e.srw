$PBExportHeader$w_52028_e.srw
$PBExportComments$동일디자인배분(기간)
forward
global type w_52028_e from w_com010_e
end type
type dw_assort from datawindow within w_52028_e
end type
type dw_db from datawindow within w_52028_e
end type
type dw_temp from datawindow within w_52028_e
end type
type st_remark from statictext within w_52028_e
end type
type dw_order from datawindow within w_52028_e
end type
type st_trend1 from statictext within w_52028_e
end type
type st_trend2 from statictext within w_52028_e
end type
end forward

global type w_52028_e from w_com010_e
dw_assort dw_assort
dw_db dw_db
dw_temp dw_temp
st_remark st_remark
dw_order dw_order
st_trend1 st_trend1
st_trend2 st_trend2
end type
global w_52028_e w_52028_e

type variables
DataWindowChild idw_fr_color, idw_to_color , idw_shop_lv, idw_area_cd, idw_shop_lv1, idw_house_cd, idw_brand

String  is_fr_style, is_fr_chno, is_fr_color, is_save_opt,is_DIST_GRP, is_DW_sort
String  is_to_style, is_to_chno, is_to_color, is_yymmdd , is_s_ymd, is_e_ymd, is_house_cd, is_brand
Long    il_deal_seq
Boolean ib_NewDeal

end variables

forward prototypes
public function boolean wf_deal_1 ()
public function boolean wf_deal ()
public subroutine wf_retrieve_1 ()
public function boolean wf_body_set ()
public subroutine wf_add_stock ()
public function boolean wf_temp_set ()
public subroutine wf_retrieve_set ()
end prototypes

public function boolean wf_deal_1 ();Long i, k, ll_row_cnt, ll_assort_cnt , j
Long ll_deal_qty, ll_chk_qty, ll_tot_qty, ll_in_qty, ll_ord_qty

ll_row_cnt    = dw_body.RowCount() 
ll_assort_cnt = dw_assort.RowCount() 

IF ll_row_Cnt < 1 THEN Return False
 
dw_body.SetRedraw(False) 

FOR i = 1 TO ll_row_cnt 
	/* 배분잔량 체크 */
	ll_tot_qty = Long(dw_assort.Describe("evaluate('sum(ord_qty)',0)"))
//	ll_in_qty = dw_assort.GetitemNumber(k, "in_qty")	
	IF isnull(ll_tot_qty) OR ll_tot_qty < 1 THEN CONTINUE 
	
	for j = 1 to ll_assort_cnt
  	   ll_in_qty  = dw_assort.GetitemNumber(j, "in_qty")		
  	   ll_ord_qty = dw_assort.GetitemNumber(j, "ord_qty")				  
		  if ll_in_qty = 0 or isnull(ll_in_qty) then
			dw_assort.Setitem(j, "chk_qty", ll_ord_qty)
        end if	
	next	
	
	FOR k = 1 TO ll_assort_cnt 
		ll_chk_qty  = dw_assort.GetitemNumber(k, "chk_qty")

		IF isnull(ll_chk_qty) THEN ll_chk_qty = 0 
//		ll_deal_qty = dw_body.GetitemNumber(i, "sale_qty_" + String(k)) 
		ll_deal_qty = dw_body.GetitemNumber(i, "deal_qty_" + String(k)) 
		IF isnull(ll_deal_qty) THEN ll_deal_qty = 0 
		IF ll_chk_qty < 1 OR ll_deal_qty < 1 THEN CONTINUE 
		/* 배분 잔량이 기준배분량 보다 작을경우 배분잔량으로 처리 */
		ll_deal_qty = Min(ll_deal_qty, ll_chk_qty)
		dw_body.Setitem(i, "deal_qty_"  + String(k), ll_deal_qty)

		/* 배분 잔량 차감 */
		dw_assort.Setitem(k, "chk_qty", ll_chk_qty - ll_deal_qty)
	NEXT 
NEXT 
dw_body.SetRedraw(True) 

Return True
end function

public function boolean wf_deal ();Long i, k, ll_row_cnt, ll_assort_cnt 
Long ll_deal_qty, ll_chk_qty, ll_tot_qty

ll_row_cnt    = dw_body.RowCount() 
ll_assort_cnt = dw_assort.RowCount() 

IF ll_row_Cnt < 1 THEN Return False
 
dw_body.SetRedraw(False) 

FOR i = 1 TO ll_row_cnt 
	/* 배분잔량 체크 */
	ll_tot_qty = Long(dw_assort.Describe("evaluate('sum(chk_qty)',0)"))
	IF isnull(ll_tot_qty) OR ll_tot_qty < 1 THEN CONTINUE 
	FOR k = 1 TO ll_assort_cnt 
		ll_chk_qty  = dw_assort.GetitemNumber(k, "chk_qty")
		IF isnull(ll_chk_qty) THEN ll_chk_qty = 0 
//		ll_deal_qty = dw_body.GetitemNumber(i, "sale_qty_" + String(k)) 
		ll_deal_qty = dw_body.GetitemNumber(i, "deal_qty_" + String(k)) 		
		IF isnull(ll_deal_qty) THEN ll_deal_qty = 0 
		IF ll_chk_qty < 1 OR ll_deal_qty < 1 THEN CONTINUE 
		/* 배분 잔량이 기준배분량 보다 작을경우 배분잔량으로 처리 */
		ll_deal_qty = Min(ll_deal_qty, ll_chk_qty)
		dw_body.Setitem(i, "deal_qty_"  + String(k), ll_deal_qty) 
		/* 배분 잔량 차감 */
		dw_assort.Setitem(k, "chk_qty", ll_chk_qty - ll_deal_qty)
	NEXT 
NEXT 
dw_body.SetRedraw(True) 

Return True
end function

public subroutine wf_retrieve_1 ();/*  배분내역 dw_body로 이관 */
String ls_shop_cd,   ls_find 
Long   ll_row, ll_row_cnt,  ll_assort_cnt 
Long   i, k,   ll_deal_qty 

ll_row_cnt    = dw_order.RowCount()
IF ll_row_cnt < 1 THEN RETURN

ll_assort_cnt = dw_assort.RowCount()

dw_body.SetRedraw(False) 
FOR i = 1 TO ll_row_cnt 
   ls_shop_cd =  dw_order.object.shop_cd[i] 
	ll_row = dw_body.find("shop_cd = '" + ls_shop_cd + "'", 1, dw_body.RowCount())
	IF ll_row < 1 THEN
	   ll_row     =  dw_body.insertRow(0)
      dw_body.Setitem(ll_row, "shop_cd",   ls_shop_cd)
      dw_body.Setitem(ll_row, "shop_nm",   dw_order.object.shop_nm[i])
      dw_body.Setitem(ll_row, "shop_stat", dw_order.object.shop_stat[i])
      dw_body.Setitem(ll_row, "deal_yn",   dw_order.object.deal_yn[i])
      dw_body.Setitem(ll_row, "shop_lv",   dw_order.object.tb_91100_m_shop_lv[i])		
      dw_body.Setitem(ll_row, "area_cd",   dw_order.object.tb_91100_m_area_cd[i])		
      dw_body.Setitem(ll_row, "shop_lv1",   dw_order.object.tb_91100_m_shop_lv1[i])				
	END IF 
	ls_find = "size = '" + dw_order.object.size[i] + "'"
   k = dw_assort.find(ls_find, 1, ll_assort_cnt)	
	IF k > 0 THEN 
		ll_deal_qty = dw_order.GetitemNumber(i, "deal_qty")
		dw_body.Setitem(ll_row, "deal_qty_"  + String(k), ll_deal_qty)

	END IF
NEXT

/* 배분가능량에 추가로 표시 */
//wf_add_stock()

if is_save_opt <> "M" then 
	dw_body.ResetUpdate()
end if
dw_body.SetRedraw(True)

Return
end subroutine

public function boolean wf_body_set ();String  ls_modify,   ls_error
String  ls_size  ,   ls_house_cd
Long    ll_stock_qty
integer i, k

/* assort 내역 조회 */
if LeftA(upper(is_to_style),1) = 'W' then
	ls_house_cd = '030000'
else
	ls_house_cd = '010000'
end if

il_rows = dw_assort.Retrieve(is_to_style, is_to_chno, is_to_color, is_house_cd)

/* 사이즈 셋 */

FOR i = 1 TO 10 
	IF i > il_rows THEN
 
					
//     ls_modify = ' t_size_'      + String(i) + '.Visible=0' + &
//                  ' t_'           + String(i) + '.Visible=0' + &
//                  ' out_qty_'       + String(i) + '_t.Visible=0' + &										
//                  ' t_1'          + String(i) + '.Visible=0' + &
//                  ' t_3'          + String(i) + '.Visible=0' + &
//                  ' t_4'          + String(i) + '.Visible=0' + &						
//                  ' sale_qty_'       + String(i) + '_t.Visible=0' + &						
//                  ' sale_ymd_qty_'   + String(i) + '_t.Visible=0' + &												
//                  ' t_6'          + String(i) + '.Visible=0' + &
//                  ' t_7'          + String(i) + '.Visible=0' + &
//                  ' t_8'          + String(i) + '.Visible=0' + &
//                  ' t_9'          + String(i) + '.Visible=0' + &						
//                  ' t_ord_'       + String(i) + '.Visible=0' + &
//                  ' out_qty_'     + String(i) + '.Visible=0' + &
//                  ' rtrn_qty_'    + String(i) + '.Visible=0' + &
//                  ' sale_qty_'    + String(i) + '.Visible=0' + &
//                  ' c_stock_'     + String(i) + '.Visible=0' + &
//                  ' deal_qty_'    + String(i) + '.Visible=0' + &
//                  ' cs_out_'      + String(i) + '.Visible=0' + &
//                  ' cs_rtrn_'     + String(i) + '.Visible=0' + &
//                  ' cs_sale_'     + String(i) + '.Visible=0' + &
//                  ' cs_st_'       + String(i) + '.Visible=0' + &
//                  ' cs_deal_'     + String(i) + '.Visible=0' + &
//                  ' ord_qty_'     + String(i) + '.Visible=0' + &						
//                  ' in_qty_'      + String(i) + '.Visible=0' + &												
//                  ' sale_ymd_qty_'      + String(i) + '.Visible=0' + &												
//                  ' last_sale_ymd_'      + String(i) + '.Visible=0' + &																		
//                  ' cs_sale_ymd_qty_'     + String(i) + '.Visible=0'
//						

     ls_modify = ' t_size_'      + String(i) + '.Visible=0' + &
                  ' out_qty_'     + String(i) + '_t.Visible=0' + &										
                  ' rtrn_qty_'    + String(i) + '_t.Visible=0' + &										
                  ' t_3'          + String(i) + '.Visible=0' + &
                  ' t_4'          + String(i) + '.Visible=0' + &						
                  ' sale_qty_'       + String(i) + '_t.Visible=0' + &						
                  ' sale_ymd_qty_'   + String(i) + '_t.Visible=0' + &												
                  ' last_sale_ymd_'  + String(i) + '_t.Visible=0' + &												
                  ' t_7'          + String(i) + '.Visible=0' + &
                  ' t_8'          + String(i) + '.Visible=0' + &
                  ' t_9'          + String(i) + '.Visible=0' + &						
                  ' t_ord_'       + String(i) + '.Visible=0' + &
                  ' out_qty_'     + String(i) + '.Visible=0' + &
                  ' rtrn_qty_'    + String(i) + '.Visible=0' + &
                  ' sale_qty_'    + String(i) + '.Visible=0' + &
                  ' c_stock_'     + String(i) + '.Visible=0' + &
                  ' deal_qty_'    + String(i) + '.Visible=0' + &
                  ' cs_out_'      + String(i) + '.Visible=0' + &
                  ' cs_rtrn_'     + String(i) + '.Visible=0' + &
                  ' cs_sale_'     + String(i) + '.Visible=0' + &
                  ' cs_st_'       + String(i) + '.Visible=0' + &
                  ' cs_deal_'     + String(i) + '.Visible=0' + &
                  ' ord_qty_'     + String(i) + '.Visible=0' + &						
                  ' in_qty_'      + String(i) + '.Visible=0' + &												
                  ' sale_ymd_qty_'      + String(i) + '.Visible=0' + &												
                  ' last_sale_ymd_'      + String(i) + '.Visible=0' + &																		
                  ' cs_sale_ymd_qty_'     + String(i) + '.Visible=0'

						
   ELSE
	   ls_size      = dw_assort.object.size[i] 
	   ll_stock_qty = dw_assort.object.stock_qty[i] 
      ls_modify = ' t_size_'      + String(i) + '.Text="' + ls_size + '"' + &
		            ' t_size_'      + String(i) + '.Visible=1' + &
                   ' out_qty_'     + String(i) + '_t.Visible=1' + &
                  ' rtrn_qty_'    + String(i) + '_t.Visible=1' + &
                  ' t_3'          + String(i) + '.Visible=1' + &
                  ' t_4'          + String(i) + '.Visible=1' + &						
                  ' sale_qty_'       + String(i) + '_t.Visible=1' + &						
                  ' sale_ymd_qty_'   + String(i) + '_t.Visible=1' + &												
                  ' last_sale_ymd_'  + String(i) + '_t.Visible=1' + &						
                  ' t_7'          + String(i) + '.Visible=1' + &						
                  ' t_8'          + String(i) + '.Visible=1' + &						
                  ' t_9'          + String(i) + '.Visible=1' + &												
                  ' t_ord_'       + String(i) + '.text="' + String(ll_stock_qty) + '"' + &
		            ' t_ord_'       + String(i) + '.Visible=1' + & 
                  ' out_qty_'     + String(i) + '.Visible=1' + &
                  ' rtrn_qty_'    + String(i) + '.Visible=1' + &
                  ' sale_qty_'    + String(i) + '.Visible=1' + &
                  ' c_stock_'     + String(i) + '.Visible=1' + &
                  ' deal_qty_'    + String(i) + '.Visible=1' + &
                  ' cs_out_'      + String(i) + '.Visible=1' + &
                  ' cs_rtrn_'     + String(i) + '.Visible=1' + &
                  ' cs_sale_'     + String(i) + '.Visible=1' + &
                  ' cs_st_'       + String(i) + '.Visible=1' + &
                  ' cs_deal_'     + String(i) + '.Visible=1' + &
                  ' ord_qty_'     + String(i) + '.Visible=1' + &						
                  ' in_qty_'      + String(i) + '.Visible=1' + &												
                  ' sale_ymd_qty_'      + String(i) + '.Visible=1' + &												
                  ' last_sale_ymd_'      + String(i) + '.Visible=1' + &																								
                  ' cs_sale_ymd_qty_'     + String(i) + '.Visible=1'					
						
//     ls_modify = ' t_size_'      + String(i) + '.Text="' + ls_size + '"' + &
//		            ' t_size_'      + String(i) + '.Visible=1' + &
//                  ' t_'           + String(i) + '.Visible=1' + &
//                  ' t_1'          + String(i) + '.Visible=1' + &
//                  ' t_3'          + String(i) + '.Visible=1' + &
//                  ' t_4'          + String(i) + '.Visible=1' + &						
//                  ' sale_qty_'       + String(i) + '_t.Visible=1' + &						
//                  ' sale_ymd_qty_'   + String(i) + '_t.Visible=1' + &												
//                  ' t_6'          + String(i) + '.Visible=1' + &						
//                  ' t_7'          + String(i) + '.Visible=1' + &						
//                  ' t_8'          + String(i) + '.Visible=1' + &						
//                  ' t_9'          + String(i) + '.Visible=1' + &												
//                  ' t_ord_'       + String(i) + '.text="' + String(ll_stock_qty) + '"' + &
//		            ' t_ord_'       + String(i) + '.Visible=1' + & 
//                  ' out_qty_'     + String(i) + '.Visible=1' + &
//                  ' rtrn_qty_'    + String(i) + '.Visible=1' + &
//                  ' sale_qty_'    + String(i) + '.Visible=1' + &
//                  ' c_stock_'     + String(i) + '.Visible=1' + &
//                  ' deal_qty_'    + String(i) + '.Visible=1' + &
//                  ' cs_out_'      + String(i) + '.Visible=1' + &
//                  ' cs_rtrn_'     + String(i) + '.Visible=1' + &
//                  ' cs_sale_'     + String(i) + '.Visible=1' + &
//                  ' cs_st_'       + String(i) + '.Visible=1' + &
//                  ' cs_deal_'     + String(i) + '.Visible=1' + &
//                  ' ord_qty_'     + String(i) + '.Visible=1' + &						
//                  ' in_qty_'      + String(i) + '.Visible=1' + &												
//                  ' sale_ymd_qty_'      + String(i) + '.Visible=1' + &												
//                  ' last_sale_ymd_'      + String(i) + '.Visible=1' + &																								
//                  ' cs_sale_ymd_qty_'     + String(i) + '.Visible=1'												
						
	END IF






	ls_Error = dw_body.Modify(ls_modify)
	IF (ls_Error <> "") THEN 
		MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
		Return False
	END IF
NEXT 

Return True 
end function

public subroutine wf_add_stock ();/* 배분내역이 존재할경우 배분가능량에 배분량만큼 추가로 처리*/
Long   k, ll_deal_qty, ll_stock_qty 
String ls_modify,      ls_Error

FOR k = 1 TO dw_ASSORT.RowCount()
  	 ll_deal_qty  = dw_body.GetitemNumber(1, "c_deal_" + String(k)) 
	 ll_stock_qty = dw_assort.Object.stock_qty[k] + ll_deal_qty 
	 dw_assort.Setitem(k, "stock_qty", ll_stock_qty)
    ls_modify = 't_ord_'    + String(k) + '.text="' + String(ll_stock_qty) + '"'
    ls_Error  = dw_body.Modify(ls_modify)
    IF (ls_Error <> "") THEN 
		 MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
		 Return 
	 END IF 
NEXT 

end subroutine

public function boolean wf_temp_set ();/* 기준품번 판매내역 dw_body로 이관 */
String ls_shop_cd,   ls_find 
Long   ll_row, ll_row_cnt, ll_assort_cnt 
Long   i, k,   ll_sale_qty  
Boolean lb_Chk

ll_row_cnt    = dw_temp.RowCount()
IF ll_row_cnt < 1 THEN RETURN FALSE

ll_assort_cnt = dw_assort.RowCount()

dw_body.SetRedraw(False) 
dw_body.Reset()
lb_Chk = False 
FOR i = 1 TO ll_row_cnt 
	IF ls_shop_cd <> dw_temp.object.shop_cd[i] THEN 
      ls_shop_cd =  dw_temp.object.shop_cd[i] 
		ll_row     =  dw_body.insertRow(0)
      dw_body.Setitem(ll_row, "shop_cd", ls_shop_cd)
      dw_body.Setitem(ll_row, "shop_nm", dw_temp.object.shop_nm[i])
      dw_body.Setitem(ll_row, "deal_yn", dw_temp.object.deal_yn[i])
      dw_body.Setitem(ll_row, "shop_lv", dw_temp.object.shop_lv[i])		
      dw_body.Setitem(ll_row, "area_cd", dw_temp.object.area_cd[i])		
      dw_body.Setitem(ll_row, "shop_lv1", dw_temp.object.shop_lv1[i])				
      dw_body.Setitem(ll_row, "shop_lv1_1", dw_temp.object.shop_lv1[i])						
	END IF 
	ls_find = "size = '" + dw_temp.object.size[i] + "'"
   k = dw_assort.find(ls_find, 1, ll_assort_cnt)	
	IF k > 0 THEN 
		dw_body.Setitem(ll_row, "out_qty_"   + String(k), dw_temp.GetitemNumber(i, "out_qty"))
		dw_body.Setitem(ll_row, "rtrn_qty_"  + String(k), dw_temp.GetitemNumber(i, "rtrn_qty"))
		dw_body.Setitem(ll_row, "sale_qty_"  + String(k), dw_temp.GetitemNumber(i, "sale_qty"))
		dw_body.Setitem(ll_row, "sale_ymd_qty_"  + String(k), dw_temp.GetitemNumber(i, "sale_ymd_qty"))
		dw_body.Setitem(ll_row, "last_sale_ymd_"  + String(k), dw_temp.GetitemString(i, "last_sale_ymd"))

		dw_body.Setitem(ll_row, "ord_qty_"  + String(k), dw_assort.GetitemNumber(k, "ord_qty"))
		dw_body.Setitem(ll_row, "in_qty_"  + String(k), dw_assort.GetitemNumber(k, "in_qty"))		
      lb_Chk = True
	END IF
NEXT

dw_body.ResetUpdate()
dw_body.SetRedraw(True)

Return lb_chk
end function

public subroutine wf_retrieve_set ();/*  배분내역 dw_body로 이관 */
String ls_shop_cd,   ls_find 
Long   ll_row, ll_row_cnt,  ll_assort_cnt 
Long   i, k,   ll_deal_qty 

ll_row_cnt    = dw_db.RowCount()
IF ll_row_cnt < 1 THEN RETURN 

ll_assort_cnt = dw_assort.RowCount()

dw_body.SetRedraw(False) 
FOR i = 1 TO ll_row_cnt 
   ls_shop_cd =  dw_db.object.shop_cd[i] 
	ll_row = dw_body.find("shop_cd = '" + ls_shop_cd + "'", 1, dw_body.RowCount())
	IF ll_row < 1 THEN
	   ll_row     =  dw_body.insertRow(0)
      dw_body.Setitem(ll_row, "shop_cd",   ls_shop_cd)
      dw_body.Setitem(ll_row, "shop_nm",   dw_db.object.shop_nm[i])
      dw_body.Setitem(ll_row, "shop_stat", dw_db.object.shop_stat[i])
      dw_body.Setitem(ll_row, "deal_yn",   dw_db.object.deal_yn[i])
      dw_body.Setitem(ll_row, "shop_lv",   dw_db.object.tb_91100_m_shop_lv[i])		
      dw_body.Setitem(ll_row, "area_cd",   dw_db.object.tb_91100_m_area_cd[i])		
      dw_body.Setitem(ll_row, "shop_lv1",   dw_db.object.tb_91100_m_shop_lv1[i])				
      dw_body.Setitem(ll_row, "shop_lv1_1",   dw_db.object.tb_91100_m_shop_lv1[i])						
	END IF 
	ls_find = "size = '" + dw_db.object.size[i] + "'"
   k = dw_assort.find(ls_find, 1, ll_assort_cnt)	
	IF k > 0 THEN 
		ll_deal_qty = dw_db.GetitemNumber(i, "deal_qty")
		dw_body.Setitem(ll_row, "deal_qty_"  + String(k), ll_deal_qty)
		
	END IF
NEXT

/* 배분가능량에 추가로 표시 */
wf_add_stock()

dw_body.ResetUpdate()
dw_body.SetRedraw(True)

Return
end subroutine

on w_52028_e.create
int iCurrent
call super::create
this.dw_assort=create dw_assort
this.dw_db=create dw_db
this.dw_temp=create dw_temp
this.st_remark=create st_remark
this.dw_order=create dw_order
this.st_trend1=create st_trend1
this.st_trend2=create st_trend2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_assort
this.Control[iCurrent+2]=this.dw_db
this.Control[iCurrent+3]=this.dw_temp
this.Control[iCurrent+4]=this.st_remark
this.Control[iCurrent+5]=this.dw_order
this.Control[iCurrent+6]=this.st_trend1
this.Control[iCurrent+7]=this.st_trend2
end on

on w_52028_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_assort)
destroy(this.dw_db)
destroy(this.dw_temp)
destroy(this.st_remark)
destroy(this.dw_order)
destroy(this.st_trend1)
destroy(this.st_trend2)
end on

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(st_remark, "ScaleToRight")
dw_assort.SetTransObject(SQLCA)
dw_temp.SetTransObject(SQLCA)
dw_db.SetTransObject(SQLCA)
dw_order.SetTransObject(SQLCA)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.12.11                                                  */	
/* 수정일      : 2002.01.28                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title, ls_style_no, ls_proc_yn

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

ls_style_no = dw_head.GetItemString(1, "fr_style_no")
if IsNull(ls_style_no) or Trim(ls_style_no) = "" then
   MessageBox(ls_title,"기준품번 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_style_no")
   return false
end if
is_fr_style = MidA(ls_style_no, 1, 8)
is_fr_Chno  = MidA(ls_style_no, 9, 1)



if gs_brand = 'N' and (MidA(is_fr_style,1,1) = 'O' or MidA(is_fr_style,1,1) = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_style_no")
   return false
elseif gs_brand = 'O' and (MidA(is_fr_style,1,1) = 'N' or MidA(is_fr_style,1,1) = 'B' or MidA(is_fr_style,1,1) = 'L' or MidA(is_fr_style,1,1) = 'F' or MidA(is_fr_style,1,1) = 'G' or MidA(is_fr_style,1,1) = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_style_no")
   return false	
elseif gs_brand = 'B' and (MidA(is_fr_style,1,1) = 'O' or MidA(is_fr_style,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_style_no")
   return false		
elseif gs_brand = 'G' and (MidA(is_fr_style,1,1) = 'O' or MidA(is_fr_style,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_style_no")
   return false			
end if


is_fr_color = dw_head.GetItemString(1, "fr_color")
if IsNull(is_fr_color) or Trim(is_fr_color) = "" then
   MessageBox(ls_title,"기준색상 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_color")
   return false
end if

ls_style_no = dw_head.GetItemString(1, "to_style_no")
if IsNull(ls_style_no) or Trim(ls_style_no) = "" then
   MessageBox(ls_title,"배분품번 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_style_no")
   return false
end if
is_to_style = MidA(ls_style_no, 1, 8)
is_to_Chno  = MidA(ls_style_no, 9, 1)

is_to_color = dw_head.GetItemString(1, "to_color")
if IsNull(is_to_color) or Trim(is_to_color) = "" then
   MessageBox(ls_title,"배분색상 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_color")
   return false
end if

//IF is_fr_style + is_fr_chno + is_fr_color = is_to_style + is_to_chno + is_to_color THEN 
//   MessageBox(ls_title,"같은 품번,색상코드 입니다!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("to_style_no")
//   return false
//END IF	

il_deal_seq = dw_head.GetItemNumber(1, "deal_seq")
if IsNull(il_deal_seq) then
   MessageBox(ls_title,"배분차수를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_seq")
   return false
end if 

is_yymmdd = String(dw_head.GetitemDate(1, "yymmdd"), "yyyymmdd")

is_save_opt = dw_head.GetItemstring(1, "save_opt")
if IsNull(is_save_opt) or Trim(is_save_opt) = "" then
   MessageBox(ls_title,"작업구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("save_opt")
   return false
end if 

is_house_cd = dw_head.GetItemstring(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"출고차고를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if 

is_brand = dw_head.GetItemstring(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"매장브랜드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if 


if is_save_opt <> "O" then

	select max(isnull(proc_yn,'N'))
	into :ls_proc_yn
	from tb_52031_h
	where out_ymd = :is_yymmdd
	and deal_seq = :il_deal_seq
	and left(style ,1) = left(:is_fr_style,1);
	
	if ls_proc_yn = "Y" then
		MessageBox(ls_title,string(il_deal_seq,"00") + "차 배분은 출고 작업중 입니다! 다른 차수를 사용하세요! ")
		dw_head.SetFocus()
		dw_head.SetColumn("deal_seq")
		return false
	end if
end if

is_dist_grp = dw_head.GetItemString(1, "dist_grp")
if IsNull(is_dist_grp) or Trim(is_dist_grp) = "" then
   MessageBox(ls_title,"그룹 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dist_grp")
   return false
end if



is_s_ymd = String(dw_head.GetitemDate(1, "s_ymd"), "yyyymmdd")

is_e_ymd = String(dw_head.GetitemDate(1, "e_ymd"), "yyyymmdd")




return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_trend, ls_country
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "fr_style_no", "to_style_no"				
		   ls_style = MidA(as_data, 1, 8)
			ls_chno  = MidA(as_data, 9, 1)
			IF ai_div = 1 THEN 	
				if gs_brand <> 'K' then
					IF gf_style_chk(ls_style, ls_chno) THEN 
						IF as_column = "fr_style_no" THEN
							dw_head.Setitem(1, "fr_color", ls_color)
						ELSE
							dw_head.Setitem(1, "to_color", ls_color)
						END IF
						
						SELECT  dbo.sf_inter_nm('122', concept), dbo.sf_inter_nm("000", country_cd)
						INTO  :ls_trend, :ls_country
						FROM vi_12020_1 WITH(NOLOCK)
						WHERE STYLE = :ls_style
						and   chno =  :ls_chno;					
						
						
						if as_column = "fr_style_no" then
							st_trend1.text = "기준: " + ls_trend +  ", " + ls_country + " 생산 제품입니다!!"
						else
							st_trend2.text = "배분: " + ls_trend +  ", " + ls_country + " 생산 제품입니다!!"
						end if	
						
						RETURN 0
					END IF 
				end if
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = ""
			
			if gs_brand <> 'K' then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"  + &
											 " and chno like '" + ls_chno + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else
				gst_cd.Item_where = ""
			end if
			
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				IF as_column = "fr_style_no" THEN
    				dw_head.SetItem(al_row, "fr_style_no", lds_Source.GetItemString(1,"style_no"))
					dw_head.Setitem(al_row, "fr_color", ls_color)
				   dw_head.SetColumn("fr_color")
					ls_style = lds_Source.GetItemString(1,"style_no")
				ELSE
    				dw_head.SetItem(al_row, "to_style_no", lds_Source.GetItemString(1,"style_no"))
					dw_head.Setitem(al_row, "to_color", ls_color)
				   dw_head.SetColumn("to_color")
					ls_style = lds_Source.GetItemString(1,"style_no")
				END IF
				
					ls_style =  lds_Source.GetItemString(1,"style")
					ls_chno  =  lds_Source.GetItemString(1,"chno")					
								
					SELECT  dbo.sf_inter_nm('122', concept), dbo.sf_inter_nm("000", country_cd)
					INTO  :ls_trend, :ls_country
					FROM vi_12020_1 WITH(NOLOCK)
					WHERE STYLE = :ls_style
					and   chno =  :ls_chno;					
					
					
					if as_column = "fr_style_no" then
						st_trend1.text = "기준: " + ls_trend +  ", " + ls_country + " 생산 제품입니다!!"
					else
						st_trend2.text = "배분: " + ls_trend +  ", " + ls_country + " 생산 제품입니다!!"
					end if	
					

				long ll_style_ctrl

				if as_column = "to_style_no" then		
						select count(*)
						into :ll_style_ctrl
						from tb_56040_m (nolock)
						where work_gubn in ('A','O') 
						and   style = :ls_style
						and   gubn = 'C';		
						
						
						if isnull(ll_style_ctrl) = false  and ll_style_ctrl > 0 then
							messagebox("출고정지!", "출고 정지 품번입니다! 다시 한번 확인 후 배분 처리 하세요!")
						end if						
				end if					
					
				
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
Long ll_row, ll_row2
string ls_deal_gubn

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

/* 사이즈별 내역 처리 */
IF wf_body_set() = FALSE THEN RETURN



/* 기준 품번 판매내역 처리 */
il_rows = dw_temp.retrieve(is_fr_style,"%", is_fr_color, il_deal_seq, is_s_ymd, is_e_ymd, is_brand, is_dist_grp)

if is_save_opt = "O" then
		IF il_rows > 0 THEN 
			IF wf_temp_set() THEN 
				ll_row = dw_order.Retrieve(is_to_style, is_to_chno, is_to_color)
				IF ll_row > 0 THEN 
					wf_retrieve_1() 
					ls_deal_gubn =dw_order.Object.out_ymd[1]
				   
					IF LenA(ls_deal_gubn) > 4  THEN 
						st_remark.Text = "이미 출고의뢰된 자료 입니다."
						cb_delete.enabled = false
					ELSE 
						st_remark.Text = "이미 배분된 내역이 있습니다."
						cb_delete.enabled = false
					END IF
					ib_NewDeal = False
				ELSE
					st_remark.Text = "배분된 처리중......."
					ib_NewDeal     = wf_deal_1()
					st_remark.Text = ""
				END IF
				dw_body.SetFocus() 
			ELSE 
				il_rows = 0 
				MessageBox("오류", "서로 같은 사이즈가 없습니다. ")
			END IF
		ELSE
			MessageBox("확인", "기준품번,색상  판매실적이 없습니다.")
		END IF
		
elseif is_save_opt = "M" then
		IF il_rows > 0 THEN 
			IF wf_temp_set() THEN 
				
				ll_row2 = dw_db.Retrieve(is_yymmdd, il_deal_seq, is_to_style, is_to_chno, is_to_color)
				if ll_row2 > 0 then
						IF ll_row2 > 0 THEN 
							wf_retrieve_set() 
							IF dw_db.Object.proc_yn[1] = 'Y' THEN 
								st_remark.Text = "이미 출고된 자료 입니다."
								cb_delete.enabled = false
							ELSE
								st_remark.Text = "배분된 내역이 있습니다. 오더재배분의 경우 차수를 확인하세요!"
								cb_delete.enabled = true
							END IF
							ib_NewDeal = False
						ELSE
							st_remark.Text = "배분된 처리중......."
							ib_NewDeal     = wf_deal()
							st_remark.Text = ""
						END IF
				else											
				
						ll_row = dw_order.Retrieve(is_to_style, is_to_chno, is_to_color)
						IF ll_row > 0 THEN 
							wf_retrieve_1() 
							ls_deal_gubn =dw_order.Object.out_ymd[1]
							
							IF LenA(ls_deal_gubn) > 4  THEN 
								st_remark.Text = "이미 출고의뢰된 자료 입니다."
								cb_delete.enabled = false
							ELSE 
								st_remark.Text = "이미 배분된 내역이 있습니다."
								cb_delete.enabled = false
							END IF
							ib_NewDeal = False
						ELSE
							st_remark.Text = "배분 처리중......."
							ib_NewDeal     = wf_deal_1()
							st_remark.Text = ""
						END IF
				end if	
				dw_body.SetFocus() 
			ELSE 
				il_rows = 0 
				MessageBox("오류", "서로 같은 사이즈가 없습니다. ")
			END IF
		ELSE
			MessageBox("확인", "기준품번,색상  판매실적이 없습니다.")
		END IF
			
		
elseif is_save_opt = "N" then
	
		IF il_rows > 0 THEN 
		 wf_temp_set() 
				ll_row = dw_db.Retrieve(is_yymmdd, il_deal_seq, is_to_style, is_to_chno, is_to_color)
				IF ll_row > 0 THEN 
					wf_retrieve_set() 
					IF dw_db.Object.proc_yn[1] = 'Y' THEN 
						st_remark.Text = "이미 출고된 자료 입니다."
						cb_delete.enabled = false
					ELSE
						st_remark.Text = "이미 배분된 내역이 있습니다."
						cb_delete.enabled = true
					END IF
					ib_NewDeal = False
				ELSE
					st_remark.Text = "배분된 처리중......."
					ib_NewDeal     = wf_deal()
					st_remark.Text = ""
				END IF
				dw_body.SetFocus() 
//			ELSE 
//				il_rows = 0 
//				MessageBox("오류", "서로 같은 사이즈가 없습니다. ")
//			END IF
		ELSE
			MessageBox("확인", "기준품번,색상  판매실적이 없습니다.")
		END IF
		
	
end if

		
	This.Trigger Event ue_button(1, il_rows)		
		IF il_rows > 0 THEN 
			IF ib_NewDeal THEN 
				ib_changed = true
				cb_update.enabled = true
				cb_excel.enabled = false
			ELSEIF st_remark.Text = "이미 출고된 자료 입니다." THEN 
				dw_body.Enabled = False
			END IF
		END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
long     i, k, ll_row_count, ll_assort_cnt, ll_find, ll_deal_qty, ll_resv_qty 
datetime ld_datetime
String   ls_shop_cd, ls_size, ls_find, ls_shop_div, ls_ErrMsg

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

/* 초과배분 여부 체크 */ 
FOR k = 1 TO dw_ASSORT.RowCount()
  	 ll_deal_qty = dw_body.GetitemNumber(1, "c_deal_" + String(k)) 
	 IF ll_deal_qty > dw_assort.Object.stock_qty[k] THEN 
		 MessageBox("오류", "[" + dw_assort.GetitemString(k, "size") + "] 배분량이 초과 하였습니다,")
		 
		 Return -1 
	 END IF
NEXT

ll_assort_cnt = dw_assort.RowCount()
il_rows = 1 
FOR i=1 TO ll_row_count
	IF il_rows <> 1 THEN EXIT 
	idw_status = dw_body.GetItemStatus(i, 0, Primary!)
     			
	  IF is_save_opt = "N" then		
			IF idw_status = NewModified! OR idw_status = DataModified! THEN	
				ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
				ls_shop_div = MidA(ls_shop_cd, 2, 1)
				FOR k = 1 TO ll_assort_cnt 
					IF dw_body.GetItemStatus(i, "deal_qty_" + String(k), Primary!) = DataModified! THEN 
						ll_deal_qty = dw_body.GetitemNumber(i, "deal_qty_" + String(k))
						ls_size  = dw_assort.GetitemString(k, "size") 
						ls_find  = "shop_cd = '" + ls_shop_cd + "' and size = '" + ls_size + "'"
						ll_find = dw_db.find(ls_find, 1, dw_db.RowCount())
						IF ll_find > 0 THEN
							ll_resv_qty = dw_db.GetitemNumber(ll_find, "deal_qty", Primary!, True)
							IF isnull(ll_resv_qty) THEN 
								ll_resv_qty = ll_deal_qty 
							ELSE
								ll_resv_qty = ll_deal_qty - ll_resv_qty 
							END IF
							dw_db.Setitem(ll_find, "deal_qty", ll_deal_qty)
							dw_db.Setitem(ll_find, "mod_id",   gs_user_id)
							dw_db.Setitem(ll_find, "mod_dt",   ld_datetime)
							dw_db.Setitem(ll_find, "rshop_cd",   is_house_cd)							
						ELSE
							ll_find = dw_db.insertRow(0)
							dw_db.Setitem(ll_find, "out_ymd",  is_yymmdd)
							dw_db.Setitem(ll_find, "deal_seq", il_deal_seq)
							dw_db.Setitem(ll_find, "deal_fg",  '1') 
							dw_db.Setitem(ll_find, "style",    is_to_style)
							dw_db.Setitem(ll_find, "chno",     is_to_chno)
							dw_db.Setitem(ll_find, "shop_cd",  ls_shop_cd)
							dw_db.Setitem(ll_find, "color",    is_to_color)
							dw_db.Setitem(ll_find, "size",     ls_size)
							dw_db.Setitem(ll_find, "deal_qty", ll_deal_qty)
							dw_db.Setitem(ll_find, "reg_id",   gs_user_id)
							dw_db.Setitem(ll_find, "rshop_cd",   is_house_cd)							
							ll_resv_qty = ll_deal_qty
						END IF
						/* 예약 재고량 처리 */
						IF gf_stresv_update (is_to_style, is_to_chno,  is_to_color, ls_size, &
													ls_shop_div, ll_resv_qty, is_house_cd, ls_ErrMsg) = FALSE THEN 
							il_rows = -1
							EXIT
						END IF
					END IF
				NEXT
			END IF
		elseIF is_save_opt = "M" then		
			IF idw_status = NewModified! OR idw_status = DataModified! THEN	
				ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
				ls_shop_div = MidA(ls_shop_cd, 2, 1)
				FOR k = 1 TO ll_assort_cnt 
					IF dw_body.GetItemStatus(i, "deal_qty_" + String(k), Primary!) = DataModified! OR  dw_body.GetItemStatus(i, "deal_qty_" + String(k), Primary!) = NewModified! THEN 
						ll_deal_qty = dw_body.GetitemNumber(i, "deal_qty_" + String(k))
						ls_size  = dw_assort.GetitemString(k, "size") 
						ls_find  = "shop_cd = '" + ls_shop_cd + "' and size = '" + ls_size + "'"
						ll_find = dw_db.find(ls_find, 1, dw_db.RowCount())
						IF ll_find > 0 THEN
							ll_resv_qty = dw_db.GetitemNumber(ll_find, "deal_qty", Primary!, True)
							IF isnull(ll_resv_qty) THEN 
								ll_resv_qty = ll_deal_qty 
							ELSE
								ll_resv_qty = ll_deal_qty - ll_resv_qty 
							END IF
							dw_db.Setitem(ll_find, "deal_qty", ll_deal_qty)
							dw_db.Setitem(ll_find, "mod_id",   gs_user_id)
							dw_db.Setitem(ll_find, "mod_dt",   ld_datetime)
							dw_db.Setitem(ll_find, "rshop_cd",   is_house_cd)		
						ELSE
							ll_find = dw_db.insertRow(0)
							dw_db.Setitem(ll_find, "out_ymd",  is_yymmdd)
							dw_db.Setitem(ll_find, "deal_seq", il_deal_seq)
							dw_db.Setitem(ll_find, "deal_fg",  '1') 
							dw_db.Setitem(ll_find, "style",    is_to_style)
							dw_db.Setitem(ll_find, "chno",     is_to_chno)
							dw_db.Setitem(ll_find, "shop_cd",  ls_shop_cd)
							dw_db.Setitem(ll_find, "color",    is_to_color)
							dw_db.Setitem(ll_find, "size",     ls_size)
							dw_db.Setitem(ll_find, "deal_qty", ll_deal_qty)
							dw_db.Setitem(ll_find, "reg_id",   gs_user_id)
							dw_db.Setitem(ll_find, "rshop_cd",   is_house_cd)									
							ll_resv_qty = ll_deal_qty
						END IF
						/* 예약 재고량 처리 */
						IF gf_stresv_update (is_to_style, is_to_chno,  is_to_color, ls_size, &
													ls_shop_div, ll_resv_qty, is_house_cd, ls_ErrMsg) = FALSE THEN 
							il_rows = -1
							EXIT
						END IF
					END IF
				NEXT
			END IF			
	elseif  is_save_opt = "O" then			
  		IF idw_status = NewModified! OR idw_status = DataModified! THEN	
				ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
				ls_shop_div = MidA(ls_shop_cd, 2, 1)
				FOR k = 1 TO ll_assort_cnt 
					IF dw_body.GetItemStatus(i, "deal_qty_" + String(k), Primary!) = DataModified! OR  dw_body.GetItemStatus(i, "deal_qty_" + String(k), Primary!) =NewModified! THEN 
						ll_deal_qty = dw_body.GetitemNumber(i, "deal_qty_" + String(k))
						ls_size  = dw_assort.GetitemString(k, "size") 
						ls_find  = "shop_cd = '" + ls_shop_cd + "' and size = '" + ls_size + "'"
						ll_find = dw_order.find(ls_find, 1, dw_order.RowCount())
						
						IF ll_find > 0 THEN
//							ll_resv_qty = dw_db.GetitemNumber(ll_find, "deal_qty", Primary!, True)
//							IF isnull(ll_resv_qty) THEN 
//								ll_resv_qty = ll_deal_qty 
//							ELSE
//								ll_resv_qty = ll_deal_qty - ll_resv_qty 
//							END IF
							dw_order.Setitem(ll_find, "deal_qty", ll_deal_qty)
							dw_order.Setitem(ll_find, "mod_id",   gs_user_id)
							dw_order.Setitem(ll_find, "mod_dt",   ld_datetime)
						ELSE
							ll_find = dw_order.insertRow(0)

//							style,chno,shop_cd,color,size,deal_qty,out_ymd,reg_id,reg_dt,mod_id,mod_dt

 						   dw_order.Setitem(ll_find, "style",    is_to_style)
							dw_order.Setitem(ll_find, "out_ymd",  is_yymmdd)
							dw_order.Setitem(ll_find, "chno",     is_to_chno)
							dw_order.Setitem(ll_find, "shop_cd",  ls_shop_cd)
							dw_order.Setitem(ll_find, "color",    is_to_color)
							dw_order.Setitem(ll_find, "size",     ls_size)
							dw_order.Setitem(ll_find, "deal_qty", ll_deal_qty)
							dw_order.Setitem(ll_find, "reg_id",   gs_user_id)

						END IF
						/* 예약 재고량 처리 */
					END IF
				NEXT
			END IF
 end if		
NEXT

IF il_rows = 1 THEN 
	if is_save_opt = "N"  or is_save_opt = "M" then
	   il_rows = dw_db.Update()
	elseif is_save_opt = "O" then	
	   il_rows = dw_order.Update()
	end if	
END IF

if il_rows = 1 then
	/* 작업용 datawindow 초기화(dw_body) */
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
	IF isnull(ls_ErrMsg) = FALSE AND Trim(ls_ErrMsg) <> "" THEN 
		MessageBox("SQL 오류", ls_ErrMsg)
	END IF
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_delete();/*===========================================================================*/
/* 작성자      :                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.07.18                                                  */
/*===========================================================================*/

//dw_db.Retrieve(is_yymmdd, il_deal_seq, is_to_style, is_to_chno, is_to_color)

if is_save_opt = "N" or  is_save_opt = "M" then				
  	   DECLARE SP_DelResv_Update PROCEDURE FOR SP_DelResv_Update  
         @YYMMDD   = :is_yymmdd,   
			@deal_seq = :il_deal_seq,
         @style    = :is_to_style,   
         @chno     = :is_to_chno,   
         @color    = :is_to_color  ;

		EXECUTE SP_DelResv_Update;
		commit  USING SQLCA;  
		MessageBox("알림!","삭제되었습니다!")
      cb_delete.enabled = false
end if		
	
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_52028_e","0")
end event

event open;call super::open;

dw_head.Setitem(1,"s_ymd", relativedate(Today(),-30))
dw_head.Setitem(1,"e_ymd", Today())


if gs_brand = 'Y' then 
	dw_head.Setitem(1, "house_cd", 'M10000')
end if	

end event

type cb_close from w_com010_e`cb_close within w_52028_e
integer taborder = 140
end type

type cb_delete from w_com010_e`cb_delete within w_52028_e
integer taborder = 90
end type

type cb_insert from w_com010_e`cb_insert within w_52028_e
boolean visible = false
integer taborder = 60
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_52028_e
end type

type cb_update from w_com010_e`cb_update within w_52028_e
integer taborder = 130
end type

type cb_print from w_com010_e`cb_print within w_52028_e
boolean visible = false
integer taborder = 100
end type

type cb_preview from w_com010_e`cb_preview within w_52028_e
boolean visible = false
integer taborder = 110
end type

type gb_button from w_com010_e`gb_button within w_52028_e
end type

type cb_excel from w_com010_e`cb_excel within w_52028_e
integer taborder = 120
end type

type dw_head from w_com010_e`dw_head within w_52028_e
integer x = 9
integer y = 264
integer width = 3589
integer height = 384
string dataobject = "d_52028_h01"
end type

event dw_head::constructor;call super::constructor;
DataWindowChild  ldw_child

This.GetChild("fr_color", idw_fr_color)
idw_fr_color.SetTransObject(SQLCA)

This.GetChild("to_color", idw_to_color)
idw_to_color.SetTransObject(SQLCA)


This.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()



string ls_filter_str
ls_filter_str = ''	
ls_filter_str = "shop_cd < '020000' or  shop_cd = 'A10000'  or  shop_cd = 'B10000'  or  shop_cd = 'M10000' "
idw_house_cd.SetFilter(ls_filter_str)
idw_house_cd.Filter( )



This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve("001")
idw_brand.insertrow(1)
idw_brand.Setitem(1, "inter_cd", "$")
idw_brand.Setitem(1, "inter_nm", "보끄레전체")




This.GetChild("dist_grp", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('036')
ldw_child.insertrow(1)
ldw_child.Setitem(1, "inter_cd", "%")
ldw_child.Setitem(1, "inter_nm", "전체")


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.04.15                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
String ls_yymmdd, ls_dep_ymd

CHOOSE CASE dwo.name
	CASE "yymmdd"      
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
	CASE "fr_style_no"
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "to_style_no" 	 
		IF ib_itemchanged THEN RETURN 1

//		select dep_ymd 
//			into :ls_dep_ymd
//		from tb_12020_m a(nolock)
//		where  style = :data;
//		
//		if len(ls_dep_ymd) = 8  then  
//			  MessageBox("확인",ls_dep_ymd + "일자로 부진처리된 스타일입니다.. 영업 MD에 문의하세요.")
//			  Return 1			
//		end if
		
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
END CHOOSE

end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;String ls_style, ls_chno

CHOOSE CASE dwo.name
	CASE "fr_color"
		ls_style = LeftA(This.Object.fr_style_no[1], 8)
		ls_chno  = RightA(This.Object.fr_style_no[1], 1)
		idw_fr_color.Retrieve(ls_style, ls_chno)
	CASE "to_color"
		ls_style = LeftA(This.Object.to_style_no[1], 8)
		ls_chno = RightA(This.Object.to_style_no[1], 1)
		idw_to_color.Retrieve(ls_style, ls_chno)
END CHOOSE


end event

type ln_1 from w_com010_e`ln_1 within w_52028_e
integer beginy = 692
integer endy = 692
end type

type ln_2 from w_com010_e`ln_2 within w_52028_e
integer beginy = 696
integer endy = 696
end type

type dw_body from w_com010_e`dw_body within w_52028_e
integer y = 712
integer width = 3566
integer height = 1292
integer taborder = 40
string dataobject = "d_52028_d01_head"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.04.15                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
IF LeftA(dwo.name, 8) = "deal_qty" and Long(Data) < 0 THEN
	RETURN 1
END IF 

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

event dw_body::constructor;call super::constructor;
This.GetChild("shop_lv", idw_shop_lv)
idw_shop_lv.SetTransObject(SQLCA)
idw_shop_lv.Retrieve('093')
idw_shop_lv.InsertRow(1)
idw_shop_lv.SetItem(1, "inter_cd", '%')
idw_shop_lv.SetItem(1, "inter_nm", '전체')


This.GetChild("area_cd", idw_area_cd)
idw_area_cd.SetTransObject(SQLCA)
idw_area_cd.Retrieve('090')
idw_area_cd.InsertRow(1)
idw_area_cd.SetItem(1, "inter_cd", '%')
idw_area_cd.SetItem(1, "inter_nm", '전체')

This.GetChild("shop_lv1", idw_shop_lv1)
idw_shop_lv1.SetTransObject(SQLCA)
idw_shop_lv1.Retrieve('096')
idw_shop_lv1.InsertRow(1)
idw_shop_lv1.SetItem(1, "inter_cd", '%')
idw_shop_lv1.SetItem(1, "inter_nm", '전체')

end event

event dw_body::rowfocuschanging;call super::rowfocuschanging;string	  ls_KeyDownType
long il_LastClickedRow
boolean ib_action_on_buttonup

If newrow = 0 then Return


If this.IsSelected(newrow) Then
	il_LastClickedRow = currentrow
	ib_action_on_buttonup = true
	
//ElseIf Keydown(KeyControl!) then
//	il_LastClickedRow = row
//	this.SelectRow(row,TRUE)
	
Else
	il_LastClickedRow = currentrow
	this.SelectRow(0,FALSE)
	this.SelectRow(newrow,TRUE)
	
End If  

end event

event dw_body::clicked;call super::clicked;string	  ls_KeyDownType
long il_LastClickedRow
boolean ib_action_on_buttonup
Integer li_Po
string ls_Obj, LS_OBJ_1

If THIS.RowCount() < 1 Then Return

LS_OBJ_1 = THIS.GetObjectAtPointer()
li_Po = PosA(LS_OBJ_1,'_t')


//MESSAGEBOX("li_Po", STRING(LI_PO, "0000"))


If is_DW_sort = "A" then
	is_DW_sort = "D"
	
	ls_Obj = MidA(LS_OBJ_1,1,li_po - 1)
	
	
	IF li_Po  =0 THEN
	
	ELSE
//		messagebox("ls_Obj_d", ls_Obj)
		if ls_Obj = "shop_class" then
			this.setsort("shop_lv1_1 D, shop_lv D" )
			this.sort()
	   elseif ls_Obj = "area_cd1" then
			this.setsort("area_cd D, shop_lv1_1 D, shop_lv D" )
			this.sort()
			
			
		end if
		
	END IF
Else
	is_DW_sort = "A"

	ls_Obj = MidA(LS_OBJ_1,1,li_po - 1)
	
	IF li_Po  =0 THEN
	
	ELSE
//				messagebox("ls_Obj_a", ls_Obj)
		if ls_Obj = "shop_class" then
			this.setsort("shop_lv1_1 A, shop_lv A" )
			this.sort()
     elseif ls_Obj = "area_cd1" then
			this.setsort("area_cd A, shop_lv1_1 A, shop_lv A" )
			this.sort()			
		end if

	END IF
End If

end event

type dw_print from w_com010_e`dw_print within w_52028_e
end type

type dw_assort from datawindow within w_52028_e
boolean visible = false
integer x = 151
integer y = 520
integer width = 3122
integer height = 432
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "assort"
string dataobject = "d_com520"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_db from datawindow within w_52028_e
boolean visible = false
integer x = 110
integer y = 1092
integer width = 3355
integer height = 432
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "db"
string dataobject = "d_52028_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_temp from datawindow within w_52028_e
boolean visible = false
integer x = 206
integer y = 768
integer width = 3232
integer height = 432
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "temp"
string dataobject = "d_52028_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_remark from statictext within w_52028_e
integer x = 27
integer y = 168
integer width = 1637
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean focusrectangle = false
end type

type dw_order from datawindow within w_52028_e
boolean visible = false
integer x = 398
integer y = 960
integer width = 2615
integer height = 432
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "dw_order"
string dataobject = "d_52028_d04"
boolean resizable = true
boolean livescroll = true
end type

type st_trend1 from statictext within w_52028_e
integer x = 1673
integer y = 164
integer width = 992
integer height = 96
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "기준:"
boolean focusrectangle = false
end type

type st_trend2 from statictext within w_52028_e
integer x = 2693
integer y = 164
integer width = 878
integer height = 96
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "배분:"
boolean focusrectangle = false
end type

