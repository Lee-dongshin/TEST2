$PBExportHeader$w_71031_d.srw
$PBExportComments$상품권지급조회
forward
global type w_71031_d from w_com010_d
end type
end forward

global type w_71031_d from w_com010_d
end type
global w_71031_d w_71031_d

type variables
string  is_from_give_date, is_to_give_date, is_jumin , is_shop_cd, is_accept_flag, is_brand, is_opt_view, is_sale_type
datawindowchild idw_sale_type, idw_brand

end variables

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


is_from_give_date = dw_head.GetItemString(1, "from_give_date")
if IsNull(is_from_give_date) or Trim(is_from_give_date) = "" then
   MessageBox(ls_title,"from 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("from_give_date")
   return false
end if

is_to_give_date = dw_head.GetItemString(1, "to_give_date")
if IsNull(is_to_give_date) or Trim(is_to_give_date) = "" then
   MessageBox(ls_title,"to 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_give_date")
   return false
end if


is_jumin = dw_head.GetItemString(1, "jumin")
if IsNull(is_jumin) or Trim(is_jumin) = "" then 
  is_jumin = '%' 
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then 
  is_shop_cd = '%' 
end if
is_accept_flag = dw_head.GetItemString(1, "accept_flag")
if IsNull(is_accept_flag) or Trim(is_accept_flag) = "" then 
  is_accept_flag = '%' 
end if

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then 
  is_brand = '%' 
end if

is_opt_view = dw_head.GetItemString(1, "opt_view")
if IsNull(is_opt_view) or Trim(is_opt_view) = "" then
   MessageBox(ls_title,"조회기준을 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_view")
   return false
end if

is_sale_type = dw_head.GetItemString(1, "sale_type")
if IsNull(is_sale_type) or Trim(is_sale_type) = "" then
   MessageBox(ls_title,"판매형태를 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_type")
   return false
end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징                                        */	
/* 작성일      : 2002.04.16                                                  */	
/* 수정일      : 2002.04.16                                                  */
/*===========================================================================*/
String     ls_shop_nm,ls_style, ls_chno
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
			gst_cd.default_where   = "WHERE  Shop_Stat = '00' " + &
											 "  AND  SHOP_DIV IN ('D','G', 'K') "			
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
//				dw_head.SetColumn("end_ymd")
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_opt_view <> 'D' then
	il_rows = dw_body.retrieve(is_from_give_date,is_to_give_date,is_jumin,is_shop_cd,is_accept_flag,is_brand, is_sale_type)
else
	il_rows = dw_body.retrieve(is_from_give_date,is_to_give_date,is_brand,is_shop_cd)	
end if	
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

on w_71031_d.create
call super::create
end on

on w_71031_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =  "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_yymmdd.Text   = '" + String(is_from_give_date + is_to_give_date, '@@@@/@@/@@ ~~ @@@@/@@/@@') + "'" 

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_71031_d
end type

type cb_delete from w_com010_d`cb_delete within w_71031_d
end type

type cb_insert from w_com010_d`cb_insert within w_71031_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_71031_d
end type

type cb_update from w_com010_d`cb_update within w_71031_d
end type

type cb_print from w_com010_d`cb_print within w_71031_d
end type

type cb_preview from w_com010_d`cb_preview within w_71031_d
end type

type gb_button from w_com010_d`gb_button within w_71031_d
end type

type cb_excel from w_com010_d`cb_excel within w_71031_d
end type

type dw_head from w_com010_d`dw_head within w_71031_d
integer y = 160
integer height = 264
string dataobject = "d_71031_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "opt_view"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if data = "A" then
			dw_body.dataobject = "d_71031_d01"
			dw_body.SetTransObject(SQLCA)
			
			dw_body.GetChild("sale_type", idw_sale_type)
			idw_sale_type.SetTransObject(SQLCA)
			idw_sale_type.Retrieve('011')

			
			dw_print.dataobject = "d_71031_r01"
			dw_print.SetTransObject(SQLCA)
			
			dw_print.GetChild("sale_type", idw_sale_type)
			idw_sale_type.SetTransObject(SQLCA)
			idw_sale_type.Retrieve('011')			
		elseif data = "B" then
			dw_body.dataobject = "d_71031_d02"
			dw_body.SetTransObject(SQLCA)
			
			dw_print.dataobject = "d_71031_r02"
			dw_print.SetTransObject(SQLCA)
		elseif data = "C" then
			dw_body.dataobject = "d_71031_d03"
			dw_body.SetTransObject(SQLCA)
			
			dw_body.GetChild("sale_type", idw_sale_type)
			idw_sale_type.SetTransObject(SQLCA)
			idw_sale_type.Retrieve('011')

			
			dw_print.dataobject = "d_71031_r03"
			dw_print.SetTransObject(SQLCA)
			
			dw_print.GetChild("sale_type", idw_sale_type)
			idw_sale_type.SetTransObject(SQLCA)
			idw_sale_type.Retrieve('011')		
		else
			dw_body.dataobject = "d_71031_d04"
			dw_body.SetTransObject(SQLCA)
			
			dw_print.dataobject = "d_71031_r04"
			dw_print.SetTransObject(SQLCA)			
      end if			
		
			dw_body.GetChild("sale_type", idw_sale_type)
			idw_sale_type.SetTransObject(SQLCA)
			idw_sale_type.Retrieve('011')
	
			dw_print.GetChild("sale_type", idw_sale_type)
			idw_sale_type.SetTransObject(SQLCA)
			idw_sale_type.Retrieve('011')	
		
		
END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1,'inter_cd','%')
idw_brand.SetItem(1,'inter_nm','전체')


This.GetChild("sale_type", idw_sale_type)
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.Retrieve('011')
idw_sale_type.InsertRow(1)
idw_sale_type.SetItem(1,'inter_cd','%')
idw_sale_type.SetItem(1,'inter_nm','전체')

end event

type ln_1 from w_com010_d`ln_1 within w_71031_d
end type

type ln_2 from w_com010_d`ln_2 within w_71031_d
end type

type dw_body from w_com010_d`dw_body within w_71031_d
string dataobject = "d_71031_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;
This.GetChild("sale_type", idw_sale_type)
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.Retrieve('011')


end event

type dw_print from w_com010_d`dw_print within w_71031_d
string dataobject = "d_71031_r02"
end type

event dw_print::constructor;call super::constructor;
This.GetChild("sale_type", idw_sale_type)
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.Retrieve('011')


end event

