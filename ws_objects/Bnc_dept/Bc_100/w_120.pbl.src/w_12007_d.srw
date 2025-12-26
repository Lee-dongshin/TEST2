$PBExportHeader$w_12007_d.srw
$PBExportComments$컨벤션 등록현황
forward
global type w_12007_d from w_com010_d
end type
end forward

global type w_12007_d from w_com010_d
end type
global w_12007_d w_12007_d

type variables
String is_brand, is_year,  is_season,  is_item
DataWindowChild idw_brand, idw_season, idw_item
end variables

on w_12007_d.create
call super::create
end on

on w_12007_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
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


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"품종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

return true
end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_item)
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
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
datetime ld_datetime
String ls_modify, ls_datetime
String ls_brand,  ls_season,  ls_item 

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
ls_brand    =  "브랜드 : " + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") 
ls_season   =  "시  즌 : " + is_year + "년도 " + &
               idw_season.GetitemString(idw_season.GetRow(), "inter_display")  
ls_item     =  "품  종 : " + idw_item.GetitemString(idw_item.GetRow(), "item_display") 

ls_modify =	"t_pg_id.Text = '"    + is_pgm_id + "'" + &
            "t_user_id.Text = '"  + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '"    + ls_brand + "'" + &
            "t_season.Text = '"   + ls_season + "'" + &
            "t_item.Text = '"     + ls_item + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12007_d","0")
end event

type cb_close from w_com010_d`cb_close within w_12007_d
end type

type cb_delete from w_com010_d`cb_delete within w_12007_d
end type

type cb_insert from w_com010_d`cb_insert within w_12007_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_12007_d
end type

type cb_update from w_com010_d`cb_update within w_12007_d
end type

type cb_print from w_com010_d`cb_print within w_12007_d
end type

type cb_preview from w_com010_d`cb_preview within w_12007_d
end type

type gb_button from w_com010_d`gb_button within w_12007_d
end type

type cb_excel from w_com010_d`cb_excel within w_12007_d
end type

type dw_head from w_com010_d`dw_head within w_12007_d
integer height = 164
string dataobject = "d_12007_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTRansObject(SQLCA)
idw_season.Retrieve('003')

This.GetChild("item", idw_item)
idw_item.SetTRansObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.insertrow(1)
idw_item.Setitem(1, "item", "%")
idw_item.Setitem(1, "item_nm", "전체")


end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name


	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
//
//
//	This.GetChild("sojae", idw_sojae)
//	idw_sojae.SetTransObject(SQLCA)
//	idw_sojae.Retrieve('%', data)
//	idw_sojae.insertrow(1)
//	idw_sojae.Setitem(1, "sojae", "%")
//	idw_sojae.Setitem(1, "sojae_nm", "전체")
//	
	This.GetChild("item", idw_item)
	idw_item.SetTransObject(SQLCA)
	idw_item.Retrieve(data)
	idw_item.insertrow(1)
	idw_item.Setitem(1, "item", "%")
	idw_item.Setitem(1, "item_nm", "전체")
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_12007_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_12007_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_12007_d
integer y = 376
integer height = 1664
string dataobject = "d_12007_d01"
end type

type dw_print from w_com010_d`dw_print within w_12007_d
string dataobject = "d_12007_r01"
end type

