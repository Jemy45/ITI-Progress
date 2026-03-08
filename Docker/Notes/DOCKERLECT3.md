**DOCKER LOCAL Volumes(VOLUMENAMES):** en ana a3mlo bind 3la el container f vol mo3yan bs el path 

mas2ol 3no docker w a7oto 3la el container f var/lib 

 *docker run -d -v mysql-data:/var/lib/mysql MySQL*



**Bind Mount**: Da eny a7oto f specific folder 3la el host 

--------------------------------------------------------------------

##### **Demo**

**Application + MongoDB**
hn3ml 2 containers wa7ed l mongoDB w da h3mlo volumes 3ady w el container bta3 

el application hykon feh port forwarding 80 => 5000



1. **Pull the application from GitHub**

2. **Create Docker file**



*FROM python:3*

*COPY . /app # h3ml copy 3ady lel application gwa el container*

*WORKDIR /app #aro7 lel path bta3o*

*RUN pip install -r requirements.txt  # ha7ael el requirments*

*ENTRYPOINT \["python", "app.py"]*



<b>3. Build the application</b>



*docker build -t husseingalal/todo .*



<b>4. Run the application</b>

<b>hna a hrun bs 34an ashof hyesht8l walla la w msh hakhaled background msh h7ot -d</b>

*docker run husseingalal/todo*



<b>NOTE: Lazm as2l el developer eh el version ely sh8al 3leha 34an lazm el container tkon nafs el version 34an mtedrabsh el nya </b>



<b>5. Run the container b2a -d w 3al port de (De khatwa mmken tet2al 3leha 34an bdl ma nems7 el container l2en lazm nesha8al el db el awl 34an moshklet el IP)</b>



*docker run -d -p 5000:5000 husseingalal/todo*



<b>6.Run mondo db </b>


*docker run -d mongo # lw awmto kda hyesht8l 3ady bs lazm a3mlo b volume w brdo el ip bta3ha msh static f de moshkla f lazm a3ml network el awl* 



<b>7.Run the container bel IP</b>

<b>hna el moshkla en el ip msh static w lazm agebo mn inspect f 7alaha tkon bel esm Ely m3mola ta7t</b>

<b>(Eft7 el code bta3 applciation w shof el 7ta bta3et MONGO\_HOST w el MONGO\_PORT wel 7gat de) </b>

*docker run -d --name todoapp -e MONGO\_HOST=172.12.0.2 -p 5000:5000 husseingalal/todo*



*---HERE THE RIGHT STEPS TO RUN THE APPLICATION-----*

<b>8 .Create NEtwokr</b>

*docker network create --subnet 10.5.0.0/16 todo*



<b>9 . Run MongoDB</b>

<b>3mlt mongo b tare2et el localvolume 3la el host w 7ateto f network ely 3mlha w be esm mongo </b>



*docker run -d -v mongodb:/data/db --name mongo --network todo mongo:latest*



<b>10 . Run the container</b>

<b>Hna b2a zabat el moshkla bta3et el IP elymsh static w khaleto bel esm 3ady </b>

*docker run -d --network todo --name todoapp -e MONGO\_HOST=mongo -p 5000:5000 husseingalal/todo*

<b>----------------------------------------------------</b>

###### <b>advanced volumes such as nfs or S3FS</b>

<b>TASK Change the Driver y3ne ash8l el volume de 3la S3</b>

<b>y3ne tkon </b>

<b>https://hub.docker.com/r/aekis/docker-mount-s3</b>



1. <b>Download S3 plugin</b>

*docker plugin install mochoa/s3fs-volume-plugin --alias s3fs --grant-all-permissions --disable*

<b>2. h generate key f IAM w hakhdo copy</b>

*docker plugin set s3fs AWSACCESSKEYID=key*

**3.ha7ot ba2y el commands ely fel documentation**

*docker plugin set s3fs AWSSECRETACCESSKEY=secret*

*docker plugin set s3fs DEFAULT\_S3FSOPTS='nomultipart,use\_path\_request\_style'*

*docker plugin enable s3fs*

<b>4.Create volume b2a leha</b>

*docker volume create -d s3fs todomongo1*

<b>5.ha run b2a </b>

*docker run -it -v mybucket:/mnt alpine*



<b>Bs  tare2et S3FS mashta8aletsh SEARCH WHY</b>

------------------------------

###### **NFS**


1) Open a VM have ubuntu like previous 


2) do the steps inside the link in the documentation (steps of nfs)

TAKE CARE FROM firewall \& NFS conf file try to edit them carefully 



3)open another VM w 3leha docker w hn3ml 3leha el command ely fel slides

Da el IP bta3 ubuntu el awl ely 3mlt 3leh nfs

*docker volume create --driver local --opt type=nfs --opt o=addr=192.168.1.225,rw --opt device=:/docker mongo-nfs*



4\) make a contianer using it 

*docker run -d -v mongo-nfs:/test --network todo --name mongo mongo:latest*



*-------------------------------------------------------------------*

###### **Docker Compose:(Badeel lel docker run)**

**Written in YAML:**

**Key: value**

**key:**

   **key: value**

**eg:------------------
services:**

  **mongodb:**

    **image: "mongo:latest"**

    **volumes:**

      **- mongodbvol:/data/db**



**volumes:**

  **mongodbvol:**

**---------------------**

*docker compose up # hy3mle el container w lw 3mlt -d hyeb2a fel background*

*docker compose down #hyshel el container ely et3ml* 



Docker compose bye3ml l nafso network brdo 

mmken b2a gwa el yaml file a7ot el image bta3y ely gbto mn build el Dockerfile

aw mmken a3ml build lel dockerfile asln w b3d kda ystkhdmo w y3ml run



bs lazm el docker compose file ykon f nafs mkan el Dockerfile



env file da mmken a7oto fel docker compose w el file da beykon feh list mn el environmentvariables



mmken brdo adelo comman yt3mlo run w2t run el container shbh m kont b3ml f docker run 

**-----------------------------------------------------**

**NOTE: Train on how to write clean Dockerfiles** 

**-----------------------------------------------------**

##### **Automated Image:**

Docker msh byostakhdm fel production khales Kubernetes hwa ely byostakhdm 

bs docker mmken yostakhdm w2t el CI w fel dev aw el test environment bs 



CNCF feha el opensource tools mwgoda f dol 7adedo 7ga kda 



OCI open container images 

han 7aded eh el shakl el sabet bta3 el container we image wel registrys

y3ne 3mlo standards 34an m7dsh yekhtlf 3nha w nestakhdmha f kaza application



docker b2a mamashash 3la elstandards de f bnlga2 le 

containerd w da leh engine mokhtlf (SEARCH FOR IT) w da ely mabne 3leh kubernetes 



docker yoskoto la y2om 7aten fel code bt3ha containerd w ba2o sh8alen beh 

mn el akher docker engine ana badelo command cli w hwa beyro7 ykalm containerd w y3mlo el container



---------------------------------------------------------------------

LAB #3



PART - 1

hn3ml hna registry 3ady w hnrf3 3leh shwyet images 

• Run an insecure docker registry on your server, follow the docs for this 

&nbsp; https://docs.docker.com/registry/insecure/

• Create an image that installs and run nginx based on alpine:latest

• Push this created image to the private registry that you created in step 1



PART – 2



Create a docker compose file that runs a WordPress image based on wordpress:latest image and mysql:5.7 database and mount data directory of MySQL to /var/lib/mysql on host

The docker‑compose file should have the two services and expose WordPress on port 8080 on the host



10 points



PART – 3 – BONUS – 10 points

hna h3ml nginx 3la container tany w ysh8le el webapp

In Lab2 you created a Docker image for running an example Flask app, push this image to the private registry that you created in Part 1

Create and run a docker compose file that runs this image and run it so that it will pull the image from the private registry

Make sure that this container is exported on port 8080 on the host and make sure that you can access the app

Run nginx in front of the flask app and publish it on port 80 and add it to the docker compose file (you can use httpd)



--------------------------------------------------------

For more labs you can open docker101tutorials->Guide->Labs of devops and administration



(Search about Docker Secrets) w de 34an akhazen feha el username aw passwords w kda 



