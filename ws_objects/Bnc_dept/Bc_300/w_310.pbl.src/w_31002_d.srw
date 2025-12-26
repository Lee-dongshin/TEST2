$PBExportHeader$w_31002_d.srw
$PBExportComments$STYLE별 내역서
forward
global type w_31002_d from w_com010_d
end type
type dw_mast from u_dw within w_31002_d
end type
end forward

global type w_31002_d from w_com010_d
dw_mast dw_mast
end type
global w_31002_d w_31002_d

type variables
String is_style_no, is_flag

end variables

on w_31002_d.create
int iCurrent
call super::create
this.dw_mast=create dw_mast
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mast
end on

on w_31002_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_mast)
end on

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(dw_mast, "ScaleToRight")
dw_mast.SetTransObject(SQLCA)
dw_mast.InsertRow(0)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style_no"				
			IF ai_div = 1 THEN 	
				IF gf_style_chk(LeftA(as_data, 8), MidA(as_data, 9, 1)) = True THEN
////				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
//					RETURN 0

					 if gs_brand <> "K" then	
						RETURN 0
					 else	
							if gs_brand <> MidA(as_data,1,1) then
								Return 1
							else 
								RETURN 0
							end if	
					 end if							
					
				END IF 
			END IF
			   gst_cd.ai_div          = ai_div
				gst_cd.window_title    = "STYLE 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = ""		//WHERE TB_11010_M.PART_FG IN ('1', '2', '3') 

			if gs_brand <> "K" then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" +  LeftA(as_data, 8) + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" +  LeftA(as_data, 8) + "%' and style like 'K%' "
				ELSE
					gst_cd.Item_where = "style like 'K%'"
				END IF
				
			end if	
				
				
//				IF Trim(as_data) <> "" THEN
//					gst_cd.Item_where = " STYLE LIKE '" + Left(as_data, 8) + "%' "
//				ELSE
//					gst_cd.Item_where = ""
//				END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("flag")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
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

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
Long ll_rows
Decimal ldc_ord_qty

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_mast.retrieve(is_style_no)

IF il_rows > 0 THEN
	ldc_ord_qty = dw_mast.GetItemDecimal(1, "ord_qty")
	ll_rows = dw_body.retrieve(is_style_no, is_flag, ldc_ord_qty)
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
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

is_style_no = dw_head.GetItemString(1, "style_no")
if IsNull(is_style_no) or Trim(is_style_no) = "" then
   MessageBox(ls_title,"STYLE 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no")
   return false
end if




if gs_brand = 'N' and (MidA(is_style_no,1,1) = 'O' or MidA(is_style_no,1,1) = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false
elseif gs_brand = 'O' and (MidA(is_style_no,1,1) = 'N' or MidA(is_style_no,1,1) = 'B' or MidA(is_style_no,1,1) = 'L' or MidA(is_style_no,1,1) = 'F' or MidA(is_style_no,1,1) = 'G' or MidA(is_style_no,1,1) = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false	
elseif gs_brand = 'B' and (MidA(is_style_no,1,1) = 'O' or MidA(is_style_no,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false		
elseif gs_brand = 'G' and (MidA(is_style_no,1,1) = 'O' or MidA(is_style_no,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false			
end if	


is_flag = dw_head.GetItemString(1, "flag")
if IsNull(is_flag) or Trim(is_flag) = "" then
	is_flag = '%'
end if

return true

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주) 지우정보                                               */	
/* 작성일      : 2002.01.09                                                  */	
/* 수정일      : 2002.01.09                                                  */
/*===========================================================================*/
Datetime ld_datetime
String   ls_modify, ls_datetime, ls_ord_ymd, ls_cust_cd, ls_cust_nm
String   ls_ord_qty, ls_make_price, ls_flag

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_flag = '1' Then
	ls_flag = '특수부자재'
Else
	ls_flag = '전체'
End If

ls_ord_ymd = Trim(dw_mast.GetItemString(1, "ord_ymd"))
If IsNull(ls_ord_ymd) or ls_ord_ymd = "" Then 
	ls_ord_ymd = ' '
Else
	ls_ord_ymd = String(ls_ord_ymd, '@@@@/@@/@@')
End If
ls_cust_cd = Trim(dw_mast.GetItemString(1, "cust_cd"))
If IsNull(ls_cust_cd) or ls_cust_cd = "" Then ls_cust_cd = ' '
ls_cust_nm = Trim(dw_mast.GetItemString(1, "cust_nm"))
If IsNull(ls_cust_nm) or ls_cust_nm = "" Then ls_cust_nm = ' '
ls_ord_qty = String(dw_mast.GetItemDecimal(1, "ord_qty"), '#,##0')
If IsNull(ls_ord_qty) or ls_ord_qty = "" Then ls_ord_qty = ' '
ls_make_price = String(dw_mast.GetItemDecimal(1, "make_price"), '#,##0')
If IsNull(ls_make_price) or ls_make_price = "" Then ls_make_price = ' '

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_style_no.Text = '" + is_style_no + "'" + &
            "t_flag.Text = '" + ls_flag + "'" + &
            "t_brand.Text = '" + dw_mast.GetItemString(1, "brand") + ' ' &
				                   + dw_mast.GetItemString(1, "brand_nm") + "'" + &
            "t_season.Text = '" + dw_mast.GetItemString(1, "year") + ' ' &
				                    + dw_mast.GetItemString(1, "season") + ' ' &
										  + dw_mast.GetItemString(1, "season_nm") + "'" + &
            "t_sojae.Text = '" + dw_mast.GetItemString(1, "sojae") + ' ' &
				                   + dw_mast.GetItemString(1, "sojae_nm") + "'" + &
            "t_item.Text = '" + dw_mast.GetItemString(1, "item") + ' ' &
				                  + dw_mast.GetItemString(1, "item_nm") + "'" + & 
            "t_out_seq.Text = '" + dw_mast.GetItemString(1, "out_seq") + "'" + &
            "t_dsgn_emp.Text = '" + dw_mast.GetItemString(1, "dsgn_emp") + ' ' &
				                      + dw_mast.GetItemString(1, "dsgn_empnm") + "'" + &
            "t_ord_ymd.Text = '" + ls_ord_ymd + "'" + &
            "t_ord_qty.Text = '" + ls_ord_qty + "'" + &
            "t_cust_cd.Text = '" + ls_cust_cd + ' ' + ls_cust_nm + "'" + &
            "t_make_price.Text = '" + ls_make_price + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_31002_d","0")
end event

event ue_preview();Decimal ldc_ord_qty

This.Trigger Event ue_title ()




/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

ldc_ord_qty = dw_mast.GetItemDecimal(1, "ord_qty")
il_rows = dw_print.retrieve(is_style_no, is_flag, ldc_ord_qty)


dw_print.inv_printpreview.of_SetZoom()

end event

type cb_close from w_com010_d`cb_close within w_31002_d
end type

type cb_delete from w_com010_d`cb_delete within w_31002_d
end type

type cb_insert from w_com010_d`cb_insert within w_31002_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_31002_d
end type

type cb_update from w_com010_d`cb_update within w_31002_d
end type

type cb_print from w_com010_d`cb_print within w_31002_d
end type

type cb_preview from w_com010_d`cb_preview within w_31002_d
end type

type gb_button from w_com010_d`gb_button within w_31002_d
end type

type cb_excel from w_com010_d`cb_excel within w_31002_d
end type

type dw_head from w_com010_d`dw_head within w_31002_d
integer height = 124
string dataobject = "d_31002_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_31002_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_31002_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_31002_d
integer y = 704
integer height = 1336
string dataobject = "d_31002_d02"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_31002_d
string dataobject = "d_31002_r01"
end type

type dw_mast from u_dw within w_31002_d
integer x = 5
integer y = 344
integer width = 3589
integer height = 348
integer taborder = 40
string dataobject = "d_31002_d01"
boolean vscrollbar = false
boolean livescroll = false
end type

