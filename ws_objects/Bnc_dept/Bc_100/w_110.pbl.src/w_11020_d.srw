$PBExportHeader$w_11020_d.srw
$PBExportComments$전체 계획/실적 진행현황
forward
global type w_11020_d from w_com010_d
end type
type st_1 from statictext within w_11020_d
end type
end forward

global type w_11020_d from w_com010_d
st_1 st_1
end type
global w_11020_d w_11020_d

type variables
DataWindowChild idw_brand, idw_season
String is_brand, is_yyyy, is_season,is_from_ymd, is_to_ymd, is_opt_chn, is_year
end variables

on w_11020_d.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_11020_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
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

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_from_ymd = dw_head.GetItemString(1, "from_ymd")
if IsNull(is_from_ymd) or Trim(is_from_ymd) = "" then
   MessageBox(ls_title,"From일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("from_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"to일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_opt_chn = dw_head.GetItemString(1, "opt_chn")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand,is_yyyy,is_season,is_from_ymd,is_to_ymd, is_opt_chn)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_1, "FixedToRight")

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.16                                                  */	
/* 수정일      : 2002.01.16                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_brand, ls_yyyy,ls_season

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss") 
ls_brand = idw_brand.GetitemString(idw_brand.GetRow(), "inter_display")
ls_season = idw_season.GetitemString(idw_season.GetRow(), "inter_display") 

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + ls_brand + "'" + &
            "t_yyyy.Text = '" + is_yyyy + "'" + &
				"t_season.Text = '" + ls_season + "'" + &
				"t_from_ymd.Text = '" + is_from_ymd + "'" + &
				"t_to_ymd.Text = '" + is_to_ymd + "'"  

dw_print.Modify(ls_modify)


end event

event open;call super::open;Datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "from_ymd",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "to_ymd",string(ld_datetime, "yyyymmdd"))

dw_body.Object.DataWindow.HorizontalScrollSplit  = 1030
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_11020_d","0")
end event

type cb_close from w_com010_d`cb_close within w_11020_d
end type

type cb_delete from w_com010_d`cb_delete within w_11020_d
end type

type cb_insert from w_com010_d`cb_insert within w_11020_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_11020_d
end type

type cb_update from w_com010_d`cb_update within w_11020_d
end type

type cb_print from w_com010_d`cb_print within w_11020_d
end type

type cb_preview from w_com010_d`cb_preview within w_11020_d
end type

type gb_button from w_com010_d`gb_button within w_11020_d
end type

type cb_excel from w_com010_d`cb_excel within w_11020_d
end type

type dw_head from w_com010_d`dw_head within w_11020_d
integer width = 3543
integer height = 168
string dataobject = "d_11020_h01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(sqlca)
idw_brand.Retrieve('001')


//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'yyyy')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003',is_brand,is_year)
//idw_season.Retrieve('003')


end event

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
	CASE "brand", "yyyy"
		//라빠레트 시즌적용
		dw_head.accepttext()
		
		is_brand = dw_head.getitemstring(1,'brand')
		is_year = dw_head.getitemstring(1,'yyyy')
		
		this.getchild("season",idw_season)
		idw_season.settransobject(sqlca)
		idw_season.retrieve('003',is_brand,is_year)
		
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_11020_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_11020_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_11020_d
integer y = 376
integer height = 1672
string dataobject = "d_11020_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_11020_d
string dataobject = "d_11020_r01"
end type

type st_1 from statictext within w_11020_d
integer x = 3154
integer y = 292
integer width = 425
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "( 단위 : 천원 )"
boolean focusrectangle = false
end type

