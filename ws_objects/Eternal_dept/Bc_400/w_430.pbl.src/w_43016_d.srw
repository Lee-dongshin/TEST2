$PBExportHeader$w_43016_d.srw
$PBExportComments$실사재고비교조회
forward
global type w_43016_d from w_com010_d
end type
type dw_detail from datawindow within w_43016_d
end type
end forward

global type w_43016_d from w_com010_d
integer width = 3685
integer height = 2248
string title = "실사재고비교표"
dw_detail dw_detail
end type
global w_43016_d w_43016_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_shop_type
string is_brand, is_shop_cd, is_shop_type, is_style, is_chno
string is_year, is_season, is_silsa_yymmdd, is_base_yymmdd
string is_style_opt, is_wonga_enabled, is_opt_visible

end variables

on w_43016_d.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
end on

on w_43016_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      :                                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
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


is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
is_year = "%"
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
is_season = "%"
end if

is_silsa_yymmdd = dw_head.GetItemString(1, "silsa_yymmdd")
if IsNull(is_silsa_yymmdd) or Trim(is_silsa_yymmdd) = "" then
   MessageBox(ls_title,"실사일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("silsa_yymmdd")
   return false
end if

is_base_yymmdd = dw_head.GetItemString(1, "base_yymmdd")
if IsNull(is_base_yymmdd) or Trim(is_base_yymmdd) = "" then
   MessageBox(ls_title,"재고 기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("base_yymmdd")
   return false
end if

is_style_opt = dw_head.GetItemString(1, "style_opt")
if IsNull(is_style_opt) or Trim(is_style_opt) = "" then
   MessageBox(ls_title,"조회 기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_opt")
   return false
end if

is_opt_visible = dw_head.GetItemString(1, "opt_visible")
if IsNull(is_opt_visible) or Trim(is_opt_visible) = "" then
   MessageBox(ls_title,"보기기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_visible")
   return false
end if

is_wonga_enabled = dw_head.GetItemString(1, "wonga_enabled")
if IsNull(is_wonga_enabled) or Trim(is_wonga_enabled) = "" then
   MessageBox(ls_title,"원가보기구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("wonga_enabled")
   return false
end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm, ls_shop_nm, ls_brand
DataStore  lds_Source
Boolean    lb_check 

CHOOSE CASE as_column
		CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
			
			ls_brand = dw_head.getitemstring(1,"brand")
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "' and shop_stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' or shop_nm like  '%" + as_data + "%'"
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
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("cust_type")
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

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_wonga_enabled = "Y" then
	dw_body.DataObject = "d_43016_d01"
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = "d_43016_r01"
	dw_print.SetTransObject(SQLCA)	
elseif is_wonga_enabled = "S" then
	dw_body.DataObject = "d_43016_d03"
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = "d_43016_r03"
	dw_print.SetTransObject(SQLCA)	
	
else	
	dw_body.DataObject = "d_43016_d02"
	dw_body.SetTransObject(SQLCA)
	dw_print.DataObject = "d_43016_r02"
	dw_print.SetTransObject(SQLCA)		
end if


//exec sp_43016_d01 '20011215' ,'20011215', 'n', 'ng0006', '1', '%' ,'%', 's'

il_rows = dw_body.retrieve(is_base_yymmdd, is_silsa_yymmdd, is_brand, is_shop_cd, is_shop_type, is_year, is_season,  is_style_opt,is_opt_visible)
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

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "shop_type", '1')
dw_head.SetItem(1, "base_yymmdd",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "silsa_yymmdd",string(ld_datetime, "yyyymmdd"))

end event

event ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_yearseason
					  
IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	   "t_pg_id.Text = '" + is_pgm_id + "'" + &
               "t_user_id.Text = '" + gs_user_id + "'" + &
               "t_datetime.Text = '" + ls_datetime + "'" + &
               "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_year.Text = '" +  idw_year.GetItemString(idw_year.GetRow(), "inter_nm") + "'" + &					
					"t_season.Text = '" +  idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &										
					"t_silsa_yymmdd.Text = '" + String(is_silsa_yymmdd, '@@@@/@@/@@') + "'" + &										
					"t_yymmdd.Text = '" + String(is_base_yymmdd, '@@@@/@@/@@') + "'" + &															
					"t_shop_cd.Text = '" + is_shop_cd + "'"  + &
					"t_shop_type.Text = '" + idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "'" 					

dw_print.Modify(ls_modify)

end event

event ue_print;call super::ue_print;if is_wonga_enabled = "Y" then
	dw_print.DataObject = "d_43016_r01"
	dw_print.SetTransObject(SQLCA)
else	
	dw_print.DataObject = "d_43016_r02"
	dw_print.SetTransObject(SQLCA)
end if
end event

event ue_preview;call super::ue_preview;if is_wonga_enabled = "Y" then
	dw_print.DataObject = "d_43016_r01"
	dw_print.SetTransObject(SQLCA)
else	
	dw_print.DataObject = "d_43016_r02"
	dw_print.SetTransObject(SQLCA)
end if
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43016_d","0")
end event

event pfc_preopen();call super::pfc_preopen;dw_detail.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_43016_d
end type

type cb_delete from w_com010_d`cb_delete within w_43016_d
end type

type cb_insert from w_com010_d`cb_insert within w_43016_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43016_d
end type

type cb_update from w_com010_d`cb_update within w_43016_d
end type

type cb_print from w_com010_d`cb_print within w_43016_d
end type

type cb_preview from w_com010_d`cb_preview within w_43016_d
end type

type gb_button from w_com010_d`gb_button within w_43016_d
end type

type cb_excel from w_com010_d`cb_excel within w_43016_d
end type

type dw_head from w_com010_d`dw_head within w_43016_d
integer x = 18
integer y = 176
integer width = 3744
integer height = 424
string dataobject = "d_43016_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')


// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name

   CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "brand", "year"		
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
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_43016_d
integer beginx = 5
integer beginy = 624
integer endx = 3625
integer endy = 624
end type

type ln_2 from w_com010_d`ln_2 within w_43016_d
integer beginx = 5
integer beginy = 628
integer endx = 3625
integer endy = 628
end type

type dw_body from w_com010_d`dw_body within w_43016_d
integer y = 644
integer width = 3598
integer height = 1372
string dataobject = "d_43016_d01"
boolean hscrollbar = true
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_style
   
	
dw_detail.reset()
ls_style =  dw_body.GetitemString(row,"style")	
is_style = MidA(ls_style,1,8)

if LenA(is_style) > 9 then
	is_chno  =  MidA(is_style,10,1)
end if

IF is_style = "" OR isnull(is_style) THEN		
	return
END IF

IF is_chno = "" OR isnull(is_chno) THEN		
		is_chno = '%'
	END IF
	
IF dw_detail.RowCount() < 1 THEN 
	il_rows = dw_detail.retrieve(is_style, is_chno)
	
END IF 

dw_detail.visible = True

end event

type dw_print from w_com010_d`dw_print within w_43016_d
integer x = 1394
integer y = 980
integer width = 1728
integer height = 744
string dataobject = "d_43016_r01"
end type

type dw_detail from datawindow within w_43016_d
boolean visible = false
integer x = 1079
integer y = 112
integer width = 1861
integer height = 1692
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "스타일정보"
string dataobject = "d_style_pic"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

