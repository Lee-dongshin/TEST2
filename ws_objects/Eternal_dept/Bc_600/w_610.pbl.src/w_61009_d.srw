$PBExportHeader$w_61009_d.srw
$PBExportComments$상제품소진율
forward
global type w_61009_d from w_com010_d
end type
type tab_1 from tab within w_61009_d
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
type dw_3 from datawindow within tabpage_2
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_3 dw_3
dw_2 dw_2
end type
type tab_1 from tab within w_61009_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
end forward

global type w_61009_d from w_com010_d
integer width = 3675
integer height = 2248
tab_1 tab_1
end type
global w_61009_d w_61009_d

type variables
/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
String 				is_brand,is_year_fr,is_year_to,is_season_fr,is_season_to
String				is_sojae_fg,is_base_ymd
DataWindowChild	idw_brand,idw_season_fr,idw_season_to
int					ii_curr_tab_page = 1, ii_rate
string            is_year, is_season,is_item, is_sojae
end variables

on w_61009_d.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_61009_d.destroy
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

dw_head.SetItem(1, "year_fr", String(ld_datetime,'yyyy'))
dw_head.SetItem(1, "year_to", String(ld_datetime,'yyyy'))
dw_head.SetItem(1, "base_ymd", String(ld_datetime,'yyyymmdd'))

dw_head.SetColumn("season_fr")
dw_head.SetColumn("season_to")

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

is_brand		= dw_head.GetItemString(1, "brand")
is_base_ymd = dw_head.GetItemString(1, "base_ymd")

is_year_fr = dw_head.GetItemString(1, "year_fr")
if IsNull(is_year_fr) OR is_year_fr = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year_fr")
   return false
end if

is_season_fr= dw_head.GetItemString(1, "season_fr")

is_year_to = dw_head.GetItemString(1, "year_to")
if IsNull(is_year_to) OR is_year_to = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year_to")
   return false
end if

is_season_to= dw_head.GetItemString(1, "season_to")

is_sojae_fg = dw_head.GetItemString(1, "sojae_fg")

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

IF ii_curr_tab_page = 1 THEN
	il_rows = tab_1.tabpage_1.dw_1.retrieve(is_brand,is_year_fr,is_year_to,is_season_fr,is_season_to,is_base_ymd)
ELSE
	il_rows = tab_1.tabpage_2.dw_2.retrieve(is_brand,is_year_fr,is_year_to,is_season_fr,is_season_to)
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

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_2, "ScaleToBottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_3, "ScaleToRight&Bottom")

tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_3.SetTransObject(SQLCA)


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

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

Tab_1.TabPage_1.dw_1.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

Tab_1.TabPage_1.dw_1.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_sojae_fg

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_base_ymd.Text = '" + String(is_base_ymd, '@@@@/@@/@@') + "'" + &
            "t_season.Text = '" + is_year_fr + ' ' + idw_season_fr.GetItemString(idw_season_fr.GetRow(), "inter_display") + ' ~~ ' &
										  + is_year_to + ' ' + idw_season_to.GetItemString(idw_season_to.GetRow(), "inter_display") + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61009_d","0")
end event

type cb_close from w_com010_d`cb_close within w_61009_d
end type

type cb_delete from w_com010_d`cb_delete within w_61009_d
end type

type cb_insert from w_com010_d`cb_insert within w_61009_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61009_d
end type

type cb_update from w_com010_d`cb_update within w_61009_d
end type

type cb_print from w_com010_d`cb_print within w_61009_d
end type

type cb_preview from w_com010_d`cb_preview within w_61009_d
end type

type gb_button from w_com010_d`gb_button within w_61009_d
end type

type cb_excel from w_com010_d`cb_excel within w_61009_d
end type

type dw_head from w_com010_d`dw_head within w_61009_d
integer height = 228
string dataobject = "d_61009_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season_fr", idw_season_fr )
idw_season_fr.SetTransObject(SQLCA)
idw_season_fr.Retrieve('003', gs_brand, '%')

This.GetChild("season_to", idw_season_to )
idw_season_to.SetTransObject(SQLCA)
idw_season_to.Retrieve('003', gs_brand, '%')


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

String ls_year, ls_brand
DataWindowChild ldw_child

IF data = "0" THEN
	tab_1.tabpage_1.dw_1.DataObject = "d_61009_d04"
	dw_print.DataObject = "d_61009_r04"
ELSE
	tab_1.tabpage_1.dw_1.DataObject = "d_61009_d01"
	dw_print.DataObject = "d_61009_r01"
END IF

tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)


CHOOSE CASE dwo.name
	
		
	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
    		
		ls_year = this.getitemstring(row, "year_fr")	
		this.getchild("season_fr",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
		ls_year = this.getitemstring(row, "year_to")	
		this.getchild("season_to",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")		
		
  CASE  "year_fr"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season_fr",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")				
		 		
  CASE  "year_to"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season_to",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")				
			
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_61009_d
integer beginy = 416
integer endy = 416
end type

type ln_2 from w_com010_d`ln_2 within w_61009_d
integer beginy = 420
integer endy = 420
end type

type dw_body from w_com010_d`dw_body within w_61009_d
boolean visible = false
boolean enabled = false
end type

type dw_print from w_com010_d`dw_print within w_61009_d
integer x = 1605
integer y = 980
string dataobject = "d_61009_r01"
end type

type tab_1 from tab within w_61009_d
integer x = 14
integer y = 436
integer width = 3579
integer height = 1576
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
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

event selectionchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/

ii_curr_tab_page = newindex
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3543
integer height = 1464
long backcolor = 79741120
string text = "상제품소진율현황"
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
integer width = 3543
integer height = 1460
integer taborder = 20
string title = "none"
string dataobject = "d_61009_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;
/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
string ls_year, ls_season, ls_item, ls_sojae
int	 li_rate

is_year   = this.getitemstring(row, "year")
is_season = this.getitemstring(row, "season")
is_sojae  = this.getitemstring(row, "sojae")
is_item   = this.getitemstring(row, "item")
if isnull(is_sojae) or is_sojae = "" then
	is_sojae = "%"
end if	


CHOOSE CASE dwo.name
	CASE "rate1"		
		ii_rate = 0
	CASE "rate2"
		ii_rate = 10
	CASE "rate3"
		ii_rate = 20
	CASE "rate4"
		ii_rate = 30
	CASE "rate5"
		ii_rate = 40
	CASE "rate6"
		ii_rate = 50
	CASE "rate7"
		ii_rate = 60
	CASE "rate8"
		ii_rate = 70		
	CASE "rate9"
		ii_rate = 80
	CASE "rate10"
		ii_rate = 90
END CHOOSE


il_rows = tab_1.tabpage_2.dw_2.retrieve(is_brand, is_base_ymd, is_year, is_season,is_item, is_sojae, ii_rate)

IF il_rows > 0 THEN
  tab_1.selectedtab = 2
  tab_1.tabpage_2.dw_2.SetFocus()
  tab_1.tabpage_2.dw_3.Reset()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3543
integer height = 1464
long backcolor = 79741120
string text = "상제품소진율상세"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_3 dw_3
dw_2 dw_2
end type

on tabpage_2.create
this.dw_3=create dw_3
this.dw_2=create dw_2
this.Control[]={this.dw_3,&
this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_3)
destroy(this.dw_2)
end on

type dw_3 from datawindow within tabpage_2
integer x = 1495
integer y = 16
integer width = 2039
integer height = 1424
integer taborder = 20
string title = "none"
string dataobject = "d_61009_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within tabpage_2
integer x = 9
integer y = 16
integer width = 1454
integer height = 1432
integer taborder = 20
string title = "none"
string dataobject = "d_61009_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/
String 	ls_style,ls_chno

IF row > 0 THEN
	ls_style	= this.GetItemString(row,'style')
	tab_1.tabpage_2.dw_3.Retrieve(is_brand, is_base_ymd, ls_style, is_year, is_season,is_item, is_sojae, ii_rate)
ELSE
	return
END IF

this.selectRow(0, false);
this.setRow(row);
this.selectRow(row, true);

end event

