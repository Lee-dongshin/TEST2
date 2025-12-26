$PBExportHeader$w_74001_e.srw
$PBExportComments$고객신상정보관리
forward
global type w_74001_e from w_com010_e
end type
type dw_3 from datawindow within w_74001_e
end type
type dw_4 from datawindow within w_74001_e
end type
type tab_1 from tab within w_74001_e
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tabpage_6 from userobject within tab_1
end type
type tabpage_6 from userobject within tab_1
end type
type tab_1 from tab within w_74001_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type
type dw_6 from datawindow within w_74001_e
end type
type dw_2 from datawindow within w_74001_e
end type
type dw_1 from datawindow within w_74001_e
end type
end forward

global type w_74001_e from w_com010_e
integer height = 2248
dw_3 dw_3
dw_4 dw_4
tab_1 tab_1
dw_6 dw_6
dw_2 dw_2
dw_1 dw_1
end type
global w_74001_e w_74001_e

type variables
String is_jumin , is_coupon_no

end variables

on w_74001_e.create
int iCurrent
call super::create
this.dw_3=create dw_3
this.dw_4=create dw_4
this.tab_1=create tab_1
this.dw_6=create dw_6
this.dw_2=create dw_2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_3
this.Control[iCurrent+2]=this.dw_4
this.Control[iCurrent+3]=this.tab_1
this.Control[iCurrent+4]=this.dw_6
this.Control[iCurrent+5]=this.dw_2
this.Control[iCurrent+6]=this.dw_1
end on

on w_74001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.tab_1)
destroy(this.dw_6)
destroy(this.dw_2)
destroy(this.dw_1)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_1,  "ScaleToRight&Bottom")
inv_resize.of_Register(dw_2,  "ScaleToRight&Bottom")
inv_resize.of_Register(dw_3,  "ScaleToRight&Bottom")
inv_resize.of_Register(dw_4,  "ScaleToRight&Bottom")
inv_resize.of_Register(dw_6,  "ScaleToRight&Bottom")

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
dw_6.SetTransObject(SQLCA)

dw_body.insertRow(0)



end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.04.06(김태범)                                          */
/*===========================================================================*/
String     ls_jumin, ls_user_name, ls_card_no
String     ls_shop_nm, ls_zipcode, ls_addr, ls_area_cd  
Boolean    lb_check 
DataStore  lds_Source



CHOOSE CASE as_column
	CASE "jumin"						
			IF ai_div = 1 THEN 	
				IF gf_cust_jumin_chk_w(as_data, ls_user_name, ls_card_no) = TRUE THEN
				   dw_head.SetItem(al_row, "user_name", ls_user_name)
				   dw_head.SetItem(al_row, "card_no", RightA(ls_card_no,9))
					RETURN 0
				ELSEIF LenA(Trim(as_data)) = 13 THEN
					IF gf_jumin_chk(as_data) THEN 
				      dw_head.SetItem(al_row, "user_name", "")
				      dw_head.SetItem(al_row, "card_no", "")
					   Return 0
					ELSE
						//MessageBox("오류", "주민번호가 잘못되여 있습니다!")
						Return 0 
					END IF
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com740" 
			gst_cd.default_where   = ""
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where   = " jumin LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "jumin",     lds_Source.GetItemString(1,"jumin"))
				dw_head.SetItem(al_row, "user_name", lds_Source.GetItemString(1,"user_name"))
				dw_head.SetItem(al_row, "card_no",   RightA(lds_Source.GetItemString(1,"card_no"),9))
				IF ai_div = 2 THEN 	
				   cb_retrieve.PostEvent(clicked!)
				END IF 
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "card_no"
			IF ai_div = 1 THEN 	
				IF gf_cust_card_chk_w('1128003'+ as_data, ls_jumin, ls_user_name) = TRUE THEN
				   dw_head.SetItem(al_row, "user_name", ls_user_name)
				   dw_head.SetItem(al_row, "card_no",   RightA(Trim(as_data),9))			
				   dw_head.SetItem(al_row, "jumin",     ls_jumin)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com740" 
			gst_cd.default_where   = ""
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where   = " card_no LIKE '" + '1128003'+as_data + "%'"
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
				dw_head.SetItem(al_row, "jumin",     lds_Source.GetItemString(1,"jumin"))
				dw_head.SetItem(al_row, "user_name", lds_Source.GetItemString(1,"user_name"))
				dw_head.SetItem(al_row, "card_no",   RightA(lds_Source.GetItemString(1,"card_no"),9))
				IF ai_div = 2 THEN 	
				   cb_retrieve.PostEvent(clicked!)
				END IF 
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "user_name"				
			if isnull(as_data) or as_data = '' then return 0
			IF ai_div = 1 THEN
				IF gf_cust_name_chk_w(as_data, ls_user_name, ls_jumin, ls_card_no) = TRUE THEN
				   dw_head.SetItem(al_row, "jumin", ls_jumin)
				   dw_head.SetItem(al_row, "card_no", RightA(ls_card_no,9))
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 검색" 
			gst_cd.datawindow_nm   = "d_com740" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where   = " user_name = '" + as_data + "'"
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
				dw_head.SetItem(al_row, "jumin",     lds_Source.GetItemString(1,"jumin"))
				dw_head.SetItem(al_row, "user_name", lds_Source.GetItemString(1,"user_name"))
				dw_head.SetItem(al_row, "card_no",   RightA(lds_Source.GetItemString(1,"card_no"),9))
				IF ai_div = 2 THEN 	
				   cb_retrieve.PostEvent(clicked!)
				END IF 
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or trim(as_data) = "" THEN
					RETURN 0
				END IF
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_body.SetItem(al_row, "shop_nm", ls_shop_nm)
					IF gf_area_cd(as_data,ls_area_cd) = True THEN
					   dw_body.SetItem(al_row, "area", ls_area_cd)
					END IF
					ib_changed = true
					cb_update.enabled = true
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND Shop_div  in ('G', 'K') "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_body.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				
				IF gf_area_cd(lds_Source.GetItemString(1,"shop_cd"),ls_area_cd) = TRUE THEN
				   dw_body.SetItem(al_row, "area", ls_area_cd)
				END IF
				
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
				cb_update.enabled = true
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source		
	CASE "zipcode"				
			IF ai_div = 1 THEN 	
				IF gf_zipcode_chk(as_data, ls_zipcode, ls_addr) = True THEN
				   dw_body.SetItem(al_row, "zipcode", ls_zipcode)
				   dw_body.SetItem(al_row, "addr", ls_addr)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "우편번호 검색" 
			gst_cd.datawindow_nm   = "d_com916" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "ZIPCODE1 LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "zipcode", lds_Source.GetItemString(1,"zipcode1"))
				dw_body.SetItem(al_row, "addr",    lds_Source.GetItemString(1,"jiyeok")+" "+lds_Source.GetItemString(1,"gu")+" "+lds_Source.GetItemString(1,"dong"))
				ib_itemchanged = False 
				lb_check = TRUE 
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("addr_s")
				ib_changed = true
				cb_update.enabled = true
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source					
	CASE "zipcode2"				
			IF ai_div = 1 THEN 	
				IF gf_zipcode_chk(as_data, ls_zipcode, ls_addr) = True THEN
				   dw_body.SetItem(al_row, "zipcode2", ls_zipcode)
				   dw_body.SetItem(al_row, "addr2", ls_addr)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "우편번호 검색" 
			gst_cd.datawindow_nm   = "d_com916" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "ZIPCODE1 LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "zipcode2", lds_Source.GetItemString(1,"zipcode1"))
				dw_body.SetItem(al_row, "addr2",    lds_Source.GetItemString(1,"jiyeok")+" "+lds_Source.GetItemString(1,"gu")+" "+lds_Source.GetItemString(1,"dong"))
				ib_itemchanged = False 
				lb_check = TRUE 
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("addr2_s")
				ib_changed = true
				cb_update.enabled = true
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
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2001.02.18                                                  */
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

is_jumin = dw_head.GetItemString(1, "jumin")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일) 												  */	
/* 작성일      : 2002.02.16																  */	
/* 수정일      : 2002.04.06(김 태범)													  */
/*===========================================================================*/
String   ls_birthday
datetime ld_datetime

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_jumin)
IF il_rows > 0 THEN
	dw_1.retrieve(is_jumin)
	dw_2.retrieve(is_jumin)
	dw_3.retrieve(is_jumin)
	dw_4.retrieve(is_jumin)
	dw_6.retrieve(is_jumin)	
	IF isnull(dw_body.GetItemString(il_rows,'birthday')) OR Trim(dw_body.GetItemString(il_rows,'birthday')) = "" THEN
      /* 생년월일 기본값 처리  */
		IF MidA(is_jumin,7,1) > '2' THEN
			ls_birthday = '20'+MidA(is_jumin,1,6)
		ELSE
			ls_birthday = '19'+MidA(is_jumin,1,6)
		END IF
		dw_body.SetItem(il_rows,'birthday',ls_birthday)
		dw_body.SetItem(il_rows,'bday',1)
	END IF
	dw_body.SetColumn("birthday")
   dw_body.SetFocus()
ELSE
	dw_1.Reset()
	dw_2.Reset()
	dw_3.Reset()
	dw_4.Reset()
	dw_6.Reset()
	il_rows = dw_body.InsertRow(0)
   IF il_rows = 1 THEN	
      /* 생년월일 기본값 처리  */
		dw_body.Setitem(1, "jumin", is_jumin)
		IF MidA(is_jumin,7,1) > '2' THEN
			ls_birthday = '20'+MidA(is_jumin,1,6)
		ELSE
			ls_birthday = '19'+MidA(is_jumin,1,6)
		END IF
		dw_body.SetItem(il_rows,'birthday',ls_birthday)
		dw_body.SetItem(il_rows,'bday',1)
      /* 성별 기본값 처리  */
		IF MidA(is_jumin,7,1) = '1' OR MidA(is_jumin,7,1) = '3' THEN
		   dw_body.Setitem(1, "sex", 0)
		ELSE 
		   dw_body.Setitem(1, "sex", 1)
		END IF
      /* 카드 발급일 기본값 처리  */
		gf_sysdate(ld_datetime)
      dw_body.Setitem(1, "card_day", string(ld_datetime,'yyyymmdd'))
   	dw_body.Enabled = False
      dw_body.SetFocus()
	END IF 
END IF



This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2001.02.18                                                  */
/*===========================================================================*/
long			ll_cur_row
integer ls_ret

ls_ret = MessageBox("삭제", "현재 고객을 삭제합니까?", &
		Exclamation!, OKCancel!, 2)

IF ls_ret = 1 THEN
	dw_body.InsertRow(0)
	dw_body.Enabled = False
	dw_1.Reset()
	dw_2.Reset()
ELSE
	return
END IF

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_body.DeleteRow (ll_cur_row)
dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)


end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일) 												  */	
/* 작성일      : 2002.02.18																  */	
/* 수정일      : 2002.04.06(김 태범)    												  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
String   ls_addr, ls_zipcode

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_zipcode = dw_body.GetitemString(1, "zipcode")
ls_addr    = dw_body.GetitemString(1, "addr")
IF LenA(Trim(ls_addr)) > 0 THEN 
	IF isnull(ls_zipcode) OR LenA(ls_zipcode) < 6 THEN 
		MessageBox("확인", "자택주소 우편번호를 입력 하십시오!")
		Return 0
	END IF
END IF

ls_zipcode = dw_body.GetitemString(1, "zipcode2")
ls_addr    = dw_body.GetitemString(1, "addr2")
IF LenA(Trim(ls_addr)) > 0 THEN 
	IF isnull(ls_zipcode) OR LenA(ls_zipcode) < 6 THEN 
		MessageBox("확인", "직장주소 우편번호를 입력 하십시오!")
		Return 0
	END IF
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN	      /* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
	dw_head.Reset()
	dw_head.insertRow(0)
	This.Post Event ue_head()
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_74001_e","0")
end event

type cb_close from w_com010_e`cb_close within w_74001_e
end type

type cb_delete from w_com010_e`cb_delete within w_74001_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_74001_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_74001_e
end type

type cb_update from w_com010_e`cb_update within w_74001_e
end type

type cb_print from w_com010_e`cb_print within w_74001_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_74001_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_74001_e
end type

type cb_excel from w_com010_e`cb_excel within w_74001_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_74001_e
event ue_chk_coupon ( string as_coupon )
integer y = 168
integer height = 124
string dataobject = "d_74001_h01"
end type

event dw_head::ue_chk_coupon(string as_coupon);//	string ls_jumin, ls_card_no
//	
//	select distinct jumin, card_no
//		into :ls_jumin, :ls_card_no		
//	from tb_71011_h (nolock) 
//	where coupon_no = :as_coupon;  
//
//	this.setitem(1,"jumin",ls_jumin)
//	this.setitem(1,"card_no",right(ls_card_no,9))
//	
//	parent.post event ue_retrieve()
//	
//	
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.04.06(ktb)                                             */
/*===========================================================================*/
Long li_ret

CHOOSE CASE dwo.name
		CASE "jumin","user_name","card_no"
			IF ib_itemchanged THEN RETURN 1
			IF Trim(Data) = "" THEN RETURN 0
			li_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1) 
			IF li_ret = 0 OR li_ret = 2 THEN 
				cb_retrieve.PostEvent(clicked!)
			END IF
			return li_ret
//		CASE "coupon_no"
//			Trigger Event ue_chk_coupon(data)
			
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_74001_e
integer beginy = 316
integer endy = 316
end type

type ln_2 from w_com010_e`ln_2 within w_74001_e
integer beginy = 320
integer endy = 320
end type

type dw_body from w_com010_e`dw_body within w_74001_e
integer x = 32
integer y = 444
integer width = 3552
integer height = 1608
string dataobject = "d_74001_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("area", ldw_child)
ldw_child.SetTRansObject(SQLCA)
ldw_child.Retrieve('090')

This.GetChild("job", ldw_child)
ldw_child.SetTRansObject(SQLCA)
ldw_child.Retrieve('701')


end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.04.06 (김 태범)                                        */
/*===========================================================================*/
String ls_null, ls_card_no, ls_user_id
long ll_cnt, ll_cnt_id
Setnull(ls_null)

ls_card_no = dw_body.GetItemString(1,"card_no")
ls_user_id = dw_body.GetItemString(1,"user_id")

SELECT count(card_no) 
  INTO :ll_cnt 
  FROM TB_71010_M 
 WHERE card_no = :ls_card_no;
SELECT count(user_id) 
  INTO :ll_cnt_id 
  FROM TB_71010_M 
 WHERE user_id = :ls_user_id;

CHOOSE CASE dwo.name
	CASE "shop_cd"
      IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "card_no2"
		IF isnull(data) or trim(data)="" THEN
			this.SetItem(row,'card_no',ls_null)
		ELSEIF match(data, "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][12]") = FALSE THEN
			MessageBox("오류", "카드번호 오류 !")
			Return 1
		ELSEIF ll_cnt > 0 THEN 
		MessageBox("확인", "이미 등록된 카드번호 입니다 !")
		RETURN 1
		ELSE
			this.SetItem(row,'card_no',"1128003"+data)
		END IF
	CASE "user_id"
		IF LenA(data) < 6 THEN
			MessageBox("확인", "아이디는 6자리 이상입니다. !")
			RETURN 1
		ELSEIF ll_cnt_id > 0 THEN
			MessageBox("확인", "이미 등록된 아이디 입니다 !")
			RETURN 1
		ELSE
			this.SetItem(row,'user_id',data)
		END IF
	CASE "passwd"
		IF LenA(data) < 6 THEN
			MessageBox("확인", "패스워드는 6자리 이상입니다. !")
			RETURN 1
		ELSE
			this.SetItem(row,'passwd',data)
		END IF
END CHOOSE

end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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

type dw_print from w_com010_e`dw_print within w_74001_e
integer x = 2167
integer y = 964
end type

type dw_3 from datawindow within w_74001_e
integer x = 32
integer y = 444
integer width = 3552
integer height = 1616
integer taborder = 20
string title = "none"
string dataobject = "d_71001_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_4 from datawindow within w_74001_e
integer x = 18
integer y = 436
integer width = 3552
integer height = 1592
integer taborder = 20
string title = "none"
string dataobject = "d_71001_d05"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tab_1 from tab within w_74001_e
integer x = 14
integer y = 328
integer width = 3589
integer height = 1724
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
end on

event selectionchanged;
CHOOSE CASE newindex 
	CASE 1 
		dw_body.visible = True
		dw_1.visible    = False
		dw_2.visible    = False
		dw_3.visible    = False
		dw_4.visible    = False
		dw_6.visible    = False		
	CASE 2
		dw_body.visible = False
		dw_1.visible    = True
		dw_2.visible    = False
		dw_3.visible    = False
		dw_4.visible    = False
		dw_6.visible    = False		
	CASE 3
		dw_body.visible = False
		dw_1.visible    = False
		dw_2.visible    = False
		dw_4.visible    = False
		dw_3.visible    = True 
		dw_6.visible    = False		
		
	CASE 4
		dw_body.visible = False
		dw_1.visible    = False
		dw_2.visible    = False
		dw_3.visible    = False
		dw_4.visible    = True 
		dw_6.visible    = False		
	CASE 5
		dw_body.visible = False
		dw_1.visible    = False
		dw_2.visible    = False
		dw_3.visible    = False		
		dw_4.visible    = False
		dw_6.visible    = True 

END CHOOSE 
	
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1612
long backcolor = 79741120
string text = "신상정보"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1612
long backcolor = 79741120
string text = "구매이력"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1612
long backcolor = 79741120
string text = "A/S처리"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1612
long backcolor = 79741120
string text = "카드재발급"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 1612
long backcolor = 79741120
string text = "기타사항"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type dw_6 from datawindow within w_74001_e
event ue_body_cync ( )
boolean visible = false
integer x = 27
integer y = 440
integer width = 3552
integer height = 1616
integer taborder = 50
string title = "none"
string dataobject = "d_71001_d06"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_body_cync();string ls_familly_stat, ls_buy_stat, ls_body_stat
ls_familly_stat = this.getitemstring(1,"familly_stat")
ls_buy_stat    = this.getitemstring(1,"buy_stat")
ls_body_stat   = this.getitemstring(1,"body_stat")

dw_body.setitem(1,"familly_stat", ls_familly_stat)
dw_body.setitem(1,"buy_stat", ls_buy_stat)
dw_body.setitem(1,"body_stat", ls_body_stat)



end event

event editchanged;
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false

IF dw_6.AcceptText() <> 1 THEN RETURN -1
end event

event itemchanged;post event ue_body_cync()
end event

type dw_2 from datawindow within w_74001_e
boolean visible = false
integer x = 27
integer y = 440
integer width = 3552
integer height = 1616
integer taborder = 40
string title = "none"
string dataobject = "d_71001_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_74001_e
boolean visible = false
integer x = 27
integer y = 436
integer width = 3552
integer height = 1616
integer taborder = 30
string title = "none"
string dataobject = "d_74001_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_child 

This.GetChild("sale_type", ldw_child)
ldw_child.SetTRansObject(SQLCA)
ldw_child.Retrieve('011')

end event

