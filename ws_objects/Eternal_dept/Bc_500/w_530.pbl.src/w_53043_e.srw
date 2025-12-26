$PBExportHeader$w_53043_e.srw
$PBExportComments$판매처리용파일등록
forward
global type w_53043_e from w_com010_e
end type
type cb_copy from commandbutton within w_53043_e
end type
type dw_1 from datawindow within w_53043_e
end type
type cb_1 from commandbutton within w_53043_e
end type
type st_1 from statictext within w_53043_e
end type
type p_1 from picture within w_53043_e
end type
type cb_form from commandbutton within w_53043_e
end type
type hpb_1 from hprogressbar within w_53043_e
end type
type st_3 from statictext within w_53043_e
end type
type st_4 from statictext within w_53043_e
end type
end forward

global type w_53043_e from w_com010_e
integer width = 3694
cb_copy cb_copy
dw_1 dw_1
cb_1 cb_1
st_1 st_1
p_1 p_1
cb_form cb_form
hpb_1 hpb_1
st_3 st_3
st_4 st_4
end type
global w_53043_e w_53043_e

type variables
DataWindowChild idw_sale_type_1, idw_sale_type_2, idw_dep_seq, idw_disc_seq
String is_brand, is_shop_div, is_shop_grp 
String is_year,  is_season,   is_yymmdd, is_data_opt
String is_job_opt 
DataStore ids_copy

end variables

forward prototypes
public function boolean wf_set_data1 (string as_shop_cd)
public function boolean wf_set_data2 (string as_shop_cd)
end prototypes

public function boolean wf_set_data1 (string as_shop_cd);/*----------------------------------------------------------------*/
/* 시즌별마진율 자료 편집                                         */
/*----------------------------------------------------------------*/
/*
Long i, ll_row
datetime ld_datetime
// 시스템 날짜를 가져온다 
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return False
END IF

// 임시자료 생성
ll_row = dw_1.RowCount()
FOR i = 1 TO ll_row
   idw_status = dw_1.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN
      dw_1.Setitem(i, "shop_cd",   as_shop_cd)
      dw_1.Setitem(i, "brand",     is_brand)
      dw_1.Setitem(i, "year",      is_year)
      dw_1.Setitem(i, "season",    is_season)
      dw_1.Setitem(i, "start_ymd", is_fr_ymd)
      dw_1.Setitem(i, "end_ymd",   'NEW_DATA')
      dw_1.Setitem(i, "mod_id",    gs_user_id)   // sp에서 reg로 처리 
      dw_1.Setitem(i, "mod_dt",    ld_datetime)
	ELSEIF idw_status = DataModified! THEN		
      dw_1.Setitem(i, "shop_cd",   as_shop_cd)
      dw_1.Setitem(i, "end_ymd",   'NEW_DATA') 
      dw_1.Setitem(i, "mod_id",    gs_user_id)
      dw_1.Setitem(i, "mod_dt",    ld_datetime)
	END IF
NEXT

IF dw_1.update(TRUE, FALSE) <> 1 THEN RETURN FALSE
*/
Return True 

end function

public function boolean wf_set_data2 (string as_shop_cd);///*----------------------------------------------------------------*/
///* 품번별마진율 자료편집                                          */
///*----------------------------------------------------------------*/
//Long i, ll_row
//datetime ld_datetime
///* 시스템 날짜를 가져온다 */
//IF gf_sysdate(ld_datetime) = FALSE THEN
//	Return False
//END IF
//
//// 수정후 자료는 'NEW_DATA'로 생성
//ll_row = tab_1.tabpage_1.dw_2.RowCount()
//FOR i = 1 TO ll_row
//   idw_status = tab_1.tabpage_1.dw_2.GetItemStatus(i, 0, Primary!)
//   IF idw_status = NewModified! THEN
//      tab_1.tabpage_1.dw_2.Setitem(i, "shop_cd",   as_shop_cd)
//      tab_1.tabpage_1.dw_2.Setitem(i, "brand",     is_brand)
//      tab_1.tabpage_1.dw_2.Setitem(i, "year",      is_year)
//      tab_1.tabpage_1.dw_2.Setitem(i, "season",    is_season)
//      tab_1.tabpage_1.dw_2.Setitem(i, "start_ymd", is_fr_ymd)
//      tab_1.tabpage_1.dw_2.Setitem(i, "end_ymd",   'NEW_DATA')
//      tab_1.tabpage_1.dw_2.Setitem(i, "mod_id",    gs_user_id)
//      tab_1.tabpage_1.dw_2.Setitem(i, "mod_dt",    ld_datetime)
//	ELSEIF idw_status = DataModified! THEN		
//      tab_1.tabpage_1.dw_2.Setitem(i, "shop_cd",   as_shop_cd)
//      tab_1.tabpage_1.dw_2.Setitem(i, "end_ymd",   'NEW_DATA') 
//      tab_1.tabpage_1.dw_2.Setitem(i, "mod_id",    gs_user_id)
//      tab_1.tabpage_1.dw_2.Setitem(i, "mod_dt",    ld_datetime)
//	END IF
//NEXT
//
//IF tab_1.tabpage_1.dw_2.update(TRUE, FALSE) <> 1 THEN RETURN FALSE
//
Return True 

end function

on w_53043_e.create
int iCurrent
call super::create
this.cb_copy=create cb_copy
this.dw_1=create dw_1
this.cb_1=create cb_1
this.st_1=create st_1
this.p_1=create p_1
this.cb_form=create cb_form
this.hpb_1=create hpb_1
this.st_3=create st_3
this.st_4=create st_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_copy
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.p_1
this.Control[iCurrent+6]=this.cb_form
this.Control[iCurrent+7]=this.hpb_1
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_4
end on

on w_53043_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_copy)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.p_1)
destroy(this.cb_form)
destroy(this.hpb_1)
destroy(this.st_3)
destroy(this.st_4)
end on

event pfc_preopen();call super::pfc_preopen;/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)

/* DataWindow  One Row 추가 */
dw_1.InsertRow(0)


/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_1, "ScaleToRight")


end event

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "YYMMDD" ,string(ld_datetime,"yyyymmdd"))
dw_head.setitem(1, 'brand', gs_brand)


select data_level
into :is_data_opt
from tb_93010_m
where person_id = :gs_user_id;


hpb_1.Position = 0
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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


is_job_opt = dw_head.GetItemString(1, "UPLOAD_OPT")
if IsNull(is_job_opt) or Trim(is_job_opt) = "" then
   MessageBox(ls_title,"작업구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("UPLOAD_OPT")
   return false
end if



is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if



if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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





Return true
end event

event ue_retrieve();call super::ue_retrieve;

Long   ll_rtn, ll_xls_ret
String ls_filename, ls_name, ls_path, ls_msg, ls_file_name1, ls_shop_type,ls_chk_style , ls_dc_chk, ls_STYLE, LS_COLOR, LS_SIZE, ls_shop_cd, ls_chno
Long	 i, ll_rowcnt,ll_row_count1, LL_STYLE_CHK, ll_shop_chk

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
hpb_1.Position = 0

Oleobject xlapp

dw_1.reset()
dw_1.insertrow(1)
dw_BODY.Reset()

SetPointer(HourGlass!)
//dw_c01.AcceptText()
dw_1.AcceptText()

ll_rtn = GetFileOpenName("엑셀파일",   &
			+ ls_filename, ls_name, "XLS", &
			+ " XLS Files (*.XLS),*.XLS")
If ll_rtn   =   1 Then
	dw_1.Object.path[1]   = ls_filename
	dw_1.Object.path_name[1]   = ls_name
End If

ls_filename = dw_1.Object.path[1]
ls_name     = dw_1.Object.path_name[1]		
ls_path     = MidA(ls_filename, 1 , LenA(ls_filename) - LenA(ls_name))

If IsNull(ls_filename) Or Trim(ls_filename) = '' Then 
	ls_msg = '엑셀 파일을 선택하여 주세요! ..........'
	Messagebox('확인',ls_msg)
	dw_1.SetFocus()
	dw_1.SetColumn("path")
	Return
End If

If IsNull(ls_name) Or Trim(ls_name) = '' Then 
	ls_msg = '엑셀 파일을 선택하여 주세요! ..........'
	Messagebox('확인',ls_msg)
	dw_1.SetFocus()
	dw_1.SetColumn("path_text")
	Return
End If

dw_BODY.Reset()

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


xlApp.Application.Visible = False

xlApp.application.workbooks(1).SaveAs(ls_file_name1 , -4158) //===== 텍스트로 저장될 경로
xlApp.application.workbooks(1).Saved = True
xlApp.Application.Quit
xlApp.DisConnectObject()
Destroy xlApp

//xlApp.Application.Activeworkbook.Saveas(ls_file_name1, -4158) //엑셀화일을 텍스트화일로 변환저장  
//xlApp.Application.Workbooks.Saved = TRUE
//xlApp.Application.Workbooks.close()
//xlApp.DisConnectObject() //엑셀 오브젝트를 파괴한다.

dw_BODY.Reset()
//데이타 윈도우에 임포트 한다.
dw_BODY.importfile(ls_file_name1)
		
//필수자료 없는 데이타삭제




ll_rowcnt = dw_BODY.rowcount()
For i = ll_rowcnt To 1 STEP -1
	If i < 1 Then Exit
	ls_STYLE = dw_BODY.object.STYLE[i]
	If ls_STYLE = "" Or IsNull(ls_STYLE) Then
		dw_BODY.DeleteRow(i)
	End If	
	
	If ls_STYLE = "품번" Then
		dw_BODY.DeleteRow(i)
	End If		
Next

FileDelete(ls_file_name1)

messagebox('완료', 'Excel 불러오기가 완료되었습니다! ')


		
ls_chk_style = ""
ll_row_count1 = dw_BODY.RowCount()
LL_STYLE_CHK = 0
ll_shop_chk = 0

FOR i=1 TO ll_row_count1
   ls_shop_cd = 	dw_BODY.GetItemString(i, "shop_cd")
	ls_style = 	dw_BODY.GetItemString(i, "style")
	ls_chno = 	dw_BODY.GetItemString(i, "chno")	
	ls_COLOR = 	dw_BODY.GetItemString(i, "COLOR")
	ls_SIZE = 	dw_BODY.GetItemString(i, "SIZE")	
	
	select dbo.SF_STYLE_CHK1(:ls_style, :ls_chno, :LS_COLOR, :LS_SIZE)
	into :ls_dc_chk
	from dual;
	
	if ls_dc_chk <> "정상" then
		LL_STYLE_CHK = LL_STYLE_CHK + 1
	end if

	dw_BODY.SETItem(i, "CHK_STYLE",ls_dc_chk )	


	if LeftA(ls_shop_cd,1) <> is_brand then
		ll_shop_chk = ll_shop_chk + 1
	end if
	
	hpb_1.Position = ll_row_count1 * (i / ll_row_count1)

   
NEXT


if ll_shop_chk <> 0 then
	messagebox("알림!", STRING(ll_shop_chk, "0000") + "건의 다른 브랜드 매장이 포함되어 있습니다!  파일을 수정 후 재등록 해주세요!"		)
end if		

if LL_STYLE_CHK <> 0 then
	messagebox("알림!", STRING(LL_STYLE_CHK, "0000") + "건의 품번오류가 있습니다! 파일을 수정 후 재등록 해주세요!"		)
else 
	hpb_1.Position = 100
	dw_body.SetFocus()		
	Trigger Event ue_button(4, ll_row_count1)
end if		




This.Trigger Event ue_msg(1, ll_row_count1)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;
/*===========================================================================*/
String     ls_style, ls_chno, ls_shop_type
Boolean    lb_check 
DataStore  lds_Source
/*
CHOOSE CASE as_column
	CASE "style"				
			IF ai_div = 1 THEN 	
				IF gf_style_chk(as_data, '%') THEN
					RETURN 0
				END IF 
			END IF
			ls_shop_type = dw_2.GetitemString(al_row, "shop_type")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com011" 
			gst_cd.default_where   = "where brand  = '" + is_brand  + "'" + & 
			                         "  and year   = '" + is_year   + "'" + & 
											 "  and season = '" + is_season + "'" 
			IF ls_shop_type = '1' THEN 
				gst_cd.default_where = gst_cd.default_where + "  and Plan_Yn = 'N'" 
			ELSEIF ls_shop_type = '3' THEN 
				gst_cd.default_where = gst_cd.default_where + "  and Plan_Yn = 'Y'" 
			END IF
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style LIKE  '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_2.SetRow(al_row)
				dw_2.SetColumn(as_column)
				dw_2.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				/* 다음컬럼으로 이동 */
				dw_2.SetColumn("sale_type")
				ib_itemchanged = False 
				lb_check = TRUE 
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
*/
RETURN 0

end event

event type long ue_update();call super::ue_update;
long i, ll_row_count
datetime ld_datetime 
boolean  lb_ok
String   ls_shop_cd, ls_ErrMsg, ls_date_chk
string   ls_style, ls_chno, ls_color, ls_size 
long     ll_sale_price, ll_dc_rate, ll_qty,ll_sale_qty
string  ls_proc_yn, ls_shop_type, ls_year, ls_season, ls_yymmdd, ls_sale_no, ls_ok,ls_s_no, ls_sale_type, ls_time_stamp, ls_order_no
decimal ldc_dc_rate

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

IF is_data_opt <> "A" THEN
	MessageBox("경고", "저장권한이 없습니다 !") 
	Return 0
END IF


select replace(convert(char(8),getdate(),108), ':','')
into :ls_time_stamp
from dual;

FOR i=1 TO ll_row_count
 	ls_yymmdd   	= dw_body.Getitemstring(i, "yymmdd")	

  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
	  MessageBox("경고","소급할수 없는 일자가 포함 되어 있습니다.")
	Return 0
  eND IF

NEXT


 

FOR i=1 TO ll_row_count
  	dw_body.selectrow(i,true)	 
		ls_yymmdd   	= dw_body.Getitemstring(i, "yymmdd")	  
		ls_shop_cd   	= dw_body.Getitemstring(i, "shop_cd")
		ls_shop_type   = dw_body.Getitemstring(i, "shop_type")		
		ls_sale_type   = dw_body.Getitemstring(i, "sale_type")				
		ls_style   	 	= dw_body.Getitemstring(i, "style")
		ls_chno   	 	= dw_body.Getitemstring(i, "chno")		
		ls_color   	 	= dw_body.Getitemstring(i, "color")		
		ls_size   	 	= dw_body.Getitemstring(i, "size")				
		ll_sale_qty  	= dw_body.GetitemNumber(i, "sale_qty")						
		ll_sale_price  = dw_body.GetitemNumber(i, "sale_price")								
		ldc_dc_rate		= dw_body.GetitemNumber(i, "dc_rate")								
		ls_order_no   	= dw_body.Getitemstring(i, "order_no")			
	  

	if ll_sale_qty <> 0 then
		
			
						 DECLARE sp_53043_p01 PROCEDURE FOR sp_53043_p01  
							@yymmdd		=  :ls_yymmdd,
							@shop_cd		=  :ls_shop_cd,
							@shop_type	=  :ls_shop_type,
							@sale_type	=  :ls_sale_type,
							@dc_rate		=  :ldc_dc_rate,
							@style		=  :ls_style,
							@chno			=  :ls_chno,
							@color		=	:ls_color,
							@size			=  :ls_size,
							@sale_qty	=  :ll_sale_qty,
							@e_sale_price	=  :ll_sale_price,							
							@reg_id		= 	:gs_user_id,
							@time_stamp	=  :ls_time_stamp,
							@order_no   =  :ls_order_no,
							@O_sale_no	=	:ls_sale_no OUT,
							@o_ok       =  :ls_ok	out,							
							@O_no			=  :ls_s_no OUT;	
							
						 EXECUTE sp_53043_p01 ;
						 fetch   sp_53043_p01  into :ls_sale_no, :ls_ok, :ls_s_no;
						 CLOSE   sp_53043_p01 ;
						 
			 
				IF SQLCA.SQLCODE = -1 THEN 
					rollback  USING SQLCA;
					MessageBox("SQL오류", SQLCA.SqlErrText) 
					Return -1 
				ELSE
					commit  USING SQLCA;
					dw_BODY.SETItem(i, "CHK_STYLE", "완료:" + ls_shop_type + "-" + ls_sale_no  )	

					 il_rows = 1 
				END IF 		
			end if		
			
	dw_body.selectrow(i,false)	

NEXT


IF il_rows = 1 THEN
   MessageBox("확인", "처리 완료") 
//	DW_BODY.ENABLED = FALSE
END IF


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53043_e","0")
end event

event ue_button(integer ai_cb_div, long al_rows);
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
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

	CASE 4		/* 입력 */
			if dw_body.RowCount() > 0 then
            ib_changed = true

				if is_data_opt = "A" then
	            cb_update.enabled = true
				ELSE	
	            cb_update.enabled = FALSE
				END IF	

	         dw_head.Enabled = false
   	      dw_body.Enabled = true	
			   cb_retrieve.Text = "조건(&Q)"				
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
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

type cb_close from w_com010_e`cb_close within w_53043_e
end type

type cb_delete from w_com010_e`cb_delete within w_53043_e
boolean visible = false
boolean enabled = true
string text = "붙여넣기"
end type

event cb_delete::clicked;//Long   ll_rows, ll_find, i, j, ll_deal_qty , ll_row 
//String ls_shop_type, ls_style, ls_sale_type, ls_excp_yn
//decimal ldc_sale_price, ldc_dc_rate
//
////ll_rows = ids_copy.RowCount()
//ll_rows = dw_4.RowCount()
//
//FOR i = 1 TO ll_rows 
//	ls_shop_type   = dw_4.GetitemString(i, "shop_type")
//	ls_style       = dw_4.GetitemString(i, "style")
//	ls_sale_type   = dw_4.GetitemString(i, "sale_type")
//	ls_excp_yn     = dw_4.GetitemString(i, "excp_yn")
//	ldc_sale_price = dw_4.GetitemNumber(i, "sale_price")
//	ldc_dc_rate    = dw_4.GetitemNumber(i, "dc_rate")
//	
//	ll_find = dw_2.Find("shop_type = '" + ls_shop_type + "' and style = '" + ls_style + "' and sale_type = '" + ls_sale_type + "'", 1, dw_2.RowCount())
//	IF ll_find < 1 THEN
//	   ll_row     =  dw_2.insertRow(0)
//      dw_2.Setitem(ll_row, "shop_type",   ls_shop_type)
//      dw_2.Setitem(ll_row, "style",       ls_style)
//      dw_2.Setitem(ll_row, "sale_type",   ls_sale_type)
//      dw_2.Setitem(ll_row, "excp_yn",     ls_excp_yn)		
//      dw_2.Setitem(ll_row, "sale_price",  ldc_sale_price)
//      dw_2.Setitem(ll_row, "dc_rate",     ldc_dc_rate)		
//	END IF 
//NEXT 
//
//ib_changed = true
//cb_update.enabled = true
//
end event

type cb_insert from w_com010_e`cb_insert within w_53043_e
boolean visible = false
string text = "복사"
end type

event cb_insert::clicked;//ids_copy.Reset()
//dw_4.reset()
//dw_2.RowsCopy(1, dw_2.RowCount(), Primary!, dw_4, 1, Primary!)

end event

type cb_retrieve from w_com010_e`cb_retrieve within w_53043_e
end type

type cb_update from w_com010_e`cb_update within w_53043_e
integer width = 352
string text = "판매처리(&S)"
end type

type cb_print from w_com010_e`cb_print within w_53043_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_53043_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_53043_e
end type

type cb_excel from w_com010_e`cb_excel within w_53043_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_53043_e
integer x = 18
integer y = 160
integer width = 3584
integer height = 148
string dataobject = "d_53043_h01"
boolean livescroll = false
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("001")



end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_yymmdd 

CHOOSE CASE dwo.name
	CASE "yymmdd"	
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			 // Return 1
        END IF
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_53043_e
integer beginy = 308
integer endy = 308
end type

type ln_2 from w_com010_e`ln_2 within w_53043_e
integer beginy = 312
integer endy = 312
end type

type dw_body from w_com010_e`dw_body within w_53043_e
integer x = 0
integer y = 464
integer width = 3616
integer height = 1540
string dataobject = "d_53043_d01"
end type

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
END CHOOSE

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("color", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve()

end event

type dw_print from w_com010_e`dw_print within w_53043_e
end type

type cb_copy from commandbutton within w_53043_e
boolean visible = false
integer x = 1083
integer y = 44
integer width = 347
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "붙여넣기"
end type

event clicked;//Long   ll_rows, ll_find, i, j, ll_deal_qty , ll_row 
//String ls_shop_type, ls_style, ls_sale_type, ls_excp_yn
//decimal ldc_sale_price, ldc_dc_rate
//
////ll_rows = ids_copy.RowCount()
//ll_rows = dw_4.RowCount()
//
//FOR i = 1 TO ll_rows 
//	ls_shop_type   = dw_4.GetitemString(i, "shop_type")
//	ls_style       = dw_4.GetitemString(i, "style")
//	ls_sale_type   = dw_4.GetitemString(i, "sale_type")
//	ls_excp_yn     = dw_4.GetitemString(i, "excp_yn")
//	ldc_sale_price = dw_4.GetitemNumber(i, "sale_price")
//	ldc_dc_rate    = dw_4.GetitemNumber(i, "dc_rate")
//	
//	ll_find = dw_2.Find("shop_type = '" + ls_shop_type + "' and style = '" + ls_style + "' and sale_type = '" + ls_sale_type + "'", 1, dw_2.RowCount())
//	IF ll_find < 1 THEN
//	   ll_row     =  dw_2.insertRow(0)
//      dw_2.Setitem(ll_row, "shop_type",   ls_shop_type)
//      dw_2.Setitem(ll_row, "style",       ls_style)
//      dw_2.Setitem(ll_row, "sale_type",   ls_sale_type)
//      dw_2.Setitem(ll_row, "excp_yn",     ls_excp_yn)		
//      dw_2.Setitem(ll_row, "sale_price",  ldc_sale_price)
//      dw_2.Setitem(ll_row, "dc_rate",     ldc_dc_rate)		
//	END IF 
//NEXT 
//
//ib_changed = true
//cb_update.enabled = true
//
end event

type dw_1 from datawindow within w_53043_e
integer x = 5
integer y = 320
integer width = 3611
integer height = 136
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_56025_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_53043_e
integer x = 3031
integer y = 344
integer width = 498
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "execl 불러오기"
end type

event clicked;Long   ll_rtn, ll_xls_ret
String ls_filename, ls_name, ls_path, ls_msg, ls_file_name1, ls_shop_type,ls_chk_style , ls_dc_chk, ls_STYLE, LS_COLOR, LS_SIZE, ls_shop_cd, ls_chno
Long	 i, ll_rowcnt,ll_row_count1, LL_STYLE_CHK, ll_shop_chk

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

hpb_1.Position = 0
dw_1.reset()
dw_1.insertrow(1)
dw_BODY.Reset()
Oleobject xlapp

SetPointer(HourGlass!)
//dw_c01.AcceptText()
dw_1.AcceptText()

ll_rtn = GetFileOpenName("엑셀파일",   &
			+ ls_filename, ls_name, "XLS", &
			+ " XLS Files (*.XLS),*.XLS")
If ll_rtn   =   1 Then
	dw_1.Object.path[1]   = ls_filename
	dw_1.Object.path_name[1]   = ls_name
End If

ls_filename = dw_1.Object.path[1]
ls_name     = dw_1.Object.path_name[1]		
ls_path     = MidA(ls_filename, 1 , LenA(ls_filename) - LenA(ls_name))

If IsNull(ls_filename) Or Trim(ls_filename) = '' Then 
	ls_msg = '엑셀 파일을 선택하여 주세요! ..........'
	Messagebox('확인',ls_msg)
	dw_1.SetFocus()
	dw_1.SetColumn("path")
	Return
End If

If IsNull(ls_name) Or Trim(ls_name) = '' Then 
	ls_msg = '엑셀 파일을 선택하여 주세요! ..........'
	Messagebox('확인',ls_msg)
	dw_1.SetFocus()
	dw_1.SetColumn("path_text")
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


xlApp.Application.Visible = False

xlApp.application.workbooks(1).SaveAs(ls_file_name1 , -4158) //===== 텍스트로 저장될 경로
xlApp.application.workbooks(1).Saved = True
xlApp.Application.Quit
xlApp.DisConnectObject()
Destroy xlApp

//xlApp.Application.Activeworkbook.Saveas(ls_file_name1, -4158) //엑셀화일을 텍스트화일로 변환저장  
//xlApp.Application.Workbooks.Saved = TRUE
//xlApp.Application.Workbooks.close()
//xlApp.DisConnectObject() //엑셀 오브젝트를 파괴한다.

dw_BODY.Reset()
//데이타 윈도우에 임포트 한다.
dw_BODY.importfile(ls_file_name1)
		
//필수자료 없는 데이타삭제




ll_rowcnt = dw_BODY.rowcount()
For i = ll_rowcnt To 1 STEP -1
	If i < 1 Then Exit
	ls_STYLE = dw_BODY.object.STYLE[i]
	If ls_STYLE = "" Or IsNull(ls_STYLE) Then
		dw_BODY.DeleteRow(i)
	End If	
	
	If ls_STYLE = "품번" Then
		dw_BODY.DeleteRow(i)
	End If		
Next

FileDelete(ls_file_name1)

messagebox('완료', 'Excel 불러오기가 완료되었습니다! ')


		
ls_chk_style = ""
ll_row_count1 = dw_BODY.RowCount()
LL_STYLE_CHK = 0
ll_shop_chk = 0

FOR i=1 TO ll_row_count1
   ls_shop_cd = 	dw_BODY.GetItemString(i, "shop_cd")
	ls_style = 	dw_BODY.GetItemString(i, "style")
	ls_chno = 	dw_BODY.GetItemString(i, "chno")	
	ls_COLOR = 	dw_BODY.GetItemString(i, "COLOR")
	ls_SIZE = 	dw_BODY.GetItemString(i, "SIZE")	
	
//	select dbo.SF_STYLE_CHK2(:ls_style, :LS_COLOR, :LS_SIZE)
//	into :ls_dc_chk
//	from dual;
	
	select dbo.SF_STYLE_CHK1(:ls_style, :ls_chno, :LS_COLOR, :LS_SIZE)
	into :ls_dc_chk
	from dual;
	
	
	if ls_dc_chk <> "정상" then
		LL_STYLE_CHK = LL_STYLE_CHK + 1
	end if

	dw_BODY.SETItem(i, "CHK_STYLE",ls_dc_chk )	


	if LeftA(ls_shop_cd,1) <> is_brand then
		ll_shop_chk = ll_shop_chk + 1
	end if
	
	hpb_1.Position = ll_row_count1 * (i / ll_row_count1)

   
NEXT


//if ll_shop_chk <> 0 then
//	messagebox("알림!", STRING(ll_shop_chk, "0000") + "건의 다른 브랜드 매장이 포함되어 있습니다! 확인바랍니다!"		)
//end if		

if LL_STYLE_CHK <> 0 then
	messagebox("알림!", STRING(LL_STYLE_CHK, "0000") + "건의 품번오류가 있습니다! 파일을 수정 후 재등록 해주세요!"		)
else 
	hpb_1.Position = 100
	Trigger Event ue_button(4, ll_row_count1)
end if		



		
dw_body.SetFocus()		
	
		
end event

type st_1 from statictext within w_53043_e
integer x = 695
integer y = 48
integer width = 2478
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "<< 확장자 : XLS , 항목 : 양식보기 및 하단 데이터창 참조, 첫줄 타이틀 제거 후 작업"
boolean focusrectangle = false
end type

event clicked;p_1.visible = true
end event

type p_1 from picture within w_53043_e
boolean visible = false
integer x = 5
integer y = 180
integer width = 4165
integer height = 1596
boolean bringtotop = true
string picturename = "C:\Bnc_dept\bmp\sale_file.bmp"
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

event clicked;p_1.visible = false
end event

type cb_form from commandbutton within w_53043_e
integer x = 384
integer y = 40
integer width = 297
integer height = 96
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "양식보기"
end type

event clicked;p_1.visible = true
end event

type hpb_1 from hprogressbar within w_53043_e
integer x = 1915
integer y = 348
integer width = 1102
integer height = 76
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type st_3 from statictext within w_53043_e
integer x = 695
integer y = 104
integer width = 2359
integer height = 44
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "<< 실판금액은 참고용 데이터 입니다."
boolean focusrectangle = false
end type

event clicked;p_1.visible = true
end event

type st_4 from statictext within w_53043_e
integer x = 46
integer y = 204
integer width = 3584
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 판매처리 후 생성된 판매데이터외에 업로드내역은 저장되지 않습니다. 품번오류 발생시 파일에서 수정해서 다시 작업하세요!"
long bordercolor = 16777215
boolean focusrectangle = false
end type

event clicked;p_1.visible = true
end event

