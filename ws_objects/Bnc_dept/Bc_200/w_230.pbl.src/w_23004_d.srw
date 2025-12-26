$PBExportHeader$w_23004_d.srw
$PBExportComments$거래처별 클레임현황
forward
global type w_23004_d from w_com020_d
end type
type p_1 from picture within w_23004_d
end type
end forward

global type w_23004_d from w_com020_d
p_1 p_1
end type
global w_23004_d w_23004_d

type variables
string is_brand, is_fr_yymmdd, is_to_yymmdd, is_cust_cd, is_claim_ymd, is_claim_no, is_claim_cust, is_claim_gubn, is_bill_yn

datawindowchild	idw_brand, idw_claim_gubn
end variables

on w_23004_d.create
int iCurrent
call super::create
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
end on

on w_23004_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_1)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_23004_d","0")
end event

event open;call super::open;datetime ld_datetime


IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))

end if

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))

end if
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm , ls_brand
Boolean    lb_check 
DataStore  lds_Source

ls_brand = dw_head.getitemstring(1,"brand")


CHOOSE CASE as_column
	CASE "cust_cd"				
			IF ai_div = 1 THEN 	
				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "업체 코드 검색" 
			gst_cd.datawindow_nm   = "d_22100_dw1" 
			gst_cd.default_where   = "WHERE cust_code between '4999' and '8999' " + &
												"and   brand in ('n','o') " + &
												"and   change_gubn = '00' " + &
												"and   custcode like '_0%' "

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(custcode LIKE '" + as_data + "%' or cust_sname like '%" + as_data + "%')"
//				gst_cd.Item_where = "custcode LIKE '" + as_data + "%'" // or cust_sname like '%" + as_data + "%')"
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
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("end_ymd")
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


is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_cust_cd   = dw_head.GetItemString(1, "cust_cd")
is_claim_gubn   = dw_head.GetItemString(1, "claim_gubn")
is_bill_yn = dw_head.GetItemString(1, "bill_yn")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_cust_cd, is_claim_gubn, is_bill_yn)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

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

/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)													  */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(st_1, "ScaleToBottom")
inv_resize.of_Register(p_1, "FixedToRight&Bottom")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

il_rows = dw_print.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_cust_cd, is_claim_ymd, is_claim_no, is_claim_gubn, is_bill_yn)

dw_print.Object.DataWindow.Print.Orientation = 1

dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)


dw_print.object.t_brand.text = is_brand + ' ' + idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")

dw_print.object.t_fr_yymmdd.text = is_fr_yymmdd
dw_print.object.t_to_yymmdd.text = is_to_yymmdd
dw_print.object.t_cust_cd.text = is_cust_cd + ' ' + dw_head.getitemstring(1,"cust_nm")

//dw_print.object.dw_2.object.t_claim_cust.text = is_claim_cust
dw_print.object.t_claim_gubn.text = '구분:'+idw_claim_gubn.getitemstring(idw_claim_gubn.getrow(),"inter_nm")

if is_bill_yn = '1' then 	
	dw_print.object.t_bill_yn.text = '계산서구분: 발행'
elseif is_bill_yn = '0' then 	
	dw_print.object.t_bill_yn.text = '계산서구분: 미발행'
else
	dw_print.object.t_bill_yn.text = '계산서구분: 전체'
end if




end event

event ue_print();trigger event ue_preview()
end event

type cb_close from w_com020_d`cb_close within w_23004_d
end type

type cb_delete from w_com020_d`cb_delete within w_23004_d
end type

type cb_insert from w_com020_d`cb_insert within w_23004_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_23004_d
end type

type cb_update from w_com020_d`cb_update within w_23004_d
end type

type cb_print from w_com020_d`cb_print within w_23004_d
end type

type cb_preview from w_com020_d`cb_preview within w_23004_d
end type

type gb_button from w_com020_d`gb_button within w_23004_d
end type

type cb_excel from w_com020_d`cb_excel within w_23004_d
end type

type dw_head from w_com020_d`dw_head within w_23004_d
integer y = 160
integer width = 4242
integer height = 196
string dataobject = "d_23004_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("claim_gubn", idw_claim_gubn)
idw_claim_gubn.SetTransObject(SQLCA)
idw_claim_gubn.Retrieve('211')
idw_claim_gubn.InsertRow(1)
idw_claim_gubn.SetItem(1, "inter_cd", '%')
idw_claim_gubn.SetItem(1, "inter_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name

	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_d`ln_1 within w_23004_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com020_d`ln_2 within w_23004_d
integer beginy = 388
integer endy = 388
end type

type dw_list from w_com020_d`dw_list within w_23004_d
integer y = 400
integer width = 3570
integer height = 1204
string dataobject = "d_23004_d01"
boolean hscrollbar = true
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_pic_nm, ls_style, ls_chno
IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_claim_ymd = This.GetItemString(row, 'claim_ymd') /* DataWindow에 Key 항목을 가져온다 */
is_claim_no  = This.GetItemString(row, 'claim_no') 
is_claim_cust  = This.GetItemString(row, 'claim_cust') + ' ' + This.GetItemString(row, 'claim_cust_nm')

IF IsNull(is_claim_ymd) THEN return
il_rows = dw_body.retrieve(is_brand, is_claim_ymd, is_claim_no)

if il_rows >0 then
	ls_style = dw_list.getitemstring(row,"style")
	ls_chno = dw_list.getitemstring(row,"chno")
	
	gf_pic_dir('0', ls_style + ls_chno, ls_pic_nm)
	p_1.PictureName = ls_pic_nm
   dw_body.SetFocus()
end if

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_23004_d
integer x = 27
integer y = 1620
integer width = 3570
integer height = 424
string dataobject = "d_23004_d02"
end type

type st_1 from w_com020_d`st_1 within w_23004_d
boolean visible = false
integer y = 368
integer height = 1676
end type

type dw_print from w_com020_d`dw_print within w_23004_d
string dataobject = "d_23004_r00"
end type

type p_1 from picture within w_23004_d
integer x = 2496
integer y = 932
integer width = 1088
integer height = 1104
boolean bringtotop = true
boolean focusrectangle = false
end type

