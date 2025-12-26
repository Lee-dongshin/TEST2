$PBExportHeader$w_33003_e.srw
$PBExportComments$협력업체 선급금 등록
forward
global type w_33003_e from w_com010_e
end type
type dw_slip from datawindow within w_33003_e
end type
type cb_slip from commandbutton within w_33003_e
end type
type dw_slip_detail from datawindow within w_33003_e
end type
type dw_slip_master from datawindow within w_33003_e
end type
type cb_slip_update from commandbutton within w_33003_e
end type
type cb_slip_close from commandbutton within w_33003_e
end type
end forward

global type w_33003_e from w_com010_e
integer width = 3680
integer height = 2240
dw_slip dw_slip
cb_slip cb_slip
dw_slip_detail dw_slip_detail
dw_slip_master dw_slip_master
cb_slip_update cb_slip_update
cb_slip_close cb_slip_close
end type
global w_33003_e w_33003_e

type variables
datawindowchild idw_slip_bonji, idw_brand

string  is_slip_bonji, is_brand, is_fore_ymd, is_fore_no, is_cust_cd, is_rmk 
decimal idc_fore_amt


   
end variables

on w_33003_e.create
int iCurrent
call super::create
this.dw_slip=create dw_slip
this.cb_slip=create cb_slip
this.dw_slip_detail=create dw_slip_detail
this.dw_slip_master=create dw_slip_master
this.cb_slip_update=create cb_slip_update
this.cb_slip_close=create cb_slip_close
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_slip
this.Control[iCurrent+2]=this.cb_slip
this.Control[iCurrent+3]=this.dw_slip_detail
this.Control[iCurrent+4]=this.dw_slip_master
this.Control[iCurrent+5]=this.cb_slip_update
this.Control[iCurrent+6]=this.cb_slip_close
end on

on w_33003_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_slip)
destroy(this.cb_slip)
destroy(this.dw_slip_detail)
destroy(this.dw_slip_master)
destroy(this.cb_slip_update)
destroy(this.cb_slip_close)
end on

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.04.10                                                  */	
/* 수정일      : 2002.04.10                                                  */
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
	If idw_status <> NotModified! Then
      IF idw_status = NewModified! THEN				
         dw_body.Setitem(i, "reg_id", gs_user_id)
      ELSEIF idw_status = DataModified! THEN		
         dw_body.Setitem(i, "mod_id", gs_user_id)
         dw_body.Setitem(i, "mod_dt", ld_datetime)
      END IF
	END IF	
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_keycheck;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.04.10                                                  */	
/* 수정일      : 2002.04.10                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

IF as_cb_div = '1' THEN
	ls_title = "조회오류"
ELSEIF as_cb_div = '2' THEN
	ls_title = "추가오류"
ELSEIF as_cb_div = '3' THEN
	ls_title = "저장오류"
ELSE
	ls_title = "오류"
END IF

IF dw_body.AcceptText() <> 1 THEN RETURN FALSE

is_brand = dw_body.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드를 입력하십시요 !!!")
   dw_body.SetFocus()
   dw_body.SetColumn("brand")
   return false
end if

is_fore_ymd = dw_body.GetItemString(1, "fore_ymd")
if IsNull(is_fore_ymd) or Trim(is_fore_ymd) = "" then
   MessageBox(ls_title,"일자를 입력하십시요 !!!")
   dw_body.SetFocus()
   dw_body.SetColumn("fore_ymd")
   return false
end if

is_fore_no = dw_body.GetItemstring(1, "fore_no")
if as_cb_div <> '1' and &
   (IsNull(is_fore_no) or Trim(is_fore_no) = "") then
   MessageBox(ls_title,"번호를 입력하십시요 !!!")
   dw_body.SetFocus()
   dw_body.SetColumn("fore_no")
   return false
end if

is_cust_cd = dw_body.GetItemstring(1, "cust_cd")
if as_cb_div <> '1' and &
   (IsNull(is_cust_cd) or Trim(is_cust_cd) = "") then
   MessageBox(ls_title,"협력업체를 입력하십시요 !!!")
   dw_body.SetFocus()
   dw_body.SetColumn("cust_cd")
   return false
end if

if as_cb_div = '1' and &
   (IsNull(is_fore_no) or Trim(is_fore_no) = "") and &
	(IsNull(is_cust_cd) or Trim(is_cust_cd) = "") then
   MessageBox(ls_title,"번호나 협력업체를 입력하십시요 !!!")
   dw_body.SetFocus()
   dw_body.SetColumn("fore_no")
   return false
end if

is_rmk = dw_body.GetItemString(1, "rmk")
if as_cb_div <> '1' and &
   (IsNull(is_rmk) or Trim(is_rmk) = "") then
   MessageBox(ls_title,"선급금 내역을 입력하십시요 !!!")
   dw_body.SetFocus()
   dw_body.SetColumn("rmk")
   return false
end if

idc_fore_amt = dw_body.GetItemdecimal(1, "fore_amt")
if as_cb_div <> '1' and &
   (IsNull(idc_fore_amt) or idc_fore_amt = 0) then
   MessageBox(ls_title,"선급금액을 입력하십시요 !!!")
   dw_body.SetFocus()
   dw_body.SetColumn("fore_amt")
   return false
end if

return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 종호)                                      */	
/* 작성일      : 2001.12.04                                                  */	
/* 수정일      : 2001.12.04                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/

string     ls_cust_cd, ls_cust_nm
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"							// 거래처 코드
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF gf_cust_nm(as_data, 'S', ls_cust_nm) <> 0 THEN
					MessageBox("입력오류","등록되지 않은 거래처 코드입니다!")
					RETURN 1
				END IF
			   If RightA(as_data, 4) < '5000' then //or Right(as_data, 4) > '9999' Then
					MessageBox("입력오류","협력업체 코드가 아닙니다!")
					RETURN 1
				End If					
				dw_body.SetItem(al_row, "cust_nm", ls_cust_nm)
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "거래처 코드 검색" 
				gst_cd.datawindow_nm   = "d_com911" 
				gst_cd.default_where   = " WHERE Cust_Code Between '5000' And 'ZZZZ' "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " CustCode LIKE ~'" + as_data + "%~' "
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
					dw_body.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"CustCode"))
					dw_body.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"Cust_sName"))
					/* 다음컬럼으로 이동 */
					dw_body.SetColumn("rmk")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
			END IF
END CHOOSE

RETURN 0

end event

event pfc_preopen;call super::pfc_preopen;/* DataWindow의 Transction 정의 */
dw_slip_master.SetTransObject(SQLCA)
dw_slip_detail.SetTransObject(SQLCA)

/* DataWindow Body에 One Row 추가 */
dw_body.InsertRow(0)
dw_slip.InsertRow(0)
end event

event open;call super::open;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.04.09                                                  */	
/* 수정일      : 2002.04.09                                                  */
/*===========================================================================*/
string ls_slip_bonji, ls_fore_ymd
datetime ld_datetime

/* 브랜드 Setting */
dw_body.SetItem(1, "brand", gs_brand)

/* 사업장 Setting */
IF gf_get_inter_sub('001', gs_brand, '1', ls_slip_bonji) = TRUE THEN
	dw_body.SetItem(1, "slip_bonji", ls_slip_bonji)
END IF

/* 일자 Setting */
IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF
ls_fore_ymd = String(ld_datetime, 'yyyymmdd')
dw_body.SetItem(1, "fore_ymd", ls_fore_ymd)
end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.04.10                                                  */	
/* 수정일      : 2002.04.10                                                  */
/*===========================================================================*/
long ll_data_count, ll_fore_jan_amt
string ls_slip_date, ls_slip_no

/* dw_body 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

SELECT COUNT(*)
  INTO :ll_data_count 
  FROM TB_33010_H A, MIS.DBO.TSB04 B 
 WHERE A.brand      = :is_brand 
   AND A.fore_ymd   = :is_fore_ymd  
   AND A.fore_no LIKE :is_fore_no + '%' 
   AND A.cust_cd LIKE :is_cust_cd + '%'   
   AND A.cust_cd   *= B.CUSTCODE;

IF ll_data_count    = 0 THEN
	MessageBox("조회오류","조회 할 자료가 없습니다 !!!")
   RETURN 
END IF 

il_rows = dw_body.retrieve(is_brand, is_fore_ymd, is_fore_no, is_cust_cd)

IF il_rows > 0 THEN
	IF IsNull(is_cust_cd) or Trim(is_cust_cd) = "" THEN
   	is_cust_cd          = dw_body.GetItemString(1, "cust_cd")
  	END IF 
				
	select sum(fore_amt) 
     into :ll_fore_jan_amt
     from tb_33010_h
    where brand     = :is_brand
	   and cust_cd   = :is_cust_cd
     	and fore_ymd <= :is_fore_ymd;

	dw_body.SetItem(1, "fore_jan_amt", ll_fore_jan_amt)
		
	ls_slip_date = dw_body.GetItemString(1, "slip_date")
	dw_slip.Setitem(1, "slip_date", ls_slip_date)
   ls_slip_no   = dw_body.GetItemString(1, "slip_no")
	dw_slip.Setitem(1, "slip_no", ls_slip_no)

   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_33003_e","0")
end event

type cb_close from w_com010_e`cb_close within w_33003_e
integer taborder = 130
end type

type cb_delete from w_com010_e`cb_delete within w_33003_e
boolean visible = false
integer taborder = 80
end type

type cb_insert from w_com010_e`cb_insert within w_33003_e
boolean visible = false
integer taborder = 60
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_33003_e
end type

type cb_update from w_com010_e`cb_update within w_33003_e
integer taborder = 120
end type

type cb_print from w_com010_e`cb_print within w_33003_e
boolean visible = false
integer taborder = 90
end type

type cb_preview from w_com010_e`cb_preview within w_33003_e
boolean visible = false
integer taborder = 100
end type

type gb_button from w_com010_e`gb_button within w_33003_e
end type

type cb_excel from w_com010_e`cb_excel within w_33003_e
boolean visible = false
integer taborder = 110
end type

type dw_head from w_com010_e`dw_head within w_33003_e
boolean visible = false
integer x = 3045
integer y = 196
integer width = 2313
integer height = 404
string dataobject = "d_33003_h01"
end type

type ln_1 from w_com010_e`ln_1 within w_33003_e
boolean visible = false
end type

type ln_2 from w_com010_e`ln_2 within w_33003_e
boolean visible = false
end type

type dw_body from w_com010_e`dw_body within w_33003_e
integer x = 41
integer y = 168
integer width = 3538
integer height = 896
integer taborder = 40
string dataobject = "d_33003_d01"
boolean vscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.04.04                                                  */	
/* 수정일      : 2002.04.04                                                  */
/*===========================================================================*/
datawindowchild ldw_child

This.GetChild("slip_bonji", idw_slip_bonji)
idw_slip_bonji.SetTRansObject(SQLCA)
idw_slip_bonji.Retrieve('028')

This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')


this.getchild("mat_type",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('014')
end event

event dw_body::itemchanged;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.04.04                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
string ls_brand, ls_fslip_bonji, ls_bslip_bonji
long ll_fore_jan_amt

CHOOSE CASE dwo.name
	CASE "slip_bonji"	
//		IF gf_get_inter_sub('028', data, '1', ls_brand) = TRUE THEN
//	      dw_body.SetItem(1, "brand", ls_brand)
//      END IF
	CASE "brand"
//		IF gf_get_inter_sub('001', data, '1', ls_fslip_bonji) = TRUE THEN
//	      ls_bslip_bonji      = dw_body.GetItemString(1, "slip_bonji")
//      	IF ls_bslip_bonji  <> ls_fslip_bonji THEN
//      		MessageBox("브랜드처리오류","사업장에 해당되지않는 브랜드입니다 !!!")
//            dw_body.SetFocus()
//            dw_body.SetColumn("brand")
//         END IF  
//      END IF
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		is_slip_bonji    = dw_body.GetItemString(1, "slip_bonji")
//		IF gf_get_inter_sub('028', is_slip_bonji, '1', ls_brand) = TRUE THEN
//	      IF ls_brand  <> mid(Upper(data),1,1) THEN
//				MessageBox("협력업체처리오류","사업장에 해당되지않는 협력업체입니다 !!!")
//            dw_body.SetFocus()
//            dw_body.SetColumn("cust_cd")
//			END IF
//      END IF
		
		is_brand         = dw_body.GetItemString(1, "brand")
		is_cust_cd       = data
		is_fore_ymd      = dw_body.GetItemString(1, "fore_ymd")
		
		select sum(fore_amt) 
        into :ll_fore_jan_amt
        from tb_33010_h
       where brand     = :is_brand
		   and cust_cd   = :is_cust_cd
      	and fore_ymd <= :is_fore_ymd;

		This.SetItem(1, "fore_jan_amt", ll_fore_jan_amt)
				
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.04.09                                                  */	
/* 수정일      : 2002.04.09                                                  */
/*===========================================================================*/
string ls_fore_no

CHOOSE CASE dwo.name
	CASE "fore_no"
		is_brand        = dw_body.GetItemString(1, "brand")
		is_fore_ymd     = dw_body.GetItemString(1, "fore_ymd")
		
		select substring(convert(varchar(5), convert(decimal(5), isnull(max(fore_no), '0000')) + 10001), 2, 4) 
        into :ls_fore_no
        from tb_33010_h
       where brand    = :is_brand
      	and fore_ymd = :is_fore_ymd;

		This.SetItem(1, "fore_no", ls_fore_no)
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_33003_e
end type

type dw_slip from datawindow within w_33003_e
integer x = 27
integer y = 1876
integer width = 3557
integer height = 124
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_33003_d02"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

type cb_slip from commandbutton within w_33003_e
integer x = 1339
integer y = 896
integer width = 503
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "전표생성처리(&P)"
end type

event clicked;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.04.11                                                  */	
/* 수정일      : 2002.04.11                                                  */
/*===========================================================================*/
string ls_slip_no, ls_io_gubn, ls_acc_name, ls_cust_name, ls_slip_detail, ls_mat_type
string ls_slip_bonji, ls_cust_cd, ls_slip_appl_code, ls_bojo_sml_code, ls_deposit_no, ls_deposit_owner, ls_bank
long ll_check_count, i, ll_row_count
	
ls_slip_no    = dw_body.GetItemString(1, "slip_no")
if IsNull(ls_slip_no) = FALSE then
   MessageBox("전표생성처리오류","이미 전표가 생성된 자료입니다 !!!")
   dw_body.SetFocus()
   dw_body.SetColumn("slip_bonji")
	RETURN
end if

ls_io_gubn    = dw_body.GetItemString(1, "io_gubn")
if ls_io_gubn = "-" then
   MessageBox("전표생성처리오류","공제는 전표를 생성할 수 없습니다 !!!")
   dw_body.SetFocus()
   dw_body.SetColumn("slip_bonji")
	RETURN
end if

IF Trigger Event ue_keycheck('4') = FALSE THEN RETURN

if cb_update.Enabled = True then
	MessageBox("전표생성처리오류","먼저 자료를 저장하십시오 !!!")
   dw_body.SetFocus()
   dw_body.SetColumn("slip_bonji")
	RETURN
end if

/* 처리하지않고 종료 -> 재전표생성처리 */
ll_check_count = dw_slip_master.RowCount()

/* DataWindow slip_master에 Row 추가 */
IF ll_check_count = 0 THEN
   dw_slip_master.InsertRow(0)
END IF

IF dw_slip_master.AcceptText() <> 1 THEN RETURN -1

ls_slip_bonji = dw_body.GetItemString(1, "slip_bonji")
ls_cust_cd    = dw_body.GetItemString(1, "cust_cd")
ls_mat_type  = dw_body.GetItemString(1, "mat_type")

dw_slip_master.Setitem(1, "slip_bonji", ls_slip_bonji)
dw_slip_master.Setitem(1, "slip_date", String(dw_body.GetItemString(1, "fore_ymd"),'@@@@.@@.@@'))
dw_slip_master.Setitem(1, "slip_bari_dept", gs_dept_cd)
dw_slip_master.Setitem(1, "slip_bari_empno", gs_user_id)
dw_slip_master.Setitem(1, "slip_gubn", "1")
dw_slip_master.Setitem(1, "slip_ok", "X")


//if ls_mat_type <> "1"  then

	select account_no, account_owner, bank_nm
	  into :ls_deposit_no, :ls_deposit_owner, :ls_bank
	  from tb_91105_d
	 where cust_cd = :ls_cust_cd;
	dw_slip_master.Setitem(1, "deposit_no", ls_deposit_no)
	dw_slip_master.Setitem(1, "deposit_owner", ls_deposit_owner)
	dw_slip_master.Setitem(1, "bank", ls_bank)

//end if

IF ls_slip_bonji = "01" THEN
   ls_slip_appl_code = "N911" 
ELSEIF ls_slip_bonji = "02" THEN	
	ls_slip_appl_code = "O911"
ELSEIF ls_slip_bonji = "41" THEN	
	ls_slip_appl_code = "M900"	
ELSEIF ls_slip_bonji = "A1" THEN	
	ls_slip_appl_code = "R900"		
else
   ls_slip_appl_code = "N911" 
END IF
dw_slip_master.Setitem(1, "slip_appl_code", ls_slip_appl_code)

/* DataWindow slip_detail에 Row 추가 */
IF ll_check_count = 0 THEN
   dw_slip_detail.InsertRow(0)
   dw_slip_detail.InsertRow(0)
END IF

ll_row_count = dw_slip_detail.RowCount()
IF dw_slip_detail.AcceptText() <> 1 THEN RETURN -1

FOR i=1 TO ll_row_count
	 dw_slip_detail.Setitem(i, "bari_dept", gs_dept_cd)
	 dw_slip_detail.Setitem(i, "bari_dept_name", gs_dept_nm)
	 dw_slip_detail.Setitem(i, "bari_emp", gs_user_id)
	 dw_slip_detail.Setitem(i, "bari_emp_name", gs_user_nm)
	 
    dw_slip_detail.Setitem(i, "slip_bonji", ls_slip_bonji)
	 dw_slip_detail.Setitem(i, "slip_date", String(dw_body.GetItemString(1, "fore_ymd"),'@@@@.@@.@@'))
	 dw_slip_detail.Setitem(i, "slip_serl", string(i, '0000'))
	 dw_slip_detail.Setitem(i, "slip_drcr", string(i, '0'))
	 dw_slip_detail.Setitem(i, "cust_code", MidA(ls_cust_cd,3,4))
	 IF gf_cust_nm(ls_cust_cd, 'S', ls_cust_name) = 0 THEN
		 dw_slip_detail.Setitem(i, "cust_name", ls_cust_name) 
	 END IF
	 dw_slip_detail.Setitem(i, "dept_code", gs_dept_cd)
	 dw_slip_detail.Setitem(i, "wonga_code", MidA(ls_cust_cd,1,1))
	 
	 IF i=1 THEN
		 dw_slip_detail.Setitem(i, "acc_code", "11161")
		 select sname 
         into :ls_acc_name
         from mis.dbo.tab01
        where acc_code = "11161";
       dw_slip_detail.Setitem(i, "acc_name", ls_acc_name) 
		 dw_slip_detail.Setitem(i, "racc_code", "11119")
		 dw_slip_detail.Setitem(i, "bojo_lrg_code", "04")
	    dw_slip_detail.Setitem(i, "bojo_sml_code", MidA(ls_cust_cd,3,4))
		 dw_slip_detail.Setitem(i, "slip_rmk1", dw_body.GetItemString(1, "rmk"))
		 dw_slip_detail.Setitem(i, "slip_cha_amt", dw_body.GetItemdecimal(1, "fore_amt"))
		 dw_slip_detail.Setitem(i, "slip_dae_amt", 0)
	 ELSEIF i=2 THEN 
	    dw_slip_detail.Setitem(i, "acc_code", "11119")
		 select sname 
         into :ls_acc_name
         from mis.dbo.tab01
        where acc_code = "11119";
       dw_slip_detail.Setitem(i, "acc_name", ls_acc_name) 
		 dw_slip_detail.Setitem(i, "racc_code", "11161")
		 dw_slip_detail.Setitem(i, "bojo_lrg_code", "01")
		 IF MidA(ls_slip_bonji,2,1) = "1" THEN
		    ls_bojo_sml_code = "110" 
		 else
			 ls_bojo_sml_code = "116" 
	    END IF
	    dw_slip_detail.Setitem(i, "bojo_sml_code", ls_bojo_sml_code)
		 dw_slip_detail.Setitem(i, "slip_cha_amt", 0)
		 dw_slip_detail.Setitem(i, "slip_dae_amt", dw_body.GetItemdecimal(1, "fore_amt"))
		 select deposit_no
		   into :ls_slip_detail
		   from mis.dbo.tab02d
        where bojo_lrg_code = "01"
          and bojo_sml_code = :ls_bojo_sml_code;
		 dw_slip_detail.Setitem(i, "slip_detail", ls_slip_detail)
    END IF
NEXT

/* DataWindow slip_detail 활성화 */
dw_slip_detail.visible = true
cb_slip_update.visible = true
cb_slip_close.visible  = true







end event

type dw_slip_detail from datawindow within w_33003_e
boolean visible = false
integer x = 37
integer y = 1216
integer width = 3479
integer height = 500
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_33003_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_slip_master from datawindow within w_33003_e
boolean visible = false
integer x = 37
integer y = 1120
integer width = 3479
integer height = 68
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_33003_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_slip_update from commandbutton within w_33003_e
boolean visible = false
integer x = 2752
integer y = 1256
integer width = 347
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "처리"
end type

event clicked;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.04.13                                                  */	
/* 수정일      : 2002.04.13                                                  */
/*===========================================================================*/
string ls_slip_rmk, ls_slip_bonji, ls_slip_date, ls_slip_no, ls_brand, ls_fore_ymd, ls_fore_no

IF dw_slip_detail.AcceptText() <> 1 THEN RETURN
ls_slip_rmk = dw_slip_detail.GetItemString(2, "slip_rmk1")
IF IsNull(ls_slip_rmk) OR Trim(ls_slip_rmk) = "" THEN
   MessageBox("처리오류","적요를 입력하십시요 !!!")
   dw_slip_detail.SetFocus()
   dw_slip_detail.SetColumn("slip_rmk1")
   RETURN
END IF

ls_slip_bonji     = dw_body.GetItemString(1, "slip_bonji")
ls_slip_date      = String(dw_body.GetItemString(1, "fore_ymd"),'@@@@.@@.@@')
		
select substring(convert(varchar(5), convert(decimal(5), isnull(max(slip_no), '0000')) + 10001), 2, 4) 
  into :ls_slip_no
  from mis.dbo.tat01m
 where slip_bonji = :ls_slip_bonji
  	and slip_date  = :ls_slip_date;

dw_slip_master.Setitem(1, "slip_no", ls_slip_no)
dw_slip_detail.Setitem(1, "slip_no", ls_slip_no)
dw_slip_detail.Setitem(2, "slip_no", ls_slip_no)

IF dw_slip_master.AcceptText() <> 1 THEN RETURN -1
IF dw_slip_detail.AcceptText() <> 1 THEN RETURN -1

il_rows    = dw_slip_master.Update(TRUE, FALSE)
if il_rows = 1 then
	il_rows = dw_slip_detail.Update(TRUE, FALSE)
end if

if il_rows = 1 then
   dw_slip_master.ResetUpdate()
	dw_slip_detail.ResetUpdate()
	commit   USING SQLCA;
else
   rollback USING SQLCA;
end if

/* 선급금 History 전표내역 Update */
ls_brand         = dw_body.GetItemString(1, "brand")
ls_fore_ymd      = dw_body.GetItemString(1, "fore_ymd")
ls_fore_no       = dw_body.GetItemString(1, "fore_no")
update tb_33010_h
   set slip_date = :ls_slip_date,
	    slip_no   = :ls_slip_no
 where brand     = :ls_brand
   and fore_ymd  = :ls_fore_ymd
	and fore_no   = :ls_fore_no;
dw_slip.Setitem(1, "slip_date", ls_slip_date)	
dw_slip.Setitem(1, "slip_no", ls_slip_no)	

/* 명령버튼 Setting */
cb_slip_update.enabled = false
cb_slip.enabled        = false




   
   





end event

type cb_slip_close from commandbutton within w_33003_e
boolean visible = false
integer x = 3099
integer y = 1256
integer width = 347
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료"
end type

event clicked;/* DataWindow slip_detail 비활성화 */
dw_slip_detail.visible = false
cb_slip_update.visible = false
cb_slip_close.visible  = false
end event

