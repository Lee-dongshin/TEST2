$PBExportHeader$w_42054_d.srw
$PBExportComments$반품/출고 소급 작업내용 조회
forward
global type w_42054_d from w_com010_d
end type
type dw_1 from datawindow within w_42054_d
end type
end forward

global type w_42054_d from w_com010_d
integer width = 3675
integer height = 2240
dw_1 dw_1
end type
global w_42054_d w_42054_d

type variables
DataWindowChild idw_brand, idw_house_cd, idw_sojae, idw_item, idw_color, ldw_child, idw_season


String is_brand, is_fr_yymmdd, is_to_yymmdd, is_house_cd, is_fr_proc_date, is_to_proc_date, is_gubn_chk, is_year, is_season
end variables

on w_42054_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_42054_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event open;call super::open;datetime ld_datetime
String ls_datetime


ld_datetime = DateTime(Today(), Now())
ls_datetime = String(ld_datetime, 'YYYYMMDD')


dw_head.Setitem(1,'gubn_chk', 'Y')


dw_head.Setitem(1,'season', '%')

dw_head.Setitem(1,'fr_yymmdd', ls_datetime)
dw_head.Setitem(1,'to_yymmdd', ls_datetime)
dw_head.Setitem(1,'fr_proc_date', ls_datetime)
dw_head.Setitem(1,'to_proc_date', ls_datetime)



dw_1.SetTransObject(SQLCA)
//inv_resize.of_Register(dw_1, "FixedToBottom&Bottom")
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
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


is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
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


//기준일
is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")

//처리일
is_fr_proc_date = dw_head.GetItemString(1, "fr_proc_date")
is_to_proc_date = dw_head.GetItemString(1, "to_proc_date")

is_gubn_chk = dw_head.GetItemString(1, "gubn_chk")


return true 
end event

event ue_retrieve();call super::ue_retrieve;
IF TRIGGER EVENT ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_brand, is_house_cd, is_fr_yymmdd, is_to_yymmdd, is_fr_proc_date, is_to_proc_date, is_gubn_chk, is_year, is_season)



IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

THIS.TRIGGER EVENT ue_button(1, il_rows)
THIS.TRIGGER EVENT ue_msg(1, il_rows)
end event

event close;call super::close;gf_user_connect_pgm(gs_user_id,"w_42054_d","0")
end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime,ls_title


IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


If is_gubn_chk = 'Y' then
	ls_title = '반품 작업 내역'
else
	ls_title = '출고 작업 내역'
end if

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	 "t_pg_id.Text    = '" + is_pgm_id + "'" + &
             "t_user_id.Text  = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
			    "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(),"inter_display") + "'" + &
             "t_title.Text  = '" + ls_title + "'" 


dw_print.Modify(ls_modify)

end event

event ue_preview();This.Trigger Event ue_title ()

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();This.Trigger Event ue_title()

dw_body.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)
end event

type cb_close from w_com010_d`cb_close within w_42054_d
end type

type cb_delete from w_com010_d`cb_delete within w_42054_d
end type

type cb_insert from w_com010_d`cb_insert within w_42054_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42054_d
end type

type cb_update from w_com010_d`cb_update within w_42054_d
end type

type cb_print from w_com010_d`cb_print within w_42054_d
end type

type cb_preview from w_com010_d`cb_preview within w_42054_d
end type

type gb_button from w_com010_d`gb_button within w_42054_d
end type

type cb_excel from w_com010_d`cb_excel within w_42054_d
end type

type dw_head from w_com010_d`dw_head within w_42054_d
string dataobject = "d_42054_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')



This.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()


// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

type ln_1 from w_com010_d`ln_1 within w_42054_d
end type

type ln_2 from w_com010_d`ln_2 within w_42054_d
end type

type dw_body from w_com010_d`dw_body within w_42054_d
integer height = 1536
string dataobject = "d_42054_d01"
boolean hscrollbar = true
end type

event dw_body::doubleclicked;call super::doubleclicked;String ls_shop_cd, ls_yymmdd, ls_out_no, ls_year, ls_season

IF row < 1 THEN RETURN 

ls_shop_cd 	= This.GetitemString(row, "shop_cd")
ls_yymmdd   = This.GetitemString(row, "yymmdd") 
ls_out_no   = This.GetitemString(row, "out_no")
ls_year 		= This.GetitemString(row, "year")
ls_season 	= This.GetitemString(row, "season")

			
il_rows = dw_1.retrieve(ls_shop_cd, ls_yymmdd, ls_out_no, is_gubn_chk, ls_year, ls_season)
			
if il_rows > 0 then 
	dw_1.visible = true
	dw_1.SetFocus()

end if


end event

event dw_body::constructor;call super::constructor;
This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
end event

type dw_print from w_com010_d`dw_print within w_42054_d
integer x = 288
integer y = 368
string dataobject = "d_42054_r01"
end type

event dw_print::constructor;call super::constructor;
This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
end event

type dw_1 from datawindow within w_42054_d
boolean visible = false
integer x = 96
integer y = 496
integer width = 3397
integer height = 1468
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "상세내역"
string dataobject = "d_42054_d02"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',gs_brand)


This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('011')


This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
end event

