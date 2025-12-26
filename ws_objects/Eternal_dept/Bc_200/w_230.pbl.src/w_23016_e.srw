$PBExportHeader$w_23016_e.srw
$PBExportComments$제품클레임 전표수정
forward
global type w_23016_e from w_com010_e
end type
end forward

global type w_23016_e from w_com010_e
integer width = 3675
integer height = 2276
end type
global w_23016_e w_23016_e

type variables
string is_brand, is_yymmdd
datawindowchild idw_brand

end variables

on w_23016_e.create
call super::create
end on

on w_23016_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"yymmdd",string(ld_datetime,"yyyymmdd"))
end if


end event

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
is_yymmdd = dw_head.GetItemString(1, "yymmdd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd)
IF il_rows > 0 THEN
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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_brand.text = is_yymmdd
dw_print.object.t_yymmdd.text = is_brand + ' - ' + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
end event

type cb_close from w_com010_e`cb_close within w_23016_e
end type

type cb_delete from w_com010_e`cb_delete within w_23016_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_23016_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_23016_e
end type

type cb_update from w_com010_e`cb_update within w_23016_e
end type

type cb_print from w_com010_e`cb_print within w_23016_e
end type

type cb_preview from w_com010_e`cb_preview within w_23016_e
end type

type gb_button from w_com010_e`gb_button within w_23016_e
end type

type cb_excel from w_com010_e`cb_excel within w_23016_e
end type

type dw_head from w_com010_e`dw_head within w_23016_e
integer height = 152
string dataobject = "d_23016_h01"
end type

event dw_head::constructor;call super::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')

idw_brand.insertrow(1)
idw_brand.setitem(1,'inter_cd', '%')
idw_brand.setitem(1,'inter_nm', '전체')




end event

type ln_1 from w_com010_e`ln_1 within w_23016_e
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com010_e`ln_2 within w_23016_e
integer beginy = 352
integer endy = 352
end type

type dw_body from w_com010_e`dw_body within w_23016_e
integer y = 364
integer height = 1676
string dataobject = "d_23016_d01"
end type

type dw_print from w_com010_e`dw_print within w_23016_e
string dataobject = "d_23016_r01"
end type

