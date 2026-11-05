# Docker/Git 개발 환경 실습 보고서

## 1. 실습 개요

이번 실습에서는 GitHub 저장소를 사용하여 프로젝트를 관리하고, Docker를 이용해 컨테이너 실행, 이미지 빌드, 포트 매핑, 바인드 마운트, Docker 볼륨, Linux 권한 변경, 트러블슈팅을 실습했다.

주요 실습 내용은 다음과 같다.

- Git 저장소 설정 및 원격 저장소 연결 확인
- Docker 설치 상태 및 데몬 상태 확인
- Dockerfile 작성 및 이미지 빌드
- Docker 컨테이너 실행
- `hello-world` 컨테이너 실행 확인
- nginx 웹 서버 실행 및 포트 매핑 확인
- 파일 생성, 이동, 삭제, 출력 확인
- Linux 컨테이너 내부에서 파일/디렉터리 권한 변경
- Docker 볼륨을 이용한 데이터 영속성 확인
- 바인드 마운트를 이용한 호스트-컨테이너 파일 공유 확인
- 이미지와 컨테이너의 차이 이해
- 네트워크 네임스페이스와 포트 포워딩 이해
- 포트 충돌, 명령어 차이 등 트러블슈팅 정리

---

## 2. 실습 환경

| 항목 | 내용 |
|---|---|
| 운영체제 | Windows |
| 터미널 | PowerShell |
| Docker 환경 | Docker Desktop |
| Git 저장소 | GitHub |
| 작업 디렉터리 | `D:\kodisei-E1-1` |
| 원격 저장소 | `https://github.com/kodisei889-dev/kodisei-E1-1.git` |
| 웹 서버 테스트 이미지 | `nginx:alpine` |
| Linux 권한 테스트 이미지 | `ubuntu:22.04` |

---

## 3. 프로젝트 구조

프로젝트 구조는 다음과 같다.

```text
D:\kodisei-E1-1
├─ README.md
├─ Dockerfile
├─ site
│  └─ index.html
├─ permission_test.txt
└─ permission_dir_test
```

각 파일과 폴더의 역할은 다음과 같다.

| 경로 | 역할 |
|---|---|
| `README.md` | 실습 과정, 명령어, 실행 결과, 트러블슈팅 기록 |
| `Dockerfile` | Docker 이미지 빌드 설정 파일 |
| `site/` | nginx 웹 서버에서 제공할 HTML 파일 저장 |
| `site/index.html` | 웹 서버 접속 시 표시할 HTML 파일 |
| `permission_test.txt` | 파일 권한 변경 실습용 파일 |
| `permission_dir_test/` | 디렉터리 권한 변경 실습용 폴더 |

### 디렉터리 설계 기준

프로젝트 루트에는 Docker 실행과 문서화에 필요한 핵심 파일을 배치했다.  
웹 서버에서 제공할 정적 파일은 `site/` 폴더에 분리하여 관리했고, 권한 실습용 파일과 폴더는 별도로 두어 역할을 구분했다.

---

## 4. 파일 생성, 이동, 삭제, 출력 확인

실습에 필요한 폴더와 파일을 생성했다.

```powershell
mkdir site
mkdir permission_dir_test
echo "<h1>Hello from Docker</h1>" > site/index.html
echo "permission test" > permission_test.txt
echo "temporary file" > temp.txt
```

생성된 파일과 폴더를 확인했다.

```powershell
dir
```

출력 일부:

```text
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----                                      site
d-----                                      permission_dir_test
-a----                                      Dockerfile
-a----                                      README.md
-a----                                      permission_test.txt
-a----                                      temp.txt
```

파일 내용을 출력했다.

```powershell
cat site/index.html
```

출력:

```html
<h1>Hello from Docker</h1>
```

파일 이동을 확인했다.

```powershell
Move-Item temp.txt site/temp.txt
dir site
```

출력 일부:

```text
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----                                      index.html
-a----                                      temp.txt
```

이후 테스트 파일을 삭제했다.

```powershell
Remove-Item site/temp.txt
dir site
```

출력 일부:

```text
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----                                      index.html
```

이를 통해 파일 생성, 이동, 삭제, 출력 과정을 확인했다.

---

## 5. Git 설정 및 원격 저장소 확인

Git 사용자 설정을 확인했다.

```powershell
git config user.name
```

출력:

```text
kodisei889-dev
```

이메일 설정도 확인했다.

```powershell
git config user.email
```

출력:

```text
개인 이메일이므로 README에서는 마스킹 처리함
```

전체 Git 설정 중 주요 항목을 확인했다.

```powershell
git config --list
```

출력 일부:

```text
core.autocrlf=true
core.filemode=false
remote.origin.url=https://github.com/kodisei889-dev/kodisei-E1-1.git
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
branch.main.remote=origin
branch.main.merge=refs/heads/main
```

원격 저장소 연결 상태를 확인했다.

```powershell
git remote -v
```

출력:

```text
origin  https://github.com/kodisei889-dev/kodisei-E1-1.git (fetch)
origin  https://github.com/kodisei889-dev/kodisei-E1-1.git (push)
```

원격 저장소와 통신 가능한지도 확인했다.

```powershell
git fetch origin
```

출력 예시:

```text
From https://github.com/kodisei889-dev/kodisei-E1-1
 * branch            main       -> FETCH_HEAD
```

또는 변경 사항을 원격 저장소에 업로드했다.

```powershell
git push origin main
```

출력 예시:

```text
Everything up-to-date
```

이를 통해 로컬 Git 저장소와 GitHub 원격 저장소가 정상적으로 연결되어 있음을 확인했다.

---

## 6. Docker 설치 상태 및 데몬 확인

Docker CLI 설치 여부를 확인했다.

```powershell
docker --version
```

출력:

```text
Docker version 29.9.2, build a82e528
```

Docker 데몬 상태를 확인하기 위해 `docker info`를 실행했다.

```powershell
docker info
```

출력 일부:

```text
Client:
 Version:    29.9.2

Server:
 Server Version: 29.9.2
 Containers:
 Images:
 Operating System: Docker Desktop
```

`docker info` 명령어가 정상적으로 출력되면 Docker CLI가 Docker 데몬과 통신하고 있다는 의미이다.

---

## 7. Docker 핵심 개념 정리

### 7-1. 이미지와 컨테이너의 차이

Docker 이미지는 애플리케이션 실행에 필요한 파일, 설정, 라이브러리를 포함한 실행 템플릿이다.  
컨테이너는 이미지를 바탕으로 실제 실행된 프로세스 환경이다.

쉽게 말해, 이미지는 실행 전의 설계도이고 컨테이너는 그 설계도를 실제로 실행한 작업 공간이다.

이미지는 저장된 상태이고, 컨테이너는 실행 중이거나 종료된 상태를 가질 수 있다.  
같은 이미지로 여러 개의 컨테이너를 만들 수도 있다.

### 7-2. 네트워크 네임스페이스와 포트 포워딩

Docker 컨테이너는 호스트와 분리된 네트워크 네임스페이스를 가진다.  
따라서 컨테이너 내부에서 nginx가 80번 포트로 실행되어도 호스트의 브라우저에서 바로 접근할 수 없다.

호스트에서 컨테이너 내부 서비스에 접근하려면 포트 포워딩이 필요하다.

예를 들어 다음 옵션을 사용한다.

```powershell
-p 8080:80
```

의미는 다음과 같다.

| 구분 | 의미 |
|---|---|
| `8080` | 호스트 Windows에서 접근할 포트 |
| `80` | 컨테이너 내부 nginx가 사용하는 포트 |

즉, 사용자가 `http://localhost:8080`으로 접속하면 Docker가 이 요청을 컨테이너 내부의 80번 포트로 전달한다.

---

## 8. Dockerfile 작성

nginx 기반 웹 서버 이미지를 만들기 위해 `Dockerfile`을 작성했다.

```dockerfile
FROM nginx:alpine

COPY site/ /usr/share/nginx/html/

EXPOSE 80
```

각 명령의 의미는 다음과 같다.

| 명령어 | 의미 |
|---|---|
| `FROM nginx:alpine` | 가벼운 nginx 이미지를 기반 이미지로 사용 |
| `COPY site/ /usr/share/nginx/html/` | 호스트의 `site` 폴더 내용을 nginx 웹 루트로 복사 |
| `EXPOSE 80` | 컨테이너 내부에서 80번 포트를 사용함을 명시 |

---

## 9. Docker 이미지 빌드

작성한 Dockerfile을 사용해 이미지를 빌드했다.

```powershell
docker build -t my-workstation .
```

빌드 로그 일부:

```text
[+] Building
 => [internal] load build definition from Dockerfile
 => [internal] load metadata for docker.io/library/nginx:alpine
 => [1/2] FROM docker.io/library/nginx:alpine
 => CACHED [2/2] COPY site/ /usr/share/nginx/html/
 => exporting to image
 => naming to docker.io/library/my-workstation
```

`COPY site/ /usr/share/nginx/html/` 단계가 실행되어 `site/index.html` 파일이 이미지 안의 nginx 웹 루트로 복사되었음을 확인했다.

---

## 10. Docker 이미지 목록 확인

로컬에 생성된 Docker 이미지 목록을 확인했다.

```powershell
docker images
```

출력 일부:

```text
REPOSITORY       TAG       IMAGE ID       CREATED        SIZE
my-workstation   latest    xxxxxxxxxxxx   recently       xxMB
nginx            alpine    xxxxxxxxxxxx   recently       xxMB
hello-world      latest    xxxxxxxxxxxx   recently       xxkB
ubuntu           22.04     xxxxxxxxxxxx   recently       xxMB
```

`my-workstation` 이미지가 표시되므로 Dockerfile을 이용한 이미지 빌드가 성공했음을 확인할 수 있다.

---

## 11. hello-world 컨테이너 실행 확인

Docker가 정상적으로 동작하는지 확인하기 위해 `hello-world` 이미지를 실행했다.

```powershell
docker run hello-world
```

출력:

```text
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

전체 컨테이너 목록에서 `hello-world` 컨테이너가 정상 종료되었는지 확인했다.

```powershell
docker ps -a
```

출력 일부:

```text
CONTAINER ID   IMAGE          COMMAND    CREATED          STATUS                      PORTS     NAMES
a9b23f3b5508   hello-world    "/hello"   3 minutes ago    Exited (0) 3 minutes ago              vigilant_archimedes
```

`Exited (0)`은 컨테이너가 오류 없이 정상 실행 후 종료되었음을 의미한다.

---

## 12. 컨테이너 실행 및 포트 매핑 확인

빌드한 이미지를 컨테이너로 실행했다.

```powershell
docker run -d --name workstation-container -p 8080:80 my-workstation
```

옵션 의미는 다음과 같다.

| 옵션 | 의미 |
|---|---|
| `-d` | 컨테이너를 백그라운드에서 실행 |
| `--name workstation-container` | 컨테이너 이름을 `workstation-container`로 지정 |
| `-p 8080:80` | 호스트의 8080 포트를 컨테이너의 80 포트와 연결 |
| `my-workstation` | 실행할 Docker 이미지 이름 |

실행 중인 컨테이너 목록을 확인했다.

```powershell
docker ps
```

출력 예시:

```text
CONTAINER ID   IMAGE            COMMAND                  STATUS        PORTS                  NAMES
xxxxxxxxxxxx   my-workstation   "/docker-entrypoint.…"   Up            0.0.0.0:8080->80/tcp   workstation-container
```

`PORTS` 항목의 `0.0.0.0:8080->80/tcp`는 Windows 호스트의 8080 포트가 컨테이너 내부의 80 포트로 연결되었다는 의미이다.

브라우저 또는 curl 명령어로 웹 서버 응답을 확인했다.

```powershell
curl.exe http://localhost:8080
```

출력:

```html
<h1>Hello from Docker</h1>
```

이를 통해 Docker 컨테이너 내부의 nginx 웹 서버가 정상적으로 실행되고, 호스트에서 포트 매핑을 통해 접근 가능함을 확인했다.

---

## 13. 전체 컨테이너 목록 확인

실행 중인 컨테이너뿐 아니라 종료된 컨테이너까지 모두 확인했다.

```powershell
docker ps -a
```

출력 예시:

```text
CONTAINER ID   IMAGE            COMMAND                  STATUS                     PORTS                  NAMES
xxxxxxxxxxxx   my-workstation   "/docker-entrypoint.…"   Up                         0.0.0.0:8080->80/tcp   workstation-container
xxxxxxxxxxxx   hello-world      "/hello"                 Exited (0)                　　　　　　　　　　　    vigilant_archimedes
```

`docker ps`는 실행 중인 컨테이너만 보여주고, `docker ps -a`는 실행 중이거나 종료된 모든 컨테이너를 보여준다.

---

## 14. 컨테이너 로그 확인

컨테이너의 동작 상태를 확인하기 위해 로그를 확인했다.

```powershell
docker logs workstation-container
```

출력 예시:

```text
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Configuration complete; ready for start up
```

nginx 컨테이너가 정상적으로 초기화되고 실행 준비가 완료되었음을 확인할 수 있다.

---

## 15. 컨테이너 내부 접속 확인

실행 중인 컨테이너 내부에 접속했다.

```powershell
docker exec -it workstation-container sh
```

컨테이너 내부에서 현재 위치를 확인했다.

```sh
pwd
```

출력 예시:

```text
/
```

nginx 웹 루트 디렉터리로 이동했다.

```sh
cd /usr/share/nginx/html
```

파일 목록을 확인했다.

```sh
ls -l
```

출력 예시:

```text
-rw-r--r--    1 root     root            29 Nov  3 05:20 index.html
```

파일 내용을 확인했다.

```sh
cat index.html
```

출력:

```html
<h1>Hello from Docker</h1>
```

이를 통해 Dockerfile의 `COPY site/ /usr/share/nginx/html/` 명령으로 `site/index.html` 파일이 컨테이너 내부 nginx 웹 루트에 복사되었음을 확인했다.

컨테이너 내부에서 빠져나왔다.

```sh
exit
```

---

## 16. Linux 컨테이너에서 파일 권한 변경 실습

Windows PowerShell이 아니라 Linux 컨테이너 내부에서 권한 변경을 실습했다.

권한 실습을 위해 Ubuntu 컨테이너를 실행하면서 현재 프로젝트 폴더를 `/app`에 마운트했다.

```powershell
docker run -it --name permission-container -v ${PWD}:/app ubuntu:22.04 bash
```

컨테이너 내부에서 `/app`으로 이동했다.

```bash
cd /app
```

파일 목록과 권한을 확인했다.

```bash
ls -l
```

출력 예시:

```text
-rw-r--r-- 1 root root   16 Nov  3 05:20 permission_test.txt
drwxr-xr-x 1 root root 4096 Nov  3 05:25 permission_dir_test
```

`permission_test.txt` 파일 권한을 확인했다.

```bash
ls -l permission_test.txt
```

출력 예시:

```text
-rw-r--r-- 1 root root 16 Nov  3 05:20 permission_test.txt
```

파일 권한을 `644`로 변경했다.

```bash
chmod 644 permission_test.txt
ls -l permission_test.txt
```

출력 예시:

```text
-rw-r--r-- 1 root root 16 Nov  3 05:20 permission_test.txt
```

파일 권한을 `755`로 변경했다.

```bash
chmod 755 permission_test.txt
ls -l permission_test.txt
```

출력 예시:

```text
-rwxr-xr-x 1 root root 16 Nov  3 05:20 permission_test.txt
```

`755` 권한은 소유자에게 읽기, 쓰기, 실행 권한을 주고 그룹과 기타 사용자에게는 읽기와 실행 권한을 주는 설정이다.

---

## 17. Linux 컨테이너에서 디렉터리 권한 변경 실습

디렉터리 권한을 확인했다.

```bash
ls -ld permission_dir_test
```

출력 예시:

```text
drwxr-xr-x 1 root root 4096 Nov  3 05:25 permission_dir_test
```

디렉터리 권한을 `755`로 변경했다.

```bash
chmod 755 permission_dir_test
ls -ld permission_dir_test
```

출력 예시:

```text
drwxr-xr-x 1 root root 4096 Nov  3 05:25 permission_dir_test
```

디렉터리 권한을 `700`으로 변경했다.

```bash
chmod 700 permission_dir_test
ls -ld permission_dir_test
```

출력 예시:

```text
drwx------ 1 root root 4096 Nov  3 05:25 permission_dir_test
```

`700` 권한은 소유자만 읽기, 쓰기, 실행이 가능하고 그룹과 기타 사용자는 접근할 수 없는 설정이다.

실습 후 컨테이너에서 빠져나왔다.

```bash
exit
```

---

## 18. rwx 권한과 숫자 권한 정리

Linux 권한은 `r`, `w`, `x`로 표현된다.

| 문자 | 숫자 | 의미 |
|---|---:|---|
| `r` | 4 | read, 읽기 |
| `w` | 2 | write, 쓰기 |
| `x` | 1 | execute, 실행 |
| `-` | 0 | 권한 없음 |

세 권한의 합으로 숫자 권한을 만든다.

| 숫자 | 권한 | 의미 |
|---:|---|---|
| 7 | `rwx` | 읽기, 쓰기, 실행 가능 |
| 6 | `rw-` | 읽기, 쓰기 가능 |
| 5 | `r-x` | 읽기, 실행 가능 |
| 4 | `r--` | 읽기만 가능 |
| 0 | `---` | 권한 없음 |

대표적인 권한 예시는 다음과 같다.

| 숫자 권한 | 문자 권한 | 의미 |
|---|---|---|
| `644` | `-rw-r--r--` | 소유자는 읽기/쓰기, 그룹과 기타 사용자는 읽기 |
| `755` | `-rwxr-xr-x` | 소유자는 읽기/쓰기/실행, 그룹과 기타 사용자는 읽기/실행 |
| `700` | `-rwx------` | 소유자만 읽기/쓰기/실행 |

파일 권한 출력 예시:

```text
-rw-r--r--
```

해석:

```text
-  rw-  r--  r--
|   |    |    |
|   |    |    └─ 기타 사용자 권한
|   |    └────── 그룹 권한
|   └─────────── 소유자 권한
└─────────────── 일반 파일
```

디렉터리 권한 출력 예시:

```text
drwxr-xr-x
```

맨 앞의 `d`는 디렉터리를 의미한다.

---

## 19. Windows 호스트와 Linux 컨테이너 권한 차이

Windows와 Linux는 파일 권한을 관리하는 방식이 다르다.

| 구분 | Windows 호스트 | Linux 컨테이너 |
|---|---|---|
| 권한 관리 방식 | ACL, 파일 속성 | `rwx` 권한 비트 |
| 권한 확인 방식 | 파일 속성, PowerShell | `ls -l`, `ls -ld` |
| 권한 변경 방식 | 속성/보안 설정 | `chmod`, `chown` |
| 출력 예시 | 읽기 전용, 사용자 권한 | `-rw-r--r--` |

이번 실습에서는 Windows의 프로젝트 폴더를 Linux 컨테이너 내부 `/app` 경로에 마운트했다.  
그래서 Windows 파일을 컨테이너 안에서 Linux 방식의 권한 표시로 확인할 수 있었다.

다만 Windows 파일 시스템과 Linux 파일 시스템은 권한 처리 방식이 다르기 때문에, 컨테이너 내부에서 보이는 권한과 Windows에서 실제 적용되는 권한이 완전히 동일하게 동작하지 않을 수 있다.

---

## 20. Docker 볼륨 생성 및 영속성 확인

Docker 볼륨은 컨테이너가 삭제되어도 데이터를 유지하기 위해 사용한다.

볼륨을 생성했다.

```powershell
docker volume create mission-volume
```

출력:

```text
mission-volume
```

볼륨 목록을 확인했다.

```powershell
docker volume ls
```

출력 예시:

```text
DRIVER    VOLUME NAME
local     mission-volume
```

볼륨을 컨테이너의 `/data` 경로에 마운트하고 파일을 생성했다.

```powershell
docker run --name volume-test -v mission-volume:/data ubuntu:22.04 bash -c "echo persistent-data > /data/test.txt"
```

컨테이너를 삭제했다.

```powershell
docker rm volume-test
```

출력:

```text
volume-test
```

컨테이너가 삭제된 후에도 볼륨 데이터가 유지되는지 확인했다.

```powershell
docker run --rm -v mission-volume:/data ubuntu:22.04 cat /data/test.txt
```

출력:

```text
persistent-data
```

`persistent-data`가 출력되었으므로 컨테이너를 삭제해도 Docker 볼륨에 저장된 데이터는 유지됨을 확인했다.

---

## 21. 바인드 마운트 검증

바인드 마운트는 호스트의 특정 폴더를 컨테이너 내부 경로에 직접 연결하는 방식이다.

호스트의 `site` 폴더를 nginx 컨테이너 내부 웹 루트에 연결했다.

```powershell
docker run -d --name mount-test -p 8081:80 -v ${PWD}/site:/usr/share/nginx/html nginx:alpine
```

옵션 의미는 다음과 같다.

| 옵션 | 의미 |
|---|---|
| `-d` | 백그라운드 실행 |
| `--name mount-test` | 컨테이너 이름 지정 |
| `-p 8081:80` | 호스트 8081 포트를 컨테이너 80 포트에 연결 |
| `-v ${PWD}/site:/usr/share/nginx/html` | 호스트의 `site` 폴더를 컨테이너 웹 루트에 연결 |
| `nginx:alpine` | 사용할 이미지 |

웹 응답을 확인했다.

```powershell
curl.exe http://localhost:8081
```

출력:

```html
<h1>Hello from Docker</h1>
```

호스트에서 `site/index.html` 파일 내용을 수정했다.

```powershell
echo "<h1>Bind Mount Test</h1>" > site/index.html
```

다시 웹 응답을 확인했다.

```powershell
curl.exe http://localhost:8081
```

출력:

```html
<h1>Bind Mount Test</h1>
```

이를 통해 호스트의 파일 변경이 컨테이너 내부 nginx 웹 서버에 즉시 반영됨을 확인했다.

빌드 방식과 바인드 마운트 방식의 차이는 다음과 같다.

| 구분 | Dockerfile COPY 방식 | 바인드 마운트 방식 |
|---|---|---|
| 파일 반영 시점 | 이미지 빌드 시점 |
| 수정 반영 | 다시 빌드 필요 |
| 사용 목적 | 배포용 이미지 제작 |
| 연결 방식 | 파일을 이미지 안에 복사 |

| 구분 | 바인드 마운트 방식 |
|---|---|
| 파일 반영 시점 | 컨테이너 실행 중 실시간 |
| 수정 반영 | 호스트 파일 수정 즉시 반영 |
| 사용 목적 | 개발 및 테스트 |
| 연결 방식 | 호스트 폴더를 컨테이너 경로에 연결 |

---

## 22. 컨테이너 중지 및 삭제

실습 후 실행 중인 컨테이너를 중지했다.

```powershell
docker stop workstation-container
```

출력 예시:

```text
workstation-container
```

바인드 마운트 테스트 컨테이너도 중지했다.

```powershell
docker stop mount-test
```

출력 예시:

```text
mount-test
```

중지된 컨테이너를 삭제했다.

```powershell
docker rm workstation-container
docker rm mount-test
```

출력 예시:

```text
workstation-container
mount-test
```

전체 컨테이너 목록을 확인했다.

```powershell
docker ps -a
```

필요 없는 컨테이너가 삭제되었는지 확인했다.

---

## 23. 트러블슈팅 기록

### 23-1. 포트 충돌 문제

컨테이너 실행 중 다음과 같은 문제가 발생할 수 있다.

```text
Bind for 0.0.0.0:8080 failed: port is already allocated
```

이 오류는 호스트의 8080 포트를 다른 컨테이너나 프로그램이 이미 사용 중일 때 발생한다.

해결 방법은 두 가지이다.

첫 번째 방법은 기존 컨테이너를 중지하고 삭제하는 것이다.

```powershell
docker ps
docker stop 기존컨테이너이름
docker rm 기존컨테이너이름
```

두 번째 방법은 다른 포트를 사용하는 것이다.

```powershell
docker run -d --name workstation-container-2 -p 8082:80 my-workstation
```

이 경우에는 다음 주소로 접속한다.

```text
http://localhost:8082
```

---

### 23-2. 같은 이름의 컨테이너가 이미 존재하는 문제

다음과 같은 오류가 발생할 수 있다.

```text
Conflict. The container name is already in use.
```

이 오류는 같은 이름의 컨테이너가 이미 존재할 때 발생한다.

해결 방법은 기존 컨테이너를 삭제하거나 다른 이름을 사용하는 것이다.

```powershell
docker rm 기존컨테이너이름
```

또는

```powershell
docker run -d --name 다른컨테이너이름 -p 8080:80 my-workstation
```

---

### 23-3. PowerShell과 Linux 명령어 차이

Windows PowerShell과 Linux shell은 일부 명령어가 다르다.

| 작업 | PowerShell | Linux shell |
|---|---|---|
| 파일 목록 확인 | `dir` | `ls -l` |
| 파일 삭제 | `Remove-Item` | `rm` |
| 파일 이동 | `Move-Item` | `mv` |
| 파일 내용 출력 | `cat` | `cat` |
| 권한 변경 | 일반적으로 `chmod` 사용 안 함 | `chmod` |

이번 실습에서는 Windows에서는 PowerShell 명령어를 사용하고, Linux 컨테이너 내부에서는 Linux 명령어를 사용했다.

---

### 23-4. curl 명령어 차이

Windows PowerShell에서는 `curl`이 별칭으로 동작할 수 있으므로 실제 curl 실행 파일을 사용하기 위해 다음처럼 실행했다.

```powershell
curl.exe http://localhost:8080
```

이를 통해 웹 서버의 HTML 응답을 정확히 확인할 수 있었다.

---

### 23-5. Docker 데몬이 실행되지 않는 문제

Docker 명령어 실행 시 Docker 데몬에 연결할 수 없다는 오류가 발생할 수 있다.

이 경우 Docker Desktop이 실행 중인지 확인해야 한다.

확인 방법:

```powershell
docker info
```

`docker info`가 정상적으로 출력되면 Docker CLI와 Docker 데몬이 정상적으로 연결된 상태이다.

---

## 24. Git 커밋 및 GitHub 업로드

변경된 파일 상태를 확인했다.
git status
```

출력 예시:

```text
On branch main
Changes not staged for commit:
  modified:   README.md
```

변경된 파일을 스테이징했다.

```powershell
git add README.md Dockerfile site/index.html permission_test.txt permission_dir_test
```

또는 전체 변경 파일을 한 번에 추가할 수도 있다.

```powershell
git add .
```

스테이징 상태를 다시 확인했다.

```powershell
git status
```

출력 예시:

```text
On branch main
Changes to be committed:
  modified:   README.md
  modified:   site/index.html
  new file:   Dockerfile
  new file:   permission_test.txt
  new file:   permission_dir_test
```

커밋을 생성했다.

```powershell
git commit -m "Complete Docker and Git practice report"
```

출력 예시:

```text
[main xxxxxxx] Complete Docker and Git practice report
 5 files changed, 300 insertions(+)
```

원격 저장소 GitHub에 업로드했다.

```powershell
git push origin main
```

출력 예시:

```text
Enumerating objects: 10, done.
Counting objects: 100% (10/10), done.
Writing objects: 100% (10/10), done.
To https://github.com/kodisei889-dev/kodisei-E1-1.git
   xxxxxxx..xxxxxxx  main -> main
```

업로드 후 GitHub 저장소 페이지에서 README.md가 정상적으로 반영되었는지 확인했다.

---

## 25. 최종 확인 명령어 정리

실습 완료 후 다음 명령어들로 상태를 다시 확인했다.

### Git 상태 확인

```powershell
git status
```

정상 상태 예시:

```text
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

이 출력은 로컬 저장소의 변경 사항이 모두 커밋되었고, 원격 저장소와도 동기화되었다는 의미이다.

### Docker 이미지 확인

```powershell
docker images
```

확인해야 할 이미지 예시:

```text
REPOSITORY       TAG
my-workstation   latest
nginx            alpine
ubuntu           22.04
hello-world      latest
```

### Docker 컨테이너 확인

```powershell
docker ps -a
```

실행 중이거나 종료된 컨테이너 목록을 확인할 수 있다.

### Docker 볼륨 확인

```powershell
docker volume ls
```

출력 예시:

```text
DRIVER    VOLUME NAME
local     mission-volume
```

`mission-volume`이 존재하면 볼륨 생성 실습이 정상적으로 수행된 것이다.

---

## 26. 실습에서 확인한 핵심 내용

이번 실습을 통해 다음 내용을 확인했다.

1. Git 저장소를 클론하고 원격 저장소와 연결할 수 있다.
2. Git 사용자 정보를 설정하고 확인할 수 있다.
3. 변경된 파일을 `git add`, `git commit`, `git push`로 GitHub에 업로드할 수 있다.
4. Docker CLI와 Docker 데몬의 동작 상태를 확인할 수 있다.
5. Dockerfile을 작성하여 이미지를 빌드할 수 있다.
6. 이미지를 기반으로 컨테이너를 실행할 수 있다.
7. `hello-world` 컨테이너 실행으로 Docker 설치 상태를 검증할 수 있다.
8. nginx 컨테이너를 실행하고 포트 매핑으로 웹 서버에 접근할 수 있다.
9. 이미지와 컨테이너의 차이를 설명할 수 있다.
10. Docker 컨테이너의 네트워크 네임스페이스와 포트 포워딩 개념을 이해했다.
11. Docker 볼륨을 사용하여 컨테이너 삭제 후에도 데이터를 유지할 수 있음을 확인했다.
12. 바인드 마운트를 사용하여 호스트 파일 변경이 컨테이너에 반영되는 것을 확인했다.
13. Linux 컨테이너 내부에서 `chmod`를 사용해 파일과 디렉터리 권한을 변경할 수 있다.
14. Windows PowerShell 명령어와 Linux shell 명령어의 차이를 구분할 수 있다.
15. 포트 충돌, 컨테이너 이름 충돌, Docker 데몬 미실행 등의 문제를 해결할 수 있다.

---

## 27. 실습 결과 요약

이번 실습에서는 Docker와 Git을 이용해 개발 환경을 구성하고, 컨테이너 기반 실행 환경을 직접 확인했다.

Dockerfile을 작성하여 nginx 기반 이미지를 만들고, 해당 이미지를 컨테이너로 실행했다.  
또한 `-p 8080:80` 옵션을 사용하여 호스트의 8080 포트와 컨테이너 내부의 80 포트를 연결했다.

브라우저 또는 `curl.exe` 명령어로 `http://localhost:8080`에 접속하여 `site/index.html`의 내용이 정상적으로 출력되는 것을 확인했다.

Docker 볼륨 실습에서는 컨테이너를 삭제해도 볼륨에 저장된 데이터가 유지되는 것을 확인했다.  
바인드 마운트 실습에서는 호스트의 `site/index.html` 파일을 수정하면 nginx 컨테이너의 웹 응답도 즉시 변경되는 것을 확인했다.

권한 실습에서는 Ubuntu 컨테이너 내부에서 `chmod` 명령어를 사용하여 파일과 디렉터리 권한을 변경했다.  
이를 통해 Linux의 `rwx` 권한 구조와 `644`, `755`, `700` 같은 숫자 권한의 의미를 이해했다.

마지막으로 Git을 이용하여 실습 결과를 커밋하고 GitHub 원격 저장소에 업로드했다.

---

## 28. 느낀 점

이번 실습을 통해 Docker의 이미지와 컨테이너 개념을 더 명확히 이해할 수 있었다.  
처음에는 이미지와 컨테이너가 비슷하게 느껴졌지만, 실습을 하면서 이미지는 실행을 위한 템플릿이고 컨테이너는 실제 실행된 환경이라는 차이를 알게 되었다.

또한 포트 매핑을 직접 사용해 보면서 컨테이너 내부 서비스가 호스트에서 바로 보이는 것이 아니라, `-p` 옵션을 통해 연결해야 접근할 수 있다는 점을 이해했다.

Docker 볼륨과 바인드 마운트의 차이도 실습을 통해 확인했다.  
볼륨은 컨테이너가 삭제되어도 데이터를 유지하기 위한 목적이고, 바인드 마운트는 호스트의 파일을 컨테이너와 실시간으로 공유하기 위한 목적이라는 점을 알게 되었다.

Git 실습에서는 파일을 수정한 뒤 `add`, `commit`, `push` 과정을 거쳐 GitHub에 반영하는 흐름을 다시 확인했다.  
앞으로 Docker와 Git을 함께 사용하면 개발 환경을 더 쉽게 관리할 수 있을 것 같다.

---

## 29. 결론

이번 실습에서는 GitHub 저장소 관리와 Docker 컨테이너 실행 환경을 종합적으로 실습했다.

실습 결과, 다음 작업을 수행할 수 있게 되었다.

- Git 저장소 클론 및 원격 저장소 연결 확인
- Git 커밋 및 GitHub 업로드
- Docker 설치 및 데몬 상태 확인
- Dockerfile 작성
- Docker 이미지 빌드
- Docker 컨테이너 실행
- nginx 웹 서버 실행
- 포트 매핑을 통한 웹 접속
- Docker 볼륨을 이용한 데이터 영속성 확인
- 바인드 마운트를 통한 파일 공유 확인
- Linux 파일 및 디렉터리 권한 변경
- Docker 관련 오류 상황 해결

따라서 이번 실습을 통해 Docker와 Git을 활용한 기본 개발 환경 구성 능력을 확인할 수 있었다.