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
use String::Numeric qw(is_int);

Log::Log4perl::init_and_watch('log4perl.conf',10);
my $logger = Log::Log4perl->get_logger('soad');


sub get_user_input {
	(my $min,my $max) = @_;
	print "Make choice: ";
	my $input = <STDIN>;
	chomp $input;
	return unless is_int($input);
	return unless int($input) >= $min;
	return unless int($input) <= $max;
	return $input;
}

sub list_choices {
	say "1. Pick agent";
	say "2. Guess double agent";
}

sub list_citizens {
	(my $text,my $citizens) = @_;
	say "";
	say "$text:";
	while((my $pos, my $citizen) = each @{$citizens}){
		say "$pos: $citizen";
	}
	say "";
	say "===============";
}
sub list_known_information {
	(my $player) = @_;
	say "";
	say "Known information:";
	foreach my $information (@{$player->known_information()}){
		say $information;
	}
	say "===============";
	say "";
}
sub pick_agent {
	(my $game_state, my $player) = @_;
	(my $agent_choice) = @{$player->choices};
	my $known_citizens = $agent_choice->get_options();
	list_citizens($agent_choice->description,$known_citizens);
	my $choice = get_user_input(0,scalar @{$known_citizens} - 1);
	return unless defined $choice;
	my $agent = $known_citizens->[$choice];
	$agent_choice->make_choice($agent);
}

sub guess_double_agent {
	(my $game_state, my $player) = @_;
	my $agent_choice = $player->choices->[1];
	my $known_citizens = $agent_choice->get_options();
	list_citizens($agent_choice->description,$known_citizens);
	my $choice = get_user_input(0,scalar @{$known_citizens} - 1);
	return unless defined $choice;
	my $agent = $known_citizens->[$choice];
	$agent_choice->make_choice($agent);
}

sub make_choice {
	(my $game_state, my $player, my $choice) = @_;
	no warnings;
        for ($choice)
        {
            when (/1/) { pick_agent($game_state,$player)};
            when (/2/) { guess_double_agent($game_state,$player) };
            default           { say "No such option"  };
        }
	use warnings;
	return 0;

}

$logger->debug("Seed is: " . srand());

my $game_state = GameState->new();
my $citizen_generator = GameModule::GenerateCitizen->new(number_of_citizens => 13);
my $allegiance_generator = GameModule::GenerateAllegiance->new();
my $information_learn = GameModule::LearnInformation->new();
my $citizen_learn = GameModule::LearnCitizen->new();
my $agent_choice = GameModule::Agent->new();
my $event_generator = GameModule::EventGenerator->new(number_of_events_per_tick => 3);
my $double_agent_guess = GameModule::DoubleAgentGuess->new();

$game_state->add_game_module($citizen_generator);
$game_state->add_game_module($allegiance_generator);
$game_state->add_game_module($event_generator);
$game_state->add_game_module($information_learn);
$game_state->add_game_module($citizen_learn);
$game_state->add_game_module($agent_choice);
$game_state->add_game_module($double_agent_guess);

$game_state->add_player();
$game_state->add_player();

$game_state->setup();

while(! $game_state->ended ) {
	$game_state->tick();
	foreach my $player (@{$game_state->get_players}){
		say "Player: " . $player;
		if(my $agent = $player->agent() ){
			say "Agent:  $agent";
		}
		do {
			list_known_information($player);
			list_choices();
		}while(make_choice($game_state,$player,get_user_input(0,2)));
		say "";
		say "";
	}
	$game_state->clean_up();
}
say "Game over! These players had it right: ";
foreach my $player (@{$game_state->get_players}){
	if($player->winner()){
		say "Player: " . $player;
	}
}


