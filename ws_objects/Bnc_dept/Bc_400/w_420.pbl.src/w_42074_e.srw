$PBExportHeader$w_42074_e.srw
$PBExportComments$배분차수변경(배분합치기)
forward
global type w_42074_e from w_com020_e
end type
end forward

global type w_42074_e from w_com020_e
integer width = 3689
integer height = 2240
end type
global w_42074_e w_42074_e

type variables
DataWindowChild	idw_color, idw_brand
String is_brand, is_to_ymd, is_shop_cd, is_yymmdd, is_to_deal_seq
integer ii_to_deal_seq
end variables

event ue_retrieve();call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//hpb_1.position = 0

il_rows = dw_list.retrieve(is_brand, is_yymmdd)
IF il_rows > 0 THEN
   dw_list.SetFocus()
	cb_print.enabled = true
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
String   ls_title
long li_cnt

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


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif (gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	


is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"배분일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"변경일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


ii_to_deal_seq = dw_head.GetItemNumber(1, "deal_seq")
if IsNull(ii_to_deal_seq) then
   MessageBox(ls_title,"변경 할 배분차수를 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_seq")
   return false
end if



	select count(*)
	into :li_cnt
	from tb_52031_h (nolock)
	where out_ymd = :is_to_ymd
	and   deal_seq = :ii_to_deal_seq;
	
	if li_cnt > 0 then
		 MessageBox("알림", "변경 대상 차수로 배분된 작업이 있습니다. 배분처리 전 배분차수를 확인하세요!")
		Return false	
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

on w_42074_e.create
call super::create
end on

on w_42074_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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
String ls_shop_cd, ls_shop_type, ls_box_size, ls_out_no_b, li_no, ls_rot_shop_no, LS_WORK_GUBN ,ls_deal_seq, ls_deal_seq_rtn, ls_sel_yn
long i, ll_row_count, ll_sqlcode, ll_cnt
datetime ld_datetime
integer Net, li_cnt

IF dw_body.AcceptText() <> 1 THEN RETURN -1

//hpb_1.position = 0
ll_cnt = 0

ll_row_count = dw_list.RowCount()

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_deal_seq = ""
ls_deal_seq_rtn = ""

FOR i=1 TO ll_row_count

	ls_sel_yn	= dw_list.GetItemString(i, "sel_yn")
	if ls_sel_yn = "Y" then
		ls_deal_seq	= dw_list.GetItemString(i, "deal_seq")
		
		if ls_deal_seq_rtn = "" then 
			ls_deal_seq_rtn = ls_deal_seq
		else 	
			ls_deal_seq_rtn = ls_deal_seq_rtn + "|" +	ls_deal_seq		
		end if
	end if
NEXT
 
//messagebox("ls_deal_seq_rtn", ls_deal_seq_rtn)
 
select count(*)
into :li_cnt
from tb_52031_h (nolock)
where out_ymd = :is_to_ymd
and   deal_seq = :ii_to_deal_seq;

if li_cnt > 0 then
	 MessageBox("알림", "변경 대상 차수로 배분된 작업이 있습니다. 배분처리 전 배분차수를 확인하세요!")
	Return  -1	
end if	




select	count(*)
into :li_cnt
from	tb_52031_h (nolock) 
where	out_ymd = :is_yymmdd
and   shoP_cd like  :is_brand + '%'
and   (dps_yn = 'Y' or proc_yn = 'Y')
and    right( convert(char(05), 10000 + deal_seq ),4)  in ( 
								 SELECT x.value 
								 FROM beaucre.dbo.sf_SplitString(:ls_deal_seq_rtn, '|') x);


if li_cnt > 0 then
	 MessageBox("알림", "선택 차수중 작업중인 내역이 있습니다. 다시 조회 후 확인하세요!")
	Return  -1	
end if	

Net = MessageBox("경고", "조회시점 기준 물류 작업대기인 배분을 합칩니다. 계속하시겠습니까?", Exclamation!, OKCancel!, 2)

IF Net = 1 THEN 
	
	//st_1.visible = true
//	st_1.text = "<-- 처리 중입니다. 잠시 기다려 주세요!  "
	
		DECLARE SP_42074_P01 PROCEDURE FOR SP_42074_P01  
			@brand		= :is_brand,
         @yymmdd 		= :is_yymmdd,   
         @deal_seq 	= :ls_deal_seq_rtn,
         @to_ymd 		= :is_to_ymd,			
			@to_deal_seq = :ii_to_deal_seq,	
			@reg_id     = :gs_user_id;

	
		 EXECUTE SP_42074_P01 ;
		 
		IF SQLCA.SQLCODE = -1 THEN 
			rollback  USING SQLCA;				
			MessageBox("SQL오류", SQLCA.SqlErrText) 
			Return -1 			
		ELSE
			commit  USING SQLCA;
   	  MessageBox("알림", "작업이 완료되었습니다!")			
		END IF 		
	

ELSE

  MessageBox("알림", "작업이 취소되었습니다!")

END IF

dw_list.retrieve(is_brand, is_yymmdd)

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42074_e","0")
end event

type cb_close from w_com020_e`cb_close within w_42074_e
end type

type cb_delete from w_com020_e`cb_delete within w_42074_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_42074_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_42074_e
end type

type cb_update from w_com020_e`cb_update within w_42074_e
end type

type cb_print from w_com020_e`cb_print within w_42074_e
boolean visible = false
integer x = 1499
end type

type cb_preview from w_com020_e`cb_preview within w_42074_e
boolean visible = false
integer x = 1847
boolean enabled = true
end type

type gb_button from w_com020_e`gb_button within w_42074_e
end type

type cb_excel from w_com020_e`cb_excel within w_42074_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_42074_e
integer y = 144
integer width = 3579
integer height = 204
string dataobject = "d_42074_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_house_cd

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

This.GetChild("house_cd", ldw_house_cd)
ldw_house_cd.SetTransObject(SQLCA)
ldw_house_cd.Retrieve()

end event

event dw_head::itemchanged;call super::itemchanged;


CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_42074_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com020_e`ln_2 within w_42074_e
integer beginy = 356
integer endy = 356
end type

type dw_list from w_com020_e`dw_list within w_42074_e
integer x = 0
integer y = 364
integer width = 1435
integer height = 1636
boolean titlebar = true
string title = "배분리스트 - 대기 상태만 선택가능"
string dataobject = "d_42074_d01"
boolean livescroll = false
end type

event dw_list::buttonclicked;call super::buttonclicked;Long	ll_row_count, i
string ls_select

//CHOOSE CASE dwo.name
//	CASE "cb_select"
//		If This.Object.cb_select.Text = '전체승인' then
//			ls_select = 'Y'
//			This.Object.cb_select.Text = '전체제외'
//		Else
//			ls_select = 'N'
//			This.Object.cb_select.Text = '전체승인'
//			ib_changed = false
//         cb_update.enabled = false
//		End If
//		
//		ll_row_count = This.RowCount()
//		
//		For i = 1 to ll_row_count
//			This.SetItem(i, "proc_yn", ls_select)
//		Next
//		
//	
//END CHOOSE
//
    
end event

event dw_list::itemchanged;call super::itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event dw_list::clicked;call super::clicked;

String ls_yymmdd, ls_deal_seq
integer  li_deal_seq

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

IF row < 0 THEN RETURN 

ls_yymmdd    = This.GetitemString(row, "out_ymd")
ls_deal_seq    = This.GetitemString(row, "deal_seq")

//messagebox("ls_yymmdd", ls_yymmdd)

il_rows = dw_body.Retrieve(is_brand , ls_yymmdd, ls_deal_seq ) 

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

parent.Trigger Event ue_button(1, il_rows)


end event

type dw_body from w_com020_e`dw_body within w_42074_e
integer x = 1449
integer y = 364
integer width = 2158
integer height = 1640
boolean titlebar = true
string title = "차수별 배분내역"
string dataobject = "d_42074_d02"
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

type st_1 from w_com020_e`st_1 within w_42074_e
integer x = 1440
integer y = 364
integer height = 1656
end type

type dw_print from w_com020_e`dw_print within w_42074_e
string dataobject = "d_42037_r02"
end type

