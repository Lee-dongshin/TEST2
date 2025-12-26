$PBExportHeader$w_92003_d.srw
$PBExportComments$매장별 재고현황(결산용)
forward
global type w_92003_d from w_com010_d
end type
type cbx_1 from checkbox within w_92003_d
end type
end forward

global type w_92003_d from w_com010_d
cbx_1 cbx_1
end type
global w_92003_d w_92003_d

type variables
string is_brand, is_year, is_season, is_fr_yymm, is_to_yymm, is_shop_cd, is_shop_div
datawindowchild idw_brand, idw_season, idw_shop_div
end variables

on w_92003_d.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
end on

on w_92003_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
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
is_year      = dw_head.GetItemString(1, "year")
is_season    = dw_head.GetItemString(1, "season")
is_shop_cd    = dw_head.GetItemString(1, "shop_cd")
is_shop_div    = dw_head.GetItemString(1, "shop_div")
is_fr_yymm = dw_head.GetItemString(1, "fr_yymm")
is_to_yymm = dw_head.GetItemString(1, "to_yymm")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
if cbx_1.checked then 
	dw_body.dataobject  = 'd_92003_d02'
	dw_print.dataobject = 'd_92003_r02'
else
	dw_body.dataobject  = 'd_92003_d01'
	dw_print.dataobject = 'd_92003_r01'	
end if
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_shop_cd, is_shop_div, is_fr_yymm, is_to_yymm)
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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_brand.Text = '" + is_brand + "'" + &
             "t_fr_yymm.Text = '" + is_fr_yymm +" ~ " + is_to_yymm + "'"
dw_print.Modify(ls_modify)


end event

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymm",LeftA(string(ld_datetime,"yyyymmdd"),4) + "01")
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymm",LeftA(string(ld_datetime,"yyyymmdd"),6))
end if
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_flag, ls_age_grp, ls_jumin 
String     ls_style,   ls_chno, ls_data , ls_sojae, ls_shop_type
string     ls_bujin_chk, ls_dep_ymd, ls_dep_seq
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
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

type cb_close from w_com010_d`cb_close within w_92003_d
end type

type cb_delete from w_com010_d`cb_delete within w_92003_d
end type

type cb_insert from w_com010_d`cb_insert within w_92003_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_92003_d
end type

type cb_update from w_com010_d`cb_update within w_92003_d
end type

type cb_print from w_com010_d`cb_print within w_92003_d
end type

type cb_preview from w_com010_d`cb_preview within w_92003_d
end type

type gb_button from w_com010_d`gb_button within w_92003_d
end type

type cb_excel from w_com010_d`cb_excel within w_92003_d
end type

type dw_head from w_com010_d`dw_head within w_92003_d
integer y = 164
integer height = 212
string dataobject = "d_92003_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;
string ls_year, ls_brand
DataWindowChild ldw_child
CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "brand"
	
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

type ln_1 from w_com010_d`ln_1 within w_92003_d
integer beginy = 388
integer endy = 388
end type

type ln_2 from w_com010_d`ln_2 within w_92003_d
integer beginy = 392
integer endy = 392
end type

type dw_body from w_com010_d`dw_body within w_92003_d
integer y = 408
integer height = 1628
string dataobject = "d_92003_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_92003_d
string dataobject = "d_92003_r01"
end type

type cbx_1 from checkbox within w_92003_d
integer x = 3035
integer y = 196
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 81324524
string text = "생산형태별"
borderstyle borderstyle = stylelowered!
end type

