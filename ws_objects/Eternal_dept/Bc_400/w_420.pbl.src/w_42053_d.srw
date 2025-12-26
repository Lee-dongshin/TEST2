$PBExportHeader$w_42053_d.srw
$PBExportComments$롯데EDI파일 발주
forward
global type w_42053_d from w_com010_d
end type
type st_1 from statictext within w_42053_d
end type
end forward

global type w_42053_d from w_com010_d
integer width = 3675
integer height = 2276
st_1 st_1
end type
global w_42053_d w_42053_d

type variables
DataWindowChild idw_brand, idw_shop_type, idw_house_cd, idw_jup_gubn, idw_shop_id
String is_brand, is_yymmdd, is_shop_cd, is_house_cd, is_jup_gubn, is_shop_type
String is_edi_code, is_out_ymd, is_data_ymd, is_rqst_ymd, is_reg_dt, is_opt_plan
end variables

on w_42053_d.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_42053_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title,   ls_today
Datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_today = string(ld_datetime,"yyyymmdd")

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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"출고일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = "%"
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
	is_shop_type = "%"
end if

is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"출고창고를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if

is_jup_gubn = dw_head.GetItemString(1, "jup_gubn")
if IsNull(is_jup_gubn) or Trim(is_jup_gubn) = "" then
   MessageBox(ls_title,"전표구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jup_gubn")
   return false
end if

if is_shop_cd = "%" then
	is_edi_code = "0101"
	dw_head.SetItem(1, "edi_code", "")	
	
else	
	is_edi_code = dw_head.GetItemString(1, "edi_code")	
end if

is_out_ymd = dw_head.GetItemString(1, "out_ymd")
if IsNull(is_out_ymd) or Trim(is_out_ymd) = "" then
   MessageBox(ls_title,"실출고예정일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_ymd")
   return false
end if

is_data_ymd = dw_head.GetItemString(1, "data_ymd")
if IsNull(is_data_ymd) or Trim(is_data_ymd) = "" then
   MessageBox(ls_title,"발주일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("data_ymd")
   return false
end if

is_rqst_ymd = dw_head.GetItemString(1, "rqst_ymd")
if IsNull(is_rqst_ymd) or Trim(is_rqst_ymd) = "" then
   MessageBox(ls_title,"작업일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rqst_ymd")
   return false
end if

is_reg_dt = dw_head.GetItemString(1, "reg_dt")
if IsNull(is_reg_dt) or Trim(is_reg_dt) = "" then
   MessageBox(ls_title,"등록일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("reg_dt")
   return false
end if

if ls_today > is_data_ymd then
   MessageBox(ls_title,"발주일자는 금일보다 커야 합니다. 다시 입력하십시요!")
	 return false
end if

if is_data_ymd >= is_out_ymd then
   MessageBox(ls_title," 출고예정일은 금일보다 커야 합니다. 다시 입력하십시요!")
 return false
end if

is_opt_plan = dw_head.GetItemString(1, "opt_gubn")

return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_42053_d01 '20060404','o','og0008','%','010000','o1'

il_rows = dw_body.retrieve(is_yymmdd, is_brand, is_shop_cd, is_shop_type, is_house_cd, is_jup_gubn, is_out_ymd, is_data_ymd, is_rqst_ymd, is_reg_dt, is_opt_plan)
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

event ue_excel();
string ls_doc_nm, ls_nm, ls_web_id
integer li_ret
boolean lb_exist
Pointer Old_pointer
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF


if is_brand = "O" or is_brand = "K" then
	ls_web_id = "3724116_P_" + string(ld_datetime,"yyyymmdd") + "_" + MidA(is_edi_code,2,3) + ".xls"
else	
	ls_web_id = "3724115_P_" + string(ld_datetime,"yyyymmdd") + "_" + MidA(is_edi_code,2,3) + ".xls"
end if


IF GetFileSaveName("Select File", ls_web_id, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_web_id)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_web_id,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)
li_ret = dw_body.SaveasAscii(ls_web_id, "	","")
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_web_id, Maximized!)



//
//string ls_doc_nm, ls_nm
//
//integer li_ret
//boolean lb_exist
//Pointer Old_pointer
//
//IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "txt", "Text Files (*.txt),*.txt") <> 1 THEN
//	RETURN
//END IF	
//lb_exist = FileExists(ls_doc_nm)
//IF lb_exist THEN 
//   SetPointer(Old_pointer)
//	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
//	if li_ret = 2 then return
//end if
//
//Old_pointer = SetPointer(HourGlass!)
////li_ret = dw_body.SaveAs(ls_doc_nm, Text!, TRUE) 
//li_ret = dw_body.SaveAsAscii(ls_doc_nm  ,"	","")
//
//
//if li_ret <> 1 then
//   SetPointer(Old_pointer)
//	MessageBox("에러!", "파일 쓰기 실패하였습니다.")
//   return
//end if
//SetPointer(Old_pointer)
//Run("C:\windows\system32\notepad.exe " + ls_doc_nm, Maximized!)
//
end event

event pfc_preopen();of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
//inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")


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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
//				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
//				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
//					RETURN 0
//				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
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
				dw_head.SetItem(al_row, "edi_code", lds_Source.GetItemString(1,"edi_code"))				
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("house_cd")
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

event open;call super::open;datetime ld_datetime
string ls_out_ymd, ls_data_ymd

select convert(char(08), dateadd(day, 1, getdate()), 112),convert(char(08),  getdate(), 112)
into :ls_out_ymd, :ls_data_ymd
from dual;


dw_head.setitem(1, "out_ymd",  ls_out_ymd)  //예정일자
dw_head.setitem(1, "data_ymd", ls_data_ymd) //발주일자
dw_head.setitem(1, "rqst_ymd", ls_data_ymd) //발주일자
dw_head.setitem(1, "reg_dt", ls_data_ymd) //발주일자
dw_head.setitem(1, "jup_gubn", "O1") //발주일자
end event

type cb_close from w_com010_d`cb_close within w_42053_d
end type

type cb_delete from w_com010_d`cb_delete within w_42053_d
end type

type cb_insert from w_com010_d`cb_insert within w_42053_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42053_d
end type

type cb_update from w_com010_d`cb_update within w_42053_d
end type

type cb_print from w_com010_d`cb_print within w_42053_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_42053_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_42053_d
end type

type cb_excel from w_com010_d`cb_excel within w_42053_d
integer x = 23
integer width = 384
string text = "화일생성(&E)"
end type

type dw_head from w_com010_d`dw_head within w_42053_d
integer y = 152
integer width = 4219
integer height = 288
string dataobject = "d_42053_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()

THIS.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')


THIS.GetChild("jup_gubn", idw_jup_gubn)
idw_jup_gubn.SetTransObject(SQLCA)
idw_jup_gubn.Retrieve('025')
idw_jup_gubn.InsertRow(1)
idw_jup_gubn.SetItem(1, "inter_cd", '%')
idw_jup_gubn.SetItem(1, "inter_nm", '전체')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if


end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		
		if LenA(data) > 0 then
			IF ib_itemchanged THEN RETURN 1
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		else
			this.setitem(1,"shop_nm","")
			this.setitem(1,"edi_code","")			
		end if	 
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_42053_d
end type

type ln_2 from w_com010_d`ln_2 within w_42053_d
end type

type dw_body from w_com010_d`dw_body within w_42053_d
string dataobject = "d_42053_d02"
end type

event dw_body::constructor;call super::constructor;THIS.GetChild("c______1", idw_shop_id)
idw_shop_id.SetTransObject(SQLCA)
idw_shop_id.Retrieve('092')
end event

type dw_print from w_com010_d`dw_print within w_42053_d
end type

type st_1 from statictext within w_42053_d
integer x = 430
integer y = 64
integer width = 2446
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 파일명 변경하지 마시고 엑셀이 열린 후  CSV 양식으로 다시 저장하세요!"
boolean focusrectangle = false
end type

