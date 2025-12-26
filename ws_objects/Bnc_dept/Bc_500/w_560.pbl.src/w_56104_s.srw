$PBExportHeader$w_56104_s.srw
$PBExportComments$입금예정현황[입금등록]
forward
global type w_56104_s from w_com010_e
end type
end forward

global type w_56104_s from w_com010_e
integer width = 2930
integer height = 1532
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
end type
global w_56104_s w_56104_s

type variables
String is_brand, is_yymmdd, is_shop_cd

end variables

on w_56104_s.create
call super::create
end on

on w_56104_s.destroy
call super::destroy
end on

event pfc_postopen();call super::pfc_postopen;This.Trigger Event ue_retrieve()
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.06.26                                                  */	
/* 수정일      : 2002.06.26                                                  */
/*===========================================================================*/

is_brand   = dw_head.GetItemString(1, "brand")
is_yymmdd  = dw_head.GetItemString(1, "yymmdd")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox('알림',"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox('알림',"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox('알림',"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox('알림',"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.26                                                  */	
/* 수정일      : 2002.06.26                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymmdd, is_shop_cd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
	il_rows = dw_body.insertRow(0)
	dw_body.SETITEM(il_rows, "REMARK",  gsv_cd.gs_cd6 )	
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;dw_head.Setitem(1, "brand",   gsv_cd.gs_cd1)
dw_head.Setitem(1, "yymmdd",  gsv_cd.gs_cd2)
dw_head.Setitem(1, "shop_cd", gsv_cd.gs_cd3)
dw_head.Setitem(1, "shop_nm", gsv_cd.gs_cd4)
gsv_cd.gs_cd5 = 'NO'

end event

event pfc_preopen();call super::pfc_preopen;Window ldw_parent
Long   ll_x, ll_y

ldw_parent = This.ParentWindow()
This.x = ((ldw_parent.Width - This.Width) / 2) +  ldw_parent.x
This.y = ((ldw_parent.Height - This.Height) / 2) +  ldw_parent.y 

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.26                                                  */	
/* 수정일      : 2002.06.26                                                  */
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
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "yymmdd",     is_yymmdd)
      dw_body.Setitem(i, "shop_cd",    is_shop_cd)
      dw_body.Setitem(i, "brand",      is_brand)
      dw_body.Setitem(i, "shop_div",   MidA(is_shop_cd, 2, 1))
      dw_body.Setitem(i, "deposit_no", '0001')
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
   IF idw_status <> New! THEN				/* New Record */
      dw_body.Setitem(i, "no", String(i,'0000'))
	END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
   gsv_cd.gs_cd5 = 'YES'
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.06.26                                                  */	
/* 수정일      : 2002.06.26                                                  */
/*===========================================================================*/
String     ls_acc_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "acc_cd"				
			IF ai_div = 1 THEN 	
				IF gf_acc_nm(as_data, 'S', ls_acc_nm) = 0 THEN
				   dw_body.SetItem(al_row, "acc_nm", ls_acc_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "계정 코드 검색" 
			gst_cd.datawindow_nm   = "d_com909" 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "acc_code LIKE '" + as_data + "%'"
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
				dw_body.SetItem(al_row, "acc_cd", lds_Source.GetItemString(1,"acc_code"))
				dw_body.SetItem(al_row, "acc_nm", lds_Source.GetItemString(1,"sname"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("draft_no")
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56104_s","0")
end event

event ue_insert();

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.SETITEM(il_rows, "REMARK",  gsv_cd.gs_cd6 )	
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_56104_s
integer x = 2528
end type

type cb_delete from w_com010_e`cb_delete within w_56104_s
end type

type cb_insert from w_com010_e`cb_insert within w_56104_s
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56104_s
boolean visible = false
integer x = 1893
end type

type cb_update from w_com010_e`cb_update within w_56104_s
end type

type cb_print from w_com010_e`cb_print within w_56104_s
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56104_s
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56104_s
integer width = 2889
end type

type cb_excel from w_com010_e`cb_excel within w_56104_s
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_56104_s
integer y = 180
integer width = 2469
integer height = 132
string dataobject = "d_56104_h10"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')


end event

type ln_1 from w_com010_e`ln_1 within w_56104_s
integer beginy = 320
integer endx = 2885
integer endy = 320
end type

type ln_2 from w_com010_e`ln_2 within w_56104_s
integer beginy = 324
integer endx = 2885
integer endy = 324
end type

type dw_body from w_com010_e`dw_body within w_56104_s
integer y = 344
integer width = 2889
integer height = 1080
string dataobject = "d_56104_d10"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("deposit_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('501')

This.GetChild("bank_cd", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('921')


end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.06.26                                                  */	
/* 수정일      : 2002.06.26                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "issue_ymd" , "full_ymd", "input_ymd"
		IF isnull(data) OR data = "" THEN RETURN 0 
		IF GF_DATECHK(DATA) = FALSE THEN RETURN 1
	CASE "acc_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_56104_s
end type

