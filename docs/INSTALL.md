# Installation Guide (openclaw_team)

이 문서는 새 VM에서 `openclaw_team` 환경을 올리는 **권장 순서**와 스크립트별 역할/옵션을 설명합니다.

---

## 0) 목표

- 한 VM에 팀 전용 OpenClaw 운영 환경 준비
- 추후 1 Gateway + 다수 Agent 구조로 확장 가능한 기반 확보

---

## 1) 설치 순서 (권장)

```bash
./scripts/prereq_ubuntu.sh
./scripts/verify_env.sh
./scripts/install_openclaw.sh
./scripts/verify_env.sh --check-openclaw
```

설치 후 권장 확인:
```bash
openclaw --version
node -v
npm -v
```

---

## 2) 스크립트 설명

## `scripts/prereq_ubuntu.sh`

### 역할
- Ubuntu/Debian 기본 패키지 설치
- nvm 설치
- Node.js 설치/활성화 (기본 22)

### 기본 동작
- apt install: `git`, `curl`, `rsync`, `jq`, `build-essential`, `ca-certificates`
- nvm 설치 후 `nvm install 22`

### 옵션
- `--node <major>`: Node major 버전 지정 (기본: 22)

### 예시
```bash
./scripts/prereq_ubuntu.sh
./scripts/prereq_ubuntu.sh --node 22
```

---

## `scripts/verify_env.sh`

### 역할
- 설치 전/후 환경 검증

### 체크 항목
- `git`, `rsync`, `node`, `npm` 존재
- Node major >= 20
- (옵션) `openclaw` 설치 여부

### 옵션
- `--check-openclaw`: openclaw 명령까지 확인

### 예시
```bash
./scripts/verify_env.sh
./scripts/verify_env.sh --check-openclaw
```

---

## `scripts/install_openclaw.sh`

### 역할
- OpenClaw CLI 설치 (버전 핀)
- PATH 보강 (`~/.bashrc`)

### 기본 동작
- 기본 버전: `2026.2.26`
- 실패 시 latest fallback
- npm prefix 기반 PATH를 `~/.bashrc`에 추가

### 옵션
- `--version <ver>`: 설치할 OpenClaw 버전 지정

### 예시
```bash
./scripts/install_openclaw.sh
./scripts/install_openclaw.sh --version 2026.2.26
```

---

## 3) 자주 겪는 문제

### A. `openclaw: command not found`
```bash
source ~/.bashrc
hash -r
command -v openclaw
```

### B. Node 버전 문제
```bash
node -v
# v20+ 필요
```

### C. nvm + npm prefix 충돌 경고
- `.npmrc`의 `prefix=`가 남아 있으면 제거 필요
```bash
npm config delete prefix
sed -i '/^prefix=/d' ~/.npmrc 2>/dev/null || true
```

---

## 4) 다음 단계 (예정)

- `install_gateway.sh` (gateway 생성/시작 표준화)
- `install_node.sh` (노드 추가 표준화)
- Director/Worker agent 배치 템플릿

---

## 5) 문서 유지 원칙

이 문서는 실제 운영 중 발견한 문제/해결을 기준으로 지속 업데이트합니다.
변경 시 반드시:
1. 재현 명령
2. 원인
3. 해결 명령
을 함께 기록합니다.
