$PBExportHeader$w_71038_d.srw
$PBExportComments$쿠폰 사용현황
forward
global type w_71038_d from w_com010_e
end type
type dw_1 from datawindow within w_71038_d
end type
end forward

global type w_71038_d from w_com010_e
dw_1 dw_1
end type
global w_71038_d w_71038_d

type variables
string is_brand, is_coupon_no, is_fr_yymmdd, is_to_yymmdd
datawindowchild idw_brand, idw_coupon_no

end variables

on w_71038_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_71038_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_title, ls_gubn

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

ls_gubn = dw_head.GetItemString(1, "gubn")

is_brand = dw_head.GetItemString(1, "brand")
is_coupon_no = dw_head.GetItemString(1, "coupon_no")
is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")

if ls_gubn = "1" then 
	dw_body.dataobject = "d_71038_d01"
	dw_print.dataobject = "d_71038_r01"
else
	dw_body.dataobject = "d_71038_d03"
	dw_print.dataobject = "d_71038_r03"
end if
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_coupon_no, is_fr_yymmdd, is_to_yymmdd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen;call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event open;call super::open;datetime ld_datetime




IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if
end event

event ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm , ls_fr_yymmdd, ls_to_yymmdd
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "coupon_no"				
			ls_fr_yymmdd = idw_coupon_no.getitemstring(idw_coupon_no.getrow(),"give_date")
			ls_to_yymmdd = idw_coupon_no.getitemstring(idw_coupon_no.getrow(),"close_ymd")
			dw_head.setitem(1,"fr_yymmdd",ls_fr_yymmdd)
			dw_head.setitem(1,"to_yymmdd",ls_to_yymmdd)
		
END CHOOSE


RETURN 0

end event

event ue_title;call super::ue_title;/*===========================================================================*/
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

dw_print.object.t_brand.text = '브랜드: ' + is_brand +' '+ idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_coupon_no.text = '행사명: '+ idw_coupon_no.getitemstring(idw_coupon_no.getrow(),"dist_event")
dw_print.object.t_yymmdd.text = '조회기간: '+is_fr_yymmdd + '-'+is_to_yymmdd




end event

type cb_close from w_com010_e`cb_close within w_71038_d
end type

type cb_delete from w_com010_e`cb_delete within w_71038_d
end type

type cb_insert from w_com010_e`cb_insert within w_71038_d
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_71038_d
end type

type cb_update from w_com010_e`cb_update within w_71038_d
end type

type cb_print from w_com010_e`cb_print within w_71038_d
end type

type cb_preview from w_com010_e`cb_preview within w_71038_d
end type

type gb_button from w_com010_e`gb_button within w_71038_d
end type

type cb_excel from w_com010_e`cb_excel within w_71038_d
end type

type dw_head from w_com010_e`dw_head within w_71038_d
integer height = 168
string dataobject = "d_71038_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("coupon_no", idw_coupon_no)
idw_coupon_no.SetTransObject(SQLCA)
idw_coupon_no.Retrieve()
end event

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
//
int li_ret
string ls_brand, ls_year, ls_season

CHOOSE CASE dwo.name
	case "style","style_no","ord_origin","mat_cd"
		li_ret = gf_default_head_set(dwo.name,string(data), ls_brand, ls_year, ls_season)
		if li_ret = 1 then 
			this.setitem(1,"brand" ,ls_brand)
			this.setitem(1,"year"  ,ls_year)
			this.setitem(1,"season",ls_season)
		end if
		
	CASE "coupon_no"      // dddw로 작성된 항목
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
//
end event

type ln_1 from w_com010_e`ln_1 within w_71038_d
integer beginy = 364
integer endy = 364
end type

type ln_2 from w_com010_e`ln_2 within w_71038_d
integer beginy = 368
integer endy = 368
end type

type dw_body from w_com010_e`dw_body within w_71038_d
integer y = 388
integer height = 1652
string dataobject = "d_71038_d01"
end type

event dw_body::doubleclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_yymmdd
/* dw_head 필수입력 column check */



	ls_yymmdd = this.getitemstring(row,'yymmdd')
	il_rows = dw_1.retrieve(is_brand, ls_yymmdd)

	dw_1.visible = true




end event

type dw_print from w_com010_e`dw_print within w_71038_d
string dataobject = "d_71038_d01"
end type

type dw_1 from datawindow within w_71038_d
boolean visible = false
integer y = 48
integer width = 3918
integer height = 2036
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "상세내역"
string dataobject = "d_71038_d02"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

