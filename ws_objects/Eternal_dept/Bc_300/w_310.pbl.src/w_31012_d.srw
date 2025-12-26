$PBExportHeader$w_31012_d.srw
$PBExportComments$부자재출고요청서
forward
global type w_31012_d from w_com010_d
end type
type dw_2 from datawindow within w_31012_d
end type
type dw_mast from datawindow within w_31012_d
end type
type dw_1 from datawindow within w_31012_d
end type
end forward

global type w_31012_d from w_com010_d
integer width = 3675
integer height = 2256
windowstate windowstate = maximized!
dw_2 dw_2
dw_mast dw_mast
dw_1 dw_1
end type
global w_31012_d w_31012_d

type variables
string is_style_no, is_gubn
end variables

on w_31012_d.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_mast=create dw_mast
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_mast
this.Control[iCurrent+3]=this.dw_1
end on

on w_31012_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.dw_mast)
destroy(this.dw_1)
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

is_style_no = dw_head.GetItemString(1, "style_no")
//if IsNull(is_style_no) or Trim(is_style_no) = "" then
//   MessageBox(ls_title,"스타일번호를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("style_no")
//   return false
//end if

is_gubn = dw_head.GetItemString(1, "gubn")



return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_gubn = '1' then
	il_rows = dw_1.retrieve(LeftA(is_style_no,8), RightA(is_style_no,1))	
elseif is_gubn = '2' then
	il_rows = dw_mast.retrieve(LeftA(is_style_no,8), RightA(is_style_no,1))
	IF il_rows > 0 THEN
		dw_body.SetFocus()
		il_rows = dw_body.retrieve(LeftA(is_style_no,8), RightA(is_style_no,1))	
	end if	
else
	il_rows = dw_2.retrieve(is_style_no)
end if

IF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style_no"
			if isnull(as_data) or as_data = ''  then
				return 0
			elseIF ai_div = 1 THEN 	
				IF gf_style_chk(LeftA(as_data, 8), MidA(as_data, 9, 1)) = True THEN
////				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
//					RETURN 0
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
				gst_cd.window_title    = "STYLE 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = ""		//WHERE TB_11010_M.PART_FG IN ('1', '2', '3') 

			if gs_brand <> "K" then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + LeftA(as_data, 8) + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + LeftA(as_data, 8) + "%' and style like 'K%' "
				ELSE
					gst_cd.Item_where = "style like 'K%'"
				END IF
				
			end if	

//				
//				IF Trim(as_data) <> "" THEN
//					gst_cd.Item_where = " STYLE LIKE '" + Left(as_data, 8) + "%' "
//				ELSE
//					gst_cd.Item_where = ""
//				END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetItem(1, "style_no", lds_Source.GetItemString(1,"style_no"))
				/* 다음컬럼으로 이동 */

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

RETURN 1

end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_mast, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_2, "ScaleToRight&Bottom")


/* DataWindow의 Transction 정의 */
dw_mast.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)


end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
if is_gubn = '1' then
	dw_print.dataobject = 'd_31012_r01'
	dw_print.SetTransObject(SQLCA)
	
	This.Trigger Event ue_title ()
	dw_1.ShareData(dw_print)
	dw_print.inv_printpreview.of_SetZoom()

elseif is_gubn = '2' then
	dw_print.dataobject = 'd_31012_r00'
	dw_print.SetTransObject(SQLCA)
	
	This.Trigger Event ue_title ()
	il_rows = dw_print.retrieve(LeftA(is_style_no,8), RightA(is_style_no,1))	
	dw_print.inv_printpreview.of_SetZoom()
else
	dw_print.dataobject = 'd_31012_r04'
	dw_print.SetTransObject(SQLCA)
	
	This.Trigger Event ue_title ()
	dw_2.ShareData(dw_print)
	dw_print.inv_printpreview.of_SetZoom()	
end if
end event

event open;call super::open;
is_style_no = Message.StringParm	
if LenA(is_style_no) = 9 then
	dw_head.setitem(1, "style_no", is_style_no)
	
	il_rows = dw_mast.retrieve(LeftA(is_style_no,8), RightA(is_style_no,1) )
	il_rows = dw_body.retrieve(LeftA(is_style_no,8), RightA(is_style_no,1) )
end if





end event

type cb_close from w_com010_d`cb_close within w_31012_d
end type

type cb_delete from w_com010_d`cb_delete within w_31012_d
end type

type cb_insert from w_com010_d`cb_insert within w_31012_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_31012_d
boolean underline = true
end type

event cb_retrieve::clicked;/*===========================================================================*/
/* 작성자      : M.S.I (김태범) 															  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

//This.Enabled = False
oldpointer = SetPointer(HourGlass!)

IF dw_head.Enabled THEN
	Parent.Trigger Event ue_retrieve()	//조회
ELSE
	Parent.Trigger Event ue_head()	//조건
END IF

SetPointer(oldpointer)
This.Enabled = True

end event

type cb_update from w_com010_d`cb_update within w_31012_d
end type

type cb_print from w_com010_d`cb_print within w_31012_d
end type

type cb_preview from w_com010_d`cb_preview within w_31012_d
boolean enabled = true
end type

type gb_button from w_com010_d`gb_button within w_31012_d
end type

type cb_excel from w_com010_d`cb_excel within w_31012_d
end type

type dw_head from w_com010_d`dw_head within w_31012_d
integer y = 160
integer height = 152
string dataobject = "d_31012_h01"
boolean livescroll = false
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/


CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	case "gubn"
		if data = '1' then
			dw_1.visible = true
			dw_2.visible = false
		elseif data = '2' then 
			dw_1.visible = false
			dw_2.visible = false
		else
			dw_1.visible = false
			dw_2.visible = true
		end if
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_31012_d
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com010_d`ln_2 within w_31012_d
integer beginy = 352
integer endy = 352
end type

type dw_body from w_com010_d`dw_body within w_31012_d
integer y = 1340
integer height = 680
string dataobject = "d_31012_d03"
end type

type dw_print from w_com010_d`dw_print within w_31012_d
integer x = 5
integer y = 368
integer width = 727
integer height = 300
string dataobject = "d_31012_r00"
end type

type dw_2 from datawindow within w_31012_d
boolean visible = false
integer x = 5
integer y = 364
integer width = 3589
integer height = 1660
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_31012_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_mast from datawindow within w_31012_d
integer x = 5
integer y = 364
integer width = 3589
integer height = 972
integer taborder = 20
string title = "none"
string dataobject = "d_31012_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;
if dwo.name = "b_ack_yn" then
	update tb_21020_cust set ack_yn = 'Y' where ord_origin = :is_style_no;
	commit  USING SQLCA;
	this.object.b_ack_yn.visible = false
end if

end event

type dw_1 from datawindow within w_31012_d
boolean visible = false
integer x = 5
integer y = 364
integer width = 3593
integer height = 1660
integer taborder = 30
string title = "none"
string dataobject = "d_31012_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

