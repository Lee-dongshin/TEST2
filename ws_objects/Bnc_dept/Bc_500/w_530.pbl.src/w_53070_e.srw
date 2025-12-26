$PBExportHeader$w_53070_e.srw
$PBExportComments$EDI/닷컴 마감입력
forward
global type w_53070_e from w_com010_e
end type
end forward

global type w_53070_e from w_com010_e
end type
global w_53070_e w_53070_e

type variables
DataWindowChild idw_brand, idw_empno

String is_brand, is_shop_cd, is_emp_no, is_s_yymm, is_e_yymm

end variables

on w_53070_e.create
call super::create
end on

on w_53070_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event close;call super::close;gf_user_connect_pgm(gs_user_id,"w_53070_e","0")
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = '%'
/*   
	MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
*/	
end if

is_emp_no = Trim(dw_head.GetItemString(1, "emp_no"))
if IsNull(is_emp_no) or is_emp_no = "" then
	is_emp_no = '%'
end if

is_s_yymm = dw_head.GetItemString(1, "s_yymm")
is_e_yymm = dw_head.GetItemString(1, "e_yymm")
if IsNull(is_s_yymm) or Trim(is_s_yymm) = "" then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("s_yymm")
   return false
end if
if IsNull(is_e_yymm) or Trim(is_e_yymm) = "" then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("e_yymm")
   return false
end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
string     ls_emp_nm,ls_shop_cd, ls_shop_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "emp_no"				
//		is_brand = Trim(dw_head.GetItemString(1, "brand"))
//		
//			IF ai_div = 1 THEN 	
//				IF IsNull(as_data) or Trim(as_data)  = "" THEN
//				   dw_head.SetItem(al_row, "emp_nm", "")
//					RETURN 0
//				END IF 
//			END IF
//
//		   gst_cd.ai_div          = ai_div
//			gst_cd.window_title    = "영업부 사원 코드 검색" 
//			gst_cd.datawindow_nm   = "d_com930" 
//
//			If gf_get_inter_sub('991', is_brand + '50', '1', ls_dept_cd) = False Then
//				dw_head.SetItem(al_row, "emp_no", "")
//				dw_head.SetItem(al_row, "emp_nm", "")
//				Return 2
//			END IF 
//			gst_cd.default_where   = " WHERE DEPT_CODE = '" + ls_dept_cd + "' " + &
//			                         "   AND GOOUT_GUBN = '1' "
//
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "EMPNO LIKE '" + as_data + "%'"
//			ELSE
//				gst_cd.Item_where = ""
//			END IF
//
//			lds_Source = Create DataStore
//			OpenWithParm(W_COM200, lds_Source)
//
//			IF Isvalid(Message.PowerObjectParm) THEN
//				ib_itemchanged = True
//				lds_Source = Message.PowerObjectParm
//				dw_head.SetRow(al_row)
//				dw_head.SetColumn(as_column)
//				dw_head.SetItem(al_row, "emp_no", lds_Source.GetItemString(1,"empno"))
//				dw_head.SetItem(al_row, "emp_nm", lds_Source.GetItemString(1,"kname"))
//				/* 다음컬럼으로 이동 */
//				cb_retrieve.SetFocus()
////				dw_head.SetColumn("end_ymd")
//				ib_itemchanged = False 
//				lb_check = TRUE 
//			ELSE
//				lb_check = FALSE 
//			END IF
//			Destroy  lds_Source

	CASE "shop_cd"				
		is_brand = dw_head.GetItemString(1, "brand")
		IF ai_div = 1 THEN 	
			IF IsNull(as_data) or Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "shop_nm", "")
				RETURN 0
			END IF 
			IF LeftA(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' " + &
										 "   AND SHOP_STAT = '00' "
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = " SHOP_CD LIKE '" + as_data + "%' "
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
			dw_head.SetColumn("s_yymm")
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
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
long i
string ls_Flag

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_s_yymm, is_e_yymm, is_shop_cd, is_emp_no, is_brand)

IF il_rows > 0 THEN
	for i = 1 to il_rows
		ls_Flag = dw_body.getitemstring(i,"Flag") 
		if ls_Flag = "New" then	dw_body.SetItemStatus(i, 0, Primary!,New!)
	next 
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.04.29 (김 태범)                                        */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime 
String   ls_yymmdd 

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_head.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

	FOR i=1 TO ll_row_count
		idw_status = dw_body.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record */
			dw_body.Setitem(i, "shop_cd",  is_shop_cd)
			dw_body.Setitem(i, "brand",  is_brand)
			dw_body.Setitem(i, "reg_id", gs_user_id)
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
			dw_body.Setitem(i, "brand",  is_brand)
			dw_body.Setitem(i, "mod_id", gs_user_id)
			dw_body.Setitem(i, "mod_ymd", ld_datetime)
		END IF
	NEXT	


il_rows = dw_body.Update(True, False)

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
Return il_rows

end event

event open;call super::open;string ls_s_yymm, ls_e_yymm


select convert(char(6), dateadd(m,-1,getdate()), 112)
into :ls_s_yymm
from dual;

ls_e_yymm = ls_s_yymm;

/*
select convert(char(6), getdate(), 112)
into :ls_e_yymm
from dual;
*/

dw_head.SetItem(1,"s_yymm", ls_s_yymm)
dw_head.SetItem(1,"e_yymm", ls_e_yymm)


//Trigger Event ue_retrieve()

end event

event ue_preview();call super::ue_preview;dw_body.inv_printpreview.of_SetZoom()
end event

event ue_print();call super::ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.21                                                  */	
/* 수정일      : 2001.12.21                                                  */
/*===========================================================================*/


il_rows = dw_print.retrieve(is_s_yymm, is_e_yymm, is_shop_cd, is_emp_no, is_brand)
//This.Trigger Event ue_title()
IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF

This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_53070_e
end type

type cb_delete from w_com010_e`cb_delete within w_53070_e
end type

type cb_insert from w_com010_e`cb_insert within w_53070_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_53070_e
end type

type cb_update from w_com010_e`cb_update within w_53070_e
end type

type cb_print from w_com010_e`cb_print within w_53070_e
end type

type cb_preview from w_com010_e`cb_preview within w_53070_e
end type

type gb_button from w_com010_e`gb_button within w_53070_e
end type

type cb_excel from w_com010_e`cb_excel within w_53070_e
end type

type dw_head from w_com010_e`dw_head within w_53070_e
integer height = 196
string dataobject = "d_53070_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("emp_no", idw_empno)
idw_empno.SetTransObject(SQLCA)
idw_empno.Retrieve(gs_brand)
idw_empno.InsertRow(0)
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "emp_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
	//	return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "brand"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
		This.SetItem(1, "emp_no", "")	
		This.GetChild("emp_no", idw_empno)
		idw_empno.SetTransObject(SQLCA)
		idw_empno.Retrieve(data)
		idw_empno.InsertRow(0)
	
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_53070_e
integer beginy = 388
integer endy = 388
end type

type ln_2 from w_com010_e`ln_2 within w_53070_e
integer beginy = 392
integer endy = 392
end type

type dw_body from w_com010_e`dw_body within w_53070_e
integer y = 412
string dataobject = "d_53070_d01"
boolean hscrollbar = true
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
Long ll_shop_sale_amt, ll_shop_sale_mileage, ll_edi_amt, ll_yeso_amt,ll_shop_dotc_amt

CHOOSE CASE dwo.name
	CASE "edi_amt" 
		ll_shop_sale_amt = This.GetItemDecimal(row, "shop_sale_amt")
		ll_shop_sale_mileage = This.GetItemDecimal(row, "shop_sale_mileage")

		This.SetItem(row, "m_amt1", ll_shop_sale_amt + ll_shop_sale_mileage - Long(data))

	CASE "dotc_amt"
		ll_shop_dotc_amt = This.GetItemDecimal(row, "shop_dotc_amt")

		This.SetItem(row, "m_amt2", ll_shop_dotc_amt - Long(data))
		
/*
	CASE "yeso_amt"
		ll_shop_sale_amt = This.GetItemDecimal(row, "shop_sale_amt")
		ll_shop_sale_mileage = This.GetItemDecimal(row, "shop_sale_mileage")
		ll_edi_amt = This.GetItemDecimal(row, "edi_amt")		

		This.SetItem(row, "m_amt1", ll_shop_sale_amt + ll_shop_sale_mileage - ll_edi_amt + Long(data))
*/


//		ll_sale_minus = This.GetItemDecimal(row, "sale_minus")
//		If IsNull(ll_sale_minus) Then ll_sale_minus = 0
//		This.SetItem(row, "sale_sum", ll_sale_minus + Long(data))
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_53070_e
string dataobject = "d_53070_r01"
end type

