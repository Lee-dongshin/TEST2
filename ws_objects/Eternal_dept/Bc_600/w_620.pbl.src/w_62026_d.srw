$PBExportHeader$w_62026_d.srw
$PBExportComments$스타일별 판매현황(종합)
forward
global type w_62026_d from w_com000
end type
type dw_head from u_dw within w_62026_d
end type
type ln_1 from line within w_62026_d
end type
type ln_2 from line within w_62026_d
end type
type dw_body from u_dw within w_62026_d
end type
type dw_print from u_dw within w_62026_d
end type
type cb_yymmdd from commandbutton within w_62026_d
end type
type dw_excel from datawindow within w_62026_d
end type
type dw_life from datawindow within w_62026_d
end type
type cb_1 from commandbutton within w_62026_d
end type
type cb_flus from commandbutton within w_62026_d
end type
type cb_minor from commandbutton within w_62026_d
end type
type dw_1 from datawindow within w_62026_d
end type
end forward

global type w_62026_d from w_com000
integer width = 3639
integer height = 2232
string menuname = "m_1_0000"
boolean toolbarvisible = false
dw_head dw_head
ln_1 ln_1
ln_2 ln_2
dw_body dw_body
dw_print dw_print
cb_yymmdd cb_yymmdd
dw_excel dw_excel
dw_life dw_life
cb_1 cb_1
cb_flus cb_flus
cb_minor cb_minor
dw_1 dw_1
end type
global w_62026_d w_62026_d

type prototypes

end prototypes

type variables
string is_brand, is_year, is_season, is_sojae, is_item, is_style, is_chno, is_gbn

datawindowchild idw_brand, idw_season, idw_item, idw_sojae

end variables

on w_62026_d.create
int iCurrent
call super::create
if this.MenuName = "m_1_0000" then this.MenuID = create m_1_0000
this.dw_head=create dw_head
this.ln_1=create ln_1
this.ln_2=create ln_2
this.dw_body=create dw_body
this.dw_print=create dw_print
this.cb_yymmdd=create cb_yymmdd
this.dw_excel=create dw_excel
this.dw_life=create dw_life
this.cb_1=create cb_1
this.cb_flus=create cb_flus
this.cb_minor=create cb_minor
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_head
this.Control[iCurrent+2]=this.ln_1
this.Control[iCurrent+3]=this.ln_2
this.Control[iCurrent+4]=this.dw_body
this.Control[iCurrent+5]=this.dw_print
this.Control[iCurrent+6]=this.cb_yymmdd
this.Control[iCurrent+7]=this.dw_excel
this.Control[iCurrent+8]=this.dw_life
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.cb_flus
this.Control[iCurrent+11]=this.cb_minor
this.Control[iCurrent+12]=this.dw_1
end on

on w_62026_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_head)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.dw_body)
destroy(this.dw_print)
destroy(this.cb_yymmdd)
destroy(this.dw_excel)
destroy(this.dw_life)
destroy(this.cb_1)
destroy(this.cb_flus)
destroy(this.cb_minor)
destroy(this.dw_1)
end on

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(dw_1, "ScaleToRight")
inv_resize.of_Register(dw_life, "FixedToRight&Bottom")
/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_excel.SetTransObject(SQLCA)
dw_life.SetTransObject(SQLCA)
/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

event ue_excel();call super::ue_excel;/*===========================================================================*/
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

il_rows = dw_excel.retrieve(is_brand, is_year, is_season, is_item, is_style, is_chno)

li_ret = dw_excel.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//Trigger Event ue_preview()
//return


/////////////////////
//dw_body.Object.DataWindow.Print.Orientation	 = 1

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_item, is_style, is_chno, is_sojae)


IF il_rows > 0 THEN
	dw_body.setrow(1)
   dw_body.SetFocus()
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
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"년도 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_item  = dw_head.GetItemString(1, "item")
is_sojae = dw_head.GetItemString(1, "sojae")
is_style = dw_head.GetItemString(1, "style")
is_chno  = dw_head.GetItemString(1, "chno")
is_sojae = dw_head.GetItemString(1, "sojae")

is_gbn   = dw_head.GetItemString(1, "gbn")

choose case is_gbn
	case 'M' //월별
		if dw_body.dataobject  <> "d_62026_pic"  then 
			dw_body.dataobject  = "d_62026_pic"
			dw_print.dataobject = "d_62026_r01"
			dw_body.SetTransObject(SQLCA)
			dw_print.SetTransObject(SQLCA)
		end if
		
	case 'W' //주별
		if dw_body.dataobject  <> "d_62026_pic2" then 
			dw_body.dataobject  = "d_62026_pic2"
			dw_print.dataobject = "d_62026_r02"
			dw_body.SetTransObject(SQLCA)
			dw_print.SetTransObject(SQLCA)
		end if		
		
	case 'D' //일별(사용안함)
		if dw_body.dataobject <> "d_62026_pic3" then 
			dw_body.dataobject = "d_62026_pic3"
			dw_print.dataobject = "d_62026_r03"			
			dw_body.SetTransObject(SQLCA)
			dw_print.SetTransObject(SQLCA)
		end if
		
end choose
dw_body.event constructor()
dw_body.Object.DataWindow.Print.Orientation	 = 1
dw_print.Object.DataWindow.Print.Orientation	 = 1		
		

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
//String     ls_shop_nm 
//Boolean    lb_check 
//DataStore  lds_Source
//
//CHOOSE CASE as_column
//	CASE "shop_cd"				
//			IF ai_div = 1 THEN 	
//				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
//				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
//					RETURN 0
//				END IF 
//			END IF
//		   gst_cd.ai_div          = ai_div
//			gst_cd.window_title    = "매장 코드 검색" 
//			gst_cd.datawindow_nm   = "d_com912" 
//			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
//			ELSE
//				gst_cd.Item_where = ""
//			END IF
//
//			lds_Source = Create DataStore
//			OpenWithParm(W_COM200, lds_Source)
//
//			lb_check = FALSE 
//			IF Isvalid(Message.PowerObjectParm) THEN
//				ib_itemchanged = True
//				lds_Source = Message.PowerObjectParm
//				IF ai_div = 2 THEN 
//				   dw_head.SetRow(al_row)
//				   dw_head.SetColumn(as_column)
//				END IF 
//				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
//				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
//				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("end_ymd")
//				ib_itemchanged = False 
//				lb_check = TRUE 
//			END IF
//			Destroy  lds_Source
//END CHOOSE
//
//IF ai_div = 1 THEN 
//	IF lb_check THEN
//      RETURN 2 
//	ELSE
//		RETURN 1
//	END IF
//END IF
//
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

event ue_preview();call super::ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation	 = 1


//dw_body.ShareData(dw_print)

il_rows = dw_print.retrieve(is_brand, is_year, is_season, is_item, is_style, is_chno, is_sojae)

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

dw_body.Object.DataWindow.Print.Orientation	 = 1
dw_print.Object.DataWindow.Print.Orientation	 = 1


dw_1.Object.DataWindow.HorizontalScrollSplit  = 385
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

dw_print.object.t_brand.text  = is_brand  + ' ' +  idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_year.text   = is_year
dw_print.object.t_season.text = is_season + ' ' +  idw_season.getitemstring(idw_season.getrow(),"inter_nm")
dw_print.object.t_item.text   = is_item   + ' ' +  idw_item.getitemstring(idw_item.getrow(),"item_nm")

dw_print.object.t_style.text   = is_style + is_chno




end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_62026_d","0")
end event

type cb_close from w_com000`cb_close within w_62026_d
integer taborder = 100
end type

type cb_delete from w_com000`cb_delete within w_62026_d
boolean visible = false
integer x = 1083
integer taborder = 50
end type

type cb_insert from w_com000`cb_insert within w_62026_d
boolean visible = false
integer x = 741
integer taborder = 40
end type

type cb_retrieve from w_com000`cb_retrieve within w_62026_d
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

type cb_update from w_com000`cb_update within w_62026_d
boolean visible = false
integer taborder = 90
end type

type cb_print from w_com000`cb_print within w_62026_d
integer x = 1426
integer taborder = 60
end type

type cb_preview from w_com000`cb_preview within w_62026_d
integer x = 1769
integer taborder = 70
end type

type gb_button from w_com000`gb_button within w_62026_d
integer taborder = 0
end type

type cb_excel from w_com000`cb_excel within w_62026_d
integer x = 2112
end type

type dw_head from u_dw within w_62026_d
event ue_keydown pbm_dwnkey
integer x = 5
integer y = 172
integer width = 4297
integer height = 144
integer taborder = 10
string dataobject = "d_62026_h01"
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

event rbuttonup;//
end event

event constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')


This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1,'sojae','%')
idw_sojae.SetItem(1,'sojae_nm','전체')


This.GetChild("item", idw_item)
idw_item.SetTRansObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.insertrow(1)
idw_item.Setitem(1, "item", "%")
idw_item.Setitem(1, "item_nm", "전체")

end event

event itemchanged;call super::itemchanged;string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
		
		This.GetChild("sojae", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('%', data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "sojae", "%")
		ldw_child.Setitem(1, "sojae_nm", "전체")
		
	
		This.GetChild("item", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve(data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "item", "%")
		ldw_child.Setitem(1, "item_nm", "전체")		
				
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")				
		

END CHOOSE
end event

type ln_1 from line within w_62026_d
integer linethickness = 4
integer beginy = 336
integer endx = 3621
integer endy = 336
end type

type ln_2 from line within w_62026_d
long linecolor = 16777215
integer linethickness = 4
integer beginy = 340
integer endx = 3621
integer endy = 340
end type

type dw_body from u_dw within w_62026_d
integer x = 5
integer y = 356
integer width = 3589
integer height = 1684
integer taborder = 30
string dataobject = "d_62026_pic"
boolean hscrollbar = true
boolean hsplitscroll = true
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

event clicked;call super::clicked;

///*===========================================================================*/
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

this.setrow(row)
this.object.style(row).backgroundcolor = rgb(213,140,247)
end event

type dw_print from u_dw within w_62026_d
boolean visible = false
integer x = 192
integer y = 1076
integer width = 1006
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_62026_r01"
boolean hscrollbar = true
end type

event constructor;call super::constructor;This.of_SetPrintPreview(TRUE)
end event

type cb_yymmdd from commandbutton within w_62026_d
integer x = 3584
integer y = 196
integer width = 315
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일자별보기"
end type

event clicked;string ls_style


ls_style = dw_body.getitemstring(dw_body.getrow(),"style")
il_rows = dw_1.retrieve(ls_style)
if il_rows > 0 then
	dw_1.visible = true	
end if
end event

type dw_excel from datawindow within w_62026_d
boolean visible = false
integer x = 2386
integer y = 540
integer width = 411
integer height = 432
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_62026_d06"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_life from datawindow within w_62026_d
boolean visible = false
integer x = 553
integer y = 704
integer width = 3035
integer height = 1332
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_62026_d07"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event resize;cb_flus.x = this.x + 2760
cb_minor.x = this.x + 2888

cb_flus.y = this.y + 108
cb_minor.y = this.y + 108
end event

type cb_1 from commandbutton within w_62026_d
integer x = 3904
integer y = 196
integer width = 293
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Life Cycle"
end type

event clicked;string ls_style


ls_style = dw_body.getitemstring(dw_body.getrow(),"style")
il_rows = dw_life.retrieve(ls_style, '%', '2')
if il_rows > 0 then
	dw_life.title = ls_style + ' --->> Life Cycle'
	dw_life.visible  = true	
end if
end event

type cb_flus from commandbutton within w_62026_d
integer x = 4206
integer y = 196
integer width = 119
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "+"
end type

event clicked;integer li_labels
li_labels = dec(dw_life.object.gr_1.category.displayeverynlabels)
li_labels = li_labels + 1

if li_labels < 0 then 	li_labels = 0
dw_life.object.gr_1.category.displayeverynlabels = li_labels
end event

type cb_minor from commandbutton within w_62026_d
integer x = 4334
integer y = 196
integer width = 119
integer height = 84
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "-"
end type

event clicked;integer li_labels
li_labels = dec(dw_life.object.gr_1.category.displayeverynlabels)
li_labels = li_labels - 1

if li_labels < 0 then 	li_labels = 0
dw_life.object.gr_1.category.displayeverynlabels = li_labels
end event

type dw_1 from datawindow within w_62026_d
boolean visible = false
integer x = 480
integer y = 464
integer width = 3099
integer height = 1168
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "일자별"
string dataobject = "d_62026_d04"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

