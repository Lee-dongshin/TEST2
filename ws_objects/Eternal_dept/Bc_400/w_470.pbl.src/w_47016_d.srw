$PBExportHeader$w_47016_d.srw
$PBExportComments$직영몰결재별입금현황
forward
global type w_47016_d from w_com010_d
end type
type dw_1 from datawindow within w_47016_d
end type
end forward

global type w_47016_d from w_com010_d
integer width = 3680
dw_1 dw_1
end type
global w_47016_d w_47016_d

type variables
DataWindowChild idw_shop_cd
string is_fr_ymd, is_to_ymd, is_brand, is_style, is_chno, is_gubn, is_order_stat, is_stat, is_fr_yymm, is_to_yymm, is_yymm, is_pay_gubn
end variables

on w_47016_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_47016_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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
 
is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"정산월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_pay_gubn = dw_head.GetItemString(1, "pay_gubn")
if IsNull(is_pay_gubn) or Trim(is_pay_gubn) = "" then
//   MessageBox(ls_title,"정산월을 입력하십시요!")
	is_pay_gubn = '%'
end if

/*
is_fr_yymm = dw_head.GetItemString(1, "fr_yymm")
if IsNull(is_fr_yymm) or Trim(is_fr_yymm) = "" then
   MessageBox(ls_title,"시작월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymm")
   return false
end if

is_to_yymm = dw_head.GetItemString(1, "to_yymm")
if IsNull(is_to_yymm) or Trim(is_to_yymm) = "" then
   MessageBox(ls_title,"마지막월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
	is_style = "%"
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
	is_chno = "%"
end if

is_gubn = dw_head.GetItemString(1, "gubn")
if IsNull(is_gubn) or Trim(is_gubn) = "" then
	is_gubn = "%"
end if

is_order_stat = dw_head.GetItemString(1, "order_stat")
if IsNull(is_order_stat) or Trim(is_order_stat) = "" then
	is_order_stat = "%"
end if

is_stat = dw_head.GetItemString(1, "stat")
if IsNull(is_stat) or Trim(is_stat) = "" then
	is_stat = "%"
end if
*/
return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_1.retrieve(is_yymm, is_pay_gubn )

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

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				  "t_fr_ymd.Text = '" + is_fr_ymd + "'" + &				 
				  "t_to_ymd.Text = '" + is_to_ymd + "'"

dw_print.Modify(ls_modify)


end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
Long       ll_row_cnt 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column

	CASE "style"				
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "chno", "")
					RETURN 0
				END IF 
				IF gf_style_chk(as_data, '%') = True THEN
				   dw_head.SetItem(al_row, "chno", "")
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "STYLE 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "WHERE 1 = 1 "
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
				dw_head.SetItem(al_row, "chno",  lds_Source.GetItemString(1,"chno"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("chno")
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_47015_d","0")
end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* Data window Resize */
inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_1, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

event open;call super::open;string ls_yymm

select convert(varchar(6), dateadd(mm,-1,getdate()),112)
  into :ls_yymm
  from dual;

dw_head.setitem(1,'yymm',ls_yymm)


dw_head.setitem(1,'pay_gubn','%')

end event

type cb_close from w_com010_d`cb_close within w_47016_d
end type

type cb_delete from w_com010_d`cb_delete within w_47016_d
end type

type cb_insert from w_com010_d`cb_insert within w_47016_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_47016_d
end type

type cb_update from w_com010_d`cb_update within w_47016_d
end type

type cb_print from w_com010_d`cb_print within w_47016_d
end type

type cb_preview from w_com010_d`cb_preview within w_47016_d
end type

type gb_button from w_com010_d`gb_button within w_47016_d
end type

type cb_excel from w_com010_d`cb_excel within w_47016_d
end type

type dw_head from w_com010_d`dw_head within w_47016_d
integer x = 5
integer y = 160
integer width = 4114
integer height = 192
string dataobject = "d_47016_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("shop_cd", idw_shop_cd)
idw_shop_cd.SetTransObject(SQLCA)
idw_shop_cd.Retrieve()
idw_shop_cd.InsertRow(1)
idw_shop_cd.SetItem(1, "cust_nm", '전체')
idw_shop_cd.SetItem(1, "shop_cd", '%')
//idw_shop_cd.SetItem(1, "b_shop_stat", '00')

DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001') 
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '%')
ldw_child.SetItem(1, "inter_nm", '전체')



// 해당 브랜드 선별작업 
/*
String   ls_filter_str = ''	

	ls_filter_str = "b_shop_stat = '00'" 
	idw_shop_cd.SetFilter(ls_filter_str)
	idw_shop_cd.Filter( )
*/
end event

event dw_head::itemchanged;call super::itemchanged;String ls_yymmdd

CHOOSE CASE dwo.name

	CASE "style"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_47016_d
integer beginy = 360
integer endy = 360
end type

type ln_2 from w_com010_d`ln_2 within w_47016_d
integer beginy = 364
integer endy = 364
end type

type dw_body from w_com010_d`dw_body within w_47016_d
integer y = 1776
integer height = 220
string dataobject = "d_47016_d02"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_47016_d
string dataobject = "d_47007_r01"
end type

type dw_1 from datawindow within w_47016_d
integer x = 5
integer y = 376
integer width = 3589
integer height = 1388
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_47016_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.06                                                  */	
/* 수정일      : 2002.02.06                                                  */
/*===========================================================================*/
long ll_rows
string ls_yymm, ls_pay_gubn, ls_stat, ls_gubn


IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_yymm = This.GetItemString(row, 'yymm') /* DataWindow에 Key 항목을 가져온다 */
ls_pay_gubn = This.GetItemString(row, 'pay_gubn') /* DataWindow에 Key 항목을 가져온다 */
ls_stat = This.GetItemString(row, 'stat') /* DataWindow에 Key 항목을 가져온다 */
ls_gubn = This.GetItemString(row, 'gubn') /* DataWindow에 Key 항목을 가져온다 */




IF IsNull(ls_yymm) THEN return

dw_body.retrieve(ls_yymm, ls_pay_gubn, ls_stat, ls_gubn)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

