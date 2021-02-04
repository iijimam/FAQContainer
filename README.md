## Apacheのログを取得する方法 ##
/usr/local/apache2/logs/access_log　は存在しないので、ホストからとる

```
docker logs faq-web 
```
これだと過去ログ全部出てしまうので、期間指定できる。
参考：https://www.memotansu.jp/docker/750/

以下、指定日時以降をとる（指定時間、日程以前もある --until）
```
docker logs --since "2021-02-03T15:00:00Z" faq-web
```

以下補足：コンテナなので、httpd.confの設定がホストのApacheと違う。
```
# ErrorLog: The location of the error log file.
# If you do not specify an ErrorLog directive within a <VirtualHost>
# container, error messages relating to that virtual host will be
# logged here.  If you *do* define an error logfile for a <VirtualHost>
# container, that host's errors will be logged there and not here.
#
ErrorLog /proc/self/fd/2

#
# LogLevel: Control the number of messages logged to the error_log.
# Possible values include: debug, info, notice, warn, error, crit,
# alert, emerg.
#
LogLevel warn

<IfModule log_config_module>
    #
    # The following directives define some format nicknames for use with
    # a CustomLog directive (see below).
    #
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common

    <IfModule logio_module>
      # You need to enable mod_logio.c to use %I and %O
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>

    #
    # The location and format of the access logfile (Common Logfile Format).
    # If you do not define any access logfiles within a <VirtualHost>
    # container, they will be logged here.  Contrariwise, if you *do*
    # define per-<VirtualHost> access logfiles, transactions will be
    # logged therein and *not* in this file.
    #
    CustomLog /proc/self/fd/1 common

    #
    # If you prefer a logfile with access, agent, and referer information
    # (Combined Logfile Format) you can use the following directive.
    #
    #CustomLog "logs/access_log" combined
</IfModule>
```

ログは以下にある
```
root@apacheforfaq:/usr/local/apache2/logs# ls /proc/self/fd -l
total 0
lrwx------ 1 root root 64 Feb  3 05:26 0 -> /dev/pts/0
lrwx------ 1 root root 64 Feb  3 05:26 1 -> /dev/pts/0
lrwx------ 1 root root 64 Feb  3 05:26 2 -> /dev/pts/0
lr-x------ 1 root root 64 Feb  3 05:26 3 -> /proc/338/fd
 
root@apacheforfaq:/usr/local/apache2/logs# ls -l /dev/pts/0
crw--w---- 1 root tty 136, 0 Feb  3 05:27 /dev/pts/0
```

***


## 変更履歴 ##

- 2021/2/4 Installer.cls
    /csp/user と /csp/documatic　を無効化するメソッドを追記（DisabledURL()）

- 2021/2/4 FAQコンテナ化手順.docx
    Installer.clsの処理追加分の追記（P17　⑨を追加）
