$PBExportHeader$w_54010_e.srw
$PBExportComments$완불요청 지시
forward
global type w_54010_e from w_com020_e
end type
type st_info from statictext within w_54010_e
end type
type cb_1 from commandbutton within w_54010_e
end type
type st_qty from statictext within w_54010_e
end type
end forward

global type w_54010_e from w_com020_e
integer width = 3689
integer height = 2252
event ue_first_open ( )
st_info st_info
cb_1 cb_1
st_qty st_qty
end type
global w_54010_e w_54010_e

type variables
String is_brand,  is_fr_ymd,  is_to_ymd 
String is_yymmdd, is_shop_cd, is_shop_type, is_check, is_self_yn
String is_style,  is_chno,    is_color,     is_size, is_opt_gubn, IS_HOUSE_CD
int    ii_rqst_seq
DataWindowChild idw_house_cd

end variables

event ue_first_open();/*------------------------------------------------------------*/
/* 내        용  : 기본 WINDOW를 Open한다. 'W_CU100_e04'      */
/*------------------------------------------------------------*/
Window lw_window

lw_window = This
gf_open_sheet(lw_window, 'W_54010_s1', '당일 완불작업분 확정')

end event

on w_54010_e.create
int iCurrent
call super::create
this.st_info=create st_info
this.cb_1=create cb_1
this.st_qty=create st_qty
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_info
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_qty
end on

on w_54010_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_info)
destroy(this.cb_1)
destroy(this.st_qty)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.29                                                  */	
/* 수정일      : 2002.03.29                                                  */
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

is_fr_ymd = String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
is_to_ymd = String(dw_head.GetItemDate(1, "to_ymd"), "yyyymmdd")

is_opt_gubn = dw_head.GetItemString(1, "opt_gubn")
if IsNull(is_opt_gubn) or Trim(is_opt_gubn) = "" then
   MessageBox(ls_title,"조회기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_gubn")
   return false
end if

is_check = dw_head.GetItemString(1, "check")
if IsNull(is_check) or Trim(is_check) = "" then
   MessageBox(ls_title,"구분코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("check")
   return false
end if


is_self_yn = dw_head.GetItemString(1, "self_yn")
if IsNull(is_self_yn) or Trim(is_self_yn) = "" then
   MessageBox(ls_title,"자체해결 여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("self_yn")
   return false
end if

is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if


if is_brand <> 'W' and is_house_cd = "030000" then
	messagebox("경고!", "해당브랜드에 창고가 맞지 않습니다!")
	return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */ 
/* 작성일      : 2002.03.29                                                  */
/* 수정일      : 2002.03.29                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_opt_gubn, is_check, is_self_yn, is_house_cd)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.29                                                  */	
/* 수정일      : 2002.03.29                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_cnt
datetime ld_datetime
String   ls_rt_ymd, ls_shop_cd

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
	  idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN		   /* Modify Record */
	   if dw_body.getitemNumber(i, "rqst_qty") = 0  and dw_body.getitemstring(i, "accept_fg") <> "Y" then 
         dw_body.DeleteRow (i)
		elseif dw_body.getitemstring(i, "accept_fg") = "Y" then
			messagebox("경고!", "매장에서 완불승인한것은 삭제 할 수 없습니다!")
		end if	
   ELSEIF idw_status = NewModified! THEN		
	   if dw_body.getitemNumber(i, "rqst_qty") = 0  and dw_body.getitemstring(i, "accept_fg") <> "Y" then 
         dw_body.DeleteRow (i)
		elseif dw_body.getitemstring(i, "accept_fg") = "Y" then
			messagebox("경고!", "매장에서 완불승인한것은 삭제 할 수 없습니다!")
		end if			
		
	END IF
NEXT

ll_row_count = dw_body.RowCount()
ls_rt_ymd = String(ld_datetime, "yyyymmdd")

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   ls_shop_cd = dw_body.getitemstring(i, "rt_shop")	

   IF idw_status = NewModified! THEN				/* New Record    */
	   if MidA(ls_shop_cd,2,5) = "G0000" then 
			dw_body.Setitem(i, "accept_fg", "Y")
			dw_body.Setitem(i, "accept_qty", dw_body.getitemnumber(i, "rqst_qty"))
			dw_body.Setitem(i, "accept_ymd", string(ld_datetime,"yyyymmdd") )
			dw_body.Setitem(i, "proc_yn", "Y")						
		
		end if	
	      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
	
	 if isnull(dw_body.getitemNumber(i, "rqst_qty")) then
			ll_cnt = ll_cnt +0
		else 
			ll_cnt = ll_cnt + dw_body.getitemNumber(i, "rqst_qty")	
		end if 	
	
	   if MidA(ls_shop_cd,2,5) = "G0000" and ll_cnt <> 0   then 
			dw_body.Setitem(i, "accept_fg", "Y")
			dw_body.Setitem(i, "accept_qty", dw_body.getitemnumber(i, "rqst_qty"))
			dw_body.Setitem(i, "accept_ymd", string(ld_datetime,"yyyymmdd"))
			dw_body.Setitem(i, "proc_yn", "Y")			
		
		end if	
		
		IF isnull(dw_body.Object.rt_ymd[i]) THEN
         dw_body.Setitem(i, "rt_ymd", ls_rt_ymd)
         dw_body.Setitem(i, "reg_id", gs_user_id)
         dw_body.Setitem(i, "reg_dt", ld_datetime)
			dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
		ELSE
         dw_body.Setitem(i, "mod_id", gs_user_id)
         dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF
   END IF
NEXT

ll_cnt = 0
il_rows = dw_body.Update(TRUE, FALSE)
if il_rows = 1 then

	
   ll_row_count = dw_body.RowCount()
	FOR i=1 TO ll_row_count
		
	   if isnull(dw_body.getitemNumber(i, "rqst_qty")) then
			ll_cnt = ll_cnt +0
		else 
			ll_cnt = ll_cnt + dw_body.getitemNumber(i, "rqst_qty")	
		end if 	
			
   NEXT
  		
		
	if ll_cnt > 0 then
		dw_list.Setitem(dw_list.GetSelectedRow(0), "rt_yn", 'Y')
   else
		dw_list.Setitem(dw_list.GetSelectedRow(0), "rt_yn", 'N')
	end if	
	   dw_list.Setitem(dw_list.GetSelectedRow(0), "mod_id", gs_user_id)
	   dw_list.Setitem(dw_list.GetSelectedRow(0), "mod_dt", ld_datetime)
   il_rows = dw_list.Update(TRUE, FALSE)
end if

if il_rows = 1 then
   dw_list.ResetUpdate()
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54010_e","0")
end event

type cb_close from w_com020_e`cb_close within w_54010_e
end type

type cb_delete from w_com020_e`cb_delete within w_54010_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_54010_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_54010_e
end type

type cb_update from w_com020_e`cb_update within w_54010_e
end type

type cb_print from w_com020_e`cb_print within w_54010_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_54010_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_54010_e
end type

type cb_excel from w_com020_e`cb_excel within w_54010_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_54010_e
integer y = 164
integer width = 3566
integer height = 228
string dataobject = "d_54010_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()

end event

type ln_1 from w_com020_e`ln_1 within w_54010_e
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com020_e`ln_2 within w_54010_e
integer beginy = 428
integer endy = 428
end type

type dw_list from w_com020_e`dw_list within w_54010_e
integer x = 5
integer y = 444
integer width = 2327
integer height = 1576
string dataobject = "d_54010_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.29                                                  */	
/* 수정일      : 2002.03.29                                                  */
/*===========================================================================*/
long ll_tag_price, ll_ord_qty, ll_in_qty, ll_not_inqty, ll_stock_qty
string ls_out_ymd

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

is_yymmdd    = This.GetItemString(row, 'yymmdd')
is_shop_cd   = This.GetItemString(row, 'shop_cd') 
is_shop_type = This.GetItemString(row, 'shop_type') 
is_style     = This.GetItemString(row, 'style') 
is_chno      = This.GetItemString(row, 'chno') 
is_color     = This.GetItemString(row, 'color') 
is_size      = This.GetItemString(row, 'size') 
ii_rqst_seq  = This.GetItemNumber(row, 'rqst_seq') 

dw_list.ResetUpdate()



select dbo.sf_first_price(style),  min(out_ymd),
       sum(isnull(ord_qty,0)),  sum(isnull(in_qty,0)), sum(isnull(ord_qty,0) - isnull(in_qty,0)) ,
		 isnull(dbo.SF_HOUSE_real_STOCK(style,:is_chno,:is_color,:is_size,'010000'),0)
into :ll_tag_price, :ls_out_ymd, :ll_ord_qty, :ll_in_qty, :ll_not_inqty, :ll_stock_qty
from tb_12030_s (nolock)
where style =  :is_style
 and  chno  =  :is_chno
 and  color =  :is_color
 and  size  =  :is_size
group by style;


//select dbo.sf_first_price(style),  min(out_ymd),
//       sum(isnull(ord_qty,0)),  sum(isnull(in_qty,0)), sum(isnull(ord_qty,0) - isnull(in_qty,0))
//into :ll_tag_price, :ls_out_ymd, :ll_ord_qty, :ll_in_qty, :ll_not_inqty
//from tb_12030_s
//where style =  :is_style
// and  chno  =  :is_chno
// and  color =  :is_color
// and  size  =  :is_size
//group by style;

st_info.text = "♥품번:"  + is_style + "-" + is_chno +  "/ 가격:" + string(ll_tag_price, "#,###") + "원 / 최초출고일:" + string(ls_out_ymd, "@@@@/@@/@@")
st_qty.text =  "♥기획:"  + string(ll_ord_qty, "#,##0") + ", 입고:" + string(ll_in_qty, "#,##0") +  ", 잔량:" + string(ll_not_inqty, "#,##0") + ", 재고:" + string(ll_stock_qty, "#,##0") + " " 

il_rows = dw_body.retrieve(is_style,   is_chno,      is_color,  is_size,  is_yymmdd, &
                           is_shop_cd, is_shop_type, ii_rqst_seq, is_check)


Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

event dw_list::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(225,238,253), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

type dw_body from w_com020_e`dw_body within w_54010_e
integer x = 2354
integer y = 444
integer width = 1253
integer height = 1576
string dataobject = "d_54010_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type st_1 from w_com020_e`st_1 within w_54010_e
integer x = 2336
integer y = 444
integer height = 1576
end type

type dw_print from w_com020_e`dw_print within w_54010_e
end type

type st_info from statictext within w_54010_e
integer x = 73
integer y = 284
integer width = 1961
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_54010_e
integer x = 379
integer y = 44
integer width = 347
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "작업확정"
end type

event clicked;long     i, k, ll_row_count, ll_assort_cnt, ll_find, ll_rt_qty , ll_sale_qty, ll_out_qty
datetime ld_datetime
string ls_chk, ls_style


IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


Parent.Trigger Event ue_first_open()
		
return il_rows

end event

type st_qty from statictext within w_54010_e
integer x = 73
integer y = 352
integer width = 1961
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

