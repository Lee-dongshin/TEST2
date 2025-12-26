$PBExportHeader$w_sh320_e.srw
$PBExportComments$마일리지카드 신청등록
forward
global type w_sh320_e from w_com010_e
end type
type st_1 from statictext within w_sh320_e
end type
type st_2 from statictext within w_sh320_e
end type
end forward

global type w_sh320_e from w_com010_e
integer width = 2971
integer height = 2068
long backcolor = 16777215
st_1 st_1
st_2 st_2
end type
global w_sh320_e w_sh320_e

type variables

end variables

forward prototypes
public function boolean wf_qty_update (ref string as_errmsg)
end prototypes

public function boolean wf_qty_update (ref string as_errmsg);/* 매장, 자재별 의뢰량 처리 tb_71070_m */
Long    i 
Decimal ldc_qty, ldc_old_qty, ldc_New_qty
String  ls_gubn

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
		ls_gubn = dw_body.GetitemString(i, "gubn") 
      DECLARE SP_71070_m_UPDATE1 PROCEDURE FOR SP_71070_m_UPDATE
         @shop_cd  = :gs_shop_cd,   
         @gubn     = :ls_gubn, 
			@qty      = :ldc_qty;
      EXECUTE SP_71070_m_UPDATE1;
		IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN 
			as_errmsg = SQLCA.SqlErrText
			Return False 
		END IF 
	END IF
NEXT

Return True
end function

on w_sh320_e.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
end on

on w_sh320_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(gs_shop_cd, gs_brand)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_postopen();call super::pfc_postopen;This.Trigger Event ue_retrieve()
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

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return -1
end if	

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

type cb_close from w_com010_e`cb_close within w_sh320_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh320_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh320_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh320_e
boolean visible = false
end type

type cb_update from w_com010_e`cb_update within w_sh320_e
end type

type cb_print from w_com010_e`cb_print within w_sh320_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh320_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh320_e
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh320_e
integer width = 2775
integer height = 144
string dataobject = "d_sh320_h01"
end type

type ln_1 from w_com010_e`ln_1 within w_sh320_e
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_e`ln_2 within w_sh320_e
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_e`dw_body within w_sh320_e
integer y = 344
integer height = 1488
string dataobject = "d_sh320_d01"
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

type dw_print from w_com010_e`dw_print within w_sh320_e
end type

type st_1 from statictext within w_sh320_e
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

type st_2 from statictext within w_sh320_e
integer x = 1029
integer y = 208
integer width = 1545
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711935
long backcolor = 16777215
string text = "※ 잔량이 남아 있는 물품은 신청하실 수 없습니다."
boolean focusrectangle = false
end type

