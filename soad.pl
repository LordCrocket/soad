use strict; 
use warnings;
use 5.20.0;
### Custom ###
use Information;
use Player;
use Citizen;
use GenerateCitizen;
use Event;
use GameState;
use experimental 'smartmatch';

### Imports ###
use Data::Dumper;
use Moose::Util::TypeConstraints;
use Log::Log4perl;

Log::Log4perl::init_and_watch('log4perl.conf',10);
my $logger = Log::Log4perl->get_logger('soad');

$logger->debug("Seed is: " . srand());

my $citizens = GenerateCitizen::generate_citizens(3);
my $diplomat = $citizens->[0];
my $diplomat2 = $citizens->[1];
my $agent = $citizens->[2];

my $game_state = GameState->new();

my $information = Event->new( 
	title => 'Informal dinner', 
	participants => [$diplomat,$diplomat2]);
my $information2 = Event->new( 
	title => 'Meeting at hotel', 
	participants => [$diplomat,$diplomat2]);

my $player = Player->new();

$game_state->add_player($player);

$game_state->add_citizen($agent);
$game_state->add_citizen($diplomat);
$game_state->add_citizen($diplomat2);

$game_state->add_information($information);

$game_state->learn($agent,$information);
$game_state->learn($diplomat,$information);
$game_state->learn($diplomat2,$information);



