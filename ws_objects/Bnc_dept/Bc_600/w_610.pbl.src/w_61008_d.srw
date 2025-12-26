$PBExportHeader$w_61008_d.srw
$PBExportComments$중간매출조회
forward
global type w_61008_d from w_com010_d
end type
type dw_99 from datawindow within w_61008_d
end type
type dw_1 from datawindow within w_61008_d
end type
type cb_cal_sale_amt from commandbutton within w_61008_d
end type
end forward

global type w_61008_d from w_com010_d
integer width = 3680
integer height = 2244
string title = "판매현황조회"
dw_99 dw_99
dw_1 dw_1
cb_cal_sale_amt cb_cal_sale_amt
end type
global w_61008_d w_61008_d

type variables
/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
String 				is_brand,is_sale_ymd
DataWindowChild	idw_brand
end variables

forward prototypes
public subroutine wf_head_set ()
end prototypes

public subroutine wf_head_set ();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.05.13                                                  */	
/* 수정일      : 2002.05.13                                                  */
/*===========================================================================*/

Long   i, ll_row
String ls_modify, ls_week_cd 
String ls_wk[] = {"月", "火", "水", "木", "金", "土", "日"}

FOR i = 1 TO 7 
   ls_modify = ls_modify + "prev_day" + String(i) + "_t.text='" + ls_wk[i] + "' "
NEXT 
dw_body.Modify(ls_modify) 
dw_print.Modify(ls_modify) 

ll_row = dw_99.Retrieve(is_sale_ymd)
ls_modify = ""
FOR i = 1 TO ll_row 
	 ls_week_cd = dw_99.GetitemString(i, "week_cd")
    ls_modify  = ls_modify + "prev_day" + ls_week_cd + "_t.text='" + ls_wk[Long(ls_week_cd)] + & 
	              "(" + dw_99.object.dd[i] + ")' "
NEXT

dw_body.Modify(ls_modify)
dw_print.Modify(ls_modify) 


end subroutine

on w_61008_d.create
int iCurrent
call super::create
this.dw_99=create dw_99
this.dw_1=create dw_1
this.cb_cal_sale_amt=create cb_cal_sale_amt
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_99
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cb_cal_sale_amt
end on

on w_61008_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_99)
destroy(this.dw_1)
destroy(this.cb_cal_sale_amt)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.05.13 (김 태범)                                        */
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
if IsNull(is_brand) OR is_brand = "" then
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


is_sale_ymd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.05.13 (김 태범)                                        */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

wf_head_set()

il_rows = dw_body.retrieve(is_brand,is_sale_ymd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2002.05.13																  */	
/* 수정일      : 2002.05.13																  */
/*===========================================================================*/

dw_99.SetTransObject(SQLCA)



/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.03.05                                                  */	
/* 수정일      : 2002.03.05                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy-mm-dd hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)


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
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
//         cb_retrieve.Text = "조건(&Q)"
//         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
//   CASE 5    /* 조건 */
//      cb_retrieve.Text = "조회(&Q)"
//      cb_print.enabled = false
//      cb_preview.enabled = false
//      cb_excel.enabled = false
//      ib_changed = false
//      dw_body.Enabled = false
//      dw_head.Enabled = true
//      dw_head.SetFocus()
//      dw_head.SetColumn(1)
	
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61008_d","0")
end event

event timer;call super::timer;dw_body.SetRedRaw(FALSE)
dw_body.Retrieve(is_brand,is_sale_ymd)
dw_body.SetRedRaw(True)

end event

event open;call super::open;
Timer(60)
end event

type cb_close from w_com010_d`cb_close within w_61008_d
end type

type cb_delete from w_com010_d`cb_delete within w_61008_d
end type

type cb_insert from w_com010_d`cb_insert within w_61008_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61008_d
end type

type cb_update from w_com010_d`cb_update within w_61008_d
end type

type cb_print from w_com010_d`cb_print within w_61008_d
end type

type cb_preview from w_com010_d`cb_preview within w_61008_d
end type

type gb_button from w_com010_d`gb_button within w_61008_d
end type

type cb_excel from w_com010_d`cb_excel within w_61008_d
end type

type dw_head from w_com010_d`dw_head within w_61008_d
integer x = 23
integer y = 184
integer width = 3538
integer height = 156
string dataobject = "d_61008_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

idw_brand.InsertRow(1)
idw_brand.SetItem(1,'inter_cd','')
idw_brand.SetItem(1,'inter_nm','전체')

end event

type ln_1 from w_com010_d`ln_1 within w_61008_d
integer beginx = 14
integer beginy = 360
integer endx = 3634
integer endy = 360
end type

type ln_2 from w_com010_d`ln_2 within w_61008_d
integer beginx = 27
integer beginy = 364
integer endx = 3648
integer endy = 364
end type

type dw_body from w_com010_d`dw_body within w_61008_d
integer x = 9
integer y = 384
integer height = 1620
string dataobject = "d_61008_d01"
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(false)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_print from w_com010_d`dw_print within w_61008_d
integer x = 425
integer y = 520
integer width = 1330
integer height = 648
string dataobject = "d_61008_r01"
end type

type dw_99 from datawindow within w_61008_d
boolean visible = false
integer x = 818
integer y = 392
integer width = 411
integer height = 432
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_61008_d99"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_61008_d
boolean visible = false
integer y = 408
integer width = 3598
integer height = 484
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "당일 예상매출"
string dataobject = "d_61022_d01"
boolean controlmenu = true
boolean border = false
boolean livescroll = true
end type

type cb_cal_sale_amt from commandbutton within w_61008_d
integer x = 2025
integer y = 232
integer width = 489
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "당일 예상매출"
end type

event clicked;

il_rows = dw_1.retrieve(is_brand, is_sale_ymd, 1)
if il_rows > 0 then
	dw_1.visible = true
end if

	
end event

