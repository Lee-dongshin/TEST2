$PBExportHeader$w_53016_e.srw
$PBExportComments$전국 타사월매출등록
forward
global type w_53016_e from w_com020_e
end type
end forward

global type w_53016_e from w_com020_e
integer width = 3680
integer height = 2252
end type
global w_53016_e w_53016_e

type variables
DataWindowChild idw_brand, idw_yymm, idw_area_no
String	is_brand, is_yymm, is_area_no, is_store_cd, is_othr_brand
end variables

on w_53016_e.create
call super::create
end on

on w_53016_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "yymm" ,MidA(string(ld_datetime,"yyyymmdd"),1,6))
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_area_no = dw_head.GetItemString(1, "area_no")
if IsNull(is_area_no) or Trim(is_area_no) = "" then
   MessageBox(ls_title,"지역구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("area_no")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53016_e","0")
end event

event ue_preview();
This.Trigger Event ue_title ()

dw_print.retrieve(is_brand, is_yymm, is_area_no)

dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();
This.Trigger Event ue_title()

dw_print.retrieve(is_brand, is_yymm, is_area_no)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text =     '" + is_pgm_id + "'" + &
            "t_user_id.Text =   '" + gs_user_id + "'" + &
            "t_datetime.Text =  '" + ls_datetime + "'" + &
            "t_brand.Text =     '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_yymm.Text =      '" + String(is_yymm, '@@@@/@@') + "'" + &
            "t_area_no.Text =   '" + idw_area_no.GetItemString(idw_area_no.GetRow(), "inter_display") + "'"

dw_print.Modify(ls_modify)


end event

type cb_close from w_com020_e`cb_close within w_53016_e
end type

type cb_delete from w_com020_e`cb_delete within w_53016_e
end type

type cb_insert from w_com020_e`cb_insert within w_53016_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_53016_e
end type

type cb_update from w_com020_e`cb_update within w_53016_e
end type

type cb_print from w_com020_e`cb_print within w_53016_e
end type

type cb_preview from w_com020_e`cb_preview within w_53016_e
end type

type gb_button from w_com020_e`gb_button within w_53016_e
end type

type cb_excel from w_com020_e`cb_excel within w_53016_e
end type

type dw_head from w_com020_e`dw_head within w_53016_e
integer y = 164
integer width = 3355
integer height = 140
string dataobject = "d_53016_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("area_no", idw_area_no)
idw_area_no.SetTransObject(SQLCA)
idw_area_no.Retrieve('091')
idw_area_no.InsertRow(1)
idw_area_no.SetItem(1, "inter_cd", '%')
idw_area_no.SetItem(1, "inter_nm", '전체')


end event

type ln_1 from w_com020_e`ln_1 within w_53016_e
integer beginy = 316
integer endy = 316
end type

type ln_2 from w_com020_e`ln_2 within w_53016_e
integer beginy = 320
integer endy = 320
end type

type dw_list from w_com020_e`dw_list within w_53016_e
integer y = 332
integer height = 1684
string dataobject = "d_53016_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
int i
string ls_flag


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

is_othr_brand = This.GetItemString(row, 'inter_cd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_othr_brand) THEN return
il_rows = dw_body.retrieve(is_yymm, is_othr_brand,is_brand)

IF il_rows > 0 THEN
	for i = 1 to il_rows
		ls_flag = dw_body.getitemstring(i,"flag")
		if ls_flag = 'New' then	dw_body.SetItemStatus(i, 0, Primary!, New!)

	next 
   dw_body.SetFocus()
END IF


Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_53016_e
integer y = 332
integer width = 2793
integer height = 1684
string dataobject = "d_53016_d02"
end type

type st_1 from w_com020_e`st_1 within w_53016_e
integer y = 332
integer height = 1684
end type

type dw_print from w_com020_e`dw_print within w_53016_e
string dataobject = "d_53016_d04"
end type

