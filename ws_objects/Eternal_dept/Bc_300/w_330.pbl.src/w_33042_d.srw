$PBExportHeader$w_33042_d.srw
$PBExportComments$업체별생산임가공조회
forward
global type w_33042_d from w_com010_d
end type
end forward

global type w_33042_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_33042_d w_33042_d

type variables
string is_brand, is_frm_ymd, is_to_ymd, is_year, is_season, is_cust_cd
DataWindowChild idw_brand, idw_season
end variables

on w_33042_d.create
call super::create
end on

on w_33042_d.destroy
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

is_frm_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"조회기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if


is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"조회기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
  is_year = "%"
end if


is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품년도를 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_cust_cd = dw_head.GetItemString(1, "cust_cd")
if IsNull(is_cust_cd) or Trim(is_cust_cd) = "" then
	is_cust_cd = "%"
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//@brand		varchar(1),
//@year   	varchar(4),
//@season    	varchar(1),
//@frm_ymd	varchar(8),
//@to_ymd		varchar(8),
//@cust_cd		varchar(6)	
//

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_frm_ymd, is_to_ymd, is_cust_cd)
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;
string     ls_cust_cd, ls_cust_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"							// 거래처 코드
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
					dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF
				
			END IF   
			
			   gst_cd.ai_div          = ai_div	// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "거래처 코드 검색" 
				gst_cd.datawindow_nm   = "d_com911" 
				gst_cd.default_where   = " WHERE Cust_Code Between '5000' And '9999' "
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
					dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"Cust_sName"))
					/* 다음컬럼으로 이동 */
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

event ue_preview();this.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로

dw_print.retrieve(is_brand, is_year, is_season, is_frm_ymd, is_to_ymd, is_cust_cd)
dw_print.inv_printpreview.of_SetZoom()
//il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_frm_ymd, is_to_ymd, is_cust_cd)
end event

event ue_print();This.Trigger Event ue_title()
dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로

dw_print.retrieve(is_brand, is_year, is_season, is_frm_ymd, is_to_ymd, is_cust_cd)
IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com010_d`cb_close within w_33042_d
end type

type cb_delete from w_com010_d`cb_delete within w_33042_d
end type

type cb_insert from w_com010_d`cb_insert within w_33042_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_33042_d
end type

type cb_update from w_com010_d`cb_update within w_33042_d
end type

type cb_print from w_com010_d`cb_print within w_33042_d
end type

type cb_preview from w_com010_d`cb_preview within w_33042_d
end type

type gb_button from w_com010_d`gb_button within w_33042_d
end type

type cb_excel from w_com010_d`cb_excel within w_33042_d
end type

type dw_head from w_com010_d`dw_head within w_33042_d
string dataobject = "d_33042_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

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

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
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
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")
			
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_33042_d
end type

type ln_2 from w_com010_d`ln_2 within w_33042_d
end type

type dw_body from w_com010_d`dw_body within w_33042_d
string dataobject = "d_33042_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_33042_d
string dataobject = "d_33042_r01"
end type

