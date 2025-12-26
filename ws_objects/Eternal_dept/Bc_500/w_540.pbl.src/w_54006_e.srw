$PBExportHeader$w_54006_e.srw
$PBExportComments$시즌Out부진등록
forward
global type w_54006_e from w_com010_e
end type
type dw_1 from datawindow within w_54006_e
end type
end forward

global type w_54006_e from w_com010_e
integer width = 3685
integer height = 2272
dw_1 dw_1
end type
global w_54006_e w_54006_e

type variables
string  is_brand, is_year, is_season, is_sojae, is_item, is_out_seq , is_check1 = 'N'
DataWindowChild   idw_brand, idw_season, idw_sojae, idw_item, idw_out_seq

end variables

on w_54006_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_54006_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event pfc_preopen;call super::pfc_preopen;string ls_dep_ymd 
datetime ld_datetime
IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_dep_ymd = String(ld_datetime, "yyyymmdd")
dw_head.Setitem(1,"dep_ymd", ls_dep_ymd)

dw_1.SetTransObject(SQLCA)

end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징 (김 종호)                              */	
/* 작성일      : 2002.02.05                                                 */	
/* 수정일      : 2002.02.05                                                  */
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
	
return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징 (김 종호)                              */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_1.retrieve(is_brand,is_year,is_season,is_sojae,is_item,is_out_seq)  /*부진모델 file read */

il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_sojae,is_item,is_out_seq)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)



end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/*===========================================================================*/
long i, ll_row_count,ll_row
datetime ld_datetime
STRING   ls_style, ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_out_seq, ls_dep_fg,ls_sel_yn

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
		ls_dep_fg  = dw_body.GetitemString(i, "dep_fg") 
	
	   IF ls_dep_fg = 'O' THEN   //시즌out 부진 이면 // 
			ll_row = dw_1.Find("style = '" + ls_style + "'", 1, dw_1.RowCount())
			IF ll_row > 0 THEN 
				ls_sel_yn = dw_1.GetItemString(ll_row, "sel_yn")
				If ls_sel_yn = 'Y' Then
					dw_1.SetItem(ll_row, "dep_fg", ls_dep_fg)
					dw_1.Setitem(ll_row, "mod_id", gs_user_id)
					dw_1.Setitem(ll_row, "mod_dt", ld_datetime)	
				End IF
			Else
				ll_row = dw_1.InsertRow(0)
				dw_1.Setitem(ll_row, "style", ls_style) 
		      dw_1.Setitem(ll_row, "brand" , ls_brand)
				dw_1.Setitem(ll_row, "year" , ls_year) 
				dw_1.Setitem(ll_row, "season" , ls_season) 
				dw_1.Setitem(ll_row, "sojae" , ls_sojae) 
				dw_1.Setitem(ll_row, "item" , ls_item) 
				dw_1.Setitem(ll_row, "out_seq" , ls_out_seq) 
				dw_1.Setitem(ll_row, "sel_yn" , 'N') 
				dw_1.Setitem(ll_row, "dep_fg" , ls_dep_fg) 
            dw_1.Setitem(ll_row, "reg_id",  gs_user_id)
			End If
		Else
			ll_row = dw_1.Find("style = '" + ls_style + "'", 1, dw_1.RowCount())
			IF ll_row > 0 THEN 
				ls_sel_yn = dw_1.GetItemString(ll_row, "sel_yn")
				If ls_sel_yn = 'Y' Then
					dw_1.SetItem(ll_row, "dep_fg", 'N')
					dw_1.Setitem(ll_row, "mod_id", gs_user_id)
					dw_1.Setitem(ll_row, "mod_dt", ld_datetime)	
				Else
					dw_1.DeleteRow(ll_row)
				End IF
			End If
		End If
		dw_body.Setitem(ll_row, "mod_id", gs_user_id)
		dw_body.Setitem(ll_row, "mod_dt", ld_datetime)	
	End If
NEXT

il_rows = dw_body.Update(TRUE, FALSE)
if il_rows = 1 then
   il_rows = dw_1.Update(TRUE, FALSE)
end if

if il_rows = 1  then
	dw_body.ResetUpdate()
	dw_1.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54006_e","0")
end event

type cb_close from w_com010_e`cb_close within w_54006_e
end type

type cb_delete from w_com010_e`cb_delete within w_54006_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_54006_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_54006_e
end type

type cb_update from w_com010_e`cb_update within w_54006_e
end type

type cb_print from w_com010_e`cb_print within w_54006_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_54006_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_54006_e
end type

type cb_excel from w_com010_e`cb_excel within w_54006_e
end type

type dw_head from w_com010_e`dw_head within w_54006_e
string dataobject = "d_54006_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/* event       : constructor(dw_head)                                        */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTRansObject(SQLCA)
idw_season.Retrieve('003')

This.GetChild("item", idw_item)
idw_item.SetTRansObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.insertrow(1)
idw_item.Setitem(1, "item", "%")
idw_item.Setitem(1, "item_nm", "전체")

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
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

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name

		
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

type ln_1 from w_com010_e`ln_1 within w_54006_e
end type

type ln_2 from w_com010_e`ln_2 within w_54006_e
end type

type dw_body from w_com010_e`dw_body within w_54006_e
integer y = 460
integer width = 3598
string dataobject = "d_54006_d01"
end type

event dw_body::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : M.S.I (정 시영)															  */	
/* 작성일      : 2000.09.18																  */	
/* 수정일      : 2000.09.18																  */
/*===========================================================================*/
long	ll_row_count, i

CHOOSE CASE dwo.name
	CASE "cb_allselect"
		If is_check1 = 'N' then
			is_check1 = 'O'
			This.Object.cb_allselect.Text = '전체제외'
		Else
			is_check1 = 'N'
			This.Object.cb_allselect.Text = '전체선택'
		End If
		
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "dep_fg", is_check1)
		Next
		
END CHOOSE


end event

event dw_body::clicked;call super::clicked;string ls_style
choose case dwo.name
	case "style"
		ls_style = this.getitemstring(row, "style")
		gf_style_pic(ls_style,"%")
end choose
end event

type dw_print from w_com010_e`dw_print within w_54006_e
integer x = 2240
integer y = 268
end type

type dw_1 from datawindow within w_54006_e
boolean visible = false
integer x = 2158
integer y = 600
integer width = 649
integer height = 452
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_54006_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

