$PBExportHeader$w_42013_d.srw
$PBExportComments$매장별 출고현황(item별)
forward
global type w_42013_d from w_com010_d
end type
end forward

global type w_42013_d from w_com010_d
integer width = 3680
integer height = 2280
end type
global w_42013_d w_42013_d

type variables
String is_brand, is_yymmdd_st, is_yymmdd_ed, is_shop_cd, is_shop_type, is_shop_div, is_sojae, is_year, is_season
DataWindowChild idw_brand, idw_shop_type, idw_shop_div, idw_season, idw_sojae, idw_year
end variables

forward prototypes
public function integer wf_shop_chk (string as_shop_cd, string as_flag, ref string as_shop_nm, ref string as_shop_div)
end prototypes

public function integer wf_shop_chk (string as_shop_cd, string as_flag, ref string as_shop_nm, ref string as_shop_div);String ls_shop_nm, ls_shop_snm

SELECT SHOP_NM, SHOP_SNM, SHOP_DIV
  INTO :ls_shop_nm, :ls_shop_snm, :as_shop_div
  FROM TB_91100_M
 WHERE SHOP_CD = :as_shop_cd
;

IF ISNULL(as_shop_nm) THEN RETURN 100

If as_flag = 'S' Then
	as_shop_nm = ls_shop_snm
Else
	as_shop_nm = ls_shop_nm
End If

RETURN sqlca.sqlcode 

end function

on w_42013_d.create
call super::create
end on

on w_42013_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.03.13                                                  */	
/* 수정일      : 2002.03.13                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd_st, is_yymmdd_ed, &
									is_shop_cd, is_shop_type, is_shop_div, &
									is_sojae, is_year, is_season)

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

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.03.13                                                  */	
/* 수정일      : 2002.03.13                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_sale_type, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

IF is_shop_cd = '%' THEN
	ls_shop_nm = '전체'
ELSE
	ls_shop_nm = dw_head.GetItemString(1, "shop_nm")
END IF

ls_modify =	"t_pg_id.Text     = '" + is_pgm_id    + "'" + &
            "t_user_id.Text   = '" + gs_user_id   + "'" + &
            "t_datetime.Text  = '" + ls_datetime  + "'" + &
            "t_yymmdd_st.Text = '" + String(is_yymmdd_st, '@@@@/@@/@@') + "'" + &
            "t_yymmdd_ed.Text = '" + String(is_yymmdd_ed, '@@@@/@@/@@')+ "'" + &
            "t_year.Text      = '" + is_year      + "'" + &
            "t_shop_cd.Text   = '" + is_shop_cd   + "'" + &
            "t_shop_nm.Text   = '" + ls_shop_nm   + "'" + &
            "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(),         "inter_display") + "'" + &
            "t_season.Text    = '" + idw_season.GetItemString(idw_season.GetRow(),       "inter_display") + "'" + &
            "t_shop_type.Text = '" + idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "'" + &
            "t_shop_div.Text  = '" + idw_shop_div.GetItemString(idw_shop_div.GetRow(),   "inter_display") + "'" + &
            "t_sojae.Text     = '" + idw_sojae.GetItemString(idw_sojae.GetRow(),         "sojae_display") + "'"

dw_print.Modify(ls_modify)

end event

event ue_keycheck;/*===========================================================================*/
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
IF IsNull(is_brand) OR is_brand = "" THEN
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF

is_yymmdd_st = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
IF IsNull(is_yymmdd_st) OR is_yymmdd_st = "" THEN
   MessageBox(ls_title,"일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   RETURN FALSE
END IF

is_yymmdd_ed = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
IF IsNull(is_yymmdd_ed) OR is_yymmdd_ed = "" THEN
   MessageBox(ls_title,"일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF

IF is_yymmdd_ed < is_yymmdd_st THEN
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF

is_year = Trim(dw_head.GetItemString(1, "year"))
IF IsNull(is_year) OR is_year = "" THEN
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   RETURN FALSE
END IF

is_season = Trim(dw_head.GetItemString(1, "season"))
IF IsNull(is_season) OR is_season = "" THEN
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   RETURN FALSE
END IF

is_sojae = Trim(dw_head.GetItemString(1, "sojae"))
IF IsNull(is_sojae) OR is_sojae = "" THEN
   MessageBox(ls_title,"소재 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   RETURN FALSE
END IF

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd"))
IF IsNull(is_shop_cd) OR is_shop_cd = "" THEN is_shop_cd = '%'

is_shop_type = Trim(dw_head.GetItemString(1, "shop_type"))
IF IsNull(is_shop_type) OR is_shop_type = "" THEN
   MessageBox(ls_title,"매장 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   RETURN FALSE
END IF

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
IF IsNull(is_shop_div) OR is_shop_div = "" THEN
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   RETURN FALSE
END IF

RETURN TRUE

end event

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.03.13                                                  */	
/* 수정일      : 2002.03.13                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_shop_div
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		is_brand = Trim(dw_head.GetItemString(1, "brand"))
		
		IF ai_div = 1 THEN 	
			IF IsNull(as_data) OR Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "shop_nm", "")
				RETURN 0
			END IF 
			IF LeftA(as_data, 1) = is_brand and wf_shop_chk(as_data, 'S', ls_shop_nm, ls_shop_div) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
				dw_head.SetItem(al_row, "shop_div", ls_shop_div)
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

		lds_Source = CREATE DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = TRUE
			lds_Source = Message.PowerObjectParm
			dw_head.SetRow(al_row)
			dw_head.SetColumn(as_column)
			dw_head.SetItem(al_row, "shop_cd",  lds_Source.GetItemString(1,"shop_cd") )
			dw_head.SetItem(al_row, "shop_nm",  lds_Source.GetItemString(1,"shop_snm"))
			dw_head.SetItem(al_row, "shop_div", lds_Source.GetItemString(1,"shop_div"))
			/* 다음컬럼으로 이동 */
			dw_head.SetColumn("shop_type")
			ib_itemchanged = FALSE 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		DESTROY lds_Source
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42013_d","0")
end event

type cb_close from w_com010_d`cb_close within w_42013_d
end type

type cb_delete from w_com010_d`cb_delete within w_42013_d
end type

type cb_insert from w_com010_d`cb_insert within w_42013_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42013_d
end type

type cb_update from w_com010_d`cb_update within w_42013_d
end type

type cb_print from w_com010_d`cb_print within w_42013_d
end type

type cb_preview from w_com010_d`cb_preview within w_42013_d
end type

type gb_button from w_com010_d`gb_button within w_42013_d
end type

type cb_excel from w_com010_d`cb_excel within w_42013_d
end type

type dw_head from w_com010_d`dw_head within w_42013_d
integer y = 148
integer width = 3534
integer height = 332
string dataobject = "d_42013_h01"
end type

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */
/* 작성일      : 2002.03.13                                                  */
/* 수정일      : 2002.03.13                                                  */
/*===========================================================================*/
CHOOSE CASE dwo.name
	CASE "brand", "shop_div"
//		IF Left(dw_head.GetItemString(1, "shop_cd"), 1) <> data THEN
			dw_head.SetItem(1, "shop_cd", "")
			dw_head.SetItem(1, "shop_nm", "")
//		END IF
//	CASE "shop_div"
//		IF data <> '%' THEN
//			IF Mid(dw_head.GetItemString(1, "shop_cd"), 2, 1) <> data THEN
//				dw_head.SetItem(1, "shop_cd", "")
//				dw_head.SetItem(1, "shop_nm", "")
//			END IF
//		END IF
	CASE "shop_cd"	      //  Popup 검색창이 존재하는 항목
		IF ib_itemchanged THEN RETURN 1
		RETURN PARENT.TRIGGER EVENT ue_Popup(dwo.name, row, data, 1)


	CASE "brand", "year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
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

			This.GetChild("sojae", idw_sojae)
			idw_sojae.SetTransObject(SQLCA)
			idw_sojae.Retrieve('%', is_brand)
			idw_sojae.insertrow(1)
			idw_sojae.Setitem(1, "sojae", "%")
			idw_sojae.Setitem(1, "sojae_nm", "전체")
	
//	This.GetChild("item", idw_item)
//	idw_item.SetTransObject(SQLCA)
//	idw_item.Retrieve(data)
//	idw_item.insertrow(1)
//	idw_item.Setitem(1, "item", "%")
//	idw_item.Setitem(1, "item_nm", "전체")
		
END CHOOSE

end event

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
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

THIS.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

THIS.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',is_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

THIS.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')

THIS.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if


end event

type ln_1 from w_com010_d`ln_1 within w_42013_d
integer beginy = 484
integer endy = 484
end type

type ln_2 from w_com010_d`ln_2 within w_42013_d
integer beginy = 488
integer endy = 488
end type

type dw_body from w_com010_d`dw_body within w_42013_d
integer x = 9
integer y = 500
integer width = 3593
integer height = 1540
string dataobject = "d_42013_d01"
end type

type dw_print from w_com010_d`dw_print within w_42013_d
integer x = 672
integer y = 828
string dataobject = "d_42013_r01"
end type

