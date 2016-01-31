use strict; 
use warnings;
use 5.20.0;
### Custom ###
use GenerateCitizen;
use GenerateAllegiance;
use EventGenerator;
use GameState;
use experimental 'smartmatch';

### Imports ###
use Data::Dumper;
use Moose::Util::TypeConstraints;
use Log::Log4perl;

Log::Log4perl::init_and_watch('log4perl.conf',10);
my $logger = Log::Log4perl->get_logger('soad');

$logger->debug("Seed is: " . srand());

my $game_state = GameState->new();
my $citizen_generator = GenerateCitizen->new(number_of_citizens => 50);
my $allegiance_generator = GenerateAllegiance->new();

$citizen_generator->setup($game_state);
$allegiance_generator->setup($game_state);

$game_state->add_player();


my $event_generator = EventGenerator->new();
$event_generator->update_game_state($game_state);
$event_generator->update_game_state($game_state);
$event_generator->update_game_state($game_state);

my @double_agents = grep { scalar(@{$_->allegiances}) > 1} @{$game_state->get_citizens()};
print Dumper(@double_agents);

#my $citizens = $game_state->get_citizens();
#my $diplomat = $citizens->[0];
#my $diplomat2 = $citizens->[1];
#my $event_id = $game_state->add_event('Informal dinner',[$diplomat,$diplomat2]);
