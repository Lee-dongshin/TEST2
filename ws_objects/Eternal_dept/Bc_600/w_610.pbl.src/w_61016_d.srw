$PBExportHeader$w_61016_d.srw
$PBExportComments$브랜드매출분석
forward
global type w_61016_d from w_com020_d
end type
type dw_g1 from u_dw within w_61016_d
end type
type cb_max from commandbutton within w_61016_d
end type
type cb_min from commandbutton within w_61016_d
end type
end forward

global type w_61016_d from w_com020_d
integer width = 3707
integer height = 2280
dw_g1 dw_g1
cb_max cb_max
cb_min cb_min
end type
global w_61016_d w_61016_d

type variables
string is_brand, is_fr_ymd, is_to_ymd, is_sale_type, is_detail

datawindowchild idw_brand
end variables

on w_61016_d.create
int iCurrent
call super::create
this.dw_g1=create dw_g1
this.cb_max=create cb_max
this.cb_min=create cb_min
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_g1
this.Control[iCurrent+2]=this.cb_max
this.Control[iCurrent+3]=this.cb_min
end on

on w_61016_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_g1)
destroy(this.cb_max)
destroy(this.cb_min)
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

is_fr_ymd    = dw_head.GetItemString(1, "fr_ymd")
is_to_ymd    = dw_head.GetItemString(1, "to_ymd")
is_sale_type = dw_head.GetItemString(1, "sale_type")
is_detail    = dw_head.GetItemString(1, "cmpt")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if dw_g1.dataobject <> 'd_61016_g01' then
	dw_g1.dataobject = 'd_61016_g01'
	dw_g1.SetTransObject(SQLCA)
end if
	
il_rows = dw_g1.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_sale_type, is_detail)
dw_body.Reset()
IF il_rows > 0 THEN
	il_rows = dw_list.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_sale_type, is_detail)	
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)													  */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

/* Data window Resize */
inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToBottom")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(st_1, "ScaleToBottom")
inv_resize.of_Register(dw_g1, "ScaleToRight")


idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_g1.SetTransObject(SQLCA)


/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

event open;call super::open;datetime ld_datetime


IF gf_cdate(ld_datetime,-12)  THEN  
	dw_head.setitem(1,"fr_ymd",string(ld_datetime,"yyyy") + '0101')
end if

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_ymd",string(ld_datetime,"yyyymmdd"))
end if


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61016_d","0")
end event

type cb_close from w_com020_d`cb_close within w_61016_d
end type

type cb_delete from w_com020_d`cb_delete within w_61016_d
end type

type cb_insert from w_com020_d`cb_insert within w_61016_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_61016_d
end type

type cb_update from w_com020_d`cb_update within w_61016_d
end type

type cb_print from w_com020_d`cb_print within w_61016_d
end type

type cb_preview from w_com020_d`cb_preview within w_61016_d
end type

type gb_button from w_com020_d`gb_button within w_61016_d
end type

type cb_excel from w_com020_d`cb_excel within w_61016_d
end type

type dw_head from w_com020_d`dw_head within w_61016_d
integer height = 156
string dataobject = "d_61016_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertrow(1)
idw_brand.setitem(1,"inter_cd","%")
idw_brand.setitem(1,"inter_nm","전체")

end event

type ln_1 from w_com020_d`ln_1 within w_61016_d
integer beginy = 336
integer endy = 336
end type

type ln_2 from w_com020_d`ln_2 within w_61016_d
integer beginy = 340
integer endy = 340
end type

type dw_list from w_com020_d`dw_list within w_61016_d
integer y = 1160
integer width = 2043
integer height = 884
string dataobject = "d_61016_d01"
boolean hscrollbar = true
end type

event dw_list::constructor;//
end event

event dw_list::doubleclicked;call super::doubleclicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_yymmdd

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_yymmdd    = This.GetItemString(row, 'cate') /* DataWindow에 Key 항목을 가져온다 */


IF IsNull(ls_yymmdd) THEN return
ls_yymmdd = ls_yymmdd + '01'

il_rows = dw_body.retrieve(is_brand, ls_yymmdd, is_sale_type)
if il_rows > 0 then
	if dw_g1.dataobject <> 'd_61016_g02' then
		dw_g1.dataobject = 'd_61016_g02'
		dw_g1.SetTransObject(SQLCA)
	end if
	
	il_rows = dw_g1.retrieve(is_brand, ls_yymmdd, is_sale_type)
end if

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_61016_d
integer x = 2098
integer y = 1160
integer width = 1527
integer height = 884
string dataobject = "d_61016_d02"
boolean hscrollbar = true
end type

type st_1 from w_com020_d`st_1 within w_61016_d
integer x = 2080
integer y = 1160
integer height = 884
end type

type dw_print from w_com020_d`dw_print within w_61016_d
integer x = 718
integer y = 988
end type

type dw_g1 from u_dw within w_61016_d
integer x = 18
integer y = 348
integer width = 3602
integer height = 804
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_61016_g01"
end type

type cb_max from commandbutton within w_61016_d
integer x = 27
integer y = 1060
integer width = 110
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "+"
end type

event clicked;integer li_labels
li_labels = dec(dw_g1.object.gr_1.category.displayeverynlabels)
li_labels = li_labels + 1

if li_labels < 0 then 	li_labels = 0
dw_g1.object.gr_1.category.displayeverynlabels = li_labels
end event

type cb_min from commandbutton within w_61016_d
integer x = 137
integer y = 1060
integer width = 105
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "-"
end type

event clicked;integer li_labels
li_labels = dec(dw_g1.object.gr_1.category.displayeverynlabels)
li_labels = li_labels - 1

if li_labels < 0 then 	li_labels = 0
dw_g1.object.gr_1.category.displayeverynlabels = li_labels
end event

