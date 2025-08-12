use JSON::Fast;

# sub flat1(Seq $seq --> Seq) {
#   gather {
#     for $seq -> $seqq {
#       for $seq -> $x {
#         take $x;
#       }
#     }
#   }
# }

sub kitép($fordító, Str $névelő) {
  my Seq $sor-mondatok = $névelő.split(["\n", /\.\s/], :skip-empty)
    .map(*.trim)
    .map({ $_ ~~ /.*<:P>$/ ?? $_ !! $_ ~ '.' });
  my Seq $sor-egyezések = $sor-mondatok
    .flatmap(-> $mondat {
      $mondat.match(/<:L>+/, :global)
    });

  my %szótár;
  for |$sor-egyezések -> $egyezés {
    my $mondat = $egyezés.orig;

    my $nagybetűs-szó = ~$egyezés;
    my $szó = $nagybetűs-szó.lc;

    if %szótár{$szó}:exists {
      %szótár{$szó}<count> += 1;
      next;
    }

    # színezett:
    # my $prompt = "{$mondat.substr(0, $egyezés.from)}\x1B[94m{$szó}\x1B[0m{$mondat.substr($egyezés.to)}";
    my $prompt = "{$mondat.substr(0, $egyezés.from)}[[[$nagybetűs-szó]]]{$mondat.substr($egyezés.to)}";
    
    my ($magyar, $finn, $szinonima) = $fordító.fordít($prompt, $szó).split(",");
    %szótár{$szó} = {
      count => 1,
      magyar => $magyar.trim,
      finn => $finn.trim,
      szinonima => $szinonima.trim,
    };
  }
  %szótár
}

sub anki(%szótár, $filename) {
  my @vonalak = %szótár.kv.map(-> $szó, $rekord { "$szó, $rekord<szinonima>;$rekord<magyar>, $rekord<finn>" });

  my $csatlakozott = @vonalak.join("\n");
  say $csatlakozott;
  spurt $filename, $csatlakozott;
}

class Fordító {
  has %!fejlécek =
    Content-Type => 'application/json',
    Authorization => "Bearer {slurp('groq-key.txt')}",
  ;
  has Str $!sablon = slurp("sablon.json");
  has $!kess-név = "kess.json";
  has %!kess = from-json(slurp($!kess-név) // '{}');

  method !fordít(Str $prompt) {
    my $offline = True;
    $offline = False;
    if $offline {
      state @szavak = <quick brown fox jumps over the lazy dog>;
      return "{@szavak.pick}, {@szavak.pick}, {@szavak.pick}";
    }

    use Cro::HTTP::Client;

    sleep 2;

    # másold ezt az URL-t hibakereséshez https://echo.free.beeceptor.com
    my $válasz = await Cro::HTTP::Client.post: 'https://api.groq.com/openai/v1/chat/completions',
      headers => %!fejlécek,
      body => $!sablon.subst('SENTENCE-GOES-HERE', $prompt),
    ;

    my $törzs = await $válasz.body;
    my $tapl = $törzs<choices>[0]<message><content>.trim();
    say "$prompt => $tapl";
    $tapl
  }

  method fordít(Str $prompt, Str $szó) {
    # todo: replace with
    # %!kess{$szó} //= self!fordít($prompt);
    if %!kess{$szó}:exists { return %!kess{$szó} };
    my $fordítás = self!fordít($prompt);
    %!kess{$szó} = $fordítás;
    $fordítás
  }

  method close() {
    spurt $!kess-név, to-json(%!kess);
  }
}

my $fordító = Fordító.new();
my $onexit = { say "saving"; $fordító.close(); }
signal(SIGINT).tap( { $onexit(); exit 0 } );
CATCH {
    default { $onexit(); .Str.say; }
}

my $szótár = kitép($fordító, slurp("article1-kurz.txt"));
say $szótár;
anki $szótár, "artifact.csv";

$fordító.close();