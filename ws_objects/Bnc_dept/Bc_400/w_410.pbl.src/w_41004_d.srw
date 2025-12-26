$PBExportHeader$w_41004_d.srw
$PBExportComments$생산입고명세서
forward
global type w_41004_d from w_com020_d
end type
type dw_list1 from u_dw within w_41004_d
end type
end forward

global type w_41004_d from w_com020_d
string title = "생산입고명세서"
dw_list1 dw_list1
end type
global w_41004_d w_41004_d

type variables
DataWindowChild idw_brand 
string is_brand, is_yymmdd, is_cust_cd

end variables

on w_41004_d.create
int iCurrent
call super::create
this.dw_list1=create dw_list1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list1
end on

on w_41004_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list1)
end on

event pfc_preopen;call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)													  */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list1, "ScaleToright")
inv_resize.of_Register(dw_list, "ScaleToBottom")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(st_1, "ScaleToBottom")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_list1.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)




end event

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "yymmdd", string(ld_datetime,"yyyymmdd"))


end event

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm , ls_message
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
		CASE "cust_cd"							// 거래처 코드
		
//			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
//				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
//					MessageBox("입력오류","등록되지 않은 거래처 코드입니다!")
//					RETURN 1
//				END IF
//			   If Right(as_data, 4) < '5000' or Right(as_data, 4) > '6999' Then
//					MessageBox("입력오류","생산처 코드가 아닙니다!")
//					RETURN 1
//				End If					
//				dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
//			ELSE		
// F1 key Or PopUp Button Click -> Call
			IF ai_div = 1 THEN 	
				if isnull(as_data) or trim(as_data) = "" then
					RETURN 0
				end if	
				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
				gst_cd.window_title    = "생산처 코드 검색" 
				gst_cd.datawindow_nm   = "d_com911" 
				gst_cd.default_where   = " WHERE Cust_Code Between '5000' And '6999' "
				IF Trim(as_data) <> "" THEN
					ls_message = " CustCode LIKE ~'" + as_data + "%~'  or cust_sname like ~'" + as_data + "%~' "
					messagebox("", ls_message)
					
					gst_cd.Item_where = "( CustCode LIKE ~'" + as_data + "%~'  or cust_sname like ~'" + as_data + "%~' )"
				ELSE
					gst_cd.Item_where = ""
				END IF

				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm
					dw_head.SetRow(al_row)
					dw_head.SetColumn(as_column)
					dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"CustCode"))
					dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"Cust_Name"))
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("cust_cd")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
//			END IF
	
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


is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"입고기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if


is_cust_cd = dw_head.GetItemString(1, "cust_cd")
if IsNull(is_cust_cd) or Trim(is_cust_cd) = "" then
  is_cust_cd = "%"  
end if


return true

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list1.retrieve(is_brand, is_yymmdd, is_cust_cd)
dw_list.reset()

IF il_rows > 0 THEN
   dw_list1.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_41004_d","0")
end event

type cb_close from w_com020_d`cb_close within w_41004_d
integer taborder = 120
end type

type cb_delete from w_com020_d`cb_delete within w_41004_d
integer taborder = 70
end type

type cb_insert from w_com020_d`cb_insert within w_41004_d
integer taborder = 60
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_41004_d
end type

type cb_update from w_com020_d`cb_update within w_41004_d
integer taborder = 110
end type

type cb_print from w_com020_d`cb_print within w_41004_d
integer taborder = 80
end type

type cb_preview from w_com020_d`cb_preview within w_41004_d
integer taborder = 90
end type

type gb_button from w_com020_d`gb_button within w_41004_d
end type

type cb_excel from w_com020_d`cb_excel within w_41004_d
integer taborder = 100
end type

type dw_head from w_com020_d`dw_head within w_41004_d
integer x = 32
integer y = 164
integer height = 216
string dataobject = "d_41004_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if
end event

event dw_head::itemchanged;call super::itemchanged;
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
//	CASE "style" 
//      IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
   
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
		
END CHOOSE

end event

type ln_1 from w_com020_d`ln_1 within w_41004_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com020_d`ln_2 within w_41004_d
integer beginy = 388
integer endy = 388
end type

type dw_list from w_com020_d`dw_list within w_41004_d
integer y = 996
integer width = 2619
integer height = 1032
string dataobject = "d_41004_d02"
end type

event dw_list::doubleclicked;///*===========================================================================*/
///* 작성자      :                                                       */	
///* 작성일      : 2001..                                                  */	
///* 수정일      : 2001..                                                  */
///*===========================================================================*/
//
//IF row <= 0 THEN Return
//
//This.SelectRow(0, FALSE)
//This.SelectRow(row, TRUE)
//
//is_key_value = This.GetItemString(row, 'key_column') /* DataWindow에 Key 항목을 가져온다 */
//
//IF IsNull(is_key_value) THEN return
//il_rows = dw_body.retrieve(is_key_value)
//Parent.Trigger Event ue_button(7, il_rows)
//Parent.Trigger Event ue_msg(1, il_rows)


/*===========================================================================*/
/* 작성자      :                                         */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
string ls_style, ls_in_no, ls_cust_cd, ls_chno, ls_color


ls_in_no = this.getitemstring(row, "in_no")
ls_style = this.getitemstring(row, "style")
ls_chno = this.getitemstring(row, "chno")
ls_color = LeftA(this.Getitemstring(row, "color"),2)


il_rows = dw_body.retrieve(is_brand, is_yymmdd, ls_in_no, is_cust_cd, ls_style, ls_chno, ls_color)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

this.selectRow(0, false);
this.setRow(row);
this.selectRow(row, true);
end event

type dw_body from w_com020_d`dw_body within w_41004_d
integer x = 2665
integer y = 996
integer width = 928
integer height = 1036
string dataobject = "d_41004_d03"
end type

type st_1 from w_com020_d`st_1 within w_41004_d
integer x = 2647
integer y = 992
integer height = 1036
end type

type dw_print from w_com020_d`dw_print within w_41004_d
integer x = 1266
integer y = 1576
end type

type dw_list1 from u_dw within w_41004_d
integer x = 23
integer y = 400
integer width = 3570
integer height = 584
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_41004_d01"
end type

event doubleclicked;
/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/


is_cust_cd = this.getitemstring(row, "cust_cd")

il_rows = dw_list.retrieve(is_brand, is_yymmdd, is_cust_cd)
dw_body.reset()
IF il_rows > 0 THEN
   dw_list1.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

this.selectRow(0, false);
this.setRow(row);
this.selectRow(row, true);
end event

