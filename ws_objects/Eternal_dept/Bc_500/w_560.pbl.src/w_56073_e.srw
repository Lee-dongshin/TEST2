$PBExportHeader$w_56073_e.srw
$PBExportComments$세트상품 등록
forward
global type w_56073_e from w_com010_e
end type
type dw_list from datawindow within w_56073_e
end type
end forward

global type w_56073_e from w_com010_e
integer width = 3680
integer height = 2232
dw_list dw_list
end type
global w_56073_e w_56073_e

type variables
DataWindowChild idw_sale_type_b, idw_sale_type_1, idw_sale_type_2
String is_brand,  is_shop_cd, is_year, is_season, is_set_style
String is_yymmdd, is_bf_ymd, is_set_type

end variables

forward prototypes
public function boolean wf_set_data1 ()
public function boolean wf_set_data2 ()
public function boolean wf_set_data3 ()
public function boolean wf_set_data4 ()
end prototypes

public function boolean wf_set_data1 ();/*----------------------------------------------------------------*/
/* 기본마진율 임시자료 편집                                       */
/*----------------------------------------------------------------*/
Long i, k, ll_row
datetime ld_datetime
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return False
END IF
/*
dw_imsi1.Reset()
// 1.삭제된 자료 'OLD_DATA' 로 생성
ll_row = dw_body.DeletedCount()

IF ll_row > 0 THEN
   dw_body.RowsCopy(1, ll_row, Delete!, dw_imsi1, 1, Primary!)
	// 변경후 삭제할경우 대비 최초 자료로 Set 
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
*/
Return True
end function

public function boolean wf_set_data2 ();/*----------------------------------------------------------------*/
/* 시즌별 마진율 자료 처리                                        */
/*----------------------------------------------------------------*/
Long     i, ll_row
datetime ld_datetime

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return False
END IF
/*
ll_row = tab_1.tabpage_1.dw_1.RowCount()

FOR i = 1 TO ll_row
   idw_status = tab_1.tabpage_1.dw_1.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN
      tab_1.tabpage_1.dw_1.Setitem(i, "shop_cd",   is_shop_cd)
      tab_1.tabpage_1.dw_1.Setitem(i, "brand",     is_brand)
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
*/
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
/*
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
*/
Return True 

end function

public function boolean wf_set_data4 ();/*----------------------------------------------------------------*/
/* 품번별마진율 자료 처리                                         */
/*----------------------------------------------------------------*/
Long     i, ll_row
datetime ld_datetime
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return False
END IF
/*
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
*/
Return True 

end function

on w_56073_e.create
int iCurrent
call super::create
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
end on

on w_56073_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
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
inv_resize.of_Register(dw_list, "ScaleToBottom")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)

dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
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
			
	CASE "style"				
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "chno", "")
					RETURN 0
				END IF 
				IF gf_style_chk(as_data, '%') = True THEN
				   dw_head.SetItem(al_row, "chno", "")
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "STYLE 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "STYLE LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF 
				dw_body.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				dw_body.SetItem(al_row, "color", "%")
				dw_body.SetItem(al_row, "size", "%")		
//				dw_head.SetItem(al_row, "chno",  lds_Source.GetItemString(1,"chno"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("chno")
				ib_itemchanged = False 
				lb_check = TRUE 
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


is_set_style = String(dw_head.GetItemDate(1, "set_style"), "set_style")

is_set_type = dw_head.GetItemString(1, "set_type")
if IsNull(is_set_type) or Trim(is_set_type) = "" then
   MessageBox(ls_title,"세트판매유형을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("set_type")
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

/*
tab_1.tabpage_1.dw_1.retrieve(is_shop_cd, is_brand, is_year, is_season, is_yymmdd)
tab_1.tabpage_2.dw_2.retrieve(is_shop_cd, is_brand, is_year, is_season, is_yymmdd)
tab_1.tabpage_3.dw_3.retrieve(is_shop_cd, is_brand, is_yymmdd)
*/

if is_brand <> 'G' then 
	dw_body.DataObject = "d_56072_d03" 
else 	
	dw_body.DataObject = "d_56072_d01" 
end if	
  dw_body.SetTransObject(SQLCA)

il_rows = dw_list.retrieve(is_brand, is_set_style, is_set_type)
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

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

string ls_shop_cd, ls_set_style, ls_style, ls_brand, ls_year, ls_season

ls_brand = dw_head.getitemstring(1,'brand')

FOR i=1 TO ll_row_count
	ls_style = dw_body.getitemstring(i,"style")	
	gf_style_year(ls_style, ls_year)
   gf_style_season(ls_style, ls_season)

	dw_body.Setitem(i, "set_type", is_set_type)
	dw_body.Setitem(i, "brand", ls_brand)
	dw_body.Setitem(i, "year", ls_year)
	dw_body.Setitem(i, "season", ls_season)
	dw_body.Setitem(i, "reg_id", gs_user_id)
	dw_body.Setitem(i, "reg_dt", ld_datetime)
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
	dw_body.ResetUpdate()
	commit  USING SQLCA;
//	messagebox('확인!','월정산 처리가 완료 되었습니다!')
else
	rollback  USING SQLCA;
end if
	
/*
lb_ok = False
IF WF_SET_DATA1() THEN 
	IF WF_SET_DATA2() THEN 
		IF WF_SET_DATA3() THEN 
			IF WF_SET_DATA4() THEN 
	         lb_ok = True
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
*/
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

type cb_close from w_com010_e`cb_close within w_56073_e
end type

type cb_delete from w_com010_e`cb_delete within w_56073_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56073_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56073_e
end type

type cb_update from w_com010_e`cb_update within w_56073_e
end type

type cb_print from w_com010_e`cb_print within w_56073_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56073_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56073_e
end type

type cb_excel from w_com010_e`cb_excel within w_56073_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_56073_e
integer x = 5
integer y = 168
integer width = 3561
integer height = 160
string dataobject = "d_56073_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String ls_yymmdd

CHOOSE CASE dwo.name

	CASE "shop_cd"	,"style"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

END CHOOSE

end event

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("set_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('052')

end event

type ln_1 from w_com010_e`ln_1 within w_56073_e
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com010_e`ln_2 within w_56073_e
integer beginy = 352
integer endy = 352
end type

type dw_body from w_com010_e`dw_body within w_56073_e
integer x = 686
integer y = 360
integer width = 2912
integer height = 1640
string dataobject = "d_56072_d03"
end type

event dw_body::constructor;call super::constructor;/*
DataWindowChild ldw_child

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
*/
end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

//CHOOSE CASE dwo.name
//	CASE "shop_type" 
//		This.Setitem(row, "sale_type", ls_null)
//		
//		
//		
//END CHOOSE

String ls_null, ls_color_nm, ls_size_nm


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

	CASE "size" 
		select dbo.sf_size_nm(:data)
		into :ls_size_nm
		from dual;
		
		This.Setitem(row, "size_nm", ls_size_nm)
				
		
		
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

type dw_print from w_com010_e`dw_print within w_56073_e
integer x = 2066
integer y = 124
end type

type dw_list from datawindow within w_56073_e
integer x = 5
integer y = 360
integer width = 677
integer height = 1640
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_56073_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_set_style
long ll_rows

ls_set_style = dw_list.getitemstring(row,'set_style')

ll_rows = dw_body.retrieve(is_brand, ls_set_style, is_set_type)

IF ll_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
	ll_rows =dw_body.insertRow(0)
   dw_body.SetFocus()
END IF

//This.Trigger Event ue_button(1, il_rows)
//This.Trigger Event ue_msg(1, il_rows)

end event

