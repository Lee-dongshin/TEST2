$PBExportHeader$w_mesage_d13.srw
$PBExportComments$검단 결과확인
forward
global type w_mesage_d13 from w_com010_d
end type
type dw_rpt from u_dw within w_mesage_d13
end type
end forward

global type w_mesage_d13 from w_com010_d
boolean visible = false
integer width = 1147
integer height = 1116
string title = "검단 결과확인※ F5 : 새로고침"
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
event type long ue_refresh ( string as_brand,  string as_person_id )
event ue_first_open ( )
dw_rpt dw_rpt
end type
global w_mesage_d13 w_mesage_d13

type variables
long il_body_row
end variables

event type long ue_refresh(string as_brand, string as_person_id);long ll_rows

ll_rows = dw_body.retrieve(as_brand, as_person_id)

if ll_rows > 0 then
	this.visible = true
else
	this.visible = false
end if

return ll_rows

end event

event pfc_preopen();call super::pfc_preopen;this.x = 2055
this.y = 500

trigger event ue_refresh(gs_brand, gs_user_id)
dw_rpt.SetTransObject(SQLCA)


end event

on w_mesage_d13.create
int iCurrent
call super::create
this.dw_rpt=create dw_rpt
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_rpt
end on

on w_mesage_d13.destroy
call super::destroy
destroy(this.dw_rpt)
end on

event timer;call super::timer;//il_rows = dw_body.retrieve(gs_brand, gs_user_id)
//
//if il_rows > 0 then
//	this.visible = true
//else
//	this.visible = false
//end if
//
end event

type cb_close from w_com010_d`cb_close within w_mesage_d13
boolean visible = false
end type

type cb_delete from w_com010_d`cb_delete within w_mesage_d13
integer x = 3337
integer y = 484
end type

type cb_insert from w_com010_d`cb_insert within w_mesage_d13
integer x = 3072
integer y = 484
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_mesage_d13
boolean visible = false
integer x = 3483
end type

type cb_update from w_com010_d`cb_update within w_mesage_d13
integer x = 3113
integer y = 480
end type

type cb_print from w_com010_d`cb_print within w_mesage_d13
boolean visible = false
integer x = 3072
integer y = 484
end type

type cb_preview from w_com010_d`cb_preview within w_mesage_d13
boolean visible = false
integer x = 3415
integer y = 484
end type

type gb_button from w_com010_d`gb_button within w_mesage_d13
boolean visible = false
integer x = 3611
integer y = 264
integer width = 713
end type

type cb_excel from w_com010_d`cb_excel within w_mesage_d13
boolean visible = false
integer x = 3758
integer y = 484
end type

type dw_head from w_com010_d`dw_head within w_mesage_d13
boolean visible = false
integer x = 2981
integer y = 196
integer width = 2811
end type

type ln_1 from w_com010_d`ln_1 within w_mesage_d13
boolean visible = false
integer beginx = 2912
integer beginy = 916
integer endx = 6533
integer endy = 916
end type

type ln_2 from w_com010_d`ln_2 within w_mesage_d13
boolean visible = false
integer beginx = 2907
integer beginy = 920
integer endx = 6528
integer endy = 920
end type

type dw_body from w_com010_d`dw_body within w_mesage_d13
event type long ue_insert ( )
event ue_update ( string as_fin_yn )
event ue_kedown pbm_dwnkey
integer y = 4
integer width = 1125
integer height = 996
string title = "F5 : 새로고침"
string dataobject = "d_message_013"
boolean minbox = true
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

event dw_body::ue_update(string as_fin_yn);string ls_insert, ls_delete
ls_insert = "출고등록 하시겠습니까?"
ls_delete = "출고취소 하시겠습니까?"

if as_fin_yn = 'Y' then
	if messagebox("확인",ls_insert, Exclamation!, OKCancel! ,2) = 2 then 
		this.setitem(this.getrow(),"fin_yn","N")
		return
	end if
	
else
	if messagebox("확인",ls_delete, Exclamation!, OKCancel! ,2) = 2 then
		this.setitem(this.getrow(),"fin_yn","Y")
		return
	end if		
end if
trigger event ue_insert()
//parent.post event ue_preview()
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

CHOOSE CASE key
	CASE KeyF5!	// refresh
		parent.trigger event ue_refresh(gs_brand, gs_user_id)
		
	CASE KeyF9!	// print
		parent.trigger event ue_preview()

	CASE KeyF12!	// print
		parent.trigger event ue_print()
		
END CHOOSE

end event

event dw_body::clicked;call super::clicked;if row > 0 then il_body_row = row

choose case dwo.name
	case "b_refresh"
		parent.trigger event ue_refresh(gs_brand, gs_user_id)
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

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

event dw_body::buttonclicked;call super::buttonclicked;string ls_sample_cd, ls_qry
int Net, li_token
choose case dwo.name
	case "b_refresh"
		trigger event ue_refresh(gs_brand, gs_user_id)
	case "b_yes"		
		Net = MessageBox("확인", "완료처리 하시겠습니까?" , Exclamation!, OKCancel!, 2)
		
		IF Net = 1 THEN
			ls_sample_cd = this.getitemstring(row,"sample_cd")
			li_token = this.getitemnumber(row,"token")
			
			choose case li_token
				case 0
					update a set
					time_0 = getdate(),
					mod_id = :gs_user_id,
					mod_dt = getdate()
					from tb_31031_m a(nolock)
					where sample_cd = :ls_sample_cd;
				case 1
					update a set
					time_1 = getdate(),
					mod_id = :gs_user_id,
					mod_dt = getdate()
					from tb_31031_m a(nolock)
					where sample_cd = :ls_sample_cd;
				case 2
					update a set
					time_2 = getdate(),
					mod_id = :gs_user_id,
					mod_dt = getdate()
					from tb_31031_m a(nolock)
					where sample_cd = :ls_sample_cd;
				case 3
					update a set
					time_3 = getdate(),
					mod_id = :gs_user_id,
					mod_dt = getdate()
					from tb_31031_m a(nolock)
					where sample_cd = :ls_sample_cd;					
				case 4
					update a set
					time_4 = getdate(),
					mod_id = :gs_user_id,
					mod_dt = getdate()
					from tb_31031_m a(nolock)
					where sample_cd = :ls_sample_cd;
				case 5
					update a set
					time_5 = getdate(),
					mod_id = :gs_user_id,
					mod_dt = getdate()
					from tb_31031_m a(nolock)
					where sample_cd = :ls_sample_cd;
				case 6
					update a set
					time_6 = getdate(),
					mod_id = :gs_user_id,
					mod_dt = getdate()
					from tb_31031_m a(nolock)
					where sample_cd = :ls_sample_cd;
				case 7
					update a set
					time_7 = getdate(),
					mod_id = :gs_user_id,
					mod_dt = getdate()
					from tb_31031_m a(nolock)
					where sample_cd = :ls_sample_cd;
				case 8
					update a set
					time_8 = getdate(),
					mod_id = :gs_user_id,
					mod_dt = getdate()
					from tb_31031_m a(nolock)
					where sample_cd = :ls_sample_cd;
				case 9
					update a set
					time_9 = getdate(),
					mod_id = :gs_user_id,
					mod_dt = getdate()
					from tb_31031_m a(nolock)
					where sample_cd = :ls_sample_cd;
					
			end choose
			commit  USING SQLCA;
			
			trigger event ue_refresh(gs_brand, gs_user_id)
		END IF

end choose
end event

event dw_body::doubleclicked;call super::doubleclicked;String 	ls_search
if row > 0 then 
	ls_search = this.getitemstring(row,"mat_cd") + this.getitemstring(row,"color")
	OpenWithParm(w_22015_e, ls_search)	
	w_22015_e.dw_head.setitem(1,"mat_cd", LeftA(ls_search,10))

	w_22015_e.dw_head.GetChild("color", w_22015_e.idw_color)
	w_22015_e.idw_color.SetTransObject(SQLCA)
	w_22015_e.idw_color.Retrieve(LeftA(ls_search,10))

	w_22015_e.dw_body.GetChild("color", w_22015_e.idw_color)
	w_22015_e.idw_color.SetTransObject(SQLCA)
	w_22015_e.idw_color.Retrieve(LeftA(ls_search,10))

	w_22015_e.dw_head.setitem(1,"color", RightA(ls_search,2))
	w_22015_e.trigger event ue_retrieve()			
end if
end event

type dw_print from w_com010_d`dw_print within w_mesage_d13
integer x = 2958
integer y = 596
end type

type dw_rpt from u_dw within w_mesage_d13
boolean visible = false
integer x = 2926
integer y = 656
integer width = 1038
integer height = 380
integer taborder = 60
boolean bringtotop = true
boolean hscrollbar = true
end type

event constructor;call super::constructor;This.of_SetPrintPreview(TRUE)
end event

