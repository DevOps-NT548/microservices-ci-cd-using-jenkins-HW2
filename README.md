<p align="center">
  <a href="https://www.uit.edu.vn/" title="Trường Đại học Công nghệ Thông tin" style="border: 5;">
    <img src="https://i.imgur.com/WmMnSRt.png" alt="Trường Đại học Công nghệ Thông tin | University of Information Technology">
  </a>
</p>

<!-- Title -->
<h1 align="center"><b>NT548.P11 - Công nghệ DevOps và ứng dụng</b></h1>

## BẢNG MỤC LỤC

- [ Giới thiệu môn học](#gioithieumonhoc)
- [ Giảng viên hướng dẫn](#giangvien)
- [ Thành viên nhóm](#thanhvien)
- [ Hướng dẫn chạy ](#huongdan)

## GIỚI THIỆU MÔN HỌC

<a name="gioithieumonhoc"></a>

- **Tên môn học**: Công nghệ DevOps và ứng dụng
- **Mã môn học**: NT548.P11
- **Năm học**: 2024-2025

## GIẢNG VIÊN HƯỚNG DẪN

<a name="giangvien"></a> 

- Ths **Lê Thanh Tuấn**

## THÀNH VIÊN NHÓM

<a name="thanhvien"></a>
| STT | MSSV | Họ và Tên | Github | Email |
| ------ |:-------------:| ----------------------:|-----------------------------------------------------:|-------------------------:
| 1 | 22520914 | Nguyễn Hải Nam |[NamSee04](https://github.com/NamSee04) |22520914@gm.uit.edu.vn |
| 2 | 22520673 | Lê Hữu Khoa |[kevdn](https://github.com/kevdn) |22520673@gm.uit.edu.vn |
| 3 | 22520864 | Làu Trường Minh |[LiuChangMinh88](https://github.com/LiuChangMing88) |22520864@gm.uit.edu.vn |

## HƯỚNG DẪN CHẠY

<a name="huongdan"></a>
#### Khởi động github repo:
- Để kiểm tra quá trình deployment, nhóm em sẽ sử dụng 1 web template có sẵn từ https://www.free-css.com/.
- Sau khi tải 1 web template về, ta upload template đó lên github và sử dụng link github đó để tích hợp CI/CD.

#### Set up EC2 trên server AWS:
- Ta tạo 2 EC2 instances (cấu hình là ubuntu và t2.small) đồng thời tạo 1 key-pair (như hình) sử dụng cho 2 instances này:
![Key pair](screenshots/keypair.jpg)
- Sau khi tạo xong keypair, ta sử dụng keypair đó để tạo 2 EC2 instances (1 cái dùng cho Jenkins, 1 cái dùng cho SonarQube):
![EC2 Instances Creation](screenshots/EC2InstancesCreation.jpg)
- Giả sử key-pair được tải về thư mục download gốc (~/Downloads), ta chạy 2 câu lệnh sau để cấp quyền cho key-pair (key-pair có tên là Group20):

```
cd ~/Downloads
chmod 400 Group20.pem
```

- Đồng thời, đổi tên 2 EC2 instances để dễ phân biệt

#### Cài đặt Jenkins bên trong EC2 và setup webhook cơ bản:
- Ta SSH vào trong Jenkins bằng lệnh:

```
ssh -i Group20.pem ubuntu@<JenkinsEC2-publicIP>
```

- Sau đó, thực hiện các câu lệnh sau để tải jenkins:

```
sudo apt update
sudo apt -y install openjdk-17-jdk
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
```
- Thêm inbound rule để cho phép port 8080 của jenkins có thể được truy cập từ mọi IP:
![jenkins Inbound Rule](screenshots/jenkinsInboundRule.jpg)
- Truy cập vào jenkins bằng browser: <JenkinsEC2-publicIP>:8080
- Lấy Initial password bằng lệnh:
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
- Đăng nhập vào jenkins bằng mật khẩu có được bằng câu lệnh trên.
- Chọn install suggested plugins:
![jenkins Plugins](screenshots/jenkinsPlugins.jpg)
- Tạo tài khoản admin đầu tiên:
![jenkins Create User](screenshots/jenkinsCreateUser.jpg)
- Sau khi tạo xong tài khoản, ta sẽ được đưa đến trang chủ của jenkins. Chọn new items, tạo 1 Freestyle Project:
![jenkins Pipeline Creation](screenshots/jenkinsPipelineCreation.jpg)
- Sau khi tạo xong project, ta định dạng các cấu hình như ảnh (Repository URL là đường dẫn tới repo của mình, branch specifier là branch mà jenkins pipeline sẽ chạy trên.):
![jenkins Sonar Pipeline Configuration](screenshots/jenkinsSonarPipelineConfiguration.jpg)
- Chuyển đến github repository của mình, ta tạo 1 webhook với các lựa chọn như sau (Payload URL là “https://<JenkinsEC2-publicIP>:8080/github-webhook/”, events ta chọn Let me select individual events và tích vào pull requests và pushes):
![webhook URL](screenshots/webhookURL.jpg)
![webhook Actions](screenshots/webhookActions.jpg)