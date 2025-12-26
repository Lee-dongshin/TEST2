$PBExportHeader$w_42050_e.srw
$PBExportComments$완불배분데이터
forward
global type w_42050_e from w_com010_e
end type
end forward

global type w_42050_e from w_com010_e
integer width = 3675
integer height = 2276
end type
global w_42050_e w_42050_e

type variables
String 	is_brand, is_yymmdd
int		ii_deal_seq
DataWindowChild	idw_brand, idw_color, idw_size
end variables

forward prototypes
public function boolean wf_style_chk (long al_row, string as_style_no)
end prototypes

public function boolean wf_style_chk (long al_row, string as_style_no);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.05.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_null, ls_shop_type, ls_shop_cd
String ls_brand, ls_year, ls_season, ls_sojae, ls_item, ls_plan_yn , ls_brand2
String ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
Long   ll_tag_price,  ll_cnt 
SetNull(ls_null)

ls_brand2 = dw_head.getitemstring(1, "brand")
ls_shop_cd = dw_body.getitemstring(al_row, "shop_cd")
IF al_row > 1 and LenA(as_style_no) <> 9 THEN
   Return False 
ELSE 
	ls_style = LeftA(as_style_no, 8)
	ls_chno  = MidA(as_style_no, 9, 1)
	
END IF 


IF ii_deal_seq = 98 then
	ls_plan_yn = 'Y'
ELSE
	ls_plan_yn = '%'
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
//	and plan_yn like :ls_plan_yn
	and brand   = 	  :ls_brand2
	and isnull(tag_price, 0) <> 0;
	
IF SQLCA.SQLCODE <> 0 or ll_cnt <> 1 THEN 
	Return False 
END IF 

//if mid(ls_style,2,1) = "C" then
//	messagebox("경고!", "이 제품은 중국수출만 가능한 제품입니다!")
//	return false
//end if 	
				
				
if ii_deal_seq = 99 and LenA(ls_style) = 8 then
		Select shop_type
		into :ls_shop_type
		From tb_56012_d with (nolock)
		Where style      = :ls_style 
		  and start_ymd <= :is_yymmdd
		  and end_ymd   >= :is_yymmdd
		  and shop_cd    = :ls_shop_cd ;
		
		if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" or ls_shop_type = "1" then		
			messagebox("경고!", "제품판매가 가능한 매장형태는 행사 제품이 아닙니다!")
			return false
		end if	 
end if
				
				
				
select isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX'),
		 isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
into :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq, :ls_given_fg, :ls_given_ymd
from tb_12020_m with (nolock)
where style = :ls_style;



if ls_given_fg = "Y"  and ls_given_ymd <= is_yymmdd then 
	messagebox("품번체크", ls_given_ymd + "일자로 사은품 전환된 제품입니다!")
	return false
end if 	


  dw_body.SetItem(al_row, "style_no", ls_style + ls_chno)
  dw_body.SetItem(al_row, "style",    ls_style)
  dw_body.SetItem(al_row, "chno",     ls_chno)


Return True

end function

on w_42050_e.create
call super::create
end on

on w_42050_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq, ls_given_fg, ls_given_ymd
String 	  ls_plan_yn, ls_SHOP_TYPE, ls_shop_cd
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_body.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm3(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_body.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV  IN ('G', 'K', 'X') " + &
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
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_body.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("shop_type")
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

				select isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX'), plan_yn
				into  :ls_given_fg, :ls_given_ymd, :ls_plan_yn
				from tb_12020_m with (nolock)
				where style = :ls_style;
					
				IF ls_given_fg = "Y"  AND  ls_given_ymd >= is_yymmdd  THEN
					messagebox("품번검색", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				END IF 					
				
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

			ls_shop_cd = dw_body.getitemstring(al_row, "shop_cd")

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
				dw_body.SetItem(al_row, "tag_price", lds_Source.GetItemNumber(1,"tag_price")) 
				ls_style = lds_Source.GetItemString(1,"style")
				
				select isnull(dep_fg, 'N'), isnull(dep_ymd, 'XXXXXXXX'), isnull(dep_seq, 'XX'),isnull(given_fg, 'N'), isnull(given_ymd, 'XXXXXXXX')
				into :ls_bujin_chk, :ls_dep_ymd, :ls_dep_seq, :ls_given_fg, :ls_given_ymd
				from tb_12020_m with (nolock)
				where style = :ls_style;
				
//				if mid(ls_style,2,1) = "C" then
//					messagebox("경고!", "이 제품은 중국수출만 가능한 제품입니다!")
//					//								dw_body.SetItem(al_row, "style_no", "")
//					ib_itemchanged = FALSE
//					return 1 	
//            end if 	

				if ii_deal_seq = 99 then			
					
						Select shop_type
						into :ls_shop_type
						From tb_56012_d with (nolock)
						Where style      = :ls_style 
						  and start_ymd <= :is_yymmdd
						  and end_ymd   >= :is_yymmdd
						  and shop_cd    = :ls_shop_cd ;
						  
						if IsNull(ls_shop_type) or Trim(ls_shop_type) = "" or Trim(ls_shop_type) = "1"  then		
							messagebox("경고!", "행사제품으로 등록되어 있지 않습니다!")
							ib_itemchanged = FALSE
							return 1
						end if	 

						
				end if

				
				if ls_bujin_chk = "Y" then 
					messagebox("부진체크", ls_dep_ymd + "-" + ls_dep_seq + "차로 부진처리된 제품입니다!")
            end if 	
				
				IF ls_given_fg = "Y"  AND ls_given_ymd <= is_yymmdd THEN 
					messagebox("품번검색", ls_given_ymd + "일자로 사은품으로 전환된 제품입니다!")					
					dw_body.SetItem(al_row, "style_no", "")
					ib_itemchanged = FALSE
					return 1 	
				END IF 
				
 				   dw_body.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style") + lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "style",    lds_Source.GetItemString(1,"style"))
				   dw_body.SetItem(al_row, "chno",     lds_Source.GetItemString(1,"chno"))
				   dw_body.SetItem(al_row, "color",    lds_Source.GetItemString(1,"color"))
				   dw_body.SetItem(al_row, "size",     lds_Source.GetItemString(1,"size"))					
				   ib_changed = true
               cb_update.enabled = true
				   /* 다음컬럼으로 이동 */
		         dw_body.SetColumn("color")
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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

ii_deal_seq = dw_head.GetItemNumber(1, "deal_seq")
if IsNull(ii_deal_seq) or ii_deal_seq < 0 then
   MessageBox(ls_title,"배분번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_seq")
   return false
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymmdd, ii_deal_seq, is_brand )
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
long i, ll_row_count, ll_resv_qty, ll_deal_qty
datetime ld_datetime
string ls_style, ls_chno, ls_color, ls_size, ls_shop_div, ls_ErrMsg, ls_shop_cd

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status  = dw_body.GetItemStatus(i, 0, Primary!)
	ls_style    = dw_body.getitemstring(i, "style")
	ls_chno     = dw_body.getitemstring(i, "chno")
	ls_color    = dw_body.getitemstring(i, "color")
	ls_size     = dw_body.getitemstring(i, "size")	
	ls_shop_cd  = dw_body.getitemstring(i, "shop_cd")	
	ls_shop_div = MidA(ls_shop_cd,2,1)
	ll_deal_qty = dw_body.getitemnumber(i, "deal_qty")	
	
//out_ymd,deal_seq,style,chno,color,size,deal_fg,
//shop_cd,deal_qty,out_qty,proc_yn,yymmdd,out_no
//work_no,dps_yn,reg_id,reg_dt,mod_id,mod_dt,rshop_cd
	
	
   IF idw_status = NewModified! THEN				/* New Record */
	
		ll_resv_qty = dw_body.GetitemNumber(i, "deal_qty", Primary!, True)
	
      dw_body.Setitem(i, "out_ymd", is_yymmdd)
      dw_body.Setitem(i, "deal_seq", ii_deal_seq)
      dw_body.Setitem(i, "deal_fg", "3")
      dw_body.Setitem(i, "reg_id", gs_user_id)		
      dw_body.Setitem(i, "reg_dt", ld_datetime)
		
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		
		ll_resv_qty = dw_body.GetitemNumber(i, "deal_qty", Primary!, True)
		
		IF isnull(ll_resv_qty) THEN 
			ll_resv_qty = ll_deal_qty 
		ELSE
			ll_resv_qty = ll_deal_qty - ll_resv_qty 
		END IF
		
		
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
	
	gf_reserve_reset (ls_ErrMsg)	
//   IF gf_stresv_update (ls_style,    ls_chno,     ls_color,   ls_size, &
//								ls_shop_div, ll_resv_qty, ls_ErrMsg) = FALSE THEN 
//			il_rows = -1
//			EXIT
//		END IF
	
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42050_e","0")
end event

type cb_close from w_com010_e`cb_close within w_42050_e
end type

type cb_delete from w_com010_e`cb_delete within w_42050_e
end type

type cb_insert from w_com010_e`cb_insert within w_42050_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_42050_e
end type

type cb_update from w_com010_e`cb_update within w_42050_e
end type

type cb_print from w_com010_e`cb_print within w_42050_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_42050_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_42050_e
end type

type cb_excel from w_com010_e`cb_excel within w_42050_e
end type

type dw_head from w_com010_e`dw_head within w_42050_e
integer width = 3255
integer height = 128
string dataobject = "d_42050_h01"
end type

event dw_head::constructor;call super::constructor;
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

type ln_1 from w_com010_e`ln_1 within w_42050_e
integer beginy = 308
integer endy = 308
end type

type ln_2 from w_com010_e`ln_2 within w_42050_e
integer beginy = 312
integer endy = 312
end type

type dw_body from w_com010_e`dw_body within w_42050_e
event ue_set_col ( string as_column )
integer y = 324
integer height = 1716
string dataobject = "d_42050_d01"
end type

event dw_body::ue_set_col(string as_column);This.SetColumn(as_column)
end event

event dw_body::constructor;call super::constructor;
This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.insertRow(0)

This.GetChild("size", idw_size)
idw_size.SetTransObject(SQLCA)
idw_size.insertRow(0)


end event

event dw_body::itemchanged;call super::itemchanged;String ls_yymmdd, ls_null
long ll_ret

CHOOSE CASE dwo.name
	CASE "yymmdd"      
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
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

type dw_print from w_com010_e`dw_print within w_42050_e
end type

