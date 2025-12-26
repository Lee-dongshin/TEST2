$PBExportHeader$w_22013_d.srw
$PBExportComments$부자재 발주-입고 비교현황
forward
global type w_22013_d from w_com010_d
end type
end forward

global type w_22013_d from w_com010_d
end type
global w_22013_d w_22013_d

type variables
string is_brand, is_year, is_season, is_mat_cd, is_s_date, is_e_date, is_mat_sojae, is_ord_origin

datawindowchild idw_brand, idw_season, idw_mat_sojae
end variables

on w_22013_d.create
call super::create
end on

on w_22013_d.destroy
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
is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_mat_sojae = dw_head.GetItemString(1, "mat_sojae")

is_s_date = dw_head.GetItemString(1, "s_date")
is_e_date = dw_head.GetItemString(1, "e_date")

is_mat_cd = dw_head.GetItemString(1, "mat_cd")
is_ord_origin = dw_head.GetItemString(1, "ord_origin")

if IsNull(is_brand) or Trim(is_brand) = "" then
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
elseif ( gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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


if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
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
//	@brand            VARCHAR(1),
//	@mat_year         VARCHAR(4),
//	@mat_season       VARCHAR(1),
//	@mat_sojae        VARCHAR(1),
// @s_date           VARCHAR(8),
// @e_date           VARCHAR(8),
// @ord_origin       VARCHAR(10),
//	@mat_cd		      varchar(10) 

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_mat_sojae,  is_s_date, is_e_date, is_ord_origin, is_mat_cd)
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

dw_head.SetItem(1, "s_date", string(ld_datetime,"yyyymm") + "01")
dw_head.SetItem(1, "e_date", string(ld_datetime,"yyyymmdd"))
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22013_d","0")
end event

type cb_close from w_com010_d`cb_close within w_22013_d
end type

type cb_delete from w_com010_d`cb_delete within w_22013_d
end type

type cb_insert from w_com010_d`cb_insert within w_22013_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_22013_d
end type

type cb_update from w_com010_d`cb_update within w_22013_d
end type

type cb_print from w_com010_d`cb_print within w_22013_d
end type

type cb_preview from w_com010_d`cb_preview within w_22013_d
end type

type gb_button from w_com010_d`gb_button within w_22013_d
end type

type cb_excel from w_com010_d`cb_excel within w_22013_d
end type

type dw_head from w_com010_d`dw_head within w_22013_d
string dataobject = "d_22013_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')

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
idw_mat_sojae.Retrieve("2")
idw_mat_sojae.insertrow(1)
idw_mat_sojae.Setitem(1, "mat_sojae", "%")
idw_mat_sojae.Setitem(1, "mat_sojae_nm", "전체")
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

type ln_1 from w_com010_d`ln_1 within w_22013_d
end type

type ln_2 from w_com010_d`ln_2 within w_22013_d
end type

type dw_body from w_com010_d`dw_body within w_22013_d
string dataobject = "d_22013_d01"
end type

type dw_print from w_com010_d`dw_print within w_22013_d
string dataobject = "d_22013_r01"
end type

