$PBExportHeader$w_11092_e.srw
$PBExportComments$출고차순별 투입계획
forward
global type w_11092_e from w_com010_e
end type
end forward

global type w_11092_e from w_com010_e
end type
global w_11092_e w_11092_e

type variables
datawindowchild idw_brand, idw_season
string is_brand, is_year, is_season
end variables

on w_11092_e.create
call super::create
end on

on w_11092_e.destroy
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

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif  ( gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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

is_year   = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
string ls_flag
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season)
IF il_rows > 0 THEN
	for i = 1 to il_rows
		ls_flag = dw_body.getitemstring(i,"flag")
		if ls_flag = 'New' then
			 dw_body.SetItemStatus(i, 0, Primary!, New!)
		end if
	next 
	
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_11092_e","0")
end event

type cb_close from w_com010_e`cb_close within w_11092_e
end type

type cb_delete from w_com010_e`cb_delete within w_11092_e
end type

type cb_insert from w_com010_e`cb_insert within w_11092_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_11092_e
end type

type cb_update from w_com010_e`cb_update within w_11092_e
end type

type cb_print from w_com010_e`cb_print within w_11092_e
end type

type cb_preview from w_com010_e`cb_preview within w_11092_e
end type

type gb_button from w_com010_e`gb_button within w_11092_e
end type

type cb_excel from w_com010_e`cb_excel within w_11092_e
end type

type dw_head from w_com010_e`dw_head within w_11092_e
integer height = 148
string dataobject = "d_11092_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(sqlca)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(sqlca)
idw_season.Retrieve('003')


end event

type ln_1 from w_com010_e`ln_1 within w_11092_e
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_e`ln_2 within w_11092_e
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_e`dw_body within w_11092_e
integer y = 344
integer height = 1696
string dataobject = "d_11092_d01"
end type

type dw_print from w_com010_e`dw_print within w_11092_e
end type

