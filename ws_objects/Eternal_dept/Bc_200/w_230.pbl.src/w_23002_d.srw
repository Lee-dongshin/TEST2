$PBExportHeader$w_23002_d.srw
$PBExportComments$자재클레임내역현황
forward
global type w_23002_d from w_com010_d
end type
type rb_color from radiobutton within w_23002_d
end type
type rb_sum from radiobutton within w_23002_d
end type
end forward

global type w_23002_d from w_com010_d
integer width = 3675
integer height = 2280
rb_color rb_color
rb_sum rb_sum
end type
global w_23002_d w_23002_d

type variables
datawindowchild idw_brand
string is_brand, is_st_ymd, is_ed_ymd, is_mat_cd, is_style, is_chno, is_gubn, is_cust_cd
end variables

on w_23002_d.create
int iCurrent
call super::create
this.rb_color=create rb_color
this.rb_sum=create rb_sum
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_color
this.Control[iCurrent+2]=this.rb_sum
end on

on w_23002_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_color)
destroy(this.rb_sum)
end on

event pfc_preopen;call super::pfc_preopen;datetime ld_datetime


IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"st_ymd",string(ld_datetime,"yyyymmdd"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"ed_ymd",string(ld_datetime,"yyyymmdd"))
end if
end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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
is_st_ymd = dw_head.GetItemString(1, "st_ymd")
is_ed_ymd = dw_head.GetItemString(1, "ed_ymd")
is_mat_cd = dw_head.GetItemString(1, "mat_cd")
is_style = dw_head.GetItemString(1, "style")
is_chno	= dw_head.GetItemString(1, "chno")
is_gubn	= dw_head.GetItemString(1, "gubn")
is_cust_cd	= dw_head.GetItemString(1, "cust_cd")

if rb_sum.checked then
		dw_body.dataobject = "d_23002_d02"
		dw_body.SetTransObject(SQLCA)
		dw_print.dataobject = "d_23002_r02"
		dw_print.settransobject(sqlca)
		
else
		dw_body.dataobject = "d_23002_d01"	
		dw_body.SetTransObject(SQLCA)
		dw_print.dataobject = "d_23002_r01"
		dw_print.settransobject(sqlca)		
end if

if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;
/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//messagebox("is_brand",is_gubn)
//messagebox("is_year",is_year)
//messagebox("is_season",is_season)
//messagebox("is_sojae",is_sojae)
//messagebox("is_out_gubn",is_out_gubn)

il_rows = dw_body.retrieve(is_brand, is_mat_cd,is_style,is_chno, is_st_ymd, is_ed_ymd, is_gubn, is_cust_cd)
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_claim_cust_nm , ls_cust_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"				
			IF ai_div = 1 THEN 	
				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
			is_brand = dw_head.getitemstring(1,"brand")
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "업체 코드 검색" 
			gst_cd.datawindow_nm   = "d_22100_dw1" 
			gst_cd.default_where   = "WHERE cust_code between '4999' and '8999' " + &
												"and   brand in ('N','O') " + &
												"and   change_gubn = '00' " + &
												"and   custcode like '_0%' "

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(custcode LIKE '" + as_data + "%' or cust_sname like '%" + as_data + "%')"
//				gst_cd.Item_where = "custcode LIKE '" + as_data + "%'" // or cust_sname like '%" + as_data + "%')"
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
//				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source

	CASE "style"	
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
//				elseIF gf_cust_nm(as_data, 'S', ls_claim_cust_nm) = 0 THEN
//				   dw_master.SetItem(al_row, "cust_nm", ls_claim_cust_nm)
//					RETURN 0
				END IF 
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "제품 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = " where brand = '" + gs_brand + "'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " brand = '" + is_brand + "' and style like '" + as_data +"%'"
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
				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source	


	CASE "mat_cd"	
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
//				elseIF gf_cust_nm(as_data, 'S', ls_claim_cust_nm) = 0 THEN
//				   dw_master.SetItem(al_row, "cust_nm", ls_claim_cust_nm)
//					RETURN 0
				END IF 
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 
			gst_cd.default_where   = " where mat_cd like '" + as_data + "%'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " mat_cd like '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("style")
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
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '"  + is_brand + "'" + &
				 "t_st_ymd.Text = '" + is_st_ymd + "'" + &
				 "t_ed_ymd.Text = '" + is_ed_ymd + "'" + &
				 "t_mat_cd.Text = '" + is_mat_cd + "'" + &
				 "t_style.Text = '"  + is_style + "'" + "-" + "'" + is_chno + "'"


		
dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_23002_d","0")
end event

type cb_close from w_com010_d`cb_close within w_23002_d
end type

type cb_delete from w_com010_d`cb_delete within w_23002_d
end type

type cb_insert from w_com010_d`cb_insert within w_23002_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_23002_d
end type

type cb_update from w_com010_d`cb_update within w_23002_d
end type

type cb_print from w_com010_d`cb_print within w_23002_d
end type

type cb_preview from w_com010_d`cb_preview within w_23002_d
end type

type gb_button from w_com010_d`gb_button within w_23002_d
end type

type cb_excel from w_com010_d`cb_excel within w_23002_d
end type

type dw_head from w_com010_d`dw_head within w_23002_d
integer y = 164
integer height = 264
string dataobject = "d_23002_h01"
end type

event dw_head::constructor;call super::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')


end event

event dw_head::editchanged;call super::editchanged;dw_head.setitem(1,"mat_nm","")
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF data = '' or isnull(data) or ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_23002_d
end type

type ln_2 from w_com010_d`ln_2 within w_23002_d
end type

type dw_body from w_com010_d`dw_body within w_23002_d
string dataobject = "d_23002_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_child
this.getchild("st_color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()
end event

type dw_print from w_com010_d`dw_print within w_23002_d
integer x = 69
integer y = 576
string dataobject = "d_23002_r01"
end type

type rb_color from radiobutton within w_23002_d
integer x = 3045
integer y = 284
integer width = 631
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "Color별 집계현황"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type rb_sum from radiobutton within w_23002_d
boolean visible = false
integer x = 3049
integer y = 208
integer width = 439
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "정산 집계현황"
borderstyle borderstyle = stylelowered!
end type

