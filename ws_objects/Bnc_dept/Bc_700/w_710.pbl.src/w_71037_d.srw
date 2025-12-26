$PBExportHeader$w_71037_d.srw
$PBExportComments$상품권 지급/회수(집계)
forward
global type w_71037_d from w_com000
end type
type dw_head from u_dw within w_71037_d
end type
type ln_1 from line within w_71037_d
end type
type ln_2 from line within w_71037_d
end type
type dw_body from u_dw within w_71037_d
end type
type dw_print from u_dw within w_71037_d
end type
end forward

global type w_71037_d from w_com000
string menuname = "m_1_0000"
boolean toolbarvisible = false
dw_head dw_head
ln_1 ln_1
ln_2 ln_2
dw_body dw_body
dw_print dw_print
end type
global w_71037_d w_71037_d

type prototypes

end prototypes

type variables
string is_brand, is_event_id, is_shop_cd, is_flag, is_fr_yymmdd, is_to_yymmdd
datawindowchild idw_brand, idw_event_id

end variables

on w_71037_d.create
int iCurrent
call super::create
if this.MenuName = "m_1_0000" then this.MenuID = create m_1_0000
this.dw_head=create dw_head
this.ln_1=create ln_1
this.ln_2=create ln_2
this.dw_body=create dw_body
this.dw_print=create dw_print
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_head
this.Control[iCurrent+2]=this.ln_1
this.Control[iCurrent+3]=this.ln_2
this.Control[iCurrent+4]=this.dw_body
this.Control[iCurrent+5]=this.dw_print
end on

on w_71037_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_head)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.dw_body)
destroy(this.dw_print)
end on

event pfc_preopen;call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
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

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_event_id, is_shop_cd, is_fr_yymmdd, is_to_yymmdd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_keycheck;/*===========================================================================*/
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

is_event_id = dw_head.GetItemString(1, "event_id")
if IsNull(is_event_id) or Trim(is_event_id) = "" then
   MessageBox(ls_title,"행사구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("event_id")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_flag   = dw_head.GetItemString(1, "flag")
 
if is_flag = '1' then 
	dw_body.dataobject = 'd_71037_d01'
	dw_print.dataobject = 'd_71037_r01'
else 
	dw_body.dataobject = 'd_71037_d02'
	dw_print.dataobject = 'd_71037_r02'	
end if
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

return true

end event

event ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	case "event_id"
			is_fr_yymmdd = idw_event_id.getitemstring(idw_event_id.getrow(),"give_date")
			is_to_yymmdd = idw_event_id.getitemstring(idw_event_id.getrow(),"close_ymd")
			dw_head.setitem(1,"fr_yymmdd",is_fr_yymmdd)
			dw_head.setitem(1,"to_yymmdd",is_to_yymmdd)		
			RETURN 0		
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			elseif string(as_data) = "" then
					return 0				
			END IF
			is_brand = dw_head.getitemstring(1,"brand")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' and brand like '%" +is_brand+"' "
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
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

event ue_button;call super::ue_button;/*===========================================================================*/
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
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_msg;call super::ue_msg;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
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

event ue_preview;call super::ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print;call super::ue_print;/*===========================================================================*/
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

event ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)
dw_print.object.t_brand.text = '브랜드: ' + is_brand +' '+ idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_event_id.text = '행사코드: ' +idw_event_id.getitemstring(idw_event_id.getrow(),"event_nm")
ls_shop_nm = dw_head.getitemstring(1,"shop_nm")
dw_print.object.t_shop_cd.text = '매장: ' + is_shop_cd + ' ' + ls_shop_nm
dw_print.object.t_yymmdd.text = '기간: ' + is_fr_yymmdd + ' - '+is_to_yymmdd



end event

type cb_close from w_com000`cb_close within w_71037_d
integer taborder = 100
end type

type cb_delete from w_com000`cb_delete within w_71037_d
boolean visible = false
integer x = 1083
integer taborder = 50
end type

type cb_insert from w_com000`cb_insert within w_71037_d
boolean visible = false
integer x = 741
integer taborder = 40
end type

type cb_retrieve from w_com000`cb_retrieve within w_71037_d
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

type cb_update from w_com000`cb_update within w_71037_d
boolean visible = false
integer taborder = 90
end type

type cb_print from w_com000`cb_print within w_71037_d
integer x = 1426
integer taborder = 60
end type

type cb_preview from w_com000`cb_preview within w_71037_d
integer x = 1769
integer taborder = 70
end type

type gb_button from w_com000`gb_button within w_71037_d
integer taborder = 0
end type

type cb_excel from w_com000`cb_excel within w_71037_d
integer x = 2112
end type

type dw_head from u_dw within w_71037_d
event ue_keydown pbm_dwnkey
integer x = 37
integer y = 172
integer width = 3520
integer height = 204
integer taborder = 10
string dataobject = "d_71037_h01"
boolean vscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
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
	CASE "brand"      // dddw로 작성된 항목
		This.GetChild("event_id", idw_event_id)
		idw_event_id.SetTransObject(SQLCA)
		idw_event_id.Retrieve(string(data))
	CASE "shop_cd","event_id"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
		
END CHOOSE

end event

event rbuttonup;//
end event

event constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("event_id", idw_event_id)
idw_event_id.SetTransObject(SQLCA)
idw_event_id.Retrieve()

end event

type ln_1 from line within w_71037_d
integer linethickness = 4
integer beginy = 396
integer endx = 3621
integer endy = 396
end type

type ln_2 from line within w_71037_d
long linecolor = 16777215
integer linethickness = 4
integer beginy = 400
integer endx = 3621
integer endy = 400
end type

type dw_body from u_dw within w_71037_d
integer x = 5
integer y = 420
integer width = 3589
integer height = 1620
integer taborder = 30
string dataobject = "d_71037_d01"
end type

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
This.inv_sort.of_SetColumnHeader(True)

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

event rbuttonup;//
end event

event clicked;call super::clicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
String 	ls_search
if row > 0 then 
	choose case dwo.name
		case 'style','style_no'
			ls_search 	= this.GetItemString(row,string(dwo.name))
			if LenA(ls_search) >= 8 then gf_style_color_pic(ls_search, '%','%')			
	end choose	
end if

end event

event doubleclicked;call super::doubleclicked;//String 	ls_search
//if row > 0 then 
//	choose case dwo.name
//		case 'shop_cd','shop_nm'
//			ls_search 	= this.GetItemString(row,'shop_cd')
//			if len(ls_search) = 6 then gf_shop_pic(ls_search)			
//	end choose	
//end if
end event

type dw_print from u_dw within w_71037_d
boolean visible = false
integer x = 178
integer y = 348
integer width = 1006
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_71037_r01"
boolean hscrollbar = true
end type

event constructor;call super::constructor;This.of_SetPrintPreview(TRUE)
end event

