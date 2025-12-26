$PBExportHeader$w_52018_d.srw
$PBExportComments$배분표 조회
forward
global type w_52018_d from w_com020_d
end type
type dw_assort from datawindow within w_52018_d
end type
type dw_db from datawindow within w_52018_d
end type
end forward

global type w_52018_d from w_com020_d
dw_assort dw_assort
dw_db dw_db
end type
global w_52018_d w_52018_d

type variables
DataWindowChild  idw_brand, idw_deal_fg 
String is_brand, is_yymmdd, is_deal_fg
String is_style, is_chno
Long   il_fr_deal_seq, il_to_deal_seq 

end variables

forward prototypes
public function boolean wf_body_set ()
public function boolean wf_print_dwset ()
public subroutine wf_retrieve_set ()
end prototypes

public function boolean wf_body_set ();Long   i, k, ll_row_cnt, ll_x
String ls_sql,    ls_dw_syntax, ls_dw_style, ls_errors
String ls_col_nm, ls_modify, ls_rowtot
String ls_color

ll_row_cnt = dw_assort.RowCount() 
IF ll_row_cnt < 1 THEN RETURN FALSE

dw_body.DataObject = ''

ls_dw_style = 'style(Type=tabular ) ' + & 
              'datawindow(color=10789024 ) ' + &
				  '  Text(border=6 background.mode=2 background.color=79741120 font.face="굴림체"  font.Height=-9  font.weight=400 font.family=1 font.pitch=1 font.charset=129) ' + &
				  'Column(border=0 background.mode=2 background.color=79741120 font.face="굴림체"  font.Height=-9  font.weight=400 font.family=2 font.pitch=2 font.charset=129) ' 

/* SQL문장 생성 */
ls_sql = "select '123456'  as shop_cd, '12345678901234567890'  as shop_nm, 0  as stock_qty "
FOR i = 1 TO ll_row_cnt 
	ls_sql = ls_sql + ", 0 as deal_qty" + String(i)
NEXT
ls_sql = ls_sql + " from dual "
/* DataWindow문장 생성 */
ls_dw_syntax = SQLCA.SyntaxFromSQL(ls_sql, ls_dw_style, ls_errors)
IF LenA(ls_errors) > 0 THEN
	MessageBox("화면생성 오류", ls_errors)
	RETURN False
END IF 
/* DataWindow 생성 */ 
dw_body.SetRedraw(False)
If dw_body.Create(ls_dw_syntax, ls_errors) > 0 Then 
	ls_modify = 'datawindow.header.Height=140 ' + &
	            'datawindow.footer.Height=68  ' + & 
	            'datawindow.detail.Height=68  ' + & 
		         'shop_cd.x="5" shop_cd.y="0" shop_cd.height="64" shop_cd.width="192" ' + & 
		         'shop_cd_t.x="10" shop_cd_t.y="8" shop_cd_t.height="124" shop_cd_t.width="187" shop_cd_t.text = "~~r~~n매장" ' + & 
		         'shop_nm.x="206" shop_nm.y="0" shop_nm.height="64" shop_nm.width="466" ' + & 
		         'shop_nm_t.x="215" shop_nm_t.y="8" shop_nm_t.height="124" shop_nm_t.width="457" shop_nm_t.text = "~~r~~n매장명칭" ' + &
		         'stock_qty.x="681" stock_qty.y="0" stock_qty.height="64" stock_qty.width="183" ' + & 
		         'stock_qty_t.x="690" stock_qty_t.y="8" stock_qty_t.height="124" stock_qty_t.width="174" stock_qty_t.text = "~~r~~n재고" ' + &
               'create text(band=footer alignment="2" text="합계" border="6" color="0" ' + &
                            'x="5" y="0" height="64" ' + 'width="663"' + 'name=t_total ' + &
									 'font.face="굴림체" font.height="-9" font.weight="400" font.family="1" ' + &
					             'font.pitch="1" font.charset="129" background.mode="2" background.color="79741120") ' + & 
               'create compute(band=footer alignment="1" expression="sum(stock_qty for all)" border="0" color="0" ' + &
					             'x="681" y="0" height="64" width="183" format="#,###" name=c_stock_tot ' + &
					             'font.face="굴림체" font.height="-9" font.weight="400" font.family="1" ' + &
					             'font.pitch="1" font.charset="129" background.mode="2" background.color="79741120") ' 
	dw_body.Modify(ls_modify)
   /* 칼럼별 정의 */
	ll_x = 873
	k    = 0 
	ls_color = dw_assort.object.color[1]
   FOR i = 1 TO ll_row_cnt 
		ls_col_nm = "deal_qty" + String(i)
		IF i = 1 THEN 
         ls_rowtot = "if(isnull(" + ls_col_nm + ") , 0," +  ls_col_nm + ") "
		ELSE
		   ls_rowtot = ls_rowtot + " + " + "if(isnull(" + ls_col_nm + ") , 0," +  ls_col_nm + ") "
		END IF 
		ls_modify = ls_col_nm + '.x="' + String(ll_x) + '" ' + &
		            ls_col_nm + '.y="0" ' + &
		            ls_col_nm + '.height="64" ' + &
		            ls_col_nm + '.width="183" ' + & 
		            ls_col_nm + '.format="#,##" ' + &
		            ls_col_nm + "_t" + '.Text="' + dw_assort.object.size[i] + '" ' + &
		            ls_col_nm + "_t" + '.x="' + String(ll_x + 9) + '" ' + &
		            ls_col_nm + "_t" + '.y="74" ' + &
		            ls_col_nm + "_t" + '.height="56" ' + &
		            ls_col_nm + "_t" + '.width="174" ' + &
                  ' create compute(band=footer alignment="1" expression="sum(' + ls_col_nm + ' for all)"' + &
					   ' border="0" color="0" x="' + String(ll_x) + '" y="0" height="64" width="183" format="#,###" name=c_tot' + String(i) + &
					   ' font.face="굴림체" font.height="-9" font.weight="400" font.family="1" ' + &
					   ' font.pitch="1" font.charset="129" background.mode="2" background.color="79741120") ' 
      /* 색상 헤드 타이틀 생성 */
		IF ls_color <> dw_assort.object.color[i] THEN 
         ls_modify = ls_modify + 'create text(band=header alignment="2" text="' + ls_color + '" border="6" color="0" ' + &
                                 'x="' + String(ll_x - (k * 192) + 9) + '" y="8" height="56" ' + &
											'width="' + String(k * 192 - 18) + '"' + &
					                  'name=t_color_' + String(i) +  ' ' + &
											'font.face="굴림체" font.height="-9" font.weight="400"  font.family="1" ' + &
					                  'font.pitch="1" font.charset="129" background.mode="2" background.color="79741120") ' 
	      ls_color  = dw_assort.object.color[i] 
			k = 0  
		END IF
	   dw_body.Modify(ls_modify)
		ll_x = ll_x + 192 
		k++
   NEXT
   /* 마지막 색상 헤드 타이틀 생성 */
   ls_modify = 'create text(band=header alignment="2" text="' + ls_color + '" border="6" color="0" ' + &
                            'x="' + String(ll_x - (k * 192) + 9) + '" y="8" height="56" ' + &
									 'width="' + String(k * 192 - 18) + '"' + &
					             'name=t_color_' + String(i) +  ' ' + &
									 'font.face="굴림체" font.height="-9" font.weight="400" font.family="1" ' + &
					             'font.pitch="1" font.charset="129" background.mode="2" background.color="79741120") ' + &
               'create text(band=header alignment="2" text="~~r~~n합계" border="6" color="0" ' + &
                            'x="' + String(ll_x + 9) + '" y="8" height="124" ' + &
									 'width="174" name=t_tot_c font.face="굴림체" font.height="-9" font.weight="400" font.family="1" ' + &
					             'font.pitch="1" font.charset="129" background.mode="2" background.color="79741120") ' 
	/* 매장별 합계 생성 */
   ls_modify = ls_modify + ' create compute(band=detail alignment="1" expression="' + ls_rowtot + ' "' + &
					            ' border="0" color="0" x="' + String(ll_x) + '" y="0" height="64" width="183" format="#,###" name=c_tot' + &
			             		' font.face="굴림체" font.height="-9" font.weight="400" font.family="1" ' + &
			             		' font.pitch="1" font.charset="129" background.mode="2" background.color="79741120") ' + &
               ' create compute(band=footer alignment="1" expression="sum(' + ls_rowtot + ' for all) "' + &
					            ' border="0" color="0" x="' + String(ll_x) + '" y="0" height="64" width="183" format="#,###" name=c_tot_s' + &
				            	' font.face="굴림체" font.height="-9" font.weight="400" font.family="1" ' + &
					            ' font.pitch="1" font.charset="129" background.mode="2" background.color="79741120") ' 
   dw_body.Modify(ls_modify)
else
	MessageBox("화면생성 오류", ls_errors)
end if
dw_body.SetRedraw(True)

Return True
end function

public function boolean wf_print_dwset ();Long   i, k, ll_row_cnt, ll_x, ll_print_weight
String ls_sql,    ls_dw_syntax, ls_dw_style, ls_errors
String ls_col_nm, ls_modify, ls_rowtot 
String ls_color

ll_row_cnt = dw_assort.RowCount() 
IF ll_row_cnt < 1 THEN RETURN FALSE

dw_print.DataObject = ''

ls_dw_style = 'style(Type=tabular ) ' + & 
				  '  Text(border=4 font.face="굴림체"  font.Height=-9  font.weight=400 font.family=1 font.pitch=1 font.charset=129) ' + &
				  'Column(border=2 font.face="굴림체"  font.Height=-9  font.weight=400 font.family=2 font.pitch=2 font.charset=129) ' 

/* SQL문장 생성 */
ls_sql = "select '123456'  as shop_cd, '12345678901234567890'  as shop_nm, 0 as stock_qty "
FOR i = 1 TO ll_row_cnt 
	ls_sql = ls_sql + ", 0 as deal_qty" + String(i)
NEXT
ls_sql = ls_sql + " from dual "
/* DataWindow문장 생성 */
ls_dw_syntax = SQLCA.SyntaxFromSQL(ls_sql, ls_dw_style, ls_errors)
IF LenA(ls_errors) > 0 THEN
	MessageBox("화면생성 오류", ls_errors)
	RETURN False
END IF 
/* DataWindow 생성 */ 
If dw_print.Create(ls_dw_syntax, ls_errors) > 0 Then 
	ls_modify = 'datawindow.header.Height=388 ' + &
	            'datawindow.summary.Height=68  ' + & 
	            'datawindow.detail.Height=68  ' + & 
		         'shop_cd.x="5" shop_cd.y="0" shop_cd.height="64" shop_cd.width="192" ' + & 
		         'shop_cd_t.x="10" shop_cd_t.y="252" shop_cd_t.height="124" shop_cd_t.width="187" shop_cd_t.text = "~~r~~n매장" ' + & 
		         'shop_nm.x="206" shop_nm.y="0" shop_nm.height="64" shop_nm.width="466" ' + & 
		         'shop_nm_t.x="215" shop_nm_t.y="252" shop_nm_t.height="124" shop_nm_t.width="457" shop_nm_t.text = "~~r~~n매장명칭" ' + &
		         'stock_qty.x="681" stock_qty.y="0" stock_qty.height="64" stock_qty.width="183" ' + & 
		         'stock_qty_t.x="690" stock_qty_t.y="252" stock_qty_t.height="124" stock_qty_t.width="174" stock_qty_t.text = "~~r~~n재고" ' + &
               'create text(band=summary alignment="2" text="합계" border="2" color="0" ' + &
                            'x="5" y="0" height="64" ' + 'width="667"' + 'name=t_total ' + &
									 'font.face="굴림체" font.height="-9" font.weight="400" font.family="1" ' + &
					             'font.pitch="1" font.charset="129" background.mode="2" background.color="553648127") ' + & 
               'create compute(band=summary alignment="1" expression="sum(stock_qty for all)" border="2" color="0" ' + &
					             'x="681" y="0" height="64" width="183" format="#,###" name=c_stock_tot ' + &
					             'font.face="굴림체" font.height="-9" font.weight="400" font.family="1" ' + &
					             'font.pitch="1" font.charset="129" background.mode="2" background.color="553648127") ' 
	dw_print.Modify(ls_modify)
   /* 칼럼별 정의 */
	ll_x = 873
	k    = 0 
	ls_color = dw_assort.object.color[1]
   FOR i = 1 TO ll_row_cnt 
		ls_col_nm = "deal_qty" + String(i)
		IF i = 1 THEN 
         ls_rowtot = "if(isnull(" + ls_col_nm + ") , 0," +  ls_col_nm + ") "
		ELSE
		   ls_rowtot = ls_rowtot + " + " + "if(isnull(" + ls_col_nm + ") , 0," +  ls_col_nm + ") "
		END IF 
		ls_modify = ls_col_nm + '.x="' + String(ll_x) + '" ' + &
		            ls_col_nm + '.y="0" ' + &
		            ls_col_nm + '.height="64" ' + &
		            ls_col_nm + '.width="183" ' + & 
		            ls_col_nm + '.format="#,##" ' + &
		            ls_col_nm + "_t" + '.Text="' + dw_assort.object.size[i] + '" ' + &
		            ls_col_nm + "_t" + '.x="' + String(ll_x + 9) + '" ' + &
		            ls_col_nm + "_t" + '.y="320" ' + &
		            ls_col_nm + "_t" + '.height="56" ' + &
		            ls_col_nm + "_t" + '.width="174" ' + &
                  ' create compute(band=summary alignment="1" expression="sum(' + ls_col_nm + ' for all)"' + &
					   ' border="2" color="0" x="' + String(ll_x) + '" y="0" height="64" width="183" format="#,###" name=c_tot' + String(i) + &
					   ' font.face="굴림체" font.height="-9" font.weight="400" font.family="1" ' + &
					   ' font.pitch="1" font.charset="129" background.mode="1" background.color="553648127") ' 
      /* 색상 헤드 타이틀 생성 */
		IF ls_color <> dw_assort.object.color[i] THEN 
         ls_modify = ls_modify + 'create text(band=header alignment="2" text="' + ls_color + '" border="4" color="0" ' + &
                                 'x="' + String(ll_x - (k * 192) + 9) + '" y="252" height="56" ' + &
											'width="' + String(k * 192 - 18) + '"' + &
					                  'name=t_color_' + String(i) +  ' ' + &
											'font.face="굴림체" font.height="-9" font.weight="400"  font.family="1" ' + &
					                  'font.pitch="1" font.charset="129" background.mode="1" background.color="553648127") ' 
	      ls_color  = dw_assort.object.color[i] 
			k = 0  
		END IF
	   dw_print.Modify(ls_modify)
		ll_x = ll_x + 192 
		k++
   NEXT
   /* 마지막 색상 헤드 타이틀 생성 */
   ls_modify = 'create text(band=header alignment="2" text="' + ls_color + '" border="4" color="0" ' + &
                           'x="' + String(ll_x - (k * 192) + 9) + '" y="252" height="56" ' + &
								   'width="' + String(k * 192 - 18) + '"' + &
				               'name=t_color_' + String(i) +  ' ' + &
								   'font.face="굴림체" font.height="-9" font.weight="400" font.family="1" ' + &
				               'font.pitch="1" font.charset="129" background.mode="1" background.color="553648127") ' + &
               'create text(band=header alignment="2" text="~~r~~n합계" border="4" color="0" ' + &
                            'x="' + String(ll_x + 9) + '" y="252" height="124" ' + &
									 'width="174" name=t_tot_c font.face="굴림체" font.height="-9" font.weight="400" font.family="1" ' + &
					             'font.pitch="1" font.charset="129" background.mode="2" background.color="553648127") ' 
	/* 매장별 합계 생성 */
   ls_modify = ls_modify + ' create compute(band=detail alignment="1" expression="' + ls_rowtot + ' "' + &
					            ' border="2" color="0" x="' + String(ll_x) + '" y="0" height="64" width="183" format="#,###" name=c_tot' + &
			             		' font.face="굴림체" font.height="-9" font.weight="400" font.family="1" ' + &
			             		' font.pitch="1" font.charset="129" background.mode="2" background.color="553648127") ' + &
               ' create compute(band=summary alignment="1" expression="sum(' + ls_rowtot + ' for all) "' + &
					            ' border="2" color="0" x="' + String(ll_x) + '" y="0" height="64" width="183" format="#,###" name=c_tot_s' + &
				            	' font.face="굴림체" font.height="-9" font.weight="400" font.family="1" ' + &
					            ' font.pitch="1" font.charset="129" background.mode="2" background.color="553648127") ' 
   dw_print.Modify(ls_modify) 
	/* Title 내용 생성 */
	ll_print_weight = Max(681 + ((i - 1) * 192), 3383)
   ls_modify = 'create text(band=header alignment="2" text="배분표 현황" border="0" color="0" x="5" y="28" height="72" width="' + String(ll_print_weight - 5) + '"  name=t_title  font.face="굴림체" font.height="-12" font.weight="700"  font.family="1" font.pitch="1" font.charset="129" background.mode="1" background.color="553648127" ) ' + &
               'create line(band=header x1="5" y1="232" x2="' + String(ll_print_weight) + '" y2="232"  name=l_h1 pen.style="0" pen.width="5" pen.color="0"  background.mode="1" background.color="553648127" ) ' + &
               'create line(band=header x1="' + String(Round(ll_print_weight / 2, 0) - 247) + '" y1="108" x2="' + String(Round(ll_print_weight / 2, 0) + 247) + '" y2="108"  name=l_t2 pen.style="0" pen.width="5" pen.color="0"  background.mode="1" background.color="553648127" ) ' + & 
               'create line(band=header x1="' + String(Round(ll_print_weight / 2, 0) - 247) + '" y1="100" x2="' + String(Round(ll_print_weight / 2, 0) + 247) + '" y2="100"  name=l_t1 pen.style="0" pen.width="5" pen.color="0"  background.mode="1" background.color="553648127" ) ' + & 
               'create text(band=header alignment="0" text="배분일 : ' + String(is_yymmdd, "@@@@/@@/@@") + '" border="0" color="0" x="18" y="104" height="56" width="585"  name=t_ymd  font.face="굴림체" font.height="-9" font.weight="400"  font.family="1" font.pitch="1" font.charset="129" background.mode="1" background.color="553648127" ) ' + & 
               'create text(band=header alignment="0" text="품  번 : ' + is_style + "-" + is_chno + '" border="0" color="0" x="18" y="168" height="56" width="585"  name=t_style  font.face="굴림체" font.height="-9" font.weight="400"  font.family="1" font.pitch="1" font.charset="129" background.mode="1" background.color="553648127" ) ' + & 
               'create text(band=header alignment="0" text="배분구분 : ' + idw_deal_fg.GetitemString(idw_deal_fg.GetRow(), "inter_display") + '" border="0" color="0" x="635" y="168" height="56" width="805"  name=t_deal_fg  font.face="굴림체" font.height="-9" font.weight="400"  font.family="1" font.pitch="1" font.charset="129" background.mode="1" background.color="553648127" ) ' + & 
               'create text(band=header alignment="0" text="배분차수 : ' + String(il_fr_deal_seq) + " ~~ " + String(il_to_deal_seq) + '" border="0" color="0" x="1477" y="168" height="56" width="805"  name=t_deal_seq  font.face="굴림체" font.height="-9" font.weight="400"  font.family="1" font.pitch="1" font.charset="129" background.mode="1" background.color="553648127" ) ' + &
               'create text(band=header alignment="1" text="1999/99/99-99:99:99" border="0" color="0" x="' + String(ll_print_weight - (3383 - 2843)) + '" y="172" height="52" width="521"  name=t_datetime  font.face="굴림체" font.height="-9" font.weight="400"  font.family="1" font.pitch="1" font.charset="129" background.mode="1" background.color="536870912" ) ' + &
               'create text(band=header alignment="2" text="M99999" border="0" color="0" x="' + String(ll_print_weight - (3383 - 2597)) + '" y="172" height="52" width="192"  name=t_user_id  font.face="굴림체" font.height="-9" font.weight="400"  font.family="1" font.pitch="1" font.charset="129" background.mode="1" background.color="536870912" ) ' + &
               'create text(band=header alignment="2" text="-" border="0" color="0" x="' + String(ll_print_weight - (3383 - 2802)) + '" y="172" height="52" width="27"  name=t_5  font.face="굴림체" font.height="-9" font.weight="400"  font.family="1" font.pitch="1" font.charset="129" background.mode="1" background.color="536870912" ) ' + &
               'create text(band=header alignment="2" text="W_99999_E" border="0" color="0" x="' + String(ll_print_weight - (3383 - 2610)) + '" y="112" height="52" width="256"  name=t_pg_id  font.face="굴림체" font.height="-9" font.weight="400"  font.family="1" font.pitch="1" font.charset="129" background.mode="1" background.color="536870912" ) ' + & 
               'create text(band=header alignment="2" text="-" border="0" color="0" x="' + String(ll_print_weight - (3383 - 2880)) + '" y="112" height="52" width="27"  name=t_8  font.face="굴림체" font.height="-9" font.weight="400"  font.family="1" font.pitch="1" font.charset="129" background.mode="1" background.color="536870912" ) ' + & 
               'create compute(band=header alignment="1" expression="~~~"Page: ~~~" + Fill(~~~"*~~~", 4 - Len(String(page()))) + page() + ~~~"/~~~" + Fill(~~~"*~~~", 4 - Len(String(pageCount()))) + pageCount()"border="0" color="0" x="' + String(ll_print_weight - (3383 - 2921)) + '" y="112" height="52" width="443" format="[GENERAL]"  name=compute_10  font.face="굴림체" font.height="-9" font.weight="400"  font.family="1" font.pitch="1" font.charset="129" background.mode="1" background.color="553648127" ) ' 
   dw_print.Modify(ls_modify)
else
	MessageBox("화면생성 오류", ls_errors)
end if

Return True 

end function

public subroutine wf_retrieve_set ();Long   i, k, ll_find 
String ls_shop_cd, ls_shop_nm 
String ls_color,   ls_size

il_rows = dw_db.Retrieve(is_yymmdd, is_style, is_chno, 	is_deal_fg, il_fr_deal_seq, il_to_deal_seq) 

ls_shop_cd = " " 

dw_body.SetRedraw(False)
FOR i = 1 to il_rows 
	IF ls_shop_cd <> dw_db.object.shop_cd[i] THEN 
		ls_shop_cd =  dw_db.object.shop_cd[i]
      ll_find = dw_body.find("shop_cd = '" + ls_shop_cd + "'", 1, dw_body.RowCount()) 
		IF ll_find < 1 THEN 
			ll_find = dw_body.insertRow(0) 
			dw_body.Setitem(ll_find, "shop_cd", ls_shop_cd)
			dw_body.Setitem(ll_find, "shop_nm",   dw_db.object.shop_nm[i])
			dw_body.Setitem(ll_find, "stock_qty", dw_db.object.stock_qty[i])
		END IF 
   END IF		
	ls_color = dw_db.GetitemString(i, "color") 
	ls_size  = dw_db.GetitemString(i, "size") 
	k = dw_assort.find("color = '" + ls_color + "' and size = '" + ls_size + "'", 1, dw_assort.RowCount()) 
	IF k < 1 THEN CONTINUE 
	dw_body.Setitem(ll_find, "deal_qty" + String(k), dw_db.GetitemNumber(i, "deal_qty"))
NEXT 
dw_body.SetRedraw(True)

end subroutine

on w_52018_d.create
int iCurrent
call super::create
this.dw_assort=create dw_assort
this.dw_db=create dw_db
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_assort
this.Control[iCurrent+2]=this.dw_db
end on

on w_52018_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_assort)
destroy(this.dw_db)
end on

event open;call super::open;dw_head.Setitem(1, "deal_fg",    "%") 
dw_head.Setitem(1, "fr_deal_seq",  1) 
dw_head.Setitem(1, "to_deal_seq", 99) 

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
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


is_yymmdd = String(dw_head.GetitemDate(1, "yymmdd"), "yyyymmdd")
is_deal_fg  = dw_head.GetItemString(1, "deal_fg")

il_fr_deal_seq = dw_head.GetItemNumber(1, "fr_deal_seq")
if IsNull(il_fr_deal_seq)  then
   MessageBox(ls_title,"배분차수를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_deal_seq")
   return false
end if

il_to_deal_seq = dw_head.GetItemNumber(1, "to_deal_seq")
if IsNull(il_to_deal_seq)  then
   MessageBox(ls_title,"배분차수를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_deal_seq")
   return false
end if

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */
/* 작성일      : 2002.02.05                                                  */
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_yymmdd, is_brand, is_deal_fg, il_fr_deal_seq, il_to_deal_seq)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen;call super::pfc_preopen;dw_assort.SetTransObject(SQLCA)
dw_db.SetTransObject(SQLCA) 


end event

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.06                                                  */	
/* 수정일      : 2002.02.06                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

wf_print_dwset()

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_52018_d","0")
end event

type cb_close from w_com020_d`cb_close within w_52018_d
end type

type cb_delete from w_com020_d`cb_delete within w_52018_d
end type

type cb_insert from w_com020_d`cb_insert within w_52018_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_52018_d
end type

type cb_update from w_com020_d`cb_update within w_52018_d
end type

type cb_print from w_com020_d`cb_print within w_52018_d
end type

type cb_preview from w_com020_d`cb_preview within w_52018_d
end type

type gb_button from w_com020_d`gb_button within w_52018_d
end type

type cb_excel from w_com020_d`cb_excel within w_52018_d
end type

type dw_head from w_com020_d`dw_head within w_52018_d
integer height = 148
string dataobject = "d_52018_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA) 
idw_brand.Retrieve('001')

This.GetChild("deal_fg", idw_deal_fg)
idw_deal_fg.SetTransObject(SQLCA) 
idw_deal_fg.Retrieve('521')
idw_deal_fg.insertRow(1)
idw_deal_fg.Setitem(1, "inter_cd", "%")
idw_deal_fg.Setitem(1, "inter_nm", "전체")

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

type ln_1 from w_com020_d`ln_1 within w_52018_d
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com020_d`ln_2 within w_52018_d
integer beginy = 324
integer endy = 324
end type

type dw_list from w_com020_d`dw_list within w_52018_d
integer x = 9
integer y = 348
integer width = 786
integer height = 1700
string dataobject = "d_52018_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/
String ls_style_no 

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_style_no = This.GetItemString(row, 'style_no') 

IF IsNull(ls_style_no) THEN return
is_style = LeftA(ls_style_no, 8) 
is_chno  = RightA(ls_style_no, 1) 

il_rows = dw_assort.retrieve(is_style, is_chno) 
IF il_rows > 0 THEN
	IF wf_body_set() THEN 
		wf_retrieve_set()
	END IF 
END IF 

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_52018_d
integer x = 818
integer y = 348
integer width = 2793
integer height = 1700
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type st_1 from w_com020_d`st_1 within w_52018_d
integer x = 800
integer y = 348
integer height = 1700
end type

type dw_print from w_com020_d`dw_print within w_52018_d
end type

type dw_assort from datawindow within w_52018_d
boolean visible = false
integer x = 2290
integer y = 280
integer width = 411
integer height = 432
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "assort"
string dataobject = "d_52018_d99"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type dw_db from datawindow within w_52018_d
boolean visible = false
integer x = 2793
integer y = 296
integer width = 517
integer height = 416
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "db"
string dataobject = "d_52018_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

