$PBExportHeader$w_52002_e.srw
$PBExportComments$배분율 수기등록
forward
global type w_52002_e from w_com010_e
end type
type dw_1 from datawindow within w_52002_e
end type
end forward

global type w_52002_e from w_com010_e
integer width = 3680
integer height = 2280
dw_1 dw_1
end type
global w_52002_e w_52002_e

type variables
String is_Brand 
DataWindowChild idw_brand
end variables

on w_52002_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_52002_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)                                      */	
/* 작성일      : 2001.12.07                                                  */	
/* 수정일      : 2001.12.07                                                  */
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

return true
end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)                                       */	
/* 작성일      : 2001.12.07                                                  */	
/* 수정일      : 2001.12.07                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_1.retrieve(is_brand)
il_rows = dw_body.retrieve(is_brand)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.06                                                  */	
/* 수정일      : 2001.12.07                                                  */
/*===========================================================================*/
long     i, j, ll_row_count, ll_row
datetime ld_datetime
String   ls_col_nm, ls_find, ls_Shop_cd
String   ls_Type[] = {'C', 'D', 'E', 'F', 'G'}
Decimal  ldc_Rate

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

/* 수정된 row 체크 */
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN 
		ls_Shop_cd = dw_body.Object.shop_cd[i]
		/* 수정된 칼럼 체크 */
		FOR j = 1 TO 5 
			ls_col_nm = Lower(ls_Type[j]) + "_rate"
			IF dw_body.GetItemStatus(i, ls_col_nm, Primary!) = DataModified! THEN 
				ldc_Rate = dw_body.GetitemDecimal(i, ls_col_nm)
				ls_Find  = "shop_cd = '" + ls_shop_cd + "' And deal_type = '" + ls_Type[j] + "'"
				ll_row = dw_1.Find(ls_Find, 1, dw_1.RowCount()) 
				IF ll_row > 0 THEN 
					dw_1.Setitem(ll_row, "deal_rate", ldc_Rate)
               dw_1.Setitem(ll_row, "mod_id",    gs_user_id)
               dw_1.Setitem(ll_row, "mod_dt",    ld_datetime)
				ELSE
					ll_row = dw_1.insertRow(0)
					dw_1.Setitem(ll_row, "brand",     is_brand)
					dw_1.Setitem(ll_row, "shop_cd",   ls_shop_cd)
					dw_1.Setitem(ll_row, "deal_type", ls_Type[j])
					dw_1.Setitem(ll_row, "sojae",     '*')
					dw_1.Setitem(ll_row, "item",      '*')
					dw_1.Setitem(ll_row, "deal_rate", ldc_Rate)
               dw_1.Setitem(ll_row, "reg_id",    gs_user_id)
				END IF
			END IF
		NEXT
	END IF
NEXT

il_rows = dw_1.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen;call super::pfc_preopen;dw_1.SetTransObject(SQLCA)

end event

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.10                                                  */	
/* 수정일      : 2001.12.10                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
				"t_user_id.Text = '" + gs_user_id + "'" + &
				"t_datetime.Text = '" + ls_datetime + "'" + &
				"t_brand.Text = '브랜드 : " + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") + "'"

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_52002_e","0")
end event

type cb_close from w_com010_e`cb_close within w_52002_e
end type

type cb_delete from w_com010_e`cb_delete within w_52002_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_52002_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_52002_e
end type

type cb_update from w_com010_e`cb_update within w_52002_e
end type

type cb_print from w_com010_e`cb_print within w_52002_e
end type

type cb_preview from w_com010_e`cb_preview within w_52002_e
end type

type gb_button from w_com010_e`gb_button within w_52002_e
end type

type cb_excel from w_com010_e`cb_excel within w_52002_e
end type

type dw_head from w_com010_e`dw_head within w_52002_e
integer y = 184
integer height = 136
string dataobject = "d_52002_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_e`ln_1 within w_52002_e
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_e`ln_2 within w_52002_e
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_e`dw_body within w_52002_e
integer y = 344
integer width = 3593
integer height = 1700
string dataobject = "d_52002_d01"
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
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_52002_e
string dataobject = "d_52002_r01"
end type

type dw_1 from datawindow within w_52002_e
boolean visible = false
integer x = 1842
integer y = 296
integer width = 411
integer height = 432
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_52002_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 1
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 1400
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE


MessageBox(parent.title, ls_message_string)
return 1
end event

