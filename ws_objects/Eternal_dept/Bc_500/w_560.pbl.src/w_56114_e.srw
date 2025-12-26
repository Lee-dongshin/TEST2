$PBExportHeader$w_56114_e.srw
$PBExportComments$입금차액관리
forward
global type w_56114_e from w_com010_e
end type
end forward

global type w_56114_e from w_com010_e
integer width = 3675
integer height = 2276
end type
global w_56114_e w_56114_e

type variables
DataWindowChild     idw_brand,  idw_shop_div, idw_comm_fg 
String is_brand,    is_fr_ymd,  is_to_ymd 
String is_shop_div, is_shop_cd, is_comm_fg, is_rpt_chk

end variables

on w_56114_e.create
call super::create
end on

on w_56114_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_head.Setitem(1, "shop_div", "%")
dw_head.Setitem(1, "comm_fg", "%")

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56114_e","0")
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.20                                                  */	
/* 수정일      : 2002.03.20                                                  */
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

is_brand    = dw_head.GetItemString(1, "brand")

is_fr_ymd   = String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
//IF DaysAfter(dw_head.GetItemDate(1, "fr_ymd"), dw_head.GetItemDate(1, "to_ymd")) > 60 THEN
//   MessageBox(ls_title,"2개월 이상 조회할수 없습니다!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("to_ymd")
//   return false
//END IF	
is_to_ymd   = String(dw_head.GetItemDate(1, "to_ymd"), "yyyymmdd") 
IF is_fr_ymd > is_to_ymd THEN 
   MessageBox(ls_title,"시작일이 종료일 보다 큽니다 !")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
END IF	

is_shop_div = dw_head.GetItemString(1, "shop_div")
is_shop_cd  = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = '%'
end if
is_comm_fg = dw_head.GetItemString(1, "comm_fg")

is_rpt_chk = dw_head.GetItemString(1, "rpt_chk")
if IsNull(is_rpt_chk) or Trim(is_rpt_chk) = "" then
   MessageBox(ls_title,"출력부분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rpt_chk")
   return false
end if


return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.20                                                  */	
/* 수정일      : 2002.03.20                                                  */
/*===========================================================================*/
String     ls_brand, ls_shop_div, ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF 
			ls_brand    = dw_head.GetitemString(1, "brand")
			ls_shop_div = dw_head.GetitemString(1, "shop_div")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand    = '" + ls_brand + "'" + &
			                         "  AND shop_div like '" + ls_shop_div + "'" + &
											 "  AND Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF 
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("comm_fg")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.20                                                  */	
/* 수정일      : 2002.03.20                                                  */
/*===========================================================================*/
long ll_row_cnt
integer ii
String ls_brand
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_ymd,  is_to_ymd, is_shop_div, is_shop_cd, is_comm_fg)

IF il_rows > 0 THEN
	ll_row_cnt = dw_body.RowCount()
	
	for ii = 1 to ll_row_cnt
		ls_brand = dw_body.getitemstring(ii, "brand")
		if IsNull(ls_brand) or Trim(ls_brand) = "" then
			dw_body.SetItemStatus(ii, 0, Primary!, NewModified!)
		end if	
	next
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count
datetime ld_datetime
String ls_yymmdd, ls_shop_cd, ls_sugm_ymd

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! or idw_status = DataModified! THEN				/* New Record    */
    		ls_yymmdd = dw_body.GetitemString(i, "yymmdd") 
		ls_sugm_ymd = dw_body.GetitemString(i, "sugm_ymd") 
		ls_shop_cd = dw_body.GetitemString(i, "shop_cd") 		
		IF isnull(ls_yymmdd) or Trim(ls_yymmdd) = "" THEN 
         dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
         dw_body.Setitem(i, "yymmdd",   ls_sugm_ymd)
         dw_body.Setitem(i, "brand",    is_brand)
         dw_body.Setitem(i, "shop_div",    MidA(ls_shop_cd,2,1) )
         dw_body.Setitem(i, "reg_id", gs_user_id)
		ELSE
         dw_body.Setitem(i, "mod_id", gs_user_id)
         dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF
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

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime, ls_shop

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

IF is_shop_cd = '%' THEN 
	ls_shop = '전체' 
ELSE
	ls_shop = dw_head.object.shop_nm[1] + "[" + is_shop_cd + "]"
END IF

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + & 
				"t_brand.Text = '브랜드 : " + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_date.Text  = '기간 : " + String(is_fr_ymd + is_to_ymd, "@@@@/@@/@@ - @@@@/@@/@@") + "'" + &
				"t_shop_div.Text = '유통망 : " + idw_shop_div.GetitemString(idw_shop_div.GetRow(), "inter_display") + "'" + &
				"t_shop_cd.Text  = '매장 : " + ls_shop + "'" + &
				"t_comm_fg.Text = '수수료구분 : " + idw_comm_fg.GetitemString(idw_comm_fg.GetRow(), "inter_display") + "'" 
				

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_e`cb_close within w_56114_e
end type

type cb_delete from w_com010_e`cb_delete within w_56114_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56114_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56114_e
end type

type cb_update from w_com010_e`cb_update within w_56114_e
end type

type cb_print from w_com010_e`cb_print within w_56114_e
end type

type cb_preview from w_com010_e`cb_preview within w_56114_e
end type

type gb_button from w_com010_e`gb_button within w_56114_e
end type

type cb_excel from w_com010_e`cb_excel within w_56114_e
end type

type dw_head from w_com010_e`dw_head within w_56114_e
string dataobject = "d_56114_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.insertRow(1) 
idw_shop_div.Setitem(1, "inter_cd", "%")
idw_shop_div.Setitem(1, "inter_nm", "전체")

This.GetChild("comm_fg", idw_comm_fg)
idw_comm_fg.SetTransObject(SQLCA)
idw_comm_fg.Retrieve('919')
idw_comm_fg.insertRow(1) 
idw_comm_fg.Setitem(1, "inter_cd", "%")
idw_comm_fg.Setitem(1, "inter_nm", "전체")


end event

event dw_head::itemchanged;call super::itemchanged;

CHOOSE CASE dwo.name
	CASE "shop_cd"	     
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_56114_e
end type

type ln_2 from w_com010_e`ln_2 within w_56114_e
end type

type dw_body from w_com010_e`dw_body within w_56114_e
string dataobject = "d_56114_d01"
boolean hsplitscroll = true
end type

event dw_body::doubleclicked;call super::doubleclicked;String ls_yes

IF row < 0 or is_rpt_chk = "Y" THEN RETURN

gsv_cd.gs_cd1 = is_brand
gsv_cd.gs_cd2 = This.GetitemString(row, "sugm_ymd")
gsv_cd.gs_cd3 = This.GetitemString(row, "shop_cd")
gsv_cd.gs_cd4 = This.GetitemString(row, "shop_nm")

OpenWithParm (W_56104_S, "W_56104_S 입금 등록") 

IF gsv_cd.gs_cd5 = 'YES' THEN 
	Parent.Trigger Event ue_retrieve()
END IF

end event

event dw_body::dberror;//
end event

type dw_print from w_com010_e`dw_print within w_56114_e
string dataobject = "d_56114_R01"
end type

