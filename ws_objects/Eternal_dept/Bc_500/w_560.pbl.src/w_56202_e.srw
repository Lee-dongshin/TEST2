$PBExportHeader$w_56202_e.srw
$PBExportComments$매출세금계산서 등록
forward
global type w_56202_e from w_com010_e
end type
type rb_1 from radiobutton within w_56202_e
end type
type gb_1 from groupbox within w_56202_e
end type
end forward

global type w_56202_e from w_com010_e
integer width = 3675
integer height = 2280
rb_1 rb_1
gb_1 gb_1
end type
global w_56202_e w_56202_e

type variables
String is_brand,   is_yymm, is_shop_div, is_yymmdd, is_bungi, is_seq 


end variables

on w_56202_e.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.gb_1
end on

on w_56202_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.gb_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.26                                                  */	
/* 수정일      : 2002.03.26                                                  */
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

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_yymm   = String(dw_head.GetitemDateTime(1, "yymm"), "yyyymm")
is_yymmdd = String(dw_head.GetitemDate(1, "yymmdd"),   "yyyy.mm.dd")
is_seq    = String(dw_head.GetitemNumber(1, "seq"), "00")
is_bungi = dw_head.GetitemString(1, "rep_bungi")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.04.01                                                  */	
/* 수정일      : 2002.04.01                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymm, is_shop_div, is_seq)
IF il_rows > 0 THEN 
   dw_body.SetFocus() 
END IF 

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.26                                                  */	
/* 수정일      : 2002.03.26                                                  */
/*===========================================================================*/
long    i, ll_row_count, ll_cnt 
String  ls_shop_cd,   ls_ErrMsg
Decimal ldc_amt, ldc_vat

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

il_rows = 1
ll_cnt  = 0 
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN		/* Modify Record */
	   ls_shop_cd = dw_body.GetitemString(i,  "shop_cd")
		ldc_amt    = dw_body.GetitemDecimal(i, "amt")
		ldc_vat    = dw_body.GetitemDecimal(i, "vat")
      DECLARE SP_56202_BILL PROCEDURE FOR SP_56202_BILL 
              @brand     = :is_brand,   
              @yymm      = :is_yymm,   
              @shop_cd   = :ls_shop_cd,   
              @seq       = :is_seq  ,   
              @amt       = :ldc_amt,   
              @vat       = :ldc_vat,   
              @yymmdd    = :is_yymmdd,   
              @rep_bungi = :is_bungi,   
              @user_id   = :gs_user_id ;    
      EXECUTE SP_56202_BILL;
      if SQLCA.SQLCODE = 0  OR SQLCA.SQLCODE = 100 then
         commit  USING SQLCA;
		   ll_cnt ++
      else 
	      ls_ErrMsg  = SQLCA.SQLErrText 
         rollback  USING SQLCA; 
         il_rows = -1 
         MessageBox("SQL 오류", ls_ErrMsg) 
		   Exit 
      end if
   END IF 
NEXT

if ll_cnt > 0 then
   dw_body.retrieve(is_brand, is_yymm, is_shop_div, is_seq)
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event open;call super::open;String ls_mm

dw_head.Setitem(1, "seq", 1)

ls_mm = String(dw_head.GetitemDate(1, "yymmdd"), "mm")
CHOOSE CASE ls_mm
    CASE '01', '02', '03'
         dw_head.setitem(1, "rep_bungi", "1")
    CASE '04', '05', '06'
         dw_head.setitem(1, "rep_bungi", "2")
    CASE '07', '08', '09'
         dw_head.setitem(1, "rep_bungi", "3")
    CASE '10', '11', '12'
         dw_head.setitem(1, "rep_bungi", "4")
END CHOOSE 


end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
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
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled  = false
         dw_body.Enabled  = true
         dw_body.SetFocus()
      end if
      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed         = false
         cb_update.enabled  = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_update.enabled  = false
      ib_changed         = false
      dw_body.Enabled    = false
      dw_head.Enabled    = true 
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56202_e","0")
end event

type cb_close from w_com010_e`cb_close within w_56202_e
end type

type cb_delete from w_com010_e`cb_delete within w_56202_e
boolean visible = false
integer x = 1737
end type

type cb_insert from w_com010_e`cb_insert within w_56202_e
boolean visible = false
integer x = 1394
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56202_e
end type

type cb_update from w_com010_e`cb_update within w_56202_e
end type

type cb_print from w_com010_e`cb_print within w_56202_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56202_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56202_e
end type

type cb_excel from w_com010_e`cb_excel within w_56202_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_56202_e
integer x = 485
integer width = 2843
string dataobject = "d_56202_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("shop_div", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("910") 
ldw_child.SetFilter("inter_cd > 'A' and inter_cd < 'X'")
ldw_child.Filter()

This.GetChild("rep_bungi", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('017')


end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "yymmdd"      // dddw로 작성된 항목
        CHOOSE CASE MidA(Data, 6, 2)
	         CASE '01', '02', '03'
                 This.setitem(1, "rep_bungi", "1")
	         CASE '04', '05', '06'
                 This.setitem(1, "rep_bungi", "2")
	         CASE '07', '08', '09'
                 This.setitem(1, "rep_bungi", "3")
            CASE '10', '11', '12'
                 This.setitem(1, "rep_bungi", "4")
        END CHOOSE 
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_56202_e
integer beginy = 416
integer endy = 416
end type

type ln_2 from w_com010_e`ln_2 within w_56202_e
integer beginy = 420
integer endy = 420
end type

type dw_body from w_com010_e`dw_body within w_56202_e
integer y = 440
integer height = 1608
boolean enabled = false
string dataobject = "d_56202_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.03.26                                                  */	
/* 수정일      : 2002.03.26                                                  */
/*===========================================================================*/
Long  ll_amt, ll_vat 

CHOOSE CASE dwo.name
	CASE "amt" 
		ll_amt = Long(Data)
		IF isnull(ll_amt) THEN ll_amt = 0 
		ll_vat = This.GetitemNumber(row, "vat")
		IF isnull(ll_vat) THEN
			ll_vat = Round(ll_amt / 10, 0)
		   This.Setitem(row, "vat", ll_vat)
		END IF 
		This.Setitem(row, "tot_amt", ll_amt + ll_vat) 
	CASE "vat" 
		ll_vat = Long(Data)
		IF isnull(ll_vat) THEN ll_vat = 0 
		ll_amt = This.GetitemNumber(row, "amt")
		IF isnull(ll_amt) THEN ll_amt = 0 
		This.Setitem(row, "tot_amt", ll_amt + ll_vat)
END CHOOSE

end event

event dw_body::buttonclicked;call super::buttonclicked;Long   i, ll_row 
String ls_slip_date

IF dwo.name = "b_copy" THEN 
	ll_row = This.RowCount() 
	FOR i = 1 TO ll_row
      ls_slip_date = This.GetitemString(i, "slip_date") 
		IF isnull(ls_slip_date) OR Trim(ls_slip_date) = "" THEN 
			This.Setitem(i, "amt"    , This.GetitemNumber(i, "edps_amt")) 
			This.Setitem(i, "vat"    , This.GetitemNumber(i, "edps_vat")) 
			This.Setitem(i, "tot_amt", This.GetitemNumber(i, "edps_tot_amt")) 
         ib_changed        = true  
         cb_update.enabled = true  
		END IF 
	NEXT 
END IF 
 
end event

type dw_print from w_com010_e`dw_print within w_56202_e
end type

type rb_1 from radiobutton within w_56202_e
integer x = 78
integer y = 252
integer width = 315
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "의류대"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_56202_e
integer x = 41
integer y = 192
integer width = 379
integer height = 156
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

