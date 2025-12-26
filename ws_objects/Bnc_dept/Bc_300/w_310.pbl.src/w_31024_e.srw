$PBExportHeader$w_31024_e.srw
$PBExportComments$스타일 납기관리
forward
global type w_31024_e from w_com010_e
end type
end forward

global type w_31024_e from w_com010_e
end type
global w_31024_e w_31024_e

type variables
DataWindowChild idw_brand, idw_season, idw_make_type, idw_sojae, idw_country_cd, idw_jup_gubn, idw_item

String is_bill_dt, is_brand, is_year, is_season, is_make_type, is_sojae, is_country_cd, is_jup_gubn, is_cust_cd, is_style
string is_dlvy_fr, is_dlvy_to, is_out_seq, is_out_seq2, is_mis_gbn, is_reorder, is_chn_gbn, is_chn_exp, is_item, is_fix_dlvy, is_sort_seq







end variables

on w_31024_e.create
call super::create
end on

on w_31024_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.10                                                  */	
/* 수정일      : 2001.12.10                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"bill_dt", string(ld_datetime,"yyyymmdd"))
//	dw_head.setitem(1,"dlvy_fr", string(ld_datetime,"yyyymm") + "01")
//	dw_head.SetItem(1,"dlvy_to", string(ld_datetime,'yyyymmdd'))
end if


end event

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

is_bill_dt = dw_head.getitemstring(1,'bill_dt')
if IsNull(is_bill_dt) or Trim(is_bill_dt) = "" then
   MessageBox(ls_title,"기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("bill_dt")
   return false
end if

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


is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if
is_sort_seq    = dw_head.GetItemString(1,"sort_seq")

is_season    = dw_head.GetItemString(1,"season")
is_sojae     = dw_head.GetItemString(1,"sojae")
is_item      = dw_head.GetItemString(1,"item")
is_country_cd= dw_head.GetItemString(1,"country_cd")
is_jup_gubn  = dw_head.GetItemString(1,"jup_gubn")
is_make_type = dw_head.GetItemString(1,"make_type")
is_cust_cd   = dw_head.GetItemString(1,"cust_cd")
is_style     = dw_head.GetItemString(1,"style")
is_dlvy_fr   = dw_head.GetitemString(1,"dlvy_fr")
is_dlvy_to   = dw_head.GetitemString(1,"dlvy_to")
is_out_seq   = dw_head.GetitemString(1,"out_seq")
is_out_seq2  = dw_head.GetitemString(1,"out_seq2")
is_mis_gbn   = dw_head.GetitemString(1,"mis_gbn")
is_reorder   = dw_head.GetitemString(1,"reorder")
is_chn_gbn   = dw_head.GetitemString(1,"chn_gbn")
is_chn_exp   = dw_head.GetitemString(1,"chn_exp")
is_fix_dlvy  = dw_head.GetItemString(1,"fix_dlvy")

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 종호)                                      */	
/* 작성일      : 2001.12.04                                                  */	
/* 수정일      : 2001.12.04                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/

string     ls_cust_cd, ls_cust_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"							// 거래처 코드
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				if isnull(as_data) or LenA(as_data) = 0 then 
					return 0
				ElseIF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
					dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF
				
			END IF   
			
			   gst_cd.ai_div          = ai_div	// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "거래처 코드 검색" 
				gst_cd.datawindow_nm   = "d_com911" 
				gst_cd.default_where   = " WHERE Cust_Code Between '5000' And '9999' "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " ( CustCode LIKE '" + as_data + "%' or  Cust_sname LIKE '" + as_data + "%') "
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
					dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"CustCode"))
					dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"Cust_sName"))
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("rmk")
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
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.11                                                  */	
/* 수정일      : 2001.12.11                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_bill_dt, is_brand, is_year, is_season, is_sojae, is_country_cd, is_jup_gubn, is_make_type, is_cust_cd, is_style, is_mis_gbn, is_reorder, is_chn_gbn, is_item, is_fix_dlvy, is_sort_seq)


IF il_rows > 0 THEN
//	If wf_week_set() <> 0 Then MessageBox("조회오류", "요일 셋팅에 실패하였습니다.")
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

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

//FOR i=1 TO ll_row_count
//   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
//   IF idw_status = NewModified! THEN				/* New Record */
//      dw_body.Setitem(i, "reg_id", gs_user_id)
//   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
//      dw_body.Setitem(i, "mod_id", gs_user_id)
//      dw_body.Setitem(i, "mod_dt", ld_datetime)
//   END IF
//NEXT

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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.11                                                  */	
/* 수정일      : 2001.12.11                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_column
Integer i

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


		// dw_body의 요일을 가져와 dw_print에 셋팅
		For i = 0 To 6
			ls_column = ls_column + "week_" + String(i) + "_t1.Text = '" + dw_body.Describe("week_" + String(i) + "_t1.Text") + "'"
		Next
		
		ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
						"t_user_id.Text = '" + gs_user_id + "'" + &
						"t_datetime.Text = '" + ls_datetime + "'" + &
						"t_bill_dt.Text = '" + String(is_bill_dt, '@@@@/@@/@@') + "'" + &
						"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
						"t_year.Text = '" + is_year + "'" + &
						"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
						"t_make_type.Text = '" + idw_make_type.GetItemString(idw_make_type.GetRow(), "inter_display") + "'" + &
						"t_sojae.Text = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "inter_display") + "'" + &
						"t_country_cd.Text = '" + idw_country_cd.GetItemString(idw_country_cd.GetRow(), "inter_display") + "'" + &
						"t_jup_gubn.Text = '" + is_jup_gubn + "'" + &				
						ls_column
		
		dw_print.Modify(ls_modify)
		if is_reorder = 'Y' then 			dw_print.object.t_reorder.text = '리오다만'


		

end event

type cb_close from w_com010_e`cb_close within w_31024_e
end type

type cb_delete from w_com010_e`cb_delete within w_31024_e
end type

type cb_insert from w_com010_e`cb_insert within w_31024_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_31024_e
end type

type cb_update from w_com010_e`cb_update within w_31024_e
end type

type cb_print from w_com010_e`cb_print within w_31024_e
end type

type cb_preview from w_com010_e`cb_preview within w_31024_e
end type

type gb_button from w_com010_e`gb_button within w_31024_e
end type

type cb_excel from w_com010_e`cb_excel within w_31024_e
end type

type dw_head from w_com010_e`dw_head within w_31024_e
integer y = 160
integer height = 272
string dataobject = "d_31024_h01"
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

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', is_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(is_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')


This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')
idw_country_cd.InsertRow(1)
idw_country_cd.SetItem(1, "inter_cd", '%')
idw_country_cd.SetItem(1, "inter_nm", '전체')


This.GetChild("make_type", idw_make_type)
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.InsertRow(1)
idw_make_type.SetItem(1, "inter_cd", '%')
idw_make_type.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name


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
			idw_sojae.InsertRow(1)
			idw_sojae.SetItem(1, "sojae", '%')
			idw_sojae.SetItem(1, "sojae_nm", '전체')
			
			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_brand)
			idw_item.InsertRow(1)
			idw_item.SetItem(1, "item", '%')
			idw_item.SetItem(1, "item_nm", '전체')
		
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_31024_e
end type

type ln_2 from w_com010_e`ln_2 within w_31024_e
end type

type dw_body from w_com010_e`dw_body within w_31024_e
string dataobject = "d_31024_d01"
boolean hscrollbar = true
end type

event dw_body::itemchanged;call super::itemchanged;datetime ld_datetime, ld_datetime2

CHOOSE CASE dwo.name
	CASE "fix_dlvy" 
		IF isnull(data) or data = '' then
			dw_body.setitem(row,"fix_dlvy_dt", "")
		elseif gf_cdate(ld_datetime,0)  THEN  
			dw_body.setitem(row,"fix_dlvy_dt", string(ld_datetime,"yyyymmdd"))
		end if
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_31024_e
integer x = 183
integer y = 612
string dataobject = "d_31024_r01"
end type

