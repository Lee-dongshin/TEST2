$PBExportHeader$w_sh352_d.srw
$PBExportComments$입고반품비교조회(쇼핑몰)
forward
global type w_sh352_d from w_com010_d
end type
type dw_1 from datawindow within w_sh352_d
end type
end forward

global type w_sh352_d from w_com010_d
integer width = 2976
integer height = 2032
long backcolor = 16777215
dw_1 dw_1
end type
global w_sh352_d w_sh352_d

type variables
DataWindowChild idw_brand, idw_year, idw_season
String is_brand, is_fr_ymd, is_to_ymd, is_year, is_season, is_style, is_outin_gubn
end variables

on w_sh352_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_sh352_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")

dw_1.SetTransObject(SQLCA)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;string   ls_title

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

if MidA(gs_shop_cd,2,5) = 'D1900' or MidA(gs_shop_cd,2,5) = 'X4988' then
else
	messagebox("주의!", '쇼핑몰에서만 사용할 수 있습니다!')
	return false
end if	


is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"종료일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
	is_style = "%"
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_outin_gubn = dw_head.GetItemString(1, "outin_gubn")
if IsNull(is_outin_gubn) or Trim(is_outin_gubn) = "" then
   MessageBox(ls_title,"출반구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("outin_gubn")
   return false
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
dw_1.visible = false
//@brand		varchar(01),
//@shop_type	varchar(01),
//@fr_ymd		varchar(08),
//@to_ymd		varchar(08),
//@year		varchar(04),
//@season		varchar(01),
//@style		varchar(08),
//@outin_gubn	varchar(01)  

il_rows = dw_body.retrieve(is_brand, "%", is_fr_ymd, is_to_ymd,is_year, is_season, is_style, is_outin_gubn)
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_style, ls_chno, ls_color, ls_size  
Boolean    lb_check 
DataStore  lds_Source 

CHOOSE CASE as_column
	CASE "style"		
//			IF ai_div = 1 THEN 	
//				RETURN 0 
//			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com011" 
			gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + as_data + "%'" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lb_check = FALSE 
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				dw_head.SetColumn("outin_gubn")
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

event open;call super::open;

if MidA(gs_shop_cd,2,5) = 'D1900' or MidA(gs_shop_cd,2,5) = 'X4988' then
else	
	messagebox("주의!", '쇼핑몰에서만 사용할 수 있습니다!')
	return 1
end if	

end event

event ue_preview();IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

This.Trigger Event ue_title()

//messagebox("" ,is_brand + '/' + is_fr_ymd + '/' + is_to_ymd + '/' + is_outin_gubn + '/' + is_year + '/' + is_season)

dw_print.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_outin_gubn, is_year, is_season)


dw_print.inv_printpreview.of_SetZoom()

end event

type cb_close from w_com010_d`cb_close within w_sh352_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh352_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh352_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh352_d
end type

type cb_update from w_com010_d`cb_update within w_sh352_d
end type

type cb_print from w_com010_d`cb_print within w_sh352_d
string text = "Excel(&E)"
end type

event cb_print::clicked;string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_print.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_outin_gubn, is_year, is_season)


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
li_ret = dw_print.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)
end event

type cb_preview from w_com010_d`cb_preview within w_sh352_d
integer width = 384
boolean enabled = true
string text = "전표출력(&V)"
end type

type gb_button from w_com010_d`gb_button within w_sh352_d
long backcolor = 16777215
end type

type dw_head from w_com010_d`dw_head within w_sh352_d
integer height = 208
string dataobject = "d_sh352_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
	CASE "style"	 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_sh352_d
integer beginy = 380
integer endy = 380
end type

type ln_2 from w_com010_d`ln_2 within w_sh352_d
integer beginy = 384
integer endy = 384
end type

type dw_body from w_com010_d`dw_body within w_sh352_d
integer y = 392
integer height = 1404
string dataobject = "d_sh352_d01"
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("color", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()
end event

event dw_body::doubleclicked;call super::doubleclicked;string ls_style, ls_chno, ls_color, ls_size

dw_1.reset()
IF row < 0 THEN RETURN 

ls_style = dw_body.getitemstring(row, "style")
ls_chno  = dw_body.getitemstring(row, "chno")
ls_color = dw_body.getitemstring(row, "color")
ls_size  = dw_body.getitemstring(row, "size")

IF dw_1.Retrieve(is_brand, is_fr_ymd, is_to_ymd, ls_style, ls_chno, ls_color, ls_size, is_outin_gubn) > 0 THEN 
   dw_1.visible = True						  
END IF



end event

type dw_print from w_com010_d`dw_print within w_sh352_d
string dataobject = "d_sh352_r03"
end type

type dw_1 from datawindow within w_sh352_d
boolean visible = false
integer y = 392
integer width = 2898
integer height = 1408
integer taborder = 40
boolean titlebar = true
string title = "상세내역"
string dataobject = "d_sh352_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;dw_1.visible = false
end event

event constructor;DataWindowChild ldw_child 

This.GetChild("color", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("911")
end event

