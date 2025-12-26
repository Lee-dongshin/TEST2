$PBExportHeader$w_sh127_e.srw
$PBExportComments$반품박스 처리
forward
global type w_sh127_e from w_com010_e
end type
type hpb_1 from hprogressbar within w_sh127_e
end type
type st_1 from statictext within w_sh127_e
end type
type st_2 from statictext within w_sh127_e
end type
type dw_1 from datawindow within w_sh127_e
end type
type st_3 from statictext within w_sh127_e
end type
end forward

global type w_sh127_e from w_com010_e
integer width = 2971
hpb_1 hpb_1
st_1 st_1
st_2 st_2
dw_1 dw_1
st_3 st_3
end type
global w_sh127_e w_sh127_e

type variables
DataWindowChild	idw_color
String is_fr_box_ymd, is_to_box_ymd, is_proc_yn
end variables

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "fr_box_ymd" ,string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "to_box_ymd" ,string(ld_datetime,"yyyymmdd"))

hpb_1.position = 0
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToBottom")
dw_1.SetTransObject(SQLCA)
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
string   ls_title, ls_accept_yn

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

if MidA(gs_shop_cd,3,4) = '2000'  then //or  mid(gs_shop_cd,1,2) = 'NI' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	


select dbo.SF_shop_rtrn_accept(:gs_shop_cd)
into :ls_accept_yn
from dual;

if ls_accept_yn = 'N' then
	messagebox("주의!", '반품등록 선정 매장에서만 사용할 수 있습니다!')
	return false
end if	


is_fr_box_ymd = dw_head.GetItemString(1, "fr_box_ymd")
if IsNull(is_fr_box_ymd) or Trim(is_fr_box_ymd) = "" then
   MessageBox(ls_title,"등록일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_box_ymd")
   return false
end if

is_to_box_ymd = dw_head.GetItemString(1, "to_box_ymd")
if IsNull(is_to_box_ymd) or Trim(is_to_box_ymd) = "" then
   MessageBox(ls_title,"등록일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_box_ymd")
   return false
end if

is_proc_yn = dw_head.GetItemString(1, "proc_yn")
if IsNull(is_proc_yn) or Trim(is_proc_yn) = "" then
   MessageBox(ls_title,"반품여부처리를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("proc_yn")
   return false
end if

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(is_fr_box_ymd, is_to_box_ymd, gs_shop_cd, is_proc_yn)

IF il_rows > 0 THEN
   dw_body.SetFocus()
	hpb_1.position = 0
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

on w_sh127_e.create
int iCurrent
call super::create
this.hpb_1=create hpb_1
this.st_1=create st_1
this.st_2=create st_2
this.dw_1=create dw_1
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.st_3
end on

on w_sh127_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.hpb_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_1)
destroy(this.st_3)
end on

event type long ue_update();call super::ue_update;
String ls_ErrMsg, ls_proc_yn, ls_box_ymd, ls_box_no
long i, ll_row_count, ll_sqlcode, ll_cnt
datetime ld_datetime

ll_row_count = dw_body.RowCount()

IF dw_body.AcceptText() <> 1 THEN RETURN -1

IF MessageBox("확인", "선택한 박스를 반품요청 하시겠습니까 ?", Question!, YesNo! ) = 2 THEN 
	RETURN 0 
END IF

hpb_1.position = 0
ll_cnt = 0

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
	
	hpb_1.position = i / ll_row_count * 100
	
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
		
	ls_proc_yn = dw_body.GetItemString(i, "proc_yn")
	ls_box_ymd = dw_body.GetItemString(i, "box_ymd")
	ls_box_no  = dw_body.GetItemString(i, "box_no")	
	
   IF idw_status = DataModified! and ls_proc_yn = "Y" THEN				/* New Record */
       
		 DECLARE sp_sh127_d01 PROCEDURE FOR sp_sh127_d01  
         @box_ymd  = :ls_box_ymd,   
         @box_no   = :ls_box_no,   
         @shop_cd  = :gs_shop_cd,   
         @brand    = :gs_brand,   
         @reg_id   = :gs_shop_cd  ;

		EXECUTE sp_sh127_d01;

		if SQLCA.SQLCODE = 0  OR SQLCA.SQLCODE = 100 then
			commit  USING SQLCA;
			il_rows = 1 
			cb_update.Enabled = False		
			ll_cnt = ll_cnt + 1
		else 
			ll_sqlcode = SQLCA.SQLCODE
			ls_ErrMsg  = SQLCA.SQLErrText 
			rollback  USING SQLCA; 
			MessageBox("SQL 오류", "[" + String(ll_sqlcode) + "]" + ls_ErrMsg) 
		end if

   END IF
NEXT

messagebox("처리 완료!", "총" + string(ll_cnt) + "개의 박스가 반품요청 되었습니다!")

This.Trigger Event ue_retrieve()

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_button(integer ai_cb_div, long al_rows);
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
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
		 cb_update.enabled = false
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

type cb_close from w_com010_e`cb_close within w_sh127_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh127_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh127_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh127_e
end type

type cb_update from w_com010_e`cb_update within w_sh127_e
end type

type cb_print from w_com010_e`cb_print within w_sh127_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh127_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh127_e
end type

type dw_head from w_com010_e`dw_head within w_sh127_e
integer y = 156
integer width = 2843
integer height = 176
string dataobject = "d_sh127_h01"
end type

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

type ln_1 from w_com010_e`ln_1 within w_sh127_e
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_e`ln_2 within w_sh127_e
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_e`dw_body within w_sh127_e
integer y = 356
integer width = 2880
integer height = 1428
string dataobject = "d_sh127_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;String ls_box_no, ls_box_ymd, ls_proc_yn, ls_yymmdd, ls_out_no

IF row < 1 THEN RETURN

ls_box_ymd = This.GetitemString(row, "box_ymd")
ls_box_no  = This.GetitemString(row, "box_no")
ls_proc_yn = This.GetitemString(row, "proc_yn")
ls_yymmdd = This.GetitemString(row, "yymmdd")
ls_out_no = This.GetitemString(row, "out_no")

il_rows = dw_1.Retrieve(ls_box_ymd, gs_shop_cd, ls_box_no, ls_yymmdd, ls_out_no) 
	
IF il_rows > 0 THEN
	dw_1.visible = true
END IF
	



end event

type dw_print from w_com010_e`dw_print within w_sh127_e
end type

type hpb_1 from hprogressbar within w_sh127_e
boolean visible = false
integer x = 613
integer y = 56
integer width = 969
integer height = 72
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
boolean smoothscroll = true
end type

type st_1 from statictext within w_sh127_e
boolean visible = false
integer x = 384
integer y = 68
integer width = 219
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "처리 0%"
boolean focusrectangle = false
end type

type st_2 from statictext within w_sh127_e
boolean visible = false
integer x = 1591
integer y = 68
integer width = 219
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "100%"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_sh127_e
boolean visible = false
integer x = 9
integer y = 360
integer width = 2016
integer height = 1492
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "박스별 조회"
string dataobject = "d_sh127_d02"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;//IF row < 1 THEN RETURN

dw_1.visible = false

end event

type st_3 from statictext within w_sh127_e
integer x = 430
integer y = 72
integer width = 402
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
boolean focusrectangle = false
end type

