$PBExportHeader$w_75017_d.srw
$PBExportComments$회원검색
forward
global type w_75017_d from w_com020_d
end type
type dw_member from datawindow within w_75017_d
end type
end forward

global type w_75017_d from w_com020_d
integer height = 2264
dw_member dw_member
end type
global w_75017_d w_75017_d

type variables
string is_jumin, is_user_id, is_user_name, is_card_day, is_card_day2, is_card_no,	&
		is_birthday, is_birthday2, is_marry_day, is_marry_day2, is_zipcode, is_zipcode2, &
		is_addr, is_addr2, is_tel_no1, is_tel_no2, is_tel_no3, is_job, is_office_name, &
		is_dept, is_email, is_homepage, is_post_flag, is_coupon_flag, is_shop_cd,  &
		is_area, is_last_sale_date, is_last_sale_date2, is_vip_grd, is_brand, is_rfm_grd, is_reg_id
		


integer ii_sex, ii_bday, ii_mailing, ii_sms_yn, ii_tm_yn, ii_dm_yn, ii_visit, ii_visit2, &
			ii_grd_r, ii_grd_f, ii_grd_m


decimal idc_sale_qty, idc_sale_qty2, idc_sale_amt, idc_sale_amt2, idc_total_point, &
		idc_total_point2, idc_sale_point, idc_sale_point2, idc_give_point, idc_give_point2, &
		idc_accept_point, idc_accept_point2, idc_board_point, idc_board_point2, &
		idc_event_point, idc_event_point2, idc_door_cnt_n, idc_door_cnt_n2, idc_door_cnt_o, &
		idc_door_cnt_o2

datawindowchild	idw_brand, idw_area, idw_job, idw_sale_type
end variables

on w_75017_d.create
int iCurrent
call super::create
this.dw_member=create dw_member
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_member
end on

on w_75017_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_member)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;IF dw_list.AcceptText() <> 1 THEN RETURN FALSE

is_jumin = dw_list.GetItemString(1, 'jumin')
is_user_id = dw_list.GetItemString(1, 'user_id')
is_user_name = dw_list.GetItemString(1, 'user_name')
ii_sex = dw_list.GetItemNumber(1, 'sex')
is_card_day = dw_list.GetItemString(1, 'card_day')
is_card_day2 = dw_list.GetItemString(1, 'card_day2')
is_card_no = dw_list.GetItemString(1, 'card_no')
is_birthday = dw_list.GetItemString(1, 'birthday')
is_birthday2 = dw_list.GetItemString(1, 'birthday2')
ii_bday = dw_list.GetItemNumber(1, 'bday')
is_marry_day = dw_list.GetItemString(1, 'marry_day')
is_marry_day2 = dw_list.GetItemString(1, 'marry_day2')
is_zipcode = dw_list.GetItemString(1, 'zipcode')
is_zipcode2 = dw_list.GetItemString(1, 'zipcode2')
is_addr = dw_list.GetItemString(1, 'address')
is_addr2 = dw_list.GetItemString(1, 'address2')
is_tel_no1 = dw_list.GetItemString(1, 'tel_no1')
is_tel_no2 = dw_list.GetItemString(1, 'tel_no2')
is_tel_no3 = dw_list.GetItemString(1, 'tel_no3')
is_job = dw_list.GetItemString(1, 'job')
is_office_name = dw_list.GetItemString(1, 'office_name')
is_dept = dw_list.GetItemString(1, 'dept')
is_email = dw_list.GetItemString(1, 'email')
is_homepage = dw_list.GetItemString(1, 'homepage')
ii_mailing = dw_list.GetItemNumber(1, 'mailing')
ii_sms_yn = dw_list.GetItemNumber(1, 'sms_yn')
ii_tm_yn = dw_list.GetItemNumber(1, 'tm_yn')
ii_dm_yn = dw_list.GetItemNumber(1, 'dm_yn')
is_post_flag = dw_list.GetItemString(1, 'post_flag')
is_coupon_flag = dw_list.GetItemString(1, 'coupon_flag')
is_shop_cd = dw_list.GetItemString(1, 'shop_cd')
is_area = dw_list.GetItemString(1, 'area')
ii_visit = dw_list.GetItemNumber(1, 'visit')
ii_visit2 = dw_list.GetItemNumber(1, 'visit2')
is_last_sale_date = dw_list.GetItemString(1, 'last_sale_date')
is_last_sale_date2 = dw_list.GetItemString(1, 'last_sale_date2')
idc_sale_qty = dw_list.GetItemNumber(1, 'sale_qty')
idc_sale_qty2 = dw_list.GetItemNumber(1, 'sale_qty2')
idc_sale_amt = dw_list.GetItemNumber(1, 'sale_amt')
idc_sale_amt2 = dw_list.GetItemNumber(1, 'sale_amt2')
idc_total_point = dw_list.GetItemNumber(1, 'total_point')
idc_total_point2 = dw_list.GetItemNumber(1, 'total_point2')
idc_sale_point = dw_list.GetItemNumber(1, 'sale_point')
idc_sale_point2 = dw_list.GetItemNumber(1, 'sale_point2')
idc_give_point = dw_list.GetItemNumber(1, 'give_point')
idc_give_point2 = dw_list.GetItemNumber(1, 'give_point2')
idc_accept_point = dw_list.GetItemNumber(1, 'accept_point')
idc_accept_point2 = dw_list.GetItemNumber(1, 'accept_point2')
idc_board_point = dw_list.GetItemNumber(1, 'board_point')
idc_board_point2 = dw_list.GetItemNumber(1, 'board_point2')
idc_event_point = dw_list.GetItemNumber(1, 'event_point')
idc_event_point2 = dw_list.GetItemNumber(1, 'event_point2')
is_vip_grd = dw_list.GetItemString(1, 'vip_grd')
is_brand = dw_list.GetItemString(1, 'brand')
is_rfm_grd = dw_list.GetItemString(1, 'frm_grd')
ii_grd_r = dw_list.GetItemNumber(1, 'grd_r')
ii_grd_f = dw_list.GetItemNumber(1, 'grd_f')
ii_grd_m = dw_list.GetItemNumber(1, 'grd_m')
idc_door_cnt_n = dw_list.GetItemNumber(1, 'door_cnt_n')
idc_door_cnt_n2 = dw_list.GetItemNumber(1, 'door_cnt_n2')
idc_door_cnt_o = dw_list.GetItemNumber(1, 'door_cnt_o')
idc_door_cnt_o2 = dw_list.GetItemNumber(1, 'door_cnt_o2')

is_reg_id = dw_list.GetItemString(1, 'reg_id')

return true
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
         dw_list.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
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
      dw_list.Enabled = true
      dw_list.SetFocus()
      dw_list.SetColumn(1)
	
END CHOOSE

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_jumin,is_user_id,is_user_name,ii_sex,is_card_day,is_card_day2,is_card_no, &
									is_birthday,is_birthday2,ii_bday,is_marry_day,is_marry_day2,is_zipcode, &
									is_zipcode2,is_addr,is_addr2,is_tel_no1,is_tel_no2,is_tel_no3,is_job, &
									is_office_name,is_dept,is_email,is_homepage,ii_mailing,ii_sms_yn,ii_tm_yn, &
									ii_dm_yn,is_post_flag,is_coupon_flag,is_shop_cd,is_area,ii_visit,ii_visit2, &
									is_last_sale_date,is_last_sale_date2,idc_sale_qty,idc_sale_qty2,idc_sale_amt, &
									idc_sale_amt2,idc_total_point,idc_total_point2,idc_sale_point,idc_sale_point2, &
									idc_give_point,idc_give_point2,idc_accept_point,idc_accept_point2,idc_board_point, &
									idc_board_point2,idc_event_point,idc_event_point2,is_vip_grd,is_brand,is_rfm_grd, &
									ii_grd_r,ii_grd_f,ii_grd_m,idc_door_cnt_n,idc_door_cnt_n2,idc_door_cnt_o,idc_door_cnt_o2, is_reg_id)

//il_rows = dw_body.retrieve(is_jumin,is_user_id,is_user_name,ii_sex,is_card_day,is_card_day2,is_card_no, &
//									is_birthday,is_birthday2,ii_bday,is_marry_day,is_marry_day2,is_zipcode, &
//									is_zipcode2,is_addr,is_addr2,is_tel_no1,is_tel_no2,is_tel_no3,is_job, &
//									is_office_name,is_dept,is_email,is_homepage,ii_mailing,ii_sms_yn,ii_tm_yn, &
//									ii_dm_yn,'1','1',is_shop_cd,is_area,ii_visit,ii_visit2, &
//									is_last_sale_date,is_last_sale_date2,idc_sale_qty,idc_sale_qty2,idc_sale_amt, &
//									idc_sale_amt2,idc_total_point,idc_total_point2,idc_sale_point,idc_sale_point2, &
//									idc_give_point,idc_give_point2,idc_accept_point,idc_accept_point2,idc_board_point, &
//									idc_board_point2,idc_event_point,idc_event_point2,is_vip_grd,is_brand,is_rfm_grd, &
//									ii_grd_r,ii_grd_f,ii_grd_m,idc_door_cnt_n,idc_door_cnt_n2,idc_door_cnt_o,idc_door_cnt_o2)
This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;dw_list.InsertRow(0)
dw_member.SetTransObject(SQLCA)

end event

type cb_close from w_com020_d`cb_close within w_75017_d
end type

type cb_delete from w_com020_d`cb_delete within w_75017_d
end type

type cb_insert from w_com020_d`cb_insert within w_75017_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_75017_d
end type

type cb_update from w_com020_d`cb_update within w_75017_d
end type

type cb_print from w_com020_d`cb_print within w_75017_d
end type

type cb_preview from w_com020_d`cb_preview within w_75017_d
end type

type gb_button from w_com020_d`gb_button within w_75017_d
end type

type cb_excel from w_com020_d`cb_excel within w_75017_d
end type

type dw_head from w_com020_d`dw_head within w_75017_d
boolean visible = false
integer y = 112
integer height = 36
end type

event dw_head::constructor;call super::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')
idw_brand.insertrow(1)
idw_brand.setitem(1,"inter_cd","%")
idw_brand.setitem(1,"inter_nm","전체")

this.getchild("job",idw_job)
idw_job.settransobject(sqlca)
idw_job.retrieve('701')
idw_job.insertrow(1)
idw_job.setitem(1,"inter_cd","%")
idw_job.setitem(1,"inter_nm","전체")

this.getchild("area",idw_area)
idw_area.settransobject(sqlca)
idw_area.retrieve('090')
idw_area.insertrow(1)
idw_area.setitem(1,"inter_cd","%")
idw_area.setitem(1,"inter_nm","전체")



end event

type ln_1 from w_com020_d`ln_1 within w_75017_d
boolean visible = false
integer beginy = 148
integer endy = 148
end type

type ln_2 from w_com020_d`ln_2 within w_75017_d
boolean visible = false
integer beginy = 152
integer endy = 152
end type

type dw_list from w_com020_d`dw_list within w_75017_d
integer y = 168
integer width = 1504
integer height = 1872
string dataobject = "d_75017_h01"
end type

event dw_list::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')
idw_brand.insertrow(1)
idw_brand.setitem(1,"inter_cd","%")
idw_brand.setitem(1,"inter_nm","전체")

this.getchild("area",idw_area)
idw_area.settransobject(sqlca)
idw_area.retrieve('090')
idw_area.insertrow(1)
idw_area.setitem(1,"inter_cd","%")
idw_area.setitem(1,"inter_nm","전체")

this.getchild("job",idw_job)
idw_job.settransobject(sqlca)
idw_job.retrieve('701')
idw_job.insertrow(1)
idw_job.setitem(1,"inter_cd","%")
idw_job.setitem(1,"inter_nm","전체")
end event

type dw_body from w_com020_d`dw_body within w_75017_d
integer x = 1559
integer y = 168
integer width = 2034
integer height = 1872
string dataobject = "d_75017_d01"
boolean hscrollbar = true
end type

event dw_body::doubleclicked;call super::doubleclicked;string  ls_jumin
long    ll_rows


dw_member.Reset()
ls_jumin = this.getitemstring(row,"jumin")
ll_rows = dw_member.Retrieve(ls_jumin) 

if  ll_rows > 0 then
	dw_member.visible = true
end if



end event

type st_1 from w_com020_d`st_1 within w_75017_d
integer x = 1531
integer y = 168
integer height = 1872
end type

type dw_print from w_com020_d`dw_print within w_75017_d
string dataobject = "d_75017_d01"
end type

type dw_member from datawindow within w_75017_d
boolean visible = false
integer x = 5
integer y = 220
integer width = 4498
integer height = 1824
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "회원정보"
string dataobject = "d_member_info"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.GetChild("area", idw_area)
idw_area.SetTRansObject(SQLCA)
idw_area.Retrieve('090')

This.GetChild("sale_type", idw_sale_type )
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.Retrieve('011')
end event

event doubleclicked;This.Visible = false 
end event

