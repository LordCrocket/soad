use strict; 
use warnings;
use 5.20.0;
### Custom ###
use GameModule::GenerateCitizen;
use GameModule::GenerateAllegiance;
use GameModule::Agent;
use GameModule::LearnCitizen;
use GameModule::LearnInformation;
use GameModule::EventGenerator;
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
my $citizen_generator = GameModule::GenerateCitizen->new(number_of_citizens => 13);
my $allegiance_generator = GameModule::GenerateAllegiance->new();
my $information_learn = GameModule::LearnInformation->new();
my $citizen_learn = GameModule::LearnCitizen->new();
my $agent_choice = GameModule::Agent->new();
my $event_generator = GameModule::EventGenerator->new();

$game_state->add_game_module($citizen_generator);
$game_state->add_game_module($allegiance_generator);
$game_state->add_game_module($information_learn);
$game_state->add_game_module($citizen_learn);
$game_state->add_game_module($agent_choice);
$game_state->add_game_module($event_generator);

$game_state->add_player();
$game_state->add_player();


$game_state->setup();
$game_state->tick();
$game_state->tick();
$game_state->tick();


my $player = $game_state->get_players()->[0];


my $citizen = $game_state->get_citizens()->[0];
my $citizen2 = $game_state->get_citizens()->[1];

$game_state->add_known_citizen($player,$citizen);
$game_state->add_known_citizen($player,$citizen2);

$player = $game_state->get_players()->[0];
$game_state->set_as_winner($player);

my $choice = $player->choices->[0];

my $player2 = $game_state->get_players()->[0];
$player2->add_known_citizen($citizen2);
$game_state->add_known_citizen($player2,$citizen2);
#say scalar @{$option->get_options()};



#print Dumper($option);
#print Dumper($ref2->($player));
#$ref->($player,$game_state->get_citizens()->[0]);


$choice->make_choice($citizen);
$choice->make_choice($citizen2);



#my @double_agents = grep { scalar(@{$_->allegiances}) > 1} @{$game_state->get_citizens()};
#print Dumper(@double_agents);

#my $citizens = $game_state->get_citizens();
#my $diplomat = $citizens->[0];
#my $diplomat2 = $citizens->[1];
#my $event_id = $game_state->add_event('Informal dinner',[$diplomat,$diplomat2]);
