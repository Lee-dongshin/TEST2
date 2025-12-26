$PBExportHeader$w_21095_e.srw
$PBExportComments$가격택정보입력
forward
global type w_21095_e from w_com030_e
end type
type dw_detail from datawindow within w_21095_e
end type
type dw_copy_ord from datawindow within w_21095_e
end type
end forward

global type w_21095_e from w_com030_e
integer width = 3685
dw_detail dw_detail
dw_copy_ord dw_copy_ord
end type
global w_21095_e w_21095_e

type variables
string  is_brand, is_year, is_season, is_sojae,  is_item , is_style, is_chno, is_style_no,is_country_cd
datawindowchild  idw_brand, idw_season, idw_sojae, idw_item
end variables

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_sojae = Trim(dw_head.GetItemString(1, "sojae"))
if IsNull(is_sojae) or is_sojae = "" then
   MessageBox(ls_title,"소재 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = Trim(dw_head.GetItemString(1, "item"))
if IsNull(is_item) or is_item = "" then
   MessageBox(ls_title,"품종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_style_no = Trim(dw_head.GetItemString(1, "style_no"))
is_country_cd = Trim(dw_head.GetItemString(1, "country_cd"))

return true

end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택) 												  */	
/* 작성일      : 2002.03.21																  */	
/* 수정일      : 2002.03.21																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert,   "FixedToRight")
inv_resize.of_Register(cb_delete,   "FixedToRight")
inv_resize.of_Register(cb_print,    "FixedToRight")
inv_resize.of_Register(cb_preview,  "FixedToRight")
inv_resize.of_Register(cb_excel,    "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close,    "FixedToRight")

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list,   "ScaleToBottom")
inv_resize.of_Register(dw_body,   "ScaleToRight")
inv_resize.of_Register(dw_detail, "ScaleToRight&Bottom")
inv_resize.of_Register(st_1,      "ScaleToBottom")
inv_resize.of_Register(ln_1,      "ScaleToRight")
inv_resize.of_Register(ln_2,      "ScaleToRight")

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.  SetTransObject(SQLCA)
dw_body.  SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
//dw_body.InsertRow(0)

///* DataWindow 사이 이동 */
//idrg_Ver[1] = dw_list
//idrg_Ver[2] = dw_body
//idrg_Ver[3] = dw_detail
//
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

is_style = LeftA(is_style_no,8)
il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_sojae, is_item,is_style,is_country_cd)

dw_body.Reset()
dw_body.InsertRow(0)
dw_detail.Reset()

IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSE
	dw_detail.InsertRow(0)
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      		  */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
	
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN			/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

	il_rows = dw_body.Update(TRUE, FALSE) 
   il_rows = dw_detail.Update(TRUE, FALSE)     




if il_rows = 1 then	
	dw_body.ResetUpdate()
	dw_detail.ResetUpdate()
   commit  USING SQLCA;
	
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

on w_21095_e.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.dw_copy_ord=create dw_copy_ord
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.dw_copy_ord
end on

on w_21095_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.dw_copy_ord)
end on

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
       cb_retrieve.Text = "조건(&Q)"
       dw_head.Enabled = false
       dw_list.Enabled = true
       dw_body.Enabled = true
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
				dw_body.Enabled = true
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
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = false
            cb_update.enabled = false
			end if
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

//      if al_rows >= 0 then
//         ib_changed = false
//         cb_update.enabled = false
//         cb_insert.enabled = true
//      end if
END CHOOSE

end event

type cb_close from w_com030_e`cb_close within w_21095_e
end type

type cb_delete from w_com030_e`cb_delete within w_21095_e
boolean visible = false
end type

type cb_insert from w_com030_e`cb_insert within w_21095_e
boolean visible = false
end type

type cb_retrieve from w_com030_e`cb_retrieve within w_21095_e
end type

type cb_update from w_com030_e`cb_update within w_21095_e
end type

type cb_print from w_com030_e`cb_print within w_21095_e
boolean visible = false
end type

type cb_preview from w_com030_e`cb_preview within w_21095_e
boolean visible = false
end type

type gb_button from w_com030_e`gb_button within w_21095_e
end type

type cb_excel from w_com030_e`cb_excel within w_21095_e
integer width = 494
string text = "가격택정보 복사!"
end type

event cb_excel::clicked;dw_copy_ord.insertrow(0)
dw_copy_ord.setitem(1,"fr_style", is_style)
dw_copy_ord.setitem(1,"fr_chno", is_chno)
dw_copy_ord.visible = true
dw_copy_ord.setcolumn("to_style")
end event

type dw_head from w_com030_e`dw_head within w_21095_e
integer x = 18
integer y = 160
integer width = 3579
integer height = 228
string dataobject = "d_21095_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',is_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')


This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(is_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')



end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name


	CASE "brand", "year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
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

			idw_sojae.SetTransObject(SQLCA)
			This.GetChild("sojae", idw_sojae)
			idw_sojae.Retrieve('%', is_brand)
			idw_sojae.insertrow(1)
			idw_sojae.Setitem(1, "sojae", "%")
			idw_sojae.Setitem(1, "sojae_nm", "전체")
			
			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_brand)
			idw_item.insertrow(1)
			idw_item.Setitem(1, "item", "%")
			idw_item.Setitem(1, "item_nm", "전체")
		
END CHOOSE

end event

type ln_1 from w_com030_e`ln_1 within w_21095_e
integer beginy = 388
integer endy = 388
end type

type ln_2 from w_com030_e`ln_2 within w_21095_e
integer beginy = 392
integer endy = 392
end type

type dw_list from w_com030_e`dw_list within w_21095_e
integer x = 14
integer y = 400
integer width = 937
integer height = 1604
string dataobject = "d_21095_d03"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long i, ll_body_rows, ll_detail_rows
string ls_flag, ls_size, ls_size_nm

IF row <= 0 THEN Return

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

is_style = This.GetItemString(row, 'style') /* DataWindow에 Key 항목을 가져온다 */
is_chno = This.GetItemString(row, 'chno') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_style) or IsNull(is_chno) THEN return

il_rows = dw_body.retrieve(is_style, is_chno)
ls_flag = dw_body.getitemstring(1,"flag")
if ls_flag = 'New' then
	dw_body.SetItemStatus(1, 0, Primary!, NewModified!)
end if

	
ll_detail_rows = 	dw_detail.retrieve(is_style, is_chno)
if  il_rows = 0  then
	dw_body.InsertRow(1)
end if

dw_body.Setitem(1, "style", is_style)
dw_body.Setitem(1, "chno", is_chno)


for i = 1 to dw_detail.rowcount()
	ls_size    = dw_detail.getitemstring(i, "size")
	ls_size_nm = dw_detail.getitemstring(i, "size_nm")
	if MidA(is_style,2,1) = 'K' and ls_size = '00' and (ls_size_nm = '' or isnull(ls_size_nm)) then 
		dw_detail.Setitem(i, "size_nm", 'FREE')
		ib_changed = true
		cb_update.enabled = true
	else
		ib_changed = false
		cb_update.enabled = false		
	end if
next



Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

event dw_list::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/


This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)


end event

type dw_body from w_com030_e`dw_body within w_21095_e
integer x = 965
integer y = 400
integer width = 2638
integer height = 844
string dataobject = "d_21095_d01"
boolean vscrollbar = false
end type

type st_1 from w_com030_e`st_1 within w_21095_e
boolean visible = false
integer x = 622
end type

type dw_print from w_com030_e`dw_print within w_21095_e
integer x = 2418
integer y = 1460
end type

type dw_detail from datawindow within w_21095_e
integer x = 965
integer y = 1252
integer width = 2638
integer height = 752
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_21095_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

type dw_copy_ord from datawindow within w_21095_e
boolean visible = false
integer x = 1047
integer y = 148
integer width = 1481
integer height = 424
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "가격택정보 복사"
string dataobject = "d_21095_d04"
boolean controlmenu = true
boolean livescroll = true
end type

event buttonclicked;string ls_fr_style, ls_fr_chno, ls_to_style, ls_to_chno, ls_color, ls_brand, to_style, to_chno

ls_brand = Trim(dw_head.GetItemString(1, "brand"))

choose case dwo.name
	case "cb_copy_ord"
			IF dw_copy_ord.AcceptText() <> 1 THEN RETURN -1
			
			ls_fr_style = dw_copy_ord.getitemstring(1,"fr_style")
			ls_fr_chno  = dw_copy_ord.getitemstring(1,"fr_chno")
			ls_to_style = dw_copy_ord.getitemstring(1,"to_style")
			ls_to_chno  = dw_copy_ord.getitemstring(1,"to_chno")
			//ls_color    = dw_body.getitemstring(1,"color")									
			
			if LenA(ls_fr_style) < 8  then 
				 messagebox("확인","스타일번호를 다시 확인 하세요...")
				return -1
			end if

			if LenA(ls_fr_chno) < 1  then 
				 messagebox("확인","차수번호를 다시 확인 하세요...")
				return -1
			end if

			if LenA(ls_to_style) < 8 or isnull(ls_to_style) then 
				 messagebox("확인","복사 될 스타일번호를 확인해주세요.")
				return -1
			end if

			if LenA(ls_to_chno) < 1 or isnull(ls_to_chno) then 
				 messagebox("확인","복사 될 차수번호를 확인해주세요.")
				return -1
			end if
			
			
			 select  style, chno
			 	into  :to_style, :to_chno
				from tb_12021_d (nolock)
			  where style = :ls_to_style
				 and chno  = :ls_to_chno;
				
					
					if isnull(to_style) or isnull(to_chno) or to_style = '' or to_chno = '' then		
						messagebox('확인','존재하지 않는 스타일번호입니다.')	
						return -1
					end if 
		
			
			
			if messagebox("확인","실행하시겠습니까...?",Exclamation!,YesNoCancel!,1 ) <> 1 then return			
			
			
				DECLARE sp_21095_copy PROCEDURE FOR sp_21095_copy  
						@fr_style      = :ls_fr_style,
						@fr_chno			= :ls_fr_chno,
						@to_style		= :ls_to_style,
						@to_chno		   = :ls_to_chno;
							
				execute sp_21095_copy;
			 
			commit  USING SQLCA;
			messagebox("확인","정상처리되었슴니다...")
			dw_copy_ord.visible = false
			dw_copy_ord.reset()
			 
end choose

end event

