# FAQコンテナ　作成手順

Ubuntu20.04にFAQコンテナを作成する手順を説明します。

>iris.keyと証明書ファイルはリポジトリにUpしていません。cloneした後指定の場所に配置してから起動してください。

## 流れ

リポジトリからcloneしたディレクトリにある[docker-composex.yml](/docker-compose.yml)を使ってコンテナをビルド＆開始します。

コンテナはDurable%SYSを利用しているため、一旦コンテナビルド＋開始の状態を作った後で、初期設定（FAQ用ネームスペース設定、メモリの設定などの初期設定）を流す必要があります。

> Durable %SYSの設定で作ったディレクトリがコンテナビルド時には有効とならないため、ビルド後コンテナを開始してから各種設定を行う必要があります。

コンテナ初回ビルドと開始＋初期設定が終わってから、コードとデータの更新をして、FAQ用コンテナが完成します。

## 事前準備

- Ubuntu20.04インストール
- Dockerインストール
    > 参考URL:https://qiita.com/nanbuwks/items/0ba1d13b3cd27e5c6426
- docker-compose インストール
- git のインストール（プレインストールされていればそれで）
- git clone このリポジトリ

    ```
    cd /usr
    sudo git clone <このリポジトリ>
    ```
- 証明書ファイル一式

    server.keyとserver.crtの名称で、[web](/web/)以下に配置します。

    ※コンテナビルド＆開始前に配置できると後からコピーが不要なので簡単です

- IRISイメージをdocker load しておく
    ```
    sudo docker load < iris-2023.1.0.229.0-docker.tar.gz
    ```
- iris.keyを準備
    [faq/source](./faq/source/)以下に配置しておきます（コンテナ用キー）

- コードとデータ更新用に使うディレクトリを準備

    ```
    sudo mkdir -p /usr/FAQsetup/Global/FAQ
    ```
    後は、/usr/FAQsetup/Global/FAQ 以下にソース一式を（[https://github.com/Intersystems-jp/isjfaq/tree/master/FAQ](https://github.com/Intersystems-jp/isjfaq/tree/master/FAQ)）配置する(FAQ.incも忘れずに配置すること)

- KB.Setup.cls　が古い
https://github.com/Intersystems-jp/isjfaq/blob/e3d403bdcb9ca6c53a5d20d20f2261cb3e25a71c/FAQ/KB/Setup.cls#L45

以下の設定にならないといけない

    ```
    1: 	^Techinfo("AttachedFileName")	=	"Attached"
    2: 	^Techinfo("AuthenticationMethods")	=	64
    3: 	^Techinfo("CSPDirectory")	=	"/opt/config/iris/csp/faq/"
    4: 	^Techinfo("CSPUrl")	=	"/csp/faq"
    5: 	^Techinfo("ClassFileDir")	=	"FAQ"
    6: 	^Techinfo("DirectorySeparator")	=	"/"
    7: 	^Techinfo("ErrorPage")	=	"/csp/faq/FAQ.FAQError.cls"
    8: 	^Techinfo("FTPDirectory")	=	"/opt/config/iris/csp/faq/downloads"
    9: 	^Techinfo("GlobalFileName")	=	"TopicD.xml"
    10: 	^Techinfo("MailSender")	=	"jpnsup@intersystems.com"
    11: 	^Techinfo("Namespace")	=	"FAQ"
    12: 	^Techinfo("SMTPServer")	=	"xxx.intersystems.com"
    13: 	^Techinfo("SetupDirectory")	=	"/usr/FAQsetup"
    14: 	^Techinfo("StartYear")	=	2003
    ```


## 1. コンテナビルド＆開始

コマンド実行などは、FAQContainerディレクトリ（/usr/FAQContainer）に移動した状態で行います。

1. Durable %SYSのディレクトリを用意と、Apacheコンテナ内で使用するshのPermission変更のため、以下シェルを実行します。
    
    ※初回のみ実行

    ```
    sudo ./setup.sh
    ```
2. コンテナをビルドします

    ```
    sudo docker-compose build
    ```

3. コンテナを開始します。

    ```
    sudo docker-compose up -d
    ```

ここまでの手順では、まだApacheとIRISは接続できません。

>　この後の初期設定の中で行う、CSPSystemユーザのパスワード変更ができていないため

ここまでの流れが正しく完成していると、https://IPアドレス にアクセスできます。

> web/index.html　をcloneした状態で利用するとリダイレクトしてFAQトップに移動します。

## 2. 初期実行

ネームスペース、データベースの作成などの初期実行を行うため、IRISにログインし、以下Installerクラスを実行します。

```
sudo docker exec -it faq-iris bash
iris session iris -U %SYS
do ##class(ZFAQSetup.Installer).setup()
```

## 3. コードとデータの更新

通常の更新方法で実行します。


```
sudo docker exec -it faq-iris bash
iris session IRIS -U FAQ
do ##class(FAQ.Installer).runInstaller("Global")
```

## 4. イメージファイル、添付ファイルの移動

imagesフォルダ一式、downloadsフォルダ一式を手動で以下にコピーする。

- images
    sudo copy -r imagesがあるディレクトリ /usr/FAQContainer/config/iris/csp/faq/images
- downloads
    sudo copy -r downloadsがあるディレクトリ /usr/FAQContainer/config/iris/csp/faq/downloads

    トピック19が添付があるので、19を開いて添付が見えてればOK

これで完成！
https://<ip>/csp/faq/FAQ.FAQTopicSearch2.cls　にアクセスできる予定

## イメージ更新《書きかけ：これではFATALエラーとなる》

IRISのコンテナにログインし、完全停止（iris stop iris）を行ってから、コンテナを破棄、イメージを削除してから、Dockerfileのイメージを書き換えてdocker-compose up -dしたらOK

```
sudo docker exec -it faq-iris bash

iris stop iris

exit

sudo docker-compose down

IRISコンテナのイメージ削除
sudo docker rmi 11d8383d1ccc

Dockerfile のイメージを新しいバージョンに変えて保存

sudo docker-compose up -d
```


