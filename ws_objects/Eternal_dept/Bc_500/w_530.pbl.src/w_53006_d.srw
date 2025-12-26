$PBExportHeader$w_53006_d.srw
$PBExportComments$타사 매출 현황
forward
global type w_53006_d from w_com010_d
end type
type dw_excel from datawindow within w_53006_d
end type
end forward

global type w_53006_d from w_com010_d
integer width = 3675
integer height = 2244
dw_excel dw_excel
end type
global w_53006_d w_53006_d

type variables
DatawindowChild idw_brand, idw_shop_div

String is_brand, is_sale_dt, is_sale_dt1, is_shop_cd, is_shop_div

end variables

on w_53006_d.create
int iCurrent
call super::create
this.dw_excel=create dw_excel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_excel
end on

on w_53006_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_excel)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "sale_dt", string(ld_datetime,"YYYYMMDD"))
dw_head.SetItem(1, "sale_dt1", string(ld_datetime,"YYYYMMDD"))

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
Datetime ld_datetime
String ls_datetime, ls_modify, ls_shop_cd

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if LenA(is_shop_cd) = 6 and is_shop_cd <> "%" then
	ls_shop_cd = MidA(is_shop_cd, 3,4)
else 
	ls_shop_cd = is_shop_cd
end if	


il_rows = dw_body.retrieve(is_brand, is_sale_dt,is_sale_dt1, ls_shop_cd, is_shop_div)

dw_excel.SetTransObject(SQLCA)
dw_excel.retrieve(is_brand, is_sale_dt,is_sale_dt1, ls_shop_cd, is_shop_div)

IF il_rows > 0 THEN
	IF gf_sysdate(ld_datetime) = FALSE THEN
		ld_datetime = DateTime(Today(), Now())
	END IF
	
	ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
	
	ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
					"t_user_id.Text = '" + gs_user_id + "'" + &
					"t_datetime.Text = '" + ls_datetime + "'" + &
					"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_sale_dt.Text = '" + String(is_sale_dt, '@@@@/@@/@@') + "'" + &
					"t_shop_div.Text = '" + idw_shop_div.GetItemString(idw_shop_div.GetRow(), "inter_display") + "'"

	dw_body.Modify(ls_modify)
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
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

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

is_sale_dt = dw_head.GetItemString(1, "sale_dt")
if IsNull(is_sale_dt) or Trim(is_sale_dt) = "" then
   MessageBox(ls_title,"판매일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_dt")
   return false
end if

is_sale_dt1 = dw_head.GetItemString(1, "sale_dt1")
if IsNull(is_sale_dt1) or Trim(is_sale_dt1) = "" then
   MessageBox(ls_title,"판매일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_dt1")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = "%"
end if

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

return true

end event

event ue_preview;dw_body.inv_printpreview.of_SetZoom()

end event

event ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.21                                                  */	
/* 수정일      : 2001.12.21                                                  */
/*===========================================================================*/


il_rows = dw_print.retrieve(is_brand, is_sale_dt, IS_SALE_DT1, IS_SHOP_CD, is_shop_div)
This.Trigger Event ue_title()
IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF

This.Trigger Event ue_msg(6, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm, ls_flag, ls_age_grp, ls_jumin 
String     ls_style,   ls_chno, ls_data 
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				if gs_brand <> 'K' then
					IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
						dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
						RETURN 0
					END IF 
				end if
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_DIV")
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

event ue_title;call super::ue_title;/*===========================================================================*/
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
					"t_datetime.Text = '" + ls_datetime + "'" + &
					"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_sale_dt.Text = '" + String(is_sale_dt, '@@@@/@@/@@') + "'" + &
					"t_shop_div.Text = '" + idw_shop_div.GetItemString(idw_shop_div.GetRow(), "inter_display") + "'"

	dw_PRINT.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53006_d","0")
end event

event ue_excel();/*===========================================================================*/
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
li_ret = dw_excel.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_close from w_com010_d`cb_close within w_53006_d
end type

type cb_delete from w_com010_d`cb_delete within w_53006_d
end type

type cb_insert from w_com010_d`cb_insert within w_53006_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_53006_d
end type

type cb_update from w_com010_d`cb_update within w_53006_d
end type

type cb_print from w_com010_d`cb_print within w_53006_d
end type

type cb_preview from w_com010_d`cb_preview within w_53006_d
end type

type gb_button from w_com010_d`gb_button within w_53006_d
end type

type cb_excel from w_com010_d`cb_excel within w_53006_d
end type

type dw_head from w_com010_d`dw_head within w_53006_d
integer y = 160
integer height = 208
string dataobject = "d_53006_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name

CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		IF LenA(DATA) = 0  THEN RETURN -1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_53006_d
integer beginy = 380
integer endy = 380
end type

type ln_2 from w_com010_d`ln_2 within w_53006_d
integer beginy = 384
integer endy = 384
end type

type dw_body from w_com010_d`dw_body within w_53006_d
integer x = 9
integer y = 400
integer width = 3584
integer height = 1604
string dataobject = "d_53006_d03"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;This.of_SetPrintPreview(TRUE)

end event

type dw_print from w_com010_d`dw_print within w_53006_d
string dataobject = "d_53006_d03"
end type

type dw_excel from datawindow within w_53006_d
boolean visible = false
integer x = 1554
integer y = 520
integer width = 1559
integer height = 840
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_53006_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

