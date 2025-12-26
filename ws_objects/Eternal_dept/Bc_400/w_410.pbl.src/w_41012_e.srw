$PBExportHeader$w_41012_e.srw
$PBExportComments$중국출고재입고처리
forward
global type w_41012_e from w_com010_e
end type
type dw_list from datawindow within w_41012_e
end type
type cb_proc from commandbutton within w_41012_e
end type
type st_1 from statictext within w_41012_e
end type
end forward

global type w_41012_e from w_com010_e
integer width = 3685
integer height = 2264
dw_list dw_list
cb_proc cb_proc
st_1 st_1
end type
global w_41012_e w_41012_e

type variables
DataWindowChild    idw_color,   idw_size, idw_brand, idw_frm_house,idw_to_house
String is_brand,    is_yymmdd, is_seqno, is_frm_house, is_to_house, is_care_gubn


end variables

forward prototypes
public function boolean wf_style_chk (long al_row, string as_style_no)
public function boolean wf_move_proc (long al_row)
end prototypes

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.05.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_null
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn , ls_brand2
String ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
Long   ll_tag_price,  ll_cnt 
SetNull(ls_null)

ls_brand2 = dw_head.getitemstring(1, "brand")

IF al_row > 1 and LenA(as_style_no) <> 9 THEN
	gf_style_edit(dw_body.Object.style_no[al_row - 1], as_style_no, ls_style, ls_chno) 
   IF ls_chno = '%' THEN ls_chno = '0' 
ELSE 
	ls_style = LeftA(as_style_no, 8)
	ls_chno  = MidA(as_style_no, 9, 1)
END IF 




Select count(style), 
       max(style)  ,   max(chno), 
       max(brand)  ,   max(year),     max(season),     
       max(sojae)  ,   max(item),     max(tag_price)  
  into :ll_cnt     , 
       :ls_style   ,   :ls_chno, 
       :ls_brand   ,   :ls_year,      :ls_season, 
		 :ls_sojae   ,   :ls_item,      :ll_tag_price
  from vi_12020_1 with (nolock) 
 where style   like :ls_style 
	and chno    =    :ls_chno
	and brand   = 	  :ls_brand2
	and isnull(tag_price, 0) <> 0;
	
IF SQLCA.SQLCODE <> 0 or ll_cnt <> 1 THEN 
	Return False 
END IF 




   dw_body.SetItem(al_row, "style_no", ls_style + ls_chno)
   dw_body.SetItem(al_row, "style",    ls_style)
	dw_body.SetItem(al_row, "chno",     ls_chno)
	dw_body.SetItem(al_row, "brand",    ls_brand)


//IF Mid(is_shop_cd, 2, 1) = 'X' OR Mid(is_shop_cd, 2, 1) = 'T' OR 

	ls_color = dw_body.GetitemString(al_row - 1, "color")
	select count(color)
	  into :ll_cnt  
	  from tb_12024_d with (nolock)
	 where style = :ls_style 
	   and chno  = :ls_chno 
		and color = :ls_color ;
		
   IF ll_cnt > 0 THEN
      dw_body.SetItem(al_row, "color", ls_color)
	ELSE
      dw_body.SetItem(al_row, "color",    '')
	END IF
	
	dw_body.SetItem(al_row, "size", ls_null)


Return True

end function

public function boolean wf_move_proc (long al_row);string ls_style, ls_chno, ls_color, ls_size, ls_proc_in_no1, ls_proc_in_no2, ls_seqno
long i, ll_row_count, ll_qty
datetime ld_datetime

   idw_status = dw_body.GetItemStatus(al_row, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
		ls_style = dw_body.getitemstring(al_row, "style")
		ls_chno  = dw_body.getitemstring(al_row, "chno")
		ls_color = dw_body.getitemstring(al_row, "color")
		ls_size  = dw_body.getitemstring(al_row, "size")		
		ll_qty   = dw_body.getitemNumber(al_row, "qty")		
  	   ls_proc_in_no1   = dw_body.getitemstring(al_row, "minus_in_no")			
  	   ls_proc_in_no2   = dw_body.getitemstring(al_row, "plus_in_no")					  
		
		if isnull(ls_proc_in_no1) or trim(ls_proc_in_no1) = "" then
 		 DECLARE sp_41012 PROCEDURE FOR sp_41012  
         @yymmdd = :is_yymmdd,   
         @style  = :ls_style,   
         @chno   = :ls_chno,   
         @color  = :ls_color,   
         @size   = :ls_size,   
         @qty    = :ll_qty,   
         @brand  = :is_brand,   
         @reg_id = :gs_user_id,   
         @proc_in_no1 = :ls_proc_in_no1 OUTPUT ,   
         @proc_in_no2 = :ls_proc_in_no2 OUTPUT;
			
		 EXECUTE sp_41012;
			IF SQLCA.SQLCODE = -1 THEN 
				rollback  USING SQLCA;
				MessageBox("SQL오류", SQLCA.SqlErrText) 
				Return false
			ELSE
				commit  USING SQLCA;
			END IF 		

		end if	
      dw_body.Setitem(al_row, "minus_in_no", ls_proc_in_no1)
      dw_body.Setitem(al_row, "plus_in_no", ls_proc_in_no2)		
		
	end if		

return true
end function

on w_41012_e.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.cb_proc=create cb_proc
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.cb_proc
this.Control[iCurrent+3]=this.st_1
end on

on w_41012_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.cb_proc)
destroy(this.st_1)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;
String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
String 	  ls_plan_yn
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column

	CASE "style_no"		
			IF ai_div = 1 THEN 	
				IF wf_style_chk(al_row, as_data)  THEN 
					RETURN 2 
				END IF 
			END IF
			IF al_row > 1 THEN 
				gf_style_edit(dw_body.object.style_no[al_row -1], as_data, ls_style, ls_chno)				
				
			ELSE
		      ls_style = MidA(as_data, 1, 8)
		      ls_chno  = MidA(as_data, 9, 1) 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com013" 
			gst_cd.default_where   = "WHERE brand = '" + is_brand + "' " + & 
			                         "  AND isnull(tag_price, 0) <> 0 "
        
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" + &
				                " and chno  LIKE '" + ls_chno  + "%'" 
			ELSE
				gst_cd.Item_where = ""
			END IF

			lb_check = FALSE 
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				ls_style = lds_Source.GetItemString(1,"style")
				
				   dw_body.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style") + lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "style",    lds_Source.GetItemString(1,"style"))
				   dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand"))
				   dw_body.SetItem(al_row, "color",    lds_Source.GetItemString(1,"color"))
				   dw_body.SetItem(al_row, "size",     lds_Source.GetItemString(1,"size"))
				   ib_changed = true
               cb_update.enabled = true
				   /* 다음컬럼으로 이동 */
		         dw_body.SetColumn("qty")
			      lb_check = TRUE 

				ib_itemchanged = FALSE
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/
String ls_shop_nm

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(This.title)
		CASE 1
			IF This.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			dw_body.SetFocus()
			RETURN
	END CHOOSE
END IF

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

IF isnull(is_seqno) or Trim(is_seqno) = "" THEN 
	is_seqno = '%'
END IF

dw_body.reset()

il_rows = dw_list.retrieve(is_yymmdd, is_seqno, is_brand, is_care_gubn)


IF il_rows > 0 THEN
	dw_list.Visible = True
//	dw_body.Visible = False
   dw_list.SetFocus()
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

is_yymmdd =  String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"처리일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_frm_house =  dw_head.GetItemString(1, "frm_house")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준 창고를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_to_house =  dw_head.GetItemString(1, "to_house")
if IsNull(is_to_house) or Trim(is_to_house) = "" then
   MessageBox(ls_title,"입고창고를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_house")
   return false
end if

is_care_gubn =  dw_head.GetItemString(1, "care_gubn")
if IsNull(is_care_gubn) or Trim(is_care_gubn) = "" then
   MessageBox(ls_title,"처리구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("care_gubn")
   return false
end if

is_seqno = dw_head.GetItemString(1, "seqno")
if IsNull(is_seqno) or Trim(is_seqno) = "" then
	is_seqno = "%"
end if

return true


end event

event type long ue_update();call super::ue_update;string ls_style, ls_chno, ls_color, ls_size, ls_proc_in_no1, ls_proc_in_no2, ls_seqno
long i, ll_row_count, ll_qty
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

   IF LenA(is_seqno) <> 4 then
		select  substring(convert(varchar(5), convert(decimal(5), isnull(max(seqno), '0000')) + 10001), 2, 4) 
		into :ls_seqno
		from tb_41012_h with (nolock)
		where  yymmdd = :is_yymmdd;
	else 
		ls_seqno = is_seqno
	end if	



FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
		ls_style = dw_body.getitemstring(i, "style")
		ls_chno  = dw_body.getitemstring(i, "chno")
		ls_color = dw_body.getitemstring(i, "color")
		ls_size  = dw_body.getitemstring(i, "size")		
		ll_qty   = dw_body.getitemNumber(i, "qty")		
  	   ls_proc_in_no1   = dw_body.getitemstring(i, "minus_in_no")			
		
//		if wf_move_proc(i) = false  then return -1
//		if isnull(ls_proc_in_no1) or trim(ls_proc_in_no1) = "" then
// 		 DECLARE sp_41012 PROCEDURE FOR sp_41012  
//         @yymmdd = :is_yymmdd,   
//         @style  = :ls_style,   
//         @chno   = :ls_chno,   
//         @color  = :ls_color,   
//         @size   = :ls_size,   
//         @qty    = :ll_qty,   
//         @brand  = :is_brand,   
//         @reg_id = :gs_user_id,   
//         @proc_in_no1 = :ls_proc_in_no1 OUTPUT ,   
//         @proc_in_no2 = :ls_proc_in_no2 OUTPUT;
//			
//		 EXECUTE sp_41012;
//			IF SQLCA.SQLCODE = -1 THEN 
//				rollback  USING SQLCA;
//				MessageBox("SQL오류", SQLCA.SqlErrText) 
//				Return -1 
//			ELSE
//				commit  USING SQLCA;
//			END IF 		
//		end if	
		
      dw_body.Setitem(i, "yymmdd", is_yymmdd)						
      dw_body.Setitem(i, "seqno", ls_seqno)			
      dw_body.Setitem(i, "minus_in_no", ls_proc_in_no1)
      dw_body.Setitem(i, "plus_in_no", ls_proc_in_no2)		
      dw_body.Setitem(i, "care_gubn", is_care_gubn)			
      dw_body.Setitem(i, "brand", is_brand)					
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)

		ls_style = dw_body.getitemstring(i, "style")
		ls_chno  = dw_body.getitemstring(i, "chno")
		ls_color = dw_body.getitemstring(i, "color")
		ls_size  = dw_body.getitemstring(i, "size")		
		ll_qty   = dw_body.getitemNumber(i, "qty")		
  	   ls_proc_in_no1   = dw_body.getitemstring(i, "minus_in_no")		
   END IF
			
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	dw_head.Setitem(1, "seqno", ls_seqno)	
	dw_list.retrieve(is_yymmdd, ls_seqno, is_brand, is_care_gubn)
	dw_list.visible = true
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_list,   "ScaleToRight&Bottom")

dw_list.SetTransObject(SQLCA)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         cb_proc.enabled = true			
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
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
			cb_proc.enabled = true			
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
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      cb_proc.enabled = false		
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

type cb_close from w_com010_e`cb_close within w_41012_e
end type

type cb_delete from w_com010_e`cb_delete within w_41012_e
integer x = 1111
end type

type cb_insert from w_com010_e`cb_insert within w_41012_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_41012_e
end type

type cb_update from w_com010_e`cb_update within w_41012_e
end type

type cb_print from w_com010_e`cb_print within w_41012_e
end type

type cb_preview from w_com010_e`cb_preview within w_41012_e
end type

type gb_button from w_com010_e`gb_button within w_41012_e
end type

type cb_excel from w_com010_e`cb_excel within w_41012_e
end type

type dw_head from w_com010_e`dw_head within w_41012_e
integer y = 156
integer width = 3355
integer height = 212
string dataobject = "d_41012_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("frm_house", idw_frm_house)
idw_frm_house.SetTransObject(SQLCA)
idw_frm_house.Retrieve('%')


This.GetChild("to_house", idw_to_house)
idw_to_house.SetTransObject(SQLCA)
idw_to_house.Retrieve('%')


// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

type ln_1 from w_com010_e`ln_1 within w_41012_e
integer beginy = 388
integer endy = 388
end type

type ln_2 from w_com010_e`ln_2 within w_41012_e
integer beginy = 392
integer endy = 392
end type

type dw_body from w_com010_e`dw_body within w_41012_e
event ue_set_col ( string as_column )
integer x = 14
integer y = 400
integer height = 1628
string dataobject = "d_41012_d02"
end type

event dw_body::ue_set_col(string as_column);This.SetColumn(as_column)
end event

event dw_body::constructor;call super::constructor;This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.insertRow(0)

This.GetChild("size", idw_size)
idw_size.SetTransObject(SQLCA)
idw_size.insertRow(0)
end event

event dw_body::itemchanged;call super::itemchanged;
Long    ll_ret, ll_curr_price, ll_qty, ll_out_price 
String ls_null
Setnull(ls_null) 

CHOOSE CASE dwo.name
	CASE "style_no"	
		IF ib_itemchanged THEN RETURN 1 
		ll_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		IF LenA(This.GetitemString(row, "size")) = 2 THEN
			This.Post Event ue_set_col("qty")
		END IF 
		Return ll_ret
	CASE "color"	
		This.Setitem(row, "size", ls_null) 

END CHOOSE

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;String ls_style, ls_chno, ls_color

CHOOSE CASE dwo.name
	CASE "color" 
		ls_style = This.GetitemString(row, "style")
		ls_chno  = This.GetitemString(row, "chno")
		idw_color.Retrieve(ls_style, ls_chno)
	CASE "size"
		ls_style = This.GetitemString(row, "style")
		ls_chno  = This.GetitemString(row, "chno")
		ls_color = This.GetitemString(row, "color")
		idw_size.Retrieve(ls_style, ls_chno, ls_color)
END CHOOSE

end event

event dw_body::dberror;//
end event

type dw_print from w_com010_e`dw_print within w_41012_e
end type

type dw_list from datawindow within w_41012_e
boolean visible = false
integer x = 18
integer y = 348
integer width = 3589
integer height = 1572
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_41012_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;String ls_seqno, ls_shop_type  

IF row < 0 THEN RETURN 

ls_seqno    = This.GetitemString(row, "seqno")

IF dw_body.Retrieve(is_yymmdd,  ls_seqno, is_brand, is_care_gubn) > 0 THEN 
   dw_body.visible = True						  
   dw_list.visible = False 
	cb_insert.Enabled = True
	dw_head.Setitem(1, "seqno", ls_seqno)

END IF

end event

type cb_proc from commandbutton within w_41012_e
integer x = 375
integer y = 44
integer width = 347
integer height = 92
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "입고재처리"
end type

event clicked;string ls_style, ls_chno, ls_color, ls_size, ls_proc_in_no1, ls_proc_in_no2, ls_seqno, ls_proc_yn, ls_care_gubn
long i, ll_row_count, ll_qty
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

IF Trigger Event ue_keycheck('1') = FALSE THEN 
	return -1
end if	

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
		ls_style = dw_body.getitemstring(i, "style")
		ls_chno  = dw_body.getitemstring(i, "chno")
		ls_color = dw_body.getitemstring(i, "color")
		ls_size  = dw_body.getitemstring(i, "size")		
		ll_qty   = dw_body.getitemNumber(i, "qty")		
  	   ls_proc_yn = dw_body.getitemstring(i, "proc_yn")		
		ls_seqno	= dw_body.getitemstring(i, "seqno")			  
	
		
		if ls_proc_yn = "N" then
			
		 st_1.visible = true
			
 		 DECLARE sp_41012 PROCEDURE FOR sp_41012  
         @yymmdd = :is_yymmdd,   
         @style  = :ls_style,   
         @chno   = :ls_chno,   
         @color  = :ls_color,   
         @size   = :ls_size,   
         @qty    = :ll_qty,   
         @brand  = :is_brand,   
         @reg_id = :gs_user_id,
			@care_gubn = :is_care_gubn,
		   @frm_house = :is_frm_house,
		   @TO_house  = :is_TO_house,			
			@seqno     = :ls_seqno;
			
		 EXECUTE sp_41012;
			IF SQLCA.SQLCODE = -1 THEN 
				rollback  USING SQLCA;
				MessageBox("SQL오류", SQLCA.SqlErrText) 
 			   st_1.visible = false
				Return -1 
			ELSE
				commit  USING SQLCA;
			END IF 		
		end if			
NEXT

 st_1.visible = false
cb_proc.enabled = false
dw_body.retrieve( is_yymmdd, is_seqno,is_brand, is_care_gubn)	//조회




end event

type st_1 from statictext within w_41012_e
boolean visible = false
integer x = 434
integer y = 1048
integer width = 2766
integer height = 164
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 65535
long backcolor = 8421376
string text = "지금 처리 중 입니다! 잠시만 기다려 주세요!"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

