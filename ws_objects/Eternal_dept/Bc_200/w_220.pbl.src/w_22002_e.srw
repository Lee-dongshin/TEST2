$PBExportHeader$w_22002_e.srw
$PBExportComments$원자재 검단 등록
forward
global type w_22002_e from w_com010_e
end type
type st_remark from statictext within w_22002_e
end type
end forward

global type w_22002_e from w_com010_e
integer width = 3675
integer height = 2280
st_remark st_remark
end type
global w_22002_e w_22002_e

type variables
DataWindowChild idw_brand

String is_brand, is_mmat_cd

end variables

on w_22002_e.create
int iCurrent
call super::create
this.st_remark=create st_remark
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_remark
end on

on w_22002_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_remark)
end on

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
/*===========================================================================*/
String     ls_mmat_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "mmat_cd"
		is_brand = dw_head.GetItemString(1, "brand")
		
			IF ai_div = 1 THEN 	
				If IsNull(as_data) or Trim(as_data) = "" Then
				   dw_head.SetItem(al_row, "mmat_nm", "")
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "원자재 코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 
			gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' AND STATUS_FG = '20' "			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "MAT_CD LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "mmat_cd", lds_Source.GetItemString(1,"mat_cd"))
				dw_head.SetItem(al_row, "mmat_nm", lds_Source.GetItemString(1,"mat_nm"))
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

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
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

is_mmat_cd = dw_head.GetItemString(1, "mmat_cd")
if IsNull(is_mmat_cd) or Trim(is_mmat_cd) = "" then
   MessageBox(ls_title,"원자재 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("mmat_cd")
   return false
end if

return true

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_mmat_cd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
String   ls_in_ymd, ls_in_no, ls_spec, ls_color
Decimal  ldc_tmp_qty, ldc_qc_qty, ldc_dft_qty1

IF dw_body.AcceptText() <> 1 THEN RETURN -1

ll_row_count = dw_body.RowCount()

// Null Check
For i = 1 to ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	IF idw_status = DataModified! THEN		/* Modify Record */
		ls_spec = dw_body.GetItemString(i, "spec")
		If IsNull(ls_spec) or Trim(ls_spec) = "" Then
			MessageBox("입력오류", "입고 폭을 입력하십시요!")
			dw_body.ScrollToRow(i)
			dw_body.SetColumn("spec")
			dw_body.SetFocus()
			Return -1
		End If
	End If
Next

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	IF idw_status = DataModified! THEN		/* Modify Record */
		ldc_dft_qty1 = dw_body.GetItemDecimal(i, "dft_qty1")
      dw_body.Setitem(i, "dft_qty", ldc_dft_qty1)
      dw_body.Setitem(i, "mod_id",  gs_user_id)
      dw_body.Setitem(i, "mod_dt",  ld_datetime)
		
//		// 폭 변경시 TB_22010_H(입고 내역)에 UPDATE
//		IF dw_body.GetItemStatus(i, "spec", Primary!) = DataModified! THEN		/* Modify Column */
			ldc_tmp_qty  = dw_body.GetItemDecimal(i, "tmp_qty")
			ldc_qc_qty   = dw_body.GetItemDecimal(i, "qc_qty")
			ls_in_ymd    = dw_body.GetItemString (i, "in_ymd")
			ls_in_no     = dw_body.GetItemString (i, "in_no")
			ls_spec      = dw_body.GetItemString (i, "spec")
			
			  UPDATE TB_22010_H
			     SET SPEC    = :ls_spec,
				      DFT_QTY = ISNULL(:ldc_tmp_qty, 0) * (ISNULL(:ldc_dft_qty1, 0) / ISNULL(:ldc_qc_qty, 1)),
				      MOD_ID  = :gs_user_id,
						MOD_DT  = :ld_datetime
				WHERE BRAND   = :is_brand
				  AND IN_YMD  = :ls_in_ymd
				  AND IN_GUBN = '01'
				  AND IN_NO   = :ls_in_no
			  ;
			If SQLCA.SQLCODE <> 0 Then
				MessageBox("저장오류", "TB_22010_H(입고 내역) UPDATE에 실패하였습니다!")
			   rollback  USING SQLCA;
				Return -1
			End If
//		END IF
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	il_rows = dw_body.retrieve(is_brand, is_mmat_cd)
	dw_body.SetFocus()
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
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
            "t_mmat_cd.Text = '" + String(is_mmat_cd, '@@@@@@@@@-@') + "'" + &
            "t_mmat_nm.Text = '" + dw_head.GetItemString(1, "mmat_nm") + "'"

dw_print.Modify(ls_modify)


end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(st_remark, "FixedToRight")

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22002_e","0")
end event

type cb_close from w_com010_e`cb_close within w_22002_e
end type

type cb_delete from w_com010_e`cb_delete within w_22002_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_22002_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_22002_e
end type

type cb_update from w_com010_e`cb_update within w_22002_e
end type

type cb_print from w_com010_e`cb_print within w_22002_e
end type

type cb_preview from w_com010_e`cb_preview within w_22002_e
end type

type gb_button from w_com010_e`gb_button within w_22002_e
end type

type cb_excel from w_com010_e`cb_excel within w_22002_e
end type

type dw_head from w_com010_e`dw_head within w_22002_e
integer height = 124
string dataobject = "d_22002_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(row, "mmat_cd", "")
		This.SetItem(row, "mmat_nm", "")
	CASE "mmat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_22002_e
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_e`ln_2 within w_22002_e
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_e`dw_body within w_22002_e
integer y = 348
integer height = 1692
string dataobject = "d_22002_d01"
boolean hscrollbar = true
end type

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

type dw_print from w_com010_e`dw_print within w_22002_e
string dataobject = "d_22002_r01"
end type

type st_remark from statictext within w_22002_e
integer x = 2949
integer y = 268
integer width = 608
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "( 실입고는 입력불가 )"
alignment alignment = right!
boolean focusrectangle = false
end type

