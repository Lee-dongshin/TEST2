$PBExportHeader$w_75006_d.srw
$PBExportComments$매장별 고객연령분석
forward
global type w_75006_d from w_com020_d
end type
end forward

global type w_75006_d from w_com020_d
integer width = 3657
end type
global w_75006_d w_75006_d

type variables
datawindowchild	idw_brand, idw_area_cd, idw_shop_grp

string is_brand, is_shop_cd, is_fr_yymmdd, is_to_yymmdd, is_area_cd, is_shop_grp, is_shop_div, is_shop_cd2
int	ii_term_age

end variables

on w_75006_d.create
call super::create
end on

on w_75006_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

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
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if
is_shop_cd   = dw_head.GetItemString(1, "shop_cd")
is_shop_cd2 = is_shop_cd

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_area_cd   = dw_head.GetItemString(1, "area_cd")
is_shop_grp  = dw_head.GetItemString(1, "shop_grp")
is_shop_div  = dw_head.GetItemString(1, "shop_div")
ii_term_age  = dw_head.GetItemNumber(1, "age_term")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_shop_cd, is_fr_yymmdd, is_to_yymmdd, is_area_cd, is_shop_grp, is_shop_div, ii_term_age)
IF il_rows > 0 THEN
	il_rows = dw_body.retrieve(is_brand, is_shop_cd, is_fr_yymmdd, is_to_yymmdd, ii_term_age, is_area_cd, is_shop_grp, is_shop_div)
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주) 지우정보                                               */	
/* 작성일      : 2001.01.24                                                  */	
/* 수정일      : 2001.01.24                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				IF LeftA(as_data, 1) = is_brand And gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE SHOP_STAT = '00' "	+ &
											 "  AND SHOP_DIV  IN ('G','K') "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(SHOP_CD LIKE '" + as_data + "%' or SHOP_SNM LIKE '%" + as_data + "%')"
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
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
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

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,-3)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyy") + '0101')
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if
end event

event ue_preview();This.Trigger Event ue_title ()

il_rows = dw_print.retrieve(is_brand, is_shop_cd, is_fr_yymmdd, is_to_yymmdd, is_area_cd, is_shop_grp, is_shop_div, ii_term_age, is_shop_cd2)
//il_rows = dw_print.retrieve('n','%', '20030101','20030420', '%','%','%',5,'ng0009')

dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_div

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


choose case  is_shop_div
	case "G"
		ls_shop_div = "백화점"
	case "K"
		ls_shop_div = "대리점"
	case else
		ls_shop_div = "전체"
end choose

if isnull(ls_shop_div) then ls_shop_div = "전체"

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_brand.text     = is_brand + ' ' + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_shop_cd.text   = is_shop_cd + ' ' + dw_head.getitemstring(1,"shop_nm")
dw_print.object.t_fr_yymmdd.text = is_fr_yymmdd
dw_print.object.t_to_yymmdd.text = is_to_yymmdd
dw_print.object.t_area_cd.text   = is_area_cd + ' ' + idw_area_cd.getitemstring(idw_area_cd.getrow(),"inter_nm")
dw_print.object.t_shop_grp.text  = is_shop_grp + ' ' + idw_shop_grp.getitemstring(idw_shop_grp.getrow(),"inter_nm")
dw_print.object.t_shop_div.text  = ls_shop_div 
				 



end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_75006_d","0")
end event

type cb_close from w_com020_d`cb_close within w_75006_d
end type

type cb_delete from w_com020_d`cb_delete within w_75006_d
end type

type cb_insert from w_com020_d`cb_insert within w_75006_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_75006_d
end type

type cb_update from w_com020_d`cb_update within w_75006_d
end type

type cb_print from w_com020_d`cb_print within w_75006_d
boolean visible = false
end type

type cb_preview from w_com020_d`cb_preview within w_75006_d
boolean enabled = true
end type

type gb_button from w_com020_d`gb_button within w_75006_d
end type

type cb_excel from w_com020_d`cb_excel within w_75006_d
end type

type dw_head from w_com020_d`dw_head within w_75006_d
integer y = 192
integer height = 208
string dataobject = "d_75006_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertrow(1)
idw_brand.setitem(1,"inter_cd","%")
idw_brand.setitem(1,"inter_nm","전체")

This.GetChild("area_cd", idw_area_cd)
idw_area_cd.SetTransObject(SQLCA)
idw_area_cd.Retrieve('090')
idw_area_cd.insertrow(1)
idw_area_cd.setitem(1,"inter_cd","%")
idw_area_cd.setitem(1,"inter_nm","전체")

This.GetChild("shop_grp", idw_shop_grp)
idw_shop_grp.SetTransObject(SQLCA)
idw_shop_grp.Retrieve('912')
idw_shop_grp.insertrow(1)
idw_shop_grp.setitem(1,"inter_cd","%")
idw_shop_grp.setitem(1,"inter_nm","전체")



end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_d`ln_1 within w_75006_d
end type

type ln_2 from w_com020_d`ln_2 within w_75006_d
end type

type dw_list from w_com020_d`dw_list within w_75006_d
integer x = 5
integer width = 2414
string dataobject = "d_75006_l01"
end type

event dw_list::doubleclicked;call super::doubleclicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_shop_cd2 = This.GetItemString(row, 'shop_cd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_shop_cd2) THEN return
il_rows = dw_body.retrieve(is_brand, is_shop_cd2, is_fr_yymmdd, is_to_yymmdd, ii_term_age, is_area_cd, is_shop_grp, is_shop_div)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)


end event

type dw_body from w_com020_d`dw_body within w_75006_d
integer x = 2437
integer width = 1166
string dataobject = "d_75006_d01"
end type

type st_1 from w_com020_d`st_1 within w_75006_d
integer x = 2418
end type

type dw_print from w_com020_d`dw_print within w_75006_d
integer x = 59
integer y = 792
string dataobject = "d_75006_r00"
end type

