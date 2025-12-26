$PBExportHeader$w_21015_e.srw
$PBExportComments$시험성적서입력
forward
global type w_21015_e from w_com030_e
end type
type cb_1 from commandbutton within w_21015_e
end type
type dw_1 from datawindow within w_21015_e
end type
type dw_2 from datawindow within w_21015_e
end type
type dw_3 from datawindow within w_21015_e
end type
end forward

global type w_21015_e from w_com030_e
integer width = 3675
integer height = 2276
windowstate windowstate = maximized!
cb_1 cb_1
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
end type
global w_21015_e w_21015_e

type variables
string  is_brand, is_year, is_season, is_sojae,is_mat_cd,  is_color, is_iud_gbn
datawindowchild  idw_brand, idw_season, idw_sojae, idw_mat_nm, idw_color, idw_make_item, idw_country_cd


end variables

on w_21015_e.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.dw_3
end on

on w_21015_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
end on

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

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif (gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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


is_year = Trim(dw_head.GetItemString(1, "year"))


is_season = Trim(dw_head.GetItemString(1, "season"))


is_sojae = Trim(dw_head.GetItemString(1, "sojae"))


is_mat_cd = Trim(dw_head.GetItemString(1, "mat_cd"))



return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                               */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_sojae, is_mat_cd)
dw_body.Reset()
dw_1.Reset()
dw_2.Reset()
dw_3.Reset()
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
string ls_chk, ls_qute, ls_flag

ls_qute = "'"

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
   ELSEIF idw_status = DataModified! THEN			/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)	
	END IF
NEXT

idw_status = dw_2.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */
	dw_2.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN			/* Modify Record */
	dw_2.Setitem(1, "mod_id", gs_user_id)
	dw_2.Setitem(1, "mod_dt", ld_datetime)	
END IF



il_rows = dw_body.Update(TRUE, FALSE)
if il_rows = 1 then
	select  	
		((convert(int,replace(isnull(MAT_RATE1,0),:ls_qute,'')) +
		convert(int,replace(isnull(MAT_RATE2,0),:ls_qute,'')) +
		convert(int,replace(isnull(MAT_RATE3,0),:ls_qute,'')) + 
		convert(int,replace(isnull(MAT_RATE4,0),:ls_qute,'')) + 
		convert(int,replace(isnull(MAT_RATE5,0),:ls_qute,'')) + 
		convert(int,replace(isnull(MAT_RATE6,0),:ls_qute,'')) + 	
		
		convert(int,replace(isnull(MAT_RATE7,0),:ls_qute,'')) + 	
				
		convert(int,replace(isnull(MAT_RATE8,0),:ls_qute,''))  ) % 100) into :li_chk
	from TB_21015_D (nolock) 
	where mat_cd = :is_mat_cd
	and   color = :is_color;
	
	
	if li_chk = 0 then    
		dw_body.ResetUpdate()	
		il_rows = dw_2.Update(TRUE, FALSE)
		if il_rows = 1 then 
			dw_2.ResetUpdate()
			commit  USING SQLCA;
		end if
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

event open;call super::open;string ls_brand, ls_year, ls_season
if gsv_cd.gs_cd8 <> ''  then
	dw_head.setitem(1,'mat_cd',gsv_cd.gs_cd8)
	select brand, mat_year, mat_season 
		into :ls_brand, :ls_year, :ls_season
	from tb_21010_m (nolock) where mat_cd = :gsv_cd.gs_cd8;
	
	dw_head.setitem(1,'brand',ls_brand)
	dw_head.setitem(1,'year',ls_year)
	dw_head.setitem(1,'season',ls_season)
	this.PostEvent("ue_retrieve")
	setnull(gsv_cd.gs_cd8)
	
end if

end event

event ue_button;
/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
       cb_retrieve.Text = "조건(&Q)"
       dw_head.Enabled = false
       dw_list.Enabled = true
       dw_body.Enabled = true

   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_list.Enabled = true
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
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = false
            cb_update.enabled = false
			end if
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
		
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
		cb_1.visible = false
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

event pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
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

/*===========================================================================*/
/* 작성자      : 지우정보        														  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToBottom")
inv_resize.of_Register(dw_2, "ScaleToBottom")
inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(st_1, "ScaleToBottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)

// 저장권한 제한하기 list_click, ue_head 이벤트에 수정: IF ib_changed  and (isnull(is_iud_gbn) or is_iud_gbn <> '0') THEN 
select iud_gbn into :is_iud_gbn
from TB_93040_H a(nolock) 
where person_id = :gs_user_id
and   pgm_id    = 'W_21015_E';

if is_iud_gbn = '0' then 
	cb_insert.visible = false
	cb_delete.visible = false
	cb_update.visible = false

end if


end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
int li_seq

dw_print.dataobject = "d_kola_r00"
dw_print.SetTransObject(SQLCA)

string ls_null
setnull(ls_null)

dw_print.GetChild("mat_nm1_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


dw_print.GetChild("mat_nm2_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm3_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm4_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm5_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm6_1", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

///////////////
dw_print.GetChild("mat_nm1_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm2_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm3_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm4_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm5_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm6_2", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

///////////////
dw_print.GetChild("mat_nm1_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm2_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm3_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm4_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm5_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm6_3", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


///////////////
dw_print.GetChild("mat_nm1_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm2_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm3_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)


dw_print.GetChild("mat_nm4_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm5_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)

dw_print.GetChild("mat_nm6_4", idw_make_item)
idw_make_item.SetTransObject(SQLCA)
idw_make_item.Retrieve('213')
idw_make_item.insertrow(1)
idw_make_item.setitem(1,'item',ls_null)



This.Trigger Event ue_title ()
li_seq = dw_1.getitemnumber(1,'seq')
il_rows = dw_print.retrieve(is_mat_cd,li_seq )
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_head;//(isnull(is_iud_gbn) or is_iud_gbn <> '0')
/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

/* 변경된 자료가 있을때 저장여부를 확인*/
IF ib_changed and (isnull(is_iud_gbn) or is_iud_gbn <> '0') THEN 
   CHOOSE CASE gf_update_yn(This.title)
	   CASE 1
		   IF This.Trigger Event ue_update() < 1 THEN
			   return
		   END IF		
	   CASE 3
		   return
   END CHOOSE
END IF

This.Trigger Event ue_button(5, 2)
This.Trigger Event ue_msg(5, 2)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_21015_e","0")
end event

type cb_close from w_com030_e`cb_close within w_21015_e
end type

type cb_delete from w_com030_e`cb_delete within w_21015_e
boolean enabled = true
end type

type cb_insert from w_com030_e`cb_insert within w_21015_e
string text = "복사"
end type

event cb_insert::clicked;call super::clicked; DECLARE sp_21015_d03 PROCEDURE FOR sp_21015_d03  
  @ps_mat_cd = :is_mat_cd,
  @ps_color = :is_color;

execute sp_21015_d03;


il_rows = dw_body.retrieve(is_mat_cd,is_color,0)


//idw_color1.Retrieve(is_style,is_chno)

IF il_rows = 0 THEN
	dw_body.Reset()
	dw_body.Insertrow(0)
END IF

dw_body.Setitem(1, "mat_cd", is_mat_cd)
dw_body.Setitem(1, "color", is_color)





end event

type cb_retrieve from w_com030_e`cb_retrieve within w_21015_e
end type

type cb_update from w_com030_e`cb_update within w_21015_e
end type

type cb_print from w_com030_e`cb_print within w_21015_e
boolean visible = false
end type

type cb_preview from w_com030_e`cb_preview within w_21015_e
end type

type gb_button from w_com030_e`gb_button within w_21015_e
integer x = 5
end type

type cb_excel from w_com030_e`cb_excel within w_21015_e
boolean visible = false
end type

type dw_head from w_com030_e`dw_head within w_21015_e
integer y = 184
integer height = 228
string dataobject = "d_21015_h01"
end type

event dw_head::constructor;call super::constructor;

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', is_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')




end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name


	CASE "brand", "year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		dw_head.accepttext()
		//라빠레트 시즌적용
		is_brand = dw_head.getitemstring(1,'brand')
		is_year = dw_head.getitemstring(1,'year')
		
		this.getchild("season",idw_season)
		idw_season.settransobject(sqlca)
		idw_season.retrieve('003', is_brand, is_year)
		//idw_season.retrieve('003')
	
		This.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', is_brand)
		idw_sojae.insertrow(1)
		idw_sojae.Setitem(1, "sojae", "%")
		idw_sojae.Setitem(1, "sojae_nm", "전체")
	
		
END CHOOSE

end event

type ln_1 from w_com030_e`ln_1 within w_21015_e
end type

type ln_2 from w_com030_e`ln_2 within w_21015_e
end type

type dw_list from w_com030_e`dw_list within w_21015_e
integer x = 9
integer width = 1102
string dataobject = "d_21015_d02"
end type

event dw_list::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long  ll_body_rows, ll_detail_rows
string ls_mat_nm, ls_cust_cd, ls_cust_nm, ls_flag

IF row <= 0 THEN Return

IF ib_changed  and (isnull(is_iud_gbn) or is_iud_gbn <> '0') THEN 
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

is_mat_cd = This.GetItemString(row, 'mat_cd') /* DataWindow에 Key 항목을 가져온다 */
is_color = This.GetItemString(row, 'color') /* DataWindow에 Key 항목을 가져온다 */
ls_mat_nm = This.GetItemString(row, 'mat_nm') /* 자재명 항목을 가져온다 */
ls_cust_cd = This.GetItemString(row, 'cust_cd') /* 거래처코드 항목을 가져온다 */
ls_cust_nm = This.GetItemString(row, 'cust_nm') /* 거래처명 항목을 가져온다 */


IF IsNull(is_mat_cd) or IsNull(is_color)  THEN return

il_rows = dw_body.retrieve(is_mat_cd,is_color,0)

IF il_rows = 0 THEN
	dw_body.Reset()
	dw_body.Insertrow(0)
	cb_1.visible = true
else
	ls_flag = dw_body.getitemstring(1,"flag")
	if ls_flag = "New" then 
		dw_body.SetItemStatus(1, 0, Primary!, Newmodified!)
	end if
	cb_1.visible = true
END IF

dw_body.Setitem(1, "mat_cd", is_mat_cd)
dw_body.Setitem(1, "color", is_color)
dw_body.Setitem(1, "mat_nm", ls_mat_nm)
dw_body.Setitem(1, "cust_cd", ls_cust_cd)
dw_body.Setitem(1, "cust_nm", ls_cust_nm)

il_rows = dw_1.retrieve(is_mat_cd,is_color)
il_rows = dw_2.retrieve(is_mat_cd,is_color)
il_rows = dw_3.retrieve(is_mat_cd)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com030_e`dw_body within w_21015_e
integer x = 1125
integer width = 1509
integer height = 1364
string dataobject = "d_21015_d01"
boolean maxbox = true
boolean vscrollbar = false
end type

event dw_body::constructor;
datawindowchild ldw_child

this.getchild("COLOR",idw_color)
idw_color.settransobject(sqlca)
idw_color.retrieve()
idw_color.InsertRow(1)


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


this.getchild("washing_type",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('216')









end event

event dw_body::dberror;//
end event

event dw_body::itemchanged;call super::itemchanged;string ls_yymmdd

select convert(char(08), getdate(), 112)
into :ls_yymmdd
from dual;

CHOOSE CASE dwo.name
	CASE "conform_yn" 
    IF data = 'Y' THEN
	   dw_body.setitem(row, "confirm_ymd", ls_yymmdd)
	 elseIF data <> 'Y' THEN
	   dw_body.setitem(row, "confirm_ymd", "")		
    END IF
END CHOOSE

end event

type st_1 from w_com030_e`st_1 within w_21015_e
integer x = 1106
end type

type dw_print from w_com030_e`dw_print within w_21015_e
integer x = 151
integer y = 1068
string dataobject = "d_kola_r00"
end type

type cb_1 from commandbutton within w_21015_e
boolean visible = false
integer x = 2089
integer y = 744
integer width = 384
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "시험분석적용"
end type

event clicked;int i
string ls_flag, ls_mat_nm
il_rows = dw_body.retrieve(is_mat_cd,is_color,1)
for i = 1 to il_rows
	ls_flag = dw_body.getitemstring(i,"flag")
	if ls_flag = 'New' then 
		dw_body.SetItemStatus(i, 0, Primary!, NewModified!)

	else
	
		dw_body.SetItemStatus(i, "mat_nm1", Primary!, DataModified!)
		dw_body.SetItemStatus(i, "mat_rate1", Primary!, DataModified!)
		dw_body.SetItemStatus(i, "mat_nm2", Primary!, DataModified!)
		dw_body.SetItemStatus(i, "mat_rate2", Primary!, DataModified!)
		dw_body.SetItemStatus(i, "mat_nm3", Primary!, DataModified!)
		dw_body.SetItemStatus(i, "mat_rate3", Primary!, DataModified!)
		dw_body.SetItemStatus(i, "mat_nm4", Primary!, DataModified!)
		dw_body.SetItemStatus(i, "mat_rate4", Primary!, DataModified!)
		dw_body.SetItemStatus(i, "mat_nm5", Primary!, DataModified!)
		dw_body.SetItemStatus(i, "mat_rate5", Primary!, DataModified!)		
		dw_body.SetItemStatus(i, "mat_nm6", Primary!, DataModified!)
		dw_body.SetItemStatus(i, "mat_rate6", Primary!, DataModified!)		
		dw_body.SetItemStatus(i, "mat_nm7", Primary!, DataModified!)
		dw_body.SetItemStatus(i, "mat_rate7", Primary!, DataModified!)		
		dw_body.SetItemStatus(i, "mat_nm8", Primary!, DataModified!)
		dw_body.SetItemStatus(i, "mat_rate8", Primary!, DataModified!)				

	end if	
next 

ls_mat_nm = dw_body.getitemstring(1,"mat_nm1")
if ls_mat_nm = '' or isnull(ls_mat_nm) then
else
	ib_changed = true
	cb_update.enabled = true
end if



end event

type dw_1 from datawindow within w_21015_e
integer x = 2656
integer y = 460
integer width = 942
integer height = 1580
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_21015_d04"
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


this.getchild("mat_nm7",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')


this.getchild("mat_nm8",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')

end event

type dw_2 from datawindow within w_21015_e
integer x = 1125
integer y = 1828
integer width = 1509
integer height = 208
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_21015_d05"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ib_changed = true
cb_update.enabled = true
end event

event editchanged;ib_changed = true
cb_update.enabled = true
end event

type dw_3 from datawindow within w_21015_e
integer x = 2135
integer y = 844
integer width = 498
integer height = 540
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_21015_d06"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_child

This.GetChild("OrgMat_Cd", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('021')
end event

