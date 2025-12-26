$PBExportHeader$w_22101_e.srw
$PBExportComments$원자재 출고 등록
forward
global type w_22101_e from w_com020_e
end type
end forward

global type w_22101_e from w_com020_e
end type
global w_22101_e w_22101_e

type variables
string is_brand, is_out_ymd, is_house, is_out_gubn, is_style, is_chno, is_mat_cd, is_cust_cd
string is_flag, is_iche_mat_cd
long il_list_row, il_body_row = 1


end variables

on w_22101_e.create
call super::create
end on

on w_22101_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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
if as_cb_div >= '8' then	//d_izene_L01
	is_brand   = dw_list.GetItemString(il_list_row, "brand")
	is_house   = dw_list.GetItemString(il_list_row, "house")
	is_out_gubn= dw_list.GetItemString(il_list_row, "out_gubn")
	is_style   = dw_list.GetItemString(il_list_row, "style")
	is_chno    = dw_list.GetItemString(il_list_row, "chno")
	is_mat_cd  = dw_list.GetItemString(il_list_row, "mat_cd")
else
	is_brand   = dw_head.GetItemString(1, "brand")
	is_house   = dw_head.GetItemString(1, "house")
	is_out_gubn= dw_head.GetItemString(1, "out_gubn")
	is_style   = dw_head.GetItemString(1, "style")
	is_chno    = dw_head.GetItemString(1, "chno")
	is_mat_cd  = dw_head.GetItemString(1, "mat_cd")
	is_cust_cd = dw_head.GetItemString(1, "cust_cd")
	is_iche_mat_cd = dw_head.GetItemString(1, "iche_mat_cd")
end if

is_out_ymd = dw_head.GetItemString(1, "out_ymd")

if as_cb_div = '2'   then 
	if is_out_gubn = "02"  then 
		if IsNull(is_iche_mat_cd) or Trim(is_iche_mat_cd) = "" then
			MessageBox(ls_title,"자재이체 코드를 입력하십시요!")
			dw_head.SetFocus()
			dw_head.SetColumn("iche_mat_cd")
			return false
		end if
		if  LenA(is_iche_mat_cd) <> 10 then
			MessageBox(ls_title,"자재이체 코드를 입력하십시요!")
			dw_head.SetFocus()
			dw_head.SetColumn("iche_mat_cd")
			return false
		end if
	elseif is_out_gubn = "03" then
		if IsNull(is_cust_cd) or Trim(is_cust_cd) = "" then
			MessageBox(ls_title,"재가공업체 코드를 입력하십시요!")
			dw_head.SetFocus()
			dw_head.SetColumn("cust_cd")
			return false
		end if		

	elseif is_out_gubn = "05" then
		if IsNull(is_cust_cd) or Trim(is_cust_cd) = "" then
			MessageBox(ls_title,"자재판매업체 코드를 입력하십시요!")
			dw_head.SetFocus()
			dw_head.SetColumn("cust_cd")
			return false
		end if		
	elseif not gf_datechk(is_out_ymd) then 
			MessageBox(ls_title,"출고일자를 올바로 입력하십시요!")
			dw_head.SetFocus()
			dw_head.SetColumn("out_ymd")		
			return false
			
	end if
	
	
	
end if


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif ( gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm ,ls_mat_nm
Boolean    lb_check 
DataStore  lds_Source


is_brand = dw_head.getitemstring(1,"brand")

CHOOSE CASE as_column
	case "style"
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				END IF 
			END IF	
	
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "제품 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "Where brand     = '" + is_brand + "' " 
	
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " style like '%" + as_data +"%'"
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
				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				dw_head.SetItem(al_row, "chno" , lds_Source.GetItemString(1,"chno"))
	
				/* 다음컬럼으로 이동 */
				dw_head.scrolltorow(1)
				dw_head.SetColumn("ord_origin")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source	
						
	CASE "cust_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "cust_nm", "")
					RETURN 0
				END IF
				
				IF LeftA(as_data, 1) = is_brand and gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911"
			
			choose case is_brand
				case 'O','D'
					gst_cd.default_where   = " WHERE BRAND in ( 'O','D') AND  CUST_CODE  > '5000' and cust_code < '8999'  "
				case else
					gst_cd.default_where   = " WHERE BRAND = 'N' AND  CUST_CODE  > '5000' and cust_code < '8999'  "					
			end choose
			

	   	if gs_brand <> "K" then	
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%')" 
				ELSE
					gst_cd.Item_where = ""
				END IF
			else
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%') and custcode LIKE '[KO]%' " 
				ELSE
					gst_cd.Item_where = " custcode LIKE '[KO]%' "
				END IF
				
			end if	

//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "(CUSTCODE LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%')"
//			ELSE
//				gst_cd.Item_where = ""
//			END IF

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
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("smat_cd")
				ib_itemchanged = False
				lb_check = TRUE
			END IF
			Destroy  lds_Source
			
	CASE "mat_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or as_data = "" then
						RETURN 0			
				ELSEIF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
						RETURN 0		
				end if
					
			END IF
			
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "원자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 

			
			gst_cd.default_where   = "where brand = '" + is_brand + "'" //
		
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "mat_cd LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
				dw_head.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))

				
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
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

event ue_retrieve();/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string iche_mat_cd
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN



dw_list.dataobject = "d_22101_l02"
dw_list.SetTransObject(SQLCA)

il_rows = dw_list.retrieve(is_brand, is_house, is_out_ymd, is_out_gubn, is_mat_cd, is_style, is_chno, is_cust_cd, "Dat")
dw_body.Reset()
IF il_rows > 0 THEN
	
   dw_list.SetFocus()
END IF



This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

cb_retrieve.enabled = true

end event

event pfc_preopen;call super::pfc_preopen;datetime ld_datetime




IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"out_ymd",string(ld_datetime,"yyyymmdd"))
end if

end event

event ue_insert();
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN

dw_list.dataobject = "d_22101_l01"
dw_list.SetTransObject(SQLCA)

il_rows = dw_list.retrieve(is_brand, is_house, is_out_gubn,is_style, is_chno, is_cust_cd, is_mat_cd, "New")
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.setfocus()
	
END IF

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)


end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1,2		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
			cb_preview.enabled = true			
      else
         dw_head.SetFocus()
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
      cb_retrieve.Text = "조회(&Q)"
//      cb_insert.enabled = false
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then

         cb_delete.enabled = true
         if is_flag = "New" then 	cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
         cb_insert.enabled = true
      end if
		
END CHOOSE


if dw_head.enabled = true then
	dw_head.setitem(1,"prot",0)
else
	dw_head.setitem(1,"prot",1)
end if
end event

event ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Integer li_result

if is_flag = "New" then Return
If li_result = 3 Then Return

is_brand   = dw_body.getitemstring(il_body_row,"brand")
is_out_ymd = dw_body.GetItemstring(il_body_row, "out_ymd")
is_style   = dw_body.getitemstring(il_body_row,"style")
is_out_gubn= dw_body.getitemstring(il_body_row,"out_gubn")

This.Trigger Event ue_title()

messagebox("is_brand",is_brand)
messagebox("is_out_ymd",is_out_ymd)
messagebox("is_style",is_style)
messagebox("is_out_gubn",is_out_gubn)

dw_print.Retrieve(is_brand, is_out_ymd, is_style, is_out_gubn)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Integer li_result


If li_result = 3 Then Return
is_brand   = dw_head.getitemstring(1,"brand")
is_out_ymd = dw_head.GetItemstring(1, "out_ymd")
is_style   = dw_head.getitemstring(1,"style")
is_style   = dw_head.getitemstring(1,"style")
is_mat_cd  = dw_head.getitemstring(1,"mat_cd")
is_out_gubn= dw_head.getitemstring(1,"out_gubn")

This.Trigger Event ue_title ()
//messagebox("is_brand",is_brand)
//messagebox("is_out_ymd",is_out_ymd)
//messagebox("is_out_no",is_out_no)


dw_print.Retrieve(is_brand, is_out_ymd, is_style, is_mat_cd, is_out_gubn) 
dw_print.inv_printpreview.of_SetZoom()

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_out_no
datetime ld_datetime
string ls_brand, ls_mat_cd ,ls_color, ls_iche_mat_cd, t_io_gubn
decimal ll_qty ,ll_price, ll_amt


ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF



select 
	isnull(convert(int,max(out_no)+1),1) 
		into :ll_out_no
from tb_22020_h 
where brand   = :is_brand
and   out_ymd = :is_out_ymd
and   out_gubn = :is_out_gubn;

if isnull(ll_out_no) then ll_out_no = 1


is_flag= dw_body.getitemstring(1,"flag")

ls_iche_mat_cd = dw_head.getitemstring(1,"iche_mat_cd")

i = dw_body.rowcount()
DO WHILE i > 0
	ll_qty = dec(dw_body.getitemnumber(i,"qty"))
	ll_price = dec(dw_body.getitemnumber(i,"price"))		
	
	if isnull(ll_qty) or ll_qty = 0 then dw_body.deleterow(i) 		

	ll_amt = dec(dw_body.getitemnumber(i,"amt"))
	if isnull(ll_amt) or ll_amt = 0 then 
		ll_price = dec(dw_body.getitemnumber(i,"price"))		
		dw_body.Setitem(i, "amt",ll_qty*ll_price)
	end if

	if ll_amt <> ll_qty*ll_price then 
		ll_price = dec(dw_body.getitemnumber(i,"price"))		
		dw_body.Setitem(i, "amt",ll_qty*ll_price)
	end if
	
	dw_body.Setitem(i, "amt",ll_qty*ll_price)
	
	i = i - 1
LOOP


FOR i=1 TO dw_body.rowcount()
	
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
		
		dw_body.Setitem(i, "out_no", string(ll_out_no,"0000"))
		ll_out_no = ll_out_no +1
      dw_body.Setitem(i, "reg_id", gs_user_id)
		is_cust_cd = dw_body.getitemstring(i,"cust_cd")
		if isnull(is_cust_cd) and is_out_gubn = "04" then
			is_cust_cd = is_brand + "04999"
			dw_body.Setitem(i, "cust_cd", is_cust_cd)
		end if
		
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)

   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)


if il_rows = 1 then
	if is_out_gubn = "02" then	//이체출고 별도 처리
		FOR i=1 TO dw_body.rowcount()
	
			ls_brand = dw_body.getitemstring(i,"brand")
			ls_mat_cd = dw_body.getitemstring(i,"mat_cd")
//			if is_flag = 'Dat' then
				ls_iche_mat_cd = dw_body.getitemstring(i,"iche_mat_cd")
//			end if
			ls_color = dw_body.getitemstring(i,"color")
			ll_qty = dec(dw_body.getitemnumber(i,"qty"))
			ll_price = dec(dw_body.getitemnumber(i,"price"))
			
			

//messagebox("ls_brand",ls_brand)
//messagebox("is_out_ymd",is_out_ymd)
//messagebox("ls_mat_cd",ls_mat_cd)
//messagebox("ls_color",ls_color)
//messagebox("ll_qty",string(ll_qty,"#,##0.00"))
//messagebox("ll_price",string(ll_price,"#,##0.00"))
//messagebox("ls_iche_mat_cd",ls_iche_mat_cd)
//messagebox("gs_user_id",gs_user_id)
//messagebox("is_flag",is_flag)


			 DECLARE sp_mat_iche PROCEDURE FOR sp_mat_iche  
						@brand     = :ls_brand,  
						@in_ymd	  = :is_out_ymd,
						@mat_cd    = :ls_mat_cd,   
						@color     = :ls_color,   
						@qty   	  = :ll_qty,  
						@price	  = :ll_price,
						@iche_mat_cd = :ls_iche_mat_cd,
						@user_id		 = :gs_user_id,
						@flag			 = :is_flag;
						
			 execute sp_mat_iche;	

		NEXT	
	end if
	
end if


if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	if is_out_gubn = '02' then 	il_rows = dw_body.retrieve(is_brand, is_house, is_out_gubn, is_style, is_chno, is_mat_cd, is_out_ymd, "Dat")		
	
else
   rollback  USING SQLCA;
	
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22101_e","0")
end event

type cb_close from w_com020_e`cb_close within w_22101_e
end type

type cb_delete from w_com020_e`cb_delete within w_22101_e
boolean enabled = true
end type

type cb_insert from w_com020_e`cb_insert within w_22101_e
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_22101_e
end type

type cb_update from w_com020_e`cb_update within w_22101_e
end type

type cb_print from w_com020_e`cb_print within w_22101_e
end type

type cb_preview from w_com020_e`cb_preview within w_22101_e
end type

type gb_button from w_com020_e`gb_button within w_22101_e
end type

type cb_excel from w_com020_e`cb_excel within w_22101_e
end type

type dw_head from w_com020_e`dw_head within w_22101_e
string dataobject = "d_22101_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand_cd"      // dddw로 작성된 항목

	CASE "style","cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;DataWindowChild ldw_child
string ls_filter


This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('001')

This.GetChild("out_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('023')

ls_filter = "inter_cd not in ('02','03')"
ldw_child.SetFilter(ls_filter)
ldw_child.Filter( )


This.GetChild("smp_item", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve()




end event

event dw_head::editchanged;call super::editchanged;choose case dwo.name
	case "mat_cd","style","ord_origin"
		if LenA(data) = 1 then this.setitem(1,"brand",data)
end choose
end event

type ln_1 from w_com020_e`ln_1 within w_22101_e
end type

type ln_2 from w_com020_e`ln_2 within w_22101_e
end type

type dw_list from w_com020_e`dw_list within w_22101_e
event body_reset ( )
integer y = 452
integer height = 1556
string dataobject = "d_22101_l02"
boolean controlmenu = true
end type

event dw_list::body_reset;
choose case is_out_gubn 
	case "01"	
			dw_body.dataobject = "d_22101_d01"
	case "02"   
			dw_body.dataobject = "d_22101_d02"
	case "03"	
			dw_body.dataobject = "d_22101_d03"
	case "04"	
			dw_body.dataobject = "d_22101_d04"
	case "05"	
			dw_body.dataobject = "d_22101_d05"
	case "06"	
			dw_body.dataobject = "d_22101_d06"
end choose 
dw_body.SetTransObject(SQLCA)

DataWindowChild ldw_child

dw_body.GetChild("make_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve("030")

dw_body.GetChild("patt_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve("020")


dw_body.GetChild("smp_item", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve()

dw_body.GetChild("st_color", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve()

dw_body.GetChild("color", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve()

end event

event dw_list::doubleclicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
string iche_mat_cd

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
//This.SelectRow(0, FALSE)
//This.SelectRow(row, TRUE)

il_list_row = row

is_flag = dw_list.getitemstring(row,"flag")
if is_flag = "New" then
		IF Trigger Event ue_keycheck('9') = FALSE THEN RETURN
else
		IF Trigger Event ue_keycheck('8') = FALSE THEN RETURN
end if


trigger event body_reset()

il_rows = dw_body.retrieve(is_brand, is_house, is_out_gubn, is_style, is_chno, is_mat_cd, is_out_ymd, is_flag)		
IF il_rows > 0 THEN
		
	if is_flag = "New" then

		for i = 1 to dw_body.rowcount()			

			if is_out_gubn = "03" or is_out_gubn = "04" or is_out_gubn = "05" then	
				dw_body.setitem(i,"cust_cd",is_cust_cd)
				dw_body.setitem(i,"st_cust_nm",dw_head.getitemstring(1,"cust_nm"))
			elseif is_out_gubn = "02" then
				dw_body.setitem(i,"iche_mat_cd", is_iche_mat_cd)
			end if
			
			dw_body.SetItemStatus(i, 0, Primary!,New!)
		next 
	else

		if is_out_gubn = "02" then 
			select top 1 mat_cd 
				into :iche_mat_cd
			from tb_22010_h 
			where in_gubn = '02' 
			and prv_mat_cd = :is_mat_cd 
			order by brand , mat_year, case mat_season when 's' then '1' when 'm' then '2' when 'a' then '3' else '4' end desc;
			
			dw_body.object.t_iche_mat_cd.text = iche_mat_cd
		end if
		
		
	end if
   dw_body.SetFocus()
	dw_body.setcolumn("qty")
END IF


Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

event dw_list::clicked;call super::clicked;This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

end event

type dw_body from w_com020_e`dw_body within w_22101_e
event ue_set_amt ( long as_row )
event type integer ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
integer y = 452
integer width = 2770
integer height = 1552
string dataobject = "d_22101_d01"
end type

event dw_body::ue_set_amt(long as_row);decimal ll_qty, ll_price
IF dw_body.AcceptText() <> 1 THEN RETURN

ll_qty = this.getitemnumber(as_row,"qty")
ll_price = this.getitemnumber(as_row,"price")

this.setitem(as_row,"t_amt", ll_qty * ll_price)
this.setitem(as_row,"amt", ll_qty * ll_price)
end event

event type integer dw_body::ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm ,ls_mat_nm
Boolean    lb_check 
DataStore  lds_Source


is_brand = dw_head.getitemstring(1,"brand")

CHOOSE CASE as_column
						
	CASE "cust_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_body.SetItem(al_row, "cust_nm", "")
					RETURN 0
				END IF
				
				IF LeftA(as_data, 1) = is_brand and gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_body.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911"
			
			choose case is_brand
				case 'O','D'
					gst_cd.default_where   = " WHERE BRAND in ('O','D') AND  CUST_CODE  > '5000' and cust_code < '8999'  "
				case else
					gst_cd.default_where   = " WHERE BRAND = 'N' AND  CUST_CODE  > '5000' and cust_code < '8999'  "					
			end choose
			

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(CUSTCODE LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%')"
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
				dw_body.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_body.SetItem(al_row, "st_cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("smat_cd")
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

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("make_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve("030")

This.GetChild("patt_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve("020")


This.GetChild("smp_item", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve()

This.GetChild("st_color", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve()

This.GetChild("color", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve()

dw_body.insertrow(0)


/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
//This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

end event

event dw_body::clicked;il_body_row = row

//This.SelectRow(0, FALSE)
//This.SelectRow(row, TRUE)

end event

event dw_body::itemchanged;
/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name

	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE




if is_out_gubn = "05" then
	choose case dwo.name
		case "qty","price"
			post event ue_set_amt(row)
	end choose
end if

end event

event dw_body::buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

type st_1 from w_com020_e`st_1 within w_22101_e
integer y = 456
integer height = 1584
end type

type dw_print from w_com020_e`dw_print within w_22101_e
integer x = 18
integer y = 184
string dataobject = "d_22101_r01"
end type

