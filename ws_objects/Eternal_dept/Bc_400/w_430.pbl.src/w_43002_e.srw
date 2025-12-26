$PBExportHeader$w_43002_e.srw
$PBExportComments$창고간 이동 관리(일괄처리)
forward
global type w_43002_e from w_com010_e
end type
type dw_1 from datawindow within w_43002_e
end type
type dw_rtrn from datawindow within w_43002_e
end type
type cb_1 from commandbutton within w_43002_e
end type
end forward

global type w_43002_e from w_com010_e
integer width = 3675
integer height = 2280
dw_1 dw_1
dw_rtrn dw_rtrn
cb_1 cb_1
end type
global w_43002_e w_43002_e

type variables
DataWindowChild   idw_brand, idw_color,   idw_size 
String is_yymmdd, is_fr_house, is_to_house, is_out_no
String is_brand,  is_year,     is_season 

end variables

forward prototypes
public function boolean wf_style_chk (long al_row, string as_style_no)
public subroutine wf_find_style (string as_style, string as_chno)
public function boolean wf_rtn_set ()
end prototypes

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno
String ls_brand, ls_year, ls_season, ls_sojae, ls_item
Long   ll_qty,   ll_tag_price, ll_curr_price 

IF LenA(Trim(as_style_no)) <> 9 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)

Select brand,     year,     season,     
       sojae,     item,     tag_price, 
		 dbo.sf_curr_price(style, :is_yymmdd) 
  into :ls_brand, :ls_year, :ls_season, 
       :ls_sojae, :ls_item, :ll_tag_price, 
		 :ll_curr_price
  from vi_12020_1 
 where style   =    :ls_style 
	and chno    =    :ls_chno ;

IF SQLCA.SQLCODE <> 0 THEN 
	Return False 
END IF

dw_body.SetItem(al_row, "tag_price",  ll_tag_price) 
dw_body.SetItem(al_row, "curr_price", ll_curr_price) 
dw_body.SetItem(al_row, "style_no",  as_style_no)
dw_body.SetItem(al_row, "style",     ls_style)
dw_body.SetItem(al_row, "chno",      ls_chno)
dw_body.SetItem(al_row, "brand",     ls_brand)
dw_body.SetItem(al_row, "year",      ls_year)
dw_body.SetItem(al_row, "season",    ls_season)
dw_body.SetItem(al_row, "sojae",     ls_sojae)
dw_body.SetItem(al_row, "item",      ls_item) 

ll_qty = dw_body.GetitemNumber(al_row, "qty")
IF isnull(ll_qty) THEN ll_qty = 1
dw_body.SetItem(al_row, "qty",      ll_qty) 
dw_body.SetItem(al_row, "tag_amt",  ll_tag_price  * ll_qty) 
dw_body.SetItem(al_row, "curr_amt", ll_curr_price * ll_qty) 

Return True

end function

public subroutine wf_find_style (string as_style, string as_chno);Long ll_find

ll_find = dw_1.Find("style = '" + as_style + "' and chno = '" + as_chno + "'", 1, dw_1.RowCount())

IF ll_find > 0 THEN 
	dw_1.scrolltorow(ll_find)
	dw_1.SelectRow(0, False)
	dw_1.SelectRow(ll_find, True)
END IF


end subroutine

public function boolean wf_rtn_set ();Long    i 
Decimal ldc_qty, ldc_tag_price, ldc_curr_price

dw_rtrn.Reset()
FOR i=1 TO dw_body.RowCount()
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	dw_rtrn.insertRow(0)
	IF idw_status = New! THEN CONTINUE 
	dw_rtrn.Object.yymmdd[i]      = is_yymmdd
   dw_rtrn.Object.shop_cd[i]     = is_fr_house
   dw_rtrn.Object.shop_type[i]   = '1' 
   dw_rtrn.Object.house_cd[i]    = is_to_house
	dw_rtrn.Object.jup_gubn[i]    = 'o2'
	dw_rtrn.Object.sale_type[i]   = '11' 
   dw_rtrn.Object.no[i]          = String(i, "0000")
	dw_rtrn.Object.style[i]       = dw_body.Object.style[i]
   dw_rtrn.Object.chno[i]        = dw_body.Object.chno[i]
	dw_rtrn.Object.color[i]       = dw_body.Object.color[i]
   dw_rtrn.Object.size[i]        = dw_body.Object.size[i] 
	/* B급창고로 이동하면 제품상태 b급 */
	IF is_to_house = '020000' or  is_to_house = '040000'  THEN 
	   dw_rtrn.Object.class[i]       = 'B' 
	ELSE
	   dw_rtrn.Object.class[i]       = 'A' 
	END IF 
	ldc_tag_price  = dw_body.GetitemDecimal(i, "tag_price")
	ldc_curr_price = dw_body.GetitemDecimal(i, "curr_price")
	ldc_qty        = dw_body.GetitemDecimal(i, "qty")
	dw_rtrn.Setitem(i, "tag_price",    ldc_tag_price)
	dw_rtrn.Setitem(i, "curr_price",   ldc_curr_price)
	dw_rtrn.Setitem(i, "qty",          ldc_qty)
	dw_rtrn.Setitem(i, "tag_amt",      ldc_qty * ldc_tag_price)
	dw_rtrn.Setitem(i, "curr_amt",     ldc_qty * ldc_curr_price)
   dw_rtrn.Object.brand[i]       = dw_body.Object.brand[i]  
	dw_rtrn.Object.year[i]        = dw_body.Object.year[i]   
   dw_rtrn.Object.season[i]      = dw_body.Object.season[i] 
	dw_rtrn.Object.item[i]        = dw_body.Object.item[i]   
   dw_rtrn.Object.sojae[i]       = dw_body.Object.sojae[i]  
	dw_rtrn.Setitem(i, "reg_id", dw_body.GetitemString(i, "reg_id"))
	dw_rtrn.Setitem(i, "reg_dt", dw_body.GetitemDateTime(i, "reg_dt"))
   dw_rtrn.SetItemStatus(i, 0, Primary!, idw_status)
NEXT

Return True
end function

on w_43002_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_rtrn=create dw_rtrn
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_rtrn
this.Control[iCurrent+3]=this.cb_1
end on

on w_43002_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_rtrn)
destroy(this.cb_1)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToBottom")
dw_1.SetTransObject(SQLCA)
dw_rtrn.SetTransObject(SQLCA)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.16                                                  */	
/* 수정일      : 2002.03.16                                                  */
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

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

is_fr_house = dw_head.GetItemString(1, "fr_house")
if IsNull(is_fr_house) or Trim(is_fr_house) = "" then
   MessageBox(ls_title,"반출창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_house")
   return false
end if

is_to_house = dw_head.GetItemString(1, "to_house")
if IsNull(is_to_house) or Trim(is_to_house) = "" then
   MessageBox(ls_title,"반입창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_house")
   return false
end if

IF is_fr_house = is_to_house THEN 
   MessageBox(ls_title,"반출 과 반입창고가 같습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_house")
   return false
END IF

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
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

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_style, ls_chno, ls_null 
Decimal    ldc_curr_price, ldc_tag_price  
Long       ll_qty
Boolean    lb_check 
DataStore  lds_Source
SetNull(ls_null)

CHOOSE CASE as_column
	CASE "style_no"		
			IF ai_div = 1 THEN 	
				IF wf_style_chk(al_row, as_data)  THEN 
					dw_body.Setitem(al_row, "color", ls_null)
					dw_body.Setitem(al_row, "size",  ls_null)
					wf_find_style(LeftA(as_data, 8), RightA(as_data, 1))
					RETURN 0 
				END IF 
			END IF
			IF al_row > 1 THEN 
				gf_style_edit(dw_body.object.style_no[al_row -1], as_data, ls_style, ls_chno)
			ELSE
		      ls_style = MidA(as_data, 1, 8)
		      ls_chno  = MidA(as_data, 9, 1) 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "WHERE brand = '" + is_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" + &
				                " and chno  LIKE '" + ls_chno  + "%'" 
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
				ldc_tag_price = lds_Source.GetItemDecimal(1,"tag_price") 
				ls_style = lds_Source.GetItemString(1,"style")
				gf_curr_price (ls_style, is_yymmdd, ldc_curr_price )
			   dw_body.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
			   dw_body.SetItem(al_row, "style",    lds_Source.GetItemString(1,"style"))
			   dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno"))
				dw_body.Setitem(al_row, "color",    ls_null)
				dw_body.Setitem(al_row, "size",     ls_null)
			   dw_body.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand"))
			   dw_body.SetItem(al_row, "year",     lds_Source.GetItemString(1,"year"))
			   dw_body.SetItem(al_row, "season",   lds_Source.GetItemString(1,"season"))
			   dw_body.SetItem(al_row, "sojae",    lds_Source.GetItemString(1,"sojae"))
			   dw_body.SetItem(al_row, "item",     lds_Source.GetItemString(1,"item"))
				dw_body.SetItem(al_row, "tag_price",  ldc_tag_price) 
				dw_body.SetItem(al_row, "curr_price", ldc_curr_price) 
				ll_qty = dw_body.GetitemNumber(al_row, "qty") 
				IF isnull(ll_qty) THEN ll_qty = 1 
				dw_body.SetItem(al_row, "qty",      ll_qty) 
				dw_body.SetItem(al_row, "tag_amt",  ldc_tag_price * ll_qty) 
				dw_body.SetItem(al_row, "curr_amt", ldc_curr_price * ll_qty) 
			   ib_changed = true
            cb_update.enabled = true
			   /* 다음컬럼으로 이동 */
				wf_find_style(ls_style, lds_Source.GetItemString(1,"chno"))
		      dw_body.SetColumn("color")
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */ 
/* 작성일      : 2002.03.16                                                  */
/* 수정일      : 2002.03.16                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_1.retrieve(is_yymmdd, is_fr_house, is_brand, is_year, is_season)
il_rows = dw_body.retrieve(is_yymmdd, is_fr_house, is_to_house, is_brand)
IF il_rows > 0 THEN 
	is_out_no = dw_body.GetitemString(1, "out_no")
	il_rows   = dw_body.insertRow(0)
	dw_head.Setitem(1, "out_no", is_out_no)
	dw_body.SetRow(il_rows)
	dw_body.SetColumn("style_no")
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
	il_rows = dw_body.insertRow(0) 
	SetNull(is_out_no) 
	dw_head.Setitem(1, "out_no", is_out_no)
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_insert.enabled = true
      end if
   CASE 5    /* 조건 */
      cb_insert.enabled = false
END CHOOSE

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.16                                                  */	
/* 수정일      : 2002.03.16                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
String   ls_class,ls_no 

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF
/* B급창고로 이동하면 제품상태 b급 */
	IF is_to_house = '020000' or  is_to_house = '040000'  THEN 
	ls_class    = 'B' 
ELSE
	ls_class    = 'A' 
END IF
wf_rtn_set()

IF isnull(is_out_no) THEN  
	IF gf_style_outno(is_yymmdd, is_brand, is_out_no) = FALSE THEN RETURN -1
END IF

select  substring(convert(varchar(5), convert(decimal(5), isnull(max(no), '0000')) + 10001), 2, 4) 
into :ls_no
from tb_42020_h with (nolock)
where brand =  :is_brand
and   yymmdd = :is_yymmdd
and   out_no = :is_out_no ;


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN			/* New Record    */
	   dw_body.Setitem(i, "yymmdd",    is_yymmdd)
	   dw_body.Setitem(i, "shop_cd",   is_to_house)
	   dw_body.Setitem(i, "shop_type", '1')
	   dw_body.Setitem(i, "out_no",    is_out_no)
	   dw_body.Setitem(i, "house_cd",  is_fr_house)
	   dw_body.Setitem(i, "jup_gubn",  'o2')
	   dw_body.Setitem(i, "out_type",  'A')
	   dw_body.Setitem(i, "sale_type", '11')
	   dw_body.Setitem(i, "no",        ls_no )//String(i, "0000"))
	   dw_body.Setitem(i, "class",     ls_class) 
      dw_body.Setitem(i, "reg_id",    gs_user_id)
	   dw_rtrn.Setitem(i, "out_no",    is_out_no)
      dw_rtrn.Setitem(i, "reg_id",    gs_user_id)
      ls_no = string(integer(ls_no) + 1 , "0000")
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
      dw_rtrn.Setitem(i, "mod_id", gs_user_id)
      dw_rtrn.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)
IF il_rows = 1 THEN
   il_rows = dw_rtrn.Update(TRUE, FALSE)
END IF

if il_rows = 1 then 
   dw_body.ResetUpdate() 
   dw_rtrn.ResetUpdate() 
   commit  USING SQLCA; 
	dw_head.Setitem(1, "out_no", is_out_no)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43002_e","0")
end event

type cb_close from w_com010_e`cb_close within w_43002_e
end type

type cb_delete from w_com010_e`cb_delete within w_43002_e
end type

type cb_insert from w_com010_e`cb_insert within w_43002_e
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_43002_e
end type

type cb_update from w_com010_e`cb_update within w_43002_e
end type

type cb_print from w_com010_e`cb_print within w_43002_e
end type

type cb_preview from w_com010_e`cb_preview within w_43002_e
end type

type gb_button from w_com010_e`gb_button within w_43002_e
end type

type cb_excel from w_com010_e`cb_excel within w_43002_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_43002_e
integer width = 3406
string dataobject = "d_43001_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("fr_house", ldw_child) 
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

This.GetChild("to_house", ldw_child) 
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

This.GetChild("brand", idw_brand) 
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

	
	This.GetChild("item", ldw_child)
	ldw_child.SetTransObject(SQLCA)
	ldw_child.Retrieve(is_brand)
	ldw_child.insertrow(1)
	ldw_child.Setitem(1, "item", "%")
	ldw_child.Setitem(1, "item_nm", "전체")
		


end event

event dw_head::itemchanged;call super::itemchanged;DataWindowChild ldw_child

CHOOSE CASE dwo.name


	CASE "brand", "year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",ldw_child)
			ldw_child.settransobject(sqlca)
			ldw_child.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')
			
			This.GetChild("item", ldw_child)
			ldw_child.SetTransObject(SQLCA)
			ldw_child.Retrieve(is_brand)
			ldw_child.insertrow(1)
			ldw_child.Setitem(1, "item", "%")
			ldw_child.Setitem(1, "item_nm", "전체")
		
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_43002_e
integer beginy = 416
integer endy = 416
end type

type ln_2 from w_com010_e`ln_2 within w_43002_e
integer beginy = 420
integer endy = 420
end type

type dw_body from w_com010_e`dw_body within w_43002_e
integer x = 1527
integer y = 436
integer width = 2066
integer height = 1608
string dataobject = "d_43001_d02"
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
Long   ll_tag_price, ll_curr_price  
String ls_null
Setnull(ls_null) 

CHOOSE CASE dwo.name
	CASE "style_no"	
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "color"	
		This.Setitem(row, "size", ls_null)
	CASE "qty"	
		ll_tag_price  = This.GetitemNumber(row, "tag_price")
		ll_curr_price = This.GetitemNumber(row, "curr_price")
		This.Setitem(row, "tag_amt",  ll_tag_price  * Long(data))
		This.Setitem(row, "curr_amt", ll_curr_price * Long(data))
END CHOOSE

end event

event dw_body::constructor;call super::constructor;This.GetChild("color", idw_color)
idw_color.SetTRansObject(sqlca)
idw_color.insertRow(0)

This.GetChild("size", idw_size)
idw_size.SetTRansObject(sqlca)
idw_size.insertRow(0)


end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;String ls_style, ls_chno, ls_color

CHOOSE CASE dwo.name
	CASE "color" 
		ls_style = This.GetitemString(row, "style")
		ls_chno  = This.GetitemString(row, "chno")
		idw_color.Retrieve(ls_style, ls_chno)
		idw_color.InsertRow(1)
		idw_color.SetItem(1, "color", 'XX')
		idw_color.SetItem(1, "color_enm", '공통')		

		
	CASE "size"
		ls_style = This.GetitemString(row, "style")
		ls_chno  = This.GetitemString(row, "chno")
		ls_color = This.GetitemString(row, "color")
		idw_size.Retrieve(ls_style, ls_chno, ls_color)
		idw_size.InsertRow(1)
		idw_size.SetItem(1, "size", 'XX')
		idw_size.SetItem(1, "size_nm", '공통')		
END CHOOSE

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
		IF ls_column_name = "qty" THEN 
			IF This.GetRow() = This.RowCount() THEN
 			   Parent.Post Event ue_insert()
		   END IF
		END IF
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

type dw_print from w_com010_e`dw_print within w_43002_e
end type

type dw_1 from datawindow within w_43002_e
integer x = 14
integer y = 436
integer width = 1257
integer height = 1608
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_43001_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;Long    ll_row
Decimal ldc_tag_price, ldc_curr_price 

This.SelectRow(0,   False)
This.SelectRow(row, True)

IF row < 1 THEN RETURN 

ll_row = dw_body.RowCount() 
IF LenA(dw_body.GetitemString(ll_row, "style_no")) = 9 THEN
   ll_row = dw_body.insertRow(0)
END IF

ldc_tag_price  = This.GetitemDecimal(row, "tag_price")
ldc_curr_price = This.GetitemDecimal(row, "curr_price")

dw_body.Setitem(ll_row, "style_no", This.Object.style[row] + This.Object.chno[row])
dw_body.Setitem(ll_row, "style",  This.Object.style[row])
dw_body.Setitem(ll_row, "chno",   This.Object.chno[row])
dw_body.Setitem(ll_row, "color",  This.object.color[row])
dw_body.Setitem(ll_row, "size",   This.object.size[row])
dw_body.Setitem(ll_row, "brand",  This.object.brand[row])
dw_body.Setitem(ll_row, "year",   This.object.year[row])
dw_body.Setitem(ll_row, "season", This.Object.season[row])
dw_body.Setitem(ll_row, "sojae",  This.Object.sojae[row])
dw_body.Setitem(ll_row, "item",   This.Object.item[row])
dw_body.Setitem(ll_row, "qty",    1) 
dw_body.Setitem(ll_row, "tag_price",  ldc_tag_price)
dw_body.Setitem(ll_row, "curr_price", ldc_curr_price)
dw_body.Setitem(ll_row, "tag_amt",    ldc_tag_price)
dw_body.Setitem(ll_row, "curr_amt",   ldc_curr_price)


ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

dw_body.SetRow(ll_row)
dw_body.SetColumn("qty")
dw_body.SetFocus()

end event

type dw_rtrn from datawindow within w_43002_e
boolean visible = false
integer x = 59
integer y = 624
integer width = 3488
integer height = 632
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_43001_d03"
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

MessageBox(parent.title + "(반품)", ls_message_string)
return 1
end event

type cb_1 from commandbutton within w_43002_e
integer x = 1298
integer y = 888
integer width = 201
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "=>"
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.16                                                  */	
/* 수정일      : 2002.03.16                                                  */
/*===========================================================================*/
long i, row_cnt
Long    ll_row
Decimal ldc_tag_price, ldc_curr_price , ldc_qty

row_cnt = dw_1.RowCount()

FOR i=1 TO row_cnt
		
	dw_1.SelectRow(0,   False)
	dw_1.SelectRow(i, True)
	
	IF row_cnt < 1 THEN RETURN 
	
	ll_row = dw_body.RowCount() 
	IF LenA(dw_body.GetitemString(ll_row, "style_no")) = 9 THEN
		ll_row = dw_body.insertRow(0)
	END IF
	
	ldc_tag_price  = dw_1.GetitemDecimal(i, "tag_price")
	ldc_curr_price = dw_1.GetitemDecimal(i, "curr_price")
	ldc_qty		   = dw_1.GetitemNumber(i, "qty")
	
	dw_body.Setitem(ll_row, "style_no", dw_1.Object.style[i] + dw_1.Object.chno[i])
	dw_body.Setitem(ll_row, "style",  dw_1.Object.style[i])
	dw_body.Setitem(ll_row, "chno",   dw_1.Object.chno[i])
	dw_body.Setitem(ll_row, "color",  dw_1.object.color[i])
	dw_body.Setitem(ll_row, "size",   dw_1.object.size[i])
	dw_body.Setitem(ll_row, "brand",  dw_1.object.brand[i])
	dw_body.Setitem(ll_row, "year",   dw_1.object.year[i])
	dw_body.Setitem(ll_row, "season", dw_1.Object.season[i])
	dw_body.Setitem(ll_row, "sojae",  dw_1.Object.sojae[i])
	dw_body.Setitem(ll_row, "item",   dw_1.Object.item[i])
	dw_body.Setitem(ll_row, "qty",    dw_1.Object.Stock_qty[i]) 
	dw_body.Setitem(ll_row, "tag_price",  ldc_tag_price)
	dw_body.Setitem(ll_row, "curr_price", ldc_curr_price)
	dw_body.Setitem(ll_row, "tag_amt",    ldc_tag_price * ldc_qty)
	dw_body.Setitem(ll_row, "curr_amt",   ldc_curr_price * ldc_qty)

NEXT

dw_1.Reset()
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

dw_body.SetRow(ll_row)
dw_body.SetColumn("qty")
dw_body.SetFocus()

end event

