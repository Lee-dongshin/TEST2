$PBExportHeader$w_12032_e.srw
$PBExportComments$품평회 투표등록
forward
global type w_12032_e from w_com010_e
end type
end forward

global type w_12032_e from w_com010_e
integer width = 3680
integer height = 2352
end type
global w_12032_e w_12032_e

type variables
string is_brand, is_yymmdd, is_shop_cd, is_voter
datawindowchild idw_brand, idw_yymmdd

end variables

on w_12032_e.create
call super::create
end on

on w_12032_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")
is_voter = dw_head.GetItemString(1, "voter")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_flag
decimal i
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_shop_cd, is_voter)
for i=0 to il_rows 
	ls_flag = dw_body.getitemstring(i,"flag")
	if ls_flag = "New" then
		 dw_body.SetItemStatus(i, 0, Primary!, New!)
	end if
next
dw_body.SetFocus()

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm , ls_brand
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
			ls_brand = dw_head.getitemstring(1,"brand")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' and brand = '"+ls_brand+"' and shop_div like '[GK]' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(SHOP_CD LIKE '" + as_data + "%' or SHOP_nm LIKE '%" + as_data + "%')"
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
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

type cb_close from w_com010_e`cb_close within w_12032_e
end type

type cb_delete from w_com010_e`cb_delete within w_12032_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_12032_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_12032_e
end type

type cb_update from w_com010_e`cb_update within w_12032_e
end type

type cb_print from w_com010_e`cb_print within w_12032_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_12032_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_12032_e
end type

type cb_excel from w_com010_e`cb_excel within w_12032_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_12032_e
integer x = 32
integer y = 164
integer height = 260
string dataobject = "d_12032_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("yymmdd", idw_yymmdd)
idw_yymmdd.SetTransObject(SQLCA)
idw_yymmdd.Retrieve(gs_brand)
	
end event

event dw_head::itemchanged;call super::itemchanged;string ls_shop

choose case dwo.name
	case "brand"
		This.GetChild("yymmdd", idw_yymmdd)
		idw_yymmdd.SetTransObject(SQLCA)
		idw_yymmdd.Retrieve(string(data))
	CASE "shop_cd"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
		
	case "voter"
		ls_shop=string(data)
		select person_nm 
			into :ls_shop
		from tb_93010_m (nolock)
		where person_id = :ls_shop
		and   user_grp  = '1'
		and   status_yn = 'Y';
		
		this.setitem(1,"voter_nm",ls_shop)			
	case "gubn"
		if string(data) = "1" then 
			this.setitem(1,"shop_cd","직원")
			this.setitem(1,"shop_nm","")			
		else
			this.setitem(1,"shop_cd","")
			this.setitem(1,"shop_nm","")
		end if
end choose 
end event

type ln_1 from w_com010_e`ln_1 within w_12032_e
integer beginy = 428
integer endy = 428
end type

type ln_2 from w_com010_e`ln_2 within w_12032_e
integer beginy = 432
integer endy = 432
end type

type dw_body from w_com010_e`dw_body within w_12032_e
integer y = 452
integer height = 1656
string dataobject = "d_12032_d01"
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
//	CASE KeyDownArrow!
//		IF This.GetRow() = This.RowCount() THEN
//		   This.InsertRow(This.GetRow() + 1)
//		END IF
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_12032_e
string dataobject = "d_12032_d01"
end type

