$PBExportHeader$w_91013_d.srw
$PBExportComments$매장 판매사원 LIST
forward
global type w_91013_d from w_com010_d
end type
end forward

global type w_91013_d from w_com010_d
end type
global w_91013_d w_91013_d

type variables
DataWindowChild idw_child

String is_flag, is_code

end variables

on w_91013_d.create
call super::create
end on

on w_91013_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.05.23                                                  */	
/* 수정일      : 2002.05.23                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "code"
		is_flag = dw_head.GetItemString(1, "flag")
		If is_flag = '1' Then
			// 매장
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" or LenA(as_data) = 1 THEN
					dw_head.SetItem(al_row, "name", "")
					RETURN 0
				END IF 
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
					dw_head.SetItem(al_row, "name", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = ""		//WHERE Shop_Stat = '00' 
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
				dw_head.SetItem(al_row, "code", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "name", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
//				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
		Else
			// 판매사원
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					dw_head.SetItem(al_row, "name", "")
					RETURN 0
				END IF 
				IF LeftA(as_data, 1) = '8' and gf_sale_empnm(as_data, ls_shop_nm) = 0 THEN
					dw_head.SetItem(al_row, "name", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "판매사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com914" 
			gst_cd.default_where   = "WHERE SALE_EMP LIKE '8%'"	
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SALE_EMP LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "code", lds_Source.GetItemString(1,"sale_emp"))
				dw_head.SetItem(al_row, "name", lds_Source.GetItemString(1,"sale_empnm"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
//				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
		End If
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

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.05.23                                                  */	
/* 수정일      : 2002.05.23                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_flag, is_code)

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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.05.23                                                  */	
/* 수정일      : 2002.05.23                                                  */
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

is_flag = Trim(dw_head.GetItemString(1, "flag"))
if IsNull(is_flag) or is_flag = "" then
   MessageBox(ls_title,"조회 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("flag")
   return false
end if

is_code = Trim(dw_head.GetItemString(1, "code"))
//if IsNull(is_code) or is_code = "" then
//   MessageBox(ls_title,"코드를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("code")
//   return false
//end if

return true

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.05.23                                                 */	
/* 수정일      : 2002.05.23                                                  */
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

If is_flag = '1' Then
	ls_modify =	ls_modify + &
					"t_title.Text = '매장별 판매사원 LIST'" + &
					"t_code.Text  = '매    장: " + is_code + ' ' + dw_head.GetItemString(1, "name") + "'" + &
					"code_t.Text  = '판매사원'"
Else
	ls_modify =	ls_modify + &
					"t_title.Text = '판매사원별 매장 LIST'" + &
					"t_code.Text  = '판매사원: " + is_code + ' ' + dw_head.GetItemString(1, "name") + "'" + &
					"code_t.Text  = '매    장'"
End If

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_91013_d
end type

type cb_delete from w_com010_d`cb_delete within w_91013_d
end type

type cb_insert from w_com010_d`cb_insert within w_91013_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_91013_d
end type

type cb_update from w_com010_d`cb_update within w_91013_d
end type

type cb_print from w_com010_d`cb_print within w_91013_d
end type

type cb_preview from w_com010_d`cb_preview within w_91013_d
end type

type gb_button from w_com010_d`gb_button within w_91013_d
end type

type cb_excel from w_com010_d`cb_excel within w_91013_d
end type

type dw_head from w_com010_d`dw_head within w_91013_d
integer height = 124
string dataobject = "d_91013_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.05.23                                                  */	
/* 수정일      : 2002.05.23                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "flag"
		This.SetItem(1, "code", "")
		This.SetItem(1, "name", "")
	CASE "code"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_91013_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_91013_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_91013_d
integer y = 348
integer height = 1692
string dataobject = "d_91013_d02"
end type

type dw_print from w_com010_d`dw_print within w_91013_d
string dataobject = "d_91013_r01"
end type

