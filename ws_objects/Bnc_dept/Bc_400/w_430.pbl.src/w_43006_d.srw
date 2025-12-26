$PBExportHeader$w_43006_d.srw
$PBExportComments$특정품번별재고내역
forward
global type w_43006_d from w_com020_d
end type
type dw_result2 from datawindow within w_43006_d
end type
type dw_shop_div from datawindow within w_43006_d
end type
type dw_detail from datawindow within w_43006_d
end type
type dw_assort from datawindow within w_43006_d
end type
type dw_color from datawindow within w_43006_d
end type
type dw_result from datawindow within w_43006_d
end type
type dw_1 from datawindow within w_43006_d
end type
type dw_2 from datawindow within w_43006_d
end type
end forward

global type w_43006_d from w_com020_d
dw_result2 dw_result2
dw_shop_div dw_shop_div
dw_detail dw_detail
dw_assort dw_assort
dw_color dw_color
dw_result dw_result
dw_1 dw_1
dw_2 dw_2
end type
global w_43006_d w_43006_d

type variables
DataWindowChild idw_color
string is_style, is_chno, is_color, is_yymmdd, is_order_yn
long il_cnt_k


end variables

forward prototypes
public function boolean wf_body_set ()
public subroutine wf_retrieve_ser1 ()
public subroutine wf_retrieve_set ()
end prototypes

public function boolean wf_body_set ();//String  ls_modify,   ls_error
//String  ls_size 
//Long    ll_size_cnt 
//integer i, k
//
//FOR i = 1  TO 8
//	IF i > il_cnt_k  THEN
//      ls_modify = ' t_size'   	+ String(i) + '.Visible=0' + &
//                  ' t_out'     + String(i) + '.Visible=0' + &
//                  ' t_sale'    + String(i) + '.Visible=0' + &
//                  ' t_stock'   + String(i) + '.Visible=0' 
//	END IF
//	ls_Error = dw_body.Modify(ls_modify)
//	IF (ls_Error <> "") THEN 
//		MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
//		Return False
//	END IF
//NEXT 
//
Return True 
end function

public subroutine wf_retrieve_ser1 ();
String ls_shop_cd,   ls_find , ls_error , ls_modify, ls_size 
Long   ll_row, ll_row_cnt, ll_assort_cnt, ll_size_cnt, ll_max_k
Long   i, k, ll_out_qty , ll_sale_qty, ll_stock_qty  ,j

  ll_max_k = 0

if is_order_yn <> "C" then
	is_chno = "%"
end if
	
il_rows = dw_assort.Retrieve(is_style, is_chno)
ll_row_cnt    = dw_result2.RowCount()
ll_assort_cnt = dw_assort.RowCount()
IF ll_row_cnt < 1 THEN RETURN 

dw_body.Reset()
FOR i = 1  TO 8
	   ls_modify = ' t_size'    + String(i) + '.Visible=1' + &
                  ' t_out'     + String(i) + '.Visible=1' + &
                  ' t_sale'    + String(i) + '.Visible=1' + &
                  ' t_stock'   + String(i) + '.Visible=1' + &
                  ' in_qty_'     + String(i) + '.Visible=1' + &
                  ' sale_qty_'    + String(i) + '.Visible=1' + &
                  ' stock_qty_'   + String(i) + '.Visible=1' + &
                  ' c_in_qty_'     + String(i) + '.Visible=1' + &
                  ' c_sale_qty_'    + String(i) + '.Visible=1' + &
                  ' c_stock_qty_'   + String(i) + '.Visible=1' 

						
     ls_Error = dw_body.Modify(ls_modify)			
	  	IF (ls_Error <> "") THEN 
		MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
	//	Return False
	END IF
NEXT 

	
For i = 1 to ll_row_cnt 
	IF ls_shop_cd <> dw_result2.object.shop_cd[i] THEN 
      ls_shop_cd =  dw_result2.object.shop_cd[i] 
		ll_row     =  dw_body.insertRow(0)
		
	for j = 1 to 8 
		dw_body.Setitem(ll_row, "in_qty_"  + String(j), 0)
		dw_body.Setitem(ll_row, "sale_qty_" + String(j), 0)
		dw_body.Setitem(ll_row, "stock_qty_" + String(j), 0)
	next
	
    dw_body.Setitem(ll_row, "part_div",   ls_shop_cd)
   END IF 
	ls_find = "size = '" + dw_result2.object.size[i] + "'"
   k = dw_assort.find(ls_find, 1, ll_assort_cnt)	

	IF k > 0 THEN 
		ll_out_qty = dw_result2.GetitemNumber(i, "out_qty")
		ll_sale_qty = dw_result2.GetitemNumber(i, "sale_qty")
		ll_stock_qty = dw_result2.GetitemNumber(i, "stock_qty")
		dw_body.Setitem(ll_row, "in_qty_"  + String(k), ll_out_qty)
		dw_body.Setitem(ll_row, "sale_qty_" + String(k), ll_sale_qty)
		dw_body.Setitem(ll_row, "stock_qty_"  + String(k), ll_stock_qty)
      ls_modify = ' t_size'    + String(k) + '.text= "' + dw_result2.object.size[i] + '"' 
		ls_Error = dw_body.Modify(ls_modify)
      
		if ll_max_k < k then
  		 ll_max_k = k
   	end if
		
//		IF (ls_Error <> "") THEN 
//			MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
//		END IF

	END IF

Next


FOR i = 1  TO 8
	IF i > ll_max_k   THEN
      ls_modify = ' t_size'    + String(i) + '.Visible=0' + &
                  ' t_out'     + String(i) + '.Visible=0' + &
                  ' t_sale'    + String(i) + '.Visible=0' + &
                  ' t_stock'   + String(i) + '.Visible=0' + &
                  ' in_qty_'     + String(i) + '.Visible=0' + &
                  ' sale_qty_'    + String(i) + '.Visible=0' + &
                  ' stock_qty_'   + String(i) + '.Visible=0' + &
                  ' c_in_qty_'     + String(i) + '.Visible=0' + &
                  ' c_sale_qty_'    + String(i) + '.Visible=0' + &
                  ' c_stock_qty_'   + String(i) + '.Visible=0' 						
						
     ls_Error = dw_body.Modify(ls_modify)		
     ls_Error = dw_print.Modify(ls_modify)	  
//	  	IF (ls_Error <> "") THEN 
//		MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
//	//	Return False
//	END IF
	END IF
	

NEXT 



end subroutine

public subroutine wf_retrieve_set ();
String ls_shop_div,   ls_find , ls_error , ls_modify, ls_size 
Long   ll_row, ll_row_cnt, ll_assort_cnt, ll_size_cnt , ll_max_k
Long   i, k, ll_out_qty , ll_sale_qty, ll_stock_qty  ,j

  ll_max_k = 0

if is_order_yn <> "C" then
	is_chno = "%"
end if
dw_assort.reset()	
il_rows = dw_assort.Retrieve(is_style, is_chno)
ll_row_cnt    = dw_result.RowCount()
ll_assort_cnt = dw_assort.RowCount()
IF ll_row_cnt < 1 THEN RETURN 


dw_list.Reset()
FOR i = 1  TO 8
	   ls_modify = ' t_size'    + String(i) + '.Visible=1' + &
                  ' t_out'     + String(i) + '.Visible=1' + &
                  ' t_sale'    + String(i) + '.Visible=1' + &
                  ' t_stock'   + String(i) + '.Visible=1' + &
                  ' in_qty_'     + String(i) + '.Visible=1' + &
                  ' sale_qty_'    + String(i) + '.Visible=1' + &
                  ' stock_qty_'   + String(i) + '.Visible=1' + &
                  ' c_in_qty_'     + String(i) + '.Visible=1' + &
                  ' c_sale_qty_'    + String(i) + '.Visible=1' + &
                  ' c_stock_qty_'   + String(i) + '.Visible=1' 
						
						
     ls_Error = dw_list.Modify(ls_modify)			
//	  	IF (ls_Error <> "") THEN 
//		MessageBox("Create Head Error1111", ls_Error + "~n~n" + ls_modify)
//	//	Return False
//	END IF
NEXT 

	
For i = 1 to ll_row_cnt 
		IF ls_shop_div <> dw_result.object.shop_div[i] THEN 
      ls_shop_div =  dw_result.object.shop_div[i] 
		ll_row      =  dw_list.insertRow(0)
    dw_list.Setitem(ll_row, "part_div",   ls_shop_div)

	for j = 1 to 8 
		dw_list.Setitem(ll_row, "in_qty_"  + String(j), 0)
		dw_list.Setitem(ll_row, "sale_qty_" + String(j), 0)
		dw_list.Setitem(ll_row, "stock_qty_" + String(j), 0)
	next
	 
	END IF 
	ls_find = "size = '" + dw_result.object.size[i] + "'"
   k = dw_assort.find(ls_find, 1, ll_assort_cnt)	
  

	IF k > 0 THEN 
		ll_out_qty = dw_result.GetitemNumber(i, "out_qty")
		ll_sale_qty = dw_result.GetitemNumber(i, "sale_qty")
		ll_stock_qty = dw_result.GetitemNumber(i, "stock_qty")
		dw_list.Setitem(ll_row, "in_qty_"  + String(k), ll_out_qty)
		dw_list.Setitem(ll_row, "sale_qty_" + String(k), ll_sale_qty)
		dw_list.Setitem(ll_row, "stock_qty_"  + String(k), ll_stock_qty)
//		if i - 1 > 0 then 
//      ls_modify = ' t_size'    + String(i - 1) + '.text= "' + dw_result.object.size[i] + '"' 
//   	end if
		if i> 0 then 
      ls_modify = ' t_size'    + String(i) + '.text= "' + dw_result.object.size[i] + '"' 
   	end if
		ls_Error = dw_list.Modify(ls_modify)
	
	 	if ll_max_k < k then	
  		 ll_max_k = k
   	end if
//		IF (ls_Error <> "") THEN 
//			MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
//		END IF

	END IF

Next


FOR i = 1  TO 8
	IF i > ll_max_k   THEN
      ls_modify = ' t_size'    + String(i) + '.Visible=0' + &
                  ' t_out'     + String(i) + '.Visible=0' + &
                  ' t_sale'    + String(i) + '.Visible=0' + &
                  ' t_stock'   + String(i) + '.Visible=0' + &
                  ' in_qty_'     + String(i) + '.Visible=0' + &
                  ' sale_qty_'    + String(i) + '.Visible=0' + &
                  ' stock_qty_'   + String(i) + '.Visible=0' + &
                  ' c_in_qty_'     + String(i) + '.Visible=0' + &
                  ' c_sale_qty_'    + String(i) + '.Visible=0' + &
                  ' c_stock_qty_'   + String(i) + '.Visible=0' 
						
						
     ls_Error = dw_list.Modify(ls_modify)			
//	  	IF (ls_Error <> "") THEN 
//		MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
//	//	Return False
//	END IF
	END IF
	

NEXT 



end subroutine

on w_43006_d.create
int iCurrent
call super::create
this.dw_result2=create dw_result2
this.dw_shop_div=create dw_shop_div
this.dw_detail=create dw_detail
this.dw_assort=create dw_assort
this.dw_color=create dw_color
this.dw_result=create dw_result
this.dw_1=create dw_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_result2
this.Control[iCurrent+2]=this.dw_shop_div
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.dw_assort
this.Control[iCurrent+5]=this.dw_color
this.Control[iCurrent+6]=this.dw_result
this.Control[iCurrent+7]=this.dw_1
this.Control[iCurrent+8]=this.dw_2
end on

on w_43006_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_result2)
destroy(this.dw_shop_div)
destroy(this.dw_detail)
destroy(this.dw_assort)
destroy(this.dw_color)
destroy(this.dw_result)
destroy(this.dw_1)
destroy(this.dw_2)
end on

event pfc_preopen();/*===========================================================================*/
/* 작성자      : 지우정보 (김태범) 														  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(st_1, "ScaleToBottom")
inv_resize.of_Register(dw_2, "ScaleToBottom")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_result.SetTransObject(SQLCA)
dw_result2.SetTransObject(SQLCA)
dw_shop_div.SetTransObject(SQLCA)
dw_assort.SetTransObject(SQLCA)
dw_color.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm , ls_style, ls_chno ,ls_bujin_chk, ls_dep_ymd, ls_dep_seq
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	
			CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				// 스타일 선별작업
				IF  gl_user_level = 0 then 
					gst_cd.default_where   = "WHERE   style like '" + gs_brand + "%'"	
				else 	
					gst_cd.default_where   = " WHERE  tag_price <> 0 "
				end if
				
			if gs_brand <> "K" then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
				ELSE
					gst_cd.Item_where = ""
				END IF
			else 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + as_data + "%' and style like 'K%' "
				ELSE
					gst_cd.Item_where = "style like 'K%'"
				END IF
				
			end if					
				
			

				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm

					dw_head.SetRow(al_row)
					dw_head.SetColumn(as_column)
            
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
								
  	   ls_style =  lds_Source.GetItemString(1,"style")
		ls_chno  = lds_Source.GetItemString(1,"chno")
		
		il_rows = dw_color.retrieve(ls_style, ls_chno)
		
				
				select isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX')
				into :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq
				from tb_12020_m
				where style = :ls_style;

  		if ls_bujin_chk = "Y" then 
			dw_head.setitem(1,"bujin_chk", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
		else	
			dw_head.setitem(1,"bujin_chk", "정상제품입니다!")
      end if 					
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("chno")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
//			END IF
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

event ue_retrieve();decimal ld_stock_qty
string  ls_chno
if  is_order_yn = 'S' then
	 ls_chno = '%'
else
	 ls_chno = is_chno
end if

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//IF wf_body_set() = FALSE THEN RETURN
//exec sp_43006_d01 '20011215', 'NF1WH803',	'0',	'62', 'c'
if LenA(is_style) = 8 then 
	il_rows = dw_result.retrieve(is_yymmdd,is_style, is_chno, is_color,is_order_yn)
	
	
	dw_1.retrieve(is_style, ls_chno, is_color)
	
	wf_retrieve_set()
	
	IF il_rows > 0 THEN
		dw_body.reset()
		dw_list.SetFocus()
	END IF
	This.Trigger Event ue_button(1, il_rows)
	This.Trigger Event ue_msg(1, il_rows)
		
	
else
	dw_2.retrieve(is_style)
end if

end event

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


is_yymmdd = dw_head.GetItemstring(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"조회기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if


is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
   MessageBox(ls_title,"스타일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style")
   return false
end if




if gs_brand = 'N' and (MidA(is_style,1,1) = 'O' or MidA(is_style,1,1) = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false
elseif gs_brand = 'O' and (MidA(is_style,1,1) = 'N' or MidA(is_style,1,1) = 'B' or MidA(is_style,1,1) = 'L' or MidA(is_style,1,1) = 'F' or MidA(is_style,1,1) = 'G'  or MidA(is_style,1,1) = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false	
elseif gs_brand = 'B' and (MidA(is_style,1,1) = 'O' or MidA(is_style,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false		
elseif gs_brand = 'G' and (MidA(is_style,1,1) = 'O' or MidA(is_style,1,1) = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("Style_no")
   return false			
end if	


is_chno = dw_head.GetItemString(1, "chno")
//if IsNull(is_chno) or Trim(is_chno) = "" then
//   is_chno = "%"
//   dw_head.SetFocus()
////   dw_head.SetColumn("color")
//  
//end if
//if IsNull(is_chno) or Trim(is_chno) = "" then
//   MessageBox(ls_title,"차수를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("chno")
//   return false
//end if

is_color = dw_head.GetItemString(1, "color")
if IsNull(is_color) or Trim(is_color) = "" then
   is_color = "%"
   dw_head.SetFocus()
//   dw_head.SetColumn("color")
  
end if

is_order_yn = dw_head.GetItemString(1, "order_yn")
//if IsNull(is_order_yn) or Trim(is_order_yn) = "" then
//   is_order_yn = "%"
//   dw_head.SetFocus()
//   dw_head.SetColumn("order_yn")
// 
//end if


return true

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43006_d","0")
end event

event ue_title();call super::ue_title;DateTime ld_datetime
String ls_modify, ls_datetime, ls_sale_type, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


ls_modify =	"t_pg_id.Text     = '" + is_pgm_id    + "'" + &
            "t_user_id.Text   = '" + gs_user_id   + "'" + &
            "t_datetime.Text  = '" + ls_datetime  + "'" + &
            "t_yymmdd.Text    = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_style.Text     = '" + is_style + "-" + is_chno + "'"  + &
            "t_color.Text     = '" + is_color + "'"  + &
            "t_yymmdd.Text   = '" + is_yymmdd + "'"  				

dw_print.Modify(ls_modify)

end event

type cb_close from w_com020_d`cb_close within w_43006_d
integer taborder = 180
end type

type cb_delete from w_com020_d`cb_delete within w_43006_d
integer taborder = 120
end type

type cb_insert from w_com020_d`cb_insert within w_43006_d
integer taborder = 90
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_43006_d
end type

type cb_update from w_com020_d`cb_update within w_43006_d
integer taborder = 170
end type

type cb_print from w_com020_d`cb_print within w_43006_d
integer taborder = 140
end type

type cb_preview from w_com020_d`cb_preview within w_43006_d
integer taborder = 150
boolean enabled = true
end type

type gb_button from w_com020_d`gb_button within w_43006_d
end type

type cb_excel from w_com020_d`cb_excel within w_43006_d
integer taborder = 160
boolean enabled = true
end type

type dw_head from w_com020_d`dw_head within w_43006_d
integer x = 9
integer y = 160
integer width = 2789
integer height = 296
string dataobject = "d_43006_h01"
end type

event dw_head::constructor;
  This.GetChild("color", idw_color )
  idw_color.SetTransObject(SQLCA)
  idw_color.Retrieve('%')

end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;string DWfilter, ls_style, ls_chno, ls_color, ls_type
long     i, j, ll_row_count, ll_row

CHOOSE CASE dwo.name

CASE "color" 
		
		ls_style = dw_body.getitemstring(row, "style")
		ls_chno  = dw_body.getitemstring(row, "chno")	
		
//		messagebox(is_style, ls_chno)
//		il_rows = dw_color.retrieve(ls_style, ls_chno)
		
			if il_rows > 0 then
				FOR i=1 TO il_rows
					  if i = il_rows then
						  ls_Type = ls_Type + "color = " +  "'" +  dw_color.getitemstring(i, "color") + "'"
					else
						  ls_Type = ls_Type + "color = " +  "'" +  dw_color.getitemstring(i, "color") + "'" + " or "
					end if	  
				next	
					 DWfilter = ls_Type
			END IF
			  idw_color.SetFilter(DWfilter)
			  idw_color.Filter()
		  
END CHOOSE



end event

event dw_head::itemchanged;call super::itemchanged;string DWfilter, ls_style, ls_chno, ls_color, ls_type, ls_in_ymd, ls_out_ymd, ls_sale_ymd, ls_order_yn
long     i, j, ll_row_count, ll_row

CHOOSE CASE dwo.name
	CASE "style" 
      IF ib_itemchanged THEN RETURN 1
		if LenA(data) = 8 then
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		end if


	CASE "order_yn" 
      ls_style = dw_head.getitemstring(row, "style")
		ls_chno  = dw_head.getitemstring(row, "chno")		
		
		if data = "S" then
		ls_chno  = "%"	
		is_chno  = "%"	
   	end if
	
		il_rows = dw_color.retrieve(ls_style, ls_chno)
		
			if il_rows > 0 then
				FOR i=1 TO il_rows
					  if i = il_rows then
						  ls_Type = ls_Type + "color = " +  "'" +  dw_color.getitemstring(i, "color") + "'"
					else
						  ls_Type = ls_Type + "color = " +  "'" +  dw_color.getitemstring(i, "color") + "'" + " or "
					end if	  
				next	
					 DWfilter = ls_Type
			END IF
			  idw_color.SetFilter(DWfilter)
			  idw_color.Filter()
	   
	  
    case "color"
		  ls_style = dw_head.getitemstring(row, "style")
		  ls_chno  = dw_head.getitemstring(row, "chno")
		  ls_color = data
		  ls_order_yn = dw_body.getitemstring(row, "order_yn")
		  if ls_order_yn = "S" then
			  ls_chno  = "%"
			  ls_color = "%"
		  end if	  
			
			select MIN(in_ymd), MIN(out_ymd), MIN(sale_ymd)
			into :ls_in_ymd, :ls_out_ymd, :ls_sale_ymd
			from tb_12030_s
			where style = :ls_style
			and  chno like :ls_chno
			and  color like :ls_color;
			
			dw_head.object.t_5.text = MidA(ls_in_ymd,1,4) + '/' + MidA(ls_in_ymd,5,2) + '/' + MidA(ls_in_ymd,7,2)
			dw_head.object.t_6.text = MidA(ls_out_ymd,1,4) + '/' + MidA(ls_out_ymd,5,2) + '/' + MidA(ls_out_ymd,7,2)
	   	dw_head.object.t_7.text = MidA(ls_sale_ymd,1,4) + '/' + MidA(ls_sale_ymd,5,2) + '/' + MidA(ls_sale_ymd,7,2)
		  
END CHOOSE


	
end event

type ln_1 from w_com020_d`ln_1 within w_43006_d
integer beginx = 5
integer beginy = 476
integer endx = 3643
integer endy = 476
end type

type ln_2 from w_com020_d`ln_2 within w_43006_d
integer beginx = 18
integer beginy = 480
integer endx = 3657
integer endy = 480
end type

type dw_list from w_com020_d`dw_list within w_43006_d
integer x = 631
integer y = 488
integer width = 2944
integer height = 808
integer taborder = 40
string dataobject = "d_43006_d01"
end type

event dw_list::doubleclicked;string ls_shop_div


/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

////exec sp_43006_d02 '20011215', 'nw1wj201','0','25','g','s'
ls_shop_div = MidA(dw_list.GetitemString(row, "part_div") ,1,1)

if IsNull(ls_shop_div) or Trim(ls_shop_div) = "" then
 ls_SHOP_DIV = "%"
end if


dw_body.setredraw(false)
il_rows = dw_result2.retrieve(is_yymmdd, is_style, is_chno, is_color,ls_shop_div,is_order_yn)

wf_retrieve_ser1()


dw_body.setredraw(true)

IF il_rows > 0 THEN
	
   dw_body.SetFocus()
END IF




end event

type dw_body from w_com020_d`dw_body within w_43006_d
integer x = 631
integer y = 1312
integer width = 2944
integer height = 684
integer taborder = 50
string dataobject = "d_43006_d02"
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_size, ls_retrieve_gubn, ls_gubn1, ls_gubn2, ls_object, ls_shop_cd, ls_txt

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//t_size1
ls_shop_cd = LeftA(dw_body.getitemstring(row, "part_div"),6)
ls_gubn1 = LeftA(dwo.name,2)  
ls_gubn2 = RightA(dwo.name,1)

ls_txt = "t_size" + ls_gubn2 + ".text"

ls_size = dw_body.Describe(ls_txt)

if ls_gubn1 = "in" then
	dw_detail.dataobject = "d_43006_d08"
	dw_detail.SetTransObject(SQLCA)
elseif ls_gubn1 = "sa" then	
	dw_detail.dataobject = "d_43006_d09"
	dw_detail.SetTransObject(SQLCA)
end if	

il_rows = dw_detail.retrieve(ls_shop_cd, is_style, is_color,ls_size, LeftA(is_style,1),is_chno)

IF il_rows > 0 THEN
	dw_detail.visible = true
   dw_detail.SetFocus()

END IF




end event

event dw_body::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

type st_1 from w_com020_d`st_1 within w_43006_d
boolean visible = false
boolean enabled = false
end type

type dw_print from w_com020_d`dw_print within w_43006_d
integer x = 2318
integer y = 1652
string dataobject = "d_43006_r02"
end type

type dw_result2 from datawindow within w_43006_d
boolean visible = false
integer x = 462
integer y = 1204
integer width = 1298
integer height = 668
integer taborder = 100
boolean titlebar = true
string title = "매장결과"
string dataobject = "d_43006_d06"
boolean border = false
boolean livescroll = true
end type

type dw_shop_div from datawindow within w_43006_d
boolean visible = false
integer x = 1659
integer y = 1212
integer width = 416
integer height = 612
integer taborder = 110
boolean titlebar = true
string title = "shop_div"
string dataobject = "d_43006_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_detail from datawindow within w_43006_d
boolean visible = false
integer x = 1367
integer y = 996
integer width = 2121
integer height = 1420
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "매장별 내역"
string dataobject = "d_43006_d09"
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event doubleclicked;this.visible = false
end event

type dw_assort from datawindow within w_43006_d
boolean visible = false
integer x = 1330
integer y = 1232
integer width = 242
integer height = 736
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "사이즈정보"
string dataobject = "d_43006_d05"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_color from datawindow within w_43006_d
boolean visible = false
integer x = 1774
integer y = 1552
integer width = 411
integer height = 432
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "color"
string dataobject = "d_43006_d07"
boolean border = false
boolean livescroll = true
end type

type dw_result from datawindow within w_43006_d
boolean visible = false
integer x = 2112
integer y = 1196
integer width = 1449
integer height = 668
integer taborder = 130
boolean bringtotop = true
boolean titlebar = true
string title = "실결과물"
string dataobject = "d_43006_d04"
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_43006_d
integer x = 2894
integer y = 160
integer width = 667
integer height = 304
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_43006_d10"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_43006_d
integer x = 32
integer y = 492
integer width = 590
integer height = 1504
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_43006_d11"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/



// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

event clicked;This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)



end event

event doubleclicked;string ls_style, ls_chno
ls_style = this.object.style[row]
ls_chno  = this.object.chno[row]

dw_head.setitem(1,"style",ls_style)
dw_head.setitem(1,"chno",ls_chno)

Parent.Trigger Event ue_retrieve()	//조회

end event

