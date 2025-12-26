$PBExportHeader$w_43014_d.srw
$PBExportComments$상품관리일계표
forward
global type w_43014_d from w_com010_d
end type
type dw_body1 from u_dw within w_43014_d
end type
end forward

global type w_43014_d from w_com010_d
integer width = 3680
integer height = 2244
string title = "상품관리일계표"
dw_body1 dw_body1
end type
global w_43014_d w_43014_d

type variables
DataWindowChild idw_brand, idw_frm_year, idw_frm_season, idw_to_year, idw_to_season, idw_house_cd
string is_brand, is_frm_year, is_frm_season, is_yymmdd,is_to_year, is_to_season, is_house_cd, is_opt_chi

end variables

on w_43014_d.create
int iCurrent
call super::create
this.dw_body1=create dw_body1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_body1
end on

on w_43014_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_body1)
end on

event pfc_preopen;call super::pfc_preopen;dw_body1.SetTransObject(SQLCA)
inv_resize.of_Register(dw_body1, "ScaleToRight")

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
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_frm_year = dw_head.GetItemString(1, "frm_year")
if IsNull(is_frm_year) or Trim(is_frm_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_year")
   return false
end if

is_to_year = dw_head.GetItemString(1, "to_year")
if IsNull(is_to_year) or Trim(is_to_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_year")
   return false
end if


is_frm_season = dw_head.GetItemString(1, "frm_season")
if IsNull(is_frm_season) or Trim(is_frm_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_season")
   return false
end if

is_to_season = dw_head.GetItemString(1, "to_season")
if IsNull(is_to_season) or Trim(is_to_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_season")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일자 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"기준일자 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if

is_opt_chi = dw_head.GetItemString(1, "opt_chi")
if IsNull(is_opt_chi) or Trim(is_opt_chi) = "" then
   MessageBox(ls_title,"중국구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_chi")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_43014_d01 'n', '20011215' ,'010000', '0' ,'s', '1', 'w'

il_rows = dw_body1.retrieve(is_brand,is_yymmdd, is_house_cd, is_frm_year,  is_frm_season, is_to_year,  is_to_season, is_opt_chi)
IF il_rows > 0 THEN
   dw_body1.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "yymmdd",string(ld_datetime, "yyyymmdd"))

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43014_d","0")
end event

type cb_close from w_com010_d`cb_close within w_43014_d
end type

type cb_delete from w_com010_d`cb_delete within w_43014_d
end type

type cb_insert from w_com010_d`cb_insert within w_43014_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43014_d
end type

type cb_update from w_com010_d`cb_update within w_43014_d
end type

type cb_print from w_com010_d`cb_print within w_43014_d
end type

type cb_preview from w_com010_d`cb_preview within w_43014_d
end type

type gb_button from w_com010_d`gb_button within w_43014_d
end type

type cb_excel from w_com010_d`cb_excel within w_43014_d
end type

type dw_head from w_com010_d`dw_head within w_43014_d
integer y = 156
integer height = 284
string dataobject = "d_43014_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("frm_year", idw_frm_year )
idw_frm_year.SetTransObject(SQLCA)
idw_frm_year.Retrieve('002')

This.GetChild("house_cd", idw_house_cd )
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('%')

This.GetChild("to_year", idw_to_year )
idw_to_year.SetTransObject(SQLCA)
idw_to_year.Retrieve('002')

This.GetChild("frm_season", idw_frm_season )
idw_frm_season.SetTransObject(SQLCA)
idw_frm_season.Retrieve('003')

This.GetChild("to_season", idw_to_season )
idw_to_season.SetTransObject(SQLCA)
idw_to_season.Retrieve('003')

 
// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

type ln_1 from w_com010_d`ln_1 within w_43014_d
integer beginx = 14
integer beginy = 448
integer endx = 3634
integer endy = 448
end type

type ln_2 from w_com010_d`ln_2 within w_43014_d
integer beginx = 14
integer beginy = 452
integer endx = 3634
integer endy = 452
end type

type dw_body from w_com010_d`dw_body within w_43014_d
integer y = 1140
integer height = 868
string dataobject = "d_43014_d02"
end type

type dw_print from w_com010_d`dw_print within w_43014_d
integer x = 2427
integer y = 1580
boolean enabled = false
end type

type dw_body1 from u_dw within w_43014_d
integer x = 5
integer y = 476
integer width = 3589
integer height = 648
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_43014_d01"
end type

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

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

event doubleclicked;call super::doubleclicked;IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

string ls_sojae, ls_item, ls_year, ls_season

//exec sp_43014_d02 'n', '20011215' ,'010000', '2001' ,'w', 'w', 'l'


ls_sojae = MidA(dw_body1.GetitemString(row, "sojae") ,1,1)
ls_item  = MidA(dw_body1.GetitemString(row, "item"),1,1) 
ls_season  = MidA(dw_body1.GetitemString(row, "season_nm"),1,1) 
ls_year  = MidA(dw_body1.GetitemString(row, "year"),1,4) 

il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_house_cd,  ls_year,&
                           ls_season, ls_sojae, ls_item, is_opt_chi)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF


end event

