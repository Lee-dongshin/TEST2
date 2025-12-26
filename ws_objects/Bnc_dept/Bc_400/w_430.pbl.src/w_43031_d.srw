$PBExportHeader$w_43031_d.srw
$PBExportComments$창고실사비교
forward
global type w_43031_d from w_com010_d
end type
type dw_detail from datawindow within w_43031_d
end type
end forward

global type w_43031_d from w_com010_d
string title = "실사재고비교표"
dw_detail dw_detail
end type
global w_43031_d w_43031_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_house_cd
string is_brand, is_house_cd, is_style, is_chno,is_location
string is_year, is_season, is_fr_ymd, is_to_ymd, is_base_yymmdd
string is_style_opt, is_wonga_enabled, is_opt_visible, is_lay_out, is_dep_gubn

end variables

on w_43031_d.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
end on

on w_43031_d.destroy
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



if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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


is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
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

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
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

is_location = dw_head.GetItemString(1, "location")
if IsNull(is_location) or Trim(is_location) = "" then
   MessageBox(ls_title,"박구분별을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("location")
   return false
end if

is_lay_out = dw_head.GetItemString(1, "lay_out")

is_dep_gubn = dw_head.GetItemString(1, "dep_gubn")

//is_wonga_enabled = dw_head.GetItemString(1, "wonga_enabled")
//if IsNull(is_wonga_enabled) or Trim(is_wonga_enabled) = "" then
//   MessageBox(ls_title,"원가보기구분을 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("wonga_enabled")
//   return false
//end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm, ls_shop_nm
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
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
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

if is_location = "Y" then 
	dw_body.DataObject = "d_43031_d02"
	dw_body.SetTransObject(SQLCA)
	
	dw_print.DataObject = "d_43031_r01"	
	dw_print.SetTransObject(SQLCA)
	
	
else	
	if is_lay_out = "Y" then
		dw_body.DataObject = "d_43031_d03"	
		dw_body.SetTransObject(SQLCA)
		
		dw_print.DataObject = "d_43031_r03"	
		dw_print.SetTransObject(SQLCA)
		
	else
		dw_body.DataObject = "d_43031_d01"	
		dw_body.SetTransObject(SQLCA)
		
		dw_print.DataObject = "d_43031_r01"	
		dw_print.SetTransObject(SQLCA)
	end if	
end if 

il_rows = dw_body.retrieve(is_base_yymmdd, is_fr_ymd, is_to_ymd, is_brand, is_house_cd,  is_year, is_season,  is_style_opt,is_opt_visible, is_dep_gubn)
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

event ue_title();/*===========================================================================*/
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
					"t_base_yymmdd.Text = '" + String(is_base_yymmdd, '@@@@/@@/@@') + "'" + &
					"t_fr_ymd.Text = '" + String(is_fr_ymd, '@@@@/@@/@@') + "'" + &					
					"t_to_ymd.Text = '" + String(is_to_ymd, '@@@@/@@/@@') + "'" 
				
dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43031_d","0")
end event

event pfc_preopen();call super::pfc_preopen;dw_detail.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_43031_d
end type

type cb_delete from w_com010_d`cb_delete within w_43031_d
end type

type cb_insert from w_com010_d`cb_insert within w_43031_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43031_d
end type

type cb_update from w_com010_d`cb_update within w_43031_d
end type

type cb_print from w_com010_d`cb_print within w_43031_d
end type

type cb_preview from w_com010_d`cb_preview within w_43031_d
end type

type gb_button from w_com010_d`gb_button within w_43031_d
end type

type cb_excel from w_com010_d`cb_excel within w_43031_d
end type

type dw_head from w_com010_d`dw_head within w_43031_d
integer y = 168
integer width = 3433
integer height = 272
string dataobject = "d_43031_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("house_cd", idw_house_cd )
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()
idw_house_cd.insertrow(1)
idw_house_cd.Setitem(1, "shop_cd", "000000")
idw_house_cd.Setitem(1, "shop_snm", "물류+온라인창고")



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



end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
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

type ln_1 from w_com010_d`ln_1 within w_43031_d
integer beginx = 5
integer beginy = 440
integer endx = 3625
integer endy = 440
end type

type ln_2 from w_com010_d`ln_2 within w_43031_d
integer beginx = 5
integer beginy = 444
integer endx = 3625
integer endy = 444
end type

type dw_body from w_com010_d`dw_body within w_43031_d
integer x = 9
integer y = 452
integer width = 3598
integer height = 1560
string dataobject = "d_43031_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
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

type dw_print from w_com010_d`dw_print within w_43031_d
integer x = 1394
integer y = 980
integer width = 1728
integer height = 744
string dataobject = "d_43031_r01"
end type

type dw_detail from datawindow within w_43031_d
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

