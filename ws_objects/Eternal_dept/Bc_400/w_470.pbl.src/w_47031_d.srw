$PBExportHeader$w_47031_d.srw
$PBExportComments$온라인 반품현황
forward
global type w_47031_d from w_com010_d
end type
type tab_1 from tab within w_47031_d
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tabpage_4 from userobject within tab_1
end type
type dw_4 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_4 dw_4
end type
type tabpage_5 from userobject within tab_1
end type
type dw_5 from datawindow within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_5 dw_5
end type
type tab_1 from tab within w_47031_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
end forward

global type w_47031_d from w_com010_d
integer width = 3675
integer height = 2256
string title = "온라인반품현황"
tab_1 tab_1
end type
global w_47031_d w_47031_d

type variables
DataWindowChild idw_judg_fg, idw_judg_s, idw_cust_fg_s
DataWindowChild idw_decision_a, idw_decision_b, idw_decision_c, idw_decision_d 

DataWindowChild idw_brand, idw_year, idw_season
String  is_fr_ymd, is_to_ymd, is_brand, is_year, is_season, is_style, is_shop_cd, is_fr_rtrn_sale, is_to_rtrn_sale
Boolean lb_ret_chk1 = False, lb_ret_chk2 = False, lb_ret_chk3 = False, lb_ret_chk4 = False, lb_ret_chk5 = False, lb_ret_chk6 = False, lb_ret_chk7 = False

end variables

on w_47031_d.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_47031_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_datetime
IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

//dw_head.SetItem(1, "base_yymm", ld_datetime)

ls_datetime = String(ld_datetime, "yyyymmdd")

dw_head.setitem(1, 'fr_ymd',MidA(ls_datetime,1,6)+'01')
dw_head.setitem(1, 'to_ymd',ls_datetime)
dw_head.setitem(1, 'fr_rtrn_sale',MidA(ls_datetime,1,6)+'01')
dw_head.setitem(1, 'to_rtrn_sale',ls_datetime)
dw_head.setitem(1, 'brand', '%')
dw_head.setitem(1, 'shop_cd', '')
dw_head.setitem(1, 'style', '')
end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_3.dw_3, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_4.dw_4, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_5.dw_5, "ScaleToRight&Bottom")


tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)
tab_1.tabpage_4.dw_4.SetTransObject(SQLCA)
tab_1.tabpage_5.dw_5.SetTransObject(SQLCA)


end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
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

 
is_fr_ymd =  dw_head.GetItemstring(1, "fr_ymd")
if IsNull(is_fr_ymd) OR is_fr_ymd = "" then
   MessageBox(ls_title,"from년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

//messagebox('1', 'is_fr_yymm =' + is_fr_yymm )

is_to_ymd =  dw_head.GetItemstring(1, "to_ymd")
if IsNull(is_to_ymd) OR is_to_ymd = "" then
   MessageBox(ls_title,"to년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_fr_rtrn_sale =  dw_head.GetItemstring(1, "fr_rtrn_sale")
if IsNull(is_fr_rtrn_sale) OR is_fr_rtrn_sale = "" then
   MessageBox(ls_title,"반품일자 from년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_rtrn_sale")
   return false
end if

//messagebox('1', 'is_fr_yymm =' + is_fr_yymm )

is_to_rtrn_sale =  dw_head.GetItemstring(1, "to_rtrn_sale")
if IsNull(is_to_rtrn_sale) OR is_to_rtrn_sale = "" then
   MessageBox(ls_title,"반품일자 to년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_rtrn_sale")
   return false
end if

is_brand =  dw_head.GetItemstring(1, "brand")
if IsNull(is_brand) OR is_brand = "" then
   MessageBox(ls_title,"브랜드를 입력하세요")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_style =  dw_head.GetItemstring(1, "style")
if IsNull(is_style) OR is_style = "" then
   dw_head.SetFocus()
   dw_head.SetColumn("style")
end if

is_shop_cd =  dw_head.GetItemstring(1, "shop_cd")
if IsNull(is_shop_cd) OR is_shop_cd = "" then
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
end if

/*
is_opt =  dw_head.GetItemstring(1, "opt_view")
is_receipt_type =  dw_head.GetItemstring(1, "receipt_type")
is_year =  dw_head.GetItemstring(1, "year")
is_season =  dw_head.GetItemstring(1, "season")
*/
return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)
tab_1.tabpage_4.dw_4.SetTransObject(SQLCA)
tab_1.tabpage_5.dw_5.SetTransObject(SQLCA)

 
		Choose Case tab_1.SelectedTab
			Case 1
				il_rows = tab_1.tabpage_1.dw_1.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_fr_rtrn_sale, is_to_rtrn_sale)
				lb_ret_chk1 = True
			Case 2
				il_rows = tab_1.tabpage_2.dw_2.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_style, is_fr_rtrn_sale, is_to_rtrn_sale)
				lb_ret_chk2 = True
			Case 3
				il_rows = tab_1.tabpage_3.dw_3.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_shop_cd, is_fr_rtrn_sale, is_to_rtrn_sale)
				lb_ret_chk3 = True
			Case 4
				il_rows = tab_1.tabpage_4.dw_4.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_fr_rtrn_sale, is_to_rtrn_sale)			
				lb_ret_chk4 = True
			Case 5
				il_rows = tab_1.tabpage_5.dw_5.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_fr_rtrn_sale, is_to_rtrn_sale)
				lb_ret_chk1 = True
		END Choose

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

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
//         cb_retrieve.Text = "조건(&Q)"
//         dw_head.Enabled = false
//         dw_body.Enabled = true
//         tab_1.Enabled = true
//         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
//		dw_body.Enabled = false
//		tab_1.Enabled = false
//		lb_ret_chk1 = False
//		lb_ret_chk2 = False
//		lb_ret_chk3 = False
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

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
Choose Case Tab_1.SelectedTab
	Case 1
		li_ret = Tab_1.TabPage_1.dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 2
		li_ret = Tab_1.TabPage_2.dw_2.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 3
		li_ret = Tab_1.TabPage_3.dw_3.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 4
		li_ret = Tab_1.TabPage_4.dw_4.SaveAs(ls_doc_nm, Excel!, TRUE)
	Case 5
		li_ret = Tab_1.TabPage_5.dw_5.SaveAs(ls_doc_nm, Excel!, TRUE)		
End Choose

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_47031_d","0")
end event

event ue_title();/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
				 "t_fr_yymm.Text = '" + is_fr_ymd + "'" + &
				 "t_to_yymm.Text = '" + is_to_ymd + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"   



dw_print.object.t_pg_id.Text = is_pgm_id
dw_print.object.t_user_id.Text = gs_user_id
dw_print.object.t_fr_yymm.Text = is_fr_ymd
dw_print.object.t_to_yymm.Text = is_to_ymd
dw_print.object.t_datetime.Text = ls_datetime
dw_print.object.t_title.Text = ls_title

dw_print.Modify(ls_modify)



end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

//This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로

datetime ld_datetime
string ls_modify, ls_datetime, ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

dw_print.object.t_pg_id.Text = is_pgm_id
dw_print.object.t_user_id.Text = gs_user_id
dw_print.object.t_fr_yymm.Text = is_fr_ymd
dw_print.object.t_to_yymm.Text = is_to_ymd
dw_print.object.t_datetime.Text = ls_datetime

dw_print.dataobject = "d_47031_r10"
dw_print.SetTransObject(SQLCA)		  
il_rows = dw_print.retrieve(is_fr_ymd,is_to_ymd, is_brand, is_fr_rtrn_sale, is_to_rtrn_sale, is_shop_cd)		  


dw_print.inv_printpreview.of_SetZoom()


end event

event ue_print();This.Trigger Event ue_title()
dw_print.dataobject = "d_47031_r10"
dw_print.SetTransObject(SQLCA)		  
il_rows = dw_print.retrieve(is_fr_ymd,is_to_ymd, is_brand, is_fr_rtrn_sale, is_to_rtrn_sale, is_shop_cd)		  

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.20                                                  */	
/* 수정일      : 2002.03.20                                                  */
/*===========================================================================*/
String     ls_card_no, ls_jumin, ls_custom_nm, ls_tel_no1, ls_tel_no2, ls_tel_no3, ls_null, ls_tel_no, ls_user_name,ls_part_nm, ls_brand
String     ls_style_no, ls_year, ls_season, ls_sojae, ls_item, ls_st_cust_cd, ls_st_cust_nm, ls_mat_cust_cd, ls_mat_cust_nm, ls_mat_cd, ls_mat_nm
Integer    li_sex, li_return, li_okyes
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

SetNull(ls_null)

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
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV  IN ('B', 'E','D') " 
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
				
			//	ls_shop_nm = lds_Source.GetItemString(1,"shop_cd")
			//	messagebox("", ls_shop_nm)
				
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			
		CASE "style"				
			
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "STYLE", "")
					RETURN 0
				END IF 
			END IF
			
			// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				if gs_brand <> 'K' then
					gst_cd.default_where   = " WHERE 1 = 1 "
				else 
					gst_cd.default_where = ""
				end if
				
				if gs_brand <> 'K' then
					IF Trim(as_data) <> "" THEN
						gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
					ELSE
						gst_cd.Item_where = ""
					END IF
				else 
					gst_cd.Item_where = ""
				end if
				
				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm

					dw_head.SetRow(al_row)
					dw_head.SetColumn(as_column)
            
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
//					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
								
      
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("chno")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
//			END IF
			
			
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

type cb_close from w_com010_d`cb_close within w_47031_d
end type

type cb_delete from w_com010_d`cb_delete within w_47031_d
end type

type cb_insert from w_com010_d`cb_insert within w_47031_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_47031_d
end type

type cb_update from w_com010_d`cb_update within w_47031_d
end type

type cb_print from w_com010_d`cb_print within w_47031_d
end type

type cb_preview from w_com010_d`cb_preview within w_47031_d
end type

type gb_button from w_com010_d`gb_button within w_47031_d
end type

type cb_excel from w_com010_d`cb_excel within w_47031_d
end type

type dw_head from w_com010_d`dw_head within w_47031_d
integer y = 156
integer width = 3525
integer height = 188
string dataobject = "d_47031_h01"
end type

event dw_head::itemchanged;call super::itemchanged;lb_ret_chk1 = False
lb_ret_chk2 = False
lb_ret_chk3 = False
lb_ret_chk4 = False
//lb_ret_chk5 = False

String ls_yymmdd

CHOOSE CASE dwo.name

	CASE "shop_cd"	    //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')

/*
This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')
*/
end event

type ln_1 from w_com010_d`ln_1 within w_47031_d
integer beginx = 14
integer beginy = 352
integer endx = 3634
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_47031_d
integer beginx = 14
integer beginy = 356
integer endx = 3634
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_47031_d
boolean visible = false
integer y = 376
integer height = 1664
boolean enabled = false
end type

type dw_print from w_com010_d`dw_print within w_47031_d
integer x = 110
integer y = 296
integer height = 384
string dataobject = "d_47031_r10"
end type

type tab_1 from tab within w_47031_d
event type boolean ue_keycheck ( string as_cb_div )
integer x = 14
integer y = 372
integer width = 3579
integer height = 1648
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
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

 
 
is_fr_ymd =  dw_head.GetItemstring(1, "fr_ymd")
if IsNull(is_fr_ymd) OR is_fr_ymd = "" then
   MessageBox(ls_title,"from년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

//messagebox('1', 'is_fr_yymm =' + is_fr_yymm )

is_to_ymd =  dw_head.GetItemstring(1, "to_ymd")
if IsNull(is_to_ymd) OR is_to_ymd = "" then
   MessageBox(ls_title,"to년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_fr_rtrn_sale =  dw_head.GetItemstring(1, "fr_rtrn_sale")
if IsNull(is_fr_rtrn_sale) OR is_fr_rtrn_sale = "" then
   MessageBox(ls_title,"반품일자 from년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_rtrn_sale")
   return false
end if

//messagebox('1', 'is_fr_yymm =' + is_fr_yymm )

is_to_rtrn_sale =  dw_head.GetItemstring(1, "to_rtrn_sale")
if IsNull(is_to_rtrn_sale) OR is_to_rtrn_sale = "" then
   MessageBox(ls_title,"반품일자 to년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_rtrn_sale")
   return false
end if

is_brand =  dw_head.GetItemstring(1, "brand")
if IsNull(is_brand) OR is_brand = "" then
   MessageBox(ls_title,"브랜드를 입력하세요")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_style =  dw_head.GetItemstring(1, "style")
if IsNull(is_style) OR is_style = "" then
   dw_head.SetFocus()
   dw_head.SetColumn("style")
end if

is_shop_cd =  dw_head.GetItemstring(1, "shop_cd")
if IsNull(is_shop_cd) OR is_shop_cd = "" then
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
end if


return true

end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

event selectionchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
If oldindex > 0 Then
	
	/* dw_head 필수입력 column check */
	IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
	
	 
			Choose Case newindex
				Case 1
					If lb_ret_chk1 = False Then
						il_rows = This.Tabpage_1.dw_1.Retrieve(is_fr_ymd, is_to_ymd, is_brand, is_fr_rtrn_sale, is_to_rtrn_sale)
						lb_ret_chk1 = True
					End If
				Case 2
					If lb_ret_chk2 = False Then
						il_rows = This.Tabpage_2.dw_2.Retrieve(is_fr_ymd, is_to_ymd, is_brand, is_style, is_fr_rtrn_sale, is_to_rtrn_sale)
						lb_ret_chk2 = True
					End If
				Case 3
					If lb_ret_chk3 = False Then
						il_rows = This.Tabpage_3.dw_3.Retrieve(is_fr_ymd, is_to_ymd, is_brand, is_shop_cd, is_fr_rtrn_sale, is_to_rtrn_sale)
						lb_ret_chk3 = True
					End If
				Case 4
					If lb_ret_chk4 = False Then
						il_rows = This.Tabpage_4.dw_4.Retrieve(is_fr_ymd, is_to_ymd, is_brand, is_fr_rtrn_sale, is_to_rtrn_sale)
						lb_ret_chk4 = True
					End If
				Case 5
					If lb_ret_chk5 = False Then
						il_rows = This.Tabpage_5.dw_5.Retrieve(is_fr_ymd, is_to_ymd, is_brand, is_fr_rtrn_sale, is_to_rtrn_sale)
						lb_ret_chk1 = True
					End If
			End Choose
	   
End If

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3543
integer height = 1536
long backcolor = 79741120
string text = "브랜드별 반품접수내역"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within tabpage_1
integer y = 8
integer width = 3538
integer height = 1524
integer taborder = 20
string title = "none"
string dataobject = "d_47031_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3543
integer height = 1536
long backcolor = 79741120
string text = "품번별 반품접수내역"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_2
integer y = 8
integer width = 3515
integer height = 1524
integer taborder = 10
string title = "none"
string dataobject = "d_47031_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3543
integer height = 1536
long backcolor = 79741120
string text = "사이트별 반품접수내역"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from datawindow within tabpage_3
integer y = 8
integer width = 3515
integer height = 1504
integer taborder = 10
string title = "none"
string dataobject = "d_47031_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;////claim_qty7
//long ll_cnt
//string ls_brand
//
//tab_1.tabpage_3.dw_3.accepttext()
//ls_brand = tab_1.tabpage_3.dw_3.getitemstring(getrow(),'brand')
//ll_cnt = tab_1.tabpage_3.dw_3.getitemnumber(getrow(),'claim_qty7')
//
//CHOOSE CASE dwo.name
//	CASE "claim_qty7"      //  Popup 검색창이 존재하는 항목 
//
//		IF ib_itemchanged THEN RETURN 1
//		if isnull(ll_cnt) or ll_cnt < 1 then 
//			return 1
//		end if		
//		dw_9.retrieve(ls_brand, is_fr_yymm, is_to_yymm, is_year, is_season)
//		IF ll_cnt > 0 THEN
//			dw_9.visible = true
//		ELSE
//			dw_9.visible = false
//		END IF
//END CHOOSE
end event

type tabpage_4 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 3543
integer height = 1536
long backcolor = 79741120
string text = "월별 반품접수내역"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_4 dw_4
end type

on tabpage_4.create
this.dw_4=create dw_4
this.Control[]={this.dw_4}
end on

on tabpage_4.destroy
destroy(this.dw_4)
end on

type dw_4 from datawindow within tabpage_4
integer y = 8
integer width = 3538
integer height = 1524
integer taborder = 110
string title = "none"
string dataobject = "d_47031_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3543
integer height = 1536
long backcolor = 79741120
string text = "반품상세내역"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_5.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_5.destroy
destroy(this.dw_5)
end on

type dw_5 from datawindow within tabpage_5
integer y = 8
integer width = 3538
integer height = 1524
integer taborder = 20
string dataobject = "d_47031_d05"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

