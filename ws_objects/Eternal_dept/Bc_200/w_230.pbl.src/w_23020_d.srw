$PBExportHeader$w_23020_d.srw
$PBExportComments$원자재 발주대비 입고현황
forward
global type w_23020_d from w_com010_d
end type
end forward

global type w_23020_d from w_com010_d
integer width = 3680
integer height = 2276
end type
global w_23020_d w_23020_d

type variables
string  is_brand, is_mat_year, is_mat_season, is_mat_sojae, is_out_seq, is_in_gubn, is_mat_cd, is_cust_cd, is_miipgo

datawindowchild  idw_brand, idw_season, idw_mat_sojae, idw_out_seq
end variables

on w_23020_d.create
call super::create
end on

on w_23020_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.14                                                  */	
/* 수정일      : 2002.01.14                                                  */
/* event       : ue_keycheck                                                 */
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_mat_year   = dw_head.GetItemString(1, "mat_year")
is_mat_season = dw_head.GetItemString(1, "mat_season")
is_mat_sojae  = dw_head.GetItemString(1, "mat_sojae")
is_out_seq    = dw_head.GetItemString(1, "out_seq")
is_mat_cd     = dw_head.GetItemString(1, "mat_cd")
is_cust_cd    = dw_head.GetItemString(1, "cust_cd")
is_in_gubn    = dw_head.GetItemString(1, "in_gubn")
is_miipgo    = dw_head.GetItemString(1, "miipgo")

return true
end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.14                                                  */	
/* 수정일      : 2002.01.14                                                  */
/* event       : ue_retrieve                                                 */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_mat_year, is_mat_season, is_mat_sojae, is_out_seq, is_in_gubn, is_mat_cd, is_cust_cd, is_miipgo)

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
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
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

dw_print.object.t_brand.text   = '브 랜 드: '+is_brand + ' ' + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_outseq.text  = '출고차순: '+is_out_seq + ' ' + idw_out_seq.getitemstring(idw_out_seq.getrow(),"inter_nm")
dw_print.object.t_cust_cd.text = '거 래 처: '+is_cust_cd + ' ' + dw_head.getitemstring(1,"cust_nm")
dw_print.object.t_sojae.text   = '소    재: '+is_mat_sojae + ' ' + idw_mat_sojae.getitemstring(idw_mat_sojae.getrow(),"mat_sojae_nm")
dw_print.object.t_yearsn.text  = '년도시즌: '+is_mat_year + ' ' + idw_season.getitemstring(idw_season.getrow(),"inter_nm")




end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
String     ls_mat_nm, ls_cust_nm, ls_emp_nm 
Boolean    lb_check 
DataStore  lds_Source 

is_brand = dw_head.getitemstring(1,"brand")
is_mat_year = dw_head.getitemstring(1,"mat_year")
is_mat_season = dw_head.getitemstring(1,"mat_season")
is_mat_sojae = dw_head.getitemstring(1,"mat_sojae")
CHOOSE CASE as_column
	CASE "mat_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or as_data = "" then
						RETURN 0			
				ELSEIF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
					//	RETURN 0		
						
					 if gs_brand <> "K" then	
						RETURN 0
					 else	
							if gs_brand <> MidA(as_data,1,1) then
								Return 1
							else 
								RETURN 0
							end if	
					 end if								
						
				end if					
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "원자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 
			gst_cd.default_where   = " where brand = '" + is_brand + "' and mat_year like '" + is_mat_year + "%' and mat_season like '" + is_mat_season + "%' and mat_sojae like '" + is_mat_sojae + "%'"
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
											 
	   	if gs_brand <> "K" then	
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%')" 
				ELSE
					gst_cd.Item_where = ""
				END IF
			else
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%') and custcode LIKE '[KO]%' " 
				ELSE
					gst_cd.Item_where = " custcode LIKE '[KO]%' "
				END IF
				
			end if	
											 
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%')" 
//			ELSE
//				gst_cd.Item_where = ""
//			END IF

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

event open;call super::open;dw_body.Object.DataWindow.HorizontalScrollSplit  = 2415
end event

type cb_close from w_com010_d`cb_close within w_23020_d
end type

type cb_delete from w_com010_d`cb_delete within w_23020_d
end type

type cb_insert from w_com010_d`cb_insert within w_23020_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_23020_d
end type

type cb_update from w_com010_d`cb_update within w_23020_d
end type

type cb_print from w_com010_d`cb_print within w_23020_d
end type

type cb_preview from w_com010_d`cb_preview within w_23020_d
end type

type gb_button from w_com010_d`gb_button within w_23020_d
end type

type cb_excel from w_com010_d`cb_excel within w_23020_d
end type

type dw_head from w_com010_d`dw_head within w_23020_d
integer width = 3817
string dataobject = "d_23020_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : constructor(dw_head)                                        */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
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

This.GetChild("mat_sojae", idw_mat_sojae)
idw_mat_sojae.SetTRansObject(SQLCA)
idw_mat_sojae.Retrieve("1",is_brand)
idw_mat_sojae.insertrow(1)
idw_mat_sojae.Setitem(1, "mat_sojae", "%")
idw_mat_sojae.Setitem(1, "mat_sojae_nm", "전체")

This.GetChild("out_seq", idw_out_seq)
idw_out_seq.SetTRansObject(SQLCA)
idw_out_seq.Retrieve('010')
idw_out_seq.insertrow(1)
idw_out_seq.Setitem(1, "inter_cd", "%")
idw_out_seq.Setitem(1, "Inter_nm", "전체")
 

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "option"      // dddw로 작성된 항목
		if data = "1" then
			dw_body.dataobject  = "d_21007_d01"
			dw_print.dataobject = "d_21007_r01"
		else
			dw_body.dataobject  = "d_21007_d02"
			dw_print.dataobject = "d_21007_r02"
		end if
		dw_body.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)
		
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
		
		This.GetChild("mat_sojae", idw_mat_sojae)
		idw_mat_sojae.SetTRansObject(SQLCA)
		idw_mat_sojae.Retrieve("1",is_brand)
		idw_mat_sojae.insertrow(1)
		idw_mat_sojae.Setitem(1, "mat_sojae", "%")
		idw_mat_sojae.Setitem(1, "mat_sojae_nm", "전체")
END CHOOSE

end event

event dw_head::editchanged;call super::editchanged;choose case dwo.name
	case "mat_cd","cust_cd"
		if LenA(data) = 1 then this.setitem(1,"brand",data)
end choose
end event

type ln_1 from w_com010_d`ln_1 within w_23020_d
end type

type ln_2 from w_com010_d`ln_2 within w_23020_d
end type

type dw_body from w_com010_d`dw_body within w_23020_d
string dataobject = "d_23020_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_23020_d
integer x = 59
integer y = 564
string dataobject = "d_23020_r01"
end type

