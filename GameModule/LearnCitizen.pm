package GameModule::LearnCitizen;
use Moose;
use namespace::autoclean;
use List::Compare;
use Data::Dumper;
use Array::Utils qw (array_minus);

extends 'GameModule';
my $logger = Log::Log4perl->get_logger('learncitizen');

sub _randomize_new_citizen {
	(my $self, my $game_state, my $player, my $unknown_citizens) = @_;
	my $citizen = @$unknown_citizens[int(rand(scalar @$unknown_citizens))];
	$game_state->add_known_citizen($player,$citizen);

}

sub _add_known_citizen_to_player {
	(my $self, my $game_state, my $player) = @_;
	my $citizens = $game_state->get_citizens();
	my $known_citizens = $player->known_citizens();

	return if (scalar @{$known_citizens} >= scalar @{$citizens});
	my @complement =  array_minus(@$citizens,@$known_citizens);
	my $lc = List::Compare->new($known_citizens,$citizens);
	#$self->_randomize_new_citizen($game_state,$player,$lc->get_complement());
	#$self->_randomize_new_citizen($game_state,$player,$lc->get_complement_ref());
	$self->_randomize_new_citizen($game_state,$player,\@complement);

}

override 'update_game_state' => sub {
	(my $self, my $game_state) = @_;
	foreach my $player (@{$game_state->get_players()}){
		$self->_add_known_citizen_to_player($game_state,$player);
	}
};

__PACKAGE__->meta->make_immutable;
1;
