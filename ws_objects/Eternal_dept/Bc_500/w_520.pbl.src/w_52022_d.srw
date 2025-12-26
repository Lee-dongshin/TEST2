$PBExportHeader$w_52022_d.srw
$PBExportComments$Order배분표 조회
forward
global type w_52022_d from w_com010_d
end type
end forward

global type w_52022_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_52022_d w_52022_d

type variables
string  is_brand, is_year, is_season, is_shop_div,is_shop_cd, is_fr_ymd, is_to_ymd, is_rpt_gubn
datawindowchild idw_brand, idw_season,idw_shop_div
end variables

on w_52022_d.create
call super::create
end on

on w_52022_d.destroy
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

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"from일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"to일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_rpt_gubn = dw_head.GetItemString(1, "rpt_gubn")
if IsNull(is_rpt_gubn) or Trim(is_rpt_gubn) = "" then
   MessageBox(ls_title,"조회 방식을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rpt_gubn")
   return false
end if


is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   is_shop_cd = '%'
end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_shop_div, ls_brand
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm) 
					dw_head.Setitem(al_row, "shop_div", MidA(as_data, 2, 1))
					RETURN 0
				END IF 
			END IF
			ls_shop_div = dw_head.GetitemString(1, "shop_div") 
			ls_brand    = dw_head.GetitemString(1, "brand") 
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand     = '" + ls_brand + "'" + & 
			                         "  AND shop_div  like '" +  ls_shop_div + "'" + &
											 "  AND shop_stat = '00' " 
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				dw_head.SetItem(al_row, "shop_div", lds_Source.GetItemString(1,"shop_div"))
				/* 다음컬럼으로 이동 */
				cb_Retrieve.SetFocus()
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


if is_rpt_gubn = "A" then 
	dw_body.dataobject = "d_52022_d01"
else 	
	dw_body.dataobject = "d_52022_d02"
end if	

dw_body.SetTransObject(SQLCA)


il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_shop_div,is_shop_cd,is_fr_ymd,is_to_ymd)
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

event open;call super::open;Dw_head.SetItem(1,"Shop_div",'%')
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.03.13                                                  */	
/* 수정일      : 2002.03.13                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_sale_type, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

IF is_shop_cd = '%' THEN
	ls_shop_nm = '전체'
ELSE
	ls_shop_nm = dw_head.GetItemString(1, "shop_nm")
END IF

ls_modify =	"t_pg_id.Text     = '" + is_pgm_id    + "'" + &
            "t_user_id.Text   = '" + gs_user_id   + "'" + &
            "t_datetime.Text  = '" + ls_datetime  + "'" + &
            "t_yymmdd_st.Text = '" + String(is_fr_ymd, '@@@@/@@/@@') + "'" + &
            "t_yymmdd_ed.Text = '" + String(is_to_ymd, '@@@@/@@/@@') + "'" + &
            "t_shop_cd.Text   = '" + is_shop_cd   + "'" + &
            "t_shop_nm.Text   = '" + ls_shop_nm   + "'" + &
            "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(),         "inter_display") + "'" + &
            "t_shop_div.Text  = '" + idw_shop_div.GetItemString(idw_shop_div.GetRow(),   "inter_display") + "'" + &
            "t_year.Text      = '" + is_year + "'" + &
            "t_season.Text    = '" + idw_season.GetItemString(idw_season.GetRow(),  "inter_display") + "'" 

dw_print.Modify(ls_modify)

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/


if is_rpt_gubn = "A" then 
	dw_print.dataobject = "d_52022_r01"
	dw_print.SetTransObject(SQLCA)
	This.Trigger Event ue_title()
	dw_print.retrieve(is_brand,is_year,is_season,is_shop_div,is_shop_cd,is_fr_ymd,is_to_ymd)	
else 	
	dw_print.dataobject = "d_52022_r02"
	dw_print.SetTransObject(SQLCA)	
	This.Trigger Event ue_title()
   dw_body.ShareData(dw_print)	
end if	

dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/



if is_rpt_gubn = "A" then 
	dw_print.dataobject = "d_52022_r01"
	dw_print.SetTransObject(SQLCA)
	This.Trigger Event ue_title()
	
	dw_print.retrieve(is_brand,is_year,is_season,is_shop_div,is_shop_cd,is_fr_ymd,is_to_ymd)	
else 	
	dw_print.dataobject = "d_52022_r02"
	dw_print.SetTransObject(SQLCA)	
	This.Trigger Event ue_title()
   dw_body.ShareData(dw_print)	
end if	


IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF

This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_52022_d","0")
end event

type cb_close from w_com010_d`cb_close within w_52022_d
end type

type cb_delete from w_com010_d`cb_delete within w_52022_d
end type

type cb_insert from w_com010_d`cb_insert within w_52022_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_52022_d
end type

type cb_update from w_com010_d`cb_update within w_52022_d
end type

type cb_print from w_com010_d`cb_print within w_52022_d
end type

type cb_preview from w_com010_d`cb_preview within w_52022_d
end type

type gb_button from w_com010_d`gb_button within w_52022_d
end type

type cb_excel from w_com010_d`cb_excel within w_52022_d
end type

type dw_head from w_com010_d`dw_head within w_52022_d
string dataobject = "d_52022_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA) 
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA) 
idw_season.Retrieve('003', gs_brand, '%')
idw_season.insertRow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA) 
idw_shop_div.Retrieve('910')
idw_shop_div.insertRow(1)
idw_shop_div.Setitem(1, "inter_cd", "%")
idw_shop_div.Setitem(1, "inter_nm", "전체")

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
DataWindowChild ldw_child
string ls_year, ls_brand


	
	
CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
	if LenA(data) = 0 then
			return 0
	else	
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	end if
	
	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
	IF ib_itemchanged THEN RETURN 1

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

type ln_1 from w_com010_d`ln_1 within w_52022_d
end type

type ln_2 from w_com010_d`ln_2 within w_52022_d
end type

type dw_body from w_com010_d`dw_body within w_52022_d
string dataobject = "d_52022_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_52022_d
string dataobject = "d_52022_r02"
end type

