$PBExportHeader$w_22202_d.srw
$PBExportComments$부자재 재고 현황
forward
global type w_22202_d from w_com010_d
end type
end forward

global type w_22202_d from w_com010_d
integer width = 3675
integer height = 2272
end type
global w_22202_d w_22202_d

type variables
String is_brand, is_year,  is_season,  is_mat_sojae, is_yymmdd, is_house
DataWindowChild idw_brand, idw_season, idw_mat_sojae,idw_house
end variables

on w_22202_d.create
call super::create
end on

on w_22202_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
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


is_mat_sojae = dw_head.GetItemString(1, "mat_sojae")


is_yymmdd = String(dw_head.GetItemDatetime(1, "yymmdd"), 'yyyymmdd')
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_house = dw_head.GetItemString(1, "house")
if IsNull(is_house) or Trim(is_house) = "" then
   MessageBox(ls_title,"창고코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house")
   return false
end if
return true
end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : ue_retrieve                                                 */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_mat_sojae,is_yymmdd,is_house)
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
/* 작성일      : 2002.01.09                                                  */	
/* 수정일      : 2002.01.09                                                  */
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
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(),'inter_display') + "'" + &
				 "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(),'inter_display') + "'" + &
				 "t_mat_sojae.Text = '" + idw_mat_sojae.GetItemString(idw_mat_sojae.GetRow(),'inter_display') + "'" + &
				 "t_yymmdd.Text = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
				 "t_house.Text = '" + idw_house.GetItemString(idw_house.GetRow(),'Shop_display') + "'"
dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22002_d","0")
end event

type cb_close from w_com010_d`cb_close within w_22202_d
end type

type cb_delete from w_com010_d`cb_delete within w_22202_d
end type

type cb_insert from w_com010_d`cb_insert within w_22202_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_22202_d
end type

type cb_update from w_com010_d`cb_update within w_22202_d
end type

type cb_print from w_com010_d`cb_print within w_22202_d
end type

type cb_preview from w_com010_d`cb_preview within w_22202_d
end type

type gb_button from w_com010_d`gb_button within w_22202_d
end type

type cb_excel from w_com010_d`cb_excel within w_22202_d
end type

type dw_head from w_com010_d`dw_head within w_22202_d
integer height = 208
string dataobject = "d_22202_h01"
boolean livescroll = false
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : constructor(dw_head)                                        */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

This.GetChild("mat_sojae", idw_mat_sojae)
idw_mat_sojae.SetTRansObject(SQLCA)
idw_mat_sojae.Retrieve('006')
idw_mat_sojae.insertrow(1)
idw_mat_sojae.Setitem(1, "inter_cd", "%")
idw_mat_sojae.Setitem(1, "inter_nm", "전체")

This.GetChild("house", idw_house)
idw_house.SetTRansObject(SQLCA)
idw_house.Retrieve('%')
idw_house.insertrow(1)
idw_house.Setitem(1, "shop_cd", "%")
idw_house.Setitem(1, "shop_snm", "전체")


end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "brand", "year"		
		//라빠레트 시즌적용
		dw_head.accepttext()
		is_brand = dw_head.getitemstring(1,'brand')
		is_year = dw_head.getitemstring(1,'year')
		
		this.getchild("season",idw_season)
		idw_season.settransobject(sqlca)
		idw_season.retrieve('003', is_brand, is_year)
		//idw_season.retrieve('003')
		idw_season.insertrow(1)
		idw_season.Setitem(1, "inter_cd", "%")
		idw_season.Setitem(1, "inter_nm", "전체")
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_22202_d
integer beginy = 388
integer endy = 388
end type

type ln_2 from w_com010_d`ln_2 within w_22202_d
integer beginy = 392
integer endy = 392
end type

type dw_body from w_com010_d`dw_body within w_22202_d
integer y = 408
integer height = 1632
string dataobject = "d_22202_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;This.inv_sort.of_SetColumnHeader(false)
end event

type dw_print from w_com010_d`dw_print within w_22202_d
integer width = 786
integer height = 360
string dataobject = "d_22202_r01"
end type

