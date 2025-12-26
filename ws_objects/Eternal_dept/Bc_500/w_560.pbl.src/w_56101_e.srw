$PBExportHeader$w_56101_e.srw
$PBExportComments$수금 내역 등록
forward
global type w_56101_e from w_com010_e
end type
end forward

global type w_56101_e from w_com010_e
integer width = 3675
integer height = 2268
end type
global w_56101_e w_56101_e

type variables
DataWindowChild idw_brand, idw_deposit_fg, idw_bank_cd

String is_brand, is_yymmdd, is_deposit_no, is_shop_cd
end variables

on w_56101_e.create
call super::create
end on

on w_56101_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.01.30                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "yymmdd", ld_datetime)
dw_head.SetColumn("brand")

end event

event ue_popup;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.01.30                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"							// 매장 코드
		is_brand = dw_head.GetItemString(1, "brand")
		If IsNull(is_brand) or Trim(is_brand) = "" Then 
			MessageBox("입력오류","브랜드 코드를 먼저 입력하십시요!")
			dw_head.SetColumn("brand")
			RETURN 1
		END IF
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF LeftA(as_data, 1) <> is_brand Then
					MessageBox("입력오류","해당 브랜드의 매장코드가 아닙니다!")
					RETURN 1
				ELSEIF gf_shop_nm(as_data, 'S', ls_part_nm) <> 0 THEN
					MessageBox("입력오류","등록되지 않은 매장코드입니다!")
					RETURN 1
				END IF
				dw_head.SetItem(al_row, "shop_nm", ls_part_nm)
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "매장 코드 검색" 
				gst_cd.datawindow_nm   = "d_com912" 
				gst_cd.default_where   = " WHERE SHOP_CD LIKE '" + is_brand + "%' "
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
END CHOOSE

RETURN 0

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/
if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
string ls_deposit_no, ls_shop_cd, ls_shop_nm

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_deposit_no, is_shop_cd)

IF IsNull(is_deposit_no) or Trim(is_deposit_no) = "" then
	ls_deposit_no       = dw_body.GetItemString(1, "deposit_no")
	dw_head.Setitem(1, "deposit_no", ls_deposit_no)
	is_deposit_no = dw_head.GetItemString(1, "deposit_no")
END IF 

IF IsNull(is_shop_cd) or Trim(is_shop_cd) = "" THEN
	ls_shop_cd          = dw_body.GetItemString(1, "shop_cd")
	dw_head.Setitem(1, "shop_cd", ls_shop_cd)
	is_shop_cd = dw_head.GetItemString(1, "shop_cd")
	
	IF gf_shop_nm(ls_shop_cd, 'S', ls_shop_nm) = 0 THEN
		dw_head.Setitem(1, "shop_nm", ls_shop_nm)
	END IF
END IF 

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_keycheck;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
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

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드를 입력하십시요 !!!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymmdd = String(dw_head.GetItemDatetime(1, "yymmdd"), 'yyyymmdd')
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"수금일자를 입력하십시요 !!!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_deposit_no = dw_head.GetItemString(1, "deposit_no")
if as_cb_div <> '1' and &
   (IsNull(is_deposit_no) or Trim(is_deposit_no) = "") then
   MessageBox(ls_title,"전표번호를 입력하십시요 !!!")
   dw_head.SetFocus()
   dw_head.SetColumn("deposit_no")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if as_cb_div <> '1' and &
   (IsNull(is_shop_cd) or Trim(is_shop_cd) = "") then
   MessageBox(ls_title,"매장코드를 입력하십시요 !!!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

if as_cb_div = '1' and &
   (IsNull(is_deposit_no) or Trim(is_deposit_no) = "") and &
	(IsNull(is_shop_cd) or Trim(is_shop_cd) = "") then
   MessageBox(ls_title,"전표번호나 매장코드를 입력하십시요 !!!")
   dw_head.SetFocus()
   dw_head.SetColumn("deposit_no")
   return false
end if

return true

end event

event ue_update;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
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
		If idw_status = NewModified! THEN				
			dw_body.Setitem(i, "yymmdd", is_yymmdd)
			dw_body.Setitem(i, "shop_cd", is_shop_cd)
			dw_body.Setitem(i, "deposit_no", is_deposit_no)
			dw_body.Setitem(i, "no", string(i, '0000'))
			dw_body.Setitem(i, "brand", is_brand)
			dw_body.Setitem(i, "shop_div", MidA(is_shop_cd,2,1))
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56101_e","0")
end event

type cb_close from w_com010_e`cb_close within w_56101_e
end type

type cb_delete from w_com010_e`cb_delete within w_56101_e
end type

type cb_insert from w_com010_e`cb_insert within w_56101_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56101_e
end type

type cb_update from w_com010_e`cb_update within w_56101_e
end type

type cb_print from w_com010_e`cb_print within w_56101_e
end type

type cb_preview from w_com010_e`cb_preview within w_56101_e
end type

type gb_button from w_com010_e`gb_button within w_56101_e
end type

type cb_excel from w_com010_e`cb_excel within w_56101_e
end type

type dw_head from w_com010_e`dw_head within w_56101_e
integer x = 681
integer y = 192
integer width = 3035
integer height = 188
string dataobject = "d_56101_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.01.30                                                  */
/*===========================================================================*/
CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.01.30                                                  */
/*===========================================================================*/
string ls_deposit_no

CHOOSE CASE dwo.name
	CASE "deposit_no"
		is_brand      = dw_head.GetItemString(1, "brand")
		is_yymmdd     = String(dw_head.GetItemDatetime(1, "yymmdd"), 'yyyymmdd')
		
		select substring(convert(varchar(5), convert(decimal(5), isnull(max(deposit_no), '0000')) + 10001), 2, 4) 
        into :ls_deposit_no
        from tb_56040_h
       where brand  = :is_brand
      	and yymmdd = :is_yymmdd;

		This.SetItem(1, "deposit_no", ls_deposit_no)
END CHOOSE



	
	
end event

type ln_1 from w_com010_e`ln_1 within w_56101_e
integer beginy = 412
integer endy = 412
end type

type ln_2 from w_com010_e`ln_2 within w_56101_e
integer beginy = 408
integer endy = 408
end type

type dw_body from w_com010_e`dw_body within w_56101_e
integer y = 432
integer height = 1604
string dataobject = "d_56101_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.02.06                                                  */	
/* 수정일      : 2002.02.06                                                  */
/*===========================================================================*/
This.GetChild("deposit_fg", idw_deposit_fg)
idw_deposit_fg.SetTransObject(SQLCA)
idw_deposit_fg.Retrieve('501')

This.GetChild("bank_cd", idw_bank_cd)
idw_bank_cd.SetTransObject(SQLCA)
idw_bank_cd.Retrieve('921')

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김재인                                                      */	
/* 작성일      : 2002.02.06                                                  */	
/* 수정일      : 2002.02.06                                                  */
/*===========================================================================*/
string     ls_sname

CHOOSE CASE dwo.name
	CASE "acc_cd"
		select sname 
        into :ls_sname
        from mis.dbo.tab01
       where acc_code = :data;

		This.SetItem(row, "sname", ls_sname)
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_56101_e
end type

