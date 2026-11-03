# 1. 베이스 이미지 설정 (가벼운 우분투 리눅스)
FROM ubuntu:22.04

# 2. 필수 패키지 설치 (기본 도구들)
RUN apt-get update && apt-get install -y \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

# 3. 작업 디렉토리 설정
WORKDIR /app

# 4. 컨테이너가 실행될 때 유지되도록 설정
CMD ["/bin/bash"]