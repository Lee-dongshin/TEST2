$PBExportHeader$w_42067_e_old.srw
$PBExportComments$매장 반품 승인 작업(Smart)
forward
global type w_42067_e_old from w_com020_e
end type
type hpb_1 from hprogressbar within w_42067_e_old
end type
type st_2 from statictext within w_42067_e_old
end type
type st_3 from statictext within w_42067_e_old
end type
end forward

global type w_42067_e_old from w_com020_e
hpb_1 hpb_1
st_2 st_2
st_3 st_3
end type
global w_42067_e_old w_42067_e_old

type variables
DataWindowChild	idw_color, idw_brand
String is_brand, is_frm_ymd, is_to_ymd, is_shop_cd
end variables

event ue_retrieve();call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

hpb_1.position = 0

il_rows = dw_list.retrieve(is_frm_ymd, is_to_ymd, is_shop_cd, is_brand)
IF il_rows > 0 THEN
   dw_list.SetFocus()
	cb_print.enabled = true
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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

is_frm_ymd = dw_head.GetItemString(1, "frm_ymd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = '%'
	
//   MessageBox(ls_title,"매장코드를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("shop_cd")
//   return false
end if

return true

end event

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_ymd" ,string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "to_ymd" ,string(ld_datetime,"yyyymmdd"))
end event

on w_42067_e_old.create
int iCurrent
call super::create
this.hpb_1=create hpb_1
this.st_2=create st_2
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
end on

on w_42067_e_old.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.hpb_1)
destroy(this.st_2)
destroy(this.st_3)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND (SHOP_DIV  IN ('G', 'K', 'T','I') or shop_cd like '__499_' OR shop_cd like '__799_')" + &
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

event ue_print();String ls_yymmdd,  ls_shop_cd, ls_shop_type, ls_out_no, ls_shop_nm, ls_out_no_house
String ls_box_ymd, ls_box_no,  ls_proc_yn
long	 ll_row_count, ii
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

 ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
 
ll_row_count = dw_list.RowCount()

for ii = 1 to ll_row_count 
	ls_proc_yn   = dw_list.GetitemString(ii, "proc_yn")
  
   if ls_proc_yn = "Y" then
		ls_yymmdd    = dw_list.GetitemString(ii, "yymmdd")
		ls_out_no    = dw_list.GetitemString(ii, "out_no")
		ls_shop_cd   = dw_list.GetitemString(ii, "shop_cd")
		ls_shop_nm   = dw_list.GetitemString(ii, "shop_nm")		
		ls_shop_type = dw_list.GetitemString(ii, "shop_type")
		ls_box_ymd   = dw_list.GetitemString(ii, "box_ymd")
		ls_box_no    = dw_list.GetitemString(ii, "box_no")
		ls_out_no_house    = dw_list.GetitemString(ii, "out_no_house")
		
		//This.Trigger Event ue_title()
		
		ls_modify =	"t_pg_id.Text     = '" + is_pgm_id    + "'" + &
						"t_user_id.Text   = '" + gs_user_id   + "'" + &
						"t_datetime.Text  = '" + ls_datetime  + "'" + &
						"t_box.Text       = '" + ls_box_ymd   + " - " + ls_box_no + "' " + &
						"t_shop.Text      = '" + ls_shop_cd   + " - " + ls_shop_nm + "' " 
		
		dw_print.Modify(ls_modify)

//      messagebox("ff", ls_modify) 
      
		dw_print.Retrieve(ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, is_brand, ls_box_ymd, ls_box_no, ls_out_no_house) 

		IF dw_print.RowCount() = 0 Then
			MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
			il_rows = 0
		ELSE
			il_rows = dw_print.Print()
 		END IF
	end if
	
next


This.Trigger Event ue_msg(6, il_rows)


end event

event type long ue_update();call super::ue_update;
String ls_ErrMsg, ls_proc_yn, ls_box_ymd, ls_box_no, ls_yymmdd, ls_out_no, ls_no, ls_out_no_house, ls_no_house, ls_box_ymd_house, ls_box_no_house, ls_tran_cust
String ls_shop_cd, ls_shop_type, ls_box_size
long i, ll_row_count, ll_sqlcode, ll_cnt
datetime ld_datetime

IF dw_body.AcceptText() <> 1 THEN RETURN -1

IF MessageBox("확인", "선택한 제품을 물류창고로 반품처리 하시겠습니까 ?", Question!, YesNo! ) = 2 THEN 
	RETURN 0 
END IF

//hpb_1.position = 0
ll_cnt = 0

ll_row_count = dw_body.RowCount()

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
	
	//hpb_1.position = i / ll_row_count * 100
	
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
		
	ls_proc_yn = dw_body.GetItemString(i, "proc_yn")
	ls_box_ymd = dw_body.GetItemString(i, "rqst_date")
	ls_box_no  = dw_body.GetItemString(i, "rqst_no")	
	ls_shop_cd = dw_body.GetItemString(i, "shop_cd")
	ls_shop_type = dw_body.GetItemString(i, "shop_type")		
	ls_yymmdd  = dw_body.GetItemString(i, "yymmdd")
	ls_out_no  = dw_body.GetItemString(i, "out_no")	
	ls_no      = dw_body.GetItemString(i, "no")		
	ls_out_no_house  = dw_body.GetItemString(i, "out_no_house")	
	ls_no_house      = dw_body.GetItemString(i, "no_house")		
	ls_tran_cust     = dw_body.GetItemString(i, "tran_cust")
	ls_box_size      = dw_body.GetItemString(i, "box_size")
//	ls_box_ymd_house = dw_body.GetItemString(i, "rqst_date_house")
//	ls_box_no_house  = dw_body.GetItemString(i, "rqst_no_house")	
	
  IF idw_status = DataModified! and ls_proc_yn = "Y" THEN				/* New Record */

	 insert into tb_42037_h								  
		select *, 'Y'							  
	  from tb_42021_shop
	 where yymmdd    = :ls_yymmdd
		and out_no    = :ls_out_no
		and shop_cd   = :ls_shop_cd
		and shop_type = :ls_shop_type
		and no        = :ls_no
		and rqst_date = :ls_box_ymd
		and rqst_no   = :ls_box_no;


		insert into tb_42021_h(
		yymmdd,		Shop_CD,			Shop_Type,	Out_NO,			House_CD,	Jup_gubn,
		Sale_Type,	Margin_Rate,	disc_Rate,	NO,				Style,		Chno,
		Color,		Size,				class,		Tag_Price,		Curr_Price,	Out_Price,
		Qty,			Tag_Amt,			Curr_Amt,	Rtrn_collect,	Vat,			Rot_Shop,
		Rot_Shop_type,	Rqst_Gubn,	Rqst_Date,	Rqst_No,			Rqst_Chno,	Shop_Ymd,
		Brand,		Year,				Season,		Item,				Sojae,		trigger_yn,
		Reg_id,		Reg_Dt,			Mod_id,		Mod_Dt,			PDA_NO,		TRAN_CUST,
		BOX_SIZE,	BOX_NO,			Note )		
		select 										  
		yymmdd,			Shop_CD,			Shop_Type,		Out_NO,			House_CD,	Jup_gubn,
		Sale_Type,		Margin_Rate,	disc_Rate,		NO,				Style,		Chno,
		Color,			Size,				class,			Tag_Price,		Curr_Price,	Out_Price,
		Qty,				Tag_Amt,			Curr_Amt,		Rtrn_collect,	Vat,			Rot_Shop,
		Rot_Shop_type,	Rqst_Gubn,		Rqst_Date,		Rqst_No,			Rqst_Chno,	Shop_Ymd,
		Brand,			Year,				Season,			Item,				Sojae,		trigger_yn,
		Reg_id,			Reg_Dt,			:gs_user_id,	getdate(),		'S001',		:ls_TRAN_CUST,
		:ls_BOX_SIZE,		BOX_NO,			Note			
		 from tb_42021_shop								  
		 where yymmdd    = :ls_yymmdd
		   and out_no    = :ls_out_no
			and shop_cd   = :ls_shop_cd
			and shop_type = :ls_shop_type
			and no        = :ls_no
			and rqst_date = :ls_box_ymd
			and rqst_no   = :ls_box_no;
			
			delete 
			 from tb_42021_shop								  
		 where yymmdd    = :ls_yymmdd
		   and out_no    = :ls_out_no
			and shop_cd   = :ls_shop_cd
			and shop_type = :ls_shop_type
			and no        = :ls_no
			and rqst_date = :ls_box_ymd
			and rqst_no   = :ls_box_no;

			update tb_42026_h set proc_yn = 'C'
		    where box_ymd  = :ls_box_ymd
		    and   shop_cd  = :ls_shop_cd
		    and   box_no   = :ls_box_no
			 and   no       = :ls_no
			 and   proc_yn  = 'Y' ;		


//창고내역 삭제
			delete 
			 from tb_42021_house								  
		 where yymmdd    = :ls_yymmdd
		   and out_no    = :ls_out_no_house
			and shop_cd   = :ls_shop_cd
			and shop_type = :ls_shop_type
			and no        = :ls_no_house
			and rqst_date = :ls_box_ymd
			and rqst_no   = :ls_box_no;
		
//창고내역 수정
			update tb_42026_h_house set proc_yn = 'C'
		    where box_ymd  = :ls_box_ymd
		    and   shop_cd  = :ls_shop_cd
		    and   box_no   = :ls_box_no
		    and   seq_no	 = :ls_no_house;
			

		if SQLCA.SQLCODE = 0  OR SQLCA.SQLCODE = 100 then
			commit  USING SQLCA;
			il_rows = 1 
			cb_update.Enabled = False		
			ll_cnt = ll_cnt + 1
		else 
			ll_sqlcode = SQLCA.SQLCODE
			ls_ErrMsg  = SQLCA.SQLErrText 
			rollback  USING SQLCA; 
			MessageBox("SQL 오류", "[" + String(ll_sqlcode) + "]" + ls_ErrMsg) 
		end if

   END IF
NEXT

messagebox("처리 완료!", "총" + string(ll_cnt) + "개의 제품이 반품처리 되었습니다!")
dw_body.reset()

This.Trigger Event ue_retrieve()

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42037_e","0")
end event

type cb_close from w_com020_e`cb_close within w_42067_e_old
end type

type cb_delete from w_com020_e`cb_delete within w_42067_e_old
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_42067_e_old
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_42067_e_old
end type

type cb_update from w_com020_e`cb_update within w_42067_e_old
end type

type cb_print from w_com020_e`cb_print within w_42067_e_old
integer x = 1499
end type

type cb_preview from w_com020_e`cb_preview within w_42067_e_old
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_42067_e_old
end type

type cb_excel from w_com020_e`cb_excel within w_42067_e_old
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_42067_e_old
integer y = 144
integer width = 3323
integer height = 208
string dataobject = "d_42067_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if
end event

event dw_head::itemchanged;call super::itemchanged;


CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_42067_e_old
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com020_e`ln_2 within w_42067_e_old
integer beginy = 356
integer endy = 356
end type

type dw_list from w_com020_e`dw_list within w_42067_e_old
integer x = 14
integer y = 364
integer width = 2263
integer height = 1636
string dataobject = "d_42067_d01"
boolean livescroll = false
end type

event dw_list::doubleclicked;call super::doubleclicked;String ls_yymmdd,  ls_shop_cd, ls_shop_type, ls_out_no, ls_out_no_house
String ls_box_ymd, ls_box_no

IF row < 0 THEN RETURN 

ls_yymmdd    = This.GetitemString(row, "yymmdd")
ls_out_no    = This.GetitemString(row, "out_no")
ls_shop_cd   = This.GetitemString(row, "shop_cd")
ls_shop_type = This.GetitemString(row, "shop_type")
ls_box_ymd   = This.GetitemString(row, "box_ymd")
ls_box_no    = This.GetitemString(row, "box_no")
ls_out_no_house    = This.GetitemString(row, "out_no_house")


il_rows = dw_body.Retrieve(ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, is_brand, ls_box_ymd, ls_box_no, ls_out_no_house) 

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

parent.Trigger Event ue_button(1, il_rows)


end event

event dw_list::buttonclicked;call super::buttonclicked;Long	ll_row_count, i
string ls_select

CHOOSE CASE dwo.name
	CASE "cb_select"
		If This.Object.cb_select.Text = '전체승인' then
			ls_select = 'Y'
			This.Object.cb_select.Text = '전체제외'
		Else
			ls_select = 'N'
			This.Object.cb_select.Text = '전체승인'
			ib_changed = false
         cb_update.enabled = false
		End If
		
		ll_row_count = This.RowCount()
		
		For i = 1 to ll_row_count
			This.SetItem(i, "proc_yn", ls_select)
		Next
		
	
END CHOOSE

    
end event

type dw_body from w_com020_e`dw_body within w_42067_e_old
integer x = 2299
integer y = 364
integer width = 1307
integer height = 1640
string dataobject = "d_42067_d02"
end type

event dw_body::buttonclicked;call super::buttonclicked;
Long	ll_row_count, i
string ls_select

CHOOSE CASE dwo.name
	CASE "cb_select"
		If This.Object.cb_select.Text = '전체승인' then
			ls_select = 'Y'
			This.Object.cb_select.Text = '전체제외'
			ib_changed = true
         cb_update.enabled = true
		Else
			ls_select = 'N'
			This.Object.cb_select.Text = '전체승인'
			ib_changed = false
         cb_update.enabled = false
		End If
		
		ll_row_count = This.RowCount()

		For i = 1 to ll_row_count
			This.SetItem(i, "proc_yn", ls_select)
		NEXT
		
END CHOOSE

    
    
end event

type st_1 from w_com020_e`st_1 within w_42067_e_old
integer x = 2277
integer y = 364
integer height = 1656
end type

type dw_print from w_com020_e`dw_print within w_42067_e_old
string dataobject = "d_42067_r01"
end type

type hpb_1 from hprogressbar within w_42067_e_old
integer x = 567
integer y = 32
integer width = 795
integer height = 112
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
boolean smoothscroll = true
end type

type st_2 from statictext within w_42067_e_old
integer x = 379
integer y = 68
integer width = 183
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "진행0%"
boolean focusrectangle = false
end type

type st_3 from statictext within w_42067_e_old
integer x = 1362
integer y = 68
integer width = 137
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "100%"
boolean focusrectangle = false
end type

