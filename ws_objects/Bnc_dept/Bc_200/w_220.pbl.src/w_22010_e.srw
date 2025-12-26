$PBExportHeader$w_22010_e.srw
$PBExportComments$원자재 재가공 등록
forward
global type w_22010_e from w_com010_e
end type
type dw_in from datawindow within w_22010_e
end type
end forward

global type w_22010_e from w_com010_e
integer height = 2344
windowstate windowstate = maximized!
dw_in dw_in
end type
global w_22010_e w_22010_e

type variables
DataWindowChild idw_brand, idw_color

String is_brand, is_io_gubn, is_out_ymd, is_mat_cd, is_cust_cd, is_in_ymd
long   il_in_row




end variables

on w_22010_e.create
int iCurrent
call super::create
this.dw_in=create dw_in
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_in
end on

on w_22010_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_in)
end on

event open;call super::open;inv_resize.of_Register(dw_in, "ScaleToRight")

dw_in.SetTransObject(SQLCA)


end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.27                                                  */	
/* 수정일      : 2002.02.27                                                  */
/*===========================================================================*/
string ls_in_ymd, ls_in_no, ls_mat_cd
	
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
il_rows = dw_in.retrieve(is_brand, is_in_ymd, '', 'xxxxxxxx', 'xxxx', is_cust_cd, is_mat_cd)
dw_body.reset()
if il_rows > 0 then		
	dw_in.setrow(1)
	ls_in_ymd = dw_in.getitemstring(1,"in_ymd")
	ls_in_no  = dw_in.getitemstring(1,"in_no")
	ls_mat_cd = dw_in.getitemstring(1,"mat_cd")
	il_rows = dw_body.retrieve(is_brand, 'in', is_out_ymd, ls_mat_cd, is_cust_cd, ls_in_ymd, 'Dat', ls_in_no)
	il_in_row = 1
end if

//dw_in.reset()
//IF il_rows > 0 and is_io_gubn = 'IN' THEN	
//	ls_in_ymd = dw_body.getitemstring(1,"in_ymd")
//	ls_in_no  = dw_body.getitemstring(1,"in_no")	
//	il_rows = dw_in.retrieve(is_brand, ls_in_ymd, ls_in_no, 'xxxxxxxx', 'xxxx')
	
//   dw_body.SetFocus()
//END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.27                                                  */	
/* 수정일      : 2002.02.27                                                  */
/*===========================================================================*/
String     ls_cust_nm, ls_mat_nm, ls_color
Boolean    lb_check 
DataStore  lds_Source
Long       i, ll_find


CHOOSE CASE as_column
	CASE "mat_cd"				
			IF ai_div = 1 THEN
				if isnull(as_data) or LenA(as_data) = 0 then 
					return 0					
				elseIF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
					dw_head.SetItem(al_row, "mat_nm",ls_mat_nm)
					RETURN 0				
				END IF 


			END IF
		   gst_cd.ai_div          = ai_div
			is_brand = dw_head.getitemstring(1,"brand")
			
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
			gst_cd.default_where   = "Where brand     = case when '" + is_brand + "' = 'J' then 'N' "      + &
																	" when '" + is_brand + "' = 'Y' then 'O' "      + &
																	" else '" + is_brand + "' end "      + &
			                         "  and cust_code between '7000' and '8999'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (custcode LIKE '%" + as_data + "%' or cust_sname like '%" + as_data + "%')"
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
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.27                                                  */	
/* 수정일      : 2002.02.27                                                  */
/*===========================================================================*/
String   ls_title


IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	


is_io_gubn = dw_head.getitemstring(1,"io_gubn")
is_out_ymd = dw_head.getitemstring(1,"out_ymd")
is_mat_cd  = dw_head.getitemstring(1,"mat_cd")
is_cust_cd = dw_head.getitemstring(1,"cust_cd")
is_in_ymd  = dw_head.getitemstring(1,"in_ymd")


if as_cb_div = '2' and is_io_gubn = "OUT" then 
	if IsNull(is_cust_cd) or LenA(is_cust_cd) <> 6 then
		MessageBox(ls_title,"거래처 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("cust_cd")
		return false

	elseif IsNull(is_out_ymd) or LenA(is_out_ymd) <> 8 then
		MessageBox(ls_title,"출고일자를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("out_ymd")
		return false
	end if
end if


IF as_cb_div = '1' THEN
	ls_title = "조회오류"
ELSEIF as_cb_div = '2' THEN
	ls_title = "추가오류"
	if isnull(is_in_ymd) or LenA(is_in_ymd) = 0 or not gf_datechk(is_in_ymd) then
		MessageBox(ls_title,"입고일자를 입력하십시요!")
		dw_head.setcolumn("in_ymd")
		dw_head.setfocus()
		return false
	end if
	
ELSEIF as_cb_div = '3' THEN
	ls_title = "저장오류"
ELSE
	ls_title = "오류"
END IF

return true

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_max_no
string ls_act, ls_io_gubn
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_io_gubn = dw_head.getitemstring(1,"io_gubn")

if ls_io_gubn = 'IN' then
		SELECT CAST(ISNULL(MAX(IN_NO), '0') AS INT)
		  INTO :ll_max_no
		  FROM TB_22010_H
		 WHERE BRAND   = :is_brand
			AND in_YMD  = :is_in_ymd
			AND in_GUBN = '03'
		;
		
		If SQLCA.SQLCODE <> 0 Then
			MessageBox("저장오류", "입고번호 채번에 실패하였습니다!")
			Return -1
		End If

		if isnull(ll_max_no) then ll_max_no = 0
		
		ll_max_no = ll_max_no + 1
		
		
		idw_status = dw_in.GetItemStatus(1, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record */
			dw_in.setitem(1, "in_ymd", is_in_ymd)
			dw_in.setitem(1, "in_no", String(ll_max_no, '0000'))
			dw_in.Setitem(1, "reg_id", gs_user_id)			
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
			dw_in.Setitem(1, "mod_id", gs_user_id)
			dw_in.Setitem(1, "mod_dt", ld_datetime)
		END IF
		
	
		il_rows = dw_in.Update(TRUE, FALSE)
		if il_rows = 1 then
			dw_in.ResetUpdate()
			FOR i=1 TO ll_row_count
				ls_act = dw_body.getitemstring(i,"act")
				
				idw_status = dw_body.GetItemStatus(i, 0, Primary!)
				IF idw_status = NewModified! THEN				/* New Record */
					if ls_act = "N" then				
						dw_body.setitem(i, "in_ymd", setnull(ls_act))
						dw_body.setitem(i, "in_no", setnull(ls_act))
					else
						dw_body.setitem(i, "in_ymd", is_in_ymd)
						dw_body.setitem(i, "in_no", String(ll_max_no, '0000'))				
						dw_body.setitem(i, "in_brand", is_brand)						
					end if
					dw_body.Setitem(i, "mod_id", gs_user_id)
					dw_body.Setitem(i, "mod_dt", ld_datetime)					
				ELSEIF idw_status = DataModified! THEN		/* Modify Record */
					dw_body.Setitem(i, "mod_id", gs_user_id)
					dw_body.Setitem(i, "mod_dt", ld_datetime)
					if ls_act = "N" then				
						dw_body.setitem(i, "in_ymd", setnull(ls_act))
						dw_body.setitem(i, "in_no", setnull(ls_act))		
					else
						dw_body.setitem(i, "in_ymd", is_in_ymd)
						dw_body.setitem(i, "in_no", String(ll_max_no, '0000'))
						dw_body.setitem(i, "in_brand", is_brand)
					end if			
				END IF
			NEXT
			
			il_rows = dw_body.Update(TRUE, FALSE)
		
			if il_rows = 1 then
				dw_body.ResetUpdate()
				commit  USING SQLCA;
			else
				rollback  USING SQLCA;		
			end if
		else
			rollback  USING SQLCA;
		end if
else

		SELECT CAST(ISNULL(MAX(out_NO), '0') AS INT)
		  INTO :ll_max_no
		  FROM TB_22020_H
		 WHERE BRAND    = :is_brand
			AND out_YMD  = :is_out_ymd
			AND out_GUBN = '03'
		;
		
		If SQLCA.SQLCODE <> 0 Then
			MessageBox("저장오류", "출고번호 채번에 실패하였습니다!")
			Return -1
		End If
									

		FOR i=1 TO ll_row_count			
			idw_status = dw_body.GetItemStatus(i, 0, Primary!)
			IF idw_status = NewModified! THEN				/* New Record */
				dw_body.setitem(i, "out_ymd", is_out_ymd)
				dw_body.setitem(i, "out_no", String(ll_max_no + 1, '0000'))
				
				ll_max_no = ll_max_no + 1
				
				dw_body.Setitem(i, "reg_id", gs_user_id)
			ELSEIF idw_status = DataModified! THEN		/* Modify Record */
				dw_body.Setitem(i, "mod_id", gs_user_id)
				dw_body.Setitem(i, "mod_dt", ld_datetime)
		
			END IF
		NEXT
		
		il_rows = dw_body.Update(TRUE, FALSE)
	
		if il_rows = 1 then
			dw_body.ResetUpdate()
			commit  USING SQLCA;
		else
			rollback  USING SQLCA;		
		end if

end if		
	
		
This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows



end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)권 진택                                                 */	
/* 작성일      : 2002.02.28                                                  */	
/* 수정일      : 2002.02.28                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text =    '" + is_pgm_id + "'" + &
            "t_user_id.Text =  '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text =    '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_yymmdd.Text =   '" + String(is_in_ymd, '@@@@/@@/@@') + "'" + &
            "t_cust_cd.Text =  '" + is_cust_cd + "'" + &
            "t_cust_nm.Text =  '" + dw_head.GetItemString(1, "cust_nm") + "'"

dw_print.Modify(ls_modify)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
			cb_insert.enabled = false
         dw_head.Enabled = false
         dw_body.Enabled = true
			dw_in.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			cb_insert.enabled = false
			
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
				dw_in.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_in.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled  = false
      cb_print.enabled   = false
      cb_preview.enabled = false
      cb_excel.enabled   = false
      cb_update.enabled  = false
		cb_insert.enabled  = true
      ib_changed = false
      dw_body.Enabled = false
      dw_in.Enabled = false		
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event ue_insert();	/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
long i
string ls_io_gubn

ls_io_gubn = dw_head.getitemstring(1,"io_gubn")

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */

if dw_head.enabled = true then
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_in.Reset()
	dw_body.Reset()
end if

il_rows = dw_body.retrieve(is_brand, is_io_gubn, is_out_ymd, is_mat_cd, is_cust_cd, is_in_ymd, 'New','')
IF il_rows > 0 THEN
	if ls_io_gubn = "OUT" then
		for i = 1 to dw_body.rowcount()
			dw_body.SetItemStatus(i, 0, Primary!,NewModified!)
		next 		
		cb_update.enabled = true
	end if
   dw_body.SetFocus()
END If


/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"out_ymd",string(ld_datetime,"yyyymmdd"))
	dw_head.setitem(1,"in_ymd" ,string(ld_datetime,"yyyymmdd"))	
end if
end event

event ue_delete();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row

ll_cur_row = dw_in.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_in.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_in.DeleteRow (ll_cur_row)
//dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22010_e","0")
end event

type cb_close from w_com010_e`cb_close within w_22010_e
end type

type cb_delete from w_com010_e`cb_delete within w_22010_e
boolean enabled = true
end type

type cb_insert from w_com010_e`cb_insert within w_22010_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_22010_e
end type

type cb_update from w_com010_e`cb_update within w_22010_e
end type

type cb_print from w_com010_e`cb_print within w_22010_e
end type

type cb_preview from w_com010_e`cb_preview within w_22010_e
end type

type gb_button from w_com010_e`gb_button within w_22010_e
end type

type cb_excel from w_com010_e`cb_excel within w_22010_e
end type

type dw_head from w_com010_e`dw_head within w_22010_e
integer x = 27
integer width = 3529
integer height = 220
string dataobject = "d_22010_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.27                                                  */	
/* 수정일      : 2002.02.27                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(row, "cust_cd", "")
		This.SetItem(row, "cust_nm", "")

	CASE "mat_cd", "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		This.SetItem(row, dwo.name, "")

		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_22010_e
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_e`ln_2 within w_22010_e
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_e`dw_body within w_22010_e
event set_qty ( )
event set_act_qty ( )
integer y = 1100
integer height = 940
string dataobject = "d_22010_d01"
boolean hscrollbar = true
end type

event dw_body::set_act_qty();decimal ll_act_qty, ll_out_price, ll_out_amt

ll_act_qty   = this.getitemnumber(il_in_row,"s_act_qty")
ll_out_price = this.getitemnumber(il_in_row,"s_act_price")
ll_out_amt   = this.getitemnumber(il_in_row,"s_act_amt")

if ll_act_qty <= 0 then
	dw_in.deleterow(il_in_row)
else
	dw_in.setitem(il_in_row,"tmp_qty",ll_act_qty)
	dw_in.setitem(il_in_row,"sil_qty",ll_act_qty)
	
	dw_in.setitem(il_in_row,"out_price", ll_out_price)
	dw_in.setitem(il_in_row,"out_amt", ll_out_amt)
end if

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.27                                                  */	
/* 수정일      : 2002.02.27                                                  */
/*===========================================================================*/
string ls_brand, ls_out_ymd, ls_out_no, ls_in_ymd, ls_in_no
decimal	ll_act_qty



CHOOSE CASE dwo.name
	CASE "act" 
		if is_io_gubn = 'IN' then
			if dw_in.rowcount()  = 0 then
				ls_brand   = dw_body.getitemstring(row,"brand")
				ls_out_ymd = dw_body.getitemstring(row,"out_ymd")
				ls_out_no  = dw_body.getitemstring(row,"out_no")
	//			ls_in_ymd  = dw_body.getitemstring(row,"in_ymd")
				ls_in_no   = dw_body.getitemstring(row,"in_no")			
	
				ls_in_ymd  = dw_head.getitemstring(1,"in_ymd")
				
				il_rows = dw_in.retrieve(ls_brand, ls_in_ymd, ls_in_no, ls_out_ymd, ls_out_no, is_cust_cd, is_mat_cd)					
				dw_in.SetItemStatus(1, 0, Primary!, NewModified!)
				
				il_in_row = 1
			end if
			
		end if
		post event set_act_qty()		
		
END CHOOSE



end event

event dw_body::dberror;//
end event

event dw_body::buttonclicked;call super::buttonclicked;long ll_row
ll_row = dw_body.deleterow(dw_body.getrow())
if ll_row = 1 then	cb_update.enabled = true


	
end event

type dw_print from w_com010_e`dw_print within w_22010_e
integer x = 325
integer y = 1508
string dataobject = "d_22010_r01"
end type

type dw_in from datawindow within w_22010_e
event qty_sync_set ( string as_col_nm,  long as_row )
integer x = 5
integer y = 428
integer width = 3593
integer height = 664
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_22010_d02"
boolean border = false
boolean livescroll = true
end type

event qty_sync_set(string as_col_nm, long as_row);this.accepttext() 

choose case as_col_nm
	case "tmp_qty"
		this.setitem(as_row,"sil_qty", this.getitemnumber(as_row,"tmp_qty")  - this.getitemnumber(as_row,"dft_qty"))
		this.setitem(as_row,"amt"    , this.getitemnumber(as_row,"t_sil_qty") * this.getitemnumber(as_row,"price") )
		
	case "dft_qty"
		this.setitem(as_row,"sil_qty", this.getitemnumber(as_row,"tmp_qty")  - this.getitemnumber(as_row,"dft_qty"))
		this.setitem(as_row,"amt"    , this.getitemnumber(as_row,"t_sil_qty") * this.getitemnumber(as_row,"price") )
		
	case "price"
		this.setitem(as_row,"amt"  , this.getitemnumber(as_row,"t_sil_qty") * this.getitemnumber(as_row,"price") )
		
end choose

end event

event constructor;This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve()
end event

event itemchanged;ib_changed = true
cb_update.enabled = true


post event qty_sync_set(dwo.name, row)
end event

event clicked;STRING ls_in_ymd, ls_in_no, ls_mat_cd
if row > 0 then
	
	ls_in_ymd = this.getitemstring(row,"in_ymd")
	ls_in_no  = this.getitemstring(row,"in_no")
	ls_mat_cd = this.getitemstring(row,"mat_cd")
	if LenA(ls_in_ymd) = 8 and LenA(ls_in_no) = 4 then 
		il_rows = dw_body.retrieve(is_brand, 'in', is_out_ymd, ls_mat_cd, is_cust_cd, ls_in_ymd, 'Dat', ls_in_no)
		il_in_row = row
		this.setrow(row)
		this.scrolltorow(row)
		this.setcolumn("color")
	end if
end if
end event

