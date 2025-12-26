$PBExportHeader$w_99014_d.srw
$PBExportComments$고정자산 사용현황
forward
global type w_99014_d from w_com010_e
end type
type cb_1 from commandbutton within w_99014_d
end type
type tab_1 from tab within w_99014_d
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tab_1 from tab within w_99014_d
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_99014_d from w_com010_e
cb_1 cb_1
tab_1 tab_1
end type
global w_99014_d w_99014_d

type variables
DataWindowChild idw_d_gubn, idw_s_gubn

String is_item, is_saupjang, is_asset_nm, is_cust_cd, is_d_gubn, is_s_gubn, is_tbit, is_fr_ymd, is_to_ymd
string is_empno, is_m_gubn



end variables

on w_99014_d.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.tab_1
end on

on w_99014_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.tab_1)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : M.S.I (김 태범)                                             */	
/* 작성일      : 2001.05.31                                                  */	
/* 수성일      : 2001.05.31                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//il_rows = dw_body.retrieve(is_item, is_asset_nm, is_cust_cd, is_d_gubn, is_s_gubn, is_tbit, is_fr_ymd, is_to_ymd)
if tab_1.selectedtab = 1 then
	il_rows = tab_1.tabpage_1.dw_1.retrieve(is_m_gubn, is_item, is_asset_nm, is_d_gubn, is_s_gubn, is_tbit, is_empno)
	IF il_rows > 0 THEN
   	tab_1.tabpage_1.dw_1.SetFocus()
	END IF
elseif tab_1.selectedtab = 2 then
	il_rows = tab_1.tabpage_2.dw_2.retrieve(is_m_gubn, is_item, is_asset_nm, is_d_gubn, is_s_gubn, is_tbit, is_empno)
	IF il_rows > 0 THEN
   	tab_1.tabpage_2.dw_2.SetFocus()
	END IF	
else 
	il_rows = tab_1.tabpage_3.dw_3.retrieve(is_m_gubn, is_item, is_asset_nm, is_d_gubn, is_s_gubn, is_tbit, is_empno)
	IF il_rows > 0 THEN
   	tab_1.tabpage_3.dw_3.SetFocus()
	END IF	
end if
dw_print.SetTransObject(SQLCA)
dw_print.retrieve(is_m_gubn, is_item, is_asset_nm, is_d_gubn, is_s_gubn, is_tbit, is_empno)
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

is_m_gubn			= dw_head.getitemstring(1,'m_gubn')
if IsNull(is_m_gubn) or is_m_gubn = "" or is_m_gubn = "전체" then
	is_m_gubn = '%'
end if

is_item			= dw_head.getitemstring(1,'item')
if IsNull(is_item) or is_item = "" or is_item = "전체" then
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

is_d_gubn		= dw_head.getitemstring(1,'d_gubn')
if IsNull(is_d_gubn) or is_d_gubn = "" or is_d_gubn = "전체" then
	is_d_gubn = '%'
end if

is_s_gubn		= dw_head.getitemstring(1,'s_gubn')
if IsNull(is_s_gubn) or is_s_gubn = "" or is_s_gubn = "전체" then
	is_s_gubn = '%'
end if

is_tbit			= dw_head.getitemstring(1,'tbit')
if IsNull(is_tbit) or is_tbit = "" then
	is_tbit = '%'
end if

is_empno		= dw_head.getitemstring(1,'empno_h')
if IsNull(is_empno) or is_empno = "" then
	is_empno = '%'	
end if

/*
is_cust_cd		= dw_head.getitemstring(1,'cust_cd')
if IsNull(is_cust_cd) or is_cust_cd = "" then
	is_cust_cd = '%'
end if

is_fr_ymd		= dw_head.getitemstring(1,'fr_ymd')
if IsNull(is_fr_ymd) or is_fr_ymd = "" then
	is_fr_ymd = '00000000'
end if

is_to_ymd		= dw_head.getitemstring(1,'to_ymd')
if IsNull(is_to_ymd) or is_to_ymd = "" then
	is_to_ymd = '99999999'
end if

*/
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
/*
		ls_yymmdd = dw_body.getitemstring(i, 'start_ymd')
		ls_item   = dw_body.getitemstring(i, 'item')
		
		//순번채번		
		SELECT CAST(ISNULL(MAX(right(asset_no,3)), '0') AS INT)
		  INTO :ll_seq_no
		  FROM tb_99013_m
		 WHERE start_ymd = :ls_yymmdd;
		 
		If SQLCA.SQLCODE <> 0 Then 
			MessageBox("저장오류", "의뢰번호 채번에 실패하였습니다!")
			Return -1
		End If
	
		ls_seq_no = String(ll_seq_no + 1, '000')
		
		dw_body.Setitem(i, "asset_no", ls_item+ls_yymmdd+ls_seq_no)
*/
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
string     ls_part_cd, ls_empno, ls_g1, ls_g2, ls_g3, ls_g4, ls_kname, ls_jik
DataStore  lds_Source
Boolean    lb_check

dw_body.accepttext()

CHOOSE CASE as_column

	CASE "empno_h"
			is_empno = dw_head.getitemstring(1, 'empno_h')
			IF ai_div = 1 THEN
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_head.SetItem(al_row, "empno_nm_h", "")
					RETURN 0
				END IF 
			END IF
			
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사용자 코드 검색" 
			gst_cd.datawindow_nm   = "d_com994"
			gst_cd.default_where   = " WHERE goout_gubn like '%'"
	
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
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "empno_h", lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "empno_nm_h", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("fr_yymm")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source			
			
END CHOOSE

RETURN 0

end event

event pfc_preopen();call super::pfc_preopen;/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)

inv_resize.of_Register(cb_1, "FixedToRight")



/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 		   									  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_3.dw_3, "ScaleToRight&Bottom")


/* DataWindow의 Transction 정의 */
tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
dw_print.SetTransObject(SQLCA)
end event

event ue_insert();call super::ue_insert;long i, ll_row_count

ll_row_count = dw_body.RowCount()

FOR i=1 TO ll_row_count
	dw_body.setitem(i,'tbit','1')
next
end event

event ue_preview();call super::ue_preview;This.Trigger Event ue_title()
end event

event ue_print();call super::ue_print;This.Trigger Event ue_title()
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

event open;call super::open;dw_head.setitem(1,'m_gubn','전체')
dw_head.setitem(1,'item','전체')
dw_head.setitem(1,'saupjang','%')
dw_head.setitem(1,'tbit','1')
dw_head.setitem(1,'d_gubn','전체')
dw_head.setitem(1,'s_gubn','전체')


end event

type cb_close from w_com010_e`cb_close within w_99014_d
end type

type cb_delete from w_com010_e`cb_delete within w_99014_d
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_99014_d
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_99014_d
end type

type cb_update from w_com010_e`cb_update within w_99014_d
end type

type cb_print from w_com010_e`cb_print within w_99014_d
end type

type cb_preview from w_com010_e`cb_preview within w_99014_d
end type

type gb_button from w_com010_e`gb_button within w_99014_d
end type

type cb_excel from w_com010_e`cb_excel within w_99014_d
end type

type dw_head from w_com010_e`dw_head within w_99014_d
integer x = 14
integer y = 160
integer width = 3584
integer height = 196
string dataobject = "d_99014_h01"
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

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
/*===========================================================================*/


String ls_d_gubn

dw_head.accepttext()

CHOOSE CASE dwo.name
	CASE "d_gubn"
		ls_d_gubn = This.GetItemString(1, "d_gubn")
		This.GetChild("s_gubn", idw_s_gubn)
		idw_s_gubn.Retrieve('962', ls_d_gubn)
		idw_s_gubn.InsertRow(1)
		idw_s_gubn.SetItem(1, "inter_cd", '%')
		idw_s_gubn.SetItem(1, "inter_nm", '전체')
	CASE "shop_cd_h", "empno_h"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
END CHOOSE






end event

type ln_1 from w_com010_e`ln_1 within w_99014_d
integer beginy = 364
integer endy = 364
end type

type ln_2 from w_com010_e`ln_2 within w_99014_d
integer beginy = 368
integer endy = 368
end type

type dw_body from w_com010_e`dw_body within w_99014_d
boolean visible = false
integer x = 1861
integer y = 728
integer width = 782
integer height = 872
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

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.16                                                  */	
/* 수정일      : 2001.11.16                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "asset_no","empno"	     //  Popup 검색창이 존재하는 항목 
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

event dw_body::doubleclicked;call super::doubleclicked;//gs_cd_search.cd1 = dw_body.getitemstring(row,'empno')

//gstr_code.code1 = dw_body.getitemstring(row,'empno')
//gstr_code.code2 = dw_body.getitemstring(row,'asset_no')

gsv_cd.gs_cd1 = dw_body.getitemstring(row,'empno')
gsv_cd.gs_cd2 = dw_body.getitemstring(row,'asset_no')


//OpenWithParm(w_99017_e, gsv_cd)
OpenWithParm(w_99015_d, gsv_cd)
end event

type dw_print from w_com010_e`dw_print within w_99014_d
integer x = 567
integer y = 736
integer width = 837
integer height = 428
string dataobject = "d_99014_r01"
end type

type cb_1 from commandbutton within w_99014_d
integer x = 2459
integer y = 44
integer width = 402
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "사용등록"
end type

event clicked;//open(w_99018_e)
open(w_99015_d)
end event

type tab_1 from tab within w_99014_d
integer x = 5
integer y = 376
integer width = 3598
integer height = 1640
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

event clicked;CHOOSE CASE index
	CASE 1
		dw_print.dataobject = 'd_99014_r01'
	CASE 2
		dw_print.dataobject = 'd_99014_r02'
	CASE 3
		dw_print.dataobject = 'd_99014_r01'			
END CHOOSE

Trigger Event ue_retrieve()
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3561
integer height = 1528
long backcolor = 79741120
string text = "조직별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within tabpage_1
integer y = 12
integer width = 3552
integer height = 1512
integer taborder = 20
string title = "none"
string dataobject = "d_99014_d01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;//gs_cd_search.cd1 = dw_body.getitemstring(row,'empno')

//gstr_code.code1 = dw_body.getitemstring(row,'empno')
//gstr_code.code2 = dw_body.getitemstring(row,'asset_no')

gsv_cd.gs_cd1 = tab_1.tabpage_1.dw_1.getitemstring(row,'empno')
gsv_cd.gs_cd2 = tab_1.tabpage_1.dw_1.getitemstring(row,'asset_no')


//OpenWithParm(w_99018_e, gsv_cd)
OpenWithParm(w_99015_d, gsv_cd)
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3561
integer height = 1528
long backcolor = 79741120
string text = "개인별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_2
integer y = 12
integer width = 3552
integer height = 1512
integer taborder = 10
string title = "none"
string dataobject = "d_99014_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;//gs_cd_search.cd1 = dw_body.getitemstring(row,'empno')

//gstr_code.code1 = dw_body.getitemstring(row,'empno')
//gstr_code.code2 = dw_body.getitemstring(row,'asset_no')

gsv_cd.gs_cd1 = tab_1.tabpage_2.dw_2.getitemstring(row,'empno')
gsv_cd.gs_cd2 = tab_1.tabpage_2.dw_2.getitemstring(row,'asset_no')


//OpenWithParm(w_99017_e, gsv_cd)
OpenWithParm(w_99015_d, gsv_cd)
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3561
integer height = 1528
long backcolor = 79741120
string text = "분류별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from datawindow within tabpage_3
integer y = 12
integer width = 3552
integer height = 1512
integer taborder = 10
string title = "none"
string dataobject = "d_99014_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;//gs_cd_search.cd1 = dw_body.getitemstring(row,'empno')

//gstr_code.code1 = dw_body.getitemstring(row,'empno')
//gstr_code.code2 = dw_body.getitemstring(row,'asset_no')

gsv_cd.gs_cd1 = tab_1.tabpage_3.dw_3.getitemstring(row,'empno')
gsv_cd.gs_cd2 = tab_1.tabpage_3.dw_3.getitemstring(row,'asset_no')


//OpenWithParm(w_99017_e, gsv_cd)
OpenWithParm(w_99015_d, gsv_cd)
end event

