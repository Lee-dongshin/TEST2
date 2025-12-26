$PBExportHeader$w_sh350_e.srw
$PBExportComments$실사수기등록(스케너)
forward
global type w_sh350_e from w_com010_e
end type
type dw_color from datawindow within w_sh350_e
end type
type dw_view from datawindow within w_sh350_e
end type
type dw_size from datawindow within w_sh350_e
end type
end forward

global type w_sh350_e from w_com010_e
integer width = 2962
integer height = 2060
string title = "매장실사재고등록"
long backcolor = 16777215
dw_color dw_color
dw_view dw_view
dw_size dw_size
end type
global w_sh350_e w_sh350_e

type variables
DataWindowChild idw_brand,idw_color,idw_size, idw_shop_type
string is_brand, is_yymmdd, is_shop_cd,is_silsa_emp,is_file_nm, is_sil_no, is_shop_type, is_empno


end variables

forward prototypes
public function boolean wf_style_chk (long al_row, string as_style)
end prototypes

public function boolean wf_style_chk (long al_row, string as_style);
String ls_style, ls_chno, ls_color,  ls_size, ls_shop_type, ls_given_fg, ls_given_ymd
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn  
Long   ll_tag_price 

IF LenA(Trim(as_style)) <> 13 THEN RETURN FALSE

ls_style = MidA(as_style, 1, 8)
ls_chno  = MidA(as_style, 9, 1)
ls_color = MidA(as_style, 10, 2)
ls_size  = MidA(as_style, 12, 2)

Select brand,     year,     season,     
       sojae,     item,     tag_price,     plan_yn   
  into :ls_brand, :ls_year, :ls_season, 
       :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
  from vi_12024_1 with (nolock)
 where brand = :gs_brand 
   and style = :ls_style 
	and chno  = :ls_chno
	and color = :ls_color 
	and size  = :ls_size
	and sojae <> 'C' ;


IF SQLCA.SQLCODE <> 0 THEN 
	Return False 
END IF



   dw_body.SetItem(al_row, "style_no", ls_style + ls_chno + ls_color + ls_size )
   dw_body.SetItem(al_row, "style",    ls_style)
	dw_body.SetItem(al_row, "chno",     ls_chno)
	dw_body.SetItem(al_row, "color",    ls_color)
	dw_body.SetItem(al_row, "size",     ls_size)
   dw_body.SetItem(al_row, "price",    ll_tag_price)	
	dw_body.SetItem(al_row, "brand",    ls_brand)
	dw_body.SetItem(al_row, "year",     ls_year)
	dw_body.SetItem(al_row, "season",   ls_season)
	dw_body.SetItem(al_row, "sojae",    ls_sojae)
	dw_body.SetItem(al_row, "item",     ls_item)
	dw_body.SetItem(al_row, "qty",      1)

	



Return True

end function

on w_sh350_e.create
int iCurrent
call super::create
this.dw_color=create dw_color
this.dw_view=create dw_view
this.dw_size=create dw_size
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_color
this.Control[iCurrent+2]=this.dw_view
this.Control[iCurrent+3]=this.dw_size
end on

on w_sh350_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_color)
destroy(this.dw_view)
destroy(this.dw_size)
end on

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "yymmdd",string(ld_datetime, "yyyymmdd"))

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.10.04                                                  */	
/* 수정일      : 2001.10.04                                                  */
/*===========================================================================*/
integer li_FileNum, li_st, li_ed
Long    ll_FileLen,  ll_FileLen2, ll_found
String  ls_data, ls_style, ls_style_chk,  ls_chno, ls_color, ls_size
decimal ldc_tag_price
int li_cnt_err

/* dw_head 필수입력 column check */

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_view.retrieve(is_yymmdd, gs_shop_cd, is_shop_type, is_sil_no, is_silsa_emp)
IF il_rows > 0 THEN
	dw_view.visible = true
   dw_view.SetFocus()
	cb_print.enabled = true
	cb_preview.enabled = true	
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                    */	
/* 작성일      : 2001.10.04                                                  */	
/* 수정일      : 2001.10.04                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

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


	
	is_shop_type = dw_head.GetItemString(1, "shop_type") 
	if IsNull(is_shop_type) or Trim(is_shop_type) = "" then 
		MessageBox(ls_title,"매장형태를 입력하십시요!") 
		dw_head.SetFocus() 
		dw_head.SetColumn("shop_type") 
		return false
	end if
	
	is_yymmdd = dw_head.GetItemString(1, "yymmdd") 
	if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then 
		MessageBox(ls_title,"실사일자를 입력하십시요!") 
		dw_head.SetFocus() 
		dw_head.SetColumn("yymmdd") 
		return false
	end if
	
//	is_sil_no = dw_head.GetItemString(1, "sil_no") 
//	if IsNull(is_sil_no) or Trim(is_sil_no) = "" then 
//		MessageBox(ls_title,"실사일자를 입력하십시요!") 
//		dw_head.SetFocus() 
//		dw_head.SetColumn("yymmdd") 
//		return false
//	end if	
	
	is_silsa_emp = dw_head.GetItemString(1, "silsa_emp") 
	if IsNull(is_silsa_emp) or Trim(is_silsa_emp) = "" then 
		is_silsa_emp = "%"
	end if

	is_sil_no = dw_head.GetItemString(1, "sil_no") 
	if IsNull(is_sil_no) or Trim(is_sil_no) = "" then 
		is_sil_no = "%"
	end if

return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size, ls_shop_nm, ls_emp_nm, ls_brand
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source 
String ls_sale_type = space(2)
Decimal ldc_marjin
Long   ll_tag_price ,ll_curr_price, ll_out_price, ll_dc_rate

CHOOSE CASE as_column
//	CASE "shop_cd"				
//			IF ai_div = 1 THEN 	
//				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
//				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
//					RETURN 0
//				END IF 
//			END IF
//		   gst_cd.ai_div          = ai_div
//			gst_cd.window_title    = "매장 코드 검색" 
//			gst_cd.datawindow_nm   = "d_com912" 
//			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "(SHOP_CD LIKE '" + as_data + "%'   or  SHOP_snm LIKE '%" + as_data + "%') "
//			ELSE
//				gst_cd.Item_where = ""
//			END IF
//
//			lds_Source = Create DataStore
//			OpenWithParm(W_COM200, lds_Source)
//
//			IF Isvalid(Message.PowerObjectParm) THEN
//				ib_itemchanged = True
//				lds_Source = Message.PowerObjectParm
//				dw_head.SetRow(al_row)
//				dw_head.SetColumn(as_column)
//				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
//				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
//				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("yymmdd")
//				ib_itemchanged = False 
//				lb_check = TRUE 
//			ELSE
//				lb_check = FALSE 
//			END IF
//			Destroy  lds_Source
			
	CASE "silsa_emp"				
			IF ai_div = 1 THEN 	
				IF gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
				   dw_head.SetItem(al_row, "emp_nm", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원 정보 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			gst_cd.default_where   = "WHERE goout_gubn = '1' and dept_code in ('5000','5200','K000','K120','T400') "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(empno LIKE '" + as_data + "%'   or  kname LIKE '%" + as_data + "%') "
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
				dw_head.SetItem(al_row, "silsa_emp", lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "emp_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source			


			
		CASE "style_no"		
			IF ai_div = 1 THEN 	
				IF wf_style_chk(al_row, as_data)  THEN
				   ll_row_cnt = dw_body.RowCount()
				   IF al_row = ll_row_cnt THEN 
					   ll_row_cnt = dw_body.insertRow(0)
					   dw_body.SetRow(ll_row_cnt)  
 				      dw_body.SetColumn("style_no")
				   END IF
					RETURN 0 
				END IF 
			END IF
	
		   ls_style = MidA(as_data, 1, 8)
		   ls_chno  = MidA(as_data, 9, 1)
		   ls_color = MidA(as_data, 10, 2)
		   ls_size  = MidA(as_data, 12, 2)
			ls_brand = dw_head.getitemstring(1, "brand")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com012" 
//			if gs_shop_div = "G" then
// 				gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20032' "
//			else	 
 				gst_cd.default_where   = "WHERE brand = '" + gs_brand + "'"				
//			end if	 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" + &
				                " and chno  LIKE '" + ls_chno + "%'" + &
				                " and color LIKE '" + ls_color + "%'" + &
				                " and size  LIKE '" + ls_size + "%'" 
			ELSE
				gst_cd.Item_where = ""
			END IF


			lb_check = FALSE 
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF

				ls_style = lds_Source.GetItemString(1,"style")


				   dw_body.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
				   dw_body.SetItem(al_row, "style",    lds_Source.GetItemString(1,"style"))
				   dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "color",     lds_Source.GetItemString(1,"color"))
				   dw_body.SetItem(al_row, "size",     lds_Source.GetItemString(1,"size"))					
					dw_body.SetItem(al_row, "qty",      1)					
					dw_body.SetItem(al_row, "price",    lds_Source.GetItemNumber(1,"tag_price") )						
				   dw_body.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand"))
				   dw_body.SetItem(al_row, "year",     lds_Source.GetItemString(1,"year"))
				   dw_body.SetItem(al_row, "season",   lds_Source.GetItemString(1,"season"))
				   dw_body.SetItem(al_row, "sojae",    lds_Source.GetItemString(1,"sojae"))
				   dw_body.SetItem(al_row, "item",     lds_Source.GetItemString(1,"item"))
				   dw_body.SetItem(al_row, "color",    lds_Source.GetItemString(1,"color"))
				   dw_body.SetItem(al_row, "size",     lds_Source.GetItemString(1,"size"))
				   ib_changed = true
               cb_update.enabled = true
				   /* 다음컬럼으로 이동 */
				   ll_row_cnt = dw_body.RowCount()
				   IF al_row = ll_row_cnt THEN 
					   ll_row_cnt = dw_body.insertRow(0)
				   END IF
				   dw_body.SetRow(ll_row_cnt)  
				   dw_body.SetColumn("style_no")
					lb_check = TRUE 
					ib_itemchanged = FALSE
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

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_view, "ScaleToRight&Bottom")

dw_size.SetTransObject(SQLCA)
dw_color.SetTransObject(SQLCA)
dw_view.SetTransObject(SQLCA)
end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, li_cnt_err
datetime ld_datetime
string	ls_style_chk, ls_style , ls_year, ls_season , ls_item, ls_sojae, LS_SIL_NO
integer  li_no


ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

	is_sil_no = dw_head.GetItemString(1, "sil_no") 
	if IsNull(is_sil_no) or Trim(is_sil_no) = "" then 
		is_sil_no = "%"
	end if



   IF LenA(is_sil_no) <> 4 then
		select  substring(convert(varchar(5), convert(decimal(5), isnull(max(SIL_no), '0000')) + 10001), 2, 4) 
		into :ls_sil_no
		from tb_44120_h with (nolock)
		where  yymmdd = :is_yymmdd;
		
		li_no = 1
   else
		ls_sil_no = is_sil_no
		
		select max(isnull(no,0)) + 1  
		into :li_no
		from tb_44120_h with (nolock)
		where brand =  :gs_brand
		and   yymmdd = :is_yymmdd
		and   sil_no = :ls_sil_no ;

	end if	


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */

      ls_style = dw_body.getitemstring(i, "style")
		
			select year, season,item, sojae 
			into :ls_year, :ls_season, :ls_item, :ls_sojae
			from tb_12020_m
			where style = :ls_style;


		dw_body.setitem(i, "sil_no"    , ls_sil_no)
      dw_body.Setitem(i, "no"        , li_no)
		dw_body.setitem(i, "year"      , ls_year)
		dw_body.setitem(i, "season"    , ls_season)			
		dw_body.setitem(i, "item"      , ls_item)			
		dw_body.setitem(i, "sojae"     , ls_sojae)					
	   DW_BODY.SETITEM(I, "brand"     , gs_brand)
	   DW_BODY.SETITEM(I, "shop_cd"   , gs_shop_cd)
	   DW_BODY.SETITEM(I, "shop_type" , is_shop_type)
	   DW_BODY.SETITEM(I, "empno"     , is_silsa_emp)
	   DW_BODY.SETITEM(I, "yymmdd"    , is_yymmdd)		
      dw_body.Setitem(i, "reg_id"    , gs_user_id)
		li_no = li_no + 1
   ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT


		il_rows = dw_body.Update(TRUE, FALSE)
		if il_rows = 1 then
			dw_body.ResetUpdate()
			commit  USING SQLCA;
			dw_head.setitem(1, "sil_no", ls_sil_no)
		else
			rollback  USING SQLCA;
		end if


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;//gf_user_connect_pgm(gs_user_id,"w_44002_e","0")
end event

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

is_silsa_emp = dw_head.GetItemString(1, "silsa_emp") 
if IsNull(is_silsa_emp) or Trim(is_silsa_emp) = ""  or LenA(Trim(is_silsa_emp)) <> 6  then 
  	MessageBox("경고","실사담당을 입력하십시요!") 
	dw_head.SetFocus() 
	dw_head.SetColumn("silsa_emp") 
	return  
end if

il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.enabled = True
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)




end event

event ue_preview();This.Trigger Event ue_title ()

dw_view.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()
end event

event ue_print();This.Trigger Event ue_title()

dw_view.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_sh350_e
integer taborder = 130
end type

type cb_delete from w_com010_e`cb_delete within w_sh350_e
integer taborder = 70
end type

type cb_insert from w_com010_e`cb_insert within w_sh350_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh350_e
end type

type cb_update from w_com010_e`cb_update within w_sh350_e
integer taborder = 120
end type

type cb_print from w_com010_e`cb_print within w_sh350_e
integer taborder = 90
end type

type cb_preview from w_com010_e`cb_preview within w_sh350_e
integer taborder = 100
end type

type gb_button from w_com010_e`gb_button within w_sh350_e
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh350_e
integer y = 160
integer width = 2816
integer height = 224
string dataobject = "d_sh350_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"      // dddw로 작성된 항목

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
   CASE "silsa_emp"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
			
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_sh350_e
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_e`ln_2 within w_sh350_e
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_e`dw_body within w_sh350_e
event ue_set_column ( long al_row )
integer x = 14
integer y = 400
integer width = 2875
integer height = 1420
string dataobject = "d_sh350_D01"
boolean controlmenu = true
boolean hscrollbar = true
end type

event dw_body::ue_set_column(long al_row);/* 품번 키보드 및 스캐너 입력시 다음 line으로 이동 */

dw_body.SetRow(al_row + 1)  
dw_body.SetColumn("style_no")

end event

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)


  This.GetChild("color", idw_color )
  idw_color.SetTransObject(SQLCA)
  
  This.GetChild("size", idw_size )
  idw_color.SetTransObject(SQLCA)
end event

event dw_body::itemchanged;call super::itemchanged;
string ls_style, ls_chno, ls_color, ls_size
decimal ldc_qty, ldc_amt
integer li_ret

CHOOSE CASE dwo.name
	CASE "style_no" 
		IF ib_itemchanged THEN RETURN 1
		li_ret =	Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
     	dw_body.Setitem(row, "amt", dw_body.getitemdecimal(row, "price") * dw_body.getitemdecimal(row, "qty"))
		IF li_ret <> 1 THEN
			This.Post Event ue_set_column(row) 
		END IF		  
		return li_ret
	CASE "qty"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
     	dw_body.Setitem(row, "amt", dw_body.getitemdecimal(row, "price") * dec(data))
END CHOOSE

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;string DWfilter, ls_style, ls_chno, ls_color,ls_year,ls_season, ls_item, ls_sojae, ls_type,ls_style_chk, ls_size
long     i, j, ll_row_count, ll_row, li_ret
decimal ldc_tag_price

ls_style = dw_body.getitemstring(row, "style")
ls_chno = dw_body.getitemstring(row, "chno")
ls_color = dw_body.getitemstring(row, "color")
ls_size = dw_body.getitemstring(row, "size")


CHOOSE CASE dwo.name

	
	case "chno"	
		ls_style = dw_body.getitemstring(row, "style")		
		gf_first_price(ls_style, ldc_tag_price)		
		dw_body.Setitem(row, "price", ldc_tag_price)
   	dw_body.Setitem(row, "amt", ldc_tag_price * dw_body.getitemdecimal(row, "qty"))
		
	CASE "color" 
		ls_style = dw_body.getitemstring(row, "style")
		ls_chno  = dw_body.getitemstring(row, "chno")	
		
		il_rows = dw_color.retrieve(ls_style, ls_chno)
		
			if il_rows > 0 then
				FOR i=1 TO il_rows
					  if i = il_rows then
						  ls_Type = ls_Type + "color = " +  "'" +  dw_color.getitemstring(i, "color") + "'"
					else
						  ls_Type = ls_Type + "color = " +  "'" +  dw_color.getitemstring(i, "color") + "'" + " or "
					end if	  
				next	
					 DWfilter = ls_Type
			END IF
			  idw_color.SetFilter(DWfilter)
			  idw_color.Filter()
		  
CASE "size"
	 
		ls_style = dw_body.getitemstring(row, "style")
		ls_chno  = dw_body.getitemstring(row, "chno")	
		ls_color = dw_body.getitemstring(row, "color")	
		
		il_rows = dw_size.retrieve(ls_style, ls_chno, ls_color)
		
			if il_rows > 0 then
				FOR i=1 TO il_rows
					  if i = il_rows then
						  ls_Type = ls_Type + "size = " +  "'" +  dw_size.getitemstring(i, "size") + "'"
					else
						  ls_Type = ls_Type + "size = " +  "'" +  dw_size.getitemstring(i, "size") + "'" + " or "
					end if	  
				next	
							
				 DWfilter = ls_Type
				
		  END IF
		  
		  idw_size.SetFilter(DWfilter)
		  idw_size.Filter()
	


END CHOOSE


end event

type dw_print from w_com010_e`dw_print within w_sh350_e
integer x = 2510
integer y = 1464
string dataobject = "d_sh350_r01"
end type

type dw_color from datawindow within w_sh350_e
boolean visible = false
integer x = 2738
integer y = 928
integer width = 411
integer height = 432
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_sh350_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_view from datawindow within w_sh350_e
boolean visible = false
integer x = 9
integer y = 392
integer width = 2889
integer height = 1436
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "실사내역조회"
string dataobject = "d_sh350_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;String ls_sil_no, ls_empno

IF row < 0 THEN RETURN 

ls_sil_no    = This.GetitemString(row, "sil_no")
ls_empno     = This.GetitemString(row, "empno")


IF dw_body.Retrieve(gs_brand, gs_shop_cd, is_yymmdd, ls_empno, is_shop_type, ls_sil_no) > 0 THEN 
   dw_body.visible = True						  
   dw_view.visible = False 
	cb_insert.Enabled = True
	dw_body.SetFocus()
	dw_head.setitem(1, "sil_no", ls_sil_no)
	dw_head.setitem(1, "silsa_emp", upper(ls_empno))	
END IF

end event

event constructor;DataWindowChild ldw_color

 This.GetChild("color", ldw_color )
 ldw_color.SetTransObject(SQLCA)
end event

type dw_size from datawindow within w_sh350_e
boolean visible = false
integer x = 3141
integer y = 944
integer width = 411
integer height = 432
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_sh350_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

