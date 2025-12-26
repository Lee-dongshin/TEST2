$PBExportHeader$w_52023_e.srw
$PBExportComments$코디디자인배분(오더배분)
forward
global type w_52023_e from w_com010_e
end type
type dw_assort from datawindow within w_52023_e
end type
type st_remark from statictext within w_52023_e
end type
type dw_order from datawindow within w_52023_e
end type
type dw_temp1 from datawindow within w_52023_e
end type
type dw_temp2 from datawindow within w_52023_e
end type
type dw_temp3 from datawindow within w_52023_e
end type
type dw_temp4 from datawindow within w_52023_e
end type
type dw_order2 from datawindow within w_52023_e
end type
type dw_order3 from datawindow within w_52023_e
end type
type dw_order4 from datawindow within w_52023_e
end type
type dw_deal1 from datawindow within w_52023_e
end type
type dw_deal2 from datawindow within w_52023_e
end type
type dw_deal3 from datawindow within w_52023_e
end type
type dw_deal4 from datawindow within w_52023_e
end type
type dw_assort2 from datawindow within w_52023_e
end type
type dw_assort3 from datawindow within w_52023_e
end type
type dw_assort4 from datawindow within w_52023_e
end type
type dw_1 from datawindow within w_52023_e
end type
end forward

global type w_52023_e from w_com010_e
integer height = 2276
dw_assort dw_assort
st_remark st_remark
dw_order dw_order
dw_temp1 dw_temp1
dw_temp2 dw_temp2
dw_temp3 dw_temp3
dw_temp4 dw_temp4
dw_order2 dw_order2
dw_order3 dw_order3
dw_order4 dw_order4
dw_deal1 dw_deal1
dw_deal2 dw_deal2
dw_deal3 dw_deal3
dw_deal4 dw_deal4
dw_assort2 dw_assort2
dw_assort3 dw_assort3
dw_assort4 dw_assort4
dw_1 dw_1
end type
global w_52023_e w_52023_e

type variables
DataWindowChild idw_color1, idw_color2, idw_color3, idw_color4, idw_deal_type,idw_shop_lv,idw_area_cd,idw_shop_lv1

String  is_yymmdd 
Long    il_deal_seq
Boolean ib_NewDeal
String  is_style1, is_chno1,is_style2, is_chno2,is_style3, is_chno3,is_style4, is_chno4
String  is_color1, is_color2, is_color3, is_color4
string  is_deal_type
end variables

forward prototypes
public function boolean wf_body_set ()
public function boolean wf_update_1 ()
public function boolean wf_update_3 ()
public function boolean wf_update_4 ()
public function boolean wf_deal_2 ()
public function boolean wf_deal_3 ()
public function boolean wf_deal_4 ()
public function boolean wf_update_2 ()
public subroutine wf_retrieve_2 ()
public subroutine wf_retrieve_3 ()
public subroutine wf_retrieve_4 ()
public subroutine wf_add_stock ()
public function boolean wf_deal_1 ()
public subroutine wf_retrieve_set ()
public function boolean wf_temp_set ()
public subroutine wf_retrieve_1 ()
end prototypes

public function boolean wf_body_set ();String  ls_modify,   ls_error, ls_modify1, ls_error1
String  ls_size 
Long    ll_stock_qty, ll_row
integer i, k,h, l

/* assort구성 */
h = 0

	if is_color1  <> "ZZ" then
		h = h + 1
			if is_color2  <> "ZZ" then
				h = h +1
					if is_color3  <> "ZZ" then
						h = h +1
						if is_color4  <> "ZZ" then
							h = h +1
						end if	
					end if		
			end if	
	end if	
	
if is_style1  <> "XXXXXXXX" then
		l = l + 1
			if is_style2  <> "XXXXXXXX" then
				l = l + 1
					if is_style3  <> "XXXXXXXX" then
						l = l + 1 
						if is_style4  <> "XXXXXXXX" then
							l = l + 1
						end if	
					end if		
			end if	
	end if	



/* 사이즈 셋 */

dw_body.SetRedraw(False)

FOR i = 1 TO 4
	IF i > h THEN
      ls_modify = ' t_color_'       + String(i) + '.Visible=0' + &
                  ' t_s1_'          + String(i) + '.Visible=0' + &
                  ' t_s2_'          + String(i) + '.Visible=0' + &
                  ' t_s3_'          + String(i) + '.Visible=0' + &
                  ' t_s4_'          + String(i) + '.Visible=0' + &
                  ' t_s155_'        + String(i) + '.Visible=0' + &
                  ' t_s166_'        + String(i) + '.Visible=0' + &
                  ' t_s177_'        + String(i) + '.Visible=0' + &						
                  ' t_s255_'        + String(i) + '.Visible=0' + &
                  ' t_s266_'        + String(i) + '.Visible=0' + &
                  ' t_s277_'        + String(i) + '.Visible=0' + &												
                  ' t_s355_'        + String(i) + '.Visible=0' + &
                  ' t_s366_'        + String(i) + '.Visible=0' + &
                  ' t_s377_'        + String(i) + '.Visible=0' + &												
	               ' t_s455_'        + String(i) + '.Visible=0' + &
                  ' t_s466_'        + String(i) + '.Visible=0' + &
                  ' t_s477_'        + String(i) + '.Visible=0' + &												
                  ' c_s155_'        + String(i) + '.Visible=0' + &
                  ' c_s166_'        + String(i) + '.Visible=0' + &
                  ' c_s177_'        + String(i) + '.Visible=0' + &						
                  ' c_s255_'        + String(i) + '.Visible=0' + &
                  ' c_s266_'        + String(i) + '.Visible=0' + &
                  ' c_s277_'        + String(i) + '.Visible=0' + &						
                  ' c_s355_'        + String(i) + '.Visible=0' + &
                  ' c_s366_'        + String(i) + '.Visible=0' + &
                  ' c_s377_'        + String(i) + '.Visible=0' + &						
                  ' c_s455_'        + String(i) + '.Visible=0' + &
                  ' c_s466_'        + String(i) + '.Visible=0' + &	
                  ' c_s477_'        + String(i) + '.Visible=0' + &	
                  ' t_sd155_'		   + String(i) + '.Visible=0' + &	
                  ' t_sd166_'		   + String(i) + '.Visible=0' + &	
                  ' t_sd177_'		   + String(i) + '.Visible=0' + &	
                  ' t_sd255_'		   + String(i) + '.Visible=0' + &	
                  ' t_sd266_'		   + String(i) + '.Visible=0' + &	
                  ' t_sd277_'		   + String(i) + '.Visible=0' + &							
                  ' t_sd355_'		   + String(i) + '.Visible=0' + &	
                  ' t_sd366_'		   + String(i) + '.Visible=0' + &	
                  ' t_sd377_'		   + String(i) + '.Visible=0' + &							
                  ' t_sd455_'		   + String(i) + '.Visible=0' + &	
                  ' t_sd466_'		   + String(i) + '.Visible=0' + &	
                  ' t_sd477_'		   + String(i) + '.Visible=0' + &							
                  ' t_sp155_'		   + String(i) + '.Visible=0' + &	
                  ' t_sp166_'		   + String(i) + '.Visible=0' + &	
                  ' t_sp177_'		   + String(i) + '.Visible=0' + &	
                  ' t_sp255_'		   + String(i) + '.Visible=0' + &	
                  ' t_sp266_'		   + String(i) + '.Visible=0' + &	
                  ' t_sp277_'		   + String(i) + '.Visible=0' + &							
                  ' t_sp355_'		   + String(i) + '.Visible=0' + &	
                  ' t_sp366_'		   + String(i) + '.Visible=0' + &	
                  ' t_sp377_'		   + String(i) + '.Visible=0' + &							
                  ' t_sp455_'		   + String(i) + '.Visible=0' + &	
                  ' t_sp466_'		   + String(i) + '.Visible=0' + &	
                  ' t_sp477_'		   + String(i) + '.Visible=0' + &													
						' s1_deal55_qty_' + String(i) + '.Visible=0' + &	
						' s1_deal66_qty_' + String(i) + '.Visible=0' + &	
						' s1_deal77_qty_' + String(i) + '.Visible=0' + &							
						' s2_deal55_qty_' + String(i) + '.Visible=0' + &	
						' s2_deal66_qty_' + String(i) + '.Visible=0' + &	
						' s2_deal77_qty_' + String(i) + '.Visible=0' + &							
						' s3_deal55_qty_' + String(i) + '.Visible=0' + &	
						' s3_deal66_qty_' + String(i) + '.Visible=0' + &	
						' s3_deal77_qty_' + String(i) + '.Visible=0' + &							
						' s4_deal55_qty_' + String(i) + '.Visible=0' + &	
						' s4_deal66_qty_' + String(i) + '.Visible=0' + &	
						' s4_deal77_qty_' + String(i) + '.Visible=0' 						
   ELSE
      ls_modify = ' t_color_'       + String(i) + '.Visible=1' + &
                  ' t_s1_'          + String(i) + '.Visible=1' + &
                  ' t_s2_'          + String(i) + '.Visible=1' + &
                  ' t_s3_'          + String(i) + '.Visible=1' + &
                  ' t_s4_'          + String(i) + '.Visible=1' + &
                  ' t_s155_'        + String(i) + '.Visible=1' + &
                  ' t_s166_'        + String(i) + '.Visible=1' + &
                  ' t_s177_'        + String(i) + '.Visible=1' + &						
                  ' t_s255_'        + String(i) + '.Visible=1' + &
                  ' t_s266_'        + String(i) + '.Visible=1' + &
                  ' t_s277_'        + String(i) + '.Visible=1' + &												
                  ' t_s355_'        + String(i) + '.Visible=1' + &
                  ' t_s366_'        + String(i) + '.Visible=1' + &
                  ' t_s377_'        + String(i) + '.Visible=1' + &												
	               ' t_s455_'        + String(i) + '.Visible=1' + &
                  ' t_s466_'        + String(i) + '.Visible=1' + &
                  ' t_s477_'        + String(i) + '.Visible=1' + &
                  ' t_sd155_'		   + String(i) + '.Visible=1' + &	
                  ' t_sd166_'		   + String(i) + '.Visible=1' + &	
                  ' t_sd177_'		   + String(i) + '.Visible=1' + &	
                  ' t_sd255_'		   + String(i) + '.Visible=1' + &	
                  ' t_sd266_'		   + String(i) + '.Visible=1' + &	
                  ' t_sd277_'		   + String(i) + '.Visible=1' + &							
                  ' t_sd355_'		   + String(i) + '.Visible=1' + &	
                  ' t_sd366_'		   + String(i) + '.Visible=1' + &	
                  ' t_sd377_'		   + String(i) + '.Visible=1' + &							
                  ' t_sd455_'		   + String(i) + '.Visible=1' + &	
                  ' t_sd466_'		   + String(i) + '.Visible=1' + &	
                  ' t_sd477_'		   + String(i) + '.Visible=1' + &	
                  ' t_sp155_'		   + String(i) + '.Visible=1' + &	
                  ' t_sp166_'		   + String(i) + '.Visible=1' + &	
                  ' t_sp177_'		   + String(i) + '.Visible=1' + &	
                  ' t_sp255_'		   + String(i) + '.Visible=1' + &	
                  ' t_sp266_'		   + String(i) + '.Visible=1' + &	
                  ' t_sp277_'		   + String(i) + '.Visible=1' + &							
                  ' t_sp355_'		   + String(i) + '.Visible=1' + &	
                  ' t_sp366_'		   + String(i) + '.Visible=1' + &	
                  ' t_sp377_'		   + String(i) + '.Visible=1' + &							
                  ' t_sp455_'		   + String(i) + '.Visible=1' + &	
                  ' t_sp466_'		   + String(i) + '.Visible=1' + &	
                  ' t_sp477_'		   + String(i) + '.Visible=1' + &													
                  ' t_sd155_'		   + String(i) + '.text= ""' + &	
                  ' t_sd166_'		   + String(i) + '.text= ""' + &	
                  ' t_sd177_'		   + String(i) + '.text= ""' + &	
                  ' t_sd255_'		   + String(i) + '.text= ""' + &	
                  ' t_sd266_'		   + String(i) + '.text= ""' + &	
                  ' t_sd277_'		   + String(i) + '.text= ""' + &							
                  ' t_sd355_'		   + String(i) + '.text= ""' + &	
                  ' t_sd366_'		   + String(i) + '.text= ""' + &	
                  ' t_sd377_'		   + String(i) + '.text= ""' + &							
                  ' t_sd455_'		   + String(i) + '.text= ""' + &	
                  ' t_sd466_'		   + String(i) + '.text= ""' + &	
                  ' t_sd477_'		   + String(i) + '.text= ""' + &							
                  ' t_sp155_'		   + String(i) + '.text= ""' + &	
                  ' t_sp166_'		   + String(i) + '.text= ""' + &	
                  ' t_sp177_'		   + String(i) + '.text= ""' + &	
                  ' t_sp255_'		   + String(i) + '.text= ""' + &	
                  ' t_sp266_'		   + String(i) + '.text= ""' + &	
                  ' t_sp277_'		   + String(i) + '.text= ""' + &							
                  ' t_sp355_'		   + String(i) + '.text= ""' + &	
                  ' t_sp366_'		   + String(i) + '.text= ""' + &	
                  ' t_sp377_'		   + String(i) + '.text= ""' + &							
                  ' t_sp455_'		   + String(i) + '.text= ""' + &	
                  ' t_sp466_'		   + String(i) + '.text= ""' + &	
                  ' t_sp477_'		   + String(i) + '.text= ""' + &													
                  ' c_s155_'        + String(i) + '.Visible=1' + &
                  ' c_s166_'        + String(i) + '.Visible=1' + &
                  ' c_s177_'        + String(i) + '.Visible=1' + &						
                  ' c_s255_'        + String(i) + '.Visible=1' + &
                  ' c_s266_'        + String(i) + '.Visible=1' + &
                  ' c_s277_'        + String(i) + '.Visible=1' + &						
                  ' c_s355_'        + String(i) + '.Visible=1' + &
                  ' c_s366_'        + String(i) + '.Visible=1' + &
                  ' c_s377_'        + String(i) + '.Visible=1' + &						
                  ' c_s455_'        + String(i) + '.Visible=1' + &
                  ' c_s466_'        + String(i) + '.Visible=1' + &	
                  ' c_s477_'        + String(i) + '.Visible=1' + &							
						' s1_deal55_qty_' + String(i) + '.Visible=1' + &	
						' s1_deal66_qty_' + String(i) + '.Visible=1' + &	
						' s1_deal77_qty_' + String(i) + '.Visible=1' + &							
						' s2_deal55_qty_' + String(i) + '.Visible=1' + &	
						' s2_deal66_qty_' + String(i) + '.Visible=1' + &	
						' s2_deal77_qty_' + String(i) + '.Visible=1' + &							
						' s3_deal55_qty_' + String(i) + '.Visible=1' + &	
						' s3_deal66_qty_' + String(i) + '.Visible=1' + &	
						' s3_deal77_qty_' + String(i) + '.Visible=1' + &							
						' s4_deal55_qty_' + String(i) + '.Visible=1' + &	
						' s4_deal66_qty_' + String(i) + '.Visible=1' + &	
						' s4_deal77_qty_' + String(i) + '.Visible=1' 	
	END IF

      ls_modify = ls_modify +    ' t_s1_'          + String(i) + '.text="' + is_style1 + '"' + &
											' t_s2_'          + String(i) + '.text="' + is_style2 + '"' + &
											' t_s3_'          + String(i) + '.text="' + is_style3 + '"' + &				
											' t_s4_'          + String(i) + '.text="' + is_style4 + '"' 
											
	   IF i > l THEN
	  	ls_modify = ls_modify + ' s'+ string(i) + '_deal55_qty_1.Visible=0' + &	
										' s'+ string(i) + '_deal55_qty_2.Visible=0' + &	
										' s'+ string(i) + '_deal55_qty_3.Visible=0' + &							
										' s'+ string(i) + '_deal55_qty_4.Visible=0' + &
									   ' s'+ string(i) + '_deal66_qty_1.Visible=0' + &	
										' s'+ string(i) + '_deal66_qty_2.Visible=0' + &	
										' s'+ string(i) + '_deal66_qty_3.Visible=0' + &							
										' s'+ string(i) + '_deal66_qty_4.Visible=0' + &
										' s'+ string(i) + '_deal77_qty_1.Visible=0' + &	
										' s'+ string(i) + '_deal77_qty_2.Visible=0' + &	
										' s'+ string(i) + '_deal77_qty_3.Visible=0' + &							
										' s'+ string(i) + '_deal77_qty_4.Visible=0' 
		end if 				
		
		
								
      if i = 1 then 
         ls_modify = ls_modify + ' t_color_'  + String(i) + '.text="' + idw_color1.GetItemString(idw_color1.GetRow(), "color_display") + '"'  
		elseif i = 2 then	
         ls_modify = ls_modify + ' t_color_'  + String(i) + '.text="' + idw_color2.GetItemString(idw_color2.GetRow(), "color_display") + '"'  
		elseif i = 3 then	
         ls_modify = ls_modify + ' t_color_'  + String(i) + '.text="' + idw_color3.GetItemString(idw_color3.GetRow(), "color_display") + '"'  
		elseif i = 4 then	
         ls_modify = ls_modify + ' t_color_'  + String(i) + '.text="' + idw_color4.GetItemString(idw_color4.GetRow(), "color_display") + '"' 	 
		end if	

  
	ls_Error = dw_body.Modify(ls_modify)
	IF (ls_Error <> "") THEN 
		MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
		Return False
	END IF
	
NEXT 

dw_body.SetRedraw(true)

Return True 

end function

public function boolean wf_update_1 ();/* 배분 처리 */
/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.01.30                                                  */
/*===========================================================================*/
long     i, k, ll_row_count, ll_assort_cnt, ll_find, ll_deal_qty , j, h
datetime ld_datetime
String   ls_shop_cd, ls_color, ls_size, ls_find, ls_size1
String   ls_out_ymd

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN false
   dw_1.AcceptText() 

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return false
END IF

/* ORDER량 초과배분 여부 체크 */ 
FOR k = 1 TO dw_ASSORT.RowCount()
	 ls_color = dw_assort.getitemstring(k, "color")	
	 ls_size = dw_assort.getitemstring(k, "size")	 
	 
	 
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if		
		

	 if ls_color = is_color1 then
  	    h = 1
 	 elseif ls_color = is_color2 then
 	    h = 2
 	 elseif ls_color = is_color3 then
 	    h = 3
 	 elseif ls_color = is_color4 then
 	    h = 4		  
  	 end if 
		
	 ll_deal_qty = dw_body.GetitemNumber(1, "c_s1" + ls_size1 + "_" + string(h)) 	

	 IF ll_deal_qty > dw_assort.Object.ord_qty[k] THEN 
		
		 MessageBox("오류", "[" + is_style1 + dw_assort.GetitemString(k, "color") + "/" + & 
		                     dw_assort.GetitemString(k, "size") + "] 배분량이 초과 하였습니다,")
		 
		 Return false
	 END IF
NEXT


ll_assort_cnt = dw_assort.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! OR idw_status = DataModified! THEN	
		ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
      FOR k = 1 TO ll_assort_cnt 
				 ls_color = dw_assort.getitemstring(k, "color")	
				 ls_size  = dw_assort.getitemstring(k, "size")	 
							 
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if		
			
				 if ls_color = is_color1 then
					 h = 1
				 elseif ls_color = is_color2 then
					 h = 2
				 elseif ls_color = is_color3 then
					 h = 3
				 elseif ls_color = is_color4 then
					 h = 4		  
				 end if 
	
			IF dw_body.GetItemStatus(i, "s1_deal" + ls_size1 + "_qty_" + string(h), Primary!) = DataModified! THEN 
				ll_deal_qty = dw_body.GetitemNumber(i, "s1_deal" + ls_size1 + "_qty_" + string(h))
				ls_find  = "shop_cd = '" + ls_shop_cd + "' and color = '" + ls_color + "' and size = '" + ls_size + "'"
				ll_find = dw_order.find(ls_find, 1, dw_order.RowCount())
				IF ll_find > 0 THEN
					dw_order.Setitem(ll_find, "deal_qty", ll_deal_qty)
               dw_order.Setitem(ll_find, "mod_id",   gs_user_id)
               dw_order.Setitem(ll_find, "mod_dt",   ld_datetime)
				ELSE
					ll_find = dw_order.insertRow(0)
               dw_order.Setitem(ll_find, "style",    is_style1)
               dw_order.Setitem(ll_find, "chno",     is_chno1)
               dw_order.Setitem(ll_find, "shop_cd",  ls_shop_cd)
               dw_order.Setitem(ll_find, "color",    ls_color)
               dw_order.Setitem(ll_find, "size",     ls_size)
               dw_order.Setitem(ll_find, "deal_qty", ll_deal_qty)
		         dw_order.Setitem(ll_find, "out_ymd",  is_yymmdd)					
               dw_order.Setitem(ll_find, "reg_id",   gs_user_id)
				END IF
			END IF
		NEXT
   END IF
NEXT

Return True

end function

public function boolean wf_update_3 ();/* 배분 처리 */

long     i, k, ll_row_count, ll_assort_cnt, ll_find, ll_deal_qty , j, h
datetime ld_datetime
String   ls_shop_cd, ls_color, ls_size, ls_find, ls_size1
String   ls_out_ymd

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN false


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return false
END IF

/* ORDER량 초과배분 여부 체크 */ 
FOR k = 1 TO dw_ASSORT3.RowCount()
	 ls_color = dw_assort3.getitemstring(k, "color")	
	 ls_size = dw_assort3.getitemstring(k, "size")	 
	 
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if		


	 if ls_color = is_color1 then
  	    h = 1
 	 elseif ls_color = is_color2 then
 	    h = 2
 	 elseif ls_color = is_color3 then
 	    h = 3
 	 elseif ls_color = is_color4 then
 	    h = 4		  
  	 end if 
		
	 ll_deal_qty = dw_body.GetitemNumber(1, "c_s3" + ls_size1 + "_" + string(h)) 	

	 IF ll_deal_qty > dw_assort3.Object.ord_qty[k] THEN 
		
		 MessageBox("오류", "["  + is_style3 + dw_assort3.GetitemString(k, "color") + "/" + & 
		                     dw_assort3.GetitemString(k, "size") + "] 배분량이 초과 하였습니다,")
		 
		 Return false
	 END IF
NEXT


ll_assort_cnt = dw_assort3.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! OR idw_status = DataModified! THEN	
		ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
      FOR k = 1 TO ll_assort_cnt 
				 ls_color = dw_assort3.getitemstring(k, "color")	
				 ls_size  = dw_assort3.getitemstring(k, "size")	 
			
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if		

				 if ls_color = is_color1 then
					 h = 1
				 elseif ls_color = is_color2 then
					 h = 2
				 elseif ls_color = is_color3 then
					 h = 3
				 elseif ls_color = is_color4 then
					 h = 4		  
				 end if 
	
			IF dw_body.GetItemStatus(i, "s3_deal" + ls_size1 + "_qty_" + string(h), Primary!) = DataModified! THEN 
				ll_deal_qty = dw_body.GetitemNumber(i, "s3_deal" + ls_size1 + "_qty_" + string(h))
				ls_find  = "shop_cd = '" + ls_shop_cd + "' and color = '" + ls_color + "' and size = '" + ls_size + "'"
				ll_find = dw_order3.find(ls_find, 1, dw_order3.RowCount())
				IF ll_find > 0 THEN
					dw_order3.Setitem(ll_find, "deal_qty", ll_deal_qty)
               dw_order3.Setitem(ll_find, "mod_id",   gs_user_id)
               dw_order3.Setitem(ll_find, "mod_dt",   ld_datetime)
				ELSE
					ll_find = dw_order3.insertRow(0)
               dw_order3.Setitem(ll_find, "style",    is_style3)
               dw_order3.Setitem(ll_find, "chno",     is_chno3)
               dw_order3.Setitem(ll_find, "shop_cd",  ls_shop_cd)
               dw_order3.Setitem(ll_find, "color",    ls_color)
               dw_order3.Setitem(ll_find, "size",     ls_size)
               dw_order3.Setitem(ll_find, "deal_qty", ll_deal_qty)
		         dw_order3.Setitem(ll_find, "out_ymd",  is_yymmdd)					
               dw_order3.Setitem(ll_find, "reg_id",   gs_user_id)
				END IF
			END IF
		NEXT
   END IF
NEXT

//
//il_rows = dw_order3.Update()
//
//if il_rows = 1 then
//  //  commit  USING SQLCA;
//  messagebox("저장", "오케바리!")
//else
//   Return false
//   rollback  USING SQLCA;
//end if
//

Return True

end function

public function boolean wf_update_4 ();/* 배분 처리 */

long     i, k, ll_row_count, ll_assort_cnt, ll_find, ll_deal_qty , j, h
datetime ld_datetime
String   ls_shop_cd, ls_color, ls_size, ls_find, ls_size1
String   ls_out_ymd

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN false


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return false
END IF

/* ORDER량 초과배분 여부 체크 */ 
FOR k = 1 TO dw_ASSORT4.RowCount()
	 ls_color = dw_assort4.getitemstring(k, "color")	
	 ls_size = dw_assort4.getitemstring(k, "size")	 

	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if		

	 if ls_color = is_color1 then
  	    h = 1
 	 elseif ls_color = is_color2 then
 	    h = 2
 	 elseif ls_color = is_color3 then
 	    h = 3
 	 elseif ls_color = is_color4 then
 	    h = 4		  
  	 end if 
		
	 ll_deal_qty = dw_body.GetitemNumber(1, "c_s4" + ls_size1 + "_" + string(h)) 	

	 IF ll_deal_qty > dw_assort4.Object.ord_qty[k] THEN 
		
		 MessageBox("오류", "["  + is_style4 + dw_assort4.GetitemString(k, "color") + "/" + & 
		                     dw_assort4.GetitemString(k, "size") + "] 배분량이 초과 하였습니다,")
		 
		 Return false
	 END IF
NEXT


ll_assort_cnt = dw_assort4.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! OR idw_status = DataModified! THEN	
		ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
      FOR k = 1 TO ll_assort_cnt 
				 ls_color = dw_assort4.getitemstring(k, "color")	
				 ls_size  = dw_assort4.getitemstring(k, "size")	 
			
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if			
			
				 if ls_color = is_color1 then
					 h = 1
				 elseif ls_color = is_color2 then
					 h = 2
				 elseif ls_color = is_color3 then
					 h = 3
				 elseif ls_color = is_color4 then
					 h = 4		  
				 end if 
	
			IF dw_body.GetItemStatus(i, "s4_deal" + ls_size1 + "_qty_" + string(h), Primary!) = DataModified! THEN 
				ll_deal_qty = dw_body.GetitemNumber(i, "s4_deal" + ls_size1 + "_qty_" + string(h))
				ls_find  = "shop_cd = '" + ls_shop_cd + "' and color = '" + ls_color + "' and size = '" + ls_size + "'"
				ll_find = dw_order4.find(ls_find, 1, dw_order4.RowCount())
				IF ll_find > 0 THEN
					dw_order4.Setitem(ll_find, "deal_qty", ll_deal_qty)
               dw_order4.Setitem(ll_find, "mod_id",   gs_user_id)
               dw_order4.Setitem(ll_find, "mod_dt",   ld_datetime)
				ELSE
					ll_find = dw_order4.insertRow(0)
               dw_order4.Setitem(ll_find, "style",    is_style4)
               dw_order4.Setitem(ll_find, "chno",     is_chno4)
               dw_order4.Setitem(ll_find, "shop_cd",  ls_shop_cd)
               dw_order4.Setitem(ll_find, "color",    ls_color)
               dw_order4.Setitem(ll_find, "size",     ls_size)
               dw_order4.Setitem(ll_find, "deal_qty", ll_deal_qty)
		         dw_order4.Setitem(ll_find, "out_ymd",  is_yymmdd)					
               dw_order4.Setitem(ll_find, "reg_id",   gs_user_id)
				END IF
			END IF
		NEXT
   END IF
NEXT




Return True

end function

public function boolean wf_deal_2 ();/* 배분 처리 */
DataStore  lds_Dealjob
Long   i, k, ll_assort_Cnt, ll_index , j, ll_body_cnt
Long   ll_deal_tot, ll_shop_tot, ll_size_deal, ll_shop_deal
Dec    ldc_deal_qty
string ls_shop_cd, ls_find, ls_color, ls_size, ls_modify, ls_size1

il_rows = dw_deal2.Retrieve(is_style2, is_chno2, is_deal_type, is_color1 , is_color2 ,is_color3 , is_color4)
IF il_rows < 1 THEN Return False

ll_assort_Cnt = dw_assort2.RowCount()
ll_body_cnt = dw_body.RowCount()

lds_Dealjob = Create DataStore
lds_Dealjob.DataObject = "d_52010_d97"

dw_body.SetRedraw(False)
	FOR j = 1 TO ll_assort_Cnt 
			ls_size  = dw_assort2.object.size[j]
  		   ls_color = dw_assort2.object.color[j]			
			
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if		
	 
				if ls_color = is_color1 then
 					ls_modify = "t_sd2" + ls_size1 + "_1.text = '" + string(dw_assort2.object.ord_deal[j]) + "'" + &
 					            "t_sp2" + ls_size1 + "_1.text = '" + string(dw_assort2.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color2 then
 					ls_modify = "t_sd2" + ls_size1 + "_2.text = '" + string(dw_assort2.object.ord_deal[j])  + "'" + &
 					            "t_sp2" + ls_size1 + "_2.text = '" + string(dw_assort2.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color3 then
 					ls_modify = "t_sd2" + ls_size1 + "_3.text = '" + string(dw_assort2.object.ord_deal[j])  + "'"	+ &
 					            "t_sp2" + ls_size1 + "_3.text = '" + string(dw_assort2.object.ord_qty[j]) + "'"					 
				elseif ls_color = is_color4 then
 					ls_modify = "t_sd2" + ls_size1 + "_4.text = '" + string(dw_assort2.object.ord_deal[j])  + "'"	+ &
 					            "t_sp2" + ls_size1 + "_4.text = '" + string(dw_assort2.object.ord_qty[j]) + "'"					 
				end if	 
					 
	
			dw_body.modify(ls_modify)
			
		next	



FOR i = 1 to il_rows 
   /*배분율 셋팅*/	
   ls_find = "shop_cd = '" + dw_deal2.Object.shop_cd[i] + "'"
	j = dw_body.find(ls_find, 1, ll_body_cnt)	
	dw_body.SetItem(j, "deal_rate", dw_deal2.GetitemDecimal(i, "deal_rate"))
	
	
   /* 매장별 배분량 산출 */
	ll_shop_tot = dw_deal2.GetitemNumber(i, "deal_qty") 
	
	/* 총 배분 잔량  산출 */
   ll_deal_tot = Long(dw_assort2.Describe("evaluate('sum(ord_deal)',0)"))
	lds_Dealjob.Reset()
	
	FOR k = 1 TO ll_assort_cnt 
		 /* 사이즈별 배분 잔량 */
		 ll_size_deal = dw_assort2.GetitemNumber(k, "ord_deal")
		 ldc_deal_qty = ll_shop_tot * (ll_size_deal / ll_deal_tot)
		 lds_Dealjob.insertRow(0)
       lds_Dealjob.Setitem(k, "no" , k)
       lds_Dealjob.Setitem(k, "color" , dw_assort2.object.color[k])		 
       lds_Dealjob.Setitem(k, "size" , dw_assort2.object.size[k])		 		 		 
       lds_Dealjob.Setitem(k, "deal_qty" , Truncate(ldc_deal_qty, 0))
       lds_Dealjob.Setitem(k, "dvd" , ldc_deal_qty - Truncate(ldc_deal_qty, 0))

	NEXT 

	ll_shop_deal = Long(lds_Dealjob.Describe("evaluate('sum(deal_qty)',0)"))	
	Do While ll_shop_tot <> ll_shop_deal 
			lds_Dealjob.SetSort("dvd d, no a")
		lds_Dealjob.Sort()
		For k = 1 to ll_assort_cnt 
         lds_Dealjob.Setitem(k, "deal_qty" , lds_Dealjob.GetitemNumber(k,"deal_qty") + 1)
			ll_shop_deal ++
			IF ll_shop_tot = ll_shop_deal THEN EXIT
		NEXT 
   Loop 
	
	/* 임시에 배분 내역을 dw_body로 이동 */
	//FOR k = 1 TO ll_assort_cnt 

//		 ls_color = lds_Dealjob.Object.color[k]
//		 ls_size  = lds_Dealjob.Object.size[k]		 
//       lds_Dealjob.Object.deal_qty[k]
		 
 
		FOR k = 1 TO ll_assort_cnt 

		 ll_index = lds_Dealjob.GetitemNumber(k, "no")
		 ls_size  = lds_Dealjob.Object.size[k]
		 ls_color = lds_Dealjob.Object.color[k]
		  
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if				  
		  

       if ls_color = is_color1 then
				 dw_body.Setitem(j, "s2_deal" + ls_size1 + "_qty_1",lds_Dealjob.Object.deal_qty[k])
 		 elseif ls_color = is_color2 then
				 dw_body.Setitem(j, "s2_deal" + ls_size1 + "_qty_2",lds_Dealjob.Object.deal_qty[k])
 		 elseif ls_color = is_color3 then
				 dw_body.Setitem(j, "s2_deal" + ls_size1 + "_qty_3",lds_Dealjob.Object.deal_qty[k])
 		 elseif ls_color = is_color4 then
				 dw_body.Setitem(j, "s2_deal" + ls_size1 + "_qty_4",lds_Dealjob.Object.deal_qty[k])				 
  		 end if 		 

	 dw_assort2.Setitem(ll_index, "ord_deal", dw_assort2.Object.ord_deal[ll_index] - lds_Dealjob.Object.deal_qty[k])		 		 
	NEXT
//		 dw_assort2.Setitem(ll_index, "ord_deal", dw_assort2.Object.ord_deal[ll_index] - lds_Dealjob.Object.deal_qty[k])

//	NEXT
NEXT

dw_body.SetRedraw(True)
Destroy  lds_Dealjob

Return True

end function

public function boolean wf_deal_3 ();/* 배분 처리 */
DataStore  lds_Dealjob
Long   i, k, ll_assort_Cnt, ll_index , j, ll_body_cnt
Long   ll_deal_tot, ll_shop_tot, ll_size_deal, ll_shop_deal
Dec    ldc_deal_qty
string ls_shop_cd, ls_find, ls_color, ls_size, ls_modify, ls_size1

il_rows = dw_deal3.Retrieve(is_style3, is_chno3, is_deal_type, is_color1 , is_color2 ,is_color3 , is_color4)
IF il_rows < 1 THEN Return False

ll_assort_Cnt = dw_assort3.RowCount()
ll_body_cnt = dw_body.RowCount()

lds_Dealjob = Create DataStore
lds_Dealjob.DataObject = "d_52010_d97"

dw_body.SetRedraw(False)

	FOR j = 1 TO ll_assort_Cnt 
			ls_size  = dw_assort3.object.size[j]
  		   ls_color = dw_assort3.object.color[j]			
			
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if		
	 
				if ls_color = is_color1 then
 					ls_modify = "t_sd3" + ls_size1 + "_1.text = '" + string(dw_assort3.object.ord_deal[j]) + "'" + &
 					            "t_sp3" + ls_size1 + "_1.text = '" + string(dw_assort3.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color2 then
 					ls_modify = "t_sd3" + ls_size1 + "_2.text = '" + string(dw_assort3.object.ord_deal[j])  + "'" + &
 					            "t_sp3" + ls_size1 + "_2.text = '" + string(dw_assort3.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color3 then
 					ls_modify = "t_sd3" + ls_size1 + "_3.text = '" + string(dw_assort3.object.ord_deal[j])  + "'"	+ &
 					            "t_sp3" + ls_size1 + "_3.text = '" + string(dw_assort3.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color4 then
 					ls_modify = "t_sd3" + ls_size1 + "_4.text = '" + string(dw_assort3.object.ord_deal[j])  + "'"	+ &
 					            "t_sp3" + ls_size1 + "_4.text = '" + string(dw_assort3.object.ord_qty[j]) + "'"		
				end if	 
					 
			dw_body.modify(ls_modify)
			
		next	


FOR i = 1 to il_rows 
   /*배분율 셋팅*/	
   ls_find = "shop_cd = '" + dw_deal3.Object.shop_cd[i] + "'"
	j = dw_body.find(ls_find, 1, ll_body_cnt)	
	dw_body.SetItem(j, "deal_rate", dw_deal3.GetitemDecimal(i, "deal_rate"))
	
	
   /* 매장별 배분량 산출 */
	ll_shop_tot = dw_deal3.GetitemNumber(i, "deal_qty") 
	
	/* 총 배분 잔량  산출 */
   ll_deal_tot = Long(dw_assort3.Describe("evaluate('sum(ord_deal)',0)"))
	lds_Dealjob.Reset()
	
	FOR k = 1 TO ll_assort_cnt 
		 /* 사이즈별 배분 잔량 */
		 ll_size_deal = dw_assort3.GetitemNumber(k, "ord_deal")
		 ldc_deal_qty = ll_shop_tot * (ll_size_deal / ll_deal_tot)
		 lds_Dealjob.insertRow(0)
       lds_Dealjob.Setitem(k, "no" , k)
       lds_Dealjob.Setitem(k, "color" , dw_assort3.object.color[k])		 
       lds_Dealjob.Setitem(k, "size" , dw_assort3.object.size[k])		 		 		 
       lds_Dealjob.Setitem(k, "deal_qty" , Truncate(ldc_deal_qty, 0))
       lds_Dealjob.Setitem(k, "dvd" , ldc_deal_qty - Truncate(ldc_deal_qty, 0))
	NEXT 
	ll_shop_deal = Long(lds_Dealjob.Describe("evaluate('sum(deal_qty)',0)"))
	Do While ll_shop_tot <> ll_shop_deal 
		lds_Dealjob.SetSort("dvd d, no a")
		lds_Dealjob.Sort()
		For k = 1 to ll_assort_cnt 
         lds_Dealjob.Setitem(k, "deal_qty" , lds_Dealjob.GetitemNumber(k,"deal_qty") + 1)
			ll_shop_deal ++
			IF ll_shop_tot = ll_shop_deal THEN EXIT
		NEXT 
   Loop 
	
	
			
	
	/* 임시에 배분 내역을 dw_body로 이동 */
//	FOR k = 1 TO ll_assort_cnt 

//		 ls_color = lds_Dealjob.Object.color[k]
//		 ls_size  = lds_Dealjob.Object.size[k]		 
//       lds_Dealjob.Object.deal_qty[k]
		FOR k = 1 TO ll_assort_cnt 

		 ll_index = lds_Dealjob.GetitemNumber(k, "no")

 		 ls_size  = lds_Dealjob.Object.size[k]
		 ls_color = lds_Dealjob.Object.color[k]
		 
 	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if		
		  

       if ls_color = is_color1 then
				 dw_body.Setitem(j, "s3_deal" + ls_size1 + "_qty_1",lds_Dealjob.Object.deal_qty[k])
 		 elseif ls_color = is_color2 then
				 dw_body.Setitem(j, "s3_deal" + ls_size1 + "_qty_2",lds_Dealjob.Object.deal_qty[k])
 		 elseif ls_color = is_color3 then
				 dw_body.Setitem(j, "s3_deal" + ls_size1 + "_qty_3",lds_Dealjob.Object.deal_qty[k])
 		 elseif ls_color = is_color4 then
				 dw_body.Setitem(j, "s3_deal" + ls_size1 + "_qty_4",lds_Dealjob.Object.deal_qty[k])				 
  		 end if 		 

		 dw_assort3.Setitem(ll_index, "ord_deal", dw_assort3.Object.ord_deal[ll_index] - lds_Dealjob.Object.deal_qty[k])		 
	NEXT
//		 dw_assort3.Setitem(ll_index, "ord_deal", dw_assort3.Object.ord_deal[ll_index] - lds_Dealjob.Object.deal_qty[k])
//	NEXT
NEXT

dw_body.SetRedraw(True)
Destroy  lds_Dealjob

Return True

end function

public function boolean wf_deal_4 ();/* 배분 처리 */
DataStore  lds_Dealjob
Long   i, k, ll_assort_Cnt, ll_index , j, ll_body_cnt
Long   ll_deal_tot, ll_shop_tot, ll_size_deal, ll_shop_deal
Dec    ldc_deal_qty
string ls_shop_cd, ls_find, ls_color, ls_size, ls_modify, ls_size1

il_rows = dw_deal4.Retrieve(is_style4, is_chno4, is_deal_type, is_color1 , is_color2 ,is_color3 , is_color4)
IF il_rows < 1 THEN Return False

ll_assort_Cnt = dw_assort4.RowCount()
ll_body_cnt = dw_body.RowCount()

lds_Dealjob = Create DataStore
lds_Dealjob.DataObject = "d_52010_d97"

dw_body.SetRedraw(False)

	FOR j = 1 TO ll_assort_cnt
			ls_size  = dw_assort4.object.size[j]
  		   ls_color = dw_assort4.object.color[j]			
			  
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if					  
			
				if ls_color = is_color1 then
 					ls_modify = "t_sd4" + ls_size1 + "_1.text = '" + string(dw_assort4.object.ord_deal[j])  + "'" + &
 					            "t_sp4" + ls_size1 + "_1.text = '" + string(dw_assort4.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color2 then
 					ls_modify = "t_sd4" + ls_size1 + "_2.text = '" + string(dw_assort4.object.ord_deal[j])  + "'" + &
 					            "t_sp4" + ls_size1 + "_2.text = '" + string(dw_assort4.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color3 then
 					ls_modify = "t_sd4" + ls_size1 + "_3.text = '" + string(dw_assort4.object.ord_deal[j])  + "'"	+ &
 					            "t_sp4" + ls_size1 + "_3.text = '" + string(dw_assort4.object.ord_qty[j]) + "'"					 
				elseif ls_color = is_color4 then
 					ls_modify = "t_sd4" + ls_size1 + "_4.text = '" + string(dw_assort4.object.ord_deal[j])  + "'"	+ &
 					            "t_sp4" + ls_size1 + "_4.text = '" + string(dw_assort4.object.ord_qty[j]) + "'"		
				end if	 
		
			dw_body.modify(ls_modify)
			
		next	


FOR i = 1 to il_rows 
   /*배분율 셋팅*/	
   ls_find = "shop_cd = '" + dw_deal4.Object.shop_cd[i] + "'"
	j = dw_body.find(ls_find, 1, ll_body_cnt)	
	dw_body.SetItem(j, "deal_rate", dw_deal4.GetitemDecimal(i, "deal_rate"))
	
	
   /* 매장별 배분량 산출 */
	ll_shop_tot = dw_deal4.GetitemNumber(i, "deal_qty") 
	
	/* 총 배분 잔량  산출 */
   ll_deal_tot = Long(dw_assort.Describe("evaluate('sum(ord_deal)',0)"))
	lds_Dealjob.Reset()
	
	FOR k = 1 TO ll_assort_cnt 
		 /* 사이즈별 배분 잔량 */
		 ll_size_deal = dw_assort4.GetitemNumber(k, "ord_deal")
		 ldc_deal_qty = ll_shop_tot * (ll_size_deal / ll_deal_tot)
		 lds_Dealjob.insertRow(0)
       lds_Dealjob.Setitem(k, "no" , k)
       lds_Dealjob.Setitem(k, "color" , dw_assort4.object.color[k])		 
       lds_Dealjob.Setitem(k, "size" , dw_assort4.object.size[k])		 		 
       lds_Dealjob.Setitem(k, "deal_qty" , Truncate(ldc_deal_qty, 0))
       lds_Dealjob.Setitem(k, "dvd" , ldc_deal_qty - Truncate(ldc_deal_qty, 0))
	NEXT 
	ll_shop_deal = Long(lds_Dealjob.Describe("evaluate('sum(deal_qty)',0)"))
	Do While ll_shop_tot <> ll_shop_deal 
		lds_Dealjob.SetSort("dvd d, no a")
		lds_Dealjob.Sort()
		For k = 1 to ll_assort_cnt 
         lds_Dealjob.Setitem(k, "deal_qty" , lds_Dealjob.GetitemNumber(k,"deal_qty") + 1)
			ll_shop_deal ++
			IF ll_shop_tot = ll_shop_deal THEN EXIT
		NEXT 
   Loop 
	
		
	/* 임시에 배분 내역을 dw_body로 이동 */
//	FOR k = 1 TO ll_assort_cnt 

//		 ls_color = lds_Dealjob.Object.color[k]
//		 ls_size  = lds_Dealjob.Object.size[k]		 
 //      lds_Dealjob.Object.deal_qty[k]
FOR k = 1 TO ll_assort_cnt 

		 ll_index = lds_Dealjob.GetitemNumber(k, "no")
		 ls_size  = lds_Dealjob.Object.size[k]
		 ls_color = lds_Dealjob.Object.color[k]

  	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if		

       if ls_color = is_color1 then
				 dw_body.Setitem(j, "s4_deal" + ls_size1 + "_qty_1",lds_Dealjob.Object.deal_qty[k])
 		 elseif ls_color = is_color2 then
				 dw_body.Setitem(j, "s4_deal" + ls_size1 + "_qty_2",lds_Dealjob.Object.deal_qty[k])
 		 elseif ls_color = is_color3 then
				 dw_body.Setitem(j, "s4_deal" + ls_size1 + "_qty_3",lds_Dealjob.Object.deal_qty[k])
 		 elseif ls_color = is_color4 then
				 dw_body.Setitem(j, "s4_deal" + ls_size1 + "_qty_4",lds_Dealjob.Object.deal_qty[k])				 
  		 end if 		 


		 dw_assort4.Setitem(ll_index, "ord_deal", dw_assort4.Object.ord_deal[ll_index] - lds_Dealjob.Object.deal_qty[k])		 
	NEXT
	//	 dw_assort4.Setitem(ll_index, "ord_deal", dw_assort4.Object.ord_deal[ll_index] - lds_Dealjob.Object.deal_qty[k])
	NEXT
//NEXT


dw_body.SetRedraw(True)
Destroy  lds_Dealjob

Return True

end function

public function boolean wf_update_2 ();/* 배분 처리 */

long     i, k, ll_row_count, ll_assort_cnt, ll_find, ll_deal_qty , j, h
datetime ld_datetime
String   ls_shop_cd, ls_color, ls_size, ls_find, ls_size1
String   ls_out_ymd

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN false


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return false
END IF

/* ORDER량 초과배분 여부 체크 */ 
FOR k = 1 TO dw_ASSORT2.RowCount()
	 ls_color = dw_assort2.getitemstring(k, "color")	
	 ls_size  = dw_assort2.getitemstring(k, "size")	 

	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if		

	 if ls_color = is_color1 then
  	    h = 1
 	 elseif ls_color = is_color2 then
 	    h = 2
 	 elseif ls_color = is_color3 then
 	    h = 3
 	 elseif ls_color = is_color4 then
 	    h = 4		  
  	 end if 
		
	 ll_deal_qty = dw_body.GetitemNumber(1, "c_s2" + ls_size1 + "_" + string(h)) 	

	 IF ll_deal_qty > dw_assort2.Object.ord_qty[k] THEN 
		
		 MessageBox("오류", "["  + is_style2 + dw_assort2.GetitemString(k, "color") + "/" + & 
		                     dw_assort2.GetitemString(k, "size") + "] 배분량이 초과 하였습니다,")
		 
		 Return false
	 END IF
NEXT


ll_assort_cnt = dw_assort2.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! OR idw_status = DataModified! THEN	
		ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
      FOR k = 1 TO ll_assort_cnt 
				 ls_color = dw_assort2.getitemstring(k, "color")	
				 ls_size  = dw_assort2.getitemstring(k, "size")	 
			
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if		
			
				 if ls_color = is_color1 then
					 h = 1
				 elseif ls_color = is_color2 then
					 h = 2
				 elseif ls_color = is_color3 then
					 h = 3
				 elseif ls_color = is_color4 then
					 h = 4		  
				 end if 
	
			IF dw_body.GetItemStatus(i, "s2_deal" + ls_size1 + "_qty_" + string(h), Primary!) = DataModified! THEN 
				ll_deal_qty = dw_body.GetitemNumber(i, "s2_deal" + ls_size1 + "_qty_" + string(h))
				ls_find  = "shop_cd = '" + ls_shop_cd + "' and color = '" + ls_color + "' and size = '" + ls_size + "'"
				ll_find = dw_order2.find(ls_find, 1, dw_order2.RowCount())
				IF ll_find > 0 THEN
					dw_order2.Setitem(ll_find, "deal_qty", ll_deal_qty)
               dw_order2.Setitem(ll_find, "mod_id",   gs_user_id)
               dw_order2.Setitem(ll_find, "mod_dt",   ld_datetime)
				ELSE
					ll_find = dw_order2.insertRow(0)
               dw_order2.Setitem(ll_find, "style",    is_style2)
               dw_order2.Setitem(ll_find, "chno",     is_chno2)
               dw_order2.Setitem(ll_find, "shop_cd",  ls_shop_cd)
               dw_order2.Setitem(ll_find, "color",    ls_color)
               dw_order2.Setitem(ll_find, "size",     ls_size)
               dw_order2.Setitem(ll_find, "deal_qty", ll_deal_qty)
		         dw_order2.Setitem(ll_find, "out_ymd",  is_yymmdd)					
               dw_order2.Setitem(ll_find, "reg_id",   gs_user_id)
				END IF
			END IF
		NEXT
   END IF
NEXT




Return True

end function

public subroutine wf_retrieve_2 ();/*  배분내역 dw_body로 이관 */
String ls_shop_cd,   ls_find , ls_style_no, ls_color, ls_size , ls_modify, ls_size1
Long   ll_row, ll_row_cnt,  ll_assort_cnt ,ll_row_cnt2,  ll_assort_cnt2 
long   ll_row_cnt3,  ll_assort_cnt3 ,ll_row_cnt4,  ll_assort_cnt4 
Long   i, k,   ll_deal_qty ,j


ll_row_cnt2    = dw_order2.RowCount()
IF ll_row_cnt2 < 1 THEN RETURN
ll_assort_cnt2 = dw_temp2.RowCount()
ll_assort_cnt3 = dw_assort2.RowCount()

//dw_body.SetRedraw(FALSE)

	FOR j = 1 TO ll_assort_cnt3 
			ls_size  = dw_assort2.object.size[j]
  		   ls_color = dw_assort2.object.color[j]			
			
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if		
		
     			if ls_color = is_color1 then
 					ls_modify = "t_sd2" + ls_size1 +  "_1.text = '" + string(dw_assort2.object.ord_deal[j]) + "'" + &
 					            "t_sp2" + ls_size1 +  "_1.text = '" + string(dw_assort2.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color2 then
 					ls_modify = "t_sd2" + ls_size1 +  "_2.text = '" + string(dw_assort2.object.ord_deal[j])  + "'" + &
 					            "t_sp2" + ls_size1 +  "_2.text = '" + string(dw_assort2.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color3 then
 					ls_modify = "t_sd2" + ls_size1 +  "_3.text = '" + string(dw_assort2.object.ord_deal[j])  + "'" + &
 					            "t_sp2" + ls_size1 +  "_3.text = '" + string(dw_assort2.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color4 then
 					ls_modify = "t_sd2" + ls_size1 +  "_4.text = '" + string(dw_assort2.object.ord_deal[j])  + "'" + &
 					            "t_sp2" + ls_size1 +  "_4.text = '" + string(dw_assort2.object.ord_qty[j]) + "'"	
				end if	 

			dw_body.modify(ls_modify)			
			

		next	


FOR i = 1 TO ll_row_cnt2
   ls_shop_cd =  dw_order2.object.shop_cd[i] 
	ll_row = dw_body.find("shop_cd = '" + ls_shop_cd + "'", 1, dw_body.RowCount())

	ls_style_no =  dw_order2.object.style[i] + dw_order2.object.chno[i] 
	ls_color = dw_order2.object.color[i]
	ls_size = dw_order2.object.size[i]
	
    if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if			
	
	ls_find = "style = '" + dw_order2.object.style[i] + "'"
	ls_find = ls_find + "and chno = '" + dw_order2.object.chno[i] + "'"
	ls_find = ls_find + "and color = '" + dw_order2.object.color[i] + "'"
	ls_find = ls_find + "and size = '" + dw_order2.object.size[i] + "'"	
	
   k = dw_temp2.find(ls_find, 1, ll_assort_cnt2)	
	
	IF k > 0 THEN 
		ll_deal_qty = dw_order2.GetitemNumber(i, "deal_qty")
		if ls_style_no = is_style2 + is_chno2 and ls_color = is_color1 and ls_size1 = '55' then
   		dw_body.Setitem(ll_row, "s2_deal55_qty_1" , ll_deal_qty)
		elseif ls_style_no =  is_style2 + is_chno2 and ls_color = is_color1 and ls_size1 = '66' then
   		dw_body.Setitem(ll_row, "s2_deal66_qty_1" , ll_deal_qty)
		elseif ls_style_no =  is_style2 + is_chno2 and ls_color = is_color1 and ls_size1 = '77' then
   		dw_body.Setitem(ll_row, "s2_deal77_qty_1" , ll_deal_qty)			
		elseif ls_style_no =  is_style2 + is_chno2 and ls_color = is_color2 and ls_size1 = '55' then
   		dw_body.Setitem(ll_row, "s2_deal55_qty_2" , ll_deal_qty)
		elseif ls_style_no =  is_style2 + is_chno2 and ls_color = is_color2 and ls_size1 = '66' then
   		dw_body.Setitem(ll_row, "s2_deal66_qty_2" , ll_deal_qty)			
		elseif ls_style_no =  is_style2 + is_chno2 and ls_color = is_color2 and ls_size1 = '77' then
   		dw_body.Setitem(ll_row, "s2_deal77_qty_2" , ll_deal_qty)						
		elseif ls_style_no =  is_style2 + is_chno2 and ls_color = is_color3 and ls_size1 = '55' then
   		dw_body.Setitem(ll_row, "s2_deal55_qty_3" , ll_deal_qty)
		elseif ls_style_no =  is_style2 + is_chno2 and ls_color = is_color3 and ls_size1 = '66' then
   		dw_body.Setitem(ll_row, "s2_deal66_qty_3" , ll_deal_qty)			
		elseif ls_style_no =  is_style2 + is_chno2 and ls_color = is_color3 and ls_size1 = '77' then
   		dw_body.Setitem(ll_row, "s2_deal77_qty_3" , ll_deal_qty)						
		elseif ls_style_no =  is_style2 + is_chno2 and ls_color = is_color4 and ls_size1 = '55' then
   		dw_body.Setitem(ll_row, "s2_deal55_qty_4" , ll_deal_qty)
		elseif ls_style_no =  is_style2 + is_chno2 and ls_color = is_color4 and ls_size1 = '66' then
   		dw_body.Setitem(ll_row, "s2_deal66_qty_4" , ll_deal_qty)						
		elseif ls_style_no =  is_style2 + is_chno2 and ls_color = is_color4 and ls_size1 = '77' then
   		dw_body.Setitem(ll_row, "s2_deal77_qty_4" , ll_deal_qty)									
		end if	
			
	END IF
	

NEXT


/* 배분가능량에 추가로 표시 */
//wf_add_stock()

dw_body.ResetUpdate()
//dw_body.SetRedraw(True)

Return
end subroutine

public subroutine wf_retrieve_3 ();/*  배분내역 dw_body로 이관 */
String ls_shop_cd,   ls_find , ls_style_no, ls_color, ls_size , ls_modify, ls_size1
Long   ll_row, ll_row_cnt,  ll_assort_cnt ,ll_row_cnt2,  ll_assort_cnt2 
long   ll_row_cnt3,  ll_assort_cnt3 ,ll_row_cnt4,  ll_assort_cnt4 
Long   i, k,   ll_deal_qty , j


ll_row_cnt3    = dw_order3.RowCount()
IF ll_row_cnt3 < 1 THEN RETURN
ll_assort_cnt3 = dw_temp3.RowCount()
ll_assort_cnt4 = dw_assort3.RowCount()

dw_body.SetRedraw(False) 

	FOR j = 1 TO ll_assort_cnt4 
			ls_size  = dw_assort3.object.size[j]
  		   ls_color = dw_assort3.object.color[j]			
			
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if				  			
			
     			if ls_color = is_color1 then
 					ls_modify = "t_sd3" + ls_size1 +  "_1.text = '" + string(dw_assort3.object.ord_deal[j]) + "'" + &
 					            " t_sp3" + ls_size1 +  "_1.text = '" + string(dw_assort3.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color2 then
 					ls_modify = "t_sd3" + ls_size1 +  "_2.text = '" + string(dw_assort3.object.ord_deal[j])  + "'" + &
 					            " t_sp3" + ls_size1 +  "_2.text = '" + string(dw_assort3.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color3 then
 					ls_modify = "t_sd3" + ls_size1 +  "_3.text = '" + string(dw_assort3.object.ord_deal[j])  + "'" + &
 					            " t_sp3" + ls_size1 +  "_3.text = '" + string(dw_assort3.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color4 then
 					ls_modify = "t_sd3" + ls_size1 +  "_4.text = '" + string(dw_assort3.object.ord_deal[j])  + "'" + &
 					            " t_sp3" + ls_size1 +  "_4.text = '" + string(dw_assort3.object.ord_qty[j]) + "'"	
				end if	 
			  dw_body.modify(ls_modify)
		next	


FOR i = 1 TO ll_row_cnt3
   ls_shop_cd =  dw_order3.object.shop_cd[i] 
	ll_row = dw_body.find("shop_cd = '" + ls_shop_cd + "'", 1, dw_body.RowCount())
	
	ls_style_no =  dw_order3.object.style[i] + dw_order3.object.chno[i] 
	ls_color = dw_order3.object.color[i]
	ls_size = dw_order3.object.size[i]

		 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if				  	
	
	ls_find = "style = '" + dw_order3.object.style[i] + "'"
	ls_find = ls_find + "and chno = '" + dw_order3.object.chno[i] + "'"
	ls_find = ls_find + "and color = '" + dw_order3.object.color[i] + "'"
	ls_find = ls_find + "and size = '" + dw_order3.object.size[i] + "'"	
	
   k = dw_temp3.find(ls_find, 1, ll_assort_cnt3)	
	

	
	IF k > 0 THEN 
		ll_deal_qty = dw_order3.GetitemNumber(i, "deal_qty")
		if ls_style_no = is_style3 + is_chno3 and ls_color = is_color1 and ls_size1 = '55' then
   		dw_body.Setitem(ll_row, "s3_deal55_qty_1" , ll_deal_qty)
		elseif ls_style_no =  is_style3 + is_chno3 and ls_color = is_color1 and ls_size1 = '66' then
   		dw_body.Setitem(ll_row, "s3_deal66_qty_1" , ll_deal_qty)
		elseif ls_style_no =  is_style3 + is_chno3 and ls_color = is_color1 and ls_size1 = '77' then
   		dw_body.Setitem(ll_row, "s3_deal77_qty_1" , ll_deal_qty)			
		elseif ls_style_no =  is_style3 + is_chno3 and ls_color = is_color2 and ls_size1 = '55' then
   		dw_body.Setitem(ll_row, "s3_deal55_qty_2" , ll_deal_qty)
		elseif ls_style_no =  is_style3 + is_chno3 and ls_color = is_color2 and ls_size1 = '66' then
   		dw_body.Setitem(ll_row, "s3_deal66_qty_2" , ll_deal_qty)			
		elseif ls_style_no =  is_style3 + is_chno3 and ls_color = is_color2 and ls_size1 = '77' then
   		dw_body.Setitem(ll_row, "s3_deal77_qty_2" , ll_deal_qty)						
		elseif ls_style_no =  is_style3 + is_chno3 and ls_color = is_color3 and ls_size1 = '55' then
   		dw_body.Setitem(ll_row, "s3_deal55_qty_3" , ll_deal_qty)
		elseif ls_style_no =  is_style3 + is_chno3 and ls_color = is_color3 and ls_size1 = '66' then
   		dw_body.Setitem(ll_row, "s3_deal66_qty_3" , ll_deal_qty)			
		elseif ls_style_no =  is_style3 + is_chno3 and ls_color = is_color3 and ls_size1 = '77' then
   		dw_body.Setitem(ll_row, "s3_deal77_qty_3" , ll_deal_qty)						
		elseif ls_style_no =  is_style3 + is_chno3 and ls_color = is_color4 and ls_size1 = '55' then
   		dw_body.Setitem(ll_row, "s3_deal55_qty_4" , ll_deal_qty)
		elseif ls_style_no =  is_style3 + is_chno3 and ls_color = is_color4 and ls_size1 = '66' then
   		dw_body.Setitem(ll_row, "s3_deal66_qty_4" , ll_deal_qty)						
		elseif ls_style_no =  is_style3 + is_chno3 and ls_color = is_color4 and ls_size1 = '77' then
   		dw_body.Setitem(ll_row, "s3_deal77_qty_4" , ll_deal_qty)									
		end if	
			
	END IF
NEXT


/* 배분가능량에 추가로 표시 */
//wf_add_stock()

dw_body.ResetUpdate()
dw_body.SetRedraw(True)

Return
end subroutine

public subroutine wf_retrieve_4 ();/*  배분내역 dw_body로 이관 */
String ls_shop_cd,   ls_find , ls_style_no, ls_color, ls_size , ls_modify, ls_size1
Long   ll_row, ll_row_cnt,  ll_assort_cnt ,ll_row_cnt2,  ll_assort_cnt2 
long   ll_row_cnt3,  ll_assort_cnt3 ,ll_row_cnt4,  ll_assort_cnt4 
Long   i, k,   ll_deal_qty , j

ll_row_cnt4    = dw_order4.RowCount()
IF ll_row_cnt4 < 1 THEN RETURN
ll_assort_cnt4 = dw_temp4.RowCount()
ll_assort_cnt3 = dw_assort4.RowCount()

dw_body.SetRedraw(False) 

	FOR j = 1 TO ll_assort_cnt3 
			ls_size  = dw_assort4.object.size[j]
  		   ls_color = dw_assort4.object.color[j]			
			  
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if					  
			  
     			if ls_color = is_color1 then
 					ls_modify = "t_sd4" + ls_size1 +  "_1.text = '" + string(dw_assort4.object.ord_deal[j]) + "'" + &
 					            "t_sp4" + ls_size1 +  "_1.text = '" + string(dw_assort4.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color2 then
 					ls_modify = "t_sd4" + ls_size1 +  "_2.text = '" + string(dw_assort4.object.ord_deal[j])  + "'" + &
 					            "t_sp4" + ls_size1 +  "_2.text = '" + string(dw_assort4.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color3 then
 					ls_modify = "t_sd4" + ls_size1 +  "_3.text = '" + string(dw_assort4.object.ord_deal[j])  + "'" + &
 					            "t_sp4" + ls_size1 +  "_3.text = '" + string(dw_assort4.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color4 then
 					ls_modify = "t_sd4" + ls_size1 +  "_4.text = '" + string(dw_assort4.object.ord_deal[j])  + "'" + &
 					            "t_sp4" + ls_size1 +  "_4.text = '" + string(dw_assort4.object.ord_qty[j]) + "'"	
				end if	 

			dw_body.modify(ls_modify)
			
		next	



FOR i = 1 TO ll_row_cnt4 
   ls_shop_cd =  dw_order4.object.shop_cd[i] 
	ll_row = dw_body.find("shop_cd = '" + ls_shop_cd + "'", 1, dw_body.RowCount())
	
	ls_style_no =  dw_order4.object.style[i] + dw_order4.object.chno[i] 
	ls_color = dw_order4.object.color[i]
	ls_size = dw_order4.object.size[i]
	
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if				  		
	
	ls_find = "style = '" + dw_order4.object.style[i] + "'"
	ls_find = ls_find + "and chno = '" + dw_order4.object.chno[i] + "'"
	ls_find = ls_find + "and color = '" + dw_order4.object.color[i] + "'"
	ls_find = ls_find + "and size = '" + dw_order4.object.size[i] + "'"	
	
   k = dw_temp4.find(ls_find, 1, ll_assort_cnt4)	
	

	IF k > 0 THEN 
		ll_deal_qty = dw_order4.GetitemNumber(i, "deal_qty")
		if ls_style_no = is_style4 + is_chno4 and ls_color = is_color1 and ls_size1 = '55' then
   		dw_body.Setitem(ll_row, "s4_deal55_qty_1" , ll_deal_qty)
		elseif ls_style_no =  is_style4 + is_chno4 and ls_color = is_color1 and ls_size1 = '66' then
   		dw_body.Setitem(ll_row, "s4_deal66_qty_1" , ll_deal_qty)
		elseif ls_style_no =  is_style4 + is_chno4 and ls_color = is_color1 and ls_size1 = '77' then
   		dw_body.Setitem(ll_row, "s4_deal77_qty_1" , ll_deal_qty)			
		elseif ls_style_no =  is_style4 + is_chno4 and ls_color = is_color2 and ls_size1 = '55' then
   		dw_body.Setitem(ll_row, "s4_deal55_qty_2" , ll_deal_qty)
		elseif ls_style_no =  is_style4 + is_chno4 and ls_color = is_color2 and ls_size1 = '66' then
   		dw_body.Setitem(ll_row, "s4_deal66_qty_2" , ll_deal_qty)			
		elseif ls_style_no =  is_style4 + is_chno4 and ls_color = is_color2 and ls_size1 = '77' then
   		dw_body.Setitem(ll_row, "s4_deal77_qty_2" , ll_deal_qty)						
		elseif ls_style_no =  is_style4 + is_chno4 and ls_color = is_color3 and ls_size1 = '55' then
   		dw_body.Setitem(ll_row, "s4_deal55_qty_3" , ll_deal_qty)
		elseif ls_style_no =  is_style4 + is_chno4 and ls_color = is_color3 and ls_size1 = '66' then
   		dw_body.Setitem(ll_row, "s4_deal66_qty_3" , ll_deal_qty)			
		elseif ls_style_no =  is_style4 + is_chno4 and ls_color = is_color3 and ls_size1 = '77' then
   		dw_body.Setitem(ll_row, "s4_deal77_qty_3" , ll_deal_qty)						
		elseif ls_style_no =  is_style4 + is_chno4 and ls_color = is_color4 and ls_size1 = '55' then
   		dw_body.Setitem(ll_row, "s4_deal55_qty_4" , ll_deal_qty)
		elseif ls_style_no =  is_style4 + is_chno4 and ls_color = is_color4 and ls_size1 = '66' then
   		dw_body.Setitem(ll_row, "s4_deal66_qty_4" , ll_deal_qty)						
		elseif ls_style_no =  is_style4 + is_chno4 and ls_color = is_color4 and ls_size1 = '77' then
   		dw_body.Setitem(ll_row, "s4_deal77_qty_4" , ll_deal_qty)									
		end if	
			
	END IF
NEXT

/* 배분가능량에 추가로 표시 */
//wf_add_stock()

dw_body.ResetUpdate()
dw_body.SetRedraw(True)

Return
end subroutine

public subroutine wf_add_stock ();/* 배분내역이 존재할경우 배분가능량에 배분량만큼 추가로 처리*/
Long   k, ll_deal_qty, ll_stock_qty 
String ls_modify,      ls_Error

FOR k = 1 TO dw_ASSORT.RowCount()
  	 ll_deal_qty  = dw_body.GetitemNumber(1, "c_deal_" + String(k)) 
	 ll_stock_qty = dw_assort.Object.stock_qty[k] + ll_deal_qty 
	 dw_assort.Setitem(k, "stock_qty", ll_stock_qty)
    ls_modify = 't_ord_'    + String(k) + '.text="' + String(ll_stock_qty) + '"'
    ls_Error  = dw_body.Modify(ls_modify)
    IF (ls_Error <> "") THEN 
		 MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
		 Return 
	 END IF 
NEXT 

end subroutine

public function boolean wf_deal_1 ();/* 배분 처리 */
DataStore  lds_Dealjob
Long   i, k, ll_assort_Cnt, ll_index , j, ll_body_cnt
Long   ll_deal_tot, ll_shop_tot, ll_size_deal, ll_shop_deal
Dec    ldc_deal_qty
string ls_shop_cd, ls_find, ls_color, ls_size, ls_modify, ls_size1

il_rows = dw_deal1.Retrieve(is_style1, is_chno1, is_deal_type, is_color1 , is_color2 ,is_color3 , is_color4)
IF il_rows < 1 THEN Return False

ll_assort_Cnt = dw_assort.RowCount()
ll_body_cnt = dw_body.RowCount()

lds_Dealjob = Create DataStore
lds_Dealjob.DataObject = "d_52010_d97"

dw_body.SetRedraw(False)

	FOR j = 1 TO ll_assort_Cnt 
			ls_size  = dw_assort.object.size[j]
  		   ls_color = dw_assort.object.color[j]	
			  
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if					  
			
				if ls_color = is_color1 then
 					ls_modify = "t_sd1" + ls_size1 +  "_1.text = '" + string(dw_assort.object.ord_deal[j]) + "'" + &
 					            "t_sp1" + ls_size1 +  "_1.text = '" + string(dw_assort.object.ord_qty[j]) + "'"					 
				elseif ls_color = is_color2 then
 					ls_modify = "t_sd1" + ls_size1 +  "_2.text = '" + string(dw_assort.object.ord_deal[j])  + "'" + &
 					            "t_sp1" + ls_size1 +  "_2.text = '" + string(dw_assort.object.ord_qty[j]) + "'"					 					 
				elseif ls_color = is_color3 then
 					ls_modify = "t_sd1" + ls_size1 +  "_3.text = '" + string(dw_assort.object.ord_deal[j])  + "'"	+ &
 					            "t_sp1" + ls_size1 +  "_3.text = '" + string(dw_assort.object.ord_qty[j]) + "'"					 
				elseif ls_color = is_color4 then
 					ls_modify = "t_sd1" + ls_size1 +  "_4.text = '" + string(dw_assort.object.ord_deal[j])  + "'"	+ &
 					            "t_sp1" + ls_size1 +  "_4.text = '" + string(dw_assort.object.ord_qty[j]) + "'"					 
				end if	 

			dw_body.modify(ls_modify)
			
		next	


FOR i = 1 to il_rows 
   /*배분율 셋팅*/	
   ls_find = "shop_cd = '" + dw_deal1.Object.shop_cd[i] + "'"
	j = dw_body.find(ls_find, 1, ll_body_cnt)	
	dw_body.SetItem(j, "deal_rate", dw_deal1.GetitemDecimal(i, "deal_rate"))
	
	
   /* 매장별 배분량 산출 */
	ll_shop_tot = dw_deal1.GetitemNumber(i, "deal_qty") 
	
	/* 총 배분 잔량  산출 */
   ll_deal_tot = Long(dw_assort.Describe("evaluate('sum(ord_deal)',0)"))
	lds_Dealjob.Reset()
	
	FOR k = 1 TO ll_assort_cnt 
		 /* 사이즈별 배분 잔량 */
		 ll_size_deal = dw_assort.GetitemNumber(k, "ord_deal")
		 ldc_deal_qty = ll_shop_tot * (ll_size_deal / ll_deal_tot)
		 lds_Dealjob.insertRow(0)
       lds_Dealjob.Setitem(k, "no" , k)
       lds_Dealjob.Setitem(k, "color" , dw_assort.object.color[k])		 
       lds_Dealjob.Setitem(k, "size" , dw_assort.object.size[k])		 		 		 
       lds_Dealjob.Setitem(k, "deal_qty" , Truncate(ldc_deal_qty, 0))
       lds_Dealjob.Setitem(k, "dvd" , ldc_deal_qty - Truncate(ldc_deal_qty, 0))
	NEXT 
	ll_shop_deal = Long(lds_Dealjob.Describe("evaluate('sum(deal_qty)',0)"))
	Do While ll_shop_tot <> ll_shop_deal 
		lds_Dealjob.SetSort("dvd d, no a")
		lds_Dealjob.Sort()
		For k = 1 to ll_assort_cnt 
         lds_Dealjob.Setitem(k, "deal_qty" , lds_Dealjob.GetitemNumber(k,"deal_qty") + 1)
			ll_shop_deal ++
			IF ll_shop_tot = ll_shop_deal THEN EXIT
		NEXT 
   Loop 
	
	
		
	/* 임시에 배분 내역을 dw_body로 이동 */
//	FOR k = 1 TO ll_assort_cnt 

//		 ls_color = lds_Dealjob.Object.color[k]
//		 ls_size  = lds_Dealjob.Object.size[k]		 
//       lds_Dealjob.Object.deal_qty[k]
		FOR k = 1 TO ll_assort_cnt 

		 ll_index = lds_Dealjob.GetitemNumber(k, "no")
		 ls_size  = lds_Dealjob.Object.size[k]
		 ls_color = lds_Dealjob.Object.color[k]
		  
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if				  

       if ls_color = is_color1 then
				 dw_body.Setitem(j, "s1_deal" + ls_size1 + "_qty_1",lds_Dealjob.Object.deal_qty[k])
 		 elseif ls_color = is_color2 then
				 dw_body.Setitem(j, "s1_deal" + ls_size1 + "_qty_2",lds_Dealjob.Object.deal_qty[k])
 		 elseif ls_color = is_color3 then
				 dw_body.Setitem(j, "s1_deal" + ls_size1 + "_qty_3",lds_Dealjob.Object.deal_qty[k])
 		 elseif ls_color = is_color4 then
				 dw_body.Setitem(j, "s1_deal" + ls_size1 + "_qty_4",lds_Dealjob.Object.deal_qty[k])				 
  		 end if 		 

		 dw_assort.Setitem(ll_index, "ord_deal", dw_assort.Object.ord_deal[ll_index] - lds_Dealjob.Object.deal_qty[k])		 
	NEXT
		// dw_assort.Setitem(ll_index, "ord_deal", dw_assort.Object.ord_deal[ll_index] - lds_Dealjob.Object.deal_qty[k])
//	NEXT
NEXT

dw_body.SetRedraw(True)
Destroy  lds_Dealjob

Return True

end function

public subroutine wf_retrieve_set ();/*  배분내역 dw_body로 이관 */
String ls_shop_cd,   ls_find 
Long   ll_row, ll_row_cnt,  ll_assort_cnt 
Long   i, k,   ll_deal_qty 
//
////ll_row_cnt    = dw_db.RowCount()
//IF ll_row_cnt < 1 THEN RETURN 
//
//ll_assort_cnt = dw_assort.RowCount()
//
//dw_body.SetRedraw(False) 
//FOR i = 1 TO ll_row_cnt 
////   ls_shop_cd =  dw_db.object.shop_cd[i] 
//	ll_row = dw_body.find("shop_cd = '" + ls_shop_cd + "'", 1, dw_body.RowCount())
//	IF ll_row < 1 THEN
//	   ll_row     =  dw_body.insertRow(0)
//      dw_body.Setitem(ll_row, "shop_cd",   ls_shop_cd)
//      dw_body.Setitem(ll_row, "shop_nm",   dw_db.object.shop_nm[i])
//      dw_body.Setitem(ll_row, "shop_stat", dw_db.object.shop_stat[i])
//      dw_body.Setitem(ll_row, "deal_yn",   dw_db.object.deal_yn[i])
//	END IF 
//	ls_find = "size = '" + dw_db.object.size[i] + "'"
//   k = dw_assort.find(ls_find, 1, ll_assort_cnt)	
//	IF k > 0 THEN 
//		ll_deal_qty = dw_db.GetitemNumber(i, "deal_qty")
//		dw_body.Setitem(ll_row, "deal_qty_"  + String(k), ll_deal_qty)
//	END IF
//NEXT
//
///* 배분가능량에 추가로 표시 */
//wf_add_stock()
//
//dw_body.ResetUpdate()
//dw_body.SetRedraw(True)

Return
end subroutine

public function boolean wf_temp_set ();/* 기준품번 판매내역 dw_body로 이관 */
String ls_shop_cd,   ls_find 
Long   ll_row, ll_row_cnt, ll_assort_cnt 
Long   i, k,   ll_sale_qty  
Boolean lb_Chk

//ll_row_cnt    = dw_temp.RowCount()
IF ll_row_cnt < 1 THEN RETURN FALSE

ll_assort_cnt = dw_assort.RowCount()

dw_body.SetRedraw(False) 
dw_body.Reset()
lb_Chk = False 
//FOR i = 1 TO ll_row_cnt 
//	IF ls_shop_cd <> dw_temp.object.shop_cd[i] THEN 
//      ls_shop_cd =  dw_temp.object.shop_cd[i] 
//		ll_row     =  dw_body.insertRow(0)
//      dw_body.Setitem(ll_row, "shop_cd", ls_shop_cd)
//      dw_body.Setitem(ll_row, "shop_nm", dw_temp.object.shop_nm[i])
//      dw_body.Setitem(ll_row, "deal_yn", dw_temp.object.deal_yn[i])
//	END IF 
//	ls_find = "size = '" + dw_temp.object.size[i] + "'"
//   k = dw_assort.find(ls_find, 1, ll_assort_cnt)	
//	IF k > 0 THEN 
//		dw_body.Setitem(ll_row, "out_qty_"   + String(k), dw_temp.GetitemNumber(i, "out_qty"))
//		dw_body.Setitem(ll_row, "rtrn_qty_"  + String(k), dw_temp.GetitemNumber(i, "rtrn_qty"))
//		dw_body.Setitem(ll_row, "sale_qty_"  + String(k), dw_temp.GetitemNumber(i, "sale_qty"))
//      lb_Chk = True
//	END IF
//NEXT
//
//dw_body.ResetUpdate()
//dw_body.SetRedraw(True)

Return lb_chk
end function

public subroutine wf_retrieve_1 ();/*  배분내역 dw_body로 이관 */
String ls_shop_cd,   ls_find , ls_style_no, ls_color, ls_size , ls_modify, ls_size1
Long   ll_row, ll_row_cnt,  ll_assort_cnt ,ll_row_cnt2,  ll_assort_cnt2 
long   ll_row_cnt3,  ll_assort_cnt3 ,ll_row_cnt4,  ll_assort_cnt4 
Long   i, k,   ll_deal_qty , j

ll_row_cnt    = dw_order.RowCount()
IF ll_row_cnt < 1 THEN RETURN
ll_assort_cnt = dw_temp1.RowCount()
ll_assort_cnt3 = dw_assort.RowCount()

dw_body.SetRedraw(False) 

	FOR j = 1 TO ll_assort_cnt3 
			ls_size  = dw_assort.object.size[j]
  		   ls_color = dw_assort.object.color[j]		
			  
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if		 
			
     			if ls_color = is_color1 then
 					ls_modify = "t_sd1" + ls_size1 +  "_1.text = '" + string(dw_assort.object.ord_deal[j]) + "'" + &
 					            "t_sp1" + ls_size1 +  "_1.text = '" + string(dw_assort.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color2 then
 					ls_modify = "t_sd1" + ls_size1 +  "_2.text = '" + string(dw_assort.object.ord_deal[j])  + "'" + &
 					            "t_sp1" + ls_size1 +  "_2.text = '" + string(dw_assort.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color3 then
 					ls_modify = "t_sd1" + ls_size1 +  "_3.text = '" + string(dw_assort.object.ord_deal[j])  + "'" + &
 					            "t_sp1" + ls_size1 +  "_3.text = '" + string(dw_assort.object.ord_qty[j]) + "'"	
				elseif ls_color = is_color4 then
 					ls_modify = "t_sd1" + ls_size1 +  "_4.text = '" + string(dw_assort.object.ord_deal[j])  + "'" + &
 					            "t_sp1" + ls_size1 +  "_4.text = '" + string(dw_assort.object.ord_qty[j]) + "'"	
				end if	 

			dw_body.modify(ls_modify)
			
		next	

FOR i = 1 TO ll_row_cnt 
   ls_shop_cd =  dw_order.object.shop_cd[i] 
	ll_row = dw_body.find("shop_cd = '" + ls_shop_cd + "'", 1, dw_body.RowCount())
	IF ll_row < 1 THEN
	   ll_row     =  dw_body.insertRow(0)
      dw_body.Setitem(ll_row, "shop_cd",   ls_shop_cd)
      dw_body.Setitem(ll_row, "shop_nm",   dw_order.object.shop_nm[i])
      dw_body.Setitem(ll_row, "shop_stat", dw_order.object.shop_stat[i])
      dw_body.Setitem(ll_row, "deal_yn",   dw_order.object.deal_yn[i])
      dw_body.Setitem(ll_row, "shop_lv",   dw_order.object.tb_91100_m_shop_lv[i])		
      dw_body.Setitem(ll_row, "area_cd",   dw_order.object.tb_91100_m_area_cd[i])		
      dw_body.Setitem(ll_row, "shop_lv1",   dw_order.object.tb_91100_m_shop_lv1[i])				
	END IF 
	
	ls_style_no =  dw_order.object.style[i] + dw_order.object.chno[i] 
	ls_color = dw_order.object.color[i]
	ls_size = dw_order.object.size[i]
	
	 if ls_size = '01' then 
		 ls_size1 = '55'
	 elseif ls_size = '02' then 
		 ls_size1 = '66'
 	 elseif ls_size = '03' then 
		 ls_size1 = '77'
    else		 
		 ls_size1 = ls_size
	 end if		 	
	
	ls_find = "style = '" + dw_order.object.style[i] + "'"
	ls_find = ls_find + "and chno = '" + dw_order.object.chno[i] + "'"
	ls_find = ls_find + "and color = '" + dw_order.object.color[i] + "'"
	ls_find = ls_find + "and size = '" + dw_order.object.size[i] + "'"	
	
   k = dw_temp1.find(ls_find, 1, ll_assort_cnt)	
	
	IF k > 0 THEN 
		ll_deal_qty = dw_order.GetitemNumber(i, "deal_qty")
		if ls_style_no = is_style1 + is_chno1 and ls_color = is_color1 and ls_size1 = '55' then
   		dw_body.Setitem(ll_row, "s1_deal55_qty_1" , ll_deal_qty)
		elseif ls_style_no =  is_style1 + is_chno1 and ls_color = is_color1 and ls_size1 = '66'  then
   		dw_body.Setitem(ll_row, "s1_deal66_qty_1" , ll_deal_qty)
		elseif ls_style_no =  is_style1 + is_chno1 and ls_color = is_color1 and ls_size1 = '77'  then
   		dw_body.Setitem(ll_row, "s1_deal77_qty_1" , ll_deal_qty)			
		elseif ls_style_no =  is_style1 + is_chno1 and ls_color = is_color2 and ls_size1 = '55'  then
   		dw_body.Setitem(ll_row, "s1_deal55_qty_2" , ll_deal_qty)
		elseif ls_style_no =  is_style1 + is_chno1 and ls_color = is_color2 and ls_size1 = '66'  then
   		dw_body.Setitem(ll_row, "s1_deal66_qty_2" , ll_deal_qty)			
		elseif ls_style_no =  is_style1 + is_chno1 and ls_color = is_color2 and ls_size1 = '77'  then
   		dw_body.Setitem(ll_row, "s1_deal77_qty_2" , ll_deal_qty)						
		elseif ls_style_no =  is_style1 + is_chno1 and ls_color = is_color3 and ls_size1 = '55'  then
   		dw_body.Setitem(ll_row, "s1_deal55_qty_3" , ll_deal_qty)
		elseif ls_style_no =  is_style1 + is_chno1 and ls_color = is_color3 and ls_size1 = '66'  then
   		dw_body.Setitem(ll_row, "s1_deal66_qty_3" , ll_deal_qty)			
		elseif ls_style_no =  is_style1 + is_chno1 and ls_color = is_color3 and ls_size1 = '77' then
   		dw_body.Setitem(ll_row, "s1_deal77_qty_3" , ll_deal_qty)						
		elseif ls_style_no =  is_style1 + is_chno1 and ls_color = is_color4 and ls_size1 = '55' then
   		dw_body.Setitem(ll_row, "s1_deal55_qty_4" , ll_deal_qty)
		elseif ls_style_no =  is_style1 + is_chno1 and ls_color = is_color4 and ls_size1 = '66'  then
   		dw_body.Setitem(ll_row, "s1_deal66_qty_4" , ll_deal_qty)						
		elseif ls_style_no =  is_style1 + is_chno1 and ls_color = is_color4 and ls_size1 = '77'  then
   		dw_body.Setitem(ll_row, "s1_deal77_qty_4" , ll_deal_qty)									
		end if	
			
	END IF
NEXT

/* 배분가능량에 추가로 표시 */
//wf_add_stock()

dw_body.ResetUpdate()
dw_body.SetRedraw(True)

Return
end subroutine

on w_52023_e.create
int iCurrent
call super::create
this.dw_assort=create dw_assort
this.st_remark=create st_remark
this.dw_order=create dw_order
this.dw_temp1=create dw_temp1
this.dw_temp2=create dw_temp2
this.dw_temp3=create dw_temp3
this.dw_temp4=create dw_temp4
this.dw_order2=create dw_order2
this.dw_order3=create dw_order3
this.dw_order4=create dw_order4
this.dw_deal1=create dw_deal1
this.dw_deal2=create dw_deal2
this.dw_deal3=create dw_deal3
this.dw_deal4=create dw_deal4
this.dw_assort2=create dw_assort2
this.dw_assort3=create dw_assort3
this.dw_assort4=create dw_assort4
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_assort
this.Control[iCurrent+2]=this.st_remark
this.Control[iCurrent+3]=this.dw_order
this.Control[iCurrent+4]=this.dw_temp1
this.Control[iCurrent+5]=this.dw_temp2
this.Control[iCurrent+6]=this.dw_temp3
this.Control[iCurrent+7]=this.dw_temp4
this.Control[iCurrent+8]=this.dw_order2
this.Control[iCurrent+9]=this.dw_order3
this.Control[iCurrent+10]=this.dw_order4
this.Control[iCurrent+11]=this.dw_deal1
this.Control[iCurrent+12]=this.dw_deal2
this.Control[iCurrent+13]=this.dw_deal3
this.Control[iCurrent+14]=this.dw_deal4
this.Control[iCurrent+15]=this.dw_assort2
this.Control[iCurrent+16]=this.dw_assort3
this.Control[iCurrent+17]=this.dw_assort4
this.Control[iCurrent+18]=this.dw_1
end on

on w_52023_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_assort)
destroy(this.st_remark)
destroy(this.dw_order)
destroy(this.dw_temp1)
destroy(this.dw_temp2)
destroy(this.dw_temp3)
destroy(this.dw_temp4)
destroy(this.dw_order2)
destroy(this.dw_order3)
destroy(this.dw_order4)
destroy(this.dw_deal1)
destroy(this.dw_deal2)
destroy(this.dw_deal3)
destroy(this.dw_deal4)
destroy(this.dw_assort2)
destroy(this.dw_assort3)
destroy(this.dw_assort4)
destroy(this.dw_1)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_remark, "ScaleToRight")
dw_assort.SetTransObject(SQLCA)
dw_assort2.SetTransObject(SQLCA)
dw_assort3.SetTransObject(SQLCA)
dw_assort4.SetTransObject(SQLCA)

dw_temp1.SetTransObject(SQLCA)
dw_temp2.SetTransObject(SQLCA)
dw_temp3.SetTransObject(SQLCA)
dw_temp4.SetTransObject(SQLCA)
//dw_db.SetTransObject(SQLCA)
dw_order.SetTransObject(SQLCA)
dw_order2.SetTransObject(SQLCA)
dw_order3.SetTransObject(SQLCA)
dw_order4.SetTransObject(SQLCA)
dw_deal1.SetTransObject(SQLCA)
dw_deal2.SetTransObject(SQLCA)
dw_deal3.SetTransObject(SQLCA)
dw_deal4.SetTransObject(SQLCA)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title, ls_style_no

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

ls_style_no = dw_head.GetItemString(1, "style_no1")
if IsNull(ls_style_no) or Trim(ls_style_no) = "" then
   MessageBox(ls_title,"기준품번 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no1")
   return false
end if
is_style1 = MidA(ls_style_no, 1, 8)
is_Chno1  = MidA(ls_style_no, 9, 1)

ls_style_no = dw_head.GetItemString(1, "style_no2")
if IsNull(ls_style_no) or Trim(ls_style_no) = "" then
   MessageBox(ls_title,"배분품번1을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no2")
   return false
end if
is_style2 = MidA(ls_style_no, 1, 8)
is_Chno2  = MidA(ls_style_no, 9, 1)

ls_style_no = dw_head.GetItemString(1, "style_no3")
if IsNull(ls_style_no) or Trim(ls_style_no) = "" then
 
 ls_style_no = 'XXXXXXXXX'
end if
is_style3 = MidA(ls_style_no, 1, 8)
is_Chno3  = MidA(ls_style_no, 9, 1)

ls_style_no = dw_head.GetItemString(1, "style_no4")
if IsNull(ls_style_no) or Trim(ls_style_no) = "" then
  ls_style_no = 'XXXXXXXXX'
end if
is_style4 = MidA(ls_style_no, 1, 8)
is_Chno4  = MidA(ls_style_no, 9, 1)

is_color1 = dw_head.GetItemString(1, "color1")
if IsNull(is_color1) or Trim(is_color1) = "" then
   MessageBox(ls_title,"배분색상 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("is_color1")
   return false
end if

is_color2 = dw_head.GetItemString(1, "color2")
if IsNull(is_color2) or Trim(is_color2) = "" then
 is_color2 = 'ZZ'
end if

is_color3 = dw_head.GetItemString(1, "color3")
if IsNull(is_color3) or Trim(is_color3) = "" then
 is_color3 = 'ZZ'
end if

is_color4 = dw_head.GetItemString(1, "color4")
if IsNull(is_color4) or Trim(is_color4) = "" then
 is_color4 = 'ZZ'
end if


IF is_style1 + is_chno1  = is_style2 + is_chno2  then
   MessageBox(ls_title,"같은 품번,색상코드 입니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no2")
   return false
END IF	

IF is_style1 + is_chno1  = is_style3 + is_chno3  THEN 
   MessageBox(ls_title,"같은 품번,색상코드 입니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no3")
   return false
END IF	

IF is_style1 + is_chno1 = is_style4 + is_chno4  then	
   MessageBox(ls_title,"같은 품번,색상코드 입니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no4")
   return false
END IF	


is_yymmdd = dw_head.GetItemString(1, "yymmdd")
IF IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"출고예정일을 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
END IF	

is_deal_type = dw_head.GetItemString(1, "deal_type")
IF IsNull(is_deal_type) or Trim(is_deal_type) = "" then
   MessageBox(ls_title,"배분타입을 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_type")
   return false
END IF	


return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;
String     ls_style, ls_chno, ls_color
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style_no1", "style_no2", "style_no3", "style_no4"				
		   ls_style = MidA(as_data, 1, 8)
			ls_chno  = MidA(as_data, 9, 1)
			IF ai_div = 1 THEN 	
				if gs_brand <> 'K' then
					IF gf_style_chk(ls_style, ls_chno) THEN 
						RETURN 0
					END IF 
				end if
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = ""
			if gs_brand <> 'K' then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"  + &
											 " and chno like '" + ls_chno + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else
				gst_cd.Item_where = ""
			end if	

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				IF as_column = "style_no1" THEN
    				dw_head.SetItem(al_row, "style_no1", lds_Source.GetItemString(1,"style_no"))
				   dw_head.SetColumn("style_no2")
				ELSEif as_column = "style_no2" THEN
    				dw_head.SetItem(al_row, "style_no2", lds_Source.GetItemString(1,"style_no"))
				   dw_head.SetColumn("style_no3")
				ELSEif as_column = "style_no3" THEN
    				dw_head.SetItem(al_row, "style_no3", lds_Source.GetItemString(1,"style_no"))
				   dw_head.SetColumn("style_no4")
				else	
    				dw_head.SetItem(al_row, "style_no4", lds_Source.GetItemString(1,"style_no"))
				   dw_head.SetColumn("color1")
				END IF
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

event ue_retrieve();call super::ue_retrieve;
Long ll_row
string ls_deal_gubn
Boolean	lb_NewDeal1,lb_NewDeal2,lb_NewDeal3,lb_NewDeal4

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

/* 사이즈별 내역 처리 */

dw_body.reset()
IF wf_body_set() = FALSE THEN RETURN

/* 기준 품번 내역 처리 */
il_rows = dw_temp1.retrieve(is_style1,is_chno1, is_color1 + is_color2 + is_color3 + is_color4)

IF il_rows > 0 THEN
	st_remark.text = '이미 배분되여 있습니다.'
	dw_head.modify(" style_no_t1.Color= '242' " )
   dw_order.retrieve(is_style1,is_chno1, is_color1 , is_color2 ,is_color3 , is_color4)
   dw_ASSORT.retrieve(is_style1,is_chno1, is_color1 , is_color2 ,is_color3 , is_color4)	
	wf_retrieve_1() 	
	//CB_delete.enabled = true
   lb_NewDeal1 = False
ELSE
	st_remark.text = '배분 처리중 .........'
	dw_head.modify(" style_no_t1.Color= '0' " )	
   dw_ASSORT.retrieve(is_style1,is_chno1, is_color1 , is_color2 ,is_color3 , is_color4)
	lb_NewDeal1 = wf_Deal_1() 
	cb_delete.enabled = false	
	st_remark.text = ''
END IF

	This.Trigger Event ue_button(1, il_rows)		
		IF il_rows > 0 THEN 
			IF ib_NewDeal THEN 
				ib_changed = true
				cb_update.enabled = true
				cb_excel.enabled = false
			ELSEIF st_remark.Text = "이미 출고된 자료 입니다." THEN 
				dw_body.Enabled = False
			END IF
		END IF

/* 배분품번1 내역 처리 */
il_rows =  dw_temp2.retrieve(is_style2,is_chno2, is_color1 + is_color2 + is_color3 + is_color4)

IF il_rows > 0 THEN
	dw_head.modify(" style_no_t2.Color= '242' " )
   dw_order2.retrieve(is_style2,is_chno2, is_color1 , is_color2 ,is_color3 , is_color4)
   dw_ASSORT2.retrieve(is_style2,is_chno2, is_color1 , is_color2 ,is_color3 , is_color4)	
	wf_retrieve_2() 	
	//CB_delete.enabled = true
   lb_NewDeal2 = False
ELSE
	st_remark.text = '배분 처리중2 .........'
		dw_head.modify(" style_no_t2.Color= '0' " )
   dw_ASSORT2.retrieve(is_style2,is_chno2, is_color1 , is_color2 ,is_color3 , is_color4)
	lb_NewDeal2 = wf_Deal_2() 
	cb_delete.enabled = false	
	st_remark.text = ''
END IF

	This.Trigger Event ue_button(1, il_rows)		
		IF il_rows > 0 THEN 
			IF ib_NewDeal THEN 
				ib_changed = true
				cb_update.enabled = true
				cb_excel.enabled = false
			ELSEIF st_remark.Text = "이미 출고된 자료 입니다." THEN 
				dw_body.Enabled = False
			END IF
		END IF

/* 배분품번2 내역 처리 */
il_rows =  dw_temp3.retrieve(is_style3,is_chno3, is_color1 + is_color2 + is_color3 + is_color4)

IF il_rows > 0 THEN
	dw_head.modify(" style_no_t3.Color= '242' " )
  	dw_order3.retrieve(is_style3,is_chno3, is_color1 , is_color2 , is_color3 , is_color4)
   dw_ASSORT3.retrieve(is_style3,is_chno3, is_color1 , is_color2 ,is_color3 , is_color4)		  
	wf_retrieve_3() 	
	//CB_delete.enabled = true
   lb_NewDeal3 = False
ELSE
	st_remark.text = '배분 처리중 .........'
	dw_head.modify(" style_no_t3.Color= '0' " )	
   dw_ASSORT3.retrieve(is_style3,is_chno3, is_color1 , is_color2 ,is_color3 , is_color4)	
	lb_NewDeal3 = wf_Deal_3() 
	cb_delete.enabled = false	
	st_remark.text = ''
END IF
			
	This.Trigger Event ue_button(1, il_rows)		
		IF il_rows > 0 THEN 
			IF ib_NewDeal THEN 
				ib_changed = true
				cb_update.enabled = true
				cb_excel.enabled = false
			ELSEIF st_remark.Text = "이미 출고된 자료 입니다." THEN 
				dw_body.Enabled = False
			END IF
		END IF

/* 배분품번3 내역 처리 */
il_rows =   dw_temp4.retrieve(is_style4,is_chno4, is_color1 + is_color2 + is_color3 + is_color4)
IF il_rows > 0 THEN
	dw_head.modify(" style_no_t4.Color= '242' " )	
  	dw_order4.retrieve(is_style4,is_chno4, is_color1 , is_color2 , is_color3 , is_color4)	
   dw_ASSORT4.retrieve(is_style4,is_chno4, is_color1 , is_color2 ,is_color3 , is_color4)	  
	wf_retrieve_3() 	
	//CB_delete.enabled = true
   lb_NewDeal4 = False
ELSE
	dw_head.modify(" style_no_t4.Color= '0' " )	
	st_remark.text = '배분 처리중 .........'
   dw_ASSORT4.retrieve(is_style4,is_chno4, is_color1 , is_color2 ,is_color3 , is_color4)		
	lb_NewDeal4 = wf_Deal_4() 
	cb_delete.enabled = false	
	st_remark.text = ''
END IF			 
			 
	if lb_NewDeal1 = true or lb_NewDeal2 = true or 	lb_NewDeal3 = true or lb_NewDeal4 = true then
		ib_NewDeal = true
	else	
		ib_NewDeal = false
	end if
	
	This.Trigger Event ue_button(1, il_rows)		
		IF il_rows > 0 THEN 
			IF ib_NewDeal THEN 
				ib_changed = true
				cb_update.enabled = true
				cb_excel.enabled = false
			ELSEIF st_remark.Text = "이미 출고된 자료 입니다." THEN 
				dw_body.Enabled = False
			END IF
		END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;
long     i, k, ll_row_count, ll_assort_cnt, ll_find, ll_deal_qty 
datetime ld_datetime
String   ls_shop_cd, ls_color, ls_size, ls_find
String   ls_out_ymd
boolean  lb_update1, lb_update2, lb_update3, lb_update4

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1
   dw_1.AcceptText() 

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


lb_update1 = wf_update_1()
if lb_update1 = true then
	il_rows = dw_order.Update()
	
	if il_rows = 1 then
	    commit  USING SQLCA;
	else
		Return -1
		rollback  USING SQLCA;
	end if
	
end if	


lb_update2 = wf_update_2()
if lb_update2 = true then
	il_rows = dw_order2.Update()
	
	if il_rows = 1 then
	  commit  USING SQLCA;
	else
		Return -1
		rollback  USING SQLCA;
	end if
	
end if	

lb_update3 = wf_update_3()
if lb_update3 = true then
	il_rows = dw_order3.Update()
	
	if il_rows = 1 then
	   commit  USING SQLCA;
	  
	else
		Return -1
		rollback  USING SQLCA;
	end if
	
end if	

lb_update4 = wf_update_4()
if lb_update4 = true then
	il_rows = dw_order4.Update()
	
	if il_rows = 1 then
	   commit  USING SQLCA;
  	else
		Return -1
		rollback  USING SQLCA;
	end if
	
end if	


This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_delete();call super::ue_delete;

//dw_db.Retrieve(is_yymmdd, il_deal_seq, is_to_style, is_to_chno, is_to_color)

//if is_save_opt = "N" then				
//  	   DECLARE SP_DelResv_Update PROCEDURE FOR SP_DelResv_Update  
//         @YYMMDD   = :is_yymmdd,   
//			@deal_seq = :il_deal_seq,
//         @style    = :is_to_style,   
//         @chno     = :is_to_chno,   
//         @color    = :is_to_color  ;
//
//		EXECUTE SP_DelResv_Update;
//		commit  USING SQLCA;  
//		MessageBox("알림!","삭제되었습니다!")
//      cb_delete.enabled = false
//end if		
	
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_52023_e","0")
end event

type cb_close from w_com010_e`cb_close within w_52023_e
end type

type cb_delete from w_com010_e`cb_delete within w_52023_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_52023_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_52023_e
end type

type cb_update from w_com010_e`cb_update within w_52023_e
end type

type cb_print from w_com010_e`cb_print within w_52023_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_52023_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_52023_e
end type

type cb_excel from w_com010_e`cb_excel within w_52023_e
end type

type dw_head from w_com010_e`dw_head within w_52023_e
integer x = 9
integer y = 144
integer width = 3529
integer height = 384
string dataobject = "d_52023_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("color1", idw_color1)
idw_color1.SetTransObject(SQLCA)
idw_color1.Retrieve('%')

This.GetChild("color2", idw_color2)
idw_color2.SetTransObject(SQLCA)
idw_color2.Retrieve('%')

This.GetChild("color3", idw_color3)
idw_color3.SetTransObject(SQLCA)
idw_color3.Retrieve('%')

This.GetChild("color4", idw_color4)
idw_color4.SetTransObject(SQLCA)
idw_color4.Retrieve('%')

This.GetChild("deal_type", idw_deal_type)
idw_deal_type.SetTransObject(SQLCA)
idw_deal_type.Retrieve('520')
end event

event dw_head::itemchanged;call super::itemchanged;

String ls_yymmdd, ls_dep_ymd

CHOOSE CASE dwo.name
	CASE "yymmdd"      
//		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
//		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
//			  MessageBox("경고","소급할수 없는 일자입니다.")
//			  Return 1
//        END IF
	CASE "style_no1"
		IF ib_itemchanged THEN RETURN 1
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

		
	CASE "style_no2" , "style_no3" , "style_no4" 	 	 	 
		IF ib_itemchanged THEN RETURN 1
		if LenA(data) <> 0 then
//			select dep_ymd 
//				into :ls_dep_ymd
//			from tb_12020_m a(nolock)
//			where  style = :data;
//			
//			if len(ls_dep_ymd) = 8  then 
//				  MessageBox("확인",string(data) + " 품번은 " + ls_dep_ymd + "일자로 부진처리된 스타일입니다.. 영업 MD에 문의하세요.")
//				  Return 1			
//			end if
		
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
   	end if		
END CHOOSE

end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;String ls_style, ls_chno

CHOOSE CASE dwo.name
	CASE "fr_color"
//		ls_style = Left(This.Object.fr_style_no[1], 8)
//		ls_chno  = Right(This.Object.fr_style_no[1], 1)
//		idw_fr_color.Retrieve(ls_style, ls_chno)
	CASE "to_color"
//		ls_style = Left(This.Object.to_style_no[1], 8)
//		ls_chno = Right(This.Object.to_style_no[1], 1)
//		idw_to_color.Retrieve(ls_style, ls_chno)
END CHOOSE


end event

type ln_1 from w_com010_e`ln_1 within w_52023_e
integer beginy = 528
integer endy = 528
end type

type ln_2 from w_com010_e`ln_2 within w_52023_e
integer beginy = 532
integer endy = 532
end type

type dw_body from w_com010_e`dw_body within w_52023_e
integer x = 0
integer y = 540
integer width = 3602
integer height = 1512
string dataobject = "d_52023_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::itemchanged;call super::itemchanged;
IF LeftA(dwo.name, 8) = "deal_qty" and Long(Data) < 0 THEN
	RETURN 1
END IF 

end event

event dw_body::ue_keydown;

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::constructor;call super::constructor;
This.GetChild("shop_lv", idw_shop_lv)
idw_shop_lv.SetTransObject(SQLCA)
idw_shop_lv.Retrieve('093')
idw_shop_lv.InsertRow(1)
idw_shop_lv.SetItem(1, "inter_cd", '%')
idw_shop_lv.SetItem(1, "inter_nm", '전체')

This.GetChild("area_cd", idw_area_cd)
idw_area_cd.SetTransObject(SQLCA)
idw_area_cd.Retrieve('090')
idw_area_cd.InsertRow(1)
idw_area_cd.SetItem(1, "inter_cd", '%')
idw_area_cd.SetItem(1, "inter_nm", '전체')


This.GetChild("shop_lv1", idw_shop_lv1)
idw_shop_lv1.SetTransObject(SQLCA)
idw_shop_lv1.Retrieve('093')
idw_shop_lv1.InsertRow(1)
idw_shop_lv1.SetItem(1, "inter_cd", '%')
idw_shop_lv1.SetItem(1, "inter_nm", '전체')


end event

type dw_print from w_com010_e`dw_print within w_52023_e
end type

type dw_assort from datawindow within w_52023_e
boolean visible = false
integer x = 1618
integer y = 404
integer width = 1819
integer height = 588
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "assort"
string dataobject = "d_52023_d06"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_remark from statictext within w_52023_e
boolean visible = false
integer x = 27
integer y = 156
integer width = 1637
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean focusrectangle = false
end type

type dw_order from datawindow within w_52023_e
boolean visible = false
integer x = 677
integer y = 608
integer width = 2615
integer height = 432
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "dw_order"
string dataobject = "d_52023_d04"
boolean controlmenu = true
boolean resizable = true
boolean livescroll = true
end type

type dw_temp1 from datawindow within w_52023_e
boolean visible = false
integer x = 242
integer y = 976
integer width = 2784
integer height = 600
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_52023_d02"
boolean controlmenu = true
boolean border = false
boolean livescroll = true
end type

type dw_temp2 from datawindow within w_52023_e
boolean visible = false
integer x = 727
integer y = 1072
integer width = 2784
integer height = 600
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "temp"
string dataobject = "d_52023_d02"
boolean controlmenu = true
boolean border = false
boolean livescroll = true
end type

type dw_temp3 from datawindow within w_52023_e
boolean visible = false
integer x = 119
integer y = 1436
integer width = 2784
integer height = 600
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_52023_d02"
boolean controlmenu = true
boolean border = false
boolean livescroll = true
end type

type dw_temp4 from datawindow within w_52023_e
boolean visible = false
integer x = 517
integer y = 904
integer width = 2784
integer height = 600
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_52023_d02"
boolean controlmenu = true
boolean border = false
boolean livescroll = true
end type

type dw_order2 from datawindow within w_52023_e
boolean visible = false
integer x = 302
integer y = 1468
integer width = 3273
integer height = 644
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "order"
string dataobject = "d_52023_d04"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_order3 from datawindow within w_52023_e
boolean visible = false
integer x = 347
integer y = 1144
integer width = 2894
integer height = 600
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_52023_d04"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_order4 from datawindow within w_52023_e
boolean visible = false
integer x = 187
integer y = 1060
integer width = 3131
integer height = 600
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_52023_d04"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_deal1 from datawindow within w_52023_e
boolean visible = false
integer x = 640
integer y = 1164
integer width = 2235
integer height = 600
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_52023_d07"
boolean border = false
boolean livescroll = true
end type

type dw_deal2 from datawindow within w_52023_e
boolean visible = false
integer x = 887
integer y = 1604
integer width = 2235
integer height = 600
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "deal"
string dataobject = "d_52023_d07"
boolean border = false
boolean livescroll = true
end type

type dw_deal3 from datawindow within w_52023_e
boolean visible = false
integer x = 640
integer y = 1164
integer width = 2235
integer height = 600
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_52023_d07"
boolean border = false
boolean livescroll = true
end type

type dw_deal4 from datawindow within w_52023_e
boolean visible = false
integer x = 640
integer y = 1164
integer width = 2235
integer height = 600
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_52023_d07"
boolean border = false
boolean livescroll = true
end type

type dw_assort2 from datawindow within w_52023_e
boolean visible = false
integer x = 1454
integer y = 1512
integer width = 1819
integer height = 588
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "assort"
string dataobject = "d_52023_d06"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_assort3 from datawindow within w_52023_e
boolean visible = false
integer x = 1545
integer y = 724
integer width = 1819
integer height = 588
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "assort"
string dataobject = "d_52023_d06"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_assort4 from datawindow within w_52023_e
boolean visible = false
integer x = 1618
integer y = 404
integer width = 1819
integer height = 588
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "assort"
string dataobject = "d_52023_d06"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_52023_e
boolean visible = false
integer x = 1577
integer y = 1344
integer width = 1723
integer height = 600
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_52010_d97"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

