$PBExportHeader$w_42020_e.srw
$PBExportComments$물류부자재 출고등록
forward
global type w_42020_e from w_com020_e
end type
type dw_1 from datawindow within w_42020_e
end type
type st_2 from statictext within w_42020_e
end type
end forward

global type w_42020_e from w_com020_e
integer width = 3675
integer height = 2276
dw_1 dw_1
st_2 st_2
end type
global w_42020_e w_42020_e

type variables
DataWindowChild idw_brand 
String is_brand, is_yymmdd, is_shop_cd 
end variables

forward prototypes
public function boolean wf_qty_update (ref string as_errmsg)
end prototypes

public function boolean wf_qty_update (ref string as_errmsg);/* 매장, 자재별 의뢰잔량 처리 */

Long    i 
Decimal ldc_qty, ldc_old_qty, ldc_New_qty, ldc_cancel_qty,ldc_OLD_cancel_qty
String  ls_mat_cd 

/* 변경된 수량만큼 차감 */
FOR i = 1 TO dw_body.RowCount()
   ldc_qty = 0 
	ldc_old_qty = 0
	ldc_New_qty = 0
	ldc_cancel_qty = 0
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN			/* New Record */
		ldc_New_qty = dw_body.GetitemDecimal(i, "qty") 
		ldc_cancel_qty = dw_body.GetitemDecimal(i, "cancel_qty") 		
		IF isnull(ldc_New_qty) THEN ldc_qty = 0 
		IF isnull(ldc_cancel_qty) THEN ldc_cancel_qty = 0 
		ldc_qty = (ldc_New_qty + ldc_cancel_qty) * -1
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		ldc_old_qty        = dw_body.GetitemDecimal(i, "qty", Primary!, TRUE)
		ldc_OLD_cancel_qty = dw_body.GetitemDecimal(i, "CANCEL_QTY", Primary!, TRUE)		
		IF isnull(ldc_old_qty) THEN ldc_old_qty = 0 
		IF isnull(ldc_cancel_qty) THEN ldc_cancel_qty = 0 
		ldc_New_qty = dw_body.GetitemDecimal(i, "qty")
		ldc_cancel_qty = dw_body.GetitemDecimal(i, "cancel_qty") 
		IF isnull(ldc_New_qty) THEN ldc_New_qty = 0 
		ldc_qty = ldc_old_qty - ldc_New_qty + ldc_OLD_cancel_qty - ldc_cancel_qty 
	END IF 
	
   IF ldc_qty <> 0 THEN 
		ls_mat_cd = dw_body.GetitemString(i, "mat_cd") 
      DECLARE SP_42030_UPDATE1 PROCEDURE FOR SP_42030_M_UPDATE 
         @shop_cd  = :is_shop_cd,   
         @mat_cd   = :ls_mat_cd, 
			@qty      = :ldc_qty;
      EXECUTE SP_42030_UPDATE1;
		IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN 
			as_errmsg = SQLCA.SqlErrText
			Return False 
		END IF 
	END IF
NEXT

/* 삭제된 수량만큼 차감 */
FOR i = 1 TO dw_body.deletedcount()
	ldc_qty = dw_body.GetitemDecimal(i, "qty", Delete!, TRUE)
   IF isnull(ldc_qty) = FALSE AND ldc_qty <> 0 THEN 
		ls_mat_cd = dw_body.GetitemString(i, "mat_cd", Delete!, TRUE) 
      DECLARE SP_42030_UPDATE2 PROCEDURE FOR SP_42030_M_UPDATE 
         @shop_cd  = :is_shop_cd,   
         @mat_cd   = :ls_mat_cd, 
			@qty      = :ldc_qty;
      EXECUTE SP_42030_UPDATE2;
		IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN 
			as_errmsg = SQLCA.SqlErrText
			Return False 
		END IF 
	END IF
NEXT

Return True
end function

on w_42020_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_2
end on

on w_42020_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_2)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight")

dw_1.SetTransObject(SQLCA)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.27                                                  */	
/* 수정일      : 2002.03.27                                                  */
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

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */ 
/* 작성일      : 2002.03.27                                                  */
/* 수정일      : 2002.03.27                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand)
dw_1.Reset()
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2002.03.27                                                  */	
/* 수정일      : 2002.03.27                                                  */
/*===========================================================================*/
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         dw_1.Enabled = true
			cb_print.enabled = true
			cb_preview.enabled = true			
      end if

   CASE 5    /* 조건 */
      dw_1.Enabled = false

END CHOOSE

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.27                                                  */	
/* 수정일      : 2002.03.27                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_qty
datetime ld_datetime
String   ls_ErrMsg

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN			/* New Record */
      dw_body.Setitem(i, "yymmdd",  is_yymmdd)
      dw_body.Setitem(i, "shop_cd", is_shop_cd)
      dw_body.Setitem(i, "brand",   is_brand)
      dw_body.Setitem(i, "shop_div", MidA(is_shop_cd, 2, 1))
      dw_body.Setitem(i, "mat_item", 'Z')
      dw_body.Setitem(i, "reg_id",  gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
   dw_body.Setitem(i, "seq",  i)
NEXT

il_rows = dw_body.Update(TRUE, FALSE)
IF il_rows = 1 THEN
	ls_ErrMsg = ""
	IF wf_qty_update(ls_ErrMsg) = FALSE THEN 
		il_rows = -1
	END IF
END IF

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
   dw_1.retrieve(is_brand, is_shop_cd)
	ll_qty = Long(dw_1.Describe("evaluate('sum(qty)',0)"))
	dw_list.Setitem(dw_list.GetSelectedRow(0), "qty", ll_qty)
else
   rollback  USING SQLCA;
	IF isnull(ls_ErrMsg) = FALSE and ls_ErrMsg <> "" THEN 
		MessageBox("SQL 오류", ls_ErrMsg) 
	END IF
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42020_e","0")
end event

event ue_print();

This.Trigger Event ue_title()

dw_print.retrieve(is_brand, is_yymmdd, is_yymmdd, "%", "%")

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_preview();
This.Trigger Event ue_title ()

dw_print.retrieve(is_brand, is_yymmdd, is_yymmdd, "%", "%")
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title();

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

   
ls_modify =	   "t_pg_id.Text = '" + is_pgm_id + "'" + &
               "t_user_id.Text = '" + gs_user_id + "'" + &
               "t_datetime.Text = '" + ls_datetime + "'" + &        
			      "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &					
					"t_yymmdd.Text = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" 															

dw_print.Modify(ls_modify)


end event

type cb_close from w_com020_e`cb_close within w_42020_e
end type

type cb_delete from w_com020_e`cb_delete within w_42020_e
end type

type cb_insert from w_com020_e`cb_insert within w_42020_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_42020_e
end type

type cb_update from w_com020_e`cb_update within w_42020_e
end type

type cb_print from w_com020_e`cb_print within w_42020_e
end type

type cb_preview from w_com020_e`cb_preview within w_42020_e
end type

type gb_button from w_com020_e`gb_button within w_42020_e
end type

type cb_excel from w_com020_e`cb_excel within w_42020_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_42020_e
integer height = 156
string dataobject = "d_42020_h01"
end type

event dw_head::constructor;call super::constructor;

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)                                       */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String ls_yymmdd

CHOOSE CASE dwo.name
	CASE "yymmdd"      
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_42020_e
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com020_e`ln_2 within w_42020_e
integer beginy = 352
integer endy = 352
end type

type dw_list from w_com020_e`dw_list within w_42020_e
integer x = 14
integer y = 376
integer width = 1006
integer height = 1668
string dataobject = "d_42020_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.27                                                  */	
/* 수정일      : 2002.03.27                                                  */
/*===========================================================================*/

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

is_shop_cd = This.GetItemString(row, 'shop_cd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_shop_cd) THEN return
dw_1.retrieve(is_brand, is_shop_cd)
il_rows = dw_body.retrieve(is_yymmdd, is_shop_cd)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_42020_e
integer x = 1038
integer y = 1380
integer width = 2555
integer height = 664
string dataobject = "d_42020_d03"
boolean hscrollbar = true
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.27                                                  */	
/* 수정일      : 2002.03.27                                                  */
/*===========================================================================*/
Long ll_qty, ll_price, ll_imsi , ll_cancel_qty

CHOOSE CASE dwo.name
	CASE "qty" 
		ll_price = This.GetitemDecimal(row, "price")
		ll_imsi  = This.GetitemDecimal(row, "imsi")
		IF isnull(ll_price) THEN ll_price = 0 
		ll_cancel_qty = ll_imsi - Long(data)
		IF MessageBox("확인", "나머지량을 의뢰취소 하시겠습니까 ?", Question!, YesNo! ) = 2 THEN 
			This.Setitem(row, "cancel_qty", 0)
		else	 
 			This.Setitem(row, "cancel_qty", ll_cancel_qty)			
		END IF

		This.Setitem(row, "amt", ll_price * Long(data))
	CASE "price"	     //  Popup 검색창이 존재하는 항목 
		ll_qty = This.GetitemDecimal(row, "qty")
		IF isnull(ll_qty) THEN ll_qty = 0 
		This.Setitem(row, "amt", ll_qty * Long(data))
END CHOOSE

end event

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

type st_1 from w_com020_e`st_1 within w_42020_e
boolean visible = false
integer x = 1019
integer y = 376
integer height = 1668
end type

type dw_print from w_com020_e`dw_print within w_42020_e
string dataobject = "d_42020_r02"
end type

type dw_1 from datawindow within w_42020_e
integer x = 1038
integer y = 448
integer width = 2555
integer height = 924
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_42020_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;Long    ll_row 
Decimal ldc_qty, ldc_price

IF row < 0 THEN RETURN 

ll_row = dw_body.insertRow(0)

ldc_qty   = dw_1.GetitemDecimal(row, "qty") 
ldc_price = dw_1.GetitemDecimal(row, "price") 

dw_body.Setitem(ll_row, "mat_cd", dw_1.Object.mat_cd[row])
dw_body.Setitem(ll_row, "mat_nm", dw_1.Object.mat_nm[row])
dw_body.Setitem(ll_row, "imsi",   ldc_qty)
dw_body.Setitem(ll_row, "qty",    ldc_qty)
dw_body.Setitem(ll_row, "price",  ldc_price)
dw_body.Setitem(ll_row, "amt",    ldc_qty * ldc_price)
dw_body.Setitem(ll_row, "pay_yn",  "Y")

ib_changed = true
cb_update.Enabled = True 
cb_delete.Enabled = True 


end event

type st_2 from statictext within w_42020_e
integer x = 1056
integer y = 380
integer width = 1399
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 79741120
string text = "해당 부자재를 더블클릭하면 추가로 등록 됩니다."
boolean focusrectangle = false
end type

