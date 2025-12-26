$PBExportHeader$w_11002_e.srw
$PBExportComments$유통망 전개 계획
forward
global type w_11002_e from w_com020_e
end type
type dw_1 from datawindow within w_11002_e
end type
end forward

global type w_11002_e from w_com020_e
dw_1 dw_1
end type
global w_11002_e w_11002_e

type variables
DataWindowChild idw_brand
String is_brand, is_yyyy
end variables

forward prototypes
public subroutine wf_set_cnt (string as_yymm, string as_shop_div, integer ai_cnt)
end prototypes

public subroutine wf_set_cnt (string as_yymm, string as_shop_div, integer ai_cnt);/* dw_list에 open 매장수 처리 */
Long   ll_row, ll_cnt
String ls_col_nm

IF isnull(as_yymm) OR Trim(as_yymm) = "" THEN RETURN
IF isnull(as_shop_div) OR Trim(as_shop_div) = "" THEN RETURN

ll_row = dw_list.find("yymm = '" + as_yymm + "'", 1, dw_list.RowCount())

IF ll_row < 1 THEN RETURN

CHOOSE CASE as_shop_div
	CASE 'G'
		  ls_col_nm = "g_open_cnt"
	CASE 'K'
		  ls_col_nm = "k_open_cnt"
END CHOOSE

ll_cnt = dw_list.GetitemNumber(ll_row, ls_col_nm)
IF isnull(ll_cnt) THEN 
   ll_cnt = ai_cnt
ELSE
   ll_cnt = ll_cnt + ai_cnt
END IF
dw_list.Setitem(ll_row, ls_col_nm, ll_cnt)

end subroutine

on w_11002_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_11002_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight")
dw_1.SetTransObject(SQLCA)

end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.11                                                  */	
/* 수정일      : 2001.12.11                                                  */
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
/* 작성자      : 김 태범                                                     */ 
/* 작성일      : 2001.12.11                                                  */
/* 수정일      : 2001.12.11                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_1.retrieve(is_yyyy, is_brand)
dw_body.retrieve(is_yyyy, is_brand)
il_rows = dw_list.retrieve(is_yyyy, is_brand)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_button(7, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_delete;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2001.12.11																  */	
/* 수정일      : 2001.12.11																  */
/*===========================================================================*/
long			ll_cur_row
String      ls_yymm, ls_shop_div 

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

ls_yymm     = dw_body.GetitemString(ll_cur_row, "yymm")
ls_shop_div = dw_body.GetitemString(ll_cur_row, "shop_div")
il_rows = dw_body.DeleteRow (ll_cur_row)
wf_set_cnt(ls_yymm, ls_shop_div, -1)
dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.11                                                  */	
/* 수정일      : 2001.12.11                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status <> New! THEN	 
      dw_body.Setitem(i, "brand", is_brand)
      dw_body.Setitem(i, "Seq", String(i, "OP00"))
      dw_body.Setitem(i, "reg_id", gs_user_id)
      dw_body.Setitem(i, "reg_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_excel;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.11                                                  */	
/* 수정일      : 2001.12.11                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)
li_ret = dw_list.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event ue_preview;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

dw_print.Retrieve(is_yyyy, is_brand)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
This.Trigger Event ue_title ()

dw_print.Retrieve(is_yyyy, is_brand)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
datetime ld_datetime
String   ls_modify, ls_datetime, ls_brand 

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
ls_brand    = "브랜드 : " + idw_brand.GetitemString(idw_brand.Getrow(), "inter_display")

ls_modify =	"t_pg_id.Text = '"    + is_pgm_id + "'" + &
            "t_user_id.Text = '"  + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
				"t_yyyy.Text = '"     + is_yyyy + "년도 '" + &
				"t_brand.Text = '"    + ls_brand + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_11002_e","0")
end event

type cb_close from w_com020_e`cb_close within w_11002_e
integer taborder = 100
end type

type cb_delete from w_com020_e`cb_delete within w_11002_e
integer taborder = 50
end type

type cb_insert from w_com020_e`cb_insert within w_11002_e
integer taborder = 40
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_11002_e
end type

type cb_update from w_com020_e`cb_update within w_11002_e
integer taborder = 90
end type

type cb_print from w_com020_e`cb_print within w_11002_e
integer taborder = 60
end type

type cb_preview from w_com020_e`cb_preview within w_11002_e
integer taborder = 70
end type

type gb_button from w_com020_e`gb_button within w_11002_e
end type

type cb_excel from w_com020_e`cb_excel within w_11002_e
integer taborder = 80
end type

type dw_head from w_com020_e`dw_head within w_11002_e
integer height = 160
string dataobject = "d_11002_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com020_e`ln_1 within w_11002_e
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com020_e`ln_2 within w_11002_e
integer beginy = 352
integer endy = 352
end type

type dw_list from w_com020_e`dw_list within w_11002_e
integer y = 376
integer width = 1952
integer height = 1668
integer taborder = 0
string dataobject = "d_11002_d01"
end type

type dw_body from w_com020_e`dw_body within w_11002_e
integer x = 1993
integer y = 1100
integer width = 1609
integer height = 944
integer taborder = 30
string dataobject = "d_11002_d03"
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("shop_div", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('910')

ldw_child.SetFilter("inter_cd > 'D' AND inter_cd < 'T'")
ldw_child.Filter()


end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2001.12.11                                                  */	
/* 수정일      : 2001.12.11                                                  */
/*===========================================================================*/
String ls_yymm, ls_shop_div

CHOOSE CASE dwo.name
	CASE "yymm" 
		IF gf_datechk(data + "01") = FALSE OR is_yyyy <> MidA(Data, 1, 4) THEN 
			Return 1 
		END IF 
		ls_shop_div = This.GetitemString(row, "shop_div")
		ls_yymm     = This.GetitemString(row, "yymm")
		wf_set_cnt(ls_yymm, ls_shop_div, -1)
		wf_set_cnt(data,    ls_shop_div, 1)
	CASE "shop_div"	 
		ls_yymm     = This.GetitemString(row, "yymm")
		ls_shop_div = This.GetitemString(row, "shop_div")
		wf_set_cnt(ls_yymm, ls_shop_div, -1)
		wf_set_cnt(ls_yymm, data, 1)
END CHOOSE

end event

type st_1 from w_com020_e`st_1 within w_11002_e
boolean visible = false
integer x = 1984
integer y = 376
boolean enabled = false
end type

type dw_print from w_com020_e`dw_print within w_11002_e
string dataobject = "d_11002_r04"
end type

type dw_1 from datawindow within w_11002_e
integer x = 1993
integer y = 376
integer width = 1609
integer height = 720
boolean bringtotop = true
string title = "none"
string dataobject = "d_11002_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

