$PBExportHeader$w_sh125_e.srw
$PBExportComments$휴무계획서 등록
forward
global type w_sh125_e from w_com010_e
end type
type dw_1 from datawindow within w_sh125_e
end type
end forward

global type w_sh125_e from w_com010_e
integer width = 2985
integer height = 2092
long backcolor = 16777215
event ue_serch_sale_empnm ( string as_sm_gbn,  string as_sale_empnm )
dw_1 dw_1
end type
global w_sh125_e w_sh125_e

type variables
string is_yymm, is_sm_gbn, is_sale_empnm
end variables

event ue_serch_sale_empnm(string as_sm_gbn, string as_sale_empnm);if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if
	
	select top 1 sale_empnm 
	into :as_sale_empnm
	from tb_91106_h (nolock)
	where brand = :gs_brand
	and   shop_cd = :gs_shop_cd
	and   sm_gbn  = :as_sm_gbn
	order by yymm desc;
	
	dw_head.setitem(1,"sale_empnm",as_sale_empnm)

end event

on w_sh125_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_sh125_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

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

if MidA(gs_shop_cd,3,4) = '2000' or  MidA(gs_shop_cd,1,2) = 'NI' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_sale_empnm = dw_head.GetItemString(1, "sale_empnm")
//if IsNull(is_sale_empnm) or Trim(is_sale_empnm) = "" then
//   MessageBox(ls_title,"이름을 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("sale_empnm")
//   return false
//end if

is_sm_gbn = dw_head.GetItemString(1, "sm_gbn")

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
string ls_Flag
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if IsNull(is_sale_empnm) or Trim(is_sale_empnm) = "" then
   dw_1.reset()
	dw_body.reset()
   return 
end if

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(is_yymm)
il_rows = dw_1.retrieve(gs_brand, is_yymm, gs_shop_cd, is_sm_gbn, '000000', is_sale_empnm)
IF il_rows > 0 THEN
	ls_Flag = dw_1.getitemstring(1,"Flag")
	if ls_Flag = "New" then	dw_1.SetItemStatus(1, 0, Primary!, New!)
	dw_body.setredraw(false)
	for i = 1 to 31
		choose case dw_1.getitemstring(1,"dd_" + string(i))
			case "M"
				dw_body.modify("dd_" + string(i) + ".background.color = " + string(dw_body.object.b_gbn_m.background.color))
			case "J"
				dw_body.modify("dd_" + string(i) + ".background.color = " + string(dw_body.object.b_gbn_j.background.color))
			case "P"
				dw_body.modify("dd_" + string(i) + ".background.color = " + string(dw_body.object.b_gbn_p.background.color))
			case "O"
				dw_body.modify("dd_" + string(i) + ".background.color = " + string(dw_body.object.b_gbn_o.background.color))
			case "X"
				dw_body.modify("dd_" + string(i) + ".background.color = " + string(dw_body.object.b_gbn_x.background.color))
			case "Q"
				dw_body.modify("dd_" + string(i) + ".background.color = " + string(dw_body.object.b_gbn_q.background.color))				
			case else				
				dw_body.modify("dd_" + string(i) + ".background.color = " + string(81324524))
		end choose
	next	
	
	dw_body.setredraw(true)
   dw_1.SetFocus()
END IF



This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_1.Enabled = true
         dw_1.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_1.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_1.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_1.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(3)
END CHOOSE

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_1.RowCount()
IF dw_1.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_1.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_1.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_1.Setitem(i, "mod_id", gs_user_id)
      dw_1.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_1.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_1.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event open;call super::open;if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

trigger event ue_serch_sale_empnm('0',is_sale_empnm)

trigger event ue_retrieve()

dw_head.setcolumn("sale_empnm")

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long i, ll_cur_row

ll_cur_row = dw_1.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_1.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_1.DeleteRow (ll_cur_row)

for i = 1 to 31 
	dw_body.modify("dd_" + string(i) + ".background.color = " + string(dw_body.object.b_gbn_o.background.color))
next

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)



end event

type cb_close from w_com010_e`cb_close within w_sh125_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh125_e
end type

type cb_insert from w_com010_e`cb_insert within w_sh125_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh125_e
end type

type cb_update from w_com010_e`cb_update within w_sh125_e
end type

type cb_print from w_com010_e`cb_print within w_sh125_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh125_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh125_e
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh125_e
integer height = 172
string dataobject = "d_sh125_h01"
end type

event dw_head::itemchanged;call super::itemchanged;string ls_yymmdd, ls_sale_empnm
long ll_b_cnt

choose case dwo.name
	case "yymm"
		ls_yymmdd = data + "01"
		if not gf_datechk(ls_yymmdd) then 
			messagebox("오류","일자를 올바로 입력하세요..")
			return 1
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
		
	case "sm_gbn"		
			parent.trigger event ue_serch_sale_empnm(data,ls_sale_empnm)
			parent.trigger event ue_retrieve()
		
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

type ln_1 from w_com010_e`ln_1 within w_sh125_e
integer beginy = 364
integer endy = 364
end type

type ln_2 from w_com010_e`ln_2 within w_sh125_e
integer beginy = 368
integer endy = 368
end type

type dw_body from w_com010_e`dw_body within w_sh125_e
integer y = 380
integer height = 1460
string dataobject = "d_sh125_d02"
end type

event dw_body::buttonclicked;call super::buttonclicked;choose case dwo.name
	case "b_gbn_m"
		this.object.t_gbn.background.color = this.object.b_gbn_m.background.color
		this.object.t_gbn_cd.text = "M"
case "b_gbn_j"
		this.object.t_gbn.background.color = this.object.b_gbn_j.background.color
		this.object.t_gbn_cd.text = "J"
	case "b_gbn_p"
		this.object.t_gbn.background.color = this.object.b_gbn_p.background.color
		this.object.t_gbn_cd.text = "P"
	case "b_gbn_o"
		this.object.t_gbn.background.color = this.object.b_gbn_o.background.color
		this.object.t_gbn_cd.text = "O"
	case "b_gbn_x"
		this.object.t_gbn.background.color = this.object.b_gbn_x.background.color
		this.object.t_gbn_cd.text = "X"
	case "b_gbn_q"
		this.object.t_gbn.background.color = this.object.b_gbn_q.background.color
		this.object.t_gbn_cd.text = "Q"



end choose

end event

event dw_body::clicked;call super::clicked;
if not dw_head.Enabled and LeftA(string(dwo.name),2) = "dd" then
		this.modify(dwo.name + ".background.color = " + this.object.t_gbn.background.color)
		dw_1.setitem(1,dwo.name,string(this.object.t_gbn_cd.text))
		
		ib_changed = true
		cb_update.enabled = true

end if
	


end event

type dw_print from w_com010_e`dw_print within w_sh125_e
integer x = 933
integer y = 1404
end type

type dw_1 from datawindow within w_sh125_e
boolean visible = false
integer x = 1614
integer y = 1404
integer width = 539
integer height = 148
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh125_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;		ib_changed = true
		cb_update.enabled = true
end event

