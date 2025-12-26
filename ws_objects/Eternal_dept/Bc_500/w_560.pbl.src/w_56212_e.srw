$PBExportHeader$w_56212_e.srw
$PBExportComments$매출계산서 회계전표 발행
forward
global type w_56212_e from w_com010_e
end type
end forward

global type w_56212_e from w_com010_e
integer width = 3680
integer height = 2284
end type
global w_56212_e w_56212_e

type variables
String is_brand, is_yymm, is_shop_div
String is_yn
end variables

on w_56212_e.create
call super::create
end on

on w_56212_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_head.Setitem(1, "shop_div", '%')


end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.06.24                                                  */	
/* 수정일      : 2002.06.24                                                  */
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
is_yymm     = String(dw_head.GetItemDateTime(1, "yymm"), "yyyymm")
is_yn       = 'N'

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.24                                                  */	
/* 수정일      : 2002.06.24                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymm, is_brand, is_shop_div)
dw_print.retrieve(is_yymm, is_brand, is_shop_div)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.24                                                  */	
/* 수정일      : 2002.06.24                                                  */
/*===========================================================================*/
long   i, ll_row_count, ll_cnt 
String ls_slip_bonji, ls_issue_date, ls_bill_no 
String ls_job_yn    , ls_ErrMsg 

IF dw_body.AcceptText() <> 1 THEN RETURN -1

ll_row_count = dw_body.RowCount()
il_rows = 1
ll_cnt  = 0 
FOR i=1 TO ll_row_count
	 ls_job_yn = dw_body.GetitemString(i, "job_yn")
	 IF ls_job_yn = 'N' THEN CONTINUE
	 ls_slip_bonji = dw_body.GetitemString(i, "slip_bonji")
	 ls_issue_date = dw_body.GetitemString(i, "issue_date")
	 ls_bill_no    = dw_body.GetitemString(i, "bill_no")
    DECLARE sp_TranMae2Acc PROCEDURE FOR sp_TranMae2Acc 
         @slip_bonji = :ls_slip_bonji,   
         @issue_date = :ls_issue_date , 
		   @bill_no    = :ls_bill_no, 
		   @Uid        = :gs_user_id, 
		   @dept_code  = :gs_dept_cd ;
    EXECUTE sp_TranMae2Acc;
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
NEXT

if ll_cnt > 0 then
	dw_body.retrieve(is_yymm, is_brand, is_shop_div)
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56212_e","0")
end event

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */
/* 작성일      : 2002.02.27                                                  */
/* 수정일      : 2002.02.27                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_modify2, ls_datetime, ls_sale_type, ls_shop_nm, ls_brand_nm
Long i, ll_row_count

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

select inter_data2 
into   :ls_brand_nm
from   tb_91011_c (nolock)
where  inter_grp = '001'
and    inter_cd  = :is_brand;


	ls_modify =	"t_yyyy.Text     = '" + LeftA(is_yymm,4)    + " 년 " + MidA(is_yymm,5,2)    + " 월 '" + &					
					"t_brand_nm.Text  = '" + ls_brand_nm + "'"		

	dw_print.Modify(ls_modify)

end event

type cb_close from w_com010_e`cb_close within w_56212_e
end type

type cb_delete from w_com010_e`cb_delete within w_56212_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56212_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56212_e
end type

type cb_update from w_com010_e`cb_update within w_56212_e
end type

type cb_print from w_com010_e`cb_print within w_56212_e
end type

type cb_preview from w_com010_e`cb_preview within w_56212_e
end type

type gb_button from w_com010_e`gb_button within w_56212_e
end type

type cb_excel from w_com010_e`cb_excel within w_56212_e
end type

type dw_head from w_com010_e`dw_head within w_56212_e
integer x = 27
integer y = 168
integer height = 172
string dataobject = "d_56212_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("shop_div", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('910')
ldw_child.insertRow(1)
ldw_child.Setitem(1, "inter_cd", "%")
ldw_child.Setitem(1, "inter_nm", "전체")
ldw_child.SetFilter("inter_cd <> 'A' AND inter_cd <> 'Z'")
ldw_child.Filter()





end event

type ln_1 from w_com010_e`ln_1 within w_56212_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_e`ln_2 within w_56212_e
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_e`dw_body within w_56212_e
integer x = 9
integer y = 376
integer height = 1676
string dataobject = "d_56212_d01"
end type

event dw_body::buttonclicked;call super::buttonclicked;Long   i, ll_row 
String ls_slip_date

IF dwo.name <> "b_yn" THEN RETURN 

ll_row = This.RowCount()
IF ll_row < 1 THEN RETURN 

IF is_yn = 'Y' THEN
	is_yn = 'N'
ELSE
	is_yn = 'Y'
END IF 

FOR i = 1 TO ll_row 
	ls_slip_date = This.GetitemString(i, "slip_date")
	IF isnull(ls_slip_date) or Trim(ls_slip_date) = "" THEN
		This.Setitem(i, "job_yn", is_yn)
		ib_changed = true
      cb_update.enabled = true
	END IF
NEXT 

end event

type dw_print from w_com010_e`dw_print within w_56212_e
integer width = 2135
integer height = 752
string dataobject = "d_56212_r01"
end type

