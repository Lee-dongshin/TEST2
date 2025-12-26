$PBExportHeader$w_33012_e.srw
$PBExportComments$납기클레임등록
forward
global type w_33012_e from w_com000
end type
type dw_head from u_dw within w_33012_e
end type
type ln_1 from line within w_33012_e
end type
type ln_2 from line within w_33012_e
end type
type dw_body from u_dw within w_33012_e
end type
type dw_print from u_dw within w_33012_e
end type
type cbx_1 from checkbox within w_33012_e
end type
end forward

global type w_33012_e from w_com000
integer width = 3675
integer height = 2276
string menuname = "m_1_0000"
boolean toolbarvisible = false
dw_head dw_head
ln_1 ln_1
ln_2 ln_2
dw_body dw_body
dw_print dw_print
cbx_1 cbx_1
end type
global w_33012_e w_33012_e

type variables
string is_brand, is_yymmdd, is_cust_cd, is_make_type, is_flag, is_sojae, is_to_ymd
datawindowchild idw_brand, idw_make_type, idw_sojae

end variables

on w_33012_e.create
int iCurrent
call super::create
if this.MenuName = "m_1_0000" then this.MenuID = create m_1_0000
this.dw_head=create dw_head
this.ln_1=create ln_1
this.ln_2=create ln_2
this.dw_body=create dw_body
this.dw_print=create dw_print
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_head
this.Control[iCurrent+2]=this.ln_1
this.Control[iCurrent+3]=this.ln_2
this.Control[iCurrent+4]=this.dw_body
this.Control[iCurrent+5]=this.dw_print
this.Control[iCurrent+6]=this.cbx_1
end on

on w_33012_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_head)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.dw_body)
destroy(this.dw_print)
destroy(this.cbx_1)
end on

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 		   									  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
datetime ld_datetime
/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"yymmdd",string(ld_datetime,"yyyymmdd"))

end if

end event

event ue_excel;call super::ue_excel;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

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
li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
long i
if dw_body.AcceptText() <> 1 then return

IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
dw_body.Reset()		

il_rows = dw_body.retrieve(is_brand, is_cust_cd, is_yymmdd, is_make_type, is_sojae, is_to_ymd)

for i = 1 to dw_body.rowcount()
	if dw_body.getitemstring(i,"flag") <> "D" then
	 	dw_body.SetItemStatus(i, 0, Primary!,New!)
	end if
next

dw_body.SetFocus()



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
is_yymmdd = dw_head.GetItemString(1, "yymmdd")
is_cust_cd = dw_head.GetItemString(1, "cust_cd")
is_make_type = dw_head.GetItemString(1, "make_type")
is_sojae = dw_head.GetItemString(1, "sojae")

if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

if IsNull(is_yymmdd) or LenA(is_yymmdd) <> 8 then
   MessageBox(ls_title,"일자를 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or LenA(is_to_ymd) <> 8 then
   MessageBox(ls_title,"일자를 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
String     ls_mat_nm, ls_cust_nm, ls_emp_nm ,ls_brand
Boolean    lb_check 

DataStore  lds_Source 


CHOOSE CASE as_column

		
	CASE "cust_cd"				
			IF ai_div = 1 THEN 	
				if isnull(as_data) or LenA(as_data) = 0 then
					return 0
				elseIF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
					dw_head.Setitem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
			ls_brand = dw_head.getitemstring(1,"brand")
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			gst_cd.default_where   = "Where brand     = '" + ls_brand + "'"      + &
			                         "  and cust_code between '5000' and '7000'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_sname like '%" + as_data + "%')"
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

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;/*===========================================================================*/
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

event ue_insert();call super::ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
long i
if dw_body.AcceptText() <> 1 then return

IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
dw_body.Reset()		

il_rows = dw_body.retrieve(is_brand, is_cust_cd, is_yymmdd, is_make_type)

for i = 1 to dw_body.rowcount()
	if dw_body.getitemstring(i,"flag") <> "D" then
	 	dw_body.SetItemStatus(i, 0, Primary!,New!)
	end if
next

dw_body.SetFocus()

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_msg;call super::ue_msg;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/* ai_cb_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 6 - 삭제  */
/* al_rows     : 리턴값                                                      */
/*===========================================================================*/

String ls_msg

CHOOSE CASE ai_cb_div
   CASE 1      /* 조회 */
      CHOOSE CASE al_rows
         CASE IS > 0
            ls_msg = "조회가 완료되었습니다."
         CASE 0
            ls_msg = "조회 할 자료가 없습니다."
         CASE IS < 0
            ls_msg = "조회가 실패하였습니다."
      END CHOOSE
   CASE 2      /* 추가 */
      IF al_rows > 0 THEN
         ls_msg = "자료를 입력하십시요."
      ELSE
         ls_msg = "자료 입력이 실패했습니다."
      END IF
   CASE 3      /* 저장 */
      IF al_rows = 1 THEN
         ls_msg = "자료가 저장되었습니다."
      ELSE
         ls_msg = "자료 저장이 실패하였습니다."
      END IF
   CASE 4      /* 삭제 */
      IF al_rows > 0 THEN
         ls_msg = "자료가 삭제되었습니다."
      ELSE
         ls_msg = "자료 삭제가 실패하였습니다."
      END IF
   CASE 5      /* 조건 */
      ls_msg = "조회할 자료를 입력하세요."
   CASE 6      /* 인쇄 */
		IF al_rows = 1 THEN
         ls_msg = "인쇄가 되었습니다."
      ELSE
         ls_msg = "인쇄가 실패하였습니다."
      END IF
END CHOOSE

This.ParentWindow().SetMicroHelp(ls_msg)

end event

event ue_delete;call super::ue_delete;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_body.DeleteRow (ll_cur_row)
dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/




if cbx_1.checked then
	dw_print.dataobject = 'd_33012_r02'
	dw_print.settransobject(sqlca)
	il_rows = dw_print.retrieve(is_brand, is_cust_cd, is_yymmdd, is_make_type, is_to_ymd)
else
	dw_print.dataobject = 'd_33012_r01'
	dw_print.settransobject(sqlca)
	dw_body.ShareData(dw_print)
end if

This.Trigger Event ue_title ()

dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();call super::ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

dw_body.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_real_claim_amt
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
	ll_real_claim_amt = dw_body.getitemnumber(i,"real_claim_amt")
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
		if isnull(ll_real_claim_amt) or ll_real_claim_amt = 0 then
			dw_body.SetItemStatus(i, 0, Primary!, New!)
		end if

   END IF
NEXT


il_rows = dw_body.Update(TRUE, FALSE)


if il_rows = 1 then
   dw_body.ResetUpdate()
	
	is_brand  = dw_head.getitemstring(1,"brand")
	is_yymmdd = dw_head.getitemstring(1,"yymmdd")
	
	DECLARE sp_dlvy_claim PROCEDURE FOR sp_dlvy_claim
				@brand     = :is_brand,  
				@yymmdd	  = :is_yymmdd;
				
	execute sp_dlvy_claim;	

   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event closequery;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

/* 변경된 자료가 있을때 저장여부를 확인*/
IF ib_changed THEN 
   IF This.Windowstate = Minimized! THEN
	   This.Windowstate = Normal!
   END IF
   This.SetFocus()

   CHOOSE CASE gf_update_yn(This.title)
	   CASE 1
		   IF This.Trigger Event ue_update() < 1 THEN
			   Message.ReturnValue = 1
			   return
		   END IF		
	   CASE 3
		   Message.ReturnValue = 1
		   return
   END CHOOSE
END IF

end event

event ue_head;call super::ue_head;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

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

This.Trigger Event ue_button(5, 2)
This.Trigger Event ue_msg(5, 2)

end event

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.12.27																  */	
/* 수정일      : 2001.12.27																  */
/* 설  명      : head 기본값 처리                                            */
/*===========================================================================*/
u_head_set lu_head_set

lu_head_set = create u_head_set

lu_head_set.uf_set(dw_head)

if IsValid (lu_head_set) then
   DESTROY lu_head_set
end if
end event

event ue_title();/*===========================================================================*/
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

ls_modify =	 "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_brand.text  = is_brand  + ' '  + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_yymmdd.text = is_yymmdd
dw_print.object.t_cust_cd.text     = is_cust_cd
dw_print.object.t_make_type.text   = is_make_type  + ' ' + idw_make_type.getitemstring(idw_make_type.getrow(),"inter_nm")


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_33012_e","0")
end event

type cb_close from w_com000`cb_close within w_33012_e
integer taborder = 110
end type

type cb_delete from w_com000`cb_delete within w_33012_e
integer x = 1083
integer taborder = 60
end type

type cb_insert from w_com000`cb_insert within w_33012_e
boolean visible = false
integer x = 731
integer taborder = 50
end type

type cb_retrieve from w_com000`cb_retrieve within w_33012_e
integer x = 2866
integer taborder = 20
end type

event cb_retrieve::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : M.S.I (김태범) 															  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

IF dw_head.Enabled THEN
	Parent.Trigger Event ue_retrieve()	//조회
ELSE
	Parent.Trigger Event ue_head()	//조건
END IF

SetPointer(oldpointer)
This.Enabled = True

end event

type cb_update from w_com000`cb_update within w_33012_e
integer taborder = 100
end type

type cb_print from w_com000`cb_print within w_33012_e
integer x = 1426
integer taborder = 70
end type

type cb_preview from w_com000`cb_preview within w_33012_e
integer x = 1769
integer taborder = 80
end type

type gb_button from w_com000`gb_button within w_33012_e
integer taborder = 0
end type

type cb_excel from w_com000`cb_excel within w_33012_e
integer x = 2112
integer taborder = 90
end type

type dw_head from u_dw within w_33012_e
event ue_keydown pbm_dwnkey
integer x = 27
integer y = 144
integer width = 3579
integer height = 216
integer taborder = 10
string dataobject = "d_33012_h01"
boolean vscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
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

event buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event itemerror;return 1
end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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

event itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event rbuttonup;//
end event

event constructor;call super::constructor;
this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')

this.getchild("make_type",idw_make_type)
idw_make_type.settransobject(sqlca)
idw_make_type.retrieve('030')
idw_make_type.insertrow(1)
idw_make_type.setitem(1,"inter_cd","%")
idw_make_type.setitem(1,"inter_nm","전체")

this.getchild("sojae",idw_sojae)
idw_sojae.settransobject(sqlca)
idw_sojae.retrieve('%')
idw_sojae.insertrow(1)
idw_sojae.setitem(1,"sojae","%")
idw_sojae.setitem(1,"sojae_nm","전체")
end event

type ln_1 from line within w_33012_e
integer linethickness = 4
integer beginy = 360
integer endx = 3621
integer endy = 360
end type

type ln_2 from line within w_33012_e
long linecolor = 16777215
integer linethickness = 4
integer beginy = 364
integer endx = 3621
integer endy = 364
end type

type dw_body from u_dw within w_33012_e
event ue_keydown pbm_dwnkey
event set_act_amt ( long row )
integer x = 5
integer y = 372
integer width = 3589
integer height = 1668
integer taborder = 40
string dataobject = "d_33012_d01"
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
		Return 1
	CASE KeyDownArrow!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
		END IF
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

event set_act_amt(long row);decimal ll_act_amt

ll_act_amt = dw_body.getitemnumber(row,"act_amt")

dw_body.setitem(row,"real_claim_amt",ll_act_amt)

end event

event buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report, ls_yn, ls_yn_t
long i,j

choose case dwo.name
	case "cb_tot"
		i = this.rowcount()
			
		ls_yn = this.getitemstring(1,'dlvy_claim')
		if isnull(ls_yn) or ls_yn = 'N' then
			for j = 1 to i
				ls_yn_t = this.getitemstring(j,'dlvy_claim')
				if isnull(ls_yn) or ls_yn = 'N' then
					this.setitem(j,'dlvy_claim','Y')
					trigger event set_act_amt(j)
				end if
			next 
		else
			for j = 1 to i
				ls_yn_t = this.getitemstring(j,'dlvy_claim')
				if isnull(ls_yn) or ls_yn = 'Y' then
					this.setitem(j,'dlvy_claim','N')
					trigger event set_act_amt(j)
				end if
			next 			
		end if
		cb_update.enabled = true		
end choose



IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(true)

//This.SetRowFocusIndicator(Hand!)

end event

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 2627
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 515
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

This.ScrollTorow(row)
This.SetRow(row)
This.SetFocus()

MessageBox(parent.title, ls_message_string)
return 1
end event

event itemerror;return 1
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

event rbuttonup;//
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

CHOOSE CASE dwo.name
	CASE "colunm1" 
    IF data = 'A' THEN
	      /*action*/
    END IF
	CASE "dlvy_claim"	     //  Popup 검색창이 존재하는 항목 
		post event set_act_amt(row)
END CHOOSE

end event

event editchanged;call super::editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

type dw_print from u_dw within w_33012_e
boolean visible = false
integer x = 128
integer y = 800
integer width = 1006
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_33012_r01"
boolean hscrollbar = true
end type

event constructor;call super::constructor;This.of_SetPrintPreview(TRUE)
end event

type cbx_1 from checkbox within w_33012_e
integer x = 2299
integer y = 280
integer width = 402
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "업체별출력"
borderstyle borderstyle = stylelowered!
end type

