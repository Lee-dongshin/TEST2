$PBExportHeader$w_sh162_e.srw
$PBExportComments$부분RT확인및 점간처리
forward
global type w_sh162_e from w_com010_e
end type
type st_1 from statictext within w_sh162_e
end type
end forward

global type w_sh162_e from w_com010_e
long backcolor = 16777215
st_1 st_1
end type
global w_sh162_e w_sh162_e

type variables
string is_fr_ymd, is_to_ymd, is_yymmdd
end variables

forward prototypes
public function boolean wf_rt_chk (long al_row)
public subroutine wf_push (string as_shop_cd, string as_yymmdd, string as_to_shop_cd)
end prototypes

public function boolean wf_rt_chk (long al_row);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String ls_style, ls_chno, ls_color,  ls_size, ls_given_fg, ls_given_ymd
String ls_brand, ls_plan_yn  , ls_shop_type, ls_to_shop_cd
Long   ll_move_qty, ll_move_qty_2, ll_move_qty_3


ls_style 		= dw_body.getitemstring(al_row, "style")
ls_color 		= dw_body.getitemstring(al_row, "color")
ls_size  		= dw_body.getitemstring(al_row, "size")
ls_to_shop_cd	= dw_body.getitemstring(al_row, "to_shop_cd")
ll_move_qty_3	= dw_body.getitemNumber(al_row, "move_qty")

	Select isnull(sum(isnull(move_qty,0)),0)
	  into :ll_move_qty
	  from tb_54013_h with (nolock)
	 where datepart(week, yymmdd ) = case when datepart(week, yymmdd ) - datepart(week, :is_yymmdd) = -1 and datepart(week, dateadd(day, -1, :is_yymmdd)) = datepart(week, yymmdd )
													then datepart(week, :is_yymmdd) -1
													 else datepart(week, :is_yymmdd) end	
		and yymmdd like substring(:is_yymmdd, 1,4) + '%'
	 	and style = :ls_style 
		and color = :ls_color 
		and size  = :ls_size
		and to_shop_cd = :ls_to_shop_cd
		and fr_shop_cd = :gs_shop_cd;

	IF SQLCA.SQLCODE <> 0 THEN 
		Return False 
	END IF

	IF IsNull(ll_move_qty) or ll_move_qty = 0 THEN 
			Return False 
	else		
		
		Select isnull(sum(isnull(move_qty,0)),0)
		into :ll_move_qty_2
		from tb_53020_h with (nolock)
		where datepart(week, fr_ymd ) = case when datepart(week, fr_ymd ) - datepart(week, :is_yymmdd) = -1 and datepart(week, dateadd(day, -1, :is_yymmdd)) = datepart(week, fr_ymd )
													then datepart(week, :is_yymmdd) -1
													 else datepart(week, :is_yymmdd) end
		and fr_ymd like substring(:is_yymmdd, 1,4) + '%'
		and style = :ls_style 
		and color = :ls_color 
		and size  = :ls_size
		and to_shop_cd = :ls_to_shop_cd
		and fr_shop_cd = :gs_shop_cd
		and rt_yn = 'Y'	;
		
		IF SQLCA.SQLCODE <> 0 THEN 
			Return False 
		END IF
		
		if ll_move_qty_2 + ll_move_qty_3 > ll_move_qty then 
			messagebox("경고!", "지시한 수량 이상 등록 할 수 없습니다!")
			Return False 
		end if	
		
	END IF


	Return True

end function

public subroutine wf_push (string as_shop_cd, string as_yymmdd, string as_to_shop_cd);string ls_shop_nm, ls_title, ls_content, ls_url, ls_to_id

gf_shop_nm(as_shop_cd,'S',ls_shop_nm)

ls_title = MidA(as_yymmdd,1,4) + '/' + MidA(as_yymmdd,5,2) + '/' + MidA(as_yymmdd,7,2) + ' 지시RT가 등록 되었습니다.'
ls_content = MidA(as_yymmdd,1,4) + '/' + MidA(as_yymmdd,5,2) + '/' + MidA(as_yymmdd,7,2) + ' ' + ls_shop_nm + ' 매장으로 부터 지시RT가 등록 되었습니다.'
ls_url = 'RTSTORE||'+as_to_shop_cd+'||' 
ls_to_id = as_to_shop_cd

gf_push(ls_title, ls_content, ls_url, ls_to_id)
end subroutine

on w_sh162_e.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_sh162_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;string ls_title
INT li_date_diff

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
IF MidA(GS_SHOP_CD,3,4) = '2000' THEN 
	messagebox("참고!", "정상 매장에서 사용이 가능합니다!")
   RETURN FALSE
end if	

//IF GS_SHOP_CD = 'NG0009' or GS_SHOP_CD =  'NG1141' THEN 
//else	
//	messagebox("참고!", "테스트 대상 매장에서 사용이 가능합니다!")
//   RETURN FALSE
//end if	

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if


is_fr_ymd   = dw_head.GetItemString(1, "fr_ymd")
is_to_ymd   = dw_head.GetItemString(1, "to_ymd") 


select datediff(day, :is_fr_ymd, :is_to_ymd)
into :li_date_diff
from dual;



if is_fr_ymd > is_to_ymd then
	MessageBox(ls_title,"마지막일자가 시작일자보다 작습니다.")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

if li_date_diff > 15 then
	MessageBox(ls_title,"2주 이상은 조회할수 없습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

//IF DaysAfter(dw_head.GetItemDate(1, "fr_ymd"), dw_head.GetItemDate(1, "to_ymd")) > 15 THEN
//   MessageBox(ls_title,"2주 이상은 조회할수 없습니다!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("to_ymd")
//   return false
//end if
//
//is_fr_ymd = String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
//is_to_ymd = String(dw_head.GetItemDate(1, "to_ymd"), "yyyymmdd")
//

select convert(char(08), getdate(),112)
into :is_yymmdd
from dual;

return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(gs_shop_cd, is_fr_ymd, is_to_ymd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count, ll_move_qty , ll_data_cnt
integer li_cnt, li_box_no
datetime ld_datetime
String   ls_ymd,   ls_rtn_no, ls_no,    ls_to_shop_cd, ls_shop_type , ls_year, ls_season, ls_yymmdd,ls_fr_rtn_no, ls_move_yn
String   ls_style, ls_chno,   ls_color, ls_size,       ls_Err_msg , ls_rt_yn, ls_tran_cust, ls_tran_type, ls_proc_chk


ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ll_row_count = dw_body.RowCount()

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_brand = dw_head.getitemstring(1,'brand')
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if


FOR i=1 TO ll_row_count
	ls_move_yn    = dw_body.GetitemString(i, "move_yn")	
   ll_move_qty   = dw_body.GetitemNumber(i, "move_qty")
	ls_shop_type  = dw_body.GetitemString(i, "fr_shop_type")
   ls_style		  = dw_body.GetitemString(i, "style")	
	ls_to_shop_cd = dw_body.GetitemString(i, "to_shop_cd")
	ls_yymmdd     = dw_body.GetitemString(i, "fr_ymd")
	ls_fr_rtn_no  = dw_body.GetitemString(i, "fr_rtn_no")	
	ls_proc_chk   = dw_body.GetitemString(i, "proc_chk")	
	
		if	ls_move_yn = "Y" and ls_proc_chk = "N" then	
				if ll_move_qty < 0 then
						messagebox("경고!" , "점간이송은 - 로 등록할 수 없습니다!")
						return -1
				end if		
				
				if is_yymmdd >= '20140107' then
					if wf_rt_chk(i)  = false then
						messagebox("경고!", "해당 품번이 금주 RT대상이 아니거나 수량이 다릅니다! 품번과 상대매장, 수량을 확인하세요!")				
						return -1
					end if		
				end if	
				
				idw_status = dw_body.GetItemStatus(i, 0, Primary!)
				IF idw_status = NewModified! or idw_status = DataModified! THEN	

					if isnull(ls_yymmdd) or isnull(ls_fr_rtn_no) then
					/* 전표 번호 채번 */
						gf_style_outno (is_yymmdd, gs_brand, ls_rtn_no)
						dw_body.Setitem(i, "fr_ymd",     is_yymmdd)
						dw_body.Setitem(i, "fr_rtn_no",  ls_rtn_no)
						dw_body.Setitem(i, "fr_no",      '0001')
						dw_body.Setitem(i, "reg_id",     gs_user_id)
						dw_body.Setitem(i, "reg_dt",     ld_datetime)
					else
						dw_body.Setitem(i, "mod_id", gs_user_id)
						dw_body.Setitem(i, "mod_dt", ld_datetime)
					end if	
				END IF
	
		end if	
				
NEXT


il_rows = 1
FOR i=1 TO ll_row_count
   idw_status   = dw_body.GetItemStatus(i, 0, Primary!)
	ls_move_yn    = dw_body.GetitemString(i, "move_yn")	
   ll_move_qty   = dw_body.GetitemNumber(i, "move_qty")
   ls_ymd        = dw_body.GetitemString(i, "fr_ymd")
   ls_shop_type  = dw_body.GetitemString(i, "fr_shop_type")
   ls_rtn_no     = dw_body.GetitemString(i, "fr_rtn_no")
   ls_no         = dw_body.GetitemString(i, "fr_no")
   ls_style      = dw_body.GetitemString(i, "style")
   ls_chno       = dw_body.GetitemString(i, "chno")
   ls_color      = dw_body.GetitemString(i, "color")
   ls_size       = dw_body.GetitemString(i, "size")
   ls_to_shop_cd = dw_body.GetitemString(i, "to_shop_cd")
	ls_proc_chk   = dw_body.GetitemString(i, "proc_chk")		
	ls_rt_yn      = "Y"
	ls_tran_cust  = "MXX"
	ls_tran_type  = "000"
	li_box_no     = 0	
	
if	 ls_proc_chk = "N" and ls_move_yn = "Y" then		
	
	if ll_move_qty < 0 then
			messagebox("경고!" , "점간이송은 - 로 등록할 수 없습니다!")

   		return -1
	end if		
	
	
	IF isnull(ls_style)      OR Trim(ls_style) = "" OR & 
	   isnull(ls_to_shop_cd) OR Trim(ls_to_shop_cd) = "" THEN 
		CONTINUE
	END IF 	
	
   IF idw_status = NewModified! or idw_status = DataModified! THEN		   /* New Record */
	     IF ll_move_qty <> 0 and ls_proc_chk = 'N' THEN 
         DECLARE SP_SH103_INSERT_new PROCEDURE FOR SP_SH103_INSERT_new
                 @yymmdd     = :is_yymmdd    , 
                 @shop_cd    = :gs_shop_cd   , 
                 @shop_type  = :ls_shop_type , 
                 @out_no     = :ls_rtn_no    , 
                 @no         = :ls_no        ,
                 @style      = :ls_style     , 
                 @chno       = :ls_chno      , 
                 @color      = :ls_color     , 
                 @size       = :ls_size      , 
                 @qty        = :ll_move_qty  , 
                 @to_shop_cd = :ls_to_shop_cd   , 
					  @rt_yn      = :ls_rt_yn     ,
                 @reg_id     = :gs_user_id   ,        
                 @reg_dt     = :ld_datetime  ,
					  @tran_cust  = :ls_tran_cust ,
					  @tran_type  = :ls_tran_type ,
					  @box_no     = :li_box_no ;
					  
       		  EXECUTE SP_SH103_INSERT_new ; 
					//wf_push(gs_shop_cd, is_yymmdd, ls_to_shop_cd)			//푸쉬넣기
				IF SQLCA.SQLCODE < 0 THEN 
					il_rows = - 1
					ls_Err_msg = SQLCA.SQLERRTEXT
					EXIT
				END IF
			END IF 
      
	END IF 
end if	
	
NEXT

if il_rows = 1 then
	dw_body.Update()
   commit  USING SQLCA;	
   dw_body.ResetUpdate()
	This.Post Event ue_retrieve()
else
   rollback  USING SQLCA;
	MessageBox("SQL오류", ls_Err_msg)
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event open;call super::open;Date ld_fr_ymd, ld_to_ymd  
STRING lS_fr_ymd, LS_TODAY
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF



LS_TODAY = STRING(ld_datetime,"YYYYMMDD") 
ld_fr_ymd  = RelativeDate(ld_to_ymd, -7)

SELECT CONVERT(CHAR(08), DATEADD(DAY, -7, :LS_TODAY), 112)
INTO :lS_fr_ymd
FROM DUAL;


dw_head.Setitem(1, "fr_ymd",lS_fr_ymd)




//dw_head.SetItem(1, "frm_ymd", mid(string(ld_datetime, "yyyymmdd"),1,6) + "01")
end event

event pfc_postopen();call super::pfc_postopen;if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

This.Trigger Event ue_retrieve()
end event

type cb_close from w_com010_e`cb_close within w_sh162_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh162_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh162_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh162_e
end type

type cb_update from w_com010_e`cb_update within w_sh162_e
end type

type cb_print from w_com010_e`cb_print within w_sh162_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh162_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh162_e
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh162_e
integer y = 156
integer height = 176
string dataobject = "d_sh162_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.object.brand_t.visible = true
	dw_head.object.brand.visible = true
else
	dw_head.object.brand_t.visible = false
	dw_head.object.brand.visible = false
end if


end event

event dw_head::itemchanged;call super::itemchanged;long ll_b_cnt
CHOOSE CASE dwo.name

	CASE "brand"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			dw_head.accepttext()
			gs_brand = dw_head.getitemstring(1,'brand')

			select isnull(count(brand),0)
			into	:ll_b_cnt
			from tb_91100_m  with (nolock) 
			where shop_cd like '%' + substring(:gs_shop_cd_1,3,4)
					and brand = :gs_brand;	
					
			if ll_b_cnt = 0 then 
				messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
				dw_body.reset()
				return 0
			end if

			gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
			Trigger Event ue_retrieve()
	
END CHOOSE
		
end event

type ln_1 from w_com010_e`ln_1 within w_sh162_e
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_e`ln_2 within w_sh162_e
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_e`dw_body within w_sh162_e
integer y = 360
integer width = 2853
integer height = 1424
string dataobject = "d_sh162_d01"
boolean hscrollbar = true
end type

event dw_body::clicked;call super::clicked;This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)
end event

event dw_body::itemchanged;call super::itemchanged;String ls_brand, ls_yymmdd, ls_rt_no, ls_no, ls_fg

ls_brand  = This.GetitemString(row, "brand")
ls_yymmdd = This.GetitemString(row, "yymmdd")
ls_rt_no  = This.GetitemString(row, "rt_no")
ls_no     = This.GetitemString(row, "no")
ls_fg     = "2"


 DECLARE SP_SH107_UPDATE PROCEDURE FOR SP_SH107_UPDATE  
         @brand  = :ls_brand,   
         @yymmdd = :ls_yymmdd,   
         @rt_no  = :ls_rt_no,   
         @no     = :ls_no,   
         @rt_fg  = :ls_fg  ;

 EXECUTE SP_SH107_UPDATE ;
 
 COMMIT; 
 
end event

type dw_print from w_com010_e`dw_print within w_sh162_e
end type

type st_1 from statictext within w_sh162_e
integer x = 1152
integer y = 204
integer width = 1714
integer height = 84
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 16777215
string text = "※ 점간데이터의 삭제수정은 점간이동등록에서 가능합니다."
boolean focusrectangle = false
end type

