$PBExportHeader$w_12025_d.srw
$PBExportComments$디자인 진행일보
forward
global type w_12025_d from w_com010_d
end type
type rb_style from radiobutton within w_12025_d
end type
type rb_item from radiobutton within w_12025_d
end type
type rb_dept from radiobutton within w_12025_d
end type
type rb_time from radiobutton within w_12025_d
end type
type dw_2 from datawindow within w_12025_d
end type
type dw_1 from datawindow within w_12025_d
end type
type dw_3 from datawindow within w_12025_d
end type
end forward

global type w_12025_d from w_com010_d
integer width = 3675
integer height = 2388
event ue_dwo_set ( datawindow ad_dwo )
rb_style rb_style
rb_item rb_item
rb_dept rb_dept
rb_time rb_time
dw_2 dw_2
dw_1 dw_1
dw_3 dw_3
end type
global w_12025_d w_12025_d

type variables
string is_brand, is_fr_yymmdd, is_to_yymmdd, is_obj_body, is_obj_print, is_year, is_season, is_item, is_sojae
string is_opt = '2', is_gubn

datawindowchild idw_brand, idw_season, idw_sojae, idw_item

end variables

event ue_dwo_set(datawindow ad_dwo);Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(ad_dwo.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = ad_dwo.Describe('#' + String(i) + '.Name')
	IF ad_dwo.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

ad_dwo.Modify(ls_modify)
end event

on w_12025_d.create
int iCurrent
call super::create
this.rb_style=create rb_style
this.rb_item=create rb_item
this.rb_dept=create rb_dept
this.rb_time=create rb_time
this.dw_2=create dw_2
this.dw_1=create dw_1
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_style
this.Control[iCurrent+2]=this.rb_item
this.Control[iCurrent+3]=this.rb_dept
this.Control[iCurrent+4]=this.rb_time
this.Control[iCurrent+5]=this.dw_2
this.Control[iCurrent+6]=this.dw_1
this.Control[iCurrent+7]=this.dw_3
end on

on w_12025_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_style)
destroy(this.rb_item)
destroy(this.rb_dept)
destroy(this.rb_time)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.dw_3)
end on

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
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if
is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_year   = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_sojae  = dw_head.GetItemString(1, "sojae")
is_item   = dw_head.GetItemString(1, "item")
is_gubn = dw_head.GetItemString(1, "gubn")

if rb_item.checked then
	is_obj_body  = 'd_12025_d01'
	is_obj_print = 'd_12025_r01'
elseif rb_style.checked then
	is_obj_body  = 'd_12025_d02'
	is_obj_print = 'd_12025_r02'
elseif rb_time.checked then
	is_obj_print = 'd_12025_r00'
else
	is_obj_body  = 'd_12025_d03'
	is_obj_print = 'd_12025_r03'	
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



if dw_body.dataobject <> is_obj_body then
	dw_body.dataobject  = is_obj_body
	dw_print.dataobject = is_obj_print
	
	dw_body.SetTransObject(SQLCA)	
	dw_print.SetTransObject(SQLCA)
	
	trigger event ue_dwo_set(dw_body)
end if


if rb_style.checked  then	
	dw_body.Object.DataWindow.HorizontalScrollSplit  = 823
	il_rows = dw_body.retrieve(is_to_yymmdd, is_brand, is_year, is_season, is_sojae, is_item)
elseif rb_item.checked  then
	dw_body.Object.DataWindow.HorizontalScrollSplit  = 516
	il_rows = dw_body.retrieve(is_fr_yymmdd, is_to_yymmdd, is_brand, is_year, is_season, is_sojae, is_item)
elseif rb_time.checked then	
	il_rows = dw_1.retrieve(is_brand, is_year, is_season, is_item, is_sojae, '0', is_gubn)
	il_rows = dw_2.retrieve(is_brand, is_year, is_season, is_item, is_sojae, '0', is_gubn)	
	dw_3.reset()
	dw_print.dataobject = "d_12025_r00"
	dw_print.SetTransObject(SQLCA)		
else
	il_rows = dw_body.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd)
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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_gubn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


if rb_time.checked then		
		dw_print.object.t_brand.text  = is_brand + ' ' + idw_brand.getitemstring(idw_brand.getrow(), "inter_nm")
		dw_print.object.t_year.text   = is_year
		dw_print.object.t_season.text = is_season
		dw_print.object.t_item.text   = is_item
		dw_print.object.t_sojae.text  = is_sojae	
		choose case is_gubn 
			case 'M'
				ls_gubn = '메인'
			case 'R'
				ls_gubn = '리오다'				
			case 'S'
				ls_gubn = '스팟'				
		end choose
		dw_print.object.t_gubn.text  = ls_gubn			
else	
	ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss" )
	
	ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
					 "t_user_id.Text = '" + gs_user_id + "'" + &
					 "t_datetime.Text = '" + ls_datetime + "'"
	
	dw_print.Modify(ls_modify)
	
	
	dw_print.object.t_brand.text = is_brand + ' ' + idw_brand.getitemstring(idw_brand.getrow(), "inter_nm")
	dw_print.object.t_to_yymmdd.text = is_to_yymmdd
	
	if is_obj_print = "d_12025_r01" or is_obj_print = "d_12025_r03" then	
		dw_print.object.t_fr_yymmdd.text = is_fr_yymmdd
	end if
end if	



end event

event ue_preview();

/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
This.Trigger Event ue_title ()

dw_print.Object.DataWindow.Print.Orientation	 = 1

if rb_time.checked then			
	il_rows = dw_print.retrieve(is_brand, is_year, is_season, is_item, is_sojae, '1', is_gubn)
	
else
	dw_body.ShareData(dw_print)
end if

dw_print.inv_printpreview.of_SetZoom()

end event

event open;call super::open;datetime ld_datetime
string ls_year, ls_season
dw_body.Object.DataWindow.HorizontalScrollSplit  = 823



IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))

end if

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))

end if


if gf_next_year(ld_datetime, ls_year) then
	dw_head.setitem(1,"year",ls_year)
end if

if gf_next_season(ld_datetime, ls_season) then
	dw_head.setitem(1,"season",ls_season)
end if

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_2, "ScaleToRight")
inv_resize.of_Register(dw_1, "ScaleToRight")
inv_resize.of_Register(dw_3, "ScaleToRight&Bottom")


dw_1.SetTransObject(SQLCA)	
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_12025_d
end type

type cb_delete from w_com010_d`cb_delete within w_12025_d
end type

type cb_insert from w_com010_d`cb_insert within w_12025_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_12025_d
end type

type cb_update from w_com010_d`cb_update within w_12025_d
end type

type cb_print from w_com010_d`cb_print within w_12025_d
end type

type cb_preview from w_com010_d`cb_preview within w_12025_d
end type

type gb_button from w_com010_d`gb_button within w_12025_d
end type

type cb_excel from w_com010_d`cb_excel within w_12025_d
end type

type dw_head from w_com010_d`dw_head within w_12025_d
integer y = 164
integer height = 212
string dataobject = "d_12025_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')


This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')




end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name


	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1


	This.GetChild("sojae", idw_sojae)
	idw_sojae.SetTransObject(SQLCA)
	idw_sojae.Retrieve('%', data)
	idw_sojae.insertrow(1)
	idw_sojae.Setitem(1, "sojae", "%")
	idw_sojae.Setitem(1, "sojae_nm", "전체")
	
	This.GetChild("item", idw_item)
	idw_item.SetTransObject(SQLCA)
	idw_item.Retrieve(data)
	idw_item.insertrow(1)
	idw_item.Setitem(1, "item", "%")
	idw_item.Setitem(1, "item_nm", "전체")
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_12025_d
integer beginy = 396
integer endy = 396
end type

type ln_2 from w_com010_d`ln_2 within w_12025_d
integer beginy = 400
integer endy = 400
end type

type dw_body from w_com010_d`dw_body within w_12025_d
integer y = 412
integer height = 1740
string dataobject = "d_12025_d02"
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
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

type dw_print from w_com010_d`dw_print within w_12025_d
integer x = 91
integer y = 596
string dataobject = "d_12025_r02"
end type

type rb_style from radiobutton within w_12025_d
integer x = 1440
integer y = 308
integer width = 320
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
string text = "스타일별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then 	
	dw_head.setitem(1,"opt","2")
	is_opt = '2'
	dw_1.visible = false
	dw_2.visible = false
	dw_3.visible = false	
	dw_head.setitem(1,"t_time",is_opt)	
	dw_head.object.gubn.visible = false	
end if

end event

type rb_item from radiobutton within w_12025_d
integer x = 1042
integer y = 308
integer width = 320
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
string text = "복종별"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then 	
	dw_head.setitem(1,"opt","1")
	is_opt = '1'
	dw_1.visible = false
	dw_2.visible = false
	dw_3.visible = false	
	dw_head.setitem(1,"t_time",is_opt)	
	dw_head.object.gubn.visible = false
end if

end event

type rb_dept from radiobutton within w_12025_d
integer x = 1842
integer y = 308
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
string text = "진행일보"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then 	
	dw_head.setitem(1,"opt","3")
	dw_1.visible = false
	dw_2.visible = false
	dw_3.visible = false	
	dw_head.setitem(1,"t_time",is_opt)	
	dw_head.object.gubn.visible = false	
end if

end event

type rb_time from radiobutton within w_12025_d
integer x = 2249
integer y = 308
integer width = 494
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
string text = "단계별시간 분석"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then 	
	dw_head.setitem(1,"opt","4")
	is_opt = '4'
	dw_1.visible = true
	dw_2.visible = true
	dw_3.visible = true	
	dw_head.setitem(1,"t_time",is_opt)
	dw_head.object.gubn.visible = true
end if

end event

type dw_2 from datawindow within w_12025_d
boolean visible = false
integer x = 5
integer y = 412
integer width = 3589
integer height = 796
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_12025_d05"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_12025_d
boolean visible = false
integer x = 5
integer y = 1212
integer width = 3589
integer height = 652
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_12025_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_season, ls_item, ls_sojae

if row > 0 then
	is_season = dw_1.getitemstring(row,"season")
	is_item   = dw_1.getitemstring(row,"item")
	is_sojae  = dw_1.getitemstring(row,"sojae")
	
	il_rows = dw_3.retrieve(is_brand, is_year, is_season, is_item, is_sojae, '1', is_gubn)	
end if
	
end event

type dw_3 from datawindow within w_12025_d
boolean visible = false
integer x = 5
integer y = 1868
integer width = 3589
integer height = 284
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_12025_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

