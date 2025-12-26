$PBExportHeader$w_22021_e.srw
$PBExportComments$원단수출 사용내역 등록
forward
global type w_22021_e from w_com020_e
end type
end forward

global type w_22021_e from w_com020_e
integer width = 3675
integer height = 2264
event ue_insert_def ( long al_row )
end type
global w_22021_e w_22021_e

type variables
string is_brand, is_year, is_season, is_mat_cd, is_color, is_st_color

datawindowchild idw_brand, idw_season, idw_color, idw_st_color
end variables

event ue_insert_def(long al_row);string ls_mat_cd, ls_color, ls_spec, ls_brand, ls_year, ls_season, ls_sojae

ls_mat_cd = dw_body.getitemstring(1,"mat_cd")
ls_spec   = dw_body.getitemstring(1,"spec")

ls_brand  = dw_body.getitemstring(1,"brand")
ls_year   = dw_body.getitemstring(1,"year")
ls_season = dw_body.getitemstring(1,"season")
ls_sojae  = dw_body.getitemstring(1,"sojae")

dw_body.setitem(al_row, "mat_cd", ls_mat_cd)
dw_body.setitem(al_row, "spec",   ls_spec)
dw_body.setitem(al_row, "brand",  ls_brand)
dw_body.setitem(al_row, "year",   ls_year)
dw_body.setitem(al_row, "season", ls_season)
dw_body.setitem(al_row, "sojae",  ls_sojae)

dw_body.SetItemStatus(al_row, 0, Primary!, New!)	
end event

on w_22021_e.create
call super::create
end on

on w_22021_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

is_year   = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_mat_cd = dw_head.GetItemString(1, "mat_cd")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_mat_cd)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
Boolean    lb_check 
DataStore  lds_Source


is_brand = dw_body.getitemstring(1,'brand')
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
			dw_body.SetColumn(as_column)
			dw_body.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
			dw_body.SetItem(al_row, "chno" , lds_Source.GetItemString(1,"chno" ))

			/* 다음컬럼으로 이동 */
			dw_body.SetColumn("chno")
			dw_body.SetColumn("st_color")			
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
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

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

event ue_insert();call super::ue_insert;trigger event ue_insert_def(dw_body.rowcount())
end event

type cb_close from w_com020_e`cb_close within w_22021_e
end type

type cb_delete from w_com020_e`cb_delete within w_22021_e
end type

type cb_insert from w_com020_e`cb_insert within w_22021_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_22021_e
end type

type cb_update from w_com020_e`cb_update within w_22021_e
end type

type cb_print from w_com020_e`cb_print within w_22021_e
end type

type cb_preview from w_com020_e`cb_preview within w_22021_e
end type

type gb_button from w_com020_e`gb_button within w_22021_e
end type

type cb_excel from w_com020_e`cb_excel within w_22021_e
end type

type dw_head from w_com020_e`dw_head within w_22021_e
integer height = 164
string dataobject = "d_22021_h01"
end type

event dw_head::constructor;call super::constructor;
this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')
idw_brand.insertrow(1)


this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.setitem(1,"inter_cd","%")
idw_season.setitem(1,"inter_nm","전체")


end event

type ln_1 from w_com020_e`ln_1 within w_22021_e
integer beginy = 376
integer endy = 376
end type

type ln_2 from w_com020_e`ln_2 within w_22021_e
integer beginy = 380
integer endy = 380
end type

type dw_list from w_com020_e`dw_list within w_22021_e
integer x = 9
integer y = 404
integer width = 1650
integer height = 1620
string dataobject = "d_22021_l01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
datetime ldt_datetime

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

is_mat_cd = This.GetItemString(row, 'mat_cd') /* DataWindow에 Key 항목을 가져온다 */
is_color  = This.GetItemString(row, 'color') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_mat_cd) THEN return
idw_color.reset()
idw_st_color.reset()

idw_color.retrieve(is_mat_cd)
idw_st_color.insertrow(0)

il_rows = dw_body.retrieve(is_mat_cd)

for i = 0 to il_rows
	ldt_datetime = dw_body.getitemdatetime(i,"reg_dt")
	if isnull(ldt_datetime) then	
		dw_body.SetItemStatus(i, 0, Primary!, New!)		
	end if
next 
	
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_22021_e
event ue_set_st_color ( long al_row )
integer x = 1682
integer y = 404
integer width = 1911
integer height = 1620
string dataobject = "d_22021_d01"
end type

event dw_body::ue_set_st_color(long al_row);idw_st_color.Retrieve(This.Object.style[al_row],This.Object.chno[al_row] )
end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

CHOOSE CASE ls_column_nm
	CASE "st_color"
		post event ue_set_st_color(row)
//		idw_color.Retrieve(This.Object.style[row],This.Object.chno[row] )
END CHOOSE 
end event

event dw_body::constructor;call super::constructor;
This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.insertrow(0)

This.GetChild("st_color", idw_st_color)
idw_st_color.SetTransObject(SQLCA)
idw_st_color.insertrow(0)




end event

event dw_body::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_null
setnull(ls_null)

CHOOSE CASE dwo.name

	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(row,"chno",ls_null)
		this.setitem(row,"st_color",ls_null)
		this.setitem(row,"st_color_nm",ls_null)		
		
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	case "color"
		this.setitem(row, "color_nm", idw_color.getitemstring(idw_color.getrow(),"color_enm") )

	case "st_color"
		this.setitem(row, "st_color_nm", idw_st_color.getitemstring(idw_st_color.getrow(),"color_enm") )
END CHOOSE

end event

type st_1 from w_com020_e`st_1 within w_22021_e
integer x = 1669
integer y = 404
integer height = 1620
end type

type dw_print from w_com020_e`dw_print within w_22021_e
end type

