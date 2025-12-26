$PBExportHeader$w_cu100_e.srw
$PBExportComments$생산진도관리
forward
global type w_cu100_e from w_com010_e
end type
type st_1 from statictext within w_cu100_e
end type
type dw_smat from datawindow within w_cu100_e
end type
end forward

global type w_cu100_e from w_com010_e
integer width = 3653
integer height = 2236
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
event ue_first_open ( )
event ue_second_open ( )
event ue_sketch_open ( )
st_1 st_1
dw_smat dw_smat
end type
global w_cu100_e w_cu100_e

type variables
string is_style_no, is_style, is_chno
end variables

event ue_first_open();/*------------------------------------------------------------*/
/* 내        용  : 기본 WINDOW를 Open한다. 'W_CU100_e04'      */
/*------------------------------------------------------------*/
Window lw_window

lw_window = This
gf_open_sheet(lw_window, 'W_CU100_e04', '검사의뢰등록')


end event

event ue_second_open();/*------------------------------------------------------------*/
/* 내        용  : 기본 WINDOW를 Open한다. 'W_CU100_e05'      */
/*------------------------------------------------------------*/
Window lw_window

lw_window = This
gf_open_sheet(lw_window, 'W_CU100_e05', '납품예정등록')


end event

event ue_sketch_open();/*------------------------------------------------------------*/
/* 내        용  : 기본 WINDOW를 Open한다. 'W_CU100_e04'      */
/*------------------------------------------------------------*/
Window lw_window

lw_window = This
gf_open_sheet(lw_window, 'W_CU100_e03', '생산의뢰서')


end event

on w_cu100_e.create
int iCurrent
call super::create
this.st_1=create st_1
this.dw_smat=create dw_smat
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_smat
end on

on w_cu100_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_smat)
end on

event open;call super::open;This.Trigger Event ue_retrieve()

Timer(180)
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(gs_shop_cd,is_style_no,gs_country_cd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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

is_style_no = dw_head.GetItemString(1, "style_no")
if IsNull(is_style_no) or Trim(is_style_no) = "" then
	is_style_no = '%'
//   MessageBox(ls_title,"품번코드를 입력하십시요!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("is_style_no")
//   return false
end if

return true
end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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
     //    cb_retrieve.Text = "조건(&Q)"
     //    dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
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
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event timer;call super::timer;dw_body.SetRedRaw(FALSE)
dw_body.Retrieve(gs_shop_cd,'%',gs_country_cd)
dw_body.SetRedRaw(True)
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

//FOR i=1 TO ll_row_count
//   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
//   IF idw_status = NewModified! THEN				/* New Record */
//      dw_body.Setitem(i, "reg_id", gs_user_id)
//   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
//      dw_body.Setitem(i, "mod_id", gs_user_id)
//      dw_body.Setitem(i, "mod_dt", ld_datetime)
//   END IF
//NEXT

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

event pfc_preopen();//datetime ld_datetime
//string ls_modify, ls_to_yymmdd, ls_fr_yymmdd
//
//IF gf_sysdate(ld_datetime) = FALSE THEN
//   ld_datetime = DateTime(Today(), Now())
//END IF
//
//ls_to_yymmdd  = string(ld_datetime, 'yyyymmdd')
//ls_fr_yymmdd  = left(ls_to_yymmdd,6) +  '01'
//
//dw_head.Setitem(1,"fr_yymmdd",ls_fr_yymmdd)
//dw_head.Setitem(1,"to_yymmdd",ls_to_yymmdd)

/*===========================================================================*/
/* 작성자      : 지우정보 (김태범) 														  */	
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
//inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

menu			lm_curr_menu
lm_curr_menu = this.menuid
IF gl_user_level = 999 then 
   lm_curr_menu.item[2].enabled = True 
ELSE
   lm_curr_menu.item[2].enabled = False
END IF 	


//////////////////////////////////////////////////////////////

/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범) 		   										  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


///////////////////////////////////////////////////////////////
inv_resize.of_Register(dw_smat, "FixedToRight&ScaleToBottom")


/* DataWindow의 Transction 정의 */
dw_smat.SetTransObject(SQLCA)

end event

type cb_close from w_com010_e`cb_close within w_cu100_e
boolean visible = false
boolean enabled = false
end type

type cb_delete from w_com010_e`cb_delete within w_cu100_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_cu100_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_cu100_e
integer x = 1083
end type

type cb_update from w_com010_e`cb_update within w_cu100_e
end type

type cb_print from w_com010_e`cb_print within w_cu100_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_cu100_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_cu100_e
boolean visible = false
integer height = 152
end type

type dw_head from w_com010_e`dw_head within w_cu100_e
integer x = 384
integer y = 44
integer width = 704
integer height = 92
string dataobject = "d_cu100_h01"
end type

type ln_1 from w_com010_e`ln_1 within w_cu100_e
integer beginy = 280
integer endy = 280
end type

type ln_2 from w_com010_e`ln_2 within w_cu100_e
integer beginy = 276
integer endy = 276
end type

type dw_body from w_com010_e`dw_body within w_cu100_e
integer y = 156
integer width = 3579
integer height = 1884
string dataobject = "d_cu100_d01"
end type

event dw_body::buttonclicked;call super::buttonclicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (권 진택)                                      */	
///* 작성일      : 2001.12.17                                                  */	
///* 수정일      : 2001.12.17                                                  */
///*===========================================================================*/
datetime ld_datetime
string   ls_date

 	is_style_no =  dw_body.GetitemString(row,"style_no")	
	
	IF is_style_no = "" OR isnull(is_style_no) THEN		
		return
	END IF
	
	is_style =  LeftA(is_style_no,8) 
	is_chno  =  RightA(is_style_no,1)
	
	///* 시스템 날짜를 가져온다 */
	IF gf_sysdate(ld_datetime) = FALSE THEN
		Return 0
	END IF	
	ls_date =   String(ld_datetime, "yyyymmdd")  
			
CHOOSE CASE dwo.name
	CASE "cb_smat"	  			
			il_rows = dw_smat.retrieve(is_style + is_chno)
			if il_rows > 0 then		 dw_smat.visible = true
			
	CASE "cb_sketch"	  

			
			dw_print.retrieve(is_style, is_chno,'Cust')
			dw_print.inv_printpreview.of_SetZoom()

			
//		     Parent.Trigger Event ue_sketch_open()
//		   dw_pic.reset()
//   				
//			IF dw_pic.RowCount() < 1 THEN 
//				il_rows = dw_pic.retrieve(is_style, is_chno)
//			END IF 
//			
//			dw_pic.visible = True
			
	CASE "cb_test"	
		     gs_style = is_style
			  gs_chno  = is_chno
			  gs_work_dt = ls_date
			  gs_work_gubn = '1'
		     Parent.Trigger Event ue_first_open()
//		   dw_test.reset()
//			  
//			IF dw_test.RowCount() < 1 THEN 
//				il_rows = dw_test.retrieve(is_style, is_chno,ls_date,'1')
//			END IF 
//			
//			dw_test.visible = True			
//		   messagebox("알림", '아직 개발중입니다 !!!')
   CASE "cb_input"
		     gs_style = is_style
			  gs_chno  = is_chno
			  gs_work_dt = ls_date
			  gs_work_gubn = '2'
		     Parent.Trigger Event ue_second_open()
//		   dw_input.reset()
//  
//			IF dw_input.RowCount() < 1 THEN 
//				il_rows = dw_input.retrieve(is_style, is_chno,ls_date,'2')
//			END IF 
//			
//			dw_input.visible = True	
//		   messagebox("알림", '아직 개발중입니다 !!!')
END CHOOSE


end event

event dw_body::itemchanged;call super::itemchanged;choose case dwo.name
	case "fix_dlvy"
		if LenA(data) <> 8 then return 1
end choose
end event

type dw_print from w_com010_e`dw_print within w_cu100_e
integer x = 142
integer y = 1044
string dataobject = "d_12010_r01"
end type

type st_1 from statictext within w_cu100_e
integer x = 1563
integer y = 64
integer width = 1051
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 납기예정일을 꼭 입력해 주세요."
boolean focusrectangle = false
end type

type dw_smat from datawindow within w_cu100_e
boolean visible = false
integer x = 1097
integer y = 156
integer width = 1797
integer height = 1644
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "부자재정보"
string dataobject = "d_21004_d04"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

