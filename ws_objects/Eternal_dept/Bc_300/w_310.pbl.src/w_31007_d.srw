$PBExportHeader$w_31007_d.srw
$PBExportComments$STYLE별 생산처 투입 현황
forward
global type w_31007_d from w_com010_d
end type
end forward

global type w_31007_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_31007_d w_31007_d

type variables
DataWindowChild idw_brand, idw_season, idw_out_seq, idw_make_type, idw_country_cd

String is_brand, is_year, is_season, is_out_seq, is_dlvy_fr, is_dlvy_to, is_make_type
string is_fr_req_ymd, is_to_req_ymd, is_main_gubn, is_country_cd
end variables

on w_31007_d.create
call super::create
end on

on w_31007_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.14                                                  */	
/* 수정일      : 2001.12.14                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_out_seq, is_dlvy_fr, is_dlvy_to, is_make_type, is_fr_req_ymd, is_to_req_ymd, is_main_gubn, is_country_cd)

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
/* 작성일      : 2001.12.14                                                  */	
/* 수정일      : 2001.12.14                                                  */
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
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
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

is_out_seq = dw_head.GetItemString(1, "out_seq")
if IsNull(is_out_seq) or Trim(is_out_seq) = "" then
   MessageBox(ls_title,"출고 차순를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_seq")
   return false
end if


is_dlvy_fr = dw_head.GetItemString(1, "dlvy_fr")
is_dlvy_to = dw_head.GetItemString(1, "dlvy_to")
is_make_type = dw_head.GetItemString(1, "make_type")
is_fr_req_ymd = dw_head.GetItemString(1, "fr_req_ymd")
is_to_req_ymd = dw_head.GetItemString(1, "to_req_ymd")


is_main_gubn = dw_head.GetItemString(1, "main_gubn")
is_country_cd = dw_head.GetItemString(1, "country_cd")


return true

end event

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
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
            "t_year.Text = '" + is_year + "'" + &				
            "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_make_type.Text = '" + idw_make_type.GetItemString(idw_make_type.GetRow(), "inter_display") + "'" + &				
            "t_out_seq.Text = '" + idw_out_seq.GetItemString(idw_out_seq.GetRow(), "inter_display") + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_dlvy_fr.text = is_dlvy_fr
dw_print.object.t_dlvy_to.text = is_dlvy_to
dw_print.object.t_fr_req_ymd.text = is_fr_req_ymd
dw_print.object.t_to_req_ymd.text = is_to_req_ymd
choose case is_main_gubn
	case "A"
		dw_print.object.t_main_gubn.text  = "전체"
	case "M"
		dw_print.object.t_main_gubn.text  = "메인"
	case "R"
		dw_print.object.t_main_gubn.text  = "리오다"
end choose



end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_31007_d","0")
end event

type cb_close from w_com010_d`cb_close within w_31007_d
end type

type cb_delete from w_com010_d`cb_delete within w_31007_d
end type

type cb_insert from w_com010_d`cb_insert within w_31007_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_31007_d
end type

type cb_update from w_com010_d`cb_update within w_31007_d
end type

type cb_print from w_com010_d`cb_print within w_31007_d
end type

type cb_preview from w_com010_d`cb_preview within w_31007_d
end type

type gb_button from w_com010_d`gb_button within w_31007_d
end type

type cb_excel from w_com010_d`cb_excel within w_31007_d
end type

type dw_head from w_com010_d`dw_head within w_31007_d
integer y = 164
integer width = 4078
integer height = 232
string dataobject = "d_31007_h01"
end type

event dw_head::constructor;datawindowchild ldw_child

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003',gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')
idw_country_cd.InsertRow(1)
idw_country_cd.SetItem(1, "inter_cd", '%')
idw_country_cd.SetItem(1, "inter_nm", '전체')


This.GetChild("out_seq", idw_out_seq)
idw_out_seq.SetTransObject(SQLCA)
idw_out_seq.Retrieve('010')
idw_out_seq.InsertRow(1)
idw_out_seq.SetItem(1, "inter_cd", '%')
idw_out_seq.SetItem(1, "inter_nm", '전체')


This.GetChild("make_type", idw_make_type)
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.InsertRow(1)
idw_make_type.SetItem(1, "inter_cd", '%')
idw_make_type.SetItem(1, "inter_nm", '전체')
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

type ln_1 from w_com010_d`ln_1 within w_31007_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_d`ln_2 within w_31007_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_31007_d
integer y = 436
integer height = 1604
string dataobject = "d_31007_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_31007_d
string dataobject = "d_31007_r01"
end type

