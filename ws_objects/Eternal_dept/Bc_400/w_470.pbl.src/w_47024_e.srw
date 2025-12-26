$PBExportHeader$w_47024_e.srw
$PBExportComments$반품처리(파일)
forward
global type w_47024_e from w_com010_e
end type
type st_1 from statictext within w_47024_e
end type
type dw_1 from datawindow within w_47024_e
end type
end forward

global type w_47024_e from w_com010_e
integer width = 3675
integer height = 2280
st_1 st_1
dw_1 dw_1
end type
global w_47024_e w_47024_e

type variables
datawindowchild idw_proc_stat, idw_color, idw_rtrn_stat,idw_rtrn_reason_detail_b,idw_rtrn_reason_detail_h
String is_order_ymd, is_shop_cd, is_order_no, is_order_name, is_order_mobile, is_proc_stat, is_fr_ymd, is_to_ymd, is_rtrn_stat
String is_sale_ymd, is_work_ymd, is_rtrn_reason, is_rtrn_reason_detail, is_gubn, is_fr_rtrn_sale, is_to_rtrn_sale
end variables

on w_47024_e.create
int iCurrent
call super::create
this.st_1=create st_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_1
end on

on w_47024_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_1)
end on

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

is_sale_ymd = dw_head.GetItemString(1, "sale_ymd")
if IsNull(is_sale_ymd) or Trim(is_sale_ymd) = "" then
   MessageBox(ls_title,"판매일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_ymd")
   return false
end if


is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"주문일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"주문일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


is_shop_cd = dw_head.GetItemString(1, "shoP_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
 is_shop_cd = "%"
end if

is_order_no = dw_head.GetItemString(1, "order_no")
if IsNull(is_order_no) or Trim(is_order_no) = "" then
 is_order_no = "%"
end if

is_order_name = dw_head.GetItemString(1, "order_name")
if IsNull(is_order_no) or Trim(is_order_no) = "" then
 is_order_no = "%"
end if

is_order_mobile = dw_head.GetItemString(1, "order_mobile")
if IsNull(is_order_mobile) or Trim(is_order_mobile) = "" then
 is_order_mobile = "%"
end if


is_work_ymd = dw_head.GetItemString(1, "work_ymd")
if IsNull(is_work_ymd) or Trim(is_work_ymd) = "" then
 is_work_ymd = "%"
end if

is_proc_stat = dw_head.GetItemString(1, "proc_stat")
if IsNull(is_proc_stat) or Trim(is_proc_stat) = "" then
   MessageBox(ls_title,"주문처리내역을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("proc_stat")
   return false
end if

is_rtrn_stat = dw_head.GetItemString(1, "rtrn_stat")
if IsNull(is_rtrn_stat) or Trim(is_rtrn_stat) = "" then
   MessageBox(ls_title,"주문처리내역을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rtrn_stat")
   return false
end if

is_rtrn_reason = dw_head.GetItemString(1, "rtrn_reason")
if IsNull(is_rtrn_reason) or Trim(is_rtrn_reason) = "" then
   MessageBox(ls_title,"반품사유를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rtrn_reason")
   return false
end if

is_rtrn_reason_detail = dw_head.GetItemString(1, "rtrn_reason_detail")
if IsNull(is_rtrn_reason_detail) or Trim(is_rtrn_reason_detail) = "" then
   MessageBox(ls_title,"반품상세사유를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rtrn_reason_detail")
   return false
end if

is_fr_rtrn_sale = dw_head.GetItemString(1, "fr_rtrn_sale")
if IsNull(is_fr_rtrn_sale) or Trim(is_fr_rtrn_sale) = "" then
 is_fr_rtrn_sale = "00000000"
end if

is_to_rtrn_sale = dw_head.GetItemString(1, "to_rtrn_sale")
if IsNull(is_to_rtrn_sale) or Trim(is_to_rtrn_sale) = "" then
 is_to_rtrn_sale = "99999999"
end if

is_gubn = dw_head.GetItemString(1, "gubn") 

return true
end event

event ue_retrieve();call super::ue_retrieve;long ll_row


/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

ll_row = dw_1.retrieve(is_fr_ymd, is_to_ymd)


if ll_row >= 1 then
	dw_1.visible = true
else 	
	dw_1.visible = false 
end if	

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_shop_cd, is_order_no, is_order_name, is_order_mobile, is_rtrn_stat, is_work_ymd, is_rtrn_reason, is_rtrn_reason_detail, is_gubn, is_fr_rtrn_sale, is_to_rtrn_sale)
IF il_rows > 0 THEN
   dw_body.SetFocus()

END IF

This.Trigger Event ue_button(1, il_rows)

IF il_rows > 0 THEN
	ib_changed = true
	cb_update.enabled = true
END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count
datetime ld_datetime
string ls_yymmdd, ls_ord_ymd, ls_shop_cd, ls_style, ls_chno, ls_color, ls_size, ls_brand, ls_rtrn_no, ls_r_no
string  ls_sale_ymd, ls_sale_yn, ls_proc_stat, ls_ok, ls_rtrn_sale_ymd, ls_rtrn_stat, ls_work_ymd,ls_work_ymd1
string  ls_r_shop_type, ls_db_rtn, ls_rtrn_invoice_no_s, ls_rtrn_invoice_no,ls_chk_corp, ls_db_no
decimal  ldc_sale_price,ldc_mall_price
integer li_sale_qty

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

if is_work_ymd = "%" then
	ls_work_ymd = string(ld_datetime,"yyyymmdd")
else
	ls_work_ymd = is_work_ymd
end if	

FOR i=1 TO ll_row_count

	dw_body.ScrollToRow(i)
	dw_body.selectrow(i,TRUE)	
	
	ls_yymmdd = dw_body.GetItemString(i, "yymmdd")
	ls_ord_ymd = dw_body.GetItemString(i, "ord_ymd")	
	ls_sale_yn = dw_body.GetItemString(i, "sale_yn")		
	ls_proc_stat = dw_body.GetItemString(i, "proc_stat")			
	ls_rtrn_stat = dw_body.GetItemString(i, "rtrn_stat")				
	ls_shop_cd = dw_body.GetItemString(i, "shoP_cd")	
	ls_style = dw_body.GetItemString(i, "style")
	ls_chno  = dw_body.GetItemString(i, "chno")
	ls_color = dw_body.GetItemString(i, "color")	
	ls_size  = dw_body.GetItemString(i, "size")		
	li_sale_qty   = -1 * dw_body.GetItemNumber(i, "qty")		
	ls_brand = MidA(ls_style, 1,1)
	ls_work_ymd1 = dw_body.GetItemString(i, "rtrn_work_ymd")
	ls_db_rtn = dw_body.GetItemString(i, "db_rtn")
	ls_rtrn_invoice_no_s = dw_body.GetItemString(i, "rtrn_invoice_no_1")
	ls_rtrn_invoice_no = dw_body.GetItemString(i, "rtrn_invoice_no")	
	ldc_mall_price   = dw_body.GetItemNumber(i, "sale_price")			
	ls_db_no = dw_body.GetItemString(i, "db")	
	if IsNull(ls_rtrn_invoice_no) or Trim(ls_rtrn_invoice_no) = "" then
		ls_rtrn_invoice_no = "X"
	end if	
	
	if IsNull(ls_rtrn_invoice_no_s) or Trim(ls_rtrn_invoice_no_s) = "" then
		ls_rtrn_invoice_no_s = "X"
	end if		
	
	if isnull(ls_sale_yn) or ls_sale_yn = "" then
		ls_sale_yn = "N"
	end if	
	
	select case when right(rtrim(ltrim(inter_cd1)),1) in ('2' ,'B') then 'O' else 'B' end
	into :ls_chk_corp
	from TB_91011_C
	where inter_grp = '001'
	and inter_cd = :ls_brand ;	
	
	if li_sale_qty <> 0 and ls_sale_yn = "Y" and ls_proc_stat =  "02" and ls_rtrn_stat = "01" then	
			
//			if ls_chk_corp = "O" then 
//			
//				 DECLARE sp_47003_p01 PROCEDURE FOR sp_47003_p01  
//						@yymmdd		=  :is_sale_ymd,
//						@ordymd		=  :ls_ord_ymd,
//						@shop_cd		=  :ls_shop_cd,
//						@style		=  :ls_style,
//						@chno			=  :ls_chno,
//						@color		=	:ls_color,
//						@size			=  :ls_size,
//						@sale_qty	=  :li_sale_qty,
//						@brand		=  :ls_brand,
//						@reg_id		= 	:gs_user_id,
//						@O_sale_ymd	=  :ls_sale_ymd OUT,
//						@O_sale_price = :ldc_sale_price OUT,
//						@O_sale_no	=	:ls_rtrn_no OUT,
//						@O_no			=  :ls_r_no OUT,			
//						@o_ok         = :ls_ok	out,			
//						@o_shop_type  = :ls_r_shop_type	out;	
//			
//					 EXECUTE sp_47003_p01 ;
//					 fetch   sp_47003_p01  into :ls_sale_ymd, :ldc_sale_price, :ls_rtrn_no, :ls_r_no, :ls_ok, :ls_r_shop_type;
//					 CLOSE   sp_47003_p01 ;
//					
//		else					
							
				 DECLARE sp_47003_p03 PROCEDURE FOR sp_47003_p03  
							@yymmdd		=  :is_sale_ymd,
							@ordymd		=  :ls_ord_ymd,
							@shop_cd		=  :ls_shop_cd,
							@style		=  :ls_style,
							@chno			=  :ls_chno,
							@color		=	:ls_color,
							@size			=  :ls_size,
							@sale_qty	=  :li_sale_qty,
							@e_sale_price	=  :ldc_mall_price,					
							@brand		=  :ls_brand,
							@reg_id		= 	:gs_user_id,
							@db_no		=	:ls_db_no,	
							@O_sale_ymd	=  :ls_sale_ymd OUT,
							@O_sale_price = :ldc_sale_price OUT,
							@O_sale_no	=	:ls_rtrn_no OUT,
							@O_no			=  :ls_r_no OUT,			
							@o_ok         = :ls_ok	out,			
							@o_shop_type  = :ls_r_shop_type	out;						
							
							
						 EXECUTE sp_47003_p03 ;
						 fetch   sp_47003_p03  into :ls_sale_ymd, :ldc_sale_price, :ls_rtrn_no, :ls_r_no, :ls_ok, :ls_r_shop_type;
						 CLOSE   sp_47003_p03 ;
						 
//		end if						 							
		
							IF SQLCA.SQLCODE = -1 or ls_ok ="No" THEN 
								rollback  USING SQLCA;				
								MessageBox("SQL오류", SQLCA.SqlErrText) 
								Return -1 
							ELSE
								commit  USING SQLCA;
								dw_body.setitem(i, "proc_stat", "02")
								dw_body.setitem(i, "rtrn_stat", "02")					
								dw_body.setitem(i, "rtrn_sale_price", ldc_sale_price)					
								dw_body.setitem(i, "rtrn_sale_ymd", ls_sale_ymd)										
								dw_body.setitem(i, "rtrn_no", ls_rtrn_no)															
								dw_body.setitem(i, "r_no", ls_r_no)																				
								dw_body.setitem(i, "r_shop_type", ls_r_shop_type)	
								
								if ls_rtrn_invoice_no <> ls_rtrn_invoice_no_s  and ls_rtrn_invoice_no_s <> "X" then //and ls_rtrn_invoice_no <> "X"   then
									dw_body.setitem(i, "rtrn_invoice_no", ls_rtrn_invoice_no_s)							
								end if
								
								if isnull(ls_work_ymd1 ) or LenA(ls_work_ymd1) <> 8 then
									dw_body.Setitem(i, "rtrn_work_ymd", ls_work_ymd)
								end if	
								
								
								dw_body.Setitem(i, "db_origin", ls_db_rtn)	// 반품파일 DB번호	
								dw_body.Setitem(i, "mod_id", gs_user_id)
								dw_body.Setitem(i, "mod_dt", ld_datetime)
							 il_rows = 1 
							END IF 		
				
				
		else		
			  idw_status = dw_body.GetItemStatus(i, 0, Primary!)
				IF idw_status = NewModified! THEN				/* New Record */			
					dw_body.Setitem(i, "rtrn_work_ymd", ls_work_ymd)
					dw_body.Setitem(i, "reg_id", gs_user_id)
					dw_body.Setitem(i, "db_origin", ls_db_rtn)	
					if ls_rtrn_invoice_no <> ls_rtrn_invoice_no_s and ls_rtrn_invoice_no_s <> "X"  then //and ls_rtrn_invoice_no <> "X"   then
						dw_body.setitem(i, "rtrn_invoice_no", ls_rtrn_invoice_no_s)							
					end if				
					
				ELSEIF idw_status = DataModified! THEN		/* Modify Record */
					
					if isnull(ls_work_ymd1 ) or LenA(ls_work_ymd1) <> 8 then
						dw_body.Setitem(i, "rtrn_work_ymd", ls_work_ymd)
					end if	
					dw_body.Setitem(i, "mod_id", gs_user_id)
					dw_body.Setitem(i, "mod_dt", ld_datetime)
					dw_body.Setitem(i, "db_origin", ls_db_rtn)
					
					if ls_rtrn_invoice_no <> ls_rtrn_invoice_no_s and ls_rtrn_invoice_no_s <> "X" then // and ls_rtrn_invoice_no <> "X"   then
						dw_body.setitem(i, "rtrn_invoice_no", ls_rtrn_invoice_no_s)							
					end if
					
				else 	
					
					dw_body.SetItemStatus(i, 0, Primary!, DataModified!)
					
					if isnull(ls_work_ymd1 ) or LenA(ls_work_ymd1) <> 8 then
						dw_body.Setitem(i, "rtrn_work_ymd", ls_work_ymd)
					end if	
					dw_body.Setitem(i, "mod_id", gs_user_id)
					dw_body.Setitem(i, "mod_dt", ld_datetime)
					dw_body.Setitem(i, "db_origin", ls_db_rtn)
					
					if ls_rtrn_invoice_no <> ls_rtrn_invoice_no_s and ls_rtrn_invoice_no_s <> "X" then // and ls_rtrn_invoice_no <> "X"   then
						dw_body.setitem(i, "rtrn_invoice_no", ls_rtrn_invoice_no_s)							
					end if					
					
				END IF						
			
		end if		
		
		
	dw_body.selectrow(i,false)	
NEXT


il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_47004_e","0")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm 
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
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
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

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "sale_ymd" ,string(ld_datetime,"yyyymmdd"))
//dw_head.SetItem(1, "fr_rtrn_sale" ,string(ld_datetime,"yyyymmdd"))
//dw_head.SetItem(1, "to_rtrn_sale" ,string(ld_datetime,"yyyymmdd"))
end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

type cb_close from w_com010_e`cb_close within w_47024_e
end type

type cb_delete from w_com010_e`cb_delete within w_47024_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_47024_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_47024_e
end type

type cb_update from w_com010_e`cb_update within w_47024_e
integer width = 521
string text = "반품처리/저장(&S)"
end type

type cb_print from w_com010_e`cb_print within w_47024_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_47024_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_47024_e
end type

type cb_excel from w_com010_e`cb_excel within w_47024_e
integer x = 2386
end type

type dw_head from w_com010_e`dw_head within w_47024_e
integer y = 156
integer height = 380
string dataobject = "d_47024_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowchild ldw_rtrn_reason

This.GetChild("proc_stat", idw_proc_stat)
idw_proc_stat.SetTransObject(SQLCA)
idw_proc_stat.Retrieve('043')
idw_proc_stat.InsertRow(1)
idw_proc_stat.SetItem(1, "inter_cd", '%')
idw_proc_stat.SetItem(1, "inter_nm", '전체')

This.GetChild("rtrn_stat", idw_rtrn_stat)
idw_rtrn_stat.SetTransObject(SQLCA)
idw_rtrn_stat.Retrieve('044')
idw_rtrn_stat.InsertRow(1)
idw_rtrn_stat.SetItem(1, "inter_cd", '%')
idw_rtrn_stat.SetItem(1, "inter_nm", '전체')

This.GetChild("rtrn_reason", ldw_rtrn_reason)
ldw_rtrn_reason.SetTransObject(SQLCA)
ldw_rtrn_reason.Retrieve('045')
ldw_rtrn_reason.InsertRow(1)
ldw_rtrn_reason.SetItem(1, "inter_cd", '%')
ldw_rtrn_reason.SetItem(1, "inter_nm", '전체')

This.GetChild("rtrn_reason_detail", idw_rtrn_reason_detail_h)
idw_rtrn_reason_detail_h.SetTransObject(SQLCA)
//idw_rtrn_reason_detail_h.InsertRow(0)
idw_rtrn_reason_detail_h.InsertRow(1)
idw_rtrn_reason_detail_h.SetItem(1, "inter_cd", '%')
idw_rtrn_reason_detail_h.SetItem(1, "inter_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;int li_ret
string ls_brand, ls_year, ls_season

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if LenA(data) > 1 then 
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		else 
			dw_head.setitem(1, "shop_nm","")
		end if
			
END CHOOSE
//
end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;String ls_rtrn_reason

CHOOSE CASE dwo.name
	
	CASE "rtrn_reason_detail"
		ls_rtrn_reason = This.GetItemString(row, "rtrn_reason")

		idw_rtrn_reason_detail_h.Retrieve('046', ls_rtrn_reason)
		idw_rtrn_reason_detail_h.InsertRow(1)
		idw_rtrn_reason_detail_h.SetItem(1, "inter_cd", '%')
		idw_rtrn_reason_detail_h.SetItem(1, "inter_nm", '전체')
		
END CHOOSE
end event

type ln_1 from w_com010_e`ln_1 within w_47024_e
integer beginy = 540
integer endy = 540
end type

type ln_2 from w_com010_e`ln_2 within w_47024_e
integer beginy = 544
integer endy = 544
end type

type dw_body from w_com010_e`dw_body within w_47024_e
integer y = 568
integer height = 1472
string dataobject = "d_47024_D01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::buttonclicked;call super::buttonclicked;Long i
String ls_yn, ls_proc_stat, ls_rtrn_stat

If dwo.Name = 'cb_sale_yn' Then
	If dwo.Text = '대상선택' Then
		ls_yn = 'Y'
		dwo.Text = '대상제외'
	Else
		ls_yn = 'N'
		dwo.Text = '대상선택'
	End If
	
	For i = 1 To This.RowCount()
		ls_proc_stat = dw_body.getitemstring(i, "proc_stat")
		ls_rtrn_stat = dw_body.getitemstring(i, "rtrn_stat")		
		if ls_proc_stat = "02" and ls_rtrn_stat = "01" then 
			This.SetItem(i, "sale_yn", ls_yn)
		end if
	Next

End If

end event

event dw_body::constructor;call super::constructor;datawindowchild ldw_proc_stat, ldw_rtrn_stat, ldw_rtrn_reason,ldw_rtrn_reason_detail

This.GetChild("proc_stat", ldw_proc_stat)
ldw_proc_stat.SetTransObject(SQLCA)
ldw_proc_stat.Retrieve('043')

This.GetChild("rtrn_stat", ldw_rtrn_stat)
ldw_rtrn_stat.SetTransObject(SQLCA)
ldw_rtrn_stat.Retrieve('044')

This.GetChild("rtrn_reason", ldw_rtrn_reason)
ldw_rtrn_reason.SetTransObject(SQLCA)
ldw_rtrn_reason.Retrieve('045')

This.GetChild("rtrn_reason_detail", idw_rtrn_reason_detail_b)
idw_rtrn_reason_detail_b.SetTransObject(SQLCA)
idw_rtrn_reason_detail_b.Retrieve('046', '%')
idw_rtrn_reason_detail_b.InsertRow(0)

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.retrieve('%')


end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;String ls_rtrn_reason

CHOOSE CASE dwo.name
	
	CASE "rtrn_reason_detail"
		ls_rtrn_reason = This.GetItemString(row, "rtrn_reason")

		idw_rtrn_reason_detail_b.Retrieve('046', ls_rtrn_reason)
		idw_rtrn_reason_detail_b.InsertRow(1)
		idw_rtrn_reason_detail_b.SetItem(1, "inter_cd", '')
		idw_rtrn_reason_detail_b.SetItem(1, "inter_nm", '')		

		
		
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_47024_e
end type

type st_1 from statictext within w_47024_e
integer x = 553
integer y = 64
integer width = 1815
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
string text = "※파일등록 구분을 반품으로 업로드 한 대상만 조회 처리됩니다!"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_47024_e
boolean visible = false
integer x = 1797
integer y = 1268
integer width = 1792
integer height = 764
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "처리 오류 반품건"
string dataobject = "d_47024_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

