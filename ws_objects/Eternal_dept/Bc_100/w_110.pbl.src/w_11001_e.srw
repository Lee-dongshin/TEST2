$PBExportHeader$w_11001_e.srw
$PBExportComments$부진매장선정
forward
global type w_11001_e from w_com010_e
end type
type dw_1 from datawindow within w_11001_e
end type
type st_1 from statictext within w_11001_e
end type
end forward

global type w_11001_e from w_com010_e
dw_1 dw_1
st_1 st_1
end type
global w_11001_e w_11001_e

type variables
String is_brand, is_yyyy
end variables

on w_11001_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_1
end on

on w_11001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_1)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
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

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_1.retrieve(is_brand, is_yyyy)
il_rows = dw_body.retrieve(is_brand, is_yyyy)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(st_1, "FixedToRight")
dw_1.SetTransObject(SQLCA)

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_row
datetime ld_datetime
String   ls_shop_cd, ls_close_yymm, ls_find

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN 
	dw_body.SetFocus() 
	RETURN -1 
END IF

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN 
		ls_shop_cd    = dw_body.GetitemString(i, "shop_cd") 
		ls_close_yymm = dw_body.GetitemString(i, "close_yymm") 
		ll_row = dw_1.Find("shop_cd = '" + ls_shop_cd + "'", 1, dw_1.RowCount())
		IF ll_row > 0 THEN 
			IF isnull(ls_close_yymm) or Trim(ls_close_yymm) = "" THEN 
				dw_1.DeleteRow(ll_row) 
			ELSE
				dw_1.Setitem(ll_row, "yymm",   ls_close_yymm)
            dw_1.Setitem(ll_row, "mod_id", gs_user_id)
            dw_1.Setitem(ll_row, "mod_dt", ld_datetime)
			END IF
		ELSE 
			IF isnull(ls_close_yymm) or Trim(ls_close_yymm) = "" THEN 
			ELSE
		   	ll_row = dw_1.insertRow(0)
			   dw_1.Setitem(ll_row, "yymm",    ls_close_yymm)
            dw_1.Setitem(ll_row, "shop_cd", ls_shop_cd)
            dw_1.Setitem(ll_row, "brand",   is_brand)
            dw_1.Setitem(ll_row, "shop_div", MidA(ls_shop_cd, 2, 1))
            dw_1.Setitem(ll_row, "reg_id",  gs_user_id) 
			END IF
		END IF
   END IF
NEXT

il_rows = dw_1.Update()

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_11001_e","0")
end event

type cb_close from w_com010_e`cb_close within w_11001_e
end type

type cb_delete from w_com010_e`cb_delete within w_11001_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_11001_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_11001_e
end type

type cb_update from w_com010_e`cb_update within w_11001_e
end type

type cb_print from w_com010_e`cb_print within w_11001_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_11001_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_11001_e
end type

type cb_excel from w_com010_e`cb_excel within w_11001_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_11001_e
integer height = 144
string dataobject = "d_11001_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('001')


end event

type ln_1 from w_com010_e`ln_1 within w_11001_e
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_e`ln_2 within w_11001_e
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_e`dw_body within w_11001_e
integer y = 344
integer height = 1704
string dataobject = "d_11001_d01"
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "close_yymm" 
	 IF isnull(data) OR Trim(data) = "" Then Return 0
    IF MidA(data, 1, 4) <> is_yyyy THEN 
		 return 1
    ELSEIF GF_DATECHK(data + '01') = False THEN
		Return 1
    END IF
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_11001_e
end type

type dw_1 from datawindow within w_11001_e
boolean visible = false
integer x = 1970
integer y = 144
integer width = 411
integer height = 432
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "dw_1"
string dataobject = "d_11001_d02"
boolean resizable = true
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
	CASE 2627
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 515
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

type st_1 from statictext within w_11001_e
integer x = 3182
integer y = 248
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "( 단위 : 천원)"
boolean focusrectangle = false
end type

