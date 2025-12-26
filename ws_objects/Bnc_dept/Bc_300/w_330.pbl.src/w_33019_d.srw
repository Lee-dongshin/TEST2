$PBExportHeader$w_33019_d.srw
$PBExportComments$정산현황(마감)
forward
global type w_33019_d from w_com010_d
end type
end forward

global type w_33019_d from w_com010_d
integer height = 2252
end type
global w_33019_d w_33019_d

type variables
string is_brand, is_fr_yymmdd, is_to_yymmdd, is_mat_type, is_cust_cd
datawindowchild idw_brand, idw_mat_type, idw_pay_gubn

end variables

on w_33019_d.create
call super::create
end on

on w_33019_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_preopen;call super::pfc_preopen;datetime ld_datetime
inv_resize.of_Register(dw_head, "ScaleToRight")
IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if


end event

event ue_keycheck;/*===========================================================================*/
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

is_brand    = dw_head.GetItemString(1, "brand")
is_fr_yymmdd     = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd     = dw_head.GetItemString(1, "to_yymmdd")
is_mat_type = dw_head.GetItemString(1, "mat_type")
is_cust_cd  = dw_head.GetItemString(1, "cust_cd")

if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "cust_nm", "")
					RETURN 0
				END IF
				
				IF LeftA(as_data, 1) = is_brand and gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911"
			
			choose case is_brand 
				case "O","Y"
					is_brand = 'O'
				case else 
					is_brand = 'N'
			end choose 
			
			gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' AND  CUST_CODE  > '5000' and cust_code < '8999'  "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(CUSTCODE LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%')"
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
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("smat_cd")
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

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_mat_type, is_cust_cd)
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

event ue_title();///*===========================================================================*/
///* 작성자      :                                                      */	
///* 작성일      : 2002..                                                  */	
///* 수정일      : 2002..                                                  */
///*===========================================================================*/
//
//datetime ld_datetime
//string ls_modify, ls_datetime
//
//IF gf_sysdate(ld_datetime) = FALSE THEN
//   ld_datetime = DateTime(Today(), Now())
//END IF
//
//ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
//
//
//dw_print.object.t_brand.text = "On & On"
//
////ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
////             "t_user_id.Text = '" + gs_user_id + "'" + &
////             "t_datetime.Text = '" + ls_datetime + "'" 
//////				 "t_brand.text = '" + is_brand + "'" + &
//////				 "t_yymm.text = '" + is_yymm + "'" + &
//////				 "t_mat_type.text = '" + is_mat_type + "'" + &				 
//////				 "t_cust_cd.text = '" + is_cust_cd + "'"
////
////dw_print.Modify(ls_modify)
//
//
//
end event

event ue_preview();dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로


//This.Trigger Event ue_title ()
il_rows = dw_print.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_mat_type, is_cust_cd)
//dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()



end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_23008_d","0")
end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_body.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com010_d`cb_close within w_33019_d
end type

type cb_delete from w_com010_d`cb_delete within w_33019_d
end type

type cb_insert from w_com010_d`cb_insert within w_33019_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_33019_d
end type

type cb_update from w_com010_d`cb_update within w_33019_d
end type

type cb_print from w_com010_d`cb_print within w_33019_d
end type

type cb_preview from w_com010_d`cb_preview within w_33019_d
end type

type gb_button from w_com010_d`gb_button within w_33019_d
end type

type cb_excel from w_com010_d`cb_excel within w_33019_d
end type

type dw_head from w_com010_d`dw_head within w_33019_d
integer height = 176
string dataobject = "d_33019_h01"
end type

event dw_head::constructor;
this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')

this.setcolumn("brand")
//
//this.getchild("mat_type",idw_mat_type)
//idw_mat_type.settransobject(sqlca)
//idw_mat_type.retrieve('014')
//idw_mat_type.InsertRow(1)
//idw_mat_type.SetItem(1,"inter_cd", '%')
//idw_mat_type.SetItem(1,"inter_nm",'전체')




end event

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

type ln_1 from w_com010_d`ln_1 within w_33019_d
integer beginy = 364
integer endy = 364
end type

type ln_2 from w_com010_d`ln_2 within w_33019_d
integer beginy = 368
integer endy = 368
end type

type dw_body from w_com010_d`dw_body within w_33019_d
integer y = 388
integer height = 1648
string dataobject = "d_33019_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("pay_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('007')
end event

type dw_print from w_com010_d`dw_print within w_33019_d
integer x = 50
integer y = 544
integer width = 1129
integer height = 460
string dataobject = "d_33019_r00"
end type

event dw_print::constructor;call super::constructor;DataWindowChild ldw_child

this.getchild("pay_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('007')


end event

