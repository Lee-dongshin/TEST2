$PBExportHeader$w_42018_e.srw
$PBExportComments$BOX출고관리
forward
global type w_42018_e from w_com010_e
end type
type cb_new from cb_retrieve within w_42018_e
end type
type dw_1 from datawindow within w_42018_e
end type
end forward

global type w_42018_e from w_com010_e
integer width = 3680
integer height = 2228
string title = "BOX 출고 관리"
cb_new cb_new
dw_1 dw_1
end type
global w_42018_e w_42018_e

type variables
DataWindowChild idw_brand, idw_othr_brand, idw_out_no

String is_brand,   is_out_no, is_out_date

end variables

on w_42018_e.create
int iCurrent
call super::create
this.cb_new=create cb_new
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_new
this.Control[iCurrent+2]=this.dw_1
end on

on w_42018_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_new)
destroy(this.dw_1)
end on

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "out_date",ld_datetime)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_body.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE   shop_cd like '" + gs_brand + "%' and Shop_Stat = '00'" 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
				dw_body.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_body.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("end_ymd")
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

event ue_update;/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      : 2001.12.06                                                  */	
/* 수정일      :                                                 */
/*===========================================================================*/
long     i, j, ll_row_count, ll_row
datetime ld_datetime
String   ls_col_nm, ls_find, ls_Shop_cd, ls_gubn, ls_shop_type, ls_no
String   ls_Type[] = {'NA', 'NB', 'ND','NE', 'SA', 'SC', 'EA', 'EC'}
Decimal  ldc_Rate


ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

is_out_date = string(dw_head.getitemdatetime(1, "out_date"),"yyyymmdd")
is_out_no = dw_head.getitemstring(1, "out_no")
is_brand = dw_head.getitemstring(1, "brand")

if isNull(is_out_no) or is_out_no = " " then
		select  substring(convert(varchar(5), convert(decimal(5), isnull(max(out_no), '0000')) + 10001), 2, 4) 
		into :is_out_no
		from tb_42040_h
		where brand = :is_brand
		and   yymmdd = :is_out_date;
		
		dw_head.Setitem(1, "out_no",   is_out_no)	
		
end if		



/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

/* 수정된 row 체크 */
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)

   IF idw_status = DataModified! or idw_status = NewModified! THEN 
		ls_Shop_cd = dw_body.Object.shop_cd[i]
		
		/* 수정된 칼럼 체크 */
		FOR j = 1 TO 8
			ls_col_nm = Lower(ls_Type[j]) 
			IF dw_body.GetItemStatus(i, ls_col_nm, Primary!) = DataModified! THEN 
				ldc_Rate = dw_body.GetitemDecimal(i, ls_col_nm)	
				ls_Find  = "shop_cd = '" + ls_shop_cd + "' And shop_type = '" &
				           + MidA(ls_Type[j],1,1) +  "' and gubn = '" + MidA(ls_Type[j],2,1) + &
  							  "' and yymmdd = '"  + is_out_date + &
							  "' and out_no = '"  + is_out_no + "'"
				ll_row = dw_1.Find(ls_Find, 1, dw_1.RowCount()) 
			
				IF ll_row > 0 THEN 
					dw_1.Setitem(ll_row, "qty", ldc_Rate)
               dw_1.Setitem(ll_row, "mod_id",    gs_user_id)
               dw_1.Setitem(ll_row, "mod_dt",    ld_datetime)
				ELSE

					
					ll_row = dw_1.insertRow(0)
	 				dw_1.Setitem(ll_row, "yymmdd",   is_out_date)
    				dw_1.Setitem(ll_row, "out_no",   is_out_no)					 
					dw_1.Setitem(ll_row, "shop_cd",   ls_shop_cd)
					dw_1.Setitem(ll_row, "shop_type",   MidA(ls_Type[j],1,1))
					dw_1.Setitem(ll_row, "gubn", MidA(ls_Type[j],2,1))
               dw_1.Setitem(ll_row, "qty", ldc_Rate)
					dw_1.Setitem(ll_row, "brand", is_brand)
               dw_1.Setitem(ll_row, "reg_id",    gs_user_id)
				END IF
			END IF
		NEXT
	END IF
NEXT

il_rows = dw_1.Update()

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

event pfc_preopen;call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
//dw_2.SetTransObject(SQLCA)
end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


is_out_date = string(dw_head.getitemdatetime(1, "out_date"),"yyyymmdd")
is_out_no = dw_head.getitemstring(1, "out_no")
is_brand = dw_head.getitemstring(1, "brand")



il_rows = dw_body.retrieve(is_brand,is_out_date, is_out_no)

dw_1.retrieve(is_brand,is_out_date, is_out_no)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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

return true
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42018_e","0")
end event

type cb_close from w_com010_e`cb_close within w_42018_e
integer taborder = 110
end type

type cb_delete from w_com010_e`cb_delete within w_42018_e
integer taborder = 60
end type

type cb_insert from w_com010_e`cb_insert within w_42018_e
integer taborder = 50
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_42018_e
end type

type cb_update from w_com010_e`cb_update within w_42018_e
integer taborder = 100
end type

type cb_print from w_com010_e`cb_print within w_42018_e
integer taborder = 70
end type

type cb_preview from w_com010_e`cb_preview within w_42018_e
integer taborder = 80
end type

type gb_button from w_com010_e`gb_button within w_42018_e
end type

type cb_excel from w_com010_e`cb_excel within w_42018_e
integer taborder = 90
end type

type dw_head from w_com010_e`dw_head within w_42018_e
integer x = 590
integer y = 176
integer width = 2592
integer height = 96
string dataobject = "d_42018_h01"
end type

event dw_head::constructor;datetime ld_datetime

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      :                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
//string ls_out_no
//
//CHOOSE CASE dwo.name
//	CASE "brand"	     //  전표최종번호		
//     is_brand = data 
//	CASE "out_date"	     //  전표최종번호
//		is_out_date = string(data)
//		
//END CHOOSE
// 
end event

event dw_head::itemfocuschanged;DataWindowChild  ldw_out_no

is_brand = dw_head.getitemstring(1, "brand")	
is_out_date = string(dw_head.getitemdatetime(1, "out_date")	,"yyyymmdd")

choose case dwo.name
	case "out_no"		
		
//		select  substring(convert(varchar(5), convert(decimal(5), isnull(max(out_no), '0000')) + 10001), 2, 4) 
//		into :is_out_no
//		from tb_42040_h
//		where brand = :is_brand
//		and   yymmdd = :is_out_date;

This.GetChild("out_no", ldw_out_no)
ldw_out_no.SetTransObject(SQLCA)
ldw_out_no.Retrieve(is_brand, is_out_date)


//		dw_head.SetItem(1, "out_no", is_out_no)
end choose		
		
end event

type ln_1 from w_com010_e`ln_1 within w_42018_e
integer beginy = 284
integer endy = 284
end type

type ln_2 from w_com010_e`ln_2 within w_42018_e
integer beginy = 288
integer endy = 288
end type

type dw_body from w_com010_e`dw_body within w_42018_e
integer x = 14
integer y = 308
integer width = 3584
integer height = 1688
integer taborder = 40
string dataobject = "d_42018_d01"
end type

event dw_body::itemchanged;
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "colunm1" 
    IF data = 'A' THEN
	      /*action*/
    END IF
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_42018_e
integer x = 2491
integer y = 920
end type

type cb_new from cb_retrieve within w_42018_e
integer x = 379
integer taborder = 100
boolean bringtotop = true
string text = "신규(&N)"
end type

event clicked;call super::clicked;datetime ld_datetime

dw_head.reset()
dw_head.insertrow(0)

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "out_date",ld_datetime)
dw_head.SetItem(1, "brand","N")

dw_body.reset()
end event

type dw_1 from datawindow within w_42018_e
boolean visible = false
integer x = 46
integer y = 712
integer width = 3538
integer height = 620
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_42018_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

