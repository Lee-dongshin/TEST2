$PBExportHeader$w_43022_d.srw
$PBExportComments$출고현황조회
forward
global type w_43022_d from w_com010_d
end type
end forward

global type w_43022_d from w_com010_d
integer width = 3694
integer height = 2260
end type
global w_43022_d w_43022_d

type variables
DataWindowChild idw_brand, idw_house_cd, idw_to_season, idw_to_year, idw_item, idw_fr_year, idw_fr_season
String	is_brand, is_house_cd, is_frm_date, is_to_date, is_fr_year, is_fr_season, is_to_year, is_to_season
String	is_item, is_gubn, is_opt_chi, is_jup_gubn
end variables

on w_43022_d.create
call super::create
end on

on w_43022_d.destroy
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
   MessageBox(ls_title,"창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if

is_frm_date = dw_head.GetItemString(1, "frm_date")
if IsNull(is_frm_date) or Trim(is_frm_date) = "" then
   MessageBox(ls_title,"시작일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_date")
   return false
end if

is_to_date = dw_head.GetItemString(1, "to_date")
if IsNull(is_to_date) or Trim(is_to_date) = "" then
   MessageBox(ls_title,"종료일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_date")
   return false
end if

if is_frm_date > is_to_date then
   MessageBox(ls_title,"시작일이 마지막일보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_date")
   return false
end if	

is_fr_year = dw_head.GetItemString(1, "fr_year")
if IsNull(is_fr_year) or Trim(is_fr_year) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_year")
   return false
end if

is_fr_season = dw_head.GetItemString(1, "fr_season")
if IsNull(is_fr_season) or Trim(is_fr_season) = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_season")
   return false
end if

is_to_year = dw_head.GetItemString(1, "to_year")
if IsNull(is_to_year) or Trim(is_to_year) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_year")
   return false
end if

is_to_season = dw_head.GetItemString(1, "to_season")
if IsNull(is_to_season) or Trim(is_to_season) = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_season")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"품종을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_gubn = dw_head.GetItemString(1, "gubn")
if IsNull(is_gubn) or Trim(is_gubn) = "" then
   MessageBox(ls_title,"조회기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubn")
   return false
end if

is_opt_chi = dw_head.GetItemString(1, "opt_chi")
if IsNull(is_opt_chi) or Trim(is_opt_chi) = "" then
   MessageBox(ls_title,"중국물량 조회기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_chi")
   return false
end if

is_jup_gubn = dw_head.GetItemString(1, "jup_gubn")
if IsNull(is_jup_gubn) or Trim(is_jup_gubn) = "" then
   MessageBox(ls_title,"출고전표구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jup_gubn")
   return false
end if

return true

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43022_d","0")
end event

event ue_retrieve();call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_43022_d01 'n', '010000','20030401','20030408','2003','m','k','%', 'e'

il_rows = dw_body.retrieve(is_brand, is_house_cd, is_frm_date, is_to_date, is_fr_year, is_fr_season, is_to_year, is_to_season, "%", is_item, is_jup_gubn, is_gubn, is_opt_chi)
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

dw_head.SetItem(1, "frm_date",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "to_date", string(ld_datetime, "yyyymmdd"))

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_opt_chi, ls_year1, ls_year2

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


//ls_year1 = idw_fr_year.GetItemString(idw_fr_year.GetRow(), "inter_display") + '/' + idw_fr_season.GetItemString(idw_fr_season.GetRow(), "inter_display") 

ls_modify =		"t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_frm_date.Text = '" + is_frm_date + "'" + &
					"t_to_date.Text  = '" + is_to_date + "'" + &					
					"t_house_cd.Text = '" + idw_house_cd.GetItemString(idw_house_cd.GetRow(), "shop_display") + "'" + &
					"t_year.Text     = '" + idw_fr_year.GetItemString(idw_fr_year.GetRow(), "inter_cd1") + "/" + idw_fr_season.GetItemString(idw_fr_season.GetRow(), "inter_nm") +  "' " + &
					"t_season.Text   = '" + idw_to_year.GetItemString(idw_to_year.GetRow(), "inter_cd1") + "/" + idw_to_season.GetItemString(idw_to_season.GetRow(), "inter_nm") + "'" + &
					"t_item.Text     = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'" + &					
					"t_opt_chi.Text  = '" + ls_opt_chi + "'" 
//messagebox("ls_modify", ls_modify)
dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_43022_d
end type

type cb_delete from w_com010_d`cb_delete within w_43022_d
end type

type cb_insert from w_com010_d`cb_insert within w_43022_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43022_d
end type

type cb_update from w_com010_d`cb_update within w_43022_d
end type

type cb_print from w_com010_d`cb_print within w_43022_d
end type

type cb_preview from w_com010_d`cb_preview within w_43022_d
end type

type gb_button from w_com010_d`gb_button within w_43022_d
end type

type cb_excel from w_com010_d`cb_excel within w_43022_d
end type

type dw_head from w_com010_d`dw_head within w_43022_d
integer y = 148
integer width = 3534
integer height = 292
string dataobject = "d_43022_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("house_cd", idw_house_cd )
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('%')

This.GetChild("fr_year", idw_fr_year )
idw_fr_year.SetTransObject(SQLCA)
idw_fr_year.Retrieve('002')

This.GetChild("to_year", idw_to_year )
idw_to_year.SetTransObject(SQLCA)
idw_to_year.Retrieve('002')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_fr_year = dw_head.getitemstring(1,'fr_year')
is_to_year = dw_head.getitemstring(1,'to_year')


THIS.GetChild("fr_season", idw_fr_season)
idw_fr_season.SetTransObject(SQLCA)
idw_fr_season.retrieve('003', is_brand, is_fr_year)
//idw_fr_season.Retrieve('003')


THIS.GetChild("to_season", idw_to_season)
idw_to_season.SetTransObject(SQLCA)
idw_to_season.retrieve('003', is_brand, is_to_year)
//idw_to_season.Retrieve('003')



This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(is_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if



end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "gubn"      // dddw로 작성된 항목
        if data = "A" then
			 dw_body.dataobject = "d_43022_d01"
			 dw_print.dataobject = "d_43022_r01"			 
	 	  elseif data = "B" then
			 dw_body.dataobject = "d_43022_d02"
			 dw_print.dataobject = "d_43022_r02"			 			 
	 	  elseif data = "C" then
			 dw_body.dataobject = "d_43022_d03"
			 dw_print.dataobject = "d_43022_r03"			 			 
	 	  elseif data = "D" then
			 dw_body.dataobject = "d_43022_d04"
			 dw_print.dataobject = "d_43022_r04"	
	 	  elseif data = "E" then 
			 dw_body.dataobject = "d_43022_d05"			 
			 dw_print.dataobject = "d_43022_r05"			 			 
	 	  else 
			 dw_body.dataobject = "d_43022_d06"			 
			 dw_print.dataobject = "d_43022_r06"			 			 			 
		  end if	 
		  dw_body.SetTransObject(SQLCA)
		  dw_print.SetTransObject(SQLCA)		  
		  
		  

CASE "brand", "fr_year", "to_year"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			//라빠레트 시즌적용
			dw_head.accepttext()	
			is_brand = dw_head.getitemstring(1,'brand')
			is_fr_year = dw_head.getitemstring(1,'fr_year')
			is_to_year = dw_head.getitemstring(1,'to_year')
			
			THIS.GetChild("fr_season", idw_fr_season)
			idw_fr_season.SetTransObject(SQLCA)
			idw_fr_season.retrieve('003', is_brand, is_fr_year)
			//idw_fr_season.Retrieve('003')

			THIS.GetChild("to_season", idw_to_season)
			idw_to_season.SetTransObject(SQLCA)
			idw_to_season.retrieve('003', is_brand, is_to_year)
			//idw_to_season.Retrieve('003')
	
			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_brand)
			idw_item.insertrow(1)
			idw_item.Setitem(1, "item", "%")
			idw_item.Setitem(1, "item_nm", "전체")
		
END CHOOSE
				  
		  


end event

type ln_1 from w_com010_d`ln_1 within w_43022_d
integer beginy = 440
integer endy = 440
end type

type ln_2 from w_com010_d`ln_2 within w_43022_d
integer beginy = 444
integer endy = 444
end type

type dw_body from w_com010_d`dw_body within w_43022_d
integer y = 452
integer width = 3598
integer height = 1568
string dataobject = "d_43022_d01"
end type

type dw_print from w_com010_d`dw_print within w_43022_d
string dataobject = "d_43022_r01"
end type

