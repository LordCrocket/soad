use strict;
use warnings;
### Custom ###
use Information;
use Player;
use Citizen;
use GenerateCitizen;
use Event;

### Imports ###
use Data::Dumper;
use Moose::Util::TypeConstraints;
use Log::Log4perl;

Log::Log4perl::init_and_watch('log4perl.conf',10);

my $citizens = GenerateCitizen::generate_citizens(3);
my $diplomat = $citizens->[0];
my $diplomat2 = $citizens->[1];
my $agent = $citizens->[2];

my $information = Event->new( 
	type => 'event', 
	title => 'Informal dinner', 
	participants => [$diplomat,$diplomat2]);

my $player = Player->new(known_citizen => [$agent]);
$agent->learn($information);
$diplomat->learn($information);
$diplomat2->learn($information);


print Dumper($player);
