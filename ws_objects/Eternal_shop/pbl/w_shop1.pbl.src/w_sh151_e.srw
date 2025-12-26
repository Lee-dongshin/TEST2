$PBExportHeader$w_sh151_e.srw
$PBExportComments$RT 마켓 거래승인
forward
global type w_sh151_e from w_com010_e
end type
type st_1 from statictext within w_sh151_e
end type
type st_3 from statictext within w_sh151_e
end type
end forward

global type w_sh151_e from w_com010_e
integer width = 2976
integer height = 2072
long backcolor = 16777215
st_1 st_1
st_3 st_3
end type
global w_sh151_e w_sh151_e

type variables
String is_yymmdd 
end variables

forward prototypes
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_size
String ls_brand, ls_plan_yn  
Long   ll_tag_price 

IF LenA(Trim(as_style_no)) <> 13 THEN RETURN FALSE

ls_style = MidA(as_style_no,  1, 8)
ls_chno  = MidA(as_style_no,  9, 1)
ls_color = MidA(as_style_no, 10, 2)
ls_size  = MidA(as_style_no, 12, 2)

Select brand,     tag_price,     plan_yn   
  into :ls_brand, :ll_tag_price, :ls_plan_yn    
  from vi_12024_1 
 where brand = :gs_brand 
   and style = :ls_style 
	and chno  = :ls_chno
	and color = :ls_color 
	and size  = :ls_size 
	and isnull(dep_fg,'N') <> 'Y' 
	and year + convert(char(01),dbo.sf_inter_sort_seq('003',season))  > '20032';

IF SQLCA.SQLCODE <> 0 THEN 
	Return False 
END IF

dw_body.SetItem(al_row, "tag_price", ll_tag_price) 
IF ls_plan_yn = 'Y' THEN 
	dw_body.Setitem(al_row, "fr_shop_type", '3')
	dw_body.Setitem(al_row, "to_shop_type", '3')
ELSE
	dw_body.Setitem(al_row, "fr_shop_type", '1')
	dw_body.Setitem(al_row, "to_shop_type", '1')
END IF

dw_body.SetItem(al_row, "style_no", as_style_no)
dw_body.SetItem(al_row, "style",    ls_style)
dw_body.SetItem(al_row, "chno",     ls_chno)
dw_body.SetItem(al_row, "color",    ls_color)
dw_body.SetItem(al_row, "size",     ls_size)
dw_body.SetItem(al_row, "brand",    ls_brand)

Return True

end function

on w_sh151_e.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_3
end on

on w_sh151_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_3)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
string   ls_title

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

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
Long ll_row

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(gs_shop_cd)
//IF il_rows >= 0 THEN
//	ll_row = dw_body.insertRow(0)
//	dw_body.SetRow(ll_row)
//	dw_body.SetColumn("style_no")
//   dw_body.SetFocus()
//END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size, ls_shop_nm
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source 

CHOOSE CASE as_column
	CASE "style_no"		
			IF ai_div = 1 THEN 	
				IF wf_style_chk(al_row, as_data)  THEN
				   ll_row_cnt = dw_body.RowCount()
				   IF al_row = ll_row_cnt THEN 
					   ll_row_cnt = dw_body.insertRow(0)
				   END IF
               dw_body.SetItem(al_row, "move_qty", 1)
					RETURN 0 
				END IF 
			END IF
		   ls_style = MidA(as_data, 1, 8)
		   ls_chno  = MidA(as_data, 9, 1)
		   ls_color = MidA(as_data, 10, 2)
		   ls_size  = MidA(as_data, 12, 2)
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com012" 
	      gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' and year + convert(char(01),dbo.sf_inter_sort_seq('003', SEASON)) > '20032' and isnull(dep_fg,'N') <> 'Y'  "										
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" + &
				                " and chno  LIKE '" + ls_chno + "%'" + &
				                " and color LIKE '" + ls_color + "%'" + &
				                " and size  LIKE '" + ls_size + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lb_check = FALSE 
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				
				dw_body.SetItem(al_row, "tag_price", lds_Source.GetItemNumber(1,"tag_price")) 
				IF lds_Source.GetItemString(1,"plan_yn") = 'Y' THEN 
					dw_body.Setitem(al_row, "fr_shop_type", '3')
					dw_body.Setitem(al_row, "to_shop_type", '3')
				ELSE
					dw_body.Setitem(al_row, "fr_shop_type", '1')
					dw_body.Setitem(al_row, "to_shop_type", '1')
				END IF
			   dw_body.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
			   dw_body.SetItem(al_row, "style",    lds_Source.GetItemString(1,"style"))
			   dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno"))
			   dw_body.SetItem(al_row, "color",    lds_Source.GetItemString(1,"color"))
			   dw_body.SetItem(al_row, "size",     lds_Source.GetItemString(1,"size"))
			   dw_body.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand"))
			   dw_body.SetItem(al_row, "move_qty", 1)
			   ib_changed = true
            cb_update.enabled = true
			   /* 다음컬럼으로 이동 */
			   ll_row_cnt = dw_body.RowCount()
			   IF al_row = ll_row_cnt THEN 
				   ll_row_cnt = dw_body.insertRow(0)
			   END IF
			   dw_body.SetColumn("to_shop_cd")
		      lb_check = TRUE 
				ib_itemchanged = FALSE
			END IF
			Destroy  lds_Source
	CASE "to_shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_body.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
               dw_body.SetRow(al_row + 1)
               dw_body.SetColumn("style_no")
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND BRAND     = '" + gs_brand + "'" + & 
											 "  AND shop_cd   <> '" + gs_shop_cd + "'"
			IF Trim(as_data) <> "" THEN 
            IF Match(as_data, "^[A-Za-z0-9]") THEN
               gst_cd.Item_where = "SHOP_CD  LIKE '" + as_data + "%'"
            ELSE
               gst_cd.Item_where = "SHOP_SNM LIKE '%" + as_data + "%'"
            END IF
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
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "to_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_body.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */ 
				dw_body.SetRow(al_row + 1)
				dw_body.SetColumn("style_no")
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

event pfc_postopen();call super::pfc_postopen;This.Trigger Event ue_Retrieve()
end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

//FOR i=1 TO ll_row_count
//   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
//   IF idw_status = NewModified! THEN				/* New Record */
//      dw_body.Setitem(i, "reg_id", gs_user_id)
//   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
//      dw_body.Setitem(i, "mod_id", gs_user_id)
//      dw_body.Setitem(i, "mod_dt", ld_datetime)
//   END IF
//NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

Trigger Event ue_retrieve()
return il_rows
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_1, "ScaleToRight")

end event

type cb_close from w_com010_e`cb_close within w_sh151_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh151_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh151_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh151_e
end type

type cb_update from w_com010_e`cb_update within w_sh151_e
end type

type cb_print from w_com010_e`cb_print within w_sh151_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh151_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh151_e
integer height = 160
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh151_e
integer width = 2811
integer height = 136
string dataobject = "d_sh151_h01"
end type

type ln_1 from w_com010_e`ln_1 within w_sh151_e
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_e`ln_2 within w_sh151_e
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_e`dw_body within w_sh151_e
event ue_set_column ( long al_row )
integer y = 344
integer height = 1488
string dataobject = "d_sh151_d01"
boolean hscrollbar = true
end type

event dw_body::ue_set_column(long al_row);/* 품번 키보드 및 스캐너 입력시 다음 line으로 이동 */

dw_body.SetRow(al_row + 1)  
dw_body.SetColumn("style_no")

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
Long ll_ret 
st_1.Text = "반드시 저장버튼을 누르세요 ! "

CHOOSE CASE dwo.name
	CASE "style_no"
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "to_shop_cd"
		IF ib_itemchanged THEN RETURN 1
		ll_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		IF ll_ret <> 1 THEN
			This.Post Event ue_set_column(row) 
		END IF
		return ll_ret
	

END CHOOSE

end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)                                           */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_sh151_e
integer x = 59
integer y = 628
end type

type st_1 from statictext within w_sh151_e
integer x = 407
integer y = 60
integer width = 1678
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 16777215
boolean focusrectangle = false
end type

type st_3 from statictext within w_sh151_e
integer x = 910
integer y = 208
integer width = 1609
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 16777215
string text = "※ 상대매장의 거래신청을  승인합니다."
boolean focusrectangle = false
end type

