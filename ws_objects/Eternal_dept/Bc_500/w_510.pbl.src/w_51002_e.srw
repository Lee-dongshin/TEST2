$PBExportHeader$w_51002_e.srw
$PBExportComments$일 매출 계획 등록
forward
global type w_51002_e from w_com020_e
end type
type st_remark from statictext within w_51002_e
end type
type dw_real from u_dw within w_51002_e
end type
type cb_clear from commandbutton within w_51002_e
end type
end forward

global type w_51002_e from w_com020_e
integer width = 3675
integer height = 2276
st_remark st_remark
dw_real dw_real
cb_clear cb_clear
end type
global w_51002_e w_51002_e

type variables
DataWindowChild idw_brand

String is_brand, is_yymm

end variables

on w_51002_e.create
int iCurrent
call super::create
this.st_remark=create st_remark
this.dw_real=create dw_real
this.cb_clear=create cb_clear
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_remark
this.Control[iCurrent+2]=this.dw_real
this.Control[iCurrent+3]=this.cb_clear
end on

on w_51002_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_remark)
destroy(this.dw_real)
destroy(this.cb_clear)
end on

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */ 
/* 작성일      : 2002.02.06                                                  */
/* 수정일      : 2002.02.06                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_yymm)

dw_body.Reset()
dw_real.Reset()

IF il_rows > 0 THEN
   dw_list.SetFocus()
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
/* 작성일      : 2002.02.06                                                  */	
/* 수정일      : 2002.02.06                                                  */
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

is_yymm = String(dw_head.GetItemDatetime(1, "yymm"), 'yyyymm')
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"계획 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

return true

end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(st_remark, "FixedToRight")
inv_resize.of_Register(cb_clear, "FixedToRight")

dw_real.SetTransObject(SQLCA)

end event

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.06                                                  */	
/* 수정일      : 2002.02.06                                                  */
/*===========================================================================*/
long           i, j, ll_row_count, ll_row
datetime       ld_datetime
String         ls_new_chk, ls_plan_ymd, ls_sale_type

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ll_row_count = dw_body.RowCount()
FOR i = 1 TO ll_row_count
	For j = 4 To 6
		idw_status = dw_body.GetItemStatus(i, j, Primary!)
		If idw_status = DataModified! THEN				/* Modify Record */
			ls_plan_ymd  = dw_body.GetItemString(i, "plan_ymd")
			ls_sale_type = RightA(dw_body.Describe("#" + String(j) + ".name"), 2)

			ll_row = dw_real.Find(" plan_ymd = '" + ls_plan_ymd + "' " + &
										 " and sale_type = '" + ls_sale_type + "' ", 1, dw_real.RowCount())
			
			If ll_row >= 1 Then
				dw_real.SetItem(ll_row, "plan_amt", dw_body.GetItemDecimal(i, j) * 1000)
		      dw_real.Setitem(ll_row, "mod_id", gs_user_id)
      		dw_real.Setitem(ll_row, "mod_dt", ld_datetime)
			ElseIf ll_row = 0 Then
				ll_row = dw_real.InsertRow(0)
				dw_real.SetItem(ll_row, "plan_ymd", ls_plan_ymd)
				dw_real.SetItem(ll_row, "brand", is_brand)
				dw_real.SetItem(ll_row, "sale_type", ls_sale_type)
				dw_real.SetItem(ll_row, "plan_amt", dw_body.GetItemDecimal(i, j) * 1000)
				dw_real.Setitem(ll_row, "reg_id", gs_user_id)
			End If
		End If
	Next
NEXT

il_rows = dw_real.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_real.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event ue_button;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
      else
         dw_head.SetFocus()
      end if

   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_list.Enabled = true
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_insert.enabled = false
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
		cb_clear.Enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
			If is_yymm >= String(Today(), 'yyyymm') Then
				cb_clear.Enabled = true
			Else
				cb_clear.Enabled = false
			End IF
		else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
         cb_insert.enabled = true
      end if
END CHOOSE

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
            "t_yymm.Text = '" + String(is_yymm, '@@@@/@@') + "'"

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_51002_e","0")
end event

type cb_close from w_com020_e`cb_close within w_51002_e
integer taborder = 120
end type

type cb_delete from w_com020_e`cb_delete within w_51002_e
boolean visible = false
integer taborder = 70
end type

type cb_insert from w_com020_e`cb_insert within w_51002_e
boolean visible = false
integer taborder = 60
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_51002_e
integer taborder = 30
end type

type cb_update from w_com020_e`cb_update within w_51002_e
integer taborder = 110
end type

type cb_print from w_com020_e`cb_print within w_51002_e
integer taborder = 80
end type

type cb_preview from w_com020_e`cb_preview within w_51002_e
integer taborder = 90
end type

type gb_button from w_com020_e`gb_button within w_51002_e
end type

type cb_excel from w_com020_e`cb_excel within w_51002_e
integer taborder = 100
end type

type dw_head from w_com020_e`dw_head within w_51002_e
integer height = 124
string dataobject = "d_51002_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com020_e`ln_1 within w_51002_e
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com020_e`ln_2 within w_51002_e
integer beginy = 332
integer endy = 332
end type

type dw_list from w_com020_e`dw_list within w_51002_e
integer y = 348
integer width = 1417
integer height = 1692
integer taborder = 40
string dataobject = "d_51002_d01"
end type

event dw_list::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.06                                                  */	
/* 수정일      : 2002.02.06                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_yymm = This.GetItemString(row, 'yymm') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_yymm) THEN return

il_rows = dw_body.retrieve(is_brand, is_yymm)
			 dw_real.retrieve(is_brand, is_yymm)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_e`dw_body within w_51002_e
integer x = 1472
integer y = 348
integer width = 2121
integer height = 1692
integer taborder = 50
string dataobject = "d_51002_d02"
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
		// Column.Protect = True Then Return
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0 
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0 
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

Return 0
end event

event dw_body::constructor;This.SetRowFocusIndicator(Hand!)

end event

type st_1 from w_com020_e`st_1 within w_51002_e
integer x = 1449
integer y = 348
integer height = 1692
end type

type dw_print from w_com020_e`dw_print within w_51002_e
string dataobject = "d_51002_r02"
end type

type st_remark from statictext within w_51002_e
integer x = 2999
integer y = 264
integer width = 576
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "(단위 : 천원)"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_real from u_dw within w_51002_e
boolean visible = false
integer x = 1198
integer y = 380
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_51002_d03"
end type

type cb_clear from commandbutton within w_51002_e
event ue_keydown pbm_keydown
integer x = 1079
integer y = 44
integer width = 347
integer height = 92
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "Clear(&C)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF

end event

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.06                                                  */	
/* 수정일      : 2002.02.06                                                  */
/*===========================================================================*/
Long i, j
Decimal ldc_plan_amt
For i = 1 To dw_body.RowCount()
	For j = 4 To 6
		ldc_plan_amt = dw_body.GetItemDecimal(i, j)
		If Not(IsNull(ldc_plan_amt) or ldc_plan_amt = 0) Then
			dw_body.SetItem(i, j, 0)
		End If
	Next
Next

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

dw_body.SetFocus()

end event

event getfocus;This.Weight = 700

end event

event losefocus;This.Weight = 400

end event

