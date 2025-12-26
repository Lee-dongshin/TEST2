$PBExportHeader$w_menu01.srw
$PBExportComments$Menu 탐색기
forward
global type w_menu01 from w_sheet
end type
type tv_1 from u_tv within w_menu01
end type
type lv_1 from u_lv within w_menu01
end type
type st_var from u_st within w_menu01
end type
end forward

global type w_menu01 from w_sheet
integer x = 5
integer y = 4
integer width = 3625
integer height = 2148
string title = "Menu탐색"
string icon = "Rectangle!"
event ue_tvinit ( )
event ue_populate ( )
event ue_insert ( )
event ue_update ( )
event ue_refresh ( )
event ue_delete ( )
event ue_user_in ( )
event ue_user_del ( )
tv_1 tv_1
lv_1 lv_1
st_var st_var
end type
global w_menu01 w_menu01

type variables
DataStore	 ids_Source
dragobject   idrg_vertical[2]
long         il_hiddencolor

boolean      ib_moveinprogress=False
boolean      ib_debug=False

integer      ii_min_left_space = 20
integer      ii_min_right_space = 20
integer      ii_barthickness = 20
/*  */
Boolean      ib_lvpass = False   
String       is_Winid, is_Winname 
Long         il_Parent, il_Person, il_index
Long	       il_DragSourcelv, il_ParentTarget
Integer	    ii_Columns, ii_OpenPos
end variables

forward prototypes
public function integer wf_refreshbars ()
public function integer wf_resizebars ()
public function integer wf_resizepanels ()
public function integer wf_retrieve_data (long al_handle)
public function integer wf_add_tv_items (long al_parent, integer ai_level, integer ai_rows)
public subroutine wf_set_tv_item (integer ai_level, integer ai_row, ref treeviewitem atvi_new)
public subroutine wf_set_lv_item (integer ai_level, integer ai_row, ref listviewitem alvi_new)
public function boolean wf_chk_pass (string as_pg_id)
public function integer wf_add_lv_items (integer ai_level, integer ai_rows)
public function boolean wf_open_sheet (string as_win_id, string as_win_name, string as_parent_id)
end prototypes

event ue_tvinit;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)														  */	
/* 작성일      : 1999.09.28																  */	
/*===========================================================================*/

Long				ll_Root
TreeViewItem	ltvi_Root

// *** Add the root item ***************************************
ltvi_Root.Label 			= "보끄레머천다이징 시스템"
ltvi_Root.Data 			= 'W_00000000'
ltvi_Root.PictureIndex 	= 1
ltvi_Root.SelectedPictureIndex = 1
ltvi_Root.Children 		= True
ll_Root = tv_1.InsertItemLast(0, ltvi_Root)

tv_1.ExpandItem(ll_Root)
tv_1.SelectItem(ll_Root)

end event

event ue_populate;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)	   												  */	
/* 작성일      : 1999.09.28																  */	
/*===========================================================================*/
Integer        li_row

lv_1.AddColumn("프로그램명", Left!, 1200)
lv_1.AddColumn("프로그램ID", Left!,  400)
lv_1.AddColumn("기능",       Center!,  300)
lv_1.AddColumn("상태",       Center!,  300)
lv_1.AddColumn("등급",       Center!,  300)
ii_Columns = 5

li_row = ids_Source.retrieve("BNC_DEPT", gs_user_id) 

wf_add_tv_items(0, 1, li_row)

tv_1.SelectItem(1)

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 1999.10.06                                                  */	
/* 수성일      : 1999.11.11                                                  */
/*===========================================================================*/
n_cst_parms       lnv_Parm
TreeViewItem		ltvi_Current
Long					ll_Parent
string            ls_parentid, ls_flag

SetPointer(HourGlass!)

// Get the currently selected TreeView item.  It is
// the parent of this item.
ll_Parent = tv_1.FindItem(CurrentTreeItem!, 0)
tv_1.GetItem(ll_Parent, ltvi_Current)

lnv_Parm.iw_Parent   = this 
lnv_Parm.is_select   = 'I' 
lnv_Parm.is_winid    = ''
lnv_Parm.ii_OpenPos  = gi_menu_pos
ls_parentid = String(ltvi_Current.Data)

// Tree View 선택된 Data가 Window일 경우 상위 Menu를 Data Set
SELECT pgm_fg 
  INTO :ls_flag
  FROM tb_93020_m
 WHERE pgm_id = :ls_parentid;

IF ls_flag = 'W' THEN
	ll_Parent = tv_1.FindItem(ParentTreeItem!, ll_parent)
	tv_1.GetItem(ll_Parent, ltvi_Current)
	ls_parentid = String(ltvi_Current.Data)
END IF

lnv_Parm.is_parentid = ls_parentid
OpenWithParm(W_MENU02, lnv_Parm)

//TreeView 항목 추가 
n_cst_parms   lnv_Parm1
TreeViewItem  ltvi_New  
lnv_Parm1 = Message.PowerObjectParm

IF lnv_Parm1.ib_Check and ltvi_Current.expandedonce = True and &
   lnv_Parm1.is_Gubun = 'M' THEN
   ltvi_New.children = True
   ltvi_New.pictureindex = 2
   ltvi_New.selectedpictureindex = 3
   ltvi_New.Data  = lnv_Parm1.is_WinID 
   ltvi_New.Label = lnv_Parm1.is_Label 
   tv_1.InsertItemLast(ll_Parent, ltvi_New)
END IF

SetPointer(Arrow!)

end event

event ue_update;n_cst_parms       lnv_Parm

Integer				li_Index
Long					ll_Parent,ll_Current
TreeViewItem		ltvi_Current
ListViewItem	   llvi_window

SetPointer(HourGlass!)
li_Index = lv_1.SelectedIndex()

If li_Index <= 0 Then Return

If lv_1.GetItem(li_Index, llvi_Window) = -1 Then Return
IF llvi_Window.data = gs_User_ID Then Return

ll_Parent = tv_1.FindItem(CurrentTreeItem!, 0)
tv_1.GetItem(ll_Parent, ltvi_Current)

lnv_Parm.iw_Parent   = this
lnv_Parm.is_select   = 'U' 
lnv_Parm.ii_OpenPos  = gi_menu_pos

lnv_Parm.is_parentid = String(ltvi_Current.Data)
lnv_Parm.is_winid    = String(llvi_window.Data)
OpenWithParm(w_menu02, lnv_Parm)

long             ll_item
String           ls_WinID1
boolean          lb_Found = False
TreeViewItem     ltvi_Item
n_cst_parms      lnv_Parm1

lnv_Parm1 = Message.PowerObjectParm
IF lnv_Parm1.ib_Check and ltvi_Current.expandedonce = True and &
   lnv_Parm1.is_Gubun = 'M' THEN
   ll_Item = tv_1.FindItem(ChildTreeItem!, ll_Parent)
   Do Until ( lb_Found or ll_Item < 1)
	   tv_1.GetItem(ll_Item, ltvi_Item)
      ls_WinID1 = ltvi_Item.Data
	   IF ls_WinID1 = lnv_Parm.is_winid Then
         lb_Found = True
	   ELSE
	      ll_Item = tv_1.FindItem(NextTreeItem!, ll_Item)
	   END IF
   Loop

   If lb_Found Then
	   ltvi_Item.Data  = lnv_Parm1.is_Winid
	   ltvi_Item.Label = lnv_Parm1.is_Label 
	   tv_1.SetItem (ll_Item, ltvi_Item )
   End If
END IF

SetPointer(Arrow!)

end event

event ue_refresh();
string   ls_work_gbn, ls_empno
long li_cnt, ll_cnt

select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '1';
if match(ls_work_gbn,'1') then // 원가계산서 확인
	close(w_mesage_d)
	openwithparm(w_mesage_d,"원가계산서 확인")
end if

select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '3';
if match(ls_work_gbn,'3') then // 원자재출고요청 확인
	close(w_mesage_d2)
	open(w_mesage_d2)
end if 

select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '4';
if match(ls_work_gbn,'4') then // CAd 완료 확인
	close(w_mesage_d3)
	open(w_mesage_d3)
end if 

select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '5';
if match(ls_work_gbn,'5') then // 부자재 발주서 확인
	close(w_mesage_d4)
	open(w_mesage_d4)
end if 


select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '6';
if match(ls_work_gbn,'6') then // 디자인 진행등록
	close(w_mesage_d7)
	open(w_mesage_d7)	
end if 


select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '7';
if match(ls_work_gbn,'7') then // 디자인진행등록
	close(w_mesage_d5)
	open(w_mesage_d5)	
end if 

select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '2';
if match(ls_work_gbn,'2') then // QC진행등록
	close(w_mesage_d8)
	open(w_mesage_d8)	
end if 


select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '8';
if match(ls_work_gbn,'8') then // 요척변경서 확인
	close(w_mesage_d6)
	open(w_mesage_d6)	
end if 

select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '9';
if match(ls_work_gbn,'9')  then // 요척변경서 확인
	close(w_mesage_d9)
	open(w_mesage_d9)	
end if 

select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '13';
if match(ls_work_gbn,'13')  then // 요척변경서 확인
	close(w_mesage_d9)
	open(w_mesage_d9)	
end if 


select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '11';
if match(ls_work_gbn,'11') then // 중국라벨확인
	close(w_mesage_d14)
	open(w_mesage_d14)	
end if 

select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '12';
if match(ls_work_gbn,'12') then // 작지내역조회
	close(w_mesage_d15)
	open(w_mesage_d15)	
end if 


SELECT empno
INTO :ls_empno
from (select  empno,  kname
from mis.dbo.thb01 with (nolock) 
where goout_gubn = '1'
 and  dept_code  in ('5000','T400','R400','9000','T500')
union all
select 'B00805','현상집' 
union all
select 'A00401','박영배' 
union all
select 'A80113','한정석' 
union all
select 'A81001','조경만'

) A
where a.empno =  :gs_user_id;

if match(ls_empno,gs_user_id) then // 요척변경서 확인
	close(w_mesage_d12)
	open(w_mesage_d12)	
end if 


select distinct work_gbn into :ls_work_gbn from tb_93013_d where person_id = :gs_user_id and work_gbn = '10';
if match(ls_work_gbn,'10') then // 요척변경서 확인
	close(w_mesage_d13)
	open(w_mesage_d13)	
end if 



//select count(style) into :li_cnt 
//from tb_53060_h (nolock) 
//where empno = :gs_user_id 
//and yymmdd between convert(char(08), dateadd(day, -10, getdate()), 112) and convert(char(08), getdate(), 112)
//and out_yn = 'Y';
//
//if li_cnt > 0 then 
//	close(w_mesage_d10)
//	open(w_mesage_d10)	
//end if 

 timer(3600)//60분
Return
end event

event ue_delete;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 1999.10.06                                                  */	
/* 수성일      : 1999.11.09                                                  */
/*===========================================================================*/
Integer				li_Index
Long					ll_Parent, ll_Current, ll_pg_cnt
TreeViewItem		ltvi_Current
ListViewItem	   llvi_window
GraphicObject		lgo_Current
string            ls_Gubun, ls_Parentid, ls_WinID, ls_WinName

lgo_Current = GetFocus()

SetPointer(HourGlass!)
	li_Index = lv_1.SelectedIndex()

If li_Index <= 0 Then Return

// Get the item that was clicked
If lv_1.GetItem(li_Index, llvi_Window) = -1 Then Return

//Get the currently selected TreeView item.  It is
//the parent of this item.
ll_Parent = tv_1.FindItem(CurrentTreeItem!, 0)
tv_1.GetItem(ll_Parent, ltvi_Current)
ls_parentid = String(ltvi_Current.Data)
 
ls_WinID   = String(llvi_window.Data)
ls_WinName = String(llvi_window.Label)

SELECT count(pgm_id)
  INTO :ll_pg_cnt
  FROM tb_93030_h
 WHERE MENU_ID = :ls_Winid ;

IF ll_pg_cnt > 0 THEN
	MessageBox("경고","하위 프로그램이 존재합니다. !")
	Return
END IF
 
IF MessageBox("메뉴삭제", ls_WinName + &
               "을 메뉴에서 삭제하시겠습니까" + &
						"?", Question!, YesNo!) = 2 THEN RETURN 

DELETE FROM tb_93030_h 
	WHERE tb_93030_h.Menu_id = :ls_WinID
	   OR tb_93030_h.pgm_id  = :ls_WinID;

IF SQLCA.SQLCODE <> 0 THEN
	MessageBox("오류1", SQLCA.SQLErrText)
	ROLLBACK;
	RETURN
END IF

lv_1.DeleteItem(il_index)

IF PosA(ls_parentid, "W_") = 1 THEN 
   DELETE FROM tb_93020_m 
	 WHERE tb_93020_m.pgm_id     = :ls_WinID;
END IF	

IF SQLCA.SQLCODE <> 0 THEN
	MessageBox("오류2", SQLCA.SQLErrText)
	ROLLBACK;
	RETURN
ELSE
	COMMIT;
END IF

long             ll_item, ll_ParentItem
String           ls_WinID1
boolean          lb_Found = False
TreeViewItem     ltvi_Item

ll_Item = tv_1.FindItem(ChildTreeItem!, ll_Parent)

Do Until ( lb_Found or ll_Item < 1)
	tv_1.GetItem(ll_Item, ltvi_Item)
	ls_WinID1 = Trim(ltvi_Item.Data)
	IF ls_WinID1 = Trim(ls_WinID) Then
		lb_Found = True
	ELSE
		ll_Item = tv_1.FindItem(NextTreeItem!, ll_Item)
	END IF
Loop

If lb_Found Then
	tv_1.DeleteItem(ll_Item)
End If

ll_ParentItem = tv_1.FindItem(CurrentTreeItem!, ll_Parent)
tv_1.GetItem(ll_ParentItem, ltvi_Item)
ltvi_Item.Children = True

SetPointer(Arrow!)

end event

event ue_user_in;/*  개인메뉴의 자료를 등록한다.        */
Integer				li_Index 
ListViewItem	   llvi_window
string            ls_pg_id, ls_pg_name

li_Index = lv_1.SelectedIndex()
if (li_Index <= 0) then Return
if (lv_1.GetItem(li_Index, llvi_Window) = -1) then Return

ls_pg_id   = String(llvi_window.Data)
ls_pg_name = String(llvi_window.Label)

if (MessageBox("개인메뉴등록", ls_pg_name + "을 개인메뉴에 등록하시겠습니까?", &
		Question!, YesNo!) = 2) then Return
		
INSERT INTO tb_93030_h 
      (menu_id, 	pgm_id)
   VALUES 
      (:gs_user_id, :ls_pg_id) ;

if (SQLCA.SQLCODE<> 0) then
	MessageBox("개인메뉴등록에러", "프로그램이 등록되어 있습니다.", Exclamation!)
	ROLLBACK;
	Return 
end if

COMMIT;

end event

event ue_user_del;//  개인메뉴의 항목 삭제. 
ListViewItem	   llvi_window
Integer				li_Index //ll_item, ll_ParentItem
String            ls_pg_ID, ls_pg_nm

li_Index = lv_1.SelectedIndex()
if (li_Index <= 0) then Return

if (lv_1.GetItem(li_Index, llvi_Window) = -1) then Return

//  Table에서 Item을 삭제한다. 
ls_pg_id = String(llvi_window.Data)
ls_pg_nm = String(llvi_window.Label)

if (MessageBox("개인메뉴삭제", ls_pg_nm + "을 개인메뉴에서 삭제하시겠습니까?", &
		Question!, YesNo!) = 2) then Return
		
DELETE FROM tb_93030_h 
	WHERE menu_id = :gs_user_id
	  AND pgm_id  = :ls_pg_id ;

if (SQLCA.SQLCODE<> 0) then
	MessageBox("개인메뉴삭제오류", "윈도우명이 등록되어 있지 않습니다.", Exclamation!)
	ROLLBACK;
	Return
end if

COMMIT;

// ListView에서 Item을 삭제한다. 
lv_1.DeleteItem(li_Index)

end event

public function integer wf_refreshbars ();st_var.Setposition(ToTop!)

st_var.width = ii_barthickness

return 1
end function

public function integer wf_resizebars ();st_var.move(st_var.x, st_var.Y)
st_var.resize(ii_barthickness, st_var.Height)

wf_refreshbars()

return 1
end function

public function integer wf_resizepanels ();long    ll_width, ll_height

ll_width  = this.workspacewidth()
ll_height = this.workspaceheight()

idrg_vertical[1].resize(st_var.x - idrg_vertical[1].x, ll_height - idrg_vertical[1].y)
idrg_vertical[2].move(st_var.x + ii_barthickness, idrg_vertical[2].y)
idrg_vertical[2].resize(ll_width - idrg_vertical[2].x, ll_height - idrg_vertical[2].y)


return 1
end function

public function integer wf_retrieve_data (long al_handle);		
// *** Declare local variable **************************************************
Integer				li_Level, li_RepID, li_ret_int
String				ls_Parm 
//Long					ll_Parent
TreeViewItem		ltvi_Current   //, ltvi_Parent

// Determine the level
tv_1.GetItem(al_Handle, ltvi_Current)
li_Level = ltvi_Current.Level

// Determine the Retrieval arguments for the new data
ls_Parm = ltvi_Current.Data

// Retrieve the data
ids_Source.Reset()

li_ret_int = ids_Source.Retrieve(ls_Parm, gs_user_id)

Return li_ret_int

end function

public function integer wf_add_tv_items (long al_parent, integer ai_level, integer ai_rows);/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)														  */	
/* 작성일      : 1999.09.28																  */	
/* Description :                                                             */
/*===========================================================================*/

Long              ll_Current, ll_Person
Integer				li_Cnt
TreeViewItem		ltvi_New

For li_Cnt = 1 To ai_Rows
   if ids_Source.Object.pgm_fg[li_Cnt] = 'M' THEN
      wf_set_tv_item(ai_Level, li_Cnt, ltvi_New)
	   If ltvi_New.Data <> is_WinID Then
		   ll_Person = tv_1.InsertItemLast(al_Parent, ltvi_New)
	      If ll_Person < 1 Then
		      MessageBox("Error", "Error inserting item", Exclamation!)
		      Return -1
		   ELSEIF ai_Level = 1 AND ltvi_New.Data = gs_User_id Then
			   il_Person = ll_Person
		   End If
	   End If
	End If
Next

Return ai_Rows

end function

public subroutine wf_set_tv_item (integer ai_level, integer ai_row, ref treeviewitem atvi_new);/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)														  */	
/* 작성일      : 1999.09.28																  */	
/* Description :                                                             */
/*===========================================================================*/

IF ai_level = 1 THEN
	atvi_New.pictureindex = 1
	atvi_New.selectedpictureindex = 1
	atvi_New.children = True
ELSE
	IF ids_Source.Object.pgm_fg[ai_Row] = 'M' THEN
		atvi_New.children = True
		atvi_New.pictureindex = 2
		atvi_New.selectedpictureindex = 3
	ELSE
		atvi_New.children = False
		atvi_New.pictureindex = 4
		atvi_New.selectedpictureindex = 4
	END IF
END IF

atvi_New.Label = ids_Source.Object.pgm_nm[ai_Row]
atvi_New.Data  = ids_Source.Object.pgm_id[ai_Row]

end subroutine

public subroutine wf_set_lv_item (integer ai_level, integer ai_row, ref listviewitem alvi_new);// *** Declare local variable **************************************************
Integer	li_Picture
String	ls_div, ls_status, ls_level
String   ls_UserID
Double	ldb_Number

IF isnull(ids_Source.Object.pgm_stat[ai_Row]) THEN
	ls_status = ' '
ELSEIF ids_Source.Object.pgm_stat[ai_Row] = 'B' THEN
	ls_status = '정상'
ELSEIF ids_Source.Object.pgm_stat[ai_Row] = 'M' THEN
	ls_status = '수정'
ELSEIF ids_Source.Object.pgm_stat[ai_Row] = 'N' THEN
	ls_status = '통제'
END IF

IF isnull(ids_Source.Object.pgm_div[ai_Row]) THEN
	ls_div = ' '
ELSEIF ids_Source.Object.pgm_div[ai_Row] = 'E' THEN
	ls_div = '관리'
ELSEIF ids_Source.Object.pgm_div[ai_Row] = 'D' THEN
	ls_div = '조회'
ELSEIF ids_Source.Object.pgm_div[ai_Row] = 'B' THEN
	ls_div = 'BATCH'
END IF

ls_level = String(ids_Source.Object.pgm_level[ai_Row])
IF isnull(ls_level) THEN ls_level = " "

alvi_New.Label = ids_Source.Object.pgm_nm[ai_Row] + "~t" + &
					  ids_Source.Object.pgm_id[ai_Row] + "~t" + &
					  ls_div + "~t" + &
                 ls_status + "~t" + &
					  ls_level
					  
alvi_New.Data = ids_Source.Object.pgm_id[ai_Row]
IF ids_Source.Object.pgm_fg[ai_Row] = 'M' THEN
		alvi_New.pictureindex = 1
ELSEIF gf_run_status(gs_user_id, alvi_New.Data) = 0 THEN
		alvi_New.pictureindex = 2
ELSE
		alvi_New.pictureindex = 3
END IF

end subroutine

public function boolean wf_chk_pass (string as_pg_id);/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)       											  */	
/* 작성일      : 1999.09.28																  */	
/* 수정일      : 1999.11.11																  */	
/*===========================================================================*/
Boolean    lb_check
String     ls_pg_passwd, ls_parm

SELECT pass_wd
  INTO :ls_pg_passwd
  FROM TB_93020_M
 WHERE PGM_ID = :as_pg_id ; 

IF sqlca.sqlcode <> 0 THEN
	RETURN FALSE
END IF

IF IsNull(ls_pg_passwd) THEN  // PassWord가 NULL
	Return True
ELSE
	gst_cd.window_title = "패스워드를 입력하세요 !"
   gst_cd.data_value = ls_pg_passwd
   Open(w_93000_e)
	ls_Parm = Message.StringParm
	IF ls_Parm = 'OK' Then
		lb_check = True
	ELSEIF ls_Parm = 'NO' THEN
		MessageBox("경고", "패스워드가 정확하지 않습니다 !", Exclamation!)
		lb_check = False
	ELSE
		lb_check = False
	END IF
END IF

Return lb_check

end function

public function integer wf_add_lv_items (integer ai_level, integer ai_rows);// *** Declare local variable **************************************************
Integer				li_cnt
ListViewItem		llvi_new

// Add each item to the ListView
for li_Cnt = 1 to ai_Rows
	wf_set_lv_item(ai_level, li_cnt, llvi_new)
	if (lv_1.AddItem(llvi_New) < 1 ) then
		MessageBox("Error", "Error adding item to the ListView", Exclamation!)
		Return -1
	end if
next

Return ai_Rows

end function

public function boolean wf_open_sheet (string as_win_id, string as_win_name, string as_parent_id);Window		lw_sheet_window
Boolean		lb_bValid, lb_isValid, lb_is_active
Long			ll_parent, handle
String		ls_msg, ls_class_name
integer     li_ret

TreeViewItem	ltvi_Window

SetPointer(HourGlass!)
/* Sheet의 Open여부를 확인한다. */
lb_isValid = FALSE

lw_sheet_window = This.ParentWindow().GetFirstSheet()
if (IsValid(lw_sheet_window)) then
	ls_class_name = lw_sheet_window.ClassName() 
	if (upper(ls_class_name) = as_win_id) then
		lb_isValid = TRUE
	else
		do
			lw_sheet_window = This.ParentWindow().GetNextSheet(lw_sheet_window)
			lb_bValid = IsValid (lw_sheet_window)
			if (lb_bValid) then
				ls_class_name = lw_sheet_window.ClassName() 
				if (upper(ls_class_name) = as_win_id) then
					lb_isValid = TRUE
					Exit
				end if
			end if
		loop while lb_bValid
	end if
end if

// *** Sheet의 Activate,Open한다. **********************************************
if (lb_isValid) then
	if (lw_sheet_window.Windowstate = Minimized!) then
		lw_sheet_window.Windowstate = Maximized!
	end if
	lw_sheet_window.SetFocus()
else
	ltvi_Window.Label = as_win_name 
	ltvi_Window.Data  = as_win_id
	gs_menu_id			= as_parent_id
	// SheetWindow를 Open한다.
	IF wf_chk_pass(as_win_id) THEN
      li_ret = OpenSheetWithParm(lw_sheet_window, ltvi_Window, as_win_id, &
			   	                  This.ParentWindow(), gi_menu_pos, Original!)
	END IF 
end if

SetPointer(Arrow!)
return TRUE

end function

on w_menu01.create
int iCurrent
call super::create
this.tv_1=create tv_1
this.lv_1=create lv_1
this.st_var=create st_var
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_1
this.Control[iCurrent+2]=this.lv_1
this.Control[iCurrent+3]=this.st_var
end on

on w_menu01.destroy
call super::destroy
destroy(this.tv_1)
destroy(this.lv_1)
destroy(this.st_var)
end on

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 1999.10.06                                                  */	
/* 수성일      : 1999.10.06                                                  */
/*===========================================================================*/
of_SetResize(True)

inv_resize.of_Register(tv_1, "ScaleToBottom")
inv_resize.of_Register(lv_1, "ScaleToRight&Bottom")
inv_resize.of_Register(st_var, "ScaleToBottom")

This.ParentWindow().Trigger ArrangeSheets(Layer!)

idrg_Vertical[1] = tv_1
idrg_Vertical[2] = lv_1

il_HiddenColor = This.BackColor
st_var.BackColor = il_HiddenColor





end event

event open;call super::open;/*===========================================================================*/
/* 작성자      : 지우정보(김 태범)                                           */	
/* 작성일      : 1999.10.06                                                  */	
/* 수성일      : 1999.10.06                                                  */
/*===========================================================================*/
long li_cnt

ids_Source 					= Create DataStore
ids_Source.DataObject 	= "d_menu01_d01"
ids_Source.SetTransObject(SQLCA)

// *** Populate first level ****************************************************

This.Post Event ue_populate()
trigger event ue_refresh()


select count(style) into :li_cnt 
from tb_53060_h (nolock) 
where empno = :gs_user_id 
and yymmdd between convert(char(08), dateadd(day, -3, getdate()), 112) and convert(char(08), getdate(), 112)
and out_yn = 'Y';

if li_cnt > 0 then 
	close(w_mesage_d10)
	open(w_mesage_d10)	
end if 


end event

event close;call super::close;DESTROY ids_Source

/* 프로그램 나갈때 시간 체크 */
gf_user_connect_pgm(gs_user_id,"%","0")



end event

event key;call super::key;IF KeyDown(KeyF5!) THEN
	
	trigger event ue_refresh()
//	close(w_mesage_d)
//	open(w_mesage_d)
//
//	close(w_mesage_d2)
//	open(w_mesage_d2)
//
//	close(w_mesage_d3)
//	open(w_mesage_d3)
//
//	close(w_mesage_d4)
//	open(w_mesage_d4)
//
//	close(w_mesage_d5)
//	open(w_mesage_d5)
//
//	close(w_mesage_d6)
//	open(w_mesage_d6)
//
//	close(w_mesage_d7)
//	open(w_mesage_d7)
//
//	close(w_mesage_d8)
//	open(w_mesage_d8)
//	
//	close(w_mesage_d9)
//	open(w_mesage_d9)	
//	
//	close(w_mesage_d10)
//	open(w_mesage_d10)
//	
////	close(w_mesage_d11)
////	open(w_mesage_d11)
//	
//	close(w_mesage_d12)
//	open(w_mesage_d12)
//	
//	close(w_mesage_d13)
//	open(w_mesage_d13)	
//	
//	close(w_mesage_d14)
//	open(w_mesage_d14)	
	
	
end if
end event

event timer;call super::timer;trigger event ue_refresh()

end event

type tv_1 from u_tv within w_menu01
integer x = 18
integer y = 24
integer width = 978
integer height = 1996
integer taborder = 10
boolean dragauto = true
integer textsize = -10
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean linesatroot = true
boolean disabledragdrop = false
boolean hideselection = false
string picturename[] = {"Custom087!","Custom039!","Custom050!","Window!"}
long picturemaskcolor = 12632256
long statepicturemaskcolor = 553648127
end type

event itemexpanding;//
end event

event itempopulate;call super::itempopulate;/*===========================================================================*/
/* Company     : (주) MSI     															  */	
/* 작성자      : 김 태 범																	  */	
/* 작성일      : 1999.09.28																  */	
/* Description : TreeView에서 ChildItem을 Populate한다.                      */
/*===========================================================================*/

// Populate the tree with this item's children
Integer				li_Rows, li_Level
Long              ll_Parent
String            ls_msg, ls_win_id, ls_parent_id
TreeViewItem		ltvi_Current, ltvi_Parent

// *** Determine the level
GetItem(handle, ltvi_Current)
li_Level = ltvi_Current.Level

// *** Retrieve the data & Add items to TreeView *******************************
if (ltvi_Current.children = FALSE) then return

SetPointer(HourGlass!)
li_Rows = wf_retrieve_data(handle)
wf_add_tv_items(handle, li_Level + 1, li_Rows)
SetPointer(Arrow!)

end event

event selectionchanged;call super::selectionchanged;// *** Declare local variable **************************************************
Long              ll_Parent, ll_Parent1, ll_Parent2
String            ls_msg, ls_parent_id, ls_win_id
Integer				li_Rows, li_Level
TreeViewItem		ltvi_current_new, ltvi_current_old, ltvi_parent_new, ltvi_parent_old

// *** Determine the level. ****************************************************
GetItem(newhandle, ltvi_current_new)
GetItem(oldhandle, ltvi_current_old)

li_Level = ltvi_current_new.Level

if (li_Level = 1) Then
   il_ParentTarget = newhandle
end if

// *** New의 항목이 Child를 가지지 않으면, DataStore의 상위항목을 가져온다. ****
if ltvi_current_new.children = FALSE then
	ll_Parent = tv_1.FindItem(ParentTreeItem!, newhandle)
	IF il_Parent = ll_parent then Return
	il_Parent    = ll_parent
   li_Rows = wf_retrieve_data(ll_Parent)
// *** New의 항목이 Child를 가지고 있으면, DataStore의 현재항목을 가져온다. ****
else
   ltvi_Current_new.hasfocus = True
   li_Rows = wf_retrieve_data(newhandle)
	il_Parent    = newhandle
end if

// *** ListView의 항목을 갱신한다. *********************************************
SetPointer(HourGlass!)
lv_1.DeleteItems()
wf_add_lv_items(li_Level + 1, li_Rows)
SetPointer(Arrow!)

end event

type lv_1 from u_lv within w_menu01
integer x = 1029
integer y = 24
integer width = 2542
integer height = 1996
integer taborder = 20
integer textsize = -10
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 1090519039
listviewview view = listviewreport!
string largepicturename[] = {"Custom039!","Window!","Error!"}
long largepicturemaskcolor = 12632256
string smallpicturename[] = {"Custom039!","Window!","Error!"}
long smallpicturemaskcolor = 12632256
end type

event rbuttonup;//

end event

event doubleclicked;call super::doubleclicked;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)    												  */	
/* 작성일      : 1999.09.28																  */	
/* 수정일      : 2001.10.04																  */	
/*===========================================================================*/
Integer           li_expend
Long					ll_Parent, ll_Item
Boolean				lb_Found
TreeViewItem		ltvi_Item, ltvi_Parent
ListViewItem		llvi_window

if (index <= 0) then Return

if (This.GetItem(index, llvi_window) = -1) then Return


ll_Parent = tv_1.FindItem(CurrentTreeItem!, 0)
tv_1.GetItem(ll_Parent, ltvi_Parent)

ib_lvpass = True      //tv_1의 Itempopulate MessageBox Not Open
if llvi_window.pictureindex = 1 then tv_1.ExpandItem (ll_Parent)

// ListView 선택된 Item 을 TreeView에서 Finditem
ll_Item = tv_1.FindItem(ChildTreeItem!, ll_Parent)
if (ll_item = -1) then
	lb_Found = FALSE
else
   do until (lb_Found or ll_Item < 1)
	   tv_1.GetItem(ll_Item, ltvi_Item)
	   if (PosA(ltvi_Item.Data, llvi_window.Data) > 0) then
		   lb_Found = True
	   else
		   ll_Item = tv_1.FindItem(NextTreeItem!, ll_Item)
	      lb_Found = FALSE
	   end if
   loop
end if	


// TreeViewItem에 존재하면 SelectItem한다. 
if (lb_Found) then	tv_1.SelectItem(ll_Item)

// 메뉴이면 Return 한다.
if llvi_window.pictureindex = 1 then return

if llvi_window.pictureindex = 3 then
   MessageBox("경고","프로그램 권한이 없습니다.")
	return
end if

wf_open_sheet (llvi_window.data, llvi_window.label, ltvi_Parent.data)

/* 프로그램 들어갈때 시간 체크 */
gf_user_connect_pgm(gs_user_id,string(llvi_window.data),"1")


end event

event rightclicked;call super::rightclicked;/*===========================================================================*/
/* 작성자      : 지우정보(김 태범)														  */	
/* 작성일      : 1999.09.28																  */	
/* Description : 오른쪽 마우스 Popup Menu                                    */
/*===========================================================================*/
boolean	lb_frame
integer	li_rc, li_index, li_width
Long		ll_Parent,ll_Current
string	ls_label, ls_parentid, ls_WinID, ls_flag
TreeViewItem	ltvi_Current
ListViewItem	llvi_window

alignment	le_align
window		lw_parent
window		lw_frame
m_2_0000    lm_view

// Determine parent window for PointerX, PointerY offset
this.of_GetParentWindow (lw_parent)
if IsValid (lw_parent) then
	// Get the MDI frame window if available
	lw_frame = lw_parent
	do while IsValid (lw_frame)
		if lw_frame.windowtype = mdi! or lw_frame.windowtype = mdihelp! then
			lb_frame = true
			exit
		else
			lw_frame = lw_frame.ParentWindow()
		end if
	loop
	if lb_frame then
		lw_parent = lw_frame
	end if
else
	return 1
end if

// Create popup menu
if not IsValid (lm_view) then
	lm_view = create m_2_0000
	lm_view.of_SetParent (this)
end if

// Set the values of the Arrange Items submenu
li_index = 1
li_rc = GetColumn (li_index, ls_label, le_align, li_width)
do while li_rc = 1
	if li_index >=1 and li_index <= 10 then
		lm_view.m_viewitem.m_arrangeicons.item[li_index].text =  ls_label
		lm_view.m_viewitem.m_arrangeicons.item[li_index].microhelp = "Sorts items by " + ls_label
		lm_view.m_viewitem.m_arrangeicons.item[li_index].visible = true
	end if
	li_index++
	li_rc = GetColumn (li_index, ls_label, le_align, li_width)
loop

// Determine if the Auto Arrange Icons item should be enabled
if this.view = ListViewLargeIcon! or this.view = ListViewSmallIcon! then
	lm_view.m_viewitem.m_arrangeicons.m_autoarrange.enabled = true
	lm_view.m_viewitem.m_arrangeicons.m_autoarrange.checked = this.autoarrange
else
	lm_view.m_viewitem.m_arrangeicons.m_autoarrange.enabled = false
	lm_view.m_viewitem.m_arrangeicons.m_autoarrange.checked = false
end if

lm_view.m_viewitem.m_menu.enabled   = False
lm_view.m_viewitem.m_update.enabled = False 
lm_view.m_viewitem.m_delete.Enabled = False

ll_Parent = tv_1.FindItem(CurrentTreeItem!, 0)
tv_1.GetItem(ll_Parent, ltvi_Current)
ls_parentid = String(ltvi_Current.Data)
lv_1.GetItem(Index, llvi_Window)
ls_WinID    = String(llvi_Window.Data)
SELECT pgm_fg
  INTO :ls_flag
  FROM TB_93020_M
 WHERE pgm_id = :ls_winid;
 
IF isnull(ls_flag) OR trim(ls_flag) = "" THEN
   ls_flag = 'M'
END IF

/* 등급이 999만 메뉴 등록, 수정, 삭제가 가능함 */
if gl_user_level = 999 then
	lm_view.m_viewitem.m_menu.enabled   = TRUE 
	lm_view.m_viewitem.m_update.enabled = TRUE 
	lm_view.m_viewitem.m_delete.Enabled = TRUE 
end if

/* 개인 메뉴 이면 메뉴등록, 수정 삭제 불가 */
IF ls_parentid = gs_user_id then
	lm_view.m_viewitem.m_menu.enabled = False
	lm_view.m_viewitem.m_update.enabled = False
	lm_view.m_viewitem.m_delete.Enabled = False
   lm_view.m_viewitem.m_personitem.enabled = False
   lm_view.m_viewitem.m_person_del.enabled = True
ELSE
   lm_view.m_viewitem.m_personitem.enabled = True
   lm_view.m_viewitem.m_person_del.enabled = False
END IF

/* 프로그램만 개인 메뉴에 추가 가능 */
IF ls_flag <> 'W' THEN
   lm_view.m_viewitem.m_personitem.enabled = False
   lm_view.m_viewitem.m_person_del.enabled = False
END IF

If il_RightClicked <= 0 Then
	lm_view.m_viewitem.m_update.enabled = False
	lm_view.m_viewitem.m_delete.Enabled = False
   lm_view.m_viewitem.m_personitem.enabled = False
   lm_view.m_viewitem.m_person_del.enabled = False
End If

il_index = il_RightClicked

this.event pfc_prermbmenu (lm_view)
lm_view.m_viewitem.PopMenu (lw_parent.PointerX() + 5, lw_parent.PointerY() + 10)

If IsValid(lm_View) Then Destroy lm_View

return 1

end event

type st_var from u_st within w_menu01
event ue_mousedown pbm_lbuttondown
event ue_mousemove pbm_mousemove
event ue_mouseup pbm_lbuttonup
integer x = 1001
integer y = 24
integer width = 27
integer height = 1996
string dragicon = "Exclamation!"
string pointer = "SizeWE!"
long backcolor = 8388608
boolean enabled = true
string text = ""
end type

event ue_mousedown;call super::ue_mousedown;ib_moveinprogress = True
end event

event ue_mousemove;call super::ue_mousemove;IF ib_moveinprogress THEN
	wf_refreshbars()
	IF Not ib_debug THEN This.Backcolor = 0
	IF This.x < idrg_vertical[1].x + ii_min_left_space THEN
	   This.x = idrg_vertical[1].x + ii_min_left_space		
	ELSEIF This.x > idrg_vertical[2].x + idrg_vertical[2].width - ii_min_right_space THEN
		This.x = idrg_vertical[2].x + idrg_vertical[2].width - ii_min_right_space
	ELSE
		This.x = parent.pointerx()
	END IF
END IF

end event

event ue_mouseup;call super::ue_mouseup;IF NOT ib_debug THEN this.backcolor = il_hiddencolor

IF This.x < idrg_vertical[1].x + 100 THEN
   This.x = idrg_vertical[1].x + 100
ELSEIF This.x > idrg_vertical[2].x + idrg_vertical[2].width - 200 THEN
	This.x = idrg_vertical[2].x + idrg_vertical[2].width - 200
END IF
	
wf_resizebars()
wf_resizepanels()

ib_moveinprogress =False
end event

