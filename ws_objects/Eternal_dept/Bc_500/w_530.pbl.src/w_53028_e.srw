$PBExportHeader$w_53028_e.srw
$PBExportComments$마일리지,할인권 판품등록
forward
global type w_53028_e from w_com020_e
end type
end forward

global type w_53028_e from w_com020_e
integer width = 3675
integer height = 2332
end type
global w_53028_e w_53028_e

type variables
string is_brand, is_jumin
datawindowchild idw_brand

end variables

on w_53028_e.create
call super::create
end on

on w_53028_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

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
is_jumin = dw_head.GetItemString(1, "jumin")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_jumin)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/*===========================================================================*/
/* 작성자      : 지우정보 (김태범) 				   									  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(st_1, "ScaleToBottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
string ls_yymmdd, ls_shop_cd, ls_shop_type, ls_sale_no, ls_no = '0000'

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
		ls_yymmdd    = dw_body.getitemstring(i,"yymmdd")
		ls_shop_cd   = dw_body.getitemstring(i,"shop_cd")
		ls_shop_type = dw_body.getitemstring(i,"shop_type")
		
		select right('0000' + cast(1 + 
				isnull((select max(sale_no)	
				from tb_53010_h 
				where yymmdd    = :ls_yymmdd
				and   shop_cd   = :ls_shop_cd
				and   shop_type = :ls_shop_type),0) as varchar(4) ),4)
				into :ls_sale_no
		from dual;
		dw_body.setitem(i,"sale_no",ls_sale_no)
		
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
dw_list.retrieve(is_brand, is_jumin)
dw_body.reset()
return il_rows

end event

type cb_close from w_com020_e`cb_close within w_53028_e
end type

type cb_delete from w_com020_e`cb_delete within w_53028_e
end type

type cb_insert from w_com020_e`cb_insert within w_53028_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_53028_e
end type

type cb_update from w_com020_e`cb_update within w_53028_e
end type

type cb_print from w_com020_e`cb_print within w_53028_e
end type

type cb_preview from w_com020_e`cb_preview within w_53028_e
end type

type gb_button from w_com020_e`gb_button within w_53028_e
end type

type cb_excel from w_com020_e`cb_excel within w_53028_e
end type

type dw_head from w_com020_e`dw_head within w_53028_e
integer y = 160
integer height = 132
string dataobject = "d_53028_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


end event

event dw_head::itemchanged;call super::itemchanged;string ls_user_name
choose case dwo.name
	case 'jumin'
		select user_name 
		into :ls_user_name
		from tb_71010_m (nolock)
		where jumin = :data;
		
		this.setitem(1,"user_name",ls_user_name)
		
end choose
end event

type ln_1 from w_com020_e`ln_1 within w_53028_e
integer beginy = 300
integer endy = 300
end type

type ln_2 from w_com020_e`ln_2 within w_53028_e
integer beginy = 304
integer endy = 304
end type

type dw_list from w_com020_e`dw_list within w_53028_e
event ue_rowcopy ( long as_row,  integer as_gbn )
integer y = 316
integer width = 3566
integer height = 1344
string dataobject = "d_53028_d01"
end type

event dw_list::ue_rowcopy(long as_row, integer as_gbn);long 		ll_row, i, body_row, ll_rowcnt


if as_gbn = 1 then 
	dw_list.rowscopy(as_row,as_row,Primary!,dw_body,dw_body.rowcount()+1,Primary!)
	dw_body.setitem(dw_body.rowcount(),"rtrn_yn", as_row)

	ll_rowcnt = dw_body.rowcount()
	dw_body.setitem(ll_rowcnt,"sale_qty"    , dw_body.getitemnumber(ll_rowcnt,"sale_qty"    )* -1 )
	dw_body.setitem(ll_rowcnt,"tag_amt"     , dw_body.getitemnumber(ll_rowcnt,"tag_amt"     )* -1 )
	dw_body.setitem(ll_rowcnt,"curr_amt"    , dw_body.getitemnumber(ll_rowcnt,"curr_amt"    )* -1 )
	dw_body.setitem(ll_rowcnt,"sale_amt"    , dw_body.getitemnumber(ll_rowcnt,"sale_amt"    )* -1 )
	dw_body.setitem(ll_rowcnt,"out_amt"     , dw_body.getitemnumber(ll_rowcnt,"out_amt"     )* -1 )
	dw_body.setitem(ll_rowcnt,"sale_collect", dw_body.getitemnumber(ll_rowcnt,"sale_collect")* -1 )
	dw_body.setitem(ll_rowcnt,"io_amt"      , dw_body.getitemnumber(ll_rowcnt,"io_amt"      )* -1 )
	dw_body.setitem(ll_rowcnt,"io_vat"      , dw_body.getitemnumber(ll_rowcnt,"io_vat"      )* -1 )	
	dw_body.setitem(ll_rowcnt,"goods_amt"   , dw_body.getitemnumber(ll_rowcnt,"goods_amt"   )* -1 )



else
	for i = 1 to dw_body.rowcount()
		body_row = dw_body.getitemnumber(i,"rtrn_yn")
		if body_row = as_row then 
			dw_body.deleterow(i)
			return
		end if
	next
	
end if
end event

event dw_list::clicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
String 	ls_search
if row > 0 then 
	choose case dwo.name
		case 'style','style_no'
			ls_search 	= this.GetItemString(row,string(dwo.name))
			if LenA(ls_search) >= 8 then gf_style_pic(ls_search, '%')
	end choose	
end if

end event

event dw_list::itemchanged;choose case dwo.name
	case "rtrn_yn"
		if data = '1' then 
			post event ue_rowcopy(row,1)			
			ib_changed = true
			cb_update.enabled = true
		else
			post event ue_rowcopy(row,0)			
		end if
		
end choose

end event

type dw_body from w_com020_e`dw_body within w_53028_e
integer x = 27
integer y = 1664
integer width = 3566
integer height = 436
string dataobject = "d_53028_d02"
end type

event dw_body::clicked;call super::clicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
String 	ls_search
if row > 0 then 
	choose case dwo.name
		case 'style','style_no'
			ls_search 	= this.GetItemString(row,string(dwo.name))
			if LenA(ls_search) >= 8 then gf_style_pic(ls_search, '%')
	end choose	
end if

end event

type st_1 from w_com020_e`st_1 within w_53028_e
boolean visible = false
integer x = 2286
end type

type dw_print from w_com020_e`dw_print within w_53028_e
end type

