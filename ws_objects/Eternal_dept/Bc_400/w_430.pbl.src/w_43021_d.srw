$PBExportHeader$w_43021_d.srw
$PBExportComments$창고부진재고현황
forward
global type w_43021_d from w_com010_d
end type
end forward

global type w_43021_d from w_com010_d
integer width = 3675
integer height = 2272
end type
global w_43021_d w_43021_d

type variables
STRING   is_brand, is_year, is_season, is_house_cd, is_yymmdd, is_dep_seq, is_disc_seq, is_except_seq, is_opt_view
DataWindowChild  idw_brand, idw_season, idw_dep_seq, idw_house_cd,idw_disc_seq, idw_except_seq
end variables

on w_43021_d.create
call super::create
end on

on w_43021_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                          */	
/* 작성일      :                                                   */	
/* 수정일      :                                                   */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				If IsNull(as_data) or Trim(as_data) = "" Then
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
					
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("dep_seq")
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                        */	
/* 작성일      :                                                   */	
/* 수정일      :                                                   */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_opt_view = "A" then
	il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_house_cd,is_yymmdd,is_dep_seq, is_opt_view)
elseif is_opt_view = "B" then	
	il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_house_cd,is_yymmdd,is_disc_seq, is_opt_view)
else
	il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_house_cd,is_yymmdd,is_except_seq, is_opt_view)
end if	

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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                             */	
/* 작성일      :                                                   */	
/* 수정일      :                                                  */
/* event       :                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
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

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if
is_yymmdd = string(dw_head.getitemdatetime(1, "yymmdd"), "yyyymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if

is_dep_seq = dw_head.GetItemString(1, "dep_seq")
if IsNull(is_dep_seq) or Trim(is_dep_seq) = "" then
	is_dep_seq = "%"
//   MessageBox(ls_title,"부진차수를 입력하십시요!")
//  dw_head.SetFocus()
//   dw_head.SetColumn("dep_seq")
//   return false
end if

is_disc_seq = dw_head.GetItemString(1, "disc_seq")
if IsNull(is_disc_seq) or Trim(is_disc_seq) = "" then
	is_disc_seq = "%"
//   MessageBox(ls_title,"품목할인차수를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("disc_seq")
//   return false
end if

is_except_seq = dw_head.GetItemString(1, "except_seq")
if IsNull(is_except_seq) or Trim(is_except_seq) = "" then
	is_except_seq = "%"
//   MessageBox(ls_title,"이관제외차수를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("except_seq")
//   return false
end if

is_opt_view = dw_head.GetItemString(1, "opt_view")

return true

end event

event open;call super::open;is_brand = dw_head.GetItemString(1, "brand")
is_year  = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")

idw_dep_seq.Retrieve(is_brand, is_year, is_season)
idw_dep_seq.InsertRow(1)
idw_dep_seq.SetItem(1, "dep_seq", '%')
idw_dep_seq.SetItem(1, "dep_ymd", '전체')

idw_disc_seq.Retrieve(is_brand, is_year, is_season)
idw_disc_seq.InsertRow(1)
idw_disc_seq.SetItem(1, "dep_seq", '%')
idw_disc_seq.SetItem(1, "dep_ymd", '전체')

idw_except_seq.Retrieve(is_brand, is_year, is_season)
idw_except_seq.InsertRow(1)
idw_except_seq.SetItem(1, "dep_seq", '%')
idw_except_seq.SetItem(1, "dep_ymd", '전체')	

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                */	
/* 작성일      :                                                   */	
/* 수정일      :                                                   */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_opt_view = "A" then
 ls_title = "창고 부진상품 재고현황"
elseif is_opt_view = "B" then
 ls_title = "창고 품목할인상품 재고현황"
else
 ls_title = "창고 이관제외상품 재고현황"
end if

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify  = "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
				 "t_yymmdd.Text = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
				 "t_dep_seq.Text = '" + idw_dep_seq.GetItemString(idw_dep_seq.GetRow(), "dep_display") + "'"  + &
				 "t_title.Text = '" + ls_title  + "'"  
dw_print.Modify(ls_modify)




end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43021_d","0")
end event

type cb_close from w_com010_d`cb_close within w_43021_d
end type

type cb_delete from w_com010_d`cb_delete within w_43021_d
end type

type cb_insert from w_com010_d`cb_insert within w_43021_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43021_d
end type

type cb_update from w_com010_d`cb_update within w_43021_d
end type

type cb_print from w_com010_d`cb_print within w_43021_d
end type

type cb_preview from w_com010_d`cb_preview within w_43021_d
end type

type gb_button from w_com010_d`gb_button within w_43021_d
end type

type cb_excel from w_com010_d`cb_excel within w_43021_d
end type

type dw_head from w_com010_d`dw_head within w_43021_d
integer x = 18
integer y = 168
integer width = 3584
integer height = 248
string dataobject = "d_43021_h01"
boolean livescroll = false
end type

event dw_head::constructor;/*===========================================================================*/
/* 작성자      :                                 */	
/* 작성일      :                                                  */	
/* 수정일      :                                                  */
/* event       : constructor(dw_head)                                        */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)

This.GetChild("dep_seq", idw_dep_seq)
idw_dep_seq.SetTRansObject(SQLCA)
idw_dep_seq.InsertRow(1)
idw_dep_seq.Setitem(1, "inter_cd", "%")
idw_dep_seq.Setitem(1, "inter_nm", "전체")

This.GetChild("disc_seq", idw_disc_seq)
idw_disc_seq.SetTRansObject(SQLCA)
idw_disc_seq.InsertRow(1)
idw_disc_seq.Setitem(1, "inter_cd", "%")
idw_disc_seq.Setitem(1, "inter_nm", "전체")

This.GetChild("except_seq", idw_except_seq)
idw_except_seq.SetTRansObject(SQLCA)
idw_except_seq.InsertRow(1)
idw_except_seq.Setitem(1, "inter_cd", "%")
idw_except_seq.Setitem(1, "inter_nm", "전체")

This.GetChild("house_cd", idw_house_cd )
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('%')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if




end event

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      :                                 */	
/* 작성일      :                                                */	
/* 수정일      :                                                  */
/* event       : itemchanged(dw_head)                                        */
/*===========================================================================*/

CHOOSE CASE dwo.name

CASE "brand", "year"		
		//라빠레트 시즌적용
		dw_head.accepttext()
		is_brand = dw_head.getitemstring(1,'brand')
		is_year = dw_head.getitemstring(1,'year')
		
		this.getchild("season",idw_season)
		idw_season.settransobject(sqlca)
		idw_season.retrieve('003', is_brand, is_year)
		
CASE "brand"
		This.SetItem(1, "dep_seq", "")
		is_brand = data
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_except_seq.Retrieve(is_brand, is_year, is_season)
		idw_except_seq.InsertRow(1)
		idw_except_seq.SetItem(1, "dep_seq", '%')
		idw_except_seq.SetItem(1, "dep_ymd", '전체')		
		
		
	CASE "year"
		This.SetItem(1, "dep_seq", "")
		is_year = data
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_except_seq.Retrieve(is_brand, is_year, is_season)
		idw_except_seq.InsertRow(1)
		idw_except_seq.SetItem(1, "dep_seq", '%')
		idw_except_seq.SetItem(1, "dep_ymd", '전체')						
		
	CASE "season"
		This.SetItem(1, "dep_seq", "")
		is_season = data
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_except_seq.Retrieve(is_brand, is_year, is_season)
		idw_except_seq.InsertRow(1)
		idw_except_seq.SetItem(1, "dep_seq", '%')
		idw_except_seq.SetItem(1, "dep_ymd", '전체')				
		
		
	CASE "shop_cd"      //  Popup 검색창이 존재하는 항목 
		  IF  ib_itemchanged THEN RETURN 1
		      return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE 
		 
end event

type ln_1 from w_com010_d`ln_1 within w_43021_d
end type

type ln_2 from w_com010_d`ln_2 within w_43021_d
end type

type dw_body from w_com010_d`dw_body within w_43021_d
string dataobject = "d_43021_d01"
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_43021_d
integer x = 123
integer y = 660
string dataobject = "d_43021_r01"
end type

