$PBExportHeader$w_21009_d.srw
$PBExportComments$원자재발주집계현황
forward
global type w_21009_d from w_com010_d
end type
end forward

global type w_21009_d from w_com010_d
integer width = 3675
integer height = 2280
end type
global w_21009_d w_21009_d

type variables
string is_brand, is_year, is_season, is_mat_sojae, is_mat_cd, is_in_gubn
datawindowchild  idw_brand, idw_season, idw_mat_sojae
end variables

on w_21009_d.create
call super::create
end on

on w_21009_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_mat_sojae, is_mat_cd, is_in_gubn)
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
is_mat_sojae = dw_head.GetItemString(1, "mat_sojae")
is_mat_cd = dw_head.GetItemString(1, "mat_cd")
is_in_gubn = dw_head.GetItemString(1, "in_gubn")

if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if
return true

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title, ls_in_gubn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_in_gubn  =  dw_head.getitemstring(1,"in_gubn")  
if ls_in_gubn = "%" then
	ls_in_gubn = "발주구분 : 전체"
elseif ls_in_gubn = "01" then
	ls_in_gubn = "발주구분 : 정상발주"
else
	ls_in_gubn = "발주구분 : 이체발주"
end if


ls_modify =  "t_pg_id.Text     = '" + is_pgm_id + "'" + &
             "t_user_id.Text   = '" + gs_user_id + "'" + &
             "t_datetime.Text  = '" + ls_datetime + "'" + &
				 "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text      = '" + is_year + "'" + &
				 "t_season.Text    = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
				 "t_in_gubn.text   = '" + ls_in_gubn + "'" + &
				 "t_mat_sojae.Text = '" + idw_mat_sojae.Getitemstring(idw_mat_sojae.GetRow(),"mat_sojae_display") + "'"
dw_print.Modify(ls_modify)



end event

event ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
String     ls_mat_nm, ls_cust_nm, ls_emp_nm 
Boolean    lb_check 
DataStore  lds_Source 

is_brand = dw_head.getitemstring(1,"brand")
is_year = dw_head.getitemstring(1,"year")
is_season = dw_head.getitemstring(1,"season")
is_mat_sojae = dw_head.getitemstring(1,"mat_sojae")
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

			
			gst_cd.default_where   = "where brand = '" + is_brand + "' and mat_year like '" + is_year + "%' and mat_season like '" + is_season + "%' and mat_sojae like '" + is_mat_sojae + "%'"
		
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
				dw_head.SetItem(al_row, "year", lds_Source.GetItemString(1,"mat_year"))
				dw_head.SetItem(al_row, "season", lds_Source.GetItemString(1,"mat_season"))
				dw_head.SetItem(al_row, "mat_sojae", lds_Source.GetItemString(1,"mat_sojae"))
				dw_head.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))
				
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
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

event pfc_dberror;//
end event

type cb_close from w_com010_d`cb_close within w_21009_d
end type

type cb_delete from w_com010_d`cb_delete within w_21009_d
end type

type cb_insert from w_com010_d`cb_insert within w_21009_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_21009_d
end type

type cb_update from w_com010_d`cb_update within w_21009_d
end type

type cb_print from w_com010_d`cb_print within w_21009_d
end type

type cb_preview from w_com010_d`cb_preview within w_21009_d
end type

type gb_button from w_com010_d`gb_button within w_21009_d
end type

type cb_excel from w_com010_d`cb_excel within w_21009_d
end type

type dw_head from w_com010_d`dw_head within w_21009_d
string dataobject = "d_21009_h01"
end type

event dw_head::constructor;datawindowchild ldw_child

this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')

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

This.GetChild("mat_sojae", idw_mat_sojae)
idw_mat_sojae.SetTRansObject(SQLCA)
idw_mat_sojae.Retrieve("1", is_brand)
idw_mat_sojae.insertrow(1)
idw_mat_sojae.Setitem(1, "mat_sojae", "%")
idw_mat_sojae.Setitem(1, "mat_sojae_nm", "전체")
end event

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "option"      // dddw로 작성된 항목
		if data = "1" then
			dw_body.dataobject = "d_21009_d01"
		else
			dw_body.dataobject = "d_21009_d02"
		end if
		dw_body.SetTransObject(SQLCA)
		
	CASE "mat_cd"	     //  Popup 검색창이 존재하는 항목 
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
		idw_season.insertrow(1)
		idw_season.Setitem(1, "inter_cd", "%")
		idw_season.Setitem(1, "inter_nm", "전체")
		
		This.GetChild("mat_sojae", idw_mat_sojae)
		idw_mat_sojae.SetTRansObject(SQLCA)
		idw_mat_sojae.Retrieve("1", is_brand)
		idw_mat_sojae.insertrow(1)
		idw_mat_sojae.Setitem(1, "mat_sojae", "%")
		idw_mat_sojae.Setitem(1, "mat_sojae_nm", "전체")

END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_21009_d
end type

type ln_2 from w_com010_d`ln_2 within w_21009_d
end type

type dw_body from w_com010_d`dw_body within w_21009_d
string dataobject = "d_21009_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_21009_d
string dataobject = "d_21009_r01"
end type

