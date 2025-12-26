$PBExportHeader$w_22204_d.srw
$PBExportComments$원/부자재 수불 집계표
forward
global type w_22204_d from w_com010_d
end type
end forward

global type w_22204_d from w_com010_d
integer width = 3680
integer height = 2276
end type
global w_22204_d w_22204_d

type variables
string is_brand,   is_year, is_season, is_yymm, is_mat_gubn
DataWindowChild idw_brand, idw_season
end variables

on w_22204_d.create
call super::create
end on

on w_22204_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/* event       : ue_keycheck                                                 */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

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
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"조회년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_mat_gubn = dw_head.GetItemString(1, "mat_gubn")
if IsNull(is_mat_gubn) or Trim(is_mat_gubn) = "" then
   MessageBox(ls_title,"자재구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("mat_gubn")
   return false
end if

return true
end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/* event       : ue_retrieve                                                 */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_yymm,is_mat_gubn)
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
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

If is_mat_gubn = '1' Then
	ls_title = '원자재 수불 집계표'
Else
	ls_title = '부자재 수불 집계표'
End If

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
				"t_title.Text = '" + ls_title + "'"  + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_year.Text = '" + is_year + "'" + &
            "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
				"t_yymm.Text = '" + is_yymm + "'" 
dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22204_d","0")
end event

type cb_close from w_com010_d`cb_close within w_22204_d
end type

type cb_delete from w_com010_d`cb_delete within w_22204_d
end type

type cb_insert from w_com010_d`cb_insert within w_22204_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_22204_d
end type

type cb_update from w_com010_d`cb_update within w_22204_d
end type

type cb_print from w_com010_d`cb_print within w_22204_d
end type

type cb_preview from w_com010_d`cb_preview within w_22204_d
end type

type gb_button from w_com010_d`gb_button within w_22204_d
end type

type cb_excel from w_com010_d`cb_excel within w_22204_d
end type

type dw_head from w_com010_d`dw_head within w_22204_d
integer y = 164
integer height = 172
string dataobject = "d_22204_h01"
boolean livescroll = false
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.08                                                  */	
/* 수정일      : 2002.01.08                                                  */
/* event       : constructor(dw_head)                                        */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTRansObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1,"inter_cd", '%')
idw_season.SetItem(1,"inter_nm",'전체')


end event

type ln_1 from w_com010_d`ln_1 within w_22204_d
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com010_d`ln_2 within w_22204_d
integer beginy = 352
integer endy = 352
end type

type dw_body from w_com010_d`dw_body within w_22204_d
integer y = 368
integer height = 1672
string dataobject = "d_22204_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_22204_d
string dataobject = "d_22204_r01"
end type

