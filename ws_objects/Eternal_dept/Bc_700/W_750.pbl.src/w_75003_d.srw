$PBExportHeader$w_75003_d.srw
$PBExportComments$VIP 고객분석
forward
global type w_75003_d from w_com010_d
end type
type dw_1 from datawindow within w_75003_d
end type
type cb_g1 from commandbutton within w_75003_d
end type
end forward

global type w_75003_d from w_com010_d
dw_1 dw_1
cb_g1 cb_g1
end type
global w_75003_d w_75003_d

type variables
string is_brand, is_gubn, is_vip
datawindowchild idw_brand
end variables

on w_75003_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_g1=create cb_g1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_g1
end on

on w_75003_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_g1)
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
is_gubn = dw_head.GetItemString(1, "gubn")
is_vip = dw_head.GetItemString(1, "vip")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_title
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_gubn, is_vip)
IF il_rows > 0 THEN
	dw_body.object.gr_1.width = dw_1.width

   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* Data window Resize */
//inv_resize.of_Register(dw_body.object.gr_1, "ScaleToRight")
inv_resize.of_Register(dw_1, "ScaleToRight")


dw_1.height = 600
/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)



end event

event resize;call super::resize;//dw_body.object.gr_1.width = dw_1.width
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_75003_d","0")
end event

event ue_preview();This.Trigger Event ue_title ()
il_rows = dw_print.retrieve(is_brand, is_gubn, is_vip)
//dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_vip, ls_gubn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_gubn = dw_head.getitemstring(1,"gubn")

choose case ls_gubn
	case "0"
		ls_gubn = "브랜드별"
	case "1"
		ls_gubn = "매장별"		
	case "2"
		ls_gubn = "연령별"
	case "3"
		ls_gubn = "지역별"
	case "4"
		ls_gubn = "직업별"
end choose

if is_vip = '2' then
	ls_vip = 'VIP 회원'
else 
	ls_vip = '전체회원'
end if

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

//				 "t_brand.text = '" + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm") + "'" + & 
				 
ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.text = '" + is_brand + "'" + & 
				 "t_gubn.Text = '" + ls_gubn + "'" + &
				 "t_vip.Text = '" + ls_vip + "'"
				 
dw_print.Modify(ls_modify)


end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
			cb_g1.visible = true
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

type cb_close from w_com010_d`cb_close within w_75003_d
end type

type cb_delete from w_com010_d`cb_delete within w_75003_d
end type

type cb_insert from w_com010_d`cb_insert within w_75003_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_75003_d
end type

type cb_update from w_com010_d`cb_update within w_75003_d
end type

type cb_print from w_com010_d`cb_print within w_75003_d
end type

type cb_preview from w_com010_d`cb_preview within w_75003_d
end type

type gb_button from w_com010_d`gb_button within w_75003_d
end type

type cb_excel from w_com010_d`cb_excel within w_75003_d
end type

type dw_head from w_com010_d`dw_head within w_75003_d
integer x = 9
integer y = 168
integer width = 3602
integer height = 120
string dataobject = "d_75003_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')



end event

type ln_1 from w_com010_d`ln_1 within w_75003_d
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_d`ln_2 within w_75003_d
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_d`dw_body within w_75003_d
integer y = 340
integer height = 1696
string dataobject = "d_75003_d01"
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(false)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_print from w_com010_d`dw_print within w_75003_d
integer x = 105
integer y = 660
integer height = 400
string dataobject = "d_75003_r00"
end type

type dw_1 from datawindow within w_75003_d
boolean visible = false
integer x = 969
integer y = 1524
integer width = 2615
integer height = 512
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_75003_d02"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

type cb_g1 from commandbutton within w_75003_d
boolean visible = false
integer x = 969
integer y = 1440
integer width = 366
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "월별구매추이"
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_1.retrieve(is_brand, is_vip)
dw_1.visible = false
IF il_rows > 0 THEN
	dw_1.visible = true
   dw_1.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

parent.Trigger Event ue_button(1, il_rows)
parent.Trigger Event ue_msg(1, il_rows)

end event

