$PBExportHeader$w_51004_e.srw
$PBExportComments$표준 재고 설정
forward
global type w_51004_e from w_com010_e
end type
type cb_copy from commandbutton within w_51004_e
end type
type st_per from statictext within w_51004_e
end type
type st_up from statictext within w_51004_e
end type
type sle_uprate from singlelineedit within w_51004_e
end type
type st_remark from statictext within w_51004_e
end type
end forward

global type w_51004_e from w_com010_e
cb_copy cb_copy
st_per st_per
st_up st_up
sle_uprate sle_uprate
st_remark st_remark
end type
global w_51004_e w_51004_e

type variables
DataWindowChild idw_brand, idw_season1, idw_season2

String is_brand, is_yymm, is_year1, is_season1, is_year2, is_season2
Decimal idc_price, idc_plan_rate

end variables

on w_51004_e.create
int iCurrent
call super::create
this.cb_copy=create cb_copy
this.st_per=create st_per
this.st_up=create st_up
this.sle_uprate=create sle_uprate
this.st_remark=create st_remark
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_copy
this.Control[iCurrent+2]=this.st_per
this.Control[iCurrent+3]=this.st_up
this.Control[iCurrent+4]=this.sle_uprate
this.Control[iCurrent+5]=this.st_remark
end on

on w_51004_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_copy)
destroy(this.st_per)
destroy(this.st_up)
destroy(this.sle_uprate)
destroy(this.st_remark)
end on

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.07                                                  */	
/* 수정일      : 2002.02.07                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymm, is_year1, is_season1, is_year2, is_season2, &
									idc_price, idc_plan_rate)

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
/* 작성일      : 2002.02.07                                                  */	
/* 수정일      : 2002.02.07                                                  */
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


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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


is_yymm = Trim(String(dw_head.GetItemDatetime(1, "yymm"), 'yyyymm'))
if IsNull(is_yymm) or is_yymm = "" then
   MessageBox(ls_title,"년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_year1 = Trim(dw_head.GetItemString(1, "year1"))
if IsNull(is_year1) or is_year1 = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year1")
   return false
end if

is_season1 = Trim(dw_head.GetItemString(1, "season1"))
if IsNull(is_season1) or is_season1 = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season1")
   return false
end if

is_year2 = Trim(dw_head.GetItemString(1, "year2"))
if IsNull(is_year2) or is_year2 = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year2")
   return false
end if

is_season2 = Trim(dw_head.GetItemString(1, "season2"))
if IsNull(is_season2) or is_season2 = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season2")
   return false
end if

If is_year2 < is_year1 Then
   MessageBox(ls_title,"시즌 년도를 차례대로 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season2")
   return false
end if
	
idc_price = dw_head.GetItemDecimal(1, "price")
if IsNull(idc_price) or idc_price = 0 then
   MessageBox(ls_title,"평균 단가를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("price")
   return false
end if

idc_plan_rate = dw_head.GetItemDecimal(1, "plan_rate")
if IsNull(idc_plan_rate) or idc_plan_rate = 0 then
   MessageBox(ls_title,"목표 비율을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("plan_rate")
   return false
end if

return true

end event

event open;call super::open;dw_head.SetItem(1, "year1", dw_head.GetItemString(1, "year") )
dw_head.SetItem(1, "season1", dw_head.GetItemString(1, "season") )
dw_head.SetItem(1, "year2", dw_head.GetItemString(1, "year") )
dw_head.SetItem(1, "season2", dw_head.GetItemString(1, "season") )

end event

event ue_button;/*===========================================================================*/
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
			ib_changed = true
			cb_update.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_delete.enabled = true
         sle_uprate.Enabled = true
         cb_copy.Enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows = 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
		sle_uprate.Enabled = false
		cb_copy.Enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.07                                                  */	
/* 수정일      : 2002.02.07                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ll_row_count = dw_body.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "limit_qty",   dw_body.GetItemDecimal(i, "limit_qty1")   * 1000)
      dw_body.Setitem(i, "limit_amt",   dw_body.GetItemDecimal(i, "limit_amt1")   * 1000)
      dw_body.Setitem(i, "uplimit_qty", dw_body.GetItemDecimal(i, "uplimit_qty1") * 1000)
      dw_body.Setitem(i, "uplimit_amt", dw_body.GetItemDecimal(i, "uplimit_amt1") * 1000)
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
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

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(st_remark, "FixedToRight")
inv_resize.of_Register(cb_copy, "FixedToRight")
inv_resize.of_Register(st_per, "FixedToRight")
inv_resize.of_Register(sle_uprate, "FixedToRight")
inv_resize.of_Register(st_up, "FixedToRight")

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.08                                                  */	
/* 수정일      : 2002.02.08                                                  */
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
				"t_season.Text = '(  " + is_year1 + " " + &
												idw_season1.GetItemString(idw_season1.GetRow(), "inter_display") + "  AND  " + &
												is_year2 + " " + &
												idw_season2.GetItemString(idw_season2.GetRow(), "inter_display") + "  )'" + &
				"t_price.Text = '" + String(idc_price, '#,##0') + "'" + &
				"t_plan_rate.Text = '" + String(idc_plan_rate) + " %'"

dw_print.Modify(ls_modify)

end event

event ue_preview;call super::ue_preview;///*===========================================================================*/
///* 작성자      : (주)지우정보                                                */	
///* 작성일      : 2002.01.03                                                  */	
///* 수정일      : 2002.01.03                                                  */
///*===========================================================================*/
//
//This.Trigger Event ue_title ()
//
//dw_print.retrieve(is_brand, is_yymm, is_year1, is_season1, is_year2, is_season2, &
//									 idc_price, idc_plan_rate)
//									
//dw_print.inv_printpreview.of_SetZoom()
//
end event

event ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long ll_rows

This.Trigger Event ue_title()

ll_rows = dw_print.retrieve(is_brand, is_yymm, is_year1, is_season1, is_year2, is_season2, &
									 idc_price, idc_plan_rate)

IF ll_rows = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_51004_e","0")
end event

type cb_close from w_com010_e`cb_close within w_51004_e
end type

type cb_delete from w_com010_e`cb_delete within w_51004_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_51004_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_51004_e
end type

type cb_update from w_com010_e`cb_update within w_51004_e
end type

type cb_print from w_com010_e`cb_print within w_51004_e
end type

type cb_preview from w_com010_e`cb_preview within w_51004_e
end type

type gb_button from w_com010_e`gb_button within w_51004_e
end type

type cb_excel from w_com010_e`cb_excel within w_51004_e
end type

type dw_head from w_com010_e`dw_head within w_51004_e
integer height = 220
string dataobject = "d_51004_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season1", idw_season1)
idw_season1.SetTransObject(SQLCA)
idw_season1.Retrieve('003')

This.GetChild("season2", idw_season2)
idw_season2.SetTransObject(SQLCA)
idw_season2.Retrieve('003')

end event

type ln_1 from w_com010_e`ln_1 within w_51004_e
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_e`ln_2 within w_51004_e
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_e`dw_body within w_51004_e
integer y = 564
integer height = 1476
string dataobject = "d_51004_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
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

type dw_print from w_com010_e`dw_print within w_51004_e
string dataobject = "d_51004_r01"
end type

type cb_copy from commandbutton within w_51004_e
event ue_keydown pbm_keydown
integer x = 3182
integer y = 452
integer width = 347
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "일괄적용(&C)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF

end event

event clicked;Decimal ldc_up_rate
Long    i

ldc_up_rate = Long(sle_uprate.Text)

For i = 1 To dw_body.RowCount()
	dw_body.SetItem(i, "up_rate", ldc_up_rate)
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

type st_per from statictext within w_51004_e
integer x = 3099
integer y = 480
integer width = 69
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "%"
boolean focusrectangle = false
end type

type st_up from statictext within w_51004_e
integer x = 2661
integer y = 480
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "UP"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_uprate from singlelineedit within w_51004_e
event ue_keydown pbm_keydown
integer x = 2834
integer y = 468
integer width = 251
integer height = 76
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean enabled = false
string text = "0"
integer limit = 2
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	cb_copy.SetFocus()
END IF

end event

event modified;Decimal ldc_up_rate

ldc_up_rate = Long(sle_uprate.Text)

If IsNull(ldc_up_rate) Then ldc_up_rate = 0

sle_uprate.Text = String(ldc_up_rate)

end event

type st_remark from statictext within w_51004_e
integer x = 2853
integer y = 348
integer width = 704
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
string text = "( 단위 : 천원 )"
alignment alignment = right!
boolean focusrectangle = false
end type

