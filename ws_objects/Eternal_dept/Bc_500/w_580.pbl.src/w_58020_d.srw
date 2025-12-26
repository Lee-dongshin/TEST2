$PBExportHeader$w_58020_d.srw
$PBExportComments$온앤온미수금정리
forward
global type w_58020_d from w_com010_d
end type
type tab_1 from tab within w_58020_d
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tab_1 from tab within w_58020_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_1 from datawindow within w_58020_d
end type
end forward

global type w_58020_d from w_com010_d
integer width = 3685
integer height = 2272
tab_1 tab_1
dw_1 dw_1
end type
global w_58020_d w_58020_d

type variables
string is_brand, is_fr_yymmdd,  is_to_yymmdd, is_gubn
Decimal id_usd_rate

DatawindowChild  idw_brand

end variables

on w_58020_d.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_1
end on

on w_58020_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_1)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")

dw_1.SetTransObject(SQLCA)

end event

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
   MessageBox(ls_title,"Brand를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if



is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
if IsNull(is_fr_yymmdd) or Trim(is_fr_yymmdd) = "" then
   MessageBox(ls_title,"From일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymmdd")
   return false
end if

is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
   MessageBox(ls_title,"To일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if

if is_fr_yymmdd > is_to_yymmdd then
	MessageBox(ls_title,"From일자가 To일자보다 큽니다 !")
	return false
end if



return true







end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


	il_rows = dw_body.retrieve(is_fr_yymmdd, is_to_yymmdd)
	il_rows = dw_1.retrieve(is_fr_yymmdd, is_to_yymmdd)
	il_rows = dw_print.retrieve(is_fr_yymmdd, is_to_yymmdd)
	
	IF il_rows > 0 THEN
		dw_body.visible = true
		dw_1.visible = false
		dw_body.SetFocus()
	ELSEIF il_rows = 0 THEN
		MessageBox("조회", "조회할 자료가 없습니다.")
	ELSE
		MessageBox("조회오류", "조회 실패 하였습니다.")
	END IF


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)
end event

event ue_title();call super::ue_title;//datetime ld_datetime
//string ls_modify, ls_datetime
//
//IF gf_sysdate(ld_datetime) = FALSE THEN
//   ld_datetime = DateTime(Today(), Now())
//END IF
//
//ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
//
//ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
//            "t_user_id.Text = '" + gs_user_id + "'" + &
//            "t_datetime.Text = '" + ls_datetime + "'" + &
//				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
//				"t_yymm.Text = '" + is_yymm + "'" + &
//				"t_year.Text = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "'" + &
//				"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" 				 
//
//dw_print.Modify(ls_modify)
//
end event

event open;call super::open;datetime	ld_datetime
string   ls_from_date, ls_to_date

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_to_date = String(ld_datetime, "yyyymmdd")
ls_from_date = LeftA(ls_to_date,6) + '01'

dw_head.Setitem(1,"fr_yymmdd", ls_from_date)
dw_head.Setitem(1,"to_yymmdd", ls_to_date)
end event

type cb_close from w_com010_d`cb_close within w_58020_d
end type

type cb_delete from w_com010_d`cb_delete within w_58020_d
end type

type cb_insert from w_com010_d`cb_insert within w_58020_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_58020_d
end type

type cb_update from w_com010_d`cb_update within w_58020_d
end type

type cb_print from w_com010_d`cb_print within w_58020_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_58020_d
end type

type gb_button from w_com010_d`gb_button within w_58020_d
end type

type cb_excel from w_com010_d`cb_excel within w_58020_d
end type

type dw_head from w_com010_d`dw_head within w_58020_d
integer y = 164
integer height = 124
string dataobject = "d_58020_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


end event

type ln_1 from w_com010_d`ln_1 within w_58020_d
integer beginy = 308
integer endy = 308
end type

type ln_2 from w_com010_d`ln_2 within w_58020_d
integer beginy = 312
integer endy = 312
end type

type dw_body from w_com010_d`dw_body within w_58020_d
integer x = 14
integer y = 432
integer width = 3566
integer height = 1596
string dataobject = "d_58020_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
//This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_print from w_com010_d`dw_print within w_58020_d
string dataobject = "d_58020_r03"
end type

type tab_1 from tab within w_58020_d
integer x = 9
integer y = 324
integer width = 3593
integer height = 1712
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
end type

event clicked;
  	CHOOSE CASE index
		CASE 1
			dw_body.visible = true
			dw_1.visible = false


		CASE 2
			dw_body.visible = false
			dw_1.visible = true

	END CHOOSE

	
end event

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

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3557
integer height = 1600
long backcolor = 79741120
string text = "전체미수금"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3557
integer height = 1600
long backcolor = 79741120
string text = "받을금액"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type dw_1 from datawindow within w_58020_d
boolean visible = false
integer x = 23
integer y = 424
integer width = 3566
integer height = 1596
integer taborder = 20
string title = "none"
string dataobject = "d_58020_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

