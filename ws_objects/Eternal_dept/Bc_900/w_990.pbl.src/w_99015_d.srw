$PBExportHeader$w_99015_d.srw
$PBExportComments$고정자산 사용등록
forward
global type w_99015_d from w_com010_e
end type
type dw_1 from datawindow within w_99015_d
end type
end forward

global type w_99015_d from w_com010_e
integer width = 2034
integer height = 1416
string title = "사용자등록"
string menuname = ""
boolean resizable = false
windowtype windowtype = popup!
dw_1 dw_1
end type
global w_99015_d w_99015_d

type variables
DataWindowChild idw_d_gubn, idw_s_gubn

String is_item, is_saupjang, is_asset_nm, is_cust_cd, is_d_gubn, is_s_gubn, is_tbit, is_fr_ymd, is_to_ymd
string is_empno, is_asset_no
end variables

on w_99015_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_99015_d.destroy
call super::destroy
destroy(this.dw_1)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : M.S.I (김 태범)                                             */	
/* 작성일      : 2001.05.31                                                  */	
/* 수성일      : 2001.05.31                                                  */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_empno, is_asset_no)

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
/*
IF dw_body.AcceptText() <> 1 THEN RETURN FALSE

is_empno			= dw_body.getitemstring(1,'empno')
if IsNull(is_empno) or is_empno = "" then
	messagebox('확인', '사번을 입력하세요')
	return false
end if

is_asset_no		= dw_body.getitemstring(1,'asset_no')
if IsNull(is_asset_no) or is_asset_no = "" then
	is_saupjang = '%'
end if
*/
IF dw_body.AcceptText() <> 1 THEN RETURN FALSE

is_empno			= dw_body.getitemstring(1,'empno')
if IsNull(is_empno) or is_empno = "" then
	messagebox('확인', '사번을 입력하세요')
	return false
end if

is_asset_no		= dw_body.getitemstring(1,'asset_no')
if IsNull(is_asset_no) or is_asset_no = "" then
	is_saupjang = '%'
end if


/*
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
*/
return true

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : M.S.I (김 태범)                                             */	
/* 작성일      : 2001.05.31                                                  */	
/* 수성일      : 2001.05.31                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_seq_no
string ls_seq_no, ls_yymmdd, ls_item, ls_empno, ls_asset_no
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
		ls_asset_no = dw_body.getitemstring(1, 'asset_no')
		ls_empno = dw_body.getitemstring(1, 'empno')
		
		//순번채번		
		SELECT CAST(ISNULL(MAX(seq), '0') AS INT)
		  INTO :ll_seq_no
		  FROM tb_99014_d
		 WHERE empno = :ls_empno
				 and asset_no = :ls_asset_no;
		 
		If SQLCA.SQLCODE <> 0 Then 
			MessageBox("저장오류", "의뢰번호 채번에 실패하였습니다!")
			Return -1
		End If
	
		ls_seq_no = String(ll_seq_no + 1, '0000')
		
		dw_body.Setitem(i, "seq", ls_seq_no)		
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.14                                                  */	
/* 수정일      : 2001.11.14                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_empno, ls_kname, ls_jik, ls_empno_fr
DataStore  lds_Source

dw_body.accepttext()

CHOOSE CASE as_column
	CASE "asset_no"				// 자산코드
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call

			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "자산 코드 검색" 
				gst_cd.datawindow_nm   = "d_com993" 
				gst_cd.default_where   = "where saupjang like '%'"
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where =	" item like '" + is_item + "%'" + &
												" and tbit like '" + is_tbit + "%'" 
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
					dw_body.SetItem(al_row, "asset_no", lds_Source.GetItemString(1,"asset_no"))
					dw_body.object.t_asset_nm.text = lds_Source.GetItemString(1,"asset_nm")
					dw_body.SetItem(al_row, "item", lds_Source.GetItemString(1,"item"))
					dw_body.object.t_d_nm.text = lds_Source.GetItemString(1,"d_gubn")+'('+lds_Source.GetItemString(1,"d_nm")+')'
					dw_body.object.t_s_nm.text = lds_Source.GetItemString(1,"s_gubn")+'('+lds_Source.GetItemString(1,"s_nm")+')'
					/* 다음컬럼으로 이동 */
					dw_body.SetColumn("start_ymd")
					
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
			END IF


	CASE "empno"
			ls_empno = dw_body.getitemstring(1, 'empno')
			IF ai_div = 1 THEN
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_body.SetItem(al_row, "empno", "")
					dw_body.object.t_kname.text = ''
					RETURN 0
				END IF 
			END IF
			
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com994"
			gst_cd.default_where   = " WHERE goout_gubn = '1' " 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "empno LIKE '" + as_data + "%'" 
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
				dw_body.SetItem(al_row, "empno", lds_Source.GetItemString(1,"empno"))
				dw_body.object.t_kname.text = lds_Source.GetItemString(1,"kname")
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("item")
				ib_itemchanged = False 
			END IF
			Destroy  lds_Source	

		CASE "empno_fr"
			ls_empno_fr = dw_body.getitemstring(1, 'empno_fr')
			IF ai_div = 1 THEN
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_body.SetItem(al_row, "empno_fr", "")
					dw_body.object.t_kname_fr.text = ''
					RETURN 0
				END IF 
			END IF
			
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com994"
			gst_cd.default_where   = " WHERE goout_gubn like '%' " 
	
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "EMPNO LIKE '" + as_data + "%'"
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
				dw_body.SetItem(al_row, "empno_fr", lds_Source.GetItemString(1,"empno"))
				dw_body.object.t_kname_fr.text = lds_Source.GetItemString(1,"kname")
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("start_ymd")
				ib_itemchanged = False 
			END IF
			Destroy  lds_Source	
END CHOOSE

RETURN 0

end event

event ue_insert();call super::ue_insert;/*
dw_body.reset()
dw_body.insertrow(0)
dw_body.setitem(1,'tbit','1')
*/
//IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
dw_body.reset()
dw_body.insertrow(0)
dw_body.setitem(1,'tbit','1')
dw_body.object.t_kname.text = ''
dw_body.object.t_asset_nm.text = ''
dw_body.object.t_d_nm.text = ''
dw_body.object.t_s_nm.text = ''
dw_body.object.t_fr_kname.text = ''
end event

event open;call super::open;string ls_empno, ls_asset_no, ls_empno_fr, ls_asset_nm, ls_d_nm, ls_s_nm, ls_kname, ls_fr_kname
if gsv_cd.gs_cd1 <> '' or isnull(gsv_cd.gs_cd1) then
	dw_body.retrieve(gsv_cd.gs_cd1,gsv_cd.gs_cd2)
	
	ls_empno = dw_body.getitemstring(1, 'empno')
	ls_asset_no = dw_body.getitemstring(1, 'asset_no')
	ls_empno_fr = dw_body.getitemstring(1, 'empno_fr')
	
	SELECT	asset_nm,				
				d_gubn + '('+dbo.sf_inter_nm('961',d_gubn) + ')' d_nm,
				s_gubn + '('+dbo.sf_inter_nm('962',s_gubn) + ')' s_nm
	into     :ls_asset_nm, :ls_d_nm, :ls_s_nm
	FROM		tb_99013_m with (nolock)	
	where asset_no = :ls_asset_no;
	
  SELECT kname       AS kname
  into   :ls_kname
  FROM   VI_93000_1  with (nolock)
  where  empno = :ls_empno;
	 
  SELECT kname       AS kname
  into   :ls_fr_kname
  FROM   VI_93000_1  with (nolock)
  where  empno = :ls_empno_fr;
	

	dw_body.object.t_asset_nm.text = ls_asset_nm
	dw_body.object.t_d_nm.text = ls_d_nm
	dw_body.object.t_s_nm.text = ls_s_nm
	dw_body.object.t_kname.text = ls_kname
	dw_body.object.t_fr_kname.text = ls_fr_kname
	
	gsv_cd.gs_cd1 = ''
	gsv_cd.gs_cd2 = ''
else
//	This.Trigger Event ue_insert()
	dw_body.reset()
	dw_body.insertrow(0)
	dw_body.setitem(1,'tbit','1')	
end if

end event

event pfc_preopen();/* DataWindow Head에 One Row 추가 */
//dw_body.InsertRow(0)

/* DataWindow의 Transction 정의 */
//dw_body.SetTransObject(SQLCA)

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)

/* DataWindow Head에 One Row 추가 */
dw_body.InsertRow(0)



end event

type cb_close from w_com010_e`cb_close within w_99015_d
integer x = 1664
integer width = 306
end type

type cb_delete from w_com010_e`cb_delete within w_99015_d
integer x = 1051
integer width = 306
boolean enabled = true
end type

type cb_insert from w_com010_e`cb_insert within w_99015_d
integer x = 439
integer width = 306
string text = "신규입력"
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_99015_d
integer x = 745
integer width = 306
end type

type cb_update from w_com010_e`cb_update within w_99015_d
integer x = 1358
integer width = 306
end type

type cb_print from w_com010_e`cb_print within w_99015_d
boolean visible = false
integer x = 2866
integer y = 268
end type

type cb_preview from w_com010_e`cb_preview within w_99015_d
boolean visible = false
integer x = 3209
integer y = 268
end type

type gb_button from w_com010_e`gb_button within w_99015_d
integer width = 2011
end type

type cb_excel from w_com010_e`cb_excel within w_99015_d
boolean visible = false
integer x = 3552
integer y = 268
end type

type dw_head from w_com010_e`dw_head within w_99015_d
boolean visible = false
integer x = 2464
integer y = 484
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

type ln_1 from w_com010_e`ln_1 within w_99015_d
integer beginy = 164
integer endx = 1998
integer endy = 164
end type

type ln_2 from w_com010_e`ln_2 within w_99015_d
integer beginy = 168
integer endx = 1998
integer endy = 168
end type

type dw_body from w_com010_e`dw_body within w_99015_d
integer y = 184
integer width = 1993
integer height = 1100
string dataobject = "d_99015_d01"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_body::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)



end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.16                                                  */	
/* 수정일      : 2001.11.16                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "asset_no","empno", "empno_fr"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)
end event

type dw_print from w_com010_e`dw_print within w_99015_d
integer x = 2437
integer y = 672
end type

type dw_1 from datawindow within w_99015_d
boolean visible = false
integer x = 2107
integer y = 212
integer width = 1993
integer height = 1100
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_99015_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemfocuschanged;String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)
end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.16                                                  */	
/* 수정일      : 2001.11.16                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "asset_no","empno", "empno_fr"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

