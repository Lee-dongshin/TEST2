$PBExportHeader$w_58007_e.srw
$PBExportComments$수입내역등록
forward
global type w_58007_e from w_com010_e
end type
type dw_1 from datawindow within w_58007_e
end type
type dw_detail from datawindow within w_58007_e
end type
end forward

global type w_58007_e from w_com010_e
dw_1 dw_1
dw_detail dw_detail
end type
global w_58007_e w_58007_e

type variables
string is_brand,  is_order_no, is_order_gubn
decimal id_detail_rows
Datawindowchild  idw_brand,idw_season, idw_country_cd, idw_unit
end variables

forward prototypes
public function integer wf_detail_copy ()
public function integer wf_detail (string as_brand, string as_order_no)
end prototypes

public function integer wf_detail_copy ();string 	ls_brand,ls_order_no, ls_State_Code,ls_State_Nm, ls_Remark
string	ls_Style,ls_item_nm,ls_Composition
decimal	i,    ld_row_count
decimal	 ld_Amount,ld_Vat
			

		
			ld_row_count = dw_1.retrieve(is_brand, is_order_no)
			dw_detail.Reset()

			
			FOR	i =  1 to ld_row_count
				   ls_brand  			= dw_1.GetitemString(i,"brand")
					ls_order_no 		= dw_1.GetitemString(i,"Order_no")
					ls_State_Code 		= dw_1.GetitemString(i,"State_Code")
					ls_State_Nm 		= dw_1.GetitemString(i,"State_Nm") 
					ld_Amount 			= dw_1.Getitemdecimal(i,"Amount")
					ld_Vat				= dw_1.Getitemdecimal(i,"Vat")
					ls_Remark 			= dw_1.GetitemString(i,"Remark")
									
					
					dw_detail.Insertrow(i)
					dw_detail.SetItemStatus(i, 0, Primary!, NewModified!)
					dw_detail.Setitem(i,"brand",is_brand)
					dw_detail.Setitem(i,"Order_no",is_order_no)
					dw_detail.Setitem(i,"State_Code",ls_State_Code)
					dw_detail.Setitem(i,"State_Nm",ls_State_Nm)
					dw_detail.Setitem(i,"Amount",ld_Amount)
					dw_detail.Setitem(i,"Vat",ld_Vat)
					dw_detail.Setitem(i,"Remark",ls_Remark)
												
			NEXT												
					 
return 0					


end function

public function integer wf_detail (string as_brand, string as_order_no);/*===========================================================================*/
/* 작성자      : 최용운                                                   */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
long ll_rows

if isnull(as_order_no) or LenA(as_order_no) < 8 then return 0

open(w_58007_s)
w_58007_s.dw_head.Setitem(1,"brand",as_brand)
w_58007_s.dw_head.Setitem(1,"order_no",as_order_no)
w_58007_s.trigger event ue_retrieve()

return	1
end function

on w_58007_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_detail
end on

on w_58007_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_detail)
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



is_order_no = dw_head.GetItemString(1, "order_no")
if IsNull(is_order_no) or Trim(is_order_no) = "" then
   MessageBox(ls_title,"발주번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("order_no")
   return false
end if

is_order_gubn = dw_head.GetItemString(1, "order_gubn")
if IsNull(is_order_gubn) or Trim(is_order_gubn) = "" then
   MessageBox(ls_title,"수입구분를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("order_gubn")
   return false
end if



return true

end event

event ue_retrieve();call super::ue_retrieve;/*=========================================================================-==*/
/* 작성자      : (주)지우정보 ()                                      			*/	
/* 작성일      : 2001..                                                  		*/	
/* 수정일      : 2001..                                                  		*/
/*========================================================================-===*/
string 	ls_out_from_date, ls_out_to_date, ls_country_cd, ls_shop_cd, ls_year, ls_season
decimal	ld_exchange_rate, ld_qty, ld_amount 

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand,is_order_no)
IF il_rows > 0 THEN
   dw_body.SetFocus()

ELSE
	il_rows = dw_body.InsertRow(0)
	dw_body.Setitem(1, "brand", is_brand)
	dw_body.Setitem(1, "order_no", is_order_no)
	dw_body.Setitem(1, "order_gubn", is_order_gubn)
	
//	ls_year = '202' + mid(is_order_no,3,1) 
	
	gf_get_inter_sub('002', MidA(is_order_no,3,1), '1', ls_year)
	ls_season = MidA(is_order_no,4,1)
	
	dw_body.Setitem(1, "year", ls_year)
	dw_body.Setitem(1, "season", ls_season)		
END IF

This.Trigger Event ue_button(1, il_rows)
dw_1.reset()
dw_detail.reset()

id_detail_rows =  dw_detail.retrieve(is_brand,is_order_no)

if id_detail_rows = 0 then
	wf_detail_copy()
end if
	

This.Trigger Event ue_msg(1, il_rows)


end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long 		i, ll_row_count
datetime ld_datetime
decimal	ld_qty, ld_amount, ld_tot_sale_amt
decimal ld_total_amount 

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


ld_total_amount  = dw_detail.Getitemdecimal(1,"amount_all")
dw_body.Setitem(1,"Tot_amount", ld_total_amount)


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

//---------------------------------------------------------------

ll_row_count = dw_detail.RowCount()
IF dw_detail.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
//	dw_detail.SetItem(i,"brand",is_brand)
//	dw_detail.SetItem(i,"order_no",is_order_no)
   idw_status = dw_detail.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_detail.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_detail.Setitem(i, "mod_id", gs_user_id)
      dw_detail.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_detail.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_detail.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
inv_resize.of_Register(dw_detail, "ScaleToRight&Bottom")
end event

event ue_delete();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row, i, ll_det_row

ll_cur_row = dw_body.GetRow()
ll_det_row = dw_detail.RowCount()
if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_body.DeleteRow (ll_cur_row)
if il_rows > 0 then 
	for i = ll_det_row to 1 step -1
		dw_detail.deleterow(i)
	next 
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_order_gubn, ls_style, ls_chno
Boolean    lb_check 
DataStore  lds_Source
is_brand = dw_head.getitemstring(1,"brand")
ls_order_gubn = dw_head.getitemstring(1,"order_gubn")
		
CHOOSE CASE ls_order_gubn
	CASE "M"							
			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then 
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div

			gst_cd.window_title    = "원자재 코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 
			gst_cd.default_where   = "where brand = '" + is_brand + "'"
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "mat_CD LIKE '" + as_data + "%' order by mat_year desc "
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
				dw_head.SetItem(al_row, "order_no", lds_Source.GetItemString(1,"mat_cd"))
				
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 

				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source					
	CASE "G"				
			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then 
					RETURN 0
				END IF 
			END IF
			
			ls_style = MidA(as_data, 1, 8)
			ls_chno  = MidA(as_data, 9, 1)
			IF ai_div = 1 THEN 	
				IF gf_style_chk(ls_style, ls_chno) THEN
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"  + &
				                   " and chno like '" + ls_chno + "%'"
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
				dw_head.SetItem(al_row, "order_no", lds_Source.GetItemString(1,"style_no"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source		
	CASE "S"							
			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then 
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div

			gst_cd.window_title    = "부자재 코드 검색" 
			gst_cd.datawindow_nm   = "d_com023" 
			gst_cd.default_where   = "and brand = '" + is_brand + "'"
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "mat_CD LIKE '" + as_data + "%' order by mat_year desc "
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
				dw_head.SetItem(al_row, "order_no", lds_Source.GetItemString(1,"mat_cd"))
				
				/* 다음컬럼으로 이동 */
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

type cb_close from w_com010_e`cb_close within w_58007_e
end type

type cb_delete from w_com010_e`cb_delete within w_58007_e
end type

type cb_insert from w_com010_e`cb_insert within w_58007_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_58007_e
end type

type cb_update from w_com010_e`cb_update within w_58007_e
end type

type cb_print from w_com010_e`cb_print within w_58007_e
end type

type cb_preview from w_com010_e`cb_preview within w_58007_e
end type

type gb_button from w_com010_e`gb_button within w_58007_e
end type

type cb_excel from w_com010_e`cb_excel within w_58007_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_58007_e
integer height = 120
string dataobject = "d_58007_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
//
int li_ret
string ls_brand, ls_year, ls_season, ls_order_gubn

CHOOSE CASE dwo.name
	case "order_no"		
		li_ret = gf_default_head_set(dwo.name,string(data), ls_brand, ls_year, ls_season)
		if li_ret = 1 then 
			this.setitem(1,"brand" ,ls_brand)
		end if

		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_58007_e
integer beginy = 292
integer endy = 292
end type

type ln_2 from w_com010_e`ln_2 within w_58007_e
integer beginy = 296
integer endy = 296
end type

type dw_body from w_com010_e`dw_body within w_58007_e
integer y = 308
integer height = 876
string dataobject = "d_58007_d01"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_body::constructor;call super::constructor;This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')

This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')

This.GetChild("qty_unit", idw_unit)
idw_unit.SetTransObject(SQLCA)
idw_unit.Retrieve('004')


end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
		IF dw_body.GetColumnName() = "remark"  THEN
	   ELSE
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		END IF
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
END CHOOSE

Return 0
end event

type dw_print from w_com010_e`dw_print within w_58007_e
integer x = 617
integer y = 716
string dataobject = "d_58007_r01"
end type

event dw_print::constructor;call super::constructor;

This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')

This.GetChild("qty_unit", idw_unit)
idw_unit.SetTransObject(SQLCA)
idw_unit.Retrieve('004')

end event

type dw_1 from datawindow within w_58007_e
boolean visible = false
integer x = 142
integer y = 1288
integer width = 3255
integer height = 432
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_58007_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_detail from datawindow within w_58007_e
integer x = 5
integer y = 1192
integer width = 3589
integer height = 856
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_58007_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;decimal ld_total_amount


end event

event itemfocuschanged;decimal ld_total_amount

ld_total_amount  = This.Getitemdecimal(row,"amount_all")

dw_body.Setitem(1,"Tot_amount", ld_total_amount)
end event

event doubleclicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
String 	ls_search, ls_brand
if row > 0 then 
	choose case dwo.name
		case 'state_nm' 
			ls_search 	= this.GetItemString(row,"order_no")
			ls_brand 	= this.GetItemString(row,"brand")
			if LenA(ls_search)  >= 8 then	wf_detail(ls_brand,ls_search)					
	end choose	
end if





end event

