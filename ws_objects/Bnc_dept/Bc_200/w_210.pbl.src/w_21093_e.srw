$PBExportHeader$w_21093_e.srw
$PBExportComments$케어라벨입력_구
forward
global type w_21093_e from w_com030_e
end type
type dw_1 from datawindow within w_21093_e
end type
type dw_2 from datawindow within w_21093_e
end type
type dw_copy_ord from datawindow within w_21093_e
end type
end forward

global type w_21093_e from w_com030_e
integer width = 4046
integer height = 2228
dw_1 dw_1
dw_2 dw_2
dw_copy_ord dw_copy_ord
end type
global w_21093_e w_21093_e

type variables
string  is_style_no, is_style, is_chno, is_color, is_p_no1, is_p_no2, is_p_no3, is_p_no4  , is_washing1, is_washing2, is_washing3, is_washing4, is_washing5, is_washing6
string  is_brand, is_year, is_season, is_sojae, is_item, is_country_cd, is_reg_dt
//string  as_mat_nm1, as_mat_rate1, as_mat_nm2,as_mat_rate2, as_mat_nm3,as_mat_rate3, as_mat_nm4, as_mat_rate4, as_mat_nm5, as_mat_rate5  
datawindowchild idw_color, idw_color1, idw_brand, idw_season, idw_sojae, idw_item, idw_fabric_by, idw_sect_nm
end variables

forward prototypes
public subroutine wf_mat_rate_copy (string as_style, string as_chno, string as_color)
public function boolean wf_chk_remark (string as_maker_fg)
end prototypes

public subroutine wf_mat_rate_copy (string as_style, string as_chno, string as_color);string  as_mat_nm1, as_mat_rate1, as_mat_nm2,as_mat_rate2, as_mat_nm3,as_mat_rate3, as_mat_nm4, as_mat_rate4, as_mat_nm5, as_mat_rate5  
string  ls_mat_nm1, ls_mat_rate1, ls_mat_nm2,ls_mat_rate2, ls_mat_nm3,ls_mat_rate3, ls_mat_nm4, ls_mat_rate4, ls_mat_nm5, ls_mat_rate5  	
string  ls_country_cd

	 select case country_cd when '00' then 'KOREA' when '02' then 'JAPAN' 
	 					when '06' then 'CHINA' when '08' then 'ITALY' else 'KOREA' end 
	 	 		into :ls_country_cd  
	 FROM 	tb_12021_d  WITH (NOLOCK)
	 WHERE  STYLE  = :AS_STYLE
	 AND	  CHNO   = :AS_CHNO;
	 
dw_body.setitem(1,"country_cd",ls_country_cd)

	 
	 

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
	 AND    A.COLOR  = B.COLOR;
	 
	 
	 as_mat_nm1 = dw_body.GetitemString(1,"mat_nm1")
	 as_mat_nm2 = dw_body.GetitemString(1,"mat_nm2")
	 as_mat_nm3 = dw_body.GetitemString(1,"mat_nm3")
	 as_mat_nm4 = dw_body.GetitemString(1,"mat_nm4")
	 as_mat_nm5 = dw_body.GetitemString(1,"mat_nm5")
		   
	 
	if ls_mat_nm1 <> "' '"   then 
	 	if ls_mat_nm1 <> as_mat_nm1 then
			dw_body.Setitem(1,"mat_gubn1","겉  감")
			dw_body.Setitem(1,"mat_nm1",ls_mat_nm1)
			dw_body.Setitem(1,"mat_rate1",ls_mat_rate1)
			cb_update.enabled = true
			dw_body.AcceptText()
		end if
	end if
	
	if ls_mat_nm2 <>  "' '"  then 
	 	if ls_mat_nm2 <> as_mat_nm2 then
			dw_body.Setitem(1,"mat_nm2",ls_mat_nm2)
			dw_body.Setitem(1,"mat_rate2",ls_mat_rate2)
			cb_update.enabled = true
			dw_body.AcceptText()
		end if
	end if
	
	
	
	if ls_mat_nm3 <>  "' '"   then 
	 	if ls_mat_nm3 <> as_mat_nm3 then
			dw_body.Setitem(1,"mat_nm3",ls_mat_nm3)
			dw_body.Setitem(1,"mat_rate3",ls_mat_rate3)
			cb_update.enabled = true
			dw_body.AcceptText()
		end if
	end if
	
	if ls_mat_nm4 <>  "' '"  then 
		if ls_mat_nm4 <> as_mat_nm4 then
			dw_body.Setitem(1,"mat_nm4",ls_mat_nm4)
			dw_body.Setitem(1,"mat_rate4",ls_mat_rate4)
			cb_update.enabled = true
			dw_body.AcceptText()
		end if
	end if
	
	if ls_mat_nm5 <>  "' '"  then 
	 	if ls_mat_nm5 <> as_mat_nm5 then
			dw_body.Setitem(1,"mat_nm5",ls_mat_nm5)
			dw_body.Setitem(1,"mat_rate5",ls_mat_rate5)
			cb_update.enabled = true
			dw_body.AcceptText()
		end if
	end if
	

 
	 
	
end subroutine

public function boolean wf_chk_remark (string as_maker_fg);string ls_remark_1, ls_remark_2, ls_remark_3, ls_remark_4, ls_remark_5
int ll_found

//messagebox("as_maker_fg",as_maker_fg)
if as_maker_fg = '2'  then //판매원, 수입/판매원
	ll_found = dw_body.Find("remark1 like '%수입원%'", 1, 1)
	if ll_found > 0 then return false
	
	ll_found = dw_body.Find("remark2 like '%수입원%'", 1, 1)
	if ll_found > 0 then return false
	
	ll_found = dw_body.Find("remark3 like '%수입원%'", 1, 1)
	if ll_found > 0 then return false
	
	ll_found = dw_body.Find("remark4 like '%수입원%'", 1, 1)
	if ll_found > 0 then return false
	
	ll_found = dw_body.Find("remark5 like '%수입원%'", 1, 1)
	if ll_found > 0 then return false
elseif as_maker_fg = '1'  then
	ll_found = dw_body.Find("remark1 like '%수입원%'", 1, 1)
	if ll_found > 0 then return true
	
	ll_found = dw_body.Find("remark2 like '%수입원%'", 1, 1)
	if ll_found > 0 then return true
	
	ll_found = dw_body.Find("remark3 like '%수입원%'", 1, 1)
	if ll_found > 0 then return true
	
	ll_found = dw_body.Find("remark4 like '%수입원%'", 1, 1)
	if ll_found > 0 then return true
	
	ll_found = dw_body.Find("remark5 like '%수입원%'", 1, 1)
	if ll_found > 0 then return true	
	return false
else
	return false
end if

return true

		


end function

on w_21093_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_copy_ord=create dw_copy_ord
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_copy_ord
end on

on w_21093_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_copy_ord)
end on

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)


end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
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

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                               */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

is_style =  LeftA(is_style_no,8)
il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_style, is_country_cd, is_reg_dt)
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
long i, ll_row_count
int li_chk
datetime ld_datetime
string ls_chk, ls_qute, ls_maker_fg

ls_qute = "'"

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

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
	select  	
		((convert(int,replace(MAT_RATE1,:ls_qute,'')) +
		convert(int,replace(MAT_RATE2,:ls_qute,'')) +
		convert(int,replace(MAT_RATE3,:ls_qute,'')) + 
		convert(int,replace(MAT_RATE4,:ls_qute,'')) + 
		convert(int,replace(MAT_RATE5,:ls_qute,'')) + 
		convert(int,replace(MAT_RATE6,:ls_qute,'')) + 
		convert(int,replace(MAT_RATE7,:ls_qute,'')) + 
		convert(int,replace(MAT_RATE8,:ls_qute,''))  ) % 100) into :li_chk
	from TB_12029_D (nolock) 
	where style = :is_style
	and   chno  = :is_chno
	and   color = :is_color;
	
	if li_chk = 0 then    
		dw_body.ResetUpdate()	
		commit  USING SQLCA;
	else
		messagebox("확인","섬유조성이 100%가 아니네요.. 올바로 입력하세요..")
	   rollback  USING SQLCA;	
		dw_body.setfocus()
	end if
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_21093_e","0")
end event

type cb_close from w_com030_e`cb_close within w_21093_e
end type

type cb_delete from w_com030_e`cb_delete within w_21093_e
boolean visible = false
end type

type cb_insert from w_com030_e`cb_insert within w_21093_e
string text = "복사"
end type

event cb_insert::clicked;call super::clicked; DECLARE sp_21093_d02 PROCEDURE FOR sp_21093_d02  
  @ps_style = :is_style,
  @ps_chno  = :is_chno,
  @ps_color = :is_color;

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

type cb_retrieve from w_com030_e`cb_retrieve within w_21093_e
end type

type cb_update from w_com030_e`cb_update within w_21093_e
end type

type cb_print from w_com030_e`cb_print within w_21093_e
boolean visible = false
end type

type cb_preview from w_com030_e`cb_preview within w_21093_e
boolean visible = false
end type

type gb_button from w_com030_e`gb_button within w_21093_e
integer x = 5
end type

type cb_excel from w_com030_e`cb_excel within w_21093_e
integer width = 439
string text = "케어라벨 복사!"
end type

event cb_excel::clicked;dw_copy_ord.insertrow(0)
dw_copy_ord.setitem(1,"fr_style", is_style)
dw_copy_ord.setitem(1,"fr_chno", is_chno)
dw_copy_ord.visible = true
dw_copy_ord.setcolumn("to_style")
end event

type dw_head from w_com030_e`dw_head within w_21093_e
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

type ln_1 from w_com030_e`ln_1 within w_21093_e
end type

type ln_2 from w_com030_e`ln_2 within w_21093_e
end type

type dw_list from w_com030_e`dw_list within w_21093_e
integer x = 9
integer width = 987
string dataobject = "d_21093_d06"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long  ll_body_rows, ll_detail_rows
string ls_mat_nm1
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


IF IsNull(is_style) or IsNull(is_chno)  or IsNull(is_color)  THEN return

il_rows = dw_body.retrieve(is_style, is_chno,is_color)


idw_color1.Retrieve(is_style,is_chno)

IF il_rows = 0 THEN
	dw_body.Reset()
	dw_body.Insertrow(0)		
END IF

dw_body.Setitem(1, "style", is_style)
dw_body.Setitem(1, "chno", is_chno)
dw_body.Setitem(1, "color", is_color)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

ls_mat_nm1 = dw_body.getitemstring(1,"mat_nm1")
if ls_mat_nm1 = "' '" then	wf_mat_rate_copy(is_style,is_chno,is_color)	

end event

type dw_body from w_com030_e`dw_body within w_21093_e
integer x = 1029
integer width = 2560
string dataobject = "d_21093_d01"
boolean maxbox = true
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

this.getchild("country_cd",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('214')

this.getchild("care_code",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()

this.getchild("washing_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()


this.getchild("fabric_by",idw_fabric_by)
idw_fabric_by.settransobject(sqlca)
idw_fabric_by.retrieve('214')

This.GetChild("sect_cm", idw_sect_nm)
idw_sect_nm.SetTransObject(SQLCA)
idw_sect_nm.insertRow(0)


end event

event dw_body::buttonclicked;call super::buttonclicked;CHOOSE CASE dwo.name
	CASE "cb_washing" 
		  	dw_1.retrieve()
			dw_1.visible  =true
			
	CASE "cb_mat_gubn" 
		  	OpenWithParm (W_21093_E1, "W_21093_E1 섬유의 조성") 
			
   CASE "cb_mat_info"
			wf_mat_rate_copy(is_style,is_chno,is_color)
		
		 
		    
END CHOOSE




end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
string  ls_care_code, ls_remark1, ls_remark2, ls_remark3, ls_remark4, ls_remark5, ls_washing_gubn
string  ls_washing1, ls_washing2, ls_washing3, ls_washing4, ls_washing5, ls_washing6
string  ls_pic1, ls_pic2, ls_pic3, ls_pic4, ls_pic5, ls_pic6


ib_changed = true
cb_update.enabled = true

dw_body.AcceptText()
CHOOSE CASE dwo.name
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
		  

	  CASE "washing_gubn" 
		  ls_washing_gubn = data
		  select  washing1, washing2, washing3, washing4, washing5, washing6
		  into    :is_washing1,  :is_washing2,  :is_washing3,  :is_washing4,  :is_washing5,  :is_washing6
		  from tb_care_washing
		  where washing_gubn = :ls_washing_gubn;  
		  		  
		  dw_body.Setitem(1, "washing1", is_washing1) 
		  dw_body.Setitem(1, "washing2", is_washing2) 
		  dw_body.Setitem(1, "washing3", is_washing3) 
		  dw_body.Setitem(1, "washing4", is_washing4)
		  dw_body.Setitem(1, "washing5", is_washing5) 
		  dw_body.Setitem(1, "washing6", is_washing6)
		  
		  ls_pic1 =  is_washing1 + '.bmp'
//		  messagebox("ls_pic1",ls_pic1)
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

event dw_body::itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

CHOOSE CASE ls_column_nm
	CASE "sect_nm" 
		idw_sect_nm.reset()
		idw_sect_nm.Retrieve(This.Object.country_cd[row])
END CHOOSE 
end event

type st_1 from w_com030_e`st_1 within w_21093_e
integer x = 1006
end type

type dw_print from w_com030_e`dw_print within w_21093_e
integer x = 1317
integer y = 616
end type

type dw_1 from datawindow within w_21093_e
boolean visible = false
integer x = 14
integer y = 4
integer width = 3584
integer height = 2040
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

type dw_2 from datawindow within w_21093_e
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

type dw_copy_ord from datawindow within w_21093_e
boolean visible = false
integer x = 709
integer y = 520
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

