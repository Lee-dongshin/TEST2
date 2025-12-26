$PBExportHeader$w_56014_e.srw
$PBExportComments$스타일별 수주내역 등록
forward
global type w_56014_e from w_com010_e
end type
end forward

global type w_56014_e from w_com010_e
integer width = 3675
integer height = 2276
end type
global w_56014_e w_56014_e

type variables
string is_shop_cd, is_brand, is_year, is_season

datawindowchild idw_brand, idw_season, idw_money_type

end variables

on w_56014_e.create
call super::create
end on

on w_56014_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_style, ls_shop_nm, ls_style_to, ls_brand, ls_year, ls_season
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style"				
		   ls_style = as_data
			ls_brand = dw_head.getitemstring(1,"brand")
			ls_year = dw_head.getitemstring(1,"year")
			ls_season = dw_head.getitemstring(1,"season")
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = ""
												
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "brand = '" + ls_brand + "' and year  like '%" + ls_year + "%' and season like '%" + ls_season + "%' and style LIKE  '%" + ls_style + "%' "
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))				
				dw_body.SetItem(al_row, "brand", lds_Source.GetItemString(1,"brand"))				
				dw_body.SetItem(al_row, "year", lds_Source.GetItemString(1,"year"))				
				dw_body.SetItem(al_row, "season", lds_Source.GetItemString(1,"season"))				

				

				ls_style = lds_Source.GetItemString(1,"style")

				select left(:ls_style,2) + right(cast(cast(substring(:ls_style,3,1) as int)+1 as varchar),1) + right(:ls_style,5)
					into :ls_style_to
				from dual;


				dw_body.SetItem(al_row, "style_to", ls_style_to)	
				
			 				
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("money_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' and exists (select top 1 * from tb_91110_m (nolock) " + &
												" where grp_gubn1 = '20' and country_cd <> '00' and cust_cd1 is not null) "
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
/* 작성자      : (주)지우정보 ()                                      */	
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
		dw_body.setitem(i,"shop_cd", is_shop_cd)
      dw_body.Setitem(i,"reg_id", gs_user_id)
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

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"거래처 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")


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

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_shop_cd, is_brand, is_year, is_season)
IF il_rows > 0 THEN
   dw_body.SetFocus()
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

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)


dw_print.object.t_brand.text = is_brand + ' ' + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_year.text = is_year
dw_print.object.t_season.text = is_season + ' ' + idw_season.getitemstring(idw_season.getrow(),"inter_nm")

dw_print.object.t_shop_cd.text = is_shop_cd
dw_print.object.t_shop_nm.text = dw_head.getitemstring(1,"shop_nm")
end event

type cb_close from w_com010_e`cb_close within w_56014_e
end type

type cb_delete from w_com010_e`cb_delete within w_56014_e
end type

type cb_insert from w_com010_e`cb_insert within w_56014_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56014_e
end type

type cb_update from w_com010_e`cb_update within w_56014_e
end type

type cb_print from w_com010_e`cb_print within w_56014_e
end type

type cb_preview from w_com010_e`cb_preview within w_56014_e
end type

type gb_button from w_com010_e`gb_button within w_56014_e
end type

type cb_excel from w_com010_e`cb_excel within w_56014_e
end type

type dw_head from w_com010_e`dw_head within w_56014_e
integer height = 144
string dataobject = "d_56014_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
	  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")				
END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')
end event

type ln_1 from w_com010_e`ln_1 within w_56014_e
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_e`ln_2 within w_56014_e
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_e`dw_body within w_56014_e
integer y = 368
integer height = 1672
string dataobject = "d_56014_d01"
end type

event dw_body::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

END CHOOSE

end event

event dw_body::constructor;call super::constructor;This.GetChild("money_type", idw_money_type)
idw_money_type.SetTransObject(SQLCA)
idw_money_type.Retrieve('013')
end event

type dw_print from w_com010_e`dw_print within w_56014_e
integer x = 151
integer y = 668
string dataobject = "d_56014_r01"
end type

event dw_print::constructor;call super::constructor;This.GetChild("money_type", idw_money_type)
idw_money_type.SetTransObject(SQLCA)
idw_money_type.Retrieve('013')
end event

