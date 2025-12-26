$PBExportHeader$w_52003_e.srw
$PBExportComments$자동배분율 생성
forward
global type w_52003_e from w_com010_e
end type
type rb_1 from radiobutton within w_52003_e
end type
type rb_2 from radiobutton within w_52003_e
end type
type dw_1 from datawindow within w_52003_e
end type
type rb_3 from radiobutton within w_52003_e
end type
type dw_2 from datawindow within w_52003_e
end type
type rb_4 from radiobutton within w_52003_e
end type
type dw_3 from datawindow within w_52003_e
end type
type rb_5 from radiobutton within w_52003_e
end type
type gb_1 from groupbox within w_52003_e
end type
end forward

global type w_52003_e from w_com010_e
integer width = 3648
integer height = 2292
rb_1 rb_1
rb_2 rb_2
dw_1 dw_1
rb_3 rb_3
dw_2 dw_2
rb_4 rb_4
dw_3 dw_3
rb_5 rb_5
gb_1 gb_1
end type
global w_52003_e w_52003_e

type variables
String is_deal_type, is_brand, is_year, is_season, is_fr_ym, is_to_ym
String is_sojae, is_item , is_year1, is_season1
end variables

on w_52003_e.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_1=create dw_1
this.rb_3=create rb_3
this.dw_2=create dw_2
this.rb_4=create rb_4
this.dw_3=create dw_3
this.rb_5=create rb_5
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.dw_2
this.Control[iCurrent+6]=this.rb_4
this.Control[iCurrent+7]=this.dw_3
this.Control[iCurrent+8]=this.rb_5
this.Control[iCurrent+9]=this.gb_1
end on

on w_52003_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_1)
destroy(this.rb_3)
destroy(this.dw_2)
destroy(this.rb_4)
destroy(this.dw_3)
destroy(this.rb_5)
destroy(this.gb_1)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToBottom")
inv_resize.of_Register(dw_2, "ScaleToBottom")
inv_resize.of_Register(dw_3, "ScaleToBottom")

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.25                                                  */	
/* 수정일      : 2002.01.25                                                  */
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


is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_year1 = dw_head.GetItemString(1, "year1")
if IsNull(is_year1) or Trim(is_year1) = "" then
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year1")
   return false
end if

is_season1 = dw_head.GetItemString(1, "season1")
if IsNull(is_season1) or Trim(is_season1) = "" then
   MessageBox(ls_title,"시즌코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season1")
   return false
end if

is_fr_ym = String(dw_head.GetitemDate(1, "fr_ym"), "yyyymm")
is_to_ym = String(dw_head.GetitemDate(1, "to_ym"), "yyyymm")

return true
end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.25                                                  */	
/* 수정일      : 2002.01.25                                                  */
/*===========================================================================*/
Long     i
Dec      ldc_rate
String   ls_deal
dwobject ldw_object

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_body.setredraw(False)
IF is_deal_type = 'A' THEN
   il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_year1, is_season1,is_fr_ym, is_to_ym)
elseIF is_deal_type = 'O' THEN
   il_rows = dw_body.retrieve(is_brand, "%", "%", "%", "%",is_fr_ym, is_to_ym)	
ELSEIF is_deal_type = 'M' THEN
	dw_2.retrieve(is_brand, is_year, is_season,is_year1, is_season1)
   il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_year1, is_season1)
ELSEIF is_deal_type = 'N' THEN
	dw_3.retrieve(is_brand, is_year, is_season,is_year1, is_season1)
   il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_year1, is_season1)	
ELSE	
	dw_1.retrieve(is_brand, is_year, is_season,is_year1, is_season1)
   il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_year1, is_season1)
END IF

FOR i = 1 TO il_rows 
	ldc_rate = dw_body.GetitemDecimal(i, "c_new_rate")
	dw_body.Setitem(i, "deal_rate", ldc_rate) 
	ls_deal = dw_body.GetitemString(i, "deal_Type") 
	IF isnull(ls_deal) THEN 
		dw_body.Setitem(i, "deal_Type", is_deal_type) 
      dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
	END IF
NEXT 

IF is_deal_type = 'B' AND il_rows > 0 THEN 
	dw_1.SetRow(1) 
	dw_1.Trigger event clicked(0, 0, 1, ldw_object)
END IF

IF is_deal_type = 'M' AND il_rows > 0 THEN 
	dw_2.SetRow(1) 
	dw_2.Trigger event clicked(0, 0, 1, ldw_object)
END IF

IF is_deal_type = 'N' AND il_rows > 0 THEN 
	dw_3.SetRow(1) 
	dw_3.Trigger event clicked(0, 0, 1, ldw_object)
END IF

dw_body.Setredraw(True)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_insert.enabled = true
			rb_1.enabled = false
			rb_2.enabled = false
			rb_3.enabled = false
			rb_4.enabled = false			
      	ib_changed = true
         cb_update.enabled = true
         dw_1.Enabled = true
      end if

   CASE 5    /* 조건 */
      cb_insert.enabled = false
		rb_1.enabled = true
		rb_2.enabled = true
		rb_3.enabled = true
		rb_4.enabled = true
      dw_1.Enabled = false
END CHOOSE

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.25                                                  */	
/* 수정일      : 2002.01.25                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF
dw_body.setredraw(False)

IF is_deal_type = 'B' THEN
   dw_body.SetFilter("")
   dw_body.Filter() 
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "brand",     is_brand)
		IF is_deal_type = 'A' THEN
         dw_body.Setitem(i, "sojae",     '*')
         dw_body.Setitem(i, "item",      '*')
		elseIF is_deal_type = 'O' THEN
         dw_body.Setitem(i, "sojae",     '*')
         dw_body.Setitem(i, "item",      '*')			
		elseIF is_deal_type = 'N' THEN
         dw_body.Setitem(i, "sojae",  is_sojae)			
         dw_body.Setitem(i, "item",    '*')			
		ELSE
         dw_body.Setitem(i, "sojae",  is_sojae)
         dw_body.Setitem(i, "item",   is_item)
		END IF
      dw_body.Setitem(i, "deal_type", is_deal_type)
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */ 
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

IF is_deal_type = 'B' THEN
   dw_body.SetFilter("sojae = '" + is_sojae + "' and item = '" + is_item + "'")
   dw_body.Filter()
END IF

IF is_deal_type = 'M' THEN
   dw_body.SetFilter("sojae = '" + is_sojae + "' and item = '" + is_item + "'")
   dw_body.Filter()
END IF

IF is_deal_type = 'N' THEN
   dw_body.SetFilter("sojae = '" + is_sojae + "'")
   dw_body.Filter()
END IF

dw_body.setredraw(True)

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event open;call super::open;is_deal_type = 'A'

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_body.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' " + & 
											 "  AND shop_div  in ('G', 'K', 'Z')"
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
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_body.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("deal_rate")
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_52003_e","0")
end event

event pfc_dberror();//
end event

type cb_close from w_com010_e`cb_close within w_52003_e
integer taborder = 120
end type

type cb_delete from w_com010_e`cb_delete within w_52003_e
integer taborder = 70
end type

type cb_insert from w_com010_e`cb_insert within w_52003_e
integer taborder = 50
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_52003_e
integer taborder = 30
end type

type cb_update from w_com010_e`cb_update within w_52003_e
integer taborder = 110
end type

type cb_print from w_com010_e`cb_print within w_52003_e
boolean visible = false
integer taborder = 80
end type

type cb_preview from w_com010_e`cb_preview within w_52003_e
boolean visible = false
integer taborder = 90
end type

type gb_button from w_com010_e`gb_button within w_52003_e
end type

type cb_excel from w_com010_e`cb_excel within w_52003_e
boolean visible = false
integer taborder = 100
end type

type dw_head from w_com010_e`dw_head within w_52003_e
integer x = 599
integer y = 160
integer width = 2862
integer height = 204
integer taborder = 20
string dataobject = "d_52003_h01"
end type

event dw_head::constructor;DataWindowChild ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('001')

This.GetChild("season", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('003',gs_brand, '%')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1, "inter_cd", '%')
//ldw_child.SetItem(1, "inter_nm", '전체')
//

This.GetChild("season1", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('003',gs_brand ,'%')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1, "inter_cd", '%')
//ldw_child.SetItem(1, "inter_nm", '전체')
//
end event

event dw_head::itemchanged;call super::itemchanged;DataWindowChild ldw_season, ldw_season1
string ls_year, ls_brand

this.accepttext()

CHOOSE CASE dwo.name
	CASE  "brand"
		
		ls_brand = data
	
		this.getchild("season",ldw_season)
		ldw_season.settransobject(sqlca)
		ldw_season.retrieve('003', ls_brand, '%')
		ldw_season.insertrow(1)
		ldw_season.Setitem(1, "inter_cd", "%")
		ldw_season.Setitem(1, "inter_nm", "전체")
		
		this.getchild("season1",ldw_season1)
		ldw_season1.settransobject(sqlca)
		ldw_season1.retrieve('003', ls_brand, '%')
		ldw_season1.insertrow(1)
		ldw_season1.Setitem(1, "inter_cd", "%")
		ldw_season1.Setitem(1, "inter_nm", "전체")

		
		
		
	CASE  "year", "year1"
		
		ls_brand = this.getitemstring(row, "brand")
		ls_year = data
	
		this.getchild("season",ldw_season)
		ldw_season.settransobject(sqlca)
		ldw_season.retrieve('003', ls_brand, ls_year)
		ldw_season.insertrow(1)
		ldw_season.Setitem(1, "inter_cd", "%")
		ldw_season.Setitem(1, "inter_nm", "전체")
		
		this.getchild("season1",ldw_season1)
		ldw_season1.settransobject(sqlca)
		ldw_season1.retrieve('003', ls_brand,  ls_year)
		ldw_season1.insertrow(1)
		ldw_season1.Setitem(1, "inter_cd", "%")
		ldw_season1.Setitem(1, "inter_nm", "전체")

		
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_52003_e
integer beginy = 476
integer endy = 476
end type

type ln_2 from w_com010_e`ln_2 within w_52003_e
integer beginy = 480
integer endy = 480
end type

type dw_body from w_com010_e`dw_body within w_52003_e
integer y = 492
integer width = 3602
integer height = 1560
integer taborder = 40
string dataobject = "d_52003_d01"
end type

event dw_body::constructor;call super::constructor;This.SetRowFocusIndicator(Hand!)

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.06.07                                                  */	
/* 수정일      : 2002.06.07                                                  */
/*===========================================================================*/
CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_body::dberror;//
end event

type dw_print from w_com010_e`dw_print within w_52003_e
end type

type rb_1 from radiobutton within w_52003_e
event ue_keydown pbm_keydown
integer x = 69
integer y = 176
integer width = 402
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
string text = "평균 매출"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN 
	Send(Handle(This), 256, 9, long(0,0))
	Return 1 
END IF

end event

event clicked;is_deal_type = 'A'

This.textcolor = Rgb(0, 0, 255)
rb_2.textcolor = Rgb(0, 0, 0)
rb_3.textcolor = Rgb(0, 0, 0)
rb_4.textcolor = Rgb(0, 0, 0)
rb_5.textcolor = Rgb(0, 0, 0)


dw_head.Object.t_ym.visible = True
dw_head.Object.t_1.visible = True
dw_head.Object.fr_ym.visible = True
dw_head.Object.to_ym.visible = True

dw_1.visible = False
dw_2.visible = False

dw_body.DataObject = "d_52003_d01"
dw_body.SetTransObject(SQLCA)
dw_body.width = dw_body.width + (dw_body.x - 5)
dw_body.x = 5

end event

type rb_2 from radiobutton within w_52003_e
event ue_keydown pbm_keydown
integer x = 69
integer y = 244
integer width = 439
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "복종별 회전율"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN 
	Send(Handle(This), 256, 9, long(0,0))
	Return 1 
END IF

end event

event clicked;is_deal_type = 'B'

This.textcolor = Rgb(0, 0, 255)
rb_1.textcolor = Rgb(0, 0, 0)
rb_3.textcolor = Rgb(0, 0, 0)
rb_4.textcolor = Rgb(0, 0, 0)
rb_5.textcolor = Rgb(0, 0, 0)

dw_head.Object.t_ym.visible = False
dw_head.Object.t_1.visible = False
dw_head.Object.fr_ym.visible = False
dw_head.Object.to_ym.visible = False

dw_1.visible = True

dw_body.DataObject = "d_52003_d02"
dw_body.SetTransObject(SQLCA)

dw_body.width = dw_body.width + (dw_body.x - 5)
dw_body.x = 5

dw_body.x = 974
dw_body.width = dw_body.width - (dw_body.x - 5)

end event

type dw_1 from datawindow within w_52003_e
boolean visible = false
integer y = 504
integer width = 969
integer height = 1548
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_52003_d09"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
DataWindowChild ldw_child

This.GetChild("sojae", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('%')



// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

event clicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.12                                                  */	
/* 수정일      : 2002.01.25                                                  */
/*===========================================================================*/
IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)


is_sojae = This.GetItemString(row, 'sojae') 
is_item  = This.GetItemString(row, 'item') 

dw_body.SetFilter("sojae = '" + is_sojae + "' and item = '" + is_item + "'")
dw_body.SetRedraw(false)
dw_body.Filter()
dw_body.SetRedraw(true)





end event

type rb_3 from radiobutton within w_52003_e
event ue_keydown pbm_keydown
boolean visible = false
integer x = 69
integer y = 312
integer width = 439
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "감도별 회전율"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN 
	Send(Handle(This), 256, 9, long(0,0))
	Return 1 
END IF

end event

event clicked;is_deal_type = 'M'

This.textcolor = Rgb(0, 0, 255)
rb_1.textcolor = Rgb(0, 0, 0)
rb_2.textcolor = Rgb(0, 0, 0)
rb_4.textcolor = Rgb(0, 0, 0)

dw_head.Object.t_ym.visible = False
dw_head.Object.t_1.visible = False
dw_head.Object.fr_ym.visible = False
dw_head.Object.to_ym.visible = False


dw_2.visible = True


dw_body.DataObject = "d_52003_d03"
dw_body.SetTransObject(SQLCA)

dw_body.width = dw_body.width + (dw_body.x - 5)
dw_body.x = 5

dw_body.x = 974
dw_body.width = dw_body.width - (dw_body.x - 5)

end event

type dw_2 from datawindow within w_52003_e
boolean visible = false
integer x = 5
integer y = 500
integer width = 960
integer height = 1552
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_52003_d10"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
DataWindowChild ldw_child


// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

event clicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.12                                                  */	
/* 수정일      : 2002.01.25                                                  */
/*===========================================================================*/
IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_sojae = This.GetItemString(row, 'sojae') 
is_item  = This.GetItemString(row, 'item') 

dw_body.SetFilter("sojae = '" + is_sojae + "' and item = '" + is_item + "'")
dw_body.SetRedraw(false)
dw_body.Filter()
dw_body.SetRedraw(true)



end event

type rb_4 from radiobutton within w_52003_e
event ue_keydown pbm_keydown
integer x = 69
integer y = 316
integer width = 439
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "소재별 회전율"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN 
	Send(Handle(This), 256, 9, long(0,0))
	Return 1 
END IF

end event

event clicked;is_deal_type = 'N'

This.textcolor = Rgb(0, 0, 255)
rb_1.textcolor = Rgb(0, 0, 0)
rb_2.textcolor = Rgb(0, 0, 0)
rb_3.textcolor = Rgb(0, 0, 0)
rb_5.textcolor = Rgb(0, 0, 0)

dw_head.Object.t_ym.visible = False
dw_head.Object.t_1.visible = False
dw_head.Object.fr_ym.visible = False
dw_head.Object.to_ym.visible = False

dw_3.visible = True

dw_body.DataObject = "d_52003_d04"
dw_body.SetTransObject(SQLCA)

dw_body.width = dw_body.width + (dw_body.x - 5)
dw_body.x = 5

dw_body.x = 974
dw_body.width = dw_body.width - (dw_body.x - 5)

end event

type dw_3 from datawindow within w_52003_e
boolean visible = false
integer x = 5
integer y = 500
integer width = 960
integer height = 1552
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_52003_d09a"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_child


// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

This.GetChild("sojae", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('%')

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

event clicked;IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_sojae = This.GetItemString(row, 'sojae') 
is_item  = This.GetItemString(row, 'item') 

dw_body.SetFilter("sojae = '" + is_sojae + "'")
dw_body.SetRedraw(false)
dw_body.Filter()
dw_body.SetRedraw(true)


end event

type rb_5 from radiobutton within w_52003_e
integer x = 69
integer y = 388
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "RT판매"
borderstyle borderstyle = stylelowered!
end type

event clicked;is_deal_type = 'O'

This.textcolor = Rgb(0, 0, 255)
rb_1.textcolor = Rgb(0, 0, 0)
rb_2.textcolor = Rgb(0, 0, 0)
rb_3.textcolor = Rgb(0, 0, 0)
rb_4.textcolor = Rgb(0, 0, 0)

dw_head.Object.t_ym.visible = true
dw_head.Object.t_1.visible = true
dw_head.Object.fr_ym.visible = true
dw_head.Object.to_ym.visible = true

dw_head.Object.yyyy_t.visible = false
dw_head.Object.t_2.visible = false
dw_head.Object.t_3.visible = false
dw_head.Object.t_4.visible = false
dw_head.Object.year.visible = false
dw_head.Object.year1.visible = false
dw_head.Object.season.visible = false
dw_head.Object.season1.visible = false

dw_3.visible = false
dw_1.visible = False
dw_2.visible = False

dw_body.DataObject = "d_52003_d05"
dw_body.SetTransObject(SQLCA)
dw_body.width = dw_body.width + (dw_body.x - 5)
dw_body.x = 5

end event

type gb_1 from groupbox within w_52003_e
integer x = 27
integer y = 132
integer width = 553
integer height = 332
integer taborder = 10
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

