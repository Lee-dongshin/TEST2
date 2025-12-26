$PBExportHeader$w_51020_e.srw
$PBExportComments$매장비용등록
forward
global type w_51020_e from w_com020_e
end type
end forward

global type w_51020_e from w_com020_e
end type
global w_51020_e w_51020_e

type variables
string is_brand, is_yymm, is_cost_fg, is_file_nm
datawindowchild idw_brand, idw_cost_fg
end variables

forward prototypes
public subroutine wf_getfile ()
end prototypes

public subroutine wf_getfile ();/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.10.04                                                  */	
/* 수정일      : 2001.10.04                                                  */
/*===========================================================================*/
integer li_FileNum, li_find, li_t
string  ls_data, ls_brand, ls_yymm, ls_shop_cd, ls_shop_nm, ls_cost_fg
long    ll_cost_amt, ll_cost, li_cnt_err

Long    ll_FileLen,  ll_FileLen2, ll_found


//IF dw_head.AcceptText() <> 1 THEN RETURN 
//IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//	

/* dw_head 필수입력 column check */
is_file_nm = dw_head.GetItemString(1, "file_nm") 

if LenA(is_file_nm) > 3 then
  
		li_FileNum = FileOpen(is_file_nm, LineMode!, Read!) 
		IF li_FileNum < 0 THEN
			MessageBox("오류", "해당 화일 열기 실패했습니다.") 
			RETURN
		END IF 
		
		dw_body.Reset()
		il_rows = 0 
		ll_FileLen = FileRead(li_FileNum, ls_data) 
	
		DO WHILE  ll_FileLen >= 0
		
			IF ll_FileLen > 5 THEN 
				li_t ++
				ls_data = Upper(ls_data)	
								
				li_find = PosA(ls_data,",")
				ls_yymm = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,30)
				
				li_find = PosA(ls_data,",")				
				ls_cost_fg  = RightA(Trim('00'+MidA(ls_data, 1,li_find - 1)),2)				
				ls_data =MidA(ls_data,li_find+1,30)
				
				li_find = PosA(ls_data,",")				
				ls_shop_cd  = Trim(MidA(ls_data, 1,li_find - 1))
				ls_data =MidA(ls_data,li_find+1,30)				

				ll_cost_amt =  long(Trim(MidA(ls_data, 1,12)))
				
				ls_brand = LeftA(ls_shop_cd,1)
				
			
//				
//					messagebox("",ls_yymm)				
//					messagebox("",ls_cost_fg)						
//					messagebox("",ls_shop_cd)												
//					messagebox("",ll_cost_amt)				


	      	dw_head.setitem(1, "brand", ls_brand)
				dw_head.setitem(1, "yymm",  ls_yymm)				

           	ll_found = dw_body.Find("yymm = '" + ls_yymm + "'  and cost_fg = '" + ls_cost_fg + "' and shop_cd = '" + ls_shop_cd + "'  ", &
					1, dw_body.RowCount()  )

				
				if ll_found <= 0 then 		
					dw_body.insertrow(0)
					il_rows ++ 								
					dw_body.setitem(il_rows, "brand", ls_brand)				
					dw_body.setitem(il_rows, "yymm", ls_yymm)				
					dw_body.setitem(il_rows, "cost_fg", ls_cost_fg)						
					dw_body.setitem(il_rows, "shop_cd", ls_shop_cd)
					select dbo.sf_cust_nm(:ls_shop_cd,'s') into :ls_shop_nm from dual;
					dw_body.setitem(il_rows, "shop_nm", ls_shop_nm)
					dw_body.setitem(il_rows, "cost_amt", ll_cost_amt)
					
				else
					ll_cost = dw_body.getitemNumber(ll_found,"cost_amt")
					ll_cost = ll_cost + ll_cost_amt
					dw_body.setitem(ll_found,"cost_amt",ll_cost)
					
				   idw_status = dw_body.GetItemStatus(ll_found, 0, Primary!)
				   IF idw_status = NewModified! THEN				/* New Record */
					else
						dw_body.SetItemStatus(ll_found, "cost_amt", Primary!, DataModified!)
					end if
				end if			
//			
//				dw_body.SetItemStatus(ll_found, "cost_amt", Primary!, NewModified!)
//			

			END IF			
			ll_FileLen = FileRead(li_FileNum, ls_data) 
		LOOP
				
		FILECLOSE(li_FileNum)
//		
// 		dw_body.SetSort("style_chk A")
//      dw_body.Sort( )
		if li_t > 0 then 
			ib_changed = true
			cb_update.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
		end if

//		MEssagebox("오류확인", "총" + "" + string(il_rows) + "" + "건중 " + "" +  string(li_cnt_err) + "" + "개의 잘못된 데이터가 있습니다!" )

end if

end subroutine

on w_51020_e.create
call super::create
end on

on w_51020_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if
return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_yymm)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
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
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
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

event ue_insert();call super::ue_insert;dw_body.setitem(il_rows,"brand", is_brand)
dw_body.setitem(il_rows,"yymm", is_yymm)
dw_body.setitem(il_rows,"cost_fg", is_cost_fg)
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_cd, ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			if LenA(as_data) = 6 then 
				select shop_snm 
				into :ls_shop_nm
				from tb_91100_m (nolock) where shop_cd = :as_data;
				dw_body.setitem(al_row, "shop_nm",ls_shop_nm)
				if ls_shop_nm <> "" then
					return 0
				end if
			end if
			
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 				
			END IF
			
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' and brand = '"+is_brand+"'"
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
				dw_body.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
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

type cb_close from w_com020_e`cb_close within w_51020_e
end type

type cb_delete from w_com020_e`cb_delete within w_51020_e
end type

type cb_insert from w_com020_e`cb_insert within w_51020_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_51020_e
end type

type cb_update from w_com020_e`cb_update within w_51020_e
end type

type cb_print from w_com020_e`cb_print within w_51020_e
end type

type cb_preview from w_com020_e`cb_preview within w_51020_e
end type

type gb_button from w_com020_e`gb_button within w_51020_e
end type

type cb_excel from w_com020_e`cb_excel within w_51020_e
end type

type dw_head from w_com020_e`dw_head within w_51020_e
integer height = 148
string dataobject = "d_51020_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')



end event

event dw_head::buttonclicking;call super::buttonclicking;/* 화일 탐색 */
string  ls_path, ls_file_nm
integer li_value

li_value = GetFileOpenName("Select File", ls_path, ls_file_nm, "CSV", "Csv Files (*.csv),*.csv")

IF li_value = 1 THEN 
	dw_head.Setitem(1, "file_nm", ls_path)	
	wf_getfile()	
END IF

parent.Trigger Event ue_button(1, li_value)
parent.Trigger Event ue_msg(1, li_value)
end event

type ln_1 from w_com020_e`ln_1 within w_51020_e
integer beginy = 332
integer endy = 332
end type

type ln_2 from w_com020_e`ln_2 within w_51020_e
integer beginy = 336
integer endy = 336
end type

type dw_list from w_com020_e`dw_list within w_51020_e
integer y = 360
integer width = 905
integer height = 1680
string dataobject = "d_51020_l01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

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

is_cost_fg = This.GetItemString(row, 'inter_cd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_cost_fg) THEN return
il_rows = dw_body.retrieve(is_brand, is_yymm, is_cost_fg)
if il_rows = 0 then 
	Parent.post Event ue_insert()
end if

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)


end event

type dw_body from w_com020_e`dw_body within w_51020_e
integer x = 960
integer y = 360
integer width = 2642
integer height = 1680
string dataobject = "d_51020_d01"
end type

event dw_body::constructor;call super::constructor;This.GetChild("cost_fg", idw_cost_fg)
idw_cost_fg.SetTransObject(SQLCA)
idw_cost_fg.Retrieve('029')
end event

event dw_body::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
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

type st_1 from w_com020_e`st_1 within w_51020_e
integer x = 942
integer y = 360
integer height = 1680
end type

type dw_print from w_com020_e`dw_print within w_51020_e
integer x = 37
integer y = 720
end type

