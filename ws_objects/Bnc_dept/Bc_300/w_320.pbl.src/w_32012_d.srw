$PBExportHeader$w_32012_d.srw
$PBExportComments$sub가공현황
forward
global type w_32012_d from w_com010_d
end type
end forward

global type w_32012_d from w_com010_d
end type
global w_32012_d w_32012_d

type variables
string is_brand, is_year, is_season, is_cust_cd, is_fr_ymd, is_to_ymd, is_make_type, is_country_cd
string is_style, is_chno
datawindowchild idw_brand, idw_season, idw_make_type, idw_country_cd, idw_child

end variables

on w_32012_d.create
call super::create
end on

on w_32012_d.destroy
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
is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_cust_cd = dw_head.GetItemString(1, "cust_cd")
is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
is_to_ymd = dw_head.GetItemString(1, "to_ymd")
is_make_type = dw_head.GetItemString(1, "make_type")
is_country_cd = dw_head.GetItemString(1, "country_cd")
is_style = dw_head.GetItemString(1, "style")
is_chno = dw_head.GetItemString(1, "chno")


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


if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.11                                                  */	
/* 수정일      : 2001.12.11                                                  */
/*===========================================================================*/
string ls_style = '%', ls_chno = '%'
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN



il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_style, is_chno, is_fr_ymd, is_to_ymd, is_cust_cd, is_country_cd, is_make_type)

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

event ue_title();/*===========================================================================*/
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


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
String     ls_mat_nm, ls_cust_nm, ls_emp_nm 
Boolean    lb_check 
DataStore  lds_Source 


is_brand = dw_head.getitemstring(1,"brand")

CHOOSE CASE as_column

	CASE "cust_cd"				
			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then 
					return  0					
				elseIF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
					dw_head.Setitem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			gst_cd.default_where   = "Where brand     = case when '" + is_brand + "' = 'J' then 'N' "      + &
																	" when '" + is_brand + "' = 'Y' then 'O' "      + &
																	" else '" + is_brand + "' end "      + &
			                         "  and cust_code between '7000' and '8999'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (custcode LIKE '%" + as_data + "%' or cust_sname like '%" + as_data + "%')"
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
				dw_head.SetItem(al_row, "cust_cd",    lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				dw_head.TriggerEvent(Editchanged!)
				dw_head.SetColumn("st_ymd")
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_32012_d","0")
end event

type cb_close from w_com010_d`cb_close within w_32012_d
end type

type cb_delete from w_com010_d`cb_delete within w_32012_d
end type

type cb_insert from w_com010_d`cb_insert within w_32012_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_32012_d
end type

type cb_update from w_com010_d`cb_update within w_32012_d
end type

type cb_print from w_com010_d`cb_print within w_32012_d
end type

type cb_preview from w_com010_d`cb_preview within w_32012_d
end type

type gb_button from w_com010_d`gb_button within w_32012_d
end type

type cb_excel from w_com010_d`cb_excel within w_32012_d
end type

type dw_head from w_com010_d`dw_head within w_32012_d
string dataobject = "d_32012_h01"
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

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE


choose case dwo.name 
	case "opt"
		if data = "1" then
			dw_print.dataobject = "d_32012_r02"
		else
			dw_print.dataobject = "d_32012_r01"
		end if
		dw_print.SetTransObject(SQLCA)
		
		dw_print.GetChild("make_type", idw_child)
		idw_child.SetTransObject(SQLCA)
		idw_child.Retrieve('030')

		dw_print.GetChild("sub_job", idw_child)
		idw_child.SetTransObject(SQLCA)
		idw_child.Retrieve('310')
		
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

event dw_head::editchanged;call super::editchanged;choose case dwo.name 
	case "cust_cd"
		if LenA(data) = 1 then	this.setitem(1,"brand",LeftA(data,1))
end choose

			
end event

type ln_1 from w_com010_d`ln_1 within w_32012_d
end type

type ln_2 from w_com010_d`ln_2 within w_32012_d
end type

type dw_body from w_com010_d`dw_body within w_32012_d
string dataobject = "d_32012_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;datawindowchild ldw_child


/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(False)

//This.SetRowFocusIndicator(Hand!)



This.GetChild("sub_job", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('310')


This.GetChild("make_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('030')




end event

type dw_print from w_com010_d`dw_print within w_32012_d
integer x = 27
integer y = 544
string dataobject = "d_32012_r01"
end type

event dw_print::constructor;call super::constructor;datawindowchild ldw_child

This.GetChild("sub_job", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('310')


This.GetChild("make_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('030')

end event

