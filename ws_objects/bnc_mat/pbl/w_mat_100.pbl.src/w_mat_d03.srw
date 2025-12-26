$PBExportHeader$w_mat_d03.srw
$PBExportComments$클레임조회
forward
global type w_mat_d03 from w_com020_d
end type
end forward

global type w_mat_d03 from w_com020_d
integer height = 2264
end type
global w_mat_d03 w_mat_d03

type variables
string is_brand, is_fr_yymmdd, is_to_yymmdd, is_cust_cd, is_claim_ymd, is_claim_no, is_claim_cust

datawindowchild	idw_brand
end variables

on w_mat_d03.create
call super::create
end on

on w_mat_d03.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_23004_d","0")
end event

event open;call super::open;datetime ld_datetime


IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))

end if

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))

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

is_brand = gs_brand
is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_cust_cd   = gs_user_id


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve('%', is_fr_yymmdd, is_to_yymmdd, MidA(gs_user_id,2))
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)													  */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(st_1, "ScaleToBottom")
//inv_resize.of_Register(p_1, "FixedToRight&Bottom")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

il_rows = dw_print.retrieve('%', is_fr_yymmdd, is_to_yymmdd, MidA(is_cust_cd,2), is_claim_ymd, is_claim_no)

//dw_print.Object.DataWindow.Print.Orientation = 1

dw_print.inv_printpreview.of_SetZoom()

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


//dw_print.object.t_brand.text = is_brand + ' ' + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")

dw_print.object.t_fr_yymmdd.text = is_fr_yymmdd
dw_print.object.t_to_yymmdd.text = is_to_yymmdd
//dw_print.object.t_cust_cd.text = is_cust_cd + ' ' + dw_head.getitemstring(1,"cust_nm")
//dw_print.object.dw_2.object.t_claim_cust.text = is_claim_cust
end event

event ue_print();trigger event ue_preview()
end event

type cb_close from w_com020_d`cb_close within w_mat_d03
end type

type cb_delete from w_com020_d`cb_delete within w_mat_d03
end type

type cb_insert from w_com020_d`cb_insert within w_mat_d03
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_mat_d03
end type

type cb_update from w_com020_d`cb_update within w_mat_d03
end type

type cb_print from w_com020_d`cb_print within w_mat_d03
end type

type cb_preview from w_com020_d`cb_preview within w_mat_d03
end type

type gb_button from w_com020_d`gb_button within w_mat_d03
end type

type cb_excel from w_com020_d`cb_excel within w_mat_d03
end type

type dw_head from w_com020_d`dw_head within w_mat_d03
integer height = 148
string dataobject = "d_mat_h21"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name

	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_d`ln_1 within w_mat_d03
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com020_d`ln_2 within w_mat_d03
integer beginy = 356
integer endy = 356
end type

type dw_list from w_com020_d`dw_list within w_mat_d03
integer y = 368
integer width = 3570
integer height = 1468
string dataobject = "d_mat_d21"
boolean hscrollbar = true
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_pic_nm, ls_style, ls_chno
IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_brand      = This.GetItemString(row, 'brand') 
is_claim_ymd  = This.GetItemString(row, 'claim_ymd') /* DataWindow에 Key 항목을 가져온다 */
is_claim_no   = This.GetItemString(row, 'claim_no') 
is_claim_cust = This.GetItemString(row, 'claim_cust') + ' ' + This.GetItemString(row, 'claim_cust_nm')

IF IsNull(is_claim_ymd) THEN return
il_rows = dw_body.retrieve(is_brand, is_claim_ymd, is_claim_no)

if il_rows >0 then
	ls_style = dw_list.getitemstring(row,"style")
	ls_chno = dw_list.getitemstring(row,"chno")
	
//	gf_pic_dir('0', ls_style + ls_chno, ls_pic_nm)
//	p_1.PictureName = ls_pic_nm
   dw_body.SetFocus()
end if

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_mat_d03
integer x = 27
integer y = 1840
integer width = 3570
integer height = 204
string dataobject = "d_mat_d22"
end type

type st_1 from w_com020_d`st_1 within w_mat_d03
boolean visible = false
integer y = 368
integer height = 1676
end type

type dw_print from w_com020_d`dw_print within w_mat_d03
integer x = 82
integer y = 472
string dataobject = "d_mat_r20"
end type

