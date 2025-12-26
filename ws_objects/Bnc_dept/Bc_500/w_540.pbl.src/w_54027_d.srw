$PBExportHeader$w_54027_d.srw
$PBExportComments$RT분석표
forward
global type w_54027_d from w_com010_d
end type
type dw_1 from datawindow within w_54027_d
end type
end forward

global type w_54027_d from w_com010_d
dw_1 dw_1
end type
global w_54027_d w_54027_d

type variables
DataWindowChild idw_brand, idw_empno, idw_reg_id
String is_brand, is_frm_ymd, is_to_ymd, is_shop_cd, is_opt_gubn, is_empno, is_reg_id
end variables

on w_54027_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_54027_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
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


//if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
//   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false	
//elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false		
//elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false			
//end if	
//





if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	



is_frm_ymd = dw_head.GetItemString(1, "frm_ymd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"조회시작일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"조회마지막일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
 is_shop_cd = "%"
end if

is_opt_gubn = dw_head.GetItemString(1, "opt_gubn")
if IsNull(is_opt_gubn) or Trim(is_opt_gubn) = "" then
   MessageBox(ls_title,"조회기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_gubn")
   return false
end if

is_empno = dw_head.GetItemString(1, "empno")
if IsNull(is_empno) or Trim(is_empno) = "" then
 is_empno = "%"
end if

is_reg_id = dw_head.GetItemString(1, "reg_id")
if IsNull(is_reg_id) or Trim(is_reg_id) = "" then
 is_reg_id = "%"
end if

return true

end event

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_ymd", MidA(string(ld_datetime, "yyyymmdd"),1,6) + "01")
dw_head.SetItem(1, "to_ymd", string(ld_datetime, "yyyymmdd"))
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


//exec sp_54027_d02 'n','20041206','20041207','%','a01020'


		if is_opt_gubn = "A" then 
			dw_body.DataObject = "d_54027_d01"
			dw_body.SetTransObject(SQLCA)
			
			dw_1.DataObject = "d_54027_d11"
			dw_1.SetTransObject(SQLCA)
			
			dw_print.DataObject = "d_54027_r01"
			dw_print.SetTransObject(SQLCA)
			
		else	
			dw_body.DataObject = "d_54027_d02"
			dw_body.SetTransObject(SQLCA)
			
			dw_1.DataObject = "d_54027_d12"
			dw_1.SetTransObject(SQLCA)
			
			dw_print.DataObject = "d_54027_r02"
			dw_print.SetTransObject(SQLCA)
			
		end if	


il_rows = dw_body.retrieve(is_brand, is_frm_ymd, is_to_ymd, is_shop_cd, is_empno, is_reg_id)
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
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_rt_gubn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

//ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
//
//if is_out_gubn = "A" then
//	ls_rt_gubn = "전량"
//else
//	ls_rt_gubn = "부분"
//end if	
//
ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "' " + &				
				"t_fr_ymd.Text = '" + is_frm_ymd + "' "   + &
				"t_to_ymd.Text = '" + is_to_ymd + "' "  		
				

dw_print.Modify(ls_modify)


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
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("out_gubn")
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

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
dw_1.SetTransObject(SQLCA)
end event

event ue_excel();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)

if dw_1.visible then 
	li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
else	
	li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
end if

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_close from w_com010_d`cb_close within w_54027_d
end type

type cb_delete from w_com010_d`cb_delete within w_54027_d
end type

type cb_insert from w_com010_d`cb_insert within w_54027_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_54027_d
end type

type cb_update from w_com010_d`cb_update within w_54027_d
end type

type cb_print from w_com010_d`cb_print within w_54027_d
end type

type cb_preview from w_com010_d`cb_preview within w_54027_d
end type

type gb_button from w_com010_d`gb_button within w_54027_d
end type

type cb_excel from w_com010_d`cb_excel within w_54027_d
end type

type dw_head from w_com010_d`dw_head within w_54027_d
integer height = 216
string dataobject = "d_54027_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("empno", idw_empno)
idw_empno.SetTransObject(SQLCA)
idw_empno.Retrieve(gs_brand)
idw_empno.InsertRow(0)

This.GetChild("reg_id", idw_reg_id)
idw_reg_id.SetTransObject(SQLCA)
idw_reg_id.Retrieve(gs_brand)
idw_reg_id.InsertRow(0)

end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name

   CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "empno"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
	//	return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"empno","")
		This.GetChild("empno", idw_empno)
		idw_empno.SetTransObject(SQLCA)
		idw_empno.Retrieve(data)
		idw_empno.InsertRow(0)		
		
		this.setitem(1,"reg_id","")
		This.GetChild("reg_id", idw_reg_id)
		idw_reg_id.SetTransObject(SQLCA)
		idw_reg_id.Retrieve(data)
		idw_reg_id.InsertRow(0)		


	CASE "opt_gubn"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if data = "A" then 
			dw_body.DataObject = "d_54027_d01"
			dw_body.SetTransObject(SQLCA)
			
			dw_1.DataObject = "d_54027_d11"
			dw_1.SetTransObject(SQLCA)
		else	
			dw_body.DataObject = "d_54027_d02"
			dw_body.SetTransObject(SQLCA)
			
			dw_1.DataObject = "d_54027_d12"
			dw_1.SetTransObject(SQLCA)
		end if	
END CHOOSE


end event

type ln_1 from w_com010_d`ln_1 within w_54027_d
integer beginy = 400
integer endy = 400
end type

type ln_2 from w_com010_d`ln_2 within w_54027_d
integer beginy = 404
integer endy = 404
end type

type dw_body from w_com010_d`dw_body within w_54027_d
integer y = 420
integer height = 1620
string dataobject = "d_54027_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;String ls_shop_cd
long ll_rows


ls_shop_cd = dw_body.getitemstring(row, "shop_cd")

if is_opt_gubn = "A" then 
	dw_1.DataObject = "d_54027_d11"
	dw_1.SetTransObject(SQLCA)
else	
	dw_1.DataObject = "d_54027_d12"
	dw_1.SetTransObject(SQLCA)
end if	


ll_rows = dw_1.retrieve(is_brand, is_frm_ymd, is_to_ymd, ls_shop_cd)

IF ll_rows > 0 THEN
   dw_1.visible = true
   dw_1.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
   dw_1.visible = false
END IF
end event

type dw_print from w_com010_d`dw_print within w_54027_d
end type

type dw_1 from datawindow within w_54027_d
boolean visible = false
integer x = 5
integer y = 420
integer width = 3589
integer height = 1620
integer taborder = 40
string title = "none"
string dataobject = "d_54027_d11"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;dw_1.visible = false
end event

