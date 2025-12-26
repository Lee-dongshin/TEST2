$PBExportHeader$w_54008_d.srw
$PBExportComments$부진모델 현황
forward
global type w_54008_d from w_com010_d
end type
type dw_1 from datawindow within w_54008_d
end type
end forward

global type w_54008_d from w_com010_d
dw_1 dw_1
end type
global w_54008_d w_54008_d

type variables
string  is_brand, is_year, is_season, is_sojae, is_item, is_dep_seq, is_dep_fg, is_disc_seq, is_work_gubn, is_plan_except

DataWindowChild idw_brand, idw_season, idw_sojae, idw_item, idw_dep_seq, idw_dep_fg, idw_disc_seq
end variables

event open;call super::open;is_brand = dw_head.GetItemString(1, "brand")
is_year  = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")

idw_dep_seq.Retrieve(is_brand, is_year, is_season)
idw_dep_seq.InsertRow(1)
idw_dep_seq.SetItem(1, "dep_seq", '%')
idw_dep_seq.SetItem(1, "dep_ymd", '전체')

end event

on w_54008_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_54008_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징 (김 종호)                              */	
/* 작성일      : 2002.02.04                                                  */	
/* 수정일      : 2002.02.04                                                  */
/*===========================================================================*/
String   ls_title, ls_dep_seq

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




is_year = dw_head.GetitemString(1, "year")
if Isnull(is_year) or Trim(is_year) = "" then
	MessageBox(ls_title, "시즌년도를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("year")
	return false
end if

is_season = dw_head.GetitemString(1, "season")
if Isnull(is_season) or Trim(is_season) = "" then
	MessageBox(ls_title, "시즌을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("season")
	return false
end if

is_sojae = dw_head.GetitemString(1, "sojae")
if Isnull(is_sojae) or Trim(is_sojae) = "" then
	MessageBox(ls_title, "소재를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("sojae")
	return false
end if

is_item = dw_head.GetitemString(1, "item")
if Isnull(is_item) or Trim(is_item) = "" then
	MessageBox(ls_title, "품종을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("item")
	return false
end if

is_dep_seq = dw_head.GetitemString(1, "dep_seq")
if Isnull(is_dep_seq) or Trim(is_dep_seq) = "" then
	is_dep_seq = "%"
//	MessageBox(ls_title, "부진차수를 입력하십시요!")
//	dw_head.SetFocus()
//	dw_head.SetColumn("dep_seq")
//	return false
end if

is_dep_fg = dw_head.GetitemString(1, "dep_fg")
if Isnull(is_dep_fg) or Trim(is_dep_fg) = "" then
	MessageBox(ls_title, "부진구분을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("dep_fg")
	return false
end if 	

is_disc_seq = dw_head.GetitemString(1, "disc_seq")
if Isnull(is_disc_seq) or Trim(is_disc_seq) = "" then
	is_disc_seq = "%"
//	MessageBox(ls_title, "품목할인차수를 입력하십시요!")
//	dw_head.SetFocus()
//	dw_head.SetColumn("disc_seq")
//	return false
end if


is_work_gubn = dw_head.GetitemString(1, "work_gubn")
if Isnull(is_work_gubn) or Trim(is_work_gubn) = "" then
	MessageBox(ls_title, "조회구분을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("work_gubn")
	return false
end if

if is_work_gubn = "B" then 
	is_dep_seq = is_disc_seq
end if	

is_plan_except = dw_head.GetitemString(1, "plan_except")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징 (김 종호)                              */	
/* 작성일      : 2002.02.04                                                  */	
/* 수정일      : 2001.02.04                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_work_gubn = "A" then
			dw_body.DataObject = "d_54008_d01"
			dw_body.SetTransObject(SQLCA)

			dw_print.DataObject = "d_54008_r01"
			dw_print.SetTransObject(SQLCA)		
		
elseif is_work_gubn = "B" then			
		
			dw_body.DataObject = "d_54008_d02"
			dw_body.SetTransObject(SQLCA)

			dw_print.DataObject = "d_54008_r02"
			dw_print.SetTransObject(SQLCA)
else 			
			dw_body.DataObject = "d_54008_d03"
			dw_body.SetTransObject(SQLCA)

			dw_print.DataObject = "d_54008_r03"
			dw_print.SetTransObject(SQLCA)
			
end if

if is_work_gubn = "C" then
	il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_sojae,is_item,"%","%")
elseif is_work_gubn = "B" then
	il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_sojae,is_item,is_dep_seq,is_dep_fg, is_plan_except)
else	
	il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_sojae,is_item,is_dep_seq,is_dep_fg)
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

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
		   	 "t_sojae.Text = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_display") + "'"   + &
				 "t_item.Text = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'"   
dw_print.Modify(ls_modify)



end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54008_d","0")
end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_54008_d
end type

type cb_delete from w_com010_d`cb_delete within w_54008_d
end type

type cb_insert from w_com010_d`cb_insert within w_54008_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_54008_d
end type

type cb_update from w_com010_d`cb_update within w_54008_d
end type

type cb_print from w_com010_d`cb_print within w_54008_d
end type

type cb_preview from w_com010_d`cb_preview within w_54008_d
end type

type gb_button from w_com010_d`gb_button within w_54008_d
end type

type cb_excel from w_com010_d`cb_excel within w_54008_d
end type

type dw_head from w_com010_d`dw_head within w_54008_d
integer height = 256
string dataobject = "d_54008_h01"
end type

event dw_head::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.02.04                                                  */	
/* 수정일      : 2002.02.04                                                  */
/* event       : constructor(dw_head)                                        */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTRansObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", "%")
idw_item.SetItem(1, "item_nm", "전체")

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',gs_brand)
idw_sojae.insertrow(1)
idw_sojae.Setitem(1, "sojae", "%")
idw_sojae.Setitem(1, "sojae_nm", "전체")

This.GetChild("dep_fg", idw_dep_fg)
idw_dep_fg.SetTRansObject(SQLCA)
idw_dep_fg.Retrieve('540')
idw_dep_fg.insertrow(1)
idw_dep_fg.Setitem(1, "inter_cd", "%")
idw_dep_fg.Setitem(1, "inter_nm", "전체")

This.GetChild("dep_seq", idw_dep_seq)
idw_dep_seq.SetTRansObject(SQLCA)
idw_dep_seq.InsertRow(1)

This.GetChild("disc_seq", idw_disc_seq)
idw_disc_seq.SetTRansObject(SQLCA)
idw_disc_seq.InsertRow(1)


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.02.04                                                  */	
/* 수정일      : 2002.02.04                                                 */
/* event       : itemchanged(dw_head)                                        */
/*===========================================================================*/
string ls_gubn, ls_count

String ls_year, ls_brand
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
		dw_1.retrieve(is_year, is_season, is_brand)
		
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
		dw_1.retrieve(is_year, is_season, is_brand)

	CASE "work_gubn"
		
		is_brand = dw_head.getitemstring(1, "brand")
		is_year = dw_head.getitemstring(1, "year")
		is_season = dw_head.getitemstring(1, "season")
		
		if data = "A" then 
			
			dw_1.visible = false
			dw_head.object.plan_except.visible = false			
			dw_head.object.disc_seq.visible = false
			dw_head.object.t_1.visible = false			
			dw_head.object.dep_seq.visible = true
			dw_head.object.dep_seq_t.visible = true

		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
					
		elseif data = "B" then 
			dw_1.retrieve(is_year, is_season, is_brand)			
			dw_1.visible = true
			dw_head.object.plan_except.visible = true			
			dw_head.object.disc_seq.visible = true
			dw_head.object.t_1.visible = true		
			dw_head.object.dep_seq.visible = false	
			dw_head.object.dep_seq_t.visible = false	
			
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
	else
			dw_1.visible = false
			dw_head.object.plan_except.visible = false
			dw_head.object.disc_seq.visible = false
			dw_head.object.t_1.visible = false		
			dw_head.object.dep_seq.visible = false	
			dw_head.object.dep_seq_t.visible = false	
			
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')	
		

			
		end if
			
		
	
END CHOOSE 
		 
end event

type ln_1 from w_com010_d`ln_1 within w_54008_d
end type

type ln_2 from w_com010_d`ln_2 within w_54008_d
end type

type dw_body from w_com010_d`dw_body within w_54008_d
string dataobject = "d_54008_d01"
end type

event dw_body::clicked;string ls_style
choose case dwo.name
	case "style"
		ls_style = this.getitemstring(row, "style")
		gf_style_pic(ls_style,"%")
end choose
end event

type dw_print from w_com010_d`dw_print within w_54008_d
integer x = 2071
integer y = 508
string dataobject = "d_54008_r03"
end type

type dw_1 from datawindow within w_54008_d
boolean visible = false
integer x = 2231
integer y = 512
integer width = 590
integer height = 548
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "선정횟수"
string dataobject = "d_54008_d04"
boolean border = false
boolean livescroll = true
end type

