###### **What is the meaning of Ubuntu Image ??**

y3ne ana khadt noskha mn el files bta3et ubuntu w 7atetha f layer laken mlosh 3laka bel kernel wla bel OS



###### **Lw ana 3wz a7ml /bin/bash bs w ash8lha f image Hal ha7tag ubuntu image kamla walla image feha 4 libraries bta3etha bs ??**

Base image => scratch y3ne image fady w ha7ot fo2ha 4 ldd files (libraries) w fo2hom el bash y3ne kda el image bt3ty kolha 3la b3d mokwana mn 5 files



###### **Union File System**

Ana bkon shayef el container layer k 2enohom layer wa7da w de betkon el mount point bta3ty

w kol el layers read only m2drsh a3dl 8er fel container layer w bye7sl 7ga esmha CoW copy on write y3ne byakhod noskha w3dl 3leha

(SEARCH MORE FOR TYPE OF UFS(Union File System))



---

Demo

* Make an app for print hello word and sleep for 10000 second

w tala3t el bin file bta3 el code w mlosh ay libraries 3wzaha lw 3mlt ldd msh hyetl3ly 7ga

---

GoLang msh interpreter msh m7taga files libraries mwgoda 3la el system laken hya btl3 files executables

---

* ha3ml scratch dockerfile b2a w ha7ot feh el code da

*FROM scratch*

*COPY scratchapp /scratchapp*

*CMD \["/scratchapp"]*



* Ha3ml b2a docker run lel dockerfile da b2a



**Elso2al hna b2a hal ynf3 aft7 shell fel image bt3ty ely fatet de ??**

La el image de msh hteft7 8er application wa7ed bs lw 3wz ageb el shell lazm akhdo w akhod el libraries bta3ty w a7oto k layer



w mmken a3m From ubuntu:latest

bs de ana kda khadt image mn ubuntu k base kolo w de msh security wise w msh a7sn 7ga



---

Need to learn Prog Languange and understand them eg: pyth, Go, etc

---



================================================================

###### **How to make Dockerfile:**



lazm a3mlo fel mkan ely feh el code 34an yekon shayfo

w awl kla f kol line betkon capital w btkon key word



Kol line 3bara 3n layer fel image:



* **FROM** #hna ba7ot el baseimage



* **COPY** # de btakhod 2 arguments source then destination

el source da el files ely gwa el context(Directory ely 7atet gwah el docker file) a2dr akhod files mn gwa w a7otha fel image

fel example ely fo2 khadt el file esmo scratchapp ely tala3to mn build code el golang w ha7oto fel image f mkan esmo /scratchapp



tyb lw feh file tany msln COPY go.mod /test.mod

da brdo hakhdo copy w ha7oto f directory gwa el image esmo /test.mod





* **ADD** source /destination # bageb link mn 3la el internet lw 3wz 7ga w ha7otha f /destination 3ady shbh copy

*ADD https//:ssss/README.md /readme.md*



* RUN # de bt3ml run le command w2t m ana b3ml build lel image

el command da bye3ml container layer w beyrun el command feha w byentog 3ano directories w files byakhod el files w el directories de w y7otha fe layer fel image bta3ty

*RUN apt update \&\& apt install htop*



da command msln hyetl3 mno 2 files /bin/htop w /bin/test msln

dol b2a hyetakhdo w yet7ato 3nde f layer lw7dohom



\*\*\*TAKECARE lazm hna el base bta3y ykon ubuntu 34an apt tkon mwgodo



kda el image takwenha hatkon kda:

Scratch then /scratchapp then /test.mod then /readme.md then 2 folders bto3 el RUN command then el container layer w de hya el writable layer w haygm3le kol el folders ganb b3d hakon shayefha 7ta w7da w gwaha el 5 files ganb b3d kda b3d el /





**LABEL** => Bye3ml label lel image bt3ty



**ENV** => da bey3rf environment variable w bstakhdmo gwa el container 3ady

*ENV iti=46*

mmken astkhdmo lw application feh versions bdl m a3dl fel link ely bta3 el ADD msln ENV VERSION = v.1.0.0 w a7otha variable fl link ganb el ADD



**ARG** app\_version => da bey3rf version lel image bt3ty

w astakhdmo w2t l build



*docker build --build -arg app\_version=v0.2.6 -t iti-image:v0.2.6*

iti-image:v0.2.6 => Da klo esm el image mmken a7ot ay 7ga



kda ana b3ml image b version mo3yana w a2dr astakhdmo brdo f 7ga tnya

eny astakhdmo

k variable gwa el link shbh ENV



**WORKDIR:** w2t m y2om el image yw2fne 3la anho dir



**CMD**: goz2 el ba2y bta3 el command ely byegy b3d el ENTRYPOINT

*CMD\["--help"]*



**ENTRYPOINT** : da awl command aw process hyesht8l gwa el container bt3ty lma t2om w lw m7tetsh entrypoint haysha8al el process el asasya bta3et el base image w f 7alet ubuntu hyft7 /bin/bash



Mn el akher lw hastakhdm astakhdm w7da bs mnhom w yofadal el ENTRYPOINT



eg:ana dlw2t lw msh 7atet entrypoint haykon l default /bin/bash

docker run -it iti-image --help ==> y3ne hy2wm command

kda */bin/bash --help* w fel example el kamel ely ta7t hyb2a kda

*/bin/bash /scratchapp*



eg: lw 7mlt htop w 3mlt

*ENTRTYPOINT\["htop"]*

*CMD\["--help"]*



da el command ely hy2om aw m el container y2om t2om

*htop --help*



* **tyb lw 3wz msln a run kza command b3ml script**

w b3mlo COPY w b3d kda a7oto k ENTRYPOINT

bs take care lazm a3mlo exectutable **chmod +x entry.sh**



kda bel tarteb script in file called any name ex:entry.sh

--
*mkdir -p /iti/*

*touch /iti/file1*

*touch /iti/file2*

*ls /iti*

*sleep 10000*

*--*

Then Convert it into Exectuable

*chmod +x entry.sh*

Then open docker file then copy it
*COPY entry.sh /bin/entry.sh*

Last thing add the ENTRYPOINT

*ENTRYPOINT\["/bin/entry.sh]*



**FULL EXAMPLE THAT HAVE ALL THING ABOVE:**

*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*

*FROM ubuntu:latest*



*ARG app\_version*



*COPY entry.sh /bin/entry.sh*



*COPY scratchapp /scratchapp*



*COPY go.mod /test.mod*



*ADD https://raw.githubusercontent.com/galal-hussein/k3k/refs/heads/main/README.md /readme.md*



*RUN apt update \&\& apt install -y wget*



*RUN wget https://github.com/galal-hussein/k3k/releases/download/$app\_version/k3k*



*LABEL foo=bar*



*ENV iti=46*



*WORKDIR /bin*



*#CMD \["/scratchapp"]*

ENTRYPOINT\["/bin/entry.sh]

$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

---

NOTE:

* Lw bage a3ml build b nafs el version bye3ml overwrite 3la el version bta3y
* zay m 2olt kol line fel code hwa layer f ana lw 3delt f layer moo3yana kol ely fo2ha msh hyet2asar f msh hybos 3leha 3ady w beykon cached lw 3mlt build gdid enma ely ta7teh bey3ed 3lehom msh by3mlohom cache 34an mmken el layer ely ana 3delt 3leha tkon leha ta2seer 3la ely ta7tha

---

###### **DEMOOO For Creating an IMAGE:(APACHE EXAMPLE)**

Make file called for example Dockerfile.apache



FROM ubuntu:latest

RUN apt update \&\&  apt	install -y apache2

ENTRYPOINT \["apache2ctl", "-D", "FOREGROUND"]



da 34an el apache 3latol byet3mlo run fel background f ba2y el ENTRY de 34an yt3mlo run fel FOREGROUND (SEARCH  FOR IT)

---

###### **DOCKER COMMANDS:**



*docker build -f <nameofDockerFile> -t <registry>*

*docker build -f Dockerfile.apache -t docker.io/husseinjalal/apache:latest* .



* **-t** ==> tag
* **Registry:(dol el hub bto3 docker ely a2dr arf3 3lehom le images)**

GCR => Google cloud registry

GHR => Git Hub registry

ACR => azure

ECR => amazon



* **docker.io** => da el default ana lw m7tetsh registry byet7t da

docker.io/username/nameOfImage:version => version de by default lw m7tethash byet7t latest



* **dlw2t ana lw 3mlt login w push yerf3ha 3ady 3la dockerhub 34an ana 7atet el default docker.io**

*docker login   #34an le akhosh docker hub*

*docker push docker.io/husseinjalal/apache:latest*



* -f DockerFile.Apachi => da 34an a2olo en da el docker file ely 3wzk t3mlholy image file bel esm ely gwa el registry ely hwa kan apache
* . => refer lel context 34an ykon 3arf hwa byegb el file mnen w brdo lw 3mlt gwa el code COPY mmken astakhdmha



---

###### **TEST PUSHING ON GITHUB:**

1. Generate Token for GitHub Login
2. Search for GHR w shof el command b2a ezay a3ml login bel token
3. w hkhale el file esmo ghcr.io/username/apachi:latest w a3mlo docker build
4. w takecare mn esm username ely fel GitHub ykon nafs ely ana msmeh w2t el build
5. b3d kda a3ml docker push



**Q!! Leh lma rf3t 3la docker hub rafa3 180M bs enma lma rfa3t 3la GitHub rfa3 80MB + 180MB ?**

l2en docker hub da msh personal space w m3mol 3leh cache le ubuntu base image f matrafa34 34an kda rafa3 files el apachi bs enama GitHub rafa3 b2a el files bta3et el ubuntu w files el apachi.

---

###### **Scenario In Production:**

12 Developer sh8alen 3la nafs el code 3la GitHub w kol 7ga mask kta fel code

w kol 7d 3ndo build environment mokhtlf swa2 versions aw 7ta os mokhtlf msln Linux aw windows

* **El so2al hna b2a Ezay a3ml consistent Environment lel Build bta3 el CODE**

swa2 kan el code da b2a eh Golang, nodejs,ROR?



Docker file byegy doro khan b2a ana ha3ml DockerFile gwa el context(folder ely feh el files kolha w el code bta3y ely mktob msln b go)



*FROM golang:1.24 # de el baseimage bt3te w mwgod golang belversion da 3la dockerhub*

*COPY . /app #copy l kol 7ga gwa el context gwa el image f folder /app*

*WORKDIR /app*

*RUN go build -o scratchapp main.go #da el command ely by3ml build lel golang code bta3y w beytl3le el bin file esmo scratchapp*

*ENTRYPONT \["/app/scratchapp"]*



Build it : docker build -t husseingalal/scrachapp .



dlw2t el developer b2a msh hyektb tany

go build lel file la hyktb docker build



**elscenario el 7a2e2y belzbt hyeb2a kda:**

Developer ktb el code byerf3ha 3la GitHub

GitHub action by3ml CI  f bye3mlha hwa b2a docker build b3d kda 3mlha teest phase w lw tamam byerf3ha 3la docker hub w b3d kda deployment 3la el production  => da el CI/CD

CI => Jenkins, GithubActions,travis w 7gat tnya



tyb lw el developer 3amel code feh syntax error f GitHub w2t el build hyla2y error f hyerg3 bel error k notification lya 

---------------------------------------------------------

(SEARCH ABOUT MULTISTAGE BUILDS)

---------------------------------------------------------

##### **Docker Networking:**

**Host=>**

have card ens0 (192.168.1.100) => main NIC

**After downloading docker:**

Another NIC made: docker0(172.17.0.1) => Da el default bta3 docker

**Making container for example: nginx**

awl 7ga byet3ml network namespace da 34an a2ol lel container enta mlksh d3wa bel route table bta3 el host wla el cards bta3to



el container da b2a beykon leh 7agten 

NIC: eth0 172.17.0.2

Defaultgateway:172.17.0.1 



bs el eth0 de msh beytkon Zahra fel host de bs btkon gwa el nginx m3zola bs m3mol (virtual)veth0 de bridged 3la el NIC bta3 docker0



y3ne kda ana lw 3mlt fel main machine:

ip a => hyezhar 7aggten el main NIC w el docker 0
lw dakhalt 3la el container w 3malt 

ip a => hyezhar el veth b ip docker0 w eth0 bta3 el container 

-----------------------

**Command for open bash inside the container w afdal gwah**

*docker exec -it rkamelcontainer bash*

-----------------------

**Docker Network Commands:**

*docker network ls*

*docker run --network=host*

*docker run --network=none # de mmken astakhdmha k securewise lw msln h train model ai f msh ha7tago yetla3 3al net* 

*docker network inspect bridge*

*-----------------------*

###### <b>How to add a network b2a shabah docker0 ?</b>



kda ana ha3ml network we esmha iti w subnet bt3ha kaza w tkon bridge 

w ha3mlha msln run lel container bta3 el apachi 3la el network ely lsa 3amelha



*docker network create --subnet 10.0.0.0/16 --driver bridge iti*

*docker run -d --network iti husseinjalal/apache:latest*



*lw 3wz awsl lel container b2a mn el machine 34an ashof el content* 

*curl 172.17.0.2*



bs el command da ynf3 lw ana local 3la nafs el ghaz f ana shayef el container w shayef el ip ely gwa 

tyb lw ana b2a bara f network tnya khales w el server bta3y 3ndo 

public ip 1.1.1.1



lw 3mlt curl 1.1.1.1 hyedeny error 



F lazm a3ml port forwarding b7es eny lma awsl lel lel machine bel ip a2ol lel public da wdeny 3la port mo3yan w wadeny 3al container bel port ely mfto7 3ndha 



*docker run -d -p 8000:80 nginx*

*docker run -d -p 8888:80 husseinjalal/apache*



<b>kda ana awmt el container bel portforwarding </b>

<b>dlw2t lw 3mlt </b>

*curl 1.1.1.1:8000*

*curl 1.1.1.1:8888*



***haywadeny lel container gwa kda w yeft7le content el apache wel nginx***



###### <b>DNS:Sh8al f same el network bs mn 8er ay configurations </b>

ha3ml 2 containers 

iti-container1 w iti-container2 w hakhalehom el etnen f nafs el network iti 

*docker run -d --name iti-container1 --network iti nginx*

*docker run -d --name iti-container2 --network iti nginx*



dlw2t lw dakhalt gwa iti-container1

*docker exec -it iti-container1 bash*



w 3mlt ping iti-container2 hy3ml ping



enma lw 3mlt iti-container3 f network tany msln f msh hyerda y3ml ping lazm ykonio f nafs el network 



*-----------------------------------------*

###### <b>Docker Volumes:by3ml 7ga esmha Bind Mount</b>



Da b2a 34an lw ana baktb 7gat fel container w 7as w etms7 f el data htetshal 

f ana for example msln 3nde data btetkatab fe

/var/lib/mysql 

haro7 a2ol lel container b2a ro7 ektb 3ala el host f file tany w sabet 34an lw el container baz 



Summary: 

Container Hyektb kol 7ga f folder MySQL into folder /db on the Host



Make docker with docker volume yakod el files mn /var/www/html gwa el container w y7otha 3la host f /data aw el 3ks w feh port forwarding brdo y3ne 



*docker run -d -v /data:/var/www/html -p 80:80 nginx*



Inside the host ha3ml b2a file



*cd /data/*

*vim index.html => Haktb gwah hello world*

*docker ps => 34an ageb esm el container aw el rakam bta3o 34an akhosh 3leh* 

*docker exec -it focused\_pasteur bash*



Inside the Container Bash



cd /var/www/html/

ls

cat index.html

hello world



---------------------------------------------------

Note: Command for Delete all containers on the system



*docker rm -fv $(docker ps -qa)*

---------------------------------------------------

###### **TASK: DAY2**

search ezay a2awm el webapplication bta3 python 3alghaz w b3d kda a2wmo 3la container 



PART - 1



• Build python flask image with the name “ITI-flask-lab2” from repo

&nbsp; https://github.com/meldafrawi/basic-flask-app.git

• The image is preferred to be based on “alpine:3.10” or ubuntu

• Run the image with memory limit 100MB

• Make sure that the image runs successfully on your machine and publish port

&nbsp; 127.0.0.1:5000 to port 80 ON THE HOST

• Create a Docker hub account

• Push the image to your docker hub

• Send the Dockerfile for this image or on github

5 points



PART - 2



• Create a new network and name it “iti-network”

• The new network should be a bridge driver and uses a subnet 10.0.0.0/8

• Run the image nginx:alpine or httpd, and the container should:

&nbsp;    • Have the name “nginx-alpine-iti”

&nbsp;    • Publish the port 80 from within the container to port 8080(PortFowarding)

&nbsp;    • The index page should have the text in <h1>Lab 2 ITI - (your name)</h1>

• You should use volumes for the index page

5 points

















