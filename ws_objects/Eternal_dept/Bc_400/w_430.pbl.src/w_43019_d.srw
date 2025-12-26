$PBExportHeader$w_43019_d.srw
$PBExportComments$매장/STYLE 수불장
forward
global type w_43019_d from w_com010_d
end type
type dw_1 from datawindow within w_43019_d
end type
type st_1 from statictext within w_43019_d
end type
end forward

global type w_43019_d from w_com010_d
integer width = 3685
integer height = 2276
dw_1 dw_1
st_1 st_1
end type
global w_43019_d w_43019_d

type variables
String is_shop_cd, is_style, is_fr_ymd, is_to_ymd, is_shop_type, is_color, is_size, is_dotcom
datawindowchild  idw_shop_type, idw_size, idw_color

end variables

on w_43019_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_1
end on

on w_43019_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_1)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.06.21                                                  */	
/* 수정일      : 2002.06.21                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
dw_1.retrieve(is_style, is_shop_cd)
il_rows = dw_body.retrieve(is_shop_cd,is_shop_type, is_style, is_color, is_size, is_fr_ymd, is_to_ymd, is_dotcom)

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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.06.21                                                  */	
/* 수정일      : 2002.06.21                                                  */
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

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd"))
if IsNull(is_shop_cd) or is_shop_cd = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_shop_type = Trim(dw_head.GetItemString(1, "shop_type"))
if IsNull(is_shop_type) or is_shop_type = "" then
   MessageBox(ls_title,"매장 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_style = Trim(dw_head.GetItemString(1, "style"))
if IsNull(is_style) or is_style = "" then
   MessageBox(ls_title,"STYLE 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style")
   return false
end if

is_color = Trim(dw_head.GetItemString(1, "color"))
if IsNull(is_color) or is_color = "" then
   MessageBox(ls_title,"색상 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("color")
   return false
end if

is_size = Trim(dw_head.GetItemString(1, "size"))
if IsNull(is_size) or is_size = "" then
   MessageBox(ls_title,"사이즈 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("size")
   return false
end if

is_fr_ymd = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
if IsNull(is_fr_ymd) or is_fr_ymd = "" then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
if IsNull(is_to_ymd) or is_to_ymd = "" then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

if is_to_ymd < is_fr_ymd then
   MessageBox(ls_title,"시작 일자가 마지막 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_dotcom = dw_head.GetItemString(1, "dotcom")

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.06.21                                                  */	
/* 수정일      : 2002.06.21                                                  */
/*===========================================================================*/
String     ls_shop_nm , ls_style
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
//				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
//					RETURN 0
//					
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
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			
			IF  gl_user_level = 0 then 
					gst_cd.default_where   = "WHERE BRAND = '" + gs_brand + "' AND SHOP_STAT = '00' AND SHOP_DIV <> 'A' "
			else		
					gst_cd.default_where   = "WHERE  SHOP_STAT = '00' AND SHOP_DIV <> 'A' "
			end if	
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
				dw_head.SetColumn("style")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
	CASE "style"				
			IF ai_div = 1 THEN 	
				IF gf_style_chk(as_data, '%') THEN

					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번코드 검색" 
			gst_cd.datawindow_nm   = "d_com013" 
			// 스타일 선별작업
			IF  gl_user_level = 0 then 
					gst_cd.default_where   = "WHERE   style like '" + gs_brand + "%'"	
				else 	
					gst_cd.default_where   = " WHERE  brand <> 'T' and tag_price <> 0 "
				end if

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
				dw_head.SetItem(al_row, "color", lds_Source.GetItemString(1,"color"))
				dw_head.SetItem(al_row, "size", lds_Source.GetItemString(1,"size"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("fr_ymd")
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

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.06.21                                                  */	
/* 수정일      : 2002.06.21                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id + "'" + &
            "t_user_id.Text  = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_shop_cd.Text  = '" + is_shop_cd + "'" + &
            "t_shop_nm.Text  = '" + dw_head.GetItemString(1, "shop_nm") + "'" + &
				"t_shop_type.Text = '" +idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "'" + &
            "t_style.Text    = '" + is_style + "'" + &
            "t_fr_ymd.Text   = '" + String(is_fr_ymd, '@@@@/@@/@@') + "'" + &
            "t_to_ymd.Text   = '" + String(is_to_ymd, '@@@@/@@/@@') + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43019_d","0")
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "Right")

/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_43019_d
end type

type cb_delete from w_com010_d`cb_delete within w_43019_d
end type

type cb_insert from w_com010_d`cb_insert within w_43019_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43019_d
end type

type cb_update from w_com010_d`cb_update within w_43019_d
end type

type cb_print from w_com010_d`cb_print within w_43019_d
end type

type cb_preview from w_com010_d`cb_preview within w_43019_d
end type

type gb_button from w_com010_d`gb_button within w_43019_d
end type

type cb_excel from w_com010_d`cb_excel within w_43019_d
end type

type dw_head from w_com010_d`dw_head within w_43019_d
integer y = 180
integer height = 212
string dataobject = "d_43019_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.06.21                                                  */	
/* 수정일      : 2002.06.21                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd", "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')

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



end event

type ln_1 from w_com010_d`ln_1 within w_43019_d
integer beginy = 524
integer endy = 524
end type

type ln_2 from w_com010_d`ln_2 within w_43019_d
integer beginy = 528
integer endy = 528
end type

type dw_body from w_com010_d`dw_body within w_43019_d
integer x = 14
integer y = 540
integer height = 1500
string dataobject = "d_43019_d01"
end type

type dw_print from w_com010_d`dw_print within w_43019_d
integer x = 192
integer y = 1156
string dataobject = "d_43019_r01"
end type

type dw_1 from datawindow within w_43019_d
integer x = 2638
integer y = 156
integer width = 1637
integer height = 360
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_43019_d03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_43019_d
integer x = 1221
integer y = 160
integer width = 1417
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 82899184
string text = "※ 기간 중복시에는 스타일별 가격이 적용됩니다."
boolean focusrectangle = false
end type

