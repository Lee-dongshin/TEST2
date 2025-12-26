$PBExportHeader$w_91011_e.srw
$PBExportComments$거래처 등록
forward
global type w_91011_e from w_com030_e
end type
type rb_3 from radiobutton within w_91011_e
end type
type rb_1 from radiobutton within w_91011_e
end type
type rb_2 from radiobutton within w_91011_e
end type
type dw_1 from datawindow within w_91011_e
end type
type gb_1 from groupbox within w_91011_e
end type
end forward

global type w_91011_e from w_com030_e
rb_3 rb_3
rb_1 rb_1
rb_2 rb_2
dw_1 dw_1
gb_1 gb_1
end type
global w_91011_e w_91011_e

type variables
String is_flag, is_brand, is_cust_cd, is_cust_nm 

end variables

forward prototypes
public subroutine wf_body_set (string as_flag)
end prototypes

public subroutine wf_body_set (string as_flag);
dw_body.Object.cust_emp_t.visible      = False
dw_body.Object.cust_emp.visible        = False
dw_body.Object.cust_emp_note_t.visible = False
dw_body.Object.cust_emp_note.visible   = False
dw_body.Object.main_item_t.visible     = False
dw_body.Object.main_item.visible       = False
dw_body.Object.make_item_t.visible     = False
dw_body.Object.make_item.visible       = False
dw_body.Object.mis_qty_t.visible       = False
dw_body.Object.mis_qty.visible         = False
dw_body.Object.cust_panme_t.visible    = False
dw_body.Object.cust_panme.visible      = False
dw_body.Object.comm_gubn_t.visible     = False
dw_body.Object.comm_gubn.visible       = False
dw_body.Object.cust_type_t.visible     = False
dw_body.Object.cust_type.visible       = False
dw_body.Object.nt_yn_t.visible         = False
dw_body.Object.nt_yn.visible           = False
dw_body.Object.shop_gubn_t.visible     = False
dw_body.Object.shop_gubn.visible       = False
dw_body.Object.empno_t.visible         = False
dw_body.Object.empno.visible           = False
dw_body.Object.emp_nm.visible          = False
dw_body.Object.shop_class_t.visible    = False
dw_body.Object.shop_class.visible      = False

CHOOSE CASE as_flag
	CASE '1'
		dw_body.Object.gb_1.text = '자재/생산 관리내역'
		dw_body.Object.cust_emp_t.visible      = True
		dw_body.Object.cust_emp.visible        = True
		dw_body.Object.cust_emp_note_t.visible = True
		dw_body.Object.cust_emp_note.visible   = True
		dw_body.Object.main_item_t.visible     = True
		dw_body.Object.main_item.visible       = True
		dw_body.Object.make_item_t.visible     = True
		dw_body.Object.make_item.visible       = True
		dw_body.Object.mis_qty_t.visible       = True
		dw_body.Object.mis_qty.visible         = True
	CASE '2'
		dw_body.Object.gb_1.text = '수수료사원 관리내역'
		dw_body.Object.cust_panme_t.visible = True
		dw_body.Object.cust_panme.visible   = True
		dw_body.Object.comm_gubn_t.visible  = True
		dw_body.Object.comm_gubn.visible    = True
	CASE '3'
      dw_body.Object.gb_1.text = '매장 관리내역'
		dw_body.Object.cust_type_t.visible  = True
		dw_body.Object.cust_type.visible    = True
		dw_body.Object.nt_yn_t.visible      = True
		dw_body.Object.nt_yn.visible        = True
		dw_body.Object.shop_gubn_t.visible  = True
		dw_body.Object.shop_gubn.visible    = True
		dw_body.Object.empno_t.visible      = True
		dw_body.Object.empno.visible        = True
      dw_body.Object.emp_nm.visible       = True
		dw_body.Object.shop_class_t.visible = True
		dw_body.Object.shop_class.visible   = True
END CHOOSE


end subroutine

on w_91011_e.create
int iCurrent
call super::create
this.rb_3=create rb_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_1=create dw_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_3
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.gb_1
end on

on w_91011_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;call super::open;is_flag = '1'
wf_body_set(is_flag)
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.02                                                  */	
/* 수정일      : 2002.04.02                                                  */
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

is_cust_cd = dw_head.GetItemString(1, "cust_cd")
if IsNull(is_cust_cd) or Trim(is_cust_cd) = "" then
	is_cust_cd = '%'
end if

is_cust_nm = dw_head.GetItemString(1, "cust_nm")
if IsNull(is_cust_nm) or Trim(is_cust_nm) = "" then
	is_cust_nm = '%'
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.02                                                  */	
/* 수정일      : 2002.04.02                                                  */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_flag, is_brand, is_cust_cd, is_cust_nm)
dw_body.Reset()
dw_body.InsertRow(0)
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSE
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;dw_body.insertRow(0)

dw_1.SetTransObject(SQLCA)
dw_1.insertRow(0)
end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
       dw_body.Enabled = false
		 rb_1.Enabled = false
		 rb_2.Enabled = false
		 rb_3.Enabled = false
		 cb_insert.Enabled = True
   CASE 2      /* 추가 */
      if al_rows > 0 then
			dw_body.Enabled = true
		end if

   CASE 5    /* 조건 */
       cb_update.enabled = false
       dw_body.Enabled = false
       rb_1.Enabled = true
       rb_2.Enabled = true
       rb_3.Enabled = true
		 cb_insert.Enabled = False
   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
			dw_body.Enabled = true
		end if
END CHOOSE

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 2002.04.02																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

IF idw_status = NotModified! OR idw_status = DataModified! THEN
	IF MessageBox("확인",'[' + is_cust_cd + '] 정말 삭제하시겠습니까?', Question!, YesNo!) = 2 THEN
		dw_body.SetFocus()
		RETURN
	END IF
END IF

il_rows = dw_body.DeleteRow (ll_cur_row)
il_rows = dw_body.InsertRow (0)

IF dw_body.update() < 1 THEN	RETURN

Commit;

IF idw_status = NotModified! OR idw_status = DataModified! THEN
	ll_cur_row = dw_list.GetSelectedRow(0)
	if ll_cur_row > 0 THEN dw_list.DeleteRow(ll_cur_row)  //dw_list Row 삭제
END IF

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.02                                                  */	
/* 수정일      : 2002.04.02                                                  */
/*===========================================================================*/
long ll_cur_row, ll_cnt
datetime ld_datetime
String   ls_custcode, ls_saup_no

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

	ls_saup_no  = dw_body.GetitemString(1, "saup_no")
	if LenA(ls_saup_no) <> 12 then 
		messagebox("알림!", "사업자번호는 '-' 를 포함 12자리여야 합니다!")
 	   dw_body.SetColumn("saup_no")
		return -1
	end if	


ls_custcode = dw_body.GetitemString(1, "custcode")	

select count(*)
into :ll_cnt
from vi_91102_1 
where cust_code = right(:ls_custcode, 4) 
and saup_no <> :ls_saup_no;

if ll_cnt >= 1 then
		messagebox("알림!", "사업자번호가 다른 거래처코드 뒷 내자리가 동일한 코드가 있습니다! 다른 코드를 사용하세요!")
 	   dw_body.SetColumn("custcode")
		return -1
end if

idw_status = dw_body.GetItemStatus(1, 0, Primary!)
ls_custcode = dw_body.GetitemString(1, "custcode")	
IF idw_status = NewModified! THEN				/* New Record */
   dw_body.Setitem(1, "brand",     LeftA(ls_custcode, 1))
   dw_body.Setitem(1, "cust_code", RightA(ls_custcode, 4))
   dw_body.Setitem(1, "shop_type", MidA(ls_custcode, 2, 1))
   dw_body.Setitem(1, "uid", gs_user_id)
   dw_body.Setitem(1, "idate", String(ld_datetime, "YYYY.MM.DD"))	
ELSEIF idw_status = DataModified! THEN		/* Modify Record */	
   dw_body.Setitem(1, "uid", gs_user_id)
   dw_body.Setitem(1, "idate", String(ld_datetime, "YYYY.MM.DD"))
END IF


integer Net, li_cnt
string ls_pwd	

select isnull(count(person_id),0)
  into :li_cnt
  FROM TB_93010_M (nolock)
  WHERE PERSON_ID = :ls_custcode;
			
if li_cnt < 1 then
	if rb_1.checked = true then
	
		Net = MessageBox('확인', '자재/생산 관련프로그램 업체ID를 자동 생성 하시겠습니까?', Exclamation!, YESNO!, 2)
	
		IF Net = 1 THEN 
			ls_pwd = MidA(ls_custcode,6,1)+MidA(ls_custcode,5,1)+MidA(ls_custcode,4,1)+MidA(ls_custcode,3,1)+MidA(ls_custcode,2,1)+MidA(ls_custcode,1,1)
			dw_1.setitem(1,'person_id'	,	ls_custcode)
			dw_1.setitem(1,'person_nm'	,	dw_body.getitemstring(1,'cust_sname'))
			dw_1.setitem(1,'pass_wd'	,	ls_pwd)
			dw_1.setitem(1,'user_grp'	,	'4')			
			dw_1.setitem(1,'brand'		,	LeftA(ls_custcode, 1))
			dw_1.setitem(1,'status_yn'	,	'Y')
			dw_1.setitem(1,'reg_id'		,	gs_user_id)
			dw_1.setitem(1,'reg_dt'		,	ld_datetime)
			dw_1.setitem(1,'data_level',	'V')					
		END IF
	end if
end if
int il_rows_1

il_rows = dw_body.Update(TRUE, FALSE)
il_rows_1 = dw_1.Update(TRUE, FALSE)
if il_rows = 1 then
   dw_body.ResetUpdate()
	dw_1.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

/* dw_list에 추가되거나 수정된 내용를 반영 */  
IF il_rows = 1 THEN
   IF idw_status = NewModified! THEN
      ll_cur_row = dw_list.GetSelectedRow(0)+1
      dw_list.InsertRow(ll_cur_row)
      dw_list.Setitem(ll_cur_row, "custcode",   dw_body.GetItemString(1, "custcode"))
      dw_list.Setitem(ll_cur_row, "cust_sname", dw_body.GetItemString(1, "cust_sname"))
      dw_list.SelectRow(0, FALSE)
      dw_list.SelectRow(ll_cur_row, TRUE)
      dw_list.SetRow(ll_cur_row)
   ELSEIF idw_status = DataModified! THEN
      ll_cur_row = dw_list.GetSelectedRow(0)
      dw_list.Setitem(ll_cur_row, "custcode",   dw_body.GetItemString(1, "custcode"))
      dw_list.Setitem(ll_cur_row, "cust_sname", dw_body.GetItemString(1, "cust_sname"))
   END IF
END IF

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
/*===========================================================================*/
String     ls_zipcode, ls_addr
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"	, "cust_nm"			
			IF ai_div = 1 and as_data = '' or isnull(as_data) then 
				return 0
//			elseIF ai_div = 1 THEN 	
//				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
//					dw_master.Setitem(al_row, "cust_nm", ls_cust_nm)
//					RETURN 0
//				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 

					gst_cd.default_where   = "Where change_gubn = '00' "      + &
													 "  and cust_code between '5000' and '9999'"


			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_sname like '%" + as_data + "%')"
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
//				dw_head.SetColumn("smat_cd")
				ib_itemchanged = False
				lb_check = TRUE
			END IF
			Destroy  lds_Source

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

		
		
	CASE "cust_zip"				
			IF ai_div = 1 THEN 	
				IF gf_zipcode_chk (as_data, ls_zipcode, ls_addr) = TRUE THEN
				   dw_body.SetItem(al_row, "cust_addr", ls_addr)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "우편 번호 검색" 
			gst_cd.datawindow_nm   = "d_com916" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "zipcode1 LIKE '" + as_data + "%'"
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
				dw_body.SetItem(al_row, "cust_zip",  lds_Source.GetItemString(1,"zipcode1"))
				dw_body.SetItem(al_row, "cust_addr", lds_Source.GetItemString(1,"jiyeok") + ' ' + &
				                                     lds_Source.GetItemString(1,"gu") + ' ' + & 
																 lds_Source.GetItemString(1,"dong"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("cust_addr")
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

type cb_close from w_com030_e`cb_close within w_91011_e
integer taborder = 120
end type

type cb_delete from w_com030_e`cb_delete within w_91011_e
integer taborder = 70
end type

type cb_insert from w_com030_e`cb_insert within w_91011_e
integer taborder = 60
end type

type cb_retrieve from w_com030_e`cb_retrieve within w_91011_e
integer taborder = 30
end type

type cb_update from w_com030_e`cb_update within w_91011_e
integer taborder = 110
end type

type cb_print from w_com030_e`cb_print within w_91011_e
boolean visible = false
integer taborder = 80
end type

type cb_preview from w_com030_e`cb_preview within w_91011_e
boolean visible = false
integer taborder = 90
end type

type gb_button from w_com030_e`gb_button within w_91011_e
end type

type cb_excel from w_com030_e`cb_excel within w_91011_e
boolean visible = false
integer taborder = 100
end type

type dw_head from w_com030_e`dw_head within w_91011_e
integer x = 1166
integer y = 192
integer width = 2437
integer height = 160
integer taborder = 20
string dataobject = "d_91011_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", 'N')
ldw_child.SetItem(1, "inter_nm", 'ON＆ON')

end event

event dw_head::itemchanged;call super::itemchanged;

CHOOSE CASE dwo.name

	CASE "cust_cd" , "cust_nm"
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

END CHOOSE
end event

type ln_1 from w_com030_e`ln_1 within w_91011_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com030_e`ln_2 within w_91011_e
integer beginy = 356
integer endy = 356
end type

type dw_list from w_com030_e`dw_list within w_91011_e
integer x = 0
integer y = 380
integer width = 809
integer height = 1668
integer taborder = 40
string dataobject = "d_91011_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.02                                                  */	
/* 수정일      : 2002.04.02                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			RETURN
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_cust_cd = This.GetItemString(row, 'custcode') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_cust_cd) THEN return
il_rows = dw_body.retrieve(is_cust_cd)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com030_e`dw_body within w_91011_e
integer x = 823
integer y = 380
integer height = 1668
integer taborder = 50
boolean enabled = false
string dataobject = "d_91011_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("nat_code", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('000')

This.GetChild("area_code", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('090')

This.GetChild("amt_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('918')

This.GetChild("vat_way", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('917')

This.GetChild("appv_cond", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('007')

This.GetChild("change_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('913')

This.GetChild("bank", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('921')

This.GetChild("comm_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('919')

This.GetChild("smat_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('006')

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.02                                                  */	
/* 수정일      : 2002.04.02                                                  */
/*===========================================================================*/
Long ll_cnt
string ls_custcode

CHOOSE CASE dwo.name
	CASE "custcode" 
		
		if LenA(Trim(Data)) <> 6 THEN RETURN 1
		
		select count(cust_code)
		  into :ll_cnt
		  from vi_91102_1 
		 where custcode = :data ;
		 
		IF ll_cnt = 1 THEN 
			MessageBox("확인", "이미 등록된 거래처 코드 입니다!")
         RETURN 1
		END IF
		
		ls_custcode = data
		
		select count(*)
		into :ll_cnt
		from vi_91102_1 
		where cust_code = right(:ls_custcode, 4) ;
	
		
		if ll_cnt >= 1 then
				messagebox("알림!", "뒷 네자리가 동일한 코드가 있습니다! 다른 코드를 사용하세요!")
				dw_body.SetColumn("custcode")
				 RETURN 1
		end if		
		
		
		CHOOSE CASE is_flag 
			CASE '1' 
				IF RightA(Data, 4) < '5000' OR RightA(Data, 4) > '8999' THEN 
					MessageBox("입력 오류", "자재/생산 거래처 범위가 아닙니다!")
					RETURN 1
				END IF
			CASE '2' 
				IF RightA(Data, 4) < '4000' OR RightA(Data, 4) > '4999' THEN 
					MessageBox("입력 오류", "수수료 사원 거래처 범위가 아닙니다!")
					RETURN 1
				END IF
			CASE ELSE
				IF RightA(Data, 4) > '3999' THEN 
					MessageBox("입력 오류", "매장 거래처 범위가 아닙니다!")
					RETURN 1
				END IF
		END CHOOSE 
	CASE "saup_no"
		
		IF gf_saup_chk(Data) = FALSE THEN 
			MessageBox("입력 오류", "사업자 번호를 잘못 입력 하였습니다!")
			RETURN 1
		END IF
//	CASE "ownr_idno"
//		IF gf_jumin_chk(Data) = FALSE THEN 
//			MessageBox("입력 오류", "주민번호를 잘못 입력 하였습니다!")
//			RETURN 1
//		END IF
	CASE "bil_date"
		IF LenA(data) > 2 or (data <> '99' and data > '31') THEN Return 1
	CASE "cust_zip"
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "open_date1" 
		This.Setitem(row, "open_date", String(Date(LeftA(Data, 10)), "YYYY.MM.DD"))
	CASE "close_date1"
		This.Setitem(row, "close_date", String(Date(LeftA(Data, 10)), "YYYY.MM.DD"))
	CASE "change_date1"
		This.Setitem(row, "change_date", String(Date(LeftA(Data, 10)), "YYYY.MM.DD"))
END CHOOSE

end event

type st_1 from w_com030_e`st_1 within w_91011_e
integer x = 809
integer y = 380
integer height = 1668
end type

type dw_print from w_com030_e`dw_print within w_91011_e
integer y = 1004
end type

type rb_3 from radiobutton within w_91011_e
event ue_keydown pbm_keydown
integer x = 832
integer y = 224
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "매장"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN 
	Send(Handle(This), 256, 9, long(0,0))
	Return 1 
END IF

end event

event clicked;is_flag = '3' 
This.textcolor = Rgb(0, 0, 255)
rb_1.textcolor = Rgb(0, 0, 0)
rb_2.textcolor = Rgb(0, 0, 0)

wf_body_set(is_flag)


end event

type rb_1 from radiobutton within w_91011_e
event ue_keydown pbm_keydown
integer x = 59
integer y = 224
integer width = 361
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "자재/생산"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN 
	Send(Handle(This), 256, 9, long(0,0))
	Return 1 
END IF

end event

event clicked;is_flag = '1' 
This.textcolor = Rgb(0, 0, 255)
rb_2.textcolor = Rgb(0, 0, 0)
rb_3.textcolor = Rgb(0, 0, 0)

wf_body_set(is_flag)
end event

type rb_2 from radiobutton within w_91011_e
event ue_keydown pbm_keydown
integer x = 430
integer y = 224
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "수수료사원"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN 
	Send(Handle(This), 256, 9, long(0,0))
	Return 1 
END IF

end event

event clicked;is_flag = '2'
This.textcolor = Rgb(0, 0, 255)
rb_1.textcolor = Rgb(0, 0, 0)
rb_3.textcolor = Rgb(0, 0, 0)

wf_body_set(is_flag)
end event

type dw_1 from datawindow within w_91011_e
boolean visible = false
integer x = 1120
integer y = 1716
integer width = 2286
integer height = 840
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_91011_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild  ldw_child, ldw_user_grp, ldw_brand


This.GetChild("user_grp", ldw_user_grp)
ldw_user_grp.SetTransObject(sqlca)
ldw_user_grp.Retrieve('931')

This.GetChild("user_grp_nm", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('931')

This.GetChild("brand", ldw_brand)
ldw_brand.SetTransObject(sqlca)
ldw_brand.Retrieve('001')

This.GetChild("brand_nm", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('001')


This.GetChild("work_brand", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('001')

ldw_child.insertrow(1)
ldw_child.setitem(1,"inter_cd","%")
ldw_child.setitem(1,"inter_nm","전체")


end event

type gb_1 from groupbox within w_91011_e
integer x = 23
integer y = 160
integer width = 1115
integer height = 156
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

