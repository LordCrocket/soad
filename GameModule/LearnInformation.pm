package GameModule::LearnInformation;
use Moose;
use namespace::autoclean;

extends 'GameModule';
my $logger = Log::Log4perl->get_logger('learn');


sub _inclusive_int_rand {
	(my $self, my $range) = @_;
	return int(rand($range + 1));
}

sub _learn_if_noticed {
	(my $self,my $game_state,my $information) = @_;
	my $citizens = $game_state->get_citizens();
	my $number_of_citizens_learnt = 0;
	foreach my $citizen (@{$citizens}){
		my $min = $game_state->get_citizens_attribute_min();
		my $max = $game_state->get_citizens_attribute_max();
		my $attribute_span = $max - $min;
		my $value_needed = $self->_inclusive_int_rand($attribute_span) + $min;
		if ($citizen->social_life >= $value_needed){
			$number_of_citizens_learnt++;	
			$game_state->learn($citizen,$information);
		}
	}
	$logger->debug($number_of_citizens_learnt . "/" . scalar @{$citizens} . " learnt " . $information);
}

sub _add_new_information_to_citizens {
	(my $self,my $game_state) = @_;

	foreach my $information (@{$game_state->get_information}){
		if($information->is_new()){
			$self->_learn_if_noticed($game_state,$information);
		}
	}

}

override 'update_game_state' => sub {
	(my $self, my $game_state) = @_;
	$self->_add_new_information_to_citizens($game_state);
};

__PACKAGE__->meta->make_immutable;
1;
