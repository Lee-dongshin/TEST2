$PBExportHeader$w_42063_e.srw
$PBExportComments$유통불량등록
forward
global type w_42063_e from w_com010_e
end type
type dw_list from datawindow within w_42063_e
end type
end forward

global type w_42063_e from w_com010_e
integer width = 3680
integer height = 2276
boolean righttoleft = true
dw_list dw_list
end type
global w_42063_e w_42063_e

type variables
DataWindowChild idw_brand, idw_shop_type, idw_color, idw_tran_cust
String is_brand, is_yymmdd, is_shop_cd, is_shop_type
end variables

forward prototypes
public function boolean wf_out_chk (long al_row, string as_style_no)
public function boolean wf_stock_chk (long al_row, string as_style_no)
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

public function boolean wf_out_chk (long al_row, string as_style_no);String ls_style, ls_chno, ls_color, ls_size , ls_find
Long   ll_out_qty, ll_cnt_stop, ll_row_count, i, k, ll, ll_chk_qty

IF LenA(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)

//select isnull(sum(isnull(qty,0)),0)
//  into :ll_out_qty
//  from tb_42020_h (nolock)
// where yymmdd >= convert(char(08), dateadd(day, -4, :is_yymmdd) ,112)
// and   shop_cd = :is_shop_cd
// and   shop_type < '9' 
// and   style = :ls_style
// and   chno  = :ls_chno
// and   color = :ls_color
// and   size  = :ls_size;
//
//
//IF sqlca.sqlcode <> 0 THEN 
//	MessageBox("SQL 오류", SQLCA.SQLERRTEXT) 
//	RETURN FALSE 
//end if

//messagebox("ll_out_qty", string(ll_out_qty, '0000'))


//IF ll_out_qty <= 0 THEN 
//	MessageBox("확인",  "출고내역이 없는 스타일은 요청할 수 없습니다!") 
//	dw_body.setitem(al_row, "style_no", "")
//	RETURN FALSE 
//END IF

//dw_body.Setitem(al_row, "qty", 1)

Return True
end function

public function boolean wf_stock_chk (long al_row, string as_style_no);String ls_style, ls_chno, ls_color, ls_size , ls_find, ls_shop_type
Long   ll_stock_qty, ll_cnt_stop, ll_row_count, i, k, ll, ll_chk_qty

IF LenA(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)


//IF wf_out_chk(al_row, as_style_no) = false THEn 	
//	RETURN FALSE 
//else	
//
//  if mid(ls_style,5,1) = "Z" then 
//	  ls_shop_type = "3"
//  else	  
//     ls_shop_type = "1"	
//  end if	  
//
//	select dbo.sf_get_stockqty(:is_shop_cd, :ls_shop_type, :ls_style, :ls_chno, :ls_color, :ls_size)
//	  into :ll_stock_qty
//	  from dual;	
//	  
//	IF sqlca.sqlcode <> 0 THEN 
//		MessageBox("SQL 오류", SQLCA.SQLERRTEXT) 
//		RETURN FALSE 
//	end if	  
//	
//	ll_row_count = dw_body.rowcount() 
//	
//	for i = 1 to ll_row_count - 1
//		ls_find = "style_no = '" + ls_style + ls_chno +  ls_color + ls_size + "'"
//		
//		if i <> al_row then
//			k = dw_body.find(ls_find, 1, ll_row_count)		
//		end if
//		
//		if k <> 0 then
//		 ll = dw_body.getitemnumber(k, "qty")
//		end if
//	
//	//   messagebox("ll_stock_qty", string(ll_stock_qty))
//		
//		ll_stock_qty = ll_stock_qty + ll
//	next  
//	

	
//	if mid(is_shop_cd,2,1) = "D" then 
//		IF ll_stock_qty <= 0 THEN 
//		MessageBox("확인", "재고가 없는 스타일은 요청할 수 없습니다!") 
//		dw_body.setitem(al_row, "style_no", "")
//		RETURN FALSE 
//		END IF
//	else	
//		IF ll_stock_qty <= 0 THEN 
//			MessageBox("확인",  "재고가 없는 스타일은 요청할 수 없습니다!") 
//			dw_body.setitem(al_row, "style_no", "")
//			RETURN FALSE 
//		END IF
//	end if
	  
	
	

	
	dw_body.Setitem(al_row, "qty", 1)
//end if	

Return True
end function

public function boolean wf_style_chk (long al_row, string as_style_no);String ls_style, ls_chno, ls_color,  ls_size, ls_shop_type, ls_bujin_chk
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn  
Long   ll_tag_price 

IF LenA(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)

Select brand,     year,     season,     
       sojae,     item,     plan_yn, dep_fg   
  into :ls_brand, :ls_year, :ls_season, 
       :ls_sojae, :ls_item, :ls_plan_yn, :ls_bujin_chk    
  from vi_12024_1 
 where style   = :ls_style 
	and chno    = :ls_chno
	and color   = :ls_color 
	and size    = :ls_size ;

IF SQLCA.SQLCODE <> 0 THEN 
	MessageBox("SQL 오류", SQLCA.SQLERRTEXT)
	RETURN FALSE 
END IF

IF ls_plan_yn = 'Y' and is_shop_type <> '3' THEN 
	MessageBox("확인", "기획 품번은 기획매장에서만 의뢰할수 없습니다!")
	RETURN FALSE 
END IF
//
//IF ls_bujin_chk = 'Y' THEN 
//	MessageBox("확인", "부진 품번은 의뢰할수 없습니다!")
//	RETURN FALSE 
//END IF
//  
//Select shop_type
//into :ls_shop_type
//From tb_56012_d with (nolock)
//Where style      = :ls_style 
//  and start_ymd <= :is_yymmdd
//  and end_ymd   >= :is_yymmdd
//  and shop_cd    = :gs_shop_cd ;
//
//if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
//	ls_shop_type = "1"
//end if	
//
//if ls_shop_type > "3"  then 
//	messagebox("경고!", "행사 품번은 의뢰할수 없습니다!")
//	return false
//end if	

IF wf_stock_chk(al_row, as_style_no) THEN 
   dw_body.SetItem(al_row, "style_no", as_style_no)
   dw_body.SetItem(al_row, "style",    ls_style)
	dw_body.SetItem(al_row, "chno",     ls_chno)
	dw_body.SetItem(al_row, "color",    ls_color)
	dw_body.SetItem(al_row, "size",     ls_size)
	dw_body.SetItem(al_row, "brand",    ls_brand)
ELSE
	Return False
END IF

Return True
end function

on w_42063_e.create
int iCurrent
call super::create
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
end on

on w_42063_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
end on

event pfc_preopen();call super::pfc_preopen;//inv_resize.of_Register(dw_head, "ScaleToRight")

inv_resize.of_Register(dw_list, "ScaleToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)

end event

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
   return false
end if


is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"등록일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
 is_shop_cd = "%"
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")


return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
String ls_shop_nm

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(This.title)
		CASE 1
			IF This.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			dw_body.SetFocus()
			RETURN
	END CHOOSE
END IF

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_yymmdd, is_shop_cd, is_shop_type)
IF il_rows > 0 THEN
	dw_list.Visible = True
	dw_body.Visible = False
   dw_list.SetFocus()	
else
	dw_body.reset()
	Trigger Event ue_insert()
   dw_body.SetFocus()		
	
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
String 	  ls_plan_yn, ls_SHOP_TYPE,ls_work_gubn, ls_color, ls_size
Boolean    lb_check 
long 			ll_row_cnt
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm3(as_data, 'S', ls_shop_nm) = 0 THEN
					
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV  IN ('G', 'K', 'X') " + &
											 "  AND BRAND = '" + ls_brand + "'"
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
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
	CASE "style_no"		
			IF ai_div = 1 THEN 	
				IF wf_style_chk(al_row, as_data)  THEN
				   ll_row_cnt = dw_body.RowCount()
				   IF al_row = ll_row_cnt THEN 
					   ll_row_cnt = dw_body.insertRow(0)
				   END IF
					RETURN 0 
				END IF 
			END IF
		   ls_style = MidA(as_data, 1, 8)
		   ls_chno  = MidA(as_data, 9, 1)
		   ls_color = MidA(as_data, 10, 2)
		   ls_size  = MidA(as_data, 12, 2)
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com012" 
			gst_cd.default_where   = "WHERE brand = '" + is_brand + "' "
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
				
//				Select shop_type
//				into :ls_shop_type
//				From tb_56012_d with (nolock)
//				Where style      = :ls_style 
//				  and start_ymd <= :is_yymmdd
//				  and end_ymd   >= :is_yymmdd
//				  and shop_cd    = :gs_shop_cd ;
//
//				
//				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
//					ls_shop_type = "1"
//				end if	
//			
//				
//				if ls_shop_type > "3" then 
//					messagebox("경고!", "행사 품번은 의뢰할수 없습니다!")
//					ib_itemchanged = FALSE
//					return 1					
//				end if	
//				
//				ls_bujin_chk = lds_Source.GetItemString(1,"style_no")
//				
//				if ls_bujin_chk =  "Y" then 
//					messagebox("경고!", "부진 품번은 의뢰할수 없습니다!")
//					ib_itemchanged = FALSE
//					return 1					
//				end if	

				if MidA(ls_style,5,1) = "Z" and is_shop_type <> "3" then 
					messagebox("경고!", "기획 품번은 의뢰할수 없습니다!")
					ib_itemchanged = FALSE
					return 1					
				end if	
				
 				IF wf_stock_chk(al_row, lds_Source.GetItemString(1,"style_no")) THEN 
				   dw_body.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
				   dw_body.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				   dw_body.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "color", lds_Source.GetItemString(1,"color"))
				   dw_body.SetItem(al_row, "size", lds_Source.GetItemString(1,"size"))
				   dw_body.SetItem(al_row, "brand", lds_Source.GetItemString(1,"brand"))
				   ib_changed = true
               cb_update.enabled = true
				   /* 다음컬럼으로 이동 */
//				   ll_row_cnt = dw_body.RowCount()
//				   IF al_row = ll_row_cnt THEN 
//					   ll_row_cnt = dw_body.insertRow(0)
//				   END IF
//				   dw_body.SetRow(ll_row_cnt)  
				   dw_body.SetColumn("reason")
			      lb_check = TRUE 

				else	
				   dw_body.SetColumn("style_no")
				END IF
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

event type long ue_update();call super::ue_update;long i, ll_row_count, li_no
datetime ld_datetime
string ls_yymmdd, LS_STYLE_NO, ls_reason, ls_tran_cust

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_yymmdd = string(ld_datetime, "YYYYMMDD")


select max(no)
into :li_no
from tb_42042_h (nolock)
where yymmdd = :is_yymmdd
and   Shop_CD = :is_shop_cd
and   Shop_Type = :is_shop_type;

if isnull(li_no) then li_no = 0

fOR i=1 TO ll_row_count
	idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	LS_STYLE_NO = DW_BODY.GETITEMSTRING(I, "STYLE_NO")
	ls_reason	= DW_BODY.GETITEMSTRING(I, "reason")
	ls_tran_cust = DW_BODY.GETITEMSTRING(I, "tran_cust")	 
	
	if isnull(ls_style_no) = false and (isnull(ls_reason) or LenA(ls_reason) < 2) then 
		messagebox("알림!", "반품사유가 정확하지 않아 저장할 수 없습니다!")
		return -1
	end if	
	
	if isnull(ls_style_no) = false and (isnull(ls_tran_cust) or LenA(ls_tran_cust) < 2) then 
		messagebox("알림!", "운송업체가 정확하지 않아 저장할 수 없습니다!")
		return -1
	end if	
	
	

	

	IF idw_status = NewModified! THEN				/* New Record */		
		li_no = li_no + 1	
	//	messagebox("vv" ,string(li_no,"0000"))
		dw_body.Setitem(i, "yymmdd",    is_yymmdd)
		dw_body.Setitem(i, "shop_cd",   is_shop_cd)
		dw_body.Setitem(i, "shop_type", is_shop_type)
		dw_body.Setitem(i, "no", li_no)
		dw_body.Setitem(i, "reg_id", gs_user_id)
	ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		dw_body.Setitem(i, "mod_id", gs_user_id)
		dw_body.Setitem(i, "mod_dt", ld_datetime)
	END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;

else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_insert();if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
   if is_shop_type = "%" then
      MessageBox("입력","정확한 매장형태 코드를 입력하십시요!")
      dw_head.SetFocus()
      dw_head.SetColumn("shop_type")
      Return 
   end if
   if is_shop_cd = "%" then
      MessageBox("입력","매장 코드를 입력하십시요!")
      dw_head.SetFocus()
      dw_head.SetColumn("shop_cd")
      return 
   end if
	
//	IF MID(IS_SHOP_CD,1,1) <> IS_BRAND  THEN 
//      MessageBox("경고!","브랜드와 매장 코드를 확인 하십시요!")
//		RETURN
//	END IF	
	
	IF dw_body.RowCount() > 0 THEN 
		IF is_shop_cd   <> dw_body.Object.shop_cd[1] OR &
		   is_yymmdd    <> dw_body.Object.yymmdd[1] OR & 
     		is_shop_type <> dw_body.Object.shop_type[1]   THEN
         MessageBox("추가","매장 및 일자가 틀려 추가할수 없습니다!")
			Return
		END IF
	END IF
END IF

il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.enabled = True
	dw_body.ScrollToRow(il_rows)
//	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_42063_e
end type

type cb_delete from w_com010_e`cb_delete within w_42063_e
end type

type cb_insert from w_com010_e`cb_insert within w_42063_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_42063_e
end type

type cb_update from w_com010_e`cb_update within w_42063_e
end type

type cb_print from w_com010_e`cb_print within w_42063_e
end type

type cb_preview from w_com010_e`cb_preview within w_42063_e
end type

type gb_button from w_com010_e`gb_button within w_42063_e
end type

type cb_excel from w_com010_e`cb_excel within w_42063_e
end type

type dw_head from w_com010_e`dw_head within w_42063_e
integer y = 164
integer height = 160
string dataobject = "d_42063_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;String ls_yymmdd

CHOOSE CASE dwo.name
//	CASE "yymmdd"      
//		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
//		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
//			  MessageBox("경고","소급할수 없는 일자입니다.")
//			  Return 1
//        END IF
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_42063_e
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_e`ln_2 within w_42063_e
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_e`dw_body within w_42063_e
integer x = 9
integer y = 360
integer height = 1680
string dataobject = "d_42063_d01"
end type

event dw_body::constructor;call super::constructor;string ls_filter_str

This.SetRowFocusIndicator(Hand!)

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()

This.GetChild("tran_cust", idw_tran_cust)
idw_tran_cust.SetTransObject(SQLCA)
idw_tran_cust.Retrieve('404')


ls_filter_str = "inter_cd in ('M02','M07','M08', 'M10') " 
idw_tran_cust.SetFilter(ls_filter_str)
idw_tran_cust.Filter( )

idw_tran_cust.InsertRow(1)
idw_tran_cust.SetItem(1, "inter_cd", '')
idw_tran_cust.SetItem(1, "inter_nm", '')
end event

event dw_body::itemchanged;call super::itemchanged;integer il_ret


CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		il_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

		return il_ret
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_42063_e
end type

type dw_list from datawindow within w_42063_e
event ue_syscommand pbm_syscommand
boolean visible = false
integer x = 5
integer y = 360
integer width = 3589
integer height = 1680
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "일별작업내역"
string dataobject = "d_42063_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_syscommand;/* DataWindow 위치 이동 금지 */
uint a

a = message.wordparm

CHOOSE CASE a
      CASE 61456, 61458
         message.processed = true
         message.returnvalue = 0
END CHOOSE

return

end event

event constructor;string ls_filter_str

This.SetRowFocusIndicator(Hand!)

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()

This.GetChild("tran_cust", idw_tran_cust)
idw_tran_cust.SetTransObject(SQLCA)
idw_tran_cust.Retrieve('404')

This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA) 
idw_shop_type.Retrieve('911')
end event

event doubleclicked;String ls_out_no, ls_shop_type , ls_out_type , ls_shop_nm

IF row < 0 THEN RETURN 


	is_shop_cd = dw_list.GetitemString(row, "shop_cd")
	is_shop_type = dw_list.GetitemString(row, "shop_type")


IF dw_body.Retrieve(is_yymmdd, is_shop_cd, is_shop_type,  is_brand) > 0 THEN 
	gf_shop_nm(is_shop_cd, 'S', ls_shop_nm) 
	dw_head.SetItem(1, "shop_cd", is_shop_cd)
   dw_head.SetItem(1, "shop_nm", ls_shop_nm)
	dw_head.SetItem(1, "shop_type", is_shop_type)	
	
   dw_body.visible = True						  
   dw_list.visible = False 
	cb_insert.Enabled = True
	
	dw_body.SetColumn("shop_cd")
	dw_body.SetFocus()
END IF

	

end event

