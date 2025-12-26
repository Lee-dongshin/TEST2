$PBExportHeader$w_71024_d.srw
$PBExportComments$기간시즌별 구매내액
forward
global type w_71024_d from w_com010_d
end type
end forward

global type w_71024_d from w_com010_d
end type
global w_71024_d w_71024_d

type variables
String 	is_brand,is_shop_cd,is_area, is_fr_yymmdd, is_to_yymmdd, is_vip, is_rfm, is_season, is_year
DataWindowChild idw_brand,idw_area, idw_season

end variables

on w_71024_d.create
call super::create
end on

on w_71024_d.destroy
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

dw_head.SetItem(1, "fr_yymmdd", string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "to_yymmdd", string(ld_datetime,"yyyymmdd"))

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
string	ls_temp_dt
date		ld_Date
time		lt_Time

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

is_fr_yymmdd = dw_head.GetItemstring(1,"fr_yymmdd")
is_to_yymmdd = dw_head.GetItemstring(1,"to_yymmdd")
is_brand = dw_head.GetItemString(1, "brand")
is_area 	= dw_head.GetItemString(1, "area")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")
is_vip = dw_head.GetItemString(1, "vip")
is_rfm = dw_head.GetItemString(1, "rfm")
is_season = dw_head.GetItemString(1, "season")
is_year = dw_head.GetItemString(1, "year")

return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_yymmdd, is_to_yymmdd , is_brand, is_year, is_season, is_vip, is_rfm)

IF il_rows > 0 THEN
   dw_body.SetFocus()
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
string ls_modify, ls_datetime, ls_vip, ls_rfm
string ls_shop_nm 

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

choose case is_rfm
	case "A"
		ls_rfm = "최우수 고정고객"
	case "B"
		ls_rfm = "우수 고정고객"
	case "C"
		ls_rfm = "일반 고정고객"
	case "D"
		ls_rfm = "우수 유동고객"
	case "E"
		ls_rfm = "일반 유동고객"
	case "F"
		ls_rfm = "일반 휴면고객"
	case else 
		ls_rfm = "일반 휴면고객"
end choose


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
				"t_area.Text = '" + idw_area.GetItemString(idw_area.GetRow(), "inter_display") + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_shop_nm.Text = '" + ls_shop_nm + "'" + &
				"t_vip.Text = '" + ls_vip + "'" + &
				"t_rfm.Text = '" + ls_rfm + "'"

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_71003_d","0")
end event

type cb_close from w_com010_d`cb_close within w_71024_d
end type

type cb_delete from w_com010_d`cb_delete within w_71024_d
end type

type cb_insert from w_com010_d`cb_insert within w_71024_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_71024_d
end type

type cb_update from w_com010_d`cb_update within w_71024_d
end type

type cb_print from w_com010_d`cb_print within w_71024_d
end type

type cb_preview from w_com010_d`cb_preview within w_71024_d
end type

type gb_button from w_com010_d`gb_button within w_71024_d
end type

type cb_excel from w_com010_d`cb_excel within w_71024_d
end type

type dw_head from w_com010_d`dw_head within w_71024_d
integer y = 168
integer width = 3456
string dataobject = "d_71024_h01"
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

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1,'inter_cd','')
idw_season.SetItem(1,'inter_nm','전체')
end event

event dw_head::itemchanged;call super::itemchanged;string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "area"
		This.SetItem(1, "brand", "")
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
	CASE "brand"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
		
//		This.GetChild("sojae", ldw_child)
//		ldw_child.SetTransObject(SQLCA)
//		ldw_child.Retrieve('%', data)
//		ldw_child.insertrow(1)
//		ldw_child.Setitem(1, "sojae", "%")
//		ldw_child.Setitem(1, "sojae_nm", "전체")
//		
//	
//		This.GetChild("item", ldw_child)
//		ldw_child.SetTransObject(SQLCA)
//		ldw_child.Retrieve(data)
//		ldw_child.insertrow(1)
//		ldw_child.Setitem(1, "item", "%")
//		ldw_child.Setitem(1, "item_nm", "전체")		
				
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")					
		

END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_71024_d
end type

type ln_2 from w_com010_d`ln_2 within w_71024_d
end type

type dw_body from w_com010_d`dw_body within w_71024_d
string dataobject = "d_71024_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(true)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(false)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_print from w_com010_d`dw_print within w_71024_d
integer x = 1001
integer y = 756
integer width = 1435
integer height = 724
string dataobject = "d_71024_r01"
end type

