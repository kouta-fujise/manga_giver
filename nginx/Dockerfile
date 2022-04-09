FROM nginx:stable
#デフォルトのnginxファイルを削除して作成したものコンテナ内にコピー
RUN rm -f /etc/nginx/conf.d/*

COPY nginx.conf /etc/nginx/conf.d/myproject.conf

#-c以降の設定ファイルを指定して起動 daemon offでフォアグラウンドで起動
CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
