$PBExportHeader$w_43030_e.srw
$PBExportComments$창고실사내역
forward
global type w_43030_e from w_com020_e
end type
type dw_1 from datawindow within w_43030_e
end type
type dw_head1 from u_dw within w_43030_e
end type
end forward

global type w_43030_e from w_com020_e
integer width = 3675
event type boolean ue_keycheck2 ( string as_cb_div )
dw_1 dw_1
dw_head1 dw_head1
end type
global w_43030_e w_43030_e

type variables
string is_brand, is_proc_gubn, is_fr_ymd, is_to_ymd, is_view_opt, is_yymmdd, is_shop_cd, is_shop_type
string is_jup_grp, is_house_cd, is_pda_no, is_proc_type, is_empno
DataWindowChild idw_brand, idw_shop_type, idw_house_cd
end variables

event type boolean ue_keycheck2(string as_cb_div);String   ls_title

IF as_cb_div = '1' THEN
	ls_title = "조회오류"
ELSEIF as_cb_div = '2' THEN
	ls_title = "추가오류"
ELSEIF as_cb_div = '3' THEN
	ls_title = "저장오류"
ELSE
	ls_title = "오류"
END IF

IF dw_head1.AcceptText() <> 1 THEN RETURN FALSE

is_yymmdd = dw_head1.GetItemString(1, "out_ymd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"출고일자를 입력하십시요!")
	dw_head1.SetFocus()
   dw_head1.SetColumn("out_ymd")
   return false
end if

is_shop_cd = dw_head1.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"출고대상 매장을 입력하십시요!")
   dw_head1.SetFocus()
   dw_head1.SetColumn("shop_cd")
   return false
end if

is_shop_type = dw_head1.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"출고대상 매장형태를 입력하십시요!")
   dw_head1.SetFocus()
   dw_head1.SetColumn("shop_type")
   return false
end if

is_jup_grp = dw_head1.GetItemString(1, "jup_grp")
if IsNull(is_jup_grp) or Trim(is_jup_grp) = "" then
   MessageBox(ls_title,"전표그룹을 입력하십시요!")
   dw_head1.SetFocus()
   dw_head1.SetColumn("jup_grp")
   return false
end if

return true

end event

on w_43030_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_head1=create dw_head1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_head1
end on

on w_43030_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_head1)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head1, "ScaleToRight")
inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
dw_1.SetTransObject(SQLCA)
dw_head1.InsertRow(0)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43030_e","0")
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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



if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif (gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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

is_proc_gubn = dw_head.GetItemString(1, "proc_gubn")
if IsNull(is_proc_gubn) or Trim(is_proc_gubn) = "" then
   MessageBox(ls_title,"출고여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("proc_gubn")
   return false
end if

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"조회시작일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"조회 마지막일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_view_opt = dw_head.GetItemString(1, "view_opt")
if IsNull(is_view_opt) or Trim(is_view_opt) = "" then
   MessageBox(ls_title,"조회 방법을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("view_opt")
   return false
end if

is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"실사창고를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if

is_pda_no = dw_head.GetItemString(1, "pda_no")
if IsNull(is_pda_no) or Trim(is_pda_no) = "" then
   MessageBox(ls_title,"PDA번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("pda_no")
   return false
end if

is_pda_no = "%"

is_proc_type = dw_head.GetItemString(1, "proc_type")

is_empno = dw_head.GetItemString(1, "empno")
if IsNull(is_empno) or Trim(is_empno) = "" then
 is_empno = "%"
end if



return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//@BRAND     	varchar(01), 
//@FR_YMD    	varchar(08), 
//@TO_YMD    	varchar(08), 
//@house     	varchar(06) ,
//@PROC_GUBN	VARCHAR(01) 


if is_view_opt = "B" then 
	dw_print.dataobject = "d_43030_r03"
	dw_print.SetTransObject(SQLCA)
	
	il_rows = dw_1.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_house_cd, is_proc_gubn, is_pda_no, is_empno)
	IF il_rows > 0 THEN
		dw_1.SetFocus()
		dw_1.visible = true			
	else	
		dw_1.visible = false			
	END IF
else
	dw_print.dataobject = "d_43030_r02"	
	dw_print.SetTransObject(SQLCA)
	
	dw_1.visible = false		
	il_rows = dw_list.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_house_cd, is_proc_gubn, is_pda_no, is_empno)
	dw_body.Reset()
	IF il_rows > 0 THEN
		dw_list.SetFocus()
	END IF
end if	

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count, ll_ok
datetime ld_datetime
String ls_yymmdd, ls_sil_no, ls_proc_gubn, ls_out_no, ls_shop_cd, ls_to_shop_cd, ls_note, ls_note_chk


ll_row_count = dw_list.RowCount()
IF dw_list.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

IF is_house_cd = "000000" THEN
	MESSAGEBOX("알림!", "물류+온라인창고 선택시 작업을 진행할 수 없습니다!") 
	Return 0
END IF

FOR i=1 TO ll_row_count
	
 ls_yymmdd = dw_list.getitemstring(i, "yymmdd")	
 ls_sil_no = dw_list.getitemstring(i, "sil_no") 
 ls_out_no = dw_list.getitemstring(i, "out_no") 
 ls_proc_gubn = dw_list.getitemstring(i, "proc_yn") 
 ls_to_shop_cd = dw_list.getitemstring(i, "to_shop_cd") 
 
 if is_proc_type = "R" then 
  ls_note ="[반품] " + dw_list.getitemstring(i, "note") 
 elseif is_proc_type = "S" then 
  ls_note ="[창고이동] " + dw_list.getitemstring(i, "note")   
 else 
  ls_note = dw_list.getitemstring(i, "note") 
 end if 
 
	 if isnull(ls_out_no) and ls_proc_gubn = "Y" then 
		
		IF Trigger Event ue_keycheck2('1') = FALSE THEN return -1

//			messagebox("ls_proc_gubn", ls_proc_gubn)
			
			
	 if is_proc_type = "O" then 		
			 DECLARE sp_43030_d04 PROCEDURE FOR sp_43030_d04  
						@yymmdd       = :ls_yymmdd,   
						@sil_no       = :ls_sil_no,   
						@shop_cd      = :is_house_cd,   
						@brand        = :is_brand,   
						@to_ymd       = :is_yymmdd,   
						@to_shop_cd   = :is_shop_cd,   
						@to_shop_type = :is_shop_type,   
						@jup_grp		  = :is_jup_grp,
						@reg_id       = :gs_user_id,
						@note			  = :ls_note	;
						
			 execute sp_43030_d04;
			 commit  USING SQLCA; 			
   	elseif is_proc_type = "R" then 		 
			 DECLARE sp_43030_d05 PROCEDURE FOR sp_43030_d05  
						@yymmdd       = :ls_yymmdd,   
						@sil_no       = :ls_sil_no,   
						@shop_cd      = :is_house_cd,   
						@brand        = :is_brand,   
						@to_ymd       = :is_yymmdd,   
						@to_shop_cd   = :is_shop_cd,   
						@to_shop_type = :is_shop_type,   
						@jup_grp		  = :is_jup_grp,
						@reg_id       = :gs_user_id,
						@note			  = :ls_note	;
						
			 execute sp_43030_d05;
			 commit  USING SQLCA; 						 
   	elseif is_proc_type = "S" then 		 
			 DECLARE sp_43030_d06 PROCEDURE FOR sp_43030_d06
						@yymmdd       = :ls_yymmdd,   
						@sil_no       = :ls_sil_no,   
						@fr_house_cd  = :is_house_cd,   
						@brand        = :is_brand,   
						@to_ymd       = :is_yymmdd,   
						@to_house_cd  = :is_shop_cd,   
						@to_shop_type = :is_shop_type,   
						@jup_grp		  = :is_jup_grp,
						@reg_id       = :gs_user_id,
						@note			  = :ls_note	;
						
			 execute sp_43030_d06;
			 commit  USING SQLCA; 			
   	elseif is_proc_type = "I" then 		 
			 DECLARE sp_43030_d07 PROCEDURE FOR sp_43030_d07
						@yymmdd       = :ls_yymmdd,   
						@sil_no       = :ls_sil_no,   
						@fr_house_cd  = :is_house_cd,   
						@brand        = :is_brand,   
						@to_ymd       = :is_yymmdd,   
						@to_house_cd  = :is_shop_cd,   
						@to_shop_type = :is_shop_type,   
						@jup_grp		  = :is_jup_grp,
						@reg_id       = :gs_user_id,
						@note			  = :ls_note	;
						
			 execute sp_43030_d07;
			 commit  USING SQLCA; 						 
   	elseif is_proc_type = "J" then 		 
			 DECLARE sp_43030_d08 PROCEDURE FOR sp_43030_d08
						@yymmdd       = :ls_yymmdd,   
						@sil_no       = :ls_sil_no,   
						@fr_house_cd  = :is_house_cd,   
						@brand        = :is_brand,   
						@to_ymd       = :is_yymmdd,   
						@to_house_cd  = :is_shop_cd,   
						@to_shop_type = :is_shop_type,   
						@jup_grp		  = :is_jup_grp,
						@reg_id       = :gs_user_id,
						@note			  = :ls_note	;
						
			 execute sp_43030_d08;
			 commit  USING SQLCA; 						 
			 
			 
		end if			
			
		 
		IF SQLCA.SQLCODE <> 0  THEN 
			rollback  USING SQLCA; 
		else 
			ll_ok = ll_ok + 1
		END IF 

	ELSE
   	 idw_status = dw_list.GetItemStatus(i, 0, Primary!)
   iF idw_status = DataModified! THEN		/* Modify Record */
     		
			UPDATE TB_44120_H  SET NOTE = :ls_note
			WHERE YYMMDD = :LS_YYMMDD
			  AND SIL_NO = :LS_SIL_NO
			  AND SHOP_CD = :is_house_cd ;
			  
			ls_note_chk = "Y"

   END IF
		
	end if				 
			
NEXT

		if ll_ok > 0 then 
			messagebox("알림!" , "총 " + string(ll_ok) + "건의 실사 자료가 처리되었습니다!")
		   ib_changed = false
			Trigger Event ue_retrieve()

		else
			if ls_note_chk  <> "Y" then
				messagebox("알림!" , "출고 처리된 실자료가 없습니다!")
			else	
				messagebox("알림!" , "비고내역이 저장되었습니다!")
			   ib_changed = false
				Trigger Event ue_retrieve()
			end if	
			
      end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows


end event

event ue_button(integer ai_cb_div, long al_rows);
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
			cb_print.enabled = true
			cb_excel.enabled = true			
         dw_head.Enabled = false
         dw_head1.Enabled = true
         dw_list.Enabled = true
         dw_body.Enabled = true
      else
         dw_head.SetFocus()
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
				dw_head1.Enabled = true
				dw_list.Enabled = true
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
			dw_head1.Enabled = false
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
      cb_insert.enabled = false
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head1.Enabled = true		
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
         cb_insert.enabled = true
      end if
END CHOOSE

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
String 	  ls_plan_yn, ls_SHOP_TYPE, ls_proc_type, ls_emp_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
		is_brand = dw_head.getitemstring(1, "brand")
		ls_proc_type = dw_head.getitemstring(1, "proc_type")
		
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head1.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm3(as_data, 'S', ls_shop_nm) = 0 THEN
					if LeftA(as_data,1) = is_brand and ls_proc_type <> "S" then
						dw_head1.SetItem(al_row, "shop_nm", ls_shop_nm)
						RETURN 0
					else	
						dw_head1.SetItem(al_row, "shop_nm", ls_shop_nm)
						RETURN 0						
					end if	
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			
			if ls_proc_type = "S" then
		    gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV = 'A' " 
			else								 
		
					if is_brand = 'N' or is_brand = 'J' then		
						 gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
														 "  AND SHOP_DIV  IN ('G', 'K', 'X', 'T','A','O') " + &
														 "  AND BRAND in ( 'N','J') "
					else									 
					    gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV  IN ('G', 'K', 'X', 'T','A','O') " + &
											 "  AND BRAND = '" + is_brand + "'"
					end if						 
	   	end if										 
											 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source

	CASE "empno"				
			IF ai_div = 1 THEN 	
				IF gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
						messagebox("ls_emp_nm", ls_emp_nm)
				   dw_head.SetItem(al_row, "emp_nm", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원 정보 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			gst_cd.default_where   = "WHERE goout_gubn = '1' and substring(dept_code,2,1) <> 'A' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(empno LIKE '" + as_data + "%'   or  kname LIKE '%" + as_data + "%') "
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
				dw_head.SetItem(al_row, "empno", lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "emp_nm", lds_Source.GetItemString(1,"kname"))
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

event ue_excel();string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)

if dw_1.visible then
	li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
else
	li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
end if	
	
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event ue_title();call super::ue_title;string ls_modify, ls_datetime
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


	ls_modify =	 "t_pg_id.Text = '" + is_pgm_id + "'" + &
					 "t_user_id.Text = '" + gs_user_id + "'" + &
					 "t_datetime.Text = '" + ls_datetime + "'" + &
					 "t_brand.Text = '" +idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &				 
					 "t_fr_ymd.Text = '" + is_fr_ymd + "'" + &
					 "t_to_ymd.Text = '" + is_to_ymd + "'" 
					

					 


dw_print.Modify(ls_modify)


end event

event ue_print();integer i
String ls_print_out, ls_yymmdd, ls_sil_no,ls_modify, ls_datetime, ls_house_cd
datetime ld_datetime


if dw_1.visible then 

	This.Trigger Event ue_title()
	dw_1.ShareData(dw_print)
	
	IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
	ELSE
		il_rows = dw_print.Print()
	END IF

else 
	
	IF gf_sysdate(ld_datetime) = FALSE THEN
		ld_datetime = DateTime(Today(), Now())
	END IF

	ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

	FOR i = 1 TO dw_list.RowCount() 
	ls_print_out = dw_list.getitemstring(i, "print_out")

	IF ls_print_out = "Y"  THEN 
	
		ls_yymmdd     = dw_list.GetitemString(i, "yymmdd")			 
		ls_sil_no     = dw_list.GetitemString(i, "sil_no")
		
		il_rows = dw_print.retrieve(is_brand, ls_yymmdd, ls_sil_no, is_house_cd)
		IF dw_print.RowCount() > 0 Then
			
			ls_modify =	 "t_pg_id.Text = '" + is_pgm_id + "'" + &
					 "t_user_id.Text = '" + gs_user_id + "'" + &
					 "t_datetime.Text = '" + ls_datetime + "'" + &
					 "t_brand.Text = '" +idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &				 
					 "t_yymmdd.Text = '" + ls_yymmdd + "'" + &
					 "t_sil_no.Text = '" + ls_sil_no + "'" 
					 				 
					 
			dw_print.Modify(ls_modify)
			
//			dw_print.inv_printpreview.of_SetZoom()
			il_rows = dw_print.Print()
		END IF
	END IF 	
	
	
NEXT 
	
end if



This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com020_e`cb_close within w_43030_e
end type

type cb_delete from w_com020_e`cb_delete within w_43030_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_43030_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_43030_e
end type

type cb_update from w_com020_e`cb_update within w_43030_e
end type

type cb_print from w_com020_e`cb_print within w_43030_e
end type

type cb_preview from w_com020_e`cb_preview within w_43030_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_43030_e
end type

type cb_excel from w_com020_e`cb_excel within w_43030_e
end type

type dw_head from w_com020_e`dw_head within w_43030_e
integer y = 156
integer height = 204
string dataobject = "d_43030_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()
idw_house_cd.insertrow(1)
idw_house_cd.Setitem(1, "shop_cd", "000000")
idw_house_cd.Setitem(1, "shop_snm", "물류+온라인창고")



end event

event dw_head::itemchanged;call super::itemchanged;int li_ret

CHOOSE CASE dwo.name
	
	CASE "shop_cd"	 ,"empno"    //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

type ln_1 from w_com020_e`ln_1 within w_43030_e
integer beginy = 484
integer endy = 484
end type

type ln_2 from w_com020_e`ln_2 within w_43030_e
integer beginy = 488
integer endy = 488
end type

type dw_list from w_com020_e`dw_list within w_43030_e
integer x = 14
integer y = 496
integer width = 1966
integer height = 1508
string dataobject = "d_43030_d01"
boolean hscrollbar = true
end type

event dw_list::clicked;call super::clicked;string ls_sil_no, ls_yymmdd

IF row <= 0 THEN Return

	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_sil_no = This.GetItemString(row, 'sil_no') /* DataWindow에 Key 항목을 가져온다 */
ls_yymmdd = This.GetItemString(row, 'yymmdd') /* DataWindow에 Key 항목을 가져온다 */


IF IsNull(ls_sil_no) THEN return
il_rows = dw_body.retrieve(is_brand, ls_yymmdd, ls_sil_no, is_house_cd)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

event dw_list::itemchanged;call super::itemchanged;

CHOOSE CASE dwo.name
	CASE "proc_yn" 
	   ib_changed = true
		cb_update.enabled = true

	CASE  "note"
	IF ib_itemchanged THEN RETURN 1
	   ib_changed = true
		cb_update.enabled = true



END CHOOSE
end event

event dw_list::buttonclicked;call super::buttonclicked;/*===========================================================================*/
Long i
String ls_yn, ls_out_no

If dwo.Name = 'cb_o_sel' Then
	If dwo.Text = '출반생성' Then
		ls_yn = 'Y'
		dwo.Text = '출반제외'
	Else
		ls_yn = 'N'
		dwo.Text = '출반생성'
	End If
	
	For i = 1 To This.RowCount()
		ls_out_no = dw_list.getitemstring(i, "out_no")
		if isnull(ls_out_no) or LenA(ls_out_no) <> 4 then 
			This.SetItem(i, "proc_yn", ls_yn)
		end if
	Next
elseIf dwo.Name = 'cb_p_sel' Then
	If dwo.Text = '출력' Then
		ls_yn = 'Y'
		dwo.Text = '제외'
	Else
		ls_yn = 'N'
		dwo.Text = '출력'
	End If
	
	For i = 1 To This.RowCount()
		This.SetItem(i, "print_out", ls_yn)		
	Next	
End If

end event

type dw_body from w_com020_e`dw_body within w_43030_e
integer x = 2002
integer y = 496
integer width = 1591
integer height = 1508
string dataobject = "d_43030_d02"
boolean hscrollbar = true
end type

type st_1 from w_com020_e`st_1 within w_43030_e
integer x = 1989
integer y = 500
integer height = 1508
end type

type dw_print from w_com020_e`dw_print within w_43030_e
string dataobject = "d_43030_r02"
end type

type dw_1 from datawindow within w_43030_e
boolean visible = false
integer x = 14
integer y = 496
integer width = 3557
integer height = 1508
integer taborder = 40
boolean bringtotop = true
string title = "전체조회"
string dataobject = "d_43030_d03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_head1 from u_dw within w_43030_e
integer x = 27
integer y = 364
integer width = 3552
integer height = 116
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_43030_h02"
boolean vscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('009')

end event

event itemchanged;call super::itemchanged;String ls_yymmdd

CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

