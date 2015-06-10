bakyeono/tg-broadcast
=====================

[See English README](https://github.com/bakyeono/tg-broadcast/blob/master/README.md)

**tg-broadcast** is a Telegram broadcast & auto response script (a.k.a. robot) for [telegram-cli(unofficial)][telegram-cli].

**tg-broadcast**는 [telegram-cli(비공식)][telegram-cli]에서 작동하는 텔레그램 방송 & 자동 반응 로봇 스크립트입니다.

검색해 보시면 여러 가지 텔레그램 로봇 스크립트를 찾을 수 있으니 필요에 맞는 것을 잘 고르세요. 여러 사람에게 메시지를 방송하고 싶다면 이 스크립트를 추천합니다.

tg-broadcast은 telegram-cli 1.3.1 버전에서 테스트 되었습니다.

깃허브 저장소: https://github.com/bakyeono/tg-broadcast

## 기능

### 방송

여러 구독자에게 메시지를 방송할 수 있습니다. 텔레그램 친구들은 당신에게 메시지를 하나 보내는 것만으로 구독을 신청하거나 철회할 수 있습니다.

### 자동 반응

`stdout`에 출력하는 프로그램을 연결해 자동으로 답장을 보낼 수 있습니다. 새로운 반응 규칙을 쉽게 추가할 수 있습니다.

### 데이타베이스 사용 / 비사용

구독자 관리를 위해 SQLite3, MySQL, MariaDB을 지원합니다. 데이타베이스 없이 텍스트 파일로 관리하는 것도 지원합니다.

## 설치

### telegram-cli 설치 (아직 하지 않은 경우)

telegram-cli 소스코드 사본을 가져와 컴파일 합니다. [telegram-cli(비공식)][telegram-cli] 페이지에 설명된 설치 과정을 따르세요.

    $ cd ~
    $ git clone --recursive git@github.com:vysheng/tg.git
    $ cd tg
    $ ./configure
    $ make

컴파일이 완료됐으면 컴파일 된 바이너리와 공개키 파일을 `~/telegram-cli` 경로에 복사합니다.

    $ mkdir ~/telegram-cli
    $ cp bin/telegram-cli tg-server.pub ~/telegram-cli

이제 telegram-cli를 실행해봅니다. 처음 실행하면 인증을 거쳐야 합니다.

    $ cd ~/telegram-cli
    $ ./telegram-cli

telegram-cli의 프롬프트에 `help`를 입력하면 사용가능한 명령어 목록을 볼 수 있습니다.

### tg-broadcast 설치

이 저장소를 홈 디렉토리에 다운로드 하세요.

    $ cd ~
    $ git clone git@github.com:bakyeono/tg-broadcast.git
    $ cd tg-broadcast

SQLite3을 설치합니다. (SQLite3 사용을 추천합니다. SQLite3을 사용하고 싶지 않다면 . `config.lua` 파일을 보세요.)

    $ sudo apt-get install sqlite3

## 실행

이제 tg-broadcast 스크립트를 실행할 수 있습니다.

    $ ~/tg-broadcast/test   # REPL 모드로 실행
    $ ~/tg-broadcast/start  # 데몬 모드로 실행
    $ ~/tg-broadcast/stop   # telegram-cli 프로세스에 종료 신호를 보냅니다.

스크립트가 실행중일 때 자신에게 `help` 메시지를 보내면 아래와 같은 답장을 받을 겁니다.

    help        : This help
    ip          : Server's IP address
    time        : Server's time
    calendar    : Calendar
    weather CITY: Weather for CITY
    subscribe   : Subscribe my news
    unsubscribe : Unsubscribe my news
    -------------------------
    (admin only)
    broadcast   : Force broadcast now
    safequit    : Turn off robot

`config.lua` 파일을 수정해서 방송할 내용을 수정하고 필요한 자동반응 명령을 추가하세요.

[telegram-cli]: https://github.com/vysheng/tg

