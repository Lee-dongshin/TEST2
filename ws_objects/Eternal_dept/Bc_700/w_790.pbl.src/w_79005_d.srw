$PBExportHeader$w_79005_d.srw
$PBExportComments$월별 A/S 접수/처리 집계 현황
forward
global type w_79005_d from w_com010_d
end type
type rb_cust from radiobutton within w_79005_d
end type
type rb_user from radiobutton within w_79005_d
end type
type gb_1 from groupbox within w_79005_d
end type
end forward

global type w_79005_d from w_com010_d
rb_cust rb_cust
rb_user rb_user
gb_1 gb_1
end type
global w_79005_d w_79005_d

type variables
DataWindowChild idw_brand, idw_season

String is_brand, is_year, is_season, is_fr_yymm, is_to_yymm, is_judg_fg

end variables

on w_79005_d.create
int iCurrent
call super::create
this.rb_cust=create rb_cust
this.rb_user=create rb_user
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_cust
this.Control[iCurrent+2]=this.rb_user
this.Control[iCurrent+3]=this.gb_1
end on

on w_79005_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_cust)
destroy(this.rb_user)
destroy(this.gb_1)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_fr_yymm, is_to_yymm, is_judg_fg)

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
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
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

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then is_year = '%'

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_fr_yymm = Trim(String(dw_head.GetItemDatetime(1, "fr_yymm"), 'yyyymm'))
if IsNull(is_fr_yymm) or is_fr_yymm = "" then
   MessageBox(ls_title,"접수 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymm")
   return false
end if

is_to_yymm = Trim(String(dw_head.GetItemDatetime(1, "to_yymm"), 'yyyymm'))
if IsNull(is_to_yymm) or is_to_yymm = "" then
   MessageBox(ls_title,"접수 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   return false
end if

if is_to_yymm < is_fr_yymm then
   MessageBox(ls_title,"마지막 년월이 시작 년월보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   return false
end if

//is_judg_fg1 = Trim(dw_head.GetItemString(1, "judg_fg1"))
//is_judg_fg2 = Trim(dw_head.GetItemString(1, "judg_fg2"))
//if is_judg_fg1 = '2' and is_judg_fg2 = '1' then
//   MessageBox(ls_title,"판정 구분을 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("judg_fg1")
//   return false
//end if

is_judg_fg = dw_head.GetItemSTRING(1, "judg_fg")
if IsNull(is_judg_fg) or is_judg_fg = "" then
   MessageBox(ls_title,"판정 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("judg_fg")
   return false
end if



return true

end event

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.29                                                  */	
/* 수정일      : 2002.03.29                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_judg_fg

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_judg_fg = '0' Then
	ls_judg_fg = ' 반송'
ELSEIf is_judg_fg = '1' Then
	ls_judg_fg = ' 수선'	
ELSEIf is_judg_fg = '2' Then
	ls_judg_fg = ' CLAIM'	
ELSEIf is_judg_fg = '3' Then
	ls_judg_fg = ' 심의중'	
ELSEIf is_judg_fg = '4' Then
	ls_judg_fg = ' 미처리'		
ELSE
	ls_judg_fg = ' 전체'			
End If

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id + "'" + &
            "t_user_id.Text  = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_year.Text     = '" + is_year + "'" + &
            "t_season.Text   = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_yymm.Text     = '" + String(is_fr_yymm + is_to_yymm, '@@@@/@@ ~~ @@@@/@@') + "'" + &
            "t_judg_fg.Text  = '" + ls_judg_fg + "'"

dw_print.Modify(ls_modify)

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
         rb_cust.Enabled = false
         rb_user.Enabled = false
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
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
		rb_cust.Enabled = true
		rb_user.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_79005_d","0")
end event

type cb_close from w_com010_d`cb_close within w_79005_d
end type

type cb_delete from w_com010_d`cb_delete within w_79005_d
end type

type cb_insert from w_com010_d`cb_insert within w_79005_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_79005_d
end type

type cb_update from w_com010_d`cb_update within w_79005_d
end type

type cb_print from w_com010_d`cb_print within w_79005_d
end type

type cb_preview from w_com010_d`cb_preview within w_79005_d
end type

type gb_button from w_com010_d`gb_button within w_79005_d
end type

type cb_excel from w_com010_d`cb_excel within w_79005_d
end type

type dw_head from w_com010_d`dw_head within w_79005_d
integer x = 434
integer width = 3003
integer height = 216
string dataobject = "d_79005_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "brand"
			
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")				
		
	
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_79005_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_d`ln_2 within w_79005_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_79005_d
integer y = 444
integer height = 1596
string dataobject = "d_79005_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_79005_d
string dataobject = "d_79005_r01"
end type

type rb_cust from radiobutton within w_79005_d
integer x = 59
integer y = 216
integer width = 274
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
string text = "업  체"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor    = RGB(0, 0, 255)
rb_user.TextColor = 0

dw_body.DataObject = 'd_79005_d01'
dw_print.DataObject = 'd_79005_r01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_user from radiobutton within w_79005_d
integer x = 59
integer y = 312
integer width = 274
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
string text = "소비자"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_cust.TextColor = 0
This.TextColor    = RGB(0, 0, 255)

dw_body.DataObject = 'd_79005_d02'
dw_print.DataObject = 'd_79005_r02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type gb_1 from groupbox within w_79005_d
integer y = 136
integer width = 402
integer height = 284
integer taborder = 20
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

