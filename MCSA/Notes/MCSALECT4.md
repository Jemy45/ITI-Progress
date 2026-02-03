#### **DHCP (Single Scope On DHCP)**

* Join DC2 into Active directory from this pc => rename pc=> change  then put domain or from server manager
* Login using administrator of iti.local 34an a2dr ash8l el dhcp l2eny lw ft7t el local administrator msh hye2dr y3ml 7ga w hyotlob eny a7mlo
* download dhcp then configure it lazm tekhtar authorization f ana talama dakhel bel administrator f ha3l commit
* Tools => DHCp => IPV4 click ymen w a3ml new scope w asameh SC1
* Scope => 10.10.10.50 => 10.10.10.254 w ha3ml exclude 10.10.10.200 => 10.10.10.220 for printers msln
* w haseb el subnet delay 0 34an da awl DHCP server laken lw 3nde wa7ed tany ablo f hade l da delay 34an aseb lel awl forsa
* Lease Time 1hr bs , Default gateway 10.10.10.10, dns hazawed 8.8.8.8 m3 10.10.10.1 w b3d kda next w msh h7ot WINS
* lma a3ml pc1 automatic take from dhcp hala7ez enp hyakhod mn network el VMware f ana ha3ml
* edit => virtual network editor => w hados 3la nat w b3d kda change setting w b3d kda nat tany w ashel el check bta3 el dhcp ely hwa akher check khales mwgoda
* 2 Commands for get refresh ip if it doent work (ipconfig /release => btms7 el config 34an yakhod mn gdid, ipconfig /renew => w da 34an yegbr el pc takhod mn el DHCP
* lw 3mlt ipconfig /all hala7ez en dns server hala2y 10.10.10.1 w el alternative bta3o 8.8.8.8
* mmken el card bta3 VMware bta3y yakhod mn el DHCP da brdo bs ana 3nde 3al ghaz kan m3mol static
* Make another scope in range 192.168.1.10 into 254 w ha3ml exclude l 220 w 230 whadeh gateway bs w hashel dns w active directory w kol 7ga hatkon fadya mn el ba2y w b3d kda next
* Dlw2t hzawed server Options w ha7ot DNS 8.8.4.4 -> de b2a kalamha hyemshy 3la SC2 laken SC1 el scope options hya ely htmshy

===========================================================================================================

NOTE: Ana leh mmken a3ml reserve lel IP address l 7ad

lw 7ad mo3yan msln aw modeer leh policy mo3yana 3wz a3adeha mn el firewall w yetl3 3la internet b tare2a mo3yana f da a3mlo reverse

Enma el Servers lazm takhod static l2en lw el DHCP wa2a3 kda el server hyakhod Apipa f el service hto2a3

==============================================================================================================

#### **How to reserve IP**

* **akhosh 3la el address leases w a3ml click ymen w a3ml reserve**
* 

**### SuperScope**

* mmken a3ml super scope click ymen 3la ipv4 w new super scope w Akhtar el etnen w hyeb2o el etnen b2o ta7t 7ga esmha super scope shabah el NIC Teaming w lw 3mlt delete hyerg3o yetfako tany (Faydeto eno lw khareg msln 3la internet w yshof anho card fady w yedy mno )

**==================================================================================================================**

**NOTE:**

Lw 3nde nas tanya f network tanya msln w 3wza takhod mn dhcp f lma y3mlo broadcast msh hyesm3hom el dhcp f eh ely hye7sl

lazm el router a3ml 3leh dhcp relay agent w bey3de ely khareg mn el router da UNICAST w yro7 b2a lel network el tanya yewslo lel DHCP f y7es behom w yb3tlohom

**==================================================================================================**

**For get all network card on my pc  getmac /v  (el computer by default feh 3 cards wifi, ethernet, Bluetooth)**



#### **Deny Mac address mo3yan 34an myakhodsh ip**

**eny ashof el address leases w click ymen w a3mlha deny w lazm a3ml lel deny enable**

**w el allow nafs el she2 w mmken tet3ml fel bet 3ady b nafs el taree2a el allowed a7sn**

**tyb b2a lw hwa 7at el bta3a static f el 7al eny akhosh 3la el firewall w a2flo a2ol en el macs de bs hya ely t3de mn el firewall**

**tyb feh 7ga esmha b2a mac spoofing w de en 7ad yakhod MAC address bta3 7d w y7oto virtualized w yekhosh w el 7al bta3ha**

**eny a3ml port security b2a w 7agat CCNA**



**En ana a7ot 7ga fel Deny da y3ne el reservation msh htefr2 b2a 7ta lw 3amel l mac reserved kda kda hatetshal msh takhod ip y basha w lw hashel el deny tany 34an yerg3 yakhod ip lazm a3ml disable lel allow**



**=====================================================================================================**

### **FAIL OVER**

En akhale DHCP yefdl backup lma DHCP tany yo2a3 ana a2om aw mmken ykon load balancing f lazm ykon f beena heart beat 34an a3rf eny 3ayesh lsa

* H7amel DHCP on DC1
* haft7 DC2 w ha3ml click ymen 3la ipv4 w configure fal over w hakhtar network 10.0.0.0 w ha3ml browse advanced w find DC1 w hakhtaro
* el LeaseTime ely b7oto da bey overwrite kol el lease time bta3 DC2 w byeb2a nafs el rakam 3la el 2 servers m3 b3d
* 3ande ekhtyaren b2a hot standby wa7ed actve wel tany standby w ana Akhtar ely ana 3wzo ykon hot standby aw active w a7otelo nesb2a b2a yeshel ad eh lw el server el tany w23 y3ne hakhod msln 5% mn el ips w awz3 mnha  aw mmken hot balancing w Akhtar kol w7ed yesht8l b nesbet eh
* State Switch Over da bta3et eh b2a de 34an lw msln el DHCP el assay bta3y bye3ml update w b3dha wa2a3 f b3d el w2t da el nesba htetsha2lb y3ne el hotstandby hyeb2a hwa el 90% w el asasy hyb2a 10% w lma y2om el active tany b2a yeb2a yerga3 yakhod mako tany w yerg3 yeb2a active



**=====================================================================================================**

### **DHCP Migration:**

* **en ana a3ml migration lel dhcp database le DC1 msln w a7otha f nafs le mkan ely akhod mn DC2 el database bta3ha 34an y3rf ye2raha wa2f ma msln DC2 ykon m7tag upgrade w ana lazm aw23 el service f ha7aml msln 3la DC1 windwos server 2025 w ykon updated w b3d kda a3ml migration w b3d kda a7ml 3la DC2 b2a el updated w mmken akhaleh failover l one b2a aw arag3 tany br7te b2a** 
* **el mkan da C:\\windows\\system32\\dhcp\\backup**
* **h2af 3la DC2.iti.local w click ymen w ha3ml backup w akhod backup dlw2t 3ady w b3d kda aro7 lel mkan wakhdo copy**
* **b3d kda a7oto 3la DC1 f nafs el makan ana hakhod folder backup klo 3latol w aro7 a3mlo replace hnak** 
* **b3d kda ha2af 3la DC1.iti.local w b3d kda a3ml restore w Akhtar el file el mfrod ydeny restored succeeded** 
* 
**========================================================================================================**

#### **Operation Master Roles:**

**FSMO role (Flexible master operation role)=>5 roles** 



**ay gehaz mmken ykon hwa ely y2ol bel dor da w y3ml el 5 roles 7ta lw parent aw chikd:**

**On Forest kolha**

1. **Domain naming master: Wa7ed yet2kd mn kol el domain l2en myenf34 7d ykon leh esm zay 7d tany shbh alex.iti.local w dee brdo by default el parent el awl iti.local el DC bt3ha**
2. **Schema master: de database 3ady w brdo ely shyelha by default el parent el iti.local l DC bt3ha aw mmken ay domain tany gwaha** 
2. 
**On Domain Only** 

1. **RID master: da ely bye3ml create lel sid w yet2kd eno unique y3ne myenf34 2 users ykon 3andhom nafs el esm** 
2. **Infrastruture master: da b2a ely byet2kd en el 3laka ben el client wel server trusted mshakel b2a bta3et not resolved aw myenf34 t3ml el user da w kda 34an sabab mo3yan**
3. **Primary Domain controller (PDC) emulator: da 34an lw 7sl moshkla fel passweord hwa bey2ol lazm t force w tkhalas el assword w brdo w2t el time lw 7sl mshakel fel time hwa ely be force y2ol l kol el nas lazm t8ayar el password** 
3. 
**==================================================================================================================**

**Mn el akher DC1 f iti.local hwa ely haykon shayel el khamsa w f kol domain el DC bta3ha hykon hwa ely shayel el 3 bto3 kol domain tyb lw DC1 w2t hal el 2 bto3 el forest mmken ay 7d yeshelhom ah sawa2 el addintional aw rodc aw 7ata child f alex.iti.local bs lazm a3ml transfer lel operation de**

**==================================================================================================================**



**Active Directory schema and how to transfer it:**

**File feh object w attributes bta3et el domain kolo b2a w el policeis w el user w balash al3b feha mmken akhodha w a3ml virtualization w abd2 a8yar 3la machine tanya** 

**w el tare2a ely yenf3 aft7ha beha hya tare2et el mmc**

**Mohema fel interviews w beyetsa2al 3nha ktir (Search for schema and its function)**

**===============================================================================================**

**run => mmc => file => addor remove snapin w dawar 3la msln user and computers=> w e3ml add w b3d kda save as w 7oto 3la el desktop de tare2a 34an a3ml shortcut yeft7le el 7gat bsor3a bdl makhosh 3la el server manager**

**===============================================================================================**



**regsvr32 schmmgmt.dll** => Command 34an yebayen el Schema 3la el gehaz bta3y\\



ha3ml nafs el mwdo3 bta3 el mmc bs hazwd el schema wft7ha b2a 



* Dlw2t ana a2dr a3dl feha w an2lha b2a 
* click ymen 3la active directory schema w b3d kda operation aster w an2lha w myenf34 8er DC wa7ed bs ely yeshelha w yet7km feha 

===============================================================

Domain name master=> a2dr agebha mn Tools=>domain and trusts w b3d kda click ymen 3la active directory domain and trust fo2 3al shmal w a3ml operation masters wn2lha 

=================================================================



#### **el 3 ely 3ma mostawa el domain b2a hala2ehom fen !!!**



click yemen 3la iti.local fel active directory users and computers w manage operation w hanla2y el 3 ne2dr ne8ayar b2a br7tna w lazm kol w7da ely yderha wa7ed y3ne msln el primary mmken yakhod el 3 kolohom y ema msln 

el primary yshel el RID master w el infrastructure wel pdc emulator yshelhom el additional w kda w 

w nafs el 7kaya 3la el 2 bto3 el forest mmken additional yakhod wa7ed wel primary yakhod wa7ed 



\#############################################################################################

#### Configuring DC3 and join it to domain with TLI only 

Download DC3 and install it then choose standard evaluation 



Configure b2a el Name wel DNS wel IP Configuration We e3ml enable lel remote ping w b3d kda dakhalo el domain w neft7 el cli

w n2r n3ml ping w lw 3wz a3ml download l ay seervice dns aw active directory and dhcp ageb el command mn 3la el net w7mlo 



Ana b2a a2dr a3ml manage b eny azwd DC3 3ndo f remotee management 3la DC1 7ml kol el roles 3la DC3 wazabato GUI 

========================================================================================

Task: How to make DC3 additional Active Directory for DC1

RUN THESEE 2 COMMANDS

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools



Install-ADDSDomainController `

-DomainName "iti.local" `

-Credential (Get-Credential) `

-InstallDns `

-NoGlobalCatalog:$false `

-ReplicationSourceDC "DC1.iti.local" `

-Force







