$PBExportHeader$w_71007_d.srw
$PBExportComments$보너스쿠폰출력
forward
global type w_71007_d from w_com010_d
end type
end forward

global type w_71007_d from w_com010_d
integer width = 3744
end type
global w_71007_d w_71007_d

type variables
String 	is_brand,is_shop_cd,is_area,is_give_date,is_jumin, is_vip, is_coupon_flag
DataWindowChild idw_brand,idw_area
Long		il_point
end variables

on w_71007_d.create
call super::create
end on

on w_71007_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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
if IsNull(is_give_date) OR Trim(is_give_date)="" then
   MessageBox(ls_title,"발행일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("give_date")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
is_jumin = dw_head.GetItemString(1, "jumin")
is_area 	= dw_head.GetItemString(1, "area")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")
is_vip = dw_head.GetItemString(1, "vip")
is_coupon_flag = dw_head.GetItemString(1, "coupon_flag")

il_point = dw_head.GetItemNumber(1, "point")
if IsNull(il_point) then
   MessageBox(ls_title,"발행점수를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("point")
   return false
end if

return true

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.25                                                  */	
/* 수정일      : 2002.04.25                                                  */
/*===========================================================================*/
Long i, ll_row

dw_print.DataObject = 'd_71007_r01'
dw_print.SetTransObject(SQLCA)
	
For i = 1 To dw_body.RowCount()
	If dw_body.GetItemString(i, "print_yn") = 'Y' Then
		ll_row = dw_print.InsertRow(0)
		dw_print.SetItem(ll_row, "coupon_no",    dw_body.GetItemString(i, "coupon_no"))
		dw_print.SetItem(ll_row, "zipcode",      dw_body.GetItemString(i, "zipcode"))
		dw_print.SetItem(ll_row, "addr",    	  dw_body.GetItemString(i, "addr"))
		dw_print.SetItem(ll_row, "addr_s",       dw_body.GetItemString(i, "addr_s"))
		dw_print.SetItem(ll_row, "user_name",    dw_body.GetItemString(i, "user_name"))
		dw_print.SetItem(ll_row, "card_no",      dw_body.GetItemString(i, "card_no"))
		dw_print.SetItem(ll_row, "total_point",  dw_body.GetItemDecimal(i, "total_point"))
		dw_print.SetItem(ll_row, "give_point",   dw_body.GetItemDecimal(i, "give_point"))
		dw_print.SetItem(ll_row, "point",        dw_body.GetItemDecimal(i, "point"))
		dw_print.SetItem(ll_row, "give_date",    dw_body.GetItemString(i, "give_date"))
		dw_print.SetItem(ll_row, "coupon_amt",   dw_body.GetItemDecimal(i, "coupon_amt"))
		dw_print.SetItem(ll_row, "VALID_DATE",   dw_body.GetItemString(i, "VALID_DATE"))
		dw_print.SetItem(ll_row, "rest_point",   dw_body.GetItemDecimal(i, "rest_point"))
		dw_print.SetItem(ll_row, "web_point",    dw_body.GetItemDecimal(i, "web_point"))
		dw_print.SetItem(ll_row, "sale_point",   dw_body.GetItemDecimal(i, "sale_point"))
	End If
Next

dw_print.inv_printpreview.of_SetZoom()



end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_give_date,is_area,is_brand,is_shop_cd,il_point,is_jumin, is_vip, is_coupon_flag)

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

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "give_date", string(ld_datetime,"yyyymmdd"))

end event

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm,ls_card_no,ls_jumin,ls_user_name
DataStore  lds_Source
Boolean    lb_check 

CHOOSE CASE as_column
	CASE "jumin"
			IF ai_div = 1 THEN 	
				IF gf_cust_jumin_chk(Trim(as_data), ls_user_name,ls_card_no) = TRUE THEN
				   dw_head.SetItem(al_row, "user_name", ls_user_name)
				   dw_head.SetItem(al_row, "jumin", Trim(as_data))					
				   dw_head.SetItem(al_row, "card_no", RightA(ls_card_no,9))
					RETURN 2
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where   = " jumin LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "jumin", lds_Source.GetItemString(1,"jumin"))
				dw_head.SetItem(al_row, "user_name", lds_Source.GetItemString(1,"user_name"))
				dw_head.SetItem(al_row, "card_no", RightA(lds_Source.GetItemString(1,"card_no"),9))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("user_name")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "card_no"
			IF ai_div = 1 THEN 	
				IF gf_cust_card_chk('4870090'+Trim(as_data),ls_jumin,ls_user_name) = TRUE THEN
				   dw_head.SetItem(al_row, "user_name", ls_user_name)
				   dw_head.SetItem(al_row, "card_no", RightA(Trim(as_data),9))			
				   dw_head.SetItem(al_row, "jumin", ls_jumin)
					RETURN 2
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where   = " card_no LIKE '" + '4870090'+as_data + "%'"
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
				dw_head.SetItem(al_row, "jumin", lds_Source.GetItemString(1,"jumin"))
				dw_head.SetItem(al_row, "user_name", lds_Source.GetItemString(1,"user_name"))
				dw_head.SetItem(al_row, "card_no", RightA(lds_Source.GetItemString(1,"card_no"),9))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("user_name")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "user_name"				
			IF ai_div = 1 THEN
				IF gf_cust_name_chk(as_data, ls_user_name, ls_jumin,ls_card_no) = TRUE THEN
				   dw_head.SetItem(al_row, "user_name", ls_user_name)
				   dw_head.SetItem(al_row, "jumin", ls_jumin)
				   dw_head.SetItem(al_row, "card_no", RightA(ls_card_no,9))
					RETURN 2
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where   = " user_name LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "jumin", lds_Source.GetItemString(1,"jumin"))
				dw_head.SetItem(al_row, "user_name", lds_Source.GetItemString(1,"user_name"))
				dw_head.SetItem(al_row, "card_no", RightA(lds_Source.GetItemString(1,"card_no"),9))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("user_name")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source		
	CASE "shop_cd"							// 매장 코드
		is_area = dw_head.GetItemString(1, "area")
		is_brand = dw_head.GetItemString(1, "brand")
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
	CASE "close"
			
END CHOOSE

RETURN 0

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_71007_d","0")
end event

type cb_close from w_com010_d`cb_close within w_71007_d
end type

type cb_delete from w_com010_d`cb_delete within w_71007_d
end type

type cb_insert from w_com010_d`cb_insert within w_71007_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_71007_d
end type

type cb_update from w_com010_d`cb_update within w_71007_d
end type

type cb_print from w_com010_d`cb_print within w_71007_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_71007_d
integer x = 1623
integer width = 494
string text = "쿠폰출력하기(&V)"
end type

type gb_button from w_com010_d`gb_button within w_71007_d
integer width = 3685
end type

type cb_excel from w_com010_d`cb_excel within w_71007_d
end type

type dw_head from w_com010_d`dw_head within w_71007_d
integer y = 156
integer width = 3648
integer height = 272
string dataobject = "d_71007_h01"
end type

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

event dw_head::constructor;/*===========================================================================*/
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

type ln_1 from w_com010_d`ln_1 within w_71007_d
end type

type ln_2 from w_com010_d`ln_2 within w_71007_d
end type

type dw_body from w_com010_d`dw_body within w_71007_d
integer width = 3680
string dataobject = "d_71007_d01"
end type

event dw_body::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
Long i

If dwo.name = "cb_print_yn" Then
	If dwo.Text = '전체제외' Then
		For i = 1 To dw_body.RowCount()
				dw_body.SetItem(i, "print_yn", 'N')
		Next
		dwo.Text = '전체선택'
	Else
		For i = 1 To dw_body.RowCount()
				dw_body.SetItem(i, "print_yn", 'Y')
		Next
		dwo.Text = '전체제외'
	End If
End If
end event

type dw_print from w_com010_d`dw_print within w_71007_d
integer x = 686
integer y = 912
integer width = 695
integer height = 480
string dataobject = "d_71007_r01"
end type

