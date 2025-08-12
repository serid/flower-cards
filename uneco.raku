use MIME::Base64;

my $url = get;

my $encoded = $url ~~ / 'ss://' (.+?) '@' /;
my $decoded = MIME::Base64.decode-str($encoded[0].Str);
my ($method, $password) = $decoded.split(':');

my $ip = $url ~~ / '@' (.+?) ':' /;

say "Password: $password";
say "IP: {$ip[0].Str}";
