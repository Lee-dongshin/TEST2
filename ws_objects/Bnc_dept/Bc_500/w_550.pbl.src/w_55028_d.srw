$PBExportHeader$w_55028_d.srw
$PBExportComments$일/월/주단위판매 현황
forward
global type w_55028_d from w_com010_d
end type
type dw_1 from u_dw within w_55028_d
end type
type tab_1 from tab within w_55028_d
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tab_1 from tab within w_55028_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type dw_2 from datawindow within w_55028_d
end type
type dw_3 from datawindow within w_55028_d
end type
end forward

global type w_55028_d from w_com010_d
integer height = 2284
dw_1 dw_1
tab_1 tab_1
dw_2 dw_2
dw_3 dw_3
end type
global w_55028_d w_55028_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_item, idw_sojae, idw_shop_div
String is_brand, is_fr_ymd, is_to_ymd, is_year, is_season, is_sojae, is_item, is_style_opt, is_chno_opt, is_sale_opt, is_dep_except
String is_diff_opt, is_plan_opt, is_chi_opt, is_style
integer ii_tab_chk
string is_shop_div, is_shop_gubn, is_amount_opt

end variables

on w_55028_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.tab_1=create tab_1
this.dw_2=create dw_2
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.dw_3
end on

on w_55028_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.tab_1)
destroy(this.dw_2)
destroy(this.dw_3)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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




is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"품종을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_style_opt = dw_head.GetItemString(1, "style_opt")
if IsNull(is_style_opt) or Trim(is_style_opt) = "" then
   MessageBox(ls_title,"스타일 조건을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_opt")
   return false
end if

is_chno_opt = dw_head.GetItemString(1, "chno_opt")
if IsNull(is_chno_opt) or Trim(is_chno_opt) = "" then
   MessageBox(ls_title,"차수 조건을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("chno_opt")
   return false
end if

is_sale_opt = dw_head.GetItemString(1, "sale_opt")
if IsNull(is_sale_opt) or Trim(is_sale_opt) = "" then
   MessageBox(ls_title,"판매 조건을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_opt")
   return false
end if

is_plan_opt = dw_head.GetItemString(1, "plan_opt")
if IsNull(is_plan_opt) or Trim(is_plan_opt) = "" then
   MessageBox(ls_title," 조건을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("plan_opt")
   return false
end if


is_chi_opt = dw_head.GetItemString(1, "chi_opt")
if IsNull(is_chi_opt) or Trim(is_chi_opt) = "" then
   MessageBox(ls_title,"조건을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("chi_opt")
   return false
end if

is_diff_opt = dw_head.GetItemString(1, "diff_opt")
if IsNull(is_diff_opt) or Trim(is_diff_opt) = "" then
   MessageBox(ls_title,"기간 조건을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("diff_opt")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
 is_style = "%"
end if


is_dep_except = dw_head.GetItemString(1, "dep_except")
if IsNull(is_dep_except) or Trim(is_dep_except) = "" then
 is_dep_except = "N"
end if

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
 is_shop_div = "%"
end if

is_shop_gubn = dw_head.GetItemString(1, "shop_gubn")
if IsNull(is_shop_gubn) or Trim(is_shop_gubn) = "" then
 is_shop_gubn = "%"
end if

is_amount_opt = dw_head.GetItemString(1, "amount_opt")
if IsNull(is_amount_opt) or Trim(is_amount_opt) = "" then
 is_amount_opt = "Q"
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_style_opt = "1" then 
	
	if is_diff_opt = "D" then
	//	messagebox("", "d_55028_d21")
//		dw_body.dataObject = "d_55028_d21"	
		dw_body.dataObject = "d_55028_d81"
		dw_body.SetTransObject(SQLCA)
//		dw_print.dataObject = "d_55028_d21"	
		dw_print.dataObject = "d_55028_d81"
		dw_print.SetTransObject(SQLCA)		
	elseif is_diff_opt = "M" then
	//	messagebox("", "d_55028_d22")
//		dw_body.dataObject = "d_55028_d22"	
		dw_body.dataObject = "d_55028_d82"
		dw_body.SetTransObject(SQLCA)
//		dw_print.dataObject = "d_55028_d22"	
		dw_print.dataObject = "d_55028_d82"
		dw_print.SetTransObject(SQLCA)		
	else	
	//	messagebox("", "d_55028_d23")		
//		dw_body.dataObject = "d_55028_d23"
		dw_body.dataObject = "d_55028_d83"
		dw_body.SetTransObject(SQLCA)		
//		dw_print.dataObject = "d_55028_d23"
		dw_print.dataObject = "d_55028_d83"
		dw_print.SetTransObject(SQLCA)				
	end if
	
elseif is_style_opt = "2" then 	
	
	if is_diff_opt = "D" then
	//	messagebox("", "d_55028_d11")		
//		dw_body.dataObject = "d_55028_d11"
		dw_body.dataObject = "d_55028_d71"
		dw_body.SetTransObject(SQLCA)		
//		dw_print.dataObject = "d_55028_d11"	
		dw_print.dataObject = "d_55028_d71"
		dw_print.SetTransObject(SQLCA)				
	elseif is_diff_opt = "M" then
	//	messagebox("", "d_55028_d12")		
//		dw_body.dataObject = "d_55028_d12"	
		dw_body.dataObject = "d_55028_d72"	
		dw_body.SetTransObject(SQLCA)	
//		dw_print.dataObject = "d_55028_d12"	
		dw_print.dataObject = "d_55028_d72"	
		dw_print.SetTransObject(SQLCA)			
	else	
	//	messagebox("", "d_55028_d13")		
//		dw_body.dataObject = "d_55028_d13"		
		dw_body.dataObject = "d_55028_d73"
		dw_body.SetTransObject(SQLCA)		
//		dw_print.dataObject = "d_55028_d13"		
		dw_print.dataObject = "d_55028_d73"
		dw_print.SetTransObject(SQLCA)				
	end if

	
else
	
	if is_diff_opt = "D" then
	//	messagebox("", "d_55028_d01")		
//		dw_body.dataObject = "d_55028_d01"	
		dw_body.dataObject = "d_55028_d61"
		dw_body.SetTransObject(SQLCA)		
//		dw_print.dataObject = "d_55028_d01"	
		dw_print.dataObject = "d_55028_d61"	
		dw_print.SetTransObject(SQLCA)			
	elseif is_diff_opt = "M" then
	//	messagebox("", "d_55028_d02")		
//		dw_body.dataObject = "d_55028_d02"	
		dw_body.dataObject = "d_55028_d62"
		dw_body.SetTransObject(SQLCA)	
//		dw_print.dataObject = "d_55028_d02"	
		dw_print.dataObject = "d_55028_d62"
		dw_print.SetTransObject(SQLCA)			
	else	
	//	messagebox("", "d_55028_d03")		
//		dw_body.dataObject = "d_55028_d03"		
		dw_body.dataObject = "d_55028_d63"
		dw_body.SetTransObject(SQLCA)		
//		dw_print.dataObject = "d_55028_d03"
		dw_print.dataObject = "d_55028_d63"
		dw_print.SetTransObject(SQLCA)				
	end if
	
end if	

//@ps_fr_ymd, @ps_to_ymd, @ps_brand, @ps_year, @ps_season, @ps_sojae, @ps_item, 
//@ps_chno_gubun, @ps_chn, @ps_except,@ps_plan_dc, @ps_sale_gubn
if dw_body.visible = true then
	il_rows =  dw_body.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_year, is_season, is_sojae, is_item, is_chno_opt, is_chi_opt, "%", is_plan_opt, is_sale_opt, is_style, is_dep_except)

	IF il_rows > 0 THEN
		
		dw_body.SetFocus()
	ELSEIF il_rows = 0 THEN
		MessageBox("조회", "조회할 자료가 없습니다.")
	ELSE
		MessageBox("조회오류", "조회 실패 하였습니다.")
	END IF
elseif dw_3.visible = true then
//	messagebox("", is_fr_ymd + "/" + is_to_ymd+ "/" + is_brand+ "/" + is_year+ "/" + is_season+ "/" + is_sojae+ "/" + is_item+ "/" + is_chno_opt+ "/" + is_style_opt+ "/" +  "%"+ "/" + is_plan_opt+ "/" + is_sale_opt+ "/" + is_style+ "/" + is_dep_except+ "/" + is_shop_div+ "/" + is_shop_gubn+ "/" + is_amount_opt+ "/" + is_diff_opt)
	
	il_rows =  dw_3.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_year, is_season, is_sojae, is_item, is_chno_opt, is_style_opt,  "%", is_plan_opt, is_sale_opt, is_style, is_dep_except, is_shop_div, is_shop_gubn, is_diff_opt,is_amount_opt)

	IF il_rows > 0 THEN
		
		dw_3.SetFocus()
	ELSEIF il_rows = 0 THEN
		MessageBox("조회", "조회할 자료가 없습니다.")
	ELSE
		MessageBox("조회오류", "조회 실패 하였습니다.")
	END IF	
	
else
	dw_print.dataObject = "d_55028_d31"		
	dw_print.SetTransObject(SQLCA)	
			
	if is_dep_except = 'Y'	then
		is_dep_except = '%'	
	else
		is_dep_except = 'Y'
	end if
	
	il_rows =  dw_1.retrieve( is_brand, is_year, is_season, is_sojae, is_item, is_chno_opt, is_plan_opt, is_chi_opt, is_sale_opt, is_style,is_dep_except)
	il_rows =  dw_2.retrieve( is_brand, is_year, is_season, is_sojae, is_item, is_chno_opt, is_plan_opt, is_chi_opt, is_sale_opt, is_style,is_dep_except)
	IF il_rows > 0 THEN
		dw_1.SetFocus()
	ELSEIF il_rows = 0 THEN
		MessageBox("조회", "조회할 자료가 없습니다.")
	ELSE
		MessageBox("조회오류", "조회 실패 하였습니다.")
	END IF
end if


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55028_d","0")
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_3, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)

end event

event ue_excel();string ls_doc_nm, ls_nm

integer li_ret,li_ret1
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
if dw_body.visible = true then
//	li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
   li_ret1 = MessageBox("저장형식 선택",  "화면과 같은 양식을 원하시면 Yes! 기초데이터를 원하시면 No! 를 선택해주세요! 파일 오픈시 확인 메시지는 무시하고 열어 주세요! ",  Question!, YesNo!)
	if li_ret1 = 1 then
		li_ret = dw_body.SaveAsascii(ls_doc_nm) //, Excel!, TRUE)
	else 	
		li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
	end if	
	
	
elseif dw_3.visible = true then
	
   li_ret1 = MessageBox("저장형식 선택",  "화면과 같은 양식을 원하시면 Yes! 기초데이터를 원하시면 No! 를 선택해주세요! 파일 오픈시 확인 메시지는 무시하고 열어 주세요! ",  Question!, YesNo!)
	if li_ret1 = 1 then
		li_ret = dw_3.SaveAsascii(ls_doc_nm) //, Excel!, TRUE)
	else 	
		li_ret = dw_3.SaveAs(ls_doc_nm, Excel!, TRUE)
	end if	

else	
//	li_ret = dw_2.SaveAs(ls_doc_nm, Excel!, TRUE)
  li_ret1 = MessageBox("저장형식 선택",  "화면과 같은 양식을 원하시면 Yes! 기초데이터를 원하시면 No! 를 선택해주세요! 파일 오픈시 확인 메시지는 무시하고 열어 주세요! ",  Question!, YesNo!)
	if li_ret1 = 1 then
		li_ret = dw_2.SaveAsascii(ls_doc_nm) //, Excel!, TRUE)
	else 	
		li_ret = dw_2.SaveAs(ls_doc_nm, Excel!, TRUE)
	end if		
	
end if

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event ue_preview();This.Trigger Event ue_title ()

if dw_1.visible = true then
	dw_1.ShareData(dw_print)
else	
	//dw_body.ShareData(dw_print)	
   dw_print.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_year, is_season, is_sojae, is_item, is_chno_opt, is_chi_opt, "%", is_plan_opt, is_sale_opt, is_style,is_dep_except)
	
end if	

dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();
This.Trigger Event ue_title()

if dw_1.visible = false then
	dw_print.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_year, is_season, is_sojae, is_item, is_chno_opt, is_chi_opt, "%", is_plan_opt, is_sale_opt, is_style,is_dep_except)
	dw_body.ShareData(dw_print)
else	
	dw_1.ShareData(dw_print)
end if	

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_cust_nm , ls_style, ls_chno ,ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_brand
long		  ll_tag_price 	
Boolean    lb_check 
DataStore  lds_Source

ls_brand = dw_head.getitemstring(1, "brand")

CHOOSE CASE as_column
	
			CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com011" 
				gst_cd.default_where   = " WHERE brand =  '" + ls_brand + "' "
				if gs_brand <> 'K' then					
					IF Trim(as_data) <> "" THEN
						gst_cd.Item_where = " style LIKE ~'" + as_data + "%~'"
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
								
       					/* 다음컬럼으로 이동 */
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

type cb_close from w_com010_d`cb_close within w_55028_d
end type

type cb_delete from w_com010_d`cb_delete within w_55028_d
end type

type cb_insert from w_com010_d`cb_insert within w_55028_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55028_d
end type

type cb_update from w_com010_d`cb_update within w_55028_d
end type

type cb_print from w_com010_d`cb_print within w_55028_d
end type

type cb_preview from w_com010_d`cb_preview within w_55028_d
end type

type gb_button from w_com010_d`gb_button within w_55028_d
end type

type cb_excel from w_com010_d`cb_excel within w_55028_d
end type

type dw_head from w_com010_d`dw_head within w_55028_d
integer x = 5
integer y = 176
integer width = 3579
integer height = 288
string dataobject = "d_55028_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_BRAND, 	'%')

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')


This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')



end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		 if data <> "%" and LenA(data) > 2 then
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		 end if	
		 

	
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
		
		THIS.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', data)
		idw_sojae.InsertRow(1)
		idw_sojae.SetItem(1, "sojae", '%')
		idw_sojae.SetItem(1, "sojae_nm", '전체')
		
		THIS.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve( data )
		idw_item.InsertRow(1)
		idw_item.SetItem(1, "item", '%')
		idw_item.SetItem(1, "item_nm", '전체')
		
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

type ln_1 from w_com010_d`ln_1 within w_55028_d
integer beginy = 476
integer endy = 476
end type

type ln_2 from w_com010_d`ln_2 within w_55028_d
integer beginy = 480
integer endy = 480
end type

type dw_body from w_com010_d`dw_body within w_55028_d
boolean visible = false
integer x = 37
integer y = 584
integer width = 3566
integer height = 1448
string dataobject = "d_55028_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_55028_d
integer x = 585
integer y = 264
end type

type dw_1 from u_dw within w_55028_d
integer x = 37
integer y = 588
integer width = 3520
integer height = 1448
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_55028_d31"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type tab_1 from tab within w_55028_d
integer x = 23
integer y = 484
integer width = 3547
integer height = 1564
integer taborder = 40
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
end type

event selectionchanged;ii_tab_chk = newindex

Choose Case newindex
	Case 1
		dw_body.Visible = false
		dw_1.Visible = true
		dw_3.Visible = false
		dw_head.object.shop_div_t.visible = 0
		dw_head.object.shop_div.visible = 0
		dw_head.object.shop_gubn.visible = 0		
		dw_head.object.amount_opt.visible = 0				
	Case 2
		dw_body.Visible = true
		dw_1.Visible = false
		dw_3.Visible = false		
		dw_head.object.shop_div_t.visible = 0
		dw_head.object.shop_div.visible = 0
		dw_head.object.shop_gubn.visible = 0		
		dw_head.object.amount_opt.visible = 0				
		
		
	Case 3
		dw_body.Visible = false
		dw_1.Visible = false
		dw_3.Visible = true
		dw_head.object.shop_div_t.visible = 1
		dw_head.object.shop_div.visible = 1
		dw_head.object.shop_gubn.visible = 1		
		dw_head.object.amount_opt.visible = 1				



End Choose
end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3511
integer height = 1452
long backcolor = 79741120
string text = "스타일정보"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3511
integer height = 1452
long backcolor = 79741120
string text = "기간별판매"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3511
integer height = 1452
long backcolor = 79741120
string text = "기간별판매/유통망/금액/수량"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type dw_2 from datawindow within w_55028_d
boolean visible = false
integer x = 37
integer y = 584
integer width = 3566
integer height = 1448
integer taborder = 110
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_55028_d41"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_3 from datawindow within w_55028_d
boolean visible = false
integer x = 37
integer y = 584
integer width = 3520
integer height = 1448
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_55028_d91"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

