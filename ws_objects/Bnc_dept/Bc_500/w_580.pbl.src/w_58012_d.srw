$PBExportHeader$w_58012_d.srw
$PBExportComments$수입내역(임가공비)월별조회
forward
global type w_58012_d from w_com010_d
end type
end forward

global type w_58012_d from w_com010_d
end type
global w_58012_d w_58012_d

type variables
string is_brand, is_yymm, is_year, is_season
datawindowchild idw_brand, idw_year, idw_season
end variables

on w_58012_d.create
call super::create
end on

on w_58012_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"yymm",string(ld_datetime,"yyyy"))
end if


end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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

is_brand    = dw_head.GetItemString(1, "brand")
is_yymm     = MidA(dw_head.GetItemString(1, "yymm"),1,4)
is_year     = dw_head.GetItemString(1, "year")
is_season   = dw_head.GetItemString(1, "season")

if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN



il_rows = dw_body.retrieve(is_brand, is_yymm, is_year, is_season)
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
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_brand, ls_yymm, ls_year, ls_season

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_brand = idw_brand.getitemstring(idw_brand.getrow(),"inter_display")
ls_year = idw_year.getitemstring(idw_year.getrow(),"inter_display")
ls_season = idw_season.getitemstring(idw_season.getrow(),"inter_display")
ls_yymm = dw_head.getitemstring(1,"yymm")

if isnull(ls_brand) then  ls_brand = ' '
if isnull(ls_year) then  ls_year = ' '
if isnull(ls_season) then  ls_season = ' '
if isnull(ls_yymm) then  ls_yymm = ' '


ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
             "t_brand.Text = '" + ls_brand + "'" + &
             "t_year.Text = '" + ls_year + "'" + &
             "t_season.Text = '" + ls_season + "'" + &
             "t_yymm.Text = '" + ls_yymm + "'"
				 
dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_58012_d","0")
end event

type cb_close from w_com010_d`cb_close within w_58012_d
end type

type cb_delete from w_com010_d`cb_delete within w_58012_d
end type

type cb_insert from w_com010_d`cb_insert within w_58012_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_58012_d
end type

type cb_update from w_com010_d`cb_update within w_58012_d
end type

type cb_print from w_com010_d`cb_print within w_58012_d
end type

type cb_preview from w_com010_d`cb_preview within w_58012_d
end type

type gb_button from w_com010_d`gb_button within w_58012_d
end type

type cb_excel from w_com010_d`cb_excel within w_58012_d
end type

type dw_head from w_com010_d`dw_head within w_58012_d
integer y = 184
integer height = 132
string dataobject = "d_58012_h01"
end type

event dw_head::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1,"inter_cd", '%')
idw_brand.SetItem(1,"inter_nm",'전체')


this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1,"inter_cd", '%')
idw_season.SetItem(1,"inter_nm",'전체')


end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
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

type ln_1 from w_com010_d`ln_1 within w_58012_d
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_d`ln_2 within w_58012_d
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_d`dw_body within w_58012_d
integer y = 336
integer width = 3593
integer height = 1680
string dataobject = "d_58012_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_58012_d
integer x = 667
integer y = 484
string dataobject = "d_58012_r01"
end type

