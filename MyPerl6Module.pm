unit module MyPerl6Module;

# useしたときにデフォルトで読み込ませる場合はis exportをつける
class UrlModel is export {
  # publicは$.var privateは$!var
  has Str $!schema;
  has Str $!host;
  has Int $!port;
  has Str $!uri;
  has Str $!real;
  
  #has Str $!test = self.$!real eq 'http:' ?? 'schema is http' !! 'schema is https';

  # コンストラクタはsubmethod BUILD
  # submethod は継承されない
  # 引数指定を :url(:$real)などとするとurl => "hoge" と指定させることが出来る
  submethod BUILD(:url(:$real)) {
    $!real  :=  $real;
    self.parse($!real);
  }

  method parse(Str $data) {
    ($!schema, my $tmp, $!host, $!uri) = $data.split('/',4,:skip-empty);
    $!host.say;
    
    if $!host ~~ /\:/ {
      ($!host, my Str $port_str) = $!host.split(':',:skip-empty);
      
      # tray-catch start
      my $exception;
      {
        $!port = $port_str.Int;
        # die するとexceptionに飛ぶ
        # Perl5みたいに終了はしない
        if $!port < 1 || $!port > 65535  { die "invalid port number. it is between 1 to 65535"; }
        CATCH {
          default {
            $exception = $_;
          }
        }
      }
      if $exception {
        #"this is module exception".say;
        # dieで呼び出し元にthrowする
        die $exception;
        # これ以降は実行されない
        "after exception at MyPerl6Module.pm".say;
      }
      # try-catch end
    }
    
  }
  
  method !privateMethod() {
    'this is private method.'.say;
  }
  
  method getUrl() {
    return $!schema ~ '//' ~ $!host ~ '/' ~ $!uri;
  }
  
  method getReal() {
    return $!real;
  }
  
  method getBuildUrl {
    return $!schema ~ '//' ~ $!host ~ ':' ~ Str($!port) ~ '/' ~ $!uri;
  }
  
  method getSchema() {
    return $!schema;
  }

  method getHost() {
    return $!host;
  }

  method getPort() {
    return $!port;
  }

  method getUri() {
    return $!uri;
  }
}
