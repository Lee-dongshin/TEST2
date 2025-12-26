$PBExportHeader$w_61043_d.srw
$PBExportComments$재고평가감조회
forward
global type w_61043_d from w_com010_d
end type
type tab_1 from tab within w_61043_d
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
type tab_1 from tab within w_61043_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type dw_1 from datawindow within w_61043_d
end type
type dw_2 from datawindow within w_61043_d
end type
type st_1 from statictext within w_61043_d
end type
end forward

global type w_61043_d from w_com010_d
integer width = 3685
integer height = 2284
tab_1 tab_1
dw_1 dw_1
dw_2 dw_2
st_1 st_1
end type
global w_61043_d w_61043_d

type variables
STRING is_brand, is_yymm
DataWindowChild idw_brand
end variables

on w_61043_d.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_1=create dw_1
this.dw_2=create dw_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.st_1
end on

on w_61043_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.st_1)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
end event

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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if




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


//DECLARE SP_61043_D01 PROCEDURE FOR SP_61043_D01  
//         @brand = :is_brand,   
//         @base_yymm = :is_yymm  ;
//	
// EXECUTE SP_61043_D01 ;
//commit  USING SQLCA;	
//messagebox("", "완료!")	
//		 
//IF SQLCA.SQLCODE = -1 THEN 
//	rollback  USING SQLCA;				
//	MessageBox("SQL오류", SQLCA.SqlErrText) 
// 			
//ELSE
		
	

		il_rows = dw_body.retrieve(is_brand, is_yymm)
		
		IF il_rows > 0 THEN
			dw_body.SetFocus()
		ELSEIF il_rows = 0 THEN
			MessageBox("조회", "조회할 자료가 없습니다.")
		ELSE
			MessageBox("조회오류", "조회 실패 하였습니다.")
		END IF


		il_rows = dw_1.retrieve(is_brand, is_yymm)
		
		IF il_rows > 0 THEN
			dw_body.SetFocus()
		ELSEIF il_rows = 0 THEN
			MessageBox("조회", "조회할 자료가 없습니다.")
		ELSE
			MessageBox("조회오류", "조회 실패 하였습니다.")
		END IF
		
		
		il_rows = dw_2.retrieve(is_brand, is_yymm)
		
		IF il_rows > 0 THEN
			dw_body.SetFocus()
		ELSEIF il_rows = 0 THEN
			MessageBox("조회", "조회할 자료가 없습니다.")
		ELSE
			MessageBox("조회오류", "조회 실패 하였습니다.")
		END IF
//		
//END IF 		



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
		elseif dw_1.visible = true then
			li_ret = dw_1.SaveAsascii(ls_doc_nm) //, Excel!, TRUE)		
		else	
			li_ret = dw_2.SaveAsascii(ls_doc_nm) //, Excel!, TRUE)		
		end if	
	else 	
//		li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
		if dw_body.visible = true then
			li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
		elseif dw_1.visible = true then
			li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE) //, Excel!, TRUE)		
		else	
			li_ret = dw_2.SaveAs(ls_doc_nm, Excel!, TRUE)//, Excel!, TRUE)		
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

type cb_close from w_com010_d`cb_close within w_61043_d
end type

type cb_delete from w_com010_d`cb_delete within w_61043_d
end type

type cb_insert from w_com010_d`cb_insert within w_61043_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61043_d
end type

type cb_update from w_com010_d`cb_update within w_61043_d
end type

type cb_print from w_com010_d`cb_print within w_61043_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_61043_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_61043_d
end type

type cb_excel from w_com010_d`cb_excel within w_61043_d
end type

type dw_head from w_com010_d`dw_head within w_61043_d
integer height = 144
string dataobject = "D_61043_H01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_d`ln_1 within w_61043_d
integer beginy = 332
integer endy = 332
end type

type ln_2 from w_com010_d`ln_2 within w_61043_d
integer beginy = 336
integer endy = 336
end type

type dw_body from w_com010_d`dw_body within w_61043_d
integer x = 23
integer width = 3557
integer height = 1564
string dataobject = "d_61043_d02"
end type

type dw_print from w_com010_d`dw_print within w_61043_d
end type

type tab_1 from tab within w_61043_d
integer x = 9
integer y = 364
integer width = 3593
integer height = 1684
integer taborder = 20
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

event clicked;
  	CHOOSE CASE index
		CASE 1
			dw_body.visible = true
			dw_1.visible = false
			dw_2.visible = false

		CASE 2
			dw_body.visible = false
			dw_1.visible = true
			dw_2.visible = false
			
		//	il_rows = dw_1.retrieve(is_brand, is_yymm)
		
		
		
					

      CASE 3
			dw_body.visible = false
			dw_1.visible = false
			dw_2.visible = true
		//	il_rows = dw_2.retrieve(is_brand, is_yymm)			

	END CHOOSE

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
integer width = 3557
integer height = 1572
long backcolor = 79741120
string text = "원가 금액"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3557
integer height = 1572
long backcolor = 79741120
string text = "평  가  율"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3557
integer height = 1572
long backcolor = 79741120
string text = "평가감금액"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type dw_1 from datawindow within w_61043_d
boolean visible = false
integer x = 23
integer y = 468
integer width = 3557
integer height = 1564
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_61043_d03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_61043_d
boolean visible = false
integer x = 23
integer y = 468
integer width = 3557
integer height = 1564
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_61043_d04"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_61043_d
integer x = 2990
integer y = 276
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "* 원가(+VAT)"
boolean focusrectangle = false
end type

