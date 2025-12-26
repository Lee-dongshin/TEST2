$PBExportHeader$w_54007_d.srw
$PBExportComments$매장별 부진상품 재고현황
forward
global type w_54007_d from w_com010_d
end type
type rb_mcs from radiobutton within w_54007_d
end type
type rb_shop from radiobutton within w_54007_d
end type
type rb_style from radiobutton within w_54007_d
end type
type gb_1 from groupbox within w_54007_d
end type
end forward

global type w_54007_d from w_com010_d
rb_mcs rb_mcs
rb_shop rb_shop
rb_style rb_style
gb_1 gb_1
end type
global w_54007_d w_54007_d

type variables
STRING   is_brand, is_year, is_season, is_shop_cd, is_shop_type, is_yymmdd, is_dep_seq, is_print_flag
DataWindowChild  idw_brand, idw_season, idw_dep_seq, idw_shop_type, idw_color, idw_size,idw_disc_seq
string   is_style, is_color, is_size, is_disc_seq, is_rpt_opt, is_opt_dotcom
end variables

on w_54007_d.create
int iCurrent
call super::create
this.rb_mcs=create rb_mcs
this.rb_shop=create rb_shop
this.rb_style=create rb_style
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_mcs
this.Control[iCurrent+2]=this.rb_shop
this.Control[iCurrent+3]=this.rb_style
this.Control[iCurrent+4]=this.gb_1
end on

on w_54007_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_mcs)
destroy(this.rb_shop)
destroy(this.rb_style)
destroy(this.gb_1)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : BEAUCRE MERCHANDISING (KIM JONG HO)                         */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand
Boolean    lb_check 
DataStore  lds_Source

ls_brand = dw_head.getitemstring(1, 'brand')

CHOOSE CASE as_column		
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				If IsNull(as_data) or Trim(as_data) = "" Then
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
					
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + &
			                         " and brand = '" + ls_brand + "'"
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

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("dep_seq")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
			
	
			CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = " WHERE style in (select distinct style from tb_12020_m where dep_fg = 'Y') " + &
			                            " and brand = '" + ls_brand + "'"

            if gs_brand <> 'K' then
					IF Trim(as_data) <> "" THEN
						gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
					ELSE
						gst_cd.Item_where = ""
					END IF
				else 
					gst_cd.Item_where = ""
				end if
				
				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm

					dw_head.SetRow(al_row)
					dw_head.SetColumn(as_column)
            
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))

					/* 다음컬럼으로 이동 */
				dw_head.SetColumn("color")
				ib_itemchanged = False 
				END IF
				Destroy  lds_Source
//			END IF			
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
/* 작성자      : BEAUCRE MERCHANDISING (KIM JONG HO)                         */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_body.reset()
il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_shop_cd,is_shop_type,is_yymmdd,is_dep_seq, is_style, is_color, is_size, is_rpt_opt, is_disc_seq, is_opt_dotcom)


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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
/* event       : ue_keycheck                                                 */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
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




is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if
is_yymmdd = string(dw_head.getitemdatetime(1, "yymmdd"), "yyyymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = '%'
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
	is_style = '%'
end if

is_color = dw_head.GetItemString(1, "color")
if IsNull(is_color) or Trim(is_color) = "" then
   MessageBox(ls_title,"색상을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("color")
   return false
end if

is_size = dw_head.GetItemString(1, "size")
if IsNull(is_size) or Trim(is_size) = "" then
   MessageBox(ls_title,"사이즈를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("size")
   return false
end if


is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_dep_seq = dw_head.GetItemString(1, "dep_seq")
if IsNull(is_dep_seq) or Trim(is_dep_seq) = "" then
	is_dep_seq = "%"
 
end if

is_disc_seq = dw_head.GetItemString(1, "disc_seq")
if IsNull(is_disc_seq) or Trim(is_disc_seq) = "" then
 is_disc_seq = "%"
end if


is_rpt_opt= dw_head.GetItemString(1, "opt_RPT")
is_opt_dotcom= dw_head.GetItemString(1, "opt_dotcom")


if is_rpt_opt = "C" then 
	 is_disc_seq = "%"
	 is_dep_seq = "%"
end if 	 

return true

end event

event open;call super::open;is_brand = dw_head.GetItemString(1, "brand")
is_year  = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")

idw_dep_seq.Retrieve(is_brand, is_year, is_season)
idw_dep_seq.InsertRow(1)
idw_dep_seq.SetItem(1, "dep_seq", '%')
idw_dep_seq.SetItem(1, "dep_ymd", '전체')


idw_disc_seq.Retrieve(is_brand, is_year, is_season)
idw_disc_seq.InsertRow(1)
idw_disc_seq.SetItem(1, "dep_seq", '%')
idw_disc_seq.SetItem(1, "dep_ymd", '전체')
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify  = "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
				 "t_yymmdd.Text = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
				 "t_dep_seq.Text = '" + idw_dep_seq.GetItemString(idw_dep_seq.GetRow(), "dep_display") + "'" 
dw_print.Modify(ls_modify)



end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54007_d","0")
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

type cb_close from w_com010_d`cb_close within w_54007_d
end type

type cb_delete from w_com010_d`cb_delete within w_54007_d
end type

type cb_insert from w_com010_d`cb_insert within w_54007_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_54007_d
end type

type cb_update from w_com010_d`cb_update within w_54007_d
end type

type cb_print from w_com010_d`cb_print within w_54007_d
end type

type cb_preview from w_com010_d`cb_preview within w_54007_d
end type

type gb_button from w_com010_d`gb_button within w_54007_d
end type

type cb_excel from w_com010_d`cb_excel within w_54007_d
end type

type dw_head from w_com010_d`dw_head within w_54007_d
integer x = 686
integer y = 152
integer width = 2903
integer height = 344
string dataobject = "d_54007_h01"
boolean livescroll = false
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
/* event       : constructor(dw_head)                                        */
/*===========================================================================*/
This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTRansObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')


This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.insertRow(0)
idw_color.insertRow(1)
idw_color.Setitem(1, "color", "%")
idw_color.Setitem(1, "color_enm", "전체")

This.GetChild("size", idw_size)
idw_size.SetTransObject(SQLCA)
idw_size.insertRow(0)
idw_size.insertRow(1)
idw_size.Setitem(1, "size", "%")
idw_size.Setitem(1, "size_nm", "전체")


This.GetChild("dep_seq", idw_dep_seq)
idw_dep_seq.SetTRansObject(SQLCA)
idw_dep_seq.InsertRow(1)
idw_dep_seq.Setitem(1, "inter_cd", "%")
idw_dep_seq.Setitem(1, "inter_nm", "전체")


This.GetChild("disc_seq", idw_disc_seq)
idw_disc_seq.SetTRansObject(SQLCA)
idw_disc_seq.InsertRow(1)
idw_disc_seq.Setitem(1, "inter_cd", "%")
idw_disc_seq.Setitem(1, "inter_nm", "전체")

This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTRansObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.Setitem(1, "inter_cd", "%")
idw_shop_type.Setitem(1, "inter_nm", "전체")




end event

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : itemchanged(dw_head)                                        */
/*===========================================================================*/
String ls_year, ls_brand
DataWindowChild ldw_child
	

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(1, "dep_seq", "")
		is_brand = data
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")		
		
	CASE "year"
		This.SetItem(1, "dep_seq", "")
		is_year = data
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
		
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
				  								
		
	CASE "season"
		This.SetItem(1, "dep_seq", "")
		is_season = data
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
		
	CASE "shop_cd"      //  Popup 검색창이 존재하는 항목 
		  IF  ib_itemchanged THEN RETURN 1
		      return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "style"      //  Popup 검색창이 존재하는 항목 
		  IF  ib_itemchanged THEN RETURN 1
		  if LenA(data) <> 0 then 
		      return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
 	     end if 
			
	CASE "opt_rpt"
		if data = "A" then 		
			
			dw_head.object.disc_seq.visible = false
			dw_head.object.t_3.visible = false			
			dw_head.object.dep_seq.visible = true
			dw_head.object.opt_dotcom.visible = true			
			dw_head.object.dep_seq_t.visible = true

		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
					
		elseif data = "B" then 
			
			dw_head.object.disc_seq.visible = true
			dw_head.object.t_3.visible = true		
			dw_head.object.dep_seq.visible = false	
			dw_head.object.opt_dotcom.visible = false						
			dw_head.object.dep_seq_t.visible = false	
			
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
		
   	elseif data = "C" then 
			
			dw_head.object.disc_seq.visible = false
			dw_head.object.t_3.visible = false
			dw_head.object.dep_seq.visible = false	
			dw_head.object.opt_dotcom.visible = false									
			dw_head.object.dep_seq_t.visible = false	
			
		idw_dep_seq.Retrieve(is_brand, is_year, is_season)
		idw_dep_seq.InsertRow(1)
		idw_dep_seq.SetItem(1, "dep_seq", '%')
		idw_dep_seq.SetItem(1, "dep_ymd", '전체')
		
		idw_disc_seq.Retrieve(is_brand, is_year, is_season)
		idw_disc_seq.InsertRow(1)
		idw_disc_seq.SetItem(1, "dep_seq", '%')
		idw_disc_seq.SetItem(1, "dep_ymd", '전체')
	
			
		end if			
			
END CHOOSE 
		 
end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;String ls_style, ls_chno, ls_color, ls_size

CHOOSE CASE dwo.name
	CASE "color"
		ls_style = This.GetitemString(row, "style")
		idw_color.Retrieve(ls_style, "%")
		idw_color.insertRow(1)
		idw_color.Setitem(1, "color", "%")
		idw_color.Setitem(1, "color_enm", "전체")

	CASE "size"
		ls_style = This.GetitemString(row, "style")
		ls_color = This.GetitemString(row, "color")
		idw_size.Retrieve(ls_style, "%", ls_color)
		idw_size.insertRow(1)
		idw_size.Setitem(1, "size", "%")
		idw_size.Setitem(1, "size_nm", "전체")

		
		
END CHOOSE


end event

type ln_1 from w_com010_d`ln_1 within w_54007_d
integer beginy = 500
integer endy = 500
end type

type ln_2 from w_com010_d`ln_2 within w_54007_d
integer beginy = 504
integer endy = 504
end type

type dw_body from w_com010_d`dw_body within w_54007_d
integer y = 528
integer height = 1516
string dataobject = "d_54007_d01"
boolean hsplitscroll = true
end type

event dw_body::clicked;string ls_style
choose case dwo.name
	case "style"
		ls_style = this.getitemstring(row, "style")
		gf_style_pic(ls_style,"%")
end choose
end event

type dw_print from w_com010_d`dw_print within w_54007_d
integer x = 123
integer y = 660
string dataobject = "d_54007_r01"
end type

type rb_mcs from radiobutton within w_54007_d
integer x = 46
integer y = 200
integer width = 603
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "Style/Color/Size별 "
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_shop.TextColor = RGB(0, 0, 0)
rb_style.TextColor = RGB(0, 0, 0)

dw_body.DataObject = 'd_54007_d01'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_54007_r01'
dw_print.SetTransObject(SQLCA)

end event

type rb_shop from radiobutton within w_54007_d
integer x = 46
integer y = 348
integer width = 603
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "매장별"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.Textcolor = RGB(0, 0, 255)
rb_style.Textcolor = RGB(0, 0, 0)
rb_mcs.Textcolor = RGB(0, 0, 0)

dw_body.DataObject = 'd_54007_d02'
dw_body.SettransObject(sqlca)
dw_print.DataObject = 'd_54007_r02'
dw_print.SettransObject(sqlca)


end event

type rb_style from radiobutton within w_54007_d
integer x = 46
integer y = 272
integer width = 603
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "Style별"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.Textcolor = RGB(0, 0, 255)
rb_shop.Textcolor = RGB(0, 0, 0)
rb_mcs.Textcolor = RGB(0, 0, 0)

dw_body.DataObject = 'd_54007_d03'
dw_body.SettransObject(sqlca)
dw_print.DataObject = 'd_54007_r03'
dw_print.SettransObject(sqlca)


end event

type gb_1 from groupbox within w_54007_d
integer x = 18
integer y = 144
integer width = 658
integer height = 284
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

