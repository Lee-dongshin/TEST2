$PBExportHeader$w_cu303_e.srw
$PBExportComments$메시지관리[수신메시지관리]
forward
global type w_cu303_e from w_com020_e
end type
end forward

global type w_cu303_e from w_com020_e
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
end type
global w_cu303_e w_cu303_e

type variables
String is_confirm_yn
String is_send_id, is_recv_id = "000000"
integer ii_mes_seq
end variables

on w_cu303_e.create
call super::create
end on

on w_cu303_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/
datetime ld_datetime

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF



end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
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

is_confirm_yn = dw_head.GetItemString(1, "confirm_yn")
IF is_confirm_yn = "" OR isnull(is_confirm_yn) THEN
	is_confirm_yn = ""
END IF

return true

end event

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

//datetime ld_datetime
//string ls_modify, ls_datetime
//
//IF gf_sysdate(ld_datetime) = FALSE THEN
//   ld_datetime = DateTime(Today(), Now())
//END IF
//
//ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
//
//ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
//             "t_user_id.Text = '" + gs_user_id + "'" + &
//             "t_datetime.Text = '" + ls_datetime + "'"
//
//dw_print.Modify(ls_modify)
//

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
il_rows = dw_list.retrieve(gs_shop_cd, is_confirm_yn)

dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

//This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen;call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/
dw_body.InsertRow(0)
end event

event pfc_postopen();call super::pfc_postopen;This.Trigger Event ue_retrieve()
end event

type cb_close from w_com020_e`cb_close within w_cu303_e
integer taborder = 160
end type

type cb_delete from w_com020_e`cb_delete within w_cu303_e
boolean visible = false
integer x = 2135
integer y = 48
integer taborder = 110
end type

type cb_insert from w_com020_e`cb_insert within w_cu303_e
boolean visible = false
integer x = 1792
integer y = 48
integer taborder = 100
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_cu303_e
integer x = 2167
integer taborder = 60
end type

type cb_update from w_com020_e`cb_update within w_cu303_e
boolean visible = false
integer taborder = 150
end type

type cb_print from w_com020_e`cb_print within w_cu303_e
boolean visible = false
integer taborder = 120
end type

type cb_preview from w_com020_e`cb_preview within w_cu303_e
boolean visible = false
integer taborder = 130
end type

type gb_button from w_com020_e`gb_button within w_cu303_e
end type

type dw_head from w_com020_e`dw_head within w_cu303_e
integer width = 2784
integer height = 160
integer taborder = 50
string dataobject = "d_cu303_h01"
end type

event dw_head::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/

end event

type ln_1 from w_com020_e`ln_1 within w_cu303_e
integer beginy = 332
integer endx = 2926
integer endy = 332
end type

type ln_2 from w_com020_e`ln_2 within w_cu303_e
integer beginy = 336
integer endx = 2921
integer endy = 336
end type

type dw_list from w_com020_e`dw_list within w_cu303_e
integer y = 344
integer width = 823
integer height = 1472
integer taborder = 70
string title = "매장"
string dataobject = "d_cu303_d01"
boolean hscrollbar = true
end type

event dw_list::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
addToolTipItem(handle(this), "☞ 메시지 선택")
end event

event dw_list::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.01                                                  */	
/* 수정일      : 2002.02.01                                                  */
/*===========================================================================*/
String ls_confirm_yn, ls_yymmdd
datetime ld_datetime

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

IF row > 0 THEN
   ls_yymmdd      = this.GetItemString(row,'yymmdd')
   is_send_id     = this.GetItemString(row,'send_id')
   ii_mes_seq     = this.GetItemNumber(row,'mes_seq')
   ls_confirm_yn 	= this.GetItemString(row,'confirm_yn')
   dw_body.Retrieve(ls_yymmdd, is_send_id, ii_mes_seq)
   this.selectRow(0, false)
   this.setRow(row)
   this.selectRow(row, true)
   IF isnull(ls_confirm_yn) OR ls_confirm_yn = 'N' THEN
      UPDATE TB_57011_H
   	   SET confirm_yn = 'Y', 
			    confirm_dt = :ld_datetime, 
				 mod_dt     = :ld_datetime, 
				 mod_id     = :gs_shop_cd 
	    WHERE yymmdd		= :ls_yymmdd
	      AND send_id	   = :is_send_id
	      AND mes_seq	   = :ii_mes_seq
	      AND recv_id	   = :gs_shop_cd;
	   Commit USING SQLCA;
	   dw_list.SetItem(row,'confirm_yn','Y')
	   dw_list.SetItem(row,'confirm_dt',ld_datetime)
   END IF
END IF


end event

type dw_body from w_com020_e`dw_body within w_cu303_e
integer x = 837
integer y = 344
integer width = 2057
integer height = 1468
integer taborder = 80
string title = "메시지 내용"
string dataobject = "d_cu303_d02"
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event dw_body::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/
addToolTipItem(handle(this), "☞ 메시지 내용")
end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		IF dw_body.GetColumnName() <> "mes" THEN
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		END IF
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
END CHOOSE

Return 0
end event

type st_1 from w_com020_e`st_1 within w_cu303_e
integer x = 818
integer y = 344
integer height = 1500
end type

type dw_print from w_com020_e`dw_print within w_cu303_e
end type

