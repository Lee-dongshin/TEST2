$PBExportHeader$w_74004_d.srw
$PBExportComments$생일/결혼기념일자조회
forward
global type w_74004_d from w_com010_d
end type
end forward

global type w_74004_d from w_com010_d
end type
global w_74004_d w_74004_d

type variables
datetime id_reg_from,id_reg_to

DataWindowChild idw_brand,idw_area
String	is_memorial_day_from,is_memorial_day_to,is_last_sale_from,is_last_sale_to
String	is_birthday,is_weddingday
String 	is_area,is_brand,is_shop_cd, is_vip
long		il_sale_qty_from,il_sale_qty_to,il_point_from,il_point_to
long		il_sale_amt_from,il_sale_amt_to
int		ii_age_from,ii_age_to
end variables

on w_74004_d.create
call super::create
end on

on w_74004_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "memorial_day_from", String(ld_datetime,"MMDD"))
dw_head.SetItem(1, "memorial_day_to", String(ld_datetime,"MMDD"))

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"							// 매장 코드
		is_area = dw_head.GetItemString(1, "area")
		is_brand = 'W'
		If IsNull(is_brand) or Trim(is_brand) = "" Then 
			is_brand = ""
		END IF
		If IsNull(is_area) or Trim(is_area) = "" Then 
			is_area = ""
		END IF
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF LeftA(as_data, 1) <> is_brand Then
					MessageBox("입력오류","해당 브랜드의 매장코드가 아닙니다!")
					RETURN 1
				ELSEIF gf_shop_nm(as_data, 'S', ls_part_nm) <> 0 THEN
					MessageBox("입력오류","등록되지 않은 매장코드입니다!")
					RETURN 1
				END IF
				dw_head.SetItem(al_row, "shop_nm", ls_part_nm)
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "매장 코드 검색" 
				gst_cd.datawindow_nm   = "d_com912" 
				gst_cd.default_where   = " WHERE SHOP_CD LIKE '" + is_brand + "%' AND AREA_CD LIKE '"+is_area+"%'"
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " SHOP_CD LIKE '" + as_data + "%' "
				ELSE
					gst_cd.Item_where = ""
				END IF

				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm
					dw_head.SetRow(al_row)
					dw_head.SetColumn(as_column)
					dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
					dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("sale_dt")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
			END IF

END CHOOSE

RETURN 0

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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

is_memorial_day_from = dw_head.GetItemString(1, "memorial_day_from")
if IsNull(is_memorial_day_from) then
   MessageBox(ls_title,"기념일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("memorial_day_from")
   return false
end if

is_memorial_day_to = dw_head.GetItemString(1, "memorial_day_to")
if IsNull(is_memorial_day_to) then
   MessageBox(ls_title,"기념일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("memorial_day_to")
   return false
end if

is_brand 		= 'W'
is_area 			= dw_head.GetItemString(1, "area")
is_shop_cd		= dw_head.GetItemString(1, "shop_cd")
is_last_sale_from = dw_head.GetItemString(1, "last_sale_from")
is_last_sale_to = dw_head.GetItemString(1, "last_sale_to")
is_birthday 	= dw_head.GetItemString(1, "birthday")
is_weddingday 	= dw_head.GetItemString(1, "weddingday")
il_sale_qty_from= dw_head.GetItemNumber(1, "sale_qty_from")
il_sale_qty_to	= dw_head.GetItemNumber(1, "sale_qty_to")
il_point_from	= dw_head.GetItemNumber(1, "point_from")
il_point_to		= dw_head.GetItemNumber(1, "point_to")
il_sale_amt_from= dw_head.GetItemNumber(1, "sale_amt_from")
il_sale_amt_to= dw_head.GetItemNumber(1, "sale_amt_to")
ii_age_from		= dw_head.GetItemNumber(1, "age_from")
ii_age_to		= dw_head.GetItemNumber(1, "age_to")
is_vip		= dw_head.GetItemString(1, "vip")



IF is_last_sale_from="" OR isnull(is_last_sale_from) THEN
	is_last_sale_from = "00000000"
END IF

IF is_last_sale_to="" OR isnull(is_last_sale_to) THEN
	is_last_sale_to = "99999999"
END IF

IF isnull(il_sale_qty_from) THEN
	il_sale_qty_from = 0
END IF

IF isnull(il_sale_qty_to) THEN
	il_sale_qty_to = 999999999
END IF

IF isnull(il_point_from) THEN
	il_point_from = 0
END IF

IF isnull(il_point_to) THEN
	il_point_to = 999999999
END IF

IF isnull(il_sale_amt_from) THEN
	il_sale_amt_from = 0
END IF

IF isnull(il_sale_amt_to) THEN
	il_sale_amt_to = 999999999
END IF

IF isnull(ii_age_from) THEN
	ii_age_from = 0
END IF

IF isnull(ii_age_to) THEN
	ii_age_to = 100
END IF

return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_memorial_day_from,is_memorial_day_to,is_area,&
is_brand,is_shop_cd,is_last_sale_from,is_last_sale_to,is_birthday,is_weddingday,&
il_sale_qty_from,il_sale_qty_to,il_point_from,il_point_to,il_sale_amt_from,il_sale_amt_to,&
ii_age_from,ii_age_to, is_vip)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime
string ls_shop_nm, ls_vip

ls_shop_nm = dw_head.GetItemString(1,'shop_nm')

IF ls_shop_nm = "" OR isnull(ls_shop_nm) THEN
	ls_shop_nm = "전체"
END IF

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_vip = '2' then
	ls_vip = 'VIP 회원'
else 
	ls_vip = '전체회원'
end if

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
				"t_area.Text = '" + idw_area.GetItemString(idw_area.GetRow(), "inter_display") + "'" + &
				"t_shop_nm.Text = '" + ls_shop_nm + "'" + &
				"t_vip.Text = '" + ls_vip + "'"
dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_74004_d","0")
end event

type cb_close from w_com010_d`cb_close within w_74004_d
end type

type cb_delete from w_com010_d`cb_delete within w_74004_d
end type

type cb_insert from w_com010_d`cb_insert within w_74004_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_74004_d
end type

type cb_update from w_com010_d`cb_update within w_74004_d
end type

type cb_print from w_com010_d`cb_print within w_74004_d
end type

type cb_preview from w_com010_d`cb_preview within w_74004_d
end type

type gb_button from w_com010_d`gb_button within w_74004_d
end type

type cb_excel from w_com010_d`cb_excel within w_74004_d
end type

type dw_head from w_com010_d`dw_head within w_74004_d
integer height = 340
string dataobject = "d_74004_h01"
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
idw_area.SetItem(1,'inter_cd','')
idw_area.SetItem(1,'inter_nm','전체')

This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

idw_brand.InsertRow(1)
idw_brand.SetItem(1,'inter_cd','')
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
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_74004_d
integer beginy = 532
integer endy = 532
end type

type ln_2 from w_com010_d`ln_2 within w_74004_d
integer beginy = 536
integer endy = 536
end type

type dw_body from w_com010_d`dw_body within w_74004_d
integer y = 568
integer height = 1472
string dataobject = "d_74004_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_74004_d
integer x = 1207
integer y = 816
integer width = 1435
integer height = 468
string dataobject = "d_74004_r01"
end type

