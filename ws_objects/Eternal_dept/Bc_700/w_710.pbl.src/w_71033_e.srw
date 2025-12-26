$PBExportHeader$w_71033_e.srw
$PBExportComments$증정권입력
forward
global type w_71033_e from w_com010_e
end type
end forward

global type w_71033_e from w_com010_e
end type
global w_71033_e w_71033_e

type variables
string is_file_nm, is_give_date
end variables

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.10.04                                                  */	
/* 수정일      : 2001.10.04                                                  */
/*===========================================================================*/
integer li_FileNum, li_st, li_ed
Long    ll_FileLen,  ll_FileLen2, ll_found
String  ls_data, ls_give_date, ls_present_no,  ls_use_ymd, ls_point
decimal ld_goods_amt
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
					
			 	ls_data       = Upper(ls_data)
				ls_give_date  = Trim(MidA(ls_data, 1,8))
				ls_present_no = Trim(MidA(ls_data, 10,16))
				ls_point      = Trim(MidA(ls_data, 27,3)) 
				ls_use_ymd    = Trim(MidA(ls_data, 31,8))
				
					if ls_point = '005' then
						ld_goods_amt = 5000
					elseif ls_point = '010' then
						ld_goods_amt = 10000
					elseif ls_point = '020' then
						ld_goods_amt = 20000
					elseif ls_point = '030' then
						ld_goods_amt = 30000
					elseif ls_point = '040' then
						ld_goods_amt = 40000
					elseif ls_point = '050' then
						ld_goods_amt = 50000
					elseif ls_point = '070' then
						ld_goods_amt = 70000
					elseif ls_point = '100' then
						ld_goods_amt = 100000
					end if
					
	      	 dw_head.setitem(1, "give_date",   Trim(MidA(ls_data, 1,8)))
				 
	

			 
             ll_found = dw_body.Find("give_date = '" + ls_give_date + "'and present_no = '" + ls_present_no + "'", &
			    1, dw_body.RowCount()  )
            
    
           if ll_found <= 0 then 		
					dw_body.insertrow(0)
					il_rows ++ 	
					
					
					dw_body.setitem(il_rows, "give_date",  Trim(MidA(ls_data, 1,8)))
					dw_body.setitem(il_rows, "present_no", Trim(MidA(ls_data, 10,16)))
					
					ls_point      = Trim(MidA(ls_data, 27,3)) 
					
					if ls_point = '005' then
						ld_goods_amt = 5000
					elseif ls_point = '010' then
						ld_goods_amt = 10000
					elseif ls_point = '020' then
						ld_goods_amt = 20000
					elseif ls_point = '030' then
						ld_goods_amt = 30000
					elseif ls_point = '040' then
						ld_goods_amt = 40000
					elseif ls_point = '050' then
						ld_goods_amt = 50000
					elseif ls_point = '070' then
						ld_goods_amt = 70000
					elseif ls_point = '100' then
						ld_goods_amt = 100000
					end if
					
					dw_body.setitem(il_rows, "goods_amt",  ld_goods_amt) 
					dw_body.setitem(il_rows, "use_ymd",    Trim(MidA(ls_data, 31,8))) 
           else				
	            messagebox("쿠폰번호 중복 에러", ls_present_no)
					FILECLOSE(li_FileNum)
					return
  			 end if			
			
			dw_BODY.SetItemStatus(ll_found, "goods_amt", Primary!, NewModified!)		
			
		END IF
			ll_FileLen = FileRead(li_FileNum, ls_data) 
		LOOP
		
		FILECLOSE(li_FileNum)
		
		 dw_body.SetSort("present_no A")
      dw_body.Sort( )

		MEssagebox("오류확인", "총" + "" + string(il_rows) + "" + "건중 " + "" +  string(li_cnt_err) + "" + "개의 잘못된 데이터가 있습니다!" )
else

			  
		il_rows = dw_body.retrieve(is_give_date )
		IF il_rows > 0 THEN
			dw_body.SetFocus()
			dw_head.setitem(1, "give_date",   dw_body.getitemstring(1,"give_date"))			 							
		ELSEIF il_rows = 0 THEN
		   MessageBox("조회", "조회할 자료가 없습니다.")
		END IF

end if
	




This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)
 cb_update.enabled = true
  
end event

on w_71033_e.create
call super::create
end on

on w_71033_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
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

is_give_date = dw_head.GetItemString(1, "give_date")
if IsNull(is_give_date) or Trim(is_give_date) = "" then
   MessageBox(ls_title,"발행일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("give_date")
   return false
end if

return true

end event

event open;call super::open;datetime  ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF


dw_head.Setitem(1, "give_date", String(ld_datetime, "yyyymmdd"))
end event

type cb_close from w_com010_e`cb_close within w_71033_e
end type

type cb_delete from w_com010_e`cb_delete within w_71033_e
end type

type cb_insert from w_com010_e`cb_insert within w_71033_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_71033_e
end type

type cb_update from w_com010_e`cb_update within w_71033_e
end type

type cb_print from w_com010_e`cb_print within w_71033_e
end type

type cb_preview from w_com010_e`cb_preview within w_71033_e
end type

type gb_button from w_com010_e`gb_button within w_71033_e
end type

type cb_excel from w_com010_e`cb_excel within w_71033_e
end type

type dw_head from w_com010_e`dw_head within w_71033_e
string dataobject = "d_71033_h01"
end type

event dw_head::buttonclicking;call super::buttonclicking;/* 화일 탐색 */
string  ls_path, ls_file_nm
integer li_value

li_value = GetFileOpenName("Select File", ls_path, ls_file_nm, "txt", "Dat Files (*.txt),*.txt")

IF li_value = 1 THEN 
	dw_head.Setitem(1, "file_nm", ls_path)
	cb_retrieve.PostEvent(Clicked!)
END IF
end event

type ln_1 from w_com010_e`ln_1 within w_71033_e
end type

type ln_2 from w_com010_e`ln_2 within w_71033_e
end type

type dw_body from w_com010_e`dw_body within w_71033_e
string dataobject = "D_71033_D01"
end type

type dw_print from w_com010_e`dw_print within w_71033_e
integer x = 2176
integer y = 220
string dataobject = "d_71033_d01"
end type

