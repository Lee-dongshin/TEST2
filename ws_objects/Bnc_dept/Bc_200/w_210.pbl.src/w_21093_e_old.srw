$PBExportHeader$w_21093_e_old.srw
$PBExportComments$케어라벨입력
forward
global type w_21093_e_old from w_com010_e
end type
type dw_2 from datawindow within w_21093_e_old
end type
type dw_list from datawindow within w_21093_e_old
end type
type dw_1 from datawindow within w_21093_e_old
end type
end forward

global type w_21093_e_old from w_com010_e
dw_2 dw_2
dw_list dw_list
dw_1 dw_1
end type
global w_21093_e_old w_21093_e_old

type variables
string  is_style_no, is_style, is_chno, is_color, is_p_no1, is_p_no2, is_p_no3, is_p_no4  , is_washing1, is_washing2, is_washing3, is_washing4
string  is_brand, is_year, is_season, is_sojae, is_item, is_country_cd
datawindowchild idw_color, idw_color1, idw_brand, idw_season, idw_sojae, idw_item
end variables

on w_21093_e_old.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_list=create dw_list
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.dw_1
end on

on w_21093_e_old.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.dw_list)
destroy(this.dw_1)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;///*===========================================================================*/
///* 작성자      : 김 태범                                                     */	
///* 작성일      : 2001.12.12                                                  */	
///* 수정일      : 2002.01.08                                                  */
///*===========================================================================*/
//String     ls_style, ls_chno
//Boolean    lb_check 
//DataStore  lds_Source
//
//CHOOSE CASE as_column
//	CASE "style_no"				
//		   ls_style = Mid(as_data, 1, 8)
//			ls_chno  = Mid(as_data, 9, 1)
//			IF ai_div = 1 THEN 	
//				IF gf_style_chk(ls_style, ls_chno) THEN
//					RETURN 0
//				END IF 
//			END IF
//		   gst_cd.ai_div          = ai_div
//			gst_cd.window_title    = "품번 코드 검색" 
//			gst_cd.datawindow_nm   = "d_com010" 
//			gst_cd.default_where   = ""
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"
//			ELSE
//				gst_cd.Item_where = ""
//			END IF
//
//			lds_Source = Create DataStore
//			OpenWithParm(W_COM200, lds_Source)
//
//			IF Isvalid(Message.PowerObjectParm) THEN
//				ib_itemchanged = True
//				lds_Source = Message.PowerObjectParm
//				dw_head.SetRow(al_row)
//				dw_head.SetColumn(as_column)
//				dw_head.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
//				/* 다음컬럼으로 이동 */
//				cb_retrieve.SetFocus()
//				ib_itemchanged = False 
//				lb_check = TRUE 
//			ELSE
//				lb_check = FALSE 
//			END IF
//			Destroy  lds_Source
//END CHOOSE
//
//IF ai_div = 1 THEN 
//	IF lb_check THEN
//      RETURN 2 
//	ELSE
//		RETURN 1
//	END IF
//END IF
//
RETURN 0
//
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;///*===========================================================================*/
///* 작성자      : (주)지우정보 (김 태범)                                      */	
///* 작성일      : 2001.12.11                                                  */	
///* 수정일      : 2001.12.11                                                  */
///*===========================================================================*/
///* Description : 조회,추가,저장 버튼 클릭시 발생                             */
///*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
///*===========================================================================*/
//string   ls_title, ls_style_no
//
//IF as_cb_div = '1' THEN
//	ls_title = "조회오류"
//ELSEIF as_cb_div = '2' THEN
//	ls_title = "추가오류"
//ELSEIF as_cb_div = '3' THEN
//	ls_title = "저장오류"
//ELSE
//	ls_title = "오류"
//END IF
//
//IF dw_head.AcceptText() <> 1 THEN RETURN FALSE
//
//ls_style_no = dw_head.GetItemString(1, "Style_no")
//if IsNull(ls_style_no) or Trim(ls_style_no) = "" then
//   MessageBox(ls_title,"품번 코드를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("Style_no")
//   return false
//end if
//is_style = Mid(ls_style_no, 1, 8)
//is_Chno  = Mid(ls_style_no, 9, 1)
//
//is_color = dw_head.GetItemString(1, "Color")
//if IsNull(is_color) or Trim(is_color) = "" then
//   MessageBox(ls_title,"색상 코드를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("COlor")
//   return false
//end if
//
//return true


/*===========================================================================*/
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

is_country_cd = Trim(dw_head.GetItemString(1, "country_cd"))

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      			*/	
/* 작성일      : 2001..                                                  		*/	
/* 수정일      : 2001..                                                  		*/
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand,is_year,is_season,is_sojae,is_item,is_country_cd)

//idw_color1.Retrieve(is_style,is_chno)
//IF il_rows > 0 THEN
//   dw_body.SetFocus()
//else 
//	dw_body.Reset()
//	dw_body.Insertrow(0)
//	dw_body.SetItem(1,  "Style" , is_style)
//	dw_body.SetItem(1,  "chno" , is_chno)
//	dw_body.SetItem(1,  "color" , is_color)
//	cb_retrieve.Text = "조건(&Q)"
//	dw_head.Enabled = false
//	dw_body.Enabled = true
//	dw_body.SetFocus()
//END IF
	  	
This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      		  */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
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
   ELSEIF idw_status = DataModified! THEN			/* Modify Record */
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

event pfc_preopen();call super::pfc_preopen;dw_body.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_body.Insertrow(0)

end event

event open;call super::open;dw_body.Enabled = false
dw_head.Enabled = true
dw_head.SetFocus()
dw_head.SetColumn(1)
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
			cb_retrieve.Text = "조회(&Q)"
			cb_delete.enabled = false
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			cb_update.enabled = false
			ib_changed = false
			dw_body.Enabled = false
			dw_head.Enabled = true
			dw_head.SetFocus()
			dw_head.SetColumn(1)
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
		cb_insert.enabled = true
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

type cb_close from w_com010_e`cb_close within w_21093_e_old
end type

type cb_delete from w_com010_e`cb_delete within w_21093_e_old
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_21093_e_old
string text = "복사(&A)"
end type

event cb_insert::clicked;call super::clicked;string  ls_STYLE,   	ls_CHNO,  		ls_COLOR,   	ls_MAT_GUBN1,   	ls_MAT_NM1,   		ls_MAT_RATE1,   	ls_MAT_GUBN2  
string  ls_MAT_NM2,  ls_MAT_RATE2,  ls_MAT_GUBN3,  ls_MAT_NM3,    	ls_MAT_RATE3,   	ls_MAT_GUBN4   
string  ls_MAT_NM4,  ls_MAT_RATE4,  ls_MAT_GUBN5,  ls_MAT_NM5,   		ls_MAT_RATE5,   	ls_MAT_GUBN6   
string  ls_MAT_NM6,  ls_MAT_RATE6, 	ls_MAT_GUBN7,  ls_MAT_NM7,   		ls_MAT_RATE7,   	ls_MAT_GUBN8    
string  ls_MAT_NM8,  ls_MAT_RATE8,  ls_REMARK1,   	ls_REMARK2,   		ls_REMARK3,   		ls_REMARK4,   		ls_REMARK5
string  ls_MAKER_FG, ls_COUNTRY_CD, ls_WASHING1,   ls_WASHING2,   	ls_WASHING3,   	ls_WASHING4  
string  ls_CONFIRM_MARK,				ls_BOX_FG

is_style_no = dw_head.GetItemString(1, "Style_no")
is_color = dw_head.GetItemString(1, "color")
is_style = MidA(is_style_no, 1, 8)
is_Chno  = MidA(is_style_no, 9, 1)

il_rows = dw_2.retrieve(is_style, is_chno,is_color)
idw_color1.Retrieve(is_style,is_chno)
IF il_rows > 0 THEN	
	
	 	 ls_STYLE = dw_2.GetitemString(1,"Style")   
       ls_CHNO =  dw_2.GetitemString(1,"CHNO")  
		 ls_COLOR =  dw_2.GetitemString(1,"COLOR")  
       ls_MAT_GUBN1 = dw_2.GetitemString(1,"MAT_GUBN1")  
       ls_MAT_NM1   = dw_2.GetitemString(1,"MAT_NM1")   
       ls_MAT_RATE1 = dw_2.GetitemString(1,"MAT_RATE1")   
       ls_MAT_GUBN2 = dw_2.GetitemString(1,"MAT_GUBN2")  
       ls_MAT_NM2   = dw_2.GetitemString(1,"MAT_NM2")   
       ls_MAT_RATE2 = dw_2.GetitemString(1,"MAT_RATE2")   
       ls_MAT_GUBN3 = dw_2.GetitemString(1,"MAT_GUBN3")  
       ls_MAT_NM3   = dw_2.GetitemString(1,"MAT_NM3")   
       ls_MAT_RATE3 = dw_2.GetitemString(1,"MAT_RATE3")
		 ls_MAT_GUBN4 = dw_2.GetitemString(1,"MAT_GUBN4")  
       ls_MAT_NM4   = dw_2.GetitemString(1,"MAT_NM4")   
       ls_MAT_RATE4 = dw_2.GetitemString(1,"MAT_RATE4")   
       ls_MAT_GUBN5 = dw_2.GetitemString(1,"MAT_GUBN5")  
       ls_MAT_NM5   = dw_2.GetitemString(1,"MAT_NM5")   
       ls_MAT_RATE5 = dw_2.GetitemString(1,"MAT_RATE5")   
       ls_MAT_GUBN6 = dw_2.GetitemString(1,"MAT_GUBN6")  
       ls_MAT_NM6   = dw_2.GetitemString(1,"MAT_NM6")   
       ls_MAT_RATE6 = dw_2.GetitemString(1,"MAT_RATE6")   
		 ls_MAT_GUBN7 = dw_2.GetitemString(1,"MAT_GUBN7")  
       ls_MAT_NM7   = dw_2.GetitemString(1,"MAT_NM7")   
       ls_MAT_RATE7 = dw_2.GetitemString(1,"MAT_RATE7")   
       ls_MAT_GUBN8 = dw_2.GetitemString(1,"MAT_GUBN8")  
       ls_MAT_NM8   = dw_2.GetitemString(1,"MAT_NM8")   
       ls_MAT_RATE8 = dw_2.GetitemString(1,"MAT_RATE8")   
       ls_REMARK1 =  dw_2.GetitemString(1,"REMARK1")   
       ls_REMARK2 =  dw_2.GetitemString(1,"REMARK2") 
       ls_REMARK3 =  dw_2.GetitemString(1,"REMARK3") 
       ls_REMARK4 =  dw_2.GetitemString(1,"REMARK4") 
       ls_REMARK5 =  dw_2.GetitemString(1,"REMARK5") 
		 ls_MAKER_FG = dw_2.GetitemString(1,"MAKER_FG")  
       ls_COUNTRY_CD =  dw_2.GetitemString(1,"COUNTRY_CD") 
       ls_WASHING1 = dw_2.GetitemString(1,"WASHING1")   
       ls_WASHING2 = dw_2.GetitemString(1,"WASHING2")    
       ls_WASHING3 = dw_2.GetitemString(1,"WASHING3")   
       ls_WASHING4 = dw_2.GetitemString(1,"WASHING4")   
		 ls_CONFIRM_MARK = dw_2.GetitemString(1,"CONFIRM_MARK")
		 ls_BOX_FG =  dw_2.GetitemString(1,"BOX_FG")
	
//	     
   	  dw_body.Reset()
		  dw_body.Insertrow(0)
		  dw_body.SetItem(1,  "Style" , is_style)
	     dw_body.SetItem(1,  "chno" , is_chno)
	     dw_body.SetItem(1,  "color" , is_color)
		  dw_body.SetItem(1,"MAT_GUBN1",ls_MAT_GUBN1)  
        dw_body.SetItem(1,"MAT_NM1",ls_MAT_NM1)   
        dw_body.SetItem(1,"MAT_RATE1",ls_MAT_RATE1)   
	     dw_body.SetItem(1,"MAT_GUBN2",ls_MAT_GUBN2)  
        dw_body.SetItem(1,"MAT_NM2",ls_MAT_NM2)   
        dw_body.SetItem(1,"MAT_RATE2",ls_MAT_RATE2)   
        dw_body.SetItem(1,"MAT_GUBN3",ls_MAT_GUBN3)  
        dw_body.SetItem(1,"MAT_NM3",ls_MAT_NM3)   
        dw_body.SetItem(1,"MAT_RATE3",ls_MAT_RATE3)   
        dw_body.SetItem(1,"MAT_GUBN4",ls_MAT_GUBN4)  
        dw_body.SetItem(1,"MAT_NM4",ls_MAT_NM4)   
        dw_body.SetItem(1,"MAT_RATE4",ls_MAT_RATE4)   
        dw_body.SetItem(1,"MAT_GUBN5",ls_MAT_GUBN5)  
        dw_body.SetItem(1,"MAT_NM5",ls_MAT_NM5)   
        dw_body.SetItem(1,"MAT_RATE5",ls_MAT_RATE5)   
        dw_body.SetItem(1,"MAT_GUBN6",ls_MAT_GUBN6)  
        dw_body.SetItem(1,"MAT_NM6",ls_MAT_NM6)   
        dw_body.SetItem(1,"MAT_RATE6",ls_MAT_RATE6)   
		  dw_body.SetItem(1,"MAT_GUBN7",ls_MAT_GUBN7)  
        dw_body.SetItem(1,"MAT_NM7",ls_MAT_NM7)   
        dw_body.SetItem(1,"MAT_RATE7",ls_MAT_RATE7)   
        dw_body.SetItem(1,"MAT_GUBN8",ls_MAT_GUBN8)  
        dw_body.SetItem(1,"MAT_NM8",ls_MAT_NM8)   
        dw_body.SetItem(1,"MAT_RATE8",ls_MAT_RATE8)   
        dw_body.SetItem(1,"REMARK1",ls_REMARK1)   
        dw_body.SetItem(1,"REMARK2",ls_REMARK2)  
        dw_body.SetItem(1,"REMARK3",ls_REMARK3)   
        dw_body.SetItem(1,"REMARK4",ls_REMARK4)  
        dw_body.SetItem(1,"REMARK5",ls_REMARK5)  
		  dw_body.SetItem(1,"MAKER_FG",ls_MAKER_FG)  
        dw_body.SetItem(1,"COUNTRY_CD",ls_COUNTRY_CD) 
        dw_body.SetItem(1,"WASHING1",ls_WASHING1)   
        dw_body.SetItem(1,"WASHING2",ls_WASHING2)   
        dw_body.SetItem(1,"WASHING3",ls_WASHING3)   
        dw_body.SetItem(1,"WASHING4",ls_WASHING4)   
		  dw_body.SetItem(1,"CONFIRM_MARK",ls_CONFIRM_MARK)
		  dw_body.SetItem(1,"BOX_FG",ls_BOX_FG)
		
			cb_retrieve.Text = "조건(&Q)"
			dw_head.Enabled = false
			dw_body.Enabled = true
			dw_body.SetFocus()
			cb_insert.Enabled = false
END IF
	  	


end event

type cb_retrieve from w_com010_e`cb_retrieve within w_21093_e_old
end type

type cb_update from w_com010_e`cb_update within w_21093_e_old
end type

type cb_print from w_com010_e`cb_print within w_21093_e_old
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_21093_e_old
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_21093_e_old
boolean visible = false
end type

type cb_excel from w_com010_e`cb_excel within w_21093_e_old
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_21093_e_old
integer width = 3525
integer height = 124
string dataobject = "d_21095_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/*===========================================================================*/
datawindowchild ldw_child
string  ls_style_no, ls_style, ls_chno

CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	
       
END CHOOSE


		

end event

event dw_head::constructor;call super::constructor;
//This.GetChild("color", idw_color)
//idw_color.SetTransObject(SQLCA)
//idw_color.insertRow(0)
//
//

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

event dw_head::itemfocuschanged;call super::itemfocuschanged;
//string  ls_style_no, ls_style, ls_chno
//
//
//CHOOSE CASE dwo.name
//	CASE "color" 
//		ls_style_no = dw_head.GetItemString(1, "Style_no")
//		ls_style = Mid(ls_style_no, 1, 8)
//		ls_Chno  = Mid(ls_style_no, 9, 1)
//		idw_color.Retrieve(ls_style, ls_chno)
//
//	
//END CHOOSE
//
end event

type ln_1 from w_com010_e`ln_1 within w_21093_e_old
integer beginy = 316
integer endy = 316
end type

type ln_2 from w_com010_e`ln_2 within w_21093_e_old
integer beginy = 320
integer endy = 320
end type

type dw_body from w_com010_e`dw_body within w_21093_e_old
integer x = 814
integer y = 432
integer width = 2715
integer height = 1704
string dataobject = "d_21093_d01"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_body::constructor;call super::constructor;
datawindowchild ldw_child

this.getchild("COLOR",idw_color1)
idw_color1.settransobject(sqlca)
idw_color1.InsertRow(1)
//idw_color1.retrieve(is_style,is_chno)


this.getchild("mat_gubn1",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", ' ')
//ldw_child.SetItem(1,"inter_nm",' ')
//
this.getchild("mat_gubn2",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", ' ')
//ldw_child.SetItem(1,"inter_nm",' ')
//
this.getchild("mat_gubn3",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", '')
//ldw_child.SetItem(1,"inter_nm",'')
//
this.getchild("mat_gubn4",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", '')
//ldw_child.SetItem(1,"inter_nm",'')

this.getchild("mat_gubn5",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", '')
//ldw_child.SetItem(1,"inter_nm",'')

this.getchild("mat_gubn6",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", '')
//ldw_child.SetItem(1,"inter_nm",'')

this.getchild("mat_gubn7",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", '')
//ldw_child.SetItem(1,"inter_nm",'')

this.getchild("mat_gubn8",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('212')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", '')
//ldw_child.SetItem(1,"inter_nm",'')

this.getchild("mat_nm1",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", '')
//ldw_child.SetItem(1,"inter_nm",'')
//
this.getchild("mat_nm2",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", '')
//ldw_child.SetItem(1,"inter_nm",'')
//
this.getchild("mat_nm3",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", '')
//ldw_child.SetItem(1,"inter_nm",'')

this.getchild("mat_nm4",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", '')
//ldw_child.SetItem(1,"inter_nm",'')

this.getchild("mat_nm5",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", '')
//ldw_child.SetItem(1,"inter_nm",'')

this.getchild("mat_nm6",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", '')
//ldw_child.SetItem(1,"inter_nm",'')

this.getchild("mat_nm7",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", '')
//ldw_child.SetItem(1,"inter_nm",'')

this.getchild("mat_nm8",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('213')
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1,"inter_cd", '')
//ldw_child.SetItem(1,"inter_nm",'')


this.getchild("country_cd",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('214')


this.getchild("care_code",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()



this.getchild("washing_gubn",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve()




end event

event dw_body::buttonclicked;call super::buttonclicked;CHOOSE CASE dwo.name
	CASE "cb_washing" 
		  	dw_1.retrieve()
			dw_1.visible  =true
			
	CASE "cb_mat_gubn" 
		  	OpenWithParm (W_21093_E1, "W_21093_E1 섬유의 조성") 
			
   CASE "cb_mat_nm" 
		 
		    
END CHOOSE




end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
string  ls_care_code, ls_remark1, ls_remark2, ls_remark3, ls_remark4, ls_remark5, ls_washing_gubn
string  ls_washing1, ls_washing2, ls_washing3, ls_washing4, ls_pic1, ls_pic2, ls_pic3, ls_pic4


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
		  select  washing1, washing2, washing3, washing4
		  into    :is_washing1,  :is_washing2,  :is_washing3,  :is_washing4
		  from tb_care_washing
		  where washing_gubn = :ls_washing_gubn;  
		  		  
		  dw_body.Setitem(1, "washing1", is_washing1) 
		  dw_body.Setitem(1, "washing2", is_washing2) 
		  dw_body.Setitem(1, "washing3", is_washing3) 
		  dw_body.Setitem(1, "washing4", is_washing4)
		  
		  ls_pic1 =  is_washing1 + '.bmp'
		  dw_body.Setitem(1, "pic1", ls_pic1)
		  ls_pic2 =  is_washing2 + '.bmp'
		  dw_body.Setitem(1, "pic2", ls_pic2)
		  ls_pic3 =  is_washing3 + '.bmp'
		  dw_body.Setitem(1, "pic3", ls_pic3)
		  ls_pic4 =  is_washing4 + '.bmp'
		  dw_body.Setitem(1, "pic4", ls_pic4)
		  
	
END CHOOSE



end event

type dw_print from w_com010_e`dw_print within w_21093_e_old
integer x = 2537
integer y = 416
end type

type dw_2 from datawindow within w_21093_e_old
boolean visible = false
integer x = 2981
integer y = 564
integer width = 411
integer height = 432
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_21093_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_list from datawindow within w_21093_e_old
integer x = 5
integer y = 336
integer width = 878
integer height = 1712
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_21093_d06"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long  ll_body_rows, ll_detail_rows
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

il_rows = dw_body.  retrieve(is_style, is_chno,is_color)


idw_color1.Retrieve(is_style,is_chno)
IF il_rows > 0 THEN
   dw_body.SetFocus()
else 
	dw_body.Reset()
	dw_body.Insertrow(0)
	dw_body.SetItem(1,  "Style" , is_style)
	dw_body.SetItem(1,  "chno" , is_chno)
	dw_body.SetItem(1,  "color" , is_color)
	cb_retrieve.Text = "조건(&Q)"
	dw_head.Enabled = false
	dw_body.Enabled = true
	dw_body.SetFocus()
END IF

dw_body.Setitem(1, "style", is_style)
dw_body.Setitem(1, "chno", is_chno)
dw_body.Setitem(1, "color", is_color)


Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_1 from datawindow within w_21093_e_old
boolean visible = false
integer x = 37
integer width = 3557
integer height = 2028
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

