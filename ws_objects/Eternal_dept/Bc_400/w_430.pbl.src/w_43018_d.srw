$PBExportHeader$w_43018_d.srw
$PBExportComments$일자별창고입출재고
forward
global type w_43018_d from w_com010_d
end type
end forward

global type w_43018_d from w_com010_d
integer width = 3675
integer height = 2240
string title = "일자별창고입출재고"
end type
global w_43018_d w_43018_d

type variables
DataWindowChild idw_brand,  idw_year,idw_season, idw_house_cd, idw_color, idw_size
string is_brand, is_frm_yymmdd, is_to_yymmdd, is_house_cd, is_shop_type, is_year, is_season
string is_style, is_chno, is_color, is_size, is_opt_chi
end variables

on w_43018_d.create
call super::create
end on

on w_43018_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

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
				
	CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				// 스타일 선별작업
				IF  gl_user_level = 0 then 
					gst_cd.default_where   = "WHERE   style like '" + gs_brand + "%'"	
				else 	
					gst_cd.default_where   = " WHERE  brand <> 'T' and tag_price <> 0 "
				end if
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
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
            				
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
					
					if LenA(lds_Source.GetItemString(1,"style")) <> 8 then
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("style")
					else
					dw_head.SetColumn("chno")
					end if
					ib_itemchanged = False
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_frm_yymmdd = dw_head.GetItemString(1, "frm_yymmdd")
if IsNull(is_frm_yymmdd) or Trim(is_frm_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_yymmdd")
   return false
end if

is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if

is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"매장코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if


is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false

end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" or LenA(Trim(is_style)) <> 8 then
	is_style = "%"
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
   is_chno = "%"
end if



is_color = dw_head.GetItemString(1, "color")
if IsNull(is_color) or Trim(is_color) = "" then
   MessageBox(ls_title,"제품색상을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("color")
   return false
end if

is_size = dw_head.GetItemString(1, "size")
if IsNull(is_size) or Trim(is_size) = "" then
   MessageBox(ls_title,"제품사이즈를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("size")
   return false
end if

is_opt_chi = dw_head.GetItemString(1, "opt_chi")
if IsNull(is_opt_chi) or Trim(is_opt_chi) = "" then
   MessageBox(ls_title,"재고구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_chi")
   return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve( is_brand, is_frm_yymmdd, is_to_yymmdd, is_house_cd, is_year, is_season , is_style, is_chno, is_color, is_size, is_opt_chi)
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

dw_head.SetItem(1, "frm_yymmdd",string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "to_yymmdd",string(ld_datetime,"yyyymmdd"))

end event

event ue_title();datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm, ls_between, ls_opt_chi


ls_between = string(is_frm_yymmdd,"@@@@/@@/@@") + '-' + string(is_to_yymmdd, "@@@@/@@/@@")
IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_opt_chi = "A" then
	ls_opt_chi = "중국물량포함" 
elseif is_opt_chi = "B" then
	ls_opt_chi = "중국물량제외"
else
	ls_opt_chi = "중국물량"
end if	

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =		"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "' " + &
					"t_year.Text = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "' " + &					
					"t_between.Text = '" + ls_between + "' "   +&										
					"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "' " +&
					"t_shop_cd.Text = '" + idw_house_cd.GetItemString(idw_house_cd.GetRow(), "shop_display") + "' " + &
					"t_opt_chi.Text = '" + ls_opt_chi + "' "   

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43018_d","0")
end event

type cb_close from w_com010_d`cb_close within w_43018_d
end type

type cb_delete from w_com010_d`cb_delete within w_43018_d
end type

type cb_insert from w_com010_d`cb_insert within w_43018_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43018_d
end type

type cb_update from w_com010_d`cb_update within w_43018_d
end type

type cb_print from w_com010_d`cb_print within w_43018_d
end type

type cb_preview from w_com010_d`cb_preview within w_43018_d
end type

type gb_button from w_com010_d`gb_button within w_43018_d
end type

type cb_excel from w_com010_d`cb_excel within w_43018_d
end type

type dw_head from w_com010_d`dw_head within w_43018_d
integer x = 14
integer y = 152
integer width = 3557
integer height = 300
string dataobject = "d_43018_h01"
end type

event dw_head::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
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

This.GetChild("house_cd", idw_house_cd )
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('%')

This.GetChild("color", idw_color )
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve('%')
idw_color.InsertRow(1)
idw_color.SetItem(1, "color", '%')
idw_color.SetItem(1, "color_enm", '전체')

This.GetChild("size", idw_size )
idw_size.SetTransObject(SQLCA)
idw_size.Retrieve('%')
idw_size.InsertRow(1)
idw_size.SetItem(1, "size", '%')
idw_size.SetItem(1, "size_nm", '전체')

 
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
		
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if LenA(data) <> 0 then
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
   	end if

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

type ln_1 from w_com010_d`ln_1 within w_43018_d
integer beginx = 5
integer beginy = 452
integer endx = 3625
integer endy = 452
end type

type ln_2 from w_com010_d`ln_2 within w_43018_d
integer beginy = 456
integer endy = 456
end type

type dw_body from w_com010_d`dw_body within w_43018_d
integer y = 464
integer height = 1540
string dataobject = "d_43018_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_43018_d
integer x = 2450
integer y = 1372
string dataobject = "d_43018_r01"
end type

