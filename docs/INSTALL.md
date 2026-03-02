# Installation Guide (openclaw_team)

이 문서는 새 VM에서 `openclaw_team` 환경을 올리는 **권장 순서**와 스크립트별 역할/옵션을 설명합니다.

---

## 0) 목표

- 한 VM에 팀 전용 OpenClaw 운영 환경 준비
- 추후 1 Gateway + 다수 Agent 구조로 확장 가능한 기반 확보

## 0.1) 중요한 파일 위치 (토큰/설정)

기본 런타임 루트: `~/openclaws`

- Gateway 설정 파일:  
  `~/openclaws/gateways/<gateway-name>/.openclaw/openclaw.json`
- Gateway 환경 파일:  
  `~/openclaws/gateways/<gateway-name>/gateway.env`
- Node 환경 파일:  
  `~/openclaws/nodes/<node-name>/node.env`

토큰 관련 메모:
- Telegram bot token: `openclaw.json` 내 `channels.telegram.botToken`
- Gateway auth token: `openclaw.json` 내 `gateway.auth.token`
- 모델 인증(OAuth/API key): 해당 agent runtime 하위 auth store 파일

보안 주의:
- 위 파일은 git 커밋 금지
- 토큰 노출 시 즉시 재발급

## 0.2) Runtime 구조 vs Team memory 구조

- OpenClaw runtime(실제 대화/세션/에이전트 상태):
  - `~/openclaws/gateways/<gw>/.openclaw/agents/...`
- openclaw_team repo memory:
  - `memory/teams/...` (팀 공유 파일)
  - `memory/agents/...` (에이전트 서랍/레퍼런스 파일)
  - runtime 메모리 대체가 아님

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

### Agent 단계로 넘어가도 되나?
네. Gateway가 안정적으로 떠 있고(서비스 active), 채널 1개 이상 송수신 확인됐다면 다음 단계로 넘어가면 됨.

권장 Agent 온보딩 순서:
1. Director agent 1개 정의 (공유 메모리 큐레이션 담당)
2. Worker agent 1개부터 시작 (예: frontdesk)
3. Worker→Director 보고 흐름(sessions_send/sessions_spawn) 검증
4. 역할별 Worker를 점진적으로 추가

---

## 5) 문서 유지 원칙

이 문서는 실제 운영 중 발견한 문제/해결을 기준으로 지속 업데이트합니다.
변경 시 반드시:
1. 재현 명령
2. 원인
3. 해결 명령
을 함께 기록합니다.
