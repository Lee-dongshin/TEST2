$PBExportHeader$w_56002_e.srw
$PBExportComments$마진율 일괄등록
forward
global type w_56002_e from w_com010_e
end type
type dw_1 from datawindow within w_56002_e
end type
type cb_1 from commandbutton within w_56002_e
end type
type dw_3 from datawindow within w_56002_e
end type
type cb_copy from commandbutton within w_56002_e
end type
type dw_4 from datawindow within w_56002_e
end type
type dw_5 from datawindow within w_56002_e
end type
type dw_2 from datawindow within w_56002_e
end type
type dw_6 from datawindow within w_56002_e
end type
end forward

global type w_56002_e from w_com010_e
integer width = 3703
integer height = 2256
dw_1 dw_1
cb_1 cb_1
dw_3 dw_3
cb_copy cb_copy
dw_4 dw_4
dw_5 dw_5
dw_2 dw_2
dw_6 dw_6
end type
global w_56002_e w_56002_e

type variables
DataWindowChild idw_sale_type_1, idw_sale_type_2, idw_dep_seq, idw_disc_seq
String is_brand, is_shop_div, is_shop_grp 
String is_year,  is_season,   is_fr_ymd,   is_to_ymd 
String is_job_yn = 'Y' , is_dep_opt
DataStore ids_copy

end variables

forward prototypes
public function boolean wf_set_data2 (string as_shop_cd)
public function boolean wf_set_data1 (string as_shop_cd)
end prototypes

public function boolean wf_set_data2 (string as_shop_cd);/*----------------------------------------------------------------*/
/* 품번별마진율 자료편집                                          */
/*----------------------------------------------------------------*/
Long i, ll_row
datetime ld_datetime
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return False
END IF

if is_dep_opt = "E" then

			// 수정후 자료는 'NEW_DATA'로 생성
			ll_row = dw_5.RowCount()
			FOR i = 1 TO ll_row
				idw_status = dw_5.GetItemStatus(i, 0, Primary!)
				IF idw_status = NewModified! THEN
					dw_5.Setitem(i, "shop_cd",   as_shop_cd)
					dw_5.Setitem(i, "brand",     is_brand)
					dw_5.Setitem(i, "year",      is_year)
					dw_5.Setitem(i, "season",    is_season)
					dw_5.Setitem(i, "start_ymd", is_fr_ymd)
					dw_5.Setitem(i, "end_ymd",   'NEW_DATA')
					dw_5.Setitem(i, "mod_id",    gs_user_id)
					dw_5.Setitem(i, "mod_dt",    ld_datetime)
				ELSEIF idw_status = DataModified! THEN		
					dw_5.Setitem(i, "shop_cd",   as_shop_cd)
					dw_5.Setitem(i, "end_ymd",   'NEW_DATA') 
					dw_5.Setitem(i, "mod_id",    gs_user_id)
					dw_5.Setitem(i, "mod_dt",    ld_datetime)
				END IF
			NEXT
			
			IF dw_5.update(TRUE, FALSE) <> 1 THEN RETURN FALSE
			
			Return True 
			
else

			// 수정후 자료는 'NEW_DATA'로 생성
			ll_row = dw_2.RowCount()
			FOR i = 1 TO ll_row
				idw_status = dw_2.GetItemStatus(i, 0, Primary!)
				IF idw_status = NewModified! THEN
					dw_2.Setitem(i, "shop_cd",   as_shop_cd)
					dw_2.Setitem(i, "brand",     is_brand)
					dw_2.Setitem(i, "year",      is_year)
					dw_2.Setitem(i, "season",    is_season)
					dw_2.Setitem(i, "start_ymd", is_fr_ymd)
					dw_2.Setitem(i, "end_ymd",   'NEW_DATA')
					dw_2.Setitem(i, "mod_id",    gs_user_id)
					dw_2.Setitem(i, "mod_dt",    ld_datetime)
				ELSEIF idw_status = DataModified! THEN		
					dw_2.Setitem(i, "shop_cd",   as_shop_cd)
					dw_2.Setitem(i, "end_ymd",   'NEW_DATA') 
					dw_2.Setitem(i, "mod_id",    gs_user_id)
					dw_2.Setitem(i, "mod_dt",    ld_datetime)
				END IF
			NEXT
			
			IF dw_2.update(TRUE, FALSE) <> 1 THEN RETURN FALSE
			
			Return True 

end if			
end function

public function boolean wf_set_data1 (string as_shop_cd);/*----------------------------------------------------------------*/
/* 시즌별마진율 자료 편집                                         */
/*----------------------------------------------------------------*/
Long i, ll_row
datetime ld_datetime
STRING ls_brand
/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return False
END IF

// 임시자료 생성
ll_row = dw_1.RowCount()
FOR i = 1 TO ll_row
	
	ls_brand = dw_1.GetItemString(i, "brand")
	if IsNull(ls_brand) or Trim(ls_brand) = "" then
	ls_brand = is_brand
	end if

	
   idw_status = dw_1.GetItemStatus(i, 0, Primary!)
	
	
   IF idw_status = NewModified! THEN
      dw_1.Setitem(i, "shop_cd",   as_shop_cd)
		
      dw_1.Setitem(i, "brand",     ls_brand)
		
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

Return True 

end function

on w_56002_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.dw_3=create dw_3
this.cb_copy=create cb_copy
this.dw_4=create dw_4
this.dw_5=create dw_5
this.dw_2=create dw_2
this.dw_6=create dw_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.cb_copy
this.Control[iCurrent+5]=this.dw_4
this.Control[iCurrent+6]=this.dw_5
this.Control[iCurrent+7]=this.dw_2
this.Control[iCurrent+8]=this.dw_6
end on

on w_56002_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.dw_3)
destroy(this.cb_copy)
destroy(this.dw_4)
destroy(this.dw_5)
destroy(this.dw_2)
destroy(this.dw_6)
end on

event pfc_preopen();call super::pfc_preopen;/* Data window Resize */
inv_resize.of_Register(dw_2, "ScaleToBottom")
inv_resize.of_Register(dw_5, "ScaleToBottom")

/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
dw_5.SetTransObject(SQLCA)
dw_6.SetTransObject(SQLCA)

dw_3.InsertRow(0)

end event

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "fr_ymd" ,string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "to_ymd" ,string(ld_datetime,"yyyymmdd"))

dw_head.Setitem(1, "shop_div", "G")
dw_head.Setitem(1, "shop_grp", "%")

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.09                                                  */	
/* 수정일      : 2002.04.01                                                  */
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


is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_shop_grp = dw_head.GetItemString(1, "shop_grp")
if IsNull(is_shop_grp) or Trim(is_shop_grp) = "" then
   MessageBox(ls_title,"백화점유형 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_grp")
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

is_dep_opt = dw_head.GetItemString(1, "dep_opt")
if IsNull(is_dep_opt) or Trim(is_dep_opt) = "" then
   MessageBox(ls_title,"작업구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dep_opt")
   return false
end if

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"종료일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

IF is_fr_ymd > is_to_ymd THEN
   MessageBox(ls_title,"시작일이 종료일 보다 큽니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
END IF

Return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.02.09                                                  */	
/* 수정일      : 2002.02.09                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_dep_opt = "E" then
	dw_2.visible = false
	dw_5.visible = true	

else	
	dw_2.visible = true
	dw_5.visible = false

end if	

il_rows = dw_body.retrieve(is_brand, is_shop_div, is_shop_grp)
IF il_rows > 0 THEN
	dw_1.Reset()
	dw_2.Reset()
	dw_3.Reset()
	dw_5.Reset()	
	dw_3.insertRow(0)
   idw_dep_seq.Retrieve(is_brand, is_year, is_season)
   idw_disc_seq.Retrieve(is_brand, is_year, is_season)	

	if is_dep_opt = "C" then 
		dw_3.object.disc_seq.visible = false
		dw_3.object.dep_seq.visible = true		
		dw_3.object.shop_type.visible = true
		dw_3.object.sale_type.visible = true		
		dw_3.object.dotcom.visible = true		
		cb_1.visible = true
		cb_1.text = "부진상품 일괄등록"
   elseif	is_dep_opt = "D" then
		dw_3.object.disc_seq.visible = true
		dw_3.object.dep_seq.visible = false
		dw_3.object.shop_type.visible = true
		dw_3.object.sale_type.visible = true	
		dw_3.object.dotcom.visible = true				
		cb_1.visible = true		
		cb_1.text = "품목할인 일괄등록"
   else	
		dw_3.object.disc_seq.visible = false
		dw_3.object.dep_seq.visible = false
		dw_3.object.shop_type.visible = false
		dw_3.object.sale_type.visible = false	
		dw_3.object.dotcom.visible = false
		cb_1.text = "색상별 사용불가"		
		cb_1.visible = false
		dw_3.enabled = false
		
		
	end if		
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
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
				
				ls_style =  lds_Source.GetItemString(1,"style")
				
				select dbo.SF_dc_except_chk(:ls_style)
				into :ls_dc_chk
				from dual;
				
				if ls_dc_chk = "Y" then 
					messagebox("알림!", "할인적용 별도 관리 품번 입니다! 확인후 처리 하세요!")
				end if	
								
				
				
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

RETURN 0

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         dw_1.Enabled = true
         dw_2.Enabled = true
         dw_3.Enabled = true
         dw_5.Enabled = true			
         cb_1.Enabled = true
      end if
   CASE 5    /* 조건 */
      dw_1.Enabled = false
      dw_2.Enabled = false
      dw_3.Enabled = false
      dw_5.Enabled = false		
      cb_1.Enabled = false
END CHOOSE

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.19                                                  */	
/* 수정일      : 2001.12.19                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_row_count1
datetime ld_datetime 
boolean  lb_ok
String   ls_shop_cd, ls_ErrMsg, ls_dc_chk_style, ls_dc_chk, ls_style

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_1.AcceptText()    <> 1 THEN RETURN -1
IF dw_2.AcceptText()    <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF



FOR i = 1 TO ll_row_count 
	 IF dw_body.Object.job_yn[i] = 'N' THEN CONTINUE 
	 ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
	 
    lb_ok = WF_SET_DATA1(ls_shop_cd) 
	 
    IF lb_ok THEN 
	    lb_ok = WF_SET_DATA2(ls_shop_cd) 
    END IF
	 
    IF lb_ok THEN
       DECLARE SP_56002_UPDATE PROCEDURE FOR SP_56002_UPDATE  
               @brand   = :is_brand,   
               @shop_cd = :ls_shop_cd,   
               @year    = :is_year,   
               @season  = :is_season,   
               @fr_ymd  = :is_fr_ymd, 
					@to_ymd  = :is_to_ymd;
					
       EXECUTE SP_56002_UPDATE;
	    IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
	       il_rows = 1
          commit  USING SQLCA;
	    ELSE
		    ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" +SQLCA.SQLERRTEXT
          Rollback  USING SQLCA;
	       MessageBox("저장 실패 [" + ls_shop_cd + "]", ls_ErrMsg)
		    il_rows = -1 
			 EXIT
	    END IF
    ELSE
	    ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" +SQLCA.SQLERRTEXT
       rollback  USING SQLCA;
       MessageBox("저장 실패 [" + ls_shop_cd + "]", ls_ErrMsg)
	    il_rows = -1 
		 EXIT
   END IF
NEXT

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56002_e","0")
end event

type cb_close from w_com010_e`cb_close within w_56002_e
end type

type cb_delete from w_com010_e`cb_delete within w_56002_e
boolean enabled = true
string text = "붙여넣기"
end type

event cb_delete::clicked;Long   ll_rows, ll_find, i, j, ll_deal_qty , ll_row 
String ls_shop_type, ls_style, ls_sale_type, ls_excp_yn, ls_color
decimal ldc_sale_price, ldc_dc_rate

if is_dep_opt = "E" then

		ll_rows = dw_6.RowCount()
		
		FOR i = 1 TO ll_rows 
			ls_shop_type   = dw_6.GetitemString(i, "shop_type")
			ls_style       = dw_6.GetitemString(i, "style")
			ls_color       = dw_6.GetitemString(i, "color")			
			ls_sale_type   = dw_6.GetitemString(i, "sale_type")
			ls_excp_yn     = dw_6.GetitemString(i, "excp_yn")
			ldc_sale_price = dw_6.GetitemNumber(i, "sale_price")
			ldc_dc_rate    = dw_6.GetitemNumber(i, "dc_rate")
			
			ll_find = dw_5.Find("shop_type = '" + ls_shop_type + "' and style = '" + ls_style + "' and color = '" + ls_color + "' and sale_type = '" + ls_sale_type + "'", 1, dw_5.RowCount())
			IF ll_find < 1 THEN
				ll_row     =  dw_5.insertRow(0)
				dw_5.Setitem(ll_row, "shop_type",   ls_shop_type)
				dw_5.Setitem(ll_row, "style",       ls_style)
				dw_5.Setitem(ll_row, "color",       ls_color)				
				dw_5.Setitem(ll_row, "sale_type",   ls_sale_type)
				dw_5.Setitem(ll_row, "excp_yn",     ls_excp_yn)		
				dw_5.Setitem(ll_row, "sale_price",  ldc_sale_price)
				dw_5.Setitem(ll_row, "dc_rate",     ldc_dc_rate)		
			END IF 
		NEXT 
else
	
		ll_rows = dw_4.RowCount()
		
		FOR i = 1 TO ll_rows 
			ls_shop_type   = dw_4.GetitemString(i, "shop_type")
			ls_style       = dw_4.GetitemString(i, "style")
			ls_sale_type   = dw_4.GetitemString(i, "sale_type")
			ls_excp_yn     = dw_4.GetitemString(i, "excp_yn")
			ldc_sale_price = dw_4.GetitemNumber(i, "sale_price")
			ldc_dc_rate    = dw_4.GetitemNumber(i, "dc_rate")
			
			ll_find = dw_2.Find("shop_type = '" + ls_shop_type + "' and style = '" + ls_style + "' and sale_type = '" + ls_sale_type + "'", 1, dw_2.RowCount())
			IF ll_find < 1 THEN
				ll_row     =  dw_2.insertRow(0)
				dw_2.Setitem(ll_row, "shop_type",   ls_shop_type)
				dw_2.Setitem(ll_row, "style",       ls_style)
				dw_2.Setitem(ll_row, "sale_type",   ls_sale_type)
				dw_2.Setitem(ll_row, "excp_yn",     ls_excp_yn)		
				dw_2.Setitem(ll_row, "sale_price",  ldc_sale_price)
				dw_2.Setitem(ll_row, "dc_rate",     ldc_dc_rate)		
			END IF 
		NEXT 	
end if	
		
ib_changed = true
cb_update.enabled = true

end event

type cb_insert from w_com010_e`cb_insert within w_56002_e
string text = "복사"
end type

event cb_insert::clicked;//ids_copy.Reset()

if is_dep_opt = "E" then
	dw_6.reset()
	dw_5.RowsCopy(1, dw_5.RowCount(), Primary!, dw_6, 1, Primary!)
else	
	dw_4.reset()
	dw_2.RowsCopy(1, dw_2.RowCount(), Primary!, dw_4, 1, Primary!)
end if	



end event

type cb_retrieve from w_com010_e`cb_retrieve within w_56002_e
end type

type cb_update from w_com010_e`cb_update within w_56002_e
end type

type cb_print from w_com010_e`cb_print within w_56002_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56002_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56002_e
end type

type cb_excel from w_com010_e`cb_excel within w_56002_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_56002_e
integer y = 160
integer height = 232
string dataobject = "d_56002_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("001")

This.GetChild("season", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("003", gs_brand, '%') 

This.GetChild("shop_div", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("910") 
ldw_child.SetFilter("inter_cd > 'A' and inter_cd < 'Z'")
ldw_child.Filter()

This.GetChild("shop_grp", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('912')
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", '%')
ldw_child.Setitem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_yymmdd 
String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "yymmdd"	
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
		  
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

type ln_1 from w_com010_e`ln_1 within w_56002_e
integer beginy = 396
integer endy = 396
end type

type ln_2 from w_com010_e`ln_2 within w_56002_e
integer beginy = 400
integer endy = 400
end type

type dw_body from w_com010_e`dw_body within w_56002_e
integer x = 2510
integer y = 416
integer width = 1111
integer height = 1608
boolean enabled = false
string dataobject = "d_56002_d03"
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

event dw_body::buttonclicked;call super::buttonclicked;Long i, ll_row 

ll_row = dw_body.RowCount()
IF ll_row < 1 THEN RETURN

IF dwo.name = "b_job_yn" THEN
	IF is_job_yn = 'Y' THEN 
		is_job_yn = 'N' 
	ELSE
		is_job_yn = 'Y' 
	END IF
	FOR i = 1 TO ll_row 
		dw_body.Object.job_yn[i] = is_job_yn
	NEXT 
END IF
end event

type dw_print from w_com010_e`dw_print within w_56002_e
end type

type dw_1 from datawindow within w_56002_e
event ue_keydown pbm_dwnkey
integer y = 416
integer width = 1797
integer height = 436
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_56002_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
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

event constructor;DataWindowChild ldw_child


This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("001")

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

This.SetRowFocusIndicator(Hand!)

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
String ls_null

CHOOSE CASE dwo.name
	CASE "shop_type" 
		This.Setitem(row, "sale_type", ls_null)
END CHOOSE

end event

event itemfocuschanged;/*===========================================================================*/
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
		idw_sale_type_1.SetFilter(ls_filter)
		idw_sale_type_1.Filter()
END CHOOSE

end event

event editchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemerror;return 1
end event

type cb_1 from commandbutton within w_56002_e
integer x = 1797
integer y = 416
integer width = 658
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "부진/품목할인 일괄등록"
end type

event clicked;String  ls_dep_seq, ls_shop_type, ls_sale_type, ls_dotcom,ls_dc_chk_style , ls_dc_chk
String  ls_style,   ls_find 
Long    ll_row ,ll_row_count1
Boolean lb_chk
integer i

if is_dep_opt = "C" then
	ls_dep_seq   = dw_3.GetitemString(1, "dep_seq") 
else	
	ls_dep_seq   = dw_3.GetitemString(1, "disc_seq") 
end if

ls_shop_type = dw_3.GetitemString(1, "shop_type") 
ls_sale_type = dw_3.GetitemString(1, "sale_type") 
ls_dotcom = dw_3.GetitemString(1, "dotcom") 

if IsNull(ls_dep_seq) or Trim(ls_dep_seq) = "" then
   MessageBox("일괄등록","부진차수를 입력하십시요!")
   dw_3.SetFocus()
   dw_3.SetColumn("dep_seq")
   return 
end if

if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
   MessageBox("일괄등록","매장형태를 입력하십시요!")
   dw_3.SetFocus()
   dw_3.SetColumn("shop_type")
   return 
end if

if IsNull(ls_sale_type) or Trim(ls_sale_type) = "" then
   MessageBox("일괄등록","판매형태를 입력하십시요!")
   dw_3.SetFocus()
   dw_3.SetColumn("sale_type")
   return 
end if

lb_chk = FALSE

if is_dep_opt = "C" then

		if ls_dotcom = "Y" then
			
			DECLARE dep_style CURSOR FOR			
				SELECT A.style 
				  FROM tb_12020_m a (nolock), tb_54020_h b (nolock)
				 WHERE a.brand   =  :is_brand
					AND a.year    =  :is_year 
					AND a.season  =  :is_season 
					AND a.dep_seq =  :ls_dep_seq 
					AND a.dep_fg  <> 'N'
					and a.style   = b.style
					and isnull(b.dotcom,'N') = 'Y' 
					and isnull(b.dotcom_cancel, 'N') = 'N';
			
			OPEN dep_style;
			
			FETCH dep_style INTO :ls_style;
			DO WHILE sqlca.sqlcode = 0  
				ls_find = "shop_type = '" + ls_shop_type + "' and style = '" + ls_style + "' and sale_type = '" + ls_sale_type + "'" 
				ll_row = dw_2.find(ls_find, 1, dw_2.RowCount()) 
				IF ll_row = 0 THEN
					ll_row = dw_2.insertRow(0)
					dw_2.Setitem(ll_row, "shop_type", ls_shop_type)
					dw_2.Setitem(ll_row, "style",     ls_style)
					dw_2.Setitem(ll_row, "sale_type", ls_sale_type)
					lb_chk = True 
				END IF
				FETCH dep_style INTO :ls_style;
			LOOP
			
			CLOSE dep_style;
		else
			DECLARE dep_style_3 CURSOR FOR			
				SELECT a.style 
				FROM tb_12020_m a (nolock), tb_54020_h b (nolock)
				WHERE a.brand   =  :is_brand
				AND a.year    =  :is_year 
				AND a.season  =  :is_season 
				AND a.dep_seq =  :ls_dep_seq 
				AND a.dep_fg  <> 'N'
				and a.style   = b.style
				and (isnull(b.dotcom,'N') = 'Y' and isnull(b.dotcom_cancel, 'N') = 'Y')
				union 
				SELECT a.style 
				FROM tb_12020_m a (nolock), tb_54020_h b (nolock)
				WHERE a.brand   =  :is_brand
				AND a.year    =  :is_year 
				AND a.season  =  :is_season 
				AND a.dep_seq =  :ls_dep_seq 
				AND a.dep_fg  <> 'N'
				and a.style   = b.style
				and isnull(b.dotcom,'N') = 'N';
			
			OPEN dep_style_3;
			
			FETCH dep_style_3 INTO :ls_style;
			DO WHILE sqlca.sqlcode = 0  
				ls_find = "shop_type = '" + ls_shop_type + "' and style = '" + ls_style + "' and sale_type = '" + ls_sale_type + "'" 
				ll_row = dw_2.find(ls_find, 1, dw_2.RowCount()) 
				IF ll_row = 0 THEN
					ll_row = dw_2.insertRow(0)
					dw_2.Setitem(ll_row, "shop_type", ls_shop_type)
					dw_2.Setitem(ll_row, "style",     ls_style)
					dw_2.Setitem(ll_row, "sale_type", ls_sale_type)
					lb_chk = True 
				END IF
				FETCH dep_style_3 INTO :ls_style;
			LOOP
			
			CLOSE dep_style_3;
		end if	
			
else			
			DECLARE dep_style_1 CURSOR FOR
				SELECT style 
				  FROM tb_54021_h (nolock)
				 WHERE brand   =  :is_brand
					AND year    =  :is_year 
					AND season  =  :is_season 
					AND dep_seq =  :ls_dep_seq 
					AND dep_fg  <> 'N';
			
			OPEN dep_style_1;
			
			FETCH dep_style_1 INTO :ls_style;
			DO WHILE sqlca.sqlcode = 0  
				ls_find = "shop_type = '" + ls_shop_type + "' and style = '" + ls_style + "' and sale_type = '" + ls_sale_type + "'" 
				ll_row = dw_2.find(ls_find, 1, dw_2.RowCount()) 
				IF ll_row = 0 THEN
					ll_row = dw_2.insertRow(0)
					dw_2.Setitem(ll_row, "shop_type", ls_shop_type)
					dw_2.Setitem(ll_row, "style",     ls_style)
					dw_2.Setitem(ll_row, "sale_type", ls_sale_type)
					lb_chk = True 
				END IF
				FETCH dep_style_1 INTO :ls_style;
			LOOP
			
			CLOSE dep_style_1;
end if
		
		
ls_dc_chk_style = ""
ll_row_count1 = dw_2.RowCount()

FOR i=1 TO ll_row_count1

	ls_style = 	dw_2.GetItemString(i, "style")
	
	select dbo.SF_dc_except_chk(:ls_style)
	into :ls_dc_chk
	from dual;
	
	if ls_dc_chk = "Y" then
		ls_dc_chk_style = ls_dc_chk_style + "|" + ls_style 
	end if	

   
NEXT

if ls_dc_chk_style <> "" then
	messagebox("알림!",ls_dc_chk_style + " 할인대상 품번이 포함되어 있습니다! 확인바랍니다!"		)
end if		
		
		
IF lb_chk THEN 
	ib_changed = true
   cb_update.enabled = true 
END IF

end event

type dw_3 from datawindow within w_56002_e
integer x = 1797
integer y = 500
integer width = 654
integer height = 336
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_56002_d99"
boolean border = false
boolean livescroll = true
end type

event constructor;DataWindowChild ldw_child

This.GetChild("dep_seq", idw_dep_seq)
idw_dep_seq.SetTransObject(SQLCA)

This.GetChild("disc_seq", idw_disc_seq)
idw_disc_seq.SetTransObject(SQLCA)


This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

end event

type cb_copy from commandbutton within w_56002_e
boolean visible = false
integer x = 1083
integer y = 40
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
//String ls_shop_type, ls_style, ls_sale_type, ls_excp_yn, ls_color
//decimal ldc_sale_price, ldc_dc_rate
//
////ll_rows = ids_copy.RowCount()
//
//if is_dep_opt = "E" then
//
//		ll_rows = dw_6.RowCount()
//		
//		FOR i = 1 TO ll_rows 
//			ls_shop_type   = dw_6.GetitemString(i, "shop_type")
//			ls_style       = dw_6.GetitemString(i, "style")
//			ls_color       = dw_6.GetitemString(i, "color")			
//			ls_sale_type   = dw_6.GetitemString(i, "sale_type")
//			ls_excp_yn     = dw_6.GetitemString(i, "excp_yn")
//			ldc_sale_price = dw_6.GetitemNumber(i, "sale_price")
//			ldc_dc_rate    = dw_6.GetitemNumber(i, "dc_rate")
//			
//			ll_find = dw_5.Find("shop_type = '" + ls_shop_type + "' and style = '" + ls_style + "' and color = '" + ls_color + "' and sale_type = '" + ls_sale_type + "'", 1, dw_5.RowCount())
//			IF ll_find < 1 THEN
//				ll_row     =  dw_5.insertRow(0)
//				dw_5.Setitem(ll_row, "shop_type",   ls_shop_type)
//				dw_5.Setitem(ll_row, "style",       ls_style)
//				dw_5.Setitem(ll_row, "color",       ls_color)				
//				dw_5.Setitem(ll_row, "sale_type",   ls_sale_type)
//				dw_5.Setitem(ll_row, "excp_yn",     ls_excp_yn)		
//				dw_5.Setitem(ll_row, "sale_price",  ldc_sale_price)
//				dw_5.Setitem(ll_row, "dc_rate",     ldc_dc_rate)		
//			END IF 
//		NEXT 
//else
//	
//		ll_rows = dw_4.RowCount()
//		
//		FOR i = 1 TO ll_rows 
//			ls_shop_type   = dw_4.GetitemString(i, "shop_type")
//			ls_style       = dw_4.GetitemString(i, "style")
//			ls_sale_type   = dw_4.GetitemString(i, "sale_type")
//			ls_excp_yn     = dw_4.GetitemString(i, "excp_yn")
//			ldc_sale_price = dw_4.GetitemNumber(i, "sale_price")
//			ldc_dc_rate    = dw_4.GetitemNumber(i, "dc_rate")
//			
//			ll_find = dw_2.Find("shop_type = '" + ls_shop_type + "' and style = '" + ls_style + "' and sale_type = '" + ls_sale_type + "'", 1, dw_2.RowCount())
//			IF ll_find < 1 THEN
//				ll_row     =  dw_2.insertRow(0)
//				dw_2.Setitem(ll_row, "shop_type",   ls_shop_type)
//				dw_2.Setitem(ll_row, "style",       ls_style)
//				dw_2.Setitem(ll_row, "sale_type",   ls_sale_type)
//				dw_2.Setitem(ll_row, "excp_yn",     ls_excp_yn)		
//				dw_2.Setitem(ll_row, "sale_price",  ldc_sale_price)
//				dw_2.Setitem(ll_row, "dc_rate",     ldc_dc_rate)		
//			END IF 
//		NEXT 	
//end if	
//		
//ib_changed = true
//cb_update.enabled = true

end event

type dw_4 from datawindow within w_56002_e
boolean visible = false
integer x = 233
integer y = 1052
integer width = 2194
integer height = 860
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_56002_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_5 from datawindow within w_56002_e
event ue_keydown pbm_dwnkey
boolean visible = false
integer y = 856
integer width = 2496
integer height = 1168
integer taborder = 50
boolean bringtotop = true
string title = "품번별"
string dataobject = "d_56002_d02_color"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
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

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

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

This.SetRowFocusIndicator(Hand!)

end event

event editchanged;ib_changed = true
cb_update.enabled = true

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
String ls_null, ls_color_nm

CHOOSE CASE dwo.name	
	CASE "shop_type" 
		This.Setitem(row, "style", ls_null)
		This.Setitem(row, "sale_type", ls_null)
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
      IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "color" 
		select dbo.sf_color_nm(:data,'e')
		into :ls_color_nm
		from dual;
		
		This.Setitem(row, "color_nm", ls_color_nm)		
		
END CHOOSE

end event

event itemerror;return 1
end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm, ls_shop_type, ls_filter, ls_style, ls_chno
ls_column_nm = This.GetColumnName()

DataWindowChild  ldw_child

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
		
END CHOOSE

end event

type dw_2 from datawindow within w_56002_e
event ue_keydown pbm_dwnkey
integer y = 856
integer width = 2496
integer height = 1168
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string title = "품번별"
string dataobject = "d_56002_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
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

This.SetRowFocusIndicator(Hand!)

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
String ls_null

CHOOSE CASE dwo.name	
	CASE "shop_type" 
		This.Setitem(row, "style", ls_null)
		This.Setitem(row, "sale_type", ls_null)
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
      IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event itemfocuschanged;/*===========================================================================*/
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
		idw_sale_type_2.SetFilter(ls_filter)
		idw_sale_type_2.Filter()
END CHOOSE

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

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event editchanged;ib_changed = true
cb_update.enabled = true

end event

event itemerror;return 1
end event

type dw_6 from datawindow within w_56002_e
boolean visible = false
integer x = 2610
integer y = 796
integer width = 3250
integer height = 860
integer taborder = 60
boolean titlebar = true
string title = "none"
string dataobject = "d_56002_d02_color"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

