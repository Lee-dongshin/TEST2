$PBExportHeader$w_42044_e.srw
$PBExportComments$오픈매장실출고처리
forward
global type w_42044_e from w_com010_e
end type
type dw_1 from datawindow within w_42044_e
end type
end forward

global type w_42044_e from w_com010_e
integer width = 3680
integer height = 2320
dw_1 dw_1
end type
global w_42044_e w_42044_e

type variables
DataWindowChild idw_brand, idw_shop_type, idw_to_shop_type, idw_house_cd, idw_shop_type1, idw_house_cd1
string is_brand,   is_out_yymmdd, is_shop_cd, is_shop_type, is_frm_ymd, is_to_ymd
string IS_PROC_YN, is_to_shop_cd , is_to_shop_type, is_house_cd, is_yymmdd, is_opt_outday, is_opt_select
end variables

forward prototypes
public function integer wf_update ()
end prototypes

public function integer wf_update ();long i, ll_row_count
string  ls_proc_yn, ls_shop_type, ls_year, ls_season,ls_yymmdd, ls_out_no, ls_out_yymmdd

ll_row_count = dw_body.RowCount()

FOR i=1 TO ll_row_count
   
		ls_proc_yn   = dw_body.Getitemstring(i, "chk_select")
		ls_yymmdd    = dw_body.Getitemstring(i, "yymmdd")				
		ls_out_no    = dw_body.Getitemstring(i, "out_no")		
		
		if is_opt_outday = "Y" then
			ls_out_yymmdd    = dw_body.Getitemstring(i, "yymmdd")
		else	
			ls_out_yymmdd    = is_out_yymmdd
		end if	
					
		if ls_proc_yn = "Y" then	
			
			 DECLARE sp_42044_shop PROCEDURE FOR sp_42044_shop  
						@BRAND         = :is_brand,   
						@yymmdd        = :ls_yymmdd,   
						@old_out_no    = :ls_out_no,   
						@shop_cd       = :is_shop_cd,   
						@shop_type     = :is_shop_type,   
						@house_cd      = :is_house_cd,   
						@OUT_yymmdd    = :ls_out_yymmdd,   
						@to_shop_cd    = :is_to_shop_cd,   
						@to_shop_type  = :is_to_shop_type,   
						@reg_id        = :gs_user_id  ;

			
			EXECUTE sp_42044_shop;
				
						
			IF SQLCA.SQLCODE = -1 THEN 
				rollback  USING SQLCA;
				MessageBox("SQL오류", SQLCA.SqlErrText) 
				Return -1 
			ELSE
				commit  USING SQLCA;			
			END IF 

	
		END IF	

NEXT
Return 1

end function

on w_42044_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_42044_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_ymd",ld_datetime)
dw_head.SetItem(1, "to_ymd",ld_datetime)
dw_head.SetItem(1, "out_yymmdd",ld_datetime)


dw_1.insertrow(0)
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm, ls_shop_nm, ls_where
DataStore  lds_Source
Boolean    lb_check 

CHOOSE CASE as_column
		CASE "shop_cd"	
			is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_head.SetItem(al_row, "shop_nm", "")
					Return 0
				End If
				Choose Case is_brand
					Case 'J'
						If (LeftA(as_data, 1) = 'N' or LeftA(as_data, 1) = 'J') and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
							dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
							RETURN 0
						End If
					Case 'Y'
						If (LeftA(as_data, 1) = 'O' or LeftA(as_data, 1) = 'Y') and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
							dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
							RETURN 0
						END IF 
					Case Else
						If LeftA(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
							dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
							RETURN 0
						END IF 
				End Choose
				
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' and shop_div = 'Z'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' "
			ELSE
				gst_cd.Item_where = ""
			END IF

			Choose Case is_brand
				Case 'J'
					ls_where = " AND BRAND IN ('N', 'J') "
				Case 'Y'
					ls_where = " AND BRAND IN ('O', 'Y') "
				Case Else
					ls_where = " AND BRAND = '" + is_brand + "' "
			End Choose

			gst_cd.default_where = gst_cd.default_where + ls_where
			
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
				dw_head.SetColumn("shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
			
		CASE "to_shop_cd"	
			is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_head.SetItem(al_row, "to_shop_nm", "")
					Return 0
				End If
				Choose Case is_brand
					Case 'J'
						If (LeftA(as_data, 1) = 'N' or LeftA(as_data, 1) = 'J') and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
							dw_head.SetItem(al_row, "to_shop_nm", ls_shop_nm)
							RETURN 0
						End If
					Case 'Y'
						If (LeftA(as_data, 1) = 'O' or LeftA(as_data, 1) = 'Y') and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
							dw_head.SetItem(al_row, "to_shop_nm", ls_shop_nm)
							RETURN 0
						END IF 
					Case Else
						If LeftA(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
							dw_head.SetItem(al_row, "to_shop_nm", ls_shop_nm)
							RETURN 0
						END IF 
				End Choose
				
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' "
			ELSE
				gst_cd.Item_where = ""
			END IF

			Choose Case is_brand
				Case 'J'
					ls_where = " AND BRAND IN ('N', 'J') "
				Case 'Y'
					ls_where = " AND BRAND IN ('O', 'Y') "
				Case Else
					ls_where = " AND BRAND = '" + is_brand + "' "
			End Choose

			gst_cd.default_where = gst_cd.default_where + ls_where
			
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "to_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "to_shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("to_shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
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


is_frm_ymd = String(dw_head.GetItemDate(1, "frm_ymd"), "yyyymmdd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_ymd")
   return false
end if


is_to_ymd = String(dw_head.GetItemDate(1, "to_ymd"), "yyyymmdd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if

is_out_yymmdd = String(dw_head.GetItemDate(1, "out_yymmdd"), "yyyymmdd")
if IsNull(is_out_yymmdd) or Trim(is_out_yymmdd) = "" then
   MessageBox(ls_title,"출고일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_yymmdd")
   return false
end if


is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"오픈매장을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_to_shop_cd = dw_head.GetItemString(1, "to_shop_cd")
if IsNull(is_to_shop_cd) or Trim(is_to_shop_cd) = "" then
   MessageBox(ls_title,"출고매장을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_shop_cd")
   return false
end if

is_to_shop_type = dw_head.GetItemString(1, "to_shop_type")
if IsNull(is_to_shop_type) or Trim(is_to_shop_type) = "" then
   MessageBox(ls_title,"출고 매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_shop_type")
   return false
end if

is_opt_outday = dw_head.GetItemString(1, "opt_outday")
if IsNull(is_opt_outday) or Trim(is_opt_outday) = "" then
   MessageBox(ls_title,"출고일자 유지여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_outday")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_1.visible = true

//@BRAND,	@frm_ymd, @to_ymd ,@house_cd, @shop_cd, @shop_type

il_rows = dw_body.retrieve(is_brand, is_frm_ymd, is_to_ymd, is_house_cd, is_shop_cd, is_shop_type )
IF il_rows > 0 THEN
	DW_BODY.ENABLED = TRUE
   dw_body.SetFocus()
END IF

dw_1.visible = false

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      :                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
string  ls_proc_yn, ls_shop_type, ls_year, ls_season,ls_yymmdd, ls_out_no, ls_out_yymmdd

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

dw_1.visible = true

 il_rows = wf_update()			

dw_1.visible = false

IF il_rows = 1 THEN
   MessageBox("확인", "처리 완료") 
   dw_body.ResetUpdate()
	DW_BODY.ENABLED = FALSE
END IF


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42044_e","0")
end event

type cb_close from w_com010_e`cb_close within w_42044_e
end type

type cb_delete from w_com010_e`cb_delete within w_42044_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_42044_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_42044_e
end type

type cb_update from w_com010_e`cb_update within w_42044_e
end type

type cb_print from w_com010_e`cb_print within w_42044_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_42044_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_42044_e
end type

type cb_excel from w_com010_e`cb_excel within w_42044_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_42044_e
integer x = 242
integer y = 252
integer width = 3003
integer height = 368
string dataobject = "d_42044_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')


This.GetChild("to_shop_type", idw_to_shop_type)
idw_to_shop_type.SetTransObject(SQLCA)
idw_to_shop_type.Retrieve('911')

This.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('%')

end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name

   CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

   CASE "to_shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		

END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_42044_e
boolean visible = false
end type

type ln_2 from w_com010_e`ln_2 within w_42044_e
boolean visible = false
end type

type dw_body from w_com010_e`dw_body within w_42044_e
integer x = 361
integer y = 644
integer width = 2839
integer height = 1348
string dataobject = "d_42044_d01"
boolean border = false
end type

event dw_body::itemchanged;//ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

event dw_body::buttonclicked;call super::buttonclicked;Long	ll_row_count, i

CHOOSE CASE dwo.name
	CASE "cb_select"
		If is_opt_select = 'N' then
			is_opt_select = 'Y'
			This.Object.cb_select.Text = '전체제외'
		Else
			is_opt_select = 'N'
			This.Object.cb_select.Text = '전체선택'
		End If
		
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "chk_select", is_opt_select)
		Next
END CHOOSE

end event

event dw_body::constructor;call super::constructor;This.GetChild("shop_type", idw_shop_type1)
idw_shop_type1.SetTransObject(SQLCA)
idw_shop_type1.Retrieve('911')

This.GetChild("house_cd", idw_house_cd1)
idw_house_cd1.SetTransObject(SQLCA)
idw_house_cd1.Retrieve('%')

end event

type dw_print from w_com010_e`dw_print within w_42044_e
end type

type dw_1 from datawindow within w_42044_e
boolean visible = false
integer x = 827
integer y = 684
integer width = 2089
integer height = 260
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "작업알림!"
string dataobject = "d_56015_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

