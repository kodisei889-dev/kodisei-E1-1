# E1-1 미션 2: 개발 워크스테이션 구축

## 개요

Docker를 사용하여 Ubuntu 기반 개발 워크스테이션 환경을 구축하고, 컨테이너 실행, 접속, 권한 변경, 볼륨 영속성, Git 설정 확인 등을 실습했다.

이번 미션에서는 다음 내용을 확인했다.

- GitHub 저장소 생성 및 Git 설정 확인
- Docker 이미지 빌드
- Docker 컨테이너 실행 및 접속
- Ubuntu 컨테이너 내부 명령어 실행
- 파일 및 디렉터리 권한 확인과 변경
- Docker 볼륨을 이용한 데이터 영속성 확인
- PowerShell과 Linux 명령어 차이 확인
- 실습 중 발생한 오류 트러블슈팅

작성자 정보는 개인정보 보호를 위해 실명 대신 `작업자`로 표기한다.

---

## 작업 환경

| 항목 | 내용 |
|---|---|
| 운영체제 | Windows |
| 터미널 | PowerShell |
| 컨테이너 환경 | Docker Desktop |
| 베이스 이미지 | Ubuntu 22.04 |
| 작업 디렉터리 | `D:\kodisei-E1-1` |
| 컨테이너 내부 작업 경로 | `/app` |

---

## GitHub 저장소

GitHub에 미션용 저장소를 생성하고 로컬 프로젝트와 연결했다.

```text
https://github.com/사용자명/저장소명.git
```

> 실제 README에는 개인정보 보호를 위해 사용자명, 이메일, 저장소 주소를 필요한 경우 마스킹한다.

---

## Dockerfile 작성

Ubuntu 22.04를 기반으로 개발 워크스테이션 이미지를 만들기 위해 Dockerfile을 작성했다.

```dockerfile
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    nginx \
    git \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

CMD ["/bin/bash"]
```

### Dockerfile 설명

| 명령어 | 의미 |
|---|---|
| `FROM ubuntu:22.04` | Ubuntu 22.04 이미지를 기반으로 사용 |
| `RUN apt-get update` | 패키지 목록 업데이트 |
| `apt-get install -y nginx git curl vim` | nginx, git, curl, vim 설치 |
| `WORKDIR /app` | 컨테이너 내부 기본 작업 디렉터리를 `/app`으로 설정 |
| `CMD ["/bin/bash"]` | 컨테이너 실행 시 bash 셸 실행 |

---

## Docker 이미지 빌드

작성한 Dockerfile을 사용하여 `my-workstation` 이미지를 빌드했다.

```powershell
docker build -t my-workstation .
```

이미지 빌드 후 Docker 이미지 목록을 확인했다.

```powershell
docker images
```

이를 통해 `my-workstation` 이미지가 생성되었음을 확인했다.

---

## Docker 컨테이너 실행

빌드한 이미지를 기반으로 컨테이너를 실행했다.

```powershell
docker run -dit --name workstation-container -p 8080:80 -v ${PWD}:/app my-workstation
```

### 옵션 설명

| 옵션 | 의미 |
|---|---|
| `-d` | 백그라운드 실행 |
| `-i` | 표준 입력 유지 |
| `-t` | 터미널 할당 |
| `--name workstation-container` | 컨테이너 이름 지정 |
| `-p 8080:80` | 호스트의 8080 포트를 컨테이너의 80 포트와 연결 |
| `-v ${PWD}:/app` | 현재 프로젝트 폴더를 컨테이너 내부 `/app`에 마운트 |
| `my-workstation` | 실행할 이미지 이름 |

---

## 실행 중인 컨테이너 확인

실행 중인 컨테이너를 확인했다.

```powershell
docker ps
```

전체 컨테이너 목록은 다음 명령어로 확인했다.

```powershell
docker ps -a
```

실행 결과 예시는 다음과 같다.

```text
CONTAINER ID   IMAGE            COMMAND                 CREATED          STATUS                     PORTS                                     NAMES
a9b23f3b5508   hello-world      "/hello"                3 minutes ago    Exited (0) 3 minutes ago                                             vigilant_archimedes
9a7c5d86a7b5   my-workstation   "/bin/bash"             39 minutes ago   Up 38 minutes              0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   workstation-container
9c98ce81e8a6   my-attend-app    "python -u attend.py"   3 hours ago      Exited (0) 3 hours ago                                               sad_allen
d7520c21b236   my-attend-app    "python -u attend.py"   3 hours ago      Exited (0) 3 hours ago                                               vigorous_ganguly
```

`workstation-container` 컨테이너가 실행 중이며, 호스트의 `8080` 포트가 컨테이너의 `80` 포트와 연결되어 있음을 확인했다.

---

## Docker 버전 및 정보 확인

Docker 설치 상태와 정보를 확인하기 위해 다음 명령어를 실행했다.

```powershell
docker --version
```

```powershell
docker info
```

이를 통해 Docker가 정상적으로 설치되어 있고, 현재 환경에서 컨테이너를 실행할 수 있음을 확인했다.

---

## hello-world 컨테이너 실행

Docker가 정상적으로 동작하는지 확인하기 위해 `hello-world` 이미지를 실행했다.

```powershell
docker run hello-world
```

이후 전체 컨테이너 목록에서 `hello-world` 컨테이너가 실행 후 종료된 것을 확인했다.

```powershell
docker ps -a
```

`hello-world` 컨테이너의 상태가 `Exited (0)`으로 표시되어 정상 실행 후 종료되었음을 확인했다.

---

## Ubuntu 테스트 컨테이너 실행

Ubuntu 22.04 테스트 컨테이너를 실행하고 내부에 접속했다.

```powershell
docker run -it --name ubuntu-test ubuntu:22.04 bash
```

컨테이너 내부에서 현재 위치를 확인했다.

```bash
pwd
```

실행 결과는 다음과 같다.

```text
/
```

루트 디렉터리의 파일과 디렉터리를 확인했다.

```bash
ls
```

실행 결과는 다음과 같다.

```text
bin   dev  home  lib32  libx32  mnt  proc  run   srv  tmp  var
boot  etc  lib   lib64  media   opt  root  sbin  sys  usr
```

문자열 출력 명령어도 실행했다.

```bash
echo "hello ubuntu container"
```

실행 결과는 다음과 같다.

```text
hello ubuntu container
```

작업 완료 후 컨테이너에서 나왔다.

```bash
exit
```

---

## 테스트 컨테이너 삭제

Ubuntu 테스트 컨테이너 사용 후 다음 명령어로 컨테이너를 삭제했다.

```powershell
docker rm ubuntu-test
```

실행 결과는 다음과 같다.

```text
ubuntu-test
```

이를 통해 `ubuntu-test` 컨테이너가 정상적으로 삭제되었음을 확인했다.

---

## 컨테이너 로그 확인

`workstation-container`의 로그를 확인했다.

```powershell
docker logs workstation-container
```

해당 명령어는 정상적으로 실행되었지만 별도의 출력 로그는 표시되지 않았다.

이는 컨테이너에서 표준 출력으로 남긴 로그가 없을 경우 발생할 수 있다.

---

## 파일 권한 실습

컨테이너 내부 Linux 환경에서 파일 권한을 확인하고 변경했다.

예시 파일을 생성했다.

```bash
touch permission_test.txt
```

파일 권한을 확인했다.

```bash
ls -l permission_test.txt
```

파일 권한을 `644`로 변경했다.

```bash
chmod 644 permission_test.txt
ls -l permission_test.txt
```

파일 권한을 `755`로 변경했다.

```bash
chmod 755 permission_test.txt
ls -l permission_test.txt
```

### 파일 권한 의미

| 권한 | 표시 예시 | 의미 |
|---|---|---|
| `644` | `-rw-r--r--` | 소유자는 읽기/쓰기 가능, 그룹과 기타 사용자는 읽기만 가능 |
| `755` | `-rwxr-xr-x` | 소유자는 읽기/쓰기/실행 가능, 그룹과 기타 사용자는 읽기/실행 가능 |

### 권한 표기법

예를 들어 다음과 같은 권한이 있다고 할 때,

```text
-rwxr-xr-x
```

각 부분의 의미는 다음과 같다.

```text
- rwx r-x r-x
```

| 위치 | 의미 |
|---|---|
| `-` | 일반 파일 |
| `rwx` | 소유자 권한 |
| `r-x` | 그룹 권한 |
| `r-x` | 기타 사용자 권한 |

권한 문자의 의미는 다음과 같다.

| 문자 | 의미 |
|---|---|
| `r` | 읽기 권한 |
| `w` | 쓰기 권한 |
| `x` | 실행 권한 |
| `-` | 해당 권한 없음 |

---

## 디렉터리 권한 실습

PowerShell에서는 Linux 명령어인 `ls -ld`가 동작하지 않기 때문에 Docker 컨테이너 내부에서 권한 실습을 진행했다.

먼저 실행 중인 컨테이너에 접속했다.

```powershell
docker exec -it workstation-container bash
```

컨테이너 접속 후 `/workspace` 경로로 이동을 시도했다.

```bash
cd /workspace
```

하지만 다음 오류가 발생했다.

```text
bash: cd: /workspace: No such file or directory
```

현재 컨테이너의 작업 경로는 `/app`이었으므로 `/app` 경로에서 실습을 진행했다.

```bash
cd /app
```

디렉터리 권한을 확인했다.

```bash
ls -ld permission_dir_test
```

실행 결과는 다음과 같다.

```text
drwxrwxrwx 1 root root 4096 Nov  3 05:25 permission_dir_test
```

초기 권한은 `777` 형태로 확인되었다.

이후 디렉터리 권한을 `755`로 변경했다.

```bash
chmod 755 permission_dir_test
ls -ld permission_dir_test
```

실행 결과는 다음과 같다.

```text
drwxr-xr-x 1 root root 4096 Nov  3 05:25 permission_dir_test
```

다시 디렉터리 권한을 `700`으로 변경했다.

```bash
chmod 700 permission_dir_test
ls -ld permission_dir_test
```

실행 결과는 다음과 같다.

```text
drwx------ 1 root root 4096 Nov  3 05:25 permission_dir_test
```

이를 통해 Docker 컨테이너 내부 Linux 환경에서 디렉터리 권한을 확인하고 변경하는 방법을 실습했다.

### 디렉터리 권한 변화 정리

| 권한 | 표시 | 의미 |
|---|---|---|
| `777` | `drwxrwxrwx` | 소유자, 그룹, 기타 사용자 모두 읽기/쓰기/실행 가능 |
| `755` | `drwxr-xr-x` | 소유자는 모든 권한, 그룹과 기타 사용자는 읽기/실행 가능 |
| `700` | `drwx------` | 소유자만 읽기/쓰기/실행 가능 |

### 디렉터리 권한 표기 의미

예를 들어 다음 권한을 보면,

```text
drwxr-xr-x
```

각 부분의 의미는 다음과 같다.

```text
d rwx r-x r-x
```

| 위치 | 의미 |
|---|---|
| `d` | 디렉터리 |
| `rwx` | 소유자 권한: 읽기, 쓰기, 실행 가능 |
| `r-x` | 그룹 권한: 읽기, 실행 가능 |
| `r-x` | 기타 사용자 권한: 읽기, 실행 가능 |

---

## Docker 볼륨 영속성 확인

Docker 볼륨이 컨테이너 삭제 이후에도 데이터를 유지하는지 확인했다.

먼저 Docker 볼륨을 생성했다.

```powershell
docker volume create mission-volume
```

실행 결과는 다음과 같다.

```text
mission-volume
```

생성한 볼륨을 컨테이너의 `/data` 경로에 마운트하고 테스트 파일을 생성했다.

```powershell
docker run --name volume-test -v mission-volume:/data ubuntu:22.04 bash -c "echo persistent-data > /data/test.txt"
```

이후 테스트 컨테이너를 삭제했다.

```powershell
docker rm volume-test
```

실행 결과는 다음과 같다.

```text
volume-test
```

컨테이너 삭제 후에도 볼륨에 저장된 데이터가 유지되는지 확인했다.

```powershell
docker run --rm -v mission-volume:/data ubuntu:22.04 cat /data/test.txt
```

실행 결과는 다음과 같다.

```text
persistent-data
```

이를 통해 컨테이너가 삭제되어도 Docker 볼륨에 저장된 데이터는 유지됨을 확인했다.

---

## Git 설정 확인

Git 설정을 확인하기 위해 다음 명령어를 실행했다.

```powershell
git config --list
```

주요 설정 일부는 다음과 같다.

```text
core.autocrlf=true
init.defaultbranch=master
core.repositoryformatversion=0
core.filemode=false
core.bare=false
core.logallrefupdates=true
core.ignorecase=true
remote.origin.url=https://github.com/사용자명/저장소명.git
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
branch.main.remote=origin
branch.main.merge=refs/heads/main
branch.main.vscode-merge-base=origin/main
```

Git 저장소가 원격 저장소와 연결되어 있으며, 현재 브랜치가 `main` 브랜치와 연결되어 있음을 확인했다.

개인정보 보호를 위해 실제 사용자명, 이메일, 저장소 주소는 README에 직접 노출하지 않고 필요한 경우 마스킹하여 기록한다.

---

## PowerShell과 Linux 명령어 차이

이번 실습에서 PowerShell과 Linux 명령어가 다르게 동작할 수 있음을 확인했다.

PowerShell에서 다음 명령어를 실행했다.

```powershell
ls -ld permission_dir_test
```

하지만 다음 오류가 발생했다.

```text
Get-ChildItem : 매개 변수 이름 'ld'과(와) 일치하는 매개 변수를 찾을 수 없습니다.
```

이는 PowerShell의 `ls`가 Linux의 `ls` 명령어가 아니라 PowerShell 명령어인 `Get-ChildItem`의 별칭이기 때문이다.

따라서 Linux 옵션인 `-ld`를 PowerShell에서는 그대로 사용할 수 없다.

Linux 방식의 권한 확인 명령어는 Docker 컨테이너 내부에서 실행해야 한다.

```powershell
docker exec -it workstation-container bash
```

컨테이너 내부에서 다음 명령어를 실행했다.

```bash
cd /app
ls -ld permission_dir_test
```

실행 결과는 정상적으로 출력되었다.

```text
drwxrwxrwx 1 root root 4096 Nov  3 05:25 permission_dir_test
```

이를 통해 운영체제와 셸 환경에 따라 같은 명령어처럼 보여도 실제 동작 방식이 다를 수 있음을 확인했다.

---

## 트러블슈팅 1: PowerShell에서 `ls -ld` 명령어 오류

### 문제 상황

PowerShell에서 디렉터리 권한을 확인하기 위해 다음 명령어를 실행했다.

```powershell
ls -ld permission_dir_test
```

하지만 다음 오류가 발생했다.

```text
Get-ChildItem : 매개 변수 이름 'ld'과(와) 일치하는 매개 변수를 찾을 수 없습니다.
위치 줄:1 문자:4
+ ls -ld permission_dir_test
+    ~~~
    + CategoryInfo          : InvalidArgument: (:) [Get-ChildItem], ParameterBindingException
    + FullyQualifiedErrorId : NamedParameterNotFound,Microsoft.PowerShell.Commands.GetChildItemCommand
```

### 원인

`ls -ld`는 Linux 환경에서 사용하는 명령어이다.

PowerShell의 `ls`는 Linux의 `ls`가 아니라 `Get-ChildItem`의 별칭이다.  
따라서 PowerShell은 Linux 옵션인 `-ld`를 인식하지 못한다.

### 해결 방법

Docker 컨테이너 내부의 Linux 환경에 접속한 뒤 명령어를 실행했다.

```powershell
docker exec -it workstation-container bash
```

컨테이너 내부에서 실제 작업 경로인 `/app`으로 이동했다.

```bash
cd /app
```

이후 Linux 명령어를 실행했다.

```bash
ls -ld permission_dir_test
```

실행 결과는 다음과 같다.

```text
drwxrwxrwx 1 root root 4096 Nov  3 05:25 permission_dir_test
```

### 정리

PowerShell에서는 Linux 전용 옵션을 그대로 사용할 수 없다.  
Linux 권한 확인 명령어는 Docker 컨테이너 내부 Linux 환경에서 실행해야 한다.

---

## 트러블슈팅 2: `/workspace` 경로가 존재하지 않는 문제

### 문제 상황

Docker 컨테이너 내부에 접속한 뒤 프로젝트 경로로 예상한 `/workspace`로 이동하려고 했다.

```bash
cd /workspace
```

하지만 다음 오류가 발생했다.

```text
bash: cd: /workspace: No such file or directory
```

### 원인

컨테이너 실행 시 프로젝트 디렉터리가 `/workspace`가 아니라 `/app` 경로에 마운트되어 있었다.

컨테이너 접속 직후 프롬프트도 다음과 같이 표시되었다.

```text
root@9a7c5d86a7b5:/app#
```

이를 통해 현재 작업 경로가 `/app`임을 확인할 수 있었다.

### 해결 방법

`/workspace` 대신 `/app` 경로에서 실습을 진행했다.

```bash
cd /app
ls -ld permission_dir_test
```

### 정리

컨테이너마다 프로젝트 폴더가 마운트되는 위치는 다를 수 있다.  
경로가 없다는 오류가 발생하면 현재 위치를 확인해야 한다.

```bash
pwd
ls
```

이번 실습에서는 실제 작업 경로가 `/app`이었다.

---

## 트러블슈팅 3: PowerShell에서 `docker inspect --format` 템플릿 오류

### 문제 상황

컨테이너의 마운트 경로를 확인하기 위해 다음 명령어를 실행했다.

```powershell
docker inspect workstation-container --format '{{range .Mounts}}{{println .Source "->" .Destination}}{{end}}'
```

하지만 다음 오류가 발생했다.

```text
template parsing error: template: :1: illegal number syntax: "-"
```

### 원인

PowerShell 환경에서 Docker의 `--format` 템플릿 문자열 안에 있는 따옴표와 기호가 예상과 다르게 해석되어 오류가 발생한 것으로 보인다.

특히 `"->"`처럼 템플릿 내부에 따옴표가 포함된 문자열은 PowerShell에서 처리될 때 문제가 생길 수 있다.

### 해결 방법

PowerShell에서는 템플릿 문자열을 조금 더 단순하게 작성할 수 있다.

```powershell
docker inspect workstation-container --format "{{range .Mounts}}{{.Source}} -> {{.Destination}}{{println}}{{end}}"
```

또는 전체 inspect 결과를 출력한 뒤 `Mounts` 항목을 직접 확인할 수도 있다.

```powershell
docker inspect workstation-container
```

### 정리

Docker의 `--format` 옵션은 터미널 환경에 따라 따옴표 처리 방식이 다를 수 있다.  
PowerShell에서는 템플릿 문자열을 단순하게 작성하는 것이 좋다.

---

## 최종 확인 명령어 모음

이번 미션에서 사용한 주요 명령어는 다음과 같다.

### Docker 이미지 빌드

```powershell
docker build -t my-workstation .
```

### 컨테이너 실행

```powershell
docker run -dit --name workstation-container -p 8080:80 -v ${PWD}:/app my-workstation
```

### 실행 중인 컨테이너 확인

```powershell
docker ps
```

### 전체 컨테이너 확인

```powershell
docker ps -a
```

### 컨테이너 접속

```powershell
docker exec -it workstation-container bash
```

### 컨테이너 로그 확인

```powershell
docker logs workstation-container
```

### Docker 이미지 목록 확인

```powershell
docker images
```

### Docker 버전 확인

```powershell
docker --version
```

### Docker 정보 확인

```powershell
docker info
```

### hello-world 실행

```powershell
docker run hello-world
```

### 볼륨 생성

```powershell
docker volume create mission-volume
```

### 볼륨 데이터 생성

```powershell
docker run --name volume-test -v mission-volume:/data ubuntu:22.04 bash -c "echo persistent-data > /data/test.txt"
```

### 볼륨 테스트 컨테이너 삭제

```powershell
docker rm volume-test
```

### 볼륨 데이터 확인

```powershell
docker run --rm -v mission-volume:/data ubuntu:22.04 cat /data/test.txt
```

---

## 학습한 내용

이번 미션을 통해 다음 내용을 학습했다.

1. Dockerfile을 작성하여 Ubuntu 기반 이미지를 만들 수 있다.
2. Docker 이미지를 빌드하고 컨테이너를 실행할 수 있다.
3. `docker ps`, `docker ps -a`, `docker images` 명령어로 Docker 상태를 확인할 수 있다.
4. `docker exec -it` 명령어로 실행 중인 컨테이너 내부에 접속할 수 있다.
5. PowerShell과 Linux 명령어는 같은 이름처럼 보여도 동작 방식이 다를 수 있다.
6. Linux의 파일 권한과 디렉터리 권한을 `ls -l`, `ls -ld`, `chmod`로 확인하고 변경할 수 있다.
7. Docker 볼륨을 사용하면 컨테이너가 삭제되어도 데이터를 유지할 수 있다.
8. 컨테이너 내부 작업 경로와 마운트 경로를 확인하는 것이 중요하다.
9. Git 설정을 확인하고 원격 저장소 연결 상태를 점검할 수 있다.
10. 실습 중 발생한 오류를 트러블슈팅 문서로 정리할 수 있다.

---

## 최종 결과

Docker 기반 개발 워크스테이션 환경 구축을 완료했다.

최종적으로 다음 항목을 확인했다.

- Ubuntu 22.04 기반 Docker 이미지 빌드 완료
- `my-workstation` 이미지 생성 확인
- `workstation-container` 컨테이너 실행 확인
- 호스트 `8080` 포트와 컨테이너 `80` 포트 연결 확인
- 현재 프로젝트 폴더를 컨테이너 내부 `/app`에 마운트
- 컨테이너 내부 접속 성공
- 파일 권한 변경 실습 완료
- 디렉터리 권한 변경 실습 완료
- Docker 볼륨 영속성 검증 완료
- Docker 기본 명령어 실행 확인
- Git 설정 및 원격 저장소 연결 확인
- PowerShell과 Linux 명령어 차이 트러블슈팅 완료

---

## 마무리

이번 실습에서는 Docker를 활용해 Ubuntu 기반 개발 워크스테이션을 구축하고, 컨테이너 내부에서 Linux 명령어와 권한 변경을 실습했다.

특히 PowerShell에서 발생한 `ls -ld` 오류를 통해 Windows PowerShell과 Linux 셸의 차이를 이해할 수 있었다.  
또한 `/workspace` 경로가 없다는 오류를 해결하면서 컨테이너 내부의 실제 작업 경로가 `/app`임을 확인했다.

Docker 볼륨 실습을 통해 컨테이너가 삭제되어도 볼륨에 저장된 데이터는 유지된다는 점도 확인했다.

이번 미션을 통해 개발 환경 구축, 컨테이너 실행, 권한 관리, 볼륨 영속성, 트러블슈팅 기록까지 전반적인 개발 워크스테이션 구축 과정을 경험했다.

### 추가

이번 미션을 통해 개발 워크스테이션 구축에 필요한 기본 환경을 직접 설정하고 확인했다.

#### 수행 내용 요약

- GitHub 저장소 생성 및 로컬 프로젝트 연결
- `Dockerfile` 작성
- `nginx:alpine` 기반 Docker 이미지 빌드
- Docker 컨테이너 실행
- `8080:80` 포트 매핑 설정
- `docker ps`로 컨테이너 실행 상태 확인
- `curl.exe http://localhost:8080` 명령으로 웹 서버 응답 확인
- 브라우저에서 `http://localhost:8080` 접속 확인
- Docker 기본 명령어 실습
  - `docker images`
  - `docker ps`
  - `docker ps -a`
  - `docker logs`
  - `docker stats`
- `hello-world`, `ubuntu` 컨테이너 실행 실습
- Docker 볼륨 생성 및 데이터 영속성 확인
- 터미널 기본 명령어 실습
- 파일 및 디렉토리 권한 변경 실습 (`755`, `644`, `700`)

#### 최종 검증 결과

컨테이너 실행 상태 확인:

```bash
docker ps
```

확인 결과:

```text
CONTAINER ID   IMAGE            COMMAND                   CREATED          STATUS          PORTS                                     NAMES
cd667d637c1a   my-workstation   "/docker-entrypoint.…"   52 seconds ago   Up 52 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   workstation-container
```

웹 서버 응답 확인:

```bash
curl.exe http://localhost:8080
```

출력 결과:

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

위 결과를 통해 Docker 컨테이너가 정상적으로 실행되었고, 포트 매핑 및 웹 서버 접속이 올바르게 동작함을 확인했다.

#### 트러블슈팅 정리

**1) `docker logs` 명령 실행 오류**

문제:
- `docker logs` 실행 시 컨테이너 이름 또는 ID를 함께 입력하지 않아 오류가 발생했다.

해결:

```bash
docker logs workstation-container
```

**2) PowerShell에서 `ls -ld` 명령 사용 문제**

문제:
- Linux에서 사용하는 `ls -ld` 명령이 PowerShell 환경에서는 동일하게 동작하지 않았다.

해결:
- Windows 환경에 맞는 명령어를 사용하거나, Git Bash 또는 WSL 같은 Linux 스타일 터미널을 활용했다.

**3) CMD에서 `${PWD}` 사용 오류**

문제:
- `${PWD}`는 PowerShell 문법이므로 CMD에서는 인식되지 않았다.

해결:
- CMD에서는 `%cd%`를 사용해야 한다.
- 또는 볼륨 옵션 없이 먼저 컨테이너를 실행해 동작을 확인할 수 있다.

예시:

```bash
docker run -d --name workstation-container -p 8080:80 my-workstation
```

**4) 컨테이너 이름 중복 오류**

문제:
- 같은 이름의 컨테이너가 이미 존재하여 새 컨테이너 실행에 실패했다.

해결:

```bash
docker rm -f workstation-container
docker run -d --name workstation-container -p 8080:80 my-workstation
```

**5) `ubuntu` 컨테이너에서 `bash` 종료 문제**

문제:
- `bash` 셸에서 `exit`를 입력하면 컨테이너가 종료되었다.

해결:
- 이는 정상 동작이며, 종료 후 `docker ps -a`로 상태를 확인할 수 있다.

#### 느낀 점

이번 실습을 통해 Docker 이미지를 만들고 컨테이너를 실행하는 기본 흐름을 직접 경험할 수 있었다.  
또한 포트 매핑, 로그 확인, 볼륨 사용, 명령어 환경 차이 같은 실제 개발 환경에서 자주 만나는 문제를 직접 해결해 보면서 Docker 사용 방법을 더 익힐 수 있었다.
