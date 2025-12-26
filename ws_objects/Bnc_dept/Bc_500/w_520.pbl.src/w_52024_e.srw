$PBExportHeader$w_52024_e.srw
$PBExportComments$중국배분
forward
global type w_52024_e from w_com020_e
end type
type st_remark from statictext within w_52024_e
end type
type dw_assort from datawindow within w_52024_e
end type
type dw_db from datawindow within w_52024_e
end type
type dw_temp from datawindow within w_52024_e
end type
type cbx_rt from checkbox within w_52024_e
end type
type cb_copy from commandbutton within w_52024_e
end type
type cb_reset from commandbutton within w_52024_e
end type
type dw_reset from datawindow within w_52024_e
end type
type st_info from statictext within w_52024_e
end type
end forward

global type w_52024_e from w_com020_e
integer width = 3666
st_remark st_remark
dw_assort dw_assort
dw_db dw_db
dw_temp dw_temp
cbx_rt cbx_rt
cb_copy cb_copy
cb_reset cb_reset
dw_reset dw_reset
st_info st_info
end type
global w_52024_e w_52024_e

type variables
String  is_brand,  is_year,  is_season, is_sojae, is_item
String  is_yymmdd, is_style, is_chno,   is_color, is_color_nm, is_house_cd
Long    il_deal_seq 
Boolean ib_NewDeal
DataStore  ids_copy
DataWindowChild	idw_house_cd

end variables

forward prototypes
public function boolean wf_body_set ()
public subroutine wf_retrieve_set ()
public function boolean wf_temp_set ()
public subroutine wf_add_stock ()
end prototypes

public function boolean wf_body_set ();String  ls_modify,   ls_error
String  ls_size 
Long    ll_stock_qty
integer i, k

/* assort 내역 조회 */
il_rows = dw_assort.Retrieve(is_style, is_chno, is_color)

/* 사이즈 셋 */
FOR i = 1 TO 10 
	IF i > il_rows THEN
      ls_modify = ' t_size_'      + String(i) + '.Visible=0' + &
                  ' t_'           + String(i) + '.Visible=0' + &
                  ' t_1'          + String(i) + '.Visible=0' + &
                  ' t_2'          + String(i) + '.Visible=0' + &
                  ' t_3'          + String(i) + '.Visible=0' + &
                  ' t_4'          + String(i) + '.Visible=0' + &
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
                  ' cs_deal_'     + String(i) + '.Visible=0'
   ELSE
	   ls_size      = dw_assort.object.size[i] 
	   ll_stock_qty = dw_assort.object.stock_qty[i] 
      ls_modify = ' t_size_'      + String(i) + '.Text="' + ls_size + '"' + &
		            ' t_size_'      + String(i) + '.Visible=1' + &
                  ' t_'           + String(i) + '.Visible=1' + &
                  ' t_1'          + String(i) + '.Visible=1' + &
                  ' t_2'          + String(i) + '.Visible=1' + &
                  ' t_3'          + String(i) + '.Visible=1' + &
                  ' t_4'          + String(i) + '.Visible=1' + &
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
                  ' cs_deal_'     + String(i) + '.Visible=1'
						
	END IF
	ls_Error = dw_body.Modify(ls_modify)
	ls_Error = dw_print.Modify(ls_modify)
	IF (ls_Error <> "") THEN 
		MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
		Return False
	END IF
NEXT 

Return True 
end function

public subroutine wf_retrieve_set ();/*  배분내역 dw_body로 이관 */
String ls_shop_cd,   ls_find 
Long   ll_row, ll_row_cnt,  ll_assort_cnt 
Long   i, k, j,  ll_deal_qty,ll_stock_qty

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

public function boolean wf_temp_set ();/* 품번 수불내역 dw_body로 이관 */
String ls_shop_cd,   ls_find 
Long   ll_row, ll_row_cnt, ll_assort_cnt ,ll_stock_qty
Long   i, k, j
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
		
//		for j = 1 to ll_assort_cnt 
//				ll_stock_qty = dw_assort.object.stock_qty[j]		
//				dw_body.Setitem(i, "deal_qty_"  + String(j), ll_stock_qty)		
//		next
		
	END IF 
	ls_find = "size = '" + dw_temp.object.size[i] + "'"
   k = dw_assort.find(ls_find, 1, ll_assort_cnt)	
	IF k > 0 THEN 
		dw_body.Setitem(ll_row, "out_qty_"   + String(k), dw_temp.GetitemNumber(i, "out_qty"))
		dw_body.Setitem(ll_row, "rtrn_qty_"  + String(k), dw_temp.GetitemNumber(i, "rtrn_qty"))
		dw_body.Setitem(ll_row, "sale_qty_"  + String(k), dw_temp.GetitemNumber(i, "sale_qty"))

      lb_Chk = True
	END IF
NEXT

dw_body.ResetUpdate()
dw_body.SetRedraw(True)

Return lb_chk
end function

public subroutine wf_add_stock ();/* 배분내역이 존재할경우 배분가능량에 배분량만큼 추가로 처리*/
Long   k, ll_deal_qty, ll_stock_qty 
String ls_modify,      ls_Error

FOR k = 1 TO dw_ASSORT.RowCount()
  	 ll_deal_qty  = dw_body.GetitemNumber(1, "cs_deal_" + String(k)) 
	 ll_stock_qty = dw_assort.Object.stock_qty[k] + ll_deal_qty 
	 dw_assort.Setitem(k, "stock_qty", ll_stock_qty)
    ls_modify = 't_ord_'    + String(k) + '.text="' + String(ll_stock_qty) + '"'
    ls_Error  = dw_body.Modify(ls_modify)
    ls_Error  = dw_print.Modify(ls_modify)
    IF (ls_Error <> "") THEN 
		 MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
		 Return 
	 END IF
NEXT

end subroutine

on w_52024_e.create
int iCurrent
call super::create
this.st_remark=create st_remark
this.dw_assort=create dw_assort
this.dw_db=create dw_db
this.dw_temp=create dw_temp
this.cbx_rt=create cbx_rt
this.cb_copy=create cb_copy
this.cb_reset=create cb_reset
this.dw_reset=create dw_reset
this.st_info=create st_info
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_remark
this.Control[iCurrent+2]=this.dw_assort
this.Control[iCurrent+3]=this.dw_db
this.Control[iCurrent+4]=this.dw_temp
this.Control[iCurrent+5]=this.cbx_rt
this.Control[iCurrent+6]=this.cb_copy
this.Control[iCurrent+7]=this.cb_reset
this.Control[iCurrent+8]=this.dw_reset
this.Control[iCurrent+9]=this.st_info
end on

on w_52024_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_remark)
destroy(this.dw_assort)
destroy(this.dw_db)
destroy(this.dw_temp)
destroy(this.cbx_rt)
destroy(this.cb_copy)
destroy(this.cb_reset)
destroy(this.dw_reset)
destroy(this.st_info)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title, ls_yymmdd
datetime ld_datetime

IF as_cb_div = '1' THEN
	ls_title = "조회오류"
ELSEIF as_cb_div = '2' THEN
	ls_title = "추가오류"
ELSEIF as_cb_div = '3' THEN
	ls_title = "저장오류"
ELSE
	ls_title = "오류"
END IF


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_yymmdd = string(ld_datetime,"yyyymmdd")


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

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"품종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
  is_style = "%"  
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
  is_chno = "%"  
end if


il_deal_seq = dw_head.GetItemNumber(1, "deal_seq")
if IsNull(il_deal_seq) then
   MessageBox(ls_title,"배분차수를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_seq")
   return false
end if

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

if is_yymmdd > ls_yymmdd then
	messagebox("경고!" ,"미래일자 배분은 불가능합니다!")
   return false
end if	


is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */ 
/* 작성일      : 2002.02.01                                                  */
/* 수정일      : 2002.02.01                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_style, is_chno, is_house_cd)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(cb_copy, "FixedToRight")
inv_resize.of_Register(cbx_rt, "FixedToRight")
inv_resize.of_Register(st_remark, "ScaleToRight")
dw_assort.SetTransObject(SQLCA)
dw_temp.SetTransObject(SQLCA)
dw_db.SetTransObject(SQLCA)
//dw_detail.SetTransObject(SQLCA)
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

/* ORDER량 초과배분 여부 체크 */ 
FOR k = 1 TO dw_ASSORT.RowCount()
  	 ll_deal_qty = dw_body.GetitemNumber(1, "cs_deal_" + String(k)) 
	 IF ll_deal_qty = 0 THEN CONTINUE 
	 IF ll_deal_qty > dw_assort.Object.stock_qty[k] and is_house_cd <> '880000' THEN 
		 MessageBox("오류", "[" + dw_assort.GetitemString(k, "size") + "] 배분량이 초과 하였습니다,")
		 Return -1 
	 END IF
NEXT

ll_assort_cnt = dw_assort.RowCount()
il_rows = 1 
FOR i=1 TO ll_row_count
	IF il_rows <> 1 THEN EXIT 
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
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
				ELSE
					ll_find = dw_db.insertRow(0)
				   dw_db.Setitem(ll_find, "out_ymd",  is_yymmdd)
               dw_db.Setitem(ll_find, "deal_seq", il_deal_seq)
					IF cbx_rt.checked = TRUE THEN
                  dw_db.Setitem(ll_find, "deal_fg",  '3') 
					ELSE
                  dw_db.Setitem(ll_find, "deal_fg",  '1') 
					END IF
               dw_db.Setitem(ll_find, "style",    is_style)
               dw_db.Setitem(ll_find, "chno",     is_chno)
               dw_db.Setitem(ll_find, "shop_cd",  ls_shop_cd)
               dw_db.Setitem(ll_find, "color",    is_color)
               dw_db.Setitem(ll_find, "size",     ls_size)
               dw_db.Setitem(ll_find, "deal_qty", ll_deal_qty)
               dw_db.Setitem(ll_find, "reg_id",   gs_user_id)
					ll_resv_qty = ll_deal_qty
				END IF
            /* 예약 재고량 처리 */
	         IF gf_stresv_update (is_style,    is_chno,     is_color,   ls_size, &
				                     ls_shop_div, ll_resv_qty, is_house_cd, ls_ErrMsg) = FALSE THEN 
		         il_rows = -1
        			EXIT
	         END IF
			END IF
		NEXT
   END IF
NEXT

IF il_rows = 1 THEN 
   il_rows = dw_db.Update()
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

event open;call super::open;dw_head.Setitem(1, "sojae", '%')
dw_head.Setitem(1, "item", '%')

ids_copy = Create DataStore
ids_copy.DataObject = "d_52014_d01"

datetime ld_datetime
Date ld_date

IF gf_sysdate(ld_datetime) THEN
	ld_date = RelativeDate(Date(ld_datetime), -1)
Else
	ld_date = RelativeDate(Today(), -1)
END IF

dw_reset.insertrow(0)
dw_reset.SetItem(1, "reset_date",string(ld_date,"yyyymmdd"))




end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
String     ls_cust_nm , ls_style, ls_chno
Boolean    lb_check 
DataStore  lds_Source
String ls_style_no, ls_out_ymd
Long   ll_row, ll_tag_price

CHOOSE CASE as_column
	
			CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				
				if gs_brand <> 'K' then
					gst_cd.default_where   = " WHERE 1 = 1 "
				else
					gst_cd.default_where   = ""
				end if
				
				if gs_brand <> 'K' then
					IF Trim(as_data) <> "" THEN
						gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
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
            
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				//	dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
					dw_head.SetItem(al_row, "year", lds_Source.GetItemString(1,"year"))
					dw_head.SetItem(al_row, "season", lds_Source.GetItemString(1,"season"))
   				dw_head.SetItem(al_row, "item", lds_Source.GetItemString(1,"item"))
					dw_head.SetItem(al_row, "sojae", lds_Source.GetItemString(1,"sojae"))	
					
		ls_style = lds_Source.GetItemString(1,"style")			
		ls_chno  = lds_Source.GetItemString(1,"chno")					

		select dbo.sf_first_price(style),  min(out_ymd)
		into :ll_tag_price, :ls_out_ymd
		from tb_12030_s
		where style =  :ls_style
		  and chno  like  :ls_chno + '%'
		group by style;
		
		 st_info.text = "♥가격:" + string(ll_tag_price, "#,###") + "원/최초출고일:" + string(ls_out_ymd, "@@@@/@@/@@")
					
								
//  	   ls_style = lds_Source.GetItemString(1,"style")
//		ls_chno  = lds_Source.GetItemString(1,"chno")
//		
//   	IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN 0
//		IF wf_body_set() = FALSE THEN RETURN 0
//		
//		il_rows = dw_temp.retrieve(is_style, is_chno, is_color)
//		IF il_rows > 0 THEN 
//			wf_temp_set() 
//			ll_row = dw_db.Retrieve(is_yymmdd, il_deal_seq, is_style, is_chno, is_color)
//			IF ll_row > 0 THEN 
//				wf_retrieve_set() 
//				IF dw_db.Object.proc_yn[1] = 'Y' THEN 
//					st_remark.Text = "이미 출고된 자료 입니다."
//				ELSE
//					st_remark.Text = "이미 배분된 내역이 있습니다."
//				END IF
//				ib_NewDeal = False
//			ELSE
//				ib_NewDeal = True
//				st_remark.Text = ""
//			END IF
//			dw_body.SetFocus() 
//		END IF
//		
//		this.Trigger Event ue_button(7, il_rows)
//		
//		IF il_rows > 0 and ib_NewDeal = FALSE THEN 
//			IF dw_db.Object.proc_yn[1] = 'Y' THEN 
//				dw_body.Enabled = False
//			END IF
//		END IF
//
//		this.Trigger Event ue_msg(1, il_rows)
//								
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("deal_seq")
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

event close;call super::close;Destroy  ids_copy

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         cb_excel.enabled = true
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
      else
         dw_head.SetFocus()
      end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
		end if
      cb_excel.enabled = true	

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
         cb_excel.enabled = true
END CHOOSE

end event

event ue_delete();Long   ll_row
String ls_style_no, ls_style, ls_chno, ls_color, ls_proc_yn
String ls_ErrMsg
int    li_ret

ll_row = dw_list.GetSelectedRow(0)

IF ll_row < 1 THEN RETURN 

ls_style_no = dw_list.GetitemString(ll_row, "style_no")
ls_color    = dw_list.GetitemString(ll_row, "color")

li_ret = MessageBox("확인", "[" + ls_style_no + "][" + ls_color + "] 을 정말 삭제 하시겠습니까 ?", Question!, YesNo!)

IF li_ret = 2 THEN RETURN 

ls_style = LeftA(ls_style_no, 8)  
ls_chno  = MidA(ls_style_no, 9, 1)  

select top 1 proc_yn
  into :ls_proc_yn
  from dbo.tb_52031_h with (nolock)
 where out_ymd  = :is_yymmdd
   and deal_seq = :il_deal_seq
   and style    = :ls_style 
   and chno     = :ls_chno 
   and color    = :ls_color ;
	
IF isnull(ls_proc_yn) OR Trim(ls_proc_yn) = "" THEN 
	MessageBox("확인", String(is_yymmdd, "@@@@/@@/@@") + " " + String(il_deal_seq) + "차 자료에는 배분된 내역이 없습니다.")
	RETURN 
ELSEIF ls_proc_yn = 'Y' THEN
	MessageBox("확인", "이미 출고처리가 되여 삭제할수 없습니다.")
	RETURN 
END IF

DECLARE SP_52014_DELETE PROCEDURE FOR SP_52014_DELETE 
        @yymmdd    = :is_yymmdd, 
        @deal_seq  = :il_deal_seq, 
        @style     = :ls_style, 
        @chno      = :ls_chno, 
        @color     = :ls_color,
		  @house_cd  = :is_house_cd;

EXECUTE SP_52014_DELETE;
IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
   COMMIT;
	dw_body.Reset()
	dw_db.Reset()
   MessageBox("확인", "삭제 되였습니다 !.")
ELSE
	ls_ErrMsg = SQLCA.SqlErrText
	ROLLBACK;
	MessageBox("오류", ls_ErrMsg)
END IF

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_52024_e","0")
end event

event ue_title();call super::ue_title;

DateTime ld_datetime
String ls_modify, ls_datetime, ls_sale_type, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


ls_modify =	"t_pg_id.Text     = '" + is_pgm_id    + "'" + &
            "t_user_id.Text   = '" + gs_user_id   + "'" + &
            "t_datetime.Text  = '" + ls_datetime  + "'" + &
            "t_yymmdd.Text    = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_style.Text     = '" + is_style + "-" + is_chno + "'"  + &
            "t_color.Text     = '" + is_color + "'"  + &
            "t_rqst_no.Text   = '" + String(il_deal_seq) + "'"  				

dw_print.Modify(ls_modify)

end event

type cb_close from w_com020_e`cb_close within w_52024_e
integer x = 3232
end type

type cb_delete from w_com020_e`cb_delete within w_52024_e
integer x = 2606
integer width = 270
boolean enabled = true
end type

type cb_insert from w_com020_e`cb_insert within w_52024_e
boolean visible = false
integer x = 2066
integer width = 215
boolean enabled = true
string text = "복사(&C)"
end type

event cb_insert::clicked;//
ids_copy.Reset()

dw_body.RowsCopy(1, dw_body.RowCount(), Primary!, ids_copy, 1, Primary!)


end event

type cb_retrieve from w_com020_e`cb_retrieve within w_52024_e
integer x = 2885
end type

type cb_update from w_com020_e`cb_update within w_52024_e
end type

type cb_print from w_com020_e`cb_print within w_52024_e
boolean visible = false
integer x = 1298
integer y = 152
integer width = 384
integer height = 128
boolean enabled = true
string text = ""
end type

type cb_preview from w_com020_e`cb_preview within w_52024_e
boolean visible = false
integer x = 2830
integer width = 334
boolean enabled = true
end type

type gb_button from w_com020_e`gb_button within w_52024_e
end type

type cb_excel from w_com020_e`cb_excel within w_52024_e
integer x = 1778
integer width = 288
end type

type dw_head from w_com020_e`dw_head within w_52024_e
integer height = 204
string dataobject = "d_52024_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild  ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('003', gs_brand, '%')

This.GetChild("sojae", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('%', gs_brand)
ldw_child.insertrow(1)
ldw_child.Setitem(1, "sojae", "%")
ldw_child.Setitem(1, "sojae_nm", "전체")

This.GetChild("item", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve(gs_brand)
ldw_child.insertrow(1)
ldw_child.Setitem(1, "item", "%")
ldw_child.Setitem(1, "item_nm", "전체")

This.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String ls_yymmdd, ls_dep_ymd, ls_year, ls_brand
Datawindowchild ldw_child

CHOOSE CASE dwo.name
	CASE "yymmdd"      
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE  THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF


   CASE "style" 
      IF ib_itemchanged THEN RETURN 1
		IF isnull(data) or trim(data) = "" then RETURN 0
//
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
		
		

	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		
		This.GetChild("sojae", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('%', data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "sojae", "%")
		ldw_child.Setitem(1, "sojae_nm", "전체")
		
		This.GetChild("item", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve(data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "item", "%")
		ldw_child.Setitem(1, "item_nm", "전체")
		

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

type ln_1 from w_com020_e`ln_1 within w_52024_e
integer beginy = 372
integer endy = 372
end type

type ln_2 from w_com020_e`ln_2 within w_52024_e
integer beginy = 376
integer endy = 376
end type

type dw_list from w_com020_e`dw_list within w_52024_e
integer x = 0
integer y = 464
integer width = 1061
integer height = 1556
string title = "품번별 가용재고 List"
string dataobject = "d_52024_d02"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.04                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
String ls_style_no ,ls_tag_price, ls_out_ymd
Long   ll_row, ll_tag_price

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_style_no = This.GetItemString(row, 'style_no') 
is_color    = This.GetItemString(row, 'color') 

IF IsNull(ls_style_no) OR isNull(is_color) THEN return 
is_style = LeftA(ls_style_no, 8)
is_chno  = RightA(ls_style_no, 1)



select dbo.sf_first_price(style),  min(out_ymd)
into :ll_tag_price, :ls_out_ymd
from tb_12030_s (nolock)
where style =  :is_style
 and  chno  =  :is_chno
group by style;

 st_info.text = "♥가격:" + string(ll_tag_price, "#,###") + "원/최초출고일:" + string(ls_out_ymd, "@@@@/@@/@@")

IF wf_body_set() = FALSE THEN RETURN

il_rows = dw_temp.retrieve(is_style, is_chno, is_color,il_deal_seq)
IF il_rows > 0 THEN 
	wf_temp_set() 
	IF cbx_rt.checked = TRUE THEN
      ll_row = dw_db.Retrieve(is_yymmdd, il_deal_seq, is_style, is_chno, is_color, '3')
   ELSE
      ll_row = dw_db.Retrieve(is_yymmdd, il_deal_seq, is_style, is_chno, is_color, '1')
	END IF
	IF ll_row > 0 THEN 
		wf_retrieve_set() 
		IF dw_db.Object.proc_yn[1] = 'Y' THEN 
		   st_remark.Text = "이미 출고된 자료 입니다."
		ELSE
		   st_remark.Text = "이미 배분된 내역이 있습니다."
		END IF
		ib_NewDeal = False
	ELSE
		ib_NewDeal = True
		st_remark.Text = ""
	END IF
   dw_body.Enabled = True
   dw_body.SetFocus() 
END IF

Parent.Trigger Event ue_button(7, il_rows)

IF il_rows > 0 and ib_NewDeal = FALSE THEN 
   IF dw_db.Object.proc_yn[1] = 'Y' THEN 
      dw_body.Enabled = False
	END IF
END IF

Parent.Trigger Event ue_msg(1, il_rows)


end event

event dw_list::doubleclicked;call super::doubleclicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
String 	ls_search, ls_color
if row > 0 then 
	choose case dwo.name
		case 'style','style_no'
			ls_search 	= this.GetItemString(row,string(dwo.name))
			ls_color 	= this.GetItemString(row,"color")			
			if LenA(ls_search) >= 8 then gf_style_color_pic(ls_search, '%',ls_color)
	end choose	
end if

end event

type dw_body from w_com020_e`dw_body within w_52024_e
integer x = 1070
integer y = 388
integer width = 2546
integer height = 1632
string dataobject = "d_52024_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

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

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.04.15                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
IF LeftA(dwo.name, 8) = "deal_qty" and Long(Data) < 0 THEN
	RETURN 1
END IF 

end event

event dw_body::buttonclicked;call super::buttonclicked;/*  배분내역 dw_body로 이관 */
Long   i, k, ll_row_cnt, ll_col_cnt

IF dwo.name = "b_clear" THEN 
   IF ib_NewDeal = FALSE THEN 
      IF dw_db.Object.proc_yn[1] = 'Y' THEN 
         RETURN 
	   END IF
   END IF
	ll_row_cnt = dw_body.RowCount()
	ll_col_cnt = dw_assort.RowCount()
   dw_body.SetRedraw(False) 
	FOR i = 1 TO ll_row_cnt
      FOR k = 1 TO ll_col_cnt
	       dw_body.Setitem(i, "deal_qty_"  + String(k), 0)
		NEXT
	NEXT
   dw_body.SetRedraw(True)
END IF 



end event

type st_1 from w_com020_e`st_1 within w_52024_e
integer x = 1061
integer y = 472
integer height = 1532
end type

type dw_print from w_com020_e`dw_print within w_52024_e
integer x = 1477
integer y = 1140
end type

type st_remark from statictext within w_52024_e
integer x = 398
integer y = 52
integer width = 1152
integer height = 84
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 79741120
boolean focusrectangle = false
end type

type dw_assort from datawindow within w_52024_e
boolean visible = false
integer x = 768
integer y = 896
integer width = 2848
integer height = 780
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "assort"
string dataobject = "d_com520_chn"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_db from datawindow within w_52024_e
boolean visible = false
integer x = 471
integer y = 1344
integer width = 2990
integer height = 436
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "db"
string dataobject = "d_52024_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_temp from datawindow within w_52024_e
boolean visible = false
integer x = 1463
integer y = 828
integer width = 2025
integer height = 432
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "temp"
string dataobject = "d_52024_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_rt from checkbox within w_52024_e
boolean visible = false
integer x = 1573
integer y = 60
integer width = 201
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 79741120
string text = "RT"
borderstyle borderstyle = stylelowered!
end type

type cb_copy from commandbutton within w_52024_e
boolean visible = false
integer x = 2281
integer y = 44
integer width = 329
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "붙여놓기(&V)"
end type

event clicked;Long   ll_rows, ll_find, i, j, ll_deal_qty  
String ls_shop_cd

ll_rows = ids_copy.RowCount()

FOR i = 1 TO ll_rows 
	ls_shop_cd = ids_copy.GetitemString(i, "shop_cd")
	ll_find = dw_body.Find("shop_cd = '" + ls_shop_cd + "'", 1, dw_body.RowCount())
	IF ll_find < 1 THEN CONTINUE
	FOR j = 1 TO 10 
		ll_deal_qty = ids_copy.GetitemNumber(i, "deal_qty_" + String(j)) 
		IF ll_deal_qty <> 0 THEN 
			dw_body.Setitem(ll_find, "deal_qty_" + String(j), ll_deal_qty)
		END IF 
	NEXT
NEXT 

ib_changed = true
cb_update.enabled = true

end event

type cb_reset from commandbutton within w_52024_e
boolean visible = false
integer x = 375
integer y = 44
integer width = 549
integer height = 92
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "예약재고초기화(&R)"
end type

event clicked;dw_reset.visible = true
end event

type dw_reset from datawindow within w_52024_e
boolean visible = false
integer x = 567
integer y = 448
integer width = 946
integer height = 448
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "미출고 예약재고 처리"
string dataobject = "d_52014_d05"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild  ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String ls_yymmdd, ls_brand, ls_ok1, ls_ok2

CHOOSE CASE dwo.name
	CASE "cb_proc"      
		
	 ls_brand  = dw_reset.getitemstring(1, "brand")
	 if IsNull(ls_brand) or Trim(ls_brand) = "" then
	   MessageBox("경고!","대상브랜드를 입력하십시요!")
	   dw_reset.SetFocus()
	   dw_reset.SetColumn("brand")
		ls_ok1 = "N"
  	 else	
		ls_ok1 = "Y"
    end if
		
		
	 ls_yymmdd = dw_reset.getitemString(1, "reset_date")
	 if IsNull(ls_yymmdd) or Trim(ls_yymmdd) = "" then
	   MessageBox("경고!","대상일자를 입력하십시요!")
	   dw_reset.SetFocus()
	   dw_reset.SetColumn("reset_date")
		ls_ok2 = "N"
  	 else	
		ls_ok2 = "Y"
    end if
	 
	 
	if ls_ok1 <> "N" 	AND ls_ok2 <> "N" then

			DECLARE SP_DAYResv_Update PROCEDURE FOR SP_DAYResv_Update  
					@BRAND = :ls_brand,   
					@YYMMDD = :ls_yymmdd  ;
		
			EXECUTE SP_DAYResv_Update;
			commit  USING SQLCA;  
			MessageBox("알림!","처리되었습니다!")
	
	ELSE
		   MessageBox("경고!","처리조건을 모두 입력하십시요!")
	END IF	
	 
		

   CASE "cb_exit" 
     dw_reset.visible = false 	  
		  
END CHOOSE

end event

type st_info from statictext within w_52024_e
integer x = 59
integer y = 396
integer width = 1275
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 82042848
string text = "none"
boolean focusrectangle = false
end type

