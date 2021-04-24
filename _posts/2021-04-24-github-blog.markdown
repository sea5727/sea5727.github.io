---
layout: posts
title:  "github 블로그 시작하기"
date:   2021-04-24 17:59:41 +0900
categories: common blog
---

깃허브 블로그를 시작는 과정과 개발장비에서 로컬 개발환경을 구성, 마지막 깃허브에 업로드하여 접속하는 단계까지 진행한 내용을 정리하였습니다.

### prerequisites

- RVM 및 ruby
- github 계정
- github.io 페이지


## Step

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

`jekyll new-theme <THEME-NAME>` 커맨드로 테마별로 기본 사이트를 생성할 수 있습니다



### 커스텀 Theme 리스트

1. [GitHub.com #jekyll-theme repos](https://github.com/topics/jekyll-theme)
2. [jamstackthemes.dev](https://jamstackthemes.dev/ssg/jekyll/)
3. [jekyllthemes.org](http://jekyllthemes.org/)
4. [jekyllthemes.io](https://jekyllthemes.io/)
5. [jekyll-themes.com](https://jekyll-themes.com/)
6. [Resource](https://jekyllrb.com/resources/)



예제는 Minimal mistakes theme를 사용하여 진행하겠습니다.

### Minimal mistakes theme

[Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/) , [github](https://github.com/mmistakes/minimal-mistakes)

가장 많이 사용된다고 하여 Minimal Mistakes 를 선택하였습니다. 문서도 잘 되어 있는것같네요

이 테마는 Gem-based theme로도, remote theme로도 사용이 가능합니다 

### Gem-based themes 란?

jekyll new <PATH> 커맨드로 Jekyll 사이트를 생성하면 기본적으로 Minima 테마의 gem-based 타입으로 생성됩니다. gem-based 의 경우 assets, _layouts, _includes, _sass 폴더가 gem에 저장되며 실제 폴더는 숨겨집니다. 이들은 Jekyll을 빌드하고 실행할 때 처리가 될것입니다.

즉, github에 업로드하지 않고 서버나 데스크탑에 설치형식으로 운영하는경우 사용하면 되는걸로 보이네요.



아래는 기본 생성한 테마(Minima)의 경우 폴더 구조입니다.

```
ysh8361@DEV0:~/workspace/sea5727.github.io$ tree
.
├── 404.html
├── about.markdown
├── index.markdown
├── _config.yml
├── Gemfile
├── Gemfile.lock
├── _posts
│   └── 2021-04-23-welcome-to-jekyll.markdown
```

`Gemfile` , `Gemfile.lock` 은 Jekyll 사이트를 구축하는데 필요한 gem들과 gem 버전들을 명시합니다. Gemfile에 명시된 gem들은 `gem update`로 모두 업데이트 할 수 있습니다. Gem-based 테마는 `gem`이나 gem theme를 `Gemfile` 에 명시하여 `bundle update` 로 개발자가 쉽게 업데이트하며 사용할 수 있습니다. 또는 `bundle update <THEME>`로 새로운 theme 버전을 프로젝트에 자동으로 업데이트 받을 수 있습니다. 



### Gem-based method 사용하기

1. Gemfile 에 추가

```
vim Gemfile
... 가장 위에 추가
gem "minimals-mistakes-jekyll"
```

2. bundle 업데이트

```
$ bundle
```

3. _config.yml 파일에 theme 추가

```
vim _config.yml
... theme에 추가
theme: minimal-mistakes-jekyll
```

4. 업데이트 run

```
bundle update
```



### Remote theme method

Remote theme method 란 Gem-based 방식과 비슷하지만 `Gemfile`을 변경할 필요가 없으며, github 사이트에서 호스팅되는 방식에 이상적입니다



### Remote theme method 사용하기

1. 

