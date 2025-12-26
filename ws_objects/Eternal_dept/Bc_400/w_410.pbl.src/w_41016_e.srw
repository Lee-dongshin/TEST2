$PBExportHeader$w_41016_e.srw
$PBExportComments$입고동시출고
forward
global type w_41016_e from w_com020_e
end type
type cb_1 from commandbutton within w_41016_e
end type
type dw_over from datawindow within w_41016_e
end type
type dw_1 from datawindow within w_41016_e
end type
end forward

global type w_41016_e from w_com020_e
integer width = 3685
integer height = 2264
string title = "입고등록"
cb_1 cb_1
dw_over dw_over
dw_1 dw_1
end type
global w_41016_e w_41016_e

type variables
DataWindowChild idw_jup_gubn, idw_house_cd, idw_class, idw_brand, idw_shop_type
long il_dc_rate
String is_brand, is_season, is_item, is_mat_type, is_in_no, is_in_date, is_close_YN, is_in_gubn
string is_style,  is_chno,  is_cust_cd, is_class, is_jup_gubn, is_house_cd, is_year
String is_make_type, is_country_cd, is_note, is_shop_cd, is_yymmdd, is_shop_type
long 	 il_plan_qty, il_in_qty
end variables

on w_41016_e.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_over=create dw_over
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_over
this.Control[iCurrent+3]=this.dw_1
end on

on w_41016_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_over)
destroy(this.dw_1)
end on

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "in_date" ,string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "jup_gubn","I1")
dw_head.SetItem(1, "in_gubn" ,"+")
dw_head.SetItem(1, "class"   ,"A")
dw_head.SetItem(1, "brand"   ,"U")
dw_head.SetItem(1, "in_house"   ,"880000")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm , ls_dlvy_ymd, ls_brand, ls_shop_nm, ls_plan_yn
long 		  ll_make_price, ll_tag_price
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
		CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				if dw_head.object.brand[1] = "U" then
					gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' and shop_div = 'T' "
				else
					gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' "
				end if	
			ELSE
				
			if dw_head.object.brand[1] = "U" then
					gst_cd.Item_where = "shop_div = 'T' "
				else
					gst_cd.Item_where = ""
				end if	
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
				dw_head.SetColumn("shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source		
		
		CASE "cust_cd"							// 거래처 코드
		
//			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
//				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
//					MessageBox("입력오류","등록되지 않은 거래처 코드입니다!")
//					RETURN 1
//				END IF
//			   If Right(as_data, 4) < '5000' or Right(as_data, 4) > '6999' Then
//					MessageBox("입력오류","생산처 코드가 아닙니다!")
//					RETURN 1
//				End If					
//				dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
//			ELSE		
// F1 key Or PopUp Button Click -> Call
			IF ai_div = 1 THEN 	
				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
				gst_cd.window_title    = "생산처 코드 검색" 
				gst_cd.datawindow_nm   = "d_com911" 
				gst_cd.default_where   = " WHERE Cust_Code Between '5000' And '8999' "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " CustCode LIKE ~'" + as_data + "%~' "
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
					dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"CustCode"))
					dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"Cust_Name"))
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("cust_cd")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
//			END IF
			CASE "style"							// 거래처 코드
				
				ls_brand = dw_head.getitemstring(1, "brand")
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = "WHERE   style like '" + ls_brand + "%'"	
				
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~'  "
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
            
				   is_style    =  ''
					is_chno     =  ''
					is_brand    =  ''
					is_season   =  ''
					is_year     =  ''
					is_item     =  ''
					is_mat_type =  ''					
					
					is_style    =  lds_Source.GetItemString(1,"style")
					is_chno     =  lds_Source.GetItemString(1,"chno")
					is_brand    =  lds_Source.GetItemString(1,"brand")
					is_season   =  lds_Source.GetItemString(1,"season")
					is_year     =  lds_Source.GetItemString(1,"year")					
					is_item     =  lds_Source.GetItemString(1,"item")					
					is_mat_type =  lds_Source.GetItemString(1,"sojae")					
					is_house_cd =  dw_head.GetitemString(1,"in_house")


				  SELECT make_price, make_type, isnull(country_cd, "00"), dlvy_ymd, plan_yn, tag_price
				  into :ll_make_price, :is_make_type, :is_country_cd, :ls_dlvy_ymd, :ls_plan_yn, :ll_tag_price
		        FROM VI_12020_2 with (nolock)
	           WHERE style = :is_style
              and   chno  = :is_chno;
					
					
					if isnull(ll_make_price) or ll_make_price = 0 then
						messagebox("경고", "임가공가가 등록되지 않았습니다! 자재과에 문의하세요!")
					   dw_head.SetItem(al_row, "style", "")						
						DW_HEAD.SETCOLUMN( "STYLE")
						return 1
					end if
					
				if isnull(ll_tag_price) or ll_tag_price = 0 then
						messagebox("경고", "소비자가 등록되지 않았습니다! 기획실에에 문의하세요!")
					   dw_head.SetItem(al_row, "style", "")						
						DW_HEAD.SETCOLUMN( "STYLE")
						return 1
					end if					

					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
					dw_head.SetItem(al_row, "brand", lds_Source.GetItemString(1,"brand"))

					select cust_cd
         		into :is_cust_cd
         		from tb_12021_d with (nolock)
          		where style = :is_style
           		and   chno = :is_chno ;
               
               select  dbo.SF_CUST_NM(:is_cust_cd,"a")    
					into :ls_cust_nm
					from dual;
					
	         	dw_head.SetItem(1, "cust_cd", is_cust_cd)
					dw_head.SetItem(1, "cust_nm", ls_cust_nm)
					
					select last_yn 
					into :is_close_yn
					from tb_12021_d with (nolock)
					where style = :is_style
					and   chno = :is_chno;
					
					dw_head.SetItem(1, "close_yn", is_close_yn)
					
					dw_list.retrieve(LeftA(is_style,1) ,is_style, is_chno, is_house_cd)
					
					if is_close_yn = 'Y' then 
					   messagebox("입고종결", "입고 종결된 제품입니다!")
				   end if
				
				
					if ls_plan_yn = "Y" and ls_brand <> "U" then
						dw_head.SetItem(1, "shop_type", "3")
					end if	
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("in_date")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
//			END IF
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
/* 작성자      :                                                         */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
decimal ll_dc_rate
integer ii
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//
//il_rows = dw_list.retrieve(left(is_style,1), is_style, is_chno)

//IF il_rows > 0 THEN
//   dw_list.SetFocus()
//END IF
//
//ll_dc_rate = integer(dw_head.getitemdecimal(1, "dc"))

dw_head.setitem(1,"out_no","")

is_in_date 	= dw_head.Getitemstring(1, "in_date")
is_in_no 	= dw_head.Getitemstring(1, "in_no")
is_house_cd = dw_head.Getitemstring(1, "in_house")
is_jup_gubn = dw_head.Getitemstring(1, "jup_gubn")
is_in_gubn 	= dw_head.Getitemstring(1, "in_gubn")
is_class 	= dw_head.Getitemstring(1, "class")
is_cust_cd 	= dw_head.Getitemstring(1, "cust_cd")
//il_dc_rate 	= integer(dw_head.getitemdecimal(1, "dc"))




if isnull(is_in_no) or LenA(is_in_no) <> 4 then
  il_rows = dw_body.retrieve(is_style, is_chno, 'xxxxxxxx', 'xxxx', 'A')
 else 
  il_rows = dw_body.retrieve(is_style, is_chno, is_in_date, is_in_no,'B')
end if  

  
select sum(isnull(plan_qty,0)), sum(isnull(in_qty,0))
into   :il_plan_qty, :il_in_qty
from   tb_12030_s with (nolock)
where  style = :is_style
and    chno  = :is_chno;

  
//IF il_rows > 0 THEN
//   dw_body.SetFocus()
//	for ii = 1 to il_rows
//		dw_body.setitem(ii, "DC_rate" , il_dc_rate)
//	next
//	
//END IF
//
//dw_1.retrieve(is_style, is_chno, is_in_no)

This.Trigger Event ue_button(1, il_rows)

This.Trigger Event ue_msg(1, il_rows)



end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_title, ls_dlvy_ymd, ls_year, ls_season
integer  li_day_cnt, li_season_no
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

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" or LenA(is_style) <> 8 then
   MessageBox(ls_title,"제품 코드를  정확히 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style")
   return false
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" or LenA(is_chno) <> 1 then
   MessageBox(ls_title,"제품 차수를  정확히 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("chno")
   return false
end if

is_in_date = dw_head.GetItemstring(1, "in_date")
if IsNull(is_in_date) or Trim(is_in_date) = "" or LenA(is_in_date) <> 8 then
   MessageBox(ls_title,"입고일자를 정확히 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("in_date")
   return false
end if

is_house_cd = dw_head.GetItemString(1, "in_house")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" or LenA(is_house_cd) <> 6 then
   MessageBox(ls_title,"입고창고를 정확히 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("in_house")
   return false
end if

is_jup_gubn = dw_head.GetItemString(1, "jup_gubn")
if IsNull(is_jup_gubn) or Trim(is_jup_gubn) = "" or LenA(is_jup_gubn) <> 2 then
   MessageBox(ls_title,"전표구분을 정확히 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jup_gubn")
   return false
end if

is_in_gubn = dw_head.GetItemString(1, "in_gubn")
if IsNull(is_in_gubn) or Trim(is_in_gubn) = "" or LenA(is_in_gubn) <> 1  then
   MessageBox(ls_title,"입출구분을 정확히 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("in_gubn")
   return false
end if


is_class = dw_head.GetItemString(1, "class")
if IsNull(is_class) or Trim(is_class) = "" or LenA(is_class) <> 1 then
   MessageBox(ls_title,"제품등급을 정확히 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("in_gubn")
   return false
end if
if is_class = "B" then 
	il_dc_rate = 50 
elseif is_class = "C" then 
	il_dc_rate = 100
else 
	il_dc_rate = 0
end if	

is_cust_cd = dw_head.GetItemString(1, "cust_cd")
if IsNull(is_cust_cd) or Trim(is_cust_cd) = "" or LenA(is_cust_cd) <> 6 then
   MessageBox(ls_title,"생산업체를 정확히 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("cust_cd")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = ""  then
   MessageBox(ls_title,"브랜드를를 정확히 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


if is_brand <> MidA(is_style,1,1)  then
   MessageBox(ls_title,"브랜드를를 정확히 입력하십시요!")
   dw_head.SetColumn("brand")
   return false
end if

is_note = dw_head.GetItemString(1, "note")

SELECT year + convert(char(01),dbo.sf_inter_sort_seq('003',season)), datediff( day, isnull(fix_dlvy, dlvy_ymd) , :is_in_date)
into :ls_year, :li_day_cnt
FROM tb_12021_d with (nolock)
WHERE style = :is_style
and   chno  = :is_chno;

if ls_year > '20052' then
	if li_day_cnt > 15 then
		MessageBox(ls_title,"납기일이 15일을 초과했습니다!")
		dw_head.SetFocus()
		dw_head.SetColumn("style")
//		return false
	end if
end if


is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = ""  then
   MessageBox(ls_title,"출고일자를 정확히 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = ""  then
   MessageBox(ls_title,"출고매장을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = ""  then
   MessageBox(ls_title,"매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

if (is_brand = "U" and LeftA(is_shop_cd,5) <> "UT356" ) or  (is_brand = "U" and is_house_cd <> "880000" ) then
	MessageBox(ls_title,"USA TEAM 전용 매장이나 창고가 아닙니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if


return true
end event

event type long ue_update();long i, II,  JJ, kk
long ll_row_count, ll_in_qty, ll_row_count1, ll_qty_chk, ll_qty_chn_chk
datetime ld_datetime
string ls_in_no, ls_in_no1,ls_yymmdd, ls_out_no
DECIMAL LL_MAKE_PRICE, LL_TAG_PRICE, LL_IN_QTY1, LL_IN_QTY2, ll_over_qty, ll_normal_qty, ll_qty_kor, ll_qty_chn, ll_qty
STRING ls_style, ls_chno, ls_color,ls_size
decimal ll_lastover_qty, ll_out_row, ll_out_qty

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

/* 시스템 날짜를 가져온다 */
IF is_close_yn = "Y" THEN
	messagebox("알림!", "종결된 스타일은 저장 할 수 없습니다!")
	Return 0
END IF

	select  substring(convert(varchar(5), convert(decimal(5), isnull(max(in_no), '0000')) + 10001), 2, 4) 
	into :ls_in_no
	from tb_41010_h with (nolock)
	where brand = :is_brand
	and   yymmdd = :is_in_date;

	
FOR i=1 TO ll_row_count
	
		ll_qty_kor = dw_body.GetItemDecimal(i, "qty_kor")
		ll_qty_chn = dw_body.GetItemDecimal(i, "qty_chn")
		ll_tag_price = dw_body.GetItemDecimal(i, "tag_price")		
		LL_MAKE_PRICE = dw_body.GetItemDecimal(i, "make_price")				
		ls_yymmdd = dw_body.GetItemstring(i, "yymmdd")		
		
		if isnull(ll_qty_kor) then ll_qty_kor = 0
		if isnull(ll_qty_chn) then ll_qty_chn = 0
		
		ll_qty = ll_qty_kor + ll_qty_chn		
	
		dw_body.SetItem(i, "qty", ll_qty)				
	
   	idw_status = dw_body.GetItemStatus(i, 0, Primary!)	
	if ll_qty <> 0 then
		IF idw_status = DataModified!  THEN		/* Modify Record */
			dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
			dw_body.Setitem(i, "yymmdd",    is_in_date)
			dw_body.Setitem(i, "cust_cd",   is_cust_cd)
			dw_body.Setitem(i, "in_no",     ls_in_no ) //is_in_no)
			dw_body.Setitem(i, "no",        string(i, "0000") ) //is_in_no)				
			dw_body.Setitem(i, "in_gubn",   is_in_gubn)				
			dw_body.Setitem(i, "jup_gubn",  is_jup_gubn)
			dw_body.Setitem(i, "house_cd",  is_house_cd)
			dw_body.Setitem(i, "REAL_MAKE_AMT"	,((100 - il_dc_rate) /100) * LL_MAKE_PRICE * ll_qty )				
			dw_body.Setitem(i, "AMT"				, LL_tag_PRICE  * ll_qty )																				
			dw_body.setitem(i, "dc_rate",   il_dc_rate)	
			dw_body.Setitem(i, "class",     is_class)
			dw_body.Setitem(i, "brand",     is_brand)		
			dw_body.Setitem(i, "year",      is_year)		
			dw_body.Setitem(i, "season" ,   is_season)		
			dw_body.Setitem(i, "item",      is_item)		
			dw_body.Setitem(i, "sojae",     is_mat_type)		
			dw_body.Setitem(i, "reg_id",    gs_user_id)	
			dw_body.Setitem(i, "reg_dt",    ld_datetime)							
		 else
			 dw_body.Setitem(i, "AMT",  dw_body.GetitemNumber(i, "cpu_tag_amt"))		
			 dw_body.Setitem(i, "REAL_MAKE_AMT",  dw_body.GetitemNumber(i, "cpu_real_make_price"))	
			 dw_body.Setitem(i, "mod_id", gs_user_id)
			 dw_body.Setitem(i, "mod_dt", ld_datetime)
		 end if	 
	else 
			dw_body.SetItemStatus(i, 0, Primary!, notModified!)
	end if
	
NEXT



il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
//입고종결량을 초과하는 입고 불가 (20080124~)
	select isnull(sum(qty),0) - isnull(max(b.last_qty),0)
		into :ll_lastover_qty
	from tb_41010_h a(nolock), tb_12021_d b(nolock)
	where a.style = b.style
	and   a.chno  = b.chno
	and   a.jup_gubn = 'i1'
	and   isnull(b.last_yn,'N') = 'Y'
	and   a.style = :is_style
	and   a.chno  = :is_chno;

	if ll_over_qty > 0 then 
		messagebox('확인','이미 입고종결된 품번으로 입고 불가합니다..')
		rollback  USING SQLCA;
		return -1
	end if
	
	
	commit  USING SQLCA;
	dw_head.setitem(1,"in_no",ls_in_no)
   dw_body.ResetUpdate()
   dw_list.retrieve(LeftA(is_style,1) ,is_style, is_chno, is_house_cd)	
	ll_out_row = dw_body.retrieve(is_style, is_chno, is_in_date, ls_in_no,'B')
	
	
	
	if ll_out_row  >= 1 then
			
		for kk = 1 to 	ll_out_row
			
			ls_color   = dw_body.getitemstring(kk, "color")
			ls_size    = dw_body.getitemstring(kk, "size")		
			ll_out_qty = dw_body.getitemNumber(kk, "qty")		
			
			IF ll_out_qty <> 0 THEN
				
				 DECLARE sp_41016_p01 PROCEDURE FOR sp_41016_p01  
					@yymmdd = :is_yymmdd,   
					@style  = :is_style,   
					@chno   = :is_chno,   
					@color  = :ls_color,   
					@size   = :ls_size,   
					@qty    = :ll_out_qty,   
					@brand  = :is_brand,   
					@reg_id = :gs_user_id,   
					@house_cd = :is_house_cd,   
					@shop_cd  = :is_shop_cd,   
					@shop_type = :is_shop_type,   
					@out_no = :ls_out_no output ;		
		
					EXECUTE sp_41016_p01 ;
					fetch   sp_41016_p01  into :ls_out_no;
					CLOSE   sp_41016_p01 ;

		   		commit  USING SQLCA; 
					dw_head.setitem(1,"out_no",ls_out_no) 
					 
			END IF	 
		
		next
	
	end if
else
   rollback  USING SQLCA;
end if




if il_rows = 1 then
	il_rows = dw_over.Update(TRUE, FALSE)
		if il_rows = 1 then
			commit  USING SQLCA;
			dw_over.ResetUpdate()
         dw_list.retrieve(LeftA(is_style,1) ,is_style, is_chno, is_house_cd)			
			dw_over.reset()
		else
			rollback  USING SQLCA;
		end if
end if		




This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_preview;string ls_brand, ls_yymmdd, ls_in_no

dw_head.AcceptText() 

ls_brand = dw_head.GetItemString(1, "BRAND")
ls_yymmdd = dw_head.GetItemString(1, "IN_DATE")
ls_in_no = dw_head.GetItemString(1, "IN_NO")


il_rows = dw_1.retrieve(LS_BRAND, LS_YYMMDD, Ls_in_no)


IF il_rows > 0 THEN
   dw_1.SetFocus()
	DW_1.VISIBLE = TRUE
ELSEIF il_rows = 0 THEN
		DW_1.VISIBLE = FALSE
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
		DW_1.VISIBLE = FALSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")

dw_over.SetTransObject(SQLCA)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_41001_e","0")
end event

type cb_close from w_com020_e`cb_close within w_41016_e
end type

type cb_delete from w_com020_e`cb_delete within w_41016_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_41016_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_41016_e
integer x = 2866
end type

type cb_update from w_com020_e`cb_update within w_41016_e
end type

type cb_print from w_com020_e`cb_print within w_41016_e
end type

type cb_preview from w_com020_e`cb_preview within w_41016_e
boolean enabled = true
string text = "전표조회(&V)"
end type

type gb_button from w_com020_e`gb_button within w_41016_e
integer x = 9
end type

type cb_excel from w_com020_e`cb_excel within w_41016_e
end type

type dw_head from w_com020_e`dw_head within w_41016_e
integer x = 9
integer y = 172
integer width = 3602
integer height = 524
string dataobject = "d_41016_h01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("in_house", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('A')


This.GetChild("jup_gubn", idw_jup_gubn)
idw_jup_gubn.SetTransObject(SQLCA)
idw_jup_gubn.Retrieve('024')


This.GetChild("class", idw_class)
idw_class.SetTransObject(SQLCA)
idw_class.Retrieve('401')


This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911') 



// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if



//ls_filter_str = ''	
//ls_filter_str = "shop_cd < '100000' "
//idw_house_cd.SetFilter(ls_filter_str)
//idw_house_cd.Filter( )


end event

event dw_head::itemchanged;
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "style" 
      IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "shop_cd" 
      IF ib_itemchanged THEN RETURN 1
		if LenA(data) <> 0 then
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
		end if	
   
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "brand" 
      IF ib_itemchanged THEN RETURN 1

      if data = "U" then 
			dw_head.setitem(1, "in_house" , "880000")
		else 	
			dw_head.setitem(1, "in_house" , "010000")
		end if			

	CASE "in_house" 
      IF ib_itemchanged THEN RETURN 1

      if data = "020000" then 
			dw_head.setitem(1, "class" , "B")
		else 	
   		dw_head.setitem(1, "class" , "A")
		end if	

   CASE "class" 
      IF ib_itemchanged THEN RETURN 1
		
		IF gs_user_id = "ASSIST" THEN
			if data = "B" then 
				dw_head.setitem(1, "in_house" , "040000")
			else	
				dw_head.setitem(1, "in_house" , "030000")			
			end if	
		ELSE
			if data = "B" then 
				dw_head.setitem(1, "in_house" , "020000")
			else	
				dw_head.setitem(1, "in_house" , "010000")			
			end if				
		END IF
END CHOOSE

end event

event dw_head::itemfocuschanged;
iF dw_head.AcceptText() <> 1 THEN RETURN 0
choose case dwo.name
	case "style"	
//
//       is_style = this.getitemstring(1,"style")

	case "chno"		
//       is_chno = this.getitemstring(1,"chno")
		 
		 
//		messagebox("",  is_style)
//		messagebox("",  is_chno)
		 
		

end choose		
end event

type ln_1 from w_com020_e`ln_1 within w_41016_e
integer beginy = 696
integer endy = 696
end type

type ln_2 from w_com020_e`ln_2 within w_41016_e
integer beginy = 700
integer endy = 700
end type

type dw_list from w_com020_e`dw_list within w_41016_e
integer x = 23
integer y = 712
integer width = 859
integer height = 1316
string dataobject = "d_41016_d01"
boolean hscrollbar = true
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

end event

event dw_list::doubleclicked;string ls_yymmdd, ls_in_no,ls_house_cd, ls_in_gubn,  ls_jup_gubn, ls_year
integer li_day_cnt

is_in_date = this.GetItemString(row, "yymmdd")
is_in_no  = this.GetItemString(row, "in_no")
is_jup_gubn = this.GetItemString(row, "jup_gubn")
is_in_gubn  = this.GetItemString(row, "in_gubn")
is_house_cd = this.GetItemString(row, "house_cd")
is_note     = this.GetItemString(row, "note")  

SELECT year + convert(char(01),dbo.sf_inter_sort_seq('003',season)), datediff( day, isnull(fix_dlvy, dlvy_ymd) , :is_in_date)
into :ls_year, :li_day_cnt
FROM tb_12021_d with (nolock)
WHERE style = :is_style
and   chno  = :is_chno;

if ls_year > '20052' then
	if li_day_cnt > 15 then
	  MessageBox("경고!","납기일이 15일을 초과했습니다!")
   	return -1
	end if
end if


il_rows = dw_body.retrieve(is_style, is_chno, is_in_date, is_in_no, "B")

if il_rows <= 0 then
	messagebox("경고!", "해당입고 전표는 계산서가 발생되어 수정할 수 없습니다!")
	return -1
end if	

dw_head.setitem(1, "in_date"  , is_in_date)
dw_head.setitem(1, "in_no"    , is_in_no)
dw_head.setitem(1, "house_cd" , is_house_cd)
dw_head.setitem(1, "jup_gubn" , is_jup_gubn)
dw_head.setitem(1, "in_gubn"  , is_in_gubn)
//dw_head.setitem(1, "note"     , is_note)

end event

type dw_body from w_com020_e`dw_body within w_41016_e
event ue_set_qty ( long al_row )
integer x = 887
integer y = 712
integer width = 2715
integer height = 1316
string dataobject = "d_41016_d02"
boolean hscrollbar = true
end type

event dw_body::ue_set_qty(long al_row);decimal ldc_qty_kor, ldc_qty_chn, ldc_qty

		ldc_qty_kor = dw_body.GetItemDecimal(al_row, "qty_kor")
		ldc_qty_chn = dw_body.GetItemDecimal(al_row, "qty_chn")
		
		if isnull(ldc_qty_kor) then ldc_qty_kor = 0
		if isnull(ldc_qty_chn) then ldc_qty_chn = 0
		
		ldc_qty = ldc_qty_kor + ldc_qty_chn
		dw_body.SetItem(al_row, "qty", ldc_qty)
		

end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
		// Column.Protect = True Then Return
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0 
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0 
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

Return 0
end event

event dw_body::itemchanged;CHOOSE CASE dwo.name
	CASE "qty_kor","qty_chn"
    IF is_in_gubn = "-" and dec(data) > 0 THEN
       messagebox("경고!", "반품 수량은 음수로입력하세요!")
		 return 1
	elseif	is_in_gubn = "+" and dec(data) < 0 then 
       messagebox("경고!", "입고 수량은 양수로입력하세요!")
		 return 1		 
	elseif dec(data) = 0 THEN
       messagebox("경고!", "입고수량을 0으로 입력할수 없습니다.")
		 return 1
    END IF

	   dw_body.setitem(ROW, "DC_rate" , il_dc_rate)

	case "qty_kor","qty_chn"
		post event ue_set_qty(row)

	 
END CHOOSE
end event

event dw_body::dberror;//
end event

type st_1 from w_com020_e`st_1 within w_41016_e
integer x = 878
integer y = 712
integer height = 1332
end type

type dw_print from w_com020_e`dw_print within w_41016_e
integer x = 2798
integer y = 920
integer width = 690
integer height = 292
end type

type cb_1 from commandbutton within w_41016_e
integer x = 379
integer y = 44
integer width = 347
integer height = 92
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "신규(&N)"
end type

event clicked;/*===========================================================================*/
/* 작성자      :                                                         */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF


dw_head.reset()
dw_head.insertrow(0)

dw_list.reset()
dw_list.insertrow(0)

dw_body.reset()
dw_body.insertrow(0)

dw_head.SetItem(1, "in_date" ,string(ld_datetime,"yyyymmdd"))
	
IF gs_user_id = "ASSIST" THEN
		dw_head.setitem(1, "in_house" , "030000")			
ELSE
		dw_head.setitem(1, "in_house" , "010000")			
END IF
//dw_head.SetItem(1, "in_house","010000")
dw_head.SetItem(1, "jup_gubn","I1")
dw_head.SetItem(1, "in_gubn" ,"+")
dw_head.SetItem(1, "class"   ,"A")
 
 
parent.Trigger Event ue_button(5, il_rows)
parent.Trigger Event ue_msg(5, il_rows)



end event

type dw_over from datawindow within w_41016_e
boolean visible = false
integer x = 37
integer y = 824
integer width = 3552
integer height = 916
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_41001_d05"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type dw_1 from datawindow within w_41016_e
boolean visible = false
integer x = 23
integer y = 496
integer width = 3570
integer height = 1556
integer taborder = 40
string title = "none"
string dataobject = "d_41001_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;DW_1.VISIBLE = FALSE
DW_HEAD.SETITEM(1, "IN_NO", "")
end event

