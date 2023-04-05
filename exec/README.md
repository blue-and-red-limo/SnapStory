## 개발 환경

- 형상 관리 : GitLab
- 이슈 관리 : Jira
- Communication :
    - Mattermost
    - Webex
    - Notion
- API 문서화
    - Swagger UI
- OS : Windows 10
- UI/UX : Figma
- IDE :
    - Visual Studio Code 1.75
    - Android Studio 2022.1.1
    - Intellij IDEA 2022.3.1
- DB : MySQL 8.0.30
- Server : AWS EC2
    - Ubuntu 20.04 LTS
    - Docker 23.0.1
    - Docker Compose 2.15.1
    - Jenkins 2.387.1
- WAS : Apache Tomcat 9.0.71
- Web Server : NGINX 1.22.1
- AI
    - Python 3.9
    - FastAPI 0.95.0
- FE
    - Dart 3.0.0
    - Flutter 3.7.5
- BE
    - OpenJDK 11
    - Spring Boot Gradle(Kotlin) 2.7.9
        - Spring Data JPA
        - Spring Security
        - Lombok

## EC2

1. Docker 23.0.1 설치
2. Docker Compose 2.15.1 설치
3. git clone
    
    ```bash
    git clone https://lab.ssafy.com/s08-ai-image-sub2/S08P22A401.git
    ```
    
4. /S08P22A401/backend/default.conf → 도메인 수정
5. docker-compose up
    
    ```bash
    sudo docker compose up -d --build
    ```
    
## Properties

1. Firebase to Flutter Project -> Firebase Console
2. OpenAI Key to Flutter Project -> /lib/constants/api_key.dart ( apiKey )
3. S3 to Spring Boot Project -> application.yaml

## 외부 서비스 문서

### AWS S3

[클라우드 스토리지 | 웹 스토리지| Amazon Web Services](https://aws.amazon.com/ko/s3/?did=ap_card&trk=ap_card)

## DB dump
[DB dump](./20230405.sql)
