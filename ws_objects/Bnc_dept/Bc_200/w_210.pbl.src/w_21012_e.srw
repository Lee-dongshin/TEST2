$PBExportHeader$w_21012_e.srw
$PBExportComments$부자재 발주서등록
forward
global type w_21012_e from w_com010_e
end type
end forward

global type w_21012_e from w_com010_e
end type
global w_21012_e w_21012_e

type variables
string is_brand, is_year,  is_season, is_s_date, is_e_date, is_mat_sojae, is_ord_origin, is_mat_cd, is_opt_gubn, is_cust_cd
string is_spec, is_mat_color, is_expert_yn, is_make_cust, is_cmt_flag, is_local_gubn
Datawindowchild  idw_brand, idw_season, idw_mat_sojae
end variables

forward prototypes
public subroutine wf_confirm_smat (string as_ord_origin)
end prototypes

public subroutine wf_confirm_smat (string as_ord_origin);
if LenA(as_ord_origin) = 9 then 
	
	OpenWithParm(w_21011_d, as_ord_origin)	
	w_21011_d.dw_head.setitem(1,"ord_origin", as_ord_origin)
	w_21011_d.trigger event ue_retrieve()			
end if
end subroutine

on w_21012_e.create
call super::create
end on

on w_21012_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "s_date", ld_datetime)
dw_head.SetItem(1, "e_date", ld_datetime)
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
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


is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")

is_mat_sojae = dw_head.GetItemString(1, "mat_sojae")

is_s_date = String(dw_head.GetItemDateTime(1,"s_date"), 'yyyymmdd')

is_e_date = String(dw_head.GetItemDateTime(1,"e_date"), 'yyyymmdd')

is_cust_cd = dw_head.GetItemString(1, "cust_cd")
is_make_cust = dw_head.GetItemString(1, "make_cust")

is_mat_cd = dw_head.GetItemString(1, "mat_cd")
is_ord_origin = dw_head.GetItemString(1, "ord_origin")

is_opt_gubn = dw_head.GetItemString(1, "opt_gubn")

is_spec = dw_head.GetItemString(1, "spec")
is_mat_color = dw_head.GetItemString(1, "mat_color")
is_expert_yn = dw_head.GetItemString(1, "expert_yn")
is_cmt_flag = dw_head.GetItemString(1, "cmt_flag")
is_local_gubn = dw_head.GetItemString(1, "local_gubn")

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : ue_retrieve                                                 */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

	
il_rows = dw_body.retrieve(is_brand, is_year, is_season,is_mat_sojae, is_s_date, is_e_date, is_ord_origin, is_mat_cd, '%', is_spec, is_mat_color, is_cust_cd, is_expert_yn,is_make_cust, is_cmt_flag, is_local_gubn)	


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

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm , ls_cust_nm, ls_make_cust_nm
Boolean    lb_check 
DataStore  lds_Source

is_brand = dw_head.getitemstring(1,"brand")
CHOOSE CASE as_column
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
			if is_brand = 'O' or is_brand = 'Y' then
				gst_cd.default_where   = "Where brand     = 'O' "      + &
												 "  and cust_code between '5000' and '9999'"
											 
			else
				gst_cd.default_where   = "Where brand     = 'N' "      + &
												 "  and cust_code between '5000' and '9999'"				
			end if

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
	CASE "make_cust"				

			
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				elseIF gf_cust_nm(as_data, 'S', ls_make_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "make_cust_nm", ls_make_cust_nm)
					RETURN 0
				END IF 
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처 코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			if is_brand = 'O' or is_brand = 'Y' then
				gst_cd.default_where   = "Where brand     = 'O' "      + &
												 "  and cust_code between '5000' and '9999'"
											 
			else
				gst_cd.default_where   = "Where brand     = 'N' "      + &
												 "  and cust_code between '5000' and '9999'"				
			end if

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
				dw_head.SetItem(al_row, "make_cust", lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "make_cust_nm", lds_Source.GetItemString(1,"cust_name"))
				/* 다음컬럼으로 이동 */
				dw_head.scrolltorow(1)
				dw_head.SetColumn("make_cust")
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

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_21012_e","0")
end event

type cb_close from w_com010_e`cb_close within w_21012_e
end type

type cb_delete from w_com010_e`cb_delete within w_21012_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_21012_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_21012_e
end type

type cb_update from w_com010_e`cb_update within w_21012_e
boolean visible = false
end type

type cb_print from w_com010_e`cb_print within w_21012_e
end type

type cb_preview from w_com010_e`cb_preview within w_21012_e
end type

type gb_button from w_com010_e`gb_button within w_21012_e
end type

type cb_excel from w_com010_e`cb_excel within w_21012_e
end type

type dw_head from w_com010_e`dw_head within w_21012_e
string dataobject = "d_21012_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : constructor(dw_head)                                        */
/*===========================================================================*/
datawindowchild ldw_mat_color

This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
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


This.GetChild("mat_sojae", idw_mat_sojae)
idw_mat_sojae.SetTRansObject(SQLCA)
idw_mat_sojae.Retrieve("2")
idw_mat_sojae.insertrow(1)
idw_mat_sojae.Setitem(1, "mat_sojae", "%")
idw_mat_sojae.Setitem(1, "mat_sojae_nm", "전체")

 
This.GetChild("mat_color", ldw_mat_color)
ldw_mat_color.SetTRansObject(SQLCA)
ldw_mat_color.Retrieve()
ldw_mat_color.insertrow(1)
ldw_mat_color.Setitem(1, "color", "%")
ldw_mat_color.Setitem(1, "color_knm", "전체")


end event

event dw_head::itemchanged;call super::itemchanged;choose case dwo.name
	CASE "cust_cd", "make_cust"	     //  Popup 검색창이 존재하는 항목 
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
		
end choose

end event

type ln_1 from w_com010_e`ln_1 within w_21012_e
end type

type ln_2 from w_com010_e`ln_2 within w_21012_e
end type

type dw_body from w_com010_e`dw_body within w_21012_e
string dataobject = "d_21012_d01"
boolean hscrollbar = true
end type

event dw_body::doubleclicked;call super::doubleclicked;String 	ls_search, ls_local_gubn
if row > 0 then 
			ls_local_gubn 	= this.GetItemString(row,'local_gubn')
			if ls_local_gubn  = '3' then 
				ls_search 	= this.GetItemString(row,'ord_origin')
				if LenA(ls_search) = 9 then  wf_confirm_smat(ls_search)
			else
				messagebox("확인", "시장부자재가 아닙니다...")
			end if

end if
end event

type dw_print from w_com010_e`dw_print within w_21012_e
string dataobject = "d_21012_r01"
end type

