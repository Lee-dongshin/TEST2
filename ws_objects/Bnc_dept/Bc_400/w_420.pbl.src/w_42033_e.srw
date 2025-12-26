$PBExportHeader$w_42033_e.srw
$PBExportComments$박스출고대상매장(Assist)
forward
global type w_42033_e from w_com010_e
end type
end forward

global type w_42033_e from w_com010_e
integer width = 3675
integer height = 2284
end type
global w_42033_e w_42033_e

type variables
DataWindowChild idw_brand, idw_mng_cust
string is_brand, is_mng_cust
end variables

on w_42033_e.create
call super::create
end on

on w_42033_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_mng_cust)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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


is_mng_cust = dw_head.GetItemString(1, "mng_cust")
if IsNull(is_mng_cust) or Trim(is_mng_cust) = "" then
   MessageBox(ls_title,"이송업체 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("mng_cust")
   return false
end if

return true

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "brand",     is_brand)	
		dw_body.Setitem(i, "mng_cust",  is_mng_cust)		
      dw_body.Setitem(i, "reg_id",    gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_body.SetItem(al_row, "shop_nm", ls_shop_nm)
 			      dw_body.setitem(al_row, "shop_div" ,MidA(as_data,2,1))					
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
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
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "shop_cd",  lds_Source.GetItemString(1,"shop_cd"))
				dw_body.SetItem(al_row, "shop_nm",  lds_Source.GetItemString(1,"shop_nm"))
				dw_body.SetItem(al_row, "shop_div", MidA(lds_Source.GetItemString(1,"shop_cd"),2,1))				
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("close_yn")
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42033_e","0")
end event

type cb_close from w_com010_e`cb_close within w_42033_e
end type

type cb_delete from w_com010_e`cb_delete within w_42033_e
end type

type cb_insert from w_com010_e`cb_insert within w_42033_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_42033_e
end type

type cb_update from w_com010_e`cb_update within w_42033_e
end type

type cb_print from w_com010_e`cb_print within w_42033_e
end type

type cb_preview from w_com010_e`cb_preview within w_42033_e
end type

type gb_button from w_com010_e`gb_button within w_42033_e
end type

type cb_excel from w_com010_e`cb_excel within w_42033_e
end type

type dw_head from w_com010_e`dw_head within w_42033_e
integer height = 160
string dataobject = "d_42033_h01"
end type

event dw_head::constructor;datetime ld_datetime

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("mng_cust", idw_mng_cust)
idw_mng_cust.SetTransObject(SQLCA)
idw_mng_cust.Retrieve('404')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if


end event

type ln_1 from w_com010_e`ln_1 within w_42033_e
integer beginy = 340
integer endy = 340
end type

type ln_2 from w_com010_e`ln_2 within w_42033_e
integer beginy = 344
integer endy = 344
end type

type dw_body from w_com010_e`dw_body within w_42033_e
integer y = 372
integer height = 1668
string dataobject = "d_42033_d01"
end type

event dw_body::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if  LenA(data) <> 0 then
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

		end if
END CHOOSE

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_shop_div, ldw_area_cd

This.GetChild("shop_div", ldw_shop_div)
ldw_shop_div.SetTransObject(SQLCA)
ldw_shop_div.Retrieve('910')

//This.GetChild("area_cd", ldw_area_cd)
//ldw_area_cd.SetTransObject(SQLCA)
//ldw_area_cd.Retrieve('090')
//

end event

event dw_body::clicked;call super::clicked;This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)
end event

type dw_print from w_com010_e`dw_print within w_42033_e
end type

