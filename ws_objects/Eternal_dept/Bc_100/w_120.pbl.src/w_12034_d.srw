$PBExportHeader$w_12034_d.srw
$PBExportComments$품평회 투표결과
forward
global type w_12034_d from w_com020_d
end type
type dw_1 from datawindow within w_12034_d
end type
end forward

global type w_12034_d from w_com020_d
integer width = 3689
integer height = 2276
dw_1 dw_1
end type
global w_12034_d w_12034_d

type variables
string is_brand, is_yymmdd, is_shop_cd, is_voter, is_shop_nm
datawindowchild idw_brand, idw_yymmdd

end variables

on w_12034_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_12034_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
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
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")
is_voter = dw_head.GetItemString(1, "voter")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_yymmdd)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen;call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
//inv_resize.of_Register(dw_1, "ScaleToRight")
end event

type cb_close from w_com020_d`cb_close within w_12034_d
end type

type cb_delete from w_com020_d`cb_delete within w_12034_d
end type

type cb_insert from w_com020_d`cb_insert within w_12034_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_12034_d
end type

type cb_update from w_com020_d`cb_update within w_12034_d
end type

type cb_print from w_com020_d`cb_print within w_12034_d
end type

type cb_preview from w_com020_d`cb_preview within w_12034_d
end type

type gb_button from w_com020_d`gb_button within w_12034_d
end type

type cb_excel from w_com020_d`cb_excel within w_12034_d
end type

type dw_head from w_com020_d`dw_head within w_12034_d
integer y = 196
integer height = 208
string dataobject = "d_12034_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("yymmdd", idw_yymmdd)
idw_yymmdd.SetTransObject(SQLCA)
idw_yymmdd.Retrieve(gs_brand)
	
	
end event

event dw_head::itemchanged;call super::itemchanged;string ls_shop, ls_brand, ls_yymmdd, ls_cnt


choose case dwo.name
	case "yymmdd"
		ls_yymmdd = string(data)
		ls_brand = this.getitemstring(1,"brand")
		select count(distinct shop_cd + voter)
			into :ls_cnt
			from tb_31031_d (nolock)
			where sample_cd like :ls_brand +'%'
			and   yymmdd = :ls_yymmdd;
			
			this.object.t_cnt.text = ls_cnt
				
	case "brand"
		This.GetChild("yymmdd", idw_yymmdd)
		idw_yymmdd.SetTransObject(SQLCA)
		idw_yymmdd.Retrieve(string(data))
		
	case "shop_cd"
		ls_shop=string(data)
		select person_nm 
			into :ls_shop
		from tb_93010_m (nolock)
		where person_id = :ls_shop
		and   user_grp  = '3'
		and   status_yn = 'Y';
		
		this.setitem(1,"shop_nm",ls_shop)
		
	case "voter"
		ls_shop=string(data)
		select person_nm 
			into :ls_shop
		from tb_93010_m (nolock)
		where person_id = :ls_shop
		and   user_grp  = '1'
		and   status_yn = 'Y';
		
		this.setitem(1,"voter_nm",ls_shop)			
	case "gubn"
		if string(data) = "1" then 
			this.setitem(1,"shop_cd","직원")
		end if
end choose 
end event

type ln_1 from w_com020_d`ln_1 within w_12034_d
end type

type ln_2 from w_com020_d`ln_2 within w_12034_d
end type

type dw_list from w_com020_d`dw_list within w_12034_d
integer x = 14
integer y = 448
integer width = 946
integer height = 1588
string dataobject = "d_12034_l01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_yymmdd

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_yymmdd = This.GetItemString(row, 'yymmdd') /* DataWindow에 Key 항목을 가져온다 */
is_yymmdd = ls_yymmdd
is_shop_cd = This.GetItemString(row, 'shop_cd') /* DataWindow에 Key 항목을 가져온다 */
is_shop_nm = This.GetItemString(row, 'shop_nm') /* DataWindow에 Key 항목을 가져온다 */
is_voter = This.GetItemString(row, 'voter') /* DataWindow에 Key 항목을 가져온다 */



il_rows = dw_body.retrieve(is_brand, ls_yymmdd, is_shop_cd, is_voter)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_12034_d
integer x = 983
integer y = 448
integer width = 2624
integer height = 1588
string dataobject = "d_12034_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::buttonclicked;dw_1.reset()
dw_1.visible = true
dw_1.title = is_shop_nm
il_rows = dw_1.retrieve(is_brand, is_yymmdd, is_shop_cd, is_voter)
end event

type st_1 from w_com020_d`st_1 within w_12034_d
integer x = 965
integer y = 448
integer height = 1588
end type

type dw_print from w_com020_d`dw_print within w_12034_d
integer x = 1605
integer y = 592
end type

type dw_1 from datawindow within w_12034_d
boolean visible = false
integer x = 32
integer y = 544
integer width = 3470
integer height = 1764
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_12034_d02"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

