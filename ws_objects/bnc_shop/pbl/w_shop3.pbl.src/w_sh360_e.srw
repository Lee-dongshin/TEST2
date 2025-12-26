$PBExportHeader$w_sh360_e.srw
$PBExportComments$부진모델 이동처리
forward
global type w_sh360_e from w_com010_e
end type
end forward

global type w_sh360_e from w_com010_e
integer width = 2976
integer height = 2092
end type
global w_sh360_e w_sh360_e

type variables
DataWindowChild idw_dep_seq
String  is_year,    is_season,       is_dep_seq, is_proc_opt
String is_yymmdd, is_fr_shop_type, is_to_shop_type  , is_to_shop_cd
end variables

on w_sh360_e.create
call super::create
end on

on w_sh360_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;string ls_shop_nm

dw_head.Setitem(1, "fr_shop_type", '1')
dw_head.Setitem(1, "to_shop_type", '4')
dw_head.Setitem(1, "shop_cd", gs_shop_cd)
dw_head.Setitem(1, "shop_nm", ls_shop_nm)

dw_head.Setitem(1, "to_shop_cd", gs_shop_cd)
dw_head.Setitem(1, "to_shop_nm", ls_shop_nm)

if gf_shop_nm(gs_shop_cd, 'S', ls_shop_nm) = 0 THEN
	dw_head.Setitem(1, "shop_nm", ls_shop_nm)	
	dw_head.Setitem(1, "to_shop_nm", ls_shop_nm)
END IF 

end event

event ue_button(integer ai_cb_div, long al_rows);

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      end if

      if al_rows > 0 then
         ib_changed = true
         cb_update.enabled = true
      end if
		
	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
         cb_update.enabled = false
			cb_print.enabled = true
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "산출(&Q)"
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.09                                                  */	
/* 수정일      : 2002.04.01                                                  */
/*===========================================================================*/
String   ls_title
int net

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

is_dep_seq = dw_head.GetItemString(1, "dep_seq")
if IsNull(is_dep_seq) or Trim(is_dep_seq) = "" then
   MessageBox(ls_title,"부진 차수를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dep_seq")
   return false
end if

is_yymmdd = String(dw_head.GetitemDate(1, "yymmdd"), "yyyymmdd")


is_fr_shop_type = dw_head.GetItemString(1, "fr_shop_type")
if IsNull(is_fr_shop_type) or Trim(is_fr_shop_type) = "" then
   MessageBox(ls_title,"매장 형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_shop_type")
   return false
end if


is_to_shop_cd = dw_head.GetItemString(1, "to_shop_cd")
if IsNull(is_to_shop_cd) or Trim(is_to_shop_cd) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_shop_cd")
   return false
end if

is_to_shop_type = dw_head.GetItemString(1, "to_shop_type")
if IsNull(is_to_shop_type) or Trim(is_to_shop_type) = "" then
   MessageBox(ls_title,"매장 형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_shop_type")
   return false
end if

is_proc_opt = "N"

if is_to_shop_cd <> gs_shop_cd then 
	Net = MessageBox("주의!", "상대매장으로 점간이송 처리됩니다. 실행하시겠습니까?", Exclamation!, OKCancel!, 2)

	IF Net <> 1 THEN
		messagebox("알림!", "취소되었습니다!")
		return false	
	else
		is_proc_opt = "M"
	END IF
end if

Return true
end event

event type long ue_update();call super::ue_update;
long     i, ll_row_count
datetime ld_datetime
String   ls_out_no, ls_no, ls_style, ls_chno, ls_color, ls_size  
String   ls_fr_sale_type,  ls_to_sale_type,   ls_ErrMsg
long     ll_qty
Decimal  ldc_fr_disc_rate, ldc_fr_margin_rate, ldc_fr_curr_price, ldc_fr_out_price
Decimal  ldc_to_disc_rate, ldc_to_margin_rate, ldc_to_curr_price, ldc_to_out_price

IF dw_body.AcceptText() <> 1 THEN RETURN -1
ll_row_count = dw_body.RowCount()


IF MessageBox("주의!", "재고 이동처리를 진행하시겠습니까?" ,Exclamation!, OKCancel!, 2) <> 1 THEN
      return -1
END IF

// 출고 전표 채번 
IF Gf_Style_Outno(is_yymmdd, gs_brand, ls_out_no) = FALSE THEN 
	Return -1 
else 
	dw_head.setitem(1, "out_no", ls_out_no)
END IF

il_rows    = 1 
FOR i=1 TO ll_row_count
	
//is_proc_opt
	 ls_no              = String(i, "0000") 
	 ls_style           = dw_body.GetitemString(i, "style")
	 ls_chno            = dw_body.GetitemString(i, "chno") 
	 ls_color           = dw_body.GetitemString(i, "color") 
	 ls_size            = "XX" //dw_body.GetitemString(i, "size")
    ls_fr_sale_type    = dw_body.GetitemString(i, "fr_sale_type")  
	 ls_to_sale_type    = dw_body.GetitemString(i, "to_sale_type")  
    ll_qty             = dw_body.GetitemNumber(i, "qty1")    
    ldc_fr_disc_rate   = dw_body.GetitemDecimal(i, "fr_disc_rate")    
	 ldc_fr_margin_rate = dw_body.GetitemDecimal(i, "fr_margin_rate")     
	 ldc_fr_curr_price  = dw_body.GetitemDecimal(i, "fr_curr_price")      
	 ldc_fr_out_price   = dw_body.GetitemDecimal(i, "fr_out_price")      
    ldc_to_disc_rate   = dw_body.GetitemDecimal(i, "to_disc_rate")     
	 ldc_to_margin_rate = dw_body.GetitemDecimal(i, "to_margin_rate")      
	 ldc_to_curr_price  = dw_body.GetitemDecimal(i, "to_curr_price")       
	 ldc_to_out_price   = dw_body.GetitemDecimal(i, "to_out_price")      

	 if ll_qty <> 0 then
	 
		 DECLARE SP_SH360_P PROCEDURE FOR SP_SH360_P
					  @yymmdd         = :is_yymmdd,   
					  @fr_shop_cd     = :gs_shop_cd, 
					  @fr_shop_type   = :is_fr_shop_type, 
					  @to_shop_cd     = :is_to_shop_cd, 				  
					  @to_shop_type   = :is_to_shop_type, 
					  @out_no         = :ls_out_no, 
					  @no             = :ls_no, 
					  @style          = :ls_style,
					  @chno           = :ls_chno,
					  @color          = :ls_color, 
					  @size           = :ls_size, 
					  @qty            = :ll_qty, 
					  @fr_sale_type   = :ls_fr_sale_type, 
					  @fr_disc_rate   = :ldc_fr_disc_rate, 
					  @fr_margin_rate = :ldc_fr_margin_rate,
					  @fr_curr_price  = :ldc_fr_curr_price, 
					  @fr_out_price   = :ldc_fr_out_price, 
					  @to_sale_type   = :ls_to_sale_type, 
					  @to_disc_rate   = :ldc_to_disc_rate, 
					  @to_margin_rate = :ldc_to_margin_rate,
					  @to_curr_price  = :ldc_to_curr_price, 
					  @to_out_price   = :ldc_to_out_price,  
					  @user_id        = :gs_user_id,
					  @proc_opt			= :is_proc_opt	;  
	
			EXECUTE SP_SH360_P;
			
			if SQLCA.SQLCODE < 0  then
				ls_ErrMsg  = SQLCA.SQLErrText 
				il_rows    = -1 
				exit 
			end if 
	
		end if
		
NEXT

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
	MessageBox("저장오류", ls_ErrMsg)
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_retrieve();call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_head.setitem(1,"out_no", "")

il_rows = dw_body.retrieve(is_yymmdd, gs_shop_cd, is_fr_shop_type, gs_shop_cd, is_to_shop_type, &
                           gs_brand,  is_year   , is_season      , is_dep_seq)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSE
	MessageBox("확인","이동처리할 내역이 없습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm
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
			gst_cd.default_where   = "WHERE brand = '" + gs_brand + "'" + &
			                         "  AND Shop_Stat = '00' "
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
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("fr_shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
			
	CASE "to_shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "to_shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + gs_brand + "'" + &
			                         "  AND Shop_Stat = '00' "
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
				dw_head.SetItem(al_row, "to_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "to_shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("to_shop_type")
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

type cb_close from w_com010_e`cb_close within w_sh360_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh360_e
end type

type cb_insert from w_com010_e`cb_insert within w_sh360_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh360_e
string text = "산출(&Q)"
end type

type cb_update from w_com010_e`cb_update within w_sh360_e
end type

type cb_print from w_com010_e`cb_print within w_sh360_e
end type

type cb_preview from w_com010_e`cb_preview within w_sh360_e
end type

type gb_button from w_com010_e`gb_button within w_sh360_e
end type

type dw_head from w_com010_e`dw_head within w_sh360_e
integer y = 156
integer height = 212
string dataobject = "d_sh360_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("003") 

This.GetChild("dep_seq", idw_dep_seq)
idw_dep_seq.SetTransObject(SQLCA)

This.GetChild("fr_shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("to_shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

end event

event dw_head::itemchanged;call super::itemchanged;String ls_null, ls_yymmdd
SetNull(ls_null)

CHOOSE CASE dwo.name
	
	CASE "year", "season"
		This.Setitem(1, "dep_seq", ls_null)
	CASE "shop_cd","to_shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	
END CHOOSE

end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;String ls_brand, ls_year, ls_season 

CHOOSE CASE dwo.name
	CASE "dep_seq"
		  ls_year    = This.GetitemString(1, "year") 
		  ls_season  = This.GetitemString(1, "season") 
        idw_dep_seq.Retrieve(gs_brand, ls_year, ls_season)
		  
		//  messagebox(gs_brand, ls_year + ls_season )
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_sh360_e
integer beginy = 368
integer endy = 368
end type

type ln_2 from w_com010_e`ln_2 within w_sh360_e
integer beginy = 372
integer endy = 372
end type

type dw_body from w_com010_e`dw_body within w_sh360_e
integer y = 384
integer height = 1456
string dataobject = "d_sh360_d01"
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("fr_sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('011')

This.GetChild("to_sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('011')

end event

event dw_body::itemchanged;call super::itemchanged;long ll_qty
int net

CHOOSE CASE dwo.name
	CASE "qty1" 
	 ll_qty	= dw_body.getitemNumber(row, "qty")
	 if gs_shop_cd <> is_to_shop_cd then

		Net = MessageBox("주의!", "전산재고와 수량 차이가 있습니다. 계속하시겠습니까?", Exclamation!, OKCancel!, 1)

	IF Net <> 1 THEN
		messagebox("알림!", "취소되었습니다!")
		return 1	
	END IF
	
 	 else
		 IF dec(data) > ll_qty  THEN
			messagebox("경고!", "전산재고와 수량 차이가 있습니다!")
			return 1
		 END IF		
	 end if	

END CHOOSE
end event

type dw_print from w_com010_e`dw_print within w_sh360_e
end type

