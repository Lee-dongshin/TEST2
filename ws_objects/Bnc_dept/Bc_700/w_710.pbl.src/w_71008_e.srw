$PBExportHeader$w_71008_e.srw
$PBExportComments$3만원권 쿠폰발행
forward
global type w_71008_e from w_com010_e
end type
type dw_1 from datawindow within w_71008_e
end type
end forward

global type w_71008_e from w_com010_e
dw_1 dw_1
end type
global w_71008_e w_71008_e

type variables
String 	is_brand,is_shop_cd,is_area,is_give_date,is_jumin,is_card_no,is_coupon_no
DataWindowChild idw_brand,idw_area
Long		il_point,i
end variables

on w_71008_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_71008_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
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

is_give_date = dw_head.GetItemString(1, "give_date")
is_coupon_no = dw_head.GetItemString(1, "coupon_no")

if IsNull(is_give_date) OR Trim(is_give_date)="" then
   MessageBox(ls_title,"발행일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("give_date")
   return false
end if

if IsNull(is_coupon_no) OR Trim(is_coupon_no)="" then
   MessageBox(ls_title,"쿠폰시작번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("coupon_no")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
/* dw_head 필수입력 column check */

string   ls_title, ls_coupon_no
Long	ll_coupon_no, ll_cnt, ll_coupon_seq
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_card_no,is_jumin)
il_rows = dw_body.RowCount()

//
ls_coupon_no = string(dec(is_coupon_no) - 1)
FOR ll_cnt = 1 TO il_rows
	ll_coupon_no = dec(ls_coupon_no) + 1
	ls_coupon_no = string(ll_coupon_no,"000000")
	SELECT count(coupon_no) INTO :ll_coupon_seq
	from tb_71011_h
	where  coupon_no = :ls_coupon_no
	AND 	 give_point = 3000
	AND	point_flag = 1;
	IF ll_coupon_seq > 0 THEN
		Rollback;
		MessageBox("알림",ls_coupon_no+"번 쿠폰은 이미 있습니다.")
		EXIT
	END IF
	
	dw_body.SetItem(ll_cnt, "coupon_no", ls_coupon_no)
NEXT
//

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

IF il_rows > 0 THEN
	cb_update.enabled = true
	ib_changed = true
END IF

end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
dw_1.SetTransObject(SQLCA)

end event

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
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


end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.04.08 (김 태범)                  */
/*===========================================================================*/

long   ll_rows,  ll_cnt,     ll_point,  ll_point_seq
String ls_jumin, ls_post_fg, ls_card_no, ls_coupon_no
int	li_err = 0, li_point

il_rows = dw_body.RowCount()

FOR ll_cnt = 1 TO il_rows
	ls_jumin   = dw_body.GetItemString(ll_cnt,'jumin')
	ll_point   = 3000
	li_point = dw_body.GetItemNumber(ll_cnt,'r_point')
	ls_post_fg = dw_body.GetItemString(ll_cnt,'post_flag')
	ls_card_no = dw_body.GetItemString(ll_cnt,'card_no')
	ls_coupon_no = dw_body.GetItemString(ll_cnt,'coupon_no')

	IF ls_coupon_no = '' THEN
		Rollback;
		MessageBox("알림","쿠폰번호가 부여되지 않았습니다.")
		EXIT
	END IF
	
	IF li_point >= 3000 THEN 
		// 쿠폰 발행-----------
		UPDATE TB_71060_H SET GIVE_DATE = :is_give_date
		WHERE jumin = :ls_jumin
		AND GIVE_DATE IS NULL;
		
		SELECT isnull(MAX(point_seq),0)+1 INTO :ll_point_seq
		 FROM  TB_71011_H
		WHERE  jumin = :ls_jumin
		  AND	 give_date = :is_give_date;
	
		UPDATE TB_71010_M
			SET give_point = give_point + :ll_point
		 WHERE jumin = :ls_jumin;
	
		INSERT TB_71011_H 
				(jumin,       give_date,     point_flag,  point_seq,  &
				 card_no,     coupon_no,	  give_point,    post_flag,   reg_id)
			VALUES 
				(:ls_jumin,   :is_give_date, '1',         :ll_point_seq, &
				 :ls_card_no, :ls_coupon_no,	:ll_point,  :ls_post_fg, :gs_user_id);
		
		// --------------------
	END IF

	IF SQLCA.SQLCODE <> 0 THEN
		li_err = 1
		EXIT 
	END IF
	
NEXT

IF li_err = 0 THEN
	il_rows = 1 
	Commit;
ELSE
	Rollback;
	MessageBox("알림","포인트 생성이 실패하였습니다!!!")
END IF

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return 1
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_71008_e","0")
end event

type cb_close from w_com010_e`cb_close within w_71008_e
end type

type cb_delete from w_com010_e`cb_delete within w_71008_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_71008_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_71008_e
end type

type cb_update from w_com010_e`cb_update within w_71008_e
integer width = 384
string text = "쿠폰발행(&S)"
end type

type cb_print from w_com010_e`cb_print within w_71008_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_71008_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_71008_e
end type

type cb_excel from w_com010_e`cb_excel within w_71008_e
boolean visible = false
integer x = 1774
end type

type dw_head from w_com010_e`dw_head within w_71008_e
integer y = 164
integer height = 112
string dataobject = "d_71008_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.01.18                                                  */
/*===========================================================================*/
This.GetChild("area", idw_area)
idw_area.SetTRansObject(SQLCA)
idw_area.Retrieve('090')

idw_area.InsertRow(1)
idw_area.SetItem(1,'inter_cd','%')
idw_area.SetItem(1,'inter_nm','전체')

This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

idw_brand.InsertRow(1)
idw_brand.SetItem(1,'inter_cd','%')
idw_brand.SetItem(1,'inter_nm','전체')


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "area"
		This.SetItem(1, "brand", "")
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
	CASE "brand"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "jumin","user_name","card_no"
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

type ln_1 from w_com010_e`ln_1 within w_71008_e
integer beginy = 284
integer endy = 284
end type

type ln_2 from w_com010_e`ln_2 within w_71008_e
integer beginy = 288
integer endy = 288
end type

type dw_body from w_com010_e`dw_body within w_71008_e
integer y = 300
integer height = 1744
string dataobject = "d_71008_d01"
boolean hscrollbar = true
end type

event dw_body::clicked;call super::clicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (김 영일)                                      */	
///* 작성일      : 2002.02.18                                                  */	
///* 수정일      : 2002.02.18                                                  */
///*===========================================================================*/
//String ls_jumin
//
//IF row > 0 THEN
//	dw_1.Visible = True
//	ls_jumin = this.GetItemString(row,'jumin')
//	dw_1.Retrieve(ls_jumin)
//END IF
//
//this.selectRow(0, false);
//this.setRow(row);
//this.selectRow(row, true);
//
end event

type dw_print from w_com010_e`dw_print within w_71008_e
integer x = 773
integer y = 916
string dataobject = "d_71005_r01"
end type

type dw_1 from datawindow within w_71008_e
boolean visible = false
integer x = 315
integer y = 300
integer width = 2752
integer height = 1564
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "포인트발행내역"
string dataobject = "d_71005_d05"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

