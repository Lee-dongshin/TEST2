$PBExportHeader$w_43033_d.srw
$PBExportComments$물류월단위보고
forward
global type w_43033_d from w_com010_d
end type
type st_1 from statictext within w_43033_d
end type
end forward

global type w_43033_d from w_com010_d
integer width = 3675
integer height = 2272
st_1 st_1
end type
global w_43033_d w_43033_d

type variables
DataWindowChild idw_brand, idw_year, idw_house_cd
String is_brand, is_yymm, is_year, is_house_cd, is_opt_view
end variables

on w_43033_d.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_43033_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

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
   MessageBox(ls_title,"기준월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시작 제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if

is_opt_view = dw_head.GetItemString(1, "opt_view")
if IsNull(is_opt_view) or Trim(is_opt_view) = "" then
   MessageBox(ls_title,"조회구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_view")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


//exec SP_43033_D04 '200707','w','010000','2006'
if is_opt_view = "A" THEN
	DW_BODY.DATAOBJECT = "d_43033_d01"
	dw_body.SetTransObject(SQLCA)
	DW_print.DATAOBJECT = "d_43033_r01"
	DW_print.SetTransObject(SQLCA)	
elseif is_opt_view = "B" THEN
	DW_BODY.DATAOBJECT = "d_43033_d02"	
	dw_body.SetTransObject(SQLCA)
	DW_print.DATAOBJECT = "d_43033_r02"
	DW_print.SetTransObject(SQLCA)	
elseif is_opt_view = "C" THEN
	DW_BODY.DATAOBJECT = "d_43033_d03"	
	dw_body.SetTransObject(SQLCA)
	DW_print.DATAOBJECT = "d_43033_r03"
	DW_print.SetTransObject(SQLCA)	
else
	DW_BODY.DATAOBJECT = "d_43033_d04"		
	dw_body.SetTransObject(SQLCA)
	DW_print.DATAOBJECT = "d_43033_r04"
	DW_print.SetTransObject(SQLCA)	
end if

il_rows = dw_body.retrieve(is_yymm, is_brand, is_house_cd, is_year)
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43033_d","0")
end event

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	 "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" +idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &				 
             "t_yymm.Text = '" + is_yymm + "'" + &
             "t_year.Text = '" + is_year + "'" 

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_43033_d
end type

type cb_delete from w_com010_d`cb_delete within w_43033_d
end type

type cb_insert from w_com010_d`cb_insert within w_43033_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43033_d
end type

type cb_update from w_com010_d`cb_update within w_43033_d
end type

type cb_print from w_com010_d`cb_print within w_43033_d
end type

type cb_preview from w_com010_d`cb_preview within w_43033_d
end type

type gb_button from w_com010_d`gb_button within w_43033_d
end type

type cb_excel from w_com010_d`cb_excel within w_43033_d
end type

type dw_head from w_com010_d`dw_head within w_43033_d
string dataobject = "d_43033_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('%')

end event

type ln_1 from w_com010_d`ln_1 within w_43033_d
integer beginy = 420
integer endy = 420
end type

type ln_2 from w_com010_d`ln_2 within w_43033_d
integer beginy = 424
integer endy = 424
end type

type dw_body from w_com010_d`dw_body within w_43033_d
integer y = 432
integer height = 1608
string dataobject = "d_43033_d01"
end type

type dw_print from w_com010_d`dw_print within w_43033_d
end type

type st_1 from statictext within w_43033_d
integer x = 151
integer y = 340
integer width = 1751
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "※ 금액: 천원, 수량: PCS, 전년대비의 년도(해당년도 + 1년)"
boolean focusrectangle = false
end type

