$PBExportHeader$w_21024_d.srw
$PBExportComments$자재시험성적진행조회
forward
global type w_21024_d from w_com010_d
end type
end forward

global type w_21024_d from w_com010_d
end type
global w_21024_d w_21024_d

type variables
string is_brand, is_mat_year, is_mat_season 
string is_mat_cd, is_cust_cd, is_miipgo, is_fr_ymd, is_to_ymd, is_sijang_gubn

datawindowchild  idw_brand, idw_season
end variables

on w_21024_d.create
call super::create
end on

on w_21024_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_mat_nm, ls_cust_nm, ls_emp_nm 
Boolean    lb_check 
DataStore  lds_Source 

is_brand = dw_head.getitemstring(1,"brand")
is_mat_year = dw_head.getitemstring(1,"mat_year")
is_mat_season = dw_head.getitemstring(1,"mat_season")

CHOOSE CASE as_column
	CASE "mat_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or as_data = "" then
						RETURN 0			
				ELSEIF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
						RETURN 0		
				end if					
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "원자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 
			gst_cd.default_where   = " where brand = '" + is_brand + "' and mat_year like '" + is_mat_year + "%' and mat_season like '" + is_mat_season + "%' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "mat_cd LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
				dw_head.SetItem(al_row, "mat_year", lds_Source.GetItemString(1,"mat_year"))
				dw_head.SetItem(al_row, "mat_season", lds_Source.GetItemString(1,"mat_season"))
				dw_head.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))
				
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "cust_cd"							
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				elseIF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처 코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			gst_cd.default_where   = "Where brand     = case when '" + is_brand + "' = 'J' then 'N' "      + &
																	" when '" + is_brand + "' = 'Y' then 'O' "      + &
																	" else '" + is_brand + "' end "      + &
			                         "  and cust_code between '5000' and '9000'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%')" 
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
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_name"))
				/* 다음컬럼으로 이동 */
				dw_head.scrolltorow(1)
				dw_head.SetColumn("cust_cd")
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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;string   ls_title

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
elseif (gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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


is_mat_year   = dw_head.GetItemString(1, "mat_year")
if IsNull(is_mat_year) or Trim(is_mat_year) = "" then
 is_mat_year = "%"
end if

is_mat_season = dw_head.GetItemString(1, "mat_season")

is_mat_cd     = dw_head.GetItemString(1, "mat_cd")
if IsNull(is_mat_cd) or Trim(is_mat_cd) = "" then
 is_mat_cd = "%"
end if


is_cust_cd    = dw_head.GetItemString(1, "cust_cd")
if IsNull(is_cust_cd) or Trim(is_cust_cd) = "" then
 is_cust_cd = "%"
end if

is_miipgo    = dw_head.GetItemString(1, "miipgo")

is_fr_ymd    = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd    = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


is_sijang_gubn = dw_head.GetItemString(1, "sijang_gubn")

return true
end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

/*

SP_21024_D01 
	@ps_brand       	VARCHAR(1),
	@ps_mat_year    	VARCHAR(4),
	@ps_mat_season  	VARCHAR(1),
	@ps_mat_cd			varchar(10),
	@ps_cust_cd			varchar(6),
	@miipgo				varchar(1) = null,	--미입고분 
	@fr_ymd				varchar(8) = null,
	@to_ymd				varchar(8) = null,
	@sijang_gubn		varchar(1) = null
	
*/	

il_rows = dw_body.retrieve(is_brand, is_mat_year, is_mat_season, is_mat_cd, is_cust_cd, is_miipgo, is_fr_ymd, is_to_ymd,is_sijang_gubn)
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

event open;call super::open;datetime ld_datetime


IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"fr_ymd",string(ld_datetime,"yyyymmdd"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_ymd",string(ld_datetime,"yyyymmdd"))
end IF
end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime,ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =  "t_pg_id.Text     = '" + is_pgm_id + "'" + &
             "t_user_id.Text   = '" + gs_user_id + "'" + &
             "t_datetime.Text  = '" + ls_datetime + "'" + &
				 "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text      = '" + is_mat_year + "'" + &
				 "t_season.Text    = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   

dw_print.Modify(ls_modify)

dw_print.object.t_yymmdd.text = is_fr_ymd + ' ~ ' + is_to_ymd


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_21024_d","0")
end event

type cb_close from w_com010_d`cb_close within w_21024_d
end type

type cb_delete from w_com010_d`cb_delete within w_21024_d
end type

type cb_insert from w_com010_d`cb_insert within w_21024_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_21024_d
end type

type cb_update from w_com010_d`cb_update within w_21024_d
end type

type cb_print from w_com010_d`cb_print within w_21024_d
end type

type cb_preview from w_com010_d`cb_preview within w_21024_d
end type

type gb_button from w_com010_d`gb_button within w_21024_d
end type

type cb_excel from w_com010_d`cb_excel within w_21024_d
end type

type dw_head from w_com010_d`dw_head within w_21024_d
integer x = 0
integer y = 180
integer width = 3611
string dataobject = "d_21024_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')


//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_mat_year = dw_head.getitemstring(1,'mat_year')

this.getchild("mat_season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_mat_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	
	CASE "mat_cd","cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		

	CASE "brand", "mat_year"		
		//라빠레트 시즌적용
		dw_head.accepttext()
		is_brand = dw_head.getitemstring(1,'brand')
		is_mat_year = dw_head.getitemstring(1,'mat_year')
		
		this.getchild("mat_season",idw_season)
		idw_season.settransobject(sqlca)
		idw_season.retrieve('003', is_brand, is_mat_year)
		//idw_season.retrieve('003')
		idw_season.insertrow(1)
		idw_season.Setitem(1, "inter_cd", "%")
		idw_season.Setitem(1, "inter_nm", "전체")
		
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_21024_d
end type

type ln_2 from w_com010_d`ln_2 within w_21024_d
end type

type dw_body from w_com010_d`dw_body within w_21024_d
string dataobject = "d_21024_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_21024_d
string dataobject = "d_21024_r01"
end type

