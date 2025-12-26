$PBExportHeader$w_56001_e.srw
$PBExportComments$마진율 등록
forward
global type w_56001_e from w_com010_e
end type
type tab_1 from tab within w_56001_e
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
type tabpage_4 from userobject within tab_1
end type
type dw_5 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_5 dw_5
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tab_1 from tab within w_56001_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_3 tabpage_3
end type
type dw_imsi1 from datawindow within w_56001_e
end type
end forward

global type w_56001_e from w_com010_e
integer width = 3671
integer height = 2268
tab_1 tab_1
dw_imsi1 dw_imsi1
end type
global w_56001_e w_56001_e

type variables
DataWindowChild idw_sale_type_b, idw_sale_type_1, idw_sale_type_2
String is_brand,  is_shop_cd, is_year, is_season 
String is_yymmdd, is_bf_ymd

end variables

forward prototypes
public function boolean wf_set_data4 ()
public function boolean wf_set_data3 ()
public function boolean wf_set_data5 ()
public function boolean wf_set_data2 ()
public function boolean wf_set_data1 ()
end prototypes

public function boolean wf_set_data4 ();/*----------------------------------------------------------------*/
/* 품번별마진율 자료 처리                                         */
/*----------------------------------------------------------------*/
Long     i, ll_row
datetime ld_datetime
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return False
END IF

ll_row = tab_1.tabpage_3.dw_3.RowCount()
FOR i = 1 TO ll_row
   idw_status = tab_1.tabpage_3.dw_3.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN
      tab_1.tabpage_3.dw_3.Setitem(i, "shop_cd",   is_shop_cd)
      tab_1.tabpage_3.dw_3.Setitem(i, "reg_id",    gs_user_id)
		tab_1.tabpage_3.dw_3.Setitem(i, "reg_dt",    ld_datetime)
	ELSEIF idw_status = DataModified! THEN		
      tab_1.tabpage_3.dw_3.Setitem(i, "mod_id",    gs_user_id)
      tab_1.tabpage_3.dw_3.Setitem(i, "mod_dt",    ld_datetime)
	END IF
NEXT

IF tab_1.tabpage_3.dw_3.update(TRUE, FALSE) <> 1 THEN RETURN FALSE

Return True 

end function

public function boolean wf_set_data3 ();/*----------------------------------------------------------------*/
/* 품번별마진율 자료 처리                                         */
/*----------------------------------------------------------------*/
Long     i, ll_row
datetime ld_datetime
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return False
END IF

ll_row = tab_1.tabpage_2.dw_2.RowCount()
FOR i = 1 TO ll_row
   idw_status = tab_1.tabpage_2.dw_2.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN
      tab_1.tabpage_2.dw_2.Setitem(i, "shop_cd",   is_shop_cd)
      tab_1.tabpage_2.dw_2.Setitem(i, "brand",     is_brand)
      tab_1.tabpage_2.dw_2.Setitem(i, "year",      is_year)
      tab_1.tabpage_2.dw_2.Setitem(i, "season",    is_season)
      tab_1.tabpage_2.dw_2.Setitem(i, "reg_id",    gs_user_id)
	ELSEIF idw_status = DataModified! THEN		
      tab_1.tabpage_2.dw_2.Setitem(i, "mod_id",    gs_user_id)
      tab_1.tabpage_2.dw_2.Setitem(i, "mod_dt",    ld_datetime)
	END IF
NEXT

IF tab_1.tabpage_2.dw_2.update(TRUE, FALSE) <> 1 THEN RETURN FALSE

Return True 

end function

public function boolean wf_set_data5 ();/*----------------------------------------------------------------*/
/* 품번별마진율 자료 처리                                         */
/*----------------------------------------------------------------*/
Long     i, ll_row
datetime ld_datetime
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return False
END IF

ll_row = tab_1.tabpage_4.dw_5.RowCount()
FOR i = 1 TO ll_row
   idw_status = tab_1.tabpage_4.dw_5.GetItemStatus(i, 0, Primary!)
 
	
   IF idw_status = NewModified! THEN
      tab_1.tabpage_4.dw_5.Setitem(i, "shop_cd",   is_shop_cd)
      tab_1.tabpage_4.dw_5.Setitem(i, "brand",     is_brand)
      tab_1.tabpage_4.dw_5.Setitem(i, "year",      is_year)
      tab_1.tabpage_4.dw_5.Setitem(i, "season",    is_season)
      tab_1.tabpage_4.dw_5.Setitem(i, "reg_id",    gs_user_id)
      tab_1.tabpage_4.dw_5.Setitem(i, "reg_dt",    ld_datetime)
	ELSEIF idw_status = DataModified! THEN		
      tab_1.tabpage_4.dw_5.Setitem(i, "mod_id",    gs_user_id)
      tab_1.tabpage_4.dw_5.Setitem(i, "mod_dt",    ld_datetime)
	END IF	
	
NEXT

IF tab_1.tabpage_4.dw_5.update(TRUE, FALSE) <> 1 THEN RETURN FALSE

Return True 

end function

public function boolean wf_set_data2 ();/*----------------------------------------------------------------*/
/* 시즌별 마진율 자료 처리                                        */
/*----------------------------------------------------------------*/
Long     i, ll_row
datetime ld_datetime
string ls_brand

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return False
END IF

ll_row = tab_1.tabpage_1.dw_1.RowCount()

FOR i = 1 TO ll_row
   idw_status = tab_1.tabpage_1.dw_1.GetItemStatus(i, 0, Primary!)
	
	ls_brand = tab_1.tabpage_1.dw_1.getitemstring(i, "brand")
	if IsNull(ls_brand) or Trim(ls_brand) = "" then
 		ls_brand = is_brand
	end if
	
   IF idw_status = NewModified! THEN
      tab_1.tabpage_1.dw_1.Setitem(i, "shop_cd",   is_shop_cd)
      tab_1.tabpage_1.dw_1.Setitem(i, "brand",     ls_brand)
      tab_1.tabpage_1.dw_1.Setitem(i, "year",      is_year)
      tab_1.tabpage_1.dw_1.Setitem(i, "season",    is_season)
      tab_1.tabpage_1.dw_1.Setitem(i, "reg_id",    gs_user_id)
      tab_1.tabpage_1.dw_1.Setitem(i, "reg_dt",    ld_datetime)
	ELSEIF idw_status = DataModified! THEN		
      tab_1.tabpage_1.dw_1.Setitem(i, "mod_id",    gs_user_id)
      tab_1.tabpage_1.dw_1.Setitem(i, "mod_dt",    ld_datetime)
	END IF
NEXT

IF tab_1.tabpage_1.dw_1.update(TRUE, FALSE) <> 1 THEN RETURN FALSE

Return True 


end function

public function boolean wf_set_data1 ();/*----------------------------------------------------------------*/
/* 기본마진율 임시자료 편집                                       */
/*----------------------------------------------------------------*/
Long i, k, ll_row
datetime ld_datetime
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return False
END IF
dw_imsi1.Reset()
// 1.삭제된 자료 'OLD_DATA' 로 생성
ll_row = dw_body.DeletedCount()

IF ll_row > 0 THEN
   dw_body.RowsCopy(1, ll_row, Delete!, dw_imsi1, 1, Primary!)
	/* 변경후 삭제할경우 대비 최초 자료로 Set */
	FOR k = 1 TO ll_row 
      dw_imsi1.Setitem(k, "shop_type", dw_body.GetItemString(k, "shop_type", Delete!, TRUE)) 
      dw_imsi1.Setitem(k, "sale_type", dw_body.GetItemString(k, "sale_type", Delete!, TRUE)) 
      dw_imsi1.Setitem(k, "dc_rate",   dw_body.GetItemDecimal(k, "dc_rate", Delete!, TRUE)) 
      dw_imsi1.Setitem(k, "end_ymd",   'OLD_DATA')
      dw_imsi1.Setitem(k, "mod_id",    gs_user_id)
      dw_imsi1.Setitem(k, "mod_dt",    ld_datetime)
	NEXT 
ELSE
	k = 1
END IF
// 2. 수정전 자료 및 종료일이 '99999999'가 아닌자료는 'OLD_DATA'로 생성
ll_row = dw_body.RowCount()
FOR i = 1 TO ll_row
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! then // OR dw_body.object.end_ymd[i] <> '99999999' THEN		   /* Modify Record */
      dw_body.RowsCopy(i, i, Primary!, dw_imsi1, k, Primary!)
      dw_imsi1.Setitem(k, "shop_type", dw_body.GetitemString(i, "shop_type", Primary!, True))
      dw_imsi1.Setitem(k, "sale_type", dw_body.GetitemString(i, "sale_type", Primary!, True))
      dw_imsi1.Setitem(k, "dc_rate",   dw_body.GetitemDecimal(i, "dc_rate",   Primary!, True))
      dw_imsi1.Setitem(k, "mod_id",    gs_user_id)
      dw_imsi1.Setitem(k, "mod_dt",    ld_datetime)
      dw_imsi1.Setitem(k, "end_ymd",   'OLD_DATA')
	   k++
   END IF
NEXT
// 3. 수정후 자료 및 종료일이 '99999999'가 아닌자료는 'NEW_DATA'로 생성 
FOR i = 1 TO ll_row
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN
      dw_body.RowsCopy(i, i, Primary!, dw_imsi1, k, Primary!)
      dw_imsi1.Setitem(k, "shop_cd",   is_shop_cd)
      dw_imsi1.Setitem(k, "brand",     is_brand)
      dw_imsi1.Setitem(k, "start_ymd", is_yymmdd)
      dw_imsi1.Setitem(k, "end_ymd",   'NEW_DATA')
      dw_imsi1.Setitem(k, "mod_id",    gs_user_id)
      dw_imsi1.Setitem(k, "mod_dt",    ld_datetime)
	   k++
	ELSEIF idw_status = DataModified! then // OR dw_body.object.end_ymd[i] <> '99999999' THEN		
      dw_body.RowsCopy(i, i, Primary!, dw_imsi1, k, Primary!) 
      dw_imsi1.Setitem(k, "end_ymd",   'NEW_DATA') 
      dw_imsi1.Setitem(k, "mod_id",    gs_user_id)
      dw_imsi1.Setitem(k, "mod_dt",    ld_datetime)
	   k++
	END IF
NEXT

IF dw_imsi1.update() <> 1 THEN RETURN FALSE

Return True
end function

on w_56001_e.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_imsi1=create dw_imsi1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_imsi1
end on

on w_56001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_imsi1)
end on

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/* Data window Resize */
inv_resize.of_Register(dw_body, "ScaleToBottom")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_1.dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_2.dw_2, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_3.dw_3, "ScaleToRight&Bottom")
inv_resize.of_Register(tab_1.tabpage_4.dw_5, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
tab_1.tabpage_1.dw_1.SetTransObject(SQLCA)
tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)
tab_1.tabpage_4.dw_5.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_imsi1.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)

end event

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
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

RETURN 0

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
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
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G') then
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


is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"시즌년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")
is_bf_ymd = String(RelativeDate(dw_head.GetItemDate(1, "yymmdd"), -1), "yyyymmdd")

if is_brand <>  MidA(is_shop_cd,1,1) then
   MessageBox(ls_title,"매장브랜드와 매장코드가 다릅니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("BRand")
   return false
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

tab_1.tabpage_1.dw_1.retrieve(is_shop_cd, is_brand, is_year, is_season, is_yymmdd)
tab_1.tabpage_2.dw_2.retrieve(is_shop_cd, is_brand, is_year, is_season, is_yymmdd)
tab_1.tabpage_3.dw_3.retrieve(is_shop_cd, is_brand, is_yymmdd)
tab_1.tabpage_4.dw_5.retrieve(is_shop_cd, is_brand, is_year, is_season, is_yymmdd)

il_rows = dw_body.retrieve(is_shop_cd, is_brand, is_yymmdd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
	il_rows =dw_body.insertRow(0)
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.19                                                  */	
/* 수정일      : 2001.12.19                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime 
boolean  lb_ok
String   ls_ErrMsg

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF tab_1.tabpage_1.dw_1.AcceptText() <> 1 THEN RETURN -1
IF tab_1.tabpage_2.dw_2.AcceptText() <> 1 THEN RETURN -1
IF tab_1.tabpage_3.dw_3.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

lb_ok = False
IF WF_SET_DATA1() THEN 
	IF WF_SET_DATA2() THEN 
		IF WF_SET_DATA3() THEN 
			IF WF_SET_DATA4() THEN 
      		IF WF_SET_DATA5() THEN 
	         	lb_ok = True
				END IF				
			END IF				
		END IF
	END IF
END IF

IF lb_ok THEN
   DECLARE SP_56001_UPDATE PROCEDURE FOR SP_56001_UPDATE  
           @brand   = :is_brand,   
           @shop_cd = :is_shop_cd,   
           @year    = :is_year,   
           @season  = :is_season,   
           @yymmdd  = :is_yymmdd;
   EXECUTE SP_56001_UPDATE;
	
	IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
		il_rows = 1
      dw_body.ResetUpdate()
      tab_1.tabpage_1.dw_1.ResetUpdate()
      tab_1.tabpage_2.dw_2.ResetUpdate()
      tab_1.tabpage_3.dw_3.ResetUpdate()
      tab_1.tabpage_4.dw_5.ResetUpdate()		
      commit  USING SQLCA;
		dw_imsi1.reset()
	ELSE
		ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" +SQLCA.SQLERRTEXT
      rollback  USING SQLCA;
		MessageBox("저장 실패[SP]", ls_ErrMsg)
		il_rows = -1
	END IF
ELSE
	ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" +SQLCA.SQLERRTEXT
   rollback  USING SQLCA;
   MessageBox("저장 실패[DW]", ls_ErrMsg)
	il_rows = -1
END IF

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event ue_button;call super::ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.21                                                  */	
/* 수정일      : 2001.12.21                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows >= 0 then
         cb_insert.enabled = true
      end if
   CASE 5    /* 조건 */
      cb_insert.enabled = false
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56001_e","0")
end event

type cb_close from w_com010_e`cb_close within w_56001_e
end type

type cb_delete from w_com010_e`cb_delete within w_56001_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56001_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56001_e
end type

type cb_update from w_com010_e`cb_update within w_56001_e
end type

type cb_print from w_com010_e`cb_print within w_56001_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56001_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56001_e
end type

type cb_excel from w_com010_e`cb_excel within w_56001_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_56001_e
integer x = 5
integer y = 168
integer width = 3561
integer height = 160
string dataobject = "d_56001_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String ls_yymmdd
String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "yymmdd"	
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
	
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")						
END CHOOSE

end event

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('003', gs_brand, '%')


end event

type ln_1 from w_com010_e`ln_1 within w_56001_e
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com010_e`ln_2 within w_56001_e
integer beginy = 352
integer endy = 352
end type

type dw_body from w_com010_e`dw_body within w_56001_e
integer x = 14
integer y = 372
integer width = 1915
integer height = 1652
string dataobject = "d_56001_d01"
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("shop_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("sale_type", idw_sale_type_b)
idw_sale_type_b.SetTransObject(SQLCA)
idw_sale_type_b.Retrieve('011')

This.GetChild("sale_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm, ls_shop_type, ls_filter
ls_column_nm = This.GetColumnName()

CHOOSE CASE ls_column_nm
	CASE "sale_type" 
		ls_shop_type = This.GetitemString(row, "shop_type")
		IF ls_shop_type = '1' THEN 
			ls_filter = "inter_cd1 = '1' or inter_cd1 = '2' "
		ELSEIF ls_shop_type = '3' THEN
			ls_filter = "inter_cd1 = '3'"
		ELSE
			ls_filter = "inter_cd1 = '4'"
		END IF
		idw_sale_type_b.SetFilter(ls_filter)
		idw_sale_type_b.Filter()
END CHOOSE

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
String ls_null

CHOOSE CASE dwo.name
	CASE "shop_type" 
		This.Setitem(row, "sale_type", ls_null)
END CHOOSE

end event

event dw_body::buttonclicking;IF row < 1 THEN RETURN 

IF dwo.name = "b_delete" THEN 
	idw_status = This.GetItemStatus (row, 0, primary!)	
	il_rows = 1
   Parent.Trigger Event ue_button(4, il_rows)
   Parent.Trigger Event ue_msg(4, il_rows)
END IF

end event

event dw_body::ue_keydown;
String ls_column_name, ls_tag, ls_report
long ll_row

ls_column_name = This.GetColumnName()



IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyF7!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
		END IF
			Parent.Trigger Event ue_button(2, il_rows)
			Parent.Trigger Event ue_msg(2, il_rows)

		
	CASE KeyF8!

			ll_row = This.GetRow()
	 	   idw_status = This.GetItemStatus (ll_row, 0, primary!)	

			il_rows = dw_body.DeleteRow (ll_row)
			dw_body.SetFocus()
						
			Parent.Trigger Event ue_button(4, il_rows)
			Parent.Trigger Event ue_msg(4, il_rows)
			


	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
	CASE KeyDownArrow!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
		END IF
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

type dw_print from w_com010_e`dw_print within w_56001_e
end type

type tab_1 from tab within w_56001_e
integer x = 1934
integer y = 360
integer width = 1655
integer height = 1652
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_4=create tabpage_4
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_4,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_4)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 1618
integer height = 1540
long backcolor = 79741120
string text = "시즌별"
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
event ue_keydown pbm_dwnkey
integer width = 1618
integer height = 1544
integer taborder = 110
string title = "none"
string dataobject = "d_56001_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report
long ll_row

PowerObject l_tabpage, l_tab
Window lw_win

l_tabpage = This.GetParent()
l_tab     = l_tabpage.Getparent()
lw_win    = l_tab.GetParent()



ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
	CASE KeyDownArrow!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
		END IF
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
		
	CASE KeyF7!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
		END IF

		lw_win.Dynamic Trigger Event ue_button(2, il_rows)
		lw_win.Dynamic Trigger Event ue_msg(2, il_rows)

		
	CASE KeyF8!

			ll_row = This.GetRow()
	 	   idw_status = This.GetItemStatus (ll_row, 0, primary!)	

			il_rows = This.DeleteRow (ll_row)
			This.SetFocus()
			
		lw_win.Dynamic Trigger Event ue_button(4, il_rows)
		lw_win.Dynamic Trigger Event ue_msg(4, il_rows)
		
		
END CHOOSE


end event

event constructor;DataWindowChild ldw_child


This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("shop_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("sale_type", idw_sale_type_1)
idw_sale_type_1.SetTransObject(SQLCA)
idw_sale_type_1.Retrieve('011')

This.GetChild("sale_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')



This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
String ls_null

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE dwo.name
	CASE "shop_type" 
		This.Setitem(row, "sale_type", ls_null) 
	CASE "start_ymd", "end_ymd"
		IF GF_DateChk(Data) = False THEN 
			RETURN 1
		END IF 
END CHOOSE

end event

event editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm, ls_tag, ls_helpMsg 
String ls_shop_type, ls_filter

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

CHOOSE CASE ls_column_nm
	CASE "sale_type" 
		ls_shop_type = This.GetitemString(row, "shop_type")
		IF ls_shop_type = '1' THEN 
			ls_filter = "inter_cd1 = '1' or inter_cd1 = '2' "
		ELSEIF ls_shop_type = '3' THEN
			ls_filter = "inter_cd1 = '3'"
		ELSE
			ls_filter = "inter_cd1 = '4'"
		END IF
		idw_sale_type_1.SetFilter(ls_filter)
		idw_sale_type_1.Filter()
END CHOOSE

end event

event buttonclicking;PowerObject l_tabpage, l_tab
Window lw_win

IF row < 1 THEN RETURN 

l_tabpage = This.GetParent()
l_tab     = l_tabpage.Getparent()
lw_win    = l_tab.GetParent()

IF dwo.name = "b_delete" THEN 
	idw_status = This.GetItemStatus (row, 0, primary!)	
	il_rows = 1
   lw_win.Dynamic Trigger Event ue_button(4, il_rows)
   lw_win.Dynamic Trigger Event ue_msg(4, il_rows)
END IF


end event

event itemerror;Return 1

end event

event buttonclicked;CHOOSE CASE dwo.name
	CASE "cb_date" 
		dw_1.SetSort("start_ymd")
		dw_1.Sort()	
	CASE "cb_shop_type" 
		dw_1.SetSort("shop_type")
		dw_1.Sort()		
	CASE "cb_sale_type" 
		dw_1.SetSort("sale_type")		
		dw_1.Sort()


END CHOOSE
end event

type tabpage_2 from userobject within tab_1
event type integer ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
integer x = 18
integer y = 96
integer width = 1618
integer height = 1540
long backcolor = 79741120
string text = "품번별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
string     ls_shop_nm,ls_dc_chk,ls_style
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style"				
			IF ai_div = 1 THEN 	
				IF gf_style_chk(as_data, '%')  THEN
					
							
					select dbo.SF_dc_except_chk(:as_data)
					into :ls_dc_chk
					from dual;
					
					
					if ls_dc_chk = "Y" then 
						messagebox("알림!", "할인적용 별도 관리 품번 입니다! 확인후 처리 하세요!")
					end if	
					
					RETURN 0
				END IF
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com011" 
			gst_cd.default_where   = "WHERE brand  = '" + is_brand  + "'" + &
			                         "  AND year   = '" + is_year   + "'" + &
											 "  AND season = '" + is_season + "'" 
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
				tab_1.tabpage_2.dw_2.SetRow(al_row)
				tab_1.tabpage_2.dw_2.SetColumn(as_column)
				tab_1.tabpage_2.dw_2.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				
						ls_style =  lds_Source.GetItemString(1,"style")
				
				select dbo.SF_dc_except_chk(:ls_style)
				into :ls_dc_chk
				from dual;
				
				if ls_dc_chk = "Y" then 
					messagebox("알림!", "할인적용 별도 관리 품번 입니다! 확인후 처리 하세요!")
				end if	
				
				/* 다음컬럼으로 이동 */
				tab_1.tabpage_2.dw_2.setcolumn("sale_price")
				ib_itemchanged = False
			END IF
			Destroy  lds_Source
END CHOOSE

IF ai_div = 1 THEN 	
   RETURN 2
END IF

RETURN 0

end event

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_2
event ue_keydown pbm_dwnkey
event type integer ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
integer width = 1623
integer height = 1556
integer taborder = 110
string title = "none"
string dataobject = "d_56001_d03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report
long ll_row

PowerObject l_tabpage, l_tab
Window lw_win

l_tabpage = This.GetParent()
l_tab     = l_tabpage.Getparent()
lw_win    = l_tab.GetParent()



ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
	CASE KeyDownArrow!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
		END IF
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
		
	CASE KeyF7!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
		END IF

		lw_win.Dynamic Trigger Event ue_button(2, il_rows)
		lw_win.Dynamic Trigger Event ue_msg(2, il_rows)

		
	CASE KeyF8!

			ll_row = This.GetRow()
	 	   idw_status = This.GetItemStatus (ll_row, 0, primary!)	

			il_rows = This.DeleteRow (ll_row)
			This.SetFocus()
			
		lw_win.Dynamic Trigger Event ue_button(4, il_rows)
		lw_win.Dynamic Trigger Event ue_msg(4, il_rows)
		
		
END CHOOSE


//String ls_column_name, ls_tag, ls_report
//
//ls_column_name = This.GetColumnName()
//
//IF KeyDown(21) THEN
//	ls_tag = This.Describe(ls_column_name + ".Tag")
//	gf_kor_eng(Handle(Parent), ls_tag, 2)
//END IF
//
//CHOOSE CASE key
//	CASE KeyEnter!
//		Send(Handle(This), 256, 9, long(0,0))
//		Return 1
//	CASE KeyDownArrow!
//		IF This.GetRow() = This.RowCount() THEN
//		   This.InsertRow(This.GetRow() + 1)
//		END IF
//   CASE KeyF12!
//      char lc_kb[256]
//      GetKeyboardState (lc_kb)
//      lc_kb[17] = Char (128)
//      SetKeyboardState (lc_kb)
//      Send (Handle (this), 256, 9, 0)
//      GetKeyboardState (lc_kb)
//      lc_kb[17] = Char (0)
//      SetKeyboardState (lc_kb)
//	CASE KeyF1!
//		ls_report = This.Describe(ls_column_name + ".Protect")
//		IF ls_report = "1" THEN RETURN 0
//		ls_report = Mid(ls_report, 4, Len(ls_report) - 4)
//		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
//								String(This.GetRow()) + ")") = '1' THEN RETURN 0
//		This.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
//END CHOOSE
//
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_shop_type
Boolean    lb_check 
DataStore  lds_Source
string ls_dc_chk

CHOOSE CASE as_column
	CASE "style"				
		
		
			IF ai_div = 1 THEN 	
				IF gf_style_chk(as_data, '%') THEN
					
					
					select dbo.SF_dc_except_chk(:as_data)
					into :ls_dc_chk
					from dual;
					
					
					if ls_dc_chk = "Y" then 
						messagebox("알림!", "할인적용 별도 관리 품번 입니다! 확인후 처리 하세요!")
					end if	
					RETURN 0
					
				END IF 
			END IF
			ls_shop_type = This.GetitemString(al_row, "shop_type")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com011" 
			
			if is_brand = "J" or is_brand = "N"  then
				gst_cd.default_where   = "where brand  like '[NJ]%'" + & 
												 "  and year   = '" + is_year   + "'" + & 
												 "  and season = '" + is_season + "'" 

			else			
				gst_cd.default_where   = "where brand  = '" + is_brand  + "'" + & 
												 "  and year   = '" + is_year   + "'" + & 
												 "  and season = '" + is_season + "'" 
			end if												 
			
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
				This.SetRow(al_row)
				This.SetColumn(as_column)
				This.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				
				ls_style =  lds_Source.GetItemString(1,"style")
				
				select dbo.SF_dc_except_chk(:ls_style)
				into :ls_dc_chk
				from dual;
				
				if ls_dc_chk = "Y" then 
					messagebox("알림!", "할인적용 별도 관리 품번 입니다! 확인후 처리 하세요!")
				end if	
				RETURN 0
				/* 다음컬럼으로 이동 */
				This.SetColumn("sale_price")
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

RETURN 0

end event

event constructor;DataWindowChild ldw_child

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("shop_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("sale_type", idw_sale_type_2)
idw_sale_type_2.SetTransObject(SQLCA)
idw_sale_type_2.Retrieve('011')

This.GetChild("sale_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

//This.GetChild("color", ldw_child )
//ldw_child.SetTransObject(SQLCA)
//ldw_child.Retrieve('%','%')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1, "color", '%%')
//ldw_child.SetItem(1, "color_enm", '전체')
end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String ls_null

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE dwo.name
	CASE "start_ymd", "end_ymd"
		IF GF_DateChk(Data) = False THEN 
			RETURN 1
		END IF 
	CASE "shop_type" 
		This.Setitem(row, "sale_type", ls_null)
		This.Setitem(row, "style",     ls_null)
	CASE "style" 	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event buttonclicked;/*===========================================================================*/
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

CHOOSE CASE dwo.name
	CASE "cb_date" 
		dw_2.SetSort("start_ymd")
		dw_2.Sort()	
	CASE "cb_shop_type" 
		dw_2.SetSort("shop_type")
		dw_2.Sort()		
	CASE "cb_sale_type" 
		dw_2.SetSort("sale_type")		
		dw_2.Sort()
	CASE "cb_style_no" 
		dw_2.SetSort("style_no")				
		dw_2.Sort()

END CHOOSE



Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg 
String ls_shop_type,  ls_filter
String ls_style, ls_chno, ls_color

DataWindowChild ldw_child

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

CHOOSE CASE ls_column_nm
	CASE "sale_type" 
		ls_shop_type = This.GetitemString(row, "shop_type")
		IF ls_shop_type = '1' THEN 
			ls_filter = "inter_cd1 = '1' or inter_cd1 = '2' "
		ELSEIF ls_shop_type = '3' THEN
			ls_filter = "inter_cd1 = '3'"
		ELSE
			ls_filter = "inter_cd1 = '4'"
		END IF
		idw_sale_type_2.SetFilter(ls_filter)
		idw_sale_type_2.Filter()
		
		

//	CASE "color"
//		ls_style = This.GetitemString(row, "style")
//		ls_chno  = '%'
//
//		
//		This.GetChild("color", ldw_child )
//		ldw_child.SetTransObject(SQLCA)
//		
//		ldw_child.Retrieve(ls_style, ls_chno)
//		
//		ldw_child.insertRow(1)
//		ldw_child.Setitem(1, "color", "%%")
//		ldw_child.Setitem(1, "color_enm", "All Colors")
//
	
		
		
		
END CHOOSE

end event

event buttonclicking;PowerObject l_tabpage, l_tab
Window lw_win

IF row < 1 THEN RETURN 

l_tabpage = This.GetParent()
l_tab     = l_tabpage.Getparent()
lw_win    = l_tab.GetParent()

IF dwo.name = "b_2" THEN 
	idw_status = This.GetItemStatus (row, 0, primary!)	
	il_rows = 1
   lw_win.DyNAMIC Trigger Event ue_button(4, il_rows)
   lw_win.DyNAMIC Trigger Event ue_msg(4, il_rows)
END IF

end event

event itemerror;Return 1

end event

type tabpage_4 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 1618
integer height = 1540
long backcolor = 79741120
string text = "품번색상별"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_4.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_4.destroy
destroy(this.dw_5)
end on

type dw_5 from datawindow within tabpage_4
event ue_keydown pbm_dwnkey
event type integer ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
integer width = 1618
integer height = 1532
integer taborder = 10
string title = "none"
string dataobject = "d_56001_d05"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report
long ll_row

PowerObject l_tabpage, l_tab
Window lw_win

l_tabpage = This.GetParent()
l_tab     = l_tabpage.Getparent()
lw_win    = l_tab.GetParent()



ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
	CASE KeyDownArrow!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
		END IF
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
		
	CASE KeyF7!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
		END IF

		lw_win.Dynamic Trigger Event ue_button(2, il_rows)
		lw_win.Dynamic Trigger Event ue_msg(2, il_rows)

		
	CASE KeyF8!

			ll_row = This.GetRow()
	 	   idw_status = This.GetItemStatus (ll_row, 0, primary!)	

			il_rows = This.DeleteRow (ll_row)
			This.SetFocus()
			
		lw_win.Dynamic Trigger Event ue_button(4, il_rows)
		lw_win.Dynamic Trigger Event ue_msg(4, il_rows)
		
		
END CHOOSE


//String ls_column_name, ls_tag, ls_report
//
//ls_column_name = This.GetColumnName()
//
//IF KeyDown(21) THEN
//	ls_tag = This.Describe(ls_column_name + ".Tag")
//	gf_kor_eng(Handle(Parent), ls_tag, 2)
//END IF
//
//CHOOSE CASE key
//	CASE KeyEnter!
//		Send(Handle(This), 256, 9, long(0,0))
//		Return 1
//	CASE KeyDownArrow!
//		IF This.GetRow() = This.RowCount() THEN
//		   This.InsertRow(This.GetRow() + 1)
//		END IF
//   CASE KeyF12!
//      char lc_kb[256]
//      GetKeyboardState (lc_kb)
//      lc_kb[17] = Char (128)
//      SetKeyboardState (lc_kb)
//      Send (Handle (this), 256, 9, 0)
//      GetKeyboardState (lc_kb)
//      lc_kb[17] = Char (0)
//      SetKeyboardState (lc_kb)
//	CASE KeyF1!
//		ls_report = This.Describe(ls_column_name + ".Protect")
//		IF ls_report = "1" THEN RETURN 0
//		ls_report = Mid(ls_report, 4, Len(ls_report) - 4)
//		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
//								String(This.GetRow()) + ")") = '1' THEN RETURN 0
//		This.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
//END CHOOSE
//
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_shop_type, ls_dc_chk
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style"				
			IF ai_div = 1 THEN 	
				IF gf_style_chk(as_data, '%') THEN
					
						
					select dbo.SF_dc_except_chk(:as_data)
					into :ls_dc_chk
					from dual;
					
					
					if ls_dc_chk = "Y" then 
						messagebox("알림!", "할인적용 별도 관리 품번 입니다! 확인후 처리 하세요!")
					end if	
					
					RETURN 0
				END IF 
			END IF
			ls_shop_type = This.GetitemString(al_row, "shop_type")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com011" 
			

			if is_brand = "J" or  is_brand = "N" then
				gst_cd.default_where   = "where brand  like '[NJ]%' " + & 
												 "  and year   = '" + is_year   + "'" + & 
												 "  and season = '" + is_season + "'" 
			else
			
				gst_cd.default_where   = "where brand  = '" + is_brand  + "'" + & 
												 "  and year   = '" + is_year   + "'" + & 
												 "  and season = '" + is_season + "'" 
			end if									 
												 
											 
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
				This.SetRow(al_row)
				This.SetColumn(as_column)
				This.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				
					ls_style =  lds_Source.GetItemString(1,"style")
				
				select dbo.SF_dc_except_chk(:ls_style)
				into :ls_dc_chk
				from dual;
				
				if ls_dc_chk = "Y" then 
					messagebox("알림!", "할인적용 별도 관리 품번 입니다! 확인후 처리 하세요!")
				end if	
				
				/* 다음컬럼으로 이동 */
				This.SetColumn("sale_price")
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

RETURN 0

end event

event buttonclicked;/*===========================================================================*/
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

CHOOSE CASE dwo.name
	CASE "cb_date" 
		dw_5.SetSort("start_ymd")
		dw_5.Sort()	
	CASE "cb_shop_type" 
		dw_5.SetSort("shop_type")
		dw_5.Sort()		
	CASE "cb_sale_type" 
		dw_5.SetSort("sale_type")		
		dw_5.Sort()
	CASE "cb_style_no" 
		dw_5.SetSort("style_no")				
		dw_5.Sort()

END CHOOSE



Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event buttonclicking;PowerObject l_tabpage, l_tab
Window lw_win

IF row < 1 THEN RETURN 

l_tabpage = This.GetParent()
l_tab     = l_tabpage.Getparent()
lw_win    = l_tab.GetParent()

IF dwo.name = "b_2" THEN 
	idw_status = This.GetItemStatus (row, 0, primary!)	
	il_rows = 1
   lw_win.DyNAMIC Trigger Event ue_button(4, il_rows)
   lw_win.DyNAMIC Trigger Event ue_msg(4, il_rows)
END IF

end event

event constructor;DataWindowChild ldw_child

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("shop_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("sale_type", idw_sale_type_2)
idw_sale_type_2.SetTransObject(SQLCA)
idw_sale_type_2.Retrieve('011')

This.GetChild("sale_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

This.GetChild("color", ldw_child )
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('%','%')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "color", '%%')
ldw_child.SetItem(1, "color_enm", '전체')
end event

event editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String ls_null, ls_color_nm


ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE dwo.name
	CASE "start_ymd", "end_ymd"
		IF GF_DateChk(Data) = False THEN 
			RETURN 1
		END IF 
	CASE "shop_type" 
		This.Setitem(row, "sale_type", ls_null)
		This.Setitem(row, "style",     ls_null)
	CASE "style" 	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "color" 
		select dbo.sf_color_nm(:data,'e')
		into :ls_color_nm
		from dual;
		
		This.Setitem(row, "color_nm", ls_color_nm)
		
		
		
END CHOOSE

end event

event itemerror;Return 1

end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg 
String ls_shop_type,  ls_filter
String ls_style, ls_chno, ls_color

DataWindowChild ldw_child

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

CHOOSE CASE ls_column_nm
	CASE "sale_type" 
		ls_shop_type = This.GetitemString(row, "shop_type")
		IF ls_shop_type = '1' THEN 
			ls_filter = "inter_cd1 = '1' or inter_cd1 = '2' "
		ELSEIF ls_shop_type = '3' THEN
			ls_filter = "inter_cd1 = '3'"
		ELSE
			ls_filter = "inter_cd1 = '4'"
		END IF
		idw_sale_type_2.SetFilter(ls_filter)
		idw_sale_type_2.Filter()
		
		

	CASE "color"
		ls_style = This.GetitemString(row, "style")
		ls_chno  = '%'

		
		This.GetChild("color", ldw_child )
		ldw_child.SetTransObject(SQLCA)
		
		ldw_child.Retrieve(ls_style, ls_chno)
//		
////		ldw_child.insertRow(1)
////		ldw_child.Setitem(1, "color", "%%")
////		ldw_child.Setitem(1, "color_enm", "All Colors")
//
//	
//		
		
		
END CHOOSE

end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 1618
integer height = 1540
long backcolor = 79741120
string text = "제휴사"
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
integer width = 1618
integer height = 1548
integer taborder = 40
string title = "none"
string dataobject = "d_56001_d04"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;/*===========================================================================*/
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

CHOOSE CASE dwo.name
	CASE "cb_date" 
		dw_3.SetSort("start_ymd")
		dw_3.Sort()	
	CASE "cb_shop_type" 
		dw_3.SetSort("shop_type")
		dw_3.Sort()		
	CASE "cb_sale_type" 
		dw_3.SetSort("sale_type")		
		dw_3.Sort()

END CHOOSE



//Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event buttonclicking;PowerObject l_tabpage, l_tab
Window lw_win

IF row < 1 THEN RETURN 

l_tabpage = This.GetParent()
l_tab     = l_tabpage.Getparent()
lw_win    = l_tab.GetParent()

IF dwo.name = "b_2" THEN 
	idw_status = This.GetItemStatus (row, 0, primary!)	
	il_rows = 1
   lw_win.DyNAMIC Trigger Event ue_button(4, il_rows)
   lw_win.DyNAMIC Trigger Event ue_msg(4, il_rows)
END IF

end event

event constructor;DataWindowChild ldw_child


This.GetChild("sale_type", idw_sale_type_2)
idw_sale_type_2.SetTransObject(SQLCA)
idw_sale_type_2.Retrieve('011')

This.GetChild("sale_type_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

end event

event editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String ls_null

ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE dwo.name
	CASE "start_ymd", "end_ymd"
		IF GF_DateChk(Data) = False THEN 
			RETURN 1
		END IF 
END CHOOSE

end event

event itemerror;Return 1

end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg 
String ls_shop_type,  ls_filter

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)



end event

type dw_imsi1 from datawindow within w_56001_e
boolean visible = false
integer x = 1394
integer y = 464
integer width = 2007
integer height = 1436
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_56001_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

