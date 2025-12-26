$PBExportHeader$w_41013_e.srw
$PBExportComments$고정스케너입고처리
forward
global type w_41013_e from w_com010_e
end type
type dw_color from datawindow within w_41013_e
end type
type dw_size from datawindow within w_41013_e
end type
type dw_view from datawindow within w_41013_e
end type
type cb_input from commandbutton within w_41013_e
end type
type dw_shop_cd from datawindow within w_41013_e
end type
type cb_proc from commandbutton within w_41013_e
end type
end forward

global type w_41013_e from w_com010_e
integer width = 3675
integer height = 2232
string title = "매장실사재고등록"
event ue_input ( )
dw_color dw_color
dw_size dw_size
dw_view dw_view
cb_input cb_input
dw_shop_cd dw_shop_cd
cb_proc cb_proc
end type
global w_41013_e w_41013_e

type variables
DataWindowChild idw_brand,idw_color,idw_size, idw_shop_type
DataWindowChild idw_tran_cust, idw_house_cd, idw_shop_cd, idw_box_size
string is_brand, is_yymmdd, is_shop_cd,is_silsa_emp,is_file_nm, is_sil_no , is_house_cd
string is_shop_type, is_empno, is_proc_no, is_tran_cust, is_box_size
string is_proc_type, is_rot_yn, is_out_reg
integer il_box_no

end variables

forward prototypes
public function boolean wf_style_chk (long al_row, string as_style)
end prototypes

event ue_input();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
dw_view.Visible   = False
dw_body.Visible   = True

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN 

if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox("입력","브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return 
end if

dw_head.setitem(1,"proc_no","")
dw_head.setitem(1, "cust_nm",  "")
dw_head.setitem(1, "plan_kor", "")				
dw_head.setitem(1, "plan_chi", "")						
dw_head.setitem(1, "mis_kor", "")						
dw_head.setitem(1, "mis_chi", "")	

dw_body.reset()

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

public function boolean wf_style_chk (long al_row, string as_style);
String ls_style, ls_chno, ls_color,  ls_size, ls_shop_type, ls_given_fg, ls_given_ymd, ls_chk_style
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn ,ls_out_no, ls_row_no
String ls_o_status, ls_o_ProductCode, ls_o_ProductName, ls_o_ord_qty_R, ls_o_ord_qty_F, ls_o_mis_qty_R, ls_o_mis_qty_F
Long   ll_tag_price 

IF LenA(Trim(as_style)) <> 13 THEN RETURN FALSE


ls_style = MidA(as_style, 1, 8)
ls_chno  = MidA(as_style, 9, 1)
ls_color = MidA(as_style, 10, 2)
ls_size  = MidA(as_style, 12, 2)
ls_row_no = string(al_row)

if al_row > 1 then 
	ls_chk_style = dw_body.getitemstring(1,"style")
	if ls_style <> ls_chk_style then 
		messagebox("경고!", "한번에 한 스타일만 작업 가능합니다!")
		return false
	end if
end if	
	
			
		  DECLARE style_info PROCEDURE FOR sp_style_info  
         @proc_type 	= :is_proc_type,   
         @brand 		= :is_brand,   
         @style 		= :ls_style,   
         @chno 		= :ls_chno,   
         @color 		= :ls_color,   
         @size 		= :ls_size,   
			@row_no		= :ls_row_no,
			@o_Status	= :ls_o_status				out,
			@o_ProductCode	= :ls_o_ProductCode 	out,
			@o_ProductName	= :ls_o_ProductName	out,
			@o_ord_qty_R	= :ls_o_ord_qty_R		out,
			@o_ord_qty_F	= :ls_o_ord_qty_F		out,
			@o_mis_qty_R	= :ls_o_mis_qty_R		out,
			@o_mis_qty_F	= :ls_o_mis_qty_F		out;
					


		 EXECUTE style_info ;
 		 fetch   style_info  into :ls_o_status, :ls_o_ProductCode,:ls_o_ProductName, :ls_o_ord_qty_R, :ls_o_ord_qty_F, :ls_o_mis_qty_R,:ls_o_mis_qty_F ;
		 CLOSE   style_info ;
					
		IF SQLCA.SQLCODE = -1 THEN 
			MessageBox("SQL오류", SQLCA.SqlErrText) 
			Return false
		ELSE
			if ls_o_status = "0" then
				dw_head.setitem(1, "cust_nm",  ls_o_ProductName)
				dw_head.setitem(1, "plan_kor", ls_o_ord_qty_R)				
				dw_head.setitem(1, "plan_chi", ls_o_ord_qty_F)						
				dw_head.setitem(1, "mis_kor", ls_o_mis_qty_R)						
				dw_head.setitem(1, "mis_chi", ls_o_mis_qty_F)						
			else
				MessageBox("주의!", ls_o_ord_qty_R) 
			   Return false
			end if
		END IF 		





Select brand,     year,     season,     
       sojae,     item,     tag_price,     plan_yn   
  into :ls_brand, :ls_year, :ls_season, 
       :ls_sojae, :ls_item, :ll_tag_price, :ls_plan_yn    
  from vi_12024_1 with (nolock)
 where style = :ls_style 
	and chno  = :ls_chno
	and color = :ls_color 
	and size  = :ls_size
	and brand = :is_brand
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

on w_41013_e.create
int iCurrent
call super::create
this.dw_color=create dw_color
this.dw_size=create dw_size
this.dw_view=create dw_view
this.cb_input=create cb_input
this.dw_shop_cd=create dw_shop_cd
this.cb_proc=create cb_proc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_color
this.Control[iCurrent+2]=this.dw_size
this.Control[iCurrent+3]=this.dw_view
this.Control[iCurrent+4]=this.cb_input
this.Control[iCurrent+5]=this.dw_shop_cd
this.Control[iCurrent+6]=this.cb_proc
end on

on w_41013_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_color)
destroy(this.dw_size)
destroy(this.dw_view)
destroy(this.cb_input)
destroy(this.dw_shop_cd)
destroy(this.cb_proc)
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

il_rows = dw_view.retrieve(is_proc_type, is_yymmdd, is_proc_no, is_house_cd, "1", is_brand)
IF il_rows > 0 THEN
	dw_view.visible = true
   dw_view.SetFocus()
	cb_print.enabled = true
	cb_preview.enabled = true	
else
	messagebox("알림!", "조회 할 자료가 없습니다!")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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


	is_brand = dw_head.GetItemString(1, "brand") 
	if IsNull(is_brand) or Trim(is_brand) = "" then 
		MessageBox(ls_title,"브랜드를 입력하십시요!") 
		dw_head.SetFocus() 
		dw_head.SetColumn("brand") 
		return false
	end if
	
	is_house_cd = dw_head.GetItemString(1, "house_cd") 
	if IsNull(is_house_cd) or Trim(is_house_cd) = "" then 
		MessageBox(ls_title,"창고를 입력하십시요!") 
		dw_head.SetFocus() 
		dw_head.SetColumn("house_cd") 
		return false
	end if
	

	
	is_shop_cd = is_house_cd
	
	is_shop_type = '1'
	
	is_yymmdd = dw_head.GetItemString(1, "yymmdd") 
	if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then 
		MessageBox(ls_title,"작업일자를 입력하십시요!") 
		dw_head.SetFocus() 
		dw_head.SetColumn("yymmdd") 
		return false
	end if
		
	is_proc_no = dw_head.GetItemString(1, "proc_no") 
	if IsNull(is_proc_no) or Trim(is_proc_no) = "" then 
		is_proc_no = "%"
	end if	
	
	
	is_proc_type = dw_head.GetItemString(1, "proc_type") 
	if IsNull(is_proc_type) or Trim(is_proc_type) = "" then 
		MessageBox(ls_title,"작업구분을 입력하십시요!") 
		dw_head.SetFocus() 
		dw_head.SetColumn("proc_type") 
		return false
	end if
	

is_out_reg = dw_head.GetItemString(1, "out_reg") 
	

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
 				gst_cd.default_where   = "WHERE brand = '" + ls_brand + "'"				
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

				ls_style    = lds_Source.GetItemString(1,"style")
			   ls_chno     = lds_Source.GetItemString(1,"chno")
				ls_color    = lds_Source.GetItemString(1,"color") 
				ls_size  	= lds_Source.GetItemString(1,"size")
				
				if wf_style_chk(al_row, ls_style + ls_chno + ls_color + ls_size) <> true then
					ib_itemchanged = FALSE
					return 1 	
				end if 	
				
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
inv_resize.of_Register(cb_input, "FixedToRight")
dw_shop_cd.SetTransObject(SQLCA)
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
string	ls_style_chk, ls_style , ls_year, ls_season , ls_item, ls_sojae, LS_proc_no
integer  li_no


ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

   IF LenA(is_proc_no) <> 4 then
		select  substring(convert(varchar(5), convert(decimal(5), isnull(max(proc_no), '0000')) + 10001), 2, 4) 
		into :ls_proc_no
		from tb_42028_h with (nolock)
		where  yymmdd = :is_yymmdd;
		
		li_no = 1
   else
		ls_proc_no = is_proc_no
		
		select max(isnull(no,0)) + 1  
		into :li_no
		from tb_42028_h with (nolock)
		where brand =  :is_brand
		and   yymmdd = :is_yymmdd
		and   proc_no = :ls_proc_no ;

	end if	

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */

      ls_style = dw_body.getitemstring(i, "style")
		
			select year, season,item, sojae 
			into :ls_year, :ls_season, :ls_item, :ls_sojae
			from tb_12020_m
			where style = :ls_style;

//proc_type, YYMMDD, PROC_NO, SHOP_CD, SHOP_TYPE, NO


		dw_body.setitem(i, "proc_type" , is_proc_type)
		dw_body.setitem(i, "proc_no"   , ls_proc_no)
      dw_body.Setitem(i, "no"        , string(li_no,"0000"))
		dw_body.setitem(i, "year"      , ls_year)
		dw_body.setitem(i, "season"    , ls_season)			
		dw_body.setitem(i, "item"      , ls_item)			
		dw_body.setitem(i, "sojae"     , ls_sojae)					
	   DW_BODY.SETITEM(I, "brand"     , is_brand)
	   DW_BODY.SETITEM(I, "house_cd"  , is_house_cd)		
	   DW_BODY.SETITEM(I, "shop_cd"   , is_house_cd)
	   DW_BODY.SETITEM(I, "rot_yn"   , is_out_reg)		
	   DW_BODY.SETITEM(I, "shop_type" , "1")
	   DW_BODY.SETITEM(I, "yymmdd"    , is_yymmdd)		
	   DW_BODY.SETITEM(I, "pda_no"    , "009")				
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
			dw_head.setitem(1, "proc_no", ls_proc_no)
			cb_proc.enabled = true
			dw_body.Retrieve(is_proc_type, is_yymmdd,  ls_proc_no, is_house_cd, "1", is_brand)
		else
			rollback  USING SQLCA;
		end if


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_41013_e","0")
end event

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN 

if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox("입력","브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
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

event ue_button(integer ai_cb_div, long al_rows);
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows >= 0 then
         cb_print.enabled   = true
         cb_preview.enabled = true
         cb_insert.enabled  = false
         cb_delete.enabled  = false
         cb_update.enabled  = false
         cb_input.Text      = "등록(&I)"
         cb_retrieve.Text   = "조건(&I)"			
         dw_head.enabled    = false 
         dw_body.enabled    = false
         ib_changed         = false
      end if
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled  = true
			cb_print.enabled   = false
			cb_preview.enabled = false
			cb_excel.enabled   = false
		end if
		if dw_head.Enabled then
		   cb_retrieve.Text = "조건(&I)"
			dw_head.Enabled = false
		end if
	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed         = false
			cb_print.enabled   = true
			cb_preview.enabled = true
			cb_proc.enabled = true			
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
      cb_input.Text = "등록(&I)"
	   cb_retrieve.Text = "조회(&Q)"
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
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
         dw_head.Enabled    = false
         dw_body.Enabled    = true
         dw_body.SetFocus()
         ib_changed = false
         cb_update.enabled = false
         cb_retrieve.Text = "조건(&I)"
      else
         cb_insert.enabled  = false
         cb_delete.enabled  = false
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
      end if

END CHOOSE

end event

event pfc_dberror();// 
end event

type cb_close from w_com010_e`cb_close within w_41013_e
integer taborder = 130
end type

type cb_delete from w_com010_e`cb_delete within w_41013_e
integer taborder = 70
end type

type cb_insert from w_com010_e`cb_insert within w_41013_e
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_41013_e
end type

type cb_update from w_com010_e`cb_update within w_41013_e
integer taborder = 120
end type

type cb_print from w_com010_e`cb_print within w_41013_e
boolean visible = false
integer taborder = 90
end type

type cb_preview from w_com010_e`cb_preview within w_41013_e
boolean visible = false
integer taborder = 100
end type

type gb_button from w_com010_e`gb_button within w_41013_e
end type

type cb_excel from w_com010_e`cb_excel within w_41013_e
boolean visible = false
integer taborder = 110
end type

type dw_head from w_com010_e`dw_head within w_41013_e
integer y = 160
integer width = 3406
integer height = 360
string dataobject = "d_41013_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("house_cd", idw_house_cd )
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if
end event

type ln_1 from w_com010_e`ln_1 within w_41013_e
integer beginy = 544
integer endy = 544
end type

type ln_2 from w_com010_e`ln_2 within w_41013_e
integer beginy = 548
integer endy = 548
end type

type dw_body from w_com010_e`dw_body within w_41013_e
event ue_set_column ( long al_row )
integer x = 14
integer y = 564
integer width = 3579
integer height = 1428
string dataobject = "d_41013_D01"
boolean controlmenu = true
boolean hscrollbar = true
end type

event dw_body::ue_set_column(long al_row);/* 품번 키보드 및 스캐너 입력시 다음 line으로 이동 */
string ls_style_no, ls_style_no_b
integer li_qty
ls_style_no = dw_body.getitemstring(al_row, "style_no")
ls_style_no_b = dw_body.getitemstring(al_row -1 , "style_no")

if ls_style_no = ls_style_no_b then
	li_qty = dw_body.getitemNumber(al_row -1 , "qty")
	dw_body.setitem(al_row -1, "qty", li_qty + 1)
	dw_body.deleteRow(al_row)  
	dw_body.SetRow(al_row)  
	dw_body.SetColumn("style_no")
else
	
	dw_body.SetRow(al_row + 1)  
	dw_body.SetColumn("style_no")
end if
end event

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify
DataWindowChild ldw_shop_type

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

  This.GetChild("shop_type", ldw_shop_type )
  ldw_shop_type.SetTransObject(SQLCA)
  ldw_shop_type.retrieve('911')

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
		IF li_ret <> 1 THEN
			This.Post Event ue_set_column(row) 
		END IF		  
		return li_ret
	CASE "qty"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1

END CHOOSE

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;//string DWfilter, ls_style, ls_chno, ls_color,ls_year,ls_season, ls_item, ls_sojae, ls_type,ls_style_chk, ls_size
//long     i, j, ll_row_count, ll_row, li_ret
//decimal ldc_tag_price
//
//ls_style = dw_body.getitemstring(row, "style")
//ls_chno = dw_body.getitemstring(row, "chno")
//ls_color = dw_body.getitemstring(row, "color")
//ls_size = dw_body.getitemstring(row, "size")
//
//
//CHOOSE CASE dwo.name
//
//	
//	case "chno"	
//		ls_style = dw_body.getitemstring(row, "style")		
//		gf_first_price(ls_style, ldc_tag_price)		
//		dw_body.Setitem(row, "price", ldc_tag_price)
//   	dw_body.Setitem(row, "amt", ldc_tag_price * dw_body.getitemdecimal(row, "qty"))
//		
//	CASE "color" 
//		ls_style = dw_body.getitemstring(row, "style")
//		ls_chno  = dw_body.getitemstring(row, "chno")	
//		
//		il_rows = dw_color.retrieve(ls_style, ls_chno)
//		
//			if il_rows > 0 then
//				FOR i=1 TO il_rows
//					  if i = il_rows then
//						  ls_Type = ls_Type + "color = " +  "'" +  dw_color.getitemstring(i, "color") + "'"
//					else
//						  ls_Type = ls_Type + "color = " +  "'" +  dw_color.getitemstring(i, "color") + "'" + " or "
//					end if	  
//				next	
//					 DWfilter = ls_Type
//			END IF
//			  idw_color.SetFilter(DWfilter)
//			  idw_color.Filter()
//		  
//CASE "size"
//	 
//		ls_style = dw_body.getitemstring(row, "style")
//		ls_chno  = dw_body.getitemstring(row, "chno")	
//		ls_color = dw_body.getitemstring(row, "color")	
//		
//		il_rows = dw_size.retrieve(ls_style, ls_chno, ls_color)
//		
//			if il_rows > 0 then
//				FOR i=1 TO il_rows
//					  if i = il_rows then
//						  ls_Type = ls_Type + "size = " +  "'" +  dw_size.getitemstring(i, "size") + "'"
//					else
//						  ls_Type = ls_Type + "size = " +  "'" +  dw_size.getitemstring(i, "size") + "'" + " or "
//					end if	  
//				next	
//							
//				 DWfilter = ls_Type
//				
//		  END IF
//		  
//		  idw_size.SetFilter(DWfilter)
//		  idw_size.Filter()
//	
//
//
//END CHOOSE


end event

event dw_body::dberror;//
end event

event dw_body::getfocus;call super::getfocus;String ls_column_nm,  ls_tag

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)
end event

event dw_body::ue_keydown;call super::ue_keydown;
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

type dw_print from w_com010_e`dw_print within w_41013_e
integer x = 2510
integer y = 1464
string dataobject = "d_43024_r01"
end type

type dw_color from datawindow within w_41013_e
boolean visible = false
integer x = 2738
integer y = 928
integer width = 411
integer height = 432
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_43015_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_size from datawindow within w_41013_e
boolean visible = false
integer x = 3141
integer y = 944
integer width = 411
integer height = 432
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_43015_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_view from datawindow within w_41013_e
boolean visible = false
integer x = 9
integer y = 392
integer width = 3602
integer height = 1624
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "실사내역조회"
string dataobject = "d_41013_D02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;String ls_proc_no, ls_shop_cd, ls_shop_type, ls_tran_cust, ls_box_size , ls_style, ls_chno, ls_color, ls_size
sTRING ls_rot_yn, ls_box_no, ls_proc_yn, ls_out_reg

IF row < 0 THEN RETURN 

ls_proc_no    = This.GetitemString(row, "proc_no")
ls_shop_cd    = This.GetitemString(row, "shop_cd")
ls_shop_type    = This.GetitemString(row, "shop_type")
ls_proc_yn    = This.GetitemString(row, "proc_yn")
ls_out_reg	  = This.GetitemString(row, "rot_yn")

IF dw_body.Retrieve(is_proc_type, is_yymmdd,  ls_proc_no, ls_shop_cd, ls_shop_type, is_brand) > 0 THEN 
	ls_style = dw_body.getitemstring(1,"style")
	ls_chno  = dw_body.getitemstring(1,"chno")
	ls_color = dw_body.getitemstring(1,"color")
	ls_size  = dw_body.getitemstring(1,"size")	
	
	
	
   dw_body.visible = True						  
   dw_view.visible = False 
	cb_insert.Enabled = True
	
	if ls_proc_yn = "Y" then 
		cb_proc.enabled = false
	else 
		cb_proc.enabled = true 
	end if
	
	dw_body.SetFocus()
	dw_head.setitem(1, "proc_no", ls_proc_no)
	dw_head.setitem(1, "house_cd", ls_shoP_cd)	
	dw_head.setitem(1, "out_reg", ls_out_reg)		
	dw_head.setitem(1, "result", "")		
	if wf_style_chk( 1, ls_style + ls_chno + ls_color + ls_size) <> true then 
		messagebox("경고!" ,"품번에 이상이 있습니다!")
	end if	
END IF


end event

event constructor;DataWindowChild ldw_color, ldw_shop_type


end event

type cb_input from commandbutton within w_41013_e
event ue_keydown pbm_keydown
integer x = 2528
integer y = 44
integer width = 347
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "등록(&I)"
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

type dw_shop_cd from datawindow within w_41013_e
boolean visible = false
integer x = 2501
integer y = 492
integer width = 901
integer height = 600
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_com940"
boolean border = false
boolean livescroll = true
end type

type cb_proc from commandbutton within w_41013_e
integer x = 379
integer y = 44
integer width = 347
integer height = 92
integer taborder = 140
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "전송"
end type

event clicked;String ls_row_no, ls_style, ls_chno, ls_color, ls_size,ls_in_no, ls_box_no,ls_o_errc,ls_o_emsg
String ls_row_cnt, ls_pda_no, ls_proc_yn
integer li_qty, i
long ll_row_count
datetime ld_datetime

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN 0

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF
dw_head.setitem(1, "result","")
ls_row_cnt = string(ll_row_count,"0000")

FOR i=1 TO ll_row_count

	dw_body.ScrollToRow(i)
	dw_body.selectrow(i,TRUE)	

	ls_row_no = dw_body.GetItemString(i, "no")
	ls_style = dw_body.GetItemString(i, "style")
	ls_chno  = dw_body.GetItemString(i, "chno")
	ls_color = dw_body.GetItemString(i, "color")	
	ls_size  = dw_body.GetItemString(i, "size")		
	li_qty   = dw_body.GetItemNumber(i, "qty")			
	ls_proc_yn = dw_body.GetItemstring(i, "proc_yn")	
	
	if isnull(ls_proc_yn) or ls_proc_yn = "" then
		ls_proc_yn = "N"
	end if	

	ls_pda_no = "0009"
	if li_qty <> 0 and ls_proc_yn <> "Y" and ls_box_no <> "XXXX" then	

		 DECLARE sp_41013_d04 PROCEDURE FOR sp_41013_d04  
         @proc_type 	= :is_proc_type,   
         @brand 		= :is_brand,   
         @row_cnt 	= :ls_row_cnt,   
         @row_no 		= :ls_row_no,   
         @yymmdd 		= :is_yymmdd,   
			@proc_no	   = :is_proc_no,
         @house_cd 	= :is_house_cd,   
         @style 		= :ls_style,   
         @chno 		= :ls_chno,   
         @color 		= :ls_color,   
         @size 		= :ls_size,   
         @qty 			= :li_qty,   
         @reg_id 		= :gs_user_id,   
         @pda_no 		= :ls_pda_no,   
         @out_region	= :is_out_reg,   			
			@o_in_no    = :ls_in_no out, 
			@o_errc     = :ls_o_errc out,
			@o_emsg     = :ls_o_emsg out;


		 EXECUTE sp_41013_d04 ;
 		 fetch   sp_41013_d04  into :ls_in_no, :ls_o_errc,:ls_o_emsg ;
		 CLOSE   sp_41013_d04 ;
		
			end if		
			
				IF SQLCA.SQLCODE = -1 THEN 
					rollback  USING SQLCA;				
					MessageBox("SQL오류", SQLCA.SqlErrText) 
					Return -1 
				ELSE
					commit  USING SQLCA;
					 il_rows = 1 
				END IF 		
	
	dw_body.selectrow(i,false)	
NEXT


			
dw_head.setitem(1, "result",ls_o_emsg)
CB_proc.ENABLED = FALSE
parent.Trigger Event ue_button(3, il_rows)
parent.Trigger Event ue_msg(3, il_rows)
return il_rows
end event

