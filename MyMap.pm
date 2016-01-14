unit module MyLinkedHashMap;

# useしたときにデフォルトで読み込ませる場合はis exportをつける
class MyMap is export {
  # publicは$.var privateは$!var
  has Str $!key;
  has Str $!val;
  
  multi submethod BUILD(:k(:$key), :v($val)) {
    $!key  :=  $key;
    $!val  :=  $val;
  }
  multi submethod BUILD() { }
  
  method kv() {
    return $!key,$!val;
  }
  
  method key() {
    return $!key;
  }
  
  method val() {
    return $!val;
  }

}
