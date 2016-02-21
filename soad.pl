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
use GameModule::DoubleAgentGuess;
use GameState;
use experimental 'smartmatch';

### Imports ###
use Data::Dumper;
use Moose::Util::TypeConstraints;
use Log::Log4perl;
use List::Util qw(first);

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
my $double_agent_guess = GameModule::DoubleAgentGuess->new();

$game_state->add_game_module($citizen_generator);
$game_state->add_game_module($allegiance_generator);
$game_state->add_game_module($information_learn);
$game_state->add_game_module($citizen_learn);
$game_state->add_game_module($agent_choice);
$game_state->add_game_module($event_generator);
$game_state->add_game_module($double_agent_guess);

$game_state->add_player();
$game_state->add_player();


$game_state->setup();
$game_state->tick();
$game_state->tick();
$game_state->tick();



my $player = $game_state->get_players()->[0];
my $double_agent = first { scalar(@{$_->allegiances}) > 1} @{$game_state->get_citizens()};

$game_state->add_known_citizen($player,$double_agent);


my $choice = $player->choices->[0];
my $choice2 = $player->choices->[1];

$choice2->make_choice($double_agent);
