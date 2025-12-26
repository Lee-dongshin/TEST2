$PBExportHeader$w_52010_e.srw
$PBExportComments$Order 배분
forward
global type w_52010_e from w_com010_e
end type
type dw_1 from datawindow within w_52010_e
end type
type st_remark from statictext within w_52010_e
end type
type dw_temp from datawindow within w_52010_e
end type
type dw_db from datawindow within w_52010_e
end type
type dw_assort from datawindow within w_52010_e
end type
type st_trend from statictext within w_52010_e
end type
type cb_1 from commandbutton within w_52010_e
end type
type cb_2 from commandbutton within w_52010_e
end type
type dw_2 from datawindow within w_52010_e
end type
end forward

global type w_52010_e from w_com010_e
integer width = 3694
integer height = 2256
event ue_deal ( )
dw_1 dw_1
st_remark st_remark
dw_temp dw_temp
dw_db dw_db
dw_assort dw_assort
st_trend st_trend
cb_1 cb_1
cb_2 cb_2
dw_2 dw_2
end type
global w_52010_e w_52010_e

type variables
DataWindowChild idw_shop_lv,idw_shop_lv1,idw_area_cd
String  is_style, is_chno, is_deal_type
Integer ii_enable_qty
Boolean ib_NewDeal
DataStore  ids_copy
end variables

forward prototypes
public function boolean wf_deal_old ()
public function boolean wf_deal ()
public function boolean wf_body_set ()
public subroutine wf_retrieve_set ()
end prototypes

public function boolean wf_deal_old ();/*==================================================================================================*/
/* 배분 처리 (옛날 방식)*/
Long   i, k, ll_loop_cnt, ll_row
Long   ll_Color_cnt, ll_deal_qty, ll_Set_Qty
Long   ll_SizeST,    ll_SizeED,   ll_assort_Cnt
Long   ll_Deal_Size 
String ls_Loop,      ls_Loop_Chk 

il_rows = dw_temp.Retrieve(is_style, is_chno, is_deal_type)
IF il_rows < 1 THEN Return False 

dw_body.SetRedraw(False)

dw_body.Reset()
FOR i = 1 to il_rows 
	dw_body.insertRow(0)
	dw_body.SetItem(i, "shop_cd",   dw_temp.Object.shop_cd[i])
	dw_body.SetItem(i, "shop_nm",   dw_temp.Object.shop_snm[i])
	dw_body.SetItem(i, "shop_stat", dw_temp.Object.shop_stat[i])
	dw_body.SetItem(i, "deal_rate", dw_temp.GetitemDecimal(i, "deal_rate"))
	dw_body.SetItem(i, "deal_chk",  dw_temp.GetitemNumber(i, "deal_qty"))
NEXT

/* 색상별 일괄 배분 처리 */
ll_assort_Cnt = dw_assort.RowCount()

ls_Loop     = FillA(' ', ll_assort_cnt)
ls_Loop_Chk = FillA('*', ll_assort_cnt)

ll_SizeED = 1
ll_row = 0 
DO WHILE ls_Loop_Chk <> ls_Loop
	IF ll_SizeED > ll_assort_Cnt THEN ll_SizeED = 1
	ll_SizeST = ll_SizeED 
	/* 다음 색상 위치 산출 */
	ll_SizeED   = dw_assort.FindGroupChange(ll_SizeST + 1, 1) 
	IF ll_SizeED <= 0 THEN ll_SizeED = ll_assort_Cnt + 1 
   /* 색상에 따른 배분 가능한 사이즈수 산출 */
   ll_Deal_Size = Long(dw_assort.Describe("evaluate('sum(if(ord_deal = 0, 0, 1) for Group 1)'," + String(ll_SizeSt) + ")"))
   /* 색상별 사이즈 갯수가 2개이상이면 적어도 2개 사이즈가 최소 지급 단위 */
	IF (ll_SizeED - ll_SizeST = 1 AND ll_Deal_Size > 0) OR &
	   (ll_SizeED - ll_SizeST > 1 AND ll_Deal_Size > 1) THEN
	ELSE
      ls_Loop  = ReplaceA(ls_Loop, ll_SizeSt, ll_SizeEd - ll_SizeSt, FillA('*', ll_SizeED - ll_SizeST))
		Continue
	END IF
	/* 색상별 최소 배분 가능량 산출 */
   ll_deal_qty = Long(dw_assort.Describe("evaluate('min(if(ord_deal = 0,ord_qty,ord_deal) for Group 1)'," + String(ll_SizeSt) + ")"))
	ll_Set_Qty = 0 
	/* 매장수 만큼만 Loop */ 
	FOR i = 1 TO il_rows
      ll_row = ll_row + 1
		IF ll_row > il_rows THEN ll_row = 1 
      IF dw_body.Object.deal_chk[ll_row] >= ll_Deal_Size THEN
	      FOR k = ll_SizeSt TO ll_SizeEd - 1 
		       dw_body.Setitem(ll_row, "deal_bf_"  + String(k), dw_body.GetitemNumber(ll_row, "deal_bf_"  + String(k)) + 1)
		       dw_body.Setitem(ll_row, "deal_qty_" + String(k), dw_body.GetitemNumber(ll_row, "deal_qty_" + String(k)) + 1)
             dw_body.Setitem(ll_row, "deal_chk", dw_body.GetitemNumber(ll_row, "deal_chk") - 1)
				 dw_assort.Setitem(k, "ord_deal", dw_assort.GetitemNumber(k, "ord_deal") - 1)
	      NEXT
			ll_Set_Qty ++
		END IF
		IF ll_Set_Qty >= Min(il_rows, ll_deal_qty) THEN
			EXIT
		END IF
	NEXT
	IF ll_Set_Qty = 0 THEN 
      ls_Loop  = ReplaceA(ls_Loop, ll_SizeSt, ll_SizeEd - ll_SizeSt, FillA('*', ll_SizeED - ll_SizeST))
	END IF
LOOP
/* 사이즈별 잔량 배분 */
ls_Loop     = FillA(' ', ll_assort_cnt)
ll_row = 0 
DO WHILE ls_Loop_Chk <> ls_Loop 
	FOR k = 1 TO ll_assort_cnt
       ll_deal_qty = dw_assort.GetitemNumber(k, "ord_deal") 
		 IF ll_deal_qty = 0 THEN 
          ls_Loop  = ReplaceA(ls_Loop, k, 1, '*')
			 CONTINUE 
		 END IF
       ll_Set_Qty = 0 
	    /* 매장수 만큼만 Loop */ 
	    FOR i = 1 TO il_rows
           ll_row = ll_row + 1
		     IF ll_row > il_rows THEN ll_row = 1 
           IF dw_body.Object.deal_chk[ll_row] > 0 and dw_body.GetitemNumber(ll_row, "deal_qty_" + String(k)) > 0 THEN
 		        dw_body.Setitem(ll_row, "deal_bf_"  + String(k), dw_body.GetitemNumber(ll_row, "deal_bf_"  + String(k)) + 1)
		        dw_body.Setitem(ll_row, "deal_qty_" + String(k), dw_body.GetitemNumber(ll_row, "deal_qty_" + String(k)) + 1)
              dw_body.Setitem(ll_row, "deal_chk", dw_body.GetitemNumber(ll_row, "deal_chk") - 1)
				  dw_assort.Setitem(k, "ord_deal", dw_assort.GetitemNumber(k, "ord_deal") - 1)
			     ll_Set_Qty ++
			  END IF
			  IF ll_Set_Qty >= ll_deal_qty THEN
				  EXIT
			  END IF
		 NEXT
	    IF ll_Set_Qty = 0 THEN 
          ls_Loop  = ReplaceA(ls_Loop, k, 1, '*')
	    END IF
	NEXT
LOOP
dw_body.SetRedraw(True)

This.Trigger Event ue_button(1, il_rows)

ib_changed = true
cb_update.enabled = true
cb_excel.enabled = false

Return True
end function

public function boolean wf_deal ();/* 배분 처리 */
DataStore  lds_Dealjob
Long   i, k, ll_assort_Cnt, ll_index 
Long   ll_deal_tot, ll_shop_tot, ll_size_deal, ll_shop_deal, ll_deal_tot_chn
Dec    ldc_deal_qty
String ls_shop_cd

il_rows = dw_temp.Retrieve(is_style, is_chno, is_deal_type)
IF il_rows < 1 THEN Return False

ll_assort_Cnt = dw_assort.RowCount()

lds_Dealjob = Create DataStore
lds_Dealjob.DataObject = "d_52010_d97"

dw_body.SetRedraw(False)
dw_body.Reset()

FOR i = 1 to il_rows 
	dw_body.insertRow(0)
	dw_body.SetItem(i, "shop_cd",   dw_temp.Object.shop_cd[i])
	dw_body.SetItem(i, "shop_nm",   dw_temp.Object.shop_snm[i])
	dw_body.SetItem(i, "shop_stat", dw_temp.Object.shop_stat[i])
	dw_body.SetItem(i, "deal_rate", dw_temp.GetitemDecimal(i, "deal_rate"))
	dw_body.SetItem(i, "shop_lv", dw_temp.Object.shop_lv[i])	
	dw_body.SetItem(i, "shop_lv1", dw_temp.Object.shop_lv1[i])	
	dw_body.SetItem(i, "area_cd", dw_temp.Object.area_cd[i])		
	ls_shop_cd = dw_temp.Object.shop_cd[i]
   /* 매장별 배분량 산출 */
	ll_shop_tot = dw_temp.GetitemNumber(i, "deal_qty") 
	/* 총 배분 잔량  산출 */
   ll_deal_tot = Long(dw_assort.Describe("evaluate('sum(ord_deal)',0)"))
   ll_deal_tot_chn = Long(dw_assort.Describe("evaluate('sum(ord_deal_chn)',0)"))	
	lds_Dealjob.Reset()
	FOR k = 1 TO ll_assort_cnt 
		 /* 사이즈별 배분 잔량 */
//		 if ls_shop_cd = "NT3516" then
// 		   ll_size_deal = dw_assort.GetitemNumber(k, "ord_deal_chn")
//		   ldc_deal_qty = ll_shop_tot * (ll_size_deal / ll_deal_tot_chn)			 
//		 else	 
 		   ll_size_deal = dw_assort.GetitemNumber(k, "ord_deal")
		   ldc_deal_qty = ll_shop_tot * (ll_size_deal / ll_deal_tot)			 
//		 end if	 

		 lds_Dealjob.insertRow(0)
       lds_Dealjob.Setitem(k, "no" , k)
       lds_Dealjob.Setitem(k, "deal_qty" , Truncate(ldc_deal_qty, 0))
       lds_Dealjob.Setitem(k, "dvd" , ldc_deal_qty - Truncate(ldc_deal_qty, 0))
	NEXT 
	ll_shop_deal = Long(lds_Dealjob.Describe("evaluate('sum(deal_qty)',0)"))
	Do While ll_shop_tot <> ll_shop_deal 
		lds_Dealjob.SetSort("dvd d, no a")
		lds_Dealjob.Sort()
		For k = 1 to ll_assort_cnt 
         lds_Dealjob.Setitem(k, "deal_qty" , lds_Dealjob.GetitemNumber(k,"deal_qty") + 1)
			ll_shop_deal ++
			IF ll_shop_tot = ll_shop_deal THEN EXIT
		NEXT 
   Loop 
	/* 임시에 배분 내역을 dw_body로 이동 */
	FOR k = 1 TO ll_assort_cnt 
		 ll_index = lds_Dealjob.GetitemNumber(k, "no")
		 dw_body.Setitem(i, "deal_bf_"  + String(ll_index), lds_Dealjob.Object.deal_qty[k])
       dw_body.Setitem(i, "deal_qty_" + String(ll_index), lds_Dealjob.Object.deal_qty[k])
	//	 if ls_shop_cd = "NT3516" then
//		   dw_assort.Setitem(ll_index, "ord_deal_chn", dw_assort.Object.ord_deal_chn[ll_index] - lds_Dealjob.Object.deal_qty[k])
//		 else	 
		   dw_assort.Setitem(ll_index, "ord_deal", dw_assort.Object.ord_deal[ll_index] - lds_Dealjob.Object.deal_qty[k])
//		 end if	 		 

	NEXT
NEXT
dw_body.SetRedraw(True)
Destroy  lds_Dealjob

Return True

end function

public function boolean wf_body_set ();String  ls_modify,   ls_error
String  ls_color,    ls_size 
Long    ll_ord_deal, ll_color_st, ll_color_wd, ll_color_cnt 
Long    ll_ord_tot,  ll_deal_tot, ll_ord_qty, ll_ord_tot_chn,  ll_deal_tot_chn
integer i, k

/* 기존에 생성한 칼라 헤드 삭제 */
ll_color_cnt = Long(dw_assort.Describe("evaluate('count(color for all distinct)',0)"))
FOR i = 1 to ll_color_cnt
   dw_body.Modify("Destroy t_color_" + String(i)) 
NEXT 

/* assort 내역 조회 */
il_rows = dw_assort.Retrieve(is_style, is_chno)

/* order 정보 Set */
ll_ord_tot      =  Long(dw_assort.Describe("evaluate('sum(ord_qty)',0)")) 
ll_deal_tot     =  Long(dw_assort.Describe("evaluate('sum(ord_deal)',0)")) 
ll_ord_tot_chn  =  Long(dw_assort.Describe("evaluate('sum(ord_qty_chn)',0)")) 
ll_deal_tot_chn =  Long(dw_assort.Describe("evaluate('sum(ord_deal_chn)',0)")) 
dw_1.Setitem(1, "ord_qty",  ll_ord_tot)
dw_1.Setitem(1, "ord_deal", ll_deal_tot)
dw_1.Setitem(1, "ord_sale", ll_ord_tot - ll_deal_tot)
dw_1.Setitem(1, "ord_qty_chn",  ll_ord_tot_chn)
dw_1.Setitem(1, "ord_deal_chn", ll_deal_tot_chn)

/* 칼라 및 사이즈 셋 */
ll_color_st = 1824
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
		ll_ord_qty  = dw_assort.object.ord_qty[i]
	   ll_ord_deal = dw_assort.object.ord_deal[i] 
      ls_modify = ' t_size_'   + String(i) + '.Text="' + ls_size + '"' + &
		            ' t_size_'   + String(i) + '.Visible=1' + &
                  ' t_'        + String(i) + '.text="' + String(ll_ord_qty) + '"' + &
                  ' t_'        + String(i) + '.Visible=1' + &
                  ' t_ord_'    + String(i) + '.text="' + String(ll_ord_deal) + '"' + &
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

public subroutine wf_retrieve_set ();/* 기존 배분내역 조회 */
String ls_shop_cd,   ls_find , ls_shop_lv, ls_shop_lv1, ls_area_cd
Long   ll_row, ll_row_cnt, ll_assort_cnt , ll_temp_cnt
Long   i, k, ll_deal_qty , jj
decimal ldc_rate

ll_row_cnt    = dw_db.RowCount()
ll_assort_cnt = dw_assort.RowCount()
IF ll_row_cnt < 1 THEN RETURN 

dw_1.Setitem(1, "yymmdd", Date(String(dw_db.GetitemString(1, "out_ymd"), "@@@@/@@/@@")))

dw_temp.Retrieve(is_style, is_chno, is_deal_type)
ll_temp_cnt = dw_temp.RowCount()

dw_body.SetRedraw(False) 
dw_body.Reset()
For i = 1 to ll_row_cnt 
	IF ls_shop_cd <> dw_db.object.shop_cd[i] THEN 
      ls_shop_cd =  dw_db.object.shop_cd[i] 
		ls_shop_lv =  dw_db.object.b_shop_lv[i] 
		ls_shop_lv1 =  dw_db.object.b_shop_lv1[i] 
		ls_area_cd =  dw_db.object.b_area_cd[i] 		
		ll_row     =  dw_body.insertRow(0)
		
      dw_body.Setitem(ll_row, "shop_cd",   ls_shop_cd)
      dw_body.Setitem(ll_row, "shop_nm",   dw_db.object.shop_nm[i])
      dw_body.Setitem(ll_row, "shop_stat", dw_db.object.shop_stat[i])	
      dw_body.Setitem(ll_row, "shop_lv",   ls_shop_lv)	
      dw_body.Setitem(ll_row, "shop_lv1",   ls_shop_lv1)	
      dw_body.Setitem(ll_row, "area_cd",   ls_area_cd)			
		
	END IF 
	ls_find = "color = '" + dw_db.object.color[i] + "' and size = '" + dw_db.object.size[i] + "'"
   k = dw_assort.find(ls_find, 1, ll_assort_cnt)	
	IF k > 0 THEN 
		ll_deal_qty = dw_db.GetitemNumber(i, "deal_qty")
		dw_body.Setitem(ll_row, "deal_bf_"  + String(k), ll_deal_qty)
		dw_body.Setitem(ll_row, "deal_qty_" + String(k), ll_deal_qty)
	END IF
	
	For jj = 1 to ll_temp_cnt
	ls_find = "shop_cd = '" + ls_shop_cd + "'"
   k = dw_temp.find(ls_find, 1, ll_temp_cnt)	
	IF k > 0 THEN 
		ldc_rate = dw_temp.object.deal_rate[k]
		dw_body.Setitem(ll_row, "deal_rate" ,  ldc_rate)
	END IF
	next
Next



dw_1.ResetUpdate()
dw_body.ResetUpdate()
dw_body.SetRedraw(True)

end subroutine

on w_52010_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_remark=create st_remark
this.dw_temp=create dw_temp
this.dw_db=create dw_db
this.dw_assort=create dw_assort
this.st_trend=create st_trend
this.cb_1=create cb_1
this.cb_2=create cb_2
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_remark
this.Control[iCurrent+3]=this.dw_temp
this.Control[iCurrent+4]=this.dw_db
this.Control[iCurrent+5]=this.dw_assort
this.Control[iCurrent+6]=this.st_trend
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.dw_2
end on

on w_52010_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_remark)
destroy(this.dw_temp)
destroy(this.dw_db)
destroy(this.dw_assort)
destroy(this.st_trend)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.dw_2)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2002.01.08                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_out_seq, ls_out_seq_nm, ls_trend, ls_country
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style_no"				
		   ls_style = MidA(as_data, 1, 8)
			ls_chno  = MidA(as_data, 9, 1)
			IF ai_div = 1 THEN 	
				if gs_brand <> 'K' then
					IF gf_style_chk(ls_style, ls_chno) THEN		
						SELECT OUT_SEQ,
						 DBO.SF_INTER_NM('032',OUT_SEQ)
						into :ls_out_seq, :ls_out_seq_nm		  
						FROM tb_12028_d
						WHERE STYLE = :ls_style
						AND   CHNO = :ls_chno;
						
						dw_head.SetItem(al_row, "out_seq_nm", ls_out_seq_nm)
						
						SELECT  dbo.sf_inter_nm('122', concept), dbo.sf_inter_nm('000',country_cd)
						INTO  :ls_trend, :ls_country
						FROM vi_12020_1 WITH(NOLOCK)
						WHERE STYLE = :ls_style
						and chno =  :ls_chno;
						
						st_trend.text = "※ " + ls_country + " 생산, "  + ls_trend +  " 제품군입니다!!"
						
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
				ls_style = lds_Source.GetItemString(1,"style")
				ls_chno = lds_Source.GetItemString(1,"chno")				
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("deal_type")
				
			SELECT OUT_SEQ,
						 DBO.SF_INTER_NM('032',OUT_SEQ)
				into :ls_out_seq, :ls_out_seq_nm		  
				FROM tb_12028_d WITH(NOLOCK)
				WHERE STYLE = :ls_style
				AND   CHNO = :ls_chno;
	
				dw_head.SetItem(al_row, "out_seq_nm", ls_out_seq_nm)
				
					SELECT  dbo.sf_inter_nm('122', concept), dbo.sf_inter_nm('000',country_cd)
					INTO  :ls_trend, :ls_country
					FROM vi_12020_1 WITH(NOLOCK)
					WHERE STYLE = :ls_style
					and chno =  :ls_chno;
					
					st_trend.text = "※ " + ls_country + " 생산, "  + ls_trend +  " 제품군입니다!!"		
					
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

is_deal_type = dw_head.GetItemString(1, "deal_type")
if IsNull(is_deal_type) or Trim(is_deal_type) = "" then
   MessageBox(ls_title,"배분타입 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_type")
   return false
end if

ii_enable_qty = dw_head.GetItemNumber(1, "enable_qty")
if IsNull(ii_enable_qty) or ii_enable_qty < 0 then
	ii_enable_qty = 0
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.28                                                  */	
/* 수정일      : 2002.01.28                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

IF wf_body_set() = FALSE THEN RETURN

il_rows = dw_db.retrieve(is_style, is_chno)

IF il_rows > 0 THEN
	st_remark.text = '이미 배분되여 있습니다.'
	wf_retrieve_set()
	cb_delete.enabled = true
   ib_NewDeal = False
ELSE
	st_remark.text = '배분 처리중 .........'
	ib_NewDeal = wf_Deal() 
	cb_delete.enabled = false	
	st_remark.text = ''
END IF

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)

IF ib_NewDeal THEN 
	ib_changed = true
   cb_update.enabled = true
   cb_excel.enabled = false
END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight")

dw_assort.SetTransObject(SQLCA)
dw_temp.SetTransObject(SQLCA)
dw_db.SetTransObject(SQLCA)

dw_1.insertRow(0)


end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.30                                                  */	
/* 수정일      : 2002.01.30                                                  */
/*===========================================================================*/
long     i, k, ll_row_count, ll_assort_cnt, ll_find, ll_deal_qty , ll_dbrow_cnt, ll_test
datetime ld_datetime
String   ls_shop_cd, ls_color, ls_size, ls_find
String   ls_out_ymd, ls_dbout_ymd

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1
   dw_1.AcceptText() 

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

/* ORDER량 초과배분 여부 체크 */ 
FOR k = 1 TO dw_ASSORT.RowCount()
  	 ll_deal_qty = dw_body.GetitemNumber(1, "c_deal_" + String(k)) 
		ll_test =dw_assort.Object.ord_qty[k] + dw_assort.Object.ord_qty_chn[k]
//		messagebox(string(ll_test), string(ll_deal_qty))
	 IF ll_deal_qty > dw_assort.Object.ord_qty[k] + dw_assort.Object.ord_qty_chn[k] THEN 
		 MessageBox("오류", "[" + dw_assort.GetitemString(k, "color") + "/" + & 
		                    dw_assort.GetitemString(k, "size") + "] 배분량이 초과 하였습니다,")
		 
		 Return -1 
	 END IF
NEXT

/* 출고 예정일 처리 요망 */
ls_out_ymd = String(dw_1.GetitemDate(1, "yymmdd"), "yyyymmdd")
IF isnull(ls_out_ymd) or Trim(ls_out_ymd) = "" or ls_out_ymd < String(ld_datetime, "yyyymmdd") THEN
	MessageBox("경고", "출고예정일을 등록 하십시오")
   dw_1.SetColumn("ymd")
	dw_1.SetFocus()
	Return -1
END IF


ll_dbrow_cnt = dw_db.rowcount()
ls_dbout_ymd = dw_db.getitemstring(1, "out_ymd")

if ls_out_ymd <> ls_dbout_ymd then
	for i = 1 to ll_dbrow_cnt
		dw_db.setitem(i, "out_ymd", ls_out_ymd)
	next
end if	


ll_assort_cnt = dw_assort.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! OR idw_status = DataModified! THEN	
		ls_shop_cd = dw_body.GetitemString(i, "shop_cd")
      FOR k = 1 TO ll_assort_cnt 
			IF dw_body.GetItemStatus(i, "deal_qty_" + String(k), Primary!) = DataModified! OR  dw_body.GetItemStatus(i, "deal_qty_" + String(k), Primary!) = NewModified! THEN 
				ll_deal_qty = dw_body.GetitemNumber(i, "deal_qty_" + String(k))
				ls_color = dw_assort.GetitemString(k, "color")
				ls_size  = dw_assort.GetitemString(k, "size") 
				ls_find  = "shop_cd = '" + ls_shop_cd + "' and color = '" + ls_color + "' and size = '" + ls_size + "'"
				ll_find = dw_db.find(ls_find, 1, dw_db.RowCount())
				IF ll_find > 0 THEN
					dw_db.Setitem(ll_find, "deal_qty", ll_deal_qty)
               dw_db.Setitem(ll_find, "mod_id",   gs_user_id)
               dw_db.Setitem(ll_find, "mod_dt",   ld_datetime)
				ELSE
					ll_find = dw_db.insertRow(0)
               dw_db.Setitem(ll_find, "style",    is_style)
               dw_db.Setitem(ll_find, "chno",     is_chno)
               dw_db.Setitem(ll_find, "shop_cd",  ls_shop_cd)
               dw_db.Setitem(ll_find, "color",    ls_color)
               dw_db.Setitem(ll_find, "size",     ls_size)
               dw_db.Setitem(ll_find, "deal_qty", ll_deal_qty)
		         dw_db.Setitem(ll_find, "out_ymd",  ls_out_ymd)					
               dw_db.Setitem(ll_find, "reg_id",   gs_user_id)
				END IF
			END IF
		NEXT
   END IF
NEXT


//IF dw_1.GetItemStatus(i, 0, Primary!) = NewModified! OR dw_1.GetItemStatus(i, 0, Primary!) = DataModified! THEN
//   FOR i=1 TO dw_db.RowCount()
//       dw_db.Setitem(i, "out_ymd", ls_out_ymd)
//	NEXT 
//END IF

il_rows = dw_db.Update()

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

event open;call super::open;datetime ld_datetime
gf_sysdate(ld_datetime)

dw_1.Setitem(1, "yymmdd", Date(ld_datetime))

end event

event ue_delete;/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String ls_style_no, ls_ok, ls_style, ls_chno

	 ls_style_no  = dw_head.getitemstring(1, "style_no")
	 if IsNull(ls_style_no) or Trim(ls_style_no) = "" or LenA(Trim(ls_style_no)) <> 9 then
	   MessageBox("경고!","대상 품번을 입력하십시요!")
	   dw_head.SetFocus()
	   dw_head.SetColumn("style_no")
  		ls_ok = "N"
  	 else	
		ls_ok = "Y"
		ls_style = MidA(ls_style_no, 1,8)
		ls_chno  = MidA(ls_style_no, 9,1)
    end if
	 	
	 
	if ls_ok <> "N" 	 then

  		   delete from tb_52030_m
			where  style = :ls_style
			and    chno  = :ls_chno;
		
			commit  USING SQLCA;  
			MessageBox("알림!","삭제되었습니다!")
	
	ELSE
		   MessageBox("경고!","처리조건을 모두 입력하십시요!")
	END IF	
	 
		

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_52010_e","0")
end event

type cb_close from w_com010_e`cb_close within w_52010_e
end type

type cb_delete from w_com010_e`cb_delete within w_52010_e
integer x = 1536
end type

type cb_insert from w_com010_e`cb_insert within w_52010_e
boolean visible = false
string text = "복사(&C)"
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_52010_e
end type

type cb_update from w_com010_e`cb_update within w_52010_e
end type

type cb_print from w_com010_e`cb_print within w_52010_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_52010_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_52010_e
end type

type cb_excel from w_com010_e`cb_excel within w_52010_e
end type

type dw_head from w_com010_e`dw_head within w_52010_e
integer y = 148
integer width = 3552
integer height = 164
string dataobject = "d_52010_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.28                                                  */	
/* 수정일      : 2002.01.28                                                  */
/*===========================================================================*/
string ls_dep_ymd

CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1

		select dep_ymd 
			into :ls_dep_ymd
		from tb_12020_m a(nolock)
		where  style = :data;
		
		if LenA(ls_dep_ymd) = 8  then 
			  MessageBox("확인",ls_dep_ymd + "일자로 부진처리된 스타일입니다.. 영업 MD에 문의하세요.")
			  Return 1			
		end if
		
		
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;DataWindowChild ldw_child 

This.GetChild("deal_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('520')

end event

type ln_1 from w_com010_e`ln_1 within w_52010_e
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_e`ln_2 within w_52010_e
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_e`dw_body within w_52010_e
integer x = 0
integer y = 536
integer width = 3616
integer height = 1488
string dataobject = "d_52010_d01"
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

event dw_body::constructor;call super::constructor;This.SetRowFocusIndicator(Hand!)

This.GetChild("shop_lv", idw_shop_lv)
idw_shop_lv.SetTransObject(SQLCA)
idw_shop_lv.Retrieve('093')
idw_shop_lv.InsertRow(1)
idw_shop_lv.SetItem(1, "inter_cd", '%')
idw_shop_lv.SetItem(1, "inter_nm", '전체')

This.GetChild("shop_lv1", idw_shop_lv1)
idw_shop_lv1.SetTransObject(SQLCA)
idw_shop_lv1.Retrieve('093')
idw_shop_lv1.InsertRow(1)
idw_shop_lv1.SetItem(1, "inter_cd", '%')
idw_shop_lv1.SetItem(1, "inter_nm", '전체')

This.GetChild("area_cd", idw_area_cd)
idw_area_cd.SetTransObject(SQLCA)
idw_area_cd.Retrieve('090')
idw_area_cd.InsertRow(1)
idw_area_cd.SetItem(1, "inter_cd", '%')
idw_area_cd.SetItem(1, "inter_nm", '전체')


end event

event dw_body::clicked;call super::clicked;string	  ls_KeyDownType
long il_LastClickedRow
boolean ib_action_on_buttonup

If row = 0 then Return


If this.IsSelected(row) Then
	il_LastClickedRow = row
	ib_action_on_buttonup = true
	
//ElseIf Keydown(KeyControl!) then
//	il_LastClickedRow = row
//	this.SelectRow(row,TRUE)
	
Else
	il_LastClickedRow = row
	this.SelectRow(0,FALSE)
	this.SelectRow(row,TRUE)
	
End If  

end event

event dw_body::rowfocuschanging;call super::rowfocuschanging;string	  ls_KeyDownType
long il_LastClickedRow
boolean ib_action_on_buttonup

If newrow = 0 then Return


If this.IsSelected(newrow) Then
	il_LastClickedRow = currentrow
	ib_action_on_buttonup = true
	
//ElseIf Keydown(KeyControl!) then
//	il_LastClickedRow = row
//	this.SelectRow(row,TRUE)
	
Else
	il_LastClickedRow = currentrow
	this.SelectRow(0,FALSE)
	this.SelectRow(newrow,TRUE)
	
End If  

end event

type dw_print from w_com010_e`dw_print within w_52010_e
end type

type dw_1 from datawindow within w_52010_e
integer y = 392
integer width = 3611
integer height = 136
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_52010_d98"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_remark from statictext within w_52010_e
integer x = 1394
integer y = 320
integer width = 1787
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
boolean focusrectangle = false
end type

type dw_temp from datawindow within w_52010_e
boolean visible = false
integer x = 1477
integer y = 624
integer width = 2473
integer height = 1032
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "dw_temp"
string dataobject = "d_52010_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type dw_db from datawindow within w_52010_e
boolean visible = false
integer x = 1371
integer y = 144
integer width = 786
integer height = 432
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "dw_db"
string dataobject = "d_52010_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type dw_assort from datawindow within w_52010_e
boolean visible = false
integer x = 2176
integer y = 152
integer width = 1289
integer height = 556
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "dw_assort"
string dataobject = "d_52010_d99"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
boolean livescroll = true
end type

type st_trend from statictext within w_52010_e
integer x = 105
integer y = 316
integer width = 1280
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "XXXXXXXXXXXXXXXXXXXXXXXXXXXX"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_52010_e
boolean visible = false
integer x = 1083
integer y = 44
integer width = 347
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "붙여넣기"
end type

event clicked;Long   ll_rows, ll_find, i, j, ll_deal_qty  
String ls_shop_cd, ls_ros

ll_rows = dw_2.RowCount()

FOR i = 1 TO ll_rows 
	ls_shop_cd = dw_2.GetitemString(i, "shop_cd")
	ll_find = dw_body.Find("shop_cd = '" + ls_shop_cd + "'", 1, dw_body.RowCount())
	IF ll_find < 1 THEN CONTINUE
	FOR j = 1 TO 10 
		ll_deal_qty = dw_2.GetitemNumber(i, "deal_qty_" + String(j)) 
		//IF ll_deal_qty <> 0 THEN 
			dw_body.Setitem(ll_find, "deal_qty_" + String(j), ll_deal_qty)
		//END IF 
	NEXT
NEXT 

ib_changed = true
cb_update.enabled = true

end event

type cb_2 from commandbutton within w_52010_e
boolean visible = false
integer x = 736
integer y = 44
integer width = 347
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "복사"
end type

event clicked;dw_2.Reset()

dw_body.RowsCopy(1, dw_body.RowCount(), Primary!, dw_2, 1, Primary!)

end event

type dw_2 from datawindow within w_52010_e
boolean visible = false
integer x = 18
integer y = 1156
integer width = 3584
integer height = 764
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_52010_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

