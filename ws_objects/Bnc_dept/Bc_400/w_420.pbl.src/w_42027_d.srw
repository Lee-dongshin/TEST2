$PBExportHeader$w_42027_d.srw
$PBExportComments$출고합계출력
forward
global type w_42027_d from w_com020_d
end type
type cb_print1 from commandbutton within w_42027_d
end type
type cbx_a4 from checkbox within w_42027_d
end type
end forward

global type w_42027_d from w_com020_d
integer width = 3680
integer height = 2288
event ue_print1 ( )
cb_print1 cb_print1
cbx_a4 cbx_a4
end type
global w_42027_d w_42027_d

type variables
DataWindowChild idw_brand, idw_house_cd, idw_jup_gubn, idw_out_type

String is_brand, is_yymmdd_st, is_yymmdd_ed, is_shop_cd_st, is_shop_cd_ed, is_house_cd, is_jup_gubn, is_out_type, is_gubun
String is_yymmdd, is_check_print, is_shop_cd, is_shop_type, is_out_no
long   il_rqst_chno, il_work_no

end variables

event ue_print1();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long   i,j,ll_row_count,ll_rows, JJ
Long ll_row_count1, ll_row_count2,  K
long ll_work_no[]
String ls_shop_type, ls_out_no, ls_jup_name, ls_modify, ls_Error
string ls_yymmdd

k = 1 
ll_row_count1 = dw_list.RowCount()
ll_row_count2 = dw_body.RowCount()
ll_row_count  = dw_body.RowCount()

		
if cbx_a4.checked then 		
	ls_jup_name = "(매 장 용)"								 
			for j = 1 to ll_row_count1
				 ls_yymmdd  = dw_list.getitemstring(j, "yymmdd")
				if dw_list.GetItemString(j, 'check_print') = 'Y'  THEN
							
							FOR i = 1 TO ll_row_count2
								dw_body.setitem(i, "check_print", "N")
							next
			
					 ll_work_no[K] = dw_list.getitemNumber(j, "work_no")		
							
					 if isnull(ll_work_no[K]) <> true then k = k + 1
				end if	 
			next			
			
			if k > 1 then
							dw_print.dataobject = "d_com422_a4"
							dw_print.SetTransObject(SQLCA)
						
							ll_rows = dw_print.retrieve(is_brand, ls_yymmdd, is_shop_cd_st, is_shop_cd_ed ,ll_work_no[1], ll_work_no[2], ll_work_no[3], ll_work_no[4], ll_work_no[5], ll_work_no[6], ll_work_no[7], ll_work_no[8], ll_work_no[9], ll_work_no[10],ll_work_no[11], ll_work_no[12], ll_work_no[13], ll_work_no[14], ll_work_no[15], ll_work_no[16], ll_work_no[17], ll_work_no[18], ll_work_no[19], ll_work_no[20], ll_work_no[21], ll_work_no[22], ll_work_no[23], ll_work_no[24], ll_work_no[25])
							
//							ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"
//							ls_Error = dw_print.Modify(ls_modify)
//									IF (ls_Error <> "") THEN 
//										MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
//									END IF
							
							If ll_rows > 0 Then il_rows = dw_print.Print()
							
			else			
					FOR i = 1 TO ll_row_count2
						is_shop_cd   = dw_body.GetItemString(i, 'shop_cd')
						is_shop_type = dw_body.GetItemString(i, 'shop_type')
						is_out_no    = dw_body.GetItemString(i, 'out_no')
						if dw_body.GetItemString(i, 'check_print') = 'Y' THEN
							
							dw_print.dataobject = "d_com420_A4"
							dw_print.SetTransObject(SQLCA)
						
							ll_rows = dw_print.retrieve(is_brand, is_yymmdd, is_shop_cd, is_shop_type, is_out_no, is_gubun)
			
//							ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"
//							ls_Error = dw_print.Modify(ls_modify)
//									IF (ls_Error <> "") THEN 
//										MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
//									END IF				
							
							If ll_rows > 0 Then il_rows = dw_print.Print()
							
						END IF
					NEXT
			end if
else			

	for j = 1 to ll_row_count1
		 ls_yymmdd  = dw_list.getitemstring(j, "yymmdd")
		if dw_list.GetItemString(j, 'check_print') = 'Y'  THEN
					
					FOR i = 1 TO ll_row_count2
						dw_body.setitem(i, "check_print", "N")
					next
	
			 ll_work_no[K] = dw_list.getitemNumber(j, "work_no")		
					
			 if isnull(ll_work_no[K]) <> true then k = k + 1
		end if	 
	next			
	
	if k > 1 then
					dw_print.dataobject = "d_com422_a4"
					dw_print.SetTransObject(SQLCA)
				
		for JJ = 1 to 3	
			if JJ = 1 then 
				ls_jup_name = "(거 래 처 용)"			
			elseif JJ = 2 then
				ls_jup_name = "(매 장 용)"			
			else
				ls_jup_name = "(창 고 용)"			
			end if				
				
					ll_rows = dw_print.retrieve(is_brand, ls_yymmdd, is_shop_cd_st, is_shop_cd_ed ,ll_work_no[1], ll_work_no[2], ll_work_no[3], ll_work_no[4], ll_work_no[5], ll_work_no[6], ll_work_no[7], ll_work_no[8], ll_work_no[9], ll_work_no[10],ll_work_no[11], ll_work_no[12], ll_work_no[13], ll_work_no[14], ll_work_no[15], ll_work_no[16], ll_work_no[17], ll_work_no[18], ll_work_no[19], ll_work_no[20], ll_work_no[21], ll_work_no[22], ll_work_no[23], ll_work_no[24], ll_work_no[25])
					
					ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"
					ls_Error = dw_print.Modify(ls_modify)
							IF (ls_Error <> "") THEN 
								MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
							END IF
					
					If ll_rows > 0 Then il_rows = dw_print.Print()
		NEXT			
					
	else			
			FOR i = 1 TO ll_row_count2
				is_shop_cd   = dw_body.GetItemString(i, 'shop_cd')
				is_shop_type = dw_body.GetItemString(i, 'shop_type')
				is_out_no    = dw_body.GetItemString(i, 'out_no')
				if dw_body.GetItemString(i, 'check_print') = 'Y' THEN
					
					dw_print.dataobject = "d_com420_A4"
					dw_print.SetTransObject(SQLCA)
				
					for JJ = 1 to 3	
						if JJ = 1 then 
							ls_jup_name = "(거 래 처 용)"			
						elseif JJ = 2 then
							ls_jup_name = "(매 장 용)"			
						else
							ls_jup_name = "(창 고 용)"			
						end if
					
						ll_rows = dw_print.retrieve(is_brand, is_yymmdd, is_shop_cd, is_shop_type, is_out_no, is_gubun)
		
						ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"
						ls_Error = dw_print.Modify(ls_modify)
								IF (ls_Error <> "") THEN 
									MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
								END IF				
						
						If ll_rows > 0 Then il_rows = dw_print.Print()
				   NEXT	
				END IF
			NEXT
	end if
end if


This.Trigger Event ue_msg(6, il_rows)

end event

on w_42027_d.create
int iCurrent
call super::create
this.cb_print1=create cb_print1
this.cbx_a4=create cbx_a4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print1
this.Control[iCurrent+2]=this.cbx_a4
end on

on w_42027_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_print1)
destroy(this.cbx_a4)
end on

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_yymmdd_st, is_yymmdd_ed, is_shop_cd_st, is_shop_cd_ed, is_house_cd, is_jup_gubn, is_out_type, is_gubun)
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

is_brand = dw_head.GetItemString(1, "brand")
IF IsNull(is_brand) OR Trim(is_brand) = "" THEN
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF

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


is_yymmdd_st = String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd')
IF IsNull(is_yymmdd_st) OR Trim(is_yymmdd_st) = "" THEN
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   RETURN FALSE
END IF

is_yymmdd_ed = String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd')
IF IsNull(is_yymmdd_ed) OR Trim(is_yymmdd_ed) = "" THEN
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF

IF is_yymmdd_ed < is_yymmdd_st THEN
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF

is_shop_cd_st = dw_head.GetItemString(1, "shop_cd_st")
IF IsNull(is_shop_cd_st) OR Trim(is_shop_cd_st) = "" THEN is_shop_cd_st = is_brand + '00000'

is_shop_cd_ed = dw_head.GetItemString(1, "shop_cd_ed")
IF IsNull(is_shop_cd_ed) OR Trim(is_shop_cd_ed) = "" THEN is_shop_cd_ed = is_brand + 'ZZZZZ'

IF is_shop_cd_ed < is_shop_cd_st THEN
   MessageBox(ls_title,"마지막 코드가 시작 코드보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd_ed")
   RETURN FALSE
END IF

is_house_cd = dw_head.GetItemString(1, "house_cd")
IF IsNull(is_house_cd) OR Trim(is_house_cd) = "" THEN
   MessageBox(ls_title,"창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   RETURN FALSE
END IF

is_jup_gubn = dw_head.GetItemString(1, "jup_gubn")
IF IsNull(is_jup_gubn) OR Trim(is_jup_gubn) = "" THEN
   MessageBox(ls_title,"전표 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jup_gubn")
   RETURN FALSE
END IF

is_out_type = dw_head.GetItemString(1, "out_type")
IF IsNull(is_out_type) OR Trim(is_out_type) = "" THEN
   MessageBox(ls_title,"출고 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_type")
   RETURN FALSE
END IF

is_gubun = "1" 

//dw_head.GetItemString(1, "gubun")
//IF IsNull(is_gubun) OR Trim(is_gubun) = "" THEN
//   MessageBox(ls_title,"조회 구분을 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("gubun")
//   RETURN FALSE
//END IF

RETURN TRUE

end event

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_shop_div
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd_st"
		is_brand = Trim(dw_head.GetItemString(1, "brand"))

		IF ai_div = 1 THEN 	
			IF IsNull(as_data) OR Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "shop_nm_st", "")
				RETURN 0
			END IF 
				
			IF LeftA(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm_st", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND Shop_Stat = '00' "
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = CREATE DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = TRUE
			lds_Source = Message.PowerObjectParm
			dw_head.SetRow(al_row)
			dw_head.SetColumn(as_column)
			dw_head.SetItem(al_row, "shop_cd_st", lds_Source.GetItemString(1,"shop_cd"))
			dw_head.SetItem(al_row, "shop_nm_st", lds_Source.GetItemString(1,"shop_snm"))
			/* 다음컬럼으로 이동 */
			dw_head.SetColumn("shop_cd_ed")
			ib_itemchanged = FALSE 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		DESTROY lds_Source
	CASE "shop_cd_ed"
		is_brand = Trim(dw_head.GetItemString(1, "brand"))

		IF ai_div = 1 THEN 	
			IF IsNull(as_data) OR Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "shop_nm_ed", "")
				RETURN 0
			END IF 
			IF LeftA(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm_ed", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND Shop_Stat = '00' "
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = CREATE DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = TRUE
			lds_Source = Message.PowerObjectParm
			dw_head.SetRow(al_row)
			dw_head.SetColumn(as_column)
			dw_head.SetItem(al_row, "shop_cd_ed", lds_Source.GetItemString(1,"shop_cd"))
			dw_head.SetItem(al_row, "shop_nm_ed", lds_Source.GetItemString(1,"shop_snm"))
			/* 다음컬럼으로 이동 */
			ib_itemchanged = FALSE
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		DESTROY lds_Source
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

event ue_print();/*===========================================================================*/
/* 작성자      :                                               */	
/* 작성일      :                                                 */	
/* 수정일      :                                                */
/*===========================================================================*/
Long ll_row_count1, ll_row_count2,i, ll_rows, J ,K
long ll_work_no[]
string ls_yymmdd

k = 1 
ll_row_count1 = dw_list.RowCount()
ll_row_count2 = dw_body.RowCount()

for j = 1 to ll_row_count1
    ls_yymmdd  = dw_list.getitemstring(j, "yymmdd")
	if dw_list.GetItemString(j, 'check_print') = 'Y'  THEN
				
				FOR i = 1 TO ll_row_count2
					dw_body.setitem(i, "check_print", "N")
				next

       ll_work_no[K] = dw_list.getitemNumber(j, "work_no")		
		 		
		 if isnull(ll_work_no[K]) <> true then k = k + 1
	end if	 
			
next			

if k > 0 then
//		messagebox("","if")
          	dw_print.dataobject = "d_com422"
				dw_print.SetTransObject(SQLCA)
			
		ll_rows = dw_print.retrieve(is_brand, ls_yymmdd, is_shop_cd_st, is_shop_cd_ed ,ll_work_no[1], ll_work_no[2], ll_work_no[3], ll_work_no[4], ll_work_no[5], ll_work_no[6], ll_work_no[7], ll_work_no[8], ll_work_no[9], ll_work_no[10],ll_work_no[11], ll_work_no[12], ll_work_no[13], ll_work_no[14], ll_work_no[15], ll_work_no[16], ll_work_no[17], ll_work_no[18], ll_work_no[19], ll_work_no[20], ll_work_no[21], ll_work_no[22], ll_work_no[23], ll_work_no[24], ll_work_no[25])
				If ll_rows > 0 Then il_rows = dw_print.Print()
				
else		
//	messagebox("","else")
		FOR i = 1 TO ll_row_count2
			is_shop_cd   = dw_body.GetItemString(i, 'shop_cd')
			is_shop_type = dw_body.GetItemString(i, 'shop_type')
			is_out_no    = dw_body.GetItemString(i, 'out_no')
			if dw_body.GetItemString(i, 'check_print') = 'Y' THEN
				
				dw_print.dataobject = "d_com420"
				dw_print.SetTransObject(SQLCA)
			
				ll_rows = dw_print.retrieve(is_brand, is_yymmdd, is_shop_cd, is_shop_type, is_out_no, is_gubun)
				If ll_rows > 0 Then il_rows = dw_print.Print()
				
			END IF
			
 		NEXT
end if


//dw_print.inv_printpreview.of_SetZoom()

This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42027_d","0")
end event

event ue_button(integer ai_cb_div, long al_rows);
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
      else
         dw_head.SetFocus()
      end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_print1.enabled = false		
      cb_preview.enabled = false
      cb_excel.enabled = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_print1.enabled = true			
         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_print.enabled = false
         cb_print1.enabled = false			
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if
END CHOOSE

end event

event ue_preview();/*===========================================================================*/
/* 작성자      :                                               */	
/* 작성일      :                                                 */	
/* 수정일      :                                                */
/*===========================================================================*/
Long ll_row_count1, ll_row_count2,i, ll_rows, J ,K
long ll_work_no[]
string ls_yymmdd

k = 1 
ll_row_count1 = dw_list.RowCount()
ll_row_count2 = dw_body.RowCount()

for j = 1 to ll_row_count1
    ls_yymmdd  = dw_list.getitemstring(j, "yymmdd")
	if dw_list.GetItemString(j, 'check_print') = 'Y'  THEN
				
				FOR i = 1 TO ll_row_count2
					dw_body.setitem(i, "check_print", "N")
				next

       ll_work_no[K] = dw_list.getitemNumber(j, "work_no")		
		 		
		 if isnull(ll_work_no[K]) <> true then k = k + 1
	end if	 
			
next			

if k > 0 then
//		messagebox("","if")
          	dw_print.dataobject = "d_com422"
				dw_print.SetTransObject(SQLCA)
			
				ll_rows = dw_print.retrieve(is_brand, ls_yymmdd, is_shop_cd_st, is_shop_cd_ed ,ll_work_no[1], ll_work_no[2], ll_work_no[3], ll_work_no[4], ll_work_no[5], ll_work_no[6], ll_work_no[7], ll_work_no[8], ll_work_no[9], ll_work_no[10])
//				If ll_rows > 0 Then il_rows = dw_print.Print()
				
else		
//	messagebox("","else")
		FOR i = 1 TO ll_row_count2
			is_shop_cd   = dw_body.GetItemString(i, 'shop_cd')
			is_shop_type = dw_body.GetItemString(i, 'shop_type')
			is_out_no    = dw_body.GetItemString(i, 'out_no')
			if dw_body.GetItemString(i, 'check_print') = 'Y' THEN
				
				dw_print.dataobject = "d_com420"
				dw_print.SetTransObject(SQLCA)
			
				ll_rows = dw_print.retrieve(is_brand, is_yymmdd, is_shop_cd, is_shop_type, is_out_no, is_gubun)
//				If ll_rows > 0 Then il_rows = dw_print.Print()
				
			END IF
			
 		NEXT
end if


dw_print.inv_printpreview.of_SetZoom()

This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com020_d`cb_close within w_42027_d
end type

type cb_delete from w_com020_d`cb_delete within w_42027_d
end type

type cb_insert from w_com020_d`cb_insert within w_42027_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_42027_d
end type

type cb_update from w_com020_d`cb_update within w_42027_d
end type

type cb_print from w_com020_d`cb_print within w_42027_d
end type

type cb_preview from w_com020_d`cb_preview within w_42027_d
end type

type gb_button from w_com020_d`gb_button within w_42027_d
end type

type cb_excel from w_com020_d`cb_excel within w_42027_d
end type

type dw_head from w_com020_d`dw_head within w_42027_d
integer y = 140
integer width = 3474
integer height = 372
string dataobject = "d_42027_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()

THIS.GetChild("jup_gubn", idw_jup_gubn)
idw_jup_gubn.SetTransObject(SQLCA)
idw_jup_gubn.Retrieve('025')
idw_jup_gubn.InsertRow(1)
idw_jup_gubn.SetItem(1, "inter_cd", '%')
idw_jup_gubn.SetItem(1, "inter_nm", '전체')

THIS.GetChild("out_type", idw_out_type)
idw_out_type.SetTransObject(SQLCA)
idw_out_type.Retrieve('420')
idw_out_type.InsertRow(1)
idw_out_type.SetItem(1, "inter_cd", '%')
idw_out_type.SetItem(1, "inter_nm", '전체')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.06                                                  */	
/* 수정일      : 2002.02.06                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		IF LeftA(dw_head.GetItemString(1, "shop_cd_st"), 1) <> data THEN
			dw_head.SetItem(1, "shop_cd_st", "")
			dw_head.SetItem(1, "shop_nm_st", "")
		END IF
		If LeftA(dw_head.GetItemString(1, "shop_cd_ed"), 1) <> data THEN
			dw_head.SetItem(1, "shop_cd_ed", "")
			dw_head.SetItem(1, "shop_nm_ed", "")
		END IF
	CASE "gubun"
		IF data = '1' THEN
			dw_head.SetItem(1, "out_type", '%')
			dw_head.Object.out_type.Protect = 0
			dw_head.Object.out_type.BackGround.Color = RGB(255, 255, 255)
		ELSE
			dw_head.SetItem(1, "out_type", '%')
			dw_head.Object.out_type.Protect = 1
			dw_head.Object.out_type.BackGround.Color = RGB(192, 192, 192)
		END IF		
	CASE "shop_cd_st", "shop_cd_ed"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		RETURN PARENT.TRIGGER EVENT ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_d`ln_1 within w_42027_d
integer beginy = 520
integer endy = 520
end type

type ln_2 from w_com020_d`ln_2 within w_42027_d
integer beginy = 524
integer endy = 524
end type

type dw_list from w_com020_d`dw_list within w_42027_d
integer x = 14
integer y = 540
integer width = 933
integer height = 1500
string dataobject = "d_42027_d01"
end type

event dw_list::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_yymmdd    = This.GetItemString(row, 'yymmdd') /* DataWindow에 Key 항목을 가져온다 */
il_rqst_chno = This.GetItemNumber(row, 'rqst_chno')
il_work_no   = This.GetItemNumber(row, 'work_no')

IF IsNull(is_yymmdd) THEN return
IF IsNull(il_rqst_chno) THEN  il_rqst_chno  = -1
IF IsNull(il_work_no) THEN  il_work_no  = -1

is_check_print = 'N'
dw_body.Object.cb_check_print.Text = '전체선택'

//messagebox("is_brand", is_brand)
//messagebox("is_yymmdd", is_yymmdd)
//messagebox("is_shop_cd_st", is_shop_cd_st)
//messagebox("is_shop_cd_ed", is_shop_cd_ed)
//messagebox("is_house_cd", is_house_cd)
//messagebox("is_jup_gubn", is_jup_gubn)
//messagebox("is_out_type", is_out_type)
//messagebox("il_rqst_chno", string(il_rqst_chno))
//messagebox("il_work_no", string(il_work_no))

il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_shop_cd_st, is_shop_cd_ed, is_house_cd, &
									is_jup_gubn, is_out_type,  il_work_no, is_gubun)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_d`dw_body within w_42027_d
integer x = 965
integer y = 536
integer width = 2633
integer height = 1504
string dataobject = "d_42027_d02"
end type

event dw_body::buttonclicked;Long	ll_row_count, i

CHOOSE CASE dwo.name
	CASE "cb_check_print"
		If is_check_print = 'N' then
			is_check_print = 'Y'
			This.Object.cb_check_print.Text = '전체제외'
		Else
			is_check_print = 'N'
			This.Object.cb_check_print.Text = '전체선택'
		End If
		
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "check_print", is_check_print)
		Next
END CHOOSE

end event

type st_1 from w_com020_d`st_1 within w_42027_d
integer x = 951
integer y = 540
integer height = 1500
end type

type dw_print from w_com020_d`dw_print within w_42027_d
integer x = 1143
integer y = 896
integer width = 2281
integer height = 440
string dataobject = "d_com422"
end type

type cb_print1 from commandbutton within w_42027_d
integer x = 37
integer y = 44
integer width = 384
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "명세서A4양식"
end type

event clicked;Parent.Trigger Event ue_print1()
end event

type cbx_a4 from checkbox within w_42027_d
integer x = 425
integer y = 64
integer width = 699
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "명세서A4양식(매장용)"
borderstyle borderstyle = stylelowered!
end type

