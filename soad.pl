use strict; 
use warnings;
use 5.20.0;
### Custom ###
use GenerateCitizen;
use GenerateAllegiance;
use AgentChoice;
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
my $agent_choice = AgentChoice->new();

$game_state->add_player();
$game_state->add_player();

$citizen_generator->setup($game_state);
$allegiance_generator->setup($game_state);
$agent_choice->setup($game_state);



my $event_generator = EventGenerator->new();
$event_generator->update_game_state($game_state);
$event_generator->update_game_state($game_state);
$event_generator->update_game_state($game_state);

my $player = $game_state->get_players()->[0];


my $citizen = $game_state->get_citizens()->[0];
my $citizen2 = $game_state->get_citizens()->[1];
$game_state->add_known_citizen($player,$citizen);
$player = $game_state->get_players()->[0];
my $choice = $player->choices->[0];
my $player2 = $game_state->get_players()->[0];
$player2->add_known_citizen($citizen2);
$game_state->add_known_citizen($player2,$citizen2);
#say scalar @{$option->get_options()};
$choice->make_choice($citizen);


#print Dumper($option);
#print Dumper($ref2->($player));
#$ref->($player,$game_state->get_citizens()->[0]);


print Dumper($game_state->get_players()->[0]->agent->name);



#my @double_agents = grep { scalar(@{$_->allegiances}) > 1} @{$game_state->get_citizens()};
#print Dumper(@double_agents);

#my $citizens = $game_state->get_citizens();
#my $diplomat = $citizens->[0];
#my $diplomat2 = $citizens->[1];
#my $event_id = $game_state->add_event('Informal dinner',[$diplomat,$diplomat2]);
