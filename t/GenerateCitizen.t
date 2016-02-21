use strict; 
use warnings;
use Test::More tests => 2;
use 5.18.0;


use GameModule::GenerateCitizen;
use GameState;
use GameState::Citizen;
use Log::Log4perl;
Log::Log4perl::init_and_watch('t/log4perl.conf',10);

sub generate_citizens {
	(my $citizen_generator,my $game_state) = @_;
	my @citizens = ();
	foreach my $citizen_hash (@{$citizen_generator->_generate_citizens($game_state)}){
		push(@citizens,GameState::Citizen->new($citizen_hash));	
	}
	return \@citizens;
		
}

sub same_seed_generation {
	my $seed = srand();
	my $game_state = GameState->new(); 

	my $first_citizen_generator = GameModule::GenerateCitizen->new(number_of_citizens => 1);

	my $citizensFirstRound = generate_citizens($first_citizen_generator,$game_state);
	my $citizen1 = $citizensFirstRound->[0];

	srand($seed);
	my $game_state2 = GameState->new(); 
	my $second_citizen_generator = GameModule::GenerateCitizen->new(number_of_citizens => 1);
	my $citizensSecondRound = generate_citizens($second_citizen_generator,$game_state2);
	my $citizen2 = $citizensSecondRound->[0];


	subtest 'Same seed generation' => sub {
		plan tests => 6;

		is($citizen1->name,$citizen2->name, "Check same name");
		is($citizen1->age,$citizen2->age, "Check same age");
		is($citizen1->occupation,$citizen2->occupation, "Check same occupation");
		is($citizen1->loyalty,$citizen2->loyalty, "Check same loyalty");
		is($citizen1->financial_status,$citizen2->financial_status, "Check same financial status");
		is($citizen1->social_life,$citizen2->social_life, "Check same social life");

	};

}

srand(); # Resetting seed

sub multiple_citizens_generators {

	my $game_state = GameState->new(); 
	my $first_citizen_generator = GameModule::GenerateCitizen->new(number_of_citizens => 5);
	my $second_citizen_generator = GameModule::GenerateCitizen->new(number_of_citizens => 5);
	my $citizens = generate_citizens($first_citizen_generator,$game_state);
	my $citizens2 = generate_citizens($second_citizen_generator,$game_state);

	subtest 'Check correct names with multiple citizens generator' => sub {
		is($citizens->[0]->name,'Hannelore Sabine','Hannelore Sabine');
		is($citizens2->[0]->name,'Hannelore Sabine','Hannelore Sabine');
		is($citizens->[1]->name,'Domenic Wilborn','Domenic Wilborn'); 
		is($citizens2->[1]->name,'Domenic Wilborn','Domenic Wilborn'); 
		is($citizens->[2]->name,'Kathie Lenard','Kathie Lenard'); 
		is($citizens2->[2]->name,'Kathie Lenard','Kathie Lenard'); 
		is($citizens->[3]->name,'Norris Kimbell','Norris Kimbell'); 
		is($citizens2->[3]->name,'Norris Kimbell','Norris Kimbell'); 
		is($citizens->[4]->name,'Donella Amar','Donella Amar'); 
		is($citizens2->[4]->name,'Donella Amar','Donella Amar'); 
	};
}
same_seed_generation();
multiple_citizens_generators();
