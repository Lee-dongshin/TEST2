$PBExportHeader$w_55020_d.srw
$PBExportComments$월판매형태별 매출
forward
global type w_55020_d from w_com010_d
end type
type rb_1 from radiobutton within w_55020_d
end type
type rb_2 from radiobutton within w_55020_d
end type
type rb_3 from radiobutton within w_55020_d
end type
type rb_4 from radiobutton within w_55020_d
end type
type rb_5 from radiobutton within w_55020_d
end type
type rb_6 from radiobutton within w_55020_d
end type
type dw_1 from datawindow within w_55020_d
end type
end forward

global type w_55020_d from w_com010_d
integer width = 3680
integer height = 2264
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
dw_1 dw_1
end type
global w_55020_d w_55020_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_shop_div, idw_st_brand
String is_brand, is_frm_yymm, is_to_yymm, is_year, is_season, is_gubn, is_shop_div, is_shop_type,is_opt_shop_type, is_st_brand

end variables

on w_55020_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_6=create rb_6
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.rb_5
this.Control[iCurrent+6]=this.rb_6
this.Control[iCurrent+7]=this.dw_1
end on

on w_55020_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.dw_1)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55020_d","0")
end event

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_yymm" , MidA(string(ld_datetime,"yyyymmdd"),1,4) + "01")
dw_head.SetItem(1, "to_yymm" , MidA(string(ld_datetime,"yyyymmdd"),1,6))

dw_head.SetItem(1, "SHOP_DIV" , "%")
dw_head.SetItem(1, "st_brand" , "%")
end event

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


is_st_brand = dw_head.GetItemString(1, "st_brand")
if IsNull(is_st_brand) or Trim(is_st_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("is_st_brand")
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




is_frm_yymm = dw_head.GetItemString(1, "frm_yymm")
if IsNull(is_frm_yymm) or Trim(is_frm_yymm) = "" then
   MessageBox(ls_title,"시작월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_yymm")
   return false
end if

is_to_yymm = dw_head.GetItemString(1, "to_yymm")
if IsNull(is_to_yymm) or Trim(is_to_yymm) = "" then
   MessageBox(ls_title,"마지막월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
if IsNull(is_shop_div) or is_shop_div = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_opt_shop_type = Trim(dw_head.GetItemString(1, "opt_shop_type"))
if IsNull(is_opt_shop_type) or is_opt_shop_type = "" then
	is_opt_shop_type = "N"
end if



if rb_1.checked then 
	is_gubn="0"
elseif rb_2.checked then 
	is_gubn="1"
elseif rb_3.checked then 
	is_gubn="2"
elseif rb_4.checked then 
	is_gubn="3"	
elseif rb_5.checked then 
	is_gubn="4"		
elseif rb_6.checked then 
	is_gubn="5"			
else
	is_gubn="0"
end if


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G') then
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

event ue_retrieve();call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

// '200301', '200307','%', 'n','2003','%' 

if is_gubn = "5" then 
	dw_body.dataobject = "d_55020_d04"
	dw_body.SetTransObject(SQLCA)
	
	dw_1.dataobject = "d_55020_d03"
	dw_1.SetTransObject(SQLCA)
	
else
   dw_body.dataobject = "d_55020_d02"
	dw_body.SetTransObject(SQLCA)	
	
	dw_1.dataobject = "d_55020_r01"
	dw_1.SetTransObject(SQLCA)

end if	

il_rows = dw_1.retrieve(is_frm_yymm, is_to_yymm, is_shop_div, is_brand, is_year, is_season, is_gubn, is_opt_shop_type,is_st_brand)

il_rows = dw_body.retrieve(is_frm_yymm, is_to_yymm, is_shop_div, is_brand, is_year, is_season, is_gubn, is_opt_shop_type, is_st_brand)

//		@frm_yymm		varchar(06),
//		@to_yymm		varchar(06),
//		@shop_div		varchar(01),
//		@brand			varchar(01),
//		@year			varchar(04),
//		@season			varchar(01),
//		@gubn			varchar(1) = null,
//		@opt_shop_type		varchar(01)
//

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
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_chno_gubun, ls_gubun

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


ls_modify =	"t_pg_id.Text      = '" + is_pgm_id    + "'" + &
            "t_user_id.Text    = '" + gs_user_id   + "'" + &
            "t_datetime.Text   = '" + ls_datetime  + "'" + &
            "t_frm_yymm.Text   = '" + is_frm_yymm  + "'" + &
            "t_to_yymm.Text    = '" + is_to_yymm   + "'" + &				
				"t_brand.Text      = '" + idw_brand.GetItemString(idw_brand.GetRow(),   "inter_display") + "'" + &
            "t_year.Text       = '" + is_year      + "'" + &
            "t_season.Text     = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" 
           
dw_print.Modify(ls_modify)
if is_gubn = '0' then 
	dw_print.object.t_gubn.text='구분:실판금액'
elseif is_gubn = '1' then 
	dw_print.object.t_gubn.text='구분:출고가액'	
elseif is_gubn = '2' then 
	dw_print.object.t_gubn.text='구분:원가금액'	
else
	dw_print.object.t_gubn.text='구분:실판금액'	
end if

end event

event ue_preview();


if is_gubn = "5" then 
	dw_print.dataobject = "d_55020_r05"
	dw_print.SetTransObject(SQLCA)
else
   dw_print.dataobject = "d_55020_r02"
	dw_print.SetTransObject(SQLCA)	
end if	

This.Trigger Event ue_title ()

dw_print.retrieve(is_frm_yymm, is_to_yymm, "%", is_brand, is_year, is_season, is_gubn, is_opt_shop_type,is_st_brand)
dw_print.inv_printpreview.of_SetZoom()



end event

event ue_print();


if is_gubn = "5" then 
	dw_print.dataobject = "d_55020_r05"
	dw_print.SetTransObject(SQLCA)
else
   dw_print.dataobject = "d_55020_r02"
	dw_print.SetTransObject(SQLCA)	
end if	

This.Trigger Event ue_title()

dw_print.retrieve(is_frm_yymm, is_to_yymm, "%", is_brand, is_year, is_season,is_opt_shop_type,is_st_brAND)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)



end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event ue_excel();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

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
		li_ret = dw_1.SaveAsascii(ls_doc_nm) //, Excel!, TRUE)
	else 	
		li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
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




//Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)
//Run("Excel.exe " + ls_doc_nm, Maximized!)
end event

type cb_close from w_com010_d`cb_close within w_55020_d
end type

type cb_delete from w_com010_d`cb_delete within w_55020_d
end type

type cb_insert from w_com010_d`cb_insert within w_55020_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55020_d
end type

type cb_update from w_com010_d`cb_update within w_55020_d
end type

type cb_print from w_com010_d`cb_print within w_55020_d
end type

type cb_preview from w_com010_d`cb_preview within w_55020_d
end type

type gb_button from w_com010_d`gb_button within w_55020_d
end type

type cb_excel from w_com010_d`cb_excel within w_55020_d
end type

type dw_head from w_com010_d`dw_head within w_55020_d
integer y = 160
integer width = 4096
integer height = 228
string dataobject = "d_55020_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("st_brand", idw_st_brand )
idw_st_brand.SetTransObject(SQLCA)
idw_st_brand.Retrieve('001')
idw_st_brand.SetItem(1, "inter_cd", '%')
idw_st_brand.SetItem(1, "inter_cd1", '%')
idw_st_brand.SetItem(1, "inter_nm", '전체')



This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


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

	
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
	

		
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

type ln_1 from w_com010_d`ln_1 within w_55020_d
integer beginy = 448
integer endy = 448
end type

type ln_2 from w_com010_d`ln_2 within w_55020_d
integer beginy = 452
integer endy = 452
end type

type dw_body from w_com010_d`dw_body within w_55020_d
integer y = 464
integer height = 1556
string dataobject = "d_55020_d02"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_55020_d
string dataobject = "d_55020_r02"
end type

type rb_1 from radiobutton within w_55020_d
integer x = 165
integer y = 372
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "실판매액"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type rb_2 from radiobutton within w_55020_d
integer x = 594
integer y = 372
integer width = 466
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "출고가액(-VAT)"
borderstyle borderstyle = stylelowered!
end type

type rb_3 from radiobutton within w_55020_d
integer x = 1120
integer y = 372
integer width = 466
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "원가금액(-VAT)"
borderstyle borderstyle = stylelowered!
end type

type rb_4 from radiobutton within w_55020_d
integer x = 1637
integer y = 372
integer width = 466
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "택가금액"
borderstyle borderstyle = stylelowered!
end type

type rb_5 from radiobutton within w_55020_d
integer x = 2030
integer y = 372
integer width = 466
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "수량"
borderstyle borderstyle = stylelowered!
end type

type rb_6 from radiobutton within w_55020_d
integer x = 2501
integer y = 372
integer width = 466
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "택가/실판액"
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_55020_d
boolean visible = false
integer x = 613
integer y = 476
integer width = 1353
integer height = 840
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_55020_d03"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

