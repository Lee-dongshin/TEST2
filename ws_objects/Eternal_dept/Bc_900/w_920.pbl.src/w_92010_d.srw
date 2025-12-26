$PBExportHeader$w_92010_d.srw
$PBExportComments$부서별 계획진행내역 조회
forward
global type w_92010_d from w_com010_d
end type
type cbx_1 from checkbox within w_92010_d
end type
end forward

global type w_92010_d from w_com010_d
cbx_1 cbx_1
end type
global w_92010_d w_92010_d

type variables
String is_dept_code, is_year, is_brand
datawindowchild idw_brand

end variables

on w_92010_d.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
end on

on w_92010_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : 윤상혁                                                      */	
/* 작성일      : 2011.07.14                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN



dw_body.SetTransObject(SQLCA)
il_rows = dw_body.retrieve(is_brAND, is_dept_code, is_year)

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

event type boolean ue_keycheck(string as_cb_div);
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
   MessageBox(ls_title,"브랜드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


//messagebox("", is_brand)

is_dept_code = dw_head.GetItemString(1, "dept_code")
if IsNull(is_dept_code) or Trim(is_dept_code) = "" then
  is_dept_code = '%'
end if

is_year = dw_head.GetItemString(1, "actl_yy")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"해당년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("actl_yy")
   return false
end if

return true

end event

event open;call super::open;datetime ld_datetime
String ls_year


ls_year = String(today(),'YYYY')


dw_head.setitem(1,"actl_yy",ls_year)
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : M.S.I (정 시영)                                             */	
/* 작성일      : 2000.09.18                                                  */	
/* 수성일      : 2000.09.18                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/

string     ls_dept_cd, ls_dept_nm
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "dept_code"			
		
	
		// 사용자 번호
			IF ai_div = 1  THEN 	// ItemChanged!  -> Call
				
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "dept_nm", "")
					RETURN 0
				END IF 
				
				
				select dept_name 
				  into :ls_dept_nm
				  from mis.dbo.thb22
				 where dept_code like :as_data;
				
				IF isnull(ls_dept_nm) or trim(ls_dept_nm) = '' THEN
					MessageBox("입력오류","등록되지 않은 부서코드 입니다!")
					RETURN 1
				END IF
				dw_head.SetItem(al_row, "dept_nm", ls_dept_nm)
				
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "부서 검색" 
				gst_cd.datawindow_nm   = "d_com935"
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "DEPT_CODE  LIKE  ~'" + as_data + "%~'"
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
					dw_head.SetItem(al_row, "dept_code", lds_Source.GetItemString(1,"dept_code"))
					dw_head.SetItem(al_row, "dept_nm", lds_Source.GetItemString(1,"dept_name"))
					ib_itemchanged = False				
				END IF
				Destroy  lds_Source
			END IF			
END CHOOSE

RETURN 0

end event

event ue_preview();This.Trigger Event ue_title ()



il_rows = dw_print.retrieve(IS_BRAND, is_dept_code, is_year)




if il_rows <= 0 Then
	messagebox('확인','출력 할 자료가 없습니다.')
	return 
end if


dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로
dw_print.inv_printpreview.of_SetZoom()
end event

event ue_title();
string ls_dept_code, ls_dept_name, ls_year, ls_modify


ls_dept_code = dw_head.GetItemString(1, "dept_code")
ls_dept_name = dw_head.GetItemString(1, "dept_nm")
ls_year = dw_head.GetItemString(1, "actl_yy")




ls_modify =	"t_dept_code.Text = '" + ls_dept_code + "'" + &
				"t_dept_nm.Text = '" + ls_dept_name + "'" + &
				"t_year.Text = '" + ls_year + "'" 


dw_print.Modify(ls_modify)

end event

event ue_print();This.Trigger Event ue_title ()


dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로


il_rows = dw_print.retrieve(IS_BRAND, is_dept_code, is_year)




if il_rows <= 0 Then
	messagebox('확인','출력 할 자료가 없습니다.')
	return 
else
	il_rows = dw_print.Print()
end if

end event

type cb_close from w_com010_d`cb_close within w_92010_d
end type

type cb_delete from w_com010_d`cb_delete within w_92010_d
end type

type cb_insert from w_com010_d`cb_insert within w_92010_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_92010_d
end type

type cb_update from w_com010_d`cb_update within w_92010_d
end type

type cb_print from w_com010_d`cb_print within w_92010_d
end type

type cb_preview from w_com010_d`cb_preview within w_92010_d
end type

type gb_button from w_com010_d`gb_button within w_92010_d
end type

type cb_excel from w_com010_d`cb_excel within w_92010_d
end type

type dw_head from w_com010_d`dw_head within w_92010_d
integer height = 224
string dataobject = "d_92010_h01"
end type

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : M.S.I (정 시영)                                             */	
/* 작성일      : 2000.09.18                                                  */	
/* 수성일      : 2000.09.18                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "dept_code"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_d`ln_1 within w_92010_d
end type

type ln_2 from w_com010_d`ln_2 within w_92010_d
end type

type dw_body from w_com010_d`dw_body within w_92010_d
integer width = 3584
integer height = 1536
string dataobject = "d_92010_d02"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_92010_d
string dataobject = "d_92010_r02"
end type

type cbx_1 from checkbox within w_92010_d
integer x = 3086
integer y = 256
integer width = 425
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "전 계정과목"
borderstyle borderstyle = stylelowered!
end type

event clicked;
If cbx_1.checked Then
	dw_body.DataObject  = 'd_92010_d01'
	dw_print.DataObject = 'd_92010_r01'
	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
else
	dw_body.DataObject  = 'd_92010_d02'
	dw_print.DataObject = 'd_92010_r02'
	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
end if 
end event

