## Assignment Completed!

## Demo-URL: https://tummoc.vinays.me

#### 🧱 Tech Stack  ( Check files in Repo)
Backend: Django (Python)  
CI/CD: Jenkins (No Gitlab because it takes 8GB+ RAM)  
Containerization: Docker & Docker Compose  (kubernetes is not in assignment)    
IaC: Terraform => 2 ec2 instannce + VPC (Note: Free tier Account and instance configuration is for real porjects) 
Webserver: Nginx + gunicorn   
Monitoring: Prometheus + Grafana  + Node Exporter  

<img width="997" height="935" alt="image" src="https://github.com/user-attachments/assets/b2a929fe-9d03-4dbe-b6e2-5dfda3ce163f" />


#### Backend: Django (Python)    
* Open source Udemy clone project  
* with sqlsite for data store  
* gunicorn and whitenoise for app and static file serving  

#### CI/CD: Jenkins (No Gitlab because takes 8GB+ RAM)  
* Jenkins run as docker container (not on host) with 4GB and 2 core (free tier)
* [View Jenkinsfile] (https://github.com/vinayhpl/django-udemy-clone/blob/master/Jenkinsfile))   

<img width="1501" height="545" alt="image" src="https://github.com/user-attachments/assets/4a410c69-5421-4594-9fb5-024fc5d97ebf" />


#### Containerization: Docker & Docker Compose  (kubernetes is not in assignment)   

[View Dockerfile] (https://github.com/vinayhpl/django-udemy-clone/blob/master/Dockerfile))  
[View docker compose] (https://github.com/vinayhpl/django-udemy-clone/blob/master/docker-compose.yml))  


#### IaC: Terraform =>  (Note: Free tier Account and instance configuration is not intended for real porjects)  

2 ec2 instannce + VPC   
Note: Free tier Account and instance configuration is for real porjects
Udemy clone app: t3.micro ( 2 cpu + 1GB RAM + 8GB volume)   
Jenkins server: c7i-flex.large ( 2 CPU + 4GB RAM + 12GB volume)

##### Webserver: Nginx + gunicorn

Nginx to server domain tummoc.vinays.me  and reverse proxied to udemy app cont  
gunicorn to server static along with whitenoise dependency and udemy clone django app   


##### Monitoring: Prometheus + Grafana  + Node Exporter  

Simple also good Moniter for udemy django and node cpu and RAM refer below screenshot

<img width="1544" height="955" alt="image" src="https://github.com/user-attachments/assets/352c38db-cde7-4f2f-8517-8d0ac402806d" />



<img width="1491" height="924" alt="image" src="https://github.com/user-attachments/assets/bca50a1e-e6d2-4aed-afd2-996bdb0d1f7c" />


## 📋 Part 2: Self-Assessment

| Tool / Area | Rating (1–5) | Comments / Example Projects |
|-------------|-------------|-----------------------------|
| CI/CD (GitHub Actions, Jenkins) | ⭐⭐⭐⭐⭐ (5/5) | Good at Jenkins and Gitlab (Self hosted Gitlab for 1 project ) |
| Docker | ⭐⭐⭐⭐⭐ (5/5) | Containerized Django python app and react and next js also have knowledge on JAVA and maven <br><br> Project: Deployed NN doctor profile Nextjs and django app [NN doctors](https://doctors.narayananethralaya.org/doctors-nn1-rajaji-nagar) |
| Kubernetes | ⭐⭐⭐⭐☆ (4/5) | Deployed 2 projects with K3s, Kubeadm, EKS(due to cost reverted back to k3s) <br><br> Projects: https://sustainswitch.com/, <br><br> https://swasthya.kctest.kavinsoft.in/ |
| Terraform / Ansible | ⭐⭐⭐⭐☆ (4/5) | Will Design best suited infra for project with Terraform |
| AWS / Azure | ⭐⭐⭐⭐☆ (4/5) | Good in AWS and manageable Azure services VM Vnet blob  <br><br> planed for GCP/AZURE solution architect |
| Monitoring Tools (Prometheus, Grafana, ELK) | ⭐⭐⭐⭐☆ (4/5) | In our org Promethes and grafana is not used for monitering due to resource and cost but can setup with ease |
| Git | ⭐⭐⭐⭐⭐ (5/5) | Daily usage for version control and team collaboration |
| Built and Deployed Wordpress  projects| ⭐⭐⭐⭐⭐ (5/5) | Build websistes with WP, HTML, CSS, JS , PHP && **Deployed** Projects:<br><br> https://www.narayananethralaya.org/ ,<br><br> https://kavintechcorp.in/mouna_wp/blogs (Shop and Blogs) ,<br><br> https://paakashala.com/ <br><br>( hero banner text changed by other company) rest all same <br><br> (Only Donate and Razorpay form site was pre built) Bits pilani alumni donate form with razorpay SDK, JS , PHP <br><br> https://atmanirbhar.org/index.php/indian-online-pay/#form |





