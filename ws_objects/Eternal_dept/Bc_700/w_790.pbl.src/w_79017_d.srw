$PBExportHeader$w_79017_d.srw
$PBExportComments$클레임 현황
forward
global type w_79017_d from w_com010_d
end type
end forward

global type w_79017_d from w_com010_d
end type
global w_79017_d w_79017_d

type variables
Datawindowchild idw_brand, idw_claim_fg, idw_year, idw_season
String is_brand, is_claim_fg, is_fr_ymd, is_to_ymd, is_rtrn_gubn, is_season, is_year, is_claim_ymd
end variables

on w_79017_d.create
call super::create
end on

on w_79017_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_keycheck;call super::ue_keycheck;
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

is_claim_fg = dw_head.GetItemString(1, "claim_fg")
if IsNull(is_claim_fg) or Trim(is_claim_fg) = "" then
   MessageBox(ls_title,"클레임구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("claim_fg")
   return false
end if

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_rtrn_gubn = dw_head.GetItemString(1, "rtrn_gubn")
if IsNull(is_rtrn_gubn) or Trim(is_rtrn_gubn) = "" then
   MessageBox(ls_title,"반품구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rtrn_gubn")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_claim_ymd = dw_head.GetItemString(1, "claim_ymd")

return true

end event

event ue_retrieve;call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_claim_fg, is_fr_ymd, is_to_ymd, is_rtrn_gubn, is_year, is_season, is_claim_ymd)
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

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_rtrn_gubn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

if is_rtrn_gubn = "a"  then 
	ls_rtrn_gubn = "전체"
else
	ls_rtrn_gubn = "입력완료"
end if	
 

ls_modify =	"t_pg_id.Text     = '" + is_pgm_id +    "'" + &
            "t_user_id.Text   = '" + gs_user_id +   "'" + &
            "t_datetime.Text  = '" + ls_datetime +  "'" + &
            "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_yymmdd.Text    = '" + String(is_fr_ymd + is_to_ymd, '@@@@/@@/@@ ~~ @@@@/@@/@@') + "'" + &
				"t_claim_fg.text  = '" + idw_claim_fg.GetItemString(idw_claim_fg.GetRow(), "inter_display") + "'" + &
            "t_rtrn_gubn.Text = '" + ls_rtrn_gubn +  "'" 
				
dw_print.Modify(ls_modify)
dw_print.object.t_claim_ymd.text = is_claim_ymd




end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

type cb_close from w_com010_d`cb_close within w_79017_d
end type

type cb_delete from w_com010_d`cb_delete within w_79017_d
end type

type cb_insert from w_com010_d`cb_insert within w_79017_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_79017_d
end type

type cb_update from w_com010_d`cb_update within w_79017_d
end type

type cb_print from w_com010_d`cb_print within w_79017_d
end type

type cb_preview from w_com010_d`cb_preview within w_79017_d
end type

type gb_button from w_com010_d`gb_button within w_79017_d
end type

type cb_excel from w_com010_d`cb_excel within w_79017_d
end type

type dw_head from w_com010_d`dw_head within w_79017_d
integer y = 164
integer width = 3547
integer height = 196
string dataobject = "d_79017_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')



This.GetChild("claim_fg", idw_claim_fg)
idw_claim_fg.SetTransObject(SQLCA)
idw_claim_fg.Retrieve('79a')
idw_claim_fg.InsertRow(1)
idw_claim_fg.SetItem(1, "inter_cd", '%')
idw_claim_fg.SetItem(1, "inter_nm", '전체')


This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_nm", '전체')


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

type ln_1 from w_com010_d`ln_1 within w_79017_d
integer beginy = 376
integer endy = 376
end type

type ln_2 from w_com010_d`ln_2 within w_79017_d
integer beginy = 380
integer endy = 380
end type

type dw_body from w_com010_d`dw_body within w_79017_d
integer y = 392
integer height = 1648
string dataobject = "d_79017_d01"
end type

type dw_print from w_com010_d`dw_print within w_79017_d
string dataobject = "d_79017_r01"
end type

