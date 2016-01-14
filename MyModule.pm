unit module MyModule;

# デフォルトで読み込ませる場合はis exportをつける
class UrlModel is export {
#class MyModule::UrlModel {
  # publicは$.var privateは$!var
  has Str $!schema;
  has Str $!host;
  has Int $!port;
  has Str @!uri;
  has Str $!real;
  
  #has Str $!test = self.$!real eq 'http:' ?? 'schema is http' !! 'schema is https';

  # コンストラクターはsubmethod BUILD
  # submethod は継承されない
  submethod BUILD(:url(:$real)) {
    $!real  :=  $real;
  }

  method !privateMethod() {
    'this is private method.'.say;
  }
  
  method getUrl() {
    #return $!schema ~ '//' ~ $!host ~ '/' ~ $!uri[0];
  }
  
  method getReal() {
    return $!real;
  }
  
  method getRealUrl() {
    #return $!schema ~ '//' ~ $!host ~ ':' ~ Str($!port) ~ '/' ~ $!uri[0];
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
    #return $!uri;
  }
}
