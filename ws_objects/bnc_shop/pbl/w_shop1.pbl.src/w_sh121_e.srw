$PBExportHeader$w_sh121_e.srw
$PBExportComments$백화점 Key 입력
forward
global type w_sh121_e from w_com010_e
end type
type dw_1 from datawindow within w_sh121_e
end type
type dw_2 from datawindow within w_sh121_e
end type
type dw_3 from datawindow within w_sh121_e
end type
type st_1 from statictext within w_sh121_e
end type
type st_2 from statictext within w_sh121_e
end type
type st_3 from statictext within w_sh121_e
end type
type st_4 from statictext within w_sh121_e
end type
type st_5 from statictext within w_sh121_e
end type
end forward

global type w_sh121_e from w_com010_e
integer width = 2939
integer height = 2084
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowstate windowstate = maximized!
event ue_set_stat ( integer as_row )
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
end type
global w_sh121_e w_sh121_e

type variables
string is_yymmdd, is_reg_mm
end variables

on w_sh121_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_5
end on

on w_sh121_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
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


dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)

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

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
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

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = dw_head.getitemstring(1,'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if


il_rows = dw_1.retrieve(gs_shop_cd, is_yymmdd, '1', is_reg_mm)
il_rows = dw_2.retrieve(gs_shop_cd, is_yymmdd, '2', is_reg_mm)
il_rows = dw_3.retrieve(gs_shop_cd, is_yymmdd, '4', is_reg_mm)

if il_rows = 0 and is_reg_mm = 'Y' then 
	dw_3.trigger event ue_insert()
end if

ls_magam_yn = dw_3.getitemstring(1,"magam_yn")
il_rows = dw_body.retrieve(gs_shop_cd, is_yymmdd, '3', is_reg_mm)
if il_rows > 0 then
   dw_body.SetFocus()
elseif ls_magam_yn = 'Y' then
	MessageBox("확인","마감된 월이므로 마지막 일자만 입력 가능 합니다..")
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
IF dw_3.AcceptText() <> 1 THEN RETURN -1

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

gf_lastday(is_yymmdd, ls_last_day ) 					
if is_reg_mm = 'Y' and  is_yymmdd = ls_last_day then	 
	FOR i=1 TO dw_3.rowcount()	 
		ls_sale_type   = dw_3.getitemstring(i,"sale_type")
		ldc_dc_rate    = dw_3.getitemnumber(i,"dc_rate")
		ldc_sale_rate  = dw_3.getitemnumber(i,"sale_rate")
		ll_sale_qty    = dw_3.getitemnumber(i,"sale_qty")
		ll_sale_amt    = dw_3.getitemnumber(i,"sale_amt")	
		
//messagebox("ls_sale_type",ls_sale_type)
//messagebox("ldc_dc_rate",string(ldc_dc_rate))
//messagebox("ldc_sale_rate",string(ldc_sale_rate))
//messagebox("ll_sale_qty",string(ll_sale_qty))
//messagebox("ll_sale_amt",string(ll_sale_amt))


		DECLARE sp_sh121_key PROCEDURE FOR sp_sh121_key  
					@yymmdd 		= :is_yymmdd,   
					@shop_cd 	= :gs_shop_cd,   
					@sale_type 	= :ls_sale_type,   
					@dc_rate 	= :ldc_dc_rate,   
					@sale_rate 	= :ldc_sale_rate,   
					@sale_qty 	= :ll_sale_qty,   
					@sale_amt 	= :ll_sale_amt,   
					@clear_fg 	= :i;
					
		execute 		sp_sh121_key;		
		
		if sqlca.sqlcode = 0 then 
			rollback  USING SQLCA;
			return i
		else
			commit  USING SQLCA;
		end if
	Next
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

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = dw_head.getitemstring(1,'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

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

type cb_close from w_com010_e`cb_close within w_sh121_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh121_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh121_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh121_e
end type

type cb_update from w_com010_e`cb_update within w_sh121_e
end type

type cb_print from w_com010_e`cb_print within w_sh121_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh121_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh121_e
end type

type dw_head from w_com010_e`dw_head within w_sh121_e
integer height = 144
string dataobject = "d_sh121_h01"
end type

event dw_head::itemchanged;call super::itemchanged;string ls_last_day
long ll_b_cnt
choose case dwo.name
	case "yymmdd"
		if not gf_datechk(data) then 
			messagebox("오류","일자를 올바로 입력하세요..")
			return 1
		else
				gf_lastday(data, ls_last_day) 
				if ls_last_day = data then	 
					this.object.reg_mm.visible = true
				else
					this.object.reg_mm.visible = false
				end if
				
		end if

		CASE "brand"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			dw_head.accepttext()
			gs_brand = dw_head.getitemstring(1,'brand')

			select isnull(count(brand),0)
			into	:ll_b_cnt
			from tb_91100_m  with (nolock) 
			where shop_cd like '%' + substring(:gs_shop_cd_1,3,4)
					and brand = :gs_brand;	
					
			if ll_b_cnt = 0 then 
				messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
				dw_body.reset()
				return 0
			end if

			gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
			Trigger Event ue_retrieve()
		
end choose

end event

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.object.brand_t.visible = true
	dw_head.object.brand.visible = true
else
	dw_head.object.brand_t.visible = false
	dw_head.object.brand.visible = false
end if


end event

type ln_1 from w_com010_e`ln_1 within w_sh121_e
integer beginy = 336
integer endy = 336
end type

type ln_2 from w_com010_e`ln_2 within w_sh121_e
integer beginy = 340
integer endy = 340
end type

type dw_body from w_com010_e`dw_body within w_sh121_e
event type boolean ue_magin_set ( long as_row )
integer x = 1426
integer y = 352
integer width = 1413
integer height = 740
string dataobject = "d_sh121_d01"
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

type dw_print from w_com010_e`dw_print within w_sh121_e
integer x = 5
integer y = 296
end type

type dw_1 from datawindow within w_sh121_e
integer x = 5
integer y = 352
integer width = 1413
integer height = 740
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh121_d01"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_sh121_e
integer x = 5
integer y = 1096
integer width = 1413
integer height = 740
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh121_d01"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_3 from datawindow within w_sh121_e
event ue_insert ( )
event ue_keydown ( )
event ue_keydwon pbm_dwnkey
integer x = 1426
integer y = 1096
integer width = 1413
integer height = 740
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh121_d01"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_insert();dw_3.insertrow(0)
dw_3.setitem(dw_3.rowcount(),'gubn','4')
dw_3.setitem(dw_3.rowcount(),'yymmdd',is_yymmdd)
dw_3.setitem(dw_3.rowcount(),'shop_cd',gs_shop_cd)
dw_3.setitem(dw_3.rowcount(),'brand',gs_brand)
dw_3.setitem(dw_3.rowcount(),'shop_div',gs_shop_div)
dw_3.setitem(dw_3.rowcount(),'magam_yn','N')
dw_3.setitem(dw_3.rowcount(),'prot',0)

dw_3.SetItemStatus(dw_3.rowcount(), 0, Primary!, New!)
end event

event ue_keydwon;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)                                           */	
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
	CASE KeyDownArrow!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
		END IF
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

event buttonclicked;choose case dwo.name
	case "b_insert"
		trigger event ue_insert()
		
		this.setrow(this.rowcount())
		this.setcolumn("sale_type")
		this.setfocus()
	case "b_delete"
		this.DeleteRow (this.getrow())
		ib_changed = true
		cb_update.enabled = true
end choose

end event

event itemchanged;ib_changed = true
cb_update.enabled = true
end event

event editchanged;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)                                           */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true

end event

type st_1 from statictext within w_sh121_e
integer x = 503
integer y = 376
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
string text = "본   사(일계)"
boolean focusrectangle = false
end type

type st_2 from statictext within w_sh121_e
integer x = 503
integer y = 1104
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
string text = "본   사(월계)"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sh121_e
integer x = 1888
integer y = 372
integer width = 425
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
string text = "백화점Key(일계)"
boolean focusrectangle = false
end type

type st_4 from statictext within w_sh121_e
integer x = 1888
integer y = 1104
integer width = 425
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "백화점Key(월계)"
boolean focusrectangle = false
end type

type st_5 from statictext within w_sh121_e
integer x = 393
integer y = 64
integer width = 1394
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 판매금액은 마일리지가 차감된 금액입니다!"
boolean focusrectangle = false
end type

