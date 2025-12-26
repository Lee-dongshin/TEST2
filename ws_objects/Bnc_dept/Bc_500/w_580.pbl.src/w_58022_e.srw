$PBExportHeader$w_58022_e.srw
$PBExportComments$입금관리
forward
global type w_58022_e from w_com020_e
end type
end forward

global type w_58022_e from w_com020_e
end type
global w_58022_e w_58022_e

type variables
string is_brand, is_yymmdd, is_in_gubn, is_cust_cd, is_country_cd
datawindowchild idw_brand, idw_country_cd, idw_slip_bonji
end variables

on w_58022_e.create
call super::create
end on

on w_58022_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

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

is_yymmdd     = dw_head.GetItemString(1, "yymmdd")
is_in_gubn    = dw_head.GetItemString(1, "in_gubn")
is_cust_cd    = dw_head.GetItemString(1, "cust_cd")
is_country_cd = dw_head.GetItemString(1, "country_cd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_yymmdd, is_in_gubn, is_cust_cd, is_country_cd)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;dw_body.insertrow(1)
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"				
			IF ai_div = 1 THEN 	
				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_body.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재/생산 거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911"
			
			gst_cd.default_where   = "WHERE CHANGE_GUBN = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "CUSTCODE LIKE '" + as_data + "%'"
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
				dw_body.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("exchange")
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

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
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
      dw_body.Setitem(i, "reg_id", gs_user_id)
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

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
      else
			cb_insert.enabled = true
         dw_head.SetFocus()
      end if

   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_list.Enabled = true
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
      cb_insert.enabled = false
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
         cb_print.enabled = true
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

end event

type cb_close from w_com020_e`cb_close within w_58022_e
end type

type cb_delete from w_com020_e`cb_delete within w_58022_e
end type

type cb_insert from w_com020_e`cb_insert within w_58022_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_58022_e
end type

type cb_update from w_com020_e`cb_update within w_58022_e
end type

type cb_print from w_com020_e`cb_print within w_58022_e
end type

type cb_preview from w_com020_e`cb_preview within w_58022_e
end type

type gb_button from w_com020_e`gb_button within w_58022_e
end type

type cb_excel from w_com020_e`cb_excel within w_58022_e
end type

type dw_head from w_com020_e`dw_head within w_58022_e
string dataobject = "d_58022_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')
idw_country_cd.insertrow(1)
idw_country_cd.setitem(1,"inter_cd","%")
idw_country_cd.setitem(1,"inter_nm","전체")
end event

event dw_head::itemchanged;//
end event

event dw_head::buttonclicked;call super::buttonclicked;pointer oldpointer 

choose case dwo.name
	case "cb_take_bill"
 		oldpointer = SetPointer(HourGlass!)
		DECLARE sp_make_tb_56501_h PROCEDURE FOR sp_make_tb_56501_h  
					@yymmdd	  = :is_yymmdd;
					
		execute sp_make_tb_56501_h;	
		commit  USING SQLCA;
		SetPointer(oldpointer)
		
		messagebox("확인","처리완료 !!")

end choose

end event

type ln_1 from w_com020_e`ln_1 within w_58022_e
end type

type ln_2 from w_com020_e`ln_2 within w_58022_e
end type

type dw_list from w_com020_e`dw_list within w_58022_e
integer width = 1147
string dataobject = "d_58022_l01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_brand, ls_yymmdd, ls_in_gubn, ls_cust_cd, ls_country_cd

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
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)


ls_brand      = This.GetItemString(row, 'brand') /* DataWindow에 Key 항목을 가져온다 */
ls_yymmdd     = This.GetItemString(row, 'yymmdd')
ls_in_gubn    = This.GetItemString(row, 'in_gubn')
ls_cust_cd    = This.GetItemString(row, 'cust_cd')
ls_country_cd = This.GetItemString(row, 'country_cd')


il_rows = dw_body.retrieve(ls_brand, ls_yymmdd, ls_in_gubn, ls_cust_cd, ls_country_cd)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_58022_e
integer x = 1198
integer width = 2418
string dataobject = "d_58022_d01"
end type

event dw_body::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')


This.GetChild("slip_bonji", idw_slip_bonji)
idw_slip_bonji.SetTransObject(SQLCA)
idw_slip_bonji.Retrieve('028')

end event

event dw_body::itemchanged;/*===========================================================================*/
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
string ls_slip_bonji, ls_yymmdd, ls_country_cd
datetime ld_datetime

CHOOSE CASE dwo.name
	CASE "brand" 
		select inter_cd into :ls_slip_bonji 
		from tb_91011_c a(nolock) 
		where inter_grp = '028' 
		and   inter_cd1 = :data;
		
		this.setitem(row,'slip_bonji',ls_slip_bonji)
		
		ls_yymmdd = this.getitemstring(row,"yymmdd")
		if ls_yymmdd = '' or isnull(ls_yymmdd) then
			IF gf_cdate(ld_datetime,0)  THEN  
				this.setitem(row,"yymmdd",string(ld_datetime,"yyyymmdd"))
			end if
		end if
		
		ls_country_cd = this.getitemstring(row,"country_cd")
		if ls_country_cd = '' or isnull(ls_country_cd) then
			
			this.setitem(row,"country_cd","06")
			
		end if
		
		
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type st_1 from w_com020_e`st_1 within w_58022_e
integer x = 1179
end type

type dw_print from w_com020_e`dw_print within w_58022_e
integer y = 776
string dataobject = "d_58022_r01"
end type

