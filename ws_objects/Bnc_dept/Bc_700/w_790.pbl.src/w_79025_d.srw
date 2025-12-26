$PBExportHeader$w_79025_d.srw
$PBExportComments$불량유형관리
forward
global type w_79025_d from w_com010_d
end type
end forward

global type w_79025_d from w_com010_d
end type
global w_79025_d w_79025_d

type variables
DataWindowChild idw_brand , idw_year , idw_season
String is_brand , is_frm_ymd, is_to_ymd, is_year, is_season, is_style, is_chno, is_receipt_type, is_judg_l, is_judg_s
end variables

on w_79025_d.create
call super::create
end on

on w_79025_d.destroy
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

is_judg_l = dw_head.GetItemSTRING(1, "judg_l")
if IsNull(is_judg_l) or Trim(is_judg_l) = "" then
	is_judg_l = '%'
end if

is_judg_s = dw_head.GetItemSTRING(1, "judg_s")
if IsNull(is_judg_s) or Trim(is_judg_s) = "" then
	is_judg_s = '%'
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

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
	is_style = '%'
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
	is_chno = '%'
end if

is_receipt_type = dw_head.GetItemString(1, "receipt_type")

return true
end event

event ue_retrieve();call super::ue_retrieve;string ls_ftp_add, ls_serial, ls_serial_1
boolean lb_exist

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_frm_ymd, is_to_ymd, is_judg_l, is_judg_s, is_year, is_season, is_style, is_chno, is_receipt_type)

ls_ftp_add = '\\220.118.68.4\photo\claim_ex\'

select top 1 style + chno + judg_l + judg_s + seq_no + '.jpg'		AS SERIAL,
				 style + chno + judg_l + judg_s + '0001' + '.jpg'	   AS SERIAL_1
into :ls_serial, :ls_serial_1
from tb_79012_h (nolock)
where style = :is_style
		and judg_l = :is_judg_l
		and judg_s = :is_judg_s;

lb_exist = FileExists(ls_ftp_add + ls_serial)

if lb_exist = true then
//	dw_body.setitem(1, 'serial', ls_ftp_add + ls_serial)
//	dw_body.setitem(1, 'file_nm', ls_serial)
else
	lb_exist = FileExists(ls_ftp_add + ls_serial_1)
	if lb_exist = true then
		dw_body.setitem(1, 'serial', ls_ftp_add + ls_serial_1)
	else
		dw_body.setitem(1, 'serial', '')
	end if
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_79025_d","0")
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

type cb_close from w_com010_d`cb_close within w_79025_d
end type

type cb_delete from w_com010_d`cb_delete within w_79025_d
end type

type cb_insert from w_com010_d`cb_insert within w_79025_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_79025_d
end type

type cb_update from w_com010_d`cb_update within w_79025_d
end type

type cb_print from w_com010_d`cb_print within w_79025_d
end type

type cb_preview from w_com010_d`cb_preview within w_79025_d
end type

type gb_button from w_com010_d`gb_button within w_79025_d
end type

type cb_excel from w_com010_d`cb_excel within w_79025_d
end type

type dw_head from w_com010_d`dw_head within w_79025_d
string dataobject = "d_79025_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child, ldw_judg_s

This.GetChild("brand", idw_brand)
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
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("judg_l", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('795')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("judg_s", ldw_judg_s)
ldw_judg_s.SetTransObject(SQLCA)
ldw_judg_s.Retrieve('796','%')
ldw_judg_s.InsertRow(1)
ldw_judg_s.SetItem(1, "inter_cd", '')
ldw_judg_s.SetItem(1, "inter_nm", '')


end event

event dw_head::itemchanged;call super::itemchanged;string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name

	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "brand"
//		This.GetChild("sojae", ldw_child)
//		ldw_child.SetTransObject(SQLCA)
//		ldw_child.Retrieve('%', data)
//		ldw_child.insertrow(1)
//		ldw_child.Setitem(1, "sojae", "%")
//		ldw_child.Setitem(1, "sojae_nm", "전체")
//		
//	
//		This.GetChild("item", ldw_child)
//		ldw_child.SetTransObject(SQLCA)
//		ldw_child.Retrieve(data)
//		ldw_child.insertrow(1)
//		ldw_child.Setitem(1, "item", "%")
//		ldw_child.Setitem(1, "item_nm", "전체")		
				
		
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

type ln_1 from w_com010_d`ln_1 within w_79025_d
end type

type ln_2 from w_com010_d`ln_2 within w_79025_d
end type

type dw_body from w_com010_d`dw_body within w_79025_d
string dataobject = "D_79025_D01"
boolean livescroll = false
end type

type dw_print from w_com010_d`dw_print within w_79025_d
string dataobject = "D_79025_R01"
end type

