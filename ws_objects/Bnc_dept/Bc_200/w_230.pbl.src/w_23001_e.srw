$PBExportHeader$w_23001_e.srw
$PBExportComments$자재생산 클레임 등록
forward
global type w_23001_e from w_com020_e
end type
type dw_mast from u_dw within w_23001_e
end type
type dw_head2 from datawindow within w_23001_e
end type
end forward

global type w_23001_e from w_com020_e
integer width = 3680
integer height = 2256
event ue_smat_set ( )
event ue_qty_apply ( )
event type long ue_detail ( )
dw_mast dw_mast
dw_head2 dw_head2
end type
global w_23001_e w_23001_e

type variables
dragobject   idrg_vertical2[2]
string is_brand , is_claim_ymd, is_claim_no, is_style, is_chno, is_mat_cd, new, Flag, is_color
long il_head2_row, il_list_row, il_body_row

end variables

forward prototypes
public function integer wf_resizepanels ()
end prototypes

event ue_smat_set();double ll_pcs, ll_qty, ll_price, ll_amt, ll_claim_rate
long ll_row

//부자재 B급 통합금액 세팅

	ll_claim_rate = 50
	ll_row = dw_body.rowcount() -1
	
	ll_pcs = dw_body.getitemnumber(ll_row,"s_pcs3")
	ll_qty = ll_pcs
	ll_amt = dw_body.getitemnumber(ll_row,"s_amt3")
	ll_price = abs(2*ll_amt/ll_pcs)
	
	dw_body.setitem(ll_row,"pcs",ll_pcs)
	dw_body.setitem(ll_row,"qty",ll_qty)
	dw_body.setitem(ll_row,"ll_claim_rate",ll_claim_rate)
	dw_body.setitem(ll_row,"price",ll_price)
	dw_body.setitem(ll_row,"amt",ll_amt)
	
	//부자재 미작업 통합금액 세팅
	ll_claim_rate = 100
	ll_row = ll_row +1
	
	ll_pcs = dw_body.getitemnumber(ll_row,"s_pcs4")
	ll_qty = ll_pcs
	ll_amt = dw_body.getitemnumber(ll_row,"s_amt4")
	ll_price = abs(ll_amt/ll_pcs)
	
	dw_body.setitem(ll_row,"pcs",ll_pcs)
	dw_body.setitem(ll_row,"qty",ll_qty)
	dw_body.setitem(ll_row,"ll_claim_rate",ll_claim_rate)
	dw_body.setitem(ll_row,"price",ll_price)
	dw_body.setitem(ll_row,"amt",ll_amt)



end event

event type long ue_detail();long i

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(this.title)
		CASE 1
			IF Trigger Event ue_update() < 1 THEN

			END IF		
		CASE 3

	END CHOOSE
END IF
ib_changed = false

is_claim_ymd  = dw_head.getitemstring(1,"claim_ymd")
is_claim_no   = dw_head.getitemstring(1,"claim_no")
il_rows = dw_mast.retrieve(is_brand, is_claim_ymd, is_claim_no, is_style, is_chno, is_mat_cd, gs_user_id, 'New', '0')
dw_body.reset()
if il_rows > 0 then

   dw_mast.SetItemStatus(1, 0, Primary!,NewModified!)

	IF Trigger Event ue_keycheck('9') = FALSE THEN RETURN 1

		dw_body.dataobject = "d_23001_d02"
		dw_body.SetTransObject(SQLCA)

		il_rows = dw_body.retrieve(is_brand, is_claim_ymd, is_claim_no, is_style, is_chno, is_mat_cd, gs_user_id, 'New','0')
	if il_rows > 0 then
		FOR i=1 TO dw_body.rowcount()
		   dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
		NEXT	
		dw_mast.setfocus()
		dw_mast.setcolumn("claim_gubn")
	end if	
end if
	


Trigger Event ue_button(2, il_rows)
Trigger Event ue_msg(2, il_rows)
end event

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

ll_Width = idrg_Vertical2[1].X + idrg_Vertical2[1].Width - (st_1.X + ii_BarThickness)

idrg_Vertical2[1].Move (st_1.X + ii_BarThickness, idrg_Vertical2[1].Y)
idrg_Vertical2[1].Resize (ll_Width, idrg_Vertical2[1].Height)


idrg_Vertical2[2].Resize (st_1.X - idrg_Vertical2[2].X, idrg_Vertical2[2].Height)

//idrg_Vertical2[2].Move (idrg_Vertical2[1].X + idrg_Vertical2[1].Width + ii_BarThickness, idrg_Vertical2[1].Y)

Return 1


end function

on w_23001_e.create
int iCurrent
call super::create
this.dw_mast=create dw_mast
this.dw_head2=create dw_head2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mast
this.Control[iCurrent+2]=this.dw_head2
end on

on w_23001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_mast)
destroy(this.dw_head2)
end on

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")
inv_resize.of_Register(dw_list, "ScaleToBottom")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(st_1, "ScaleToBottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(dw_mast, "ScaleToRight")



idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_mast.SetTransObject(SQLCA)
dw_head2.SetTransObject(SQLCA)


//dw_asst.SetTransObject(SQLCA)
/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
//dw_asst.reset()
//dw_1.InsertRow(0)

new = 'New'
datetime ld_datetime



idrg_Vertical2[1] = dw_mast
idrg_Vertical2[2] = dw_head2

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"claim_ymd",string(ld_datetime,"yyyymmdd"))

end if


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
			dw_head2.Enabled = false
         dw_list.Enabled = true
			cb_insert.enabled = false
         dw_mast.Enabled = false
         dw_body.Enabled = false
			cb_delete.enabled = false

		else
         dw_head.SetFocus()
      end if

   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
//			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_head2.Enabled = true
				dw_list.Enabled = true
				dw_mast.Enabled = true
	         dw_body.Enabled = true
				cb_delete.enabled = false //true
			end if
//		end if

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
      cb_insert.enabled = true
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_mast.Enabled = false
      dw_body.Enabled = false		
      dw_head.Enabled = true
		dw_head2.Enabled = true		
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
         cb_insert.enabled = false
      end if
		
		prot = dw_mast.getitemnumber(1,"prot")
		if prot = 1 then
			cb_update.enabled = false
			cb_delete.enabled = true
         dw_mast.Enabled = true
         dw_body.Enabled = true			
		else
			cb_delete.enabled = true
         dw_mast.Enabled = true
         dw_body.Enabled = true			
		end if
	
END CHOOSE

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



if as_cb_div = '9' then
	IF dw_mast.AcceptText() <> 1 THEN RETURN FALSE
	is_brand        = dw_mast.GetItemString(1, "brand")
	is_claim_ymd    = dw_mast.GetItemString(1, "claim_ymd")
	is_claim_no     = dw_mast.GetItemString(1, "claim_no")
	is_style 		 = LeftA(dw_mast.GetItemString(1, "style"),8)
	is_chno 			 = dw_mast.GetItemString(1, "chno")
	is_mat_cd 		 = dw_mast.GetItemString(1, "mat_cd")	
	Flag            = dw_mast.GetItemString(1, "Flag")  
else
	IF dw_head.AcceptText() <> 1 THEN RETURN FALSE
	is_brand        = dw_head.GetItemString(1, "brand")
	is_claim_ymd    = dw_head.GetItemString(1, "claim_ymd")
	is_claim_no     = dw_head.GetItemString(1, "claim_no")
	is_style        = dw_head.GetItemString(1, "style")
	if LenA(is_style) = 9 then		
		is_chno 			 = RightA(is_style,1)
	else
		setnull(is_chno)
	end if	
	is_mat_cd 		 = dw_head.GetItemString(1, "mat_cd")		
	Flag            = dw_head.GetItemString(1, "Flag")  
end if
	
	
if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif ( gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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

	

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_claim_ymd, is_claim_no, is_style, is_chno, is_mat_cd)
dw_mast.reset()
dw_body.reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_claim_cust_nm ,ls_ord_emp, ls_mat_cd
Boolean    lb_check 
DataStore  lds_Source
//if not this.trigger event ue_keycheck('1') then return -1

is_brand = dw_head.getitemstring(1,'brand')
CHOOSE CASE as_column
	CASE "claim_cust"				
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				elseIF gf_cust_nm(as_data, 'S', ls_claim_cust_nm) = 0 THEN
				   dw_mast.SetItem(al_row, "claim_cust_nm", ls_claim_cust_nm)
					RETURN 0
				END IF 
			END IF

			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처 코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			gst_cd.default_where   = "Where brand     = case when '" + is_brand + "' = 'J' then 'N' "      + &
																	" when '" + is_brand + "' = 'Y' then 'O' "      + &
																	" else '" + is_brand + "' end "      + &
			                         "  and cust_code between '7000' and '8999'"
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
				dw_mast.SetRow(al_row)
				dw_mast.SetColumn(as_column)
				dw_mast.SetItem(al_row, "claim_cust", lds_Source.GetItemString(1,"custcode"))
				dw_mast.SetItem(al_row, "claim_cust_nm", lds_Source.GetItemString(1,"cust_name"))
				/* 다음컬럼으로 이동 */
				dw_mast.scrolltorow(1)
				dw_mast.SetColumn("claim_cust")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source


	CASE "style"			
		IF ai_div = 1 THEN 				
			if isnull(as_data) or as_data = "" then
				return 0					

			END IF 
		END IF	
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "제품 코드 검색" 
		gst_cd.datawindow_nm   = "d_com010" 
		gst_cd.default_where   = " where brand = '" + is_brand + "'"
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "style + chno like '%" + as_data +"%'"
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = Create DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = True
			lds_Source = Message.PowerObjectParm
			dw_head.SetRow(1)
			dw_head.SetColumn(as_column)
			dw_head.SetItem(1, "style", lds_Source.GetItemString(1,"style")+lds_Source.GetItemString(1,"chno"))

			/* 다음컬럼으로 이동 */
			dw_head.scrolltorow(1)
			dw_head.SetColumn("mat_cd")
			ib_itemchanged = False 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		Destroy  lds_Source	
				
	case "mat_cd"
		IF ai_div = 1 THEN 				
			if isnull(as_data) or as_data = "" then
				return 0					
			END IF 
		END IF

		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "원자재코드 검색" 
		gst_cd.datawindow_nm   = "d_com020" 
		gst_cd.default_where   = " where brand = '" + is_brand + "'"
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
			dw_head.SetItem(1, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
			dw_head.SetItem(1, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))

			/* 다음컬럼으로 이동 */
//				dw_head.post event ue_addnew(as_data,al_row)
//				dw_head.SetColumn("color")					
			ib_itemchanged = False 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		Destroy  lds_Source		

	CASE "ord_emp"				
			IF ai_div = 1 THEN 
				if isnull(as_data) or as_data = "" then
					return 0	
				elseIF gf_emp_nm(as_data,  ls_ord_emp) = 0 THEN
				   dw_mast.SetItem(al_row, "ord_emp_nm", ls_ord_emp)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			gst_cd.default_where   = " where brand = '" + is_brand + "' and dept_cd = 'A000'" //자재과
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "empno LIKE '" + as_data + "%' or kname like '%" + as_data + "%'" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_mast.SetRow(al_row)
				dw_mast.SetColumn(as_column)
				dw_mast.SetItem(al_row, "ord_emp", lds_Source.GetItemString(1,"empno"))
				dw_mast.SetItem(al_row, "ord_emp_nm", lds_Source.GetItemString(1,"kname"))

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

event type long ue_update();/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_no, ll_ret, ll_amt
string ls_null, empty_chk = '1',mat_gubn
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF Trigger Event ue_keycheck('9') = FALSE THEN RETURN -1
IF dw_mast.AcceptText() <> 1 THEN RETURN -1
IF dw_body.AcceptText() <> 1 THEN RETURN -1
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


idw_status = dw_mast.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */
	trigger event ue_smat_set()	
	
	select 
	right('0000'+ rtrim(convert(char(4),convert(int,
	isnull((select max(claim_no) from tb_23010_m where brand = :is_brand and claim_ymd = :is_claim_ymd),'0000')
	) +1)),4)
		into :is_claim_no
	from dual;
	
   dw_mast.Setitem(1, "claim_no", is_claim_no)
   dw_mast.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN		/* Modify Record */
   dw_mast.Setitem(1, "mod_id", gs_user_id)
   dw_mast.Setitem(1, "mod_dt", ld_datetime)	
end if


select 
convert(int,
isnull((select max(no) from tb_23011_d where brand = :is_brand and claim_ymd = :is_claim_ymd and claim_no = :is_claim_no),'0000')
) +1
	into :ll_no
from dual;



FOR i=1 TO dw_body.rowcount()
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	mat_gubn = dw_body.getitemstring(i,"mat_gubn")

   IF idw_status = NewModified! THEN				/* New Record */

		ll_amt   = dw_body.getitemnumber(i,"amt")

		if  mat_gubn <> '2' and ll_amt <> 0 then	// 원자재 B급, 미작업, 부자재 B급, 미작업, 임봉료 각각 한줄씩 					
			dw_body.Setitem(i, "claim_ymd", is_claim_ymd)
			dw_body.Setitem(i, "claim_no", is_claim_no)
			dw_body.Setitem(i, "no", string(ll_no,"0000"))
			dw_body.Setitem(i, "reg_id", gs_user_id)
			ll_no = ll_no+1
	
		else
			dw_body.SetItemStatus(i, 0, Primary!,NotModified!)		
	
		end if
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
	
   END IF
NEXT


il_rows = dw_body.Update(TRUE, FALSE)
if il_rows = 1 then	
   il_rows = dw_mast.Update(TRUE, FALSE)
end if


if il_rows = 1 then
	
   commit  USING SQLCA;

	ib_changed = false
	trigger event ue_retrieve()

else	
	
   rollback  USING SQLCA;

	IF SQLCA.SQLCode = -1 THEN 	
		MessageBox("SQL error", SQLCA.SQLErrText)	
	END IF

end if

return il_rows




end event

event ue_insert();string ls_flag
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_head2.retrieve(is_brand, is_mat_cd, is_style)

select top 1 style 
	into :ls_flag
	from tb_23010_m where brand = :is_brand 
	and style = left(:is_style,8)
	and chno  = right(:is_style,1);


if isnull(ls_flag) or ls_flag = "" then
else
	messagebox("주의","클레임 등록된 스타일입니다...")
end if



this.Trigger Event ue_button(2, il_rows)
this.Trigger Event ue_msg(2, il_rows)


end event

event ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Integer li_result

li_result = MessageBox("인쇄구분", "인쇄 하시겠습니까? ", Question!, YesNoCancel!)
If li_result = 3 or dw_body.rowcount() = 0 Then Return

This.Trigger Event ue_title()

dw_print.Retrieve(is_brand, is_claim_ymd, is_claim_no)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)





end event

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Integer li_result
string ls_brand, ls_claim_ymd, ls_claim_no


If li_result = 3 or dw_body.rowcount() = 0 Then Return

This.Trigger Event ue_title()
ls_brand = dw_body.getitemstring(1,"brand")
ls_claim_ymd = dw_body.getitemstring(1,"claim_ymd")
ls_claim_no  = dw_body.getitemstring(1,"claim_no")


dw_print.Retrieve(ls_brand, ls_claim_ymd, ls_claim_no)
dw_print.inv_printpreview.of_SetZoom()
end event

event ue_delete();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row

ll_cur_row = dw_body.GetRow()

//if ll_cur_row <= 0 then return
	


il_rows = dw_body.DeleteRow (ll_cur_row)
if dw_body.rowcount() = 0 then 
	il_rows = dw_mast.DeleteRow (1)	
else
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_23001_e","0")
end event

type cb_close from w_com020_e`cb_close within w_23001_e
end type

type cb_delete from w_com020_e`cb_delete within w_23001_e
end type

type cb_insert from w_com020_e`cb_insert within w_23001_e
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_23001_e
end type

type cb_update from w_com020_e`cb_update within w_23001_e
end type

type cb_print from w_com020_e`cb_print within w_23001_e
boolean enabled = true
end type

type cb_preview from w_com020_e`cb_preview within w_23001_e
boolean enabled = true
end type

type gb_button from w_com020_e`gb_button within w_23001_e
end type

type cb_excel from w_com020_e`cb_excel within w_23001_e
end type

type dw_head from w_com020_e`dw_head within w_23001_e
event ue_bom ( string name,  string gubn )
event type long ue_detail ( )
integer width = 3566
integer height = 208
string dataobject = "d_23001_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('001')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand_cd"      // dddw로 작성된 항목
   
	CASE "style","mat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::editchanged;call super::editchanged;choose case dwo.name
	case "mat_cd","style","ord_origin"
		if LenA(data) = 1 then this.setitem(1,"brand",data)
end choose
end event

type ln_1 from w_com020_e`ln_1 within w_23001_e
integer beginy = 388
integer endy = 388
end type

type ln_2 from w_com020_e`ln_2 within w_23001_e
integer beginy = 392
integer endy = 392
end type

type dw_list from w_com020_e`dw_list within w_23001_e
integer x = 14
integer y = 936
integer width = 768
integer height = 1104
string dataobject = "d_23001_L01"
boolean hscrollbar = true
end type

event dw_list::doubleclicked;call super::doubleclicked;/*===========================================================================*/
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

is_brand = This.GetItemString(row, 'brand') /* DataWindow에 Key 항목을 가져온다 */
is_claim_ymd = This.GetItemString(row, 'claim_ymd')
is_claim_no = This.GetItemString(row, 'claim_no')



IF IsNull(is_brand) or IsNull(is_claim_ymd) or IsNull(is_claim_no) THEN return
dw_body.dataobject = "d_23001_d03"
dw_body.SetTransObject(SQLCA)

il_rows = dw_mast.retrieve(is_brand, is_claim_ymd, is_claim_no, is_style, is_chno, is_mat_cd, gs_user_id, 'Dat', '0')
if il_rows > 0 then
	il_rows = dw_body.retrieve(is_brand, is_claim_ymd, is_claim_no)
end if

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_23001_e
event ue_refresh ( long row,  string as_name )
event ue_auto_calcu ( long row )
event ue_qty_apply ( long al_qty,  string as_gubn,  string as_color )
integer y = 936
integer width = 2839
integer height = 1104
string dataobject = "d_23001_d02"
boolean hscrollbar = true
end type

event dw_body::ue_auto_calcu(long row);string ls_gubn, ls_acpt_ack
decimal ll_bom, ll_pcs, ll_qty, ll_price, ll_claim_rate, ll_amt

ls_gubn 	= dw_body.getitemstring(row,"gubn")
ll_bom  	= dw_body.getitemnumber(row,"bom")
ll_pcs  	= dw_body.getitemnumber(row,"pcs")
ll_price  	= dw_body.getitemnumber(row,"price")
ll_claim_rate  	= dw_body.getitemnumber(row,"claim_rate")
ll_amt  	= dw_body.getitemnumber(row,"amt")
ls_acpt_ack = dw_body.getitemstring(row,"acpt_ack")

dw_body.setitem(row,"qty",ll_bom * ll_pcs)

ll_qty  	= ll_bom * ll_pcs

if ls_acpt_ack = "N" then	dw_body.setitem(row,"amt",ll_qty * ll_price * ll_claim_rate * 0.01)

end event

event dw_body::ue_qty_apply(long al_qty, string as_gubn, string as_color);decimal	ll_class_b, ll_class_z, ll_imgam_pcs
long i, ll_row
string ls_gubn, ls_mat_gubn, ls_color


ll_row = dw_body.rowcount() - 2
if this.dataobject = "d_23001_d02" then
	dw_mast.setitem(1,"class_b",this.getitemnumber(1,"class_b"))
	dw_mast.setitem(1,"class_z",this.getitemnumber(1,"class_z"))
	dw_mast.setitem(1,"imgam_pcs",this.getitemnumber(1,"class_imgam"))
else
	dw_mast.setitem(1,"imgam_pcs",this.getitemnumber(1,"class_imgam"))
end if

ll_class_b   = dw_mast.getitemnumber(1,"class_b")
ll_class_z   = dw_mast.getitemnumber(1,"class_z")
ll_imgam_pcs = dw_mast.getitemnumber(1,"imgam_pcs")

for i = 1 to ll_row
	ls_mat_gubn = dw_body.getitemstring(i,"mat_gubn")
	ls_color =  dw_body.getitemstring(i,"st_color")
	if ls_mat_gubn = "2" then
		ls_gubn = dw_body.getitemstring(i,"gubn")
//		messagebox("color", ls_color + '/' + as_color)		
//		messagebox("gubn", ls_gubn + '/' + as_gubn)						
		if ls_gubn = "3" then //and ls_color = "XX" then //and (ls_color = is_color or ls_color = "XX") then
			if ls_color = as_color and as_gubn = "1" then
				dw_body.setitem(i,"pcs",al_qty)	
			elseif ls_color = "XX" then				
				dw_body.setitem(i,"pcs",ll_class_b)	
			end if	
		elseif ls_gubn = "4"  then //and ls_color = "XX" then //and (ls_color = is_color or ls_color = "XX") then		
//			dw_body.setitem(i,"pcs",ll_class_z)
			if ls_color = as_color and as_gubn = "2" then
				dw_body.setitem(i,"pcs",al_qty)	
			elseif ls_color = "XX" then								
				dw_body.setitem(i,"pcs",ll_class_z)
			end if				
			
		end if
	elseif ls_mat_gubn = "5" then
		dw_body.setitem(i,"pcs",ll_imgam_pcs)
	end if
	dw_body.trigger event ue_auto_calcu(i)
next


end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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
	CASE KeyDownArrow!

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
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::dberror;//
end event

event dw_body::itemchanged;string ls_gubn, ls_acpt_ack
decimal ll_bom, ll_pcs, ll_qty, ll_price, ll_claim_rate, ll_amt

ls_gubn 	= dw_body.getitemstring(row,"gubn")
ll_bom  	= dw_body.getitemnumber(row,"bom")
ll_pcs  	= dw_body.getitemnumber(row,"pcs")
ll_price  	= dw_body.getitemnumber(row,"price")
ll_claim_rate  	= dw_body.getitemnumber(row,"claim_rate")
ll_amt  	= dw_body.getitemnumber(row,"amt")
is_color = dw_body.getitemstring(row,"st_color")

//messagebox("ls_gubn", ls_gubn)
//messagebox("is_color", is_color)

choose case dwo.name 
	case "pcs"
		ll_pcs = dec(data)
		this.post event ue_qty_apply(ll_pcs, ls_gubn, is_color)		
case "price"
		ll_price = dec(data)
	case "claim_rate"
		ll_claim_rate = dec(data)
end choose

dw_body.setitem(row,"qty",ll_bom * ll_pcs)

ll_qty  	= ll_bom * ll_pcs

dw_body.setitem(row,"amt",ll_qty * ll_price * ll_claim_rate * 0.01)

if dwo.name = "acpt_ack" then
	if data = "Y" then
		this.setitem(row,"amt",0)
	end if
end if


end event

event dw_body::losefocus;call super::losefocus;this.accepttext() 
end event

type st_1 from w_com020_e`st_1 within w_23001_e
integer y = 404
integer height = 1636
end type

type dw_print from w_com020_e`dw_print within w_23001_e
integer x = 50
integer y = 1212
integer height = 432
string dataobject = "d_23001_r01"
end type

type dw_mast from u_dw within w_23001_e
event ue_keydown pbm_dwnkey
event ue_qty_apply ( )
integer x = 805
integer y = 404
integer width = 2830
integer height = 528
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_23001_d01"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)                                       */	
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
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event ue_qty_apply();decimal	ll_class_b, ll_class_z, ll_imgam_pcs
long i, ll_row
string ls_gubn, ls_mat_gubn

IF dw_mast.AcceptText() <> 1 THEN RETURN 


ll_row = dw_body.rowcount() - 2

ll_class_b   = dw_mast.getitemnumber(1,"class_b")
ll_class_z   = dw_mast.getitemnumber(1,"class_z")
ll_imgam_pcs = dw_mast.getitemnumber(1,"imgam_pcs")

for i = 1 to ll_row
	ls_mat_gubn = dw_body.getitemstring(i,"mat_gubn")
	if ls_mat_gubn = "2" then
		dw_body.setitem(i,"pcs",ll_imgam_pcs)
	elseif ls_mat_gubn = "5" then
		dw_body.setitem(i,"pcs",ll_imgam_pcs)
	end if
	dw_body.trigger event ue_auto_calcu(i)
next

end event

event itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_style_cust, ls_style_cust_nm, ls_mat_cust, ls_mat_cust_nm

CHOOSE CASE dwo.name
	CASE "claim_gubn" 
    	IF data = '01' THEN
			ls_mat_cust = this.getitemstring(1,"mat_cust")
			ls_mat_cust_nm = this.getitemstring(1,"mat_cust_nm")
			this.setitem(1,"claim_cust", ls_mat_cust)
			this.setitem(1,"claim_cust_nm", ls_mat_cust_nm)			
		elseif data = '02' THEN
			ls_style_cust = this.getitemstring(1,"style_cust")
			ls_style_cust_nm = this.getitemstring(1,"style_cust_nm")
			this.setitem(1,"claim_cust",ls_style_cust)			
			this.setitem(1,"claim_cust_nm",ls_style_cust_nm)			
	else
			this.setitem(1,"claim_cust", "")	
		end if
		
	CASE "claim_cust"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

//CHOOSE CASE ls_column_name
//	CASE "cust_cd"
//		ls_helpMsg = "▶ ※ 거래처 코드를 입력하세요! "
//	CASE ELSE
//		ls_helpMsg = " "
//END CHOOSE
//
//Parent.SetMicroHelp(ls_helpMsg)

end event

event constructor;call super::constructor;datawindowchild ldw_child
this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('001')

this.getchild("claim_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('211')

this.getchild("pay_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('007')

end event

event dberror;//
end event

event buttonclicked;call super::buttonclicked;trigger event ue_qty_apply()

end event

type dw_head2 from datawindow within w_23001_e
integer x = 14
integer y = 404
integer width = 763
integer height = 532
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_23001_h02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)
il_list_row = row

dw_head.setitem(1,"style" ,this.getitemstring(row,"style"))
dw_head.setitem(1,"mat_cd",this.getitemstring(row,"mat_cd"))

is_style  = dw_head2.getitemstring(row,"style")

is_chno  = RightA(is_style,1)
is_style = LeftA(is_style,8)
is_mat_cd = dw_head2.getitemstring(row,"mat_cd")



parent.trigger event ue_detail()
end event

event clicked;This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)
end event

