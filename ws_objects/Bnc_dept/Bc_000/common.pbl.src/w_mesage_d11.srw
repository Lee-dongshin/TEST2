$PBExportHeader$w_mesage_d11.srw
$PBExportComments$원가변경 비교
forward
global type w_mesage_d11 from w_com010_d
end type
end forward

global type w_mesage_d11 from w_com010_d
integer width = 2711
integer height = 2252
string title = "원가변경 비교확정"
string menuname = ""
boolean minbox = false
boolean maxbox = false
windowtype windowtype = popup!
event type long ue_refresh ( string as_person_id )
event ue_first_open ( )
end type
global w_mesage_d11 w_mesage_d11

type variables
long il_body_row
end variables

event pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
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
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
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




this.x = 1155
this.y = 300

dw_body.retrieve(gsv_cd.gs_cd10)

gsv_cd.gs_cd10 = ''
end event

on w_mesage_d11.create
call super::create
end on

on w_mesage_d11.destroy
call super::destroy
end on

type cb_close from w_com010_d`cb_close within w_mesage_d11
boolean visible = false
end type

type cb_delete from w_com010_d`cb_delete within w_mesage_d11
integer x = 3337
integer y = 484
end type

type cb_insert from w_com010_d`cb_insert within w_mesage_d11
integer x = 3072
integer y = 484
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_mesage_d11
boolean visible = false
integer x = 3483
end type

type cb_update from w_com010_d`cb_update within w_mesage_d11
integer x = 3113
integer y = 480
end type

type cb_print from w_com010_d`cb_print within w_mesage_d11
integer x = 3072
integer y = 484
boolean enabled = true
end type

type cb_preview from w_com010_d`cb_preview within w_mesage_d11
integer x = 18
integer y = 4
boolean enabled = true
end type

type gb_button from w_com010_d`gb_button within w_mesage_d11
boolean visible = false
integer x = 3611
integer y = 264
integer width = 713
end type

type cb_excel from w_com010_d`cb_excel within w_mesage_d11
boolean visible = false
integer x = 3758
integer y = 484
end type

type dw_head from w_com010_d`dw_head within w_mesage_d11
boolean visible = false
integer x = 3182
integer y = 208
integer width = 2811
end type

type ln_1 from w_com010_d`ln_1 within w_mesage_d11
boolean visible = false
integer beginx = 2912
integer beginy = 916
integer endx = 6533
integer endy = 916
end type

type ln_2 from w_com010_d`ln_2 within w_mesage_d11
boolean visible = false
integer beginx = 2907
integer beginy = 920
integer endx = 6528
integer endy = 920
end type

type dw_body from w_com010_d`dw_body within w_mesage_d11
event type long ue_insert ( )
event ue_update ( string as_fin_yn )
event ue_kedown pbm_dwnkey
integer x = 9
integer y = 100
integer width = 2661
integer height = 2012
string dataobject = "d_message_011"
boolean hscrollbar = true
boolean ib_rmbmenu = false
end type

event type long dw_body::ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
				
string ls_brand, ls_mat_cd, ls_color, ls_cust_cd, ls_out_ymd, ls_out_no, ls_flag, ls_req_ymd, ls_fin_yn, ls_person_id
decimal ldc_qty
int		li_req_no

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF



FOR i=1 TO ll_row_count
	idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	
   IF idw_status = DataModified! THEN		/* Modify Record */
   	   dw_body.Setitem(i, "mod_id", gs_user_id)
	      dw_body.Setitem(i, "mod_dt", ld_datetime)

			ls_brand   = dw_body.getitemstring(i,"brand")
			ls_req_ymd = dw_body.getitemstring(i,"req_ymd")
			li_req_no  = dw_body.getitemnumber(i,"req_no")			
			ls_mat_cd  = dw_body.getitemstring(i,"mat_cd")
			ls_color   = dw_body.getitemstring(i,"color")
			ldc_qty    = dw_body.getitemnumber(i,"qty")
			ls_cust_cd = dw_body.getitemstring(i,"cust_cd")
			ls_out_ymd = dw_body.getitemstring(i,"out_ymd")
			ls_out_no  = dw_body.getitemstring(i,"out_no")
			ls_fin_yn  = dw_body.getitemstring(i,"fin_yn")

			ls_person_id  = dw_body.getitemstring(i,"person_id")
			
			
			if ls_fin_yn = 'Y' and isnull(ls_out_ymd) then
				ls_flag = "New"

				select right('0000' + convert(varchar(3),isnull(max(out_no),'0000') + 1),4) 
					into :ls_out_no
					from tb_22020_h (nolock)
					where brand = :ls_brand
					and   out_ymd = convert(char(8),getdate(),112);
					
			elseif ls_fin_yn = 'N' and not isnull(ls_out_ymd) then 
				ls_flag = "Del"
			end if
	

			declare sp_mat_sample_out procedure for sp_mat_sample_out
				@brand		= :ls_brand,
				@req_ymd		= :ls_req_ymd,
				@req_no		= :li_req_no,
				@mat_cd		= :ls_mat_cd,
				@color		= :ls_color,
				@qty			= :ldc_qty,
				@cust_cd		= :ls_cust_cd,	
				@out_ymd		= :ls_out_ymd,
				@out_no		= :ls_out_no,			
				@person_id	= :ls_person_id,
				@flag			= :ls_flag;
				
			execute 	sp_mat_sample_out;

   END IF
NEXT

	
if sqlca.sqlcode <> 0 then
	il_rows = dw_body.Update(TRUE, FALSE)
	if il_rows = 1 then   
		dw_body.ResetUpdate()	
		commit  USING SQLCA;
	else
		rollback  USING SQLCA;
	end if
	Trigger Event ue_retrieve()	//조회
else
   rollback  USING SQLCA;
end if


return il_rows

end event

event dw_body::ue_kedown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF


end event

event dw_body::clicked;call super::clicked;string ls_style_no, ls_style, ls_chno
pointer oldpointer // Declares a pointer variable

if row > 0 then il_body_row = row

choose case dwo.name
	case "cb_apply"
			
			if messagebox("확인","원가에 적용하시겠습니까?...",Exclamation!,YesNoCancel!,1 ) <> 1 then return
			

oldpointer = SetPointer(HourGlass!)

			ls_style_no = this.getitemstring(1,"style_no")
			ls_chno  = RightA(ls_style_no,1)
			ls_style = LeftA(ls_style_no,8)

IF dw_body.AcceptText() <> 1 THEN RETURN -1			
il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if	

			
			 DECLARE sp_wonga_apply PROCEDURE FOR sp_wonga_apply  
						@style = :ls_style,   
						@chno  = :ls_chno,
						@user_id = :gs_user_id;
						
			execute sp_wonga_apply;	
			
			commit  USING SQLCA;
			

			
			messagebox("확인","정상처리되었슴니다...")
SetPointer (oldpointer)

end choose
end event

event dw_body::itemchanged;call super::itemchanged;choose case dwo.name
	case 'fin_yn'
		post event ue_update(data)
end choose

end event

event dw_body::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

//FOR i=1 TO li_column_count
//	ls_column_name = This.Describe('#' + String(i) + '.Name')
//	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
//		ls_modify   = ls_modify + ls_column_name + &
//		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
//	END IF
//NEXT
//
//This.Modify(ls_modify)
end event

type dw_print from w_com010_d`dw_print within w_mesage_d11
boolean visible = true
integer x = 2958
integer y = 596
string dataobject = "d_message_r11"
end type

