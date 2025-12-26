$PBExportHeader$w_53090_d.srw
$PBExportComments$브랜드별 매출속보
forward
global type w_53090_d from w_com010_d
end type
type dw_1 from u_dw within w_53090_d
end type
end forward

global type w_53090_d from w_com010_d
dw_1 dw_1
end type
global w_53090_d w_53090_d

type variables
DatawindowChild	idw_brand, idw_shop_type, idw_empno, idw_shop_div


String is_brand , is_yymm, is_yymm_vs, is_shop_type, is_empno, is_gubn, is_shop_div, is_nt_code, is_amt_gubn
end variables

on w_53090_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_53090_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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




is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if


is_yymm_vs = dw_head.GetItemString(1, "yymm_vs")
if IsNull(is_yymm_vs) or Trim(is_yymm_vs) = "" then
	is_yymm_vs = String(long(LeftA(is_yymm,4)) - 1) +RightA(is_yymm,2)
end if



is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"판매형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if



is_empno = Trim(dw_head.GetItemString(1, "empno"))
if IsNull(is_empno) or is_empno = "" then
	is_empno = '%'
end if


is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
if IsNull(is_shop_div) or is_shop_div = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if


is_nt_code = dw_head.GetItemString(1, "nt_code")


is_amt_gubn = dw_head.GetItemString(1, "amt_gubn")


return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec SP_55026_D01 '200503' , 'n','%', '%', 'a'
il_rows = dw_1.retrieve(is_yymm, is_yymm_vs, is_brand, is_empno, is_shop_type, is_shop_div, is_nt_code, is_amt_gubn)

il_rows = dw_body.retrieve(is_yymm, is_yymm_vs, is_brand, is_empno, is_shop_type, is_shop_div, is_nt_code, is_amt_gubn)


IF il_rows > 0 THEN
   dw_1.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight")
dw_1.SetTransObject(sqlca)
end event

event open;call super::open;dw_1.Object.DataWindow.HorizontalScrollSplit  = 2005
dw_body.Object.DataWindow.HorizontalScrollSplit  = 2005


dw_head.Setitem(1,'nt_code', 'Y')

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
li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)

//   li_ret = MessageBox("저장형식 선택",  "화면과 같은 양식을 원하시면 Yes! 기초데이터를 원하시면 No! 를 선택해주세요! 파일 오픈시 확인 메시지는 무시하고 열어 주세요! ",  Question!, YesNo!)
//	if li_ret = 1 then
//		li_ret = dw_body.SaveAsascii(ls_doc_nm) //, Excel!, TRUE)
//	else 	
//		li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
//	end if	

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_close from w_com010_d`cb_close within w_53090_d
end type

type cb_delete from w_com010_d`cb_delete within w_53090_d
end type

type cb_insert from w_com010_d`cb_insert within w_53090_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_53090_d
end type

type cb_update from w_com010_d`cb_update within w_53090_d
end type

type cb_print from w_com010_d`cb_print within w_53090_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_53090_d
integer width = 448
string text = "브랜드Excel(&V)"
end type

event cb_preview::clicked;/*===========================================================================*/
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
li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)

//   li_ret = MessageBox("저장형식 선택",  "화면과 같은 양식을 원하시면 Yes! 기초데이터를 원하시면 No! 를 선택해주세요! 파일 오픈시 확인 메시지는 무시하고 열어 주세요! ",  Question!, YesNo!)
//	if li_ret = 1 then
//		li_ret = dw_1.SaveAsascii(ls_doc_nm) //, Excel!, TRUE)
//	else 	
//		li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
//	end if	

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type gb_button from w_com010_d`gb_button within w_53090_d
end type

type cb_excel from w_com010_d`cb_excel within w_53090_d
integer x = 2213
integer width = 384
string text = "매장Excel(&E)"
end type

type dw_head from w_com010_d`dw_head within w_53090_d
integer y = 180
integer height = 232
string dataobject = "d_53090_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('009')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '0')
idw_shop_type.SetItem(1, "inter_nm", '기타제외')


This.GetChild("empno", idw_empno)
idw_empno.SetTransObject(SQLCA)
idw_empno.Retrieve(gs_brand)
idw_empno.InsertRow(0)


This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;

CHOOSE CASE dwo.name
	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"empno","")
		This.GetChild("empno", idw_empno)
		idw_empno.SetTransObject(SQLCA)
		idw_empno.Retrieve(data)
		idw_empno.InsertRow(0)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_53090_d
integer beginy = 420
integer endy = 420
end type

type ln_2 from w_com010_d`ln_2 within w_53090_d
integer beginy = 424
integer endy = 424
end type

type dw_body from w_com010_d`dw_body within w_53090_d
integer y = 948
integer width = 3566
integer height = 1048
string dataobject = "d_53090_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_53090_d
integer x = 2382
integer y = 544
end type

type dw_1 from u_dw within w_53090_d
integer x = 5
integer y = 440
integer width = 3566
integer height = 492
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_53090_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event clicked;call super::clicked;//String  ls_brand, ls_shop_cd, ls_yymm, ls_shop_div, ls_comm_fg
//
//setrow(row)
//
//
//dw_body.SetTransObject(sqlca)
//
//
//dw_body.reset()
//
//dw_body.SetRedraw(False)
//
//
//ls_yymm = dw_head.GetItemString(1, "yymm")
//ls_brand = dw_head.GetItemString(1, "brand")
//ls_shop_div = dw_1.getitemstring(getrow(),"shop_div")
//ls_shop_cd = dw_1.getitemstring(getrow(),"shop_cd")
//ls_comm_fg = dw_1.getitemstring(getrow(),"comm_fg")
//
//
//messagebox('1',ls_shop_cd)
//messagebox('2',ls_comm_fg)
//messagebox('3',ls_shop_div)
//
//il_rows = dw_body.retrieve(ls_yymm, ls_brand, ls_shop_div, ls_shop_cd, ls_comm_fg)
//
//IF il_rows > 0 THEN
//   dw_body.SetFocus()
//END IF
//
//dw_body.SetRedraw(True)
//
end event

