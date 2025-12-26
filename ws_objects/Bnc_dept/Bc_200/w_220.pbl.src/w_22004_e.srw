$PBExportHeader$w_22004_e.srw
$PBExportComments$부자재 입고 등록
forward
global type w_22004_e from w_com020_e
end type
type dw_mast from u_dw within w_22004_e
end type
type rb_mat from radiobutton within w_22004_e
end type
type rb_style from radiobutton within w_22004_e
end type
end forward

global type w_22004_e from w_com020_e
integer width = 3648
integer height = 2260
event type long ue_update_mast ( )
dw_mast dw_mast
rb_mat rb_mat
rb_style rb_style
end type
global w_22004_e w_22004_e

type variables
dragobject   idrg_vertical2[2]

String is_brand, is_year, is_season, is_sojae, is_ord_type = "1"
string is_ord_origin, is_in_gubn, is_cust_cd, is_ord_ymd, is_ord_no, is_in_ymd, is_in_no, is_flag

long il_mast_row, il_list_row, il_body_row

datetime id_datetime
end variables

forward prototypes
public function boolean wf_mat_chk (string as_mat_cd)
public function integer wf_resizepanels ()
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

public function integer wf_resizepanels ();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.26                                                  */
/*===========================================================================*/
// DataWindow 위치 및 크기 변경
Long		ll_Width

ll_Width = idrg_Vertical[2].X + idrg_Vertical[2].Width - st_1.X - ii_BarThickness

idrg_Vertical[1].Resize (st_1.X - idrg_Vertical[1].X, idrg_Vertical[1].Height)

idrg_Vertical[2].Move (st_1.X + ii_BarThickness, idrg_Vertical[2].Y)
idrg_Vertical[2].Resize (ll_Width, idrg_Vertical[2].Height)


idrg_Vertical2[1].Move (st_1.X + ii_BarThickness, idrg_Vertical2[1].Y)
idrg_Vertical2[1].Resize (ll_Width, idrg_Vertical2[1].Height)

Return 1


end function

on w_22004_e.create
int iCurrent
call super::create
this.dw_mast=create dw_mast
this.rb_mat=create rb_mat
this.rb_style=create rb_style
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mast
this.Control[iCurrent+2]=this.rb_mat
this.Control[iCurrent+3]=this.rb_style
end on

on w_22004_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_mast)
destroy(this.rb_mat)
destroy(this.rb_style)
end on

event pfc_preopen;call super::pfc_preopen;datetime ld_datetime

inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_mast, "ScaleToRight")


dw_mast.SetTransObject(SQLCA)
idrg_Vertical2[1] = dw_mast

IF gf_cdate(id_datetime,0)  THEN  
	dw_head.setitem(1,"ord_ymd",string(id_datetime,"yyyymmdd"))
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
	case "ord_origin"
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
				gst_cd.Item_where = " style like '%" + as_data +"%'"
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
				if isnull(as_data) or trim(as_data) = "" then
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
				gst_cd.Item_where = " mat_cd like '%" + as_data + "%'"
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
	CASE "cust_cd"				
			IF ai_div = 1 THEN 	
				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
					dw_head.Setitem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				 
				elseif isnull(as_data) or trim(as_data) = "" then 
					return 0
				end if
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			gst_cd.default_where   = "Where brand = case when '" + is_brand + "' in ('J','T','W','C') then 'N' "      + &
																	" when '" + is_brand + "' = 'Y' then 'O' "      + &
																	" else '" + is_brand + "' end "      + &
			                         "  and cust_code between '6000' and '9999'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (custcode LIKE '%" + as_data + "%' or cust_name like '%" + as_data + "%')" 
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
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
String   ls_title



if as_cb_div = '8' then 
	IF dw_list.AcceptText() <> 1 THEN RETURN FALSE
	is_brand      = dw_list.GetItemString(il_list_row, "brand")
	is_in_ymd     = dw_list.GetItemString(il_list_row, "in_ymd")
	is_in_gubn    = dw_list.GetItemString(il_list_row, "in_gubn")
	is_ord_origin = dw_list.GetItemString(il_list_row, "ord_origin")
	is_cust_cd    = dw_list.GetItemString(il_list_row, "cust_cd")	
		
elseif as_cb_div = '9' then 
	IF dw_mast.AcceptText() <> 1 THEN RETURN FALSE
	is_brand   = dw_mast.GetItemString(il_mast_row, "brand")
	is_ord_ymd = dw_mast.GetItemString(il_mast_row, "ord_ymd")
	is_ord_no  = dw_mast.GetItemString(il_mast_row, "ord_no")	
	is_ord_origin = dw_list.GetItemString(il_mast_row, "ord_origin")

else
	IF dw_head.AcceptText() <> 1 THEN RETURN FALSE		
	is_brand   = dw_head.GetItemString(1, "brand")
	is_in_gubn = dw_head.GetItemString(1, "in_gubn")
	is_cust_cd = dw_head.GetItemString(1, "cust_cd")
	is_ord_ymd = dw_head.GetItemString(1, "ord_ymd")
	is_in_ymd  = dw_head.GetItemString(1, "in_ymd")
	is_ord_origin  = dw_head.GetItemString(1, "ord_origin")
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
//			cb_excel.enabled = false
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
//			cb_excel.enabled = true
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
//         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_insert.enabled  = true
      cb_delete.enabled  = false
      cb_print.enabled   = false
      cb_preview.enabled = false
//      cb_excel.enabled   = false
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
//         cb_excel.enabled = true
		else
         cb_print.enabled = false
         cb_preview.enabled = false
//         cb_excel.enabled = false
		end if

      if al_rows >= 0 then
			cb_delete.enabled  = true
         ib_changed = false
         cb_update.enabled = false
			dw_body.enabled = true	
      end if
			
END CHOOSE

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, '110000',is_cust_cd, is_in_ymd, is_in_gubn, is_ord_origin, is_ord_ymd, is_ord_type)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */

IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN

il_rows = dw_mast.retrieve(is_brand, is_ord_ymd, is_cust_cd, is_ord_origin, is_ord_type, 'Dat')
dw_body.Reset()
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
long i, ll_row_count, ll_in_no
decimal ll_amt
datetime ld_datetime




ll_row_count = dw_body.RowCount()

IF dw_body.AcceptText() <> 1 THEN RETURN -1


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
	ll_amt = dw_body.getitemnumber(i,"ll_amt")

	
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
		if ll_amt = 0 then 
			dw_body.SetItemStatus(i, 0, Primary!,New!)
		else 
			dw_body.setitem(i,"amt",ll_amt)
			dw_body.Setitem(i, "reg_id", gs_user_id)
			dw_body.setitem(i, "in_no" ,string(ll_in_no,"0000"))								//임고번호
			ll_in_no = ll_in_no + 1		
		end if
	ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		dw_body.setitem(i,"amt",ll_amt)
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

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_delete;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row, prot

prot = dw_body.getitemnumber(il_body_row,"prot")

if prot = 1 then 
	messagebox("주의","삭제할 수 없는 데이타입니다..")
	return
end if

ll_cur_row = dw_body.GetRow()

if il_body_row <= 0 then return

idw_status = dw_body.GetItemStatus (il_body_row, 0, primary!)	
il_rows = dw_body.DeleteRow (il_body_row)

il_body_row = il_body_row  -1

dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22004_e","0")
end event

type cb_close from w_com020_e`cb_close within w_22004_e
integer taborder = 140
end type

type cb_delete from w_com020_e`cb_delete within w_22004_e
integer taborder = 90
boolean enabled = true
end type

type cb_insert from w_com020_e`cb_insert within w_22004_e
integer taborder = 80
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_22004_e
end type

type cb_update from w_com020_e`cb_update within w_22004_e
integer taborder = 130
end type

type cb_print from w_com020_e`cb_print within w_22004_e
boolean visible = false
integer taborder = 100
end type

type cb_preview from w_com020_e`cb_preview within w_22004_e
boolean visible = false
integer taborder = 110
end type

type gb_button from w_com020_e`gb_button within w_22004_e
end type

type cb_excel from w_com020_e`cb_excel within w_22004_e
integer width = 411
integer taborder = 120
boolean enabled = true
string text = "일일 입고마감"
end type

event cb_excel::clicked;//
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN 0

if isnull(is_brand) or is_brand = '' then 
		messagebox("주의", "브랜드를 올바로 입력해주세요..") 
		return 0
end if
	
if isnull(is_in_ymd) or is_in_ymd = '' then 
		messagebox("주의", "입고일자를 올바로 입력해주세요..") 
		return 0
end if	


if messagebox("확인","실행하시겠습니다...?",Exclamation!,YesNoCancel!,1 ) <> 1 then return 0

		 DECLARE sp_in_smat_daily PROCEDURE FOR sp_in_smat_daily  
					@brand     = :is_brand,  
					@yymmdd	  = :is_in_ymd;
					
		 execute sp_in_smat_daily;	
	commit  USING SQLCA;
	
messagebox("확인","정상처리되었슴니다...")
end event

type dw_head from w_com020_e`dw_head within w_22004_e
integer x = 9
integer y = 152
integer width = 3589
integer height = 184
string dataobject = "d_22004_h01"
boolean border = true
borderstyle borderstyle = styleraised!
end type

event dw_head::constructor;DataWindowChild ldw_child


This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('001')

This.GetChild("in_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('022')



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
//cb_excel.enabled    = false
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

type ln_1 from w_com020_e`ln_1 within w_22004_e
boolean visible = false
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com020_e`ln_2 within w_22004_e
boolean visible = false
integer beginy = 352
integer endy = 352
end type

type dw_list from w_com020_e`dw_list within w_22004_e
integer x = 9
integer y = 328
integer width = 777
integer height = 1712
string dataobject = "d_22004_l01"
end type

event dw_list::doubleclicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

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

il_rows = dw_body.retrieve(is_brand, is_ord_ymd, is_ord_no, is_in_ymd, is_in_gubn, is_ord_origin, is_cust_cd, 'Dat')
IF il_rows > 0 THEN
   dw_body.SetFocus()
	dw_body.setcolumn('sil_qty')
END IF

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_22004_e
integer y = 992
integer width = 2793
integer height = 1048
integer taborder = 60
string dataobject = "d_22004_d02"
boolean hscrollbar = true
end type

event dw_body::constructor;DataWindowChild ldw_child
This.GetChild("unit", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve("004")

This.GetChild("color", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve()

This.GetChild("mat_color", ldw_child)
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

event dw_body::itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
//cb_excel.enabled = false



end event

event dw_body::clicked;string ls_in_ymd
ls_in_ymd = this.getitemstring(row,"in_ymd")

//if ls_in_ymd = string(id_datetime,"YYYYMMDD") then 
//	cb_delete.enabled = true	
//else 
//	cb_delete.enabled = false			
//end if

il_body_row = row

end event

type st_1 from w_com020_e`st_1 within w_22004_e
integer y = 340
integer height = 1700
end type

type dw_print from w_com020_e`dw_print within w_22004_e
integer x = 32
integer y = 416
end type

type dw_mast from u_dw within w_22004_e
integer x = 805
integer y = 328
integer width = 2793
integer height = 660
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_22004_d01"
end type

event doubleclicked;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
string ls_fin_yn

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

il_rows = dw_body.retrieve(is_brand, is_ord_ymd, is_ord_no, is_in_ymd, is_in_gubn, is_ord_origin, is_cust_cd, 'New')
IF il_rows > 0 THEN
	for i = 1 to il_rows
		dw_body.SetItemStatus(i, 0, Primary!,New!)
	next
	
	dw_body.SetFocus()
	dw_body.setcolumn('sil_qty')
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

type rb_mat from radiobutton within w_22004_e
integer x = 2565
integer y = 248
integer width = 357
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
string text = "비축발주"
borderstyle borderstyle = styleraised!
end type

event clicked;is_ord_type = "0"

end event

type rb_style from radiobutton within w_22004_e
integer x = 2958
integer y = 248
integer width = 466
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
string text = "스타일별발주"
boolean checked = true
borderstyle borderstyle = styleraised!
end type

event clicked;is_ord_type = "1"
end event

