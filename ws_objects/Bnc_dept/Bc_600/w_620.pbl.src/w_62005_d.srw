$PBExportHeader$w_62005_d.srw
$PBExportComments$판매감도분석
forward
global type w_62005_d from w_com010_d
end type
type tab_1 from tab within w_62005_d
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
type tabpage_6 from userobject within tab_1
end type
type dw_6 from datawindow within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_6 dw_6
end type
type tabpage_7 from userobject within tab_1
end type
type dw_7 from datawindow within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_7 dw_7
end type
type tab_1 from tab within w_62005_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
end type
end forward

global type w_62005_d from w_com010_d
integer width = 3680
integer height = 2244
tab_1 tab_1
end type
global w_62005_d w_62005_d

type variables
/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
String 				is_brand,is_year,is_season,is_area_cd,is_shop_grp, is_mrs_gbn, is_expt_gubn, is_yymmdd
DataWindowChild	idw_brand,idw_season,idw_area_cd,idw_shop_grp
int					ii_curr_tab_page = 1
end variables

on w_62005_d.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_62005_d.destroy
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

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "year", String(ld_datetime,'yyyy'))


end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(tab_1.tabpage_1.dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_3.dw_3, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_4.dw_4, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_5.dw_5, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_6.dw_6, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_7.dw_7, "ScaleToRight&Bottom")

tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)
tab_1.tabpage_4.dw_4.SetTransObject(SQLCA)
tab_1.tabpage_5.dw_5.SetTransObject(SQLCA)
tab_1.tabpage_6.dw_6.SetTransObject(SQLCA)
tab_1.tabpage_7.dw_7.SetTransObject(SQLCA)


end event

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
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

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) OR is_year = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
is_season = dw_head.GetItemString(1, "season")
is_area_cd = dw_head.GetItemString(1, "area_cd")
is_shop_grp = dw_head.GetItemString(1, "shop_grp")
is_mrs_gbn = dw_head.GetItemString(1, "mrs_gbn")
is_expt_gubn = dw_head.GetItemString(1, "expt_gubn")
is_yymmdd = dw_head.GetItemString(1, "yymmdd")

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

IF ii_curr_tab_page = 1 THEN
	il_rows = tab_1.tabpage_1.dw_1.retrieve(is_brand,is_year,is_season, is_mrs_gbn, is_expt_gubn, is_yymmdd)
ELSEIF ii_curr_tab_page = 2 THEN
	il_rows = tab_1.tabpage_2.dw_2.retrieve(is_brand,is_year,is_season, is_mrs_gbn, is_expt_gubn, is_yymmdd)
ELSEIF ii_curr_tab_page = 3 THEN
	il_rows = tab_1.tabpage_3.dw_3.retrieve(is_brand,is_year,is_season,is_area_cd,is_shop_grp, is_mrs_gbn, is_expt_gubn, is_yymmdd)	
ELSEIF ii_curr_tab_page = 4 THEN
	il_rows = tab_1.tabpage_4.dw_4.retrieve(is_brand,is_year,is_season,is_area_cd,is_shop_grp, is_mrs_gbn, is_expt_gubn, is_yymmdd)
ELSEIF ii_curr_tab_page = 5 THEN
	il_rows = tab_1.tabpage_5.dw_5.retrieve(is_brand,is_year,is_season,is_area_cd,is_shop_grp, is_mrs_gbn, is_expt_gubn, is_yymmdd)
ELSEIF ii_curr_tab_page = 6 THEN
	il_rows = tab_1.tabpage_6.dw_6.retrieve(is_brand,is_year,is_season,is_area_cd,is_shop_grp, is_mrs_gbn, is_expt_gubn, is_yymmdd)
ELSEIF ii_curr_tab_page = 7 THEN
	il_rows = tab_1.tabpage_7.dw_7.retrieve(is_brand,is_year,is_season,is_area_cd,is_shop_grp, is_mrs_gbn, is_expt_gubn, is_yymmdd)
END IF

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

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
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
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
//   CASE 5    /* 조건 */
//      cb_retrieve.Text = "조회(&Q)"
//      cb_print.enabled = false
//      cb_preview.enabled = false
//      cb_excel.enabled = false
//      ib_changed = false
//      dw_body.Enabled = false
//      dw_head.Enabled = true
//      dw_head.SetFocus()
//      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_excel;
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

IF ii_curr_tab_page = 1 THEN
	li_ret = tab_1.tabpage_1.dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
ELSEIF ii_curr_tab_page = 2 THEN
	li_ret = tab_1.tabpage_2.dw_2.SaveAs(ls_doc_nm, Excel!, TRUE)
ELSEIF ii_curr_tab_page = 3 THEN
	li_ret = tab_1.tabpage_3.dw_3.SaveAs(ls_doc_nm, Excel!, TRUE)
ELSEIF ii_curr_tab_page = 4 THEN
	li_ret = tab_1.tabpage_4.dw_4.SaveAs(ls_doc_nm, Excel!, TRUE)
ELSEIF ii_curr_tab_page = 5 THEN
	li_ret = tab_1.tabpage_5.dw_5.SaveAs(ls_doc_nm, Excel!, TRUE)
ELSEIF ii_curr_tab_page = 6 THEN
	li_ret = tab_1.tabpage_6.dw_6.SaveAs(ls_doc_nm, Excel!, TRUE)
ELSEIF ii_curr_tab_page = 7 THEN
	li_ret = tab_1.tabpage_7.dw_7.SaveAs(ls_doc_nm, Excel!, TRUE)
END IF

li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)


if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_62005_d","0")
end event

type cb_close from w_com010_d`cb_close within w_62005_d
end type

type cb_delete from w_com010_d`cb_delete within w_62005_d
end type

type cb_insert from w_com010_d`cb_insert within w_62005_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_62005_d
end type

type cb_update from w_com010_d`cb_update within w_62005_d
end type

type cb_print from w_com010_d`cb_print within w_62005_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_62005_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_62005_d
end type

type cb_excel from w_com010_d`cb_excel within w_62005_d
boolean enabled = true
end type

type dw_head from w_com010_d`dw_head within w_62005_d
integer height = 224
string dataobject = "d_62005_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

This.GetChild("area_cd", idw_area_cd )
idw_area_cd.SetTransObject(SQLCA)
idw_area_cd.Retrieve('090')

idw_area_cd.InsertRow(1)
idw_area_cd.SetItem(1,'inter_cd','%')
idw_area_cd.SetItem(1,'inter_nm','전체')

This.GetChild("shop_grp", idw_shop_grp )
idw_shop_grp.SetTransObject(SQLCA)
idw_shop_grp.Retrieve('912')

idw_shop_grp.InsertRow(1)
idw_shop_grp.SetItem(1,'inter_cd','%')
idw_shop_grp.SetItem(1,'inter_nm','전체')
end event

event dw_head::itemchanged;call super::itemchanged;string ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name
	CASE "brand"
		
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

type ln_1 from w_com010_d`ln_1 within w_62005_d
integer beginy = 416
integer endy = 416
end type

type ln_2 from w_com010_d`ln_2 within w_62005_d
integer beginy = 420
integer endy = 420
end type

type dw_body from w_com010_d`dw_body within w_62005_d
boolean visible = false
integer y = 436
integer height = 1604
boolean enabled = false
end type

type dw_print from w_com010_d`dw_print within w_62005_d
end type

type tab_1 from tab within w_62005_d
integer x = 9
integer y = 432
integer width = 3589
integer height = 1568
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
tabpage_6 tabpage_6
tabpage_7 tabpage_7
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_7}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
end on

event selectionchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
String ls_mod

ii_curr_tab_page = newindex

CHOOSE CASE newindex 
	CASE 1, 2
		ls_mod = "area_cd_t.visible = '0'  area_cd.visible = '0' "  + &
		         "shop_div_t.visible = '0' shop_div.visible = '0'"
	CASE ELSE 
		ls_mod = "area_cd_t.visible = '1'  area_cd.visible = '1' "  + &
		         "shop_div_t.visible = '1' shop_div.visible = '1'"
END CHOOSE 
dw_head.modify(ls_mod)

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1456
long backcolor = 79741120
string text = "복종별상품군별"
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
integer y = 12
integer width = 3543
integer height = 1440
integer taborder = 20
string title = "none"
string dataobject = "d_62005_d01"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1456
long backcolor = 79741120
string text = "복종스타일별"
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
integer y = 12
integer width = 3543
integer height = 1440
integer taborder = 10
string title = "none"
string dataobject = "d_62005_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1456
long backcolor = 79741120
string text = "점포별감도순위"
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
integer y = 12
integer width = 3543
integer height = 1440
integer taborder = 10
string title = "none"
string dataobject = "d_62005_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1456
long backcolor = 79741120
string text = "점포별감도분석"
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
integer y = 12
integer width = 3543
integer height = 1440
integer taborder = 10
string title = "none"
string dataobject = "d_62005_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1456
long backcolor = 79741120
string text = "지역별감도분석"
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
integer y = 12
integer width = 3543
integer height = 1440
integer taborder = 10
string title = "none"
string dataobject = "d_62005_d05"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1456
long backcolor = 79741120
string text = "특정지역복종감도"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_6 dw_6
end type

on tabpage_6.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tabpage_6.destroy
destroy(this.dw_6)
end on

type dw_6 from datawindow within tabpage_6
integer y = 12
integer width = 3543
integer height = 1440
integer taborder = 10
string title = "none"
string dataobject = "d_62005_d06"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1456
long backcolor = 79741120
string text = "유통채널별감도"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_7 dw_7
end type

on tabpage_7.create
this.dw_7=create dw_7
this.Control[]={this.dw_7}
end on

on tabpage_7.destroy
destroy(this.dw_7)
end on

type dw_7 from datawindow within tabpage_7
integer y = 12
integer width = 3543
integer height = 1432
integer taborder = 10
string title = "none"
string dataobject = "d_62005_d07"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

