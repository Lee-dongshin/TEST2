$PBExportHeader$w_46005_e.srw
$PBExportComments$부자재공제내역등록
forward
global type w_46005_e from w_com010_e
end type
type dw_list from datawindow within w_46005_e
end type
type dw_mat from datawindow within w_46005_e
end type
type cb_input from commandbutton within w_46005_e
end type
end forward

global type w_46005_e from w_com010_e
integer width = 3675
integer height = 2244
event ue_input ( )
dw_list dw_list
dw_mat dw_mat
cb_input cb_input
end type
global w_46005_e w_46005_e

type variables
string is_brand, is_yymmdd, is_out_no, is_shop_cd, is_shop_type, is_apply_yymm
DataWindowChild idw_brand
end variables

forward prototypes
public subroutine wf_amt_set (long al_row, long al_qty, long al_curr_price)
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

event ue_input();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
dw_list.Visible   = False
dw_body.Visible   = True
dw_head.setitem(1, "out_no", "")


/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_body.Reset()
il_rows = dw_body.insertRow(0)


IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(6, il_rows)

//IF is_shop_type = '1' or is_shop_type = '3'  THEN
//	dw_member.Enabled = TRUE
//ELSE
//	dw_member.Enabled = FALSE 
//END IF 
end event

public subroutine wf_amt_set (long al_row, long al_qty, long al_curr_price);
Long ll_price
Decimal ldc_amt 


ll_price  = dw_body.GetitemDecimal(al_row, "price") 

ldc_amt   = dec(ll_price) * al_qty   

dw_body.Setitem(al_row, "amt", ldc_amt) 



end subroutine

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.05.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_null, ls_shop_type, ls_work_gubn
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn , ls_brand2
String ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
Long   ll_tag_price,  ll_cnt 
SetNull(ls_null)


IF al_row > 1 and LenA(as_style_no) <> 9 THEN
	gf_style_edit(dw_body.Object.style_no[al_row - 1], as_style_no, ls_style, ls_chno) 
	
	IF ls_chno = '%' THEN
		select isnull(min(chno),'%')
		into :ls_chno
		from tb_12021_d (nolock)
		where style like :ls_style;
	END IF

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
	and plan_yn like :ls_plan_yn
	and brand   = 	  :ls_brand2
	and isnull(tag_price, 0) <> 0;
	
IF SQLCA.SQLCODE <> 0 or ll_cnt <> 1 THEN 
	Return False 
END IF 

   dw_body.SetItem(al_row, "style_no", ls_style + ls_chno)
   dw_body.SetItem(al_row, "style",    ls_style)
	dw_body.SetItem(al_row, "chno",     ls_chno)
	dw_body.SetItem(al_row, "color",    "XX")	
	dw_body.SetItem(al_row, "size",     "XX")	
	dw_body.SetItem(al_row, "brand",    ls_brand)
	dw_body.SetItem(al_row, "year",     ls_year)
	dw_body.SetItem(al_row, "season",   ls_season)


Return True

end function

on w_46005_e.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_mat=create dw_mat
this.cb_input=create cb_input
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_mat
this.Control[iCurrent+3]=this.cb_input
end on

on w_46005_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_mat)
destroy(this.cb_input)
end on

event pfc_preopen();call super::pfc_preopen;
inv_resize.of_Register(dw_list, "ScaleToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_mat.SetTransObject(SQLCA)
inv_resize.of_Register(cb_input, "FixedToRight")

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
String 	  ls_plan_yn, ls_SHOP_TYPE,ls_work_gubn, ls_gubn
Boolean    lb_check 
long  ll_row
DataStore  lds_Source
long ll_row1
string ls_mat_cd,  ls_mat_nm
decimal ldc_price

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm3(as_data, 'S', ls_shop_nm) = 0 THEN
					
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
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
			gst_cd.datawindow_nm   = "d_com012" 
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
				ls_CHNO = lds_Source.GetItemString(1,"CHNO")							
				
				   dw_body.SetItem(al_row, "style_no", ls_style + ls_chno )
				   dw_body.SetItem(al_row, "style",    lds_Source.GetItemString(1,"style"))
				   dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "brand",    lds_Source.GetItemString(1,"brand"))
				   dw_body.SetItem(al_row, "year",     lds_Source.GetItemString(1,"year"))
				   dw_body.SetItem(al_row, "season",   lds_Source.GetItemString(1,"season"))
				   dw_body.SetItem(al_row, "color",    "XX")
				   dw_body.SetItem(al_row, "size",     "XX")
				   ib_changed = true
               cb_update.enabled = true
				   /* 다음컬럼으로 이동 */
					
					ll_row = dw_mat.retrieve(is_brand, ls_style, ls_chno, al_row)
					if ll_row > 1 then
						dw_mat.visible = true
						dw_mat.setfocus()
					elseif ll_row = 1 then
						dw_mat.visible = true
						dw_mat.setfocus()						


						ls_mat_cd = dw_mat.GetitemString(1, "mat_cd")
						ls_mat_nm = dw_mat.GetitemString(1, "mat_nm")
						ldc_price = dw_mat.GetitemNumber(1, "mat_price")
						ll_row = dw_mat.GetitemNumber(1, "row_no")
						
						dw_body.setitem(al_row, "mat_cd", ls_mat_cd)
						dw_body.setitem(al_row, "mat_nm", ls_mat_nm)
						dw_body.setitem(al_row, "price", ldc_price)
						dw_body.setitem(al_row, "qty", 1)
						dw_body.setitem(al_row, "apply_yymm", is_apply_yymm)
						dw_body.SetColumn("qty")
						dw_mat.visible = false
						dw_body.Setfocus()
						
					else
						dw_mat.visible = false
						messagebox("알림", "대상 부자재가 없는 품번 입니다!")
					 dw_body.SetColumn("style_no")
					end if
					
					
//		         dw_body.SetColumn("qty")
			      lb_check = TRUE 
				END IF
				ib_itemchanged = FALSE

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
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"등록일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if


//select case when :is_yymmdd between convert(char(06), dateadd(mm, -1, :is_yymmdd),112) + '16'
//			                       and substring(:is_yymmdd,1,6) + '15' then substring(:is_yymmdd,1,6) 
//	         when :is_yymmdd between substring(:is_yymmdd,1,6) + '16'
//			                      and convert(char(06), dateadd(mm, 1, :is_yymmdd),112) + '15' then convert(char(06), dateadd(mm, 1, :is_yymmdd),112) 
//	end
select  case when :is_yymmdd between convert(char(06), dateadd(mm, -1, :is_yymmdd),112) + '16'  
           and convert(char(06), dateadd(mm, 0, :is_yymmdd),112) + '15'                         
      then  convert(char(06), dateadd(mm, -1, :is_yymmdd),112) 

      when :is_yymmdd between convert(char(06), dateadd(mm, 0, :is_yymmdd),112) + '16'	
           and convert(char(06), dateadd(mm, 1, :is_yymmdd),112) + '15' 
      then convert(char(06), dateadd(mm, 0, :is_yymmdd),112) 
 end	
into :is_apply_yymm	
from dual;	


is_out_no = dw_head.GetItemString(1, "out_no")
if IsNull(is_out_no) or Trim(is_out_no) = "" then
 is_out_no = "%"
end if

is_shop_type = "1"

return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_yymmdd, is_shop_cd, is_shop_type, is_out_no, is_brand )
IF il_rows > 0 THEN
   dw_list.visible = true
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count, li_no
datetime ld_datetime
string ls_out_no
Long ll_price, LL_QTY
Decimal ldc_amt 



ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

   IF LenA(is_out_no) <> 4 then
		select  substring(convert(varchar(5), convert(decimal(5), isnull(max(out_no), '0000')) + 10001), 2, 4) 
		into :ls_out_no
		from tb_42023_h with (nolock)
		where  yymmdd = :is_yymmdd;
   else
		ls_out_no = is_out_no
	end if	
	
select   convert(decimal(5), isnull(max(no), '0000'))
into :li_no
from tb_42023_h with (nolock)
where brand   = :is_brand
and   yymmdd  = :is_yymmdd
and   out_no  = :is_out_no
and   shop_cd = :is_shop_cd
and   shop_type = "1" ;

	

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
	

		ll_price  = dw_body.GetitemDecimal(i, "price") 
		ll_qty    = dw_body.GetitemDecimal(i, "qty") 
		ldc_amt   = dec(ll_price) * ll_qty   
		dw_body.Setitem(i, "amt", ldc_amt) 	
      dw_body.Setitem(i, "yymmdd", is_yymmdd)			
      dw_body.Setitem(i, "shop_cd", is_shop_cd)			
      dw_body.Setitem(i, "out_no", ls_out_no)			
      dw_body.Setitem(i, "no"     , string(i,"0000"))
      dw_body.Setitem(i, "shop_type", "1")		
      dw_body.Setitem(i, "apply_yymm", is_apply_yymm)	
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	dw_head.setitem(1, "out_no", ls_out_no)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows
end event

event ue_button(integer ai_cb_div, long al_rows);
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows >= 0 then
         cb_excel.enabled   = true
         cb_insert.enabled  = false
         cb_update.enabled  = false
         cb_input.Text      = "등록(&I)"
         dw_head.enabled    = true 
         dw_body.enabled    = false
         ib_changed         = false
      end if
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			dw_body.Enabled = true			
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = true
				dw_body.Enabled = true
			end if
		end if
	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed         = false
			cb_excel.enabled   = true
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
      cb_input.Text = "등록(&I)"
      cb_insert.enabled  = false
      cb_delete.enabled  = false
      cb_print.enabled   = false

      cb_preview.enabled = false
      cb_excel.enabled   = false
      cb_update.enabled  = false 
//		IF dw_body.RowCount() > 0 THEN 
//		   IF dw_body.GetItemStatus(1, 0, Primary!) <> New! THEN 
//				cb_copy.enabled  = true 
//			END IF
//		END IF
//      ib_changed         = false
      dw_body.Enabled    = false
      dw_head.Enabled    = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 6		/* 입력 */
      if al_rows > 0 then
         cb_insert.enabled  = true
         cb_print.enabled   = false
          cb_preview.enabled = false
         cb_excel.enabled   = false
         dw_head.Enabled    = false
         dw_body.Enabled    = true
         dw_body.SetFocus()
         ib_changed = false
         cb_update.enabled = false
         cb_input.Text = "조건(&I)"
      else
         cb_insert.enabled  = false
         cb_delete.enabled  = false
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
      end if

END CHOOSE
end event

type cb_close from w_com010_e`cb_close within w_46005_e
end type

type cb_delete from w_com010_e`cb_delete within w_46005_e
end type

type cb_insert from w_com010_e`cb_insert within w_46005_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_46005_e
end type

type cb_update from w_com010_e`cb_update within w_46005_e
end type

type cb_print from w_com010_e`cb_print within w_46005_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_46005_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_46005_e
end type

type cb_excel from w_com010_e`cb_excel within w_46005_e
end type

type dw_head from w_com010_e`dw_head within w_46005_e
integer y = 148
integer height = 180
string dataobject = "d_46005_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

event dw_head::itemchanged;call super::itemchanged;String ls_yymmdd

CHOOSE CASE dwo.name
//	CASE "yymmdd"      
//		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
//		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
//			  MessageBox("경고","소급할수 없는 일자입니다.")
//			  Return 1
//        END IF
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_46005_e
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com010_e`ln_2 within w_46005_e
integer beginy = 352
integer endy = 352
end type

type dw_body from w_com010_e`dw_body within w_46005_e
integer y = 368
integer height = 1636
string dataobject = "d_46005_d01"
end type

event dw_body::itemchanged;call super::itemchanged;Long    ll_ret, ll_price, ll_qty

String ls_null
Setnull(ls_null) 

CHOOSE CASE dwo.name
	CASE "style_no"	
		IF ib_itemchanged THEN RETURN 1 
		ll_ret = Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		Return ll_ret
	CASE "qty"	
		ll_price = This.GetitemNumber(row, "price")
		wf_amt_set(row, Long(data), ll_price)
END CHOOSE

end event

event dw_body::doubleclicked;call super::doubleclicked;string ls_style, ls_chno
long ll_row

ls_style = this.getitemstring(row, "style")
ls_chno  = this.getitemstring(row, "chno")


ll_row = dw_mat.retrieve(is_brand, ls_style, ls_chno, row)

if ll_row > 0 then 
	dw_mat.visible = true
else
	messagebox("알림!", "대상 부자재가 없는 품번입니다!")
	dw_mat.visible = false
end if	
	



end event

event dw_body::dberror;//
end event

type dw_print from w_com010_e`dw_print within w_46005_e
end type

type dw_list from datawindow within w_46005_e
integer y = 368
integer width = 3589
integer height = 1644
integer taborder = 40
string title = "none"
string dataobject = "d_46005_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;String ls_out_no, ls_shop_type 

IF row < 0 THEN RETURN 

is_out_no    = This.GetitemString(row, "out_no")
dw_head.setitem(1,"out_no" , is_out_no)

IF dw_body.Retrieve(is_yymmdd, is_shop_cd, is_shop_type, is_out_no, is_brand) > 0 THEN 
   dw_body.visible = True						  
   dw_list.visible = False 
	cb_insert.Enabled = True	
   dw_head.ENABLED = FALSE
	Parent.Trigger Event ue_insert()
	dw_body.SetFocus()
	
END IF

end event

type dw_mat from datawindow within w_46005_e
boolean visible = false
integer x = 974
integer y = 368
integer width = 1353
integer height = 832
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "부자재검색"
string dataobject = "d_46005_d03"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;long ll_row
string ls_mat_cd,  ls_mat_nm
decimal ldc_price

ls_mat_cd = this.GetitemString(row, "mat_cd")
ls_mat_nm = this.GetitemString(row, "mat_nm")
ldc_price = this.GetitemNumber(row, "mat_price")
ll_row = this.GetitemNumber(row, "row_no")

dw_body.setitem(ll_row, "mat_cd", ls_mat_cd)
dw_body.setitem(ll_row, "mat_nm", ls_mat_nm)
dw_body.setitem(ll_row, "price", ldc_price)
dw_body.setitem(ll_row, "qty", 1)
dw_body.setitem(ll_row, "apply_yymm", is_apply_yymm)
dw_body.SetColumn("qty")
this.visible = false
dw_body.Setfocus()
end event

type cb_input from commandbutton within w_46005_e
event ue_keydown pbm_keydown
integer x = 2487
integer y = 44
integer width = 384
integer height = 92
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "등록(&I)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
end event

event clicked;/*===========================================================================*/
/* 작성자      : 김태범        															  */	
/* 작성일      : 2002.03.04																  */	
/* 수정일      : 2002.03.04																  */
/*===========================================================================*/
IF dw_head.Enabled THEN
   Parent.Trigger Event ue_input()	//등록 
ELSE 
	Parent.Trigger Event ue_head()	//조건 
END IF

end event

event getfocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 700

end event

event losefocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 400

end event

