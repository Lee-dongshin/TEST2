$PBExportHeader$w_43011_d.srw
$PBExportComments$일자별매장수불내역(행사용)
forward
global type w_43011_d from w_com010_d
end type
end forward

global type w_43011_d from w_com010_d
integer width = 3675
integer height = 2284
end type
global w_43011_d w_43011_d

type variables
DataWindowChild   idw_brand,  idw_shop_type, idw_season 
String is_brand,  is_shop_cd, is_shop_type , is_house_opt
String is_fr_ymd, is_to_ymd,  is_year,       is_season,  is_dotcom

end variables

on w_43011_d.create
call super::create
end on

on w_43011_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_head.Setitem(1, "shop_type", '4')
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.06.26                                                  */	
/* 수정일      : 2002.06.26                                                  */
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



is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장 형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_fr_ymd   = String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
//IF DaysAfter(dw_head.GetItemDate(1, "fr_ymd"), dw_head.GetItemDate(1, "to_ymd")) > 91 THEN
//   MessageBox(ls_title,"3개월 이상 조회할수 없습니다!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("to_ymd")
//   return false
//END IF	
is_to_ymd   = String(dw_head.GetItemDate(1, "to_ymd"), "yyyymmdd") 
IF is_fr_ymd > is_to_ymd THEN 
   MessageBox(ls_title,"시작일이 종료일 보다 큽니다 !")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
END IF	

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
	is_year = '%'
end if
is_season = dw_head.GetItemString(1, "season")

is_house_opt   = dw_head.GetItemString(1, "house_opt") 
IF  IsNull(is_house_opt) or Trim(is_house_opt) = "" then
   MessageBox(ls_title,"창고고구분 코드를 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_opt")
   return false
END IF	

is_dotcom = dw_head.GetItemString(1, "dotcom")

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.20                                                  */	
/* 수정일      : 2002.03.20                                                  */
/*===========================================================================*/
String     ls_brand, ls_shop_div, ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF 
			ls_brand    = dw_head.GetitemString(1, "brand")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand    = '" + ls_brand + "'" + &
			                         "  AND shop_div in ('G', 'K', 'X') " + &
											 "  AND Shop_Stat = '00' "
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.26                                                  */	
/* 수정일      : 2002.06.26                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_shop_cd, is_shop_type, is_fr_ymd, is_to_ymd, is_brand, is_year, is_season, is_house_opt, is_dotcom)
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
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.06.26                                                  */	
/* 수정일      : 2002.06.26                                                  */
/*===========================================================================*/
datetime ld_datetime
string   ls_modify, ls_datetime, ls_shop, ls_season 

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_shop   = dw_head.object.shop_nm[1] + "[" + is_shop_cd + "(" + is_shop_type + ")]"
IF is_year = '%' THEN
   ls_season = '전체년도 ' +  idw_season.GetitemString(idw_season.GetRow(), "inter_display") 
ELSE
	ls_season = is_year + '년도 ' +  idw_season.GetitemString(idw_season.GetRow(), "inter_display") 
END IF 

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + & 
				"t_shop.Text   = '매장 : " + ls_shop + "'" + &
				"t_ymd.Text    = '(" + String(is_fr_ymd + is_to_ymd, "@@@@/@@/@@ - @@@@/@@/@@") + ")'" + &
				"t_brand.Text  = '브랜드 : " + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_title.Text  = '(" + idw_shop_type.GetitemString(idw_shop_type.GetRow(), "inter_nm") + ")'" + &				
				"t_season.Text = '시즌 : " + ls_season + "'" 
				

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43011_d","0")
end event

type cb_close from w_com010_d`cb_close within w_43011_d
end type

type cb_delete from w_com010_d`cb_delete within w_43011_d
end type

type cb_insert from w_com010_d`cb_insert within w_43011_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43011_d
end type

type cb_update from w_com010_d`cb_update within w_43011_d
end type

type cb_print from w_com010_d`cb_print within w_43011_d
end type

type cb_preview from w_com010_d`cb_preview within w_43011_d
end type

type gb_button from w_com010_d`gb_button within w_43011_d
end type

type cb_excel from w_com010_d`cb_excel within w_43011_d
end type

type dw_head from w_com010_d`dw_head within w_43011_d
integer height = 248
string dataobject = "d_43011_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.SetFilter("inter_cd >= '3'")
idw_shop_type.Filter()

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

 
// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.26                                                  */	
/* 수정일      : 2002.06.26                                                  */
/*===========================================================================*/

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

type ln_1 from w_com010_d`ln_1 within w_43011_d
end type

type ln_2 from w_com010_d`ln_2 within w_43011_d
end type

type dw_body from w_com010_d`dw_body within w_43011_d
string dataobject = "d_43011_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_43011_d
string dataobject = "d_43011_r01"
end type

