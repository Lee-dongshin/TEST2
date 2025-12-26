$PBExportHeader$w_47001_e.srw
$PBExportComments$입점몰 데이터 입력
forward
global type w_47001_e from w_com010_e
end type
type dw_color from datawindow within w_47001_e
end type
type dw_size from datawindow within w_47001_e
end type
type st_1 from statictext within w_47001_e
end type
end forward

global type w_47001_e from w_com010_e
integer width = 3680
integer height = 2228
dw_color dw_color
dw_size dw_size
st_1 st_1
end type
global w_47001_e w_47001_e

type variables

DataWindowchild idw_color, idw_size
String is_yymmdd, is_file_nm, is_gubn
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
string  ls_data, ls_null, ls_gubn, ls_colcd, ls_real_size, ls_zip, ls_addr
Long    ll_FileLen,  ll_FileLen2, ll_found,ll_found2
string ls_yymmdd, ls_ord_ymd, ls_shop_cd, ls_cust_nm, ls_order_no, ls_no, ls_order_name, ls_order_mobile, ls_order_tel	
string ls_order_email, ls_receiver_name, ls_receiver_mobile	,ls_receiver_tel	,ls_style, ls_chno, ls_color, ls_size	, ls_null_v
string ls_sale_ymd, ls_invoice_no, ls_prod_no, ls_settle_ymd, ls_tran_ymd,ls_style_chk	, ls_db,ls_order_no_sub, ls_order_no_make, ls_style_nm, ls_brand_nm, ls_mall_name, ls_db_original
long ll_qty	
decimal ldc_supply_price, ldc_sale_price, ldc_erp_sale_price	



//IF dw_head.AcceptText() <> 1 THEN RETURN 
//IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//	

/* dw_head 필수입력 column check */
is_file_nm = dw_head.GetItemString(1, "file_nm") 
is_gubn   = dw_head.GetItemString(1, "gubn") 

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
				
				//DB	 1				
				li_find = PosA(ls_data,",")
				ls_db = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,600)
				//출력 2
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,600)
				//등록일 3
				li_find = PosA(ls_data,",")
				ls_yymmdd = MidA(Trim(MidA(ls_data, 1,li_find - 1)),1,4) + MidA(Trim(MidA(ls_data, 1,li_find - 1)),6,2) + MidA(Trim(MidA(ls_data, 1,li_find - 1)),9,2)
				ls_data =MidA(ls_data,li_find+1,600)
				//주문일 4
				li_find = PosA(ls_data,",")
				ls_ord_ymd = MidA(Trim(MidA(ls_data, 1,li_find - 1)),1,4) + MidA(Trim(MidA(ls_data, 1,li_find - 1)),6,2) + MidA(Trim(MidA(ls_data, 1,li_find - 1)),9,2)
				ls_data =MidA(ls_data,li_find+1,600)
				//결제일 5
				li_find = PosA(ls_data,",")
				ls_settle_ymd = MidA(Trim(MidA(ls_data, 1,li_find - 1)),1,4) + MidA(Trim(MidA(ls_data, 1,li_find - 1)),6,2) + MidA(Trim(MidA(ls_data, 1,li_find - 1)),9,2)
				ls_data =MidA(ls_data,li_find+1,600)
				//배송희망일 6
				li_find = PosA(ls_data,",")
				ls_tran_ymd = MidA(Trim(MidA(ls_data, 1,li_find - 1)),1,4) + MidA(Trim(MidA(ls_data, 1,li_find - 1)),6,2) + MidA(Trim(MidA(ls_data, 1,li_find - 1)),9,2)
				ls_data =MidA(ls_data,li_find+1,600)
				//등록자 7
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,600)
				//발주처 8
				li_find = PosA(ls_data,",")
				ls_cust_nm = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,600)
				//배송처 9
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,600)
				
				//style 10
				li_find = PosA(ls_data,",")
				ls_style = MidA(Trim(MidA(ls_data, 1,li_find - 1)),1,8)
				ls_chno  = MidA(Trim(MidA(ls_data, 1,li_find - 1)),9,1)
				ls_data =MidA(ls_data,li_find+1,600)				
				
					//반품의 경우 품번 칼라 사이즈 무시
				if is_gubn = "C" then 
					ls_style = "XXXXXXXX"
					ls_chno  = "X"
				end if	
				
				
				
				//color 11
				li_find = PosA(ls_data,",")
//				ls_color = mid(Trim(Mid(ls_data, 1,li_find - 1)),1,2)
				ls_colcd = Trim(MidA(ls_data, 1,li_find - 1)) 
				
				
//				select dbo.SF_eshop_ColCD(:ls_colcd)
//				into :ls_color
//				from dual;
				
					//반품의 경우 품번 칼라 사이즈 무시
				if is_gubn = "C" then 

					ls_color = 'XX'
				else 
						
					select dbo.SF_eshop_ColCD(:ls_colcd)
					into :ls_color
					from dual;
					
				end if	
				
				
				ls_data =MidA(ls_data,li_find+1,600)
				
				//size 12
				li_find = PosA(ls_data,",")
				
				if upper(MidA(Trim(MidA(ls_data, 1,li_find - 1)),1,2)) = "FR" then
					ls_size = "89"
				else	
					ls_size = MidA(Trim(MidA(ls_data, 1,li_find - 1)),1,2)
				end if				
				
				//반품의 경우 품번 칼라 사이즈 무시
				if is_gubn = "C" then 
					ls_size = 'XX'
				end if	
				
				
				ls_data =MidA(ls_data,li_find+1,600)
				
				
				//prod_no(몰별제품코드) 13
				li_find = PosA(ls_data,",")
				ls_prod_no = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)
				
			
				//수량 14
				li_find = PosA(ls_data,",")
				ll_qty = long(Trim(MidA(ls_data, 1,li_find - 1)))
				ls_data =MidA(ls_data,li_find+1,600)
				
				if ls_style + ls_chno = "GX2XX301S" and ls_ord_ymd >= "20130226"  then 
					ls_chno = "0"
					ll_qty = ll_qty * 3
				end if	
				
			   if ls_style + ls_chno = "GX3XX304G" and ls_ord_ymd >= "20130603"  then 
					ls_chno = "0"
					ll_qty = ll_qty * 2
				end if	

				
				
				
				//발주처공급가 15
				li_find = PosA(ls_data,",")
				ldc_supply_price = dec(Trim(MidA(ls_data, 1,li_find - 1)))
				ls_data =MidA(ls_data,li_find+1,600)
				
				//업체원가 16
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)
				
				//판매가 17
				li_find = PosA(ls_data,",")
				ldc_SALE_price = dec(Trim(MidA(ls_data, 1,li_find - 1)))
				ls_data =MidA(ls_data,li_find+1,600)
				
				//배송료 18
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)
				
				//착불 19
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)
				
				//주문번호 20
				li_find = PosA(ls_data,",")
				ls_order_no = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)
				
				//주문자 21
				li_find = PosA(ls_data,",")
				ls_order_name = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)
				
				//주문자휴대폰 22
				li_find = PosA(ls_data,",")
				ls_order_mobile = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)
				
				//주문자전화 23
				li_find = PosA(ls_data,",")
				ls_order_tel = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)
				
				//주문자메일 24
				li_find = PosA(ls_data,",")
				ls_order_email = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)
				
				//수령자 25
				li_find = PosA(ls_data,",")
				ls_receiver_name = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)
				
				//받는사람 26
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)		
				
				//수령자전화 27
				li_find = PosA(ls_data,",")
				ls_receiver_tel = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)	
				
				//수령자휴대폰 28
				li_find = PosA(ls_data,",")
				ls_receiver_mobile = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)
				
				//우편번호 29
				li_find = PosA(ls_data,",")
				ls_zip = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)		
				
				//주소 30				
				li_find = PosA(ls_data,",")
				ls_addr = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)	
				
				//배송메세지 31
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)		
				
				//어드민메세지 32
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)			
				
				//C/S메세지 33
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)	
				
				//카드메세지 34
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)		
				
				//발주확인 35
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)		
				
				
				
				//교환접수 36
				li_find = PosA(ls_data,",")
				ls_db_original = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)	
				
				//부주문번호 37				
				li_find = PosA(ls_data,",")
				ls_order_no_sub = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)			
				
				
				//취소확인 38
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)				
				
				
				//배송사 39
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)		
				
				
				//송장번호 40
				li_find = PosA(ls_data,",")
				ls_invoice_no = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)				
				
				
				//브랜드명 41 
				li_find = PosA(ls_data,",")
				ls_brand_nm = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)		
				
				
				
							
				//메이크샵주문번호 42 AP열 추가ㅣ 
				li_find = PosA(ls_data,",")
				
				if li_find = 0 then
					ls_order_no_make = Trim(ls_data)							
				else 
					ls_order_no_make = Trim(MidA(ls_data, 1,li_find - 1))					
				end if
				ls_data =MidA(ls_data,li_find+1,600)				
//				
				//상품명 43
				li_find = PosA(ls_data,",")
				ls_style_nm = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)				
				
				
//				 MESSAGEBOX("", STRING(LEN(ls_style_nm),"0000")) LEN(ls_style_nm) > 2
				
//				if  LEN(TRIM(ls_style_nm)) <= 2  THEN
//						MESSAGEBOX("ls_style_nm",  trim(ls_style_nm))
//				end if	



				
				//판매처 mall_name 44
				li_find = PosA(ls_data,",")
				if li_find = 0 then
					ls_mall_name = Trim(ls_data)							
				else 
					ls_mall_name = Trim(MidA(ls_data, 1,li_find - 1))					
				end if
				ls_data =MidA(ls_data,li_find+1,600)				
				
							
				
				//기타3 45
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)				
				//기타4 46
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)				
				//상태 47
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)				
				//구분 48
				li_find = PosA(ls_data,",")
				ls_null = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,600)				
				
//				dw_head.setitem(1, "yymmdd",  ls_yymmdd)			
				
				
				select dbo.sf_eshop_cd(:ls_cust_nm, substring(:ls_style,1,1))
				into :ls_shop_cd
				from dual;
				
				//반품의 경우 품번 칼라 사이즈 무시
				if is_gubn = "C" and ls_cust_nm <> "발주처" then 
					ls_shop_cd = 'XXXXXX'
				end if	
				
				
				if ll_found > 0 then
					messagebox("알림", ls_order_no)
				end if	


           	ll_found = dw_body.Find("yymmdd = '" + is_yymmdd + "'  and ord_ymd = '" + ls_ord_ymd + "' and shop_cd = '" + ls_shop_cd + "' and order_no = '" + ls_order_no + "' and style = '" + ls_style + "' and no = '" + ls_no + "'  and gubn = '" + is_gubn + "' ", &
					1, dw_body.RowCount()  )

//				if ll_found > 0 then
//					messagebox("알림", ls_order_no)
//				end if	

				select count(*)
				into :ll_found2
				from tb_45030_h (nolock)
				where yymmdd = :is_yymmdd 
				and ord_ymd  = :ls_ord_ymd 
				and shop_cd  = :ls_shop_cd 
				and order_no = :ls_order_no
				and no       = :ls_no
				and gubn     = :is_gubn; 
				
				if ll_found2 > 0 then
					messagebox("알림", "주문번호" + ls_order_no + " 가 중복되어 등록되지 않습니다!")
				end if					
				

				if ll_found2 = 0 or isnull(ll_found2) then
					if ll_found <= 0  then 		
						dw_body.insertrow(0)
						il_rows ++ 				
						dw_body.ScrollToRow(il_rows)
						dw_body.setitem(il_rows, "gubn",	is_gubn	)						
						dw_body.setitem(il_rows, "yymmdd",	is_yymmdd	)
						dw_body.setitem(il_rows, "ord_ymd",	ls_ord_ymd	)
						dw_body.setitem(il_rows, "shop_cd", ls_shop_cd	)
						dw_body.setitem(il_rows, "shop_nm", ls_cust_nm	)		
						
						if ( MidA(ls_shop_cd,2,5) = 'D1970'  or ls_shop_cd = 'VD1900' or ls_shop_cd = 'UD1900' or ls_shop_cd = 'RD1900' or ls_shop_cd = 'DD1900' or ls_shop_cd = 'WD1900' or ls_shop_cd = 'ID1900' or  ls_shop_cd = 'GD1902'  or ls_shop_cd = 'LD1900'  or ls_shop_cd = 'KD1900' or ls_shop_cd = 'FD1900' or ls_shop_cd = 'SD1900' or ls_shop_cd = 'GD190F'  or ls_shop_cd = 'HD1900'  or ls_shop_cd = 'GD1944' or ls_shop_cd = 'TD1900'  ) and LenA(trim(ls_order_no_sub)) <> LenA(trim(ls_order_no))  then
							dw_body.setitem(il_rows, "order_no",	ls_order_no_sub	) //ls_order_no_sub
							
						elseif ( ls_shop_cd = 'BD1900' or ls_shop_cd = 'GD1900'  )   then
							
							ls_order_no_make = gf_replacetext(ls_order_no_make, "[", "(")
							ls_order_no_make = gf_replacetext(ls_order_no_make, "]", ")")
							
							//messagebox("", ls_order_no_make)
						
							dw_body.setitem(il_rows, "order_no",	ls_order_no_make	) //ls_order_no_make							
						else 
							dw_body.setitem(il_rows, "order_no",	ls_order_no	) //ls_order_no
						end if							
					//	dw_body.setitem(il_rows, "order_no",	ls_order_no	)
						
						
						dw_body.setitem(il_rows, "no",	string(li_t,"0000")	)
						
						IF is_gubn = "A" then
							dw_body.setitem(il_rows, "proc_stat",	"00")
						elseif is_gubn = "B" then
							dw_body.setitem(il_rows, "proc_stat",	"01")	
						elseif is_gubn = "E" then
							dw_body.setitem(il_rows, "proc_stat",	"01")								
							
						else	
							dw_body.setitem(il_rows, "proc_stat",	"02")	
						end if	
						
						IF is_gubn = "A" then
							dw_body.setitem(il_rows, "rtrn_stat",	"00")
						elseif is_gubn = "B" then
							dw_body.setitem(il_rows, "rtrn_stat",	"00")
						elseif is_gubn = "E" then
							dw_body.setitem(il_rows, "rtrn_stat",	"00")							
						else	
							dw_body.setitem(il_rows, "rtrn_stat",	"01")
						end if	


						
						
						dw_body.setitem(il_rows, "rtrn_reason",	"00")
						dw_body.setitem(il_rows, "order_name",	ls_order_name	)
						dw_body.setitem(il_rows, "order_mobile",	ls_order_mobile	)
						dw_body.setitem(il_rows, "order_tel",	ls_order_tel	)
					//	dw_body.setitem(il_rows, "order_email",	ls_order_email	)
						dw_body.setitem(il_rows, "receiver_name",	ls_receiver_name	)
						dw_body.setitem(il_rows, "receiver_mobile",	ls_receiver_mobile	)
						dw_body.setitem(il_rows, "receiver_tel",	ls_receiver_tel	)
						dw_body.setitem(il_rows, "style",	ls_style	)
						dw_body.setitem(il_rows, "chno",	ls_chno	)
						dw_body.setitem(il_rows, "color",	ls_color	)
						
						
						select dbo.sf_real_size(:ls_style, :ls_chno, :ls_color, :ls_size)
						into :ls_real_size
						from dual;
						
						if isnull(ls_real_size) then
							ls_real_size = ls_size
						end if	
						
						dw_body.setitem(il_rows, "size",	ls_real_size	)
						dw_body.setitem(il_rows, "qty",	ll_qty	)
						dw_body.setitem(il_rows, "supply_price",	ldc_supply_price	)
						dw_body.setitem(il_rows, "sale_price",	ldc_sale_price	)
		//				dw_body.setitem(il_rows, "erp_sale_price",	0	)
		//				dw_body.setitem(il_rows, "sale_ymd",	sale_ymd	)
		
						if is_gubn = "C" then // 반품의 경우 반품 송장 입력
							dw_body.setitem(il_rows, "rtrn_invoice_no",	ls_invoice_no	)
						else	
							dw_body.setitem(il_rows, "invoice_no",	ls_invoice_no	)
						end if	
				
						
						dw_body.setitem(il_rows, "prod_no",	ls_prod_no	)
						dw_body.setitem(il_rows, "settle_ymd",	ls_settle_ymd	)
						dw_body.setitem(il_rows, "tran_ymd",	ls_tran_ymd	)		

						
						if is_gubn = "C" then //반품의 경우 품번체크 안함
							 ls_style_chk = "정상"
						else  
		 					 gf_style_chk1(ls_style, ls_chno, ls_color, ls_real_size, ls_style_chk)		
						end if						
						
						dw_body.Setitem(il_rows, "style_chk", ls_style_chk)
						
						dw_body.Setitem(il_rows, "zipcode", ls_zip)						
						dw_body.Setitem(il_rows, "addr", ls_addr)												
						dw_body.Setitem(il_rows, "db", ls_db)		
						dw_body.Setitem(il_rows, "db_origin", ls_db_original)	// 반품의 원출고 Db번호 입력													
						
						
					if  LenA(TRIM(ls_style_nm)) > 2  THEN
//						dw_body.Setitem(il_rows, "style_name", ls_null_v)		
//					ELSE	
						dw_body.Setitem(il_rows, "style_name", ls_style_nm)							
					end if	
						
					if  LenA(TRIM(ls_mall_name)) > 2  THEN
//						dw_body.Setitem(il_rows, "style_name", ls_null_v)		
//					ELSE	
						dw_body.Setitem(il_rows, "mall_name", ls_mall_name)							
					end if							
						

						if ls_style_chk <> '정상' then
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
				MEssagebox("중복확인", "총" + "" + string(il_rows) + "" + "건중 " + "" +  string(li_dup_chk) + "" + "개의 기입력된 데이터가 있습니다!" )			
			end if	
			ib_changed = true
			cb_update.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
		else	
			if li_dup_chk > 0 then
				MEssagebox("중복확인", "총" + "" + string(il_rows) + "" + "건중 " + "" +  string(li_dup_chk) + "" + "개의 기입력된 데이터가 있습니다!" )			
			end if	
			MEssagebox("오류확인", "총" + "" + string(il_rows) + "" + "건중 " + "" +  string(li_cnt_err) + "" + "개의 잘못된 데이터가 있습니다!" )			
		end if



end if

end subroutine

on w_47001_e.create
int iCurrent
call super::create
this.dw_color=create dw_color
this.dw_size=create dw_size
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_color
this.Control[iCurrent+2]=this.dw_size
this.Control[iCurrent+3]=this.st_1
end on

on w_47001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_color)
destroy(this.dw_size)
destroy(this.st_1)
end on

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymmdd, is_gubn)
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
long i, ll_row_count,li_cnt_err
string ls_style_chk
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
	
		ls_style_chk = dw_body.getitemstring(i, "style_chk")
		if ls_style_chk <> '정상' then
						li_cnt_err ++
		end if		
NEXT

if li_cnt_err = 0 then 
	il_rows = dw_body.Update(TRUE, FALSE)
	
	if il_rows = 1 then
		dw_body.ResetUpdate()
		commit  USING SQLCA;
	else
		rollback  USING SQLCA;
	end if

else 
	MEssagebox("오류확인", "총" + "" + string(ll_row_count) + "" + "건중 " + "" +  string(li_cnt_err) + "" + "개의 잘못된 데이터가 있습니다!" )
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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_gubn = dw_head.GetItemString(1, "gubn")

return true
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_47001_e","0")
end event

event pfc_preopen();call super::pfc_preopen;dw_color.SetTransObject(SQLCA)
dw_size.SetTransObject(SQLCA)
end event

event ue_preview();
long i, ll_row_count,li_cnt_err
string ls_db, ls_barcode
datetime ld_datetime


This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로

dw_print.retrieve(is_yymmdd, is_gubn)

ll_row_count = dw_print.RowCount()
//
//FOR i=1 TO ll_row_count
//		ls_db = dw_body.getitemstring(i, "db")
//		ls_barcode = f_barcode_code128(ls_db) 
//
//
//      dw_body.Setitem(i, "db_1", ls_barcode)
//   
//
//NEXT
//
dw_print.inv_printpreview.of_SetZoom()
end event

type cb_close from w_com010_e`cb_close within w_47001_e
end type

type cb_delete from w_com010_e`cb_delete within w_47001_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_47001_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_47001_e
end type

type cb_update from w_com010_e`cb_update within w_47001_e
end type

type cb_print from w_com010_e`cb_print within w_47001_e
end type

type cb_preview from w_com010_e`cb_preview within w_47001_e
end type

type gb_button from w_com010_e`gb_button within w_47001_e
end type

type cb_excel from w_com010_e`cb_excel within w_47001_e
end type

type dw_head from w_com010_e`dw_head within w_47001_e
integer y = 156
integer height = 140
string dataobject = "d_47001_h01"
end type

event dw_head::buttonclicking;call super::buttonclicking;/* 화일 탐색 */
string  ls_path, ls_file_nm
integer li_value

is_gubn = dw_head.getitemstring(1,"gubn")
is_yymmdd = dw_head.getitemstring(1,"yymmdd")

li_value = GetFileOpenName("Select File", ls_path, ls_file_nm, "CSV", "Csv Files (*.csv),*.csv")

IF li_value = 1 THEN 
	dw_head.Setitem(1, "file_nm", ls_path)	
	wf_getfile()	
END IF

parent.Trigger Event ue_button(1, li_value)
parent.Trigger Event ue_msg(1, li_value)
end event

type ln_1 from w_com010_e`ln_1 within w_47001_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_e`ln_2 within w_47001_e
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_e`dw_body within w_47001_e
integer y = 372
integer width = 3593
integer height = 1624
string dataobject = "d_47001_d01"
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

if is_gubn = "C" then
	ls_style_chk = "정상"
else 	
	gf_style_chk1(ls_style, ls_chno, ls_color, ls_size, ls_style_chk)		
end if
dw_body.Setitem(row, "style_chk", ls_style_chk)
end event

type dw_print from w_com010_e`dw_print within w_47001_e
integer x = 2487
integer y = 560
string dataobject = "d_47001_r02"
end type

type dw_color from datawindow within w_47001_e
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

type dw_size from datawindow within w_47001_e
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

type st_1 from statictext within w_47001_e
integer x = 859
integer y = 280
integer width = 2656
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "※ 파일을 올리기전에 주소에 포함되어 있는  쉼표(콤마  ,  )를 반드시 제거하세요!"
boolean focusrectangle = false
end type

