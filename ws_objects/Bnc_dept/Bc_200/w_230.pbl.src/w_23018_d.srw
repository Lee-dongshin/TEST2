$PBExportHeader$w_23018_d.srw
$PBExportComments$업체별 납기클레임현황
forward
global type w_23018_d from w_com010_d
end type
end forward

global type w_23018_d from w_com010_d
end type
global w_23018_d w_23018_d

type variables
string is_cust_cd, is_yymmdd, is_claim_gubn

end variables

on w_23018_d.create
call super::create
end on

on w_23018_d.destroy
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

is_cust_cd    = dw_head.GetItemString(1, "cust_cd")
is_yymmdd     = dw_head.GetItemString(1, "yymmdd")
is_claim_gubn = dw_head.GetItemString(1, "claim_gubn")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_cust_cd, is_yymmdd, is_claim_gubn)
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
/* 작성자      :                                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
String     ls_claim_cust_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"				
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				elseIF gf_cust_nm(as_data, 'S', ls_claim_cust_nm) = 0 THEN
//						dw_head.SetItem(al_row, "cust_nm", ls_claim_cust_nm)
//						RETURN 0
//					
				 	 if gs_brand <> "K" then	
						dw_head.SetItem(al_row, "cust_nm", ls_claim_cust_nm)
						RETURN 0
					 else	
							if gs_brand <> MidA(as_data,1,1) then
								Return 1
							else 
								dw_head.SetItem(al_row, "cust_nm", ls_claim_cust_nm)
								RETURN 0

							end if	
					 end if		
					
					
					
				END IF 
			END IF
			IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처 코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			gst_cd.default_where   = "Where cust_code between '5000' and '8999'"
			
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
//				gst_cd.Item_where = " (custcode LIKE '%" + as_data + "%' or cust_name like '%" + as_data + "%')" 
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


dw_print.object.t_cust_cd.text = dw_head.getitemstring(1,"cust_nm")
dw_print.object.t_yymmdd.text = is_yymmdd


end event

type cb_close from w_com010_d`cb_close within w_23018_d
end type

type cb_delete from w_com010_d`cb_delete within w_23018_d
end type

type cb_insert from w_com010_d`cb_insert within w_23018_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_23018_d
end type

type cb_update from w_com010_d`cb_update within w_23018_d
end type

type cb_print from w_com010_d`cb_print within w_23018_d
end type

type cb_preview from w_com010_d`cb_preview within w_23018_d
end type

type gb_button from w_com010_d`gb_button within w_23018_d
end type

type cb_excel from w_com010_d`cb_excel within w_23018_d
end type

type dw_head from w_com010_d`dw_head within w_23018_d
integer height = 192
string dataobject = "d_23018_h01"
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

type ln_1 from w_com010_d`ln_1 within w_23018_d
integer beginy = 388
integer endy = 388
end type

type ln_2 from w_com010_d`ln_2 within w_23018_d
integer beginy = 392
integer endy = 392
end type

type dw_body from w_com010_d`dw_body within w_23018_d
integer y = 412
integer height = 1608
string dataobject = "d_23018_d01"
end type

type dw_print from w_com010_d`dw_print within w_23018_d
string dataobject = "d_23018_r01"
end type

