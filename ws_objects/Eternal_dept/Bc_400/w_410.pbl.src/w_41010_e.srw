$PBExportHeader$w_41010_e.srw
$PBExportComments$제품이체등록
forward
global type w_41010_e from w_com010_e
end type
type cb_input from commandbutton within w_41010_e
end type
type dw_list from datawindow within w_41010_e
end type
end forward

global type w_41010_e from w_com010_e
integer width = 3680
integer height = 2276
event ue_input ( )
cb_input cb_input
dw_list dw_list
end type
global w_41010_e w_41010_e

type variables
DataWindowChild  idw_brand, idw_color, idw_size , idw_to_brand
String is_brand,    is_yymmdd,    is_fr_house, is_to_house
String is_fr_style, is_fr_chno,   is_to_style, is_to_chno 
String is_fr_year,  is_fr_season, is_fr_sojae, is_fr_item 
String is_to_year,  is_to_season, is_to_sojae, is_to_item 
String is_fr_cust,  is_to_cust ,is_to_brand, is_chn_yn
Long   il_fr_tag_price,   il_to_tag_price,  il_fr_make_price, il_to_make_price

end variables

forward prototypes
public function boolean wf_style_chk (string as_column, string as_style_no, string as_brand)
end prototypes

event ue_input();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
dw_list.Visible   = False
dw_body.Visible   = True

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if IsNull(is_fr_house) or Trim(is_fr_house) = "" then
   MessageBox("등록오류","FROM 창고코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_house")
   return 
end if

if IsNull(is_to_house) or Trim(is_to_house) = "" then
   MessageBox("등록오류","TO 창고코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_house")
   return 
end if

if IsNull(is_fr_style) or Trim(is_fr_style) = "" then
   MessageBox("등록오류","FROM 품번코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_style_no")
   return 
end if

if IsNull(is_to_style) or Trim(is_to_style) = "" then
   MessageBox("등록오류","TO 품번코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_style_no")
   return 
end if 

IF is_fr_style = is_to_style THEN
   MessageBox("등록오류","같은 품번코드는 이체할수 없습니다.")
   dw_head.SetFocus()
   dw_head.SetColumn("to_style_no")
   return 
end if 

il_rows = dw_body.Retrieve(is_fr_style, is_fr_chno, is_fr_house)

IF il_rows > 0 THEN
	idw_color.Retrieve(is_to_style, is_to_chno)
   dw_body.SetFocus()
ELSE
	MessageBox("확인", "[" + is_fr_style + is_fr_chno + "] 재고 내역이 없습니다.")
END IF

This.Trigger Event ue_button(6, il_rows)
end event

public function boolean wf_style_chk (string as_column, string as_style_no, string as_brand);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno

IF LenA(Trim(as_style_no)) <> 9 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)

IF as_column = 'fr_style_no' THEN
	Select year,     season,    sojae,   
			 item,     cust_cd,   make_price, 
			 tag_price
	  into :is_fr_year, :is_fr_season, :is_fr_sojae, 
			 :is_fr_item, :is_fr_cust,   :il_fr_make_price, 
			 :il_fr_tag_price 
	  from vi_12020_1 
	 where style   =    :ls_style 
		and chno    =    :ls_chno
		and brand   =    :as_brand 
		and tag_price <> 0 ;
ELSE
	Select year,     season,    sojae,   
			 item,     cust_cd,   make_price, 
			 tag_price
	  into :is_to_year, :is_to_season, :is_to_sojae, 
			 :is_to_item, :is_to_cust,   :il_to_make_price, 
			 :il_to_tag_price 
	  from vi_12020_1 
	 where style   =    :ls_style 
		and chno    =    :ls_chno
		and brand   =    :as_brand 
		and tag_price <> 0 ;
END IF

IF SQLCA.SQLCODE <> 0 THEN 
	Return False 
END IF

Return True

end function

on w_41010_e.create
int iCurrent
call super::create
this.cb_input=create cb_input
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_input
this.Control[iCurrent+2]=this.dw_list
end on

on w_41010_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_input)
destroy(this.dw_list)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_list, "ScaleToRight&Bottom")
inv_resize.of_Register(cb_input, "FixedToRight")

dw_list.SetTransObject(SQLCA)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 6 - 입력  */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows >= 0 then
         cb_print.enabled   = true
         cb_preview.enabled = true
         cb_excel.enabled   = true
         cb_insert.enabled  = false
         cb_delete.enabled  = false
         cb_update.enabled  = false
         cb_input.Text      = "등록(&I)"
         dw_head.enabled    = true 
         dw_body.enabled    = false
         ib_changed         = false
      end if
	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed         = false
			cb_print.enabled   = true
			cb_preview.enabled = true
			cb_excel.enabled   = true
			cb_delete.enabled  = false
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
      cb_input.Text = "등록(&I)"
      cb_insert.enabled  = false
      cb_delete.enabled  = false
      cb_print.enabled   = false
      cb_preview.enabled = false
      cb_excel.enabled   = false
      cb_update.enabled  = false 
      ib_changed         = false
      dw_body.Enabled    = false
      dw_head.Enabled    = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 6		/* 입력 */
      if al_rows > 0 then
         cb_insert.enabled  = true
         cb_delete.enabled  = true
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
         dw_head.Enabled    = false
         dw_body.Enabled    = true
         dw_body.SetFocus()
         ib_changed = false
         cb_update.enabled = false
         cb_input.Text = "조건(&I)"
      else
         cb_insert.enabled  = false
         cb_delete.enabled  = false
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
      end if

END CHOOSE

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String   ls_title, ls_style_no 

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

is_to_brand = dw_head.GetItemString(1, "to_brand")
if IsNull(is_to_brand) or Trim(is_to_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_brand")
   return false
end if

//messagebox("is_brand", is_brand)
//messagebox("is_to_brand", is_to_brand)
//
if is_brand = "O" and ( is_to_brand = "A"  or is_to_brand = "O" ) then 
elseif is_brand = "A" and is_to_brand <> "O" then 
	MessageBox(ls_title,"이체대상브랜드를 확인 하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_brand")
	return false		
elseif is_brand = "N" and ( is_to_brand = "A"  or is_to_brand = "O" ) then 
	MessageBox(ls_title,"이체대상브랜드를 확인 하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_brand")
	return false	

end if



is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

is_fr_house = dw_head.GetItemString(1, "fr_house")
is_to_house = dw_head.GetItemString(1, "to_house")

ls_style_no = dw_head.GetItemString(1, "fr_style_no")
is_fr_style = LeftA(ls_style_no, 8)
is_fr_chno  = RightA(ls_style_no, 1)

ls_style_no = dw_head.GetItemString(1, "to_style_no")
is_to_style = LeftA(ls_style_no, 8)
is_to_chno  = RightA(ls_style_no, 1)
is_chn_yn  =  dw_head.GetItemString(1, "chn_yn")

return true 
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/
IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(This.title)
		CASE 1
			IF This.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			dw_body.SetFocus()
			RETURN
	END CHOOSE
END IF

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_yymmdd)

IF il_rows >= 0 THEN
	dw_list.Visible = True
	dw_body.Visible = False
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_brand, ls_style, ls_chno, ls_to_brand
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "fr_style_no"
			ls_brand = dw_head.GetitemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF wf_style_chk(as_column, as_data, ls_brand)  THEN 
					RETURN 0 
				END IF 
			END IF
	      ls_style = MidA(as_data, 1, 8)
	      ls_chno  = MidA(as_data, 9, 1) 
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			// 스타일 선별작업
//				IF  gl_user_level = 0 then 
//					gst_cd.default_where   = "WHERE   style like '" + gs_brand + "%'"	
//				else 	
					gst_cd.default_where   = "WHERE brand like '" + ls_brand + "%'"	+ &
			                         "  AND tag_price <> 0 "
//				end if
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" + &
				                " and chno  LIKE '" + ls_chno  + "%'" 
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
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF 

					dw_head.SetItem(al_row, "fr_style_no", lds_Source.GetItemString(1,"style_no"))
					is_fr_year       = lds_Source.GetItemString(1,"year")
					is_fr_season     = lds_Source.GetItemString(1,"season")
					is_fr_sojae      = lds_Source.GetItemString(1,"sojae")
					is_fr_item       = lds_Source.GetItemString(1,"item")
					is_fr_cust       = lds_Source.GetItemString(1,"cust_cd")
					il_fr_tag_price  = lds_Source.GetItemNumber(1,"tag_price")
					il_fr_make_price = lds_Source.GetItemNumber(1,"MAKE_price")
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("to_style_no")
		      lb_check = TRUE 
				ib_itemchanged = FALSE
			END IF
			Destroy  lds_Source
			
	CASE  "to_style_no"
			ls_to_brand = dw_head.GetitemString(1, "to_brand")
			IF ai_div = 1 THEN 	
				IF wf_style_chk(as_column, as_data, ls_to_brand)  THEN 
					RETURN 0 
				END IF 
			END IF
	      ls_style = MidA(as_data, 1, 8)
	      ls_chno  = MidA(as_data, 9, 1) 
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			// 스타일 선별작업
//				IF  gl_user_level = 0 then 
//					gst_cd.default_where   = "WHERE   style like '" + gs_brand + "%'"	
//				else 	
					gst_cd.default_where   = "WHERE brand like '" + ls_to_brand + "%'"	+ &
			                         "  AND tag_price <> 0 "
//				end if
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" + &
				                " and chno  LIKE '" + ls_chno  + "%'" 
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
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF 
		
					dw_head.SetItem(al_row, "to_style_no", lds_Source.GetItemString(1,"style_no"))
					is_to_year       = lds_Source.GetItemString(1,"year")
					is_to_season     = lds_Source.GetItemString(1,"season")
					is_to_sojae      = lds_Source.GetItemString(1,"sojae")
					is_to_item       = lds_Source.GetItemString(1,"item")
					is_to_cust       = lds_Source.GetItemString(1,"cust_cd")
					il_to_tag_price  = lds_Source.GetItemNumber(1,"tag_price")
					il_to_make_price = lds_Source.GetItemNumber(1,"MAKE_price")
					/* 다음컬럼으로 이동 */
					cb_input.SetFocus()
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
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
long i,  ll_row_count, ll_iwol_qty, ll_row
datetime ld_datetime
String   ls_in_no, ls_in_no2

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF
/* 입고전표 채번 */
IF gf_style_inno(is_yymmdd, is_brand, ls_in_no) <> 0 THEN 
	MessageBox("저장오류", "입고번호 채번 오류")
	Return -1 
END IF 

IF gf_style_inno(is_yymmdd, is_to_brand, ls_in_no2) <> 0 THEN 
	MessageBox("저장오류", "입고번호 채번 오류")
	Return -1 
END IF 

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN		
		ll_iwol_qty = dw_body.GetitemDecimal(i, "iwol_qty")
      /* 이체 반출 */
		ll_row = dw_list.insertRow(0)
      dw_list.Setitem(ll_row, "yymmdd",          is_yymmdd) 
      dw_list.Setitem(ll_row, "cust_cd",         is_fr_cust)
      dw_list.Setitem(ll_row,	"in_no",           ls_in_no)
      dw_list.Setitem(ll_row,	"no",              String(ll_row, "0000"))
      dw_list.Setitem(ll_row,	"in_gubn",         '-') 
      dw_list.Setitem(ll_row,	"jup_gubn",        "I2")
      dw_list.Setitem(ll_row,	"house_cd",        is_fr_house)
      dw_list.Setitem(ll_row,	"style",           is_fr_style)  	
      dw_list.Setitem(ll_row,	"chno",            is_fr_chno)	 	
      dw_list.Setitem(ll_row,	"color",           dw_body.GetitemString(i, "color"))
      dw_list.Setitem(ll_row,	"size",            dw_body.GetitemString(i, "size"))
      dw_list.Setitem(ll_row,	"class",           'A')	 	
      dw_list.Setitem(ll_row,	"dc_rate",         0)	 	
      dw_list.Setitem(ll_row,	"make_price",      il_fr_make_price)
      dw_list.Setitem(ll_row, "real_make_amt",   il_fr_make_price *  ll_iwol_qty * -1 ) 	
      dw_list.Setitem(ll_row,	"qty",             ll_iwol_qty * -1)	 	
      dw_list.Setitem(ll_row,	"amt",             ll_iwol_qty * il_fr_tag_price * -1)	 	
      dw_list.Setitem(ll_row,	"close_yn",        'Y') 	
      dw_list.Setitem(ll_row, "brand",           is_brand)	 	
      dw_list.Setitem(ll_row,	"year",            is_fr_year)	 	
      dw_list.Setitem(ll_row,	"season",          is_fr_season)	
      dw_list.Setitem(ll_row,	"item",            is_fr_item)
      dw_list.Setitem(ll_row,	"sojae",           is_fr_sojae)
      dw_list.Setitem(ll_row,	"iche_style",	    is_to_style)
      dw_list.Setitem(ll_row,	"iche_chno",       is_to_chno) 	
      dw_list.Setitem(ll_row, "reg_id",          gs_user_id)
      dw_list.Setitem(ll_row, "reg_dt",          ld_datetime)
      /* 이체 입고 */
		ll_row = dw_list.insertRow(0)
      dw_list.Setitem(ll_row, "yymmdd",          is_yymmdd) 
      dw_list.Setitem(ll_row, "cust_cd",         is_to_cust)
      dw_list.Setitem(ll_row,	"in_no",           ls_in_no2)
      dw_list.Setitem(ll_row,	"no",              String(ll_row, "0000"))
      dw_list.Setitem(ll_row,	"in_gubn",         '+') 
      dw_list.Setitem(ll_row,	"jup_gubn",        "I2")
      dw_list.Setitem(ll_row,	"house_cd",        is_to_house)
      dw_list.Setitem(ll_row,	"style",           is_to_style)  	
      dw_list.Setitem(ll_row,	"chno",            is_to_chno)	 	
      dw_list.Setitem(ll_row,	"color",           dw_body.GetitemString(i, "to_color"))
      dw_list.Setitem(ll_row,	"size",            dw_body.GetitemString(i, "to_size"))
      dw_list.Setitem(ll_row,	"class",           'A')	 	
      dw_list.Setitem(ll_row,	"dc_rate",         0)	 	
      dw_list.Setitem(ll_row,	"make_price",      il_to_make_price)
      dw_list.Setitem(ll_row, "real_make_amt",   il_to_make_price * ll_iwol_qty) 	
      dw_list.Setitem(ll_row,	"qty",             ll_iwol_qty)	 	
      dw_list.Setitem(ll_row,	"amt",             ll_iwol_qty * il_to_tag_price)	 	
      dw_list.Setitem(ll_row,	"close_yn",        'Y') 	
      dw_list.Setitem(ll_row, "brand",           is_to_brand)	 	
      dw_list.Setitem(ll_row,	"year",            is_to_year)	 	
      dw_list.Setitem(ll_row,	"season",          is_to_season)	
      dw_list.Setitem(ll_row,	"item",            is_to_item)
      dw_list.Setitem(ll_row,	"sojae",           is_to_sojae)
      dw_list.Setitem(ll_row,	"iche_style",	    is_fr_style)
      dw_list.Setitem(ll_row,	"iche_chno",       is_fr_chno) 	
      dw_list.Setitem(ll_row, "reg_id",          gs_user_id)
      dw_list.Setitem(ll_row, "reg_dt",          ld_datetime)
		if is_chn_yn = "C" then
	      dw_list.Setitem(ll_row, "qty_chn",          ll_iwol_qty)		
		elseif is_chn_yn = "R" then			
	      dw_list.Setitem(ll_row, "qty_rus",          ll_iwol_qty)		
		end if
   END IF
NEXT

il_rows = dw_list.Update()

if il_rows = 1 then
   commit  USING SQLCA;
	cb_retrieve.PostEvent(Clicked!)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_41010_e","0")
end event

type cb_close from w_com010_e`cb_close within w_41010_e
integer taborder = 120
end type

type cb_delete from w_com010_e`cb_delete within w_41010_e
boolean visible = false
integer taborder = 70
end type

type cb_insert from w_com010_e`cb_insert within w_41010_e
boolean visible = false
integer taborder = 50
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_41010_e
integer taborder = 30
end type

event cb_retrieve::clicked;/*===========================================================================*/
/* 작성자      : 김 태범      															  */	
/* 작성일      : 2002.03.04																  */	
/* 수정일      : 2002.03.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

Parent.Trigger Event ue_retrieve()	//조회

SetPointer(oldpointer)
This.Enabled = True

end event

type cb_update from w_com010_e`cb_update within w_41010_e
integer taborder = 110
end type

type cb_print from w_com010_e`cb_print within w_41010_e
boolean visible = false
integer taborder = 80
end type

type cb_preview from w_com010_e`cb_preview within w_41010_e
boolean visible = false
integer taborder = 90
end type

type gb_button from w_com010_e`gb_button within w_41010_e
end type

type cb_excel from w_com010_e`cb_excel within w_41010_e
boolean visible = false
integer taborder = 100
end type

type dw_head from w_com010_e`dw_head within w_41010_e
integer y = 156
integer height = 284
string dataobject = "d_41010_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("to_brand", idw_to_brand)
idw_to_brand.SetTransObject(SQLCA)
idw_to_brand.Retrieve('001')

This.GetChild("fr_house", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

This.GetChild("to_house", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()


// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
	
	if gs_brand = "K" then
 		idw_to_brand.SetFilter(ls_filter_str)
		idw_to_brand.Filter( )
	end if	

end if

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
String ls_yymmdd

CHOOSE CASE dwo.name
	CASE "yymmdd"      
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
	CASE "fr_style_no", 	"to_style_no"
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_41010_e
end type

type ln_2 from w_com010_e`ln_2 within w_41010_e
end type

type dw_body from w_com010_e`dw_body within w_41010_e
integer x = 9
integer taborder = 40
string dataobject = "d_41010_d01"
end type

event dw_body::constructor;call super::constructor;This.GetChild("to_color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.insertRow(0)

This.GetChild("to_size", idw_size)
idw_size.SetTransObject(SQLCA)
idw_size.insertRow(0)


end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;String ls_color 

CHOOSE CASE dwo.name
	CASE "to_size"
		ls_color = This.GetitemString(row, "to_color")
		idw_size.Retrieve(is_to_style, is_to_chno, ls_color)
END CHOOSE


end event

type dw_print from w_com010_e`dw_print within w_41010_e
end type

type cb_input from commandbutton within w_41010_e
event ue_keydown pbm_keydown
integer x = 2528
integer y = 44
integer width = 347
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "등록(&I)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
end event

event clicked;/*===========================================================================*/
/* 작성자      : 김태범        															  */	
/* 작성일      : 2002.03.04																  */	
/* 수정일      : 2002.03.04																  */
/*===========================================================================*/
IF dw_head.Enabled THEN
   Parent.Trigger Event ue_input()	//등록 
ELSE 
	Parent.Trigger Event ue_head()	//조건 
END IF

end event

event getfocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 700

end event

event losefocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 400

end event

type dw_list from datawindow within w_41010_e
boolean visible = false
integer x = 5
integer y = 468
integer width = 3589
integer height = 1572
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_41010_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

