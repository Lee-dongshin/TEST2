$PBExportHeader$w_55023_d.srw
$PBExportComments$년도,시즌,브랜드 판매비교조회
forward
global type w_55023_d from w_com010_d
end type
end forward

global type w_55023_d from w_com010_d
integer width = 3675
integer height = 2256
end type
global w_55023_d w_55023_d

type variables
DataWindowChild idw_brand, idw_sojae, idw_item, idw_year, idw_season
DataWindowChild idw_bf_brand, idw_bf_year, idw_bf_season
String is_brand, is_sojae, is_item, is_year, is_season, is_bf_brand, is_bf_year, is_shop_cd
String is_bf_season, is_sale_gubn, is_frm_ymd, is_to_ymd, is_dep_fg, is_amt_gubn,is_bf_frm_ymd, is_bf_to_ymd
end variables

on w_55023_d.create
call super::create
end on

on w_55023_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_keycheck;call super::ue_keycheck;String   ls_title

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

is_bf_brand = dw_head.GetItemString(1, "bf_brand")
if IsNull(is_bf_brand) or Trim(is_bf_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("bf_brand")
   return false
end if

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"품종를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_bf_year = dw_head.GetItemString(1, "bf_year")
if IsNull(is_bf_year) or Trim(is_bf_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("bf_year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_bf_season = dw_head.GetItemString(1, "bf_season")
if IsNull(is_bf_season) or Trim(is_bf_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("bf_season")
   return false
end if

is_sale_gubn = dw_head.GetItemString(1, "sale_gubn")
if IsNull(is_sale_gubn) or Trim(is_sale_gubn) = "" then
   MessageBox(ls_title,"판매구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_gubn")
   return false
end if

is_frm_ymd = dw_head.GetItemString(1, "frm_ymd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_bf_frm_ymd = dw_head.GetItemString(1, "bf_frm_ymd")
if IsNull(is_bf_frm_ymd) or Trim(is_bf_frm_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("bf_frm_ymd")
   return false
end if

is_bf_to_ymd = dw_head.GetItemString(1, "bf_to_ymd")
if IsNull(is_bf_to_ymd) or Trim(is_bf_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("bf_to_ymd")
   return false
end if

is_dep_fg = dw_head.GetItemString(1, "dep_fg")
if IsNull(is_dep_fg) or Trim(is_dep_fg) = "" then
   MessageBox(ls_title,"부진구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dep_fg")
   return false
end if

is_amt_gubn = dw_head.GetItemString(1, "amt_gubn")
if IsNull(is_amt_gubn) or Trim(is_amt_gubn) = "" then
   MessageBox(ls_title,"금액구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("amt_gubn")
   return false
end if

if is_brand <> is_bf_brand then
	if is_year <> is_bf_year then 
		 messagebox("경고!", "브랜드간 비교시에는 같은 년도시즌만 가능합니다!")
		 dw_head.SetColumn("bf_year")
	   return false		 
	end if	 
	
	if is_season <> is_bf_season then 
		 messagebox("경고!", "브랜드간 비교시에는 같은 년도시즌만 가능합니다!")
		 dw_head.SetColumn("bf_season")
 	   return false		 
	end if	 
end if	

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
//if is_brand = is_bf_brand then
//	if is_year = is_bf_year and is_season = is_bf_season then 
//		 messagebox("경고!", "전년 비교시에는 서로 다른 년도시즌만 가능합니다!")
//		 dw_head.SetColumn("bf_year")
//	   return false		 
//	end if	 	
//end if	
	

return true
end event

event ue_retrieve;call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_brand <> is_bf_brand then
	dw_body.DataObject = "d_55023_d02"
	dw_print.DataObject = "d_55023_R02"	
	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)	
ELSE	
	dw_body.DataObject = "d_55023_d01"
	dw_print.DataObject = "d_55023_R01"	
	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
END IF	
	


//exec sp_55023_d01 'o','20031001','20031031','2003','w','%','%','%','2002','w','o','1'

//messagebox("dd", is_brand + '-' + is_frm_ymd + '-' + is_to_ymd + '-' + is_year + '-' + is_season + '-' + is_sojae + '-' + is_item + '-' + is_dep_fg + '-' + is_bf_year + '-' + is_bf_season + '-' + is_bf_brand + '-' + is_sale_gubn)

il_rows = dw_body.retrieve(is_brand, is_frm_ymd, is_to_ymd, is_bf_frm_ymd, is_bf_to_ymd, is_year, is_season, is_sojae, is_item, is_dep_fg, is_bf_year, is_bf_season, is_bf_brand, is_sale_gubn, is_amt_gubn, is_shop_cd)
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55023_d","0")
end event

event open;call super::open;datetime ld_datetime
String ls_year, ls_season, ls_brand

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_year = dw_head.getitemString(1, "year")
ls_season = dw_head.getitemString(1, "season")
ls_brand = dw_head.getitemString(1, "brand")


dw_head.SetItem(1, "frm_ymd"   ,string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "to_ymd"    ,string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "bf_frm_ymd"   ,string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "bf_to_ymd"    ,string(ld_datetime, "yyyymmdd"))
//dw_head.SetItem(1, "bf_year"   ,ls_year)
//dw_head.SetItem(1, "bf_season" ,ls_season)
//dw_head.SetItem(1, "bf_brand"  ,ls_brand)


dw_head.AcceptText() 
end event

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime, ls_dep_fg, ls_amt_gubn, ls_season

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_dep_fg = "Y" then
  ls_dep_fg = "부진"
elseif is_dep_fg = "N" then
  ls_dep_fg = "정상"	
else
  ls_dep_fg = "전체"		
end if

if is_amt_gubn = '1' then
	ls_amt_gubn = "소매가기준"
else 
	ls_amt_gubn = "실판가기준"
end if


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


ls_modify =	"t_frm_ymd.Text    = '" + is_frm_ymd + "'" + &
			   "t_to_ymd.Text     = '" + is_to_ymd + "'" + &
				"t_brand.Text      = '" + idw_brand.GetItemString(idw_brand.GetRow(),   "inter_display") + "'" + &
            "t_year.Text       = '" + is_year  + "'" + &
            "t_season.Text     = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
				"t_bf_brand.Text   = '" + idw_bf_brand.GetItemString(idw_bf_brand.GetRow(),   "inter_display") + "'" + &
            "t_bf_year.Text    = '" + is_bf_year      + "'" + &
            "t_bf_season.Text  = '" + idw_bf_season.GetItemString(idw_bf_season.GetRow(), "inter_display") + "'" + &				
            "t_dep_fg.Text     = '" + ls_dep_fg + "'"  + &
				"t_amt_gubn.text   = '" + ls_amt_gubn + "'"  + &
				"t_bf_frm_ymd.Text    = '" + is_bf_frm_ymd + "'" + &
			   "t_bf_to_ymd.Text     = '" + is_bf_to_ymd + "'" 

//messagebox("", ls_modify)

dw_print.Modify(ls_modify)


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm 
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
			gst_cd.default_where   = "WHERE Shop_Stat = '00' and shop_div in ('G','K') " + &
			                         " and brand = '" + gs_brand + "'"
			if gs_brand <> 'K' then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else 
				gst_cd.Item_where = ""
			end if
			
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF 
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
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

type cb_close from w_com010_d`cb_close within w_55023_d
end type

type cb_delete from w_com010_d`cb_delete within w_55023_d
end type

type cb_insert from w_com010_d`cb_insert within w_55023_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55023_d
end type

type cb_update from w_com010_d`cb_update within w_55023_d
end type

type cb_print from w_com010_d`cb_print within w_55023_d
end type

type cb_preview from w_com010_d`cb_preview within w_55023_d
end type

type gb_button from w_com010_d`gb_button within w_55023_d
end type

type cb_excel from w_com010_d`cb_excel within w_55023_d
end type

type dw_head from w_com010_d`dw_head within w_55023_d
integer y = 152
integer width = 3557
integer height = 364
string dataobject = "d_55023_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("bf_brand", idw_bf_brand )
idw_bf_brand.SetTransObject(SQLCA)
idw_bf_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("bf_year", idw_bf_year )
idw_bf_year.SetTransObject(SQLCA)
idw_bf_year.Retrieve('002')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.insertrow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("bf_season", idw_bf_season )
idw_bf_season.SetTransObject(SQLCA)
idw_bf_season.Retrieve('003', gs_brand, '%')
idw_bf_season.insertrow(1)
idw_bf_season.SetItem(1, "inter_cd", '%')
idw_bf_season.SetItem(1, "inter_nm", '전체')


This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.insertrow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.insertrow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')



end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand, ls_bf_year
DataWindowChild ldw_child


CHOOSE CASE dwo.name
	CASE "brand"
				
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
		This.GetChild("sojae", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('%',data)
		ldw_child.InsertRow(1)
		ldw_child.SetItem(1, "sojae", '%')
		ldw_child.SetItem(1, "sojae_nm", '전체')
		
		This.GetChild("item", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve(data)
		ldw_child.InsertRow(1)
		ldw_child.SetItem(1, "item", '%')
		ldw_child.SetItem(1, "item_nm", '전체')
		
	CASE "bf_brand"		
		ls_bf_year = this.getitemstring(row, "bf_year")	
		this.getchild("bf_season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_bf_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
	
		
	CASE "year"
	
		
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
	CASE "bf_year"
	
		
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("bf_season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")		
				  								
				
		
						
				

END CHOOSE 
end event

type ln_1 from w_com010_d`ln_1 within w_55023_d
integer beginy = 520
integer endy = 520
end type

type ln_2 from w_com010_d`ln_2 within w_55023_d
integer beginy = 524
integer endy = 524
end type

type dw_body from w_com010_d`dw_body within w_55023_d
integer y = 532
integer height = 1488
string dataobject = "d_55023_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_55023_d
string dataobject = "d_55023_r01"
end type

