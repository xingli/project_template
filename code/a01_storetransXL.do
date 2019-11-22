*** in store and out store ***
	 *12/23/2016
	 *Xing Li
	 *In:	"../data/Sample_in_Store_161220.xlsx"
			*"../data/Sample_out_Store_161220.xlsx"
			*"../data/161226-x/Supermarket_Data.xlsx"
	 *Out:	"./dta/a01_d01_instore_raw.dta" - raw file from excel
			*"./dta/a01_d01_outstore_raw.dta"
			*"./dta/a01_d02_transaction.dta" - duplicates dropped, id = SO_Num Sku
			*"./dta/a01_d03_offlineOrder.dta" - id = SO_Num Sku Return
			*"./dta/a01_d04_offlineOrder_raw.dta" - id = SO_Num Sku Return







quietly{
if(0){

**** 00. Load in data ****
**** ================ ****

	import excel using "../data/Sample_in_Store_161220.xlsx", clear first
	save "./dta/a01_d01_instore_raw.dta", replace

	import excel using "../data/Sample_out_Store_161220.xlsx", clear first
	save "./dta/a01_d01_outstore_raw.dta", replace

**** 01. Data cleaning ****
**** ================= ****

	*** load in data ***

	use "./dta/a01_d01_instore_raw.dta",clear
	
	*** remove one errored observation and format the variables **

	list if SO_Num == 9919
	drop if SO_Num == 9919
	destring Amount, replace

	generate double date = clock(SO_Date, "DM20Y hms") 
	format date %tc 
	* 我的天终于找到时间差从哪儿来的了。。。。。。。。没有加double
	drop SO_Date
	rename date SO_Date
	generate instore = 1

	*** appending out-store data ***
	
	append using "./dta/a01_d01_outstore_raw.dta"
	replace instore = 0 if instore == .

	sort Customer_ID instore
	by Customer_ID: generate difinstore = (instore[_N] - instore[1])
	codebook Customer_ID if difinstore == 1
	tab instore if difinstore == 1
	drop if difinstore == 1 & instore == 0  
	drop difinstore
	
	save temp.dta, replace

	*** duplicates in SO_Num and Sku ***
	
	use temp.dta,clear
	sort SO_Num Sku
	by SO_Num Sku: keep if _N > 1
	gsort SO_Num Sku -Price
	generate pricepath = string(Price)
	by SO_Num Sku: replace pricepath = pricepath + "-" + pricepath[_n-1] if _n > 1
	by SO_Num Sku: replace pricepath = pricepath[_N]

	by SO_Num Sku: replace Amount = sum(Amount)
	by SO_Num Sku: replace Qty = sum(Qty)
	by SO_Num Sku: keep if _n == _N
	replace Price = Amount / Qty
	generate discount = 1
	tempfile tmp
	save `tmp', replace

	use temp.dta,clear
	sort SO_Num Sku
	by SO_Num Sku: keep if _N == 1
	append using `tmp'
	replace discount = 0 if discount == .
	save temp.dta,replace
		
	*** formating variables ***

	use temp.dta,clear

	format SO_Num %20.0f
	format Sku %20.0f
	
	foreach var of varlist Customer_ID Category* Business{
		rename `var' temp
		encode temp, gen(`var')
		drop temp
	}
	
	order instore SO_Num Sku Price Qty Amount SO_Date Sku_Name Customer_ID Category* Business
	label var SO_Num "Order ID"
	label var SO_Date "Time"
	label var pricepath "price path of raw data"
	label var instore "0:outstore; 1:instore"
	label var discount "0:nodiscount; 1:collapsed from discounted"
	
	save "./dta/a01_d02_transaction.dta",replace

	*** same customer-time, differnet items, sometimes same order, sometimes different order ***

		use "./dta/a01_d02_transaction.dta", clear

		list SO_Date Customer_ID SO_Num Sku Price Qty Sku_Name if SO_Num == 17924475339 & (Sku == 10001621 | Sku == 10081231), noobs

		sort Customer_ID SO_Date SO_Num
		by Customer_ID SO_Date SO_Num: generate norder = (_n == 1)
		by Customer_ID SO_Date: replace norder = sum(norder)
		by Customer_ID SO_Date: replace norder = norder[_N]
		tab norder

		list SO_Date Customer_ID SO_Num Sku Price Qty Sku_Name if SO_Num == 20685242486 | SO_Num == 20693235276 | SO_Num == 20693235284, noobs

		list SO_Date Customer_ID SO_Num Sku Price Qty Sku_Name if SO_Num == 11070340681 | SO_Num == 11090200731, noobs


**** 02. Summary statistics ****
**** ====================== ****

	** date **

	use "./dta/a01_d02_transaction.dta",clear
	generate date = dofc(SO_Date)
	format date %td
	tabstat date, by(instore) s(min median max) format

	** customers and orders are either instore only, or outstore only **

	use "./dta/a01_d02_transaction.dta",clear
	sort Customer_ID instore
	by Customer_ID: generate difstore = (instore[_N] > instore[1])
	qui count if difstore
	assert(`r(N)' == 0)
	drop difstore

	sort SO_Num instore
	by SO_Num: generate difstore = (instore[_N] > instore[1])
	qui count if difstore
	assert(`r(N)' == 0)
	drop difstore

	** for orders ***

	use "./dta/a01_d02_transaction.dta",clear
	sort SO_Num
	by SO_Num: egen amount = sum(Amount)
	by SO_Num: generate nSku = _N
	egen tag = tag(SO_Num)
	estpost tabstat amount nSku if tag, by(instore) s(count min mean median max) columns(statistics) listwise
	drop tag

	** for customers **

	use "./dta/a01_d02_transaction.dta",clear
	sort Customer_ID
	by Customer_ID: egen amount = sum(Amount)
	by Customer_ID: generate nOrder = _N
	egen tag = tag(Customer_ID)
	estpost tabstat amount nOrder if tag, by(instore) s(count min mean median max) columns(statistics) listwise

	** same types of business for one order. **

	use "./dta/a01_d02_transaction.dta",clear
	sort SO_Num Business
	by SO_Num: generate difbus = (Business[_N] - Business[1])
	qui count if difbus > 0
	assert(`r(N)' == 0)
	drop difbus

	egen tag = tag(SO_Num)
	tab Business instore if tag

	** prices **

	use "./dta/a01_d02_transaction.dta",clear
	tabstat Price, by(instore) s(count min p5 p25 p50 p75 p95 max)
	list SO_Num Sku Price Qty Amount SO_Date Sku_Name if SO_Num == 11060460068, noobs

	** Categories, by frequency **

	use "./dta/a01_d02_transaction.dta",clear
	tab Category1 if instore == 0, sort
	tab Category1 if instore == 1, sort
	tab Category2 if instore == 0, sort
	tab Category2 if instore == 1, sort

	** Categories, by amount **

	use "./dta/a01_d02_transaction.dta",clear
	sort Category1
	collapse (sum) Amount, by(Category1)
	egen totalamount = sum(Amount)
	gsort -Amount
	generate share = Amount / totalamount
	generate cumshare = sum(share)
	format share %3.2f
	format cumshare %3.2f
	generate amountM = Amount / 1e6
	list Category1 amountM share cumshare, sep(100) noobs

	use "./dta/a01_d02_transaction.dta",clear
	sort Category2
	collapse (sum) Amount, by(Category2)
	egen totalamount = sum(Amount)
	gsort -Amount
	generate share = Amount / totalamount
	generate cumshare = sum(share)
	format share %3.2f
	format cumshare %3.2f
	generate amountM = Amount / 1e6
	list Category2 amountM share cumshare, sep(100) noobs

**** 03. instore offline data ****
**** ======================== ****

*** read in order data ***
*** ------------------ ***

	*** load in data ***
	
	set more off
	tempfile tmp
	local afterfirst = 0
	foreach name in "全球购" "闪购" "宠物生活" "厨具" "电脑、办公" "服饰内衣" "个护化妆" "家居家装" "家具" "家用电器" "家装建材" "酒类" "礼品箱包" "母婴" "汽车用品" "生鲜" "食品饮料" "手机" "数码" "图书" "玩具乐器" "鞋靴" "营养保健" "运动户外" "钟表" "珠宝首饰" "影视&教育音像" "退货信息"{
		import excel using "../data/161226-1/03_Operation_Order.xlsx", sheet("`name'") clear firstrow
		if (`afterfirst'){
		append using `tmp'
		}
		save `tmp', replace
		local afterfirst = 1
	}
	foreach folder in "0630" "0731" "0831" "0930" "1031" "1130" "1221"{
		import excel using "../data/161226-2/`folder'/Supermarket_Data.xlsx", sheet("SO") clear firstrow
		append using `tmp'
		save `tmp', replace
	}
	save temp.dta,replace
	set more on

	*** renaming variables ***

	use temp.dta,clear
	list if Category != Category1 in 1/100
	drop Category

	replace Category1 = 一级品类 if Category1 == ""
	replace Category2 = 二级品类 if Category2 == ""
	replace Category3 = 三级品类 if Category3 == ""

	drop 一级品类 二级品类 三级品类
	rename 订单日期 SO_Date
	rename 订单编号 SO_Num
	rename 客户ID Customer_ID
	rename Sku名称 Sku_Name
	rename 店铺名称 Store_Name
	rename 单价 Price
	rename 订购数量 Qty
	rename 订购金额 Amount

	rename 下单类型 SO_Type
	drop NewWeek

	rename 在陈标记 DisplayInStore
	qui count if R < .
	error(`r(N)' > 0)
	drop R
	drop YearD QuarterD MonthD DayD WeekD WeekdayD

	replace SO_Date = 退货日期 if SO_Date == .
	replace SO_Num = 订单号 if SO_Num == .
	replace Qty = 退货数量 if Qty == .
	replace Amount = 退货金额 if Amount == .

	drop 退货日期 订单号 退货数量 退货金额

	replace Price = 优惠后单价 if Price == .
	replace Cost = 仓报价 if Cost == .
	drop 优惠后单价 仓报价 
	save temp.dta,replace

	*** duplicates ***

	use temp.dta,clear
	contract _all 
	drop _freq
	list if SO_Num == .
	drop if SO_Num == .
	generate Return = (Qty < 0)
	save temp.dta,replace
	save "./dta/a01_d04_offlineOrder_raw.dta", replace

	*** abnormal case with same SO_Num, Sku, but different stores ***

	use "./dta/a01_d04_offlineOrder_raw.dta",clear
	sort SO_Num Sku Store_Name
	by SO_Num Sku: generate difstore = (Store_Name[_N] != Store_Name[1])
	format SO_Num %20.0f
	list SO_Num Sku SO_Date Store_Name Price Qty Amount if difstore

	** deal with multiple prices within SO_Num and Sku **

	use temp.dta,clear
	sort SO_Num Sku Return
	by SO_Num Sku Return: keep if _N > 1
	assert Return == 0
	gsort SO_Num Sku -Price
	generate pricepath = string(Price)
	by SO_Num Sku: replace pricepath = pricepath + "-" + pricepath[_n-1] if _n > 1
	by SO_Num Sku: replace pricepath = pricepath[_N]

	by SO_Num Sku: replace Amount = sum(Amount)
	by SO_Num Sku: replace Qty = sum(Qty)
	by SO_Num Sku: keep if _n == _N
	replace Price = Amount / Qty
	generate discount = 1
	tempfile tmp
	save `tmp', replace

	use temp.dta,clear
	sort SO_Num Sku Return
	by SO_Num Sku Return: keep if _N == 1
	append using `tmp'
	replace discount = 0 if discount == .

	** for some Sku == "" **

	list SO_Num Customer_ID Sku Sku_Name if Sku == ""
	replace Sku = "9999999" if Sku == ""
	replace Sku_Name = "Unnown" if Sku_Name == ""
	destring Sku, replace
	save "./dta/a01_d03_offlineOrder.dta", replace



}
}




