$PBExportHeader$w_61044_d.srw
$PBExportComments$유통망별 매출조회(품번기준)
forward
global type w_61044_d from w_com010_d
end type
end forward

global type w_61044_d from w_com010_d
integer width = 3675
integer height = 2268
end type
global w_61044_d w_61044_d

type variables
STRING is_brand, is_yymm, is_fr_ymd, is_to_ymd, is_view_opt
DataWindowChild idw_brand
end variables

on w_61044_d.create
call super::create
end on

on w_61044_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

is_yymm = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
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

is_view_opt = dw_head.GetItemString(1, "view_opt")


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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



return true
end event

event ue_retrieve();call super::ue_retrieve;IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN



		if is_view_opt = "A" then
			il_rows = dw_body.retrieve(is_brand, is_yymm)
		else 	
			il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd)
		end if	
		
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

event ue_excel();string ls_doc_nm, ls_nm

integer li_ret, li_ret2
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
//li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)

   li_ret = MessageBox("저장형식 선택",  "화면과 같은 양식을 원하시면 Yes! 기초데이터를 원하시면 No! 를 선택해주세요! 파일 오픈시 확인 메시지는 무시하고 열어 주세요! ",  Question!, YesNo!)
	if li_ret = 1 then
		if dw_body.visible = true then
			li_ret = dw_body.SaveAsascii(ls_doc_nm) //, Excel!, TRUE)
		end if	
	else 	
//		li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
		if dw_body.visible = true then
			li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)	
		end if			
		
	end if	

if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if


SetPointer(Old_pointer)


  li_ret2 = MessageBox("엑셀 실행 선택",  "해당 파일을 OPEN 하시겠습니까? ",  Question!, YesNo!)
	if li_ret2 = 1 then
		OleObject ole_excel
		ole_excel = Create OleObject
		
		ole_excel.connecttonewobject("excel.application")
		
		ole_excel.windowstate = 1
		ole_excel.Application.Visible = true
		ole_excel.workbooks.open(ls_doc_nm)
		
		ole_excel.DisConnectObject()
	
	end if	
end event

type cb_close from w_com010_d`cb_close within w_61044_d
end type

type cb_delete from w_com010_d`cb_delete within w_61044_d
end type

type cb_insert from w_com010_d`cb_insert within w_61044_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61044_d
end type

type cb_update from w_com010_d`cb_update within w_61044_d
end type

type cb_print from w_com010_d`cb_print within w_61044_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_61044_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_61044_d
end type

type cb_excel from w_com010_d`cb_excel within w_61044_d
end type

type dw_head from w_com010_d`dw_head within w_61044_d
integer y = 168
integer height = 144
string dataobject = "D_61044_H01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::itemchanged;call super::itemchanged;
//dw_head.object.sojae.visible = 1
//dw_head.object.sojae_t.visible = 1
//
//dw_head.object.item.visible = 1
//dw_head.object.item_t.visible = 1
//

//
CHOOSE CASE dwo.name
	CASE "view_opt"      // dddw로 작성된 항목
//					MESSAGEBOX("",DATA)
    	If data = 'A' then

			dw_head.object.yymm_t.visible = 1
			dw_head.object.yyyy.visible = 1
			dw_head.object.date_t.visible = 0
			dw_head.object.fr_ymd.visible = 0
			dw_head.object.t_2.visible = 0			
			dw_head.object.to_ymd.visible = 0			
			
			dw_body.DataObject  = 'd_61044_d03'
			dw_body.SetTransObject(SQLCA)

			
		ELSE	
			dw_head.object.yymm_t.visible = 0
			dw_head.object.yyyy.visible = 0
			dw_head.object.date_t.visible = 1
			dw_head.object.fr_ymd.visible = 1
			dw_head.object.t_2.visible = 1			
			dw_head.object.to_ymd.visible = 1			
			
			dw_body.DataObject  = 'd_61044_d04'
			dw_body.SetTransObject(SQLCA)
			
		END IF	
			
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_61044_d
integer beginy = 332
integer endy = 332
end type

type ln_2 from w_com010_d`ln_2 within w_61044_d
integer beginy = 336
integer endy = 336
end type

type dw_body from w_com010_d`dw_body within w_61044_d
integer x = 23
integer y = 352
integer width = 3570
integer height = 1680
string dataobject = "d_61044_d03"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_61044_d
end type

