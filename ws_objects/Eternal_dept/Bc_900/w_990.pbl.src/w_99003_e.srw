$PBExportHeader$w_99003_e.srw
$PBExportComments$table 설명
forward
global type w_99003_e from w_com010_e
end type
end forward

global type w_99003_e from w_com010_e
end type
global w_99003_e w_99003_e

type variables
String is_file_nm
end variables

forward prototypes
public subroutine wf_ch_data (string as_data, ref string as_data2)
public subroutine wf_column_list (string as_data)
end prototypes

public subroutine wf_ch_data (string as_data, ref string as_data2);Long   ll_pos=1
String New_str

New_str = as_data

ll_pos = PosA(New_str, "~t", ll_pos)

DO WHILE ll_pos > 0
	New_str = ReplaceA(New_str, ll_pos, 1, " ")
	ll_pos  = PosA(New_str, "~t", ll_pos)
LOOP

as_data2 = New_str

end subroutine

public subroutine wf_column_list (string as_data);/* Column 항목 정의 */
String ls_text 
int    li_pos
Long   ll_row

IF PosA(as_data, "CONSTRAINT") > 0 THEN RETURN 

// column id
ls_text = Trim(as_data)
IF isnull(ls_text) OR ls_text = "" OR LenA(ls_text) < 5 THEN RETURN 

ll_row = dw_body.insertRow(0)

li_pos = PosA(ls_text, " ", 1) 
dw_body.object.col_id[ll_row] = Trim(MidA(ls_text, 1, li_pos))

// data type
ls_text = Trim(MidA(ls_text, li_pos))
li_pos  = PosA(ls_text, "/*", 1) 
dw_body.object.data_type[ll_row] = Trim(MidA(ls_text, 1, li_pos - 1))

// reamrk
ls_text = Trim(MidA(ls_text, li_pos))
li_pos  = PosA(ls_text, "*/", 1) 
dw_body.object.remark[ll_row] = Trim(MidA(ls_text, 3, li_pos - 3))

end subroutine

on w_99003_e.create
call super::create
end on

on w_99003_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_head.Setitem(1, "file_nm", "E:\DB_SCRI\Table\")
end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.10.04                                                  */	
/* 수정일      : 2001.10.04                                                  */
/*===========================================================================*/
integer li_FileNum, li_st, li_ed
Long    ll_FileLen
String  ls_data

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

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
		il_rows ++ 
		wf_ch_data(ls_data, ls_data)
		ls_data = Upper(ls_data)
		CHOOSE CASE il_rows
			CASE 1
				li_st = PosA(ls_data, "/*")
				IF li_st > 0 THEN
					li_ed = PosA(ls_data, "*/")
					dw_body.Object.t_table_nm.text = Trim(MidA(ls_data, li_st + 2, li_ed - (li_st + 2)))
				ELSE
					MessageBox("오류", "TABLE 생성문이 잘못 되었습니다.")
					il_rows = -1
					EXIT
				END IF
			CASE 2
				li_st = PosA(ls_data, "TB")
				IF li_st > 0 THEN
					li_ed = PosA(ls_data, " ", li_st)
					dw_body.Object.t_table_id.text = Trim(MidA(ls_data, li_st, li_ed - li_st))
				ELSE
					MessageBox("오류", "TABLE 생성문이 잘못 되었습니다.")
					il_rows = -1
					EXIT
				END IF
			CASE ELSE
				WF_COLUMN_LIST(ls_data)
		END CHOOSE
	END IF
   ll_FileLen = FileRead(li_FileNum, ls_data) 
LOOP

FILECLOSE(li_FileNum)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
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
if IsNull(is_file_nm) or Trim(is_file_nm) = "" then 
   MessageBox(ls_title,"파일명을 입력하십시요!") 
   dw_head.SetFocus() 
   dw_head.SetColumn("file_nm") 
   return false
end if

return true
end event

event ue_button;call super::ue_button;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001.10.04                                                  */	
/* 수정일      : 2001.10.04                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
			cb_update.enabled = true
      end if
	CASE 3		/* 저장 */
		if al_rows = 1 then
			cb_update.enabled = false
		end if
END CHOOSE

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : 김태범                                                      */	
/* 작성일      : 2001.10.04                                                  */	
/* 수정일      : 2001.10.04                                                  */
/*===========================================================================*/
long i, ll_row_count
String ls_name,         ls_value,        ls_level0type,   ls_level0name  
String ls_level1type,   ls_level1name,   ls_level2type,   ls_level2name 

ll_row_count = dw_body.RowCount()

DECLARE sp_addproperty PROCEDURE FOR sp_addextendedproperty  
        @name       = :ls_name,   
        @value      = :ls_value,   
        @level0type = :ls_level0type,   
        @level0name = :ls_level0name,   
        @level1type = :ls_level1type,   
        @level1name = :ls_level1name,   
        @level2type = :ls_level2type,   
        @level2name = :ls_level2name  ;

DECLARE sp_updateproperty PROCEDURE FOR sp_updateextendedproperty  
        @name       = :ls_name,   
        @value      = :ls_value,   
        @level0type = :ls_level0type,   
        @level0name = :ls_level0name,   
        @level1type = :ls_level1type,   
        @level1name = :ls_level1name,   
        @level2type = :ls_level2type,   
        @level2name = :ls_level2name  ;

ls_name       = 'MS_Description' 
ls_value      = dw_body.object.t_table_nm.text
ls_level0type = 'user' 
ls_level0name = 'dbo' 
ls_level1type = 'table' 
ls_level1name = dw_body.object.t_table_id.text 
SetNull(ls_level2type) 
SetNull(ls_level2name) 

EXECUTE sp_addproperty ;

IF SQLCA.SQLCODE = -1 AND SQLCA.SQLDBCODE = 15233 THEN 
   EXECUTE sp_updateproperty ;
END IF
IF SQLCA.SQLCODE = -1 THEN 
   MessageBox("SQL 오류", String(SQLCA.SQLDBCODE) + "/" + SQLCA.SQLERRTEXT) 
	RollBack; 
	RETURN -1 
ELSE
	Commit;
END IF

ls_level2type =  'column'
il_rows = 1
FOR i=1 TO ll_row_count
   ls_value      = dw_body.object.remark[i]
   ls_level2name = dw_body.object.col_id[i]
   EXECUTE sp_addproperty ;
   IF SQLCA.SQLCODE = -1 AND SQLCA.SQLDBCODE = 15233 THEN 
      EXECUTE sp_updateproperty ;
	END IF
   IF SQLCA.SQLCODE = -1 THEN 
	   MessageBox("SQL 오류", String(SQLCA.SQLDBCODE) + "/" + SQLCA.SQLERRTEXT)
		il_rows = -1
	   RollBack; 
		EXIT
	ELSE
	   Commit;
	END IF
NEXT

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

Return il_rows

end event

type cb_close from w_com010_e`cb_close within w_99003_e
end type

type cb_delete from w_com010_e`cb_delete within w_99003_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_99003_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_99003_e
end type

type cb_update from w_com010_e`cb_update within w_99003_e
end type

type cb_print from w_com010_e`cb_print within w_99003_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_99003_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_99003_e
end type

type cb_excel from w_com010_e`cb_excel within w_99003_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_99003_e
integer height = 144
string dataobject = "d_99003_h01"
end type

event dw_head::buttonclicked;call super::buttonclicked;/* 화일 탐색 */
string  ls_path, ls_file_nm
integer li_value

li_value = GetFileOpenName("Select File", ls_path, ls_file_nm, "SQL", "SQL Files (*.SQL),*.SQL")

IF li_value = 1 THEN 
	dw_head.Setitem(1, "file_nm", ls_path)
	cb_retrieve.PostEvent(Clicked!)
END IF
end event

type ln_1 from w_com010_e`ln_1 within w_99003_e
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_e`ln_2 within w_99003_e
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_e`dw_body within w_99003_e
integer y = 352
integer height = 1688
string dataobject = "d_99003_d01"
end type

type dw_print from w_com010_e`dw_print within w_99003_e
end type

