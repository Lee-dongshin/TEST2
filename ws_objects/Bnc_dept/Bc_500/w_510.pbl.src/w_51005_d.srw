$PBExportHeader$w_51005_d.srw
$PBExportComments$표준 재고 비교 현황
forward
global type w_51005_d from w_com010_d
end type
end forward

global type w_51005_d from w_com010_d
end type
global w_51005_d w_51005_d

type variables
DataWindowChild idw_brand, idw_season1, idw_season2

String is_brand, is_yymm, is_year1, is_season1, is_year2, is_season2

end variables

on w_51005_d.create
call super::create
end on

on w_51005_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_head.SetItem(1, "year1", dw_head.GetItemString(1, "year") )
dw_head.SetItem(1, "season1", dw_head.GetItemString(1, "season") )
dw_head.SetItem(1, "year2", dw_head.GetItemString(1, "year") )
dw_head.SetItem(1, "season2", dw_head.GetItemString(1, "season") )

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
	
return true

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.07                                                  */	
/* 수정일      : 2002.02.07                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymm, is_year1, is_season1, is_year2, is_season2)

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
												idw_season2.GetItemString(idw_season2.GetRow(), "inter_display") + "  )'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_51005_d","0")
end event

type cb_close from w_com010_d`cb_close within w_51005_d
end type

type cb_delete from w_com010_d`cb_delete within w_51005_d
end type

type cb_insert from w_com010_d`cb_insert within w_51005_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_51005_d
end type

type cb_update from w_com010_d`cb_update within w_51005_d
end type

type cb_print from w_com010_d`cb_print within w_51005_d
end type

type cb_preview from w_com010_d`cb_preview within w_51005_d
end type

type gb_button from w_com010_d`gb_button within w_51005_d
end type

type cb_excel from w_com010_d`cb_excel within w_51005_d
end type

type dw_head from w_com010_d`dw_head within w_51005_d
integer height = 124
string dataobject = "d_51005_h01"
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

type ln_1 from w_com010_d`ln_1 within w_51005_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_51005_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_51005_d
integer y = 348
integer height = 1692
string dataobject = "d_51005_d01"
end type

type dw_print from w_com010_d`dw_print within w_51005_d
string dataobject = "d_51005_r01"
end type

