$PBExportHeader$w_22203_d.srw
$PBExportComments$자재 HISTORY
forward
global type w_22203_d from w_com010_d
end type
type rb_1 from radiobutton within w_22203_d
end type
type rb_2 from radiobutton within w_22203_d
end type
type gb_1 from groupbox within w_22203_d
end type
end forward

global type w_22203_d from w_com010_d
integer width = 3675
integer height = 2276
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_22203_d w_22203_d

type variables
String is_mat_cd, is_mat_gubn
end variables

on w_22203_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.gb_1
end on

on w_22203_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.07                                                  */	
/* 수정일      : 2002.01.07                                                  */
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

is_mat_cd = dw_head.GetItemString(1, "mat_cd")
if IsNull(is_mat_cd) or Trim(is_mat_cd) = "" then
   MessageBox(ls_title,"자재코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("mat_cd")
   return false
end if

return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.07                                                  */	
/* 수정일      : 2002.01.07                                                  */
/*===========================================================================*/
String     ls_mat_nm ,ls_mat_cust_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "mat_cd"				
			IF ai_div = 1 THEN 	
				if isnull(as_data) or LenA(as_data) = 0 then return 0
				IF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
				
					

		 			 if gs_brand <> "K" then	
					   dw_head.SetItem(al_row, "mat_nm", ls_mat_nm)

						select isnull((select cust_cd + dbo.sf_cust_nm(cust_cd,'s') 
									from tb_21010_m where mat_cd = :as_data),'')
						into :ls_mat_cust_nm 
						from dual;
							
						dw_head.setitem(1,"cust_nm",ls_mat_cust_nm)
					
						RETURN 0
					 else	
							if gs_brand <> MidA(as_data,1,1) then
								Return 1
							else 
								dw_head.SetItem(al_row, "mat_nm", ls_mat_nm)
	
								select isnull((select cust_cd + dbo.sf_cust_nm(cust_cd,'s') 
											from tb_21010_m where mat_cd = :as_data),'')
								into :ls_mat_cust_nm 
								from dual;
									
								dw_head.setitem(1,"cust_nm",ls_mat_cust_nm)
							
								RETURN 0
							end if	
					 end if				
					
					
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			if is_mat_gubn =  '1'  then 
				gst_cd.window_title    = "원자재 코드 검색" 
				gst_cd.datawindow_nm   = "d_com020" 
				gst_cd.default_where   = ""
			else 
				gst_cd.window_title    = "부자재 코드 검색" 
				gst_cd.datawindow_nm   = "d_com913" 
				gst_cd.default_where   = "where mat_gubn  =  '2' "
			end if
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "mat_CD LIKE '" + as_data + "%'"
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
				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 


				ls_mat_cust_nm = dw_head.getitemstring(1,"mat_cd")

				select isnull((select cust_cd + dbo.sf_cust_nm(cust_cd,'s') 
							from tb_21010_m where mat_cd = :ls_mat_cust_nm),'')
				into :ls_mat_cust_nm 
				from dual;
					
				dw_head.setitem(1,"cust_nm",ls_mat_cust_nm)

				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "cust_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or trim(as_data) = "" then
				
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div

			gst_cd.window_title    = "원자재 코드 검색" 
			gst_cd.datawindow_nm   = "d_22203_d02" 
			gst_cd.default_where   = " where right(cust_cd,4) between '5' and '9' "

	  		 if gs_brand <> "K" then	
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " (cust_cd LIKE '" + as_data + "%' or cust_sname like '%" + as_data + "%')" 
				ELSE
					gst_cd.Item_where = ""
				END IF
			else
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " (cust_cd LIKE '" + as_data + "%' or cust_sname like '%" + as_data + "%') and cust_cd LIKE '[KO]%' " 
				ELSE
					gst_cd.Item_where = " cust_cd LIKE '[KO]%' "
				END IF
				
			end if
			
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = " (cust_cd  like '%" + as_data + "%' or cust_sname like '%" +  as_data + "%')"												
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
				dw_head.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
				dw_head.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))

				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"cust_cd"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 


				ls_mat_cust_nm = dw_head.getitemstring(1,"mat_cd")

				select isnull((select cust_cd + dbo.sf_cust_nm(cust_cd,'s') 
							from tb_21010_m where mat_cd = :ls_mat_cust_nm),'')
				into :ls_mat_cust_nm 
				from dual;
					
				dw_head.setitem(1,"cust_nm",ls_mat_cust_nm)

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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.07                                                  */	
/* 수정일      : 2002.01.07                                                  */
/* event       : ue_retrieve                                                 */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_mat_gubn,is_mat_cd)
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

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징                                        */	
/* 작성일      : 2002.01.14                                                  */	
/* 수정일      : 2002.01.14                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_mat_gubn = '1' Then
	ls_title = '원자재 HISTORY'
Else
	ls_title = '부자재 HISTORY'
End If

ls_modify =	 "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"  + &
				 "t_title.Text = '" + ls_title + "'"  + &
				 "t_mat_cd.Text = '" + is_mat_cd + "'"  + & 
             "t_mat_nm.Text = '" + dw_head.GetItemString(1,"mat_nm") + "'" 
dw_print.Modify(ls_modify)


end event

event open;call super::open;is_mat_gubn = '1'
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22003_d","0")
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

type cb_close from w_com010_d`cb_close within w_22203_d
end type

type cb_delete from w_com010_d`cb_delete within w_22203_d
end type

type cb_insert from w_com010_d`cb_insert within w_22203_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_22203_d
end type

type cb_update from w_com010_d`cb_update within w_22203_d
end type

type cb_print from w_com010_d`cb_print within w_22203_d
end type

type cb_preview from w_com010_d`cb_preview within w_22203_d
end type

type gb_button from w_com010_d`gb_button within w_22203_d
end type

type cb_excel from w_com010_d`cb_excel within w_22203_d
end type

type dw_head from w_com010_d`dw_head within w_22203_d
integer x = 809
integer width = 2747
integer height = 124
string dataobject = "d_22203_h01"
boolean livescroll = false
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.07                                                  */	
/* 수정일      : 2002.01.07                                                  */
/*===========================================================================*/
long ll_rows

CHOOSE CASE dwo.name
	CASE "mat_cd", "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_22203_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_22203_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_22203_d
integer y = 348
integer height = 1692
string dataobject = "d_22203_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_22203_d
integer x = 27
integer y = 856
integer width = 1047
string dataobject = "d_22203_r01"
end type

type rb_1 from radiobutton within w_22203_d
event ue_keydown pbm_keydown
integer x = 73
integer y = 212
integer width = 302
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "원자재"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0))
END IF

end event

event clicked;This.textcolor = Rgb(0, 0, 255) 
rb_2.textcolor = Rgb(0, 0, 0)
is_mat_gubn = '1' 

dw_head.SetItem(1, "mat_cd", "")
dw_head.SetItem(1, "mat_nm", "")
end event

type rb_2 from radiobutton within w_22203_d
event ue_keydown pbm_keydown
integer x = 425
integer y = 212
integer width = 334
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
string text = "부자재"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0))
END IF
end event

event clicked;This.textcolor = Rgb(0, 0, 255) 
rb_1.textcolor = Rgb(0, 0, 0)
is_mat_gubn = '2' 

dw_head.SetItem(1, "mat_cd", "")
dw_head.SetItem(1, "mat_nm", "")
end event

type gb_1 from groupbox within w_22203_d
integer x = 9
integer y = 144
integer width = 782
integer height = 176
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

