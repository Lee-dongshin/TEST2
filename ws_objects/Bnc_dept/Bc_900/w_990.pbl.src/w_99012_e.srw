$PBExportHeader$w_99012_e.srw
$PBExportComments$도서대여관리
forward
global type w_99012_e from w_com010_e
end type
type st_1 from statictext within w_99012_e
end type
end forward

global type w_99012_e from w_com010_e
st_1 st_1
end type
global w_99012_e w_99012_e

type variables
string  is_book_id
end variables

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_book_id)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

on w_99012_e.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_99012_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
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

is_book_id = dw_head.GetItemString(1, "book_id")


return true

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count , ll_lend_count, ll_cnt
datetime ld_datetime
string  ls_lend_dt, ls_lend_id, ls_exist_yn, ls_return_dt

//ll_row_count = dw_body.RowCount()
//IF dw_body.AcceptText() <> 1 THEN RETURN -1





/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

		ls_lend_id = dw_body.getitemstring(1,'lend_id')
		ls_lend_dt = dw_body.getitemstring(1,'lend_dt')
		ls_return_dt = dw_body.getitemstring(1,'return_dt')
		ll_lend_count = dw_body.getitemdecimal(1,'lend_count')
		ls_exist_yn = dw_body.getitemstring(1,'exist_yn')
			   			
		if  LenA(ls_return_dt) = 8 then
		 
			update a
			 set return_dt = :ls_return_dt
			FROM   tb_book_h a
			where  person_id = :ls_lend_id 
			and    lend_dt   = :ls_lend_dt
			and    book_id   = :is_book_id ;
			
			update a 
				set exist_yn = 'N'
			from   tb_book_m a
			where  book_id = :is_book_id;							 
		else	
			 select count(person_id)
			 into   :ll_cnt
			 from   tb_book_h 
			 where  person_id = :ls_lend_id 
			 and    lend_dt   = :ls_lend_dt
			 and    book_id   = :is_book_id;
			 if  ll_cnt > 0 then 
				   messagebox('확인', '이미 대여처리한 도서 입니다 ' )	
					dw_body.reset()				
					dw_head.setitem(1,'book_id','')
					dw_head.SetFocus()

					return -1
			 else
				 insert into tb_book_h
				 values (:ls_lend_id, :ls_lend_dt,  :is_book_id,'', '', :gs_user_id,:ld_datetime); 
				 
				  update a 
						set exist_yn = 'Y',
							 last_lend_id = :ls_lend_id,
							 last_lend_dt = :ls_lend_dt,
							 lend_count   = :ll_lend_count + 1
					from   tb_book_m a
					where  book_id = :is_book_id;		 		
			 end if
		end if         


messagebox('확인', '처리되었습니다 !!' ) 
	
dw_body.reset()

dw_head.setitem(1,'book_id','')
dw_head.SetFocus()


return il_rows

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
  //       cb_update.enabled = false
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
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
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
  //    cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

type cb_close from w_com010_e`cb_close within w_99012_e
end type

type cb_delete from w_com010_e`cb_delete within w_99012_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_99012_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_99012_e
boolean visible = false
boolean enabled = false
end type

type cb_update from w_com010_e`cb_update within w_99012_e
boolean visible = false
end type

type cb_print from w_com010_e`cb_print within w_99012_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_99012_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_99012_e
end type

type cb_excel from w_com010_e`cb_excel within w_99012_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_99012_e
integer x = 46
integer y = 220
integer width = 1001
integer height = 164
string dataobject = "d_99012_h01"
end type

event dw_head::editchanged;call super::editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/


string  ls_title, ls_lend_id,  ls_lend_nm, ls_lend_dt, ls_return_dt
datetime ld_datetime
integer  Net

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_book_id)
IF il_rows > 0 THEN
	 cb_update.enabled = TRUE

   dw_body.SetFocus()
	dw_body.setcolumn("lend_id")
END IF


IF dw_body.AcceptText() <> 1 THEN RETURN -1

ls_lend_id = dw_body.GetItemString(1, "lend_id")
ls_return_dt = dw_body.GetItemString(1, "return_dt")


 
if LenA(ls_return_dt)  = 8   then
   Net = messagebox('확인', '도서를 반납하시겠습니까?' ,Question!, YesNo!)
	 	IF Net = 1 THEN
				 Parent.Trigger Event ue_update()
				 return 0
		ELSE
			messagebox('확인', '작업이 취소되었습니다')
			dw_body.reset()						
			dw_head.setitem(1,'book_id','')
			dw_head.SetFocus()
			return -1
		END IF
end if


end event

type ln_1 from w_com010_e`ln_1 within w_99012_e
end type

type ln_2 from w_com010_e`ln_2 within w_99012_e
end type

type dw_body from w_com010_e`dw_body within w_99012_e
string dataobject = "d_99012_d01"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_body::editchanged;call super::editchanged;string  ls_title, ls_lend_id,  ls_lend_nm, ls_lend_dt, ls_return_dt
datetime ld_datetime
integer  Net
IF dw_body.AcceptText() <> 1 THEN RETURN -1

ls_lend_id = dw_body.GetItemString(1, "lend_id")

select  person_nm 
  into :ls_lend_nm
  from  vi_93010_1 (nolock)
  where person_id = :ls_lend_id;
 

 this.setitem(1,'lend_nm', ls_lend_nm)
 

 ls_lend_dt = dw_body.getitemstring(1, "lend_dt")
 
 
 IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

if LenA(ls_lend_id) = 6 then
	 if   IsNull(ls_lend_nm) or Trim(ls_lend_nm) = "" then
	   messagebox('경고', '등록된 직원이 아닙니다 ')
		return -1 
    end if
 
 
	 if  IsNull(ls_lend_dt) or Trim(ls_lend_dt) = "" then
		  ls_lend_dt = String(ld_datetime, "yyyymmdd") 
		   this.setitem(1,'lend_dt', ls_lend_dt)
	   	Net = messagebox('확인', '도서를 대여하시겠습니까?'  ,Question!, YesNo!)
			
			IF Net = 1 THEN
				 Parent.Trigger Event ue_update()
				 return 0
			ELSE
				messagebox('확인', '작업이 취소되었습니다')
				dw_body.reset()							
				dw_head.setitem(1,'book_id','')
				dw_head.SetFocus()
				return -1
			END IF
			
			
	 else 
		  ls_return_dt = String(ld_datetime, "yyyymmdd") 
		   this.setitem(1,'return_dt', ls_return_dt)
			Net = messagebox('확인', '도서를 반납하시겠습니까?' ,Question!, YesNo!)
			IF Net = 1 THEN
				 Parent.Trigger Event ue_update()
				 return 0
			ELSE
				messagebox('확인', '작업이 취소되었습니다')
				dw_body.reset()								
				dw_head.setitem(1,'book_id','')
				dw_head.SetFocus()
				return -1
			END IF
	 end if
end if



 
 

 
 
  
end event

type dw_print from w_com010_e`dw_print within w_99012_e
integer x = 2496
integer y = 192
end type

type st_1 from statictext within w_99012_e
integer x = 1079
integer y = 252
integer width = 1865
integer height = 104
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = roman!
string facename = "바탕체"
long textcolor = 128
long backcolor = 67108864
string text = "☜ 도서에 부착된 BARCODE를 스캔하세요"
boolean focusrectangle = false
end type

