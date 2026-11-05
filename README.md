# kodisei-E1-1

## 1. 프로젝트 개요

이 저장소는 Docker를 이용해 정적 웹 페이지를 컨테이너로 실행하는 실습 프로젝트이다.

`nginx:alpine` 이미지를 기반으로 Docker 이미지를 만들고, `site/` 폴더 안의 `index.html` 파일을 컨테이너 내부의 Nginx 기본 웹 문서 경로로 복사하여 웹 페이지를 서비스한다.

이 프로젝트를 통해 다음 내용을 학습했다.

- Dockerfile 작성
- Docker 이미지 빌드
- Docker 컨테이너 실행
- 포트 매핑
- 웹 서버 응답 확인
- GitHub 원격 저장소 연결 확인
- Docker 명령어 오류 해결

---

## 2. 저장소 정보

GitHub 원격 저장소 주소는 다음과 같다.

```text
https://github.com/kodisei889-dev/kodisei-E1-1.git
```

원격 저장소 연결 확인 결과는 다음과 같다.

```text
origin  https://github.com/kodisei889-dev/kodisei-E1-1.git (fetch)
origin  https://github.com/kodisei889-dev/kodisei-E1-1.git (push)
```

이를 통해 로컬 저장소가 GitHub 원격 저장소와 정상적으로 연결되어 있음을 확인했다.

---

## 3. 개발 및 실행 환경

Docker 버전 확인 결과는 다음과 같다.

```text
Docker version 29.9.2, build a82e528
```

Docker 정보 확인 결과 Docker Desktop 환경에서 실행 중임을 확인했다.

```text
Client:
 Version:    29.9.2
 Context:    desktop-linux
 Debug Mode: false
```

```text
Server:
 Containers: 4
  Running: 1
  Paused: 0
  Stopped: 3
 Images: 4
 Server Version: 29.9.2
 Operating System: Docker Desktop
 OSType: linux
 Architecture: x86_64
 CPUs: 24
 Total Memory: 15.25GiB
```

실행 환경을 정리하면 다음과 같다.

```text
Docker Desktop 기반 Linux 컨테이너 환경에서 실습을 진행했다.
```

---

## 4. 프로젝트 디렉터리 구조

`tree /F` 명령어 실행 결과는 다음과 같다.

```text
D:\kodisei-E1-1>tree /F
폴더 PATH의 목록입니다.
볼륨 일련 번호는 08C4-5815입니다.
D:.
│  Dockerfile
│  localhost 스크린샷.png
│  permission_test.txt
│  README.md
│  
├─evidence
├─permission_dir_test
└─site
        index.html
```

프로젝트 구조를 정리하면 다음과 같다.

```text
kodisei-E1-1/
├─ Dockerfile
├─ localhost 스크린샷.png
├─ permission_test.txt
├─ README.md
├─ evidence/
├─ permission_dir_test/
└─ site/
   └─ index.html
```

각 파일과 폴더의 역할은 다음과 같다.

```text
Dockerfile
- Docker 이미지를 만들기 위한 설정 파일

site/index.html
- Nginx 웹 서버가 제공할 정적 HTML 파일

localhost 스크린샷.png
- localhost 접속 결과를 캡처한 이미지 파일

permission_test.txt
- 권한 관련 실습에 사용한 테스트 파일

permission_dir_test/
- 권한 관련 실습에 사용한 테스트 디렉터리

evidence/
- 실습 결과나 증빙 자료를 저장하기 위한 폴더
```

---

## 5. Dockerfile 내용

실제 작성한 `Dockerfile` 내용은 다음과 같다.

```dockerfile
FROM nginx:alpine

COPY site/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

각 명령어의 의미는 다음과 같다.

```text
FROM nginx:alpine
- nginx:alpine 이미지를 기반 이미지로 사용한다.
- Nginx가 설치된 가벼운 Alpine 기반 이미지를 사용한다.

COPY site/ /usr/share/nginx/html/
- 로컬의 site/ 폴더 내용을 컨테이너 내부의 /usr/share/nginx/html/ 경로로 복사한다.
- 이 경로는 Nginx의 기본 웹 문서 경로이다.

EXPOSE 80
- 컨테이너 내부에서 80번 포트를 사용한다는 것을 나타낸다.
- 실제 외부 접속은 docker run 명령의 -p 옵션으로 연결한다.

CMD ["nginx", "-g", "daemon off;"]
- 컨테이너가 시작될 때 Nginx를 실행한다.
- daemon off 옵션을 사용하여 Nginx가 포그라운드에서 실행되도록 한다.
- 이를 통해 컨테이너가 바로 종료되지 않고 계속 실행된다.
```

---

## 6. 이미지 빌드

Docker 이미지를 빌드하기 위해 다음 명령어를 사용했다.

```bash
docker build -t my-workstation .
```

빌드 결과는 다음과 같다.

```text
[+] Building 1.9s (7/7) FINISHED                   docker:desktop-linux
 => [internal] load build definition from Dockerfile               0.0s
 => => transferring dockerfile: 142B                               0.0s
 => [internal] load metadata for docker.io/library/nginx:alpine    1.7s
 => [internal] load .dockerignore                                  0.0s
 => => transferring context: 2B                                    0.0s
 => [internal] load build context                                  0.0s
 => => transferring context: 61B                                   0.0s
 => [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db  0.0s
 => => resolve docker.io/library/nginx:alpine@sha256:785835ea65db  0.0s
 => CACHED [2/2] COPY site/ /usr/share/nginx/html/                 0.0s
 => exporting to image                                             0.1s
 => => exporting layers                                            0.0s
 => => exporting manifest sha256:3e0d3c35329b9920e89c014304a6ed96  0.0s
 => => exporting config sha256:e3318200ee665de05cac9b41c62cf6ecab  0.0s
 => => exporting attestation manifest sha256:a471b624dbcc4c187d1a  0.0s
 => => exporting manifest list sha256:5f43a69f849847a69a628c594be  0.0s
 => => naming to docker.io/library/my-workstation:latest           0.0s
 => => unpacking to docker.io/library/my-workstation:latest        0.0s
```

빌드 결과 해석은 다음과 같다.

```text
- Dockerfile을 정상적으로 읽었다.
- nginx:alpine 이미지를 기반 이미지로 사용했다.
- site/ 폴더가 컨테이너 내부의 /usr/share/nginx/html/ 경로로 복사되었다.
- 최종적으로 my-workstation:latest 이미지가 생성되었다.
```

---

## 7. 생성된 Docker 이미지

빌드 결과 생성된 이미지 이름은 다음과 같다.

```text
my-workstation:latest
```

이미지 이름의 의미는 다음과 같다.

```text
my-workstation
- docker build 명령어에서 -t 옵션으로 지정한 이미지 이름이다.

latest
- 태그를 따로 지정하지 않았을 때 기본으로 붙는 태그이다.
```

사용한 빌드 명령어는 다음과 같다.

```bash
docker build -t my-workstation .
```

---

## 8. 컨테이너 실행

생성한 이미지를 이용해 컨테이너를 실행하는 명령어는 다음과 같다.

```bash
docker run -d --name my-workstation-container -p 8080:80 my-workstation
```

명령어 옵션의 의미는 다음과 같다.

```text
-d
- 컨테이너를 백그라운드에서 실행한다.

--name my-workstation-container
- 컨테이너 이름을 my-workstation-container로 지정한다.

-p 8080:80
- 호스트 PC의 8080번 포트를 컨테이너 내부의 80번 포트와 연결한다.

my-workstation
- 실행할 Docker 이미지 이름이다.
```

기존에 같은 이름의 컨테이너가 있을 경우 다음 명령어로 삭제 후 다시 실행할 수 있다.

```bash
docker rm -f my-workstation-container
docker run -d --name my-workstation-container -p 8080:80 my-workstation
```

---

## 9. 컨테이너 실행 상태 확인

컨테이너 실행 상태는 다음 명령어로 확인할 수 있다.

```bash
docker ps
```

`docker ps` 명령어는 현재 실행 중인 컨테이너 목록을 보여준다.

확인해야 할 주요 항목은 다음과 같다.

```text
CONTAINER ID
- 컨테이너의 고유 ID이다.

IMAGE
- 컨테이너가 어떤 이미지로 실행되었는지 보여준다.

COMMAND
- 컨테이너에서 실행 중인 명령을 보여준다.

STATUS
- 컨테이너가 실행 중인지 상태를 보여준다.

PORTS
- 호스트와 컨테이너 포트가 어떻게 연결되어 있는지 보여준다.

NAMES
- 컨테이너 이름을 보여준다.
```

이 프로젝트에서는 다음과 같은 상태를 기대할 수 있다.

```text
IMAGE: my-workstation
PORTS: 0.0.0.0:8080->80/tcp
NAMES: my-workstation-container
```

---

## 10. 웹 서버 응답 확인

웹 서버가 정상적으로 실행되는지 확인하기 위해 다음 명령어를 실행했다.

```bash
curl http://localhost:8080
```

실행 결과는 다음과 같다.

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Docker Port Test</title>
</head>
<body>
  <h1>Hello from Docker</h1>
  <p>nginx container is running.</p>
</body>
</html>
```

결과 해석은 다음과 같다.

```text
- localhost:8080으로 접속했을 때 HTML 문서가 반환되었다.
- Docker 컨테이너 내부의 Nginx 웹 서버가 정상적으로 실행 중이다.
- site/index.html 파일이 정상적으로 서비스되고 있다.
```

---

## 11. 브라우저 접속 확인

브라우저에서 다음 주소로 접속하여 웹 페이지를 확인할 수 있다.

```text
http://localhost:8080
```

정상적으로 실행되면 다음 내용이 화면에 표시된다.

```text
Hello from Docker
nginx container is running.
```

프로젝트 폴더에는 브라우저 확인 결과를 저장한 파일도 포함되어 있다.

```text
localhost 스크린샷.png
```

---

## 12. 포트 매핑 설명

이 프로젝트에서는 다음과 같이 포트를 연결했다.

```text
호스트 PC 8080번 포트 -> 컨테이너 내부 80번 포트
```

Docker 실행 명령어에서는 다음 부분이 포트 매핑을 담당한다.

```bash
-p 8080:80
```

의미는 다음과 같다.

```text
8080
- 내 컴퓨터에서 접속할 포트이다.

80
- 컨테이너 내부에서 Nginx가 사용하는 포트이다.
```

따라서 사용자는 브라우저나 curl에서 다음 주소로 접속한다.

```text
http://localhost:8080
```

그러면 Docker가 요청을 컨테이너 내부의 80번 포트로 전달하고, Nginx가 HTML 파일을 응답한다.

---

## 13. 정적 웹 페이지 서비스 흐름

이 프로젝트의 웹 페이지 서비스 흐름은 다음과 같다.

```text
1. 로컬 프로젝트의 site/index.html 파일 작성
2. Dockerfile에서 site/ 폴더를 컨테이너 내부로 복사
3. docker build 명령어로 이미지 생성
4. docker run 명령어로 컨테이너 실행
5. 호스트 8080 포트를 컨테이너 80 포트에 연결
6. 브라우저 또는 curl로 localhost:8080 접속
7. Nginx가 index.html 파일을 응답
```

흐름을 그림처럼 정리하면 다음과 같다.

```text
site/index.html
        ↓
Dockerfile의 COPY 명령
        ↓
/usr/share/nginx/html/
        ↓
Nginx 웹 서버
        ↓
localhost:8080
```

---

## 14. 잘못 입력한 Docker 명령어와 오류

실습 중 다음 명령어를 입력했다.

```text
docker rm / docker run / docker ps
```

실행 결과 다음 오류가 발생했다.

```text
container name cannot be empty
Error response from daemon: No such container: docker
Error response from daemon: No such container: run
container name cannot be empty
Error response from daemon: No such container: docker
Error response from daemon: No such container: ps
```

오류 원인은 다음과 같다.

```text
- docker rm, docker run, docker ps는 각각 따로 실행해야 하는 명령어이다.
- / 기호로 명령어를 연결하면 안 된다.
- Docker가 docker, run, ps 같은 단어를 컨테이너 이름처럼 해석하면서 오류가 발생했다.
```

올바른 명령어 예시는 다음과 같다.

```bash
docker rm -f my-workstation-container
docker run -d --name my-workstation-container -p 8080:80 my-workstation
docker ps
```

이 오류를 통해 배운 점은 다음과 같다.

```text
- Docker 명령어는 정확한 형식으로 입력해야 한다.
- 여러 명령어는 한 줄에 / 로 연결하지 않는다.
- 오류 메시지를 확인하면 Docker가 어떤 값을 잘못 해석했는지 알 수 있다.
```

---

## 15. 컨테이너 중지 및 삭제

실행 중인 컨테이너를 중지하려면 다음 명령어를 사용할 수 있다.

```bash
docker stop my-workstation-container
```

컨테이너를 삭제하려면 다음 명령어를 사용할 수 있다.

```bash
docker rm my-workstation-container
```

중지와 삭제를 한 번에 처리하려면 다음 명령어를 사용할 수 있다.

```bash
docker rm -f my-workstation-container
```

명령어 의미는 다음과 같다.

```text
docker stop
- 실행 중인 컨테이너를 중지한다.

docker rm
- 중지된 컨테이너를 삭제한다.

docker rm -f
- 실행 중인 컨테이너도 강제로 중지하고 삭제한다.
```

---

## 16. 자주 사용하는 Docker 명령어 정리

이번 실습에서 사용한 주요 Docker 명령어는 다음과 같다.

```bash
docker --version
docker info
docker build -t my-workstation .
docker images
docker run -d --name my-workstation-container -p 8080:80 my-workstation
docker ps
docker stop my-workstation-container
docker rm my-workstation-container
docker rm -f my-workstation-container
```

각 명령어의 역할은 다음과 같다.

```text
docker --version
- Docker 버전을 확인한다.

docker info
- Docker 실행 환경 정보를 확인한다.

docker build -t my-workstation .
- 현재 폴더의 Dockerfile을 이용해 my-workstation 이미지를 빌드한다.

docker images
- 로컬에 저장된 Docker 이미지 목록을 확인한다.

docker run -d --name my-workstation-container -p 8080:80 my-workstation
- my-workstation 이미지를 이용해 컨테이너를 실행한다.

docker ps
- 실행 중인 컨테이너 목록을 확인한다.

docker stop my-workstation-container
- 실행 중인 my-workstation-container 컨테이너를 중지한다.

docker rm my-workstation-container
- 중지된 my-workstation-container 컨테이너를 삭제한다.

docker rm -f my-workstation-container
- 실행 중인 컨테이너를 강제로 중지하고 삭제한다.
```

---

## 17. Git 명령어 확인

원격 저장소 연결을 확인하기 위해 다음 명령어를 사용했다.

```bash
git remote -v
```

실행 결과는 다음과 같다.

```text
origin  https://github.com/kodisei889-dev/kodisei-E1-1.git (fetch)
origin  https://github.com/kodisei889-dev/kodisei-E1-1.git (push)
```

이 결과를 통해 다음을 확인할 수 있다.

```text
- 로컬 Git 저장소가 GitHub 원격 저장소와 연결되어 있다.
- origin이라는 이름으로 원격 저장소가 등록되어 있다.
- fetch와 push 주소가 모두 같은 GitHub 저장소를 가리킨다.
```

원격 저장소의 최신 정보를 가져오기 위해 다음 명령어도 실행했다.

```bash
git fetch origin
```

실행 결과는 다음과 같다.

```text
출력 없음
```

해석은 다음과 같다.

```text
- git fetch origin 명령 실행 후 별도 출력이 없었다.
- 출력이 없더라도 명령이 실패했다는 의미는 아니다.
- 오류 메시지가 없으면 정상적으로 실행된 것으로 볼 수 있다.
```

---

## 18. Docker 이미지 목록 확인

Docker 이미지 목록은 다음 명령어로 확인할 수 있다.

```bash
docker images
```

실습 환경에서 확인된 이미지는 다음과 같다.

```text
my-workstation
ubuntu
nginx
hello-world
```

해석은 다음과 같다.

```text
my-workstation
- 이번 실습에서 Dockerfile을 이용해 직접 빌드한 이미지이다.

ubuntu
- 로컬에 존재하는 Ubuntu 이미지이다.

nginx
- Nginx 웹 서버 이미지이다.

hello-world
- Docker 설치 및 실행 확인에 자주 사용하는 테스트 이미지이다.
```

이번 프로젝트에서 실제로 사용한 이미지는 다음과 같다.

```text
my-workstation
nginx:alpine
```

---

## 19. 전체 실행 순서

이 프로젝트를 다시 실행하려면 다음 순서대로 진행하면 된다.

```bash
docker build -t my-workstation .
docker rm -f my-workstation-container
docker run -d --name my-workstation-container -p 8080:80 my-workstation
docker ps
curl http://localhost:8080
```

각 단계의 의미는 다음과 같다.

```text
1. docker build -t my-workstation .
   - Dockerfile을 이용해 my-workstation 이미지를 빌드한다.

2. docker rm -f my-workstation-container
   - 같은 이름의 기존 컨테이너가 있으면 삭제한다.

3. docker run -d --name my-workstation-container -p 8080:80 my-workstation
   - my-workstation 이미지로 컨테이너를 실행한다.

4. docker ps
   - 컨테이너가 실행 중인지 확인한다.

5. curl http://localhost:8080
   - 웹 서버가 HTML을 정상적으로 응답하는지 확인한다.
```

---

## 20. 실행 결과 요약

이번 실습에서 확인한 결과는 다음과 같다.

```text
Docker 설치 확인
- Docker version 29.9.2, build a82e528

Docker 실행 환경 확인
- Docker Desktop 기반 Linux 컨테이너 환경 확인

Dockerfile 작성 확인
- nginx:alpine 기반
- site/ 폴더를 /usr/share/nginx/html/ 경로로 복사
- 80번 포트 사용
- Nginx 포그라운드 실행

이미지 빌드 확인
- docker build -t my-workstation . 실행 성공
- my-workstation:latest 이미지 생성

컨테이너 실행 확인
- my-workstation 이미지 기반 컨테이너 실행
- 호스트 8080 포트와 컨테이너 80 포트 연결

웹 서버 응답 확인
- curl http://localhost:8080 실행 성공
- HTML 응답 확인

Git 원격 저장소 확인
- origin 원격 저장소가 GitHub 주소로 연결됨
```

---

## 21. 핵심 개념 정리

이번 실습의 핵심 개념은 다음과 같다.

```text
Dockerfile
- Docker 이미지를 만들기 위한 설정 파일이다.

Docker image
- 컨테이너 실행에 필요한 파일과 설정을 포함한 실행 템플릿이다.

Docker container
- 이미지를 바탕으로 실제 실행되는 환경이다.

Nginx
- 정적 웹 페이지를 제공할 수 있는 웹 서버이다.

Port mapping
- 호스트 PC의 포트와 컨테이너 내부 포트를 연결하는 기능이다.

curl
- 터미널에서 웹 요청을 보내고 응답을 확인할 수 있는 명령어이다.

Git remote
- 로컬 저장소와 연결된 원격 저장소 정보를 의미한다.
```

---

## 22. 배운 점

이번 실습을 통해 Docker의 기본 흐름을 직접 경험할 수 있었다.

```text
첫째, Dockerfile을 작성하면 같은 실행 환경을 반복해서 만들 수 있다는 점을 배웠다.

둘째, nginx:alpine 이미지를 이용하면 간단한 정적 웹 서버를 빠르게 구성할 수 있다는 점을 확인했다.

셋째, docker build 명령어로 이미지를 만들고 docker run 명령어로 컨테이너를 실행하는 흐름을 이해했다.

넷째, -p 8080:80 옵션을 통해 내 컴퓨터의 8080번 포트와 컨테이너 내부의 80번 포트를 연결하는 방법을 익혔다.

다섯째, curl http://localhost:8080 명령어를 사용하여 웹 서버가 정상적으로 응답하는지 확인했다.

여섯째, Docker 명령어를 잘못 입력했을 때 오류 메시지를 보고 원인을 파악하는 연습을 했다.

일곱째, git remote -v 명령어를 통해 로컬 저장소와 GitHub 원격 저장소의 연결 상태를 확인했다.
```

---

## 23. 오류 해결 경험

실습 중 잘못된 명령어 입력으로 오류가 발생했다.

잘못 입력한 예시는 다음과 같다.

```text
docker rm / docker run / docker ps
```

이 입력은 여러 Docker 명령어를 한 줄에 잘못 연결한 형태이다.

Docker는 `/`, `docker`, `run`, `ps` 등을 올바른 명령 구분자로 이해하지 못하고, 컨테이너 이름처럼 해석했다.

그 결과 다음과 같은 오류가 발생했다.

```text
container name cannot be empty
Error response from daemon: No such container: docker
Error response from daemon: No such container: run
Error response from daemon: No such container: ps
```

올바른 방식은 다음처럼 명령어를 각각 분리해서 실행하는 것이다.

```bash
docker rm -f my-workstation-container
docker run -d --name my-workstation-container -p 8080:80 my-workstation
docker ps
```

이 경험을 통해 다음을 알게 되었다.

```text
- Docker 명령어는 정확한 형식으로 입력해야 한다.
- 여러 명령어를 실행할 때는 한 줄에 무리하게 연결하지 않고 각각 실행하는 것이 안전하다.
- 오류 메시지는 문제 해결의 중요한 단서가 된다.
```

---

## 24. 최종 확인 결과

최종적으로 다음 항목을 모두 확인했다.

```text
[확인 완료] Docker 버전 확인
[확인 완료] Docker 실행 환경 확인
[확인 완료] 프로젝트 구조 확인
[확인 완료] Dockerfile 내용 확인
[확인 완료] Docker 이미지 빌드 성공
[확인 완료] my-workstation 이미지 생성
[확인 완료] 컨테이너 실행 명령 정리
[확인 완료] 포트 매핑 설정 확인
[확인 완료] curl을 통한 웹 서버 응답 확인
[확인 완료] 브라우저 접속 결과 파일 확인
[확인 완료] GitHub 원격 저장소 연결 확인
[확인 완료] git fetch origin 실행 확인
[확인 완료] Docker 명령어 오류 원인 분석
[확인 완료] 올바른 Docker 명령어 정리
[확인 완료] 전체 재실행 절차 정리
```

---

## 25. 결론

이 프로젝트는 Docker를 이용해 정적 웹 페이지를 컨테이너 환경에서 실행하는 실습이다.

최종적으로 다음 흐름이 정상적으로 동작함을 확인했다.

```text
Dockerfile 작성
→ Docker 이미지 빌드
→ 컨테이너 실행
→ 포트 매핑
→ localhost:8080 접속
→ Nginx HTML 응답 확인
```

따라서 이 프로젝트는 Docker 기반 정적 웹 서버 실행 실습 요구사항을 충족한다.

이번 실습을 통해 Docker의 기본 사용 흐름과 GitHub 저장소 연결 확인 방법을 익힐 수 있었다.