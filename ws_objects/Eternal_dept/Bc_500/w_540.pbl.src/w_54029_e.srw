$PBExportHeader$w_54029_e.srw
$PBExportComments$완불등록(쇼핑몰용)
forward
global type w_54029_e from w_com010_e
end type
type dw_color from datawindow within w_54029_e
end type
type dw_size from datawindow within w_54029_e
end type
end forward

global type w_54029_e from w_com010_e
integer width = 3675
integer height = 2280
dw_color dw_color
dw_size dw_size
end type
global w_54029_e w_54029_e

type variables
DataWindowChild	idw_brand, idw_color, idw_size, idw_shop_type
String	is_brand,  is_yymmdd , is_shop_cd, is_shop_type, is_add
end variables

forward prototypes
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

public function boolean wf_style_chk (long al_row, string as_style_no);String ls_style, ls_chno, ls_color,  ls_size, ls_shop_type, ls_bujin_chk
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn  
Long   ll_tag_price 

IF LenA(Trim(as_style_no)) <> 9 THEN RETURN FALSE

ls_style = MidA(as_style_no, 1, 8)
ls_chno  = MidA(as_style_no, 9, 1)


Select brand,     year,     season,     
       sojae,     item,     plan_yn, dep_fg   
  into :ls_brand, :ls_year, :ls_season, 
       :ls_sojae, :ls_item, :ls_plan_yn, :ls_bujin_chk    
  from vi_12020_1 
 where brand   = :is_brand 
   and style   = :ls_style 
	and chno    = :ls_chno;

IF SQLCA.SQLCODE <> 0 THEN 
	MessageBox("SQL 오류", SQLCA.SQLERRTEXT)
	RETURN FALSE 
END IF

  
				
				Select shop_type
				into :ls_shop_type
				From tb_56012_d with (nolock)
				Where style      = :ls_style 
				  and start_ymd <= :is_yymmdd
				  and end_ymd   >= :is_yymmdd
				  and shop_cd    = :is_shop_cd ;

				
				if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then
					IF ls_plan_yn = 'Y' then
						ls_shop_type = "3"
					ELSE	
						ls_shop_type = "1"
					END IF	
				end if	

				
				if ls_shop_type <> "1" or ls_shop_type <> "3"   THEN					
					messagebox("경고!", "정상/기획 이외 제품은 의뢰할수 없습니다!")
					ib_itemchanged = FALSE
					return FALSE				
				end if	

			
   dw_body.SetItem(al_row, "SHOP_TYPE", LS_SHOP_TYPE)
   dw_body.SetItem(al_row, "style",    ls_style)
	dw_body.SetItem(al_row, "chno",     ls_chno)
	dw_body.SetItem(al_row, "brand",    ls_brand)
	dw_body.SetItem(al_row, "year",     ls_year)
	dw_body.SetItem(al_row, "season",   ls_season)
	dw_body.SetItem(al_row, "sojae",    ls_sojae)
	dw_body.SetItem(al_row, "item",     ls_item)
	dw_body.SetItem(al_row, "rqst_qty", 1)	


Return True
end function

on w_54029_e.create
int iCurrent
call super::create
this.dw_color=create dw_color
this.dw_size=create dw_size
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_color
this.Control[iCurrent+2]=this.dw_size
end on

on w_54029_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_color)
destroy(this.dw_size)
end on

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "yymmdd",string(ld_datetime,"yyyymmdd"))

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                     */	
/* 작성일      :                                                 */	
/* 수정일      :                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_shop_type
String 		ls_plan_yn
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd1"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm1", "")
					RETURN 0
				ELSEIF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
					if MidA(as_data,2,1) = "E"  or MidA(as_data,2,1) = "D" then
						dw_head.SetItem(al_row, "shop_nm1", ls_shop_nm)
						RETURN 0
					else
				   	dw_head.SetItem(al_row, "shop_nm1", "")
						RETURN 0
					end if	
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV  in ('E','D') " + &
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
				dw_head.SetItem(al_row, "shop_cd1", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm1", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			
			
	CASE "style"		
		
			
			gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
 			   ls_brand = dw_head.GetitemString(1, "brand")
				gst_cd.default_where   = " WHERE 1 = 1 "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' " + &
											  " AND BRAND = '" + ls_brand + "'"
				ELSE
					gst_cd.Item_where = ""
				END IF

				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)		     
			  
				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm

					dw_body.SetRow(al_row)
					dw_body.SetColumn(as_column)

				ls_style = lds_Source.GetItemString(1,"style")
				ls_CHNO = lds_Source.GetItemString(1,"CHNO")				
				
				select isnull(plan_yn,'N'), isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX')
				into :ls_plan_yn, :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq
				from tb_12020_m with (nolock)
				where style = :ls_style;
			
				
						Select shop_type
						into :ls_shop_type
						From tb_56012_d with (nolock)
						Where style      = :ls_style 
						  and start_ymd <= :is_yymmdd
						  and end_ymd   >= :is_yymmdd
						  and shop_cd    = :is_shop_cd ;
					
					
				
						if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" then		
							if ls_plan_yn = "Y"  then
							 ls_shop_type = '3'
							else 
							 ls_shop_type = '1'	
							end if 
						end if	 

				
				if is_shop_type <> ls_shop_type then 
					messagebox("경고!", "제품판매가 가능한 매장형태는 " + ls_shop_type + " 입니다!")
					ib_itemchanged = FALSE
					return 1
				end if	
						
			
				if ls_bujin_chk = "Y" then 
					messagebox("부진체크", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
            end if 	

				
				
					dw_body.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_body.SetItem(al_row, "chno",  lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "brand", lds_Source.GetItemString(1,"brand"))
				   dw_body.SetItem(al_row, "year", lds_Source.GetItemString(1,"year"))
				   dw_body.SetItem(al_row, "season", lds_Source.GetItemString(1,"season"))
				   dw_body.SetItem(al_row, "sojae", lds_Source.GetItemString(1,"sojae"))
				   dw_body.SetItem(al_row, "item", lds_Source.GetItemString(1,"item"))
							
					if LenA(lds_Source.GetItemString(1,"style")) <> 8 then
					/* 다음컬럼으로 이동 */
					dw_body.SetColumn("style")
					else
					dw_body.SetColumn("color")
					end if
					ib_itemchanged = False
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

event pfc_preopen;call super::pfc_preopen;dw_color.SetTransObject(SQLCA)
dw_size.SetTransObject(SQLCA)
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
LONG ll_row_cnt, ii
String ls_rqst_seq
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_shop_cd, is_shop_type)
IF il_rows > 0 THEN

//	ll_row_cnt = dw_body.RowCount()
//	
//	for ii = 1 to ll_row_cnt
//		ls_rqst_seq = dw_body.getitemstring(ii, "rqst_seq")
//		if IsNull(ls_rqst_seq) or Trim(ls_rqst_seq) = "" then
//			dw_body.SetItemStatus(ii, 0, Primary!, New!)
//		end if	
//	next
	
   dw_body.SetFocus()
	
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"요청일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

//is_shop_cd = dw_head.GetItemString(1, "shop_cd1")
//if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
//   is_shop_cd = "%"  
//end if
//

is_shop_cd = dw_head.GetItemString(1, "shop_cd1")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd1")
   return false
end if


is_shop_type = dw_head.GetItemString(1, "shop_type1")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type1")
   return false
end if
//
//is_add = dw_head.GetItemString(1, "add")
//if IsNull(is_add) or Trim(is_add) = "" then
//   MessageBox(ls_title,"조회구분을 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("add")
//   return false
//end if


if MidA(is_shop_cd,2,5) <> "D1900" and is_add = "B" then
	 MessageBox(ls_title,"일괄추가 작업은 쇼핑몰코드만 가능합니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if	
	

return true

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_rqst_seq
datetime ld_datetime
string ls_shop_cd


ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


		select isnull(max(rqst_seq),0) 
		into :ll_rqst_seq
		from tb_54030_mall
		where yymmdd = :is_yymmdd
		and   shop_cd = :is_brand + 'D1900';


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	
   IF idw_status = NewModified!  THEN				/* New Record */
	ls_shop_cd = dw_body.getitemstring(i, "shop_cd")
   	ll_rqst_seq = ll_rqst_seq + 1	
	   dw_body.Setitem(i, "ordnum",    is_shop_cd + is_yymmdd)
      dw_body.Setitem(i, "ordseq",    ll_rqst_seq )		
      dw_body.Setitem(i, "shop_cd",   is_brand + 'D1900')
	   dw_body.Setitem(i, "yymmdd",    is_yymmdd)		
	   dw_body.Setitem(i, "yymmdd",    is_yymmdd)
      dw_body.Setitem(i, "rqst_seq",  ll_rqst_seq )
	   dw_body.Setitem(i, "reserve_qty", dw_body.getitemNumber(i, "rqst_qty"))				

//		if is_add <> "B" then
//		   dw_body.Setitem(i, "reserve_qty", dw_body.getitemNumber(i, "rqst_qty"))
//		end if	
      dw_body.Setitem(i, "reg_id", gs_user_id)
		
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
	   dw_body.Setitem(i, "reserve_qty", dw_body.getitemNumber(i, "rqst_qty"))				
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
	

NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.setitem(il_rows,"shop_type" , is_shop_type)	
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	if is_shop_cd <> "%" and LenA(is_shop_cd) = 6 then
		dw_body.setitem(il_rows,"shop_cd" , is_shop_cd)
		dw_body.setitem(il_rows,"shop_nm" , dw_head.getitemstring(1,"shop_nm1"))		
 	   dw_body.SetColumn("style")		
	end if
	dw_body.SetFocus()
	
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)


	
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54028_e","0")
end event

type cb_close from w_com010_e`cb_close within w_54029_e
end type

type cb_delete from w_com010_e`cb_delete within w_54029_e
end type

type cb_insert from w_com010_e`cb_insert within w_54029_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_54029_e
end type

type cb_update from w_com010_e`cb_update within w_54029_e
end type

type cb_print from w_com010_e`cb_print within w_54029_e
end type

type cb_preview from w_com010_e`cb_preview within w_54029_e
end type

type gb_button from w_com010_e`gb_button within w_54029_e
end type

type cb_excel from w_com010_e`cb_excel within w_54029_e
end type

type dw_head from w_com010_e`dw_head within w_54029_e
string dataobject = "d_54029_h01"
end type

event dw_head::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("shop_type1", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                     */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd1"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_54029_e
end type

type ln_2 from w_com010_e`ln_2 within w_54029_e
end type

type dw_body from w_com010_e`dw_body within w_54029_e
string dataobject = "d_54029_d01"
end type

event dw_body::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name

   CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

   CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

END CHOOSE

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)


This.GetChild("size", idw_size)
idw_size.SetTransObject(SQLCA)



end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;string DWfilter, ls_style, ls_chno, ls_color, ls_year, ls_season
string ls_item,  ls_sojae, ls_type, ls_size
long   i, j, ll_row_count, ll_row, ll_stock_qty, ll_stock_qty1

ls_style = dw_body.getitemstring(row, "style")
ls_chno  = dw_body.getitemstring(row,  "chno")
ls_color = dw_body.getitemstring(row, "color")
ls_size  = dw_body.getitemstring(row,  "size")

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

    CASE "rqst_qty"	
	
		ls_style = dw_body.getitemstring(row, "style")
		ls_chno  = dw_body.getitemstring(row, "chno")	
		ls_color = dw_body.getitemstring(row, "color")	
		ls_size  = dw_body.getitemstring(row, "size")	

		  IF gf_shop_stock(is_shop_cd, is_shop_type, ls_style, ls_chno, ls_color, ls_size, ll_stock_qty1) = 100 THEN 
			Return -1
		  END IF 

		
		  IF gf_house_stock(ls_style, ls_chno, ls_color, ls_size, "010000", ll_stock_qty) = 100 THEN 
			Return -1
		  END IF 
    
 	   dw_body.Setitem(row, "stock_qty", ll_stock_qty)
	   dw_body.Setitem(row, "shop_stock_qty", ll_stock_qty1)
	
END CHOOSE




end event

event dw_body::clicked;call super::clicked;String 	ls_search
if row > 0 then 
	choose case dwo.name
		case 'style','style_no'
			ls_search 	= this.GetItemString(row,string(dwo.name))
			if LenA(ls_search) >= 8 then gf_style_color_pic(ls_search, '%','%')			
	end choose	
end if

end event

type dw_print from w_com010_e`dw_print within w_54029_e
integer x = 517
integer y = 188
end type

type dw_color from datawindow within w_54029_e
boolean visible = false
integer x = 1861
integer y = 904
integer width = 411
integer height = 432
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_54015_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_size from datawindow within w_54029_e
boolean visible = false
integer x = 2619
integer y = 900
integer width = 411
integer height = 432
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_54015_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

