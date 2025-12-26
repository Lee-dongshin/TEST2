$PBExportHeader$w_43028_d.srw
$PBExportComments$특정스타일, 일자별수불현황
forward
global type w_43028_d from w_com010_d
end type
end forward

global type w_43028_d from w_com010_d
integer width = 3689
integer height = 2288
end type
global w_43028_d w_43028_d

type variables
String is_style, is_color, is_size
datawindowchild  idw_size, idw_color

end variables

on w_43028_d.create
call super::create
end on

on w_43028_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.06.21                                                  */	
/* 수정일      : 2002.06.21                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_style, is_color, is_size)

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



is_style = Trim(dw_head.GetItemString(1, "style"))
if IsNull(is_style) or is_style = "" then
   MessageBox(ls_title,"STYLE 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style")
   return false
end if



if gs_brand = 'N' and (MidA(is_style,1,1) = 'O' or MidA(is_style,1,1) = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false
elseif gs_brand = 'O' and (MidA(is_style,1,1) = 'N' or MidA(is_style,1,1) = 'B' or MidA(is_style,1,1) = 'L' or MidA(is_style,1,1) = 'F' or MidA(is_style,1,1) = 'G'  or MidA(is_style,1,1) = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false	
elseif gs_brand = 'B' and (MidA(is_style,1,1) = 'O' or MidA(is_style,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false		
elseif gs_brand = 'G' and (MidA(is_style,1,1) = 'O' or MidA(is_style,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
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



return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.06.21                                                  */	
/* 수정일      : 2002.06.21                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column

	CASE "style"				
			IF ai_div = 1 THEN 	
				IF gf_style_chk(as_data, '%') THEN
					if gs_brand <> "K" then						
						RETURN 0
					else 
						if gs_brand <> MidA(as_data,1,1) then
							Return 1
						else 
							RETURN 0
						end if	
					end if	
					
					
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

			if gs_brand <> "K" then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + as_data + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + as_data + "%' and style like 'K%' "
				ELSE
					gst_cd.Item_where = "style like 'K%'"
				END IF
				
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
            "t_style.Text    = '" + is_style + "'" 
          
dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43028_d","0")
end event

type cb_close from w_com010_d`cb_close within w_43028_d
end type

type cb_delete from w_com010_d`cb_delete within w_43028_d
end type

type cb_insert from w_com010_d`cb_insert within w_43028_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43028_d
end type

type cb_update from w_com010_d`cb_update within w_43028_d
end type

type cb_print from w_com010_d`cb_print within w_43028_d
end type

type cb_preview from w_com010_d`cb_preview within w_43028_d
end type

type gb_button from w_com010_d`gb_button within w_43028_d
end type

type cb_excel from w_com010_d`cb_excel within w_43028_d
end type

type dw_head from w_com010_d`dw_head within w_43028_d
integer x = 41
integer y = 200
integer width = 1678
integer height = 172
string dataobject = "d_43028_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.06.21                                                  */	
/* 수정일      : 2002.06.21                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;call super::constructor;

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

type ln_1 from w_com010_d`ln_1 within w_43028_d
integer beginy = 392
integer endy = 392
end type

type ln_2 from w_com010_d`ln_2 within w_43028_d
integer beginy = 396
integer endy = 396
end type

type dw_body from w_com010_d`dw_body within w_43028_d
integer x = 14
integer y = 412
integer height = 1628
string dataobject = "d_43028_d01"
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(false)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_print from w_com010_d`dw_print within w_43028_d
integer x = 183
integer y = 796
integer width = 1879
integer height = 452
string dataobject = "d_43028_r01"
end type

