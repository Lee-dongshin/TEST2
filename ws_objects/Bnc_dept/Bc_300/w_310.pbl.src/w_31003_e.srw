$PBExportHeader$w_31003_e.srw
$PBExportComments$생산 공정 진행 관리
forward
global type w_31003_e from w_com010_e
end type
type dw_mast from datawindow within w_31003_e
end type
end forward

global type w_31003_e from w_com010_e
dw_mast dw_mast
end type
global w_31003_e w_31003_e

type variables
string is_work_dt, is_cust_cd, is_country_cd
end variables

on w_31003_e.create
int iCurrent
call super::create
this.dw_mast=create dw_mast
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mast
end on

on w_31003_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_mast)
end on

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime
string 	ls_date

inv_resize.of_Register(dw_mast, "ScaleToRight")


dw_mast.SetTransObject(SQLCA)

dw_mast.insertrow(1)
dw_mast.setitem(1,"prot",1)

dw_head.setitem(1,"cust_cd",gs_user_id)
dw_head.setitem(1,"cust_nm",gs_user_nm)

dw_head.setitem(1,"prot",0)

IF gf_cdate(ld_datetime,0)  THEN  
	ls_date = string(ld_datetime,"yyyymmdd")
	dw_head.setitem(1,"work_dt",ls_date)
	if gf_date_nm(ls_date) then
		dw_head.setitem(1,"date_nm",ls_date)
	end if
	
end if
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

is_work_dt = dw_head.GetItemString(1, "work_dt")
is_cust_cd = dw_head.GetItemString(1, "cust_cd")
is_country_cd = dw_head.GetItemString(1, "country_cd")

if IsNull(is_work_dt) or Trim(is_work_dt) = ""  or not gf_datechk(is_work_dt) then
   MessageBox(ls_title,"작업일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("work_dt")
   return false
end if

if IsNull(is_cust_cd) or Trim(is_cust_cd) = "" then
   MessageBox(ls_title,"거래처를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("cust_cd")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_date, ls_flag
long i

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_mast.retrieve(is_work_dt, is_cust_cd, is_country_cd)
dw_body.reset()
if il_rows > 0 then
	ls_flag = dw_mast.getitemstring(1,"flag")
	if ls_flag = "N" then
		dw_mast.SetItemStatus(1, 0, Primary!,New!)
	end if
	
	
	il_rows = dw_body.retrieve(is_work_dt, is_cust_cd, is_country_cd)	
	IF il_rows > 0 THEN
		for i = 1 to il_rows
			ls_flag = dw_body.getitemstring(i,"flag")
			if ls_flag = "N" then
				dw_body.SetItemStatus(i, 0, Primary!,New!)
			end if			
		next 
		dw_body.SetFocus()
	END IF
else
	dw_mast.insertrow(1)	
	
	dw_head.setitem(1,"cust_cd",gs_user_id)
	dw_head.setitem(1,"cust_nm",gs_user_nm)
	
	
	IF gf_cdate(ld_datetime,0)  THEN  
		ls_date = string(ld_datetime,"yyyymmdd")
		dw_head.setitem(1,"work_dt",ls_date)
		if gf_date_nm(ls_date) then
			dw_head.setitem(1,"date_nm",ls_date)
		end if
		
	end if	
	
end if
	
This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 종호)                                      */	
/* 작성일      : 2001.12.04                                                  */	
/* 수정일      : 2001.12.04                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/

string     ls_cust_cd, ls_cust_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"							// 거래처 코드
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				if isnull(as_data) or LenA(as_data) = 0 then 
					return 0
				ElseIF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
//					dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
//					RETURN 0
					
					
		 			 if gs_brand <> "K" then	
						dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
						RETURN 0
					 else	
							if gs_brand <> MidA(as_data,1,1) then
								Return 1
							else 
								dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
								RETURN 0
							end if	
					 end if				

					
					
				END IF
				
			END IF   
			
			   gst_cd.ai_div          = ai_div	// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "거래처 코드 검색" 
				gst_cd.datawindow_nm   = "d_com911" 
				gst_cd.default_where   = " WHERE Cust_Code Between '5000' And '9999' "

		   if gs_brand <> "K" then	
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_Sname like '%" + as_data + "%')" 
				ELSE
					gst_cd.Item_where = ""
				END IF
			else
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_Sname like '%" + as_data + "%') and custcode LIKE '[KO]%' " 
				ELSE
					gst_cd.Item_where = " custcode LIKE '[KO]%' "
				END IF
				
			end if	
				
//				IF Trim(as_data) <> "" THEN
//					gst_cd.Item_where = " (CustCode LIKE ~'" + as_data + "%~' or Cust_sname like ~'" + as_data + "%~')"
//				ELSE
//					gst_cd.Item_where = ""
//				END IF
//
				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm
					dw_head.SetRow(al_row)
					dw_head.SetColumn(as_column)
					dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"CustCode"))
					dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"Cust_sName"))
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("work_dt")
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
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_mast.Enabled = true
         dw_body.Enabled = true
         dw_body.SetFocus()

			dw_mast.setitem(1,"prot",0)	
			dw_head.setitem(1,"prot",1)
	
      else
			dw_mast.setitem(1,"prot",1)	
			dw_head.setitem(1,"prot",0)

         cb_print.enabled = false
         cb_preview.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_print.enabled = false
			cb_preview.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
	         dw_mast.Enabled = true
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

      cb_print.enabled = false
      cb_preview.enabled = false

      cb_update.enabled = false
      ib_changed = false
      dw_mast.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
		dw_mast.setitem(1,"prot",1)	
		dw_head.setitem(1,"prot",0)
	
END CHOOSE

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
string   ls_style, ls_chno, ls_bigo


IF dw_mast.AcceptText() <> 1 THEN RETURN -1

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

/* 마스터 저장	*/
idw_status = dw_mast.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */
	dw_mast.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN		/* Modify Record */
	dw_mast.Setitem(1, "mod_id", gs_user_id)
	dw_mast.Setitem(1, "mod_dt", ld_datetime)
END IF
	
	
/* 디테일 저장 */
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
	
   /* 품번 디테일(tb_12021_d)에 비고 저장 */
	ls_style = dw_body.GetitemString(i,"style")
	ls_chno  = dw_body.GetitemString(i,"chno")
	ls_bigo  = dw_body.GetitemString(i,"bigo")
	update tb_12021_d
	set    bigo  =  :ls_bigo
	where  style =  :ls_style
	and    chno  =  :ls_chno;
	
NEXT
//
il_rows = dw_mast.Update(TRUE, FALSE)
if il_rows = 1 then
	il_rows = dw_body.Update(TRUE, FALSE)
	
	if il_rows = 1 then
		dw_mast.ResetUpdate()
		dw_body.ResetUpdate()		
		commit  USING SQLCA;
	else
		rollback  USING SQLCA;
	end if
else
	rollback  USING SQLCA;	
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_preview();//
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로
il_rows = dw_print.retrieve(is_work_dt, is_cust_cd, is_country_cd)
dw_print.inv_printpreview.of_SetZoom()
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_31003_e","0")
end event

type cb_close from w_com010_e`cb_close within w_31003_e
end type

type cb_delete from w_com010_e`cb_delete within w_31003_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_31003_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_31003_e
end type

event cb_retrieve::clicked;//cb_retrieve.Text = "조건(&Q)"
/*===========================================================================*/
/* 작성자      : M.S.I (김태범) 															  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

IF cb_retrieve.Text = "조회(&Q)" THEN
	Parent.Trigger Event ue_retrieve()	//조회
ELSE
	Parent.Trigger Event ue_head()	//조건
END IF

SetPointer(oldpointer)
This.Enabled = True

end event

type cb_update from w_com010_e`cb_update within w_31003_e
end type

type cb_print from w_com010_e`cb_print within w_31003_e
end type

type cb_preview from w_com010_e`cb_preview within w_31003_e
end type

type gb_button from w_com010_e`gb_button within w_31003_e
end type

type cb_excel from w_com010_e`cb_excel within w_31003_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_31003_e
integer x = 5
integer y = 164
integer width = 1170
integer height = 164
string dataobject = "d_31003_h01"
end type

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_date

CHOOSE CASE dwo.name

	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"cust_nm","")
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "work_dt"
		this.setitem(1,"date_nm","")
		ls_date = data

		if not gf_datechk(ls_date) then
			messagebox("확인", "작업일자를 올바로 입력하세요..")
			return 1
		end if
		
		if gf_date_nm(ls_date) then
			dw_head.setitem(1,"date_nm",ls_date)
		end if
		
END CHOOSE

ib_changed = true
cb_update.enabled = true


end event

type ln_1 from w_com010_e`ln_1 within w_31003_e
integer beginy = 696
integer endy = 696
end type

type ln_2 from w_com010_e`ln_2 within w_31003_e
integer beginy = 700
integer endy = 700
end type

type dw_body from w_com010_e`dw_body within w_31003_e
event ue_date ( long as_row,  string as_field_nm,  string as_date )
integer y = 716
integer height = 1324
string dataobject = "d_31003_d02"
boolean hscrollbar = true
end type

event dw_body::ue_date(long as_row, string as_field_nm, string as_date);this.setitem(as_row,as_field_nm,RightA(as_date,4))

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

event dw_body::itemchanged;call super::itemchanged;datetime ld_datetime
string 	ls_date, ls_year

choose case dwo.name
	case "cut_dte", "sew_dte", "fin_dte", "madome_dte", "siyage_dte", "self_qc_dte", "qc_dt"
		IF gf_cdate(ld_datetime,0)  THEN  
			ls_date = string(ld_datetime,"yyyymmdd")
			ls_year = LeftA(ls_date,4)

			if LenA(data) = 4 and dec(data) < 2000 then
				ls_date = ls_year + data			
				post event ue_date(row,dwo.name,ls_date)

			else 
				ls_date = data
			end if
		else
			return 1
		end if

		if not gf_datechk(ls_date) then
			messagebox("주의","일자를 올바로 입력하세요")
			return 1
		end if
end choose
end event

type dw_print from w_com010_e`dw_print within w_31003_e
string dataobject = "d_31003_r00"
end type

type dw_mast from datawindow within w_31003_e
integer x = 5
integer y = 152
integer width = 3589
integer height = 532
integer taborder = 20
string title = "none"
string dataobject = "d_31003_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
end event

