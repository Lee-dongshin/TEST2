$PBExportHeader$w_42041_e.srw
$PBExportComments$출고요청출고
forward
global type w_42041_e from w_com020_e
end type
type cb_right from commandbutton within w_42041_e
end type
type cb_2 from commandbutton within w_42041_e
end type
type dw_1 from datawindow within w_42041_e
end type
type dw_2 from datawindow within w_42041_e
end type
type st_2 from statictext within w_42041_e
end type
type rb_style from radiobutton within w_42041_e
end type
type rb_shop from radiobutton within w_42041_e
end type
type cb_1 from commandbutton within w_42041_e
end type
type rb_style_no from radiobutton within w_42041_e
end type
type rb_year from radiobutton within w_42041_e
end type
end forward

global type w_42041_e from w_com020_e
integer width = 3685
integer height = 2272
event ue_ac_chk ( long row )
cb_right cb_right
cb_2 cb_2
dw_1 dw_1
dw_2 dw_2
st_2 st_2
rb_style rb_style
rb_shop rb_shop
cb_1 cb_1
rb_style_no rb_style_no
rb_year rb_year
end type
global w_42041_e w_42041_e

type variables
DatawindowChild idw_brand, idw_deal_fg //, idw_proc_yn
string is_brand, is_out_ymd, is_deal_fg, is_proc_yn, is_yymmdd,is_action, ls_print = '1', is_out_term
long ii_work_no, ii_deal_seq

long il_LastClickedRow, &
     il_prim_lastclicked, &
     il_del_lastclicked, &
     il_fil_lastclicked, &
	  il_selected_clicked	  

boolean   ib_prim_ldown, &
          ib_del_ldown, &
          ib_fil_ldown, &
			 ib_action_on_buttonup, &
          ib_already_selected
 


end variables

forward prototypes
public function integer wf_shift_highlight1 (long al_aclickedrow)
public function integer wf_shift_highlight (long al_aclickedrow)
protected subroutine wf_discard_rows ()
end prototypes

event ue_ac_chk;///*===========================================================================*/
///* 작성자      :                                                       */	
///* 작성일      : 2001..                                                  */	
///* 수정일      : 2001..                                                  */
///*===========================================================================*/
//string is_null, ac_chk, ls_mat_cd
//long i
//
//				dw_body.deleterow(i)
//	
//	
//	il_rows = dw_1.retrieve(is_brand, is_year, is_season, ls_mat_cd, to_brand, to_year, to_season, is_item, 'A' )
//	if il_rows > 0 then	
//		dw_list.rowscopy(1,1,Primary!,dw_body,dw_body.rowcount()+1,Primary!)
//	else
//		messagebox("오류","이미 존재하는 데이타가 있습니다..")
//		dw_list.setitem(row,"ac_chk",is_null)
//		return
//	end if	
//
//
//This.SelectRow(0, FALSE)
//This.SelectRow(row, TRUE)
//cb_update.enabled = true
//
//
end event

public function integer wf_shift_highlight1 (long al_aclickedrow);
integer	li_Idx

//file manager functionality ... turn off all rows then select new range
dw_body.setredraw(false)
dw_body.selectrow(0,false)

If il_lastclickedrow = 0 then
//	dw_highlight.SelectRow(al_aclickedrow,TRUE)
	dw_body.setredraw(true)
	Return 1
end if


//selection moving backward
if il_lastclickedrow > al_aclickedrow then
	For li_Idx = il_lastclickedrow to al_aclickedrow STEP -1
		dw_body.selectrow(li_Idx,TRUE)	
	end for	
else
//selection moving forward
	For li_Idx = il_lastclickedrow to al_aclickedrow 
		dw_body.selectrow(li_Idx,TRUE)	
	next	
end if

dw_body.setredraw(true)
Return 1

end function

public function integer wf_shift_highlight (long al_aclickedrow);
integer	li_Idx

//file manager functionality ... turn off all rows then select new range
dw_list.setredraw(false)
dw_list.selectrow(0,false)

If il_lastclickedrow = 0 then
//	dw_highlight.SelectRow(al_aclickedrow,TRUE)
	dw_list.setredraw(true)
	Return 1
end if


//selection moving backward
if il_lastclickedrow > al_aclickedrow then
	For li_Idx = il_lastclickedrow to al_aclickedrow STEP -1
		dw_list.selectrow(li_Idx,TRUE)	
	end for	
else
//selection moving forward
	For li_Idx = il_lastclickedrow to al_aclickedrow 
		dw_list.selectrow(li_Idx,TRUE)	
	next	
end if

dw_list.setredraw(true)
Return 1

end function

protected subroutine wf_discard_rows ();
graphicobject	lgo_focus
DataWindow	ldw_control
long			ll_selected_rows[], &
				ll_selected_count
dwbuffer			lb_buffer
string			ls_buffer


lgo_focus = GetFocus()
if TypeOf (lgo_focus) <> DataWindow! then
	return
else
	ldw_control = lgo_focus
end if


ll_selected_count = gf_retrun_selected (ldw_control, ll_selected_rows)
if ll_selected_count = 0 then
	return
end if


if ldw_control.RowsDiscard (ll_selected_rows[1], ll_selected_rows[ll_selected_count], primary!) = -1 then
	MessageBox ("Error", "An error occured performing RowsDiscard function.", exclamation!)
	return
end if


if ldw_control = dw_list then
	return
else
	if ldw_control = dw_body then
		lb_buffer = delete!
		ls_buffer = "delete"
	else
		lb_buffer = filter!
		ls_buffer = "filter"
	end if
	if dw_1.RowsDiscard (ll_selected_rows[1], ll_selected_rows[ll_selected_count], lb_buffer) = -1 then
		MessageBox ("Error", "An error occured performing RowsDiscard function~r" + &
						"when discarding from the " + ls_buffer + " buffer", exclamation!)
	end if
end if



end subroutine

on w_42041_e.create
int iCurrent
call super::create
this.cb_right=create cb_right
this.cb_2=create cb_2
this.dw_1=create dw_1
this.dw_2=create dw_2
this.st_2=create st_2
this.rb_style=create rb_style
this.rb_shop=create rb_shop
this.cb_1=create cb_1
this.rb_style_no=create rb_style_no
this.rb_year=create rb_year
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_right
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.rb_style
this.Control[iCurrent+7]=this.rb_shop
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.rb_style_no
this.Control[iCurrent+10]=this.rb_year
end on

on w_42041_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_right)
destroy(this.cb_2)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.rb_style)
destroy(this.rb_shop)
destroy(this.cb_1)
destroy(this.rb_style_no)
destroy(this.rb_year)
end on

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "out_ymd",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "yymmdd",string(ld_datetime, "yyyymmdd"))

dw_1.insertrow(0)
dw_2.insertrow(0)
dw_2.SetItem(1, "yymmdd",string(ld_datetime,"yyyymmdd"))


end event

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

is_out_ymd = dw_head.GetItemString(1, "out_ymd")
if IsNull(is_out_ymd) or Trim(is_out_ymd) = "" then
   MessageBox(ls_title,"출고 의뢰일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_ymd")
   return false
end if

is_deal_fg = dw_head.GetItemString(1, "deal_fg")
if IsNull(is_deal_fg) or Trim(is_deal_fg) = "" then
   MessageBox(ls_title,"배분 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_fg")
   return false
end if

is_out_term = dw_head.GetItemString(1, "out_term")
if IsNull(is_out_term) or Trim(is_out_term) = "" then
   MessageBox(ls_title,"처리 여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_term")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"출고 지정일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

//
//
//ii_deal_seq = dw_head.GetItemNumber(1, "deal_seq")
//if is_proc_yn <> "Y" then	
//	if IsNull(ii_deal_seq) or ii_deal_seq < 0 then
//		MessageBox(ls_title,"배분차수를 입력하십시요!")
//		dw_head.SetFocus()
//		dw_head.SetColumn("deal_seq")
//		return false
//	end if
//end if

return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      :                                                        */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN



if is_out_term = "N" then
il_rows = dw_list.retrieve(is_brand, is_out_ymd,   is_deal_fg,  is_out_term)
dw_body.Reset()
		IF il_rows > 0 THEN
  			 dw_body.SetFocus()
		ELSEIF il_rows = 0 THEN
  			 MessageBox("조회", "조회할 자료가 없습니다.")
		ELSE
 			  MessageBox("조회오류", "조회 실패 하였습니다.")
		END IF
else
il_rows = dw_body.retrieve(is_brand, is_out_ymd,  is_deal_fg,  is_out_term)
dw_list.Reset()
		IF il_rows > 0 THEN
  			 dw_body.SetFocus()
		ELSEIF il_rows = 0 THEN
  			 MessageBox("조회", "조회할 자료가 없습니다.")
		ELSE
 			  MessageBox("조회오류", "조회 실패 하였습니다.")
		END IF
end if


IF il_rows > 0 THEN
   dw_list.SetFocus()

END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

inv_resize.of_Register(st_2,     "FixedToRight")
inv_resize.of_Register(rb_style, "FixedToRight")
inv_resize.of_Register(rb_shop,  "FixedToRight")

end event

event type long ue_update();string ls_out_ymd, ls_proc_yn, ls_style, ls_color, ls_size, ls_deal_fg
Integer li_deal_seq
long    ll_row, II, JJ, KK, ll_ok, li_work_no



//if is_proc_yn = "N"     then
//		select isnull(max(work_no),0) + 1
//		into :li_work_no
//		from tb_52031_h
//		where style like  :is_brand + "%"
//		and   yymmdd = :is_yymmdd;
//else		
   li_work_no = ii_work_no
//end if	

//      dw_head.Setitem(1, "work_no", li_work_no) 			

dw_body.SetSort("yymmdd A, work_no A")
dw_body.Sort( )
		
		ll_row = dw_body.rowcount()
		ll_ok = 0
		
		for ii= 1 to ll_row
				ls_out_ymd   = dw_body.GetItemString(ii, "YYMMDD")
				ls_proc_yn   = "Y"
				li_deal_seq  = dw_body.GetItemNumber(ii, "WORK_NO")
				ls_deal_fg   = dw_body.GetItemstring(ii, "deal_fg")				
				idw_status   = dw_body.GetItemStatus(ii, 0, Primary!)

			if ls_proc_yn = "Y"  and  isnull(li_deal_seq) = false aND idw_status = NewModified! THEN	
			
					DECLARE sp_42041_d01 PROCEDURE FOR sp_42041_d01  
							  @out_ymd  = :ls_out_ymd,   
 						     @yymmdd   = :is_yymmdd,   
							  @deal_seq = :li_deal_seq,   
							  @deal_fg  = :ls_deal_fg,   
							  @brand    = :is_brand,   
							  @reg_id   = :gs_user_id  ;
							  
 			      execute sp_42041_d01;
 			      commit  USING SQLCA; 
            ll_ok = ll_ok + 1 						  
				
			else
				  messagebox("경고!", "작업번호를 설정하셔야 가능합니다!")
			end if
		next 	
       
		if ll_ok > 0 then 
			messagebox("알림!" , "총 " + string(ll_ok) + "건의 배분 자료가 출고처리되었습니다!")
			dw_body.reset()
		else
			messagebox("알림!" , "출고 처리된 배분자료가 없습니다!")
      end if

			

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)			
return il_rows
	
	

end event

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
This.Trigger Event ue_title ()

il_rows = dw_print.retrieve(is_brand, is_out_ymd, is_deal_fg, is_yymmdd, ii_work_no)

IF il_rows = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
ELSE
	dw_print.inv_printpreview.of_SetZoom()
END IF

This.Trigger Event ue_msg(6, il_rows)


end event

event ue_button;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         dw_head.SetFocus()
      end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

END CHOOSE

end event

event ue_title();/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

Choose Case ls_print
	Case '1'
		dw_print.DataObject = 'd_42004_r01'
	Case '2'
		dw_print.DataObject = 'd_42004_r02'
	Case '3'
		dw_print.DataObject = 'd_42004_r03'		
	Case '4'
		dw_print.DataObject = 'd_42004_r04'				
End Choose


dw_print.SetTransObject(SQLCA)

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id + "'" + &
            "t_user_id.Text  = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_out_ymd.Text  = '" + String(is_out_ymd, '@@@@/@@/@@') + "'" + &
            "t_yymmdd.Text   = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_deal_fg.Text  = '" + idw_deal_fg.GetItemString(idw_deal_fg.GetRow(), "inter_display") + "'" + &
            "t_work_no.Text  = '" + String(ii_work_no) + "'"

dw_print.Modify(ls_modify)

end event

event ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

dw_print.retrieve(is_brand, is_out_ymd, is_deal_fg, is_yymmdd, ii_work_no)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42041_e","0")
end event

type cb_close from w_com020_e`cb_close within w_42041_e
end type

type cb_delete from w_com020_e`cb_delete within w_42041_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_42041_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_42041_e
end type

type cb_update from w_com020_e`cb_update within w_42041_e
end type

type cb_print from w_com020_e`cb_print within w_42041_e
integer x = 2176
end type

type cb_preview from w_com020_e`cb_preview within w_42041_e
integer x = 2519
end type

type gb_button from w_com020_e`gb_button within w_42041_e
integer y = 4
integer height = 152
end type

type cb_excel from w_com020_e`cb_excel within w_42041_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_42041_e
integer y = 192
integer height = 208
string dataobject = "d_42041_h01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("deal_fg", idw_deal_fg )
idw_deal_fg.SetTransObject(SQLCA)
idw_deal_fg.Retrieve('521')
idw_deal_fg.InsertRow(1)
idw_deal_fg.SetItem(1, "inter_cd", '%')
idw_deal_fg.SetItem(1, "inter_nm", '전체')


// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)                                       */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String ls_yymmdd

CHOOSE CASE dwo.name
	CASE "out_ymd"      
		  
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, data) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
		  
   CASE "yymmdd"      
		  
		 // IF gf_iwoldate_chk(gs_user_id, is_pgm_id, data) = FALSE THEN 
		//  MessageBox("경고","소급할수 없는 일자입니다.")
		//	  Return 1
      // END IF		  
	
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_42041_e
end type

type ln_2 from w_com020_e`ln_2 within w_42041_e
end type

type dw_list from w_com020_e`dw_list within w_42041_e
event ue_lmouse_down pbm_lbuttondown
event ue_lmouse_up pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 14
integer y = 464
integer width = 1659
integer height = 1576
string dragicon = "row.ico"
string dataobject = "d_42041_d01"
boolean hscrollbar = true
end type

event dw_list::doubleclicked;call super::doubleclicked;///*===========================================================================*/
///* 작성자      :                                                      */ 
///* 작성일      : 2001..                                                  */
///* 수정일      : 2001..                                                  */
///*===========================================================================*/
//string ls_out_ymd, ls_style, ls_color
//Integer li_out_seq
//
//ls_out_ymd = dw_list.getitemstring(row, "out_ymd")
//ls_style	  = dw_list.getitemstring(row, "style")
//ls_color	  = dw_list.getitemstring(row, "color")
//li_out_seq = dw_list.getitemNumber(row, "deal_seq")
//
//
//
//il_rows = dw_1.retrieve(ls_out_ymd, li_out_seq, ls_style, ls_color)
//IF il_rows > 0 THEN
//	dw_1.visible = true
//   dw_1.SetFocus()
//ELSEIF il_rows = 0 THEN
//	dw_1.visible = false
//   MessageBox("조회", "조회할 자료가 없습니다.")
//ELSE
//   MessageBox("조회오류", "조회 실패 하였습니다.")
//END IF
//
//
end event

event dw_list::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_out_ymd, ls_style
Integer li_deal_seq, li_work_no, li_rtrn

CHOOSE CASE dwo.name

CASE "proc_yn"	     //  Popup 검색창이 존재하는 항목 
	IF ib_itemchanged THEN RETURN 1

   if data = "N" then
		li_rtrn = messagebox("경고!", "이미 발생된 전표가 있습니다! 삭제하시겠습니까?",Question!,OKCancel! )
		 if li_rtrn = 1 then
       		ls_out_ymd   = dw_list.GetItemString(row, "out_ymd")
				ls_style     = dw_list.GetItemString(row, "style")				
				li_deal_seq  = dw_list.GetItemNumber(row, "deal_seq")
				li_work_no   = dw_list.GetItemNumber(row, "work_no") 

            delete from tb_42020_work
		      where yymmdd =  :is_yymmdd
 	         and   style = :ls_style       				
   	      and   brand  =  :is_brand
  	         and   rqst_gubn  = :is_deal_fg
	  	      and   rqst_date  = :ls_out_ymd
				and   rqst_chno  = :li_deal_seq   ;
				
			   update tb_52031_h set 	proc_yn = 'N',
											  	yymmdd  = null,
	                          			out_no  = null,
	                          			work_no = null,
                                  	out_qty = null
		      where out_ymd  = :ls_out_ymd
		      and   deal_seq = :li_deal_seq
		      and   deal_fg  = :is_deal_fg
		      and   style    = :ls_style; 

			  commit  USING SQLCA;
			else
				messagebox("알림!", "작업을 취소했습니다!")
				dw_list.retrieve(is_brand, is_out_ymd, is_deal_fg, is_proc_yn)
			end if	
			dw_list.retrieve(is_brand, is_out_ymd, is_deal_fg, is_proc_yn)
		end if	
		
		
END CHOOSE

end event

event dw_list::clicked;string	  ls_KeyDownType


If row = 0 then Return


If Keydown(KeyShift!) then
	wf_Shift_Highlight(row)

ElseIf this.IsSelected(row) Then
	il_LastClickedRow = row
	ib_action_on_buttonup = true
	
//ElseIf Keydown(KeyControl!) then
//	il_LastClickedRow = row
//	this.SelectRow(row,TRUE)
	
Else
	il_LastClickedRow = row
	this.SelectRow(0,FALSE)
	this.SelectRow(row,TRUE)
	
End If  

end event

type dw_body from w_com020_e`dw_body within w_42041_e
event ue_mousemove pbm_mousemove
event ue_lmouse_up pbm_lbuttonup
event ue_lmouse_down pbm_lbuttondown
integer x = 1906
integer y = 456
integer width = 1696
integer height = 1576
string dragicon = "row.ico"
string dataobject = "d_42041_d02"
end type

event dw_body::clicked;call super::clicked;string	  ls_KeyDownType


If row = 0 then Return


If Keydown(KeyShift!) then
	wf_Shift_Highlight1(row)

ElseIf this.IsSelected(row) Then
	il_LastClickedRow = row
	ib_action_on_buttonup = true
	
//ElseIf Keydown(KeyControl!) then
//	il_LastClickedRow = row
//	this.SelectRow(row,TRUE)
//	
Else
	il_LastClickedRow = row
	this.SelectRow(0,FALSE)
	this.SelectRow(row,TRUE)
	
End If  

end event

event dw_body::doubleclicked;call super::doubleclicked;///*===========================================================================*/
///* 작성자      :                                                      */ 
///* 작성일      : 2001..                                                  */
///* 수정일      : 2001..                                                  */
///*===========================================================================*/
//string ls_out_ymd, ls_style, ls_color
//Integer li_out_seq
//
//ls_out_ymd = dw_body.getitemstring(row, "out_ymd")
//ls_style	  = dw_body.getitemstring(row, "style")
//ls_color	  = dw_body.getitemstring(row, "color")
//li_out_seq = dw_body.getitemNumber(row, "deal_seq")
//
//
//
//il_rows = dw_1.retrieve(ls_out_ymd, li_out_seq, ls_style, ls_color)
//IF il_rows > 0 THEN
//	dw_1.visible = true
//   dw_1.SetFocus()
//ELSEIF il_rows = 0 THEN
//	dw_1.visible = false
//   MessageBox("조회", "조회할 자료가 없습니다.")
//ELSE
//   MessageBox("조회오류", "조회 실패 하였습니다.")
//END IF
//
//
end event

type st_1 from w_com020_e`st_1 within w_42041_e
boolean visible = false
integer x = 2053
integer y = 464
boolean enabled = false
end type

type dw_print from w_com020_e`dw_print within w_42041_e
integer x = 2098
integer y = 1512
string dataobject = "d_42004_r02"
end type

type cb_right from commandbutton within w_42041_e
integer x = 1678
integer y = 620
integer width = 229
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = ">>>>"
end type

event clicked;
long		ll_selected_rows[], &
			ll_selected_count, &
			ll_rowcount, li_loop
dwbuffer	lb_source_buffer, &
			lb_target_buffer


ll_selected_count = gf_retrun_selected (dw_list, ll_selected_rows)
if ll_selected_count = 0 then return

	dw_list.RowsMove (ll_selected_rows[1], ll_selected_rows[ll_selected_count], &
								primary!, dw_body, dw_body.RowCount() + 1, primary!)	

dw_body.SetFocus()
ll_rowcount = dw_body.RowCount()
dw_body.ScrollToRow(ll_rowcount)

cb_update.enabled = true

end event

type cb_2 from commandbutton within w_42041_e
integer x = 1678
integer y = 736
integer width = 229
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "<<<<"
end type

event clicked;
long		ll_selected_rows[], &
			ll_selected_count, &
			ll_rowcount, li_loop
dwbuffer	lb_source_buffer, &
			lb_target_buffer
string ls_out_ymd, ls_style, ls_color, ls_size, ls_deal_fg
Integer li_deal_seq, li_work_no, li_rtrn, li_data_cnt, ll_select_row

ll_selected_count = gf_retrun_selected (dw_body, ll_selected_rows)
if ll_selected_count = 0 then return

ll_select_row = dw_body.GetSelectedRow(0)

for li_loop = ll_select_row to ll_select_row + ll_selected_count - 1
	
	ls_out_ymd    = dw_body.getitemstring(ll_select_row, "YYMMDD")
	li_deal_seq   = dw_body.getitemNumber(ll_select_row, "WORK_NO")
	ls_deal_fg    = dw_body.getitemstring(ll_select_row, "deal_fg")
	
 				select count(style)	
				INTO :li_data_cnt  
				from tb_42020_work with (nolock)
		      where yymmdd =  :is_yymmdd
   	      and   brand  =  :is_brand
  	         and   rqst_gubn  = :ls_deal_fg
	  	      and   rqst_date  = :ls_out_ymd
				and   rqst_chno  = :li_deal_seq ;
				
				
				
    if li_data_cnt <> 0 then  	

		li_rtrn = 1 // messagebox("경고!", "이미 발생된 전표가 있습니다! 삭제하시겠습니까?",Question!,OKCancel! )

		 if li_rtrn = 1 then
       	
            delete from tb_42020_work
				//from tb_42020_work with (nolock)
		      where yymmdd =  :is_yymmdd
   	      and   brand  =  :is_brand
  	         and   rqst_gubn  = :ls_deal_fg
	  	      and   rqst_date  = :ls_out_ymd
				and   rqst_chno  = :li_deal_seq;
				
			  commit  USING SQLCA;
				
			   update tb_52031_work set 	out_term = 'N'
		      where yymmdd   = :ls_out_ymd
		      and   work_no  = :li_deal_seq
		      and   deal_fg  = :ls_deal_fg
				and   deal_seq = :li_deal_seq
				and   brand  =  :is_brand	; 

			  commit  USING SQLCA;
			    
			  
			  dw_body.RowsMove (ll_select_row, ll_select_row, &
								primary!, dw_list, dw_list.RowCount() + 1, primary!)	

			  
			else
				messagebox("알림!", "작업을 취소했습니다!")
				dw_list.retrieve(is_brand, is_out_ymd, is_deal_fg, is_proc_yn)
			end if	
			
		else	
		  dw_body.RowsMove (ll_select_row, ll_select_row, &
								primary!, dw_list, dw_list.RowCount() + 1, primary!)	
		end if						
next		


dw_body.selectrow(0,false)
dw_body.setredraw(true)

dw_list.SetFocus()
ll_rowcount = dw_list.RowCount()
dw_list.ScrollToRow(ll_rowcount)
end event

type dw_1 from datawindow within w_42041_e
boolean visible = false
integer x = 283
integer y = 788
integer width = 974
integer height = 1116
integer taborder = 40
boolean titlebar = true
string title = "상세조회"
string dataobject = "d_42004_d03"
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;dw_1.visible = false
end event

type dw_2 from datawindow within w_42041_e
boolean visible = false
integer x = 1184
integer y = 476
integer width = 1166
integer height = 660
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "배분강제 적용"
string dataobject = "d_42041_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;datawindowchild ldw_brand, ldw_deal_fg


This.GetChild("brand", ldw_brand )
ldw_brand.SetTransObject(SQLCA)
ldw_brand.Retrieve('001')

This.GetChild("deal_fg", ldw_deal_fg )
ldw_deal_fg.SetTransObject(SQLCA)
ldw_deal_fg.Retrieve('521')

end event

event buttonclicked;
String ls_yymmdd, ls_brand, ls_deal_fg, ls_chk_null1, ls_chk_null2, ls_chk_null3, ls_chk_null4
integer li_work_no

CHOOSE CASE dwo.name
	CASE "cb_apply"      

IF dw_2.AcceptText() <> 1 THEN RETURN -1
		
	 ls_brand    = dw_2.GetitemString(1, "brand")
	 if IsNull(ls_brand) or Trim(ls_brand) = "" then
	   MessageBox("경고!","대상브랜드를 입력하십시요!")
	   dw_2.SetFocus()
	   dw_2.SetColumn("brand")
   	ls_chk_null1 = "N"
  	 else	
		ls_chk_null1 = "Y"
    end if

		
	 ls_yymmdd = dw_2.getitemString(1, "yymmdd")
	 if IsNull(ls_yymmdd) or Trim(ls_yymmdd) = "" then
	   MessageBox("경고!","배분일자를 입력하십시요!")
	   dw_2.SetFocus()
	   dw_2.SetColumn("yymmdd")
		ls_chk_null2 = "N"
  	 else	
		ls_chk_null2 = "Y"
    end if
	 
	 ls_deal_fg  = dw_2.GetitemString(1, "deal_fg")	 
	 if IsNull(ls_deal_fg) or Trim(ls_deal_fg) = "" then
	   MessageBox("경고!","배분구분을 입력하십시요!")
	   dw_2.SetFocus()
	   dw_2.SetColumn("deal_fg")
		ls_chk_null3 = "N"
  	 else	
		ls_chk_null3 = "Y"
    end if	 
	
 	 li_work_no  = dw_2.GetitemNumber(1, "work_no")	 
	 if IsNull(li_work_no) or li_work_no <= 0  then
	   MessageBox("경고!","배분번호를 입력하십시요!")
	   dw_2.SetFocus()
	   dw_2.SetColumn("work_no")
		ls_chk_null4 = "N"
  	 else	
		ls_chk_null4 = "Y"
    end if	 	  

	 
	if ls_chk_null1 = "Y" and ls_chk_null2 = "Y" and ls_chk_null3 = "Y" and ls_chk_null4 = "Y" then

		   update tb_52031_work set out_qty = deal_qty, trx_chk = '2', out_term = 'N'			
			where yymmdd  = :ls_yymmdd
			  and brand   = :ls_brand
			  and deal_fg = :ls_deal_fg
			  and work_no = :li_work_no ;
			
			IF SQLCA.SQLCODE <> 0 THEN 
				rollback  USING SQLCA;  				
				MessageBox("알림!","처리 실패하였습니다!")
			else	
				commit  USING SQLCA;  
			   MessageBox("알림!","처리되었습니다!")				
			end if	
	
	ELSE
		   MessageBox("경고!","처리조건을 모두 입력하십시요!")
	END IF	
	 
		

   CASE "cb_close" 
     dw_2.visible = false 	  
		  
END CHOOSE

end event

type st_2 from statictext within w_42041_e
integer x = 795
integer y = 68
integer width = 768
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
string text = "인쇄: "
boolean focusrectangle = false
end type

type rb_style from radiobutton within w_42041_e
integer x = 933
integer y = 64
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "품번별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_style.TextColor = RGB(0, 0, 255)
rb_shop.TextColor = 0
rb_style_no.TextColor = 0
rb_year.TextColor = 0


ls_print = '1'

end event

type rb_shop from radiobutton within w_42041_e
integer x = 1554
integer y = 64
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "매장별"
borderstyle borderstyle = stylelowered!
end type

event clicked;
rb_style.TextColor = 0
rb_shop.TextColor = RGB(0, 0, 255)
rb_style_no.TextColor = 0
rb_year.TextColor = 0



ls_print = '2'

end event

type cb_1 from commandbutton within w_42041_e
integer x = 379
integer y = 44
integer width = 366
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "강제적용"
end type

event clicked;dw_2.visible = true
end event

type rb_style_no from radiobutton within w_42041_e
integer x = 1193
integer y = 64
integer width = 357
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "품번차수별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_style.TextColor = 0
rb_shop.TextColor = 0
rb_style_no.TextColor = RGB(0, 0, 255)
rb_year.TextColor = 0


ls_print = '3'

end event

type rb_year from radiobutton within w_42041_e
integer x = 1806
integer y = 64
integer width = 357
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "년도시즌별"
borderstyle borderstyle = stylelowered!
end type

event clicked;

rb_style.TextColor = 0
rb_shop.TextColor = 0
rb_style_no.TextColor = 0
rb_year.TextColor = RGB(0, 0, 255)



ls_print = '4'

end event

