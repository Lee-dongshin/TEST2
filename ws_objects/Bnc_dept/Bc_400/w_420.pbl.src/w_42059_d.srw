$PBExportHeader$w_42059_d.srw
$PBExportComments$신세계 EDI용 화일 생성
forward
global type w_42059_d from w_com010_d
end type
type st_1 from statictext within w_42059_d
end type
end forward

global type w_42059_d from w_com010_d
integer width = 3689
integer height = 2292
st_1 st_1
end type
global w_42059_d w_42059_d

type variables
DataWindowChild idw_brand, idw_jup_gubn, idw_shop_type, idw_house_cd
String is_brand, is_yymmdd, is_jup_gubn, is_gubn, is_shop_cd, is_shop_type
String is_house_cd, is_opt_gubn, is_rqst_ymd, is_reg_dt
end variables

on w_42059_d.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_42059_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event open;call super::open;datetime ld_datetime
string ls_out_ymd

select convert(char(08),  getdate(), 112)
into :ls_out_ymd
from dual;

dw_head.setitem(1, "rqst_ymd", ls_out_ymd) //작업일자
dw_head.setitem(1, "reg_dt", ls_out_ymd) //작업일자
dw_head.setitem(1, "jup_gubn", "O1") 
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42059_d","0")
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


inv_resize.of_Register(dw_head, "ScaleToRight")
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

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
//elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
elseif (gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'E' or is_brand = 'M' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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


is_yymmdd = string(dw_head.GetItemDate(1, "yymmdd"), "YYYYMMDD")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"출고일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_jup_gubn = dw_head.GetItemString(1, "jup_gubn")
if IsNull(is_jup_gubn) or Trim(is_jup_gubn) = "" then
   MessageBox(ls_title,"전표구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jup_gubn")
   return false
end if

is_gubn = dw_head.GetItemString(1, "gubn")
if IsNull(is_gubn) or Trim(is_gubn) = "" then
   MessageBox(ls_title,"출고 반품 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubn")
   return false
end if

is_opt_gubn = dw_head.GetItemString(1, "opt_gubn")
if IsNull(is_opt_gubn) or Trim(is_opt_gubn) = "" then
   MessageBox(ls_title,"파일구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_gubn")
   return false
end if


if is_opt_gubn = "A" then
	is_shop_cd = dw_head.GetItemString(1, "shop_cd")
	if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
		MessageBox(ls_title,"매장코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("shop_cd")
		return false
	end if
else	
	is_shop_cd = dw_head.GetItemString(1, "shop_cd")
	if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
		is_shop_cd = "%"
	end if	
end if
	
	is_shop_type = dw_head.GetItemString(1, "shop_type")
	if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
		MessageBox(ls_title,"매장형태를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("shop_type")
		return false
	end if	
	

is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
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

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				IF LeftA(as_data, 1) = is_brand And gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm",  ls_shop_nm)
				   dw_head.SetItem(al_row, "shop_div", '%')
				   dw_head.SetItem(al_row, "area_cd",  '%')
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
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
				dw_head.SetItem(al_row, "shop_div", '%')
				dw_head.SetItem(al_row, "area_cd",  '%')
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
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

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_opt_gubn = "A" then
	dw_body.DataObject = "d_42059_d01"
	dw_body.SetTransObject(SQLCA)
else	
	dw_body.DataObject = "d_42059_d12"
	dw_body.SetTransObject(SQLCA)
end if	

il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_shop_cd,is_shop_type, is_jup_gubn, is_house_cd, is_gubn, is_rqst_ymd, is_reg_dt)
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

string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

ls_doc_nm = "Sheet1.xls"

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
li_ret = dw_body.SaveasAscii(ls_doc_nm, "	","")
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_close from w_com010_d`cb_close within w_42059_d
end type

type cb_delete from w_com010_d`cb_delete within w_42059_d
integer taborder = 0
end type

type cb_insert from w_com010_d`cb_insert within w_42059_d
integer taborder = 0
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42059_d
end type

type cb_update from w_com010_d`cb_update within w_42059_d
end type

type cb_print from w_com010_d`cb_print within w_42059_d
boolean visible = false
integer taborder = 0
end type

type cb_preview from w_com010_d`cb_preview within w_42059_d
boolean visible = false
integer taborder = 0
end type

type gb_button from w_com010_d`gb_button within w_42059_d
end type

type cb_excel from w_com010_d`cb_excel within w_42059_d
integer x = 37
integer y = 40
integer width = 384
string text = "화일생성(&E)"
end type

type dw_head from w_com010_d`dw_head within w_42059_d
integer width = 3561
integer height = 280
string dataobject = "d_42059_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("house_cd", idw_house_cd )
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('%')

This.GetChild("jup_gubn", idw_jup_gubn )
idw_jup_gubn.SetTransObject(SQLCA)
idw_jup_gubn.Retrieve('025')

This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')




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
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_42059_d
integer beginy = 468
integer endy = 468
end type

type ln_2 from w_com010_d`ln_2 within w_42059_d
integer beginx = 9
integer beginy = 472
integer endy = 472
end type

type dw_body from w_com010_d`dw_body within w_42059_d
integer y = 484
integer width = 3593
integer height = 1556
string dataobject = "d_42059_d12"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_42059_d
end type

type st_1 from statictext within w_42059_d
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
long backcolor = 79741120
string text = "※ 파일명 변경하지 마시고 엑셀이 열린 후  엑셀통합문서 양식으로 다시 저장하세요!"
boolean focusrectangle = false
end type

