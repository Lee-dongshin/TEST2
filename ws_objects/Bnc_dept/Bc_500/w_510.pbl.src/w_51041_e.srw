$PBExportHeader$w_51041_e.srw
$PBExportComments$일용근로소득등록처리
forward
global type w_51041_e from w_com020_e
end type
type cb_batch from commandbutton within w_51041_e
end type
type cb_proc from commandbutton within w_51041_e
end type
end forward

global type w_51041_e from w_com020_e
cb_batch cb_batch
cb_proc cb_proc
end type
global w_51041_e w_51041_e

type variables
string is_slip_bonji, is_happen_date, is_empno, is_ilyong_no, is_jumn_no, is_gubn, is_appl_code
Datawindowchild idw_slip_bonji
end variables

on w_51041_e.create
int iCurrent
call super::create
this.cb_batch=create cb_batch
this.cb_proc=create cb_proc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_batch
this.Control[iCurrent+2]=this.cb_proc
end on

on w_51041_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_batch)
destroy(this.cb_proc)
end on

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

is_slip_bonji = dw_head.GetItemString(1, "slip_bonji")
if IsNull(is_slip_bonji) or Trim(is_slip_bonji) = "" then
   MessageBox(ls_title,"사업장 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("slip_bonji")
   return false
end if


is_happen_date = dw_head.GetItemString(1, "happen_date")
if IsNull(is_happen_date) or Trim(is_happen_date) = "" or LenA(Trim(is_happen_date)) <> 8  then
   MessageBox(ls_title,"등록일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("happen_date")
   return false
end if

is_happen_date = MidA(is_happen_date,1,4) + "." + MidA(is_happen_date,5,2) + "." + MidA(is_happen_date,7,2)

is_empno = dw_head.GetItemString(1, "empno")
if IsNull(is_empno) or Trim(is_empno) = "" then
   MessageBox(ls_title,"등록자 사번을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("empno")
   return false
end if

is_appl_code = dw_head.GetItemString(1, "appl_code")
if IsNull(is_appl_code) or Trim(is_appl_code) = "" then
   MessageBox(ls_title,"전표처리를 위한 예산부서를 입력하십시요!")
	dw_head.SetFocus()
   dw_head.SetColumn("appl_code")
   return false
end if

is_gubn = dw_head.GetItemString(1, "gubn")
if IsNull(is_gubn) or Trim(is_gubn) = "" then
   MessageBox(ls_title,"전표처리 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubn")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_slip_bonji, is_happen_date, is_empno, is_gubn)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);string ls_slip_date

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
//	    cb_retrieve.Text = "조건(&Q)"
//       dw_head.Enabled = false
//       dw_body.Enabled = false
		 cb_insert.Enabled = True
		 
		 if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
			cb_batch.Enabled = true
			cb_proc.Enabled = true
      else
			cb_insert.Enabled = True
			cb_batch.Enabled = false
			cb_proc.Enabled = false			
         dw_head.SetFocus()
      end if		 
		 
		 
   CASE 2      /* 추가 */
      if al_rows > 0 then
			dw_body.Enabled = true
		   dw_head.Enabled = false
			cb_retrieve.Text = "조건(&Q)"
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
		end if		

   CASE 5    /* 조건 */
	    cb_retrieve.Text = "조회(&Q)"
       cb_update.enabled = false
       dw_head.Enabled = true
       dw_list.Enabled = false		 
       dw_body.Enabled = false
		 cb_insert.Enabled = False
 	    ib_changed = false
       dw_head.SetFocus()
       dw_head.SetColumn(1)
		 
   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
			dw_body.Enabled = true
		end if
END CHOOSE



end event

event type long ue_update();call super::ue_update;long i, ll_row_count, ll_so_tax, ll_ju_tax
datetime ld_datetime
string ls_jumn_no, li_no, ls_start_date, ls_end_date

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

select right(isnull(max(ilyong_no), 0) + 10001, 4)
into :li_no
from mis.dbo.tat09m(nolock) 
where slip_bonji  =  :is_slip_bonji
and happen_date   =  :is_happen_date ; 

FOR i=1 TO ll_row_count
	ls_jumn_no 		=  dw_body.GetItemString(i, "jumn_no")
	ls_start_date 	=  dw_body.GetItemString(i, "start_date")
	ls_end_date 	=  dw_body.GetItemString(i, "end_date")	
	ll_so_tax 		=  dw_body.GetItemNumber(i, "c_so_tax")	
	ll_ju_tax 		=  dw_body.GetItemNumber(i, "c_jumn")		
	
	
	if LenA(ls_jumn_no) <> 14 or MidA(ls_jumn_no, 7,1) <> "-" then
		messagebox("주민번호 확인", "주민번호가 양식에 맞도록 입력해주세요!")
	   dw_body.SetFocus()
   	dw_body.SetColumn("jumn_no")		
		Return 0
	end if	
	
	
	if LenA(ls_start_date) <> 10 or MidA(ls_start_date, 5,1) <> "."  or MidA(ls_start_date, 8,1) <> "."  then
		messagebox("근무일자 확인", "근무일자를 양식에 맞도록 입력해주세요!")
	   dw_body.SetFocus()
   	dw_body.SetColumn("start_date")				
		Return 0
	end if	
	
	if LenA(ls_end_date) <> 10 or MidA(ls_end_date, 5,1) <> "."  or MidA(ls_end_date, 8,1) <> "."  then
		messagebox("근무일자 확인", "근무일자를 양식에 맞도록 입력해주세요!")
	   dw_body.SetFocus()
   	dw_body.SetColumn("end_date")		
		Return 0
	end if		
	
	


   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */	
      dw_body.Setitem(i, "slip_bonji", is_slip_bonji)
	   dw_body.Setitem(i, "happen_date", is_happen_date)
	   dw_body.Setitem(i, "ilyong_no", li_no)		
	   dw_body.Setitem(i, "so_tax", ll_so_tax)				
	   dw_body.Setitem(i, "ju_tax", ll_ju_tax)						
      dw_body.Setitem(i, "input_empno", is_empno)
      dw_body.Setitem(i, "input_date", ld_datetime)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "input_empno", is_empno)
      dw_body.Setitem(i, "input_date", ld_datetime)
   END IF

	
 
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	ib_changed = false
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_retrieve()
This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_insert();
if dw_body.AcceptText() <> 1 then return


/* 변경된 자료가 있을때 저장여부를 확인*/
IF ib_changed THEN 
   CHOOSE CASE gf_update_yn(This.title)
	   CASE 1
		   IF This.Trigger Event ue_update() < 1 THEN
			   return
		   END IF		
	   CASE 3
		   return
   END CHOOSE
END IF


///* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
//IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
//END IF


dw_body.Reset()
il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_emp_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
CASE "empno"		

//			IF ai_div = 1 THEN 
//				if isnull(as_data) or len(as_data) = 0 then  return 1
//				if gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
//					dw_head.Setitem(al_row, "emp_nm", ls_emp_nm)
//					RETURN 0
//				END IF 
//			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 

			gst_cd.default_where   = "where goout_gubn = '1' " 
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(empno LIKE '" + as_data + "%' )" 
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
				dw_head.SetItem(al_row, "empno",    lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "emp_nm", lds_Source.GetItemString(1,"kname"))
				dw_head.SetItem(al_row, "appl_code", lds_Source.GetItemString(1,"appl_code"))				
				dw_head.SetItem(al_row, "appl_code_nm", lds_Source.GetItemString(1,"appl_code_nm"))								
				/* 다음컬럼으로 이동 */
				dw_head.TriggerEvent(Editchanged!)
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
			
CASE "kname"		

			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then  return 1
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "일용근로자 검색" 
			gst_cd.datawindow_nm   = "d_com936" 

			gst_cd.default_where   = "where 1 = 1 " 
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(kname LIKE '" + as_data + "%' )" 
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
				dw_body.SetItem(al_row, "kname",    lds_Source.GetItemString(1,"kname"))
				dw_body.SetItem(al_row, "jumn_no", lds_Source.GetItemString(1,"jumn_no"))
				dw_body.SetItem(al_row, "foreign_gubn", lds_Source.GetItemString(1,"foreign_gubn"))				
				/* 다음컬럼으로 이동 */
				dw_body.TriggerEvent(Editchanged!)
				dw_body.SetColumn("start_date")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source			
			
CASE "appl_code"		

			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then  return 1
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "예산부서코드" 
			gst_cd.datawindow_nm   = "d_com935" 

			gst_cd.default_where   = "where 1 = 1 " 
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "dept_code LIKE '" + as_data + "%'" 
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
				dw_head.SetItem(al_row, "appl_code",    lds_Source.GetItemString(1,"dept_code"))
				dw_head.SetItem(al_row, "appl_code_nm", lds_Source.GetItemString(1,"dept_name"))
				/* 다음컬럼으로 이동 */
				dw_head.TriggerEvent(Editchanged!)
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

type cb_close from w_com020_e`cb_close within w_51041_e
end type

type cb_delete from w_com020_e`cb_delete within w_51041_e
integer x = 1774
end type

type cb_insert from w_com020_e`cb_insert within w_51041_e
integer x = 1431
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_51041_e
end type

type cb_update from w_com020_e`cb_update within w_51041_e
end type

type cb_print from w_com020_e`cb_print within w_51041_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_51041_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_51041_e
end type

type cb_excel from w_com020_e`cb_excel within w_51041_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_51041_e
integer height = 256
string dataobject = "d_51041_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("slip_bonji", idw_slip_bonji)
idw_slip_bonji.SetTransObject(SQLCA)
idw_slip_bonji.Retrieve('018')

end event

event dw_head::itemchanged;call super::itemchanged;int li_ret
string ls_emp_nm

CHOOSE CASE dwo.name
	case "empno"
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	case "appl_code"
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
END CHOOSE
end event

type ln_1 from w_com020_e`ln_1 within w_51041_e
integer beginy = 436
integer endy = 436
end type

type ln_2 from w_com020_e`ln_2 within w_51041_e
integer beginy = 440
integer endy = 440
end type

type dw_list from w_com020_e`dw_list within w_51041_e
integer x = 5
integer y = 464
integer width = 1705
integer height = 1528
string dataobject = "d_51041_D01"
end type

event dw_list::clicked;call super::clicked;string ls_slip_date

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

is_jumn_no = This.GetItemString(row, 'jumn_no') /* DataWindow에 Key 항목을 가져온다 */
is_ilyong_no = This.GetItemString(row, 'ilyong_no') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_jumn_no) THEN return
IF IsNull(is_ilyong_no) THEN return

il_rows = dw_body.retrieve(is_slip_bonji, is_happen_date, is_ilyong_no, is_empno, is_jumn_no)

ls_slip_date = dw_body.GetItemString(1, 'slip_date')

IF IsNull(ls_slip_date) THEN 
	cb_delete.enabled  = true	
else 	
	cb_delete.enabled  = false
end if	

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

event dw_list::buttonclicked;call super::buttonclicked;Long i
String ls_yn, ls_proc_gubn

If dwo.Name = 'cb_sel' Then
	If dwo.Text = '전체선택' Then
		ls_yn = 'Y'
		dwo.Text = '전체제외'
	Else
		ls_yn = 'N'
		dwo.Text = '전체선택'
	End If
	
	For i = 1 To This.RowCount()
		ls_proc_gubn = dw_list.getitemstring(i, "proc_gubn")
		if ls_proc_gubn = "N" then 
			This.SetItem(i, "proc_yn", ls_yn)
		end if
	Next

End If

end event

type dw_body from w_com020_e`dw_body within w_51041_e
integer x = 1719
integer y = 464
integer width = 1851
integer height = 1528
string dataobject = "d_51041_D02"
end type

event dw_body::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name

	CASE "kname"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type st_1 from w_com020_e`st_1 within w_51041_e
integer x = 1705
integer y = 464
integer height = 1528
end type

type dw_print from w_com020_e`dw_print within w_51041_e
end type

type cb_batch from commandbutton within w_51041_e
integer x = 768
integer y = 40
integer width = 384
integer height = 96
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "일괄전표처리"
end type

event clicked;long i, ll_row_count
datetime ld_datetime
string ls_ilyong_no, ls_proc_yn, ls_proc_gubn, ls_sel
int net
decimal ld_pay_amt, ld_diff_amt

ll_row_count = dw_list.RowCount()
IF dw_list.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


Net = MessageBox("알림!", "등록일에 등록자 사번으로 등록된  지급내역이 한개의 전표로 생성됩니다!  계속하시겠습니까?", Exclamation!, OKCancel!, 2)

IF Net = 1 THEN 
	
			select amt
			into :ld_pay_amt
			from mis.dbo.tat09m (nolock)
			where slip_bonji  = :is_slip_bonji
			and   happen_date = :is_happen_date		
			and   input_empno = :is_empno; 
			
			select dbo.sf_51041(:is_appl_code, left(:is_happen_date,7)) //+ 5000000
			into :ld_diff_amt
			from dual;
		
		 if ld_diff_amt - ld_pay_amt >=0 then 
			
			 DECLARE SP_51041_P02 PROCEDURE FOR SP_51041_P02  
					@slip_bonji		=  :is_slip_bonji,
					@happen_date	=  :is_happen_date,
					@empno			=	:is_empno,
					@appl_code		=  :is_appl_code;	
		
		
			 EXECUTE SP_51041_P02 ;
		
				
				IF SQLCA.SQLCODE = -1 THEN 
					rollback  USING SQLCA;				
					MessageBox("SQL오류", SQLCA.SqlErrText) 
					Return -1 
				ELSE
					commit  USING SQLCA;
					MessageBox("알림", "작업이 완료 되었습니다!")
					dw_body.Reset()
					parent.Trigger Event ue_retrieve()					
									
				END IF 		
			else 	
				MessageBox("알림", "예산이 부족하여 작업이 취소되었습니다!")				
			end if	
				
ELSE

  MessageBox("알림", "작업이 취소되었습니다!")

END if
end event

type cb_proc from commandbutton within w_51041_e
integer x = 379
integer y = 40
integer width = 384
integer height = 96
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "개별전표처리"
end type

event clicked;long i, ll_row_count, j
datetime ld_datetime
string ls_ilyong_no, ls_proc_yn, ls_proc_gubn, ls_sel
int net
decimal ld_diff_amt, ld_pay_amt

ll_row_count = dw_list.RowCount()
IF dw_list.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


Net = MessageBox("알림!", "리스트에서 선택된 지급내역이 각각의 전표로 생성됩니다!  계속하시겠습니까?", Exclamation!, OKCancel!, 2)
j = 0

IF Net = 1 THEN 
	
		FOR i=1 TO ll_row_count
		
			dw_list.ScrollToRow(i)
			dw_list.selectrow(i,TRUE)	
			
			ls_ilyong_no = dw_list.GetItemString(i, "ilyong_no")
			ls_proc_yn = dw_list.GetItemString(i, "proc_yn")		
			ls_proc_gubn = dw_list.GetItemString(i, "proc_gubn")		
			
			if isnull(ls_proc_yn) or ls_proc_yn = "" then
				ls_proc_yn = "N"
			end if	
		
			select amt
			into :ld_pay_amt
			from mis.dbo.tat09m (nolock)
			where slip_bonji  = :is_slip_bonji
			and   happen_date = :is_happen_date
			and   ilyong_no   = :ls_ilyong_no
			and   input_empno = :is_empno; 
			
			select dbo.sf_51041(:is_appl_code, left(:is_happen_date,7))
			into :ld_diff_amt
			from dual;
			
		
			
					if ls_proc_yn = "Y" and ls_proc_gubn =  "N"   then	
						
							if ld_diff_amt - ld_pay_amt  >= 0 then 
									dw_list.selectrow(i,TRUE)	
									
									
												 DECLARE SP_51041_P01 PROCEDURE FOR SP_51041_P01  
														@slip_bonji		=  :is_slip_bonji,
														@happen_date	=  :is_happen_date,
														@ilyong_no		=  :ls_ilyong_no,
														@empno			=	:is_empno,
														@appl_code		=  :is_appl_code;	
											
											
												 EXECUTE SP_51041_P01 ;
											
													
													IF SQLCA.SQLCODE = -1 THEN 
														rollback  USING SQLCA;				
														MessageBox("SQL오류", SQLCA.SqlErrText) 
														Return -1 
													ELSE
														commit  USING SQLCA;
														j = j + 1 
													END IF 		
								else		
									MessageBox("알림", "예산이 부족합니다.!")
				
							end if								
													
						
					end if
			
			
			dw_list.selectrow(i,false)	
		NEXT
		
 	MessageBox("알림", "예산 가능 범위의 " + string(j, "0000") +  "건이 완료 되었습니다!")
   dw_body.Reset()
	parent.Trigger Event ue_retrieve()
		
ELSE

  MessageBox("알림", "작업이 취소되었습니다!")

END if



end event

