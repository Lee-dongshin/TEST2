$PBExportHeader$w_55006_d.srw
$PBExportComments$출고 대비 판매율 현황
forward
global type w_55006_d from w_com010_d
end type
type tab_1 from tab within w_55006_d
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tabpage_6 from userobject within tab_1
end type
type tabpage_6 from userobject within tab_1
end type
type tab_1 from tab within w_55006_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type
type dw_shop_item_color_size from u_dw within w_55006_d
end type
type dw_shop_item_color_size_temp from u_dw within w_55006_d
end type
type dw_shop_style from u_dw within w_55006_d
end type
type dw_style_shop from u_dw within w_55006_d
end type
type dw_shop_item_size_temp2 from u_dw within w_55006_d
end type
type dw_shop_item_size from u_dw within w_55006_d
end type
type dw_shop_item from u_dw within w_55006_d
end type
type dw_shop_color from u_dw within w_55006_d
end type
type dw_shop_item_color from u_dw within w_55006_d
end type
end forward

global type w_55006_d from w_com010_d
integer width = 3698
integer height = 2304
tab_1 tab_1
dw_shop_item_color_size dw_shop_item_color_size
dw_shop_item_color_size_temp dw_shop_item_color_size_temp
dw_shop_style dw_shop_style
dw_style_shop dw_style_shop
dw_shop_item_size_temp2 dw_shop_item_size_temp2
dw_shop_item_size dw_shop_item_size
dw_shop_item dw_shop_item
dw_shop_color dw_shop_color
dw_shop_item_color dw_shop_item_color
end type
global w_55006_d w_55006_d

type variables
DataWindowChild idw_brand, idw_season, idw_sojae, idw_item, idw_color, idw_size, idw_st_brand 

String is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, is_st_brand
String is_shop_type, is_style, is_chno, is_color, is_size
Integer ii_tab_chk = 1
Boolean ib_tab1_chk = False, ib_tab2_chk = False, ib_tab3_chk = False
Boolean ib_tab4_chk = False, ib_tab5_chk = False, ib_tab6_chk = False
Long il_size_cnt

end variables

forward prototypes
public function integer wf_shop_item_color_size_set (datawindow adw_dw)
public subroutine wf_shop_item_color_size_head (datawindow adw_dw)
public subroutine wf_shop_item_color_size_destroy (datawindow adw_dw)
public function integer wf_shop_item_size_set (datawindow adw_dw)
public subroutine wf_shop_item_size_head (datawindow adw_dw)
end prototypes

public function integer wf_shop_item_color_size_set (datawindow adw_dw);Long i, j, ll_temp_row, ll_real_row
Decimal ldc_qty, ldc_out_sum = 0, ldc_sale_sum = 0, ldc_rtrn_sum = 0
String ls_shop_chk = ' ', ls_shop_cd, ls_shop_nm, ls_item_chk = ' ', ls_item, ls_item_nm
String ls_flag, ls_size, ls_size_t, ls_color_chk = ' ' ,ls_color, ls_color_nm

wf_shop_item_color_size_head(adw_dw)

ll_temp_row = dw_shop_item_color_size_temp.RowCount()

For i = 1 To ll_temp_row
	ls_shop_cd = dw_shop_item_color_size_temp.GetItemString(i, "shop_cd")
	ls_item    = dw_shop_item_color_size_temp.GetItemString(i, "item")
	ls_color   = dw_shop_item_color_size_temp.GetItemString(i, "color")	
	If ls_shop_chk <> ls_shop_cd or ls_item_chk <> ls_item or ls_color_chk <> ls_color Then
		ls_shop_nm = dw_shop_item_color_size_temp.GetItemString(i, "shop_nm")
		ls_item_nm = dw_shop_item_color_size_temp.GetItemString(i, "item_nm")
		ls_color_nm = dw_shop_item_color_size_temp.GetItemString(i, "color_nm")		
		
		ll_real_row = dw_shop_item_color_size.InsertRow(0)
		adw_dw.SetItem(ll_real_row, "shop_cd", ls_shop_cd)
		adw_dw.SetItem(ll_real_row, "shop_nm", ls_shop_nm)
		adw_dw.SetItem(ll_real_row, "item"   , ls_item)
		adw_dw.SetItem(ll_real_row, "item_nm", ls_item_nm)
		adw_dw.SetItem(ll_real_row, "color"   , ls_color)
		adw_dw.SetItem(ll_real_row, "color_nm", ls_color_nm)
		
		ldc_out_sum  = 0
		ldc_sale_sum = 0
		ldc_rtrn_sum = 0
		
	End If
	ls_flag = dw_shop_item_color_size_temp.GetItemString(i, "flag")
	ls_size = dw_shop_item_color_size_temp.GetItemString(i, "size")
	ldc_qty  = dw_shop_item_color_size_temp.GetItemDecimal(i, "qty")
	If ls_flag = '1' Then
		For j = 1 To il_size_cnt
			ls_size_t = LeftA(Trim(adw_dw.Describe("column_" + String(j, '00') + "_t.Text")), 2)
			If ls_size = ls_size_t Then
				adw_dw.SetItem(ll_real_row, "column_" + String(j, '00'), ldc_qty)
				Exit
			End If
		Next
		ldc_out_sum = ldc_out_sum + ldc_qty
	ElseIf ls_flag = '2' Then
		For j = il_size_cnt + 2 To il_size_cnt * 2 + 1
			ls_size_t = LeftA(Trim(adw_dw.Describe("column_" + String(j, '00') + "_t.Text")), 2)
			If ls_size = ls_size_t Then
				adw_dw.SetItem(ll_real_row, "column_" + String(j, '00'), ldc_qty)
				Exit
			End If
		Next
		ldc_sale_sum = ldc_sale_sum + ldc_qty
	ElseIf ls_flag = '3' Then
		ldc_rtrn_sum = ldc_rtrn_sum + ldc_qty
	End If
	ls_shop_chk = ls_shop_cd
	ls_item_chk = ls_item
	ls_color_chk = ls_color	
	ls_shop_cd = dw_shop_item_color_size_temp.GetItemString(i + 1, "shop_cd")
	ls_item    = dw_shop_item_color_size_temp.GetItemString(i + 1, "item")
	ls_color   = dw_shop_item_color_size_temp.GetItemString(i + 1, "color")	
	If ls_shop_chk <> ls_shop_cd or ls_item_chk <> ls_item or ls_color_chk <> ls_color or i = ll_temp_row Then
		// 출고계, 판매계, 재고 SETTING
		adw_dw.SetItem(ll_real_row, "column_" + String(il_size_cnt + 1, '00'),     ldc_out_sum)
		adw_dw.SetItem(ll_real_row, "column_" + String(il_size_cnt * 2 + 2, '00'), ldc_sale_sum)
		adw_dw.SetItem(ll_real_row, "column_" + String(il_size_cnt * 3 + 3, '00'), ldc_out_sum - ldc_rtrn_sum - ldc_sale_sum)
		adw_dw.SetItem(ll_real_row, "column_" + String(il_size_cnt * 3 + 4, '00'), ldc_sale_sum / ldc_out_sum)

		// 판매비 SETTING
		For j = il_size_cnt + 2 To il_size_cnt * 2 + 1
			ldc_qty      = adw_dw.GetItemDecimal(ll_real_row, "column_" + String(j, '00'))
			adw_dw.SetItem(ll_real_row, "column_" + String(j + il_size_cnt + 1, '00'), ldc_qty / ldc_sale_sum)
		Next
	End If
Next

Return 0

end function

public subroutine wf_shop_item_color_size_head (datawindow adw_dw);Long i, j, k, l, ll_y_col = 4
Long ll_x,  ll_y,  ll_width,  ll_height
Long ll_x1, ll_y1, ll_width1, ll_height1
String ls_modify, ls_modify_print
Long ll_line_width


If adw_dw.DataObject = 'd_55006_d09' Then
	ll_x  = 1676
	ll_y  = 84
	ll_width  = 0
	ll_height  = 60
	ll_x1 = 1693
	ll_y1 = 8
	ll_width1 = 0
	ll_height1 = 136
ElseIf adw_dw.DataObject = 'd_55006_r09' Then
	ll_x  = 1685
	ll_y  = 540
	ll_width  = 0
	ll_height  = 60
	ll_x1 = 1687
	ll_y1 = 464
	ll_width1 = 0
	ll_height1 = 140
End If
	
il_size_cnt = dw_shop_item_size_temp2.retrieve(is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, &
															  is_shop_type, is_style, is_chno, is_color, is_size)

// 출고 SIZE SETTING
For i = 1 To il_size_cnt
	ll_x      = ll_x + ll_width + 18
	ll_width  = 256
	ls_modify = ls_modify + "column_" + String(i, '00') + "_t.Text = '" + dw_shop_item_size_temp2.GetItemString(i, "size") + "~(" + dw_shop_item_size_temp2.GetItemString(i, "size_nm") + "~)' " + &
	                        "column_" + String(i, '00') + "_t.Visible = True " + &
	                        "column_" + String(i, '00') + "_t.X = " + String(ll_x) + &
	                        "column_" + String(i, '00') + "_t.Y = " + String(ll_y) + &
	                        "column_" + String(i, '00') + "_t.Width = " + String(ll_width) + &
	                        "column_" + String(i, '00') + "_t.Height = " + String(ll_height) + &
	                        "column_" + String(i, '00') + ".Visible = True " + &
	                        "column_" + String(i, '00') + ".X = " + String(ll_x) + &
	                        "column_" + String(i, '00') + ".Y = " + String(ll_y_col) + &
	                        "column_" + String(i, '00') + ".Width = " + String(ll_width) + &
	                        "column_" + String(i, '00') + ".Height = " + String(ll_height) + &
	                        "column_" + String(i, '00') + ".Format = '#,##0' "
									
	ll_width1 = ll_width1 + ll_width + 18
Next


// 출고 계 SETTING
ll_x      = ll_x + ll_width + 18
ll_width  = 256
ls_modify = ls_modify + "column_" + String(i, '00') + "_t.Text = '계' " + &
								"column_" + String(i, '00') + "_t.Visible = True " + &
								"column_" + String(i, '00') + "_t.X = " + String(ll_x) + &
								"column_" + String(i, '00') + "_t.Y = " + String(ll_y) + &
								"column_" + String(i, '00') + "_t.Width = " + String(ll_width) + &
								"column_" + String(i, '00') + "_t.Height = " + String(ll_height) + &
								"column_" + String(i, '00') + ".Visible = True " + &
								"column_" + String(i, '00') + ".X = " + String(ll_x) + &
								"column_" + String(i, '00') + ".Y = " + String(ll_y_col) + &
								"column_" + String(i, '00') + ".Width = " + String(ll_width) + &
								"column_" + String(i, '00') + ".Height = " + String(ll_height) + &
                        "column_" + String(i, '00') + ".Format = '#,##0' "

ll_width1 = ll_width1 + ll_width

// 출고 TEXT SETTING
ls_modify = ls_modify + "out_qty_t.Text = '출      고' " + &
								"out_qty_t.Visible = True " + &
                        "out_qty_t.X = " + String(ll_x1) + &
                        "out_qty_t.Y = " + String(ll_y1) + &
                        "out_qty_t.Width = " + String(ll_width1) + &
                        "out_qty_t.Height = " + String(ll_height)

ll_x1 = ll_x1 + ll_width1 + 18
ll_width1 = 0

// 판매 SIZE SETTING
For j = 1 + i To il_size_cnt + i
	ll_x = ll_x + ll_width + 18
	ll_width = 256
	ls_modify = ls_modify + "column_" + String(j, '00') + "_t.Text = '" + dw_shop_item_size_temp2.GetItemString(j - i, "size") + "~(" + dw_shop_item_size_temp2.GetItemString(j - i, "size_nm") + "~)' " + &
	                        "column_" + String(j, '00') + "_t.Visible = True " + &
	                        "column_" + String(j, '00') + "_t.X = " + String(ll_x) + &
	                        "column_" + String(j, '00') + "_t.Y = " + String(ll_y) + &
	                        "column_" + String(j, '00') + "_t.Width = " + String(ll_width) + &
	                        "column_" + String(j, '00') + "_t.Height = " + String(ll_height) + &
	                        "column_" + String(j, '00') + ".Visible = True " + &
	                        "column_" + String(j, '00') + ".X = " + String(ll_x) + &
	                        "column_" + String(j, '00') + ".Y = " + String(ll_y_col) + &
	                        "column_" + String(j, '00') + ".Width = " + String(ll_width) + &
	                        "column_" + String(j, '00') + ".Height = " + String(ll_height) + &
	                        "column_" + String(j, '00') + ".Format = '#,##0' "

	ll_width1 = ll_width1 + ll_width + 18
Next

// 판매 계 SETTING
ll_x      = ll_x + ll_width + 18
ll_width  = 256
ls_modify = ls_modify + "column_" + String(j, '00') + "_t.Text = '계' " + &
								"column_" + String(j, '00') + "_t.Visible = True " + &
								"column_" + String(j, '00') + "_t.X = " + String(ll_x) + &
								"column_" + String(j, '00') + "_t.Y = " + String(ll_y) + &
								"column_" + String(j, '00') + "_t.Width = " + String(ll_width) + &
								"column_" + String(j, '00') + "_t.Height = " + String(ll_height) + &
								"column_" + String(j, '00') + ".Visible = True " + &
								"column_" + String(j, '00') + ".X = " + String(ll_x) + &
								"column_" + String(j, '00') + ".Y = " + String(ll_y_col) + &
								"column_" + String(j, '00') + ".Width = " + String(ll_width) + &
								"column_" + String(j, '00') + ".Height = " + String(ll_height) + &
                        "column_" + String(j, '00') + ".Format = '#,##0' "

ll_width1 = ll_width1 + ll_width

// 판매 TEXT SETTING
ls_modify = ls_modify + "sale_qty_t.Text = '판      매' " + &
								"sale_qty_t.Visible = True " + &
                        "sale_qty_t.X = " + String(ll_x1) + &
                        "sale_qty_t.Y = " + String(ll_y1) + &
                        "sale_qty_t.Width = " + String(ll_width1) + &
                        "sale_qty_t.Height = " + String(ll_height)

ll_x1 = ll_x1 + ll_width1 + 18
ll_width1 = 0

// 판매비 SIZE SETTING
For k = 1 + j To il_size_cnt + j
	ll_x = ll_x + ll_width + 18
	ll_width = 256
	ls_modify = ls_modify + "column_" + String(k, '00') + "_t.Text = '" + dw_shop_item_size_temp2.GetItemString(k - j, "size") + "~(" + dw_shop_item_size_temp2.GetItemString(k - j, "size_nm") + "~)' " + &
	                        "column_" + String(k, '00') + "_t.Visible = True " + &
	                        "column_" + String(k, '00') + "_t.X = " + String(ll_x) + &
	                        "column_" + String(k, '00') + "_t.Y = " + String(ll_y) + &
	                        "column_" + String(k, '00') + "_t.Width = " + String(ll_width) + &
	                        "column_" + String(k, '00') + "_t.Height = " + String(ll_height) + &
	                        "column_" + String(k, '00') + ".Visible = True " + &
	                        "column_" + String(k, '00') + ".X = " + String(ll_x) + &
	                        "column_" + String(k, '00') + ".Y = " + String(ll_y_col) + &
	                        "column_" + String(k, '00') + ".Width = " + String(ll_width) + &
	                        "column_" + String(k, '00') + ".Height = " + String(ll_height) + &
	                        "column_" + String(k, '00') + ".Format = '0.00%' "

	ll_width1 = ll_width1 + ll_width + 18
Next

// 판매비 TEXT SETTING
ll_width1 = ll_width1 - 18

ls_modify = ls_modify + "sale_per_t.Text = '판  매  비' " + &
								"sale_per_t.Visible = True " + &
                        "sale_per_t.X = " + String(ll_x1) + &
                        "sale_per_t.Y = " + String(ll_y1) + &
                        "sale_per_t.Width = " + String(ll_width1) + &
                        "sale_per_t.Height = " + String(ll_height)

ll_x1 = ll_x1 + ll_width1 + 18
ll_width1 = 0

// 재고 SETTING
ll_x      = ll_x + ll_width + 18
ll_width  = 256
ll_width1 = ll_width1 + ll_width
ls_modify = ls_modify + "column_" + String(k, '00') + "_t.Text = '~n~r재  고' " + &
								"column_" + String(k, '00') + "_t.Visible = True " + &
								"column_" + String(k, '00') + "_t.X = " + String(ll_x1) + &
								"column_" + String(k, '00') + "_t.Y = " + String(ll_y1) + &
								"column_" + String(k, '00') + "_t.Width = " + String(ll_width1) + &
								"column_" + String(k, '00') + "_t.Height = " + String(ll_height1) + &
								"column_" + String(k, '00') + ".Visible = True " + &
								"column_" + String(k, '00') + ".X = " + String(ll_x1) + &
								"column_" + String(k, '00') + ".Y = " + String(ll_y_col) + &
								"column_" + String(k, '00') + ".Width = " + String(ll_width1) + &
								"column_" + String(k, '00') + ".Height = " + String(ll_height) + &
                        "column_" + String(k, '00') + ".Format = '#,##0' "

ll_x1 = ll_x1 + ll_width1 + 18
ll_width1 = 0

// 판매율 SETTING
k++
ll_x      = ll_x + ll_width + 18
ll_width  = 256
ll_width1 = ll_width1 + ll_width
ls_modify = ls_modify + "column_" + String(k, '00') + "_t.Text = '~n~r판매율' " + &
								"column_" + String(k, '00') + "_t.Visible = True " + &
								"column_" + String(k, '00') + "_t.X = " + String(ll_x1) + &
								"column_" + String(k, '00') + "_t.Y = " + String(ll_y1) + &
								"column_" + String(k, '00') + "_t.Width = " + String(ll_width1) + &
								"column_" + String(k, '00') + "_t.Height = " + String(ll_height1) + &
								"column_" + String(k, '00') + ".Visible = True " + &
								"column_" + String(k, '00') + ".X = " + String(ll_x1) + &
								"column_" + String(k, '00') + ".Y = " + String(ll_y_col) + &
								"column_" + String(k, '00') + ".Width = " + String(ll_width1) + &
								"column_" + String(k, '00') + ".Height = " + String(ll_height) + &
                        "column_" + String(k, '00') + ".Format = '0.00%' "

ll_x1 = ll_x1 + ll_width1 + 18
ll_width1 = 0

// dw_print LINE 정렬
If adw_dw.DataObject = 'd_55006_r03' Then
	ll_line_width = Long(adw_dw.Describe("l_2.X2")) - Long(adw_dw.Describe("l_2.X1"))
	ls_modify = ls_modify + "t_title.Width = " + String(ll_x1) + &
									"l_1.X2 = " + String(ll_x1) + &
									"l_4.X2 = " + String(ll_x1) + &
									"l_5.X2 = " + String(ll_x1) + &
									"l_6.X2 = " + String(ll_x1) + &
									"l_2.X1 = " + String( (ll_x1 / 2) - ( ll_line_width / 2 ) ) + &
									"l_2.X2 = " + String( (ll_x1 / 2) - ( ll_line_width / 2 ) + ll_line_width ) + &
									"l_3.X1 = " + String( (ll_x1 / 2) - ( ll_line_width / 2 ) ) + &
									"l_3.X2 = " + String( (ll_x1 / 2) - ( ll_line_width / 2 ) + ll_line_width ) + &
									"t_10.X = " + String( (ll_x1 / 2) - (Long(adw_dw.Describe("t_10.Width")) / 2) ) + &
									"t_11.X = " + String( (ll_x1 / 2) - (Long(adw_dw.Describe("t_10.Width")) / 2) ) + &
									"t_pg_id.X = " + String( ll_x1 - ( Long(adw_dw.Describe("t_title.Width")) - Long(adw_dw.Describe("t_pg_id.X")) ) ) + &
									"t_7.X = " + String( ll_x1 - ( Long(adw_dw.Describe("t_title.Width")) - Long(adw_dw.Describe("t_pg_id.X")) ) ) + &
									"compute_7.X = " + String( ll_x1 - ( Long(adw_dw.Describe("t_title.Width")) - Long(adw_dw.Describe("compute_7.X")) ) ) + &
									"t_user_id.X = " + String( ll_x1 - ( Long(adw_dw.Describe("t_title.Width")) - Long(adw_dw.Describe("t_user_id.X")) ) ) + &
									"t_15.X = " + String( ll_x1 - ( Long(adw_dw.Describe("t_title.Width")) - Long(adw_dw.Describe("t_15.X")) ) ) + &
									"t_datetime.X = " + String( ll_x1 - ( Long(adw_dw.Describe("t_title.Width")) - Long(adw_dw.Describe("t_datetime.X")) ) )
End If





adw_dw.Modify(ls_modify)



end subroutine

public subroutine wf_shop_item_color_size_destroy (datawindow adw_dw);Long i, j, k, l, ll_y_col = 4
Long ll_x,  ll_y,  ll_width,  ll_height
Long ll_x1, ll_y1, ll_width1, ll_height1
String ls_modify, ls_modify_print
Long ll_line_width, ll_row

ll_row = dw_shop_item_color_size_temp.rowcount()

// 출고 SIZE SETTING
For i = 1 To 100
	ls_modify = ls_modify + "column_" + String(i, '00') + "_t.Visible = false " 
Next



// 판매 SIZE SETTING
For j = 1 + i To il_size_cnt + i
	ls_modify = ls_modify + "column_" + String(j, '00') + "_t.Visible = false " 

Next

ls_modify = ls_modify + "column_" + String(j, '00') + "_t.Visible = false " 
								
// 판매 TEXT SETTING
ls_modify = ls_modify + "sale_qty_t.Visible = false " 

// 판매비 SIZE SETTING
For k = 1 + j To il_size_cnt + j

	ls_modify = ls_modify + "column_" + String(k, '00') + "_t.Visible = false " 

Next

// 판매비 TEXT SETTING

ls_modify = ls_modify + "sale_per_t.Visible = false " 
                        

ll_x1 = ll_x1 + ll_width1 + 18
ll_width1 = 0

// 재고 SETTING
ls_modify = ls_modify + "column_" + String(k, '00') + "_t.Visible = false " 

// 판매율 SETTING
k++
ls_modify = ls_modify + "column_" + String(k, '00') + "_t.Visible = false " 


adw_dw.Modify(ls_modify)






end subroutine

public function integer wf_shop_item_size_set (datawindow adw_dw);//Long i, j, ll_temp_row, ll_real_row
//Decimal ldc_qty, ldc_out_sum = 0, ldc_sale_sum = 0, ldc_rtrn_sum = 0
//String ls_shop_chk = ' ', ls_shop_cd, ls_shop_nm, ls_item_chk = ' ', ls_item, ls_item_nm
//String ls_flag, ls_size, ls_size_t
//
//wf_shop_item_size_head(adw_dw)
//
//ll_temp_row = dw_shop_item_size_temp.RowCount()
//
//For i = 1 To ll_temp_row
//	ls_shop_cd = dw_shop_item_size_temp.GetItemString(i, "shop_cd")
//	ls_item    = dw_shop_item_size_temp.GetItemString(i, "item")
//	
//	If ls_shop_chk <> ls_shop_cd or ls_item_chk <> ls_item Then
//		ls_shop_nm = dw_shop_item_size_temp.GetItemString(i, "shop_nm")
//		ls_item_nm = dw_shop_item_size_temp.GetItemString(i, "item_nm")
//		
//		ll_real_row = dw_shop_item_size.InsertRow(0)
//		adw_dw.SetItem(ll_real_row, "shop_cd", ls_shop_cd)
//		adw_dw.SetItem(ll_real_row, "shop_nm", ls_shop_nm)
//		adw_dw.SetItem(ll_real_row, "item"   , ls_item)
//		adw_dw.SetItem(ll_real_row, "item_nm", ls_item_nm)
//		ldc_out_sum  = 0
//		ldc_sale_sum = 0
//		ldc_rtrn_sum = 0
//	End If
//	
//	ls_flag = dw_shop_item_size_temp.GetItemString(i, "flag")
//	ls_size = dw_shop_item_size_temp.GetItemString(i, "size")
//	ldc_qty = dw_shop_item_size_temp.GetItemDecimal(i, "qty")
//	
//	If ls_flag = '1' Then
//		For j = 1 To il_size_cnt
//			ls_size_t = Left(Trim(adw_dw.Describe("column_" + String(j, '00') + "_t.Text")), 2)
//			If ls_size = ls_size_t Then
//				adw_dw.SetItem(ll_real_row, "column_" + String(j, '00'), ldc_qty)
//				Exit
//			End If
//		Next
//		ldc_out_sum = ldc_out_sum + ldc_qty
//	ElseIf ls_flag = '2' Then
//		For j = il_size_cnt + 2 To il_size_cnt * 2 + 1
//			ls_size_t = Left(Trim(adw_dw.Describe("column_" + String(j, '00') + "_t.Text")), 2)
//			If ls_size = ls_size_t Then
//				adw_dw.SetItem(ll_real_row, "column_" + String(j, '00'), ldc_qty)
//				Exit
//			End If
//		Next
//		ldc_sale_sum = ldc_sale_sum + ldc_qty
//	ElseIf ls_flag = '3' Then
//		ldc_rtrn_sum = ldc_rtrn_sum + ldc_qty
//	End If
//	
//	ls_shop_chk = ls_shop_cd
//	ls_item_chk = ls_item
//	ls_shop_cd = dw_shop_item_size_temp.GetItemString(i + 1, "shop_cd")
//	ls_item    = dw_shop_item_size_temp.GetItemString(i + 1, "item")
//	If ls_shop_chk <> ls_shop_cd or ls_item_chk <> ls_item or i = ll_temp_row Then
//		// 출고계, 판매계, 재고 SETTING
//		adw_dw.SetItem(ll_real_row, "column_" + String(il_size_cnt + 1, '00'),     ldc_out_sum)
//		adw_dw.SetItem(ll_real_row, "column_" + String(il_size_cnt * 2 + 2, '00'), ldc_sale_sum)
//		adw_dw.SetItem(ll_real_row, "column_" + String(il_size_cnt * 3 + 3, '00'), ldc_out_sum - ldc_rtrn_sum - ldc_sale_sum)
//		adw_dw.SetItem(ll_real_row, "column_" + String(il_size_cnt * 3 + 4, '00'), ldc_sale_sum / ldc_out_sum)
//
//		// 판매비 SETTING
//		For j = il_size_cnt + 2 To il_size_cnt * 2 + 1
//			ldc_qty      = adw_dw.GetItemDecimal(ll_real_row, "column_" + String(j, '00'))
//			adw_dw.SetItem(ll_real_row, "column_" + String(j + il_size_cnt + 1, '00'), ldc_qty / ldc_sale_sum)
//		Next
//	End If
//Next
//
Return 0
//
end function

public subroutine wf_shop_item_size_head (datawindow adw_dw);//Long i, j, k, l, ll_y_col = 4
//Long ll_x,  ll_y,  ll_width,  ll_height
//Long ll_x1, ll_y1, ll_width1, ll_height1
//String ls_modify, ls_modify_print
//Long ll_line_width
//
//If adw_dw.DataObject = 'd_55006_d03' Then
//	ll_x  = 1203
//	ll_y  = 84
//	ll_width  = 0
//	ll_height  = 60
//	ll_x1 = 1221
//	ll_y1 = 8
//	ll_width1 = 0
//	ll_height1 = 136
//ElseIf adw_dw.DataObject = 'd_55006_r03' Then
//	ll_x  = 1203
//	ll_y  = 540
//	ll_width  = 0
//	ll_height  = 60
//	ll_x1 = 1221
//	ll_y1 = 464
//	ll_width1 = 0
//	ll_height1 = 140
//End If
//	
//il_size_cnt = dw_shop_item_size_temp2.retrieve(is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, &
//															  is_shop_type, is_style, is_chno, is_color, is_size)
//
//// 출고 SIZE SETTING
//For i = 1 To il_size_cnt
//	ll_x      = ll_x + ll_width + 18
//	ll_width  = 256
//	ls_modify = ls_modify + "column_" + String(i, '00') + "_t.Text = '" + dw_shop_item_size_temp2.GetItemString(i, "size") + "~(" + dw_shop_item_size_temp2.GetItemString(i, "size_nm") + "~)' " + &
//	                        "column_" + String(i, '00') + "_t.Visible = True " + &
//	                        "column_" + String(i, '00') + "_t.X = " + String(ll_x) + &
//	                        "column_" + String(i, '00') + "_t.Y = " + String(ll_y) + &
//	                        "column_" + String(i, '00') + "_t.Width = " + String(ll_width) + &
//	                        "column_" + String(i, '00') + "_t.Height = " + String(ll_height) + &
//	                        "column_" + String(i, '00') + ".Visible = True " + &
//	                        "column_" + String(i, '00') + ".X = " + String(ll_x) + &
//	                        "column_" + String(i, '00') + ".Y = " + String(ll_y_col) + &
//	                        "column_" + String(i, '00') + ".Width = " + String(ll_width) + &
//	                        "column_" + String(i, '00') + ".Height = " + String(ll_height) + &
//	                        "column_" + String(i, '00') + ".Format = '#,##0' "
//									
//	ll_width1 = ll_width1 + ll_width + 18
//Next
//
//// 출고 계 SETTING
//ll_x      = ll_x + ll_width + 18
//ll_width  = 256
//ls_modify = ls_modify + "column_" + String(i, '00') + "_t.Text = '계' " + &
//								"column_" + String(i, '00') + "_t.Visible = True " + &
//								"column_" + String(i, '00') + "_t.X = " + String(ll_x) + &
//								"column_" + String(i, '00') + "_t.Y = " + String(ll_y) + &
//								"column_" + String(i, '00') + "_t.Width = " + String(ll_width) + &
//								"column_" + String(i, '00') + "_t.Height = " + String(ll_height) + &
//								"column_" + String(i, '00') + ".Visible = True " + &
//								"column_" + String(i, '00') + ".X = " + String(ll_x) + &
//								"column_" + String(i, '00') + ".Y = " + String(ll_y_col) + &
//								"column_" + String(i, '00') + ".Width = " + String(ll_width) + &
//								"column_" + String(i, '00') + ".Height = " + String(ll_height) + &
//                        "column_" + String(i, '00') + ".Format = '#,##0' "
//
//ll_width1 = ll_width1 + ll_width
//
//// 출고 TEXT SETTING
//ls_modify = ls_modify + "out_qty_t.Text = '출      고' " + &
//								"out_qty_t.Visible = True " + &
//                        "out_qty_t.X = " + String(ll_x1) + &
//                        "out_qty_t.Y = " + String(ll_y1) + &
//                        "out_qty_t.Width = " + String(ll_width1) + &
//                        "out_qty_t.Height = " + String(ll_height)
//
//ll_x1 = ll_x1 + ll_width1 + 18
//ll_width1 = 0
//
//// 판매 SIZE SETTING
//For j = 1 + i To il_size_cnt + i
//	ll_x = ll_x + ll_width + 18
//	ll_width = 256
//	ls_modify = ls_modify + "column_" + String(j, '00') + "_t.Text = '" + dw_shop_item_size_temp2.GetItemString(j - i, "size") + "~(" + dw_shop_item_size_temp2.GetItemString(j - i, "size_nm") + "~)' " + &
//	                        "column_" + String(j, '00') + "_t.Visible = True " + &
//	                        "column_" + String(j, '00') + "_t.X = " + String(ll_x) + &
//	                        "column_" + String(j, '00') + "_t.Y = " + String(ll_y) + &
//	                        "column_" + String(j, '00') + "_t.Width = " + String(ll_width) + &
//	                        "column_" + String(j, '00') + "_t.Height = " + String(ll_height) + &
//	                        "column_" + String(j, '00') + ".Visible = True " + &
//	                        "column_" + String(j, '00') + ".X = " + String(ll_x) + &
//	                        "column_" + String(j, '00') + ".Y = " + String(ll_y_col) + &
//	                        "column_" + String(j, '00') + ".Width = " + String(ll_width) + &
//	                        "column_" + String(j, '00') + ".Height = " + String(ll_height) + &
//	                        "column_" + String(j, '00') + ".Format = '#,##0' "
//
//	ll_width1 = ll_width1 + ll_width + 18
//Next
//
//// 판매 계 SETTING
//ll_x      = ll_x + ll_width + 18
//ll_width  = 256
//ls_modify = ls_modify + "column_" + String(j, '00') + "_t.Text = '계' " + &
//								"column_" + String(j, '00') + "_t.Visible = True " + &
//								"column_" + String(j, '00') + "_t.X = " + String(ll_x) + &
//								"column_" + String(j, '00') + "_t.Y = " + String(ll_y) + &
//								"column_" + String(j, '00') + "_t.Width = " + String(ll_width) + &
//								"column_" + String(j, '00') + "_t.Height = " + String(ll_height) + &
//								"column_" + String(j, '00') + ".Visible = True " + &
//								"column_" + String(j, '00') + ".X = " + String(ll_x) + &
//								"column_" + String(j, '00') + ".Y = " + String(ll_y_col) + &
//								"column_" + String(j, '00') + ".Width = " + String(ll_width) + &
//								"column_" + String(j, '00') + ".Height = " + String(ll_height) + &
//                        "column_" + String(j, '00') + ".Format = '#,##0' "
//
//ll_width1 = ll_width1 + ll_width
//
//// 판매 TEXT SETTING
//ls_modify = ls_modify + "sale_qty_t.Text = '판      매' " + &
//								"sale_qty_t.Visible = True " + &
//                        "sale_qty_t.X = " + String(ll_x1) + &
//                        "sale_qty_t.Y = " + String(ll_y1) + &
//                        "sale_qty_t.Width = " + String(ll_width1) + &
//                        "sale_qty_t.Height = " + String(ll_height)
//
//ll_x1 = ll_x1 + ll_width1 + 18
//ll_width1 = 0
//
//// 판매비 SIZE SETTING
//For k = 1 + j To il_size_cnt + j
//	ll_x = ll_x + ll_width + 18
//	ll_width = 256
//	ls_modify = ls_modify + "column_" + String(k, '00') + "_t.Text = '" + dw_shop_item_size_temp2.GetItemString(k - j, "size") + "~(" + dw_shop_item_size_temp2.GetItemString(k - j, "size_nm") + "~)' " + &
//	                        "column_" + String(k, '00') + "_t.Visible = True " + &
//	                        "column_" + String(k, '00') + "_t.X = " + String(ll_x) + &
//	                        "column_" + String(k, '00') + "_t.Y = " + String(ll_y) + &
//	                        "column_" + String(k, '00') + "_t.Width = " + String(ll_width) + &
//	                        "column_" + String(k, '00') + "_t.Height = " + String(ll_height) + &
//	                        "column_" + String(k, '00') + ".Visible = True " + &
//	                        "column_" + String(k, '00') + ".X = " + String(ll_x) + &
//	                        "column_" + String(k, '00') + ".Y = " + String(ll_y_col) + &
//	                        "column_" + String(k, '00') + ".Width = " + String(ll_width) + &
//	                        "column_" + String(k, '00') + ".Height = " + String(ll_height) + &
//	                        "column_" + String(k, '00') + ".Format = '0.00%' "
//
//	ll_width1 = ll_width1 + ll_width + 18
//Next
//
//// 판매비 TEXT SETTING
//ll_width1 = ll_width1 - 18
//
//ls_modify = ls_modify + "sale_per_t.Text = '판  매  비' " + &
//								"sale_per_t.Visible = True " + &
//                        "sale_per_t.X = " + String(ll_x1) + &
//                        "sale_per_t.Y = " + String(ll_y1) + &
//                        "sale_per_t.Width = " + String(ll_width1) + &
//                        "sale_per_t.Height = " + String(ll_height)
//
//ll_x1 = ll_x1 + ll_width1 + 18
//ll_width1 = 0
//
//// 재고 SETTING
//ll_x      = ll_x + ll_width + 18
//ll_width  = 256
//ll_width1 = ll_width1 + ll_width
//ls_modify = ls_modify + "column_" + String(k, '00') + "_t.Text = '~n~r재  고' " + &
//								"column_" + String(k, '00') + "_t.Visible = True " + &
//								"column_" + String(k, '00') + "_t.X = " + String(ll_x1) + &
//								"column_" + String(k, '00') + "_t.Y = " + String(ll_y1) + &
//								"column_" + String(k, '00') + "_t.Width = " + String(ll_width1) + &
//								"column_" + String(k, '00') + "_t.Height = " + String(ll_height1) + &
//								"column_" + String(k, '00') + ".Visible = True " + &
//								"column_" + String(k, '00') + ".X = " + String(ll_x1) + &
//								"column_" + String(k, '00') + ".Y = " + String(ll_y_col) + &
//								"column_" + String(k, '00') + ".Width = " + String(ll_width1) + &
//								"column_" + String(k, '00') + ".Height = " + String(ll_height) + &
//                        "column_" + String(k, '00') + ".Format = '#,##0' "
//
//ll_x1 = ll_x1 + ll_width1 + 18
//ll_width1 = 0
//
//// 판매율 SETTING
//k++
//ll_x      = ll_x + ll_width + 18
//ll_width  = 256
//ll_width1 = ll_width1 + ll_width
//ls_modify = ls_modify + "column_" + String(k, '00') + "_t.Text = '~n~r판매율' " + &
//								"column_" + String(k, '00') + "_t.Visible = True " + &
//								"column_" + String(k, '00') + "_t.X = " + String(ll_x1) + &
//								"column_" + String(k, '00') + "_t.Y = " + String(ll_y1) + &
//								"column_" + String(k, '00') + "_t.Width = " + String(ll_width1) + &
//								"column_" + String(k, '00') + "_t.Height = " + String(ll_height1) + &
//								"column_" + String(k, '00') + ".Visible = True " + &
//								"column_" + String(k, '00') + ".X = " + String(ll_x1) + &
//								"column_" + String(k, '00') + ".Y = " + String(ll_y_col) + &
//								"column_" + String(k, '00') + ".Width = " + String(ll_width1) + &
//								"column_" + String(k, '00') + ".Height = " + String(ll_height) + &
//                        "column_" + String(k, '00') + ".Format = '0.00%' "
//
//ll_x1 = ll_x1 + ll_width1 + 18
//ll_width1 = 0
//
//// dw_print LINE 정렬
//If adw_dw.DataObject = 'd_55006_r03' Then
//	ll_line_width = Long(adw_dw.Describe("l_2.X2")) - Long(adw_dw.Describe("l_2.X1"))
//	ls_modify = ls_modify + "t_title.Width = " + String(ll_x1) + &
//									"l_1.X2 = " + String(ll_x1) + &
//									"l_4.X2 = " + String(ll_x1) + &
//									"l_5.X2 = " + String(ll_x1) + &
//									"l_6.X2 = " + String(ll_x1) + &
//									"l_2.X1 = " + String( (ll_x1 / 2) - ( ll_line_width / 2 ) ) + &
//									"l_2.X2 = " + String( (ll_x1 / 2) - ( ll_line_width / 2 ) + ll_line_width ) + &
//									"l_3.X1 = " + String( (ll_x1 / 2) - ( ll_line_width / 2 ) ) + &
//									"l_3.X2 = " + String( (ll_x1 / 2) - ( ll_line_width / 2 ) + ll_line_width ) + &
//									"t_10.X = " + String( (ll_x1 / 2) - (Long(adw_dw.Describe("t_10.Width")) / 2) ) + &
//									"t_11.X = " + String( (ll_x1 / 2) - (Long(adw_dw.Describe("t_10.Width")) / 2) ) + &
//									"t_pg_id.X = " + String( ll_x1 - ( Long(adw_dw.Describe("t_title.Width")) - Long(adw_dw.Describe("t_pg_id.X")) ) ) + &
//									"t_7.X = " + String( ll_x1 - ( Long(adw_dw.Describe("t_title.Width")) - Long(adw_dw.Describe("t_pg_id.X")) ) ) + &
//									"compute_7.X = " + String( ll_x1 - ( Long(adw_dw.Describe("t_title.Width")) - Long(adw_dw.Describe("compute_7.X")) ) ) + &
//									"t_user_id.X = " + String( ll_x1 - ( Long(adw_dw.Describe("t_title.Width")) - Long(adw_dw.Describe("t_user_id.X")) ) ) + &
//									"t_15.X = " + String( ll_x1 - ( Long(adw_dw.Describe("t_title.Width")) - Long(adw_dw.Describe("t_15.X")) ) ) + &
//									"t_datetime.X = " + String( ll_x1 - ( Long(adw_dw.Describe("t_title.Width")) - Long(adw_dw.Describe("t_datetime.X")) ) )
//End If
//
//adw_dw.Modify(ls_modify)
//
end subroutine

on w_55006_d.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_shop_item_color_size=create dw_shop_item_color_size
this.dw_shop_item_color_size_temp=create dw_shop_item_color_size_temp
this.dw_shop_style=create dw_shop_style
this.dw_style_shop=create dw_style_shop
this.dw_shop_item_size_temp2=create dw_shop_item_size_temp2
this.dw_shop_item_size=create dw_shop_item_size
this.dw_shop_item=create dw_shop_item
this.dw_shop_color=create dw_shop_color
this.dw_shop_item_color=create dw_shop_item_color
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_shop_item_color_size
this.Control[iCurrent+3]=this.dw_shop_item_color_size_temp
this.Control[iCurrent+4]=this.dw_shop_style
this.Control[iCurrent+5]=this.dw_style_shop
this.Control[iCurrent+6]=this.dw_shop_item_size_temp2
this.Control[iCurrent+7]=this.dw_shop_item_size
this.Control[iCurrent+8]=this.dw_shop_item
this.Control[iCurrent+9]=this.dw_shop_color
this.Control[iCurrent+10]=this.dw_shop_item_color
end on

on w_55006_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_shop_item_color_size)
destroy(this.dw_shop_item_color_size_temp)
destroy(this.dw_shop_style)
destroy(this.dw_style_shop)
destroy(this.dw_shop_item_size_temp2)
destroy(this.dw_shop_item_size)
destroy(this.dw_shop_item)
destroy(this.dw_shop_color)
destroy(this.dw_shop_item_color)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.28                                                  */	
/* 수정일      : 2002.01.28                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_style_no
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		is_brand = dw_head.GetItemString(1, "brand")
		IF ai_div = 1 THEN 	
			If IsNull(as_data) or Trim(as_data) = "" Then
				dw_head.SetItem(al_row, "shop_nm", "")
				RETURN 0
			END IF 
				
			IF LeftA(as_data, 1) = is_brand And gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' " + &
		                         "  AND SHOP_STAT = '00' "		
										 
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
			dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
			/* 다음컬럼으로 이동 */
			dw_head.SetColumn("style_no")
			ib_itemchanged = False 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		Destroy  lds_Source
	CASE "style_no"
		IF ai_div = 1 THEN
			If IsNull(as_data) or Trim(as_data) = "" Then
				dw_head.SetItem(al_row, "color", "")
				idw_color.ReSet()
				idw_color.InsertRow(1)
				idw_color.SetItem(1, "color", '%')
				idw_color.SetItem(1, "color_enm", '전체')
				dw_head.SetItem(al_row, "size", "")
				idw_size.ReSet()
				idw_size.InsertRow(1)
				idw_size.SetItem(1, "size", '%')
				idw_size.SetItem(1, "size_nm", '전체')
				RETURN 0
			END IF 
				
			If LenA(as_data) = 8 Then 
				if gs_brand <> 'K' then
					IF gf_style_chk(as_data, '%') = True THEN 
						dw_head.SetItem(1, "color", "")
						idw_color.Retrieve(as_data, '%')
						idw_color.InsertRow(1)
						idw_color.SetItem(1, "color", '%')
						idw_color.SetItem(1, "color_enm", '전체')
						dw_head.SetItem(1, "size", "")
						idw_size.ReSet()
						idw_size.InsertRow(1)
						idw_size.SetItem(1, "size", '%')
						idw_size.SetItem(1, "size_nm", '전체')
						RETURN 0
					End If
				end if
			Else
				if gs_brand <> 'K' then
					IF gf_style_chk(LeftA(as_data, 8), MidA(as_data, 9, 1)) = True THEN 
						dw_head.SetItem(1, "color", "")
						idw_color.Retrieve(LeftA(as_data, 8), MidA(as_data, 9, 1))
						idw_color.SetItem(1, "color", '%')
						idw_color.SetItem(1, "color_enm", '전체')
						dw_head.SetItem(1, "size", "")
						idw_size.ReSet()
						idw_size.InsertRow(1)
						idw_size.SetItem(1, "size", '%')
						idw_size.SetItem(1, "size_nm", '전체')
						RETURN 0
					End If
				end if
			End If
		END IF
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com010" 
		gst_cd.default_where   = ""		// WHERE Style = '00' 
		if gs_brand <> 'K' then
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " STYLE LIKE '" + LeftA(as_data, 8) + "%' AND CHNO LIKE '" + MidA(as_data, 9, 1) + "%' "
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
			ls_style_no = lds_Source.GetItemString(1,"style_no")
			dw_head.SetItem(al_row, "style_no", ls_style_no)
			dw_head.SetItem(1, "color", "")
			idw_color.Retrieve(LeftA(ls_style_no, 8), MidA(ls_style_no, 9, 1))
			idw_color.SetItem(1, "color", '%')
			idw_color.SetItem(1, "color_enm", '전체')
			dw_head.SetItem(1, "size", "")
			idw_size.ReSet()
			idw_size.InsertRow(1)
			idw_size.SetItem(1, "size", '%')
			idw_size.SetItem(1, "size_nm", '전체')
			/* 다음컬럼으로 이동 */
			dw_head.SetColumn("style_no")
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

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.28                                                  */	
/* 수정일      : 2002.01.28                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

Choose Case ii_tab_chk
	Case 1
		il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, &
											is_shop_type, is_style, is_chno, is_color, is_size,is_st_brand)
		IF il_rows > 0 THEN
			ib_tab1_chk = True
			dw_body.SetFocus()
		End If
	Case 2
		il_rows = dw_shop_item.retrieve(is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, &
												  is_shop_type, is_style, is_chno, is_color, is_size, is_st_brand)
		IF il_rows > 0 THEN
			ib_tab2_chk = True
			dw_shop_item.SetFocus()
		End If
	Case 3
//		dw_shop_item_size.dataobject = "d_55006_d03"
//		dw_shop_item_size.SetTransObject(SQLCA)
//
   	dw_shop_item_size.ReSet()
//		wf_shop_item_color_size_Destroy(dw_shop_item_size)
		il_rows = dw_shop_item_size.retrieve(is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, &
																is_shop_type, is_style, is_chno, is_color, is_size, is_st_brand)
		IF il_rows > 0 THEN
			dw_shop_item_size.SETREDRAW(FALSE)
			ib_tab3_chk = True
			wf_shop_item_size_set(dw_shop_item_size)
			dw_shop_item_size.SetFocus()
			dw_shop_item_size.SETREDRAW(true)
			
		End If
	Case 5
		il_rows = dw_shop_color.retrieve(is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, &
													is_shop_type, is_style, is_chno, is_color, is_size, is_st_brand)
		IF il_rows > 0 THEN
			ib_tab4_chk = True
			dw_shop_color.SetFocus()
		End If
		
	Case 6
		il_rows = dw_shop_item_color.retrieve(is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, &
													is_shop_type, is_style, is_chno, is_color, is_size, is_st_brand)
		IF il_rows > 0 THEN
			ib_tab4_chk = True
			dw_shop_item_color.SetFocus()
		End If		
//	Case 5
//		il_rows = dw_style_shop.retrieve(is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, &
//													is_shop_type, is_style, is_chno, is_color, is_size)
//		IF il_rows > 0 THEN
//			ib_tab5_chk = True
//			dw_style_shop.SetFocus()
//		End If
//	Case 6
//		dw_shop_item_color_size.ReSet( )
//   	wf_shop_item_color_size_Destroy(dw_shop_item_color_size)																		
//		il_rows = dw_shop_item_color_size_temp.retrieve(is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, &
//																is_shop_type, is_style, is_chno, is_color, is_size)
//		IF il_rows > 0 THEN
//			ib_tab6_chk = True
//			wf_shop_item_color_size_set(dw_shop_item_color_size)
//			dw_shop_item_color_size.SetFocus()
//		End If
End Choose

IF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSEIF il_rows < 0 Then
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.28                                                  */	
/* 수정일      : 2002.01.28                                                  */
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


is_st_brand = dw_head.GetItemString(1, "st_brand")
if IsNull(is_st_brand) or Trim(is_st_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("st_brand")
   return false
end if



//if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
//   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false	
//elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false		
//elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false			
//end if	




if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_yymmdd = String(dw_head.GetItemDatetime(1, "yymmdd"), 'yyyymmdd')
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재 유형을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"복종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = '%'
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

ls_style_no = dw_head.GetItemString(1, "style_no")
if IsNull(ls_style_no) or Trim(ls_style_no) = "" then
	is_style = '%'
	is_chno = '%'
ElseIf LenA(ls_style_no) = 8 Then
	is_style = ls_style_no
	is_chno = '%'
Else
	is_style = LeftA(ls_style_no, 8)
	is_chno = MidA(ls_style_no, 9, 1)
end if

is_color = dw_head.GetItemString(1, "color")
if IsNull(is_color) or Trim(is_color) = "" then
   MessageBox(ls_title,"색상 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("color")
   return false
end if

is_size = dw_head.GetItemString(1, "size")
if IsNull(is_size) or Trim(is_size) = "" then
   MessageBox(ls_title,"사이즈 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("size")
   return false
end if

return true

end event

event pfc_preopen();call super::pfc_preopen;/* Data window Resize */
inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_shop_item, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_shop_item_size, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_shop_item_color_size, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_shop_style, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_style_shop, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_shop_color, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_shop_item_color, "ScaleToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_shop_item.SetTransObject(SQLCA)
dw_shop_item_size.SetTransObject(SQLCA)
//dw_shop_item_size_temp.SetTransObject(SQLCA)
dw_shop_item_color_size.SetTransObject(SQLCA)
dw_shop_item_color_size_temp.SetTransObject(SQLCA)
dw_shop_item_size_temp2.SetTransObject(SQLCA)
dw_shop_style.SetTransObject(SQLCA)
dw_style_shop.SetTransObject(SQLCA)
dw_shop_color.SetTransObject(SQLCA)
dw_shop_item_color.SetTransObject(SQLCA)

end event

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.29                                                  */	
/* 수정일      : 2002.01.29                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         tab_1.Enabled = true
         dw_body.Enabled = true
         dw_shop_item.Enabled = true
         dw_shop_item_size.Enabled = true
         dw_shop_style.Enabled = true
         dw_style_shop.Enabled = true
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
		tab_1.Enabled = false
      dw_body.Enabled = false
		dw_shop_item.Enabled = false
		dw_shop_item_size.Enabled = false
		dw_shop_style.Enabled = false
		dw_style_shop.Enabled = false
		ib_tab1_chk = False
		ib_tab2_chk = False
		ib_tab3_chk = False
		ib_tab4_chk = False
		ib_tab5_chk = False
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.01.30                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm, ls_shop_type_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_shop_cd = '%' Then
	ls_shop_nm = '전체'
Else
	ls_shop_nm = dw_head.GetItemString(1, "shop_nm")
End If

If is_shop_type = '1' Then
	ls_shop_type_nm = '정   상'
Else
	ls_shop_type_nm = '정상 + 기획'
End If

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_year.Text = '" + is_year + "'" + &
            "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_yymmdd.Text = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_sojae.Text = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_display") + "'" + &
            "t_item.Text = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'" + &
            "t_shop_cd.Text = '" + is_shop_cd + ' ' + ls_shop_nm + "'" + &
            "t_shop_type.Text = '" + ls_shop_type_nm + "'" + &
            "t_style_no.Text = '" + is_style + "~-" + is_chno + "'" + &
            "t_color.Text = '" + idw_color.GetItemString(idw_color.GetRow(), "color_display") + "'" + &
            "t_size.Text = '" + idw_size.GetItemString(idw_size.GetRow(), "size_display") + "'"

dw_print.Modify(ls_modify)

end event

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

Choose Case ii_tab_chk
	Case 1
		dw_print.DataObject = 'd_55006_r01'
		dw_print.SetTransObject(SQLCA)
		dw_body.ShareData(dw_print)
	Case 2
		dw_print.DataObject = 'd_55006_r02'
		dw_print.SetTransObject(SQLCA)
		dw_shop_item.ShareData(dw_print)
	Case 3
		dw_print.DataObject = 'd_55006_r03'
		dw_print.SetTransObject(SQLCA)
	//	wf_shop_item_size_head(dw_print)
		dw_shop_item_size.ShareData(dw_print)
//	Case 4
//		dw_print.DataObject = 'd_55006_r04'
//		dw_print.SetTransObject(SQLCA)
//		dw_shop_style.ShareData(dw_print)
	Case 5
		dw_print.DataObject = 'd_55006_r11'
		dw_print.SetTransObject(SQLCA)
		dw_shop_color.ShareData(dw_print)
	Case 6
		dw_print.DataObject = 'd_55006_r12'
		dw_print.SetTransObject(SQLCA)
		dw_shop_item_color.ShareData(dw_print)

End Choose

This.Trigger Event ue_title ()

dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

Choose Case ii_tab_chk
	Case 1
		dw_print.DataObject = 'd_55006_r01'
		dw_print.SetTransObject(SQLCA)
		dw_body.ShareData(dw_print)
	Case 2
		dw_print.DataObject = 'd_55006_r02'
		dw_print.SetTransObject(SQLCA)
		dw_shop_item.ShareData(dw_print)
	Case 3
		dw_print.DataObject = 'd_55006_r03'
		dw_print.SetTransObject(SQLCA)
		dw_shop_item_size.ShareData(dw_print)
//	Case 4
//		dw_print.DataObject = 'd_55006_r04'
//		dw_print.SetTransObject(SQLCA)
//		dw_shop_style.ShareData(dw_print)
	Case 5
		dw_print.DataObject = 'd_55006_r11'
		dw_print.SetTransObject(SQLCA)
		dw_style_shop.ShareData(dw_print)
		
	Case 6
		dw_print.DataObject = 'd_55006_r12'
		dw_print.SetTransObject(SQLCA)
		dw_style_shop.ShareData(dw_print)		
End Choose

This.Trigger Event ue_title()

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_excel;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)
Choose Case ii_tab_chk
	Case 1
		li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 2
		li_ret = dw_SHOP_ITEM.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 3
		li_ret = dw_SHOP_ITEM_SIZE.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 5
		li_ret = dw_SHOP_color.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 6
		li_ret = dw_SHOP_ITEM_color.SaveAs(ls_doc_nm, Excel!, TRUE)		
End Choose



if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55006_d","0")
end event

event open;call super::open;dw_head.SetItem(1, "st_brand", "%")

ii_tab_chk = 1
end event

type cb_close from w_com010_d`cb_close within w_55006_d
integer taborder = 190
end type

type cb_delete from w_com010_d`cb_delete within w_55006_d
integer taborder = 140
end type

type cb_insert from w_com010_d`cb_insert within w_55006_d
integer taborder = 120
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55006_d
integer taborder = 80
end type

type cb_update from w_com010_d`cb_update within w_55006_d
integer taborder = 180
end type

type cb_print from w_com010_d`cb_print within w_55006_d
integer taborder = 150
end type

type cb_preview from w_com010_d`cb_preview within w_55006_d
integer taborder = 160
end type

type gb_button from w_com010_d`gb_button within w_55006_d
end type

type cb_excel from w_com010_d`cb_excel within w_55006_d
integer taborder = 170
end type

type dw_head from w_com010_d`dw_head within w_55006_d
integer width = 3552
integer height = 412
string dataobject = "d_55006_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("st_brand", idw_st_brand)
idw_st_brand.SetTransObject(SQLCA)
idw_st_brand.Retrieve('001')
idw_st_brand.InsertRow(1)
idw_st_brand.SetItem(1, "inter_cd", '%')
idw_st_brand.SetItem(1, "inter_nm", '전체')


This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.retrieve('%')
idw_color.InsertRow(1)
idw_color.SetItem(1, "color", '%')
idw_color.SetItem(1, "color_enm", '전체')

This.GetChild("size", idw_size)
idw_size.SetTransObject(SQLCA)
idw_size.retrieve('%')
idw_size.InsertRow(1)
idw_size.SetItem(1, "size", '%')
idw_size.SetItem(1, "size_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.28                                                  */	
/* 수정일      : 2002.01.28                                                  */
/*===========================================================================*/
String ls_style_no
String ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name
		
		
 CASE "brand"
	IF ib_itemchanged THEN RETURN 1
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
		
	  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")		
		
//	CASE "color"
//		ls_style_no = dw_head.GetItemString(1, "style_no")
//		If Len(ls_style_no) = 8 Then
//			This.SetItem(1, "size", "")
//			idw_size.Retrieve(ls_style_no, '%', data)
//			idw_size.InsertRow(1)
//			idw_size.SetItem(1, "size", '%')
//			idw_size.SetItem(1, "size_nm", '전체')
//		ElseIf Len(ls_style_no) = 9 Then
//			This.SetItem(1, "size", "")
//			idw_size.Retrieve(Left(ls_style_no, 8), Mid(ls_style_no, 9, 1), data)
//			idw_size.InsertRow(1)
//			idw_size.SetItem(1, "size", '%')
//			idw_size.SetItem(1, "size_nm", '전체')
//		End If
		
	CASE "shop_cd", "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE



end event

type ln_1 from w_com010_d`ln_1 within w_55006_d
integer beginy = 616
integer endy = 616
end type

type ln_2 from w_com010_d`ln_2 within w_55006_d
integer beginy = 620
integer endy = 620
end type

type dw_body from w_com010_d`dw_body within w_55006_d
integer x = 18
integer y = 732
integer width = 3579
integer height = 1312
integer taborder = 110
string dataobject = "d_55006_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_55006_d
integer x = 2112
integer y = 664
string dataobject = "d_55006_r11"
end type

type tab_1 from tab within w_55006_d
integer y = 628
integer width = 3616
integer height = 1432
integer taborder = 90
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
end on

event selectionchanged;ii_tab_chk = newindex

Choose Case newindex
	Case 1
		dw_body.Visible = True
		dw_shop_item.Visible = False
		dw_shop_item_size.Visible = False
		dw_shop_item_color.Visible = false				
		dw_shop_color.Visible = false
		dw_shop_style.Visible = False
		dw_style_shop.Visible = False
//		If oldindex <> -1  and ib_tab1_chk = False Then
//			dw_body.Retrieve(is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, &
//								  is_shop_type, is_style, is_chno, is_color, is_size)
//			ib_tab1_chk = True
//		End If
	Case 2
		dw_body.Visible = False
		dw_shop_item.Visible = True
		dw_shop_item_size.Visible = False
		dw_shop_item_color.Visible = false				
		dw_shop_color.Visible = false		
		dw_shop_style.Visible = False
		dw_style_shop.Visible = False
//		If oldindex <> -1  and ib_tab2_chk = False Then
//			dw_shop_item.Retrieve(is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, &
//										 is_shop_type, is_style, is_chno, is_color, is_size)
//			ib_tab2_chk = True
//		End If
	Case 3
		dw_body.Visible = False
		dw_shop_item.Visible = False
		dw_shop_item_size.Visible = True
		dw_shop_item_color.Visible = false				
		dw_shop_color.Visible = false		
		dw_shop_style.Visible = False
		dw_style_shop.Visible = False
		
	Case 5
		dw_body.Visible = False
		dw_shop_item.Visible = False
		dw_shop_item_size.Visible = false
		dw_shop_color.Visible = true
		dw_shop_item_color.Visible = false				
		dw_shop_style.Visible = False
		dw_style_shop.Visible = False		
		
	Case 6
		dw_body.Visible = False
		dw_shop_item.Visible = False
		dw_shop_item_size.Visible = false
		dw_shop_color.Visible = false
		dw_shop_item_color.Visible = true		
		dw_shop_style.Visible = False
		dw_style_shop.Visible = False		
		
//		If oldindex <> -1  and ib_tab3_chk = False Then
//			dw_shop_item_size.ReSet()
//			il_rows = dw_shop_item_size_temp.Retrieve(is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, &
//																	is_shop_type, is_style, is_chno, is_color, is_size)
//			IF il_rows > 0 THEN
//				wf_shop_item_size_set(dw_shop_item_size)
//			End If
//			ib_tab3_chk = True
//		End IF
//	Case 4
//		dw_body.Visible = False
//		dw_shop_item.Visible = False
//		dw_shop_item_size.Visible = False
//		dw_shop_style.Visible = True
//		dw_style_shop.Visible = False
////		If oldindex <> -1  and ib_tab4_chk = False Then
////			dw_shop_style.Retrieve(is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, &
////										  is_shop_type, is_style, is_chno, is_color, is_size)
////			ib_tab4_chk = True
////		End If
//	Case 5
//		dw_body.Visible = False
//		dw_shop_item.Visible = False
//		dw_shop_item_size.Visible = False
//		dw_shop_style.Visible = False
//		dw_style_shop.Visible = True
////		If oldindex <> -1  and ib_tab5_chk = False Then
////			dw_style_shop.Retrieve(is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, &
////										  is_shop_type, is_style, is_chno, is_color, is_size)
////			ib_tab5_chk = True
////		End If
//	Case 6
//		dw_body.Visible = False
//		dw_shop_item.Visible = False
//		dw_shop_item_size.Visible = false
//		dw_shop_item_color_size.Visible = true		
//		dw_shop_style.Visible = False
//		dw_style_shop.Visible = False
////		If oldindex <> -1  and ib_tab3_chk = False Then
////			dw_shop_item_size.ReSet()
////			il_rows = dw_shop_item_color_size_temp.Retrieve(is_brand, is_year, is_season, is_yymmdd, is_sojae, is_item, is_shop_cd, &
////																	is_shop_type, is_style, is_chno, is_color, is_size)
////			IF il_rows > 0 THEN
////				wf_shop_item_color_size_set(dw_shop_item_color_size)
////			End If
////			ib_tab6_chk = True
////		End IF
End Choose

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3579
integer height = 1320
long backcolor = 79741120
string text = "매장별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3579
integer height = 1320
long backcolor = 79741120
string text = "매장/복종별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3579
integer height = 1320
long backcolor = 79741120
string text = "매장/복종/사이즈별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_4 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 96
integer width = 3579
integer height = 1320
long backcolor = 79741120
string text = "매장/칼라별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3579
integer height = 1320
long backcolor = 79741120
string text = "매장/칼라별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3579
integer height = 1320
long backcolor = 79741120
string text = "매장/복종/칼라별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type dw_shop_item_color_size from u_dw within w_55006_d
boolean visible = false
integer x = 37
integer y = 752
integer width = 3552
integer height = 1284
integer taborder = 130
boolean bringtotop = true
string dataobject = "d_55006_d09"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_shop_item_color_size_temp from u_dw within w_55006_d
boolean visible = false
integer x = 1120
integer y = 996
integer width = 1381
integer height = 776
integer taborder = 100
boolean bringtotop = true
string dataobject = "d_55006_d08"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_shop_style from u_dw within w_55006_d
boolean visible = false
integer x = 32
integer y = 752
integer width = 3552
integer height = 1284
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_55006_d04"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_style_shop from u_dw within w_55006_d
boolean visible = false
integer x = 32
integer y = 752
integer width = 3552
integer height = 1284
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_55006_d05"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_shop_item_size_temp2 from u_dw within w_55006_d
boolean visible = false
integer x = 2002
integer y = 996
integer width = 1376
integer height = 720
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_55006_d07"
end type

type dw_shop_item_size from u_dw within w_55006_d
boolean visible = false
integer x = 23
integer y = 740
integer width = 3570
integer height = 1284
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_55006_d03"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_shop_item from u_dw within w_55006_d
boolean visible = false
integer x = 18
integer y = 740
integer width = 3575
integer height = 1296
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_55006_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_shop_color from u_dw within w_55006_d
boolean visible = false
integer x = 18
integer y = 740
integer width = 3570
integer height = 1284
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_55006_d11"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_shop_item_color from u_dw within w_55006_d
boolean visible = false
integer x = 14
integer y = 732
integer width = 3575
integer height = 1304
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_55006_d12"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

