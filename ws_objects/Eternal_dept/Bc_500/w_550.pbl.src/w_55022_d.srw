$PBExportHeader$w_55022_d.srw
$PBExportComments$시즌별비인기 판매현황
forward
global type w_55022_d from w_com010_d
end type
type dw_detail from datawindow within w_55022_d
end type
end forward

global type w_55022_d from w_com010_d
integer width = 3685
integer height = 2252
dw_detail dw_detail
end type
global w_55022_d w_55022_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_dep_seq, idw_disc_seq,idw_except_seq
String is_brand, is_year, is_season, is_dep_seq, is_yymmdd, is_rpt_gubn, is_except_gubn
String is_chi_gubn, is_disc_seq, is_opt_view, is_opt_style, is_except_seq, is_rus_gubn

end variables

on w_55022_d.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
end on

on w_55022_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
end on

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



is_rpt_gubn = dw_head.GetItemString(1, "rpt_gubn")
if IsNull(is_rpt_gubn) or Trim(is_rpt_gubn) = "" then
   MessageBox(ls_title,"조회구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rpt_gubn")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_except_gubn = dw_head.GetItemString(1, "except_gubn")
if IsNull(is_except_gubn) or Trim(is_except_gubn) = "" then
   MessageBox(ls_title,"사입제외 여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("except_gubn")
   return false
end if

is_chi_gubn = dw_head.GetItemString(1, "chi_gubn")
if IsNull(is_chi_gubn) or Trim(is_chi_gubn) = "" then
   MessageBox(ls_title,"중국제외 여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("chi_gubn")
   return false
end if

is_rus_gubn = dw_head.GetItemString(1, "rus_gubn")
if IsNull(is_rus_gubn) or Trim(is_rus_gubn) = "" then
   MessageBox(ls_title,"레시아제외 여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rus_gubn")
   return false
end if

is_opt_view = dw_head.GetItemString(1, "opt_view")
if IsNull(is_opt_view) or Trim(is_opt_view) = "" then
   MessageBox(ls_title,"조회대상을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_view")
   return false
end if


if is_opt_view <> "A" then
	is_disc_seq = dw_head.GetItemString(1, "disc_seq")
	if IsNull(is_disc_seq) or Trim(is_disc_seq) = "" then
		MessageBox(ls_title,"품목할인 차수를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("disc_seq")
		return false
	end if
else
	is_dep_seq = dw_head.GetItemString(1, "dep_seq")
	if IsNull(is_dep_seq) or Trim(is_dep_seq) = "" then
		MessageBox(ls_title,"부진차수를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("dep_seq")
		return false
	end if
end if

is_opt_style = dw_head.GetItemString(1, "opt_style")
if IsNull(is_opt_style) or Trim(is_opt_style) = "" then
   MessageBox(ls_title,"선정구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_style")
   return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
// exec sp_55022_d01 'o','2003','w','%','20031201'

if is_opt_view = "A" then
	if is_rpt_gubn = "Y" then
		dw_body.DataObject = "d_55022_d02"
		dw_print.DataObject = "d_55022_r02"	
		dw_body.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)	
	else	
		dw_body.DataObject = "d_55022_d01"	
		dw_print.DataObject = "d_55022_r01"		
		dw_body.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)	
	end if	
elseif is_opt_view = "B" then
	if is_rpt_gubn = "Y" then
		dw_body.DataObject = "d_55022_d04"
		dw_print.DataObject = "d_55022_r04"	
		dw_body.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)	
	else	
		dw_body.DataObject = "d_55022_d03"	
		dw_print.DataObject = "d_55022_r03"		
		dw_body.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)	
	end if	
else
	if is_rpt_gubn = "Y" then
		dw_body.DataObject = "d_55022_d06"
		dw_print.DataObject = "d_55022_r06"	
		dw_body.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)	
	else	
		dw_body.DataObject = "d_55022_d05"	
		dw_print.DataObject = "d_55022_r05"		
		dw_body.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)	
	end if		
end if


if is_opt_view = "A" then
	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_dep_seq, is_yymmdd, is_except_gubn, is_chi_gubn, is_rus_gubn)
else
	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_disc_seq, is_yymmdd, is_except_gubn, is_chi_gubn, is_rus_gubn, is_opt_style)
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55022_d","0")
end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime,ls_title, ls_except

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_except_gubn = "Y" then
	ls_except = "※ 사입제외"
else
	ls_except = "※ 사입포함"
end if	

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify  = "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
				 "t_yymmdd.Text = '" + is_yymmdd + "'"  + &
				 "t_except_gubn.Text = '" + ls_except + "'" 		 
dw_print.Modify(ls_modify)


end event

event open;call super::open;is_brand = dw_head.GetItemString(1, "brand")
is_year  = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")

idw_dep_seq.Retrieve(is_brand, is_year, is_season)
idw_dep_seq.InsertRow(1)
idw_dep_seq.SetItem(1, "dep_seq", '%')
idw_dep_seq.SetItem(1, "dep_ymd", '전체')

end event

event pfc_preopen();call super::pfc_preopen;dw_detail.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_55022_d
end type

type cb_delete from w_com010_d`cb_delete within w_55022_d
end type

type cb_insert from w_com010_d`cb_insert within w_55022_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55022_d
end type

type cb_update from w_com010_d`cb_update within w_55022_d
end type

type cb_print from w_com010_d`cb_print within w_55022_d
end type

type cb_preview from w_com010_d`cb_preview within w_55022_d
end type

type gb_button from w_com010_d`gb_button within w_55022_d
end type

type cb_excel from w_com010_d`cb_excel within w_55022_d
end type

type dw_head from w_com010_d`dw_head within w_55022_d
integer y = 156
integer width = 3543
integer height = 264
string dataobject = "d_55022_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTRansObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

This.GetChild("year", idw_year)
idw_year.SetTRansObject(SQLCA)
idw_year.Retrieve('002')


This.GetChild("dep_seq", idw_dep_seq)
idw_dep_seq.SetTRansObject(SQLCA)
idw_dep_seq.InsertRow(1)
idw_dep_seq.Setitem(1, "inter_cd", "%")
idw_dep_seq.Setitem(1, "inter_nm", "전체")


This.GetChild("disc_seq", idw_disc_seq)
idw_disc_seq.SetTRansObject(SQLCA)
idw_disc_seq.InsertRow(1)
idw_disc_seq.Setitem(1, "inter_cd", "%")
idw_disc_seq.Setitem(1, "inter_nm", "전체")



This.GetChild("except_seq", idw_except_seq)
idw_except_seq.SetTRansObject(SQLCA)
idw_except_seq.InsertRow(1)
idw_except_seq.Setitem(1, "inter_cd", "%")
idw_except_seq.Setitem(1, "inter_nm", "전체")


end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(1, "dep_seq", "")
		is_brand = data
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_except_seq.Retrieve(is_brand, is_year, is_season)
		idw_except_seq.InsertRow(1)
		idw_except_seq.SetItem(1, "dep_seq", '%')
		idw_except_seq.SetItem(1, "dep_ymd", '전체')	
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
	
		
	CASE "year"
		This.SetItem(1, "dep_seq", "")
		is_year = data
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_except_seq.Retrieve(is_brand, is_year, is_season)
		idw_except_seq.InsertRow(1)
		idw_except_seq.SetItem(1, "dep_seq", '%')
		idw_except_seq.SetItem(1, "dep_ymd", '전체')		
		
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
				  								
				
		
	CASE "season"
		This.SetItem(1, "dep_seq", "")
		is_season = data
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_except_seq.Retrieve(is_brand, is_year, is_season)
		idw_except_seq.InsertRow(1)
		idw_except_seq.SetItem(1, "dep_seq", '%')
		idw_except_seq.SetItem(1, "dep_ymd", '전체')		
				
		
	CASE "opt_view"
		if data = "B" then 
			dw_head.object.opt_style.visible = true
			dw_head.object.t_2.visible = true			
		else
			dw_head.object.opt_style.visible = false
			dw_head.object.t_2.visible = false
		end if

		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_except_seq.Retrieve(is_brand, is_year, is_season)
		idw_except_seq.InsertRow(1)
		idw_except_seq.SetItem(1, "dep_seq", '%')
		idw_except_seq.SetItem(1, "dep_ymd", '전체')					
			
						
				

END CHOOSE 
end event

type ln_1 from w_com010_d`ln_1 within w_55022_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_d`ln_2 within w_55022_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_55022_d
integer y = 440
integer width = 3598
integer height = 1576
string dataobject = "d_55022_d01"
boolean hscrollbar = true
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_shop_nm, ls_style, ls_chno
   
	
dw_detail.reset()
ls_style =  dw_body.GetitemString(row,"style")	
ls_chno = '%'


IF ls_style = "" OR isnull(ls_style) THEN		
	return
END IF
	
IF dw_detail.RowCount() < 1 THEN 
	il_rows = dw_detail.retrieve(ls_style, ls_chno)	
END IF 

dw_detail.visible = True

end event

type dw_print from w_com010_d`dw_print within w_55022_d
string dataobject = "d_55022_r01"
end type

type dw_detail from datawindow within w_55022_d
boolean visible = false
integer x = 754
integer y = 160
integer width = 1838
integer height = 1732
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "스타일조회"
string dataobject = "d_style_pic"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;dw_detail.visible = false
end event

