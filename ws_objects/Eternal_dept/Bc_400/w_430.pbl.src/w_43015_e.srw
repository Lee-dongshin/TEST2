$PBExportHeader$w_43015_e.srw
$PBExportComments$매장실사등록
forward
global type w_43015_e from w_com010_e
end type
type dw_color from datawindow within w_43015_e
end type
type dw_size from datawindow within w_43015_e
end type
type cb_remove from commandbutton within w_43015_e
end type
end forward

global type w_43015_e from w_com010_e
integer width = 3680
integer height = 2272
string title = "매장실사재고등록"
dw_color dw_color
dw_size dw_size
cb_remove cb_remove
end type
global w_43015_e w_43015_e

type variables
DataWindowChild idw_brand,idw_color,idw_size,idw_shop_type
string is_brand, is_yymmdd, is_shop_cd,is_silsa_emp,is_file_nm, is_shop_type, IS_SIL_NO


end variables

forward prototypes
public function boolean wf_remove_data (string as_brand, string as_yymmdd, string as_sil_no)
end prototypes

public function boolean wf_remove_data (string as_brand, string as_yymmdd, string as_sil_no);long ll_cnt

	select count(*)
	into :ll_cnt
	from tb_44120_h with (nolock)
	where brand  = :as_brand
	and   yymmdd = :as_yymmdd
	and   sil_no = :as_sil_no;


if ll_cnt <= 0 then 
	return false
else 
	delete from tb_44120_h 
	where brand  = :as_brand
	and   yymmdd = :as_yymmdd
	and   sil_no = :as_sil_no;
	
	commit  USING SQLCA; 
end if

return true
end function

on w_43015_e.create
int iCurrent
call super::create
this.dw_color=create dw_color
this.dw_size=create dw_size
this.cb_remove=create cb_remove
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_color
this.Control[iCurrent+2]=this.dw_size
this.Control[iCurrent+3]=this.cb_remove
end on

on w_43015_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_color)
destroy(this.dw_size)
destroy(this.cb_remove)
end on

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "yymmdd",string(ld_datetime, "yyyymmdd"))

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.10.04                                                  */	
/* 수정일      : 2001.10.04                                                  */
/*===========================================================================*/
integer li_FileNum, li_st, li_ed
Long    ll_FileLen,  ll_FileLen2, ll_found
String  ls_data, ls_style, ls_style_chk,  ls_chno, ls_color, ls_size, ls_shop_nm, ls_empnm
decimal ldc_tag_price
int li_cnt_err

IF dw_head.AcceptText() <> 1 THEN RETURN 
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
	

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
					
				ls_data = Upper(ls_data)
				ls_style = Trim(MidA(ls_data, 34,8))
				ls_chno = Trim(MidA(ls_data, 42,1))
				ls_color = Trim(MidA(ls_data, 43,2))
				ls_size =  Trim(MidA(ls_data, 45,2))

	      	dw_head.setitem(1, "brand",   Trim(MidA(ls_style, 1,1)))
			//	dw_head.setitem(1, "shop_cd", Trim(Mid(ls_data, 14,6)))		
			//	dw_head.setitem(1, "yymmdd",  Trim(Mid(ls_data, 2,4)) + Trim(Mid(ls_data, 7,2)) + Trim(Mid(ls_data, 10,2)))				

           ll_found = dw_body.Find("style = '" + ls_style + "'  and chno = '" + ls_chno + "' and color = '" + ls_color + "' and size = '" + ls_size + "' ", &
					1, dw_body.RowCount()  )

    
           if ll_found <= 0 then 		
				dw_body.insertrow(0)
           	il_rows ++ 								
				dw_body.setitem(il_rows, "style",   Trim(MidA(ls_data, 34,8)))				
				dw_body.setitem(il_rows, "chno",    Trim(MidA(ls_data, 42,1)))						
				dw_body.setitem(il_rows, "color",   Trim(MidA(ls_data, 43,2)))								
				dw_body.setitem(il_rows, "size",    Trim(MidA(ls_data, 45,2)))										
				ls_style = Trim(MidA(ls_data, 34,8))
				gf_first_price(ls_style, ldc_tag_price)		
			//	messagebox("",string(ldc_tag_price))
		
				gf_style_chk1(ls_style, Trim(MidA(ls_data, 42,1)), Trim(MidA(ls_data, 43,2)), Trim(MidA(ls_data, 45,2)), ls_style_chk)		
				dw_body.Setitem(il_rows, "style_chk", ls_style_chk)

					if ls_style_chk <> '정상' then
						li_cnt_err ++
					end if				
				dw_body.Setitem(il_rows, "price", ldc_tag_price)
				dw_body.setitem(il_rows, "qty", dec(Trim(MidA(ls_data, 49,1))) )												
				dw_body.setitem(il_rows, "amt", ldc_tag_price * dec(Trim(MidA(ls_data, 49,1))) )		
           else				
							
				dw_body.setitem(ll_found, "qty", dw_body.getitemdecimal(ll_found , "qty") + dec(Trim(MidA(ls_data, 49,1))) )												
            dw_body.setitem(ll_found, "amt", dw_body.getitemdecimal(ll_found , "price") *  dw_body.getitemdecimal(ll_found , "qty") )		
  			 end if			
			
			dw_BODY.SetItemStatus(ll_found, "QTY", Primary!, NewModified!)
			
		END IF
			ll_FileLen = FileRead(li_FileNum, ls_data) 
		LOOP
		
		FILECLOSE(li_FileNum)
		
 		dw_body.SetSort("style_chk A")
      dw_body.Sort( )

		MEssagebox("오류확인", "총" + "" + string(il_rows) + "" + "건중 " + "" +  string(li_cnt_err) + "" + "개의 잘못된 데이터가 있습니다!" )
else
	     is_brand = dw_head.getitemstring(1, "brand")
	     is_yymmdd = dw_head.getitemstring(1, "yymmdd")
	     is_sil_no = dw_head.getitemstring(1, "sil_no")
		  
			  
			il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_sil_no )
		IF il_rows > 0 THEN
			dw_body.SetFocus()
			dw_head.setitem(1, "shop_cd",   dw_body.getitemstring(1,"shop_cd"))
			gf_shop_nm(dw_body.getitemstring(1,"shop_cd"), "S", ls_shop_nm)
			gf_emp_nm(dw_body.getitemstring(1,"empno"),  ls_empnm)
			dw_head.setitem(1, "shop_nm",   ls_shop_nm)
			dw_head.setitem(1, "shop_type", dw_body.getitemstring(1,"shop_type"))
			dw_head.setitem(1, "silsa_emp", dw_body.getitemstring(1,"empno"))
			dw_head.setitem(1, "emp_nm",    ls_empnm)			
			cb_remove.enabled = true				
			
		ELSEIF il_rows = 0 THEN
		   MessageBox("조회", "조회할 자료가 없습니다.")
		END IF

end if
	




This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                    */	
/* 작성일      : 2001.10.04                                                  */	
/* 수정일      : 2001.10.04                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

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

is_file_nm = dw_head.GetItemString(1, "file_nm") 

if LenA(is_file_nm) > 0  then 

	if IsNull(is_file_nm) or Trim(is_file_nm) = "" then 
		MessageBox(ls_title,"파일명을 입력하십시요!") 
		dw_head.SetFocus() 
		dw_head.SetColumn("file_nm") 
		return false
	end if

		is_shop_type = dw_head.GetItemString(1, "shop_type") 
	if IsNull(is_shop_type) or Trim(is_shop_type) = "" then 
		MessageBox(ls_title,"매장형태를 입력하십시요!") 
		dw_head.SetFocus() 
		dw_head.SetColumn("shop_type") 
		return false
	end if
	
		is_shop_cd = dw_head.GetItemString(1, "shop_cd") 
	if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then 
		MessageBox(ls_title,"실사매장을 입력하십시요!") 
		dw_head.SetFocus() 
		dw_head.SetColumn("shop_cd") 
		return false
	end if
	
		is_silsa_emp = dw_head.GetItemString(1, "silsa_emp") 
		if IsNull(is_silsa_emp) or Trim(is_silsa_emp) = "" then 
		MessageBox(ls_title,"실사담당을 입력하십시요!") 
		dw_head.SetFocus() 
		dw_head.SetColumn("silsa_emp") 
		return false
	end if
	
	is_yymmdd = dw_head.GetItemString(1, "yymmdd") 
	if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then 
		MessageBox(ls_title,"실사일자를 입력하십시요!") 
		dw_head.SetFocus() 
		dw_head.SetColumn("yymmdd") 
		return false
	end if
	
		is_brand = dw_head.GetItemString(1, "brand") 
	if IsNull(is_brand) or Trim(is_brand) = "" then 
		MessageBox(ls_title,"브랜드를 입력하십시요!") 
		dw_head.SetFocus() 
		dw_head.SetColumn("brand") 
		return false
	end if
	
else
	is_brand = dw_head.GetItemString(1, "brand") 
	if IsNull(is_brand) or Trim(is_brand) = "" then 
		MessageBox(ls_title,"브랜드를 입력하십시요!") 
		dw_head.SetFocus() 
		dw_head.SetColumn("brand") 
		return false
	end if
	

	
	is_yymmdd = dw_head.GetItemString(1, "yymmdd") 
	if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then 
		MessageBox(ls_title,"실사일자를 입력하십시요!") 
		dw_head.SetFocus() 
		dw_head.SetColumn("yymmdd") 
		return false
	end if
	
	is_sil_no = dw_head.GetItemString(1, "sil_no") 
	


end if	
return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm , ls_emp_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
				gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(SHOP_CD LIKE '" + as_data + "%'   or  SHOP_snm LIKE '%" + as_data + "%') "
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("yymmdd")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
			
	CASE "silsa_emp"				
			IF ai_div = 1 THEN 	
				IF gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
				   dw_head.SetItem(al_row, "emp_nm", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원 정보 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			gst_cd.default_where   = "WHERE goout_gubn = '1' and substring(dept_code,2,1) <> 'A' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(empno LIKE '" + as_data + "%'   or  kname LIKE '%" + as_data + "%') "
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "silsa_emp", lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "emp_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source			

	CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				// 스타일 선별작업
				IF  gl_user_level = 0 then 
					gst_cd.default_where   = "WHERE   style like '" + gs_brand + "%'"	
				else 	
					gst_cd.default_where   = " WHERE  brand <> 'T' and tag_price <> 0 "
				end if
				
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
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
            
				   messagebox("",lds_Source.GetItemString(1,"style")) 
				
					dw_body.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_body.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
					
					if LenA(lds_Source.GetItemString(1,"style")) <> 8 then
					/* 다음컬럼으로 이동 */
					dw_body.SetColumn("style")
					else
					dw_body.SetColumn("chno")
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

event pfc_preopen;call super::pfc_preopen;dw_size.SetTransObject(SQLCA)
dw_color.SetTransObject(SQLCA)
end event

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, li_cnt_err
datetime ld_datetime
string	ls_style_chk, ls_style , ls_year, ls_season , ls_item, ls_sojae, LS_SIL_NO



ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

   IF LenA(is_sil_no) <> 4 then
		select  substring(convert(varchar(5), convert(decimal(5), isnull(max(SIL_no), '0000')) + 10001), 2, 4) 
		into :ls_sil_no
		from tb_44120_h with (nolock)
		where  yymmdd = :is_yymmdd;
   else
		ls_sil_no = is_sil_no
	end if	

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */

      ls_style = dw_body.getitemstring(i, "style")
		
			select year, season,item, sojae 
			into :ls_year, :ls_season, :ls_item, :ls_sojae
			from tb_12020_m
			where style = :ls_style;


		dw_body.setitem(i, "sil_no" , ls_sil_no)
      dw_body.Setitem(i, "no"     , i)
		dw_body.setitem(i, "year"   , ls_year)
		dw_body.setitem(i, "season" , ls_season)			
		dw_body.setitem(i, "item"   , ls_item)			
		dw_body.setitem(i, "sojae"  , ls_sojae)					
	   DW_BODY.SETITEM(I, "brand"     , is_brand)
	   DW_BODY.SETITEM(I, "shop_cd"   , is_shop_cd)
	   DW_BODY.SETITEM(I, "shop_type" , is_shop_type)
	   DW_BODY.SETITEM(I, "empno"     , is_silsa_emp)
	   DW_BODY.SETITEM(I, "yymmdd"    , is_yymmdd)		
      dw_body.Setitem(i, "reg_id"    , gs_user_id)
   ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
		ls_style_chk = dw_body.getitemstring(i, "style_chk")
		if ls_style_chk <> '정상' then
						li_cnt_err ++
		end if	
NEXT


if li_cnt_err = 0 then 
		il_rows = dw_body.Update(TRUE, FALSE)
		if il_rows = 1 then
			dw_body.ResetUpdate()
			commit  USING SQLCA;
			dw_head.setitem(1, "sil_no", ls_sil_no)
		else
			rollback  USING SQLCA;
		end if

else 
	MEssagebox("오류확인", "총" + "" + string(ll_row_count) + "" + "건중 " + "" +  string(li_cnt_err) + "" + "개의 잘못된 데이터가 있습니다!" )
end if	

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_dberror;call super::pfc_dberror;//
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43015_e","0")
end event

type cb_close from w_com010_e`cb_close within w_43015_e
end type

type cb_delete from w_com010_e`cb_delete within w_43015_e
end type

type cb_insert from w_com010_e`cb_insert within w_43015_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_43015_e
end type

event cb_retrieve::clicked;call super::clicked;//IF dw_head.Enabled THEN
////	Parent.Trigger Event ue_retrieve()	//조회
//ELSE
//dw_head.reset()
//dw_head.insertrow(0)
//	
//datetime ld_datetime
//
//
//IF gf_sysdate(ld_datetime) = FALSE THEN
//	ld_datetime = DateTime(Today(), Now())
//END IF
//
//dw_head.SetItem(1, "yymmdd",string(ld_datetime, "yyyymmdd"))
//dw_head.setitem(1, "brand", "N")
//
//	
//END IF
end event

type cb_update from w_com010_e`cb_update within w_43015_e
end type

type cb_print from w_com010_e`cb_print within w_43015_e
end type

type cb_preview from w_com010_e`cb_preview within w_43015_e
end type

type gb_button from w_com010_e`gb_button within w_43015_e
end type

type cb_excel from w_com010_e`cb_excel within w_43015_e
end type

type dw_head from w_com010_e`dw_head within w_43015_e
integer x = 32
integer y = 160
integer height = 292
string dataobject = "d_43015_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')

 
// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if
end event

event dw_head::buttonclicking;call super::buttonclicking;/* 화일 탐색 */
string  ls_path, ls_file_nm
integer li_value

li_value = GetFileOpenName("Select File", ls_path, ls_file_nm, "DAT", "Dat Files (*.Dat),*.dat")

IF li_value = 1 THEN 
	dw_head.Setitem(1, "file_nm", ls_path)
	cb_retrieve.PostEvent(Clicked!)
END IF
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"      // dddw로 작성된 항목

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
   CASE "silsa_emp"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
			
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_43015_e
integer beginy = 468
integer endy = 468
end type

type ln_2 from w_com010_e`ln_2 within w_43015_e
integer beginy = 472
integer endy = 472
end type

type dw_body from w_com010_e`dw_body within w_43015_e
integer x = 9
integer y = 484
integer width = 3584
integer height = 1552
string dataobject = "d_43015_D01"
boolean controlmenu = true
boolean hscrollbar = true
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)

This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


  This.GetChild("color", idw_color )
  idw_color.SetTransObject(SQLCA)
  
  This.GetChild("size", idw_size )
  idw_color.SetTransObject(SQLCA)
end event

event dw_body::itemchanged;call super::itemchanged;//	gf_style_chk1(ls_style, Trim(Mid(ls_data, 42,1)), Trim(Mid(ls_data, 43,2)), Trim(Mid(ls_data, 45,2)), ls_style_chk)		
//	dw_body.Setitem(il_rows, "style_chk", ls_style_chk)
string ls_style, ls_chno, ls_color, ls_size
decimal ldc_qty, ldc_amt

CHOOSE CASE dwo.name
	CASE "style" 
		IF ib_itemchanged THEN RETURN 1
   	return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
     	dw_body.Setitem(row, "amt", dw_body.getitemdecimal(row, "price") * dw_body.getitemdecimal(row, "qty"))
	CASE "qty"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		
     	dw_body.Setitem(row, "amt", dw_body.getitemdecimal(row, "price") * dec(data))



END CHOOSE

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;string DWfilter, ls_style, ls_chno, ls_color,ls_year,ls_season, ls_item, ls_sojae, ls_type,ls_style_chk, ls_size
long     i, j, ll_row_count, ll_row
decimal ldc_tag_price

ls_style = dw_body.getitemstring(row, "style")
ls_chno = dw_body.getitemstring(row, "chno")
ls_color = dw_body.getitemstring(row, "color")
ls_size = dw_body.getitemstring(row, "size")


CHOOSE CASE dwo.name

		
	
	case "chno"	
		ls_style = dw_body.getitemstring(row, "style")		
				
	

//   		gf_style_chk1(ls_style, Trim(Mid(ls_data, 42,1)), Trim(Mid(ls_data, 43,2)), Trim(Mid(ls_data, 45,2)), ls_style_chk)		
//			dw_body.Setitem(il_rows, "style_chk", ls_style_chk)
		gf_first_price(ls_style, ldc_tag_price)		
		dw_body.Setitem(row, "price", ldc_tag_price)
   	dw_body.Setitem(row, "amt", ldc_tag_price * dw_body.getitemdecimal(row, "qty"))


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
	


END CHOOSE

gf_style_chk1(ls_style, ls_chno, ls_color, ls_size, ls_style_chk)		
dw_body.Setitem(row, "style_chk", ls_style_chk)


end event

type dw_print from w_com010_e`dw_print within w_43015_e
integer x = 2510
integer y = 1464
end type

type dw_color from datawindow within w_43015_e
boolean visible = false
integer x = 2752
integer y = 948
integer width = 366
integer height = 428
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_43015_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_size from datawindow within w_43015_e
boolean visible = false
integer x = 3141
integer y = 944
integer width = 411
integer height = 432
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_43015_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_remove from commandbutton within w_43015_e
integer x = 375
integer y = 44
integer width = 347
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "실사삭제(&R)"
end type

event clicked;long ll_rtrn
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF


ll_rtrn = messagebox("경고!", "삭제시 복구할 수 없습니다. 작업을진행 하시겠습니까?",Question!,OKCancel! )

if ll_rtrn = 1 then 

	if wf_remove_data(is_brand, is_yymmdd, is_sil_no) = true then
		il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_sil_no )
		if il_rows <= 0  then 
			messagebox("알림!", "삭제 되었습니다!")
			dw_body.reset()
			dw_head.reset()
			dw_head.insertrow(0)
			dw_head.SetItem(1, "yymmdd",string(ld_datetime, "yyyymmdd"))
			dw_head.setitem(1, "brand", "N")
			cb_remove.enabled = false
		end if
	else
		messagebox("알림!", "작업이 실패했습니다!")
	end if
	
else	
		messagebox("알림!", "취소되었습니다.!")
end if		
		
			
end event

