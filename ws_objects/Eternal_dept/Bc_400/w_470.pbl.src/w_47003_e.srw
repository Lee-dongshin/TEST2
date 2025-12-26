$PBExportHeader$w_47003_e.srw
$PBExportComments$판매처리
forward
global type w_47003_e from w_com010_e
end type
type cb_wan from commandbutton within w_47003_e
end type
type st_1 from statictext within w_47003_e
end type
type cb_rt from commandbutton within w_47003_e
end type
end forward

global type w_47003_e from w_com010_e
integer width = 3675
integer height = 2276
cb_wan cb_wan
st_1 st_1
cb_rt cb_rt
end type
global w_47003_e w_47003_e

type variables
datawindowchild idw_proc_stat, idw_color
String is_order_ymd, is_shop_cd, is_order_no, is_order_name, is_order_mobile, is_proc_stat, is_fr_ymd, is_to_ymd, is_gubn
end variables

on w_47003_e.create
int iCurrent
call super::create
this.cb_wan=create cb_wan
this.st_1=create st_1
this.cb_rt=create cb_rt
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_wan
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_rt
end on

on w_47003_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_wan)
destroy(this.st_1)
destroy(this.cb_rt)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"주문일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"주문일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


is_shop_cd = dw_head.GetItemString(1, "shoP_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
 is_shop_cd = "%"
end if

is_order_no = dw_head.GetItemString(1, "order_no")
if IsNull(is_order_no) or Trim(is_order_no) = "" then
 is_order_no = "%"
end if

is_order_name = dw_head.GetItemString(1, "order_name")
if IsNull(is_order_no) or Trim(is_order_no) = "" then
 is_order_no = "%"
end if

is_order_mobile = dw_head.GetItemString(1, "order_mobile")
if IsNull(is_order_mobile) or Trim(is_order_mobile) = "" then
 is_order_mobile = "%"
end if

is_proc_stat = dw_head.GetItemString(1, "proc_stat")
if IsNull(is_proc_stat) or Trim(is_proc_stat) = "" then
   MessageBox(ls_title,"주문처리내역을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("proc_stat")
   return false
end if

is_gubn = dw_head.GetItemString(1, "gubn")

return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_shop_cd, is_order_no, is_order_name, is_order_mobile, is_proc_stat, is_gubn)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count
datetime ld_datetime
string ls_yymmdd, ls_ord_ymd, ls_shop_cd, ls_style, ls_chno, ls_color, ls_size, ls_brand, ls_sale_ymd, ls_sale_yn, ls_proc_stat, ls_ok
string ls_sale_no, ls_s_no, ls_s_shop_type
decimal  ldc_sale_price, ldc_mall_price
integer li_sale_qty

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


/*******************************************************/ 
/* 전표번호 동기화 처리, 중복키 오류 문제 사전 예방    */	
 DECLARE SP_sync_GET_OUTNO PROCEDURE FOR SP_sync_GET_OUTNO  
								
 execute SP_sync_GET_OUTNO;		
		 
 commit  USING SQLCA;		
/*******************************************************/ 
  
 

FOR i=1 TO ll_row_count

	dw_body.ScrollToRow(i)
	dw_body.selectrow(i,TRUE)	
	
	ls_yymmdd = dw_body.GetItemString(i, "yymmdd")
	ls_ord_ymd = dw_body.GetItemString(i, "ord_ymd")	
	ls_sale_yn = dw_body.GetItemString(i, "sale_yn")		
	ls_proc_stat = dw_body.GetItemString(i, "proc_stat")			
	ls_shop_cd = dw_body.GetItemString(i, "shoP_cd")	
	ls_style = dw_body.GetItemString(i, "style")
	ls_chno  = dw_body.GetItemString(i, "chno")
	ls_color = dw_body.GetItemString(i, "color")	
	ls_size  = dw_body.GetItemString(i, "size")		
	li_sale_qty   = dw_body.GetItemNumber(i, "qty")		
	ldc_mall_price   = dw_body.GetItemNumber(i, "sale_price")			
	ls_brand = MidA(ls_style, 1,1)
	
	if isnull(ls_sale_yn) or ls_sale_yn = "" then
		ls_sale_yn = "N"
	end if	
	
	if li_sale_qty <> 0 and ls_sale_yn = "Y" and ls_proc_stat =  "01" then	

	// DECLARE sp_47003_p01 PROCEDURE FOR sp_47003_p01  
	 DECLARE sp_47003_p02 PROCEDURE FOR sp_47003_p02  	 
			@yymmdd		=  :ls_yymmdd,
			@ordymd		=  :ls_ord_ymd,
			@shop_cd		=  :ls_shop_cd,
			@style		=  :ls_style,
			@chno			=  :ls_chno,
			@color		=	:ls_color,
			@size			=  :ls_size,
			@sale_qty	=  :li_sale_qty,
			@e_sale_price = :ldc_mall_price,
			@brand		=  :ls_brand,
			@reg_id		= 	:gs_user_id,
			@O_sale_ymd	=  :ls_sale_ymd OUT,
			@O_sale_price = :ldc_sale_price OUT,
			@O_sale_no	=	:ls_sale_no OUT,
			@O_no			=  :ls_s_no OUT,			
			@o_ok       =  :ls_ok	out,
			@o_shop_type  = :ls_s_shop_type	out;	

	 	 EXECUTE sp_47003_p02 ;
 		 fetch   sp_47003_p02  into :ls_sale_ymd, :ldc_sale_price, :ls_sale_no, :ls_s_no, :ls_ok, :ls_s_shop_type;
		 CLOSE   sp_47003_p02 ;


//		 EXECUTE sp_47003_p01 ;
// 		 fetch   sp_47003_p01  into :ls_sale_ymd, :ldc_sale_price, :ls_sale_no, :ls_s_no, :ls_ok, :ls_s_shop_type;
//		 CLOSE   sp_47003_p01 ;
//		
		IF SQLCA.SQLCODE = -1 or ls_ok ="No" THEN 
			rollback  USING SQLCA;				
			MessageBox("SQL오류", SQLCA.SqlErrText) 
			Return -1 
		ELSE
			commit  USING SQLCA;
			dw_body.setitem(i, "proc_stat", "02")
			dw_body.setitem(i, "erp_sale_price", ldc_sale_price)					
			dw_body.setitem(i, "sale_ymd", ls_sale_ymd)										
			dw_body.setitem(i, "sale_no", ls_sale_no)										
			dw_body.setitem(i, "s_no", ls_s_no)													
			dw_body.setitem(i, "s_shop_type", ls_s_shop_type)						
		 il_rows = 1 
		END IF 		
		
	end if
	
	dw_body.selectrow(i,false)	
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_47003_e","0")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm 
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
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
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

type cb_close from w_com010_e`cb_close within w_47003_e
end type

type cb_delete from w_com010_e`cb_delete within w_47003_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_47003_e
boolean visible = false
integer width = 603
string text = "미출고분완불등록(&A)"
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_47003_e
end type

type cb_update from w_com010_e`cb_update within w_47003_e
integer width = 384
string text = "판매처리(&S)"
end type

type cb_print from w_com010_e`cb_print within w_47003_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_47003_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_47003_e
end type

type cb_excel from w_com010_e`cb_excel within w_47003_e
end type

type dw_head from w_com010_e`dw_head within w_47003_e
string dataobject = "d_47003_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("proc_stat", idw_proc_stat)
idw_proc_stat.SetTransObject(SQLCA)
idw_proc_stat.Retrieve('043')
idw_proc_stat.InsertRow(1)
idw_proc_stat.SetItem(1, "inter_cd", '%')
idw_proc_stat.SetItem(1, "inter_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;string ls_brand, ls_year, ls_season
CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if LenA(data) <> 0 then 
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		else 
			dw_head.setitem(1, "shop_nm","")
		end if
			
END CHOOSE
end event

type ln_1 from w_com010_e`ln_1 within w_47003_e
end type

type ln_2 from w_com010_e`ln_2 within w_47003_e
end type

type dw_body from w_com010_e`dw_body within w_47003_e
string dataobject = "d_47003_D01"
end type

event dw_body::buttonclicked;call super::buttonclicked;Long i
String ls_yn, ls_proc_stat

If dwo.Name = 'cb_sale_yn' Then
	If dwo.Text = '대상선택' Then
		ls_yn = 'Y'
		dwo.Text = '대상제외'
	Else
		ls_yn = 'N'
		dwo.Text = '대상선택'
	End If
	
	For i = 1 To This.RowCount()
		ls_proc_stat = dw_body.getitemstring(i, "proc_stat")
		if ls_proc_stat = "01" then 
			This.SetItem(i, "sale_yn", ls_yn)
		end if
	Next

End If

end event

event dw_body::constructor;call super::constructor;datawindowchild ldw_proc_stat

This.GetChild("proc_stat", ldw_proc_stat)
ldw_proc_stat.SetTransObject(SQLCA)
ldw_proc_stat.Retrieve('043')


This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.retrieve('%')


end event

type dw_print from w_com010_e`dw_print within w_47003_e
end type

type cb_wan from commandbutton within w_47003_e
integer x = 416
integer y = 44
integer width = 466
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "미출고분완불등록"
end type

event clicked;integer Net

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox("알림!","등록일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox("알림!","등록일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
end if


Net = MessageBox("경고", "등록일자 기간동안 미출고분이 완불데이터로 등록됩니다. 계속하시겠습니까?", Exclamation!, OKCancel!, 2)

IF Net = 1 THEN 
	
	st_1.visible = true
	
		DECLARE sP_54015_p02 PROCEDURE FOR SP_54015_P02  
         @fr_ymd = :is_fr_ymd,   
         @to_ymd = :is_to_ymd  ;

	
		 EXECUTE SP_54015_P02 ;
		 
		IF SQLCA.SQLCODE = -1 THEN 
			rollback  USING SQLCA;				
			MessageBox("SQL오류", SQLCA.SqlErrText) 
			st_1.visible = false			
			Return -1 			
		ELSE
 		  MessageBox("알림", "작업이 완료되었습니다!")
			commit  USING SQLCA;
			st_1.visible = false			
		END IF 		
	

ELSE

  MessageBox("알림", "작업이 취소되었습니다!")

END IF
end event

type st_1 from statictext within w_47003_e
boolean visible = false
integer x = 1339
integer y = 68
integer width = 814
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "<-- 작업이 처리 중입니다!"
boolean focusrectangle = false
end type

type cb_rt from commandbutton within w_47003_e
boolean visible = false
integer x = 887
integer y = 44
integer width = 439
integer height = 92
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "미출고분RT의뢰"
end type

event clicked;integer Net

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox("알림!","등록일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox("알림!","등록일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
end if


Net = MessageBox("경고", "등록일자 기간동안 미출고RT 입력 대상이 등록됩니다. 계속하시겠습니까?", Exclamation!, OKCancel!, 2)

IF Net = 1 THEN 
	
	st_1.visible = true
	
		DECLARE sP_54015_p03 PROCEDURE FOR SP_54015_P03  
         @fr_ymd = :is_fr_ymd,   
         @to_ymd = :is_to_ymd  ;

	
		 EXECUTE SP_54015_P03 ;
		 
		IF SQLCA.SQLCODE = -1 THEN 
			rollback  USING SQLCA;				
			MessageBox("SQL오류", SQLCA.SqlErrText) 
			st_1.visible = false			
			Return -1 			
		ELSE
 		  MessageBox("알림", "작업이 완료되었습니다!")
			commit  USING SQLCA;
			st_1.visible = false			
		END IF 		
	

ELSE

  MessageBox("알림", "작업이 취소되었습니다!")

END IF
end event

