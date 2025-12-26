$PBExportHeader$w_71014_d.srw
$PBExportComments$카드/쿠폰 재발송
forward
global type w_71014_d from w_com010_d
end type
type rb_card from radiobutton within w_71014_d
end type
type rb_coup from radiobutton within w_71014_d
end type
type em_today from editmask within w_71014_d
end type
type gb_1 from groupbox within w_71014_d
end type
end forward

global type w_71014_d from w_com010_d
rb_card rb_card
rb_coup rb_coup
em_today em_today
gb_1 gb_1
end type
global w_71014_d w_71014_d

type variables
String is_fr_ymd, is_to_ymd, is_flag, is_vip

end variables

on w_71014_d.create
int iCurrent
call super::create
this.rb_card=create rb_card
this.rb_coup=create rb_coup
this.em_today=create em_today
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_card
this.Control[iCurrent+2]=this.rb_coup
this.Control[iCurrent+3]=this.em_today
this.Control[iCurrent+4]=this.gb_1
end on

on w_71014_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_card)
destroy(this.rb_coup)
destroy(this.em_today)
destroy(this.gb_1)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.25                                                  */	
/* 수정일      : 2002.04.25                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_vip)

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
/* 작성일      : 2002.04.25                                                  */	
/* 수정일      : 2002.04.25                                                  */
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

is_fr_ymd = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
if IsNull(is_fr_ymd) or is_fr_ymd = "" then
   MessageBox(ls_title,"접수 기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
if IsNull(is_to_ymd) or is_to_ymd = "" then
   MessageBox(ls_title,"접수 기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

if is_to_ymd < is_fr_ymd then
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_vip = dw_head.GetitemString(1, "vip")

return true

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long i, ll_row

dw_print.DataObject = 'd_71014_r03'
dw_print.SetTransObject(SQLCA)
	
For i = 1 To dw_body.RowCount()
	If dw_body.GetItemString(i, "print_yn") = 'Y' Then
		ll_row = dw_print.InsertRow(0)
		dw_print.SetItem(ll_row, "coupon_no",    dw_body.GetItemString(i, "coupon_no"))
		dw_print.SetItem(ll_row, "zipcode",      dw_body.GetItemString(i, "zip_code"))
		dw_print.SetItem(ll_row, "addr",    	  dw_body.GetItemString(i, "addr"))
		dw_print.SetItem(ll_row, "addr_s",       dw_body.GetItemString(i, "addr_s"))
		dw_print.SetItem(ll_row, "user_name",    dw_body.GetItemString(i, "user_name"))
		dw_print.SetItem(ll_row, "card_no",      dw_body.GetItemString(i, "card_no"))
		dw_print.SetItem(ll_row, "total_point",  dw_body.GetItemDecimal(i, "total_point"))
		dw_print.SetItem(ll_row, "accept_point", dw_body.GetItemDecimal(i, "point"))
		dw_print.SetItem(ll_row, "give_point",   dw_body.GetItemDecimal(i, "accept_point"))
		dw_print.SetItem(ll_row, "give_date",    dw_body.GetItemString(i, "give_date"))
		dw_print.SetItem(ll_row, "coupon_amt",   dw_body.GetItemDecimal(i, "coupon_amt"))
		dw_print.SetItem(ll_row, "VALID_DATE",   dw_body.GetItemString(i, "VALID_DATE"))
		dw_print.SetItem(ll_row, "rest_point",   dw_body.GetItemDecimal(i, "rest_point"))
		dw_print.SetItem(ll_row, "web_point",    dw_body.GetItemDecimal(i, "web_point"))
		dw_print.SetItem(ll_row, "sale_point",   dw_body.GetItemDecimal(i, "sale_point"))
	End If
Next

dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.25                                                  */	
/* 수정일      : 2002.04.25                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_vip

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
            "t_yymmdd.Text = '" + String(is_fr_ymd + is_to_ymd, '@@@@/@@/@@ ~~ @@@@/@@/@@') + "'" + &
				"t_vip.Text = '" + ls_vip + "'"
dw_print.Modify(ls_modify)

end event

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.25                                                  */	
/* 수정일      : 2002.04.25                                                  */
/*===========================================================================*/

If is_flag = '1' Then
	dw_print.DataObject = 'd_71014_r01'
Else
	dw_print.DataObject = 'd_71014_r02'
End If
dw_print.SetTransObject(SQLCA)

This.Trigger Event ue_title ()

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

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
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         rb_card.Enabled = false
         rb_coup.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
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
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
		rb_card.Enabled = true
		rb_coup.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event open;call super::open;is_flag = '1'

em_today.Text = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.05.28                                                  */	
/* 수정일      : 2002.05.28                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_point_seq, ll_give_point, ll_coupon_seq
String ls_jumin, ls_give_date, ls_coupon_no
datetime ld_datetime

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ll_row_count = dw_body.RowCount()

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, "coupon_no", Primary!)
   IF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
		
		ls_jumin   = dw_body.GetItemString(i,'jumin')
		ls_give_date   = dw_body.GetItemString(i,'give_date')
		ls_coupon_no = dw_body.GetItemString(i,'coupon_no')
		ll_point_seq = dw_body.GetItemNumber(i,'point_seq')
		
		ls_coupon_no = dw_body.GetItemString(i,'coupon_no')
		ll_give_point = dw_body.GetItemNumber(i,'give_point')
		// 쿠폰번호 중복체크
		SELECT count(coupon_no) INTO :ll_coupon_seq
		from beaucre.dbo.tb_71011_h
		where  coupon_no = :ls_coupon_no
		AND 	 give_point = :ll_give_point
		AND	point_flag = 1;
		IF ll_coupon_seq > 0 THEN
			Rollback;
			MessageBox("알림",ls_coupon_no+"번은 중복됩니다!!")
			EXIT
		END IF
		// ------------------
		UPDATE beaucre.dbo.TB_71011_H
	   SET coupon_no = :ls_coupon_no
	   WHERE jumin = :ls_jumin
		AND give_date = :ls_give_date
		AND point_seq = :ll_point_seq;
		
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

event ue_delete;Long i, ll_cnt = 0
String ls_today

ls_today = em_today.Text
ls_today = LeftA(ls_today, 4) + MidA(ls_today, 6, 2) + MidA(ls_today, 9, 2)

For i = 1 To dw_body.RowCount()
	dw_body.SetItem(i, "send_ymd", ls_today)
	ll_cnt++
Next

If ll_cnt > 0 Then
	ib_changed = true
	cb_update.enabled = true
	cb_print.enabled = false
	cb_preview.enabled = false
	cb_excel.enabled = false
End If

end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(em_today, "FixedToRight")

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_71014_d","0")
end event

type cb_close from w_com010_d`cb_close within w_71014_d
integer taborder = 120
end type

type cb_delete from w_com010_d`cb_delete within w_71014_d
boolean visible = true
integer taborder = 70
boolean enabled = true
string text = "복사(&C)"
end type

type cb_insert from w_com010_d`cb_insert within w_71014_d
integer taborder = 50
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_71014_d
end type

type cb_update from w_com010_d`cb_update within w_71014_d
boolean visible = true
integer taborder = 110
end type

type cb_print from w_com010_d`cb_print within w_71014_d
integer taborder = 80
string text = "주소인쇄(&P)"
end type

type cb_preview from w_com010_d`cb_preview within w_71014_d
integer taborder = 90
string text = "LIST인쇄(&V)"
end type

type gb_button from w_com010_d`gb_button within w_71014_d
end type

type cb_excel from w_com010_d`cb_excel within w_71014_d
integer taborder = 100
end type

type dw_head from w_com010_d`dw_head within w_71014_d
integer x = 585
integer width = 2971
integer height = 128
string dataobject = "d_71014_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_71014_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_71014_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_71014_d
integer y = 348
integer height = 1692
integer taborder = 40
string dataobject = "d_71014_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "send_ymd"
		If gf_datechk(data) = True Then
			ib_changed = true
			cb_update.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
		Else
			Return 1
		End IF
END CHOOSE

end event

event dw_body::editchanged;call super::editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event dw_body::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
Long i

If dwo.name = "cb_print_yn" Then
	If dwo.Text = '전체제외' Then
		For i = 1 To dw_body.RowCount()
	//		If dw_body.GetItemString(i, "post_flag") <> '2' Then
				dw_body.SetItem(i, "print_yn", 'N')
	//		End If
		Next
		dwo.Text = '전체선택'
	Else
		For i = 1 To dw_body.RowCount()
	//		If dw_body.GetItemString(i, "post_flag") <> '2' Then
				dw_body.SetItem(i, "print_yn", 'Y')
	//		End If
		Next
		dwo.Text = '전체제외'
	End If
End If
end event

type dw_print from w_com010_d`dw_print within w_71014_d
string dataobject = "d_71014_r02"
end type

type rb_card from radiobutton within w_71014_d
integer x = 59
integer y = 212
integer width = 219
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "카드"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_coup.TextColor = 0

dw_body.DataObject = 'd_71014_d01'
dw_body.SetTransObject(SQLCA)

is_flag = '1'

end event

type rb_coup from radiobutton within w_71014_d
integer x = 297
integer y = 212
integer width = 219
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "쿠폰"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_card.TextColor = 0
This.TextColor = RGB(0, 0, 255)

dw_body.DataObject = 'd_71014_d02'
dw_body.SetTransObject(SQLCA)

is_flag = '2'

end event

type em_today from editmask within w_71014_d
event ue_keydown pbm_keydown
integer x = 768
integer y = 44
integer width = 311
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "####/##/##"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	cb_delete.SetFocus()
END IF
end event

type gb_1 from groupbox within w_71014_d
event ue_keydown pbm_keydown
integer y = 136
integer width = 567
integer height = 188
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	cb_delete.SetFocus()
END IF
end event

