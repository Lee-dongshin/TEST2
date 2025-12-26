$PBExportHeader$w_sh131_e.srw
$PBExportComments$특수부자재 요청등록
forward
global type w_sh131_e from w_com010_e
end type
end forward

global type w_sh131_e from w_com010_e
integer width = 2949
end type
global w_sh131_e w_sh131_e

type variables
string is_brand, is_yymmdd, is_items, is_shop_div, is_shop_grp, is_area, is_emp_no, is_shop_cd

datawindowchild  idw_brand, idw_items, idw_shop_div, idw_shop_grp, idw_area, idw_person_id, idw_color


end variables

on w_sh131_e.create
call super::create
end on

on w_sh131_e.destroy
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

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

gs_brand = dw_head.GetItemString(1, "brand")
if IsNull(gs_brand) or Trim(gs_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
is_items = dw_head.GetItemString(1, "items")
is_shop_div = dw_head.GetItemString(1, "shop_div")
is_shop_grp = dw_head.GetItemString(1, "shop_grp")
is_area = dw_head.GetItemString(1, "area")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")
is_emp_no = dw_head.GetItemString(1, "emp_no")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
int i
string ls_flag, ls_style
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_brand = dw_head.getitemstring(1,'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(gs_brand, is_yymmdd, gs_shop_cd)
IF il_rows > 0 THEN							
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_yymmdd, ls_mat_cd, ls_mat_nm, ls_style, ls_chno, ls_color, ls_color_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd_body"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_body.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + is_brand + "' and Shop_Stat = '00' and shop_div in ('G','K') "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_body.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source		
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + is_brand + "' and Shop_Stat = '00' and shop_div in ('G','K') "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where   = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where   = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
	CASE "style"	
//		   if len(as_data) >= 8  then
//					select 
//						convert(char(8),getdate(),112) 	as yymmdd,
//						a.mat_cd,
//						dbo.sf_mat_nm(a.mat_cd)	as mat_nm,
//						style, 
//						chno,
//						color,
//						dbo.sf_color_nm(color,'e')	as color_nm
//						into :ls_yymmdd, :ls_mat_cd, :ls_mat_nm, :ls_style, :ls_chno, :ls_color, :ls_color_nm
//					from tb_12025_d a(nolock), tb_21000_m b(nolock)
//					where a.brand = :gs_brand
//					and   a.style = :as_data
//					and   a.chno  like isnull(substring(:as_data,9,1),'') + '%'
//					and   a.mat_cd = b.mat_cd
//					and   a.mat_gubn = '2'
//					and   b.mat_type = '3';
//				
//					if not isnull(ls_mat_cd) then 
//						dw_body.SetItem(al_row, "yymmdd"   , ls_yymmdd)				
//						dw_body.SetItem(al_row, "mat_cd"   , ls_mat_cd)
//						dw_body.SetItem(al_row, "mat_nm"   , ls_mat_nm)
//						dw_body.SetItem(al_row, "style"    , ls_style)
//						dw_body.SetItem(al_row, "chno"     , ls_chno)
//						dw_body.SetItem(al_row, "color"    , ls_color)
//						dw_body.SetItem(al_row, "color_nm" , ls_color_nm)	
//
//						dw_body.GetChild("color", idw_color)
//						idw_color.SetTransObject(SQLCA)
//						idw_color.Retrieve(ls_style, ls_chno)
//						
//						return 1
//					end if					
//			end if
//		
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "특수부자재 검색" 
			gst_cd.datawindow_nm   = "d_sh131_ddw" 
			gst_cd.default_where   = " where a.brand = '" + gs_brand + "'" + &
											 " and   a.mat_cd = b.mat_cd " + &
											 " and   a.mat_gubn = '2' " + &
											 " and   b.mat_type = '3' "
											 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " style+chno LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				
				dw_body.SetItem(al_row, "yymmdd", lds_Source.GetItemString(1,"yymmdd"))
				
				dw_body.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
				dw_body.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))
				dw_body.SetItem(al_row, "style" , lds_Source.GetItemString(1,"style" ))
				dw_body.SetItem(al_row, "chno"  , lds_Source.GetItemString(1,"chno"  ))
				dw_body.SetItem(al_row, "color" , lds_Source.GetItemString(1,"color" ))
				dw_body.SetItem(al_row, "color_nm" , lds_Source.GetItemString(1,"color_nm" ))
				/* 다음컬럼으로 이동 */

				dw_body.GetChild("color", idw_color)
				idw_color.SetTransObject(SQLCA)
				idw_color.Retrieve(lds_Source.GetItemString(1,"style" ), lds_Source.GetItemString(1,"chno"  ))
		

				
				ib_itemchanged = False 
				lb_check = TRUE 

			else

				return 0
			END IF
			Destroy  lds_Source
			
END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_brand, ls_yymmdd, ls_mat_cd, ls_style, ls_chno, ls_color, ls_size, ls_out_gbn
long i, ll_row_count, ll_qty, ll_rqst_qty
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	ls_mat_cd  = dw_body.getitemstring(i,"mat_cd")
	ls_out_gbn = dw_body.getitemstring(i,"out_gbn")
	
	if ls_mat_cd = '' or isnull(ls_mat_cd) then dw_body.DeleteRow (i)

	ls_yymmdd = dw_body.getitemstring(i,"yymmdd")
	ls_style  = dw_body.getitemstring(i,"style")
	ls_chno   = dw_body.getitemstring(i,"chno")
	ls_color  = dw_body.getitemstring(i,"color")
	ls_size   = dw_body.getitemstring(i,"size")	
	ll_rqst_qty = dw_body.getitemNumber(i,"qty")	
	
	if isnull(ls_out_gbn) then
		messagebox("경고!" , "요청구분을 입력하세요.!")
		dw_body.SetRow(i)  
		dw_body.SetColumn("out_gbn")
		return -1
	end if
		
	
	IF idw_status = NewModified! or idw_status = DataModified! THEN	
		
		select sum(out_qty) // - sum(rtrn_qty)
		into :ll_qty
		from tb_44010_s  (nolock)
		where yymmdd >= convert(char(08), dateadd(day, -3, :ls_yymmdd),112)
		and   yymmdd <= :ls_yymmdd
		and shop_cd = :gs_shop_cd
		and style = :ls_style
		and chno  = :ls_chno
		and color = :ls_color
		and size  = :ls_size;
		
	//	messagebox("ll_qty", string(ll_qty,'0000'))
	//	messagebox("ll_rqst_qty", string(ll_rqst_qty,'0000'))	
		
		if isnull(ll_qty) then 
			ll_qty = 0
		end if
		
		if ll_qty < ll_rqst_qty then
			messagebox("경고!" , "요청일 기준 3일전 출고수량 보다 요청수량이 많습니다!")
			dw_body.SetRow(i)  
			dw_body.SetColumn("qty")
			return -1
		end if
		
	end if
	
	
	
	
   IF idw_status = NewModified! THEN				/* New Record */	
		dw_body.Setitem(i, "brand", gs_brand)
		dw_body.Setitem(i, "shop_cd", gs_shop_cd)		
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

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event open;call super::open;if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if	

trigger event ue_retrieve()
end event

type cb_close from w_com010_e`cb_close within w_sh131_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh131_e
end type

type cb_insert from w_com010_e`cb_insert within w_sh131_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh131_e
end type

type cb_update from w_com010_e`cb_update within w_sh131_e
end type

type cb_print from w_com010_e`cb_print within w_sh131_e
end type

type cb_preview from w_com010_e`cb_preview within w_sh131_e
end type

type gb_button from w_com010_e`gb_button within w_sh131_e
end type

type dw_head from w_com010_e`dw_head within w_sh131_e
integer height = 144
string dataobject = "d_sh131_h01"
end type

event dw_head::constructor;call super::constructor;string ls_filter, ls_null, ls_modify

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

if MidA(gs_shop_cd_1,1,2) <> 'XX' then
	ls_modify =	'brand.protect = 1'
	dw_head.Modify(ls_modify)
end if
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long ll_b_cnt

CHOOSE CASE dwo.name
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

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

type ln_1 from w_com010_e`ln_1 within w_sh131_e
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com010_e`ln_2 within w_sh131_e
integer beginy = 352
integer endy = 352
end type

type dw_body from w_com010_e`dw_body within w_sh131_e
integer y = 372
integer width = 2862
integer height = 1412
string dataobject = "d_sh131_d01"
boolean hscrollbar = true
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
//ib_changed = true
//cb_update.enabled = true
//cb_print.enabled = false
//cb_preview.enabled = false
//cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "colunm1" 
    IF data = 'A' THEN
	      /*action*/
    END IF
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_body::constructor;call super::constructor;This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.insertRow(0)


end event

type dw_print from w_com010_e`dw_print within w_sh131_e
integer x = 1906
integer y = 264
end type

