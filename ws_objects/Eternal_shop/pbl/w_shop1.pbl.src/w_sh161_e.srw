$PBExportHeader$w_sh161_e.srw
$PBExportComments$일별매출집계(직영)
forward
global type w_sh161_e from w_com010_e
end type
type dw_1 from datawindow within w_sh161_e
end type
end forward

global type w_sh161_e from w_com010_e
integer width = 2981
integer height = 2084
long backcolor = 16777215
dw_1 dw_1
end type
global w_sh161_e w_sh161_e

type variables
string is_brand, is_yymm, is_opt_view
Datawindowchild idw_brand
end variables

on w_sh161_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_sh161_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;string   ls_title

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


if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	is_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
else
	is_brand = dw_head.GetItemString(1, "brand")
	if IsNull(is_brand) or Trim(is_brand) = "" then
		MessageBox(ls_title,"() 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

is_yymm = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"입력월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_opt_view = dw_head.GetItemString(1, "opt_view")

if is_opt_view = "N" then 
	dw_1.visible = false
end if	

//if mid(gs_shop_cd,2,1) = 'G' or  mid(gs_shop_cd,2,1) = 'K' then 
if MidA(gs_shop_cd,2,1) = 'G' then
//   MessageBox(ls_title,"백화점,대리점은 사용하실 수 없습니다!")	
   MessageBox(ls_title,"백화점은 사용하실 수 없습니다!")
   return false
end if	

return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
long ll_rows

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	is_brand = dw_head.getitemstring(1,'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

if is_opt_view = "Y" then
	ll_rows = dw_1.retrieve(is_yymm, is_brand ,gs_shop_cd)
	if ll_rows >0 then 
		dw_1.visible = true
   else
	 	dw_1.visible = false
	end if	 
else	
	il_rows = dw_body.retrieve(is_yymm, is_brand ,gs_shop_cd)
	IF il_rows > 0 THEN
		dw_body.SetFocus()
	END IF
end if	

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
dw_1.SetTransObject(SQLCA)
end event

event type long ue_update();call super::ue_update;long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
//   IF idw_status = NewModified! or idw_status = DataModified! THEN		/* Modify Record */		
   IF idw_status = DataModified! THEN		/* Modify Record */		
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

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


ls_modify =	"t_shop_cd.Text = '" + gs_shop_cd + "'" + &
             "t_shop_nm.Text = '" + gs_shop_nm + "'" + &
             "t_fr_ymd.Text = '" + is_yymm + "'" 

dw_print.Modify(ls_modify)
end event

type cb_close from w_com010_e`cb_close within w_sh161_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh161_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh161_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh161_e
end type

type cb_update from w_com010_e`cb_update within w_sh161_e
end type

type cb_print from w_com010_e`cb_print within w_sh161_e
end type

type cb_preview from w_com010_e`cb_preview within w_sh161_e
end type

type gb_button from w_com010_e`gb_button within w_sh161_e
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh161_e
integer y = 156
integer height = 152
string dataobject = "d_sh161_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.retrieve('001')

end event

event dw_head::itemchanged;call super::itemchanged;long ll_b_cnt
CHOOSE CASE dwo.name

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
	
END CHOOSE
		
end event

type ln_1 from w_com010_e`ln_1 within w_sh161_e
integer beginy = 308
integer endy = 308
end type

type ln_2 from w_com010_e`ln_2 within w_sh161_e
integer beginy = 312
integer endy = 312
end type

type dw_body from w_com010_e`dw_body within w_sh161_e
integer y = 324
integer height = 1516
string dataobject = "d_sh161_d01"
end type

type dw_print from w_com010_e`dw_print within w_sh161_e
integer x = 55
integer y = 116
integer width = 1061
integer height = 304
string dataobject = "d_sh161_r01"
end type

type dw_1 from datawindow within w_sh161_e
boolean visible = false
integer y = 324
integer width = 2894
integer height = 1516
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh161_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;dw_1.visible = false
end event

