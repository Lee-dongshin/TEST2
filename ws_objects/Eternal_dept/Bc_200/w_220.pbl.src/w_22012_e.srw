$PBExportHeader$w_22012_e.srw
$PBExportComments$원자재 수축율,절수 관리
forward
global type w_22012_e from w_com020_e
end type
end forward

global type w_22012_e from w_com020_e
integer width = 3685
integer height = 2248
end type
global w_22012_e w_22012_e

type variables
string is_brand, is_year, is_season, is_mat_cd, is_yymmdd, is_cust_cd

datawindowchild  idw_brand, idw_season
end variables

on w_22012_e.create
call super::create
end on

on w_22012_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm ,ls_mat_nm, ls_brand
Boolean    lb_check 
DataStore  lds_Source


				
is_brand = dw_head.getitemstring(1,"brand")
is_year = dw_head.getitemstring(1,"year")
is_season = dw_head.getitemstring(1,"season")

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
			if is_brand = 'O' or is_brand = 'Y' or is_brand = 'A' then
				gst_cd.default_where   = " WHERE BRAND = 'O' AND  CUST_CODE  > '5000' and cust_code < '8999'  "
			else
				gst_cd.default_where   = " WHERE BRAND = 'N' AND  CUST_CODE  > '5000' and cust_code < '8999'  "				
			end if
			
			
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
				dw_body.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
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

			
			gst_cd.default_where   = "where brand = '" + is_brand + "' and mat_year like '" + is_year + "%' and mat_season like '" + is_season + "%' "
		
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
				dw_head.SetItem(al_row, "year", lds_Source.GetItemString(1,"mat_year"))
				dw_head.SetItem(al_row, "season", lds_Source.GetItemString(1,"mat_season"))


				
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
is_year   = dw_head.GetItemString(1, "year")
is_yymmdd = dw_head.GetItemString(1, "yymmdd")
is_season = dw_head.GetItemString(1, "season")
is_mat_cd = dw_head.GetItemString(1, "mat_cd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_mat_cd)
dw_body.Reset()
IF il_rows > 0 THEN	
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

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

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

//dw_body.ShareData(dw_print)
dw_print.retrieve(is_yymmdd, is_mat_cd)

dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

//dw_body.ShareData(dw_print)
dw_print.retrieve(is_mat_cd)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;datetime id_datetime

IF gf_cdate(id_datetime,0)  THEN  
	dw_head.setitem(1,"yymmdd",string(id_datetime,"yyyymmdd"))
end if

end event

type cb_close from w_com020_e`cb_close within w_22012_e
end type

type cb_delete from w_com020_e`cb_delete within w_22012_e
end type

type cb_insert from w_com020_e`cb_insert within w_22012_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_22012_e
end type

type cb_update from w_com020_e`cb_update within w_22012_e
end type

type cb_print from w_com020_e`cb_print within w_22012_e
end type

type cb_preview from w_com020_e`cb_preview within w_22012_e
end type

type gb_button from w_com020_e`gb_button within w_22012_e
end type

type cb_excel from w_com020_e`cb_excel within w_22012_e
end type

type dw_head from w_com020_e`dw_head within w_22012_e
integer height = 156
string dataobject = "d_22012_h01"
end type

event dw_head::constructor;call super::constructor;

this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')


//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")
end event

event dw_head::itemchanged;call super::itemchanged;//choose case dwo.name
//	case "yymmdd"
//		if not gf_datechk(data) then return 1
//end choose



CHOOSE CASE dwo.name
	CASE "brand", "year"		
		//라빠레트 시즌적용
		dw_head.accepttext()
		is_brand = dw_head.getitemstring(1,'brand')
		is_year = dw_head.getitemstring(1,'year')
		
		this.getchild("season",idw_season)
		idw_season.settransobject(sqlca)
		idw_season.retrieve('003', is_brand, is_year)
		//idw_season.retrieve('003')
		idw_season.insertrow(1)
		idw_season.Setitem(1, "inter_cd", "%")
		idw_season.Setitem(1, "inter_nm", "전체")
END CHOOSE
end event

type ln_1 from w_com020_e`ln_1 within w_22012_e
integer beginy = 340
integer endy = 340
end type

type ln_2 from w_com020_e`ln_2 within w_22012_e
integer beginy = 344
integer endy = 344
end type

type dw_list from w_com020_e`dw_list within w_22012_e
integer y = 368
integer width = 1074
integer height = 1644
string dataobject = "d_22012_L01"
boolean hscrollbar = true
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_flag
long i

	

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

is_mat_cd = This.GetItemString(row, 'mat_cd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_mat_cd) THEN return

il_rows = dw_body.retrieve(is_yymmdd, is_mat_cd)
for i = 1 to il_rows
	ls_flag = dw_body.GetItemString(i,"flag")
	if ls_flag = "New" then	dw_body.SetItemStatus(i, 0, Primary!, New!)		
next



Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
dw_body.setfocus()
end event

type dw_body from w_com020_e`dw_body within w_22012_e
integer x = 1120
integer y = 368
integer width = 2482
integer height = 1644
string dataobject = "d_22012_d01"
end type

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

CHOOSE CASE dwo.name
	CASE "colunm1" 
    IF data = 'A' THEN
	      /*action*/
    END IF
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type st_1 from w_com020_e`st_1 within w_22012_e
integer x = 1102
integer y = 368
integer height = 1644
end type

type dw_print from w_com020_e`dw_print within w_22012_e
integer x = 128
integer y = 376
string dataobject = "d_22012_r01"
end type

