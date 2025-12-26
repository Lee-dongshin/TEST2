$PBExportHeader$w_47013_e.srw
$PBExportComments$정산 데이터(메이크샵, 이니시스) 입력
forward
global type w_47013_e from w_com010_e
end type
type dw_color from datawindow within w_47013_e
end type
type dw_size from datawindow within w_47013_e
end type
end forward

global type w_47013_e from w_com010_e
dw_color dw_color
dw_size dw_size
end type
global w_47013_e w_47013_e

type variables

DataWindowchild idw_color, idw_size, idw_shop_nm
String is_yymm, is_file_nm, is_shop_nm, is_path_name, is_gubn
end variables

forward prototypes
public subroutine wf_delete ()
public subroutine wf_getfile ()
end prototypes

public subroutine wf_delete ();long i, ll_row_count
string ls_ErrMsg, ls_yymm, ls_order_id, ls_order_num, ls_gubn

ll_row_count = dw_body.RowCount()
ls_yymm = dw_head.getitemstring(1,'yymm')
ls_gubn = dw_head.getitemstring(1,'gubn')


if ls_gubn = 'A' then
	FOR i=1 TO ll_row_count
		ls_order_id = dw_body.getitemstring(i, 'order_id')
		ls_order_num = dw_body.getitemstring(i, 'order_num')
		
		delete
		from tb_45032_h
		where yymm = :ls_yymm
				and order_id = :ls_order_id
				and order_num = :ls_order_num;
	
		commit  USING SQLCA;
	next
elseif ls_gubn = 'B' then
	FOR i=1 TO ll_row_count		
		ls_order_id = dw_body.getitemstring(i, 'order_id')
		
		delete
		from tb_45033_h
		where yymm = :ls_yymm
				and order_id = :ls_order_id;
	
		commit  USING SQLCA;
	next
elseif ls_gubn = 'C' then
	FOR i=1 TO ll_row_count		
		ls_order_id = dw_body.getitemstring(i, 'order_id')
		
		delete
		from tb_45034_h
		where yymm = :ls_yymm
				and order_id = :ls_order_id;
	
		commit  USING SQLCA;
	next
elseif ls_gubn = 'D' then
	FOR i=1 TO ll_row_count		
		ls_order_id = dw_body.getitemstring(i, 'order_id')
		
		delete
		from tb_45035_h
		where yymm = :ls_yymm
				and order_id = :ls_order_id;
	
		commit  USING SQLCA;
	next
elseif ls_gubn = 'E' then
	FOR i=1 TO ll_row_count		
		ls_order_id = dw_body.getitemstring(i, 'order_id')
		
		delete
		from tb_45036_h
		where yymm = :ls_yymm
				and order_id = :ls_order_id;
	
		commit  USING SQLCA;
	next
elseif ls_gubn = 'F' then
	FOR i=1 TO ll_row_count		
		ls_order_id = dw_body.getitemstring(i, 'naver_ord_id')
		
		delete
		from tb_45037_h
		where yymm = :ls_yymm
				and naver_ord_id = :ls_order_id;
	
		commit  USING SQLCA;
	next
elseif ls_gubn = 'G' then
	FOR i=1 TO ll_row_count		
		ls_order_id = dw_body.getitemstring(i, 'order_id')
		
		delete
		from tb_45038_h
		where yymm = :ls_yymm
				and order_id = :ls_order_id;
	
		commit  USING SQLCA;
	next
end if


//messagebox('확인','중복되는 파일이 있습니다. 중복되는 파일은 수정됩니다.')



end subroutine

public subroutine wf_getfile ();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.10.04                                                  */	
/* 수정일      : 2001.10.04                                                  */
/*===========================================================================*/
integer li_FileNum, li_find, li_t,li_cnt_err, li_dup_chk
string  ls_data, ls_null, ls_text, ls_data_chk
Long    i, ll_row_count, ll_found,ll_found2
string ls_yymmdd,  ls_shop_cd, ls_cust_nm, ls_order_no1,ls_order_no2, ls_no, ls_gubn
string ls_yymm, ls_order_id, ls_order_num
long ll_qty	
decimal ldc_sale_price	


ll_row_count = dw_body.RowCount()
ls_yymm = dw_head.getitemstring(1,'yymm')
ls_gubn = dw_head.getitemstring(1,'gubn')

ll_found2 = 0
if ls_gubn = 'A' then
	FOR i=1 TO ll_row_count		
		ls_order_id = dw_body.getitemstring(i,'order_id')
		ls_order_num = dw_body.getitemstring(i,'order_num')
	
		ll_found = 0
					
		select count(*)
		into :ll_found
		from tb_45032_h (nolock)
		where yymm	 = :ls_yymm 
		and order_id = :ls_order_id
		and order_num = :ls_order_num; 
		
		ll_found2 = ll_found + ll_found2
	next
elseif ls_gubn = 'B' then
	FOR i=1 TO ll_row_count		
		ls_order_id = dw_body.getitemstring(i,'order_id')
	
		ll_found = 0
					
		select count(*)
		into :ll_found
		from tb_45033_h (nolock)
		where yymm	 = :ls_yymm 
		and order_id = :ls_order_id; 
		
		ll_found2 = ll_found + ll_found2
	next
elseif ls_gubn = 'C' then
	FOR i=1 TO ll_row_count		
		ls_order_id = dw_body.getitemstring(i,'order_id')
	
		ll_found = 0
					
		select count(*)
		into :ll_found
		from tb_45034_h (nolock)
		where yymm	 = :ls_yymm 
		and order_id = :ls_order_id; 
		
		ll_found2 = ll_found + ll_found2
	next
elseif ls_gubn = 'D' then
	FOR i=1 TO ll_row_count		
		ls_order_id = dw_body.getitemstring(i,'order_id')
	
		ll_found = 0
					
		select count(*)
		into :ll_found
		from tb_45035_h (nolock)
		where yymm	 = :ls_yymm 
		and order_id = :ls_order_id; 
		
		ll_found2 = ll_found + ll_found2
	next
elseif ls_gubn = 'E' then
	FOR i=1 TO ll_row_count		
		ls_order_id = dw_body.getitemstring(i,'order_id')
	
		ll_found = 0
					
		select count(*)
		into :ll_found
		from tb_45036_h (nolock)
		where yymm	 = :ls_yymm 
		and order_id = :ls_order_id; 
		
		ll_found2 = ll_found + ll_found2
	next
elseif ls_gubn = 'F' then
	FOR i=1 TO ll_row_count		
		ls_order_id = dw_body.getitemstring(i,'naver_ord_id')
	
		ll_found = 0
					
		select count(*)
		into :ll_found
		from tb_45037_h (nolock)
		where yymm	 = :ls_yymm 
		and naver_ord_id = :ls_order_id; 
		
		ll_found2 = ll_found + ll_found2
	next
elseif ls_gubn = 'G' then
	FOR i=1 TO ll_row_count		
		ls_order_id = dw_body.getitemstring(i,'order_id')
	
		ll_found = 0
					
		select count(*)
		into :ll_found
		from tb_45038_h (nolock)
		where yymm	 = :ls_yymm 
		and order_id = :ls_order_id; 
		
		ll_found2 = ll_found + ll_found2
	next
end if
if ll_found2 > 0 then 
//	MEssagebox("확인", "총" + "" +  string(ll_found2) + "" + "개의 기입력된 데이터가 있습니다!")
	wf_delete()
end if



end subroutine

on w_47013_e.create
int iCurrent
call super::create
this.dw_color=create dw_color
this.dw_size=create dw_size
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_color
this.Control[iCurrent+2]=this.dw_size
end on

on w_47013_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_color)
destroy(this.dw_size)
end on

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymm)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count,li_cnt_err,li_cnt_err1
string ls_ErrMsg, ls_order_id, ls_order_num, ls_yymm
datetime ld_datetime

ll_row_count = dw_body.RowCount()

IF dw_body.AcceptText() <> 1 THEN RETURN -1



/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

//기존에 있는데이터 수정해서 삭제 하기
idw_status = dw_body.GetItemStatus(1, 0, Primary!)
if idw_status =  NewModified! THEN
	wf_getfile()
end if

ls_yymm = dw_head.getitemstring(1,"yymm")

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */

		dw_body.setitem(i, "yymm", ls_yymm)
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
	if dw_head.getitemstring(1,'gubn') = 'A' then
		 DECLARE sp_47013_useamt_set PROCEDURE FOR sp_47013_useamt_set
				@ps_yymm     = :ls_yymm;
		EXECUTE sp_47013_useamt_set;	
	end if
else
   rollback  USING SQLCA;
	IF isnull(ls_ErrMsg) = FALSE AND Trim(ls_ErrMsg) <> "" THEN 
		MessageBox("SQL 오류", ls_ErrMsg)
	END IF
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"정산년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_gubn = dw_head.GetItemString(1, "gubn")
if IsNull(is_gubn) or Trim(is_gubn) = "" then
   MessageBox(ls_title,"구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubn")
   return false
end if


return true
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_47013_e","0")
end event

type cb_close from w_com010_e`cb_close within w_47013_e
end type

type cb_delete from w_com010_e`cb_delete within w_47013_e
end type

type cb_insert from w_com010_e`cb_insert within w_47013_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_47013_e
end type

type cb_update from w_com010_e`cb_update within w_47013_e
end type

type cb_print from w_com010_e`cb_print within w_47013_e
end type

type cb_preview from w_com010_e`cb_preview within w_47013_e
end type

type gb_button from w_com010_e`gb_button within w_47013_e
end type

type cb_excel from w_com010_e`cb_excel within w_47013_e
end type

type dw_head from w_com010_e`dw_head within w_47013_e
integer height = 140
string dataobject = "d_47013_h01"
end type

event dw_head::buttonclicking;call super::buttonclicking;/* 화일 탐색 */
Long   ll_rtn, ll_xls_ret
String ls_filename, ls_name, ls_path, ls_msg, ls_file_name1, ls_shop_nm
Long	 i, ll_rowcnt

Oleobject xlapp

SetPointer(HourGlass!)
//dw_c01.AcceptText()
dw_head.AcceptText()

ll_rtn = GetFileOpenName("엑셀파일",   &
			+ ls_filename, ls_name, "XLSX", &
			+ " XLSX Files (*.XLSX),*.XLSX," &
			+ " XLS Files (*.XLS),*.XLS," &
			+ " CSV Files (*.CSV),*.CSV")
If ll_rtn   =   1 Then
	dw_head.Object.path[1]   = ls_filename
	dw_head.Object.path_name[1]   = ls_name
End If

ls_filename = dw_head.Object.path[1]
ls_name     = dw_head.Object.path_name[1]		
ls_path     = MidA(ls_filename, 1 , LenA(ls_filename) - LenA(ls_name))

If IsNull(ls_filename) Or Trim(ls_filename) = '' Then 
	ls_msg = '엑셀 파일을 선택하여 주세요! ..........'
	Messagebox('확인',ls_msg)
	dw_head.SetFocus()
	dw_head.SetColumn("path")
	Return
End If

If IsNull(ls_name) Or Trim(ls_name) = '' Then 
	ls_msg = '엑셀 파일을 선택하여 주세요! ..........'
	Messagebox('확인',ls_msg)
	dw_head.SetFocus()
	dw_head.SetColumn("path_text")
	Return
End If

//엑셀용 OleObject를 열어 준다.
xlApp       = Create OLEObject    //엑셀용 OLE Object를 선언 한다.
ll_xls_ret = xlApp.ConnectToNewObject("excel.application") //엑셀과 연결하여 준다.
If ll_xls_ret < 0 Then
	ls_msg = '엑셀 프로그램을 사용하는데 실패 하였습니다! 포멧에 정확히 맞추어 다시 작업하세요!'
	Messagebox('확인',ls_msg)
	Return 
End If

xlApp.Application.Workbooks.Open(ls_filename) //화일을 엑셀에 맞추어서 열어 준다.

ls_file_name1 = ls_path + string(today(),'yyyymmdd') + string(now(),'hhmmss') + '_tmp.txt'

xlApp.Application.Activeworkbook.Saveas(ls_file_name1, -4158) //엑셀화일을 텍스트화일로 변환저장
xlApp.Application.Workbooks.close()
xlApp.DisConnectObject() //엑셀 오브젝트를 파괴한다.

dw_body.Reset()
//데이타 윈도우에 임포트 한다.
dw_body.importfile(ls_file_name1)
		
//필수자료 없는 데이타삭제
ll_rowcnt = dw_body.rowcount()
For i = ll_rowcnt To 1 STEP -1
	If i < 1 Then Exit
	ls_shop_nm = dw_body.object.shop_nm[i]
	If ls_shop_nm = "" Or IsNull(ls_shop_nm) Then
		dw_body.DeleteRow(i)
	End If	
Next

FileDelete(ls_file_name1)

//messagebox('완료', 'Excel 불러오기가 완료되었습니다! ')

parent.Trigger Event ue_button(1, ll_rtn)
cb_update.enabled = true
parent.Trigger Event ue_msg(1, ll_rtn)

		
		
end event

event dw_head::itemchanged;call super::itemchanged;int li_ret
string ls_gubn

dw_head.accepttext()
ls_gubn = dw_head.getitemstring(1,'gubn')

CHOOSE CASE dwo.name
	CASE "gubn"	     //  Popup 검색창이 존재하는 항목 
			if ls_gubn = 'A' then // 메이크샵
				dw_body.dataobject = 'd_47013_d01'
			elseif ls_gubn = 'B' then //실시간계좌
				dw_body.dataobject = 'd_47013_d02'
			elseif ls_gubn = 'C' then //카드결제
				dw_body.dataobject = 'd_47013_d03'
			elseif ls_gubn = 'D' then //가상계좌
				dw_body.dataobject = 'd_47013_d04'
			elseif ls_gubn = 'E' then //휴대폰결제				
				dw_body.dataobject = 'd_47013_d05'
			elseif ls_gubn = 'F' then //네이버페이
				dw_body.dataobject = 'd_47013_d06'
			elseif ls_gubn = 'G' then //페이코
				dw_body.dataobject = 'd_47013_d07'
			end if
			dw_body.SetTransObject(SQLCA)			
END CHOOSE

cb_update.enabled = true
end event

type ln_1 from w_com010_e`ln_1 within w_47013_e
integer beginy = 316
integer endy = 316
end type

type ln_2 from w_com010_e`ln_2 within w_47013_e
integer beginy = 320
integer endy = 320
end type

type dw_body from w_com010_e`dw_body within w_47013_e
integer x = 9
integer y = 328
integer width = 3557
integer height = 1676
string dataobject = "d_47013_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;

  This.GetChild("color", idw_color )
  idw_color.SetTransObject(SQLCA)
  
  This.GetChild("size", idw_size )
  idw_color.SetTransObject(SQLCA)
end event

type dw_print from w_com010_e`dw_print within w_47013_e
integer x = 2487
integer y = 560
end type

type dw_color from datawindow within w_47013_e
boolean visible = false
integer x = 2752
integer y = 948
integer width = 366
integer height = 428
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_43015_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_size from datawindow within w_47013_e
boolean visible = false
integer x = 3141
integer y = 944
integer width = 411
integer height = 432
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_43015_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

