$PBExportHeader$w_56123_e.srw
$PBExportComments$대리점 입금계획
forward
global type w_56123_e from w_com010_e
end type
type dw_db from datawindow within w_56123_e
end type
type dw_1 from u_dw within w_56123_e
end type
end forward

global type w_56123_e from w_com010_e
integer width = 3675
integer height = 2248
dw_db dw_db
dw_1 dw_1
end type
global w_56123_e w_56123_e

type variables
DataWindowChild	idw_brand, idw_shop_div, idw_bank_cd
String is_brand, is_shop_cd, is_shop_div, is_fr_yymmdd, is_to_yymmdd
end variables

on w_56123_e.create
int iCurrent
call super::create
this.dw_db=create dw_db
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_db
this.Control[iCurrent+2]=this.dw_1
end on

on w_56123_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_db)
destroy(this.dw_1)
end on

event pfc_preopen();call super::pfc_preopen;dw_db.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
end event

event open;call super::open;DateTime ld_datetime
String ls_datetime, ls_person_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "YYYYMMDD")


dw_head.Setitem(1, "FR_yymmdd", ls_datetime )
dw_head.Setitem(1, "TO_yymmdd", ls_datetime)
dw_head.Setitem(1, "shop_div", 'K')

dw_1.insertrow(0)

//온앤온   현진 B40703
//올리브   혜란 B51001
//라빠레트 상은 B20307
//코인코즈 소연 A30301
	
		if gs_brand = "O" then 
			dw_1.setitem(1, "bank_no", "387-910007-70904")
			dw_1.setitem(1, "bank", "50")						
			dw_1.setitem(1, "mng_emp", "B51001")			
			dw_1.setitem(1, "tel_no", "2225-0122")		
			IF gf_user_nm("B51001", ls_person_nm) <> 0 THEN
				ls_person_nm = ''
			END IF
			dw_1.SetItem(1, "mng_nm", ls_person_nm)
		elseif	gs_brand = "N" then
			dw_1.setitem(1, "bank", "50")				
			dw_1.setitem(1, "bank_no", "387-910006-81404")	
			dw_1.setitem(1, "mng_emp", "B40703")			
			dw_1.setitem(1, "tel_no", "2225-0227")	
			IF gf_user_nm("B40703", ls_person_nm) <> 0 THEN
				ls_person_nm = ''
			END IF
			dw_1.SetItem(1, "mng_nm", ls_person_nm)		
		elseif	gs_brand = "B" then
			dw_1.setitem(1, "bank_no", "387-910006-81404")		
			dw_1.setitem(1, "bank", "50")									
			dw_1.setitem(1, "mng_emp", "B20307")			
			dw_1.setitem(1, "tel_no", "2225-0129")		
			IF gf_user_nm("B00703", ls_person_nm) <> 0 THEN
				ls_person_nm = ''
			END IF
			dw_1.SetItem(1, "mng_nm", ls_person_nm)			
		else//if	data = "I" then
			dw_1.setitem(1, "bank_no", "387-910006-81404")		
			dw_1.setitem(1, "bank", "50")									
			dw_1.setitem(1, "mng_emp", "A30301")			
			dw_1.setitem(1, "tel_no", "2225-0123")		
			IF gf_user_nm("A30301", ls_person_nm) <> 0 THEN
				ls_person_nm = ''
			END IF
			dw_1.SetItem(1, "mng_nm", ls_person_nm)	
//		else
//			dw_1.setitem(row, "bank_no", "387-910006-81404")				
		end if	
		

//
//	if gs_brand = "O" then 
//		dw_1.setitem(1, "bank_no", "101-13-44846-1")
//		dw_1.setitem(1, "bank", "59")					
//		dw_1.setitem(1, "mng_emp", "A30301")			
//		dw_1.setitem(1, "tel_no", "2225-0123")		
//		IF gf_user_nm("A30301", ls_person_nm) <> 0 THEN
//			ls_person_nm = ''
//		END IF
//		dw_1.SetItem(1, "mng_nm", ls_person_nm)
//	elseif	gs_brand = "W" then
//		dw_1.setitem(1, "bank_no", "101-13-41481-8")		
//		dw_1.setitem(1, "bank", "59")					
//		dw_1.setitem(1, "mng_emp", "990902")			
//		dw_1.setitem(1, "tel_no", "2225-0121")		
//		IF gf_user_nm("990902", ls_person_nm) <> 0 THEN
//			ls_person_nm = ''
//		END IF
//		dw_1.SetItem(1, "mng_nm", ls_person_nm)			
//	elseif	gs_brand = "N" then
//		dw_1.setitem(1, "bank_no", "387-910006-81404")	
//		dw_1.setitem(1, "bank", "50")			
//		dw_1.setitem(1, "mng_emp", "A80404")			
//		dw_1.setitem(1, "tel_no", "2225-0189")	
//		IF gf_user_nm("A80404", ls_person_nm) <> 0 THEN
//			ls_person_nm = ''
//		END IF
//		dw_1.SetItem(1, "mng_nm", ls_person_nm)					
//	else
//		dw_1.setitem(1, "bank_no", "101-13-41481-8")				
//	end if	
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

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
if IsNull(is_fr_yymmdd) or Trim(is_fr_yymmdd) = "" then
   MessageBox(ls_title,"입금일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymmdd")
   return false
end if

is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
if IsNull(is_to_yymmdd) or Trim(is_to_yymmdd) = "" then
   MessageBox(ls_title,"입금일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if


is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if


is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
  is_shop_cd = '%'
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long ll_rows

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec  SP_56122_D01 'n', '20030109','20030109', 'k', '%'

il_rows = dw_body.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_shop_div, is_shop_cd)
ll_rows = dw_db.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd)
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

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
long i, ll_row_count, ll_row_count1, ll_find, ll_new_row
datetime ld_datetime
string ls_find, ls_shop_cd, ls_yymmdd, ls_chk_yn, ls_remark
string ls_modify, ls_datetime, ls_mng_emp, ls_tel_no, ls_bank, ls_bank1, ls_bank_no

ll_row_count  = dw_body.RowCount()
ll_row_count1 = dw_db.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1
   dw_1.AcceptText()

ls_mng_emp = dw_1.GetItemString(1, "mng_emp")
if IsNull(ls_mng_emp) or Trim(ls_mng_emp) = "" then
  ls_mng_emp = "A40201"
end if

ls_tel_no = dw_1.GetItemString(1, "tel_no")
if IsNull(ls_tel_no) or Trim(ls_tel_no) = "" then
  ls_tel_no = "2225-0120"
end if

ls_bank = dw_1.GetItemString(1, "bank")
if IsNull(ls_bank) or Trim(ls_bank) = "" then
  ls_bank = "50"
end if
ls_bank1 = ls_bank

ls_bank_no = dw_1.GetItemString(1, "bank_no")
if IsNull(ls_bank_no) or Trim(ls_bank_no) = "" then
  ls_bank_no = "119-910001-57104"
end if

ls_remark = dw_1.GetItemString(1, "remark")
if IsNull(ls_remark) or Trim(ls_remark) = "" then
  ls_remark = " "
end if


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   ls_chk_yn  = dw_body.GetitemString(i, "check_yn")
	ls_shop_cd = dw_body.GetitemString(i, "shop_cd") 
	ls_yymmdd  = dw_body.GetitemString(i, "sugm_ymd") 	
   IF ls_chk_yn = 'Y' THEN				/* New Record */
      ls_find  = "shop_cd = '" + ls_shop_cd + "' and yymmdd = '" + ls_yymmdd + "'"
		ll_find = dw_db.find(ls_find, 1, ll_row_count1)	
	    if ll_find = 0 then
			 ll_new_row = dw_db.insertrow(0)
          dw_db.Setitem(ll_new_row, "yymmdd",  ls_yymmdd)			 
          dw_db.Setitem(ll_new_row, "shop_cd", ls_shop_cd)			 
          dw_db.Setitem(ll_new_row, "brand",   is_brand)		
          dw_db.Setitem(ll_new_row, "mng_empno",   ls_mng_emp)		
          dw_db.Setitem(ll_new_row, "tel_no",   ls_tel_no)		
          dw_db.Setitem(ll_new_row, "bank_cd",   ls_bank)		
          dw_db.Setitem(ll_new_row, "bank_no",   ls_bank_no)					 
          dw_db.Setitem(ll_new_row, "remark",   ls_remark)				 
          dw_db.Setitem(ll_new_row, "reg_id",  gs_user_id)
 		else 	 
	       dw_db.Setitem(i, "mod_id", gs_user_id)
          dw_db.Setitem(i, "mod_dt", ld_datetime)	 
		end if	 
	 	 
   ELSEIF ls_chk_yn = 'N' THEN				/* New Record */
      ls_find  = "shop_cd = '" + ls_shop_cd + "' and yymmdd = '" + ls_yymmdd + "'"
		ll_find = dw_db.find(ls_find, 1, ll_row_count1)	
      if ll_find <> 0 then
			 dw_db.deleterow(ll_find)
		end if	 

   END IF
NEXT

il_rows = dw_db.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_db.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime, ls_mng_nm, ls_tel_no, ls_bank, ls_bank1, ls_bank_no, ls_mng_emp
String ls_bank_nm

ls_mng_emp = dw_1.GetItemString(1, "mng_emp")
if IsNull(ls_mng_emp) or Trim(ls_mng_emp) = "" then
  ls_mng_emp = "990107"
end if

select kname 
into :ls_mng_nm 
from mis.dbo.thb01
where empno = :ls_mng_emp;


ls_tel_no = dw_1.GetItemString(1, "tel_no")
if IsNull(ls_tel_no) or Trim(ls_tel_no) = "" then
  ls_tel_no = "2225-0121"
end if

ls_bank = dw_1.GetItemString(1, "bank")
if IsNull(ls_bank) or Trim(ls_bank) = "" then
  ls_bank = "50"
end if


SELECT INTER_NM
into :ls_bank_nm
FROM TB_91011_C (nolock)
WHERE INTER_GRP = '921'
AND   INTER_CD  = :ls_bank;

ls_bank1 = ls_bank_nm



ls_bank_no = dw_1.GetItemString(1, "bank_no")
if IsNull(ls_bank_no) or Trim(ls_bank_no) = "" then
  ls_bank_no = "119-91001-57104"
end if

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	 "t_name.Text = '" + ls_mng_nm + "'" + &
				 "t_tel_no.Text = '" + ls_tel_no + "'" + &
				 "t_bank.Text = '" + ls_bank_nm + "'" + &				 
				 "t_bank1.Text = '" + ls_bank1 + "'" + &				 				 
				 "t_bank_no.Text = '" + ls_bank_no + "'" 

dw_print.Modify(ls_modify)

end event

event ue_print();
Long   i 
String ls_shop_type, ls_out_no, ls_shop_cd, ls_yymmdd, ls_print, ls_inout_gubn, ls_out_gubn
String ls_shop_div

This.Trigger Event ue_title()

FOR i = 1 TO dw_body.RowCount() 
	ls_print = dw_body.getitemstring(i, "check_yn")
	IF ls_print = "Y"  THEN 
		ls_yymmdd     = dw_body.GetitemString(i, "sugm_ymd")			 
		ls_shop_cd    = dw_body.GetitemString(i, "shop_cd") 
		ls_shop_div   = MidA(ls_shop_cd,2,1)

		il_rows = dw_print.Retrieve(is_brand, ls_yymmdd, ls_yymmdd, ls_shop_div, ls_shop_cd)
		IF dw_print.RowCount() > 0 Then			     
			il_rows = dw_print.Print()
		END IF
	END IF 	
NEXT 
	
This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56123_e","0")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.01.30                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm,  ls_person_nm
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"							// 매장 코드
	
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF gf_shop_nm(as_data, 'S', ls_part_nm) <> 0 THEN
					MessageBox("입력오류","등록되지 않은 매장코드입니다!")
					RETURN 1
				END IF
				dw_head.SetItem(al_row, "shop_nm", ls_part_nm)
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "매장 코드 검색" 
				gst_cd.datawindow_nm   = "d_com912" 
				gst_cd.default_where   = " WHERE SHOP_CD LIKE '" + is_brand + "%' and shop_div = 'K' "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " SHOP_CD LIKE '" + as_data + "%' "
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
					dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
					dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
			END IF
			

	CASE "mng_emp"							// 사용자 코드
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF gf_user_nm(as_data, ls_person_nm) <> 0 THEN
					ls_person_nm = ''
				END IF
				dw_1.SetItem(al_row, "mng_nm", ls_person_nm)
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "사번 코드 검색" 
				gst_cd.datawindow_nm   = "d_com931" 
				gst_cd.default_where   = "where dept_cd in ('4100','T310') and status_yn = 'Y' "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "PERSON_ID LIKE '" + as_data + "%' and  dept_cd in ('4100','T310') and status_yn = 'Y' "
				ELSE
					gst_cd.Item_where = ""
				END IF

				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm
					dw_1.SetRow(al_row)
					dw_1.SetColumn(as_column)
					dw_1.SetItem(al_row, "mng_emp", lds_Source.GetItemString(1,"person_id"))
					dw_1.SetItem(al_row, "mng_nm", lds_Source.GetItemString(1,"person_nm"))
					/* 다음컬럼으로 이동 */
					dw_1.SetColumn("tel_no")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
			END IF


			
END CHOOSE

RETURN 0

end event

type cb_close from w_com010_e`cb_close within w_56123_e
end type

type cb_delete from w_com010_e`cb_delete within w_56123_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56123_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56123_e
end type

type cb_update from w_com010_e`cb_update within w_56123_e
end type

type cb_print from w_com010_e`cb_print within w_56123_e
integer x = 1221
integer width = 549
string text = "입금내역서인쇄(&P)"
end type

type cb_preview from w_com010_e`cb_preview within w_56123_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56123_e
end type

type cb_excel from w_com010_e`cb_excel within w_56123_e
end type

type dw_head from w_com010_e`dw_head within w_56123_e
integer y = 148
integer height = 220
string dataobject = "d_56123_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;string ls_person_nm
CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		
//온앤온   세희 B20604
//올리브   혜진 B00703
//라빠레트 상은 B20307
//코인코즈 소연 A30301
	
		if data = "O" then 
			dw_1.setitem(row, "bank_no", "387-910007-70904")
			dw_1.setitem(1, "bank", "50")						
			dw_1.setitem(row, "mng_emp", "B00703")			
			dw_1.setitem(row, "tel_no", "2225-0189")		
			IF gf_user_nm("B00703", ls_person_nm) <> 0 THEN
				ls_person_nm = ''
			END IF
			dw_1.SetItem(row, "mng_nm", ls_person_nm)
		elseif	data = "N" then
			dw_1.setitem(row, "bank", "50")				
			dw_1.setitem(row, "bank_no", "387-910006-81404")	
			dw_1.setitem(row, "mng_emp", "B20604")			
			dw_1.setitem(row, "tel_no", "2225-0122")	
			IF gf_user_nm("B20604", ls_person_nm) <> 0 THEN
				ls_person_nm = ''
			END IF
			dw_1.SetItem(row, "mng_nm", ls_person_nm)		
		elseif	data = "B" then
			dw_1.setitem(row, "bank_no", "387-910006-81404")		
			dw_1.setitem(1, "bank", "50")									
			dw_1.setitem(row, "mng_emp", "B20307")			
			dw_1.setitem(row, "tel_no", "2225-0129")		
			IF gf_user_nm("B20307", ls_person_nm) <> 0 THEN
				ls_person_nm = ''
			END IF
			dw_1.SetItem(row, "mng_nm", ls_person_nm)			
		else//if	data = "I" then
			dw_1.setitem(row, "bank_no", "387-910006-81404")		
			dw_1.setitem(1, "bank", "50")									
			dw_1.setitem(row, "mng_emp", "A30301")			
			dw_1.setitem(row, "tel_no", "2225-0123")		
			IF gf_user_nm("A30301", ls_person_nm) <> 0 THEN
				ls_person_nm = ''
			END IF
			dw_1.SetItem(row, "mng_nm", ls_person_nm)	
//		else
//			dw_1.setitem(row, "bank_no", "387-910006-81404")				
		end if	
		
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_56123_e
integer beginy = 576
integer endy = 576
end type

type ln_2 from w_com010_e`ln_2 within w_56123_e
integer beginy = 580
integer endy = 580
end type

type dw_body from w_com010_e`dw_body within w_56123_e
integer y = 592
integer height = 1416
string dataobject = "d_56123_d01"
boolean hscrollbar = true
end type

event dw_body::clicked;call super::clicked;Long	ll_row_count, i
string ls_accept_yn

CHOOSE CASE dwo.name
	CASE "cb_proc"
		If This.Object.cb_proc.Text = '확정' then
			ls_accept_yn = 'Y'
			This.Object.cb_proc.Text = '제외'
		Else
			ls_accept_yn = 'N'
			This.Object.cb_proc.Text = '확정'
		End If
		
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "check_yn", ls_accept_yn)
		Next
END CHOOSE

    
end event

type dw_print from w_com010_e`dw_print within w_56123_e
string dataobject = "d_56122_r02"
end type

type dw_db from datawindow within w_56123_e
boolean visible = false
integer x = 325
integer y = 988
integer width = 2807
integer height = 600
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "조회승인등록"
string dataobject = "d_56123_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from u_dw within w_56123_e
integer x = 23
integer y = 356
integer width = 3561
integer height = 212
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_56123_h02"
boolean vscrollbar = false
end type

event itemchanged;call super::itemchanged;CHOOSE CASE dwo.name

	CASE "mng_emp"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
END CHOOSE

end event

event constructor;call super::constructor;THIS.GetChild("bank", idw_bank_cd)
idw_bank_cd.SetTransObject(SQLCA)
idw_bank_cd.Retrieve('921')
end event

event buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

