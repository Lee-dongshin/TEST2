$PBExportHeader$w_43010_d.srw
$PBExportComments$일자별매장수불내역
forward
global type w_43010_d from w_com010_d
end type
end forward

global type w_43010_d from w_com010_d
integer width = 3675
integer height = 2252
string title = "일자별매장입고판매재고"
end type
global w_43010_d w_43010_d

type variables
DataWindowChild idw_brand,  idw_year,idw_season, idw_shop_type
string is_brand, is_frm_yymmdd, is_to_yymmdd, is_shop_cd, is_shop_type, is_year, is_season

end variables

on w_43010_d.create
call super::create
end on

on w_43010_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm, ls_shop_nm, ls_where
DataStore  lds_Source
Boolean    lb_check 

CHOOSE CASE as_column
		CASE "shop_cd"	
			is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_head.SetItem(al_row, "shop_nm", "")
					Return 0
				End If
				Choose Case is_brand
					Case 'J'
						If (LeftA(as_data, 1) = 'N' or LeftA(as_data, 1) = 'J') and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
							dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
							RETURN 0
						End If
					Case 'Y'
						If (LeftA(as_data, 1) = 'O' or LeftA(as_data, 1) = 'Y') and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
							dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
							RETURN 0
						END IF 
					Case Else
						If LeftA(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
							dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
							RETURN 0
						END IF 
				End Choose
				
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
				gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' "
			ELSE
				gst_cd.Item_where = ""
			END IF

			Choose Case is_brand
				Case 'J'
					ls_where = " AND BRAND IN ('N', 'J') "
				Case 'Y'
					ls_where = " AND BRAND IN ('O', 'Y') "
				Case Else
					ls_where = " AND BRAND = '" + is_brand + "' "
			End Choose

			gst_cd.default_where = gst_cd.default_where + ls_where
			
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
				dw_head.SetColumn("shop_type")
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



is_frm_yymmdd = dw_head.GetItemString(1, "frm_yymmdd")
if IsNull(is_frm_yymmdd) or Trim(is_frm_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_yymmdd")
   return false
end if

is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
//string ls_option
//
//if rb_1.checked = true then 
//	ls_option = "S"
//else if 	rb_2.checked = true then 
//	ls_option = "C"
//else 
//	ls_option = 'X'
//end if	

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_43010_d01 'n','20011201' , '20011215' , 'ng0006', '1' ,'%' ,'%'

il_rows = dw_body.retrieve( is_brand, is_frm_yymmdd, is_to_yymmdd, is_shop_cd, is_shop_type, is_year, is_season)
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

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_yymmdd",string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "to_yymmdd",string(ld_datetime,"yyyymmdd"))

end event

event ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm, ls_between


ls_shop_nm = is_shop_cd + ' ' + dw_head.getitemstring(1, "shop_nm")
ls_between = String(is_frm_yymmdd, '@@@@/@@/@@') + " ~~ " + String(is_to_yymmdd, '@@@@/@@/@@')
IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
				"t_user_id.Text = '" + gs_user_id + "'" + &
				"t_datetime.Text = '" + ls_datetime + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "' " + &
				"t_year.Text = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "' " + &					
				"t_between.Text = '" + ls_between + "' "   + &
				"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "' " +&
				"t_shop_cd.Text = '" + ls_shop_nm+ "' "   + &
				"t_shop_type.Text = '" + idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "' " 

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43010_d","0")
end event

type cb_close from w_com010_d`cb_close within w_43010_d
end type

type cb_delete from w_com010_d`cb_delete within w_43010_d
end type

type cb_insert from w_com010_d`cb_insert within w_43010_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43010_d
end type

type cb_update from w_com010_d`cb_update within w_43010_d
end type

type cb_print from w_com010_d`cb_print within w_43010_d
end type

type cb_preview from w_com010_d`cb_preview within w_43010_d
end type

type gb_button from w_com010_d`gb_button within w_43010_d
end type

type cb_excel from w_com010_d`cb_excel within w_43010_d
end type

type dw_head from w_com010_d`dw_head within w_43010_d
integer y = 152
integer height = 300
string dataobject = "d_43010_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
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

This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')
 
// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if
end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name

   CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
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

type ln_1 from w_com010_d`ln_1 within w_43010_d
integer beginx = 5
integer beginy = 452
integer endx = 3625
integer endy = 452
end type

type ln_2 from w_com010_d`ln_2 within w_43010_d
integer beginy = 456
integer endy = 456
end type

type dw_body from w_com010_d`dw_body within w_43010_d
integer y = 464
integer height = 1540
string dataobject = "d_43010_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_43010_d
integer x = 2450
integer y = 1372
string dataobject = "d_43010_r01"
end type

