$PBExportHeader$w_53012_e.srw
$PBExportComments$타사매출 이동 처리
forward
global type w_53012_e from w_com010_e
end type
end forward

global type w_53012_e from w_com010_e
end type
global w_53012_e w_53012_e

type variables
String is_brand,      is_yymmdd,       is_fr_ymd,     is_to_ymd 
String is_fr_shop_cd, is_fr_shop_type, is_to_shop_cd, is_to_shop_type

end variables

on w_53012_e.create
call super::create
end on

on w_53012_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
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
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' " + & 
											 "  AND SHOP_DIV  IN ('G', 'K')" 
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
				dw_head.SetColumn("fr_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "fr_shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "fr_shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' " + &
											 "  AND SHOP_DIV  = 'T' " 
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
				dw_head.SetItem(al_row, "fr_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "fr_shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				IF ai_div = 2 THEN 
					This.Post Event ue_retrieve()
            END IF 
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("fr_shop_type")
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

event open;call super::open;dw_head.Setitem(1, "to_shop_type", '9') 
dw_head.Setitem(1, "fr_shop_type", '4') 

end event

event ue_retrieve();call super::ue_retrieve;String ls_brand, ls_shop_cd, ls_shop_type, ls_yymmdd 

ls_brand     = dw_head.GetitemString(1, "brand")
ls_shop_cd   = dw_head.GetitemString(1, "fr_shop_cd")
ls_shop_type = dw_head.GetitemString(1, "fr_shop_type")
ls_yymmdd    = String(dw_head.GetitemDate(1, "yymmdd"), "yyyymmdd")

dw_body.retrieve(ls_brand, ls_shop_cd, ls_shop_type, ls_yymmdd)

dw_body.SetFilter("dc_rate <> 0")
dw_body.Filter()

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.18                                                  */	
/* 수정일      : 2002.06.18                                                  */
/*===========================================================================*/
long     ll_row
String   ls_sale_type, ls_ErrMsg 
Decimal  ldc_dc_rate,  ldc_marjin_rate 
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1

ll_row = dw_body.GetSelectedRow(0)

IF ll_row < 1 THEN 
	MessageBox("확인", "사입매장 마진형태를 선택하십시오 !")
	RETURN 0
END IF 
ls_sale_type     = dw_body.GetitemString(ll_row,  "sale_type") 
ldc_dc_rate      = dw_body.GetitemDecimal(ll_row, "dc_rate") 
ldc_marjin_rate  = dw_body.GetitemDecimal(ll_row, "marjin_rate")  

il_rows = 1

DECLARE SP_53012 PROCEDURE FOR SP_53012
        @fr_shop_cd     = :is_fr_shop_cd, 
        @fr_shop_type   = :is_fr_shop_type, 
        @to_shop_cd     = :is_to_shop_cd, 
        @to_shop_type   = :is_to_shop_type, 
        @fr_ymd         = :is_fr_ymd,   
        @to_ymd         = :is_to_ymd,   
        @yymmdd         = :is_yymmdd,   
        @brand          = :is_brand, 
        @sale_type      = :ls_sale_type, 
        @disc_rate      = :ldc_dc_rate, 
        @marjin_rate    = :ldc_marjin_rate,
        @user_id        = :gs_user_id ;  
EXECUTE SP_53012;
if SQLCA.SQLCODE < 0  then
   ls_ErrMsg  = SQLCA.SQLErrText 
   il_rows    = -1 
end if 

if il_rows = 1 then
   commit  USING SQLCA;
	MessageBox("확인", "이동 처리가 완료 되였습니다 !")
else
   rollback  USING SQLCA;
	MessageBox("저장오류", ls_ErrMsg)
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.09                                                  */	
/* 수정일      : 2002.04.01                                                  */
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


is_yymmdd = String(dw_head.GetitemDate(1, "yymmdd"), "yyyymmdd")

is_to_shop_cd = dw_head.GetItemString(1, "to_shop_cd")
if IsNull(is_to_shop_cd) or Trim(is_to_shop_cd) = "" then
   MessageBox(ls_title,"판매 매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_shop_cd")
   return false
end if
is_to_shop_type = dw_head.GetItemString(1, "to_shop_type")

is_fr_ymd = String(dw_head.GetitemDate(1, "fr_ymd"), "yyyymmdd")
is_to_ymd = String(dw_head.GetitemDate(1, "to_ymd"), "yyyymmdd")
IF LeftA(is_fr_ymd, 6) <> LeftA(is_to_ymd, 6) THEN
   MessageBox(ls_title,"판매기간은 같은월만 가능합니다 !")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
END IF	

is_fr_shop_cd = dw_head.GetItemString(1, "fr_shop_cd")
if IsNull(is_fr_shop_cd) or Trim(is_fr_shop_cd) = "" then
   MessageBox(ls_title,"사입 매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("is_fr_shop_cd")
   return false
end if
is_fr_shop_type = dw_head.GetItemString(1, "fr_shop_type")
if IsNull(is_fr_shop_type) or Trim(is_fr_shop_type) = "" then
   MessageBox(ls_title,"매장 형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_shop_type")
   return false
end if

Return true
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53012_e","0")
end event

type cb_close from w_com010_e`cb_close within w_53012_e
end type

type cb_delete from w_com010_e`cb_delete within w_53012_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_53012_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_53012_e
boolean visible = false
end type

type cb_update from w_com010_e`cb_update within w_53012_e
boolean enabled = true
end type

type cb_print from w_com010_e`cb_print within w_53012_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_53012_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_53012_e
end type

type cb_excel from w_com010_e`cb_excel within w_53012_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_53012_e
integer width = 3333
integer height = 700
string dataobject = "d_53012_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("001")

This.GetChild("fr_shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("to_shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.18                                                  */	
/* 수정일      : 2002.06.18                                                  */
/*===========================================================================*/
String ls_yymmdd
Long   ll_ret

cb_update.enabled = true

CHOOSE CASE dwo.name
	CASE "yymmdd"      
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
	CASE "to_shop_cd"
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "fr_shop_cd"	 	 
		IF ib_itemchanged THEN RETURN 1
		ll_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1) 
		IF ll_ret = 0 OR ll_ret = 2 THEN
			Parent.Post Event ue_retrieve()
		END IF
		return ll_ret
	CASE "fr_shop_type"	 	 
		Parent.Post Event ue_retrieve()
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_53012_e
integer beginy = 892
integer endy = 892
end type

type ln_2 from w_com010_e`ln_2 within w_53012_e
integer beginy = 896
integer endy = 896
end type

type dw_body from w_com010_e`dw_body within w_53012_e
event ue_syscommand pbm_syscommand
integer x = 14
integer y = 908
integer width = 3579
integer height = 1132
boolean titlebar = true
string title = "사입매장 마진 형태"
string dataobject = "d_53012_d01"
end type

event dw_body::ue_syscommand;/* DataWindow 위치 이동 금지 */
uint a

a = message.wordparm

CHOOSE CASE a
      CASE 61456, 61458
         message.processed = true
         message.returnvalue = 0
END CHOOSE

return

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('011')

end event

event dw_body::clicked;call super::clicked;IF row < 1 THEN RETURN 

This.selectrow( 0,   False)
This.selectrow( row, True)
end event

type dw_print from w_com010_e`dw_print within w_53012_e
end type

