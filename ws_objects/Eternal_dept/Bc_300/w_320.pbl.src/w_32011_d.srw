$PBExportHeader$w_32011_d.srw
$PBExportComments$일자별 입고현황
forward
global type w_32011_d from w_com010_d
end type
end forward

global type w_32011_d from w_com010_d
integer width = 3675
integer height = 2280
end type
global w_32011_d w_32011_d

type variables
DataWindowChild idw_child, idw_brand, idw_year, idw_season, idw_make_type, idw_country_cd, idw_house_cd

String is_brand, is_year, is_season = '%', is_cust_cd = '%', is_style, is_make_type = '%', is_country_cd = '%', is_fr_ymd, is_to_ymd, is_house_cd, is_opt
end variables

on w_32011_d.create
call super::create
end on

on w_32011_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.11                                                  */	
/* 수정일      : 2001.12.11                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = Trim(dw_head.GetItemString(1, "year"))

is_season = Trim(dw_head.GetItemString(1, "season"))
is_cust_cd = Trim(dw_head.GetItemString(1, "cust_cd"))
is_make_type = Trim(dw_head.GetItemString(1, "make_type"))
is_country_cd = Trim(dw_head.GetItemString(1, "country_cd"))
is_fr_ymd = Trim(dw_head.GetItemString(1, "fr_ymd"))
is_to_ymd = Trim(dw_head.GetItemString(1, "to_ymd"))

is_style = Trim(dw_head.GetItemString(1, "style"))
is_house_cd = Trim(dw_head.GetItemString(1, "house_cd"))
is_opt = Trim(dw_head.GetItemString(1, "opt"))

return true
end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.11                                                  */	
/* 수정일      : 2001.12.11                                                  */
/*===========================================================================*/
string ls_style = '%', ls_chno = '%'
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_style, ls_chno, is_fr_ymd, is_to_ymd, is_cust_cd, is_country_cd, is_make_type, is_house_cd)

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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime
string ls_brand, ls_year, ls_season, ls_cust_cd, ls_fr_ymd, ls_to_ymd, ls_make_type, ls_country_cd

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_brand = is_brand
ls_year = is_year
ls_season = is_season
ls_cust_cd = is_cust_cd
ls_fr_ymd = is_fr_ymd
ls_to_ymd = is_to_ymd
ls_make_type = is_make_type
ls_country_cd = is_country_cd


if isnull(ls_brand) then ls_brand = ' '
if isnull(ls_year) then ls_year = ' '
if isnull(ls_season) then ls_season = ' '
if isnull(ls_make_type) then ls_make_type = ' '
if isnull(ls_country_cd) then ls_country_cd = ' '
if isnull(ls_fr_ymd) then ls_fr_ymd = ' '
if isnull(ls_to_ymd) then ls_to_ymd = ' '



ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
             "t_brand.Text = '" + ls_brand + "'" + &
				 "t_year.Text = '" + ls_year + "'" + &
				 "t_season.Text = '" + ls_season + "'" + &
				 "t_fr_ymd.Text = '" + ls_fr_ymd + "'" + &
				 "t_to_ymd.Text = '" + ls_to_ymd + "'" + &
				 "t_make_type.Text = '" + ls_make_type + "'" + &
				 "t_country_cd.Text = '" + ls_country_cd + "'"

				 
dw_print.Modify(ls_modify)

dw_print.object.t_house_cd.text = idw_house_cd.getitemstring(idw_house_cd.getrow(),"shop_display")




end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.07                                                  */	
/* 수정일      : 2001.12.07                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"							// 생산처 코드
	   is_brand = Trim(dw_head.GetItemString(1, "brand"))
			
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					dw_head.SetItem(al_row, "cust_nm", "")
					RETURN 0
				End If
				
				Choose Case is_brand
					Case 'O','Y','A'
						IF gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_part_nm)
							RETURN 0
						END IF
						
					Case Else
						IF gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_part_nm)
							RETURN 0
						END IF
						
				End Choose
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재/생산 거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911" 
			Choose Case is_brand
				Case 'O','Y','A'
					gst_cd.default_where   = " WHERE BRAND IN ('O', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '5000' and '8999' "
				Case Else
					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '5000' and '8999' " 					 
			End Choose

			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " CUSTCODE LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("make_type")
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_32011_d","0")
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로




//dw_body.ShareData(dw_print)
il_rows = dw_print.retrieve(is_brand, is_year, is_season, is_style, '%', is_fr_ymd, is_to_ymd, is_cust_cd, is_country_cd, is_make_type, is_house_cd)
dw_print.inv_printpreview.of_SetZoom()



end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_body.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com010_d`cb_close within w_32011_d
end type

type cb_delete from w_com010_d`cb_delete within w_32011_d
end type

type cb_insert from w_com010_d`cb_insert within w_32011_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_32011_d
end type

type cb_update from w_com010_d`cb_update within w_32011_d
end type

type cb_print from w_com010_d`cb_print within w_32011_d
end type

type cb_preview from w_com010_d`cb_preview within w_32011_d
end type

type gb_button from w_com010_d`gb_button within w_32011_d
end type

type cb_excel from w_com010_d`cb_excel within w_32011_d
end type

type dw_head from w_com010_d`dw_head within w_32011_d
integer x = 32
integer width = 3657
integer height = 264
string dataobject = "D_32011_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

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

This.GetChild("make_type", idw_make_type)
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.InsertRow(1)
idw_make_type.SetItem(1, "inter_cd", '%')
idw_make_type.SetItem(1, "inter_nm", '전체')

This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')
idw_country_cd.InsertRow(1)
idw_country_cd.SetItem(1, "inter_cd", '%')
idw_country_cd.SetItem(1, "inter_nm", '전체')

This.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('A')
idw_house_cd.InsertRow(1)
idw_house_cd.SetItem(1, "shop_cd", '%')
idw_house_cd.SetItem(1, "shop_snm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;choose case dwo.name 
	case "opt"
		
		if data = "1" then
			dw_body.dataobject = "d_32011_d01"
			dw_print.dataobject = "d_32011_r01"
		elseif data = "2" then
			dw_body.dataobject = "d_32011_d02"
			dw_print.dataobject = "d_32011_r02"
		elseif data = "3" then
			dw_body.dataobject = "d_32011_d03"
			dw_print.dataobject = "d_32011_r03"
		elseif data = "4" then
			dw_body.dataobject = "d_32011_d04"
			dw_print.dataobject = "d_32011_r04"

		end if
		dw_body.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)


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
		
end choose

end event

type ln_1 from w_com010_d`ln_1 within w_32011_d
end type

type ln_2 from w_com010_d`ln_2 within w_32011_d
end type

type dw_body from w_com010_d`dw_body within w_32011_d
integer y = 464
integer height = 1576
string dataobject = "D_32011_d03"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("make_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('030')

end event

type dw_print from w_com010_d`dw_print within w_32011_d
integer x = 137
integer y = 792
string dataobject = "D_32011_R03"
end type

event dw_print::constructor;call super::constructor;		This.GetChild("make_type", idw_child)
		idw_child.SetTransObject(SQLCA)
		idw_child.Retrieve('030')
end event

