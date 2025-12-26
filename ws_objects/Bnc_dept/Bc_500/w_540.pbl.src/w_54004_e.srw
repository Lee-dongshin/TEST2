$PBExportHeader$w_54004_e.srw
$PBExportComments$부진모델분석
forward
global type w_54004_e from w_com010_e
end type
type dw_1 from datawindow within w_54004_e
end type
end forward

global type w_54004_e from w_com010_e
string title = "부진모델분석"
dw_1 dw_1
end type
global w_54004_e w_54004_e

type variables
string  is_brand, is_year, is_season, is_sojae, is_item, is_out_seq,is_dep_seq,is_dep_ymd, is_work_gubn
DataWindowChild   idw_brand, idw_season, idw_sojae, idw_item, idw_out_seq

end variables

on w_54004_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_54004_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징 (김 종호)                              */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.01.30                                                  */
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

is_out_seq = dw_head.GetitemString(1, "out_seq")
if Isnull(is_out_seq) or Trim(is_out_seq) = "" then
	MessageBox(ls_title, "출고차수를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("out_seq")
	return false
end if

is_work_gubn = dw_head.GetitemString(1, "work_gubn")
if Isnull(is_work_gubn) or Trim(is_work_gubn) = "" then
	MessageBox(ls_title, "작업구분을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("work_gubn")
	return false
end if
 	
return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징 (김 종호)                              */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.01.30                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_work_gubn = "A" then 
	dw_1.dataobject = "d_54004_d02"
	dw_1.SetTransObject(SQLCA)
	
	dw_print.dataobject = "d_54004_r01"
	dw_print.SetTransObject(SQLCA)
	
elseif is_work_gubn = "B" then	
	dw_1.dataobject = "d_54004_d03"
	dw_1.SetTransObject(SQLCA)
	
	dw_print.dataobject = "d_54004_r02"
	dw_print.SetTransObject(SQLCA)
else
	dw_1.dataobject = "d_54004_d04"
	dw_1.SetTransObject(SQLCA)
	
	dw_print.dataobject = "d_54004_r03"
	dw_print.SetTransObject(SQLCA)		
	
end if	
	

dw_1.retrieve(is_brand,is_year,is_season,is_sojae,is_item,is_out_seq)
il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_sojae,is_item,is_out_seq, is_work_gubn)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)



end event

event pfc_preopen;call super::pfc_preopen;string ls_dep_ymd 
datetime ld_datetime
IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_1.SetTransObject(SQLCA)
end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/
long i, ll_row_count,ll_row
datetime ld_datetime
STRING   ls_style, ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_out_seq, ls_sel_yn

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN 
		ls_style   = dw_body.GetitemString(i, "style") 
		ls_brand   = dw_body.GetitemString(i, "brand")
		ls_year    = dw_body.GetitemString(i, "year") 
		ls_season  = dw_body.GetitemString(i, "season") 
		ls_sojae   = dw_body.GetitemString(i, "sojae") 
		ls_item    = dw_body.GetitemString(i, "item") 
		ls_out_seq = dw_body.GetitemString(i, "out_seq") 
		ls_sel_yn  = dw_body.GetitemString(i, "sel_yn") 
		ll_row = dw_1.Find("style = '" + ls_style + "'", 1, dw_1.RowCount())
		IF ll_row > 0 THEN 
			IF  ls_sel_yn  = 'N'  THEN 
				 dw_1.DeleteRow(ll_row) 
			ELSE
				 dw_1.Setitem(ll_row, "style", ls_style) 
		       dw_1.Setitem(ll_row, "brand" , ls_brand)
				 dw_1.Setitem(ll_row, "year" , ls_year) 
				 dw_1.Setitem(ll_row, "season" , ls_season) 
				 dw_1.Setitem(ll_row, "sojae" , ls_sojae) 
				 dw_1.Setitem(ll_row, "item" , ls_item) 
				 dw_1.Setitem(ll_row, "out_seq" , ls_out_seq) 
				 dw_1.Setitem(ll_row, "sel_yn" , ls_sel_yn) 
             dw_1.Setitem(ll_row, "mod_id", gs_user_id)
             dw_1.Setitem(ll_row, "mod_dt", ld_datetime)
			END IF
		ELSE 
			IF ls_sel_yn  = 'N'  THEN 
			ELSE
		   	ll_row = dw_1.insertRow(0)
			   dw_1.Setitem(ll_row, "style", ls_style) 
		      dw_1.Setitem(ll_row, "brand" , ls_brand)
				dw_1.Setitem(ll_row, "year" , ls_year) 
				dw_1.Setitem(ll_row, "season" , ls_season) 
				dw_1.Setitem(ll_row, "sojae" , ls_sojae) 
				dw_1.Setitem(ll_row, "item" , ls_item) 
				dw_1.Setitem(ll_row, "out_seq" , ls_out_seq) 
				dw_1.Setitem(ll_row, "sel_yn" , ls_sel_yn) 
            dw_1.Setitem(ll_row, "reg_id",  gs_user_id)
			END IF
		END IF
   END IF
NEXT

il_rows = dw_1.Update()

if il_rows = 1 then
	dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows




end event

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

dw_print.Retrieve(is_brand,is_year,is_season,is_sojae,is_item,is_out_seq)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.02.02                                                  */	
/* 수정일      : 2002.02.02                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =  "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
				 "t_sojae.Text = '" + idw_sojae.GetItemString(idw_Sojae.GetRow(), "sojae_display") + "'"   + &
				 "t_item.Text = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'"   + &
				 "t_out_seq.Text = '" +  is_out_seq + "'"  
dw_print.Modify(ls_modify)



end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54004_e","0")
end event

type cb_close from w_com010_e`cb_close within w_54004_e
end type

type cb_delete from w_com010_e`cb_delete within w_54004_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_54004_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_54004_e
end type

type cb_update from w_com010_e`cb_update within w_54004_e
end type

type cb_print from w_com010_e`cb_print within w_54004_e
end type

type cb_preview from w_com010_e`cb_preview within w_54004_e
end type

type gb_button from w_com010_e`gb_button within w_54004_e
end type

type cb_excel from w_com010_e`cb_excel within w_54004_e
end type

type dw_head from w_com010_e`dw_head within w_54004_e
integer y = 168
integer height = 216
string dataobject = "d_54004_h01"
end type

event dw_head::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.01.30                                                  */
/* event       : constructor(dw_head)                                        */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTRansObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

This.GetChild("item", idw_item)
idw_item.SetTRansObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.insertrow(1)
idw_item.Setitem(1, "item", "%")
idw_item.Setitem(1, "item_nm", "전체")

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',gs_brand)
idw_sojae.insertrow(1)
idw_sojae.Setitem(1, "sojae", "%")
idw_sojae.Setitem(1, "sojae_nm", "전체")

This.GetChild("out_seq", idw_out_seq)
idw_out_seq.SetTransObject(SQLCA)
idw_out_seq.Retrieve('010')
idw_out_seq.Insertrow(1)
idw_out_seq.Setitem(1,"inter_cd", "%")
idw_out_seq.Setitem(1,"inter_nm", "전체")


end event

event dw_head::itemerror;call super::itemerror;CHOOSE CASE dwo.name

		
	CASE "brand"
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

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child



CHOOSE CASE dwo.name

	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
	
		This.GetChild("sojae", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('%', data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "sojae", "%")
		ldw_child.Setitem(1, "sojae_nm", "전체")
		
		This.GetChild("item", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve(data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "item", "%")
		ldw_child.Setitem(1, "item_nm", "전체")		
		
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

type ln_1 from w_com010_e`ln_1 within w_54004_e
integer beginy = 388
integer endy = 388
end type

type ln_2 from w_com010_e`ln_2 within w_54004_e
integer beginy = 392
integer endy = 392
end type

type dw_body from w_com010_e`dw_body within w_54004_e
integer y = 404
integer width = 3602
integer height = 1644
string dataobject = "d_54004_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::clicked;call super::clicked;string ls_style
choose case dwo.name
	case "style"
		ls_style = this.getitemstring(row, "style")
		gf_style_pic(ls_style,"%")
end choose
end event

type dw_print from w_com010_e`dw_print within w_54004_e
integer x = 251
integer y = 864
string dataobject = "d_54004_r02"
end type

type dw_1 from datawindow within w_54004_e
boolean visible = false
integer x = 1783
integer y = 980
integer width = 498
integer height = 288
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_54004_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

