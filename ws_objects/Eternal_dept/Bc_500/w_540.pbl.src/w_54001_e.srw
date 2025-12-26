$PBExportHeader$w_54001_e.srw
$PBExportComments$Reorder판단분석
forward
global type w_54001_e from w_com010_e
end type
type dw_list from datawindow within w_54001_e
end type
type dw_detail from datawindow within w_54001_e
end type
type cb_filter from commandbutton within w_54001_e
end type
type dw_filter from datawindow within w_54001_e
end type
end forward

global type w_54001_e from w_com010_e
integer width = 3675
integer height = 2280
string title = "Reorder판단분석"
event ue_filter ( )
dw_list dw_list
dw_detail dw_detail
cb_filter cb_filter
dw_filter dw_filter
end type
global w_54001_e w_54001_e

type variables
string   is_brand, is_year, is_season, is_out_seq, is_style, is_chno, is_end_yymmdd,is_yymmdd
string	is_sojae, is_item, is_sale_type, is_style_seq, is_save_opt, is_chn_yn
integer  ii_rc
decimal  is_outday_num,  is_saleday_num
DataWindowChild   idw_brand, idw_season, idw_out_seq, idw_sojae, idw_item
end variables

forward prototypes
public function integer wf_update (integer ai_rownum)
end prototypes

event ue_filter();
String   ls_filter_str = ''
Decimal  ld_in_sale_rate,  ld_avg_sale_qty

IF dw_filter.AcceptText() <> 1 THEN RETURN 

/* 입고대비판매율 Filter조건 생성 */
ld_in_sale_rate = dw_filter.GetItemDecimal(1, "in_sale_rate")
if IsNull(ld_in_sale_rate ) = false then
  ls_filter_str = 'sale_rate >= ' + String(ld_in_sale_rate) 
	
end if


/* 일평균판매수량 Filter조건 생성 */
ld_avg_sale_qty = dw_filter.GetItemDecimal(1, "avg_sale_qty")
if IsNull(ld_avg_sale_qty ) = false then
	if LenA(ls_filter_str) = 0 then
		ls_filter_str = ' avg_sale_qty >= ' + String(ld_avg_sale_qty)
	else
		ls_filter_str = ls_filter_str + ' and avg_sale_qty >= ' + String(ld_avg_sale_qty)
	end if	
end if

messagebox("ls_filter_str",ls_filter_str)

dw_body.SetFilter(ls_filter_str)
dw_body.Filter( )
end event

public function integer wf_update (integer ai_rownum);String    ls_style,ls_chno,ls_color
Long     ll_avg_sale_qty, ll_advice_qty

ls_style    = dw_body.GetItemString(ai_rownum,'style')
ls_chno    = dw_body.GetItemString(ai_rownum,'chno')
ls_color  = dw_body.GetItemString(ai_rownum,'color')
ll_avg_sale_qty = dw_body.GetItemNumber(ai_rownum,'avg_sale_qty')
ll_advice_qty = dw_body.GetItemNumber(ai_rownum,'advice_qty')

 
INSERT INTO TB_43010_H
       (  STYLE, CHNO,COLOR, BRAND, YEAR,SEASON,ITEM,SOJAE, AVG_SALE_QTY, ADVICE_QTY )  
VALUES ( :ls_style, :ls_chno,:ls_color, :is_brand, :is_year, :is_season, substring(:ls_style,5,1), 
         substring(:ls_style,2,1), :ll_avg_sale_qty,:ll_advice_qty )  ;

IF SQLCA.SQLCODE = -1 THEN
	/* KEY 중복 에러 이외에만 에러로 처리 */
	IF SQLCA.SQLDBCODE <> 1 THEN 
      RETURN -1
   END IF
END IF

RETURN 1

end function

on w_54001_e.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_detail=create dw_detail
this.cb_filter=create cb_filter
this.dw_filter=create dw_filter
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.cb_filter
this.Control[iCurrent+4]=this.dw_filter
end on

on w_54001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_detail)
destroy(this.cb_filter)
destroy(this.dw_filter)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : ue_retrieve                                                 */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_end_yymmdd, is_out_seq, is_year, is_season, is_sojae, is_item, is_sale_type, is_outday_num,is_saleday_num, is_style_seq, is_save_opt,is_chn_yn)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.25                                                  */	
/* 수정일      : 2002.01.25                                                  */
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

is_out_seq = dw_head.GetItemString(1, "out_seq")
if IsNull(is_out_seq) or Trim(is_out_seq) = "" then
   MessageBox(ls_title,"출고차수를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_seq")
   return false
end if



is_end_yymmdd = dw_head.GetItemString(1, "end_ymd")
if IsNull(is_end_yymmdd) or Trim(is_end_yymmdd) = "" then
   MessageBox(ls_title,"예상시즌 마감일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("end_ymd")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_sale_type = dw_head.GetItemString(1, "sale_type")
if IsNull(is_sale_type) or Trim(is_sale_type) = "" then
   MessageBox(ls_title,"판매구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_type")
   return false
end if

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"품종을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_chn_yn = dw_head.GetItemString(1, "chn_yn")
if IsNull(is_chn_yn) or Trim(is_chn_yn) = "" then
   MessageBox(ls_title,"지역구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("chn_yn")
   return false
end if


is_outday_num = dw_head.GetItemDecimal(1, "outday_num")
if IsNull(is_outday_num) or  is_outday_num  = 0 then
	is_outday_num  = 0
//   MessageBox(ls_title,"최초출고일부터 몇일 이내 인지 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("outday_num")
//   return false
end if

is_saleday_num = dw_head.GetItemDecimal(1, "saleday_num")
if IsNull(is_saleday_num) or  is_saleday_num  = 0 then
	 is_saleday_num  = 0
//   MessageBox(ls_title,"최초판매일부터 몇일 이내 인지 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("saleday_num")
//   return false
end if

is_style_seq = dw_head.GetItemString(1, "style_seq")
if IsNull(is_style_seq) or  is_style_seq  = "" then
	 is_style_seq  = "%"
end if

is_save_opt = dw_head.GetItemString(1, "save_opt")

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.25                                                  */	
/* 수정일      : 2002.01.25                                                  */
/*===========================================================================*/
String     ls_style
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style"	
		
		   IF ai_div = 1 THEN 	
				If IsNull(as_data) or Trim(as_data) = "" Then
				   dw_head.SetItem(al_row, "ls_style", "")
					RETURN 0
				END IF     
			END IF
			
			   gst_cd.ai_div          = ai_div
				gst_cd.window_title    = "STYLE 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = ""
				if gs_brand <> 'K' then					
					IF Trim(as_data) <> "" THEN
						gst_cd.Item_where = " STYLE LIKE '" + LeftA(as_data, 8) + "%' "
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
				ls_style = lds_Source.GetItemString(1,"style")

				dw_head.SetItem(al_row, "style", ls_style)
				
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_date")
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

event pfc_preopen();call super::pfc_preopen;

inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "FixedToBottom&ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_filter.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
dw_filter.InsertRow(0)

cb_insert.enabled = false
cb_delete.enabled = false
cb_preview.enabled = false
cb_print.enabled = false




end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.25                                                  */	
/* 수정일      : 2002.01.25                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
STRING   ls_chk_brand, ls_brand, ls_chk_bit
long    ll_reorder_cost, ll_chk_reorder
ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	ls_chk_bit = dw_body.GetItemString(i, "chk_bit")
	ll_reorder_cost = dw_body.GetItemNumber(i, "c_reorder_cost")
   IF idw_status = NewModified!  and ls_chk_bit = "Y" THEN				/* New Record */
      dw_body.Setitem(i, "reorder_cost", ll_reorder_cost)	
      dw_body.Setitem(i, "brand", is_brand)		
      dw_body.Setitem(i, "reg_id", gs_user_id)
      dw_body.Setitem(i, "reg_dt", ld_datetime)
   ELSEIF idw_status = DataModified! and ls_chk_bit = "Y" THEN		/* Modify Record */
	   ll_chk_reorder = dw_body.GetItemNumber(i, 'reorder_cost')
		IF isnull(ll_chk_reorder) THEN
         dw_body.SetItemStatus(i, 0, Primary!, NewModified!)			
			dw_body.Setitem(i, "reorder_cost", ll_reorder_cost)				
         dw_body.Setitem(i, "brand", is_brand)
         dw_body.Setitem(i, "reg_id", gs_user_id)
	      dw_body.Setitem(i, "reg_dt", ld_datetime)
		ELSE
			dw_body.Setitem(i, "reorder_cost", ll_reorder_cost)							
         dw_body.Setitem(i, "mod_id", gs_user_id)
         dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF
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

event ue_button;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징 (김 종호)               					  */	
/* 작성일      : 2002.01.28																  */	
/* 수성일      : 2002.01.28																  */
/*===========================================================================*/
/*	Event       : ue_button  																  */
/* Description : 버튼클릭시 발생                                             */
/* Update      : 수정가능                                                    */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then 
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
		   cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
         dw_body.SetFocus()      
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
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
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_update.enabled = false
      ib_changed = false
		cb_print.enabled = false
		cb_preview.enabled = false
		cb_excel.enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event ue_preview();call super::ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
//datetime ld_datetime
//This.Trigger Event ue_title ()
//
//IF gf_sysdate(ld_datetime) = FALSE THEN
//   ld_datetime = DateTime(Today(), Now())
//END IF
//
//is_yymmdd = String(ld_datetime, "yyyymmdd")
//
//dw_print.Retrieve(is_brand,is_year,is_season,is_out_seq, is_yymmdd)
//dw_print.inv_printpreview.of_SetZoom()
//
end event

event ue_title();call super::ue_title;

datetime ld_datetime
string ls_modify, ls_datetime,ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify  = "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'" + &
				 "t_out_seq.Text = '" + idw_out_seq.GetItemString(idw_out_seq.GetRow(), "inter_display") + "'" 
dw_print.Modify(ls_modify)




end event

event ue_print();call super::ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
//datetime ld_datetime
//
//This.Trigger Event ue_title()
//
//is_yymmdd = String(ld_datetime, "yyyymmdd")
//
//dw_print.Retrieve(is_brand,is_year,is_season,is_out_seq, is_yymmdd)
//
//IF dw_print.RowCount() = 0 Then
//   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
//   il_rows = 0
//ELSE
//   il_rows = dw_print.Print()
//END IF
//This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54001_e","0")
end event

event open;call super::open;dw_body.Object.DataWindow.HorizontalScrollSplit  = 926
end event

type cb_close from w_com010_e`cb_close within w_54001_e
integer taborder = 130
end type

type cb_delete from w_com010_e`cb_delete within w_54001_e
integer taborder = 80
end type

type cb_insert from w_com010_e`cb_insert within w_54001_e
integer taborder = 70
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_54001_e
end type

type cb_update from w_com010_e`cb_update within w_54001_e
integer taborder = 120
end type

type cb_print from w_com010_e`cb_print within w_54001_e
integer taborder = 90
end type

type cb_preview from w_com010_e`cb_preview within w_54001_e
integer taborder = 100
end type

type gb_button from w_com010_e`gb_button within w_54001_e
end type

type cb_excel from w_com010_e`cb_excel within w_54001_e
integer taborder = 110
end type

type dw_head from w_com010_e`dw_head within w_54001_e
integer x = 27
integer width = 2839
integer height = 352
string dataobject = "d_54001_h11"
boolean livescroll = false
end type

event dw_head::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.25                                                  */	
/* 수정일      : 2002.01.25                                                  */
/* event       : constructor(dw_head)                                        */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTRansObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

This.GetChild("out_seq", idw_out_seq)
idw_out_seq.SetTRansObject(SQLCA)
idw_out_seq.Retrieve('010')
idw_out_seq.insertRow(1)
idw_out_seq.SetItem(1, "inter_cd", "%")
idw_out_seq.SetItem(1, "inter_nm", "전체")

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.SetItem(1, "sojae", "%")
idw_sojae.SetItem(1, "sojae_nm", "전체")


This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.SetItem(1, "item", "%")
idw_item.SetItem(1, "item_nm", "전체")


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.25                                                  */	
/* 수정일      : 2002.01.25                                                  */
/*===========================================================================*/
String ls_year, ls_brand
DataWindowChild ldw_child



CHOOSE CASE dwo.name

	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
	
		This.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', data)
		idw_sojae.insertrow(1)
		idw_sojae.Setitem(1, "sojae", "%")
		idw_sojae.Setitem(1, "sojae_nm", "전체")
		
		This.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve(data)
		idw_item.insertrow(1)
		idw_item.Setitem(1, "item", "%")
		idw_item.Setitem(1, "item_nm", "전체")		
		
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

type ln_1 from w_com010_e`ln_1 within w_54001_e
integer beginy = 552
integer endy = 552
end type

type ln_2 from w_com010_e`ln_2 within w_54001_e
integer beginy = 556
integer endy = 556
end type

type dw_body from w_com010_e`dw_body within w_54001_e
integer x = 9
integer y = 572
integer height = 648
integer taborder = 50
string dataobject = "d_54001_d11"
boolean hsplitscroll = true
boolean livescroll = false
end type

event dw_body::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.25                                                  */	
/* 수정일      : 2002.01.25                                                  */
/*===========================================================================*/
DataWindowChild ldw_child

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify


This.GetChild("sojae", ldw_child )
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('%')


This.GetChild("item", ldw_child )
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('%')


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

event dw_body::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.25                                                  */	
/* 수정일      : 2002.01.25                                                  */
/*===========================================================================*/
string ls_style, ls_chno, ls_color, ls_out_ymd

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_style = This.GetItemString(row, 'style') /* DataWindow에 Key 항목을 가져온다 */
ls_chno = This.GetItemString(row, 'chno')
ls_color = This.GetItemString(row, 'color')
ls_out_ymd = This.GetItemString(row, 'out_ymd')
IF IsNull(ls_style) THEN return
IF IsNull(ls_chno) THEN return
IF IsNull(ls_color) THEN return

il_rows = dw_list.retrieve(ls_style,ls_chno,ls_color)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
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

event dw_body::doubleclicked;call super::doubleclicked;String 	ls_search, ls_color, ls_chno
if row > 0 then 
	choose case dwo.name
		case 'style','style_no'
			ls_search 	= this.GetItemString(row,string(dwo.name))
			ls_chno 	= this.GetItemString(row,"chno")			
			ls_color	= this.GetItemString(row,"color")						
			if LenA(ls_search) >= 8 then gf_style_color_pic(ls_search, ls_chno, ls_color)			
	end choose	
end if

end event

type dw_print from w_com010_e`dw_print within w_54001_e
integer x = 370
integer y = 872
string dataobject = "d_54001_r11"
end type

type dw_list from datawindow within w_54001_e
integer x = 14
integer y = 1224
integer width = 3579
integer height = 820
boolean bringtotop = true
string title = "none"
string dataobject = "d_54001_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_detail from datawindow within w_54001_e
boolean visible = false
integer x = 905
integer width = 1847
integer height = 1900
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "스타일정보"
string dataobject = "d_style_pic"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_filter from commandbutton within w_54001_e
event ue_postfocus ( )
integer x = 3287
integer y = 412
integer width = 279
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "검색(&F)"
end type

event ue_postfocus;This.Weight = 400
This.Italic = TRUE
end event

event clicked;pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

Parent.Trigger Event ue_filter()	//조건검색

SetPointer(oldpointer)
This.Enabled = True
end event

event getfocus;This.Weight = 700
This.Italic = FALSE
end event

event losefocus;This.Post Event ue_postfocus()
end event

type dw_filter from datawindow within w_54001_e
event ue_keydown ( )
integer x = 2866
integer y = 204
integer width = 709
integer height = 208
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_54001_h02"
borderstyle borderstyle = styleshadowbox!
end type

