$PBExportHeader$w_fiti_103_e.srw
$PBExportComments$임시_시험분석등록(excel)
forward
global type w_fiti_103_e from w_com010_e
end type
end forward

global type w_fiti_103_e from w_com010_e
end type
global w_fiti_103_e w_fiti_103_e

type variables
DataWindowchild idw_brand,idw_KSK0650_V_YN, idw_KSK0650_H_YN, idw_KSK0430_V_YN, idw_A_1_H_YN, idw_KSK0645_V_YN, idw_KSK0645_H_YN, idw_KSK0644_V_YN, idw_KSK0644_H_YN, idw_KSK0535_V_YN, idw_KSK0535_H_YN, idw_IRONG12_V_YN, idw_IRONG12_H_YN, idw_KSK0465_V_YN, idw_KSK0465_H_YN, idw_IWS117_V_YN, idw_IWS117_H_YN, idw_Daylight_YN, idw_Coloring_YN, idw_Pollution_YN, idw_Pilling_YN, idw_etc_1_YN, idw_etc_2_YN, idw_etc_3_YN, idw_etc_4_YN, idw_etc_5_YN, idw_GBT_3922_YN, idw_GBT_2912_YN, idw_GBT_7528_YN, idw_GBT_18401_YN, idw_GBT_1_YN, idw_GBT_2_YN, idw_GBT_4_YN, idw_KC_aryl_yn, idw_KC_pH_yn, idw_KC_formald_yn, idw_KC_PCP_yn, idw_KC_chrome_yn
String is_brand, is_gubn, is_file_nm
end variables

forward prototypes
public function string of_str_replace (string as_msg, string as_char, string as_changechar)
public subroutine wf_getfile ()
end prototypes

public function string of_str_replace (string as_msg, string as_char, string as_changechar);/*******************************************************************/
// 처리내용  : 스트링안에 특정 문자를 다른 특정 문자로 변경한다.
// Arguments : as_msg        : 원본 String
//             as_char       : 찾아 변경하고 싶은 원본의 문자   (string)
//             as_changechar : 변경하고자하는 문자.   (string)
// Return    : as_msg        : 변경된 스트링 
//                    
/*******************************************************************/


Integer li_pos 
Long ll_cnt 
String ls_temp 

do while true 

li_pos = PosA(as_msg, as_char) 

IF li_pos = 0 THEN 
ls_temp += as_msg 
exit 
END IF 

ll_cnt++ 

as_msg = ReplaceA( as_msg, li_pos, LenA(as_char), as_changechar) 

ls_temp += LeftA(as_msg, li_pos + LenA(as_changechar) - 1) 

as_msg = MidA(as_msg, li_pos + LenA(as_changechar) ) 

loop 

as_msg = ls_temp 

return as_msg 

end function

public subroutine wf_getfile ();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.10.04                                                  */	
/* 수정일      : 2001.10.04                                                  */
/*===========================================================================*/
integer li_FileNum, li_find, li_t,li_cnt_err, li_dup_chk
string  ls_data, ls_null, ls_gubn, ls_colcd, ls_real_size, ls_zip, ls_addr
Long    ll_FileLen,  ll_FileLen2, ll_found,ll_found2


string ls_re_chk_yn, ls_mat_cd, ls_seq, ls_comment,ls_price, ls_color, ls_yymmdd, ls_mat_nm1, ls_mat_rate1
string ls_mat_nm2, ls_mat_rate2, ls_mat_nm3, ls_mat_rate3, ls_mat_nm4, ls_mat_rate4
string ls_mat_nm5, ls_mat_rate5, ls_mat_nm6, ls_mat_rate6, ls_MAT_NM7, ls_MAT_RATE7
string ls_MAT_NM8, ls_MAT_RATE8, ls_KSK0650_V, ls_KSK0650_V_YN, ls_KSK0650_H, ls_KSK0650_H_YN
string ls_KSK0430_V, ls_KSK0430_V_YN, ls_A_1_H, ls_A_1_H_YN, ls_KSK0645_V, ls_KSK0645_V_YN
string ls_KSK0645_H, ls_KSK0645_H_YN, ls_KSK0644_V, ls_KSK0644_V_YN, ls_KSK0644_H, ls_KSK0644_H_YN
string ls_KSK0535_V, ls_KSK0535_V_YN, ls_KSK0535_H, ls_KSK0535_H_YN, ls_IRONG12_V, ls_IRONG12_V_YN
string ls_IRONG12_H, ls_IRONG12_H_YN, ls_KSK0465_V, ls_KSK0465_V_YN, ls_KSK0465_H, ls_KSK0465_H_YN
string ls_IWS117_V, ls_IWS117_V_YN, ls_IWS117_H, ls_IWS117_H_YN, ls_Daylight, ls_Daylight_YN
string ls_Coloring, ls_Coloring_YN, ls_Pollution, ls_Pollution_YN, ls_Pilling, ls_Pilling_YN
string ls_etc_1, ls_etc_1_YN, ls_etc_2, ls_etc_2_YN, ls_etc_3, ls_etc_3_YN, ls_etc_4, ls_etc_4_YN
string ls_etc_5, ls_etc_5_YN, ls_GBT_3922, ls_GBT_3922_YN, ls_GBT_2912, ls_GBT_2912_YN
string ls_GBT_7528, ls_GBT_7528_YN, ls_GBT_18401, ls_GBT_18401_YN, ls_GBT_1, ls_GBT_1_YN
string ls_GBT_2, ls_GBT_2_YN, ls_GBT_3, ls_GBT_3_YN, ls_GBT_4, ls_GBT_4_YN, ls_KC_aryl, ls_KC_aryl_yn
string ls_KC_pH, ls_KC_pH_yn, ls_KC_formald, ls_KC_formald_yn, ls_KC_PCP, ls_KC_PCP_yn, ls_KC_chrome, ls_KC_chrome_yn, ls_KC_dmf, ls_KC_dmf_yn


decimal ldc_price, ldc_mat_rate1, ldc_mat_rate2, ldc_mat_rate3, ldc_mat_rate4, ldc_mat_rate5, ldc_mat_rate6, ldc_mat_rate7, ldc_mat_rate8
long ll_KSK0650_V_YN, ll_KSK0650_H_YN, ll_KSK0430_V_YN, ll_A_1_H_YN, ll_KSK0645_V_YN, ll_KSK0645_H_YN, ll_KSK0644_V_YN
long ll_KSK0644_H_YN, ll_KSK0535_V_YN, ll_KSK0535_H_YN, ll_IRONG12_V_YN, ll_IRONG12_H_YN, ll_KSK0465_V_YN, ll_KSK0465_H_YN
long ll_IWS117_V_YN, ll_IWS117_H_YN, ll_Daylight_YN, ll_Coloring_YN, ll_Pollution_YN, ll_Pilling_YN, ll_etc_1_YN, ll_etc_2_YN
long ll_etc_3_YN, ll_etc_4_YN, ll_etc_5_YN, ll_GBT_3922_YN, ll_GBT_2912_YN, ll_GBT_7528_YN, ll_GBT_18401_YN, ll_GBT_1_YN
long ll_GBT_2_YN, ll_GBT_3_YN, ll_GBT_4_YN, ll_KC_aryl_yn, ll_KC_pH_yn, ll_KC_formald_yn, ll_KC_PCP_yn, ll_KC_chrome_yn, ll_KC_dmf_yn


long ll_seq
long ll_qty	

long ll_color_tmp
long ll_ins_tmp, ll_max_seq
string ls_mat_tmp 
string ls_ins_gubn
string ls_year


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
		il_rows = 1 
		ll_FileLen = FileRead(li_FileNum, ls_data) 
	
		DO WHILE  ll_FileLen > 0
		
			IF ll_FileLen > 0 THEN 
//				li_t ++
//				ls_no = string(li_t,"0000")

				//chk_char1 (pass)
				li_find = PosA(ls_data,"$")
				ls_data =MidA(ls_data,li_find+2,1000)

				//ls_re_chk_yn
				li_find = PosA(ls_data,",")
				ls_re_chk_yn = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,1000)
			
				//ls_mat_cd				
				li_find = PosA(ls_data,",")
				ls_mat_cd = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)

				
				//ls_seq (pass)
				li_find = PosA(ls_data,",")
				ls_data =MidA(ls_data,li_find+1,1000)
				

				//ls_comment
				li_find = PosA(ls_data,"@")
				ls_comment = Trim(MidA(ls_data, 1,li_find - 2)) 
				ls_data =MidA(ls_data,li_find+2,1000)

				//color_nm  (pass)
				li_find = PosA(ls_data,",")
				ls_data =MidA(ls_data,li_find+1,1000)
				
				//ls_color
				li_find = PosA(ls_data,",")
				ls_color = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ll_seq
				// ls_ins_gubn
				/*
					ls_ins_gubn 
					A	=  seq 증가 , m ins , d ins
					B	=	seq none , m none, d upd
					C	=	seq none , m none, d ins
					D	=	seq none , m none, d upd

				*/					

							
				if is_gubn = "1" then  //원자재 kola    
				
					SELECT isnull(max(seq),0)
					INTO :ll_max_seq
					FROM tb_kola_d
					WHERE mat_cd = :ls_mat_cd;


					SELECT isnull(max(seq),0)
					INTO :ll_seq
					FROM tb_kola_d
					WHERE mat_cd = :ls_mat_cd
					AND color = :ls_color;

					
						if ll_seq = ll_max_seq then

		
							SELECT count(*)
							INTO :ll_ins_tmp
							FROM tb_kola_d
							WHERE mat_cd = :ls_mat_cd
							AND color = :ls_color
							AND isnull(yymmdd,'')<>'';

								if ll_ins_tmp >0 then
									ll_seq = ll_seq + 1
									ls_ins_gubn = "A"
								else
									ls_ins_gubn = "B"									
								end if

						else
							
							if ls_mat_tmp = ls_mat_cd then
								ls_ins_gubn = "C"
							else
								ll_seq = ll_max_seq + 1
								ls_ins_gubn = "A"											
								ls_mat_tmp = ls_mat_cd
							end if
							
						end if




				else    // 완사입 fiti        
					
			
					SELECT count(*)
					INTO :ll_ins_tmp
					FROM tb_fiti_d
					WHERE mat_cd = :ls_mat_cd
					and isnull(yymmdd,'') <> '' ;
										
					
					SELECT isnull(max(seq),0)
					INTO :ll_seq
					FROM tb_fiti_d
					WHERE mat_cd = :ls_mat_cd;
					
					if ll_ins_tmp >0 then

						if ls_mat_tmp <>ls_mat_cd then
							ll_seq = ll_seq + 1
							ls_ins_gubn = "A"

							ls_color = "x1"
							ll_color_tmp = 1
							ls_mat_tmp = ls_mat_cd
						else
							ls_ins_gubn = "B" // 원래 C 값이 맞지만 fiti는 초기에 모든컬러가 ins 됨으로 B(upd) 로 수정.
							ll_color_tmp = ll_color_tmp +1
								
								choose case ll_color_tmp
								 case 2
								  ls_color = "x2"
								 case 3
								  ls_color = "x3"
								 case else
								  ls_color = "x4"
								end choose							
						end if

							
					else

						if ll_seq > 0 then

							//ll_seq = 1
							ls_ins_gubn = "B"
							// 초기 등록이라 d 만 업데이트 하는데. 순차적으로 컬러를 x1 x2 x3 x4 정해줌
							if ls_mat_tmp <>ls_mat_cd then
								ls_color = "x1"
								ll_color_tmp = 1
								ls_mat_tmp = ls_mat_cd
							else 
								ll_color_tmp = ll_color_tmp +1
								
								choose case ll_color_tmp
								 case 2
								  ls_color = "x2"
								 case 3
								  ls_color = "x3"
								 case else
								  ls_color = "x4"
								end choose
							end if

						else
							if ls_mat_tmp = ls_mat_cd then
								ls_ins_gubn = "D"
								ll_color_tmp = ll_color_tmp +1
								
								choose case ll_color_tmp
								 case 2
								  ls_color = "x2"
								 case 3
								  ls_color = "x3"
								 case else
								  ls_color = "x4"
								end choose
							else
								ll_seq = ll_seq + 1
								ls_ins_gubn = "A"	
								ls_color = "x1"
								ll_color_tmp = 1
								ls_mat_tmp = ls_mat_cd
							end if		

						end if						
						
						
					end if
					
				end if    


				//ls_yymmdd
				li_find = PosA(ls_data,",")
				ls_yymmdd = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_yymmdd = of_str_replace(ls_yymmdd, "-" , "")
				ls_data =MidA(ls_data,li_find+1,1000)

				//ldc_price
/*				
				li_find = pos(ls_data,",")
				ls_price = Trim(Mid(ls_data, 1,li_find - 1)) 
				ldc_price = Dec(ls_price)				
				ls_data =mid(ls_data,li_find+1,1000)
*/

				//mat_nm_chr1  (pass)
				li_find = PosA(ls_data,",")
				ls_data =MidA(ls_data,li_find+1,1000)
				
				//ls_mat_nm1
				li_find = PosA(ls_data,",")
				ls_mat_nm1 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)
				
				//ls_mat_rate1
				li_find = PosA(ls_data,",")
				ls_mat_rate1 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ldc_mat_rate1 = Dec(ls_mat_rate1)								
				ls_data =MidA(ls_data,li_find+1,1000)

				//mat_nm_chr2  (pass)
				li_find = PosA(ls_data,",")
				ls_data =MidA(ls_data,li_find+1,1000)
								
				//ls_mat_nm2
				li_find = PosA(ls_data,",")
				ls_mat_nm2 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)
				
				//ls_mat_rate2
				li_find = PosA(ls_data,",")
				ls_mat_rate2 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ldc_mat_rate2 = Dec(ls_mat_rate2)
				ls_data =MidA(ls_data,li_find+1,1000)

				//mat_nm_chr3  (pass)
				li_find = PosA(ls_data,",")
				ls_data =MidA(ls_data,li_find+1,1000)
												
				//ls_mat_nm3
				li_find = PosA(ls_data,",")
				ls_mat_nm3 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)
				
				//ls_mat_rate3
				li_find = PosA(ls_data,",")
				ls_mat_rate3 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ldc_mat_rate3 = Dec(ls_mat_rate3)				
				ls_data =MidA(ls_data,li_find+1,1000)

				//mat_nm_chr4  (pass)
				li_find = PosA(ls_data,",")
				ls_data =MidA(ls_data,li_find+1,1000)
																
				//ls_mat_nm4
				li_find = PosA(ls_data,",")
				ls_mat_nm4 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)
				
				//ls_mat_rate4
				li_find = PosA(ls_data,",")
				ls_mat_rate4 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ldc_mat_rate4 = Dec(ls_mat_rate4)				
				ls_data =MidA(ls_data,li_find+1,1000)

				//mat_nm_chr5  (pass)
				li_find = PosA(ls_data,",")
				ls_data =MidA(ls_data,li_find+1,1000)
																
				//ls_mat_nm5
				li_find = PosA(ls_data,",")
				ls_mat_nm5 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)
				
				//ls_mat_rate5
				li_find = PosA(ls_data,",")
				ls_mat_rate5 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ldc_mat_rate5 = Dec(ls_mat_rate5)				
				ls_data =MidA(ls_data,li_find+1,1000)

				//mat_nm_chr6  (pass)
				li_find = PosA(ls_data,",")
				ls_data =MidA(ls_data,li_find+1,1000)
																
				//ls_mat_nm6
				li_find = PosA(ls_data,",")
				ls_mat_nm6 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)
				
				//ls_mat_rate6
				li_find = PosA(ls_data,",")
				ls_mat_rate6 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ldc_mat_rate6 = Dec(ls_mat_rate6)				
				ls_data =MidA(ls_data,li_find+1,1000)

				//mat_nm_chr7  (pass)
				li_find = PosA(ls_data,",")
				ls_data =MidA(ls_data,li_find+1,1000)
				
				//ls_MAT_NM7
				li_find = PosA(ls_data,",")
				ls_MAT_NM7 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)
				
				//ls_MAT_RATE7
				li_find = PosA(ls_data,",")
				ls_MAT_RATE7 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ldc_mat_rate7 = Dec(ls_mat_rate7)				
				ls_data =MidA(ls_data,li_find+1,1000)

				//mat_nm_chr8  (pass)
				li_find = PosA(ls_data,",")
				ls_data =MidA(ls_data,li_find+1,1000)
												
				//ls_MAT_NM8
				li_find = PosA(ls_data,",")
				ls_MAT_NM8 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_MAT_RATE8
				li_find = PosA(ls_data,",")
				ls_MAT_RATE8 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ldc_mat_rate8 = Dec(ls_mat_rate8)				
				ls_data =MidA(ls_data,li_find+1,1000)

				//mat_rate_sum  (pass)
				li_find = PosA(ls_data,",")
				ls_data =MidA(ls_data,li_find+1,1000)

				//ls_KSK0650_V
				li_find = PosA(ls_data,",")
				ls_KSK0650_V = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0650_V_YN
				li_find = PosA(ls_data,",")
				ls_KSK0650_V_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KSK0650_V_YN = long(ls_KSK0650_V_YN)								
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0650_H
				li_find = PosA(ls_data,",")
				ls_KSK0650_H = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0650_H_YN
				li_find = PosA(ls_data,",")
				ls_KSK0650_H_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KSK0650_H_YN = long(ls_KSK0650_H_YN)								
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0430_V
				li_find = PosA(ls_data,",")
				ls_KSK0430_V = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0430_V_YN
				li_find = PosA(ls_data,",")
				ls_KSK0430_V_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KSK0430_V_YN = long(ls_KSK0430_V_YN)												
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_A_1_H
				li_find = PosA(ls_data,",")
				ls_A_1_H = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_A_1_H_YN
				li_find = PosA(ls_data,",")
				ls_A_1_H_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_A_1_H_YN = long(ls_A_1_H_YN)												
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0645_V
				li_find = PosA(ls_data,",")
				ls_KSK0645_V = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0645_V_YN
				li_find = PosA(ls_data,",")
				ls_KSK0645_V_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KSK0645_V_YN = long(ls_KSK0645_V_YN)												
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0645_H
				li_find = PosA(ls_data,",")
				ls_KSK0645_H = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0645_H_YN
				li_find = PosA(ls_data,",")
				ls_KSK0645_H_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KSK0645_H_YN = long(ls_KSK0645_H_YN)												
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0644_V
				li_find = PosA(ls_data,",")
				ls_KSK0644_V = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0644_V_YN
				li_find = PosA(ls_data,",")
				ls_KSK0644_V_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KSK0644_V_YN = long(ls_KSK0644_V_YN)												
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0644_H
				li_find = PosA(ls_data,",")
				ls_KSK0644_H = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0644_H_YN
				li_find = PosA(ls_data,",")
				ls_KSK0644_H_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KSK0644_H_YN = long(ls_KSK0644_H_YN)												
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0535_V
				li_find = PosA(ls_data,",")
				ls_KSK0535_V = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0535_V_YN
				li_find = PosA(ls_data,",")
				ls_KSK0535_V_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KSK0535_V_YN = long(ls_KSK0535_V_YN)												
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0535_H
				li_find = PosA(ls_data,",")
				ls_KSK0535_H = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0535_H_YN
				li_find = PosA(ls_data,",")
				ls_KSK0535_H_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KSK0535_H_YN = long(ls_KSK0535_H_YN)												
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_IRONG12_V
				li_find = PosA(ls_data,",")
				ls_IRONG12_V = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_IRONG12_V_YN
				li_find = PosA(ls_data,",")
				ls_IRONG12_V_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_IRONG12_V_YN = long(ls_IRONG12_V_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_IRONG12_H
				li_find = PosA(ls_data,",")
				ls_IRONG12_H = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_IRONG12_H_YN
				li_find = PosA(ls_data,",")
				ls_IRONG12_H_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_IRONG12_H_YN = long(ls_IRONG12_H_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0465_V
				li_find = PosA(ls_data,",")
				ls_KSK0465_V = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0465_V_YN
				li_find = PosA(ls_data,",")
				ls_KSK0465_V_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KSK0465_V_YN = long(ls_KSK0465_V_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0465_H
				li_find = PosA(ls_data,",")
				ls_KSK0465_H = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KSK0465_H_YN
				li_find = PosA(ls_data,",")
				ls_KSK0465_H_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KSK0465_H_YN = long(ls_KSK0465_H_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_IWS117_V
				li_find = PosA(ls_data,",")
				ls_IWS117_V = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_IWS117_V_YN
				li_find = PosA(ls_data,",")
				ls_IWS117_V_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_IWS117_V_YN = long(ls_IWS117_V_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_IWS117_H
				li_find = PosA(ls_data,",")
				ls_IWS117_H = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_IWS117_H_YN
				li_find = PosA(ls_data,",")
				ls_IWS117_H_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_IWS117_H_YN = long(ls_IWS117_H_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_Daylight
				li_find = PosA(ls_data,",")
				ls_Daylight = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_Daylight_YN
				li_find = PosA(ls_data,",")
				ls_Daylight_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_Daylight_YN = long(ls_Daylight_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_Coloring
				li_find = PosA(ls_data,",")
				ls_Coloring = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_Coloring_YN
				li_find = PosA(ls_data,",")
				ls_Coloring_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_Coloring_YN = long(ls_Coloring_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_Pollution
				li_find = PosA(ls_data,",")
				ls_Pollution = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_Pollution_YN
				li_find = PosA(ls_data,",")
				ls_Pollution_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_Pollution_YN = long(ls_Pollution_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_Pilling
				li_find = PosA(ls_data,",")
				ls_Pilling = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_Pilling_YN
				li_find = PosA(ls_data,",")
				ls_Pilling_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_Pilling_YN = long(ls_Pilling_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_etc_1
				li_find = PosA(ls_data,",")
				ls_etc_1 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_etc_1_YN
				li_find = PosA(ls_data,",")
				ls_etc_1_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_etc_1_YN = long(ls_etc_1_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_etc_2
				li_find = PosA(ls_data,",")
				ls_etc_2 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_etc_2_YN
				li_find = PosA(ls_data,",")
				ls_etc_2_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_etc_2_YN = long(ls_etc_2_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_etc_3
				li_find = PosA(ls_data,",")
				ls_etc_3 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_etc_3_YN
				li_find = PosA(ls_data,",")
				ls_etc_3_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_etc_3_YN = long(ls_etc_3_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_etc_4
				li_find = PosA(ls_data,",")
				ls_etc_4 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_etc_4_YN
				li_find = PosA(ls_data,",")
				ls_etc_4_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_etc_4_YN = long(ls_etc_4_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_etc_5
				li_find = PosA(ls_data,",")
				ls_etc_5 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_etc_5_YN
				li_find = PosA(ls_data,",")
				ls_etc_5_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_etc_5_YN = long(ls_etc_5_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_3922
				li_find = PosA(ls_data,",")
				ls_GBT_3922 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_3922_YN
				li_find = PosA(ls_data,",")
				ls_GBT_3922_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_GBT_3922_YN = long(ls_GBT_3922_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_2912
				li_find = PosA(ls_data,",")
				ls_GBT_2912 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_2912_YN
				li_find = PosA(ls_data,",")
				ls_GBT_2912_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_GBT_2912_YN = long(ls_GBT_2912_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_7528
				li_find = PosA(ls_data,",")
				ls_GBT_7528 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_7528_YN
				li_find = PosA(ls_data,",")
				ls_GBT_7528_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_GBT_7528_YN = long(ls_GBT_7528_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_18401
				li_find = PosA(ls_data,",")
				ls_GBT_18401 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_18401_YN
				li_find = PosA(ls_data,",")
				ls_GBT_18401_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_GBT_18401_YN = long(ls_GBT_18401_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_1
				li_find = PosA(ls_data,",")
				ls_GBT_1 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_1_YN
				li_find = PosA(ls_data,",")
				ls_GBT_1_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_GBT_1_YN = long(ls_GBT_1_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_2
				li_find = PosA(ls_data,",")
				ls_GBT_2 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_2_YN
				li_find = PosA(ls_data,",")
				ls_GBT_2_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_GBT_2_YN = long(ls_GBT_2_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_3
				li_find = PosA(ls_data,",")
				ls_GBT_3 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_3_YN
				li_find = PosA(ls_data,",")
				ls_GBT_3_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_GBT_3_YN = long(ls_GBT_3_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_4
				li_find = PosA(ls_data,",")
				ls_GBT_4 = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_GBT_4_YN
				li_find = PosA(ls_data,",")
				ls_GBT_4_YN = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_GBT_4_YN = long(ls_GBT_4_YN)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KC_aryl
				li_find = PosA(ls_data,",")
				ls_KC_aryl = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KC_aryl_yn
				li_find = PosA(ls_data,",")
				ls_KC_aryl_yn = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KC_aryl_yn = long(ls_KC_aryl_yn)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KC_pH
				li_find = PosA(ls_data,",")
				ls_KC_pH = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KC_pH_yn
				li_find = PosA(ls_data,",")
				ls_KC_pH_yn = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KC_pH_yn = long(ls_KC_pH_yn)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KC_formald
				li_find = PosA(ls_data,",")
				ls_KC_formald = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KC_formald_yn
				li_find = PosA(ls_data,",")
				ls_KC_formald_yn = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KC_formald_yn = long(ls_KC_formald_yn)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KC_PCP
				li_find = PosA(ls_data,",")
				ls_KC_PCP = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KC_PCP_yn
				li_find = PosA(ls_data,",")
				ls_KC_PCP_yn = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KC_PCP_yn = long(ls_KC_PCP_yn)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KC_chrome
				li_find = PosA(ls_data,",")
				ls_KC_chrome = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KC_chrome_yn
				li_find = PosA(ls_data,",")
				ls_KC_chrome_yn = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KC_chrome_yn = long(ls_KC_chrome_yn)
				ls_data =MidA(ls_data,li_find+1,1000)


				//ls_KC_dmf
				li_find = PosA(ls_data,",")
				ls_KC_dmf = Trim(MidA(ls_data, 1,li_find - 1)) 
				ls_data =MidA(ls_data,li_find+1,1000)

				//ll_KC_dmf_yn
				li_find = PosA(ls_data,",")
				ls_KC_dmf_yn = Trim(MidA(ls_data, 1,li_find - 1)) 
				ll_KC_dmf_yn = long(ls_KC_dmf_yn)
				ls_data =MidA(ls_data,li_find+1,1000)



//######################  변수로 받기 END ################################



				dw_body.insertrow(0)
				

/******************기존에 등록되지 않은 데이타 등록 (ins_gubn=A)*************************/

						if ls_ins_gubn = "A" then
							
							ls_year = MidA(ls_mat_cd,3,1)
								
								choose case ls_year
									case "0"
										ls_year = "2010"
									case "1"
										ls_year = "2011"
									case "2"
										ls_year = "2012"
									case "3"
										ls_year = "2013"
									case "4"
										ls_year = "2014"
									case "5"
										ls_year = "2015"
									case "6"
										ls_year = "2016"
									case "7"
										ls_year = "2017"
									case "8"
										ls_year = "2018"
									case else
										ls_year = "2019"										
								end choose
							
							if is_gubn = "1" then

								INSERT INTO tb_kola_m(mat_cd, seq, year,reg_id, reg_dt)
								VALUES(:ls_mat_cd, :ll_seq, :ls_year, :gs_user_id, getdate());
								
								INSERT INTO tb_kola_d(mat_cd, seq, color, year,reg_id, reg_dt)
								VALUES(:ls_mat_cd, :ll_seq, :ls_color, :ls_year, :gs_user_id, getdate());			

							else
					
								INSERT INTO tb_fiti_m(mat_cd, seq, year,reg_id, reg_dt)
								VALUES(:ls_mat_cd, :ll_seq, :ls_year, :gs_user_id, getdate());
								
								INSERT INTO tb_fiti_d(mat_cd, seq, color, year,reg_id, reg_dt)
								VALUES(:ls_mat_cd, :ll_seq, 'x1', :ls_year, :gs_user_id, getdate());								

								INSERT INTO tb_fiti_d(mat_cd, seq, color, year,reg_id, reg_dt)
								VALUES(:ls_mat_cd, :ll_seq, 'x2', :ls_year, :gs_user_id, getdate());	

								INSERT INTO tb_fiti_d(mat_cd, seq, color, year,reg_id, reg_dt)
								VALUES(:ls_mat_cd, :ll_seq, 'x3', :ls_year, :gs_user_id, getdate());	

								INSERT INTO tb_fiti_d(mat_cd, seq, color, year,reg_id, reg_dt)
								VALUES(:ls_mat_cd, :ll_seq, 'x4', :ls_year, :gs_user_id, getdate());									

							end if
			
							ls_ins_gubn = "B"
				
						end if



/****************************************************************************************/


						dw_body.setitem(il_rows, "mat_cd",	ls_mat_cd)
						dw_body.setitem(il_rows, "seq",	ll_seq)
						dw_body.setitem(il_rows, "comment",	ls_comment)
						dw_body.setitem(il_rows, "color",	ls_color)
						dw_body.setitem(il_rows, "yymmdd",	ls_yymmdd)
						dw_body.setitem(il_rows, "price",	ldc_price)
						dw_body.setitem(il_rows, "mat_nm1",	ls_mat_nm1)
						dw_body.setitem(il_rows, "mat_rate1",	ldc_mat_rate1)
						dw_body.setitem(il_rows, "mat_nm2",	ls_mat_nm2)
						dw_body.setitem(il_rows, "mat_rate2",	ldc_mat_rate2)
						dw_body.setitem(il_rows, "mat_nm3",	ls_mat_nm3)
						dw_body.setitem(il_rows, "mat_rate3",	ldc_mat_rate3)
						dw_body.setitem(il_rows, "mat_nm4",	ls_mat_nm4)
						dw_body.setitem(il_rows, "mat_rate4",	ldc_mat_rate4)
						dw_body.setitem(il_rows, "mat_nm5",	ls_mat_nm5)
						dw_body.setitem(il_rows, "mat_rate5",	ldc_mat_rate5)
						dw_body.setitem(il_rows, "mat_nm6",	ls_mat_nm6)
						dw_body.setitem(il_rows, "mat_rate6",	ldc_mat_rate6)
						dw_body.setitem(il_rows, "MAT_NM7",	ls_MAT_NM7)
						dw_body.setitem(il_rows, "MAT_RATE7",	ldc_MAT_RATE7)
						dw_body.setitem(il_rows, "MAT_NM8",	ls_MAT_NM8)
						dw_body.setitem(il_rows, "MAT_RATE8",	ldc_MAT_RATE8)
						dw_body.setitem(il_rows, "KSK0650_V",	ls_KSK0650_V)
						dw_body.setitem(il_rows, "KSK0650_V_YN",	ll_KSK0650_V_YN)
						dw_body.setitem(il_rows, "KSK0650_H",	ls_KSK0650_H)
						dw_body.setitem(il_rows, "KSK0650_H_YN",	ll_KSK0650_H_YN)
						dw_body.setitem(il_rows, "KSK0430_V",	ls_KSK0430_V)
						dw_body.setitem(il_rows, "KSK0430_V_YN",	ll_KSK0430_V_YN)
						dw_body.setitem(il_rows, "A_1_H",	ls_A_1_H)
						dw_body.setitem(il_rows, "A_1_H_YN",	ll_A_1_H_YN)
						dw_body.setitem(il_rows, "KSK0645_V",	ls_KSK0645_V)
						dw_body.setitem(il_rows, "KSK0645_V_YN",	ll_KSK0645_V_YN)
						dw_body.setitem(il_rows, "KSK0645_H",	ls_KSK0645_H)
						dw_body.setitem(il_rows, "KSK0645_H_YN",	ll_KSK0645_H_YN)
						dw_body.setitem(il_rows, "KSK0644_V",	ls_KSK0644_V)
						dw_body.setitem(il_rows, "KSK0644_V_YN",	ll_KSK0644_V_YN)
						dw_body.setitem(il_rows, "KSK0644_H",	ls_KSK0644_H)
						dw_body.setitem(il_rows, "KSK0644_H_YN",	ll_KSK0644_H_YN)
						dw_body.setitem(il_rows, "KSK0535_V",	ls_KSK0535_V)
						dw_body.setitem(il_rows, "KSK0535_V_YN",	ll_KSK0535_V_YN)
						dw_body.setitem(il_rows, "KSK0535_H",	ls_KSK0535_H)
						dw_body.setitem(il_rows, "KSK0535_H_YN",	ll_KSK0535_H_YN)
						dw_body.setitem(il_rows, "IRONG12_V",	ls_IRONG12_V)
						dw_body.setitem(il_rows, "IRONG12_V_YN",	ll_IRONG12_V_YN)
						dw_body.setitem(il_rows, "IRONG12_H",	ls_IRONG12_H)
						dw_body.setitem(il_rows, "IRONG12_H_YN",	ll_IRONG12_H_YN)
						dw_body.setitem(il_rows, "KSK0465_V",	ls_KSK0465_V)
						dw_body.setitem(il_rows, "KSK0465_V_YN",	ll_KSK0465_V_YN)
						dw_body.setitem(il_rows, "KSK0465_H",	ls_KSK0465_H)
						dw_body.setitem(il_rows, "KSK0465_H_YN",	ll_KSK0465_H_YN)
						dw_body.setitem(il_rows, "IWS117_V",	ls_IWS117_V)
						dw_body.setitem(il_rows, "IWS117_V_YN",	ll_IWS117_V_YN)
						dw_body.setitem(il_rows, "IWS117_H",	ls_IWS117_H)
						dw_body.setitem(il_rows, "IWS117_H_YN",	ll_IWS117_H_YN)
						dw_body.setitem(il_rows, "Daylight",	ls_Daylight)
						dw_body.setitem(il_rows, "Daylight_YN",	ll_Daylight_YN)
						dw_body.setitem(il_rows, "Coloring",	ls_Coloring)
						dw_body.setitem(il_rows, "Coloring_YN",	ll_Coloring_YN)
						dw_body.setitem(il_rows, "Pollution",	ls_Pollution)
						dw_body.setitem(il_rows, "Pollution_YN",	ll_Pollution_YN)
						dw_body.setitem(il_rows, "Pilling",	ls_Pilling)
						dw_body.setitem(il_rows, "Pilling_YN",	ll_Pilling_YN)
						dw_body.setitem(il_rows, "etc_1",	ls_etc_1)
						dw_body.setitem(il_rows, "etc_1_YN",	ll_etc_1_YN)
						dw_body.setitem(il_rows, "etc_2",	ls_etc_2)
						dw_body.setitem(il_rows, "etc_2_YN",	ll_etc_2_YN)
						dw_body.setitem(il_rows, "etc_3",	ls_etc_3)
						dw_body.setitem(il_rows, "etc_3_YN",	ll_etc_3_YN)
						dw_body.setitem(il_rows, "etc_4",	ls_etc_4)
						dw_body.setitem(il_rows, "etc_4_YN",	ll_etc_4_YN)
						dw_body.setitem(il_rows, "etc_5",	ls_etc_5)
						dw_body.setitem(il_rows, "etc_5_YN",	ll_etc_5_YN)
						dw_body.setitem(il_rows, "GBT_3922",	ls_GBT_3922)
						dw_body.setitem(il_rows, "GBT_3922_YN",	ll_GBT_3922_YN)
						dw_body.setitem(il_rows, "GBT_2912",	ls_GBT_2912)
						dw_body.setitem(il_rows, "GBT_2912_YN",	ll_GBT_2912_YN)
						dw_body.setitem(il_rows, "GBT_7528",	ls_GBT_7528)
						dw_body.setitem(il_rows, "GBT_7528_YN",	ll_GBT_7528_YN)
						dw_body.setitem(il_rows, "GBT_18401",	ls_GBT_18401)
						dw_body.setitem(il_rows, "GBT_18401_YN",	ll_GBT_18401_YN)
						dw_body.setitem(il_rows, "GBT_1",	ls_GBT_1)
						dw_body.setitem(il_rows, "GBT_1_YN",	ll_GBT_1_YN)
						dw_body.setitem(il_rows, "GBT_2",	ls_GBT_2)
						dw_body.setitem(il_rows, "GBT_2_YN",	ll_GBT_2_YN)
						dw_body.setitem(il_rows, "GBT_3",	ls_GBT_3)
						dw_body.setitem(il_rows, "GBT_3_YN",	ll_GBT_3_YN)
						dw_body.setitem(il_rows, "GBT_4",	ls_GBT_4)
						dw_body.setitem(il_rows, "GBT_4_YN",	ll_GBT_4_YN)
						dw_body.setitem(il_rows, "KC_aryl",	ls_KC_aryl)
						dw_body.setitem(il_rows, "KC_aryl_yn",	ll_KC_aryl_yn)
						dw_body.setitem(il_rows, "KC_pH",	ls_KC_pH)
						dw_body.setitem(il_rows, "KC_pH_yn",	ll_KC_pH_yn)
						dw_body.setitem(il_rows, "KC_formald",	ls_KC_formald)
						dw_body.setitem(il_rows, "KC_formald_yn",	ll_KC_formald_yn)
						dw_body.setitem(il_rows, "KC_PCP",	ls_KC_PCP)
						dw_body.setitem(il_rows, "KC_PCP_yn",	ll_KC_PCP_yn)
						dw_body.setitem(il_rows, "KC_chrome",	ls_KC_chrome)
						dw_body.setitem(il_rows, "KC_chrome_yn",	ll_KC_chrome_yn)
						dw_body.setitem(il_rows, "KC_dmf",	ls_KC_dmf)
						dw_body.setitem(il_rows, "KC_dmf_yn",	ll_KC_dmf_yn)						
						dw_body.setitem(il_rows, "ins_gubn",	ls_ins_gubn)												

						il_rows ++ 		

/***********************************************************************/
//							messagebox("알림", ls_ins_gubn)	
//							messagebox("알림", ls_mat_cd)	
//							messagebox("알림", ls_mat_tmp)	
//							messagebox("알림", ls_ins_gubn)	
/***********************************************************************/			
									



			END IF			
			ll_FileLen = FileRead(li_FileNum, ls_data) 
		LOOP

		FILECLOSE(li_FileNum)

		dw_body.SetFocus()

//		cb_update.enabled = true
		

end if

end subroutine

on w_fiti_103_e.create
call super::create
end on

on w_fiti_103_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_gubn = dw_head.GetItemString(1, "gubn")

return true
end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_gubn)
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
      dw_body.Setitem(i, "gubn", is_gubn)		
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF


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

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
      else
         dw_head.SetFocus()
      end if

   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_insert.enabled = false
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
         cb_insert.enabled = true
      end if
END CHOOSE
cb_retrieve.enabled = true
end event

type cb_close from w_com010_e`cb_close within w_fiti_103_e
end type

type cb_delete from w_com010_e`cb_delete within w_fiti_103_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_fiti_103_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_fiti_103_e
end type

type cb_update from w_com010_e`cb_update within w_fiti_103_e
end type

type cb_print from w_com010_e`cb_print within w_fiti_103_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_fiti_103_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_fiti_103_e
end type

type cb_excel from w_com010_e`cb_excel within w_fiti_103_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_fiti_103_e
integer x = 27
integer width = 3547
integer height = 108
string dataobject = "d_kola_h02"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')

end event

event dw_head::buttonclicked;call super::buttonclicked;/* 화일 탐색 */
string  ls_path, ls_file_nm
integer li_value

is_gubn = dw_head.getitemstring(1,"gubn")
is_brand = dw_head.getitemstring(1,"brand")

choose case dwo.name
	case "cb_file_nm"
		
		li_value = GetFileOpenName("Select File", ls_path, ls_file_nm, "CSV", "Csv Files (*.csv),*.csv")
	
		IF li_value = 1 THEN 
			dw_head.Setitem(1, "file_nm", ls_path)	
			wf_getfile()	
		END IF

	case "cb_realdata_upd"
			
//			MessageBox("시작", "start") 
			
			DECLARE sp_fiti_103_d01_Upd PROCEDURE FOR sp_fiti_103_d01_Upd ;
			execute sp_fiti_103_d01_Upd;	
			
			IF SQLCA.SQLCODE >= 0 THEN 
  				   commit  USING SQLCA;	
					MessageBox("Complete", "실데이타로 모두 적용 되었습니다.") 
			else		
					MessageBox("오류", "실패하였습니다..") 
			END IF


			
end choose








parent.Trigger Event ue_button(1, li_value)
parent.Trigger Event ue_msg(1, li_value)
end event

type ln_1 from w_com010_e`ln_1 within w_fiti_103_e
integer beginy = 288
integer endy = 288
end type

type ln_2 from w_com010_e`ln_2 within w_fiti_103_e
integer beginy = 292
integer endy = 292
end type

type dw_body from w_com010_e`dw_body within w_fiti_103_e
integer y = 312
string dataobject = "d_fiti_d03"
boolean hscrollbar = true
end type

event dw_body::dberror;//
end event

type dw_print from w_com010_e`dw_print within w_fiti_103_e
end type

