$PBExportHeader$w_22007_d.srw
$PBExportComments$원자재 검단현황
forward
global type w_22007_d from w_com010_d
end type
end forward

global type w_22007_d from w_com010_d
integer width = 3671
integer height = 2276
end type
global w_22007_d w_22007_d

type variables
string is_mat_cd, is_mat_nm, is_brand, is_fr_yymmdd, is_to_yymmdd, is_cust_cd

datawindowchild idw_brand

end variables

forward prototypes
public subroutine wf_disp_matqc (string as_mat_cd, string as_color)
end prototypes

public subroutine wf_disp_matqc (string as_mat_cd, string as_color);	OpenWithParm(w_22015_e, as_mat_cd)	
	w_22015_e.dw_head.setitem(1,"mat_cd", as_mat_cd)

	w_22015_e.dw_head.GetChild("color", w_22015_e.idw_color)
	w_22015_e.idw_color.SetTransObject(SQLCA)
	w_22015_e.idw_color.Retrieve(as_mat_cd)

	w_22015_e.dw_body.GetChild("color", w_22015_e.idw_color)
	w_22015_e.idw_color.SetTransObject(SQLCA)
	w_22015_e.idw_color.Retrieve(as_mat_cd)

	w_22015_e.dw_head.setitem(1,"color", as_color)
	w_22015_e.trigger event ue_retrieve()	
end subroutine

on w_22007_d.create
call super::create
end on

on w_22007_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_mat_cd, is_fr_yymmdd, is_to_yymmdd, is_cust_cd)
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
is_mat_cd = dw_head.GetItemString(1, "mat_cd")
is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_cust_cd = dw_head.GetItemString(1, "cust_cd")

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
String     ls_mat_nm, ls_cust_nm, ls_emp_nm 
Boolean    lb_check 
DataStore  lds_Source 


is_brand = dw_head.getitemstring(1,"brand")

CHOOSE CASE as_column

	CASE "cust_cd"				
			IF ai_div = 1 THEN
				if isnull(as_data) or LenA(as_data) = 0 then
					return 0
					
				elseIF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
					dw_head.Setitem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			gst_cd.default_where   = "Where brand     = case when '" + is_brand + "' in ('J','T','W','C','S') then 'N' "      + &
																	" when '" + is_brand + "' = 'Y' then 'O' "      + &
																	" else '" + is_brand + "' end "      + &
			                         "  and cust_code between '5000' and '8999'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (custcode LIKE '%" + as_data + "%' or cust_sname like '%" + as_data + "%')"
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
				dw_head.SetItem(al_row, "cust_cd",    lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				dw_head.TriggerEvent(Editchanged!)
				dw_head.SetColumn("ord_ymd")
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

event ue_title();/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime,ls_title, ls_cust_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_mat_cd.Text =  '" + String(is_mat_cd, '@@@@@@@@@-@') + "'" + &
            "t_mat_nm.Text = '" + is_mat_nm + "'" 
				 
dw_print.Modify(ls_modify)

dw_print.object.t_brand.text = idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_mat_cd.text = is_mat_cd
dw_print.object.t_fr_yymmdd.text = is_fr_yymmdd
dw_print.object.t_to_yymmdd.text = is_to_yymmdd
ls_cust_nm = dw_head.getitemstring(1,"cust_nm")
dw_print.object.t_cust_cd.text = is_cust_cd + " " + ls_cust_nm

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22007_d","0")
end event

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if

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

type cb_close from w_com010_d`cb_close within w_22007_d
end type

type cb_delete from w_com010_d`cb_delete within w_22007_d
end type

type cb_insert from w_com010_d`cb_insert within w_22007_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_22007_d
end type

type cb_update from w_com010_d`cb_update within w_22007_d
end type

type cb_print from w_com010_d`cb_print within w_22007_d
end type

type cb_preview from w_com010_d`cb_preview within w_22007_d
end type

type gb_button from w_com010_d`gb_button within w_22007_d
end type

type cb_excel from w_com010_d`cb_excel within w_22007_d
end type

type dw_head from w_com010_d`dw_head within w_22007_d
integer height = 184
string dataobject = "d_22007_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


end event

type ln_1 from w_com010_d`ln_1 within w_22007_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_d`ln_2 within w_22007_d
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_d`dw_body within w_22007_d
integer y = 408
integer height = 1632
string dataobject = "d_22007_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

end event

event dw_body::doubleclicked;call super::doubleclicked;String 	ls_mat_cd, ls_color
if row > 0 then 
			ls_mat_cd 	= this.GetItemString(row,'mat_cd')
			ls_color 	= this.GetItemString(row,'color')
			if LenA(ls_mat_cd) = 10 then wf_disp_matqc(ls_mat_cd, ls_color)
end if
end event

type dw_print from w_com010_d`dw_print within w_22007_d
integer x = 1344
integer y = 772
string dataobject = "d_22007_r01"
end type

