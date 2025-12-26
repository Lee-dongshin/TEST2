$PBExportHeader$w_52013_e.srw
$PBExportComments$Order배분출고의뢰
forward
global type w_52013_e from w_com010_e
end type
type dw_assort from datawindow within w_52013_e
end type
type dw_db from datawindow within w_52013_e
end type
type dw_temp from datawindow within w_52013_e
end type
type st_remark from statictext within w_52013_e
end type
type st_country from statictext within w_52013_e
end type
end forward

global type w_52013_e from w_com010_e
integer width = 3675
integer height = 2272
dw_assort dw_assort
dw_db dw_db
dw_temp dw_temp
st_remark st_remark
st_country st_country
end type
global w_52013_e w_52013_e

type variables
DataWindowChild idw_color 
String  is_style, is_chno, is_color, is_yymmdd
Long    il_deal_seq 
Boolean ib_NewDeal
end variables

forward prototypes
public function boolean wf_deal ()
public function boolean wf_temp_set ()
public subroutine wf_retrieve_set ()
public subroutine wf_add_stock ()
public function boolean wf_body_set ()
end prototypes

public function boolean wf_deal ();Long i, k, ll_row_cnt, ll_assort_cnt 
Long ll_deal_qty, ll_chk_qty, ll_tot_qty

ll_row_cnt    = dw_body.RowCount() 
ll_assort_cnt = dw_assort.RowCount() 

IF ll_row_Cnt < 1 THEN Return False
 
dw_body.SetRedraw(False) 

FOR i = 1 TO ll_row_cnt 
	/* 총 배분가능량 체크 */
	ll_tot_qty = Long(dw_assort.Describe("evaluate('sum(chk_qty)',0)"))
	IF isnull(ll_tot_qty) OR ll_tot_qty = 0 THEN CONTINUE 
	FOR k = 1 TO ll_assort_cnt 
		ll_chk_qty  = dw_assort.Object.chk_qty[k]
		ll_deal_qty = dw_body.GetitemNumber(i, "deal_bf_" + String(k)) 
		IF ll_chk_qty = 0 OR ll_deal_qty = 0 THEN CONTINUE 
		/* 배분 잔량이 ORDER배분잔량 보다 작을경우 배분잔량으로 처리 */
		ll_deal_qty = Min(ll_deal_qty, ll_chk_qty)
		dw_body.Setitem(i, "deal_qty_"  + String(k), ll_deal_qty) 
		/* 배분 잔량 차감 */
		dw_assort.Setitem(k, "chk_qty", ll_chk_qty - ll_deal_qty)
	NEXT 
NEXT 
dw_body.SetRedraw(True) 

Return True
end function

public function boolean wf_temp_set ();/* ORDER배분내역 dw_body로 이관 */
String ls_shop_cd,   ls_find 
Long   ll_row, ll_row_cnt, ll_assort_cnt 
Long   i, k,   ll_real_qty  
Boolean lb_Chk

ll_row_cnt    = dw_temp.RowCount()
IF ll_row_cnt < 1 THEN RETURN FALSE

ll_assort_cnt = dw_assort.RowCount()

dw_body.SetRedraw(False) 
dw_body.Reset()
lb_Chk = False 
FOR i = 1 TO ll_row_cnt 
	IF ls_shop_cd <> dw_temp.object.shop_cd[i] THEN 
      ls_shop_cd =  dw_temp.object.shop_cd[i] 
		ll_row     =  dw_body.insertRow(0)
      dw_body.Setitem(ll_row, "shop_cd",   ls_shop_cd)
      dw_body.Setitem(ll_row, "shop_nm",   dw_temp.object.shop_nm[i])
      dw_body.Setitem(ll_row, "shop_stat", dw_temp.object.shop_stat[i])
      dw_body.Setitem(ll_row, "deal_yn",   dw_temp.object.deal_yn[i])
	END IF 
	ls_find = "color = '" + dw_temp.object.color[i] + "' and size = '" + dw_temp.object.size[i] + "'"
   k = dw_assort.find(ls_find, 1, ll_assort_cnt)	
	IF k > 0 THEN 
		ll_real_qty = dw_temp.GetitemNumber(i, "c_real_qty")
		dw_body.Setitem(ll_row, "deal_bf_"  + String(k), ll_real_qty)
      lb_Chk = True
	END IF
NEXT

dw_head.Setitem(1, "deal_qty",   Long(dw_temp.Describe("evaluate('sum(deal_qty)',0)")))

dw_body.ResetUpdate()
dw_body.SetRedraw(True)

Return lb_chk
end function

public subroutine wf_retrieve_set ();/*  배분내역 dw_body로 이관 */
String ls_shop_cd,   ls_find 
Long   ll_row, ll_row_cnt,  ll_assort_cnt 
Long   i, k,   ll_deal_qty

ll_row_cnt    = dw_db.RowCount()
IF ll_row_cnt < 1 THEN RETURN 

ll_assort_cnt = dw_assort.RowCount()

dw_body.SetRedraw(False) 
FOR i = 1 TO ll_row_cnt 
   ls_shop_cd =  dw_db.object.shop_cd[i] 
	ll_row = dw_body.find("shop_cd = '" + ls_shop_cd + "'", 1, dw_body.RowCount())
	IF ll_row < 1 THEN
	   ll_row     =  dw_body.insertRow(0)
      dw_body.Setitem(ll_row, "shop_cd",   ls_shop_cd)
      dw_body.Setitem(ll_row, "shop_nm",   dw_db.object.shop_nm[i])
      dw_body.Setitem(ll_row, "shop_stat", dw_db.object.shop_stat[i])
      dw_body.Setitem(ll_row, "deal_yn",   dw_db.object.deal_yn[i])
	END IF 
	ls_find = "color = '" + dw_db.object.color[i] + "' and size = '" + dw_db.object.size[i] + "'"
   k = dw_assort.find(ls_find, 1, ll_assort_cnt)	
	IF k > 0 THEN 
		ll_deal_qty = dw_db.GetitemNumber(i, "deal_qty") 
		dw_body.Setitem(ll_row, "deal_qty_"  + String(k), ll_deal_qty) 
		/* 배분잔량에 기배분된량 추가로 표시 */
		dw_body.Setitem(ll_row, "deal_bf_"   + String(k), dw_body.GetitemNumber(ll_row, "deal_bf_" + String(k)) + ll_deal_qty)
	END IF
NEXT
/* 가용재고량에 추가로 표시 */
wf_add_stock()

dw_body.ResetUpdate()
dw_body.SetRedraw(True)

Return
end subroutine

public subroutine wf_add_stock ();/* 배분내역이 존재할경우 배분가능량에 배분량만큼 추가로 처리*/
Long   k, ll_deal_qty, ll_stock_qty 
String ls_modify,      ls_Error

FOR k = 1 TO dw_ASSORT.RowCount()
  	 ll_deal_qty  = dw_body.GetitemNumber(1, "c_deal_" + String(k)) 
	 ll_stock_qty = dw_assort.Object.stock_qty[k] + ll_deal_qty 
	 dw_assort.Setitem(k, "stock_qty", ll_stock_qty)
    ls_modify = 't_ord_'    + String(k) + '.text="' + String(ll_stock_qty) + '"'
    ls_Error  = dw_body.Modify(ls_modify)
    IF (ls_Error <> "") THEN 
		 MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
		 Return 
	 END IF
NEXT

end subroutine

public function boolean wf_body_set ();String  ls_modify,   ls_error, ls_house_cd
String  ls_color,    ls_size 
Long    ll_color_st, ll_color_wd, ll_color_cnt
Long    ll_deal_qty, ll_deal_tot
integer i, k

/* 기존에 생성한 칼라 헤드 삭제 */
ll_color_cnt = Long(dw_assort.Describe("evaluate('count(color for all distinct)',0)"))
FOR i = 1 to ll_color_cnt
   dw_body.Modify("Destroy t_color_" + String(i)) 
NEXT 

/* assort 내역 조회 */
if LeftA(upper(is_style),1) = 'W' then 
	ls_house_cd = '030000'
else
	ls_house_cd = '010000'
end if

il_rows = dw_assort.Retrieve(is_style, is_chno, is_color, ls_house_cd)

/* Head 정보 Set */
dw_head.Setitem(1, "ord_qty",   Long(dw_assort.Describe("evaluate('sum(ord_qty)',0)")))
dw_head.Setitem(1, "in_qty",    Long(dw_assort.Describe("evaluate('sum(in_qty)',0)")))
dw_head.Setitem(1, "open_qty",  Long(dw_assort.Describe("evaluate('sum(open_qty)',0)")))
dw_head.Setitem(1, "resv_qty",  Long(dw_assort.Describe("evaluate('sum(resv_qty)',0)")))
dw_head.Setitem(1, "stock_qty", Long(dw_assort.Describe("evaluate('sum(stock_qty)',0)")))

/* 칼라 및 사이즈 셋 */
ll_color_st = 1147
ls_color    = '@@'
k           = 0

FOR i = 1 TO 20 
	IF i > il_rows THEN
      ls_modify = ' t_size_'   + String(i) + '.Visible=0' + &
                  ' t_'        + String(i) + '.Visible=0' + &
                  ' t_ord_'    + String(i) + '.Visible=0' + &
                  ' deal_bf_'  + String(i) + '.Visible=0' + &
                  ' deal_qty_' + String(i) + '.Visible=0' + &
                  ' c_bf_'     + String(i) + '.Visible=0' + &
                  ' c_deal_'   + String(i) + '.Visible=0'
   ELSE
	   ls_size     = dw_assort.object.size[i] 
	   ll_deal_qty = dw_assort.object.stock_qty[i] 
      ls_modify = ' t_size_'   + String(i) + '.Text="' + ls_size + '"' + &
		            ' t_size_'   + String(i) + '.Visible=1' + &
                  ' t_'        + String(i) + '.Visible=1' + &
                  ' t_ord_'    + String(i) + '.text="' + String(ll_deal_qty) + '"' + &
		            ' t_ord_'    + String(i) + '.Visible=1' + & 
                  ' deal_bf_'  + String(i) + '.Visible=1' + &
                  ' deal_qty_' + String(i) + '.Visible=1' + &
                  ' c_bf_'     + String(i) + '.Visible=1' + &
                  ' c_deal_'   + String(i) + '.Visible=1'
      /* 색상 헤드 타이틀 생성 */
		IF ls_color <> dw_assort.object.color[i] THEN 
	      ls_color  = dw_assort.object.color[i] 
			k++ 
         ls_modify = ls_modify + 'create text(band=header alignment="2" text="' + ls_color + '" border="6" color="0"' + &
                     ' x="' + String(ll_color_st) + '" y="4" height="56" width="283"' + &
					      ' name=t_color_' + String(k) + ' font.face="굴림체" font.height="-9" font.weight="400"  font.family="1"' + &
					      ' font.pitch="1" font.charset="129" background.mode="2" background.color="79741120")'	
			ll_color_st = ll_color_st + 302
		ELSE       /* 색상 헤드 타이틀 폭 확장  */
			ll_color_wd = Long(dw_body.Describe(' t_color_' + String(k) + + '.width'))
			ls_modify = ls_modify + ' t_color_' + String(k) + '.width="' + String(ll_color_wd + 302) + '"'
			ll_color_st = ll_color_st + 302
		END IF
	END IF
	ls_Error = dw_body.Modify(ls_modify)
	IF (ls_Error <> "") THEN 
		MessageBox("Create Head Error", ls_Error + "~n~n" + ls_modify)
		Return False
	END IF
NEXT 

Return True 
end function

on w_52013_e.create
int iCurrent
call super::create
this.dw_assort=create dw_assort
this.dw_db=create dw_db
this.dw_temp=create dw_temp
this.st_remark=create st_remark
this.st_country=create st_country
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_assort
this.Control[iCurrent+2]=this.dw_db
this.Control[iCurrent+3]=this.dw_temp
this.Control[iCurrent+4]=this.st_remark
this.Control[iCurrent+5]=this.st_country
end on

on w_52013_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_assort)
destroy(this.dw_db)
destroy(this.dw_temp)
destroy(this.st_remark)
destroy(this.st_country)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.12.11                                                  */	
/* 수정일      : 2002.01.28                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title, ls_style_no

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

ls_style_no = dw_head.GetItemString(1, "style_no")
if IsNull(ls_style_no) or Trim(ls_style_no) = "" then
   MessageBox(ls_title,"품번 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no")
   return false
end if
is_style = MidA(ls_style_no, 1, 8)
is_Chno  = MidA(ls_style_no, 9, 1)

is_color = dw_head.GetItemString(1, "color")
if IsNull(is_color) or Trim(is_color) = "" then
   MessageBox(ls_title,"색상 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("color")
   return false
end if

il_deal_seq = dw_head.GetItemNumber(1, "deal_seq")
if IsNull(il_deal_seq)  then
   MessageBox(ls_title,"배분차수를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_seq")
   return false
end if

is_yymmdd = String(dw_head.GetItemDate(1, "yymmdd"), "yyyymmdd")

return true
end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
Long ll_row

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

IF wf_body_set() = FALSE THEN RETURN

il_rows = dw_temp.retrieve(is_style, is_chno, is_color)
IF il_rows > 0 THEN 
	wf_temp_set() 
	ll_row = dw_db.Retrieve(is_yymmdd, il_deal_seq, is_style, is_chno, is_color)
	IF ll_row > 0 THEN 
		wf_retrieve_set() 
		IF dw_db.Object.proc_yn[1] = 'Y' THEN 
		   st_remark.Text = "이미 출고된 자료 입니다."
			cb_delete.enabled = false
		ELSE
		   st_remark.Text = "이미 배분된 내역이 있습니다."
			cb_delete.enabled = true
		END IF
		ib_NewDeal = False
	ELSE
		st_remark.Text = "배분된 처리중......."
		ib_NewDeal     = wf_deal()
		st_remark.Text = ""
	END IF
   dw_body.SetFocus() 
ELSE
	MessageBox("확인", "ORDER배분 내역이 없습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)

IF il_rows > 0 THEN 
	IF ib_NewDeal THEN 
		ib_changed        = true
		cb_update.enabled = true
		cb_excel.enabled  = false
	ELSEIF st_remark.Text = "이미 출고된 자료 입니다." THEN 
		dw_body.Enabled = False
	END IF
END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
long     i, k, ll_row_count, ll_assort_cnt, ll_find, ll_deal_qty, ll_resv_qty  
datetime ld_datetime
String   ls_shop_cd, ls_color, ls_size, ls_find, ls_shop_div, ls_ErrMsg

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

/* ORDER량 초과배분 여부 체크 */ 
FOR k = 1 TO dw_ASSORT.RowCount()
  	 ll_deal_qty = dw_body.GetitemNumber(1, "c_deal_" + String(k)) 
	 IF ll_deal_qty > dw_assort.Object.stock_qty[k] THEN 
		 MessageBox("오류", "[" + dw_assort.GetitemString(k, "color") + "/" + & 
		                    dw_assort.GetitemString(k, "size") + "] 배분량이 초과 하였습니다,")
		 
		 Return -1 
	 END IF
NEXT

ll_assort_cnt = dw_assort.RowCount()
il_rows = 1
FOR i=1 TO ll_row_count
	IF il_rows <> 1 THEN EXIT 
   idw_status = dw_body.GetItemStatus(i, 0, Primary!) 
	/* 수정된 row체크 */
   IF idw_status = NewModified! OR idw_status = DataModified! THEN	
		ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
		ls_shop_div = MidA(ls_shop_cd, 2, 1)
      FOR k = 1 TO ll_assort_cnt 
			/* 수정 칼럼 체크 */
			IF dw_body.GetItemStatus(i, "deal_qty_" + String(k), Primary!) = DataModified! THEN 
				ll_deal_qty = dw_body.GetitemNumber(i, "deal_qty_" + String(k)) 
				/* 신규배분 내역이면서 배분량이 ZERO면 SKIP */
				IF ib_NewDeal AND ll_deal_qty = 0 THEN CONTINUE
				ls_color = dw_assort.GetitemString(k, "color") 
				ls_size  = dw_assort.GetitemString(k, "size") 
				/* db용에서 해당row 검색 없으면 신규, 존재하면 수정*/
				ls_find  = "shop_cd = '" + ls_shop_cd + "' and color = '" + ls_color + "' and size = '" + ls_size + "'"
				ll_find = dw_db.find(ls_find, 1, dw_db.RowCount())
				IF ll_find > 0 THEN
					ll_resv_qty = dw_db.GetitemNumber(ll_find, "deal_qty", Primary!, True)
					IF isnull(ll_resv_qty) THEN 
						ll_resv_qty = ll_deal_qty 
					ELSE
						ll_resv_qty = ll_deal_qty - ll_resv_qty 
					END IF
					dw_db.Setitem(ll_find, "deal_qty", ll_deal_qty)
               dw_db.Setitem(ll_find, "mod_id",   gs_user_id)
               dw_db.Setitem(ll_find, "mod_dt",   ld_datetime)
				ELSE
					ll_find = dw_db.insertRow(0)
               dw_db.Setitem(ll_find, "out_ymd",  is_yymmdd)
               dw_db.Setitem(ll_find, "deal_seq", il_deal_seq)
               dw_db.Setitem(ll_find, "style",    is_style)
               dw_db.Setitem(ll_find, "chno",     is_chno)
               dw_db.Setitem(ll_find, "shop_cd",  ls_shop_cd)
               dw_db.Setitem(ll_find, "color",    ls_color)
               dw_db.Setitem(ll_find, "size",     ls_size)
               dw_db.Setitem(ll_find, "deal_fg",  '1')
               dw_db.Setitem(ll_find, "deal_qty", ll_deal_qty)
               dw_db.Setitem(ll_find, "reg_id",   gs_user_id)
					ll_resv_qty = ll_deal_qty
				END IF
            /* 예약 재고량 처리 */
	         IF gf_stresv_update (is_style,    is_chno,     ls_color, ls_size, &
				                     ls_shop_div, ll_resv_qty, ls_ErrMsg) = FALSE THEN 
		         il_rows = -1
        			EXIT
	         END IF
			END IF
		NEXT
   END IF
NEXT

il_rows = dw_db.Update()

if il_rows = 1 then
	/* 작업용 datawindow 초기화(dw_body) */
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	ib_NewDeal = False
else
   rollback  USING SQLCA;
	IF isnull(ls_ErrMsg) = FALSE AND Trim(ls_ErrMsg) <> "" THEN 
		MessageBox("SQL 오류", ls_ErrMsg)
	END IF
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_country
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style_no"				
		   ls_style = MidA(as_data, 1, 8)
			ls_chno  = MidA(as_data, 9, 1)
			IF ai_div = 1 THEN 	
				if gs_brand <> 'K' then
					IF gf_style_chk(ls_style, ls_chno) THEN
							
						SELECT  dbo.sf_inter_nm('000',country_cd)
						INTO  :ls_country
						FROM vi_12020_1 WITH(NOLOCK)
						WHERE STYLE = :ls_style
						and chno =  :ls_chno;
						
						st_country.text = "※ " + ls_country + " 생산 제품입니다!!"
						
						
						RETURN 0
					END IF 
				end if
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = ""
			if gs_brand <> 'K' then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + ls_style + "%'"  + &
											 " and chno like '" + ls_chno + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else
				gst_cd.Item_where = ""
			end if	

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("deal_type")
				
					ls_style = lds_Source.GetItemString(1,"style")
					ls_chno  = lds_Source.GetItemString(1,"chno")					
								
					SELECT  dbo.sf_inter_nm('000',country_cd)
					INTO  :ls_country
					FROM vi_12020_1 WITH(NOLOCK)
					WHERE STYLE = :ls_style
					and chno =  :ls_chno;
					
					st_country.text = "※ " + ls_country + " 생산 제품입니다!!"
				
				
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(st_remark, "ScaleToRight")

dw_assort.SetTransObject(SQLCA)
dw_temp.SetTransObject(SQLCA)
dw_db.SetTransObject(SQLCA)



end event

event ue_delete;/*===========================================================================*/
/* 작성자      :                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.07.18                                                  */
/*===========================================================================*/

//ll_row = dw_db.Retrieve(is_yymmdd, il_deal_seq, is_style, is_chno, is_color)

				
  	   DECLARE SP_DelResv_Update PROCEDURE FOR SP_DelResv_Update  
         @YYMMDD   = :is_yymmdd,   
			@deal_seq = :il_deal_seq,
         @style    = :is_style,   
         @chno     = :is_chno,   
         @color    = :is_color  ;

		EXECUTE SP_DelResv_Update;
		commit  USING SQLCA;  
		MessageBox("알림!","삭제되었습니다!")
      cb_delete.enabled = false
	
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_52013_e","0")
end event

type cb_close from w_com010_e`cb_close within w_52013_e
end type

type cb_delete from w_com010_e`cb_delete within w_52013_e
end type

type cb_insert from w_com010_e`cb_insert within w_52013_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_52013_e
end type

type cb_update from w_com010_e`cb_update within w_52013_e
end type

type cb_print from w_com010_e`cb_print within w_52013_e
boolean visible = false
integer x = 1422
integer y = 56
end type

type cb_preview from w_com010_e`cb_preview within w_52013_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_52013_e
end type

type cb_excel from w_com010_e`cb_excel within w_52013_e
end type

type dw_head from w_com010_e`dw_head within w_52013_e
integer y = 268
integer height = 276
string dataobject = "d_52013_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.28                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
String ls_yymmdd

CHOOSE CASE dwo.name
	CASE "yymmdd"      
		  ls_yymmdd = String(Date(Data),  "yyyymmdd") 
		  IF gf_iwoldate_chk(gs_user_id, is_pgm_id, ls_yymmdd) = FALSE THEN 
			  MessageBox("경고","소급할수 없는 일자입니다.")
			  Return 1
        END IF
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
//idw_color.InsertRow(1)
//idw_color.Setitem(1, "color", '%')
//idw_color.Setitem(1, "color_display", '전체')
//
end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_style_no, ls_color

CHOOSE CASE dwo.name
	CASE "color"
		ls_style_no = This.GetitemString(row, "style_no")
		idw_color.Retrieve(LeftA(ls_style_no, 8), RightA(ls_style_no, 1))
		idw_color.insertRow(1)
		idw_color.Setitem(1, "color", "%")
		idw_color.Setitem(1, "color_enm", "전체")
END CHOOSE


end event

type ln_1 from w_com010_e`ln_1 within w_52013_e
integer beginy = 544
integer endy = 544
end type

type ln_2 from w_com010_e`ln_2 within w_52013_e
integer beginy = 548
integer endy = 548
end type

type dw_body from w_com010_e`dw_body within w_52013_e
integer y = 560
integer height = 1480
string dataobject = "d_52013_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::ue_keydown;/*===========================================================================*/
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
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                      */	
/* 작성일      : 2002.04.15                                                  */	
/* 수정일      : 2002.04.15                                                  */
/*===========================================================================*/
IF LeftA(dwo.name, 8) = "deal_qty" and Long(Data) < 0 THEN
	RETURN 1
END IF 

end event

type dw_print from w_com010_e`dw_print within w_52013_e
end type

type dw_assort from datawindow within w_52013_e
boolean visible = false
integer x = 1339
integer y = 328
integer width = 640
integer height = 536
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "assort"
string dataobject = "d_com520"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_db from datawindow within w_52013_e
boolean visible = false
integer x = 2107
integer y = 352
integer width = 411
integer height = 432
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "db"
string dataobject = "d_52013_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_temp from datawindow within w_52013_e
boolean visible = false
integer x = 2533
integer y = 360
integer width = 411
integer height = 432
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "temp"
string dataobject = "d_52013_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_remark from statictext within w_52013_e
integer x = 23
integer y = 168
integer width = 1659
integer height = 84
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_country from statictext within w_52013_e
integer x = 1737
integer y = 184
integer width = 1627
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean focusrectangle = false
end type

