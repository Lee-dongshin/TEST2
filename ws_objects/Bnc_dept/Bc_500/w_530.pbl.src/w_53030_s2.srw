$PBExportHeader$w_53030_s2.srw
$PBExportComments$판매등록[고객등록]
forward
global type w_53030_s2 from w_com010_e
end type
type st_1 from statictext within w_53030_s2
end type
end forward

global type w_53030_s2 from w_com010_e
integer width = 1170
integer height = 732
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_closeparm ( )
st_1 st_1
end type
global w_53030_s2 w_53030_s2

type variables
String is_shop_cd, is_area_cd, is_jumin 
int    ii_sex
end variables

forward prototypes
public function boolean wf_card_chk (string as_card_no)
end prototypes

event ue_closeparm();CloseWithReturn(This, is_jumin)

end event

public function boolean wf_card_chk (string as_card_no);String ls_card_no 
Long   ll_cnt 

IF LenA(Trim(as_card_no)) <> 9 THEN RETURN FALSE 
IF match(as_card_no, "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][12]") = FALSE THEN 
	MessageBox("오류", "카드번호 오류!") 
	dw_body.SetFocus()
	Return False 
END IF

ls_card_no = "1128003" + as_card_no

SELECT count(card_no) 
  INTO :ll_cnt 
  FROM TB_72010_M 
 WHERE card_no = :ls_card_no;

IF ll_cnt > 0 THEN 
	MessageBox("확인", "이미 등록된 카드번호 입니다 !")
	RETURN FALSE
END IF

dw_body.Setitem(1, "card_no", ls_card_no)

RETURN TRUE 


end function

on w_53030_s2.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_53030_s2.destroy
call super::destroy
destroy(this.st_1)
end on

event pfc_preopen();call super::pfc_preopen;Window ldw_parent
Long   ll_x, ll_y

ldw_parent = This.ParentWindow()
This.x = ((ldw_parent.Width - This.Width) / 2) +  ldw_parent.x
This.y = ((ldw_parent.Height - This.Height) / 2) +  ldw_parent.y 

dw_body.InsertRow(0) 

is_shop_cd = gsv_cd.gs_cd1 
Select area_cd 
  into :is_area_cd 
  from tb_91100_m 
 where shop_cd = :gsv_cd.gs_cd1 ;

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
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

is_jumin = dw_head.GetItemString(1, "jumin")
if IsNull(is_jumin) or Trim(is_jumin) = "" then
   MessageBox(ls_title,"주민등록 번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jumin")
   return false
end if

IF match(MidA(is_jumin, 7, 1), "^[13]") THEN 
	ii_sex = 0 
ELSE
	ii_sex = 1 
END IF

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_jumin)
IF il_rows > 0 THEN
	dw_body.Enabled = TRUE
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN 
   il_rows = dw_body.insertRow(0)
	dw_body.Enabled = TRUE
   dw_body.SetFocus()
END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime 
String   ls_card_no

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1 
ls_card_no = dw_body.GetitemString(1, "card_no") 
IF isnull(ls_card_no) OR LenA(Trim(ls_card_no)) <> 16 THEN 
	MessageBox("오류", "카드번호를 확인하세요")
	dw_body.SetColumn("card_no2")
	RETURN -1 
END IF

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "jumin",   is_jumin)
      dw_body.Setitem(i, "sex",     ii_sex)
		IF dw_body.GetItemStatus(i, "card_no", Primary!) = DataModified! THEN
         dw_body.Setitem(i, "shop_cd", is_shop_cd)
         dw_body.Setitem(i, "card_day", String(ld_datetime, "yyyymmdd"))
         dw_body.Setitem(i, "area",    is_area_cd)
		END IF
      dw_body.Setitem(i, "reg_id",  gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */ 
		IF dw_body.GetItemStatus(i, "card_no", Primary!) = DataModified! THEN
         dw_body.Setitem(i, "shop_cd", is_shop_cd)
         dw_body.Setitem(i, "card_day", String(ld_datetime, "yyyymmdd"))
         dw_body.Setitem(i, "area",    is_area_cd)
		END IF
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
	This.Post Event ue_closeParm()
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

type cb_close from w_com010_e`cb_close within w_53030_s2
integer x = 731
end type

type cb_delete from w_com010_e`cb_delete within w_53030_s2
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_53030_s2
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_53030_s2
boolean visible = false
end type

type cb_update from w_com010_e`cb_update within w_53030_s2
integer x = 87
end type

type cb_print from w_com010_e`cb_print within w_53030_s2
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_53030_s2
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_53030_s2
integer x = 14
integer width = 1106
end type

type cb_excel from w_com010_e`cb_excel within w_53030_s2
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_53030_s2
integer x = 41
integer y = 184
integer width = 974
integer height = 136
string dataobject = "d_53030_h20"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "jumin"     
		IF gf_jumin_chk(data) THEN
  		   Parent.Post Event ue_retrieve() 
		ELSE
			MessageBox("오류", "주민등록번호가 잘못되여 있습니다.")
			RETURN 1
		END IF
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_53030_s2
boolean visible = false
end type

type ln_2 from w_com010_e`ln_2 within w_53030_s2
boolean visible = false
end type

type dw_body from w_com010_e`dw_body within w_53030_s2
integer x = 41
integer y = 332
integer width = 1056
integer height = 244
boolean enabled = false
string dataobject = "d_53030_d20"
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "card_no2" 
		IF wf_card_chk(data) = FALSE THEN RETURN 1
 
	END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_53030_s2
end type

type st_1 from statictext within w_53030_s2
integer x = 14
integer y = 164
integer width = 1106
integer height = 452
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

