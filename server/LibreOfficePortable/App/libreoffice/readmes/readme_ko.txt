
======================================================================
LibreOffice 7.5 ReadMe
======================================================================


For the latest updates to this readme file, see https://git.libreoffice.org/core/tree/master/README.md

이 파일은 LibreOffice에 대한 중요한 정보를 담고 있습니다. 설치를 시작하기 전에 이 정보를 주의 깊게 읽으십시오.

제품의 개발을 담당하고 있는 LibreOffice 커뮤니티는 여러분의 참여를 기다립니다. 새 사용자는 LibreOffice 사이트를 방문하여 LibreOffice 프로젝트와 커뮤니티에 대한 다양한 정보를 얻을 수 있습니다. https://ko.libreoffice.org/를 방문해 보십시오.

LibreOffice는 정말 모든 사용자에게 무료입니까?
----------------------------------------------------------------------

LibreOffice는 모든 사람이 무료로 사용할 수 있습니다. 여러분은 LibreOffice 복사본을 원하는 수의 컴퓨터에 설치할 수 있으며 (회사, 정부, 공공 기관, 교육 기관 등을 포함하여) 용도에 관계없이 사용할 수 있습니다. 더 자세한 사항은 LibreOffice 다운로드에 포함된 라이선스 전문을 참고하십시오.

왜 LibreOffice는 모든 사용자에게 무료입니까?
----------------------------------------------------------------------

여러분이 LibreOffice를 무료로 사용할 수 있는 것은 개인 기여자와 기업 스폰서가 세계 최고의 오픈 소스 가정용 및 사무용 생산성 소프트웨어인 오늘날의 LibreOffice를 위해 다양한 방법으로 설계, 개발, 테스트, 번역, 문서 작업, 사용자 지원, 마케팅 등을 돕고 있기 때문입니다.

기여자들의 노력에 감사한 마음이 든다면, 더 많은 사람들이 LibreOffice를 사용할 수 있도록 프로젝트에 기여해 주세요. 누구나 다양한 방법으로 기여할 수 있습니다. 자세한 내용은 https://www.documentfoundation.org/contribution/을 참고하십시오.

----------------------------------------------------------------------
설치시 참고 사항
----------------------------------------------------------------------

LibreOffice의 모든 기능을 아용하려면 최신 버전의 Java 런타임 환경(JRE)가 필요합니다. JRE는 LibreOffice 설치 패키지에 포함되어 있지 않아 따로 설치해야 합니다.

시스템 요구 사항
----------------------------------------------------------------------

* Microsoft Windows 7 SP1, 8, 8.1 Update (S14) 또는 10

설치 과정에는 관리자 권한이 필요하다는 점을 숙지하십시오.

Microsoft 오피스 포맷의 기본 프로그램으로 LibreOffice 을 등록하는 것은 설치 프로그램에서 다음 명령을 통해 설정할 수 있습니다.:

* REGISTER_ALL_MSO_TYPES=1을(를) 선택하면 LibreOffice를 Microsoft Office 형식의 기본 프로그램으로 설정합니다.
* REGISTER_NO_MSO_TYPES=1을(를) 선택하면 LibreOffice를 Microsoft Office 형식의 기본 프로그램으로 설정하지 않습니다.

시스템의 임시 디렉터리에 충분한 공간이 있는지 확인하고 읽기, 쓰기, 실행 권한이 있는지 확인하십시오. 설치 과정을 시작하기 전에 다른 모든 프로그램을 닫으십시오.

Debian/Ubuntu 기반 Linux 시스템에서 LibreOffice 설치
----------------------------------------------------------------------

(LibreOffice 영어 버전을 설치한 후에) 추가 언어팩을 설치하는 방법은 아래의 "언어팩 설치하기" 섹션을 참고하십시오.

다운로드받은 파일을 압축 해제합니다. 파일 관리자를 열고 "LibreOffice_(버전 및 플랫폼 정보)" 디렉터리로 이동합니다.

이 디렉터리에는 "DEBS"라는 하위 디렉터리가 있습니다. "DEBS" 디렉터리로 이동합니다.

디렉터리 안에서 마우스 오른쪽 버튼을 클릭하고 "터미널 열기"를 선택하면 터미널 창이 열립니다. 터미널 창의 명령줄에 다음 명령을 입력합니다.(명령을 수행하기 전에 관리자 암호를 입력해야 합니다):

다음 명령어는 리브레오피스와 데스크톱 통합 패키지를 설치합니다.(단순히 명령어를 복사해 터미널 화면에 붙여넣기 해도 됩니다.):

sudo dpkg -i *.deb

이제 설치 과정을 마쳤으며 데스크톱의 응용프로그램/오피스 메뉴에 LibreOffice의 각 애플리케이션을 가리키는 아이콘이 표시됩니다.

Fedora, openSUSE, Mandriva 등 RPM 패키지를 사용하는 다른 리눅스 시스템에 LibreOffice 설치하기
----------------------------------------------------------------------

(LibreOffice 영어 버전을 설치한 후에) 추가 언어팩을 설치하는 방법은 아래의 "언어팩 설치하기" 섹션을 참고하시십시오.

다운로드받은 파일을 압축 해제합니다. 파일 관리자를 열고 "LibreOffice_(버전 및 플랫폼 정보)" 디렉터리로 이동합니다.

해당 디렉터리는 "RPMS"라는 하위 디렉터리를 가지고 있습니다. "RPMS" 디렉터리로 변경합니다.

디렉터리 안에서 마우스 오른쪽 버튼을 클릭하고 "터미널 열기"를 선택하면 터미널 창이 열립니다. 터미널 창의 명령줄에 다음 명령을 입력합니다.(명령을 수행하기 전에 관리자 암호를 입력해야 합니다):

For Fedora-based systems: sudo dnf install *.rpm

Mandriva 기반 시스템: sudo urpmi *.rpm

기타 RPM 이용 시스템(openSUSE 등): rpm -Uvh *.rpm

이제 설치 과정을 마쳤으며 데스크톱의 응용프로그램/오피스 메뉴에 LibreOffice의 각 애플리케이션을 가리키는 아이콘이 표시됩니다.

사용자 권한으로 설치를 진행하려면, 이 압축파일의 최상위 디렉터리에 있는 'install' 스크립트를 이용하여 설치를 진행합니다. 이 스크립트를 이용하면 일반적인 LibreOffice 프로필과는 독립적인 자체 프로필을 생성합니다. 그리고 데스크톱 메뉴 항목이나 데스크탑 MIME 타입 등록과 같은 시스템 통합 부분을 진행하지 않습니다.

위 설치 설명에서 다루지 않은 리눅스 배포판의 데스크톱 통합에 대한 참고 사항
----------------------------------------------------------------------

이 설치 설명에서 다루지 않은 Linux 배포판에서도 쉽게 LibreOffice를 설치할 수 있습니다. 발생 가능한 다른 점의 주 양상은 데스크톱 통합입니다.

RPMS(또는 DEBS) 디렉터리에도 libreoffice7.5-freedesktop-menus-7.5.0.1-1.noarch.rpm (또는 libreoffice7.5-debian-menus_7.5.0.1-1_all.deb) 이라는 패키지가 있습니다. 이 패키지는 Freedesktop.org 기술 사양/추천 (https://en.wikipedia.org/wiki/Freedesktop.org) 내용을 지원하는 모든 리눅스 배포판을 위한 패키지입니다. 그리고 앞서 기술한 설치 방법을 지원하지 않는 다른 리눅스 배포판을 위한 설치 방법도 제공합니다.

언어팩 설치하기
----------------------------------------------------------------------

원하는 언어와 플랫폼에 맞는 언어팩을 다운로드합니다. 언어팩은 주 설치 저장소와 같은 장소에서 다운로드할 수 있습니다. Nautilus 파일 관리자를 이용하여 다운로드한 압축파일을 (바탕 화면과 같은) 임의의 디렉터리에 풉니다. 그리고 (빠른 시작을 포함한) 모든 LibreOffice 응용 프로그램을 종료했는지 확인합니다.

다운로드한 언어 팩을 푼 디렉터리로 변경합니다.

이제, 압축 해제를 하는 과정에서 생긴 디렉터리로 이동합니다. 예를 들어 32비트 데비안/우분투 시스템용 한국어 언어팩의 경우, 디렉터리명은 LibreOffice_버전정보_Linux_x86_langpack-deb_ko 입니다.

이제 설치할 패키지가 있는 디렉터리로 이동합니다. 데비안/우분투 시스템이라면, DEBS 디렉터리입니다. 페도라, 오픈수세, 맨드리바 시스템의 경우에는 RPMS 디렉터리입니다.

Nautilus 파일 관리자에서 해당 폴더에 마우스 오른쪽 버튼을 클릭하고 "터미널에서 열기" 명령을 선택합니다. 방금 연 터미널 창에서 (아래 명령을 이용하여) 언어팩을 설치하기 위한 명령을 실행합니다(관리자 암호 입력을 요청할 수도 있습니다):

Debian/Ubuntu 기반 시스템: sudo dpkg -i *.deb

For Fedora-based systems: su -c 'dnf install *.rpm'

Mandriva 기반 시스템: sudo urpmi *.rpm

기타 RPM 이용 시스템(openSUSE 등): rpm -Uvh *.rpm

이제 라이터와 같은 LibreOffice 응용 프로그램 중 하나를 시작합니다. 도구 메뉴에서 옵션을 선택합니다. 기본 설정 대화 상자에서 "언어 설정"을 클릭하고 "언어"를 클릭합니다. "사용자 화면" 목록을 펼치고 방금 설치한 언어를 선택합니다. 원하는 경우에는 "국가별 설정", "기본 통화", "문서 기본 언어"에 대해서 같은 작업을 반복합니다.

해당 설정을 지정한 후에 확인을 클릭합니다. 대화 상자가 닫히고, (빠른 시작을 포함한) LibreOffice를 종료한 후 다시 시작해야 변경 사항이 적용된다는 것을 알리는 메시지가 표시됩니다.

다음에 LibreOffice를 시작하면 방금 설치한 언어로 시작됩니다.

----------------------------------------------------------------------
Problems During Program 시동
----------------------------------------------------------------------

Difficulties starting LibreOffice (e.g. applications hang) as well as problems with the screen display are often caused by the graphics card driver. If these problems occur, please update your graphics card driver or try using the graphics driver delivered with your operating system.

----------------------------------------------------------------------
윈도우에서 ALPS/Synaptics 노트북 터치패드
----------------------------------------------------------------------

윈도우 드라이버 문제 때문에, ALPS/Synaptics 터치패드에서 손가락을 움직여서 LibreOffice 문서를 스크롤할 수 없습니다.

터치패드 스크롤을 사용하려면 "C:\Program Files\Synaptics\SynTP\SynTPEnh.ini" 구성 파일에 다음 내용을 추가한 후에 컴퓨터를 다시 시작하십시오:

[LibreOffice]

FC = "SALFRAME"

SF = 0x10000000

SF |= 0x00004000

구성 파일의 위치는 Windows 버전마다 다를 수 있습니다.

----------------------------------------------------------------------
단축키
----------------------------------------------------------------------

운영체제에서 사용하지 않는 단축키(키 조합)만 LibreOffice에서 사용하실 수 있습니다. LibreOffice에서 키 조합이 LibreOffice 도움말에 설명된 대로 작동하지 않는 경우, 이 키를 운영체제에서 이미 사용하고 있는지 확인해 보십시오. 단축키 충돌을 없애려면 운영체제에 지정한 키를 바꾸거나 LibreOffice에서 할당한 단축키를 변경하십시오. 이 주제에 대한 자세한 정보는 LibreOffice 도움말이나 운영체제의 도움말 문서를 참조하십시오.

----------------------------------------------------------------------
Problems When Sending Documents as Emails From LibreOffice
----------------------------------------------------------------------

When sending a document via 'File - Send - Document as Email' or 'Document as PDF Attachment' problems might occur (program crashes or hangs). This is due to the Windows system file "Mapi" (Messaging Application Programming Interface) which causes problems in some file versions. Unfortunately, the problem cannot be narrowed down to a certain version number. For more information visit https://www.microsoft.com to search the Microsoft Knowledge Base for "mapi dll".

----------------------------------------------------------------------
중요한 접근성 정보
----------------------------------------------------------------------

LibreOffice가 제공하는 접근성 향상 기능에 대한 보다 자세한 정보는 https://www.libreoffice.org/accessibility/를 참고하십시오.

----------------------------------------------------------------------
사용자 지원
----------------------------------------------------------------------

사용자 지원 페이지에서는 LibreOffice에 대한 다양한 도움을 제공합니다. 여러분이 묻고자 하는 것과 같은 질문과 그에 대한 답변이 이미 있을 지도 모릅니다 - https://www.documentfoundation.org/nabble/에 있는 커뮤니티 포럼을 확인하거나 https://www.libreoffice.org/lists/users/에서 'users@libreoffice.org' 메일링 리스트 저장소를 확인해 보십시오. 답변을 못찾은 경우에는 질문을 users@libreoffice.org로 보낼 수 있습니다. (답변을 받기 위해) 리스트를 구독하려면 빈 메일을 users+subscribe@libreoffice.org로 보내십시오.

또한 리브레오피스 웹사이트 FAQ 페이지를 살펴보십시오.

----------------------------------------------------------------------
버그와 이슈 보고하기
----------------------------------------------------------------------

Our system for reporting, tracking and solving bugs is currently Bugzilla, hosted at https://bugs.documentfoundation.org/. We encourage all users to feel entitled and welcome to report bugs that may arise on your particular platform. Energetic reporting of bugs is one of the most important contributions that the user community can make to the ongoing development and improvement of LibreOffice.

----------------------------------------------------------------------
참여하기
----------------------------------------------------------------------

이처럼 중요한 오픈소스 프로젝트의 개발에 여러분이 적극적으로 참여하는 것은 LibreOffice 커뮤니티에 큰 도움이 됩니다.

프로그램 사용자로써 여러분은 이미 개발 프로세스의 중요한 부분을 담당하고 있습니다. 하지만 이보다 더 많은 기여와 활발한 활동을 기대합니다. 관심있는 분은 리브레오피스 웹사이트를 참고하세요.

시작하기
----------------------------------------------------------------------

기여를 시작하는 가장 좋은 방법은, 하나 이상의 메일링 리스트를 구독하고 당분간 살펴보는 것입니다. 메일 저장소를 통하여 2000년 10월 LibreOffice 소스 코드가 공개된 이후에 다루어져 왔던 주제들에 대해서 점차 익숙해질 수 있습니다. 그런 다음 자기 소개를 담은 이메일을 보내고 참여를 시작하면 됩니다. 여러분이 오픈소스 프로젝트에 익숙하다면 리브레오피스 웹사이트에서 할 일 목록을 살펴보고 돕고 싶은 일이 있는지 알아봅니다.

구독
----------------------------------------------------------------------

https://ko.libreoffice.org/get-help/mailing-lists/에 여러분이 구독할 수 있는 메일링 리스트가 있습니다.

* 뉴스: announce@documentfoundation.org *모든 사용자에게 권장* (메일 수 적음)
* 사용자 리스트: users@global.libreoffice.org *토론 참여 쉬움* (메일 수 많음)
* 홍보 프로젝트: marketing@global.libreoffice.org *비개발 분야* (메일 수 중간)
* 일반 개발자 리스트: libreoffice@lists.freedesktop.org (메일 수 많음)

하나 이상의 프로젝트에 참여하기
----------------------------------------------------------------------

여러분이 소프트웨어 설계나 코딩 경험이 없다고 하더라도 이 중요한 오픈소스 프로젝트에 주요한 기여를 할 수 있습니다. 네, 여러분이 할 수 있습니다!

우리는 여러분이 LibreOffice 7.5을 위해 일하는 것을 즐기기 바라며 온라인으로 함께 참여하기를 희망합니다.

리브레오피스 커뮤니티

----------------------------------------------------------------------
사용된 / 수정된 소스 코드
----------------------------------------------------------------------

Portions Copyright 1998, 1999 James Clark. Portions Copyright 1996, 1998 Netscape Communications Corporation.
