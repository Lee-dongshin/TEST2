$PBExportHeader$w_55018_d.srw
$PBExportComments$브랜드별 매출비교
forward
global type w_55018_d from w_com010_d
end type
end forward

global type w_55018_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_55018_d w_55018_d

type variables
string is_brand, is_yymmdd, is_shop_cd, is_gubn, is_flag, is_to_ymd
datawindowchild idw_brand
end variables

on w_55018_d.create
call super::create
end on

on w_55018_d.destroy
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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


is_shop_cd = dw_head.GetItemString(1, "shop_cd")
is_gubn = dw_head.GetItemString(1, "gubn")
is_flag = dw_head.GetItemString(1, "flag")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_flag = '1' then
	dw_body.dataobject = "d_55018_d01"
	dw_print.dataobject = "d_55018_r01"
ELSEif is_flag = '2' then
	dw_body.dataobject = "d_55018_d02"
	dw_print.dataobject = "d_55018_r02"	
	
else 
	dw_body.dataobject = "d_55018_d03"
	dw_print.dataobject = "d_55018_r03"	
end if
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_to_ymd, is_shop_cd, is_gubn)
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_shop_div
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		ls_brand    = Trim(dw_head.GetItemString(1, "brand"))
	
		IF ai_div = 1 THEN 	
			IF IsNull(as_data) OR Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "shop_nm", "")
				RETURN 0
			END IF 

			
			IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
				RETURN 0
			END IF 
			
		end if
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "' AND SHOP_DIV in ('G','K')" + " AND SHOP_STAT = '00' "
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "(SHOP_CD LIKE '" + as_data + "%' or shop_cd like '%" + as_data + "%')"
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = CREATE DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = TRUE
			lds_Source = Message.PowerObjectParm
			dw_head.SetRow(al_row)
			dw_head.SetColumn(as_column)
			dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
			dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
			/* 다음컬럼으로 이동 */
//			dw_head.SetColumn("shop_cd")
			ib_itemchanged = FALSE 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		DESTROY lds_Source

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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
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


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55018_d","0")
end event

type cb_close from w_com010_d`cb_close within w_55018_d
end type

type cb_delete from w_com010_d`cb_delete within w_55018_d
end type

type cb_insert from w_com010_d`cb_insert within w_55018_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55018_d
end type

type cb_update from w_com010_d`cb_update within w_55018_d
end type

type cb_print from w_com010_d`cb_print within w_55018_d
end type

type cb_preview from w_com010_d`cb_preview within w_55018_d
end type

type gb_button from w_com010_d`gb_button within w_55018_d
end type

type cb_excel from w_com010_d`cb_excel within w_55018_d
end type

type dw_head from w_com010_d`dw_head within w_55018_d
integer x = 9
integer y = 148
integer width = 3575
integer height = 240
string dataobject = "d_55018_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
//	CASE "FLAG"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//		IF DATA = '1' THEN
//			dw_HEAD.object.to_yom[1].visible = true
//		else	
//			dw_HEAD.object.to_yom[1].visible = false
//		end if	
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_55018_d
integer beginy = 396
integer endy = 396
end type

type ln_2 from w_com010_d`ln_2 within w_55018_d
integer beginy = 400
integer endy = 400
end type

type dw_body from w_com010_d`dw_body within w_55018_d
integer y = 416
integer height = 1624
string dataobject = "d_55018_d01"
end type

type dw_print from w_com010_d`dw_print within w_55018_d
string dataobject = "d_55018_r01"
end type

