package GenerateAllegiance;
use Moose;
use Data::Dumper;
use namespace::autoclean;

extends 'GameModule';

my $logger = Log::Log4perl->get_logger('generateallegiance');

sub _generate_allegiances_round_robin {
	(my $self,my $game_state) = @_;
	my $allegiances = $game_state->get_allegiances();
	my $citizens = $game_state->get_citizens();

	while((my $pos, my $citizen) = each @$citizens){
		my $allegiance = @$allegiances[$pos % (scalar @$allegiances)];
		$game_state->add_allegiance($citizen,$allegiance);
	}

}


sub _add_double_agent {
	(my $self,my $game_state) = @_;

	my $allegiances = $game_state->get_allegiances();
	my $citizens = $game_state->get_citizens();
	
	my $random_citizen = @$citizens[int(rand(scalar @$citizens))];
	my $citizen_allegiances = $random_citizen->allegiances();

	die "$random_citizen should have exactly on allegiance" unless (scalar @{ $citizen_allegiances } == 1); 
	my $citizen_allegiance = $citizen_allegiances->[0];
	my @possible_new_allegiances = grep { $citizen_allegiance ne $_ } @$allegiances;
	my $new_allegiance =  @possible_new_allegiances[int(rand(scalar @possible_new_allegiances))];

	$game_state->add_allegiance($random_citizen,$new_allegiance);

	

}

override 'setup' => sub {
	(my $self, my $game_state) = @_;
	$logger->debug("Generating Allegiances");

	$self->_generate_allegiances_round_robin($game_state);
	$logger->debug("Generating Double Agent");
	$self->_add_double_agent($game_state);

}; 

__PACKAGE__->meta->make_immutable;
1;
