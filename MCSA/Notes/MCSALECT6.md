MBR=> Akhrre 4 primary partition w kol wa7ed mmken a7ot 3leh os mokhtalef laken el partitions el secondary dol akhry 64



GBT=> Da kbir b2a 



Basic Disks: Vs Dynamic Disks => Search for it 

Hneft7 machine w7da 

IDE => byet7t lama el gehaz yet2fl w a2dm 7ga 

SCSi=> da b2a mmken yet7t w el makan wa2ef w brdo el SATA

NVME lazm a2fl el gehaz 





haft7 el gehaz w ashof el disk management mn computer manager 

w han3ml new wizard b2a MBR 7agmo 3 giga 



fat => file allocator table

=> da feh kol sector fel hard w mwgod fen yo3tabar da el khareta bta3ty 



feh 7ga esmha shredding eno yekasar el harddisk  ydaya3 el 7ga 34an feh nas betgeb 

harddisk w t3mlha restores 

el 7al eny a3mlo reformate aktar mn mara y ema abwz el harddisk klo 



hafdl azawed f harddisks ktir b2a l7d m el primary yekhlas w ygblo logical 

w mmken a2dr a shrink => beynazl el mesa7a yemeno 

w lma  b3d shrink lw el msa7ten el unallocated bo3ad 3n ba3d m3rfsh adefhom 3la ba3d 

bs feh application yenf3 ye3mloha 



lma bage a3ml extend lazm el mesa7a tkon oryba meny 3la yemeny el b3ed da mbshofosh 





New spanned volume beye2dr yegama3hom w akhod el a7gam ely ana 3wzha mn kol makan fady f kol harddisk 

Cant be done on basic hard disk , byesht8l 3la Dynamic harddisks bs 





f ana mmken a7ml operating system 3la basic 3ady w b3d kda a7mlo dynamic kda zay el fol 

w el data msh hye7slha loss 

lw 7welt dynamic into basic hye7sl loss 





Dynamic b2a leh meeza eny a2dr a3mlo spanning wgm3 el 7gat dlw2t b2a 

lma a3ml spann hy2oly a7wlholk spann walla la f ehna han7wlo hyet7wl 





ely output mn el span da b2a el write bta3o sloooow Cant be used in Database or logs or web serving 



READ => FAST



================================================================

el 7al RAID (Striping)(B3mlo b new striping)

w da el read wel write sare3 w el data btetkhazn nosha 3la harddisk w el nos el tany 3l hard disk tany 



RAID0

bs lazm ykon el hards nafs el no3 w nafs el mesa7a brdo belzbt bs brdo myenf34 

f 7alet el basic f hy7wlholy dynamic 





bs moshklet da en lw goz2 mn el disk etdarab el noskha el tnya hto2a3 brdo 



======================================================================

RAID 1 da b2a hyeb2a feh 2 drive 2ad b3d bs beykon feh 7ga esmha mirror 

y3ne lazm yet2kd en el etnen harddisk ly mtgm3en dol 3lehom nafs el data 



kda el write b2a medium, READ => FAST kdakda => bs el mesa7a ely hakhsrha hatkon el nos lel asaf 



=====================================================

RAID 5 



ana hageb 3 hards msln aw aktr 

haktb f 7ta fel awlany  wel goz2 el tany f el tany  7ta w a3ml parity fel talet

f lazm a7ot 3 harddisks aw aktr bs el write da b2a low  



w ely beyro7 mne 7wale 20% msln mn 67% into 94% bah2dr astakhdmo mn  mesa7a ely 7atetha l tagme3et el hards de w el ba2y beyro7 parity bs brdo slow 

===============================================



mmken a3ml virtual harddisks b2a w beykon .vhd



VHD aw VHDX el 2ola static bs el tnya dynamic w t2dr t expand br7tk 3ady 

el file da msln mmken a3mlo mn harddisk mo3yan tamam w b3d kda a2dr a3mlo offline w de attach w akhdo copy w a7otof f host machine msln w a3mlo attach w lw 3wz ashelo a3mlo deattach b3den 

================================================

RAID 6 katar el harddisk ba3et el parity 

============================================

RAID 1+ 0 => RAID 10 da game3 awl raid b tany raid 

=================================================

STORAGE SPACES:



byakhod kol el physical discs 7ta lw mokhtlfen sata w scsi w ay 7ga tnya msln 

w ye7otohom f storage pool w a2dr atala3 mnha virtual harddisks ktir b2a w a3ml w a3ml mn kol harddisk partitions b2a br7te shbh ely 3nde 



=================================================

TASK => Screen shot mn el 7ta bta3et el virtual disks w screan shot mn el raid 5 w el mirror mn el computer management 

