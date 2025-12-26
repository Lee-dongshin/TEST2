$PBExportHeader$w_sh117_e.srw
$PBExportComments$완불지시승인
forward
global type w_sh117_e from w_com010_e
end type
type st_1 from statictext within w_sh117_e
end type
end forward

global type w_sh117_e from w_com010_e
integer width = 2949
integer height = 2032
st_1 st_1
end type
global w_sh117_e w_sh117_e

type variables
String is_yymmdd
end variables

on w_sh117_e.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_sh117_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event pfc_postopen();call super::pfc_postopen;if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

This.Trigger Event ue_retrieve()
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;is_yymmdd = String(dw_head.GetitemDate(1, "yymmdd"), "yyyymmdd")

if MidA(gs_shop_cd,3,4) = '2000' or MidA(gs_shop_cd,1,1) = 'N' then
	messagebox("주의!", '온앤온매장, 행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox("주의!","브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

Return True

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.23                                                  */	
/* 수정일      : 2002.04.23                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(gs_shop_cd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_1, "ScaleToRight")

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.23                                                  */	
/* 수정일      : 2002.04.23                                                  */
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
   IF idw_status = DataModified! THEN		/* Modify Record */
	   if dw_body.getitemstring(i, "accept_fg") = "Y" then
	      dw_body.Setitem(i, "accept_ymd", string(ld_datetime,"yyyymmdd"))
		else
	      dw_body.Setitem(i, "accept_ymd", "")
		end if	
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
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

type cb_close from w_com010_e`cb_close within w_sh117_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh117_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh117_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh117_e
boolean visible = false
end type

type cb_update from w_com010_e`cb_update within w_sh117_e
end type

type cb_print from w_com010_e`cb_print within w_sh117_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh117_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh117_e
end type

type dw_head from w_com010_e`dw_head within w_sh117_e
integer height = 188
string dataobject = "d_sh117_h01"
end type

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

type ln_1 from w_com010_e`ln_1 within w_sh117_e
integer beginy = 360
integer endy = 360
end type

type ln_2 from w_com010_e`ln_2 within w_sh117_e
integer beginy = 364
integer endy = 364
end type

type dw_body from w_com010_e`dw_body within w_sh117_e
integer y = 372
integer width = 2857
integer height = 1416
string dataobject = "d_sh117_d01"
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.23                                                  */	
/* 수정일      : 2002.04.23                                                  */
/*===========================================================================*/
st_1.Text = "<- 체크 반드시 저장버튼을 누르세요" 


CHOOSE CASE dwo.name
	CASE "accept_fg" 
    IF data = 'Y' THEN 
		 This.Setitem(row, "accept_qty", This.GetitemNumber(row, "rqst_qty"))
	 ELSE
		 This.Setitem(row, "accept_qty", 0)
    END IF
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_sh117_e
end type

type st_1 from statictext within w_sh117_e
integer x = 411
integer y = 60
integer width = 1979
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean focusrectangle = false
end type

