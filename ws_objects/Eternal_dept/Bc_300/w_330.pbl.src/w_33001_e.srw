$PBExportHeader$w_33001_e.srw
$PBExportComments$생산 사고 관리
forward
global type w_33001_e from w_com020_e
end type
type dw_claim from datawindow within w_33001_e
end type
end forward

global type w_33001_e from w_com020_e
integer width = 3680
integer height = 2272
dw_claim dw_claim
end type
global w_33001_e w_33001_e

type variables
dragobject   idrg_vertical2[2]
string is_style, is_chno, is_brand, is_year, is_season
long il_prot, il_list_row

end variables

forward prototypes
public function integer wf_resizepanels ()
end prototypes

public function integer wf_resizepanels ();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.26                                                  */
/*===========================================================================*/
// DataWindow 위치 및 크기 변경
Long		ll_Width

ll_Width = idrg_Vertical[2].X + idrg_Vertical[2].Width - st_1.X - ii_BarThickness

idrg_Vertical[1].Resize (st_1.X - idrg_Vertical[1].X, idrg_Vertical[1].Height)

idrg_Vertical[2].Move (st_1.X + ii_BarThickness, idrg_Vertical[2].Y)
idrg_Vertical[2].Resize (ll_Width, idrg_Vertical[2].Height)

ll_Width = idrg_Vertical2[1].X + idrg_Vertical2[1].Width - (st_1.X + ii_BarThickness)

idrg_Vertical2[1].Move (st_1.X + ii_BarThickness, idrg_Vertical2[1].Y)
idrg_Vertical2[1].Resize (ll_Width, idrg_Vertical2[1].Height)



//idrg_Vertical2[2].Move (idrg_Vertical2[1].X + idrg_Vertical2[1].Width + ii_BarThickness, idrg_Vertical2[1].Y)

Return 1



end function

on w_33001_e.create
int iCurrent
call super::create
this.dw_claim=create dw_claim
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_claim
end on

on w_33001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_claim)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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


if as_cb_div = '9' then
	IF dw_list.AcceptText() <> 1 THEN RETURN FALSE
	is_style 		 = dw_list.GetItemString(il_list_row, "style")
	is_chno 			 = dw_list.GetItemString(il_list_row, "chno")
	il_prot 			 = dw_list.GetItemnumber(il_list_row, "prot")		
else
	IF dw_head.AcceptText() <> 1 THEN RETURN FALSE
	is_brand    = dw_head.GetItemString(1, "brand")
	is_style    = dw_head.GetItemString(1, "style")
	is_chno     = dw_head.GetItemString(1, "chno")
	is_year     = dw_head.GetItemString(1, "year")
	is_season   = dw_head.GetItemString(1, "season")
end if
	
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

return true

end event

event ue_button;/*===========================================================================*/
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
         dw_body.Enabled = false
         dw_claim.Enabled = false		
      else
         dw_head.SetFocus()
      end if

   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_list.Enabled = true
				dw_body.Enabled = false
				dw_claim.Enabled = false	
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
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
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_insert.enabled = false
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
		dw_claim.Enabled = false	
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled  = true
         cb_print.enabled   = true
         cb_preview.enabled = true
         cb_excel.enabled   = true
		else
         cb_delete.enabled  = false
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
         cb_insert.enabled = false
			dw_body.Enabled   = true	
			dw_claim.Enabled  = true
      end if
END CHOOSE

end event

event pfc_preopen;/*===========================================================================*/
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
inv_resize.of_Register(dw_list, "ScaleToBottom")
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(st_1, "ScaleToBottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(dw_claim, "ScaleToRight&Bottom")


idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_claim.SetTransObject(SQLCA)

//dw_asst.SetTransObject(SQLCA)
/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
//dw_asst.reset()
//dw_1.InsertRow(0)


datetime ld_datetime



idrg_Vertical2[1] = dw_claim


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"claim_ymd",string(ld_datetime,"yyyymmdd"))

end if


end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_style, is_chno, "New")
dw_body.reset()
dw_claim.reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
Boolean    lb_check 
DataStore  lds_Source


is_brand = dw_head.getitemstring(1,'brand')
if isnull(is_brand) then is_brand = LeftA(as_data,1)

CHOOSE CASE as_column
	CASE "style"			
		IF ai_div = 1 THEN 				
			if isnull(as_data) or as_data = "" then
				return 0					

			END IF 
		END IF	
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "제품 코드 검색" 
		gst_cd.datawindow_nm   = "d_com010" 
		gst_cd.default_where   = " where brand = '" + is_brand + "'"
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "style like '" + as_data +"%'"
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = Create DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = True
			lds_Source = Message.PowerObjectParm
			dw_head.SetRow(1)
			dw_head.SetColumn(as_column)
			dw_head.SetItem(1, "style", lds_Source.GetItemString(1,"style"))
			dw_head.SetItem(1, "chno" , lds_Source.GetItemString(1,"chno" ))
			dw_head.SetItem(1, "brand" , lds_Source.GetItemString(1,"brand" ))
			dw_head.SetItem(1, "year" , lds_Source.GetItemString(1,"year" ))
			dw_head.SetItem(1, "season" , lds_Source.GetItemString(1,"season" ))			
			/* 다음컬럼으로 이동 */
			dw_head.scrolltorow(1)
			dw_head.SetColumn("brand")
			ib_itemchanged = False 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		Destroy  lds_Source	
							
END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
string ls_last_ymd
datetime ld_datetime
long ll_mis_qty_sum

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

il_rows = dw_body.Update(TRUE, FALSE)
if il_rows = 1  then
	ll_mis_qty_sum = dw_body.getitemnumber(1,"mis_qty_all")

	if ll_mis_qty_sum = 0 then
		dw_list.setitem(il_list_row,"last_yn","N")
		dw_list.setitem(il_list_row,"last_ymd","")
	else
		dw_list.setitem(il_list_row,"last_yn","Y")
		ls_last_ymd = dw_list.getitemstring(il_list_row,"last_ymd")

		if isnull(ls_last_ymd) or ls_last_ymd = "" then
			dw_list.setitem(il_list_row,"last_ymd",string(ld_datetime,"yyyymmdd"))
		end if
	
	end if
	

	il_rows = dw_list.Update(TRUE, FALSE)
end if

if il_rows = 1 then
   dw_body.ResetUpdate()
   dw_list.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_33001_e","0")
end event

type cb_close from w_com020_e`cb_close within w_33001_e
end type

type cb_delete from w_com020_e`cb_delete within w_33001_e
end type

type cb_insert from w_com020_e`cb_insert within w_33001_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_33001_e
end type

type cb_update from w_com020_e`cb_update within w_33001_e
end type

type cb_print from w_com020_e`cb_print within w_33001_e
end type

type cb_preview from w_com020_e`cb_preview within w_33001_e
end type

type gb_button from w_com020_e`gb_button within w_33001_e
end type

type cb_excel from w_com020_e`cb_excel within w_33001_e
end type

type dw_head from w_com020_e`dw_head within w_33001_e
integer height = 184
string dataobject = "d_33001_h01"
end type

event dw_head::constructor;datawindowchild ldw_child

this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('001')

this.getchild("year",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('002')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
datawindowchild ldw_child
CHOOSE CASE dwo.name

	CASE "brand","year"      // dddw로 작성된 항목
		//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",ldw_child)
			ldw_child.settransobject(sqlca)
			ldw_child.retrieve('003', is_brand, is_year)

	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::editchanged;call super::editchanged;choose case dwo.name 
	case "style"
		if LenA(data) = 1 then	this.setitem(1,"brand",LeftA(data,1))
end choose

end event

type ln_1 from w_com020_e`ln_1 within w_33001_e
integer beginy = 356
integer endy = 356
end type

type ln_2 from w_com020_e`ln_2 within w_33001_e
integer beginy = 376
integer endy = 376
end type

type dw_list from w_com020_e`dw_list within w_33001_e
integer x = 14
integer y = 376
integer width = 951
integer height = 1660
string dataobject = "d_33001_l01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return
il_list_row = row

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

IF Trigger Event ue_keycheck('9') = FALSE THEN RETURN 1

IF IsNull(is_style) THEN return
il_rows = dw_body.retrieve(is_style, is_chno, il_prot)
if il_rows > 0 then
	il_rows = dw_claim.retrieve(is_style, is_chno)
end if
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)


end event

type dw_body from w_com020_e`dw_body within w_33001_e
integer x = 983
integer y = 376
integer width = 2615
integer height = 736
string dataobject = "d_33001_d01"
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("st_color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

end event

type st_1 from w_com020_e`st_1 within w_33001_e
integer x = 965
integer y = 376
integer height = 1660
end type

type dw_print from w_com020_e`dw_print within w_33001_e
end type

type dw_claim from datawindow within w_33001_e
integer x = 983
integer y = 1120
integer width = 2615
integer height = 916
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_33001_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;datawindowchild ldw_child

this.getchild("st_color",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("claim_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve("211")
end event

