$PBExportHeader$w_12022_e.srw
$PBExportComments$디자인 진행등록
forward
global type w_12022_e from w_com010_e
end type
type rb_1 from radiobutton within w_12022_e
end type
type rb_0 from radiobutton within w_12022_e
end type
type dw_sample from datawindow within w_12022_e
end type
type dw_qc from datawindow within w_12022_e
end type
type cb_direct_qc from commandbutton within w_12022_e
end type
type dw_1 from datawindow within w_12022_e
end type
end forward

global type w_12022_e from w_com010_e
integer width = 3675
integer height = 2284
event type boolean ue_st_info_set ( string as_sample_cd,  long al_row )
rb_1 rb_1
rb_0 rb_0
dw_sample dw_sample
dw_qc dw_qc
cb_direct_qc cb_direct_qc
dw_1 dw_1
end type
global w_12022_e w_12022_e

type variables
string is_brand, is_designer , is_yymmdd, is_item, is_my_own, is_sample_cd, is_style, is_emp_no
int	ii_v_opt
boolean ib_changed2 , ib_insert 

DataWindowChild idw_brand, idw_designer, idw_sample_type, idw_out_seq, idw_item

end variables

forward prototypes
public function boolean uf_sample_cd_chk (string as_brand, string as_sample_cd)
public function boolean uf_exist_style (string as_style)
end prototypes

event type boolean ue_st_info_set(string as_sample_cd, long al_row);	string ls_year 
	if LenA(as_sample_cd) <> 8 then return false

	ls_year = '202' + MidA(as_sample_cd,3,1)
	
	dw_body.setitem(al_row,"brand" ,LeftA(as_sample_cd,1))
	dw_body.setitem(al_row,"sojae" ,MidA(as_sample_cd,2,1))
	dw_body.setitem(al_row,"year"  ,ls_year)
	dw_body.setitem(al_row,"season",MidA(as_sample_cd,4,1))
	dw_body.setitem(al_row,"item"  ,MidA(as_sample_cd,5,1))
	

end event

public function boolean uf_sample_cd_chk (string as_brand, string as_sample_cd);

if LenA(as_sample_cd) <> 9 then
	messagebox("확인1","샘플번호 포멧이 일치하지 않습니다.")
	return false

elseif LeftA(as_sample_cd,1) <> as_brand then
	messagebox("확인2","샘플번호가 브랜드와 일치하지 않습니다.")
	return false

elseif AscA(MidA(as_sample_cd,2,1)) < 48 or 	AscA(MidA(as_sample_cd,2,1)) > 57 then 
	messagebox("확인3","샘플번호 포멧이 일치하지 않습니다.")
	return false	

elseif MidA(as_sample_cd,3,1) <> 'S' and MidA(as_sample_cd,3,1) <> 'M' and MidA(as_sample_cd,3,1) <> 'A' and MidA(as_sample_cd,3,1) <> 'W' then 
	messagebox("확인4","샘플번호 포멧이 일치하지 않습니다.")
	return false	

elseif AscA(MidA(as_sample_cd,4,1)) >= 48 and AscA(MidA(as_sample_cd,4,1)) <= 57 then 
	messagebox("확인5","샘플번호 포멧이 일치하지 않습니다.")
	return false	

elseif AscA(MidA(as_sample_cd,5,1)) >= 48 and AscA(MidA(as_sample_cd,5,1)) <= 57 then 
	messagebox("확인6","샘플번호 포멧이 일치하지 않습니다.")
	return false

elseif AscA(MidA(as_sample_cd,6,1)) >= 48 and AscA(MidA(as_sample_cd,6,1)) <= 57 then 
	messagebox("확인7","샘플번호 포멧이 일치하지 않습니다.")
	return false
	
elseif AscA(MidA(as_sample_cd,7,1)) < 48 or 	AscA(MidA(as_sample_cd,7,1)) > 57 then 
	messagebox("확인8","샘플번호 포멧이 일치하지 않습니다.")
	return false		

	
elseif AscA(MidA(as_sample_cd,8,1)) < 48 or 	AscA(MidA(as_sample_cd,8,1)) > 57 then 
	messagebox("확인9","샘플번호 포멧이 일치하지 않습니다.")
	return false		
	
elseif AscA(MidA(as_sample_cd,9,1)) < 48 or 	AscA(MidA(as_sample_cd,9,1)) > 57 then 
	messagebox("확인10","샘플번호 포멧이 일치하지 않습니다.")
	return false	
end if

return true

end function

public function boolean uf_exist_style (string as_style);string ls_style
boolean	lb_exists

	select style
		into :ls_style
	from tb_31031_m (nolock)
	where style = :as_style;
	
	if isnull(ls_style) or LenA(ls_style) <> 8 then
		return false
	end if
		
	return true
	
end function

on w_12022_e.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_0=create rb_0
this.dw_sample=create dw_sample
this.dw_qc=create dw_qc
this.cb_direct_qc=create cb_direct_qc
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_0
this.Control[iCurrent+3]=this.dw_sample
this.Control[iCurrent+4]=this.dw_qc
this.Control[iCurrent+5]=this.cb_direct_qc
this.Control[iCurrent+6]=this.dw_1
end on

on w_12022_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_0)
destroy(this.dw_sample)
destroy(this.dw_qc)
destroy(this.cb_direct_qc)
destroy(this.dw_1)
end on

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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


is_item = dw_head.GetItemString(1, "item")
is_my_own = dw_head.GetItemString(1, "my_own")
is_sample_cd = dw_head.GetItemString(1, "sample_cd")
is_style     = dw_head.GetItemString(1, "style")
is_emp_no     = dw_head.GetItemString(1, "emp_no")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_brand, gs_user_id, ii_v_opt, is_item, is_my_own, is_sample_cd, is_style, is_emp_no)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_token, ll_my_token, ll_row
datetime ld_datetime, ld_tdate, ld_time, ld_time_6
string ls_chk_yn, ls_sample_cd, ls_select_yn
boolean	ib_change


setnull(ld_tdate)

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1



/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF
	
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */	
		ls_sample_cd = dw_body.getitemstring(i,"sample_cd")	
			
		IF gf_auto_sample_cd(ls_sample_cd, gs_brand) THEN 
			dw_body.setitem(i,"sample_cd",ls_sample_cd)	
		else
			return 0
		end if
		
		trigger event ue_st_info_set(ls_sample_cd, i)	
      dw_body.Setitem(i, "reg_id", gs_user_id)

					ls_chk_yn = dw_body.GetItemString(i,"end_yn")
				
					if ls_chk_yn = "Y" then		
						ld_tdate = ld_datetime
					else
						setnull(ld_tdate)
					end if
					
				
					
					ll_my_token = dw_body.getitemnumber(i,"my_token")
					
				
					choose case ll_my_token
						case 0
							dw_body.setitem(i,"time_0", ld_tdate)
						case 1
							dw_body.setitem(i,"time_1", ld_tdate)
						case 2
							dw_body.setitem(i,"time_2", ld_tdate)
						case 3
							dw_body.setitem(i,"time_3", ld_tdate)
						case 4
							dw_body.setitem(i,"time_4", ld_tdate)
						case 5 
							dw_body.setitem(i,"time_5", ld_tdate)
						case 6
							dw_body.setitem(i,"time_6", ld_tdate)
						case 7							
							dw_body.setitem(i,"time_7", ld_tdate)
						case 8
							dw_body.setitem(i,"time_8", ld_tdate)
						case 9
							dw_body.setitem(i,"time_9", ld_tdate)
							
					end choose		

					ls_select_yn = dw_body.getitemstring(i,"select_yn")
					ld_time_6 = dw_body.getitemdatetime(i,"time_6")
					if  ls_select_yn = '' or isnull(ls_select_yn) then
						setnull(ld_time)
						dw_body.setitem(i,"time_6", ld_time)	
					elseif string(ld_time_6,"yyyy/mm/dd") = '' or isnull(ld_time_6) then
						dw_body.setitem(i,"time_6", ld_datetime)
					end if		
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */		
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
		
					ls_chk_yn = dw_body.GetItemString(i,"end_yn")
				
					if ls_chk_yn = "Y" then		
						ld_tdate = ld_datetime
					else
						setnull(ld_tdate)
					end if
					
				
					
					ll_my_token = dw_body.getitemnumber(i,"my_token")
					
				
					choose case ll_my_token
						case 0
							dw_body.setitem(i,"time_0", ld_tdate)
						case 1
							dw_body.setitem(i,"time_1", ld_tdate)
						case 2
							dw_body.setitem(i,"time_2", ld_tdate)
						case 3
							dw_body.setitem(i,"time_3", ld_tdate)
						case 4
							dw_body.setitem(i,"time_4", ld_tdate)
						case 5 
							dw_body.setitem(i,"time_5", ld_tdate)
						case 6
							dw_body.setitem(i,"time_6", ld_tdate)
						case 7							
							dw_body.setitem(i,"time_7", ld_tdate)
						case 8
							dw_body.setitem(i,"time_8", ld_tdate)
						case 9
							dw_body.setitem(i,"time_9", ld_tdate)
							
					end choose		

					ls_select_yn = dw_body.getitemstring(i,"select_yn")
					ld_time_6 = dw_body.getitemdatetime(i,"time_6")
					if  ls_select_yn = '' or isnull(ls_select_yn) then
						setnull(ld_time)
						dw_body.setitem(i,"time_6", ld_time)	
					elseif string(ld_time_6,"yyyy/mm/dd") = '' or isnull(ld_time_6) then
						dw_body.setitem(i,"time_6", ld_datetime)
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

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

post event ue_retrieve()
if il_rows > 0 then
	dw_body.setfocus()
	dw_body.setrow(ll_row_count)
	dw_body.setcolumn("mat_nm")
end if	
	
return il_rows


end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1   , "ScaleToRight")
inv_resize.of_Register(ln_2   , "ScaleToRight")
inv_resize.of_Register(dw_1   , "FixedToRight&Bottom")


dw_sample.SetTransObject(SQLCA)
dw_qc.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
end event

event ue_insert();idw_status = dw_body.GetItemStatus(dw_body.rowcount(), 0, Primary!)

IF idw_status = NewModified! or idw_status = New!  THEN return

/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)



dw_body.setrow(il_rows)
dw_body.setcolumn("sample")
dw_body.setfocus()


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12022_e","0")
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
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_brand.text = is_brand  + '  ' + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")


end event

event ue_preview();
/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation	 = 1
//dw_body.ShareData(dw_print)
dw_print.retrieve(is_brand, gs_user_id, ii_v_opt, is_item, is_my_own, is_sample_cd, is_style, is_emp_no)
dw_print.inv_printpreview.of_SetZoom()

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_sample_cd, ls_emp_nm, ls_dept, ls_mat_cd, ls_mat_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column

	CASE "designer"				
			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then  return 1
				if gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
					dw_body.Setitem(al_row, "designer_nm", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			/* 관련부서 산출 */ 

//			messagebox("ls_dept",ls_dept)
			
//			if gs_brand = 'T' then 
//		   	gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('T000')" /* TASSE 추가 */  
//			elseif gs_brand = 'W' then 
//			   gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('K100')" /* W. 추가 */  
//			else
				gf_get_inter_sub ('991', gs_brand + '10', '1', ls_dept)
				gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('" + ls_dept + "','B200','O200','O100','B100','T000','K100','O000')" /* 니트 , 악세라시 추가 */  
//			end if
			
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(empno LIKE '" + as_data + "%' OR " + & 
				                    " kname LIKE '" + as_data + "%' )" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "designer",    lds_Source.GetItemString(1,"empno"))
				dw_body.SetItem(al_row, "designer_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */				
				dw_body.SetColumn("bigo")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source


	CASE "emp_no"				
			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then  return 1
				if gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
					dw_head.Setitem(al_row, "emp_nm", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			/* 관련부서 산출 */ 

//			messagebox("ls_dept",ls_dept)
			
//			if gs_brand = 'T' then 
//		   	gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('T000')" /* TASSE 추가 */  
//			elseif gs_brand = 'W' then 
//			   gst_cd.default_where   = "where goout_gubn = '1' and dept_code in ('K100')" /* W. 추가 */  
//			else
//				gf_get_inter_sub ('991', gs_brand + '10', '1', ls_dept)
				gst_cd.default_where   = "where goout_gubn = '1' " // and dept_code in ('" + ls_dept + "','B200','O200','O100','B100','T000','K100','O000')" /* 니트 , 악세라시 추가 */  
//			end if
			
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(empno LIKE '" + as_data + "%' OR " + & 
				                    " kname LIKE '%" + as_data + "%' )" 
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
				dw_head.SetItem(al_row, "emp_no",    lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "emp_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */				

				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
			
			
	CASE "cust_cd"				
		is_brand = dw_body.GetItemString(1, "brand")

			IF ai_div = 1 THEN 
				if isnull(as_data) or trim(as_data) = "" then
					return 0
				end if
			END IF
			
		
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재/생산 거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911"
			Choose Case is_brand
				Case 'O','Y','K' /* Double U Dot, Tasse Tasse 추가 2003.07.07 */
					gst_cd.default_where   = " WHERE BRAND IN ('O', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
				Case Else
					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
			End Choose
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "CUSTCODE LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "designer", lds_Source.GetItemString(1,"custcode"))

				/* 다음컬럼으로 이동 */

				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
				cb_excel.enabled = false
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source			
	CASE "mat_cd"				
			IF ai_div = 1 THEN 	
				IF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
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
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "원자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 

			Choose Case is_brand
				Case 'O','Y','K'
					gst_cd.default_where   = " WHERE BRAND IN ('O', '" + is_brand + "') "
				
				Case else
					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') "
					
			end choose
			

			if gs_brand <> "K" then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "mat_cd LIKE '" + as_data + "%'"
				ELSE				
					gst_cd.Item_where = ""
				END IF
			else
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "mat_cd LIKE '" + as_data + "%' and mat_cd like 'K%'"
				ELSE				
					gst_cd.Item_where = "mat_cd like 'K%'"
				END IF

			end if 	

//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "mat_cd LIKE '" + as_data + "%'"
//			ELSE
//				gst_cd.Item_where = ""
//			END IF
			
			

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_sample.SetRow(al_row)
				dw_sample.SetColumn(as_column)
				dw_sample.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
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

event ue_delete();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row
datetime	ld_datetime

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return
ld_datetime = dw_body.getitemdatetime(ll_cur_row,"time_1")
if not isnull(ld_datetime) then 
	messagebox("주의","진행중인 디자인은 삭제할 수 없습니다.")
	return
end if
	
idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_body.DeleteRow (ll_cur_row)
dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

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
			
         dw_head.Enabled = false
         dw_body.Enabled = true
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
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
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
			if dw_body.RowCount() = 0 then
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
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event open;call super::open;string ls_pass

	select user_level
		into :ls_pass
	from tb_93013_d (nolock)
	where work_gbn = '6' 
	and   person_id = :gs_user_id;

	
	if LenA(ls_pass) > 0 then	cb_update.visible = true
	

	if PosA(ls_pass,'0') > 0 or PosA(ls_pass,'6') > 0 then
		cb_insert.visible = true
		cb_delete.visible = true	
		if PosA(ls_pass,'6') > 0 then cb_direct_qc.visible = true
	end if
	
	dw_1.retrieve()
end event

type cb_close from w_com010_e`cb_close within w_12022_e
integer taborder = 110
end type

type cb_delete from w_com010_e`cb_delete within w_12022_e
boolean visible = false
integer taborder = 100
end type

type cb_insert from w_com010_e`cb_insert within w_12022_e
boolean visible = false
end type

event cb_insert::clicked;Parent.Trigger Event ue_insert()
end event

type cb_retrieve from w_com010_e`cb_retrieve within w_12022_e
end type

type cb_update from w_com010_e`cb_update within w_12022_e
boolean visible = false
integer taborder = 60
end type

event cb_update::clicked;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)  													  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)


il_rows = Parent.Trigger Event ue_update()

SetPointer(oldpointer)

IF il_rows = 1 THEN 
	This.Enabled = False
ELSE
	This.Enabled = True
END IF

end event

type cb_print from w_com010_e`cb_print within w_12022_e
integer taborder = 70
end type

type cb_preview from w_com010_e`cb_preview within w_12022_e
integer taborder = 80
end type

type gb_button from w_com010_e`gb_button within w_12022_e
end type

type cb_excel from w_com010_e`cb_excel within w_12022_e
integer taborder = 90
end type

type dw_head from w_com010_e`dw_head within w_12022_e
integer x = 0
integer width = 4274
integer height = 144
string dataobject = "d_12022_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve()
idw_item.insertrow(1)
idw_item.Setitem(1, "item", "%")
idw_item.Setitem(1, "item_nm", "전체")


end event

event dw_head::clicked;call super::clicked;if dwo.name = 'b_direct_qc' then
	if dw_qc.rowcount() > 0 then dw_qc.reset()
	dw_qc.insertrow(0)
	dw_qc.visible = true
	dw_qc.setfocus()
	dw_qc.setcolumn('style')
end if

	
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name

	CASE "emp_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_12022_e
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_e`ln_2 within w_12022_e
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_e`dw_body within w_12022_e
event ue_set_sample ( string as_sample,  long al_row )
integer x = 0
integer y = 340
integer height = 1700
string dataobject = "d_12022_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::ue_set_sample(string as_sample, long al_row);
dw_body.setitem(al_row,"sample",LeftA(as_sample,5))
dw_body.setitem(al_row,"sample_cd",as_sample)	
dw_body.setitem(al_row,"designer",gs_user_id)	
dw_body.setitem(al_row,"sample_type","3")	  //기본 자체 샘플 
end event

event dw_body::itemfocuschanged;//
end event

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
//This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)


datawindowchild ldw_item
THIS.GetChild("designer", idw_designer)
idw_designer.SetTransObject(SQLCA)
idw_designer.Retrieve(gs_brand, '%')


THIS.GetChild("item", ldw_item)
ldw_item.SetTransObject(SQLCA)
ldw_item.Retrieve('%')

/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/


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

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
string ls_sample_cd, ls_md_yn, ls_style, ls_time
long ll_token, ll_md, ll_my_token


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
CHOOSE CASE dwo.name
	CASE "sample"	     //  Popup 검색창이 존재하는 항목 
		ls_sample_cd = data
		IF gf_auto_sample_cd(ls_sample_cd, gs_brand) THEN 
			post event ue_set_sample (ls_sample_cd, row)
			this.setfocus()
			this.setcolumn("mat_nm")
			
		else
			messagebox("주의","샘플코드를 올바로 입력하세요..")
			return 1
		end if
	case "select_yn"
		this.setitem(row,"end_yn",'N')
		if data = 'Y'  then 
			ls_sample_cd = this.getitemstring(row,"sample_cd")		
			ls_style     = this.getitemstring(row,"style")
			if isnull(ls_style) or ls_style = '' then 
			else
				return 0
			end if
			
			ls_md_yn = this.getitemstring(row,"md_yn")	
			ll_token = this.getitemnumber(row,"token")
			ll_my_token = this.getitemnumber(row,"my_token")
			if ls_md_yn = 'Y' or ll_my_token = 0 then
				ll_md = 0
			else
				ll_md = 1
			end if 
			
			
			il_rows = dw_sample.retrieve(ls_sample_cd, 'Y', ll_md)
			if il_rows > 0 then
				dw_sample.visible = true
				dw_sample.setfocus()
				dw_sample.setcolumn("style")
			else
				dw_sample.visible = false
			end if
			if ll_token = 6 then			this.setitem(row,"end_yn",'Y')

		elseif data = 'N' then 								
			if ll_token = 6 then this.setitem(row,"end_yn",'Y')			

		end if				
				
END CHOOSE

return 0

end event

event dw_body::doubleclicked;call super::doubleclicked;this.setrow(row)

string ls_sample_cd, ls_select_yn, ls_md_yn
long	ll_token


CHOOSE CASE dwo.name
	CASE "sample_cd"
		ls_sample_cd = this.getitemstring(row,"sample_cd")
		ls_select_yn = this.getitemstring(row,"select_yn")
		ls_md_yn = this.getitemstring(row,"md_yn")

		ll_token = this.getitemnumber(row,"my_token")
		if ls_md_yn = 'Y' or ll_token = 0 then
			ll_token = 0
		else
			ll_token = 1
		end if 
			
		il_rows = dw_sample.retrieve(ls_sample_cd, ls_select_yn, ll_token)
		if il_rows > 0 then
			dw_sample.visible = true
			dw_sample.object.t_msg.text = ""
			dw_sample.setfocus()
			dw_sample.setcolumn("style")
		else
			dw_sample.visible = false
		end if		


END CHOOSE
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
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_12022_e
integer x = 165
integer y = 816
string dataobject = "d_12022_r02"
end type

event dw_print::constructor;call super::constructor;datawindowchild ldw_designer
THIS.GetChild("designer", ldw_designer)
ldw_designer.SetTransObject(SQLCA)
ldw_designer.Retrieve(gs_brand, '%')

This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%')
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')
end event

type rb_1 from radiobutton within w_12022_e
boolean visible = false
integer x = 4453
integer y = 216
integer width = 219
integer height = 60
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "시간"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then 
	ii_v_opt = 0
else
	ii_v_opt = 1
end if

end event

type rb_0 from radiobutton within w_12022_e
boolean visible = false
integer x = 4178
integer y = 216
integer width = 256
integer height = 60
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "막대"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then 
	ii_v_opt = 1
else
	ii_v_opt = 0
end if

end event

type dw_sample from datawindow within w_12022_e
event ue_keydown pbm_dwnkey
event ue_head ( )
event type long ue_update ( )
boolean visible = false
integer x = 1728
integer y = 604
integer width = 1458
integer height = 948
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "샘플정보"
string dataobject = "d_12022_d04"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
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
//   CASE KeyF12!
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

event ue_head();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

/* 변경된 자료가 있을때 저장여부를 확인*/
IF ib_changed2 THEN 
   CHOOSE CASE gf_update_yn(This.title)
	   CASE 1
		   IF This.Trigger Event ue_update() < 1 THEN
			   return
		   END IF		
	   CASE 3
		   return
   END CHOOSE
END IF

//This.Trigger Event ue_button(5, 2)
//This.Trigger Event ue_msg(5, 2)

end event

event type long ue_update();
//
/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_token, ll_my_token
datetime ld_datetime, ld_tdate
string ls_chk_yn, ls_sample_cd, ls_select_yn, ls_style, ls_year

setnull(ld_tdate)

ll_row_count = dw_sample.RowCount()
IF dw_sample.AcceptText() <> 1 THEN RETURN -1



/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
	ls_select_yn = this.getitemstring(i,"select_yn")
	ls_style = this.getitemstring(i,"style")
	ls_sample_cd = this.getitemstring(i,"sample_cd")
	ld_tdate		 = this.getitemdatetime(i,"time_6")
   idw_status = dw_sample.GetItemStatus(i, 0, Primary!)
	if ls_select_yn = 'N' then
		setnull(ls_select_yn)
		this.setitem(i,"style",ls_select_yn)	
	elseif  ls_select_yn = '' then
		setnull(ls_select_yn)
		this.setitem(i,"select_yn",ls_select_yn)			
	end if

///////////////
	ls_year = '202' + MidA(ls_style,3,1)
	if LenA(ls_style) = 8 then 	
		dw_sample.setitem(i,"brand" ,LeftA(ls_style,1))
		dw_sample.setitem(i,"sojae" ,MidA(ls_style,2,1))
		dw_sample.setitem(i,"year"  ,ls_year)
		dw_sample.setitem(i,"season",MidA(ls_style,4,1))
		dw_sample.setitem(i,"item"  ,MidA(ls_style,5,1))
	else
		ls_year = '202' + MidA(ls_sample_cd,3,1)
		dw_sample.setitem(i,"brand" ,LeftA(ls_sample_cd,1))
		dw_sample.setitem(i,"sojae" ,MidA(ls_sample_cd,2,1))
		dw_sample.setitem(i,"year"  ,ls_year)
		dw_sample.setitem(i,"season",MidA(ls_sample_cd,4,1))
		dw_sample.setitem(i,"item"  ,MidA(ls_sample_cd,5,1))
	end if
///////////////
	
	if ls_select_yn = 'Y' or ls_select_yn = 'N' then
		if isnull(ld_tdate) then this.setitem(i,"time_6",ld_datetime)		
	end if

	if (isnull(ls_select_yn) or ls_select_yn = '') and not isnull(ld_tdate) then 
		setnull(ld_tdate)
		this.setitem(i,"time_6",ld_tdate)
	end if
	
	
   IF idw_status = NewModified! THEN				/* New Record */
      dw_sample.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */		
      dw_sample.Setitem(i, "mod_id", gs_user_id)
      dw_sample.Setitem(i, "mod_dt", ld_datetime)
   END IF
next

il_rows = dw_sample.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_sample.ResetUpdate()
   commit  USING SQLCA;
	ib_changed2 = false
	dw_sample.object.t_msg.text = "저장되었습니다.."
else

   rollback  USING SQLCA;
end if

return il_rows


end event

event constructor;This.GetChild("sample_type", idw_sample_type)
idw_sample_type.SetTRansObject(SQLCA)
idw_sample_type.Retrieve('121')
idw_sample_type.insertrow(0)



This.GetChild("out_seq", idw_out_seq)
idw_out_seq.SetTRansObject(SQLCA)
idw_out_seq.Retrieve('010')
idw_out_seq.insertrow(0)


THIS.GetChild("dsgn_emp", idw_designer)
idw_designer.SetTransObject(SQLCA)
idw_designer.Retrieve(gs_brand, '%')

end event

event buttonclicked;choose case dwo.name
	case 'b_save'
		trigger event ue_update()
		this.visible = false
	case 'cb_mat_cd'
		Parent.Trigger Event ue_popup ('mat_cd', 1, '', 2)
end choose
end event

event dberror;///*===========================================================================*/
///* 작성자      : (주)지우정보 (김 태범)                                      */	
///* 작성일      : 1999.11.09																  */	
///* 수정일      : 1999.11.09																  */
///*===========================================================================*/
//
//string ls_message_string
//
//CHOOSE CASE sqldbcode
//	CASE 2627
//		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
//	CASE 515
//		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
//	CASE -1
//		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
//	CASE ELSE
//		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
//						        "~n" + "에러메세지("+sqlerrtext+")" 
//END CHOOSE
//
//This.ScrollTorow(row)
//This.SetRow(row)
//This.SetFocus()
//
//this.object.t_msg.text = ls_message_string
//return 1
end event

event editchanged;ib_changed2 = true

this.object.t_msg.text = ""

end event

event itemchanged;decimal ldc_tag_price, ldc_cost_price, ldc_baesu
ib_changed2 = true
choose case dwo.name
	CASE "baesu"	     //  Popup 검색창이 존재하는 항목 
		ldc_tag_price = this.getitemnumber(row,"tag_price")
		this.setitem(row,"cost_price",ldc_tag_price / dec(data))		

	CASE "cost_price"	     //  Popup 검색창이 존재하는 항목 
		ldc_tag_price = this.getitemnumber(row,"tag_price")
		this.setitem(row,"baesu",ldc_tag_price / dec(data))		

	CASE "tag_price"	     //  Popup 검색창이 존재하는 항목 
		ldc_cost_price = this.getitemnumber(row,"cost_price")
		this.setitem(row,"baesu",dec(data) / ldc_cost_price)	
		
	case "style"
		if uf_exist_style(data) then 
			messagebox("확인","스타일 번호가 이미 존재합니다.")
			return 2
		end if
		
	CASE "mat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
end choose

this.object.b_save.visible = true


end event

event losefocus;//trigger event ue_head()

end event

type dw_qc from datawindow within w_12022_e
event ue_keydown pbm_dwnkey
boolean visible = false
integer x = 2286
integer y = 528
integer width = 992
integer height = 448
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "직QC 등록"
string dataobject = "d_12022_qc"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
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
		IF ls_report = "1" THEN RETURN  0
	   ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
	   IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
			   					String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event clicked;string ls_style, ls_chno, ls_mat_nm, ls_msg

choose case dwo.name
	case 'b_save'		
		this.object.t_msg.text = ''
		IF dw_qc.AcceptText() <> 1 THEN RETURN -1
		ls_style = dw_qc.getitemstring(1,"style")
		ls_chno = dw_qc.getitemstring(1,"chno")
		ls_mat_nm = dw_qc.getitemstring(1,"mat_nm")
		
		if LenA(ls_style) <> 8 or isnull(ls_style) or LenA(ls_chno) <> 1 or isnull(ls_chno) then return -1
		
		declare sp_direct_qc procedure for sp_direct_qc
				@style	= :ls_style,
				@chno	   = :ls_chno,
				@mat_nm	= :ls_mat_nm;
					
		execute sp_direct_qc;	
		commit  USING SQLCA;

		select 'Y'
			into :ls_msg
		from tb_31030_m (nolock)
		where style = :ls_style
		and   chno  = :ls_chno;
		
		if ls_msg = 'Y' then						
			this.object.t_msg.text = '저장되었습니다..'
		else		
			this.object.t_msg.text = '저장중 에러발생!!!'
		end if					
		this.setcolumn('style')
		
	case 'b_insert'
		this.reset()
		this.object.t_msg.text = ''
		this.insertrow(0)
		this.setcolumn('style')
end choose
end event

type cb_direct_qc from commandbutton within w_12022_e
boolean visible = false
integer x = 4005
integer y = 204
integer width = 402
integer height = 84
integer taborder = 140
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "직QC 등록"
end type

event clicked;
if dw_qc.rowcount() > 0 then dw_qc.reset()
dw_qc.insertrow(0)
dw_qc.visible = true
dw_qc.setfocus()
dw_qc.setcolumn('style')


	
end event

type dw_1 from datawindow within w_12022_e
integer x = 2318
integer y = 948
integer width = 1266
integer height = 1084
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "브랜드별 진도율"
string dataobject = "d_12022_d05"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

