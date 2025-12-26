$PBExportHeader$w_56216_d.srw
$PBExportComments$년도별계획대비투입판매현황
forward
global type w_56216_d from w_com010_d
end type
type tab_1 from tab within w_56216_d
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tab_1 from tab within w_56216_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_1 from u_dw within w_56216_d
end type
end forward

global type w_56216_d from w_com010_d
integer width = 3685
integer height = 2252
tab_1 tab_1
dw_1 dw_1
end type
global w_56216_d w_56216_d

type variables
DataWindowChild idw_brand, idw_year, idw_season
String is_brand, is_yymmdd, is_year, is_season
end variables

on w_56216_d.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_1
end on

on w_56216_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_1)
end on

event pfc_preopen();call super::pfc_preopen;
inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")

dw_1.SetTransObject(SQLCA)



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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"기준년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_yymmdd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
	dw_body.ShareData(dw_1)
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
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =		"t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_year.Text     = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "'" + &					
					"t_year1.Text    = '" + is_year + "'" + &										
					"t_yymmdd.Text   = '" + is_yymmdd + "'" + &										
					"t_season.Text   = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
					"t_pg_id.Text    = '" + is_pgm_id + "'" + &
               "t_user_id.Text  = '" + gs_user_id + "'" + &
               "t_datetime.Text = '" + ls_datetime + "'"


dw_print.Modify(ls_modify)


end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

dw_print.retrieve(is_brand, is_year, is_season, is_yymmdd)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_preview();/*===========================================================================*/

This.Trigger Event ue_title ()

dw_print.retrieve(is_brand, is_year, is_season, is_yymmdd)

dw_print.inv_printpreview.of_SetZoom()

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56216_d","0")
end event

type cb_close from w_com010_d`cb_close within w_56216_d
end type

type cb_delete from w_com010_d`cb_delete within w_56216_d
end type

type cb_insert from w_com010_d`cb_insert within w_56216_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56216_d
end type

type cb_update from w_com010_d`cb_update within w_56216_d
end type

type cb_print from w_com010_d`cb_print within w_56216_d
end type

type cb_preview from w_com010_d`cb_preview within w_56216_d
end type

type gb_button from w_com010_d`gb_button within w_56216_d
end type

type cb_excel from w_com010_d`cb_excel within w_56216_d
end type

type dw_head from w_com010_d`dw_head within w_56216_d
integer y = 156
integer height = 200
string dataobject = "d_56216_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

end event

type ln_1 from w_com010_d`ln_1 within w_56216_d
integer beginy = 356
integer endy = 356
end type

type ln_2 from w_com010_d`ln_2 within w_56216_d
integer beginy = 360
integer endy = 360
end type

type dw_body from w_com010_d`dw_body within w_56216_d
integer x = 23
integer y = 464
integer width = 3557
integer height = 1540
string dataobject = "d_56216_d02"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_56216_d
string dataobject = "d_56216_d03"
end type

type tab_1 from tab within w_56216_d
integer x = 5
integer y = 368
integer width = 3598
integer height = 1648
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

event clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/

//IF dw_head.Enabled = TRUE THEN Return 1

  	CHOOSE CASE index
		CASE 1
			dw_body.visible  = true
			dw_1.visible = false

		CASE 2
			dw_body.visible  = false
			dw_1.visible = true

	
END CHOOSE
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3561
integer height = 1536
long backcolor = 79741120
string text = "시즌별계"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3561
integer height = 1536
long backcolor = 79741120
string text = "시즌별상세"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type dw_1 from u_dw within w_56216_d
boolean visible = false
integer x = 23
integer y = 464
integer width = 3557
integer height = 1540
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_56216_d11"
boolean hscrollbar = true
end type

