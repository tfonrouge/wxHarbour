/*
    $Id$
    Tbl_Address : Table to contain names
*/

#include "wxharbour.ch"

#include "AddressBook.ch"

/*
    Tbl_Address
*/
CLASS Tbl_Address FROM Tbl_Common
PRIVATE:
PROTECTED:
PUBLIC:

	PROPERTY TableFileName DEFAULT "address"

    DEFINE FIELDS
    DEFINE INDEXES

PUBLISHED:
ENDCLASS

/*
	FIELDS
*/
BEGIN FIELDS CLASS Tbl_Address

    ADD INTEGER FIELD "RecId"

    ADD MEMO FIELD "Memo"
        
    /* Calculated Field's */

END FIELDS CLASS

/*
	INDEXES
*/
BEGIN INDEXES CLASS Tbl_Address
    DEFINE PRIMARY INDEX "Primary" KEYFIELD "RecId" AUTOINCREMENT
END INDEXES CLASS

/*
    EndClass Tbl_Address
*/

/*
    Tbl_Country
*/
CLASS Tbl_Country FROM Tbl_Address
PRIVATE:
PROTECTED:
PUBLIC:

    DEFINE FIELDS
    DEFINE INDEXES
    
    METHOD OnAfterOpen()

PUBLISHED:
ENDCLASS

/*
	FIELDS
*/
BEGIN FIELDS CLASS Tbl_Country

    ADD STRING FIELD "Type" SIZE 1 ;
        DEFAULT "0"

    ADD INTEGER FIELD "IDNum"

    ADD STRING FIELD "Name" SIZE 60 ;
        REQUIRED
        
    ADD STRING FIELD "ID2" SIZE 2 ;
        REQUIRED
        
    ADD STRING FIELD "ID3" SIZE 3 ;
        REQUIRED

    /* Calculated Field's */

END FIELDS CLASS

/*
	INDEXES
*/
BEGIN INDEXES CLASS Tbl_Country
    DEFINE PRIMARY INDEX "IDNum" MASTERKEYFIELD "Type" KEYFIELD "IDNum"
    DEFINE SECONDARY INDEX "Name" MASTERKEYFIELD "Type" KEYFIELD "Name" UNIQUE NO_CASE_SENSITIVE
    DEFINE SECONDARY INDEX "ID2" MASTERKEYFIELD "Type" KEYFIELD "ID2" UNIQUE
    DEFINE SECONDARY INDEX "ID3" MASTERKEYFIELD "Type" KEYFIELD "ID3" UNIQUE
END INDEXES CLASS

/*
    OnAfterOpen
*/
METHOD PROCEDURE OnAfterOpen() CLASS Tbl_Country
    LOCAL itm

    IF ::Count = 0
        FOR EACH itm IN CountryList()
            ::Insert()
            ::Field_Name:Value  := itm[ 1 ]
            ::Field_ID2:Value   := itm[ 2 ]
            ::Field_ID3:Value   := itm[ 3 ]
            ::Field_IDNum:Value := itm[ 4 ]
            ::Post()
        NEXT
    ENDIF

RETURN

/*
    EndClass Tbl_Address
*/

STATIC FUNCTION CountryList()
RETURN {;
    {"Afghanistan","AF","AFG",4,"ISO 3166-2:AF"},;
    {"Aland Islands","AX","ALA",248,"ISO 3166-2:AX"},;
    {"Albania","AL","ALB",8,"ISO 3166-2:AL"},;
    {"Algeria","DZ","DZA",12,"ISO 3166-2:DZ"},;
    {"American Samoa","AS","ASM",16,"ISO 3166-2:AS"},;
    {"Andorra","AD","AND",20,"ISO 3166-2:AD"},;
    {"Angola","AO","AGO",24,"ISO 3166-2:AO"},;
    {"Anguilla","AI","AIA",660,"ISO 3166-2:AI"},;
    {"Antarctica","AQ","ATA",10,"ISO 3166-2:AQ"},;
    {"Antigua and Barbuda","AG","ATG",28,"ISO 3166-2:AG"},;
    {"Argentina","AR","ARG",32,"ISO 3166-2:AR"},;
    {"Armenia","AM","ARM",51,"ISO 3166-2:AM"},;
    {"Aruba","AW","ABW",533,"ISO 3166-2:AW"},;
    {"Australia","AU","AUS",36,"ISO 3166-2:AU"},;
    {"Austria","AT","AUT",40,"ISO 3166-2:AT"},;
    {"Azerbaijan","AZ","AZE",31,"ISO 3166-2:AZ"},;
    {"Bahamas","BS","BHS",44,"ISO 3166-2:BS"},;
    {"Bahrain","BH","BHR",48,"ISO 3166-2:BH"},;
    {"Bangladesh","BD","BGD",50,"ISO 3166-2:BD"},;
    {"Barbados","BB","BRB",52,"ISO 3166-2:BB"},;
    {"Belarus","BY","BLR",112,"ISO 3166-2:BY"},;
    {"Belgium","BE","BEL",56,"ISO 3166-2:BE"},;
    {"Belize","BZ","BLZ",84,"ISO 3166-2:BZ"},;
    {"Benin","BJ","BEN",204,"ISO 3166-2:BJ"},;
    {"Bermuda","BM","BMU",60,"ISO 3166-2:BM"},;
    {"Bhutan","BT","BTN",64,"ISO 3166-2:BT"},;
    {"Bolivia, Plurinational State of","BO","BOL",68,"ISO 3166-2:BO"},;
    {"Bosnia and Herzegovina","BA","BIH",70,"ISO 3166-2:BA"},;
    {"Botswana","BW","BWA",72,"ISO 3166-2:BW"},;
    {"Bouvet Island","BV","BVT",74,"ISO 3166-2:BV"},;
    {"Brazil","BR","BRA",76,"ISO 3166-2:BR"},;
    {"British Indian Ocean Territory","IO","IOT",86,"ISO 3166-2:IO"},;
    {"Brunei Darussalam","BN","BRN",96,"ISO 3166-2:BN"},;
    {"Bulgaria","BG","BGR",100,"ISO 3166-2:BG"},;
    {"Burkina Faso","BF","BFA",854,"ISO 3166-2:BF"},;
    {"Burundi","BI","BDI",108,"ISO 3166-2:BI"},;
    {"Cambodia","KH","KHM",116,"ISO 3166-2:KH"},;
    {"Cameroon","CM","CMR",120,"ISO 3166-2:CM"},;
    {"Canada","CA","CAN",124,"ISO 3166-2:CA"},;
    {"Cape Verde","CV","CPV",132,"ISO 3166-2:CV"},;
    {"Cayman Islands","KY","CYM",136,"ISO 3166-2:KY"},;
    {"Central African Republic","CF","CAF",140,"ISO 3166-2:CF"},;
    {"Chad","TD","TCD",148,"ISO 3166-2:TD"},;
    {"Chile","CL","CHL",152,"ISO 3166-2:CL"},;
    {"China","CN","CHN",156,"ISO 3166-2:CN"},;
    {"Christmas Island","CX","CXR",162,"ISO 3166-2:CX"},;
    {"Cocos (Keeling) Islands","CC","CCK",166,"ISO 3166-2:CC"},;
    {"Colombia","CO","COL",170,"ISO 3166-2:CO"},;
    {"Comoros","KM","COM",174,"ISO 3166-2:KM"},;
    {"Congo","CG","COG",178,"ISO 3166-2:CG"},;
    {"Congo, the Democratic Republic of the","CD","COD",180,"ISO 3166-2:CD"},;
    {"Cook Islands","CK","COK",184,"ISO 3166-2:CK"},;
    {"Costa Rica","CR","CRI",188,"ISO 3166-2:CR"},;
    {"C?te d'Ivoire","CI","CIV",384,"ISO 3166-2:CI"},;
    {"Croatia","HR","HRV",191,"ISO 3166-2:HR"},;
    {"Cuba","CU","CUB",192,"ISO 3166-2:CU"},;
    {"Cyprus","CY","CYP",196,"ISO 3166-2:CY"},;
    {"Czech Republic","CZ","CZE",203,"ISO 3166-2:CZ"},;
    {"Denmark","DK","DNK",208,"ISO 3166-2:DK"},;
    {"Djibouti","DJ","DJI",262,"ISO 3166-2:DJ"},;
    {"Dominica","DM","DMA",212,"ISO 3166-2:DM"},;
    {"Dominican Republic","DO","DOM",214,"ISO 3166-2:DO"},;
    {"Ecuador","EC","ECU",218,"ISO 3166-2:EC"},;
    {"Egypt","EG","EGY",818,"ISO 3166-2:EG"},;
    {"El Salvador","SV","SLV",222,"ISO 3166-2:SV"},;
    {"Equatorial Guinea","GQ","GNQ",226,"ISO 3166-2:GQ"},;
    {"Eritrea","ER","ERI",232,"ISO 3166-2:ER"},;
    {"Estonia","EE","EST",233,"ISO 3166-2:EE"},;
    {"Ethiopia","ET","ETH",231,"ISO 3166-2:ET"},;
    {"Falkland Islands (Malvinas)","FK","FLK",238,"ISO 3166-2:FK"},;
    {"Faroe Islands","FO","FRO",234,"ISO 3166-2:FO"},;
    {"Fiji","FJ","FJI",242,"ISO 3166-2:FJ"},;
    {"Finland","FI","FIN",246,"ISO 3166-2:FI"},;
    {"France","FR","FRA",250,"ISO 3166-2:FR"},;
    {"French Guiana","GF","GUF",254,"ISO 3166-2:GF"},;
    {"French Polynesia","PF","PYF",258,"ISO 3166-2:PF"},;
    {"French Southern Territories","TF","ATF",260,"ISO 3166-2:TF"},;
    {"Gabon","GA","GAB",266,"ISO 3166-2:GA"},;
    {"Gambia","GM","GMB",270,"ISO 3166-2:GM"},;
    {"Georgia","GE","GEO",268,"ISO 3166-2:GE"},;
    {"Germany","DE","DEU",276,"ISO 3166-2:DE"},;
    {"Ghana","GH","GHA",288,"ISO 3166-2:GH"},;
    {"Gibraltar","GI","GIB",292,"ISO 3166-2:GI"},;
    {"Greece","GR","GRC",300,"ISO 3166-2:GR"},;
    {"Greenland","GL","GRL",304,"ISO 3166-2:GL"},;
    {"Grenada","GD","GRD",308,"ISO 3166-2:GD"},;
    {"Guadeloupe","GP","GLP",312,"ISO 3166-2:GP"},;
    {"Guam","GU","GUM",316,"ISO 3166-2:GU"},;
    {"Guatemala","GT","GTM",320,"ISO 3166-2:GT"},;
    {"Guernsey","GG","GGY",831,"ISO 3166-2:GG"},;
    {"Guinea","GN","GIN",324,"ISO 3166-2:GN"},;
    {"Guinea-Bissau","GW","GNB",624,"ISO 3166-2:GW"},;
    {"Guyana","GY","GUY",328,"ISO 3166-2:GY"},;
    {"Haiti","HT","HTI",332,"ISO 3166-2:HT"},;
    {"Heard Island and McDonald Islands","HM","HMD",334,"ISO 3166-2:HM"},;
    {"Holy See (Vatican City State)","VA","VAT",336,"ISO 3166-2:VA"},;
    {"Honduras","HN","HND",340,"ISO 3166-2:HN"},;
    {"Hong Kong","HK","HKG",344,"ISO 3166-2:HK"},;
    {"Hungary","HU","HUN",348,"ISO 3166-2:HU"},;
    {"Iceland","IS","ISL",352,"ISO 3166-2:IS"},;
    {"India","IN","IND",356,"ISO 3166-2:IN"},;
    {"Indonesia","ID","IDN",360,"ISO 3166-2:ID"},;
    {"Iran, Islamic Republic of","IR","IRN",364,"ISO 3166-2:IR"},;
    {"Iraq","IQ","IRQ",368,"ISO 3166-2:IQ"},;
    {"Ireland","IE","IRL",372,"ISO 3166-2:IE"},;
    {"Isle of Man","IM","IMN",833,"ISO 3166-2:IM"},;
    {"Israel","IL","ISR",376,"ISO 3166-2:IL"},;
    {"Italy","IT","ITA",380,"ISO 3166-2:IT"},;
    {"Jamaica","JM","JAM",388,"ISO 3166-2:JM"},;
    {"Japan","JP","JPN",392,"ISO 3166-2:JP"},;
    {"Jersey","JE","JEY",832,"ISO 3166-2:JE"},;
    {"Jordan","JO","JOR",400,"ISO 3166-2:JO"},;
    {"Kazakhstan","KZ","KAZ",398,"ISO 3166-2:KZ"},;
    {"Kenya","KE","KEN",404,"ISO 3166-2:KE"},;
    {"Kiribati","KI","KIR",296,"ISO 3166-2:KI"},;
    {"Korea, Democratic People's Republic of","KP","PRK",408,"ISO 3166-2:KP"},;
    {"Korea, Republic of","KR","KOR",410,"ISO 3166-2:KR"},;
    {"Kuwait","KW","KWT",414,"ISO 3166-2:KW"},;
    {"Kyrgyzstan","KG","KGZ",417,"ISO 3166-2:KG"},;
    {"Lao People's Democratic Republic","LA","LAO",418,"ISO 3166-2:LA"},;
    {"Latvia","LV","LVA",428,"ISO 3166-2:LV"},;
    {"Lebanon","LB","LBN",422,"ISO 3166-2:LB"},;
    {"Lesotho","LS","LSO",426,"ISO 3166-2:LS"},;
    {"Liberia","LR","LBR",430,"ISO 3166-2:LR"},;
    {"Libyan Arab Jamahiriya","LY","LBY",434,"ISO 3166-2:LY"},;
    {"Liechtenstein","LI","LIE",438,"ISO 3166-2:LI"},;
    {"Lithuania","LT","LTU",440,"ISO 3166-2:LT"},;
    {"Luxembourg","LU","LUX",442,"ISO 3166-2:LU"},;
    {"Macao","MO","MAC",446,"ISO 3166-2:MO"},;
    {"Macedonia, the former Yugoslav Republic of","MK","MKD",807,"ISO 3166-2:MK"},;
    {"Madagascar","MG","MDG",450,"ISO 3166-2:MG"},;
    {"Malawi","MW","MWI",454,"ISO 3166-2:MW"},;
    {"Malaysia","MY","MYS",458,"ISO 3166-2:MY"},;
    {"Maldives","MV","MDV",462,"ISO 3166-2:MV"},;
    {"Mali","ML","MLI",466,"ISO 3166-2:ML"},;
    {"Malta","MT","MLT",470,"ISO 3166-2:MT"},;
    {"Marshall Islands","MH","MHL",584,"ISO 3166-2:MH"},;
    {"Martinique","MQ","MTQ",474,"ISO 3166-2:MQ"},;
    {"Mauritania","MR","MRT",478,"ISO 3166-2:MR"},;
    {"Mauritius","MU","MUS",480,"ISO 3166-2:MU"},;
    {"Mayotte","YT","MYT",175,"ISO 3166-2:YT"},;
    {"Mexico","MX","MEX",484,"ISO 3166-2:MX"},;
    {"Micronesia, Federated States of","FM","FSM",583,"ISO 3166-2:FM"},;
    {"Moldova, Republic of","MD","MDA",498,"ISO 3166-2:MD"},;
    {"Monaco","MC","MCO",492,"ISO 3166-2:MC"},;
    {"Mongolia","MN","MNG",496,"ISO 3166-2:MN"},;
    {"Montenegro","ME","MNE",499,"ISO 3166-2:ME"},;
    {"Montserrat","MS","MSR",500,"ISO 3166-2:MS"},;
    {"Morocco","MA","MAR",504,"ISO 3166-2:MA"},;
    {"Mozambique","MZ","MOZ",508,"ISO 3166-2:MZ"},;
    {"Myanmar","MM","MMR",104,"ISO 3166-2:MM"},;
    {"Namibia","NA","NAM",516,"ISO 3166-2:NA"},;
    {"Nauru","NR","NRU",520,"ISO 3166-2:NR"},;
    {"Nepal","NP","NPL",524,"ISO 3166-2:NP"},;
    {"Netherlands","NL","NLD",528,"ISO 3166-2:NL"},;
    {"Netherlands Antilles","AN","ANT",530,"ISO 3166-2:AN"},;
    {"New Caledonia","NC","NCL",540,"ISO 3166-2:NC"},;
    {"New Zealand","NZ","NZL",554,"ISO 3166-2:NZ"},;
    {"Nicaragua","NI","NIC",558,"ISO 3166-2:NI"},;
    {"Niger","NE","NER",562,"ISO 3166-2:NE"},;
    {"Nigeria","NG","NGA",566,"ISO 3166-2:NG"},;
    {"Niue","NU","NIU",570,"ISO 3166-2:NU"},;
    {"Norfolk Island","NF","NFK",574,"ISO 3166-2:NF"},;
    {"Northern Mariana Islands","MP","MNP",580,"ISO 3166-2:MP"},;
    {"Norway","NO","NOR",578,"ISO 3166-2:NO"},;
    {"Oman","OM","OMN",512,"ISO 3166-2:OM"},;
    {"Pakistan","PK","PAK",586,"ISO 3166-2:PK"},;
    {"Palau","PW","PLW",585,"ISO 3166-2:PW"},;
    {"Palestinian Territory, Occupied","PS","PSE",275,"ISO 3166-2:PS"},;
    {"Panama","PA","PAN",591,"ISO 3166-2:PA"},;
    {"Papua New Guinea","PG","PNG",598,"ISO 3166-2:PG"},;
    {"Paraguay","PY","PRY",600,"ISO 3166-2:PY"},;
    {"Peru","PE","PER",604,"ISO 3166-2:PE"},;
    {"Philippines","PH","PHL",608,"ISO 3166-2:PH"},;
    {"Pitcairn","PN","PCN",612,"ISO 3166-2:PN"},;
    {"Poland","PL","POL",616,"ISO 3166-2:PL"},;
    {"Portugal","PT","PRT",620,"ISO 3166-2:PT"},;
    {"Puerto Rico","PR","PRI",630,"ISO 3166-2:PR"},;
    {"Qatar","QA","QAT",634,"ISO 3166-2:QA"},;
    {"R?union","RE","REU",638,"ISO 3166-2:RE"},;
    {"Romania","RO","ROU",642,"ISO 3166-2:RO"},;
    {"Russian Federation","RU","RUS",643,"ISO 3166-2:RU"},;
    {"Rwanda","RW","RWA",646,"ISO 3166-2:RW"},;
    {"Saint Barth?lemy","BL","BLM",652,"ISO 3166-2:BL"},;
    {"Saint Helena, Ascension and Tristan da Cunha","SH","SHN",654,"ISO 3166-2:SH"},;
    {"Saint Kitts and Nevis","KN","KNA",659,"ISO 3166-2:KN"},;
    {"Saint Lucia","LC","LCA",662,"ISO 3166-2:LC"},;
    {"Saint Martin (French part)","MF","MAF",663,"ISO 3166-2:MF"},;
    {"Saint Pierre and Miquelon","PM","SPM",666,"ISO 3166-2:PM"},;
    {"Saint Vincent and the Grenadines","VC","VCT",670,"ISO 3166-2:VC"},;
    {"Samoa","WS","WSM",882,"ISO 3166-2:WS"},;
    {"San Marino","SM","SMR",674,"ISO 3166-2:SM"},;
    {"Sao Tome and Principe","ST","STP",678,"ISO 3166-2:ST"},;
    {"Saudi Arabia","SA","SAU",682,"ISO 3166-2:SA"},;
    {"Senegal","SN","SEN",686,"ISO 3166-2:SN"},;
    {"Serbia","RS","SRB",688,"ISO 3166-2:RS"},;
    {"Seychelles","SC","SYC",690,"ISO 3166-2:SC"},;
    {"Sierra Leone","SL","SLE",694,"ISO 3166-2:SL"},;
    {"Singapore","SG","SGP",702,"ISO 3166-2:SG"},;
    {"Slovakia","SK","SVK",703,"ISO 3166-2:SK"},;
    {"Slovenia","SI","SVN",705,"ISO 3166-2:SI"},;
    {"Solomon Islands","SB","SLB",90,"ISO 3166-2:SB"},;
    {"Somalia","SO","SOM",706,"ISO 3166-2:SO"},;
    {"South Africa","ZA","ZAF",710,"ISO 3166-2:ZA"},;
    {"South Georgia and the South Sandwich Islands","GS","SGS",239,"ISO 3166-2:GS"},;
    {"Spain","ES","ESP",724,"ISO 3166-2:ES"},;
    {"Sri Lanka","LK","LKA",144,"ISO 3166-2:LK"},;
    {"Sudan","SD","SDN",736,"ISO 3166-2:SD"},;
    {"Suriname","SR","SUR",740,"ISO 3166-2:SR"},;
    {"Svalbard and Jan Mayen","SJ","SJM",744,"ISO 3166-2:SJ"},;
    {"Swaziland","SZ","SWZ",748,"ISO 3166-2:SZ"},;
    {"Sweden","SE","SWE",752,"ISO 3166-2:SE"},;
    {"Switzerland","CH","CHE",756,"ISO 3166-2:CH"},;
    {"Syrian Arab Republic","SY","SYR",760,"ISO 3166-2:SY"},;
    {"Taiwan, Province of China","TW","TWN",158,"ISO 3166-2:TW"},;
    {"Tajikistan","TJ","TJK",762,"ISO 3166-2:TJ"},;
    {"Tanzania, United Republic of","TZ","TZA",834,"ISO 3166-2:TZ"},;
    {"Thailand","TH","THA",764,"ISO 3166-2:TH"},;
    {"Timor-Leste","TL","TLS",626,"ISO 3166-2:TL"},;
    {"Togo","TG","TGO",768,"ISO 3166-2:TG"},;
    {"Tokelau","TK","TKL",772,"ISO 3166-2:TK"},;
    {"Tonga","TO","TON",776,"ISO 3166-2:TO"},;
    {"Trinidad and Tobago","TT","TTO",780,"ISO 3166-2:TT"},;
    {"Tunisia","TN","TUN",788,"ISO 3166-2:TN"},;
    {"Turkey","TR","TUR",792,"ISO 3166-2:TR"},;
    {"Turkmenistan","TM","TKM",795,"ISO 3166-2:TM"},;
    {"Turks and Caicos Islands","TC","TCA",796,"ISO 3166-2:TC"},;
    {"Tuvalu","TV","TUV",798,"ISO 3166-2:TV"},;
    {"Uganda","UG","UGA",800,"ISO 3166-2:UG"},;
    {"Ukraine","UA","UKR",804,"ISO 3166-2:UA"},;
    {"United Arab Emirates","AE","ARE",784,"ISO 3166-2:AE"},;
    {"United Kingdom","GB","GBR",826,"ISO 3166-2:GB"},;
    {"United States","US","USA",840,"ISO 3166-2:US"},;
    {"United States Minor Outlying Islands","UM","UMI",581,"ISO 3166-2:UM"},;
    {"Uruguay","UY","URY",858,"ISO 3166-2:UY"},;
    {"Uzbekistan","UZ","UZB",860,"ISO 3166-2:UZ"},;
    {"Vanuatu","VU","VUT",548,"ISO 3166-2:VU"},;
    {"Venezuela, Bolivarian Republic of","VE","VEN",862,"ISO 3166-2:VE"},;
    {"Viet Nam","VN","VNM",704,"ISO 3166-2:VN"},;
    {"Virgin Islands, British","VG","VGB",92,"ISO 3166-2:VG"},;
    {"Virgin Islands, U.S.","VI","VIR",850,"ISO 3166-2:VI"},;
    {"Wallis and Futuna","WF","WLF",876,"ISO 3166-2:WF"},;
    {"Western Sahara","EH","ESH",732,"ISO 3166-2:EH"},;
    {"Yemen","YE","YEM",887,"ISO 3166-2:YE"},;
    {"Zambia","ZM","ZMB",894,"ISO 3166-2:ZM"},;
    {"Zimbabwe","ZW","ZWE",716,"ISO 3166-2:ZW"} }
