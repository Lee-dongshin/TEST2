$PBExportHeader$w_54009_e.srw
$PBExportComments$RT작업
forward
global type w_54009_e from w_com010_e
end type
type tab_1 from tab within w_54009_e
end type
type tabpage_1 from userobject within tab_1
end type
type dw_7 from datawindow within tabpage_1
end type
type dw_6 from datawindow within tabpage_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_7 dw_7
dw_6 dw_6
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_3
end type
type dw_3_head from datawindow within tabpage_3
end type
type dw_db from datawindow within tabpage_3
end type
type dw_5 from datawindow within tabpage_3
end type
type dw_4 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
dw_3_head dw_3_head
dw_db dw_db
dw_5 dw_5
dw_4 dw_4
end type
type tabpage_4 from userobject within tab_1
end type
type dw_9 from datawindow within tabpage_4
end type
type dw_8 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_9 dw_9
dw_8 dw_8
end type
type tabpage_5 from userobject within tab_1
end type
type dw_10_head from datawindow within tabpage_5
end type
type dw_10 from datawindow within tabpage_5
end type
type cb_exc from commandbutton within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_10_head dw_10_head
dw_10 dw_10
cb_exc cb_exc
end type
type tab_1 from tab within w_54009_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
type mle_title from multilineedit within w_54009_e
end type
type mle_url from multilineedit within w_54009_e
end type
type mle_content from multilineedit within w_54009_e
end type
type cb_5 from commandbutton within w_54009_e
end type
type cb_push from commandbutton within w_54009_e
end type
type mle_to_id from multilineedit within w_54009_e
end type
type dw_12 from datawindow within w_54009_e
end type
end forward

global type w_54009_e from w_com010_e
integer width = 3675
integer height = 2288
tab_1 tab_1
mle_title mle_title
mle_url mle_url
mle_content mle_content
cb_5 cb_5
cb_push cb_push
mle_to_id mle_to_id
dw_12 dw_12
end type
global w_54009_e w_54009_e

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_item , idw_shop_div
string is_brand,  is_year, is_season, is_frm_yymmdd, is_to_yymmdd, is_item, is_opt_between, is_opt_chno
string is_style, is_color, is_yymmdd, is_recall_no,  is_shop_div
int	 ii_sale_rate 
end variables

forward prototypes
public subroutine wf_retrieve_set ()
public subroutine wf_push_insert (string as_yymmdd, string as_brand)
end prototypes

public subroutine wf_retrieve_set ();
String ls_shop_cd,   ls_find , ls_error , ls_modify, ls_size ,ls_style, ls_chno
Long   ll_row, ll_row_cnt, ll_assort_cnt, ll_size_cnt , ll_max_k
Long   i, k, ll_out_qty , ll_sale_qty, ll_stock_qty, ll_recall_qty  ,j

ll_max_k = 0

ls_style = MidA(trim(is_style),1,8)
if is_opt_chno = "C" then
	ls_chno = "%"
else
	ls_chno = MidA(trim(is_style),10,1)
end if

il_rows = tab_1.tabpage_3.dw_5.Retrieve(ls_style, ls_chno)
ll_row_cnt    = tab_1.tabpage_3.dw_4.RowCount()
ll_assort_cnt = tab_1.tabpage_3.dw_5.RowCount()
IF ll_row_cnt < 1 THEN RETURN 

tab_1.tabpage_3.dw_db.Reset()
tab_1.tabpage_3.dw_3.Reset()
FOR i = 1  TO 8
	   ls_modify = ' t_size'      + String(i) + '.Visible=1' + &
                  ' t_out'       + String(i) + '.Visible=1' + &
                  ' t_sale'      + String(i) + '.Visible=1' + &
                  ' t_stock'     + String(i) + '.Visible=1' + &
                  ' t_rt'        + String(i) + '.Visible=1' + &						
                  ' in_qty_'     + String(i) + '.Visible=1' + &
                  ' sale_qty_'   + String(i) + '.Visible=1' + &
                  ' stock_qty_'  + String(i) + '.Visible=1' + &
                  ' rt_qty_'     + String(i) + '.Visible=1' 
						
     ls_Error = tab_1.tabpage_3.dw_3.Modify(ls_modify)			
	  	IF (ls_Error <> "") THEN 
		MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
	//	Return False
	END IF
NEXT 

	
For i = 1 to ll_row_cnt 
		IF ls_shop_cd <> tab_1.tabpage_3.dw_4.object.shop_cd[i] THEN 
      ls_shop_cd =  tab_1.tabpage_3.dw_4.object.shop_cd[i] 
		ll_row     =  tab_1.tabpage_3.dw_3.insertRow(0)
      tab_1.tabpage_3.dw_3.Setitem(ll_row, "part_div",   ls_shop_cd)

	for j = 1 to 8 
		tab_1.tabpage_3.dw_3.Setitem(ll_row, "in_qty_"    + String(j), 0)
		tab_1.tabpage_3.dw_3.Setitem(ll_row, "sale_qty_"  + String(j), 0)
		tab_1.tabpage_3.dw_3.Setitem(ll_row, "stock_qty_" + String(j), 0)
		tab_1.tabpage_3.dw_3.Setitem(ll_row, "rt_qty_"    + String(j), 0)		
	next
	 
	END IF 
	ls_find = "size = '" + tab_1.tabpage_3.dw_4.object.size[i] + "'"
   k = tab_1.tabpage_3.dw_5.find(ls_find, 1, ll_assort_cnt)	
  

	IF k > 0 THEN 
		ll_out_qty   =  tab_1.tabpage_3.dw_4.GetitemNumber(i, "out_qty")
		ll_sale_qty  =  tab_1.tabpage_3.dw_4.GetitemNumber(i, "sale_qty")
		ll_stock_qty =  tab_1.tabpage_3.dw_4.GetitemNumber(i, "shop_stock_qty")
		ll_recall_qty =  tab_1.tabpage_3.dw_4.GetitemNumber(i, "recall_qty")		
  	   tab_1.tabpage_3.dw_3.Setitem(ll_row, "in_qty_"  + String(k), ll_out_qty)
		tab_1.tabpage_3.dw_3.Setitem(ll_row, "sale_qty_" + String(k), ll_sale_qty)
		tab_1.tabpage_3.dw_3.Setitem(ll_row, "stock_qty_"  + String(k), ll_stock_qty)
		tab_1.tabpage_3.dw_3.Setitem(ll_row, "rt_qty_"  + String(k),    ll_recall_qty)		
		
      ls_modify = ' t_size'    + String(k) + '.text= "' + tab_1.tabpage_3.dw_4.object.size[i] + '"' 
		ls_Error = tab_1.tabpage_3.dw_3.Modify(ls_modify)
	
	 	if ll_max_k < k then	
  		 ll_max_k = k
   	end if
		IF (ls_Error <> "") THEN 
			MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
		END IF

	END IF

Next


FOR i = 1  TO 8
	IF i > ll_max_k   THEN
      ls_modify = ' t_size'    + String(i) + '.Visible=0' + &
                  ' t_out'     + String(i) + '.Visible=0' + &
                  ' t_sale'    + String(i) + '.Visible=0' + &
                  ' t_stock'   + String(i) + '.Visible=0' + &
                  ' t_rt'      + String(i) + '.Visible=0' + &						
                  ' in_qty_'     + String(i) + '.Visible=0' + &
                  ' sale_qty_'   + String(i) + '.Visible=0' + &
                  ' stock_qty_'  + String(i) + '.Visible=0' + &
                  ' rt_qty_'     + String(i) + '.Visible=0'
						
     ls_Error =  tab_1.tabpage_3.dw_3.Modify(ls_modify)			
	  	IF (ls_Error <> "") THEN 
		MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
	//	Return False
	END IF
	END IF
	

NEXT 



end subroutine

public subroutine wf_push_insert (string as_yymmdd, string as_brand);//푸쉬보내기
long i, ll_cnt
string ls_shop_cd

dw_12.retrieve(as_yymmdd, as_brand)

for i = 1 to dw_12.rowcount()
	ls_shop_cd = dw_12.getitemstring(i, 'shop_cd')
	
	mle_title.text = MidA(is_yymmdd,1,4) + '/'+ MidA(is_yymmdd,5,2) + '/'+ MidA(is_yymmdd,7,2) + ' 본사 지시 RT'
	mle_content.text = MidA(is_yymmdd,1,4) + '/'+ MidA(is_yymmdd,5,2) + '/'+ MidA(is_yymmdd,7,2) + ' 본사 지시 RT가 등록 되었습니다.'
	mle_url.text = 'RTSTORE||'+ls_shop_cd+'||'
	mle_to_id.text	= ls_shop_cd
	
	cb_push.triggerevent(clicked!)


	update tb_54009_h set push_yn = 'Y'
	from tb_54009_h
	where yymmdd 	= :as_yymmdd
			and brand 	= :as_brand
			and SHOP_CD = :ls_shop_cd
		 	and   accept_yn   like 'Y'
			and   isnull(push_yn,'N') = 'N'
			
	commit  USING SQLCA;

next

dw_12.reset()
end subroutine

on w_54009_e.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.mle_title=create mle_title
this.mle_url=create mle_url
this.mle_content=create mle_content
this.cb_5=create cb_5
this.cb_push=create cb_push
this.mle_to_id=create mle_to_id
this.dw_12=create dw_12
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.mle_title
this.Control[iCurrent+3]=this.mle_url
this.Control[iCurrent+4]=this.mle_content
this.Control[iCurrent+5]=this.cb_5
this.Control[iCurrent+6]=this.cb_push
this.Control[iCurrent+7]=this.mle_to_id
this.Control[iCurrent+8]=this.dw_12
end on

on w_54009_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.mle_title)
destroy(this.mle_url)
destroy(this.mle_content)
destroy(this.cb_5)
destroy(this.cb_push)
destroy(this.mle_to_id)
destroy(this.dw_12)
end on

event pfc_preopen();call super::pfc_preopen;
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_1, "ScaleToright&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_3.dw_3, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_4.dw_8, "ScaleToBottom")
inv_resize.of_Register(tab_1.tabpage_4.dw_9, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_3.dw_3_head, "ScaleToRight")
inv_resize.of_Register(tab_1.tabpage_5.dw_10_head, "ScaleToRight")
inv_resize.of_Register(tab_1.tabpage_5.dw_10, "ScaleToRight&bottom")

tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_4.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_5.SetTransObject(SQLCA)
tab_1.tabpage_1.dw_6.SetTransObject(SQLCA)
tab_1.tabpage_1.dw_7.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_db.SetTransObject(SQLCA)
tab_1.tabpage_4.dw_8.SetTransObject(SQLCA)
tab_1.tabpage_4.dw_9.SetTransObject(SQLCA)
tab_1.tabpage_5.dw_10.SetTransObject(SQLCA)
dw_12.SetTransObject(SQLCA)

//tab_1.tabpage_3.dw_3_head.SetTransObject(SQLCA)


end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_title
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

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

//is_yymmdd = string(ld_datetime, "yyyymmdd")

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"작업일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if


is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
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

is_opt_between = dw_head.GetItemString(1, "opt_between")
if IsNull(is_opt_between) or Trim(is_opt_between) = "" then
is_opt_between = "A"
end if


if is_opt_between <> "A" then
		is_frm_yymmdd = dw_head.GetItemString(1, "frm_yymmdd")
		if IsNull(is_frm_yymmdd) or Trim(is_frm_yymmdd) = "" then
			MessageBox(ls_title,"기준일자 입력하십시요!")
			dw_head.SetFocus()
			dw_head.SetColumn("frm_yymmdd")
			return false
		end if
		
		is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
		if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
			MessageBox(ls_title,"기준일자 입력하십시요!")
			dw_head.SetFocus()
			dw_head.SetColumn("to_yymmdd")
			return false
		end if
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"복종을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

ii_sale_rate = dw_head.GetItemNumber(1, "sale_rate")
if IsNull(ii_sale_rate) or ii_sale_rate = 0 then
   MessageBox(ls_title,"기준 판매율을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_rate")
   return false
end if

// is_opt_between, is_opt_chno

is_opt_chno = "c"
//dw_head.GetItemString(1, "style_opt")
//if IsNull(is_opt_chno) or Trim(is_opt_chno) = "" then
//is_opt_chno = "X"
//end if

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if


return true

end event

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_yymmdd",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "to_yymmdd",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "yymmdd",string(ld_datetime, "yyyymmdd"))
tab_1.tabpage_5.dw_10_head.SetItem(1, "yymmdd",string(ld_datetime, "yyyymmdd"))



end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if tab_1.selectedtab = 4 then
	tab_1.tabpage_4.dw_8.retrieve(is_yymmdd,IS_BRAND,is_shop_div)
else 	
	//exec sp_54009_d01 'n', '2001' ,'w', 'h', '20011201', '20011215', 'a','s'
	il_rows = tab_1.tabpage_1.dw_1.retrieve(is_brand, is_year, is_season, is_item,  is_frm_yymmdd, is_to_yymmdd, is_opt_between, is_opt_chno, ii_sale_rate, is_shop_div)
	IF il_rows > 0 THEN
		tab_1.tabpage_1.dw_1.SetFocus()
	ELSEIF il_rows = 0 THEN
		MessageBox("조회", "조회할 자료가 없습니다.")
	ELSE
		MessageBox("조회오류", "조회 실패 하였습니다.")
	END IF
	
	This.Trigger Event ue_button(1, il_rows)
	This.Trigger Event ue_msg(1, il_rows)
end if

end event

event resize;call super::resize;decimal ld_increase , ld_increase1
ld_increase = tab_1.tabpage_1.dw_1.height / 2

tab_1.tabpage_1.dw_6.resize(489, ld_increase)
tab_1.tabpage_1.dw_7.y = ld_increase + 10
tab_1.tabpage_1.dw_7.resize(489, ld_increase)

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      :                                                   */	
/* 작성일      :                                                   */	
/* 수정일      :                                                   */
/*===========================================================================*/
long     i, k, ll_row_count, ll_assort_cnt, ll_find, ll_rt_qty , ll_sale_qty, ll_out_qty
datetime ld_datetime
String   ls_shop_cd, ls_size, ls_find, ls_season, ls_year,ls_recall_no

	
if tab_1.selectedtab = 3 then

	select dbo.sf_style_season(substring(:is_style,1,8)),
	       dbo.sf_style_year(substring(:is_style,1,8))
   into :ls_season, :ls_year
	from dual;
	
	select  substring(convert(varchar(5), convert(decimal(5), isnull(max(recall_no), '0000')) + 10001), 2, 4) 
	into :ls_recall_no
	from tb_54009_h
	where brand = :is_brand
	and   yymmdd = :is_yymmdd;

	
ll_row_count = tab_1.tabpage_3.dw_3.RowCount()
	IF tab_1.tabpage_3.dw_3.AcceptText() <> 1 THEN RETURN -1
		
		/* 시스템 날짜를 가져온다 */
		IF gf_sysdate(ld_datetime) = FALSE THEN
			Return 0
		END IF
		
		
		ll_assort_cnt = tab_1.tabpage_3.dw_5.RowCount()
		
		FOR i=1 TO ll_row_count
			
			idw_status = tab_1.tabpage_3.dw_3.GetItemStatus(i, 0, Primary!)
			
			IF idw_status = NewModified! OR idw_status = DataModified! THEN	
				
				ls_shop_cd = tab_1.tabpage_3.dw_3.GetitemString(i, "part_div")

				FOR k = 1 TO ll_assort_cnt 
					
					IF tab_1.tabpage_3.dw_3.GetItemStatus(i, "rt_qty_" + String(k), Primary!) = DataModified! THEN 
						
						ll_rt_qty   = tab_1.tabpage_3.dw_3.GetitemNumber(i, "rt_qty_" + String(k))
						ll_sale_qty = tab_1.tabpage_3.dw_3.GetitemNumber(i, "sale_qty_" + String(k))
						ll_out_qty  = tab_1.tabpage_3.dw_3.GetitemNumber(i, "in_qty_" + String(k))
						ls_size     = tab_1.tabpage_3.dw_5.GetitemString(k, "size") 
						ls_find     = "shop_cd = '" + MidA(ls_shop_cd,1,6) + "' and size = '" + ls_size + "'"
						ll_find = tab_1.tabpage_3.dw_db.find(ls_find, 1, tab_1.tabpage_3.dw_db.RowCount())

						IF ll_find > 0 and ll_rt_qty <> 0 THEN
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "recall_qty",   ll_rt_qty)
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "mod_id",   gs_user_id)
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "mod_dt",   ld_datetime)
						ELSEif ll_find = 0 and ll_rt_qty <> 0 then
							ll_find = tab_1.tabpage_3.dw_db.insertRow(0)
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "brand",      is_brand)
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "yymmdd",     is_yymmdd)
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "recall_no",  ls_recall_no)					
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "no",         MidA(string(10000 + ll_find),2,4))								
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "shop_cd",    MidA(ls_shop_cd,1,6))
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "style",      MidA(is_style,1,8))
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "chno",       MidA(is_style,10,1))
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "color",      is_color)					
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "size",       ls_size)
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "year",       ls_year)
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "season",     ls_season)							
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "item",       is_item)														
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "out_qty",    ll_out_qty)
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "sale_qty",   ll_sale_qty)
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "recall_qty", ll_rt_qty)										
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "rcv_check",  "N")										
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "accept_yn",  "N")															
							tab_1.tabpage_3.dw_db.Setitem(ll_find, "reg_id",     gs_user_id)
						END IF
						
					END IF
					
				NEXT
				
			END IF
			
		NEXT
		
		
		il_rows = tab_1.tabpage_3.dw_db.Update()
		
		if il_rows = 1 then
			tab_1.tabpage_3.dw_3.ResetUpdate()
			tab_1.tabpage_3.dw_3_head.setitem(1, "yymmdd", is_yymmdd)
			tab_1.tabpage_3.dw_3_head.setitem(1, "recall_no", ls_recall_no)			
			commit  USING SQLCA;
		else
			rollback  USING SQLCA;
		end if
 else
		IF tab_1.tabpage_4.dw_9.AcceptText() <> 1 THEN RETURN -1
			ll_row_count = tab_1.tabpage_4.dw_9.RowCount()

		IF gf_sysdate(ld_datetime) = FALSE THEN
			Return 0
		END IF
		
		FOR i=1 TO ll_row_count
			idw_status = tab_1.tabpage_4.dw_9.GetItemStatus(i, 0, Primary!)
			IF idw_status = NewModified! OR idw_status = DataModified! THEN	
							tab_1.tabpage_4.dw_9.Setitem(ll_find, "mod_id",   gs_user_id)
							tab_1.tabpage_4.dw_9.Setitem(ll_find, "mod_dt",   ld_datetime)
 		   end if							
		NEXT
		il_rows = tab_1.tabpage_4.dw_9.Update()
		
		if il_rows = 1 then
			tab_1.tabpage_4.dw_9.ResetUpdate()
			commit  USING SQLCA;
			
		else
			rollback  USING SQLCA;
		end if
	
end if

   	This.Trigger Event ue_button(3, il_rows)
		This.Trigger Event ue_msg(3, il_rows)

		
return il_rows

end event

event ue_title;call super::ue_title;string ls_modify, ls_yymmdd, ls_print_opt

ls_yymmdd = MidA(tab_1.tabpage_5.dw_10_head.GetitemString(1, "yymmdd"),1,4) + "." + &
            MidA(tab_1.tabpage_5.dw_10_head.GetitemString(1, "yymmdd"),5,2) + "." + & 
            MidA(tab_1.tabpage_5.dw_10_head.GetitemString(1, "yymmdd"),7,2) 


ls_print_opt = tab_1.tabpage_5.dw_10_head.GetitemString(1, "print_opt")
				
If ls_print_opt = "B" then
	
	ls_modify =	" t_pgm_id.Text = '" + is_pgm_id + "' " + &
					" t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "' " + &
					" t_yymmdd.Text = '" + ls_yymmdd + "' " 
   					

	dw_print.Modify(ls_modify)
end if


end event

event ue_print();string ls_brand,ls_yymmdd, ls_recall_no, ls_shop_cd, ls_print_opt

 tab_1.tabpage_5.dw_10_head.AcceptText()


	   ls_yymmdd = tab_1.tabpage_5.dw_10_head.GetItemString(1, "yymmdd")
		if IsNull(ls_yymmdd) or Trim(ls_yymmdd) = "" then
			MessageBox("오류!","조회일자를 입력하십시요!")
			tab_1.tabpage_5.dw_10_head.SetFocus()
			tab_1.tabpage_5.dw_10_head.SetColumn("yymmdd")
		end if
		
		ls_brand= dw_head.GetItemString(1, "brand")
		if IsNull(ls_brand) or Trim(ls_brand) = "" then
			MessageBox("오류!","브랜드를 입력하십시요!")
			dw_head.SetFocus()
			dw_head.SetColumn("brand")
		end if

		ls_recall_no = tab_1.tabpage_5.dw_10_head.GetItemString(1, "recall_no")
		if IsNull(ls_recall_no) or Trim(ls_recall_no) = "" then
			ls_recall_no = "%"		
		end if
		
    	ls_shop_cd = tab_1.tabpage_5.dw_10_head.GetItemString(1, "shop_cd")
		if IsNull(ls_shop_cd) or Trim(ls_shop_cd) = "" then
			ls_shop_cd = "%"		
		end if
		
      ls_print_opt = tab_1.tabpage_5.dw_10_head.GetItemString(1, "print_opt")
		
This.Trigger Event ue_title()

if ls_print_opt = 'A' then
	dw_print.dataobject = "d_54009_d16"
elseif ls_print_opt = 'B' then
	dw_print.dataobject = "d_54009_d17"
end if	


   dw_print.SetTransObject(SQLCA)
	dw_print.RETRIEVE( ls_brand,ls_yymmdd, ls_recall_no, ls_shop_cd, is_shop_div)


IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_preview();string ls_brand,ls_yymmdd, ls_recall_no, ls_shop_cd, ls_print_opt

 tab_1.tabpage_5.dw_10_head.AcceptText()
 
	   ls_yymmdd = tab_1.tabpage_5.dw_10_head.GetItemString(1, "yymmdd")
		if IsNull(ls_yymmdd) or Trim(ls_yymmdd) = "" then
			MessageBox("오류!","조회일자를 입력하십시요!")
			tab_1.tabpage_5.dw_10_head.SetFocus()
			tab_1.tabpage_5.dw_10_head.SetColumn("yymmdd")
		end if
		
		ls_brand= dw_head.GetItemString(1, "brand")
		if IsNull(ls_brand) or Trim(ls_brand) = "" then
			MessageBox("오류!","브랜드를 입력하십시요!")
			dw_head.SetFocus()
			dw_head.SetColumn("brand")
		end if


		ls_recall_no = tab_1.tabpage_5.dw_10_head.GetItemString(1, "recall_no")
		if IsNull(ls_recall_no) or Trim(ls_recall_no) = "" then
			ls_recall_no = "%"		
		end if
		
    	ls_shop_cd = tab_1.tabpage_5.dw_10_head.GetItemString(1, "shop_cd")
		if IsNull(ls_shop_cd) or Trim(ls_shop_cd) = "" then
			ls_shop_cd = "%"		
		end if
		
      ls_print_opt = tab_1.tabpage_5.dw_10_head.GetItemString(1, "print_opt")
		

if ls_print_opt = 'A' then
	dw_print.dataobject = "d_54009_d16"
elseif ls_print_opt = 'B' then
	dw_print.dataobject = "d_54009_d17"
end if	

This.Trigger Event ue_title()
 
   dw_print.SetTransObject(SQLCA)
	dw_print.RETRIEVE(ls_brand, ls_yymmdd, ls_recall_no, ls_shop_cd, is_shop_div)

dw_print.inv_printpreview.of_SetZoom()

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54009_e","0")
end event

type cb_close from w_com010_e`cb_close within w_54009_e
end type

type cb_delete from w_com010_e`cb_delete within w_54009_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_54009_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_54009_e
end type

type cb_update from w_com010_e`cb_update within w_54009_e
end type

type cb_print from w_com010_e`cb_print within w_54009_e
end type

type cb_preview from w_com010_e`cb_preview within w_54009_e
boolean enabled = true
end type

type gb_button from w_com010_e`gb_button within w_54009_e
end type

type cb_excel from w_com010_e`cb_excel within w_54009_e
end type

type dw_head from w_com010_e`dw_head within w_54009_e
integer x = 41
integer y = 148
integer height = 260
string dataobject = "d_54009_h01"
end type

event dw_head::constructor;call super::constructor;string ls_type

This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')


This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)


This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
	
ls_Type = ls_Type + "inter_cd = 'G' or inter_cd = 'K' "
idw_shop_div.SetFilter(ls_Type)
idw_shop_div.Filter()

idw_shop_div.insertrow(1)
idw_shop_div.setitem(1, "inter_cd", "%")
idw_shop_div.setitem(1, "inter_nm", "전체")


end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child



CHOOSE CASE dwo.name

		
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
	
		This.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve(data)
//		idw_item.insertrow(1)
//		idw_item.Setitem(1, "item", "%")
//		idw_item.Setitem(1, "item_nm", "전체")		

		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
//		ldw_child.insertrow(1)
//		ldw_child.Setitem(1, "inter_cd", "%")
//		ldw_child.Setitem(1, "inter_nm", "전체")
		
  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
//		ldw_child.insertrow(1)
//		ldw_child.Setitem(1, "inter_cd", "%")
//		ldw_child.Setitem(1, "inter_nm", "전체")		
		
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_54009_e
integer beginy = 408
integer endy = 408
end type

type ln_2 from w_com010_e`ln_2 within w_54009_e
integer beginy = 412
integer endy = 412
end type

type dw_body from w_com010_e`dw_body within w_54009_e
boolean visible = false
integer x = 1925
integer y = 628
integer width = 1554
integer height = 1072
boolean enabled = false
end type

event dw_body::clicked;call super::clicked;string ls_style
choose case dwo.name
	case "style"
		ls_style = this.getitemstring(row, "style")
		gf_style_pic(LeftA(ls_style,8),"%")
end choose
end event

type dw_print from w_com010_e`dw_print within w_54009_e
integer x = 1527
integer y = 1332
string dataobject = "d_54009_d16"
end type

type tab_1 from tab within w_54009_e
integer x = 14
integer y = 416
integer width = 3584
integer height = 1636
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean focusonbuttondown = true
boolean boldselectedtext = true
alignment alignment = center!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3547
integer height = 1524
long backcolor = 79741120
string text = "스타일차수별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_7 dw_7
dw_6 dw_6
dw_1 dw_1
end type

on tabpage_1.create
this.dw_7=create dw_7
this.dw_6=create dw_6
this.dw_1=create dw_1
this.Control[]={this.dw_7,&
this.dw_6,&
this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_7)
destroy(this.dw_6)
destroy(this.dw_1)
end on

type dw_7 from datawindow within tabpage_1
integer x = 9
integer y = 764
integer width = 489
integer height = 752
integer taborder = 40
string title = "none"
string dataobject = "d_54009_d06"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_6 from datawindow within tabpage_1
integer x = 9
integer y = 8
integer width = 489
integer height = 740
integer taborder = 20
string title = "none"
string dataobject = "d_54009_d05"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within tabpage_1
integer x = 507
integer y = 8
integer width = 3040
integer height = 1512
integer taborder = 20
string title = "none"
string dataobject = "d_54009_d01"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;/*===========================================================================*/
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
end event

event doubleclicked;

//exec sp_54009_d02 'n', '2001' ,'w', 'h', 'NF1WH803','20011201', '20011215', 'a','c'
is_style = tab_1.tabpage_1.dw_1.GetitemString(row, "style") 

il_rows = tab_1.tabpage_2.dw_2.retrieve(is_brand, is_year, is_season, is_item, is_style, is_frm_yymmdd, is_to_yymmdd, is_opt_between, is_opt_chno, is_shop_div)

IF il_rows > 0 THEN
   tab_1.selectedtab = 2
   tab_1.tabpage_2.dw_2.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF


end event

event clicked;string ls_style

ls_style = tab_1.tabpage_1.dw_1.GetitemString(row, "style") 

il_rows = tab_1.tabpage_1.dw_6.retrieve(is_brand, MidA(ls_style,1,8))
il_rows = tab_1.tabpage_1.dw_7.retrieve(is_brand, MidA(ls_style,1,8))

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3547
integer height = 1524
long backcolor = 79741120
string text = "스타일차수칼라별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_2
integer x = 5
integer y = 4
integer width = 3525
integer height = 1516
integer taborder = 20
string title = "none"
string dataobject = "d_54009_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;DatawindowChild ldw_style1, ldw_color


/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_54009_d03 'n', '2001' ,'w', 'h', 'NF1WH803-0', '62' ,'20011201', '20011215', 'a','s'

is_color = MidA(tab_1.tabpage_2.dw_2.getitemstring(row, "color"),1,2)
is_style = MidA(tab_1.tabpage_2.dw_2.getitemstring(row, "style"),1,8)
is_item  = MidA(tab_1.tabpage_2.dw_2.getitemstring(row, "style"),5,1)

il_rows = tab_1.tabpage_3.dw_4.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_frm_yymmdd, is_to_yymmdd, is_opt_between, "X",' ',' ',is_shop_div)

wf_retrieve_set()

IF il_rows > 0 THEN
tab_1.tabpage_3.dw_3_head.reset()
tab_1.tabpage_3.dw_3_head.insertrow(0)
tab_1.tabpage_3.dw_3_head.setitem(1, "style", is_style)
tab_1.tabpage_3.dw_3_head.setitem(1, "color", is_color)

tab_1.tabpage_3.dw_3_head.GetChild("style1", ldw_style1 )
ldw_style1.SetTransObject(SQLCA)
ldw_style1.Retrieve(MidA(trim(is_style),1,8), "%")

tab_1.tabpage_3.dw_3_head.GetChild("color", ldw_color )
ldw_color.SetTransObject(SQLCA)
ldw_color.Retrieve("%")

tab_1.selectedtab = 3
tab_1.tabpage_3.dw_4.SetFocus()
 
END IF

end event

event constructor;/*===========================================================================*/
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
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3547
integer height = 1524
long backcolor = 79741120
string text = "매장별RT수량등록"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_3 dw_3
dw_3_head dw_3_head
dw_db dw_db
dw_5 dw_5
dw_4 dw_4
end type

on tabpage_3.create
this.dw_3=create dw_3
this.dw_3_head=create dw_3_head
this.dw_db=create dw_db
this.dw_5=create dw_5
this.dw_4=create dw_4
this.Control[]={this.dw_3,&
this.dw_3_head,&
this.dw_db,&
this.dw_5,&
this.dw_4}
end on

on tabpage_3.destroy
destroy(this.dw_3)
destroy(this.dw_3_head)
destroy(this.dw_db)
destroy(this.dw_5)
destroy(this.dw_4)
end on

type dw_3 from datawindow within tabpage_3
integer x = 5
integer y = 280
integer width = 3534
integer height = 1240
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_54009_d03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event editchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

event itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

type dw_3_head from datawindow within tabpage_3
integer x = 5
integer width = 3534
integer height = 272
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_54009_d07"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_style_origin, ls_style
CHOOSE CASE dwo.name
	CASE "cb_codi"

		ls_style_origin = tab_1.tabpage_3.dw_3_head.getitemstring(row, "style")
		ls_style = tab_1.tabpage_3.dw_3_head.getitemstring(row, "style1")
		is_style = MidA(ls_style,1,8)
      is_item  = MidA(ls_style,5,1)
	
   	il_rows = tab_1.tabpage_3.dw_4.retrieve(is_brand, is_year, is_season, is_item, is_style, is_color, is_frm_yymmdd, is_to_yymmdd, is_opt_between, is_opt_chno,is_yymmdd,ls_style_origin, is_shop_div)
		wf_retrieve_set()

		IF il_rows > 0 THEN
			tab_1.selectedtab = 3
			tab_1.tabpage_3.dw_4.SetFocus()
 		END IF

END CHOOSE

end event

type dw_db from datawindow within tabpage_3
boolean visible = false
integer x = 238
integer y = 604
integer width = 3259
integer height = 688
integer taborder = 30
boolean enabled = false
string title = "save"
string dataobject = "d_54009_d09"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_5 from datawindow within tabpage_3
boolean visible = false
integer x = 489
integer y = 552
integer width = 242
integer height = 528
integer taborder = 30
boolean enabled = false
string title = "사이즈"
string dataobject = "d_43006_d05"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_4 from datawindow within tabpage_3
boolean visible = false
integer x = 1243
integer y = 604
integer width = 2258
integer height = 552
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
string title = "실결과물"
string dataobject = "d_54009_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3547
integer height = 1524
long backcolor = 79741120
string text = "작업내용수정/승인"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_9 dw_9
dw_8 dw_8
end type

on tabpage_4.create
this.dw_9=create dw_9
this.dw_8=create dw_8
this.Control[]={this.dw_9,&
this.dw_8}
end on

on tabpage_4.destroy
destroy(this.dw_9)
destroy(this.dw_8)
end on

type dw_9 from datawindow within tabpage_4
integer x = 1806
integer y = 8
integer width = 1714
integer height = 1508
integer taborder = 20
string title = "none"
string dataobject = "d_54009_d11"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

event editchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

type dw_8 from datawindow within tabpage_4
integer y = 8
integer width = 1792
integer height = 1508
integer taborder = 20
string title = "none"
string dataobject = "d_54009_d10"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;/*===========================================================================*/
/* 작성자      :                                                   */	
/* 작성일      :                                                   */	
/* 수정일      :                                                   */
/*===========================================================================*/
string ls_yymmdd, ls_recall_no, ls_accept_yn, ls_chi_fg,ls_chi_fg_N
integer li_rtrn

CHOOSE CASE dwo.name
	CASE "accept_yn"
		ls_yymmdd = this.Getitemstring(row, "yymmdd")
		ls_recall_no = this.Getitemstring(row, "recall_no")		

		select accept_yn 
		into :ls_accept_yn
		from tb_54009_h
		where yymmdd = :ls_yymmdd
		and   recall_no = :ls_recall_no
		and   brand  = :is_brand ;
		
		 commit  USING SQLCA;
		
		if ls_accept_yn = 'Y' then
			li_rtrn = messagebox("알림!" ,"이미 승인된 번호입니다! 승인을 취소하시겠습니까?",Question!,YesNo!,1 )
			if li_rtrn = 1 then
		      update tb_54009_h set accept_yn = 'N'
				where brand = :is_brand
				and   yymmdd = :is_yymmdd
				and   recall_no = :ls_recall_no;
			
    			 commit  USING SQLCA;
				
			else
				messagebox("알림!" ,"작업을 취소했습니다!" )
         end if
		elseif 	ls_accept_yn = 'N' then
		
		      update tb_54009_h set accept_yn = 'Y'
				where brand = :is_brand
				and   yymmdd = :is_yymmdd
				and   recall_no = :ls_recall_no;
				
				 commit  USING SQLCA;
		
				messagebox("알림!" ,"작업을 승인했습니다!" )
      
		end if	

	CASE "chi_fg"
		ls_yymmdd = this.Getitemstring(row, "yymmdd")
		ls_recall_no = this.Getitemstring(row, "recall_no")	
		

   	 update tb_54009_h set chi_fg = :data
			where brand = :is_brand
			and   yymmdd = :is_yymmdd
			and   recall_no = :ls_recall_no;
			
			 commit  USING SQLCA;
	
			

//
//		select accept_yn 
//		into :ls_chi_fg
//		from tb_54009_h
//		where yymmdd = :ls_yymmdd
//		and   recall_no = :ls_recall_no
//		and   brand  = :is_brand ;
//		
//		if ls_chi_fg = 'Y' then
//			li_rtrn = messagebox("알림!" ,"중국용 작업내역을 국내용으로 전환하시겠습니까?",Question!,YesNo!,1 )
//			if li_rtrn = 1 then
//		      update tb_54009_h set chi_fg = 'N'
//				where brand = :is_brand
//				and   yymmdd = :is_yymmdd
//				and   recall_no = :ls_recall_no;
//				
// 			 commit  USING SQLCA;	
//			else
//				messagebox("알림!" ,"취소되었습니다!" )
//         end if
//			
//		elseif ls_chi_fg = 'T' then
//			li_rtrn = messagebox("알림!" ,"중국용 작업내역을 국내용으로 전환하시겠습니까?",Question!,YesNo!,1 )
//			if li_rtrn = 1 then
//		      update tb_54009_h set chi_fg = 'N'
//				where brand = :is_brand
//				and   yymmdd = :is_yymmdd
//				and   recall_no = :ls_recall_no;
//				
// 			 commit  USING SQLCA;	
//			else
//				messagebox("알림!" ,"취소되었습니다!" )
//         end if			
//		elseif 	ls_chi_fg = 'N' then
//		
//		      update tb_54009_h set chi_fg = 'Y'
//				where brand = :is_brand
//				and   yymmdd = :is_yymmdd
//				and   recall_no = :ls_recall_no;
//				
//				 commit  USING SQLCA;
//		
//				messagebox("알림!" ,"전환되었습니다!" )
//      
//		end if	
//						

END CHOOSE 
	
end event

event constructor;	 /*===========================================================================*/
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
end event

event doubleclicked;string ls_yymmdd, ls_recall_no

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

ls_yymmdd = tab_1.tabpage_4.dw_8.getitemstring(row, "yymmdd")
ls_recall_no = tab_1.tabpage_4.dw_8.getitemstring(row, "recall_no")

il_rows = tab_1.tabpage_4.dw_9.retrieve(is_brand, ls_yymmdd, ls_recall_no, is_shop_div)

end event

event buttonclicked;Long	ll_row_count, i
string ls_accept_yn, ls_chi_fg

CHOOSE CASE dwo.name
	CASE "cb_accept"
		If This.Object.cb_accept.Text = '전체승인' then
			ls_accept_yn = 'Y'
			This.Object.cb_accept.Text = '전체제외'
		Else
			ls_accept_yn = 'N'
			This.Object.cb_accept.Text = '전체승인'
		End If
		
		  update tb_54009_h set accept_yn = :ls_accept_yn
				where brand = :is_brand
				and   yymmdd = :is_yymmdd;
				
		  commit  USING SQLCA;
		 
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "accept_yn", ls_accept_yn)
		Next
		
	CASE "cb_chi"
				
		  update tb_54009_h set chi_fg = 'Y'
				where brand = :is_brand
				and   yymmdd = :is_yymmdd;
				
		  commit  USING SQLCA;
		 
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "chi_fg", 'Y')
		Next
		
	CASE "cb_house"
				
		  update tb_54009_h set chi_fg = 'N'
				where brand = :is_brand
				and   yymmdd = :is_yymmdd;
				
		  commit  USING SQLCA;
		 
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "chi_fg", 'N')
		Next		
		
	CASE "cb_com"
				
		  update tb_54009_h set chi_fg = 'X'
				where brand = :is_brand
				and   yymmdd = :is_yymmdd;
				
		  commit  USING SQLCA;
		 
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "chi_fg", 'X')
		Next				
		
	CASE "cb_taiwan"
				
		  update tb_54009_h set chi_fg = 'T'
				where brand = :is_brand
				and   yymmdd = :is_yymmdd;
				
		  commit  USING SQLCA;
		 
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "chi_fg", 'T')
		Next						
		
END CHOOSE

    
end event

type tabpage_5 from userobject within tab_1
event type integer ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
integer x = 18
integer y = 96
integer width = 3547
integer height = 1524
long backcolor = 79741120
string text = "     집계표     "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_10_head dw_10_head
dw_10 dw_10
cb_exc cb_exc
end type

event ue_popup;/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm, ls_shop_nm
DataStore  lds_Source
Boolean    lb_check 

CHOOSE CASE as_column
		CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   tab_1.tabpage_5.dw_10_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' or shop_nm like  '%" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				tab_1.tabpage_5.dw_10_head.SetRow(al_row)
				tab_1.tabpage_5.dw_10_head.SetColumn(as_column)
				tab_1.tabpage_5.dw_10_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				tab_1.tabpage_5.dw_10_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				tab_1.tabpage_5.dw_10_head.SetColumn("cust_type")
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

on tabpage_5.create
this.dw_10_head=create dw_10_head
this.dw_10=create dw_10
this.cb_exc=create cb_exc
this.Control[]={this.dw_10_head,&
this.dw_10,&
this.cb_exc}
end on

on tabpage_5.destroy
destroy(this.dw_10_head)
destroy(this.dw_10)
destroy(this.cb_exc)
end on

type dw_10_head from datawindow within tabpage_5
integer x = 9
integer width = 3515
integer height = 248
integer taborder = 110
string title = "none"
string dataobject = "d_54009_d13"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string ls_yymmdd, ls_recall_no, ls_shop_cd, ls_rpt_output, ls_title , ls_brand// ls_print_opt
String ls_shop_div
datetime ld_datetime
long ll_rows

ls_title = "조회오류"

CHOOSE CASE dwo.name

   CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	case  "rpt_output"
		IF ib_itemchanged THEN RETURN 1
		
	
		
		ls_yymmdd = tab_1.tabpage_5.dw_10_head.GetItemString(1, "yymmdd")
		if IsNull(ls_yymmdd) or Trim(ls_yymmdd) = "" then
			MessageBox(ls_title,"조회일자를 입력하십시요!")
			tab_1.tabpage_5.dw_10_head.SetFocus()
			tab_1.tabpage_5.dw_10_head.SetColumn("yymmdd")
			return 0
		end if
		
		ls_brand= dw_head.GetItemString(1, "brand")
		if IsNull(ls_brand) or Trim(ls_brand) = "" then
			MessageBox(ls_title,"브랜드를 입력하십시요!")
			dw_head.SetFocus()
			dw_head.SetColumn("brand")
			return 0
		end if
		
		ls_shop_div = dw_head.GetItemString(1, "shop_div")
		if IsNull(ls_shop_div) or Trim(ls_shop_div) = "" then
			MessageBox(ls_title,"유통망을 입력하십시요!")
			dw_head.SetFocus()
			dw_head.SetColumn("shop_div")
			return 0
		end if

		ls_recall_no = tab_1.tabpage_5.dw_10_head.GetItemString(1, "recall_no")
		if IsNull(ls_recall_no) or Trim(ls_recall_no) = "" then
			ls_recall_no = "%"		
		end if
		
		ls_shop_cd = tab_1.tabpage_5.dw_10_head.GetItemString(1, "shop_cd")
		if IsNull(ls_shop_cd) or Trim(ls_shop_cd) = "" then
			ls_shop_cd = "%"		
		end if		
		
		if data = 'S' then
			tab_1.tabpage_5.dw_10.dataobject = "d_54009_d12"
		elseif data = 'I' then
			tab_1.tabpage_5.dw_10.dataobject = "d_54009_d14"
		end if	
		
		tab_1.tabpage_5.dw_10.SetTransObject(SQLCA)	
		ll_rows = tab_1.tabpage_5.dw_10.retrieve(ls_brand, ls_shop_cd,ls_yymmdd,ls_recall_no, ls_shop_div)
		
		IF ll_rows > 0 THEN
			tab_1.tabpage_5.dw_10.SetFocus()
		ELSEIF ll_rows = 0 THEN
			MessageBox("조회", "조회할 자료가 없습니다.")
		ELSE
			MessageBox("조회오류", "조회 실패 하였습니다.")
		END IF

		
END CHOOSE

end event

event constructor;tab_1.tabpage_5.dw_10_head.insertrow(0)
end event

type dw_10 from datawindow within tabpage_5
integer x = 5
integer y = 252
integer width = 3529
integer height = 1268
integer taborder = 20
string title = "none"
string dataobject = "d_54009_d12"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_color

This.GetChild("brand", ldw_color )
ldw_color.SetTransObject(SQLCA)
ldw_color.Retrieve('%')

end event

type cb_exc from commandbutton within tabpage_5
integer x = 987
integer y = 36
integer width = 251
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "EXCEL"
end type

event clicked;/*===========================================================================*/
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
li_ret = tab_1.tabpage_5.dw_10.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type mle_title from multilineedit within w_54009_e
boolean visible = false
integer x = 1102
integer y = 136
integer width = 480
integer height = 68
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type mle_url from multilineedit within w_54009_e
boolean visible = false
integer x = 1627
integer y = 124
integer width = 480
integer height = 68
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type mle_content from multilineedit within w_54009_e
boolean visible = false
integer x = 2149
integer y = 124
integer width = 480
integer height = 68
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_5 from commandbutton within w_54009_e
boolean visible = false
integer x = 2208
integer width = 402
integer height = 84
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "push 테스트"
end type

event clicked;dw_head.accepttext()
is_yymmdd = dw_head.GetItemString(1, "yymmdd")
is_brand = dw_head.GetItemString(1, "brand")

//messagebox('is_yymmdd', is_yymmdd)
//messagebox('is_brand', is_brand)

//dw_12.retrieve(is_yymmdd, is_brand)

wf_push_insert(is_yymmdd, is_brand)
end event

type cb_push from commandbutton within w_54009_e
boolean visible = false
integer x = 2478
integer y = 44
integer width = 402
integer height = 84
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "PUSH"
end type

event clicked;string ls_title, ls_content, ls_url, ls_to_id

ls_title = mle_title.text
ls_content = mle_content.text
ls_url = mle_url.text
ls_to_id = mle_to_id.text

gf_push(ls_title, ls_content, ls_url, ls_to_id)


end event

type mle_to_id from multilineedit within w_54009_e
boolean visible = false
integer x = 2633
integer y = 116
integer width = 480
integer height = 68
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type dw_12 from datawindow within w_54009_e
boolean visible = false
integer x = 2807
integer y = 196
integer width = 663
integer height = 328
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_54009_d18"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

