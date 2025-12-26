$PBExportHeader$w_22205_d.srw
$PBExportComments$원/부자재 수불내역 조회
forward
global type w_22205_d from w_com010_d
end type
end forward

global type w_22205_d from w_com010_d
end type
global w_22205_d w_22205_d

type variables
string is_brand, is_year, is_season, is_mat_gubn, is_fr_bill_dt, is_to_bill_dt, is_mat_cd, is_gubn
DataWindowChild  idw_brand, idw_season
end variables

on w_22205_d.create
call super::create
end on

on w_22205_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

If is_mat_gubn = '1' Then
	ls_title = '원자재 수불내역 현황'
Else
	ls_title = '부자재 수불내역 현황'
End If

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_title.Text = '" + ls_title + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
				 "t_fr_bill_dt.Text = '" + String(is_fr_bill_dt, '@@@@/@@/@@') + "'" + &
				 "t_to_bill_dt.Text = '" + String(is_to_bill_dt, '@@@@/@@/@@') + "'" 
dw_print.Modify(ls_modify)


end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/* event       : ue_retrieve                                                 */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_mat_gubn,is_fr_bill_dt,is_to_bill_dt,is_mat_cd, is_gubn)
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
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
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



if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif ( gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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

is_mat_gubn = dw_head.GetItemString(1, "mat_gubn")
if IsNull(is_mat_gubn) or Trim(is_mat_gubn) = "" then
   MessageBox(ls_title,"자재구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("mat_gubn")
   return false
end if

is_mat_cd = dw_head.getitemstring(1,"mat_cd")
is_gubn = dw_head.getitemstring(1,"gubn")

is_fr_bill_dt = String(dw_head.GetItemDateTime(1,"fr_bill_dt"), 'yyyymmdd')
if IsNull(is_fr_bill_dt) Or Trim(is_fr_bill_dt) = "" then
   MessageBox(ls_title,"From일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("fr_bill_dt")
	return false
end if

is_to_bill_dt = String(dw_head.GetItemDateTime(1,"to_bill_dt"), 'yyyymmdd')
if IsNull(is_to_bill_dt) Or Trim(is_to_bill_dt) = "" then
   MessageBox(ls_title,"To일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("to_bill_dt")
	return false
end if

if is_to_bill_dt < is_fr_bill_dt  then
	MessageBox(ls_title, "마지막 일자가 처음 일자보다 작습니다!")
   dw_head.SetFocus()
	dw_head.SetColumn("to_bill_dt")
	return false
end if

return true
end event

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "fr_bill_dt", ld_datetime)
dw_head.SetItem(1, "to_bill_dt", ld_datetime)
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm ,ls_mat_nm
Boolean    lb_check 
DataStore  lds_Source


is_brand = dw_head.getitemstring(1,"brand")
is_year = dw_head.getitemstring(1,"year")
is_season = dw_head.getitemstring(1,"season")

CHOOSE CASE as_column
	CASE "mat_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or as_data = "" then
						RETURN 0			
				ELSEIF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
//						RETURN 0		

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

			
			gst_cd.default_where   = "where brand = '" + is_brand + "' and mat_year like '" + is_year + "%' and mat_season like '" + is_season + "%'" // and mat_sojae like '" + is_item + "%'"
		
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22205_d","0")
end event

type cb_close from w_com010_d`cb_close within w_22205_d
end type

type cb_delete from w_com010_d`cb_delete within w_22205_d
end type

type cb_insert from w_com010_d`cb_insert within w_22205_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_22205_d
end type

type cb_update from w_com010_d`cb_update within w_22205_d
end type

type cb_print from w_com010_d`cb_print within w_22205_d
end type

type cb_preview from w_com010_d`cb_preview within w_22205_d
end type

type gb_button from w_com010_d`gb_button within w_22205_d
end type

type cb_excel from w_com010_d`cb_excel within w_22205_d
end type

type dw_head from w_com010_d`dw_head within w_22205_d
integer height = 224
string dataobject = "d_22205_h01"
boolean livescroll = false
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
idw_brand.InsertRow(1)
idw_brand.SetItem(1,"inter_cd", '%')
idw_brand.SetItem(1,"inter_nm",'전체')


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
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE ""	     //  Popup 검색창이 존재하는 항목 
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

type ln_1 from w_com010_d`ln_1 within w_22205_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_d`ln_2 within w_22205_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_22205_d
integer y = 444
integer width = 3570
integer height = 1564
string dataobject = "d_22205_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;This.inv_sort.of_SetColumnHeader(false)
end event

type dw_print from w_com010_d`dw_print within w_22205_d
string dataobject = "d_22205_r01"
end type

