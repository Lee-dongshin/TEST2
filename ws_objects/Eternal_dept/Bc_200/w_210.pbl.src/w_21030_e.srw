$PBExportHeader$w_21030_e.srw
$PBExportComments$부자재발주관리
forward
global type w_21030_e from w_com010_e
end type
end forward

global type w_21030_e from w_com010_e
integer width = 3675
integer height = 2272
end type
global w_21030_e w_21030_e

type variables
datawindowchild idw_brand, idw_year, idw_season
string is_brand, is_fr_ymd, is_to_ymd, is_ord_origin, is_cust_cd, is_mat_cd, is_year, is_season, is_gubn, is_view
string is_make_cust
end variables

on w_21030_e.create
call super::create
end on

on w_21030_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_ord_origin = dw_head.GetItemString(1, "ord_origin")
if IsNull(is_ord_origin) or Trim(is_ord_origin) = "" then
  is_ord_origin = "%"
end if

is_cust_cd = dw_head.GetItemString(1, "cust_cd")
if IsNull(is_cust_cd) or Trim(is_cust_cd) = "" then
  is_cust_cd = "%"
end if

is_make_cust = dw_head.GetItemString(1, "make_cust")
if IsNull(is_make_cust) or Trim(is_make_cust) = "" then
  is_make_cust = "%"
end if

is_mat_cd = dw_head.GetItemString(1, "mat_cd")
if IsNull(is_mat_cd) or Trim(is_mat_cd) = "" then
  is_mat_cd = "%"
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_gubn = dw_head.GetItemString(1, "gubn")
if IsNull(is_gubn) or Trim(is_gubn) = "" then
   MessageBox(ls_title,"조회구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubn")
   return false
end if

is_view = dw_head.GetItemString(1, "view")

return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_claim_cust_nm ,ls_ord_emp, ls_mat_cd, ls_style ,ls_chno, ls_smat_confirm
Boolean    lb_check 
DataStore  lds_Source

is_brand = dw_head.getitemstring(1,'brand')
CHOOSE CASE as_column
	CASE "cust_cd"				
		
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				elseIF gf_cust_nm(as_data, 'S', ls_claim_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_claim_cust_nm)
					RETURN 0
				END IF 
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처 코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 

				gst_cd.default_where   = "Where change_gubn = '00'"      + &
												 "  and cust_code between '5000' and '9999'"

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%')" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_name"))
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source

	CASE "make_cust"				
		
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				elseIF gf_cust_nm(as_data, 'S', ls_claim_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "make_nm", ls_claim_cust_nm)
					RETURN 0
				END IF 
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처 코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 

				gst_cd.default_where   = "Where change_gubn = '00'"      + &
												 "  and cust_code between '5000' and '9999'"

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%')" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetItem(al_row, "make_cust", lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "make_nm", lds_Source.GetItemString(1,"cust_name"))
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "ord_origin"
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
				gst_cd.Item_where = " style like '" + LeftA(as_data,8) +"%'"
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
				dw_head.SetItem(al_row, "ord_origin", lds_Source.GetItemString(1,"style")+lds_Source.GetItemString(1,"chno"))

				/* 다음컬럼으로 이동 */
				dw_head.scrolltorow(1)
				dw_head.SetColumn("cust_cd")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source	
				

	CASE "mat_cd"
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				END IF 
			END IF

			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "부자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com913" 
			gst_cd.default_where   = "Where brand     = '" + is_brand + "'" 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " mat_cd like '" + as_data + "%'"
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
				dw_head.SetColumn("year")					
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

//	@brand		varchar(1),
//	@fr_ymd		varchar(8),
//	@to_ymd		varchar(8),
//	@ord_origin	varchar(10),	
//	@cust_cd	varchar(6),
//	@year		varchar(04),
//	@season		varchar(01),
//	@gubn		varchar(01)

if is_view = "Y" then 
	dw_body.dataobject = "d_21030_d02"
	dw_print.dataobject = "d_21030_r02"	
else	
	dw_body.dataobject = "d_21030_d01"	
	dw_print.dataobject = "d_21030_r01"		
end if	

dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_ord_origin, is_cust_cd, is_year, is_season, is_gubn, is_make_cust)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;dw_head.setitem(1,"year","%")
dw_head.setitem(1,"season","%")
dw_body.Object.DataWindow.HorizontalScrollSplit  = 677
end event

event type long ue_update();call super::ue_update;long i, ll_row_count
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

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
		 		 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_fr_ymd.Text = '" + is_fr_ymd + "'" + &
             "t_to_ymd.Text = '" + is_to_ymd + "'" 

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_e`cb_close within w_21030_e
end type

type cb_delete from w_com010_e`cb_delete within w_21030_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_21030_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_21030_e
end type

type cb_update from w_com010_e`cb_update within w_21030_e
end type

type cb_print from w_com010_e`cb_print within w_21030_e
end type

type cb_preview from w_com010_e`cb_preview within w_21030_e
end type

type gb_button from w_com010_e`gb_button within w_21030_e
end type

type cb_excel from w_com010_e`cb_excel within w_21030_e
end type

type dw_head from w_com010_e`dw_head within w_21030_e
integer height = 192
string dataobject = "d_21030_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

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

event dw_head::itemchanged;call super::itemchanged;int li_ret
string ls_brand, ls_year, ls_season

CHOOSE CASE dwo.name
	case "style","style_no","ord_origin","mat_cd"
		li_ret = gf_default_head_set(dwo.name,string(data), ls_brand, ls_year, ls_season)
		if li_ret = 1 then 
			this.setitem(1,"brand" ,ls_brand)
			this.setitem(1,"year"  ,ls_year)
			this.setitem(1,"season",ls_season)
		end if
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
		
	CASE "cust_cd"	,"make_cust"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
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

type ln_1 from w_com010_e`ln_1 within w_21030_e
integer beginy = 380
integer endy = 380
end type

type ln_2 from w_com010_e`ln_2 within w_21030_e
integer beginy = 384
integer endy = 384
end type

type dw_body from w_com010_e`dw_body within w_21030_e
integer y = 400
integer height = 1640
string dataobject = "d_21030_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_e`dw_print within w_21030_e
string dataobject = "d_21030_r01"
end type

