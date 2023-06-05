# WebGatewayコンテナ版への変更

WebGatewayコンテナ版（2023.1.0）への変更で修正したファイルは以下の通り。

- Dockerfile

    WebGateway用イメージを使用するように修正したファイルに変更

    CSP.iniの中身をコンテナビルド時に追記してる（[./webgwfiles/CSP.ini](./webgwfiles/CSP.ini)を使用)

    - 書き換え方

        [Dockerfile-WGContainer](/web/Dockerfile-WGContainer) の中身をDockerfileにコピーして保存します。

        > [Dockerfile-preWGContainer](/web/Dockerfile-prevWGContainer)は、現在使用中FAQコンテナで使用しているWebGateway用コンテナ作成元。念のため保管


- /web/webgwfiles/webgateway.conf

    以下FAQをそのまま使用（元ファイルと1か所除きほぼ一緒）：元は`web/webgateway.conf`を使用

    https://faq.intersystems.co.jp/csp/faq/result.csp?DocNo=593

    > CSPConfigPath "/opt/webgateway/bin/" がなくて動かなったので、FAQトピックのそのまま使用

- 未使用になるファイル

    - [WebGateway-2020.3.0.221.0-lnxubuntux64.tar.gz](/web/WebGateway-2020.3.0.221.0-lnxubuntux64.tar.gz)
    - [webgateway-entrypoint.sh](/web/webgateway-entrypoint.sh)
    - [webgateway.conf](/web/webgateway.conf)



