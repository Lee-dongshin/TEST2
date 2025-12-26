$PBExportHeader$w_42008_e.srw
$PBExportComments$수주출고처리
forward
global type w_42008_e from w_com020_e
end type
type cb_move from cb_update within w_42008_e
end type
end forward

global type w_42008_e from w_com020_e
integer width = 3698
integer height = 2284
cb_move cb_move
end type
global w_42008_e w_42008_e

type variables
String  is_house,   is_brand,     is_yymmdd, is_out_no
String  is_shop_cd, is_shop_type, is_fr_ymd, is_to_ymd 
DataWindowchild  idw_brand
end variables

on w_42008_e.create
int iCurrent
call super::create
this.cb_move=create cb_move
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_move
end on

on w_42008_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_move)
end on

event open;call super::open;dw_head.Setitem(1, "shop_type", '1')
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
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
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV  IN ('G', 'K', 'T')  " + &
											 "  AND BRAND = '" + ls_brand + "'"
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
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
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

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.16                                                  */	
/* 수정일      : 2002.03.16                                                  */
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

is_house = dw_head.GetItemString(1, "house")
if IsNull(is_house) or Trim(is_house) = "" then
   MessageBox(ls_title,"창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

IF DaysAfter(dw_head.GetItemDate(1, "fr_ymd"), dw_head.GetItemDate(1, "to_ymd")) > 90 THEN
   MessageBox(ls_title,"3개월 이상 처리할수 없습니다 !")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
END IF

is_fr_ymd = String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
is_to_ymd = String(dw_head.GetItemDate(1, "to_ymd"), "yyyymmdd")
IF is_fr_ymd > is_to_ymd THEN 
   MessageBox(ls_title,"TO 일자가 작습니다 !")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
END IF

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */ 
/* 작성일      : 2002.03.16                                                  */
/* 수정일      : 2002.03.16                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand,  is_shop_cd, is_shop_type, &
                           is_fr_ymd, is_to_ymd,  is_house) 
dw_body.Reset()
IF il_rows > 0 THEN
	cb_move.enabled = true
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;
CHOOSE CASE ai_cb_div
   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then 
			if dw_body.Object.accept_yn[1] = 'N' then
            cb_update.enabled = true
            cb_print.enabled  = false
			else
            cb_update.enabled = false
            cb_print.enabled = true
			end if
		else 
         cb_update.enabled = false
         cb_print.enabled  = false
      end if
END CHOOSE

end event

event ue_update;call super::ue_update;
return il_rows

end event

event ue_print;
datetime ld_datetime
string   ls_yymmdd, ls_out_no, ls_shop_cd, ls_shop_type, ls_brand, ls_accept_yn
long     i, ll_row_count, ll_row,ll_cnt, II, JJ, KK, ll_ok, ll_rtrn

ll_row_count = dw_list.RowCount()

 dw_list.AcceptText() 

  FOR i=1 TO ll_row_count
		
		ls_accept_yn	= dw_list.GetitemString(i, "accept_yn")
		ls_yymmdd   	= dw_list.GetItemString(i, "yymmdd")
		ls_out_no   	= dw_list.GetItemString(i, "out_no")				
		ls_shop_cd  	= dw_list.GetItemString(i, "shop_cd")
		ls_shop_type	= dw_list.Getitemstring(i, "shop_type")	
		ls_brand = is_brand

						
		if ls_accept_yn = "Y" then
			dw_print.Retrieve(is_brand, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, '1')
		  IF dw_print.RowCount() > 0 Then
		     il_rows = dw_print.Print()
		  END IF
   	end if  

  next		


This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42008_e","0")
end event

type cb_close from w_com020_e`cb_close within w_42008_e
end type

type cb_delete from w_com020_e`cb_delete within w_42008_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_42008_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_42008_e
end type

type cb_update from w_com020_e`cb_update within w_42008_e
boolean visible = false
end type

type cb_print from w_com020_e`cb_print within w_42008_e
integer width = 549
string text = "거래명세서인쇄(&P)"
end type

type cb_preview from w_com020_e`cb_preview within w_42008_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_42008_e
end type

type cb_excel from w_com020_e`cb_excel within w_42008_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_42008_e
string dataobject = "d_42008_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("house", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.16                                                  */	
/* 수정일      : 2002.03.16                                                  */
/*===========================================================================*/
String ls_yymmdd

CHOOSE CASE dwo.name
	CASE "yymmdd"      
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_42008_e
integer beginy = 412
integer endy = 412
end type

type ln_2 from w_com020_e`ln_2 within w_42008_e
integer beginy = 416
integer endy = 416
end type

type dw_list from w_com020_e`dw_list within w_42008_e
integer x = 0
integer y = 428
integer width = 1737
integer height = 1620
string dataobject = "d_42008_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_list::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('911')

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')


end event

event dw_list::doubleclicked;call super::doubleclicked;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.16                                                  */	
/* 수정일      : 2002.03.16                                                  */
/*===========================================================================*/
String  ls_yymmdd, ls_shop_type, ls_sale_type, ls_shop_cd, ls_out_no
Decimal ldc_margin_rate

IF row <= 0 THEN Return

//IF ib_changed THEN 
//  	CHOOSE CASE gf_update_yn(Parent.title)
//		CASE 1
//			IF Parent.Trigger Event ue_update() < 1 THEN
//				RETURN 1
//			END IF		
//		CASE 3
//			RETURN 1
//	END CHOOSE
//END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_yymmdd       = This.GetitemString(row, "yymmdd")  
ls_out_no       = This.GetitemString(row, "out_no")  
ls_shop_cd      = This.GetitemString(row, "shop_cd")  
ls_shop_type    = This.GetitemString(row, "shop_type")

il_rows = dw_body.retrieve(is_brand, ls_shop_cd, ls_yymmdd, ls_shop_type, ls_out_no)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

event dw_list::buttonclicked;call super::buttonclicked;string ls_yymmdd, ls_out_no, ls_shop_cd, ls_modify
Integer li_deal_seq, li_work_no, li_rtrn
long    ll_row, II, JJ, KK, ll_ok

CHOOSE CASE dwo.name
	CASE "cb_select"	
	
		ll_row = dw_list.rowcount()
		if dw_list.object.cb_select.text = "선택"  then 
			for ii = 1 to ll_row
				dw_list.setitem(ii , "accept_yn", "Y")
			next	

	   ls_modify = 'cb_select.text= "해제"' 
		dw_list.Modify(ls_modify)
			
      else
			
			for ii = 1 to ll_row
				dw_list.setitem(ii , "accept_yn", "N")				
			next	
	   ls_modify = 'cb_select.text= "선택"'
		dw_list.Modify(ls_modify)
		end if	
			
END CHOOSE
	
	
	

end event

type dw_body from w_com020_e`dw_body within w_42008_e
integer x = 1755
integer y = 428
integer width = 1856
integer height = 1620
string dataobject = "d_42008_d02"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type st_1 from w_com020_e`st_1 within w_42008_e
integer x = 1737
integer y = 424
integer height = 1620
end type

type dw_print from w_com020_e`dw_print within w_42008_e
string dataobject = "d_com420_suju"
end type

type cb_move from cb_update within w_42008_e
boolean visible = true
integer width = 384
integer taborder = 10
string text = "출고처리(&S)"
end type

event clicked;call super::clicked;
datetime ld_datetime
string   ls_yymmdd, ls_out_no, ls_shop_cd, ls_shop_type, ls_brand, ls_accept_yn
long     i, ll_row_count, ll_row,ll_cnt, II, JJ, KK, ll_ok, ll_rtrn

ll_row_count = dw_list.RowCount()
IF dw_list.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ll_rtrn = messagebox("경고!", "출고확정이되면 전표를 수정할 수 없습니다! 작업을진행 하시겠습니까?",Question!,OKCancel! )
ii = 0
if ll_rtrn = 1 then

  FOR i=1 TO ll_row_count
		
		ls_accept_yn	= dw_list.GetitemString(i, "accept_yn")
		ls_yymmdd   	= dw_list.GetItemString(i, "yymmdd")
		ls_out_no   	= dw_list.GetItemString(i, "out_no")				
		ls_shop_cd  	= dw_list.GetItemString(i, "shop_cd")
		ls_shop_type	= dw_list.Getitemstring(i, "shop_type")	
		ls_brand = is_brand

						
		if ls_accept_yn = "Y" then

					// 전표의 확정전표의 유무를 확인한다.						
			      select count(*) 
					into :ll_cnt
					from tb_42020_suju with (nolock)
					where brand  		= :is_brand
					and   yymmdd 		= :ls_yymmdd
					and   shop_cd 		= :ls_shop_cd
					and   shop_type 	= :ls_shop_type
					and   out_no		= :ls_out_no;

				if ll_cnt > 0 then

					 ii = ii + 1		
					 
					  DECLARE sp_42031 PROCEDURE FOR sp_42031  
						@yymmdd 		= :ls_yymmdd,   
						@out_no 		= :ls_out_no,   
						@shop_cd 	= :ls_shop_cd,   
						@shop_type 	= :ls_shop_type,   
						@brand 		= :is_brand  ;

				    execute sp_42031;	
					 
					 commit USING SQLCA; 
													
				end if
		end if		

  NEXT				

else		
		messagebox("알림!" , "작업이 취소 되었습니다!")
end if
	
messagebox("알림!" ,  string(ii) + "건의 전표가 출고처리되었습니다!")	
parent.Trigger Event ue_retrieve()
parent.Trigger Event ue_button(3, il_rows)
parent.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

