$PBExportHeader$w_47011_e.srw
$PBExportComments$입점몰 정산 데이터 입력
forward
global type w_47011_e from w_com010_e
end type
type dw_color from datawindow within w_47011_e
end type
type dw_size from datawindow within w_47011_e
end type
end forward

global type w_47011_e from w_com010_e
dw_color dw_color
dw_size dw_size
end type
global w_47011_e w_47011_e

type variables

DataWindowchild idw_color, idw_size, idw_shop_nm
String is_yymm, is_file_nm, is_shop_nm
end variables

forward prototypes
public subroutine wf_getfile ()
end prototypes

public subroutine wf_getfile ();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.10.04                                                  */	
/* 수정일      : 2001.10.04                                                  */
/*===========================================================================*/
integer li_FileNum, li_find, li_t,li_cnt_err, li_dup_chk
string  ls_data, ls_null, ls_text, ls_data_chk
Long    ll_FileLen,  ll_FileLen2, ll_found,ll_found2
string ls_yymmdd,  ls_shop_cd, ls_cust_nm, ls_order_no1,ls_order_no2, ls_no 	
string ls_style, ls_chno, ls_color, ls_size, ls_style_no	
long ll_qty	
decimal ldc_sale_price	



//IF dw_head.AcceptText() <> 1 THEN RETURN 
//IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//	

/* dw_head 필수입력 column check */
is_file_nm = dw_head.GetItemString(1, "file_nm") 


if LenA(is_file_nm) > 3 then
  
		li_FileNum = FileOpen(is_file_nm, LineMode!, Read!) 
		IF li_FileNum < 0 THEN
			MessageBox("오류", "해당 화일 열기 실패했습니다.") 
			RETURN
		END IF 
		
		dw_body.Reset()
		il_rows = 0 
		ll_FileLen = FileRead(li_FileNum, ls_data) 
	
		DO WHILE  ll_FileLen >= 0
		
			IF ll_FileLen > 5 THEN 
				li_t ++
				ls_no = string(li_t,"0000")
				ls_data = Upper(ls_data)	
				//주문번호1			
				li_find = PosA(ls_data,",")
				ls_order_no1 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,2000)
				//주문번호 2
				li_find = PosA(ls_data,",")
				ls_order_no2 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,2000)
				// 품명
				li_find = PosA(ls_data,",")
				ls_text = Trim(MidA(ls_data, 1,li_find - 1))
				
				select dbo.sf_style_find(:ls_text)
				into :ls_style_no
				from dual;
				
				
				if IsNull(ls_style_no) or Trim(ls_style_no) = "" then
					ls_style_no = "XXXXXXXXX"
				end if
				
				ls_style = LeftA(ls_style_no,8)
				ls_chno  = RightA(ls_style_no,1)
				
				if ls_style_no <> "XXXXXXXXX"  then
					select dbo.sf_eshop_cd(:is_shop_nm, substring(:ls_style_no,1,1))
					into :ls_shop_cd
					from dual;				
					
				else
					ls_shop_cd = "XXXXXX"
				end if
				
				
				ls_data =MidA(ls_data,li_find+1,2000)
				
				// 수량
				li_find = PosA(ls_data,",")

				
				if is_shop_nm = "롯데홈쇼핑" or is_shop_nm = "롯데홈쇼핑2" then 
					ll_qty = long(Trim(ls_data))
				else	
					ll_qty = long(Trim(MidA(ls_data, 1,li_find - 1)))
				end if	
				
				ls_data =MidA(ls_data,li_find+1,2000)
				
				
				// 판매가
				li_find = PosA(ls_data,",")
//				ldc_sale_price = dec(Trim(Mid(ls_data, 1,li_find - 1)))

				if is_shop_nm = "롯데홈쇼핑" or is_shop_nm = "롯데홈쇼핑2" then 
					select dbo.sf_first_price(:ls_style) * :ll_qty
					into :ldc_sale_price
					from dual;
				else	
					ldc_sale_price = dec(Trim(ls_data))
				end if	
				
				if	ls_order_no1 = "534713108" then
					messagebox("",ls_data)
				end if
				
				ls_data =MidA(ls_data,li_find+1,2000)
	
	
				if ll_qty < 0 and ldc_sale_price > 0 then
					ldc_sale_price = ldc_sale_price * -1
				elseif ll_qty > 0 and ldc_sale_price < 0 then	
					ll_qty = ll_qty * -1
				end if	
	
//				if ll_found > 0 then
//					messagebox("알림", ls_order_no)
//				end if	
//
//
//           	ll_found = dw_body.Find("yymm = '" + is_yymmdd + "'  and ord_ymd = '" + ls_ord_ymd + "' and shop_cd = '" + ls_shop_cd + "' and order_no = '" + ls_order_no + "' and style = '" + ls_style + "' and no = '" + ls_no + "'  and gubn = '" + is_gubn + "' ", &
//					1, dw_body.RowCount()  )
//	
	
				ll_found = 0
				
				select count(*)
				into :ll_found2
				from tb_45031_h (nolock)
				where yymm	 = :is_yymm 
				and shop_cd  = :ls_shop_cd 
				and order_no1 = :ls_order_no1
				and isnull(order_no2,'X') = isnull(:ls_order_no2,'X')
				and style     = :ls_style
				and chno      = :ls_chno	; 
				
				if ll_found2 > 0 then
					messagebox("알림", "주문번호" + ls_order_no1 + " 가 중복되어 등록되지 않습니다!")
				end if					
				

				if (ll_found2 = 0 or isnull(ll_found2)) and ls_style_no <> "XXXXXXXXX" then
					if ll_found <= 0  then 		
						dw_body.insertrow(0)
						il_rows ++ 				
						dw_body.setitem(il_rows, "yymm",	is_yymm	)
						dw_body.setitem(il_rows, "shop_cd", ls_shop_cd	)
						dw_body.setitem(il_rows, "shop_nm", is_shop_nm	)					
						dw_body.setitem(il_rows, "order_no1",	ls_order_no1	)
						dw_body.setitem(il_rows, "order_no2",	ls_order_no2	)						
						dw_body.setitem(il_rows, "no",	string(li_t,"0000")	)
						dw_body.setitem(il_rows, "style",	ls_style	)
						dw_body.setitem(il_rows, "chno",	ls_chno	)
						dw_body.setitem(il_rows, "qty",	ll_qty	)
						dw_body.setitem(il_rows, "sale_price",	ldc_sale_price	)
						
						if ls_style = "XXXXXXXX" then  
							ls_data_chk = "오류"
						else	
							ls_data_chk = "정상"							
						end if
						
						dw_body.setitem(il_rows, "data_chk",	ls_data_chk	)
						
						if ls_data_chk <> '정상' then
							li_cnt_err ++
						end if				
						
						
					end if			
				else	
					li_dup_chk ++
			   end if
				dw_body.SetItemStatus(ll_found, 0, Primary!, NewModified!)
			

			END IF			
			ll_FileLen = FileRead(li_FileNum, ls_data) 
		LOOP
				
		FILECLOSE(li_FileNum)
		
	
		if li_t > 0 and li_cnt_err = 0  then 
			if li_dup_chk > 0 then
				MEssagebox("확인", "총" + "" + string(il_rows) + "" + "건중 " + "" +  string(li_dup_chk) + "" + "개의 오류이거나 기입력된 데이터가 있습니다!" )			
			end if	
			ib_changed = true
			cb_update.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
		else	
			if li_dup_chk > 0 then
				MEssagebox("중복확인", "총" + "" + string(il_rows) + "" + "건중 " + "" +  string(li_dup_chk) + "" + "개의 오류이거나 기입력된 데이터가 있습니다!!" )			
			end if	
			MEssagebox("오류확인", "총" + "" + string(il_rows) + "" + "건중 " + "" +  string(li_cnt_err) + "" + "개의 잘못된 데이터가 있습니다!" )			
		end if



end if

end subroutine

on w_47011_e.create
int iCurrent
call super::create
this.dw_color=create dw_color
this.dw_size=create dw_size
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_color
this.Control[iCurrent+2]=this.dw_size
end on

on w_47011_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_color)
destroy(this.dw_size)
end on

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymm, is_shop_nm)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count,li_cnt_err,li_cnt_err1
string ls_data_chk
datetime ld_datetime

ll_row_count = dw_body.RowCount()


IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
	
//		ls_data_chk = dw_body.getitemstring(i, "style_chk")
//		if ls_style_chk <> '정상' then
//						li_cnt_err ++
//		end if		
NEXT

FOR i=1 TO ll_row_count
  ls_data_chk = dw_body.getitemstring(i, "data_chk")
		if ls_data_chk <> '정상' then
			li_cnt_err ++
			dw_body.DeleteRow(i)
//			messagebox("", string(i,"0000"))
		end if		
NEXT

FOR i=1 TO ll_row_count
  ls_data_chk = dw_body.getitemstring(i, "data_chk")
		if ls_data_chk <> '정상' then
			li_cnt_err1 ++			
		end if		
NEXT


if li_cnt_err1 = 0 then 
	il_rows = dw_body.Update(TRUE, FALSE)
	
	if il_rows = 1 then
		dw_body.ResetUpdate()
		commit  USING SQLCA;
	else
		rollback  USING SQLCA;
	end if

else 
	MEssagebox("오류확인", "총" + "" + string(ll_row_count) + "" + "건중 " + "" +  string(li_cnt_err) + "" + "개의 잘못된 데이터를 삭제했습니다!" )
end if	



This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"정산년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_shop_nm = dw_head.GetItemString(1, "shop_Nm")

return true
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_47011_e","0")
end event

type cb_close from w_com010_e`cb_close within w_47011_e
end type

type cb_delete from w_com010_e`cb_delete within w_47011_e
end type

type cb_insert from w_com010_e`cb_insert within w_47011_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_47011_e
end type

type cb_update from w_com010_e`cb_update within w_47011_e
end type

type cb_print from w_com010_e`cb_print within w_47011_e
end type

type cb_preview from w_com010_e`cb_preview within w_47011_e
end type

type gb_button from w_com010_e`gb_button within w_47011_e
end type

type cb_excel from w_com010_e`cb_excel within w_47011_e
end type

type dw_head from w_com010_e`dw_head within w_47011_e
integer height = 140
string dataobject = "d_47011_h01"
end type

event dw_head::buttonclicking;call super::buttonclicking;/* 화일 탐색 */
string  ls_path, ls_file_nm
integer li_value

is_shop_nm = dw_head.getitemstring(1,"shop_nm")
is_yymm = dw_head.getitemstring(1,"yymm")

li_value = GetFileOpenName("Select File", ls_path, ls_file_nm, "CSV", "Csv Files (*.csv),*.csv")

IF li_value = 1 THEN 
	dw_head.Setitem(1, "file_nm", ls_path)	
	wf_getfile()	
END IF

parent.Trigger Event ue_button(1, li_value)
parent.Trigger Event ue_msg(1, li_value)
end event

event dw_head::constructor;call super::constructor;This.GetChild("shop_nm", idw_shop_nm)
idw_shop_nm.SetTransObject(SQLCA)
idw_shop_nm.Retrieve()
idw_shop_nm.InsertRow(1)

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	

	ls_filter_str = "b_shop_stat = '00'" 
	idw_shop_nm.SetFilter(ls_filter_str)
	idw_shop_nm.Filter( )
end event

type ln_1 from w_com010_e`ln_1 within w_47011_e
integer beginy = 316
integer endy = 316
end type

type ln_2 from w_com010_e`ln_2 within w_47011_e
integer beginy = 320
integer endy = 320
end type

type dw_body from w_com010_e`dw_body within w_47011_e
integer y = 328
integer height = 1712
string dataobject = "d_47011_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;

  This.GetChild("color", idw_color )
  idw_color.SetTransObject(SQLCA)
  
  This.GetChild("size", idw_size )
  idw_color.SetTransObject(SQLCA)
end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;string DWfilter, ls_style, ls_chno, ls_color,ls_year,ls_season, ls_item, ls_sojae, ls_type,ls_style_chk, ls_size
long     i, j, ll_row_count, ll_row
decimal ldc_tag_price

ls_style = dw_body.getitemstring(row, "style")
ls_chno = dw_body.getitemstring(row, "chno")
ls_color = dw_body.getitemstring(row, "color")
ls_size = dw_body.getitemstring(row, "size")


CHOOSE CASE dwo.name

		
CASE "color" 
		ls_style = dw_body.getitemstring(row, "style")
		ls_chno  = dw_body.getitemstring(row, "chno")	
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
		  
CASE "size"
		ls_style = dw_body.getitemstring(row, "style")
		ls_chno  = dw_body.getitemstring(row, "chno")	
		ls_color = dw_body.getitemstring(row, "color")	
		
		il_rows = dw_size.retrieve(ls_style, ls_chno, ls_color)
		
			if il_rows > 0 then
				FOR i=1 TO il_rows
					  if i = il_rows then
						  ls_Type = ls_Type + "size = " +  "'" +  dw_size.getitemstring(i, "size") + "'"
					else
						  ls_Type = ls_Type + "size = " +  "'" +  dw_size.getitemstring(i, "size") + "'" + " or "
					end if	  
				next	
							
				 DWfilter = ls_Type
				
		  END IF
		  
		  idw_size.SetFilter(DWfilter)
		  idw_size.Filter()
	


END CHOOSE

gf_style_chk1(ls_style, ls_chno, ls_color, ls_size, ls_style_chk)		
dw_body.Setitem(row, "style_chk", ls_style_chk)
end event

type dw_print from w_com010_e`dw_print within w_47011_e
integer x = 2487
integer y = 560
end type

type dw_color from datawindow within w_47011_e
boolean visible = false
integer x = 2752
integer y = 948
integer width = 366
integer height = 428
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_43015_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_size from datawindow within w_47011_e
boolean visible = false
integer x = 3141
integer y = 944
integer width = 411
integer height = 432
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_43015_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

