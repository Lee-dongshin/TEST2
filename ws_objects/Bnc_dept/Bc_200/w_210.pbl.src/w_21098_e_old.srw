$PBExportHeader$w_21098_e_old.srw
$PBExportComments$케어라벨입력
forward
global type w_21098_e_old from w_com030_e
end type
type dw_2 from datawindow within w_21098_e_old
end type
type dw_copy_ord from datawindow within w_21098_e_old
end type
type dw_1 from datawindow within w_21098_e_old
end type
type dw_3 from datawindow within w_21098_e_old
end type
type dw_4 from datawindow within w_21098_e_old
end type
type dw_5 from datawindow within w_21098_e_old
end type
type dw_9 from datawindow within w_21098_e_old
end type
type dw_6 from datawindow within w_21098_e_old
end type
type dw_7 from datawindow within w_21098_e_old
end type
end forward

global type w_21098_e_old from w_com030_e
integer width = 3648
integer height = 2248
dw_2 dw_2
dw_copy_ord dw_copy_ord
dw_1 dw_1
dw_3 dw_3
dw_4 dw_4
dw_5 dw_5
dw_9 dw_9
dw_6 dw_6
dw_7 dw_7
end type
global w_21098_e_old w_21098_e_old

type variables
string  is_style_no, is_style, is_chno, is_color, is_p_no1, is_p_no2, is_p_no3, is_p_no4  , is_washing1, is_washing2, is_washing3, is_washing4, is_washing5, is_washing6
string  is_brand, is_year, is_season, is_sojae, is_item, is_country_cd, is_reg_dt, is_mat_cd, is_mat_color

//string  as_mat_nm1, as_mat_rate1, as_mat_nm2,as_mat_rate2, as_mat_nm3,as_mat_rate3, as_mat_nm4, as_mat_rate4, as_mat_nm5, as_mat_rate5  
datawindowchild idw_color, idw_color1, idw_brand, idw_season, idw_sojae, idw_item, idw_fabric_by, idw_sect_nm, idw_country_cd
end variables

forward prototypes
public function boolean wf_chk_remark (string as_maker_fg)
public subroutine wf_mat_rate_copy (string as_style, string as_chno, string as_color)
end prototypes

public function boolean wf_chk_remark (string as_maker_fg);string ls_remark_1, ls_remark_2, ls_remark_3, ls_remark_4, ls_remark_5
int ll_found

//messagebox("as_maker_fg",as_maker_fg)
//if as_maker_fg = '2'  then //판매원, 수입/판매원
//	ll_found = dw_body.Find("remark1 like '%수입자%'", 1, 1)
//	if ll_found > 0 then return false
//	
//	ll_found = dw_body.Find("remark2 like '%수입자%'", 1, 1)
//	if ll_found > 0 then return false
//	
//	ll_found = dw_body.Find("remark3 like '%수입자%'", 1, 1)
//	if ll_found > 0 then return false
//	
//	ll_found = dw_body.Find("remark4 like '%수입자%'", 1, 1)
//	if ll_found > 0 then return false
//	
//	ll_found = dw_body.Find("remark5 like '%수입자%'", 1, 1)
//	if ll_found > 0 then return false
//elseif as_maker_fg = '1'  then
//	ll_found = dw_body.Find("remark1 like '%수입자%'", 1, 1)
//	if ll_found > 0 then return true
//	
//	ll_found = dw_body.Find("remark2 like '%수입자%'", 1, 1)
//	if ll_found > 0 then return true
//	
//	ll_found = dw_body.Find("remark3 like '%수입자%'", 1, 1)
//	if ll_found > 0 then return true
//	
//	ll_found = dw_body.Find("remark4 like '%수입자%'", 1, 1)
//	if ll_found > 0 then return true
//	
//	ll_found = dw_body.Find("remark5 like '%수입자%'", 1, 1)
//	if ll_found > 0 then return true	
//	return false
//else
//	return false
//end if

return false

		


end function

public subroutine wf_mat_rate_copy (string as_style, string as_chno, string as_color);string  as_mat_nm1, as_mat_rate1, as_mat_nm2,as_mat_rate2, as_mat_nm3,as_mat_rate3, as_mat_nm4, as_mat_rate4, as_mat_nm5, as_mat_rate5  
string  ls_mat_nm1, ls_mat_rate1, ls_mat_nm2,ls_mat_rate2, ls_mat_nm3,ls_mat_rate3, ls_mat_nm4, ls_mat_rate4, ls_mat_nm5, ls_mat_rate5  	
string  ls_country_cd

//	 select case country_cd when '00' then 'KOREA' when '02' then 'JAPAN' 
//	 					when '06' then 'CHINA' when '08' then 'ITALY' else 'KOREA' end 
//	 select left(dbo.sf_inter_cd1('000',country_cd),5)
//	 	 		into :ls_country_cd  
//	 FROM 	tb_12021_d  WITH (NOLOCK)
//	 WHERE  STYLE  = :AS_STYLE
//	 AND	  CHNO   = :AS_CHNO;
//	 
//dw_body.setitem(1,"country_cd",ls_country_cd)

	 
	 

ls_mat_nm1 =  "' '"  
ls_mat_nm2 =  "' '" 
ls_mat_nm3 =  "' '"  
ls_mat_nm4 =  "' '" 
ls_mat_nm5 =  "' '"  
	  	
	SELECT 	A.MAT_NM1,
				A.MAT_RATE1,
				A.MAT_NM2,
				A.MAT_RATE2,
				A.MAT_NM3,
				A.MAT_RATE3,
				A.MAT_NM4,
				A.MAT_RATE4,
				A.MAT_NM5,
				A.MAT_RATE5 
	 INTO    :ls_mat_nm1, 
	 			:ls_mat_rate1,  
				:ls_mat_nm2, 
	 			:ls_mat_rate2,  
				:ls_mat_nm3, 
	 			:ls_mat_rate3,  
				:ls_mat_nm4, 
	 			:ls_mat_rate4,  
				:ls_mat_nm5, 
	 			:ls_mat_rate5  
	 FROM 	TB_21015_D  A WITH (NOLOCK) , TB_12025_D B  WITH (NOLOCK)
	 WHERE  B.STYLE  = :AS_STYLE
	 AND	  B.CHNO   = :AS_CHNO
	 AND    B.COLOR  = :AS_COLOR
	 AND    A.MAT_CD = B.MAT_CD
	 AND    A.COLOR  = B.MAT_COLOR;
	 
	 if ls_mat_nm1 = "' '"   then 
			SELECT 	dbo.sf_inter_nm('213',A.MAT_NM1)	as mat_nm1 ,
						A.MAT_RATE1,
						dbo.sf_inter_nm('213',A.MAT_NM2)	as mat_nm2 ,
						A.MAT_RATE2,
						dbo.sf_inter_nm('213',A.MAT_NM3)	as mat_nm3 ,
						A.MAT_RATE3,
						dbo.sf_inter_nm('213',A.MAT_NM4)	as mat_nm4 ,
						A.MAT_RATE4,
						dbo.sf_inter_nm('213',A.MAT_NM5)	as mat_nm5 ,
						A.MAT_RATE5 
			 INTO    :ls_mat_nm1, 
						:ls_mat_rate1,  
						:ls_mat_nm2, 
						:ls_mat_rate2,  
						:ls_mat_nm3, 
						:ls_mat_rate3,  
						:ls_mat_nm4, 
						:ls_mat_rate4,  
						:ls_mat_nm5, 
						:ls_mat_rate5  
			 FROM 	TB_fiti_D  A WITH (NOLOCK)
			 WHERE  a.mat_cd = :as_style + :as_chno;

			 
	 		
	 end if
	 
	 
	 
	 as_mat_nm1 = dw_body.GetitemString(1,"mat_nm1")
	 as_mat_nm2 = dw_body.GetitemString(1,"mat_nm2")
	 as_mat_nm3 = dw_body.GetitemString(1,"mat_nm3")
	 as_mat_nm4 = dw_body.GetitemString(1,"mat_nm4")
	 as_mat_nm5 = dw_body.GetitemString(1,"mat_nm5")
		   
	 
	if ls_mat_nm1 <> "' '"   then 
		if dw_body.dataobject = "d_21098_d01"  then
			dw_body.Setitem(1,"mat_gubn1","겉  감")
		else
			dw_body.Setitem(1,"mat_gubn1","속  감")
		end if
		dw_body.Setitem(1,"mat_nm1",ls_mat_nm1)
		dw_body.Setitem(1,"mat_rate1",ls_mat_rate1)
		cb_update.enabled = true
		dw_body.AcceptText()
	end if
	
	
	if ls_mat_nm2 <>  "' '" and dec(ls_mat_rate1) < 100  then 
		dw_body.Setitem(1,"mat_nm2",ls_mat_nm2)
		dw_body.Setitem(1,"mat_rate2",ls_mat_rate2)
		cb_update.enabled = true
		dw_body.AcceptText()
	end if
	
	
	
	if ls_mat_nm3 <>  "' '" and (dec(ls_mat_rate1) + dec(ls_mat_rate2)) < 100  then 
			dw_body.Setitem(1,"mat_nm3",ls_mat_nm3)
			dw_body.Setitem(1,"mat_rate3",ls_mat_rate3)
			cb_update.enabled = true
			dw_body.AcceptText()
	end if
	
	if ls_mat_nm4 <>  "' '" and (dec(ls_mat_rate1) + dec(ls_mat_rate2) + dec(ls_mat_rate3)) < 100 then 
			dw_body.Setitem(1,"mat_nm4",ls_mat_nm4)
			dw_body.Setitem(1,"mat_rate4",ls_mat_rate4)
			cb_update.enabled = true
			dw_body.AcceptText()
	end if
	
	if ls_mat_nm5 <>  "' '" and (dec(ls_mat_rate1) + dec(ls_mat_rate2) + dec(ls_mat_rate3) + dec(ls_mat_rate4)) < 100 then 
			dw_body.Setitem(1,"mat_nm5",ls_mat_nm5)
			dw_body.Setitem(1,"mat_rate5",ls_mat_rate5)
			cb_update.enabled = true
			dw_body.AcceptText()
	end if
		
//	if ls_mat_nm2 <>  "' '"  then 
//	 	if ls_mat_nm2 <> as_mat_nm2 then
//			dw_body.Setitem(1,"mat_nm2",ls_mat_nm2)
//			dw_body.Setitem(1,"mat_rate2",ls_mat_rate2)
//			cb_update.enabled = true
//			dw_body.AcceptText()
//		end if
//	end if
//	
//	
//	
//	if ls_mat_nm3 <>  "' '"   then 
//	 	if ls_mat_nm3 <> as_mat_nm3 then
//			dw_body.Setitem(1,"mat_nm3",ls_mat_nm3)
//			dw_body.Setitem(1,"mat_rate3",ls_mat_rate3)
//			cb_update.enabled = true
//			dw_body.AcceptText()
//		end if
//	end if
//	
//	if ls_mat_nm4 <>  "' '"  then 
//		if ls_mat_nm4 <> as_mat_nm4 then
//			dw_body.Setitem(1,"mat_nm4",ls_mat_nm4)
//			dw_body.Setitem(1,"mat_rate4",ls_mat_rate4)
//			cb_update.enabled = true
//			dw_body.AcceptText()
//		end if
//	end if
//	
//	if ls_mat_nm5 <>  "' '"  then 
//	 	if ls_mat_nm5 <> as_mat_nm5 then
//			dw_body.Setitem(1,"mat_nm5",ls_mat_nm5)
//			dw_body.Setitem(1,"mat_rate5",ls_mat_rate5)
//			cb_update.enabled = true
//			dw_body.AcceptText()
//		end if
//	end if
//	

 
	 
	
end subroutine

on w_21098_e_old.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_copy_ord=create dw_copy_ord
this.dw_1=create dw_1
this.dw_3=create dw_3
this.dw_4=create dw_4
this.dw_5=create dw_5
this.dw_9=create dw_9
this.dw_6=create dw_6
this.dw_7=create dw_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_copy_ord
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_3
this.Control[iCurrent+5]=this.dw_4
this.Control[iCurrent+6]=this.dw_5
this.Control[iCurrent+7]=this.dw_9
this.Control[iCurrent+8]=this.dw_6
this.Control[iCurrent+9]=this.dw_7
end on

on w_21098_e_old.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.dw_copy_ord)
destroy(this.dw_1)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.dw_5)
destroy(this.dw_9)
destroy(this.dw_6)
destroy(this.dw_7)
end on

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
dw_5.SetTransObject(SQLCA)
dw_6.SetTransObject(SQLCA)
dw_7.SetTransObject(SQLCA)
dw_9.SetTransObject(SQLCA)



end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_sojae = Trim(dw_head.GetItemString(1, "sojae"))
if IsNull(is_sojae) or is_sojae = "" then
   MessageBox(ls_title,"소재 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = Trim(dw_head.GetItemString(1, "item"))
if IsNull(is_item) or is_item = "" then
   MessageBox(ls_title,"품종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if


is_style_no = Trim(dw_head.GetItemString(1, "style_no"))

is_country_cd = Trim(dw_head.GetItemString(1, "country_cd"))
is_reg_dt = Trim(dw_head.GetItemString(1, "reg_dt"))
is_mat_cd = Trim(dw_head.GetItemString(1, "mat_cd"))
return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                               */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

is_style =  LeftA(is_style_no,8)
il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_style, is_country_cd, is_reg_dt, is_mat_cd)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSE
   dw_body.InsertRow(0)
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      		  */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
long i, ll_row_count, ll_max_rate_all
int li_chk, ll_qty
datetime ld_datetime
string ls_chk, ls_qute, ls_maker_fg, ls_washing_type

ls_qute = "'"

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF
if dw_body.dataobject = "d_21098_d01"  then //겉감
	select qty into :ll_qty from tb_12029_tl (nolock) where style = :is_style &
	and chno = :is_chno and color = :is_color and tl_gbn = '3'  and reprint is null;
	if ll_qty > 0 then 
		messagebox("확인","케어라벨이 이미 발행되었기에 수정 불가합니다..")
		return 0	
	end if

else													  //속감
	select qty into :ll_qty from tb_12029_tl (nolock) where style = :is_style &
	and chno = :is_chno and color = :is_color and tl_gbn = '8' and reprint is null;
	if ll_qty > 0 then 
		messagebox("확인","속감케어라벨이 이미 발행되었기에 수정 불가합니다..")
		return 0	
	end if

end if



ll_max_rate_all = dw_body.getitemnumber(1,"mat_rate_all")
if ll_max_rate_all <> 0 then  
	messagebox("확인","혼용율이 100%가 아닙니다..다시한번 확인해주세요..")
	return 0
end if


ls_washing_type = dw_body.getitemstring(1, "washing_type")
if isnull(ls_washing_type) or ls_washing_type = '' then 
	messagebox("주의", "세탁표시방법을 확인하세요..")
	dw_body.setfocus()
	dw_body.setrow(1)
	dw_body.setcolumn("washing_type")
	return -1
end if


ls_maker_fg = dw_body.getitemstring(1, "maker_fg")
if wf_chk_remark(ls_maker_fg) then 
	messagebox("주의", "취급주의에 수입원을 확인하세요..")
	dw_body.setfocus()
	dw_body.setrow(1)
	dw_body.setcolumn("remark1")
	return -1
end if	


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN			/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
	if dw_body.dataobject = "d_21098_d01" then 
		select  	
			((convert(int,replace(MAT_RATE1,:ls_qute,'')) +
			convert(int,replace(MAT_RATE2,:ls_qute,'')) +
			convert(int,replace(MAT_RATE3,:ls_qute,'')) + 
			convert(int,replace(MAT_RATE4,:ls_qute,'')) + 
			convert(int,replace(MAT_RATE5,:ls_qute,'')) + 
			convert(int,replace(MAT_RATE6,:ls_qute,'')) + 
			convert(int,replace(MAT_RATE7,:ls_qute,'')) + 
			convert(int,replace(MAT_RATE8,:ls_qute,''))  ) % 100) 
			+ 
case when exists (select inter_cd from tb_91011_c (nolock) 
where inter_grp = '213'
and   inter_nm = a.mat_nm1) then 0 else 1 end
+
case when exists (select inter_cd from tb_91011_c (nolock) 
where inter_grp = '213'
and   inter_nm = a.mat_nm2) then 0 else 1 end
+
case when exists (select inter_cd from tb_91011_c (nolock) 
where inter_grp = '213'
and   inter_nm = a.mat_nm3) then 0 else 1 end
+
case when exists (select inter_cd from tb_91011_c (nolock) 
where inter_grp = '213'
and   inter_nm = a.mat_nm4) then 0 else 1 end
+
case when exists (select inter_cd from tb_91011_c (nolock) 
where inter_grp = '213'
and   inter_nm = a.mat_nm5) then 0 else 1 end
+
case when exists (select inter_cd from tb_91011_c (nolock) 
where inter_grp = '213'
and   inter_nm = a.mat_nm6) then 0 else 1 end

			into :li_chk
		from TB_12029_D a(nolock) 
		where style = :is_style
		and   chno  = :is_chno
		and   color = :is_color;
	else
		select  	
			((convert(int,replace(MAT_RATE1,:ls_qute,'')) +
			convert(int,replace(MAT_RATE2,:ls_qute,'')) +
			convert(int,replace(MAT_RATE3,:ls_qute,'')) + 
			convert(int,replace(MAT_RATE4,:ls_qute,'')) + 
			convert(int,replace(MAT_RATE5,:ls_qute,'')) + 
			convert(int,replace(MAT_RATE6,:ls_qute,'')) + 
			convert(int,replace(MAT_RATE7,:ls_qute,'')) + 
			convert(int,replace(MAT_RATE8,:ls_qute,''))  ) % 100) into :li_chk
		from TB_12029_E (nolock) 
		where style = :is_style
		and   chno  = :is_chno
		and   color = :is_color;		
	end if
	
	if li_chk = 0 then    
		dw_body.ResetUpdate()	
		
			//////모링꽁뜨 작지 자동생성////////
//		if is_brand = 'O' then 
//					 DECLARE sp_make_morine_12029_d PROCEDURE FOR sp_make_morine_12029_d  
//								@style		 = :is_style,
//								@chno  	    = :is_chno;						
//					 execute sp_make_morine_12029_d;				 
//		end if
		
			////////////////////////////////////////////////////
		
		commit  USING SQLCA;
	else
		messagebox("확인","섬유조성을 올바로 입력하세요..")
//	   rollback  USING SQLCA;	
//		dw_body.setfocus()
	end if
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows


end event

type cb_close from w_com030_e`cb_close within w_21098_e_old
end type

type cb_delete from w_com030_e`cb_delete within w_21098_e_old
boolean visible = false
end type

type cb_insert from w_com030_e`cb_insert within w_21098_e_old
string text = "복사"
end type

event cb_insert::clicked;call super::clicked;string ls_gubn
	if dw_body.dataobject = 'd_21098_d01' then 
		ls_gubn = 'o'
	else
		ls_gubn = 'i'
	end if
	
 DECLARE sp_21093_d02 PROCEDURE FOR sp_21093_d02  
  @ps_style = :is_style,
  @ps_chno  = :is_chno,
  @ps_color = :is_color,
  @gubn     = :ls_gubn;

execute sp_21093_d02;


il_rows = dw_body.retrieve(is_style, is_chno,is_color)


idw_color1.Retrieve(is_style,is_chno)

IF il_rows = 0 THEN
	dw_body.Reset()
	dw_body.Insertrow(0)
END IF

dw_body.Setitem(1, "style", is_style)
dw_body.Setitem(1, "chno", is_chno)
dw_body.Setitem(1, "color", is_color)





end event

type cb_retrieve from w_com030_e`cb_retrieve within w_21098_e_old
end type

type cb_update from w_com030_e`cb_update within w_21098_e_old
end type

type cb_print from w_com030_e`cb_print within w_21098_e_old
boolean visible = false
end type

type cb_preview from w_com030_e`cb_preview within w_21098_e_old
boolean visible = false
end type

type gb_button from w_com030_e`gb_button within w_21098_e_old
integer x = 5
end type

type cb_excel from w_com030_e`cb_excel within w_21098_e_old
integer width = 439
string text = "케어라벨 복사!"
end type

event cb_excel::clicked;dw_copy_ord.insertrow(0)
dw_copy_ord.setitem(1,"fr_style", is_style)
dw_copy_ord.setitem(1,"fr_chno", is_chno)
dw_copy_ord.visible = true
dw_copy_ord.setcolumn("to_style")
end event

type dw_head from w_com030_e`dw_head within w_21098_e_old
integer y = 184
integer height = 228
string dataobject = "d_21093_h01"
end type

event dw_head::constructor;call super::constructor;

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%')
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')


This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%')
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')



end event

type ln_1 from w_com030_e`ln_1 within w_21098_e_old
end type

type ln_2 from w_com030_e`ln_2 within w_21098_e_old
end type

type dw_list from w_com030_e`dw_list within w_21098_e_old
integer x = 0
integer width = 1381
string dataobject = "d_21098_l01"
boolean hscrollbar = true
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long  ll_body_rows, ll_detail_rows
string ls_mat_nm1, ls_remark1, ls_country_nm, ls_sect_nm, ls_flag, ls_cust_nm, ls_sojae
IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_style = This.GetItemString(row, 'style') /* DataWindow에 Key 항목을 가져온다 */
is_chno  = This.GetItemString(row, 'chno') /* DataWindow에 Key 항목을 가져온다 */
is_color = This.GetItemString(row, 'color') /* DataWindow에 Key 항목을 가져온다 */
ls_sojae = This.GetItemString(row, 'sojae') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_style) or IsNull(is_chno)  or IsNull(is_color)  THEN return

il_rows = dw_body.retrieve(is_style, is_chno,is_color)
if il_rows > 0 then
	
	ls_flag = dw_body.getitemstring(1,"flag")
	
	if ls_flag = 'New' then
		dw_body.SetItemStatus(1, 0, Primary!, New!)
	end if
//	ls_sect_nm = dw_body.getitemstring(1,"sect_nm")
//	if isnull(ls_sect_nm) or ls_sect_nm = '' then
//		select max(sect_nm) 
//			into :ls_sect_nm
//			from tb_91105_d (nolock) 
//			where  cust_cd = dbo.SF_GetMake_Cust(:is_style + :is_chno);
//		dw_body.setitem(1,"sect_nm", ls_sect_nm)
//	end if

end if

idw_color1.Retrieve(is_style,is_chno)
IF il_rows = 0 THEN
	dw_body.Reset()
	dw_body.Insertrow(0)		
END IF
ls_country_nm = dw_body.getitemstring(1,"country_cd")
ls_cust_nm = dw_body.getitemstring(1,"cust_nm")
if upper(ls_country_nm) <> 'KOREA' then 
	dw_body.object.t_importer.text = "수입자:" + ls_cust_nm
else
	dw_body.object.t_importer.text = "' '"
end if
This.GetChild("sect_nm", idw_sect_nm)
idw_sect_nm.SetTransObject(SQLCA)
idw_sect_nm.retrieve(ls_country_nm)
idw_sect_nm.InsertRow(0)

if upper(ls_sojae) = 'X' then 
	dw_9.Retrieve(is_style,is_chno,is_color)
	dw_9.visible = true
end if	
			
dw_body.Setitem(1, "style", is_style)
dw_body.Setitem(1, "chno" , is_chno)
dw_body.Setitem(1, "color", is_color)




Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
ls_remark1 = dw_body.getitemstring(1,"remark1")
if ls_remark1 = "' '" and MidA(is_style,2,1) = "J" then	dw_body.setitem(1,"remark1","*단독세탁하시오.")

ls_mat_nm1 = dw_body.getitemstring(1,"mat_nm1")
if ls_mat_nm1 = "' '" then	wf_mat_rate_copy(is_style,is_chno,is_color)	

end event

type dw_body from w_com030_e`dw_body within w_21098_e_old
integer x = 1403
integer width = 2194
string dataobject = "d_21098_d01"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = false
end type

event dw_body::constructor;call super::constructor;
datawindowchild ldw_child

this.getchild("COLOR",idw_color1)
idw_color1.settransobject(sqlca)
idw_color1.InsertRow(1)

this.getchild("mat_gubn1",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn2",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn3",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn4",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')


this.getchild("mat_gubn5",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn6",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn7",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn8",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_nm1",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm2",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm3",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm4",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm5",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm6",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm7",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm8",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')



this.getchild("care_code",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("washing_type",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("fabric_by",idw_fabric_by)
idw_fabric_by.settransobject(sqlca)
idw_fabric_by.retrieve('214')

This.GetChild("sect_nm", idw_sect_nm)
idw_sect_nm.SetTransObject(SQLCA)
idw_sect_nm.retrieve('%')
idw_sect_nm.InsertRow(0)

this.getchild("country_cd",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('214')

this.getchild("care_lable",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('216')

end event

event dw_body::buttonclicked;call super::buttonclicked;long  ll_body_rows, ll_detail_rows
string ls_mat_nm1, ls_remark1, ls_country_nm, ls_sect_nm, ls_flag
string ls_mat_cd, ls_mat_color
datawindowchild ldw_child
CHOOSE CASE dwo.name
	case "cb_label_print"  //발행가능내역
		il_rows = dw_7.retrieve(is_style, is_chno)
		dw_7.visible = true
	case "cb_sojae"  //원단 혼용율내역
		il_rows = dw_6.retrieve(is_style, is_chno)
		dw_6.visible = true
	case "cb_label"  //대화라벨발행내역
		il_rows = dw_5.retrieve(is_style, is_chno)
		dw_5.visible = true
	case "cb_care_chn" //중국어라벨
		if dw_body.dataobject = "d_21098_d01"  then //겉감
			il_rows = dw_4.retrieve(is_style, is_chno,'out')
			dw_4.title = "중국어 케어라벨 - 겉감"
		else
			il_rows = dw_4.retrieve(is_style, is_chno,'in')		
			dw_4.title = "중국어 케어라벨 - 속감"
		end if
		dw_4.visible = true
		
//	CASE "cb_washing" 
//		  	dw_1.retrieve()
//			dw_1.visible  =true
			
	case "cb_katri"	//카트리 시험분석결과
			ls_mat_cd = dw_list.getitemstring(dw_list.getrow(),"mat_cd")
			ls_mat_color = MidA(ls_mat_cd,12,2)
			ls_mat_cd = LeftA(ls_mat_cd,10) 
			il_rows = dw_3.retrieve(ls_mat_cd, ls_mat_color)
//			if il_rows > 0 then
				dw_3.visible = true
//			end if
	CASE "cb_mat_gubn" 
		  	OpenWithParm (W_21093_E1, "W_21093_E1 섬유의 조성") 
			
   CASE "cb_mat_info"
			wf_mat_rate_copy(is_style, is_chno, is_color)
			
   CASE "cb_in"
		IF ib_changed THEN 
			CHOOSE CASE gf_update_yn(Parent.title)
				CASE 1
					IF Parent.Trigger Event ue_update() < 1 THEN
						RETURN 1
					END IF		
				CASE 3
					RETURN 1
			END CHOOSE
		END IF
		
		dw_body.dataobject = "d_21098_d02"  //속감등록
		dw_body.SetTransObject(SQLCA)

	this.object.cb_mat_info.visible = false
	this.getchild("COLOR",idw_color1)
	idw_color1.settransobject(sqlca)
	idw_color1.InsertRow(1)
	
	this.getchild("mat_gubn1",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('212')
	
	this.getchild("mat_gubn2",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('212')
	
	this.getchild("mat_gubn3",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('212')
	
	this.getchild("mat_gubn4",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('212')
	
	
	this.getchild("mat_gubn5",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('212')
	
	this.getchild("mat_gubn6",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('212')
	
	this.getchild("mat_gubn7",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('212')
	
	this.getchild("mat_gubn8",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('212')
	
	this.getchild("mat_nm1",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('213')
	
	this.getchild("mat_nm2",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('213')
	
	this.getchild("mat_nm3",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('213')
	
	this.getchild("mat_nm4",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('213')
	
	this.getchild("mat_nm5",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('213')
	
	this.getchild("mat_nm6",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('213')
	
	this.getchild("mat_nm7",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('213')
	
	this.getchild("mat_nm8",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('213')
	
	this.getchild("country_cd",idw_country_cd)
	idw_country_cd.settransobject(sqlca)
	idw_country_cd.retrieve('214')
	
	this.getchild("care_code",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve()
	
	this.getchild("washing_type",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve()
	
	this.getchild("fabric_by",idw_fabric_by)
	idw_fabric_by.settransobject(sqlca)
	idw_fabric_by.retrieve('214')
	
	This.GetChild("sect_nm", idw_sect_nm)
	idw_sect_nm.SetTransObject(SQLCA)
	idw_sect_nm.retrieve('%')
	idw_sect_nm.InsertRow(0)

								
								is_style = dw_list.GetItemString(dw_list.getrow(), 'style') /* DataWindow에 Key 항목을 가져온다 */
								is_chno  = dw_list.GetItemString(dw_list.getrow(), 'chno') /* DataWindow에 Key 항목을 가져온다 */
								is_color = dw_list.GetItemString(dw_list.getrow(), 'color') /* DataWindow에 Key 항목을 가져온다 */
								
								
								IF IsNull(is_style) or IsNull(is_chno)  or IsNull(is_color)  THEN return
								
								il_rows = dw_body.retrieve(is_style, is_chno,is_color)
								if il_rows > 0 then
//									ls_sect_nm = dw_body.getitemstring(1,"sect_nm")
//									if isnull(ls_sect_nm) or ls_sect_nm = '' then
//										select max(sect_nm) 
//											into :ls_sect_nm
//											from tb_91105_d (nolock) 
//											where  cust_cd = dbo.SF_GetMake_Cust(:is_style + :is_chno);
//										dw_body.setitem(1,"sect_nm", ls_sect_nm)
//									end if
									ls_flag = dw_body.getitemstring(1,"flag")
									if ls_flag = 'New' then
										dw_body.SetItemStatus(1, 0, Primary!, New!)
									end if
	
								end if
								
								idw_color1.Retrieve(is_style,is_chno)
								IF il_rows = 0 THEN
									dw_body.Reset()
									dw_body.Insertrow(0)		
								END IF
								ls_country_nm = dw_body.getitemstring(1,"country_cd")
								This.GetChild("sect_nm", idw_sect_nm)
								idw_sect_nm.SetTransObject(SQLCA)
								idw_sect_nm.retrieve(ls_country_nm)
								idw_sect_nm.InsertRow(0)
								
											
								dw_body.Setitem(1, "style", is_style)
								dw_body.Setitem(1, "chno" , is_chno)
								dw_body.Setitem(1, "color", is_color)
								
								
								
								
								Parent.Trigger Event ue_button(7, il_rows)
								Parent.Trigger Event ue_msg(1, il_rows)
//								ls_remark1 = dw_body.getitemstring(1,"remark1")
//								if ls_remark1 = "' '" and mid(is_style,2,1) = "J" then	dw_body.setitem(1,"remark1","*단독세탁하시오.")
//								
//								ls_mat_nm1 = dw_body.getitemstring(1,"mat_nm1")
//								if ls_mat_nm1 = "' '" then	wf_mat_rate_copy(is_style,is_chno,is_color)	

   CASE "cb_out"		
		IF ib_changed THEN 
			CHOOSE CASE gf_update_yn(Parent.title)
				CASE 1
					IF Parent.Trigger Event ue_update() < 1 THEN
						RETURN 1
					END IF		
				CASE 3
					RETURN 1
			END CHOOSE
		END IF		

		dw_body.dataobject = "d_21098_d01"  //겉감등록		 
		dw_body.SetTransObject(SQLCA)
							
this.object.cb_mat_info.visible = true
this.getchild("COLOR",idw_color1)
idw_color1.settransobject(sqlca)
idw_color1.InsertRow(1)

this.getchild("mat_gubn1",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn2",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn3",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn4",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')


this.getchild("mat_gubn5",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn6",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn7",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_gubn8",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')

this.getchild("mat_nm1",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm2",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm3",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm4",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm5",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm6",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm7",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm8",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("country_cd",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('214')

this.getchild("care_code",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("washing_type",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("fabric_by",idw_fabric_by)
idw_fabric_by.settransobject(sqlca)
idw_fabric_by.retrieve('214')

This.GetChild("sect_nm", idw_sect_nm)
idw_sect_nm.SetTransObject(SQLCA)
idw_sect_nm.retrieve('%')
idw_sect_nm.InsertRow(0)
								
this.getchild("care_lable",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('216')

								
								is_style = dw_list.GetItemString(dw_list.getrow(), 'style') /* DataWindow에 Key 항목을 가져온다 */
								is_chno  = dw_list.GetItemString(dw_list.getrow(), 'chno') /* DataWindow에 Key 항목을 가져온다 */
								is_color = dw_list.GetItemString(dw_list.getrow(), 'color') /* DataWindow에 Key 항목을 가져온다 */
								
								
								IF IsNull(is_style) or IsNull(is_chno)  or IsNull(is_color)  THEN return
								
								il_rows = dw_body.retrieve(is_style, is_chno,is_color)
								if il_rows > 0 then
//									ls_sect_nm = dw_body.getitemstring(1,"sect_nm")
//									if isnull(ls_sect_nm) or ls_sect_nm = '' then
//										select max(sect_nm) 
//											into :ls_sect_nm
//											from tb_91105_d (nolock) 
//											where  cust_cd = dbo.SF_GetMake_Cust(:is_style + :is_chno);
//										dw_body.setitem(1,"sect_nm", ls_sect_nm)
//									end if
									ls_flag = dw_body.getitemstring(1,"flag")
									if ls_flag = 'New' then
										dw_body.SetItemStatus(1, 0, Primary!, Newmodified!)
									end if									
								end if
								
								idw_color1.Retrieve(is_style,is_chno)
								IF il_rows = 0 THEN
									dw_body.Reset()
									dw_body.Insertrow(0)		
								END IF
								ls_country_nm = dw_body.getitemstring(1,"country_cd")
								This.GetChild("sect_nm", idw_sect_nm)
								idw_sect_nm.SetTransObject(SQLCA)
								idw_sect_nm.retrieve(ls_country_nm)
								idw_sect_nm.InsertRow(0)
								
											
								dw_body.Setitem(1, "style", is_style)
								dw_body.Setitem(1, "chno" , is_chno)
								dw_body.Setitem(1, "color", is_color)
								
								
								
								
								Parent.Trigger Event ue_button(7, il_rows)
								Parent.Trigger Event ue_msg(1, il_rows)
//								ls_remark1 = dw_body.getitemstring(1,"remark1")
//								if ls_remark1 = "' '" and mid(is_style,2,1) = "J" then	dw_body.setitem(1,"remark1","*단독세탁하시오.")
//								
//								ls_mat_nm1 = dw_body.getitemstring(1,"mat_nm1")
//								if ls_mat_nm1 = "' '" then	wf_mat_rate_copy(is_style,is_chno,is_color)	
//
END CHOOSE




end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
string  ls_care_code, ls_remark1, ls_remark2, ls_remark3, ls_remark4, ls_remark5, ls_washing_type
string  ls_washing1, ls_washing2, ls_washing3, ls_washing4, ls_washing5, ls_washing6
string  ls_pic1, ls_pic2, ls_pic3, ls_pic4, ls_pic5, ls_pic6


ib_changed = true
cb_update.enabled = true

dw_body.AcceptText()

CHOOSE CASE dwo.name
	CASE "reprint" 
			DECLARE sp_reprint PROCEDURE FOR sp_reprint
					@style = :is_style,
					@chno  = :is_chno,
					@flag  = '1';
					
			execute sp_reprint;				
			commit  USING SQLCA;	
			this.setfocus()
			this.setcolumn("style")
	CASE "care_code" 
		  ls_care_code = data 
		 
   	  select  remark1, remark2, remark3, remark4, remark5
		  into    :ls_remark1, :ls_remark2, :ls_remark3, :ls_remark4, :ls_remark5
		  from tb_care_label
		  where care_code = :ls_care_code;  
		  		  
		  dw_body.Setitem(1, "remark1", ls_remark1) 
		  dw_body.Setitem(1, "remark2", ls_remark2) 
		  dw_body.Setitem(1, "remark3", ls_remark3) 
		  dw_body.Setitem(1, "remark4", ls_remark4) 
		  dw_body.Setitem(1, "remark5", ls_remark5) 
		  

	  CASE "washing_type"
		  ls_washing_type = string(data)
		  select  washing1, washing2, washing3, washing4, washing5, washing6
		  into    :is_washing1,  :is_washing2,  :is_washing3,  :is_washing4,  :is_washing5,  :is_washing6
		  from tb_washing_type (nolock)
		  where washing_type = :ls_washing_type;  

		  dw_body.Setitem(1, "washing1", is_washing1) 
		  dw_body.Setitem(1, "washing2", is_washing2) 
		  dw_body.Setitem(1, "washing3", is_washing3) 
		  dw_body.Setitem(1, "washing4", is_washing4)
		  dw_body.Setitem(1, "washing5", is_washing5) 
		  dw_body.Setitem(1, "washing6", is_washing6)

//messagebox("is_washing6",is_washing6)
//  	  	  ls_pic6 =  is_washing6 + '.bmp'
//		  dw_body.Setitem(1, "pic6", ls_pic6)
		  
		  
		  ls_pic1 =  is_washing1 + '.bmp'
		  dw_body.Setitem(1, "pic1", ls_pic1)

		  ls_pic2 =  is_washing2 + '.bmp'
		  dw_body.Setitem(1, "pic2", ls_pic2)

		  ls_pic3 =  is_washing3 + '.bmp'
		  dw_body.Setitem(1, "pic3", ls_pic3)

		  ls_pic4 =  is_washing4 + '.bmp'
		  dw_body.Setitem(1, "pic4", ls_pic4)

		  ls_pic5 =  is_washing5 + '.bmp'
		  dw_body.Setitem(1, "pic5", ls_pic5)

		  ls_pic6 =  is_washing6 + '.bmp'		 
		  dw_body.Setitem(1, "pic6", ls_pic6)


END CHOOSE



end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;///*===========================================================================*/
///* 작성자      : (주) 지우정보 (김 태범)                                     */	
///* 작성일      : 1999.11.09                                                  */	
///* 수정일      : 1999.11.09                                                  */
///*===========================================================================*/
//String ls_column_nm,  ls_tag, ls_helpMsg
//
//ls_column_nm = This.GetColumnName()
//
//ls_tag = This.Describe(ls_column_nm + ".Tag")
//
//gf_kor_eng(Handle(Parent), ls_tag, 1)
//
//This.SelectText(1, 3000)
//
//CHOOSE CASE ls_column_nm
//	CASE "sect_nm" 
//		idw_sect_nm.reset()
//		idw_sect_nm.Retrieve(This.Object.country_cd[row])
//END CHOOSE 
end event

type st_1 from w_com030_e`st_1 within w_21098_e_old
integer x = 1381
end type

type dw_print from w_com030_e`dw_print within w_21098_e_old
integer x = 1317
integer y = 616
end type

type dw_2 from datawindow within w_21098_e_old
boolean visible = false
integer x = 2738
integer y = 624
integer width = 411
integer height = 432
integer taborder = 50
string title = "none"
string dataobject = "d_21093_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_copy_ord from datawindow within w_21098_e_old
boolean visible = false
integer x = 1833
integer y = 92
integer width = 1481
integer height = 412
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "케어라벨 복사!"
string dataobject = "d_21093_d07"
boolean controlmenu = true
boolean resizable = true
boolean livescroll = true
end type

event buttonclicked;string ls_fr_style, ls_fr_chno, ls_to_style, ls_to_chno, ls_color


choose case dwo.name
	case "cb_copy_ord"
			IF dw_copy_ord.AcceptText() <> 1 THEN RETURN -1
			
			ls_fr_style = dw_copy_ord.getitemstring(1,"fr_style")
			ls_fr_chno  = dw_copy_ord.getitemstring(1,"fr_chno")
			ls_to_style = dw_copy_ord.getitemstring(1,"to_style")
			ls_to_chno  = dw_copy_ord.getitemstring(1,"to_chno")
			ls_color    = dw_body.getitemstring(1,"color")									
			
			if LenA(ls_fr_style) < 8 or LenA(ls_to_style) < 8 then 
				 messagebox("확인","스타일번호를 다시 확인 하세요...")
				return -1
			end if

			if LenA(ls_fr_chno) < 1 or LenA(ls_to_chno) < 1 then 
				 messagebox("확인","차수번호를 다시 확인 하세요...")
				return -1
			end if


			if isnull(ls_color) or LenA(ls_color) < 2 then 
				 messagebox("확인","스타일번호를 다시 확인 하세요...")
				return -1
			end if
			
			
			if messagebox("확인","실행하시겠습니다...?",Exclamation!,YesNoCancel!,1 ) <> 1 then return			
			
			DECLARE sp_21093_d07 PROCEDURE FOR sp_21093_d07  
					@fr_style      = :ls_fr_style,
					@fr_chno			= :ls_fr_chno,
					@fr_color		= :ls_color,
					@to_style		= :ls_to_style,
					@to_chno		   = :ls_to_chno;
						
			execute sp_21093_d07;		
			 
			commit  USING SQLCA;
			messagebox("확인","정상처리되었슴니다...")
			dw_copy_ord.visible = false
			dw_copy_ord.reset()
			 
end choose

end event

type dw_1 from datawindow within w_21098_e_old
boolean visible = false
integer x = 160
integer y = 116
integer width = 1198
integer height = 324
integer taborder = 40
boolean titlebar = true
string title = "세탁표시방법"
string dataobject = "d_21093_d03"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string   ls_inter_cd , ls_washing_pic , ls_p_no1, ls_p_no2, ls_p_no3, ls_p_no4
string   ls_washing1, ls_washing2, ls_washing3, ls_washing4

choose case dwo.name	
	case "p_1"
		   is_p_no1 = "P_1"
			is_p_no2 = ""
			is_p_no3 = ""
			is_p_no4 = ""
			ls_inter_cd =''
			this.object.p_1.border = 6
			this.object.p_2.border = 2
			this.object.p_3.border = 2
			this.object.p_4.border = 2

	case "p_2"
			is_p_no2 = "P_2"
			is_p_no1 = ""
			is_p_no3 = ""
			is_p_no4 = ""
			ls_inter_cd =''
			this.object.p_2.border = 6
			this.object.p_1.border = 2
			this.object.p_3.border = 2
			this.object.p_4.border = 2
			
	case "p_3"
			is_p_no3 = "P_3"
			is_p_no2 = ""
			is_p_no1 = ""
			is_p_no4 = ""
			ls_inter_cd =''
			this.object.p_3.border = 6		
			this.object.p_2.border = 2
			this.object.p_1.border = 2
			this.object.p_4.border = 2

	case "p_4"	
			is_p_no4 = "P_4"
			is_p_no2 = ""
			is_p_no3 = ""
			is_p_no1 = ""
			ls_inter_cd =''
			this.object.p_4.border = 6		
			this.object.p_2.border = 2
			this.object.p_3.border = 2
			this.object.p_1.border = 2
			
	case	"cb_confirm"
		   is_p_no4 = ""
			is_p_no2 = ""
			is_p_no3 = ""
			is_p_no1 = ""
			ls_inter_cd =''
			dw_1.visible  =false
			dw_1.reset()
			ib_changed = true
			cb_update.enabled = true		
		
	case  else
			ls_inter_cd = this.getitemstring(row,"inter_cd")
			ls_washing_pic = this.getitemstring(row,"washing_pic")					

end choose
			
	//		messagebox('ls_inter_cd', ls_inter_cd)
			
			if is_p_no1     = "P_1" then	
			    	 
					 this.object.p_1.filename = ls_washing_pic	
			   	 dw_body.Setitem(1, "pic1", ls_washing_pic)
					 dw_body.Setitem(1, "washing1", ls_inter_cd)
					 is_washing1 = ls_inter_cd
				if  (ls_inter_cd <> is_washing2)  and (ls_inter_cd <> is_washing3) and (ls_inter_cd <> is_washing4)   then  	
					
				elseif ls_inter_cd <> '' then  
						messagebox('확인', "동일한 세탁표시를 선택했습니다 !")
						this.object.p_1.filename = ''
						dw_body.Setitem(1, "pic1", '')
					   dw_body.Setitem(1, "washing1", '')
						return 1
				end if  
				
			elseif is_p_no2 = "P_2" then
				    this.object.p_2.filename = ls_washing_pic
				    dw_body.Setitem(1, "pic2", ls_washing_pic)
					 dw_body.Setitem(1, "washing2", ls_inter_cd)
					 is_washing2 = ls_inter_cd
				if  (ls_inter_cd <> is_washing1)  and (ls_inter_cd <> is_washing3) and (ls_inter_cd <> is_washing4)  then   
					 
			   elseif  ls_inter_cd <> '' then  
					 	messagebox('확인', "동일한 세탁표시를 선택했습니다 !")
						this.object.p_2.filename = ''
						dw_body.Setitem(1, "pic2", '')
					   dw_body.Setitem(1, "washing2", '')
						return 1
				end if  
				
			
			elseif is_p_no3 = "P_3" then		
				    this.object.p_3.filename = ls_washing_pic
				    dw_body.Setitem(1, "pic3", ls_washing_pic)
					 dw_body.Setitem(1, "washing3", ls_inter_cd)
					 is_washing3 = ls_inter_cd
				if  (ls_inter_cd <> is_washing1)  and (ls_inter_cd <> is_washing2) and (ls_inter_cd <> is_washing4)  then   
					 
				elseif ls_inter_cd <> '' then  
					 	 messagebox('확인', "동일한 세탁표시를 선택했습니다 !")
						 this.object.p_3.filename = ''
						 dw_body.Setitem(1, "pic3", '')
						 dw_body.Setitem(1, "washing3", '')
						return 1
				end if  
			
			
			elseif is_p_no4 = "P_4" then		
				    this.object.p_4.filename = ls_washing_pic
				    dw_body.Setitem(1, "pic4", ls_washing_pic)
					 dw_body.Setitem(1, "washing4", ls_inter_cd)
					  is_washing4 = ls_inter_cd
				if  (ls_inter_cd <> is_washing1)  and (ls_inter_cd <> is_washing2) and (ls_inter_cd <> is_washing3)  then   
				elseif  ls_inter_cd <> '' then  
					 	messagebox('확인', "동일한 세탁표시를 선택했습니다 !")
						this.object.p_4.filename = ''
				      dw_body.Setitem(1, "pic4", '')
					   dw_body.Setitem(1, "washing4", '')
						return 1
				end if  
			end if




end event

type dw_3 from datawindow within w_21098_e_old
boolean visible = false
integer x = 352
integer y = 24
integer width = 1792
integer height = 2976
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "시험분석 결과"
string dataobject = "d_21015_d04"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;
datawindowchild ldw_child

this.getchild("mat_nm1",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm2",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm3",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm4",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm5",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm5",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

this.getchild("mat_nm6",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

end event

type dw_4 from datawindow within w_21098_e_old
boolean visible = false
integer x = 1335
integer y = 372
integer width = 1906
integer height = 1428
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "중국어 케어라벨"
string dataobject = "d_21098_d04"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_5 from datawindow within w_21098_e_old
boolean visible = false
integer x = 1920
integer y = 416
integer width = 1193
integer height = 1060
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "대화라벨발행내역"
string dataobject = "d_21098_d05"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_9 from datawindow within w_21098_e_old
boolean visible = false
integer x = 832
integer y = 260
integer width = 2565
integer height = 972
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "신체치수표기"
string dataobject = "d_21098_d09"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long ll_cur_row
datetime ld_datetime

IF dw_9.AcceptText() <> 1 THEN RETURN -1


il_rows = dw_9.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_9.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

dw_9.Retrieve(is_style,is_chno,is_color)


end event

type dw_6 from datawindow within w_21098_e_old
boolean visible = false
integer x = 288
integer y = 340
integer width = 2953
integer height = 2100
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "소재팀에서 등록한 혼용율 내역입니다.."
string dataobject = "d_21098_d06"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_7 from datawindow within w_21098_e_old
boolean visible = false
integer x = 119
integer y = 668
integer width = 3383
integer height = 836
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "조회된 스타일은 라벨 발행을 할 수 있습니다.."
string dataobject = "d_21098_d07"
boolean controlmenu = true
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

