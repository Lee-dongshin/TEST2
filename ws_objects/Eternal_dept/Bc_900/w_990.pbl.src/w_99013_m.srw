$PBExportHeader$w_99013_m.srw
$PBExportComments$고정자산 보유대장
forward
global type w_99013_m from w_com010_e
end type
end forward

global type w_99013_m from w_com010_e
end type
global w_99013_m w_99013_m

type variables
DataWindowChild idw_d_gubn, idw_s_gubn

String is_item, is_saupjang, is_asset_nm, is_cust_cd, is_d_gubn, is_s_gubn, is_tbit, is_fr_ymd, is_to_ymd

end variables

on w_99013_m.create
call super::create
end on

on w_99013_m.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : M.S.I (김 태범)                                             */	
/* 작성일      : 2001.05.31                                                  */	
/* 수성일      : 2001.05.31                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_item, is_saupjang, is_asset_nm, is_cust_cd, is_d_gubn, is_s_gubn, is_tbit, is_fr_ymd, is_to_ymd)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : M.S.I (김 태범)                                             */	
/* 작성일      : 2001.05.31                                                  */	
/* 수성일      : 2001.09.31                                                  */
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

is_item			= dw_head.getitemstring(1,'item')
if IsNull(is_item) or is_item = "" then
	is_item = '%'
end if

is_saupjang		= dw_head.getitemstring(1,'saupjang')
if IsNull(is_saupjang) or is_saupjang = "" then
	is_saupjang = '%'
end if

is_asset_nm		= dw_head.getitemstring(1,'asset_nm')
if IsNull(is_asset_nm) or is_asset_nm = "" then
	is_asset_nm = '%'
end if

is_cust_cd		= dw_head.getitemstring(1,'cust_cd')
if IsNull(is_cust_cd) or is_cust_cd = "" then
	is_cust_cd = '%'
end if

is_d_gubn		= dw_head.getitemstring(1,'d_gubn')
if IsNull(is_d_gubn) or is_d_gubn = "" then
	is_d_gubn = '%'
end if

is_s_gubn		= dw_head.getitemstring(1,'s_gubn')
if IsNull(is_s_gubn) or is_s_gubn = "" then
	is_s_gubn = '%'
end if

is_tbit			= dw_head.getitemstring(1,'tbit')
if IsNull(is_tbit) or is_tbit = "" then
	is_tbit = '%'
end if

is_fr_ymd		= dw_head.getitemstring(1,'fr_ymd')
if IsNull(is_fr_ymd) or is_fr_ymd = "" then
	is_fr_ymd = '00000000'
end if

is_to_ymd		= dw_head.getitemstring(1,'to_ymd')
if IsNull(is_to_ymd) or is_to_ymd = "" then
	is_to_ymd = '99999999'
end if
//is_person_id = dw_head.GetItemString(1, "person_id")
//is_person_nm = dw_head.GetItemString(1, "person_nm")
//is_user_grp = dw_head.GetItemString(1, "user_grp")

return true

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : M.S.I (김 태범)                                             */	
/* 작성일      : 2001.05.31                                                  */	
/* 수성일      : 2001.05.31                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_seq_no
string ls_seq_no, ls_yymmdd, ls_item
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
		ls_item   = dw_body.getitemstring(i, 'item')
		ls_yymmdd = dw_body.getitemstring(i, 'start_ymd')

		if i = 1 then
			//순번채번		
			SELECT CAST(ISNULL(MAX(right(asset_no,3)), '0') AS INT)
			  INTO :ll_seq_no
			  FROM tb_99013_m
			 WHERE start_ymd = :ls_yymmdd;
			
			If SQLCA.SQLCODE <> 0 Then 
				MessageBox("저장오류", "의뢰번호 채번에 실패하였습니다!")
				Return -1
			End If		
		end if
		
		ll_seq_no = ll_seq_no + 1
//		ls_seq_no = String(ll_seq_no + 1, '000')			

		dw_body.Setitem(i, "asset_no", ls_item+ls_yymmdd+String(ll_seq_no, '000'))
//		dw_body.Setitem(i, "asset_no", ls_item+ls_yymmdd+ls_seq_no)
      dw_body.Setitem(i, "reg_id", gs_user_id)
      dw_body.Setitem(i, "reg_dt", ld_datetime)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
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

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.14                                                  */	
/* 수정일      : 2001.11.14                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_person_nm
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "person_id"							// 사용자 코드
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF gf_user_nm(as_data, ls_person_nm) <> 0 THEN
					ls_person_nm = ''
				END IF
				dw_head.SetItem(al_row, "person_nm", ls_person_nm)
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "사번 코드 검색" 
				gst_cd.datawindow_nm   = "d_com931" 
				gst_cd.default_where   = ""
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "PERSON_ID LIKE '" + as_data + "%' "
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
					dw_head.SetItem(al_row, "person_id", lds_Source.GetItemString(1,"person_id"))
					dw_head.SetItem(al_row, "person_nm", lds_Source.GetItemString(1,"person_nm"))
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("person_nm")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
			END IF
END CHOOSE

RETURN 0

end event

event pfc_preopen();call super::pfc_preopen;/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
dw_body.InsertRow(0)


/*
This.GetChild("d_gubn", idw_d_gubn)
idw_d_gubn.SetTransObject(SQLCA)
idw_d_gubn.Retrieve('961')
idw_d_gubn.InsertRow(1)
idw_d_gubn.SetItem(1, "inter_cd", '%')
idw_d_gubn.SetItem(1, "inter_nm", '전체')


This.GetChild("s_gubn", idw_s_gubn)
idw_s_gubn.SetTransObject(SQLCA)
idw_s_gubn.Retrieve('962','%')
idw_s_gubn.InsertRow(1)
idw_s_gubn.SetItem(1, "inter_cd", '%')
idw_s_gubn.SetItem(1, "inter_nm", '전체')

*/
end event

event ue_insert();call super::ue_insert;long i, ll_row_count

ll_row_count = dw_body.RowCount()

FOR i=1 TO ll_row_count
	dw_body.setitem(i,'tbit','1')
next
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")



ls_modify =	"t_pg_id.Text     = '" + is_pgm_id +    "'" + &
            "t_user_id.Text   = '" + gs_user_id +   "'" + &
            "t_datetime.Text  = '" + ls_datetime +  "'" 
				
dw_print.Modify(ls_modify)

end event

event ue_print();call super::ue_print;This.Trigger Event ue_title()
end event

event ue_preview();call super::ue_preview;This.Trigger Event ue_title()
end event

type cb_close from w_com010_e`cb_close within w_99013_m
end type

type cb_delete from w_com010_e`cb_delete within w_99013_m
end type

type cb_insert from w_com010_e`cb_insert within w_99013_m
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_99013_m
end type

type cb_update from w_com010_e`cb_update within w_99013_m
end type

type cb_print from w_com010_e`cb_print within w_99013_m
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_99013_m
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_99013_m
end type

type cb_excel from w_com010_e`cb_excel within w_99013_m
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_99013_m
integer x = 14
integer y = 160
integer width = 3584
integer height = 196
string dataobject = "d_99013_h01"
end type

event dw_head::constructor;call super::constructor;
DataWindowChild ldw_child
This.GetChild("d_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('961')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("s_gubn", idw_s_gubn)
idw_s_gubn.SetTransObject(SQLCA)
idw_s_gubn.Retrieve('962','%')
idw_s_gubn.InsertRow(1)
idw_s_gubn.SetItem(1, "inter_cd", '')
idw_s_gubn.SetItem(1, "inter_nm", '')


end event

event dw_head::itemchanged;call super::itemchanged;String ls_d_gubn

dw_head.accepttext()

CHOOSE CASE dwo.name
	CASE "d_gubn"
		ls_d_gubn = This.GetItemString(1, "d_gubn")
		This.GetChild("s_gubn", idw_s_gubn)
		idw_s_gubn.Retrieve('962', ls_d_gubn)
		idw_s_gubn.InsertRow(1)
		idw_s_gubn.SetItem(1, "inter_cd", '%')
		idw_s_gubn.SetItem(1, "inter_nm", '전체')
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_99013_m
integer beginy = 364
integer endy = 364
end type

type ln_2 from w_com010_e`ln_2 within w_99013_m
integer beginy = 368
integer endy = 368
end type

type dw_body from w_com010_e`dw_body within w_99013_m
integer y = 380
integer width = 3602
integer height = 1640
string dataobject = "d_99013_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
DataWindowChild ldw_child

This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)
This.GetChild("d_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('961')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("s_gubn", idw_s_gubn)
idw_s_gubn.SetTransObject(SQLCA)
idw_s_gubn.Retrieve('962','%')
idw_s_gubn.InsertRow(1)
idw_s_gubn.SetItem(1, "inter_cd", '')
idw_s_gubn.SetItem(1, "inter_nm", '')


end event

type dw_print from w_com010_e`dw_print within w_99013_m
integer x = 146
integer y = 732
string dataobject = "d_99013_r01"
end type

