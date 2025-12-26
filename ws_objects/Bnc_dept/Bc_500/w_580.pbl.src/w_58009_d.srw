$PBExportHeader$w_58009_d.srw
$PBExportComments$수입내역조회
forward
global type w_58009_d from w_com010_d
end type
type cbx_1 from checkbox within w_58009_d
end type
end forward

global type w_58009_d from w_com010_d
cbx_1 cbx_1
end type
global w_58009_d w_58009_d

type variables
string  is_brand, is_order_gubn, is_year, is_season,is_from_date, is_to_date, is_country_cd
datawindowchild	idw_brand, idw_season, idw_country_cd, idw_unit
end variables

forward prototypes
public function any wf_report (string as_brand, string as_order_no)
end prototypes

public function any wf_report (string as_brand, string as_order_no);/*===========================================================================*/
/* 작성자      : 최용운                                                   */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
long ll_rows

if isnull(as_order_no) or LenA(as_order_no) < 8 then return 0

open(w_58007_e)
ll_rows = w_58007_e.dw_body.retrieve(as_brand,as_order_no)
ll_rows = w_58007_e.dw_detail.retrieve(as_brand,as_order_no)
w_58007_e.dw_head.Setitem(1,"brand",as_brand)
w_58007_e.dw_head.Setitem(1,"order_no",as_order_no)
return	1



end function

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

is_order_gubn = dw_head.GetItemString(1, "order_gubn")
if IsNull(is_order_gubn) or Trim(is_order_gubn) = "" then
   MessageBox(ls_title,"구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("order_gubn")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   is_year  = '%'  
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   is_season = '%' 
end if


is_from_date = dw_head.GetItemString(1, "from_date")
if IsNull(is_from_date) or Trim(is_from_date) = "" then
   MessageBox(ls_title,"입항일 From date를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("From_date")
   return false
end if

is_to_date = dw_head.GetItemString(1, "to_date")
if IsNull(is_to_date) or Trim(is_to_date) = "" then
   MessageBox(ls_title,"입항일 To date를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_date")
   return false
end if

if is_from_date > is_to_date then
	messagebox("확인", "From Date 가 더 큽니다 !")
end if

is_country_cd = dw_head.GetItemString(1, "country_cd")
if IsNull(is_country_cd) or Trim(is_country_cd) = "" then
	is_country_cd = '%'
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

if cbx_1.checked then 
	dw_body.dataobject = "d_58009_d02"
	dw_print.dataobject = "d_58009_r02"
	
	dw_body.GetChild("country_cd", idw_country_cd)
	idw_country_cd.SetTransObject(SQLCA)
	idw_country_cd.Retrieve('000')
	
	dw_print.GetChild("country_cd", idw_country_cd)
	idw_country_cd.SetTransObject(SQLCA)
	idw_country_cd.Retrieve('000')
	
else
	dw_body.dataobject = "d_58009_d01"
	dw_print.dataobject = "d_58009_r01"
	
	dw_body.GetChild("country_cd", idw_country_cd)
	idw_country_cd.SetTransObject(SQLCA)
	idw_country_cd.Retrieve('000')
	
	dw_body.GetChild("qty_unit", idw_unit)
	idw_unit.SetTransObject(SQLCA)
	idw_unit.Retrieve('004')	
	
	dw_print.GetChild("country_cd", idw_country_cd)
	idw_country_cd.SetTransObject(SQLCA)
	idw_country_cd.Retrieve('000')
	
	dw_print.GetChild("qty_unit", idw_unit)
	idw_unit.SetTransObject(SQLCA)
	idw_unit.Retrieve('004')

	
	
end if
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


il_rows = dw_body.retrieve(is_brand, is_order_gubn, is_year, is_season,is_from_date, is_to_date, is_country_cd)
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

on w_58009_d.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
end on

on w_58009_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
end on

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_country, ls_order_gubn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_country_cd = '%'  then
	ls_country = '% 전체'
else
	 gf_inter_nm('000', is_country_cd,ls_country)
end if

if is_order_gubn = '%'  then
	ls_order_gubn = '% 전체'
elseif is_order_gubn = 'M'  then
	 ls_order_gubn = 'M 원자재'
elseif is_order_gubn = 'G'  then
	 ls_order_gubn = 'G 상품'
end if

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	 "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"				 

dw_print.Modify(ls_modify)

dw_print.object.t_order_gubn.Text = ls_order_gubn
dw_print.object.t_brand.Text = idw_brand.GetItemString(idw_brand.GetRow(), "inter_display")
dw_print.object.t_year.Text = is_year
dw_print.object.t_season.Text = idw_season.GetItemString(idw_season.GetRow(), "inter_display")
dw_print.object.t_yymmdd.Text = String(is_from_date, '@@@@/@@/@@') + ' ~ ' + String(is_to_date, '@@@@/@@/@@')
dw_print.object.t_country.Text = ls_country

end event

event open;call super::open;datetime	ld_datetime
string   ls_from_date, ls_to_date

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_to_date = String(ld_datetime, "yyyymmdd")
ls_from_date = LeftA(ls_to_date,6) + '01'

dw_head.Setitem(1,"from_date", ls_from_date)
dw_head.Setitem(1,"to_date", ls_to_date)
end event

type cb_close from w_com010_d`cb_close within w_58009_d
end type

type cb_delete from w_com010_d`cb_delete within w_58009_d
end type

type cb_insert from w_com010_d`cb_insert within w_58009_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_58009_d
end type

type cb_update from w_com010_d`cb_update within w_58009_d
end type

type cb_print from w_com010_d`cb_print within w_58009_d
end type

type cb_preview from w_com010_d`cb_preview within w_58009_d
end type

type gb_button from w_com010_d`gb_button within w_58009_d
end type

type cb_excel from w_com010_d`cb_excel within w_58009_d
end type

type dw_head from w_com010_d`dw_head within w_58009_d
string dataobject = "d_58009_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')
idw_country_cd.InsertRow(1)
idw_country_cd.SetItem(1, "inter_cd", '%')
idw_country_cd.SetItem(1, "inter_nm", '전체')


end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
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

type ln_1 from w_com010_d`ln_1 within w_58009_d
end type

type ln_2 from w_com010_d`ln_2 within w_58009_d
end type

type dw_body from w_com010_d`dw_body within w_58009_d
integer y = 460
integer height = 1580
string dataobject = "d_58009_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')

This.GetChild("qty_unit", idw_unit)
idw_unit.SetTransObject(SQLCA)
idw_unit.Retrieve('004')


end event

event dw_body::clicked;call super::clicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
String 	ls_search, ls_brand
if row > 0 then 
	choose case dwo.name
		case 'order_no' 
			ls_search 	= this.GetItemString(row,string(dwo.name))
			ls_brand 	= this.GetItemString(row,"brand")
			if LenA(ls_search)  >= 8 then	wf_report(ls_brand,ls_search)					
	end choose	
end if

end event

type dw_print from w_com010_d`dw_print within w_58009_d
integer width = 910
integer height = 416
string dataobject = "d_58009_r01"
end type

event dw_print::constructor;call super::constructor;This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')

This.GetChild("qty_unit", idw_unit)
idw_unit.SetTransObject(SQLCA)
idw_unit.Retrieve('004')


end event

type cbx_1 from checkbox within w_58009_d
integer x = 2469
integer y = 328
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "상세내역"
borderstyle borderstyle = stylelowered!
end type

