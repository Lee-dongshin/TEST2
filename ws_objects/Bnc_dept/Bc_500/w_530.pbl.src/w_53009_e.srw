$PBExportHeader$w_53009_e.srw
$PBExportComments$사내판매등록
forward
global type w_53009_e from w_com010_e
end type
type cb_input from commandbutton within w_53009_e
end type
type dw_list from datawindow within w_53009_e
end type
end forward

global type w_53009_e from w_com010_e
event ue_input ( )
cb_input cb_input
dw_list dw_list
end type
global w_53009_e w_53009_e

type variables
DataWindowChild idw_color, idw_size
String is_brand, is_yymmdd, is_shop_cd, is_shop_type, is_fr_ymd  , is_brand_grp
String is_house, is_fr_shop_cd, is_fr_shop_type
end variables

forward prototypes
public function boolean wf_style_chk (long al_row, string as_style_no)
public function boolean wf_style_set (long al_row, string as_style)
public subroutine wf_amt_set (long al_row, long al_sale_qty, long al_sale_price)
end prototypes

event ue_input();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
dw_list.Visible   = False
dw_body.Visible   = True

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

IF isnull(is_fr_shop_cd) = False and Trim(is_fr_shop_cd) <> "" THEN
	IF isnull(is_fr_shop_type) OR Trim(is_fr_shop_type) = "" THEN
      MessageBox("입력오류","반품매장 형태를 입력하십시요!")
      dw_head.SetFocus()
      dw_head.SetColumn("fr_shop_type")
      return 
	END IF 
END IF 

dw_body.Reset()
il_rows = dw_body.insertRow(0)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(6, il_rows)


end event

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.05.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_given_fg, ls_given_ymd
String ls_brand, ls_year, ls_season, ls_sojae, ls_item
Long   ll_tag_price,  ll_cnt 

IF al_row > 1 and LenA(as_style_no) <> 9 THEN
	gf_style_edit(dw_body.Object.style_no[al_row - 1], as_style_no, ls_style, ls_chno) 
   IF ls_chno = '%' THEN ls_chno = '0' 
ELSE 
	ls_style = LeftA(as_style_no, 8)
	ls_chno  = MidA(as_style_no, 9, 1)
END IF 

Select count(style), 
       max(style)  ,   max(chno), 
       max(brand)  ,   max(year),     max(season),     
       max(sojae)  ,   max(item),     max(tag_price)  
  into :ll_cnt     , 
       :ls_style   ,   :ls_chno, 
       :ls_brand   ,   :ls_year,      :ls_season, 
		 :ls_sojae   ,   :ls_item,      :ll_tag_price
  from vi_12020_1
 where style   like :ls_style 
	and chno    =    :ls_chno
	and isnull(tag_price, 0) <> 0;
	
IF SQLCA.SQLCODE <> 0 or ll_cnt <> 1 THEN 
	Return False 
END IF 

//select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
//into  :ls_given_fg, :ls_given_ymd
//from tb_12020_m with (nolock)
//where style = :ls_style;
//
//
//if ls_given_fg = "Y" then 
//	messagebox("품번체크", ls_given_ymd + "일자로 사은품 전환된 제품입니다!")
////	return false
//end if 	


dw_body.SetItem(al_row, "tag_price",  ll_tag_price) 
IF wf_style_set(al_row, ls_style) THEN 
   dw_body.SetItem(al_row, "style_no", ls_style + ls_chno)
   dw_body.SetItem(al_row, "style",    ls_style)
	dw_body.SetItem(al_row, "chno",     ls_chno)
	dw_body.SetItem(al_row, "brand",    ls_brand)
	dw_body.SetItem(al_row, "year",     ls_year)
	dw_body.SetItem(al_row, "season",   ls_season)
	dw_body.SetItem(al_row, "sojae",    ls_sojae)
	dw_body.SetItem(al_row, "item",     ls_item)
END IF

//dw_body.SetItem(al_row, "color",    'XX')
dw_body.SetItem(al_row, "size",     'XX')

Return True

end function

public function boolean wf_style_set (long al_row, string as_style);Long     ll_tag_price, ll_sale_price
Decimal  ldc_dc_rate 

ll_tag_price  = dw_body.GetitemNumber(al_row, "tag_price")
IF al_row > 1 THEN
	ldc_dc_rate = dw_body.GetitemDecimal(al_row - 1, "dc_rate") 
	IF isnull(ldc_dc_rate) THEN ldc_dc_rate = 0 
ELSE
	ldc_dc_rate = 0 
END IF 
ll_sale_price = ll_tag_price * (100 - ldc_dc_rate) / 100

/* 판매 마진내역 자료 등록 */
/* 직원구매 = [91 50% (기본)] 마진율 100% */
dw_body.Setitem(al_row, "sale_type",  '91')
dw_body.Setitem(al_row, "sale_qty",   1)
dw_body.Setitem(al_row, "curr_price", ll_sale_price)
dw_body.Setitem(al_row, "dc_rate",    ldc_dc_rate)
dw_body.Setitem(al_row, "sale_price", ll_sale_price)
dw_body.Setitem(al_row, "out_rate",   0)
dw_body.Setitem(al_row, "sale_rate",  0)

/* 금액 처리 */
wf_amt_set(al_row, 1, ll_sale_price)

RETURN True
end function

public subroutine wf_amt_set (long al_row, long al_sale_qty, long al_sale_price);/* 각 단가 및 판매량에 따른 금액 처리 */
Long  ll_tag_price, ll_io_amt 
ll_tag_price     = dw_body.GetitemDecimal(al_row, "tag_price") 

dw_body.Setitem(al_row, "tag_amt",  ll_tag_price  * al_sale_qty)
dw_body.Setitem(al_row, "curr_amt", al_sale_price * al_sale_qty)
dw_body.Setitem(al_row, "sale_amt", al_sale_price * al_sale_qty)
dw_body.Setitem(al_row, "out_amt",  al_sale_price * al_sale_qty) 
dw_body.Setitem(al_row, "sale_collect", al_sale_price * al_sale_qty)

dw_body.Setitem(al_row, "io_amt", 0)
dw_body.Setitem(al_row, "io_vat", 0)

end subroutine

on w_53009_e.create
int iCurrent
call super::create
this.cb_input=create cb_input
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_input
this.Control[iCurrent+2]=this.dw_list
end on

on w_53009_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_input)
destroy(this.dw_list)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
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




if is_brand = "V" or is_brand = "B" or is_brand = "F" or is_brand = "L" then
			messagebox("주의", "이터널 브랜드의 경우 이터널영업관리를 이용하세요!")
			  return false
//			return -1
//			Return 0
End if		

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if


select DBO.SF_INTER_CD2('001',:is_brand)
into :is_brand_grp
from dual;


is_yymmdd    = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")
is_fr_ymd    = String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
is_shop_type = '9'
is_house     = dw_head.GetitemString(1, "house_cd")
is_fr_shop_cd   = dw_head.GetitemString(1, "fr_shop_cd")
is_fr_shop_type = dw_head.GetitemString(1, "fr_shop_type")

if IsNull(is_fr_shop_cd) = false or Trim(is_fr_shop_cd) <> "" then 
	
    if is_brand <> MidA(is_fr_shop_cd,1,1) then
		 messagebox("경고!",  "브랜드와 매장코드가 맞지 않습니다!")
   	 dw_head.SetColumn("fr_shop_cd")
		 return false
	end if
	
end if	

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_given_fg, ls_given_ymd
String     ls_style,   ls_chno, ls_data 
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "fr_shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "fr_shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' AND shop_seq < '5000' " 
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
				dw_head.SetItem(al_row, "fr_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "fr_shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("fr_shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "style_no"		
			IF ai_div = 1 THEN 	
			   IF wf_style_chk(al_row, as_data)  THEN
				   RETURN 2 
				END IF
			END IF
			IF al_row > 1 and LenA(Trim(as_data)) <> 9 THEN 
				gf_style_edit(dw_body.Object.style_no[al_row - 1], as_data, ls_style, ls_chno)
			ELSE
		      ls_style = MidA(as_data, 1, 8)
		      ls_chno  = MidA(as_data, 9, 1)
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com013" 
			//gst_cd.default_where   = "WHERE brand = '" + is_brand + "' " + &
			gst_cd.default_where   = "WHERE  '" + is_brand_grp + "' like '%' + brand + '%' " + & 						
			                         "  AND isnull(tag_price, 0) <> 0 "
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
				dw_body.SetItem(al_row, "tag_price", lds_Source.GetItemNumber(1,"tag_price")) 
				ls_style = lds_Source.GetItemString(1,"style")

//				select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
//				into :ls_given_fg, :ls_given_ymd
//				from beaucre.dbo.tb_12020_m with (nolock)
//				where style like :ls_style + '%';
//				
//			
//				IF ls_given_fg = "Y"  THEN 
//					messagebox("품번검색", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")					
////					dw_body.SetItem(al_row, "style_no", "")
////					ib_itemchanged = FALSE
////					return 1 	
//				END IF 								
				
				
 				IF wf_style_set(al_row, ls_style) THEN 
				   dw_body.SetItem(al_row, "style_no", ls_style + lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "style",    ls_style)
				   dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno"))
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
			      dw_body.SetColumn("sale_qty")
			      lb_check = TRUE 
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
String ls_fr_shop_cd 

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

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

IF isnull(is_fr_shop_cd) or Trim(is_fr_shop_cd) = "" THEN
	ls_fr_shop_cd = '%'
ELSE
	ls_fr_shop_cd = is_fr_shop_cd
END IF

il_rows = dw_list.retrieve(is_brand, is_yymmdd, is_shop_cd, ls_fr_shop_cd)

IF il_rows >= 0 THEN
   dw_list.visible   = True
   dw_body.visible   = False
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(cb_input,   "FixedToRight")
inv_resize.of_Register(dw_list,   "ScaleToRight&Bottom")

dw_list.SetTransObject(SQLCA)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 6 - 입력  */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows >= 0 then
         cb_print.enabled   = true
         cb_preview.enabled = true
         cb_excel.enabled   = true
         cb_insert.enabled  = false
         cb_delete.enabled  = false
         cb_update.enabled  = false
         cb_input.Text      = "일보등록(&I)"
         dw_head.enabled    = true 
         ib_changed         = false
      end if
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled  = true
			cb_print.enabled   = false
			cb_preview.enabled = false
			cb_excel.enabled   = false
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed         = false
			cb_print.enabled   = true
			cb_preview.enabled = true
			cb_excel.enabled   = true
			cb_delete.enabled  = false
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
      cb_input.Text = "일보등록(&I)"
      cb_insert.enabled  = false
      cb_delete.enabled  = false
      cb_print.enabled   = false
      cb_preview.enabled = false
      cb_excel.enabled   = false
      cb_update.enabled  = false
      ib_changed         = false
      dw_body.Enabled    = false
      dw_head.Enabled    = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 6		/* 입력 */
      if al_rows > 0 then
         cb_insert.enabled  = true
         cb_delete.enabled  = true
         cb_print.enabled   = true
         cb_preview.enabled = true
         cb_excel.enabled   = true
         dw_head.Enabled    = false
         dw_body.Enabled    = true
         dw_body.SetFocus()
         ib_changed = false
         cb_update.enabled = false
         cb_input.Text = "조건(&I)"
      else
         cb_insert.enabled  = false
         cb_delete.enabled  = false
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
      end if

END CHOOSE

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04																  */	
/* 수정일      : 2002.03.04																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

IF idw_status = NotModified! OR idw_status = DataModified! THEN
	RETURN 
END IF 

il_rows = dw_body.DeleteRow (ll_cur_row)
dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
String   ls_sale_no,  ls_no,  ls_ErrMsg,   ls_style_no
long     i, ll_row_count 
datetime ld_datetime 
String   ls_style, ls_chno, ls_color, ls_size
Long     ll_qty,   ll_sale_price
Decimal  ldc_dc_rate 

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ll_row_count = dw_body.RowCount()
FOR i = ll_row_count to 1 step -1 
	ls_style_no = dw_body.GetitemString(i, "style_no")
	IF isnull(ls_style_no) THEN
		dw_body.DeleteRow(i) 
	END IF
NEXT 
ll_row_count = dw_body.RowCount()

IF ll_row_count > 0 AND dw_body.GetItemStatus(1, 0, Primary!) <> NewModified! THEN 
   ls_sale_no = dw_body.GetitemString(1, "sale_no")
//ELSEIF Gf_Get_Saleno(is_yymmdd, is_shop_cd, is_shop_type, ls_sale_no) <> 0 THEN 
ELSEIF Gf_Style_Outno(is_yymmdd, is_brand, ls_sale_no) = FALSE THEN 
	Return -1 
END IF

il_rows    = 1 
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN			/* New Record */
	   ls_no = String(i, "0000")
      dw_body.Setitem(i, "no",         ls_no)
      dw_body.Setitem(i, "yymmdd",     is_yymmdd)
      dw_body.Setitem(i, "shop_cd",    is_shop_cd)
      dw_body.Setitem(i, "shop_type",  is_shop_type)
      dw_body.Setitem(i, "shop_div",   MidA(is_shop_cd, 2, 1))
      dw_body.Setitem(i, "sale_no",    ls_sale_no)
		dw_body.Setitem(i, "sale_cust",  is_fr_shop_cd)
		dw_body.Setitem(i, "sale_fg",    'Z')
      dw_body.Setitem(i, "reg_id",     gs_user_id)
		ls_style      = dw_body.GetitemString(i, "style")
		ls_chno       = dw_body.GetitemString(i, "chno")
		ls_color      = dw_body.GetitemString(i, "color")
		ls_size       = dw_body.GetitemString(i, "size")
		ll_qty        = dw_body.GetitemNumber(i, "sale_qty")
		ll_sale_price = dw_body.GetitemNumber(i, "sale_price")
		ldc_dc_rate   = dw_body.GetitemDecimal(i, "dc_rate")
		
//		if is_brand <> mid(ls_style,1,1) and is_brand <> "J"  then 
//			messagebox("경고!", "스타일과 브랜드가 일치 하지 않습니다!")
//			return -1
//		end if
		
      DECLARE SP_53009_OUT PROCEDURE FOR SP_53009_OUT
              @brand        = :is_brand, 
              @yymmdd       = :is_yymmdd, 
              @shop_cd      = :is_shop_cd, 
              @shop_type    = :is_shop_type, 
              @house_cd     = :is_house, 
              @sale_no      = :ls_sale_no, 
              @no           = :ls_no, 
              @style        = :ls_style, 
              @chno         = :ls_chno, 
              @color        = :ls_color, 
              @size         = :ls_size, 
              @dc_rate      = :ldc_dc_rate, 
              @qty          = :ll_qty, 
              @sale_price   = :ll_sale_price, 
				  @fr_ymd       = :is_fr_ymd, 
              @fr_shop_cd   = :is_fr_shop_cd, 
              @fr_shop_type = :is_fr_shop_type, 
              @user_id      = :gs_user_id ;  
       EXECUTE SP_53009_OUT;
      if SQLCA.SQLCODE < 0  then
         ls_ErrMsg  = SQLCA.SQLErrText 
			il_rows    = -1 
			exit 
		end if 
   END IF 
NEXT

if il_rows = 1 then
   il_rows = dw_body.Update()
end if 

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
	IF isnull(ls_ErrMsg) = False AND Trim(ls_ErrMsg) <> "" THEN 
      MessageBox("SQL 오류", ls_ErrMsg) 
	END IF 
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event open;call super::open;String ls_brand, ls_shop_cd, ls_shop_nm 

ls_brand = dw_head.GetitemString(1, "brand")

IF ls_brand = 'N' OR ls_brand = 'J' THEN
   ls_shop_cd = 'NX4990'
ELSEif ls_brand = 'O' then
   ls_shop_cd = 'OX4990'
ELSEif ls_brand = 'E' then
   ls_shop_cd = 'EX4990'	
ELSEif ls_brand = 'B' then
   ls_shop_cd = 'BX4990'	
ELSEif ls_brand = 'A' then
   ls_shop_cd = 'AX4990'			
ELSEif ls_brand = 'I' then
   ls_shop_cd = 'IX4990'				
ELSEif ls_brand = 'K' then
   ls_shop_cd = 'KX4990'
ELSEif ls_brand = 'U' then
   ls_shop_cd = 'UX4990'
else
	ls_shop_cd = 'WX4990'
END IF

gf_shop_nm(ls_shop_cd, 'S',   ls_shop_nm) 

dw_head.SetItem(1, "shop_cd", ls_shop_cd)
dw_head.SetItem(1, "shop_nm", ls_shop_nm)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53009_e","0")
end event

type cb_close from w_com010_e`cb_close within w_53009_e
integer taborder = 140
end type

type cb_delete from w_com010_e`cb_delete within w_53009_e
integer taborder = 130
end type

type cb_insert from w_com010_e`cb_insert within w_53009_e
integer taborder = 70
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_53009_e
integer x = 2839
integer width = 384
integer taborder = 40
string text = "일보조회(&Q)"
end type

event cb_retrieve::clicked;/*===========================================================================*/
/* 작성자      : 김 태범      															  */	
/* 작성일      : 2002.03.04																  */	
/* 수정일      : 2002.03.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

Parent.Trigger Event ue_retrieve()	//조회

SetPointer(oldpointer)
This.Enabled = True

end event

type cb_update from w_com010_e`cb_update within w_53009_e
end type

type cb_print from w_com010_e`cb_print within w_53009_e
boolean visible = false
integer taborder = 100
end type

type cb_preview from w_com010_e`cb_preview within w_53009_e
boolean visible = false
integer taborder = 110
end type

type gb_button from w_com010_e`gb_button within w_53009_e
end type

type cb_excel from w_com010_e`cb_excel within w_53009_e
boolean visible = false
integer taborder = 120
end type

type dw_head from w_com010_e`dw_head within w_53009_e
integer width = 3406
integer height = 252
string dataobject = "d_53009_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001') 

This.GetChild("house_cd", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve() 

This.GetChild("fr_shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911') 
ldw_child.insertRow(1)

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
/*===========================================================================*/
String ls_yymmdd, ls_shop_cd, ls_shop_nm 

CHOOSE CASE dwo.name
	CASE "fr_shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "yymmdd"      
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
	CASE "brand"	   
		  IF Data = 'N' THEN			
			  ls_shop_cd = 'NX4990'
		  ELSEif Data = 'J' then
		     ls_shop_cd = 'JX4990'
		  ELSEif Data = 'O' then
		     ls_shop_cd = 'OX4990'
		  ELSEif Data = 'E' then
			  ls_shop_cd = 'EX4990'			
		  ELSEif Data = 'B' then
			  ls_shop_cd = 'BX4990'		
		  ELSEif Data = 'A' then
			  ls_shop_cd = 'AX4990'		
		  ELSEif Data = 'I' then
			  ls_shop_cd = 'IX4990'				  
		  else
		  	  ls_shop_cd = Data + 'X4990'
		  END IF		  
		  
		  gf_shop_nm(ls_shop_cd, 'S',   ls_shop_nm) 
		  dw_head.SetItem(1, "shop_cd", ls_shop_cd)
		  dw_head.SetItem(1, "shop_nm", ls_shop_nm)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_53009_e
integer beginy = 436
integer endy = 436
end type

type ln_2 from w_com010_e`ln_2 within w_53009_e
integer beginy = 440
integer endy = 440
end type

type dw_body from w_com010_e`dw_body within w_53009_e
event ue_set_col ( string as_column )
integer y = 456
integer width = 3593
integer height = 1540
integer taborder = 50
boolean enabled = false
string dataobject = "d_53009_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::ue_set_col(string as_column);This.SetColumn(as_column)
end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
Long    ll_ret, ll_sale_qty, ll_tag_price, ll_sale_price
Decimal ldc_dc_rate 
String  ll_null
SetNull(ll_null)

CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1 
	//	if is_brand = mid(data,1,1) then
		ll_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1) 
//   	else
//			messagebox("경고!", "브랜드와 제품코드가 맞지 않습니다!")
//			return 1
//		end if	
//		IF Len(This.GetitemString(row, "color")) = 2 THEN
//			This.Post Event ue_set_col("sale_qty")
//		END IF 
		Return ll_ret
	CASE "color"	    
		This.Setitem(row, "size", ll_null) 
	CASE "dc_rate" 
		ldc_dc_rate = Dec(Data)
		IF isnull(ldc_dc_rate) THEN ldc_dc_rate = 0 
		ll_tag_price    = This.GetitemNumber(row, "tag_price")
		ll_sale_qty     = This.GetitemNumber(row, "sale_qty")
		ll_sale_price   = ll_tag_price * (100 - ldc_dc_rate) / 100
      This.Setitem(row, "curr_price", ll_sale_price)
      This.Setitem(row, "sale_price", ll_sale_price)
		wf_amt_set(row, ll_sale_qty, ll_sale_price) 
	CASE "sale_price" 
		ll_sale_price   = Long(Data) 
		IF isnull(ll_sale_price) or ll_sale_price = 0 THEN RETURN 1 
		ll_tag_price    = This.GetitemNumber(row, "tag_price")
		ll_sale_qty     = This.GetitemNumber(row, "sale_qty")
		ldc_dc_rate     = 100 - (ll_sale_price / ll_tag_price * 100)
      This.Setitem(row, "curr_price", ll_sale_price)
      This.Setitem(row, "dc_rate",    ldc_dc_rate)
		wf_amt_set(row, ll_sale_qty, ll_sale_price) 
	CASE "sale_qty" 
		ll_sale_qty   = Long(Data) 
		IF isnull(ll_sale_qty) or ll_sale_qty = 0 THEN RETURN 1 
		ll_sale_price = This.GetitemNumber(row, "sale_price")
      /* 금액 처리           */
		wf_amt_set(row, ll_sale_qty, ll_sale_price) 
END CHOOSE

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.insertRow(0)

This.GetChild("size", idw_size)
idw_size.SetTransObject(SQLCA)
idw_size.insertRow(0)

This.GetChild("color_1", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve()

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('011')

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
		IF ls_column_name = "sale_qty" and This.GetRow() = This.RowCount() THEN 
			Parent.Post Event ue_insert()
		END IF
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

event dw_body::itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color

CHOOSE CASE dwo.name
	CASE "color"
		ls_style = This.GetitemString(row, "style")
		ls_chno  = This.GetitemString(row, "chno")
		idw_color.Retrieve(ls_style, ls_chno)
		if is_shop_type > '3' then 
			idw_color.insertRow(1)
			idw_color.Setitem(1, "color", "XX")
			idw_color.Setitem(1, "color_enm", "XX")
		end if 
	CASE "size"
		ls_style = This.GetitemString(row, "style")
		ls_chno  = This.GetitemString(row, "chno")
		ls_color = This.GetitemString(row, "color")
		idw_size.Retrieve(ls_style, ls_chno, ls_color)
		if is_shop_type > '3' then 
			idw_size.insertRow(1)
			idw_size.Setitem(1, "size", "XX")
			idw_size.Setitem(1, "size_nm", "XX")
		end if 
END CHOOSE


end event

type dw_print from w_com010_e`dw_print within w_53009_e
end type

type cb_input from commandbutton within w_53009_e
event ue_keydown pbm_keydown
integer x = 2455
integer y = 44
integer width = 384
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일보등록(&I)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
end event

event clicked;/*===========================================================================*/
/* 작성자      : 김태범        															  */	
/* 작성일      : 2002.03.04																  */	
/* 수정일      : 2002.03.04																  */
/*===========================================================================*/
IF dw_head.Enabled THEN
   Parent.Trigger Event ue_input()	//등록 
ELSE 
	Parent.Trigger Event ue_head()	//조건 
END IF

end event

event getfocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 700

end event

event losefocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 400

end event

type dw_list from datawindow within w_53009_e
boolean visible = false
integer x = 5
integer y = 456
integer width = 3593
integer height = 1596
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "d_53009_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_child 

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('011')

end event

event doubleclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
String ls_sale_no 

IF row < 1 THEN RETURN 

is_shop_type = This.GetitemString(row, "shop_type")
ls_sale_no   = This.GetitemString(row, "sale_no") 

dw_head.Setitem(1, "shop_type", is_shop_type) 
dw_body.Retrieve(is_yymmdd, is_shop_cd, is_shop_type, ls_sale_no)

dw_body.visible = True
This.visible = False

dw_body.SetFocus()

Parent.Trigger Event ue_button(6, il_rows)


end event

