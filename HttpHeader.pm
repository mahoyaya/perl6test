unit module HttpHeader;
use lib '.';
use MyMap;

# useしたときにデフォルトで読み込ませる場合はis exportをつける
class Header is export {
  # publicは$.var privateは$!var
  has Str $!ua = 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3';
  has Str $!xff = '';
  has Str $!host = 'localhost';
  has Str $!conn = 'close';
  has Str $!accept = 'image/gif, image/jpeg, */*';
  has Str $!ae = 'gzip, deflate';
  has Str $!cookie = '';
  
  # コンストラクタはnewだが、BUILDでも初期化できる
  # ただしBUILDは引数が必須
  # submethod は継承されない
  # 引数指定を :url(:$real)などとするとurl => "hoge" と指定させることが出来る
  multi submethod BUILD(:x-forwarded-for(:$xff)) {
    $!xff  :=  $xff;
  }
  
  method get() {
    my MyMap @headers;
    @headers.push(MyMap.new(k=>'User-Agent', v=>$!ua));
    if $!xff.chars > 0 { @headers.push(MyMap.new(k=>'X-Forwarded-For', v=>$!xff)); }
    @headers.push(MyMap.new(k=>'Host', v=>$!host));
    @headers.push(MyMap.new(k=>'Accept', v=>$!accept));
    @headers.push(MyMap.new(k=>'Accept-Encoding', v=>$!ae));
    if $!cookie.chars > 0 { @headers.push(MyMap.new(k=>'Cookie', v=>$!cookie)); }
    @headers.push(MyMap.new(k=>'Connection', v=>$!conn));
    return @headers;
  }
  
  method setUserAgent(Str $ua) {
    $!ua = $ua;
  }
  
  method setXForwardedFor(Str $xff) {
    $!xff = $xff;
  }
  
  method setHost(Str $host) {
    $!host = $host;
  }
  
  method setAccept(Str $accept) {
    $!accept = $accept;
  }
  
  method setAcceptEncoding(Str $ae) {
    $!ae = $ae;
  }
  
  method setCookie(Str $cookie) {
    $!cookie = $cookie;
  }
  
  method getCookie() {
    return $!cookie;
  }
}
