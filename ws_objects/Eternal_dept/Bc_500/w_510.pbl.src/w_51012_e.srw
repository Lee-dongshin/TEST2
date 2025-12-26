$PBExportHeader$w_51012_e.srw
$PBExportComments$매장인원등록
forward
global type w_51012_e from w_com020_e
end type
end forward

global type w_51012_e from w_com020_e
integer width = 3675
integer height = 2276
end type
global w_51012_e w_51012_e

type variables
DataWindowChild idw_emp_class, idw_dept_cd
String is_shop_cd, is_goout_gubn, is_emp_class, is_emp_nm
end variables

forward prototypes
protected subroutine wf_apply_insa (string flag, string empno, string shop_cd, string emp_class, string end_ymd, string mod_id)
end prototypes

protected subroutine wf_apply_insa (string flag, string empno, string shop_cd, string emp_class, string end_ymd, string mod_id);//messagebox("",flag)
//messagebox("",empno)
//messagebox("",shop_cd)
//messagebox("",emp_class)
//messagebox("",end_ymd)
//messagebox("",mod_id)

		 DECLARE sp_apply_insa PROCEDURE FOR sp_apply_insa  
					@gubn     = :flag,  
					@empno	 = :empno,	
					@shop_cd	 = :shop_cd, 
					@emp_class	= :emp_class, 
					@end_ymd		= :end_ymd,
					@mod_id		= :mod_id;		
				
		 execute sp_apply_insa;	
		 commit  USING SQLCA;

end subroutine

on w_51012_e.create
call super::create
end on

on w_51012_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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

is_shop_cd    = dw_head.GetItemString(1, "shop_cd")
is_goout_gubn = dw_head.GetItemString(1, "goout_gubn")
is_emp_nm     = dw_head.GetItemString(1, "emp_nm")

return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_shop_cd , is_goout_gubn, is_emp_nm)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
String     ls_style2
Boolean    lb_check 
string     ls_emp_nm, ls_birth_day, ls_tel_no, ls_begin_ymd, ls_end_ymd, ls_goout_gubn, ls_jumin, ls_empno, ls_address
decimal    ldc_hobong
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
//			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND brand = '" + gs_brand + "'"  + & 
			                         "  AND SHOP_DIV  IN ('G', 'K') " 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (shop_cd like '%" + as_data + "'"  + &
											" or   shop_snm like '%" + as_data + "')" 
//"SHOP_CD LIKE '" + as_data + "%'"

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
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
	CASE "jumin"	
		select top 1 empno, kname, replace(birth,'.','') as birth,
			replace(enter_date,'.','') as enter_date,
			hobong, 
			cur_addr, 
			goout_gubn,
			replace(goout_date,'.','') as goout_date
			into :ls_empno, :ls_emp_nm, :ls_birth_day, :ls_begin_ymd, 
				  :ldc_hobong, :ls_address, :ls_goout_gubn, :ls_end_ymd				  
		from mis.dbo.thb01 b(nolock) where replace(jumn_no,'-','') like :as_data
		order by goout_gubn, isnull(goout_date,'99999999') desc;

		dw_body.setitem(al_row,"empno",ls_empno)
		dw_body.setitem(al_row,"emp_nm",ls_emp_nm)
		
		
		if isnull(dw_body.getitemstring(al_row,"birth_day")) or dw_body.getitemstring(al_row,"birth_day") = '' or not isdate(dw_body.getitemstring(al_row,"birth_day")) then 
				dw_body.setitem(al_row,"birth_day",ls_birth_day)
		end if

		if isnull(dw_body.getitemstring(al_row,"begin_ymd")) or dw_body.getitemstring(al_row,"begin_ymd") = '' or not isdate(dw_body.getitemstring(al_row,"begin_ymd")) then 
				dw_body.setitem(al_row,"begin_ymd",ls_begin_ymd)
		end if

		if isnull(dw_body.getitemdecimal(al_row,"hobong")) or dw_body.getitemdecimal(al_row,"hobong") = 0 then 
				dw_body.setitem(al_row,"hobong",ldc_hobong)
		end if



		if isnull(dw_body.getitemstring(al_row,"address")) or dw_body.getitemstring(al_row,"address") = '' then 
				dw_body.setitem(al_row,"address",ls_address)
		end if		

		if isnull(dw_body.getitemstring(al_row,"goout_gubn")) or dw_body.getitemstring(al_row,"goout_gubn") = '' then 
				dw_body.setitem(al_row,"goout_gubn",ls_goout_gubn)
		end if	
		
		if isnull(dw_body.getitemstring(al_row,"end_ymd")) or dw_body.getitemstring(al_row,"end_ymd") = '' then 
				dw_body.setitem(al_row,"end_ymd",ls_end_ymd)
		end if			
		Destroy  lds_Source
		RETURN 0
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

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long	ll_cur_row

if dw_body.AcceptText() <> 1 then return

/* 추가시 수정자료가 있을때 저장여부 확인 */
if ib_changed then 
	CHOOSE CASE gf_update_yn(This.title)
		CASE 1
			IF This.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 2
			ib_changed = false
		CASE 3
			RETURN
	END CHOOSE
end if

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
END IF

dw_body.  SetRedraw(False)
dw_body.  Reset()


if IsNull(is_shop_cd) or Trim(is_shop_cd) = "%"  then
	messagebox("경고!", "해당매장을 입력해주세요!")
	return
else
	il_rows = dw_body.InsertRow(0)
end if	


dw_body.SetColumn(ii_min_column_id)
dw_body.SetFocus()

dw_body.  SetRedraw(True)


This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
	CASE 1		/* 조회 */
		cb_retrieve.Text = "조건(&Q)"
		dw_head.Enabled = false
		dw_list.Enabled = true
		
		If al_rows <= 0 Then
			dw_body.Enabled = true
		End If
	CASE 2   /* 추가 */
		if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
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
			cb_excel.enabled = true		
			if gs_user_nm = '정지선' then 
				dw_body.object.b_2.visible=true
			end if
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
//         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
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
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_insert.enabled  = false
         cb_delete.enabled  = true
         cb_print.enabled   = true
         cb_preview.enabled = true
         cb_excel.enabled   = true
			dw_body.enabled    = true
			if gs_user_nm = '정지선' then 
				dw_body.object.b_2.visible=true
			end if
		else
         cb_delete.enabled  = false
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
//         cb_insert.enabled = true
      end if
END CHOOSE

end event

event type long ue_update();call super::ue_update;
long i, ll_row_count
datetime ld_datetime
String ls_chk_data

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF





FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
	
	ls_chk_data = dw_body.GetItemString(1, "emp_nm")
	if IsNull(ls_chk_data) or Trim(ls_chk_data) = "" then
		MessageBox("경고!","직원이름을 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("emp_nm")
		return -1
	end if
	
	ls_chk_data = dw_body.GetItemString(1, "birth_day")
	if IsNull(ls_chk_data) or LenA(Trim(ls_chk_data)) <> 8 then
		MessageBox("경고!","생년월일을 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("birth_day")
		return -1
	end if
	
	ls_chk_data = dw_body.GetItemString(1, "begin_ymd")
	if IsNull(ls_chk_data) or Trim(ls_chk_data) = "" then
		MessageBox("경고!","근무시작일을 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("begin_ymd")
		return -1
	end if
	
	ls_chk_data = dw_body.GetItemString(1, "end_ymd")
	if IsNull(ls_chk_data) or Trim(ls_chk_data) = "" then
		MessageBox("경고!","근무종료일을 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("end_ymd")
		return -1
	end if
		
	
      dw_body.Setitem(i, "shop_cd", is_shop_cd)
      dw_body.Setitem(i, "reg_id", gs_user_id)
      dw_body.Setitem(i, "brand", MidA(is_shop_cd,1,1))		
      dw_body.Setitem(i, "shop_div", MidA(is_shop_cd,2,1))		
		
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
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

//This.Trigger Event ue_retrieve()
This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_dberror();//
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_51012_e","0")
end event

event open;call super::open;dw_head.setitem(1,"goout_gubn","1")

dw_head.setitem(1,"brand",gs_brand)
end event

type cb_close from w_com020_e`cb_close within w_51012_e
end type

type cb_delete from w_com020_e`cb_delete within w_51012_e
end type

type cb_insert from w_com020_e`cb_insert within w_51012_e
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_51012_e
end type

type cb_update from w_com020_e`cb_update within w_51012_e
end type

type cb_print from w_com020_e`cb_print within w_51012_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_51012_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_51012_e
end type

type cb_excel from w_com020_e`cb_excel within w_51012_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_51012_e
integer y = 208
integer height = 204
string dataobject = "d_51012_h01"
end type

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_51012_e
end type

type ln_2 from w_com020_e`ln_2 within w_51012_e
end type

type dw_list from w_com020_e`dw_list within w_51012_e
integer width = 1147
string dataobject = "d_51012_d01"
end type

event dw_list::clicked;
string ls_shop_cd

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
ls_shop_cd = This.GetItemString(row, 'shop_cd') 
is_emp_class = This.GetItemString(row, 'emp_class') /* DataWindow에 Key 항목을 가져온다 */
is_emp_nm = This.GetItemString(row, 'emp_nm') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_emp_class) THEN return
IF IsNull(is_emp_class) THEN return

il_rows = dw_body.retrieve(ls_shop_cd, is_emp_class, is_emp_nm, is_goout_gubn)
	
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

event dw_list::constructor;//

end event

type dw_body from w_com020_e`dw_body within w_51012_e
integer x = 1198
integer width = 2395
string dataobject = "d_51012_d02"
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_child
This.GetChild("emp_class", idw_emp_class)
idw_emp_class.SetTransObject(SQLCA)
idw_emp_class.Retrieve('510')


This.GetChild("dept_cd", idw_dept_cd)
idw_dept_cd.SetTransObject(SQLCA)
idw_dept_cd.Retrieve('%')


//This.GetChild("bank_code", ldw_child)
//ldw_child.SetTransObject(SQLCA)
//ldw_child.Retrieve('921')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1, "inter_cd", '')
//ldw_child.SetItem(1, "inter_nm", '없음')


end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;String ls_column_nm,  ls_tag, ls_helpMsg
string ls_goout_gubn

ls_column_nm = This.GetColumnName()

CHOOSE CASE ls_column_nm
	CASE "end_ymd"
		ls_goout_gubn = dw_body.getitemstring(1, "goout_gubn")
		if ls_goout_gubn = '1' then 
			dw_body.setitem(1, "end_ymd", "99999999")
		end if	
		
END CHOOSE

Parent.SetMicroHelp(ls_helpMsg)

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

event dw_body::dberror;//
end event

event dw_body::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
dw_body.object.b_2.visible=false
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF


CHOOSE CASE dwo.name
	CASE "jumin"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	case "goout_gubn"	
		if data = "2" then
			this.SetItem(1, "end_ymd" ,string(ld_datetime,"yyyymmdd"))
		end if	
END CHOOSE

end event

event dw_body::buttonclicked;call super::buttonclicked;string b_name, ls_empno, ls_shop_cd, ls_emp_class, ls_end_ymd, ls_mod_id

ls_empno = dw_body.getitemstring(1,"empno")
if isnull(ls_empno) then 
	ls_empno = " "
end if

ls_shop_cd = dw_body.getitemstring(1,"shop_cd")
ls_emp_class = dw_body.getitemstring(1,"emp_class")
ls_end_ymd = dw_body.getitemstring(1,"end_ymd")
ls_mod_id = dw_body.getitemstring(1,"mod_id")

	
b_name=dwo.name
choose case b_name
	case "b_1"	//인사정보 가져오기	
		if ib_changed then 
			MessageBox('확인','수정된 자료가 있습니다! 먼저 저장해주세요..')
		else
			  CHOOSE CASE MessageBox('확인','신규 인사기록을 가져오겠습니까?', &
								 Question!, YesNoCancel!)
				CASE 1	

					wf_apply_insa('1',ls_empno, ls_shop_cd, ls_emp_class, ls_end_ymd, ls_mod_id)
					MessageBox('확인','작업이 완료되었습니다...')
					RETURN 1		
				CASE 3
					RETURN 1
			END CHOOSE
		END IF
	case "b_2"  //인사에 적용하기
		if ib_changed then 
			MessageBox('확인','수정된 자료가 있습니다! 먼저 저장해주세요..')
		else
			  CHOOSE CASE MessageBox('확인','인사정보에 적용하시겠습니까?', &
								 Question!, YesNoCancel!)
				CASE 1

					wf_apply_insa('2',ls_empno, ls_shop_cd, ls_emp_class, ls_end_ymd, ls_mod_id)
					MessageBox('확인','작업이 완료되었습니다...')
					il_rows = dw_body.retrieve(ls_shop_cd, is_emp_class, is_emp_nm, is_goout_gubn)
					RETURN 1		
				CASE 3
					RETURN 1
			END CHOOSE
		END IF	
end choose
end event

type st_1 from w_com020_e`st_1 within w_51012_e
integer x = 1179
end type

type dw_print from w_com020_e`dw_print within w_51012_e
end type

