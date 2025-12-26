$PBExportHeader$w_fiti_102_e.srw
$PBExportComments$시험분석조회
forward
global type w_fiti_102_e from w_com020_e
end type
type cbx_1 from checkbox within w_fiti_102_e
end type
end forward

global type w_fiti_102_e from w_com020_e
string title = "시험분석조회-FITI"
windowstate windowstate = maximized!
cbx_1 cbx_1
end type
global w_fiti_102_e w_fiti_102_e

type variables
string is_brand, is_fr_ymd, is_to_ymd, is_cust_cd
datawindowchild idw_brand

end variables

on w_fiti_102_e.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
end on

on w_fiti_102_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
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

is_brand   = dw_head.GetItemString(1, "brand")
is_fr_ymd  = dw_head.GetItemString(1, "fr_ymd")
is_to_ymd  = dw_head.GetItemString(1, "to_ymd")
is_cust_cd = dw_head.GetItemString(1, "cust_cd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_cust_cd)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_cust_nm

ls_cust_nm = dw_head.getitemstring(1,"cust_nm")

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

//ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
//
//ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
//             "t_user_id.Text = '" + gs_user_id + "'" + &
//             "t_datetime.Text = '" + ls_datetime + "'"
//
//dw_print.Modify(ls_modify)

dw_print.object.t_brand.text = is_brand + ' ' + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_fr_ymd.text = is_fr_ymd
dw_print.object.t_to_ymd.text = is_to_ymd




end event

event ue_preview();if cbx_1.checked then 
	dw_print.dataobject = "d_kola_r12"
else
	dw_print.dataobject = "d_kola_r11"	
end if
dw_print.SetTransObject(SQLCA)


/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

//dw_body.ShareData(dw_print)
il_rows = dw_print.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_cust_cd)
dw_print.inv_printpreview.of_SetZoom()

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
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

event open;call super::open;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"fr_ymd",LeftA(string(ld_datetime,"yyyymmdd"),6) + '01')
	dw_head.setitem(1,"to_ymd",string(ld_datetime,"yyyymmdd"))
end if
end event

type cb_close from w_com020_e`cb_close within w_fiti_102_e
end type

type cb_delete from w_com020_e`cb_delete within w_fiti_102_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_fiti_102_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_fiti_102_e
end type

type cb_update from w_com020_e`cb_update within w_fiti_102_e
end type

type cb_print from w_com020_e`cb_print within w_fiti_102_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_fiti_102_e
end type

type gb_button from w_com020_e`gb_button within w_fiti_102_e
end type

type cb_excel from w_com020_e`cb_excel within w_fiti_102_e
end type

type dw_head from w_com020_e`dw_head within w_fiti_102_e
integer width = 3831
integer height = 152
string dataobject = "d_kola_h11"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')


end event

type ln_1 from w_com020_e`ln_1 within w_fiti_102_e
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com020_e`ln_2 within w_fiti_102_e
integer beginy = 328
integer endy = 328
end type

type dw_list from w_com020_e`dw_list within w_fiti_102_e
integer y = 352
integer width = 827
integer height = 1664
string dataobject = "d_fiti_L11"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

//IF row <= 0 THEN Return
//
//IF ib_changed THEN 
//  	CHOOSE CASE gf_update_yn(Parent.title)
//		CASE 1
//			IF Parent.Trigger Event ue_update() < 1 THEN
//				RETURN 1
//			END IF		
//		CASE 3
//			RETURN 1
//	END CHOOSE
//END IF
//	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_cust_cd = This.GetItemString(row, 'cust_cd') /* DataWindow에 Key 항목을 가져온다 */

if not isnull(is_cust_cd) then 
	il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_cust_cd)
else
	il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, '%')
end if
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_fiti_102_e
integer x = 873
integer y = 352
integer width = 2734
integer height = 1664
string dataobject = "d_fiti_d11"
boolean hscrollbar = true
end type

type st_1 from w_com020_e`st_1 within w_fiti_102_e
integer x = 855
integer y = 352
integer height = 1664
end type

type dw_print from w_com020_e`dw_print within w_fiti_102_e
integer x = 73
integer y = 228
string dataobject = "d_fiti_r11"
end type

type cbx_1 from checkbox within w_fiti_102_e
integer x = 3250
integer y = 204
integer width = 457
integer height = 92
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "업체별출력"
borderstyle borderstyle = stylelowered!
end type

