$PBExportHeader$w_54025_d.srw
$PBExportComments$매장RT요청현황
forward
global type w_54025_d from w_com010_d
end type
end forward

global type w_54025_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_54025_d w_54025_d

type variables
String is_brand, is_frm_ymd, is_to_ymd, is_shop_cd, is_opt_gubn, is_opt_stock, is_style
DataWindowChild idw_brand, idw_color
end variables

on w_54025_d.create
call super::create
end on

on w_54025_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_ymd" ,string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "to_ymd" ,string(ld_datetime,"yyyymmdd"))
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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





if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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




is_frm_ymd = dw_head.GetItemString(1, "frm_ymd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   is_shop_cd = "%"
end if


is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
   is_style = "%"
end if

is_opt_gubn = dw_head.GetItemString(1, "opt_gubn")
if IsNull(is_opt_gubn) or Trim(is_opt_gubn) = "" then
   MessageBox(ls_title,"조회기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_opt_stock = dw_head.GetItemString(1, "opt_stock")
if IsNull(is_opt_stock) or Trim(is_opt_stock) = "" then
   MessageBox(ls_title,"조회기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_stock")
   return false
end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm , LS_BRAND, ls_style, ls_chno
Boolean    lb_check 
DataStore  lds_Source


	Ls_brand = dw_head.GetItemString(1, "brand")

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + &
											 " and brand = '" + Ls_brand + "'"
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
				ls_chno  = lds_Source.GetItemString(1,"chno")				

				dw_head.SetItem(al_row, "style", ls_style)
				
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("opt_gubn")
				
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

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_opt_gubn = "A" then 
	dw_body.DataObject = "d_54025_d01"
	dw_body.SetTransObject(SQLCA)
else	
	dw_body.DataObject = "d_54025_d02"	
	dw_body.SetTransObject(SQLCA)
end if	

il_rows = dw_body.retrieve(is_brand, is_frm_ymd, is_to_ymd, is_shop_cd, is_opt_stock,is_style)
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

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm, ls_opt_gubn, ls_opt_stock

ls_shop_nm = dw_head.getitemstring(1, "shop_nm")

if isnull(ls_shop_nm) or LenA(ls_shop_nm) = 0 then 
	ls_shop_nm = "전체매장"
end if

if is_opt_gubn = "A" then
	ls_opt_gubn = "매장별 조회"
else	
	ls_opt_gubn = "스타일별 조회"
end if	

if is_opt_stock = "A" then
	ls_opt_stock = "전체 요청스타일"
else	
	ls_opt_stock = "물류재고 5장이상 스타일"
end if	


IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF



ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	 "t_pg_id.Text    = '" + is_pgm_id + "'" + &
             "t_user_id.Text  = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
			    "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(),"inter_display") + "'" + &
             "t_frm_ymd.Text  = '" + is_frm_ymd + "'" + &				 
             "t_to_ymd.Text   = '" + is_to_ymd + "'" + &				 				 
				 "t_shop_cd.Text       = '" + is_shop_cd + "'" + & 
				 "t_shop_nm.Text       = '" + ls_shop_nm + "'" + & 				 
				 "t_opt_gubn.Text      = '" + ls_opt_gubn + "'" + & 				
				 "t_opt_stock.Text     = '" + ls_opt_stock + "'" 

dw_print.Modify(ls_modify)

end event

event ue_print();if is_opt_gubn = "A" then 
	dw_print.DataObject = "d_54025_r01"
	dw_print.SetTransObject(SQLCA)
else	
	dw_print.DataObject = "d_54025_r02"	
	dw_print.SetTransObject(SQLCA)
end if	

This.Trigger Event ue_title()

dw_body.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)
end event

event ue_preview();if is_opt_gubn = "A" then 
	dw_print.DataObject = "d_54025_r01"
	dw_print.SetTransObject(SQLCA)
else	
	dw_print.DataObject = "d_54025_r02"	
	dw_print.SetTransObject(SQLCA)
end if	

This.Trigger Event ue_title ()

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54025_d","0")
end event

type cb_close from w_com010_d`cb_close within w_54025_d
end type

type cb_delete from w_com010_d`cb_delete within w_54025_d
end type

type cb_insert from w_com010_d`cb_insert within w_54025_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_54025_d
end type

type cb_update from w_com010_d`cb_update within w_54025_d
end type

type cb_print from w_com010_d`cb_print within w_54025_d
end type

type cb_preview from w_com010_d`cb_preview within w_54025_d
end type

type gb_button from w_com010_d`gb_button within w_54025_d
end type

type cb_excel from w_com010_d`cb_excel within w_54025_d
end type

type dw_head from w_com010_d`dw_head within w_54025_d
integer y = 156
integer width = 3424
integer height = 204
string dataobject = "D_54025_H01"
end type

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
				
		
END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_d`ln_1 within w_54025_d
integer beginy = 376
integer endy = 376
end type

type ln_2 from w_com010_d`ln_2 within w_54025_d
integer beginy = 380
integer endy = 380
end type

type dw_body from w_com010_d`dw_body within w_54025_d
integer y = 396
integer height = 1644
string dataobject = "D_54025_D01"
end type

type dw_print from w_com010_d`dw_print within w_54025_d
string dataobject = "D_54025_r01"
end type

