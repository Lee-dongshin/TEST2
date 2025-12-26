$PBExportHeader$w_42009_d.srw
$PBExportComments$거래명세서
forward
global type w_42009_d from w_com020_d
end type
type cbx_a4 from checkbox within w_42009_d
end type
type cb_print1 from commandbutton within w_42009_d
end type
end forward

global type w_42009_d from w_com020_d
event ue_print1 ( )
cbx_a4 cbx_a4
cb_print1 cb_print1
end type
global w_42009_d w_42009_d

type variables
DataWindowChild idw_brand, idw_house_cd, idw_shop_type, idw_jup_gubn, idw_out_type

String is_brand, is_yymmdd, is_shop_cd, is_house_cd, is_shop_type, is_jup_gubn
String is_out_type, is_gubun, is_out_no

end variables

event ue_print1();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long ll_row_count, i, ll_rows, j
string ls_print_gubn
String ls_shop_type, ls_out_no, ls_jup_name, ls_modify, ls_Error,ls_print, ls_shop_cd

ll_row_count = dw_list.RowCount()

ls_print_gubn = dw_head.GetitemString(1, "print_gubn")

IF ls_print_gubn = "N" THEN
	dw_print.DataObject = 'd_com420_A4'
	dw_print.SetTransObject(SQLCA)
ELSE
	dw_print.DataObject = 'd_com420_tag_a4'
	dw_print.SetTransObject(SQLCA)
END IF


if cbx_a4.checked then 		
			ls_jup_name = "(매 장 용)"			

			FOR i = 1 TO ll_row_count
				IF dw_list.GetItemString(i, 'check_print') = 'Y' THEN
					is_shop_cd = dw_list.GetItemString(i, 'shop_cd')
					is_out_no  = dw_list.GetItemString(i, 'out_no' )
					is_out_no  = dw_list.GetItemString(i, 'shop_type' )					
					ll_rows = dw_print.retrieve(is_brand, is_yymmdd, is_shop_cd, is_shop_type, is_out_no, is_gubun)
			
					ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"
					ls_Error = dw_print.Modify(ls_modify)
						IF (ls_Error <> "") THEN 
							MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
						END IF				
					IF ll_rows > 0 Then il_rows = dw_print.Print()
				END IF
			NEXT

else			
		FOR i = 1 TO ll_row_count
			IF dw_list.GetItemString(i, 'check_print') = 'Y' THEN
				is_shop_cd = dw_list.GetItemString(i, 'shop_cd')
				is_out_no  = dw_list.GetItemString(i, 'out_no' )
				
				for j = 1 to 3	
					if j = 1 then 
						ls_jup_name = "(거 래 처 용)"			
					elseif j = 2 then
						ls_jup_name = "(매 장 용)"			
					else
						ls_jup_name = "(창 고 용)"			
					end if
					
					ll_rows = dw_print.retrieve(is_brand, is_yymmdd, is_shop_cd, is_shop_type, is_out_no, is_gubun)
			
					ls_modify = "t_jup_name.text = '" + ls_jup_name + "'"
					ls_Error = dw_print.Modify(ls_modify)
						IF (ls_Error <> "") THEN 
							MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
						END IF				
					IF ll_rows > 0 Then il_rows = dw_print.Print()
			   NEXT		
			END IF
		
	  next	
end if


This.Trigger Event ue_msg(6, il_rows)

end event

on w_42009_d.create
int iCurrent
call super::create
this.cbx_a4=create cbx_a4
this.cb_print1=create cb_print1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_a4
this.Control[iCurrent+2]=this.cb_print1
end on

on w_42009_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_a4)
destroy(this.cb_print1)
end on

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */
/* 작성일      : 2002.03.16                                                  */
/* 수정일      : 2002.03.16                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_yymmdd, is_shop_cd, is_house_cd, &
									is_shop_type, is_jup_gubn, is_out_type, is_gubun)
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
IF IsNull(is_brand) OR Trim(is_brand) = "" THEN
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	


is_yymmdd = String(dw_head.GetItemDateTime(1, "yymmdd"), 'yyyymmdd')
IF IsNull(is_yymmdd) OR Trim(is_yymmdd) = "" THEN
   MessageBox(ls_title,"일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   RETURN FALSE
END IF

is_house_cd = dw_head.GetItemString(1, "house_cd")
IF IsNull(is_house_cd) OR Trim(is_house_cd) = "" THEN
   MessageBox(ls_title,"창고를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   RETURN FALSE
END IF

is_jup_gubn = dw_head.GetItemString(1, "jup_gubn")
IF IsNull(is_jup_gubn) OR Trim(is_jup_gubn) = "" THEN
   MessageBox(ls_title,"전표 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("jup_gubn")
   RETURN FALSE
END IF

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
IF IsNull(is_shop_cd) OR Trim(is_shop_cd) = "" THEN is_shop_cd = '%'

is_shop_type = dw_head.GetItemString(1, "shop_type")
IF IsNull(is_shop_type) OR Trim(is_shop_type) = "" THEN
   MessageBox(ls_title,"매장형태를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   RETURN FALSE
END IF

is_out_type = dw_head.GetItemString(1, "out_type")
IF IsNull(is_out_type) OR Trim(is_out_type) = "" THEN is_out_type= '%'

is_gubun = dw_head.GetItemString(1, "gubun")
IF IsNull(is_gubun) OR Trim(is_gubun) = "" THEN
   MessageBox(ls_title,"조회 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubun")
   RETURN FALSE
END IF

RETURN TRUE

end event

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_shop_div
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		is_brand = Trim(dw_head.GetItemString(1, "brand"))
//		Choose Case is_brand
//			Case 'J'
//				ls_brand = 'N'
//			Case 'Y'
//				ls_brand = 'O'
//			Case Else
//				ls_brand = is_brand
//		End Choose
		
		IF ai_div = 1 THEN
			IF IsNull(as_data) OR Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "shop_nm", "")
				RETURN 0
			END IF

			IF LeftA(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND Shop_Stat = '00' "
		
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = CREATE DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = TRUE
			lds_Source = Message.PowerObjectParm
			dw_head.SetRow(al_row)
			dw_head.SetColumn(as_column)
			dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
			dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
			/* 다음컬럼으로 이동 */
			dw_head.SetColumn("house_cd")
			ib_itemchanged = FALSE
			lb_check = TRUE
		ELSE
			lb_check = FALSE
		END IF
		DESTROY lds_Source
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

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long ll_row_count, i, ll_rows
string ls_print_gubn

ll_row_count = dw_list.RowCount()

ls_print_gubn = dw_head.GetitemString(1, "print_gubn")

IF ls_print_gubn = "N" THEN
	dw_print.DataObject = 'd_com420'
	dw_print.SetTransObject(SQLCA)
ELSE
	dw_print.DataObject = 'd_com420_tag'
	dw_print.SetTransObject(SQLCA)
END IF



FOR i = 1 TO ll_row_count
	IF dw_list.GetItemString(i, 'check_print') = 'Y' THEN
		is_shop_cd = dw_list.GetItemString(i, 'shop_cd')
		is_out_no  = dw_list.GetItemString(i, 'out_no' )
		is_shop_type  = dw_list.GetItemString(i, 'shop_type' )		

		
		ll_rows = dw_print.retrieve(is_brand, is_yymmdd, is_shop_cd, is_shop_type, is_out_no, is_gubun)
		IF ll_rows > 0 Then il_rows = dw_print.Print()
	END IF
NEXT

THIS.TRIGGER EVENT ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42009_d","0")
end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
      else
         dw_head.SetFocus()
      end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_print1.enabled = false		
      cb_preview.enabled = false
      cb_excel.enabled = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_print1.enabled = true			
         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_print.enabled = false
         cb_print1.enabled = false			
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if
END CHOOSE

end event

type cb_close from w_com020_d`cb_close within w_42009_d
end type

type cb_delete from w_com020_d`cb_delete within w_42009_d
end type

type cb_insert from w_com020_d`cb_insert within w_42009_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_42009_d
end type

type cb_update from w_com020_d`cb_update within w_42009_d
end type

type cb_print from w_com020_d`cb_print within w_42009_d
end type

type cb_preview from w_com020_d`cb_preview within w_42009_d
boolean visible = false
end type

type gb_button from w_com020_d`gb_button within w_42009_d
end type

type cb_excel from w_com020_d`cb_excel within w_42009_d
end type

type dw_head from w_com020_d`dw_head within w_42009_d
integer x = 37
integer y = 144
integer height = 276
string dataobject = "d_42009_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()

THIS.GetChild("jup_gubn", idw_jup_gubn)
idw_jup_gubn.SetTransObject(SQLCA)
idw_jup_gubn.Retrieve('025')
idw_jup_gubn.InsertRow(1)
idw_jup_gubn.SetItem(1, "inter_cd", '%')
idw_jup_gubn.SetItem(1, "inter_nm", '전체')

THIS.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')

THIS.GetChild("out_type", idw_out_type)
idw_out_type.SetTransObject(SQLCA)
idw_out_type.Retrieve('420')
idw_out_type.InsertRow(1)
idw_out_type.SetItem(1, "inter_cd", '%')
idw_out_type.SetItem(1, "inter_nm", '전체')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */
/* 작성일      : 2002.03.13                                                  */
/* 수정일      : 2002.03.13                                                  */
/*===========================================================================*/
CHOOSE CASE dwo.name
	CASE "brand"
		dw_head.SetItem(1, "shop_cd", "")
		dw_head.SetItem(1, "shop_nm", "")
	CASE "gubun"
		IF data = '1' THEN
			dw_head.Object.out_type.Protect = 0
			dw_head.Object.out_type.BackGround.Color = RGB(255, 255, 255)
		ELSE
			dw_head.SetItem(1, "out_type", '%')
			dw_head.Object.out_type.Protect = 1
			dw_head.Object.out_type.BackGround.Color = RGB(192, 192, 192)
		END IF
	CASE "shop_cd"	      //  Popup 검색창이 존재하는 항목
		IF ib_itemchanged THEN RETURN 1
		RETURN PARENT.TRIGGER EVENT ue_Popup(dwo.name, row, data, 1)

	
		
END CHOOSE

end event

type ln_1 from w_com020_d`ln_1 within w_42009_d
end type

type ln_2 from w_com020_d`ln_2 within w_42009_d
end type

type dw_list from w_com020_d`dw_list within w_42009_d
integer x = 14
integer y = 452
integer width = 1289
integer height = 1588
string dataobject = "d_42009_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/



IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_shop_cd = This.GetItemString(row, 'shop_cd') /* DataWindow에 Key 항목을 가져온다 */
is_out_no  = This.GetItemString(row, 'out_no')  /* DataWindow에 Key 항목을 가져온다 */
is_shop_type = This.GetItemString(row, 'shop_type')  /* DataWindow에 Key 항목을 가져온다 */


IF IsNull(is_shop_cd) or IsNull(is_out_no) THEN RETURN
//il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_shop_cd, is_house_cd, is_shop_type, is_out_type, is_out_no, is_gubun)
il_rows = dw_body.retrieve(is_yymmdd, is_shop_cd, is_shop_type, is_out_no, is_gubun)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

event dw_list::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(true)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

end event

event dw_list::buttonclicked;call super::buttonclicked;string ls_yymmdd, ls_out_no, ls_shop_cd, ls_modify
Integer li_deal_seq, li_work_no, li_rtrn
long    ll_row, II, JJ, KK, ll_ok

CHOOSE CASE dwo.name
	CASE "cb_print"	
	
		ll_row = dw_list.rowcount()
		if dw_list.object.cb_print.text = "선택"  then 
			for ii = 1 to ll_row
				dw_list.setitem(ii , "check_print", "Y")
			next	

	   ls_modify = 'cb_print.text= "해제"' 
		dw_list.Modify(ls_modify)
			
      else
			for ii = 1 to ll_row
				dw_list.setitem(ii , "check_print", "N")				
			next	
	   ls_modify = 'cb_print.text= "선택"'
		dw_list.Modify(ls_modify)
		end if	
			

END CHOOSE
	
end event

type dw_body from w_com020_d`dw_body within w_42009_d
integer x = 1321
integer y = 452
integer width = 2281
integer height = 1588
string dataobject = "d_42009_d02"
end type

type st_1 from w_com020_d`st_1 within w_42009_d
integer x = 1303
integer y = 452
integer height = 1588
end type

type dw_print from w_com020_d`dw_print within w_42009_d
integer x = 567
integer y = 492
integer width = 1865
integer height = 372
string dataobject = "d_com420_tag"
end type

type cbx_a4 from checkbox within w_42009_d
integer x = 46
integer y = 56
integer width = 594
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "명세서A4(매장용)"
borderstyle borderstyle = stylelowered!
end type

type cb_print1 from commandbutton within w_42009_d
integer x = 626
integer y = 44
integer width = 347
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "명세서A4"
end type

event clicked;Parent.Trigger Event ue_print1()
end event

