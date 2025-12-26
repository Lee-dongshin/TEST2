$PBExportHeader$w_12004_e.srw
$PBExportComments$품번관리
forward
global type w_12004_e from w_com010_e
end type
type dw_1 from datawindow within w_12004_e
end type
type dw_2 from datawindow within w_12004_e
end type
type p_1 from picture within w_12004_e
end type
end forward

global type w_12004_e from w_com010_e
dw_1 dw_1
dw_2 dw_2
p_1 p_1
end type
global w_12004_e w_12004_e

type variables
String is_Style, is_Chno
end variables

on w_12004_e.create
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

on w_12004_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.p_1)
end on

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/* Data window Resize */
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_2, "FixedToRight&ScaleToBottom")
inv_resize.of_Register(p_1, "FixedToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
dw_body.InsertRow(0)

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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
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





if gs_brand = 'N' and (MidA(is_style,1,1) = 'O' or MidA(is_style,1,1) = 'D' or MidA(is_style,1,1) = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false
elseif gs_brand = 'O' and (MidA(is_style,1,1) = 'N' or MidA(is_style,1,1) = 'M' or MidA(is_style,1,1) = 'E' or MidA(is_style,1,1) = 'F' or MidA(is_style,1,1) = 'G'  or MidA(is_style,1,1) = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false	
elseif gs_brand = 'Y' and (MidA(is_style,1,1) = 'N' or MidA(is_style,1,1) = 'M' or MidA(is_style,1,1) = 'E' or MidA(is_style,1,1) = 'F' or MidA(is_style,1,1) = 'G'  or MidA(is_style,1,1) = 'J') then
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


return true
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

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN		/* Modify Record */
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

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12004_e","0")
end event

type cb_close from w_com010_e`cb_close within w_12004_e
end type

type cb_delete from w_com010_e`cb_delete within w_12004_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_12004_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_12004_e
end type

type cb_update from w_com010_e`cb_update within w_12004_e
end type

type cb_print from w_com010_e`cb_print within w_12004_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_12004_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_12004_e
end type

type cb_excel from w_com010_e`cb_excel within w_12004_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_12004_e
integer width = 2473
integer height = 152
string dataobject = "d_12004_h01"
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

type ln_1 from w_com010_e`ln_1 within w_12004_e
integer beginy = 348
integer endx = 2528
integer endy = 348
end type

type ln_2 from w_com010_e`ln_2 within w_12004_e
integer beginy = 352
integer endx = 2528
integer endy = 352
end type

type dw_body from w_com010_e`dw_body within w_12004_e
integer y = 364
integer width = 2505
integer height = 1104
boolean enabled = false
string dataobject = "d_12004_d01"
end type

event dw_body::constructor;call super::constructor;DataWindowChild  ldw_Child

This.GetChild("out_seq", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('010')

This.GetChild("concept", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('122')

end event

type dw_print from w_com010_e`dw_print within w_12004_e
end type

type dw_1 from datawindow within w_12004_e
integer y = 1476
integer width = 2505
integer height = 576
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_12004_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_12004_e
event ue_syscommand pbm_syscommand
integer x = 2505
integer y = 1260
integer width = 1111
integer height = 792
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "단가 정보"
string dataobject = "d_12004_d03"
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

type p_1 from picture within w_12004_e
integer x = 2514
integer y = 164
integer width = 1093
integer height = 952
boolean bringtotop = true
boolean focusrectangle = false
end type

