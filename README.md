# E1-1 미션 2 개발 워크스테이션 구축

## 1. 미션 개요

Docker를 사용하여 재현 가능한 개발 워크스테이션 환경을 구축하고, 컨테이너 실행 및 리눅스 파일 권한 변경 실습을 진행하였다.

이번 미션의 핵심은 다음과 같다.

- Dockerfile을 이용해 개발 환경을 이미지로 정의한다.
- Docker 이미지를 빌드한다.
- 컨테이너를 실행하고 포트 및 볼륨을 연결한다.
- 리눅스 파일 권한을 확인하고 변경한다.
- 실습 과정을 명령어와 결과 중심으로 기록한다.

---

## 2. 작업 정보

| 항목 | 내용 |
|---|---|
| 미션 | E1-1 미션 2 |
| 작업자 | 저장소 소유자 |
| 운영체제 | Ubuntu 22.04 기반 Docker 이미지 |
| 사용 도구 | Docker, Git, Linux Shell |
| 공개 여부 | 공개용 README이므로 실명 등 개인정보는 제외 |

---

## 3. Dockerfile 작성

Ubuntu 22.04를 기반으로 개발 워크스테이션 이미지를 만들기 위해 `Dockerfile`을 작성하였다.

```Dockerfile
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    vim \
    nano \
    curl \
    git \
    nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### Dockerfile 설명

| 명령어 | 의미 |
|---|---|
| `FROM ubuntu:22.04` | Ubuntu 22.04 이미지를 기반으로 사용 |
| `RUN apt-get update` | 패키지 목록 업데이트 |
| `apt-get install -y` | 필요한 패키지를 자동으로 설치 |
| `vim`, `nano` | 터미널 텍스트 편집기 |
| `curl` | URL 요청 도구 |
| `git` | 버전 관리 도구 |
| `nginx` | 웹 서버 |
| `WORKDIR /workspace` | 컨테이너 내부 작업 디렉터리 설정 |
| `EXPOSE 80` | 컨테이너의 80번 포트 사용 명시 |
| `CMD` | 컨테이너 실행 시 nginx 실행 |

---

## 4. Docker 이미지 빌드

다음 명령어를 사용하여 Docker 이미지를 빌드하였다.

```bash
docker build -t e1-1-workstation .
```

### 실행 결과

```bash
[+] Building ...
[+] Building ... FINISHED
```

이미지 빌드가 정상적으로 완료되었다.

---

## 5. Docker 이미지 확인

빌드된 이미지가 생성되었는지 확인하였다.

```bash
docker images
```

### 실행 결과 예시

```bash
REPOSITORY          TAG       IMAGE ID       CREATED          SIZE
e1-1-workstation    latest    xxxxxxxxxxxx   few seconds ago  xxxMB
```

`e1-1-workstation` 이미지가 생성된 것을 확인하였다.

---

## 6. Docker 컨테이너 실행 및 확인

다음 명령어를 사용하여 컨테이너를 실행하였다.

```bash
docker run -d \
  --name e1-1-container \
  -p 8080:80 \
  -v $(pwd):/workspace \
  e1-1-workstation
```

### 옵션 설명

| 옵션 | 의미 |
|---|---|
| `-d` | 백그라운드에서 컨테이너 실행 |
| `--name e1-1-container` | 컨테이너 이름 지정 |
| `-p 8080:80` | 호스트의 8080 포트를 컨테이너의 80 포트와 연결 |
| `-v $(pwd):/workspace` | 현재 디렉터리를 컨테이너 내부 `/workspace`에 마운트 |
| `e1-1-workstation` | 실행할 Docker 이미지 이름 |

컨테이너가 정상적으로 실행 중인지 확인하였다.

```bash
docker ps
```

### 실행 결과 예시

```bash
CONTAINER ID   IMAGE              COMMAND                  PORTS                  NAMES
xxxxxxxxxxxx   e1-1-workstation   "nginx -g 'daemon of…"   0.0.0.0:8080->80/tcp   e1-1-container
```

`e1-1-container`가 실행 중이며, `8080:80` 포트 연결도 정상적으로 설정되었다.

---

## 7. 리눅스 파일 권한 관리 실습

### 7.1 실습 목적

리눅스에서 파일 권한을 확인하고, `chmod` 명령어를 사용하여 권한을 변경하는 방법을 실습하였다.

이번 실습에서는 다음 내용을 확인하였다.

- `ls -l` 명령어로 파일 권한 확인
- `chmod 755`로 실행 권한 추가
- `chmod 644`로 실행 권한 제거
- `-rw-r--r--`와 `-rwxr-xr-x` 권한 표기의 의미 이해

---

### 7.2 리눅스 파일 권한 표기법 설명

리눅스에서 `ls -l` 명령어를 실행하면 파일 권한이 다음과 같은 형태로 표시된다.

```bash
-rw-r--r--
-rwxr-xr-x
```

권한 표기는 총 10자리로 구성된다.

```text
[파일 종류][소유자 권한][그룹 권한][기타 사용자 권한]
```

예를 들어 `-rw-r--r--`는 다음과 같이 나눌 수 있다.

```text
-rw-r--r--
```

| 구분 | 값 | 의미 |
|---|---|---|
| 파일 종류 | `-` | 일반 파일 |
| 소유자 권한 | `rw-` | 읽기, 쓰기 가능 / 실행 불가 |
| 그룹 권한 | `r--` | 읽기 가능 / 쓰기, 실행 불가 |
| 기타 사용자 권한 | `r--` | 읽기 가능 / 쓰기, 실행 불가 |

따라서 `-rw-r--r--`는 숫자 권한으로 `644`이다.

```text
rw- = 4 + 2 + 0 = 6
r-- = 4 + 0 + 0 = 4
r-- = 4 + 0 + 0 = 4
```

즉, `644`는 다음을 의미한다.

- 소유자: 읽기, 쓰기 가능
- 그룹: 읽기만 가능
- 기타 사용자: 읽기만 가능

---

`-rwxr-xr-x`는 다음과 같이 나눌 수 있다.

```text
-rwxr-xr-x
```

| 구분 | 값 | 의미 |
|---|---|---|
| 파일 종류 | `-` | 일반 파일 |
| 소유자 권한 | `rwx` | 읽기, 쓰기, 실행 가능 |
| 그룹 권한 | `r-x` | 읽기, 실행 가능 / 쓰기 불가 |
| 기타 사용자 권한 | `r-x` | 읽기, 실행 가능 / 쓰기 불가 |

따라서 `-rwxr-xr-x`는 숫자 권한으로 `755`이다.

```text
rwx = 4 + 2 + 1 = 7
r-x = 4 + 0 + 1 = 5
r-x = 4 + 0 + 1 = 5
```

즉, `755`는 다음을 의미한다.

- 소유자: 읽기, 쓰기, 실행 가능
- 그룹: 읽기, 실행 가능
- 기타 사용자: 읽기, 실행 가능

---

#### 권한 문자 의미

| 문자 | 의미 | 설명 |
|---|---|---|
| `r` | read | 파일을 읽을 수 있음 |
| `w` | write | 파일을 수정하거나 쓸 수 있음 |
| `x` | execute | 파일을 실행할 수 있음 |
| `-` | 권한 없음 | 해당 권한이 없음 |

---

#### 숫자 권한 의미

리눅스 파일 권한은 숫자로도 표현할 수 있다.

| 권한 | 숫자 |
|---|---|
| 읽기 `r` | 4 |
| 쓰기 `w` | 2 |
| 실행 `x` | 1 |

각 권한 숫자를 더해서 소유자, 그룹, 기타 사용자의 권한을 표현한다.

| 권한 표시 | 숫자 권한 | 의미 |
|---|---|---|
| `-rw-r--r--` | `644` | 소유자는 읽기/쓰기 가능, 그룹과 기타 사용자는 읽기만 가능 |
| `-rwxr-xr-x` | `755` | 소유자는 읽기/쓰기/실행 가능, 그룹과 기타 사용자는 읽기/실행 가능 |

---

### 7.3 권한 변경 실습 로그

컨테이너 내부에 접속하여 `/workspace` 디렉터리에서 파일 권한 변경 실습을 진행하였다.

#### 1. 컨테이너 내부 접속

```bash
docker exec -it e1-1-container bash
```

컨테이너 내부에서 작업 디렉터리로 이동하였다.

```bash
cd /workspace
pwd
```

실행 결과:

```bash
/workspace
```

호스트의 현재 프로젝트 디렉터리가 컨테이너 내부 `/workspace`와 연결된 것을 확인하였다.

---

#### 2. 실습 파일 생성

```bash
touch permission-test.sh
ls -l permission-test.sh
```

실행 결과:

```bash
-rw-r--r-- 1 root root 0 permission-test.sh
```

처음 생성된 파일은 `644` 권한을 가지고 있었다.

---

#### 3. 실행 권한 추가

```bash
chmod 755 permission-test.sh
ls -l permission-test.sh
```

실행 결과:

```bash
-rwxr-xr-x 1 root root 0 permission-test.sh
```

`chmod 755` 명령어를 실행한 후 파일에 실행 권한이 추가된 것을 확인하였다.

---

#### 4. 권한을 다시 644로 변경

```bash
chmod 644 permission-test.sh
ls -l permission-test.sh
```

실행 결과:

```bash
-rw-r--r-- 1 root root 0 permission-test.sh
```

`chmod 644` 명령어를 실행한 후 실행 권한이 제거된 것을 확인하였다.

---

## 8. 실습 명령어 요약

이번 실습에서 사용한 주요 명령어는 다음과 같다.

```bash
docker build -t e1-1-workstation .

docker images

docker run -d \
  --name e1-1-container \
  -p 8080:80 \
  -v $(pwd):/workspace \
  e1-1-workstation

docker ps

docker exec -it e1-1-container bash

cd /workspace

touch permission-test.sh

ls -l permission-test.sh

chmod 755 permission-test.sh

ls -l permission-test.sh

chmod 644 permission-test.sh

ls -l permission-test.sh
```

---

## 9. 실습 결과 정리

이번 실습을 통해 다음 내용을 확인하였다.

- Dockerfile을 작성하여 개발 환경을 코드로 정의할 수 있었다.
- Docker 이미지를 빌드하여 동일한 환경을 재현할 수 있었다.
- 컨테이너 실행 시 포트 매핑과 볼륨 마운트를 설정할 수 있었다.
- `docker ps` 명령어로 실행 중인 컨테이너를 확인할 수 있었다.
- `docker exec` 명령어로 컨테이너 내부에 접속할 수 있었다.
- 리눅스 파일 권한 표기법을 이해하였다.
- `chmod` 명령어를 사용하여 파일 권한을 변경할 수 있었다.
- `644`와 `755` 권한의 차이를 이해하였다.

---

## 10. 트러블슈팅 기록

| 문제 상황 | 원인 | 해결 방법 |
|---|---|---|
| 컨테이너 내부 파일을 호스트에서도 확인해야 함 | 컨테이너와 호스트 디렉터리가 분리되어 있음 | `-v $(pwd):/workspace` 옵션으로 볼륨 마운트 |
| 웹 서버 포트를 호스트에서 접근해야 함 | 컨테이너 내부 포트는 외부에서 바로 접근할 수 없음 | `-p 8080:80` 옵션으로 포트 매핑 |
| 파일 실행 권한이 없음 | 기본 파일 권한에 실행 권한이 없음 | `chmod 755 파일명`으로 실행 권한 추가 |
| 실행 권한 제거가 필요함 | 실행 파일이 아닌 일반 파일로 관리해야 함 | `chmod 644 파일명`으로 권한 변경 |

---

## 11. 느낀 점

Docker를 사용하면 개발 환경을 Dockerfile로 기록할 수 있어서, 다른 환경에서도 동일한 개발 워크스테이션을 재현할 수 있다는 점을 확인하였다.

또한 리눅스 파일 권한을 직접 변경해 보면서 `-rw-r--r--`, `-rwxr-xr-x`와 같은 표기가 단순한 문자열이 아니라 파일의 읽기, 쓰기, 실행 권한을 나타낸다는 것을 이해할 수 있었다.

이번 실습을 통해 Docker 컨테이너 실행 과정과 리눅스 권한 관리의 기본 개념을 함께 익힐 수 있었다.