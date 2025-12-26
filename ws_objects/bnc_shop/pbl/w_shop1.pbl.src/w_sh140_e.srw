$PBExportHeader$w_sh140_e.srw
$PBExportComments$RT 마켓
forward
global type w_sh140_e from w_com020_e
end type
type dw_1 from datawindow within w_sh140_e
end type
type dw_2 from datawindow within w_sh140_e
end type
end forward

global type w_sh140_e from w_com020_e
integer width = 2981
integer height = 2080
dw_1 dw_1
dw_2 dw_2
end type
global w_sh140_e w_sh140_e

type variables
string is_brand, is_year, is_season, is_item, is_deal_yn
string is_style, is_style1, is_style2, is_style3, is_style4, is_style5, is_style6 
string is_shop_cd, is_own_shop
int  ii_demand_no, ii_supply_no

datawindowchild idw_brand, idw_season, idw_item
end variables

on w_sh140_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
end on

on w_sh140_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

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

return true	
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
int li_rows_list, li_rows_body
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

li_rows_list = dw_list.retrieve(is_brand, is_year, is_season, is_item, '%', gs_shop_cd)
li_rows_body = dw_body.retrieve(is_brand, is_year, is_season, is_item, '%', gs_shop_cd)
dw_1.Reset()
dw_2.Reset()


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
			dw_1.reset()
			dw_2.reset()
			dw_1.visible = false
			dw_2.visible = false
      else
         dw_head.SetFocus()
      end if

   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_list.Enabled = true
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			dw_2.visible = false
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_insert.enabled = false
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
			dw_1.reset()
			dw_2.reset()
			dw_1.visible = false
			dw_2.visible = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
			dw_2.reset()
			dw_1.visible = true
			dw_2.visible = false

		else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
         cb_insert.enabled = true
      end if
END CHOOSE

end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
string ls_demand_no, ls_supply_no, ls_rt_shop_cd
int     li_deal_qty

ll_row_count = dw_2.RowCount()
IF dw_2.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   is_deal_yn = dw_2.GetItemString(i, "deal_yn")
	
   IF is_deal_yn = 'Y' THEN				/* New Record */
			if dw_2.dataobject = 'd_sh140_d05' then
		   	ii_demand_no = dw_2.GetItemNumber(i, "demand_no")
				li_deal_qty  = dw_2.GetItemNumber(i, "supply_qty")
			else
				ii_supply_no = dw_2.GetItemNumber(i, "supply_no")
				li_deal_qty  = dw_2.GetItemNumber(i, "demand_qty")
			end if
						
				
         DECLARE sp_market_nego PROCEDURE FOR sp_market_nego  
                 @demand_no   = :ii_demand_no, 
                 @supply_no   = :ii_supply_no, 
                 @deal_qty    = :li_deal_qty, 
                 @rt_shop_cd  = :gs_shop_cd; 
         EXECUTE sp_market_nego ;
			IF SQLCA.SQLCODE < 0 THEN 
				il_rows = - 1
				EXIT
			END IF

   END IF
NEXT

dw_2.ResetUpdate()
commit  USING SQLCA;
il_rows = dw_1.retrieve(is_style, '', gs_shop_cd)

//il_rows = dw_body.Update(TRUE, FALSE)
//
//if il_rows = 1 then
//   dw_body.ResetUpdate()
//   commit  USING SQLCA;
//else
//   rollback  USING SQLCA;
//end if

This.Trigger Event ue_button(3, 1)
This.Trigger Event ue_msg(3, 1)

dw_list.retrieve(is_brand, is_year, is_season, is_item, '%', gs_shop_cd)
dw_body.retrieve(is_brand, is_year, is_season, is_item, '%', gs_shop_cd)

return il_rows

end event

type cb_close from w_com020_e`cb_close within w_sh140_e
end type

type cb_delete from w_com020_e`cb_delete within w_sh140_e
end type

type cb_insert from w_com020_e`cb_insert within w_sh140_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_sh140_e
end type

type cb_update from w_com020_e`cb_update within w_sh140_e
end type

type cb_print from w_com020_e`cb_print within w_sh140_e
end type

type cb_preview from w_com020_e`cb_preview within w_sh140_e
end type

type gb_button from w_com020_e`gb_button within w_sh140_e
end type

type dw_head from w_com020_e`dw_head within w_sh140_e
integer height = 148
string dataobject = "d_sh140_h01"
end type

event dw_head::constructor;call super::constructor; 

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertRow(1)
idw_brand.Setitem(1, "inter_cd", "%")



This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.insertRow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")


This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('')
idw_item.insertRow(1)
idw_item.Setitem(1, "item_cd", "%")
idw_item.Setitem(1, "item_NM", "전체")
end event

type ln_1 from w_com020_e`ln_1 within w_sh140_e
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com020_e`ln_2 within w_sh140_e
integer beginy = 328
integer endy = 328
end type

type dw_list from w_com020_e`dw_list within w_sh140_e
integer y = 344
integer width = 1408
integer height = 1488
string dataobject = "d_sh140_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

//IF ib_changed THEN 
//  	CHOOSE CASE gf_update_yn(Parent.title)
//		CASE 1
//			IF Parent.Trigger Event ue_update() < 1 THEN
//				RETURN
//			END IF		
//		CASE 3
//			RETURN
//	END CHOOSE
//END IF
//	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

dw_1.dataobject = "d_sh140_d03"
dw_1.SetTransObject(SQLCA)

is_style = This.GetItemString(row, 'style') /* DataWindow에 Key 항목을 가져온다 */
is_shop_cd = This.GetItemString(row, 'shop_cd') /* DataWindow에 Key 항목을 가져온다 */


IF IsNull(is_style) THEN return
il_rows = dw_1.retrieve(is_style, '%', gs_shop_cd)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_sh140_e
integer x = 1431
integer y = 344
integer width = 1463
integer height = 1488
string dataobject = "d_sh140_d02"
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

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

event dw_body::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

//IF ib_changed THEN 
//  	CHOOSE CASE gf_update_yn(Parent.title)
//		CASE 1
//			IF Parent.Trigger Event ue_update() < 1 THEN
//				RETURN
//			END IF		
//		CASE 3
//			RETURN
//	END CHOOSE
//END IF
//	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

dw_1.dataobject = "d_sh140_d04"
dw_1.SetTransObject(SQLCA)


is_style = This.GetItemString(row, 'style') /* DataWindow에 Key 항목을 가져온다 */
is_shop_cd = This.GetItemString(row, 'shop_cd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_style) THEN return
il_rows = dw_1.retrieve(is_style, '%', gs_shop_cd)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type st_1 from w_com020_e`st_1 within w_sh140_e
integer x = 1413
integer y = 344
integer height = 1488
end type

type dw_print from w_com020_e`dw_print within w_sh140_e
end type

type dw_1 from datawindow within w_sh140_e
boolean visible = false
integer x = 585
integer y = 340
integer width = 1385
integer height = 1484
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sh140_d03"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return


This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)
if dw_1.dataobject = "d_sh140_d03" then
	dw_2.dataobject = "d_sh140_d06"
	dw_2.SetTransObject(SQLCA)
else
	dw_2.dataobject = "d_sh140_d05"
	dw_2.SetTransObject(SQLCA)	
end if

ii_demand_no = this.getitemnumber(row,"demand_no")
ii_supply_no = this.getitemnumber(row,"supply_no")

is_style1 = This.GetItemString(row, 'style') /* DataWindow에 Key 항목을 가져온다 */
is_shop_cd = This.GetItemString(row, 'shop_cd') /* DataWindow에 Key 항목을 가져온다 */


IF IsNull(is_style1) THEN return
il_rows = dw_2.retrieve('%', is_shop_cd, gs_shop_cd)
if il_rows > 0 then
	dw_2.visible = true
else
	dw_2.visible = false
end if

//Parent.Trigger Event ue_button(7, il_rows)
//Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_2 from datawindow within w_sh140_e
boolean visible = false
integer x = 823
integer y = 484
integer width = 1563
integer height = 1188
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "거래가능 제품"
string dataobject = "d_sh140_d05"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
end if


end event

event buttonclicked;if dwo.name = "cb_save" then
	parent.trigger event ue_update()
end if

end event

