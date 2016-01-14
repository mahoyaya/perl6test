use lib '.';
use MyPerl6Module;
my $encode = "UTF-8";
my Str $str = "http://localhost:8888/testuri/test.html";

# これは名前付き指定にしていないのでエラーになる
# Default constructor for 'UrlModel' only takes named arguments
# コンストラクタが submethod BUILD(:url(:$real)) { になっているため
#my $poor = MyPerl6Module::UrlModel.new($str);

my $class = MyPerl6Module::UrlModel.new(url => $str);
$class.getReal().say;
if $class.defined {
  "これはインスタンスメソッドです。".say;
  "これはインスタンスメソッドです。".encode($encode).say;
} else {
  "これはクラスメソッドです。".say;
  "これはクラスメソッドです。".encode($encode).say;
}

# is exportされているのでネームスペース不要で呼び出せる
my $class2 = UrlModel.new(url => $str);
if $class2.defined {
  "これはインスタンスメソッドです。".say;
  "これはインスタンスメソッドです。".encode($encode).say;
} else {
  "これはクラスメソッドです。".say;
  "これはクラスメソッドです。".encode($encode).say;
}

# インスタンス化しないで呼び出す
if UrlModel.defined {
  "これはインスタンスメソッドです。".say;
  "これはインスタンスメソッドです。".encode($encode).say;
} else {
  "これはクラスメソッドです。".say;
  "これはクラスメソッドです。".encode($encode).say;
}

my $exception;
my Str $str3 = "http://localhost:8888a/testuri/test.html";
{
  # .throwでexceptionを受け取れる
  my $class3 = MyPerl6Module::UrlModel.new(url => $str3).throw;
  CATCH {
    default {
      $exception = $_;
    }
  }
}
if $exception {
  "this is parent exception".say;
  $exception.say;
}