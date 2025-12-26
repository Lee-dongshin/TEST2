$PBExportHeader$w_51009_e.srw
$PBExportComments$행사계획서 등록
forward
global type w_51009_e from w_com020_e
end type
type dw_1 from datawindow within w_51009_e
end type
type dw_2 from datawindow within w_51009_e
end type
type cb_all from commandbutton within w_51009_e
end type
end forward

global type w_51009_e from w_com020_e
boolean visible = false
dw_1 dw_1
dw_2 dw_2
cb_all cb_all
end type
global w_51009_e w_51009_e

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_dep_seq, idw_shop_div
String is_brand, is_frm_ymd, is_to_ymd, is_shop_cd, is_yymmdd, IS_CANCEL_YN, is_shop_div
end variables

forward prototypes
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.05.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_null
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn , ls_brand2
String ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
Long   ll_tag_price,  ll_cnt 
SetNull(ls_null)


IF al_row > 1 and LenA(as_style_no) <> 9 THEN
	gf_style_edit(dw_2.Object.style[al_row - 1], as_style_no, ls_style, ls_chno) 
   IF ls_chno = '%' THEN ls_chno = '0' 
ELSE 
	ls_style = LeftA(as_style_no, 8)
	ls_chno  = MidA(as_style_no, 9, 1)
END IF 

ls_plan_yn = 'Y'

Select count(style), 
       max(style)  ,   max(chno), 
       max(brand)  ,   max(year),     max(season),     
       max(sojae)  ,   max(item),     max(tag_price)  
  into :ll_cnt     , 
       :ls_style   ,   :ls_chno, 
       :ls_brand   ,   :ls_year,      :ls_season, 
		 :ls_sojae   ,   :ls_item,      :ll_tag_price
  from vi_12020_1 with (nolock) 
 where style   like :ls_style 
	and plan_yn like :ls_plan_yn
	and brand   = 	  :is_brand
	and isnull(tag_price, 0) <> 0;
	
IF SQLCA.SQLCODE <> 0 or ll_cnt <> 1 THEN 
	Return False 
END IF 


   dw_2.SetItem(al_row, "style",    ls_style)
	dw_2.SetItem(al_row, "brand",    ls_brand)


Return True

end function

on w_51009_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.cb_all=create cb_all
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.cb_all
end on

on w_51009_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.cb_all)
end on

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_yymmdd, is_shop_cd, IS_CANCEL_YN, is_shop_div)
dw_body.Reset()
dw_1.Reset()
dw_2.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)
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


is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = "%"
//   MessageBox(ls_title,"해당매장을 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("is_shop_cd")
//   return false
end if

is_CANCEL_YN = dw_head.GetItemSTRING(1, "CANCEL_YN")
if IsNull(is_CANCEL_YN) or Trim(is_CANCEL_YN) = "" then
   MessageBox(ls_title,"진행여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("CANCEL_YN")
   return false
end if

if is_shop_cd <> '%' then
	if is_brand <> MidA(is_shop_cd,1,1) then
		messagebox('확인','매장코드를 확인해 주세요!')
		dw_head.SetFocus()
		dw_head.SetColumn("shop_cd")	
		return false
	end if
end if


is_shop_div = dw_head.GetItemSTRING(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if




return true
end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범) 				   									  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(dw_1, "ScaleToBottom")
inv_resize.of_Register(dw_2, "ScaleToBottom")

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
//dw_3.SetTransObject(SQLCA)
//if gs_dept_cd = '9000' or gs_dept_cd = 'T400' or gs_dept_cd = '5000' or gs_dept_cd = 'R400' or gs_dept_cd = 'RB20' or gs_dept_cd = 'R340' or gs_dept_cd = 'T500' then
	cb_all.visible = true
//else
//	cb_all.visible = false
//end if
end event

event resize;call super::resize;decimal ld_increase , ld_increase1, LD_WIND, LD_WINDOW_HEIGHT
ld_increase  = 868
ld_increase1 = dw_BODY.WIDTH / 2
LD_WINDOW_HEIGHT = THIS.HEIGHT

dw_BODY.resize(ld_increase1 * 2, ld_increase )



dw_1.y = DW_BODY.y + ld_increase  + 10
dw_2.y = DW_BODY.y + ld_increase  + 10

dw_1.resize(ld_increase1 -5, LD_WINDOW_HEIGHT - 1380 ) //DW_BODY.Y + ld_increase  - 20  )

LD_WIND = DW_1.WIDTH
dw_2.X = DW_1.X + LD_WIND + 10
dw_2.resize(ld_increase1 -5, LD_WINDOW_HEIGHT - 1380 ) //DW_BODY.Y + ld_increase  - 20 )

cb_all.x = cb_insert.x + cb_all.width

//dw_2.resize(ld_increase1 -5, 842 )

end event

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long	ll_cur_row

if dw_body.AcceptText() <> 1 then return

/* 추가시 수정자료가 있을때 저장여부 확인 */
if ib_changed then 
	CHOOSE CASE gf_update_yn(This.title)
		CASE 1
			IF This.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 2
			ib_changed = false
		CASE 3
			RETURN
	END CHOOSE
end if

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
END IF

dw_body.  SetRedraw(False)
dw_body.  Reset()


if IsNull(is_shop_cd) or Trim(is_shop_cd) = "%"  then
	messagebox("경고!", "해당매장을 입력해주세요!")
	return
else
	il_rows = dw_body.InsertRow(0)
	dw_1.  Reset()
	dw_2.  Reset()
end if	


dw_body.SetColumn(ii_min_column_id)
dw_body.SetFocus()

dw_body.  SetRedraw(True)


This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
	CASE 1		/* 조회 */
		cb_retrieve.Text = "조건(&Q)"
		dw_head.Enabled = false
		dw_list.Enabled = true
		If al_rows <= 0 Then
			dw_body.Enabled = true
//			 if gs_brand = "O" then
//				if gs_dept_cd = "4100" or gs_dept_cd ="5400" or gs_dept_cd = "K140" or gs_dept_cd = "T310" or gs_dept_cd = "9000" then
//					dw_1.enabled = true
//					dw_2.enabled = true
//				else	
//					dw_1.enabled = false
//					dw_2.enabled = false
//				end if	
//			 else	
					dw_1.enabled = true
					dw_2.enabled = true
//			 end if		

		End If
	CASE 2   /* 추가 */
		if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_list.Enabled = true
				dw_body.Enabled = true
//			 if gs_brand = "O" then
//				if gs_dept_cd = "4100" or gs_dept_cd ="5400" or gs_dept_cd = "K140" or gs_dept_cd = "T310" or gs_dept_cd = "9000" then
//					dw_1.enabled = true
//					dw_2.enabled = true
//				else	
//					dw_1.enabled = false
//					dw_2.enabled = false
//				end if	
//			 else	
					dw_1.enabled = true
					dw_2.enabled = true
//			 end if		
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
//         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_insert.enabled = true
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_1.Enabled = false
      dw_2.Enabled = false		
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_insert.enabled  = false
         cb_delete.enabled  = true
         cb_print.enabled   = true
         cb_preview.enabled = true
         cb_excel.enabled   = true
			dw_body.enabled    = true
//			 if gs_brand = "O" then
//				if gs_dept_cd = "4100" or gs_dept_cd ="5400" or gs_dept_cd = "K140" or gs_dept_cd = "T310" or gs_dept_cd = "9000" then
//					dw_1.enabled = true
//					dw_2.enabled = true
//				else	
//					dw_1.enabled = false
//					dw_2.enabled = false
//				end if	
//			 else	
					dw_1.enabled = true
					dw_2.enabled = true
//			 end if		
		else
         cb_delete.enabled  = false
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
//         cb_insert.enabled = true
      end if
END CHOOSE

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
String     ls_style2
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV  IN ('G', 'K', 'B','I') " + &
											 "  AND BRAND = '" + ls_brand + "'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
	CASE "style"		
			IF ai_div = 1 THEN 	
				IF wf_style_chk(al_row, as_data)  THEN 
					RETURN 2 
				END IF 
			END IF
			IF al_row > 1 THEN 
				gf_style_edit(dw_2.object.style[al_row -1], as_data, ls_style, ls_chno)
			ELSE
		      ls_style = MidA(as_data, 1, 8)
		      ls_chno  = MidA(as_data, 9, 1) 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com011" 
			gst_cd.default_where   = "WHERE brand = '" + is_brand + "' " + & 
			                         "  AND isnull(tag_price, 0) <> 0 AND plan_yn = 'Y' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lb_check = FALSE 
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_2.SetRow(al_row)
				   dw_2.SetColumn(as_column)
				END IF
				
				   dw_2.SetItem(al_row, "style",    lds_Source.GetItemString(1,"style"))
				   dw_2.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand"))
				   ib_changed = true
               cb_update.enabled = true
				   /* 다음컬럼으로 이동 */
			      lb_check = TRUE 									
					ib_itemchanged = FALSE

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

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
integer li_no
datetime ld_datetime
string ls_frm_ymd, ls_to_ymd, LS_DEP, LS_PLAN, ls_fr_year, ls_fr_season 
LONG LL_ROW_CNT1, LL_ROW_CNT2

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

//LL_ROW_CNT1 = dw_1.RowCount()
//LL_ROW_CNT2 = dw_2.RowCount()
//
//LS_DEP = dw_BODY.GetItemsTRING(1, "DEP_PARTI")
//if IsNull(LS_DEP) or Trim(LS_DEP) = "" then 
//ELSE
//	IF LL_ROW_CNT1 < 1 THEN 
//		MESSAGEBOX("경고!", "부진내역이 있는 경우 상세 내역을 입력하셔야 합니다!")
//		Return 0
//	END IF		
//end if
//
//LS_PLAN = dw_BODY.GetItemsTRING(1, "PLAN_PARTI")
//if IsNull(LS_PLAN) or Trim(LS_PLAN) = "" then 
//ELSE
//	IF LL_ROW_CNT2 < 1 THEN 
//		MESSAGEBOX("경고!", "기획내역이 있는 경우 상세 내역을 입력하셔야 합니다!")
//		Return 0
//	END IF		
//end if

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_frm_ymd = dw_body.getitemstring(1, "frm_ymd")
ls_to_ymd  = dw_body.getitemstring(1, "to_ymd")
ls_fr_year = dw_body.getitemstring(1, "fr_year")
ls_fr_season  = dw_body.getitemstring(1, "fr_season")

//if ls_fr_year = "%"  or  ls_fr_season = "%" then
//	messagebox("경고!", "행사진행 최소 제품년도시즌을 등록 하시기 바랍니다!")
//	Return 0
//end if	
//
if gf_datechk(ls_frm_ymd) = false then
	messagebox("경고!", "시작일자가 형식에 맞지 않습니다!")
	Return 0
end if	

if gf_datechk(ls_to_ymd) = false then
	messagebox("경고!", "마지막일자가 형식에 맞지 않습니다!")
	Return 0
end if	

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				
		/* New Record */
      dw_body.Setitem(i, "shop_cd", is_shop_cd)		
      dw_body.Setitem(i, "brand"  , is_brand)				
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
	
	ls_frm_ymd = dw_body.getitemstring(1,"frm_ymd")
	ls_to_ymd = dw_body.getitemstring(1,"to_ymd")	

	select convert(int,	isnull(max(no), '0')) + 1
	into :li_no 
	from tb_51036_d (nolock)
	where shop_cd = :is_shop_cd
	  and frm_ymd = :ls_frm_ymd;
//	  and to_ymd  = :ls_to_ymd;
	
	ll_row_count = dw_1.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_1.GetItemStatus(i, 0, Primary!)
	
   IF idw_status = NewModified! THEN				
		/* New Record */
      dw_1.Setitem(i, "shop_cd", is_shop_cd)				
		dw_1.setitem(i, "frm_ymd", ls_frm_ymd)
		dw_1.setitem(i, "to_ymd" , ls_to_ymd)	
		dw_1.setitem(i, "no"     , string(li_no, '0000'))	
      dw_1.Setitem(i, "brand"  , is_brand)				
      dw_1.Setitem(i, "reg_id", gs_user_id)
		li_no = li_no + 1
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_1.Setitem(i, "mod_id", gs_user_id)
      dw_1.Setitem(i, "mod_dt", ld_datetime)
   END IF
	

 NEXT	
	il_rows = dw_1.Update(TRUE, FALSE)

	if il_rows = 1 then
   	dw_1.ResetUpdate()
	   commit  USING SQLCA;
		
			ll_row_count = dw_2.RowCount()
			FOR i=1 TO ll_row_count
			idw_status = dw_2.GetItemStatus(i, 0, Primary!)
			IF idw_status = NewModified! THEN				
				/* New Record */
				dw_2.Setitem(i, "shop_cd", is_shop_cd)				
				dw_2.setitem(i, "frm_ymd", ls_frm_ymd)
				dw_2.setitem(i, "to_ymd" , ls_to_ymd)	
				dw_2.setitem(i, "no"     , string(i, "0000"))	
				dw_2.Setitem(i, "brand"  , is_brand)				
				dw_2.Setitem(i, "reg_id", gs_user_id)
			ELSEIF idw_status = DataModified! THEN		/* Modify Record */
				dw_2.Setitem(i, "mod_id", gs_user_id)
				dw_2.Setitem(i, "mod_dt", ld_datetime)
			END IF
			NEXT
			il_rows = dw_2.Update(TRUE, FALSE)
			
			if il_rows = 1 then
		   	dw_1.ResetUpdate()
	   		commit  USING SQLCA;
			else	
				 rollback  USING SQLCA;
			end if	 		
	else
		 rollback  USING SQLCA;
	end if	
	
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_51009_e","0")
end event

event open;call super::open;
//4100	관리팀
//5400	영업관리팀
//K140	W.관리팀
//T310	관리팀


end event

type cb_close from w_com020_e`cb_close within w_51009_e
end type

type cb_delete from w_com020_e`cb_delete within w_51009_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_51009_e
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_51009_e
end type

type cb_update from w_com020_e`cb_update within w_51009_e
end type

type cb_print from w_com020_e`cb_print within w_51009_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_51009_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_51009_e
end type

type cb_excel from w_com020_e`cb_excel within w_51009_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_51009_e
integer y = 156
integer width = 4174
integer height = 184
string dataobject = "d_51009_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')



This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_51009_e
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com020_e`ln_2 within w_51009_e
integer beginy = 352
integer endy = 352
end type

type dw_list from w_com020_e`dw_list within w_51009_e
integer x = 5
integer y = 364
integer width = 1385
integer height = 1636
string dataobject = "D_51009_D01"
end type

event dw_list::clicked;call super::clicked;string ls_shop_nm
String ls_brand, ls_year
DataWindowChild ldw_season


IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_shop_cd = This.GetItemString(row, 'shop_cd')
is_frm_ymd = This.GetItemString(row, 'frm_ymd')
is_to_ymd  = This.GetItemString(row, 'to_ymd') 

IF IsNull(is_shop_cd) or IsNull(is_frm_ymd) or IsNull(is_to_ymd) THEN return

dw_head.setitem(1, "shop_cd", is_shop_cd)
if gf_shop_nm(is_shop_cd, 'S', ls_shop_nm) = 0 THEN
   dw_head.SetItem(1, "shop_nm", ls_shop_nm)
end if	
dw_1.reset()
dw_2.reset()
dw_body.reset()


dw_body.GetChild("fr_season", ldw_season)
ldw_season.SetTransObject(SQLCA)
//ldw_season.Retrieve('003')
ldw_season.Retrieve('003', is_brand, '%')
ldw_season.InsertRow(1)
ldw_season.SetItem(1, "inter_cd", '%')
ldw_season.SetItem(1, "inter_nm", '전체')


dw_1.GetChild("season", ldw_season)
ldw_season.SetTransObject(SQLCA)
//ldw_season.Retrieve('003')
ldw_season.Retrieve('003', is_brand, '%')
ldw_season.InsertRow(1)
ldw_season.SetItem(1, "inter_cd", '%')
ldw_season.SetItem(1, "inter_nm", '전체')

il_rows = dw_1.retrieve(is_shop_cd, is_frm_ymd, is_to_ymd, is_brand)
il_rows = dw_2.retrieve(is_shop_cd, is_frm_ymd, is_to_ymd, is_brand)
il_rows = dw_body.retrieve(is_shop_cd, is_frm_ymd, is_to_ymd, is_brand, IS_CANCEL_YN)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_51009_e
integer x = 1390
integer y = 364
integer width = 2327
integer height = 800
string dataobject = "d_51009_d02"
boolean hscrollbar = true
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
		If dw_body.GetColumnName() = 'sale_scale' OR dw_body.GetColumnName() = 'note' OR dw_body.GetColumnName() = 'DEP_PARTI' OR dw_body.GetColumnName() = 'PLAN_PARTI' Then
			RETURN 0
		else  
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		END IF	



	CASE KeyUpArrow!, KeyDownArrow!, KeyPageUp!, KeyPageDown!
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
		// Column.Protect = True Then Return
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0 
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0 
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

Return 0

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_season, ldw_year
String ls_brand, ls_year


This.GetChild("fr_year", ldw_year)
ldw_year.SetTransObject(SQLCA)
ldw_year.Retrieve('002')
ldw_year.InsertRow(1)
ldw_year.SetItem(1, "inter_cd", '%')
ldw_year.SetItem(1, "inter_cd1", '%')
ldw_year.SetItem(1, "inter_nm", '전체')


This.GetChild("fr_season", ldw_season)
ldw_season.SetTransObject(SQLCA)
//ldw_season.Retrieve('003')
ldw_season.Retrieve('003', gs_brand, '%')
ldw_season.InsertRow(1)
ldw_season.SetItem(1, "inter_cd", '%')
ldw_season.SetItem(1, "inter_nm", '전체')


if gs_brand = "O" then
	if gs_dept_cd = "4100" or gs_dept_cd ="5400" or gs_dept_cd = "K140" or gs_dept_cd = "T310" or gs_dept_cd = "9000" then
		dw_body.object.fr_year.protect   = false
		dw_body.object.fr_season.protect = false
	else	
		dw_body.object.fr_year.protect   = true	
		dw_body.object.fr_season.protect = true	
	
	end if	
else	
		dw_body.object.fr_year.protect   = false
		dw_body.object.fr_season.protect = false
end if		


end event

event dw_body::itemchanged;call super::itemchanged;
DataWindowChild ldw_season
string ls_year

this.accepttext()

CHOOSE CASE dwo.name
	CASE  "fr_year"
		ls_year = data
	
		this.getchild("fr_season",ldw_season)
		ldw_season.settransobject(sqlca)
		ldw_season.retrieve('003', is_brand, ls_year)
		ldw_season.insertrow(1)
		ldw_season.Setitem(1, "inter_cd", "%")
		ldw_season.Setitem(1, "inter_nm", "전체")
		
		
END CHOOSE

end event

type st_1 from w_com020_e`st_1 within w_51009_e
boolean visible = false
integer x = 832
integer y = 364
integer width = 41
integer height = 1680
end type

type dw_print from w_com020_e`dw_print within w_51009_e
integer x = 1678
integer y = 252
end type

type dw_1 from datawindow within w_51009_e
event ue_keydown pbm_dwnkey
integer x = 1390
integer y = 1172
integer width = 1755
integer height = 832
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_51009_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
		IF ls_column_name = "dep_seq" THEN 
			IF This.GetRow() = This.RowCount() THEN
			il_rows = This.InsertRow(0)				
			This.SetColumn(il_rows)
		   END IF
		END IF
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
	CASE KeyUpArrow!, KeyDownArrow!, KeyPageUp!, KeyPageDown!
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
		// Column.Protect = True Then Return
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0 
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0 
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

Return 0

end event

event itemfocuschanged;String ls_year, ls_season

CHOOSE CASE dwo.name
	CASE "dep_seq"
		ls_year = This.GetitemString(row, "year")
		ls_season  = This.GetitemString(row, "season")
		This.GetChild("dep_seq", idw_dep_seq)
		idw_dep_seq.SetTRansObject(SQLCA)		
		idw_dep_seq.Retrieve(is_brand, ls_year, ls_season)

END CHOOSE

end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report, ls_yymmdd, ls_judg_fg
Long ll_row

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Choose Case ls_column_nm
	Case "add"
			il_rows = This.InsertRow(0)				
			This.SetColumn(il_rows)
	Case "delete"
		ll_row = This.GetRow()
		if ll_row <= 0 then return

		idw_status = This.GetItemStatus(ll_row, 0, Primary!)
		il_rows = This.DeleteRow(ll_row)
		This.SetFocus()
		Parent.Trigger Event ue_button (4, il_rows)
End Choose

end event

event constructor;This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')


This.GetChild("dep_seq", idw_dep_seq)
idw_dep_seq.SetTRansObject(SQLCA)
idw_dep_seq.Retrieve('%','%','%')

end event

event editchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event clicked;
CHOOSE CASE dwo.name

	CASE "year"  	     //  Popup 검색창이 존재하는 항목 
		ib_changed = true
		cb_update.enabled = true
		cb_print.enabled = false
		cb_preview.enabled = false
		cb_excel.enabled = false

   case  "season" 
		ib_changed = true
		cb_update.enabled = true
		cb_print.enabled = false
		cb_preview.enabled = false
		cb_excel.enabled = false
		
	case 	"dep_seq"
		ib_changed = true
		cb_update.enabled = true
		cb_print.enabled = false
		cb_preview.enabled = false
		cb_excel.enabled = false


END CHOOSE



end event

event itemchanged;DataWindowChild ldw_season
string ls_year

this.accepttext()

CHOOSE CASE dwo.name
	CASE  "year"
		ls_year = data
	
		this.getchild("season",ldw_season)
		ldw_season.settransobject(sqlca)
		ldw_season.retrieve('003', is_brand, ls_year)
		ldw_season.insertrow(1)
		ldw_season.Setitem(1, "inter_cd", "%")
		ldw_season.Setitem(1, "inter_nm", "전체")
		
		
END CHOOSE

end event

type dw_2 from datawindow within w_51009_e
event ue_keydown pbm_dwnkey
integer x = 3145
integer y = 1172
integer width = 713
integer height = 832
integer taborder = 40
string title = "none"
string dataobject = "d_51009_d04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
			IF ls_column_name = "style" THEN 
			IF This.GetRow() = This.RowCount() THEN
			il_rows = This.InsertRow(0)				
			This.SetColumn(il_rows)
		   END IF
		END IF
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
	CASE KeyUpArrow!, KeyDownArrow!, KeyPageUp!, KeyPageDown!
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
		// Column.Protect = True Then Return
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0 
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0 
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

Return 0

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/



Long    ll_ret
String ls_null
Setnull(ls_null) 

CHOOSE CASE dwo.name
	CASE "style"	
		if ib_itemchanged then
			messagebox("", "return 1")
		else	
			messagebox("", "return 2")	
		end if
		
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
END CHOOSE

end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report, ls_yymmdd, ls_judg_fg
Long ll_row

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Choose Case ls_column_nm
	Case "add"
			il_rows = This.InsertRow(0)
			This.SetColumn(il_rows)
	Case "delete"
		ll_row = This.GetRow()
		if ll_row <= 0 then return

		idw_status = This.GetItemStatus(ll_row, 0, Primary!)
		il_rows = This.DeleteRow(ll_row)
		This.SetFocus()
		Parent.Trigger Event ue_button (4, il_rows)
   Case Else
		Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)		
End Choose

end event

event editchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

type cb_all from commandbutton within w_51009_e
integer x = 2450
integer y = 44
integer width = 347
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일괄등록"
end type

event clicked;open(w_51009_chk)
end event

