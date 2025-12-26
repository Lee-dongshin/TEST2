$PBExportHeader$w_33008_d.srw
$PBExportComments$시즌별어음현금결제 현황
forward
global type w_33008_d from w_com010_d
end type
end forward

global type w_33008_d from w_com010_d
integer width = 3675
integer height = 2268
end type
global w_33008_d w_33008_d

type variables
datawindowchild idw_brand, idw_season

string is_brand, is_year, is_season, is_fr_yymmdd, is_to_yymmdd, is_opt

end variables

on w_33008_d.create
call super::create
end on

on w_33008_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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

is_year = dw_head.GetItemString(1, "year")
is_season    = dw_head.GetItemString(1, "season")
is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_opt    = dw_head.GetItemString(1, "opt")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_fr_yymmdd, is_to_yymmdd, is_opt)
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

event open;call super::open;dw_body.Object.DataWindow.HorizontalScrollSplit  = 945
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_33008_d","0")
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
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
 				 "t_brand.Text = '" + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm") + "'" + &
				 "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.getitemstring(idw_season.getrow(),"inter_nm") + "'" + &
				 "t_fr_yymmdd.Text = '" + is_fr_yymmdd + "'" + &
				 "t_to_yymmdd.Text = '" + is_to_yymmdd + "'"
dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_33008_d
end type

type cb_delete from w_com010_d`cb_delete within w_33008_d
end type

type cb_insert from w_com010_d`cb_insert within w_33008_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_33008_d
end type

type cb_update from w_com010_d`cb_update within w_33008_d
end type

type cb_print from w_com010_d`cb_print within w_33008_d
end type

type cb_preview from w_com010_d`cb_preview within w_33008_d
end type

type gb_button from w_com010_d`gb_button within w_33008_d
end type

type cb_excel from w_com010_d`cb_excel within w_33008_d
end type

type dw_head from w_com010_d`dw_head within w_33008_d
integer height = 172
string dataobject = "d_33008_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("season", idw_season)
idw_season.SetTRansObject(SQLCA)
idw_season.Retrieve('003')
idw_season.insertrow(1)
idw_season.setitem(1,"inter_cd","%")
idw_season.setitem(1,"inter_nm","전체")

end event

type ln_1 from w_com010_d`ln_1 within w_33008_d
integer beginy = 356
integer endy = 356
end type

type ln_2 from w_com010_d`ln_2 within w_33008_d
integer beginy = 360
integer endy = 360
end type

type dw_body from w_com010_d`dw_body within w_33008_d
integer y = 376
integer height = 1652
string dataobject = "d_33008_d01"
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_33008_d
string dataobject = "d_33008_r01"
end type

