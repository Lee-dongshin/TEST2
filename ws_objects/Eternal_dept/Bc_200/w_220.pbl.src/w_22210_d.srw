$PBExportHeader$w_22210_d.srw
$PBExportComments$부자재 출고증 인쇄
forward
global type w_22210_d from w_com020_d
end type
end forward

global type w_22210_d from w_com020_d
integer width = 3675
integer height = 2276
end type
global w_22210_d w_22210_d

type variables
string is_cust_cd, is_fr_yymmdd, is_to_yymmdd, is_style, is_chno

end variables

on w_22210_d.create
call super::create
end on

on w_22210_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_cust_cd, is_fr_yymmdd, is_to_yymmdd)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
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

//is_brand = dw_head.GetItemString(1, "brand")
//if IsNull(is_brand) or Trim(is_brand) = "" then
//   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//end if
is_cust_cd = dw_head.GetItemString(1, "cust_cd")
is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
return true

end event

event ue_preview();long i, j
decimal ldc_out_qty
string ls_miss
This.Trigger Event ue_title ()
IF dw_body.AcceptText() <> 1 THEN RETURN 

il_rows = dw_print.retrieve(is_cust_cd, is_style, is_chno)
for i = 1 to dw_body.rowcount()
	ldc_out_qty = dw_body.getitemnumber(i,"out_qty")
	dw_print.setitem(i,"out_qty",ldc_out_qty)
next


j=0
for i = 1 to dw_body.rowcount()
	ls_miss = dw_body.getitemstring(i,"out_yn")
	if ls_miss = 'N' then		
		dw_print.deleterow(i - j)
		j = j + 1
	end if
next


dw_print.Object.DataWindow.Print.Orientation	 = 1
//dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()


end event

event ue_print();long i, j
decimal ldc_out_qty
string ls_miss

This.Trigger Event ue_title()
IF dw_body.AcceptText() <> 1 THEN RETURN 

il_rows = dw_print.retrieve(is_cust_cd, is_style, is_chno)
for i = 1 to dw_body.rowcount()
	ldc_out_qty = dw_body.getitemnumber(i,"out_qty")
	dw_print.setitem(i,"out_qty",ldc_out_qty)
next


j=0
for i = 1 to dw_body.rowcount()
	ls_miss = dw_body.getitemstring(i,"out_yn")
	if ls_miss = 'N' then		
		dw_print.deleterow(i - j)
		j = j + 1
	end if
next

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
	dw_print.Object.DataWindow.Print.Orientation	 = 1
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
String     ls_cust_nm 
Boolean    lb_check 
DataStore  lds_Source


CHOOSE CASE as_column
	CASE "cust_cd"				
			IF ai_div = 1 THEN 
				
				if isnull(as_data) or as_data = "" then
					return 0					
				elseIF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
//				   dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
//					RETURN 0
					 if gs_brand <> "K" then	
						   dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
							RETURN 0

					 else	
							if gs_brand <> MidA(as_data,1,1) then
								Return 1
							else 
								dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
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
//
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22210_d","0")
end event

event type long ue_update();call super::ue_update;IF dw_body.AcceptText() <> 1 THEN RETURN -1

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if
end event

type cb_close from w_com020_d`cb_close within w_22210_d
end type

type cb_delete from w_com020_d`cb_delete within w_22210_d
end type

type cb_insert from w_com020_d`cb_insert within w_22210_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_22210_d
end type

type cb_update from w_com020_d`cb_update within w_22210_d
end type

type cb_print from w_com020_d`cb_print within w_22210_d
end type

type cb_preview from w_com020_d`cb_preview within w_22210_d
end type

event cb_preview::clicked;if  messagebox("확인","저장하시겠습니까..?",Exclamation!,YesNo!,1) = 1 then
	Parent.Trigger Event ue_preview()
	Parent.Trigger Event ue_update()
	il_rows = dw_body.retrieve(is_cust_cd, is_style, is_chno)
else
	Parent.Trigger Event ue_preview()
end if





end event

type gb_button from w_com020_d`gb_button within w_22210_d
end type

type cb_excel from w_com020_d`cb_excel within w_22210_d
end type

type dw_head from w_com020_d`dw_head within w_22210_d
integer height = 156
string dataobject = "d_22210_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name

	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_d`ln_1 within w_22210_d
integer beginy = 356
integer endy = 356
end type

type ln_2 from w_com020_d`ln_2 within w_22210_d
integer beginy = 360
integer endy = 360
end type

type dw_list from w_com020_d`dw_list within w_22210_d
integer y = 376
integer width = 645
integer height = 1664
string dataobject = "d_22210_l01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_style = This.GetItemString(row, 'style') /* DataWindow에 Key 항목을 가져온다 */
is_chno  = This.GetItemString(row, 'chno') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_style) THEN return
il_rows = dw_body.retrieve(is_cust_cd, is_style, is_chno)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_22210_d
integer x = 704
integer y = 376
integer width = 2894
integer height = 1664
string dataobject = "d_22210_d01"
boolean hscrollbar = true
end type

event dw_body::buttonclicked;call super::buttonclicked;long i
string ls_ss
if dwo.text = "선택" then 
	ls_ss = "Y"
	dwo.text = "제외"
else
	ls_ss = "N"
	dwo.text = "선택"
end if

for i = 1 to this.rowcount()
	this.setitem(i,"out_yn",ls_ss)
next
end event

type st_1 from w_com020_d`st_1 within w_22210_d
integer x = 686
integer y = 376
integer height = 1664
end type

type dw_print from w_com020_d`dw_print within w_22210_d
integer x = 151
integer y = 500
integer height = 400
string dataobject = "d_22210_r01"
end type

