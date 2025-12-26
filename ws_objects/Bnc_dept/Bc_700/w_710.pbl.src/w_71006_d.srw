$PBExportHeader$w_71006_d.srw
$PBExportComments$보너스쿠폰출력
forward
global type w_71006_d from w_com010_e
end type
type dw_excel from datawindow within w_71006_d
end type
type dw_1 from datawindow within w_71006_d
end type
end forward

global type w_71006_d from w_com010_e
dw_excel dw_excel
dw_1 dw_1
end type
global w_71006_d w_71006_d

type variables
String 	is_brand,is_shop_cd,is_area,is_give_date,is_jumin, is_vip
DataWindowChild idw_brand,idw_area
Long		il_point
end variables

on w_71006_d.create
int iCurrent
call super::create
this.dw_excel=create dw_excel
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_excel
this.Control[iCurrent+2]=this.dw_1
end on

on w_71006_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_excel)
destroy(this.dw_1)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "give_date", string(ld_datetime,"yyyymmdd"))

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
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

is_give_date = dw_head.GetItemString(1, "give_date")
if IsNull(is_give_date) OR Trim(is_give_date)="" then
   MessageBox(ls_title,"발행일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("give_date")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
is_jumin = dw_head.GetItemString(1, "jumin")
is_area 	= dw_head.GetItemString(1, "area")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")
is_vip = dw_head.GetItemString(1, "vip")

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm,ls_card_no,ls_jumin,ls_user_name
DataStore  lds_Source
Boolean    lb_check 
int		  li_rows
long		  ll_point
String	  ls_jumin2

CHOOSE CASE as_column
	CASE "jumin"
			IF ai_div = 1 THEN 	
				IF gf_cust_jumin_chk(Trim(as_data), ls_user_name,ls_card_no) = TRUE THEN
				   dw_head.SetItem(al_row, "user_name", ls_user_name)
				   dw_head.SetItem(al_row, "jumin", Trim(as_data))					
				   dw_head.SetItem(al_row, "card_no", RightA(ls_card_no,9))
					RETURN 2
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where   = " jumin LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "jumin", lds_Source.GetItemString(1,"jumin"))
				dw_head.SetItem(al_row, "user_name", lds_Source.GetItemString(1,"user_name"))
				dw_head.SetItem(al_row, "card_no", RightA(lds_Source.GetItemString(1,"card_no"),9))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("user_name")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "card_no"
			IF ai_div = 1 THEN 	
				IF gf_cust_card_chk('4870090'+Trim(as_data),ls_jumin,ls_user_name) = TRUE THEN
				   dw_head.SetItem(al_row, "user_name", ls_user_name)
				   dw_head.SetItem(al_row, "card_no", RightA(Trim(as_data),9))			
				   dw_head.SetItem(al_row, "jumin", ls_jumin)
					RETURN 2
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where   = " card_no LIKE '" + '4870090'+as_data + "%'"
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
				dw_head.SetItem(al_row, "jumin", lds_Source.GetItemString(1,"jumin"))
				dw_head.SetItem(al_row, "user_name", lds_Source.GetItemString(1,"user_name"))
				dw_head.SetItem(al_row, "card_no", RightA(lds_Source.GetItemString(1,"card_no"),9))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("user_name")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "user_name"				
			IF ai_div = 1 THEN
				IF gf_cust_name_chk(as_data, ls_user_name, ls_jumin,ls_card_no) = TRUE THEN
				   dw_head.SetItem(al_row, "user_name", ls_user_name)
				   dw_head.SetItem(al_row, "jumin", ls_jumin)
				   dw_head.SetItem(al_row, "card_no", RightA(ls_card_no,9))
					RETURN 2
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where   = " user_name LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "jumin", lds_Source.GetItemString(1,"jumin"))
				dw_head.SetItem(al_row, "user_name", lds_Source.GetItemString(1,"user_name"))
				dw_head.SetItem(al_row, "card_no", RightA(lds_Source.GetItemString(1,"card_no"),9))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("user_name")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source		
	CASE "shop_cd"							// 매장 코드
		is_area = dw_head.GetItemString(1, "area")
		is_brand = dw_head.GetItemString(1, "brand")
		If IsNull(is_brand) or Trim(is_brand) = "" Then 
			is_brand = ""
		END IF
		If IsNull(is_area) or Trim(is_area) = "" Then 
			is_area = ""
		END IF
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF LeftA(as_data, 1) <> is_brand Then
					MessageBox("입력오류","해당 브랜드의 매장코드가 아닙니다!")
					RETURN 1
				ELSEIF gf_shop_nm(as_data, 'S', ls_part_nm) <> 0 THEN
					MessageBox("입력오류","등록되지 않은 매장코드입니다!")
					RETURN 1
				END IF
				dw_head.SetItem(al_row, "shop_nm", ls_part_nm)
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "매장 코드 검색" 
				gst_cd.datawindow_nm   = "d_com912" 
				gst_cd.default_where   = " WHERE SHOP_CD LIKE '" + is_brand + "%' AND AREA_CD LIKE '"+is_area+"%'"
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " SHOP_CD LIKE '" + as_data + "%' "
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
					dw_head.SetColumn("sale_dt")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
			END IF
	CASE "close"
			dw_1.Visible = False
END CHOOSE

RETURN 0

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_area,is_brand,is_shop_cd,0,is_jumin,is_give_date, is_vip)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

cb_update.enabled = false
ib_changed = false

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

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_excel.retrieve(is_area,is_brand,is_shop_cd,0,is_jumin,is_give_date)

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

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
dw_1.SetTransObject(SQLCA)
dw_excel.SetTransObject(SQLCA)

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime
string ls_shop_nm , ls_vip


ls_shop_nm = dw_head.GetItemString(1,'shop_nm')

IF ls_shop_nm = "" OR isnull(ls_shop_nm) THEN
	ls_shop_nm = "전체"
END IF

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_vip = '2' then
	ls_vip = 'VIP 회원'
else 
	ls_vip = '전체회원'
end if


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
				"t_area.Text = '" + idw_area.GetItemString(idw_area.GetRow(), "inter_display") + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_shop_nm.Text = '" + ls_shop_nm + "'" + &
				"t_vip.Text = '" + ls_vip + "'"
				

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_71006_d","0")
end event

type cb_close from w_com010_e`cb_close within w_71006_d
end type

type cb_delete from w_com010_e`cb_delete within w_71006_d
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_71006_d
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_71006_d
end type

type cb_update from w_com010_e`cb_update within w_71006_d
boolean visible = false
end type

type cb_print from w_com010_e`cb_print within w_71006_d
end type

type cb_preview from w_com010_e`cb_preview within w_71006_d
end type

type gb_button from w_com010_e`gb_button within w_71006_d
end type

type cb_excel from w_com010_e`cb_excel within w_71006_d
end type

type dw_head from w_com010_e`dw_head within w_71006_d
integer y = 168
integer height = 264
string dataobject = "d_71006_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.01.18                                                  */
/*===========================================================================*/
This.GetChild("area", idw_area)
idw_area.SetTRansObject(SQLCA)
idw_area.Retrieve('090')

idw_area.InsertRow(1)
idw_area.SetItem(1,'inter_cd','%')
idw_area.SetItem(1,'inter_nm','전체')

This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

idw_brand.InsertRow(1)
idw_brand.SetItem(1,'inter_cd','%')
idw_brand.SetItem(1,'inter_nm','전체')


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "area"
		This.SetItem(1, "brand", "")
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
	CASE "brand"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "jumin","user_name","card_no"
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

type ln_1 from w_com010_e`ln_1 within w_71006_d
end type

type ln_2 from w_com010_e`ln_2 within w_71006_d
end type

type dw_body from w_com010_e`dw_body within w_71006_d
string dataobject = "d_71006_d02"
boolean hscrollbar = true
end type

event dw_body::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
String ls_jumin

IF row > 0 THEN
	dw_1.Visible = True
	ls_jumin = this.GetItemString(row,'jumin')
	dw_1.Retrieve(ls_jumin)
END IF

this.selectRow(0, false);
this.setRow(row);
this.selectRow(row, true);

end event

type dw_print from w_com010_e`dw_print within w_71006_d
integer x = 773
integer y = 916
string dataobject = "d_71006_r01"
end type

type dw_excel from datawindow within w_71006_d
boolean visible = false
integer x = 681
integer y = 760
integer width = 1056
integer height = 880
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_71006_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_71006_d
boolean visible = false
integer x = 626
integer y = 128
integer width = 2606
integer height = 1564
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "포인트발행내역"
string dataobject = "d_71006_d05"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.28                                                  */	
/* 수정일      : 2002.02.28                                                   */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

