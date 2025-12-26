$PBExportHeader$w_54014_e.srw
$PBExportComments$완불출고확인
forward
global type w_54014_e from w_com010_e
end type
end forward

global type w_54014_e from w_com010_e
integer width = 3675
integer height = 2280
end type
global w_54014_e w_54014_e

type variables
String is_brand, is_yymmdd, is_fr_ymd, is_to_ymd, is_accept_yn 
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

on w_54014_e.create
call super::create
end on

on w_54014_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.22                                                  */	
/* 수정일      : 2002.03.22                                                  */
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

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

IF DaysAfter(dw_head.GetItemDate(1, "fr_ymd"), dw_head.GetItemDate(1, "to_ymd")) > 7 THEN
   MessageBox(ls_title,"1주일 이상 조회할수 없습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
END IF	
is_fr_ymd = String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
is_to_ymd = String(dw_head.GetItemDate(1, "to_ymd"), "yyyymmdd")
if is_fr_ymd > is_to_ymd then
   MessageBox(ls_title,"종료일이 시작일보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_accept_yn = dw_head.GetItemString(1, "accept_yn")

return true

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.02.22                                                  */	
/* 수정일      : 2002.02.22                                                  */
/*===========================================================================*/
String ls_modify
long i

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_body.SetRedraw(False)
il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_accept_yn)



IF il_rows > 0 THEN 
	
  for i = 1 to il_rows 
	dw_body.setitemstatus( i, "reserve_qty", primary!, Datamodified!)
  next

	ls_modify = "accept_qty.Protect='0~tIf(isnull(out_ymd),0,If(out_ymd = ~~'" + is_yymmdd + "~~',0,1))' " + &
	            "accept_qty.Background.Color='16777215~tIf(isnull(out_ymd),16777215,If(out_ymd = ~~'" + is_yymmdd + "~~',16777215,12639424))' "  + &
	            "accept_yn.Protect='0~tIf(isnull(out_ymd),0,If(out_ymd = ~~'" + is_yymmdd + "~~',0,1))' " + &
	            "accept_yn.Background.Color='16777215~tIf(isnull(out_ymd),16777215,If(out_ymd = ~~'" + is_yymmdd + "~~',16777215,12639424))' " 
	dw_body.Modify(ls_modify)
   dw_body.SetFocus()
END IF
dw_body.SetRedraw(True)

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event open;call super::open;dw_head.Setitem(1, "accept_yn", "N")
end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.02.22                                                  */	
/* 수정일      : 2002.02.22                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime 
String   ls_Err_Msg

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

il_rows = 1 
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime) 
//		IF wf_out_update(i, ld_datetime, ls_Err_Msg) = FALSE THEN 
//         Rollback  USING SQLCA;
//			MessageBox("SQL 오류", ls_Err_Msg)
//         This.Trigger Event ue_msg(3, -1)
//			Return -1
//		END IF 
   END IF
NEXT

IF il_rows = 1 THEN
   il_rows = dw_body.Update() 
END IF

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

Return il_rows

end event

event ue_print();call super::ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long   i 
String ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no

FOR i = 1 TO dw_body.RowCount() 
    IF dw_body.Object.accept_yn[i] = "Y" THEN
       ls_yymmdd    =  dw_body.GetitemString(i, "out_ymd")
	    ls_shop_cd   =  dw_body.GetitemString(i, "shop_cd")
       ls_shop_type =  dw_body.GetitemString(i, "shop_type")
   	 ls_out_no    =  dw_body.GetitemString(i, "out_no")
       dw_print.Retrieve(is_brand, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, '1')
       IF dw_print.RowCount() > 0 Then
          il_rows = dw_print.Print()
       END IF
	END IF
NEXT 

This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54014_e","0")
end event

type cb_close from w_com010_e`cb_close within w_54014_e
end type

type cb_delete from w_com010_e`cb_delete within w_54014_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_54014_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_54014_e
end type

type cb_update from w_com010_e`cb_update within w_54014_e
end type

type cb_print from w_com010_e`cb_print within w_54014_e
end type

type cb_preview from w_com010_e`cb_preview within w_54014_e
boolean visible = false
integer width = 439
string text = "거래명세서(&V)"
end type

type gb_button from w_com010_e`gb_button within w_54014_e
end type

type cb_excel from w_com010_e`cb_excel within w_54014_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_54014_e
integer height = 152
string dataobject = "d_54014_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)                                       */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String ls_yymmdd

CHOOSE CASE dwo.name
	CASE "yymmdd"      
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_54014_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_e`ln_2 within w_54014_e
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_e`dw_body within w_54014_e
integer y = 376
integer height = 1668
string dataobject = "d_54014_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.Getchild("sale_type", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('011')

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.22                                                  */	
/* 수정일      : 2002.03.22                                                  */
/*===========================================================================*/
Long    ll_qty,  ll_out_price, ll_out_collect 
String  ls_null, ls_org_yn 

CHOOSE CASE dwo.name
	CASE "reserve_qty" 
		ll_qty = This.GetitemDecimal(row, "rqst_qty")
//		IF Long(Data) < 1 OR ll_qty < Long(Data) THEN 
//			MessageBox("확인요망", "출고수량을 잘못 입력 하셨습니다.")
//			RETURN 1
//		END IF
      ll_out_price = dw_body.GetitemDecimal(row, "out_price")
      ll_out_collect = ll_out_price * Long(Data)
//      dw_body.Setitem(row, "out_collect", ll_out_collect)
//      dw_body.Setitem(row, "vat", ll_out_collect - Round(ll_out_collect / 1.1, 0))
//	CASE "accept_yn" 
//		IF Data = 'Y' THEN
//			ll_qty    = This.GetitemDecimal(row, "accept_qty") 
//			ls_org_yn = This.GetitemString(row, "accept_yn", Primary!, True) 
//			IF ls_org_yn = 'Y' THEN
//				This.Setitem(row, "out_ymd",     This.GetitemString(row, "out_ymd", Primary!, True))
//				This.Setitem(row, "out_no",      This.GetitemString(row, "out_no", Primary!, True))
//				This.Setitem(row, "no",          This.GetitemString(row, "no", Primary!, True))
//				This.Setitem(row, "curr_price",  This.GetitemDecimal(row, "curr_price", Primary!, True))
//				This.Setitem(row, "sale_type",   This.GetitemString(row, "sale_type", Primary!, True))
//				This.Setitem(row, "disc_rate",   This.GetitemDecimal(row, "disc_rate", Primary!, True))
//				This.Setitem(row, "margin_rate", This.GetitemDecimal(row, "margin_rate", Primary!, True))
//				This.Setitem(row, "accept_qty",  This.GetitemDecimal(row, "accept_qty", Primary!, True))
//				This.Setitem(row, "out_collect", This.GetitemDecimal(row, "out_collect", Primary!, True))
//				This.Setitem(row, "vat",         This.GetitemDecimal(row, "vat", Primary!, True))
//			ELSE
//   			IF isnull(ll_qty) OR ll_qty = 0 THEN 
//	   			This.Setitem(row, "accept_qty", This.GetitemDecimal(row, "rqst_qty"))
//		   	END IF 
//		   	IF wf_margin_set(row) = FALSE THEN
//			   	RETURN 1
////	   		END IF
////			END IF
//		ELSE
//			SetNull(ll_qty)
//			SetNull(ls_Null)
//			This.Setitem(row, "out_ymd",     ls_null)
//			This.Setitem(row, "out_no",      ls_null)
//			This.Setitem(row, "no",          ls_null)
//			This.Setitem(row, "curr_price",  ll_qty)
//			This.Setitem(row, "sale_type",   ls_null)
//			This.Setitem(row, "disc_rate",   ll_qty)
//			This.Setitem(row, "margin_rate", ll_qty)
//			This.Setitem(row, "accept_qty",  ll_qty)
//			This.Setitem(row, "out_collect", 0)
//			This.Setitem(row, "vat", 0)
//		END IF
END CHOOSE

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

event dw_body::clicked;call super::clicked;string ls_style
choose case dwo.name
	case "style_no"
		ls_style = this.getitemstring(row, "style_no")
		gf_style_pic(ls_style,"%")
end choose
end event

type dw_print from w_com010_e`dw_print within w_54014_e
integer x = 2455
integer y = 876
string dataobject = "d_com420"
end type

