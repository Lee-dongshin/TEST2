$PBExportHeader$w_31001_e.srw
$PBExportComments$생산 의뢰 확정 관리
forward
global type w_31001_e from w_com010_e
end type
type tab_1 from tab within w_31001_e
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
type tabpage_5 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tabpage_6 from userobject within tab_1
end type
type tabpage_6 from userobject within tab_1
end type
type tabpage_7 from userobject within tab_1
end type
type tabpage_7 from userobject within tab_1
end type
type tabpage_8 from userobject within tab_1
end type
type tabpage_8 from userobject within tab_1
end type
type tab_1 from tab within w_31001_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
end type
type dw_sub from u_dw within w_31001_e
end type
type dw_going from u_dw within w_31001_e
end type
type dw_amat from u_dw within w_31001_e
end type
type dw_label from datawindow within w_31001_e
end type
type dw_bigo from datawindow within w_31001_e
end type
type dw_smat from u_dw within w_31001_e
end type
type dw_sketch from datawindow within w_31001_e
end type
type dw_spec from u_dw within w_31001_e
end type
type cb_copy from commandbutton within w_31001_e
end type
type dw_1 from datawindow within w_31001_e
end type
type dw_assort from u_dw within w_31001_e
end type
end forward

global type w_31001_e from w_com010_e
integer width = 3675
integer height = 2184
string menuname = ""
windowstate windowstate = maximized!
event type integer ue_popup2 ( string as_column,  long al_row,  string as_data,  integer ai_div )
tab_1 tab_1
dw_sub dw_sub
dw_going dw_going
dw_amat dw_amat
dw_label dw_label
dw_bigo dw_bigo
dw_smat dw_smat
dw_sketch dw_sketch
dw_spec dw_spec
cb_copy cb_copy
dw_1 dw_1
dw_assort dw_assort
end type
global w_31001_e w_31001_e

type variables
DataWindowChild idw_sub_job, idw_fabric_by
String  is_size[]
Boolean ib_read[]
String  is_style, is_chno, is_brand, is_year, is_season
Boolean ib_tab1_chk = False, ib_tab2_chk = False, ib_tab3_chk = False, ib_tab4_chk = False
Boolean ib_tab5_chk = False, ib_tab6_chk = False, ib_tab7_chk = False, ib_tab8_chk = False

end variables

forward prototypes
public function boolean wf_style_chk (string as_style)
public subroutine wf_tab_retrieve (integer ai_index)
public subroutine wf_save_spec ()
public subroutine wf_set_size ()
public function boolean wf_tab_update (datetime adt_datetime, string as_errmsg)
public subroutine wf_display_spec ()
end prototypes

event type integer ue_popup2(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"				
		is_brand = dw_body.GetItemString(1, "brand")
			IF ai_div = 1 THEN
						IF gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_shop_nm) = 0 THEN
							dw_sub.SetItem(al_row, "cust_nm", ls_shop_nm)
							RETURN 0
						END IF


//				Choose Case is_brand
//					Case 'J','W','T'
//						IF (Left(as_data, 1) = 'N' or Left(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_shop_nm) = 0 THEN
//							dw_sub.SetItem(al_row, "cust_nm", ls_shop_nm)
//							RETURN 0
//						END IF
//					Case 'Y'
//						IF (Left(as_data, 1) = 'O' or Left(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_shop_nm) = 0 THEN
//							dw_sub.SetItem(al_row, "cust_nm", ls_shop_nm)
//							RETURN 0
//						END IF
//					Case Else
//						IF Left(as_data, 1) = is_brand and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_shop_nm) = 0 THEN
//							dw_sub.SetItem(al_row, "cust_nm", ls_shop_nm)
//							RETURN 0
//						END IF
//				End Choose
			END IF
			
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재/생산 거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911"
//			Choose Case is_brand					
//				case 'M'
//
//					gst_cd.default_where   = " WHERE CUST_CODE BETWEEN '5000' and '9999' " + &
//													 "   AND CHANGE_GUBN = '00' "					
//			
//													 
//				case 'O','Y'
//					gst_cd.default_where   = " WHERE BRAND = 'O' " + &
//													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
//													 "   AND CHANGE_GUBN = '00' "					
//				case else
//					gst_cd.default_where   = " WHERE BRAND = 'N' " + &
//													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
//													 "   AND CHANGE_GUBN = '00' "								
//			end choose


			gst_cd.default_where   = " WHERE CUST_CODE BETWEEN '5000' and '8999' " + &
									 "   AND CHANGE_GUBN = '00' "				
													 
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "CUSTCODE LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_sub.SetRow(al_row)
				dw_sub.SetColumn(as_column)
				dw_sub.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_sub.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				dw_sub.SetColumn("ord_ymd")
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
				cb_excel.enabled = false
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

public subroutine wf_tab_retrieve (integer ai_index);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* TABPAGE별 조회   */

IF ib_read[ai_index] THEN RETURN 


CHOOSE CASE ai_index
	CASE 2
		dw_1.Retrieve(is_style, is_chno) 
		dw_spec.Reset() 
		
END CHOOSE

ib_read[ai_index] = True

end subroutine

public subroutine wf_save_spec ();/*-------------------------------------------------*/
/* dw_spec 내용을 dw_1로 이관 처리 */
/*-------------------------------------------------*/

String  ls_spec_fg,    ls_spec_cd, ls_size, ls_find, ls_flag
Long    ll_RowCnt,     ll_row, i, j  
Decimal ldc_spec_term, ldc_size_spec
DwItemStatus ldw_status

IF dw_spec.modifiedcount() = 0 AND dw_spec.deletedcount() = 0 THEN
	Return 
END IF

/* db처리용 datawindow clear */
FOR i = 1 TO dw_1.RowCount()
   dw_1.Setitem(ll_row, "size_spec", 0)
NEXT

/* display용 datawindow 에서 db용 datawindow로 자료 이관 */
ll_RowCnt = dw_spec.RowCount()
FOR i = 1 TO ll_RowCnt 
	ls_spec_fg    = dw_spec.GetitemString(i,  "spec_fg")  
	ls_spec_cd    = dw_spec.GetitemString(i,  "spec_cd") 
 	IF isnull(ls_spec_fg) or isnull(ls_spec_cd) THEN CONTINUE
   ldc_spec_term = dw_spec.GetitemDecimal(i, "spec_term")
	FOR j = 1 TO UpperBound(is_size) 
	   ls_size       = dw_spec.describe("t_size_spec_" + String(j) + ".Text")
		ldc_size_spec = dw_spec.GetitemDecimal(i, "size_spec_" + String(j))
		 
  		IF isnull(ldc_size_spec)  THEN CONTINUE

		ls_find = "spec_fg = '" + ls_spec_fg + "' and spec_cd = '" + & 
		          ls_spec_cd + "' and size = '" + ls_size + "'"
		ll_row  = dw_1.find(ls_find, 1, dw_1.RowCount()) 
		
	
		IF ll_row < 1 THEN
			ll_row = dw_1.insertRow(0)
	      dw_1.Setitem(ll_row, "spec_fg", ls_spec_fg)
	      dw_1.Setitem(ll_row, "spec_cd", ls_spec_cd)
	      dw_1.Setitem(ll_row, "size",    ls_size)
		END IF
	
		ls_flag = dw_1.Getitemstring(ll_row,"update_flag")
		
		if  ls_flag = 'N' then 
			dw_1.SetItemStatus(ll_row, 0, Primary!, NewModified!)
		end if
			 
      dw_1.Setitem(ll_row, "spec_term", ldc_spec_term)
      dw_1.Setitem(ll_row, "size_spec", ldc_size_spec)
	NEXT 
NEXT

///* 제품 치수가 없는자료는 삭제 */

//FOR i = 1 to   dw_1.RowCount() 
//	ldc_size_spec = dw_1.GetitemDecimal(i, "size_spec")
//   IF isnull(ldc_size_spec) OR ldc_size_spec = 0 THEN 
//		dw_1.DeleteRow(i)
//	END IF
//NEXT
//
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

ll_rowcount = dw_assort.RowCount()
lds_Source  = Create DataStore 
lds_Source.DataObject = dw_assort.DataObject

dw_assort.RowsCopy(1, ll_rowcount, Primary!, lds_Source, 1, Primary!)

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
	dw_spec.modify(ls_modify)
NEXT

Destroy  lds_Source


end subroutine

public function boolean wf_tab_update (datetime adt_datetime, string as_errmsg);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
/* tabpage datawindow 저장 처리 */
Long    i, ll_row 
String  ls_color, ls_size 


/* 완성제품 치수 처리 */
/* dw_spec에 변경 내역 있으면 dw_1로 이관 */
//if ib_read[2] then
IF dw_spec.ModifiedCount() > 0 OR dw_spec.deletedcount() > 0 THEN 
	wf_save_spec()
END IF

IF dw_1.ModifiedCount() > 0 THEN 
	FOR i = 1 TO dw_1.RowCount()
		idw_status = dw_1.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record */
			dw_1.Setitem(i, "style",  is_style)
			dw_1.Setitem(i, "chno",   is_chno)
			dw_1.Setitem(i, "reg_id", gs_user_id)
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
			dw_1.Setitem(i, "mod_id", gs_user_id)
			dw_1.Setitem(i, "mod_dt", adt_datetime)
		END IF
	NEXT
END IF



RETURN true

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

ll_RowCnt = dw_1.RowCount()
IF ll_RowCnt < 1 THEN RETURN

/* 사이즈 갯수 (wf_set_size에서 정의됨)*/
ll_max = UpperBound(is_size)    

/* display 용 datawindow 초기화 후 셋팅 */
dw_spec.Reset()
FOR i = ll_RowCnt TO 1 STEP -1
	ls_spec_fg = dw_1.GetitemString(i, "spec_fg") 
	ls_spec_cd = dw_1.GetitemString(i, "spec_cd") 
	ls_size    = dw_1.GetitemString(i, "size") 
	ls_find    = "spec_fg = '" + ls_spec_fg + "' and spec_cd = '" + ls_spec_cd + "'"
	ll_row = dw_spec.find(ls_find, 1, dw_spec.RowCount())
	IF ll_row < 0 THEN 
		RETURN 
	ELSEIF ll_row = 0 THEN
		ll_row = dw_spec.insertRow(0)

		dw_spec.Setitem(ll_row, "spec_fg", ls_spec_fg)
		dw_spec.Setitem(ll_row, "spec_cd", ls_spec_cd)
		dw_spec.Setitem(ll_row, "spec_term", dw_1.GetitemDecimal(i, "spec_term"))

   END IF 
	/* size assort 내역 검색 */
	FOR j = 1 TO ll_max 
		IF is_size[j] = ls_size THEN EXIT
	NEXT 
   /* 해당 사이즈가 없으면 삭제 */
	IF j > ll_max THEN 
//		dw_1.DeleteRow(i)
	ELSE 
		dw_spec.Setitem(ll_row, "size_spec_" + String(j), dw_1.GetitemDecimal(i, "size_spec"))
	END IF
NEXT

/* 제품 치수내역 정렬 */
dw_spec.SetSort("spec_fg A, spec_cd A")
dw_spec.Sort()
dw_spec.ResetUpdate()

end subroutine

on w_31001_e.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_sub=create dw_sub
this.dw_going=create dw_going
this.dw_amat=create dw_amat
this.dw_label=create dw_label
this.dw_bigo=create dw_bigo
this.dw_smat=create dw_smat
this.dw_sketch=create dw_sketch
this.dw_spec=create dw_spec
this.cb_copy=create cb_copy
this.dw_1=create dw_1
this.dw_assort=create dw_assort
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_sub
this.Control[iCurrent+3]=this.dw_going
this.Control[iCurrent+4]=this.dw_amat
this.Control[iCurrent+5]=this.dw_label
this.Control[iCurrent+6]=this.dw_bigo
this.Control[iCurrent+7]=this.dw_smat
this.Control[iCurrent+8]=this.dw_sketch
this.Control[iCurrent+9]=this.dw_spec
this.Control[iCurrent+10]=this.cb_copy
this.Control[iCurrent+11]=this.dw_1
this.Control[iCurrent+12]=this.dw_assort
end on

on w_31001_e.destroy
call super::destroy
destroy(this.tab_1)
destroy(this.dw_sub)
destroy(this.dw_going)
destroy(this.dw_amat)
destroy(this.dw_label)
destroy(this.dw_bigo)
destroy(this.dw_smat)
destroy(this.dw_sketch)
destroy(this.dw_spec)
destroy(this.cb_copy)
destroy(this.dw_1)
destroy(this.dw_assort)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.01                                                  */	
/* 수정일      : 2002.02.01                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_style, ls_chno, ls_brand, ls_year, ls_season, ls_fr_style, ls_fr_chno, ls_mat_cd, ls_mat_nm, ls_syear
Boolean    lb_check 
Long       i
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
//				
					select case when :ls_style like '[BP]X3X___%' then '20132' else dbo.sf_inter_cd1('002',substring(:ls_style,3,1)) + convert(char(1),dbo.sf_inter_sort_seq('003',substring(:ls_style,4,1))) end
					into :ls_syear
					from dual;
			
			
					if ls_syear >= "20133"  then
						ls_brand = MidA(ls_style,1,1)
					else	
						ls_brand = "N"
					end if
					

					dw_body.getchild("season",ldw_child)
					ldw_child.settransobject(sqlca)
					ldw_child.retrieve('003', ls_brand, LeftA(ls_syear,4))		
					
			IF gf_style_chk(ls_style, ls_chno) THEN
					if gs_brand <> "K" then						
						RETURN 0
					else 
						if gs_brand <> MidA(ls_style,1,1) then
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
			gst_cd.default_where   = ""		//WHERE Shop_Stat = '00' 
			
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
//				gst_cd.Item_where = "STYLE LIKE '" + ls_style + "%'"
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
				dw_head.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand")   )
				dw_head.SetItem(al_row, "year",     lds_Source.GetItemString(1,"year")    )
				dw_head.SetItem(al_row, "season",   lds_Source.GetItemString(1,"season")  )
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
				cb_excel.enabled = false
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
			
			if gs_brand <> "K" then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "(mat_cd LIKE  '" + ls_mat_cd + "%' or mat_nm LIKE  '%" + ls_mat_cd + "%')"
				ELSE				
					gst_cd.Item_where = ""
				END IF
			else
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "(mat_cd LIKE  '" + ls_mat_cd + "%' or mat_nm LIKE  '%" + ls_mat_cd + "%') and mat_cd like 'K%'"
				ELSE				
					gst_cd.Item_where = "mat_cd like 'K%'"
				END IF
			end if 	
			
			
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = " (mat_cd LIKE  '" + ls_mat_cd + "%' or mat_nm LIKE  '%" + ls_mat_cd + "%') "
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
				dw_head.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand")   )
				dw_head.SetItem(al_row, "year",     lds_Source.GetItemString(1,"year")    )
				dw_head.SetItem(al_row, "season",   lds_Source.GetItemString(1,"season")  )
				


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
	CASE "cust_cd"				
		is_brand = dw_body.GetItemString(1, "brand")
//		messagebox("is_brand",is_brand)
			IF ai_div = 1 THEN 
				if isnull(as_data) or trim(as_data) = "" then
					return 0
				end if
						IF gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_shop_nm) = 0 THEN
							dw_body.SetItem(al_row, "cust_nm", ls_shop_nm)
							For i = 1 To dw_assort.RowCount()
								dw_assort.SetItem(i, "ord_qty", dw_assort.GetItemDecimal(i, "plan_qty"))
								dw_assort.SetItem(i, "ord_qty_chn", dw_assort.GetItemDecimal(i, "plan_qty_chn"))

							Next
							RETURN 0
						END IF


//				Choose Case is_brand
//					Case 'J','W','T','C' /* Double U Dot, Tasse Tasse 추가 2003.07.07 */
//						IF (Left(as_data, 1) = 'N' or Left(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_shop_nm) = 0 THEN
//							dw_body.SetItem(al_row, "cust_nm", ls_shop_nm)
//							For i = 1 To dw_assort.RowCount()
//								dw_assort.SetItem(i, "ord_qty", dw_assort.GetItemDecimal(i, "plan_qty"))
//								dw_assort.SetItem(i, "ord_qty_chn", dw_assort.GetItemDecimal(i, "plan_qty_chn"))
//
//							Next
//							RETURN 0
//						END IF
//					Case 'Y'
//						IF (Left(as_data, 1) = 'O' or Left(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_shop_nm) = 0 THEN
//							dw_body.SetItem(al_row, "cust_nm", ls_shop_nm)
//							For i = 1 To dw_assort.RowCount()
//								dw_assort.SetItem(i, "ord_qty", dw_assort.GetItemDecimal(i, "plan_qty"))
//								dw_assort.SetItem(i, "ord_qty_chn", dw_assort.GetItemDecimal(i, "plan_qty_chn"))
//
//							Next
//							RETURN 0
//						END IF
//					Case Else
//						IF Left(as_data, 1) = is_brand and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_shop_nm) = 0 THEN
//							dw_body.SetItem(al_row, "cust_nm", ls_shop_nm)
//							For i = 1 To dw_assort.RowCount()
//								dw_assort.SetItem(i, "ord_qty", dw_assort.GetItemDecimal(i, "plan_qty"))
//								dw_assort.SetItem(i, "ord_qty_chn", dw_assort.GetItemDecimal(i, "plan_qty_chn"))
//
//							Next
//							RETURN 0
//						END IF
//				End Choose
			END IF
			
		
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재/생산 거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911"

			gst_cd.default_where   = " WHERE CUST_CODE BETWEEN '5000' and '9999' " + &
											 "   AND CHANGE_GUBN = '00' "		

//			Choose Case is_brand
//				case 'M'
//					gst_cd.default_where   = " WHERE CUST_CODE BETWEEN '5000' and '9999' " + &
//													 "   AND CHANGE_GUBN = '00' "					
//			
//						
//				case 'O','Y'
//					gst_cd.default_where   = " WHERE BRAND = 'O' " + &
//													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
//													 "   AND CHANGE_GUBN = '00' "					
//				case else
//					gst_cd.default_where   = " WHERE BRAND = 'N' " + &
//													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
//													 "   AND CHANGE_GUBN = '00' "							
//			end choose
			
					
//			Choose Case is_brand
//				Case 'J','W','T','C' /* Double U Dot, Tasse Tasse 추가 2003.07.07 */
//					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
//													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
//													 "   AND CHANGE_GUBN = '00' "
//				Case 'Y'
//					gst_cd.default_where   = " WHERE BRAND IN ('O', '" + is_brand + "') " + &
//													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
//													 "   AND CHANGE_GUBN = '00' "
//				Case Else
//					gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' " + &
//													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
//													 "   AND CHANGE_GUBN = '00' "
//			End Choose
			
			
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "CUSTCODE LIKE '" + as_data + "%'"
//			ELSE
//				gst_cd.Item_where = ""
//			END IF

			if gs_brand <> "K" then		
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "custcode LIKE '%" + as_data + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "custcode LIKE '%" + as_data + "%' and custcode like '[OK]%'"
				ELSE
					gst_cd.Item_where = "custcode like '[OK]%'"
				END IF				
			end if	

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_body.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				For i = 1 To dw_assort.RowCount()
					dw_assort.SetItem(i, "ord_qty", dw_assort.GetItemDecimal(i, "plan_qty"))
					dw_assort.SetItem(i, "ord_qty_chn", dw_assort.GetItemDecimal(i, "plan_qty_chn"))

				Next
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("ord_ymd")
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
				cb_excel.enabled = false
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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.01                                                  */	
/* 수정일      : 2002.02.01                                                  */
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

ls_style_no = Trim(dw_head.GetItemString(1, "style_no"))
if IsNull(ls_style_no) or ls_style_no = "" then
   MessageBox(ls_title,"STYLE_NO를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no")
   return false
end if

is_style = LeftA(ls_style_no, 8)
is_chno  = MidA(ls_style_no, 9, 1)

is_brand = LeftA(is_style,1)
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"품번 내역에 브랜드 코드가 없습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no")
   return false
end if

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then
   MessageBox(ls_title,"품번 내역에 시즌년도가 없습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no")
   return false
end if

is_season = MidA(is_style,4,1)



return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.01                                                  */	
/* 수정일      : 2002.02.01                                                  */
/*===========================================================================*/
DateTime ld_datetime
Long i, ll_rows
string ls_flag, ls_cust_cd, ls_remark, ls_color, ls_design_agree
string ls_user_level

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN



il_rows = dw_sketch.retrieve(is_style + is_chno)
il_rows = dw_body.retrieve(is_style, is_chno)
IF il_rows > 0 THEN
	//사용자 레벨 체크
	select '999' into :ls_user_level
	from tb_93013_d(nolock) 	
	where person_id = :gs_user_id
	and   work_gbn = '1'
	and 	user_level like '%9%'
	and   ctrl_brand like '%'+:is_brand+'%';
	
	if ls_user_level = '999' then 
		dw_body.object.design_agree.visible = true
	else
		dw_body.object.design_agree.visible = false		
	end if
	
	//
	ls_design_agree = dw_body.getitemstring(1,"design_agree")
	if ls_design_agree = 'Y' then  //원가확정시 서브공임 수정 불가 
		dw_sub.object.cb_insert_row.visible = false
		dw_sub.object.cb_delete_row.visible = false
	else
		dw_sub.object.cb_insert_row.visible = true
		dw_sub.object.cb_delete_row.visible = true		
	end if
	
	ll_rows = dw_assort.retrieve(is_style, is_chno)
	ib_tab1_chk = True
	
	ls_cust_cd = Trim(dw_body.GetItemString(1, "cust_cd"))
	If IsNull(ls_cust_cd) = False and ls_cust_cd <> "" Then
		For i = 1 To ll_rows
			If dw_assort.GetItemDecimal(i, "plan_qty") <> dw_assort.GetItemDecimal(i, "ord_qty") Then
				MessageBox("변경사항", "Assort내역의 기획량이 변경되었으니 확인하십시요!")
				Exit
			End If
		Next
	End If


	dw_1.retrieve(is_style, is_chno)
	ib_tab2_chk = True
	wf_display_spec()
	
	Choose Case tab_1.selectedtab
//		Case 1
//			dw_assort.retrieve(is_style, is_chno)
//			ib_tab1_chk = True
//		Case 2
//			dw_1.retrieve(is_style, is_chno)
//			ib_tab2_chk = True
//			wf_display_spec()
		Case 3
			dw_amat.retrieve(is_style, is_chno)
			ib_tab3_chk = True
		Case 4
			dw_smat.retrieve(is_style, is_chno)
			ib_tab4_chk = True
		Case 5
			dw_sub.retrieve(is_style, is_chno)
			ib_tab5_chk = True
		Case 6
			dw_going.retrieve(is_brand, is_year, is_season)
			ib_tab6_chk = True
		Case 7
			dw_bigo.retrieve(is_style, is_chno)
			ib_tab7_chk = True			
	End Choose
	
   dw_body.SetFocus()
END IF

IF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSEIF il_rows < 0 Then
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

/****************** Main Label **************************/
il_rows = dw_label.retrieve(is_style, is_chno)
for i = 1 to dw_label.rowcount()
	ls_flag = dw_label.getitemstring(i,"flag")	
	if ls_flag = 'New' then
		dw_label.SetItemStatus(i, 0, Primary!,NewModified!)
	else
		dw_label.SetItemStatus(i, 0, Primary!,DataModified!)
	end if

	ls_remark = dw_label.getitemstring(i,"remark")	
	if isnull(ls_remark) or ls_remark = '' or ls_remark = '()' then
		ls_color = dw_label.getitemstring(i,"color")	
		select '(' + convert(varchar(10),sum(plan_qty)) + ')'
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

/********************************************************/
end event

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled  = true
         cb_print.enabled   = true
         cb_preview.enabled = true
         cb_excel.enabled   = true
         cb_retrieve.Text   = "조건(&Q)"
         dw_head.Enabled    = false
         dw_body.Enabled    = true
         tab_1.Enabled      = true
         dw_assort.Enabled  = true
         dw_spec.Enabled    = true
         dw_amat.Enabled    = true
         dw_smat.Enabled    = true
         dw_sub.Enabled     = true
         dw_going.Enabled   = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text  = "조건(&Q)"
				dw_head.Enabled   = false
				dw_body.Enabled   = true
				tab_1.Enabled     = true
				dw_assort.Enabled = true
				dw_spec.Enabled   = true
				dw_amat.Enabled   = true
				dw_smat.Enabled   = true
				dw_sub.Enabled    = true
				dw_going.Enabled  = true
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
//			if dw_body.RowCount() = 0 then
//            cb_delete.enabled = false
//			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text   = "조회(&Q)"
      cb_delete.enabled  = false
      cb_print.enabled   = false
      cb_preview.enabled = false
      cb_excel.enabled   = false
      cb_update.enabled  = false
      ib_changed         = false
      dw_body.Enabled    = false
      tab_1.Enabled      = false
		dw_assort.Enabled  = false
		dw_spec.Enabled    = false
		dw_amat.Enabled    = false
		dw_smat.Enabled    = false
		dw_sub.Enabled     = false
		dw_going.Enabled   = false
		ib_tab1_chk        = False
		ib_tab2_chk        = False
		ib_tab3_chk        = False
		ib_tab4_chk        = False
		ib_tab5_chk        = False
		ib_tab6_chk        = False
      dw_head.Enabled    = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert,   "FixedToRight")
inv_resize.of_Register(cb_delete,   "FixedToRight")
inv_resize.of_Register(cb_print,    "FixedToRight")
inv_resize.of_Register(cb_preview,  "FixedToRight")
inv_resize.of_Register(cb_excel,    "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close,    "FixedToRight")

/* Data window Resize */
//inv_resize.of_Register(dw_head,   "ScaleToRight")
//inv_resize.of_Register(dw_body,   "ScaleToRight")
inv_resize.of_Register(dw_label,   "ScaleToRight")
inv_resize.of_Register(ln_1,      "ScaleToRight")
inv_resize.of_Register(ln_2,      "ScaleToRight")
inv_resize.of_Register(tab_1,     "ScaleToRight&Bottom")
inv_resize.of_Register(dw_assort, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_spec,   "ScaleToRight&Bottom")
inv_resize.of_Register(dw_amat,   "ScaleToRight&Bottom")
inv_resize.of_Register(dw_smat,   "ScaleToRight&Bottom")
inv_resize.of_Register(dw_sub,    "ScaleToRight&Bottom")
inv_resize.of_Register(dw_going,  "ScaleToRight&Bottom")
inv_resize.of_Register(dw_bigo,   "ScaleToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_assort.SetTransObject(SQLCA)
dw_spec.SetTransObject(SQLCA)
dw_amat.SetTransObject(SQLCA)
dw_smat.SetTransObject(SQLCA)
dw_sub.SetTransObject(SQLCA)
dw_going.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_label.SetTransObject(SQLCA)
dw_bigo.SetTransObject(SQLCA)
dw_sketch.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
This.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
dw_body.InsertRow(0)
dw_head.setitem(1,"style_no",gsv_cd.gs_cd10)
end event

event ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_sub.AcceptText() <> 1 then return

il_rows = dw_sub.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	This.Trigger Event ue_init(dw_sub)
	dw_sub.ScrollToRow(il_rows)
	dw_sub.SetColumn(ii_min_column_id)
	dw_sub.SetFocus()
end if

This.Trigger Event ue_msg(2, il_rows)

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.01																  */	
/* 수정일      : 2002.02.01																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row
decimal	ldc_sub_price

ll_cur_row = dw_sub.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_sub.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_sub.DeleteRow (ll_cur_row)

ldc_sub_price = dw_sub.Getitemnumber(1,'sub_price')
if ldc_sub_price < 0 then ldc_sub_price = 0 
dw_body.setitem(1,'etc_price',ldc_sub_price)

dw_sub.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.01                                                  */	
/* 수정일      : 2002.02.01                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_rows1, ll_rows2, ll_rows3, ll_make_price
datetime ld_datetime 
String ls_cust_cd, ls_ord_ymd, ls_dlvy_ymd, ls_ErrMsg, ls_make_type, ls_factory_cd, ls_country_cd, ls_sojae, ls_make_ymd, ls_design_agree, ls_ord_ymd1, ls_dlvy_ymd1
string ls_yymmdd, ls_brand
decimal ldc_size_spec
dwItemStatus l_status
   
IF dw_body.AcceptText()   <> 1 THEN RETURN -1
IF dw_assort.AcceptText() <> 1 THEN RETURN -1
IF dw_sub.AcceptText()    <> 1 THEN RETURN -1
IF dw_label.AcceptText()   <> 1 THEN RETURN -1
IF dw_spec.AcceptText()   <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_brand = dw_body.GetItemString(1, "brand") 
ls_ord_ymd = dw_body.getitemstring(1,"ord_ymd")
ls_dlvy_ymd = dw_body.getitemstring(1,"dlvy_ymd")
ls_country_cd = dw_body.getitemstring(1,"country_cd")
ls_factory_cd = dw_body.getitemstring(1,"factory_cd")
ls_make_ymd = dw_body.getitemstring(1,"make_ymd")
ls_sojae = dw_body.getitemstring(1,"sojae")
ls_design_agree = dw_body.getitemstring(1,"design_agree")


select isnull(ord_ymd,'XXXXXXXX'), isnull(dlvy_ymd,'XXXXXXXX')
into :ls_ord_ymd1, :ls_dlvy_ymd1
from tb_12021_d (nolock)
where style = :is_style
and   chno  = :is_chno;


//20250718 민아영
//if ls_country_cd <> "00"  then 
//	if isnull(ls_factory_cd) or ls_factory_cd = "" then
//		messagebox("주의","생산공장명을 입력하세요..")
//		dw_body.setfocus()
//		dw_body.setcolumn("factory_cd")
////		Return 1		
//	end if
//end if


If gf_datechk(ls_ord_ymd) = true and ls_ord_ymd1 <> ls_ord_ymd Then 

	select t_date into :ls_yymmdd from tb_date where t_date = :ls_ord_ymd and t_date >= convert(char(08), getdate(),112);
	if ls_yymmdd = "" or isnull(ls_yymmdd) then 
		messagebox("주의","투입일이 과거일자이거나 올바른 날짜가 아닙니다..")
		dw_body.setfocus()
		dw_body.setcolumn("ord_ymd")				
		return 1	
	end if
	

End if

If gf_datechk(ls_dlvy_ymd) = true and ls_dlvy_ymd1 <> ls_dlvy_ymd Then  

	select t_date into :ls_yymmdd from tb_date where t_date = :ls_dlvy_ymd and t_date >= convert(char(08), getdate(),112);
	if ls_yymmdd = "" or isnull(ls_yymmdd) then 
		messagebox("주의","납기일이 과거일자이거나 올바른 날짜가 아닙니다..")
		dw_body.setfocus()
		dw_body.setcolumn("dlvy_ymd")				
		return 1	
	end if

End if

/*
If not gf_datechk(ls_dlvy_ymd) or isnull(ls_dlvy_ymd) Then 
	messagebox("주의","납기일을 입력하세요..")
	dw_body.setfocus()
	dw_body.setcolumn("dlvy_ymd")
	Return 1
End if
*/
if ls_design_agree <> "Y" then
	If gf_datechk(ls_make_ymd + '01') = false or isnull(ls_make_ymd)  Then 
		messagebox("주의","제조년월을 입력하세요..")
		dw_body.setfocus()
		dw_body.setcolumn("ls_make_ymd")
		Return 1
	End if
end if	

ll_make_price = dw_body.getitemdecimal(1,"make_price")
ls_make_type  = dw_body.getitemstring(1,"make_type")
//if is_brand <> 'T' and ll_make_price <> 0 and ls_make_type = '10' then
  if is_brand <> 'D' and is_brand <> 'J' and is_brand <> 'V' and is_brand <> 'Y' and is_brand <> 'Q' and is_brand <> 'R' and is_brand <> 'E' and ll_make_price <> 0  then
		for i = 1 to dw_spec.rowcount()
			if ldc_size_spec = 0 or isnull(ldc_size_spec) then 	
				ldc_size_spec = dw_spec.getitemdecimal(i,"size_spec_1")	
				if ldc_size_spec = 0 or isnull(ldc_size_spec) then 
					ldc_size_spec = dw_spec.getitemdecimal(i,"size_spec_2")
					if ldc_size_spec = 0 or isnull(ldc_size_spec) then 	
						ldc_size_spec = dw_spec.getitemdecimal(i,"size_spec_3")
						if ldc_size_spec = 0 or isnull(ldc_size_spec) then 
							ldc_size_spec = dw_1.getitemdecimal(i,"size_spec")
						end if
					end if
				end if		
			end if
		next 

//	if (ldc_size_spec = 0 or isnull(ldc_size_spec)) and (ls_make_type<>'40' or isnull(ls_make_type)) then 
	if (ldc_size_spec = 0 or isnull(ldc_size_spec)) and ls_sojae <> 'X' and ls_brand <> 'K' and ls_brand <> 'G'  then 
		messagebox("주의","임가공제품은 제품치수를 입력해 주세요..")
		return 1
	end if

end if




ll_row_count = dw_sub.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_sub.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_sub.Setitem(i, "style", is_style)
      dw_sub.Setitem(i, "chno", is_chno)
      dw_sub.Setitem(i, "brand",  dw_body.GetItemString(1, "brand") )
      dw_sub.Setitem(i, "year",   dw_body.GetItemString(1, "year")  )
      dw_sub.Setitem(i, "season", dw_body.GetItemString(1, "season"))
      dw_sub.Setitem(i, "sojae",  dw_body.GetItemString(1, "sojae") )
      dw_sub.Setitem(i, "item",   dw_body.GetItemString(1, "item")  )
      dw_sub.Setitem(i, "reg_id", gs_user_id)
		dw_body.SetItem(1, "etc_price", dw_sub.GetItemDecimal(ll_row_count, "sub_price") )
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_sub.Setitem(i, "mod_id", gs_user_id)
      dw_sub.Setitem(i, "mod_dt", ld_datetime)
		dw_body.SetItem(1, "etc_price", dw_sub.GetItemDecimal(ll_row_count, "sub_price") )
	END IF
NEXT

idw_status = dw_body.GetItemStatus(1, 0, Primary!)
IF idw_status = DataModified! THEN		/* Modify Record */
	dw_body.Setitem(1, "mod_id", gs_user_id)
	dw_body.Setitem(1, "mod_dt", ld_datetime)
END IF

 
 wf_tab_update(ld_datetime, ls_ErrMsg) 


il_rows  = dw_label.Update(TRUE, FALSE)
il_rows  = dw_body.Update(TRUE, FALSE)
ll_rows1 = dw_assort.Update(TRUE, FALSE)
ll_rows2 = dw_sub.Update(TRUE, FALSE)
ll_rows3 = dw_1.Update(TRUE, FALSE)  // size_spec


if il_rows = 1 and ll_rows1 = 1 And ll_rows2 = 1   And ll_rows3 = 1 then
   dw_body.ResetUpdate()
   dw_assort.ResetUpdate()
	dw_1.ResetUpdate()
   dw_sub.ResetUpdate()

	//////모링꽁뜨 작지 자동생성////////
//	if is_brand = 'O' then 
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
	  
	////////////////////////////////////////////////////
 	commit  USING SQLCA;
	
	
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
 

else
	If il_rows = 1 Then il_rows = -1
   rollback USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_31001_e","0")
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

type cb_close from w_com010_e`cb_close within w_31001_e
end type

type cb_delete from w_com010_e`cb_delete within w_31001_e
integer x = 2121
string text = "SKETCH"
end type

event cb_delete::clicked;IF dw_sketch.visible then
	dw_sketch.visible = false
else
	dw_sketch.visible = true
end if

end event

type cb_insert from w_com010_e`cb_insert within w_31001_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_31001_e
end type

type cb_update from w_com010_e`cb_update within w_31001_e
end type

type cb_print from w_com010_e`cb_print within w_31001_e
boolean visible = false
integer x = 1088
end type

type cb_preview from w_com010_e`cb_preview within w_31001_e
integer x = 1431
string text = "작지출력"
end type

event cb_preview::clicked;dw_print.dataobject = "d_12010_r01"
dw_print.SetTransObject(SQLCA)



Parent.Trigger Event ue_preview()
end event

type gb_button from w_com010_e`gb_button within w_31001_e
end type

type cb_excel from w_com010_e`cb_excel within w_31001_e
integer x = 1774
string text = "생산의뢰서"
end type

event cb_excel::clicked;dw_print.dataobject = "d_12020_r00"
dw_print.SetTransObject(SQLCA)



Parent.Trigger Event ue_preview()
end event

type dw_head from w_com010_e`dw_head within w_31001_e
integer y = 152
integer height = 104
string dataobject = "d_31001_h01"
end type

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.01                                                  */	
/* 수정일      : 2002.02.01                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "mat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

END CHOOSE

end event

event dw_head::buttonclicked;call super::buttonclicked;string ls_style_no, ls_style, ls_chno

ls_style_no = this.getitemstring(1,"style_no")
ls_style = MidA(ls_style_no, 1, 8)
ls_chno  = MidA(ls_style_no, 9, 1)


insert into tb_12023_d(
	style,		chno,		spec_fg,
	spec_cd,		size,		size_spec,	
	spec_term,	reg_id,	reg_dt
	)
select  
	b.style,	b.chno,		a.spec_fg,
	a.spec_cd,	b.size,		a.size_spec,	
	a.spec_term,	a.reg_id,	a.reg_dt
from (select * from tb_12023_d (nolock)
	where style = :ls_style
	and   chno  in ('0','S')) a, 
     (select distinct style, chno, size from tb_12024_d (nolock) 
	where style = :ls_style) b
where a.style =  b.style
and   a.size  =  b.size
and   not exists (select * from tb_12023_d (nolock)
		where style = b.style
		and   chno  = b.chno
		and   size  = b.size)
order by b.style, b.chno, b.size



commit USING SQLCA;
end event

type ln_1 from w_com010_e`ln_1 within w_31001_e
integer beginy = 256
integer endy = 256
end type

type ln_2 from w_com010_e`ln_2 within w_31001_e
integer beginy = 260
integer endy = 260
end type

type dw_body from w_com010_e`dw_body within w_31001_e
integer y = 272
integer width = 3383
integer height = 788
boolean enabled = false
string dataobject = "d_31001_d01"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_body::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.01                                                  */	
/* 수정일      : 2002.02.01                                                  */
/*===========================================================================*/
 string ls_yymmdd, ls_make_ymd, ls_make_ymd2, ls_ord_ymd
 
 
CHOOSE CASE dwo.name
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN 			RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	
		
		
	case "fix_dlvy"
		if data <> ""  then
			select t_date into :ls_yymmdd from tb_date where t_date = :data; 
			if ls_yymmdd = "" or isnull(ls_yymmdd) then 
				messagebox("확인","날자를 올바로 입력하세요..")
				this.setfocus()
				this.setcolumn("fix_dlvy")
				
				return -1
					
			end if
			
				
			
		end if
	case "dlvy_ymd"
		if data <> ""  then
			ls_make_ymd = this.getitemstring(1, "make_ymd")
			select t_date into :ls_yymmdd from tb_date where t_date = :data; 
			if ls_yymmdd = "" or isnull(ls_yymmdd) then 
				messagebox("확인","날자를 올바로 입력하세요..")
				this.setfocus()
				this.setcolumn("dlvy_ymd")					
				return -1
			else
				 if ls_make_ymd = "" or isnull(ls_make_ymd) then 	
					
					 select left(convert(char(8), dateadd(day, -15, :ls_yymmdd), 112),6)
					 into :ls_make_ymd
					 from dual;			
					 
					 this.setitem(1, "make_ymd", ls_make_ymd)		
					
				 end if 	 

			end if
		end if
		
case "ord_ymd"
		if data <> ""  then
			select t_date into :ls_yymmdd from tb_date where t_date = :data and t_date >= convert(char(08), getdate(),112); 
			if ls_yymmdd = "" or isnull(ls_yymmdd) then 
				messagebox("확인","과거일자이거나 올바른 날짜가 아닙니다..")
				this.setfocus()
				this.setcolumn("ord_ymd")				
				return -1
			end if
			
		end if
				
		
END CHOOSE



	ib_changed = true
	cb_update.enabled = true
	cb_print.enabled = false
	cb_preview.enabled = false
	cb_excel.enabled = false		

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("country_cd", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('000')

This.GetChild("pay_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('007')

this.getchild("fabric_by",idw_fabric_by)
idw_fabric_by.settransobject(sqlca)
idw_fabric_by.retrieve('214')

This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('003', gs_brand, '%')
end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
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

type dw_print from w_com010_e`dw_print within w_31001_e
string dataobject = "d_12020_r00"
end type

type tab_1 from tab within w_31001_e
integer x = 5
integer y = 1084
integer width = 3589
integer height = 944
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean focusonbuttondown = true
boolean showpicture = false
boolean boldselectedtext = true
alignment alignment = center!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.tabpage_8=create tabpage_8
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_7,&
this.tabpage_8}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
destroy(this.tabpage_8)
end on

event selectionchanged;Choose Case newindex
	Case 1
		dw_assort.Visible = True
		dw_spec.Visible   = False
		dw_amat.Visible   = False
		dw_smat.Visible   = False
		dw_sub.Visible    = False
		dw_going.Visible  = False
		dw_bigo.Visible  = False
		If ib_tab1_chk = False Then
			dw_assort.Retrieve(is_style, is_chno)
			ib_tab1_chk = True
		End If
	Case 2
		dw_assort.Visible = False
		dw_spec.Visible   = True
		dw_amat.Visible   = False
		dw_smat.Visible   = False
		dw_sub.Visible    = False
		dw_going.Visible  = False
		dw_bigo.Visible  = False
		dw_1.Retrieve(is_style, is_chno)
		wf_set_size() 
		wf_display_spec()
	
	
	Case 3
		dw_assort.Visible = False
		dw_spec.Visible   = False
		dw_amat.Visible   = True
		dw_smat.Visible   = False
		dw_sub.Visible    = False
		dw_going.Visible  = False
		dw_bigo.Visible  = False
		If ib_tab3_chk = False Then
			dw_amat.Retrieve(is_style, is_chno)
			ib_tab3_chk = True
		End IF
	Case 4
		dw_assort.Visible = False
		dw_spec.Visible   = False
		dw_amat.Visible   = False
		dw_smat.Visible   = True
		dw_sub.Visible    = False
		dw_going.Visible  = False
		dw_bigo.Visible  = False
		If ib_tab4_chk = False Then
			dw_smat.Retrieve(is_style, is_chno)
			ib_tab4_chk = True
		End If
	Case 5
		dw_assort.Visible = False
		dw_spec.Visible   = False
		dw_amat.Visible   = False
		dw_smat.Visible   = False
		dw_sub.Visible    = True
		dw_going.Visible  = False
		dw_bigo.Visible  = False
		If ib_tab5_chk = False Then
			dw_sub.Retrieve(is_style, is_chno)
			ib_tab5_chk = True
		End If
	Case 6
		dw_assort.Visible = False
		dw_spec.Visible   = False
		dw_amat.Visible   = False
		dw_smat.Visible   = False
		dw_sub.Visible    = False
		dw_going.Visible  = True
		dw_bigo.Visible   = False
		If ib_tab6_chk    = False Then
			dw_going.Retrieve(is_brand, is_year, is_season)
			ib_tab6_chk = True
		End If
	Case 7
		dw_assort.Visible = False
		dw_spec.Visible   = False
		dw_amat.Visible   = False
		dw_smat.Visible   = False
		dw_sub.Visible    = False
		dw_going.Visible  = false
		dw_bigo.Visible   = true
		If ib_tab7_chk = False Then
			il_rows = dw_bigo.Retrieve(is_style, is_chno)
			if il_rows = 0 then	dw_bigo.insertrow(0)
			
			ib_tab7_chk = True
		End If
		
End Choose


end event

event selectionchanging;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.08                                                  */	
/* 수정일      : 2001.01.08                                                  */
/*===========================================================================*/

if oldindex < 1 then return 0

CHOOSE CASE oldindex 

	CASE 2 
		IF dw_spec.AcceptText() <> 1 THEN RETURN 1
	
END CHOOSE

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 832
long backcolor = 79741120
string text = "Assort"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 832
long backcolor = 79741120
string text = "완성제품치수"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 832
long backcolor = 79741120
string text = "원자재요척"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 832
long backcolor = 79741120
string text = "부자재요척"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 832
long backcolor = 79741120
string text = "Sub공정"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 832
long backcolor = 79741120
string text = "진행내역"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_8 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 832
long backcolor = 79741120
string text = "수정사항"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type dw_sub from u_dw within w_31001_e
event ue_keydown pbm_dwnkey
event set_etc_price ( )
boolean visible = false
integer x = 18
integer y = 1184
integer width = 3557
integer height = 828
integer taborder = 11
boolean enabled = false
string dataobject = "d_31001_d07"
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
		Parent.Trigger Event ue_popup2 (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event set_etc_price();dw_body.setitem(1,"etc_price",dw_sub.getitemnumber(1,"sub_price"))
end event

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

This.GetChild("sub_job", idw_sub_job)
idw_sub_job.SetTransObject(SQLCA)
idw_sub_job.Retrieve('310')

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

MessageBox(parent.title, ls_message_string)
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
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.01                                                  */	
/* 수정일      : 2002.02.01                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE dwo.name
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup2(dwo.name, row, data, 1)
	CASE "ord_ymd", "dlvy_ymd"
		IF gf_datechk(data) = False Then RETURN 1
	case "price"
		post event set_etc_price()
END CHOOSE




end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.02.01                                                  */	
/* 수정일      : 2001.02.01                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

If ls_column_nm = "insert_row" Then
	Parent.Trigger Event ue_insert()
	Return
ElseIf ls_column_nm = "delete_row" Then
	Parent.Trigger Event ue_delete()
	Return
End If

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Parent.Trigger Event ue_popup2 (ls_column_nm, row, ls_column_value, 2)

end event

event itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

//CHOOSE CASE ls_column_name
//	CASE "cust_cd"
//		ls_helpMsg = "▶ ※ 거래처 코드를 입력하세요! "
//	CASE ELSE
//		ls_helpMsg = " "
//END CHOOSE
//
//Parent.SetMicroHelp(ls_helpMsg)

end event

event itemerror;return 1
end event

type dw_going from u_dw within w_31001_e
integer x = 18
integer y = 1184
integer width = 3557
integer height = 828
integer taborder = 11
boolean enabled = false
string dataobject = "d_31001_d08"
end type

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_amat from u_dw within w_31001_e
boolean visible = false
integer x = 18
integer y = 1184
integer width = 3557
integer height = 828
integer taborder = 11
boolean enabled = false
string dataobject = "d_31001_d05"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_label from datawindow within w_31001_e
integer x = 3392
integer y = 272
integer width = 206
integer height = 788
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_12010_d14"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

type dw_bigo from datawindow within w_31001_e
integer x = 18
integer y = 1184
integer width = 3557
integer height = 828
integer taborder = 40
string title = "none"
string dataobject = "d_12020_d09"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_smat from u_dw within w_31001_e
boolean visible = false
integer x = 18
integer y = 1184
integer width = 3557
integer height = 828
integer taborder = 11
boolean enabled = false
string dataobject = "d_31001_d06"
end type

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_sketch from datawindow within w_31001_e
boolean visible = false
integer x = 855
integer y = 148
integer width = 2725
integer height = 1868
integer taborder = 40
boolean titlebar = true
string title = "SKETCH"
string dataobject = "d_12010_pic"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_spec from u_dw within w_31001_e
event ue_keydown pbm_keydown
boolean visible = false
integer x = 18
integer y = 1184
integer width = 3557
integer height = 828
integer taborder = 11
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_12010_d03"
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

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)
DataWindowChild ldw_child
 
This.GetChild("spec_fg", ldw_child) 
ldw_child.SetTransObject(SQLCA) 
ldw_child.retrieve('124') 

This.GetChild("spec_cd", ldw_child) 
ldw_child.SetTransObject(SQLCA) 
ldw_child.retrieve('125') 


end event

event editchanged;call super::editchanged;/*===========================================================================*/
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

event itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.08                                                  */	
/* 수정일      : 2001.01.08                                                  */
/*===========================================================================*/
This.TriggerEvent(EditChanged!)

end event

event itemerror;call super::itemerror;return 1
end event

event itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
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

type cb_copy from commandbutton within w_31001_e
integer x = 2624
integer y = 164
integer width = 594
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "완성제품치수 복사"
end type

event clicked;string ls_style_no, ls_style, ls_chno

ls_style_no = dw_head.getitemstring(1,"style_no")
ls_style = MidA(ls_style_no, 1, 8)
ls_chno  = MidA(ls_style_no, 9, 1)


insert into tb_12023_d(
	style,		chno,		spec_fg,
	spec_cd,		size,		size_spec,	
	spec_term,	reg_id,	reg_dt
	)
select  
	b.style,	b.chno,		a.spec_fg,
	a.spec_cd,	b.size,		a.size_spec,	
	a.spec_term,	a.reg_id,	a.reg_dt
from (select * from tb_12023_d (nolock)
	where style = :ls_style
	and   chno  in ('0','S')) a, 
     (select distinct style, chno, size from tb_12024_d (nolock) 
	where style = :ls_style) b
where a.style =  b.style
and   a.size  =  b.size
and   not exists (select * from tb_12023_d (nolock)
		where style = b.style
		and   chno  = b.chno
		and   size  = b.size)
order by b.style, b.chno, b.size



commit USING SQLCA;
end event

type dw_1 from datawindow within w_31001_e
boolean visible = false
integer x = 1481
integer y = 224
integer width = 2030
integer height = 588
integer taborder = 50
boolean titlebar = true
string title = "사이즈"
string dataobject = "d_12010_spec"
boolean controlmenu = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_assort from u_dw within w_31001_e
integer x = 18
integer y = 1184
integer width = 3557
integer height = 828
integer taborder = 11
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_31001_d02"
end type

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

end event

event buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.02.01                                                  */	
/* 수정일      : 2001.02.01                                                  */
/*===========================================================================*/
String ls_column_nm, ls_cust_cd
Long i

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

If ls_column_nm = "copy" Then
	ls_cust_cd = Trim(dw_body.GetItemString(1, "cust_cd"))
	If IsNull(ls_cust_cd) or ls_cust_cd = "" Then
		Messagebox("입력오류", "생산업체를 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("cust_cd")
		Return 
	End If
	
	For i = 1 To This.RowCount()
		This.SetItem(i, "ord_qty", This.GetItemDecimal(i, "plan_qty"))
		This.SetItem(i, "ord_qty_chn", This.GetItemDecimal(i, "plan_qty_chn"))
		This.SetItem(i, "ord_qty_rus", This.GetItemDecimal(i, "plan_qty_rus"))
		This.SetItem(i, "ord_qty_sing", This.GetItemDecimal(i, "plan_qty_sing"))		
	Next
	
	ib_changed = true
	cb_update.enabled = true
	cb_print.enabled = false
	cb_preview.enabled = false
	cb_excel.enabled = false
End If

end event

