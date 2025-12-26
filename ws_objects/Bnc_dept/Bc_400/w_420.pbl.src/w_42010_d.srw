$PBExportHeader$w_42010_d.srw
$PBExportComments$출고/반품명세서
forward
global type w_42010_d from w_com010_d
end type
type dw_1 from u_dw within w_42010_d
end type
type cb_excel1 from cb_excel within w_42010_d
end type
type cb_print1 from commandbutton within w_42010_d
end type
type cbx_a4 from checkbox within w_42010_d
end type
type cbx_laser from checkbox within w_42010_d
end type
type cb_1 from commandbutton within w_42010_d
end type
type cbx_a42 from checkbox within w_42010_d
end type
end forward

global type w_42010_d from w_com010_d
integer width = 3662
integer height = 2248
event ue_print1 ( )
dw_1 dw_1
cb_excel1 cb_excel1
cb_print1 cb_print1
cbx_a4 cbx_a4
cbx_laser cbx_laser
cb_1 cb_1
cbx_a42 cbx_a42
end type
global w_42010_d w_42010_d

type variables
DataWindowChild idw_house_cd, idw_shop_type, idw_out_gubn,idw_brand, idw_season, idw_item
DataWindowChild idw_jup_gubn, idw_sale_type, IDW_SHOP_DIV, idw_color, idw_size, idw_sojae
string  is_frm_date, is_to_date, is_brand, is_house_cd,  is_out_gubn , is_jup_gubn
string  is_shop_cd, is_shop_type, is_sale_type, is_style, is_chno, is_year, is_season, IS_SHOP_DIV
string  is_color, is_size	, is_item, is_sojae
end variables

event ue_print1();
Long   i,j
String ls_shop_type, ls_out_no, ls_jup_name, ls_modify, ls_Error
String ls_shop_cd, ls_yymmdd, ls_print, ls_inout_gubn, ls_out_gubn


if  cbx_a42.checked then 		
	dw_print.DataObject = "d_com420_a4"
	dw_print.SetTransObject(SQLCA)
else	
	dw_print.DataObject = "d_com420_new"
	dw_print.SetTransObject(SQLCA)	
end if

if cbx_a4.checked then 		
		ls_jup_name = "(매 장 용)"			
		FOR i = 1 TO dw_1.RowCount() 
			ls_print = dw_1.getitemstring(i, "print_out")
			IF ls_print = "Y"  THEN 
				ls_yymmdd     = dw_1.GetitemString(i, "yymmdd")			 
				ls_out_no     = dw_1.GetitemString(i, "out_no")
				ls_shop_cd    = dw_1.GetitemString(i, "shop_cd") 
				ls_shop_type  = dw_1.GetitemString(i, "shop_type")
				ls_inout_gubn = dw_1.GetitemString(i, "inout_gubn")
				If ls_inout_gubn = "+" THEN 
					ls_out_gubn = "1"
				else
					ls_out_gubn = "2"
				end if	
				
				il_rows = dw_print.Retrieve(is_brand, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, ls_out_gubn)
				
//				ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"		
//				ls_Error = dw_print.Modify(ls_modify)
//					IF (ls_Error <> "") THEN 
//						MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
//					END IF		
					
				IF dw_print.RowCount() > 0 Then
					il_rows = dw_print.Print()
				END IF
			END IF 	
		NEXT 

else			

  FOR i = 1 TO dw_1.RowCount() 
				ls_print = dw_1.getitemstring(i, "print_out")
	IF ls_print = "Y"  THEN 
		ls_yymmdd     = dw_1.GetitemString(i, "yymmdd")			 
		ls_out_no     = dw_1.GetitemString(i, "out_no")
		ls_shop_cd    = dw_1.GetitemString(i, "shop_cd") 
		ls_shop_type  = dw_1.GetitemString(i, "shop_type")
		ls_inout_gubn = dw_1.GetitemString(i, "inout_gubn")
		If ls_inout_gubn = "+" THEN 
			ls_out_gubn = "1"
		else
			ls_out_gubn = "2"
		end if	
					
			for j = 1 to 3	
				if j = 1 then 
					ls_jup_name = "(거 래 처 용)"			
				elseif j = 2 then
					ls_jup_name = "(매 장 용)"			
				else
					ls_jup_name = "(창 고 용)"			
				end if
					
					il_rows = dw_print.Retrieve(is_brand, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, ls_out_gubn)
					
//					ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"		
//					ls_Error = dw_print.Modify(ls_modify)
//						IF (ls_Error <> "") THEN 
//							MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
//						END IF		
						
					IF dw_print.RowCount() > 0 Then
						il_rows = dw_print.Print()
					END IF	
      	NEXT 					
	end if	
		
  next		
end if


This.Trigger Event ue_msg(6, il_rows)

end event

on w_42010_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_excel1=create cb_excel1
this.cb_print1=create cb_print1
this.cbx_a4=create cbx_a4
this.cbx_laser=create cbx_laser
this.cb_1=create cb_1
this.cbx_a42=create cbx_a42
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_excel1
this.Control[iCurrent+3]=this.cb_print1
this.Control[iCurrent+4]=this.cbx_a4
this.Control[iCurrent+5]=this.cbx_laser
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.cbx_a42
end on

on w_42010_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_excel1)
destroy(this.cb_print1)
destroy(this.cbx_a4)
destroy(this.cbx_laser)
destroy(this.cb_1)
destroy(this.cbx_a42)
end on

event pfc_preopen;call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
inv_resize.of_Register(dw_1, "ScaleToRight")

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//exec sp_42010_d01 'n', '20020216', '20020216', '%', '1', '010000', 'o1','11', '+'

dw_body.Reset()

il_rows = dw_1.retrieve(is_brand, is_frm_date, is_to_date, is_style, is_chno, &
								is_year, is_season, is_shop_cd, is_shop_type, is_house_cd, &
								is_jup_gubn, is_sale_type, is_out_gubn, IS_SHOP_DIV, is_color, is_size,is_item, is_sojae)

IF il_rows > 0 THEN
   dw_1.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

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



is_frm_date = dw_head.GetItemString(1, "frm_date")
if IsNull(is_frm_date) or Trim(is_frm_date) = "" then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_date")
   return false
end if

is_to_date = dw_head.GetItemString(1, "to_date")
if IsNull(is_to_date) or Trim(is_to_date) = "" then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_date")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then is_style = "%"

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then is_chno = "%"

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then is_year = '%'

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then is_season = '%'

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then is_shop_cd = "%"

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"출고 창고를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if

is_jup_gubn = dw_head.GetItemString(1, "jup_gubn")
if IsNull(is_jup_gubn) or Trim(is_jup_gubn) = "" then
   MessageBox(ls_title,"전표 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jup_gubn")
   return false
end if

is_sale_type = dw_head.GetItemString(1, "sale_type")
if IsNull(is_sale_type) or Trim(is_sale_type) = "" then
   MessageBox(ls_title,"판매 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_type")
   return false
end if

is_SHOP_DIV = dw_head.GetItemString(1, "SHOP_DIV")
if IsNull(is_SHOP_DIV) or Trim(is_SHOP_DIV) = "" then
   MessageBox(ls_title,"유통망 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("SHOP_DIV")
   return false
end if

is_out_gubn = dw_head.GetItemString(1, "out_gubn")
if IsNull(is_out_gubn) or Trim(is_out_gubn) = "" then
   MessageBox(ls_title,"출/반 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_gubn")
   return false
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

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"품종을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if


is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if


return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm, ls_shop_nm, ls_brand
DataStore  lds_Source
Boolean    lb_check 

CHOOSE CASE as_column
	CASE "style"				
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "chno", "")
					RETURN 0
				END IF 
				IF gf_style_chk(as_data, '%') = True THEN
				   dw_head.SetItem(al_row, "chno", "")
					RETURN 0
					
					
					 if gs_brand <> "K" then	
						dw_head.SetItem(al_row, "chno", "")
						RETURN 0
					 else	
							if gs_brand <> MidA(as_data,1,1) then
								Return 1
							else 
								dw_head.SetItem(al_row, "chno", "")
								RETURN 0
							end if	
					 end if		


					
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "STYLE 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "STYLE LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

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
				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				dw_head.SetItem(al_row, "chno",  lds_Source.GetItemString(1,"chno"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("chno")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source

CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
//				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
//					RETURN 0

					 if gs_brand <> "K" then	
						dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
						RETURN 0
					 else	
							if gs_brand <> MidA(as_data,1,1) then
								Return 1
							else 
								dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
								RETURN 0
							end if	
					 end if		

					
					
					
				END IF 
			END IF
			
			ls_brand = dw_head.getitemstring(1, "brand")
			
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			IF  gl_user_level >= 50 then 
					gst_cd.default_where   = "WHERE   shop_cd like '" + ls_brand + "%'"	
				else 	
					if gs_brand <> "K" then
						gst_cd.default_where   = "WHERE Shop_Stat = '00' "
					else
						gst_cd.default_where   = "WHERE Shop_Stat = '00' and shop_cd like 'K%' "
					end if	
			end if
			
			IF Trim(as_data) <> "" THEN
				if gs_brand <> "K" then
					gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
				else
					gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' and shop_cd like 'K%' "					
				end if	
			ELSE
				gst_cd.Item_where = ""
			END IF

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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("year")
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

event open;call super::open;Datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_date",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "to_date",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "year","%")
dw_head.SetItem(1, "season","%")
dw_head.SetItem(1, "jup_gubn","%")
dw_head.SetItem(1, "out_gubn","%")
dw_head.SetItem(1, "shop_type","%")
dw_head.SetItem(1, "sale_type","%")

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long   i 
String ls_shop_type, ls_out_no, ls_shop_cd, ls_yymmdd, ls_print, ls_inout_gubn, ls_out_gubn

if cbx_laser.checked then
	dw_print.DataObject = "d_com420_A"
	dw_print.SetTransObject(SQLCA)
ELSE
	dw_print.DataObject = "d_com420"
	dw_print.SetTransObject(SQLCA)
END IF	

FOR i = 1 TO dw_1.RowCount() 
	ls_print = dw_1.getitemstring(i, "print_out")
	IF ls_print = "Y"  THEN 
		ls_yymmdd     = dw_1.GetitemString(i, "yymmdd")			 
		ls_out_no     = dw_1.GetitemString(i, "out_no")
		ls_shop_cd    = dw_1.GetitemString(i, "shop_cd") 
		ls_shop_type  = dw_1.GetitemString(i, "shop_type")
		ls_inout_gubn = dw_1.GetitemString(i, "inout_gubn")
		If ls_inout_gubn = "+" THEN 
			ls_out_gubn = "1"
		else
			ls_out_gubn = "2"
		end if	

		il_rows = dw_print.Retrieve(is_brand, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, ls_out_gubn)
		IF dw_print.RowCount() > 0 Then
			il_rows = dw_print.Print()
		END IF
	END IF 	
NEXT 
	
This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42010_d","0")
end event

event ue_button(integer ai_cb_div, long al_rows);

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_print1.enabled = true			
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_excel1.enabled = true			
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_print1.enabled = false			
         cb_preview.enabled = false
         cb_excel.enabled = false
         cb_excel1.enabled = false			
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_print1.enabled = false		
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_excel1.enabled = false		
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

type cb_close from w_com010_d`cb_close within w_42010_d
integer taborder = 110
end type

type cb_delete from w_com010_d`cb_delete within w_42010_d
integer taborder = 60
end type

type cb_insert from w_com010_d`cb_insert within w_42010_d
integer taborder = 50
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42010_d
end type

type cb_update from w_com010_d`cb_update within w_42010_d
integer taborder = 100
end type

type cb_print from w_com010_d`cb_print within w_42010_d
integer x = 1947
integer width = 576
integer taborder = 70
string text = "거래명세서인쇄(&P)"
end type

type cb_preview from w_com010_d`cb_preview within w_42010_d
boolean visible = false
integer taborder = 80
end type

type gb_button from w_com010_d`gb_button within w_42010_d
end type

type cb_excel from w_com010_d`cb_excel within w_42010_d
integer x = 2523
integer taborder = 90
end type

type dw_head from w_com010_d`dw_head within w_42010_d
integer y = 176
integer height = 412
string dataobject = "d_42010_h01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

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
idw_house_cd.InsertRow(1)
idw_house_cd.SetItem(1, "shop_cd", '%')
idw_house_cd.SetItem(1, "shop_snm", '전체')

This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')

This.GetChild("SHOP_DIV", idw_shop_DIV )
idw_shop_DIV.SetTransObject(SQLCA)
idw_shop_DIV.Retrieve('910')
idw_shop_DIV.InsertRow(1)
idw_shop_DIV.SetItem(1, "inter_cd", '%')
idw_shop_DIV.SetItem(1, "inter_nm", '전체')

This.GetChild("jup_gubn", idw_jup_gubn )
idw_jup_gubn.SetTransObject(SQLCA)
idw_jup_gubn.Retrieve('025')
idw_jup_gubn.InsertRow(1)
idw_jup_gubn.SetItem(1, "inter_cd", '%')
idw_jup_gubn.SetItem(1, "inter_nm", '전체')

This.GetChild("sale_type", idw_sale_type )
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.Retrieve('011')
idw_sale_type.InsertRow(1)
idw_sale_type.SetItem(1, "inter_cd", '%')
idw_sale_type.SetItem(1, "inter_nm", '전체')

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


This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%')
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', is_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

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

CHOOSE CASE dwo.name
	CASE "shop_cd", "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)


	CASE "brand", "year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
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
			
			This.GetChild("sojae", idw_sojae)
			idw_sojae.SetTransObject(SQLCA)
			idw_sojae.Retrieve('%', is_brand)
			idw_sojae.insertrow(1)
			idw_sojae.Setitem(1, "sojae", "%")
			idw_sojae.Setitem(1, "sojae_nm", "전체")
			
			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_brand)
			idw_item.insertrow(1)
			idw_item.Setitem(1, "item", "%")
			idw_item.Setitem(1, "item_nm", "전체")
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_42010_d
integer beginx = -5
integer beginy = 616
integer endx = 3616
integer endy = 616
end type

type ln_2 from w_com010_d`ln_2 within w_42010_d
integer beginy = 620
integer endy = 620
end type

type dw_body from w_com010_d`dw_body within w_42010_d
integer y = 1220
integer width = 3579
integer height = 788
integer taborder = 40
string dataobject = "d_42010_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_42010_d
integer x = 2418
integer y = 1632
string dataobject = "d_com420"
end type

type dw_1 from u_dw within w_42010_d
integer x = 5
integer y = 636
integer width = 3579
integer height = 580
integer taborder = 11
string dataobject = "d_42010_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event doubleclicked;string ls_yymmdd, ls_out_no, ls_shop_cd, ls_shop_type, ls_sale_type, ls_inout_gubn

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

if dw_body.dataobject <> 'd_42010_d02' then
	dw_body.dataobject = 'd_42010_d02'
	dw_body.SetTransObject(SQLCA)
end if

//exec sp_42010_d02 'n', '20011201', '0254', 'ng0006', '1', '010000', 'o1','11', '+'
ls_yymmdd     = dw_1.GetitemString(row, "yymmdd") 
ls_shop_cd    = dw_1.GetitemString(row, "shop_cd") 
ls_shop_type  = dw_1.GetitemString(row, "shop_type") 
ls_out_no     = dw_1.GetitemString(row, "out_no") 
ls_inout_gubn = dw_1.GetitemString(row, "inout_gubn") 

il_rows = dw_body.retrieve(ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, ls_inout_gubn, "%", "%", "%", "%", "%", is_sojae)

IF il_rows > 0 THEN
   dw_1.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

end event

event constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

end event

event buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
Long i
String ls_yn

If dwo.Name = 'b_print' Then
	If dwo.Text = '선택' Then
		ls_yn = 'Y'
		dwo.Text = '제외'
	Else
		ls_yn = 'N'
		dwo.Text = '선택'
	End If
	
	For i = 1 To This.RowCount()
		This.SetItem(i, "print_out", ls_yn)
	Next
End If

end event

type cb_excel1 from cb_excel within w_42010_d
integer x = 32
integer width = 416
string text = "Excel(전전표)"
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)
li_ret = dw_1.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_print1 from commandbutton within w_42010_d
integer x = 443
integer y = 44
integer width = 384
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "명세서A4양식"
end type

event clicked;Parent.Trigger Event ue_print1()
end event

type cbx_a4 from checkbox within w_42010_d
integer x = 832
integer y = 32
integer width = 699
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "명세서A4양식(매장용)"
borderstyle borderstyle = stylelowered!
end type

type cbx_laser from checkbox within w_42010_d
integer x = 1513
integer y = 28
integer width = 521
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "명세서(laser)"
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_42010_d
integer x = 14
integer y = 1128
integer width = 251
integer height = 84
integer taborder = 21
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "전체보기"
end type

event clicked;
dw_body.dataobject = 'd_42010_d03'
dw_body.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_brand, is_frm_date, is_to_date, is_style, is_chno, &
								is_year, is_season, is_shop_cd, is_shop_type, is_house_cd, &
								is_jup_gubn, is_sale_type, is_out_gubn, IS_SHOP_DIV, is_color, is_size,is_item, is_sojae)

end event

type cbx_a42 from checkbox within w_42010_d
integer x = 832
integer y = 92
integer width = 640
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "명세서A4(자체인쇄)"
borderstyle borderstyle = stylelowered!
end type

