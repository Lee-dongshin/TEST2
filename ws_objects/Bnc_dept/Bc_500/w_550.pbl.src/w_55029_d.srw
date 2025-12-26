$PBExportHeader$w_55029_d.srw
$PBExportComments$브랜드진행/차순진행조회
forward
global type w_55029_d from w_com010_d
end type
end forward

global type w_55029_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_55029_d w_55029_d

type variables
String is_rpt_opt, is_year, is_season, is_yymmdd, is_brand, is_opt_chn
DataWindowChild idw_brand, idw_year, idw_season
end variables

on w_55029_d.create
call super::create
end on

on w_55029_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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


//if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
//   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false	
//elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false		
//elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false			
//end if	





if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_rpt_opt = dw_head.GetItemString(1, "rpt_opt")
if IsNull(is_rpt_opt) or Trim(is_rpt_opt) = "" then
   MessageBox(ls_title,"레포트 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rpt_opt")
   return false
end if

is_opt_chn = dw_head.GetItemString(1, "opt_chn")
if IsNull(is_opt_chn) or Trim(is_opt_chn) = "" then
   MessageBox(ls_title,"조회구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_chn")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//@year       	varchar(4), 
//@season     	varchar(1),  
//@opt_chn	varchar(1)	= null,	-- C:중국, K:국내, A:전체 
//@yymmdd		varchar(08)
// 
if is_rpt_opt = "A" then 
	dw_body.dataobject = "d_55029_d01"
	dw_print.dataobject = "d_55029_r01"
else	
	dw_body.dataobject = "d_55029_d02"
	dw_print.dataobject = "d_55029_r02"	
end if 	
   dw_body.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)


if is_rpt_opt = "A" then 
	il_rows = dw_body.retrieve( is_year, is_season, is_opt_chn, is_yymmdd)

else	
	il_rows = dw_print.retrieve(is_brand, is_year, is_season, is_opt_chn, is_yymmdd)	
	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_opt_chn, is_yymmdd)

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

event open;call super::open;dw_body.Object.DataWindow.HorizontalScrollSplit  = 653
end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_opt_chn

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_opt_chn = 'A' Then
	ls_opt_chn = '전체'
Elseif  is_opt_chn = 'C' Then
	ls_opt_chn = '중국'
Else
	ls_opt_chn = '국내'	
End If

if is_rpt_opt = 'A' then 
	ls_modify =	"t_pg_id.Text      = '" + is_pgm_id    + "'" + &
					"t_user_id.Text    = '" + gs_user_id   + "'" + &
					"t_datetime.Text   = '" + ls_datetime  + "'" + &
					"t_yymmdd.Text     = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
					"t_year.Text       = '" + is_year      + "'" + &
					"t_season.Text     = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
					"t_opt_chn.Text    = '" + ls_opt_chn + "'" 
else				
		ls_modify =	"t_yymmdd.Text     = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
					"t_brand.Text      = '" + idw_brand.GetItemString(idw_brand.GetRow(),   "inter_display") + "'" + &
					"t_year.Text       = '" + is_year      + "'" + &
					"t_season.Text     = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
					"t_opt_chn.Text    = '" + ls_opt_chn + "'"
end if				

dw_print.Modify(ls_modify)
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

type cb_close from w_com010_d`cb_close within w_55029_d
end type

type cb_delete from w_com010_d`cb_delete within w_55029_d
end type

type cb_insert from w_com010_d`cb_insert within w_55029_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55029_d
end type

type cb_update from w_com010_d`cb_update within w_55029_d
end type

type cb_print from w_com010_d`cb_print within w_55029_d
end type

type cb_preview from w_com010_d`cb_preview within w_55029_d
end type

type gb_button from w_com010_d`gb_button within w_55029_d
end type

type cb_excel from w_com010_d`cb_excel within w_55029_d
end type

type dw_head from w_com010_d`dw_head within w_55029_d
integer x = 9
integer y = 160
integer width = 3584
integer height = 216
string dataobject = "d_55029_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
//idw_season.insertrow(1)
//idw_season.SetItem(1, "inter_cd", '%')
//idw_season.SetItem(1, "inter_nm", '전체')





end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name

	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
	
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

type ln_1 from w_com010_d`ln_1 within w_55029_d
integer beginy = 380
integer endy = 380
end type

type ln_2 from w_com010_d`ln_2 within w_55029_d
integer beginy = 384
integer endy = 384
end type

type dw_body from w_com010_d`dw_body within w_55029_d
integer y = 396
integer height = 1644
string dataobject = "d_55029_d01"
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_55029_d
string dataobject = "d_55029_r02"
end type

