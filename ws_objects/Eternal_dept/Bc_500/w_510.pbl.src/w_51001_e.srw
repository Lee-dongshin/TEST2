$PBExportHeader$w_51001_e.srw
$PBExportComments$월 매출 계획 등록
forward
global type w_51001_e from w_com010_e
end type
type st_unit from statictext within w_51001_e
end type
end forward

global type w_51001_e from w_com010_e
integer width = 3680
integer height = 2276
st_unit st_unit
end type
global w_51001_e w_51001_e

type variables
DataWindowChild idw_brand, idw_sale_type,idw_person_id

String is_brand, is_yymm, is_sale_type, is_emp_no

end variables

on w_51001_e.create
int iCurrent
call super::create
this.st_unit=create st_unit
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_unit
end on

on w_51001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_unit)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/
String     ls_emp_nm, ls_dept_cd, ls_brand
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "emp_no"				
		is_brand = Trim(dw_head.GetItemString(1, "brand"))
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data)  = "" THEN
				   dw_head.SetItem(al_row, "emp_nm", "")
					RETURN 0
				END IF 
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "영업부 사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 

			If gf_get_inter_sub('991', is_brand + '50', '1', ls_dept_cd) = False Then
				dw_head.SetItem(al_row, "emp_no", "")
				dw_head.SetItem(al_row, "emp_nm", "")
				Return 2
			END IF 
			ls_brand = dw_head.getitemstring(1,"brand")
			
			if ls_brand  <> 'W' then
				gst_cd.default_where   = " WHERE (DEPT_CODE = '" + ls_dept_cd + "' or empno = 'A20401') " + &
												 "   AND GOOUT_GUBN = '1' "
			else												 
				gst_cd.default_where   = " WHERE (DEPT_CODE in ('K000', 'K120' ) or empno = 'A20401') " + &
												 "   AND GOOUT_GUBN = '1' "
			end if												 

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "EMPNO LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "emp_no", lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "emp_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
//				dw_head.SetColumn("end_ymd")
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

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymm, is_sale_type, is_emp_no)

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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymm = Trim(String(dw_head.GetItemDatetime(1, "yymm"), 'yyyymm'))
if IsNull(is_yymm) or is_yymm = "" then
   MessageBox(ls_title,"계획 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_sale_type = Trim(dw_head.GetItemString(1, "sale_type"))
if IsNull(is_sale_type) or is_sale_type = "" then
   MessageBox(ls_title,"판매 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_type")
   return false
end if

is_emp_no = Trim(dw_head.GetItemString(1, "person_id"))
if IsNull(is_emp_no) or is_emp_no = "" then
   MessageBox(ls_title,"사원 번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("person_id")
   return false
end if

return true

end event

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.06                                                  */	
/* 수정일      : 2002.02.06                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
String ls_new_chk

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	If idw_status = DataModified! THEN				/* Modify Record */
		dw_body.SetItem(i, "plan_amt", dw_body.GetItemDecimal(i, "plan_amt1") * 1000 )
		
		ls_new_chk = dw_body.GetItemString(i, "new_chk")
		If ls_new_chk = 'NEW' Then
			dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
			dw_body.SetItem(i, "reg_id", gs_user_id)
		Else
			dw_body.SetItem(i, "mod_id", gs_user_id)
			dw_body.SetItem(i, "mod_dt", ld_datetime)
		END IF
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(st_unit, "FixedToRight")

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.06                                                  */	
/* 수정일      : 2002.02.06                                                  */
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
            "t_yymm.Text = '" + String(is_yymm, '@@@@/@@') + "'" + &
            "t_sale_type.Text = '" + idw_sale_type.GetItemString(idw_sale_type.GetRow(), "inter_display") + "'" + &
            "t_emp_no.Text = '" + is_emp_no + "'" + &
            "t_emp_nm.Text = '" + dw_head.GetItemString(1, "emp_nm") + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_51001_e","0")
end event

type cb_close from w_com010_e`cb_close within w_51001_e
end type

type cb_delete from w_com010_e`cb_delete within w_51001_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_51001_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_51001_e
end type

type cb_update from w_com010_e`cb_update within w_51001_e
end type

type cb_print from w_com010_e`cb_print within w_51001_e
end type

type cb_preview from w_com010_e`cb_preview within w_51001_e
end type

type gb_button from w_com010_e`gb_button within w_51001_e
end type

type cb_excel from w_com010_e`cb_excel within w_51001_e
end type

type dw_head from w_com010_e`dw_head within w_51001_e
integer height = 128
string dataobject = "d_51001_h01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("sale_type", idw_sale_type)
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.Retrieve('011')

This.GetChild("person_id", idw_person_id)
idw_person_id.SetTransObject(SQLCA)
idw_person_id.Retrieve(gs_brand)
idw_person_id.InsertRow(0)

end event

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/




CHOOSE CASE dwo.name
	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"person_id","")
		This.GetChild("person_id", idw_person_id)
		idw_person_id.SetTransObject(SQLCA)
		idw_person_id.Retrieve(data)
		idw_person_id.InsertRow(0)
	CASE "emp_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_51001_e
integer beginy = 380
integer endy = 380
end type

type ln_2 from w_com010_e`ln_2 within w_51001_e
integer beginy = 384
integer endy = 384
end type

type dw_body from w_com010_e`dw_body within w_51001_e
integer y = 400
integer height = 1640
string dataobject = "d_51001_d01"
end type

event dw_body::constructor;call super::constructor;This.SetRowFocusIndicator(Hand!)

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

type dw_print from w_com010_e`dw_print within w_51001_e
string dataobject = "d_51001_r01"
end type

type st_unit from statictext within w_51001_e
integer x = 1824
integer y = 320
integer width = 1719
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "매장상태가 정상이 아닌경우 적색표시     (단위 : 천원)"
alignment alignment = right!
boolean focusrectangle = false
end type

