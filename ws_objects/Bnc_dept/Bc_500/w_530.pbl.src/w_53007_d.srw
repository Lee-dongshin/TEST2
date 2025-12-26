$PBExportHeader$w_53007_d.srw
$PBExportComments$일일 판매 현황 (영업보고)
forward
global type w_53007_d from w_com010_e
end type
end forward

global type w_53007_d from w_com010_e
integer width = 3685
integer height = 2288
end type
global w_53007_d w_53007_d

type variables
DataWindowChild idw_brand

String is_brand, is_yymmdd

end variables

on w_53007_d.create
call super::create
end on

on w_53007_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if




if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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




is_yymmdd = Trim(String(dw_head.GetItemDate(1, "yymmdd"), 'yyyymmdd'))
if IsNull(is_yymmdd) or is_yymmdd = "" then
   MessageBox(ls_title,"판매 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

return true

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.19                                                  */	
/* 수정일      : 2002.03.19                                                  */
/*===========================================================================*/

long ll_user_chk

if dw_body.AcceptText() <> 1 then return

/* 변경된 자료가 있을때 저장여부를 확인*/
IF ib_changed THEN 
   CHOOSE CASE gf_update_yn(This.title)
	   CASE 1
		   IF This.Trigger Event ue_update() < 1 THEN
			   return
		   END IF		
	   CASE 3
		   return
   END CHOOSE
END IF

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF


select count(empno)
into :ll_user_chk
from mis.dbo.thb01
where dept_code in ('5000','5200','6000','6100',  'K000','K120','T400' )
and   goout_gubn = '1'
and   empno = :gs_user_id ;

if ll_user_chk > 0 then
	
	SQLCA.SP_53007('MIDD', is_brand, is_yymmdd, gs_user_id)
	
	IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN 
		COMMIT;
		il_rows = dw_body.Retrieve(is_brand, is_yymmdd)
	Else
		ROLLBACK;
		il_rows = -1
		MessageBox("SQL 오류", SQLCA.SQLERRTEXT)
	END IF 

else
		messagebox("경고!", "마감기능은 영업부 직원만 가능합니다!")
		il_rows = -1
end if	

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
//         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
//         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 매출 생성 */
      if al_rows > 0 then
//			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
//      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.19                                                  */	
/* 수정일      : 2002.03.19                                                  */
/*===========================================================================*/
long ll_user_chk
Integer li_result

if dw_body.AcceptText() <> 1 then return

/* 변경된 자료가 있을때 저장여부를 확인*/
IF ib_changed THEN 
   CHOOSE CASE gf_update_yn(This.title)
	   CASE 1
		   IF This.Trigger Event ue_update() < 1 THEN
			   return
		   END IF		
	   CASE 3
		   return
   END CHOOSE
END IF

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF



li_result = MessageBox("경고!", "최종데이터가 변경되며 최종 수정자로 기록됩니다. 재마감 하시겠습니까?", Question!, YesNo! )


select count(empno)
into :ll_user_chk
from mis.dbo.thb01
where dept_code in ('5000','5200','6000','6100',  'K000','K120','T400' )
and   goout_gubn = '1'
and   empno = :gs_user_id ;

if ll_user_chk > 0 then
	
	IF li_result = 1 THEN
			SQLCA.SP_53007('LAST', is_brand, is_yymmdd, gs_user_id)
		
		IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN 
			COMMIT;
			il_rows = dw_body.Retrieve(is_brand, is_yymmdd)
		Else
			ROLLBACK;
			il_rows = -1
			MessageBox("SQL 오류", SQLCA.SQLERRTEXT)
		END IF 
	
	END IF	
	
else	
	messagebox("경고!", "마감기능은 영업부 직원만 가능합니다!")
	il_rows = -1
end if

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.19                                                  */	
/* 수정일      : 2002.03.19                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ll_row_count = dw_body.RowCount()

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
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

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Integer li_result

li_result = MessageBox("인쇄구분", "가마감 데이터를 미리보기 하시겠습니까? ~n~r ('YES': 가마감, 'NO': 마감)", Question!, YesNoCancel!)
If li_result = 3 Then Return

This.Trigger Event ue_title ()

dw_print.Retrieve(is_brand, is_yymmdd, li_result)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.19                                                  */	
/* 수정일      : 2002.03.19                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text =    '" + is_pgm_id + "'" + &
            "t_user_id.Text =  '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text =    '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_yymmdd.Text =   '" + String(is_yymmdd, '@@@@/@@/@@') + "'"

dw_print.Modify(ls_modify)

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Integer li_result

li_result = MessageBox("인쇄구분", "가마감 데이터를 인쇄 하시겠습니까? ~n~r ('YES': 가마감, 'NO': 마감)", Question!, YesNoCancel!)
If li_result = 3 Then Return

This.Trigger Event ue_title()

dw_print.Retrieve(is_brand, is_yymmdd, li_result)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53007_d","0")
end event

event ue_excel();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm
Integer li_result
integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if



li_result = MessageBox("인쇄구분", "가마감 데이터를 EXCEL로  만드시겠습니까? ~n~r ('YES': 가마감, 'NO': 마감)", Question!, YesNoCancel!)
If li_result = 3 Then Return

This.Trigger Event ue_title ()
Old_pointer = SetPointer(HourGlass!)
dw_print.Retrieve(is_brand, is_yymmdd, li_result)
li_ret = dw_print.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

type cb_close from w_com010_e`cb_close within w_53007_d
end type

type cb_delete from w_com010_e`cb_delete within w_53007_d
boolean enabled = true
string text = "마감매출(&L)"
end type

type cb_insert from w_com010_e`cb_insert within w_53007_d
string text = "중간매출(&M)"
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_53007_d
end type

type cb_update from w_com010_e`cb_update within w_53007_d
end type

type cb_print from w_com010_e`cb_print within w_53007_d
end type

type cb_preview from w_com010_e`cb_preview within w_53007_d
end type

type gb_button from w_com010_e`gb_button within w_53007_d
end type

type cb_excel from w_com010_e`cb_excel within w_53007_d
end type

type dw_head from w_com010_e`dw_head within w_53007_d
integer height = 124
string dataobject = "d_53007_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_e`ln_1 within w_53007_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_e`ln_2 within w_53007_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_e`dw_body within w_53007_d
integer y = 348
integer height = 1692
string dataobject = "d_53007_d01"
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.19                                                  */	
/* 수정일      : 2002.03.19                                                  */
/*===========================================================================*/
CHOOSE CASE dwo.name
	CASE "last_amt1" 
		This.SetItem(row, "last_amt", This.GetItemDecimal(row, "last_amt3") + This.GetItemDecimal(row, "last_amt4") + Dec(data))
	CASE "last_amt3" 
		This.SetItem(row, "last_amt", This.GetItemDecimal(row, "last_amt1") + This.GetItemDecimal(row, "last_amt4") + Dec(data))
	CASE "last_amt4" 
		This.SetItem(row, "last_amt", This.GetItemDecimal(row, "last_amt1") + This.GetItemDecimal(row, "last_amt3") + Dec(data))
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

event dw_body::clicked;call super::clicked;uint rtn, wstyle
string 	  	ls_file_name, ls_url

CHOOSE CASE dwo.name
	CASE "shop_nm" 
		ls_url = dw_body.getitemstring(row, "km_new")
		ls_file_name = "C:\\Program Files\\Internet Explorer\\iexplore.exe  "
		ls_file_name = ls_file_name + ls_url
		wstyle = 1				
		rtn = WinExec(ls_file_name, wstyle)
END CHOOSE
end event

type dw_print from w_com010_e`dw_print within w_53007_d
integer width = 2542
integer height = 848
string dataobject = "d_53007_r01"
end type

