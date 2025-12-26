$PBExportHeader$w_cu131_e.srw
$PBExportComments$부자재 출고요청 등록
forward
global type w_cu131_e from w_com020_e
end type
type dw_asst from datawindow within w_cu131_e
end type
type dw_master from datawindow within w_cu131_e
end type
end forward

global type w_cu131_e from w_com020_e
integer width = 3653
integer height = 2236
event ue_default ( )
dw_asst dw_asst
dw_master dw_master
end type
global w_cu131_e w_cu131_e

type variables
string is_brand, is_ord_origin , is_ord_no, is_ord_ymd

datawindowchild   idw_color


end variables

event ue_default();string ls_null

		dw_master.setitem(1,"brand",is_brand)
		dw_master.setitem(1,"ord_ymd",string(now(),"yyyymmdd") )
		dw_master.setitem(1,"ord_origin",is_ord_origin)
		dw_master.setitem(1,"ord_no",ls_null)

		dw_master.setitem(1,"local_gubn","1")
		dw_master.setitem(1,"pay_gubn","08")
		if LenA(is_ord_origin) = 10 then
			dw_master.setitem(1,"ord_type","2")
		else
			dw_master.setitem(1,"ord_type","1")
		end if
		
		dw_master.setitem(1,"cust_cd",ls_null)
		dw_master.setitem(1,"cust_nm",ls_null)
		
		dw_master.SetItemStatus(1, 0, Primary!, New!)
		dw_master.setfocus()
		dw_master.setcolumn("cust_cd")
end event

on w_cu131_e.create
int iCurrent
call super::create
this.dw_asst=create dw_asst
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_asst
this.Control[iCurrent+2]=this.dw_master
end on

on w_cu131_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_asst)
destroy(this.dw_master)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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

is_ord_origin = dw_head.GetItemString(1, "ord_origin")



return true	
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(gs_shop_cd, is_ord_origin)
dw_body.Reset()


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_no, ll_ret
string Selt, ls_null, empty_chk = '1', Flag, ls_ord_no
datetime ld_datetime


ll_row_count = dw_body.RowCount()
IF Trigger Event ue_keycheck('9') = FALSE THEN RETURN -1
IF dw_master.AcceptText() <> 1 THEN RETURN -1
IF dw_body.AcceptText() <> 1 THEN RETURN -1
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

Flag = dw_master.getitemstring(1,"Flag")
ls_ord_no = dw_master.getitemstring(1,"ord_no")
if Flag = 'New' then
   dw_master.SetItemStatus(1, 0, Primary!,NewModified!)
   dw_master.Setitem(1, "reg_id", gs_user_id)
elseif Flag = 'Dat' then
   dw_master.Setitem(1, "mod_id", gs_user_id)
   dw_master.Setitem(1, "mod_dt", ld_datetime)	
end if



FOR i=1 TO ll_row_count
	Flag = dw_body.getitemstring(i,"Flag")
	Selt = dw_body.getitemstring(i,"selt")	
	if Selt = 'Y' then empty_chk = '0'
	
   IF Flag = 'New' THEN				/* New Record */
		dw_body.SetItemStatus(i, 0, Primary!, New!)
	
		if  selt = 'Y' then 								
			dw_body.Setitem(i, "ord_no", ls_ord_no  )			
			dw_body.Setitem(i, "reg_id", gs_user_id )			
			dw_body.SetItemStatus(i, 0, Primary!, NewModified! )
		else
			dw_body.SetItemStatus(i, 0, Primary!,NotModified!  )
		end if

   ELSEIF Flag = 'Dat' THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id  )
      dw_body.Setitem(i, "mod_dt", ld_datetime )
   END IF
	
NEXT


//if empty_chk = '1' then
////	messagebox("저장오류","저장할 데이타가 없습니다..")
//	for i = 1 to dw_body.rowcount()
//			dw_body.SetItemStatus(1, 0, Primary!, New!)							
//	next	
////	return -1
//end if


il_rows = dw_master.Update(TRUE, FALSE)
if il_rows = 1 then	
   il_rows = dw_body.Update(TRUE, FALSE)
	if il_rows = 1 then	
		il_rows = dw_asst.Update(TRUE, FALSE)

		dw_master.ResetUpdate()
		dw_body.ResetUpdate()
		dw_asst.ResetUpdate()
		commit  USING SQLCA;
	else
		rollback  USING SQLCA;
	end if
else
	rollback  USING SQLCA;	
end if



 
//
//if il_rows = 1 then
//	if empty_chk = '1'  then  
//		ll_ret = dw_master.DeleteRow (1)
//		ll_ret = dw_master.Update()
//		dw_master.insertrow(0)
//
////		trigger event ue_default()
//		
//	else
//		dw_master.SetItemStatus(1, 0, Primary!, New!)			
//	end if 
//	
//
//   
//	
//	commit  USING SQLCA;
//	
//end if

//
////
////	if Flag = 'New' then				//신규드록일때.
////		for i = 1 to dw_body.rowcount()
////				selt = dw_body.getitemstring(i,"selt")
////				if selt = 'Y' then	// 한번 저장한 데이타는 라인 삭제
//////					il_rows = dw_body.DeleteRow (i)
//////					i = i - 1
////					dw_body.setitem(i,"selt","N")
////					dw_body.SetItemStatus(1, 0, Primary!, New!)	//데이타 윈도우 초기화
////				else
////					dw_body.SetItemStatus(1, 0, Primary!, New!)	//데이타 윈도우 초기화
////				end if								
////		next	
////		setnull(ls_null)
////		il_rows = dw_list.retrieve(is_ord_origin)
////
////	
////	else
////
////		dw_master.ResetUpdate()
////		dw_body.ResetUpdate()
////		trigger event ue_retrieve()
////		
////	end if
////
////
////
////	ib_changed = false
////	This.Trigger Event ue_button(2, il_rows)
////	This.Trigger Event ue_msg(2, il_rows)
////
////	
////else	
////	
////   rollback  USING SQLCA;
////
////	IF SQLCA.SQLCode = -1 THEN 	
////		MessageBox("SQL error", SQLCA.SQLErrText)	
////	END IF
////
////end if
////

ib_changed = false
This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)
return il_rows




end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

/* DataWindow의 Transction 정의 */
dw_master.SetTransObject(SQLCA)
dw_asst.SetTransObject(SQLCA)
end event

event ue_insert();//
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_claim_cust_nm ,ls_ord_emp, ls_mat_cd, ls_style ,ls_chno, ls_smat_confirm
Boolean    lb_check 
DataStore  lds_Source

is_brand = LeftA(gs_shop_cd,1)
CHOOSE CASE as_column
	CASE "cust_cd"				

			
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				elseIF gf_cust_nm(as_data, 'S', ls_claim_cust_nm) = 0 THEN
				   dw_master.SetItem(al_row, "cust_nm", ls_claim_cust_nm)
					RETURN 0
				END IF 
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처 코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			gst_cd.default_where   = "Where brand     = case when '" + is_brand + "' in ('J','T','W') then 'N' "      + &
																	" when '" + is_brand + "' = 'Y' then 'O' "      + &
																	" else '" + is_brand + "' end "      + &
			                         "  and cust_code between '5000' and '8999'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%')" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_master.SetRow(al_row)
				dw_master.SetColumn(as_column)
				dw_master.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_master.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_name"))
				/* 다음컬럼으로 이동 */

				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source


	CASE "ord_origin"

		if MidA(as_data,2,1) <> '2' then		
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				END IF 
			END IF	

			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "제품 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "Where brand     = '" + is_brand + "' " 

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " style like '" + LeftA(as_data,8) +"%'"
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
				dw_head.SetItem(al_row, "ord_origin", lds_Source.GetItemString(1,"style")+lds_Source.GetItemString(1,"chno"))



///////////////////////////////////////

						
							
			ls_style = lds_Source.GetItemString(1,"style")
			ls_chno = lds_Source.GetItemString(1,"chno")

			select isnull(smat_confirm,'0') into :ls_smat_confirm from tb_12021_d (nolock) where style = :ls_style and chno = :ls_chno;
	
			dw_head.object.smat_confirm.visible = true
			if ls_smat_confirm <> '0' then
					dw_head.object.smat_confirm.visible = false
			end if

///////////////////////////////////////





				/* 다음컬럼으로 이동 */
				dw_head.scrolltorow(1)
				dw_head.SetColumn("ord_origin")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source	
				
		else
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
//				elseIF gf_cust_nm(as_data, 'S', ls_claim_cust_nm) = 0 THEN
//				   dw_master.SetItem(al_row, "cust_nm", ls_claim_cust_nm)
//					RETURN 0
				END IF 
			END IF

			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "부자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com913" 
			gst_cd.default_where   = "Where brand     = '" + is_brand + "'" 
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
				dw_head.SetItem(al_row, "ord_origin", lds_Source.GetItemString(1,"mat_cd"))
//				dw_head.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))

				/* 다음컬럼으로 이동 */
//				dw_head.post event ue_addnew(as_data,al_row)
//				dw_head.SetColumn("color")					
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source		
		end if
	CASE "ord_emp"				
			IF ai_div = 1 THEN 
				if isnull(as_data) or as_data = "" then
					return 0	
				elseIF gf_emp_nm(as_data,  ls_ord_emp) = 0 THEN
				   dw_master.SetItem(al_row, "ord_emp_nm", ls_ord_emp)
					RETURN 0
				END IF 
			END IF		
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			gst_cd.default_where   = "where goout_gubn = '1'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (empno LIKE '%" + as_data + "%' or kname like '%" + as_data + "%')"
			ELSE
				gst_cd.Item_where = ""
			END IF
			
			

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_master.SetRow(al_row)
				dw_master.SetColumn(as_column)
				dw_master.SetItem(1, "ord_emp", lds_Source.GetItemString(1,"empno"))
				dw_master.SetItem(1, "ord_emp_nm", lds_Source.GetItemString(1,"kname"))

				/* 다음컬럼으로 이동 */
//				dw_mast.setcolumn("bigo")
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

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
      	dw_body.Enabled = false
	      dw_asst.Enabled = false
		
         dw_body.reset()
	      dw_asst.reset()
      else
         dw_head.SetFocus()
      end if

   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_list.Enabled = true
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_insert.enabled = false
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_asst.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled  = true
         cb_print.enabled   = true
         cb_preview.enabled = true
	      dw_body.Enabled    = true
      	dw_asst.Enabled    = true
		
		else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
         cb_insert.enabled = true
      end if
END CHOOSE

end event

type cb_close from w_com020_e`cb_close within w_cu131_e
end type

type cb_delete from w_com020_e`cb_delete within w_cu131_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_cu131_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_cu131_e
end type

type cb_update from w_com020_e`cb_update within w_cu131_e
end type

type cb_print from w_com020_e`cb_print within w_cu131_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_cu131_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_cu131_e
integer width = 3607
end type

type dw_head from w_com020_e`dw_head within w_cu131_e
integer x = 672
integer y = 160
integer width = 581
integer height = 120
string dataobject = "d_cu131_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name

	CASE "ord_origin"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_cu131_e
integer beginy = 292
integer endy = 292
end type

type ln_2 from w_com020_e`ln_2 within w_cu131_e
integer beginy = 296
integer endy = 296
end type

type dw_list from w_com020_e`dw_list within w_cu131_e
integer y = 976
integer width = 635
integer height = 1064
string dataobject = "d_cu131_l01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
string ls_flag, ls_ord_origin, ls_style, ls_chno

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			RETURN
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_style = This.GetItemString(row, 'style')
ls_chno  = This.GetItemString(row, 'chno') 

ls_ord_origin = ls_style + ls_chno

IF IsNull(ls_ord_origin) THEN return
il_rows = dw_body.retrieve(ls_ord_origin )

for i = 1 to il_rows
		ls_flag = dw_body.getitemstring(i,"flag")
		if isnull(ls_flag) or ls_flag = 'New' then
			dw_body.SetItemStatus(i, 0, Primary!, New!)
		end if		
next

if il_rows > 0 then
	il_rows = dw_asst.retrieve(ls_ord_origin )	
	il_rows = dw_master.retrieve(ls_ord_origin )	
	dw_asst.setfocus()
	dw_asst.setcolumn("add_qty")
end if

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)


end event

type dw_body from w_com020_e`dw_body within w_cu131_e
event ue_ord_qty_change ( long al_row )
event ue_t_need_qty_change ( long al_row )
event ue_zero_check ( long al_row )
event ue_addnew ( string ord_origin,  long row )
integer x = 658
integer y = 308
integer width = 2939
integer height = 1740
string dataobject = "d_cu131_d01"
boolean hscrollbar = true
end type

event dw_body::ue_zero_check(long al_row);decimal ll_qty
//IF dw_body.AcceptText() <> 1 THEN RETURN 

ll_qty = this.getitemnumber(al_row,"qty")
if isnull(ll_qty) or ll_qty <=0 then 
	messagebox("Data Err", "발주량이나 발주단가를 올바로 입력하세요..")
	this.setitem(al_row,"selt","N")
	this.setcolumn("qty")
end if
	
	
end event

event dw_body::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

this.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()
end event

event dw_body::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false

/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

choose case  dwo.name 
	case "selt" 
		post event ue_zero_check(row)
	case "mat_cd"

     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
end choose

	
end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
//	CASE KeyDownArrow!
//		IF This.GetRow() = This.RowCount() THEN
//		   This.InsertRow(This.GetRow() + 1)
//		END IF
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		// Column.Protect = True Then Return
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0 
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0 
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

Return 0
end event

type st_1 from w_com020_e`st_1 within w_cu131_e
integer x = 640
integer y = 308
integer height = 1740
end type

type dw_print from w_com020_e`dw_print within w_cu131_e
integer x = 402
integer y = 896
end type

type dw_asst from datawindow within w_cu131_e
event type long apply_qty_set ( )
integer y = 156
integer width = 635
integer height = 812
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_cu131_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long apply_qty_set();long i,j, ll_prot, ll_body_rows, ll_asst_rows
string ls_asst_color, ls_body_color
decimal ll_req_qty, ll_apply_qty, ll_qty, ll_price, ll_amt 

IF this.AcceptText() <> 1 THEN RETURN -1

ll_prot = dw_master.getitemnumber(1,"Prot")
if ll_prot = 1 then 
	messagebox("확인","입고된 발주서는 수정할수 없습니다..")
	return -1
end if

ll_asst_rows = dw_asst.rowcount()		
if ll_asst_rows <= 0 then return -1

ll_body_rows = dw_body.rowcount()		
if ll_body_rows <= 0 then return -1

for i = 1 to ll_asst_rows
	ls_asst_color = dw_asst.getitemstring(i,"color")
	ll_apply_qty  = dw_asst.getitemnumber(i,"apply_qty")
	for j = 1 to ll_body_rows
		ls_body_color = dw_body.getitemstring(j,"color")
		if ls_asst_color = ls_body_color then
			ll_req_qty = dw_body.getitemnumber(j,"req_qty")
			dw_body.setitem(j,"qty",ll_apply_qty * ll_req_qty)					
		end if
	next						
next 

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false

dw_body.Enabled = true


	
end event

event constructor;datawindowchild ldw_child


this.getchild("color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

end event

event buttonclicked;long i,j, ll_prot, ll_body_rows, ll_asst_rows
string ls_asst_color, ls_body_color
decimal ll_req_qty, ll_apply_qty, ll_qty, ll_price, ll_amt 

choose case dwo.name
	case "cb_apply"
		post event apply_qty_set()
		dw_body.enabled = true
		
end choose

	
end event

type dw_master from datawindow within w_cu131_e
boolean visible = false
integer x = 1417
integer y = 152
integer width = 1422
integer height = 120
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_cu131_m01"
boolean border = false
boolean livescroll = true
end type

