$PBExportHeader$w_62099_d.srw
$PBExportComments$미사용-출고상품 인기도분석
forward
global type w_62099_d from w_com010_d
end type
type dw_1 from datawindow within w_62099_d
end type
type dw_2 from datawindow within w_62099_d
end type
type dw_3 from datawindow within w_62099_d
end type
type cb_shop from commandbutton within w_62099_d
end type
type dw_4 from datawindow within w_62099_d
end type
end forward

global type w_62099_d from w_com010_d
integer width = 3698
integer height = 2268
event ue_stage_set ( )
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
cb_shop cb_shop
dw_4 dw_4
end type
global w_62099_d w_62099_d

type variables
string is_brand , is_year, is_season, is_item, is_style, is_fr_yymmdd, is_to_yymmdd
datawindowchild idw_brand, idw_season, idw_item
end variables

event ue_stage_set();dw_1.height = dw_body.height/2 - 10
dw_2.y 	   = dw_body.y + dw_body.height/2 
dw_2.height = dw_1.height
end event

on w_62099_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.cb_shop=create cb_shop
this.dw_4=create dw_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.cb_shop
this.Control[iCurrent+5]=this.dw_4
end on

on w_62099_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.cb_shop)
destroy(this.dw_4)
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

is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_item = dw_head.GetItemString(1, "item")
is_style = dw_head.GetItemString(1, "style")
is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_item, is_style, is_fr_yymmdd, is_to_yymmdd)
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
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToBottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

inv_resize.of_Register(dw_1, "ScaleToRight")
inv_resize.of_Register(dw_2, "ScaleToRight&Bottom")


/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


post event ue_stage_set()



end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_62099_d","0")
end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
			cb_shop.Enabled = true
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      ib_changed = false
		cb_shop.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_preview();dw_print.dataobject = 'd_62099_r01'
dw_print.SetTransObject(SQLCA)


This.Trigger Event ue_title ()
dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();dw_print.dataobject = 'd_62099_r04'
dw_print.SetTransObject(SQLCA)

This.Trigger Event ue_title()
dw_3.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()



end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.06.26                                                  */	
/* 수정일      : 2002.06.26                                                  */
/*===========================================================================*/
datetime ld_datetime
string   ls_modify, ls_datetime, ls_style, ls_season 

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

if dw_print.dataobject = 'd_62099_r04' then

		IF isnull(is_year) or LenA(is_year) = 0  THEN
			ls_season = '전체년도/' +  idw_season.GetitemString(idw_season.GetRow(), "inter_display") 
		ELSE
			ls_season = is_year + '/' +  idw_season.GetitemString(idw_season.GetRow(), "inter_display") 
		END IF 
		
		IF isnull(is_style) or LenA(is_style) = 0  THEN
			ls_style = '% 전체스타일'
		END IF 
		
		
		ls_modify =	"t_pg_id.Text      = '" + is_pgm_id + "'" + &
						"t_user_id.Text    = '" + gs_user_id + "'" + &
						"t_datetime.Text   = '" + ls_datetime + "'" + & 				
						"t_brand.Text      = '" + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") + "'" + &
						"t_yearseason.Text = '" + ls_season + "'"  + &
						"t_item.Text       = '" + idw_item.GetitemString(idw_item.GetRow(), "item_display") + "'" + &
						"t_style.Text      = '" + idw_item.GetitemString(idw_item.GetRow(), "item_display") + "'"
						
		
		dw_print.Modify(ls_modify)


		dw_print.object.t_yymmdd.Text = String(is_fr_yymmdd, "@@@@/@@/@@") + " - " +  String(is_to_yymmdd, "@@@@/@@/@@")
else
		ls_modify =	"t_pg_id.Text      = '" + is_pgm_id + "'" + &
						"t_user_id.Text    = '" + gs_user_id + "'" + &
						"t_datetime.Text   = '" + ls_datetime + "'"			
						
		
		dw_print.Modify(ls_modify)
		dw_print.object.t_brand.text = '브랜드: ' + is_brand + '/' +  idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") 
		dw_print.object.t_season.text = '시즌: ' + is_year + '/' +  idw_season.GetitemString(idw_season.GetRow(), "inter_display") 
		dw_print.object.t_yymmdd.Text = '출고일자: ' + String(is_fr_yymmdd, "@@@@/@@/@@") + " - " +  String(is_to_yymmdd, "@@@@/@@/@@")
		
end if
end event

event open;call super::open;
//select convert(char(8),dateadd(dd,-6 - datepart(dw,getdate()),getdate()),112),
//	    convert(char(8),dateadd(dd,- datepart(dw,getdate()),getdate()),112)	
//		 into :is_fr_yymmdd, :is_to_yymmdd
//		 from dual;
		 
select convert(char(8),dateadd(dd,-datepart(dw,dateadd(dd,4,getdate())),getdate()),112),
       convert(char(8),getdate(),112)	
		 into :is_fr_yymmdd, :is_to_yymmdd
		 from dual;		 
		 
		 
dw_head.setitem(1,"fr_yymmdd", is_fr_yymmdd)
dw_head.setitem(1,"to_yymmdd", is_to_yymmdd)
end event

type cb_close from w_com010_d`cb_close within w_62099_d
end type

type cb_delete from w_com010_d`cb_delete within w_62099_d
end type

type cb_insert from w_com010_d`cb_insert within w_62099_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_62099_d
end type

type cb_update from w_com010_d`cb_update within w_62099_d
end type

type cb_print from w_com010_d`cb_print within w_62099_d
integer x = 631
integer width = 686
string text = "인기도조사 미리보기(&P)"
end type

type cb_preview from w_com010_d`cb_preview within w_62099_d
end type

type gb_button from w_com010_d`gb_button within w_62099_d
end type

type cb_excel from w_com010_d`cb_excel within w_62099_d
end type

type dw_head from w_com010_d`dw_head within w_62099_d
integer y = 164
integer width = 3584
integer height = 220
string dataobject = "d_62099_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild	idw_child

this.getchild("brand",idw_brand)
idw_brand.SetTransObject(SQLCA) 
idw_brand.retrieve('001')

this.getchild("season",idw_season)
idw_season.SetTransObject(SQLCA) 
idw_season.retrieve('003', gs_brand, '%')
idw_season.insertrow(1)
idw_season.setitem(1,"inter_cd","%")
idw_season.setitem(1,"inter_nm","전체")

this.getchild("item",idw_item)
idw_item.SetTransObject(SQLCA) 
idw_item.retrieve(gs_brand)
idw_item.insertrow(1)
idw_item.setitem(1,"item","%")
idw_item.setitem(1,"item_nm","전체")


end event

event dw_head::itemchanged;call super::itemchanged;string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "yymmdd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			select convert(char(8),dateadd(dd,-6 - datepart(dw,:data),:data),112),
					 convert(char(8),dateadd(dd,- datepart(dw,:data),:data),112)	
					 into :is_fr_yymmdd, :is_to_yymmdd
					 from dual;
					 
			dw_head.setitem(1,"fr_yymmdd", is_fr_yymmdd)
			dw_head.setitem(1,"to_yymmdd", is_to_yymmdd)
			
	CASE "brand"

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

type ln_1 from w_com010_d`ln_1 within w_62099_d
integer beginy = 408
integer endy = 408
end type

type ln_2 from w_com010_d`ln_2 within w_62099_d
integer beginy = 412
integer endy = 412
end type

type dw_body from w_com010_d`dw_body within w_62099_d
integer y = 424
integer width = 3077
integer height = 1600
string dataobject = "d_62099_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_style
choose case dwo.name
	case "style"
		ls_style = this.getitemstring(row, "style")
		il_rows = dw_1.retrieve(ls_style)		
		il_rows = dw_2.retrieve(ls_style)		
end choose

end event

event dw_body::buttonclicked;call super::buttonclicked;string ls_style
ls_style = this.getitemstring(row,'style')
il_rows = dw_4.retrieve(ls_style)
dw_4.visible = true
end event

type dw_print from w_com010_d`dw_print within w_62099_d
integer x = 110
integer y = 136
string dataobject = "d_62099_r04"
end type

type dw_1 from datawindow within w_62099_d
integer x = 3086
integer y = 424
integer width = 526
integer height = 800
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_62099_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_62099_d
integer x = 3086
integer y = 1228
integer width = 526
integer height = 800
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_62099_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_3 from datawindow within w_62099_d
boolean visible = false
integer x = 96
integer y = 28
integer width = 1687
integer height = 2032
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "매장별 인기도"
string dataobject = "d_62099_d04"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_shop from commandbutton within w_62099_d
integer x = 55
integer y = 44
integer width = 571
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "매장별인기도조사"
end type

event clicked;dw_3.Retrieve(is_brand, is_year, is_season)
dw_3.Visible = true 


if dw_3.rowcount() > 0 then
	cb_print.enabled = true
//	cb_preview.enabled = true	
else	
	cb_print.enabled = false
//	cb_preview.enabled = false
end if	
end event

type dw_4 from datawindow within w_62099_d
boolean visible = false
integer x = 430
integer y = 500
integer width = 2267
integer height = 1416
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "매장별 투표현황"
string dataobject = "d_62099_d05"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

