$PBExportHeader$w_79011_d.srw
$PBExportComments$월별판매수량대리클레임접수량
forward
global type w_79011_d from w_com010_d
end type
end forward

global type w_79011_d from w_com010_d
end type
global w_79011_d w_79011_d

type variables
DataWindowChild idw_brand, idw_season, idw_fr_year, idw_to_year

String is_brand, is_year, is_season, is_yymm, is_judg_fg, is_judg_fg2, is_fr_year, is_to_year

end variables

on w_79011_d.create
call super::create
end on

on w_79011_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_year, is_season, is_yymm, is_fr_year, is_to_year, is_judg_fg)

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

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then is_year = '%'

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_yymm = dw_head.GetItemstring(1, "yymm")
if IsNull(is_yymm) or is_yymm = "" then
   MessageBox(ls_title,"기준년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
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

is_fr_year = Trim(dw_head.GetItemString(1, "fr_year"))
if IsNull(is_fr_year) or is_fr_year = "" then
   MessageBox(ls_title,"비교년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_year")
   return false
end if

is_to_year = Trim(dw_head.GetItemString(1, "to_year"))
if IsNull(is_to_year) or is_to_year = "" then
   MessageBox(ls_title,"비교년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_year")
   return false
end if

is_judg_fg = Trim(dw_head.GetItemString(1, "judg_fg"))
if IsNull(is_judg_fg) or is_judg_fg = "" then
   MessageBox(ls_title,"판정 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("judg_fg")
   return false
end if

if is_fr_year >= is_to_year then
	messagebox("경고!", "비교년도가 같거나 비교시작년도가 대상년도보다 큽니다!")
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
else 	
	ls_judg_fg = ' 전체'			
End If

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id + "'" + &
            "t_user_id.Text  = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_year.Text     = '" + is_year + "'" + &
            "t_season.Text   = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_yymm.Text     = '" + is_yymm + "'" + &
            "t_judg_fg.Text  = '" + ls_judg_fg + "'" + &
            "t_fr_year.Text     = '" + is_fr_year + "'" + &
            "t_to_year.Text     = '" + is_to_year + "'" 
				

dw_print.Modify(ls_modify)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
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
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_79011_d","0")
end event

type cb_close from w_com010_d`cb_close within w_79011_d
end type

type cb_delete from w_com010_d`cb_delete within w_79011_d
end type

type cb_insert from w_com010_d`cb_insert within w_79011_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_79011_d
end type

type cb_update from w_com010_d`cb_update within w_79011_d
end type

type cb_print from w_com010_d`cb_print within w_79011_d
end type

type cb_preview from w_com010_d`cb_preview within w_79011_d
end type

type gb_button from w_com010_d`gb_button within w_79011_d
end type

type cb_excel from w_com010_d`cb_excel within w_79011_d
end type

type dw_head from w_com010_d`dw_head within w_79011_d
integer x = 73
integer y = 144
integer width = 3342
integer height = 200
string dataobject = "d_79011_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("fr_year", idw_fr_year )
idw_fr_year.SetTransObject(SQLCA)
idw_fr_year.Retrieve('002')

This.GetChild("to_year", idw_to_year )
idw_to_year.SetTransObject(SQLCA)
idw_to_year.Retrieve('002')
end event

type ln_1 from w_com010_d`ln_1 within w_79011_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_79011_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_79011_d
integer y = 368
integer height = 1672
string dataobject = "d_79011_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_79011_d
string dataobject = "d_79011_r01"
end type

