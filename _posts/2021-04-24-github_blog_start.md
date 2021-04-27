---
layout: archive
title:  "github 블로그 시작하기"
date:   2021-04-24 18:46:07 +0900
categories: summary
sidebar:
  nav: "posts_navi"
---

깃헙 블로그를 시작하면서 개발장비에서 로컬 개발환경을 구성하고, 깃허브에 업로드하여 접속하는 단계까지 진행합니다.

### prerequisites

- RVM 및 ruby
- github 계정
- github.io 페이지



## Step

### 0. RVM install

```
$ curl -sSL https://get.rvm.io | bash
...
$ rvm list
$ rvm install 2.7.1
$ rvm list
$ rvm alias create default 2.7.1
```



### 1. Install jekyll, bundler

웹 사이트를 생성해주는 툴 jekyll과 루비 gem 패키지 버전 관리 툴을 다운받습니다.

```
$ gem install jekyll
$ gem install bundler
```



### 2. create blog home

jekyll로 사이트를 생성합니다. 커맨드는 `jekyll new <PATH>` 입니다

```
블로그 홈으로 사용할 폴더를 생성
$ mkdir -p $BLOG_HOME
$ cd $BLOG_HOME
$ jekyll new .
$ bundle install
```



### 3. Run server in local

개발환경에서 접속할 수 있습니다

```
$ bundle exec jekyll serve --host 0.0.0.0 --port 8080
웹에서 접속.
```





### 4 테마 적용하기

테마는 [깃헙에서 제공해주는 테마](https://pages.github.com/themes/)와 개인 사용자가 만든 커스텀 테마 2종류가 있습니다.    

깃헙에서 제공해주는 테마는 특별한 설정 없이 _config.yml 파일에 theme: 만 명시하여 사용할 수 있어 간편하게  사용할 수 있으며, 커스텀 테마는 추가 설정을 해주어 더 좋은 퀄리트의 테마를 사용할 수 있습니다.

`jekyll new-theme <THEME-NAME>` 커맨드로 테마별로 샘플 사이트를 생성할 수 있습니다



#### 커스텀 Theme 리스트들

1. [GitHub.com #jekyll-theme repos](https://github.com/topics/jekyll-theme)

2. [jamstackthemes.dev](https://jamstackthemes.dev/ssg/jekyll/)

3. [jekyllthemes.org](http://jekyllthemes.org/)

4. [jekyllthemes.io](https://jekyllthemes.io/)

5. [jekyll-themes.com](https://jekyll-themes.com/)

6. [Resource](https://jekyllrb.com/resources/)



예제는 커스텀 테마인 Minimal mistakes theme를 사용하여 진행하겠습니다.

### Minimal mistakes theme

[Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/) , [github](https://github.com/mmistakes/minimal-mistakes)

가장 많이 사용된다고 하여 Minimal Mistakes 를 선택하였습니다. 문서도 잘 되어있습니다.



#### 1. github fork

[minimal-mistakes](https://github.com/mmistakes/minimal-mistakes) 깃허브로 가서 저장소를 fork 받습니다. 

#### 2. _config.yml 복사

minimal-mistakes 깃허브의 _config.yml내용을 복사하여 Step에서 진행해온 내 사이트의 _config.yml에 붙여넣습니다. 또한 remote_theme 컬럼을 fork받은 깃허브 저장소로 변경해줍니다.

```
remote_theme             : "<깃허브아이디>/minimal-mistakes"
```

 #### 3.  push

변경된 내용을 저장소에 push를 합니다.

```
$ git add .
$ git commit -m "commit"
$ git push
```

#### 4. 사이트 확인

브라우저에 http://<깃허브아이디>.github.io로 접속하여 사이트 화면을 확인할 수 있습니다.


### Navigation 등록하기

블로그의 최상단에 nav 를 추가합니다.

#### 1. 사이트 상단의 nav 목록 추가

/_data/navigation.yml 에 `main:` 에 아래 포맷에 맞춰 추가합니다.

title : 표시되는 문구입니다.
url : 클릭시 이동하는 url입니다.

``` yml
main:
  - title: "About"
    url: /About/
  - title: "Posts"
    url: /Posts/
```


### 2. 사이트 왼쪽 옆에 nav 목록 추가

/_data/navigation.yml 에 `이름:` 으로 아래 포맷에 맞춰 추가합니다.

``` yml
posts_navi:
  - title: Development
    children:
      - title: "C/C++"
        url: /Development/C,C++/
      - title: "Go"
        url: /Development/Go/
      - title: "Python"
        url: /Development/Python/
  - title: ...
```



## Reference

도움이 된 사이트입니다.

https://hahafamilia.github.io/howto/jekyll-github-mistakes-blog/

https://jekyllrb.com/

https://junhobaik.github.io/jekyll-apply-theme/#%EB%8C%93%EA%B8%80-%EC%84%A4%EC%A0%95   

https://ansohxxn.github.io/blog/jekyll-directory-structure/