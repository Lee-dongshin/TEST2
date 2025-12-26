$PBExportHeader$w_55037_d.srw
$PBExportComments$상품진행현황(상품속성)
forward
global type w_55037_d from w_com010_d
end type
end forward

global type w_55037_d from w_com010_d
end type
global w_55037_d w_55037_d

type variables
string is_view_opt, is_brand, is_frm_ymd, is_to_ymd, is_year, is_season, is_run_season, is_style_opt, is_style_no,is_plan_month
DataWindowChild idw_brand, idw_year, idw_season, idw_run_season
end variables

on w_55037_d.create
call super::create
end on

on w_55037_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55037_d","0")
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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

is_frm_ymd = dw_head.GetItemString(1, "frm_ymd")
IF IsNull(is_frm_ymd) OR is_frm_ymd = "" THEN
	MessageBox(ls_title,"기준일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("is_frm_ymd")
	RETURN FALSE
END IF

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
IF IsNull(is_to_ymd) OR is_to_ymd = "" THEN
	MessageBox(ls_title,"기준일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("is_to_ymd")
	RETURN FALSE
END IF

is_brand = Trim(dw_head.GetItemString(1, "brand"))
IF IsNull(is_brand) OR is_brand = "" THEN
	MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("brand")
	RETURN FALSE
END IF

is_year = Trim(dw_head.GetItemString(1, "year"))
IF IsNull(is_year) OR is_year = "" THEN
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
	RETURN FALSE
END IF

is_season = Trim(dw_head.GetItemString(1, "season"))
IF IsNull(is_season) OR is_season = "" THEN
   MessageBox(ls_title,"기획 시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
	RETURN FALSE
END IF

is_run_season = Trim(dw_head.GetItemString(1, "run_season"))
IF IsNull(is_run_season) OR is_run_season = "" THEN
   MessageBox(ls_title,"운영 시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("run_season")
	RETURN FALSE
END IF


is_view_opt = Trim(dw_head.GetItemString(1, "view_opt"))
IF IsNull(is_view_opt) OR is_view_opt = "" then
   MessageBox(ls_title,"조회 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("view_opt")
	RETURN FALSE
END IF

is_style_opt = Trim(dw_head.GetItemString(1, "style_opt"))
IF IsNull(is_style_opt) OR is_style_opt = "" then
   MessageBox(ls_title,"차수 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_opt")
	RETURN FALSE
END IF



is_style_no = "%"	




RETURN TRUE

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


//	@fr_ymd			VARCHAR(8),
//	@ps_yymmdd		VARCHAR(8),
//	@ps_brand		VARCHAR(1),
//	@ps_year		VARCHAR(10),
//	@ps_season		VARCHAR(10),
//	@ps_run_season		VARCHAR(10),
//	@ps_plan_month		varchar(02),
//
//	@ps_chno_gubun		VARCHAR(1),
//	@ps_style_no		VARCHAR(09),
//	@ps_view_opt		varchar(01)	--- s: 스타일 c: 칼라별 A: 칼라사이즈
//

il_rows = dw_body.retrieve(is_frm_ymd, is_to_ymd, is_brand, is_year, is_season, is_run_season, is_plan_month, is_style_opt, is_style_no, is_view_opt )

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

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_ymd" ,string(ld_datetime,"yyyymmdd"))
end event

type cb_close from w_com010_d`cb_close within w_55037_d
end type

type cb_delete from w_com010_d`cb_delete within w_55037_d
end type

type cb_insert from w_com010_d`cb_insert within w_55037_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55037_d
end type

type cb_update from w_com010_d`cb_update within w_55037_d
end type

type cb_print from w_com010_d`cb_print within w_55037_d
end type

type cb_preview from w_com010_d`cb_preview within w_55037_d
end type

type gb_button from w_com010_d`gb_button within w_55037_d
end type

type cb_excel from w_com010_d`cb_excel within w_55037_d
end type

type dw_head from w_com010_d`dw_head within w_55037_d
integer y = 164
integer height = 320
string dataobject = "d_55037_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')



THIS.GetChild("run_season", idw_run_season)
idw_run_season.SetTransObject(SQLCA)
idw_run_season.Retrieve('003', gs_brand, '%')
idw_run_season.InsertRow(1)
idw_run_season.SetItem(1, "inter_cd", '%')
idw_run_season.SetItem(1, "inter_nm", '전체')


THIS.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_nm", '전체')



end event

type ln_1 from w_com010_d`ln_1 within w_55037_d
integer beginy = 512
integer endy = 512
end type

type ln_2 from w_com010_d`ln_2 within w_55037_d
integer beginy = 516
integer endy = 516
end type

type dw_body from w_com010_d`dw_body within w_55037_d
integer x = 0
integer y = 528
integer width = 3570
integer height = 1472
string dataobject = "d_55037_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_55037_d
end type

