$PBExportHeader$w_42017_d.srw
$PBExportComments$기타출고명세서
forward
global type w_42017_d from w_com010_d
end type
end forward

global type w_42017_d from w_com010_d
string title = "기타출고명세서"
end type
global w_42017_d w_42017_d

type variables
DataWindowChild idw_brand, idw_house_cd, idw_make_type	

String is_brand, is_house_cd, is_fr_yymmdd, is_to_yymmdd, is_make_type, is_make_10, is_make_20, is_make_30, is_make_40, is_make_50 , is_out_no
end variables

on w_42017_d.create
call super::create
end on

on w_42017_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "fr_yymmdd", ld_datetime)
dw_head.SetItem(1, "to_yymmdd", ld_datetime)
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.02.26                                                  */	
/* 수정일      : 2002.02.26                                                  */
/*===========================================================================*/
IF TRIGGER EVENT ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_house_cd, is_fr_yymmdd, is_to_yymmdd, 'C', is_make_10, is_make_20, is_make_30, is_make_40, is_make_50, is_out_no)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

THIS.TRIGGER EVENT ue_button(1, il_rows)
THIS.TRIGGER EVENT ue_msg(1, il_rows)
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.02.26                                                  */	
/* 수정일      : 2002.02.26                                                  */
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
IF IsNull(is_brand) OR Trim(is_brand) = "" THEN
   MessageBox(ls_title,"브랜드를 선택하십시요 !!!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
//elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
elseif (gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'E' or is_brand = 'M' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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


is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고를 입력하십시요 !!!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if

is_fr_yymmdd = String(dw_head.GetItemDateTime(1, "fr_yymmdd"), 'yyyymmdd')
IF IsNull(is_fr_yymmdd) OR Trim(is_fr_yymmdd) = "" THEN
   MessageBox(ls_title,"출고일자[From]를 입력하십시요 !!!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymmdd")
   RETURN FALSE
END IF

is_to_yymmdd = String(dw_head.GetItemDateTime(1, "to_yymmdd"), 'yyyymmdd')
IF IsNull(is_to_yymmdd) OR Trim(is_to_yymmdd) = "" THEN
   MessageBox(ls_title,"출고일자[To]를 입력하십시요 !!!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   RETURN FALSE
END IF

is_make_type = dw_head.GetItemString(1, "make_type")
IF IsNull(is_make_type) OR Trim(is_make_type) = "" THEN
   MessageBox(ls_title,"생산형태를 선택하십시요 !!!")
   dw_head.SetFocus()
   dw_head.SetColumn("make_type")
   RETURN FALSE
END IF

is_make_10 = dw_head.GetItemString(1, "make_10")
is_make_20 = dw_head.GetItemString(1, "make_20")
is_make_30 = dw_head.GetItemString(1, "make_30")
is_make_40 = dw_head.GetItemString(1, "make_40")
is_make_50 = dw_head.GetItemString(1, "make_50")

is_out_no = dw_head.GetItemString(1, "out_no")
IF IsNull(is_out_no) OR Trim(is_out_no) = "" THEN
 is_out_no = "%"
END IF

RETURN TRUE
end event

event ue_title;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.02.26                                                  */	
/* 수정일      : 2002.02.26                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_datetime, ls_modify

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
is_fr_yymmdd = String(dw_head.GetItemDateTime(1, "fr_yymmdd"), 'yyyy/mm/dd')
is_to_yymmdd = String(dw_head.GetItemDateTime(1, "to_yymmdd"), 'yyyy/mm/dd')

ls_modify =	"t_pg_id.Text     = '" + is_pgm_id    + "'" + &
            "t_user_id.Text   = '" + gs_user_id   + "'" + &
				"t_datetime.Text  = '" + ls_datetime  + "'" + & 
            "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display")      + "'" + &
				"t_house_cd.Text  = '" + idw_house_cd.GetItemString(idw_house_cd.GetRow(), "shop_display") + "'" + &
            "t_fr_yymmdd.Text = '" + is_fr_yymmdd + "'" + &            
            "t_to_yymmdd.Text = '" + is_to_yymmdd + "'"            				

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42017_d","0")
end event

type cb_close from w_com010_d`cb_close within w_42017_d
end type

type cb_delete from w_com010_d`cb_delete within w_42017_d
end type

type cb_insert from w_com010_d`cb_insert within w_42017_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42017_d
end type

type cb_update from w_com010_d`cb_update within w_42017_d
end type

type cb_print from w_com010_d`cb_print within w_42017_d
end type

type cb_preview from w_com010_d`cb_preview within w_42017_d
end type

type gb_button from w_com010_d`gb_button within w_42017_d
end type

type cb_excel from w_com010_d`cb_excel within w_42017_d
end type

type dw_head from w_com010_d`dw_head within w_42017_d
integer y = 192
integer height = 228
string dataobject = "d_42017_h01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("house_cd", idw_house_cd) 
idw_house_cd.SetTransObject(sqlca)
idw_house_cd.Retrieve()

This.GetChild("make_type", idw_make_type) 
idw_make_type.SetTransObject(sqlca)
idw_make_type.Retrieve('030')
idw_make_type.InsertRow(1)
idw_make_type.SetItem(1, "inter_cd", '%')
idw_make_type.SetItem(1, "inter_nm", '전체')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

type ln_1 from w_com010_d`ln_1 within w_42017_d
end type

type ln_2 from w_com010_d`ln_2 within w_42017_d
end type

type dw_body from w_com010_d`dw_body within w_42017_d
integer width = 3570
integer height = 1528
boolean enabled = false
string dataobject = "d_42017_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_42017_d
string dataobject = "d_42017_r01"
end type

