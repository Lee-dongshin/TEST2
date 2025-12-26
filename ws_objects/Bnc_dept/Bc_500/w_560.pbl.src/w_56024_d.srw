$PBExportHeader$w_56024_d.srw
$PBExportComments$직영점  매출 집계
forward
global type w_56024_d from w_com010_d
end type
end forward

global type w_56024_d from w_com010_d
integer width = 3680
integer height = 2280
end type
global w_56024_d w_56024_d

type variables
string is_yymm, is_shop_cd
end variables

on w_56024_d.create
call super::create
end on

on w_56024_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm, ls_tel_no, ls_shop_cd
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				if gs_brand <> 'K' then
					IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 and  MidA(as_data,2,1) = "B" or MidA(as_data,2,1) = 'K' THEN
						dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
						RETURN 0
					END IF 
				end if
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
//			gst_cd.default_where   = "WHERE Shop_Stat = '00' and shop_div = 'B' "
			gst_cd.default_where   = "WHERE Shop_Stat = '00' and shop_div in ('B','K') " + &
			                         " and brand = '" + gs_brand + "'"
			if gs_brand <> 'K' then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else
				gst_cd.Item_where = ""
			end if
			
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

				ls_shop_cd = lds_Source.GetItemString(1,"shop_cd")
				select tel_no
				into :ls_tel_no
				from tb_91100_m (nolock)
				where shop_cd = :ls_shop_cd;
					
			   dw_head.object.t_tel.text = ls_tel_no
				
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56024_d","0")
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준월을 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shoP_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"대표매장코드를 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shoP_cd")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymm, '%', is_shop_cd)
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

event ue_preview();



This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_print.retrieve(is_yymm, '%', is_shop_cd)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();This.Trigger Event ue_title()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_print.retrieve(is_yymm, '%', is_shop_cd)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm

ls_shop_nm = dw_head.getitemstring(1, "shop_nm")

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
             "t_SHOP_NM.Text = '" + ls_shop_nm + "'" + &
              "t_yymm.Text = '" + is_yymm + "'"

dw_print.Modify(ls_modify)

end event

type cb_close from w_com010_d`cb_close within w_56024_d
end type

type cb_delete from w_com010_d`cb_delete within w_56024_d
end type

type cb_insert from w_com010_d`cb_insert within w_56024_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56024_d
end type

type cb_update from w_com010_d`cb_update within w_56024_d
end type

type cb_print from w_com010_d`cb_print within w_56024_d
end type

type cb_preview from w_com010_d`cb_preview within w_56024_d
end type

type gb_button from w_com010_d`gb_button within w_56024_d
end type

type cb_excel from w_com010_d`cb_excel within w_56024_d
end type

type dw_head from w_com010_d`dw_head within w_56024_d
integer height = 124
string dataobject = "d_56024_h01"
end type

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_56024_d
integer beginy = 312
integer endy = 312
end type

type ln_2 from w_com010_d`ln_2 within w_56024_d
integer beginy = 316
integer endy = 316
end type

type dw_body from w_com010_d`dw_body within w_56024_d
integer y = 332
integer height = 1708
string dataobject = "d_56024_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_56024_d
string dataobject = "d_56024_r02"
end type

