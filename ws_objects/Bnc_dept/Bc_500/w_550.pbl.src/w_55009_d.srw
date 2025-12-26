$PBExportHeader$w_55009_d.srw
$PBExportComments$상제품 보유 현황
forward
global type w_55009_d from w_com010_d
end type
type st_1 from statictext within w_55009_d
end type
end forward

global type w_55009_d from w_com010_d
integer width = 3689
integer height = 2284
st_1 st_1
end type
global w_55009_d w_55009_d

type variables
String is_yymmdd_st, is_yymmdd_ed, is_brand, is_year_st, is_year_ed, is_season_st, is_season_ed, is_opt_gubn, is_ms_gubn, is_sale_gubn, is_chi_gubn
DataWindowChild idw_brand, idw_season_st, idw_season_ed, idw_sojae, idw_item
end variables

on w_55009_d.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_55009_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */
/* 작성일      : 2002.03.11                                                  */
/* 수정일      : 2002.03.11                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF TRIGGER EVENT ue_keycheck('1') = FALSE THEN RETURN

   if is_opt_gubn = "S" then

      dw_print.DataObject = "d_55009_r01"
	elseif is_opt_gubn = "I" then	

      dw_print.DataObject = "d_55009_r02"		
	end if	 
	
	dw_print.SetTransObject(SQLCA)	

il_rows = dw_body.retrieve(is_yymmdd_st, is_yymmdd_ed, is_brand, is_year_st, is_season_st, is_year_ed, is_season_ed, is_ms_gubn, is_sale_gubn, is_chi_gubn)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

THIS.TRIGGER EVENT ue_button(1, il_rows)
THIS.TRIGGER EVENT ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
IF IsNull(is_brand) OR is_brand = "" THEN
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF


//if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
//   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false	
//elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false		
//elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false			
//end if	




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




is_yymmdd_st = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
IF IsNull(is_yymmdd_st) OR is_yymmdd_st = "" THEN
   MessageBox(ls_title,"시작 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   RETURN FALSE
END IF

is_yymmdd_ed = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
IF IsNull(is_yymmdd_ed) OR is_yymmdd_ed = "" THEN
   MessageBox(ls_title,"종료 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF

IF is_yymmdd_ed < is_yymmdd_st THEN
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE
END IF

is_year_st = Trim(dw_head.GetItemString(1, "year1"))
IF IsNull(is_year_st) OR is_year_st = "" THEN
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year1")
   RETURN FALSE
END IF

is_season_st = Trim(dw_head.GetItemString(1, "season1"))
IF IsNull(is_season_st) OR is_season_st = "" THEN
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season1")
   RETURN FALSE
END IF

is_year_ed = Trim(dw_head.GetItemString(1, "year2"))
IF IsNull(is_year_ed) OR is_year_ed = "" THEN
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year2")
   RETURN FALSE
END IF

is_season_ed = Trim(dw_head.GetItemString(1, "season2"))
IF IsNull(is_season_ed) OR is_season_ed = "" THEN
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season2")
   RETURN FALSE
END IF

is_opt_gubn = dw_head.GetItemString(1, "opt_gubn")
IF IsNull(is_opt_gubn) OR is_opt_gubn = "" THEN
   MessageBox(ls_title,"조회 옵션을 확인 하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_gubn")
   RETURN FALSE
END IF

IF is_year_ed < is_year_st THEN
   MessageBox(ls_title,"두번째 년도가 첫번째 년도보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_year")
   RETURN FALSE
END IF

is_sale_gubn = dw_head.GetItemString(1, "sale_gubn")
IF IsNull(is_sale_gubn) OR is_sale_gubn = "" THEN
   MessageBox(ls_title,"판매구분을 확인 하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_gubn")
   RETURN FALSE
END IF

is_ms_gubn = dw_head.GetItemString(1, "ms_gubn")
is_chi_gubn = dw_head.GetItemString(1, "chi_gubn")

RETURN TRUE

end event

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.03.11                                                  */
/* 수정일      : 2002.03.11                                                  */
/*===========================================================================*/
dw_head.SetItem(1, "year1",   dw_head.GetItemString(1, "year"))
dw_head.SetItem(1, "year2",   dw_head.GetItemString(1, "year"))
dw_head.SetItem(1, "season1", dw_head.GetItemString(1, "season"))
dw_head.SetItem(1, "season2", dw_head.GetItemString(1, "season"))
dw_head.SetColumn( "season1")
dw_head.SetColumn( "season2")

dw_body.Object.DataWindow.HorizontalScrollSplit  = 740
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */
/* 작성일      : 2002.03.11                                                  */
/* 수정일      : 2002.03.11                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_sale_type, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime     = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text     = '"  + is_pgm_id    + "'" + &
				"t_user_id.Text   = '"  + gs_user_id   + "'" + &
				"t_datetime.Text  = '"  + ls_datetime  + "'" + &
				"t_yymmdd_st.Text = '"  + String(is_yymmdd_st, '@@@@/@@/@@') + "'" + &
				"t_yymmdd_ed.Text = '"  + String(is_yymmdd_ed, '@@@@/@@/@@') + "'" + &
				"t_brand.Text     = '"  + idw_brand.GetItemString(idw_brand.GetRow(),         "inter_display") + "'" + &
				"t_season.Text    = '(" + is_year_st + " " + idw_season_st.GetItemString(idw_season_st.GetRow(), "inter_display") + ", " + &
				                        + is_year_ed + " " + idw_season_ed.GetItemString(idw_season_ed.GetRow(), "inter_display") + ")'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55009_d","0")
end event

type cb_close from w_com010_d`cb_close within w_55009_d
end type

type cb_delete from w_com010_d`cb_delete within w_55009_d
end type

type cb_insert from w_com010_d`cb_insert within w_55009_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55009_d
end type

type cb_update from w_com010_d`cb_update within w_55009_d
end type

type cb_print from w_com010_d`cb_print within w_55009_d
end type

type cb_preview from w_com010_d`cb_preview within w_55009_d
end type

type gb_button from w_com010_d`gb_button within w_55009_d
end type

type cb_excel from w_com010_d`cb_excel within w_55009_d
end type

type dw_head from w_com010_d`dw_head within w_55009_d
integer y = 160
integer height = 224
string dataobject = "d_55009_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season1", idw_season_st)
idw_season_st.SetTransObject(SQLCA)
idw_season_st.Retrieve('003', gs_brand, '%')

This.GetChild("season2", idw_season_ed)
idw_season_ed.SetTransObject(SQLCA)
idw_season_ed.Retrieve('003', gs_brand, '%')

end event

event dw_head::itemchanged;call super::itemchanged;
String ls_year, ls_brand
DataWindowChild ldw_child



CHOOSE CASE dwo.name
	CASE "opt_gubn"      // dddw로 작성된 항목

   if data = "S" then
      dw_body.DataObject = "d_55009_d01"
		dw_body.Object.DataWindow.HorizontalScrollSplit  = 740
	elseif Data = "I" then	
      dw_body.DataObject = "d_55009_d02"
		dw_body.Object.DataWindow.HorizontalScrollSplit  = 430
	end if	 
	
	dw_body.SetTransObject(SQLCA)

CASE "brand"
		IF ib_itemchanged THEN RETURN 1
	

		ls_year = this.getitemstring(row, "year1")	
		this.getchild("season1",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
		ls_year = this.getitemstring(row, "year2")	
		this.getchild("season2",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")		
		
	  CASE  "year1"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season1",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
				  				
							  
	  CASE  "year2"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season2",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
	 
	 
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_55009_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_d`ln_2 within w_55009_d
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_d`dw_body within w_55009_d
integer x = 14
integer y = 400
integer height = 1648
string dataobject = "d_55009_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;THIS.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%')

THIS.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%')


This.of_SetSort(false)

end event

type dw_print from w_com010_d`dw_print within w_55009_d
integer x = 1600
integer y = 664
integer height = 240
string dataobject = "d_55009_r01"
end type

type st_1 from statictext within w_55009_d
integer x = 32
integer y = 64
integer width = 480
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "(금액단위 : 천원)"
boolean focusrectangle = false
end type

