$PBExportHeader$w_41007_d.srw
$PBExportComments$업체별입고현황출력
forward
global type w_41007_d from w_com010_d
end type
end forward

global type w_41007_d from w_com010_d
end type
global w_41007_d w_41007_d

type variables
DataWindowChild idw_brand, idw_house_cd, idw_jup_gubn, idw_make_type,idw_year, idw_season, idw_item, idw_sojae
string is_brand, is_frm_date, is_to_date, is_house_cd, is_jup_gubn, is_make_type
string is_year, is_season, is_item, is_sojae, is_in_gubn, is_style, is_cust_cd, is_chi_gubn

end variables

on w_41007_d.create
call super::create
end on

on w_41007_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_in_date", string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "to_in_date",  string(ld_datetime,"yyyymmdd"))
dw_head.setitem(1, "in_gubn", "+")
dw_head.SetColumn("in_gubn")
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


is_frm_date = dw_head.GetItemString(1, "frm_in_date")
if IsNull(is_frm_date) or Trim(is_frm_date) = "" then
   MessageBox(ls_title,"입고기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_in_date")
   return false
end if

is_to_date = dw_head.GetItemString(1, "to_in_date")
if IsNull(is_to_date) or Trim(is_to_date) = "" then
   MessageBox(ls_title,"입고기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_in_date")
   return false
end if

is_house_cd = dw_head.GetItemString(1, "house")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house")
   return false
end if

is_in_gubn = dw_head.GetItemString(1, "in_gubn")
if IsNull(is_in_gubn) or Trim(is_in_gubn) = "" then
   MessageBox(ls_title,"입고구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("in_gubn")
   return false
end if

is_jup_gubn = dw_head.GetItemString(1, "jup_gubn")
if IsNull(is_jup_gubn) or Trim(is_jup_gubn) = "" then
   MessageBox(ls_title,"전표구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jup_gubn")
   return false
end if

is_cust_cd = dw_head.GetItemString(1, "cust_cd")
if IsNull(is_cust_cd) or Trim(is_cust_cd) = "" then
   MessageBox(ls_title,"생산업체를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("cust_cd")
   return false
end if

//is_make_type = dw_head.GetItemString(1, "prod_gubn")
//if IsNull(is_make_type) or Trim(is_make_type) = "" then
//   MessageBox(ls_title,"생산형태를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("prod_gubn")
//   return false
//end if

is_chi_gubn = dw_head.GetItemString(1, "chi_gubn")

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   is_year = '%'
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   is_season = '%'
end if



return true

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
		CASE "cust_cd"							// 거래처 코드
		
//			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
//				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
//					MessageBox("입력오류","등록되지 않은 거래처 코드입니다!")
//					RETURN 1
//				END IF
//			   If Right(as_data, 4) < '5000' or Right(as_data, 4) > '6999' Then
//					MessageBox("입력오류","생산처 코드가 아닙니다!")
//					RETURN 1
//				End If					
//				dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
//			ELSE		
// F1 key Or PopUp Button Click -> Call
			IF ai_div = 1 THEN 	
				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
				gst_cd.window_title    = "생산처 코드 검색" 
				gst_cd.datawindow_nm   = "d_com911" 
				gst_cd.default_where   = " WHERE Cust_Code Between '5000' And '9000' "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " CustCode LIKE ~'" + as_data + "%~' "
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
					dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"CustCode"))
					dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"Cust_Name"))
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("cust_cd")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
//			END IF
	
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

il_rows = dw_body.retrieve(is_brand, is_frm_date, is_to_date, is_house_cd, is_in_gubn, is_jup_gubn, is_cust_cd, is_year, is_season, "%",is_chi_gubn)
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_41007_d","0")
end event

type cb_close from w_com010_d`cb_close within w_41007_d
end type

type cb_delete from w_com010_d`cb_delete within w_41007_d
end type

type cb_insert from w_com010_d`cb_insert within w_41007_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_41007_d
end type

type cb_update from w_com010_d`cb_update within w_41007_d
end type

type cb_print from w_com010_d`cb_print within w_41007_d
end type

type cb_preview from w_com010_d`cb_preview within w_41007_d
end type

type gb_button from w_com010_d`gb_button within w_41007_d
end type

type cb_excel from w_com010_d`cb_excel within w_41007_d
end type

type dw_head from w_com010_d`dw_head within w_41007_d
integer x = 23
integer y = 180
integer width = 3538
integer height = 316
string dataobject = "d_41007_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("house", idw_house_cd )
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('%')

This.GetChild("jup_gubn", idw_jup_gubn )
idw_jup_gubn.SetTransObject(SQLCA)
idw_jup_gubn.Retrieve('024')

This.GetChild("prod_gubn", idw_make_type )
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')

//This.GetChild("item", idw_item )
//idw_item.SetTransObject(SQLCA)
//idw_item.Retrieve()
//
//This.GetChild("sojae", idw_sojae )
//idw_sojae.SetTransObject(SQLCA)
//idw_sojae.Retrieve('%')


this.setitem(1, "in_gubn", "+")
this.setitem(1, "jup_gubn", "I1")
this.setitem(1, "prod_gubn", "10")
this.setitem(1, "house", "000001")

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if



end event

event dw_head::itemchanged;call super::itemchanged;
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
//	CASE "style" 
//      IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
   
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		
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
			
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_41007_d
integer beginy = 532
integer endy = 532
end type

type ln_2 from w_com010_d`ln_2 within w_41007_d
integer beginy = 536
integer endy = 536
end type

type dw_body from w_com010_d`dw_body within w_41007_d
integer y = 568
integer width = 3575
integer height = 1472
string dataobject = "d_41007_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_41007_d
integer x = 2190
integer y = 1708
integer width = 1285
integer height = 656
string dataobject = "d_41007_r01"
end type

