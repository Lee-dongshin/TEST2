$PBExportHeader$w_23013_d.srw
$PBExportComments$계산서회계처리
forward
global type w_23013_d from w_com020_e
end type
type dw_detail from datawindow within w_23013_d
end type
type st_2 from statictext within w_23013_d
end type
end forward

global type w_23013_d from w_com020_e
integer width = 3657
event type long ue_detail ( )
event ue_detail_set ( )
event ue_magam_chk ( )
event type boolean ue_magam_check ( )
dw_detail dw_detail
st_2 st_2
end type
global w_23013_d w_23013_d

type variables
string is_brand, is_bill_type, is_bill_date, is_cust_cd 



end variables

forward prototypes
public function integer wf_resizepanels ()
end prototypes

public function integer wf_resizepanels ();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.26                                                  */
/*===========================================================================*/
// DataWindow 위치 및 크기 변경
Long		ll_Width

ll_Width = idrg_Vertical[2].X + idrg_Vertical[2].Width - st_1.X - ii_BarThickness

idrg_Vertical[1].Resize (st_1.X - idrg_Vertical[1].X, idrg_Vertical[1].Height)

idrg_Vertical[2].Move (st_1.X + ii_BarThickness, idrg_Vertical[2].Y)
idrg_Vertical[2].Resize (ll_Width, idrg_Vertical[2].Height)




//ll_Width = idrg_Vertical2[1].X + idrg_Vertical2[1].Width - st_1.X - ii_BarThickness
//
//idrg_Vertical2[1].Move (st_1.X + ii_BarThickness, idrg_Vertical2[1].Y)
//idrg_Vertical2[1].Resize (ll_Width, idrg_Vertical2[1].Height)
//

Return 1

end function

on w_23013_d.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.st_2
end on

on w_23013_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.st_2)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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

is_brand     = dw_head.GetItemString(1, "brand")
is_bill_type = dw_head.GetItemString(1, "bill_type")
is_bill_date = dw_head.GetItemString(1, "bill_date")
is_cust_cd   = dw_head.GetItemString(1, "cust_cd")


if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

if LenA(is_bill_date) < 6 then
	MessageBox(ls_title,"계산서 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("bill_date")
   return false
end if
return true

end event

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */

inv_resize.of_Register(cb_close, "FixedToRight")




idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_detail

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_head.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
//this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */

dw_head.insertrow(0)

datetime ld_datetime



//idrg_Vertical2[1] = dw_detail



end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      :                                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
String     ls_claim_cust_nm 
Boolean    lb_check 
DataStore  lds_Source

is_brand = dw_head.getitemstring(1,'brand')
CHOOSE CASE as_column
	CASE "cust_cd"				
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				elseIF gf_cust_nm(as_data, 'S', ls_claim_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_claim_cust_nm)
					RETURN 0
				END IF 
			END IF
			IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처 코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			gst_cd.default_where   = "Where change_gubn = '00' "      + &
			                         "  and cust_code between '5000' and '8999'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (custcode LIKE '%" + as_data + "%' or cust_name like '%" + as_data + "%')" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_name"))
				/* 다음컬럼으로 이동 */			
		
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_23013_d","0")
end event

type cb_close from w_com020_e`cb_close within w_23013_d
integer taborder = 120
end type

type cb_delete from w_com020_e`cb_delete within w_23013_d
boolean visible = false
integer taborder = 70
boolean enabled = true
end type

type cb_insert from w_com020_e`cb_insert within w_23013_d
boolean visible = false
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_23013_d
boolean visible = false
end type

type cb_update from w_com020_e`cb_update within w_23013_d
integer x = 1248
integer y = 1168
integer width = 736
integer taborder = 110
integer weight = 700
boolean enabled = true
string text = "회계 데이타로 이전"
end type

event cb_update::clicked;if messagebox("확인","실행하시겠습니다...?",Exclamation!,YesNoCancel!,1 ) <> 1 then return

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

messagebox("is_brand",is_brand)
messagebox("is_bill_date",is_bill_date)
messagebox("is_bill_type",is_bill_type)
messagebox("is_cust_cd",is_cust_cd)

 DECLARE sp_make_bill_data PROCEDURE FOR sp_make_bill_data  
			@brand     = :is_brand,   
			@bill_date = :is_bill_date,   
			@pa_bill_type = :is_bill_type,   
			@cust_cd   = :is_cust_cd  ;
			
execute sp_make_bill_data;	


commit  USING SQLCA;



messagebox("확인","정상처리되었슴니다...")
	
	
end event

type cb_print from w_com020_e`cb_print within w_23013_d
boolean visible = false
integer x = 384
integer taborder = 80
end type

type cb_preview from w_com020_e`cb_preview within w_23013_d
boolean visible = false
integer x = 1422
integer taborder = 90
end type

type gb_button from w_com020_e`gb_button within w_23013_d
end type

type cb_excel from w_com020_e`cb_excel within w_23013_d
boolean visible = false
integer x = 1765
integer taborder = 100
end type

type dw_head from w_com020_e`dw_head within w_23013_d
event type long ue_detail ( )
integer y = 160
integer height = 1848
string dataobject = "d_23013_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild ldw_child, ldw_brand

this.getchild("brand",ldw_brand)
ldw_brand.settransobject(sqlca)
ldw_brand.retrieve('001')

this.getchild("bill_type",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('008')
ldw_child.insertrow(1)
ldw_child.setitem(1,"inter_cd","%")
ldw_child.setitem(1,"inter_nm","전체")

end event

event dw_head::itemchanged;call super::itemchanged;
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
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_23013_d
boolean visible = false
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com020_e`ln_2 within w_23013_d
boolean visible = false
integer beginy = 332
integer endy = 332
end type

type dw_list from w_com020_e`dw_list within w_23013_d
boolean visible = false
integer x = 5
integer y = 888
integer width = 754
integer height = 1148
end type

type dw_body from w_com020_e`dw_body within w_23013_d
event type long ue_detail ( )
boolean visible = false
integer x = 5
integer y = 348
integer width = 3593
integer height = 524
boolean vscrollbar = false
end type

type st_1 from w_com020_e`st_1 within w_23013_d
boolean visible = false
integer x = 763
integer y = 896
integer height = 1140
end type

type dw_print from w_com020_e`dw_print within w_23013_d
integer x = 5
integer y = 724
end type

type dw_detail from datawindow within w_23013_d
event ue_refresh ( long row,  string iwol_yn )
boolean visible = false
integer x = 782
integer y = 888
integer width = 2811
integer height = 1148
integer taborder = 60
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_23013_d
integer x = 581
integer y = 1376
integer width = 2098
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 81324524
string text = ">>(((⊙>.....자동분개처리는 (구)자재생산 프로그램을 이용하세요.....<⊙)))<<"
boolean focusrectangle = false
end type

