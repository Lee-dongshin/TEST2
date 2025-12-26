$PBExportHeader$w_42021_e.srw
$PBExportComments$물류부자재 코드관리
forward
global type w_42021_e from w_com010_e
end type
end forward

global type w_42021_e from w_com010_e
integer width = 3675
integer height = 2232
end type
global w_42021_e w_42021_e

type variables
String is_brand 
DatawindowChild  idw_brand
end variables

on w_42021_e.create
call super::create
end on

on w_42021_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.20                                                  */	
/* 수정일      : 2002.05.20                                                  */
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

dw_body.Modify("t_mat_cd1.Text = '" + is_brand + "2XXZ'")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.05.20                                                  */	
/* 수정일      : 2002.05.20                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.05.20                                                  */	
/* 수정일      : 2002.05.20                                                  */
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
      dw_body.Setitem(i, "mat_type",   '9')
      dw_body.Setitem(i, "brand",      is_brand)
      dw_body.Setitem(i, "mat_year",   '0000')
      dw_body.Setitem(i, "mat_season", 'X')
      dw_body.Setitem(i, "mat_item",   'Z')
      dw_body.Setitem(i, "mat_gubn",   '2')
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42021_e","0")
end event

type cb_close from w_com010_e`cb_close within w_42021_e
end type

type cb_delete from w_com010_e`cb_delete within w_42021_e
end type

type cb_insert from w_com010_e`cb_insert within w_42021_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_42021_e
end type

type cb_update from w_com010_e`cb_update within w_42021_e
end type

type cb_print from w_com010_e`cb_print within w_42021_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_42021_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_42021_e
end type

type cb_excel from w_com010_e`cb_excel within w_42021_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_42021_e
integer y = 176
integer height = 168
string dataobject = "d_42021_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

type ln_1 from w_com010_e`ln_1 within w_42021_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_e`ln_2 within w_42021_e
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_e`dw_body within w_42021_e
integer y = 376
integer height = 1624
string dataobject = "d_42021_d01"
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("mat_div", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('429')

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.05.20                                                  */	
/* 수정일      : 2002.05.20                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "mat_cd2" 
    IF LenA(data) <> 5 THEN RETURN 1
	 This.Setitem(row, "mat_cd",   is_brand + '2XXZ' + data)
	 This.Setitem(row, "mat_div",  LeftA(data, 2))
	 This.Setitem(row, "mat_chno", RightA(data, 1))
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_42021_e
end type

