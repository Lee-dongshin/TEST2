$PBExportHeader$w_53042_d.srw
$PBExportComments$위탁판매 현황
forward
global type w_53042_d from w_com010_d
end type
end forward

global type w_53042_d from w_com010_d
end type
global w_53042_d w_53042_d

type variables
string is_brand, is_fr_ymd, is_to_ymd, is_style, is_chno, is_year, is_season, is_opt_view
DataWindowchild idw_brand, idw_year, idw_season
end variables

on w_53042_d.create
call super::create
end on

on w_53042_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm , ls_style, ls_chno,ls_country, ls_brand
Boolean    lb_check 
DataStore  lds_Source
String ls_style_no, ls_out_ymd
Long   ll_row, ll_tag_price

CHOOSE CASE as_column
		
//		ls_brand = dw_head.Getitemstring(1, "brand")

	
			CASE "style"							// 거래처 코드
				
				ls_brand = dw_head.GetItemString(1, "brand")
				
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = " WHERE 1 = 1 "

				IF Trim(as_data) <> "" THEN 
					gst_cd.Item_where = " style LIKE '" + as_data + "%' and brand = '" + ls_brand + "' and make_type = '50' "
				ELSE
					gst_cd.Item_where = " brand = '" + ls_brand + "' and make_type = '50' "
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
					
	//								
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("year")
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

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_opt_view = "S" then
 dw_body.dataobject = "d_53042_d01"
 dw_body.SetTransObject(SQLCA)
 dw_print.dataobject = "d_53042_r01"
 dw_print.SetTransObject(SQLCA) 
else
 dw_body.dataobject = "d_53042_d02"
 dw_body.SetTransObject(SQLCA)
 dw_print.dataobject = "d_53042_r02"
 dw_print.SetTransObject(SQLCA)  
end if 

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_style, is_chno, is_year, is_season)
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53042_d","0")
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


is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
	is_style = "%"
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
	is_chno = "%"
end if

is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")

is_opt_view = dw_head.GetItemString(1, "opt_view")


return true

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.29                                                  */	
/* 수정일      : 2002.03.29                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_judg_fg

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id + "'" + &
				"t_user_id.Text  = '" + gs_user_id + "'" + &
				"t_datetime.Text = '" + ls_datetime + "'" + &
				"t_yymm.Text     = '" + String(is_fr_ymd, '@@@@/@@/@@') + "'" + &
				"t_yymm1.Text    = '" + String(is_to_ymd, '@@@@/@@/@@') + "'" + &					
				"t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_year.Text     = '" + is_year + "'" + &
				"t_season.Text   = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" 

dw_print.Modify(ls_modify)

end event

type cb_close from w_com010_d`cb_close within w_53042_d
end type

type cb_delete from w_com010_d`cb_delete within w_53042_d
end type

type cb_insert from w_com010_d`cb_insert within w_53042_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_53042_d
end type

type cb_update from w_com010_d`cb_update within w_53042_d
end type

type cb_print from w_com010_d`cb_print within w_53042_d
end type

type cb_preview from w_com010_d`cb_preview within w_53042_d
end type

type gb_button from w_com010_d`gb_button within w_53042_d
end type

type cb_excel from w_com010_d`cb_excel within w_53042_d
end type

type dw_head from w_com010_d`dw_head within w_53042_d
integer height = 224
string dataobject = "d_53042_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')



end event

event dw_head::itemchanged;call super::itemchanged;string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if LenA(data) <> 0 then
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		end if	
		

	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
			
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_cd1", "%")		
		ldw_child.Setitem(1, "inter_nm", "전체")
	
  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		
		ls_brand = this.getitemstring(row, "brand")
		ls_year  = data
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")			
		
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_53042_d
end type

type ln_2 from w_com010_d`ln_2 within w_53042_d
end type

type dw_body from w_com010_d`dw_body within w_53042_d
string dataobject = "d_53042_d01"
end type

type dw_print from w_com010_d`dw_print within w_53042_d
string dataobject = "d_53042_r01"
end type

