$PBExportHeader$w_79016_d.srw
$PBExportComments$불량유형관리
forward
global type w_79016_d from w_com010_d
end type
end forward

global type w_79016_d from w_com010_d
end type
global w_79016_d w_79016_d

type variables
DataWindowChild idw_brand , idw_year , idw_season
String is_brand , is_frm_ymd, is_to_ymd, is_year, is_season, is_style, is_chno, is_receipt_type 
end variables

on w_79016_d.create
call super::create
end on

on w_79016_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm , ls_style, ls_chno ,ls_bujin_chk, ls_dep_ymd, ls_dep_seq
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	
			CASE "style"							// 거래처 코드
				IF ISNULL(AS_DATA) OR Trim(as_data) = "" THEN RETURN 0
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = " WHERE 1 = 1 "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
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
            
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
					

					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("chno")
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


is_frm_ymd = dw_head.GetItemSTRING(1, "frm_ymd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("is_frm_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemSTRING(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("is_to_ymd")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("is_year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("is_season")
   return false
end if

is_receipt_type = dw_head.GetItemString(1, "receipt_type")

return true
end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_frm_ymd, is_to_ymd, is_year, is_season, is_style, is_chno,is_receipt_type)
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

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text 		= '" + is_pgm_id + "'" + &
            "t_user_id.Text 	= '" + gs_user_id + "'" + &
            "t_datetime.Text 	= '" + ls_datetime + "'" + &
				"t_brand.Text 		= '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_year.Text      = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_nm") + "'" + &					
				"t_season.Text    = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &									
				"t_frm_ymd.Text   = '" + is_frm_ymd + "'" + &		
				"t_to_ymd.Text    = '" + is_to_ymd + "'" 


dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_79016_d","0")
end event

event open;call super::open;
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_datetime = String(ld_datetime, "yyyymmdd")

DW_HEAD.SETITEM(1, "FRM_YMD", LS_DATETIME)
DW_HEAD.SETITEM(1, "TO_YMD", LS_DATETIME)


end event

type cb_close from w_com010_d`cb_close within w_79016_d
end type

type cb_delete from w_com010_d`cb_delete within w_79016_d
end type

type cb_insert from w_com010_d`cb_insert within w_79016_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_79016_d
end type

type cb_update from w_com010_d`cb_update within w_79016_d
end type

type cb_print from w_com010_d`cb_print within w_79016_d
end type

type cb_preview from w_com010_d`cb_preview within w_79016_d
end type

type gb_button from w_com010_d`gb_button within w_79016_d
end type

type cb_excel from w_com010_d`cb_excel within w_79016_d
end type

type dw_head from w_com010_d`dw_head within w_79016_d
string dataobject = "d_79016_h01"
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


This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


end event

event dw_head::itemchanged;call super::itemchanged;

CHOOSE CASE dwo.name

	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_79016_d
end type

type ln_2 from w_com010_d`ln_2 within w_79016_d
end type

type dw_body from w_com010_d`dw_body within w_79016_d
string dataobject = "D_79016_D01"
boolean livescroll = false
end type

type dw_print from w_com010_d`dw_print within w_79016_d
string dataobject = "D_79016_R01"
end type

