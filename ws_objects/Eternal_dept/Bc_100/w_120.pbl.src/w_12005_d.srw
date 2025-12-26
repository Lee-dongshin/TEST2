$PBExportHeader$w_12005_d.srw
$PBExportComments$품번조회
forward
global type w_12005_d from w_com010_d
end type
type dw_1 from datawindow within w_12005_d
end type
type dw_2 from datawindow within w_12005_d
end type
type p_1 from picture within w_12005_d
end type
end forward

global type w_12005_d from w_com010_d
integer width = 3730
integer height = 2296
dw_1 dw_1
dw_2 dw_2
p_1 p_1
end type
global w_12005_d w_12005_d

type variables
String is_Style, is_Chno
end variables

on w_12005_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.p_1
end on

on w_12005_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.p_1)
end on

event pfc_preopen();call super::pfc_preopen;//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_1, "ScaleToRight")
inv_resize.of_Register(dw_2, "FixedToRight&ScaleToBottom")
inv_resize.of_Register(p_1, "FixedToRight")

/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_1.insertRow(0)


end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.11                                                  */	
/* 수정일      : 2001.12.11                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title, ls_style_no

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

ls_style_no = dw_head.GetItemString(1, "Style_no")
if IsNull(ls_style_no) or Trim(ls_style_no) = "" then
   MessageBox(ls_title,"품번 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false
end if
is_style = MidA(ls_style_no, 1, 8)
is_Chno  = MidA(ls_style_no, 9, 1)

return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_style, ls_chno
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style_no"				
		   ls_style = MidA(as_data, 1, 8)
			ls_chno  = MidA(as_data, 9, 1)
			IF ai_div = 1 THEN 	
			
			IF gf_style_chk(ls_style, ls_chno) THEN
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
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = ""
			
						
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"
//			ELSE
//				gst_cd.Item_where = ""
//			END IF
			
			if gs_brand <> "K" then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + ls_style + "%' and style like 'K%' "
				ELSE
					gst_cd.Item_where = "style like 'K%'"
				END IF
				
			end if	


			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/*===========================================================================*/
String ls_pic_nm

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_style, is_chno)
IF il_rows > 0 THEN
   dw_1.retrieve(is_style, is_chno)
   dw_2.retrieve(is_style)
	gf_pic_dir('0', is_style + is_chno, ls_pic_nm)
	p_1.PictureName = ls_pic_nm
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12005_d","0")
end event

type cb_close from w_com010_d`cb_close within w_12005_d
end type

type cb_delete from w_com010_d`cb_delete within w_12005_d
end type

type cb_insert from w_com010_d`cb_insert within w_12005_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_12005_d
end type

type cb_update from w_com010_d`cb_update within w_12005_d
end type

type cb_print from w_com010_d`cb_print within w_12005_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_12005_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_12005_d
end type

type cb_excel from w_com010_d`cb_excel within w_12005_d
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_12005_d
integer height = 148
string dataobject = "d_12005_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_12005_d
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_d`ln_2 within w_12005_d
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_d`dw_body within w_12005_d
integer y = 1480
integer width = 2519
integer height = 568
string dataobject = "d_12005_d02"
end type

type dw_print from w_com010_d`dw_print within w_12005_d
end type

type dw_1 from datawindow within w_12005_d
integer y = 344
integer width = 2519
integer height = 1132
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_12005_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_12005_d
event ue_syscommand pbm_syscommand
boolean visible = false
integer x = 2523
integer y = 1268
integer width = 1088
integer height = 780
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "단가정보"
string dataobject = "d_12005_d03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_syscommand;/* DataWindow 위치 이동 금지 */
uint a

a = message.wordparm

CHOOSE CASE a
      CASE 61456, 61458
         message.processed = true
         message.returnvalue = 0
END CHOOSE

return

end event

type p_1 from picture within w_12005_d
integer x = 2528
integer y = 348
integer width = 1093
integer height = 952
boolean bringtotop = true
boolean focusrectangle = false
end type

