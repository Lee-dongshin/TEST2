$PBExportHeader$w_sh126_e.srw
$PBExportComments$반품박스 등록(처리)
forward
global type w_sh126_e from w_com010_e
end type
type cb_1 from commandbutton within w_sh126_e
end type
type dw_point from datawindow within w_sh126_e
end type
type dw_list from datawindow within w_sh126_e
end type
type cb_txt from commandbutton within w_sh126_e
end type
type st_1 from statictext within w_sh126_e
end type
type shl_1 from statichyperlink within w_sh126_e
end type
end forward

global type w_sh126_e from w_com010_e
integer width = 2953
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
long backcolor = 16777215
event ue_tot_set ( )
event ue_total_retrieve ( )
event ue_point_update ( )
cb_1 cb_1
dw_point dw_point
dw_list dw_list
cb_txt cb_txt
st_1 st_1
shl_1 shl_1
end type
global w_sh126_e w_sh126_e

type variables
String is_box_ymd, is_box_no

end variables

forward prototypes
public function boolean wf_stock_chk (long al_row, string as_style_no, integer ai_qty)
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

public function boolean wf_stock_chk (long al_row, string as_style_no, integer ai_qty);String ls_style, ls_chno, ls_color, ls_size , ls_find, ls_style_no
Long   ll_stock_qty, ll_cnt_stop, ll_row_count, i, k, ll, ll_chk_qty

IF LenA(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)

select dbo.sf_get_stockqty(:gs_shop_cd, '%', :ls_style, :ls_chno, :ls_color, :ls_size)
  into :ll_stock_qty
  from dual;

ll_row_count = dw_body.rowcount() 

	for i = 1 to ll_row_count 
		ll = 0
		ls_find = "style_no = '" + ls_style + ls_chno +  ls_color + ls_size + "'"
		
		if i <> al_row then
			k = dw_body.find(ls_find, i, i )		
		else
			k  = 0
			ll = ai_qty
		end if
		
		if k <> 0 then
		 ll = dw_body.getitemnumber(k, "qty")
		end if
		
		ll_stock_qty = ll_stock_qty - ll
		
	next  

	IF sqlca.sqlcode <> 0 THEN 
		MessageBox("SQL 오류", SQLCA.SQLERRTEXT) 
		RETURN FALSE 
	end if

//	messagebox("ll_stock_qty1", ll_stock_qty)

iF ll_stock_qty < 0 THEN 
		MessageBox("확인", "재고가 없거나 이미 반품한 제품은 등록 할 수 없습니다!") 
		RETURN FALSE 
END IF

Return True

end function

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_size, ls_dep_fg, ls_dep_ymd
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn,ls_shop_type  
String ls_sale_type = space(2)
Decimal ldc_marjin
Long   ll_tag_price ,ll_curr_price, ll_out_price, ll_dc_rate

IF LenA(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)

//IF gf_out_marjin(is_box_ymd, gs_shop_cd, '1', ls_style, ls_sale_type, ldc_marjin, ll_dc_rate, & 
//						ll_curr_price, ll_out_price) = FALSE THEN 
//	RETURN False 
//END IF


Select brand,     year,     season ,item, sojae        
  into :ls_brand,  :ls_year, :ls_season, :ls_item, :ls_sojae
 from vi_12024_1 with (nolock)
	 where style = :ls_style 
		and chno  = :ls_chno
		and color = :ls_color 
		and size  = :ls_size;



IF SQLCA.SQLCODE <> 0 THEN 
	Return False 
END IF


////IF  ls_dep_fg <> 'Y'  THEN 
//	//dw_body.Setitem(al_row, "shop_type", '3')
////	messagebox("경고!", "정상 제품은 등록 하실 수 없습니다!")
//	Return False 
//ELSE
//	dw_body.Setitem(al_row, "shop_type", '1')
//END IF

	 
 select dbo.SF_GetShop_type_color(:is_box_ymd,:gs_shop_cd,:ls_style,:ls_color)
 into :ls_shop_type
 from dual;	
 
 
 dw_body.Setitem(al_row, "shop_type", ls_shop_type)

//IF wf_stock_chk(al_row, as_style_no, 1) THEN 
  dw_body.SetItem(al_row, "style_no", as_style_no)
   dw_body.SetItem(al_row, "style",    ls_style)
	dw_body.SetItem(al_row, "chno",     ls_chno)
	dw_body.SetItem(al_row, "color",    ls_color)
	dw_body.SetItem(al_row, "size",     ls_size)
	dw_body.SetItem(al_row, "qty",      1)	
	dw_body.SetItem(al_row, "class",    "A")		
	dw_body.SetItem(al_row, "brand",    ls_brand)
	dw_body.SetItem(al_row, "year",     ls_year)
	dw_body.SetItem(al_row, "season",   ls_season)
	dw_body.SetItem(al_row, "sojae",    ls_sojae)
	dw_body.SetItem(al_row, "item",     ls_item)
//ELSE
//	Return False
//END IF

 

Return True

end function

on w_sh126_e.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_point=create dw_point
this.dw_list=create dw_list
this.cb_txt=create cb_txt
this.st_1=create st_1
this.shl_1=create shl_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_point
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.cb_txt
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.shl_1
end on

on w_sh126_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_point)
destroy(this.dw_list)
destroy(this.cb_txt)
destroy(this.st_1)
destroy(this.shl_1)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(cb_1, "FixedToRight")
inv_resize.of_Register(shl_1, "FixedToRight")
//inv_resize.of_Register(st_1, "ScaleToRight&Bottom")

inv_resize.of_Register(dw_list, "ScaleToRight&Bottom")



dw_list.SetTransObject(SQLCA)






end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size, ls_shop_type
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source 
String ls_sale_type = space(2)
Decimal ldc_marjin
Long   ll_tag_price ,ll_curr_price, ll_out_price, ll_dc_rate

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = MidA(as_data,1,1)
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

CHOOSE CASE as_column
	CASE "style_no"		
			IF ai_div = 1 THEN 	
				IF wf_style_chk(al_row, as_data)  THEN
				   ll_row_cnt = dw_body.RowCount()
				   IF al_row = ll_row_cnt THEN 
					   ll_row_cnt = dw_body.insertRow(0)
				   END IF
					RETURN 1 
				END IF 
			END IF
			
		   ls_style = MidA(as_data, 1, 8)
		   ls_chno  = MidA(as_data, 9, 1)
		   ls_color = MidA(as_data, 10, 2)
		   ls_size  = MidA(as_data, 12, 2)
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com012" 
			gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" 
//									 " and plan_yn = 'N'  and isnull(dep_fg,'N') = 'Y' "
									 
//				                " and chno  LIKE '" + ls_chno  + "%'"  + &
//				                " and color LIKE '" + ls_color + "%'" + &
//				                " and size  LIKE '" + ls_size  + "%'"  + &
//									 
									 
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
				 ls_color = lds_Source.GetItemString(1,"color")				 
				 
				 select dbo.SF_GetShop_type_color(:is_box_ymd,:gs_shop_cd,:ls_style, :ls_color)
				 into :ls_shop_type
				 from dual;	
				 
			 	dw_body.Setitem(al_row, "shop_type", ls_shop_type)
				 

//				IF gf_out_marjin(is_box_ymd, gs_shop_cd, '1', ls_style, ls_sale_type, ldc_marjin, ll_dc_rate, & 
//										ll_curr_price, ll_out_price) = FALSE THEN 
// 				   ib_itemchanged = FALSE
//					return 1 	
////					RETURN 0
//				END IF

//				IF lds_Source.GetItemString(1,"plan_yn") = 'Y' THEN 
//            	messagebox("경고1!", "정상 제품만 등록 하실 수 있습니다!")
////					return 2					
// 				   ib_itemchanged = FALSE
//					return 1 	
//					//dw_body.Setitem(al_row, "shop_type", '3')
//				ELSE
//					dw_body.Setitem(al_row, "shop_type", '1')
//				END IF


	     //IF wf_stock_chk(al_row, lds_Source.GetItemString(1,"style_no"), 1) THEN 			
				   dw_body.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
				   dw_body.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				   dw_body.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "color", lds_Source.GetItemString(1,"color"))
				   dw_body.SetItem(al_row, "size", lds_Source.GetItemString(1,"size"))
				   dw_body.SetItem(al_row, "qty", 1)					
					dw_body.SetItem(al_row, "class", "A")
				   dw_body.SetItem(al_row, "brand", lds_Source.GetItemString(1,"brand"))
				   dw_body.SetItem(al_row, "year", lds_Source.GetItemString(1,"year"))
				   dw_body.SetItem(al_row, "season", lds_Source.GetItemString(1,"season"))
				   dw_body.SetItem(al_row, "sojae", lds_Source.GetItemString(1,"sojae"))
				   dw_body.SetItem(al_row, "item", lds_Source.GetItemString(1,"item"))
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
			//	else	
			//	   dw_body.SetColumn("style_no")
			//	END IF
				
				
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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string ls_title , ls_accept_yn

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

if MidA(gs_shop_cd,3,4) = '2000'  then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	


select dbo.SF_shop_rtrn_accept(:gs_shop_cd)
into :ls_accept_yn
from dual;

if ls_accept_yn = 'N' then
	messagebox("주의!", '반품등록 선정 매장에서 사용할 수 있습니다!')
	return false
end if	


is_box_ymd = dw_head.GetItemString(1, "box_ymd")
if IsNull(is_box_ymd) or Trim(is_box_ymd) = "" then
   MessageBox(ls_title,"등록일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("box_ymd")
   return false
end if


is_box_no = dw_head.GetItemString(1, "box_no")
if IsNull(is_box_no) or Trim(is_box_no) = "" then
	is_box_no = "%"
	
// MessageBox(ls_title,"박스번호를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("box_no")
//   return false	

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

end if

Return true 
 
end event

event ue_button(integer ai_cb_div, long al_rows);

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = false
         dw_body.SetFocus()
		   cb_retrieve.Text  = "조건(&I)"			
      end if
      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			if dw_head.Enabled = false then
				dw_body.Enabled = true
				dw_body.setfocus()
			end if
		end if
	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
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
		end if
   CASE 5    /* 조건 */
	   cb_retrieve.Text  = "조회(&I)"
      cb_delete.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true		
      dw_head.SetFocus()
      dw_head.SetColumn(1)
   CASE 6		/* 입력 */
      if al_rows > 0 then
         cb_delete.enabled = True
         dw_body.Enabled = true			
         dw_body.SetFocus()
      end if
      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
END CHOOSE

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
long	ll_cur_row
string ls_proc_yn


ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

ls_proc_yn = dw_body.GetItemstring (ll_cur_row, "proc_yn")	
if IsNull(ls_proc_yn) or Trim(ls_proc_yn) = "" then
  ls_proc_yn = "N"
end if


idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

IF idw_status = NewModified!	or ls_proc_yn = "N" THEN 
	il_rows = dw_body.DeleteRow (ll_cur_row)
	dw_body.SetFocus()	
else		
   dw_body.SetFocus()
	messagebox("알림!", "물류반품 의뢰 된 자료는 삭제 하실 수 없습니다!")
	RETURN 
END IF 



This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
String   ls_style_no,   ls_sale_fg,   ls_card_no  , ls_coupon_no , ls_jumin, ls_item
long     ll_sale_price, ll_goods_amt, ll_sale_qty , ll_coupon_amt, ll_accept_point
long     i, ll_row_count
datetime ld_datetime 
int     li_point_seq	

IF dw_body.AcceptText() <> 1 THEN RETURN -1


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

//if gs_shop_cd <> "OG0001" then
// messagebox("경고!", "현재 테스트대상 매장만 사용 가능합니다!")
// return -1
//end if
//

ll_row_count = dw_body.RowCount()
FOR i = ll_row_count to 1 step -1 
	ls_style_no = dw_body.GetitemString(i, "style_no")
	IF isnull(ls_style_no) THEN
		dw_body.DeleteRow(i) 
	END IF
NEXT 
ll_row_count = dw_body.RowCount()

IF ll_row_count > 0 AND dw_body.GetItemStatus(1, 0, Primary!) <> NewModified! THEN 
	is_box_no = dw_body.GetitemString(1, "box_no")
ELSE
//(BOX_YMD, Shop_Cd, box_No, No)	
	select  substring(convert(varchar(5), convert(decimal(5), isnull(max(box_no), '0000')) + 10001), 2, 4) 
	into :is_box_no
	from tb_42026_h with (nolock)
	where box_ymd = :is_box_ymd
	  and shop_cd = :gs_shop_cd;	
END IF


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN			/* New Record */  
      dw_body.Setitem(i, "no",  String(i, "0000"))
      dw_body.Setitem(i, "box_ymd", is_box_ymd)
      dw_body.Setitem(i, "shop_cd",  gs_shop_cd)
      dw_body.Setitem(i, "shop_div", gs_shop_div)
      dw_body.Setitem(i, "box_no",  is_box_no)
      dw_body.Setitem(i, "reg_id",   gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */	
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF 
	
NEXT


il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	cb_1.SetFocus()
else
   rollback  USING SQLCA;
end if


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
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

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if


il_rows = dw_list.Retrieve(is_box_ymd, gs_shop_cd, is_box_no) 


dw_body.Visible = False
dw_list.Visible = True

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "box_ymd" ,string(ld_datetime,"yyyymmdd"))
end event

event ue_insert();/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN 
END IF

il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_print();/*===========================================================================*/


This.Trigger Event ue_title ()

dw_LIST.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

//
//IF dw_print.RowCount() = 0 Then
//   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
//   il_rows = 0
//ELSE
//   il_rows = dw_print.Print()
//END IF
//This.Trigger Event ue_msg(6, il_rows)
//
end event

type cb_close from w_com010_e`cb_close within w_sh126_e
integer x = 2528
end type

type cb_delete from w_com010_e`cb_delete within w_sh126_e
integer taborder = 70
boolean enabled = true
end type

type cb_insert from w_com010_e`cb_insert within w_sh126_e
integer taborder = 60
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh126_e
integer x = 2185
integer taborder = 110
end type

type cb_update from w_com010_e`cb_update within w_sh126_e
integer taborder = 50
end type

type cb_print from w_com010_e`cb_print within w_sh126_e
integer taborder = 80
boolean enabled = true
end type

type cb_preview from w_com010_e`cb_preview within w_sh126_e
boolean visible = false
integer x = 1193
integer y = 48
integer taborder = 90
end type

type gb_button from w_com010_e`gb_button within w_sh126_e
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh126_e
integer y = 152
integer height = 112
string dataobject = "d_sh126_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_yymmdd
long ll_b_cnt

CHOOSE CASE dwo.name
	CASE "yymmdd"
		ls_yymmdd = String(Date(data), "yyyymmdd")
      IF GF_IWOLDATE_CHK(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN
			MessageBox("일자변경", "소급할수 없는 일자입니다.")
			Return 1
		END IF
		
	CASE "brand"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			dw_head.accepttext()
			gs_brand = dw_head.getitemstring(1,'brand')

			select isnull(count(brand),0)
			into	:ll_b_cnt
			from tb_91100_m  with (nolock) 
			where shop_cd like '%' + substring(:gs_shop_cd_1,3,4)
					and brand = :gs_brand;	
					
			if ll_b_cnt = 0 then 
				messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
				dw_body.reset()
				return 0
			end if
			gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
			Trigger Event ue_retrieve()
END CHOOSE

end event

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.object.brand_t.visible = true
	dw_head.object.brand.visible = true
else
	dw_head.object.brand_t.visible = false
	dw_head.object.brand.visible = false
end if


end event

type ln_1 from w_com010_e`ln_1 within w_sh126_e
integer beginy = 336
integer endy = 336
end type

type ln_2 from w_com010_e`ln_2 within w_sh126_e
integer beginy = 340
integer endy = 340
end type

type dw_body from w_com010_e`dw_body within w_sh126_e
event ue_set_column ( long al_row )
integer x = 9
integer y = 352
integer width = 2862
integer height = 1432
string dataobject = "d_sh126_d02"
boolean maxbox = true
boolean hscrollbar = true
end type

event dw_body::ue_set_column(long al_row);/* 품번 키보드 및 스캐너 입력시 다음 line으로 이동 */

dw_body.SetRow(al_row + 1)  
dw_body.SetColumn("style_no")

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.02.16                                                  */	
/* 수정일      : 2002.02.16                                                  */
/*===========================================================================*/
integer li_ret
String  ls_style_no

CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			li_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
   	IF LenA(This.GetitemString(row, "size")) = 2 THEN
			This.Post Event ue_set_column(row)
		else	
			return 1
		END IF 
		Return li_ret			

//	CASE "qty"	     //  Popup 검색창이 존재하는 항목 
//		ls_style_no = dw_body.getitemstring(row, "style_no")
//		
//		if len(ls_style_no) <> 13 then return 1
//		
//		if wf_stock_chk(row,ls_style_no, integer(data)) = false then
//			return 1
//		END IF 			
			
//		IF li_ret <> 1 THEN
//			This.Post Event ue_set_column(row) 
//		END IF


END CHOOSE

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.of_SetSort(False)

This.GetChild("color", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()




end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)                                           */	
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

event dw_body::getfocus;call super::getfocus;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)


end event

type dw_print from w_com010_e`dw_print within w_sh126_e
string dataobject = "d_sh126_R01"
end type

type cb_1 from commandbutton within w_sh126_e
event ue_keydown pbm_keydown
boolean visible = false
integer x = 1838
integer y = 44
integer width = 347
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "입력(&P)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
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

event clicked;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			dw_body.SetFocus()
			RETURN
	END CHOOSE
END IF

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

IF dw_body.Visible = FALSE THEN 
	dw_body.Visible = True
	dw_list.Visible = False
END IF

dw_head.setitem(1, "box_no", "")
dw_body.Reset()
il_rows = dw_body.insertRow(0)


Parent.Trigger Event ue_button(6, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_point from datawindow within w_sh126_e
boolean visible = false
integer x = 1723
integer y = 448
integer width = 846
integer height = 328
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh101_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_list from datawindow within w_sh126_e
event ue_syscommand pbm_syscommand
boolean visible = false
integer x = 5
integer y = 356
integer width = 2857
integer height = 1428
integer taborder = 110
boolean bringtotop = true
boolean titlebar = true
string title = "판매일보조회"
string dataobject = "d_sh126_d01"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
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

event constructor;DataWindowChild ldw_child 

This.GetChild("color", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('%')


end event

event doubleclicked;String ls_box_no, ls_out_no, ls_yymmdd, ls_proc_yn

IF row < 1 THEN RETURN

ls_box_no = This.GetitemString(row, "box_no")
ls_yymmdd = This.GetitemString(row, "yymmdd")
ls_out_no = This.GetitemString(row, "out_no")
ls_proc_yn = This.GetitemString(row, "proc_yn")


if ls_proc_yn = "N" then
	il_rows = dw_body.Retrieve(is_box_ymd, gs_shop_cd, ls_box_no) 
	
	IF il_rows > 0 THEN
		dw_body.SetFocus()
		dw_head.setitem(1, "box_no" , ls_box_no)
		dw_head.enabled = false
	END IF
	
	dw_body.visible = TRUE 
	dw_list.visible = FALSE
else
	messagebox("경고!", "이미 반품 요청 완료로 수정 불가능한 박스입니다!")
end if	



end event

type cb_txt from commandbutton within w_sh126_e
integer x = 375
integer y = 44
integer width = 347
integer height = 92
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "문서로저장"
end type

event clicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "txt", "Text Files (*.TXT),*.TXT,") <> 1 THEN
	RETURN
END IF	

lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)

if dw_list.visible = true then
	li_ret = dw_list.SaveAs(ls_doc_nm, Text!, TRUE)
else
	li_ret = dw_body.SaveAs(ls_doc_nm, Text!, TRUE)
end if


if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Text 파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\windows\notepad.exe " + ls_doc_nm, Maximized!)

end event

type st_1 from statictext within w_sh126_e
integer x = 27
integer y = 268
integer width = 2560
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 16777215
string text = "※ 반품내역 등록  저장 후  매장관리2 -> ~"13.반품처리물류의뢰~"  화면에서 박스별 처리!"
boolean focusrectangle = false
end type

type shl_1 from statichyperlink within w_sh126_e
integer x = 2345
integer y = 160
integer width = 526
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 67108864
string text = "* 메뉴얼 보기"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
string url = "http://with.ibeaucre.co.kr/instant/manual/dept_shop.asp"
end type

