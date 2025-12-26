$PBExportHeader$w_54020_e.srw
$PBExportComments$RT 스타일 선정
forward
global type w_54020_e from w_com010_e
end type
type dw_1 from datawindow within w_54020_e
end type
end forward

global type w_54020_e from w_com010_e
dw_1 dw_1
end type
global w_54020_e w_54020_e

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_color, idw_item, idw_sojae
String is_brand, is_year, is_season, is_style, is_color, is_item, is_sojae, is_yymmdd
end variables

on w_54020_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_54020_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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
if IsNull(is_style) or Trim(is_style) = "" then
 is_style = "%"
end if

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_color = dw_head.GetItemString(1, "color")
if IsNull(is_color) or Trim(is_color) = "" then
   MessageBox(ls_title,"색상을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("color")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"품종을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"선정일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_54020_d01 'n', '2003' ,'w', '%', '%','w','l'

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_style, is_color, is_sojae, is_item, is_yymmdd)
IF il_rows > 0 THEN

	dw_1.retrieve(is_yymmdd, is_style, is_color,is_year, is_season,  is_item, is_brand)
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54020_e","0")
end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                   */	
/* 작성일      :                                                   */	
/* 수정일      :                                                   */
/*===========================================================================*/
long     i, k, ll_row_count, ll_assort_cnt, ll_find, ll_rt_qty , ll_sale_qty, ll_out_qty
datetime ld_datetime
String   ls_color, ls_size, ls_find, ls_season, ls_year,ls_recall_no, ls_style, ls_chk

ll_row_count = dw_body.RowCount()
ll_assort_cnt = dw_1.RowCount()

IF dw_body.AcceptText() <> 1 THEN RETURN -1
		
		/* 시스템 날짜를 가져온다 */
		IF gf_sysdate(ld_datetime) = FALSE THEN
			Return 0
		END IF		

		FOR i=1 TO ll_row_count
			
			idw_status = dw_body.GetItemStatus(i, 0, Primary!)
			
			IF idw_status = NewModified! OR idw_status = DataModified! THEN	

				
				ls_style = dw_body.GetitemString(i, "style")
				ls_color = dw_body.GetitemString(i, "color")				
				ls_chk   = dw_body.GetitemString(i, "proc_chk")		

				messagebox("ls_chk", ls_chk)
				
				select dbo.sf_style_season(:ls_style),
				dbo.sf_style_year(:ls_style)
				into :ls_season, :ls_year
				from dual;

					
						ls_find     = "style = '" + ls_style + "' and color = '" + ls_color + "'"
						ll_find = dw_1.find(ls_find, 1, dw_1.RowCount())

						IF ll_find > 0 and ls_chk = "N" THEN
							dw_1.deleterow(ll_find)
						ELSEif ll_find = 0 and ls_chk = "Y" then
							ll_find = dw_1.insertRow(0)
							dw_1.Setitem(ll_find, "yymmdd",     is_yymmdd)					
							dw_1.Setitem(ll_find, "brand",      is_brand)
							dw_1.Setitem(ll_find, "style",      ls_style)
							dw_1.Setitem(ll_find, "color",      ls_color)					
							dw_1.Setitem(ll_find, "year",       ls_year)
							dw_1.Setitem(ll_find, "season",     ls_season)							
							dw_1.Setitem(ll_find, "item",       upper(MidA(ls_style,5,1)))														
							dw_1.Setitem(ll_find, "sojae",      upper(MidA(ls_style,2,1)))														
							dw_1.Setitem(ll_find, "proc_yn",    "N")								
							dw_1.Setitem(ll_find, "reg_id",     gs_user_id)
						END IF
				
			END IF
		NEXT
		
		
		il_rows = dw_1.Update()
		
		if il_rows = 1 then
			dw_body.ResetUpdate()
			commit  USING SQLCA;
		else
			rollback  USING SQLCA;
		end if

	   This.Trigger Event ue_button(3, il_rows)
		This.Trigger Event ue_msg(3, il_rows)

		
return il_rows

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_style, ls_chno
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style"	
		
		   IF ai_div = 1 THEN 	
				If IsNull(as_data) or Trim(as_data) = "" Then
				   dw_head.SetItem(al_row, "ls_style", "")
					RETURN 0
				END IF     
			END IF
			
			   gst_cd.ai_div          = ai_div
				gst_cd.window_title    = "STYLE 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = ""		
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " STYLE LIKE '" + LeftA(as_data, 8) + "%' "
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
				ls_style = lds_Source.GetItemString(1,"style")

				dw_head.SetItem(al_row, "style", ls_style)
				
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("COLOR")
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

type cb_close from w_com010_e`cb_close within w_54020_e
end type

type cb_delete from w_com010_e`cb_delete within w_54020_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_54020_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_54020_e
end type

type cb_update from w_com010_e`cb_update within w_54020_e
end type

type cb_print from w_com010_e`cb_print within w_54020_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_54020_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_54020_e
end type

type cb_excel from w_com010_e`cb_excel within w_54020_e
end type

type dw_head from w_com010_e`dw_head within w_54020_e
integer y = 180
string dataobject = "d_54020_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("color", idw_color )
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve('%', '%')

This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)

This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%',gs_brand)


end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "style_no"	    
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
	
		This.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', data)
		idw_sojae.insertrow(1)
		idw_sojae.Setitem(1, "sojae", "%")
		idw_sojae.Setitem(1, "sojae_nm", "전체")
		
		This.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve(data)
		idw_item.insertrow(1)
		idw_item.Setitem(1, "item", "%")
		idw_item.Setitem(1, "item_nm", "전체")		
		
		
END CHOOSE

end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;String ls_style, ls_chno, ls_color, ls_flag, ls_style_no

CHOOSE CASE dwo.name
	CASE "color"
		ls_style = This.GetitemString(row, "style")
		
	if IsNull(ls_style) or Trim(ls_style) = "" then
			idw_color.Retrieve(ls_style, '%')
	end if


		idw_color.insertRow(1)
		idw_color.Setitem(1, "color", "%")
		idw_color.Setitem(1, "color_enm", "전체")

END CHOOSE


end event

type ln_1 from w_com010_e`ln_1 within w_54020_e
end type

type ln_2 from w_com010_e`ln_2 within w_54020_e
end type

type dw_body from w_com010_e`dw_body within w_54020_e
string dataobject = "d_54020_d01"
end type

event dw_body::constructor;call super::constructor;dataWindowChild ldw_color
  
  This.GetChild("color", ldw_color )
  ldw_color.SetTransObject(SQLCA)
  ldw_color.Retrieve('%')

end event

type dw_print from w_com010_e`dw_print within w_54020_e
end type

type dw_1 from datawindow within w_54020_e
boolean visible = false
integer x = 137
integer y = 652
integer width = 3415
integer height = 600
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_54020_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

