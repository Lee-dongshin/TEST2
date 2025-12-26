$PBExportHeader$w_sh122_e.srw
$PBExportComments$백화점 Key 입력
forward
global type w_sh122_e from w_com010_e
end type
end forward

global type w_sh122_e from w_com010_e
integer width = 2958
integer height = 2088
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowstate windowstate = maximized!
event ue_set_stat ( integer as_row )
end type
global w_sh122_e w_sh122_e

type variables
string is_yymmdd, is_reg_mm
end variables

on w_sh122_e.create
call super::create
end on

on w_sh122_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_preopen();/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범) 		   										  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/


of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

menu			lm_curr_menu
lm_curr_menu = this.menuid
IF gl_user_level = 999 then 
   lm_curr_menu.item[2].enabled = True 
ELSE
   lm_curr_menu.item[2].enabled = False
END IF 	

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
//inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)




end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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

//if mid(gs_shop_cd,3,4) = '2000' then
//	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
//	return false
//end if	

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"날자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_reg_mm = dw_head.GetItemString(1, "reg_mm")

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                         */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_magam_yn
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(gs_shop_cd, is_yymmdd, '3', is_reg_mm)
if il_rows > 0 then
   dw_body.SetFocus()
else 	
//	dw_body.insertrow(1)
	trigger event ue_insert()	
end if


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)


	


end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long 		i, ll_row_count, ll_sale_qty, ll_sale_amt, ll_row
datetime ld_datetime
decimal  ldc_dc_rate, ldc_sale_rate
string 	ls_last_day, ls_sale_type

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
		ls_sale_type = dw_body.getitemstring(i,"sale_type")
		if isnull(ls_sale_type) or ls_sale_type = "" then dw_body.deleterow(i)		
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

if is_reg_mm = 'Y' then
	dw_head.setitem(1,'reg_mm','N')
	trigger event ue_retrieve()
end if

return il_rows

end event

event ue_insert();/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

il_rows = dw_body.InsertRow(0)

dw_body.setitem(dw_body.rowcount(),'gubn','3')
dw_body.setitem(dw_body.rowcount(),'yymmdd',is_yymmdd)
dw_body.setitem(dw_body.rowcount(),'shop_cd',gs_shop_cd)
dw_body.setitem(dw_body.rowcount(),'brand',gs_brand)
dw_body.setitem(dw_body.rowcount(),'shop_div',gs_shop_div)
dw_body.setitem(dw_body.rowcount(),'magam_yn','N')
dw_body.setitem(dw_body.rowcount(),'prot',0)


dw_body.SetItemStatus(dw_body.rowcount(), 0, Primary!, New!)


/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)



end event

event open;call super::open;string ls_yymmdd, ls_last_day
ls_yymmdd = dw_head.getitemstring(1,"yymmdd")

gf_lastday(ls_yymmdd, ls_last_day) 
if ls_yymmdd = ls_last_day then	 
	dw_head.object.reg_mm.visible = true
else
	dw_head.object.reg_mm.visible = false
end if
end event

type cb_close from w_com010_e`cb_close within w_sh122_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh122_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh122_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh122_e
end type

type cb_update from w_com010_e`cb_update within w_sh122_e
end type

type cb_print from w_com010_e`cb_print within w_sh122_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh122_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh122_e
end type

type dw_head from w_com010_e`dw_head within w_sh122_e
integer height = 144
string dataobject = "d_sh121_h01"
end type

event dw_head::itemchanged;call super::itemchanged;string ls_last_day
choose case dwo.name
	case "yymmdd"
		if not gf_datechk(data) then 
			messagebox("오류","일자를 올바로 입력하세요..")
			return 1
	
				
		end if
end choose

end event

type ln_1 from w_com010_e`ln_1 within w_sh122_e
integer beginy = 336
integer endy = 336
end type

type ln_2 from w_com010_e`ln_2 within w_sh122_e
integer beginy = 340
integer endy = 340
end type

type dw_body from w_com010_e`dw_body within w_sh122_e
event type boolean ue_magin_set ( long as_row )
integer x = 23
integer y = 352
integer width = 2843
integer height = 1492
string dataobject = "d_sh122_d01"
end type

event type boolean dw_body::ue_magin_set(long as_row);decimal ldc_sale_rate, ldc_dc_rate
string  ls_sale_type, ls_shop_type
long ll_ret

ls_sale_type = this.getitemstring(as_row,"sale_type")
if ls_sale_type <= '2' then 
	ls_shop_type = '1'
else
	ls_shop_type = ls_sale_type
end if

ldc_dc_rate  = this.getitemnumber(as_row,"dc_rate")
ldc_sale_rate  = this.getitemnumber(as_row,"sale_rate")

   select marjin_rate
		into :ll_ret
     from tb_56010_m with(index(pk_56010_m))
    where shop_cd   =  :gs_shop_cd
      and brand     =  :gs_brand
      and shop_type =  :ls_shop_type
      and sale_type like :ls_sale_type + '%'
      and dc_rate   =  :ldc_dc_rate
      and end_ymd   >= :is_yymmdd
		and marjin_rate = :ldc_sale_rate;


if isnull(ll_ret) then 
	return False
else
	return True
end if



end event

event dw_body::buttonclicked;call super::buttonclicked;choose case dwo.name
	case "b_insert"
		parent.trigger event ue_insert()	

		this.setrow(this.rowcount())
		this.setcolumn("sale_type")
		this.setfocus()
	
	case "b_delete"		
		parent.trigger event ue_delete()		
//		if this.rowcount() = 0 then 
//			parent.trigger event ue_insert()	
//			this.SetItemStatus(1, 0, Primary!, New!)
//		end if
//			
end choose

end event

type dw_print from w_com010_e`dw_print within w_sh122_e
integer x = 5
integer y = 296
end type

