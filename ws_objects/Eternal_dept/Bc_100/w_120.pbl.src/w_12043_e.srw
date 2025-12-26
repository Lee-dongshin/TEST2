$PBExportHeader$w_12043_e.srw
$PBExportComments$품번별 상품태깅정보 입력
forward
global type w_12043_e from w_com020_e
end type
end forward

global type w_12043_e from w_com020_e
end type
global w_12043_e w_12043_e

type variables
Datawindowchild idw_branD, idw_yeAR, idw_season, idw_item
Datawindowchild idw_comment_class,idw_sale_class,idw_run_season,idw_plan_month,idw_close_month,idw_item_lrg_class,idw_item_mid_class,idw_item_sub_class,idw_item_lrg_02_neck
Datawindowchild idw_item_lrg_02_sleeve,idw_item_lrg_02_fit,idw_item_lrg_02_patt,idw_item_lrg_01_015_filler,idw_item_lrg_01_015_goose,idw_item_lrg_01_015_skin
Datawindowchild IDW_item_bag, IDW_item_SHOES, IDW_CARRY_GUBN

string is_brand, is_style, is_chno, is_year, is_season, is_opt_view, is_item
end variables

on w_12043_e.create
call super::create
end on

on w_12043_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12043_e","0")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_cust_nm , ls_style, ls_chno,ls_country
Boolean    lb_check 
DataStore  lds_Source
String ls_style_no, ls_out_ymd
Long   ll_row, ll_tag_price

CHOOSE CASE as_column
	
			CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				if gs_brand <> 'K' then
					gst_cd.default_where   = " WHERE 1 = 1 "
				else
					gst_cd.default_where   = ""
				end if
				
				if gs_brand <> 'K' then
					IF Trim(as_data) <> "" THEN
						gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
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
            
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
					dw_head.SetItem(al_row, "year", lds_Source.GetItemString(1,"year"))
					dw_head.SetItem(al_row, "season", lds_Source.GetItemString(1,"season"))
					
		ls_style = lds_Source.GetItemString(1,"style")			
		ls_chno  = lds_Source.GetItemString(1,"chno")					

//		select dbo.sf_first_price(style),  min(out_ymd)
//		into :ll_tag_price, :ls_out_ymd
//		from tb_12030_s
//		where style =  :ls_style
//		  and chno  like  :ls_chno + '%'
//		group by style;
//		
//		SELECT dbo.sf_inter_nm('000',country_cd)
//			INTO  :ls_country
//			FROM vi_12020_1 WITH(NOLOCK)
//			WHERE STYLE = :ls_style
//			and chno =  :ls_chno;
//		
//		
//		 st_info.text = "♥" + ls_country + "생산, 가격:" + string(ll_tag_price, "#,###") + "원/최초출고일:" + string(ls_out_ymd, "@@@@/@@/@@")
					
								

					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("opt_view")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
//			END IF
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


is_brand = Trim(dw_head.GetItemString(1, "brand"))
IF IsNull(is_brand) OR is_brand = "" THEN
	MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("brand")
	RETURN FALSE
END IF

is_year = Trim(dw_head.GetItemString(1, "year"))
IF IsNull(is_year) OR is_year = "" THEN
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
	RETURN FALSE
END IF

is_season = Trim(dw_head.GetItemString(1, "season"))
IF IsNull(is_season) OR is_season = "" THEN
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
	RETURN FALSE
END IF


is_item = Trim(dw_head.GetItemString(1, "item"))
IF IsNull(is_item) OR is_item = "" THEN
   MessageBox(ls_title,"품종을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
	RETURN FALSE
END IF

is_style = Trim(dw_head.GetItemString(1, "style"))
IF IsNull(is_style) OR is_style = "" then
	is_style = "%"
END IF

is_chno = Trim(dw_head.GetItemString(1, "chno"))
IF IsNull(is_chno) OR is_chno = "" then
	is_style = "%"
END IF


is_opt_view = Trim(dw_head.GetItemString(1, "opt_view"))
IF IsNull(is_opt_view) OR is_opt_view = "" then
   MessageBox(ls_title,"조회 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_view")
	RETURN FALSE
END IF



RETURN TRUE
end event

event ue_retrieve();call super::ue_retrieve;
string ls_filter_str

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//B,F,H,L,P,R, T,U,W
IF is_brand = "B" OR is_brand = "F" OR is_brand = "H" OR is_brand = "L" OR is_brand = "P" OR is_brand = "R" OR is_brand = "T" OR is_brand = "U" OR   is_brand = "W"  THEN
   dw_list.DataObject = "d_12043_d11"
	dw_list.SetTransObject(SQLCA)
	
   dw_body.DataObject = "d_12043_d12"
	dw_body.SetTransObject(SQLCA)
	
ELSE
   dw_list.DataObject = "d_12043_d01"
	dw_list.SetTransObject(SQLCA)
	
   dw_body.DataObject = "d_12043_d02"
	dw_body.SetTransObject(SQLCA)
		
END IF	

il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_item, is_style, is_chno, is_opt_view)

//dw_body.Reset()

IF is_brand = "B" OR is_brand = "F" OR is_brand = "H" OR is_brand = "L" OR is_brand = "P" OR is_brand = "R" OR is_brand = "T" OR is_brand = "U" OR   is_brand = "W"  THEN
 		dw_body.GetChild("comment_class", idw_comment_class)
		idw_comment_class.SetTransObject(SQLCA)
		idw_comment_class.Retrieve('816')
		
		dw_body.GetChild("sale_class", idw_sale_class)
		idw_sale_class.SetTransObject(SQLCA)
		idw_sale_class.Retrieve('817')
			
		
		dw_body.GetChild("item_bag", idw_item_bag)
		idw_item_bag.SetTransObject(SQLCA)
		idw_item_bag.Retrieve('834')
		
		dw_body.GetChild("item_SHOES", idw_item_SHOES)
		idw_item_SHOES.SetTransObject(SQLCA)
		idw_item_SHOES.Retrieve('835')
		
		
		dw_body.GetChild("carry_gubn", idw_carry_gubn)
		idw_carry_gubn.SetTransObject(SQLCA)
		idw_carry_gubn.Retrieve('833')
		
	
ELSE
		dw_body.GetChild("comment_class", idw_comment_class)
		idw_comment_class.SetTransObject(SQLCA)
		idw_comment_class.Retrieve('816')
		
		dw_body.GetChild("sale_class", idw_sale_class)
		idw_sale_class.SetTransObject(SQLCA)
		idw_sale_class.Retrieve('817')
		
		dw_body.GetChild("run_season", idw_run_season)
		idw_run_season.SetTransObject(SQLCA)
		idw_run_season.Retrieve('003')
		
		ls_filter_str = ''	
		ls_filter_str = "inter_cd <> 'X' and  inter_cd <> 'P'  "
		idw_run_season.SetFilter(ls_filter_str)
		idw_run_season.Filter( )
		
		
		dw_body.GetChild("plan_month", idw_plan_month)
		idw_plan_month.SetTransObject(SQLCA)
		idw_plan_month.Retrieve('818')
		
		dw_body.GetChild("close_month", idw_close_month)
		idw_close_month.SetTransObject(SQLCA)
		idw_close_month.Retrieve('818')
		
		dw_body.GetChild("item_lrg_class", idw_item_lrg_class)
		idw_item_lrg_class.SetTransObject(SQLCA)
		idw_item_lrg_class.Retrieve('81A')
		
		dw_body.GetChild("item_mid_class", idw_item_mid_class)
		idw_item_mid_class.SetTransObject(SQLCA)
		idw_item_mid_class.Retrieve('81B', '%')
		
		dw_body.GetChild("item_sub_class", idw_item_sub_class)
		idw_item_sub_class.SetTransObject(SQLCA)
		idw_item_sub_class.Retrieve('81C', '%')
		
		dw_body.GetChild("item_lrg_02_neck", idw_item_lrg_02_neck)
		idw_item_lrg_02_neck.SetTransObject(SQLCA)
		idw_item_lrg_02_neck.Retrieve('819')
		
		dw_body.GetChild("item_lrg_02_sleeve", idw_item_lrg_02_sleeve)
		idw_item_lrg_02_sleeve.SetTransObject(SQLCA)
		idw_item_lrg_02_sleeve.Retrieve('820')
		
		dw_body.GetChild("item_lrg_02_fit", idw_item_lrg_02_fit)
		idw_item_lrg_02_fit.SetTransObject(SQLCA)
		idw_item_lrg_02_fit.Retrieve('821')
		
		dw_body.GetChild("item_lrg_02_patt", idw_item_lrg_02_patt)
		idw_item_lrg_02_patt.SetTransObject(SQLCA)
		idw_item_lrg_02_patt.Retrieve('822')
		
		
		dw_body.GetChild("item_lrg_01_015_filler", idw_item_lrg_01_015_filler)
		idw_item_lrg_01_015_filler.SetTransObject(SQLCA)
		idw_item_lrg_01_015_filler.Retrieve('830')
		
		dw_body.GetChild("item_lrg_01_015_goose", idw_item_lrg_01_015_goose)
		idw_item_lrg_01_015_goose.SetTransObject(SQLCA)
		idw_item_lrg_01_015_goose.Retrieve('832')
		
		dw_body.GetChild("item_lrg_01_015_skin", idw_item_lrg_01_015_skin)
		idw_item_lrg_01_015_skin.SetTransObject(SQLCA)
		idw_item_lrg_01_015_skin.Retrieve('831')

		
END IF	


IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count
string ls_line_nm, ls_datawindow_nm
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1


//d_12043_d12

ls_datawindow_nm = dw_body.Dataobject



/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	
//	if ls_datawindow_nm = "d_12043_d12" then
//		ls_line_nm = dw_body.GetItemString(i, "line_nm" )
//		
//		select replace(:ls_line_nm, ' ' ,'')
//		into :ls_line_nm
//		from dual;
//		
//	//	messagebox("ls_line_nm",ls_line_nm)
//		
//	end if	
		
	
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_dt", ld_datetime)
      dw_body.Setitem(i, "reg_id", gs_user_id)
		
		if ls_datawindow_nm = "d_12043_d12" then
			ls_line_nm = dw_body.GetItemString(i, "line_nm" )
			
			select replace(:ls_line_nm, ' ' ,'')
			into :ls_line_nm
			from dual;
			
			 dw_body.Setitem(i, "line_nm", ls_line_nm)
			
		end if	
		
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
		
		if ls_datawindow_nm = "d_12043_d12" then
			ls_line_nm = dw_body.GetItemString(i, "line_nm" )
			
			select replace(:ls_line_nm, ' ' ,'')
			into :ls_line_nm
			from dual;
			
			 dw_body.Setitem(i, "line_nm", ls_line_nm)
			
		end if	
		
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)



if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	ib_changed = false
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_retrieve()
// dw_list.retrieve(is_brand, is_year, is_season, is_item, is_style, is_chno, is_opt_view)

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;
//CHOOSE CASE ai_cb_div
//   CASE 1		/* 조회 */
//      if al_rows > 0 then
//         cb_retrieve.Text = "조건(&Q)"
//         dw_head.Enabled = false
//         dw_list.Enabled = true
//         dw_body.Enabled = true
//      else
//         dw_head.SetFocus()
//      end if
//
////   CASE 2   /* 추가 */
////      if al_rows > 0 then
////			cb_delete.enabled = true
////			cb_print.enabled = false
////			cb_preview.enabled = false
////			cb_excel.enabled = false
////			if dw_head.Enabled then
////				cb_retrieve.Text = "조건(&Q)"
////				dw_head.Enabled = false
////				dw_list.Enabled = true
////				dw_body.Enabled = true
////			end if
////		end if
//
//	CASE 3		/* 저장 */
//		if al_rows = 1 then
//			ib_changed = false
//			cb_print.enabled = true
//			cb_preview.enabled = true
//			cb_excel.enabled = true
//		end if
//
////	CASE 4		/* 삭제 */
////		if al_rows = 1 then
////			if dw_body.RowCount() = 0 then
////            cb_delete.enabled = false
////			end if
////         if idw_status <> new! and idw_status <> newmodified! then
////            ib_changed = true
////            cb_update.enabled = true
////			end if
////         cb_print.enabled = false
////         cb_preview.enabled = false
////         cb_excel.enabled = false
////		end if
////
//   CASE 5    /* 조건 */
//      cb_retrieve.Text = "조회(&Q)"
//      cb_insert.enabled = false
//      cb_delete.enabled = false
//      cb_print.enabled = false
//      cb_preview.enabled = false
//      cb_excel.enabled = false
//      cb_update.enabled = false
//      ib_changed = false
//      dw_list.Enabled = false
//      dw_body.Enabled = false
//      dw_head.Enabled = true
//      dw_head.SetFocus()
//      dw_head.SetColumn(1)
//
//   CASE 7  /* dw_list clicked 조회 */
//      if al_rows > 0 then
//         cb_delete.enabled = true
//         cb_print.enabled = true
//         cb_preview.enabled = true
//         cb_excel.enabled = true
//		else
//         cb_delete.enabled = false
//         cb_print.enabled = false
//         cb_preview.enabled = false
//         cb_excel.enabled = false
//		end if
//
//      if al_rows >= 0 then
//         ib_changed = false
//         cb_update.enabled = false
//         cb_insert.enabled = true
//      end if
//END CHOOSE
end event

type cb_close from w_com020_e`cb_close within w_12043_e
end type

type cb_delete from w_com020_e`cb_delete within w_12043_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_12043_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_12043_e
end type

type cb_update from w_com020_e`cb_update within w_12043_e
end type

type cb_print from w_com020_e`cb_print within w_12043_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_12043_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_12043_e
end type

type cb_excel from w_com020_e`cb_excel within w_12043_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_12043_e
string dataobject = "d_12043_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if



This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')


end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand, ls_bf_year
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			IF isnull(data) or trim(data) = "" then RETURN 0
			IF LenA(trim(data)) < 8 then RETURN 0		
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
			
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
		
		THIS.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve( data )
		idw_item.InsertRow(1)
		idw_item.SetItem(1, "item", '%')
		idw_item.SetItem(1, "item_nm", '전체')
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
	  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")						

END CHOOSE
end event

type ln_1 from w_com020_e`ln_1 within w_12043_e
end type

type ln_2 from w_com020_e`ln_2 within w_12043_e
end type

type dw_list from w_com020_e`dw_list within w_12043_e
integer x = 9
integer y = 444
integer width = 2162
integer height = 1556
string dataobject = "d_12043_d01"
end type

event dw_list::clicked;call super::clicked;
String ls_style , ls_chno, ls_year, ls_season, ls_item_lrg_class, ls_item_mid_class, ls_null, ls_filter_str, ls_auto, LS_COLOR
Long   ll_row,  ll_rows

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

ls_style   = This.GetItemString(row, 'style') 
ls_chno    = This.GetItemString(row, 'chno') 
ls_year    = This.GetItemString(row, 'year') 
ls_season  = This.GetItemString(row, 'season') 

IF IsNull(ls_style) OR isNull(ls_chno) THEN return 


//B,F,H,L,P,R, T,U,W
IF is_brand = "B" OR is_brand = "F" OR is_brand = "H" OR is_brand = "L" OR is_brand = "P" OR is_brand = "R" OR is_brand = "T" OR is_brand = "U" OR   is_brand = "W"  THEN
   dw_body.DataObject = "d_12043_d12"
	dw_body.SetTransObject(SQLCA)
	
	dw_body.GetChild("comment_class", idw_comment_class)
	idw_comment_class.SetTransObject(SQLCA)
	idw_comment_class.Retrieve('816')
	
	dw_body.GetChild("sale_class", idw_sale_class)
	idw_sale_class.SetTransObject(SQLCA)
	idw_sale_class.Retrieve('817')
		
	
	dw_body.GetChild("item_bag", idw_item_bag)
	idw_item_bag.SetTransObject(SQLCA)
	idw_item_bag.Retrieve('834')
	
	dw_body.GetChild("item_SHOES", idw_item_SHOES)
	idw_item_SHOES.SetTransObject(SQLCA)
	idw_item_SHOES.Retrieve('835')
	
	
	dw_body.GetChild("carry_gubn", idw_carry_gubn)
	idw_carry_gubn.SetTransObject(SQLCA)
	idw_carry_gubn.Retrieve('833')
		
	ls_color  = This.GetItemString(row, 'color') 		
		
	ll_rows = dw_body.retrieve(ls_style, ls_chno, ls_color, ls_year, ls_season)		
	
ELSE
   dw_body.DataObject = "d_12043_d02"
	dw_body.SetTransObject(SQLCA)
	
	dw_body.GetChild("comment_class", idw_comment_class)
	idw_comment_class.SetTransObject(SQLCA)
	idw_comment_class.Retrieve('816')
	
	dw_body.GetChild("sale_class", idw_sale_class)
	idw_sale_class.SetTransObject(SQLCA)
	idw_sale_class.Retrieve('817')
	
	dw_body.GetChild("run_season", idw_run_season)
	idw_run_season.SetTransObject(SQLCA)
	idw_run_season.Retrieve('003')
	
	ls_filter_str = ''	
	ls_filter_str = "inter_cd <> 'X' and  inter_cd <> 'P'  "
	idw_run_season.SetFilter(ls_filter_str)
	idw_run_season.Filter( )
	
	dw_body.GetChild("plan_month", idw_plan_month)
	idw_plan_month.SetTransObject(SQLCA)
	idw_plan_month.Retrieve('818')
	
	dw_body.GetChild("close_month", idw_close_month)
	idw_close_month.SetTransObject(SQLCA)
	idw_close_month.Retrieve('818')
	
	dw_body.GetChild("item_lrg_class", idw_item_lrg_class)
	idw_item_lrg_class.SetTransObject(SQLCA)
	idw_item_lrg_class.Retrieve('81A')
	
	dw_body.GetChild("item_mid_class", idw_item_mid_class)
	idw_item_mid_class.SetTransObject(SQLCA)
	idw_item_mid_class.Retrieve('81B', '%')
	
	dw_body.GetChild("item_sub_class", idw_item_sub_class)
	idw_item_sub_class.SetTransObject(SQLCA)
	idw_item_sub_class.Retrieve('81C', '%')
	
	dw_body.GetChild("item_lrg_02_neck", idw_item_lrg_02_neck)
	idw_item_lrg_02_neck.SetTransObject(SQLCA)
	idw_item_lrg_02_neck.Retrieve('819')
	
	dw_body.GetChild("item_lrg_02_sleeve", idw_item_lrg_02_sleeve)
	idw_item_lrg_02_sleeve.SetTransObject(SQLCA)
	idw_item_lrg_02_sleeve.Retrieve('820')
	
	dw_body.GetChild("item_lrg_02_fit", idw_item_lrg_02_fit)
	idw_item_lrg_02_fit.SetTransObject(SQLCA)
	idw_item_lrg_02_fit.Retrieve('821')
	
	dw_body.GetChild("item_lrg_02_patt", idw_item_lrg_02_patt)
	idw_item_lrg_02_patt.SetTransObject(SQLCA)
	idw_item_lrg_02_patt.Retrieve('822')
	
	
	dw_body.GetChild("item_lrg_01_015_filler", idw_item_lrg_01_015_filler)
	idw_item_lrg_01_015_filler.SetTransObject(SQLCA)
	idw_item_lrg_01_015_filler.Retrieve('830')
	
	dw_body.GetChild("item_lrg_01_015_goose", idw_item_lrg_01_015_goose)
	idw_item_lrg_01_015_goose.SetTransObject(SQLCA)
	idw_item_lrg_01_015_goose.Retrieve('832')
	
	dw_body.GetChild("item_lrg_01_015_skin", idw_item_lrg_01_015_skin)
	idw_item_lrg_01_015_skin.SetTransObject(SQLCA)
	idw_item_lrg_01_015_skin.Retrieve('831')	
	
	ll_rows = dw_body.retrieve(ls_style, ls_chno, ls_year, ls_season)

	
		
END IF	

//dw_body.RESET()



//

//ll_rows = dw_body.retrieve(ls_style, ls_chno, ls_year, ls_season)

ib_changed = false

ls_auto = dw_body.GetItemString(1, 'mod_id') 

commit  USING SQLCA;

//if ls_auto = "auto" then
//	messagebox("auto", ls_auto)
//   dw_body.ResetUpdate()
//   commit  USING SQLCA;
//end if	

IF is_brand = "B" OR is_brand = "F" OR is_brand = "H" OR is_brand = "L" OR is_brand = "P" OR is_brand = "R" OR is_brand = "T" OR is_brand = "U" OR   is_brand = "W"  THEN

		IF is_brand = "B" OR is_brand = "F" OR  is_brand = "L" OR is_brand = "P" OR is_brand = "R" OR is_brand = "T" OR is_brand = "U"   THEN
					dw_body.OBJECT.item_shoes.VISIBLE = 0
					dw_body.OBJECT.item_shoes_T.VISIBLE = 0			
	
					dw_body.OBJECT.item_bag.VISIBLE = 1
					dw_body.OBJECT.item_bag_t.VISIBLE = 1
					
		else 				
					dw_body.OBJECT.item_shoes.VISIBLE = 1
					dw_body.OBJECT.item_shoes_T.VISIBLE = 1			
	
					dw_body.OBJECT.item_bag.VISIBLE = 0
					dw_body.OBJECT.item_bag_t.VISIBLE = 0
		end if					

else 
		ls_item_lrg_class  = dw_body.GetItemString(1, 'item_lrg_class') 
		ls_item_mid_class  = dw_body.GetItemString(1, 'item_mid_class') 
		
		
		IF ls_item_lrg_class <> "02" THEN
					dw_body.SetItem(1, "item_lrg_02_neck", LS_NULL)
					dw_body.SetItem(1, "item_lrg_02_sleeve", LS_NULL)			
					dw_body.SetItem(1, "item_lrg_02_fit", LS_NULL)
					dw_body.SetItem(1, "item_lrg_02_PATT", LS_NULL)			
					
					dw_body.OBJECT.item_lrg_02_neck.VISIBLE = 0
					dw_body.OBJECT.item_lrg_02_sleeve.VISIBLE = 0			
					dw_body.OBJECT.item_lrg_02_fit.VISIBLE = 0
					dw_body.OBJECT.item_lrg_02_PATT.VISIBLE = 0		
					dw_body.OBJECT.gb_1.VISIBLE = 0			
		
					dw_body.OBJECT.item_lrg_02_neck_T.VISIBLE = 0
					dw_body.OBJECT.item_lrg_02_sleeve_T.VISIBLE = 0			
					dw_body.OBJECT.item_lrg_02_fit_T.VISIBLE = 0
					dw_body.OBJECT.item_lrg_02_PATT_T.VISIBLE = 0		
				ELSE 
					dw_body.OBJECT.item_lrg_02_neck.VISIBLE = 1
					dw_body.OBJECT.item_lrg_02_sleeve.VISIBLE = 1			
					dw_body.OBJECT.item_lrg_02_fit.VISIBLE = 1
					dw_body.OBJECT.item_lrg_02_PATT.VISIBLE = 1		
					dw_body.OBJECT.gb_1.VISIBLE = 1			
		
					dw_body.OBJECT.item_lrg_02_neck_T.VISIBLE = 1
					dw_body.OBJECT.item_lrg_02_sleeve_T.VISIBLE = 1			
					dw_body.OBJECT.item_lrg_02_fit_T.VISIBLE = 1
					dw_body.OBJECT.item_lrg_02_PATT_T.VISIBLE = 1					
		
					
		
				END IF	
				
				IF LS_item_mid_class <> "015" THEN
					dw_body.SetItem(1, "item_lrg_01_015_filler", LS_NULL)
					dw_body.SetItem(1, "item_lrg_01_015_goose", LS_NULL)			
					dw_body.SetItem(1, "item_lrg_01_015_skin", LS_NULL)
					dw_body.SetItem(1, "item_lrg_01_015_fillpower", 0)		
					
					dw_body.OBJECT.item_lrg_01_015_filler.VISIBLE = 0
					dw_body.OBJECT.item_lrg_01_015_goose.VISIBLE = 0			
					dw_body.OBJECT.item_lrg_01_015_skin.VISIBLE = 0
					dw_body.OBJECT.item_lrg_01_015_fillpower.VISIBLE = 0					
					dw_body.OBJECT.gb_2.VISIBLE = 0			
					
					dw_body.OBJECT.item_lrg_01_015_filler_T.VISIBLE = 0
					dw_body.OBJECT.item_lrg_01_015_goose_T.VISIBLE = 0			
					dw_body.OBJECT.item_lrg_01_015_skin_T.VISIBLE = 0
					dw_body.OBJECT.item_lrg_01_015_fillpower_T.VISIBLE = 0				
				ELSE 
					
					dw_body.OBJECT.item_lrg_01_015_filler.VISIBLE = 1
					dw_body.OBJECT.item_lrg_01_015_goose.VISIBLE = 1			
					dw_body.OBJECT.item_lrg_01_015_skin.VISIBLE = 1
					dw_body.OBJECT.item_lrg_01_015_fillpower.VISIBLE = 1					
					dw_body.OBJECT.gb_2.VISIBLE = 1			
					
					dw_body.OBJECT.item_lrg_01_015_filler_T.VISIBLE = 1
					dw_body.OBJECT.item_lrg_01_015_goose_T.VISIBLE = 1		
					dw_body.OBJECT.item_lrg_01_015_skin_T.VISIBLE = 1
					dw_body.OBJECT.item_lrg_01_015_fillpower_T.VISIBLE = 1				
					
				END IF	
end if				
					


Parent.Trigger Event ue_button(7, ll_rows)
Parent.Trigger Event ue_msg(1, ll_rows)
end event

type dw_body from w_com020_e`dw_body within w_12043_e
integer x = 2181
integer y = 440
integer width = 1413
integer height = 1560
string dataobject = "d_12043_d02"
end type

event dw_body::constructor;call super::constructor;

DataWindowChild ldw_child
string  ls_filter_str

This.GetChild("comment_class", idw_comment_class)
idw_comment_class.SetTransObject(SQLCA)
idw_comment_class.Retrieve('816')

This.GetChild("sale_class", idw_sale_class)
idw_sale_class.SetTransObject(SQLCA)
idw_sale_class.Retrieve('817')

This.GetChild("run_season", idw_run_season)
idw_run_season.SetTransObject(SQLCA)
idw_run_season.Retrieve('003')


ls_filter_str = ''	
ls_filter_str = "inter_cd <> 'X' and  inter_cd <> 'P'  "
idw_run_season.SetFilter(ls_filter_str)
idw_run_season.Filter( )



This.GetChild("plan_month", idw_plan_month)
idw_plan_month.SetTransObject(SQLCA)
idw_plan_month.Retrieve('818')

This.GetChild("close_month", idw_close_month)
idw_close_month.SetTransObject(SQLCA)
idw_close_month.Retrieve('818')

This.GetChild("item_lrg_class", idw_item_lrg_class)
idw_item_lrg_class.SetTransObject(SQLCA)
idw_item_lrg_class.Retrieve('81A')

This.GetChild("item_mid_class", idw_item_mid_class)
idw_item_mid_class.SetTransObject(SQLCA)
idw_item_mid_class.Retrieve('81B', '%')

This.GetChild("item_sub_class", idw_item_sub_class)
idw_item_sub_class.SetTransObject(SQLCA)
idw_item_sub_class.Retrieve('81C', '%')

This.GetChild("item_lrg_02_neck", idw_item_lrg_02_neck)
idw_item_lrg_02_neck.SetTransObject(SQLCA)
idw_item_lrg_02_neck.Retrieve('819')

This.GetChild("item_lrg_02_sleeve", idw_item_lrg_02_sleeve)
idw_item_lrg_02_sleeve.SetTransObject(SQLCA)
idw_item_lrg_02_sleeve.Retrieve('820')

This.GetChild("item_lrg_02_fit", idw_item_lrg_02_fit)
idw_item_lrg_02_fit.SetTransObject(SQLCA)
idw_item_lrg_02_fit.Retrieve('821')

This.GetChild("item_lrg_02_patt", idw_item_lrg_02_patt)
idw_item_lrg_02_patt.SetTransObject(SQLCA)
idw_item_lrg_02_patt.Retrieve('822')


This.GetChild("item_lrg_01_015_filler", idw_item_lrg_01_015_filler)
idw_item_lrg_01_015_filler.SetTransObject(SQLCA)
idw_item_lrg_01_015_filler.Retrieve('830')

This.GetChild("item_lrg_01_015_goose", idw_item_lrg_01_015_goose)
idw_item_lrg_01_015_goose.SetTransObject(SQLCA)
idw_item_lrg_01_015_goose.Retrieve('832')

This.GetChild("item_lrg_01_015_skin", idw_item_lrg_01_015_skin)
idw_item_lrg_01_015_skin.SetTransObject(SQLCA)
idw_item_lrg_01_015_skin.Retrieve('831')



//Datawindowchild idw_comment_class, idw_sale_class, idw_run_season,idw_plan_month,idw_close_month,idw_item_lrg_class,idw_item_mid_class,idw_item_sub_class,idw_item_lrg_02_neck
//Datawindowchild idw_item_lrg_02_sleeve,idw_item_lrg_02_fit,idw_item_lrg_02_patt,idw_item_lrg_01_015_filler,idw_item_lrg_01_015_goose,idw_item_lrg_01_015_skin
//


end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;String ls_item_lrg_class, LS_item_mid_class, ls_item_sub_class, LS_NULL

datawindow ldw_child

CHOOSE CASE dwo.name
	CASE "item_mid_class"
		ls_item_lrg_class = This.GetItemString(row, "item_lrg_class")
		idw_item_mid_class.Retrieve('81B', ls_item_lrg_class)
		
		ls_item_lrg_class = This.GetItemString(row, "item_lrg_class")
		LS_item_mid_class = This.GetItemString(row, "item_mid_class")
		
	
		IF ls_item_lrg_class <> "02" THEN
			THIS.SetItem(1, "item_lrg_02_neck", LS_NULL)
			THIS.SetItem(1, "item_lrg_02_sleeve", LS_NULL)			
			THIS.SetItem(1, "item_lrg_02_fit", LS_NULL)
			THIS.SetItem(1, "item_lrg_02_PATT", LS_NULL)			
			
			THIS.OBJECT.item_lrg_02_neck.VISIBLE = 0
			THIS.OBJECT.item_lrg_02_sleeve.VISIBLE = 0			
			THIS.OBJECT.item_lrg_02_fit.VISIBLE = 0
			THIS.OBJECT.item_lrg_02_PATT.VISIBLE = 0		
			THIS.OBJECT.gb_1.VISIBLE = 0			

			THIS.OBJECT.item_lrg_02_neck_T.VISIBLE = 0
			THIS.OBJECT.item_lrg_02_sleeve_T.VISIBLE = 0			
			THIS.OBJECT.item_lrg_02_fit_T.VISIBLE = 0
			THIS.OBJECT.item_lrg_02_PATT_T.VISIBLE = 0		
		ELSE 
			THIS.OBJECT.item_lrg_02_neck.VISIBLE = 1
			THIS.OBJECT.item_lrg_02_sleeve.VISIBLE = 1			
			THIS.OBJECT.item_lrg_02_fit.VISIBLE = 1
			THIS.OBJECT.item_lrg_02_PATT.VISIBLE = 1		
			THIS.OBJECT.gb_1.VISIBLE = 1			

			THIS.OBJECT.item_lrg_02_neck_T.VISIBLE = 1
			THIS.OBJECT.item_lrg_02_sleeve_T.VISIBLE = 1			
			THIS.OBJECT.item_lrg_02_fit_T.VISIBLE = 1
			THIS.OBJECT.item_lrg_02_PATT_T.VISIBLE = 1					

			

		END IF	
		
		IF  LS_item_mid_class <> "015" THEN
			THIS.SetItem(1, "item_lrg_01_015_filler", LS_NULL)
			THIS.SetItem(1, "item_lrg_01_015_goose", LS_NULL)			
			THIS.SetItem(1, "item_lrg_01_015_skin", LS_NULL)
			THIS.SetItem(1, "item_lrg_01_015_fillpower", 0)		
			
			THIS.OBJECT.item_lrg_01_015_filler.VISIBLE = 0
			THIS.OBJECT.item_lrg_01_015_goose.VISIBLE = 0			
			THIS.OBJECT.item_lrg_01_015_skin.VISIBLE = 0
			THIS.OBJECT.item_lrg_01_015_fillpower.VISIBLE = 0					
			THIS.OBJECT.gb_2.VISIBLE = 0			
			
			THIS.OBJECT.item_lrg_01_015_filler_T.VISIBLE = 0
			THIS.OBJECT.item_lrg_01_015_goose_T.VISIBLE = 0			
			THIS.OBJECT.item_lrg_01_015_skin_T.VISIBLE = 0
			THIS.OBJECT.item_lrg_01_015_fillpower_T.VISIBLE = 0				
		ELSE 
			
			THIS.OBJECT.item_lrg_01_015_filler.VISIBLE = 1
			THIS.OBJECT.item_lrg_01_015_goose.VISIBLE = 1			
			THIS.OBJECT.item_lrg_01_015_skin.VISIBLE = 1
			THIS.OBJECT.item_lrg_01_015_fillpower.VISIBLE = 1					
			THIS.OBJECT.gb_2.VISIBLE = 1			
			
			THIS.OBJECT.item_lrg_01_015_filler_T.VISIBLE = 1
			THIS.OBJECT.item_lrg_01_015_goose_T.VISIBLE = 1		
			THIS.OBJECT.item_lrg_01_015_skin_T.VISIBLE = 1
			THIS.OBJECT.item_lrg_01_015_fillpower_T.VISIBLE = 1		
			
			
		END IF	
					


   CASE "item_lrg_02_patt","item_lrg_01_015_filler","item_lrg_01_015_goose","item_lrg_01_015_skin","item_lrg_01_015_fillpower"

		ls_item_lrg_class = This.GetItemString(row, "item_lrg_class")
		LS_item_mid_class = This.GetItemString(row, "item_mid_class")
		
	
		IF ls_item_lrg_class <> "02" THEN
			THIS.SetItem(1, "item_lrg_02_neck", LS_NULL)
			THIS.SetItem(1, "item_lrg_02_sleeve", LS_NULL)			
			THIS.SetItem(1, "item_lrg_02_fit", LS_NULL)
			THIS.SetItem(1, "item_lrg_02_PATT", LS_NULL)			
			
			THIS.OBJECT.item_lrg_02_neck.VISIBLE = 0
			THIS.OBJECT.item_lrg_02_sleeve.VISIBLE = 0			
			THIS.OBJECT.item_lrg_02_fit.VISIBLE = 0
			THIS.OBJECT.item_lrg_02_PATT.VISIBLE = 0		
			THIS.OBJECT.gb_1.VISIBLE = 0			

			THIS.OBJECT.item_lrg_02_neck_T.VISIBLE = 0
			THIS.OBJECT.item_lrg_02_sleeve_T.VISIBLE = 0			
			THIS.OBJECT.item_lrg_02_fit_T.VISIBLE = 0
			THIS.OBJECT.item_lrg_02_PATT_T.VISIBLE = 0		
		ELSE 
			THIS.OBJECT.item_lrg_02_neck.VISIBLE = 1
			THIS.OBJECT.item_lrg_02_sleeve.VISIBLE = 1			
			THIS.OBJECT.item_lrg_02_fit.VISIBLE = 1
			THIS.OBJECT.item_lrg_02_PATT.VISIBLE = 1		
			THIS.OBJECT.gb_1.VISIBLE = 1			

			THIS.OBJECT.item_lrg_02_neck_T.VISIBLE = 1
			THIS.OBJECT.item_lrg_02_sleeve_T.VISIBLE = 1			
			THIS.OBJECT.item_lrg_02_fit_T.VISIBLE = 1
			THIS.OBJECT.item_lrg_02_PATT_T.VISIBLE = 1					

			

		END IF	
		
		IF LS_item_mid_class <> "015" THEN
			THIS.SetItem(1, "item_lrg_01_015_filler", LS_NULL)
			THIS.SetItem(1, "item_lrg_01_015_goose", LS_NULL)			
			THIS.SetItem(1, "item_lrg_01_015_skin", LS_NULL)
			THIS.SetItem(1, "item_lrg_01_015_fillpower", 0)		
			
			THIS.OBJECT.item_lrg_01_015_filler.VISIBLE = 0
			THIS.OBJECT.item_lrg_01_015_goose.VISIBLE = 0			
			THIS.OBJECT.item_lrg_01_015_skin.VISIBLE = 0
			THIS.OBJECT.item_lrg_01_015_fillpower.VISIBLE = 0					
			THIS.OBJECT.gb_2.VISIBLE = 0			
			
			THIS.OBJECT.item_lrg_01_015_filler_T.VISIBLE = 0
			THIS.OBJECT.item_lrg_01_015_goose_T.VISIBLE = 0			
			THIS.OBJECT.item_lrg_01_015_skin_T.VISIBLE = 0
			THIS.OBJECT.item_lrg_01_015_fillpower_T.VISIBLE = 0				
		ELSE 
			
			THIS.OBJECT.item_lrg_01_015_filler.VISIBLE = 1
			THIS.OBJECT.item_lrg_01_015_goose.VISIBLE = 1			
			THIS.OBJECT.item_lrg_01_015_skin.VISIBLE = 1
			THIS.OBJECT.item_lrg_01_015_fillpower.VISIBLE = 1					
			THIS.OBJECT.gb_2.VISIBLE = 1			
			
			THIS.OBJECT.item_lrg_01_015_filler_T.VISIBLE = 1
			THIS.OBJECT.item_lrg_01_015_goose_T.VISIBLE = 1		
			THIS.OBJECT.item_lrg_01_015_skin_T.VISIBLE = 1
			THIS.OBJECT.item_lrg_01_015_fillpower_T.VISIBLE = 1		
			
			
		END IF	
					
			
		
		IF LS_item_mid_class = "011" OR 	LS_item_mid_class = "012" OR LS_item_mid_class = "013" OR LS_item_mid_class = "014" OR LS_item_mid_class = "016" OR LS_item_mid_class = "017" OR 	LS_item_mid_class = "018" OR	LS_item_mid_class = "019" THEN
			

		   idw_item_sub_class.Retrieve('81C', LS_item_mid_class)
			ls_item_sub_class = RightA(LS_item_mid_class,2) + "X"
			THIS.SetItem(1, "item_sub_class", ls_item_sub_class)
			
		ELSEIF LS_item_mid_class = "01A" OR 	LS_item_mid_class = "01B" OR 	LS_item_mid_class = "01C" OR 	LS_item_mid_class = "01D" OR LS_item_mid_class = "01X" OR			LS_item_mid_class = "024" OR 		LS_item_mid_class = "025" OR 	LS_item_mid_class = "026"  THEN 
			
	
					
			
			idw_item_sub_class.Retrieve('81C', LS_item_mid_class)
			ls_item_sub_class = RightA(LS_item_mid_class,2) + "X"
			THIS.SetItem(1, "item_sub_class", ls_item_sub_class)

		ELSEIF LS_item_mid_class = "02X" OR LS_item_mid_class = "03X" OR LS_item_mid_class = "041" OR LS_item_mid_class = "042" OR LS_item_mid_class = "043" OR LS_item_mid_class = "044" OR LS_item_mid_class = "045" OR	LS_item_mid_class = "046" THEN

	
		

			idw_item_sub_class.Retrieve('81C', LS_item_mid_class)
			ls_item_sub_class = RightA(LS_item_mid_class,2) + "X"
			THIS.SetItem(1, "item_sub_class", ls_item_sub_class)
			
		ELSEIF LS_item_mid_class = "047" OR LS_item_mid_class = "048" OR 	LS_item_mid_class = "99X"   THEN

				
	
		
			
			idw_item_sub_class.Retrieve('81C', LS_item_mid_class)
			ls_item_sub_class = RightA(LS_item_mid_class,2) + "X"
			THIS.SetItem(1, "item_sub_class", ls_item_sub_class)

		ELSE 

				
	
		
			
			idw_item_sub_class.Retrieve('81C', LS_item_mid_class)

		END IF	
			
		
		
	CASE "comment_class","sale_class","run_season","plan_month","close_month","item_lrg_class","item_sub_class","item_lrg_02_neck","item_lrg_02_sleeve","item_lrg_02_fit"		

	ls_item_lrg_class = This.GetItemString(row, "item_lrg_class")
		LS_item_mid_class = This.GetItemString(row, "item_mid_class")
		
			
	
		IF ls_item_lrg_class <> "02" THEN
			THIS.SetItem(1, "item_lrg_02_neck", LS_NULL)
			THIS.SetItem(1, "item_lrg_02_sleeve", LS_NULL)			
			THIS.SetItem(1, "item_lrg_02_fit", LS_NULL)
			THIS.SetItem(1, "item_lrg_02_PATT", LS_NULL)			
			
			THIS.OBJECT.item_lrg_02_neck.VISIBLE = 0
			THIS.OBJECT.item_lrg_02_sleeve.VISIBLE = 0			
			THIS.OBJECT.item_lrg_02_fit.VISIBLE = 0
			THIS.OBJECT.item_lrg_02_PATT.VISIBLE = 0		
			THIS.OBJECT.gb_1.VISIBLE = 0			

			THIS.OBJECT.item_lrg_02_neck_T.VISIBLE = 0
			THIS.OBJECT.item_lrg_02_sleeve_T.VISIBLE = 0			
			THIS.OBJECT.item_lrg_02_fit_T.VISIBLE = 0
			THIS.OBJECT.item_lrg_02_PATT_T.VISIBLE = 0		
		ELSE 
			THIS.OBJECT.item_lrg_02_neck.VISIBLE = 1
			THIS.OBJECT.item_lrg_02_sleeve.VISIBLE = 1			
			THIS.OBJECT.item_lrg_02_fit.VISIBLE = 1
			THIS.OBJECT.item_lrg_02_PATT.VISIBLE = 1		
			THIS.OBJECT.gb_1.VISIBLE = 1			

			THIS.OBJECT.item_lrg_02_neck_T.VISIBLE = 1
			THIS.OBJECT.item_lrg_02_sleeve_T.VISIBLE = 1			
			THIS.OBJECT.item_lrg_02_fit_T.VISIBLE = 1
			THIS.OBJECT.item_lrg_02_PATT_T.VISIBLE = 1					

			

		END IF	
		
		IF LS_item_mid_class <> "015" THEN
			THIS.SetItem(1, "item_lrg_01_015_filler", LS_NULL)
			THIS.SetItem(1, "item_lrg_01_015_goose", LS_NULL)			
			THIS.SetItem(1, "item_lrg_01_015_skin", LS_NULL)
			THIS.SetItem(1, "item_lrg_01_015_fillpower", 0)		
			
			THIS.OBJECT.item_lrg_01_015_filler.VISIBLE = 0
			THIS.OBJECT.item_lrg_01_015_goose.VISIBLE = 0			
			THIS.OBJECT.item_lrg_01_015_skin.VISIBLE = 0
			THIS.OBJECT.item_lrg_01_015_fillpower.VISIBLE = 0					
			THIS.OBJECT.gb_2.VISIBLE = 0			
			
			THIS.OBJECT.item_lrg_01_015_filler_T.VISIBLE = 0
			THIS.OBJECT.item_lrg_01_015_goose_T.VISIBLE = 0			
			THIS.OBJECT.item_lrg_01_015_skin_T.VISIBLE = 0
			THIS.OBJECT.item_lrg_01_015_fillpower_T.VISIBLE = 0				
		ELSE 
			
			THIS.OBJECT.item_lrg_01_015_filler.VISIBLE = 1
			THIS.OBJECT.item_lrg_01_015_goose.VISIBLE = 1			
			THIS.OBJECT.item_lrg_01_015_skin.VISIBLE = 1
			THIS.OBJECT.item_lrg_01_015_fillpower.VISIBLE = 1					
			THIS.OBJECT.gb_2.VISIBLE = 1			
			
			THIS.OBJECT.item_lrg_01_015_filler_T.VISIBLE = 1
			THIS.OBJECT.item_lrg_01_015_goose_T.VISIBLE = 1		
			THIS.OBJECT.item_lrg_01_015_skin_T.VISIBLE = 1
			THIS.OBJECT.item_lrg_01_015_fillpower_T.VISIBLE = 1		
			
			
		END IF	
			
		IF LS_item_mid_class = "011" OR 	LS_item_mid_class = "012" OR LS_item_mid_class = "013" OR LS_item_mid_class = "014" OR LS_item_mid_class = "016" OR LS_item_mid_class = "017" OR 	LS_item_mid_class = "018" OR	LS_item_mid_class = "019" THEN
			idw_item_sub_class.Retrieve('81C', LS_item_mid_class)					
			ls_item_sub_class = RightA(LS_item_mid_class,2) + "X"
			THIS.SetItem(1, "item_sub_class", ls_item_sub_class)
			
		ELSEIF LS_item_mid_class = "01A" OR 	LS_item_mid_class = "01B" OR 	LS_item_mid_class = "01C" OR 	LS_item_mid_class = "01D" OR LS_item_mid_class = "01X" OR			LS_item_mid_class = "024" OR 		LS_item_mid_class = "025" OR 	LS_item_mid_class = "026"  THEN 
			
			idw_item_sub_class.Retrieve('81C', LS_item_mid_class)					
			ls_item_sub_class = RightA(LS_item_mid_class,2) + "X"
			THIS.SetItem(1, "item_sub_class", ls_item_sub_class)

		ELSEIF LS_item_mid_class = "02X" OR LS_item_mid_class = "03X" OR LS_item_mid_class = "041" OR LS_item_mid_class = "042" OR LS_item_mid_class = "043" OR LS_item_mid_class = "044" OR LS_item_mid_class = "045" OR	LS_item_mid_class = "046" THEN

			idw_item_sub_class.Retrieve('81C', LS_item_mid_class)					
			ls_item_sub_class = RightA(LS_item_mid_class,2) + "X"
			THIS.SetItem(1, "item_sub_class", ls_item_sub_class)
			
		ELSEIF LS_item_mid_class = "047" OR LS_item_mid_class = "048" OR 	LS_item_mid_class = "99X"   THEN

			idw_item_sub_class.Retrieve('81C', LS_item_mid_class)					
			ls_item_sub_class = RightA(LS_item_mid_class,2) + "X"
			THIS.SetItem(1, "item_sub_class", ls_item_sub_class)
		ELSE
			idw_item_sub_class.Retrieve('81C', LS_item_mid_class)							

		END IF	
			
//		idw_cust_fg_s.InsertRow(1)
//		idw_cust_fg_s.SetItem(1, "inter_cd", '')
//		idw_cust_fg_s.SetItem(1, "inter_nm", '')		
		
		
END CHOOSE

end event

event dw_body::itemchanged;call super::itemchanged;STRING LS_NULL


CHOOSE CASE dwo.name
	CASE "item_lrg_class" 
		This.SetItem(1, "item_mid_class", LS_NULL)
		This.SetItem(1, "item_sub_class", LS_NULL)		
	CASE "item_mid_class" 
		This.SetItem(1, "item_sub_class", LS_NULL)
END CHOOSE




end event

type st_1 from w_com020_e`st_1 within w_12043_e
integer x = 2167
end type

type dw_print from w_com020_e`dw_print within w_12043_e
end type

