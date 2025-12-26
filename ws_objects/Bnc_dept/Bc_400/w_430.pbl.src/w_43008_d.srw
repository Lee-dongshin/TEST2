$PBExportHeader$w_43008_d.srw
$PBExportComments$년도시즌별재고내역
forward
global type w_43008_d from w_com010_d
end type
type st_1 from statictext within w_43008_d
end type
end forward

global type w_43008_d from w_com010_d
integer width = 3675
integer height = 2240
string title = "년도시즌별재고현황"
st_1 st_1
end type
global w_43008_d w_43008_d

type variables
DataWindowChild idw_brand, idw_year,idw_season, idw_cost_season
string is_brand,  is_year, is_season, is_yymmdd, is_cost_season

end variables

on w_43008_d.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_43008_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
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


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif (gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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



is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
 is_season = "%"
end if

is_cost_season = dw_head.GetItemString(1, "cost_season")
if IsNull(is_cost_season) or Trim(is_cost_season) = "" then
 is_cost_season = "%"
elseif  is_season <> "X" then 
	is_cost_season = "%"
else 	
	is_cost_season = is_cost_season
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

//exec sp_43008_d01 '20011215' , 'n', '1' ,'%'

//messagebox("is_yymmdd", is_yymmdd)
//messagebox("is_brand", is_brand)
//messagebox("is_year", is_year)
//messagebox("is_season", is_season)
//messagebox("is_cost_season", is_cost_season)

il_rows = dw_body.retrieve( is_yymmdd,is_brand, is_year,  is_season, is_cost_season)
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
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
//					"t_year.Text = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "'" + &					
ls_modify =		"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_year.Text = '" + dw_head.GetItemString(1,'year') + "'" + &										
					"t_yymmdd.Text = '" + is_yymmdd + "'" + &										
					"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" 

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43008_d","0")
end event

type cb_close from w_com010_d`cb_close within w_43008_d
end type

type cb_delete from w_com010_d`cb_delete within w_43008_d
end type

type cb_insert from w_com010_d`cb_insert within w_43008_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43008_d
end type

type cb_update from w_com010_d`cb_update within w_43008_d
end type

type cb_print from w_com010_d`cb_print within w_43008_d
end type

type cb_preview from w_com010_d`cb_preview within w_43008_d
end type

type gb_button from w_com010_d`gb_button within w_43008_d
end type

type cb_excel from w_com010_d`cb_excel within w_43008_d
end type

type dw_head from w_com010_d`dw_head within w_43008_d
integer y = 196
integer height = 224
string dataobject = "d_43008_h01"
end type

event dw_head::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
//
//THIS.GetChild("year", idw_year)
//idw_year.SetTransObject(SQLCA)
//idw_year.Retrieve('002')
//idw_year.InsertRow(1)
//idw_year.SetItem(1, "inter_cd", '%')
//idw_year.SetItem(1, "inter_cd1", '%')
//idw_year.SetItem(1, "inter_nm", '전체')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")


this.getchild("cost_season",idw_cost_season)
idw_cost_season.settransobject(sqlca)
idw_cost_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_cost_season.insertrow(1)
idw_cost_season.Setitem(1, "inter_cd", "%")
idw_cost_season.Setitem(1, "inter_nm", "전체")



// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "brand", "year"		
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_43008_d
end type

type ln_2 from w_com010_d`ln_2 within w_43008_d
end type

type dw_body from w_com010_d`dw_body within w_43008_d
integer x = 9
integer y = 460
integer width = 3584
integer height = 1540
string dataobject = "d_43008_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_43008_d
integer x = 2409
integer y = 188
integer width = 722
integer height = 440
string dataobject = "d_43008_r01"
end type

type st_1 from statictext within w_43008_d
integer x = 2834
integer y = 228
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "원가(VAT+)"
boolean focusrectangle = false
end type

