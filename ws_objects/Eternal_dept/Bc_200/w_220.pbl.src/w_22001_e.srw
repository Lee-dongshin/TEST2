$PBExportHeader$w_22001_e.srw
$PBExportComments$원자재 입고 등록
forward
global type w_22001_e from w_com020_e
end type
type dw_mast from u_dw within w_22001_e
end type
type dw_qc from u_dw within w_22001_e
end type
end forward

global type w_22001_e from w_com020_e
integer width = 3685
integer height = 2276
event type long ue_update_mast ( )
dw_mast dw_mast
dw_qc dw_qc
end type
global w_22001_e w_22001_e

type variables
String is_mat_cd 
String is_brand, is_year, is_season, is_sojae , is_house

string is_in_gubn, is_cust_cd, is_ord_ymd, is_in_ymd, is_in_no, is_color, is_flag

decimal il_tmp_qty

long il_qc_row, il_mast_row, il_list_row, il_body_row
boolean qc_changed, qc_error 

datetime id_datetime
end variables

forward prototypes
public function boolean wf_mat_chk (string as_mat_cd)
end prototypes

event ue_update_mast;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
datetime ld_datetime

IF dw_mast.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

dw_mast.SetItemStatus(0, 0, Primary!,Notmodified!)
dw_mast.SetItemStatus(dw_mast.getrow(), 8, Primary!,Datamodified!)

il_rows = dw_mast.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_mast.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

return il_rows

end event

public function boolean wf_mat_chk (string as_mat_cd);// 원자재 코드 CHECK
String ls_year_cd, ls_nm

IF isnull(as_mat_cd) OR LenA(as_mat_cd) <> 10 THEN Return False

// 자재 구분
IF MidA(as_mat_cd, 2, 1) <> '1' THEN Return False 

// 브랜드 
is_brand  = MidA(as_mat_cd, 1, 1)

IF gf_inter_nm('001', is_brand, ls_nm) <> 0 THEN Return False 
//시즌년도 
ls_year_cd   = MidA(as_mat_cd, 3, 1)

IF gf_inter_nm('002', ls_year_cd, ls_nm) <> 0 THEN Return False 
gf_get_inter_sub('002', ls_year_cd, '1', is_year)

// 시즌 
is_season = MidA(as_mat_cd, 4, 1)
IF gf_inter_nm('003', is_season, ls_nm) <> 0 THEN Return False 

is_sojae  = MidA(as_mat_cd, 5, 1)
IF gf_sojae_nm(is_sojae, ls_nm) <> 0 THEN Return False 

Return True
end function

on w_22001_e.create
int iCurrent
call super::create
this.dw_mast=create dw_mast
this.dw_qc=create dw_qc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mast
this.Control[iCurrent+2]=this.dw_qc
end on

on w_22001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_mast)
destroy(this.dw_qc)
end on

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_mast, "ScaleToRight")
inv_resize.of_Register(dw_qc, "ScaleToRight")

dw_mast.SetTransObject(SQLCA)
dw_qc.SetTransObject(SQLCA)
IF gf_cdate(id_datetime,0)  THEN  
//	dw_head.setitem(1,"ord_ymd",string(id_datetime,"yyyymmdd"))
	dw_head.setitem(1,"in_ymd",string(id_datetime,"yyyymmdd"))
end if



end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
String     ls_mat_nm, ls_cust_nm, ls_emp_nm 
Boolean    lb_check 
DataStore  lds_Source 


is_brand = dw_head.getitemstring(1,"brand")

CHOOSE CASE as_column
	CASE "mat_cd"				
			IF ai_div = 1 THEN
				if isnull(as_data) or LenA(as_data) = 0 then 
					return 0					
				elseIF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN

					 if gs_brand <> "K" then	
						RETURN 0
					 else	
							if gs_brand <> MidA(as_data,1,1) then
								Return 1
							else 
								RETURN 0
							end if	
					 end if							
				END IF 
				
				IF wf_mat_chk(as_data) THEN
					RETURN 0 
				ELSEIF LenA(as_data) = 10 THEN 
					MessageBox("오류", "원자재 코드가 형식에 맞지안습니다 !")
					Return 1				
				elseif isnull(as_data) or trim(as_data) = "" then
					return 0
				end if
				
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "원자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 
			
			gst_cd.default_where   = " where brand = '" + is_brand + "'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "mat_cd LIKE '%" + as_data + "%'"
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
				cb_retrieve.SetFocus()
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "cust_cd"				
			IF ai_div = 1 THEN
				if isnull(as_data) or LenA(as_data) = 0 then
					return 0
					
				elseIF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
					dw_head.Setitem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			gst_cd.default_where   = "Where brand     like case when '" + is_brand + "' in ('B','L','V','F','G','S', 'K') then '[N" + is_brand + "]%' "      + &
																	" when '" + is_brand + "' = 'Y' then 'O' "      + &
																	" else '" + is_brand + "' end + '%'  "      + &
			                         "  and cust_code between '5000' and '8999'"
											 
	   	if gs_brand <> "K" then	
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_name like '%" + as_data + "%' or cust_sname like '%" + as_data + "%')" 
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

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "cust_cd",    lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				dw_head.TriggerEvent(Editchanged!)
				dw_head.SetColumn("ord_ymd")
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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
String   ls_title

is_house =  dw_head.GetItemString(1, "house")

if as_cb_div = '7' then 
	IF dw_body.AcceptText() <> 1 THEN RETURN FALSE
	is_brand   = dw_body.GetItemString(il_body_row, "brand")
	is_in_ymd  = dw_body.GetItemString(il_body_row, "in_ymd")
	is_in_gubn = dw_body.GetItemString(il_body_row, "in_gubn")
	is_in_no   = dw_body.GetItemString(il_body_row, "in_no")
	is_mat_cd  = dw_body.GetItemString(il_body_row, "mat_cd")
	is_color   = dw_body.GetItemString(il_body_row, "color")
	il_tmp_qty = dw_body.GetItemnumber(il_body_row, "tmp_qty")	
	is_flag    = dw_body.GetItemstring(il_body_row, "flag")	
	
elseif as_cb_div = '8' then 
	IF dw_list.AcceptText() <> 1 THEN RETURN FALSE
	is_brand   = dw_list.GetItemString(il_list_row, "brand")
	is_mat_cd  = dw_list.GetItemString(il_list_row, "mat_cd")
	is_in_ymd  = dw_list.GetItemString(il_list_row, "in_ymd")
	is_in_gubn = dw_list.GetItemString(il_list_row, "in_gubn")
	is_cust_cd = dw_list.GetItemString(il_list_row, "cust_cd")	
		
elseif as_cb_div = '9' then 
	IF dw_mast.AcceptText() <> 1 THEN RETURN FALSE
	is_brand   = dw_mast.GetItemString(il_mast_row, "brand")
	is_mat_cd  = LeftA(dw_mast.GetItemString(il_mast_row, "mat_cd"),10)
	is_in_ymd  = dw_mast.GetItemString(il_mast_row, "in_ymd")
	is_in_gubn = dw_head.GetItemString(1, "in_gubn")
else
	IF dw_head.AcceptText() <> 1 THEN RETURN FALSE		
	is_brand   = dw_head.GetItemString(1, "brand")
	is_in_gubn = dw_head.GetItemString(1, "in_gubn")
	is_cust_cd = dw_head.GetItemString(1, "cust_cd")
	is_ord_ymd = dw_head.GetItemString(1, "ord_ymd")
	is_in_ymd  = dw_head.GetItemString(1, "in_ymd")
	is_mat_cd  = dw_head.GetItemString(1, "mat_cd")
end if

IF as_cb_div = '1' THEN
	ls_title = "조회오류"
ELSEIF as_cb_div = '2' THEN
	ls_title = "추가오류"
	if not gf_datechk(is_in_ymd) then 
		messagebox(ls_title,"입고일자를 올바로 입력하세요..")
		return	false
	end if

ELSEIF as_cb_div = '3' THEN
	ls_title = "저장오류"
ELSE
	ls_title = "오류"
END IF

return true

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/
long prot

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
			dw_head.setitem(1,'prot',1)
         dw_list.Enabled = true

         dw_body.Enabled = false

			cb_update.enabled = false			
			cb_delete.enabled = false

		else
         dw_head.SetFocus()
      end if

   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			cb_insert.enabled = false 
			cb_retrieve.Text = "조건(&Q)"
			dw_head.Enabled = false
			dw_head.setitem(1,'prot',1)
			dw_mast.Enabled = true

	end if


	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
			cb_insert.enabled = true //
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> Newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_insert.enabled  = true
      cb_delete.enabled  = false
      cb_print.enabled   = false
      cb_preview.enabled = false
      cb_excel.enabled   = false
      cb_update.enabled  = false
      ib_changed = false
		
      dw_body.Enabled = false				
      dw_head.Enabled = true
		dw_head.setitem(1,'prot',0)		
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
			cb_delete.enabled = true
			dw_body.enabled = true	
      end if
			
END CHOOSE

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//il_rows = dw_list.retrieve(is_brand, '110000',is_cust_cd, is_in_ymd, is_in_gubn, is_mat_cd, is_ord_ymd)
il_rows = dw_list.retrieve(is_brand, is_house ,is_cust_cd, is_in_ymd, is_in_gubn, is_mat_cd, is_ord_ymd)

dw_mast.Reset()
dw_body.Reset()
dw_qc.reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_insert();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */

IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
		
il_rows = dw_mast.retrieve(is_brand, is_cust_cd, is_ord_ymd, is_mat_cd, is_in_ymd, 'Dat')
dw_body.Reset()
dw_qc.reset()
IF il_rows > 0 THEN
   dw_mast.SetFocus()
END IF


/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_in_no, qc_row_count, qc_row
string 	qc_in_no
datetime ld_datetime
decimal ll_qty




ll_row_count = dw_body.RowCount()
qc_row_count = dw_qc.rowcount()

IF dw_body.AcceptText() <> 1 THEN RETURN -1
//IF dw_qc.AcceptText()   <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

is_brand   = dw_body.getitemstring(1,'brand')
is_in_ymd  = dw_body.getitemstring(1,'in_ymd')
is_in_gubn = dw_body.getitemstring(1,'in_gubn')

select  
convert(int,isnull(max(in_no),'0000'))+1
into :ll_in_no
from tb_22010_h 
where brand   = :is_brand 
and   in_ymd  = :is_in_ymd
and   in_gubn = :is_in_gubn;


FOR i=1 TO ll_row_count
	ll_qty = dw_body.getitemnumber(i,"sil_qty")
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */		
		
      dw_body.Setitem(i, "reg_id", gs_user_id)
		dw_body.setitem(i, "in_no" ,string(ll_in_no,"0000"))								//임고번호
	
//		dw_qc.Setitem(i, "reg_id", gs_user_id)
//		dw_qc.setitem(i, "in_no" ,string(ll_in_no,"0000"))	
		
		ll_in_no = ll_in_no + 1		
		
		if ll_qty < 0 then 
			dw_body.setitem(i,"io_gubn","-")
		end if
		
	ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
		
		if ll_qty < 0 then dw_body.setitem(i,"io_gubn","-")
	END IF
NEXT



il_rows = dw_body.Update(TRUE, FALSE)
//if il_rows  = 1 then
//	il_rows = dw_qc.Update(TRUE, FALSE)
//end if

if il_rows = 1 then
   dw_body.ResetUpdate()
//	dw_qc.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows


end event

event ue_delete();long i, as_row, qc_row, ll_cur_row

/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	
il_rows = dw_body.DeleteRow (ll_cur_row)
//il_rows = dw_qc.DeleteRow (ll_cur_row)

//검단은 트리거에서 자동삭제 처리
//for i = 1 to dw_qc.rowcount()
//	
//	qc_row = dw_qc.GetItemnumber(i, "qc_row")
//	if qc_row = ll_cur_row then
//		il_rows = dw_qc.DeleteRow (qc_row)
//	end if
//	
//next 

dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)	
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22001_e","0")
end event

type cb_close from w_com020_e`cb_close within w_22001_e
integer taborder = 140
end type

type cb_delete from w_com020_e`cb_delete within w_22001_e
integer taborder = 90
end type

type cb_insert from w_com020_e`cb_insert within w_22001_e
integer taborder = 80
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_22001_e
end type

type cb_update from w_com020_e`cb_update within w_22001_e
integer taborder = 130
end type

type cb_print from w_com020_e`cb_print within w_22001_e
boolean visible = false
integer taborder = 100
end type

type cb_preview from w_com020_e`cb_preview within w_22001_e
boolean visible = false
integer taborder = 110
end type

type gb_button from w_com020_e`gb_button within w_22001_e
end type

type cb_excel from w_com020_e`cb_excel within w_22001_e
boolean visible = false
integer taborder = 120
end type

type dw_head from w_com020_e`dw_head within w_22001_e
integer x = 9
integer y = 152
integer width = 3589
integer height = 184
string dataobject = "d_22001_h01"
boolean border = true
borderstyle borderstyle = styleraised!
end type

event dw_head::constructor;DataWindowChild ldw_child


This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('001')



end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
//ib_changed = true
//cb_update.enabled = true
cb_print.enabled    = false
cb_preview.enabled  = false
cb_excel.enabled    = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "colunm1" 
    IF data = 'A' THEN
	      /*action*/
    END IF
	CASE "cust_cd","mat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::editchanged;call super::editchanged;choose case dwo.name 
	case "mat_cd"
		if LenA(data) = 1 then	this.setitem(1,"brand",LeftA(data,1))
end choose

			
end event

type ln_1 from w_com020_e`ln_1 within w_22001_e
boolean visible = false
integer beginy = 1036
integer endy = 1036
end type

type ln_2 from w_com020_e`ln_2 within w_22001_e
boolean visible = false
integer beginy = 1040
integer endy = 1040
end type

type dw_list from w_com020_e`dw_list within w_22001_e
integer x = 9
integer y = 1048
integer width = 777
integer height = 992
string dataobject = "d_22001_l01"
end type

event dw_list::doubleclicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
string ls_flag

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

il_list_row = row
IF Trigger Event ue_keycheck('8') = FALSE THEN RETURN

il_rows = dw_qc.retrieve(is_mat_cd)

il_rows = dw_body.retrieve(is_brand, is_mat_cd, is_in_ymd, is_in_gubn, is_cust_cd, 'Dat', is_house)
IF il_rows > 0 THEN
	for i = 1 to il_rows
			ls_flag = dw_body.getitemstring(i,"flag")
			if ls_flag = 'New' then 
			   dw_body.SetItemStatus(i, 0, Primary!, New!)
			end if
	next 


   dw_body.SetFocus()
	dw_body.setcolumn('tmp_qty')
	
	if is_in_ymd = string(id_datetime,"YYYYMMDD") then 
		cb_delete.enabled = true	
	else 
		cb_delete.enabled = false			
	end if
END IF

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_22001_e
event type long ue_qc ( long as_row )
event ue_claim_set ( long al_body_row,  string as_flag )
event ue_set_sil_qty ( long al_row )
integer y = 1864
integer width = 2798
integer height = 176
integer taborder = 60
string dataobject = "d_22001_d02"
boolean hscrollbar = true
end type

event dw_body::ue_claim_set(long al_body_row, string as_flag);decimal ldc_amt, ldc_dely, ldc_claim_amt
string ls_chno

ls_chno  = this.GetitemString(al_body_row,'mat_chno')
ldc_dely = this.GetitemDecimal(al_body_row,'dely_cnt')
ldc_amt  = this.GetitemDecimal(al_body_row,'amt')	
	
if as_flag = 'New' and ldc_dely > 0 then 		
	if ls_chno = '0' then 
				if     ldc_dely >= 4  and ldc_dely <= 7  	then 
						ldc_claim_amt = truncate(ldc_amt * 0.03,0)
						
				elseif ldc_dely >= 8  and ldc_dely <= 10 	then 
						ldc_claim_amt = truncate(ldc_amt * 0.05,0)
						
				elseif ldc_dely >= 11 and ldc_dely <= 15 	then  
						ldc_claim_amt = truncate(ldc_amt * 0.10,0)
						
				elseif ldc_dely  > 15             			then  
						ldc_claim_amt = truncate(ldc_amt * 0.10,0)
						
				end if
	else
				if     ldc_dely >= 3 and ldc_dely <= 5  	then  
						ldc_claim_amt = truncate(ldc_amt * 0.03,0)
						
				elseif ldc_dely >= 6 and ldc_dely <= 8  	then  
						ldc_claim_amt = truncate(ldc_amt * 0.06,0)
						
				elseif ldc_dely > 8               			then  
						ldc_claim_amt = truncate(ldc_amt * 0.10,0)
						
				end if				
	end if 
	this.SetItem(al_body_row, 'claim_amt', ldc_claim_amt)
end if

return 


end event

event dw_body::ue_set_sil_qty(long al_row);		double ld_defect, ld_tmp_qty, ld_price
		string ls_qc_gbn
		
	
//		ld_defect = dw_qc.getitemnumber(al_row,"defect")
		ld_defect = dw_body.getitemnumber(al_row,"dft_qty")
		ld_tmp_qty = dw_body.getitemnumber(al_row,"tmp_qty")
		ld_price   = dw_body.getitemnumber(al_row,"price")
				
		if isnull(ld_defect) then ld_defect = 0
		if isnull(ld_tmp_qty) then ld_tmp_qty = 0
		
		
//		dw_body.setitem(al_row,"dft_qty",ld_defect)
		
//		ls_qc_gbn = dw_body.getitemstring(al_row,"qc_gbn")
//		if ls_qc_gbn = 'Y' then 
			dw_body.setitem(al_row,"sil_qty", ld_tmp_qty - ld_defect)
			dw_body.setitem(al_row,"amt", (ld_tmp_qty - ld_defect) * ld_price)
//		end if
end event

event dw_body::constructor;DataWindowChild ldw_child

This.GetChild("color", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve()


/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

event dw_body::itemchanged;decimal ll_ord_qty, ll_in_qty, ll_tmp_qty, ll_dft_qty, ll_price
string ls_flag

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false


choose case dwo.name
	case 'qc_gbn'
		post event ue_set_sil_qty(row)
			
	case 'tmp_qty'
		ll_tmp_qty = gf_nulltozero(dec(data))
		ll_ord_qty = gf_nulltozero(this.getitemnumber(row,'ord_qty'))
		ll_in_qty  = gf_nulltozero(this.getitemnumber(row,'in_qty'))	

		dw_qc.setitem(row,"tmp_qty", ll_tmp_qty)
	
//		if ll_tmp_qty > (ll_ord_qty - ll_in_qty) then
//			messagebox("주의","가입고량이 미입고량을 초과하였습니다..")
//		end if

	//	if this.trigger event ue_qc(row)	= 0 then return 1
	//	dw_qc1.post event ue_qc_confirm('tmp_qty',ll_tmp_qty)
	case 'price'
			ls_flag = this.GetItemString(row,'flag')			
			post event ue_claim_set(row, ls_flag)
		
end choose


end event

event dw_body::dberror;//
end event

event dw_body::buttonclicked;call super::buttonclicked;Long	ll_row_count, i, ll_price, ll_price_now, ll_qty
integer  Net
String ls_mat_cd

CHOOSE CASE dwo.name
	CASE "cb_apply_price"
		
	
		ll_row_count = this.rowcount()
		
		
		for i = 1 to ll_row_count
			ls_mat_cd = this.getitemString(i, "mat_cd")
			ll_price_now = this.getitemNumber(i, "price")
			ll_qty =  this.getitemNumber(i, "in_qty")
			
			SELECT nego_price
			into :ll_price
			FROM tb_21011_d(nolock) 
			WHERE mat_cd = :ls_mat_cd;

			
			if ll_price_now <> ll_price then
				
				Net = MessageBox("주의!", "입고단가가 변경됩니다 처리하시겠습니까?", Exclamation!, OKCancel!, 2)
				IF Net = 1 THEN
					this.setitem(1, "price", ll_price)	
					this.setitem(1, "amt", ll_price * ll_qty)						
					ib_changed = true
					cb_update.enabled = true
				END IF
				
			
			end if	
			
		next	
		
		
		
END CHOOSE


end event

type st_1 from w_com020_e`st_1 within w_22001_e
integer y = 1048
integer height = 992
end type

event st_1::ue_mouseup;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.26                                                  */
/*===========================================================================*/

If Not ib_debug Then This.BackColor = il_hiddencolor

// 화면에 벗어 났을 경우 처리 
IF This.x < idrg_vertical[1].x + 50 THEN
   This.x = idrg_vertical[1].x + 50		
ELSEIF This.x > idrg_vertical[2].width + idrg_vertical[2].x - 50 THEN
	This.x = idrg_vertical[2].width + idrg_vertical[2].x - 50	
END IF

dw_qc.x = this.x + 25
// Data Window 크기 변경
wf_ResizePanels()

end event

type dw_print from w_com020_e`dw_print within w_22001_e
end type

type dw_mast from u_dw within w_22001_e
integer x = 9
integer y = 340
integer width = 3589
integer height = 712
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_22001_d01"
boolean hscrollbar = true
borderstyle borderstyle = styleraised!
end type

event doubleclicked;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
string ls_fin_yn, ls_flag

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF


/* dw_head 필수입력 column check */
il_mast_row = row
IF Trigger Event ue_keycheck('9') = FALSE THEN RETURN

il_rows = dw_qc.retrieve(is_mat_cd)

il_rows = dw_body.retrieve(is_brand, is_mat_cd, is_in_ymd, is_in_gubn, is_cust_cd, 'New', is_house)
IF il_rows > 0 THEN
	for i = 1 to il_rows
		dw_body.SetItemStatus(i, 0, Primary!,New!)
	next
	
	dw_body.SetFocus()
	dw_body.setcolumn('tmp_qty')
	cb_delete.enabled = true
END IF

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)


end event

event constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
DataWindowChild ldw_child

This.GetChild("in_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('022')

This.GetChild("status_fg", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('201')


end event

event itemchanged;parent.post event ue_update_mast()


end event

event clicked;call super::clicked;This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)	
end event

event dberror;//
end event

type dw_qc from u_dw within w_22001_e
event ue_keydwon pbm_dwnkey
event ue_set_defect ( long al_row )
integer x = 805
integer y = 1048
integer width = 2798
integer height = 820
integer taborder = 70
string dataobject = "d_22001_d03"
boolean hscrollbar = true
end type

event ue_keydwon;/*===========================================================================*/
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
		return 1
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

RETURN 0
end event

event ue_set_defect(long al_row);double ld_defect, ld_tmp_qty, ld_price
string ls_qc_gbn

ld_defect = this.getitemnumber(al_row,"defect")
ld_tmp_qty = dw_body.getitemnumber(al_row,"tmp_qty")
ld_price   = dw_body.getitemnumber(al_row,"price")

if isnull(ld_defect) then ld_defect = 0
if isnull(ld_tmp_qty) then ld_tmp_qty = 0


dw_body.setitem(al_row,"dft_qty",ld_defect)

ls_qc_gbn = dw_body.getitemstring(al_row,"qc_gbn")
if ls_qc_gbn = 'Y' then 
	dw_body.setitem(al_row,"sil_qty", ld_tmp_qty - ld_defect)
	dw_body.setitem(al_row,"amt", (ld_tmp_qty - ld_defect) * ld_price)
end if


end event

event constructor;DataWindowChild ldw_child


This.GetChild("color", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('')
end event

event itemchanged;call super::itemchanged;//ib_changed = true
//cb_update.enabled = true
//cb_print.enabled = false
//cb_preview.enabled = false
//cb_excel.enabled = false
//
//post event ue_set_defect(row)


end event

event editchanged;call super::editchanged;//ib_changed = true
//cb_update.enabled = true
//cb_print.enabled = false
//cb_preview.enabled = false
//cb_excel.enabled = false
//
//IF dw_qc.AcceptText()   <> 1 THEN RETURN -1
//
//dw_body.post event ue_set_sil_qty(row)
end event

