$PBExportHeader$w_54032_e.srw
$PBExportComments$출고요청출고확인
forward
global type w_54032_e from w_com010_e
end type
type cb_out_proc from commandbutton within w_54032_e
end type
type st_1 from statictext within w_54032_e
end type
end forward

global type w_54032_e from w_com010_e
integer width = 3666
integer height = 2288
cb_out_proc cb_out_proc
st_1 st_1
end type
global w_54032_e w_54032_e

type variables
String is_brand, is_yymmdd, is_fr_ymd, is_to_ymd, is_proc_yn , is_st_brand, is_out_ymd
string is_year, is_season, is_house_cd, is_style_gubn
int	ii_deal_seq
DATAWINDOWCHILD IDW_YEAR, IDW_SEASON, idw_house_cd
end variables

forward prototypes
public function boolean wf_out_update (long al_row, datetime ad_datetime, ref string as_err_msg)
public function boolean wf_margin_set (long al_row)
end prototypes

public function boolean wf_out_update (long al_row, datetime ad_datetime, ref string as_err_msg);Long    ll_old_qty,   ll_new_qty  
String  ls_accept_yn, ls_org_yn
String  ls_out_ymd,   ls_shop_cd, ls_shop_type, ls_out_no, ls_no 
String  ls_brand,     ls_year,    ls_season,    ls_item,   ls_sojae 
String  ls_style,     ls_chno,    ls_color,     ls_size,   ls_sale_type  
Decimal ldc_tag_price,    ldc_curr_price, ldc_out_price 
Decimal ldc_out_collect,  ldc_vat 
Decimal ldc_Margin_Rate,  ldc_disc_Rate

ls_org_yn    = dw_body.GetitemString(al_row, "accept_yn",   Primary!, True)	
ls_accept_yn = dw_body.GetitemString(al_row, "accept_yn")  
ll_old_qty   = dw_body.GetitemNumber(al_row, "accept_qty",  Primary!, True)  
ll_new_qty   = dw_body.GetitemNumber(al_row, "accept_qty")	
ls_shop_cd   = dw_body.GetitemString(al_row, "shop_cd")  
ls_shop_type = dw_body.GetitemString(al_row, "shop_type")  

IF ls_accept_yn = 'N' and ls_org_yn = 'Y' THEN 
	ls_out_ymd   = dw_body.GetitemString(al_row, "out_ymd", Primary!, True)  
	ls_out_no    = dw_body.GetitemString(al_row, "out_no",  Primary!, True)  
	ls_no        = dw_body.GetitemString(al_row, "no",      Primary!, True)  
	Delete from tb_42020_h 
    where yymmdd     = :ls_out_ymd 
	   and Shop_Cd    = :ls_shop_cd 
		and Shop_Type  = :ls_shop_type 
		and Out_No     = :ls_out_no 
		and No         = :ls_no ; 
ELSEIF ls_accept_yn = 'Y' and ls_org_yn = 'Y' and ll_old_qty <> ll_new_qty THEN 
	ls_out_ymd   = dw_body.GetitemString(al_row, "out_ymd")  
	ls_out_no    = dw_body.GetitemString(al_row, "out_no")  
	ls_no        = dw_body.GetitemString(al_row, "no")  
	Update tb_42020_h  
	   Set qty    = :ll_new_qty, 
		    mod_id = :gs_user_id, 
			 mod_dt = :ad_dateTime  
    where yymmdd     = :ls_out_ymd 
	   and Shop_Cd    = :ls_shop_cd 
		and Shop_Type  = :ls_shop_type 
		and Out_No     = :ls_out_no 
		and No         = :ls_no ; 
ELSEIF ls_accept_yn = 'Y' and ls_org_yn = 'N' THEN 
	IF gf_style_outno(is_yymmdd, is_brand, ls_out_no) = FALSE THEN 
		Return False 
	END IF 
	ls_no     = '0001' 
   ls_style        = dw_body.Object.style[al_row] 
   ls_chno         = dw_body.Object.chno[al_row] 
   ls_color        = dw_body.Object.color[al_row] 
   ls_size         = dw_body.Object.size[al_row] 
   ls_brand        = dw_body.Object.brand[al_row] 
   ls_year         = dw_body.Object.year[al_row] 
   ls_season       = dw_body.Object.season[al_row] 
   ls_item         = dw_body.Object.item[al_row] 
   ls_sojae        = dw_body.Object.sojae[al_row] 
   ls_sale_type    = dw_body.Object.sale_type[al_row] 
   ldc_margin_rate = dw_body.GetitemDecimal(al_row, "margin_rate") 
   ldc_disc_rate   = dw_body.GetitemDecimal(al_row, "disc_rate") 
   ldc_tag_price   = dw_body.GetitemDecimal(al_row, "tag_price") 
   ldc_curr_price  = dw_body.GetitemDecimal(al_row, "curr_price") 
   ldc_out_price   = dw_body.GetitemDecimal(al_row, "out_price") 
   ldc_out_collect = dw_body.GetitemDecimal(al_row, "out_collect") 
   ldc_vat         = dw_body.GetitemDecimal(al_row, "vat") 
	insert into tb_42020_h 
	  	    (yymmdd,            Shop_CD,         Shop_Type,        Out_NO, 
           House_CD,          Jup_gubn,        Out_Type,         Sale_Type, 
           Margin_Rate,       disc_Rate,       NO, 
           Style,             Chno,            Color,            Size, 
           class, 
           Tag_Price,         Curr_Price,      Out_Price,        Qty, 
           Tag_Amt,           Curr_Amt,        Out_Collect,      Vat, 
           Brand,             Year,            Season,           Item,      Sojae, 
           Reg_id,            Reg_Dt ) 
      values 
	  	    (:is_yymmdd,        :ls_shop_cd,     :ls_shop_type,    :ls_out_no, 
           '010000',          'O1',            'B',              :ls_sale_type, 
           :ldc_margin_rate,  :ldc_disc_Rate,  :ls_no, 
           :ls_style,         :ls_chno,        :ls_color,        :ls_size, 
           'A', 
           :ldc_tag_price,    :ldc_curr_price, :ldc_out_price,   :ll_new_qty, 
           :ldc_tag_price  * :ll_new_qty,      
			  :ldc_curr_price * :ll_new_qty,      :ldc_out_collect, :ldc_vat, 
           :ls_brand,         :ls_year,        :ls_season,       :ls_item,  :ls_sojae, 
           :gs_user_id,       :ad_dateTime) ;
END IF 

IF SQLCA.SQLCODE <> 0 THEN 
	as_err_msg = SQLCA.SQLErrText
	Return False 
ELSEIF ls_accept_yn = 'Y' and ls_org_yn = 'N' THEN 
	dw_body.Setitem(al_row, "out_ymd", is_yymmdd)  
	dw_body.Setitem(al_row, "out_no",  ls_out_no)  
	dw_body.Setitem(al_row, "no",      ls_no)  
END IF

Return True 

end function

public function boolean wf_margin_set (long al_row);Long    ll_qty      
Long    ll_curr_price,  ll_out_price,  ll_out_collect
String  ls_sale_type = space(2)
String  ls_shop_cd,     ls_shop_type,  ls_style , ls_color
decimal ldc_marjin,   ldc_dc_rate

ls_shop_cd   = dw_body.GetitemString(al_row, "shop_cd")
ls_shop_type = dw_body.GetitemString(al_row, "shop_type")
ls_style     = dw_body.GetitemString(al_row, "style")
ls_color     = dw_body.GetitemString(al_row, "color")

/* 출고시 마진율 체크 */
IF gf_outmarjin_color (is_yymmdd,    ls_shop_cd, ls_shop_type, ls_style, ls_color, & 
                  ls_sale_type, ldc_marjin, ldc_dc_rate,   ll_curr_price, ll_out_price) = FALSE THEN 
	RETURN False 
END IF

ll_qty = dw_body.GetitemNumber(al_row, "accept_qty") 

/* 단가 및 율 등록 */
dw_body.Setitem(al_row, "curr_price",  ll_curr_price)
dw_body.Setitem(al_row, "sale_type",   ls_sale_type)
dw_body.Setitem(al_row, "disc_rate",   ldc_dc_rate)
dw_body.Setitem(al_row, "margin_rate", ldc_marjin)
dw_body.Setitem(al_row, "out_price",   ll_out_price)
ll_out_collect = ll_out_price * ll_qty
dw_body.Setitem(al_row, "out_collect", ll_out_collect)
dw_body.Setitem(al_row, "vat", ll_out_collect - Round(ll_out_collect / 1.1, 0))

RETURN True
end function

on w_54032_e.create
int iCurrent
call super::create
this.cb_out_proc=create cb_out_proc
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_out_proc
this.Control[iCurrent+2]=this.st_1
end on

on w_54032_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_out_proc)
destroy(this.st_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.22                                                  */	
/* 수정일      : 2002.03.22                                                  */
/*===========================================================================*/
String   ls_title
long li_cnt

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
   MessageBox(ls_title,"품번구분용 브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("st_brand")
   return false
end if


is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
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



is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"조회기간 시작일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if


is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"조회기간 마지막일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


if is_fr_ymd > is_to_ymd then
   MessageBox(ls_title,"종료일이 시작일보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


is_yymmdd = dw_head.GetItemstring(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"배분요청용 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_house_cd = dw_head.GetItemstring(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"출고창고를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if


is_style_gubn = dw_head.GetItemstring(1, "style_gubn")

ii_deal_seq = dw_head.GetItemNumber(1, "deal_seq")
if IsNull(ii_deal_seq) or ii_deal_seq = 0 then
   MessageBox(ls_title,"배분차수를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_seq")
   return false
end if

//ii_deal_seq = dw_head.GetItemNumber(1, "deal_seq")
//if IsNull(ii_deal_seq) or ii_deal_seq = 0 then
////   MessageBox("알림!","450번대로 배분차수를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("deal_seq")
//	 return false
//end if


select count(*)
into :li_cnt
from tb_52031_h (nolock)
where out_ymd = :is_yymmdd
and   proc_yn = 'Y'
and   deal_seq = :ii_deal_seq;

if li_cnt > 0 then
	 MessageBox("알림", "해당 차수로 배분된 작업이 있습니다. 배분처리 전 배분차수를 확인하세요!")
//	Return false	
end if	
	 

is_proc_yn = dw_head.GetItemString(1, "proc_yn")

return true

end event

event ue_retrieve();/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


//if is_brand = "O" or is_brand = "Y"  or  is_brand = "A"  or is_brand = "D"   then
//	dw_body.DataObject = "d_54032_d01_ol"
//	dw_body.SetTransObject(SQLCA)
//else 
	dw_body.DataObject = "d_54032_d01"
	dw_body.SetTransObject(SQLCA)
//end if	


il_rows = dw_body.retrieve(is_brand, is_st_brand, is_fr_ymd, is_to_ymd, is_proc_yn, is_year, is_season, is_house_cd, is_style_gubn)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF



This.Trigger Event ue_button(2, il_rows)
cb_excel.enabled = true
This.Trigger Event ue_msg(2, il_rows)

end event

event open;call super::open;dw_head.Setitem(1, "proc_yn", "N")


if gs_brand = 'Y' then 
	dw_head.Setitem(1, "house_cd", 'M10000')
end if	

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.02.22                                                  */	
/* 수정일      : 2002.02.22                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_proc_qty
datetime ld_datetime 
String   ls_Err_Msg, ls_note_md

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count

	
	ll_proc_qty = dw_body.GetItemNumber(i, "proc_qty")
	ls_note_md = dw_body.GetItemstring(i, "note_md")
	if isnull(ll_proc_qty) = false and  ll_proc_qty > 0 then
			dw_body.SetItemStatus(i, 0, Primary!,DataModified!)
	end if	
	
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)	
	
   IF idw_status = DataModified! THEN		/* Modify Record */
	
		dw_body.Setitem(i, "proc_qty", ll_proc_qty)
		if isnull(ls_note_md) or ls_note_md = "" then
			dw_body.Setitem(i, "note_md", "")
		else 	
			dw_body.Setitem(i, "note_md", ls_note_md)
		end if	
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
cb_excel.enabled = true
This.Trigger Event ue_msg(3, il_rows)

Return il_rows

end event

event ue_print();call super::ue_print;//
//Long   i 
//String ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no
//
//FOR i = 1 TO dw_body.RowCount() 
//    IF dw_body.Object.accept_yn[i] = "Y" THEN
//       ls_yymmdd    =  dw_body.GetitemString(i, "out_ymd")
//	    ls_shop_cd   =  dw_body.GetitemString(i, "shop_cd")
//       ls_shop_type =  dw_body.GetitemString(i, "shop_type")
//   	 ls_out_no    =  dw_body.GetitemString(i, "out_no")
//       dw_print.Retrieve(is_brand, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, '1')
//       IF dw_print.RowCount() > 0 Then
//          il_rows = dw_print.Print()
//       END IF
//	END IF
//NEXT 
//
//This.Trigger Event ue_msg(6, il_rows)
//
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54032_e","0")
end event

type cb_close from w_com010_e`cb_close within w_54032_e
end type

type cb_delete from w_com010_e`cb_delete within w_54032_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_54032_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_54032_e
end type

type cb_update from w_com010_e`cb_update within w_54032_e
end type

type cb_print from w_com010_e`cb_print within w_54032_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_54032_e
boolean visible = false
integer width = 439
string text = "거래명세서(&V)"
end type

type gb_button from w_com010_e`gb_button within w_54032_e
end type

type cb_excel from w_com010_e`cb_excel within w_54032_e
boolean enabled = true
end type

type dw_head from w_com010_e`dw_head within w_54032_e
integer y = 156
integer height = 260
string dataobject = "d_54032_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')


This.GetChild("st_brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')
ldw_child.insertrow(1)
ldw_child.Setitem(1, "inter_cd1", "%")
ldw_child.Setitem(1, "inter_cd", "%")
ldw_child.Setitem(1, "inter_nm", "전체")

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")



THIS.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.insertrow(1)
idw_year.Setitem(1, "inter_cd1", "%")
idw_year.Setitem(1, "inter_cd", "%")
idw_year.Setitem(1, "inter_nm", "전체")



This.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('A')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
ls_filter_str = "shop_cd in ('010000','A10000','M10000') " 
idw_house_cd.SetFilter(ls_filter_str)
idw_house_cd.Filter( )

end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name
//	CASE "style"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
	
			
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
		
		
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_54032_e
integer beginy = 416
integer endy = 416
end type

type ln_2 from w_com010_e`ln_2 within w_54032_e
integer beginy = 420
integer endy = 420
end type

type dw_body from w_com010_e`dw_body within w_54032_e
integer y = 432
integer width = 3584
integer height = 1624
string dataobject = "d_54032_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.22                                                  */	
/* 수정일      : 2002.03.22                                                  */
/*===========================================================================*/
//Long    ll_qty,  ll_out_price, ll_out_collect 
//String  ls_null, ls_org_yn 
//
//CHOOSE CASE dwo.name
//	CASE "reserve_qty" 
//		ll_qty = This.GetitemDecimal(row, "rqst_qty")
////		IF Long(Data) < 1 OR ll_qty < Long(Data) THEN 
////			MessageBox("확인요망", "출고수량을 잘못 입력 하셨습니다.")
////			RETURN 1
////		END IF
//      ll_out_price = dw_body.GetitemDecimal(row, "out_price")
//      ll_out_collect = ll_out_price * Long(Data)
////      dw_body.Setitem(row, "out_collect", ll_out_collect)
////      dw_body.Setitem(row, "vat", ll_out_collect - Round(ll_out_collect / 1.1, 0))
////	CASE "accept_yn" 
////		IF Data = 'Y' THEN
////			ll_qty    = This.GetitemDecimal(row, "accept_qty") 
////			ls_org_yn = This.GetitemString(row, "accept_yn", Primary!, True) 
////			IF ls_org_yn = 'Y' THEN
////				This.Setitem(row, "out_ymd",     This.GetitemString(row, "out_ymd", Primary!, True))
////				This.Setitem(row, "out_no",      This.GetitemString(row, "out_no", Primary!, True))
////				This.Setitem(row, "no",          This.GetitemString(row, "no", Primary!, True))
////				This.Setitem(row, "curr_price",  This.GetitemDecimal(row, "curr_price", Primary!, True))
////				This.Setitem(row, "sale_type",   This.GetitemString(row, "sale_type", Primary!, True))
////				This.Setitem(row, "disc_rate",   This.GetitemDecimal(row, "disc_rate", Primary!, True))
////				This.Setitem(row, "margin_rate", This.GetitemDecimal(row, "margin_rate", Primary!, True))
////				This.Setitem(row, "accept_qty",  This.GetitemDecimal(row, "accept_qty", Primary!, True))
////				This.Setitem(row, "out_collect", This.GetitemDecimal(row, "out_collect", Primary!, True))
////				This.Setitem(row, "vat",         This.GetitemDecimal(row, "vat", Primary!, True))
////			ELSE
////   			IF isnull(ll_qty) OR ll_qty = 0 THEN 
////	   			This.Setitem(row, "accept_qty", This.GetitemDecimal(row, "rqst_qty"))
////		   	END IF 
////		   	IF wf_margin_set(row) = FALSE THEN
////			   	RETURN 1
//////	   		END IF
//////			END IF
////		ELSE
////			SetNull(ll_qty)
////			SetNull(ls_Null)
////			This.Setitem(row, "out_ymd",     ls_null)
////			This.Setitem(row, "out_no",      ls_null)
////			This.Setitem(row, "no",          ls_null)
////			This.Setitem(row, "curr_price",  ll_qty)
////			This.Setitem(row, "sale_type",   ls_null)
////			This.Setitem(row, "disc_rate",   ll_qty)
////			This.Setitem(row, "margin_rate", ll_qty)
////			This.Setitem(row, "accept_qty",  ll_qty)
////			This.Setitem(row, "out_collect", 0)
////			This.Setitem(row, "vat", 0)
////		END IF
//END CHOOSE

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

event dw_body::clicked;call super::clicked;string ls_style, ls_chno
choose case dwo.name
	case "style"
		ls_style = this.getitemstring(row, "style")
		gf_style_pic(ls_style,"%")
end choose
end event

event dw_body::buttonclicked;call super::buttonclicked;Long i
String ls_yn, ls_out_ymd

If dwo.Name = 'cb_proc' Then
	If dwo.Text = '수량확정' Then
		ls_yn = 'Y'
		dwo.Text = '확정취소'
	Else
		ls_yn = 'N'
		dwo.Text = '수량확정'
	End If
	
	For i = 1 To This.RowCount()
		ls_out_ymd = this.getitemstring(i, "out_ymd")
		if isnull(ls_out_ymd) or LenA(ls_out_ymd) <> 8 then 
			This.SetItem(i, "proc_yn", ls_yn)
		end if
	Next

ib_changed = true
cb_update.enabled = true
End If

end event

type dw_print from w_com010_e`dw_print within w_54032_e
integer x = 2455
integer y = 876
string dataobject = "d_com420"
end type

type cb_out_proc from commandbutton within w_54032_e
integer x = 379
integer y = 44
integer width = 352
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "배분처리"
end type

event clicked;integer Net, li_cnt

is_YYMMDD = dw_head.GetItemString(1, "YYMMDD")
if IsNull(is_YYMMDD) or Trim(is_YYMMDD) = "" then
   MessageBox("알림!","등록일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("YYMMDD")
end if

ii_deal_seq = dw_head.GetItemNumber(1, "deal_seq")
if IsNull(ii_deal_seq) or ii_deal_seq < 450 then
   MessageBox("알림!","450번대로 배분차수를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_seq")
end if


select count(*)
into :li_cnt
from tb_52031_h (nolock)
where out_ymd = :is_yymmdd
and   proc_yn = 'Y'
and   deal_seq = :ii_deal_seq;

if li_cnt > 0 then
	 MessageBox("알림", "해당 차수로 배분된 작업이 있습니다. 배분차수를 확인하세요!")
	Return -1 		
end if	
	 

Net = MessageBox("경고", "수량 확정된 출고요청 내역이 배분데이터로 등록됩니다. 계속하시겠습니까?", Exclamation!, OKCancel!, 2)

IF Net = 1 THEN 
	
	//st_1.visible = true
	st_1.text = "<-- 처리 중입니다!"
	
		DECLARE SP_54032_P02 PROCEDURE FOR SP_54032_P02
			@brand		= :is_brand,
			@st_brand	= :is_st_brand,
         @fr_ymd 		= :is_fr_ymd,   
         @to_ymd 		= :is_to_ymd,
         @out_ymd 	= :is_yymmdd,			
         @deal_seq 	= :ii_deal_seq,						
			@reg_id     = :gs_user_id,
			@YEAR			= :IS_YEAR,
			@SEASON		= :IS_SEASON,
			@house_cd   = :is_house_cd,	
			@style_gubn	= :is_style_gubn	;

	
		 EXECUTE SP_54032_P02;
		 
		IF SQLCA.SQLCODE = -1 THEN 
			rollback  USING SQLCA;				
			MessageBox("SQL오류", SQLCA.SqlErrText) 
			st_1.text = "<-- 수량 확정 배분차수등 확인 후 작업하세요!"
//			st_1.visible = false			
			Return -1 			
		ELSE
 		  MessageBox("알림", "작업이 완료되었습니다!")
			commit  USING SQLCA;
//			st_1.visible = false
			st_1.text = "<-- 수량 확정 이후 작업하세요!"
			dw_head.setitem(1, "proc_yn","X")
			Parent.Trigger Event ue_retrieve()
		END IF 		
	

ELSE

  MessageBox("알림", "작업이 취소되었습니다!")

END IF
end event

type st_1 from statictext within w_54032_e
integer x = 754
integer y = 68
integer width = 923
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "<-- 수량 확정 이후 작업하세요!"
boolean focusrectangle = false
end type

