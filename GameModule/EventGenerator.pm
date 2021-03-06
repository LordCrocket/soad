package GameModule::EventGenerator;
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor;
use Readonly;
use List::MoreUtils qw(any);
extends 'GameModule';

my $logger = Log::Log4perl->get_logger('eventgenerator');

Readonly::Array1 my @event_titles => ("Informal dinner","Meeting at hotel");

has 'number_of_events_per_tick' => (is => 'ro', isa => 'Int', required => '1');

sub _got_same_allegiance {
	(my $citizen1, my $citizen2) = @_;
	foreach my $allegiance (@{$citizen1->allegiances}){
		return 1 if any { $_ eq $allegiance}(@{$citizen2->allegiances});
	}

}

sub _get_random_event_title {
	return $event_titles[rand(scalar @event_titles)];
}

sub _get_two_random_citizens {
	(my $self, my $citizens) = @_;
	my $number_of_citizens = scalar @{$citizens};

	if ($number_of_citizens < 2){
		die "Need at least two citizens to be able to generate an event";
	}	

	my $first_citizen = $citizens->[int(rand($number_of_citizens))];
	my $second_citizen;
	do {
		$second_citizen = $citizens->[int(rand(scalar @$citizens))];
	} while ($first_citizen eq $second_citizen || (! _got_same_allegiance($first_citizen,$second_citizen)));

	return ($first_citizen,$second_citizen);

}

sub _generate_event {
	(my $self, my $game_state) = @_;

	my $citizens = $game_state->get_citizens();	
	(my $citizen1, my $citizen2) = $self->_get_two_random_citizens($citizens);
	my $title = $self->_get_random_event_title(); 
	$game_state->add_event($title,[$citizen1,$citizen2]);

}

override 'update_game_state' => sub {
	(my $self, my $game_state) = @_;
	for(1..$self->number_of_events_per_tick) {
		$self->_generate_event($game_state);
	}
};

__PACKAGE__->meta->make_immutable;

1;
