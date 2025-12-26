$PBExportHeader$w_sh330_e.srw
$PBExportComments$부자재 주문등록
forward
global type w_sh330_e from w_com010_e
end type
type st_1 from statictext within w_sh330_e
end type
end forward

global type w_sh330_e from w_com010_e
integer width = 2981
integer height = 2080
long backcolor = 16777215
st_1 st_1
end type
global w_sh330_e w_sh330_e

type variables
STRING IS_FRM_YYMMDD, IS_TO_YYMMDD
end variables

forward prototypes
public function boolean wf_qty_update (ref string as_errmsg)
end prototypes

public function boolean wf_qty_update (ref string as_errmsg);/* 매장, 자재별 의뢰량 처리 tb_42030_m */
Long    i 
Decimal ldc_qty, ldc_old_qty, ldc_New_qty
String  ls_mat_cd 

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

/* 변경된 수량만큼 차감 */
FOR i = 1 TO dw_body.RowCount()
   ldc_qty = 0 
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN			/* New Record */
		ldc_New_qty = dw_body.GetitemDecimal(i, "qty")
		IF isnull(ldc_New_qty) THEN ldc_qty = 0 
		ldc_qty = ldc_New_qty 
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		ldc_old_qty = dw_body.GetitemDecimal(i, "qty", Primary!, TRUE)
		IF isnull(ldc_old_qty) THEN ldc_old_qty = 0 
		ldc_New_qty = dw_body.GetitemDecimal(i, "qty")
		IF isnull(ldc_New_qty) THEN ldc_New_qty = 0 
		ldc_qty = ldc_New_qty - ldc_old_qty 
	END IF 
   IF ldc_qty <> 0 THEN 
		ls_mat_cd = dw_body.GetitemString(i, "mat_cd") 
      DECLARE SP_42030_UPDATE1 PROCEDURE FOR SP_42030_M_UPDATE 
         @shop_cd  = :gs_shop_cd,   
         @mat_cd   = :ls_mat_cd, 
			@qty      = :ldc_qty;
      EXECUTE SP_42030_UPDATE1;
		IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN 
			as_errmsg = SQLCA.SqlErrText
			Return False 
		END IF 
	END IF
NEXT

Return True
end function

on w_sh330_e.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_sh330_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_brand = dw_head.getitemstring(1,'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if


il_rows = dw_body.retrieve(gs_brand,IS_FRM_YYMMDD, IS_TO_YYMMDD, gs_shop_cd )
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_postopen;call super::pfc_postopen;//This.Trigger Event ue_retrieve()
end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
String   ls_shop_cd, ls_ErrMsg 

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
		IF isnull(ls_shop_cd) or Trim(ls_shop_cd) = "" THEN 
			if MidA(gs_shop_cd_1,1,2) = 'XX' then 
				gs_brand = dw_head.getitemstring(1, 'brand')
				gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
			end if
         dw_body.Setitem(i, "shop_cd", gs_shop_cd)
         dw_body.Setitem(i, "reg_id", gs_user_id)
			dw_body.SetitemStatus(i, 0, Primary!, NewModified!)
		ELSE
         dw_body.Setitem(i, "mod_id", gs_user_id)
         dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF 
   END IF
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
	st_1.visible = False
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

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_yymmdd",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "to_yymmdd", string(ld_datetime, "yyyymmdd"))
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
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

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

is_FRM_YYMMDD = dw_head.GetItemString(1, "FRM_YYMMDD")
if IsNull(is_FRM_YYMMDD) or Trim(is_FRM_YYMMDD) = "" then
   MessageBox(ls_title,"조회일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("FRM_YYMMDD")
   return false
end if

is_TO_YYMMDD = dw_head.GetItemString(1, "TO_YYMMDD")
if IsNull(is_TO_YYMMDD) or Trim(is_TO_YYMMDD) = "" then
   MessageBox(ls_title,"조회일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("TO_YYMMDD")
   return false
end if

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

return true
end event

type cb_close from w_com010_e`cb_close within w_sh330_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh330_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh330_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh330_e
end type

type cb_update from w_com010_e`cb_update within w_sh330_e
boolean visible = false
end type

type cb_print from w_com010_e`cb_print within w_sh330_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh330_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh330_e
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh330_e
integer width = 2743
integer height = 144
string dataobject = "d_sh330_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.object.brand_t.visible = true
	dw_head.object.brand.visible = true
else
	dw_head.object.brand_t.visible = false
	dw_head.object.brand.visible = false
end if


end event

event dw_head::itemchanged;call super::itemchanged;long ll_b_cnt
CHOOSE CASE dwo.name

	CASE "brand"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			dw_head.accepttext()
			gs_brand = dw_head.getitemstring(1,'brand')

			select isnull(count(brand),0)
			into	:ll_b_cnt
			from tb_91100_m  with (nolock) 
			where shop_cd like '%' + substring(:gs_shop_cd_1,3,4)
					and brand = :gs_brand;	
					
			if ll_b_cnt = 0 then 
				messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
				dw_body.reset()
				return 0
			end if

			gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
			Trigger Event ue_retrieve()
	
END CHOOSE
		
end event

type ln_1 from w_com010_e`ln_1 within w_sh330_e
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_e`ln_2 within w_sh330_e
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_e`dw_body within w_sh330_e
integer y = 344
integer height = 1488
string dataobject = "D_SH330_D01"
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)                                           */	
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

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
Long   ll_limit

st_1.visible = true

CHOOSE CASE dwo.name
	CASE "qty" 
		ll_limit = This.GetitemNumber(row, "limit_qty")
	   IF ll_limit <> 0 THEN 
			IF Mod(Long(data), ll_limit) <> 0 THEN 
				MessageBox("오류", "단위에 맞게 입력하십시오 !")
				Return 1
			END IF 
		END IF 
END CHOOSE

end event

event dw_body::editchanged;call super::editchanged;st_1.visible = true
end event

type dw_print from w_com010_e`dw_print within w_sh330_e
end type

type st_1 from statictext within w_sh330_e
boolean visible = false
integer x = 411
integer y = 60
integer width = 1851
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "<- 입력후 반드시 저장버튼을 누르세요 (단축키 Alt+S)"
boolean focusrectangle = false
end type

