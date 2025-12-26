$PBExportHeader$w_56205_d.srw
$PBExportComments$외상채권 정산현황
forward
global type w_56205_d from w_com010_d
end type
end forward

global type w_56205_d from w_com010_d
integer width = 3680
integer height = 2280
end type
global w_56205_d w_56205_d

type variables
String is_shop_cd, is_fr_ym, is_to_ym
end variables

on w_56205_d.create
call super::create
end on

on w_56205_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.20                                                  */	
/* 수정일      : 2002.03.20                                                  */
/*===========================================================================*/
String     ls_shop_div, ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF 
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE shop_div in ('G', 'K', 'X') " + &
											 "  AND Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF 
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.06.26                                                  */	
/* 수정일      : 2002.06.26                                                  */
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

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_fr_ym   = String(dw_head.GetItemDateTime(1, "fr_yymm"), "yyyymm")
is_to_ym   = String(dw_head.GetItemDateTime(1, "to_yymm"), "yyyymm") 
IF is_fr_ym > is_to_ym THEN 
   MessageBox(ls_title,"시작월이 종료일 보다 큽니다 !")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ym")
   return false
END IF	

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.26                                                  */	
/* 수정일      : 2002.06.26                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_shop_cd, is_fr_ym, is_to_ym)
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
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.06.26                                                  */	
/* 수정일      : 2002.06.26                                                  */
/*===========================================================================*/
datetime ld_datetime
string   ls_modify, ls_datetime, ls_shop, ls_season 

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_shop   = dw_head.object.shop_nm[1] + "[" + is_shop_cd + "]"

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + & 
				"t_shop.Text   = '매장 : " + ls_shop + "'" + &
				"t_ym.Text    = '(" + String(is_fr_ym + is_to_ym, "@@@@/@@ - @@@@/@@") + ")'" 

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56205_d","0")
end event

type cb_close from w_com010_d`cb_close within w_56205_d
end type

type cb_delete from w_com010_d`cb_delete within w_56205_d
end type

type cb_insert from w_com010_d`cb_insert within w_56205_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56205_d
end type

type cb_update from w_com010_d`cb_update within w_56205_d
end type

type cb_print from w_com010_d`cb_print within w_56205_d
end type

type cb_preview from w_com010_d`cb_preview within w_56205_d
end type

type gb_button from w_com010_d`gb_button within w_56205_d
end type

type cb_excel from w_com010_d`cb_excel within w_56205_d
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_56205_d
integer height = 172
string dataobject = "d_56205_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.26                                                  */	
/* 수정일      : 2002.06.26                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_56205_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_56205_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_56205_d
integer x = 9
integer y = 372
integer height = 1672
string dataobject = "d_56205_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_56205_d
string dataobject = "d_56205_r01"
end type

