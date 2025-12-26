$PBExportHeader$w_58026_e.srw
$PBExportComments$원자재수출 팩킹리스트
forward
global type w_58026_e from w_com010_e
end type
end forward

global type w_58026_e from w_com010_e
integer width = 3675
integer height = 2280
end type
global w_58026_e w_58026_e

type variables
string is_fr_yymmdd, is_to_yymmdd, is_cust_cd, is_style, is_mat_cd

end variables

on w_58026_e.create
call super::create
end on

on w_58026_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : 지우정보      															  */	
/* 작성일      : 2001.05.29																  */	
/* 수정일      : 2001.05.29																  */
/*===========================================================================*/
datetime id_datetime

IF gf_cdate(id_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(id_datetime,"yyyymmdd"))
	dw_head.setitem(1,"to_yymmdd",string(id_datetime,"yyyymmdd"))
end if
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 지우정보(권 진택)                                           */	
/* 작성일      : 2000.09.07                                                  */	
/* 수성일      : 2000.09.07                                                  */
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

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")

if IsNull(is_fr_yymmdd) or Trim(is_fr_yymmdd) = "" then
   MessageBox(ls_title,"조회기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
   MessageBox(ls_title,"조회기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_cust_cd   = dw_head.GetItemString(1, "cust_cd")
if IsNull(is_cust_cd) or LenA(Trim(is_cust_cd)) <> 6 then
   MessageBox(ls_title,"거래처를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("cust_cd")
   return false
end if

is_style   = dw_head.GetItemString(1, "style")
is_mat_cd  = dw_head.GetItemString(1, "mat_cd")

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

il_rows = dw_body.retrieve(is_fr_yymmdd, is_to_yymmdd, is_cust_cd, is_style, is_mat_cd)
IF il_rows > 0 THEN
	for i = 1 to il_rows
		ls_flag = dw_body.getitemstring(i,"flag")
		if ls_flag = "New" then
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
dw_print.object.t_yymmdd.text = '조회기간: '+is_fr_yymmdd+' - '+is_to_yymmdd
dw_print.object.t_cust_cd.text = '거래처: '+is_cust_cd


end event

type cb_close from w_com010_e`cb_close within w_58026_e
end type

type cb_delete from w_com010_e`cb_delete within w_58026_e
end type

type cb_insert from w_com010_e`cb_insert within w_58026_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_58026_e
end type

type cb_update from w_com010_e`cb_update within w_58026_e
end type

type cb_print from w_com010_e`cb_print within w_58026_e
end type

type cb_preview from w_com010_e`cb_preview within w_58026_e
end type

type gb_button from w_com010_e`gb_button within w_58026_e
end type

type cb_excel from w_com010_e`cb_excel within w_58026_e
end type

type dw_head from w_com010_e`dw_head within w_58026_e
integer y = 168
integer height = 140
string dataobject = "d_58026_h01"
end type

event dw_head::itemchanged;call super::itemchanged;string ls_cust_nm
choose case dwo.name 
	case "cust_cd"
		this.setitem(1,"cust_nm","")
		select dbo.sf_cust_nm(:data,'s') into :ls_cust_nm from dual;
		this.setitem(1,"cust_nm",ls_cust_nm)
end choose
end event

type ln_1 from w_com010_e`ln_1 within w_58026_e
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_e`ln_2 within w_58026_e
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_e`dw_body within w_58026_e
integer y = 348
integer height = 1692
string dataobject = "d_58026_d01"
end type

type dw_print from w_com010_e`dw_print within w_58026_e
string dataobject = "d_58026_r01"
end type

